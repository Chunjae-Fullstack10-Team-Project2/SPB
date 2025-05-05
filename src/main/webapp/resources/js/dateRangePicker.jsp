
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<body>
<script>
  $(function () {
    $('input[name="datefilter"]')
            .daterangepicker({
              autoUpdateInput: false,
              locale: {
                format: "YYYY-MM-DD",
                separator: " - ",
                applyLabel: "확인",
                cancelLabel: "취소",
                customRangeLabel: "Custom",
                weekLabel: "주",
                daysOfWeek: ["일", "월", "화", "수", "목", "금", "토"],
                monthNames: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
                firstDay: 1
              }
            });

    $('input[name="datefilter"]').on('apply.daterangepicker', function (ev, picker) {
      $(this).val(picker.startDate.format('YYYY-MM-DD') + ' - ' + picker.endDate.format('YYYY-MM-DD'));
    });

    $('#btnSearch').click(function (e) {
      e.preventDefault();

      var url = new URL(window.location.href);
      var params = url.searchParams;

      var datefilter = $('input[name="datefilter"]').val();
      if (datefilter) {
        var dates = datefilter.split(' - ');
        params.set('startDate', dates[0]);
        params.set('endDate', dates[1]);
      } else {
        params.delete('startDate');
        params.delete('endDate');
      }

      params.set('searchType', $('select[name="searchType"]').val());
      params.set('searchWord', $('input[name="searchWord"]').val());

      window.location.href = url.toString();
    });

    $('#btnReset').click(function () {
      $('input[name="searchWord"]').val('');
      $('select[name="searchType"]').val('qnaTitle');
      $('input[name="datefilter"]').val('');

      var url = new URL(window.location.href);
      var params = url.searchParams;
      params.delete('datefilter');
      params.delete('startDate');
      params.delete('endDate');
      params.delete('searchType');
      params.delete('searchWord');

      window.location.href = url.toString();
    });
  });

  <c:if test="${not empty message}">
  alert("${message}");
  </c:if>
</script>
</body>
</html>
