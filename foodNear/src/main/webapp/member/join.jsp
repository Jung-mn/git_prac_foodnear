<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>회원가입</title>
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
            cursor: pointer; /* 클릭할 수 있는 모양으로 변경 */ㄴ
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

        .form-container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            width: 400px;
        }
        .form-container h2 {
            text-align: center;
            margin-bottom: 20px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        .form-group input, .form-group select {
            width: 94%;
            padding: 10px;
            margin-top: 5px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .form-group input[type="checkbox"] {
            width: auto;
        }
        .form-group div {
            margin-top: 5px;
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
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script>
        function checkUsername() {
            const username = document.getElementById('username').value;

            if (username === '') {
                alert('아이디를 입력해주세요.');
                return;
            }

            $.ajax({
                url: 'check_username.jsp',
                type: 'POST',
                data: { username: username },
                success: function(response) {
                    document.getElementById('check-result').innerText = response.trim();
                },
                error: function() {
                    alert('중복 확인 중 문제가 발생했습니다.');
                }
            });
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
        <div class="form-container">
            <h2>회원가입</h2>
            <form action="register_user.jsp" method="POST">
                <div class="form-group">
                    <label>학교</label>
                    <div style="display: flex; gap: 20px;">
                        <label style="color: #666666;">  
                            <input type="radio" name="university" value="인하대" checked> 인하대
                        </label>
                        <label style="color: #666666;">
                            <input type="radio" name="university" value="인하공전"> 인하공전
                        </label>  
                    </div>
                </div>
                <div class="form-group">
                    <label>상태</label>
                    <select name="status">
                        <option value="재학생">재학생</option>
                        <option value="휴학생">휴학생</option>
                        <option value="졸업생">졸업생</option>
                        <option value="교수">교수</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>아이디</label>
                    <div style="display: flex; align-items: center;">
                        <input type="text" id="username" name="username" required 
                               style="flex: 7; padding: 10px; border: 1px solid #ccc; border-radius: 5px;">
                        <button type="button" onclick="checkUsername()" 
                                style="flex: 1; margin-left: 10px; padding: 8px 10px; font-size: 14px; background-color: #FFEBB3; border: 1px solid #ccc; border-radius: 5px; cursor: pointer;">
                            중복확인
                        </button>
                    </div>
                    <div id="check-result" style="margin-top: 10px; color: green;"></div>
                </div>
                <div class="form-group">
                    <label>비밀번호</label>
                    <input type="password" name="password" required>
                </div>
                <div class="form-group">
                    <label>이름</label>
                    <input type="text" name="name">
                </div>
                <div class="form-group">
                    <label>학번</label>
                    <input type="text" name="student_id">
                </div>
                <div class="form-group">
                    <label>이메일</label>
                    <input type="email" name="email">
                </div>
                <div class="form-group">
                    <label>전화번호</label>
                    <input type="text" name="phone">
                </div>
                <button type="submit">회원가입</button>
            </form>
        </div>
    </main>
</body>
</html>
