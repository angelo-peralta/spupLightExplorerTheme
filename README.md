# The Light Explorer Theme

The Light Explorer Theme is a custom Open Journal Systems 3.5 theme developed for the journal network of St. Paul University Philippines. It is based on the [PKP Classic Theme](https://github.com/pkp/classic), with modifications developed by St. Paul University Philippines. This release establishes an independent plugin identity while retaining the Classic visual design and features.

## Base theme and compatibility

- Base: PKP Classic Theme, stable-3_5_0 branch
- Target platform: Open Journal Systems 3.5
- Plugin folder: plugins/themes/spupLightExplorerTheme
- Plugin version: 1.0.0.0

The theme has not yet been tested in a running OJS 3.5 installation. Test it locally before deploying it to a journal network.

## Installation

1. Copy or extract this repository into plugins/themes/spupLightExplorerTheme under the OJS installation root. Keep that exact folder name.
2. In OJS, open **Settings > Website > Plugins** and enable **The Light Explorer Theme**.
3. Open **Settings > Website > Appearance** and select **The Light Explorer Theme** as the journal theme.
4. Clear OJS caches if the plugin or its translated name does not appear, then reload the page.

The official Classic Theme may remain installed alongside this theme. The plugin folder, application ID, PHP class, and translation keys are distinct.

## Development

The repository includes the existing Classic Theme LESS, templates, JavaScript, and assets. Keep those files when installing the theme. The existing Gulp tasks in gulpfile.js can rebuild assets after npm install; no asset rebuild is required for this identity release.

## Credits and license

The original Classic Theme was designed and developed by Sophy Ouch, Vitalii Bezsheiko, John Willinsky, and Kevin Stranack for the Public Knowledge Project. Original PKP, Simon Fraser University, and John Willinsky copyright and GNU GPL notices are retained in the source.

Modifications: Copyright © 2026 St. Paul University Philippines.

This project is distributed under the [GNU General Public License v3.0](LICENSE). The Cardo and Montserrat fonts retain their [Open Font License](https://openfontlicense.org/) terms.
