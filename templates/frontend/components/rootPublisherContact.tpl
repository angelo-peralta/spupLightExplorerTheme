<div class="spup-publisher-page spup-publisher-contact">
  <header class="spup-contact__intro">
    <p class="spup-page-eyebrow">{translate key="plugins.themes.spupLightExplorerTheme.contact.eyebrow"}</p>
    <h1>{translate key="plugins.themes.spupLightExplorerTheme.contact.title"}</h1>
    <p>{translate key="plugins.themes.spupLightExplorerTheme.contact.intro"}</p>
  </header>

  <div class="spup-contact__main">
    <div class="spup-contact__details">
      {if $spupFooterContactEmail}
        <section aria-labelledby="spup-contact-publishing">
          <p class="spup-page-eyebrow">{translate key="plugins.themes.spupLightExplorerTheme.contact.inquiries"}</p>
          <h2 id="spup-contact-publishing">{translate key="plugins.themes.spupLightExplorerTheme.root.publishingContact"}</h2>
          <a class="spup-contact__email" href="mailto:{$spupFooterContactEmail|escape}">{$spupFooterContactEmail|escape}</a>
        </section>
      {/if}
      <section aria-labelledby="spup-contact-publisher">
        <p class="spup-page-eyebrow">{translate key="plugins.themes.spupLightExplorerTheme.about.institution"}</p>
        <h2 id="spup-contact-publisher">{translate key="plugins.themes.spupLightExplorerTheme.root.publisher"}</h2>
        <p><strong>{translate key="plugins.themes.spupLightExplorerTheme.footer.institution"}</strong></p>
        <p><a href="{$spupInstitutionalUrl|escape}">{translate key="plugins.themes.spupLightExplorerTheme.root.institutionalWebsite"} <span aria-hidden="true">&nearr;</span></a></p>
      </section>
    </div>

    <section class="spup-contact__location" aria-labelledby="spup-contact-location">
      <p class="spup-page-eyebrow">{translate key="plugins.themes.spupLightExplorerTheme.about.whereWeAre"}</p>
      <h2 id="spup-contact-location">{translate key="plugins.themes.spupLightExplorerTheme.footer.location"}</h2>
      <address><strong>{translate key="plugins.themes.spupLightExplorerTheme.footer.institution"}</strong>{if $spupRootOptions.publisherAddress}<span>{$spupRootOptions.publisherAddress|escape|nl2br}</span>{/if}</address>
      {if $spupRootOptions.mapUrl && $spupRootOptions.showMapContact}{include file="frontend/components/rootLocationMap.tpl"}{/if}
    </section>
  </div>

  <section class="spup-contact__links" aria-labelledby="spup-contact-links-title">
    <p class="spup-page-eyebrow">{translate key="plugins.themes.spupLightExplorerTheme.contact.nextEyebrow"}</p>
    <h2 id="spup-contact-links-title">{translate key="plugins.themes.spupLightExplorerTheme.contact.publishingInformation"}</h2>
    <div class="spup-contact__link-list">
      <a href="{url page='journals'}">{translate key="plugins.themes.spupLightExplorerTheme.about.exploreJournals"} <span aria-hidden="true">&rarr;</span></a>
      <a href="{url page='search'}">{translate key="plugins.themes.spupLightExplorerTheme.about.searchPublications"} <span aria-hidden="true">&rarr;</span></a>
      <a href="{url page='about'}">{translate key="plugins.themes.spupLightExplorerTheme.contact.aboutNetwork"} <span aria-hidden="true">&rarr;</span></a>
      <a href="{url page='submission'}">{translate key="plugins.themes.spupLightExplorerTheme.root.submissionOverview"} <span aria-hidden="true">&rarr;</span></a>
    </div>
  </section>
</div>
