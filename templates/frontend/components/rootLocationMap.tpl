{if $spupRootOptions.mapUrl}
  <div class="spup-location-map">
    <iframe src="{$spupRootOptions.mapUrl|escape}" title="{translate|escape key='plugins.themes.spupLightExplorerTheme.root.mapTitle'}" loading="lazy" referrerpolicy="no-referrer-when-downgrade" allowfullscreen></iframe>
  </div>
{/if}
