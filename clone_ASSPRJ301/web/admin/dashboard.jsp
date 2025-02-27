<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dto.UserDTO"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Homestay</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Arial, sans-serif;
        }

        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            color: #333;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .main-content {
            flex: 1;
            padding: 80px 0;
            max-width: 1200px;
            margin: 0 auto;
            width: 90%;
        }

        .dashboard-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
            padding: 30px;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .dashboard-container:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 35px rgba(0, 0, 0, 0.15);
        }

        h1 {
            font-size: 36px;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 30px;
            text-align: center;
        }

        .menu {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
        }

        .menu-item {
            background: linear-gradient(45deg, #5DC1B9, #4ECDC4);
            color: white;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
            text-decoration: none;
            font-size: 18px;
            font-weight: 600;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            box-shadow: 0 4px 15px rgba(93, 193, 185, 0.4);
        }

        .menu-item:hover {
            transform: scale(1.05);
            box-shadow: 0 6px 20px rgba(93, 193, 185, 0.6);
        }

        .logout-btn {
            display: inline-block;
            margin-top: 40px;
            padding: 12px 25px;
            background: #e74c3c;
            color: white;
            text-decoration: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            transition: background 0.3s ease, transform 0.3s ease;
        }

        .logout-btn:hover {
            background: #c0392b;
            transform: scale(1.05);
        }

        .error-message {
            color: #e74c3c;
            background: #ffebee;
            padding: 15px;
            border-radius: 10px;
            text-align: center;
            margin-bottom: 20px;
        }

        @media (max-width: 768px) {
            .main-content {
                padding: 60px 15px;
            }

            h1 {
                font-size: 28px;
            }

            .menu-item {
                font-size: 16px;
                padding: 15px;
            }

            .logout-btn {
                padding: 10px 20px;
                font-size: 14px;
            }
        }
    </style>
</head>
<body>
    <div class="header-container">
        <%@include file="../header.jsp" %>
    </div>

    <div class="main-content">
        <%
            if (user == null || !"AD".equals(user.getRoleID())) {
                response.sendRedirect(request.getContextPath() + "/login-regis.jsp");
            } else {
        %>
        <div class="dashboard-container">
            <h1>Chào mừng Admin: <%= user.getFullName() %></h1>
            <div class="menu">
                <a href="<%= request.getContextPath() %>/admin/users" class="menu-item">Quản lý người dùng</a>
                <a href="<%= request.getContextPath() %>/admin/rooms" class="menu-item">Quản lý phòng</a>
                <a href="<%= request.getContextPath() %>/admin/bookings" class="menu-item">Quản lý đặt phòng</a>
                <a href="<%= request.getContextPath() %>/admin/statistics" class="menu-item">Thống kê</a>
            </div>
            <a href="<%= request.getContextPath() %>/login?action=logout" class="logout-btn">Đăng xuất</a>
        </div>
        <%
            }
        %>
    </div>

    <div class="footer-container">
        <%@include file="../footer.jsp" %>
    </div>
</body>
</html>