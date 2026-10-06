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
