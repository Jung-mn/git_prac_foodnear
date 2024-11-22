<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String loggedInName = (String) session.getAttribute("loggedInName");
	Integer userId = (Integer) session.getAttribute("userId");

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    int userLevel = 0;
    int totalLikes = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/foodnear_db", "root", "1234");
        String sql = "SELECT likes_received, level FROM member WHERE id = ?";
        System.out.println(userId);
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, userId);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            totalLikes = rs.getInt("likes_received");
            userLevel = rs.getInt("level");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
            background-color: #FFF9E5; /* 노란 파스텔 톤 */
            color: #333;
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
        .container {
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 20px;
        }
        .profile-card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            width: 80%;
            max-width: 400px;
            text-align: center;
        }
        .profile-card h1 {
            margin-bottom: 10px;
            font-size: 24px;
            color: #333;
        }
        .profile-card p {
            margin: 5px 0;
            font-size: 16px;
            color: #666;
        }
        .button-group {
            margin-top: 20px;
            display: flex;
            justify-content: space-around;
        }
        .button {
            padding: 10px 20px;
            background-color: #FFEBB3;
            color: #333;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .button:hover {
            background-color: #FFE680;
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
        <div class="logo" onclick="location.href='/foodNear/foodnear/home.jsp'">Foodnear</div>
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
    
    <!-- 마이페이지 정보 -->
    <div class="container">
        <div class="profile-card">
            <h1><%= loggedInName %>님</h1>
            <p>누적 좋아요 수: <strong><%= totalLikes %></strong></p>
            <p>레벨: <strong><%= userLevel %></strong></p>
            <div class="button-group">
                <button class="button" onclick="location.href='modify.jsp'">수정하기</button>
                <button class="button" onclick="location.href='/foodNear/foodnear/home.jsp'">HOME</button>
            </div>
        </div>
    </div>
</body>
</html>
