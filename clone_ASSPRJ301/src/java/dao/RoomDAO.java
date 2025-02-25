package dao;

import dto.RoomDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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

            // Truy vấn thông tin phòng
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
                    
                    // Truy vấn danh sách ảnh chi tiết
                    psImages.setInt(1, roomId);
                    try (ResultSet rsImages = psImages.executeQuery()) {
                        List<String> detailImages = new ArrayList<>();
                        while (rsImages.next()) {
                            detailImages.add(rsImages.getString("image_url"));
                        }
                        room.setDetailImages(detailImages); // Gán danh sách ảnh chi tiết
                    }
                }
            }
        } catch (Exception e) {
            throw new Exception("Error retrieving room by ID " + roomId + ": " + e.getMessage(), e);
        }
        return room; // Trả về null nếu không tìm thấy phòng
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

            // Truy vấn thông tin phòng
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
                        null // detailImages để null, sẽ cập nhật sau
                    );
                    
                    // Truy vấn danh sách ảnh chi tiết
                    psImages.setInt(1, room.getId());
                    try (ResultSet rsImages = psImages.executeQuery()) {
                        List<String> detailImages = new ArrayList<>();
                        while (rsImages.next()) {
                            detailImages.add(rsImages.getString("image_url"));
                        }
                        room.setDetailImages(detailImages); // Gán danh sách ảnh chi tiết
                    }
                }
            }
        } catch (Exception e) {
            throw new Exception("Error retrieving room by name " + roomName + ": " + e.getMessage(), e);
        }
        return room; 
    }
}