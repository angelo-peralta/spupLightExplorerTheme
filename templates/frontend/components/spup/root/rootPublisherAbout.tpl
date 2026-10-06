<div class="spup-publisher-page spup-publisher-about">
  <section class="spup-about__hero" aria-labelledby="spup-about-title">
    {include file="frontend/components/spup/layout/pageIntro.tpl" headingId="spup-about-title" title=$siteTitle eyebrowKey="plugins.themes.spupLightExplorerTheme.about.eyebrow" descriptionHtml=$spupAboutSections.intro descriptionKey="plugins.themes.spupLightExplorerTheme.about.intro"}
  </section>

  <section class="spup-about__section spup-about__story spup-publisher-section" aria-labelledby="spup-about-story-title">
    <div class="spup-about__section-heading">{include file="frontend/components/spup/content/sectionHeading.tpl" headingId="spup-about-story-title" eyebrowKey="plugins.themes.spupLightExplorerTheme.about.history" titleKey="plugins.themes.spupLightExplorerTheme.about.story"}</div>
    <div class="spup-about__story-copy spup-about__prose">
      {if $spupAboutSections.story}{$spupAboutSections.story|strip_unsafe_html}{else}
        <p>{translate key="plugins.themes.spupLightExplorerTheme.about.storyOne"}</p>
        <p>{translate key="plugins.themes.spupLightExplorerTheme.about.storyTwo"}</p>
        <p>{translate key="plugins.themes.spupLightExplorerTheme.about.storyThree"}</p>
      {/if}
    </div>
  </section>

  <section class="spup-about__section spup-publisher-section" aria-labelledby="spup-about-identity-title">
    <div class="spup-about__section-heading">{include file="frontend/components/spup/content/sectionHeading.tpl" headingId="spup-about-identity-title" eyebrowKey="plugins.themes.spupLightExplorerTheme.about.present" titleKey="plugins.themes.spupLightExplorerTheme.about.whoWeAre" hideRule=true}</div>
    <div class="spup-about__identity-grid">
      <div class="spup-about__prose">{if $spupAboutSections.identity}{$spupAboutSections.identity|strip_unsafe_html}{else}<p>{translate key="plugins.themes.spupLightExplorerTheme.about.identity"}</p>{/if}</div>
      <ul class="spup-about__function-list">
        <li><a href="{url page='journals'}">{translate key="plugins.themes.spupLightExplorerTheme.about.functionJournals"} <span aria-hidden="true">&rarr;</span></a></li>
        <li><a href="{url page='search'}">{translate key="plugins.themes.spupLightExplorerTheme.about.functionSearch"} <span aria-hidden="true">&rarr;</span></a></li>
        <li><a href="{url page='journals'}">{translate key="plugins.themes.spupLightExplorerTheme.about.functionIssues"} <span aria-hidden="true">&rarr;</span></a></li>
        <li><a href="{url page='announcement'}">{translate key="plugins.themes.spupLightExplorerTheme.about.functionAnnouncements"} <span aria-hidden="true">&rarr;</span></a></li>
        <li><a href="{if $spupRootOptions.showAboutSubmission}{url page='submission'}{else}{url page='journals'}{/if}">{translate key="plugins.themes.spupLightExplorerTheme.about.functionSubmit"} <span aria-hidden="true">&rarr;</span></a></li>
      </ul>
    </div>
  </section>

  {if $spupRootOptions.showAboutStats}<section class="spup-about__section spup-about__stats spup-publisher-section" aria-labelledby="spup-about-stats-title">
    <div class="spup-about__section-heading">{include file="frontend/components/spup/content/sectionHeading.tpl" headingId="spup-about-stats-title" eyebrowKey="plugins.themes.spupLightExplorerTheme.about.network" titleKey="plugins.themes.spupLightExplorerTheme.root.networkAtGlance" hideRule=true}</div>
    {include file="frontend/components/spup/root/rootNetworkStats.tpl"}
  </section>{/if}

  {if $spupRootOptions.showAboutJournals}<section class="spup-about__section spup-about__journals spup-publisher-section" aria-labelledby="spup-about-journals-title">
    <div class="spup-about__section-heading">{include file="frontend/components/spup/content/sectionHeading.tpl" headingId="spup-about-journals-title" eyebrowKey="plugins.themes.spupLightExplorerTheme.root.discover" titleKey="plugins.themes.spupLightExplorerTheme.about.ourJournals" hideRule=true}</div>
    <p class="spup-about__section-intro">{translate key="plugins.themes.spupLightExplorerTheme.about.journalsIntro"}</p>
    {assign var="spupGalleryJournals" value=$spupPublisherJournals}
    {include file="frontend/components/spup/root/rootJournalGallery.tpl"}
  </section>{/if}

  <section class="spup-about__section spup-about__structure spup-publisher-section" aria-labelledby="spup-about-structure-title">
    <div class="spup-about__section-heading">{include file="frontend/components/spup/content/sectionHeading.tpl" headingId="spup-about-structure-title" eyebrowKey="plugins.themes.spupLightExplorerTheme.about.structureEyebrow" titleKey="plugins.themes.spupLightExplorerTheme.about.structure" hideRule=true}</div>
    <div class="spup-about__prose spup-about__measure">{if $spupAboutSections.structure}{$spupAboutSections.structure|strip_unsafe_html}{else}<p>{translate key="plugins.themes.spupLightExplorerTheme.about.structureOne"}</p><p>{translate key="plugins.themes.spupLightExplorerTheme.about.structureTwo"}</p>{/if}</div>
  </section>

  <section class="spup-about__section spup-about__audiences spup-publisher-section" aria-label="{translate|escape key='plugins.themes.spupLightExplorerTheme.about.audiences'}">
    <div class="spup-about__audience" aria-labelledby="spup-about-readers-title">
      <p class="spup-page-eyebrow">{translate key="plugins.themes.spupLightExplorerTheme.about.audienceEyebrow"}</p><h2 id="spup-about-readers-title">{translate key="plugins.themes.spupLightExplorerTheme.about.readers"}</h2>
      <div class="spup-about__prose">{if $spupAboutSections.readers}{$spupAboutSections.readers|strip_unsafe_html}{else}<p>{translate key="plugins.themes.spupLightExplorerTheme.about.readersCopy"}</p>{/if}</div>
      <a class="spup-about__text-link" href="{url page='search'}">{translate key="plugins.themes.spupLightExplorerTheme.about.searchPublications"} <span aria-hidden="true">&rarr;</span></a>
    </div>
    <div class="spup-about__audience" aria-labelledby="spup-about-authors-title">
      <p class="spup-page-eyebrow">{translate key="plugins.themes.spupLightExplorerTheme.about.audienceEyebrow"}</p><h2 id="spup-about-authors-title">{translate key="plugins.themes.spupLightExplorerTheme.about.authors"}</h2>
      <div class="spup-about__prose">{if $spupAboutSections.authors}{$spupAboutSections.authors|strip_unsafe_html}{else}<p>{translate key="plugins.themes.spupLightExplorerTheme.about.authorsCopy"}</p>{/if}</div>
      <div class="spup-about__links"><a class="spup-about__text-link" href="{url page='journals'}">{translate key="plugins.themes.spupLightExplorerTheme.about.exploreJournals"} <span aria-hidden="true">&rarr;</span></a>{if $spupRootOptions.showAboutSubmission}<a class="spup-about__text-link" href="{url page='submission'}">{translate key="plugins.themes.spupLightExplorerTheme.root.submissionOverview"} <span aria-hidden="true">&rarr;</span></a>{/if}</div>
    </div>
  </section>

  {if $spupRootOptions.showAboutPublisher}<section class="spup-about__section spup-about__publisher spup-publisher-section" aria-labelledby="spup-about-publisher-title">
    <div class="spup-about__section-heading">{include file="frontend/components/spup/content/sectionHeading.tpl" headingId="spup-about-publisher-title" eyebrowKey="plugins.themes.spupLightExplorerTheme.about.institution" titleKey="plugins.themes.spupLightExplorerTheme.root.publisher" hideRule=true}</div>
    <div class="spup-about__publisher-grid">
      <address><strong>{translate key="plugins.themes.spupLightExplorerTheme.footer.institution"}</strong>{if $spupRootOptions.publisherAddress}<span>{$spupRootOptions.publisherAddress|escape|nl2br}</span>{/if}</address>
      <dl>{if $spupFooterContactEmail}<div><dt>{translate key="plugins.themes.spupLightExplorerTheme.root.publishingContact"}</dt><dd><a href="mailto:{$spupFooterContactEmail|escape}">{$spupFooterContactEmail|escape}</a></dd></div>{/if}<div><dt>{translate key="plugins.themes.spupLightExplorerTheme.about.institutionalWebsite"}</dt><dd><a href="{$spupInstitutionalUrl|escape}">{$spupInstitutionalUrl|escape}</a></dd></div></dl>
    </div>
  </section>{/if}

  <section class="spup-about__section spup-about__location spup-publisher-section" aria-labelledby="spup-about-location-title">
    <div class="spup-about__section-heading">{include file="frontend/components/spup/content/sectionHeading.tpl" headingId="spup-about-location-title" eyebrowKey="plugins.themes.spupLightExplorerTheme.about.whereWeAre" titleKey="plugins.themes.spupLightExplorerTheme.footer.location" hideRule=true}</div>
    <address><strong>{translate key="plugins.themes.spupLightExplorerTheme.footer.institution"}</strong>{if $spupRootOptions.publisherAddress}<span>{$spupRootOptions.publisherAddress|escape|nl2br}</span>{/if}</address>
    {if $spupRootOptions.mapUrl && $spupRootOptions.showMapAbout}{include file="frontend/components/spup/root/rootLocationMap.tpl"}{/if}
  </section>

  <section class="spup-about__section spup-about__platform spup-publisher-section" aria-labelledby="spup-about-platform-title">
    <div class="spup-about__section-heading">{include file="frontend/components/spup/content/sectionHeading.tpl" headingId="spup-about-platform-title" eyebrowKey="plugins.themes.spupLightExplorerTheme.about.platformEyebrow" titleKey="plugins.themes.spupLightExplorerTheme.about.platform" hideRule=true}</div>
    <div class="spup-about__prose spup-about__measure">{if $spupAboutSections.platform}{$spupAboutSections.platform|strip_unsafe_html}{else}<p>{translate key="plugins.themes.spupLightExplorerTheme.about.platformCopy"}</p>{/if}</div>
  </section>

  <section class="spup-about__section spup-about__next spup-publisher-section" aria-labelledby="spup-about-next-title">
    <div class="spup-about__section-heading">{include file="frontend/components/spup/content/sectionHeading.tpl" headingId="spup-about-next-title" eyebrowKey="plugins.themes.spupLightExplorerTheme.about.nextEyebrow" titleKey="plugins.themes.spupLightExplorerTheme.about.exploreNetwork" hideRule=true}</div>
    <div class="spup-about__links"><a class="spup-about__text-link" href="{url page='journals'}">{translate key="plugins.themes.spupLightExplorerTheme.about.exploreJournals"} <span aria-hidden="true">&rarr;</span></a><a class="spup-about__text-link" href="{url page='search'}">{translate key="plugins.themes.spupLightExplorerTheme.about.searchPublications"} <span aria-hidden="true">&rarr;</span></a>{if $spupRootOptions.showAboutSubmission}<a class="spup-about__text-link" href="{url page='submission'}">{translate key="plugins.themes.spupLightExplorerTheme.root.submissionOverview"} <span aria-hidden="true">&rarr;</span></a>{/if}</div>
  </section>
</div>
