{if $stats}
<div class="spup-journal-band spup-journal-band--light">
  <section class="spup-journal-band__inner spup-site-container spup-journal-statistics" aria-labelledby="spup-journal-statistics-heading">
    {include file="frontend/components/spup/content/sectionHeading.tpl" headingId="spup-journal-statistics-heading" eyebrow=$journalInitials titleKey="plugins.themes.spupLightExplorerTheme.journal.statistics"}
    <dl class="spup-network-stats" aria-label="{translate|escape key='plugins.themes.spupLightExplorerTheme.journal.statistics'}">
      <div><dt>{translate key="plugins.themes.spupLightExplorerTheme.root.articles"}</dt><dd>{$stats.articles|escape}</dd></div>
      <div><dt>{translate key="plugins.themes.spupLightExplorerTheme.root.issues"}</dt><dd>{$stats.issues|escape}</dd></div>
    </dl>
  </section>
</div>
{/if}
