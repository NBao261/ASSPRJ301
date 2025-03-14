package controller;

import dao.BookingDAO;
import dto.BookingDTO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/paymentResult")
public class PaymentResultController extends HttpServlet {

    private BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String resultCode = request.getParameter("resultCode");
        String orderId = request.getParameter("orderId");

        if ("0".equals(resultCode)) { // Thanh toán thành công
            String bookingId = orderId.split("_")[0]; // Tách bookingId từ orderId
            try {
                BookingDTO booking = bookingDAO.getBookingById(Integer.parseInt(bookingId));
                if (booking != null && BookingDAO.STATUS_PENDING_PAYMENT.equals(booking.getStatus())) {
                    booking.setStatus(BookingDAO.STATUS_PAID);
                    bookingDAO.updateBookingStatus(Integer.parseInt(bookingId), BookingDAO.STATUS_PAID);
                    request.setAttribute("message", "Thanh toán thành công cho đơn đặt phòng #" + bookingId);
                } else {
                    request.setAttribute("message", "Không tìm thấy đơn đặt phòng hoặc trạng thái không hợp lệ.");
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("message", "Lỗi khi cập nhật trạng thái thanh toán: " + e.getMessage());
            }
        } else {
            request.setAttribute("message", "Thanh toán thất bại. Vui lòng thử lại.");
        }

        request.getRequestDispatcher("/payment-result.jsp").forward(request, response);
    }
}
