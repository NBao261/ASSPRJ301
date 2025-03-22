package pe.appointment;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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
                        rs.getDate("timeToMeet"),
                        rs.getString("place"),
                        rs.getFloat("expense"),
                        rs.getString("note")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return appointment;
    }

    public boolean create(AppointmentDTO appointment) {
        String sql = "INSERT INTO Appointments (idApp, account, partnerPhone, partnerName, timeToMeet, place, expense, note)" + ""
                + " VALUES (?,?,?,?,?,?,?,?)";
        try {
            Connection conn = DBUtils.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, appointment.getIdApp());
            ps.setString(2, appointment.getAccount());
            ps.setString(3, appointment.getPartnerPhone());
            ps.setString(4, appointment.getPartnerName());
            ps.setDate(5, new java.sql.Date(appointment.getTimeToMeet().getTime()));
            ps.setString(6, appointment.getPlace());
            ps.setFloat(7, appointment.getExpense());
            ps.setString(8, appointment.getNote());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
