{* Root publisher pages share the same short OJS-style breadcrumb trail. *}
<nav class="spup-root-breadcrumbs cmp_breadcrumbs" aria-label="{translate|escape key="navigation.breadcrumbLabel"}">
	<ol>
		<li><a href="{url page="index" router=$smarty.const.ROUTE_PAGE}">{translate key="common.homepageNavigationLabel"}</a></li>
		{if $parentTitleKey}
			<li><span class="separator" aria-hidden="true">/</span><a href="{$parentUrl|escape}">{translate key=$parentTitleKey}</a></li>
		{/if}
		<li class="current" aria-current="page"><span class="separator" aria-hidden="true">/</span>{if $currentTitleKey}{translate key=$currentTitleKey}{else}{$currentTitle|escape}{/if}</li>
	</ol>
</nav>
