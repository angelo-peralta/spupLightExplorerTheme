{**
 * Copyright (c) 2014-2025 Simon Fraser University
 * Copyright (c) 2003-2025 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see docs/COPYING.
 * Theme-owned cover presentation shared by issue and article views.
 * The caller supplies an OJS image URL and, where needed, an OJS-generated link.
 * Empty images produce no markup; callers own any intentional fallback.
 *}
{if $imageUrl}
  {assign var=spupCoverLoading value=$loading|default:'lazy'}
  {assign var=spupCoverDecoding value=$decoding|default:'async'}
  {if $linkUrl}
    <a class="spup-cover-media spup-cover-media--{$variant|escape}{if $showOffset} spup-cover-media--offset{/if}{if $className} {$className|escape}{/if}" href="{$linkUrl|escape}">
      <img{if $imageClass} class="{$imageClass|escape}"{/if} src="{$imageUrl|escape}" alt="{$alt|escape}" loading="{$spupCoverLoading|escape}" decoding="{$spupCoverDecoding|escape}">
    </a>
  {else}
    <div class="spup-cover-media spup-cover-media--{$variant|escape}{if $showOffset} spup-cover-media--offset{/if}{if $className} {$className|escape}{/if}">
      <img{if $imageClass} class="{$imageClass|escape}"{/if} src="{$imageUrl|escape}" alt="{$alt|escape}" loading="{$spupCoverLoading|escape}" decoding="{$spupCoverDecoding|escape}">
    </div>
  {/if}
{/if}
