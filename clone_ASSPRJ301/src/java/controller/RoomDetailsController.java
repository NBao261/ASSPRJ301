
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

        String roomName = request.getParameter("room");  // Lấy tên phòng từ URL
        RoomDAO roomDAO = new RoomDAO();
        RoomDTO room = roomDAO.getRoomByName(roomName);

        if (room != null) {
            request.setAttribute("room", room);
            RequestDispatcher rd = request.getRequestDispatcher("room-details.jsp");
            rd.forward(request, response);
        } else {
            response.sendRedirect("home.jsp");  // Nếu phòng không tồn tại, quay lại trang chủ
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

