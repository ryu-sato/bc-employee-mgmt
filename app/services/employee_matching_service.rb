require 'singleton'
require 'rjb'

module  JavaIterator
    def each
        i = self.iterator
        while i.has_next
            yield i.next
        end
    end
end

class EmployeeMatchingService
    include Singleton

    def initialize
        Rjb::load(Settings.KUROMOJI_LIB)

        tokenizer = Rjb::import('org.atilika.kuromoji.Tokenizer')
        @tokenizer = tokenizer.builder.build
    end

    def enabled?
        @tokenizer.present?
    end

    # 従業員のマッチ度を以下の前提で計算する
    # * 名前の相性
    #   (相性はピラミッド占いで算出します。参考: https://matome.naver.jp/odai/2149993519330139601)
    # 1. 相性を占いたい2人の名前を母音で数値化します。「あ＝１」「い＝２」「う＝３」「え＝４」「お＝５」
    #    例：「きむらたろう」→「231153」、「やまだはなこ」→「111115」
    # 2. 2人の数字を続けて書きます
    #    例：231153111115
    # 3. 隣り合っている数字をたして、下に書いていきます
    #    2と3で5、　3と1で4、　1と1で2…。　10以上は下一桁を書きます
    #    例：計算していくと、54268422227
    # 4. これを、数字の並びが100以下になるまで、続けます
    def compatibility(employee_a, employee_b)
        return nil if [employee_a, employee_b].any?(&:blank?)

        vowels_numbers = (vowels(employee_a.name) + vowels(employee_b.name)).split('').map(&:to_i)
        pyramid_adding(vowels_numbers)
    end

    private

    # 指定された文字列の日本語読みから、母音の数字列を返す (1文字は母音毎に「あ＝１」「い＝２」「う＝３」「え＝４」「お＝５」と変換する)
    # ex. 「きむらたろう」→「231153」、「やまだはなこ」→「111115」
    def vowels(string)
        return '' if string.blank?

        replace_table = [
            # 無声音は削除する
            { regex: /[ッンー]/, rep: '' },
            # 濁点・半濁点を削除する
            { regex: /[ガ]/, rep: 'カ'}, { regex: /[ザ]/, rep: 'サ'}, { regex: /[ダ]/, rep: 'タ'}, { regex: /[バ]/, rep: 'パ'},
            { regex: /[ギ]/, rep: 'キ'}, { regex: /[ジ]/, rep: 'シ'}, { regex: /[ヂ]/, rep: 'チ'}, { regex: /[ビ]/, rep: 'ヒ'},
            { regex: /[グ]/, rep: 'ク'}, { regex: /[ズ]/, rep: 'ス'}, { regex: /[ヅ]/, rep: 'ツ'}, { regex: /[ブ]/, rep: 'フ'},
            { regex: /[ゲ]/, rep: 'ケ'}, { regex: /[ゼ]/, rep: 'セ'}, { regex: /[デ]/, rep: 'テ'}, { regex: /[ベ]/, rep: 'ヘ'},
            { regex: /[ゴ]/, rep: 'コ'}, { regex: /[ゾ]/, rep: 'ソ'}, { regex: /[ド]/, rep: 'ト'}, { regex: /[ボ]/, rep: 'ホ'},
            { regex: /[パ]/, rep: 'パ'},
            { regex: /[ピ]/, rep: 'ヒ'},
            { regex: /[プ]/, rep: 'フ'},
            { regex: /[ペ]/, rep: 'ヘ'},
            { regex: /[ポ]/, rep: 'ホ'},
            # 母音を数値へ変換する
            { regex: /[アカサタナハマヤラワ]/, rep: '1' },
            { regex: /[イキシチニヒミリ]/,     rep: '2' },
            { regex: /[ウクスツヌフムユル]/,   rep: '3' },
            { regex: /[エケセテネヘメレ]/,     rep: '4' },
            { regex: /[オコソトノホモヨロヲ]/, rep: '5' }
        ]

        readings = ''
        sentences = @tokenizer.tokenize(string)
        sentences.extend JavaIterator
        sentences.each do |s|
            readings += s.reading
        end
        replace_table.each do |it|
            readings.gsub!(it[:regex], it[:rep])
        end

        if readings.match?(/[^1-9]/)
            Rails.logger.warn("vowels error: non-numeric char contains. these characters will be ignored.")
            readings.reject! {|r| r =~ /[^1-5]/}
        end

        readings
    end

    def pyramid_adding(numbers)
        return nil if numbers.size < 2
        return(numbers[0] * 10 + numbers[1]) if numbers.size == 2

        calced_numbers = []
        i = 0
        while i < (numbers.size - 1)
            calced_numbers << (numbers[i] + numbers[i + 1]) % 10
            i += 1
        end

        pyramid_adding(calced_numbers)
    end
end
