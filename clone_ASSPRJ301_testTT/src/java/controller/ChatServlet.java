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
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

@WebServlet(name = "ChatServlet", urlPatterns = {"/ChatServlet"})
public class ChatServlet extends HttpServlet {
    private static final Log log = LogFactory.getLog(ChatServlet.class);
    private static final String GROK_API_KEY = "xai-9R3arNcqSL0lwl3PQt6Uaxhtxwxfq3htCq7KTjDiswacLM9OyZa37LIdczc8kUcT4iNBAZXlyr5QfD6k"; // Thay bằng API Key của bạn
    private static final String GROK_API_URL = "https://api.x.ai/v1/chat/completions"; // URL API của Grok

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/plain;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        String grokResponse = "";

        try {
            // Kiểm tra yêu cầu xóa lịch sử chat
            if ("true".equals(request.getParameter("clearHistory"))) {
                session.removeAttribute("chatHistory");
                session.removeAttribute("chatState");
                grokResponse = "Lịch sử đã được xóa";
                response.getWriter().write(grokResponse);
                return;
            }

            // Kiểm tra yêu cầu xác nhận đặt phòng
            String confirmBooking = request.getParameter("confirmBooking");
            if (confirmBooking != null && confirmBooking.equals("true")) {
                grokResponse = confirmAndSaveBooking(session);
                session.removeAttribute("chatState");
                response.getWriter().write(grokResponse);

                // Lưu lịch sử chat
                List<String[]> chatHistory = (List<String[]>) session.getAttribute("chatHistory");
                if (chatHistory == null) {
                    chatHistory = new ArrayList<>();
                }
                String timestamp = new SimpleDateFormat("HH:mm:ss").format(new Date());
                chatHistory.add(new String[]{"You", "Xác nhận đặt phòng", timestamp});
                chatHistory.add(new String[]{"Grok", grokResponse, timestamp});
                session.setAttribute("chatHistory", chatHistory);

                return;
            }

            String userMessage = request.getParameter("message").toLowerCase();

            // Kiểm tra trạng thái hội thoại (chat state)
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
                        grokResponse = "Lỗi trạng thái hội thoại, vui lòng thử lại.";
                        session.removeAttribute("chatState");
                }
            } else {
                // Gửi tin nhắn đến API của Grok để phân tích ý định
                String apiResponse = callGrokAPI(userMessage);
                grokResponse = processApiResponse(apiResponse, userMessage, session);
            }

            // Lưu lịch sử chat
            List<String[]> chatHistory = (List<String[]>) session.getAttribute("chatHistory");
            if (chatHistory == null) {
                chatHistory = new ArrayList<>();
            }
            String timestamp = new SimpleDateFormat("HH:mm:ss").format(new Date());
            chatHistory.add(new String[]{"You", userMessage, timestamp});
            chatHistory.add(new String[]{"Grok", grokResponse, timestamp});
            session.setAttribute("chatHistory", chatHistory);

            // Gửi phản hồi về client
            response.getWriter().write(grokResponse);

        } catch (Exception e) {
            String errorMessage = e.getMessage() != null ? e.getMessage() : "Không xác định";
            grokResponse = "Lỗi hệ thống: " + errorMessage;
            response.getWriter().write(grokResponse);
        }
    }

    private String callGrokAPI(String userMessage) throws IOException {
        log.info("Gửi yêu cầu đến API Grok với tin nhắn: " + userMessage);
        CloseableHttpClient client = HttpClients.createDefault();
        HttpPost httpPost = new HttpPost(GROK_API_URL);

        // Thiết lập header
        httpPost.setHeader("Content-Type", "application/json");
        httpPost.setHeader("Accept", "application/json");
        httpPost.setHeader("Authorization", "Bearer " + GROK_API_KEY);

        // Tạo JSON request
        String jsonInputString = String.format(
                "{\"model\": \"grok-2-latest\", \"messages\": [{\"role\": \"system\", \"content\": \"Bạn là một trợ lý đặt phòng homestay, trả lời bằng tiếng Việt.\"}, {\"role\": \"user\", \"content\": \"%s\"}], \"temperature\": 0.7, \"max_tokens\": 1024}",
                userMessage.replace("\"", "\\\"")
        );
        httpPost.setEntity(new StringEntity(jsonInputString, "UTF-8"));

        // Gửi yêu cầu và nhận phản hồi
        CloseableHttpResponse response = client.execute(httpPost);
        try {
            // Kiểm tra mã trạng thái HTTP
            int statusCode = response.getStatusLine().getStatusCode();
            if (statusCode != 200) {
                BufferedReader reader = new BufferedReader(new InputStreamReader(response.getEntity().getContent(), "UTF-8"));
                StringBuilder errorResult = new StringBuilder();
                String line;
                while ((line = reader.readLine()) != null) {
                    errorResult.append(line);
                }
                throw new IOException("Lỗi từ API Grok (HTTP " + statusCode + "): " + errorResult.toString());
            }

            BufferedReader reader = new BufferedReader(new InputStreamReader(response.getEntity().getContent(), "UTF-8"));
            StringBuilder result = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                result.append(line);
            }
            log.info("Nhận phản hồi từ API Grok: " + result.toString());
            return result.toString();
        } finally {
            response.close();
            client.close();
        }
    }

    private String processApiResponse(String apiResponse, String userMessage, HttpSession session) {
        String intent = extractIntent(apiResponse);
        String response = extractResponse(apiResponse);

        switch (intent.toLowerCase()) {
            case "view_rooms":
                return "Bạn có thể xem danh sách phòng tại đây: \n" +
                       "- Xem tất cả phòng: http://localhost:8080/clone_ASSPRJ301_testTT/search.jsp\n" +
                       "- Xem phòng theo loại: http://localhost:8080/clone_ASSPRJ301_testTT/room-details?roomId=2";
            case "book_room":
                session.setAttribute("chatState", "awaiting_booking_details");
                return "Vui lòng cung cấp thông tin đặt phòng: tên phòng, ngày và giờ check-in (ví dụ: Deluxe, 2025-04-01 14:00).";
            case "suggest_room":
                session.setAttribute("chatState", "awaiting_suggestion_amenities");
                return "Bạn muốn phòng có các tiện ích nào? (Ví dụ: wifi, điều hòa, tivi)";
            default:
                return response != null ? response : "Tôi không hiểu, bạn có thể hỏi về phòng hoặc đặt phòng không?";
        }
    }

    private String extractIntent(String apiResponse) {
        try {
            JSONObject jsonResponse = new JSONObject(apiResponse);
            JSONObject choice = jsonResponse.getJSONArray("choices").getJSONObject(0);
            String content = choice.getJSONObject("message").getString("content").toLowerCase();

            // Phân tích nội dung để xác định intent
            if (content.contains("xem")) {
                return "view_rooms";
            } else if (content.contains("đặt")) {
                return "book_room";
            } else if (content.contains("gợi ý")) {
                return "suggest_room";
            } else {
                return "unknown";
            }
        } catch (Exception e) {
            return "unknown";
        }
    }

    private String extractResponse(String apiResponse) {
        try {
            JSONObject jsonResponse = new JSONObject(apiResponse);
            JSONObject choice = jsonResponse.getJSONArray("choices").getJSONObject(0);
            return choice.getJSONObject("message").getString("content");
        } catch (Exception e) {
            return null;
        }
    }

    private String processBookingDetails(String userMessage, HttpSession session) {
        // Giả sử người dùng nhập: "Deluxe, 2025-04-01 14:00"
        String[] parts = userMessage.split(",");
        if (parts.length < 2) {
            return "Vui lòng cung cấp đầy đủ: tên phòng, ngày và giờ check-in (ví dụ: Deluxe, 2025-04-01 14:00).";
        }

        String roomName = parts[0].trim();
        String checkInDateTimeStr = parts[1].trim();

        UserDTO user = (UserDTO) session.getAttribute("user");
        if (user == null) {
            session.removeAttribute("chatState");
            return "Vui lòng đăng nhập để đặt phòng";
        }

        try {
            RoomDAO roomDAO = new RoomDAO();
            RoomDTO room = roomDAO.getRoomByName(roomName);
            if (room == null) {
                session.removeAttribute("chatState");
                return "Phòng " + roomName + " không tồn tại";
            }

            // Phân tích ngày và giờ check-in
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
            LocalDateTime checkInDateTime = LocalDateTime.parse(checkInDateTimeStr, formatter);
            LocalDateTime checkOutDateTime = checkInDateTime.plusDays(1); // Giả sử mặc định 1 đêm

            // Kiểm tra phòng có trống không
            if (!roomDAO.isRoomAvailable(room.getId(), 
                    java.sql.Timestamp.valueOf(checkInDateTime), 
                    java.sql.Timestamp.valueOf(checkOutDateTime))) {
                session.removeAttribute("chatState");
                return "Phòng " + roomName + " không còn trống trong khoảng thời gian này";
            }

            // Tạo booking tạm thời và lưu vào session để xác nhận
            BookingDTO booking = new BookingDTO();
            booking.setUser(user);
            booking.setRoom(room);
            booking.setCheckInDate(java.sql.Timestamp.valueOf(checkInDateTime));
            booking.setCheckOutDate(java.sql.Timestamp.valueOf(checkOutDateTime));
            booking.setTotalPrice(room.getPrice() * ChronoUnit.DAYS.between(checkInDateTime, checkOutDateTime));
            booking.setStatus(BookingDAO.STATUS_PENDING_PAYMENT);
            booking.setCreatedAt(new Timestamp(System.currentTimeMillis()));

            session.setAttribute("pendingBooking", booking);
            session.setAttribute("pendingUserName", user.getFullName());

            return "Bạn đang đặt phòng " + roomName + " từ " + checkInDateTimeStr + " với tổng giá: " + 
                   String.format("%,.0f", booking.getTotalPrice()) + " VND.\n" +
                   "Vui lòng xác nhận đặt phòng bằng cách nhập: Xác nhận đặt phòng";
        } catch (Exception e) {
            session.removeAttribute("chatState");
            return "Lỗi khi đặt phòng: " + e.getMessage();
        }
    }

    private String processSuggestionAmenities(String userMessage, HttpSession session) {
        try {
            RoomDAO roomDAO = new RoomDAO();
            List<RoomDTO> rooms = roomDAO.getAllRooms();
            StringBuilder response = new StringBuilder("Gợi ý phòng:\n");

            // Tách các tiện ích người dùng nhập (ví dụ: "wifi, điều hòa")
            String[] requestedAmenities = userMessage.toLowerCase().split(",");
            boolean found = false;

            for (RoomDTO room : rooms) {
                String amenities = room.getAmenities() != null ? room.getAmenities().toLowerCase() : "";
                boolean matchesAllAmenities = true;

                // Kiểm tra xem phòng có chứa tất cả tiện ích người dùng yêu cầu không
                for (String amenity : requestedAmenities) {
                    amenity = amenity.trim();
                    if (!amenities.contains(amenity)) {
                        matchesAllAmenities = false;
                        break;
                    }
                }

                if (matchesAllAmenities) {
                    response.append(String.format("%s: %s - Giá: %,.0f VND - Đánh giá: %.1f - Ảnh: %s\n",
                            room.getName(), room.getDescription(), room.getPrice(), room.getRatings(), room.getImageUrl()));
                    found = true;
                }
            }

            if (!found) {
                response.append("Không tìm thấy phòng phù hợp với các tiện ích bạn yêu cầu.");
            }

            session.removeAttribute("chatState");
            return response.toString();
        } catch (Exception e) {
            session.removeAttribute("chatState");
            return "Lỗi khi gợi ý phòng: " + e.getMessage();
        }
    }

    private String listRooms() {
        try {
            RoomDAO roomDAO = new RoomDAO();
            List<RoomDTO> rooms = roomDAO.getAllRooms();
            StringBuilder response = new StringBuilder("Danh sách phòng:\n");
            for (RoomDTO room : rooms) {
                response.append(String.format("%s: %s - Giá: %,.0f VND - Đánh giá: %.1f - Ảnh: %s\n",
                        room.getName(), room.getDescription(), room.getPrice(), room.getRatings(), room.getImageUrl()));
            }
            return response.toString();
        } catch (Exception e) {
            return "Lỗi khi lấy danh sách phòng: " + e.getMessage();
        }
    }

    private String bookRoom(String message, HttpSession session) {
        // Không cần phương thức này nữa vì đã xử lý trong processBookingDetails
        return "Vui lòng cung cấp thông tin đặt phòng: tên phòng, ngày và giờ check-in (ví dụ: Deluxe, 2025-04-01 14:00).";
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

                String userNotificationMessage = "Bạn vừa đặt phòng " + booking.getRoom().getName() + " thành công.";
                NotificationDTO userNotification = new NotificationDTO(0, booking.getUser().getUserID(), userNotificationMessage, new Timestamp(System.currentTimeMillis()), false);
                notificationDAO.addNotification(userNotification);

                UserDAO userDAO = new UserDAO();
                List<UserDTO> admins = userDAO.getAllAdmins();
                String adminNotificationMessage = "Người dùng " + booking.getUser().getFullName() + " vừa đặt phòng " + booking.getRoom().getName() + ".";
                for (UserDTO admin : admins) {
                    NotificationDTO adminNotification = new NotificationDTO(0, admin.getUserID(), adminNotificationMessage, new Timestamp(System.currentTimeMillis()), false);
                    notificationDAO.addNotification(adminNotification);
                }

                session.removeAttribute("pendingBooking");
                session.removeAttribute("pendingUserName");

                return "Đặt phòng " + booking.getRoom().getName() + " thành công cho " + userName;
            } else {
                return "Lỗi khi lưu đặt phòng";
            }
        } catch (Exception e) {
            return "Lỗi khi lưu đặt phòng: " + e.getMessage();
        }
    }

    private String suggestRoom(String message, HttpSession session) {
        // Không cần phương thức này nữa vì đã xử lý trong processSuggestionAmenities
        return "Bạn muốn phòng có các tiện ích nào? (Ví dụ: wifi, điều hòa, tivi)";
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}