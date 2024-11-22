<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    String reviewId = request.getParameter("review_id");
    String foodId = request.getParameter("food_id");
    Integer userId = (Integer) session.getAttribute("userId");

    if (reviewId == null || userId == null) {
        response.sendRedirect("foodInfor.jsp?id=" + foodId + "&error=unauthorized");
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/foodnear_db", "root", "1234");

        // 본인 리뷰인지 확인
        String checkQuery = "SELECT user_id FROM review WHERE id = ?";
        pstmt = conn.prepareStatement(checkQuery);
        pstmt.setInt(1, Integer.parseInt(reviewId));
        rs = pstmt.executeQuery();

        if (rs.next()) {
            int reviewUserId = rs.getInt("user_id");
            if (reviewUserId != userId) {
                response.sendRedirect("foodInfor.jsp?id=" + foodId + "&error=unauthorized");
                return;
            }
        }

        // 본인 리뷰일 경우 삭제
        String deleteQuery = "DELETE FROM review WHERE id = ?";
        pstmt = conn.prepareStatement(deleteQuery);
        pstmt.setInt(1, Integer.parseInt(reviewId));
        int rowsAffected = pstmt.executeUpdate();

        if (rowsAffected > 0) {
            response.sendRedirect("foodInfor.jsp?id=" + foodId + "&success=deleted");
        } else {
            response.sendRedirect("foodInfor.jsp?id=" + foodId + "&error=delete_failed");
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("foodInfor.jsp?id=" + foodId + "&error=exception");
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>