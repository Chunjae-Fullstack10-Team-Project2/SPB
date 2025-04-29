<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- Created by IntelliJ IDEA. User: sinjihye Date: 2025. 4. 29. Time: 10:27 To
change this template use File | Settings | File Templates. --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head>
    <title>봄콩이 자유게시판</title>
  </head>
  <body>
    <div class="container">
      <h1>자유게시판 🌱 - 상세 페이지</h1>
      <div class="post">
        <form name="frmDelete" id="frmDelete" method="post" action="/board/freeboard/delete">
          <input type="hidden" name="idx" value="${post.postIdx}" />
          <!-- 제목, 정보 영역 -->
          <div class="post-header">
            <h2>${post.postTitle}</h2>
            <div class="post-header-info">
              <img src="" width="50px" height="50px" />
              <div class="post-header-info-author">
                ${post.postMemberId}
                <div class="post-header-info-readcnt">조회 240 | 댓글 20</div>
              </div>
            </div>
            <hr />
          </div>

          <!-- 내용 영역 -->
          <div class="post-content">
            <div class="post-content-postcontent">
              <p>${post.postContent}</p>
            </div>
            <div class="post-content-postfile">
              <img src="" width="200px" height="50px" />
            </div>
            <div class="post-content-ex">공유 | 신고</div>
            <div class="post-content-btn">
              <button type="button" id="btnPostModify">수정하기</button>
              <button type="button" id="btnPostDelete">삭제하기</button>
            </div>
            <hr />
          </div>
        </form>
        <!-- 댓글 영역 -->
        <c:choose>
          <c:when test="${not empty post.postComments}">
            <c:forEach items="${post.postComments}" var="postComment">
              <form name="frmComment${postComment.postCommentIdx}" class="frmComment">
                <input type="hidden" name="postCommentIdx" value="${postComment.postCommentIdx}"/>
                <input type="hidden" name="postCommentRefPostIdx" value="${postComment.postCommentRefPostIdx}"/>

                <div class="comment-item">
                  <div class="post-comment">
                    <div class="post-comment-author-img">
                      <img src="" width="40px" height="40px" />
                        ${postComment.postCommentMemberId}
                    </div>
                    <div class="comment-edit-delete-btn">
                      <input type="button" class="comment-btn edit-btn" style="border: 0px;" value="편집" onclick="enableEdit(this)" />
                      <input type="button" class="comment-btn delete-btn commentDeleteButton" style="border: 0px;" value="삭제"/>
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
          <form name="frmCommentRegist" id="frmCommentRegist" action="/board/comment/write" method="post">
            <input type="hidden" name="postCommentMemberId" value="user01">
            <input type="hidden" name="postCommentRefPostIdx" value="${post.postIdx}"/>
            <div class="post-comment-input-comment">
              <textarea name="postCommentContent"></textarea>
            </div>
            <button type="submit">작성</button>
          </form>
        </div>
      </div>
    </div>
    <script>
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
            form.action = "/board/comment/delete";
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

        form.action = "/board/comment/modify";
        form.method = "post";
        form.submit();
      }
    </script>
  </body>
</html>
