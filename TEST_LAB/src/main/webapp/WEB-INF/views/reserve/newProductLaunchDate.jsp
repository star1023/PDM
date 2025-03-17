<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page session="false" %>
	<title>회의실 예약리스트</title>
	<link href="../resources/css/main.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
$(document).ready(function(){
	
})


function launchDateUpdate(){

 openDialog("open");
}
</script>
	<div class="wrap_in" id="fixNextTag">
				<span class="path">신제품 출시일 리스트&nbsp;&nbsp;<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;<a href="#">삼립식품 연구개발시스템</a></span>
				<section class="type01">
				<!-- 상세 페이지  start-->
					<h2 style="position:relative"><span class="title_s">newProductLaunchName</span>
						<span class="title">신제품 출시일 리스트</span>
						<div  class="top_btn_box">

						</div>
					</h2>
						<div class="group01" >
	<div class="title"><!--span class="txt">연구개발시스템 공지사항</span--></div>
			<div class="fr pb10"><button class="btn_circle_red" onClick="openDialog('insert_meeting')"> &nbsp;</button>&nbsp;<button class="btn_circle_nomal_more">&nbsp;</button>
					</div>
				<!-- 	<div class="title7"><span class="txt">회의실 예약<strong> 연구소외에는 회의실 예약 사용이 금지되어 있습니다. </strong></span></div> -->
					<div class="tab04">
				<ul>
				<!-- 선택됬을경우는 탭 클래스에 select를 넣어주세요 -->
				<!-- 회의실이 하나밖에 없을경우는 ul은 그대로 두고 a 링크부터 li 포함한 부분 안보이게 처리 여기부터  -->
				<a href="#"><li class="select">회의실 명1</li></a>
				<a href="#"><li class="">회의실 명2</li></a>
				<!-- 회의실이 하나밖에 없을경우는 ul은 그대로 두고 a 링크부터 li 포함한 부분 안보이게 처리 여기까지  -->
				</ul>
				</div>
	<div class="re_meeting" >
		<div class="cal_header">
		<!-- 이미 지난 날짜일경우 아래 버튼 클래스에 비활성화 클래스 nouse (연한회색처리됨)를 넣어줍니다.--> 
		<button class="btn_cal_pre nouse">&lt;</button>
		<!-- 캘린더 아이콘 클릭시 먼날짜 이동 -->
		<span style="display:block; width:100%; text-align:center; height:80px;"><strong>2019-01-12 월요일 <a href="#"><img src="images/btn_calendar.png"/></a></strong><br/>
			2020.01.12~2020.01.18</span>
			<!-- 버튼 클릭시 일주일 단위로 전환 -->
		<button class="btn_cal_next">&gt;</button>
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
		<th class="today">01.01 월요일</th>
		<th>01.02 화요일</th>
		<th>01.03 수요일</th>
		<th>01.04 목요일</th>
		<th>01.05 금요일</th>
		</tr>
		</thead>
		<tbody>
		<tr>
		<!-- 당일 시간 표시는 th class 명에 now 삽입 -->
		<th class="now">09:00~09:30 (AM)</th>
		<td rowspan="2" class="today">
		<div class="meeting_obj">
		<!-- 본인이 예약한 건에대해서만 삭제버튼 노출 -->
		<div class="meeting_obj_in"><button class="btn_meeting_close"></button>
		<p onClick="openDialog('insert_meeting_view')"><strong>김현정(3인)</strong><br>
		09:00~10:00</p>
		</div>
		</div>
		</td>
		<!-- 예약되지 않은 시간대 클릭시 예약 창 오픈 -->
		<!-- 해당 날짜와 시간대를 자동으로 가져올수 있도록 -->
		<td ><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
			<td ><div class="meeting_obj_none"  onClick="openDialog('insert_meeting')"></div></td>
			<td ><div class="meeting_obj_none"  onClick="openDialog('insert_meeting')"></div></td>
		<td ><div class="meeting_obj_none"  onClick="openDialog('insert_meeting')"></div></td>
		</tr>
		<tr>
		<th>09:30~10:00 (AM)</th>
		<td>
		<div class="meeting_obj">
		<div class="meeting_obj_in"><button class="btn_meeting_close"></button>
				<!-- 30분 단위 예약건에 대해서 아래 주석부분 안보이게 처리 br을 포함한 시간표현( 줄늘어남 방지) -->
		<p onClick="openDialog('insert_meeting_view')"><strong>김현정(3인)</strong><!--br>
		09:00~10:00--></p>
		</div>
		</div>
		</td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		</tr>
		<tr>
		<th>10:00~10:30 (AM)</th>
		<td  class="today"><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<!-- 예약할때 중요표시한 회의실 예약건에 대해서 class 명에 point 추가-->
		<!-- 본인이 예약한 건에대해서만 삭제버튼 노출 -->
		<td><div class="meeting_obj point">
		<div class="meeting_obj_in"><!--button class="btn_meeting_close"></button-->
		<p onClick="openDialog('insert_meeting_view')"><strong><img src="images/icon_meeting_file.png"> 김현정(3인)</strong></p>
		</div>
		</div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		</tr>
		<tr>
		<th >10:30~11:00 (AM)</th>
		<td rowspan="2" class="today">
		<!-- 예약할때 중요표시한 회의실 예약건에 대해서 class 명에 point 추가-->
		<div class="meeting_obj point">
		<div class="meeting_obj_in"><button class="btn_meeting_close"></button>
		<p onClick="openDialog('insert_meeting_view')"><strong><img src="images/icon_meeting_file.png"> 김현정(3인)</strong><br>
		09:00~10:00</p>
		</div>
		</div>
		</td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		</tr>
		<tr>
		<th>11:00~11:30 (AM)</th>
		
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		</tr>
		<tr>
		<th>11:30~12:00 (AM)</th>
		<td  class="today"><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		</tr>
		<tr>
		<th >12:00~12:30 (PM)</th>
		<td class="today"><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		</tr>
		<tr>
		<th>12:30~01:00 (PM)</th>
		<td  class="today"><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		</tr>
		<tr>
		<th>01:30~02:00 (PM)</th>
		<td  class="today"><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		</tr>
		<tr>
		<th>02:00~02:30 (PM)</th>
		<td  class="today"><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		</tr>
		<tr>
		<th>02:30~03:00 (PM)</th>
		<td  class="today"><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		</tr>
		<tr>
		<th>03:00~03:30 (PM)</th>
		<td  class="today"><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		</tr>
		<tr>
		<th>03:30~04:00 (PM)</th>
		<td  class="today"><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		</tr>
		<tr>
		<th>04:00~04:30 (PM)</th>
		<td  class="today"><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		</tr>
		<tr>
		<th>04:30~05:00 (PM)</th>
		<td  class="today"><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		</tr>
		<tr>
		<th>05:00~05:30 (PM)</th>
		<td  class="today"><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		</tr>
		<tr>
		<th>05:30~06:00 (PM)</th>
		<td  class="today"><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		<td><div class="meeting_obj_none" onClick="openDialog('insert_meeting')"></div></td>
		</tr>
		</tbody>
		</table>
		 
		
		
	</div>
	
	
		
			<div class="btn_box_con"><button type="button" class="btn_admin_red" onClick="launchDateUpdate(); return false;" >신제품 출시일 업데이트</button></div>
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
</div>
</form>
<div class="white_content" id="open">
	<div class="modal" style="	width: 700px;margin-left:-350px;height: 420px;margin-top:-200px;">
		<h5 style="position:relative">
			<span class="title">신제품 등록</span>
			<div  class="top_btn_box">
				<ul>
					<li>
						<button type="button" class="btn_madal_close" onClick="closeDialog('open')"></button>
					</li>
				</ul>
			</div>
		</h5>
		<div class="list_detail">
			<ul>
				<li class="pt10">
					<dt>키워드</dt>
					<dd>
						<div class="selectbox" style="width:100px;">  
								<label for="searchType" id="searchType_label">전체</label> 
								<select name="searchType" id="searchType">
									<option value="">전체</option>
									<option value="number">제품명</option>
									<option value="name">제품명</option>
									<option value="code">제품코드</option>
								</select>								
						</div>		
						<input type="text" style="width:180px; margin-left:5px; float:left;" name="searchValue" id="searchValue"/>				 
						<button type="button" class="btn_small01 ml5" onClick="searchProduct(); return false;">검색</button>
					</dd>
				</li>
				<li>
					<dt>제품정보</dt>
					<dd>		
						<table class="tbl01">
							<colgroup>
							<col width="10%">
							<col width="10%">
							<col width="10%">
							<col width="20%">
							<col width="20%">
							<col width="30%">
							</colgroup> 
							<thead>
								<tr>
									<th>체크</th>
									<th>버전</th>
									<th>제품번호</th>
									<th>제품코드</th>
									<th>제품명</th>
									<th>출시일</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td><input type="checkbox" id="launchDateCheck" name="launchDateCheck"/>
										<label for="launchDateCheck" style="padding-right:0px;"><span></span></label>
									</td>
									<td>12</td>
									<td>22</td>
									<td>22</td>
									<td>22</td>
									<td><input type="text" style="width:180px; margin-left:5px; float:left;"/></td>
								</tr>
							</tbody>
						</table>	 
					</dd>
				</li>
			</ul>
		</div>
		<div class="btn_box_con">
			<button type="button" class="btn_admin_red" id="insertForm" onClick="goInsert();">출시일 수정</button> 
			<button type="button" class="btn_admin_gray"onclick="closeDialog('open')"> 취소</button>
		</div>
	</div>
</div>

 