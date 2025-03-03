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

        .main-content {
            flex: 1;
            padding: 80px 0;
            max-width: 1200px;
            margin: 0 auto;
            width: 90%;
        }

        .notifications-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
            padding: 30px;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .notifications-container:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 35px rgba(0, 0, 0, 0.15);
        }

        h2 {
            font-size: 36px;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 30px;
            text-align: center;
        }

        .back-link {
            display: inline-block;
            color: #3498db;
            text-decoration: none;
            font-weight: 600;
            margin-bottom: 20px;
            transition: color 0.3s ease;
        }

        .back-link:hover {
            color: #2980b9;
        }

        .notification-list {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .notification-item {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .notification-item:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }

        .notification-item.unread {
            background: #e8f5e9;
        }

        .notification-item p {
            margin: 5px 0;
            font-size: 16px;
            color: #555;
        }

        .notification-item small {
            font-size: 14px;
            color: #7f8c8d;
        }

        .btn-mark-read {
            background: #3498db;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.3s ease, transform 0.2s ease;
        }

        .btn-mark-read:hover {
            background: #2980b9;
            transform: scale(1.05);
        }

        @media (max-width: 768px) {
            .main-content {
                padding: 60px 15px;
            }

            h2 {
                font-size: 28px;
            }

            .notification-item {
                padding: 12px;
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
            <a href="<%= request.getContextPath() %>/home.jsp" class="back-link">← Quay lại trang chủ</a>

            <%
                if (user == null) {
            %>
            <p style="text-align: center;">Vui lòng đăng nhập để xem thông báo!</p>
            <%
                } else {
                    NotificationDAO notificationDAO = new NotificationDAO();
                    List<NotificationDTO> notifications = notificationDAO.getNotificationsByUserId(user.getUserID());
                    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
                    if (notifications.isEmpty()) {
            %>
            <p style="text-align: center;">Bạn chưa có thông báo nào.</p>
            <%
                    } else {
            %>
            <div class="notification-list">
                <% for (NotificationDTO notification : notifications) { %>
                <div class="notification-item <%= notification.isIsRead() ? "" : "unread" %>">
                    <p><%= notification.getMessage() %></p>
                    <p><small><%= dateFormat.format(notification.getCreatedAt()) %></small></p>
                    <% if (!notification.isIsRead()) { %>
                    <button class="btn-mark-read" onclick="markAsRead(<%= notification.getNotificationId() %>)">Đánh dấu đã đọc</button>
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

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        function markAsRead(notificationId) {
            $.ajax({
                url: '<%= request.getContextPath() %>/markNotificationAsRead',
                type: 'POST',
                data: { notificationId: notificationId },
                success: function(response) {
                    location.reload(); // Làm mới trang để cập nhật giao diện
                },
                error: function() {
                    alert('Có lỗi xảy ra khi đánh dấu đã đọc.');
                }
            });
        }
    </script>
</body>
</html>