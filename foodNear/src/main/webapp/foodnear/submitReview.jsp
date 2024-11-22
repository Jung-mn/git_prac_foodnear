<%@ page import="java.sql.*" %>
<%
    request.setCharacterEncoding("UTF-8");

    // 로그인된 사용자의 이름을 session에서 가져옴
    String loggedInName = (String) session.getAttribute("loggedInName");

    // food_id, rating, comment는 request 파라미터에서 가져옴
    int foodId = Integer.parseInt(request.getParameter("food_id"));
    int rating = Integer.parseInt(request.getParameter("rating"));
    String comment = request.getParameter("comment");

    // MySQL 연결 설정
    Connection connection = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        // DB 연결
        connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/foodnear_db", "root", "1234");

        // loggedInName을 이용하여 user_id 조회
        String userQuery = "SELECT id FROM member WHERE name = ?";
        pstmt = connection.prepareStatement(userQuery);
        pstmt.setString(1, loggedInName);
        rs = pstmt.executeQuery();

        int userId = 0;

        if (rs.next()) {
            userId = rs.getInt("id");
        }

        // 리뷰를 review 테이블에 삽입
        String reviewQuery = "INSERT INTO review (food_id, user_id, rating, comment) VALUES (?, ?, ?, ?)";
        pstmt = connection.prepareStatement(reviewQuery);
        pstmt.setInt(1, foodId);
        pstmt.setInt(2, userId);
        pstmt.setInt(3, rating);
        pstmt.setString(4, comment);

        pstmt.executeUpdate();
        
     // 리뷰 추가 후 해당 food_id에 대한 별점 평균값을 계산
        String updateRatingQuery = "UPDATE foodnear f " +
                                   "SET f.f_rating = (SELECT AVG(r.rating) FROM review r WHERE r.food_id = f.id) " +
                                   "WHERE f.id = ?";
        pstmt = connection.prepareStatement(updateRatingQuery);
        pstmt.setInt(1, foodId);
        pstmt.executeUpdate();
        
        
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (connection != null) connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 리뷰 작성 후 원래 페이지로 리다이렉트
    response.sendRedirect("foodInfor.jsp?id=" + foodId);
%>
