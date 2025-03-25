package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import dto.RoomDTO;
import dao.RoomDAO;
import javax.servlet.annotation.WebServlet;

@WebServlet("/RoomFilterServlet")
public class RoomFilterController extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        // Nhận tham số từ request
        String searchName = request.getParameter("searchName");
        String minPriceStr = request.getParameter("minPrice");
        String maxPriceStr = request.getParameter("maxPrice");
        String amenities = request.getParameter("amenities");

        // Xử lý giá (nếu không nhập thì đặt giá trị mặc định)
        double minPrice = (minPriceStr != null && !minPriceStr.isEmpty()) ? Double.parseDouble(minPriceStr) : 0;
        double maxPrice = (maxPriceStr != null && !maxPriceStr.isEmpty()) ? Double.parseDouble(maxPriceStr) : Double.MAX_VALUE;

        // Lấy danh sách phòng từ DAO
        RoomDAO roomDAO = new RoomDAO();
        List<RoomDTO> rooms = roomDAO.getFilteredRooms(searchName, minPrice, maxPrice, amenities);

        // Trả về HTML cập nhật danh sách phòng
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        for (RoomDTO room : rooms) {
            out.println("<div class='room-item'>");
            out.println("<div class='room-content'>");
            out.println("<div class='room-image'>");
            out.println("<img src='" + room.getImageUrl() + "' alt='Hình ảnh phòng'>");
            out.println("</div>");
            out.println("<h3>" + room.getName() + "</h3>");
            out.println("<p><i class='fas fa-tag'></i> Khởi giá từ " + String.format("%,.0f", room.getPrice()) + " VND</p>");
            out.println("<p><i class='fas fa-wifi'></i> Tiện ích: " + (room.getAmenities() != null ? room.getAmenities() : "Chưa có tiện ích") + "</p>");
            out.println("<p><i class='fas fa-star'></i> Đánh giá: " + room.getRatings() + "/5</p>");
            out.println("<button onclick='roomDetails(" + room.getId() + ")'>Xem chi tiết</button>");
            out.println("</div>");
            out.println("</div>");
        }
    }
}