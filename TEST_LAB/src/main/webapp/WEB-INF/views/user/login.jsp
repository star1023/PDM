<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>제너시스 식품연구소</title>
	<link href="/resources/css/common.css" rel="stylesheet" type="text/css" />
	<link href="/resources/css/layout.css" rel="stylesheet" type="text/css" />
		
<script type="text/javascript" src="/resources/js/jquery-3.3.1.js"></script>
<script type="text/javascript" src="/resources/js/jquery.form.js"></script>
<script type="text/javascript">
//로그인 처리
function loginProc(){
	if($("#userId").val() == '' ) {
		alert("아이디를 입력하세요.");
		$("#userId").focus();
		return;
	} else if( $("#userPwd").val() == '' ) {
		alert("비밀번호를 입력하세요.");
		$("#userPwd").focus();
		return;
	} else {
		var URL = "../user/loginProcAjax";
		$.ajax({
			type:"POST",
			url:URL,
			data:{
				"userId" : $("#userId").val(),
				"userPwd" : $("#userPwd").val()
			},
			dataType:"json",
			async:false,
			success:function(data) {
				if(data.status == 'success'){
					location.href = '../main/main';			
		        } else if( data.status == 'fail' ){
					alert(data.msg);
		        } else if( data.status == 'lock' ) {
		        	location.href = '/user/userlock.jsp';
		        } else{
					alert('아이디 또는 비밀번호가 일치하지 않습니다.');
		        }
			},
			error:function(request, status, errorThrown){
				alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
			}			
		});
	}
	
	
}
</script>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" />
		<title>삼립 연구소 시스템</title>
	</head>	
	<body bgcolor="#f1f1f1">
 		<div class="login_wrap">
 			<div class="login_box login_ani">
				<div class="login_txt">
					<p class="pb20">로고 추가 예정<!--img src="/resources/images/img_logo_login.png"--></p>
					<p><span>BBQ 식품연구소 관리자 페이지입니다.</span></p>				
				</div>
	 			<div class="login_input">
	 				<input type="text" id="userId" name="userId" tabindex="1" class="inputbg01" placeholder="아이디"/>
					<input type="password" id="userPwd" name="userPwd" tabindex="2" onKeyPress="if(window.event.keyCode == 13) { loginProc();}" class="inputbg02" placeholder="비밀번호"/>
					<!-- auto_save_off / auto_save_on -->
					<div class="auto_save">
					<!--아이디 자동저장 <a href="#"><img src="images/auto_save_on.png"/></a>-->
					</div>
					<div>
						<button class="btn_login" onClick="javascript:loginProc();">관리자 로그인</button>
					</div>
				</div>
			<br/><br/><br/> 
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