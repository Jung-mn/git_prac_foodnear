<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<% 
	String loggedInName = (String) session.getAttribute("loggedInName");
	Integer userId = (Integer) session.getAttribute("userId");
%>
<%
    session.setAttribute("loggedInName", loggedInName);
	session.setAttribute("userId", userId);
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
            padding: 0;
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
            cursor: pointer; /* 클릭할 수 있는 모양으로 변경 */
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
        .strong {
        	font-weight: bold;
        	font-size: 20px;
        	margin-top: 6px;
        }
        .review-section {
        display: flex; /* 또는 grid */
  		flex-direction: column; /* 세로로 정렬 */
  		gap: 10px; /* 리뷰 사이의 간격 */
	  	max-height: 400px; /* 필요에 따라 고정 높이 설정 */
	  	overflow-y: auto; /* 내용이 넘칠 경우 스크롤 활성화 */
		    }
	
	    .review-section h2 {
	        border-bottom: 2px solid #FFB347; /* 밝은 오렌지 톤 */
	        padding-bottom: 5px;
	        margin-bottom: 20px;
	        color: #333;
	    }
	
	    .review-form {
	        margin-bottom: 20px;
	        background-color: #FFF9E5; /* 노란 파스텔 배경 */
	        padding: 15px;
	        border: 1px solid #FFEBB3;
	        border-radius: 10px;
	    }
	
	    .review-form label {
	        display: block;
	        font-weight: bold;
	        margin-bottom: 5px;
	        color: #333;
	    }
	
	    .review-form textarea {
	        width: 100%;
	        padding: 10px;
	        border: 1px solid #CCC;
	        border-radius: 5px;
	        resize: none;
	        margin-bottom: 15px;
	    }
	
	    .review-form select,
	    .review-form button {
	        display: inline-block;
	        padding: 10px;
	        font-size: 14px;
	        margin-bottom: 10px;
	        border: 1px solid #CCC;
	        border-radius: 5px;
	        cursor: pointer;
	    }
	
	    .review-form button {
	        background-color: #FFB347; /* 밝은 오렌지 톤 */
	        color: white;
	        border: none;
	        transition: background-color 0.3s ease;
	    }
	
	    .review-form button:hover {
	        background-color: #FF9A33; /* 더 짙은 오렌지 톤 */
	    }
	
	    .review-list {
	        margin-top: 20px;
	    }
	
	    .review-item {
	        padding: 15px;
	        border: 1px solid #DDD;
	        border-radius: 10px;
	        margin-bottom: 15px;
	        background-color: #FAFAFA; /* 연한 배경색 */
	        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
	    }
	
	    .review-item strong {
	        color: #FF9A33; /* 강조된 오렌지 톤 */
	        font-size: 16px;
	    }
	
	    .review-item p {
	        margin: 5px 0;
	    }
	
	    .review-item .review-meta {
	        font-size: 12px;
	        color: #777;
	        margin-bottom: 10px;
	    }
	
	    .like-dislike {
	        display: flex;
	        gap: 10px;
	    }
	
	    .like-dislike form {
	        display: inline;
	    }
	
	    .like-dislike button {
	        background-color: #FFB347;
	        color: white;
	        padding: 5px 10px;
	        border: none;
	        border-radius: 5px;
	        cursor: pointer;
	        font-size: 12px;
	    }
	
	    .like-dislike button:hover {
	        background-color: #FF9A33;
	    }
	    /* 새 스타일 추가 */
		.restaurant-info {
		    text-align: center;
		    margin-top: 20px;
		}
		
		.restaurant-name {
		    font-size: 32px;
		    color: #FF9A33; /* 강조된 주황색 */
		    margin-bottom: 20px;
		    font-weight: bold;
		}
		
		.photo-container {
		    display: flex;
		    justify-content: center;
		    margin-bottom: 20px;
		}
		
		.restaurant-photo {
		    width: 100%;
		    max-width: 500px;
		    height: auto;
		    border-radius: 10px;
		    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
		}
		
		.details {
		    background-color: #FFFBF0; /* 부드러운 크림색 배경 */
		    padding: 20px;
		    border-radius: 10px;
		    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
		    font-size: 16px;
		    line-height: 1.8;
		}
		
		.detail-item {
		    display: flex;
		    justify-content: space-between;
		    margin-bottom: 15px;
		    border-bottom: 1px dashed #FFEBB3; /* 구분선 */
		    padding-bottom: 5px;
		}
		
		.detail-label {
		    font-weight: bold;
		    color: #333;
		}
		
		.detail-value {
		    color: #555;
		    text-align: right;
		    font-weight: 500;
		}
	    
    </style>
</head>
<body>

	<header>
        <div class="logo" onclick="location.href='home.jsp'">Foodnear</div>
        <div class="auth-buttons">
    	<%
        	if (loggedInName == null) {
    	%>
        	<a href="/foodNear/member/login.jsp">로그인</a>
        	<a href="/foodNear/member/join.jsp">회원가입</a>
   		<%
        	} else {
    	%>
        	<span class="strong"><%= loggedInName %>님</span>
        	<a href="/foodNear/member/mypage.jsp">마이페이지</a>
        	<a href="/foodNear/member/logout.jsp">로그아웃</a>
    	<%
        	}
    	%>
		</div>
    </header>
    
    <div class="container">
        <%  
        	/* foodnear테이블의 id를 이용해 1차 확인 */
            String id = request.getParameter("id");
            if (id == null || id.isEmpty()) {
                out.println("<h2>잘못된 요청입니다. 식당 ID가 제공되지 않았습니다.</h2>");
                return; // 이후 코드 실행 방지
            }
		
            /* foodnear테이블의 id를 이용해 sql연결 */
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
        
        <!-- 식당 세부정보 가져오기 -->
		<div class="restaurant-info">
		    <h1 class="restaurant-name"><%= rs.getString("name") %></h1>
		    <div class="photo-container">
		        <img src="<%= rs.getString("photo") %>" alt="식당 사진" class="restaurant-photo">
		    </div>
		    <div class="details">
		        <div class="detail-item">
		            <span class="detail-label">대표 메뉴:</span>
		            <span class="detail-value"><%= rs.getString("bestmenu") %></span>
		        </div>
		        <div class="detail-item">
		            <span class="detail-label">가격:</span>
		            <span class="detail-value"><%= rs.getInt("price") %>원</span>
		        </div>
		        <div class="detail-item">
		            <span class="detail-label">영업시간:</span>
		            <span class="detail-value"><%= rs.getFloat("opentime") %> ~ <%= rs.getFloat("closetime") %></span>
		        </div>
		        <div class="detail-item">
				    <span class="detail-label">브레이크 타임:</span>
				    <span class="detail-value"><%= rs.getString("breaktime") %></span>
				</div>

		        <div class="detail-item">
		            <span class="detail-label">위치:</span>
		            <span class="detail-value">인천광역시 <%= rs.getString("location") %></span>
		        </div>
		        <div class="detail-item">
		            <span class="detail-label">네이버 평점:</span>
		            <span class="detail-value"><%= rs.getString("navergrade") %></span>
		        </div>
		    </div>
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
        <div class="review-section">
		    <h2>리뷰</h2>
		
		    <% if (loggedInName != null) { %>
		    <div class="review-form">
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
		    </div>
		    <% } else { %>
		    <p>로그인 후 리뷰를 남길 수 있습니다.</p>
		    <% } %>

                
	        <!-- 리뷰 목록 정렬 옵션 -->
			<div>
	    		<h3>리뷰 목록</h3>
	    		<form action="foodInfor.jsp" method="GET">
	        		<input type="hidden" name="id" value="<%= id %>">
	        		<label for="sort">정렬:</label>
	        		<select name="sort" id="sort" onchange="this.form.submit()">
	            		<option value="latest" <%= "latest".equals(request.getParameter("sort")) || request.getParameter("sort") == null ? "selected" : "" %>>최신순</option>
	            		<option value="most_likes" <%= "most_likes".equals(request.getParameter("sort")) ? "selected" : "" %>>좋아요 많은순</option>
	            		<option value="highest_rating" <%= "highest_rating".equals(request.getParameter("sort")) ? "selected" : "" %>>높은 평점 순</option>
	            		<option value="lowest_rating" <%= "lowest_rating".equals(request.getParameter("sort")) ? "selected" : "" %>>낮은 평점 순</option>
	            		<option value="highest_level" <%= "highest_level".equals(request.getParameter("sort")) ? "selected" : "" %>>레벨 높은 순</option>
	        		</select>
	    		</form>
			</div>
	
			<%
	    		// 기본 정렬 기준
	    		String sortOption = request.getParameter("sort");
	    		if (sortOption == null || sortOption.isEmpty()) {
	    		    sortOption = "latest";
	    		}
	
	    		// 정렬 기준에 따라 SQL ORDER BY 조건 설정
	    		String orderByClause = "r.created_at DESC"; // 최신순 기본값
	    		switch (sortOption) {
	        		case "most_likes":
	            		orderByClause = "r.likes DESC";
			            break;
			        case "highest_rating":
			            orderByClause = "r.rating DESC";
			            break;
			        case "lowest_rating":
			            orderByClause = "r.rating ASC";
			            break;
			        case "highest_level":
			            orderByClause = "m.level DESC";
			            break;
			    }
			%>
			
			<%
			    try {
			        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/foodnear_db", "root", "1234");
			        String query = "SELECT r.id AS review_id, r.user_id, r.rating, r.comment, r.likes, r.dislikes, m.name, m.level, r.created_at " +
			                       "FROM review r JOIN member m ON r.user_id = m.id WHERE r.food_id = ? ORDER BY " + orderByClause;
			        pstmt = conn.prepareStatement(query);
			        pstmt.setInt(1, Integer.parseInt(id));
			        rs = pstmt.executeQuery();
			
			        
			%>
			<div class="review-list">
		        <% 	while (rs.next()) { %>
		        <div class="review-item">
		            <strong><%= rs.getString("name") %> (Level <%= rs.getInt("level") %>)</strong>
		            <div class="review-meta">
		                <span>작성일: <%= rs.getTimestamp("created_at") %></span>
		            </div>
		            <p>별점: ★ <%= rs.getFloat("rating") %> / 5</p>
		            <p><%= rs.getString("comment") %></p>
		            
		            <!-- 좋아요,싫어요 버튼 -->
	            	<div class="like-dislike">
		                <form action="likeReview.jsp" method="POST">
		                    <input type="hidden" name="review_id" value="<%= rs.getInt("review_id") %>">
		                    <input type="hidden" name="food_id" value="<%= id %>">
		                    <button type="submit">좋아요 (<%= rs.getInt("likes") %>)</button>
		                </form>
		                <form action="dislikeReview.jsp" method="POST">
		                    <input type="hidden" name="review_id" value="<%= rs.getInt("review_id") %>">
		                    <input type="hidden" name="food_id" value="<%= id %>">
		                    <button type="submit">싫어요 (<%= rs.getInt("dislikes") %>)</button>
		                </form>
		                
		                <!-- 삭제 버튼: 본인 리뷰일 경우에만 표시 -->
				    <% 
				        int reviewUserId = rs.getInt("user_id"); // 리뷰 작성자의 ID
				        if (userId != null && reviewUserId == userId) { 
				    %>
				        <form action="deleteReview.jsp" method="POST" style="display:inline;">
				            <input type="hidden" name="review_id" value="<%= rs.getInt("review_id") %>">
				            <input type="hidden" name="food_id" value="<%= id %>">
				            <button type="submit" onclick="return confirm('정말 삭제하시겠습니까?');">삭제</button>
				        </form>
				    <% } %>
		                
		                
		            </div>
		        </div>
		        <% } %>
		    </div>
		</div>
		<%
		        
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
</body>
</html>

