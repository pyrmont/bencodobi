(import testament :prefix "" :exit true)
(import ../src/iostream :as io)


(deftest forget-reader
  (def output @"")
  (def input @"hello")
  (is (thrown? (:read input 1 output)) "forget to create a reader from a buffer"))


(deftest read-file
  (def file (file/temp))
  (file/write file "hello")
  (file/seek file :set 0)
  (def output @"")
  (def input (io/reader file))
  (:read input 1 output)
  (file/close file)
  (is (= "h" (string output)) "read from a file"))


(deftest read-buffer
  (def output @"")
  (def input (io/reader @"hello"))
  (:read input 1 output)
  (is (= "h" (string output)) "read first byte from a buffer"))


(deftest read-string
  (def output @"")
  (def input (io/reader "hello"))
  (:read input 1 output)
  (is (= "h" (string output)) "read first byte from a string"))


(deftest read-too-much
  (def output @"")
  (def input (io/reader "hello"))
  (:read input 6 output)
  (is (= "hello" (string output)) "read more than in reader"))


(deftest forget-writer
  (def output @"")
  (def input @"hello")
  (is (thrown? (:write output input)) "forget to create a reader from a buffer"))


(deftest write-file
  (def file (file/temp))
  (def output (io/writer file))
  (:write output "hello")
  (file/seek file :set 0)
  (def content (file/read file :all))
  (file/close file)
  (is (= "hello" (string content)) "read from a file"))


(deftest write-buffer
  (def buf @"")
  (def output (io/writer buf))
  (:write output "hello")
  (is (= "hello" (string buf)) "read first byte from a buffer"))


(run-tests!)
