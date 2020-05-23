(import ../iostream :as io)


# Forward declaration
(varfn encode [stream val])


(defn- write-string
  ```
  Write `str` to `stream`
  ```
  [stream str]
  (:write stream str))


(defn- is-num?
  ```
  Check whether the value is an integer

  Note that this will treat a number as an integer if it can be expressed as an
  integer (e.g. `(int? 2.0)` will evaluate to `true`.
  ```
  [val]
  (int? val))


(defn- is-str?
  ```
  Check whether `val` is a string

  In addition to strings this will return `true` for buffers, keywords and
  symbols.
  ```
  [val]
  (case (type val)
    :string true
    :buffer true
    :keyword true
    :symbol true
    false))


(defn- is-list?
  ```
  Check whether `val` is an indexed data structure
  ```
  [val]
  (indexed? val))


(defn- is-dict?
  ```
  Check whether `val` is a dictionary data structure

  This will return `false` if the keys at the top level of the dictionary are
  not string-like values (i.e. strings, buffers, keywords or symbols).
  ```
  [val]
  (and (dictionary? val)
       (all is-str? (keys val))))


(defn- encode-num
  ```
  Encode `num` and write it to `stream`
  ```
  [stream num]
  (->> (string/format "i%de" num)
       (write-string stream)))


(defn- encode-str
  ```
  Encode `str` and write it to `stream`
  ```
  [stream str]
  (->> (string str)
       (string/format "%d:%s" (length str))
       (write-string stream)))


(defn- encode-list
  ```
  Encode `list` and write it to `stream`
  ```
  [stream list]
  (write-string stream "l")
  (each item list
    (encode stream item))
  (write-string stream "e"))


(defn- encode-dict
  ```
  Encode `dict` and write it to `stream`
  ```
  [stream dict]
  (write-string stream "d")
  (each k (sort (keys dict))
    (encode stream k)
    (encode stream (get dict k)))
  (write-string stream "e"))


(varfn encode
  ```
  Encode `val` and write it to `output`

  This function will throw an error if `val` is not a valid value for bencoding.
  ```
  [output val]
  (let [stream  (io/writer output)
        encoder (cond
                  (is-num? val)  encode-num
                  (is-str? val)  encode-str
                  (is-list? val) encode-list
                  (is-dict? val) encode-dict
                  (error (string/format "invalid input: %q is unsupported type" val)))]
    (encoder stream val)))
