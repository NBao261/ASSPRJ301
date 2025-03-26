<%@page pageEncoding="UTF-8"%>
<footer>
    <div class="footer-content">
        <p>© 2025 Homestay Booking. Tất cả quyền lợi được bảo vệ.</p>

        <!-- Social media logos (images) -->
        <div class="social-logos">
            <a href="https://www.facebook.com" class="logo-link" target="_blank" rel="noopener noreferrer">
                <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/b/b8/2021_Facebook_icon.svg/512px-2021_Facebook_icon.svg.png" alt="Facebook" loading="lazy">
            </a>
            <a href="https://www.instagram.com" class="logo-link" target="_blank" rel="noopener noreferrer">
                <img src="https://cdn-icons-png.flaticon.com/512/1409/1409946.png" alt="Instagram" loading="lazy">
            </a>
            <a href="https://zalo.me" class="logo-link" target="_blank" rel="noopener noreferrer">
                <img src="https://haiauint.vn/wp-content/uploads/2024/02/zalo-icon.png" alt="Zalo" loading="lazy">
            </a>
        </div>
    </div>
</footer>

<style>
    /* Reset CSS */
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    /* Footer styling */
    footer {
        background: linear-gradient(45deg, #5DC1B9, #F7DC6F); /* Đồng bộ gradient với header */
        color: white;
        text-align: center;
        padding: 10px 0; 
        font-family: 'Segoe UI', Arial, sans-serif; 
        position: relative; 
        bottom: 0;
        left: 0;
        width: 100%; 
        z-index: 999; 
        box-shadow: 0 -2px 10px rgba(0, 0, 0, 0.1); 
        height: 80px; 
    }

    .footer-content {
        max-width: 1200px;
        margin: 0 auto;
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 5px;
        height: 100%; 
        justify-content: space-between;
    }

    .footer-content p {
        font-size: 14px;
        font-weight: 500;
        margin: 0;
        text-shadow: 0 1px 2px rgba(0, 0, 0, 0.2); /* Thêm text-shadow để chữ nổi bật trên nền gradient */
    }

    /* Social media logos (images) */
    .social-logos {
        display: flex;
        justify-content: center;
        gap: 10px; 
        margin-top: -30px; 
        align-items: center; 
    }

    .logo-link img {
        width: 30px; 
        height: 30px;
        transition: transform 0.3s ease;
        filter: brightness(1.1);
        object-fit: contain; 
    }

    .logo-link img:hover {
        transform: scale(1.2);
    }

    /* Responsive Design */
    @media (max-width: 768px) {
        footer {
            padding: 5px 0; 
            height: 70px; 
        }

        .footer-content p {
            font-size: 12px;
            margin: 0;
        }

        .social-logos {
            gap: 8px; 
        }

        .logo-link img {
            width: 25px; 
            height: 25px;
        }
    }
</style>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        console.log("Footer script loaded!");
    });
</script>