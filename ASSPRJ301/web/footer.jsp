<%@page contentType="text/html" pageEncoding="UTF-8"%>
<footer>
    <div class="footer-content">
        <p>© 2025 Homestay Booking. Tất cả quyền lợi được bảo vệ.</p>
        <div class="social-links">
            <a href="#">Facebook</a>
            <a href="#">Instagram</a>
            <a href="#">Twitter</a>
        </div>
    </div>
</footer>

<style>
    /* Footer */
    footer {
        background-color: #34495e;
        padding: 20px 10px;
        text-align: center;
        color: white;
        position: relative;
        width: 100%;
        margin-top: auto; /* Chắc chắn footer sẽ nằm dưới cùng */
    }

    .footer-content {
        max-width: 1200px;
        margin: 0 auto;
    }

    .footer-content p {
        font-size: 14px;
        margin: 10px 0;
    }

    .social-links {
        margin-top: 10px;
    }

    .social-links a {
        color: white;
        text-decoration: none;
        font-size: 18px;
        margin: 0 15px;
        transition: color 0.3s ease;
    }

    .social-links a:hover {
        color: #1abc9c;
    }

    /* Cấu hình Flexbox để đảm bảo footer nằm dưới cùng */
    html, body {
        height: 100%;  /* Đảm bảo chiều cao đầy đủ */
        margin: 0;
        display: flex;
        flex-direction: column;  /* Sắp xếp các phần tử theo cột */
    }

    body {
        flex: 1;  /* Nội dung chiếm không gian còn lại */
    }

    /* Responsive Design */
    @media (max-width: 768px) {
        footer {
            padding: 20px;
        }

        .social-links a {
            font-size: 16px;
            margin: 0 12px;
        }

        .footer-content p {
            font-size: 13px;
        }
    }

    @media (max-width: 480px) {
        .social-links a {
            font-size: 14px;
            margin: 0 10px;
        }

        .footer-content p {
            font-size: 12px;
        }
    }
</style>
