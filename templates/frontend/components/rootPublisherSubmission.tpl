<div class="spup-publisher-page spup-publisher-submission">
  <div class="spup-publisher-prose">{if $content}{$content|strip_unsafe_html}{else}<p>{translate key="plugins.themes.spupLightExplorerTheme.root.submitHelp"}</p>{/if}</div>
  <section class="spup-publisher-section" aria-labelledby="spup-submit-journals">
    <h2 id="spup-submit-journals">{translate key="plugins.themes.spupLightExplorerTheme.root.chooseJournal"}</h2>
    {assign var="spupGalleryJournals" value=$spupPublisherJournals}
    {include file="frontend/components/rootJournalGallery.tpl"}
  </section>
</div>
