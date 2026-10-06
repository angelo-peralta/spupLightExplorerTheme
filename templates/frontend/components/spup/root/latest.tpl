{if $showPublications || $announcements|@count}
<section class="spup-latest" aria-labelledby="spup-latest-heading">
  {if $showPublications}
    {include file="frontend/components/spup/content/sectionHeading.tpl" headingId="spup-latest-heading" eyebrowKey="plugins.themes.spupLightExplorerTheme.root.publishing" titleKey="plugins.themes.spupLightExplorerTheme.root.latestScholarship"}
  {else}
    {include file="frontend/components/spup/content/sectionHeading.tpl" headingId="spup-latest-heading" eyebrowKey="plugins.themes.spupLightExplorerTheme.root.publishing" titleKey="announcement.announcements"}
  {/if}
  <div class="spup-latest__columns{if !$showPublications || !$announcements|@count} spup-latest__columns--single{/if}">
    {if $showPublications}
      <div class="spup-latest__publications">
        <h3>{translate key="plugins.themes.spupLightExplorerTheme.root.recentPublications"}</h3>
        {if $publications|@count}
          <ol class="spup-editorial-list">
            {foreach from=$publications item=recent}
              {include file="frontend/components/spup/content/publicationRow.tpl" submission=$recent.submission publication=$recent.publication journal=$recent.journal authors=$recent.authors datePublished=$recent.datePublished headingLevel="h4"}
            {/foreach}
          </ol>
        {else}<p class="spup-empty-state">{translate key="plugins.themes.spupLightExplorerTheme.root.noPublications"}</p>{/if}
      </div>
    {/if}
    {if $announcements|@count}
      <aside class="spup-latest__announcements" aria-labelledby="spup-latest-announcements-heading">
        <h3 id="spup-latest-announcements-heading">{translate key="announcement.announcements"}</h3>
        <ol class="spup-editorial-list">
          {foreach from=$announcements item=announcement}
            {include file="frontend/components/spup/content/announcementRow.tpl" announcement=$announcement headingLevel="h4" showArrow=true showExcerpt=false}
          {/foreach}
        </ol>
        <a class="spup-text-link" href="{url page="announcement"}">{translate key="plugins.themes.spupLightExplorerTheme.root.allAnnouncements"} <span aria-hidden="true">&rarr;</span></a>
      </aside>
    {/if}
  </div>
</section>
{/if}
