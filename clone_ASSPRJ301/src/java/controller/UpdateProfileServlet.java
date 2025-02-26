package controller;

import dao.UserDAO;
import dto.UserDTO;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@WebServlet(name = "UpdateProfileServlet", urlPatterns = {"/updateProfile"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class UpdateProfileServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads/avatars";
    private static final String PROFILE_PAGE = "profile.jsp";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login-regis.jsp");
            return;
        }

        // Lấy dữ liệu từ form
        String fullName = request.getParameter("fullName") != null ? request.getParameter("fullName").trim() : "";
        String gmail = request.getParameter("gmail") != null ? request.getParameter("gmail").trim() : "";
        String sdt = request.getParameter("sdt") != null ? request.getParameter("sdt").trim() : "";
        Part filePart = request.getPart("avatar");
        String fileName = filePart != null ? Paths.get(filePart.getSubmittedFileName()).getFileName().toString() : null;

        // Kiểm tra hợp lệ
        boolean hasError = false;
        if (fullName.isEmpty()) {
            request.setAttribute("errorFullName", "Họ và tên không được để trống.");
            hasError = true;
        }
        if (!gmail.isEmpty() && !gmail.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            request.setAttribute("errorGmail", "Email không hợp lệ.");
            hasError = true;
        }
        if (!sdt.isEmpty() && !sdt.matches("^\\+?[0-9]{9,12}$")) {
            request.setAttribute("errorSdt", "Số điện thoại không hợp lệ (9-12 số).");
            hasError = true;
        }

        // Xử lý upload ảnh avatar
        String avatarUrl = user.getAvatarUrl(); // Giữ URL cũ nếu không upload ảnh mới
        if (fileName != null && !fileName.isEmpty()) {
            try {
                String appPath = request.getServletContext().getRealPath("");
                String uploadPath = appPath + File.separator + UPLOAD_DIR;
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
                String filePath = uploadPath + File.separator + uniqueFileName;
                filePart.write(filePath);
                avatarUrl = "/" + UPLOAD_DIR + "/" + uniqueFileName;
            } catch (Exception e) {
                log("Error uploading avatar: " + e.getMessage(), e);
                request.setAttribute("errorAvatar", "Không thể tải ảnh lên, vui lòng thử lại.");
                hasError = true;
            }
        }

        // Nếu có lỗi, quay lại trang profile
        if (hasError) {
            request.getRequestDispatcher(PROFILE_PAGE).forward(request, response);
            return;
        }

        // Cập nhật UserDTO
        user.setFullName(fullName);
        user.setGmail(gmail);
        user.setSdt(sdt);
        user.setAvatarUrl(avatarUrl);

        // Lưu vào cơ sở dữ liệu
        UserDAO userDAO = new UserDAO();
        try {
            if (userDAO.update(user)) {
                session.setAttribute("user", user); // Cập nhật session
                request.setAttribute("successMessage", "Cập nhật thông tin thành công!");
            } else {
                request.setAttribute("errorMessage", "Cập nhật thất bại, vui lòng thử lại.");
            }
        } catch (Exception e) {
            log("Error updating user in database: " + e.getMessage(), e);
            request.setAttribute("errorMessage", "Lỗi hệ thống khi cập nhật thông tin, vui lòng thử lại.");
        }
        request.getRequestDispatcher(PROFILE_PAGE).forward(request, response);
    }
}
