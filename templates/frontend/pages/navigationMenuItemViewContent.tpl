{**
 * frontend/pages/navigationMenuItemViewContent.tpl
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2003-2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * Display NavigationMenuItem content
 *}
{include file="frontend/components/header.tpl" pageTitleTranslated=$title|escape}

<main class="page navigation-item-content{if !$currentContext && $requestedPage == 'journals'} page_journals{/if}">
	<div class="container-fluid container-page container-narrow">
		{if !$currentContext}{include file="frontend/components/rootBreadcrumbs.tpl" currentTitle=$title}{/if}
		<h1 class="page_title{if $currentContext} text-center{/if}">{$title|escape}</h1>
		{if !$currentContext && $requestedPage == 'publisher-about'}
			{include file="frontend/components/rootPublisherAbout.tpl"}
		{elseif !$currentContext && $requestedPage == 'publisher-contact'}
			{include file="frontend/components/rootPublisherContact.tpl"}
		{elseif !$currentContext && $requestedPage == 'publisher-submit'}
			{include file="frontend/components/rootPublisherSubmission.tpl"}
		{elseif !$currentContext && $requestedPage == 'journals'}
			{include file="frontend/components/rootJournalDirectory.tpl"}
		{else}
			{$content}
		{/if}
	</div>
</main>

{include file="frontend/components/footer.tpl"}
