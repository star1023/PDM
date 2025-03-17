<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page session="false" %>
<script type="text/javascript" src="../resources/js/reservemeeting.js"></script>
<title>메인_회의실</title>
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
			
			$("#reserveDayCode").val(today);
		},
	})
	
	$("#displayDateInput").datepicker({
		dateFormat: 'yy-mm-dd',
		minDate :0,
		buttonImage: '/resources/images/btn_calendar.png',
		buttonImageOnly: true,
		showOn: 'button',
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
			
			var week = new Array('일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일');
			var reserveRoomCode = $("#roomUL li.select").attr("id");
			
			var today = new Date(dateText).getDay();
			var todayLabel = week[today];
			
			location.href = "/main/meeting?selectDay="+dateText+"&reserveCode="+reserveRoomCode;
		},
	})
	
	$('.ui-datepicker-trigger').css('margin-left', '8px');
	$('.ui-datepicker-trigger').css('margin-top', '-5px');
	$('.ui-datepicker-trigger').css('cursor', 'pointer');
	
	fileListCheck();
	
	
});


function fileListCheck() {
	var nodes=$("#fileData").children();
	if( nodes.length > 0 ) {
		$("#add_file2").prop("class","add_file");
		$("#fileList").show();
	} else {
		$("#add_file2").prop("class","add_file2");
		$("#fileList").hide();
	}
}

function reserveRoom(obj){
	
	var reserveRoomCode = $("#roomUL li.select").attr("id");
	
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
	
	var st = $("#reserveDate").val()+" "+$("#startTime").val()+":00";
	
	var ed = $("#reserveDate").val()+" "+$("#endTime").val()+":00";
	
	var startDate = new Date(st);
	
	var endDate = new Date(ed);
	
	var min = (endDate.getTime()-startDate.getTime())/60000;
	
	if(min > 120){
		alert("최대 2시간 예약 가능합니다.");
		return false;
	}
	
	if(startTime == endTime){
		alert("시작시간과 종료시간이 같습니다.");
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
	
	$("#notiYNval").val(notiYN);
	$("#reserveRoomCode").val(reserveRoomCode);
	
	if(confirm("등록하시겠습니까?")){
		$.ajax({
			type:"POST",
			url:"/Reserve/ReserveCount",
			data:{
				  "reserveDate":$("#reserveDate").val(),
				  "startTime":$("#startTime").val(),
				  "endTime":$("#endTime").val(),
				  "reserveCode" : reserveRoomCode
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
	
	
}

function selectMeetingRoom(obj){
	var obj = $(obj);

	var id = obj.attr("id");
	
	if(obj.attr("class") != "select"){
		
		$("#roomUL a li").each(function(){
			
			if($(this).attr("class") == "select"){
				$(this).attr("class","");
			}
			
		});
		
		obj.attr("class","select");
		
	}
	
	location.href = "/main/meeting?reserveCode="+id;
	
}

function preWeek(monday){
	
	var reserveRoomCode = $("#roomUL li.select").attr("id");
	
	location.href = "/main/meeting?selectDay="+monday+"&weekParam=P&reserveCode="+reserveRoomCode;
}

function nextWeek(monday){
	
	var reserveRoomCode = $("#roomUL li.select").attr("id");
	
	location.href = "/main/meeting?selectDay="+monday+"&weekParam=N&reserveCode="+reserveRoomCode;
}

function deleteReserveRoom(rmrNo,userId){
	
	 if(confirm("삭제하시겠습니까?")){
		$.ajax({
			type:"POST",
			url:"/Reserve/ReserveDelete",
			data:{
				  "nNo":rmrNo,
				  "userId":userId,
				  "tbType":"reserve"
			},
			dataType:"json",
			success:function(data){
				if(data.result == 'S'){
					alert("해당 예약이 삭제 되었습니다.");
					location.href = "/main/meeting";
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

 function goDetailView(id,rmrNo){
	 
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
					
					$("#modifyReserveBtn").attr("onclick","test("+data.detailReserve.rmrNo+"); return false;");
					
					$("#fileListUl").empty();
					
					if(data.fileList.length > 0){
						
						var html = "";
						
						for(var i=0 ; i<data.fileList.length; i++){

								html = "<li><a href='/file/fileDownload?fmNo="+data.fileList[i].fmNo+"&tbkey="+data.fileList[i].tbKey+"&tbType=reserve'>"+data.fileList[i].orgFileName+"</a></li>";
								$("#fileListUl").append(html);
						}
						
					}
					
					openDialog(id);					
				}else {
					alert("오류가 발생하였습니다.");
				}
			},
			error:function(request, status, errorThrown){
				alert("오류가 발생하였습니다.");
			}
	 });
	
	
}
 
 function test(rmrNo){
	 alert(rmrNo);
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
	$("#fileData").append(html);
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

function goMoreList(){
	location.href = "/Reserve/ReserveList";
}

</script>
<div class="wrap_in" id="fixNextTag">
	<span class="path">문서이관&nbsp;&nbsp;
		<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;
		<a href="#">삼립식품 연구개발시스템</a>
	</span>
	<section class="type01">
				<h2 style="position:relative"><span class="title_s">System main</span>
	<span class="title">삼립 식품연구소</span>

	</h2>
		<div class="group01" >
		<!-- 작성 버튼 눌렀을때는 날짜에 당일날짜 기본값-->
		<!-- 더보기 버튼은 상세보기 게시판형으로 링크 연결 -->
		<div class="fr pb10"><button class="btn_circle_red" onClick="openReserve('insert_meeting','${timeCode}','${today}')"> &nbsp;</button>&nbsp;<button class="btn_circle_nomal_more" onClick="goMoreList(); return false;">&nbsp;</button>
					</div>
					<div class="title7"><span class="txt">회의실 예약</span></div>
					<div class="tab03">
				<ul id="roomUL">
					<!-- 선택됬을경우는 탭 클래스에 select를 넣어주세요 -->
					<!-- 회의실이 하나밖에 없을경우는 ul은 그대로 두고 a 링크부터 li 포함한 부분 안보이게 처리 여기부터  -->
					<a href="#"><li <c:if test="${reserveCode eq 'V'}">class="select"</c:if> onclick="selectMeetingRoom(this)" id="V">비전룸</li></a>
					<a href="#"><li <c:if test="${reserveCode eq 'Y'}">class="select"</c:if>  onclick="selectMeetingRoom(this)" id="Y">열정룸</li></a>
					<a href="#"><li <c:if test="${reserveCode eq 'G'}">class="select"</c:if>  onclick="selectMeetingRoom(this)" id="G">가치룸</li></a>
					<a href="#"><li <c:if test="${reserveCode eq 'S'}">class="select"</c:if> onclick="selectMeetingRoom(this)" id="S">신뢰룸</li></a>
					
					<!-- 회의실이 하나밖에 없을경우는 ul은 그대로 두고 a 링크부터 li 포함한 부분 안보이게 처리 여기까지  -->
				</ul>
				</div>
				<fmt:parseDate value="${today}" pattern="yyyy-MM-dd" var="todayFormat"/>
		<fmt:parseDate value="${monday}" pattern="yyyy-MM-dd" var="mondayFormat"/>
		<fmt:parseDate value="${tuesday}" pattern="yyyy-MM-dd" var="tuesdayFormat"/>
		<fmt:parseDate value="${wednesday}" pattern="yyyy-MM-dd" var="wednesdayFormat"/>
		<fmt:parseDate value="${thursday}" pattern="yyyy-MM-dd" var="thursdayFormat"/>
		<fmt:parseDate value="${friday}" pattern="yyyy-MM-dd" var="fridayFormat"/>
		
		<fmt:formatDate value="${todayFormat}" pattern="yyyyMMdd" var="todayDate"/>
		<fmt:formatDate value="${mondayFormat}" pattern="yyyyMMdd" var="mondayDate"/>
		<fmt:formatDate value="${tuesdayFormat}" pattern="yyyyMMdd" var="tuesdayDate"/>
		<fmt:formatDate value="${wednesdayFormat}" pattern="yyyyMMdd" var="wednesdayDate"/>
		<fmt:formatDate value="${thursdayFormat}" pattern="yyyyMMdd" var="thursdayDate"/>
		<fmt:formatDate value="${fridayFormat}" pattern="yyyyMMdd" var="fridayDate"/>
		
	<div class="re_meeting" >
		<div class="cal_header">
		<!-- 이미 지난 날짜일경우 아래 버튼 클래스에 비활성화 클래스 nouse (연한회색처리됨)를 넣어줍니다.--> 
		
		
				
		<c:if test="${mondayDate <= todayDate}">
			<button class="btn_cal_pre nouse">&lt;</button>
		</c:if>		
		<c:if test="${mondayDate > todayDate}">
			<button class="btn_cal_pre" onclick="preWeek('${monday}'); return false;">&lt;</button>
		</c:if>
		<!-- 캘린더 아이콘 클릭시 먼날짜 이동 -->
		<span style="display:block; width:100%; text-align:center; height:80px;"><strong id="displayDateStrong">${selectDay}</strong><input id="displayDateInput" type="hidden"/><br/>
			${monday} ~ ${friday}</span>
			<!-- 버튼 클릭시 일주일 단위로 전환 -->
		<button class="btn_cal_next" onclick="nextWeek('${monday}'); return false;">&gt;</button>
		</div>
		<table class="tbl_meeting">
		<colgroup>
		<col width="15%">
		<col width="17%">
		<col width="17%">
		<col width="17%">
		<col width="17%">
		<col width="17%">
		</colgroup>
		
		<thead>
		<tr>
		<th>시간</th>
		<!-- 오늘 표시는 class 명에 today 삽입 -->
		<th <c:if test="${today == monday}">class="today"</c:if>>${monday} 월요일</th>
		<th <c:if test="${today == tuesday}">class="today"</c:if>>${tuesday} 화요일</th>
		<th <c:if test="${today == wednesday}">class="today"</c:if>>${wednesday} 수요일</th>
		<th <c:if test="${today == thursday}">class="today"</c:if>>${thursday} 목요일</th>
		<th <c:if test="${today == friday}">class="today"</c:if>>${friday} 금요일</th>
		</tr>
		</thead>
			
		<tbody>
		<tr>
		<th <c:if test="${timeCode == 1}">class="now"</c:if>>09:00~09:30 (AM)</th>
		<c:if test="${not empty reserveListDay1}">
			<c:forEach items="${reserveListDay1}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 0}">
			 	 	
			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>
			 	 
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${monday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${monday == today}">class="today"</c:if>>
			 	 	 		
			 	 	 			<c:if test="${timeCode <= 1 && (mondayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','1','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','1','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay1}">
			<td <c:if test="${monday == today}">class="today"</c:if>>
						<c:if test="${timeCode <= 1 && (mondayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','1','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','1','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay2}">
			<c:forEach items="${reserveListDay2}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 0}">
			 	 
			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>
			 	 
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${tuesday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${tuesday == today}">class="today"</c:if>>
								<c:if test="${timeCode <= 1 && (tuesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','1','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','1','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay2}">
			<td <c:if test="${tuesday == today}">class="today"</c:if>>
					<c:if test="${timeCode <= 1 && (tuesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','1','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','1','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay3}">
			<c:forEach items="${reserveListDay3}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 0}">
			 	 
			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>
			 	 
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${wednesday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${wednesday == today}">class="today"</c:if>>
								<c:if test="${timeCode <= 1 && (wednesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','1','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','1','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay3}">
			<td <c:if test="${wednesday == today}">class="today"</c:if>>
					<c:if test="${timeCode <= 1 && (wednesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','1','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','1','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay4}">
			<c:forEach items="${reserveListDay4}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 0}">
			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${thursday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${thursday == today}">class="today"</c:if>>
								<c:if test="${timeCode <= 1 && (thursdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','1','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','1','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay4}">
			<td <c:if test="${thursday == today}">class="today"</c:if>>
					<c:if test="${timeCode <= 1 && (thursdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','1','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','1','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay5}">
			<c:forEach items="${reserveListDay5}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 0}">
			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${friday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${friday == today}">class="today"</c:if>>
								<c:if test="${timeCode <= 1 && (fridayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','1','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','1','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay5}">
			<td <c:if test="${friday == today}">class="today"</c:if>>
				<c:if test="${timeCode <= 1 && (fridayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','1','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','1','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		</tr>
		
		<tr>
		<th <c:if test="${timeCode == 2}">class="now"</c:if>>09:30~10:00 (AM)</th>
		<c:if test="${not empty reserveListDay1}">
			<c:forEach items="${reserveListDay1}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 1}">
			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>		 	 
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${monday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${monday == today}">class="today"</c:if>>
								<c:if test="${timeCode <= 2 && (mondayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','2','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','2','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay1}">
			<td <c:if test="${monday == today}">class="today"</c:if>>
					<c:if test="${timeCode <= 2 && (mondayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','2','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','2','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay2}">
			<c:forEach items="${reserveListDay2}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 1}">
			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${tuesday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${tuesday == today}">class="today"</c:if>>
								<c:if test="${timeCode <= 2 && (tuesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','2','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','2','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay2}">
			<td <c:if test="${tuesday == today}">class="today"</c:if>>
			<c:if test="${timeCode <= 2 && (tuesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','2','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','2','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay3}">
			<c:forEach items="${reserveListDay3}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 1}">
			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${wednesday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${wednesday == today}">class="today"</c:if>>
								<c:if test="${timeCode <= 2 && (wednesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','2','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','2','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay3}">
			<td <c:if test="${wednesday == today}">class="today"</c:if>>
					<c:if test="${timeCode <= 2 && (wednesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','2','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','2','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay4}">
			<c:forEach items="${reserveListDay4}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 1}">
			 	 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${thursday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${thursday == today}">class="today"</c:if>>
								<c:if test="${timeCode <= 2 && (thursdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','2','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','2','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay4}">
			<td <c:if test="${thursday == today}">class="today"</c:if>>
					<c:if test="${timeCode <= 2 && (thursdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','2','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','2','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay5}">
			<c:forEach items="${reserveListDay5}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 1}">
			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${friday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${friday == today}">class="today"</c:if>>
								<c:if test="${timeCode <= 2 && (fridayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','2','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','2','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay5}">
			<td <c:if test="${friday == today}">class="today"</c:if>>
					<c:if test="${timeCode <= 2 && (fridayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','2','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','2','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		</tr>
		<tr>
		<th <c:if test="${timeCode == 3}">class="now"</c:if>>10:00~10:30 (AM)</th>
		<c:if test="${not empty reserveListDay1}">
			<c:forEach items="${reserveListDay1}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 2}">
			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${monday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${monday == today}">class="today"</c:if>>
								<c:if test="${timeCode <= 3 && (mondayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','3','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','3','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay1}">
			<td <c:if test="${monday == today}">class="today"</c:if>>
						<c:if test="${timeCode <= 3 && (mondayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','3','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','3','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay2}">
			<c:forEach items="${reserveListDay2}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 2}">
			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${tuesday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${tuesday == today}">class="today"</c:if>>
									<c:if test="${timeCode <= 3 && (tuesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','3','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','3','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay2}">
			<td <c:if test="${tuesday == today}">class="today"</c:if>>
					<c:if test="${timeCode <= 3 && (tuesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','3','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','3','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay3}">
			<c:forEach items="${reserveListDay3}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 2}">
			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${wednesday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${wednesday == today}">class="today"</c:if>>
								<c:if test="${timeCode <= 3 && (wednesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','3','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','3','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay3}">
			<td <c:if test="${wednesday == today}">class="today"</c:if>>
					<c:if test="${timeCode <= 3 && (wednesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','3','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','3','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay4}">
			<c:forEach items="${reserveListDay4}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 2}">
			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${thursday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${thursday == today}">class="today"</c:if>>
								<c:if test="${timeCode <= 3 && (thursdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','3','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','3','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay4}">
			<td <c:if test="${thursday == today}">class="today"</c:if>>
						<c:if test="${timeCode <= 3 && (thursdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','3','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','3','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay5}">
			<c:forEach items="${reserveListDay5}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 2}">
			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${friday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${friday == today}">class="today"</c:if>>
									<c:if test="${timeCode <= 3 && (fridayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','3','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','3','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay5}">
			<td <c:if test="${friday == today}">class="today"</c:if>>
					<c:if test="${timeCode <= 3 && (fridayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','3','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','3','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		</tr>
		<tr>
			<th <c:if test="${timeCode == 4}">class="now"</c:if>>10:30~11:00 (AM)</th>
			<c:if test="${not empty reserveListDay1}">
			<c:forEach items="${reserveListDay1}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 3}">
			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${monday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${monday == today}">class="today"</c:if>>
								<c:if test="${timeCode <= 4 && (mondayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','4','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','4','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay1}">
			<td <c:if test="${monday == today}">class="today"</c:if>>
					<c:if test="${timeCode <= 4 && (mondayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','4','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','4','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay2}">
			<c:forEach items="${reserveListDay2}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 3}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${tuesday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${tuesday == today}">class="today"</c:if>>
								<c:if test="${timeCode <= 4 && (tuesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','4','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','4','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay2}">
			<td <c:if test="${tuesday == today}">class="today"</c:if>>
					<c:if test="${timeCode <= 4 && (tuesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','4','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','4','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay3}">
			<c:forEach items="${reserveListDay3}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 3}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${wednesday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${wednesday == today}">class="today"</c:if>>
								<c:if test="${timeCode <= 4 && (wednesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','4','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','4','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay3}">
			<td <c:if test="${wednesday == today}">class="today"</c:if>>
					<c:if test="${timeCode <= 4 && (wednesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','4','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','4','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay4}">
			<c:forEach items="${reserveListDay4}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 3}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${thursday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${thursday == today}">class="today"</c:if>>
								<c:if test="${timeCode <= 4 && (thursdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','4','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','4','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay4}">
			<td <c:if test="${thursday == today}">class="today"</c:if>>
					<c:if test="${timeCode <= 4 && (thursdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','4','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','4','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay5}">
			<c:forEach items="${reserveListDay5}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 3}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${friday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${friday == today}">class="today"</c:if>>
								<c:if test="${timeCode <= 4 && (fridayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','4','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','4','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay5}">
			<td <c:if test="${friday == today}">class="today"</c:if>>
					<c:if test="${timeCode <= 4 && (fridayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','4','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','4','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		</tr>
		<tr>
		<th <c:if test="${timeCode == 5}">class="now"</c:if>>11:00~11:30 (AM)</th>
			<c:if test="${not empty reserveListDay1}">
			<c:forEach items="${reserveListDay1}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 4}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${monday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${monday == today}">class="today"</c:if>>
								<c:if test="${timeCode <= 5 && (mondayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','5','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','5','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay1}">
			<td <c:if test="${monday == today}">class="today"</c:if>>
					<c:if test="${timeCode <= 5 && (mondayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','5','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','5','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay2}">
			<c:forEach items="${reserveListDay2}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 4}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${tuesday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${tuesday == today}">class="today"</c:if>>
									<c:if test="${timeCode <= 5 && (tuesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','5','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','5','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay2}">
			<td <c:if test="${tuesday == today}">class="today"</c:if>>
							<c:if test="${timeCode <= 5 && (tuesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','5','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','5','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay3}">
			<c:forEach items="${reserveListDay3}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 4}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${wednesday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${wednesday == today}">class="today"</c:if>>
										<c:if test="${timeCode <= 5 && (wednesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','5','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','5','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay3}">
			<td <c:if test="${wednesday == today}">class="today"</c:if>>
						<c:if test="${timeCode <= 5 && (wednesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','5','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','5','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay4}">
			<c:forEach items="${reserveListDay4}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 4}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${thursday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${thursday == today}">class="today"</c:if>>
									<c:if test="${timeCode <= 5 && (thursdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','5','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','5','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay4}">
			<td <c:if test="${thursday == today}">class="today"</c:if>>
						<c:if test="${timeCode <= 5 && (thursdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','5','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','5','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay5}">
			<c:forEach items="${reserveListDay5}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 4}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${friday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${friday == today}">class="today"</c:if>>
									<c:if test="${timeCode <= 5 && (fridayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','5','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','5','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay5}">
			<td <c:if test="${friday == today}">class="today"</c:if>>
						<c:if test="${timeCode <= 5 && (fridayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','5','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','5','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		</tr>
		<tr>
		<th <c:if test="${timeCode == 6}">class="now"</c:if>>11:30~12:00 (AM)</th>
 			<c:if test="${not empty reserveListDay1}">
			<c:forEach items="${reserveListDay1}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 5}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${monday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${monday == today}">class="today"</c:if>>
					<c:if test="${timeCode <= 6 && (mondayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','6','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','6','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay1}">
			<td <c:if test="${monday == today}">class="today"</c:if>>
							<c:if test="${timeCode <= 6 && (mondayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','6','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','6','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay2}">
			<c:forEach items="${reserveListDay2}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 5}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${tuesday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${tuesday == today}">class="today"</c:if>>
										<c:if test="${timeCode <= 6 && (tuesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','6','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','6','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay2}">
			<td <c:if test="${tuesday == today}">class="today"</c:if>>
						<c:if test="${timeCode <= 6 && (tuesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','6','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','6','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay3}">
			<c:forEach items="${reserveListDay3}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 5}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${wednesday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${wednesday == today}">class="today"</c:if>>
									<c:if test="${timeCode <= 6 && (wednesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','6','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','6','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay3}">
			<td <c:if test="${wednesday == today}">class="today"</c:if>>
					<c:if test="${timeCode <= 6 && (wednesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','6','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','6','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay4}">
			<c:forEach items="${reserveListDay4}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 5}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${thursday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${thursday == today}">class="today"</c:if>>
									<c:if test="${timeCode <= 6 && (thursdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','6','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','6','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay4}">
			<td <c:if test="${thursday == today}">class="today"</c:if>>
						<c:if test="${timeCode <= 6 && (thursdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','6','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','6','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay5}">
			<c:forEach items="${reserveListDay5}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 5}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${friday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${friday == today}">class="today"</c:if>>
									<c:if test="${timeCode <= 6 && (fridayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','6','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','6','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay5}">
			<td <c:if test="${friday == today}">class="today"</c:if>>
						<c:if test="${timeCode <= 6 && (fridayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','6','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','6','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		</tr>
		<tr>
		<th <c:if test="${timeCode == 7}">class="now"</c:if>>12:00~12:30 (PM)</th>
			<c:if test="${not empty reserveListDay1}">
			<c:forEach items="${reserveListDay1}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 6}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${monday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${monday == today}">class="today"</c:if>>
									<c:if test="${timeCode <= 7 && (mondayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','7','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','7','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay1}">
			<td <c:if test="${monday == today}">class="today"</c:if>>
						<c:if test="${timeCode <= 7 && (mondayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','7','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','7','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay2}">
			<c:forEach items="${reserveListDay2}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 6}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${tuesday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${tuesday == today}">class="today"</c:if>>
			<c:if test="${timeCode <= 7 && (tuesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','7','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','7','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay2}">
			<td <c:if test="${tuesday == today}">class="today"</c:if>>
				<c:if test="${timeCode <= 7 && (tuesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','7','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','7','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay3}">
			<c:forEach items="${reserveListDay3}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 6}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${wednesday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${wednesday == today}">class="today"</c:if>>
								<c:if test="${timeCode <= 7 && (wednesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','7','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','7','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay3}">
			<td <c:if test="${wednesday == today}">class="today"</c:if>>
					<c:if test="${timeCode <= 7 && (wednesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','7','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','7','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay4}">
			<c:forEach items="${reserveListDay4}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 6}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${thursday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${thursday == today}">class="today"</c:if>>
								<c:if test="${timeCode <= 7 && (thursdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','7','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','7','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay4}">
			<td <c:if test="${thursday == today}">class="today"</c:if>>
				<c:if test="${timeCode <= 7 && (thursdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','7','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','7','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay5}">
			<c:forEach items="${reserveListDay5}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 6}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${friday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${friday == today}">class="today"</c:if>>
								<c:if test="${timeCode <= 7 && (fridayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','7','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','7','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay5}">
			<td <c:if test="${friday == today}">class="today"</c:if>>
					<c:if test="${timeCode <= 7 && (fridayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','7','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','7','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		</tr>
		<tr>
		<th <c:if test="${timeCode == 8 }">class="now"</c:if>>12:30~13:00 (PM)</th>
 			<c:if test="${not empty reserveListDay1}">
			<c:forEach items="${reserveListDay1}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 7}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${monday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${monday == today}">class="today"</c:if>>
								<c:if test="${timeCode <= 8 && (mondayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','8','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','8','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay1}">
			<td <c:if test="${monday == today}">class="today"</c:if>>
					<c:if test="${timeCode <= 8 && (mondayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','8','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','8','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay2}">
			<c:forEach items="${reserveListDay2}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 7}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${tuesday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${tuesday == today}">class="today"</c:if>>
								<c:if test="${timeCode <= 8 && (tuesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','8','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','8','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay2}">
			<td <c:if test="${tuesday == today}">class="today"</c:if>>
					<c:if test="${timeCode <= 8 && (tuesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','8','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','8','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay3}">
			<c:forEach items="${reserveListDay3}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 7}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${wednesday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${wednesday == today}">class="today"</c:if>>
							<c:if test="${timeCode <= 8 && (wednesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','8','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','8','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay3}">
			<td <c:if test="${wednesday == today}">class="today"</c:if>>
						<c:if test="${timeCode <= 8 && (wednesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','8','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','8','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay4}">
			<c:forEach items="${reserveListDay4}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 7}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${thursday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${thursday == today}">class="today"</c:if>>
									<c:if test="${timeCode <= 8 && (thursdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','8','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','8','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay4}">
			<td <c:if test="${thursday == today}">class="today"</c:if>>
					<c:if test="${timeCode <= 8 && (thursdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','8','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','8','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay5}">
			<c:forEach items="${reserveListDay5}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 7}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${friday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${friday == today}">class="today"</c:if>>
								<c:if test="${timeCode <= 8 && (fridayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','8','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','8','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay5}">
			<td <c:if test="${friday == today}">class="today"</c:if>>
					<c:if test="${timeCode <= 8 && (fridayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','8','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','8','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		</tr> 
		<tr>
  		<th <c:if test="${timeCode == 9}">class="now"</c:if>>13:00~13:30 (PM)</th>
		<c:if test="${not empty reserveListDay1}">
			<c:forEach items="${reserveListDay1}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 8}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${monday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${monday == today}">class="today"</c:if>>
								<c:if test="${timeCode <= 9 && (mondayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','9','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','9','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay1}">
			<td <c:if test="${monday == today}">class="today"</c:if>>
					<c:if test="${timeCode <= 9 && (mondayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','9','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','9','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay2}">
			<c:forEach items="${reserveListDay2}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 8}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${tuesday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${tuesday == today}">class="today"</c:if>>
								<c:if test="${timeCode <= 9 && (tuesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','9','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','9','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay2}">
			<td <c:if test="${tuesday == today}">class="today"</c:if>>
					<c:if test="${timeCode <= 9 && (tuesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','9','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','9','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay3}">
			<c:forEach items="${reserveListDay3}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 8}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${wednesday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${wednesday == today}">class="today"</c:if>>
							<c:if test="${timeCode <= 9 && (wednesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','9','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','9','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay3}">
			<td <c:if test="${wednesday == today}">class="today"</c:if>>
					<c:if test="${timeCode <= 9 && (wednesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','9','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','9','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay4}">
			<c:forEach items="${reserveListDay4}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 8}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${thursday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${thursday == today}">class="today"</c:if>>
								<c:if test="${timeCode <= 9 && (thursdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','9','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','9','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay4}">
			<td <c:if test="${thursday == today}">class="today"</c:if>>
								<c:if test="${timeCode <= 9 && (thursdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','9','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','9','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate < todayDate}"></c:if>
							</td>
		</c:if>	
		<c:if test="${not empty reserveListDay5}">
			<c:forEach items="${reserveListDay5}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 8}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${friday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${friday == today}">class="today"</c:if>>
								<c:if test="${timeCode <= 9 && (fridayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','9','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','9','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay5}">
			<td <c:if test="${friday == today}">class="today"</c:if>>
					<c:if test="${timeCode <= 9 && (fridayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','9','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','9','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		</tr>
		<tr>
		<th <c:if test="${timeCode == 10}">class="now"</c:if>>13:30~14:00 (PM)</th>
			<c:if test="${not empty reserveListDay1}">
			<c:forEach items="${reserveListDay1}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 9}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${monday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${monday == today}">class="today"</c:if>>
								<c:if test="${timeCode <= 10 && (mondayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','10','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','10','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay1}">
			<td <c:if test="${monday == today}">class="today"</c:if>>
					<c:if test="${timeCode <= 10 && (mondayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','10','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','10','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay2}">
			<c:forEach items="${reserveListDay2}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 9}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${tuesday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${tuesday == today}">class="today"</c:if>>
								<c:if test="${timeCode <= 10 && (tuesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','10','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','10','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay2}">
			<td <c:if test="${tuesday == today}">class="today"</c:if>>
				<c:if test="${timeCode <= 10 && (tuesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','10','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','10','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay3}">
			<c:forEach items="${reserveListDay3}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 9}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${wednesday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${wednesday == today}">class="today"</c:if>>
								<c:if test="${timeCode <= 10 && (wednesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','10','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','10','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay3}">
			<td <c:if test="${wednesday == today}">class="today"</c:if>>
				<c:if test="${timeCode <= 10 && (wednesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','10','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','10','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay4}">
			<c:forEach items="${reserveListDay4}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 9}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${thursday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${thursday == today}">class="today"</c:if>>
								<c:if test="${timeCode <= 10 && (thursdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','10','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','10','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay4}">
			<td <c:if test="${thursday == today}">class="today"</c:if>>
						<c:if test="${timeCode <= 10 && (thursdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','10','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','10','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay5}">
			<c:forEach items="${reserveListDay5}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 9}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${friday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${friday == today}">class="today"</c:if>>
								<c:if test="${timeCode <= 10 && (fridayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','10','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','10','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay5}">
			<td <c:if test="${friday == today}">class="today"</c:if>>
					<c:if test="${timeCode <= 10 && (fridayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','10','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','10','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		</tr>
		<tr>
		<th <c:if test="${timeCode == 11}">class="now"</c:if>>14:00~14:30 (PM)</th>
		<c:if test="${not empty reserveListDay1}">
			<c:forEach items="${reserveListDay1}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 10}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${monday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${monday == today}">class="today"</c:if>>
							<c:if test="${timeCode <= 11 && (mondayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','11','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','11','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay1}">
			<td <c:if test="${monday == today}">class="today"</c:if>>
				<c:if test="${timeCode <= 11 && (mondayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','11','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','11','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay2}">
			<c:forEach items="${reserveListDay2}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 10}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${tuesday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${tuesday == today}">class="today"</c:if>>
	<c:if test="${timeCode <= 11 && (tuesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','11','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','11','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay2}">
			<td <c:if test="${tuesday == today}">class="today"</c:if>>
					<c:if test="${timeCode <= 11 && (tuesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','11','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','11','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay3}">
			<c:forEach items="${reserveListDay3}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 10}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${wednesday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${wednesday == today}">class="today"</c:if>>
								<c:if test="${timeCode <= 11 && (wednesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','11','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','11','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay3}">
			<td <c:if test="${wednesday == today}">class="today"</c:if>>
					<c:if test="${timeCode <= 11 && (wednesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','11','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','11','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay4}">
			<c:forEach items="${reserveListDay4}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 10}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${thursday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${thursday == today}">class="today"</c:if>>
								<c:if test="${timeCode <= 11 && (thursdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','11','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','11','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay4}">
			<td <c:if test="${thursday == today}">class="today"</c:if>>
					<c:if test="${timeCode <= 11 && (thursdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','11','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','11','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay5}">
			<c:forEach items="${reserveListDay5}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 10}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${friday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${friday == today}">class="today"</c:if>>
								<c:if test="${timeCode <= 11 && (fridayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','11','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','11','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay5}">
			<td <c:if test="${friday == today}">class="today"</c:if>>
					<c:if test="${timeCode <= 11 && (fridayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','11','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','11','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		</tr>
		<tr>
		<th <c:if test="${timeCode == 12}">class="now"</c:if>>14:30~15:00 (PM)</th>
		<c:if test="${not empty reserveListDay1}">
			<c:forEach items="${reserveListDay1}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 11}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${monday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${monday == today}">class="today"</c:if>>
								<c:if test="${timeCode <= 12 && (mondayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','12','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','12','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay1}">
			<td <c:if test="${monday == today}">class="today"</c:if>>
					<c:if test="${timeCode <= 12 && (mondayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','12','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','12','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay2}">
			<c:forEach items="${reserveListDay2}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 11}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${tuesday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${tuesday == today}">class="today"</c:if>>
									<c:if test="${timeCode <= 12 && (tuesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','12','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','12','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay2}">
			<td <c:if test="${tuesday == today}">class="today"</c:if>>
						<c:if test="${timeCode <= 12 && (tuesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','12','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','12','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay3}">
			<c:forEach items="${reserveListDay3}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 11}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${wednesday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${wednesday == today}">class="today"</c:if>>
									<c:if test="${timeCode <= 12 && (wednesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','12','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','12','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay3}">
			<td <c:if test="${wednesday == today}">class="today"</c:if>>
						<c:if test="${timeCode <= 12 && (wednesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','12','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','12','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay4}">
			<c:forEach items="${reserveListDay4}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 11}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${thursday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${thursday == today}">class="today"</c:if>>
									<c:if test="${timeCode <= 12 && (thursdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','12','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','12','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay4}">
			<td <c:if test="${thursday == today}">class="today"</c:if>>
						<c:if test="${timeCode <= 12 && (thursdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','12','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','12','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay5}">
			<c:forEach items="${reserveListDay5}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 11}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${friday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${friday == today}">class="today"</c:if>>
									<c:if test="${timeCode <= 12 && (fridayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','12','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','12','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay5}">
			<td <c:if test="${friday == today}">class="today"</c:if>>
						<c:if test="${timeCode <= 12 && (fridayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','12','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','12','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		</tr>
		<tr>
		<th <c:if test="${timeCode == 13}">class="now"</c:if>>15:00~15:30 (PM)</th>
		<c:if test="${not empty reserveListDay1}">
			<c:forEach items="${reserveListDay1}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 12}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${monday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${monday == today}">class="today"</c:if>>
										<c:if test="${timeCode <= 13 && (mondayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','13','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','13','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay1}">
			<td <c:if test="${monday == today}">class="today"</c:if>>
						<c:if test="${timeCode <= 13 && (mondayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','13','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','13','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay2}">
			<c:forEach items="${reserveListDay2}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 12}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${tuesday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${tuesday == today}">class="today"</c:if>>
								<c:if test="${timeCode <= 13 && (tuesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','13','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','13','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay2}">
			<td <c:if test="${tuesday == today}">class="today"</c:if>>
					<c:if test="${timeCode <= 13 && (tuesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','13','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','13','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay3}">
			<c:forEach items="${reserveListDay3}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 12}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${wednesday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${wednesday == today}">class="today"</c:if>>
								<c:if test="${timeCode <= 13 && (wednesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','13','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','13','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay3}">
			<td <c:if test="${wednesday == today}">class="today"</c:if>>
					<c:if test="${timeCode <= 13 && (wednesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','13','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','13','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay4}">
			<c:forEach items="${reserveListDay4}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 12}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${thursday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${thursday == today}">class="today"</c:if>>
								<c:if test="${timeCode <= 13 && (thursdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','13','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','13','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay4}">
			<td <c:if test="${thursday == today}">class="today"</c:if>>
					<c:if test="${timeCode <= 13 && (thursdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','13','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','13','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay5}">
			<c:forEach items="${reserveListDay5}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 12}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${friday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${friday == today}">class="today"</c:if>>
								<c:if test="${timeCode <= 13 && (fridayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','13','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','13','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay5}">
			<td <c:if test="${friday == today}">class="today"</c:if>>
					<c:if test="${timeCode <= 13 && (fridayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','13','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','13','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		</tr>
		<tr>
		<th <c:if test="${timeCode == 14}">class="now"</c:if>>15:30~16:00 (PM)</th>
		<c:if test="${not empty reserveListDay1}">
			<c:forEach items="${reserveListDay1}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 13}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${monday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${monday == today}">class="today"</c:if>>
								<c:if test="${timeCode <= 14 && (mondayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','14','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','14','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay1}">
			<td <c:if test="${monday == today}">class="today"</c:if>>
					<c:if test="${timeCode <= 14 && (mondayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','14','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','14','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay2}">
			<c:forEach items="${reserveListDay2}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 13}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${tuesday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${tuesday == today}">class="today"</c:if>>
						<c:if test="${timeCode <= 14 && (tuesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','14','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','14','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay2}">
			<td <c:if test="${tuesday == today}">class="today"</c:if>>
					<c:if test="${timeCode <= 14 && (tuesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','14','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','14','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay3}">
			<c:forEach items="${reserveListDay3}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 13}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${wednesday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${wednesday == today}">class="today"</c:if>>
								<c:if test="${timeCode <= 14 && (wednesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','14','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','14','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay3}">
			<td <c:if test="${wednesday == today}">class="today"</c:if>>
					<c:if test="${timeCode <= 14 && (wednesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','14','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','14','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay4}">
			<c:forEach items="${reserveListDay4}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 13}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${thursday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${thursday == today}">class="today"</c:if>>
								<c:if test="${timeCode <= 14 && (thursdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','14','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','14','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay4}">
			<td <c:if test="${thursday == today}">class="today"</c:if>>
					<c:if test="${timeCode <= 14 && (thursdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','14','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','14','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay5}">
			<c:forEach items="${reserveListDay5}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 13}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${friday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${friday == today}">class="today"</c:if>>
								<c:if test="${timeCode <= 14 && (fridayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','14','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','14','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay5}">
			<td <c:if test="${friday == today}">class="today"</c:if>>
					<c:if test="${timeCode <= 14 && (fridayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','14','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','14','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		</tr>
		<tr>
		<th <c:if test="${timeCode == 15}">class="now"</c:if>>16:00~16:30 (PM)</th>
		<c:if test="${not empty reserveListDay1}">
			<c:forEach items="${reserveListDay1}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 14}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${monday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${monday == today}">class="today"</c:if>>
								<c:if test="${timeCode <= 15 && (mondayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','15','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','15','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay1}">
			<td <c:if test="${monday == today}">class="today"</c:if>>
					<c:if test="${timeCode <= 15 && (mondayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','15','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','15','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay2}">
			<c:forEach items="${reserveListDay2}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 14}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${tuesday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${tuesday == today}">class="today"</c:if>>
							<c:if test="${timeCode <= 15 && (tuesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','15','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','15','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay2}">
			<td <c:if test="${tuesday == today}">class="today"</c:if>>
					<c:if test="${timeCode <= 15 && (tuesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','15','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','15','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay3}">
			<c:forEach items="${reserveListDay3}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 14}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${wednesday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${wednesday == today}">class="today"</c:if>>
								<c:if test="${timeCode <= 15 && (wednesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','15','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','15','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay3}">
			<td <c:if test="${wednesday == today}">class="today"</c:if>>
					<c:if test="${timeCode <= 15 && (wednesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','15','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','15','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay4}">
			<c:forEach items="${reserveListDay4}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 14}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${thursday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${thursday == today}">class="today"</c:if>>
								<c:if test="${timeCode <= 15 && (thursdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','15','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','15','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay4}">
			<td <c:if test="${thursday == today}">class="today"</c:if>>
						<c:if test="${timeCode <= 15 && (thursdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','15','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','15','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay5}">
			<c:forEach items="${reserveListDay5}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 14}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${friday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${friday == today}">class="today"</c:if>>
									<c:if test="${timeCode <= 15 && (fridayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','15','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','15','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay5}">
			<td <c:if test="${friday == today}">class="today"</c:if>>
				<c:if test="${timeCode <= 15 && (fridayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','15','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','15','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		</tr>
		<tr>
		<th <c:if test="${timeCode == 16}">class="now"</c:if>>16:30~17:00 (PM)</th>
		<c:if test="${not empty reserveListDay1}">
			<c:forEach items="${reserveListDay1}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 15}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${monday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${monday == today}">class="today"</c:if>>
								<c:if test="${timeCode <= 16 && (mondayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','16','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','16','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay1}">
			<td <c:if test="${monday == today}">class="today"</c:if>>
				<c:if test="${timeCode <= 16 && (mondayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','16','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','16','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay2}">
			<c:forEach items="${reserveListDay2}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 15}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${tuesday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${tuesday == today}">class="today"</c:if>>
									<c:if test="${timeCode <= 16 && (tuesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','16','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','16','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay2}">
			<td <c:if test="${tuesday == today}">class="today"</c:if>>
						<c:if test="${timeCode <= 16 && (tuesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','16','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','16','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay3}">
			<c:forEach items="${reserveListDay3}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 15}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${wednesday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${wednesday == today}">class="today"</c:if>>
									<c:if test="${timeCode <= 16 && (wednesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','16','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','16','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay3}">
			<td <c:if test="${wednesday == today}">class="today"</c:if>>
						<c:if test="${timeCode <= 16 && (wednesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','16','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','16','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay4}">
			<c:forEach items="${reserveListDay4}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 15}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${thursday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${thursday == today}">class="today"</c:if>>
									<c:if test="${timeCode <= 16 && (thursdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','16','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','16','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay4}">
			<td <c:if test="${thursday == today}">class="today"</c:if>>
					<c:if test="${timeCode <= 16 && (thursdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','16','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','16','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay5}">
			<c:forEach items="${reserveListDay5}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 15}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${friday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${friday == today}">class="today"</c:if>>
								<c:if test="${timeCode <= 16 && (fridayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','16','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','16','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay5}">
			<td <c:if test="${friday == today}">class="today"</c:if>>
						<c:if test="${timeCode <= 16 && (fridayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','16','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','16','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		</tr>
		<tr>
		<th <c:if test="${timeCode == 17}">class="now"</c:if>>17:00~17:30 (PM)</th>
		<c:if test="${not empty reserveListDay1}">
			<c:forEach items="${reserveListDay1}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 16}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${monday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${monday == today}">class="today"</c:if>>
									<c:if test="${timeCode <= 17 && (mondayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','17','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','17','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay1}">
			<td <c:if test="${monday == today}">class="today"</c:if>>
				<c:if test="${timeCode <= 17 && (mondayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','17','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','17','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay2}">
			<c:forEach items="${reserveListDay2}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 16}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${tuesday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${tuesday == today}">class="today"</c:if>>
								<c:if test="${timeCode <= 17 && (tuesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','17','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','17','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay2}">
			<td <c:if test="${tuesday == today}">class="today"</c:if>>
					<c:if test="${timeCode <= 17 && (tuesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','17','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','17','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay3}">
			<c:forEach items="${reserveListDay3}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 16}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${wednesday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${wednesday == today}">class="today"</c:if>>
								<c:if test="${timeCode <= 17 && (wednesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','17','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','17','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay3}">
			<td <c:if test="${wednesday == today}">class="today"</c:if>>
				<c:if test="${timeCode <= 17 && (wednesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','17','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','17','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay4}">
			<c:forEach items="${reserveListDay4}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 16}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${thursday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${thursday == today}">class="today"</c:if>>
								<c:if test="${timeCode <= 17 && (thursdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','17','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','17','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay4}">
			<td <c:if test="${thursday == today}">class="today"</c:if>>
						<c:if test="${timeCode <= 17 && (thursdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','17','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','17','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay5}">
			<c:forEach items="${reserveListDay5}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 16}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${friday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${friday == today}">class="today"</c:if>>
									<c:if test="${timeCode <= 17 && (fridayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','17','${friday}'))"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','17','${friday}'))"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay5}">
			<td <c:if test="${friday == today}">class="today"</c:if>>
					<c:if test="${timeCode <= 17 && (fridayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','17','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','17','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		</tr>
		<tr>
		<th <c:if test="${timeCode == 18}">class="now"</c:if>>17:30~18:00 (PM)</th>
		<c:if test="${not empty reserveListDay1}">
			<c:forEach items="${reserveListDay1}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 17}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${monday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${monday == today}">class="today"</c:if>>
						<c:if test="${timeCode <= 18 && (mondayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','18','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','18','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay1}">
			<td <c:if test="${monday == today}">class="today"</c:if>>
					<c:if test="${timeCode <= 18 && (mondayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','18','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','18','${monday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${mondayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay2}">
			<c:forEach items="${reserveListDay2}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 17}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${tuesday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${tuesday == today}">class="today"</c:if>>
									<c:if test="${timeCode <= 18 && (tuesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','18','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','18','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay2}">
			<td <c:if test="${tuesday == today}">class="today"</c:if>>
						<c:if test="${timeCode <= 18 && (tuesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','18','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','18','${tuesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${tuesdayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay3}">
			<c:forEach items="${reserveListDay3}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 17}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${wednesday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${wednesday == today}">class="today"</c:if>>
									<c:if test="${timeCode <= 18 && (wednesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','18','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','18','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay3}">
			<td <c:if test="${wednesday == today}">class="today"</c:if>>
						<c:if test="${timeCode <= 18 && (wednesdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','18','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','18','${wednesday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${wednesdayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay4}">
			<c:forEach items="${reserveListDay4}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 17}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${thursday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${thursday == today}">class="today"</c:if>>
									<c:if test="${timeCode <= 18 && (thursdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','18','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','18','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay4}">
			<td <c:if test="${thursday == today}">class="today"</c:if>>
						<c:if test="${timeCode <= 18 && (thursdayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','18','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','18','${thursday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${thursdayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		<c:if test="${not empty reserveListDay5}">
			<c:forEach items="${reserveListDay5}" var = "reserve" varStatus="status">
			 	 <c:if test="${status.index eq 17}">
			 	 			 	 	<c:if test="${reserve.fileCnt ne '' && reserve.fileCnt ne null}">
			 	 			<fmt:parseNumber var="fileCnt" type="number" value="${reserve.fileCnt}"/>
			 	 	</c:if>	
			 	 	 <c:choose>
			 	 	 	<c:when test="${fn:trim(reserve.start) ne '' && fn:trim(reserve.start) ne null}">
			 	 	 		<c:choose>
			 	 	 	 		<c:when test="${fn:trim(reserve.start) eq 'yes'}">
								<td rowspan="${reserve.diffTime}" <c:if test="${friday == today}">class="today"</c:if>>
								<c:if test="${reserve.notiYN eq 'Y' }">
									<div class="meeting_obj point">
								</c:if>
								<c:if test="${reserve.notiYN eq 'N' }">
									<div class="meeting_obj">
								</c:if>
		    	 				<div class="meeting_obj_in">
								<c:if test="${loginUserId eq reserve.regUserId}"><button class="btn_meeting_close" onclick="deleteReserveRoom('${reserve.rmrNo}','${loginUserId}'); return false;"></button></c:if>	
									<p onClick="goDetailView('insert_meeting_view','${reserve.rmrNo}')"><strong><c:if test="${reserve.fileCnt > 0}"><img src="/resources/images/icon_meeting_file.png"></c:if>${reserve.regUserName}(${reserve.pn}인)</strong>
									 <c:if test="${fn:trim(reserve.diffTime) ne '1'}">
									 	<br>${reserve.startTime}~${reserve.endTime}
									 </c:if>							 
									</p>
								</div>
		    	 				</div>
								</td>
								</c:when>
								<c:when test="${fn:trim(reserve.start) eq 'include'}">

								</c:when>
			 	 	 		</c:choose>
			 	 	 	</c:when>
			 	 	 	<c:otherwise>
			 	 	 		<td <c:if test="${friday == today}">class="today"</c:if>>
									<c:if test="${timeCode <= 18 && (fridayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','18','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','18','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate < todayDate}"></c:if>
							</td>
			 	 		 </c:otherwise>
					</c:choose>		 
				 </c:if>
			</c:forEach>
		</c:if>
		<c:if test="${empty reserveListDay5}">
			<td <c:if test="${friday == today}">class="today"</c:if>>
						<c:if test="${timeCode <= 18 && (fridayDate == todayDate) }">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','18','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate > todayDate}">
			 	 	 				<div class="meeting_obj_none" onClick="openReserve('insert_meeting','18','${friday}')"></div>
			 	 	 			</c:if>
			 	 	 			<c:if test="${fridayDate < todayDate}"></c:if>
			</td>
		</c:if>	
		</tr> 
		</tbody>
		</table>
		 
		
		
	</div>
	


				<div class="btn_box_con"></div>
			 <hr class="con_mode"/><!-- 신규 추가 꼭 데려갈것 !-->
			</div>
	
		<!-- 컨텐츠 close-->	
				</section>
</div>	

<form name="insert_meeting_form" id="insert_meeting_form" action="/Reserve/ReserveSaveAjax" method="post" enctype="multipart/form-data"> 
<div class="white_content" id="insert_meeting">
		<div class="modal" style="	margin-left:-250px;width:500px;height:440px;margin-top:-220px">
		  <h5 style="position:relative">
				<span class="title">회의실 예약</span>
				<div  class="top_btn_box">
					<ul><li><button class="btn_madal_close"  onClick="closeDialog('insert_meeting'); return false;"></button></li></ul>
				</div>
			</h5>
			<div class="list_detail">
		<ul>
	
					<li>
			<dt>날짜</dt><dd><input type="text"style="width:110px;" class="req" id="reserveDate" name="reserveDate"/></dd>
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
				<label for="endTime ">---선택---</label>
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

<dd><input type="text" class="req" style="width:50px;" id="pn" name="pn"> 명 
</dd>
			</li>
				<li>
			<dt>회의목적</dt>

<dd><input type="text" style="width:300px;" class="req" placeholder="연구소외 부서 회의실 예약불가" name="title" id="title"> <input type="checkbox" id="notiYN"><label for="notiYN" style="padding-right:0px;"><span></span></label>중요
</dd>
			</li>
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
			<div class="btn_box_con4" style="padding:15px 0 20px 0"><button class="btn_admin_red" onclick="reserveRoom(this); return false;">예약</button> <button class="btn_admin_gray" onClick="closeDialog('insert_meeting'); return false;">닫기</button></div>
</div>
		<input type="hidden" name="reserveDayCode" id="reserveDayCode"/>
		<input type="hidden" name="notiYNval" id="notiYNval"/>
		<input type="hidden" name="reserveRoomCode" id="reserveRoomCode"/>
		
</div>
</form> 
	<!-- 회의실 예약 레이어 생성레이어 close-->
		<!-- 회의실 보기 레이어 start-->
	<!-- 신규로 레이어창을 생성하고싶을때는  아이디값 교체-->
	<!-- 클래스 옆에 적힌 스타일 값을 인라인으로 작성해서 팝업 사이즈를 직접 조정 -->
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
		<li id="detailTitle"><dt>회의목적</dt><dd><strong>[중요]</strong>마켓컬리 MD초청 상품 제안 품평회
</dd>
			</li>
				<li><dt>첨부파일</dt><dd>
	
												 <ul class="meeting_file_list" id="fileListUl">
												 	<!-- <li><a href="#">실적 파일 다운로드</a></li>
													<li><a href="#">d20193년 세미나 자료 첨부</a></li>
													<li><a href="#">d20193년 세미나 자료 첨부</a></li> 
 -->
												</ul> 
			</dd>
			</li>
		</ul>
	</div>
			<div class="btn_box_con" style="padding:15px 0 20px 0"> <button class="btn_admin_gray" onClick="closeDialog('insert_meeting_view')">닫기</button></div>
</div>
</div>