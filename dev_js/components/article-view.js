/* Keep long article titles readable within a bounded header, and position author cards in view. */
(function () {
	function initArticleView() {
		const title = document.querySelector('main.page_article h1.article-full-title');
		if (!title) return;

		const titleText = title.querySelector('.spup-article__title-text');
		const titleToggle = document.querySelector('.spup-article__title-toggle');
		const showFullTitleLabel = titleToggle && titleToggle.dataset.showFullTitleLabel || 'Show full title';
		const showLessTitleLabel = titleToggle && titleToggle.dataset.showLessTitleLabel || 'Show less';
		let frame;
		function fitTitle() {
			if (!titleText) return;
			const wasExpanded = title.classList.contains('spup-article__title--expanded');
			title.classList.remove('spup-article__title--fitted', 'spup-article__title--clamped', 'spup-article__title--expanded');
			title.style.removeProperty('--spup-article-title-size');

			const mobile = window.matchMedia('(max-width: 767px)').matches;
			const titleStyle = window.getComputedStyle(title);
			const configuredMinimum = parseFloat(titleStyle.getPropertyValue('--journal-article-title-min'));
			const minimum = Number.isFinite(configuredMinimum) ? configuredMinimum : (mobile ? 26 : 30);
			const maxLines = mobile ? 5 : 4;
			const baseSize = parseFloat(titleStyle.fontSize);
			const length = Array.from(titleText.textContent.trim()).length;
			let size = Math.max(minimum, baseSize - Math.min(4, Math.max(0, (length - 65) / 22)));

			while (size >= minimum) {
				title.style.setProperty('--spup-article-title-size', `${size}px`);
				const lineHeight = parseFloat(window.getComputedStyle(title).lineHeight);
				if (titleText.getBoundingClientRect().height <= lineHeight * maxLines + 1) {
					title.classList.add('spup-article__title--fitted');
					if (titleToggle) titleToggle.hidden = true;
					return;
				}
				size -= 0.5;
			}

			// Keep the whole scholarly title available through a disclosure at the size floor.
			title.style.setProperty('--spup-article-title-size', `${minimum}px`);
			title.classList.add('spup-article__title--clamped');
			if (titleToggle) {
				titleToggle.hidden = false;
				title.classList.toggle('spup-article__title--expanded', wasExpanded);
				titleToggle.textContent = wasExpanded ? showLessTitleLabel : showFullTitleLabel;
				titleToggle.setAttribute('aria-expanded', String(wasExpanded));
			}
		}

		function scheduleFit() {
			window.cancelAnimationFrame(frame);
			frame = window.requestAnimationFrame(fitTitle);
		}
		scheduleFit();
		window.addEventListener('resize', scheduleFit);
		if (document.fonts && document.fonts.ready) document.fonts.ready.then(scheduleFit);
		if (titleToggle) {
			titleToggle.addEventListener('click', () => {
				const expanded = !title.classList.contains('spup-article__title--expanded');
				title.classList.toggle('spup-article__title--expanded', expanded);
				titleToggle.textContent = expanded ? showLessTitleLabel : showFullTitleLabel;
				titleToggle.setAttribute('aria-expanded', String(expanded));
			});
		}

		const authorCards = document.querySelectorAll('.spup-article__author-card');
		function positionPopover(card) {
			const popover = card.querySelector('.spup-article__author-popover');
			if (!popover || window.getComputedStyle(popover).display === 'none') return;
			const margin = 18;
			const cardLeft = card.getBoundingClientRect().left;
			const popoverWidth = popover.getBoundingClientRect().width;
			const left = Math.min(Math.max(cardLeft, margin), document.documentElement.clientWidth - popoverWidth - margin);
			popover.style.left = `${Math.round(left - cardLeft)}px`;
		}
		authorCards.forEach(card => {
			card.addEventListener('pointerenter', () => window.requestAnimationFrame(() => positionPopover(card)));
			card.addEventListener('focusin', () => window.requestAnimationFrame(() => positionPopover(card)));
		});
		document.addEventListener('pointerdown', event => {
			const activeElement = document.activeElement;
			if (!event.target.closest('.spup-article__author-card') && activeElement && activeElement.closest && activeElement.closest('.spup-article__author-card')) {
				activeElement.blur();
			}
		});
		document.addEventListener('keydown', event => {
			const activeElement = document.activeElement;
			if (event.key === 'Escape' && activeElement && activeElement.closest && activeElement.closest('.spup-article__author-card')) {
				activeElement.blur();
			}
		});
	}

	if (document.readyState === 'loading') {
		document.addEventListener('DOMContentLoaded', initArticleView, { once: true });
	} else {
		initArticleView();
	}
})();
