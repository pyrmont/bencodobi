(def- error-message
  "more bytes requrested than in stream")


(defn- read-from-buffer
  ```
  Copy `num-bytes` from `in-buf` to `out-buf` beginning at `start`

  This function may return less than `num-bytes` if more bytes are requested
  than are left in the buffer.
  ```
  [in-buf num-bytes out-buf start]
  (let [in-len  (length in-buf)
        out-len (length out-buf)
        end     (if (> (+ num-bytes start) in-len)
                   (- in-len start) (+ num-bytes start))]
    (buffer/blit out-buf in-buf out-len start end)))


(defn- read-from-string
  ```
  Copy `num-bytes` from `str` to `buf` beginning at `start`

  This function may return less than `num-bytes` if more bytes are requested
  than are left in the string.
  ```
  [str num-bytes buf start]
  (let [str-len (length str)
        buf-len (length buf)
        end     (if (> (+ num-bytes start) str-len)
                  (- str-len start) (+ num-bytes start))]
    (buffer/blit buf (string/slice str start end) buf-len)))


(def- IOReader
  @{:source @""
    :curr 0
    :read (fn [self num-bytes buf]
            (case (type (self :source))
              :buffer
              (read-from-buffer (self :source) num-bytes buf (self :curr))

              :string
              (read-from-string (self :source) num-bytes buf (self :curr))

              (break (:read (self :source) num-bytes buf)))
            (put self :curr (+ (self :curr) num-bytes))
            buf)})


(defn reader
  ```
  Wrap `source` in an `IOReader` unless it is already wrapped

  The IOReader prototype is a stream reading abstraction that allows objects
  to respond to a `:read` function call"
  ```
  [source]
  (if (and (= :table (type source)) (= IOReader (table/getproto source)))
    source
    (table/setproto @{:source source} IOReader)))
