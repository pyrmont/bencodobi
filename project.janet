(declare-project
  :name "bencodobi"
  :description "A bencode library for Janet"
  :author "Michael Camilleri"
  :license "MIT"
  :url "https://github.com/pyrmont/bencodobi"
  :repo "git+https://github.com/pyrmont/bencodobi"
  :dependencies ["https://github.com/joy-framework/tester"])

(declare-source
  :source ["src/bencodobi src/bencodobi.janet"])
