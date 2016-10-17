# Unity プロジェクトから ADT 形式の Android プロジェクトを生成し、Gradle を使ってそれをビルドする

## これによって解決できること

Unity に設定項目のない Android ビルド時のパラメーターが指定できるようになる。

- compile SDK version
- build tools version

Android のビルド時に指定するバージョンの意味については下記を参考にしてください。

- [Android SDK に関する情報](https://sites.google.com/a/klab.com/techinfo/native/android/android-versions)

## 用意するもの

- Unity のプロジェクト
  - バッチモードで Android プロジェクトが生成できるスクリプト
    - このプロジェクトでは `void GradleTest.BatchBuild.Build()`
- _make-gradle-buildable.bash_
- _gradle_ ディレクトリー
  - _build.gradle_ は記載してある各バージョンを必要に応じて書き換えること

## やっていること

1. Unity から ADT 形式の Android プロジェクトを _build-adt_ に出力する。
1. _gradle_ ディレクトリーに用意した Gradle 関連のファイルを _build-adt_ 以下にリンクする。
1. Gradle を使って Android プロジェクトをビルドする。

## ソース説明

バッチモードで Android プロジェクトを生成するには、`BuildOptions.AcceptExternalModificationsToPlayer` を指定して `string BuildPipeline.BuildPlayer(string[], string, BuildTarget, BuildOptions)` を呼ぶ。後で使うスクリプトにハードコードされているので、出力ディレクトリー名を _build-adt_ にするために、これを `BuildPlayer` 関数の第2引数に指定する。

_make-gradle-buildable.bash_ で、_gradle_ ディレクトリーに用意した Gradle 関連のファイルを _build-adt_ 以下にリンクしている。

_build.gradle_ は ADT の構成のディレクトリーを対象とするために、`android.sourceSets` で各ディレクトリーを指定している。その他は一般の Android の Gradle ファイルと同じ。

## 使い方説明

ソースの用意ができたら下記手順で Unity プロジェクトを Android アプリケーションにビルドする。

### 1. Unity プロジェクトから Android プロジェクトを出力する

Unity の「Build Settings」で「Google Android Project」にチェックを入れてビルドする。もしくは、下記（macOS での例）のようにプロジェクトルートで上述のバッチモードを実行する。

```
$ /Applications/Unity/Unity.app/Contents/MacOS/Unity -batchmode -quit -executeMethod GradleTest.BatchBuild.Build
```

### 2. Gradle でビルドできるようにする準備

プロジェクトルートで _make-gradle-buildable.bash_ を実行する。成功すると最後に `SUCCESS` と出力される。

### 3. Gradle でビルドする

カレントディレクトリーを _build-adt/PROD_NAME_ にして _./gradlew build_ コマンドでビルドする。`PROD_NAME` はこのプロジェクトでは `Gradle Test`。

```
$ cd build-adt/PROD_NAME
$ ./gradlew build
```

生成された APK は _build/outputs/apk_ 以下にある。

_./make-gradle-buildable.bash_ と _./gradlew build_ の実行は、Unity の post process build にしてしまうのもありだと思う。

### CI

Jenkins に設定する場合は、ジョブの「設定」で通常の Unity のビルドのように「ビルド」に「Invoke Unity3d Edior」で上記 1 を設定し、「シェルの実行」に下記のスクリプトで 2・3 を設定すればよい。

```
./make-gradle-buildable.bash
pushd build-adt/PROD_NAME
  ./gradlew build
popd
```
