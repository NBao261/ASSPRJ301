package pe.appointment;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import pe.utils.DBUtils;

public class AppointmentDAO {

    //your code here
    public List<AppointmentDTO> getAll() {
        List<AppointmentDTO> appointment = new ArrayList<>();
        String sql = "SELECT * FROM Appointments";
        try {
            Connection conn = DBUtils.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                appointment.add(new AppointmentDTO(rs.getInt("idApp"),
                        rs.getString("account"),
                        rs.getString("partnerPhone"),
                        rs.getString("partnerName"),
                        rs.getTimestamp("timeToMeet"),
                        rs.getString("place"),
                        rs.getFloat("expense"),
                        rs.getString("note")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return appointment;
    }

    public boolean create(AppointmentDTO appointment) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO Appointments (account, partnerPhone, partnerName, timeToMeet, place, expense, note) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, appointment.getAccount());
            ps.setString(2, appointment.getPartnerPhone());
            ps.setString(3, appointment.getPartnerName());
            ps.setTimestamp(4, appointment.getTimeToMeet());
            ps.setString(5, appointment.getPlace());
            ps.setFloat(6, appointment.getExpense());
            ps.setString(7, appointment.getNote());

            return ps.executeUpdate() > 0;
        }
    }
}
