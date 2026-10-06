{**
 * Copyright (c) 2014-2025 Simon Fraser University
 * Copyright (c) 2003-2025 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see docs/COPYING.
 * The issue page's identity; publication content remains in the native TOC.
 *}
<p class="spup-issue__eyebrow">{if $issue->getId() == $currentContext->getData('currentIssueId')}{translate key="current.current"}{else}{translate key="issue.issue"}{/if}</p>
{include file="frontend/components/headings.tpl" currentTitle=$issueIdentificationString}
{assign var=spupIssueCoverUrl value=$issue->getLocalizedCoverImageUrl()}
<section class="spup-issue__identity{if !$spupIssueCoverUrl} spup-issue__identity--no-cover{/if}">
  {if $spupIssueCoverUrl}
    {include file="frontend/components/spup/layout/coverMedia.tpl"
      imageUrl=$spupIssueCoverUrl
      alt=$issue->getLocalizedCoverImageAltText()|default:$issue->getIssueIdentification()
      variant="issue"
      className="spup-issue__cover"
      showOffset=true
      loading="eager"
    }
  {/if}
  <div class="spup-issue__details">
    {if $issue->getDatePublished()}<p class="spup-issue__date">{translate key="submissions.published"} {$issue->getDatePublished()|date_format:$dateFormatLong}</p>{/if}
    {if $issue->hasDescription()}<div class="spup-issue__description">{$issue->getLocalizedDescription()|strip_unsafe_html}</div>{/if}
  </div>
</section>
