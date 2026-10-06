{**
 * Shared root/journal page introduction. The page owns its single H1 here.
 * Rich description comes from approved OJS content and is sanitized at output.
 *}
<header class="spup-page-intro{if $variant == 'journal'} spup-page-intro--journal current_page_title{/if}{if $className} {$className|escape}{/if}">
  {if $eyebrowKey}<p class="spup-page-intro__eyebrow">{translate key=$eyebrowKey}</p>{elseif $eyebrow}<p class="spup-page-intro__eyebrow">{$eyebrow|escape}</p>{/if}
  <h1{if $headingId} id="{$headingId|escape}"{/if}>{if $titleKey}{translate key=$titleKey}{else}{$title|escape}{/if}</h1>
  {if $descriptionHtml}<div class="spup-page-intro__description">{$descriptionHtml|strip_unsafe_html}</div>{elseif $descriptionKey}<p class="spup-page-intro__description">{translate key=$descriptionKey}</p>{elseif $description}<p class="spup-page-intro__description">{$description|escape}</p>{/if}
</header>
