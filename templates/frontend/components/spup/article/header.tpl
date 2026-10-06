{**
 * Copyright (c) 2014-2025 Simon Fraser University
 * Copyright (c) 2003-2025 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see docs/COPYING.
 * Article identity adapted from PKP Classic.
 *}
{assign var=spupArticleIssueCover value=$issue && $issue->getLocalizedCoverImageUrl()}
<header class="spup-article__header{if !$spupArticleIssueCover} spup-article__header--no-cover{/if}">
  {if $spupArticleIssueCover}
    {capture assign=spupArticleIssueUrl}{url page="issue" op="view" path=$issue->getBestIssueId() escape=false}{/capture}
    {include file="frontend/components/spup/layout/coverMedia.tpl"
      imageUrl=$issue->getLocalizedCoverImageUrl()
      alt=$issue->getLocalizedCoverImageAltText()|default:$issue->getIssueIdentification()
      linkUrl=$spupArticleIssueUrl
      variant="article"
      className="spup-article__cover"
      showOffset=true
      loading="eager"
    }
  {/if}
  <div class="spup-article__identity">
    <h1 class="page_title article-full-title"><span id="spup-article-title-text" class="spup-article__title-text">{$publication->getLocalizedFullTitle(null, 'html')|strip_unsafe_html}</span></h1>
    <button type="button" class="spup-article__title-toggle" aria-controls="spup-article-title-text" aria-expanded="false" data-show-full-title-label="{translate|escape key='plugins.themes.spupLightExplorerTheme.article.showFullTitle'}" data-show-less-title-label="{translate|escape key='plugins.themes.spupLightExplorerTheme.article.showLessTitle'}" hidden>{translate key='plugins.themes.spupLightExplorerTheme.article.showFullTitle'}</button>
    {include file="frontend/components/spup/article/authorList.tpl" publication=$publication}
    {if $doiObject}<dl class="spup-article__meta"><div><dt>DOI</dt><dd><a href="{$doiObject->getData('resolvingUrl')|escape}">{$doiObject->getData('resolvingUrl')|escape}</a></dd></div></dl>{/if}
  </div>
</header>
