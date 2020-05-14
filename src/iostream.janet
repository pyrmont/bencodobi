(def- error-message
  "more bytes requrested than in stream")


(defn- read-from-buffer
  ```
  Copy `num-bytes` from `in-buf` to `out-buf` beginning at `start`

  This function may return less than `num-bytes` if more bytes are requested
  than are left in the buffer.
  ```
  [in-buf num-bytes out-buf start]
  # (if (> (+ num-bytes start) (length in-buf))
  #   (error error-message))
  (let [in-len   (length in-buf)
        out-len  (length out-buf)
        copy-len (if (> (+ num-bytes start) in-len)
                   (- in-len start) num-bytes)]
    (buffer/blit out-buf in-buf out-len start copy-len)))


(defn- read-from-string
  ```
  Copy `num-bytes` from `str` to `buf` beginning at `start`

  This function may return less than `num-bytes` if more bytes are requested
  than are left in the string.
  ```
  [str num-bytes buf start]
  # (if (> (+ num-bytes start) (length str))
  #   (error error-message))
  (let [str-len  (length str)
        buf-len  (length buf)
        copy-len (if (> (+ num-bytes start) str-len)
                   (- str-len start) num-bytes)]
    (buffer/blit buf (string/slice str start (+ start copy-len)) buf-len)))


(def- IOStream
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


(defn stream
  [source]
  (table/setproto @{:source source} IOStream))
