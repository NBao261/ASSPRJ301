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
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import dao.NotificationDAO;
import dto.NotificationDTO;

@WebServlet(name = "BookingController", urlPatterns = {"/bookRoom", "/viewBookings", "/cancelBooking", "/checkAvailability"})
public class BookingController extends HttpServlet {

    // Các hằng số đường dẫn trang JSP
    private static final String LOGIN_PAGE = "login-regis.jsp";
    private static final String BOOKING_PAGE = "booking.jsp";
    private static final String BOOKING_LIST_PAGE = "viewBookings.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String action = request.getServletPath();
        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("user");

        // Kiểm tra đăng nhập, ngoại trừ action checkAvailability
        if (user == null && !action.equals("/checkAvailability")) {
            response.sendRedirect(request.getContextPath() + "/" + LOGIN_PAGE);
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
                    cancelBooking(request, response, user);
                    break;
                case "/checkAvailability":
                    checkAvailability(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Action not supported");
                    break;
            }
        } catch (Exception e) {
            log("Error in BookingController: " + e.getMessage(), e);
            request.setAttribute("errorMessage", "Đã xảy ra lỗi: " + e.getMessage());
            request.getRequestDispatcher(BOOKING_PAGE).forward(request, response);
        }
    }

    // Hàm xử lý đặt phòng mới
    private void handleBooking(HttpServletRequest request, HttpServletResponse response, UserDTO user)
            throws IOException, ServletException, ClassNotFoundException, Exception {
        String roomIdParam = request.getParameter("roomId");
        String checkInStr = request.getParameter("checkInDate");
        String checkOutStr = request.getParameter("checkOutDate");

        if (roomIdParam == null || roomIdParam.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Không tìm thấy thông tin phòng!");
            request.getRequestDispatcher(BOOKING_PAGE).forward(request, response);
            return;
        }

        int roomId = Integer.parseInt(roomIdParam);
        RoomDAO roomDAO = new RoomDAO();
        RoomDTO room = roomDAO.getRoomById(roomId);

        if (room == null) {
            request.setAttribute("errorMessage", "Phòng không tồn tại!");
            request.getRequestDispatcher(BOOKING_PAGE).forward(request, response);
            return;
        }

        BookingDAO bookingDAO = new BookingDAO();
        Date checkInDate = Date.valueOf(checkInStr);
        Date checkOutDate = Date.valueOf(checkOutStr);
        long days = ChronoUnit.DAYS.between(checkInDate.toLocalDate(), checkOutDate.toLocalDate());

        if (days <= 0) {
            request.setAttribute("errorMessage", "Ngày trả phòng phải sau ngày nhận phòng!");
            request.getRequestDispatcher(BOOKING_PAGE).forward(request, response);
            return;
        }

        if (!bookingDAO.isRoomAvailable(roomId, checkInDate, checkOutDate)) {
            request.setAttribute("errorMessage", "Phòng đã được đặt trong khoảng thời gian này!");
            request.getRequestDispatcher(BOOKING_PAGE).forward(request, response);
            return;
        }

        double totalPrice = days * room.getPrice();
        BookingDTO booking = new BookingDTO(0, user, room, checkInDate, checkOutDate, totalPrice, BookingDAO.STATUS_PENDING_PAYMENT, new java.util.Date());

        if (bookingDAO.addBooking(booking)) {
            NotificationDAO notificationDAO = new NotificationDAO();
            NotificationDTO notification = new NotificationDTO(0, user.getUserID(),
                    "Bạn đã đặt phòng '" + room.getName() + "' thành công! Vui lòng thanh toán để hoàn tất.", null, false);
            notificationDAO.addNotification(notification);

            request.setAttribute("successMessage", "Đặt phòng thành công! Vui lòng thanh toán để hoàn tất.");
            viewBookings(request, response, user); // Chuyển đến danh sách đặt phòng
        } else {
            request.setAttribute("errorMessage", "Đặt phòng thất bại, vui lòng thử lại.");
            request.getRequestDispatcher(BOOKING_PAGE).forward(request, response);
        }
    }

    // Hàm hiển thị danh sách đặt phòng của người dùng
    private void viewBookings(HttpServletRequest request, HttpServletResponse response, UserDTO user)
            throws ServletException, IOException, ClassNotFoundException, Exception {
        BookingDAO bookingDAO = new BookingDAO();
        List<BookingDTO> bookingList = bookingDAO.getBookingsByUserId(user.getUserID());
        request.setAttribute("bookingList", bookingList);
        request.getRequestDispatcher(BOOKING_LIST_PAGE).forward(request, response);
    }

    // Hàm xử lý hủy đặt phòng
    private void cancelBooking(HttpServletRequest request, HttpServletResponse response, UserDTO user)
            throws IOException, ServletException, ClassNotFoundException, Exception {
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        BookingDAO bookingDAO = new BookingDAO();
        BookingDTO booking = bookingDAO.getBookingById(bookingId);

        // Chỉ cho phép hủy khi trạng thái là "PendingPayment"
        if (booking != null && BookingDAO.STATUS_PENDING_PAYMENT.equals(booking.getStatus()) && bookingDAO.cancelBooking(bookingId)) {
            NotificationDAO notificationDAO = new NotificationDAO();
            String roomName = booking.getRoom() != null ? booking.getRoom().getName() : "Không xác định";
            String message = "Đơn đặt phòng '" + roomName + "' đã được hủy.";
            NotificationDTO notification = new NotificationDTO(0, user.getUserID(), message, null, false);
            notificationDAO.addNotification(notification);

            response.sendRedirect(request.getContextPath() + "/viewBookings");
        } else {
            request.setAttribute("errorMessage", "Hủy đặt phòng thất bại. Đơn đặt phòng không tồn tại hoặc đã được thanh toán/xác nhận.");
            viewBookings(request, response, user); // Quay lại danh sách với thông báo lỗi
        }
    }

    // Hàm kiểm tra phòng trống (AJAX endpoint)
    private void checkAvailability(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        try {
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            String checkInDateStr = request.getParameter("checkInDate");
            String checkOutDateStr = request.getParameter("checkOutDate");

            Date checkInDate = Date.valueOf(checkInDateStr);
            Date checkOutDate = Date.valueOf(checkOutDateStr);

            BookingDAO bookingDAO = new BookingDAO();
            boolean isAvailable = bookingDAO.isRoomAvailable(roomId, checkInDate, checkOutDate);

            out.print("{\"available\": " + isAvailable + "}");
        } catch (Exception e) {
            out.print("{\"error\": \"" + e.getMessage() + "\"}");
        } finally {
            out.flush();
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