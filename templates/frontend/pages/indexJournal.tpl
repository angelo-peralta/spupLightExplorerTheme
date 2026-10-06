{** Journal homepage orchestrator. Content and URLs come from the active OJS context. *}
{include file="frontend/components/header.tpl" pageTitleTranslated=$currentJournal->getLocalizedName() spupLandingPage=true}

{assign var=spupJournalName value=$currentJournal->getLocalizedName()}
{assign var=spupJournalInitials value=$currentJournal->getLocalizedAcronym()}
{assign var=spupJournalCover value=$currentJournal->getLocalizedData('journalThumbnail')}
{assign var=spupJournalIntro value=$activeTheme->getJournalHomepageIntro($currentJournal->getLocalizedDescription())}

<main class="page_index_journal">
  {include file="frontend/components/spup/journal/identity.tpl" spupJournalName=$spupJournalName spupJournalInitials=$spupJournalInitials spupJournalCover=$spupJournalCover spupJournalIntro=$spupJournalIntro showJournalSummary=$showJournalSummary}
  {include file="frontend/components/spup/journal/indexing.tpl" services=$spupJournalIndexingServices}

  <div class="spup-site-container">{call_hook name="Templates::Index::journal"}</div>

  {include file="frontend/components/spup/journal/issueAndAuthors.tpl" issue=$issue authorLinks=$spupJournalAuthorLinks issueIdentificationString=$issueIdentificationString}
  {include file="frontend/components/spup/journal/latestAndInfo.tpl" recentPublications=$spupJournalRecentPublications informationLinks=$spupJournalInformationLinks audienceLinks=$spupJournalAudienceLinks journalInitials=$spupJournalInitials hasSidebar=$hasSidebar}
  {include file="frontend/components/spup/journal/announcements.tpl" announcements=$announcements journalInitials=$spupJournalInitials}

  {if $additionalHomeContent}<div class="spup-journal-band spup-journal-band--white"><section class="spup-journal-band__inner spup-site-container additional_content">{$additionalHomeContent}</section></div>{/if}

  {include file="frontend/components/spup/journal/statistics.tpl" stats=$spupJournalStats journalInitials=$spupJournalInitials}
</main>

{include file="frontend/components/footer.tpl" spupSidebarInMain=true}
