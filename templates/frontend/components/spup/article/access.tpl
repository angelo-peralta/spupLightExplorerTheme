{**
 * Copyright (c) 2014-2025 Simon Fraser University
 * Copyright (c) 2003-2025 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see docs/COPYING.
 * Native OJS galley links, access decisions, and citation plugin output.
 *}
{if $spupFeaturedGalley || ($citation && ($citationStyles || $citationDownloads))}
  <section class="spup-article__side-section spup-article__access">
    <h2>Article Access</h2>
    {if $spupFeaturedGalley}
      <div class="spup-article__access-actions">
        {include file="frontend/objects/galley_link.tpl" parent=$article publication=$publication galley=$spupFeaturedGalley isSupplementary=$spupFeaturedIsSupplementary spupFeaturedAction=true purchaseFee=$currentJournal->getSetting('purchaseArticleFee') purchaseCurrency=$currentJournal->getSetting('currency')}
        {if $spupFeaturedGalley->isPdfGalley() && $spupFeaturedGalley->getData('submissionFileId') && !$spupFeaturedGalley->getData('urlRemote') && $hasAccess}
          {if $publication->getId() !== $article->getData('currentPublicationId')}
            {assign var=spupDownloadPath value=$article->getBestId()|to_array:"version":$publication->getId():$spupFeaturedGalley->getBestGalleyId()}
          {else}
            {assign var=spupDownloadPath value=$article->getBestId()|to_array:$spupFeaturedGalley->getBestGalleyId()}
          {/if}
          <a class="spup-article__download" href="{url page="article" op="download" path=$spupDownloadPath}">Download PDF <span aria-hidden="true">&rarr;</span></a>
        {/if}
      </div>
    {/if}
    {if $spupHasOtherGalleys}
      <details class="spup-article__more-formats"><summary>More Formats</summary><ul>
        {foreach from=$primaryGalleys item=galley}
          {if $galley->getId() !== $spupFeaturedGalley->getId()}<li>{include file="frontend/objects/galley_link.tpl" parent=$article publication=$publication galley=$galley purchaseFee=$currentJournal->getSetting('purchaseArticleFee') purchaseCurrency=$currentJournal->getSetting('currency')}</li>{/if}
        {/foreach}
        {foreach from=$supplementaryGalleys item=galley}
          {if $galley->getId() !== $spupFeaturedGalley->getId()}<li>{include file="frontend/objects/galley_link.tpl" parent=$article publication=$publication galley=$galley isSupplementary="1"}</li>{/if}
        {/foreach}
      </ul></details>
    {/if}
    {if $citation && ($citationStyles || $citationDownloads)}
      {include file="frontend/objects/article_citation_formats.tpl"}
    {/if}
  </section>
{/if}
