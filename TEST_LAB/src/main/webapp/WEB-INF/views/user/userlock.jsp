<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"	trimDirectiveWhitespaces="true"%>
<%@ page import="kr.co.aspn.vo.ResultVO"%>
<%@ page import="com.fasterxml.jackson.databind.ObjectMapper"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String accept = request.getHeader("Accept");
	String xr = request.getHeader("X-Requested-With");
	StringBuffer debugMsg = new StringBuffer();

	// Ajax json 요청
	if ("XMLHttpRequest".equals(xr) && (accept.indexOf("application/json") > -1)) {
		response.setContentType("application/json");

		ResultVO resultVO = new ResultVO(ResultVO.FAIL);
        ObjectMapper mapper = new ObjectMapper();
        String json = mapper.writeValueAsString(resultVO);

        out.println(json);

        return;
	}
%>
<!DOCTYPE HTML>
<html lang="ko">
<head>
<meta charset="utf-8">
<title>삼립식품연구소</title>
<link href="/resources/css/common.css" rel="stylesheet" type="text/css" />
<link href="/resources/css/layout.css" rel="stylesheet" type="text/css" />	
<script type="text/javascript" src='<c:url value="/resources/js/jquery-3.3.1.js"/>'></script>
<script type="text/javascript" src='<c:url value="/resources/js/jquery.form.js"/>'></script>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" />
		<title>삼립 연구소 시스템</title>
	</head>	
	<body bgcolor="#f1f1f1">
 		<div class="login_wrap">
 			<div class="login_box login_ani">
				<div class="login_txt">
					<p class="pb20"><img src="/resources/images/img_logo_login.png"></p>
					<p><span>사용자 계정 잠김 알림</span></p>			
				</div>
	 			<div class="login_input">
	 				30일 이상 로그인하지 않아 계정이 [잠김]상태로 전환되었습니다. 관리자에게 문의하세요.
	 				<br/>
	 				
	 				<br/><br/><br/>
					<div>
						<button class="btn_login" onClick="history.back(-1);">확인</button>
					</div>
				</div>
				<br/><br/>
	 		</div>
		<footer>
			<div id="main_footer">
				<span>서울특별시 서초구 양재동 남부순환로 2620 (주)SPC 삼립 <i> | </i> 대표이사 황종현 <i> | </i> 정보보호 최고책임자 김재섭 <br/>(c) SPC SAMLIP GENERAL FOOD ALL Rights Reserved.
		   		</span>
			</div>
		</footer>
		</div>
	</body>
</html>