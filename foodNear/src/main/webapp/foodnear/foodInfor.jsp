<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<% 
	String loggedInName = (String) session.getAttribute("loggedInName");
    Integer userId = (Integer) session.getAttribute("user_id");
%>
<%
    session.setAttribute("loggedInName", loggedInName);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>식당 정보</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #FFF9E5; /* 노란 파스텔 톤 */
            margin: 0;
            padding: 20px;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }
        .restaurant-photo {
            width: 100%;
            height: auto;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        .details {
            font-size: 16px;
            line-height: 1.6;
        }
        .details h2 {
            margin-bottom: 10px;
        }
        .details div {
            margin-bottom: 10px;
        }
        header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 20px;
            background-color: #FFEBB3; /* 더 진한 노란색 */
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        .logo {
            font-size: 24px;
            font-weight: bold;
            color: #333;
        }
        .auth-buttons {
            display: flex;
            gap: 10px;
        }
        .auth-buttons a {
            text-decoration: none;
            padding: 8px 15px;
            border: 1px solid #333;
            border-radius: 5px;
            color: #333;
            background-color: #FFF9E5;
            transition: all 0.3s ease;
        }
        .auth-buttons a:hover {
            background-color: #FFE680; /* 버튼 hover 색상 */
        }
    </style>
</head>
<body>
	<header>
        <div class="logo">Foodnear</div>
        <div style="text-align: right; padding: 10px;">
    	<%
        	if (loggedInName == null) {
    	%>
        	<a href="/foodNear/member/login.jsp">로그인</a>
        	<a href="/foodNear/member/join.jsp">회원가입</a>
   		<%
        	} else {
    	%>
        	<span><%= loggedInName %>님</span>
        	<a href="/foodNear/member/logout.jsp">로그아웃</a>
    	<%
        	}
    	%>
		</div>
    </header>
    <div class="container">
        <%
            String id = request.getParameter("id");
            if (id == null || id.isEmpty()) {
                out.println("<h2>잘못된 요청입니다.</h2>");
            } else {
                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/foodnear_db", "root", "1234");
                    String sql = "SELECT * FROM foodnear WHERE id = ?";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setInt(1, Integer.parseInt(id));
                    rs = pstmt.executeQuery();

                    if (rs.next()) {
        %>
        <h2><%= rs.getString("name") %></h2>
        <img src="<%= rs.getString("photo") %>" alt="식당 사진" class="restaurant-photo">
        <div class="details">
            <div>카테고리: <%= rs.getString("category") %></div>
            <div>지역: <%= rs.getString("position") %></div>
            <div>대표 메뉴: <%= rs.getString("bestmenu") %></div>
            <div>가격: <%= rs.getInt("price") %></div>
            <div>영업시간: <%= rs.getFloat("opentime") %> ~ <%= rs.getFloat("closetime") %></div>
            <div>브레이크 타임: <%= rs.getString("breaktime") %></div>
            <div>위치: <%= rs.getString("location") %></div>
            <div>네이버평점: <%= rs.getString("navergrade") %></div>
        </div>
        <%
                    } else {
                        out.println("<h2>존재하지 않는 식당입니다.</h2>");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    if (rs != null) rs.close();
                    if (pstmt != null) pstmt.close();
                    if (conn != null) conn.close();
                }
            }
        %>

        <!-- 리뷰 작성 -->
        <div>
            <h2>리뷰</h2>
            <% if (loggedInName != null) { %>
            <form action="submitReview.jsp" method="POST">
                <input type="hidden" name="food_id" value="<%= id %>">
                <label for="rating">별점:</label>
                <select name="rating" required>
                    <option value="1">1</option>
                    <option value="2">2</option>
                    <option value="3">3</option>
                    <option value="4">4</option>
                    <option value="5">5</option>
                </select>
                <label for="comment">댓글:</label>
                <textarea name="comment" rows="3" required></textarea>
                <button type="submit">리뷰 남기기</button>
            </form>
            <% } else { %>
            <p>로그인 후 리뷰를 남길 수 있습니다.</p>
            <% } %>
        </div>

		<!-- 리뷰 리스트 -->
		<div>
    		<h3>리뷰 목록</h3>
    		<%
        		Connection conn = null;  // Connection 객체 선언
        		PreparedStatement pstmt = null;  // PreparedStatement 객체 선언
        		ResultSet rs = null;  // ResultSet 객체 선언

        		try {
            		// 데이터베이스 연결
            		conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/foodnear_db", "root", "1234");
            
            		// 리뷰 데이터를 가져오는 SQL
            		String query = "SELECT r.rating, r.comment, m.name, r.created_at FROM review r JOIN member m ON r.user_id = m.id WHERE r.food_id = ?";
            		pstmt = conn.prepareStatement(query);
            		pstmt.setInt(1, Integer.parseInt(id));  // 현재 식당 ID를 조건으로 설정
            		rs = pstmt.executeQuery();

            		// 리뷰 목록 출력
            		while (rs.next()) {
    		%>
    		<div>
        		<strong><%= rs.getString("name") %></strong> 
        		(<%= rs.getTimestamp("created_at") %>)
        		<p>별점: <%= rs.getFloat("rating") %></p>
        		<p><%= rs.getString("comment") %></p>
    		</div>
    		<hr>
    		<%
            		}
        		} catch (Exception e) {
            		e.printStackTrace();  // 오류 출력
        		} finally {
            		// 리소스 닫기
           	 		if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            		if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            		if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        		}
    		%>
</div>
</body>
</html>

