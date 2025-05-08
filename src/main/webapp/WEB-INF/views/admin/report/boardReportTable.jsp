<table class="table table-hover text-center align-middle">
    <thead class="table-light">
    <tr>
        <th>번호</th>
        <th>
            <a href="javascript:void(0);" onclick="applySort('postTitle')">
                제목
                <c:if test="${searchDTO.sortColumn eq 'postTitle'}">
                    ${searchDTO.sortOrder eq 'asc' ? '▲' : '▼'}
                </c:if>
            </a>
        </th>
        <th>
            <a href="javascript:void(0);" onclick="applySort('postMemberId')">
                작성자
                <c:if test="${searchDTO.sortColumn eq 'postMemberId'}">
                    ${searchDTO.sortOrder eq 'asc' ? '▲' : '▼'}
                </c:if>
            </a>
        </th>
        <th>
            <a href="javascript:void(0);" onclick="applySort('postCreatedAt')">
                작성일
                <c:if test="${searchDTO.sortColumn eq 'postCreatedAt'}">
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
            <td class="text-start">
                <a href="/post/detail?postIdx=${orderDTO.postIdx}"
                   class="text-decoration-none text-dark">
                        ${orderDTO.postTitle}
                </a>
            </td>
            <td>${orderDTO.postMemberId}</td>
            <td>${orderDTO.postCreatedAt.toLocalDate()}</td>
        </tr>
    </c:forEach>
    </tbody>
</table>
