package dao;

import dto.BookingDTO;
import dto.RoomDTO;
import dto.UserDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import utils.DBUtils;

public class BookingDAO {

    // Hằng số cho các trạng thái đặt phòng
    public static final String STATUS_PENDING = "Pending";
    public static final String STATUS_CONFIRMED = "Confirmed";
    public static final String STATUS_CANCELLED = "Cancelled";

    // Thêm đặt phòng mới sau khi kiểm tra phòng có sẵn
    public boolean addBooking(BookingDTO booking) throws ClassNotFoundException {
        if (booking == null || !isRoomAvailable(booking.getRoom().getId(), booking.getCheckInDate(), booking.getCheckOutDate())) {
            return false;
        }

        String sql = "INSERT INTO bookings (userID, room_id, check_in_date, check_out_date, total_price, status, created_at) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, booking.getUser().getUserID());
            ps.setInt(2, booking.getRoom().getId());
            ps.setDate(3, new java.sql.Date(booking.getCheckInDate().getTime()));
            ps.setDate(4, new java.sql.Date(booking.getCheckOutDate().getTime()));
            ps.setDouble(5, booking.getTotalPrice());
            ps.setString(6, booking.getStatus());
            ps.setTimestamp(7, new Timestamp(booking.getCreatedAt().getTime()));
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error adding booking: " + e.getMessage());
            return false;
        }
    }

    // Kiểm tra phòng có sẵn không
    public boolean isRoomAvailable(int roomId, java.util.Date checkIn, java.util.Date checkOut) throws ClassNotFoundException {
        if (roomId <= 0 || checkIn == null || checkOut == null || checkOut.before(checkIn)) {
            return false;
        }

        String sql = "SELECT COUNT(*) FROM bookings WHERE room_id = ? AND (check_in_date < ? AND check_out_date > ?) AND status != ?";
        try (Connection conn = DBUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ps.setDate(2, new java.sql.Date(checkOut.getTime()));
            ps.setDate(3, new java.sql.Date(checkIn.getTime()));
            ps.setString(4, STATUS_CANCELLED);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) == 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error checking room availability: " + e.getMessage());
        }
        return false;
    }

    // Lấy danh sách đặt phòng theo userID
    public List<BookingDTO> getBookingsByUserId(String userID) throws ClassNotFoundException, Exception {
        List<BookingDTO> bookings = new ArrayList<>();
        String sql = "SELECT * FROM bookings WHERE userID = ? ORDER BY created_at DESC";
        try (Connection conn = DBUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    bookings.add(mapResultSetToBooking(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching bookings by user ID: " + e.getMessage());
        }
        return bookings;
    }

    // Lấy danh sách đặt phòng theo room_id
    public List<BookingDTO> getBookingsByRoomId(int roomId) throws ClassNotFoundException, Exception {
        List<BookingDTO> bookings = new ArrayList<>();
        if (roomId <= 0) {
            return bookings;
        }

        String sql = "SELECT * FROM bookings WHERE room_id = ? ORDER BY created_at DESC";
        try (Connection conn = DBUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    bookings.add(mapResultSetToBooking(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching bookings by room ID: " + e.getMessage());
        }
        return bookings;
    }

    // Hủy đặt phòng bằng cách cập nhật trạng thái
    public boolean cancelBooking(int bookingId) throws ClassNotFoundException {
        return updateBookingStatus(bookingId, STATUS_CANCELLED);
    }

    // Cập nhật trạng thái đặt phòng
    public boolean updateBookingStatus(int bookingId, String status) throws ClassNotFoundException {
        if (bookingId <= 0 || status == null || status.trim().isEmpty()) {
            return false;
        }

        String sql = "UPDATE bookings SET status = ? WHERE id = ?";
        try (Connection conn = DBUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, bookingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error updating booking status: " + e.getMessage());
            return false;
        }
    }

    // Xóa đặt phòng hoàn toàn khỏi cơ sở dữ liệu
    public boolean delete(int bookingId) throws ClassNotFoundException {
        if (bookingId <= 0) {
            return false;
        }

        String sql = "DELETE FROM bookings WHERE id = ?";
        try (Connection conn = DBUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting booking: " + e.getMessage());
            return false;
        }
    }

    // Map dữ liệu từ ResultSet sang BookingDTO
    private BookingDTO mapResultSetToBooking(ResultSet rs) throws SQLException, Exception {
        UserDAO userDAO = new UserDAO();
        UserDTO user = userDAO.readById(rs.getString("userID"));

        RoomDAO roomDAO = new RoomDAO();
        RoomDTO room = roomDAO.getRoomById(rs.getInt("room_id"));

        return new BookingDTO(
                rs.getInt("id"),
                user,
                room,
                rs.getDate("check_in_date"),
                rs.getDate("check_out_date"),
                rs.getDouble("total_price"),
                rs.getString("status"),
                rs.getTimestamp("created_at")
        );
    }

    // Lấy thông tin đặt phòng theo ID
    public BookingDTO getBookingById(int bookingId) throws ClassNotFoundException, Exception {
        if (bookingId <= 0) {
            return null;
        }

        String sql = "SELECT * FROM bookings WHERE id = ?";
        try (Connection conn = DBUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToBooking(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching booking by ID: " + e.getMessage());
        }
        return null;
    }

    // Lấy thông tin đặt phòng theo userID và room_id
    public BookingDTO getBookingByUserAndRoom(String userId, int roomId) throws ClassNotFoundException, Exception {
        if (userId == null || userId.trim().isEmpty() || roomId <= 0) {
            return null;
        }

        String sql = "SELECT * FROM bookings WHERE userID = ? AND room_id = ? AND status != ?";
        try (Connection conn = DBUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userId);
            ps.setInt(2, roomId);
            ps.setString(3, STATUS_CANCELLED);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToBooking(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching booking by user and room: " + e.getMessage());
        }
        return null;
    }

    // Lấy tất cả đặt phòng
    public List<BookingDTO> getAllBookings() throws ClassNotFoundException, Exception {
        List<BookingDTO> bookings = new ArrayList<>();
        String sql = "SELECT * FROM bookings ORDER BY created_at DESC";
        try (Connection conn = DBUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    bookings.add(mapResultSetToBooking(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching all bookings: " + e.getMessage());
        }
        return bookings;
    }

    // Lấy danh sách đặt phòng trong khoảng thời gian
    public List<BookingDTO> getBookingsByDateRange(Date startDate, Date endDate) throws Exception {
        List<BookingDTO> bookingList = new ArrayList<>();
        if (startDate == null || endDate == null || endDate.before(startDate)) {
            return bookingList; // Trả về danh sách rỗng nếu tham số không hợp lệ
        }

        String sql = "SELECT * FROM bookings WHERE created_at BETWEEN ? AND ? ORDER BY created_at DESC";
        try (Connection conn = DBUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTimestamp(1, new Timestamp(startDate.getTime()));
            ps.setTimestamp(2, new Timestamp(endDate.getTime()));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    bookingList.add(mapResultSetToBooking(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching bookings by date range: " + e.getMessage());
            throw new Exception("Lỗi khi truy vấn dữ liệu đặt phòng theo khoảng thời gian: " + e.getMessage(), e);
        }
        return bookingList;
    }
//    // Phương thức lấy tổng số booking của một người dùng
//
//    public int getTotalBookingCountByUser(String userId) throws Exception {
//        String sql = "SELECT COUNT(*) FROM bookings WHERE user_id = ?";
//        try (Connection conn = utils.DBUtils.getConnection();
//                PreparedStatement ps = conn.prepareStatement(sql)) {
//            ps.setString(1, userId);
//            try (ResultSet rs = ps.executeQuery()) {
//                if (rs.next()) {
//                    return rs.getInt(1);
//                }
//            }
//        }
//        return 0;
//    }
//
//    // Phương thức lấy danh sách booking của một người dùng theo phân trang
//    public List<BookingDTO> getBookingsByUserId(String userId, int offset, int limit) throws Exception {
//        List<BookingDTO> bookingList = new ArrayList<>();
//        String sql = "SELECT b.*, r.id as room_id, r.name as room_name, r.description, r.price as room_price, r.amenities, r.ratings, r.image_url "
//                + "FROM bookings b "
//                + "LEFT JOIN rooms r ON b.room_id = r.id "
//                + "WHERE b.user_id = ? "
//                + "ORDER BY b.id "
//                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
//        try (Connection conn = utils.DBUtils.getConnection();
//                PreparedStatement ps = conn.prepareStatement(sql)) {
//            ps.setString(1, userId);
//            ps.setInt(2, offset);
//            ps.setInt(3, limit);
//            try (ResultSet rs = ps.executeQuery()) {
//                while (rs.next()) {
//                    BookingDTO booking = new BookingDTO();
//                    booking.setId(rs.getInt("id"));
//                    booking.setCheckInDate(rs.getDate("check_in_date"));
//                    booking.setCheckOutDate(rs.getDate("check_out_date"));
//                    booking.setTotalPrice(rs.getDouble("total_price"));
//                    booking.setStatus(rs.getString("status"));
//
//                    // Ánh xạ thông tin phòng
//                    RoomDTO room = new RoomDTO();
//                    room.setId(rs.getInt("room_id"));
//                    room.setName(rs.getString("room_name"));
//                    room.setDescription(rs.getString("description"));
//                    room.setPrice(rs.getDouble("room_price"));
//                    room.setAmenities(rs.getString("amenities"));
//                    room.setRatings(rs.getFloat("ratings"));
//                    room.setImageUrl(rs.getString("image_url"));
//                    booking.setRoom(room);
//
//                    // Ánh xạ thông tin người dùng (nếu cần)
//                    UserDTO user = new UserDTO();
//                    user.setUserID(userId);
//                    booking.setUser(user);
//
//                    bookingList.add(booking);
//                }
//            }
//        }
//        return bookingList;
//    }
}
