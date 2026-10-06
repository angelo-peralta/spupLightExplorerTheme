/**
 * @file /js/main-theme.js
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2003-2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Custom javascript functionality for Traditional OJS 3 theme plugin
 */


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
