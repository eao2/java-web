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

        .img{
            position: relative;
            z-index: 1;
        }

        img{
            transition: 300ms;
        }

        .img_hover{
            opacity: 0;
            bottom: 4px;
            right: 4px;
            position: absolute;
            width: 1.5rem;
            height: 1.5rem;
            display: flex;
            justify-content: center;
            align-items: start;
            z-index: 2;
            transition: 300ms;
        }

        .img:hover{
            img{
                filter: brightness(0.5);
            }
            .img_hover{
                opacity: 1;
            }
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
    SELECT * FROM images WHERE user_id = ?;
    <sql:param value="${userId}"/>
</sql:query>
<div class="grid-container">
    <c:forEach var="row" items="${result.rows}">
        <div class="grid-item">
            <a href="editImage.jsp?id=${row.id}">
                <div class="img">
                    <img src="image?id=${row.id}" alt="${row.name}"/>
                    <div class="img_hover" >
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512">
                            <path d="M441 58.9L453.1 71c9.4 9.4 9.4 24.6 0 33.9L424 134.1 377.9 88 407 58.9c9.4-9.4 24.6-9.4 33.9 0zM209.8 256.2L344 121.9 390.1 168 255.8 302.2c-2.9 2.9-6.5 5-10.4 6.1l-58.5 16.7 16.7-58.5c1.1-3.9 3.2-7.5 6.1-10.4zM373.1 25L175.8 222.2c-8.7 8.7-15 19.4-18.3 31.1l-28.6 100c-2.4 8.4-.1 17.4 6.1 23.6s15.2 8.5 23.6 6.1l100-28.6c11.8-3.4 22.5-9.7 31.1-18.3L487 138.9c28.1-28.1 28.1-73.7 0-101.8L474.9 25C446.8-3.1 401.2-3.1 373.1 25zM88 64C39.4 64 0 103.4 0 152L0 424c0 48.6 39.4 88 88 88l272 0c48.6 0 88-39.4 88-88l0-112c0-13.3-10.7-24-24-24s-24 10.7-24 24l0 112c0 22.1-17.9 40-40 40L88 464c-22.1 0-40-17.9-40-40l0-272c0-22.1 17.9-40 40-40l112 0c13.3 0 24-10.7 24-24s-10.7-24-24-24L88 64z" fill="#ffffff"/>
                        </svg>
                    </div>
                </div>
                <p>${row.name}</p>
            </a>
        </div>
    </c:forEach>
</div>
</body>
</html>