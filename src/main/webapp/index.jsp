<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>

<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    String username = (String) session.getAttribute("username");

//    if (username == null) {
//        response.sendRedirect("login.jsp");
//        return;
//    }
%>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Wallpaper_Site</title>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background-color: #000;
            color: #fff;
        }

        /* Grid container */
        .grid-container {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 10px;
            padding: 20px;
            margin: 0 auto;
            max-width: 960px;
            margin-top: 6.5rem;
            @media (max-width: 1024px) {
                grid-template-columns: repeat(4, 1fr);
            }

            @media (max-width: 768px) {
                grid-template-columns: repeat(3, 1fr);
            }

            @media (max-width: 480px) {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        .grid-item {
            width: 100%;
            position: relative;
            overflow: hidden;
            border: 5px solid #000;
        }

        .grid-item img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }
    </style>
</head>
<body>
<jsp:include page="components/Header.jsp" />
<sql:setDataSource var="dataSource"
                       driver="com.mysql.cj.jdbc.Driver"
                       url="jdbc:mysql://localhost:3306/wallpaper_shop?useSSL=false&serverTimezone=UTC"
                       user="root"
                       password="admin" />

    <sql:query dataSource="${dataSource}" var="result">
        SELECT * FROM images;
    </sql:query>
    <div class="grid-container">
    <c:forEach var="row" items="${result.rows}">
        <div class="grid-item">
            <p>${row.name}</p>
            <img src="image?id=${row.id}" alt="${row.name}" style="max-width: 300px;"/>
        </div>
    </c:forEach>
    </div>
</body>
</html>