{**
 * Copyright (c) 2014-2025 Simon Fraser University
 * Copyright (c) 2003-2025 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see docs/COPYING.
 * Article body and native plugin hooks adapted from PKP Classic.
 *}
{if $publication->getLocalizedData('abstract')}
  <section class="spup-article__section abstract"><h2>{translate key="article.abstract"}</h2>{$publication->getLocalizedData('abstract')|strip_unsafe_html}</section>
{/if}
{assign var=keywords value=$publication->getLocalizedData('keywords')}
{if !empty($keywords)}
  <section class="spup-article__section keywords">
    <h2>{translate key="article.subject"}</h2>
    <ul class="spup-article__keywords">{foreach from=$keywords item=keyword}<li>{$keyword.name|escape}</li>{/foreach}</ul>
  </section>
{/if}
{if $publication->getLocalizedData('dataAvailability')}
  <section class="spup-article__section dataAvailability"><h2>{translate key="submission.dataAvailability"}</h2>{$publication->getLocalizedData('dataAvailability')|strip_unsafe_html}</section>
{/if}
{if count($parsedCitations) || (string) $publication->getData('citationsRaw')}
  <section class="spup-article__section references">
    <h2>{translate key="submission.citations"}</h2>
    {if count($parsedCitations)}
      <ol class="references-list">
        {foreach from=$parsedCitations item=parsedCitation}<li>{$parsedCitation->getCitationWithLinks()|strip_unsafe_html} {call_hook name="Templates::Article::Details::Reference" citation=$parsedCitation}</li>{/foreach}
      </ol>
    {else}
      <div class="references-raw">{$publication->getData('citationsRaw')|escape|nl2br}</div>
    {/if}
  </section>
{/if}
{capture assign=spupArticleDetailsOutput}{call_hook name="Templates::Article::Details"}{/capture}
{if !empty(trim($spupArticleDetailsOutput))}<div class="spup-article__citation">{$spupArticleDetailsOutput}</div>{/if}
{assign var=licenseTerms value=$currentContext->getLocalizedData('licenseTerms')}
{assign var=licenseUrl value=$publication->getData('licenseUrl')}
{assign var=copyrightHolder value=$publication->getLocalizedData('copyrightHolder')}
{if $licenseTerms || $licenseUrl || $copyrightHolder}
  <section class="spup-article__section spup-article__license">
    <h2>{translate key="submission.license"}</h2>
    {if $copyrightHolder}<p>{translate key="submission.copyrightStatement" copyrightHolder=$copyrightHolder|escape copyrightYear=$publication->getData('copyrightYear')|escape}</p>{/if}
    {if $licenseUrl}{if $ccLicenseBadge}{$ccLicenseBadge}{else}<p><a href="{$licenseUrl|escape}">{$licenseUrl|escape}</a></p>{/if}{/if}
    {if $licenseTerms && !$licenseUrl}<div>{$licenseTerms|strip_unsafe_html}</div>{/if}
  </section>
{/if}
{assign var=hasBiographies value=0}
{foreach from=$publication->getData('authors') item=author}
  {if $author->getLocalizedBiography()}{assign var=hasBiographies value=$hasBiographies+1}{/if}
{/foreach}
{if $hasBiographies}
  <section class="spup-article__section spup-article__biographies">
    <h2>{translate key="submission.authorBiographies"}</h2>
    {foreach from=$publication->getData('authors') item=author}
      {if $author->getLocalizedBiography()}<div class="spup-article__biography"><h3>{$author->getFullName()|escape}</h3>{$author->getLocalizedBiography()|strip_unsafe_html}</div>{/if}
    {/foreach}
  </section>
{/if}
{if count($article->getPublishedPublications()) > 1}
  <section class="spup-article__section spup-article__versions"><h2>{translate key="submission.versions"}</h2><ul>
    {foreach from=array_reverse($article->getPublishedPublications()) item=iPublication}
      <li>{if $iPublication->getId() === $publication->getId()}{$iPublication->getData('datePublished')|date_format:$dateFormatShort}{else}<a href="{url page="article" op="view" path=$article->getBestId()|to_array:"version":$iPublication->getId()}">{$iPublication->getData('datePublished')|date_format:$dateFormatShort}</a>{/if}</li>
    {/foreach}
  </ul></section>
{/if}
<div class="spup-article__supplemental">{call_hook name="Templates::Article::Main"}</div>
<div class="footer-hook-block spup-article__similar">{call_hook name="Templates::Article::Footer::PageFooter"}</div>
