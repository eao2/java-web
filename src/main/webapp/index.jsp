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

        /* Navbar */
        header{
            background-color: #1e1e1e;
            width: 100vw;
            position: fixed;
            top: 0;
            left: 0;
            z-index: 100;
        }
        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0px;
            max-width: 960px;
            height: 5rem;
            margin: auto;
        }

        .navbar a {
            color: #fff;
            text-decoration: none;
            margin: 0 15px;
            font-size: 16px;
        }

        .navbar .logout {
            color: #ff4d4d;
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

    <header>
    <div class="navbar">
        <div class="links">
            <a href="#">Latest</a>
            <a href="#">Toplist</a>
            <a href="#">Random</a>
            <a href="#">Upload</a>
            <a href="#">Forums</a>
        </div>
        <div class="user">
            <% if (username == null) { %>
            <a class="login" href="login.jsp">Login</a>
            <% } else { %>
            <span><%= username %></span> <a class="logout" href="logout.jsp">Logout</a>
            <% } %>

        </div>
    </div>
        </header>
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