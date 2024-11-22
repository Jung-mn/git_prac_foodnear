<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<% 
	// 세션에서 'loggedInName' 값을 가져오기
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
    <title>검색 결과</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #FFF9E5;
            margin: 0;
            padding: 0;
        }
        .result-container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }
        .result-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .result-header select {
            padding: 5px;
            border-radius: 5px;
            border: 1px solid #ccc;
        }
        .result-item {
            display: flex;
            align-items: flex-start;
            margin-bottom: 15px;
            padding: 10px;
            border-bottom: 1px solid #ccc;
        }
        .result-item:last-child {
            border-bottom: none;
        }
        .result-item img {
            width: 120px;
            height: 120px;
            object-fit: cover;
            border-radius: 8px;
            margin-right: 15px;
        }
        .result-item h3 {
            margin: 0;
            font-size: 20px;
            color: #333;
        }
        .result-item p {
            margin: 5px 0;
            font-size: 14px;
            color: #555;
        }
        .result-item h3 a {
            text-decoration: none;
            color: #007bff;
        }
        .result-item h3 a:hover {
            text-decoration: underline;
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

    <div class="result-container">
        <div class="result-header">
            <h2>검색 결과</h2>
            <form action="resultList.jsp" method="GET" style="margin: 0;">
                <% 
                    String[] categories = request.getParameterValues("category");
                    String position = request.getParameter("position");
                    String priceMin = request.getParameter("priceMin");
                    String priceMax = request.getParameter("priceMax");

                    if (categories != null) {
                        for (String category : categories) {
                %>
                            <input type="hidden" name="category" value="<%= category %>">
                <% 
                        }
                    }
                %>
                <input type="hidden" name="position" value="<%= position %>">
                <input type="hidden" name="priceMin" value="<%= priceMin %>">
                <input type="hidden" name="priceMax" value="<%= priceMax %>">
                
				<!-- 정렬 종류 -->
                <select name="sort" onchange="this.form.submit()">
                    <option value="alphabetical" <%= "alphabetical".equals(request.getParameter("sort")) ? "selected" : "" %>>가나다 순</option>
                    <option value="highF_rating" <%= "highF_rating".equals(request.getParameter("sort")) ? "selected" : "" %>>평점 높은순</option>
                    <option value="highrating" <%= "highrating".equals(request.getParameter("sort")) ? "selected" : "" %>>네이버평점 높은순</option>
                    <option value="lowrating" <%= "lowrating".equals(request.getParameter("sort")) ? "selected" : "" %>>네이버평점 낮은순</option>
                    <option value="lowprice" <%= "lowprice".equals(request.getParameter("sort")) ? "selected" : "" %>>낮은 가격 순</option>
                    <option value="highprice" <%= "highprice".equals(request.getParameter("sort")) ? "selected" : "" %>>높은 가격 순</option>
                </select>
            </form>
        </div>

        <%	
        	/* 정렬 종류 */
            String sort = request.getParameter("sort");
            StringBuilder query = new StringBuilder("SELECT id, name, bestmenu, price, opentime, closetime, navergrade, f_rating, photo FROM foodnear WHERE 1=1");

            if (categories != null && categories.length > 0) {
                query.append(" AND category IN (");
                for (int i = 0; i < categories.length; i++) {
                    query.append("'").append(categories[i]).append("'");
                    if (i < categories.length - 1) query.append(", ");
                }
                query.append(")");
            }
            if (position != null && !position.equals("상관없음")) {
                query.append(" AND position = '").append(position).append("'");
            }
            if (priceMin != null && !priceMin.isEmpty()) {
                query.append(" AND price >= ").append(priceMin);
            }
            if (priceMax != null && !priceMax.isEmpty()) {
                query.append(" AND price <= ").append(priceMax);
            }

            if ("alphabetical".equals(sort)) {
                query.append(" ORDER BY name ASC");
            } else if ("highF_rating".equals(sort)) {
            	query.append(" ORDER BY f_rating DESC");
            } else if ("highrating".equals(sort)) {
                query.append(" ORDER BY navergrade DESC");
            } else if ("lowrating".equals(sort)) {
                query.append(" ORDER BY navergrade ASC");
            } else if ("lowprice".equals(sort)) {
                query.append(" ORDER BY price ASC");
            } else if ("highprice".equals(sort)) {
                query.append(" ORDER BY price DESC");
            } else {
                query.append(" ORDER BY name ASC");
            }

            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/foodnear_db", "root", "1234");
                pstmt = conn.prepareStatement(query.toString());
                rs = pstmt.executeQuery();

                while (rs.next()) {
                    int id = rs.getInt("id");
                    String name = rs.getString("name");
                    String bestmenu = rs.getString("bestmenu");
                    int price = rs.getInt("price");
                    float opentime = rs.getFloat("opentime");
                    float closetime = rs.getFloat("closetime");                   
                    float navergrade = rs.getFloat("navergrade");
                    float f_rating = rs.getFloat("f_rating");
                    String photo = rs.getString("photo");
        %>
        			<!-- 식당 정보 -->
                    <div class="result-item">
                        <img src="<%= photo %>" alt="식당 사진">
                        <div>
                            <h3><a href="/foodNear/foodnear/foodInfor.jsp?id=<%= id %>"><%= name %></a></h3>
                            <p><strong>대표 메뉴:</strong> <%= bestmenu %></p>
                            <p><strong>가격:</strong> <%= price %></p>
                            <p><strong>영업시간:</strong> <%= opentime %> ~ <%= closetime %></p>
                            <p><strong>평점:</strong> <%= f_rating %></p>
                            <p><strong>네이버 평점:</strong> <%= navergrade %></p>
                        </div>
                    </div>
        <%
        	 }
            } catch (Exception e) {
                out.println("<p>데이터를 불러오는 중 문제가 발생했습니다.</p>");
                e.printStackTrace();
            } finally {
                if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        %>
    </div>
</body>
</html>
