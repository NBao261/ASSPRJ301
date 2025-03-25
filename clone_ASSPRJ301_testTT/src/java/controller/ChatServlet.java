package controller;

import dao.BookingDAO;
import dao.NotificationDAO;
import dao.RoomDAO;
import dao.UserDAO;
import dto.BookingDTO;
import dto.NotificationDTO;
import dto.RoomDTO;
import dto.UserDTO;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.json.JSONObject;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.logging.Logger;
import java.util.logging.Level;
import java.util.Properties;
import java.io.FileInputStream;
import java.io.File;

@WebServlet(name = "ChatServlet", urlPatterns = {"/ChatServlet"})
public class ChatServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ChatServlet.class.getName());
    private static String GROK_API_KEY;
    private static final String GROK_API_URL = "https://api.x.ai/v1/chat/completions";
    private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
    private static final SimpleDateFormat TIME_FORMATTER = new SimpleDateFormat("HH:mm:ss");

    @Override
    public void init() throws ServletException {
        try {
            // Load configuration from WEB-INF/config.properties
            String configPath = getServletContext().getRealPath("/WEB-INF/config.properties");
            File configFile = new File(configPath);
            
            if (!configFile.exists()) {
                LOGGER.log(Level.SEVERE, "Configuration file not found at: {0}", configPath);
                throw new ServletException("Configuration file not found");
            }

            Properties props = new Properties();
            try (FileInputStream fis = new FileInputStream(configFile)) {
                props.load(fis);
            }

            GROK_API_KEY = props.getProperty("grok.api.key");
            if (GROK_API_KEY == null || GROK_API_KEY.trim().isEmpty()) {
                LOGGER.log(Level.SEVERE, "Grok API key not found in configuration");
                throw new ServletException("Grok API key not found in configuration");
            }
            
            LOGGER.log(Level.INFO, "ChatServlet initialized successfully");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to initialize ChatServlet", e);
            throw new ServletException("Failed to initialize ChatServlet", e);
        }
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/plain;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        String grokResponse = "";

        try {
            // Validate session
            if (session == null) {
                response.getWriter().write("Phiên làm việc đã hết hạn. Vui lòng đăng nhập lại.");
                return;
            }

            // Handle clear history request
            if ("true".equals(request.getParameter("clearHistory"))) {
                session.removeAttribute("chatHistory");
                session.removeAttribute("chatState");
                grokResponse = "Lịch sử chat đã được xóa thành công.";
                response.getWriter().write(grokResponse);
                return;
            }

            // Handle booking confirmation
            String confirmBooking = request.getParameter("confirmBooking");
            if (confirmBooking != null && confirmBooking.equals("true")) {
                grokResponse = confirmAndSaveBooking(session);
                session.removeAttribute("chatState");
                response.getWriter().write(grokResponse);
                updateChatHistory(session, "You", "Xác nhận đặt phòng", grokResponse);
                return;
            }

            // Process user message
            String userMessage = request.getParameter("message");
            if (userMessage == null || userMessage.trim().isEmpty()) {
                response.getWriter().write("Vui lòng nhập tin nhắn.");
                return;
            }

            userMessage = userMessage.toLowerCase().trim();
            String chatState = (String) session.getAttribute("chatState");

            if (chatState != null) {
                switch (chatState) {
                    case "awaiting_booking_details":
                        grokResponse = processBookingDetails(userMessage, session);
                        break;
                    case "awaiting_suggestion_amenities":
                        grokResponse = processSuggestionAmenities(userMessage, session);
                        break;
                    default:
                        grokResponse = "Lỗi trạng thái hội thoại. Vui lòng thử lại.";
                        session.removeAttribute("chatState");
                }
            } else {
                String apiResponse = callGrokAPI(userMessage);
                grokResponse = processApiResponse(apiResponse, userMessage, session);
            }

            // Update chat history and send response
            updateChatHistory(session, "You", userMessage, grokResponse);
            response.getWriter().write(grokResponse);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing chat request", e);
            String errorMessage = "Lỗi hệ thống: " + (e.getMessage() != null ? e.getMessage() : "Không xác định");
            response.getWriter().write(errorMessage);
        }
    }

    private void updateChatHistory(HttpSession session, String sender, String message, String response) {
        List<String[]> chatHistory = (List<String[]>) session.getAttribute("chatHistory");
        if (chatHistory == null) {
            chatHistory = new ArrayList<>();
        }
        String timestamp = TIME_FORMATTER.format(new Date());
        chatHistory.add(new String[]{sender, message, timestamp});
        if (response != null) {
            chatHistory.add(new String[]{"Grok", response, timestamp});
        }
        session.setAttribute("chatHistory", chatHistory);
    }

    private String callGrokAPI(String userMessage) throws IOException {
        LOGGER.log(Level.INFO, "Sending request to Grok API with message: " + userMessage);
        CloseableHttpClient client = HttpClients.createDefault();
        HttpPost httpPost = new HttpPost(GROK_API_URL);

        httpPost.setHeader("Content-Type", "application/json");
        httpPost.setHeader("Accept", "application/json");
        httpPost.setHeader("Authorization", "Bearer " + GROK_API_KEY);

        String systemPrompt = "Bạn là một trợ lý đặt phòng homestay, trả lời bằng tiếng Việt. " +
                "Bạn có thể giúp người dùng đặt phòng, gợi ý phòng dựa trên tiện ích, và trả lời các câu hỏi về homestay. " +
                "Khi người dùng muốn đặt phòng, hãy hướng dẫn họ cung cấp thông tin theo định dạng: tên phòng, ngày và giờ check-in. " +
                "Khi người dùng muốn gợi ý phòng, hãy yêu cầu họ liệt kê các tiện ích cần thiết.";

        String jsonInputString = String.format(
                "{\"model\": \"grok-2-latest\", \"messages\": [{\"role\": \"system\", \"content\": \"%s\"}, {\"role\": \"user\", \"content\": \"%s\"}], \"temperature\": 0.7, \"max_tokens\": 1024}",
                systemPrompt.replace("\"", "\\\""),
                userMessage.replace("\"", "\\\"")
        );
        httpPost.setEntity(new StringEntity(jsonInputString, "UTF-8"));

        try (CloseableHttpResponse response = client.execute(httpPost)) {
            int statusCode = response.getStatusLine().getStatusCode();
            if (statusCode != 200) {
                String errorMessage = readResponse(response);
                LOGGER.log(Level.SEVERE, "Grok API error: " + errorMessage);
                throw new IOException("Lỗi từ API Grok (HTTP " + statusCode + "): " + errorMessage);
            }

            String result = readResponse(response);
            LOGGER.log(Level.INFO, "Received response from Grok API: " + result);
            return result;
        } finally {
            client.close();
        }
    }

    private String readResponse(CloseableHttpResponse response) throws IOException {
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(response.getEntity().getContent(), "UTF-8"))) {
            StringBuilder result = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                result.append(line);
            }
            return result.toString();
        }
    }

    private String processBookingDetails(String userMessage, HttpSession session) {
        String[] parts = userMessage.split(",");
        if (parts.length < 2) {
            return "Vui lòng cung cấp đầy đủ thông tin theo định dạng: tên phòng, ngày và giờ check-in (ví dụ: Deluxe, 2025-04-01 14:00).";
        }

        String roomName = parts[0].trim();
        String checkInDateTimeStr = parts[1].trim();

        UserDTO user = (UserDTO) session.getAttribute("user");
        if (user == null) {
            session.removeAttribute("chatState");
            return "Vui lòng đăng nhập để đặt phòng.";
        }

        try {
            RoomDAO roomDAO = new RoomDAO();
            RoomDTO room = roomDAO.getRoomByName(roomName);
            if (room == null) {
                session.removeAttribute("chatState");
                return "Phòng " + roomName + " không tồn tại trong hệ thống.";
            }

            LocalDateTime checkInDateTime;
            try {
                checkInDateTime = LocalDateTime.parse(checkInDateTimeStr, DATE_TIME_FORMATTER);
            } catch (Exception e) {
                return "Định dạng ngày giờ không hợp lệ. Vui lòng nhập theo định dạng: yyyy-MM-dd HH:mm";
            }

            if (checkInDateTime.isBefore(LocalDateTime.now())) {
                return "Thời gian check-in không thể trong quá khứ.";
            }

            LocalDateTime checkOutDateTime = checkInDateTime.plusDays(1);

            if (!roomDAO.isRoomAvailable(room.getId(), 
                    Timestamp.valueOf(checkInDateTime), 
                    Timestamp.valueOf(checkOutDateTime))) {
                session.removeAttribute("chatState");
                return "Phòng " + roomName + " không còn trống trong khoảng thời gian này. Vui lòng chọn thời gian khác.";
            }

            BookingDTO booking = new BookingDTO();
            booking.setUser(user);
            booking.setRoom(room);
            booking.setCheckInDate(Timestamp.valueOf(checkInDateTime));
            booking.setCheckOutDate(Timestamp.valueOf(checkOutDateTime));
            booking.setTotalPrice(room.getPrice() * ChronoUnit.DAYS.between(checkInDateTime, checkOutDateTime));
            booking.setStatus(BookingDAO.STATUS_PENDING_PAYMENT);
            booking.setCreatedAt(new Timestamp(System.currentTimeMillis()));

            session.setAttribute("pendingBooking", booking);
            session.setAttribute("pendingUserName", user.getFullName());

            return String.format("Bạn đang đặt phòng %s từ %s với tổng giá: %,.0f VND.\nVui lòng xác nhận đặt phòng bằng cách nhập: Xác nhận đặt phòng",
                    roomName, checkInDateTimeStr, booking.getTotalPrice());
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing booking details", e);
            session.removeAttribute("chatState");
            return "Lỗi khi xử lý thông tin đặt phòng: " + e.getMessage();
        }
    }

    private String processSuggestionAmenities(String userMessage, HttpSession session) {
        try {
            RoomDAO roomDAO = new RoomDAO();
            List<RoomDTO> rooms = roomDAO.getAllRooms();
            StringBuilder response = new StringBuilder("Dựa trên yêu cầu của bạn, tôi gợi ý các phòng sau:\n\n");

            String[] requestedAmenities = userMessage.toLowerCase().split(",");
            boolean found = false;

            for (RoomDTO room : rooms) {
                String amenities = room.getAmenities() != null ? room.getAmenities().toLowerCase() : "";
                boolean matchesAllAmenities = true;

                for (String amenity : requestedAmenities) {
                    amenity = amenity.trim();
                    if (!amenities.contains(amenity)) {
                        matchesAllAmenities = false;
                        break;
                    }
                }

                if (matchesAllAmenities) {
                    response.append(String.format("- %s\n  Mô tả: %s\n  Giá: %,.0f VND/đêm\n  Đánh giá: %.1f/5\n  Ảnh: %s\n\n",
                            room.getName(), room.getDescription(), room.getPrice(), room.getRatings(), room.getImageUrl()));
                    found = true;
                }
            }

            if (!found) {
                response.append("Không tìm thấy phòng phù hợp với các tiện ích bạn yêu cầu. Vui lòng thử với các tiện ích khác.");
            }

            session.removeAttribute("chatState");
            return response.toString();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing room suggestions", e);
            session.removeAttribute("chatState");
            return "Lỗi khi gợi ý phòng: " + e.getMessage();
        }
    }

    private String confirmAndSaveBooking(HttpSession session) {
        BookingDTO booking = (BookingDTO) session.getAttribute("pendingBooking");
        String userName = (String) session.getAttribute("pendingUserName");

        if (booking == null) {
            return "Không có đặt phòng nào để xác nhận. Vui lòng đặt phòng trước.";
        }

        try {
            BookingDAO bookingDAO = new BookingDAO();
            if (bookingDAO.addBooking(booking)) {
                NotificationDAO notificationDAO = new NotificationDAO();

                // Create user notification
                String userNotificationMessage = String.format("Bạn đã đặt phòng %s thành công từ %s đến %s.",
                        booking.getRoom().getName(),
                        booking.getCheckInDate().toLocalDateTime().format(DATE_TIME_FORMATTER),
                        booking.getCheckOutDate().toLocalDateTime().format(DATE_TIME_FORMATTER));
                
                NotificationDTO userNotification = new NotificationDTO(0, booking.getUser().getUserID(), 
                        userNotificationMessage, new Timestamp(System.currentTimeMillis()), false);
                notificationDAO.addNotification(userNotification);

                // Create admin notifications
                UserDAO userDAO = new UserDAO();
                List<UserDTO> admins = userDAO.getAllAdmins();
                String adminNotificationMessage = String.format("Người dùng %s vừa đặt phòng %s từ %s đến %s.",
                        booking.getUser().getFullName(),
                        booking.getRoom().getName(),
                        booking.getCheckInDate().toLocalDateTime().format(DATE_TIME_FORMATTER),
                        booking.getCheckOutDate().toLocalDateTime().format(DATE_TIME_FORMATTER));

                for (UserDTO admin : admins) {
                    NotificationDTO adminNotification = new NotificationDTO(0, admin.getUserID(), 
                            adminNotificationMessage, new Timestamp(System.currentTimeMillis()), false);
                    notificationDAO.addNotification(adminNotification);
                }

                session.removeAttribute("pendingBooking");
                session.removeAttribute("pendingUserName");

                return String.format("Đặt phòng %s thành công cho %s từ %s đến %s. Tổng giá: %,.0f VND",
                        booking.getRoom().getName(),
                        userName,
                        booking.getCheckInDate().toLocalDateTime().format(DATE_TIME_FORMATTER),
                        booking.getCheckOutDate().toLocalDateTime().format(DATE_TIME_FORMATTER),
                        booking.getTotalPrice());
            } else {
                return "Lỗi khi lưu đặt phòng. Vui lòng thử lại.";
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error confirming booking", e);
            return "Lỗi khi xác nhận đặt phòng: " + e.getMessage();
        }
    }

    private String processApiResponse(String apiResponse, String userMessage, HttpSession session) {
        try {
            JSONObject jsonResponse = new JSONObject(apiResponse);
            String content = jsonResponse.getJSONArray("choices")
                    .getJSONObject(0)
                    .getJSONObject("message")
                    .getString("content");

            // Check for booking-related keywords
            if (userMessage.contains("đặt phòng") || userMessage.contains("book room")) {
                session.setAttribute("chatState", "awaiting_booking_details");
                return "Vui lòng cung cấp thông tin đặt phòng theo định dạng: tên phòng, ngày và giờ check-in (ví dụ: Deluxe, 2025-04-01 14:00)";
            }

            // Check for room suggestion keywords
            if (userMessage.contains("gợi ý") || userMessage.contains("suggest")) {
                session.setAttribute("chatState", "awaiting_suggestion_amenities");
                return "Vui lòng cho biết các tiện ích bạn cần (ví dụ: WiFi, Bể bơi, Gym)";
            }

            return content;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing API response", e);
            return "Xin lỗi, tôi không thể xử lý yêu cầu của bạn lúc này. Vui lòng thử lại sau.";
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}