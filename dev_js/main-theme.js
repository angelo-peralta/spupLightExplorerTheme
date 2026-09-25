/**
 * @file /js/main-theme.js
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2003-2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Custom javascript functionality for Traditional OJS 3 theme plugin
 */


/* Keep OJS's single set of menu links available in an inline mobile panel. */
(function () {
	const header = document.querySelector('.spup-header');
	const toggle = document.getElementById('spup-menu-toggle');
	if (!header || !toggle) {
		return;
	}
	const menuRoot = toggle.closest('.spup-header');

	function setOpen(open) {
		menuRoot.classList.toggle('is-open', open);
		toggle.setAttribute('aria-expanded', String(open));
	}

	menuRoot.classList.add('spup-header--enhanced');
	toggle.hidden = false;
	toggle.addEventListener('click', function () {
		setOpen(!menuRoot.classList.contains('is-open'));
	});

	menuRoot.addEventListener('keydown', function (event) {
		if (event.key === ' ' && event.target.matches('.dropdown-toggle[role="button"]')) {
			event.preventDefault();
			event.target.click();
			return;
		}

		if (event.key === 'Escape' && menuRoot.classList.contains('is-open') && !menuRoot.querySelector('.dropdown-menu.show')) {
			setOpen(false);
			toggle.focus();
		}
	});

	document.addEventListener('click', function (event) {
		if (menuRoot.classList.contains('is-open') && !menuRoot.contains(event.target)) {
			setOpen(false);
		}
	});

	const desktopQuery = window.matchMedia('(min-width: 992px)');
	function closeAtDesktop(event) {
		if (event.matches) {
			setOpen(false);
		}
	}
	if (desktopQuery.addEventListener) {
		desktopQuery.addEventListener('change', closeAtDesktop);
	} else if (desktopQuery.addListener) {
		desktopQuery.addListener(closeAtDesktop);
	}
})();

/* Reveal publisher sections when they enter view, while keeping no-JS content visible. */
(function () {
	if (!('IntersectionObserver' in window) || window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;

	const selector = [
		'.page_index_site .index-site-journals > .spup-section-eyebrow',
		'.page_index_site .index-site-journals > h2',
		'.page_index_site .index-site-journals > .spup-section-rule',
		'.page_index_site .spup-journal-cover',
		'.page_index_site .spup-latest > .spup-section-eyebrow',
		'.page_index_site .spup-latest > h2',
		'.page_index_site .spup-latest > .spup-section-rule',
		'.page_index_site .spup-latest__columns h3',
		'.page_index_site .spup-editorial-list li',
		'.spup-root .page_journals .spup-journal-directory__item',
	].join(', ');
	const elements = document.querySelectorAll(selector);
	if (!elements.length) return;

	const observer = new IntersectionObserver((entries) => {
		for (const entry of entries) {
			if (!entry.isIntersecting) continue;
			entry.target.classList.remove('is-pending');
			entry.target.classList.add('is-visible');
			observer.unobserve(entry.target);
		}
	}, { rootMargin: '0px 0px -8% 0px', threshold: 0.08 });

	for (const element of elements) {
		if (element.getBoundingClientRect().top < window.innerHeight * .9) continue;
		const siblings = Array.from(element.parentElement.children);
		const delay = Math.min(siblings.indexOf(element) % 4, 3) * 45;
		element.style.setProperty('--spup-reveal-delay', `${delay}ms`);
		element.classList.add('spup-scroll-reveal', 'is-pending');
		observer.observe(element);
	}
})();

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

(function() {
	if (!document.querySelector('main.page_register')) {
		return;
	}

	const checkboxReviewerInterests = document.getElementById('checkbox-reviewer-interests');
	if (!checkboxReviewerInterests) {
		return;
	}

	/**
	 * Reveal the reviewer interests field on the registration form when a
	 * user has opted to register as a reviewer
	 *
	 * @see: /templates/frontend/pages/userRegister.tpl
	 */
	function reviewerInterestsToggle() {
		if (checkboxReviewerInterests.checked) {
			document.getElementById('reviewerInterests').classList.remove('hidden');
		} else {
			document.getElementById('reviewerInterests').classList.add('hidden');
		}
	}

	// Update interests on page load and when the toggled is toggled
	reviewerInterestsToggle();
	document.querySelector('#reviewerOptinGroup input').addEventListener('click', reviewerInterestsToggle);
})();

// more keywords functionality
(function () {
	if (!document.querySelector('main.page_article')) {
		return;
	}

	const moreKeywords = document.getElementById('more_keywords');
	if (!moreKeywords) {
		return;
	}
	moreKeywords.addEventListener('click', function () {
		document.querySelectorAll('.keyword_item').forEach((item) => {
			item.classList.remove('more-than-five');
		});
		this.classList.add('hide');
		document.getElementById('keywords-ellipsis').classList.add('hide');
		document.getElementById('less_keywords').classList.remove('hide');
		document.querySelector('.fifth-keyword-delimeter').classList.remove('hide');
	});

	document.getElementById('less_keywords').addEventListener('click', function () {
		document.querySelectorAll('.keyword_item').forEach((item, number) => {
			if (number > 4) {
				item.classList.add('more-than-five');
			}
		});
		this.classList.add('hide');
		document.getElementById('keywords-ellipsis').classList.remove('hide');
		document.getElementById('more_keywords').classList.remove('hide');
		document.querySelector('.fifth-keyword-delimeter').classList.add('hide');
	});
})();

// more authors data functionality
(function () {
	if (!document.querySelector('main.page_article')) {
		return;
	}

	const authorInfoCollapsible = document.getElementById('authorInfoCollapse');
	if (!authorInfoCollapsible) {
		return;
	}
	const moreSymbol = document.getElementById('more-authors-data-symbol');
	const lessSymbol = document.getElementById('less-authors-data-symbol');

	authorInfoCollapsible.addEventListener('shown.bs.collapse', event => {
		moreSymbol.classList.add('hide');
		lessSymbol.classList.remove('hide');
	});

	authorInfoCollapsible.addEventListener('hidden.bs.collapse', event => {
		moreSymbol.classList.remove('hide');
		lessSymbol.classList.add('hide');
	});
})();

// change article's blocks logic for small screens
(function () {
	if (!document.querySelector('main.page_article')) {
		return;
	}

	const articleMainData = document.getElementById('articleMainData');
	const mainEntry = document.getElementById('mainEntry');
	let mainEntryChildren = mainEntry.children;
	const articleAbstractBlock = document.getElementById('articleAbstractBlock');
	let articleAbstractBlockChildren = articleAbstractBlock.children;
	const dataForMobilesMark = 'data-for-mobiles';

	// article's blocks in one column for mobiles and two for big screens
	function reorganizeArticleBlocks() {
		if (articleMainData !== null && !articleMainData.classList.contains(dataForMobilesMark) && window.innerWidth < 768) {
			let childrenClone = [].concat(...mainEntryChildren);
			mainEntry.replaceWith(...mainEntryChildren);
			mainEntryChildren = childrenClone;

			childrenClone = [].concat(...articleAbstractBlockChildren);
			articleAbstractBlock.replaceWith(...articleAbstractBlockChildren);
			articleAbstractBlockChildren = childrenClone;

			articleMainData.classList.add(dataForMobilesMark);
		} else if (articleMainData !== null && articleMainData.classList.contains(dataForMobilesMark) && window.innerWidth >= 768) {
			while (articleMainData.lastElementChild) {
				articleMainData.removeChild(articleMainData.lastElementChild);
			}
			articleMainData.appendChild(mainEntry);
			mainEntry.append(...mainEntryChildren);
			articleMainData.appendChild(articleAbstractBlock);
			articleAbstractBlock.append(...articleAbstractBlockChildren);
			articleMainData.classList.remove(dataForMobilesMark);
		}
	}

	reorganizeArticleBlocks();

	window.addEventListener("resize", function () {
		reorganizeArticleBlocks();
	});
})();

(function () {
	if (!document.querySelector('main.page_article')) {
		return;
	}

	const authorsToLimit = document.querySelectorAll('.limit-for-mobiles');
	const showAllAuthors = document.getElementById('show-all-authors');
	if (!authorsToLimit || !showAllAuthors) {
		return;
	}
	showAllAuthors.addEventListener('click', function () {
		authorsToLimit.forEach((item) => {
			item.classList.remove('limit-for-mobiles');
		});
		this.classList.add('hide');
		document.getElementById('hide-authors').classList.remove('hide');
		document.querySelector('.fifth-author .author-delimiter').classList.add('show');
	});

	document.getElementById('hide-authors').addEventListener('click', function () {
		authorsToLimit.forEach((item) => {
			item.classList.add('limit-for-mobiles');
		});
		this.classList.add('hide');
		document.getElementById('show-all-authors').classList.remove('hide');
		document.querySelector('.fifth-author .author-delimiter').classList.remove('show');
	});
})();

(function () {
	const contextOptinGroup = document.getElementById('contextOptinGroup');
	if (!contextOptinGroup) {
		return;
	}

	const privacyVisible = 'context_privacy_visible';

	document.querySelectorAll('.context').forEach((context) => {
		const roleInputs = context.querySelectorAll(':scope .roles input[type=checkbox]');
		roleInputs.forEach((roleInput) => {
			roleInput.addEventListener('change', function () {
				const contextPrivacy = context.querySelector(':scope .context_privacy');
				if (!contextPrivacy) {
					return;
				}

				if (this.checked) {
					if (!contextPrivacy.classList.contains(privacyVisible)) {
						contextPrivacy.classList.add(privacyVisible);
						return;
					}
				}

				for (let i = 0; i < roleInputs.length; i++) {
					const sibling = roleInputs[i];
					if (sibling === roleInput) {
						continue;
					}
					if (sibling.checked) {
						return;
					}
				}

				contextPrivacy.classList.remove(privacyVisible);
			});
		});
	});
})();
