{if !$spupGalleryJournals|@count}
  <p class="spup-empty-state">{translate key="site.noJournals"}</p>
{else}
  <div class="spup-journal-grid">
    {foreach from=$spupGalleryJournals item=journal}
      {capture assign="journalUrl"}{url journal=$journal->getPath()}{/capture}
      {assign var="thumb" value=$journal->getLocalizedData('journalThumbnail')}
      {assign var="descriptionPreview" value=$activeTheme->getJournalDescriptionPreview($journal->getLocalizedDescription(), 180)}
      {assign var="abbreviation" value=$journal->getLocalizedData('abbreviation')}
      <article class="spup-journal-cover{if !$thumb} spup-journal-cover--missing{/if}">
        <a class="spup-journal-cover__link" href="{$journalUrl|escape}" aria-labelledby="spup-journal-title-{$journal->getId()|escape}">
          <figure class="spup-journal-cover__figure">
            <div class="spup-journal-cover__media">
              {if $thumb}
                <img src="{$journalFilesPath}{$journal->getId()}/{$thumb.uploadName|escape:'url'}" alt="" loading="lazy" decoding="async">
              {else}
                <div class="spup-journal-cover__fallback" aria-hidden="true">{if $abbreviation}<span>{$abbreviation|escape}</span>{/if}<strong>{$journal->getLocalizedName()|escape}</strong></div>
              {/if}
            </div>
            <figcaption class="spup-journal-cover__overlay">
              {if $abbreviation}<span class="spup-journal-cover__abbreviation">{$abbreviation|escape}</span>{/if}
              <h3 id="spup-journal-title-{$journal->getId()|escape}">{$journal->getLocalizedName()|escape}</h3>
              {if $descriptionPreview}<p class="spup-journal-cover__description">{$descriptionPreview|escape}</p>{/if}
              <span class="spup-journal-cover__action">{translate key="plugins.themes.spupLightExplorerTheme.directory.openJournal"} <span aria-hidden="true">&rarr;</span></span>
            </figcaption>
          </figure>
        </a>
      </article>
    {/foreach}
  </div>
{/if}
