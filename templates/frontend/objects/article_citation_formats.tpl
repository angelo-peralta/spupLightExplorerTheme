{* The CSL plugin assigns these URLs and the matching citation output before article.tpl renders. *}
<details class="spup-article__more-formats spup-article__citation-formats">
  <summary>{translate key="submission.howToCite.citationFormats"}</summary>
  {if $citationStyles}
    <p class="spup-article__format-label">Citation styles</p>
    <ul>
      {foreach from=$citationStyles item=citationStyle}
        <li><a rel="nofollow" aria-controls="citationOutput" href="{url page="citationstylelanguage" op="get" path=$citationStyle.id params=$citationArgs}" data-load-citation data-json-href="{url page="citationstylelanguage" op="get" path=$citationStyle.id params=$citationArgsJson}">{$citationStyle.title|escape}</a></li>
      {/foreach}
    </ul>
  {/if}
  {if $citationDownloads}
    <p class="spup-article__format-label">{translate key="submission.howToCite.downloadCitation"}</p>
    <ul>
      {foreach from=$citationDownloads item=citationDownload}
        <li><a href="{url page="citationstylelanguage" op="download" path=$citationDownload.id params=$citationArgs}">{$citationDownload.title|escape}</a></li>
      {/foreach}
    </ul>
  {/if}
</details>
