{if $citation}
	<div class="item citation">
		<div class="sub_item citation_display">
			<h2>
                {translate key="submission.howToCite"}
			</h2>
			<div class="citation_format_value">
				<div id="citationOutput" role="region" aria-live="polite">
                    {$citation}
				</div>
			</div>
		</div>
	</div>
{/if}
