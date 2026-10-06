{* Journal identity uses only the active OJS journal's name, description and thumbnail. *}
<section class="spup-journal-identity spup-site-hero{if !$spupJournalCover.uploadName} spup-journal-identity--no-cover{/if}" aria-labelledby="spup-journal-name">
  <div class="spup-journal-identity__inner spup-site-container">
    <div class="spup-journal-identity__copy">
      {if $spupJournalInitials}<p class="spup-journal-identity__initials spup-site-hero__institution">{$spupJournalInitials|escape}</p>{/if}
      <h1 id="spup-journal-name">{$spupJournalName|escape}</h1>
      {if $showJournalSummary && $spupJournalIntro.summary}<p class="spup-journal-identity__summary">{$spupJournalIntro.summary|escape}</p>{/if}
    </div>
    {if $spupJournalCover.uploadName}
      {capture assign=spupJournalCoverUrl}{$publicFilesDir}/{$spupJournalCover.uploadName|escape:'url'}{/capture}
      {capture assign=spupJournalCoverAlt}{if $spupJournalCover.altText}{$spupJournalCover.altText}{else}{$spupJournalName} cover{/if}{/capture}
      <div class="spup-journal-identity__visual">
        {include file="frontend/components/spup/layout/coverMedia.tpl" imageUrl=$spupJournalCoverUrl alt=$spupJournalCoverAlt variant="journal" className="spup-journal-identity__cover-frame" imageClass="spup-journal-identity__cover" showOffset=true loading="eager"}
      </div>
    {/if}
  </div>
</section>
