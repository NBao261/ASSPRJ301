<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Liên hệ - Homestay</title>
        <style>
            /* Reset toàn cục để tránh xung đột */
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            html, body {
                height: 100%;
                scroll-behavior: smooth; /* Cuộn mượt mà */
            }

            body {
                font-family: 'Arial', sans-serif;
                background: linear-gradient(135deg, #f4f4f4, #e0f7fa); /* Gradient nền sinh động */
                color: #333;
                display: flex;
                flex-direction: column;
                min-height: 100vh; /* Đảm bảo body tối thiểu bằng chiều cao màn hình */
            }

            /* Header (cố định ở trên cùng) */
            header {
                position: fixed;
                top: 0;
                width: 100%;
                background: #2ecc71; /* Màu nền xanh lá */
                z-index: 1000;
                padding: 15px 0;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2); /* Hiệu ứng bóng đổ */
                transition: background 0.3s ease;
            }
            header:hover {
                background: #27ae60; /* Thay đổi màu khi hover */
            }

            /* Nội dung chính */
            .contact-container {
                width: 85%;
                max-width: 1200px;
                margin: 100px auto 20px auto; /* Thêm margin-top để tránh header che */
                padding: 40px 20px;
                background: rgba(255, 255, 255, 0.9); /* Nền trong suốt nhẹ */
                border-radius: 15px;
                box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
            }

            h2, h3 {
                color: #2c3e50;
                text-align: center;
                margin-bottom: 20px;
                text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.1); /* Hiệu ứng bóng chữ */
            }

            .contact-info, .contact-form, .faq, .map, .social-links {
                background: #fff;
                padding: 25px;
                margin-bottom: 30px;
                border-radius: 10px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                transition: all 0.3s ease;
            }

            .contact-info:hover, .contact-form:hover, .faq:hover, .map:hover, .social-links:hover {
                transform: translateY(-10px) scale(1.02); /* Hiệu ứng nâng lên và phóng to */
                box-shadow: 0 6px 20px rgba(0, 0, 0, 0.2);
            }

            .contact-info p {
                margin: 10px 0;
                line-height: 1.6;
                color: #555;
            }

            iframe {
                width: 100%;
                height: 350px;
                border-radius: 8px;
                border: none;
                box-shadow: inset 0 0 10px rgba(0, 0, 0, 0.1); /* Hiệu ứng bóng trong iframe */
            }

            .contact-form input, .contact-form textarea {
                width: 100%;
                padding: 12px;
                margin: 10px 0;
                border: 1px solid #ddd;
                border-radius: 5px;
                font-size: 16px;
                transition: border-color 0.3s ease, box-shadow 0.3s ease;
            }

            .contact-form input:focus, .contact-form textarea:focus {
                border-color: #28a745;
                box-shadow: 0 0 5px rgba(40, 167, 69, 0.5);
                outline: none;
            }

            .contact-form textarea {
                resize: vertical;
                min-height: 100px;
            }

            .contact-form button {
                background: linear-gradient(45deg, #28a745, #2ecc71); /* Gradient nút */
                color: #fff;
                padding: 12px 25px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                font-size: 16px;
                transition: all 0.3s ease;
                text-transform: uppercase;
            }

            .contact-form button:hover {
                background: linear-gradient(45deg, #218838, #27ae60);
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(40, 167, 69, 0.4);
            }

            /* Phần .social-links */
            .social-links {
                text-align: center;
                margin-bottom: 40px;
                padding: 20px;
                background: linear-gradient(135deg, #fff, #f9f9f9); /* Nền gradient nhẹ */
                border-radius: 10px;
                display: flex;
                justify-content: center; /* Căn giữa theo chiều ngang */
                align-items: center; /* Căn giữa theo chiều dọc */
                gap: 30px; /* Khoảng cách đều giữa các biểu tượng */
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                position: relative;
                overflow: hidden; /* Ẩn hiệu ứng tràn */
            }

            .social-links::before {
                content: '';
                position: absolute;
                top: -50%;
                left: -50%;
                width: 200%;
                height: 200%;
                background: radial-gradient(circle, rgba(40, 167, 69, 0.1) 0%, transparent 70%);
                animation: rotate 10s linear infinite; /* Hiệu ứng xoay gradient */
                z-index: 0;
            }

            @keyframes rotate {
                0% { transform: rotate(0deg); }
                100% { transform: rotate(360deg); }
            }

            .social-links a {
                display: flex;
                justify-content: center;
                align-items: center;
                position: relative;
                z-index: 1; /* Đảm bảo biểu tượng nằm trên gradient */
                transition: transform 0.3s ease, filter 0.3s ease;
            }

            .social-links a:hover {
                transform: scale(1.3) rotate(5deg); /* Phóng to và xoay nhẹ */
                filter: brightness(1.2) drop-shadow(0 0 10px rgba(40, 167, 69, 0.5));
            }

            .social-links img {
                width: 50px;
                height: 50px;
                border-radius: 50%;
                box-shadow: 0 2px 6px rgba(0, 0, 0, 0.2);
                transition: box-shadow 0.3s ease, transform 0.3s ease;
                background: #fff; /* Nền trắng cho biểu tượng */
                padding: 5px; /* Khoảng cách nội bộ */
            }

            .social-links img:hover {
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
                transform: scale(1.1);
            }

            .faq p {
                margin: 15px 0;
                line-height: 1.6;
                color: #666;
            }

            .faq strong {
                color: #2c3e50;
            }

            /* Nút quay lại đầu trang */
            .back-to-top {
                display: none;
                position: fixed;
                bottom: 20px;
                right: 20px;
                background: #28a745;
                color: #fff;
                padding: 10px 15px;
                border-radius: 50%;
                border: none;
                cursor: pointer;
                font-size: 18px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
                transition: all 0.3s ease;
            }

            .back-to-top:hover {
                background: #218838;
                transform: scale(1.1);
            }

            /* Footer (luôn ở cuối trang) */
            footer {
                width: 100%;
                background: #2ecc71;
                padding: 20px 0;
                text-align: center;
                flex-shrink: 0;
                margin-top: auto;
                color: #fff;
                font-size: 14px;
            }

            footer a {
                color: #fff;
                margin: 0 10px;
                text-decoration: none;
                transition: color 0.3s ease;
            }

            footer a:hover {
                color: #f1c40f;
            }

            /* Responsive */
            @media (max-width: 768px) {
                .contact-container {
                    width: 90%;
                    padding: 20px 10px;
                    margin-top: 80px; /* Giảm margin-top trên màn hình nhỏ */
                }
                .social-links {
                    gap: 15px; /* Giảm khoảng cách trên màn hình nhỏ */
                    padding: 15px;
                }
                .social-links img {
                    width: 40px;
                    height: 40px;
                }
                .contact-form button {
                    width: 100%;
                }
                .back-to-top {
                    bottom: 10px;
                    right: 10px;
                }
            }
        </style>
    </head>
    <body>
        <%@include file="header.jsp" %>

        <div class="contact-container">
            <h2>Liên hệ với chúng tôi</h2>

            <div class="contact-info">
                <h3>Thông tin liên hệ</h3>
                <p><strong>Địa chỉ:</strong> 123 Đường ABC, Quận XYZ, TP. Hồ Chí Minh</p>
                <p><strong>Điện thoại:</strong> 0901 234 567</p>
                <p><strong>Email:</strong> contact@homestay.com</p>
                <p><strong>Giờ làm việc:</strong> 08:00 - 22:00 (Hằng ngày)</p>
            </div>

            <div class="map">
                <h3>Bản đồ</h3>
                <iframe src="https://maps.google.com/maps?width=100%25&height=600&hl=en&q=S702%20Vinhomes%20GrandPark,%20Qu%E1%BA%ADn%209+(HomeStay)&t=&z=14&ie=UTF8&iwloc=B&output=embed" allowfullscreen></iframe>
            </div>

            <div class="contact-form">
                <h3>Gửi tin nhắn cho chúng tôi</h3>
                <form id="contactForm">
                    <input type="text" name="name" placeholder="Họ và tên" required>
                    <input type="email" name="email" placeholder="Email" required>
                    <input type="tel" name="phone" placeholder="Số điện thoại">
                    <textarea name="message" placeholder="Nội dung tin nhắn" rows="5" required></textarea>
                    <button type="submit">Gửi</button>
                </form>
            </div>

            <div class="social-links">
                <h3>Kết nối với chúng tôi</h3>
                <a href="https://www.facebook.com/mamchildrendreamfoundation" target="_blank">
                    <img src="https://upload.wikimedia.org/wikipedia/commons/0/05/Facebook_Logo_%282019%29.png" alt="Facebook">
                </a>
                <a href="https://www.instagram.com/" target="_blank">
                    <img src="https://cdn.pixabay.com/photo/2016/08/09/17/52/instagram-1581266_640.jpg" alt="Instagram">
                </a>
                <a href="https://zalo.me/" target="_blank">
                    <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/9/91/Icon_of_Zalo.svg/1024px-Icon_of_Zalo.svg.png" alt="Zalo">
                </a>
            </div>

            <div class="faq">
                <h3>Câu hỏi thường gặp</h3>
                <p><strong>1. Tôi có thể đặt phòng qua điện thoại không?</strong> - Có, bạn có thể gọi hotline để đặt phòng nhanh chóng.</p>
                <p><strong>2. Chính sách hoàn hủy như thế nào?</strong> - Vui lòng liên hệ chúng tôi để biết thêm chi tiết.</p>
            </div>
        </div>

        <%@include file="footer.jsp" %>

        <button class="back-to-top" onclick="scrollToTop()">↑</button>

        <script>
            // Xử lý gửi form
            document.getElementById('contactForm').addEventListener('submit', function (e) {
                e.preventDefault();
                alert('Cảm ơn bạn đã gửi tin nhắn! Chúng tôi sẽ liên hệ lại sớm nhất.');
                this.reset();
            });

            // Hiệu ứng cuộn lên đầu trang
            function scrollToTop() {
                window.scrollTo({top: 0, behavior: 'smooth'});
            }

            // Hiển thị nút quay lại đầu trang khi cuộn
            window.onscroll = function () {
                const backToTopButton = document.querySelector('.back-to-top');
                if (document.body.scrollTop > 100 || document.documentElement.scrollTop > 100) {
                    backToTopButton.style.display = 'block';
                } else {
                    backToTopButton.style.display = 'none';
                }
            };
        </script>
    </body>
</html>