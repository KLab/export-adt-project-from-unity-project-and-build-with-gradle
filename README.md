# Unity プロジェクトから ADT 形式の Android プロジェクトを生成し、Gradle を使ってそれをビルドする

## これによって解決できること

Unity に設定項目のない Android ビルド時のパラメーターが指定できるようになる。

- compile SDK version
- build tools version

## 用意するもの

- Unity のプロジェクト
  - バッチモードで Android プロジェクトが生成できるスクリプト
    - このプロジェクトでは `void GradleTest.BatchBuild.Build()`
- _make-gradle-buildable.bash_
- _gradle_ ディレクトリー
  - _build.gradle_ は記載してある各バージョンを必要に応じて書き換えること

## やってること

Unity から ADT 形式の Android プロジェクトを出力する。後で使うスクリプトにハードコードされているので、出力ディレクトリー名は _build-adt_ にする。

_gradle_ ディレクトリーに用意した Gradle 関連のファイルを _build-adt_ にコピーする。_make-gradle-buildable.bash_ でそれをしている。

カレントディレクトリーを _build-adt/PROD_NAME_ にして _./gradlew build_ コマンドでビルドする。

## ソース説明

バッチモードで Android プロジェクトを生成するには、`BuildOptions.AcceptExternalModificationsToPlayer` を指定して `string BuildPipeline.BuildPlayer(string[], string, BuildTarget, BuildOptions)` を呼ぶ。出力ディレクトリー名を _build-adt_ にするために、これを `BuildPlayer` 関数の第2引数に指定する。

_make-gradle-buildable.bash_ は _rsync_ しているだけ。

_build.gradle_ は ADT の構成のディレクトリーを対象とするために、`android.sourceSets` で各ディレクトリーを指定している。その他は一般の Android の Gradle ファイルと同じ。

_./make-gradle-buildable.bash_ と _./gradlew build_ の実行は、Unity の post process build でも Jenkins のスクリプトでもお好きにどうぞ。
