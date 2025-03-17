<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page session="false" %>
	<link href="/resources/css/common.css?param=1" rel="stylesheet" type="text/css" />
	<link href="/resources/css/board.css" rel="stylesheet" type="text/css" />
	<link href="/resources/css/layout.css" rel="stylesheet" type="text/css" />
	<title>공지사항</title>
	<script type="text/javascript">
	$(document).ready(function (){
		  var selectTarget = $('.selectbox select');

		  selectTarget.on('blur', function(){
		    $(this).parent().removeClass('focus');
		  });

		   selectTarget.change(function(){
		     var select_name = $(this).children('option:selected').text();

		   $(this).siblings('label').text(select_name);
		   });
		   
			var topBar = $("#topBar").offset();

			$(window).scroll(function(){
				
				var docScrollY = $(document).scrollTop()
				var barThis = $("#topBar")
				var fixNext = $("#fixNextTag")

				if( docScrollY > topBar.top ) {
					barThis.addClass("top_bar_fix");
					fixNext.addClass("pd_top_80");
				}else{
					barThis.removeClass("top_bar_fix");
					fixNext.removeClass("pd_top_80");
				}

			});
	});
	
	
	function stepchage(id,step){
		document.getElementById("width_wrap").className = step;
	}
	
	//공지사항 수정
	function goSave(){
		
		if($("#title").val() == ""){
			alert("회의명을 입력하세요.");
			$("#title").focus();
			return;
		}
		
		if($("#reserveDate").val() == ""){
			alert("회의일시를 입력하세요.");
			$("#reserveDate").focus();
			return;
		}
		
		if($("#reserveCode").val() == ""){
			alert("회의실을 선택하여 주세요.");
			$("#reserveCode").focus();
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
		
		var rmrNo = $("#rmrNo").val();
		
		var title = $("#title").val();
		
		var memo = $("#memo").val();
		
		var reserveDate = $("#reserveDate").val();
		
		var reserveTime = $("#reserveTime").val();
		
		var notiYN = $("#notiYN").val();
		
		var reserveCode = $("#reserveCode").val();
		
		if(confirm("수정하시겠습니까? ")){
			
			$.ajax({
				type:"POST",
				url:"/Reserve/ReserveCountAjax",
				data:{
					  "rmrNo":rmrNo,
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
								url:"/Reserve/ReserveEditAjax",
								data:{
									  "rmrNo":rmrNo,
									  "title":title,
									  "memo":memo,
									  "reserveDate":reserveDate,
									  "reserveTime":reserveTime,
									  "notiYN":notiYN,
									  "reserveCode":reserveCode},
								dataType:"json",
								success:function(data){
									if(data.status=='success'){
										alert("수정되었습니다.");
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
	
	function goClose(){
		window.close();
	}
	
	function checkNotiYN(){
		if($("#notiYN").val()=='Y'){
			$("#notiYN").prop("checked",true);
			alert("상단 공지로 등록한 게시물은 일반 게시물로 변경할 수 없습니다.");				
			return;
		}
	}
</script>

<form name="contentsForm" id="contentsForm" method="post" enctype="multipart/form-data" action = "/Reserve/ReserveEditAjax">
	<input type="hidden" id="rmrNo" name="rmrNo" value="${data.rmrNo }">
	<span class="path">
	공지사항 작성&nbsp;&nbsp;<img src="../resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;
	<a href="#">SPC삼립연구소</a>
	</span>
	<section class="type01">
		<h2 style="position:relative">
		<span class="title_s">Notice Doc</span>
		<span class="title">회의실 예약 수정</span>
		</h2>		
		<div class="group01" >
			<div class="title">
			 <c:choose>
			 	<c:when test="${data.notiYN eq 'Y' }">
			 		<input type="checkbox" name="notiYN" id="notiYN" align="middle" value="${data.notiYN}" onchange="checkNotiYN();" checked="checked" />
			 	</c:when>
			 	<c:otherwise>
			 		<input type="checkbox" name="notiYN" id="notiYN" align="middle" value="${data.notiYN}" onchange="checkNotiYN();"/>
				</c:otherwise>
			 </c:choose>
			</div>
			<div class="notice_title">
				<span class="font04">회의명 :&nbsp;<input type="text" style="width:500px; border-radius: 5px; background-color: #ffffff; border: 1px solid #c5c5c5; padding: 3px 5px 5px 5px; box-sizing: border-box;" name="title" id="title" value="${data.title }"/></span><br>	
				<fmt:formatDate value="${data.reserveDate}" pattern="yyyy-MM-dd" var="reserveDate"/>
				<span class="font18">회의일시:&nbsp;<input type="text" name="reserveDate" id="reserveDate" value="${reserveDate}"/> <input type="text" name="reserveTime" id="reserveTime" value="${data.reserveTime}"/></span><br>				
				회의실 선택:
				<select id="reserveCode" name="reserveCode">
					<option value="">--회의실을 선택하여 주세요--</option>
					<option <c:if test="${data.reserveCode == 'V'}">selected</c:if> value="V">비전룸</option>
					<option <c:if test="${data.reserveCode == 'Y'}">selected</c:if> value="Y">열정룸</option>
					<option	<c:if test="${data.reserveCode == 'G'}">selected</c:if> value="G">가치룸</option>
					<option	<c:if test="${data.reserveCode == 'S'}">selected</c:if> value="S">신뢰룸</option>
				</select>
			</div>
			<div class="main_tbl">
				<ul class="notice_view">
					<li>
						<div class="text_view">
							<textarea style="width:100%; height:260px;" name="memo" id="memo" >${data.memo}</textarea>
						</div>
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

