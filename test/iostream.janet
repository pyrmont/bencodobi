(import testament :prefix "" :exit true)
(import ../src/iostream :as io)


(deftest forget-stream
  (def output @"")
  (def input @"hello")
  (is (thrown? (:read input 1 output)) "forget to create a stream from a buffer"))


(deftest read-file
  (def file (file/temp))
  (file/write file "hello")
  (file/seek file :set 0)
  (def output @"")
  (def input (io/stream file))
  (:read input 1 output)
  (file/close file)
  (is (= "h" (string output)) "read from a file"))


(deftest read-buffer
  (def output @"")
  (def input (io/stream @"hello"))
  (:read input 1 output)
  (is (= "h" (string output)) "read first byte from a buffer"))


(deftest read-string
  (def output @"")
  (def input (io/stream "hello"))
  (:read input 1 output)
  (is (= "h" (string output)) "read first byte from a string"))


(deftest read-too-much
  (def output @"")
  (def input (io/stream "hello"))
  (:read input 6 output)
  (is (= "hello" (string output)) "read more than in stream"))


(run-tests!)
