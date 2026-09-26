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
        HookRegistry::add('TemplateManager::display', [$this, 'loadRootHomepageData']);
        HookRegistry::add('TemplateManager::display', [$this, 'loadRootJournalDirectory']);
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
        }
        // Validate the base colour setting value.
        if ($name == 'primaryColor' && !preg_match('/^#[0-9a-fA-F]{1,6}$/', $value)) $value = null; // pkp/pkp-lib#11974
        parent::saveOption($name, $value, $contextId);
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

    /** Use OJS author data without requiring a per-result user-group query. */
    public function getPublicationAuthors($publication): string
    {
        return $publication->getAuthorString(collect());
    }

    public function loadAdditionalData($hookName, $args)
    {
        $smarty = $args[0];

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

        $journalDao = DAORegistry::getDAO('JournalDAO');
        $journals = $journalDao->getAll(true)->toArray();
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
            $submissions = Repo::submission()->getCollector()
                ->filterByContextIds($journalIds)
                ->filterByStatus([Submission::STATUS_PUBLISHED]);
            $stats['articles'] = $submissions->getCount();
            $stats['issues'] = Repo::issue()->getCollector()
                ->filterByContextIds($journalIds)
                ->filterByPublished(true)
                ->getCount();
        }

        if ($journalIds && $needsRecent) {
            $journalById = [];
            foreach ($journals as $journal) {
                $journalById[$journal->getId()] = $journal;
            }
            $recent = Repo::submission()->getCollector()
                ->filterByContextIds($journalIds)
                ->filterByStatus([Submission::STATUS_PUBLISHED])
                ->orderBy(SubmissionCollector::ORDERBY_DATE_PUBLISHED)
                ->limit($this->rootCount('recentPublicationCount'))
                ->getMany();
            foreach ($recent as $submission) {
                $publication = $submission->getCurrentPublication();
                $journal = $journalById[$submission->getData('contextId')] ?? null;
                if (!$publication || !$journal) {
                    continue;
                }
                $recentPublications[] = [
                    'submission' => $submission,
                    'publication' => $publication,
                    'journal' => $journal,
                    'authors' => $publication->getAuthorString(collect()),
                    'datePublished' => $publication->getData('datePublished'),
                ];
            }
        }

        // OJS supports site-wide announcements (a null association ID).
        $announcements = [];
        if ($isHomepage && $this->rootOptionEnabled('showAnnouncements')) {
            $announcements = Announcement::query()
                ->where('assoc_type', Application::get()->getContextAssocType())
                ->whereNull('assoc_id')
                ->where('date_posted', '<=', now())
                ->where(function ($query) {
                    $query->whereNull('date_expire')->orWhere('date_expire', '>', now());
                })
                ->orderByDesc('date_posted')
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

        $journals = DAORegistry::getDAO('JournalDAO')->getAll(true)->toArray();
        $args[0]->assign([
            'spupDirectoryJournals' => $journals,
            'spupJournalAccentColors' => $this->getJournalAccentColors($journals),
            'journalFilesPath' => $this->getRequest()->getBaseUrl() . '/' . Config::getVar('files', 'public_files_dir') . '/journals/',
        ]);
        return false;
    }
}
