(defn to-digit [b]
  (- b 48))


(defn is-num? [b]
  (and (>= b 48) (<= b 57)))


(defn is-char? [c b]
  (-> (string/bytes c) (first) (= b)))


# Forward declaration
(varfn decode [stream &opt indicator])


(defn decode-str [stream len]
  (string/from-bytes (splice (:read stream len))))


(defn decode-nums [stream ending &opt total]
  (default total 0)
  (let [byte (first (:read stream 1))]
    (cond
      (is-char? ending byte) total
      (is-num? byte)         (decode-nums stream
                                          ending
                                          (+ (* total 10) (to-digit byte)))
      (error "invalid bencoding"))))


(defn decode-list [stream &opt items]
  (default items [])
  (let [byte (first (:read stream 1))]
    (cond
      (is-char? "e" byte) items
      (decode-list stream (tuple (splice items) (decode stream byte))))))


(defn decode-key [stream byte]
  (cond
    (is-num? byte) (->> (decode-nums stream ":" (to-digit byte))
                        (decode-str stream))
    (error "invalid bencoding")))


(defn decode-dict [stream &opt items]
  (default items [])
  (let [byte (first (:read stream 1))]
    (cond
      (is-char? "e" byte) (struct (splice items))
      (decode-dict stream (tuple (splice items) (decode-key stream byte) (decode stream))))))


(varfn decode [stream &opt indicator]
  (let [byte (or indicator (first (:read stream 1)))]
    (cond
      (is-num? byte)      (->> (decode-nums stream ":" (to-digit byte))
                               (decode-str stream))
      (is-char? "i" byte) (decode-nums stream "e")
      (is-char? "l" byte) (decode-list stream)
      (is-char? "d" byte) (decode-dict stream)
      (error "invalid bencoding"))))


(def Stream
  @{:content ""
    :read (fn [self num_bytes]
            (let [res (string/slice (self :content) 0 num_bytes)]
              (put self :content (string/slice (self :content) num_bytes))
              (string/bytes res)))})


(def an-ascii-str
  (table/setproto @{:content "4:spam"} Stream))


(def a-utf8-str
  (table/setproto @{:content "4:👍"} Stream))


(def an-int
  (table/setproto @{:content "i42e"} Stream))


(def an-empty-list
  (table/setproto @{:content "le"} Stream))


(def a-list
  (table/setproto @{:content "l4:spami42ee"} Stream))


(def an-empty-dict
  (table/setproto @{:content "de"} Stream))


(def a-dict
  (table/setproto @{:content "d3:cow3:moo4:spam4:eggse"} Stream))


(def a-nested-coll
  (table/setproto @{:content "d4:spaml1:a1:bee"} Stream))


(pp (decode an-ascii-str))
(pp (decode a-utf8-str))
(pp (decode an-int))
(pp (decode an-empty-list))
(pp (decode a-list))
(pp (decode an-empty-dict))
(pp (decode a-dict))
(pp (decode a-nested-coll))
