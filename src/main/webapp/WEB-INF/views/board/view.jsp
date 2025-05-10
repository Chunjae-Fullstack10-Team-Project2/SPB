<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%-- Created by IntelliJ IDEA. User: sinjihye Date: 2025. 4. 29. Time: 10:27 To
change this template use File | Settings | File Templates. --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<c:set var="cp" value="${pageContext.request.contextPath}"/>
<html>
<head>
  <title>${post.postTitle} - 봄콩이 ${category.displayName}</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
  <style>
    .comment-edit { display: none; }
    .btn.liked {
      background-color: #198754;
      color: white;
      border-color: #198754;
    }
  </style>
</head>
<body>
<%@ include file="../common/sidebarHeader.jsp" %>
<div class="content">
  <div class="container my-5">
    <%@ include file="../common/breadcrumb.jsp" %>
  </div>
  <div class="container my-5">
    <h2 class="h4 fw-bold">${post.postTitle}</h2>
    <div class="d-flex gap-2 align-items-center mb-2">
      <img src="${cp}/upload/${post.memberProfileImg}" width="32" height="32" class="rounded-circle">
      <div>
        <div class="small">${post.postMemberId}</div>
        <div class="text-muted small">조회 ${post.postReadCnt} | 댓글 ${fn:length(post.postComments)}</div>
      </div>
    </div>
    <hr/>

    <p>${post.postContent}</p>
    <c:forEach items="${post.postFiles}" var="file">
      <div class="my-3">
        <a href="/upload/${file.fileName}" target="_blank">
          <img src="/upload/${file.fileName}" class="img-fluid rounded border"/>
        </a>
      </div>
    </c:forEach>

    <div class="d-flex gap-2 mt-3">
      <button class="btn btn-outline-primary btn-sm"><i class="bi bi-share"></i> 공유</button>
      <button type="submit" id="btnReport" class="btn btn-outline-danger btn-sm" data-report-ref-idx="${post.postIdx}" data-post-member-id="${post.postMemberId}" data-report-ref-type="POST"><i class="bi bi-flag"></i> 신고</button>
    </div>

    <div class="d-flex gap-2 my-4">
      <button class="btn btn-secondary btn-sm" onclick="location.href='list'"><i class="bi bi-list"></i> 목록</button>
      <c:if test="${sessionScope.memberId eq post.postMemberId}">
        <button class="btn btn-warning btn-sm" onclick="location.href='modify?idx=${post.postIdx}'"><i class="bi bi-pencil"></i> 수정</button>
        <button class="btn btn-danger btn-sm" id="btnPostDelete" data-post-idx="${post.postIdx}" data-member-id="${post.postMemberId}">
          <i class="bi bi-trash"></i> 삭제
        </button>
      </c:if>
    </div>

    <button type="button"
            class="btn btn-outline-success btn-sm ${post.like ? 'liked' : ''}"
            id="btnLike"
            data-post-idx="${post.postIdx}"
            data-like-ref-type="POST">
      👍 <span id="likeCount">${post.postLikeCnt}</span>
    </button>

    <hr/>

    <!-- 댓글 목록 -->
    <div class="post-comments mb-4">
      <c:forEach items="${post.postComments}" var="postComment">
        <div class="comment-item border-bottom pb-2 mb-2" data-comment-idx="${postComment.postCommentIdx}">
          <div class="d-flex justify-content-between">
            <div>
              <img src="https://github.com/mdo.png" width="24" height="24" class="rounded-circle me-2">
              <strong>${postComment.postCommentMemberId}</strong>
            </div>
            <div class="text-muted small">
                ${fn:replace(postComment.postCommentCreatedAt, 'T', ' ')}
              <c:if test="${not empty postComment.postCommentUpdatedAt}">
                (수정: ${fn:replace(postComment.postCommentUpdatedAt, 'T', ' ')})
              </c:if>
            </div>
          </div>
          <div class="comment-body mt-2">
            <div class="comment-text">${postComment.postCommentContent}</div>
            <div class="comment-edit">
              <textarea class="form-control edit-textarea">${postComment.postCommentContent}</textarea>
              <div class="mt-2 text-end">
                <button class="btn btn-sm btn-outline-primary" onclick="saveEdit(this, ${postComment.postCommentIdx}, '${sessionScope.memberId}')">저장</button>
                <button class="btn btn-sm btn-outline-secondary" onclick="cancelEdit(this)">취소</button>
              </div>
            </div>
            <c:if test="${sessionScope.memberId eq postComment.postCommentMemberId}">
              <div class="text-end mt-2">
                <button class="btn btn-sm btn-link text-decoration-none" onclick="enableEdit(this)">편집</button>
                <button class="btn btn-sm btn-link text-danger text-decoration-none commentDeleteButton"
                        data-comment-idx="${postComment.postCommentIdx}" data-member-id="${postComment.postCommentMemberId}">삭제</button>
              </div>
            </c:if>
          </div>
        </div>
      </c:forEach>
    </div>

    <!-- 댓글 입력 -->
    <div class="mb-2">
      <div class="col-8">
        <textarea id="postCommentContent" class="form-control" rows="3" placeholder="댓글을 입력하세요" style="resize: none;"></textarea>
      </div>
      <div class="col-2">
        <button type="button" class="btn btn-primary btn-sm" id="commentInsertButton"
                data-member-id="${sessionScope.memberId}"
                data-post-idx="${post.postIdx}"><i class="bi bi-chat-dots"></i> 댓글 작성</button>
      </div>
    </div>
  </div>
</div>
<!-- Toast 메시지 -->
<div class="position-fixed bottom-0 end-0 p-3" style="z-index: 11">
  <div id="toastMessage" class="toast align-items-center text-bg-dark border-0" role="alert" aria-live="assertive" aria-atomic="true">
    <div class="d-flex">
      <div class="toast-body" id="toastText">알림 메시지</div>
      <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
    </div>
  </div>
</div>

<!-- 스크립트 -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>

  // 게시글 삭제
  document.getElementById('btnPostDelete')?.addEventListener('click', function () {
    if (!confirm("정말 게시글을 삭제할까요?")) return;
    fetch("/board/${category}/delete", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
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

  // 댓글 등록
  document.getElementById('commentInsertButton').addEventListener('click', function () {
    const content = document.getElementById('postCommentContent').value;
    console.log(content);
    console.log(this.dataset.postIdx);
    fetch("/board/${category}/comment/write", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: new URLSearchParams({
        postCommentContent: content,
        postCommentRefPostIdx: this.dataset.postIdx
      })
    }).then(res => res.json()).then(json => {
      if (json.success) {
        showToast(json.message);
      } else showToast(json.message, true);
    }).catch(() => showToast("댓글 등록 실패", true));
  });

  // 댓글 삭제
  document.querySelectorAll('.commentDeleteButton').forEach(btn => {
    btn.addEventListener('click', function () {
      if (!confirm("댓글을 삭제할까요?")) return;
      const commentItem = this.closest('.comment-item');
      fetch("/board/${category}/comment/delete", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: new URLSearchParams({
          postCommentIdx: this.dataset.commentIdx,
          postCommentMemberId: this.dataset.memberId
        })
      }).then(res => res.json()).then(json => {
        if (json.success) {
          showToast(json.message);
          commentItem.remove();
        } else showToast(json.message, true);
      }).catch(() => showToast("댓글 삭제 실패", true));
    });
  });

  // 댓글 편집
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
    const body = btn.closest('.comment-body');
    const newContent = body.querySelector('.edit-textarea').value.trim();
    fetch("/board/${category}/comment/modify", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: new URLSearchParams({
        postCommentIdx: commentIdx,
        postCommentMemberId: memberId,
        postCommentContent: newContent
      })
    }).then(res => res.json()).then(json => {
      if (json.success) {
        body.querySelector('.comment-text').textContent = newContent;
        cancelEdit(btn);
        showToast(json.message);
      } else showToast(json.message, true);
    }).catch(() => showToast("댓글 수정 실패", true));
  }

  // 좋아요 처리
  document.getElementById('btnLike').addEventListener('click', function() {
    const btn = this;
    const isLiked = btn.classList.contains('liked');
    const action = isLiked ? "delete" : "regist";
    const url = "/board/${category}/like/" + action;

    fetch(url, {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
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
        const countSpan = document.getElementById("likeCount");
        let count = parseInt(countSpan.textContent, 10);
        countSpan.textContent = isLiked ? count - 1 : count + 1;
      } else showToast(json.message, true);
    }).catch(() => showToast("좋아요 처리 실패", true));
  })

  // 게시글 신고
  document.getElementById("btnReport")?.addEventListener("click", function () {
    const reportRefIdx = this.dataset.reportRefIdx;
    const postMemberId = this.dataset.postMemberId;
    console.log("reportRefIdx",reportRefIdx);
    console.log("postMemberId",postMemberId);
    fetch(`/board/${category}/report/regist`, {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
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


  function showToast(message, isError = false) {
    const toastEl = document.getElementById("toastMessage");
    const toastText = document.getElementById("toastText");
    toastText.innerText = message;
    toastEl.classList.remove("text-bg-success", "text-bg-danger");
    toastEl.classList.add(isError ? "text-bg-danger" : "text-bg-success");
    new bootstrap.Toast(toastEl).show();
  }
</script>
</body>
</html>
