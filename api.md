# Bencodobi API

[bencodobi/decode](#bencodobidecode)
, [bencodobi/encode](#bencodobiencode)
, [iostream/reader](#iostreamreader)
, [iostream/writer](#iostreamwriter)

## bencodobi/decode

**function**  | [source][1]

```janet
(decode input &opt indicator)
```

Decode `input`

This function is possibly called by the list and dictionary decoding functions
and so can be passed an initial `indicator`.

[1]: src/bencodobi/decoder.janet#L132

## bencodobi/encode

**function**  | [source][2]

```janet
(encode output val)
```

Encode `val` and write it to `output`

This function will throw an error if `val` is not a valid value for bencoding.

[2]: src/bencodobi/encoder.janet#L105

## iostream/reader

**function**  | [source][3]

```janet
(reader source)
```

Wrap `source` in an `IOReader` unless it is already wrapped

The IOReader prototype is a stream reading abstraction that allows objects
to respond to a `:read` function call.

[3]: src/iostream.janet#L51

## iostream/writer

**function**  | [source][4]

```janet
(writer dest)
```

Wrap `dest` in an `IOWriter` unless it is already wrapped

The IOWriter prototype is a stream writing abstraction that allows objects
to respond to a `:write` function call.

[4]: src/iostream.janet#L83

