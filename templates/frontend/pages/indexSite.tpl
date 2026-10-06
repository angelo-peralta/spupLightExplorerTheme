{include file="frontend/components/header.tpl" spupSiteHeroHeading=true spupLandingPage=true}
<main class="page_index_site">
  {include file="frontend/components/spup/root/hero.tpl" rootOptions=$spupRootOptions}
  <div class="spup-site-container spup-site-content">
    {include file="frontend/components/spup/root/journalSection.tpl" journals=$journals}
    {include file="frontend/components/spup/root/latest.tpl" showPublications=$spupRootOptions.showLatestScholarship publications=$spupRecentPublications announcements=$spupNetworkAnnouncements}
  </div>
</main>
{include file="frontend/components/footer.tpl"}
