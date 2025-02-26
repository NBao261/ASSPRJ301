<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dto.UserDTO"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Cập nhật thông tin cá nhân</title>
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
            background: linear-gradient(135deg, #f0f4f8 0%, #d9e6f2 100%);
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            margin: 0;
        }

        .header-container {
            width: 100%;
            position: fixed;
            top: 0;
            left: 0;
            z-index: 1000;
        }

        .footer-container {
            width: 100%;
            position: fixed;
            bottom: 0;
            left: 0;
            z-index: 999;
        }

        .main-content {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 60px 20px;
            width: 100%;
            overflow: auto;
        }

        .form-container {
            max-width: 520px;
            width: 100%;
            padding: 35px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .form-container:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.15);
        }

        h2 {
            font-size: 28px;
            font-weight: 600;
            color: #2c3e50;
            text-align: center;
            margin-bottom: 25px;
            position: relative;
        }

        h2::after {
            content: "";
            display: block;
            width: 50px;
            height: 3px;
            background: #5DC1B9;
            margin: 10px auto 0;
            border-radius: 2px;
        }

        .form-group {
            position: relative;
            margin-bottom: 20px;
        }

        label {
            font-weight: 500;
            color: #555;
            font-size: 14px;
            margin-bottom: 8px;
            display: block;
        }

        input[type="text"], input[type="email"] {
            width: 100%;
            padding: 12px 15px 12px 38px;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
            background: #f9f9f9;
            transition: all 0.3s ease;
        }

        input[type="file"] {
            width: 100%;
            padding: 12px;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
            background: #f9f9f9;
            transition: all 0.3s ease;
        }

        input:focus {
            border-color: #5DC1B9;
            background: white;
            box-shadow: 0 0 6px rgba(93, 193, 185, 0.2);
            outline: none;
        }

        .form-group i {
            position: absolute;
            top: 70%;
            left: 12px;
            transform: translateY(-50%);
            color: #888;
            font-size: 16px;
            transition: color 0.3s ease;
        }

        .form-group input:focus + i {
            color: #5DC1B9;
        }

        button {
            background: linear-gradient(45deg, #5DC1B9, #4ECDC4);
            color: white;
            padding: 12px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            width: 100%;
            font-size: 16px;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(93, 193, 185, 0.3);
        }

        button:hover {
            background: linear-gradient(45deg, #4ECDC4, #45b7d1);
            transform: scale(1.03);
            box-shadow: 0 6px 18px rgba(93, 193, 185, 0.5);
        }

        .message {
            padding: 10px 15px;
            margin-bottom: 15px;
            border-radius: 8px;
            font-size: 14px;
            text-align: center;
        }

        .message.success {
            background: #e8f5e9;
            color: #27ae60;
            border: 1px solid #27ae60;
        }

        .message.error {
            background: #ffebee;
            color: #e74c3c;
            border: 1px solid #e74c3c;
        }

        .current-avatar {
            margin-top: 15px;
            text-align: center;
            padding: 10px;
            background: #f9f9f9;
            border-radius: 8px;
            border: 1px solid #e0e0e0;
        }

        .current-avatar img {
            max-width: 80px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        .current-avatar span {
            display: block;
            margin-top: 5px;
            font-size: 12px;
            color: #666;
        }

        @media (max-width: 768px) {
            .form-container {
                margin: 60px auto;
                padding: 20px;
            }
            h2 {
                font-size: 24px;
            }
            input[type="text"], input[type="email"], input[type="file"] {
                padding: 10px 15px 10px 35px;
                font-size: 13px;
            }
            .form-group i {
                left: 10px;
                font-size: 14px;
            }
            button {
                padding: 10px;
                font-size: 14px;
            }
            .current-avatar {
                margin-top: 10px;
                padding: 8px;
            }
            .current-avatar img {
                max-width: 60px;
            }
        }
    </style>
</head>
<body>
    <div class="header-container">
        <%@include file="header.jsp" %>
    </div>

    <div class="main-content">
        <div class="form-container">
            <h2>Cập nhật thông tin cá nhân</h2>
            <%
                String successMessage = (String) request.getAttribute("successMessage");
                String errorMessage = (String) request.getAttribute("errorMessage");
                if (user != null) {
            %>
            <% if (successMessage != null) { %>
                <div class="message success"><%= successMessage %></div>
            <% } %>
            <% if (errorMessage != null) { %>
                <div class="message error"><%= errorMessage %></div>
            <% } %>
            <form action="updateProfile" method="post" enctype="multipart/form-data">
                <input type="hidden" name="userId" value="<%= user.getUserID() %>">
                <div class="form-group">
                    <label for="fullName">Họ và tên:</label>
                    <input type="text" id="fullName" name="fullName" value="<%= user.getFullName() != null ? user.getFullName() : "" %>">
                    <i class="fas fa-id-card"></i>
                    <% if (request.getAttribute("errorFullName") != null) { %>
                        <div class="message error"><%= request.getAttribute("errorFullName") %></div>
                    <% } %>
                </div>
                <div class="form-group">
                    <label for="gmail">Gmail:</label>
                    <input type="email" id="gmail" name="gmail" value="<%= user.getGmail() != null ? user.getGmail() : "" %>">
                    <i class="fas fa-envelope"></i>
                    <% if (request.getAttribute("errorGmail") != null) { %>
                        <div class="message error"><%= request.getAttribute("errorGmail") %></div>
                    <% } %>
                </div>
                <div class="form-group">
                    <label for="sdt">Số điện thoại:</label>
                    <input type="text" id="sdt" name="sdt" value="<%= user.getSdt() != null ? user.getSdt() : "" %>">
                    <i class="fas fa-phone"></i>
                    <% if (request.getAttribute("errorSdt") != null) { %>
                        <div class="message error"><%= request.getAttribute("errorSdt") %></div>
                    <% } %>
                </div>
                <div class="form-group">
                    <label for="avatar">Avatar:</label>
                    <input type="file" id="avatar" name="avatar" accept="image/*">
                    <% if (request.getAttribute("errorAvatar") != null) { %>
                        <div class="message error"><%= request.getAttribute("errorAvatar") %></div>
                    <% } %>
                    <% if (user.getAvatarUrl() != null && !user.getAvatarUrl().isEmpty()) { %>
                        <div class="current-avatar">
                            <img src="<%= user.getAvatarUrl() %>" alt="Avatar hiện tại">
                            <span>Avatar hiện tại</span>
                        </div>
                    <% } else { %>
                        <div class="current-avatar">
                            <span>Không có avatar</span>
                        </div>
                    <% } %>
                </div>
                <button type="submit">Cập nhật</button>
            </form>
            <% } else { %>
                <p style="text-align: center; color: #e74c3c;">Vui lòng đăng nhập để cập nhật thông tin.</p>
            <% } %>
        </div>
    </div>

    <div class="footer-container">
        <%@include file="footer.jsp" %>
    </div>
</body>
</html>