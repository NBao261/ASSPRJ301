<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dto.NotificationDTO"%>
<%@page import="dao.NotificationDAO"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thông báo</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Poppins', 'Segoe UI', Arial, sans-serif;
            }
            body {
                background: linear-gradient(120deg, #e0eafc 0%, #cfdef3 100%);
                color: #2c3e50;
                min-height: 100vh;
                padding-top: 80px;
                overflow-x: hidden;
            }
            .main-content {
                flex: 1;
                padding: 100px 20px;
                max-width: 1300px;
                margin: 0 auto;
                width: 95%;
            }
            .notifications-container {
                background: #ffffff;
                border-radius: 20px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
                padding: 40px;
                animation: fadeIn 0.5s ease-in;
            }
            @keyframes fadeIn {
                from { opacity: 0; transform: translateY(20px); }
                to { opacity: 1; transform: translateY(0); }
            }
            h2 {
                font-size: 42px;
                font-weight: 700;
                color: #1a3c34;
                margin-bottom: 30px;
                text-align: center;
                text-transform: uppercase;
                letter-spacing: 1px;
            }
            .back-link {
                display: inline-flex;
                align-items: center;
                color: #1abc9c;
                text-decoration: none;
                font-weight: 600;
                margin-bottom: 25px;
                transition: color 0.3s ease, transform 0.3s ease;
            }
            .back-link:hover {
                color: #16a085;
                transform: translateX(-5px);
            }
            .back-link i {
                margin-right: 8px;
            }
            .notification-list {
                display: flex;
                flex-direction: column;
                gap: 15px;
            }
            .notification-item {
                background: #f9fbfc;
                padding: 20px;
                border-radius: 15px;
                box-shadow: 0 6px 20px rgba(0, 0, 0, 0.05);
                transition: transform 0.3s ease, box-shadow 0.3s ease;
                display: flex;
                flex-direction: column;
                gap: 8px;
            }
            .notification-item:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
            }
            .notification-item.unread {
                background: #e8f5e9;
                border-left: 5px solid #27ae60; /* Đánh dấu thông báo chưa đọc */
            }
            .notification-item p {
                margin: 0;
                font-size: 16px;
                color: #34495e;
                line-height: 1.5;
            }
            .notification-item .message {
                font-weight: 500;
            }
            .notification-item .timestamp {
                font-size: 14px;
                color: #7f8c8d;
            }
            .btn-mark-read {
                background: linear-gradient(45deg, #3498db, #2980b9);
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 8px;
                font-size: 14px;
                font-weight: 600;
                cursor: pointer;
                transition: transform 0.3s ease, background 0.3s ease;
                align-self: flex-start;
                margin-top: 10px;
            }
            .btn-mark-read:hover {
                background: linear-gradient(45deg, #2980b9, #1f6391);
                transform: scale(1.05);
            }
            .no-notifications {
                text-align: center;
                padding: 30px;
                color: #7f8c8d;
                font-size: 18px;
                background: #f9fbfc;
                border-radius: 15px;
                box-shadow: 0 6px 20px rgba(0, 0, 0, 0.05);
            }
            @media (max-width: 768px) {
                .main-content {
                    padding: 60px 15px;
                }
                h2 {
                    font-size: 32px;
                }
                .notification-item {
                    padding: 15px;
                }
                .btn-mark-read {
                    padding: 8px 15px;
                }
            }
        </style>
    </head>
    <body>
        <div class="header-container">
            <%@include file="header.jsp" %>
        </div>

        <div class="main-content">
            <div class="notifications-container">
                <h2>Thông báo</h2>
                <a href="<%= request.getContextPath()%>/home.jsp" class="back-link"><i class="fas fa-arrow-left"></i> Quay lại trang chủ</a>

                <%
                    if (user == null) {
                %>
                <p class="no-notifications">Vui lòng đăng nhập để xem thông báo!</p>
                <%
                } else {
                    NotificationDAO notificationDAO = new NotificationDAO();
                    List<NotificationDTO> notifications = notificationDAO.getNotificationsByUserId(user.getUserID());
                    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
                    if (notifications.isEmpty()) {
                %>
                <p class="no-notifications">Bạn chưa có thông báo nào.</p>
                <%
                } else {
                %>
                <div class="notification-list">
                    <% for (NotificationDTO notification : notifications) {%>
                    <div class="notification-item <%= notification.isIsRead() ? "" : "unread"%>">
                        <p class="message"><%= notification.getMessage()%></p>
                        <p class="timestamp"><small><%= dateFormat.format(notification.getCreatedAt())%></small></p>
                                <% if (!notification.isIsRead()) {%>
                        <button class="btn-mark-read" onclick="markAsRead(<%= notification.getNotificationId()%>)">Đánh dấu đã đọc</button>
                        <% } %>
                    </div>
                    <% } %>
                </div>
                <%
                        }
                    }
                %>
            </div>
        </div>

        <div class="footer-container">
            <%@include file="footer.jsp" %>
        </div>

        <script>
            function markAsRead(notificationId) {
                $.ajax({
                    url: '<%= request.getContextPath()%>/markNotificationAsRead',
                    type: 'POST',
                    data: {notificationId: notificationId},
                    success: function (response) {
                        location.reload(); // Làm mới trang để cập nhật giao diện
                    },
                    error: function () {
                        alert('Có lỗi xảy ra khi đánh dấu đã đọc.');
                    }
                });
            }
        </script>
    </body>
</html>