<%@page contentType="text/html" pageEncoding="UTF-8"%>
<footer>
    <div class="footer-content">
        <p>© 2025 Homestay Booking. Tất cả quyền lợi được bảo vệ.</p>
        <div class="social-links">
            <a href="https://www.facebook.com" class="social-icon" title="Facebook" target="_blank" rel="noopener noreferrer">
                <i class="fab fa-facebook-f"></i>
            </a>
            <a href="https://www.instagram.com" class="social-icon" title="Instagram" target="_blank" rel="noopener noreferrer">
                <i class="fab fa-instagram"></i>
            </a>
            <a href="https://www.twitter.com" class="social-icon" title="Twitter" target="_blank" rel="noopener noreferrer">
                <i class="fab fa-twitter"></i>
            </a>
        </div>
    </div>
    
    <div class="social-logos">
        <a href="https://www.facebook.com" class="logo-link" target="_blank" rel="noopener noreferrer">
            <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/b/b8/2021_Facebook_icon.svg/512px-2021_Facebook_icon.svg.png" alt="Facebook">
        </a>
        <a href="https://www.instagram.com" class="logo-link" target="_blank" rel="noopener noreferrer">
            <img src="https://cdn-icons-png.flaticon.com/512/1409/1409946.png" alt="Instagram">
        </a>
        <a href="https://zalo.me" class="logo-link" target="_blank" rel="noopener noreferrer">
            <img src="https://haiauint.vn/wp-content/uploads/2024/02/zalo-icon.png" alt="Zalo">
        </a>
    </div>
</footer>

<style>
    
    footer {
        background: #5DC1B9;
        color: white;
        text-align: center;
        padding: 20px;
        margin-top: auto;
        font-family: 'Arial', sans-serif;
    }

    .footer-content {
        max-width: 1200px;
        margin: 0 auto;
    }

    .footer-content p {
        font-size: 14px;
    }

    .social-links {
        margin-top: 10px;
        display: flex;
        justify-content: center;
        gap: 20px;
    }

    .social-icon {
        font-size: 20px;
        color: white;
        transition: transform 0.3s ease, color 0.3s ease;
    }

    .social-icon:hover {
        color: #ecf0f1;
        transform: scale(1.2);
    }

    /* Logo mạng xã hội */
    .social-logos {
        display: flex;
        justify-content: center;
        gap: 15px;
        margin-top: 15px;
    }

    .logo-link img {
        width: 40px;
        height: 40px;
        transition: transform 0.3s ease;
        filter: brightness(1.1);
    }

    .logo-link img:hover {
        transform: scale(1.2);
    }
</style>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        console.log("Footer script loaded!");
    });
</script>

<!-- Import FontAwesome -->
<script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
