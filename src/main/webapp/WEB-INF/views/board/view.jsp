<%@ page import="net.spb.spb.util.FileUtil" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%-- Created by IntelliJ IDEA. User: sinjihye Date: 2025. 4. 29. Time: 10:27 To
change this template use File | Settings | File Templates. --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<c:set var="cp" value="${pageContext.request.contextPath}"/>
<html>
<head>
    <title>${post.postTitle} - 봄콩이 ${category.displayName}</title>
    <style>
        .comment-edit {
            display: none;
        }

        .img-gallery {
            display: flex;
            gap: 10px;
            justify-content: center;
            flex-wrap: wrap;
            margin-bottom: 1rem;
        }

        .img-preview {
            max-width: 180px;
            max-height: 180px;
            object-fit: cover;
            border: 1px solid #dee2e6;
            border-radius: 0.5rem;
            cursor: pointer;
            transition: transform 0.2s ease-in-out;
        }

        .img-preview:hover {
            transform: scale(1.05);
        }

        .file-list {
            font-size: 13px;
        }
    </style>
</head>
<body>
<%@ include file="../common/sidebarHeader.jsp" %>
<div class="content">
    <div class="container my-5">
        <%@ include file="../common/breadcrumb.jsp" %>
    </div>
    <div class="container my-5 pb-5" style="min-height: 100vh;">
        <div class="card shadow-sm border rounded-3 bg-light">
            <div class="card-body">
                <h2 class="h4 fw-bold">${post.postTitle}</h2>
                <div class="d-flex gap-3 align-items-center border-bottom pb-3 mb-4">
                    <c:choose>
                        <c:when test="${not empty post.memberProfileImg}">
                            <img src="${cp}/upload/${post.memberProfileImg}" width="40" height="40"
                                 class="rounded-circle"
                                 onerror="this.src='${cp}/resources/img/default_profileImg.png';" alt="프로필 이미지">
                        </c:when>
                        <c:otherwise>
                            <img src="${cp}/resources/img/default_profileImg.png" width="40" height="40"
                                 class="rounded-circle" alt="프로필 이미지">
                        </c:otherwise>
                    </c:choose>

                    <div class="flex-grow-1">
                        <div class="fw-semibold">${post.memberName} (${post.postMemberId})</div>
                        <div class="d-flex justify-content-between text-muted small">
                            <div>${fn:replace(post.postCreatedAt, 'T', ' ')}
                                <c:if test="${not empty post.postUpdatedAt}">
                                    (수정: ${fn:replace(post.postUpdatedAt, 'T', ' ')})
                                </c:if>
                            </div>
                            <div>조회 ${post.postReadCnt} | 댓글 ${fn:length(post.postComments)} | 좋아요
                                <span class="likeCount">${post.postLikeCnt}</span></div>
                        </div>
                    </div>
                </div>

                <div class="mb-4" style="white-space: pre-line;"><c:out value="${post.postContent}"/></div>

                <div class="img-gallery">
                    <c:forEach items="${post.postFiles}" var="file">
                        <c:if test="${file.image}">
                            <a href="/upload/${file.fileName}" target="_blank" title="이미지 원본 보기">
                                <img src="/upload/${file.fileName}" class="img-preview"/>
                            </a>
                        </c:if>
                    </c:forEach>
                </div>
                <div class="file-list">
                    <c:forEach items="${post.postFiles}" var="file">
                        <c:if test="${not file.image}">
                            <div class="d-flex justify-content-between align-items-center border p-2 rounded mb-2">
                                <div>
                                    <i class="bi ${FileUtil.getIconClass(file.fileExt)} me-2"></i>
                                        ${file.fileOrgName}
                                    <span class="text-muted small ms-2">(${FileUtil.formatFileSize(file.fileSize)})</span>
                                </div>
                                <a class="btn btn-sm btn-outline-secondary"
                                   href="/upload/${file.fileName}" download>
                                    <i class="bi bi-download"></i> 다운로드
                                </a>
                            </div>
                        </c:if>
                    </c:forEach>
                </div>

                <div class="d-flex justify-content-between align-items-start mt-3 flex-wrap gap-2">

                    <div>
                        <button class="btn btn-secondary btn-sm" onclick="location.href='list'"><i class="bi bi-list"></i>
                            목록
                        </button>
                    </div>

                    <div class="d-flex flex-wrap gap-2 justify-content-end">
                        <button class="btn btn-outline-primary btn-sm" id="btnCopyUrl"><i class="bi bi-share"></i> 공유</button>
                        <c:if test="${category == 'freeboard' and not empty sessionScope.memberId}">
                            <button type="submit" id="btnReport" class="btn btn-outline-danger btn-sm"
                                    data-report-ref-idx="${post.postIdx}" data-post-member-id="${post.postMemberId}"
                                    data-report-ref-type="POST">
                                <i class="bi bi-flag"></i> 신고
                            </button>
                        </c:if>
                        <c:if test="${sessionScope.memberId eq post.postMemberId}">
                            <button class="btn btn-warning btn-sm" onclick="location.href='modify?idx=${post.postIdx}'"><i
                                    class="bi bi-pencil"></i> 수정
                            </button>
                            <button class="btn btn-danger btn-sm" id="btnPostDelete" data-post-idx="${post.postIdx}"
                                    data-member-id="${post.postMemberId}">
                                <i class="bi bi-trash"></i> 삭제
                            </button>
                        </c:if>

                        <c:if test="${not empty sessionScope.memberId}">
                            <button type="button"
                                    class="btn btn-outline-success btn-sm ${post.like ? 'liked' : ''}"
                                    id="btnLike"
                                    data-post-idx="${post.postIdx}"
                                    data-like-ref-type="POST">
                                    ${category != 'freeboard' ? '도움이 돼요 ': ''}
                                👍&nbsp;&nbsp;<span class="likeCount">${post.postLikeCnt}</span>
                            </button>
                        </c:if>
                    </div>
                </div>
                <hr/>

                <!-- 댓글 목록 -->
                <c:if test="${category == 'freeboard'}">
                    <div class="post-comments mb-4" id="commentList">
                        <c:forEach items="${post.postComments}" var="postComment">
                            <div class="comment-item border-bottom pb-2 mb-2"
                                 data-comment-idx="${postComment.postCommentIdx}">
                                <div class="d-flex justify-content-between">
                                    <div class="d-flex align-items-center">
                                        <img src="${cp}/upload/${postComment.postCommentMemberProfileImg}" width="24"
                                             height="24"
                                             class="rounded-circle me-2"
                                             onerror="this.src='${cp}/resources/img/default_profileImg.png';"
                                             alt="댓글 작성자 프로필 이미지">
                                        <strong>${postComment.postCommentMemberId}</strong>
                                    </div>
                                    <div class="text-muted small comment-info">
                                            ${fn:replace(postComment.postCommentCreatedAt, 'T', ' ')}
                                        <c:if test="${not empty postComment.postCommentUpdatedAt}">
                                            (수정: ${fn:replace(postComment.postCommentUpdatedAt, 'T', ' ')})
                                        </c:if>
                                    </div>
                                </div>
                                <div class="comment-body mt-2">
                                    <div class="comment-text"><c:out value="${postComment.postCommentContent}"/></div>
                                    <!-- 댓글 수정 -->
                                    <div class="comment-edit position-relative border rounded p-3 bg-light mt-2"
                                         style="min-height: 100px;">
                                        <div class="position-absolute top-0 end-0 pe-3 pt-2 small text-muted">
                                            <span class="editCharCount">0</span> / 3000
                                        </div>

                                        <textarea class="form-control edit-textarea border-0 shadow-none mb-4 ps-0"
                                                  style="resize: none; overflow: hidden; height: auto; background: transparent;"
                                                  maxlength="3000">${postComment.postCommentContent}</textarea>

                                        <div class="position-absolute end-0 bottom-0 p-2">
                                            <button class="btn btn-sm btn-outline-primary"
                                                    onclick="saveEdit(this, ${postComment.postCommentIdx}, '${sessionScope.memberId}')">
                                                저장
                                            </button>
                                            <button class="btn btn-sm btn-outline-secondary" onclick="cancelEdit(this)">
                                                취소
                                            </button>
                                        </div>
                                    </div>

                                    <div class="text-end mt-2">
                                        <c:if test="${sessionScope.memberId eq postComment.postCommentMemberId}">
                                            <button class="btn btn-sm btn-link text-decoration-none"
                                                    onclick="enableEdit(this)">수정
                                            </button>
                                            <button class="btn btn-sm btn-link text-danger text-decoration-none commentDeleteButton"
                                                    data-comment-idx="${postComment.postCommentIdx}"
                                                    data-member-id="${postComment.postCommentMemberId}">삭제
                                            </button>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:if>
                <!-- 댓글 입력 -->
                <c:if test="${category == 'freeboard' and not empty sessionScope.memberId}">
                    <div class="comment-input-wrapper position-relative border rounded p-3 bg-white"
                         style="min-height: 100px;">

                        <div class="position-absolute top-0 start-0 ps-3 pt-2">
                                ${sessionScope.memberId}
                        </div>

                        <div class="position-absolute top-0 end-0 pe-3 pt-2 text-muted small">
                            <span id="commentCharCount">0</span> / 3000
                        </div>

                        <!-- 입력 영역 -->
                        <textarea id="postCommentContent"
                                  class="comment-textarea form-control border-0 shadow-none p-0 my-4"
                                  placeholder="댓글을 입력하세요"
                                  style="resize: none; height: auto; background: transparent;"
                                  maxlength="3000"></textarea>

                        <div class="comment-controls position-absolute end-0 bottom-0 p-2 mt-2">
                            <button type="button" class="btn btn-primary btn-sm" id="commentInsertButton"
                                    data-member-id="${sessionScope.memberId}"
                                    data-post-idx="${post.postIdx}"
                                    data-profile-img="${memberDTO.memberProfileImg}">
                                작성
                            </button>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</div>
<!-- Toast 메시지 -->
<div class="position-fixed bottom-0 end-0 p-3" style="z-index: 11">
    <div id="toastMessage" class="toast align-items-center text-bg-dark border-0" role="alert" aria-live="assertive"
         aria-atomic="true">
        <div class="d-flex">
            <div class="toast-body" id="toastText">알림 메시지</div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
        </div>
    </div>
</div>

<!-- 스크립트 -->

<script>
    const sessionMemberId = '${sessionScope.memberId != null ? sessionScope.memberId : ''}';
    // 게시글 삭제
    document.getElementById('btnPostDelete')?.addEventListener('click', function () {
        if (!confirm("정말 게시글을 삭제할까요?")) return;
        fetch("/board/${category}/delete", {
            method: "POST",
            headers: {"Content-Type": "application/x-www-form-urlencoded"},
            body: new URLSearchParams({
                postIdx: this.dataset.postIdx,
                postMemberId: this.dataset.memberId
            })
        }).then(res => res.json()).then(json => {
            if (json.success) {
                showToast(json.message);
                setTimeout(() => window.location.href = json.redirect, 1500);
            } else showToast(json.message, true);
        }).catch(() => showToast("삭제 실패", true));
    });

    // 댓글 삭제
    document.getElementById('commentList')?.addEventListener('click', function (e) {
        if (e.target.classList.contains('commentDeleteButton')) {
            if (!confirm("댓글을 삭제할까요?")) return;
            const commentItem = e.target.closest('.comment-item');
            fetch("/board/${category}/comment/delete", {
                method: "POST",
                headers: {"Content-Type": "application/x-www-form-urlencoded"},
                body: new URLSearchParams({
                    postCommentIdx: e.target.dataset.commentIdx,
                    postCommentMemberId: e.target.dataset.memberId
                })
            }).then(res => res.json()).then(json => {
                if (json.success) {
                    showToast(json.message);
                    commentItem.remove();
                } else {
                    showToast(json.message, true);
                }
            }).catch(() => showToast("댓글 삭제 실패", true));
        }
    });

    // 댓글 수정 모드
    function enableEdit(btn) {
        const body = btn.closest('.comment-body');
        body.querySelector('.comment-text').style.display = 'none';
        body.querySelector('.comment-edit').style.display = 'block';
    }

    function cancelEdit(btn) {
        const body = btn.closest('.comment-body');
        body.querySelector('.comment-edit').style.display = 'none';
        body.querySelector('.comment-text').style.display = 'block';
    }

    function saveEdit(btn, commentIdx, memberId) {
        const commentItem = btn.closest('.comment-item');
        const body = btn.closest('.comment-body');
        const infoBox = commentItem.querySelector('.comment-info');

        const newContent = body.querySelector('.edit-textarea').value.trim();
        fetch("/board/${category}/comment/modify", {
            method: "POST",
            headers: {"Content-Type": "application/x-www-form-urlencoded"},
            body: new URLSearchParams({
                postCommentIdx: commentIdx,
                postCommentMemberId: memberId,
                postCommentContent: newContent
            })
        }).then(res => res.json()).then(json => {
            if (json.success) {
                body.querySelector('.comment-text').textContent = newContent;
                let original = infoBox.dataset.originalDate;
                if (!original) {
                    original = infoBox.textContent.trim().split('(')[0].trim();
                }
                infoBox.innerHTML = original +
                    '<span class="text-muted">(수정: ' +
                    json.updatedAt +
                    ')</span>';
                infoBox.dataset.originalDate = original;
                cancelEdit(btn);
                showToast(json.message);
            } else showToast(json.message, true);
        }).catch((e) => showToast("댓글 수정 실패: " + e, true));
    }

    // 댓글 수정 textarea 실시간 처리
    document.querySelectorAll('.edit-textarea').forEach(textarea => {
        const countSpan = textarea.closest('.comment-edit').querySelector('.editCharCount');

        const update = () => {
            textarea.style.height = 'auto';
            textarea.style.height = textarea.scrollHeight + 'px';
            countSpan.textContent = textarea.value.length;
        };

        textarea.addEventListener('input', update);
        update(); // 초기 실행
    });

    // 댓글 입력
    const textarea = document.getElementById('postCommentContent');

    textarea?.addEventListener('input', function () {
        this.style.height = 'auto'; // 높이 초기화
        this.style.height = this.scrollHeight + 'px'; // 내용만큼 늘림

        // 글자 수 카운트
        document.getElementById('commentCharCount').textContent = this.value.length;
    });

    // 댓글 등록
    document.getElementById('commentInsertButton')?.addEventListener('click', function () {
        const content = document.getElementById('postCommentContent').value.trim();
        const postIdx = this.dataset.postIdx;
        const memberProfileImg = this.dataset.profileImg ?? "";

        if (!content) {
            showToast("댓글 내용을 입력해주세요.", true);
            return;
        }

        fetch(`/board/${category}/comment/write`, {
            method: "POST",
            headers: {"Content-Type": "application/x-www-form-urlencoded"},
            body: new URLSearchParams({
                postCommentContent: content,
                postCommentRefPostIdx: postIdx,
                memberProfileImg: memberProfileImg
            })
        })
            .then(res => res.text())
            .then(text => {
                let json;
                try {
                    json = JSON.parse(text);
                } catch (e) {
                    showToast("서버 응답 형식 오류", true);
                    return;
                }
                if (json.success) {
                    showToast(json.message);
                    const comment = json.comment;
                    let createdAt = json.createdAt;
                    const profileImg = comment.postCommentMemberProfileImg
                        ? (comment.postCommentMemberProfileImg.startsWith("/upload/")
                            ? comment.postCommentMemberProfileImg
                            : '/upload/' + comment.postCommentMemberProfileImg)
                        : '/resources/img/default_profileImg.png';

                    const div = document.createElement('div');
                    div.setAttribute('data-comment-idx', comment.postCommentIdx);
                    div.classList.add('comment-item', 'border-bottom', 'pb-2', 'mb-2');

                    div.innerHTML =
                        '<div class="d-flex justify-content-between">' +
                        '<div class="d-flex align-items-center">' +
                        '<img src="' + profileImg + '" width="24" height="24" class="rounded-circle me-2" alt="프로필">' +
                        '<strong>' + comment.postCommentMemberId + '</strong>' +
                        '</div>' +
                        '<div class="text-muted small comment-info" data-original-date="' + createdAt + '">' + createdAt + '</div>' +
                        '</div>' +
                        '<div class="comment-body mt-2">' +
                        '<div class="comment-text">' + comment.postCommentContent + '</div>' +
                        '<div class="comment-edit position-relative border rounded p-3 bg-light mt-2" style="min-height: 100px;">' +
                        '<div class="position-absolute top-0 end-0 pe-3 pt-2 small text-muted">' +
                            '<span class="editCharCount">0</span> / 3000</div>' +

                        '<textarea class="form-control edit-textarea border-0 shadow-none mb-4 ps-0" style="resize: none; overflow: hidden; height: auto; background: transparent;" maxlength="3000">' + comment.postCommentContent + '</textarea>' +
                        '<div class="position-absolute end-0 bottom-0 p-2">' +
                        '<button class="btn btn-sm btn-outline-primary" onclick="saveEdit(this, ' + comment.postCommentIdx + ', \'' + sessionMemberId + '\')">저장</button>' +
                        '<button class="btn btn-sm btn-outline-secondary" onclick="cancelEdit(this)">취소</button>' +
                        '</div>' +
                        '</div>' +
                        '<div class="text-end mt-2">' +
                        '<button class="btn btn-sm btn-link" onclick="enableEdit(this)" style="text-decoration: none;">수정</button>' +
                        '<button class="btn btn-sm btn-link text-danger commentDeleteButton" style="text-decoration: none;"' +
                        'data-comment-idx="' + comment.postCommentIdx + '" ' +
                        'data-member-id="' + comment.postCommentMemberId + '">삭제</button>' +
                        '</div>' +
                        '</div>';

                    document.getElementById('commentList').appendChild(div);
                    document.getElementById('postCommentContent').value = '';
                } else {
                    showToast(json.message || "댓글 등록에 실패했습니다.", true);
                }
            })
            .catch(err => {
                showToast("댓글 등록 요청 중 오류 발생", true);
            });
    });

    // 좋아요 처리
    document.getElementById('btnLike')?.addEventListener('click', function () {
        const btn = this;
        const isLiked = btn.classList.contains('liked');
        const action = isLiked ? "delete" : "regist";
        const url = "/board/${category}/like/" + action;

        fetch(url, {
            method: "POST",
            headers: {"Content-Type": "application/x-www-form-urlencoded"},
            body: new URLSearchParams({
                postLikeRefIdx: this.dataset.postIdx,
                postLikeRefType: this.dataset.likeRefType
            })
        })
            .then(res => res.json())
            .then(json => {
                if (json.success) {
                    showToast(json.message);
                    btn.classList.toggle("liked");
                    const countSpans = document.querySelectorAll(".likeCount");
                    countSpans.forEach((countSpan) => {
                        let count = parseInt(countSpan.textContent.trim(), 10);
                        if (!isNaN(count))
                            countSpan.textContent = isLiked ? count - 1 : count + 1;
                    })

                } else showToast(json.message, true);
            }).catch(() => showToast("좋아요 처리 실패", true));
    })

    // 게시글 신고
    document.getElementById("btnReport")?.addEventListener("click", function () {
        const reportRefIdx = this.dataset.reportRefIdx;
        const postMemberId = this.dataset.postMemberId;
        fetch(`/board/${category}/report/regist`, {
            method: "POST",
            headers: {"Content-Type": "application/x-www-form-urlencoded"},
            body: new URLSearchParams({
                reportRefIdx: reportRefIdx,
                reportRefType: "POST",
                postMemberId: postMemberId
            })
        })
            .then(res => res.json())
            .then(json => {
                if (json.success) {
                    showToast(json.message);
                } else {
                    showToast(json.message, true);
                }
            })
            .catch(() => showToast("신고 처리 중 오류가 발생했습니다.", true));
    });

    // toast 함수
    function showToast(message, isError = false) {
        const toastEl = document.getElementById("toastMessage");
        const toastText = document.getElementById("toastText");
        toastText.innerText = message;
        toastEl.classList.remove("text-bg-success", "text-bg-danger");
        toastEl.classList.add(isError ? "text-bg-danger" : "text-bg-success");
        new bootstrap.Toast(toastEl).show();
    }

    // url 클립보드 복사
    document.getElementById("btnCopyUrl").addEventListener("click", function () {
        const url = window.location.href;
        navigator.clipboard.writeText(url).then(() => {
            showToast("URL이 클립보드에 복사되었습니다.");
        }).catch(err => {
            showToast("복사에 실패했습니다: " + err, true);
        });
    });
</script>
</body>
</html>
