package controller;

import dao.BookingDAO;
import dao.RoomDAO;
import dto.BookingDTO;
import dto.RoomDTO;
import dto.UserDTO;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.time.temporal.ChronoUnit;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "BookingController", urlPatterns = {"/bookRoom", "/viewBookings", "/cancelBooking", "/checkAvailability"})
public class BookingController extends HttpServlet {

    // Các hằng số đường dẫn trang JSP
    private static final String LOGIN_PAGE = "login-regis.jsp"; 
    private static final String BOOKING_PAGE = "booking.jsp"; 
    private static final String BOOKING_LIST_PAGE = "viewBookings.jsp"; 

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8"); 
        String action = request.getServletPath(); // Lấy đường dẫn servlet (ví dụ: /bookRoom)
        HttpSession session = request.getSession(); // Lấy phiên làm việc hiện tại
        UserDTO user = (UserDTO) session.getAttribute("user"); // Lấy thông tin người dùng từ session

        // Kiểm tra đăng nhập, ngoại trừ action checkAvailability không yêu cầu đăng nhập
        if (user == null && !action.equals("/checkAvailability")) {
            response.sendRedirect(request.getContextPath() + LOGIN_PAGE); // Chuyển hướng đến trang đăng nhập nếu chưa đăng nhập
            return;
        }

        try {
            switch (action) {
                case "/bookRoom": 
                    handleBooking(request, response, user);
                    break;
                case "/viewBookings": 
                    viewBookings(request, response, user);
                    break;
                case "/cancelBooking":
                    cancelBooking(request, response);
                    break;
                case "/checkAvailability":
                    checkAvailability(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Action not supported"); // Xử lý hành động không hợp lệ
                    break;
            }
        } catch (Exception e) {
            log("Error in BookingController: " + e.getMessage(), e); // Ghi log lỗi nếu xảy ra ngoại lệ
            request.setAttribute("errorMessage", "Đã xảy ra lỗi: " + e.getMessage()); // Đặt thông báo lỗi
            request.getRequestDispatcher(BOOKING_PAGE).forward(request, response); // Chuyển tiếp đến trang đặt phòng
        }
    }

    // Hàm xử lý đặt phòng mới
    private void handleBooking(HttpServletRequest request, HttpServletResponse response, UserDTO user)
            throws IOException, ServletException, ClassNotFoundException, Exception {
        // Lấy dữ liệu từ form
        String roomIdParam = request.getParameter("roomId");
        String checkInStr = request.getParameter("checkInDate");
        String checkOutStr = request.getParameter("checkOutDate");

        // Kiểm tra thông tin phòng
        if (roomIdParam == null || roomIdParam.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Không tìm thấy thông tin phòng!");
            request.getRequestDispatcher(BOOKING_PAGE).forward(request, response);
            return;
        }

        int roomId = Integer.parseInt(roomIdParam); // Chuyển đổi roomId sang kiểu int
        RoomDAO roomDAO = new RoomDAO();
        RoomDTO room = roomDAO.getRoomById(roomId); // Lấy thông tin phòng từ database

        // Kiểm tra phòng có tồn tại không
        if (room == null) {
            request.setAttribute("errorMessage", "Phòng không tồn tại!");
            request.getRequestDispatcher(BOOKING_PAGE).forward(request, response);
            return;
        }

        BookingDAO bookingDAO = new BookingDAO();
        Date checkInDate = Date.valueOf(checkInStr); // Chuyển đổi ngày nhận phòng
        Date checkOutDate = Date.valueOf(checkOutStr); // Chuyển đổi ngày trả phòng
        long days = ChronoUnit.DAYS.between(checkInDate.toLocalDate(), checkOutDate.toLocalDate()); // Tính số ngày đặt

        // Kiểm tra ngày trả phòng phải sau ngày nhận phòng
        if (days <= 0) {
            request.setAttribute("errorMessage", "Ngày trả phòng phải sau ngày nhận phòng!");
            request.getRequestDispatcher(BOOKING_PAGE).forward(request, response);
            return;
        }

        // Kiểm tra phòng có sẵn không
        if (!bookingDAO.isRoomAvailable(roomId, checkInDate, checkOutDate)) {
            request.setAttribute("errorMessage", "Phòng đã được đặt trong khoảng thời gian này!");
            request.getRequestDispatcher(BOOKING_PAGE).forward(request, response);
            return;
        }

        // Tính tổng giá và tạo đối tượng đặt phòng
        double totalPrice = days * room.getPrice();
        BookingDTO booking = new BookingDTO(0, user, room, checkInDate, checkOutDate, totalPrice, BookingDAO.STATUS_PENDING, new java.util.Date());

        // Thêm đặt phòng vào database
        if (bookingDAO.addBooking(booking)) {
            request.setAttribute("successMessage", "Đặt phòng thành công!");
            viewBookings(request, response, user); // Chuyển hướng về danh sách đặt phòng
        } else {
            request.setAttribute("errorMessage", "Đặt phòng thất bại, vui lòng thử lại.");
            request.getRequestDispatcher(BOOKING_PAGE).forward(request, response);
        }
    }

    // Hàm hiển thị danh sách đặt phòng của người dùng
    private void viewBookings(HttpServletRequest request, HttpServletResponse response, UserDTO user)
            throws ServletException, IOException, ClassNotFoundException, Exception {
        BookingDAO bookingDAO = new BookingDAO();
        List<BookingDTO> bookingList = bookingDAO.getBookingsByUserId(user.getUserID()); // Lấy danh sách đặt phòng theo userID
        request.setAttribute("bookingList", bookingList); // Đặt danh sách vào request
        request.getRequestDispatcher(BOOKING_LIST_PAGE).forward(request, response); // Chuyển tiếp đến trang danh sách
    }

    // Hàm xử lý hủy đặt phòng
    private void cancelBooking(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException, ClassNotFoundException {
        int bookingId = Integer.parseInt(request.getParameter("bookingId")); // Lấy ID đặt phòng từ request
        BookingDAO bookingDAO = new BookingDAO();

        // Hủy đặt phòng và chuyển hướng
        if (bookingDAO.cancelBooking(bookingId)) {
            response.sendRedirect(request.getContextPath() + "/viewBookings"); // Chuyển hướng về danh sách nếu thành công
        } else {
            request.setAttribute("errorMessage", "Hủy đặt phòng thất bại."); // Đặt thông báo lỗi nếu thất bại
            request.getRequestDispatcher(BOOKING_LIST_PAGE).forward(request, response);
        }
    }

    // Hàm kiểm tra phòng trống (AJAX endpoint)
    private void checkAvailability(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json"); // Đặt kiểu nội dung là JSON
        PrintWriter out = response.getWriter(); // Lấy writer để gửi phản hồi

        try {
            // Lấy dữ liệu từ request
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            String checkInDateStr = request.getParameter("checkInDate");
            String checkOutDateStr = request.getParameter("checkOutDate");

            Date checkInDate = Date.valueOf(checkInDateStr); // Chuyển đổi ngày nhận phòng
            Date checkOutDate = Date.valueOf(checkOutDateStr); // Chuyển đổi ngày trả phòng

            BookingDAO bookingDAO = new BookingDAO();
            boolean isAvailable = bookingDAO.isRoomAvailable(roomId, checkInDate, checkOutDate); // Kiểm tra phòng trống

            // Gửi phản hồi JSON
            out.print("{\"available\": " + isAvailable + "}");
        } catch (Exception e) {
            out.print("{\"error\": \"" + e.getMessage() + "\"}"); // Gửi lỗi nếu có ngoại lệ
        } finally {
            out.flush(); // Đảm bảo dữ liệu được gửi đi
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