/* OJS renders menu links without a current-page marker for root custom pages. */
(function () {
	const navigation = document.querySelector('.spup-header__nav-band #navigationPrimary');
	if (!navigation) return;

	const current = window.location.pathname.replace(/\/$/, '') || '/';
	let best = null;
	let bestLength = -1;
	for (const link of navigation.querySelectorAll('a[href]')) {
		const url = new URL(link.href, window.location.href);
		if (url.origin !== window.location.origin) continue;
		const path = url.pathname.replace(/\/$/, '') || '/';
		if (url.hash && url.hash !== window.location.hash) continue;
		const matches = current === path || (path !== '/' && current.startsWith(path + '/'));
		const score = path.length + (url.hash ? 1000 : 0);
		if (matches && score > bestLength) {
			best = link;
			bestLength = score;
		}
	}
	if (!best && document.body.dataset.spupCurrentIssue === 'true' && document.querySelector('main.page_issue')) {
		best = [...navigation.querySelectorAll('a[href]')].find(link => new URL(link.href).pathname.endsWith('/issue/current'));
	}
	if (!best && document.body.classList.contains('spup-journal')) {
		const headerHomeLink = document.querySelector('.spup-header__home-link');
		const homeUrl = headerHomeLink ? headerHomeLink.href : null;
		const homeLink = [...navigation.querySelectorAll('a[href]')].find(link => link.href === homeUrl);
		if (homeLink) {
			const homePath = new URL(homeLink.href).pathname.replace(/\/$/, '');
			const shortHomePath = homePath.replace(/\/index(?:\/index)?$/, '');
			if (current === homePath || current === shortHomePath) best = homeLink;
		}
	}
	if (!best && current === '/') best = navigation.querySelector('a[href$="/index/index"]');
	if (!best) return;
	best.setAttribute('aria-current', 'page');
	best.classList.add('active');
	const dropdown = best.closest('.dropdown');
	if (dropdown && dropdown.contains(best)) {
		const parent = dropdown.querySelector(':scope > .nav-link');
		if (parent && parent !== best) parent.classList.add('active');
	}
})();
