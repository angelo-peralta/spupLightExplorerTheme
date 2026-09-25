# The Light Explorer Theme

The Light Explorer Theme is an OJS 3.5 theme for the St. Paul University Philippines journal network. It is based on the PKP Classic Theme and keeps OJS journals, publications, issues, announcements, authentication, and navigation menus as the source of their own data.

Version 1.0.2.0 designs the **root publisher site**. Individual journal design systems are planned for V2; this release does not redesign their homepages, issues, or articles.

## Install in OJS

1. Sign in as a site administrator and open **Dashboard → Plugins → Upload a New Plugin**.
2. Upload `spupLightExplorerTheme-v1.0.2.zip`, enable **The Light Explorer Theme**, and select it under **Settings → Website → Appearance** for the root site.
3. Set the OJS **Site Name**, **Site Logo**, and **Site Contact Email**. Use **Site About** for section-specific About copy as described below.
4. Assign the site's **User Navigation Menu** to the `user` area, the publisher menu to `primary`, and the footer menus to `footerExplore` and `footerInformation` in OJS Navigation Menus.
5. Configure the root theme options under Appearance. If a changed template or LESS file is not visible, clear the OJS template and stylesheet caches.

The installed theme does not require Node.js, npm, Gulp, or Composer. The official Classic Theme can remain installed separately. The ZIP is larger than PHP's default 2 MB upload limit; set `upload_max_filesize` and `post_max_size` above the ZIP size before uploading.

For an existing installation, use the **Upgrade** action on The Light Explorer Theme under the installed Theme Plugins list. OJS does not upgrade an installed plugin through **Upload a New Plugin**. After upgrading, clear the OJS template and compiled stylesheet caches.

## Root navigation and content

Create site-level Custom Navigation Menu Items with these paths and assign them to the site's menus as needed:

| Label | Path | Content source |
| --- | --- | --- |
| Journals | `journals` | Enabled OJS journals and their uploaded covers |
| About | `publisher-about` | Approved theme fallback text or sectioned OJS About copy, plus live statistics and journals |
| Contact | `publisher-contact` | OJS Site Contact Email and the theme's publisher address |
| Submission Overview | `publisher-submit` | Administrator-edited item content plus live journal covers |

The theme renders the first three pages dynamically; their custom-item content may be empty. Keep Submission Overview's guidance in the OJS custom item's content field. Its links should lead to individual journals, because manuscripts are submitted inside a journal.

The Submission Overview journal chooser is rendered by the theme for a root-level custom navigation page at `publisher-submit` or `submission`. It lists enabled OJS journals and uses their saved cover images. If the chooser is missing, verify the custom page path, that this theme version is active for the root site, and that OJS template and stylesheet caches have been cleared after updating the plugin.

The root About page uses the approved wording supplied for its V1 layout as English fallback text. To edit a narrative section in OJS, place its copy in **Site About** or the `publisher-about` custom page content inside a wrapper such as `<div id="spup-about-story"><p>Approved history text.</p></div>`. Supported IDs are `spup-about-intro`, `spup-about-story`, `spup-about-identity`, `spup-about-structure`, `spup-about-readers`, `spup-about-authors`, and `spup-about-platform`. The theme supplies headings and section order, so these wrappers should contain body copy only. Custom page sections override matching Site About sections; unstructured Site About text is not inserted into the redesigned page. Statistics, journal covers, contact email, publisher address, and map are sourced separately from OJS and the root theme settings.

The homepage uses site-level OJS announcements, published OJS submissions, and enabled journal contexts. Journal names, article titles, counts, and cover paths are not stored in the theme.

Journal covers and Latest Scholarship entries reveal with a brief slide and wipe as they enter the viewport. The content stays visible without JavaScript, and the reveal is disabled when reduced motion is requested.

## Root theme options

The site administrator may edit the network subtitle, publisher address, and Google Maps embed URL; show or hide network statistics, Latest Scholarship, announcements, About sections, and maps; and choose the recent publication and announcement counts. Counts are restricted to the choices shown in Appearance. Map URLs must be HTTPS Google Maps embed URLs; an empty or invalid URL renders no iframe. No Custom CSS, font, color, layout, or animation setting is provided for the root design.

Upload journal cover images through each OJS journal's settings. The root gallery and Journals page keep each image's natural proportions and frame it with that journal's saved primary colour. A journal without a cover receives a text fallback. The maps on About and Contact are optional and use the same configured URL. Paste either the URL or full iframe from Google Maps > Share > Embed a map into the theme setting; the theme stores only a validated Google Maps URL. The footer map is off by default. The SPUP seal in the root utility bar is packaged in `resources/spup-seal.png`; the subdued institutional footer photograph is packaged in `resources/footer-image.jpg`.

## Development and packaging

The runtime stylesheet is compiled by OJS from `less/import.less`. The committed `resources/app.min.js` and `resources/app.min.css` provide the runtime JavaScript and Bootstrap styles. If `dev_js/main-theme.js` changes, run `npx gulp scripts` and `npx gulp compress` before packaging. These tools are only needed by developers.

Run `python scripts/build_release.py` to create `dist/spupLightExplorerTheme-v1.0.2.zip`. The archive has one top-level `spupLightExplorerTheme/` folder and contains only runtime code, styles, fonts, locales, templates, and license/documentation files. It excludes `.git`, `.local-dev`, `node_modules`, database dumps, credentials, screenshots, and development output. Test the exact ZIP through OJS's plugin upload workflow before publishing a release tag.

## Credits and licenses

The theme is based on the [PKP Classic Theme](https://github.com/pkp/classic). Original PKP, Simon Fraser University, and John Willinsky copyright and GNU GPL notices are retained. Classic Theme design credits include Sophy Ouch, Vitalii Bezsheiko, John Willinsky, and Kevin Stranack.

Modified by St. Paul University Philippines, 2026. The theme is distributed under [GNU GPL v3](LICENSE). Bundled Cardo and Montserrat fonts are distributed under the SIL Open Font License; their notices are in [fonts/OFL-Cardo.txt](fonts/OFL-Cardo.txt) and [fonts/OFL-Montserrat.txt](fonts/OFL-Montserrat.txt).
