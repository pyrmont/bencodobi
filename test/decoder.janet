(import testament :prefix "" :exit true)
(import ../src/bencodobi :as bencodobi)


(def- Stream
  @{:content @""
    :read (fn [self num_bytes buf]
            (let [taken (buffer/slice (self :content) 0 num_bytes)
                  left  (buffer/slice (self :content) num_bytes)]
              (put self :content left)
              (buffer/push-string buf (string taken))))})


(deftest decode-ascii-string
  (def an-ascii-str (table/setproto @{:content @"4:spam"} Stream))
  (is (= "spam" (bencodobi/decode an-ascii-str)) "decode an ASCII string"))


(deftest decode-utf8-string
  (def a-utf8-str (table/setproto @{:content @"4:👍"} Stream))
  (is (= "👍" (bencodobi/decode a-utf8-str)) "decode a UTF-8 string"))


(deftest decode-integer
  (def an-int (table/setproto @{:content @"i42e"} Stream))
  (is (= 42 (bencodobi/decode an-int)) "decode an integer"))


(deftest decode-negative-integer
  (def an-int (table/setproto @{:content @"i-42e"} Stream))
  (is (= -42 (bencodobi/decode an-int)) "decode a negative integer"))


(deftest decode-empty-list
  (def an-empty-list (table/setproto @{:content @"le"} Stream))
  (is (= [] (bencodobi/decode an-empty-list)) "decode an empty list"))


(deftest decode-list
  (def a-list (table/setproto @{:content @"l4:spami42ee"} Stream))
  (is (= ["spam" 42] (bencodobi/decode a-list)) "decode a list"))


(deftest decode-empty-dict
  (def an-empty-dict (table/setproto @{:content @"de"} Stream))
  (is (= {} (bencodobi/decode an-empty-dict)) "decode an empty dictionary"))


(deftest decode-dict
 (def a-dict (table/setproto @{:content @"d3:cow3:moo4:spam4:eggse"} Stream))
 (is (= {"cow" "moo" "spam" "eggs"} (bencodobi/decode a-dict)) "decode a dictionary"))


(deftest decode-nested-coll
 (def a-nested-coll (table/setproto @{:content @"d4:spaml1:a1:bee"} Stream))
 (is (= {"spam" ["a" "b"]} (bencodobi/decode a-nested-coll)) "decode a nested collection"))


(run-tests!)
