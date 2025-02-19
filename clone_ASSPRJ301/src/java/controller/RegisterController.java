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

    private static final String LOGIN_PAGE = "login.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        try {
            String newUsername = request.getParameter("txtNewUsername").trim();
            String fullName = request.getParameter("txtFullName").trim();
            String newPassword = request.getParameter("txtNewPassword").trim();
            String confirmPassword = request.getParameter("txtConfirmPassword").trim();

            if (newUsername.isEmpty() || fullName.isEmpty() || newPassword.isEmpty() || confirmPassword.isEmpty()) {
                request.setAttribute("errorMessage", "Vui lòng điền đầy đủ thông tin!");
                request.setAttribute("formType", "register");
            } else if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("errorMessage", "Mật khẩu không khớp!");
                request.setAttribute("formType", "register");
            } else {
                UserDAO userDao = new UserDAO();
                
                if (userDao.readById(newUsername) != null) {
                    request.setAttribute("errorMessage", "Tên đăng nhập đã tồn tại!");
                    request.setAttribute("formType", "register");
                } else {
                    // Tạo user mới với role mặc định là "USER"
                    UserDTO newUser = new UserDTO(newUsername, fullName, "US", newPassword);
                    
                    if (userDao.create(newUser)) {
                        request.setAttribute("successMessage", "Đăng ký thành công! Vui lòng đăng nhập.");
                        request.setAttribute("formType", "login");
                    } else {
                        request.setAttribute("errorMessage", "Lỗi hệ thống, vui lòng thử lại!");
                        request.setAttribute("formType", "register");
                    }
                }
            }
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } catch (Exception e) {
            log("Error in RegisterController: " + e.getMessage());
            request.setAttribute("errorMessage", "Lỗi hệ thống, vui lòng thử lại sau!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
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
