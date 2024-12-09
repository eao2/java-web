<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%--
  Created by IntelliJ IDEA.
  User: EA
  Date: 11/14/2024
  Time: 12:40 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <style>
        /* styles.css */

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        body {
            background-color: #121212;
            color: #ffffff;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .login-container {
            background-color: #1e1e1e;
            padding: 20px;
            width: 300px;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
            margin: 1rem 1.5rem;
        }

        h2 {
            text-align: center;
            margin-bottom: 20px;
        }

        .input-group {
            margin-bottom: 15px;
        }

        label {
            display: block;
            margin-bottom: 5px;
            font-size: 14px;
        }

        input {
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

        .login-btn {
            width: 100%;
            padding: 10px;
            background-color: #3a3a3a;
            border: none;
            border-radius: 8px;
            color: #ffffff;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.2s;
        }

        .login-btn:hover {
            background-color: #575757;
        }

        p {
            text-align: center;
            font-size: 14px;
            margin-top: 10px;
        }

        a {
            color: #1e90ff;
            text-decoration: none;
        }

        a:hover {
            text-decoration: underline;
        }

    </style>
</head>
<body>
<div class="login-container">
    <h2>Update password</h2>
    <form action="UpdateServlet" method="post">
        <div class="input-group">
            <label for="username">Username:</label>
            <input type="text" id="username" name="username" required>
        </div>
        <div class="input-group">
            <label for="email">Email:</label>
            <input type="email" id="email" name="email" required>
        </div>
        <div class="input-group">
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required>
        </div>
        <button type="submit" class="login-btn">Update</button>
    </form>
    <p>Don't have an account? <a href="signup.jsp">Sign Up</a></p>
    <p>If you have an account? <a href="login.jsp">Login</a></p>
    <c:if test="${param.error != null && param.error == 'userNotFound'}">
        <p style="color:red;">User not found. Please check your username and email.</p>
    </c:if>
    <c:if test="${param.error != null && param.error == 'updateFailed'}">
        <p style="color:red;">Failed to update the password. Please try again.</p>
    </c:if>
    <c:if test="${param.error != null && param.error == 'sqlError'}">
        <p style="color:red;">An error occurred. Please contact support.</p>
    </c:if>


</div>
</body>
</html>
