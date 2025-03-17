<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ page session="false" %>
<title>사용자 등록</title>
<script type="text/javascript">
	var idFlag ;
	$(document).ready(function(){
		$('#userId').keyup(function(event){
			if($('#userId').val().length<4){
				$('#checkId').html('<font color="red" font-size="10px">글자수는 4글자 이상으로 설정해주세요.</font>');
				idFlag = false;
			}else{
		 		$.ajax({
				type: 'post',
				url: '/user/checkId?userId='+$('#userId').val(),
				dataType: 'json',
				contentType: false, 
				processData: false,
				async : true,
				success: function (data) {
					if(data.result == 'F'){
						return;
					} else {
						if(data.checkId > 0){
							$('#checkId').html('<font color="red" font-size="10px">이미 사용중인 아이디 입니다.</font>');
							idFlag = false;
						} else {
							$('#checkId').html('<font color="blue" font-size="10px">사용가능한 아이디입니다.</font>');
							idFlag = true;
						}
					}
				},error: function(XMLHttpRequest, textStatus, errorThrown){
					submitBool = true;
				}
			});
			}
		});
	});
	
	function userInsert() {
		$('#insertForm').ajaxForm({
            beforeSubmit: function (data,form,option) {
                //validation체크 
                //막기위해서는 return false를 잡아주면됨
                if( !chkNull($("#userName").val()) ) {
                	alert("이름을 입력해주세요.");
                	$("#userName").focus();
                	return false;
                } else if( !chkNull($("#userId").val()) ) {
                	alert("아이디를 입력해주세요.");
                	$("#userId").focus();
                	return false;
                } else if( !chkNull($("#email").val()) ) {
                	alert("이메일 아이디를 입력해주세요.");
                	$("#email").focus();
                	return false;
                } else if( !chkEmail($("#email").val()) ) {
                	alert("이메일 형식이 올바르지 않습니다. \n 메일아이디@spc.co.kr 형식으로 입력해주세요.");
                	$("#email").focus();
                	return false;
                } else if(idFlag == false){
                	alert('아이디 중복확인을 해주세요.');
                	return false;
                }else {
                	return true;	
                }
                
            },
            success: function(response,status){
                //성공후 서버에서 받은 데이터 처리
                alert("사용자 등록 성공");
            	location.href="../user/userList";
            },
            error: function(){
                //에러발생을 위한 code페이지
            	alert("오류가 발생하였습니다.");
            }                               
        }).submit();
	}
	
	function goUserList(){
		location.href="../user/userList";
	}
	
	function chkNull(ObjSrc) {
		var str = ObjSrc;
		var blank_flg = false;
		if(str == null || str == "") return false;
			for(cnt=0;cnt<str.length;cnt++) {
				if( str.charAt(cnt) != " "){
					blank_flg = true;
				}
				}
			if(!blank_flg) return false;
			return true;
	}
	
	function chkEmail(str) {
	    var regExp = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
	    if (regExp.test(str)) return true;
	    else return false;
	}
</script>
<form id="insertForm" name="insertForm" method="post" action="../user/insert">
<div class="wrap_in" id="fixNextTag">
	<span class="path">
		사용자관리&nbsp;&nbsp;<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;
		관리자&nbsp;&nbsp;<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;
		<a href="#">${strUtil:getSystemName()}</a>
	</span>
	<section class="type01">
	<!-- 상세 페이지  start-->
		<h2 style="position:relative">
			<span class="title_s">user management</span>
			<span class="title">사용자 관리</span>
			<div  class="top_btn_box">
				<ul>
					<li>
					</li>
				</ul>
			</div>
		</h2>
		<div class="group01" >
			<div class="title"><!--span class="txt">연구개발시스템 공지사항</span--></div>
			<div class="list_detail">
				<ul>
					<li class="pt10">
						<dt>이름</dt>
						<dd class="pr20 pb10">
							<input type="text" name="userName" id="userName" style="width:40%;" placeholder="이름을 입력해주세요."/>
						</dd>
					</li>
					<li>
						<dt>아이디</dt>
						<dd class="pr20 pb10">
							<input type="text" name="userId" id="userId" style="width:40%;" placeholder="아이디를 입력해주세요."/>
							<span id="checkId"></span>
						</dd>
					</li>
					<li>
						<dt>eMail 주소</dt>
						<dd class="pr20 pb10">
							<input type="text" name="email" id="email" style="width:40%;" placeholder="메일주소를 입력해주세요.(예:test@spc.co.kr)"/>
						</dd>
					</li>
					<li>
						<dt>부서</dt>
						<dd class="pr20 pb10">
							<div class="selectbox" style="width:20%"> 
								<label for="deptCode">선택하세요</label>
								<select name="deptCode" id="deptCode">
									<option value="">선택하세요</option>
									<c:forEach  items="${deptList}" var = "dept">
										<option value="${dept.itemCode}">${dept.itemName}</option>
									</c:forEach>											
								</select>
							</div>
						</dd>
					</li>
					<li>
						<dt>팀</dt>
						<dd class="pr20 pb10">
							<div class="selectbox" style="width:20%"> 
								<label for="teamCode">선택하세요</label>
								<select name="teamCode" id="teamCode">
									<option value="">선택하세요</option>
									<c:forEach  items="${teamList}" var = "team">
									<option value="${team.itemCode}">${team.itemName}</option>
									</c:forEach>
								</select>
							</div>
						</dd>
					</li>
					<li>
						<dt>권한</dt>
						<dd class="pr20 pb10">
							<div class="selectbox" style="width:20%"> 
								<label for="userGrade">선택하세요</label>
								<select name="userGrade" id="userGrade">
									<option value="">선택하세요</option>
									<c:forEach  items="${gradeList}" var = "grade">
									<option value="${grade.itemCode}">${grade.itemName}</option>
									</c:forEach>
								</select>
							</div>							
						</dd>
					</li>
					<li>
						<dt>시스템 관리자</dt>
						<dd class="pr20 pb10">
							<input type="checkbox" name="isAdmin" id="isAdmin" value="Y"><label for="isAdmin"><span></span>시스템 관리자</label>
						</dd>
					</li>
				</ul>
			</div>
			<div class="btn_box_con5">
			</div>
			<div class="btn_box_con4"> 
				<button type="button" class="btn_admin_red" onClick="javascript:userInsert()">저장</button> 
				<button type="button" class="btn_admin_gray" onClick="javascript:goUserList()">목록</button>
			</div>
			 <hr class="con_mode"/><!-- 신규 추가 꼭 데려갈것 !-->
		</div>
	</section>	
</div>
<!-- 컨텐츠 close-->	
</form>