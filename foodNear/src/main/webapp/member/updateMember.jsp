<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String loggedInName = (String) session.getAttribute("loggedInName");
	Integer userId = (Integer) session.getAttribute("userId");

    String password = request.getParameter("password");
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String phone = request.getParameter("phone");

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/foodnear_db", "root", "1234");
        String sql = "UPDATE member SET password = ?, name = ?, email = ?, phone = ? WHERE id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, password);
        pstmt.setString(2, name);
        pstmt.setString(3, email);
        pstmt.setString(4, phone);
        pstmt.setInt(5, userId);
        pstmt.executeUpdate();

        response.sendRedirect("mypage.jsp");
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<h2>오류가 발생했습니다: " + e.getMessage() + "</h2>");
    } finally {
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>
