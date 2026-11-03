// The native shell inserts this notice after page initialization.
// Preserve its original dismiss handler and keep the full recovery details.
function enhanceSourceNotice() {
 const notice = document.getElementById('xar-source-review');
 if (!notice) return false;
 if (notice.dataset.enhanced) return true;
 const dismiss = notice.querySelector('button');
 if (!dismiss) return false;
 const originalText = [...notice.childNodes]
  .filter(node => node !== dismiss)
  .map(node => node.textContent).join('').trim();
 const content = document.createElement('div');
 content.className = 'xar-notice-content';
 const title = document.createElement('strong');
 title.className = 'xar-notice-title';
 title.textContent = 'A fresh look. Everything kept.';
 const description = document.createElement('p');
 description.className = 'xar-notice-description';
 description.textContent = 'Your previous source and repairs are safely saved.';
 const details = document.createElement('details');
 details.className = 'xar-notice-details';
 const summary = document.createElement('summary');
 summary.textContent = 'View recovery details';
 const recovery = document.createElement('p');
 recovery.textContent = originalText;
 details.append(summary, recovery);
 const actions = document.createElement('div');
 actions.className = 'xar-notice-actions';
 const help = document.createElement('button');
 help.type = 'button';
 help.className = 'xar-notice-help';
 help.textContent = 'Open Auto Help';
 help.addEventListener('click', () => {
  const entry = document.querySelector('.auto-help-entry');
  if (entry && !entry.disabled) entry.click();
 });
 const label = document.createElement('span');
 label.className = 'xar-notice-label';
 label.textContent = 'WORKSPACE UPDATE';
 actions.append(help, label);
 content.append(title, description, details, actions);
 const badge = document.createElement('span');
 badge.className = 'xar-notice-badge';
 badge.setAttribute('aria-hidden', 'true');
 badge.textContent = '✓';
 dismiss.type = 'button';
 dismiss.classList.add('xar-notice-dismiss');
 dismiss.setAttribute('aria-label', 'Dismiss update notification');
 dismiss.textContent = '×';
 notice.dataset.enhanced = 'true';
 notice.setAttribute('aria-live', 'polite');
 notice.replaceChildren(badge, content, dismiss);
 return true;
}

if (!enhanceSourceNotice()) {
 const observer = new MutationObserver(() => {
  if (enhanceSourceNotice()) observer.disconnect();
 });
 observer.observe(document.body, {childList: true, subtree: true});
 window.addEventListener('pagehide', () => observer.disconnect(), {once: true});
}
