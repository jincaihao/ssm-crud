<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">

<head>
    <meta charset="UTF-8">
    <title>首页</title>
</head>
<body>
    <jsp:forward page="/list"></jsp:forward>
    <%--<a th:href="@{/list}">列表</a>--%>
</body>
</html>