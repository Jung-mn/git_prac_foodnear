<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>

<html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Foodnear - 홈</title>
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
            flex-direction: column;
            align-items: center;
            padding: 20px;
        }
        .filter-form {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            width: 80%;
            max-width: 600px;
        }
        .filter-form h2 {
            margin-bottom: 20px;
            text-align: center;
            color: #333;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        .form-group input[type="checkbox"] {
            margin-right: 10px;
        }
        .form-group select, .form-group input[type="text"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .submit-button {
            display: block;
            width: 100%;
            padding: 10px;
            background-color: #FFEBB3;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .submit-button:hover {
            background-color: #FFE680;
        }
    </style>
</head>
<body>
    <header>
        <div class="logo">Foodnear</div>
        <div class="auth-buttons">
            <a href="register.jsp">회원가입</a>
            <a href="login.jsp">로그인</a>
        </div>
    </header>
    <main>
        <form class="filter-form" action="search_results.jsp" method="GET">
            <h2>학교 주변 식당 찾기</h2>
            <div class="form-group">
                <label>음식 카테고리</label>
                <label><input type="checkbox" name="category" value="한식"> 한식</label>
                <label><input type="checkbox" name="category" value="중식"> 중식</label>
                <label><input type="checkbox" name="category" value="일식"> 일식</label>
                <label><input type="checkbox" name="category" value="양식"> 양식</label>
                <label><input type="checkbox" name="category" value="주점"> 주점</label>
                <label><input type="checkbox" name="category" value="카페"> 카페</label>
            </div>
            <div class="form-group">
                <label>위치</label>
                <select name="location">
                    <option value="정문">정문</option>
                    <option value="후문">후문</option>
                    <option value="상관없음">상관없음</option>
                </select>
            </div>
            <div class="form-group">
                <label>가격 범위</label>
                <input type="text" name="price_min" placeholder="최소 가격 (숫자 입력)">
                <input type="text" name="price_max" placeholder="최대 가격 (숫자 입력)">
            </div>
            <button type="submit" class="submit-button">검색</button>
        </form>
    </main>
</body>
</html>