# コントリビューションガイド

## モジュール構成

Vivliostyle Viewerは2つのコンポーネントで構成されています:

| [Core](https://github.com/vivliostyle/vivliostyle/tree/master/packages/core) | [Viewer](https://github.com/vivliostyle/vivliostyle/tree/master/packages/viewer) |
| ---------------------------------------------------------------------------- | -------------------------------------------------------------------------------- |
| Page layout engine                                                           | UI for Vivliostyle Core                                                          |

## 開発環境のセットアップ

以下のものがインストールされていることを確認してください:

- [Node.js](https://nodejs.org)
- [Yarn](https://yarnpkg.com)
- [Git](https://git-scm.com)

[vivliostyle](https://github.com/vivliostyle/vivliostyle)をクローンします。

```shell
git clone https://github.com/vivliostyle/vivliostyle.git
cd vivliostyle
```

`@vivliostyle/core` は `@vivliostyle/viewer` 内の `package.json` でdependencyに含まれています。開発時には、`@vivliostyle/core` はnpmからインストールされたパッケージではなくローカルのコピーを用います。このため、`yarn bootstrap` を使ってシンボリックリンクを作成します。

```shell
yarn install # install dependencies
yarn bootstrap # setup development environment
```

## ビルド・開発サーバーの立ち上げ

```shell
yarn build-dev # build a development version of both Core and Viewer.
yarn dev # start watching source files and open browser.
```

`yarn dev` を使用すると、（[Browsersync](https://browsersync.io/) によりライブリロードが有効な）Webサーバーが起動し、Google Chromeが自動的に開きます。 ブラウザーが開かない場合は、<http://localhost:3000/core/test/files/>を開きます。 ソースファイルを保存すると、ブラウザは自動的にリロードされます。

## ビューワーとテストファイル

開発モード中のビューワーHTMLファイルは `packages/viewer/lib/vivliostyle-viewer-dev.html` にあります。`x` ハッシュパラメータを指定して、ビューワーHTMLファイルから相対の(X)HTMLファイルをURLで指定できます。例えば、<http://localhost:3000/viewer/lib/vivliostyle-viewer-dev.html#x=../../core/test/files/print_media/index.html> は `packages/core/test/files/print_media/index.html` にあるprint mediaのテストファイルを開きます。また、`b` パラメータによってEPUBディレクトリ（解凍されたEPUBファイル）を開くこともできます。例えば、<http://localhost:3000/viewer/lib/vivliostyle-viewer-dev.html#b=../../core/scripts/package-artifacts/samples/niimi/> は `packages/core/scripts/package-artifacts/samples/niimi/` にあるサンプルのEPUBディレクトリを開きます。ただし、末尾のスラッシュは省略できないことに注意してください。`b` パラメータはWeb出版物（複数のHTMLによるドキュメント）も受け入れます。PR: [Support Web Publications and similar multi-HTML documents with TOC navigation](https://github.com/vivliostyle/vivliostyle/pull/511) を参照してください。

開発中に使用することを目的としたテストHTMLファイルは、 `packages/core/test/files/` にあります。 機能の実装と検証に役立つテストファイルを追加することをお勧めします。

`packages/core/scripts/package-artifacts/samples/` ディレクトリには公開用のサンプルファイルがあり、これらは [vivliostyle.orgのサンプルページ](https://vivliostyle.org/samples) にデプロイされます。

## テスト

以下を実行する前に、ルートディレクトリで `npm install` を実行する必要があります。

TypeScriptで書かれたソースファイルは、Rollupによってコンパイル・minifyされます。 JavaScriptファイルのminifiedバージョンをビルドするには、（ルートディレクトリで）`yarn build` を実行します。 ソースは型チェックされ、minifyされたファイルは `packages/core/lib/` と `packages/viewer/lib` ディレクトリの下に生成されます。

[Jasmine](http://jasmine.github.io/) はユニットテストに使用されます。 スペックファイルは `packages/core/test/spec/` の下にあります。 ローカルマシンでテストを実行するには、`npm run test-local` を実行します。

~~[A forked version of CSSWG reftests](https://github.com/vivliostyle/csswg-test) can be run with vivliostyle. See files under `packages/core/test/wpt/` for details.~~ (Currently not working, need fix!)

ユニットテスト ~~and reftests (listed in `packages/core/test/wpt/metadata/MANIFEST.json`)~~ はGitHubにプッシュした際に [Travis CI](https://travis-ci.org/vivliostyle/vivliostyle) が自動的に実行されます。masterにプッシュされると、すべてのテストに合格した後、コードは自動的にGitHub Pagesにデプロイされ、[vivliostyle.orgのサンプルページ](https://vivliostyle.org/samples) からアクセスできます。masterへのプッシュ（PRのマージ）には注意してくだい。

## production versionのビルド

packages/coreディレクトリとpackages/viewerディレクトリの両方で `yarn build` を実行することで、Vivliostyleのproduction versionをビルドできます。 packages/coreおよびpackages/viewerのすべてのJSファイルは、単一のファイルに結合されます。

## 開発モード

開発モード (`yarn build-dev`) では、コンパイルされたJSファイル ` vivliostyle.js` とソースマップファイル `vivliostyle.js.map`（両方とも ` packages/core/lib` の下にあります）がブラウザーによってロードされ、 ブラウザの開発者ツールでTypeScriptコードをデバッグできます。

## ドキュメントのメンテナンス

以下のドキュメントを開発中に更新してください。

- [`CHANGELOG.md`](https://github.com/vivliostyle/vivliostyle/blob/master/CHANGELOG.md)
- [Available Properties](./available-properties.md)
- ~~This file can be generated with [`scripts/generate-property-doc.js`](https://github.com/vivliostyle/vivliostyle.org/blob/master/scripts/generate-property-doc.js) script as follows:~~ (Currently not working, need fix!)
  ```shell
  cd scripts
  curl -o anchors.json -H "Accept: application/json" 'https://test.csswg.org/shepherd/api/spec/?anchors&draft'  # Download spec data
  node ./generate-property-doc
  ```
- [Supported features](./supported-features.md)
- Document about features (values, selectors, at-rules, media queries and properties) supported by Vivliostyle. Automatically deployed to https://vivliostyle.org/docs/supported-features. ~~Update this file using information in `property-doc-generated.md`.~~

## コード情報

### Lint / code formatting

vivliostyleのソースコードは、`npm run lint` を実行（[eslint-plugin-prettier](https://github.com/prettier/eslint-plugin-prettier) を用いた [ESLint](https://eslint.org/)）して、コードフォーマットをチェックしてください。

修正できる問題は、`npm run lint-fix` を実行して修正します。

コードのフォーマットには、[Prettierのデフォルトオプション](https://prettier.io/docs/en/options.html) を使用します。`npm run lint-fix` を使用して、きれいなコードを保ってください。

### ソースファイル

`packages/core/src/` 以下のソースファイルについて簡単に説明します。

#### `vivliostyle/core-viewer.ts`

- Exposed interface of vivliostyle-core. To use vivliostyle-core, instantiate
  Vivliostyle.CoreViewer, set options, register event listeners by addListener
  method, and call loadDocument or loadPublication method.

#### `vivliostyle/constants.ts`

- Defines constants used throughout the library.

#### `vivliostyle/task.ts`

- Task scheduling.

#### `vivliostyle/exprs.ts`

- Definitions for [expressions](http://web.archive.org/web/20190506055550im_/http://www.idpf.org/epub/pgt/#s2) of Adaptive Layout.

#### `vivliostyle/css.ts`

- Definitions for various CSS values.

#### `vivliostyle/css-parser.ts`

- CSS parser.

#### `vivliostyle/css-cascade.ts`

- Classes for selector matching and cascading calculation.

#### `vivliostyle/vtree.ts`

- View tree data structures.

#### `vivliostyle/css-styler.ts`

- Apply CSS cascade to a document incrementally.

#### `vivliostyle/font.ts`

- Web font handling.

#### `vivliostyle/page-masters.ts`

- Classes for [page masters of Adaptive Layout](http://web.archive.org/web/20190506055550im_/http://www.idpf.org/epub/pgt/#s3.4).

#### `vivliostyle/page-floats.ts`

- Page floats.

#### `vivliostyle/vgen.ts`

- Generation of view tree.

#### `vivliostyle/layout.ts`

- Content layout inside regions, including column breaking etc.

#### `vivliostyle/css-page.ts`

- Support for [CSS Paged Media](https://drafts.csswg.org/css-page/).

#### `vivliostyle/ops.ts`

- Select page master, layout regions (columns) one by one etc.

#### `vivliostyle/epub.ts`

- Handling EPUB metadata, rendering pages etc.

> (There are more files... See the `pakcages/core/src` directory)

## その他の開発ドキュメント

- [Vivliostyle API Reference](./api.md)
- [Migration to TypeScript](./typescript-migration.md)
