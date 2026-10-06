{**
 * Shared breadcrumb trail for root and journal pages.
 *
 * @uses $items array Levels after Home. Each item has a plain-text label,
 *   optional OJS-generated url, and current=true for the current page.
 * @uses $currentTitle string Plain-text current title for a one-level trail.
 * @uses $currentTitleKey string Translation key for a one-level trail.
 *}
{if !empty($items) || $currentTitle || $currentTitleKey}
<nav class="spup-breadcrumbs cmp_breadcrumbs {if $currentContext}spup-journal-breadcrumbs{else}spup-root-breadcrumbs{/if}" aria-label="{translate|escape key="navigation.breadcrumbLabel"}">
	<ol>
		<li><a href="{url page="index" router=$smarty.const.ROUTE_PAGE}">{translate key="common.homepageNavigationLabel"}</a></li>
		{if !empty($items)}
			{foreach from=$items item=item}
				<li{if $item.current} class="current" aria-current="page"{/if}><span class="separator" aria-hidden="true">/</span>{if $item.url && !$item.current}<a href="{$item.url|escape}">{$item.label|escape}</a>{else}{$item.label|escape}{/if}</li>
			{/foreach}
		{else}
			<li class="current" aria-current="page"><span class="separator" aria-hidden="true">/</span>{if $currentTitleKey}{translate key=$currentTitleKey}{else}{$currentTitle|escape}{/if}</li>
		{/if}
	</ol>
</nav>
{/if}
