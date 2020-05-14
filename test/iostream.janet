(import testament :prefix "" :exit true)
(import ../src/iostream :as iostream)

(defn stream [source]
  (table/setproto @{:source source} iostream/IOStream))

(deftest read-buffer
  (def output @"")
  (def input (stream @"hello"))
  (:read input 1 output)
  (is (= "h" (string output))))

(run-tests!)
