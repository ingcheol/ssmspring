<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="col-sm-10">
  <h2>Cust GetPage Page</h2>
  <table class="table table-bordered">
    <thead>
    <tr>
      <th>Id</th>
      <th>Name</th>
      <th>Regdate</th>
      <th>Update</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="c" items="${clist.getList()}">
      <tr>
        <td>${c.custId}</td>
        <td>${c.custName}</td>
        <td>
          <fmt:parseDate value="${ c.custRegdate }"
                         pattern="yyyy-MM-dd'T'HH:mm" var="parsedDateTime" type="both" />
          <fmt:formatDate pattern="yyyy년MM월dd일 HH:mm" value="${ parsedDateTime }" />
        </td>
        <td>
          <fmt:parseDate value="${c.custUpdate}"
                         pattern="yyyy-MM-dd'T'HH:mm" var="parsedDateTime" type="both" />
          <fmt:formatDate pattern="yyyy년MM월dd일 HH:mm" value="${ parsedDateTime }" />
        </td>
      </tr>
    </c:forEach>
    </tbody>
  </table>
  <jsp:include page="../page.jsp"/>
</div>