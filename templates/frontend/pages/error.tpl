{**
 * templates/frontend/pages/error.tpl
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2003-2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * Generic error page.
 * Displays a simple error message and (optionally) a return link.
 *}

{include file="frontend/components/header.tpl"}

<main class="page page_error">
	<div class="container-fluid container-page container-narrow">
		{if !$currentContext}
			{include file="frontend/components/rootBreadcrumbs.tpl" currentTitleKey=$pageTitle}
			<h1 class="page_title">{translate key=$pageTitle}</h1>
		{else}{include file="frontend/components/headings.tpl" currentTitleKey=$pageTitle}{/if}
		<div class="error-description">
			<p>{translate key=$errorMsg params=$errorParams}</p>
		</div>
		{if $backLink}
			<div class="cmp_back_link">
				<a href="{$backLink}">{translate key=$backLinkLabel}</a>
			</div>
		{/if}
		{if !$currentContext}<a class="spup-text-link" href="{url page="index"}">{translate key="plugins.themes.spupLightExplorerTheme.root.backHome"} <span aria-hidden="true">&rarr;</span></a>{/if}
	</div>
</main>

{include file="frontend/components/footer.tpl"}
