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

        /* Remove body padding-top since it's handled by the including page */
        body {
            margin: 0;
        }

        header {
            background: linear-gradient(45deg, #5DC1B9, #4ECDC4); /* Gradient for modern look */
            color: white;
            padding: 10px 50px; /* Reduced padding for a sleeker look */
            position: fixed; /* Keep fixed positioning for consistency */
            top: 0;
            left: 0;
            width: 100%;
            z-index: 1000;
            transition: all 0.3s ease-in-out;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); /* Subtle shadow */
        }

        .container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            max-width: 1200px;
            margin: 0 auto; /* Center the container */
            height: 60px; /* Fixed height for consistency across pages */
        }

        .logo {
            font-family: 'Segoe UI', Arial, sans-serif;
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
            font-family: 'Roboto', Arial, sans-serif;
            font-size: 16px;
            font-weight: 500;
            padding: 8px 12px;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .nav-links a:hover, .nav-links a:focus {
            background: rgba(255, 255, 255, 0.15);
            transform: translateY(-2px);
            outline: none;
        }

        .header-right {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .booking-btn, .logout-btn {
            padding: 8px 18px;
            text-decoration: none;
            border-radius: 8px;
            transition: all 0.3s ease;
            font-family: 'Roboto', Arial, sans-serif;
            font-size: 14px;
            font-weight: 600;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
        }

        .booking-btn {
            background-color: #e74c3c;
            color: white;
        }

        .booking-btn:hover {
            background-color: #ff5e5e;
            transform: scale(1.05);
        }

        .logout-btn {
            background-color: #8e44ad;
            color: white;
        }

        .logout-btn:hover {
            background-color: #9b59b6;
            transform: scale(1.05);
        }

        .user-info {
            display: flex;
            align-items: center;
        }

        .user-name {
            margin-right: 10px;
            font-family: 'Roboto', Arial, sans-serif;
            font-size: 14px;
            font-weight: 500;
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
                padding: 10px 20px; /* Reduced padding for mobile */
            }

            .nav-links {
                display: none;
                flex-direction: column;
                background: linear-gradient(45deg, #5DC1B9, #4ECDC4); /* Match header background */
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

            .booking-btn, .logout-btn {
                padding: 6px 14px;
                font-size: 12px;
            }

            .user-name {
                display: none; /* Hide user name on mobile for space */
            }

            .menu-toggle {
                display: block;
            }

            .container {
                height: 50px; /* Reduced height for mobile */
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
                    <a href="viewBookings" class="booking-btn">Đơn của tôi</a>
                    <a href="login?action=logout" class="logout-btn">Đăng xuất</a>
                </div>
                <% } else { %>
                <a href="login-regis.jsp" class="booking-btn">Đăng nhập</a>
                <% } %>
            </div>
            <div class="menu-toggle">☰</div>
        </div>
    </header>

    <script>
        document.querySelector(".menu-toggle").addEventListener("click", function () {
            document.querySelector(".nav-links").classList.toggle("active");
        });

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