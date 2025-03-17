<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page session="false" %>
	<script type="text/javascript" src="../resources/js/reservemeeting.js"></script>
	<title>회의실 예약리스트</title>
	<link href="../resources/css/main.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
$(document).ready(function(){
	$("#reserveDate").datepicker({
		dateFormat: 'yy-mm-dd',
		minDate : 0, 
		buttonImage: '/resources/images/btn_calendar.png',
		buttonImageOnly: true,
		buttonText: "선택",  
		showOn: 'both',
		showMonthAfterYear: true,
		showOtherMonths: false,
		dayNames: ['일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일'],
		dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
		monthNames: [ "1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
		monthNamesShot: [ "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"],
		showOtherMonths: true,
		yearSuffix: "년",
		beforeShowDay:function(date){
			var day = date.getDay();

			return [(day != 0 && day != 6)];
		},
		onSelect : function(dateText,inst){
			var today = new Date(dateText).getDay();
			
			var yearFormat = new Date().getFullYear();
			
			var monthFormat = new Date().getMonth() + 1;
			
			var dateFormat = new Date().getDate();
			
			var todayFormat = yearFormat + "-" + monthFormat + "-" +dateFormat;
			
			$("#reserveDayCode").val(today);
			
			var html = "<option value=\"\">선택</option>";
			
			var html2 = "<option value=\"\">선택</option>";
				
			var timeAry = ['09:00', '09:30', '10:00', '10:30', 
				'11:00', '11:30', '12:00', '12:30', 
				'13:00', '13:30', '14:00', '14:30', 
				'15:00', '15:30', '16:00', '16:30', 
				'17:00', '17:30', '18:00'];
			
			if(dateText == todayFormat){
				for ( var i = 0; i < timeAry.length ; i++ ) {
					var isSelected = "";
					if( parseInt($("#timeCode").val())-1 == i) {
						isSelected = "selected";
					}
					html += "<option value = \""+timeAry[i]+"\" "+isSelected+">"+timeAry[i]+"</option>";
			    }
				
				for ( var i = 0; i < timeAry.length ; i++ ) {
					var isSelected = "";
					if( parseInt($("#timeCode").val()) == i) {
						isSelected = "selected";
					}
					html2 += "<option value = \""+timeAry[i]+"\" "+isSelected+">"+timeAry[i]+"</option>";
			    }

			}else{
				for ( var i = 0; i < timeAry.length ; i++ ) {
					var isSelected = "";
					if( parseInt($("1").val())-1 == i) {
						isSelected = "selected";
					}
					html += "<option value = \""+timeAry[i]+"\" "+isSelected+">"+timeAry[i]+"</option>";
			    }
				
				for ( var i = 0; i < timeAry.length ; i++ ) {
					var isSelected = "";
					if( parseInt($("1").val()) == i) {
						isSelected = "selected";
					}
					html2 += "<option value = \""+timeAry[i]+"\" "+isSelected+">"+timeAry[i]+"</option>";
			    }
			}
			
			$("#startTime").html(html);
			$("label[for=startTime]").html($("#startTime").selectedTexts()[0]);
			
			$("#endTime").html(html2);
			$("label[for=endTime]").html($("#endTime").selectedTexts()[0]);

		},
	})
	
	$('.ui-datepicker-trigger').css('margin-left', '8px');
	$('.ui-datepicker-trigger').css('margin-top', '-5px');
	$('.ui-datepicker-trigger').css('cursor', 'pointer');
	
	fileListCheck();
	
})

function fileListCheck(){
	var nodes=$("#fileData").children();
	if( nodes.length > 0 ) {
		$("#add_file2").prop("class","add_file");
		$("#fileList").show();
	} else {
		$("#add_file2").prop("class","add_file2");
		$("#fileList").hide();
	}
}

function fileDownReserve(rmrNo){
	 $.ajax({
		 type:"POST",
			url:"/Reserve/ReserveDetail",
			data:{
					"tbKey":rmrNo,
				  "tbType":"reserve"
			},
			dataType:"json",
			success:function(data){
				if(data.status == 'S'){
					
					$("#detailDate").html("<dt>날짜</dt><dd>"+data.detailReserve.reserveDateFormat+"</dd>");
					$("#detailStartTime").html("<dt>시작시간</dt><dd>"+data.detailReserve.startTime+"</dd>");
					$("#detailEndTime").html("<dt>종료시간</dt><dd>"+data.detailReserve.endTime+"</dd>");
					$("#detailPn").html("<dt>인원</dt><dd>"+data.detailReserve.pn+"</dd>");
					
					if(data.detailReserve.notiYN == 'Y'){
						$("#detailTitle").html("<dt>회의목적</dt><dd><strong>[중요]</strong>"+data.detailReserve.title+"</dd>");
					}else{
						$("#detailTitle").html("<dt>회의목적</dt><dd><strong></strong>"+data.detailReserve.title+"</dd>");
					}
					
					
			 		if($.trim(data.detailReserve.meetingCategory) == 'Y'){
						$("#detailMeetingCategory").html("<dt>회의유형</dt><dd>세미나/외부강의</dd>");
					}else{
						$("#detailMeetingCategory").html("<dt>회의유형</dt><dd></dd>");
					} 
					
			 		
					$("#modifyReserveBtn").attr("onclick","test("+data.detailReserve.rmrNo+"); return false;");
					
					$("#fileListUl").empty();
					
					if(data.fileList.length > 0){
						
						var html = "";
						
						for(var i=0 ; i<data.fileList.length; i++){

								html = "<li><a href='/file/fileDownload?fmNo="+data.fileList[i].fmNo+"&tbkey="+data.fileList[i].tbKey+"&tbType=reserve'>"+data.fileList[i].orgFileName+"</a></li>";
								$("#fileListUl").append(html);
						}
						
					}
					
					openDialog("insert_meeting_view");					
				}else {
					alert("오류가 발생하였습니다.");
				}
			},
			error:function(request, status, errorThrown){
				alert("오류가 발생하였습니다.");
			}
	 });
}

/* function modifyPopup(no,text){
	
	$("#reserveDate").val('');
	
	$("label[for=startTime]").text('---선택---');
	$("label[for=startTime]").val('');
	$("#startTime").val('');
	
	$("label[for=endTime]").text('---선택---');
	$("label[for=endTime]").val('');
	$("#endTime").val('');
	
	$("#pn").val('');
	
	$("#title").val('');
	
	$("#notiYN").prop("checked",false);
	$("label[for=reserveRoomCode]").text('---선택---');
	$("label[for=reserveRoomCode]").val('');
	$("#reserveRoomCode").val('');
	$("#reserveDayCode").val('');
	$("#modifyRmrNo").val('');
	$("#notiYNval").val('');
	$("#gubun").val('');
	
	if($("#fileData li").length > 0){
		for(var i=0; i < $("#fileData li").length; i++){
			
			var fileId = parseInt($("#fileData li").eq(i).attr("id").slice(7));
			
			var fileNo = fileId-1;
			
			$("#file"+fileNo).remove();
			$("#fileSpan"+fileNo).remove();

		}
		
			$("#fileData").empty();
		
			fileListCheck();
	}	
	
	
	
	
	
	if(text == 'modify'){
		$.ajax({
			 type:"POST",
				url:"/Reserve/ReserveDetail",
				data:{
						"tbKey":no,
					  "tbType":"reserve"
				},
				dataType:"json",
				success:function(data){
					if(data.status == 'S'){
						
						$("#reserveDate").val($.trim(data.detailReserve.reserveDateFormat1));

						
						var gubunSt = "AM";
						var gubunEd = "AM";
						
						if(parseInt(($.trim(data.detailReserve.startTime)).substr(0,2)) >= 12){
							gubunSt = "PM";
						}
						
						if(parseInt(($.trim(data.detailReserve.endTime)).substr(0,2)) >= 12){
							gubunEd = "PM";
						}
						
						$("label[for=startTime]").text(gubunSt+" "+$.trim(data.detailReserve.startTime));
						$("label[for=endTime]").text(gubunEd+" "+$.trim(data.detailReserve.endTime));
						
						$("label[for=startTime]").val($.trim(data.detailReserve.startTime));
						$("label[for=endTime]").val($.trim(data.detailReserve.endTime));
						$("#startTime").val($.trim(data.detailReserve.startTime));
						$("#endTime").val($.trim(data.detailReserve.endTime));
						$("#reserveDayCode").val($.trim(data.detailReserve.reserveDayCode));
						
						$("#pn").val($.trim(data.detailReserve.pn));
						$("#modifyRmrNo").val($.trim(data.detailReserve.rmrNo));
						
						var reserveCode = $.trim(data.detailReserve.reserveCode);
						
						if(reserveCode == 'V'){
							$("label[for=reserveRoomCode]").text('비전룸');
							$("label[for=reserveRoomCode]").val(reserveCode);
							$("#reserveRoomCode").val(reserveCode);
						}else if(reserveCode == 'Y'){
							$("label[for=reserveRoomCode]").text('열정룸');
							$("label[for=reserveRoomCode]").val(reserveCode);
							$("#reserveRoomCode").val(reserveCode);
						}else if(reserveCode == 'G'){
							$("label[for=reserveRoomCode]").text('가치룸');
							$("label[for=reserveRoomCode]").val(reserveCode);
							$("#reserveRoomCode").val(reserveCode);
						}else{
							$("label[for=reserveRoomCode]").text('신뢰룸');
							$("label[for=reserveRoomCode]").val(reserveCode);
							$("#reserveRoomCode").val(reserveCode);
						}
						
						if($.trim(data.detailReserve.notiYN) == 'Y'){
							$("#notiYNval").prop("checked",true);
						}else{
							$("#notiYNval").prop("checked",false);
						}
						
						$("#title").val($.trim(data.detailReserve.title));
						$("#insertPopupTitle").text("회의실 수정");
						$("#reserveModifyBtn").text("수정");
						
						openDialog("insert_meeting");					
					
					}else {
						alert("오류가 발생하였습니다.");
					}
				},
				error:function(request, status, errorThrown){
					alert("오류가 발생하였습니다.");
				}
		 });
	}else{
		$("#insertPopupTitle").text("회의실 예약");
		$("#reserveModifyBtn").text("예약");
		openDialog("insert_meeting");
	}
	 
	
} */

function deleteReserve(no){
	
	var userId = '${loginuserId}';
	
	if(confirm("삭제하시겠습니까?")){
		$.ajax({
			type:"POST",
			url:"/Reserve/ReserveDelete",
			data:{
				  "nNo":no,
				  "userId":userId,
				  "tbType":"reserve"
			},
			dataType:"json",
			success:function(data){
				if(data.result == 'S'){
					alert("해당 예약이 삭제 되었습니다.");
					location.href = "/Reserve/ReserveList?pageNo="+'${paramVO.pageNo}'+"&viewCount="+'${paramVO.viewCount}'+"&searchType="+'${paramVO.searchType}'+"&searchValue="+encodeURI(encodeURIComponent('${paramVO.searchValue}'));
				}else {
					alert("오류가 발생하였습니다.");
				}
			},
			error:function(request, status, errorThrown){
				alert("오류가 발생하였습니다.");
			}	
		});
	} 
	
}

function paging(no){
	
	location.href = '/Reserve/ReserveList?pageNo='+no+"&searchType="+'${paramVO.searchType}'+"&searchValue="+ encodeURI(encodeURIComponent('${paramVO.searchValue}'))+"&viewCount="+'${paramVO.viewCount}';
	
}

function reserveBtn(){
	
/* 	var text = $("#insertPopupTitle").text();
	
	var modifyDate = $("#modifyDate").val();
	var startTime = $("#modifyStartTime").val();
	var endTime = $("#modifyEndTime").val();
	var title = $("#modifyTitle").val();
	var pn =  $("#modifyPn").val();
	var notiYN = "N";
	var reserveDayCode = $("#modifyReserveDayCode").val();
	var rmrNo = $("#modifyRmrNo").val();
	var reserveCode = $("#modifyMeetingRoom").val();
	
 	if($("#modifyNotiYN").is(":checked")){
		notiYN = "Y";
	} 
	
	if(text == '회의실 수정'){
		
		
		if(confirm("수정하시겠습니까?")){
			
			$.ajax({
				type:"POST",
				url: "/Reserve/ReserveCount",
				data:{
					  "reserveDate":$("#modifyDate").val(),
					  "startTime":$("#modifyStartTime").val(),
					  "endTime":$("#modifyEndTime").val(),
					  "reserveCode" : reserveCode
				},
				dataType:"json",
				success:function(data){
					if(data.status == 'S'){
						if(data.count > 0){
							alert("이미 예약되어 있는 시간대입니다.");
						}else{
							
						}
					}else {
						alert("오류가 발생하였습니다.");
					}
				},
				error:function(request, status, errorThrown){
					alert("오류가 발생하였습니다.");
				}
			});
			
		}		
	}else { */

			if($("#isPast").val() == 'Y'){
				alert("과거건은 수정하실수 없습니다.");
				return false;
			}
		
		
			var startTime = $("#startTime").val();
			
			var endTime = $("#endTime").val();
			
			var notiYN = "";
			
			if($("#reserveDate").val() == '' || $("#reserveDate").val() == undefined){
				$("#reserveDate").focus();
				alert("예약 날짜를 지정해주세요.");
				return false;
			}
			
			if((startTime == '' || startTime == undefined) && (endTime == '' || endTime == undefined)){
				
				$("#startTime").focus();
				
				$("#endTime").focus();
			
				alert("시작시간과 종료시간을 선택해주세요.");
				return false;
			}
			
		/* 	var startDate = new Date($("#reserveDate").val().substr(0,4),$("#reserveDate").val().substr(5,2),$("#reserveDate").val().substr(8,2),$("#startTime").val().substr(0,2),$("#startTime").val().substr(3,2));
			
			var endDate = new Date($("#reserveDate").val().substr(0,4),$("#reserveDate").val().substr(5,2),$("#reserveDate").val().substr(8,2),$("#endTime").val().substr(0,2),$("#endTime").val().substr(3,2));
			
			var min = (endDate.getTime()-startDate.getTime())/60000;
			
			if(min > 120){
				alert("최대 2시간 예약 가능합니다.");
				return false;
			} */
			
			if(startTime >= endTime){
				alert("시작시간과 종료시간을 다시 선택해주세요.");
				return false;
			}
			
			if($("#pn").val() == '' || $("#pn").val() == undefined){
				
				$("#pn").focus();
				alert("사용할 인원수를 입력해주세요.");
				return false;
			}
			
			if($("#title").val() == '' || $("#title").val() == undefined){
				
				$("#title").focus();
				
				alert("회의 목적을 입력해주세요.");
				
				return false;
			}
			
			if($("#notiYN").is(":checked") == true){
				
				notiYN = "Y";
				
			}else{
				
				notiYN = "N";
				
			}
			
			if($("#meetingCategory").is(":checked") == true){
				
				$("#meetingCategoryVal").val("Y");
				
			}else{
				
				$("#meetingCategoryVal").val("N");
				
			}
			
			$("#notiYNval").val(notiYN);
			
			$("#gubun").val('reserve');
			
			if(confirm("등록하시겠습니까?")){
				$.ajax({
					type:"POST",
					url:"/Reserve/ReserveCount",
					data:{
						  "reserveDate":$("#reserveDate").val(),
						  "startTime":$("#startTime").val(),
						  "endTime":$("#endTime").val(),
						  "reserveCode" : 'V',
						  "rmrNo" : $("#modifyRmrNo").val()
					},
					dataType:"json",
					success:function(data){
						if(data.status == 'S'){
							if(data.count > 0){
								alert("이미 예약되어 있는 시간이 포함되어있습니다.");
							}else{
								$("#insert_meeting_form").submit();
							}
						}else {
							alert("오류가 발생하였습니다.");
						}
					},
					error:function(request, status, errorThrown){
						alert("오류가 발생하였습니다.");
					}	
				}); 
				 
			}
	/* } */
	
}

var tmpNo = 1;

function addFile(fileIdx){
	var filePath = document.getElementById("file"+fileIdx).value;
	var fileName = filePath.substring(filePath.lastIndexOf('\\') + 1,	filePath.length);
	if (fileName.length == 0) {
		alert("파일을 선택해 주십시요.");
		return;
	}
	// 파일 추가
	$("#fileSpan"+fileIdx).hide();
	tmpNo = ++fileIdx;
	var html = "";
	html += "<li id='selfile" + fileIdx 	+ "'>";
	html += "		<a href='#' onClick='javascript:deleteFile(this)'><img src=\"/resources/images/icon_del_file.png\"></a>";
	html += "		"+ fileName + "";
	html += "</li>"
	$("#fileData").prepend(html);
	html = "";
	html += "<span class=\"file_load\" id=\"fileSpan" + fileIdx + "\">";
	html += "<input type=\"file\" name=\"files\" id='file" + fileIdx + "' onChange=\"javaScript:addFile(tmpNo)\" style=\"display:none\"><label for=\"file" + fileIdx + "\">첨부파일 등록 <img src=\"/resources/images/icon_add_file.png\"></label>";
	html += "</span>";
	$("#upFile").append(html);
	fileListCheck();
}

function deleteFile(e){
	var fileSpanId = $(e).parent().prop("id");
	var fileIndex = fileSpanId.slice(7);
	var fileId = "file"+fileIndex;
	var fileNo = fileIndex - 1;
	$(e).parent().remove();
	$("#file"+ fileNo).remove();
	$("#fileSpan"+fileNo).remove();
	fileListCheck();
	return;
}

function deleteFileList(e){
	
	var fileDelete = $(e).siblings("input[name=fileDeleteInput]").val();
	
	var fileDeleteVal = $("#fileDelete").val();
	
	if(fileDeleteVal == '' || fileDeleteVal == undefined){
		$("#fileDelete").val(fileDelete);
	}else{
		fileDeleteVal = fileDeleteVal + ',' + fileDelete;
		$("#fileDelete").val(fileDeleteVal);
	}
	
	$(e).parent().remove();
	fileListCheck();
	return;
}

function searchClear(){
	
	$("#searchType").selectOptions("");	
	$("#searchType_label").html("선택");
	$("#searchValue").val("");
	$("#viewCount").selectOptions("");
	$("#viewCount_label").html("선택");
	
 	goSearch();  
}

function goSearch(){
	
	var searchValue = encodeURI(encodeURIComponent($("#searchValue").val()));
	
	location.href = "/Reserve/ReserveList?&searchType="+$("#searchType").val()+"&searchValue="+searchValue+"&viewCount="+$("#viewCount").val();
	
}
</script>
	<div class="wrap_in" id="fixNextTag">
				<span class="path">회의실 예약 리스트&nbsp;&nbsp;<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;<a href="#">삼립식품 연구개발시스템</a></span>
				<section class="type01">
				<!-- 상세 페이지  start-->
					<h2 style="position:relative"><span class="title_s">conference room</span>
						<span class="title">회의실 예약 리스트</span>
						<div  class="top_btn_box">
							<ul><li><button class="btn_circle_red" onClick="modifyPopup('','reserve','${timeCode}'); return false;">&nbsp;</button></li></ul>
						</div>
					</h2>
						<div class="group01" >
	<div class="title"><!--span class="txt">연구개발시스템 공지사항</span--></div>
	
			<div class = "search_box">
				<ul>
					<li>
						<dt>작성자</dt>
						<dd >
						<div class="selectbox" style="width:100px;">  
								<label for="searchType" id="searchType_label">
									<c:if test="${paramVO.searchType == '' or paramVO.searchType == null }">선택</c:if>
									<c:if test="${paramVO.searchType != null and paramVO.searchType eq 'regUserName'}">작성자</c:if>
									<c:if test="${paramVO.searchType != null and paramVO.searchType eq 'title'}">회의목적</c:if>
								</label> 
								<select name="searchType" id="searchType">
									<option value=""<c:if test="${paramVO.searchType == '' or paramVO.searchType == null }">selected</c:if>>선택</option>
									<option value="regUserName" <c:if test="${paramVO.searchType != null and paramVO.searchType eq 'regUserName'}">selected</c:if>>작성자</option>
									<option value="title"<c:if test="${paramVO.searchType != null and paramVO.searchType eq 'title'}">selected</c:if>>회의목적</option>					
								</select>
							</div>
							<input type="text" name="searchValue" id="searchValue" style="width:180px; margin-left:5px;" value="${paramVO.searchValue}">
						</dd>
					</li>
					<li>
						<dt>표시수</dt>
						<dd >
						<div class="selectbox" style="width:100px;">  
								<label for="viewCount" id="viewCount_label">
								 	<c:choose>
								 		<c:when test="${paramVO.viewCount eq '10'}">
								 			10
								 		</c:when>
								 		<c:when test="${paramVO.viewCount eq '20'}">
								 			20
								 		</c:when>
								 		<c:when test="${paramVO.viewCount eq '50'}">
								 			50
								 		</c:when>
								 		<c:when test="${paramVO.viewCount eq '100'}">
								 			100
								 		</c:when>
								 		<c:otherwise>
								 			선택
								 		</c:otherwise>
								 	</c:choose>
								</label> 
								<select name="viewCount" id="viewCount">		
									<option value=""  <c:if test="${paramVO.viewCount == '' or paramVO.viewCount == null}">selected</c:if>>선택</option>													
									<option value="10"  <c:if test="${paramVO.viewCount != null and paramVO.viewCount eq '10'}">selected</c:if>>10</option>
									<option value="20"  <c:if test="${paramVO.viewCount != null and paramVO.viewCount eq '20'}">selected</c:if>>20</option>
									<option value="50"  <c:if test="${paramVO.viewCount != null and paramVO.viewCount eq '50'}">selected</c:if>>50</option>
									<option value="100" <c:if test="${paramVO.viewCount != null and paramVO.viewCount eq '100'}">selected</c:if>>100</option>
								</select>
							</div>
						</dd>
					</li>
				</ul>
				<div class="fr pt5 pb10">
					<button type="button" class="btn_con_search" onClick="javascript:goSearch();"><img src="/resources/images/btn_icon_search.png" style="vertical-align:middle;"/> 검색</button>
					<button type="button" class="btn_con_search" onClick="javascript:searchClear();"><img src="/resources/images/btn_icon_refresh.png" style="vertical-align:middle;"/> 검색 초기화</button>					
				</div>
			</div>
			<div class="main_tbl">
				<table class="tbl01">
					<colgroup>
					<col width="8%">
					<col width="8%">
					<col width="10%">
					<col width="10%">
					<col width="20%">
					<col width="8%">
					
					<col width="8%">
					
					<col width="15%">
					<col/>
				
					</colgroup>
					<thead>
					<tr>
					<th>예약번호</th>
					<th>예약날짜</th>
					<th>시간</th>
					<th>중요여부</th>
					<th>회의목적</th>
					<th>인원</th>
					<th>예약자명</th>
					<th>등록일</th>
					<th>&nbsp;</th>
					<tr>
					</thead>
						<tbody>	
					<c:set var="now" value="<%=new java.util.Date()%>"/> 
					<fmt:formatDate var="nowDate" value="${now}" pattern="yyyy.MM.dd"/>
				<c:choose>
					<c:when test="${not empty reserveList}">
					 <c:forEach items="${reserveList}" var="reserve">
					 	<Tr>
						<td>${reserve.rmrNo}</td>
						<fmt:formatDate var="parseRegDate" pattern="yyyy.MM.dd" value="${reserve.regDate}"/>
						<fmt:formatDate var="parseReserveDate" pattern="yyyy.MM.dd" value="${reserve.reserveDate}"/>
						<Td>${parseReserveDate}</Td>
						<Td>${reserve.startTime}- ${reserve.endTime}</Td>
						<Td>
							<c:if test="${reserve.notiYN eq 'Y'}">중요</c:if>
							<c:if test="${reserve.notiYN eq 'N'}">일반</c:if>
						</Td>
						<Td><div class="tgnl">${reserve.title}<c:if test="${nowDate <= parseRegDate}"><span class="icon_new">N</span></c:if></div></Td>
						<Td>${reserve.pn}명</Td>
						
						<Td>${reserve.regUserName}</Td>
						<Td>
						${parseRegDate}
						</Td>
						<Td >
						<ul class="list_ul">
						<li><button type="button" class="btn_doc" onclick="fileDownReserve('${reserve.rmrNo}'); return false;"><img src="/resources/images/icon_doc15.png"> 첨부파일다운로드</button></li>
							<li><button type="button" class="btn_doc" onclick="modifyPopup('${reserve.rmrNo}','modify','${timeCode}'); return false;"><img src="/resources/images/icon_doc03.png"> 수정</button></li>
							<li><button type="button" class="btn_doc" onclick="deleteReserve('${reserve.rmrNo}'); return false;"><img src="/resources/images/icon_doc04.png"> 삭제</button></li>
						</ul> 
						</Td>
						</Tr>				 
					 </c:forEach>
					</c:when>	
					<c:when test="${empty reserveList}">
						<Tr>
							<td colspan="8">'작성된 게시물이 없습니다.'</td>
						</Tr>
					</c:when>
				
				</c:choose>
					
						</tbody>
				</table>
				<c:if test="${totalCount > 0 }">
					<div class="page_navi  mt10">
						${navi.prevBlock}
						${navi.pageList}
						${navi.nextBlock}
					</div>
				</c:if>

		</div>
			<div class="btn_box_con"><button type="button" class="btn_admin_red" onClick="modifyPopup('','reserve','${timeCode}'); return false;" >회의실 예약</button></div>
			 <hr class="con_mode"/><!-- 신규 추가 꼭 데려갈것 !-->
			</div>
				</section>
		</div>
<form name="insert_meeting_form" id="insert_meeting_form" action="/Reserve/ReserveSaveAjax" method="post" enctype="multipart/form-data">
<div class="white_content" id="insert_meeting">
		<div class="modal" style="	margin-left:-250px;width:500px;height:480px;margin-top:-250px">
		  <h5 style="position:relative">
				<span class="title" id="insertPopupTitle">회의실 예약</span>
				<div  class="top_btn_box">
					<ul><li><button type="button" class="btn_madal_close"  onClick="closeDialog('insert_meeting'); return false;"></button></li></ul>
				</div>
			</h5>
			<div class="list_detail">
		<ul>
	
					<li>
			<dt>날짜</dt><dd><input type="text"style="width:110px;" class="req" value="" id="reserveDate" name="reserveDate"/></dd>
			</li>
				<li>
			<dt>시작시간</dt>

<dd><div class="selectbox req" style="width:108px;">
				<label for="startTime">---선택---</label>
						<select id="startTime" name="startTime">
							<option selected value="">---선택---</option>
					<option value = "09:00">AM 09:00</option>
					<option value = "09:30">AM 09:30</option>
					<option value = "10:00">AM 10:00</option>
					<option value = "10:30">AM 10:30</option>
					<option value = "11:00">AM 11:00</option>
					<option value = "11:30">AM 11:30</option>
					<option value = "12:00">PM 12:00</option>
					<option value = "12:30">PM 12:30</option>
					<option value = "13:00">PM 13:00</option>
					<option value = "13:30">PM 13:30</option>
					<option value = "14:00">PM 14:00</option>
					<option value = "14:30">PM 14:30</option>
					<option value = "15:00">PM 15:00</option>
					<option value = "15:30">PM 15:30</option>
					<option value = "16:00">PM 16:00</option>
					<option value = "16:30">PM 16:30</option>
					<option value = "17:00">PM 17:00</option>
					<option value = "17:30">PM 17:30</option>
					<option value = "18:00">PM 18:00</option>
						</select>
						</div>
					
</dd>
			</li>
				<li>
			<dt>종료시간</dt>

<dd><div class="selectbox req" style="width:108px;">
				<label for="endTime">---선택---</label>
						<select id="endTime" name="endTime">
							<option selected value="">---선택---</option>
					<option value = "09:00">AM 09:00</option>
					<option value = "09:30">AM 09:30</option>
					<option value = "10:00">AM 10:00</option>
					<option value = "10:30">AM 10:30</option>
					<option value = "11:00">AM 11:00</option>
					<option value = "11:30">AM 11:30</option>
					<option value = "12:00">PM 12:00</option>
					<option value = "12:30">PM 12:30</option>
					<option value = "13:00">PM 13:00</option>
					<option value = "13:30">PM 13:30</option>
					<option value = "14:00">PM 14:00</option>
					<option value = "14:30">PM 14:30</option>
					<option value = "15:00">PM 15:00</option>
					<option value = "15:30">PM 15:30</option>
					<option value = "16:00">PM 16:00</option>
					<option value = "16:30">PM 16:30</option>
					<option value = "17:00">PM 17:00</option>
					<option value = "17:30">PM 17:30</option>
					<option value = "18:00">PM 18:00</option>
						</select>
						</div>
</dd>
			</li>
			<li>
			<dt>인원</dt>

<dd><input type="text" class="req" id="pn" name="pn" style="width:50px;"> 명 
</dd>
			</li>
				<li>
			<dt>회의목적</dt>

<dd><input type="text" style="width:300px;" class="req" placeholder="연구소외 부서 회의실 예약불가" id="title" name="title"> <input type="checkbox"  id="notiYN"><label for="notiYN" style="padding-right:0px;"><span></span></label>중요
</dd>
			</li>
			<li>
			<dt>회의유형</dt>

<dd> <input type="checkbox"  id="meetingCategory"><label for="meetingCategory" style="padding-right:0px;"><span></span></label>세미나/외부강의
</dd>
			</li>
<!--  			<li>
			<dt>회의실</dt>

<dd><div class="selectbox req" style="width:108px;">
				<label for="reserveRoomCode">---선택---</label>
						<select id="reserveRoomCode" name="reserveRoomCode">
							<option selected value="">---선택---</option>
					<option value = "V">비전룸</option>
					<option value = "Y">열정룸</option>
					<option value = "G">가치룸</option>
					<option value = "S">신뢰룸</option>
						</select>
						</div>
</dd>
			</li>  -->
			<li class="mt5">
			<dt>첨부파일</dt>
<!-- 첨부파일 최대 3개까지 -->
<dd><!-- 첨부파일이 하나도 없을때는 add_file2 / 하나라도 생성되면 add_file 로 클래스명 교체해주세요-->
			<div class="add_file2" id="add_file2" style="width:97.5%">
				<span class="file_load" id="fileSpan1">
						<input type="file" name="files" id="file1"  value="" onChange="javaScript:addFile(tmpNo)" style="display:none"><label for="file1">첨부파일 등록 <img src="/resources/images/icon_add_file.png"></label>
				</span>
				<span id="upFile"></span>
			</div>
			<!--  첨부된 파일리스트 start 첨부된 파일이 없을 경우 안보이게 해주세요 -->

					<div id="fileList" class="file_box_pop" style=" height:59px; width:97.5%; border-top-left-radius:0px;border-top-right-radius:0px; border-top:1px solid #ddd;box-sizing:border-box;" >
							<ul id="fileData">
									<!-- <li> <a href="11.html"><img src="/resources/images/icon_del_file.png"></a> asdfkasdflkj;a동그라미 첨부파일 .png </li>
									<li> <a href="11.html"><img src="/resources/images/icon_del_file.png"></a> asdfk그라미 첨부파일 .png</li>
									<li> <a href="11.html"><img src="/resources/images/icon_del_file.png"></a> asdfkasdflkj;a동그라미 첨부파일 .png </li>
									<li> <a href="11.html"> <img src="/resources/images/icon_del_file.png"></a> asdfkasdflkj;a동그라미 첨부파일 .png </li>
									<li> <a href="11.html"> <img src="/resources/images/icon_del_file.png"></a> asdfk그라미 첨부파일 .png</li>
									<li> <a href="11.html"> <img src="/resources/images/icon_del_file.png"></a> asdfkasdflkj;a동그라미 첨부파일 .png </li>
									<li> <a href="11.html"> <img src="/resources/images/icon_del_file.png"></a> asdfkasdflkj;a동그라미 첨부파일 .png </li>
									<li> <a href="11.html"> <img src="/resources/images/icon_del_file.png"></a> asdfk그라미 첨부파일 .png</li> -->
							</ul>
					</div>
					<!--  첨부된 파일리스트 close 첨부된 파일이 없을 경우 안보이게 해주세요 -->
</dd>
			</li>
		</ul>
	</div>
			<div class="btn_box_con4" style="padding:15px 0 20px 0"><button type="button" class="btn_admin_red" onclick="reserveBtn(); return false;" id="reserveModifyBtn">예약</button> <button class="btn_admin_gray" onClick="closeDialog('insert_meeting'); return false;">닫기</button></div>
</div>
		<input type="hidden" id="fileDelete" name="fileDelete"/>
		<input type="hidden" id="reserveDayCode" name="reserveDayCode"/>
		<input type="hidden" id="modifyRmrNo" name="modifyRmrNo" />
		<input type="hidden" id="notiYNval" name="notiYNval"/>
		<input type="hidden" id="gubun" name="gubun"/>
		<input type="hidden" id="timeCode" name="timeCode"/>
		<input type="hidden" id="isPast" name="isPast" />
		<input type="hidden" id="meetingCategoryVal" name="meetingCategoryVal"/>
		<input type="hidden" id="pageNo_1" name="pageNo_1" value="${paramVO.pageNo}"/>
		<input type="hidden" id="searchType_1" name="searchType_1" value="${paramVO.searchType}"/>
		<input type="hidden" id="searchValue_1" name="searchValue_1" value="${paramVO.searchValue}"/>
		<input type="hidden" id="viewCount_1" name="viewCount_1" value="${paramVO.viewCount}"/>
</div>
</form>
<div class="white_content" id="insert_meeting_view">
		<div class="modal" style="	margin-left:-250px;width:500px;height:420px;margin-top:-210px">
		  <h5 style="position:relative">
				<span class="title">회의실 예약내역</span>
				<div  class="top_btn_box">
					<ul><li><button class="btn_madal_close"  onClick="closeDialog('insert_meeting_view')"></button></li></ul>
				</div>
			</h5>
			<div class="list_detail">
		<ul>
		<li id="detailDate"><dt>날짜</dt><dd>2019.01.12</dd></li>
		<li id="detailStartTime"><dt>시작시간</dt><dd>AM 09:00</dd></li>
		<li id="detailEndTime"><dt>종료시간</dt><dd>AM 09:30</dd></li>
		<li id="detailPn"><dt>인원</dt><dd>3명</dd></li>
		<li id="detailTitle"><dt>회의목적</dt><dd><strong>[중요]</strong>마켓컬리 MD초청 상품 제안 품평회</dd></li>
		<li id="detailMeetingCategory"><dt>회의유형</dt><dd>세미나/외부강의</dd></li>
				
				<li><dt>첨부파일</dt><dd>
	
												<ul class="meeting_file_list" id="fileListUl">
												<!-- 	<li><a href="#">실적 파일 다운로드</a></li>
													<li><a href="#">d20193년 세미나 자료 첨부</a></li>
													<li><a href="#">d20193년 세미나 자료 첨부</a></li> -->

												</ul>
</dd>
			</li>
		</ul>
	</div>
			<div class="btn_box_con" style="padding:15px 0 20px 0"> <button type="button" class="btn_admin_gray" onClick="closeDialog('insert_meeting_view')">닫기</button></div>
</div>
</div>

 