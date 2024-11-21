<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    String username = (String) session.getAttribute("username");

    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Grid Layout with Images</title>
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

    <!-- Navbar -->
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
            <span><%= username %></span> <a class="logout" href="logout.jsp">Logout</a>
        </div>
    </div>
        </header>


    <!-- Grid container -->
    <div class="grid-container">
        <div class="grid-item"><img src="https://picsum.photos/200/300?random=1" alt="Random Image 1"></div>
        <div class="grid-item"><img src="https://picsum.photos/200/300?random=2" alt="Random Image 2"></div>
        <div class="grid-item"><img src="https://picsum.photos/200/300?random=3" alt="Random Image 3"></div>
        <div class="grid-item"><img src="https://picsum.photos/200/300?random=4" alt="Random Image 4"></div>
        <div class="grid-item"><img src="https://picsum.photos/200/300?random=5" alt="Random Image 5"></div>
        <div class="grid-item"><img src="https://picsum.photos/200/300?random=6" alt="Random Image 6"></div>
        <div class="grid-item"><img src="https://picsum.photos/200/300?random=7" alt="Random Image 7"></div>
        <div class="grid-item"><img src="https://picsum.photos/200/300?random=8" alt="Random Image 8"></div>
        <div class="grid-item"><img src="https://picsum.photos/200/300?random=9" alt="Random Image 9"></div>
        <div class="grid-item"><img src="https://picsum.photos/200/300?random=10" alt="Random Image 10"></div>
        <div class="grid-item"><img src="https://picsum.photos/200/300?random=11" alt="Random Image 11"></div>
        <div class="grid-item"><img src="https://picsum.photos/200/300?random=12" alt="Random Image 12"></div>
        <div class="grid-item"><img src="https://picsum.photos/200/300?random=13" alt="Random Image 13"></div>
        <div class="grid-item"><img src="https://picsum.photos/200/300?random=14" alt="Random Image 14"></div>
        <div class="grid-item"><img src="https://picsum.photos/200/300?random=15" alt="Random Image 15"></div>
        <div class="grid-item"><img src="https://picsum.photos/200/300?random=16" alt="Random Image 16"></div>
        <div class="grid-item"><img src="https://picsum.photos/200/300?random=17" alt="Random Image 17"></div>
        <div class="grid-item"><img src="https://picsum.photos/200/300?random=18" alt="Random Image 18"></div>
        <div class="grid-item"><img src="https://picsum.photos/200/300?random=19" alt="Random Image 19"></div>
        <div class="grid-item"><img src="https://picsum.photos/200/300?random=20" alt="Random Image 20"></div>
        <div class="grid-item"><img src="https://picsum.photos/200/300?random=21" alt="Random Image 21"></div>
        <div class="grid-item"><img src="https://picsum.photos/200/300?random=22" alt="Random Image 22"></div>
        <div class="grid-item"><img src="https://picsum.photos/200/300?random=23" alt="Random Image 23"></div>
        <div class="grid-item"><img src="https://picsum.photos/200/300?random=24" alt="Random Image 24"></div>
        <div class="grid-item"><img src="https://picsum.photos/200/300?random=25" alt="Random Image 25"></div>
    </div>

</body>
</html>
