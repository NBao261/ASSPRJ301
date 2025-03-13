<%@page import="dto.UserDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Trang chủ - Homestay</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
            /* Reset CSS */
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

            /* Header and Footer Containers */
            .header-container, .footer-container {
                width: 100%;
                z-index: 1000;
            }

            .main-content {
                flex: 1;
                padding: 80px 0 80px;
                overflow: auto;
            }

            /* Banner Section (Cập nhật với carousel) */
            .banner {
                background: none;
                height: 500px;
                position: relative;
                margin-bottom: 40px;
                overflow: hidden;
            }

            .banner-slider {
                position: relative;
                height: 100%;
                width: 100%;
            }

            .slide {
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background-size: cover;
                background-position: center;
                display: flex;
                align-items: center;
                justify-content: center;
                opacity: 0;
                transition: opacity 0.5s ease-in-out;
            }

            .slide:nth-child(1) { background: url('https://acihome.vn/uploads/15/thiet-ke-khu-nghi-duong-homestay-la-gi.jpg') no-repeat center center/cover; }
            .slide:nth-child(2) { background: url('https://media.vov.vn/sites/default/files/styles/large_watermark/public/2024-06/du-lich-tam-coc-ninh-binh-2024-2.jpg') no-repeat center center/cover; }
            .slide:nth-child(3) { background: url('https://pix10.agoda.net/hotelImages/442/442279/442279_16092616080046938860.jpg?ca=6&ce=1&s=414x232&ar=16x9') no-repeat center center/cover; }

            .slide.active {
                opacity: 1;
                z-index: 1;
            }

            .banner-content {
                background: rgba(0, 0, 0, 0.5);
                padding: 40px;
                border-radius: 15px;
                max-width: 900px;
                width: 90%;
                backdrop-filter: blur(5px);
                box-shadow: 0 8px 25px rgba(0, 0, 0, 0.3);
                transition: transform 0.3s ease, box-shadow 0.3s ease;
                text-align: center;
                color: white;
            }

            .banner-content:hover {
                transform: translateY(-5px);
                box-shadow: 0 12px 35px rgba(0, 0, 0, 0.4);
            }

            .banner h1 {
                font-size: 48px;
                font-weight: 700;
                margin-bottom: 20px;
                text-shadow: 0 2px 4px rgba(0, 0, 0, 0.4);
            }

            .banner p {
                font-size: 20px;
                margin-bottom: 30px;
                text-shadow: 0 1px 2px rgba(0, 0, 0, 0.4);
            }

            .btn-view-details {
                background: #5DC1B9;
                color: white;
                padding: 10px 20px;
                text-decoration: none;
                border-radius: 8px;
                font-size: 16px;
                font-weight: 600;
                transition: background 0.3s ease, transform 0.3s ease, box-shadow 0.3s ease;
                display: inline-block;
                box-shadow: 0 4px 12px rgba(93, 193, 185, 0.4);
            }

            .btn-view-details:hover {
                background: #4ECDC4;
                transform: translateY(-3px);
                box-shadow: 0 6px 15px rgba(93, 193, 185, 0.6);
            }

            /* Intro Section (Cập nhật: Chữ chạy từ trái sang phải kiểu biển LED) */
            .intro {
                background: linear-gradient(135deg, #ffffff, #f9f9f9); /* Gradient nhẹ */
                padding: 60px 40px;
                margin: 0 auto 40px;
                border-radius: 15px;
                box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
                max-width: 1200px;
                width: 90%;
                position: relative;
                overflow: hidden;
                text-align: center; /* Căn giữa nội dung */
            }

            .intro::before {
                content: '';
                position: absolute;
                top: -50%;
                left: -50%;
                width: 200%;
                height: 200%;
                background: radial-gradient(circle, rgba(93, 193, 185, 0.1) 0%, transparent 70%);
                animation: rotate 15s linear infinite; /* Hiệu ứng xoay gradient */
                z-index: 0;
            }

            @keyframes rotate {
                0% { transform: rotate(0deg); }
                100% { transform: rotate(360deg); }
            }

            .intro-content, .intro-image {
                position: relative;
                z-index: 1; /* Đảm bảo nội dung và hình ảnh nằm trên gradient */
            }

            /* Container cho chữ chạy */
            .intro-content .text-container {
                overflow: hidden;
                white-space: nowrap; /* Đảm bảo chữ không xuống dòng */
                position: relative;
                display: inline-block;
            }

            .intro-content h2 {
                font-size: 48px; /* Tăng kích thước chữ */
                font-weight: 700;
                color: #2c3e50;
                text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.1), 0 0 10px rgba(93, 193, 185, 0.5); /* Thêm bóng sáng kiểu LED */
                display: inline-block;
                animation: marquee 10s linear infinite; /* Hiệu ứng chạy từ trái sang phải */
                transition: color 0.3s ease;
            }

            .intro-content h2:hover {
                color: #5DC1B9; /* Đổi màu khi hover */
            }

            /* Hiệu ứng chạy từ trái sang phải */
            @keyframes marquee {
                0% { transform: translateX(-100%); }
                100% { transform: translateX(100%); }
            }

            .intro-content p {
                font-size: 24px; /* Tăng kích thước chữ */
                color: #555;
                line-height: 1.8;
                margin-bottom: 30px;
                display: inline-block;
                animation: marquee 15s linear infinite; /* Hiệu ứng chạy từ trái sang phải, chậm hơn */
                text-shadow: 0 0 8px rgba(93, 193, 185, 0.3); /* Thêm bóng sáng kiểu LED */
            }

            .intro-image {
                margin-top: 30px; /* Khoảng cách giữa nội dung và hình ảnh */
            }

            .intro-image img {
                display: block; /* Đảm bảo hình ảnh là block để căn giữa */
                margin: 0 auto; /* Căn giữa hình ảnh */
                width: 100%;
                max-width: 1000px; /* Giới hạn chiều rộng tối đa của hình ảnh */
                height: 400px;
                object-fit: cover;
                border-radius: 15px;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
                transition: transform 0.3s ease, box-shadow 0.3s ease, filter 0.3s ease; /* Hiệu ứng phóng to, bóng, và sáng */
                opacity: 0; /* Ẩn ban đầu để áp dụng hiệu ứng fade-in */
                animation: fadeInScale 1s ease forwards 1s; /* Mờ dần và phóng to, trễ 1s */
            }

            /* Hiệu ứng fade-in và phóng to */
            @keyframes fadeInScale {
                0% {
                    opacity: 0;
                    transform: scale(0.95);
                }
                100% {
                    opacity: 1;
                    transform: scale(1);
                }
            }

            .intro-image img:hover {
                transform: scale(1.05); /* Phóng to nhẹ khi hover */
                box-shadow: 0 8px 20px rgba(0, 0, 0, 0.3), 0 0 20px rgba(93, 193, 185, 0.5); /* Thêm bóng sáng */
                filter: brightness(1.1); /* Tăng độ sáng khi hover */
            }

            /* Services Section (Cập nhật) */
            .services-section {
                max-width: 1200px;
                width: 90%;
                margin: 0 auto 40px;
                padding: 40px 20px;
                background: #ffffff;
                border-radius: 15px;
                box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
            }

            .services-section h2 {
                font-size: 36px;
                font-weight: 600;
                color: #2c3e50;
                text-align: center;
                margin-bottom: 40px;
            }

            .services-grid {
                display: grid;
                gap: 30px;
            }

            /* Service Item Layout (Chéo qua chéo lại) */
            .service-item {
                display: flex;
                flex-direction: row;
                align-items: center;
                background: white;
                border-radius: 15px;
                overflow: hidden;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }

            .service-item:hover {
                transform: translateY(-10px);
                box-shadow: 0 15px 40px rgba(0, 0, 0, 0.2);
            }

            .service-image, .service-content {
                flex: 1;
                padding: 20px;
            }

            .service-image img {
                width: 100%;
                height: 250px;
                object-fit: cover;
                border-radius: 15px;
            }

            .service-item-left .service-image {
                order: 1; /* Hình bên trái */
            }

            .service-item-left .service-content {
                order: 2; /* Nội dung bên phải */
            }

            .service-item-right .service-image {
                order: 2; /* Hình bên phải */
            }

            .service-item-right .service-content {
                order: 1; /* Nội dung bên trái */
            }

            .service-content h3 {
                font-size: 24px;
                color: #d4a017;
                margin-bottom: 10px;
            }

            .service-content p {
                font-size: 16px;
                color: #555;
                line-height: 1.6;
            }

            /* Responsive Design */
            @media (max-width: 768px) {
                .main-content {
                    padding: 60px 0 70px;
                }

                .banner {
                    height: 300px;
                }

                .banner-content {
                    padding: 20px;
                    max-width: 85%;
                }

                .banner h1 {
                    font-size: 28px;
                }

                .banner p {
                    font-size: 16px;
                }

                .btn-view-details {
                    padding: 8px 18px;
                    font-size: 14px;
                }

                .intro {
                    padding: 40px 20px;
                    margin: 0 auto 20px;
                }

                .intro-content h2 {
                    font-size: 36px; /* Giảm kích thước chữ trên mobile */
                }

                .intro-content p {
                    font-size: 18px; /* Giảm kích thước chữ trên mobile */
                }

                .intro-image img {
                    height: 200px;
                    max-width: 100%; /* Đảm bảo hình ảnh không vượt quá khung trên mobile */
                }

                .services-section {
                    padding: 20px;
                }

                .services-section h2 {
                    font-size: 24px;
                }

                .service-item {
                    flex-direction: column; /* Chuyển về bố cục dọc trên mobile */
                }

                .service-image, .service-content {
                    flex: none;
                    width: 100%;
                }

                .service-image img {
                    height: 200px;
                }

                .service-content h3 {
                    font-size: 20px;
                }

                .service-content p {
                    font-size: 14px;
                }
            }

            /* Smooth scrolling */
            html {
                scroll-behavior: smooth;
            }
        </style>
        <!-- Include FontAwesome for footer.jsp -->
        <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
    </head>
    <body>
        <div class="header-container">
            <%@include file="header.jsp" %>
        </div>

        <div class="main-content">
            <div class="banner">
                <div class="banner-slider">
                    <div class="slide">
                        <div class="banner-content">
                            <h1>Chào mừng đến với Homestay của chúng tôi!</h1>
                            <p>Trải nghiệm không gian thư giãn và dịch vụ tuyệt vời.</p>
                        </div>
                    </div>
                    <div class="slide">
                        <div class="banner-content">
                            <h1>Khám phá không gian tuyệt đẹp</h1>
                            <p>Thư giãn giữa thiên nhiên xanh mát tại homestay của chúng tôi.</p>
                        </div>
                    </div>
                    <div class="slide">
                        <div class="banner-content">
                            <h1>Dịch vụ cao cấp dành cho bạn</h1>
                            <p>Hưởng thụ sự sang trọng và tiện nghi đỉnh cao.</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Intro Section (Chữ chạy từ trái sang phải kiểu biển LED) -->
            <section class="intro">
                <div class="intro-content">
                    <div class="text-container">
                        <h2>Về chúng tôi</h2>
                    </div>
                    <div class="text-container">
                        <p>Homestay của chúng tôi mang đến không gian ấm cúng, tiện nghi và sạch sẽ, giúp bạn cảm thấy như đang ở nhà. Đội ngũ nhân viên thân thiện, luôn sẵn sàng hỗ trợ để mang lại trải nghiệm tốt nhất cho khách hàng. Chúng tôi cam kết cung cấp dịch vụ chất lượng với mức giá hợp lý, giúp bạn tận hưởng kỳ nghỉ trọn vẹn.</p>
                    </div>
                </div>
                <div class="intro-image">
                    <img src="https://ik.imagekit.io/tvlk/blog/2022/11/homestay-da-lat-view-dep-23.png" alt="Homestay Image">
                </div>
            </section>

            <!-- Services Section -->
            <section class="services-section">
                <h2>Dịch vụ nổi bật</h2>
                <div class="services-grid">
                    <!-- Service 1: Infinity Pool (Hình bên trái, nội dung bên phải) -->
                    <div class="service-item service-item-left">
                        <div class="service-image">
                            <img src="https://tecwood.com.vn/upload/mau-ho-boi-dep.jpg" alt="Bể bơi bốn mùa">
                        </div>
                        <div class="service-content">
                            <h3>Bể bơi bốn mùa</h3>
                            <p>Bể bơi bốn mùa trong nhà tại tầng 4 của khách sạn, với công nghệ làm ấm nước và điều nhiệt độ liên tục, là nơi quý khách có thể tận hưởng không gian thư giãn và rèn luyện cơ thể 4 mùa trong năm.</p>
                        </div>
                    </div>

                    <!-- Service 2: Gym & Yoga (Hình bên phải, nội dung bên trái) -->
                    <div class="service-item service-item-right">
                        <div class="service-image">
                            <img src="https://www.vietnambooking.com/wp-content/uploads/2017/10/khach-san-co-phong-tap-the-hinh-khong-7-7-2018-2.jpg" alt="Câu lạc bộ Gym & Yoga">
                        </div>
                        <div class="service-content">
                            <h3>Câu lạc bộ Gym & Yoga</h3>
                            <p>Tận hưởng không gian rèn luyện sức khỏe với những trang thiết bị hiện đại nhất tại câu lạc bộ Gym & Yoga trong khách sạn. Tiện ích này đáp ứng mọi nhu cầu tập luyện của quý khách.</p>
                        </div>
                    </div>

                    <!-- Service 3: Spa & Massage (Hình bên trái, nội dung bên phải) -->
                    <div class="service-item service-item-left">
                        <div class="service-image">
                            <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT3sji02LlMhmx8utCHFTcadOeppqb3NbXD4Q&s" alt="Spa & Massage">
                        </div>
                        <div class="service-content">
                            <h3>Spa & Massage</h3>
                            <p>Trải nghiệm thư giãn tuyệt đối với các liệu trình spa cao cấp và massage chuyên nghiệp, giúp bạn phục hồi năng lượng sau ngày dài.</p>
                        </div>
                    </div>

                    <!-- Service 4: Nhà hàng sang trọng (Hình bên phải, nội dung bên trái) -->
                    <div class="service-item service-item-right">
                        <div class="service-image">
                            <img src="https://halotravel.vn/wp-content/uploads/2021/02/nha-hang-sang-trong-sai-gon-the-log-1024x682.jpg" alt="Nhà hàng sang trọng">
                        </div>
                        <div class="service-content">
                            <h3>Nhà hàng sang trọng</h3>
                            <p>Thưởng thức các món ăn tinh tế từ khắp nơi trên thế giới, với không gian sang trọng và dịch vụ chuyên nghiệp.</p>
                        </div>
                    </div>

                    <!-- Service 5: Bar & Lounge (Hình bên trái, nội dung bên phải) -->
                    <div class="service-item service-item-left">
                        <div class="service-image">
                            <img src="https://acihome.vn/uploads/19/quay-bar-resort-cao-cap-doc-dao.jpg" alt="Bar & Lounge">
                        </div>
                        <div class="service-content">
                            <h3>Bar & Lounge</h3>
                            <p>Khu vực bar và lounge hiện đại, nơi bạn có thể thư giãn với đồ uống yêu thích và ngắm cảnh đêm tuyệt đẹp.</p>
                        </div>
                    </div>

                    <!-- Service 6: Tour & Trải nghiệm địa phương (Hình bên phải, nội dung bên trái) -->
                    <div class="service-item service-item-right">
                        <div class="service-image">
                            <img src="https://dalatravel.vn/wp-content/uploads/2021/03/tai-sao-nen-dat-tour-du-lich-da-lat-thay-vi-di-du-lich-tu-tuc-1.jpg" alt="Tour & Trải nghiệm địa phương">
                        </div>
                        <div class="service-content">
                            <h3>Tour & Trải nghiệm địa phương</h3>
                            <p>Khám phá văn hóa địa phương với các tour du lịch được thiết kế riêng, mang đến trải nghiệm độc đáo và ý nghĩa.</p>
                        </div>
                    </div>
                </div>
            </section>
        </div>

        <div class="footer-container">
            <%@include file="footer.jsp" %>
        </div>

        <!-- JavaScript cho carousel banner -->
        <script>
            let slideIndex = 0;
            const slides = document.querySelectorAll('.slide');

            function showSlide(index) {
                slides.forEach(slide => slide.classList.remove('active'));
                slides[index].classList.add('active');
            }

            function nextSlide() {
                slideIndex = (slideIndex + 1) % slides.length;
                showSlide(slideIndex);
            }

            // Tự động chuyển slide mỗi 5 giây (5000ms)
            setInterval(nextSlide, 5000);

            // Hiển thị slide đầu tiên khi tải trang
            showSlide(slideIndex);
        </script>
    </body>
</html>