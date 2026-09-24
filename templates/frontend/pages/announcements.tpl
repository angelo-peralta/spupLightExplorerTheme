{**
 * templates/frontend/pages/announcements.tpl
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2003-2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Display the page to view the latest announcements
 *
 * @uses $announcements array List of announcements
 *}

{include file="frontend/components/header.tpl" pageTitle="announcement.announcements"}

<main class="page page_announcements">
	<div class="container-fluid container-page container-narrow">
		{if !$currentContext}<p class="spup-page-eyebrow">{translate key="plugins.themes.spupLightExplorerTheme.root.announcementsEyebrow"}</p>{/if}
		{include file="frontend/components/headings.tpl" currentTitleKey="announcement.announcements"}
		{include file="frontend/components/editLink.tpl" page="management" op="settings" path="announcements" anchor="announcements" sectionTitleKey="announcement.announcements"}

		<div class="announcements-introduction">
			{if $announcementsIntroduction}{$announcementsIntroduction|strip_unsafe_html}{elseif !$currentContext}{translate key="plugins.themes.spupLightExplorerTheme.root.announcementsIntro"}{/if}
		</div>

		{if !$announcements|@count && !$currentContext}<p class="spup-empty-state">{translate key="plugins.themes.spupLightExplorerTheme.root.noAnnouncements"}</p>{/if}
		{include file="frontend/components/announcements.tpl"}
	</div>
</main><!-- .page -->

{include file="frontend/components/footer.tpl"}
