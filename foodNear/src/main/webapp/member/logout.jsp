<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 세션 무효화 (로그아웃 처리)
    session.invalidate();
%>
<script>
    // 로그아웃 알림 메시지
    alert("로그아웃되었습니다.");
    // home.jsp로 리다이렉트
    location.href = "/foodNear/foodnear/home.jsp";
</script>