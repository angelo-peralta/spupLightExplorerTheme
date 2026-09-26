<aside class="spup-auth-identity" aria-label="{translate|escape key='plugins.themes.spupLightExplorerTheme.footer.institution'}">
  {if $displayPageHeaderLogo}
    <img src="{$sitePublicFilesDir}/{$displayPageHeaderLogo.uploadName|escape:'url'}" alt="" loading="eager">
  {/if}
  <p class="spup-auth-identity__institution">{translate key="plugins.themes.spupLightExplorerTheme.footer.institution"}</p>
  <p class="spup-auth-identity__title">{$siteTitle|escape}</p>
  <p class="spup-auth-identity__subtitle">{$spupRootOptions.networkSubtitle|escape}</p>
</aside>
