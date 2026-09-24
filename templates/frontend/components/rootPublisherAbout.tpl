<div class="spup-publisher-page spup-publisher-about">
  {if $spupSiteAbout || $content}<section class="spup-publisher-section" aria-labelledby="spup-about-network">
    <h2 id="spup-about-network">{translate key="plugins.themes.spupLightExplorerTheme.root.aboutNetwork"}</h2>
    <div class="spup-publisher-prose">{if $spupSiteAbout}{$spupSiteAbout|strip_unsafe_html}{elseif $content}{$content|strip_unsafe_html}{/if}</div>
  </section>{/if}
  {if $spupRootOptions.showAboutStats}
    <section class="spup-publisher-section" aria-labelledby="spup-about-stats">
      <h2 id="spup-about-stats">{translate key="plugins.themes.spupLightExplorerTheme.root.networkAtGlance"}</h2>
      {include file="frontend/components/rootNetworkStats.tpl"}
    </section>
  {/if}
  {if $spupRootOptions.showAboutJournals}
    <section class="spup-publisher-section" aria-labelledby="spup-about-journals">
      <h2 id="spup-about-journals">{translate key="plugins.themes.spupLightExplorerTheme.root.exploreJournals"}</h2>
      {assign var="spupGalleryJournals" value=$spupPublisherJournals}
      {include file="frontend/components/rootJournalGallery.tpl"}
    </section>
  {/if}
  {if $spupRootOptions.showAboutPublisher}
    <section class="spup-publisher-section" aria-labelledby="spup-about-publisher">
      <h2 id="spup-about-publisher">{translate key="plugins.themes.spupLightExplorerTheme.root.publisher"}</h2>
      <p><strong>{translate key="plugins.themes.spupLightExplorerTheme.footer.institution"}</strong></p>
      {if $spupRootOptions.publisherAddress}<p>{$spupRootOptions.publisherAddress|escape|nl2br}</p>{/if}
      {if $spupFooterContactEmail}<p><a href="mailto:{$spupFooterContactEmail|escape}">{$spupFooterContactEmail|escape}</a></p>{/if}
      <p><a href="{$spupInstitutionalUrl|escape}">{translate key="plugins.themes.spupLightExplorerTheme.root.institutionalWebsite"}</a></p>
    </section>
  {/if}
  {if $spupRootOptions.mapUrl && $spupRootOptions.showMapAbout}
    <section class="spup-publisher-section" aria-labelledby="spup-about-location">
      <h2 id="spup-about-location">{translate key="plugins.themes.spupLightExplorerTheme.footer.location"}</h2>
      {include file="frontend/components/rootLocationMap.tpl"}
    </section>
  {/if}
  {if $spupRootOptions.showAboutSubmission}
    <section class="spup-publisher-section spup-publisher-cta" aria-labelledby="spup-about-submit">
      <h2 id="spup-about-submit">{translate key="plugins.themes.spupLightExplorerTheme.root.publishWithUs"}</h2>
      <p>{translate key="plugins.themes.spupLightExplorerTheme.root.submitHelp"}</p>
      <a class="spup-publisher-button" href="{url page='publisher-submit'}">{translate key="plugins.themes.spupLightExplorerTheme.root.submissionOverview"} <span aria-hidden="true">&rarr;</span></a>
    </section>
  {/if}
</div>
