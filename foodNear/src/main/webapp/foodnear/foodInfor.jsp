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
    		width: 450px; /* 고정 가로 크기 */
    		height: 300px; /* 고정 세로 크기 */
    		object-fit: cover; /* 비율을 유지하며 잘라냄 */
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
                out.println("<h2>잘못된 요청입니다. 식당 ID가 제공되지 않았습니다.</h2>");
                return; // 이후 코드 실행 방지
            }

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
        <h1><%= rs.getString("name") %></h1>
        <img src="<%= rs.getString("photo") %>" alt="식당 사진" class="restaurant-photo">
        <div class="details">
            <div>대표 메뉴: <%= rs.getString("bestmenu") %></div>
            <div>가격: <%= rs.getInt("price") %>원</div><br>
            <div>영업시간: <%= rs.getFloat("opentime") %> ~ <%= rs.getFloat("closetime") %></div>
            <div>브레이크 타임: <%= rs.getString("breaktime") %></div><br>
            <div>위치: 인천광역시 <%= rs.getString("location") %></div>
            <div>네이버평점: <%= rs.getString("navergrade") %></div>
        </div>
        <%
                } else {
                    out.println("<h2>존재하지 않는 식당입니다.</h2>");
                }
            } catch (Exception e) {
                out.println("<h2>오류가 발생했습니다: " + e.getMessage() + "</h2>");
                e.printStackTrace();
            } finally {
                if (rs != null) try { rs.close(); } catch (Exception e) {}
                if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
                if (conn != null) try { conn.close(); } catch (Exception e) {}
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

        <!-- 리뷰 목록 -->
        <div>
            <h3>리뷰 목록</h3>
            <%
            	System.out.println("id 파라미터 값: " + id);
                try {
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/foodnear_db", "root", "1234");
                    String query = "SELECT r.id AS review_id, r.rating, r.comment, r.likes, r.dislikes, m.name, m.level, r.created_at " +
                                   "FROM review r JOIN member m ON r.user_id = m.id WHERE r.food_id = ?";
                    pstmt = conn.prepareStatement(query);
                    pstmt.setInt(1, Integer.parseInt(id));
                    rs = pstmt.executeQuery();

                    while (rs.next()) {
            %>
            <div>
                <strong><%= rs.getString("name") %> (Level <%= rs.getInt("level") %>)</strong>
                (<%= rs.getTimestamp("created_at") %>)
                <p>별점: <%= rs.getFloat("rating") %></p>
                <p><%= rs.getString("comment") %></p>

                <!-- 좋아요/싫어요 버튼 -->
                <p>
                    좋아요: <%= rs.getInt("likes") %> 
                    <form action="likeReview.jsp" method="POST" style="display:inline;">
                        <input type="hidden" name="review_id" value="<%= rs.getInt("review_id") %>">
                        <input type="hidden" name="food_id" value="<%= id %>">
                        <button type="submit">좋아요</button>
                    </form>

                    싫어요: <%= rs.getInt("dislikes") %> 
                    <form action="dislikeReview.jsp" method="POST" style="display:inline;">
                        <input type="hidden" name="review_id" value="<%= rs.getInt("review_id") %>">
                        <input type="hidden" name="food_id" value="<%= id %>">
                        <button type="submit">싫어요</button>
                    </form>
                </p>
            </div>
            <% 
                    }
                } catch (Exception e) {
                    out.println("<h2>리뷰를 가져오는 중 오류가 발생했습니다: " + e.getMessage() + "</h2>");
                    e.printStackTrace();
                } finally {
                    if (rs != null) try { rs.close(); } catch (Exception e) {}
                    if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
                    if (conn != null) try { conn.close(); } catch (Exception e) {}
                }
            %>
        </div>
    </div>
</body>
</html>

