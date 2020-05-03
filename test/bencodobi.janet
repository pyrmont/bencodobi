(import tester :prefix "" :exit true)
(import "../bencodobi" :as bencodobi)

(deftest


  (def Stream
    @{:content ""
      :read (fn [self num_bytes]
              (let [res (string/slice (self :content) 0 num_bytes)]
                (put self :content (string/slice (self :content) num_bytes))
                (string/bytes res)))})


  (test "decode an ASCII string"
        (do
          (def an-ascii-str (table/setproto @{:content "4:spam"} Stream))
          (= "spam"
             (bencodobi/decode an-ascii-str))))


  (test "decode a UTF-8 string"
        (do
          (def a-utf8-str (table/setproto @{:content "4:👍"} Stream))
          (= "👍"
             (bencodobi/decode a-utf8-str))))


  (test "decode an integer"
        (do
          (def an-int (table/setproto @{:content "i42e"} Stream))
          (= 42
             (bencodobi/decode an-int))))


  (test "decode an empty list"
        (do
          (def an-empty-list (table/setproto @{:content "le"} Stream))
          (= []
             (bencodobi/decode an-empty-list))))


  (test "decode a list"
        (do
          (def a-list (table/setproto @{:content "l4:spami42ee"} Stream))
          (= ["spam" 42]
             (bencodobi/decode a-list))))


  (test "decode an empty dictionary"
        (do
          (def an-empty-dict (table/setproto @{:content "de"} Stream))
          (= {}
             (bencodobi/decode an-empty-dict))))


  (test "decode a dictionary"
        (do
          (def a-dict (table/setproto @{:content "d3:cow3:moo4:spam4:eggse"} Stream))
          (= {"cow" "moo" "spam" "eggs"}
             (bencodobi/decode a-dict))))


  (test "decode a nested collection"
        (do
          (def a-nested-coll (table/setproto @{:content "d4:spaml1:a1:bee"} Stream))
          (= {"spam" ["a" "b"]}))))

