<%--
  Created by IntelliJ IDEA.
  User: EA
  Date: 12/6/2024
  Time: 12:57 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String username = (String) session.getAttribute("username");
%>
<heaad>
  <style>

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
  </style>
</heaad>
<header>
  <div class="navbar">
    <div class="links">
      <a href="/upload-image.jsp">Upload</a>
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

