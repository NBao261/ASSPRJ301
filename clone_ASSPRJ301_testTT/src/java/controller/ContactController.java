package controller;

import dao.ContactDAO;
import dto.ContactMessageDTO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "ContactController", urlPatterns = {"/ContactController"})
public class ContactController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        try {
            String userId = request.getParameter("userId");
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String message = request.getParameter("message");

            ContactMessageDTO contactMessage = new ContactMessageDTO(0, userId, fullName, email, phone, message, null, false);
            ContactDAO contactDAO = new ContactDAO();

            if (contactDAO.create(contactMessage)) {
                request.setAttribute("successMessage", "Tin nhắn đã được gửi thành công!");
            } else {
                request.setAttribute("errorMessage", "Gửi tin nhắn thất bại. Vui lòng thử lại!");
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
        }

        // Quay lại trang liên hệ
        request.getRequestDispatcher("contact.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}