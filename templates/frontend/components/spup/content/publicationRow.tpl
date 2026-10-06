{* Published OJS submission row for root and journal homepages. *}
{if $submission && $publication}
<li><article>
  <{if $headingLevel}{$headingLevel}{else}h3{/if}>
    <a href="{if $journal}{url journal=$journal->getPath() page='article' op='view' path=$submission->getBestId()}{else}{url page='article' op='view' path=$submission->getBestId()}{/if}">{$publication->getLocalizedFullTitle(null, 'text')|escape} <span class="spup-editorial-arrow" aria-hidden="true">&rarr;</span></a>
  </{if $headingLevel}{$headingLevel}{else}h3{/if}>
  {if $variant == 'journal' && $authors}<p class="spup-editorial-list__authors">{$authors|escape}</p>{/if}
  {if $journal || ($authors && $variant != 'journal') || $datePublished}
    <p class="spup-editorial-list__meta">
      {if $journal}{$journal->getLocalizedName()|escape}{/if}
      {if $journal && $authors && $variant != 'journal'} &middot; {/if}{if $authors && $variant != 'journal'}{$authors|escape}{/if}
      {if ($journal || ($authors && $variant != 'journal')) && $datePublished} &middot; {/if}
      {if $datePublished}<time datetime="{$datePublished|date_format:'Y-m-d'|escape}">{$datePublished|date_format:$dateFormatShort}</time>{/if}
    </p>
  {/if}
</article></li>
{/if}
