<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<%
    application.setAttribute("APP_PATH", request.getContextPath());
%>
<head>
    <meta charset="UTF-8">
    <title>用户列表</title>
    <script src="${APP_PATH}/static/js/jquery-3.6.0.min.js"></script>
    <script src="${APP_PATH}/static/bootstrap-3.4.1-dist/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="${APP_PATH}/static/bootstrap-3.4.1-dist/css/bootstrap.min.css">
</head>
<body>
<div class="container">
    <div class="row">
        <div class="col-lg-12">
            <h1>SSM-CRUD</h1>
        </div>
    </div>
    <div class="row" style="margin-bottom: 10px">
        <div class="col-lg-4 col-lg-offset-8 text-center">
            <button type="button" class="btn btn-success">新增</button>
            <button type="button" class="btn btn-warning">删除</button>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12">
            <table class="table table-hover">
                <%--表头--%>
                <tr>
                    <th>#</th>
                    <th>Name</th>
                    <th>Gender</th>
                    <th>Email</th>
                    <th>DeptName</th>
                    <th>操作</th>
                </tr>
                <%--填充数据--%>
                <c:forEach var="emp" items="${pageInfo.list}">
                    <tr>
                        <td>${emp.empId}</td>
                        <td>${emp.empName}</td>
                        <td>${emp.gender=="1"?"男":"女"}</td>
                        <td>${emp.email}</td>
                        <td>${emp.dept.deptName}</td>
                        <td>
                            <button type="button" class="btn btn-info btn-xs">
                                <span class="glyphicon glyphicon-text-size" aria-hidden="true"></span>
                                编辑
                            </button>
                            <button type="button" class="btn btn-warning btn-xs">
                                <span class=" glyphicon glyphicon-remove" aria-hidden="true"></span>
                                删除
                            </button>
                        </td>
                    </tr>
                </c:forEach>
            </table>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12 text-center">
            当前第<span class="label label-primary">${pageInfo.pageNum}</span>页，
            共有<span class="label label-primary">${pageInfo.pages}</span>页，
            总计<span class="label label-primary">${pageInfo.total}</span>条记录
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12 text-center">
            <nav aria-label="Page navigation">
                <ul class="pagination">
                    <li>
                        <a href="${APP_PATH}/list?pageNum=1">
                            <span aria-hidden="true">首页</span>
                        </a>
                    </li>
                    <%--不是第一页才有“上一页”--%>
                    <c:if test="${!pageInfo.isFirstPage}">
                        <li>
                            <a href="${APP_PATH}/list?pageNum=${pageInfo.pageNum - 1}" aria-label="Previous">
                                <span aria-hidden="true">&laquo;</span>
                            </a>
                        </li>
                    </c:if>
                    <c:forEach var="page_Num" items="${pageInfo.navigatepageNums}">
                        <%--如果是当前页，则高亮，且不能点击--%>
                        <c:if test="${page_Num == pageInfo.pageNum}">
                            <li class="active"><span href="${APP_PATH}/list?pageNum=${page_Num}">${page_Num}</span></li>
                        </c:if>
                        <%--如果不是当前页，则正常显示--%>
                        <c:if test="${page_Num != pageInfo.pageNum}">
                            <li><a href="${APP_PATH}/list?pageNum=${page_Num}">${page_Num}</a></li>
                        </c:if>
                    </c:forEach>

                    <%--不是最后一页才有“下一页”--%>
                    <c:if test="${!pageInfo.isLastPage}">
                        <li>
                            <a href="${APP_PATH}/list?pageNum=${pageInfo.pageNum + 1}" aria-label="Next">
                                <span aria-hidden="true">&raquo;</span>
                            </a>
                        </li>
                    </c:if>
                    <li>
                        <a href="${APP_PATH}/list?pageNum=${pageInfo.pages}">
                            <span aria-hidden="true">末页</span>
                        </a>
                    </li>
                </ul>
            </nav>
        </div>
    </div>
</div>
</body>
</html>