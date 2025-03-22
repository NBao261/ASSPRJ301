<%@page import="dto.UserDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, java.util.ArrayList" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Trang chủ - Homestay</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
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

            .header-container, .footer-container {
                width: 100%;
                z-index: 1000;
            }

            .main-content {
                flex: 1;
                padding: 0 0 80px;
                overflow: hidden;
            }

            /* Banner Section */
            .banner {
                background: url('https://acihome.vn/uploads/15/thiet-ke-khu-nghi-duong-homestay-la-gi.jpg') no-repeat center center/cover;
                height: 650px;
                display: flex;
                align-items: center;
                justify-content: center;
                text-align: center;
                position: relative;
                margin-bottom: 80px;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
            }

            .banner::after {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.5);
                z-index: 1;
            }

            .banner-content {
                position: relative;
                z-index: 2;
                padding: 60px;
                max-width: 1000px;
                width: 90%;
                color: white;
                animation: fadeIn 1.2s ease;
            }

            .banner h1 {
                font-size: 54px;
                font-weight: 700;
                margin-bottom: 30px;
                text-shadow: 0 3px 6px rgba(0, 0, 0, 0.5);
                animation: fadeInDown 1s ease;
            }

            .banner p {
                font-size: 24px;
                font-weight: 300;
                margin-bottom: 40px;
                text-shadow: 0 2px 4px rgba(0, 0, 0, 0.5);
                line-height: 1.6;
            }

            .btn-view-details {
                background: linear-gradient(45deg, #5DC1B9, #4ECDC4);
                color: white;
                padding: 14px 34px;
                text-decoration: none;
                border-radius: 50px;
                font-size: 18px;
                font-weight: 600;
                transition: all 0.3s ease;
                box-shadow: 0 4px 15px rgba(93, 193, 185, 0.4);
                display: inline-block;
            }

            .btn-view-details:hover {
                background: linear-gradient(45deg, #4ECDC4, #45b7d1);
                transform: translateY(-3px);
                box-shadow: 0 6px 20px rgba(93, 193, 185, 0.6);
            }

            /* Intro Section */
            .intro {
                background: #fff;
                padding: 80px 40px;
                text-align: center;
                margin: 0 auto 80px;
                border-radius: 20px;
                box-shadow: 0 15px 40px rgba(0, 0, 0, 0.12);
                max-width: 1200px;
                width: 90%;
                position: relative;
                overflow: hidden;
                transform: translateY(0);
                transition: transform 0.3s ease;
            }

            .intro:hover {
                transform: translateY(-5px);
            }

            .intro::before {
                content: '';
                position: absolute;
                top: -50px;
                left: -50px;
                width: 200px;
                height: 200px;
                background: rgba(93, 193, 185, 0.15);
                border-radius: 50%;
                z-index: 0;
            }

            .intro::after {
                content: '';
                position: absolute;
                bottom: -80px;
                right: -80px;
                width: 250px;
                height: 250px;
                background: rgba(93, 193, 185, 0.1);
                border-radius: 50%;
                z-index: 0;
            }

            .intro h2 {
                font-size: 42px;
                font-weight: 600;
                margin-bottom: 30px;
                color: #2c3e50;
                position: relative;
                z-index: 1;
            }

            .intro p {
                font-size: 19px;
                color: #555;
                line-height: 1.9;
                max-width: 850px;
                margin: 0 auto 30px;
                position: relative;
                z-index: 1;
            }

            /* Highlighted Rooms Section */
            .highlighted-rooms {
                max-width: 1200px;
                width: 90%;
                margin: 0 auto 80px;
                padding: 0 20px;
            }

            .section-title {
                text-align: center;
                font-size: 38px;
                font-weight: 600;
                color: #2c3e50;
                margin-bottom: 50px;
                position: relative;
            }

            .section-title::after {
                content: '';
                position: absolute;
                bottom: -15px;
                left: 50%;
                transform: translateX(-50%);
                width: 80px;
                height: 3px;
                background: linear-gradient(45deg, #5DC1B9, #4ECDC4);
            }

            .room-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(340px, 1fr));
                gap: 40px;
            }

            .room {
                background: white;
                border-radius: 20px;
                overflow: hidden;
                box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
                transition: all 0.4s ease;
                display: flex;
                flex-direction: column;
                position: relative;
            }

            .room:hover {
                transform: translateY(-15px);
                box-shadow: 0 20px 45px rgba(0, 0, 0, 0.15);
            }

            .room img {
                width: 100%;
                height: 240px;
                object-fit: cover;
                transition: transform 0.5s ease;
            }

            .room:hover img {
                transform: scale(1.05);
            }

            .room-info {
                padding: 30px;
                text-align: center;
                flex-grow: 1;
                display: flex;
                flex-direction: column;
                justify-content: space-between;
            }

            .room h3 {
                font-size: 26px;
                font-weight: 600;
                color: #2c3e50;
                margin-bottom: 15px;
            }

            .room p {
                font-size: 17px;
                color: #666;
                margin-bottom: 20px;
                line-height: 1.6;
            }

            .room .price {
                font-size: 23px;
                font-weight: 600;
                color: #5DC1B9;
                margin: 15px 0;
            }

            .room .btn-container {
                margin-top: 25px;
            }

            /* More Rooms Link */
            .more-rooms {
                text-align: center;
                margin-top: 50px;
            }

            .more-rooms a {
                color: #5DC1B9;
                font-size: 18px;
                font-weight: 600;
                text-decoration: none;
                padding: 12px 26px;
                border: 2px solid #5DC1B9;
                border-radius: 50px;
                transition: all 0.3s ease;
            }

            .more-rooms a:hover {
                background: #5DC1B9;
                color: white;
                box-shadow: 0 5px 15px rgba(93, 193, 185, 0.4);
            }

            /* Chatbot Styles */
            .chatbot-container {
                position: fixed;
                bottom: 80px;
                right: 20px;
                width: 350px;
                border: 1px solid #ccc;
                border-radius: 20px;
                box-shadow: 0 15px 40px rgba(0, 0, 0, 0.12);
                display: none;
                flex-direction: column;
                background: #fff;
                z-index: 1000;
            }
            .chatbot-header {
                background: linear-gradient(45deg, #5DC1B9, #4ECDC4);
                color: white;
                padding: 15px;
                border-radius: 20px 20px 0 0;
                display: flex;
                justify-content: space-between;
                align-items: center;
                font-size: 18px;
                font-weight: 600;
            }
            .chatbot-box {
                height: 300px;
                overflow-y: auto;
                padding: 15px;
                background: #f9f9f9;
            }
            .chat-message { margin: 10px 0; padding: 8px; border-radius: 10px; }
            .user-message { background: #e3f2fd; text-align: right; }
            .grok-message { background: #fff; border: 1px solid #ddd; }
            .timestamp { font-size: 0.8em; color: #666; }
            .chatbot-input {
                display: flex;
                gap: 10px;
                padding: 10px;
                border-top: 1px solid #ccc;
            }
            .chatbot-input input {
                flex: 1;
                padding: 8px;
                border: 1px solid #ccc;
                border-radius: 10px;
                font-size: 16px;
            }
            .chatbot-input button, .suggestion-btn {
                padding: 8px 15px;
                background: linear-gradient(45deg, #5DC1B9, #4ECDC4);
                color: white;
                border: none;
                border-radius: 10px;
                cursor: pointer;
                font-size: 16px;
                font-weight: 600;
                transition: all 0.3s ease;
            }
            .chatbot-input button:hover, .suggestion-btn:hover {
                background: linear-gradient(45deg, #4ECDC4, #45b7d1);
                box-shadow: 0 5px 15px rgba(93, 193, 185, 0.4);
            }
            .clear-btn {
                background: #dc3545;
            }
            .clear-btn:hover {
                background: #b02a37;
                box-shadow: 0 5px 15px rgba(220, 53, 69, 0.4);
            }
            .chatbot-toggle {
                position: fixed;
                bottom: 20px;
                right: 20px;
                background: linear-gradient(45deg, #5DC1B9, #4ECDC4);
                color: white;
                border: none;
                border-radius: 50%;
                width: 50px;
                height: 50px;
                font-size: 24px;
                cursor: pointer;
                box-shadow: 0 5px 15px rgba(93, 193, 185, 0.4);
                transition: all 0.3s ease;
            }
            .chatbot-toggle:hover {
                background: linear-gradient(45deg, #4ECDC4, #45b7d1);
                transform: translateY(-3px);
                box-shadow: 0 8px 20px rgba(93, 193, 185, 0.6);
            }
            .suggestions { padding: 10px; display: flex; gap: 10px; flex-wrap: wrap; }

            /* Animation */
            @keyframes fadeIn {
                from { opacity: 0; }
                to { opacity: 1; }
            }

            @keyframes fadeInDown {
                from { opacity: 0; transform: translateY(-30px); }
                to { opacity: 1; transform: translateY(0); }
            }

            @keyframes fadeInUp {
                from { opacity: 0; transform: translateY(30px); }
                to { opacity: 1; transform: translateY(0); }
            }

            /* Responsive Design */
            @media (max-width: 992px) {
                .banner {
                    height: 550px;
                }

                .room-grid {
                    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                    gap: 30px;
                }
            }

            @media (max-width: 768px) {
                .banner {
                    height: 450px;
                    margin-bottom: 60px;
                }

                .banner-content {
                    padding: 40px 20px;
                }

                .banner h1 {
                    font-size: 36px;
                    margin-bottom: 20px;
                }

                .banner p {
                    font-size: 18px;
                    margin-bottom: 30px;
                }

                .btn-view-details {
                    padding: 12px 28px;
                    font-size: 16px;
                }

                .intro {
                    padding: 60px 30px;
                    margin-bottom: 60px;
                }

                .intro h2 {
                    font-size: 32px;
                }

                .intro p {
                    font-size: 17px;
                }

                .section-title {
                    font-size: 30px;
                    margin-bottom: 40px;
                }

                .room img {
                    height: 200px;
                }

                .room h3 {
                    font-size: 22px;
                }

                .room p {
                    font-size: 16px;
                }

                .room .price {
                    font-size: 20px;
                }

                .more-rooms a {
                    font-size: 16px;
                    padding: 10px 22px;
                }

                .chatbot-container {
                    width: 300px;
                    bottom: 70px;
                }
            }

            @media (max-width: 480px) {
                .banner {
                    height: 400px;
                }

                .banner h1 {
                    font-size: 30px;
                }

                .intro {
                    padding: 50px 20px;
                }

                .room-grid {
                    grid-template-columns: 1fr;
                    gap: 30px;
                }

                .room-info {
                    padding: 25px 20px;
                }

                .chatbot-container {
                    width: 90%;
                    right: 5%;
                }
            }
        </style>
        <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
    </head>
    <body>
        <div class="header-container">
            <%@include file="header.jsp" %>
        </div>

        <div class="main-content">
            <div class="banner">
                <div class="banner-content">
                    <h1>Khám phá Homestay tuyệt vời của bạn!</h1>
                    <p>Đặt ngay hôm nay để tận hưởng không gian nghỉ dưỡng đẳng cấp với giá ưu đãi.</p>
                    <a href="#highlighted-rooms" class="btn-view-details">Khám phá ngay</a>
                </div>
            </div>

            <section class="intro">
                <h2>Về Homestay của chúng tôi</h2>
                <p>Chào mừng bạn đến với Homestay của sự thư giãn và đẳng cấp. Chúng tôi mang đến không gian sống ấm cúng, tiện nghi hiện đại và dịch vụ tận tâm, giúp bạn có một kỳ nghỉ đáng nhớ giữa lòng thiên nhiên.</p>
            </section>

            <section id="highlighted-rooms" class="highlighted-rooms">
                <h2 class="section-title">Phòng nổi bật</h2>
                <div class="room-grid">
                    <div class="room">
                        <img src="https://mia.vn/media/uploads/blog-du-lich/top-11-homestay-ba-vi-01-1700960372.jpeg" alt="Phòng Deluxe">
                        <div class="room-info">
                            <div>
                                <h3>Phòng Deluxe</h3>
                                <p>Không gian ấm cúng, lý tưởng cho các cặp đôi.</p>
                                <p class="price">1.200.000đ / đêm</p>
                            </div>
                            <div class="btn-container">
                                <% if (user != null) { %>
                                <a href="room-details?roomId=1" class="btn-view-details">Xem chi tiết</a>
                                <% } else { %>
                                <a href="login-regis.jsp" class="btn-view-details">Đăng nhập để đặt</a>
                                <% } %>
                            </div>
                        </div>
                    </div>

                    <div class="room">
                        <img src="https://dongtiengroup.vn/wp-content/uploads/2024/05/thiet-ke-homestay-nha-vuon-5.jpg" alt="Phòng VIP">
                        <div class="room-info">
                            <div>
                                <h3>Phòng VIP</h3>
                                <p>Sang trọng với view biển tuyệt đẹp.</p>
                                <p class="price">1.800.000đ / đêm</p>
                            </div>
                            <div class="btn-container">
                                <% if (user != null) { %>
                                <a href="room-details?roomId=2" class="btn-view-details">Xem chi tiết</a>
                                <% } else { %>
                                <a href="login-regis.jsp" class="btn-view-details">Đăng nhập để đặt</a>
                                <% } %>
                            </div>
                        </div>
                    </div>

                    <div class="room">
                        <img src="https://sakos.vn/wp-content/uploads/2023/05/momo-upload-api-220510091852-637877711328579007.jpeg" alt="Phòng Gia Đình">
                        <div class="room-info">
                            <div>
                                <h3>Phòng Gia Đình</h3>
                                <p>Rộng rãi, thoáng mát cho cả gia đình.</p>
                                <p class="price">2.500.000đ / đêm</p>
                            </div>
                            <div class="btn-container">
                                <% if (user != null) { %>
                                <a href="room-details?roomId=3" class="btn-view-details">Xem chi tiết</a>
                                <% } else { %>
                                <a href="login-regis.jsp" class="btn-view-details">Đăng nhập để đặt</a>
                                <% }%>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="more-rooms">
                    <a href="<%= request.getContextPath()%>/search.jsp">Xem nhiều phòng khác tại đây</a>
                </div>
            </section>
        </div>

        <!-- Chatbot Widget -->
        <button class="chatbot-toggle" onclick="toggleChatbot()">💬</button>
        <div class="chatbot-container" id="chatbotContainer">
            <div class="chatbot-header">
                <span>Chat với Grok</span>
                <button onclick="toggleChatbot()" style="background: none; border: none; color: white; font-size: 16px;">✖</button>
            </div>
            <div class="chatbot-box" id="chatBox">
                <%
                    List<String[]> chatHistory = (List<String[]>) session.getAttribute("chatHistory");
                    if (chatHistory != null) {
                        for (String[] msg : chatHistory) {
                            String sender = msg[0];
                            String content = msg[1];
                            String timestamp = msg[2];
                            if ("You".equals(sender)) {
                                out.println("<div class='chat-message user-message'><b>You:</b> " + content + " <span class='timestamp'>(" + timestamp + ")</span></div>");
                            } else {
                                out.println("<div class='chat-message grok-message'><b>Grok:</b> " + content + " <span class='timestamp'>(" + timestamp + ")</span></div>");
                            }
                        }
                    }
                %>
            </div>
            <div class="suggestions" id="suggestions">
                <button class="suggestion-btn" onclick="suggestMessage('Xem phòng')">Xem phòng</button>
                <button class="suggestion-btn" onclick="suggestMessage('Đặt phòng Deluxe từ 2025-04-01 đến 2025-04-03, tên Nguyễn Văn A')">Đặt phòng</button>
                <button class="suggestion-btn" onclick="suggestMessage('Gợi ý phòng cho 2 người')">Gợi ý</button>
            </div>
            <div class="chatbot-input">
                <input type="text" id="userInput" placeholder="Nhập tin nhắn của bạn...">
                <button onclick="sendMessage()">Gửi</button>
                <button class="clear-btn" onclick="clearChat()">Xóa</button>
            </div>
        </div>

        <div class="footer-container">
            <%@include file="footer.jsp" %>
        </div>

        <script>
            let currentLanguage = "vi";

            function toggleChatbot() {
                const container = document.getElementById("chatbotContainer");
                container.style.display = container.style.display === "none" || container.style.display === "" ? "flex" : "none";
            }

            function sendMessage() {
                var input = document.getElementById("userInput").value;
                if (input.trim() === "")
                    return;

                var chatBox = document.getElementById("chatBox");
                var timestamp = new Date().toLocaleTimeString();
                chatBox.innerHTML += "<div class='chat-message user-message'><b>You:</b> " + input + " <span class='timestamp'>(" + timestamp + ")</span></div>";
                chatBox.innerHTML += "<div class='chat-message grok-message loading' id='loading'>Đang xử lý...</div>";
                chatBox.scrollTop = chatBox.scrollHeight;

                // Kiểm tra nếu người dùng nhập "Xác nhận đặt phòng"
                if (input.toLowerCase().includes("xác nhận đặt phòng")) {
                    fetch("ChatServlet", {
                        method: "POST",
                        headers: {"Content-Type": "application/x-www-form-urlencoded"},
                        body: "confirmBooking=true"
                    })
                            .then(response => response.text())
                            .then(data => {
                                document.getElementById("loading").remove();
                                chatBox.innerHTML += "<div class='chat-message grok-message'><b>Grok:</b> " + data + " <span class='timestamp'>(" + new Date().toLocaleTimeString() + ")</span></div>";
                                chatBox.scrollTop = chatBox.scrollHeight;
                            })
                            .catch(error => {
                                document.getElementById("loading").remove();
                                chatBox.innerHTML += "<div class='chat-message grok-message'><b>Lỗi:</b> " + error + "</div>";
                            });
                } else {
                    fetch("ChatServlet", {
                        method: "POST",
                        headers: {"Content-Type": "application/x-www-form-urlencoded"},
                        body: "message=" + encodeURIComponent(input) + "&language=vi"
                    })
                            .then(response => response.text())
                            .then(data => {
                                document.getElementById("loading").remove();
                                chatBox.innerHTML += "<div class='chat-message grok-message'><b>Grok:</b> " + data + " <span class='timestamp'>(" + new Date().toLocaleTimeString() + ")</span></div>";
                                chatBox.scrollTop = chatBox.scrollHeight;
                            })
                            .catch(error => {
                                document.getElementById("loading").remove();
                                chatBox.innerHTML += "<div class='chat-message grok-message'><b>Lỗi:</b> " + error + "</div>";
                            });
                }

                document.getElementById("userInput").value = "";
            }

            function clearChat() {
                if (confirm("Bạn có chắc muốn xóa lịch sử chat không?")) {
                    fetch("ChatServlet", {
                        method: "POST",
                        headers: {"Content-Type": "application/x-www-form-urlencoded"},
                        body: "clearHistory=true"
                    }).then(() => {
                        document.getElementById("chatBox").innerHTML = "";
                    });
                }
            }

            function suggestMessage(text) {
                document.getElementById("userInput").value = text;
                sendMessage();
            }

            document.getElementById("userInput").addEventListener("keypress", function (event) {
                if (event.key === "Enter")
                    sendMessage();
            });

            window.onload = function () {
                var chatBox = document.getElementById("chatBox");
                chatBox.scrollTop = chatBox.scrollHeight;
            };
        </script>
    </body>
</html>