<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<svg xmlns="http://www.w3.org/2000/svg" class="d-none">
    <symbol id="house-door-fill" viewBox="0 0 16 16">
        <path d="M6.5 14.5v-3.505c0-.245.25-.495.5-.495h2c.25 0 .5.25.5.5v3.5a.5.5 0 0 0 .5.5h4a.5.5 0 0 0 .5-.5v-7a.5.5 0 0 0-.146-.354L13 5.793V2.5a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1.293L8.354 1.146a.5.5 0 0 0-.708 0l-6 6A.5.5 0 0 0 1.5 7.5v7a.5.5 0 0 0 .5.5h4a.5.5 0 0 0 .5-.5z"/>
    </symbol>
</svg>
<ol class="breadcrumb breadcrumb-chevron p-3 bg-body-tertiary rounded-3">
    <li class="breadcrumb-item">
        <a class="link-body-emphasis" href="/">
            <svg class="bi" width="16" height="16" aria-hidden="true">
                <use xlink:href="#house-door-fill"></use>
            </svg>
            <span class="visually-hidden">Home</span>
        </a>
    </li>
    <c:forEach var="item" items="${breadcrumbItems}" varStatus="status">
        <c:choose>
            <c:when test="${status.last}">
                <li class="breadcrumb-item active" aria-current="page">${item.name}</li>
            </c:when>
            <c:otherwise>
                <li class="breadcrumb-item">
                    <a class="link-body-emphasis fw-semibold text-decoration-none" href="${item.url}">
                            ${item.name}
                    </a>
                </li>
            </c:otherwise>
        </c:choose>
    </c:forEach>
</ol>
