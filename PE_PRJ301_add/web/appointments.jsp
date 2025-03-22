<%@page import="java.util.List"%>
<%@page import="pe.appointment.AppointmentDTO"%>
<%@page import="pe.account.AccountDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>List of the appointments </title>
    </head>
    <body>
        <h1>The appointments</h1>
        <hr/>
        <!--your code here-->
        <%
            AccountDTO user = (AccountDTO) session.getAttribute("user");
            if (user == null) {
                response.sendRedirect("login.jsp");
                return;
            }
        %>
        <h2>
            Welcome <%=user.getFullName()%>
        </h2>

        <form action="MainController" method="POST">
            <input type="hidden" name="action" value="logout"/>
            <input type="submit" value="logout"/>
        </form>

        <br>

        <table border ="1">
            <tr>
                <th>idApp</th>
                <th>account</th>
                <th>partnerPhone</th>
                <th>partnerName</th>
                <th>timeToMeet</th>
                <th>place</th>
                <th>expense</th>
                <th>note</th>
            </tr>

            <%
                List<AppointmentDTO> appointment = (List<AppointmentDTO>) request.getAttribute("appointment");
                if (appointment != null) {
                    for (AppointmentDTO appointments : appointment) {
            %>

            <tr>
                <td> <%= appointments.getIdApp()%> </td>
                <td> <%= appointments.getAccount()%></td>
                <td><%= appointments.getPartnerPhone()%></td>
                <td><%= appointments.getPartnerName()%></td>
                <td><%= appointments.getTimeToMeet()%></td>
                <td><%= appointments.getPlace()%></td>
                <td><%= appointments.getExpense()%></td>
                <td><%= appointments.getNote()%></td>

            </tr>
            <%
                    }
                }
            %>
        </table>
        <%
            if (user != null && user.getRoleDB().equals("super")) {
        %>
        <a href="create.jsp">Create</a>
        <%            }
        %>
    </body>
</html>
