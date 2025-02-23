<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dto.UserDTO"%>

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
                <span class="user-name">👋 Xin chào, <%= user.getFullName()%></span>
                <a href="viewBookings" class="booking-btn">Đơn của tôi</a>
                <a href="login?action=logout" class="logout-btn">Đăng xuất</a>
            </div>
            <% } else { %>
            <a href="login-regis.jsp" class="booking-btn">Đăng nhập</a>
            <% }%>
        </div>
        <div class="menu-toggle">&#9776;</div>
    </div>
</header>

<style>
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    header {
        background: #5DC1B9;
        color: white;
        padding: 15px 50px;
        position: sticky;
        top: 0;
        width: 100%;
        z-index: 1000;
        transition: all 0.3s ease-in-out;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
    }

    .container {
        display: flex;
        justify-content: space-between;
        align-items: center;
        max-width: 1200px;
        margin: auto;
    }

    .logo {
        font-size: 26px;
        font-weight: bold;
        letter-spacing: 1px;
        transition: transform 0.3s ease-in-out;
    }

    .logo:hover {
        transform: scale(1.1);
    }

    .nav-links {
        list-style: none;
        display: flex;
    }

    .nav-links li {
        margin: 0 15px;
    }

    .nav-links a {
        color: white;
        text-decoration: none;
        font-size: 18px;
        padding: 10px 15px;
        border-radius: 5px;
        transition: all 0.3s ease;
    }

    .nav-links a:hover {
        background: rgba(255, 255, 255, 0.2);
        transform: translateY(-2px);
    }

    .header-right {
        display: flex;
        align-items: center;
    }

    .booking-btn, .logout-btn {
        padding: 10px 20px;
        text-decoration: none;
        border-radius: 5px;
        transition: all 0.3s ease;
        font-size: 16px;
        font-weight: bold;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
    }

    .booking-btn {
        background-color: #e74c3c;
        color: white;
    }

    .booking-btn:hover {
        background-color: #ff6b6b;
        transform: scale(1.1);
    }

    .logout-btn {
        background-color: #8e44ad;
        color: white;
        margin-left: 10px;
    }

    .logout-btn:hover {
        background-color: #9b59b6;
        transform: scale(1.1);
    }

    .user-info {
        display: flex;
        align-items: center;
    }

    .user-name {
        margin-right: 10px;
        font-weight: bold;
    }

    .menu-toggle {
        display: none;
        font-size: 30px;
        cursor: pointer;
    }

    @media (max-width: 768px) {
        .nav-links {
            display: none;
            flex-direction: column;
            background: #2ecc71;
            position: absolute;
            width: 100%;
            left: 0;
            top: 60px;
            text-align: center;
            padding: 15px 0;
        }

        .nav-links.active {
            display: flex;
        }

        .menu-toggle {
            display: block;
        }
    }
</style>

<script>
    document.querySelector(".menu-toggle").addEventListener("click", function () {
        document.querySelector(".nav-links").classList.toggle("active");
    });

    window.addEventListener("scroll", function () {
        const header = document.querySelector("header");
        if (window.scrollY > 50) {
            header.style.boxShadow = "0 4px 12px rgba(0, 0, 0, 0.3)";
        } else {
            header.style.boxShadow = "0 4px 8px rgba(0, 0, 0, 0.15)";
        }
    });
</script>
