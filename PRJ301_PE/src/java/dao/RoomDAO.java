/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao;

import dto.RoomDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import sample.utils.DBUtils;


public class RoomDAO {

    public List<RoomDTO> searchRoomByName(String searchName) {
        List<RoomDTO> rooms = new ArrayList<>();
        String sql = "SELECT * FROM tblRooms WHERE name LIKE ? AND status = 1";
        try {
            Connection conn = DBUtils.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, "%" + searchName + "%");
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                rooms.add(new RoomDTO(rs.getString("id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getFloat("price"),
                        rs.getFloat("area"),
                        null));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return rooms;
    }

    public RoomDTO getRoomById(String roomID) {
        String sql = "SELECT * FROM tblRooms WHERE id = ?";
        try (Connection conn = DBUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, roomID);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return new RoomDTO(
                        rs.getString("id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getFloat("price"),
                        rs.getFloat("area"),
                        null
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateRoom(String roomID, String name, String description, float price, float area) {
        String sql = "UPDATE tblRooms SET name = ?, description = ?, price = ?, area = ? WHERE id = ?";
        try (Connection conn = DBUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, name);
            ps.setString(2, description);
            ps.setFloat(3, price);
            ps.setFloat(4, area);
            ps.setString(5, roomID);

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
