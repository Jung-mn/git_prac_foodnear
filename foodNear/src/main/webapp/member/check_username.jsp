<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*" %>

<%
    String username = request.getParameter("username"); // 클라이언트에서 전달받은 아이디
    String resultMessage = "";

    if (username != null && !username.trim().isEmpty()) {
        try {
            // DB 연결
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/foodnear_db", "root", "1234");
            
            // 쿼리 실행
            String query = "SELECT COUNT(*) FROM member WHERE username = ?";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setString(1, username);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next() && rs.getInt(1) > 0) {
                resultMessage = "이미 사용중인 아이디입니다.";
            } else {
                resultMessage = "사용 가능합니다.";
            }

            rs.close();
            pstmt.close();
            conn.close();
        } catch (Exception e) {
            resultMessage = "오류 발생: " + e.getMessage();
        }
    } else {
        resultMessage = "아이디를 입력해주세요.";
    }

    out.print(resultMessage); // 결과를 클라이언트로 전달
%>
