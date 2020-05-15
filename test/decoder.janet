(import testament :prefix "" :exit true)
(import ../src/bencodobi :as bencodobi)


(deftest decode-ascii-string
  (def an-ascii-str @"4:spam")
  (is (= "spam" (bencodobi/decode an-ascii-str)) "decode an ASCII string"))


(deftest decode-utf8-string
  (def a-utf8-str @"4:👍")
  (is (= "👍" (bencodobi/decode a-utf8-str)) "decode a UTF-8 string"))


(deftest decode-integer
  (def an-int @"i42e")
  (is (= 42 (bencodobi/decode an-int)) "decode an integer"))


(deftest decode-negative-integer
  (def an-int @"i-42e")
  (is (= -42 (bencodobi/decode an-int)) "decode a negative integer"))


(deftest decode-empty-list
  (def an-empty-list @"le")
  (is (= [] (bencodobi/decode an-empty-list)) "decode an empty list"))


(deftest decode-list
  (def a-list @"l4:spami42ee")
  (is (= ["spam" 42] (bencodobi/decode a-list)) "decode a list"))


(deftest decode-empty-dict
  (def an-empty-dict @"de")
  (is (= {} (bencodobi/decode an-empty-dict)) "decode an empty dictionary"))


(deftest decode-dict
 (def a-dict @"d3:cow3:moo4:spam4:eggse")
 (is (= {"cow" "moo" "spam" "eggs"} (bencodobi/decode a-dict)) "decode a dictionary"))


(deftest decode-nested-coll
 (def a-nested-coll @"d4:spaml1:a1:bee")
 (is (= {"spam" ["a" "b"]} (bencodobi/decode a-nested-coll)) "decode a nested collection"))


(run-tests!)
