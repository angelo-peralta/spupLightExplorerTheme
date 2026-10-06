{if !$spupDirectoryJournals|@count}
	<p class="spup-empty-state">{translate key="site.noJournals"}</p>
{else}
	<div class="spup-journal-directory">
		{foreach from=$spupDirectoryJournals item=journal}
			{assign var=thumb value=$journal->getLocalizedData('journalThumbnail')}
			{assign var=abbreviation value=$journal->getLocalizedData('abbreviation')}
			{assign var=summary value=$activeTheme->getJournalDescriptionPreview($journal->getLocalizedDescription())}
			{capture assign=journalUrl}{url journal=$journal->getPath()}{/capture}
			<article class="spup-journal-directory__item" style="--spup-journal-accent: {$spupJournalAccentColors[$journal->getId()]|escape};">
				{if $thumb}
					{include file="frontend/components/spup/layout/coverMedia.tpl" imageUrl="{$journalFilesPath}{$journal->getId()}/{$thumb.uploadName|escape:'url'}" alt=$journal->getLocalizedName() linkUrl=$journalUrl variant="journal-directory" showOffset=true className="spup-journal-directory__cover"}
				{else}
					<a class="spup-journal-directory__cover" href="{$journalUrl|escape}" aria-label="{$journal->getLocalizedName()|escape}">
						<span class="spup-journal-directory__cover-fallback" aria-hidden="true">{if $abbreviation}{$abbreviation|escape}{else}{$journal->getPath()|upper|escape}{/if}</span>
					</a>
				{/if}
				<div class="spup-journal-directory__details">
					<p class="spup-journal-directory__initials">{if $abbreviation}{$abbreviation|escape}{else}{$journal->getPath()|upper|escape}{/if}</p>
					<h2><a href="{$journalUrl|escape}">{$journal->getLocalizedName()|escape}</a></h2>
					{if $summary}<p class="spup-journal-directory__summary">{$summary|escape}</p>{/if}
					<div class="spup-journal-directory__actions">
						<a class="spup-journal-directory__button spup-journal-directory__button--primary" href="{$journalUrl|escape}">{translate key="plugins.themes.spupLightExplorerTheme.directory.viewJournal"}</a>
						<a class="spup-journal-directory__button" href="{url journal=$journal->getPath() page="issue" op="current"}">{translate key="journal.currentIssue"}</a>
					</div>
				</div>
			</article>
		{/foreach}
	</div>
{/if}
