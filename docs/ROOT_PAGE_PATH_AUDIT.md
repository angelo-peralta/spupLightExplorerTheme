# Root page path audit

Checked 25–26 September 2026 against the public production site and local OJS 3.5. Production was inspected with HTTP requests only; no production data or configuration was changed. The production paths below were read from the live root navigation menu and then requested directly. Local pages are OJS `NMI_TYPE_CUSTOM` Navigation Menu Items served by `NavigationMenuItemHandler`. Both `/index/{path}` and `/index.php/index/{path}` resolve locally, although OJS generates the former under its current local URL settings.

| Page | Supplied path | Live production menu path | Local path | Result |
| --- | --- | --- | --- | --- |
| Home | `index` | `index` | `index` | Match |
| About | `about` | `publisher-about` | `about` | Desired `/about` redirects to Login in production; local `/about` works |
| Submission Overview | `submission` | `submission` | `submission` | Match |
| Journal Policies grouping | Group only | `journalpolicies` (200) | same (200) | Production also has a custom overview page |
| Publication Ethics | `publication-ethics` | `publication-ethics` | same | Match |
| Peer Review | `peer-review` | `Peer-review` | same | Local now preserves the live path's case |
| Plagiarism and Similarity Screening | `plagiarism-similarity-screening` | same | same | Match |
| Article Processing Charge | `article-processing-charge` | `Article-processing` (200) | same (200) | Supplied production path returns 404 |
| AI Use | `ai-use` | `AI-use` | same | Local now preserves the live path's case |
| Open Access | `open-access` | `Open-access` | same | Local now preserves the live path's case |
| Copyright and Licensing | `copyright-and-licensing` | same (200) | same | Match; preserve the correct spelling |
| Publication Guidelines grouping | Group only | `publication-guidelines` (200) | same | Production also has an overview page |
| Research Ethics | `research-ethics` | `ethics` (200) | same (200) | Supplied production path returns 404 |
| Authorship Criteria | `authorship-criteria` | `Authorship` (200) | same (200) | Supplied production path returns 404 |
| Conflict of Interest | `conflict-of-interest` | same | same | Match |
| Funding Statement | `funding-statement` | `Funding` (200) | same (200) | Supplied production path returns 404 |
| Contact | Not supplied | `contact-us` (200) | `contact-us` (200) | Production and local also serve `/contact` with the same content |

The live production pages above have `page navigation-item-content` markup, consistent with custom navigation item rendering. Their database records and owning plugin could not be inspected remotely, so the exact production storage type remains unconfirmed.

The existing production About item should use `about` if the supplied mapping is the intended final URL. Local verification confirmed a root custom item at `about` takes precedence over the native route that otherwise redirects to Login. Change the existing production item's path in OJS while keeping its menu assignments, then verify public `/index.php/index/about` and all About menu/footer links. If the change fails, restore `publisher-about`. The theme accepts both paths during migration, but its own About links generate `about`.

The four supplied policy/guideline slugs that return 404 are **not** existing production page paths. Their live menu destinations are listed above. Do not rename those production pages based on the local source filenames. Local navigation now mirrors the verified live paths exactly, preserving page content and menu assignments. The theme does not hard-code either hostname. It recognizes both production Contact paths, `contact-us` and `contact`, for the expanded Contact layout.

Repeated fresh checks showed `copyright-and-licensing` serving the production page and `copyrigth-and-licensing` returning 404. The typo in the old source filename is not a production slug.

Before the local path updates, the three root navigation tables were backed up to `.local-dev/spup-root-routes-before-audit.sql` and `.local-dev/spup-root-routes-before-live-mirror.sql`. These backups are local only and excluded from the plugin package. Existing local menu items retained their IDs and assignments while their paths were aligned; an unassigned `/contact` alias was added because production serves both Contact URLs. No production changes were made.
