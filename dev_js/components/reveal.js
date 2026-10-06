/* Reveal root content after the observer is ready; without JS everything stays visible. */
(function () {
	const root = document.body;
	if (!(root.classList.contains('spup-root') || root.classList.contains('spup-journal')) || !('IntersectionObserver' in window) || window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;

	const selector = root.classList.contains('spup-journal') ? [
		'.page_index_journal .spup-journal-indexing .spup-journal-band__inner',
		'.page_index_journal .spup-journal-row > .spup-journal-panel',
		'.page_index_journal .spup-journal-row > .spup-journal-information-column',
		'.page_index_journal .spup-journal-announcements',
		'.page_index_journal .spup-journal-statistics',
		'.page_index_journal .additional_content',
		'.page_index_journal .spup-journal-layout__sidebar .pkp_block',
		'.page_issue .current_page_title',
		'.page_issue .description_cover',
		'.page_issue .section',
		'.page_issue_archive .current_page_title',
		'.page_issue_archive .issue_item',
		'.page_article .spup-article__header',
		'.page_about .current_page_title',
		'.page_about .journal-section',
		'.navigation-item-content .page_title',
		'.navigation-item-content .journal-section',
		'.page_submissions .current_page_title',
		'.page_submissions .submission-item-block',
		'.page_announcements .cmp_announcement',
		'.page_search .spup-search-result',
	].join(', ') : [
		'.page_index_site .index-site-journals > .spup-section-eyebrow',
		'.page_index_site .index-site-journals > h2',
		'.page_index_site .index-site-journals > .spup-section-rule',
		'.page_index_site .spup-journal-cover',
		'.page_index_site .spup-latest > .spup-section-eyebrow',
		'.page_index_site .spup-latest > h2',
		'.page_index_site .spup-latest > .spup-section-rule',
		'.page_index_site .spup-latest__columns > *',
		'.page_publisher_about .spup-about__hero',
		'.page_publisher_about .spup-about__section',
		'.page_publisher_contact .spup-contact__intro',
		'.page_publisher_contact .spup-contact__details > section',
		'.page_publisher_contact .spup-contact__location',
		'.page_publisher_contact .spup-contact__links',
		'.page_search .cmp_form',
		'.page_search .spup-search-result',
		'.page_announcements .cmp_announcement',
		'.page_announcement .announcement-full-description',
		'.page_journals .spup-journal-directory__item',
		'.navigation-item-content .spup-publisher-submission > *',
		'.navigation-item-content:not(.page_publisher_about):not(.page_publisher_contact):not(.page_journals) .container-page > :not(.spup-root-breadcrumbs):not(.spup-publisher-submission)',
		'.page_error .container-page > *',
		'.page_message .container-page > *',
	].join(', ');
	const elements = Array.from(document.querySelectorAll(selector));
	if (!elements.length) return;

	let observer;
	try {
		observer = new IntersectionObserver((entries) => {
			for (const entry of entries) {
				if (!entry.isIntersecting) continue;
				entry.target.classList.remove('is-pending');
				entry.target.classList.add('is-visible');
				observer.unobserve(entry.target);
			}
		}, { rootMargin: '0px 0px -40px 0px', threshold: 0.1 });
		for (const element of elements) {
			element.classList.add('spup-scroll-reveal', 'is-pending');
			observer.observe(element);
		}
		root.classList.add('spup-motion-ready');
	} catch (error) {
		if (observer) observer.disconnect();
		root.classList.remove('spup-motion-ready');
		for (const element of elements) element.classList.remove('is-pending');
	}
})();
