{**
 * Copyright (c) 2014-2025 Simon Fraser University
 * Copyright (c) 2003-2025 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see docs/COPYING.
 * Year-grouped archive list using the native issue summary object.
 *}
<div class="flex_container issues_list">
  {assign var=archiveYear value=''}
  {foreach from=$issues item=issue}
    {assign var=issueYear value=$issue->getDatePublished()|date_format:'Y'}
    {if $issueYear && $issueYear != $archiveYear}
      <h2 class="spup-archive__year">{$issueYear|escape}</h2>
      {assign var=archiveYear value=$issueYear}
    {/if}
    <div class="issue_item">
      {include file="frontend/objects/issue_summary.tpl" issue=$issue}
    </div>
  {/foreach}
</div>
