<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    String dbUrl = "jdbc:mysql://localhost:3306/foodnear_db";
    String dbUser = "root";
    String dbPassword = "1234"; // MySQL 비밀번호

    boolean isValidUser = false;
    String name = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

        String sql = "SELECT name FROM member WHERE username = ? AND password = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, username);
        pstmt.setString(2, password);

        rs = pstmt.executeQuery();
        if (rs.next()) {
            isValidUser = true;
            name = rs.getString("name");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }

    if (isValidUser) {
        session.setAttribute("username", username);
        session.setAttribute("name", name);
        out.println("<script>alert('로그인되었습니다.'); location.href='../foodnear/home.jsp';</script>");
    } else {
        out.println("<script>alert('아이디, 혹은 비밀번호가 일치하지 않습니다.'); history.back();</script>");
    }
%>
