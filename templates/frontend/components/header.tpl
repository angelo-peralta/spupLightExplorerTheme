{**
 * templates/frontend/components/header.tpl
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2003-2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Shared site and journal header with native OJS menus
 *}

{strip}
	{capture assign="homeUrl"}{url page="index" router=$smarty.const.ROUTE_PAGE}{/capture}
	{capture assign="primaryMenu"}{load_menu name="primary" id="navigationPrimary" ulClass="pkp_navigation_primary"}{/capture}
	{assign var="hasPrimaryMenu" value=!empty(trim($primaryMenu))}
{/strip}

<!DOCTYPE html>
<html lang="{$currentLocale|replace:"_":"-"}" xml:lang="{$currentLocale|replace:"_":"-"}">
{if !$pageTitleTranslated}
	{capture assign="pageTitleTranslated"}{translate key=$pageTitle}{/capture}
{/if}
{include file="frontend/components/headerHead.tpl"}
<body{if !$currentContext} class="spup-root"{/if}>
<header class="spup-header spup-header--{if $currentContext}journal{else}site{/if}">
	<div class="spup-header__inner">
		<div class="spup-header__top">
			<div class="spup-header__identity">
				<a href="{$homeUrl|escape}" class="spup-header__home-link">
					{if $currentContext}
						{if $requestedPage|default:"index" == 'index'}<h1 class="spup-header__journal-heading">{else}<span class="spup-header__journal-heading">{/if}
						{if $displayPageHeaderLogo}
							<img class="spup-header__logo spup-header__logo--journal"
								src="{$publicFilesDir}/{$displayPageHeaderLogo.uploadName|escape:"url"}"
								alt="{if !$spupShowJournalTitleInHeader}{if $displayPageHeaderLogo.altText != ''}{$displayPageHeaderLogo.altText|escape}{elseif $displayPageHeaderLogoAltText}{$displayPageHeaderLogoAltText|escape}{else}{$currentContext->getLocalizedName()|escape}{/if}{/if}"
								loading="eager">
						{/if}
						{if !$displayPageHeaderLogo || $spupShowJournalTitleInHeader}
							<span class="spup-header__journal-title">{if $displayPageHeaderTitle}{$displayPageHeaderTitle|escape}{else}{$currentContext->getLocalizedName()|escape}{/if}</span>
						{/if}
						{if $requestedPage|default:"index" == 'index'}</h1>{else}</span>{/if}
					{else}
						{if $displayPageHeaderLogo}
							<img class="spup-header__logo spup-header__logo--site"
								src="{$sitePublicFilesDir}/{$displayPageHeaderLogo.uploadName|escape:"url"}"
								alt="" width="44" height="44" loading="eager">
						{/if}
						<span class="spup-header__institution">{translate key="plugins.themes.spupLightExplorerTheme.footer.institution"}</span>
					{/if}
				</a>
			</div>
			<button id="spup-menu-toggle" class="spup-header__menu-toggle" type="button"
				aria-controls="{if $hasPrimaryMenu}spupHeaderNavigation {/if}spupHeaderUtilities"
				aria-expanded="false" hidden>
				<span class="spup-header__menu-icon" aria-hidden="true"></span>
				<span class="spup-header__menu-open-label">{translate key="plugins.themes.spupLightExplorerTheme.menu"}</span>
				<span class="spup-header__menu-close-label">{translate key="plugins.themes.spupLightExplorerTheme.closeMenu"}</span>
			</button>
		</div>

		{if $hasPrimaryMenu}
			<nav id="spupHeaderNavigation" class="spup-header__navigation"
				aria-label="{translate|escape key="plugins.themes.spupLightExplorerTheme.primaryNavigation"}">
				{$primaryMenu}
			</nav>
		{/if}

		<div id="spupHeaderUtilities" class="spup-header__utilities">
			<span class="spup-header__account-label">{translate key="plugins.themes.spupLightExplorerTheme.accountNavigation"}</span>
			<nav class="spup-header__user-navigation"
				aria-label="{translate|escape key="plugins.themes.spupLightExplorerTheme.accountNavigation"}">
				{load_menu name="user" id="navigationUser" ulClass="pkp_navigation_user"}
			</nav>
			{include file="frontend/components/languageSwitcher.tpl" id="languageNav"}
		</div>
	</div>
</header>
