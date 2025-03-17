<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="userUtil" uri="/WEB-INF/tld/userUtil.tld"%>
<%@ page session="false" %>
<style>
	.popText { padding-top: 5px; padding-left: 10px; }
	#quickForm ul li dd { padding-top: 5px; padding-left: 10px; }
</style>
<script>
	$(document).ready(function(){
		$('#quickDate').datepicker({
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
				$('#lab_loading').show();
				var selelctDate = new Date(dateText)
				
				var startDate = getDateStr(selelctDate, (1-selelctDate.getDay()));
				var endDate = getDateStr(selelctDate, (5-selelctDate.getDay()))
				searchQuickList(startDate, endDate);
				
				$('#quickToday').text(dateText);
				$('#dayFromTo').text(startDate +' ~ ' + endDate);
				$('#lab_loading').hide();
			},
		});
		
		$('#quickDate').siblings('img').css('margin-left', '8px');
		$('#quickDate').siblings('img').css('margin-top', '-5px');
		$('#quickDate').siblings('img').css('cursor', 'pointer');
		
		$('#sendDate').datepicker({
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
			beforeShow:function(input, inst){
				var offset = $('#dialog_quick_body')[0].offsetTop - 66;
				
				setTimeout(function () {
		            inst.dpDiv.css({
		                top: offset
		            });
		        }, 0);
			},
			onSelect : function(dateText,inst){
				$('#lab_loading').show();
				$('#sendDate').val(dateText)
				$('#lab_loading').hide();
			},
		});
		
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
		
		// 오늘날짜 설정
		$('#quickDate').datepicker("setDate", new Date() );
		$('.ui-datepicker-current-day').click();
		
		$('#sendDate').datepicker("setDate", new Date() );
		$('.ui-datepicker-current-day').click();
		
		//setTodayClass();
		
		$('input[name=transType]').change(function(e){
			var transTypeName = $('label[for='+e.target.id+']').text();
			$('#transTypeName').val(transTypeName);
		});
	})
	
	
	
	function setTodayClass(){
		var curday = new Date().getDay()+1;
		$('#quickTbl thead tr:first-child').children('th:nth-child('+curday+')').attr('class', 'today');
		$('#quickTbl tbody tr').children('td:nth-child('+curday+')').attr('class', 'today')
	}
	
	function getDateStr(dateObj, numDays){
		var d = dateObj;
		d.setDate(dateObj.getDate() + numDays);
		
		var month = d.getMonth() + 1;
		var day = d.getDate();

		var output = d.getFullYear() + '-' +
		    (month < 10 ? '0' : '') + month + '-' +
		    (day < 10 ? '0' : '') + day;
		
		return output;
		//return output += " " + getDayOfTheWeek(d.getDay());
	}
	
	function getDayOfTheWeek(dayIndex){
		var week = [ "일", "월요일", "화요일", "수요일", "목요일", "금요일", "토"];
		return week[dayIndex];
	}
	
	function registQuickInfo(){
		$('#lab_loading').show();
		
		$.ajax({
			url: '/quick/registQuick',
			type: 'post',
			data: $('#quickForm').serialize(),
			success: function(data){
				if(data.status == "success"){
					alert("등록되었습니다.");
					searchQuickList();
					closeQuickDialog();
				 } else if( data.status == 'fail' ){
					 alert(data.msg);
				} else {
					alert("오류가 발생하였습니다.");
				}
			},
			error: function(a,b,c){
				alert("시스템 오류 - 관리자에게 문의하세요.");
			},
			complete: function(){
				$('#lab_loading').hide();
			}
		})
	}
	
	function searchQuickList(startDate, endDate){
		if(startDate == null || endDate == null){
			startDate = $('#dayFromTo').text().split(' ~ ')[0];
			endDate = $('#dayFromTo').text().split(' ~ ')[1];
		}
		$.ajax({
			url: '/quick/getQuickInfoList',
			type: 'post',
			data: {
				startDate: startDate,
				endDate: endDate
			},
			success: function(data){
				if(data != null){
					setQuickHead(startDate);
					setQuickBody(data);
				} else {
					
				}
			},
			error: function(a,b,c){
				alert("시스템 오류 - 관리자에게 문의하세요.");
			}
		})
	}
	
	function setQuickHead(startDate){
		var headElement = '';
		
		for (var i = 0; i < 5; i++) {
			var date = new Date(startDate);
			var yyyymmdd = getDateStr(date, i);
			if(yyyymmdd == getDateStr(new Date(), 0)){
				headElement += '<th class="today">'+ yyyymmdd + ' ' + getDayOfTheWeek(new Date(yyyymmdd).getDay()) + '</th>'
				$('#quickTbl tbody tr td:nth-child('+(i+1)+')').attr('class', 'today');
			} else {
				headElement += '<th>'+yyyymmdd + ' ' + getDayOfTheWeek(new Date(yyyymmdd).getDay()) + '</th>'
				$('#quickTbl tbody tr td:nth-child('+(i+1)+')').attr('class', '');
			}
		}
		$('#quickTbl thead tr').empty();
		$('#quickTbl thead tr').append(headElement);
	}
	
	function setQuickBody(quickList){
		clearQuickBody();
		for (var i = 0; i < quickList.length; i++) {
			var quickInfo = quickList[i];
			var sendDate = quickInfo.sendDate;
			var sendTime = quickInfo.sendTime;
			
			//var rowDateId = $('#quickTbl thead tr th')[i+1].textContent.split(' ')[0];
			
			var rowNdx = new Date(sendDate).getDay()-1;
			var trId = 'quickTr';//+parseInt(sendTime.substr(0,2));
			$($('#'+trId).children().get(rowNdx)).append(createQuickElement(quickInfo))
		}
	}
	
	function clearQuickBody(){
		$('tr[id^=quickTr]').children('td').empty();
	}
	
	function createQuickElement(quickInfo){
		var loginUserId = '${userUtil:getUserId(pageContext.request)}'
		var regUserId = quickInfo.regUserId;
		
		var sendDate = quickInfo.sendDate;
		var sendTime = quickInfo.sendTime;
		var destination = quickInfo.destination;
		var sendUser = quickInfo.sendUser;
		var transTypeName = quickInfo.transTypeName;
		var memo = quickInfo.memo;
		var qNo = quickInfo.qNo;
		
		var element =	'<div class="meeting_obj" style="margin-top:2px; height:20px; text-align: left; padding-left: 3px;">';
		element	+=			'<div class="meeting_obj_in" onclick="openQuickDetailDialog(\''+sendDate+'\',\''+sendTime+'\',\''+destination+'\',\''+sendUser+'\',\''+transTypeName+'\',\''+memo+'\',\''+qNo+'\')">';
		if(loginUserId == regUserId)
			element	+=			'<button class="btn_meeting_close" style="top:1px" onclick="deleteQuickInfo(event, \''+qNo+'\');"></button>';
		element	+=				'<p onclick="">';
		element	+=					'<strong>['+sendTime+'] '+destination+' '+transTypeName+' '+sendUser+'</strong>';
		element	+=				'</p>';
		element	+=			'</div>';
		element	+=		'</div>';
		return element;
	}
	
	function deleteQuickInfo(event, qNo){
		$('#lab_loading').show();
		
		event.stopPropagation();
		
		if(confirm('삭제하시겠습니까?')){
			$.ajax({
				url: '/quick/deleteQuickInfo',
				type: 'post',
				data: { qNo: qNo },
				success: function(data){
					console.log(data);
					if(data.status == "success"){
						alert("삭제되었습니다.");
						searchQuickList();
					 } else if( data.status == 'fail' ){
						 alert(data.msg);
					} else {
						alert("오류가 발생하였습니다.");
					}
				},
				error: function(a,b,c){
					alert("시스템 오류 - 관리자에게 문의하세요.");
				},
				complete: function(){
					$('#lab_loading').hide();
				}
			});
		}
	}
	
	function createEmptyQuickElemnt(){
		$('tr[id^=quickTr]').children('td').toArray().forEach(function(td){
			if($(td).text() == ''){
				$(td).empty();
				$(td).append('<div class="meeting_obj_none" onclick="addCalendarQuickInfo(\'dow\', \'09:00\')"></div>')
			}
		})
		//'<div class="meeting_obj_none" onclick="addCalendarQuickInfo(\'${dow}\', \'${time+10}:00\')"></div>'
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
	
	function changeWeek(type){
		if (type == 'next') {
			var currentDate = $('#quickToday').text();
			var selelctDate = getDateStr(new Date(currentDate), 7);
			$('#quickDate').datepicker("setDate", selelctDate );
			$('.ui-datepicker-current-day').click()
		}
		
		if (type == 'prev') {
			var currentDate = $('#quickToday').text();
			var selelctDate = getDateStr(new Date(currentDate), -7);
			$('#quickDate').datepicker("setDate", selelctDate );
			$('.ui-datepicker-current-day').click()
		}
	}
	
	function openQuickDetailDialog(sendDate, sendTime, destination, sendUser, transTypeName, memo, qNo){
		$('#detail_sendDate').text(sendDate);
		$('#detail_sendTime').text(sendTime);
		$('#detail_destination').text(destination);
		$('#detail_sendUser').text(sendUser);
		$('#detail_transTypeName').text(transTypeName);
		$('#detail_memo').text(memo);
		$('#selectedQuickSn').val(qNo);
		openDialog('dialog_quickDetail');
	}
	
	function closeQuickDetailDialog(){
		closeDialog('dialog_quickDetail');
		$('#detail_sendDate').text();
		$('#detail_sendTime').text();
		$('#detail_destination').text();
		$('#detail_sendUser').text();
		$('#detail_transTypeName').text();
		$('#detail_memo').text();
		$('#selectedQuickSn').val('');
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
		<button class="btn_cal_pre" onclick="changeWeek('prev')">&lt;</button>
		<!-- 캘린더 아이콘 클릭시 먼날짜 이동 -->
		<span style="display:block; width:100%; text-align:center; height:19px;">
			<strong id="quickToday">0000-00-00</strong><input id="quickDate" type="hidden"/>
			<br>
		</span>
		<span id="dayFromTo" style="display:block; width:100%; text-align:center; height:61px;">
			0000-00-00 ~ 0000-00-00
		</span>
		<!-- 버튼 클릭시 일주일 단위로 전환 -->
		<button class="btn_cal_next" onclick="changeWeek('next')">&gt;</button>
	</div>

	<table id="quickTbl" class="tbl_meeting">
		<colgroup>
			<%-- 
			<col width="15%">
			 --%>
			<col width="17%">
			<col width="17%">
			<col width="17%">
			<col width="17%">
			<col width="17%">
			<%-- 
			<col width="3%">
			<col width="3%">
			 --%>
		</colgroup>
		<thead>
			<tr>
				<!-- <th>시간</th> -->
				<!-- 오늘 표시는 class 명에 today 삽입 -->
				<th>2020-09-07 월요일</th>
				<th>2020-09-08 화요일</th>
				<th>2020-09-09 수요일</th>
				<th>2020-09-10 목요일</th>
				<th>2020-09-11 금요일</th>
				<!-- 
				<th><span style="color:blue;"><strong>토</strong></span></th>
				<th><span style="color:red;"><strong>일</strong></span></th>
				 -->
			</tr>
		</thead>
		<tbody>
			<tr id="quickTr">
				<c:forEach begin="0" end="4" step="1" var="dow" >
					<td style="text-aling:left; padding-left: 3px;"><div class="meeting_obj_none" onclick="addCalendarQuickInfo('${dow}', '${time+10}:00')"></div></td>
				</c:forEach>
			</tr>
		</tbody>
	</table>
</div>

<div class="white_content" id="dialog_quick">
	<div id="dialog_quick_body" class="modal positionCenter" style="width:510px;height: 440px;">
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
						<dt>목적지</dt>
						<dd>
							<input class="req" id="destination" name="destination" type="text" value="" style="width: 150px; float: left" />
						</dd>
					<li>
					<li>
						<dt>발송인</dt>
						<dd class="popText">
							<span>${userUtil:getUserName(pageContext.request)}</span>
							<input class="req" id="sendUser" name="sendUser" type="hidden" value="${userUtil:getUserName(pageContext.request)}" style="width: 150px; float: left" />
						</dd>
					<li>
					<li>
						<dt>차량종류</dt>
						<dd class="popText">
							<input type="radio" name="transType" id="transType1" value="B" checked="checked"/><label for="transType1"><span></span>오토바이</label>
							<input type="radio" name="transType" id="transType2" value="D" ><label for="transType2"><span></span>다마스</label>
							<input id="transTypeName" name="transTypeName" type="hidden" value="오토바이"/>
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

<div class="white_content" id="dialog_quickDetail">
	<div class="modal positionCenter" style="width:410px;height: 425px;">
		<h5 style="position:relative">
			<span class="title">퀵서비스 발송정보 상세</span>
			<div class="top_btn_box">
				<ul>
					<li>
						<button class="btn_madal_close" onClick="closeQuickDetailDialog()"></button>
					</li>
				</ul>
			</div>
		</h5>
		<div class="list_detail">
			<form id="quickForm">
				<ul>
					<li>
						<dt>발송일</dt>
						<dd style="padding-top: 5px;">
							<span id="detail_sendDate"></span>
						</dd>
					<li>
					<li>
						<dt>발송시간</dt>
						<dd style="padding-top: 5px;">
							<span id="detail_sendTime"></span>
						</dd>
					<li>
					<li>
						<dt>목적지</dt>
						<dd style="padding-top: 5px;">
							<span id="detail_destination"></span>
						</dd>
					<li>
					<li>
						<dt>발송인</dt>
						<dd style="padding-top: 5px;">
							<span id="detail_sendUser"></span>
						</dd>
					<li>
					<li>
						<dt>차량종류</dt>
						<dd style="padding-top: 5px;">
							<span id="detail_transTypeName"></span>
						</dd>
					<li>
					<li>
						<dt>메모</dt>
						<dd style="padding-top: 5px;">
							<span id="detail_memo"></span>
						</dd>
					<li>
				</ul>
			</form>
		</div>
        <div class="btn_box_con">
        	<!-- <button id="fixQuickBtn" class="btn_admin_sky" onClick="fixQuickInfo()">수정</button> -->
            <button class="btn_admin_gray" onClick="closeQuickDetailDialog()">닫기</button>
        </div>
    </div>
</div>
<input id="selectedQuickSn" type="hidden">