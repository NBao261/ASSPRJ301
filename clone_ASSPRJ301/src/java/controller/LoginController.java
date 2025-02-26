package controller;

import dao.UserDAO;
import dto.UserDTO;
import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "LoginController", urlPatterns = {"/login", "/logout", "/home"})
public class LoginController extends HttpServlet {

    private static final String LOGIN_PAGE = "login-regis.jsp";
    private static final String HOME_PAGE = "home.jsp";

    private UserDTO getUser(String strUserID) {
        UserDAO udao = new UserDAO();
        return udao.readById(strUserID);
    }

    private boolean isValidLogin(String strUserID, String strPassword) {
        UserDTO user = getUser(strUserID);
        return user != null && user.getPassword() != null && user.getPassword().equals(strPassword);
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = LOGIN_PAGE;

        try {
            String action = request.getParameter("action");
            HttpSession session = request.getSession();
            UserDTO user = (UserDTO) session.getAttribute("user");

            if (action != null) {
                switch (action) {
                    case "login":
                        String strUserID = request.getParameter("txtUsername");
                        String strPassword = request.getParameter("txtPassword");

                        if (strUserID != null && strPassword != null && !strUserID.trim().isEmpty() && !strPassword.trim().isEmpty()) {
                            if (isValidLogin(strUserID.trim(), strPassword.trim())) {
                                user = getUser(strUserID.trim());
                                session.setAttribute("user", user);
                                response.sendRedirect(HOME_PAGE);
                                return;
                            } else {
                                request.setAttribute("errorMessage", "Sai tài khoản hoặc mật khẩu!");
                            }
                        } else {
                            request.setAttribute("errorMessage", "Vui lòng nhập tài khoản và mật khẩu!");
                        }
                        break;

                    case "logout":
                        session.invalidate();
                        response.sendRedirect(LOGIN_PAGE);
                        return;

                    case "home":
                        if (user != null) {
                            response.sendRedirect(HOME_PAGE);
                            return;
                        }
                        break;
                }
            }
        } catch (Exception e) {
            log("Error in LoginController: " + e.getMessage(), e);
            request.setAttribute("errorMessage", "Đã xảy ra lỗi hệ thống. Vui lòng thử lại sau!");
        }

        RequestDispatcher rd = request.getRequestDispatcher(url);
        rd.forward(request, response);
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
}