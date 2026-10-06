{if $announcements|@count}
<div class="spup-journal-band spup-journal-band--white">
  <section class="spup-journal-band__inner spup-site-container spup-journal-announcements" aria-labelledby="spup-journal-announcements-heading">
    {include file="frontend/components/spup/content/sectionHeading.tpl" headingId="spup-journal-announcements-heading" eyebrow=$journalInitials titleKey="announcement.announcements"}
    <ol class="spup-editorial-list">
      {foreach from=$announcements item=announcement}
        {include file="frontend/components/spup/content/announcementRow.tpl" announcement=$announcement headingLevel="h3" showExcerpt=true readKey="plugins.themes.spupLightExplorerTheme.journal.readAnnouncement"}
      {/foreach}
    </ol>
  </section>
</div>
{/if}
