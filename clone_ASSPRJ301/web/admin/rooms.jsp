<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="dto.RoomDTO"%>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý phòng - Admin</title>
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

        .rooms-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
            padding: 30px;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .rooms-container:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 35px rgba(0, 0, 0, 0.15);
        }

        h1 {
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

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        th {
            background: linear-gradient(45deg, #5DC1B9, #4ECDC4);
            color: white;
            font-weight: 600;
        }

        tr:hover {
            background: #f8f9fa;
        }

        .btn {
            padding: 8px 15px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            transition: transform 0.3s ease, background 0.3s ease;
        }

        .btn-add {
            background: #2ecc71;
            color: white;
            margin-bottom: 20px;
        }

        .btn-add:hover {
            background: #27ae60;
            transform: scale(1.05);
        }

        .btn-edit {
            background: #3498db;
            color: white;
        }

        .btn-edit:hover {
            background: #2980b9;
            transform: scale(1.05);
        }

        .btn-delete {
            background: #e74c3c;
            color: white;
        }

        .btn-delete:hover {
            background: #c0392b;
            transform: scale(1.05);
        }

        .message {
            padding: 10px;
            border-radius: 8px;
            margin-bottom: 20px;
            text-align: center;
        }

        .message.success {
            background: #e8f5e9;
            color: #27ae60;
        }

        .message.error {
            background: #ffebee;
            color: #e74c3c;
        }

        .form-container {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            display: none;
        }

        .form-container.active {
            display: block;
        }

        .form-container label {
            display: block;
            margin-bottom: 5px;
            font-weight: 600;
        }

        .form-container input, .form-container textarea {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
        }

        .form-container textarea {
            height: 100px;
            resize: vertical;
        }

        .form-container .note {
            font-size: 12px;
            color: #777;
            margin-top: -10px;
            margin-bottom: 15px;
        }

        .image-preview {
            max-width: 100px;
            height: auto;
            margin: 5px;
        }

        @media (max-width: 768px) {
            .main-content {
                padding: 60px 15px;
            }

            h1 {
                font-size: 28px;
            }

            th, td {
                padding: 10px;
                font-size: 14px;
            }

            .btn {
                padding: 6px 12px;
                font-size: 14px;
            }

            table {
                display: block;
                overflow-x: auto;
                white-space: nowrap;
            }

            .image-preview {
                max-width: 80px;
            }
        }
    </style>
</head>
<body>
    <div class="header-container">
        <%@include file="../header.jsp" %>
    </div>

    <div class="main-content">
        <div class="rooms-container">
            <h1>Quản lý phòng</h1>
            <a href="<%= request.getContextPath() %>/admin/dashboard.jsp" class="back-link">← Quay lại Dashboard</a>
            <button class="btn btn-add" onclick="toggleForm('addForm')">Thêm phòng</button>

            <% 
                String successMessage = (String) request.getAttribute("successMessage");
                String errorMessage = (String) request.getAttribute("errorMessage");
                if (successMessage != null) { 
            %>
                <div class="message success"><%= successMessage %></div>
            <% } else if (errorMessage != null) { %>
                <div class="message error"><%= errorMessage %></div>
            <% } %>

            <!-- Form thêm phòng -->
            <div class="form-container" id="addForm">
                <form action="<%= request.getContextPath() %>/admin/rooms?action=add" method="post">
                    <label for="addName">Tên phòng:</label>
                    <input type="text" id="addName" name="name" required>
                    
                    <label for="addDescription">Mô tả:</label>
                    <textarea id="addDescription" name="description"></textarea>
                    
                    <label for="addPrice">Giá (VND):</label>
                    <input type="number" id="addPrice" name="price" step="1000" min="0" required>
                    
                    <label for="addAmenities">Tiện nghi:</label>
                    <input type="text" id="addAmenities" name="amenities">
                    
                    <label for="addRatings">Đánh giá (0-5):</label>
                    <input type="number" id="addRatings" name="ratings" step="0.1" min="0" max="5" required>
                    
                    <label for="addImageUrl">URL hình ảnh chính:</label>
                    <input type="text" id="addImageUrl" name="imageUrl" placeholder="Nhập link ảnh">
                    <div class="note">Nhập link ảnh bất kỳ</div>
                    
                    <label for="addDetailImages">URL ảnh chi tiết (mỗi dòng một URL):</label>
                    <textarea id="addDetailImages" name="detailImages" placeholder="Nhập các link ảnh, mỗi dòng một link"></textarea>
                    <div class="note">Nhập từng link ảnh chi tiết trên một dòng</div>
                    
                    <button type="submit" class="btn btn-add">Lưu</button>
                    <button type="button" class="btn btn-delete" onclick="toggleForm('addForm')">Hủy</button>
                </form>
            </div>

            <!-- Form sửa phòng -->
            <%
                RoomDTO editRoom = (RoomDTO) request.getAttribute("editRoom");
                boolean showEditForm = editRoom != null;
                String detailImagesText = showEditForm && editRoom.getDetailImages() != null ? String.join("\n", editRoom.getDetailImages()) : "";
            %>
            <div class="form-container <%= showEditForm ? "active" : "" %>" id="editForm">
                <form action="<%= request.getContextPath() %>/admin/rooms?action=edit" method="post">
                    <input type="hidden" name="roomId" value="<%= showEditForm ? editRoom.getId() : "" %>">
                    
                    <label for="editName">Tên phòng:</label>
                    <input type="text" id="editName" name="name" value="<%= showEditForm ? editRoom.getName() : "" %>" required>
                    
                    <label for="editDescription">Mô tả:</label>
                    <textarea id="editDescription" name="description"><%= showEditForm && editRoom.getDescription() != null ? editRoom.getDescription() : "" %></textarea>
                    
                    <label for="editPrice">Giá (VND):</label>
                    <input type="number" id="editPrice" name="price" step="1000" min="0" value="<%= showEditForm ? editRoom.getPrice() : "" %>" required>
                    
                    <label for="editAmenities">Tiện nghi:</label>
                    <input type="text" id="editAmenities" name="amenities" value="<%= showEditForm && editRoom.getAmenities() != null ? editRoom.getAmenities() : "" %>">
                    
                    <label for="editRatings">Đánh giá (0-5):</label>
                    <input type="number" id="editRatings" name="ratings" step="0.1" min="0" max="5" value="<%= showEditForm ? editRoom.getRatings() : "" %>" required>
                    
                    <label for="editImageUrl">URL hình ảnh chính:</label>
                    <input type="text" id="editImageUrl" name="imageUrl" value="<%= showEditForm && editRoom.getImageUrl() != null ? editRoom.getImageUrl() : "" %>" placeholder="Nhập link ảnh">
                    <div class="note">Nhập link ảnh bất kỳ</div>
                    
                    <label for="editDetailImages">URL ảnh chi tiết (mỗi dòng một URL):</label>
                    <textarea id="editDetailImages" name="detailImages" placeholder="Nhập các link ảnh, mỗi dòng một link"><%= detailImagesText %></textarea>
                    <div class="note">Nhập từng link ảnh chi tiết trên một dòng</div>
                    
                    <button type="submit" class="btn btn-add">Lưu</button>
                    <button type="button" class="btn btn-delete" onclick="toggleForm('editForm')">Hủy</button>
                </form>
            </div>

            <%
                List<RoomDTO> roomList = (List<RoomDTO>) request.getAttribute("roomList");
                if (roomList == null || roomList.isEmpty()) {
            %>
            <p>Không có phòng nào trong hệ thống.</p>
            <%
                } else {
            %>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Tên phòng</th>
                        <th>Mô tả</th>
                        <th>Giá (VND)</th>
                        <th>Tiện nghi</th>
                        <th>Đánh giá</th>
                        <th>Hình ảnh chính</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (RoomDTO room : roomList) { %>
                    <tr>
                        <td><%= room.getId() %></td>
                        <td><%= room.getName() %></td>
                        <td><%= room.getDescription() != null ? room.getDescription() : "Chưa có mô tả" %></td>
                        <td><%= String.format("%,.0f", room.getPrice()) %></td>
                        <td><%= room.getAmenities() != null ? room.getAmenities() : "Chưa có tiện nghi" %></td>
                        <td><%= room.getRatings() %></td>
                        <td>
                            <% if (room.getImageUrl() != null && !room.getImageUrl().isEmpty()) { %>
                                <img src="<%= room.getImageUrl() %>" alt="Hình ảnh chính" class="image-preview" onerror="this.src='<%= request.getContextPath() %>/images/placeholder.jpg';">
                            <% } else { %>
                                Chưa có ảnh
                            <% } %>
                        </td>
                        <td>
                            <a href="<%= request.getContextPath() %>/admin/rooms?action=edit&roomId=<%= room.getId() %>" class="btn btn-edit">Sửa</a>
                            <button class="btn btn-delete" onclick="confirmDelete('<%= room.getId() %>')">Xóa</button>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
            <%
                }
            %>
        </div>
    </div>

    <div class="footer-container">
        <%@include file="../footer.jsp" %>
    </div>

    <script>
        function toggleForm(formId) {
            const form = document.getElementById(formId);
            form.classList.toggle('active');
        }

        function confirmDelete(roomId) {
            if (confirm("Bạn có chắc chắn muốn xóa phòng này không?")) {
                window.location.href = '<%= request.getContextPath() %>/admin/rooms?action=delete&roomId=' + roomId;
            }
        }
    </script>
</body>
</html>