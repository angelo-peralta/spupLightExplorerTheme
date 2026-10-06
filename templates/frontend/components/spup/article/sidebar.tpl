{**
 * Copyright (c) 2014-2025 Simon Fraser University
 * Copyright (c) 2003-2025 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see docs/COPYING.
 * Article sidebar assembled from native publication data and prepared metrics.
 *}
{include file="frontend/components/spup/article/access.tpl"
  spupFeaturedGalley=$spupFeaturedGalley
  spupFeaturedIsSupplementary=$spupFeaturedIsSupplementary
  spupHasOtherGalleys=$spupHasOtherGalleys
}
{if $section}{assign var=spupArticleSectionTitle value=$section->getLocalizedTitle()}{else}{assign var=spupArticleSectionTitle value=''}{/if}
{if $publication->getData('datePublished') || $issue || $doiObject || $categories || $spupArticleSectionTitle}
  <section class="spup-article__side-section spup-article__information">
    <h2>Article Information</h2>
    <dl>
      {if $publication->getData('datePublished')}<div><dt>Published</dt><dd>{$publication->getData('datePublished')|date_format:$dateFormatShort}</dd></div>{/if}
      {if $issue}<div><dt>Issue</dt><dd><a href="{url page="issue" op="view" path=$issue->getBestIssueId()}">{$issue->getIssueIdentification()|escape}</a></dd></div>{/if}
      {if $spupArticleSectionTitle}<div><dt>{translate key="section.section"}</dt><dd>{$spupArticleSectionTitle|escape}</dd></div>{/if}
      {if $doiObject}<div><dt>DOI</dt><dd><a href="{$doiObject->getData('resolvingUrl')|escape}">{$doiObject->getData('resolvingUrl')|escape}</a></dd></div>{/if}
      {if $categories}<div><dt>{translate key="category.category"}</dt><dd>{foreach name=categories from=$categories item=category}<a href="{url router=$smarty.const.ROUTE_PAGE page="catalog" op="category" path=$category->getPath()|escape}">{$category->getLocalizedTitle()|escape}</a>{if !$smarty.foreach.categories.last}, {/if}{/foreach}</dd></div>{/if}
    </dl>
  </section>
{/if}
{if $spupArticleMetrics}
  <section class="spup-article__side-section spup-article__metrics" aria-label="Article metrics">
    <h2>Article Metrics</h2>
    <div class="spup-article__metric-list">
      <div class="spup-article__metric"><span class="spup-article__metric-ring"><strong>{$spupArticleMetrics.abstract|escape}</strong></span><span>Views</span></div>
      <div class="spup-article__metric"><span class="spup-article__metric-ring"><strong>{$spupArticleMetrics.downloads|escape}</strong></span><span>Downloads</span></div>
    </div>
  </section>
{/if}
{if $issue}
  <section class="spup-article__side-section spup-article__issue">
    <h2>In This Issue</h2>
    <p>{$issue->getIssueIdentification()|escape} <a href="{url page="issue" op="view" path=$issue->getBestIssueId()}">View Full Issue <span aria-hidden="true">&rarr;</span></a></p>
  </section>
{/if}
