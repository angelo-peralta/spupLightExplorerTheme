{if $recentPublications|@count || $informationLinks|@count || $audienceLinks|@count || $hasSidebar}
<section class="spup-journal-band spup-journal-band--light" aria-label="{translate|escape key='plugins.themes.spupLightExplorerTheme.journal.latestArticles'}">
  <div class="spup-journal-band__inner spup-site-container spup-journal-row{if !$recentPublications|@count} spup-journal-row--single{/if}">
    {if $recentPublications|@count}
      <section class="spup-journal-latest spup-journal-panel" aria-labelledby="spup-journal-latest-heading">
        {include file="frontend/components/spup/content/sectionHeading.tpl" headingId="spup-journal-latest-heading" eyebrowKey="plugins.themes.spupLightExplorerTheme.root.publishing" titleKey="plugins.themes.spupLightExplorerTheme.journal.latestArticles"}
        <ol class="spup-editorial-list">
          {foreach from=$recentPublications item=recent}
            {include file="frontend/components/spup/content/publicationRow.tpl" submission=$recent.submission publication=$recent.publication authors=$recent.authors datePublished=$recent.datePublished headingLevel="h3" variant="journal"}
          {/foreach}
        </ol>
      </section>
    {/if}
    <div class="spup-journal-information-column spup-journal-panel">
      {if $informationLinks|@count || $audienceLinks|@count}
        <section class="spup-journal-information" aria-labelledby="spup-journal-information-heading">
          {include file="frontend/components/spup/content/sectionHeading.tpl" headingId="spup-journal-information-heading" eyebrow=$journalInitials titleKey="plugins.themes.spupLightExplorerTheme.journal.information"}
          {include file="frontend/components/spup/content/resourceList.tpl" items=$informationLinks}
          {if $audienceLinks|@count}
            <nav class="spup-journal-information__resources" aria-label="{translate|escape key='plugins.themes.spupLightExplorerTheme.journal.resources'}">
              <h3>{translate key="plugins.themes.spupLightExplorerTheme.journal.resources"}</h3>
              {include file="frontend/components/spup/content/resourceList.tpl" items=$audienceLinks}
            </nav>
          {/if}
        </section>
      {/if}
      {if $hasSidebar}<aside class="spup-journal-layout__sidebar sidebar_wrapper">{call_hook name="Templates::Common::Sidebar"}</aside>{/if}
    </div>
  </div>
</section>
{/if}
