<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%--
  Created by IntelliJ IDEA.
  User: EA
  Date: 12/5/2024
  Time: 2:46 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
    <title>Upload Image</title>
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
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .upload-container {
            background-color: #1e1e1e;
            padding: 20px;
            width: 350px;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
            margin: 1rem 1.5rem;
        }

        h1 {
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
        }

        button:hover {
            background-color: #575757;
        }

        p {
            text-align: center;
            font-size: 14px;
            margin-top: 10px;
        }

        .message {
            text-align: center;
            font-size: 14px;
            margin-top: 10px;
        }

        .message.error {
            color: red;
        }

        .message.success {
            color: green;
        }

        .image-label {
            height: 15rem;
            width: 100%;
            border: 2px dashed #575757;
            border-radius: 1rem;
            display: flex;
            justify-content: center;
            align-items: center;
            text-align: center;
            cursor: pointer;
            transition: background-color 0.2s;
        }

        .image-label.dragover {
            background-color: #3a3a3a;
        }

        .image-label span {
            color: #aaaaaa;
        }
    </style>
</head>
<body>
<jsp:include page="components/Header.jsp" />
<div class="upload-container">
    <h1>Upload an Image</h1>
    <form action="uploadImage" method="post" enctype="multipart/form-data">
        <div class="input-group">
            <label for="name">Image Name:</label>
            <input type="text" id="name" name="name" placeholder="Enter image name" required>
        </div>

        <div class="input-group">
            <label for="tags">Tags (comma-separated):</label>
            <input type="text" id="tags" name="tags" placeholder="e.g., nature, landscape" required>
        </div>

        <div class="input-group">
            <label for="price">Price:</label>
            <input type="number" id="price" name="price" placeholder="Enter price" step="0.01" required>
        </div>

        <div class="input-group">
            <label for="image">Select Image:</label>
            <div class="image-label" id="dropzone">
                <span>Drag & Drop your image here or click to upload</span>
            </div>
            <input type="file" id="image" name="image" accept="image/*" required style="display: none;">
        </div>

        <button type="submit">Upload</button>
    </form>

    <c:if test="${param.error != null}">
        <p class="message error">${param.error}</p>
    </c:if>
    <c:if test="${param.success != null}">
        <p class="message success">${param.success}</p>
    </c:if>
</div>

<script>
    const dropzone = document.getElementById('dropzone');
    const fileInput = document.getElementById('image');

    // Click event to open file input dialog
    dropzone.addEventListener('click', () => {
        fileInput.click();
    });

    // Drag over event to highlight dropzone
    dropzone.addEventListener('dragover', (event) => {
        event.preventDefault();
        dropzone.classList.add('dragover');
    });

    // Drag leave event to remove highlight
    dropzone.addEventListener('dragleave', () => {
        dropzone.classList.remove('dragover');
    });

    // Drop event to handle file selection
    dropzone.addEventListener('drop', (event) => {
        event.preventDefault();
        dropzone.classList.remove('dragover');

        if (event.dataTransfer.files.length) {
            fileInput.files = event.dataTransfer.files;

            // Display file name in dropzone
            dropzone.querySelector('span').textContent = event.dataTransfer.files[0].name;
        }
    });

    // Update dropzone text when file is selected via dialog
    fileInput.addEventListener('change', () => {
        if (fileInput.files.length) {
            dropzone.querySelector('span').textContent = fileInput.files[0].name;
        }
    });
</script>
</body>
</html>
