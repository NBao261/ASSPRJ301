package utils;

import java.util.Properties;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class EmailUtils {
    
    private static final String EMAIL_USERNAME = "ncb2601@gmail.com";
    private static final String EMAIL_PASSWORD = "mlwkvkcqirkiyzix";
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    
    // URL cơ sở dựa trên context path thực tế
    private static final String BASE_URL = "http://localhost:8080/clone_ASSPRJ301_testTT";
    
    public static boolean sendRegistrationEmail(String toEmail, String fullName, String userID) {
        try {
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", SMTP_HOST);
            props.put("mail.smtp.port", SMTP_PORT);
            
            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(EMAIL_USERNAME, EMAIL_PASSWORD);
                }
            });
            
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_USERNAME));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Welcome to Our Website - Registration Successful");
            
            String htmlContent = createRegistrationEmailContent(fullName, userID);
            message.setContent(htmlContent, "text/html; charset=utf-8");
            
            Transport.send(message);
            return true;
        } catch (MessagingException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    private static String createRegistrationEmailContent(String fullName, String userID) {
        return "<!DOCTYPE html>\n"
                + "<html>\n"
                + "<head>\n"
                + "    <meta charset=\"UTF-8\">\n"
                + "    <title>Registration Successful</title>\n"
                + "    <style>\n"
                + "        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; margin: 0; padding: 0; }\n"
                + "        .container { max-width: 600px; margin: 0 auto; padding: 20px; background-color: #f9f9f9; }\n"
                + "        .header { background-color: #4a90e2; color: white; padding: 20px; text-align: center; }\n"
                + "        .content { padding: 20px; background-color: white; border-radius: 5px; }\n"
                + "        .button { display: inline-block; padding: 10px 20px; background-color: #4a90e2; color: white; text-decoration: none; border-radius: 5px; margin: 20px 0; }\n"
                + "        .footer { text-align: center; margin-top: 20px; font-size: 12px; color: #666; }\n"
                + "    </style>\n"
                + "</head>\n"
                + "<body>\n"
                + "    <div class=\"container\">\n"
                + "        <div class=\"header\">\n"
                + "            <h1>Welcome to Our Website!</h1>\n"
                + "        </div>\n"
                + "        <div class=\"content\">\n"
                + "            <h2>Hello, " + fullName + "!</h2>\n"
                + "            <p>Thank you for registering with our website. Your account has been successfully created.</p>\n"
                + "            <p><strong>Your login information:</strong></p>\n"
                + "            <p>Username: <strong>" + userID + "</strong></p>\n"
                + "            <p>You can now login to your account and start exploring our services.</p>\n"
                + "            <a href=\"" + BASE_URL + "/login\" class=\"button\">Login to Your Account</a>\n"
                + "            <p>If you have any questions or need assistance, please don't hesitate to contact our support team.</p>\n"
                + "            <p>Best regards,<br>The Team</p>\n"
                + "        </div>\n"
                + "        <div class=\"footer\">\n"
                + "            <p>This is an automated message, please do not reply to this email.</p>\n"
                + "            <p>© 2025 Your Company. All rights reserved.</p>\n"
                + "        </div>\n"
                + "    </div>\n"
                + "</body>\n"
                + "</html>";
    }
    
    public static boolean sendVerificationEmail(String toEmail, String fullName, String token) {
        try {
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", SMTP_HOST);
            props.put("mail.smtp.port", SMTP_PORT);
            
            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(EMAIL_USERNAME, EMAIL_PASSWORD);
                }
            });
            
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_USERNAME));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Account Verification Required");
            
            // Sử dụng BASE_URL để tạo verificationLink
            String verificationLink = BASE_URL + "/verify?token=" + token;
            String htmlContent = createVerificationEmailContent(fullName, verificationLink);
            message.setContent(htmlContent, "text/html; charset=utf-8");
            
            Transport.send(message);
            return true;
        } catch (MessagingException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    private static String createVerificationEmailContent(String fullName, String verificationLink) {
        return "<!DOCTYPE html>\n"
                + "<html>\n"
                + "<head>\n"
                + "    <meta charset=\"UTF-8\">\n"
                + "    <title>Verify Your Account</title>\n"
                + "    <style>\n"
                + "        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; margin: 0; padding: 0; }\n"
                + "        .container { max-width: 600px; margin: 0 auto; padding: 20px; background-color: #f9f9f9; }\n"
                + "        .header { background-color: #4a90e2; color: white; padding: 20px; text-align: center; }\n"
                + "        .content { padding: 20px; background-color: white; border-radius: 5px; }\n"
                + "        .button { display: inline-block; padding: 10px 20px; background-color: #4a90e2; color: white; text-decoration: none; border-radius: 5px; margin: 20px 0; }\n"
                + "        .footer { text-align: center; margin-top: 20px; font-size: 12px; color: #666; }\n"
                + "    </style>\n"
                + "</head>\n"
                + "<body>\n"
                + "    <div class=\"container\">\n"
                + "        <div class=\"header\">\n"
                + "            <h1>Verify Your Account</h1>\n"
                + "        </div>\n"
                + "        <div class=\"content\">\n"
                + "            <h2>Hello, " + fullName + "!</h2>\n"
                + "            <p>Thank you for registering with our website. To complete your registration, please verify your email address by clicking the button below:</p>\n"
                + "            <a href=\"" + verificationLink + "\" class=\"button\">Verify Your Account</a>\n"
                + "            <p>If the button doesn't work, you can also copy and paste the following link into your browser:</p>\n"
                + "            <p><a href=\"" + verificationLink + "\">" + verificationLink + "</a></p>\n"
                + "            <p>This verification link will expire in 24 hours.</p>\n"
                + "            <p>If you did not sign up for an account, please ignore this email.</p>\n"
                + "            <p>Best regards,<br>The Team</p>\n"
                + "        </div>\n"
                + "        <div class=\"footer\">\n"
                + "            <p>This is an automated message, please do not reply to this email.</p>\n"
                + "            <p>© 2025 Your Company. All rights reserved.</p>\n"
                + "        </div>\n"
                + "    </div>\n"
                + "</body>\n"
                + "</html>";
    }
}