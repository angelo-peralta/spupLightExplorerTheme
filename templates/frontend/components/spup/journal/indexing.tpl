{* Configured, approved indexing names only. *}
{if $services|@count}
<section class="spup-journal-band spup-journal-band--light spup-journal-indexing" aria-labelledby="spup-journal-indexing-heading">
  <div class="spup-journal-band__inner spup-site-container">
    <h2 id="spup-journal-indexing-heading">{translate key="plugins.themes.spupLightExplorerTheme.journal.indexing"}</h2>
    <ul>{foreach from=$services item=service}<li>{$service|escape}</li>{/foreach}</ul>
  </div>
</section>
{/if}
