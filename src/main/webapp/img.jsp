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
            gap: 1rem;
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

        button{
            background-color: #3a3a3a;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.2s;
            margin-top: 1rem;
        }

        .download-button{
            padding: 1rem 1.5rem;
            width: 100%;
            text-decoration: none;
            padding-top: 1rem;
            background-color: #3a3a3a;
            color: white;
            border-radius: 1rem;
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
    </style>
</head>

<sql:setDataSource var="dataSource"
                   driver="com.mysql.cj.jdbc.Driver"
                   url="jdbc:mysql://localhost:3306/wallpaper_shop?useSSL=false&serverTimezone=UTC"
                   user="root"
                   password="admin" />

<sql:query var="imageData" dataSource="${dataSource}">
    SELECT id, name, tags, price, user_id FROM images WHERE id = ?
    <sql:param value="${param.id}" />
</sql:query>

<sql:query var="userData" dataSource="${dataSource}">
    SELECT username FROM users WHERE id = ?
    <sql:param value="${imageData.rows[0].user_id}" />
</sql:query>

<sql:query var="purchaseData" dataSource="${dataSource}">
    SELECT COUNT(*) AS purchaseCount
    FROM purchases
    WHERE user_id = ? AND image_id = ?
    <sql:param value="${userId}" />
    <sql:param value="${param.id}" />
</sql:query>

<jsp:include page="components/Header.jsp" />
<body>
<main>
    <section class="container">
        <c:choose>
            <c:when test="${not empty imageData.rows}">
                <c:set var="image" value="${imageData.rows[0]}" />
                <div class="txt_container">
                    <h3><span class="lname">Username: </span>${userData.rows[0].username}</h3>

                    <h3><span class="lname">Name: </span>${image.name}</h3>

                    <h5><span class="lname">Tags: </span>${image.tags}</h5>

                    <p><span class="lname">Price: </span>${image.price}</p>

                    <div>
                        <c:choose>
                            <c:when test="${not empty purchaseData.rows and purchaseData.rows[0].purchaseCount > 0}">
                                <a href="image?res=high&id=${image.id}" download>
                                    <div class="download-button">
                                        Download
                                    </div>
                                </a>
                            </c:when>
                            <c:otherwise>
                                <form action="/add-to-cart" method="post">
                                    <input type="number" value="${userId}" hidden name="userId"/>
                                    <input type="number" value="${image.id}" hidden name="imageId"/>
                                    <button type="submit">Add to Cart</button>
                                </form>
                            </c:otherwise>
                        </c:choose>
                    </div>
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
