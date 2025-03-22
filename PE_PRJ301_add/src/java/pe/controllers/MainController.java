package pe.controllers;

import java.io.IOException;
import java.util.Date;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import pe.account.AccountDAO;
import pe.account.AccountDTO;
import pe.appointment.AppointmentDAO;
import pe.appointment.AppointmentDTO;

@WebServlet(name = "MainController", urlPatterns = {"/MainController"})
public class MainController extends HttpServlet {

    private AppointmentDAO appointmentDAO = new AppointmentDAO();
    private AccountDAO accountDAO = new AccountDAO();
    private static final String ERROR = "login.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        response.setContentType("text/html;charset=UTF-8");
        String url = ERROR;
        try {
            //your code here
            String action = request.getParameter("action");
            if (action == null) {
                url = ERROR;
            } else if ("login".equals(action)) {
                String account = request.getParameter("txtAccount");
                String pass = request.getParameter("txtPass");

                AccountDTO user = accountDAO.login(account, pass);

                if (user != null) {
                    url = "appointments.jsp";
                    session.setAttribute("user", user);
                    List<AppointmentDTO> appointment = appointmentDAO.getAll();
                    request.setAttribute("appointment", appointment);
                    request.getRequestDispatcher(url).forward(request, response);
                    return;
                } else {
                    request.setAttribute("error", "Incorrect account or Password");
                    request.getRequestDispatcher(url).forward(request, response);
                    return;
                }
            } else if ("logout".equals(action)) {
                if (session != null) {
                    session.invalidate();
                    response.sendRedirect(url);
                    return;
                }
            } else if ("create".equals(action)) {
                int idApp = Integer.parseInt(request.getParameter("idApp"));
                String account = request.getParameter("account");
                String partnerPhone = request.getParameter("partnerPhone");
                String partnerName = request.getParameter("partnerName");
                Date timeToMeet = java.sql.Date.valueOf(request.getParameter("timeToMeet"));
                String place = request.getParameter("place");
                float expense = Float.parseFloat(request.getParameter("expense"));
                String note = request.getParameter("note");

                AppointmentDTO appointment = new AppointmentDTO(idApp, account, partnerPhone, partnerName, timeToMeet, place, expense, note);
                if (appointmentDAO.create(appointment)) {
                    url = "appointments.jsp";
                    request.setAttribute("appointment", appointment);
                    request.getRequestDispatcher(url).forward(request, response);
                } else {
                    url = "create.jsp";
                    request.setAttribute("error", "Fail");
                    request.getRequestDispatcher(url).forward(request, response);
                }
                return;
            }

        } catch (Exception e) {
            log("Error at MainController: " + e.toString());
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }

}
