(import testament :prefix "" :exit true)
(import ../src/iostream :as iostream)


(defn stream [source]
  (table/setproto @{:source source} iostream/IOStream))


(deftest read-buffer
  (def output @"")
  (def input (stream @"hello"))
  (:read input 1 output)
  (is (= "h" (string output)) "read first byte from a buffer"))


(deftest read-string
  (def output @"")
  (def input (stream "hello"))
  (:read input 1 output)
  (is (= "h" (string output)) "read first byte from a string"))


(deftest read-too-much
  (def output @"")
  (def input (stream "hello"))
  (is (thrown? (:read input 6 output)) "read more than in stream"))


(run-tests!)
