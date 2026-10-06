{**
 * templates/frontend/objects/article_details.tpl
 *
 * Copyright (c) 2014-2025 Simon Fraser University
 * Copyright (c) 2003-2025 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see docs/COPYING.
 *
 * @brief Article object composed from theme presentation partials and native OJS data.
 * @uses $article Submission
 * @uses $publication Publication being displayed, including older published versions
 * @uses $primaryGalleys array OJS-filtered primary galleys for this publication
 * @uses $supplementaryGalleys array OJS-filtered supplementary galleys
 * @hook Templates::Article::Main []
 * @hook Templates::Article::Details::Reference []
 * @hook Templates::Article::Details []
 * @hook Templates::Article::Footer::PageFooter []
 *}
<article class="obj_article_details spup-article">
  {if $publication->getData('status') !== PKP\submission\PKPSubmission::STATUS_PUBLISHED}
    <div class="cmp_notification notice" role="alert">
      {capture assign="submissionUrl"}{url page="dashboard" op="editorial" workflowSubmissionId=$article->getId()}{/capture}
      {translate key="submission.viewingPreview" url=$submissionUrl}
    </div>
  {/if}
  {if $currentPublication->getId() !== $publication->getId()}
    <div class="cmp_notification notice" role="alert">
      {capture assign="latestVersionUrl"}{url page="article" op="view" path=$article->getBestId()}{/capture}
      {translate key="submission.outdatedVersion" datePublished=$publication->getData('datePublished')|date_format:$dateFormatShort urlRecentVersion=$latestVersionUrl|escape}
    </div>
  {/if}

  {assign var=doiObject value=$publication->getData('doiObject')}
  {include file="frontend/components/spup/article/header.tpl" publication=$publication issue=$issue doiObject=$doiObject}

  {* ArticleHandler supplies published galleys for this publication with a file or remote URL. *}
  {assign var=spupFeaturedGalley value=null}
  {assign var=spupFeaturedIsSupplementary value=false}
  {foreach from=$primaryGalleys item=galley}
    {if !$spupFeaturedGalley && $galley->isPdfGalley()}{assign var=spupFeaturedGalley value=$galley}{/if}
  {/foreach}
  {if !$spupFeaturedGalley}
    {foreach from=$primaryGalleys item=galley}{if !$spupFeaturedGalley}{assign var=spupFeaturedGalley value=$galley}{/if}{/foreach}
  {/if}
  {if !$spupFeaturedGalley}
    {foreach from=$supplementaryGalleys item=galley}{if !$spupFeaturedGalley}{assign var=spupFeaturedGalley value=$galley}{assign var=spupFeaturedIsSupplementary value=true}{/if}{/foreach}
  {/if}
  {assign var=spupHasOtherGalleys value=false}
  {if $spupFeaturedGalley}
    {foreach from=$primaryGalleys item=galley}{if $galley->getId() !== $spupFeaturedGalley->getId()}{assign var=spupHasOtherGalleys value=true}{/if}{/foreach}
    {foreach from=$supplementaryGalleys item=galley}{if $galley->getId() !== $spupFeaturedGalley->getId()}{assign var=spupHasOtherGalleys value=true}{/if}{/foreach}
  {/if}

  <div class="spup-article__grid">
    <div class="spup-article__reading">
      {include file="frontend/components/spup/article/reading.tpl" article=$article publication=$publication}
    </div>
    <aside class="spup-article__sidebar" aria-label="Article details">
      {include file="frontend/components/spup/article/sidebar.tpl"
        article=$article
        publication=$publication
        issue=$issue
        doiObject=$doiObject
        spupFeaturedGalley=$spupFeaturedGalley
        spupFeaturedIsSupplementary=$spupFeaturedIsSupplementary
        spupHasOtherGalleys=$spupHasOtherGalleys
      }
    </aside>
  </div>
</article>
