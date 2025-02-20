package controller;

import dao.UserDAO;
import dto.UserDTO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "RegisterController", urlPatterns = {"/register"})
public class RegisterController extends HttpServlet {

    private static final String LOGIN_PAGE = "login-regis.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        try {
            String newUsername = request.getParameter("txtNewUsername").trim();
            String fullName = request.getParameter("txtFullName").trim();
            String newPassword = request.getParameter("txtNewPassword").trim();
            String confirmPassword = request.getParameter("txtConfirmPassword").trim();
            boolean hasError = false;

            // Kiểm tra lỗi nhập liệu
            if (newUsername.isEmpty()) {
                request.setAttribute("errorNewUsername", "Tên đăng nhập không được để trống.");
                hasError = true;
            }
            if (fullName.isEmpty()) {
                request.setAttribute("errorFullName", "Họ và tên không được để trống.");
                hasError = true;
            }
            if (newPassword.isEmpty()) {
                request.setAttribute("errorNewPassword", "Mật khẩu không được để trống.");
                hasError = true;
            }
            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("errorConfirmPassword", "Mật khẩu xác nhận không khớp.");
                hasError = true;
            }

            // Nếu có lỗi, quay lại trang đăng ký
            if (hasError) {
                request.setAttribute("showRegisterForm", true);
                request.getRequestDispatcher("login-regis.jsp").forward(request, response);
                return;
            }

            // Kiểm tra xem tên đăng nhập đã tồn tại chưa
            UserDAO userDao = new UserDAO();
            if (userDao.readById(newUsername) != null) {
                request.setAttribute("errorNewUsername", "Tên đăng nhập đã tồn tại.");
                request.setAttribute("showRegisterForm", true);
            } else {
                // Tạo user mới và lưu vào database
                UserDTO newUser = new UserDTO(newUsername, fullName, "US", newPassword);
                if (userDao.create(newUser)) {
                    request.setAttribute("successMessage", "Đăng ký thành công! Vui lòng đăng nhập.");
                    request.setAttribute("showRegisterForm", false);
                } else {
                    request.setAttribute("errorMessage", "Lỗi hệ thống, vui lòng thử lại!");
                    request.setAttribute("showRegisterForm", true);
                }
            }

            request.getRequestDispatcher("login-regis.jsp").forward(request, response);
        } catch (Exception e) {
            log("Error in RegisterController: " + e.getMessage());
            request.setAttribute("errorMessage", "Lỗi hệ thống, vui lòng thử lại sau!");
            request.setAttribute("showRegisterForm", true);
            request.getRequestDispatcher("login-regis.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Handles user registration";
    }
}
