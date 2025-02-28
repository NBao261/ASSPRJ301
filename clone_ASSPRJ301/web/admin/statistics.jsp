<%@page import="dao.RoomDAO"%>
<%@page import="java.util.Map"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dto.RoomDTO"%>
<%@page import="java.util.Set"%>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thống kê - Admin</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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

        .stats-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
            padding: 30px;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .stats-container:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 35px rgba(0, 0, 0, 0.15);
        }

        h1, h2 {
            font-size: 36px;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 30px;
            text-align: center;
        }

        h2 {
            font-size: 24px;
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

        .filter-container {
            margin-bottom: 20px;
            text-align: center;
        }

        .filter-container select {
            padding: 8px;
            border-radius: 5px;
            border: 1px solid #ddd;
            font-size: 16px;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }

        .stat-item {
            background: #f8fafc;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
            transition: transform 0.3s ease;
        }

        .stat-item:hover {
            transform: scale(1.05);
        }

        .stat-label {
            font-size: 16px;
            color: #7f8c8d;
            margin-bottom: 10px;
        }

        .stat-value {
            font-size: 24px;
            font-weight: 700;
            color: #2c3e50;
        }

        .stat-value.revenue {
            color: #5DC1B9;
        }

        .stat-value.pending {
            color: #e67e22;
        }

        .stat-value.confirmed {
            color: #2ecc71;
        }

        .stat-value.cancelled {
            color: #e74c3c;
        }

        .chart-container {
            margin-top: 40px;
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
        }

        .revenue-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background: #f8fafc;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
        }

        .revenue-table th, .revenue-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        .revenue-table th {
            background: linear-gradient(45deg, #5DC1B9, #4ECDC4);
            color: white;
            font-weight: 600;
        }

        .message {
            padding: 10px;
            border-radius: 8px;
            margin-bottom: 20px;
            text-align: center;
        }

        .message.error {
            background: #ffebee;
            color: #e74c3c;
        }

        @media (max-width: 768px) {
            .main-content {
                padding: 60px 15px;
            }

            h1 {
                font-size: 28px;
            }

            h2 {
                font-size: 20px;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }

            .stat-value {
                font-size: 20px;
            }

            .chart-container {
                max-width: 100%;
            }

            .revenue-table {
                display: block;
                overflow-x: auto;
                white-space: nowrap;
            }
        }
    </style>
</head>
<body>
    <div class="header-container">
        <%@include file="../header.jsp" %>
    </div>

    <div class="main-content">
        <div class="stats-container">
            <h1>Thống kê</h1>
            <a href="<%= request.getContextPath() %>/admin/dashboard.jsp" class="back-link">← Quay lại Dashboard</a>

            <% 
                String errorMessage = (String) request.getAttribute("errorMessage");
                if (errorMessage != null) { 
            %>
                <div class="message error"><%= errorMessage %></div>
            <% } %>

            <!-- Bộ lọc thời gian động -->
            <div class="filter-container">
                <label for="timeFilter">Thời gian: </label>
                <select id="timeFilter" onchange="location.href='<%= request.getContextPath() %>/admin/statistics?time=' + this.value;">
                    <option value="all" <%= "all".equals(request.getParameter("time")) || request.getParameter("time") == null ? "selected" : "" %>>Tất cả</option>
                    <% 
                        Set<String> timeOptions = (Set<String>) request.getAttribute("timeOptions");
                        if (timeOptions != null) {
                            for (String time : timeOptions) {
                    %>
                    <option value="<%= time %>" <%= time.equals(request.getParameter("time")) ? "selected" : "" %>><%= time %></option>
                    <% 
                            }
                        }
                    %>
                </select>
            </div>

            <div class="stats-grid">
                <div class="stat-item">
                    <div class="stat-label">Tổng doanh thu (Đã xác nhận)</div>
                    <div class="stat-value revenue"><%= String.format("%,.0f", (Double) request.getAttribute("totalRevenue")) %> VND</div>
                </div>
                <div class="stat-item">
                    <div class="stat-label">Số đơn chờ xác nhận</div>
                    <div class="stat-value pending"><%= request.getAttribute("pendingCount") %></div>
                </div>
                <div class="stat-item">
                    <div class="stat-label">Số đơn đã xác nhận</div>
                    <div class="stat-value confirmed"><%= request.getAttribute("confirmedCount") %></div>
                </div>
                <div class="stat-item">
                    <div class="stat-label">Số đơn đã hủy</div>
                    <div class="stat-value cancelled"><%= request.getAttribute("cancelledCount") %></div>
                </div>
                <div class="stat-item">
                    <div class="stat-label">Số user hoạt động</div>
                    <div class="stat-value"><%= request.getAttribute("activeUserCount") %></div>
                </div>
                <div class="stat-item">
                    <div class="stat-label">Phòng được đặt nhiều nhất</div>
                    <% RoomDTO mostBookedRoom = (RoomDTO) request.getAttribute("mostBookedRoom"); %>
                    <div class="stat-value">
                        <%= mostBookedRoom != null ? mostBookedRoom.getName() + " (" + request.getAttribute("mostBookedCount") + " lần)" : "Chưa có" %>
                    </div>
                </div>
            </div>

            <!-- Biểu đồ -->
            <div class="chart-container">
                <canvas id="bookingChart"></canvas>
            </div>

            <!-- Doanh thu theo phòng -->
            <div style="margin-top: 40px;">
                <h2>Doanh thu theo phòng</h2>
                <table class="revenue-table">
                    <thead>
                        <tr>
                            <th>Tên phòng</th>
                            <th>Doanh thu (VND)</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            Map<Integer, Double> revenueByRoom = (Map<Integer, Double>) request.getAttribute("revenueByRoom");
                            RoomDAO roomDAO = (RoomDAO) request.getAttribute("roomDAO");
                            if (revenueByRoom != null && !revenueByRoom.isEmpty()) {
                                for (Map.Entry<Integer, Double> entry : revenueByRoom.entrySet()) {
                                    RoomDTO room = roomDAO.getRoomById(entry.getKey());
                        %>
                        <tr>
                            <td><%= room != null ? room.getName() : "Không xác định" %></td>
                            <td><%= String.format("%,.0f", entry.getValue()) %></td>
                        </tr>
                        <% 
                                }
                            } else {
                        %>
                        <tr>
                            <td colspan="2" style="text-align: center;">Chưa có dữ liệu doanh thu</td>
                        </tr>
                        <% 
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="footer-container">
        <%@include file="../footer.jsp" %>
    </div>

    <script>
        // Dữ liệu từ JSP để vẽ biểu đồ
        const ctx = document.getElementById('bookingChart').getContext('2d');
        const bookingChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: ['Chờ xác nhận', 'Đã xác nhận', 'Đã hủy'],
                datasets: [{
                    label: 'Số lượng đặt phòng',
                    data: [<%= request.getAttribute("pendingCount") %>, <%= request.getAttribute("confirmedCount") %>, <%= request.getAttribute("cancelledCount") %>],
                    backgroundColor: ['#e67e22', '#2ecc71', '#e74c3c'],
                    borderColor: ['#d35400', '#27ae60', '#c0392b'],
                    borderWidth: 1
                }]
            },
            options: {
                scales: {
                    y: {
                        beginAtZero: true,
                        title: {
                            display: true,
                            text: 'Số lượng'
                        }
                    }
                },
                plugins: {
                    legend: {
                        display: false
                    }
                }
            }
        });
    </script>
</body>
</html>