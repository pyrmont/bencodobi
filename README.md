# Bencodobi

[![Build Status](https://github.com/pyrmont/bencodobi/workflows/build/badge.svg)](https://github.com/pyrmont/bencodobi/actions?query=workflow%3Abuild)

Bencodobi is a bencode encoding and decoding library for Janet.

## Installation

Add the dependency to your `project.janet` file:

```clojure
(declare-project
  :dependencies ["https://github.com/pyrmont/bencodobi"])
```

## Usage

Bencodobi can be used like this:

```
(import bencodobi)

(def output @"")

(bencodobi/encode output "hello world")

(print output) # => "11:hello world"

(bencodobi/decode "13:goodbye world") # => "goodbye world"
```

## API

Documentation for Bencodobi's API is in [api.md][api].

[api]: https://github.com/pyrmont/bencodobi/blob/master/api.md

## Bugs

Found a bug? I'd love to know about it. The best way is to report your bug in
the [Issues][] section on GitHub.

[Issues]: https://github.com/pyrmont/bencodobi/issues

## Licence

Bencodobi is licensed under the MIT Licence. See [LICENSE][] for more details.

[LICENSE]: https://github.com/pyrmont/bencodobi/blob/master/LICENSE
