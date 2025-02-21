package dao;

import dto.RoomDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import utils.DBUtils;

public class RoomDAO {
    public RoomDTO getRoomByName(String roomName) {
        RoomDTO room = null;
        String sql = "SELECT * FROM rooms WHERE name = ?";
        
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, roomName);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                room = new RoomDTO(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getDouble("price"),
                    rs.getString("amenities"),
                    rs.getFloat("ratings"),
                    rs.getString("image_url")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return room;
    }
}
