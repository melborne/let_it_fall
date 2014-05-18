require "emot"

module LetItFall
  CODESET =
    Emot::MAP.reject do |name, codes|
      (codes.size != 1) || (name.match /shell/)
    end.merge(
      {
        faces:    [*0x1F600..0x1F64F] - [*0x1F641..0x1F644],
        kanjis:   (0x4E00..0x4F00),
        times:    (0x1F550..0x1f567),
        animals:  (0x1F40C..0x1F43C),
        foods:    (0x1F344..0x1F373),
        loves:    (0x1F493..0x1F49F),
        latins:   [*0x0021..0x007E, *0x00A1..0x00FF, *0x0100..0x017F, *0x0250..0x02AF],
        moneys:   [0x1F4B0, 0x1F4B3, 0x1F4B4, 0x1F4B5, 0x1F4B6, 0x1F4B7, 0x1F4B8],
        arrows:   (0x2190..0x21FF),
        oreillys: (0x1F40C..0x1F43C),
        alphabets: [*0x0041..0x005A, *0x0061..0x007A],
        dingbats: (0x2701..0x27BF),
        moons:    (0x1F311..0x1F315),
        christmas: [0x1F384, 0x1F385, 0x1F370],
        snow:     0x2736,
        python:   0x1F40D,
        perl:     0x1F42A,
      }
    ).freeze
end
