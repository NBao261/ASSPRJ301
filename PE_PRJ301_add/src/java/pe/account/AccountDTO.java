package pe.account;

import java.util.Date;

public class AccountDTO {

    //your code here
    private String account;
    private String pass;
    private String roleDB;
    private String fullName;
    private String gender;
    private Date date;
    private String phone;
    private String addr;

    public AccountDTO() {
    }

    public AccountDTO(String account, String pass, String roleDB, String fullName, String gender, Date date, String phone, String addr) {
        this.account = account;
        this.pass = pass;
        this.roleDB = roleDB;
        this.fullName = fullName;
        this.gender = gender;
        this.date = date;
        this.phone = phone;
        this.addr = addr;
    }

    public String getAccount() {
        return account;
    }

    public void setAccount(String account) {
        this.account = account;
    }

    public String getPass() {
        return pass;
    }

    public void setPass(String pass) {
        this.pass = pass;
    }

    public String getRoleDB() {
        return roleDB;
    }

    public void setRoleDB(String roleDB) {
        this.roleDB = roleDB;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAddr() {
        return addr;
    }

    public void setAddr(String addr) {
        this.addr = addr;
    }

}
