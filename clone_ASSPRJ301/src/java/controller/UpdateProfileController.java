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

@WebServlet(name = "UpdateProfileServlet", urlPatterns = {"/updateProfile", "/external-uploads/avatars/*"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
                 maxFileSize = 1024 * 1024 * 10,      // 10MB
                 maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class UpdateProfileController extends HttpServlet {

    // Đường dẫn linh hoạt sử dụng thư mục home của người dùng
    private static final String UPLOAD_BASE_DIR = System.getProperty("user.home") + File.separator + "HomestayUploads";
    private static final String UPLOAD_DIR = UPLOAD_BASE_DIR + File.separator + "avatars";
    private static final String PROFILE_PAGE = "profile.jsp";
    private static final String AVATAR_URL_BASE = "/external-uploads/avatars/"; // Đường dẫn ảo trong ứng dụng

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
                // Đường dẫn tuyệt đối đến thư mục uploads/avatars
                File uploadDir = new File(UPLOAD_DIR);

                // Tự động tạo thư mục nếu chưa tồn tại
                if (!uploadDir.exists()) {
                    if (!uploadDir.mkdirs()) {
                        throw new IOException("Không thể tạo thư mục: " + UPLOAD_DIR);
                    }
                    // Đặt quyền đọc/ghi/thực thi cho thư mục (hỗ trợ Windows và Linux)
                    uploadDir.setReadable(true, false);
                    uploadDir.setWritable(true, false);
                    uploadDir.setExecutable(true, false);
                }

                // Tạo tên file duy nhất
                String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
                String filePath = UPLOAD_DIR + File.separator + uniqueFileName;

                // Ghi file lên server
                filePart.write(filePath);

                // Tạo URL ảo để hiển thị trong JSP (bao gồm context path)
                String contextPath = request.getContextPath(); // Lấy context path (/clone_ASSPRJ301)
                avatarUrl = contextPath + AVATAR_URL_BASE + uniqueFileName;

                // Kiểm tra file đã được tạo chưa
                File uploadedFile = new File(filePath);
                if (!uploadedFile.exists()) {
                    throw new IOException("File không được tạo thành công tại: " + filePath);
                }

                // Đặt quyền đọc cho file (hỗ trợ Windows)
                uploadedFile.setReadable(true, false); // Quyền đọc cho mọi người
                uploadedFile.setWritable(false, false); // Chỉ cho phép ghi bởi owner

                // Kiểm tra lại file sau khi đặt quyền
                if (!uploadedFile.canRead()) {
                    throw new IOException("Không thể đặt quyền đọc cho file: " + filePath);
                }
            } catch (IOException e) {
                request.setAttribute("errorAvatar", "Không thể tải ảnh lên, vui lòng thử lại: " + e.getMessage());
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
                session.setAttribute("user", user); // Cập nhật session với avatarUrl mới
                request.setAttribute("successMessage", "Cập nhật thông tin thành công!");
            } else {
                request.setAttribute("errorMessage", "Cập nhật thất bại, vui lòng thử lại.");
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Lỗi hệ thống khi cập nhật thông tin, vui lòng thử lại: " + e.getMessage());
        }
        request.getRequestDispatcher(PROFILE_PAGE).forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String requestURI = request.getRequestURI();
        String contextPath = request.getContextPath(); // Lấy context path (/clone_ASSPRJ301)
        if (requestURI != null && requestURI.startsWith(contextPath + "/external-uploads/avatars/")) {
            String filePath = requestURI.substring((contextPath + "/external-uploads/avatars/").length());
            String fullFilePath = UPLOAD_DIR + File.separator + filePath;

            File file = new File(fullFilePath);
            if (file.exists() && file.isFile() && file.canRead()) {
                // Xác định loại nội dung (content type) của file
                String mimeType = getServletContext().getMimeType(filePath);
                if (mimeType == null) {
                    // Nếu không xác định được, mặc định là image/jpeg
                    mimeType = "image/jpeg";
                }
                response.setContentType(mimeType);
                response.setHeader("Content-Disposition", "inline; filename=\"" + filePath + "\"");
                try (java.io.FileInputStream in = new java.io.FileInputStream(file)) {
                    java.io.OutputStream out = response.getOutputStream();
                    byte[] buffer = new byte[4096];
                    int bytesRead;
                    while ((bytesRead = in.read(buffer)) != -1) {
                        out.write(buffer, 0, bytesRead);
                    }
                    out.flush();
                }
                return;
            }
        }
        response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found");
    }
}