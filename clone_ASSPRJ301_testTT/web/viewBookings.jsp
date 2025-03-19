<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Date"%>
<%@page import="dto.BookingDTO"%>
<%@page import="dto.RoomDTO"%>
<%@page import="dto.UserDTO"%>
<%@page import="dao.BookingDAO"%>
<%
    List<BookingDTO> bookingList = (List<BookingDTO>) request.getAttribute("bookingList");
    List<BookingDTO> transactionList = (List<BookingDTO>) request.getAttribute("transactionList");
    Integer bookingPage = (Integer) request.getAttribute("bookingPage");
    Integer totalBookingPages = (Integer) request.getAttribute("totalBookingPages");
    Integer transactionPage = (Integer) request.getAttribute("transactionPage");
    Integer totalTransactionPages = (Integer) request.getAttribute("totalTransactionPages");
    String bookingStatusFilter = (String) request.getAttribute("bookingStatusFilter");
    String bookingStartDate = (String) request.getAttribute("bookingStartDate");
    String bookingEndDate = (String) request.getAttribute("bookingEndDate");
    String bookingSortBy = (String) request.getAttribute("bookingSortBy");
    String transactionStatusFilter = (String) request.getAttribute("transactionStatusFilter");
    String transactionStartDate = (String) request.getAttribute("transactionStartDate");
    String transactionEndDate = (String) request.getAttribute("transactionEndDate");
    String transactionSortBy = (String) request.getAttribute("transactionSortBy");
    String errorMessage = (String) request.getAttribute("errorMessage");

    // Định dạng cho hiển thị ngày trong bảng
    SimpleDateFormat sdfDisplay = new SimpleDateFormat("dd/MM/yyyy");
    // Định dạng cho input type="date" (yyyy-MM-dd)
    SimpleDateFormat sdfInput = new SimpleDateFormat("yyyy-MM-dd");

    Date currentDate = new Date();
    UserDTO user = (UserDTO) session.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <title>Danh sách đặt phòng</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
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
                overflow-x: hidden;
            }
            .main-content {
                padding: 40px 20px;
                max-width: 1300px;
                margin: 0 auto;
                width: 95%;
            }
            .container {
                background: #ffffff;
                border-radius: 20px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
                padding: 40px;
                animation: fadeIn 0.5s ease-in;
                margin-bottom: 40px;
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
            .error-message {
                color: #e74c3c;
                background: #ffebee;
                padding: 15px;
                border-radius: 10px;
                margin-bottom: 25px;
                text-align: center;
                font-weight: 500;
            }
            .no-booking {
                text-align: center;
                padding: 30px;
                color: #7f8c8d;
                font-size: 18px;
                background: #f9fbfc;
                border-radius: 15px;
                box-shadow: 0 6px 20px rgba(0, 0, 0, 0.05);
            }
            .booking-table, .transaction-table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 30px;
                background: #fff;
                border-radius: 15px;
                overflow: hidden;
                box-shadow: 0 6px 20px rgba(0, 0, 0, 0.05);
                table-layout: fixed;
            }
            .booking-table th, .booking-table td, .transaction-table th, .transaction-table td {
                padding: 18px;
                text-align: center;
                border-bottom: 1px solid #eee;
                word-wrap: break-word;
            }
            .booking-table th, .transaction-table th {
                background: linear-gradient(45deg, #1abc9c, #16a085);
                color: white;
                font-weight: 600;
                text-transform: uppercase;
                width: 16.67%;
            }
            .booking-table tr:hover, .transaction-table tr:hover {
                background: #f5f7fa;
                transition: background 0.3s ease;
            }
            .booking-table .price, .transaction-table .price {
                font-weight: 600;
                color: #1abc9c;
            }
            .booking-table .status, .transaction-table .status {
                font-weight: 500;
            }
            .booking-table .status.cancelled, .transaction-table .status.cancelled {
                color: #e74c3c;
            }
            .booking-table .status.success, .transaction-table .status.success {
                color: #27ae60;
            }
            .booking-table .status.completed, .transaction-table .status.completed {
                color: #7f8c8d;
            }
            .booking-table .status.pending, .transaction-table .status.pending {
                color: #f1c40f;
            }
            .booking-table .actions {
                display: flex;
                justify-content: center;
                gap: 10px;
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
            .btn.cancel {
                background: #e74c3c;
            }
            .btn.cancel:hover {
                background: #c0392b;
                transform: scale(1.05);
            }
            .btn.view {
                background: #3498db;
            }
            .btn.view:hover {
                background: #2980b9;
                transform: scale(1.05);
            }
            .btn.pay {
                background: #f1c40f;
                color: #fff;
            }
            .btn.pay:hover {
                background: #d4ac0d;
                transform: scale(1.05);
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
            .filter-sort {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
                gap: 20px;
                flex-wrap: wrap;
            }
            .filter-sort select, .filter-sort input {
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 8px;
                font-size: 14px;
                background: #f9fbfc;
                transition: border-color 0.3s ease;
            }
            .filter-sort select:focus, .filter-sort input:focus {
                border-color: #1abc9c;
                outline: none;
            }
            .filter-sort label {
                margin-right: 10px;
                font-weight: 500;
                color: #2c3e50;
            }
            .filter-sort .date-filter {
                display: flex;
                gap: 10px;
                align-items: center;
            }
            @media (max-width: 768px) {
                .main-content {
                    padding: 20px 15px;
                }
                h2 {
                    font-size: 32px;
                }
                .booking-table th, .booking-table td, .transaction-table th, .transaction-table td {
                    padding: 12px;
                    font-size: 14px;
                }
                .btn {
                    padding: 8px 12px;
                    font-size: 14px;
                }
                .booking-table, .transaction-table {
                    display: block;
                    overflow-x: auto;
                    white-space: nowrap;
                }
                th {
                    width: auto;
                }
                .pagination a {
                    padding: 8px 12px;
                    font-size: 14px;
                }
                .filter-sort {
                    flex-direction: column;
                    align-items: flex-start;
                }
                .filter-sort .date-filter {
                    flex-direction: column;
                    align-items: flex-start;
                }
            }
        </style>
        <script>
            function confirmCancel(bookingId) {
                if (confirm("Bạn có chắc chắn muốn hủy đặt phòng này không?")) {
                    document.getElementById('cancelForm_' + bookingId).submit();
                }
            }
        </script>
    </head>
    <body>
        <div class="main-content">
            <!-- Danh sách đặt phòng -->
            <div class="container">
                <h2>Danh sách đặt phòng của bạn</h2>
                <a href="<%= request.getContextPath()%>/home.jsp" class="back-link"><i class="fas fa-arrow-left"></i> Quay lại trang chủ</a>

                <% if (errorMessage != null) {%>
                <p class="error-message"><%= errorMessage%></p>
                <% } %>

                <!-- Bộ lọc và sắp xếp cho danh sách đặt phòng -->
                <form action="<%= request.getContextPath()%>/viewBookings" method="get">
                    <div class="filter-sort">
                        <div>
                            <label for="bookingStatusFilter">Lọc theo trạng thái:</label>
                            <select id="bookingStatusFilter" name="bookingStatusFilter" onchange="this.form.submit()">
                                <option value="all" <%= "all".equals(bookingStatusFilter) || bookingStatusFilter == null ? "selected" : ""%>>Tất cả</option>
                                <option value="pending" <%= "pending".equals(bookingStatusFilter) ? "selected" : ""%>>Chờ thanh toán</option>
                                <option value="paid" <%= "paid".equals(bookingStatusFilter) ? "selected" : ""%>>Đã thanh toán</option>
                                <option value="cancelled" <%= "cancelled".equals(bookingStatusFilter) ? "selected" : ""%>>Đã hủy</option>
                                <option value="completed" <%= "completed".equals(bookingStatusFilter) ? "selected" : ""%>>Đã ở</option>
                            </select>
                        </div>
                        <div class="date-filter">
                            <label for="bookingStartDate">Từ ngày:</label>
                            <input type="date" id="bookingStartDate" name="bookingStartDate" value="<%= bookingStartDate != null ? bookingStartDate : ""%>" onchange="this.form.submit()">
                            <label for="bookingEndDate">Đến ngày:</label>
                            <input type="date" id="bookingEndDate" name="bookingEndDate" value="<%= bookingEndDate != null ? bookingEndDate : ""%>" onchange="this.form.submit()">
                        </div>
                        <div>
                            <label for="bookingSortBy">Sắp xếp theo:</label>
                            <select id="bookingSortBy" name="bookingSortBy" onchange="this.form.submit()">
                                <option value="" <%= bookingSortBy == null ? "selected" : ""%>>Mặc định</option>
                                <option value="dateAsc" <%= "dateAsc".equals(bookingSortBy) ? "selected" : ""%>>Ngày (Cũ nhất trước)</option>
                                <option value="dateDesc" <%= "dateDesc".equals(bookingSortBy) ? "selected" : ""%>>Ngày (Mới nhất trước)</option>
                                <option value="statusAsc" <%= "statusAsc".equals(bookingSortBy) ? "selected" : ""%>>Trạng thái (A-Z)</option>
                                <option value="statusDesc" <%= "statusDesc".equals(bookingSortBy) ? "selected" : ""%>>Trạng thái (Z-A)</option>
                            </select>
                        </div>
                    </div>
                    <!-- Ẩn các tham số khác để giữ trạng thái phân trang và bộ lọc của lịch sử giao dịch -->
                    <input type="hidden" name="bookingPage" value="<%= bookingPage != null ? bookingPage : 1 %>">
                    <input type="hidden" name="transactionPage" value="<%= transactionPage != null ? transactionPage : 1 %>">
                    <input type="hidden" name="transactionStatusFilter" value="<%= transactionStatusFilter != null ? transactionStatusFilter : "all" %>">
                    <input type="hidden" name="transactionStartDate" value="<%= transactionStartDate != null ? transactionStartDate : "" %>">
                    <input type="hidden" name="transactionEndDate" value="<%= transactionEndDate != null ? transactionEndDate : "" %>">
                    <input type="hidden" name="transactionSortBy" value="<%= transactionSortBy != null ? transactionSortBy : "" %>">
                </form>

                <% if (bookingList == null || bookingList.isEmpty()) { %>
                <p class="no-booking">Bạn chưa có đặt phòng nào.</p>
                <% } else { %>
                <table class="booking-table">
                    <thead>
                        <tr>
                            <th>Tên phòng</th>
                            <th>Ngày nhận</th>
                            <th>Ngày trả</th>
                            <th>Giá</th>
                            <th>Trạng thái</th>
                            <th>Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (BookingDTO booking : bookingList) {
                                RoomDTO room = booking.getRoom();
                                String statusClass = "";
                                String displayStatus = "";

                                if (BookingDAO.STATUS_CANCELLED.equals(booking.getStatus())) {
                                    statusClass = "cancelled";
                                    displayStatus = "Đã hủy";
                                } else if (BookingDAO.STATUS_PAID.equals(booking.getStatus()) || BookingDAO.STATUS_CONFIRMED.equals(booking.getStatus())) {
                                    statusClass = "success";
                                    displayStatus = "Đã thanh toán";
                                } else if (BookingDAO.STATUS_PENDING_PAYMENT.equals(booking.getStatus())) {
                                    statusClass = "pending";
                                    displayStatus = "Chờ thanh toán";
                                } else if (currentDate.after(booking.getCheckOutDate())) {
                                    statusClass = "completed";
                                    displayStatus = "Đã ở";
                                }
                        %>
                        <tr>
                            <td><%= room != null ? room.getName() : "Không xác định"%></td>
                            <td><%= sdfDisplay.format(booking.getCheckInDate())%></td>
                            <td><%= sdfDisplay.format(booking.getCheckOutDate())%></td>
                            <td class="price"><%= String.format("%,.0f", booking.getTotalPrice())%> VND</td>
                            <td class="status <%= statusClass%>"><%= displayStatus%></td>
                            <td class="actions">
                                <% if (BookingDAO.STATUS_PENDING_PAYMENT.equals(booking.getStatus()) && currentDate.before(booking.getCheckOutDate())) {%>
                                <form id="paymentForm_<%= booking.getId()%>" action="<%= request.getContextPath()%>/processPayment" method="post" style="display:inline;">
                                    <input type="hidden" name="bookingId" value="<%= booking.getId()%>">
                                    <input type="hidden" name="amount" value="<%= booking.getTotalPrice()%>">
                                    <button type="submit" class="btn pay"><i class="fas fa-credit-card"></i> Thanh toán</button>
                                </form>
                                <form id="cancelForm_<%= booking.getId()%>" action="<%= request.getContextPath()%>/cancelBooking" method="post" style="display:inline;">
                                    <input type="hidden" name="bookingId" value="<%= booking.getId()%>">
                                    <button type="button" class="btn cancel" onclick="confirmCancel('<%= booking.getId()%>')"><i class="fas fa-times"></i> Hủy</button>
                                </form>
                                <% } %>
                                <% if (room != null) {%>
                                <form action="<%= request.getContextPath()%>/room-details" method="get" style="display:inline;">
                                    <input type="hidden" name="roomId" value="<%= room.getId()%>">
                                    <button type="submit" class="btn view"><i class="fas fa-eye"></i> Xem</button>
                                </form>
                                <% } %>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>

                <!-- Phân trang cho danh sách đặt phòng -->
                <div class="pagination">
                    <% if (bookingPage > 1) { %>
                    <a href="<%= request.getContextPath()%>/viewBookings?bookingPage=<%= bookingPage - 1%>&bookingStatusFilter=<%= bookingStatusFilter != null ? bookingStatusFilter : "all"%>&bookingStartDate=<%= bookingStartDate != null ? bookingStartDate : ""%>&bookingEndDate=<%= bookingEndDate != null ? bookingEndDate : ""%>&bookingSortBy=<%= bookingSortBy != null ? bookingSortBy : ""%>&transactionPage=<%= transactionPage%>&transactionStatusFilter=<%= transactionStatusFilter != null ? transactionStatusFilter : "all"%>&transactionStartDate=<%= transactionStartDate != null ? transactionStartDate : ""%>&transactionEndDate=<%= transactionEndDate != null ? transactionEndDate : ""%>&transactionSortBy=<%= transactionSortBy != null ? transactionSortBy : ""%>">Trang trước</a>
                    <% } else { %>
                    <a href="#" class="disabled">Trang trước</a>
                    <% } %>

                    <% for (int i = 1; i <= totalBookingPages; i++) { %>
                    <a href="<%= request.getContextPath()%>/viewBookings?bookingPage=<%= i%>&bookingStatusFilter=<%= bookingStatusFilter != null ? bookingStatusFilter : "all"%>&bookingStartDate=<%= bookingStartDate != null ? bookingStartDate : ""%>&bookingEndDate=<%= bookingEndDate != null ? bookingEndDate : ""%>&bookingSortBy=<%= bookingSortBy != null ? bookingSortBy : ""%>&transactionPage=<%= transactionPage%>&transactionStatusFilter=<%= transactionStatusFilter != null ? transactionStatusFilter : "all"%>&transactionStartDate=<%= transactionStartDate != null ? transactionStartDate : ""%>&transactionEndDate=<%= transactionEndDate != null ? transactionEndDate : ""%>&transactionSortBy=<%= transactionSortBy != null ? transactionSortBy : ""%>" class="<%= (i == bookingPage) ? "active" : ""%>"><%= i%></a>
                    <% } %>

                    <% if (bookingPage < totalBookingPages) { %>
                    <a href="<%= request.getContextPath()%>/viewBookings?bookingPage=<%= bookingPage + 1%>&bookingStatusFilter=<%= bookingStatusFilter != null ? bookingStatusFilter : "all"%>&bookingStartDate=<%= bookingStartDate != null ? bookingStartDate : ""%>&bookingEndDate=<%= bookingEndDate != null ? bookingEndDate : ""%>&bookingSortBy=<%= bookingSortBy != null ? bookingSortBy : ""%>&transactionPage=<%= transactionPage%>&transactionStatusFilter=<%= transactionStatusFilter != null ? transactionStatusFilter : "all"%>&transactionStartDate=<%= transactionStartDate != null ? transactionStartDate : ""%>&transactionEndDate=<%= transactionEndDate != null ? transactionEndDate : ""%>&transactionSortBy=<%= transactionSortBy != null ? transactionSortBy : ""%>">Trang sau</a>
                    <% } else { %>
                    <a href="#" class="disabled">Trang sau</a>
                    <% } %>
                </div>
                <% } %>
            </div>

            <!-- Lịch sử giao dịch -->
            <div class="container">
                <h2>Lịch sử giao dịch</h2>

                <!-- Bộ lọc và sắp xếp cho lịch sử giao dịch -->
                <form action="<%= request.getContextPath()%>/viewBookings" method="get">
                    <div class="filter-sort">
                        <div>
                            <label for="transactionStatusFilter">Lọc theo trạng thái:</label>
                            <select id="transactionStatusFilter" name="transactionStatusFilter" onchange="this.form.submit()">
                                <option value="all" <%= "all".equals(transactionStatusFilter) || transactionStatusFilter == null ? "selected" : ""%>>Tất cả</option>
                                <option value="paid" <%= "paid".equals(transactionStatusFilter) ? "selected" : ""%>>Thành công</option>
                                <option value="cancelled" <%= "cancelled".equals(transactionStatusFilter) ? "selected" : ""%>>Đã hủy</option>
                            </select>
                        </div>
                        <div class="date-filter">
                            <label for="transactionStartDate">Từ ngày:</label>
                            <input type="date" id="transactionStartDate" name="transactionStartDate" value="<%= transactionStartDate != null ? transactionStartDate : ""%>" onchange="this.form.submit()">
                            <label for="transactionEndDate">Đến ngày:</label>
                            <input type="date" id="transactionEndDate" name="transactionEndDate" value="<%= transactionEndDate != null ? transactionEndDate : ""%>" onchange="this.form.submit()">
                        </div>
                        <div>
                            <label for="transactionSortBy">Sắp xếp theo:</label>
                            <select id="transactionSortBy" name="transactionSortBy" onchange="this.form.submit()">
                                <option value="" <%= transactionSortBy == null ? "selected" : ""%>>Mặc định</option>
                                <option value="dateAsc" <%= "dateAsc".equals(transactionSortBy) ? "selected" : ""%>>Ngày (Cũ nhất trước)</option>
                                <option value="dateDesc" <%= "dateDesc".equals(transactionSortBy) ? "selected" : ""%>>Ngày (Mới nhất trước)</option>
                                <option value="statusAsc" <%= "statusAsc".equals(transactionSortBy) ? "selected" : ""%>>Trạng thái (A-Z)</option>
                                <option value="statusDesc" <%= "statusDesc".equals(transactionSortBy) ? "selected" : ""%>>Trạng thái (Z-A)</option>
                            </select>
                        </div>
                    </div>
                    <!-- Ẩn các tham số khác để giữ trạng thái phân trang và bộ lọc của danh sách đặt phòng -->
                    <input type="hidden" name="bookingPage" value="<%= bookingPage != null ? bookingPage : 1 %>">
                    <input type="hidden" name="bookingStatusFilter" value="<%= bookingStatusFilter != null ? bookingStatusFilter : "all" %>">
                    <input type="hidden" name="bookingStartDate" value="<%= bookingStartDate != null ? bookingStartDate : "" %>">
                    <input type="hidden" name="bookingEndDate" value="<%= bookingEndDate != null ? bookingEndDate : "" %>">
                    <input type="hidden" name="bookingSortBy" value="<%= bookingSortBy != null ? bookingSortBy : "" %>">
                    <input type="hidden" name="transactionPage" value="<%= transactionPage != null ? transactionPage : 1 %>">
                </form>

                <% if (transactionList == null || transactionList.isEmpty()) { %>
                <p class="no-booking">Bạn chưa có giao dịch nào.</p>
                <% } else { %>
                <table class="transaction-table">
                    <thead>
                        <tr>
                            <th>Tên phòng</th>
                            <th>Ngày giao dịch</th>
                            <th>Số tiền</th>
                            <th>Trạng thái</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (BookingDTO transaction : transactionList) {
                                RoomDTO room = transaction.getRoom();
                                String statusClass = "";
                                String displayStatus = "";

                                if (BookingDAO.STATUS_CANCELLED.equals(transaction.getStatus())) {
                                    statusClass = "cancelled";
                                    displayStatus = "Đã hủy";
                                } else if (BookingDAO.STATUS_PAID.equals(transaction.getStatus()) || BookingDAO.STATUS_CONFIRMED.equals(transaction.getStatus())) {
                                    statusClass = "success";
                                    displayStatus = "Thành công";
                                }
                        %>
                        <tr>
                            <td><%= room != null ? room.getName() : "Không xác định"%></td>
                            <td><%= sdfDisplay.format(transaction.getCreatedAt())%></td>
                            <td class="price"><%= String.format("%,.0f", transaction.getTotalPrice())%> VND</td>
                            <td class="status <%= statusClass%>"><%= displayStatus%></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>

                <!-- Phân trang cho lịch sử giao dịch -->
                <div class="pagination">
                    <% if (transactionPage > 1) { %>
                    <a href="<%= request.getContextPath()%>/viewBookings?bookingPage=<%= bookingPage%>&bookingStatusFilter=<%= bookingStatusFilter != null ? bookingStatusFilter : "all"%>&bookingStartDate=<%= bookingStartDate != null ? bookingStartDate : ""%>&bookingEndDate=<%= bookingEndDate != null ? bookingEndDate : ""%>&bookingSortBy=<%= bookingSortBy != null ? bookingSortBy : ""%>&transactionPage=<%= transactionPage - 1%>&transactionStatusFilter=<%= transactionStatusFilter != null ? transactionStatusFilter : "all"%>&transactionStartDate=<%= transactionStartDate != null ? transactionStartDate : ""%>&transactionEndDate=<%= transactionEndDate != null ? transactionEndDate : ""%>&transactionSortBy=<%= transactionSortBy != null ? transactionSortBy : ""%>">Trang trước</a>
                    <% } else { %>
                    <a href="#" class="disabled">Trang trước</a>
                    <% } %>

                    <% for (int i = 1; i <= totalTransactionPages; i++) { %>
                    <a href="<%= request.getContextPath()%>/viewBookings?bookingPage=<%= bookingPage%>&bookingStatusFilter=<%= bookingStatusFilter != null ? bookingStatusFilter : "all"%>&bookingStartDate=<%= bookingStartDate != null ? bookingStartDate : ""%>&bookingEndDate=<%= bookingEndDate != null ? bookingEndDate : ""%>&bookingSortBy=<%= bookingSortBy != null ? bookingSortBy : ""%>&transactionPage=<%= i%>&transactionStatusFilter=<%= transactionStatusFilter != null ? transactionStatusFilter : "all"%>&transactionStartDate=<%= transactionStartDate != null ? transactionStartDate : ""%>&transactionEndDate=<%= transactionEndDate != null ? transactionEndDate : ""%>&transactionSortBy=<%= transactionSortBy != null ? transactionSortBy : ""%>" class="<%= (i == transactionPage) ? "active" : ""%>"><%= i%></a>
                    <% } %>

                    <% if (transactionPage < totalTransactionPages) { %>
                    <a href="<%= request.getContextPath()%>/viewBookings?bookingPage=<%= bookingPage%>&bookingStatusFilter=<%= bookingStatusFilter != null ? bookingStatusFilter : "all"%>&bookingStartDate=<%= bookingStartDate != null ? bookingStartDate : ""%>&bookingEndDate=<%= bookingEndDate != null ? bookingEndDate : ""%>&bookingSortBy=<%= bookingSortBy != null ? bookingSortBy : ""%>&transactionPage=<%= transactionPage + 1%>&transactionStatusFilter=<%= transactionStatusFilter != null ? transactionStatusFilter : "all"%>&transactionStartDate=<%= transactionStartDate != null ? transactionStartDate : ""%>&transactionEndDate=<%= transactionEndDate != null ? transactionEndDate : ""%>&transactionSortBy=<%= transactionSortBy != null ? transactionSortBy : ""%>">Trang sau</a>
                    <% } else { %>
                    <a href="#" class="disabled">Trang sau</a>
                    <% } %>
                </div>
                <% } %>
            </div>
        </div>
    </body>
</html>