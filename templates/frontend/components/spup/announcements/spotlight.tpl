{** One OJS announcement spotlight shared by the root site and every journal. *}
{if !empty($spupSpotlightAnnouncements)}
<div class="spup-announcement-spotlight" data-spup-spotlight data-context-key="{$spupSpotlightContextKey|escape}" hidden>
  <div class="spup-announcement-spotlight__dialog" role="dialog" aria-modal="true" aria-labelledby="spupSpotlightHeading" tabindex="-1">
    <div class="spup-announcement-spotlight__header">
      <p id="spupSpotlightHeading" class="spup-announcement-spotlight__heading">{translate key="plugins.themes.spupLightExplorerTheme.spotlight.announcements"}</p>
      <div class="spup-announcement-spotlight__controls">
        <span class="spup-announcement-spotlight__counter" data-spotlight-counter data-of-label="{translate|escape key="plugins.themes.spupLightExplorerTheme.spotlight.of"}" aria-live="polite" hidden></span>
        <button class="spup-announcement-spotlight__icon" type="button" data-spotlight-previous aria-label="{translate|escape key="plugins.themes.spupLightExplorerTheme.spotlight.previous"}" hidden><span aria-hidden="true">&larr;</span></button>
        <button class="spup-announcement-spotlight__icon" type="button" data-spotlight-next aria-label="{translate|escape key="plugins.themes.spupLightExplorerTheme.spotlight.next"}" hidden><span aria-hidden="true">&rarr;</span></button>
        <button class="spup-announcement-spotlight__icon spup-announcement-spotlight__close" type="button" data-spotlight-close aria-label="{translate|escape key="plugins.themes.spupLightExplorerTheme.spotlight.close"}"><span aria-hidden="true">&times;</span></button>
      </div>
    </div>
    <div class="spup-announcement-spotlight__body" data-spotlight-body aria-live="polite">
      {foreach from=$spupSpotlightAnnouncements item=item}
        <article class="spup-announcement-spotlight__story{if $item.imageUrl} spup-announcement-spotlight__story--with-image{/if}" data-spotlight-story data-announcement-id="{$item.id|escape}" hidden>
          {if $item.imageUrl}<div class="spup-announcement-spotlight__media"><img src="{$item.imageUrl|escape}" alt="{$item.imageAlt|escape}" loading="eager" decoding="async"></div>{/if}
          <div class="spup-announcement-spotlight__content">
            <p class="spup-announcement-spotlight__category">{if $item.category}{$item.category|escape}{else}{translate key="plugins.themes.spupLightExplorerTheme.spotlight.announcement"}{/if}</p>
            <h2 id="spupSpotlightTitle{$item.id|escape}" class="spup-announcement-spotlight__title">{$item.title|escape}</h2>
            <time class="spup-announcement-spotlight__date" datetime="{$item.datePosted|date_format:'Y-m-d'|escape}">{$item.datePosted|date_format:$dateFormatShort}</time>
          </div>
          <div class="spup-announcement-spotlight__summary">
            {if $item.excerpt}<p id="spupSpotlightExcerpt{$item.id|escape}" class="spup-announcement-spotlight__excerpt">{$item.excerpt|escape}</p>{/if}
            <a class="spup-announcement-spotlight__read" data-spotlight-read href="{url router=$smarty.const.ROUTE_PAGE page="announcement" op="view" path=$item.id}">{translate key="plugins.themes.spupLightExplorerTheme.spotlight.readFull"} <span aria-hidden="true">&rarr;</span></a>
          </div>
        </article>
      {/foreach}
    </div>
    <div class="spup-announcement-spotlight__footer">
      <a data-spotlight-view-all href="{url router=$smarty.const.ROUTE_PAGE page="announcement"}">{translate key="plugins.themes.spupLightExplorerTheme.spotlight.viewAll"} <span aria-hidden="true">&rarr;</span></a>
    </div>
  </div>
</div>
{/if}
