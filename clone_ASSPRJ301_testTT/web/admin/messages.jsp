<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dto.ContactMessageDTO"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<% request.setCharacterEncoding("UTF-8");%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý tin nhắn - Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
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
            display: flex;
            flex-direction: column;
            overflow-x: hidden;
        }
        .main-content {
            flex: 1;
            padding: 100px 20px;
            max-width: 1300px;
            margin: 0 auto;
            width: 95%;
        }
        .messages-container {
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
        h1 {
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
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 30px;
            background: #fff;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.05);
        }
        th, td {
            padding: 18px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        th {
            background: linear-gradient(45deg, #1abc9c, #16a085);
            color: white;
            font-weight: 600;
            text-transform: uppercase;
        }
        tr:hover {
            background: #f5f7fa;
            transition: background 0.3s ease;
        }
        .status {
            font-weight: 500;
        }
        .status.unread {
            color: #f1c40f;
        }
        .status.read {
            color: #27ae60;
        }
        .btn {
            padding: 10px 18px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            color: white;
            transition: transform 0.3s ease, background 0.3s ease;
        }
        .btn-mark-read {
            background: #3498db;
        }
        .btn-mark-read:hover {
            background: #2980b9;
            transform: scale(1.05);
        }
        .message {
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 25px;
            text-align: center;
            font-weight: 500;
        }
        .message.success {
            background: #e8f5e9;
            color: #27ae60;
        }
        .message.error {
            background: #ffebee;
            color: #e74c3c;
        }
        .message.info {
            background: #e8eaf6;
            color: #3498db;
        }
        .no-data {
            text-align: center;
            padding: 30px;
            color: #7f8c8d;
            font-size: 18px;
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
            h1 {
                font-size: 32px;
            }
            th, td {
                padding: 12px;
                font-size: 14px;
            }
            .btn {
                padding: 8px 12px;
                font-size: 14px;
            }
            table {
                display: block;
                overflow-x: auto;
                white-space: nowrap;
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
        <%@include file="../header.jsp" %>
    </div>

    <div class="main-content">
        <div class="messages-container">
            <h1>Quản lý tin nhắn</h1>
            <a href="<%= request.getContextPath() %>/admin/dashboard.jsp" class="back-link"><i class="fas fa-arrow-left"></i> Quay lại Dashboard</a>

            <% 
                String successMessage = (String) request.getAttribute("successMessage");
                String errorMessage = (String) request.getAttribute("errorMessage");
                String infoMessage = (String) request.getAttribute("infoMessage");
                if (successMessage != null && !successMessage.isEmpty()) {
            %>
                <div class="message success"><%= successMessage %></div>
            <% 
                } else if (errorMessage != null && !errorMessage.isEmpty()) {
            %>
                <div class="message error"><%= errorMessage %></div>
            <% 
                } else if (infoMessage != null && !infoMessage.isEmpty()) {
            %>
                <div class="message info"><%= infoMessage %></div>
            <% 
                } 
            %>

            <% 
                List<ContactMessageDTO> messageList = (List<ContactMessageDTO>) request.getAttribute("messageList");
                SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
                if (messageList == null || messageList.isEmpty()) {
            %>
                <p class="no-data">Không có tin nhắn nào từ người dùng.</p>
            <% 
                } else {
                    // Phân trang
                    final int ITEMS_PER_PAGE = 5; // Số lượng tin nhắn trên mỗi trang
                    int currentPage = 1;
                    String pageParam = request.getParameter("page");
                    if (pageParam != null) {
                        try {
                            currentPage = Integer.parseInt(pageParam);
                        } catch (NumberFormatException e) {
                            currentPage = 1;
                        }
                    }

                    int totalMessages = messageList.size();
                    int totalPages = (int) Math.ceil((double) totalMessages / ITEMS_PER_PAGE);
                    if (currentPage < 1) currentPage = 1;
                    if (currentPage > totalPages) currentPage = totalPages;

                    int start = (currentPage - 1) * ITEMS_PER_PAGE;
                    int end = Math.min(start + ITEMS_PER_PAGE, totalMessages);
                    List<ContactMessageDTO> messagesToShow = totalMessages > 0 ? messageList.subList(start, end) : messageList;
            %>
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Người gửi</th>
                            <th>Email</th>
                            <th>Điện thoại</th>
                            <th>Tin nhắn</th>
                            <th>Thời gian</th>
                            <th>Trạng thái</th>
                            <th>Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            for (ContactMessageDTO message : messagesToShow) {
                                String statusClass = message.isRead() ? "read" : "unread";
                                String displayStatus = message.isRead() ? "Đã đọc" : "Chưa đọc";
                        %>
                            <tr>
                                <td><%= message.getId() %></td>
                                <td>
                                    <%= message.getFullName() %>
                                    <% if (message.getUserId() != null) { %>
                                        (<%= message.getUserId() %>)
                                    <% } %>
                                </td>
                                <td><%= message.getEmail() %></td>
                                <td><%= message.getPhone() != null ? message.getPhone() : "" %></td>
                                <td><%= message.getMessage() %></td>
                                <td><%= dateFormat.format(message.getCreatedAt()) %></td>
                                <td class="status <%= statusClass %>"><%= displayStatus %></td>
                                <td>
                                    <% if (!message.isRead()) { %>
                                        <form action="<%= request.getContextPath() %>/admin/messages?action=markAsRead" method="post" style="display:inline;">
                                            <input type="hidden" name="messageId" value="<%= message.getId() %>">
                                            <input type="hidden" name="page" value="<%= currentPage %>">
                                            <button type="submit" class="btn btn-mark-read"><i class="fas fa-check"></i> Đánh dấu đã đọc</button>
                                        </form>
                                    <% } %>
                                </td>
                            </tr>
                        <% 
                            }
                        %>
                    </tbody>
                </table>

                <!-- Phân trang -->
                <div class="pagination">
                    <% if (currentPage > 1) { %>
                    <a href="<%= request.getContextPath()%>/admin/messages?page=<%= currentPage - 1%>">Trang trước</a>
                    <% } else { %>
                    <a href="#" class="disabled">Trang trước</a>
                    <% } %>

                    <% for (int i = 1; i <= totalPages; i++) { %>
                    <a href="<%= request.getContextPath()%>/admin/messages?page=<%= i%>" class="<%= (i == currentPage) ? "active" : ""%>"><%= i%></a>
                    <% } %>

                    <% if (currentPage < totalPages) { %>
                    <a href="<%= request.getContextPath()%>/admin/messages?page=<%= currentPage + 1%>">Trang sau</a>
                    <% } else { %>
                    <a href="#" class="disabled">Trang sau</a>
                    <% } %>
                </div>
            <% 
                }
            %>
        </div>
    </div>

    <div class="footer-container">
        <%@include file="../footer.jsp" %>
    </div>
</body>
</html>