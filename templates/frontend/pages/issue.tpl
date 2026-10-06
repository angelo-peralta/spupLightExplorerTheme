{**
 * templates/frontend/pages/issue.tpl
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2003-2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Display a landing page for a single issue. It will show the table of contents
 *  (toc) or a cover image, with a click through to the toc.
 *
 * @uses $issue Issue The issue
 * @uses $issueIdentification string Label for this issue, consisting of one or
 *       more of the volume, number, year and title, depending on settings
 * @uses $issueIdentificationString string custom label for the issue, developed for the Traditional theme
 * @uses $issueGalleys array Galleys for the entire issue
 * @uses $primaryGenreIds array List of file genre IDs for primary types
 *}

{include file="frontend/components/header.tpl" pageTitleTranslated=$issueIdentification|escape}

<main class="page page_issue">
	<div class="container-fluid container-page">

		{* Display a message if no current issue exists *}
		{if !$issue}
			{include file="frontend/components/spup/layout/breadcrumbs.tpl" currentTitleKey="current.noCurrentIssue"}
			{include file="frontend/components/headings.tpl" currentTitleKey="current.noCurrentIssue"}
			{include file="frontend/components/notification.tpl" type="warning" messageKey="current.noCurrentIssueDesc"}

		{* Display an issue with the Table of Contents *}
		{else}
			{capture assign=spupArchiveLabel}{translate key="archive.archives"}{/capture}
			{capture assign=spupArchiveUrl}{url page="issue" op="archive" escape=false}{/capture}
			{assign var=spupIssueBreadcrumbs value=[]}
			{append var=spupIssueBreadcrumbs value=['label'=>$spupArchiveLabel, 'url'=>$spupArchiveUrl]}
			{append var=spupIssueBreadcrumbs value=['label'=>$issue->getIssueIdentification(), 'current'=>true]}
			{include file="frontend/components/spup/layout/breadcrumbs.tpl" items=$spupIssueBreadcrumbs}
			{include file="frontend/components/spup/issue/identity.tpl" issue=$issue issueIdentificationString=$issueIdentificationString}
			{include file="frontend/objects/issue_toc.tpl" spupIssueIdentityShown=true}
		{/if}
	</div>
</main>

{include file="frontend/components/footer.tpl"}
