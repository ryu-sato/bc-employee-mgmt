# How to install

JAVA 8 ([JAVA 11 だと jrb が動作しない](https://github.com/arton/rjb/issues/70)) をインストールし、JAVA_HOME 環境変数を設定する

* 依存関係を解決する
    `bundle install --path vendor/bundle --binstubs=.bundle/bin`
* kuromoji をダウンロードしてパスを設定する
    * [GitHub](https://github.com/atilika/kuromoji/downloads) から kuromoji をダウンロードする
    * config/settings/#{Rails.env}.yml の KUROMOJI_LIB に kuromoji へのパスを指定する
