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

<main class="page navigation-item-content{if !$currentContext && $requestedPage == 'journals'} page_journals{/if}{if !$currentContext && ($requestedPage == 'about' || $requestedPage == 'publisher-about')} page_publisher_about{/if}{if !$currentContext && ($requestedPage == 'contact' || $requestedPage == 'contact-us' || $requestedPage == 'publisher-contact')} page_publisher_contact{/if}">
	{if $currentContext}
		{include file="frontend/components/spup/layout/customPage.tpl" variant="journal" title=$title content=$spupJournalCustomContent breadcrumbItems=[]}
	{elseif $requestedPage != 'journals' && $requestedPage != 'about' && $requestedPage != 'publisher-about' && $requestedPage != 'contact' && $requestedPage != 'contact-us' && $requestedPage != 'publisher-contact' && $requestedPage != 'publisher-submit' && $requestedPage != 'submission'}
		{include file="frontend/components/spup/layout/customPage.tpl" title=$title content=$spupRootCustomContent breadcrumbItems=$spupRootBreadcrumbItems}
	{else}
	<div class="container-fluid container-page container-narrow">
		{include file="frontend/components/spup/layout/breadcrumbs.tpl" items=[] currentTitle=$title}
		{if !$currentContext && ($requestedPage == 'about' || $requestedPage == 'publisher-about')}
			{include file="frontend/components/spup/root/rootPublisherAbout.tpl"}
		{elseif !$currentContext && ($requestedPage == 'contact' || $requestedPage == 'contact-us' || $requestedPage == 'publisher-contact')}
			{include file="frontend/components/spup/root/rootPublisherContact.tpl"}
		{else}
			{include file="frontend/components/spup/layout/pageIntro.tpl" title=$title}
			{if !$currentContext && ($requestedPage == 'publisher-submit' || $requestedPage == 'submission')}
				{include file="frontend/components/spup/root/rootPublisherSubmission.tpl"}
			{elseif !$currentContext && $requestedPage == 'journals'}
				{include file="frontend/components/spup/root/rootJournalDirectory.tpl"}
			{else}
				{$content}
			{/if}
		{/if}
	</div>
	{/if}
</main>

{include file="frontend/components/footer.tpl"}
