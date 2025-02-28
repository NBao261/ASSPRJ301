package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import dao.RoomDAO;
import dto.RoomDTO;

@WebServlet("/RoomFilterServlet")
public class RoomFilterController extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        // Nhận tham số từ request
        String searchName = request.getParameter("searchName");
        String priceStr = request.getParameter("maxPrice");
        String priceFilterType = request.getParameter("priceFilterType");
        String amenities = request.getParameter("amenities");

        // Xử lý giá (nếu không nhập thì để null)
        Double price = (priceStr != null && !priceStr.isEmpty()) ? Double.parseDouble(priceStr) : null;

        // Lấy danh sách phòng từ DAO
        RoomDAO roomDAO = new RoomDAO();
        List<RoomDTO> rooms = roomDAO.getFilteredRooms(searchName, price, priceFilterType, amenities);

        // Trả về HTML cập nhật danh sách phòng
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        for (RoomDTO room : rooms) {
            out.println("<div class='room-item'>");
            out.println("<img src='" + room.getImageUrl() + "' alt='Hình ảnh phòng'>");
            out.println("<h3>" + room.getName() + "</h3>");
            out.println("<p>" + room.getDescription() + "</p>");
            out.println("<p>Giá: " + room.getPrice() + " VND</p>");
            out.println("<p>Tiện ích: " + room.getAmenities() + "</p>");
            out.println("<p>Đánh giá: " + room.getRatings() + "/5</p>");
            out.println("<button onclick='roomDetails(" + room.getId() + ")'>Xem chi tiết</button>");
            out.println("</div>");
        }
    }
}