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

    private static final String LOGIN_PAGE = "login-regis.jsp";
    private static final String BOOKING_PAGE = "booking.jsp";
    private static final String BOOKING_LIST_PAGE = "viewBookings.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        String action = request.getServletPath();
        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("user");

        if (user == null && !action.equals("/checkAvailability")) { // Không yêu cầu đăng nhập cho checkAvailability
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
                case "/checkAvailability":
                    checkAvailability(request, response);
                    return;
            }
        } catch (Exception e) {
            log("Error in BookingController: " + e.getMessage(), e);
            request.setAttribute("errorMessage", "Đã xảy ra lỗi. Vui lòng thử lại sau.");
            request.getRequestDispatcher(BOOKING_PAGE).forward(request, response);
        }
    }

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
            throws ServletException, IOException, ClassNotFoundException, Exception {
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