{**
 * templates/frontend/components/footer.tpl
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2003-2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Site-wide footer; designed to contain a sidebar hook
 *
 *}

<footer class="site-footer{if !$currentContext} site-footer--institutional{/if}">
	{if !$currentContext}
		{if $hasSidebar}
			<div class="spup-footer__utilities">
				<div class="spup-footer__container">
					<div class="sidebar_wrapper" role="complementary">
						{call_hook name="Templates::Common::Sidebar"}
					</div>
				</div>
			</div>
		{/if}
		<div class="spup-footer__main">
			<div class="spup-footer__container">
				<div class="spup-footer__grid">
					<div class="spup-footer__details">
						{if $spupFooterContactEmail}
							<section class="spup-footer__detail">
								<h3>{translate key="plugins.themes.spupLightExplorerTheme.footer.contact"}</h3>
								<a href="mailto:{$spupFooterContactEmail|escape}">{$spupFooterContactEmail|escape}</a>
							</section>
						{/if}
						<section class="spup-footer__detail">
							<h3>{translate key="plugins.themes.spupLightExplorerTheme.footer.location"}</h3>
							<p>{translate key="plugins.themes.spupLightExplorerTheme.footer.institution"}<br>{translate key="plugins.themes.spupLightExplorerTheme.footer.address"}</p>
						</section>
					</div>
					<div class="spup-footer__identity">
						{if $displayPageHeaderLogo}
							<img class="spup-footer__seal" src="{$sitePublicFilesDir}/{$displayPageHeaderLogo.uploadName|escape:"url"}" alt="" loading="lazy">
						{/if}
						<p class="spup-footer__eyebrow">{translate key="plugins.themes.spupLightExplorerTheme.footer.institution"}</p>
						<h2 class="spup-footer__institution">{$siteTitle|escape}</h2>
						<p class="spup-footer__site-title">{translate key="plugins.themes.spupLightExplorerTheme.footer.network"}</p>
					</div>
					<div class="spup-footer__navigation">
						<section class="spup-footer__menu-section">
							<h3 id="spupFooterExploreHeading">{translate key="plugins.themes.spupLightExplorerTheme.footer.explore"}</h3>
							<nav aria-labelledby="spupFooterExploreHeading">{load_menu name="footerExplore" id="spupFooterExplore" ulClass="spup-footer__menu"}</nav>
						</section>
						<section class="spup-footer__menu-section">
							<h3 id="spupFooterInformationHeading">{translate key="plugins.themes.spupLightExplorerTheme.footer.information"}</h3>
							<nav aria-labelledby="spupFooterInformationHeading">{load_menu name="footerInformation" id="spupFooterInformation" ulClass="spup-footer__menu"}</nav>
						</section>
					</div>
				</div>
				{if $pageFooter}
					<div class="spup-footer__admin-content user-page-footer">{$pageFooter}</div>
				{/if}
			</div>
		</div>
		<div class="spup-footer__bottom">
			<div class="spup-footer__container spup-footer__bottom-inner">
				<div class="spup-footer__credits">
					<p>&copy; {$smarty.now|date_format:"Y"} {translate key="plugins.themes.spupLightExplorerTheme.footer.institution"}</p>
					<p>{translate key="plugins.themes.spupLightExplorerTheme.footer.poweredBy"}</p>
				</div>
				<div class="spup-footer__platform">
					<span>{translate key="plugins.themes.spupLightExplorerTheme.footer.platform"}</span>
					<div class="pkpbrand-wrapper" role="complementary">
						<a href="{url page="about" op="aboutThisPublishingSystem"}">
							<img class="footer-brand-image" alt="{translate key="about.aboutThisPublishingSystem"}" src="{$baseUrl}/{$brandImage}">
						</a>
					</div>
				</div>
			</div>
		</div>
	{else}
		<div class="container-fluid container-footer">
			{if $hasSidebar}
				<div class="sidebar_wrapper" role="complementary">
					{call_hook name="Templates::Common::Sidebar"}
				</div>
			{/if}
			<div class="additional-footer-info">
				{if $pageFooter}
					<div class="user-page-footer">
						{$pageFooter}
					</div>
				{/if}
				<div class="pkpbrand-wrapper" role="complementary">
					<a href="{url page="about" op="aboutThisPublishingSystem"}">
						<img class="footer-brand-image" alt="{translate key="about.aboutThisPublishingSystem"}" src="{$baseUrl}/{$brandImage}">
					</a>
				</div>
			</div>
		</div>
	{/if}
</footer>

{load_script context="frontend"}

{call_hook name="Templates::Common::Footer::PageFooter"}

</body>
</html>
