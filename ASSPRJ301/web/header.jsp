<%@page contentType="text/html" pageEncoding="UTF-8"%>
<style>
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    /* Cấu trúc chung */
    body {
        font-family: Arial, sans-serif;
        line-height: 1.6;
        display: flex;
        flex-direction: column;
        min-height: 100vh;
    }

    /* Header */
    header {
        background-color: #2a9d8f;
        color: white;
        padding: 15px 50px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        position: sticky;
        top: 0;
        z-index: 1000;
    }

    header .logo {
        font-size: 24px;
        font-weight: bold;
    }

    header nav ul {
        list-style: none;
        display: flex;
        margin: 0;
        padding: 0;
    }

    header nav ul li {
        margin: 0 15px;
    }

    header nav ul li a {
        color: white;
        text-decoration: none;
        font-size: 18px;
        transition: color 0.3s;
    }

    header nav ul li a:hover {
        color: #e76f51;
    }

    header .booking-btn {
        background-color: #e76f51;
        color: white;
        padding: 10px 20px;
        text-decoration: none;
        border-radius: 5px;
        transition: background-color 0.3s;
    }

    header .booking-btn:hover {
        background-color: #f4a261;
    }

    /* Responsive */
    @media (max-width: 768px) {
        header {
            padding: 15px 30px;
        }

        header .logo {
            font-size: 20px;
        }

        header nav ul {
            display: block;
            text-align: center;
        }

        header nav ul li {
            margin: 10px 0;
        }

        header nav ul li a {
            font-size: 16px;
        }

        header .booking-btn {
            font-size: 16px;
            padding: 8px 15px;
        }
    }

    @media (max-width: 480px) {
        header {
            padding: 10px 20px;
        }

        header .logo {
            font-size: 18px;
        }

        header nav ul li a {
            font-size: 14px;
        }

        header .booking-btn {
            font-size: 14px;
            padding: 6px 12px;
        }
    }
</style>

<!-- Header -->
<header>
    <div class="logo">🏡 Homestay</div>
    <nav>
        <ul>
            <li><a href="index.jsp">Trang chủ</a></li>
            <li><a href="homestay.jsp">Homestay</a></li>
            <li><a href="services.jsp">Dịch vụ</a></li>
            <li><a href="contact.jsp">Liên hệ</a></li>
        </ul>
    </nav>
    <a href="booking.jsp" class="booking-btn">Đặt ngay</a>
</header>
