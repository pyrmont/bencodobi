(defn read-from-buffer
  [in-buf num-bytes out-buf start]
  (let [out-len (length out-buf)]
    (buffer/blit out-buf in-buf out-len start num-bytes)))


(defn read-from-file
  [file num-bytes buf]
  (file/read file num-bytes buf))


(defn read-from-string
  (str num-bytes buf start)
  (let [buf-len (length buf)]
    (buffer/blit buf (string/slice str start (+ start num-bytes)) buf-len)))


(def IOStream
  @{:source @""
    :curr 0
    :read (fn [self num-bytes buf]
            (if (> (+ num-bytes (self :curr)) (length (self :source)))
              (error "more bytes requested than in stream"))
            (case (type (self :source))
              :core/file
              (read-from-file (self :source) num-bytes buf)

              :buffer
              (read-from-buffer (self :source) num-bytes buf (self :curr))

              :string
              (read-from-string (self :source) num-bytes buf (self :curr))

              (break (:read (self :source) num-bytes buf)))
            (put self :curr (+ (self :curr) num-bytes))
            buf)})
