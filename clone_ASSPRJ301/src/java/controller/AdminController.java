package controller;

import dao.BookingDAO;
import dao.RoomDAO;
import dao.UserDAO;
import dto.BookingDTO;
import dto.RoomDTO;
import dto.UserDTO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import dao.NotificationDAO;
import dto.NotificationDTO;

@WebServlet(name = "AdminController", urlPatterns = {
    "/admin/users", "/admin/rooms", "/admin/bookings", "/admin/statistics"
})
public class AdminController extends HttpServlet {

    private static final String LOGIN_PAGE = "/login-regis.jsp";
    private static final String ADMIN_USERS_PAGE = "/admin/users.jsp";
    private static final String ADMIN_ROOMS_PAGE = "/admin/rooms.jsp";
    private static final String ADMIN_BOOKINGS_PAGE = "/admin/bookings.jsp";
    private static final String ADMIN_STATISTICS_PAGE = "/admin/statistics.jsp";
    private static final String EMAIL_PATTERN = "^[A-Za-z0-9+_.-]+@(.+)$";
    private static final String PHONE_PATTERN = "^\\+?[0-9]{9,12}$";
    private static final Logger LOGGER = Logger.getLogger(AdminController.class.getName());
    private final SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy"); // Khai báo sdf ở phạm vi toàn cục

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // Kiểm tra phiên đăng nhập và quyền admin
        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("user");
        if (user == null || !"AD".equals(user.getRoleID())) {
            response.sendRedirect(request.getContextPath() + "/" + LOGIN_PAGE); // Chuyển hướng đến trang đăng nhập nếu không phải admin
            return;
        }

        // Lấy đường dẫn và hành động từ request
        String path = request.getServletPath(); // Đường dẫn servlet (ví dụ: /admin/users)
        String action = request.getParameter("action"); // Tham số hành động (add, edit, delete)

        // Phân luồng xử lý theo đường dẫn
        if ("/admin/users".equals(path)) { // Quản lý người dùng
            UserDAO userDAO = new UserDAO();
            if (action == null || action.isEmpty()) { // Hiển thị danh sách người dùng
                List<UserDTO> userList = userDAO.readAll();
                request.setAttribute("userList", userList); // Đặt danh sách người dùng vào request
                request.getRequestDispatcher(ADMIN_USERS_PAGE).forward(request, response); // Chuyển tiếp đến trang JSP
            } else {
                switch (action) {
                    case "add": // Thêm người dùng mới
                        if ("GET".equals(request.getMethod())) { // Hiển thị form thêm
                            List<UserDTO> userList = userDAO.readAll();
                            request.setAttribute("userList", userList);
                            request.getRequestDispatcher(ADMIN_USERS_PAGE).forward(request, response);
                        } else if ("POST".equals(request.getMethod())) { // Xử lý thêm người dùng
                            // Lấy dữ liệu từ form
                            String userID = request.getParameter("userID");
                            String fullName = request.getParameter("fullName");
                            String roleID = request.getParameter("roleID");
                            String password = request.getParameter("password");
                            String gmail = request.getParameter("gmail");
                            String sdt = request.getParameter("sdt");

                            // Kiểm tra dữ liệu đầu vào
                            if (userID == null || userID.trim().isEmpty() || fullName == null || fullName.trim().isEmpty() || password == null || password.trim().isEmpty()) {
                                request.setAttribute("errorMessage", "ID, họ tên và mật khẩu không được để trống!");
                            } else if (userDAO.readById(userID) != null) {
                                request.setAttribute("errorMessage", "ID người dùng đã tồn tại!");
                            } else if (!"US".equals(roleID) && !"AD".equals(roleID)) {
                                request.setAttribute("errorMessage", "Vai trò không hợp lệ!");
                            } else if (gmail != null && !gmail.trim().isEmpty() && !Pattern.matches(EMAIL_PATTERN, gmail)) {
                                request.setAttribute("errorMessage", "Email không đúng định dạng!");
                            } else if (sdt != null && !sdt.trim().isEmpty() && !Pattern.matches(PHONE_PATTERN, sdt)) {
                                request.setAttribute("errorMessage", "Số điện thoại không đúng định dạng (9-12 số, có thể bắt đầu bằng +)!");
                            } else {
                                // Tạo đối tượng người dùng mới
                                UserDTO newUser = new UserDTO(userID, fullName, roleID, password, gmail, sdt, null);
                                if (userDAO.create(newUser)) {
                                    request.setAttribute("successMessage", "Thêm người dùng thành công!");
                                } else {
                                    request.setAttribute("errorMessage", "Thêm người dùng thất bại!");
                                }
                            }

                            // Cập nhật danh sách và chuyển tiếp
                            List<UserDTO> userList = userDAO.readAll();
                            request.setAttribute("userList", userList);
                            request.getRequestDispatcher(ADMIN_USERS_PAGE).forward(request, response);
                        }
                        break;

                    case "edit": // Sửa thông tin người dùng
                        if ("GET".equals(request.getMethod())) { // Hiển thị form sửa
                            String editUserID = request.getParameter("userID");
                            UserDTO editUser = userDAO.readById(editUserID);
                            if (editUser != null) {
                                request.setAttribute("editUser", editUser); // Đặt thông tin người dùng cần sửa
                            } else {
                                request.setAttribute("errorMessage", "Không tìm thấy người dùng để sửa!");
                            }
                            List<UserDTO> userList = userDAO.readAll();
                            request.setAttribute("userList", userList);
                            request.getRequestDispatcher(ADMIN_USERS_PAGE).forward(request, response);
                        } else if ("POST".equals(request.getMethod())) { // Xử lý sửa người dùng
                            // Lấy dữ liệu từ form
                            String userID = request.getParameter("userID");
                            String fullName = request.getParameter("fullName");
                            String roleID = request.getParameter("roleID");
                            String gmail = request.getParameter("gmail");
                            String sdt = request.getParameter("sdt");

                            UserDTO updatedUser = userDAO.readById(userID);
                            if (updatedUser != null) {
                                // Kiểm tra dữ liệu đầu vào
                                if (fullName == null || fullName.trim().isEmpty()) {
                                    request.setAttribute("errorMessage", "Họ tên không được để trống!");
                                } else if (!"US".equals(roleID) && !"AD".equals(roleID)) {
                                    request.setAttribute("errorMessage", "Vai trò không hợp lệ!");
                                } else if (gmail != null && !gmail.trim().isEmpty() && !Pattern.matches(EMAIL_PATTERN, gmail)) {
                                    request.setAttribute("errorMessage", "Email không đúng định dạng!");
                                } else if (sdt != null && !sdt.trim().isEmpty() && !Pattern.matches(PHONE_PATTERN, sdt)) {
                                    request.setAttribute("errorMessage", "Số điện thoại không đúng định dạng (9-12 số, có thể bắt đầu bằng +)!");
                                } else {
                                    // Cập nhật thông tin người dùng
                                    updatedUser.setFullName(fullName);
                                    updatedUser.setRoleID(roleID);
                                    updatedUser.setGmail(gmail);
                                    updatedUser.setSdt(sdt);

                                    if (userDAO.update(updatedUser)) {
                                        request.setAttribute("successMessage", "Cập nhật người dùng thành công!");
                                    } else {
                                        request.setAttribute("errorMessage", "Cập nhật người dùng thất bại!");
                                    }
                                }
                            } else {
                                request.setAttribute("errorMessage", "Không tìm thấy người dùng để cập nhật!");
                            }

                            // Cập nhật danh sách và chuyển tiếp
                            List<UserDTO> userList = userDAO.readAll();
                            request.setAttribute("userList", userList);
                            request.getRequestDispatcher(ADMIN_USERS_PAGE).forward(request, response);
                        }
                        break;

                    case "delete": // Xóa người dùng
                        String deleteUserID = request.getParameter("userID");
                        BookingDAO bookingDAO = new BookingDAO();
                        List<BookingDTO> userBookings = bookingDAO.getBookingsByUserId(deleteUserID);

                        if (userDAO.readById(deleteUserID) != null) {
                            boolean canDelete = true;
                            StringBuilder errorMsg = new StringBuilder();

                            if (userBookings != null && !userBookings.isEmpty()) {
                                Date currentDate = new Date();
                                for (BookingDTO booking : userBookings) {
                                    if (!"Cancelled".equals(booking.getStatus()) && currentDate.before(booking.getCheckOutDate())) {
                                        canDelete = false;
                                        errorMsg.append("Không thể xóa người dùng vì có đặt phòng chưa hoàn tất (")
                                                .append(booking.getId()).append(") trong khoảng thời gian từ ")
                                                .append(sdf.format(booking.getCheckInDate())).append(" đến ")
                                                .append(sdf.format(booking.getCheckOutDate())).append(". ");
                                    }
                                }
                            }

                            if (canDelete) {
                                if (userDAO.delete(deleteUserID)) {
                                    request.setAttribute("successMessage", "Xóa người dùng thành công!");
                                } else {
                                    request.setAttribute("errorMessage", "Xóa người dùng thất bại!");
                                }
                            } else {
                                request.setAttribute("errorMessage", errorMsg.toString());
                            }
                        } else {
                            request.setAttribute("errorMessage", "Không tìm thấy người dùng để xóa!");
                        }

                        List<UserDTO> userList = userDAO.readAll();
                        request.setAttribute("userList", userList);
                        request.getRequestDispatcher(ADMIN_USERS_PAGE).forward(request, response);
                        break;

                    default:
                        response.sendError(HttpServletResponse.SC_NOT_FOUND, "Action not supported");
                        break;
                }
            }
        } else if ("/admin/rooms".equals(path)) { // Quản lý phòng
            RoomDAO roomDAO = new RoomDAO();
            if (action == null || action.isEmpty()) { // Hiển thị danh sách phòng
                try {
                    List<RoomDTO> roomList = roomDAO.getAllRooms();
                    LOGGER.log(Level.INFO, "Retrieved {0} rooms from database", roomList.size());
                    request.setAttribute("roomList", roomList);
                    if (roomList.isEmpty()) {
                        request.setAttribute("errorMessage", "Không có phòng nào được tìm thấy trong cơ sở dữ liệu!");
                    }
                } catch (Exception e) {
                    LOGGER.log(Level.SEVERE, "Error retrieving rooms: " + e.getMessage(), e);
                    request.setAttribute("errorMessage", "Lỗi khi lấy danh sách phòng: " + e.getMessage());
                }
                request.getRequestDispatcher(ADMIN_ROOMS_PAGE).forward(request, response);
            } else {
                switch (action) {
                    case "add": // Thêm phòng mới
                        if ("GET".equals(request.getMethod())) { // Hiển thị form thêm
                            List<RoomDTO> roomList = roomDAO.getAllRooms();
                            request.setAttribute("roomList", roomList);
                            request.getRequestDispatcher(ADMIN_ROOMS_PAGE).forward(request, response);
                        } else if ("POST".equals(request.getMethod())) { // Xử lý thêm phòng
                            String name = request.getParameter("name");
                            String description = request.getParameter("description");
                            String priceStr = request.getParameter("price");
                            String amenities = request.getParameter("amenities");
                            String ratingsStr = request.getParameter("ratings");
                            String imageUrl = request.getParameter("imageUrl");
                            String detailImagesStr = request.getParameter("detailImages");

                            try {
                                double price = priceStr != null && !priceStr.trim().isEmpty() ? Double.parseDouble(priceStr) : 0;
                                float ratings = ratingsStr != null && !ratingsStr.trim().isEmpty() ? Float.parseFloat(ratingsStr) : 0;
                                List<String> detailImages = detailImagesStr != null && !detailImagesStr.trim().isEmpty()
                                        ? Arrays.asList(detailImagesStr.split("\\r?\\n")) : new ArrayList<>();

                                // Kiểm tra dữ liệu đầu vào
                                if (name == null || name.trim().isEmpty()) {
                                    request.setAttribute("errorMessage", "Tên phòng không được để trống!");
                                } else if (price <= 0) {
                                    request.setAttribute("errorMessage", "Giá phòng phải lớn hơn 0!");
                                } else if (ratings < 0 || ratings > 5) {
                                    request.setAttribute("errorMessage", "Đánh giá phải từ 0 đến 5!");
                                } else {
                                    RoomDTO newRoom = new RoomDTO(0, name, description, price, amenities, ratings, imageUrl, detailImages);
                                    if (roomDAO.create(newRoom)) {
                                        request.setAttribute("successMessage", "Thêm phòng thành công!");
                                    } else {
                                        request.setAttribute("errorMessage", "Thêm phòng thất bại!");
                                    }
                                }
                            } catch (NumberFormatException e) {
                                request.setAttribute("errorMessage", "Giá hoặc đánh giá phải là số hợp lệ!");
                            } catch (Exception e) {
                                request.setAttribute("errorMessage", "Lỗi hệ thống khi thêm phòng: " + e.getMessage());
                            }

                            List<RoomDTO> roomList = roomDAO.getAllRooms();
                            request.setAttribute("roomList", roomList);
                            request.getRequestDispatcher(ADMIN_ROOMS_PAGE).forward(request, response);
                        }
                        break;

                    case "edit": // Sửa thông tin phòng
                        if ("GET".equals(request.getMethod())) { // Hiển thị form sửa
                            String roomIdStr = request.getParameter("roomId");
                            try {
                                int roomId = Integer.parseInt(roomIdStr);
                                RoomDTO editRoom = roomDAO.getRoomById(roomId);
                                if (editRoom != null) {
                                    request.setAttribute("editRoom", editRoom);
                                } else {
                                    request.setAttribute("errorMessage", "Không tìm thấy phòng để sửa!");
                                }
                            } catch (NumberFormatException e) {
                                request.setAttribute("errorMessage", "ID phòng không hợp lệ!");
                            } catch (Exception e) {
                                request.setAttribute("errorMessage", "Lỗi hệ thống khi lấy thông tin phòng: " + e.getMessage());
                            }
                            List<RoomDTO> roomList = roomDAO.getAllRooms();
                            request.setAttribute("roomList", roomList);
                            request.getRequestDispatcher(ADMIN_ROOMS_PAGE).forward(request, response);
                        } else if ("POST".equals(request.getMethod())) { // Xử lý sửa phòng
                            String roomIdStr = request.getParameter("roomId");
                            String name = request.getParameter("name");
                            String description = request.getParameter("description");
                            String priceStr = request.getParameter("price");
                            String amenities = request.getParameter("amenities");
                            String ratingsStr = request.getParameter("ratings");
                            String imageUrl = request.getParameter("imageUrl");
                            String detailImagesStr = request.getParameter("detailImages");

                            try {
                                int roomId = Integer.parseInt(roomIdStr);
                                double price = priceStr != null && !priceStr.trim().isEmpty() ? Double.parseDouble(priceStr) : 0;
                                float ratings = ratingsStr != null && !ratingsStr.trim().isEmpty() ? Float.parseFloat(ratingsStr) : 0;
                                List<String> detailImages = detailImagesStr != null && !detailImagesStr.trim().isEmpty()
                                        ? Arrays.asList(detailImagesStr.split("\\r?\\n")) : new ArrayList<>();

                                RoomDTO updatedRoom = roomDAO.getRoomById(roomId);
                                if (updatedRoom != null) {
                                    if (name == null || name.trim().isEmpty()) {
                                        request.setAttribute("errorMessage", "Tên phòng không được để trống!");
                                    } else if (price <= 0) {
                                        request.setAttribute("errorMessage", "Giá phòng phải lớn hơn 0!");
                                    } else if (ratings < 0 || ratings > 5) {
                                        request.setAttribute("errorMessage", "Đánh giá phải từ 0 đến 5!");
                                    } else {
                                        updatedRoom.setName(name);
                                        updatedRoom.setDescription(description);
                                        updatedRoom.setPrice(price);
                                        updatedRoom.setAmenities(amenities);
                                        updatedRoom.setRatings(ratings);
                                        updatedRoom.setImageUrl(imageUrl);
                                        updatedRoom.setDetailImages(detailImages);

                                        if (roomDAO.update(updatedRoom)) {
                                            request.setAttribute("successMessage", "Cập nhật phòng thành công!");
                                        } else {
                                            request.setAttribute("errorMessage", "Cập nhật phòng thất bại!");
                                        }
                                    }
                                } else {
                                    request.setAttribute("errorMessage", "Không tìm thấy phòng để cập nhật!");
                                }
                            } catch (NumberFormatException e) {
                                request.setAttribute("errorMessage", "Giá hoặc đánh giá phải là số hợp lệ!");
                            } catch (Exception e) {
                                request.setAttribute("errorMessage", "Lỗi hệ thống khi cập nhật phòng: " + e.getMessage());
                            }

                            List<RoomDTO> roomList = roomDAO.getAllRooms();
                            request.setAttribute("roomList", roomList);
                            request.getRequestDispatcher(ADMIN_ROOMS_PAGE).forward(request, response);
                        }
                        break;

                    case "delete": // Xóa phòng
                        String deleteRoomIdStr = request.getParameter("roomId");
                        BookingDAO bookingDAO = new BookingDAO();
                        try {
                            int deleteRoomId = Integer.parseInt(deleteRoomIdStr);
                            RoomDTO roomToDelete = roomDAO.getRoomById(deleteRoomId);
                            if (roomToDelete != null) {
                                boolean canDelete = true;
                                StringBuilder errorMsg = new StringBuilder();

                                List<BookingDTO> roomBookings = bookingDAO.getBookingsByRoomId(deleteRoomId);
                                if (roomBookings != null && !roomBookings.isEmpty()) {
                                    Date currentDate = new Date();
                                    for (BookingDTO booking : roomBookings) {
                                        // Kiểm tra tất cả các booking, không chỉ trạng thái chưa hoàn tất
                                        errorMsg.append("Phòng này có booking (ID: ").append(booking.getId())
                                                .append(") từ ").append(sdf.format(booking.getCheckInDate()))
                                                .append(" đến ").append(sdf.format(booking.getCheckOutDate())).append(". ");
                                    }
                                    // Nếu có bất kỳ booking nào, không cho xóa
                                    canDelete = false;
                                }

                                if (canDelete) {
                                    if (roomDAO.delete(deleteRoomId)) {
                                        request.setAttribute("successMessage", "Xóa phòng thành công!");
                                    } else {
                                        request.setAttribute("errorMessage", "Xóa phòng thất bại!");
                                    }
                                } else {
                                    request.setAttribute("errorMessage", "Không thể xóa phòng vì có các booking liên quan: " + errorMsg.toString());
                                }
                            } else {
                                request.setAttribute("errorMessage", "Không tìm thấy phòng để xóa!");
                            }
                        } catch (NumberFormatException e) {
                            request.setAttribute("errorMessage", "ID phòng không hợp lệ!");
                        } catch (Exception e) {
                            // Kiểm tra lỗi ràng buộc khóa ngoại
                            if (e.getMessage().contains("The DELETE statement conflicted with the REFERENCE constraint")) {
                                request.setAttribute("errorMessage", "Không thể xóa phòng vì có ràng buộc khóa ngoại với bảng bookings!");
                            } else {
                                request.setAttribute("errorMessage", "Lỗi khi xóa phòng: " + e.getMessage());
                            }
                        }

                        List<RoomDTO> roomList = roomDAO.getAllRooms();
                        request.setAttribute("roomList", roomList);
                        request.getRequestDispatcher(ADMIN_ROOMS_PAGE).forward(request, response);
                        break;

                    default:
                        response.sendError(HttpServletResponse.SC_NOT_FOUND, "Action not supported");
                        break;
                }
            }
        } else if ("/admin/bookings".equals(path)) { // Quản lý đặt phòng
            BookingDAO bookingDAO = new BookingDAO();
            if (action == null || action.isEmpty()) { // Hiển thị danh sách đặt phòng
                try {
                    List<BookingDTO> bookingList = bookingDAO.getAllBookings();
                    LOGGER.log(Level.INFO, "Retrieved {0} bookings from database", bookingList.size());
                    request.setAttribute("bookingList", bookingList);
                    if (bookingList.isEmpty()) {
                        request.setAttribute("errorMessage", "Không có đặt phòng nào được tìm thấy trong cơ sở dữ liệu!");
                    }
                } catch (Exception e) {
                    LOGGER.log(Level.SEVERE, "Error retrieving bookings: " + e.getMessage(), e);
                    request.setAttribute("errorMessage", "Lỗi khi lấy danh sách đặt phòng: " + e.getMessage());
                }
                request.getRequestDispatcher(ADMIN_BOOKINGS_PAGE).forward(request, response);
            } else {
                switch (action) {
                    case "confirm": // Xác nhận đặt phòng
                        String confirmBookingIdStr = request.getParameter("bookingId");
                        try {
                            int bookingId = Integer.parseInt(confirmBookingIdStr);
                            BookingDTO booking = bookingDAO.getBookingById(bookingId);
                            if (booking != null && bookingDAO.updateBookingStatus(bookingId, BookingDAO.STATUS_CONFIRMED)) {
                                NotificationDAO notificationDAO = new NotificationDAO();
                                String roomName = booking.getRoom() != null ? booking.getRoom().getName() : "Không xác định";
                                String message = "Đơn đặt phòng '" + roomName + "' đã được xác nhận.";
                                NotificationDTO notification = new NotificationDTO(0, booking.getUser().getUserID(), message, null, false);
                                notificationDAO.addNotification(notification);

                                request.setAttribute("successMessage", "Xác nhận đặt phòng thành công!");
                            } else {
                                request.setAttribute("errorMessage", "Xác nhận đặt phòng thất bại hoặc không tìm thấy đặt phòng!");
                            }
                        } catch (NumberFormatException e) {
                            request.setAttribute("errorMessage", "ID đặt phòng không hợp lệ!");
                        } catch (Exception e) {
                            request.setAttribute("errorMessage", "Lỗi hệ thống khi xác nhận đặt phòng: " + e.getMessage());
                        }
                        redirectToBookingList(bookingDAO, request, response);
                        break;

                    case "cancel": // Hủy đặt phòng
                        String cancelBookingIdStr = request.getParameter("bookingId");
                        try {
                            int bookingId = Integer.parseInt(cancelBookingIdStr);
                            if (bookingDAO.cancelBooking(bookingId)) {
                                request.setAttribute("successMessage", "Hủy đặt phòng thành công!");
                            } else {
                                request.setAttribute("errorMessage", "Hủy đặt phòng thất bại hoặc không tìm thấy đặt phòng!");
                            }
                        } catch (NumberFormatException e) {
                            request.setAttribute("errorMessage", "ID đặt phòng không hợp lệ!");
                        } catch (Exception e) {
                            request.setAttribute("errorMessage", "Lỗi hệ thống khi hủy đặt phòng: " + e.getMessage());
                        }
                        redirectToBookingList(bookingDAO, request, response);
                        break;

                    case "delete": // Xóa đặt phòng
                        String deleteBookingIdStr = request.getParameter("bookingId");
                        try {
                            int bookingId = Integer.parseInt(deleteBookingIdStr);
                            BookingDTO booking = bookingDAO.getBookingById(bookingId);
                            if (booking != null) {
                                Date currentDate = new Date();
                                if (currentDate.after(booking.getCheckOutDate())) {
                                    if (bookingDAO.delete(bookingId)) {
                                        request.setAttribute("successMessage", "Xóa đặt phòng thành công vì đã qua thời gian sử dụng!");
                                    } else {
                                        request.setAttribute("errorMessage", "Xóa đặt phòng thất bại!");
                                    }
                                } else {
                                    request.setAttribute("errorMessage", "Không thể xóa đặt phòng (ID: " + bookingId + ") vì vẫn trong thời gian sử dụng từ "
                                            + sdf.format(booking.getCheckInDate()) + " đến " + sdf.format(booking.getCheckOutDate()) + "!");
                                }
                            } else {
                                request.setAttribute("errorMessage", "Không tìm thấy đặt phòng để xóa!");
                            }
                        } catch (NumberFormatException e) {
                            request.setAttribute("errorMessage", "ID đặt phòng không hợp lệ!");
                        } catch (Exception e) {
                            request.setAttribute("errorMessage", "Lỗi hệ thống khi xóa đặt phòng: " + e.getMessage());
                        }
                        redirectToBookingList(bookingDAO, request, response);
                        break;

                    default:
                        response.sendError(HttpServletResponse.SC_NOT_FOUND, "Action not supported");
                        break;
                }
            }
        } else if ("/admin/statistics".equals(path)) {
            BookingDAO bookingDAO = new BookingDAO();
            RoomDAO roomDAO = new RoomDAO();
            UserDAO userDAO = new UserDAO();
            try {
                System.out.println("Starting statistics processing...");
                List<BookingDTO> bookingList = bookingDAO.getAllBookings();
                System.out.println("Booking list size: " + (bookingList != null ? bookingList.size() : "null"));

                Set<String> timeOptions = new HashSet<>();
                SimpleDateFormat sdfMonthYear = new SimpleDateFormat("yyyy-MM"); // Định dạng riêng cho timeOptions
                for (BookingDTO booking : bookingList) {
                    String monthYear = sdfMonthYear.format(booking.getCreatedAt());
                    timeOptions.add(monthYear);
                }
                System.out.println("Time options: " + timeOptions);

                // Lọc theo khoảng thời gian tùy chỉnh
                String startDateStr = request.getParameter("startDate");
                String endDateStr = request.getParameter("endDate");
                String timeFilter = request.getParameter("time");
                System.out.println("StartDate: " + startDateStr + ", EndDate: " + endDateStr + ", TimeFilter: " + timeFilter);
                if (startDateStr != null && endDateStr != null && !startDateStr.isEmpty() && !endDateStr.isEmpty()) {
                    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                    Date startDate = dateFormat.parse(startDateStr);
                    Date endDate = dateFormat.parse(endDateStr);
                    bookingList = bookingDAO.getBookingsByDateRange(startDate, endDate);
                    System.out.println("Filtered by date range, new size: " + (bookingList != null ? bookingList.size() : "null"));
                } else if (timeFilter != null && !timeFilter.equals("all")) {
                    List<BookingDTO> filteredList = new ArrayList<>();
                    for (BookingDTO booking : bookingList) {
                        String bookingMonthYear = sdfMonthYear.format(booking.getCreatedAt());
                        if (bookingMonthYear.equals(timeFilter)) {
                            filteredList.add(booking);
                        }
                    }
                    bookingList = filteredList;
                    System.out.println("Filtered by month, new size: " + (bookingList != null ? bookingList.size() : "null"));
                }

                // Kiểm tra null cho bookingList
                if (bookingList == null) {
                    LOGGER.log(Level.WARNING, "Booking list is null");
                    bookingList = new ArrayList<>(); // Gán danh sách rỗng để tiếp tục
                }

                // Tính toán thống kê
                double totalRevenue = 0;
                int pendingCount = 0, confirmedCount = 0, cancelledCount = 0;
                Map<String, Integer> activeUsers = new HashMap<>();
                Map<Integer, Double> revenueByRoom = new HashMap<>();
                Map<Integer, Integer> roomBookingCount = new HashMap<>();
                Map<Integer, Integer> roomCancelCount = new HashMap<>();
                Map<String, Integer> userBookingCount = new HashMap<>();
                Map<String, Double> userTotalSpent = new HashMap<>();

                for (BookingDTO booking : bookingList) {
                    if (booking.getUser() == null || booking.getRoom() == null) {
                        LOGGER.log(Level.WARNING, "Booking ID {0} has null user or room", booking.getId());
                        continue; // Bỏ qua nếu user hoặc room là null
                    }
                    String userId = booking.getUser().getUserID();
                    int roomId = booking.getRoom().getId();
                    switch (booking.getStatus()) {
                        case "Pending":
                            pendingCount++;
                            roomBookingCount.put(roomId, roomBookingCount.getOrDefault(roomId, 0) + 1);
                            userBookingCount.put(userId, userBookingCount.getOrDefault(userId, 0) + 1);
                            break;
                        case "Confirmed":
                            confirmedCount++;
                            totalRevenue += booking.getTotalPrice();
                            activeUsers.put(userId, 1);
                            revenueByRoom.put(roomId, revenueByRoom.getOrDefault(roomId, 0.0) + booking.getTotalPrice());
                            roomBookingCount.put(roomId, roomBookingCount.getOrDefault(roomId, 0) + 1);
                            userBookingCount.put(userId, userBookingCount.getOrDefault(userId, 0) + 1);
                            userTotalSpent.put(userId, userTotalSpent.getOrDefault(userId, 0.0) + booking.getTotalPrice());
                            break;
                        case "Cancelled":
                            cancelledCount++;
                            roomCancelCount.put(roomId, roomCancelCount.getOrDefault(roomId, 0) + 1);
                            userBookingCount.put(userId, userBookingCount.getOrDefault(userId, 0) + 1);
                            break;
                    }
                }
                System.out.println("Total revenue: " + totalRevenue + ", Pending: " + pendingCount + ", Confirmed: " + confirmedCount + ", Cancelled: " + cancelledCount);

                // Phòng được đặt nhiều nhất
                int mostBookedRoomId = -1;
                int maxBookings = 0;
                for (Map.Entry<Integer, Integer> entry : roomBookingCount.entrySet()) {
                    if (entry.getValue() > maxBookings) {
                        mostBookedRoomId = entry.getKey();
                        maxBookings = entry.getValue();
                    }
                }
                RoomDTO mostBookedRoom = mostBookedRoomId != -1 ? roomDAO.getRoomById(mostBookedRoomId) : null;
                System.out.println("Most booked room: " + (mostBookedRoom != null ? mostBookedRoom.getName() : "null"));

                // Top 5 người dùng đặt nhiều nhất
                List<Map.Entry<String, Integer>> topUsersByBookings = userBookingCount.entrySet().stream()
                        .sorted(Map.Entry.<String, Integer>comparingByValue().reversed())
                        .limit(5).collect(Collectors.toList());
                System.out.println("Top users size: " + topUsersByBookings.size());

                // Đặt dữ liệu vào request
                request.setAttribute("totalRevenue", totalRevenue);
                request.setAttribute("pendingCount", pendingCount);
                request.setAttribute("confirmedCount", confirmedCount);
                request.setAttribute("cancelledCount", cancelledCount);
                request.setAttribute("activeUserCount", activeUsers.size());
                request.setAttribute("revenueByRoom", revenueByRoom);
                request.setAttribute("roomBookingCount", roomBookingCount);
                request.setAttribute("roomCancelCount", roomCancelCount);
                request.setAttribute("mostBookedRoom", mostBookedRoom);
                request.setAttribute("mostBookedCount", maxBookings);
                request.setAttribute("roomDAO", roomDAO);
                request.setAttribute("timeOptions", timeOptions);
                request.setAttribute("topUsersByBookings", topUsersByBookings);
                request.setAttribute("userTotalSpent", userTotalSpent);
                request.setAttribute("userDAO", userDAO);

                System.out.println("Forwarding to statistics.jsp...");
                request.getRequestDispatcher(ADMIN_STATISTICS_PAGE).forward(request, response);
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Error retrieving statistics: " + e.getMessage(), e);
                request.setAttribute("errorMessage", "Lỗi khi lấy dữ liệu thống kê: " + e.getMessage());
                System.out.println("Error occurred, forwarding with error: " + e.getMessage());
                request.getRequestDispatcher(ADMIN_STATISTICS_PAGE).forward(request, response);
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Page not found"); // Xử lý đường dẫn không hợp lệ
        }
    }

    // Hàm hỗ trợ chuyển hướng về danh sách đặt phòng sau khi thực hiện hành động
    private void redirectToBookingList(BookingDAO bookingDAO, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            List<BookingDTO> bookingList = bookingDAO.getAllBookings();
            request.setAttribute("bookingList", bookingList);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error retrieving bookings: " + e.getMessage(), e);
            request.setAttribute("errorMessage", "Lỗi khi lấy danh sách đặt phòng: " + e.getMessage());
        }
        request.getRequestDispatcher(ADMIN_BOOKINGS_PAGE).forward(request, response);
    }

    // Xử lý yêu cầu GET
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Error in doGet: " + ex.getMessage(), ex);
        }
    }

    // Xử lý yêu cầu POST
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Error in doPost: " + ex.getMessage(), ex);
        }
    }

    // Mô tả thông tin servlet
    @Override
    public String getServletInfo() {
        return "Admin Controller for managing users, rooms, bookings, and statistics";
    }
}
