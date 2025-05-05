<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%-- Created by IntelliJ IDEA. User: sinjihye Date: 2025. 4. 29. Time: 10:27 To
change this template use File | Settings | File Templates. --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head>
    <title>봄콩이 ${category.displayName}</title>
    <style>
      .post-header-info {
        display: flex;
        gap: 10px;
      }
      .post-content-postimg img{
        max-width: 100%;
        max-height: 80vh;
      }
      .post-header-info-author {
        font-size: 13px;
      }
    </style>
  </head>
  <body>
  <%@ include file="../common/header.jsp" %>
    <div class="container">
      <div class="breadcrumbs">
        <a href="/board/${category}/list">${category.displayName}</a> > 상세 페이지
      </div>
      <div class="post">
          <input type="hidden" name="idx" value="${post.postIdx}" />
          <!-- 제목, 정보 영역 -->
          <div class="post-header">
            <h1 class="h2">${post.postTitle}</h1>
            <div class="post-header-info">
              <img src="https://github.com/mdo.png" alt="mdo" width="32" height="32" class="rounded-circle">
              <div class="post-header-info-author">
                ${post.postMemberId}
                <div class="post-header-info-readcnt">조회 ${post.postReadCnt} | 댓글 ${fn:length(post.postComments)}</div>
              </div>
            </div>
            <hr />
          </div>

          <!-- 내용 영역 -->
          <div class="post-content">
            <div class="post-content-postcontent">
              <p>${post.postContent}</p>
            </div>
            <c:if test="${not empty post.postFiles}">
              <c:forEach items="${post.postFiles}" var="file">
                <div class="post-content-postimg">
                  <a href="/upload/${file.fileName}" target="_blank">
                    <img src="/upload/${file.fileName}"/>
                  </a>
                </div>
              </c:forEach>
            </c:if>
            <div class="post-content-ex">
              <button type="button" class="btn" id="btnShare">공유</button> |
              <form name="frmReport" action="/board/${category}/report/regist" method="post" style="display: inline;">
                <input type="hidden" name="reportRefIdx" value="${post.postIdx}"/>
                <input type="hidden" name="reportMemberId" value="${sessionScope.memberId}"/>
                <button type="submit" class="btn" id="btnReport">신고</button>
              </form>
            </div>

            <form name="frmDelete" id="frmDelete" method="post" action="/board/${category}/delete">
              <div class="post-content-btn">
                <button type="button" class="btn btn-outline-secondary" id="btnList">목록 이동</button>
                <button type="button" class="btn btn-outline-warning" id="btnPostModify">수정하기</button>
                <button type="submit" class="btn btn-outline-danger" id="btnPostDelete">삭제하기</button>
              </div>
            </form>
            <hr />
          </div>
        <!-- 좋아요 영역 -->
        <div class="post-like">
          <form name="frmLike" action="/board/${category}/like/regist" method="post" id="frmLike">
            <input type="hidden" name="postIdx" value="${post.postIdx}"/>
            <input type="hidden" name="postLikeRefIdx" value="${post.postIdx}"/>
            <input type="hidden" name="postLikeRefType" value="POST"/>
            <button type="submit" class="btn" id="btnLike">👍 ${post.postLikeCnt}</button>
          </form>
        </div>
        <!-- 댓글 영역 -->
        <c:choose>
          <c:when test="${not empty post.postComments}">
            <c:forEach items="${post.postComments}" var="postComment">
              <form name="frmComment${postComment.postCommentIdx}" class="frmComment">
                <input type="hidden" name="postCommentIdx" value="${postComment.postCommentIdx}"/>
                <input type="hidden" name="postCommentRefPostIdx" value="${postComment.postCommentRefPostIdx}"/>
                <input type="hidden" name="postCommentMemberId" value="${postComment.postCommentMemberId}"/>

                <div class="comment-item" id="comment-item${postComment.postCommentIdx}">
                  <div class="post-comment">
                    <div class="post-comment-author-img">
                      <img src="https://github.com/mdo.png" alt="mdo" width="32" height="32" class="rounded-circle">
                        ${postComment.postCommentMemberId}
                    </div>
                    <div class="post-comment-createdat-updatedat">
                      ${fn:replace(postComment.postCommentCreatedAt, 'T', ' ')}
                      <c:if test="${not empty postComment.postCommentUpdatedAt}">
                      (수정: ${fn:replace(postComment.postCommentUpdatedAt, 'T', ' ')})
                      </c:if>
                    </div>
                    <div class="comment-edit-delete-btn">
                      <input type="button" class="comment-btn edit-btn" style="border: 0px;background:none;" value="편집" onclick="enableEdit(this)" />
                      <input type="button" class="comment-btn delete-btn commentDeleteButton" style="border: 0px;background:none;" value="삭제"/>
                    </div>
                  </div>

                  <div class="comment-body">
                    <div class="comment-text">${postComment.postCommentContent}</div>
                    <div class="comment-edit" style="display:none;">
                      <textarea class="edit-textarea" name="postCommentContent" style="width:100%;">${postComment.postCommentContent}</textarea>
                      <div class="edit-actions">
                        <input type="button" value="저장" onclick="saveEdit(this)" />
                        <input type="button" value="취소" onclick="cancelEdit(this)" />
                      </div>
                    </div>
                  </div>
                </div>
              </form>
            </c:forEach>
          </c:when>
          <c:otherwise>
            댓글이 없어요
          </c:otherwise>
        </c:choose>

        <div class="post-comment-input">
          <form name="frmCommentRegist" id="frmCommentRegist" action="/board/${category}/comment/write" method="post">
            <input type="hidden" name="postCommentMemberId" value="${sessionScope.memberId}">
            <input type="hidden" name="postCommentRefPostIdx" value="${post.postIdx}"/>
            <div class="post-comment-input-comment">
              <textarea name="postCommentContent"></textarea>
            </div>
            <button type="submit" class="btn btn-primary">작성</button>
          </form>
        </div>
      </div>
    </div>
    <script>
      document.getElementById('btnList').addEventListener('click', function() {
        window.location.href='list';
      })
      const btnPostModify = document.getElementById("btnPostModify");
      if (btnPostModify) {
        btnPostModify.addEventListener("click", function () {
          window.location.href = "modify?idx=${post.postIdx}";
        });
      }

      const btnPostDelete = document.getElementById("btnPostDelete");
      if (btnPostDelete) {
        btnPostDelete.addEventListener("click", function () {
          if (confirm("정말 게시글을 삭제할까요?")) {
            const frmDelete = document.getElementById("frmDelete");
            frmDelete.submit();
          }
        });
      }

      // 댓글 삭제
      document.querySelectorAll('.commentDeleteButton').forEach(button => {
        button.addEventListener('click', function() {
          if(confirm('정말 댓글을 삭제하시겠습니까?')) {
            const form = this.closest('form');
            form.action = "/board/${category}/comment/delete";
            form.method="post";
            form.submit();
          }
        })
      })

      // 댓글 편집
      function enableEdit(editBtn) {
        const form = editBtn.closest('form');
        const commentText = form.querySelector('.comment-text');
        const commentEdit = form.querySelector('.comment-edit');

        commentText.style.display = 'none';
        commentEdit.style.display = 'block';
      }

      // 댓글 편집 취소
      function cancelEdit(cancelBtn) {
        const form = cancelBtn.closest('form');
        const commentText = form.querySelector('.comment-text');
        const commentEdit = form.querySelector('.comment-edit');
        const textarea = form.querySelector('.edit-textarea');

        textarea.value = commentText.textContent.trim();
        commentText.style.display = 'block';
        commentEdit.style.display = 'none';
      }

      // 댓글 편집 저장
      function saveEdit(saveBtn) {
        const form = saveBtn.closest('form');
        const textarea = form.querySelector('.edit-textarea');
        const commentText = form.querySelector('.comment-text');
        const commentEdit = form.querySelector('.comment-edit');

        commentText.textContent = textarea.value.trim();
        commentText.style.display = 'block';
        commentEdit.style.display = 'none';

        form.action = "/board/${category}/comment/modify";
        form.method = "post";
        form.submit();
      }
      // 좋아요
      document.getElementById('btnLike').addEventListener('click', function() {
        const frm = document.getElementById('frmLike');
        if (${post.like}) {
          frm.action = "/board/${category}/like/delete";
        }
        frm.submit();
      });
    </script>
  </body>
</html>
