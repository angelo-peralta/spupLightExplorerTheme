{* Context-scoped OJS announcement row for root and journal previews. *}
{if $announcement}
<li><article>
  {if $announcement->datePosted}<time datetime="{$announcement->datePosted|date_format:'Y-m-d'|escape}">{$announcement->datePosted|date_format:$dateFormatShort|escape}</time>{/if}
  <{if $headingLevel}{$headingLevel}{else}h3{/if}><a href="{url page='announcement' op='view' path=$announcement->id}">{$announcement->getLocalizedData('title')|escape}{if $showArrow} <span class="spup-editorial-arrow" aria-hidden="true">&rarr;</span>{/if}</a></{if $headingLevel}{$headingLevel}{else}h3{/if}>
  {if $showExcerpt && $announcement->getLocalizedData('descriptionShort')}<div class="spup-journal-announcements__preview">{$announcement->getLocalizedData('descriptionShort')|strip_unsafe_html}</div>{/if}
  {if $readKey}<a class="spup-text-link spup-journal-announcements__read" href="{url page='announcement' op='view' path=$announcement->id}">{translate key=$readKey} <span aria-hidden="true">&rarr;</span></a>{/if}
</article></li>
{/if}
