# 二郎ガチャ

二郎系ラーメン20枚と、ハズレの味噌ラーメン1枚からランダムに抽選するFlutterアプリです。

画像はすべて `assets/images/` に同梱しているため、実行時の画像ダウンロードや外部APIは不要です。

## 実行方法

```sh
flutter pub get
flutter run
```

Web版を実行する場合:

```sh
flutter run -d chrome
```

## 構成

- `lib/main.dart`: ガチャ画面、抽選処理、当たり・ハズレ演出
- `assets/images/`: 二郎系20枚、ハズレ画像1枚
- `pubspec.yaml`: 画像アセットの登録

ハズレ画像は `lib/main.dart` の `GachaImage` で `isMiss: true` に設定されています。

## 画像について

同梱画像はWikimedia Commons上の各ファイルをアプリ表示向けに縮小したものです。作者・ライセンス・出典は [IMAGE_CREDITS.md](IMAGE_CREDITS.md) を参照してください。
