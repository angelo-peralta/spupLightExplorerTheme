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
use PKP\db\DAORegistry;
use PKP\plugins\ThemePlugin;

class SpupLightExplorerThemePlugin extends ThemePlugin
{
    public function init()
    {
        /* Additional theme options */
        // Changing theme primary color
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
    }

    /** @see ThemePlugin::saveOption */
    public function saveOption($name, $value, $contextId = null) {
        // Validate the base colour setting value.
        if ($name == 'primaryColor' && !preg_match('/^#[0-9a-fA-F]{1,6}$/', $value)) $value = null; // pkp/pkp-lib#11974
        parent::saveOption($name, $value, $contextId);
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
    public function getJournalDescriptionPreview(?string $description): string
    {
        if (!$description) {
            return '';
        }

        $withoutScripts = preg_replace('~<(script|style)\b[^>]*>.*?</\1\s*>~is', ' ', $description) ?? $description;
        $withSpacing = preg_replace('~</?(?:p|div|br|li|ul|ol|h[1-6]|section|article)\b[^>]*>~i', ' ', $withoutScripts) ?? $withoutScripts;
        $plainText = html_entity_decode(strip_tags($withSpacing), ENT_QUOTES | ENT_HTML5, 'UTF-8');

        return trim(preg_replace('/\s+/u', ' ', $plainText) ?? $plainText);
    }

    /** Use OJS author data without requiring a per-result user-group query. */
    public function getPublicationAuthors($publication): string
    {
        return $publication->getAuthorString(collect());
    }

    public function loadAdditionalData($hookName, $args)
    {
        $smarty = $args[0];

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
            $smarty->assign('spupFooterContactEmail', $request->getSite()->getLocalizedData('contactEmail'));
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

    /** Load bounded network data only for the public site homepage. */
    public function loadRootHomepageData($hookName, $args)
    {
        if ($args[1] !== 'frontend/pages/indexSite.tpl' || $this->getRequest()->getContext()) {
            return false;
        }

        $journalDao = DAORegistry::getDAO('JournalDAO');
        $journals = $journalDao->getAll(true)->toArray();
        $journalIds = array_map(static fn ($journal) => $journal->getId(), $journals);
        $journalById = [];
        foreach ($journals as $journal) {
            $journalById[$journal->getId()] = $journal;
        }

        $stats = [
            'journals' => count($journals),
            'articles' => 0,
            'issues' => 0,
        ];
        $recentPublications = [];
        if ($journalIds) {
            $submissions = Repo::submission()->getCollector()
                ->filterByContextIds($journalIds)
                ->filterByStatus([Submission::STATUS_PUBLISHED]);
            $stats['articles'] = $submissions->getCount();
            $stats['issues'] = Repo::issue()->getCollector()
                ->filterByContextIds($journalIds)
                ->filterByPublished(true)
                ->getCount();

            $recent = Repo::submission()->getCollector()
                ->filterByContextIds($journalIds)
                ->filterByStatus([Submission::STATUS_PUBLISHED])
                ->orderBy(SubmissionCollector::ORDERBY_DATE_PUBLISHED)
                ->limit(4)
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
        $announcements = Announcement::query()
            ->where('assoc_type', Application::get()->getContextAssocType())
            ->whereNull('assoc_id')
            ->where('date_posted', '<=', now())
            ->where(function ($query) {
                $query->whereNull('date_expire')->orWhere('date_expire', '>', now());
            })
            ->orderByDesc('date_posted')
            ->limit(3)
            ->get();

        $args[0]->assign([
            'spupNetworkStats' => $stats,
            'spupRecentPublications' => $recentPublications,
            'spupNetworkAnnouncements' => $announcements,
        ]);
        return false;
    }
}
