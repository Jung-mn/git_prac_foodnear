<%@ page import="java.sql.*" %>
<%
    request.setCharacterEncoding("UTF-8");

    String loggedInName = (String) session.getAttribute("loggedInName");
    int reviewId = Integer.parseInt(request.getParameter("review_id"));

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/foodnear_db", "root", "1234");

        // 중복 싫어요 체크
        String checkQuery = "SELECT COUNT(*) FROM review_dislikes WHERE review_id = ? AND user_name = ?";
        pstmt = conn.prepareStatement(checkQuery);
        pstmt.setInt(1, reviewId);
        pstmt.setString(2, loggedInName);
        rs = pstmt.executeQuery();

        if (rs.next() && rs.getInt(1) > 0) {
            // 이미 싫어요를 눌렀으면 싫어요 취소
                  
            // 싫어요 취소
        	String likeOutQuery = "UPDATE review SET dislikes = dislikes - 1 WHERE id = ?";
        	pstmt = conn.prepareStatement(likeOutQuery);
        	pstmt.setInt(1, reviewId);
        	pstmt.executeUpdate();
            
        	// 싫어요 취소 기록 저장
            String insertLikeOutQuery = "DELETE FROM review_dislikes WHERE review_id = ? and user_name = ?";
            pstmt = conn.prepareStatement(insertLikeOutQuery);
            pstmt.setInt(1, reviewId);
            pstmt.setString(2, loggedInName);
            pstmt.executeUpdate();
            
            response.sendRedirect("foodInfor.jsp?id=" + request.getParameter("food_id"));
            return;
        }

        // 싫어요 추가
        String dislikeQuery = "UPDATE review SET dislikes = dislikes + 1 WHERE id = ?";
        pstmt = conn.prepareStatement(dislikeQuery);
        pstmt.setInt(1, reviewId);
        pstmt.executeUpdate();

        // 싫어요 기록 저장
        String insertdisLikeQuery = "INSERT INTO review_dislikes (review_id, user_name) VALUES (?, ?)";
        pstmt = conn.prepareStatement(insertdisLikeQuery);
        pstmt.setInt(1, reviewId);
        pstmt.setString(2, loggedInName);
        pstmt.executeUpdate();
        
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }

    response.sendRedirect("foodInfor.jsp?id=" + request.getParameter("food_id"));
%>
