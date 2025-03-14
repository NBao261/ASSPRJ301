package dao;

import dto.RoomDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import utils.DBUtils;

public class RoomDAO {

    public RoomDTO getRoomById(int roomId) throws Exception {
        RoomDTO room = null;
        String sqlRoom = "SELECT * FROM rooms WHERE id = ?";
        String sqlImages = "SELECT image_url FROM room_images WHERE room_id = ?";

        try (Connection conn = DBUtils.getConnection();
                PreparedStatement psRoom = conn.prepareStatement(sqlRoom);
                PreparedStatement psImages = conn.prepareStatement(sqlImages)) {

            if (conn == null) {
                throw new Exception("Cannot establish database connection");
            }

            psRoom.setInt(1, roomId);
            try (ResultSet rsRoom = psRoom.executeQuery()) {
                if (rsRoom.next()) {
                    room = new RoomDTO(
                            rsRoom.getInt("id"),
                            rsRoom.getString("name"),
                            rsRoom.getString("description"),
                            rsRoom.getDouble("price"),
                            rsRoom.getString("amenities"),
                            rsRoom.getFloat("ratings"),
                            rsRoom.getString("image_url"),
                            null
                    );

                    psImages.setInt(1, roomId);
                    try (ResultSet rsImages = psImages.executeQuery()) {
                        List<String> detailImages = new ArrayList<>();
                        while (rsImages.next()) {
                            detailImages.add(rsImages.getString("image_url"));
                        }
                        room.setDetailImages(detailImages);
                    }
                }
            }
        } catch (Exception e) {
            throw new Exception("Error retrieving room by ID " + roomId + ": " + e.getMessage(), e);
        }
        return room;
    }

    public RoomDTO getRoomByName(String roomName) throws Exception {
        RoomDTO room = null;
        String sqlRoom = "SELECT * FROM rooms WHERE name = ?";
        String sqlImages = "SELECT image_url FROM room_images WHERE room_id = ?";

        try (Connection conn = DBUtils.getConnection();
                PreparedStatement psRoom = conn.prepareStatement(sqlRoom);
                PreparedStatement psImages = conn.prepareStatement(sqlImages)) {

            if (conn == null) {
                throw new Exception("Cannot establish database connection");
            }

            psRoom.setString(1, roomName);
            try (ResultSet rsRoom = psRoom.executeQuery()) {
                if (rsRoom.next()) {
                    room = new RoomDTO(
                            rsRoom.getInt("id"),
                            rsRoom.getString("name"),
                            rsRoom.getString("description"),
                            rsRoom.getDouble("price"),
                            rsRoom.getString("amenities"),
                            rsRoom.getFloat("ratings"),
                            rsRoom.getString("image_url"),
                            null
                    );

                    psImages.setInt(1, room.getId());
                    try (ResultSet rsImages = psImages.executeQuery()) {
                        List<String> detailImages = new ArrayList<>();
                        while (rsImages.next()) {
                            detailImages.add(rsImages.getString("image_url"));
                        }
                        room.setDetailImages(detailImages);
                    }
                }
            }
        } catch (Exception e) {
            throw new Exception("Error retrieving room by name " + roomName + ": " + e.getMessage(), e);
        }
        return room;
    }

    public List<RoomDTO> getAllRooms() throws Exception {
        List<RoomDTO> roomList = new ArrayList<>();
        String sqlRoom = "SELECT * FROM rooms";
        String sqlImages = "SELECT image_url FROM room_images WHERE room_id = ?";

        try (Connection conn = DBUtils.getConnection();
                PreparedStatement psRoom = conn.prepareStatement(sqlRoom);
                PreparedStatement psImages = conn.prepareStatement(sqlImages)) {

            if (conn == null) {
                throw new Exception("Cannot establish database connection");
            }

            try (ResultSet rsRoom = psRoom.executeQuery()) {
                while (rsRoom.next()) {
                    RoomDTO room = new RoomDTO(
                            rsRoom.getInt("id"),
                            rsRoom.getString("name"),
                            rsRoom.getString("description"),
                            rsRoom.getDouble("price"),
                            rsRoom.getString("amenities"),
                            rsRoom.getFloat("ratings"),
                            rsRoom.getString("image_url"),
                            null
                    );

                    psImages.setInt(1, room.getId());
                    try (ResultSet rsImages = psImages.executeQuery()) {
                        List<String> detailImages = new ArrayList<>();
                        while (rsImages.next()) {
                            detailImages.add(rsImages.getString("image_url"));
                        }
                        room.setDetailImages(detailImages);
                    }

                    roomList.add(room);
                }
            }
        } catch (Exception e) {
            throw new Exception("Error retrieving all rooms: " + e.getMessage(), e);
        }
        return roomList;
    }

    public boolean create(RoomDTO room) throws Exception {
        String sqlRoom = "INSERT INTO rooms (name, description, price, amenities, ratings, image_url) VALUES (?, ?, ?, ?, ?, ?)";
        String sqlImages = "INSERT INTO room_images (room_id, image_url) VALUES (?, ?)";

        try (Connection conn = DBUtils.getConnection()) {
            if (conn == null) {
                throw new Exception("Cannot establish database connection");
            }

            // Thêm vào bảng rooms
            try (PreparedStatement psRoom = conn.prepareStatement(sqlRoom, PreparedStatement.RETURN_GENERATED_KEYS)) {
                psRoom.setString(1, room.getName());
                psRoom.setString(2, room.getDescription());
                psRoom.setDouble(3, room.getPrice());
                psRoom.setString(4, room.getAmenities());
                psRoom.setFloat(5, room.getRatings());
                psRoom.setString(6, room.getImageUrl());

                int affectedRows = psRoom.executeUpdate();
                if (affectedRows == 0) {
                    return false;
                }

                // Lấy ID vừa tạo
                try (ResultSet generatedKeys = psRoom.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int roomId = generatedKeys.getInt(1);
                        room.setId(roomId);

                        // Thêm detailImages nếu có
                        if (room.getDetailImages() != null && !room.getDetailImages().isEmpty()) {
                            try (PreparedStatement psImages = conn.prepareStatement(sqlImages)) {
                                for (String imageUrl : room.getDetailImages()) {
                                    psImages.setInt(1, roomId);
                                    psImages.setString(2, imageUrl);
                                    psImages.addBatch();
                                }
                                psImages.executeBatch();
                            }
                        }
                        return true;
                    } else {
                        return false;
                    }
                }
            }
        } catch (Exception e) {
            throw new Exception("Error creating room: " + e.getMessage(), e);
        }
    }

    public boolean update(RoomDTO room) throws Exception {
        String sqlRoom = "UPDATE rooms SET name = ?, description = ?, price = ?, amenities = ?, ratings = ?, image_url = ? WHERE id = ?";
        String sqlDeleteImages = "DELETE FROM room_images WHERE room_id = ?";
        String sqlInsertImages = "INSERT INTO room_images (room_id, image_url) VALUES (?, ?)";

        try (Connection conn = DBUtils.getConnection()) {
            if (conn == null) {
                throw new Exception("Cannot establish database connection");
            }

            // Cập nhật bảng rooms
            try (PreparedStatement psRoom = conn.prepareStatement(sqlRoom)) {
                psRoom.setString(1, room.getName());
                psRoom.setString(2, room.getDescription());
                psRoom.setDouble(3, room.getPrice());
                psRoom.setString(4, room.getAmenities());
                psRoom.setFloat(5, room.getRatings());
                psRoom.setString(6, room.getImageUrl());
                psRoom.setInt(7, room.getId());

                int affectedRows = psRoom.executeUpdate();
                if (affectedRows == 0) {
                    return false;
                }

                // Xóa và thêm lại detailImages
                try (PreparedStatement psDelete = conn.prepareStatement(sqlDeleteImages)) {
                    psDelete.setInt(1, room.getId());
                    psDelete.executeUpdate();
                }

                if (room.getDetailImages() != null && !room.getDetailImages().isEmpty()) {
                    try (PreparedStatement psInsert = conn.prepareStatement(sqlInsertImages)) {
                        for (String imageUrl : room.getDetailImages()) {
                            psInsert.setInt(1, room.getId());
                            psInsert.setString(2, imageUrl);
                            psInsert.addBatch();
                        }
                        psInsert.executeBatch();
                    }
                }
                return true;
            }
        } catch (Exception e) {
            throw new Exception("Error updating room: " + e.getMessage(), e);
        }
    }

    public boolean delete(int roomId) throws Exception {
        String sqlDeleteImages = "DELETE FROM room_images WHERE room_id = ?";
        String sqlDeleteRoom = "DELETE FROM rooms WHERE id = ?";

        try (Connection conn = DBUtils.getConnection()) {
            if (conn == null) {
                throw new Exception("Cannot establish database connection");
            }

            // Xóa detailImages trước
            try (PreparedStatement psDeleteImages = conn.prepareStatement(sqlDeleteImages)) {
                psDeleteImages.setInt(1, roomId);
                psDeleteImages.executeUpdate();
            }

            // Xóa phòng
            try (PreparedStatement psDeleteRoom = conn.prepareStatement(sqlDeleteRoom)) {
                psDeleteRoom.setInt(1, roomId);
                int affectedRows = psDeleteRoom.executeUpdate();
                return affectedRows > 0;
            }
        } catch (Exception e) {
            throw new Exception("Error deleting room: " + e.getMessage(), e);
        }
    }

    public List<RoomDTO> getFilteredRooms(String homestayName, Double maxPrice, String priceFilterType, String amenities) {
        List<RoomDTO> rooms = new ArrayList<>();
        String sql = "SELECT * FROM Rooms WHERE 1=1";

        // Xây dựng điều kiện lọc linh hoạt
        if (homestayName != null && !homestayName.isEmpty()) {
            sql += " AND LOWER(name) LIKE ?";
        }
        if (maxPrice != null) {
            if ("below".equals(priceFilterType)) {
                sql += " AND price <= ?";
            } else if ("above".equals(priceFilterType)) {
                sql += " AND price >= ?";
            }
        }
        if (amenities != null && !amenities.isEmpty()) {
            sql += " AND LOWER(amenities) LIKE ?";
        }

        try (Connection conn = DBUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            int index = 1;
            if (homestayName != null && !homestayName.isEmpty()) {
                ps.setString(index++, "%" + homestayName.toLowerCase() + "%");
            }
            if (maxPrice != null) {
                ps.setDouble(index++, maxPrice);
            }
            if (amenities != null && !amenities.isEmpty()) {
                ps.setString(index++, "%" + amenities.toLowerCase() + "%");
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                rooms.add(new RoomDTO(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getDouble("price"),
                        rs.getString("amenities"),
                        rs.getFloat("ratings"),
                        rs.getString("image_url"),
                        new ArrayList<>()
                ));
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return rooms;
    }

    // Phương thức lấy tổng số phòng
    public int getTotalRoomCount() throws Exception {
        String sql = "SELECT COUNT(*) FROM rooms";
        try (Connection conn = utils.DBUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    // Phương thức lấy danh sách phòng theo trang
    public List<RoomDTO> getRoomsByPage(int offset, int limit) throws Exception {
        List<RoomDTO> roomList = new ArrayList<>();
        String sql = "SELECT * FROM rooms ORDER BY id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection conn = utils.DBUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    RoomDTO room = new RoomDTO();
                    room.setId(rs.getInt("id"));
                    room.setName(rs.getString("name"));
                    room.setDescription(rs.getString("description"));
                    room.setPrice(rs.getDouble("price"));
                    room.setAmenities(rs.getString("amenities"));
                    room.setRatings(rs.getFloat("ratings"));
                    room.setImageUrl(rs.getString("image_url"));
                    // Ánh xạ các cột khác nếu cần
                    roomList.add(room);
                }
            }
        }
        return roomList;
    }

    public List<RoomDTO> filterRooms(String searchName, Double maxPrice, String priceFilterType, String amenities, int offset, int limit) throws Exception {
        List<RoomDTO> roomList = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM rooms WHERE 1=1");

        // Xây dựng điều kiện lọc
        List<Object> params = new ArrayList<>();
        if (searchName != null && !searchName.trim().isEmpty()) {
            sql.append(" AND name LIKE ?");
            params.add("%" + searchName + "%");
        }
        if (maxPrice != null) {
            if ("below".equals(priceFilterType)) {
                sql.append(" AND price <= ?");
            } else {
                sql.append(" AND price >= ?");
            }
            params.add(maxPrice);
        }
        if (amenities != null && !amenities.trim().isEmpty()) {
            sql.append(" AND amenities LIKE ?");
            params.add("%" + amenities + "%");
        }

        // Thêm phân trang
        sql.append(" ORDER BY id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add(offset);
        params.add(limit);

        try (Connection conn = utils.DBUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    RoomDTO room = new RoomDTO();
                    room.setId(rs.getInt("id"));
                    room.setName(rs.getString("name"));
                    room.setDescription(rs.getString("description"));
                    room.setPrice(rs.getDouble("price"));
                    room.setAmenities(rs.getString("amenities"));
                    room.setRatings(rs.getFloat("ratings"));
                    room.setImageUrl(rs.getString("image_url"));
                    roomList.add(room);
                }
            }
        }
        return roomList;
    }
}
