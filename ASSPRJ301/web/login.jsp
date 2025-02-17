<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Đăng nhập</title>
        <style>
            /* Reset CSS */
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            /* Giữ nguyên cấu trúc body */
            body {
                font-family: Arial, sans-serif;
                background-color: #f5f5f5;
                display: flex;
                flex-direction: column;
                min-height: 100vh;
            }

            /* Container cho login */
            .login-container {
                display: flex;
                justify-content: center;
                align-items: center;
                flex-grow: 1; /* Đảm bảo phần đăng nhập chiếm hết không gian */
                padding: 20px;
                width: 100%;
            }

            /* Form đăng nhập */
            .login-form {
                background: white;
                padding: 40px;
                border-radius: 8px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                width: 100%;
                max-width: 500px; /* Đặt kích thước lớn hơn */
                margin: 0 auto;
            }

            /* Tiêu đề */
            .form-title {
                text-align: center;
                margin-bottom: 30px;
                font-size: 28px;
                font-weight: bold;
                color: #333;
            }

            /* Các nhóm input */
            .form-group {
                margin-bottom: 25px;
            }

            .form-group label {
                display: block;
                margin-bottom: 10px;
                font-weight: 500;
                color: #333;
                font-size: 16px;
            }

            .form-group input {
                width: 100%;
                padding: 12px;
                border: 1px solid #ddd;
                border-radius: 6px;
                font-size: 18px;
                transition: border-color 0.3s;
            }

            .form-group input:focus {
                border-color: #4CAF50;
                outline: none;
            }

            /* Nút đăng nhập */
            .submit-btn {
                background-color: #4CAF50;
                color: white;
                padding: 14px 20px;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                width: 100%;
                font-size: 18px;
                transition: background-color 0.3s;
            }

            .submit-btn:hover {
                background-color: #45a049;
            }

            /* Responsive */
            @media (max-width: 768px) {
                .login-form {
                    padding: 35px;
                }

                .form-title {
                    font-size: 24px;
                }

                .form-group input {
                    font-size: 16px;
                }

                .submit-btn {
                    font-size: 16px;
                    padding: 12px 18px;
                }
            }

            @media (max-width: 480px) {
                .login-form {
                    padding: 25px;
                }

                .form-title {
                    font-size: 22px;
                }

                .form-group input {
                    font-size: 14px;
                }

                .submit-btn {
                    font-size: 14px;
                    padding: 12px;
                }
            }
        </style>
    </head>
    <body>
        <%@include file="header.jsp" %>
        <div class="login-container">
            <div class="login-form">
                <h2 class="form-title">Đăng nhập</h2>
                <form action="MainController" method="post">
                    <input type="hidden" name="action" value="login" />

                    <div class="form-group">
                        <label for="userId">Tên đăng nhập</label>
                        <input type="text" id="userId" name="txtUsername" required />
                    </div>

                    <div class="form-group">
                        <label for="password">Mật khẩu</label>
                        <input type="password" id="password" name="txtPassword" required />
                    </div>

                    <button type="submit" class="submit-btn">Đăng nhập</button>
                </form>
            </div>
        </div>
        <%@include file="footer.jsp" %>
    </body>
</html>
