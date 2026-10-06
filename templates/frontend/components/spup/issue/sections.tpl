{**
 * Copyright (c) 2014-2025 Simon Fraser University
 * Copyright (c) 2003-2025 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see docs/COPYING.
 * OJS supplies the published submissions grouped and ordered by section.
 *}
<section class="sections">
  <h2 class="visually-hidden">{translate key="issue.toc"}</h2>
  {foreach name=sections from=$publishedSubmissions item=section}
    <section class="section">
      {if $section.articles}
        {if $section.title}<h3 class="section_title">{$section.title|escape}</h3>{/if}
        <div class="section_content">
          {foreach from=$section.articles item=article}
            {include file="frontend/objects/article_summary.tpl" headingLevel="4"}
          {/foreach}
        </div>
      {/if}
    </section>
  {/foreach}
</section>
