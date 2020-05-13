(declare-project
  :name "Bencodobi"
  :description "A bencode library for Janet"
  :author "Michael Camilleri"
  :license "MIT"
  :url "https://github.com/pyrmont/bencodobi"
  :repo "git+https://github.com/pyrmont/bencodobi"
  :dependencies ["https://github.com/pyrmont/testament"])

(declare-source
  :source ["src/bencodobi" "src/bencodobi.janet"])
