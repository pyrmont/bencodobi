# Forward declaration
(varfn decode [stream &opt indicator])


(defn- to-digit [b]
  "Convert `b`, the integer value of a UTF-8 character, into a digit from 0-9"
  (- b 48))


(defn- is-num? [b]
  "Check whether `b`, the integer value of a UTF-8 character, represents a
  digit from 0-9"
  (and (>= b 48) (<= b 57)))


(defn- is-char? [c b]
  "Check whether `b`, the integer value of a UTF-8 character, is equal to a
  character `c`"
  (-> (string/bytes c) (first) (= b)))


(defn- decode-str [stream len]
  "Decode a string from a bytestream `stream` of length `len`"
  (string/from-bytes (splice (:read stream len))))


(defn- decode-nums [stream ending &opt total]
  "Decode a number from a bytestream `stream` until an `ending`

  Integers are used in two ways in Bencode: (1) the beginning of strings; and
  (2) in integer values. The two ways correspond to the endings `:` and `e`
  respectively. The function is called recursively and so can pass an optional
  `total` that represents the current total."
  (default total 0)
  (let [byte (first (:read stream 1))]
    (cond
      (is-char? ending byte) total
      (is-num? byte)         (decode-nums stream
                                          ending
                                          (+ (* total 10) (to-digit byte)))
      (error "invalid bencoding: number"))))


(defn- decode-list [stream &opt items]
  "Decode a list from a bytestream `stream`

  This function is called recursively and so can pass an optional `items` that
  represents the current list of items."
  (default items [])
  (let [byte (first (:read stream 1))]
    (cond
      (is-char? "e" byte) items
      (decode-list stream (tuple (splice items) (decode stream byte))))))


(defn- decode-key [stream byte]
  "Decode a dictionary key from a bytestream `stream` with initial `byte`

  This function passes the `byte` so that it can test whether the key is valid."
  (cond
    (is-num? byte) (->> (decode-nums stream ":" (to-digit byte))
                        (decode-str stream))
    (error "invalid bencoding: dictionary key")))


(defn- decode-dict [stream &opt items]
  "Decode a dictionary from a bytestream `stream`

  This function is called recursively and so can pass an optional `items` that
  represents the pairs of keys and values. The struct result is not created
  until the end of the decoding."
  (default items [])
  (let [byte (first (:read stream 1))]
    (cond
      (is-char? "e" byte) (struct (splice items))
      (decode-dict stream (tuple (splice items) (decode-key stream byte) (decode stream))))))


(varfn decode [stream &opt indicator]
  "Decode a bytestream `stream`

  This function is possibly called by the list and dictionary decoding functions
  and so can be passed an initial `indicator`."
  (let [byte (or indicator (first (:read stream 1)))]
    (cond
      (is-num? byte)      (->> (decode-nums stream ":" (to-digit byte))
                               (decode-str stream))
      (is-char? "i" byte) (decode-nums stream "e")
      (is-char? "l" byte) (decode-list stream)
      (is-char? "d" byte) (decode-dict stream)
      (error "invalid bencoding: general"))))
