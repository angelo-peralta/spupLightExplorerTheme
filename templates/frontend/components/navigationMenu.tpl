{**
 * templates/frontend/components/navigationMenu.tpl
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2003-2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Template for primary and user menus
 *
 *}

{if $navigationMenu}
	{assign var=spupPrimaryHasJournalHome value=false}
	{if $id == 'navigationPrimary' && $currentContext}
		{capture assign=spupJournalHomeUrl}{url journal=$currentContext->getPath() page='index'}{/capture}
		{foreach item=spupTopLevelItem from=$navigationMenu->menuTree}
			{if $spupTopLevelItem->navigationMenuItem->getIsDisplayed() && $spupTopLevelItem->navigationMenuItem->getUrl() == $spupJournalHomeUrl}
				{assign var=spupPrimaryHasJournalHome value=true}
			{/if}
		{/foreach}
	{/if}
	<ul id="{$id|escape}" class="{$ulClass|escape} nav nav-tabs">
		{if $id == 'navigationPrimary' && $currentContext && !$spupPrimaryHasJournalHome}
			<li class="nav-item"><a class="nav-link spup-header__home-nav-link" href="{$spupJournalHomeUrl|escape}"><span class="spup-header__nav-label">{translate key="plugins.themes.spupLightExplorerTheme.journal.home"}</span></a></li>
		{/if}
		{foreach key=field item=navigationMenuItemAssignment from=$navigationMenu->menuTree}
			{if !$navigationMenuItemAssignment->navigationMenuItem->getIsDisplayed()}
				{continue}
			{/if}
			{assign var=navItemType value=$navigationMenuItemAssignment->navigationMenuItem->getType()}
			{assign var=spupNavTitle value=$navigationMenuItemAssignment->navigationMenuItem->getLocalizedTitle()}
			{if $id == 'navigationUser' && !$spupNavTitle}
				{if $navItemType == 'NMI_TYPE_USER_REGISTER'}{capture assign=spupNavTitle}{translate key='navigation.register'}{/capture}
				{elseif $navItemType == 'NMI_TYPE_USER_LOGIN'}{capture assign=spupNavTitle}{translate key='navigation.login'}{/capture}
				{elseif $navItemType == 'NMI_TYPE_USER_DASHBOARD'}{capture assign=spupNavTitle}{translate key='navigation.dashboard'}{/capture}
				{elseif $navItemType == 'NMI_TYPE_USER_PROFILE'}{capture assign=spupNavTitle}{translate key='common.viewProfile'}{/capture}
				{elseif $navItemType == 'NMI_TYPE_ADMINISTRATION'}{capture assign=spupNavTitle}{translate key='navigation.admin'}{/capture}
				{elseif $navItemType == 'NMI_TYPE_USER_LOGOUT'}{capture assign=spupNavTitle}{translate key='user.logOut'}{/capture}
				{/if}
				{if !$spupNavTitle}{continue}{/if}
			{/if}
			{if !empty($navigationMenuItemAssignment->children)}
				<li class="{$liClass|escape} nav-item dropdown">
					<a id="{if $navItemType === "NMI_TYPE_USER_DASHBOARD"}user-dashboard-link{else}{$id|escape}-dropdown-{$field|escape}{/if}"
							class="nav-link dropdown-toggle{if !($languageToggleLocales && $languageToggleLocales|@count > 1)} locales-toggle-off{/if}"
							href="{$navigationMenuItemAssignment->navigationMenuItem->getUrl()}" role="button"
							data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
						{if $id == 'navigationPrimary'}<span class="spup-header__nav-label">{if $navItemType == 'NMI_TYPE_USER_DASHBOARD'}{$spupNavTitle|spup_dashboard_title}{else}{$spupNavTitle|escape}{/if}</span>{elseif $navItemType == 'NMI_TYPE_USER_DASHBOARD'}{$spupNavTitle|spup_dashboard_title}{else}{$spupNavTitle|escape}{/if}
					</a>
					<div class="navigation-dropdown dropdown-menu dropdown-menu-end" aria-labelledby="{if $navItemType === "NMI_TYPE_USER_DASHBOARD"}user-dashboard-link{else}{$id|escape}-dropdown-{$field|escape}{/if}">
						{foreach key=childField item=childNavigationMenuItemAssignment from=$navigationMenuItemAssignment->children}
							{if $childNavigationMenuItemAssignment->navigationMenuItem->getIsDisplayed()}
								{assign var=spupChildTitle value=$childNavigationMenuItemAssignment->navigationMenuItem->getLocalizedTitle()}
								{assign var=spupChildType value=$childNavigationMenuItemAssignment->navigationMenuItem->getType()}
								{if $id == 'navigationUser' && !$spupChildTitle}
									{if $spupChildType == 'NMI_TYPE_USER_REGISTER'}{capture assign=spupChildTitle}{translate key='navigation.register'}{/capture}
									{elseif $spupChildType == 'NMI_TYPE_USER_LOGIN'}{capture assign=spupChildTitle}{translate key='navigation.login'}{/capture}
									{elseif $spupChildType == 'NMI_TYPE_USER_DASHBOARD'}{capture assign=spupChildTitle}{translate key='navigation.dashboard'}{/capture}
									{elseif $spupChildType == 'NMI_TYPE_USER_PROFILE'}{capture assign=spupChildTitle}{translate key='common.viewProfile'}{/capture}
									{elseif $spupChildType == 'NMI_TYPE_ADMINISTRATION'}{capture assign=spupChildTitle}{translate key='navigation.admin'}{/capture}
									{elseif $spupChildType == 'NMI_TYPE_USER_LOGOUT'}{capture assign=spupChildTitle}{translate key='user.logOut'}{/capture}
									{/if}
									{if !$spupChildTitle}{continue}{/if}
								{/if}
								<a class="{$liClass|escape} dropdown-item"
								   href="{$childNavigationMenuItemAssignment->navigationMenuItem->getUrl()}">
									{if $spupChildType == 'NMI_TYPE_USER_DASHBOARD'}{$spupChildTitle|spup_dashboard_title}{else}{$spupChildTitle|escape}{/if}
								</a>
							{/if}
						{/foreach}
					</div>
				</li>
			{else}
				<li class="{$liClass|escape} nav-item">
					<a class="nav-link"
					   href="{$navigationMenuItemAssignment->navigationMenuItem->getUrl()}">{if $id == 'navigationPrimary'}<span class="spup-header__nav-label">{if $navItemType == 'NMI_TYPE_USER_DASHBOARD'}{$spupNavTitle|spup_dashboard_title}{else}{$spupNavTitle|escape}{/if}</span>{elseif $navItemType == 'NMI_TYPE_USER_DASHBOARD'}{$spupNavTitle|spup_dashboard_title}{else}{$spupNavTitle|escape}{/if}</a>
				</li>
			{/if}
		{/foreach}
	</ul>
{/if}
