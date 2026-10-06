{**
 * Copyright (c) 2014-2025 Simon Fraser University
 * Copyright (c) 2003-2025 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see docs/COPYING.
 * Author presentation adapted from PKP Classic; OJS supplies publication authors.
 *}
{if $publication->getData('authors')}
  <div class="spup-article__authors">
    <h2 class="pkp_screen_reader">{translate key="article.authors"}</h2>
    <ul>
      {foreach from=$publication->getData('authors') item=author}
        {assign var=authorUserGroup value=$userGroupsById[$author->getData('userGroupId')]}
        <li class="spup-article__author{if $author->getId() === $publication->getData('primaryContactId')} spup-article__author--primary{/if}">
          <span class="spup-article__author-line">
            <span class="spup-article__author-card">
              <button type="button" class="spup-article__author-name" aria-label="Author information for {$author->getFullName()|escape}">{$author->getFullName()|escape}<span class="spup-article__author-info-icon" aria-hidden="true">i</span></button>
              <span class="spup-article__author-popover" role="group" aria-label="Information for {$author->getFullName()|escape}">
                <strong>{$author->getFullName()|escape}</strong>
                {if $author->getId() === $publication->getData('primaryContactId')}<span class="spup-article__author-popover-role">Corresponding author</span>{/if}
                {if $author->getLocalizedAffiliationNamesAsString()}<span><b>Institution</b>{$author->getLocalizedAffiliationNamesAsString(null, ', ')|escape}</span>{/if}
                {if $author->getCountryLocalized()}<span><b>Country</b>{$author->getCountryLocalized()|escape}</span>{/if}
                {if $author->getEmail()}<span><b>Email</b><a href="mailto:{$author->getEmail()|escape}">{$author->getEmail()|escape}</a></span>{/if}
                {if $authorUserGroup && $authorUserGroup->showTitle}<span><b>Role</b>{$authorUserGroup->getLocalizedData('name')|escape}</span>{/if}
                {if $author->getData('orcid')}<span><b>ORCID</b><a href="{$author->getData('orcid')|escape}" target="_blank" rel="noopener noreferrer">{$author->getOrcidDisplayValue()|escape}</a></span>{/if}
              </span>
            </span>
            {if $author->getId() === $publication->getData('primaryContactId')}<span class="spup-article__primary-badge">Corresponding author</span>{/if}
            {if $author->getData('orcid')}<a class="spup-article__orcid" href="{$author->getData('orcid')|escape}" target="_blank" rel="noopener noreferrer" aria-label="ORCID for {$author->getFullName()|escape}">{if $author->hasVerifiedOrcid()}{$orcidIcon|default:'iD'}{else}{$orcidUnauthenticatedIcon|default:'iD'}{/if}</a>{/if}
          </span>
          {if $author->getLocalizedAffiliationNamesAsString() || count($author->getAffiliations()) > 0}
            <span class="spup-article__affiliation">
              {$author->getLocalizedAffiliationNamesAsString(null, ', ')|escape}
              {foreach from=$author->getAffiliations() item=affiliation}
                {if $affiliation->getRor()}<a class="spup-article__ror" href="{$affiliation->getRor()|escape}" target="_blank" rel="noopener noreferrer" aria-label="ROR for {$author->getFullName()|escape}">{if $rorIdIcon}{$rorIdIcon}{else}ROR{/if}</a>{/if}
              {/foreach}
            </span>
          {/if}
        </li>
      {/foreach}
    </ul>
  </div>
{/if}
