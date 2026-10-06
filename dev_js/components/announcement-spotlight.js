/* One context-aware announcement dialog. OJS supplies its context and URLs. */
(function () {
  function startLandingMotion() {
    const root = document.body;
    if (!root.classList.contains('spup-landing-motion-held')) return;
    root.classList.remove('spup-landing-motion-held');
  }

  function init() {
    const overlay = document.querySelector('[data-spup-spotlight]');
    if (!overlay) { startLandingMotion(); return; }

    const contextKey = overlay.dataset.contextKey;
    const dialog = overlay.querySelector('[role="dialog"]');
    const body = overlay.querySelector('[data-spotlight-body]');
    const counter = overlay.querySelector('[data-spotlight-counter]');
    const previous = overlay.querySelector('[data-spotlight-previous]');
    const next = overlay.querySelector('[data-spotlight-next]');
    const close = overlay.querySelector('[data-spotlight-close]');
    const stories = [...overlay.querySelectorAll('[data-spotlight-story]')];
    const cookieName = 'spupAnnouncementSeenIds_' + contextKey;
    const reducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)');
    let current = 0;
    let visible = [];
    let priorFocus = null;
    let priorOverflow = '';
    let switching = false;

    function keyFor(id) {
      return 'spupAnnouncementSeen_' + contextKey + '_' + id;
    }

    function isSeen(id) {
      try { return window.localStorage.getItem(keyFor(id)) === 'true'; }
      catch (error) { return false; }
    }

    function cookieIds() {
      try {
        const entry = document.cookie.split(';').map(part => part.trim()).find(part => part.startsWith(cookieName + '='));
        return entry ? decodeURIComponent(entry.slice(cookieName.length + 1)).split(',').filter(id => /^[1-9][0-9]{0,9}$/.test(id)) : [];
      } catch (error) { return []; }
    }

    function mirrorSeenId(id) {
      try {
        const ids = [...new Set([...cookieIds(), String(id)])];
        while (encodeURIComponent(ids.join(',')).length > 3000) ids.shift();
        document.cookie = cookieName + '=' + encodeURIComponent(ids.join(',')) + '; Path=/; Max-Age=31536000; SameSite=Lax';
      } catch (error) { /* localStorage remains the source of seen state. */ }
    }

    function markCurrentSeen() {
      const story = visible[current];
      if (!story) return;
      const id = story.dataset.announcementId;
      try { window.localStorage.setItem(keyFor(id), 'true'); }
      catch (error) { /* Storage may be blocked in private browsing. */ }
      mirrorSeenId(id);
    }

    const alreadySeen = stories.filter(story => isSeen(story.dataset.announcementId));
    alreadySeen.forEach(story => mirrorSeenId(story.dataset.announcementId));
    visible = stories.filter(story => !isSeen(story.dataset.announcementId)).slice(0, 3);

    // A cleared cookie can leave only locally seen records in the first query.
    // Synchronize once, then let the server select the next three unseen IDs.
    if (!visible.length && alreadySeen.length) {
      try {
        const syncKey = 'spupSpotlightResynced_' + contextKey;
        if (window.sessionStorage.getItem(syncKey) !== 'true') {
          window.sessionStorage.setItem(syncKey, 'true');
          window.location.reload();
        }
      } catch (error) { /* Leave the page usable if sessionStorage fails. */ }
      return;
    }
    if (!visible.length) { startLandingMotion(); return; }

    function render() {
      const active = visible[current];
      stories.forEach(story => { story.hidden = story !== active; });
      const title = active.querySelector('.spup-announcement-spotlight__title');
      const excerpt = active.querySelector('.spup-announcement-spotlight__excerpt');
      dialog.setAttribute('aria-labelledby', title.id);
      if (excerpt) dialog.setAttribute('aria-describedby', excerpt.id);
      else dialog.removeAttribute('aria-describedby');
      overlay.classList.toggle('is-with-image', !!active.querySelector('.spup-announcement-spotlight__media'));
      const multiple = visible.length > 1;
      counter.hidden = previous.hidden = next.hidden = !multiple;
      if (multiple) {
        counter.textContent = (current + 1) + ' ' + counter.dataset.ofLabel + ' ' + visible.length;
        previous.disabled = current === 0;
        next.disabled = current === visible.length - 1;
        if ((document.activeElement === previous && previous.disabled)
          || (document.activeElement === next && next.disabled)) close.focus();
      }
      body.scrollTop = 0;
    }

    function restoreFocus() {
      if (priorFocus && priorFocus !== document.body && priorFocus.isConnected) {
        priorFocus.focus({ preventScroll: true });
        return;
      }
      const target = document.querySelector('main h1') || document.querySelector('.spup-header__home-link');
      if (!target) return;
      const hadTabindex = target.hasAttribute('tabindex');
      if (!hadTabindex) target.setAttribute('tabindex', '-1');
      target.focus({ preventScroll: true });
      if (!hadTabindex) target.addEventListener('blur', () => target.removeAttribute('tabindex'), { once: true });
    }

    function dismiss() {
      if (overlay.hidden) return;
      markCurrentSeen();
      overlay.hidden = true;
      overlay.classList.remove('is-open');
      document.body.style.overflow = priorOverflow;
      startLandingMotion();
      restoreFocus();
    }

    function navigate(step) {
      const target = current + step;
      if (switching || target < 0 || target >= visible.length) return;
      markCurrentSeen();
      if (reducedMotion.matches) {
        current = target;
        render();
        return;
      }
      switching = true;
      body.classList.add('is-switching');
      window.setTimeout(() => {
        if (!overlay.hidden) {
          current = target;
          render();
          body.classList.remove('is-switching');
        }
        switching = false;
      }, 140);
    }

    function focusableControls() {
      return [...dialog.querySelectorAll('a[href], button:not([disabled]), [tabindex]:not([tabindex="-1"])')]
        .filter(element => !element.hidden && element.getClientRects().length);
    }

    overlay.addEventListener('keydown', event => {
      if (event.key === 'Escape') {
        event.preventDefault();
        dismiss();
      } else if (event.key === 'Tab') {
        const controls = focusableControls();
        if (!controls.length) { event.preventDefault(); dialog.focus(); return; }
        const first = controls[0];
        const last = controls[controls.length - 1];
        if (event.shiftKey && (document.activeElement === first || document.activeElement === dialog)) {
          event.preventDefault(); last.focus();
        } else if (!event.shiftKey && document.activeElement === last) {
          event.preventDefault(); first.focus();
        }
      }
    });
    overlay.addEventListener('click', event => { if (event.target === overlay) dismiss(); });
    document.addEventListener('focusin', event => {
      if (!overlay.hidden && !dialog.contains(event.target)) close.focus();
    });
    close.addEventListener('click', dismiss);
    previous.addEventListener('click', () => navigate(-1));
    next.addEventListener('click', () => navigate(1));
    overlay.querySelectorAll('[data-spotlight-read], [data-spotlight-view-all]').forEach(link => {
      link.addEventListener('click', markCurrentSeen);
    });

    priorFocus = document.activeElement;
    priorOverflow = document.body.style.overflow;
    render();
    overlay.hidden = false;
    document.body.style.overflow = 'hidden';
    window.requestAnimationFrame(() => overlay.classList.add('is-open'));
    close.focus({ preventScroll: true });
  }

  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', init, { once: true });
  else init();
})();
