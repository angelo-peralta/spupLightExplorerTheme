{**
 * templates/frontend/pages/announcements.tpl
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2003-2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Display the page which represents a single announcement
 *
 * @uses $announcement Announcement The announcement to display
 *}
{include file="frontend/components/header.tpl" pageTitleTranslated=$announcement->getLocalizedData('title')|escape}

<main class="page page_announcement">
	<div class="container-fluid container-page container-narrow">
		{capture assign="spupAnnouncementsUrl"}{url page="announcement" escape=false}{/capture}
		{capture assign="spupAnnouncementsLabel"}{translate key="announcement.announcements"}{/capture}
		{include file="frontend/components/spup/layout/breadcrumbs.tpl" items=[['label'=>$spupAnnouncementsLabel,'url'=>$spupAnnouncementsUrl],['label'=>$announcement->getLocalizedData('title'),'current'=>true]]}
		{* Display book details *}
		{include file="frontend/objects/announcement_full.tpl"}
		{if !$currentContext}<a class="spup-text-link" href="{$spupAnnouncementsUrl|escape}">{translate key="announcement.announcements"} <span aria-hidden="true">&rarr;</span></a>{/if}
	</div>
</main><!-- .page -->

{include file="frontend/components/footer.tpl"}
