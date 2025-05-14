function bindCharCount(inputEl, countEl, wrapperEl, maxLengthInput) {
    if (!inputEl || !countEl || !wrapperEl) return;

    const maxLength = inputEl.hasAttribute('maxlength') ? inputEl.maxLength : maxLengthInput;

    function updateCharCount() {
        const length = inputEl.value.length;
        countEl.textContent = length;

        if (length > maxLength) {
            wrapperEl.classList.add('text-danger');
        } else {
            wrapperEl.classList.remove('text-danger');
        }
    }

    inputEl.addEventListener('input', updateCharCount);
    document.addEventListener('DOMContentLoaded', updateCharCount);
}