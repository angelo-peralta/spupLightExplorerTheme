{**
 * templates/frontend/pages/indexSite.tpl
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2003-2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Template for site-wide index page
 *
 *}
{include file="frontend/components/header.tpl" spupSiteHeroHeading=true}

<main class="page_index_site">
	<section class="spup-site-hero" aria-labelledby="spup-site-hero-title">
		<div class="spup-site-container spup-site-hero__inner">
			<p class="spup-site-hero__institution">St. Paul University Philippines</p>
			<h1 id="spup-site-hero-title" class="spup-site-hero__title">
				{if $siteTitle}{$siteTitle|escape}{else}The Light Explorer{/if}
			</h1>
			<p class="spup-site-hero__subtitle">Journal Network</p>
			<div class="spup-site-hero__divider" aria-hidden="true"></div>

			{capture assign="spupSearchUrl"}{url page="search" op="search" router=$smarty.const.ROUTE_PAGE escape=false}{/capture}
			{assign var=spupSearchUrlParameters value=$activeTheme->getSearchFormParameters($spupSearchUrl)}
			<form class="spup-site-hero__search" method="get" action="{$spupSearchUrl|strtok:"?"|escape}" role="search">
				{foreach from=$spupSearchUrlParameters key=paramKey item=paramValue}
					{if $paramKey != 'query' && $paramKey != 'searchJournal'}
						<input type="hidden" name="{$paramKey|escape}" value="{$paramValue|escape}">
					{/if}
				{/foreach}
				<label class="spup-site-hero__search-label" for="spup-site-search-query">{translate key="plugins.themes.spupLightExplorerTheme.search.allJournals"}</label>
				<div class="spup-site-hero__search-controls">
					<input id="spup-site-search-query" type="search" name="query" placeholder="{translate|escape key="plugins.themes.spupLightExplorerTheme.search.allJournals"}" required>
					<button type="submit">{translate key="common.search"}</button>
				</div>
			</form>

			{if $journals|@count}
				<p class="spup-site-hero__meta">
					{$journals|@count} {if $journals|@count == 1}{translate key="context.context"}{else}{translate key="context.contexts"}{/if}
				</p>
			{/if}
		</div>
	</section>

	<div class="spup-site-container spup-site-content">

		{if $about}
			<div class="about_site">
				{$about|nl2br}
			</div>
		{/if}

		<section class="index-site-journals" aria-labelledby="spup-journals-heading">
			<h2 id="spup-journals-heading">
				{translate key="context.contexts"}
			</h2>
			{if !$journals|@count}
				<p class="spup-journal-empty">{translate key="site.noJournals"}</p>
			{else}
				<div class="spup-journal-grid">
					{foreach from=$journals item=journal}
						{capture assign="url"}{url journal=$journal->getPath()}{/capture}
						{assign var="thumb" value=$journal->getLocalizedData('journalThumbnail')}
						{assign var="description" value=$journal->getLocalizedDescription()}
						{assign var="descriptionPreview" value=$activeTheme->getJournalDescriptionPreview($description)}
						<article class="spup-journal-card{if !$thumb} spup-journal-card--no-thumb{/if}">
							<a class="spup-journal-card__link" href="{$url|escape}" rel="bookmark" aria-labelledby="spup-journal-title-{$journal->getId()|escape}"{if $descriptionPreview} aria-describedby="spup-journal-description-{$journal->getId()|escape}"{/if}>
								<div class="spup-journal-card__media">
									{if $thumb}
										<img class="spup-journal-card__image" src="{$journalFilesPath}{$journal->getId()}/{$thumb.uploadName|escape:"url"}" alt="{$thumb.altText|escape|default:''}" loading="lazy" decoding="async">
									{else}
										<div class="spup-journal-card__fallback" aria-hidden="true">
											<span>{$journal->getLocalizedName()|escape}</span>
										</div>
									{/if}
								</div>
								<div class="spup-journal-card__overlay">
									<h3 id="spup-journal-title-{$journal->getId()|escape}" class="spup-journal-card__title">{$journal->getLocalizedName()|escape}</h3>
									{if $descriptionPreview}
										<p id="spup-journal-description-{$journal->getId()|escape}" class="spup-journal-card__description">{$descriptionPreview|escape}</p>
									{/if}
									<span class="spup-journal-card__action">{translate key="plugins.themes.spupLightExplorerTheme.directory.openJournal"}<span aria-hidden="true"> &rarr;</span></span>
								</div>
							</a>
						</article>
					{/foreach}
				</div>
			{/if}
		</section>
	</div>

</main><!-- .page_index_site -->

{include file="frontend/components/footer.tpl"}
