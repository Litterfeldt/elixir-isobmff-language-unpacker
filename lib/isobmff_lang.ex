defmodule ISOBMFFLang do
  @moduledoc """
  ISO based media file format derived formats such as Apples MOV and MPEG's MP4 pack language infromation in 16bit binaries.
  How these language codes are packed varies though from format to format, Apple has a table of QuickTime language codes that
  they enforce in the MOV format while MP4 uses a technique of packing 3 character ISO 639-2/T language codes into 3 unsigned
  5 bit integers that they then shift and add.

  Sounds complicated? You would be right, this hex is meant to abstract away the complexity and get right down to business.

  At your disposal you have several convenience functions, they all do the same thing but take different types of input.
  If you have the language int packed as a 16 bit bitstring straight from a MP4 container use `#int16_to_lang`, if you've unpacked
  it to a Elixir integer use `#int_to_lang` or if you are presented with the raw 15 bit bitstring use `#int15_to_lang`.
  You get the picture the result will always be the same.

  ## Examples

      # QuickTime language code value for swedish (MOV container)
      iex> ISOBMFFLang.int_to_lang(5)
      {:ok, "swe"}

      # Packed ISO Language Code for undefined language (MP4 container)
      iex> ISOBMFFLang.int16_to_lang(<<0::1, 21956::15>>)
      {:ok, "und"}

  """

  # Quicktime language codes as per Table 5-1
  # https://developer.apple.com/library/content/documentation/QuickTime/QTFF/QTFFChap4/qtff4.html#//apple_ref/doc/uid/TP40000939-CH206-34353
  @quicktime_language_codes %{
    eng: 000, # English
    fre: 001, # French
    deu: 002, # German
    ita: 003, # Italian
    nld: 004, # Dutch
    swe: 005, # Swedish
    spa: 006, # Spanish
    dan: 007, # Danish
    por: 008, # Portuguese
    nor: 009, # Norwegian
    heb: 010, # Hebrew
    jpn: 011, # Japanese
    ara: 012, # Arabic
    fin: 013, # Finnish
    ell: 014, # Greek
    isl: 015, # Icelandic
    mlt: 016, # Maltese
    tur: 017, # Turkish
    hrv: 018, # Croatian
    zho: 019, # Traditional Chinese (ISO 639-2 can't express script differences, so zho)
    urd: 020, # Urdu
    hin: 021, # Hindi
    tha: 022, # Thai
    kor: 023, # Korean
    lit: 024, # Lithuanian
    pol: 025, # Polish
    hun: 026, # Hungarian
    est: 027, # Estonian
    lav: 028, # Latvian / Lettish
    sme: 029, # Lappish / Saamish (used code for Nothern Sami)
    fao: 030, # Faeroese
    fas: 031, # Farsi
    rus: 032, # Russian
    zho: 033, # Simplified Chinese (ISO 639-2 can't express script differences, so zho)
    nld: 034, # Flemish (no ISO 639-2 code, used Dutch code)
    gle: 035, # Irish
    sqi: 036, # Albanian
    ron: 037, # Romanian
    ces: 038, # Czech
    slk: 039, # Slovak
    slv: 040, # Slovenian
    yid: 041, # Yiddish
    srp: 042, # Serbian
    mkd: 043, # Macedonian
    bul: 044, # Bulgarian
    ukr: 045, # Ukrainian
    bel: 046, # Byelorussian
    uzb: 047, # Uzbek
    kaz: 048, # Kazakh
    aze: 049, # Azerbaijani
    aze: 050, # AzerbaijanAr (presumably script difference? used aze here)
    hye: 051, # Armenian
    kat: 052, # Georgian
    mol: 053, # Moldavian
    kir: 054, # Kirghiz
    tgk: 055, # Tajiki
    tuk: 056, # Turkmen
    mon: 057, # Mongolian
    mon: 058, # MongolianCyr (presumably script difference? used mon here)
    pus: 059, # Pashto
    kur: 060, # Kurdish
    kas: 061, # Kashmiri
    snd: 062, # Sindhi
    bod: 063, # Tibetan
    nep: 064, # Nepali
    san: 065, # Sanskrit
    mar: 066, # Marathi
    ben: 067, # Bengali
    asm: 068, # Assamese
    guj: 069, # Gujarati
    pan: 070, # Punjabi
    ori: 071, # Oriya
    mal: 072, # Malayalam
    kan: 073, # Kannada
    tam: 074, # Tamil
    tel: 075, # Telugu
    sin: 076, # Sinhalese
    mya: 077, # Burmese
    khm: 078, # Khmer
    lao: 079, # Lao
    vie: 080, # Vietnamese
    ind: 081, # Indonesian
    tgl: 082, # Tagalog
    msa: 083, # MalayRoman
    msa: 084, # MalayArabic
    amh: 085, # Amharic
    orm: 087, # Galla (same as Oromo?)
    orm: 087, # Oromo
    som: 088, # Somali
    swa: 089, # Swahili
    kin: 090, # Ruanda
    run: 091, # Rundi
    nya: 092, # Chewa
    mlg: 093, # Malagasy
    epo: 094, # Esperanto
    cym: 128, # Welsh
    eus: 129, # Basque
    cat: 130, # Catalan
    lat: 131, # Latin
    que: 132, # Quechua
    grn: 133, # Guarani
    aym: 134, # Aymara
    tat: 135, # Tatar
    uig: 136, # Uighur
    dzo: 137, # Dzongkha
    jav: 138, # JavaneseRom
    und: 32767, # Unspecified,
  }

  @doc """
  Converts a 15 bit ISOBMFF integer language representation into ISO 639-2 language code.

  Returns an error if integer value is not within range for a uint15

  ## Examples

      # QuickTime language code value for swedish (MOV container)
      iex> ISOBMFFLang.int_to_lang(5)
      {:ok, "swe"}

      # Packed ISO Language Code for undefined language (MP4 container)
      iex> ISOBMFFLang.int_to_lang(21956)
      {:ok, "und"}

      iex> ISOBMFFLang.int_to_lang(-1)
      {:error, "Failed to parse integer value: Integer out of bounds."}

      iex> ISOBMFFLang.int_to_lang(32768)
      {:error, "Failed to parse integer value: Integer out of bounds."}
  """

  @max_int15 32767

  def int_to_lang(i) when i <= @max_int15 and i >= 0, do: <<i::15>> |> int15_to_lang
  def int_to_lang(_), do: {:error, "Failed to parse integer value: Integer out of bounds."}

  @doc """
  Converts a 16 bit, zero padded, uint15 ISOBMFF language representation into ISO 639-2 language code.

  Returns an error if integer value is not within range for a uint15

  ## Examples

      # QuickTime language code value for swedish (MOV container)
      iex> ISOBMFFLang.int16_to_lang(<<0::1, 5::15>>)
      {:ok, "swe"}

      # Packed ISO Language Code for undefined language (MP4 container)
      iex> ISOBMFFLang.int16_to_lang(<<0::1, 21956::15>>)
      {:ok, "und"}

      iex> ISOBMFFLang.int16_to_lang(<<-1::14>>)
      {:error, "Failed to parse 16 bit integer value: Integer out of bounds."}

      iex> ISOBMFFLang.int16_to_lang(<<32768::17>>)
      {:error, "Failed to parse 16 bit integer value: Integer out of bounds."}
  """

  def int16_to_lang(<<0::1, i::15>>), do: i |> int_to_lang
  def int16_to_lang(_), do: {:error, "Failed to parse 16 bit integer value: Integer out of bounds."}

  @doc """
  Converts a 15 bit ISOBMFF integer language representation into ISO 639-2 language code.

  Returns an error if integer value is not within range for a uint15

  ## Examples

      # QuickTime language code value for swedish (MOV container)
      iex> ISOBMFFLang.int15_to_lang(<<5::15>>)
      {:ok, "swe"}

      # Packed ISO Language Code for undefined language (MP4 container)
      iex> ISOBMFFLang.int15_to_lang(<<21956::15>>)
      {:ok, "und"}

      iex> ISOBMFFLang.int15_to_lang(<<1::14>>)
      {:error, "Failed to parse 15 bit integer value: Integer out of bounds."}

      iex> ISOBMFFLang.int15_to_lang(<<32768::17>>)
      {:error, "Failed to parse 15 bit integer value: Integer out of bounds."}
  """

  Enum.each @quicktime_language_codes, fn {name, number} ->
    def int15_to_lang(<<unquote(number)::15>>), do: {:ok, unquote(name |> to_string)}
  end

  def int15_to_lang(<<a::5, b::5, c::5>>), do: {:ok, <<a + 0x60, b + 0x60, c + 0x60>>}
  def int15_to_lang(_), do: {:error, "Failed to parse 15 bit integer value: Integer out of bounds."}
end
