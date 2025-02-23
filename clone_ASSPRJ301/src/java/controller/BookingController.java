package controller;

import dao.BookingDAO;
import dao.RoomDAO;
import dto.BookingDTO;
import dto.RoomDTO;
import dto.UserDTO;
import java.io.IOException;
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

@WebServlet(name = "BookingController", urlPatterns = {"/bookRoom", "/viewBookings", "/cancelBooking", "/updateBooking"})
public class BookingController extends HttpServlet {

    private static final String LOGIN_PAGE = "login-regis.jsp";
    private static final String BOOKING_PAGE = "booking.jsp";
    private static final String BOOKING_LIST_PAGE = "viewBookings.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        String action = request.getServletPath();
        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(LOGIN_PAGE);
            return;
        }

        try {
            switch (action) {
                case "/bookRoom":
                    handleBooking(request, response, user);
                    return;
                case "/viewBookings":
                    viewBookings(request, response, user);
                    return;
                case "/cancelBooking":
                    cancelBooking(request, response);
                    return;
                case "/updateBooking":
                    updateBooking(request, response);
                    return;
            }
        } catch (Exception e) {
            log("Error in BookingController: " + e.getMessage(), e);
            request.setAttribute("errorMessage", "Đã xảy ra lỗi. Vui lòng thử lại sau.");
            request.getRequestDispatcher(BOOKING_PAGE).forward(request, response);
        }
    }

    private void handleBooking(HttpServletRequest request, HttpServletResponse response, UserDTO user)
            throws IOException, ServletException, ClassNotFoundException {
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
            request.setAttribute("errorMessage", "Phòng đã được đặt!");
            request.getRequestDispatcher(BOOKING_PAGE).forward(request, response);
            return;
        }

        double totalPrice = days * room.getPrice();
        BookingDTO booking = new BookingDTO(0, user, room, checkInDate, checkOutDate, totalPrice, BookingDAO.STATUS_PENDING, new java.util.Date());

        if (bookingDAO.addBooking(booking)) {
            request.setAttribute("successMessage", "Đặt phòng thành công!");
            request.getRequestDispatcher(BOOKING_PAGE).forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Đặt phòng thất bại, vui lòng thử lại.");
            request.getRequestDispatcher(BOOKING_PAGE).forward(request, response);
        }
    }

    private void viewBookings(HttpServletRequest request, HttpServletResponse response, UserDTO user)
            throws ServletException, IOException, ClassNotFoundException {
        BookingDAO bookingDAO = new BookingDAO();
        List<BookingDTO> bookingList = bookingDAO.getBookingsByUserId(user.getUserID());
        request.setAttribute("bookingList", bookingList);
        request.getRequestDispatcher(BOOKING_LIST_PAGE).forward(request, response);
    }

    private void cancelBooking(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException, ClassNotFoundException {
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        BookingDAO bookingDAO = new BookingDAO();

        if (bookingDAO.cancelBooking(bookingId)) {
            response.sendRedirect("viewBookings");
        } else {
            request.setAttribute("errorMessage", "Hủy đặt phòng thất bại.");
            request.getRequestDispatcher(BOOKING_LIST_PAGE).forward(request, response);
        }
    }

    private void updateBooking(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException, ClassNotFoundException {
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        String checkInStr = request.getParameter("checkInDate");
        String checkOutStr = request.getParameter("checkOutDate");
        Date checkInDate = Date.valueOf(checkInStr);
        Date checkOutDate = Date.valueOf(checkOutStr);
        long days = ChronoUnit.DAYS.between(checkInDate.toLocalDate(), checkOutDate.toLocalDate());

        if (days <= 0) {
            request.setAttribute("errorMessage", "Ngày trả phòng phải sau ngày nhận phòng!");
            request.getRequestDispatcher(BOOKING_LIST_PAGE).forward(request, response);
            return;
        }

        BookingDAO bookingDAO = new BookingDAO();
        BookingDTO booking = bookingDAO.getBookingById(bookingId);
        if (booking == null) {
            request.setAttribute("errorMessage", "Không tìm thấy đặt phòng!");
            request.getRequestDispatcher(BOOKING_LIST_PAGE).forward(request, response);
            return;
        }

        double totalPrice = days * booking.getRoom().getPrice();
        if (bookingDAO.updateBookingDetails(bookingId, checkInDate, checkOutDate, totalPrice)) {
            response.sendRedirect("viewBookings");
        } else {
            request.setAttribute("errorMessage", "Cập nhật đặt phòng thất bại.");
            request.getRequestDispatcher(BOOKING_LIST_PAGE).forward(request, response);
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
