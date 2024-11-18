<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
    <title>Database Connection Test</title>
</head>
<body>
<%
    String url = "jdbc:mysql://localhost:3306/foodnear_db";
    String username = "root";  // MySQL 사용자 이름
    String password = "q1w0e4r2!@#"; // MySQL 비밀번호

    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;

    try {
        // MySQL 드라이버 로드
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, username, password);
        out.println("<h3>Database connected successfully!</h3>");

        // 테스트 쿼리 실행
        stmt = conn.createStatement();
        rs = stmt.executeQuery("SELECT * FROM foodnear");

        out.println("<h4>Foodnear Table Data:</h4>");
        while (rs.next()) {
            out.println("ID: " + rs.getInt("id") + ", ");
            out.println("Name: " + rs.getString("name") + "<br>");
        }
    } catch (Exception e) {
        out.println("<h3>Connection failed: " + e.getMessage() + "</h3>");
    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>
</body>
</html>