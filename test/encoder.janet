(import testament :prefix "" :exit true)
(import ../src/bencodobi :as bencodobi)


(deftest encode-ascii-string
  (def output @"")
  (def val "spam")
  (bencodobi/encode output val)
  (is (= "4:spam" (string output))))


(deftest encode-utf8-string
  (def output @"")
  (def val "👍")
  (bencodobi/encode output val)
  (is (= "4:👍" (string output))))


(deftest encode-an-empty-buffer
  (def output @"")
  (def val @"")
  (bencodobi/encode output val)
  (is (= "0:" (string output))))


(deftest encode-a-nonempty-buffer
  (def output @"")
  (def val @"spam")
  (bencodobi/encode output val)
  (is (= "4:spam" (string output))))


(deftest encode-a-keyword
  (def output @"")
  (def val :spam)
  (bencodobi/encode output val)
  (is (= "4:spam" (string output))))


(deftest encode-a-symbol
  (def output @"")
  (def val 'spam)
  (bencodobi/encode output val)
  (is (= "4:spam" (string output))))


(deftest encode-integer
  (def output @"")
  (def val 42)
  (bencodobi/encode output val)
  (is (= "i42e" (string output))))


(deftest encode-negative-integer
  (def output @"")
  (def val -42)
  (bencodobi/encode output val)
  (is (= "i-42e" (string output))))


(deftest encode-negative-integer
  (def output @"")
  (def val -42)
  (bencodobi/encode output val)
  (is (= "i-42e" (string output))))


(deftest encode-negative-integer
  (def output @"")
  (def val -42)
  (bencodobi/encode output val)
  (is (= "i-42e" (string output))))


(deftest encode-an-empty-tuple
  (def output @"")
  (def val [])
  (bencodobi/encode output val)
  (is (= "le" (string output))))


(deftest encode-a-tuple
  (def output @"")
  (def val [1 "two" :three 'four])
  (bencodobi/encode output val)
  (is (= "li1e3:two5:three4:foure" (string output))))


(deftest encode-a-nested-tuple
  (def output @"")
  (def val [1 [2 "two"] [3 "three" :three]])
  (bencodobi/encode output val)
  (is (= "li1eli2e3:twoeli3e5:three5:threeee" (string output))))


(deftest encode-an-empty-array
  (def output @"")
  (def val @[])
  (bencodobi/encode output val)
  (is (= "le" (string output))))


(deftest encode-a-nonempty-array
  (def output @"")
  (def val @[1 "two" :three 'four])
  (bencodobi/encode output val)
  (is (= "li1e3:two5:three4:foure" (string output))))


(deftest encode-an-empty-struct
  (def output @"")
  (def val {})
  (bencodobi/encode output val)
  (is (= "de" (string output))))


(deftest encode-a-struct
  (def output @"")
  (def val {"one" 1 "two" 2 "three" 3})
  (bencodobi/encode output val)
  (is (= "d3:onei1e5:threei3e3:twoi2ee" (string output))))


(deftest encode-a-nested-struct
  (def output @"")
  (def val {"one" [1] "two" [1 2] "three" [1 2 3]})
  (bencodobi/encode output val)
  (is (= "d3:oneli1ee5:threeli1ei2ei3ee3:twoli1ei2eee" (string output))))


(deftest encode-an-empty-table
  (def output @"")
  (def val @{})
  (bencodobi/encode output val)
  (is (= "de" (string output))))


(deftest encode-an-nonempty-table
  (def output @"")
  (def val @{"one" 1})
  (bencodobi/encode output val)
  (is (= "d3:onei1ee" (string output))))


(deftest encode-a-decimal
  (def output @"")
  (def val 3.14)
  (def message "invalid input: 3.14 is unsupported type")
  (is (thrown? message (bencodobi/encode output val))))


(deftest encode-a-struct-with-nonstring-keys
  (def output @"")
  (def val {1 "one" 2 "two" 3 "three"})
  (def message "invalid input: {3 \"three\" 2 \"two\" 1 \"one\"} is unsupported type")
  (is (thrown? message (bencodobi/encode output val))))


(run-tests!)
