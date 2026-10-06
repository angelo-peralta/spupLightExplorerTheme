<?php

/**
 * @file plugins/themes/spupLightExplorerTheme/SpupLightExplorerThemePlugin.inc.php
 *
 * Copyright (c) 2014-2025 Simon Fraser University
 * Copyright (c) 2003-2025 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class SpupLightExplorerThemePlugin
 * @ingroup plugins_themes_spupLightExplorerTheme
 *
 * @brief The Light Explorer Theme
 *
 * Based on the PKP Classic Theme.
 * Modified by St. Paul University Philippines, 2026.
 *
 * Distributed under the GNU GPL v3.
 */

use APP\publication\Publication;
use APP\facades\Repo;
use APP\core\Application;
use APP\submission\Submission;
use APP\submission\Collector as SubmissionCollector;
use PKP\announcement\Announcement;
use PKP\config\Config;
use PKP\db\DAORegistry;
use PKP\plugins\ThemePlugin;

class SpupLightExplorerThemePlugin extends ThemePlugin
{
    private const INSTITUTIONAL_URL = 'https://spup.edu.ph/';

    /** Approved editorial and interface families for the eight journal identities. */
    private const JOURNAL_FONT_PAIRS = [
        'jhsi' => ["'Source Serif 4', Georgia, serif", "'Inter', Arial, sans-serif"],
        'jeil' => ["'Literata', Georgia, serif", "'Source Sans 3', Arial, sans-serif"],
        'jbie' => ["'Libre Baskerville', Georgia, serif", "'Manrope', Arial, sans-serif"],
        'jcadi' => ["'Space Grotesk', Arial, sans-serif", "'IBM Plex Sans', Arial, sans-serif"],
        'jish' => ["'Cormorant Garamond', Georgia, serif", "'Work Sans', Arial, sans-serif"],
        'jens' => ["'Lora', Georgia, serif", "'Nunito Sans', Arial, sans-serif"],
        'jft' => ["'EB Garamond', Georgia, serif", "'Noto Sans', Arial, sans-serif"],
        'jetr' => ["'Roboto Slab', Georgia, serif", "'Barlow', Arial, sans-serif"],
    ];

    public function init()
    {
        /* Additional theme options */
        if (!$this->getRequest()->getContext()) {
            $this->addRootOptions();
        }

        // Changing theme primary color
        if ($this->getRequest()->getContext()) {
            $this->addOption('primaryColor', 'colour', [
            'label' => 'plugins.themes.spupLightExplorerTheme.option.primaryColor.label',
            'description' => 'plugins.themes.spupLightExplorerTheme.option.primaryColor.description',
            'default' => '#ffd120',
        ]);

        // Option to show journal summary
            $this->addOption('journalSummary', 'radio', [
            'label' => 'manager.setup.contextSummary',
            'options' => [
                0 => 'plugins.themes.spupLightExplorerTheme.options.journalSummary.disable',
                1 => 'plugins.themes.spupLightExplorerTheme.options.journalSummary.enable'
            ]
        ]);

            $this->addOption('showJournalTitleInHeader', 'radio', [
            'label' => 'plugins.themes.spupLightExplorerTheme.option.showJournalTitleInHeader.label',
            'description' => 'plugins.themes.spupLightExplorerTheme.option.showJournalTitleInHeader.description',
            'options' => [
                0 => 'plugins.themes.spupLightExplorerTheme.option.showJournalTitleInHeader.hide',
                1 => 'plugins.themes.spupLightExplorerTheme.option.showJournalTitleInHeader.show',
            ],
            'default' => 0,
        ]);

            $this->addOption('approvedIndexingServices', 'text', [
            'label' => 'plugins.themes.spupLightExplorerTheme.option.approvedIndexingServices.label',
            'description' => 'plugins.themes.spupLightExplorerTheme.option.approvedIndexingServices.description',
            'default' => '',
        ]);

        // Add usage stats display options
            $this->addOption('displayStats', 'FieldOptions', [
            'type' => 'radio',
            'label' => __('plugins.themes.spupLightExplorerTheme.option.displayStats.label'),
            'options' => [
                [
                    'value' => 'none',
                    'label' => __('plugins.themes.spupLightExplorerTheme.option.displayStats.none'),
                ],
                [
                    'value' => 'bar',
                    'label' => __('plugins.themes.spupLightExplorerTheme.option.displayStats.bar'),
                ],
                [
                    'value' => 'line',
                    'label' => __('plugins.themes.spupLightExplorerTheme.option.displayStats.line'),
                ],
            ],
            'default' => 'none',
            ]);
        }

        // Calculate secondary colour based on user’s primary colour choice
        $additionalLessVariables = [];
        $primaryColor = $this->getOption('primaryColor');
        if (!preg_match('/^#[0-9a-fA-F]{1,6}$/', (string) $primaryColor)) $primaryColor = '#ffd120'; // pkp/pkp-lib#11974
        if ($primaryColor !== '#ffd120') {
            $additionalLessVariables[] = '
				@primary-colour:' . $primaryColor . ';
				@secondary-colour: darken(@primary-colour, 45%);
			';
        }

        // Update contrast colour based on primary colour
        if ($this->isColourDark($primaryColor)) {
            $additionalLessVariables[] = '
				@contrast-colour: #FFF;
				@secondary-colour: lighten(@primary-colour, 45%);
			';
        }

        // OJS compiles these variables for the active context. Root typography stays unchanged.
        $journalFontPair = $this->getJournalFontPair();
        if ($journalFontPair) {
            $additionalLessVariables[] = '@font-family-primary: ' . $journalFontPair[0] . ';'
                . "\n" . '@font-family-secondary: ' . $journalFontPair[1] . ';';
            $this->addStyle('journalFonts', 'fonts/journals/journal-fonts.css');
        }

        // Importing Bootstrap's and tag-it CSS
        $this->addStyle('app_css', 'resources/app.min.css');

        // Styles for HTML galleys
        $this->addStyle('htmlGalley', 'templates/plugins/generic/htmlArticleGalley/css/default.less', ['contexts' => 'htmlGalley']);
        $this->addStyle('htmlFont', 'less/fonts.less', ['contexts' => 'htmlGalley']);

        $this->addStyle('stylesheet', 'less/import.less');
        $this->modifyStyle('stylesheet', ['addLessVariables' => join("\n", $additionalLessVariables)]);

        // Importing JQuery, Popper, Bootstrap, JQuery-ui, tag-it (own instance), and custom theme's javascript
        $this->addScript('app_js', 'resources/app.min.js');

        // Load icon font Ionicons
        $this->addScript(
            'ionicons',
            $this->getRequest()->getBaseUrl() . '/plugins/themes/spupLightExplorerTheme/resources/ionicons.js',
            ['baseUrl' => '']
        );

        // Adding navigation menu as in OJS 3.1+ we can have custom
        $this->addMenuArea(['primary', 'user']);
        if (!$this->getRequest()->getContext()) {
            $this->addMenuArea(['footerExplore', 'footerInformation']);
        }

        HookRegistry::add('TemplateManager::display', [$this, 'loadAdditionalData']);
        // Get additional issue data to the issue page
        HookRegistry::add('TemplateManager::display', [$this, 'loadIssueData']);
        // Check whether authors have additional info
        HookRegistry::add('TemplateManager::display', [$this, 'hasAuthorsInfo']);
        // Display journal summary on the homepage
        HookRegistry::add('TemplateManager::display', [$this, 'homepageJournalSummary']);
        HookRegistry::add('TemplateManager::display', [$this, 'loadJournalHomepageData']);
        HookRegistry::add('TemplateManager::display', [$this, 'loadRootHomepageData']);
        HookRegistry::add('TemplateManager::display', [$this, 'loadRootCustomBreadcrumbData']);
        HookRegistry::add('TemplateManager::display', [$this, 'prepareRootCustomPageContent']);
        HookRegistry::add('TemplateManager::display', [$this, 'loadAnnouncementSpotlightData']);
        HookRegistry::add('TemplateManager::display', [$this, 'loadRootJournalDirectory']);
        HookRegistry::add('TemplateManager::display', [$this, 'loadArticleMetrics']);
    }

    /** @see ThemePlugin::saveOption */
    public function saveOption($name, $value, $contextId = null) {
        if (in_array($name, ['recentPublicationCount', 'announcementCount'], true)) {
            $allowed = $name === 'recentPublicationCount' ? [3, 4, 5, 6] : [2, 3, 4, 5];
            $value = in_array((int) $value, $allowed, true) ? (int) $value : ($name === 'recentPublicationCount' ? 4 : 3);
        } elseif ($name === 'googleMapsEmbedUrl') {
            $value = $this->getSafeGoogleMapsEmbedUrl((string) $value);
        } elseif (in_array($name, ['networkSubtitle', 'publisherAddress'], true)) {
            $value = mb_substr(trim(strip_tags((string) $value)), 0, $name === 'networkSubtitle' ? 120 : 500);
        } elseif ($name === 'approvedIndexingServices') {
            $names = array_map(static fn ($service) => mb_substr(trim(strip_tags($service)), 0, 80), explode(',', (string) $value));
            $value = implode(', ', array_slice(array_unique(array_filter($names)), 0, 12));
        }
        // Validate the base colour setting value.
        if ($name == 'primaryColor' && !preg_match('/^#[0-9a-fA-F]{1,6}$/', $value)) $value = null; // pkp/pkp-lib#11974
        parent::saveOption($name, $value, $contextId);
    }

    /** Prefer the native journal acronym; retain compatibility with existing context paths. */
    private function getJournalFontPair(): ?array
    {
        $context = $this->getRequest()->getContext();
        if (!$context) {
            return null;
        }

        $acronym = strtolower(trim((string) $context->getLocalizedData('acronym')));
        if (isset(self::JOURNAL_FONT_PAIRS[$acronym])) {
            return self::JOURNAL_FONT_PAIRS[$acronym];
        }

        return self::JOURNAL_FONT_PAIRS[strtolower((string) $context->getPath())] ?? null;
    }

    private function addRootOptions(): void
    {
        $prefix = 'plugins.themes.spupLightExplorerTheme.setting.';
        $yesNo = [1 => $prefix . 'yes', 0 => $prefix . 'no'];
        foreach (['networkSubtitle' => ['text', 'Journal Network'],
            'publisherAddress' => ['text', 'Tuguegarao City, Cagayan 3500, Philippines'],
            'googleMapsEmbedUrl' => ['text', '']] as $name => [$type, $default]) {
            $this->addOption($name, $type, ['label' => $prefix . $name, 'description' => $prefix . $name . '.description', 'default' => $default]);
        }
        foreach (['showNetworkStats' => 1, 'showLatestScholarship' => 1, 'showAnnouncements' => 1,
            'showMapAbout' => 1, 'showMapContact' => 1, 'showMapFooter' => 0,
            'showAboutStats' => 1, 'showAboutJournals' => 1,
            'showAboutPublisher' => 1, 'showAboutSubmission' => 1] as $name => $default) {
            $this->addOption($name, 'radio', ['label' => $prefix . $name, 'options' => $yesNo, 'default' => $default]);
        }
        $this->addOption('recentPublicationCount', 'radio', [
            'label' => $prefix . 'recentPublicationCount',
            'options' => [3 => $prefix . 'count3', 4 => $prefix . 'count4', 5 => $prefix . 'count5', 6 => $prefix . 'count6'],
            'default' => 4,
        ]);
        $this->addOption('announcementCount', 'radio', [
            'label' => $prefix . 'announcementCount',
            'options' => [2 => $prefix . 'count2', 3 => $prefix . 'count3', 4 => $prefix . 'count4', 5 => $prefix . 'count5'],
            'default' => 3,
        ]);
    }

    public function getSafeGoogleMapsEmbedUrl(?string $url): string
    {
        $url = trim((string) $url);
        // Google Maps' "Share > Embed a map" action copies an iframe, not just its URL.
        if (preg_match('/<iframe\b[^>]*\bsrc\s*=\s*(["\'])(.*?)\1/is', $url, $matches)) {
            $url = $matches[2];
        }
        $url = html_entity_decode(trim($url), ENT_QUOTES | ENT_HTML5, 'UTF-8');
        if (!$url || !filter_var($url, FILTER_VALIDATE_URL)) {
            return '';
        }
        $parts = parse_url($url);
        if (!$parts || strtolower($parts['scheme'] ?? '') !== 'https'
            || !in_array(strtolower($parts['host'] ?? ''), ['www.google.com', 'google.com', 'maps.google.com'], true)
            || !in_array($parts['path'] ?? '', ['/maps/embed', '/maps/embed/v1/place', '/maps/embed/v1/search', '/maps/embed/v1/view', '/maps/embed/v1/directions'], true)
            || isset($parts['user']) || isset($parts['pass'])
            || (isset($parts['port']) && $parts['port'] !== 443)) {
            return '';
        }
        return $url;
    }

    private function rootOptionEnabled(string $name): bool
    {
        return (string) $this->getOption($name) === '1';
    }

    private function rootCount(string $name): int
    {
        $allowed = $name === 'recentPublicationCount' ? [3, 4, 5, 6] : [2, 3, 4, 5];
        $value = (int) $this->getOption($name);
        return in_array($value, $allowed, true) ? $value : ($name === 'recentPublicationCount' ? 4 : 3);
    }

    /** Split editor-managed Site About or custom-page HTML into the root About layout. */
    private function getRootAboutSections(string $pageContent, string $siteAbout): array
    {
        $allowed = ['intro', 'story', 'identity', 'structure', 'readers', 'authors', 'platform'];
        $sections = [];
        // A custom About page may override individual sections from Site About.
        foreach ([$siteAbout, $pageContent] as $html) {
            if (!trim($html)) {
                continue;
            }
            $document = new DOMDocument();
            $previous = libxml_use_internal_errors(true);
            $loaded = $document->loadHTML('<?xml encoding="UTF-8"?><div id="spup-about-content">' . $html . '</div>');
            libxml_clear_errors();
            libxml_use_internal_errors($previous);
            if (!$loaded) {
                continue;
            }
            $xpath = new DOMXPath($document);
            foreach ($allowed as $key) {
                $nodes = $xpath->query('//*[@id="spup-about-' . $key . '" or @data-spup-about="' . $key . '"]');
                if (!$nodes || !$nodes->length) {
                    continue;
                }
                $fragment = '';
                foreach ($nodes->item(0)->childNodes as $child) {
                    $fragment .= $document->saveHTML($child);
                }
                if (trim(strip_tags($fragment))) {
                    $sections[$key] = $fragment;
                }
            }
        }
        return $sections;
    }

    /** Reuse each journal's saved theme colour in its root directory and cover frame. */
    private function getJournalAccentColors(array $journals): array
    {
        $settings = DAORegistry::getDAO('PluginSettingsDAO');
        $colors = [];
        foreach ($journals as $journal) {
            $color = (string) $settings->getSetting($journal->getId(), $this->getName(), 'primaryColor');
            $colors[$journal->getId()] = preg_match('/^#(?:[0-9a-fA-F]{3}|[0-9a-fA-F]{6})$/', $color)
                ? $color : '#0B6B43';
        }
        return $colors;
    }

    /** Only enabled journals are eligible for the public network views. */
    private function getEnabledJournals(): array
    {
        return DAORegistry::getDAO('JournalDAO')->getAll(true)->toArray();
    }

    public function getDisplayName(): string
    {
        return __('plugins.themes.spupLightExplorerTheme.name');
    }

    public function getDescription(): string
    {
        return __('plugins.themes.spupLightExplorerTheme.description');
    }

    /** Preserve OJS route parameters when a GET search form submits a query. */
    public function getSearchFormParameters(string $url): array
    {
        $query = parse_url($url, PHP_URL_QUERY);
        if (!is_string($query) || $query === '') {
            return [];
        }

        parse_str($query, $parameters);
        return array_filter($parameters, 'is_scalar');
    }

    /** Return safe plain text for the root journal directory preview. */
    public function getJournalDescriptionPreview(?string $description, int $maxCharacters = 360): string
    {
        if (!$description) {
            return '';
        }

        $withoutScripts = preg_replace('~<(script|style)\b[^>]*>.*?</\1\s*>~is', ' ', $description) ?? $description;
        $withSpacing = preg_replace('~</?(?:p|div|br|li|ul|ol|h[1-6]|section|article)\b[^>]*>~i', ' ', $withoutScripts) ?? $withoutScripts;
        $plainText = html_entity_decode(strip_tags($withSpacing), ENT_QUOTES | ENT_HTML5, 'UTF-8');

        $preview = trim(preg_replace('/\s+/u', ' ', $plainText) ?? $plainText);
        if (mb_strlen($preview) <= $maxCharacters) {
            return $preview;
        }

        $cut = mb_substr($preview, 0, $maxCharacters + 1);
        $lastSpace = mb_strrpos($cut, ' ');
        if ($lastSpace !== false && $lastSpace > (int) ($maxCharacters * 0.6)) {
            $cut = mb_substr($cut, 0, $lastSpace);
        } else {
            $cut = mb_substr($cut, 0, $maxCharacters);
        }
        return rtrim($cut, " ,.;:") . '…';
    }

    /** Use the journal's first two configured paragraphs without repeating its full About page. */
    public function getJournalHomepageIntro(?string $description): array
    {
        $paragraphs = [];
        if ($description) {
            $safeHtml = preg_replace('~<(script|style)\b[^>]*>.*?</\1\s*>~is', ' ', $description) ?? $description;
            preg_match_all('~<p\b[^>]*>(.*?)</p>~is', $safeHtml, $matches);
            foreach ($matches[1] as $html) {
                $plain = html_entity_decode(strip_tags($html), ENT_QUOTES | ENT_HTML5, 'UTF-8');
                $plain = trim(preg_replace('/\s+/u', ' ', $plain) ?? $plain);
                if ($plain !== '' && !in_array($plain, $paragraphs, true)) {
                    $paragraphs[] = $plain;
                }
                if (count($paragraphs) === 2) break;
            }
        }
        return [
            'summary' => $paragraphs[0] ?? $this->getJournalDescriptionPreview($description, 360),
            'about' => $paragraphs[1] ?? '',
        ];
    }

    /** Use OJS author data without requiring a per-result user-group query. */
    public function getPublicationAuthors($publication): string
    {
        return $publication->getAuthorString(collect());
    }

    /** Collect the same published-submission shape for root and journal lists. */
    private function getRecentPublications(array $contextIds, int $limit, array $journalById = []): array
    {
        if (!$contextIds) {
            return [];
        }

        $recentPublications = [];
        $submissions = Repo::submission()->getCollector()
            ->filterByContextIds($contextIds)
            ->filterByStatus([Submission::STATUS_PUBLISHED])
            ->orderBy(SubmissionCollector::ORDERBY_DATE_PUBLISHED)
            ->limit($limit)
            ->getMany();

        foreach ($submissions as $submission) {
            $publication = $submission->getCurrentPublication();
            $journal = $journalById[$submission->getData('contextId')] ?? null;
            if (!$publication || ($journalById && !$journal)) {
                continue;
            }
            $recentPublications[] = [
                'submission' => $submission,
                'publication' => $publication,
                'journal' => $journal,
                'authors' => $this->getPublicationAuthors($publication),
                'datePublished' => $publication->getData('datePublished'),
            ];
        }
        return $recentPublications;
    }

    /** Counts use the same published OJS collectors in both contexts. */
    private function getPublishedCounts(array $contextIds): array
    {
        if (!$contextIds) {
            return ['articles' => 0, 'issues' => 0];
        }
        return [
            'articles' => Repo::submission()->getCollector()
                ->filterByContextIds($contextIds)
                ->filterByStatus([Submission::STATUS_PUBLISHED])
                ->getCount(),
            'issues' => Repo::issue()->getCollector()
                ->filterByContextIds($contextIds)
                ->filterByPublished(true)
                ->getCount(),
        ];
    }

    public function loadAdditionalData($hookName, $args)
    {
        $smarty = $args[0];

        if (!isset($smarty->registered_plugins['modifier']['spup_dashboard_title'])) {
            $smarty->registerPlugin('modifier', 'spup_dashboard_title', [$this, 'formatDashboardNavigationTitle']);
        }

        if ($args[1] === 'user/userPasswordReset.tpl') {
            $smarty->assign('pageTitle', __('user.login.resetPassword'));
        }

        $request = $this->getRequest();
        $context = $request->getContext();

        if (!defined('SESSION_DISABLE_INIT')) {
            // Get possible locales
            if ($context) {
                $locales = $context->getSupportedLocaleNames();
            } else {
                $locales = $request->getSite()->getSupportedLocaleNames();
            }

            $smarty->assign([
                'languageToggleLocales' => $locales
            ]);
        }

        $smarty->assign([
            'spupInstitutionalUrl' => self::INSTITUTIONAL_URL,
            'spupNetworkTitle' => $request->getSite()->getLocalizedData('title'),
            'spupNetworkLogo' => $request->getSite()->getLocalizedData('pageHeaderTitleImage'),
        ]);
        if (!$context) {
            $site = $request->getSite();
            $smarty->assign([
                'spupFooterContactEmail' => $site->getLocalizedData('contactEmail'),
                'spupSiteAbout' => $site->getLocalizedAbout(),
                'spupInstitutionalUrl' => self::INSTITUTIONAL_URL,
                'spupRootOptions' => [
                    'networkSubtitle' => $this->getOption('networkSubtitle') ?: 'Journal Network',
                    'publisherAddress' => $this->getOption('publisherAddress'),
                    'mapUrl' => $this->getSafeGoogleMapsEmbedUrl($this->getOption('googleMapsEmbedUrl')),
                    'showNetworkStats' => $this->rootOptionEnabled('showNetworkStats'),
                    'showLatestScholarship' => $this->rootOptionEnabled('showLatestScholarship'),
                    'showAnnouncements' => $this->rootOptionEnabled('showAnnouncements'),
                    'showMapAbout' => $this->rootOptionEnabled('showMapAbout'),
                    'showMapContact' => $this->rootOptionEnabled('showMapContact'),
                    'showMapFooter' => $this->rootOptionEnabled('showMapFooter'),
                    'showAboutStats' => $this->rootOptionEnabled('showAboutStats'),
                    'showAboutJournals' => $this->rootOptionEnabled('showAboutJournals'),
                    'showAboutPublisher' => $this->rootOptionEnabled('showAboutPublisher'),
                    'showAboutSubmission' => $this->rootOptionEnabled('showAboutSubmission'),
                ],
            ]);
        } else {
            $smarty->assign('spupShowJournalTitleInHeader', (string) $this->getOption('showJournalTitleInHeader') === '1');
        }
    }

    /** Preserve only the numeric badge prepared by OJS's dashboard menu template. */
    public function formatDashboardNavigationTitle($title): string
    {
        $title = (string) $title;
        $count = null;
        if (preg_match('~\A(.*?)\s*<span class="task_count">\s*([0-9]+)\s*</span>\s*\z~s', $title, $match)) {
            $title = $match[1];
            $count = $match[2];
        }
        $label = htmlspecialchars(
            html_entity_decode(trim($title), ENT_QUOTES | ENT_HTML5, 'UTF-8'),
            ENT_QUOTES | ENT_SUBSTITUTE,
            'UTF-8'
        );
        return $label . ($count !== null ? ' <span class="task_count">' . $count . '</span>' : '');
    }

    /** Display only recorded, article-specific OJS usage totals. */
    public function loadArticleMetrics($hookName, $args)
    {
        if ($args[1] !== 'frontend/pages/article.tpl') {
            return false;
        }
        $templateMgr = $args[0];
        $article = $templateMgr->getTemplateVars('article');
        $context = $this->getRequest()->getContext();
        if (!$article || !$context) {
            return false;
        }
        $totals = app()->get('publicationStats')->getTotalsByType(
            $article->getId(),
            $context->getId(),
            null,
            null
        );
        $abstract = (int) ($totals['abstract'] ?? 0);
        // HTML galley views are page views, while file and supplementary requests are downloads.
        $downloads = (int) ($totals['pdf'] ?? 0)
            + (int) ($totals['other'] ?? 0)
            + (int) ($totals['suppFileViews'] ?? 0);
        // A zero-filled response does not establish that statistics have been recorded.
        $templateMgr->assign('spupArticleMetrics', ($abstract || $downloads)
            ? ['abstract' => $abstract, 'downloads' => $downloads]
            : null);
        return false;
    }

    public function loadIssueData($hookName, $args)
    {
        $templateMgr = $args[0];
        $template = $args[1];

        // Return false if not an issue or journal landing page
        if ($template !== 'frontend/pages/issue.tpl' && $template !== 'frontend/pages/indexJournal.tpl') {
            return false;
        }

        $issue = $templateMgr->getTemplateVars('issue');

        if (empty($issue)) {
            return false;
        }

        $issueIdentificationString = null;

        if ($issue->getVolume() && $issue->getShowVolume()) {
            $issueIdentificationString .= __('plugins.themes.spupLightExplorerTheme.volume-abbr') . " " . $issue->getVolume();
        }
        if ($issue->getNumber() && $issue->getShowNumber()) {
            if ($issue->getVolume() && $issue->getShowVolume()) {
                $issueIdentificationString .= ", ";
            }
            $issueIdentificationString .= __('plugins.themes.spupLightExplorerTheme.number-abbr') . " " . $issue->getNumber();
        }
        if ($issue->getYear() && $issue->getShowYear()) {
            if ($issueIdentificationString !== null) {
                $issueIdentificationString .= " (" . $issue->getYear() . ")";
            } else {
                $issueIdentificationString .= $issue->getYear();
            }
        }
        if ($issue->getLocalizedTitle() && $issue->getShowTitle()) {
            if ($issueIdentificationString !== null) {
                $issueIdentificationString .= ": " . $issue->getLocalizedTitle();
            } else {
                $issueIdentificationString .= $issue->getLocalizedTitle();
            }
        }

        $templateMgr->assign('issueIdentificationString', $issueIdentificationString);
    }

    public function hasAuthorsInfo($hookName, $args)
    {
        $templateMgr = $args[0];
        $template = $args[1];

        // Return false if not an article page
        if ($template !== 'frontend/pages/article.tpl') {
            return false;
        }

        /** @var Publication $publication */
        $publication = $templateMgr->getTemplateVars('publication');

        // Check if there is additional info on any of authors
        $boolAuthorInfo = false;
        foreach ($publication->getData('authors') as $author) {
            if ($author->getLocalizedData('affiliations') || $author->getLocalizedData('biography')) {
                $boolAuthorInfo = true;
                break;
            }
        }

        $templateMgr->assign('boolAuthorInfo', $boolAuthorInfo);
    }

    public function homepageJournalSummary($hookName, $args)
    {
        $templateMgr = $args[0];
        $template = $args[1];

        if ($template !== "frontend/pages/indexJournal.tpl") {
            return false;
        }

        $templateMgr->assign([
            'showJournalSummary' => $this->getOption('journalSummary'),
        ]);
    }

    /** Load only the active journal's published content and curated OJS menu links. */
    public function loadJournalHomepageData($hookName, $args)
    {
        if ($args[1] !== 'frontend/pages/indexJournal.tpl') {
            return false;
        }
        $context = $this->getRequest()->getContext();
        if (!$context) {
            return false;
        }
        $contextId = $context->getId();
        $recentPublications = $this->getRecentPublications([$contextId], 4);
        $stats = $this->getPublishedCounts([$contextId]);

        $menuItems = [];
        $menu = DAORegistry::getDAO('NavigationMenuDAO')->getByArea($contextId, 'primary')->next();
        if ($menu) {
            (new \PKP\services\PKPNavigationMenuService())->getMenuTree($menu);
            foreach ($menu->menuTree as $assignment) {
                foreach (array_merge([$assignment], $assignment->children ?? []) as $entry) {
                    $item = $entry->getMenuItem();
                    if (!$item || !$item->getIsDisplayed() || !$item->getUrl() || !$item->getLocalizedTitle()) {
                        continue;
                    }
                    $key = $item->getType() === 'NMI_TYPE_CUSTOM'
                        ? 'path:' . $item->getPath() : 'type:' . $item->getType();
                    $menuItems[$key] ??= [
                        'title' => $item->getLocalizedTitle(),
                        'url' => $item->getUrl(),
                    ];
                }
            }
        }
        $selectLinks = static function (array $keys) use ($menuItems): array {
            $links = [];
            foreach ($keys as $key) {
                if (isset($menuItems[$key])) {
                    $links[] = $menuItems[$key];
                }
            }
            return $links;
        };

        // Audience pages can exist as OJS custom pages without being assigned to the primary menu.
        $audienceLinks = [];
        $itemDao = DAORegistry::getDAO('NavigationMenuItemDAO');
        foreach (['for-readers', 'for-authors', 'for-librarians'] as $path) {
            $item = $itemDao->getByPath($contextId, $path);
            if ($item && $item->getLocalizedTitle() && $item->getUrl()) {
                $audienceLinks[] = ['title' => $item->getLocalizedTitle(), 'url' => $item->getUrl()];
            }
        }

        // Discovery platforms mentioned on a custom page do not establish coverage.
        $approvedIndexing = (string) $this->getOption('approvedIndexingServices');
        $indexingServices = array_values(array_filter(array_map('trim', explode(',', $approvedIndexing))));

        $args[0]->assign([
            'spupJournalRecentPublications' => $recentPublications,
            'spupJournalStats' => $stats,
            'spupJournalAuthorLinks' => $selectLinks([
                'path:guide-for-authors', 'type:NMI_TYPE_SUBMISSIONS',
                'path:publication-ethics', 'path:copyright-and-licensing', 'path:copyrigth-and-licensing',
            ]),
            'spupJournalInformationLinks' => $selectLinks([
                'path:focus-and-scope', 'type:NMI_TYPE_ABOUT', 'path:editorial',
                'path:peer-review', 'path:open-access', 'type:NMI_TYPE_CONTACT',
            ]),
            'spupJournalAudienceLinks' => $audienceLinks,
            'spupJournalIndexingServices' => array_slice($indexingServices, 0, 12),
        ]);
        return false;
    }

    /** Derive root custom-page breadcrumb ancestry from the assigned OJS primary menu. */
    public function loadRootCustomBreadcrumbData($hookName, $args)
    {
        if ($args[1] !== 'frontend/pages/navigationMenuItemViewContent.tpl' || $this->getRequest()->getContext()) {
            return false;
        }

        $path = (string) $args[0]->getTemplateVars('requestedPage');
        $title = (string) $args[0]->getTemplateVars('title');
        if ($path === '' || $title === '') {
            return false;
        }

        $menu = DAORegistry::getDAO('NavigationMenuDAO')->getByArea(null, 'primary')->next();
        if (!$menu) {
            return false;
        }
        (new \PKP\services\PKPNavigationMenuService())->getMenuTree($menu);
        foreach ($menu->menuTree as $parentAssignment) {
            $parent = $parentAssignment->getMenuItem();
            if (!$parent || !$parent->getIsDisplayed()) {
                continue;
            }
            foreach ($parentAssignment->children ?? [] as $childAssignment) {
                $child = $childAssignment->getMenuItem();
                if (!$child || !$child->getIsDisplayed() || strcasecmp((string) $child->getPath(), $path) !== 0) {
                    continue;
                }
                $parentUrl = (string) $parent->getUrl();
                $parentTitle = (string) $parent->getLocalizedTitle();
                if ($parentUrl !== '' && $parentTitle !== '') {
                    $args[0]->assign('spupRootBreadcrumbItems', [
                        ['label' => $parentTitle, 'url' => $parentUrl],
                        ['label' => $title, 'current' => true],
                    ]);
                }
                return false;
            }
        }
        return false;
    }

    /** Remove only a leading rich-content H1 that exactly repeats the OJS page title. */
    public function prepareRootCustomPageContent($hookName, $args)
    {
        if ($args[1] !== 'frontend/pages/navigationMenuItemViewContent.tpl'
            && !$this->isStaticPagesContentTemplate((string) $args[1])) {
            return false;
        }

        $content = (string) $args[0]->getTemplateVars('content');
        $title = (string) $args[0]->getTemplateVars('title');
        if (preg_match('~^\s*<h1\b[^>]*>(.*?)</h1>~is', $content, $match)) {
            $normalize = static function (string $value): string {
                $value = html_entity_decode(strip_tags($value), ENT_QUOTES | ENT_HTML5, 'UTF-8');
                return mb_strtolower(trim(preg_replace('/\s+/u', ' ', $value) ?? $value), 'UTF-8');
            };
            if ($normalize($match[1]) === $normalize($title)) {
                $content = substr($content, strlen($match[0]));
            }
        }
        $args[0]->assign($this->getRequest()->getContext() ? 'spupJournalCustomContent' : 'spupRootCustomContent', $content);
        return false;
    }

    /** Static Pages displays a plugin resource name rather than a frontend/pages path. */
    private function isStaticPagesContentTemplate(string $template): bool
    {
        return $template === 'plugins/generic/staticPages/templates/content.tpl'
            || (str_contains($template, 'staticPages') && str_ends_with($template, 'content.tpl'));
    }

    /** Match the public OJS announcement context, dates, and expiry rules. */
    private function getVisibleAnnouncementQuery(?int $contextId)
    {
        $query = Announcement::query()->where('assoc_type', Application::get()->getContextAssocType());
        $contextId === null ? $query->whereNull('assoc_id') : $query->where('assoc_id', $contextId);

        return $query->where('date_posted', '<=', now())
            ->where(function ($query) {
                $query->whereNull('date_expire')->orWhere('date_expire', '>', now());
            })
            ->orderByDesc('date_posted')
            ->orderByDesc('announcement_id');
    }

    /** The cookie mirrors localStorage IDs so the server only loads unseen records. */
    private function getSpotlightSeenIds(string $contextKey): array
    {
        $raw = $_COOKIE['spupAnnouncementSeenIds_' . $contextKey] ?? '';
        if (!is_string($raw) || strlen($raw) > 3500) {
            return [];
        }
        $ids = [];
        foreach (explode(',', $raw) as $value) {
            if (preg_match('/^[1-9][0-9]{0,9}$/', $value)) {
                $ids[] = (int) $value;
            }
        }
        return array_values(array_unique($ids));
    }

    private function getSpotlightExcerpt(string $html): string
    {
        $plain = trim(preg_replace('/\s+/u', ' ', html_entity_decode(strip_tags($html), ENT_QUOTES | ENT_HTML5, 'UTF-8')) ?? '');
        return mb_strimwidth($plain, 0, 320, '…', 'UTF-8');
    }

    /** Supply one context-scoped spotlight to every public page with a footer. */
    public function loadAnnouncementSpotlightData($hookName, $args)
    {
        if (!str_starts_with((string) $args[1], 'frontend/pages/')
            && !$this->isStaticPagesContentTemplate((string) $args[1])) {
            return false;
        }

        $request = $this->getRequest();
        $context = $request->getContext();
        $owner = $context ?? $request->getSite();
        if (!$owner || !$owner->getData('enableAnnouncements')) {
            return false;
        }

        $contextKey = $context ? strtolower((string) $context->getPath()) : 'root';
        $contextKey = preg_replace('/[^a-z0-9_-]/', '', $contextKey);
        $query = $this->getVisibleAnnouncementQuery($context?->getId());
        $seenIds = $this->getSpotlightSeenIds($contextKey);
        if ($seenIds) {
            $query->whereNotIn('announcement_id', $seenIds);
        }

        $typeDao = DAORegistry::getDAO('AnnouncementTypeDAO');
        $items = [];
        foreach ($query->limit(3)->get() as $announcement) {
            $type = $announcement->typeId ? $typeDao->getById((int) $announcement->typeId) : null;
            $short = (string) $announcement->getLocalizedData('descriptionShort');
            $items[] = [
                'id' => (int) $announcement->id,
                'title' => (string) $announcement->getLocalizedData('title'),
                'datePosted' => $announcement->datePosted,
                'excerpt' => $this->getSpotlightExcerpt($short ?: (string) $announcement->getLocalizedData('description')),
                'category' => $type ? (string) $type->getLocalizedTypeName() : '',
                'imageUrl' => $announcement->image ? (string) $announcement->imageUrl : '',
                'imageAlt' => $announcement->image ? (string) $announcement->imageAltText : '',
            ];
        }

        $args[0]->assign([
            'spupSpotlightAnnouncements' => $items,
            'spupSpotlightContextKey' => $contextKey,
        ]);
        return false;
    }

    /** Load bounded OJS network data for the public root pages that use it. */
    public function loadRootHomepageData($hookName, $args)
    {
        if ($this->getRequest()->getContext()) {
            return false;
        }
        $isHomepage = $args[1] === 'frontend/pages/indexSite.tpl';
        $isCustomPage = $args[1] === 'frontend/pages/navigationMenuItemViewContent.tpl';
        $isAbout = $isCustomPage && in_array($this->getRequest()->getRequestedPage(), ['about', 'publisher-about'], true);
        $isSubmission = $isCustomPage && in_array($this->getRequest()->getRequestedPage(), ['publisher-submit', 'submission'], true);
        if (!$isHomepage && !$isAbout && !$isSubmission) {
            return false;
        }

        $journals = $this->getEnabledJournals();
        $journalIds = array_map(static fn ($journal) => $journal->getId(), $journals);
        $stats = [
            'journals' => count($journals),
            'articles' => 0,
            'issues' => 0,
        ];
        $recentPublications = [];
        $needsStats = ($isHomepage && $this->rootOptionEnabled('showNetworkStats'))
            || ($isAbout && $this->rootOptionEnabled('showAboutStats'));
        $needsRecent = $isHomepage && $this->rootOptionEnabled('showLatestScholarship');
        if ($journalIds && $needsStats) {
            $stats = array_merge($stats, $this->getPublishedCounts($journalIds));
        }

        if ($journalIds && $needsRecent) {
            $journalById = [];
            foreach ($journals as $journal) {
                $journalById[$journal->getId()] = $journal;
            }
            $recentPublications = $this->getRecentPublications(
                $journalIds,
                $this->rootCount('recentPublicationCount'),
                $journalById
            );
        }

        // OJS supports site-wide announcements (a null association ID).
        $announcements = [];
        if ($isHomepage && $this->rootOptionEnabled('showAnnouncements')) {
            $announcements = $this->getVisibleAnnouncementQuery(null)
                ->limit($this->rootCount('announcementCount'))
                ->get();
        }

        $args[0]->assign([
            'spupNetworkStats' => $stats,
            'spupRecentPublications' => $recentPublications,
            'spupNetworkAnnouncements' => $announcements,
            'spupPublisherJournals' => $journals,
            'spupJournalAccentColors' => $this->getJournalAccentColors($journals),
            'journalFilesPath' => $this->getRequest()->getBaseUrl() . '/' . Config::getVar('files', 'public_files_dir') . '/journals/',
            'spupAboutSections' => $isAbout ? $this->getRootAboutSections(
                (string) $args[0]->getTemplateVars('content'),
                (string) $this->getRequest()->getSite()->getLocalizedAbout()
            ) : [],
        ]);
        return false;
    }

    /** Populate the root Journals navigation page from enabled OJS journals. */
    public function loadRootJournalDirectory($hookName, $args)
    {
        if ($args[1] !== 'frontend/pages/navigationMenuItemViewContent.tpl'
            || $this->getRequest()->getContext()
            || $this->getRequest()->getRequestedPage() !== 'journals') {
            return false;
        }

        $journals = $this->getEnabledJournals();
        $args[0]->assign([
            'spupDirectoryJournals' => $journals,
            'spupJournalAccentColors' => $this->getJournalAccentColors($journals),
            'journalFilesPath' => $this->getRequest()->getBaseUrl() . '/' . Config::getVar('files', 'public_files_dir') . '/journals/',
        ]);
        return false;
    }
}
