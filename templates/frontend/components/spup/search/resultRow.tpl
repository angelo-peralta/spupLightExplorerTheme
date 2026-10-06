{**
 * Root cross-journal result and native journal article summary.
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2003-2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *}
<div class="spup-search-result">
  {if !$currentContext}
    {assign var=spupResultPublication value=$result.publishedSubmission->getCurrentPublication()}
    {if $spupResultPublication}
      <p class="spup-search-result-type">{translate key="plugins.themes.spupLightExplorerTheme.root.researchArticle"}</p>
      <h2><a href="{url journal=$result.journal->getPath() page="article" op="view" path=$result.publishedSubmission->getBestId()}">{$spupResultPublication->getLocalizedFullTitle(null, 'text')|escape}</a></h2>
      <p class="spup-search-result-journal">{$result.journal->getLocalizedName()|escape}</p>
      {assign var=spupResultAuthors value=$activeTheme->getPublicationAuthors($spupResultPublication)}
      {if $spupResultAuthors}<p class="spup-search-result-authors">{$spupResultAuthors|escape}</p>{/if}
      {if $spupResultPublication->getData('datePublished')}<time datetime="{$spupResultPublication->getData('datePublished')|date_format:'Y-m-d'|escape}">{$spupResultPublication->getData('datePublished')|date_format:$dateFormatShort}</time>{/if}
      {if $spupResultPublication->getLocalizedData('abstract')}<div class="spup-search-result-abstract">{$spupResultPublication->getLocalizedData('abstract')|strip_unsafe_html}</div>{/if}
      <a class="spup-text-link" href="{url journal=$result.journal->getPath() page="article" op="view" path=$result.publishedSubmission->getBestId()}">{translate key="plugins.themes.spupLightExplorerTheme.root.readArticle"} <span aria-hidden="true">&rarr;</span></a>
    {/if}
  {else}
    {include file="frontend/objects/article_summary.tpl" headingLevel="2" article=$result.publishedSubmission journal=$result.journal showDatePublished=true hideGalleys=true}
  {/if}
</div>
