<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.URLDecoder" %>
<%
    String name = request.getParameter("name");
    String decodedName = URLDecoder.decode(name, "UTF-8");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>회원가입 완료</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #FFF9E5;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .container {
            text-align: center;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            width: 400px;
        }
        .container h1 {
            color: #333;
            margin-bottom: 20px;
        }
        .container a {
            display: inline-block;
            margin: 10px;
            padding: 10px 20px;
            color: white;
            background-color: #FFEBB3;
            text-decoration: none;
            border-radius: 5px;
            font-size: 16px;
        }
        .container a:hover {
            background-color: #FFE680;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>회원가입이 성공적으로 완료되었습니다!</h2>
    	<p>환영합니다, <%= request.getParameter("name") %>님!</p>
        <a href="login.jsp">로그인</a>
        <a href="../foodnear/home.jsp">HOME</a>
    </div>
</body>
</html>
