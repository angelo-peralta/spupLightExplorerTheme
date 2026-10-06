{**
 * templates/frontend/pages/message.tpl
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2003-2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * Generic message page.
 * Displays a simple message and (optionally) a return link.
 *}
{include file="frontend/components/header.tpl"}

<main class="page page_message">
	<div class="container-fluid container-page container-narrow">
		{include file="frontend/components/spup/layout/breadcrumbs.tpl" items=[] currentTitleKey=$pageTitle}
		{if !$currentContext}
			{include file="frontend/components/spup/layout/pageIntro.tpl" titleKey=$pageTitle}
		{else}{include file="frontend/components/headings.tpl" currentTitleKey=$pageTitle}{/if}
		<div class="message-description">
			{if $messageTranslated}
				{$messageTranslated}
			{else}
				{translate key=$message}
			{/if}
		</div>
		{if $backLink}
			<div class="cmp_back_link">
				<a href="{$backLink}">{translate key=$backLinkLabel}</a>
			</div>
		{/if}
	</div>
</main>

{include file="frontend/components/footer.tpl"}
