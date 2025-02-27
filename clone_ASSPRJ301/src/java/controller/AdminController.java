package controller;

import dao.RoomDAO;
import dao.UserDAO;
import dto.RoomDTO;
import dto.UserDTO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Pattern;

@WebServlet(name = "AdminController", urlPatterns = {
    "/admin/users", "/admin/rooms", "/admin/bookings", "/admin/statistics"
})
public class AdminController extends HttpServlet {

    private static final String LOGIN_PAGE = "/login-regis.jsp";
    private static final String ADMIN_USERS_PAGE = "/admin/users.jsp";
    private static final String ADMIN_ROOMS_PAGE = "/admin/rooms.jsp";
    private static final String EMAIL_PATTERN = "^[A-Za-z0-9+_.-]+@(.+)$";
    private static final String PHONE_PATTERN = "^\\+?[0-9]{9,12}$";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("user");

        if (user == null || !"AD".equals(user.getRoleID())) {
            response.sendRedirect(request.getContextPath() + "/" + LOGIN_PAGE);
            return;
        }

        String path = request.getServletPath();
        String action = request.getParameter("action");

        if ("/admin/users".equals(path)) {
            UserDAO userDAO = new UserDAO();
            if (action == null || action.isEmpty()) {
                List<UserDTO> userList = userDAO.readAll();
                request.setAttribute("userList", userList);
                request.getRequestDispatcher(ADMIN_USERS_PAGE).forward(request, response);
            } else {
                switch (action) {
                    case "add":
                        if ("GET".equals(request.getMethod())) {
                            List<UserDTO> userList = userDAO.readAll();
                            request.setAttribute("userList", userList);
                            request.getRequestDispatcher(ADMIN_USERS_PAGE).forward(request, response);
                        } else if ("POST".equals(request.getMethod())) {
                            String userID = request.getParameter("userID");
                            String fullName = request.getParameter("fullName");
                            String roleID = request.getParameter("roleID");
                            String password = request.getParameter("password");
                            String gmail = request.getParameter("gmail");
                            String sdt = request.getParameter("sdt");

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
                                UserDTO newUser = new UserDTO(userID, fullName, roleID, password, gmail, sdt, null);
                                if (userDAO.create(newUser)) {
                                    request.setAttribute("successMessage", "Thêm người dùng thành công!");
                                } else {
                                    request.setAttribute("errorMessage", "Thêm người dùng thất bại!");
                                }
                            }

                            List<UserDTO> userList = userDAO.readAll();
                            request.setAttribute("userList", userList);
                            request.getRequestDispatcher(ADMIN_USERS_PAGE).forward(request, response);
                        }
                        break;

                    case "edit":
                        if ("GET".equals(request.getMethod())) {
                            String editUserID = request.getParameter("userID");
                            UserDTO editUser = userDAO.readById(editUserID);
                            if (editUser != null) {
                                request.setAttribute("editUser", editUser);
                            } else {
                                request.setAttribute("errorMessage", "Không tìm thấy người dùng để sửa!");
                            }
                            List<UserDTO> userList = userDAO.readAll();
                            request.setAttribute("userList", userList);
                            request.getRequestDispatcher(ADMIN_USERS_PAGE).forward(request, response);
                        } else if ("POST".equals(request.getMethod())) {
                            String userID = request.getParameter("userID");
                            String fullName = request.getParameter("fullName");
                            String roleID = request.getParameter("roleID");
                            String gmail = request.getParameter("gmail");
                            String sdt = request.getParameter("sdt");

                            UserDTO updatedUser = userDAO.readById(userID);
                            if (updatedUser != null) {
                                if (fullName == null || fullName.trim().isEmpty()) {
                                    request.setAttribute("errorMessage", "Họ tên không được để trống!");
                                } else if (!"US".equals(roleID) && !"AD".equals(roleID)) {
                                    request.setAttribute("errorMessage", "Vai trò không hợp lệ!");
                                } else if (gmail != null && !gmail.trim().isEmpty() && !Pattern.matches(EMAIL_PATTERN, gmail)) {
                                    request.setAttribute("errorMessage", "Email không đúng định dạng!");
                                } else if (sdt != null && !sdt.trim().isEmpty() && !Pattern.matches(PHONE_PATTERN, sdt)) {
                                    request.setAttribute("errorMessage", "Số điện thoại không đúng định dạng (9-12 số, có thể bắt đầu bằng +)!");
                                } else {
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

                            List<UserDTO> userList = userDAO.readAll();
                            request.setAttribute("userList", userList);
                            request.getRequestDispatcher(ADMIN_USERS_PAGE).forward(request, response);
                        }
                        break;

                    case "delete":
                        String deleteUserID = request.getParameter("userID");
                        if (userDAO.readById(deleteUserID) != null) {
                            if (userDAO.delete(deleteUserID)) {
                                request.setAttribute("successMessage", "Xóa người dùng thành công!");
                            } else {
                                request.setAttribute("errorMessage", "Xóa người dùng thất bại!");
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
        } else if ("/admin/rooms".equals(path)) {
            RoomDAO roomDAO = new RoomDAO();
            if (action == null || action.isEmpty()) {
                List<RoomDTO> roomList = roomDAO.getAllRooms();
                request.setAttribute("roomList", roomList);
                request.getRequestDispatcher(ADMIN_ROOMS_PAGE).forward(request, response);
            } else {
                switch (action) {
                    case "add":
                        if ("GET".equals(request.getMethod())) {
                            List<RoomDTO> roomList = roomDAO.getAllRooms();
                            request.setAttribute("roomList", roomList);
                            request.getRequestDispatcher(ADMIN_ROOMS_PAGE).forward(request, response);
                        } else if ("POST".equals(request.getMethod())) {
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
                                List<String> detailImages = detailImagesStr != null && !detailImagesStr.trim().isEmpty() ?
                                        Arrays.asList(detailImagesStr.split("\\r?\\n")) : new ArrayList<>();

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

                    case "edit":
                        if ("GET".equals(request.getMethod())) {
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
                        } else if ("POST".equals(request.getMethod())) {
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
                                List<String> detailImages = detailImagesStr != null && !detailImagesStr.trim().isEmpty() ?
                                        Arrays.asList(detailImagesStr.split("\\r?\\n")) : new ArrayList<>();

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

                    case "delete":
                        String deleteRoomIdStr = request.getParameter("roomId");
                        try {
                            int deleteRoomId = Integer.parseInt(deleteRoomIdStr);
                            if (roomDAO.delete(deleteRoomId)) {
                                request.setAttribute("successMessage", "Xóa phòng thành công!");
                            } else {
                                request.setAttribute("errorMessage", "Xóa phòng thất bại hoặc không tìm thấy phòng!");
                            }
                        } catch (NumberFormatException e) {
                            request.setAttribute("errorMessage", "ID phòng không hợp lệ!");
                        } catch (Exception e) {
                            request.setAttribute("errorMessage", "Lỗi hệ thống khi xóa phòng: " + e.getMessage());
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
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Page not found");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (Exception ex) {
            Logger.getLogger(AdminController.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (Exception ex) {
            Logger.getLogger(AdminController.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    public String getServletInfo() {
        return "Admin Controller for managing users, rooms, bookings, and statistics";
    }
}