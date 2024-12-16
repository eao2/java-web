<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
    <title>Edit Image</title>
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
            padding-top: 3.5rem;
            min-height: 100vh;
        }

        .container {
            width: auto;
            display: grid;
            grid-template-columns: 15rem auto;
            height: calc(100vh - 3.5rem);
        }

        .img_container{
            display: flex;
            justify-content: center;
            align-content: center;
            padding: 1rem;
            min-height: 100%;
        }

        .txt_container{
            padding: 1rem;
            display: flex;
            flex-direction: column;
            align-items: start;
            background-color: #0e0e0e;
        }

        .img{
            max-height: max-content;
            max-width: 100%;
        }

        .lname{
            color: #fff;
        }

        h1 {
            text-align: center;
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 5px;
            font-size: 14px;
            margin-top: 1rem;
        }

        input, button {
            width: 100%;
            padding: 10px;
            border-radius: 8px;
            border: none;
            background-color: #2a2a2a;
            color: #ffffff;
        }

        input::placeholder {
            color: #aaaaaa;
        }

        button {
            background-color: #3a3a3a;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.2s;
            margin-top: 1rem;
        }

        button:hover {
            background-color: #575757;
        }

        p{
            text-align: center;
            font-size: 14px;
        }

        .image-label span {
            color: #aaaaaa;
        }

        @media (max-width: 480px) {
            .container{
                grid-template-columns: 1fr;
            }
        }

        .image-label span {
            color: #aaaaaa;
        }

        .delete{
            background-color: #ff4d4d;
        }

        .delete:hover {
            background-color: #ff2d2d;
        }

        label {
            display: block;
            margin-bottom: 5px;
            font-size: 14px;
            margin-top: 1rem;
        }

        input, button {
            width: 100%;
            padding: 10px;
            border-radius: 8px;
            border: none;
            background-color: #2a2a2a;
            color: #ffffff;
        }

        input::placeholder {
            color: #aaaaaa;
        }

        button {
            background-color: #3a3a3a;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.2s;
            margin-top: 1rem;
        }

        button:hover {
            background-color: #575757;
        }

        form{
            width: 100%;
        }

    </style>
</head>

<sql:setDataSource var="dataSource"
                   driver="com.mysql.cj.jdbc.Driver"
                   url="jdbc:mysql://localhost:3306/wallpaper_shop?useSSL=false&serverTimezone=UTC"
                   user="root"
                   password="admin" />

<sql:query var="imageData" dataSource="${dataSource}">
    SELECT id, name, tags, price FROM images WHERE id = ? AND user_id = ?
    <sql:param value="${param.id}" />
    <sql:param value="${userId}" />
</sql:query>

<jsp:include page="components/Header.jsp" />
<body>
<main>
    <section class="container">
        <c:choose>
            <c:when test="${not empty imageData.rows}">
                <c:set var="image" value="${imageData.rows[0]}" />
                <div class="txt_container">
                    <form action="updateImage" method="post">
                        <input type="hidden" name="id" value="${image.id}" />

                        <label for="name">Name:</label>
                        <input type="text" id="name" name="name" value="${image.name}" required /><br />

                        <label for="tags">Tags:</label>
                        <input type="text" id="tags" name="tags" value="${image.tags}" /><br />

                        <label for="price">Price:</label>
                        <input type="number" id="price" name="price" value="${image.price}" step="0.01" /><br />

                        <button type="submit">Save Changes</button>
                    </form>
                    <form action="deleteImage" method="post" style="display:inline;">
                        <input type="hidden" name="id" value="${image.id}">
                        <button type="submit" class="delete">Delete</button>
                    </form>
                </div>
                <div class="img_container">
                    <img
                        class="img"
                        src="image?res=medium&id=${image.id}"
                    />
                </div>
            </c:when>
            <c:otherwise>
                <p>Error: Image not found or you do not have permission to edit this image.</p>
            </c:otherwise>
        </c:choose>
    </section>
</main>
</body>
</html>
