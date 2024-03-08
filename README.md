# bundler_t

Offense-free Initializer with Bundler

for MS-Windows

## 1. はじめに

Ruby で script を書くなら、****.rb の 1 file だけを書き始めるのではなく、最初から良い方法で書き始めたいと思いませんか?

* 最終的には RubyGem にまとめたい
* RuboCop に整形を任せたい
* YARD で常に文書化率 100% を維持したい
* RSpec で動作確認しながら開発したい

ところが、`bundle gem ****` で新規作成すると、何も手を加えていないのにいきなり RuboCop の指摘箇所が何か所も発生します。せっかく「書き始めたい」と思っても、RuboCop の指摘箇所の修正 (または .rubocop.yml の修正) に手間取り、書く気が萎えてしまいます。

また、新しい class を作ろうと思っても、他の class files で require_relative したり、その class の spec file を用意したりして、すぐには class の中身を書き始められないと思います。

この bundler_t は、様々なことを YAML file に記入しておいてから `bundlegem ****.yml` と入力するだけで、様々な初期設定をしてくれます。(`bundle gem ****` ではなく `bundlegem ****.yml` です。)

## 2. YAML file の中身

以下に例を提示します。

<pre>name: polearn35
summary: Support to study languages.
description: 『いまからはじめる○○語』などの外国語教科書の理解を深める。
classes:
  - name: grammatical_category
    docstring: 文法範疇。
  - name: concept
    docstring: 語が持つ概念。概念の表現は presentation。
    beginning: attr_reader :presentation
    methods:
      - name: initialize(presentation:)
        docstring: 概念表現を登録する。
        content: "@presentation = presentation"
  - name: language
    docstring: 言語。
    beginning: attr_reader :words
    methods:
      - name: initialize(name:)
        docstring: 名前付きで言語を定義する。
        content: |-
          @name = name
          @words = []
      - name: add_word(w)
        docstring: 単語を登録する。
        content: "@words << w"
  - name: word
    docstring: 語。
    beginning: attr_reader :name, :concept
    methods:
      - name: "initialize(name:, concept: nil)"
        docstring: 名前付き、概念付きで語を定義する。
        content: |-
          @name = name
          @concept = concept
specs:
  - name: russian
    content: |-
      before do
      @rus = described_class::Language.new(name: 'ロシア語')
      te = described_class::Concept.new(presentation: '手')
      ruka = described_class::Word.new(name: 'рука', concept: te)
      @rus.add_word(ruka)
      end
      it 'ロシア語へ「рука」を登録すると語数が1になる' do
      expect(@rus.words.count).to eq(1)
      end
</pre>

root 直下の要素を説明します。

|要素 |説明 |
|--|--|
|name|project の名称|
|summary|project の簡易な説明|
|description|project の詳細な説明|
|classes|各 class の配列|
|specs|各 spec の配列|

class　の要素を説明します。

|要素 |説明 |
|--|--|
|name|class 名|
|docstring|YARD の検出対象となる class 説明文|
|beginning|class 内の冒頭に書かれる文字列、主に `attr_reader` 用|
|methods|class に属する method の配列|

method の要素を説明します。

|要素 |説明 |
|--|--|
|name|method 名|
|docstring|YARD の検出対象となる method 説明文|
|content|method の内容|

spec の要素を説明します。

|要素 |説明 |
|--|--|
|name|spec 名|
|content|spec の内容|

要素によっては複数行を許容します。

## 3. 起動方法 (通常)

上述の YAML file の名称が aaa.yaml であるなら、`bundlegem y:aaa.yaml` で起動します。

## 4. 起動方法 (簡易)

YAML file を用意することも面倒な場合、簡易な初期化だけで良ければ以下の方法で起動できます。

例えば `bundlegem school s:management d:school_management student teacher` と入力すると、「school」という　project の中に「student」class と「teacher」class が含まれたものが用意されます。「s:」で始まる項は summary になり、「d:」で始まる項は description になります。

summary や description がなくても起動できますが、`rake build` するには最低でも summary が必要なので、最初から指定しておく方が楽です。

## 5. 起動後の動作

起動後は以下の通り動作します。

1. `bundle gem` を呼び出します。
2. `bundle gem` で自動生成された内容を一部書き換えます。
3. RuboCop の自動修正を実施します。
4. `rake spec` を実施します。

## A. appendix

### [YARD tags](https://qiita.com/mattan5271/items/f8c28f475747eea69dcf#%E3%82%BF%E3%82%B0%E4%B8%80%E8%A6%A7)

* @param: メソッドの引数を説明
* @option: メソッドのハッシュ引数を説明
* @return: メソッドの返り値を説明
* @raise: メソッドの例外クラスの説明
* @example: メソッドの使用例を説明(インデントをずらさないとコード変換されないので注意)
* @note: メソッドを使用する際の注意点やその他共有事項を記載する(「{}」で囲むことでリンクになる)
* @see: URLや他のオブジェクトを書くとリンクになる
