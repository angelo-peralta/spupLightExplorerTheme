{if $issue || $authorLinks|@count || !$currentJournal->getData('disableSubmissions')}
<section class="spup-journal-band spup-journal-band--white" aria-label="{translate|escape key='journal.currentIssue'}">
  <div class="spup-journal-band__inner spup-site-container spup-journal-row{if !$issue} spup-journal-row--single{/if}">
    {if $issue}
      <section class="current_issue spup-journal-panel" aria-labelledby="spup-current-issue-heading">
        {include file="frontend/components/spup/content/sectionHeading.tpl" headingId="spup-current-issue-heading" eyebrowKey="plugins.themes.spupLightExplorerTheme.root.publishing" titleKey="journal.currentIssue"}
        {assign var=spupIssueCover value=$issue->getLocalizedCoverImageUrl()}
        <div class="spup-journal-issue{if !$spupIssueCover} spup-journal-issue--no-cover{/if}">
          {if $spupIssueCover}
            {capture assign=spupIssueUrl}{url page="issue" op="view" path=$issue->getBestIssueId() escape=false}{/capture}
            {capture assign=spupIssueAlt}{if $issue->getLocalizedCoverImageAltText()}{$issue->getLocalizedCoverImageAltText()}{else}{$issue->getIssueIdentification()}{/if}{/capture}
            {include file="frontend/components/spup/layout/coverMedia.tpl" imageUrl=$spupIssueCover alt=$spupIssueAlt linkUrl=$spupIssueUrl variant="issue" className="spup-journal-issue__cover" showOffset=true}
          {/if}
          <div class="spup-journal-issue__details">
            {if $issueIdentificationString}<h3>{$issueIdentificationString|escape}</h3>{/if}
            {if $issue->getDatePublished()}<p class="spup-journal-issue__date">{translate key="submissions.published"} <time datetime="{$issue->getDatePublished()|date_format:'Y-m-d'|escape}">{$issue->getDatePublished()|date_format:$dateFormatLong}</time></p>{/if}
            {if $issue->hasDescription()}<div class="spup-journal-issue__description">{$issue->getLocalizedDescription()|strip_unsafe_html}</div>{/if}
            <div class="spup-journal-issue__actions">
              <a class="spup-text-link" href="{url page="issue" op="view" path=$issue->getBestIssueId()}">{translate key="plugins.themes.spupLightExplorerTheme.journal.viewCurrentIssue"} <span aria-hidden="true">&rarr;</span></a>
              <a class="spup-text-link" href="{url page="issue" op="archive"}">{translate key="plugins.themes.spupLightExplorerTheme.journal.browseArchives"} <span aria-hidden="true">&rarr;</span></a>
            </div>
          </div>
        </div>
      </section>
    {/if}
    {if $authorLinks|@count || !$currentJournal->getData('disableSubmissions')}
      <aside class="spup-journal-shortcuts spup-journal-panel" aria-labelledby="spup-journal-authors-heading">
        {include file="frontend/components/spup/content/sectionHeading.tpl" headingId="spup-journal-authors-heading" eyebrowKey="plugins.themes.spupLightExplorerTheme.journal.resources" titleKey="plugins.themes.spupLightExplorerTheme.about.authors"}
        {include file="frontend/components/spup/content/resourceList.tpl" items=$authorLinks}
        {if !$currentJournal->getData('disableSubmissions')}<a class="spup-text-link spup-journal-submission" href="{url page="submission" op="wizard"}">{translate key="plugins.themes.spupLightExplorerTheme.journal.makeSubmission"} <span aria-hidden="true">&rarr;</span></a>{/if}
      </aside>
    {/if}
  </div>
</section>
{/if}
