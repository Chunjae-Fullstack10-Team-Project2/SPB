/**
 * 현재 URL의 쿼리 파라미터를 유지하며 이동할 URL을 생성하고 이동함
 * @param {string} baseUrl - 이동할 URL (예: "/board/view?idx=1")
 */
function navigateWithCurrentParams(baseUrl) {
    const searchParams = window.location.search;
    if (!searchParams || searchParams === '?') {
        window.location.href = baseUrl;
        return;
    }
    const fullUrl = baseUrl.includes('?')
        ? baseUrl + '&' + searchParams.substring(1)
        : baseUrl + searchParams;
    window.location.href = fullUrl;
}
