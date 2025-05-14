function showToast(message, isError = false) {
    const toastEl = document.getElementById("toastMessage");
    const toastText = document.getElementById("toastText");
    toastText.innerText = message;
    toastEl.classList.remove("text-bg-success", "text-bg-danger");
    toastEl.classList.add(isError ? "text-bg-danger" : "text-bg-success");
    new bootstrap.Toast(toastEl).show();
}