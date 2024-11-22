<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>로그인</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #FFF9E5; /* 노란 파스텔 톤 */
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        /* 헤더 스타일 */
        header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 20px;
            background-color: #FFEBB3; /* 더 진한 노란색 */
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            position: fixed;
            top: 0;
            left: 0;
            width: 98%;
            z-index: 1000;
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

        main {
            display: flex;
            justify-content: center;
            align-items: center;
            flex: 1;
            margin-top: 80px; /* 헤더 높이 공간 확보 */
        }

        .login-container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            width: 300px;
            text-align: center;
        }
        .login-container h2 {
            margin-bottom: 20px;
        }
        .form-group {
            margin-bottom: 15px;
            text-align: left;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        .form-group input {
            width: 92%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        button {
            width: 100%;
            padding: 10px;
            background: #FFEBB3;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
        }
        button:hover {
            background: #FFE680;
        }
    </style>
    <script>
        function validateLogin() {
            const form = document.getElementById("loginForm");
            const id = form.username.value.trim();
            const password = form.password.value.trim();

            if (id === "" || password === "") {
                alert("아이디와 비밀번호를 입력해주세요.");
                return false;
            }
            return true;
        }
    </script>
</head>
<body>
    <header>
        <div class="logo" onclick="location.href='/foodNear/foodnear/home.jsp'">Foodnear</div>
        <div class="auth-buttons">
            <a href="/foodNear/member/login.jsp">로그인</a>
            <a href="/foodNear/member/join.jsp">회원가입</a>
        </div>
    </header>

    <main>
        <div class="login-container">
            <h2>로그인</h2>
            <form id="loginForm" action="login_check.jsp" method="POST" onsubmit="return validateLogin();">
                <div class="form-group">
                    <label for="username">아이디</label>
                    <input type="text" id="username" name="username">
                </div>
                <div class="form-group">
                    <label for="password">비밀번호</label>
                    <input type="password" id="password" name="password">
                </div>
                <button type="submit">로그인</button>
            </form>
        </div>
    </main>
</body>
</html>
