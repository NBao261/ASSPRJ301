<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Đăng nhập & Đăng ký</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        .login-container {
            display: flex;
            justify-content: center;
            align-items: center;
            flex-grow: 1;
            padding: 40px 20px;
            width: 100%;
        }

        .form-wrapper {
            background: white;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.15);
            width: 100%;
            max-width: 450px;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .form-wrapper:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.2);
        }

        .form-title {
            font-size: 32px;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 30px;
            text-align: center;
            position: relative;
        }

        .form-title::after {
            content: "";
            display: block;
            width: 60px;
            height: 4px;
            background: #5DC1B9;
            margin: 10px auto 0;
            border-radius: 2px;
        }

        .form-group {
            position: relative;
            margin-bottom: 25px;
        }

        .form-group label {
            font-weight: 600;
            color: #444;
            font-size: 16px;
            margin-bottom: 8px;
            display: block;
        }

        .form-group input {
            width: 100%;
            padding: 14px 15px 14px 40px;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            font-size: 16px;
            background: #f9f9f9;
            transition: all 0.3s ease;
        }

        .form-group input:focus {
            border-color: #5DC1B9;
            background: white;
            box-shadow: 0 0 8px rgba(93, 193, 185, 0.3);
            outline: none;
        }

        .form-group i {
            position: absolute;
            top: 62%;
            left: 15px;
            transform: translateY(-50%);
            color: #888;
            font-size: 16px;
            transition: color 0.3s ease;
        }

        .form-group input:focus + i {
            color: #5DC1B9;
        }

        .submit-btn {
            background: linear-gradient(45deg, #5DC1B9, #4ECDC4);
            color: white;
            padding: 14px;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            width: 100%;
            font-size: 18px;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(93, 193, 185, 0.4);
        }

        .submit-btn:hover {
            background: linear-gradient(45deg, #4ECDC4, #45b7d1);
            transform: scale(1.05);
            box-shadow: 0 8px 20px rgba(93, 193, 185, 0.6);
        }

        .switch-form {
            margin-top: 20px;
            font-size: 14px;
            color: #666;
            text-align: center;
        }

        .switch-form a {
            color: #5DC1B9;
            font-weight: 600;
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .switch-form a:hover {
            color: #4BAA9F;
        }

        .hidden {
            display: none;
        }

        .error-message {
            color: #e74c3c;
            font-size: 14px;
            margin-top: 5px;
            text-align: left;
        }

        .success-message {
            color: #27ae60;
            font-size: 14px;
            margin-top: 5px;
            text-align: center;
        }
    </style>
</head>
<body>
    <%@include file="header.jsp" %> 

    <div class="login-container">
        <!-- Form đăng nhập -->
        <div class="form-wrapper" id="loginForm">
            <h2 class="form-title">Đăng nhập</h2>
            <form action="login" method="post">
                <input type="hidden" name="action" value="login" />
                <div class="form-group">
                    <label for="userId">Tên đăng nhập</label>
                    <input type="text" id="userId" name="txtUsername" required />
                    <i class="fas fa-user"></i>
                    <% if (request.getAttribute("errorUsername") != null) {%>
                        <p class="error-message"><%= request.getAttribute("errorUsername")%></p>
                    <% } %>
                </div>
                <div class="form-group">
                    <label for="password">Mật khẩu</label>
                    <input type="password" id="password" name="txtPassword" required />
                    <i class="fas fa-lock"></i>
                    <% if (request.getAttribute("errorPassword") != null) {%>
                        <p class="error-message"><%= request.getAttribute("errorPassword")%></p>
                    <% } %>
                </div>
                <button type="submit" class="submit-btn">Đăng nhập</button>
                <% if (request.getAttribute("errorMessage") != null) {%>
                    <p class="error-message"><%= request.getAttribute("errorMessage")%></p>
                <% } %>
            </form>
            <p class="switch-form">Chưa có tài khoản? <a href="#" onclick="showRegister()">Đăng ký ngay</a></p>
        </div>

        <!-- Form đăng ký -->
        <div class="form-wrapper <%= request.getAttribute("showRegisterForm") != null && (boolean) request.getAttribute("showRegisterForm") ? "" : "hidden"%>" id="registerForm">
            <h2 class="form-title">Đăng ký</h2>
            <form action="register" method="post">
                <div class="form-group">
                    <label for="newUsername">Tên đăng nhập</label>
                    <input type="text" id="newUsername" name="txtNewUsername" value="<%= request.getParameter("txtNewUsername") != null ? request.getParameter("txtNewUsername") : ""%>" required />
                    <i class="fas fa-user"></i>
                    <% if (request.getAttribute("errorNewUsername") != null) {%>
                        <p class="error-message"><%= request.getAttribute("errorNewUsername")%></p>
                    <% } %>
                </div>
                <div class="form-group">
                    <label for="fullName">Họ và tên</label>
                    <input type="text" id="fullName" name="txtFullName" value="<%= request.getParameter("txtFullName") != null ? request.getParameter("txtFullName") : ""%>" required />
                    <i class="fas fa-id-card"></i>
                    <% if (request.getAttribute("errorFullName") != null) {%>
                        <p class="error-message"><%= request.getAttribute("errorFullName")%></p>
                    <% } %>
                </div>
                <div class="form-group">
                    <label for="gmail">Gmail</label>
                    <input type="email" id="gmail" name="txtGmail" value="<%= request.getParameter("txtGmail") != null ? request.getParameter("txtGmail") : ""%>" />
                    <i class="fas fa-envelope"></i>
                    <% if (request.getAttribute("errorGmail") != null) {%>
                        <p class="error-message"><%= request.getAttribute("errorGmail")%></p>
                    <% } %>
                </div>
                <div class="form-group">
                    <label for="sdt">Số điện thoại</label>
                    <input type="text" id="sdt" name="txtSdt" value="<%= request.getParameter("txtSdt") != null ? request.getParameter("txtSdt") : ""%>" />
                    <i class="fas fa-phone"></i>
                    <% if (request.getAttribute("errorSdt") != null) {%>
                        <p class="error-message"><%= request.getAttribute("errorSdt")%></p>
                    <% } %>
                </div>
                <div class="form-group">
                    <label for="newPassword">Mật khẩu</label>
                    <input type="password" id="newPassword" name="txtNewPassword" required />
                    <i class="fas fa-lock"></i>
                    <% if (request.getAttribute("errorNewPassword") != null) {%>
                        <p class="error-message"><%= request.getAttribute("errorNewPassword")%></p>
                    <% } %>
                </div>
                <div class="form-group">
                    <label for="confirmPassword">Nhập lại mật khẩu</label>
                    <input type="password" id="confirmPassword" name="txtConfirmPassword" required />
                    <i class="fas fa-lock"></i>
                    <% if (request.getAttribute("errorConfirmPassword") != null) {%>
                        <p class="error-message"><%= request.getAttribute("errorConfirmPassword")%></p>
                    <% } %>
                </div>
                <button type="submit" class="submit-btn">Đăng ký</button>
                <% if (request.getAttribute("errorMessage") != null) {%>
                    <p class="error-message"><%= request.getAttribute("errorMessage")%></p>
                <% } %>
                <% if (request.getAttribute("successMessage") != null) {%>
                    <p class="success-message"><%= request.getAttribute("successMessage")%></p>
                <% } %>
            </form>
            <p class="switch-form">Đã có tài khoản? <a href="#" onclick="showLogin()">Đăng nhập</a></p>
        </div>
    </div>

    <%@include file="footer.jsp" %> 

    <script>
        function showRegister() {
            document.getElementById("loginForm").classList.add("hidden");
            document.getElementById("registerForm").classList.remove("hidden");
        }

        function showLogin() {
            document.getElementById("registerForm").classList.add("hidden");
            document.getElementById("loginForm").classList.remove("hidden");
        }

        window.onload = function () {
            <% if (request.getAttribute("showRegisterForm") != null && (boolean) request.getAttribute("showRegisterForm")) { %>
                showRegister();
            <% } else { %>
                showLogin();
            <% } %>
        };
    </script>
</body>
</html>