{* Link data comes from configured OJS menu items; empty URLs are omitted. *}
{if $items|@count}
<ul class="spup-journal-link-list">
  {foreach from=$items item=link}
    {if $link.url && $link.title}
      <li><a href="{$link.url|escape}">{$link.title|strip_tags|escape}<span aria-hidden="true">&rarr;</span></a></li>
    {/if}
  {/foreach}
</ul>
{/if}
