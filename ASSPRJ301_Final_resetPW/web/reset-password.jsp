<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Đặt lại mật khẩu</title>
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

        .reset-password-container {
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
            margin-bottom: 25px;
        }

        .form-group label {
            font-weight: 600;
            color: #444;
            font-size: 16px;
            margin-bottom: 8px;
            display: block;
        }

        .input-container {
            position: relative;
            width: 100%;
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

        .input-container i {
            position: absolute;
            top: 50%;
            left: 15px;
            transform: translateY(-50%);
            color: #888;
            font-size: 16px;
            z-index: 1;
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

        .message {
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            text-align: center;
            font-weight: 500;
            font-size: 14px;
        }

        .error-message {
            background: #ffebee;
            color: #e74c3c;
        }

        .success-message {
            background: #e8f5e9;
            color: #27ae60;
        }
    </style>
</head>
<body>
    <%@include file="header.jsp" %>

    <div class="reset-password-container">
        <div class="form-wrapper">
            <h2 class="form-title">Đặt lại mật khẩu</h2>
            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="message error-message"><%= request.getAttribute("errorMessage") %></div>
            <% } %>
            <% if (request.getAttribute("successMessage") != null) { %>
                <div class="message success-message"><%= request.getAttribute("successMessage") %></div>
            <% } else { %>
                <form action="resetPassword" method="post">
                    <input type="hidden" name="token" value="<%= request.getAttribute("token") %>">
                    <div class="form-group">
                        <label for="newPassword">Mật khẩu mới</label>
                        <div class="input-container">
                            <input type="password" id="newPassword" name="newPassword" required />
                            <i class="fas fa-lock"></i>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="confirmPassword">Xác nhận mật khẩu</label>
                        <div class="input-container">
                            <input type="password" id="confirmPassword" name="confirmPassword" required />
                            <i class="fas fa-lock"></i>
                        </div>
                    </div>
                    <button type="submit" class="submit-btn">Đặt lại mật khẩu</button>
                </form>
            <% } %>
            <p class="switch-form"><a href="login-regis.jsp">Quay lại đăng nhập</a></p>
        </div>
    </div>

    <%@include file="footer.jsp" %>
</body>
</html>