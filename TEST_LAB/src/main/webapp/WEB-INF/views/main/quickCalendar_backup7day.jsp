<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="userUtil" uri="/WEB-INF/tld/userUtil.tld"%>
<%@ page session="false" %>

<script>
	$(document).ready(function(){
		$('#quickDate, #sendDate').datepicker({
			dateFormat: 'yy-mm-dd',
			/* minDate :0, */
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
				var curday = new Date(dateText).getDay();
				
				var monday = Number(dateText.substr(8,9))-curday+1;
				var friday = Number(dateText.substr(8,9))-curday+5;
				
				console.log('Date of monday: ' + dateText.substr(0,8)+monday);
				console.log('Date of friday: ' + dateText.substr(0,8)+friday);
				
				$('#quickToday').text(dateText);
				
				
				var currntDate = new Date(dateText);
				setQuickTblShape(currntDate);
				
				function addDays(dateObj, numDays) {
				   dateObj.setDate(dateObj.getDate() + numDays);
				   return dateObj;
				}

				var now = new Date();
				var tomorrow = addDays(new Date(), 1);
				var nextWeek = addDays(new Date(), 25);
					
			},
		});
		
		$('#quickDate').siblings('img').css('margin-left', '8px');
		$('#quickDate').siblings('img').css('margin-top', '-5px');
		$('#quickDate').siblings('img').css('cursor', 'pointer');
		
		$('#sendDate').siblings('img').css('margin-left', '3px');
		$('#sendDate').siblings('img').css('margin-top', '3px');
		
		$('#sendTime').timepicker({
			step:10,
			timeFormat: 'H:i',
		    minTime: '9',
		    maxTime: '18:00',
		    defaultTime: '9',
		    startTime: '9:00',
		    dynamic: false,
		    dropdown: true,
		    scrollbar: true
		});
		
		setTodayClass();
	})
	
	function setTodayClass(){
		var curday = new Date().getDay()+1;
		$('#quickTbl thead tr:first-child').children('th:nth-child('+curday+')').attr('class', 'today');
		$('#quickTbl tbody tr').children('td:nth-child('+curday+')').attr('class', 'today')
	}
	
	
	function setQuickTblShape(dateObj){
		var dayIndex = dateObj.getDay();
		
		var colGroupElement = '';
		for (var i = dayIndex; i < dayIndex+8; i++) {
			if(i == dayIndex){
				colGroupElement += '<col width="14%">';
			} else if((i == 7 || i == 8)) {
				colGroupElement += '<col width="3%">';
			} else {
				colGroupElement += '<col width="16%">';
			}
		}
		
		$('#quickTbl colgroup').empty();
		$('#quickTbl colgroup').append(colGroupElement);
		
		
		var thElement = '';
		for (var i = 0; i < 8; i++) {
			if(i == 0 ) {
				thElement += '<th>시간</th>'
			} else {
				var str = getDateStr(dateObj, i-1);
				var isToday = false;
				
				if(getDateStr(dateObj, i-1) == getDateStr(new Date(), 0)){
					isToday = true;
				}
				
				if(str.split(' ')[1] == '토' || str.split(' ')[1] == '일'){
					str = str.split(' ')[1];
				}
				
				if(isToday){
					thElement += '<th class="today">'+str+'</th>';
				} else {
					thElement += '<th>'+str+'</th>';
				}
				
			}
		}
		$('#quickTbl thead tr').empty();
		$('#quickTbl thead tr').append(thElement);
		
	}
	
	function getDateStr(dateObj, numDays){
		var d = new Date();
		d.setDate(dateObj.getDate() + numDays);
		
		var month = d.getMonth() + 1;
		var day = d.getDate();

		var output = d.getFullYear() + '-' +
		    (month < 10 ? '0' : '') + month + '-' +
		    (day < 10 ? '0' : '') + day;
		
		output += " " + getDayOfTheWeek(d.getDay());
		
		return output;
	}
	
	function getDayOfTheWeek(dayIndex){
		var week = [ "일", "월요일", "화요일", "수요일", "목요일", "금요일", "토"];
		return week[dayIndex];
	}
	
	function registQuickInfo(){
		$.ajax({
			url: '/quick/registQuick',
			type: 'post',
			data: $('#quickForm').serialize(),
			success: function(data){
				if(data.status == "success"){
					alert("등록되었습니다.");
					searchQuickList();
				 } else if( data.status == 'fail' ){
					 alert(data.msg);
				} else {
					alert("오류가 발생하였습니다.");
				}
			},
			error: function(a,b,c){
				alert("시스템 오류 - 관리자에게 문의하세요.");
			}
		})
	}
	
	function searchQuickList(){
		$.ajax({
			url: '/quick/getQuickInfoList',
			type: 'post',
			data: {
				startDate: '',
				endDate: ''
			},
			success: function(data){
				if(data.status == "success"){
					alert("등록되었습니다.");
					searchQuickList();
				 } else if( data.status == 'fail' ){
					 alert(data.msg);
				} else {
					alert("오류가 발생하였습니다.");
				}
			},
			error: function(a,b,c){
				alert("시스템 오류 - 관리자에게 문의하세요.");
			}
		})
	}
	
	function clearQuickForm(){
		var loginUserName = '${userUtil:getUserName(pageContext.request)}';
		
		$('#sendDate').val('');
		$('#sendTime').val('');
		$('#sendUser').val(loginUserName);
		$('#transTypeName').val('');
		$('#memo').val('');
	}
	
	function addCalendarQuickInfo(dow, time){
		var sendDate = $('#quickTbl thead tr th')[dow].textContent.split(' ')[0];
		
		$('#sendDate').val(sendDate);
		$('#sendTime').val(time);
		
		openDialog('dialog_quick');
	}
	
	function closeQuickDialog(){
		closeDialog('dialog_quick');
		clearQuickForm();
	}
</script>
<div class="title7 mt30">
	<span class="txt">퀵서비스 발송</span>
	
</div>
<div class="fr pb10" style="margin-top: 23px;">
		<button class="btn_circle_red" onclick="openDialog('dialog_quick')"></button>&nbsp;
	</div>
<div class="dashboard_quick">
	<div class="cal_header">
		<!-- 이미 지난 날짜일경우 아래 버튼 클래스에 비활성화 클래스 nouse (연한회색처리됨)를 넣어줍니다.-->
		<button class="btn_cal_pre">&lt;</button>
		<!-- 캘린더 아이콘 클릭시 먼날짜 이동 -->
		<span style="display:block; width:100%; text-align:center; height:19px;">
			<strong id="quickToday">2020-09-07</strong>
			<input id="quickDate" type="hidden"/>
			<br>
		</span>
		<span id="dayFromTo" style="display:block; width:100%; text-align:center; height:61px;">2020-09-07 ~ 2020-09-11
		</span>
			<!-- 버튼 클릭시 일주일 단위로 전환 -->
		<button class="btn_cal_next">&gt;</button>
	</div>

	<table id="quickTbl" class="tbl_meeting">
		<colgroup>
			<col width="14%">
			<col width="16%">
			<col width="16%">
			<col width="16%">
			<col width="16%">
			<col width="16%">
			
			<col width="3%">
			<col width="3%">
		</colgroup>
		<thead>
			<tr>
				<th>시간</th>
				<!-- 오늘 표시는 class 명에 today 삽입 -->
				<th>2020-09-07 월요일</th>
				<th>2020-09-08 화요일</th>
				<th>2020-09-09 수요일</th>
				<th>2020-09-10 목요일</th>
				<th>2020-09-11 금요일</th>
				<th><span style="color:blue;"><strong>토</strong></span></th>
				<th><span style="color:red;"><strong>일</strong></span></th>
			</tr>
		</thead>
		<tbody>
			<c:forEach begin="0" end="10" step="1" var="time" >
				<tr id="quickTr${time+9}">
					<c:forEach begin="0" end="7" step="1" var="dow" >
						<c:if test="${dow == 0}">
							<th>${time+9}:00 ~ ${time+10}:00 ${time == 5 ? '(AM)' : '(PM)' }</th>
						</c:if> 
						<c:if test="${dow != 0}">
							<c:if test="${dow == 1}">
								<td>
									<div class="meeting_obj_none" onclick="addCalendarQuickInfo('${dow}', '${time+10}:00')"></div>
								</td>
							</c:if>
							<c:if test="${dow != 1}">
								<td>
									<%-- <div class="meeting_obj_none" onclick="addCalendarQuickInfo('${dow}', '${time+10}:00')"></div> --%>
									<!-- <div class="meeting_obj point" style="height:20px;">
										<div class="meeting_obj_in">
											<p onclick="">
												<strong>[17:20] 시화공장 - 박성욱</strong>
											</p>
										</div>
									</div>
									<div class="meeting_obj" style="margin-top:2px; height:20px;">
										<div class="meeting_obj_in">
											<p onclick="">
												<strong>푸드시식보고 </strong>
											</p>
										</div>
									</div> -->
								</td>
							</c:if>
						</c:if>
					</c:forEach>
				</tr>
			</c:forEach>
		</tbody>
	</table>
</div>


<div class="white_content" id="dialog_quick">
	<div class="modal" style="margin-left:-305px;width:510px;height: 390px;margin-top:-160px">
		<h5 style="position:relative">
			<span class="title">퀵서비스 발송정보 등록</span>
			<div class="top_btn_box">
				<ul>
					<li>
						<button class="btn_madal_close" onClick="closeDialog('dialog_quick')"></button>
					</li>
				</ul>
			</div>
		</h5>
		<div class="list_detail">
			<form id="quickForm">
				<ul>
					<li>
						<dt>발송일</dt>
						<dd>
							<input class="req" id="sendDate" name="sendDate" type="text" value="" style="width: 150px; float: left" />
						</dd>
					<li>
					<li>
						<dt>발송시간</dt>
						<dd>
							<input class="req" id="sendTime" name="sendTime" type="text" value="" style="width: 150px; float: left" />
						</dd>
					<li>
					<li>
						<dt>발송인</dt>
						<dd>
							<input class="req" id="sendUser" name="sendUser" type="text" value="${userUtil:getUserName(pageContext.request)}" style="width: 150px; float: left" />
						</dd>
					<li>
					<li>
						<dt>차량종류</dt>
						<dd>
							<input class="req" id="transTypeName" name="transTypeName" type="text" value="" style="width: 150px; float: left" />
						</dd>
					<li>
					<li>
						<dt>메모</dt>
						<dd>
							<input class="" id="memo" name="memo" type="text" value="" style="width: 350px; float: left" />
						</dd>
					<li>
				</ul>
			</form>
		</div>
        <div class="btn_box_con">
            <button class="btn_admin_red" onclick="registQuickInfo()">등록</button>
            <button class="btn_admin_gray" onClick="closeDialog('dialog_quick')">취소</button>
        </div>
    </div>
</div>