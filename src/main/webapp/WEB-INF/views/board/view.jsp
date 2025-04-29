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
      <form name="frmDelete" id="frmDelete" method="post" action="/board/freeboard/delete">
        <input type="hidden" name="idx" value="${post.postIdx}"/>
        <div class="post">
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

          <!-- 댓글 영역 -->
          <div class="post-comment">
            <div class="post-comment-author-img">
              <img src="" width="40px" height="40px" />
            </div>
            <div class="post-comment-content">
              Lorem Ipsum is simply dummy text of the printing and typesetting
              industry. Lorem Ipsum has been the industry's standard dummy text
              ever since the 1500s, when an unknown printer took a galley
            </div>
          </div>
        </div>
      </form>
    </div>
  <script>
    const btnPostModify = document.getElementById('btnPostModify');
    if (btnPostModify) {
      btnPostModify.addEventListener('click', function() {
        window.location.href = "modify?idx=${post.postIdx}";
      });
    }

    const btnPostDelete = document.getElementById('btnPostDelete');
    if (btnPostDelete) {
      btnPostDelete.addEventListener('click', function() {
        if (confirm('정말 게시글을 삭제할까요?')) {
          const frmDelete = document.getElementById('frmDelete');
          frmDelete.submit();
        }
      })
    }
  </script>
  </body>
</html>
