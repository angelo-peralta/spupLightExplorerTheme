{* Shared section heading. The caller supplies an OJS locale key and a stable id. *}
{if $eyebrowKey}<p class="spup-section-eyebrow">{translate key=$eyebrowKey}</p>{elseif $eyebrow}<p class="spup-section-eyebrow">{$eyebrow|escape}</p>{/if}
<h2 id="{$headingId|escape}">{if $titleKey}{translate key=$titleKey}{else}{$title|escape}{/if}</h2>
{if !$hideRule}<div class="spup-section-rule" aria-hidden="true"></div>{/if}
