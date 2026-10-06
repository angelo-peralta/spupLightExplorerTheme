{**
 * templates/frontend/pages/article.tpl
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2003-2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Display the page to view an article with all of it's details.
 *
 * @uses $article Submission This article
 * @uses $publication Publication The publication being displayed
 * @uses $firstPublication Publication The first published version of this article
 * @uses $currentPublication Publication The most recently published version of this article
 * @uses $issue Issue The issue this article is assigned to
 * @uses $section Section The journal section this article is assigned to
 * @uses $journal Journal The journal currently being viewed.
 * @uses $primaryGalleys array List of article galleys that are not supplementary or dependent
 * @uses $supplementaryGalleys array List of article galleys that are supplementary
 *}

{include file="frontend/components/header.tpl" pageTitleTranslated=$publication->getLocalizedTitle()|escape}

<main class="page page_article">
	<div class="container-fluid container-page">
		{assign var=spupArticleBreadcrumbs value=[]}
		{if $issue}
			{capture assign=spupArchiveLabel}{translate key="archive.archives"}{/capture}
			{capture assign=spupArchiveUrl}{url page="issue" op="archive" escape=false}{/capture}
			{capture assign=spupIssueUrl}{url page="issue" op="view" path=$issue->getBestIssueId() escape=false}{/capture}
			{append var=spupArticleBreadcrumbs value=['label'=>$spupArchiveLabel, 'url'=>$spupArchiveUrl]}
			{append var=spupArticleBreadcrumbs value=['label'=>$issue->getIssueIdentification(), 'url'=>$spupIssueUrl]}
		{/if}
		{append var=spupArticleBreadcrumbs value=['label'=>$publication->getLocalizedFullTitle(null, 'text'), 'current'=>true]}
		{include file="frontend/components/spup/layout/breadcrumbs.tpl" items=$spupArticleBreadcrumbs}

		{* Show article overview *}
		{include file="frontend/objects/article_details.tpl"}

	</div>

</main><!-- .page -->

{include file="frontend/components/footer.tpl"}
