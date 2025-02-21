
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
        return user != null && user.getPassword().equals(strPassword);
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
                        String strUserID = request.getParameter("txtUsername").trim();
                        String strPassword = request.getParameter("txtPassword").trim();
                        if (isValidLogin(strUserID, strPassword)) {
                            user = getUser(strUserID);
                            session.setAttribute("user", user); // Lưu user vào session
                            response.sendRedirect(HOME_PAGE); // Thay đổi URL
                            return;
                        } else {
                            request.setAttribute("errorMessage", "Sai tài khoản hoặc mật khẩu!");
                        }
                        break;

                    case "logout":
                        session.invalidate(); // Hủy session
                        response.sendRedirect(LOGIN_PAGE); // Chuyển hướng về trang đăng nhập
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
        }

        // Chỉ forward nếu cần hiển thị thông báo lỗi
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
