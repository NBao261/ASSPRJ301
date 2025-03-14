package controller;

import dao.BookingDAO;
import dao.NotificationDAO;
import dto.BookingDTO;
import dto.NotificationDTO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/paymentResult")
public class PaymentResultController extends HttpServlet {

    private BookingDAO bookingDAO = new BookingDAO();
    private NotificationDAO notificationDAO = new NotificationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String resultCode = request.getParameter("resultCode");
        String orderId = request.getParameter("orderId");
        String amount = request.getParameter("amount"); // Thêm để lấy số tiền thanh toán

        if ("0".equals(resultCode)) { // Thanh toán thành công
            String bookingId = orderId.split("_")[0]; // Tách bookingId từ orderId
            try {
                int bookingIdInt = Integer.parseInt(bookingId);
                BookingDTO booking = bookingDAO.getBookingById(bookingIdInt);
                if (booking != null && BookingDAO.STATUS_PENDING_PAYMENT.equals(booking.getStatus())) {
                    // Cập nhật trạng thái booking thành "Paid"
                    booking.setStatus(BookingDAO.STATUS_PAID);
                    bookingDAO.updateBookingStatus(bookingIdInt, BookingDAO.STATUS_PAID);

                    // Tạo thông báo cho người dùng
                    String userId = booking.getUser().getUserID();
                    String roomName = booking.getRoom() != null ? booking.getRoom().getName() : "Không xác định";
                    String message = "Thanh toán thành công cho đặt phòng '" + roomName + "' với số tiền "
                            + String.format("%,.0f", Double.parseDouble(amount)) + " VND.";
                    NotificationDTO notification = new NotificationDTO(0, userId, message, null, false);
                    notificationDAO.addNotification(notification);

                    // Gửi thông báo thành công tới giao diện
                    request.setAttribute("message", "Thanh toán thành công cho đơn đặt phòng #" + bookingId);
                } else {
                    request.setAttribute("message", "Không tìm thấy đơn đặt phòng hoặc trạng thái không hợp lệ.");
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
                request.setAttribute("message", "Lỗi: ID đặt phòng không hợp lệ.");
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("message", "Lỗi khi cập nhật trạng thái thanh toán: " + e.getMessage());
            }
        } else {
            request.setAttribute("message", "Thanh toán thất bại. Mã lỗi: " + resultCode + ". Vui lòng thử lại.");
        }

        request.getRequestDispatcher("/payment-result.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response); // Xử lý POST giống GET để hỗ trợ IPN từ MoMo
    }
}
