package controller;

import dao.RoomDAO;
import dto.RoomDTO;
import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "RoomDetailsController", urlPatterns = {"/room-details"})
public class RoomDetailsController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {
        response.setContentType("text/html;charset=UTF-8");

        // Lấy roomId từ request 
        String roomIdStr = request.getParameter("roomId");
        if (roomIdStr == null) {
            response.sendRedirect("home.jsp");
            return;
        }

        int roomId = Integer.parseInt(roomIdStr);
        RoomDAO roomDAO = new RoomDAO();
        RoomDTO room = roomDAO.getRoomById(roomId);  

        if (room != null) {
            request.setAttribute("room", room);
            RequestDispatcher rd = request.getRequestDispatcher("room-details.jsp");
            rd.forward(request, response);
        } else {
            response.sendRedirect("home.jsp");  
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (Exception ex) {
            Logger.getLogger(RoomDetailsController.class.getName()).log(Level.SEVERE, null, ex);
            response.sendRedirect("home.jsp"); 
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (Exception ex) {
            Logger.getLogger(RoomDetailsController.class.getName()).log(Level.SEVERE, null, ex);
            response.sendRedirect("home.jsp"); 
        }
    }
}