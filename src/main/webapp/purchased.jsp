<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>

<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    //    HttpSession session = request.getSession(false);
    Integer userId = (Integer) session.getAttribute("userId");

    if (userId == null) {
        response.sendRedirect("login.jsp?error=PleaseLogin");
        return;
    }
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
            font-family: Rubik, sans-serif;
            background-color: #121212;
            color: #fff;
        }

        /* Grid container */
        .grid-container {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            padding: 0 1rem;
            gap: 1rem;
            margin: 0 auto;
            max-width: 1200px;
            margin-top: 7rem;
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
            width: auto;
            display: flex;
            flex-direction: column;
            align-content: center;
            justify-content: space-between;
        }

        .grid-item img {
            width: 100%;
            height: auto;
            aspect-ratio: 3/2;
            object-fit: cover;
            display: block;
            border-radius: 4px;
        }

        .grid-item p {
            object-fit: cover;
            display: block;
            color: #aaaaaa;
            padding-top: 1rem;
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
        SELECT images.id, images.name, images.price, purchases.purchase_date
        FROM purchases
        JOIN images ON purchases.image_id = images.id
        WHERE purchases.user_id = ?
        ORDER BY purchases.purchase_date DESC;
        <sql:param value="${userId}"/>
    </sql:query>
    <div class="grid-container">
    <c:forEach var="row" items="${result.rows}">
        <div class="grid-item">
            <a href="img.jsp?id=${row.id}">
                <img src="image?id=${row.id}" alt="${row.name}"/>
                <p>${row.name}</p>
            </a>
        </div>
    </c:forEach>
    </div>
</body>
</html>