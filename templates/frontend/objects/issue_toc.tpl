{**
 * templates/frontend/objects/issue_toc.tpl
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2003-2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief View of an Issue which displays a full table of contents.
 *
 * @uses $issue Issue The issue
 * @uses $issueTitle string Title of the issue. May be empty
 * @uses $issueSeries string Vol/No/Year string for the issue
 * @uses $issueGalleys array Galleys for the entire issue
 * @uses $hasAccess bool Can this user access galleys for this context?
 * @uses $publishedSubmissions array Lists of articles published in this issue
 *   sorted by section.
 * @uses $primaryGenreIds array List of file genre ids for primary file types
 *}

{* Indicate if this is only a preview *}
{if !$issue->getPublished()}
	{include file="frontend/components/notification.tpl" type="warning" messageKey="editor.issues.preview"}
{/if}

{* Issue introduction area above articles *}
{if !$spupIssueIdentityShown}
	{include file="frontend/components/spup/issue/introduction.tpl" issue=$issue}
{/if}

{* Full-issue galleys *}
{if $issueGalleys}
	<section class="galleys">
		<h2 class="visually-hidden">
			{translate key="issue.tableOfContents"}
		</h2>
		<ul class="galleys_links">
			{foreach from=$issueGalleys item=galley}
				<li>
					{include file="frontend/objects/galley_link.tpl" parent=$issue purchaseFee=$currentJournal->getSetting('purchaseIssueFee') purchaseCurrency=$currentJournal->getSetting('currency')}
				</li>
			{/foreach}
		</ul>
	</section>
{/if}

{* Articles *}
{include file="frontend/components/spup/issue/sections.tpl" publishedSubmissions=$publishedSubmissions}

<a class="read_more btn btn-secondary" href="{url router=$smarty.const.ROUTE_PAGE page="issue" op="archive"}">
	{translate key="journal.viewAllIssues"}
</a>
