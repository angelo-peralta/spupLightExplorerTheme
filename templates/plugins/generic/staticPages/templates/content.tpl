{**
 * templates/content.tpl
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2003-2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * Display Static Page content
 *}
{include file="frontend/components/header.tpl" pageTitleTranslated=$title|escape}

<main class="page static_page">
	{if !$currentContext}
		{include file="frontend/components/spup/layout/customPage.tpl" title=$title content=$spupRootCustomContent}
	{else}
		{include file="frontend/components/spup/layout/customPage.tpl" variant="journal" title=$title content=$spupJournalCustomContent breadcrumbItems=[]}
	{/if}
</main>

{include file="frontend/components/footer.tpl"}
