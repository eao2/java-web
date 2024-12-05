<%--
  Created by IntelliJ IDEA.
  User: EA
  Date: 12/5/2024
  Time: 2:46 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Upload Image</title>
</head>
<body>
<h1>Upload an Image</h1>
<form action="uploadImage" method="post" enctype="multipart/form-data">
    <label for="name">Image Name:</label>
    <input type="text" id="name" name="name" required><br><br>

    <label for="tags">Tags (comma-separated):</label>
    <input type="text" id="tags" name="tags" required><br><br>

    <label for="price">Price:</label>
    <input type="number" id="price" name="price" step="0.01" required><br><br>

    <label for="image">Select Image:</label>
    <input type="file" id="image" name="image" accept="image/*" required><br><br>

    <button type="submit">Upload</button>
</form>

<c:if test="${param.error != null}">
    <p style="color:red;">${param.error}</p>
</c:if>
<c:if test="${param.success != null}">
    <p style="color:green;">${param.success}</p>
</c:if>
</body>
</html>