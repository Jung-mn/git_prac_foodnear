<%@ page import="java.sql.*" %>
<%
    

    String loggedInName = (String) session.getAttribute("loggedInName");
    int reviewId = Integer.parseInt(request.getParameter("review_id"));
    
    System.out.println("reviewId 파라미터 값: " + reviewId);

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/foodnear_db", "root", "1234");

        // 중복 좋아요 체크
        String checkQuery = "SELECT COUNT(*) FROM review_likes WHERE review_id = ? AND user_name = ?";
        pstmt = conn.prepareStatement(checkQuery);
        pstmt.setInt(1, reviewId);
        pstmt.setString(2, loggedInName);
        rs = pstmt.executeQuery();

        if (rs.next() && rs.getInt(1) > 0) {
            // 이미 좋아요를 눌렀으면 좋아요 취소
            
            // 좋아요 취소
        	String likeOutQuery = "UPDATE review SET likes = likes - 1 WHERE id = ?";
        	pstmt = conn.prepareStatement(likeOutQuery);
        	pstmt.setInt(1, reviewId);
        	pstmt.executeUpdate();
            
        	// 좋아요 취소 기록 저장
            String insertLikeOutQuery = "DELETE FROM review_likes WHERE review_id = ? and user_name = ?";
            pstmt = conn.prepareStatement(insertLikeOutQuery);
            pstmt.setInt(1, reviewId);
            pstmt.setString(2, loggedInName);
            pstmt.executeUpdate();
            
         	// 작성자 좋아요 수 감소 및 레벨 업데이트
            String updateMemberQuery = "UPDATE member SET likes_received = likes_received - 1, level = LEAST(10, (likes_received + 1) DIV 10 + 1) WHERE id = (SELECT user_id FROM review WHERE id = ?)";
            pstmt = conn.prepareStatement(updateMemberQuery);
            pstmt.setInt(1, reviewId);
            pstmt.executeUpdate();
            
            response.sendRedirect("foodInfor.jsp?id=" + request.getParameter("food_id"));
            return;
        }

        // 좋아요 추가
        String likeQuery = "UPDATE review SET likes = likes + 1 WHERE id = ?";
        pstmt = conn.prepareStatement(likeQuery);
        pstmt.setInt(1, reviewId);
        pstmt.executeUpdate();

        // 좋아요 기록 저장
        String insertLikeQuery = "INSERT INTO review_likes (review_id, user_name) VALUES (?, ?)";
        pstmt = conn.prepareStatement(insertLikeQuery);
        pstmt.setInt(1, reviewId);
        pstmt.setString(2, loggedInName);
        pstmt.executeUpdate();

        // 작성자 좋아요 수 증가 및 레벨 업데이트
        String updateMemberQuery = "UPDATE member SET likes_received = likes_received + 1, level = LEAST(10, (likes_received + 1) DIV 10 + 1) WHERE id = (SELECT user_id FROM review WHERE id = ?)";
        pstmt = conn.prepareStatement(updateMemberQuery);
        pstmt.setInt(1, reviewId);
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
