<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dto.NotificationDTO"%>
<%@page import="dao.NotificationDAO"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="dto.UserDTO"%>
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
                position: relative;
            }
            .notification-item:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
            }
            .notification-item.unread {
                background: #e8f5e9;
                border-left: 5px solid #27ae60;
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
                transition: transform 0.3s ease, background 0.3s ease, opacity 0.3s ease;
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
            .temp-message {
                position: fixed;
                top: 20px;
                right: 20px;
                padding: 15px 25px;
                border-radius: 8px;
                color: white;
                font-weight: 500;
                z-index: 1000;
                animation: slideIn 0.5s ease-out, fadeOut 0.5s ease-out 2.5s forwards;
            }
            .temp-message.success {
                background: #27ae60;
            }
            .temp-message.error {
                background: #e74c3c;
            }
            @keyframes slideIn {
                from { transform: translateX(100%); opacity: 0; }
                to { transform: translateX(0); opacity: 1; }
            }
            @keyframes fadeOut {
                from { opacity: 1; }
                to { opacity: 0; }
            }
            .pagination {
                display: flex;
                justify-content: center;
                margin-top: 30px;
                gap: 10px;
            }
            .pagination a {
                padding: 10px 15px;
                background: #1abc9c;
                color: white;
                text-decoration: none;
                border-radius: 8px;
                font-weight: 500;
                transition: background 0.3s ease, transform 0.3s ease;
            }
            .pagination a:hover {
                background: #16a085;
                transform: scale(1.05);
            }
            .pagination a.disabled {
                background: #bdc3c7;
                cursor: not-allowed;
                pointer-events: none;
            }
            .pagination a.active {
                background: #16a085;
                font-weight: 700;
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
                .pagination a {
                    padding: 8px 12px;
                    font-size: 14px;
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
                    List<NotificationDTO> notifications = notificationDAO.getNotificationsByUserId(user.getUserID());
                    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");

                    // Phân trang
                    final int ITEMS_PER_PAGE = 5; // Số lượng thông báo trên mỗi trang
                    int currentPage = 1;
                    String pageParam = request.getParameter("page");
                    if (pageParam != null) {
                        try {
                            currentPage = Integer.parseInt(pageParam);
                        } catch (NumberFormatException e) {
                            currentPage = 1;
                        }
                    }

                    int totalNotifications = notifications.size();
                    int totalPages = (int) Math.ceil((double) totalNotifications / ITEMS_PER_PAGE);
                    if (currentPage < 1) currentPage = 1;
                    if (currentPage > totalPages) currentPage = totalPages;

                    int start = (currentPage - 1) * ITEMS_PER_PAGE;
                    int end = Math.min(start + ITEMS_PER_PAGE, totalNotifications);
                    List<NotificationDTO> notificationsToShow = totalNotifications > 0 ? notifications.subList(start, end) : notifications;

                    if (notifications.isEmpty()) {
                %>
                <p class="no-notifications">Bạn chưa có thông báo nào.</p>
                <%
                } else {
                %>
                <div class="notification-list">
                    <% for (NotificationDTO notification : notificationsToShow) {%>
                    <div class="notification-item <%= notification.isIsRead() ? "" : "unread"%>" id="notification-<%= notification.getNotificationId()%>">
                        <p class="message"><%= notification.getMessage()%></p>
                        <p class="timestamp"><small><%= dateFormat.format(notification.getCreatedAt())%></small></p>
                        <% if (!notification.isIsRead()) {%>
                        <button class="btn-mark-read" onclick="markAsRead(<%= notification.getNotificationId()%>)">Đánh dấu đã đọc</button>
                        <% } %>
                    </div>
                    <% } %>
                </div>

                <!-- Phân trang -->
                <div class="pagination">
                    <% if (currentPage > 1) { %>
                    <a href="<%= request.getContextPath()%>/notifications.jsp?page=<%= currentPage - 1%>">Trang trước</a>
                    <% } else { %>
                    <a href="#" class="disabled">Trang trước</a>
                    <% } %>

                    <% for (int i = 1; i <= totalPages; i++) { %>
                    <a href="<%= request.getContextPath()%>/notifications.jsp?page=<%= i%>" class="<%= (i == currentPage) ? "active" : ""%>"><%= i%></a>
                    <% } %>

                    <% if (currentPage < totalPages) { %>
                    <a href="<%= request.getContextPath()%>/notifications.jsp?page=<%= currentPage + 1%>">Trang sau</a>
                    <% } else { %>
                    <a href="#" class="disabled">Trang sau</a>
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
                        const notificationItem = $('#notification-' + notificationId);
                        notificationItem.removeClass('unread');
                        notificationItem.find('.btn-mark-read').fadeOut(300, function() {
                            $(this).remove();
                        });
                        showTempMessage('Thông báo đã được đánh dấu là đã đọc!', 'success');
                    },
                    error: function () {
                        showTempMessage('Có lỗi xảy ra khi đánh dấu đã đọc.', 'error');
                    }
                });
            }

            function showTempMessage(message, type) {
                const tempMessage = $('<div/>', {
                    class: 'temp-message ' + type,
                    text: message
                });
                $('body').append(tempMessage);
                setTimeout(() => tempMessage.remove(), 1000);
            }
        </script>
    </body>
</html>