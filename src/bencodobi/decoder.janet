(def single (buffer/new 1))
(def multi (buffer/new 1))


# Forward declaration
(varfn decode [stream &opt indicator])


(defn- read-byte
  "Read a single byte from `stream`"
  [stream]
  (buffer/clear single)
  (-> (:read stream 1 single) (get 0)))


(defn- read-bytes
  "Read `n` bytes from `stream`"
  [stream n]
  (buffer/clear multi)
  (-> (:read stream n multi) (string)))


(defn- to-digit
  "Convert `b`, the integer value of a UTF-8 character, into a digit from 0-9"
  [b]
  (- b 48))


(defn- is-minus?
  "Check whether `b`, the integer value of a UTF-8 character, represents the
  minus character"
  [b]
  (= b 45))


(defn- is-num?
  "Check whether `b`, the integer value of a UTF-8 character, represents a
  digit from 0-9"
  [b]
  (and (>= b 48) (<= b 57)))


(defn- is-char?
  "Check whether `b`, the integer value of a UTF-8 character, is equal to a
  character `c`"
  [c b]
  (-> (string/bytes c) (first) (= b)))


(defn- decode-str
  "Decode a string from a bytestream `stream` of length `len`"
  [stream len]
  (string (read-bytes stream len)))


(defn- decode-nums
  "Decode a number from a bytestream `stream` until an `ending`

  Integers are used in two ways in Bencode: (1) the beginning of strings; and
  (2) in integer values. The two ways correspond to the endings `:` and `e`
  respectively. The function is called recursively and so can pass an optional
  `total` that represents the current total."
  [stream ending &opt total]
  (default total 0)
  (let [byte (read-byte stream)]
    (cond
      (is-char? ending byte) total
      (is-num? byte)         (decode-nums stream
                                          ending
                                          (+ (* total 10) (to-digit byte)))
      (error "invalid bencoding: number"))))


(defn- decode-int
  "Decode an integer from a bytestream `stream`"
  [stream]
  (let [byte (read-byte stream)]
    (cond
      (is-minus? byte) (* -1 (decode-nums stream "e"))
      (is-num? byte) (decode-nums stream "e" (to-digit byte)))))


(defn- decode-list
  "Decode a list from a bytestream `stream`

  This function is called recursively and so can pass an optional `items` that
  represents the current list of items."
  [stream &opt items]
  (default items [])
  (let [byte (read-byte stream)]
    (cond
      (is-char? "e" byte) items
      (decode-list stream (tuple (splice items) (decode stream byte))))))


(defn- decode-key
  "Decode a dictionary key from a bytestream `stream` with initial `byte`

  This function passes the `byte` so that it can test whether the key is valid."
  [stream byte]
  (cond
    (is-num? byte) (->> (decode-nums stream ":" (to-digit byte))
                        (decode-str stream))
    (error "invalid bencoding: dictionary key")))


(defn- decode-dict
  "Decode a dictionary from a bytestream `stream`

  This function is called recursively and so can pass an optional `items` that
  represents the pairs of keys and values. The struct result is not created
  until the end of the decoding."
  [stream &opt items]
  (default items [])
  (let [byte (read-byte stream)]
    (cond
      (is-char? "e" byte) (struct (splice items))
      (decode-dict stream (tuple (splice items) (decode-key stream byte) (decode stream))))))


(varfn decode
  "Decode a bytestream `stream`

  This function is possibly called by the list and dictionary decoding functions
  and so can be passed an initial `indicator`."
  [stream &opt indicator]
  (let [byte (or indicator (read-byte stream))]
    (cond
      (is-num? byte)      (->> (decode-nums stream ":" (to-digit byte))
                               (decode-str stream))
      (is-char? "i" byte) (decode-int stream)
      (is-char? "l" byte) (decode-list stream)
      (is-char? "d" byte) (decode-dict stream)
      (error "invalid bencoding: general"))))
