{**
 * Shared root/journal shell for OJS navigation and Static Pages content.
 * The OJS override paths remain the public entry points.
 *}
{assign var=customPageVariant value=$variant|default:'root'}
<div class="container-fluid container-page container-narrow">
  {include file="frontend/components/spup/layout/breadcrumbs.tpl" items=$breadcrumbItems currentTitle=$title}
  {include file="frontend/components/spup/layout/pageIntro.tpl" title=$title variant=$customPageVariant}
  <div class="{if $customPageVariant == 'journal'}spup-journal-reading{else}spup-root-reading{/if} spup-custom-content">{$content}</div>
</div>
