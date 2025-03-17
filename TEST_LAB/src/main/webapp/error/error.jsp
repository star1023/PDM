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
<title>에러</title>
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
					<p class="pb20"><!--img src="/resources/images/img_logo_login.png"--></p>
					<p><span>서비스 이용에 불편을 드려 죄송합니다.</span></p>			
				</div>
	 			<div class="login_input">
	 				존재하지 않는 페이지이거나, 오류로 인하여 현재 페이지를 볼 수 없습니다.
	 				<br/>
	 				<%=debugMsg.toString() %>	 				
	 				<br/><br/><br/>
					<div>
						<button class="btn_login" onClick="history.back(-1);">확인</button>
					</div>
				</div>
				<br/><br/>
	 		</div>
		<footer>
			<div id="main_footer">
				<span>서울특별시 송파구 중대로 64(문정동) (주)제너시스 <i> | </i> 대표이사 최영 <i> | </i> 정보보호 최고책임자 <br/>(c) GENESIS BBQ ALL Rights Reserved.
		   		</span>
			</div>
		</footer>
		</div>
	</body>
</html>