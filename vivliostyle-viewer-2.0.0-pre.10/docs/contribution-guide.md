# Contribution Guide

## Module structure

Vivliostyle Viewer consists of two components:

| [Core](https://github.com/vivliostyle/vivliostyle/tree/master/packages/core) | [Viewer](https://github.com/vivliostyle/vivliostyle/tree/master/packages/viewer) |
| ---------------------------------------------------------------------------- | -------------------------------------------------------------------------------- |
| Page layout engine                                                           | UI for Vivliostyle Core                                                          |

## Setup a development environment

Make sure that the following is installed:

- [Node.js](https://nodejs.org)
- [Yarn](https://yarnpkg.com)
- [Git](https://git-scm.com)

Clone [vivliostyle](https://github.com/vivliostyle/vivliostyle).

```shell
git clone https://github.com/vivliostyle/vivliostyle.git
cd vivliostyle
```

`@vivliostyle/core` is listed as a dependency for @vivliostyle/viewer in `package.json`. During development, you want to use the local copy of `@vivliostyle/core`, rather than a package installed from npm. For this purpose, use `yarn bootstrap` to make a symbolic link:

```shell
yarn install # install dependencies
yarn bootstrap # setup development environment
```

## Build and serve

```shell
yarn build-dev # build a development version of both Core and Viewer.
yarn dev # start watching source files and open browser.
```

With `yarn dev`, a web server starts ([Browsersync](https://browsersync.io/) with live-reload enabled), and Google Chrome should automatically open. If no browser opens, open <http://localhost:3000/core/test/files/>. On saving any source file, the browser automatically reloads.

## Viewer and test files

Viewer HTML file (in development mode) is located at `packages/viewer/lib/vivliostyle-viewer-dev.html`. You can open an (X)HTML file with a URL (relative to the viewer HTML file) specified to `x` hash parameter. For example, <http://localhost:3000/viewer/lib/vivliostyle-viewer-dev.html#x=../../core/test/files/print_media/index.html> opens a test file for print media located at `packages/core/test/files/print_media/index.html`. You can also open an EPUB directory (unzipped EPUB file) by `b` parameter. For example, <http://localhost:3000/viewer/lib/vivliostyle-viewer-dev.html#b=../../core/scripts/package-artifacts/samples/niimi/> opens a sample EPUB directory located at `packages/core/scripts/package-artifacts/samples/niimi/`. Note that you cannot omit the trailing slash.
The `b` parameter also accepts Web publications (multi-HTML documents). See the PR: [Support Web Publications and similar multi-HTML documents with TOC navigation](https://github.com/vivliostyle/vivliostyle/pull/511).

Test HTML files, intended to be used during development, are located at `packages/core/test/files/`. You are encouraged to add test files useful for implementing and verifying features.

`packages/core/scripts/package-artifacts/samples/` directory holds a public sample files, which are deployed to [the sample page on vivliostyle.org](https://vivliostyle.org/samples).

## Testing

You need to run `npm install` in the root directory before running the following.

The TypeScript source files are compiled and minified by Rollup. To build the minified version of JavaScript files, run `yarn build` (in the root directory). The sources are type-checked and the minified file will be generated under `packages/core/lib/` and `packages/viewer/lib` directories.

[Jasmine](http://jasmine.github.io/) is used for unit testing. Spec files are located under `packages/core/test/spec/`. To run unit tests on a local machine, run `npm run test-local`.

~~[A forked version of CSSWG reftests](https://github.com/vivliostyle/csswg-test) can be run with vivliostyle. See files under `packages/core/test/wpt/` for details.~~ (Currently not working, need fix!)

The unit tests ~~and reftests (listed in `packages/core/test/wpt/metadata/MANIFEST.json`)~~ is automatically invoked in [Travis CI](https://travis-ci.org/vivliostyle/vivliostyle) when pushing to GitHub. When pushed to master, after all tests pass, the code will be automatically deployed to github pages and can be accessed from [the sample page on vivliostyle.org](https://vivliostyle.org/samples), so please be careful when pushing to master (merging PR).

## Building production version

You can build a production version of Vivliostyle by running `yarn build` under both packages/core and packages/viewer directories. All JS files of packages/core and packages/viewer are concatenated to a single file.

## Development mode

In development mode (`yarn build-dev`), the compiled JS file `vivliostyle.js` and source map file `vivliostyle.js.map` (both located under `packages/core/lib`) are loaded by the browser and you can debug TypeScript code in the browser's developer tools.

## Maintaining documents

Please update the following documents as developing.

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

## Code

### Lint and code formatting

Run `npm run lint` for lint and code format check (using [ESLint](https://eslint.org/) with [eslint-plugin-prettier](https://github.com/prettier/eslint-plugin-prettier)) for the vivliostyle.js source code.

Run `npm run lint-fix` to fix fixable errors.

We use the [default options of Prettier](https://prettier.io/docs/en/options.html) for code formatting. Use `npm run lint-fix` to keep the code pretty.

### Source files

Source files under `packages/core/src/` are briefly described below.

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

## Other dev documents

- [Vivliostyle API Reference](./api.md)
- [Migration to TypeScript](./typescript-migration.md)
