<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Your Cart</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        body {
            background-color: #121212;
            color: #ffffff;
        }

        main{
            min-height: 100vh;
            padding-top: 4.5rem;
            min-height: 100vh;
        }

        table{
            outline: none;
            border: none;
            width: 100%;
        }

        button {
            outline: none;
            border: none;
            background-color: #3a3a3a;
            color: #ffffff;
            width: 100%;
            height: 100%;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.2s;
        }

        .container {
            width: auto;
            display: grid;
            grid-template-columns: 15rem auto;
            height: calc(100vh - 3.5rem);
        }

        .grid-container {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            padding: 0 1rem;
            gap: 1rem;
            margin: 0 auto;
            max-width: 1200px;
            margin-top: 0;
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

        .purchase_button{
            margin-top: 1rem;
            border-radius: 1rem;
            background-color: #2f2f2f;
            padding: 1rem 1.5rem;
        }
    </style>
</head>
<body>

<jsp:include page="components/Header.jsp" />
<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<sql:setDataSource var="dataSource" driver="com.mysql.cj.jdbc.Driver"
                   url="jdbc:mysql://localhost:3306/wallpaper_shop"
                   user="root" password="admin"/>

<sql:query var="cartItems" dataSource="${dataSource}">
    SELECT images.id, images.name, images.price
    FROM cart
    JOIN images ON cart.image_id = images.id
    WHERE cart.user_id = ?
    <sql:param value="${userId}"/>
</sql:query>

<main>
    <div class="grid-container">
        <c:forEach var="row" items="${cartItems.rows}">
            <div class="grid-item">
                <a href="img.jsp?id=${row.id}">
                    <img src="image?id=${row.id}" alt="${row.name}"/>
                    <p>${row.name}</p>
                    <form action="purchase" method="post">
                        <input type="hidden" name="userId" value="<%= userId %>">
                        <input type="hidden" name="imageId" value="${item.id}">
                        <input type="hidden" name="price" value="${item.price}">
                        <button class="purchase_button" type="submit">Purchase</button>
                    </form>
                </a>
            </div>
        </c:forEach>
    </div>
</main>
</body>
</html>