/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package sample.controllers;

import dao.RoomDAO;
import dao.UserDAO;
import dto.RoomDTO;
import dto.UserDTO;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author hoadnt
 */
@WebServlet(name = "MainController", urlPatterns = {"/MainController"})
public class MainController extends HttpServlet {

    private UserDAO userDAO = new UserDAO();
    private RoomDAO roomDAO = new RoomDAO();

    private static final String WELCOME = "login.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        response.setContentType("text/html;charset=UTF-8");
        String url = WELCOME;
        try {
            String action = request.getParameter("action");
//            your code here
            if (action == null) {
                request.getRequestDispatcher(url).forward(request, response);
                return;
            }
            if ("login".equals(action)) {
                String userID = request.getParameter("txtUserID");
                String password = request.getParameter("txtPassword");

                UserDTO user = userDAO.login(userID, password);

                if (user != null) {
                    session.setAttribute("user", user);
                    session.removeAttribute("searchTerm");
                    request.getRequestDispatcher("roomList.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "Incorrect UserID or Password");
                    request.getRequestDispatcher(url).forward(request, response);
                }
            } else if ("logout".equals(action)) {
                session.invalidate();
                response.sendRedirect("login.jsp");
                return;
            } else if ("search".equals(action)) {
                String searchTerm = request.getParameter("searchName");
                if (searchTerm == null || searchTerm.trim().isEmpty()) {
                    searchTerm = "";
                } else {
                    session.setAttribute("searchTerm", searchTerm);
                }

                List<RoomDTO> rooms = roomDAO.searchRoomByName(searchTerm);
                request.setAttribute("rooms", rooms);

                request.getRequestDispatcher("roomList.jsp").forward(request, response);
            } else if ("edit".equals(action)) {
                String roomID = request.getParameter("roomID");
                RoomDTO room = roomDAO.getRoomById(roomID);

                request.setAttribute("room", room);
                request.getRequestDispatcher("editRoom.jsp").forward(request, response);
            } else if ("update".equals(action)) {
                String roomID = request.getParameter("roomID");
                String name = request.getParameter("name");
                String description = request.getParameter("description");
                float price = Float.parseFloat(request.getParameter("price"));
                float area = Float.parseFloat(request.getParameter("area"));

                boolean updated = roomDAO.updateRoom(roomID, name, description, price, area);

                if (updated) {
                    List<RoomDTO> rooms = roomDAO.searchRoomByName("");
                    request.setAttribute("rooms", rooms);
                }

                request.getRequestDispatcher("roomList.jsp").forward(request, response);
            }
        } catch (Exception e) {
            log("Error at MainController: " + e.toString());
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
        return "Short description";
    }// </editor-fold>

}
