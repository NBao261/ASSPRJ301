/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
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
    private static final String BOOKING_PAGE = "booking.jsp";
    
    public UserDTO getUser(String strUserID) {
        UserDAO udao = new UserDAO();
        return udao.readById(strUserID);
    }

    public boolean isValidLogin(String strUserID, String strPassword) {
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

            if (action == null) {
                url = LOGIN_PAGE;
            } else {
                switch (action) {
                    case "login":
                        String strUserID = request.getParameter("txtUsername");
                        String strPassword = request.getParameter("txtPassword");
                        if (isValidLogin(strUserID, strPassword)) {
                            user = getUser(strUserID);
                            session.setAttribute("user", user); // Lưu user vào session
                            url = HOME_PAGE;
                        } else {
                            request.setAttribute("errorMessage", "Sai tài khoản hoặc mật khẩu!");
                            url = LOGIN_PAGE;
                        }
                        break;
                    case "logout":
                        session.invalidate(); // Hủy session
                        url = LOGIN_PAGE;
                        break;
                    case "home":
                        url = HOME_PAGE; // Không bắt buộc đăng nhập
                        break;
                    case "booking":
                        String room = request.getParameter("room");
                        if (user != null) {
                            url = BOOKING_PAGE + "?room=" + room;
                        } else {
                            url = LOGIN_PAGE;
                        }
                        break;
                }
            }
        } catch (Exception e) {
            log("Error in LoginController: " + e.toString());
        } finally {
            RequestDispatcher rd = request.getRequestDispatcher(url);
            rd.forward(request, response);
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
}
