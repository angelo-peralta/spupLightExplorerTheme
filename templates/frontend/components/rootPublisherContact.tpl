<div class="spup-publisher-page spup-publisher-contact">
  <div class="spup-contact-grid">
    {if $spupFooterContactEmail}<section aria-labelledby="spup-contact-publishing">
      <h2 id="spup-contact-publishing">{translate key="plugins.themes.spupLightExplorerTheme.root.publishingContact"}</h2>
      <p><a href="mailto:{$spupFooterContactEmail|escape}">{$spupFooterContactEmail|escape}</a></p>
    </section>{/if}
    <section aria-labelledby="spup-contact-publisher">
      <h2 id="spup-contact-publisher">{translate key="plugins.themes.spupLightExplorerTheme.root.publisher"}</h2>
      <p><strong>{translate key="plugins.themes.spupLightExplorerTheme.footer.institution"}</strong></p>
      {if $spupRootOptions.publisherAddress}<p>{$spupRootOptions.publisherAddress|escape|nl2br}</p>{/if}
      <p><a href="{$spupInstitutionalUrl|escape}">{translate key="plugins.themes.spupLightExplorerTheme.root.institutionalWebsite"}</a></p>
    </section>
  </div>
  {if $spupRootOptions.mapUrl && $spupRootOptions.showMapContact}
    <section class="spup-publisher-section" aria-labelledby="spup-contact-location">
      <h2 id="spup-contact-location">{translate key="plugins.themes.spupLightExplorerTheme.footer.location"}</h2>
      {include file="frontend/components/rootLocationMap.tpl"}
    </section>
  {/if}
</div>
