<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String loggedInName = (String) session.getAttribute("loggedInName");
    Integer userId = (Integer) session.getAttribute("userId");

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    String username = "";
    String password = "";
    String name = "";
    String email = "";
    String phone = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/foodnear_db", "root", "1234");
        String sql = "SELECT username, password, name, email, phone FROM member WHERE id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, userId);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            username = rs.getString("username");
            password = rs.getString("password");
            name = rs.getString("name");
            email = rs.getString("email");
            phone = rs.getString("phone");
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
    <title>정보 수정</title>
    <link rel="stylesheet" href="style.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #FFF9E6; /* 노란 파스텔 배경색 */
        }

        /* 헤더 스타일 */
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
        /* 폼 컨테이너 스타일 */
        .form-container {
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
            background: #FFFFFF; /* 흰색 배경 */
            border: 1px solid #FFD966; /* 진한 노란색 테두리 */
            border-radius: 5px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        h1 {
            text-align: center;
            color: #333; /* 제목 색상 */
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #333;
        }
        input[type="text"], input[type="password"], input[type="email"], input[type="tel"] {
            width: 96%;
            padding: 10px;
            border: 1px solid #FFD966; /* 노란 테두리 */
            border-radius: 5px;
            font-size: 14px;
        }
        .button {
            display: inline-block;
            padding: 10px 20px;
            margin-top: 20px;
            font-size: 14px;
            color: white;
            background-color: #FFD966; /* 노란 버튼 */
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-align: center;
            text-decoration: none;
        }
        .button:hover {
            background-color: #FFC933; /* 버튼 hover 색상 */
        }
        .button-secondary {
            background-color: #FFEB99; /* 부 버튼 색상 */
        }
        .button-secondary:hover {
            background-color: #FFD966;
        }
        .strong {
        	font-weight: bold;
        	font-size: 20px;
        	margin-top: 6px;
        }
    </style>
</head>
<body>
    <!-- 헤더 -->
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

    <!-- 수정 폼 -->
    <div class="form-container">
        <h1>회원 정보 수정</h1>
        <form action="updateMember.jsp" method="POST">
            <div class="form-group">
                <label for="username">아이디</label>
                <input type="text" name="username" id="username" value="<%= username %>" readonly>
            </div>
            <div class="form-group">
                <label for="password">비밀번호</label>
                <input type="password" name="password" id="password" value="<%= password %>">
            </div>
            <div class="form-group">
                <label for="name">이름</label>
                <input type="text" name="name" id="name" value="<%= name %>">
            </div>
            <div class="form-group">
                <label for="email">이메일</label>
                <input type="email" name="email" id="email" value="<%= email %>">
            </div>
            <div class="form-group">
                <label for="phone">전화번호</label>
                <input type="tel" name="phone" id="phone" value="<%= phone %>">
            </div>
            <button type="submit" class="button">수정하기</button>
            <a href="/foodNear/foodnear/home.jsp" class="button button-secondary">홈으로</a>
        </form>
    </div>
</body>
</html>
