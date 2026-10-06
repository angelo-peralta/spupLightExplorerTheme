{**
 * Copyright (c) 2014-2025 Simon Fraser University
 * Copyright (c) 2003-2025 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see docs/COPYING.
 * Issue description and cover when the TOC is shown outside the issue page.
 *}
{if $issue->hasDescription() || $issue->getLocalizedCoverImageUrl()}
  <section class="flex_container description_cover">
    {if $issue->hasDescription()}
      <div class="description">
        <h3 class="description_label">{translate key="plugins.themes.spupLightExplorerTheme.issueDescription"}</h3>
        {assign var=issueDescription value=$issue->getLocalizedDescription()|strip_unsafe_html}
        <div class="description_text">
          {if $issueDescription|strlen < 800 || $requestedPage|escape === "issue"}
            {$issueDescription}
          {else}
            {$issueDescription|substr:0:800|mb_convert_encoding:'UTF-8'|replace:'?':''}<span class="three_dots">...</span>
            <a class="more_button" href="{url op="view" page="issue" path=$issue->getBestIssueId()}">{translate key="plugins.themes.spupLightExplorerTheme.more"}</a>
          {/if}
        </div>
      </div>
    {/if}
    {assign var=issueCover value=$issue->getLocalizedCoverImageUrl()}
    {if $issueCover}
      {capture assign=spupIssueViewUrl}{url op="view" page="issue" path=$issue->getBestIssueId() escape=false}{/capture}
      <div class="issue_cover_block{if !$issue->hasDescription()} align-left{/if}">
        {include file="frontend/components/spup/layout/coverMedia.tpl"
          imageUrl=$issueCover
          alt=$issue->getLocalizedCoverImageAltText()|default:$issue->getIssueIdentification()
          linkUrl=$spupIssueViewUrl
          variant="issue-toc"
          imageClass="cover_image"
          showOffset=true
        }
      </div>
    {/if}
  </section>
{/if}
