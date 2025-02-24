<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dto.UserDTO"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Header</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: 'Segoe UI', Arial, sans-serif;
        }

        header {
            background: linear-gradient(45deg, #5DC1B9, #4ECDC4);
            color: white;
            padding: 10px 50px;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            z-index: 1000;
            transition: all 0.3s ease-in-out;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            max-width: 1200px;
            margin: 0 auto;
            height: 60px;
        }

        .logo {
            font-size: 28px;
            font-weight: 700;
            letter-spacing: 1.5px;
            color: #ffffff;
            transition: transform 0.3s ease, color 0.3s ease;
        }

        .logo:hover {
            transform: scale(1.05);
            color: #f8f9fa;
        }

        .nav-links {
            list-style: none;
            display: flex;
            align-items: center;
        }

        .nav-links li {
            margin: 0 15px;
        }

        .nav-links a {
            color: white;
            text-decoration: none;
            font-size: 16px;
            font-weight: 500;
            padding: 8px 12px;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .nav-links a:hover, .nav-links a:focus {
            background: rgba(255, 255, 255, 0.15);
            transform: translateY(-2px);
        }

        .header-right {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .user-info {
            position: relative;
            display: flex;
            align-items: center;
        }

        .user-name {
            margin-right: 10px;
            font-size: 14px;
            font-weight: 500;
            padding: 8px 12px;
            border-radius: 8px;
            cursor: pointer;
            transition: background 0.3s ease;
        }

        .user-name:hover {
            background: rgba(255, 255, 255, 0.15);
        }

        .dropdown-menu {
            display: none;
            position: absolute;
            top: 100%;
            right: 0;
            background: linear-gradient(45deg, #5DC1B9, #4ECDC4);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
            border-radius: 8px;
            list-style: none;
            padding: 10px 0;
            min-width: 180px;
            z-index: 1001;
        }

        .user-info:hover .dropdown-menu {
            display: block;
        }

        .dropdown-menu li {
            margin: 0;
        }

        .dropdown-menu a {
            display: block;
            color: white;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            padding: 10px 20px;
            transition: all 0.3s ease;
        }

        .dropdown-menu a:hover {
            background: rgba(255, 255, 255, 0.2);
            transform: translateX(5px);
        }

        /* Enhanced Login Button Styling */
        .login-btn {
            padding: 8px 20px;
            text-decoration: none;
            border-radius: 25px;
            font-size: 14px;
            font-weight: 600;
            background: linear-gradient(45deg, #ff6b6b, #e74c3c);
            color: white;
            position: relative;
            overflow: hidden;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(231, 76, 60, 0.3);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .login-btn:hover {
            background: linear-gradient(45deg, #ff8787, #ff5e5e);
            transform: scale(1.05) translateY(-2px);
            box-shadow: 0 6px 18px rgba(231, 76, 60, 0.5);
            color: #fff;
        }

        .login-btn::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            background: rgba(255, 255, 255, 0.3);
            border-radius: 50%;
            transform: translate(-50%, -50%);
            transition: width 0.6s ease, height 0.6s ease;
        }

        .login-btn:hover::before {
            width: 200px;
            height: 200px;
        }

        .menu-toggle {
            display: none;
            font-size: 28px;
            cursor: pointer;
            color: white;
            transition: transform 0.3s ease;
        }

        .menu-toggle:hover {
            transform: scale(1.1);
        }

        @media (max-width: 768px) {
            header {
                padding: 10px 20px;
            }

            .nav-links {
                display: none;
                flex-direction: column;
                background: linear-gradient(45deg, #5DC1B9, #4ECDC4);
                position: absolute;
                width: 100%;
                left: 0;
                top: 60px;
                text-align: center;
                padding: 15px 0;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            }

            .nav-links.active {
                display: flex;
            }

            .nav-links li {
                margin: 10px 0;
            }

            .nav-links a {
                display: block;
                padding: 10px 20px;
                font-size: 16px;
            }

            .header-right {
                flex-direction: column;
                align-items: flex-end;
                gap: 5px;
            }

            .user-name {
                display: none;
            }

            .dropdown-menu {
                display: none;
                position: static;
                width: 100%;
                box-shadow: none;
                border-radius: 0;
            }

            .user-info:hover .dropdown-menu {
                display: none;
            }

            .user-info.active .dropdown-menu {
                display: block;
            }

            .login-btn {
                padding: 6px 16px;
                font-size: 12px;
            }

            .menu-toggle {
                display: block;
            }

            .container {
                height: 50px;
            }
        }
    </style>
</head>
<body>
    <header>
        <div class="container">
            <div class="logo">🏡 Homestay</div>
            <nav>
                <ul class="nav-links">
                    <li><a href="home.jsp">Trang chủ</a></li>
                    <li><a href="homestay.jsp">Homestay</a></li>
                    <li><a href="services.jsp">Dịch vụ</a></li>
                    <li><a href="contact.jsp">Liên hệ</a></li>
                </ul>
            </nav>
            <div class="header-right">
                <%
                    UserDTO user = (UserDTO) session.getAttribute("user");
                    if (user != null) {
                %>
                <div class="user-info">
                    <span class="user-name">👋 Xin chào, <%= user.getFullName() %></span>
                    <ul class="dropdown-menu">
                        <li><a href="viewBookings">Đơn của tôi</a></li>
                        <li><a href="profile.jsp">Thông tin cá nhân</a></li>
                        <li><a href="login?action=logout">Đăng xuất</a></li>
                    </ul>
                </div>
                <% } else { %>
                <a href="login-regis.jsp" class="login-btn">Đăng nhập</a>
                <% } %>
            </div>
            <div class="menu-toggle">☰</div>
        </div>
    </header>

    <script>
        // Toggle navigation menu on mobile
        document.querySelector(".menu-toggle").addEventListener("click", function () {
            document.querySelector(".nav-links").classList.toggle("active");
        });

        // Toggle dropdown on mobile click
        const userInfo = document.querySelector(".user-info");
        if (window.innerWidth <= 768 && userInfo) {
            document.querySelector(".user-name").addEventListener("click", function (e) {
                e.preventDefault();
                userInfo.classList.toggle("active");
            });
        }

        // Header shadow on scroll
        window.addEventListener("scroll", function () {
            const header = document.querySelector("header");
            if (window.scrollY > 50) {
                header.style.boxShadow = "0 4px 12px rgba(0, 0, 0, 0.2)";
            } else {
                header.style.boxShadow = "0 2px 10px rgba(0, 0, 0, 0.1)";
            }
        });
    </script>
</body>
</html>