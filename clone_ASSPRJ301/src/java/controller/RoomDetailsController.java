
package controller;

import dao.RoomDAO;
import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import dto.RoomDTO;

@WebServlet(name = "RoomDetailsController", urlPatterns = {"/room-details"})
public class RoomDetailsController extends HttpServlet {

   protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        // Lấy roomId từ request
        int roomId = Integer.parseInt(request.getParameter("roomId"));  
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
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}

