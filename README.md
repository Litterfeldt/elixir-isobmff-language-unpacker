# ISOBMFF Language Unpacker
ISO based media file format derived formats such as Apples MOV and MPEG's MP4 pack language infromation in 16bit binaries.
How these language codes are packed varies though from format to format, Apple has a table of QuickTime language codes that
they enforce in the MOV format while MP4 uses a technique of packing 3 character ISO 639-2/T language codes into 3 unsigned
5 bit integers that they then shift and add.

Sounds complicated? You would be right, this hex is meant to abstract away the complexity and get right down to business.

At your disposal you have several convenience functions, they all do the same thing but take different types of input.
If you have the language int packed as a 16 bit bitstring straight from a MP4 container use `#int16_to_lang`, if you've unpacked
it to a Elixir integer use `#int_to_lang` or if you are presented with the raw 15 bit bitstring use `#int15_to_lang`.
You get the picture, the result will always be the same.


## Documentation
https://hexdocs.pm/isobmff_lang/0.1.0/ISOBMFFLang.html#content

## Examples
```elixir
# QuickTime language code value for swedish (MOV container)
iex> ISOBMFFLang.int_to_lang(5)
{:ok, "swe"}

# Packed ISO Language Code for undefined language (MP4 container)
iex> ISOBMFFLang.int16_to_lang(<<0::1, 21956::15>>)
{:ok, "und"}
```

## Installation
See [package info on hex.pm](https://hex.pm/packages/isobmff_lang)

The package can be installed by adding `:isobmff_lang` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:isobmff_lang, "~> 0.1.0"}]
end
```

## Testing

The project is bundled with doctests, to run them simply:

```
mix test
```

### References:
- [Quicktime language codes](https://developer.apple.com/library/content/documentation/QuickTime/QTFF/QTFFChap4/qtff4.html#//apple_ref/doc/uid/TP40000939-CH206-34353)
- [ISO language code packing](https://developer.apple.com/library/content/documentation/QuickTime/QTFF/QTFFChap4/qtff4.html#//apple_ref/doc/uid/TP40000939-CH206-35133)
