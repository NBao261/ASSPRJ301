<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="dto.UserDTO"%>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý người dùng - Admin</title>
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

        .users-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
            padding: 30px;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .users-container:hover {
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

        .form-container input, .form-container select {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
        }

        .form-container .note {
            font-size: 12px;
            color: #777;
            margin-top: -10px;
            margin-bottom: 15px;
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
        }
    </style>
</head>
<body>
    <div class="header-container">
        <%@include file="../header.jsp" %>
    </div>

    <div class="main-content">
        <div class="users-container">
            <h1>Quản lý người dùng</h1>
            <a href="<%= request.getContextPath() %>/admin/dashboard.jsp" class="back-link">← Quay lại Dashboard</a>
            <button class="btn btn-add" onclick="toggleForm('addForm')">Thêm người dùng</button>

            <% 
                String successMessage = (String) request.getAttribute("successMessage");
                String errorMessage = (String) request.getAttribute("errorMessage");
                if (successMessage != null) { 
            %>
                <div class="message success"><%= successMessage %></div>
            <% } else if (errorMessage != null) { %>
                <div class="message error"><%= errorMessage %></div>
            <% } %>

            <!-- Form thêm người dùng -->
            <div class="form-container" id="addForm">
                <form action="<%= request.getContextPath() %>/admin/users?action=add" method="post">
                    <label for="addUserID">ID người dùng:</label>
                    <input type="text" id="addUserID" name="userID" required>
                    
                    <label for="addFullName">Họ và tên:</label>
                    <input type="text" id="addFullName" name="fullName" required>
                    
                    <label for="addRoleID">Vai trò:</label>
                    <select id="addRoleID" name="roleID" required>
                        <option value="US">Người dùng (US)</option>
                        <option value="AD">Admin (AD)</option>
                    </select>
                    
                    <label for="addPassword">Mật khẩu:</label>
                    <input type="password" id="addPassword" name="password" required>
                    
                    <label for="addGmail">Email:</label>
                    <input type="email" id="addGmail" name="gmail" placeholder="example@domain.com">
                    <div class="note">Email phải đúng định dạng (ví dụ: example@domain.com)</div>
                    
                    <label for="addSdt">Số điện thoại:</label>
                    <input type="text" id="addSdt" name="sdt" placeholder="+84912345678">
                    <div class="note">Số điện thoại từ 9-12 số, có thể bắt đầu bằng +</div>
                    
                    <button type="submit" class="btn btn-add">Lưu</button>
                    <button type="button" class="btn btn-delete" onclick="toggleForm('addForm')">Hủy</button>
                </form>
            </div>

            <!-- Form sửa người dùng -->
            <%
                UserDTO editUser = (UserDTO) request.getAttribute("editUser");
                boolean showEditForm = editUser != null;
            %>
            <div class="form-container <%= showEditForm ? "active" : "" %>" id="editForm">
                <form action="<%= request.getContextPath() %>/admin/users?action=edit" method="post">
                    <input type="hidden" name="userID" value="<%= showEditForm ? editUser.getUserID() : "" %>">
                    
                    <label for="editFullName">Họ và tên:</label>
                    <input type="text" id="editFullName" name="fullName" value="<%= showEditForm ? editUser.getFullName() : "" %>" required>
                    
                    <label for="editRoleID">Vai trò:</label>
                    <select id="editRoleID" name="roleID" required>
                        <option value="US" <%= showEditForm && "US".equals(editUser.getRoleID()) ? "selected" : "" %>>Người dùng (US)</option>
                        <option value="AD" <%= showEditForm && "AD".equals(editUser.getRoleID()) ? "selected" : "" %>>Admin (AD)</option>
                    </select>
                    
                    <label for="editGmail">Email:</label>
                    <input type="email" id="editGmail" name="gmail" value="<%= showEditForm && editUser.getGmail() != null ? editUser.getGmail() : "" %>" placeholder="example@domain.com">
                    <div class="note">Email phải đúng định dạng (ví dụ: example@domain.com)</div>
                    
                    <label for="editSdt">Số điện thoại:</label>
                    <input type="text" id="editSdt" name="sdt" value="<%= showEditForm && editUser.getSdt() != null ? editUser.getSdt() : "" %>" placeholder="+84912345678">
                    <div class="note">Số điện thoại từ 9-12 số, có thể bắt đầu bằng +</div>
                    
                    <button type="submit" class="btn btn-add">Lưu</button>
                    <button type="button" class="btn btn-delete" onclick="toggleForm('editForm')">Hủy</button>
                </form>
            </div>

            <%
                List<UserDTO> userList = (List<UserDTO>) request.getAttribute("userList");
                if (userList == null || userList.isEmpty()) {
            %>
            <p>Không có người dùng nào trong hệ thống.</p>
            <%
                } else {
            %>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Họ và tên</th>
                        <th>Vai trò</th>
                        <th>Email</th>
                        <th>Số điện thoại</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (UserDTO currentUser : userList) { %>
                    <tr>
                        <td><%= currentUser.getUserID() %></td>
                        <td><%= currentUser.getFullName() != null ? currentUser.getFullName() : "Chưa cập nhật" %></td>
                        <td><%= currentUser.getRoleID() %></td>
                        <td><%= currentUser.getGmail() != null ? currentUser.getGmail() : "Chưa cập nhật" %></td>
                        <td><%= currentUser.getSdt() != null ? currentUser.getSdt() : "Chưa cập nhật" %></td>
                        <td>
                            <a href="<%= request.getContextPath() %>/admin/users?action=edit&userID=<%= currentUser.getUserID() %>" class="btn btn-edit">Sửa</a>
                            <button class="btn btn-delete" onclick="confirmDelete('<%= currentUser.getUserID() %>')">Xóa</button>
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

        function confirmDelete(userID) {
            if (confirm("Bạn có chắc chắn muốn xóa người dùng này không?")) {
                window.location.href = '<%= request.getContextPath() %>/admin/users?action=delete&userID=' + userID;
            }
        }
    </script>
</body>
</html>