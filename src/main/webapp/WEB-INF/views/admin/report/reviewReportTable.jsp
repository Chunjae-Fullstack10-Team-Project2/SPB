<table class="table table-hover text-center align-middle">
    <thead class="table-light">
    <tr>
        <th>번호</th>
        <th>
            <a href="javascript:void(0);" onclick="applySort('lectureReviewContent')">
                내용
                <c:if test="${searchDTO.sortColumn eq 'lectureReviewContent'}">
                    ${searchDTO.sortOrder eq 'asc' ? '▲' : '▼'}
                </c:if>
            </a>
        </th>
        <th>
            <a href="javascript:void(0);" onclick="applySort('lectureReviewMemberId')">
                작성자
                <c:if test="${searchDTO.sortColumn eq 'lectureReviewMemberId'}">
                    ${searchDTO.sortOrder eq 'asc' ? '▲' : '▼'}
                </c:if>
            </a>
        </th>
        <th>
            <a href="javascript:void(0);" onclick="applySort('lectureReviewCreatedAt')">
                작성일
                <c:if test="${searchDTO.sortColumn eq 'lectureReviewCreatedAt'}">
                    ${searchDTO.sortOrder eq 'asc' ? '▲' : '▼'}
                </c:if>
            </a>
        </th>
    </tr>
    </thead>
    <tbody>
    <c:forEach items="${boardReportList}" var="orderDTO" varStatus="status">
        <tr>
            <td>${status.index + 1}</td>
            <td class="text-start">${orderDTO.lectureReviewContent}</td>
            <td>${orderDTO.lectureReviewMemberId}</td>
            <td>${orderDTO.lectureReviewCreatedAt.toLocalDate()}</td>
        </tr>
    </c:forEach>
    </tbody>
</table>