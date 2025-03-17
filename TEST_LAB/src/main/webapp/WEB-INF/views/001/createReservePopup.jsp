<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page session="false" %>
<html>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<head>
<title>공지사항 등록 페이지</title>
</head>
<link href="css/common.css" rel="stylesheet" type="text/css" />
<link href="css/board.css" rel="stylesheet" type="text/css" />
<link href="css/layout.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src='<c:url value="/resources/js/jquery-3.3.1.js"/>'></script>
<script type="text/javascript" src='<c:url value="/resources/js/jquery.form.js"/>'></script>

<script type="text/javascript">
	$(document).ready(function(){
		

	});
	
	function stepchage(id,step){document.getElementById("width_wrap").className = step;}

	function goClose(){
		window.close();
	}
	
function goSave(){
		
		if($("#title").val() == ""){
			alert("회의명을 입력하세요.");
			$("#title").focus();
			return;
		}
		
		if($("#reserveCode").val() == ''){
			alert("회의실을 선택하세요.");
			$("#reserveCode").focus();
			return;
		}
		
		if($("#reserveDate").val() == ""){
			alert("회의일시를 입력하세요.");
			$("#reserveDate").focus();
			return;
		}
		
		if($("#reserveTime").val() == ""){
			alert("회의일시를 입력하세요.");
			$("#reserveTime").focus();
			return;
		}
		
		var chkYN = $("#notiYN").is(":checked");
		
		if(chkYN){
			$("#notiYN").val("Y");
		}else{
			$("#notiYN").val("N");
		}
		
		var title = $("#title").val();
		
		var memo = $("#memo").val();
		
		var reserveDate = $("#reserveDate").val();
		
		var reserveTime = $("#reserveTime").val();
		
		var notiYN = $("#notiYN").val();
		
		var reserveCode = $("#reserveCode").val();
		
		if(confirm("등록하시겠습니까? ")){

			$.ajax({
				type:"POST",
				url:"/Reserve/ReserveCountAjax",
				data:{
					  "title":title,
					  "memo":memo,
					  "reserveDate":reserveDate,
					  "reserveTime":reserveTime,
					  "notiYN":notiYN,
					  "reserveCode":reserveCode},
				dataType:"json",
				success:function(data){
					if(data.status=='success'){
						if(data.count > 0){
							alert("해당 회의실과 예약시간이 겹칩니다. 예약시간을 다시 지정해 주세요.");
						}else{
							
							$.ajax({
								type:"POST",
								url:"/Reserve/ReserveSaveAjax",
								data:{
									  "title":title,
									  "memo":memo,
									  "reserveDate":reserveDate,
									  "reserveTime":reserveTime,
									  "notiYN":notiYN,
									  "reserveCode":reserveCode},
								dataType:"json",
								success:function(data){
									if(data.status=='success'){
										alert("예약되었습니다.");
										window.opener.location.reload();
										window.close();
									}else if(data.status=='fail'){
										alert(data.msg);
									}else{
										alert("오류가 발생하였습니다.");
									}
								},
								error:function(request, status, errorThrown){
									alert("오류가 발생하였습니다.");
								}	
							});
						
						}

					}else if(data.status=='fail'){
						alert(data.msg);
					}else{
						alert("오류가 발생하였습니다.");
					}
				},
				error:function(request, status, errorThrown){
					alert("오류가 발생하였습니다.");
				}	
			});
		}
		
	}
</script>
	<form id="noticeRegistForm" name="noticeRegistForm" method="post" enctype="multipart/form-data">
		<span class="path">
		공지사항 작성&nbsp;&nbsp;<img src="../resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;
		<a href="#">SPC삼립연구소</a>
		</span>
		<section class="type01">
			<h2 style="position:relative">
			<span class="title_s">Notice</span>
			<span class="title">화의실 예약</span>
			</h2>
			<div class="group01" >
			<div class="title">
				상단공지 :<input type="checkbox" name="notiYN" id="notiYN" align="middle"  value="N"/>
				회의실 선택:	<select id="reserveCode" name="reserveCode">
								<option value="">--회의실을 선택하여 주세요--</option>
								<option value="V">비전룸</option>
								<option value="Y">열정룸</option>
								<option value="G">가치룸</option>
								<option value="S">신뢰룸</option>
							</select>
			</div>
				<div class="list_detail">
					<ul>
						<li class="pt10">
							<dt>회의 명</dt>
							<dd class="pr20 pb10">
								<input type="text"style="width:70%;" name="title" id="title" placeholder="제목을 입력해주세요."/>
							</dd>
						</li>
						<li>
							<dt>회의일시</dt>
							<dd class="pr20 pb10">
								<input type="text" name="reserveDate" id="reserveDate"/> <input type="text" name="reserveTime" id="reserveTime"/>
							</dd>
						</li>
						<li>
							<dt>메모</dt>
							<dd class="pr20 pb10">
								<textarea style="width:100%; height:230px" name="memo" id="memo"></textarea>
							</dd>
						</li>	
					</ul>
				</div>
				<div class="btn_box_con" >
					<input type="button" value="저장" class="btn_admin_red" onclick="goSave(); return false;"> 
					<input type="button" value="닫기"  class="btn_admin_gray" onclick="goClose(); return false;">
				</div>
			</div>
		</section>
	</form>
</html>