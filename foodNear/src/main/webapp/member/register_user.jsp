<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.net.URLEncoder" %>
<%
    // 요청에서 데이터 가져오기
    String university = request.getParameter("university");
    String status = request.getParameter("status");
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    String name = request.getParameter("name");
    String studentId = request.getParameter("student_id");
    String email = request.getParameter("email");
    String phone = request.getParameter("phone");

    // 데이터베이스 연결
    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/foodnear_db", "root", "1234"); // 비밀번호는 환경에 맞게 변경
        String sql = "INSERT INTO member (university, status, username, password, name, student_id, email, phone) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, university);
        pstmt.setString(2, status);
        pstmt.setString(3, username);
        pstmt.setString(4, password);
        pstmt.setString(5, name);
        pstmt.setString(6, studentId);
        pstmt.setString(7, email);
        pstmt.setString(8, phone);
        pstmt.executeUpdate();

        // 성공적으로 삽입되면 join_Ok.jsp로 이동
        String encodedName = URLEncoder.encode(name, "UTF-8");
        out.println("회원가입 성공: " + name);
        response.sendRedirect("join_Ok.jsp?name=" + name);
    } catch (Exception e) {
        out.println("회원가입 중 오류가 발생했습니다: " + e.getMessage());
        e.printStackTrace();
    } finally {
        try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>
