package controller;

import dao.RoomDAO;
import dto.RoomDTO;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "RoomFilterController", urlPatterns = {"/RoomFilterController"})
public class RoomFilterController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try {
            String searchName = request.getParameter("searchName");
            String maxPriceStr = request.getParameter("maxPrice");
            String priceFilterType = request.getParameter("priceFilterType");
            String amenities = request.getParameter("amenities");
            String pageParam = request.getParameter("page");

            // Xử lý tham số
            Double maxPrice = maxPriceStr != null && !maxPriceStr.isEmpty() ? Double.parseDouble(maxPriceStr) : null;
            int currentPage = pageParam != null && !pageParam.isEmpty() ? Integer.parseInt(pageParam) : 1;
            int roomsPerPage = 6; // Số lượng phòng mỗi trang (đồng bộ với search.jsp)

            RoomDAO roomDAO = new RoomDAO();
            // Lấy danh sách phòng đã lọc (cần thêm phương thức trong RoomDAO để lọc)
            List<RoomDTO> rooms = roomDAO.filterRooms(searchName, maxPrice, priceFilterType, amenities, (currentPage - 1) * roomsPerPage, roomsPerPage);

            // Tạo HTML cho danh sách phòng
            StringBuilder html = new StringBuilder();
            if (rooms != null && !rooms.isEmpty()) {
                for (RoomDTO room : rooms) {
                    html.append("<div class='room-item'>")
                        .append("<img src='").append(room.getImageUrl() != null && !room.getImageUrl().isEmpty() ? room.getImageUrl() : request.getContextPath() + "/images/placeholder.jpg")
                        .append("' alt='Hình ảnh phòng' onerror=\"this.src='").append(request.getContextPath()).append("/images/placeholder.jpg';\">")
                        .append("<h3>").append(room.getName()).append("</h3>")
                        .append("<p>").append(room.getDescription() != null ? room.getDescription() : "Chưa có mô tả").append("</p>")
                        .append("<p>Giá: ").append(String.format("%,.0f", room.getPrice())).append(" VND</p>")
                        .append("<p>Tiện ích: ").append(room.getAmenities() != null ? room.getAmenities() : "Chưa có tiện ích").append("</p>")
                        .append("<p>Đánh giá: ").append(room.getRatings()).append("/5</p>")
                        .append("<button onclick='roomDetails(").append(room.getId()).append(")'>Xem chi tiết</button>")
                        .append("</div>");
                }
            } else {
                html.append("<p style='text-align: center; color: #e74c3c;'>Không tìm thấy homestay nào!</p>");
            }

            response.getWriter().write(html.toString());
        } catch (Exception e) {
            response.getWriter().write("<p style='text-align: center; color: #e74c3c;'>Lỗi khi lọc dữ liệu: " + e.getMessage() + "</p>");
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