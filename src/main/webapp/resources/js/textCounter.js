document.addEventListener("DOMContentLoaded", function () {
  document.querySelectorAll("textarea.char-limit, input[type='text'].char-limit, input[type='password'].char-limit").forEach(function (el) {
    const maxLength = parseInt(el.dataset.maxlength || "1000", 10);
    const counterSelector = el.dataset.target;
    const counterEl = counterSelector ? document.querySelector(counterSelector) : null;

    el.addEventListener("input", function () {
      let text = el.value;
      if (text.length > maxLength) {
        el.value = text.substring(0, maxLength);
      }
      if (counterEl) {
        counterEl.textContent = el.value.length;
      }
    });
  });
});
