<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- Begin Page Content -->
<div class="container-fluid">

  <!-- Page Heading -->
  <h1 class="h3 mb-2 text-gray-800">Tables</h1>

  <!-- DataTales Example -->
  <div class="card shadow mb-4">
    <div class="card-header py-3">
      <h6 class="m-0 font-weight-bold text-primary">Customer INQUIRY</h6>
    </div>
    <div class="card-body">
      <div class="table-responsive">
        <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
          <thead>
          <tr>
            <th>ID</th>
            <th>NAME</th>
            <th>Type</th>
            <th>Ctt</th>
            <th>Register Date</th>
          </tr>
          </thead>
          <tfoot>
          <tr>
            <th>ID</th>
            <th>NAME</th>
            <th>Type</th>
            <th>Ctt</th>
            <th>Register Date</th>
          </tr>
          </tfoot>
          <tbody>
          <c:forEach var="i" items="${ilist}">
            <tr>
              <%-- 수정된 링크: /cust/details로 고객 ID(custId)를 전달 --%>
              <td><a href="<c:url value="/cust/details?id=${i.custId}"/>">${i.iqId}</a></td>
              <td>${i.custId}</td>
              <td>${i.cateName}</td>
              <td>${i.iqCtt}</td>
              <td>
                <fmt:parseDate value="${i.iqRegdate}"
                               pattern="yyyy-MM-dd HH:mm:ss" var="parsedDateTime" type="both" />
                <fmt:formatDate pattern="yyyy년MM월dd일" value="${parsedDateTime}" />
              </td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </div>
    </div>
  </div>

</div>
<!-- /.container-fluid -->

<!-- Page level plugins -->
<script src="/vendor/datatables/jquery.dataTables.min.js"></script>
<script src="/vendor/datatables/dataTables.bootstrap4.min.js"></script>

<!-- Page level custom scripts -->
<script src="/js/demo/datatables-demo.js"></script>