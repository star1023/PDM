<%-- <%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<title>메인화면</title>    
	메인화면입니다.
 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="userUtil" uri="/WEB-INF/tld/userUtil.tld"%>
<%@ page session="false" %>
<script type="text/javascript" src="../resources/js/reservemeeting.js"></script>
<title>연구개발시스템</title>
<link href="../resources/css/main.css" rel="stylesheet" type="text/css" />
<style>
.popup-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0,0,0,0.5);
    z-index: 9999;
    display: flex;
    align-items: center;
    justify-content: center;
    overflow: auto; /* ✅ 만약 팝업 전체가 넘칠 경우 대비 */
}

.popup-header img {
    height: 40px;
    margin: 5px 0 5px 0;
}
   
.popup-wrapper {
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    z-index: 1000;
    width: 700px;
    background: none;
    display: flex;
    flex-direction: column;
    max-height: 80vh;
    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    border-radius: 16px;
    overflow: hidden;
}

.popup-header {
    background-color: #b32025;
    height: 60px;
    display: flex;
    align-items: center;
    padding: 0 20px;
    border-top-left-radius: 16px;
    border-top-right-radius: 16px;
    color: white;
    font-weight: bold;
    font-size: 16px;
}

.popup-container {
    background: #fff;
    overflow-y: auto;
    padding: 30px 40px;
    flex: 1; /* 본문이 남는 공간 차지 */
}

.popup-title {
    display: flex;
    justify-content: space-between;
    align-items: center;
    font-size: 24px;
    font-weight: bold;
    color: #222;
    border-bottom: 2px solid #b92c35;
    padding-bottom: 10px;
    margin-bottom: 20px;
    margin-top: 10px;
}

.notice-title {
    cursor: pointer;
    transition: color 0.2s;
}
.notice-title:hover {
    color: #b92c35;
}

.more-icon {
    display: flex;
    flex-direction: column;
    align-items: center;
    font-size: 12px;
    color: #888;
    cursor: pointer;
}
.more-icon img {
    width: 20px;
    height: 20px;
    margin-bottom: 2px;
}
.more-icon:hover {
    color: #b92c35;
}

   .popup-title .more-btn {
       cursor: pointer;
       display: flex;
       align-items: center;
       gap: 4px;
   }

   .popup-meta {
       font-size: 14px;
       color: #666;
       margin-bottom: 20px;
   	text-align: right;
   }

   .popup-content {
       font-size: 16px;
       line-height: 1.8;
       white-space: pre-wrap;
   }

   .popup-footer {
       display: flex;
       justify-content: space-between;
       align-items: center;
       margin-top: 30px;
   }

   .popup-footer label {
       font-size: 14px;
       color: #555;
   }

   .btn-close {
       background: #3c8dbc;
       color: white;
       border: none;
       padding: 8px 16px;
       font-size: 14px;
       border-radius: 4px;
       cursor: pointer;
   }

   .btn-close:hover {
       background: #337ab7;
   }
   
   .popup-footer-fixed {
    background: #fff;
    border-top: 1px solid #ddd;
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 15px 30px;
    height: 60px;
    box-sizing: border-box;
    border-bottom-left-radius: 16px;
    border-bottom-right-radius: 16px;
}
.positionCenter{
	position: absolute;
	transform: translate(-50%, -45%);
}
/* 공지사항 */
.tbl_dashboard {
    width: 100%;
    border-collapse: collapse;
    margin-top: 10px;
    border: 1px solid #c8c8c8;
}

.tbl_dashboard th, .tbl_dashboard td {
    padding: 8px;
    text-align: left;
    border-bottom: 1px solid #ddd;
}

.tbl_dashboard th {
    background-color: #f4f4f4;
    font-weight: bold;
}

.tbl_dashboard td a {
    color: #333;
    text-decoration: none;
}

.tbl_dashboard td a:hover {
    color: #d15b47; /* 강조 색상 */
}
/* 공지사항 */

</style>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	//loadApprCount();
	//loadMyCount();
	//loadRefCount();
	loadMailCheck();
	loadCompany('');
	
	// 공지사항
	fn_loadList(1);
	
	
	google.charts.load("current", {packages:['corechart']});
	//google.charts.setOnLoadCallback(drawVisualization);
	//google.charts.setOnLoadCallback(drawVisualization2);
	
	//drawSellingChart();
	
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
		beforeShow:function(input, inst){
			var offset = $('#insert_meeting_body')[0].offsetTop - 72;
			
			setTimeout(function () {
	            inst.dpDiv.css({
	                top: offset
	            });
	        }, 0);
		},
		beforeShowDay:function(date){
			var day = date.getDay();

			return [(day != 0 && day != 6)];
		},
		onSelect : function(dateText,inst){
			var today = new Date(dateText).getDay();
			var yearFormat = new Date().getFullYear();
			var monthFormat = new Date().getMonth() + 1;
			var dayFormat = new Date().getDate();
			var todayFormat = yearFormat + "-" + monthFormat + "-" +dayFormat;
			
			$("#reserveDayCode").val(today);
			var html = "<option value=\"\">선택</option>";
			var html2= "<option value=\"\">선택</option>";
			var timeAry = ['09:00', '09:30', '10:00', '10:30', 
				'11:00', '11:30', '12:00', '12:30', 
				'13:00', '13:30', '14:00', '14:30', 
				'15:00', '15:30', '16:00', '16:30', 
				'17:00', '17:30', '18:00'];
			
			if(todayFormat == dateText){
				
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

			} else {
				
				if($("#isTopReserve").val()=='Y'){
					for ( var i = 0; i < timeAry.length ; i++ ) {
						var isSelected = "";
						if( parseInt("1")-1 == i) {
							isSelected = "selected";
						}
						html += "<option value = \""+timeAry[i]+"\" "+isSelected+">"+timeAry[i]+"</option>";
				    }
					
					for ( var i = 0; i < timeAry.length ; i++ ) {
						var isSelected = "";
						if( parseInt("1") == i) {
							isSelected = "selected";
						}
						html2 += "<option value = \""+timeAry[i]+"\" "+isSelected+">"+timeAry[i]+"</option>";
				    }
				}else{
					
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
				}
			}
			
			$("#startTime").html(html);
			$("label[for=startTime]").html($("#startTime").selectedTexts()[0]);
			
			$("#endTime").html(html2);
			$("label[for=endTime]").html($("#endTime").selectedTexts()[0]);
		},
	})
	
	$('#reserveDate').siblings('img').css('margin-left', '3px');
	$('#reserveDate').siblings('img').css('margin-top', '-2px');
	
	$("#displayDateInput").datepicker({
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
			
			/* var week = new Array('일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일');
			var reserveRoomCode = $("#roomUL li.select").attr("id");
			
			var today = new Date(dateText).getDay();
			var todayLabel = week[today];
			
			location.href = "/main/main?selectDay="+dateText+"&reserveCode="+reserveRoomCode; */
			
			var week = new Array('일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일');
			
			var today = new Date(dateText).getDay();
			var todayLabel = week[today];
			
			location.href = "/main/main?selectDay="+dateText;
		},
	})
	
	$('#displayDateInput').siblings('img').css('margin-left', '8px');
	$('#displayDateInput').siblings('img').css('margin-top', '-5px');
	$('#displayDateInput').siblings('img').css('cursor', 'pointer');
	
	fileListCheck();

	
});


function drawVisualization(){
	var URL = "../main/docCountAjax";
	$.ajax({
		type:"POST",
		url:URL,
		data:{
		},		
		dataType:"json",
		success:function(data) {
			var dataArray = [["문서", "갯수", { role: "style" } ]];
			if( data.length > 0 ) {
				data.forEach(function (item) {
					if( item.type == 'DesignDoc' ){ 
						dataArray.push(["제품설계서", item.docCount, "#62acc7"]);
						$("#countDesignDoc").html(item.docCount);
					}
					if( item.type == 'DevDoc' ) {
						dataArray.push(["제품개발문서", item.docCount, "#62c6c7"]);
					}
					if( item.type == 'DesignReqDoc' ){
						dataArray.push(["제조공정서", item.docCount, "#62c7b1"]);
						$("#countManufacturingDoc").html(item.docCount);
					}
					if( item.type == 'ManufacturingDoc' ){
						dataArray.push(["디자인의뢰서", item.docCount, "#81909c"]);
					}
				}); 
			} else {
				$("#countDesignDoc").html("0");
				$("#countManufacturingDoc").html("0");
				dataArray.push(["제품설계서", parseInt("0"), "#62acc7"]);
				dataArray.push(["제품개발문서", parseInt("0"), "#62c6c7"]);
				dataArray.push(["제조공정서", parseInt("0"), "#62c7b1"]);
				dataArray.push(["디자인의뢰서", parseInt("0"), "#81909c"]);
			}
			var data = google.visualization.arrayToDataTable(dataArray);
			var view = new google.visualization.DataView(data);
			view.setColumns([0, 1,
				{calc: "stringify",
		         sourceColumn: 1,
		         type: "string",
		         role: "annotation" },
		        2]);
			
			var options = {
				backgroundColor: '#fafafa',
				bar: {groupWidth: "35%"},
				legend: { position: "none" },
				annotations: {
			    	textStyle: {
			      		fontName: 'Malgun Gothic',
			      		fontSize: 12,
			      		color: '#000',
			    	}
			  	},
				hAxis: {
			    	textStyle: {
			      		fontName: 'Malgun Gothic',
			      		fontSize: 12,
			      		color: '#5d6564',
			    	}
			  	}  ,
			   	chartArea:{left:40,top:30,width:'90%',height:'80%'}
			};
			 var chart = new google.visualization.ColumnChart(document.getElementById("columnchart_values1"));
		     chart.draw(view, options);
		},
		error:function(request, status, errorThrown){

		}			
	});	
}

function drawVisualization2(){
	var URL = "../main/docStateCountAjax";
	$.ajax({
		type:"POST",
		url:URL,
		data:{
		},		
		dataType:"json",
		success:function(data) {
			var data = google.visualization.arrayToDataTable([
				["문서상태", "갯수", { role: "style" } ],
				["등록", data.regCount, "#4b5165"],
				["진행중", data.goCount, "#4b5165"],
				["결재완료", data.compCount, "#4b5165"],
				["ERP반영", data.erpCompCount, "#62c6c7"],
				["ERP반영 오류", data.erpErrCount, "#62c6c7"],
				["반려", data.retCount, "#e5584e"]
			]);
			var view = new google.visualization.DataView(data);
			view.setColumns([0, 1,
				{ calc: "stringify",
				sourceColumn: 1,
		  		type: "string",
				role: "annotation" },
			2]);
			
			var options = {
				backgroundColor: '#fafafa',
				bar: {groupWidth: "35%"},
				legend: { position: "none" },
				annotations: {
				textStyle: {
					fontName: 'Malgun Gothic',
					fontSize: 13,
					color: '#000',
					}
				},
				hAxis: {
				textStyle: {
					fontName: 'Malgun Gothic',
					fontSize: 10,
					color: '#5d6564',
					}
				}  ,
				chartArea:{left:40,top:30,width:'90%',height:'80%'}
			};
			
			var chart = new google.visualization.ColumnChart(document.getElementById("columnchart_values2"));
		    chart.draw(view, options);
		},
		error:function(request, status, errorThrown){

		}			
	});
}

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
	
	/* var startDate = new Date($("#reserveDate").val().substr(0,4),$("#reserveDate").val().substr(5,2),$("#reserveDate").val().substr(8,2),$("#startTime").val().substr(0,2),$("#startTime").val().substr(3,2));
	
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
		
	} else{
		
		$("#meetingCategoryVal").val("N");
		
	}
	
	$("#notiYNval").val(notiYN);
/* 	$("#reserveRoomCode").val(reserveRoomCode); */
	
	if(confirm("등록하시겠습니까?")){
		$.ajax({
			type:"POST",
			url:"/Reserve/ReserveCount",
			data:{
				  "reserveDate":$("#reserveDate").val(),
				  "startTime":$("#startTime").val(),
				  "endTime":$("#endTime").val()
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

/* function selectMeetingRoom(obj){
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
	
	location.href = "/main/main?reserveCode="+id;
	
} */

function preWeek(monday){
	
/* 	var reserveRoomCode = $("#roomUL li.select").attr("id"); */
	
	/* location.href = "/main/main?selectDay="+monday+"&weekParam=P&reserveCode="+reserveRoomCode; */
	
	location.href = "/main/main?selectDay="+monday+"&weekParam=P";
}

function nextWeek(monday){
	
/* 	var reserveRoomCode = $("#roomUL li.select").attr("id"); */
	
/* 	location.href = "/main/main?selectDay="+monday+"&weekParam=N&reserveCode="+reserveRoomCode; */
 	
 	location.href = "/main/main?selectDay="+monday+"&weekParam=N";
}

function deleteReserveRoom(rmrNo,userId){
	
	var selectDay = '${selectDayParam}';
	
	var weekParam = '${weekParam}';
	
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
					location.href = "/main/main?selectDay="+selectDay+"&weekParam="+weekParam;
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
					$("#detailRegUser").html("<dt>작성자</dt><dd>"+data.detailReserve.regUserName+" / "+data.detailReserve.deptCodeName+"</dd>"); 
					$("#detailPn").html("<dt>인원</dt><dd>"+data.detailReserve.pn+"</dd>");
					
					if(data.detailReserve.notiYN == 'Y'){
						$("#detailTitle").html("<dt>회의목적</dt><dd><strong>[중요]</strong>"+data.detailReserve.title+"</dd>");
					}else{
						$("#detailTitle").html("<dt>회의목적</dt><dd><strong></strong>"+data.detailReserve.title+"</dd>");
					}
					
					if($.trim(data.detailReserve.meetingCategory) == 'Y'){
					/* 	$("#detailMeetingCategory").prop("checked",true); */
					
						$("#detailMeetingCategory").html("<dt>회의유형</dt><dd>세미나/외부강의</dd>");
					}else{
				/* 		$("#detailMeetingCategory").prop("checked",false); */
					
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

function drawSellingChart(){
	google.charts.load('current', {'packages':['bar']});
	google.charts.setOnLoadCallback(drawSellingData);
}

function drawSellingData() {
	var URL = "../selling/sellingDataListAjax";
	var today = new Date();
	var year = today.getFullYear();
	$("#selling_chart_title").html("<span class=\"txt\"><strong>"+year+"</strong> 신제품 매출</span>");
	$.ajax({
		type:"POST",
		url:URL,
		data:{
			"year":year
		},		
		dataType:"json",
		success:function(data) {
			if( data.length > 0 ) {
				var height = (58*data.length);
				var style = "width: 100%; height:"+height+"px; float:left;";
				$("#selling_chart_div").attr("style",style);
				var dataArray = [['', '상반기', '하반기', '총매출']];
				data.forEach(function (item) {
					dataArray.push([restoreStrAmp(item.titleName), (item.upSelling), (item.downSelling), (item.upSelling+item.downSelling)]);
				});
				var dataTable = new google.visualization.arrayToDataTable(dataArray);
				var options = {  
					fontName: 'Malgun Gothic',
					fontSize: 13,
			    	color: '#5d6564',
					backgroundColor:'#fafafa', 
			        chart: {},
					chartArea:{left:360, top:60, width:'70%', height:'70%'},
					bars:'horizontal',
					bar: {groupWidth: "50%"},
			       	series: {
			       		0: { color: '#f3c311' }, // Bind series 0 to an axis named 'distance'.
			            1: { color: '#3cb4e6' },
						2: { color: '#b8c3c8' }// Bind series 1 to an axis named 'brightness'.
					},
				};
	
			    var chart = new google.charts.Bar(document.getElementById('selling_chart_div'));
			    
			    var formatter = new google.visualization.NumberFormat({pattern:'###,###'});
			    	formatter.format(dataTable, 1); // Apply formatter to second column
			    	formatter.format(dataTable, 2); // Apply formatter to second column
			    	formatter.format(dataTable, 3); // Apply formatter to second column
			    	
		        chart.draw(dataTable, google.charts.Bar.convertOptions(options));
	        }
		},
		error:function(request, status, errorThrown){

		}			
	});	
}

function drawSellingData2() {
	var URL = "../selling/sellingDataListAjax";
	var today = new Date();
	var year = today.getFullYear();
	$("#selling_chart_title").html("<span class=\"txt\"><strong>"+year+"</strong> 신제품 매출</span>");
	$.ajax({
		type:"POST",
		url:URL,
		data:{
			"year":year
		},		
		dataType:"json",
		success:function(data) {
			if( data.length > 0 ) {
				var height = (58*data.length);
				var style = "width: 100%; height:"+height+"px; float:left;";
				$("#selling_chart_div").attr("style",style);
				var dataArray = [['', '상반기', '하반기', '총매출']];
				data.forEach(function (item) {
					dataArray.push([restoreStrAmp(item.titleName), (item.upSelling), (item.downSelling), (item.upSelling+item.downSelling)]);
				});
				var dataTable = new google.visualization.arrayToDataTable(dataArray);
				var options = {  
						fontName: 'Malgun Gothic',
						fontSize: 13,
				    	color: '#5d6564',
						backgroundColor:'#fafafa', 
				        chart: {},
						chartArea:{left:360, top:60, width:'70%', height:'70%'},
						bars:'horizontal',
						bar: {groupWidth: "50%"},
				       	series: {
				       		0: { color: '#f3c311' }, // Bind series 0 to an axis named 'distance'.
				            1: { color: '#3cb4e6' },
							2: { color: '#b8c3c8' }// Bind series 1 to an axis named 'brightness'.
						},
					};
	
			    var chart = new google.charts.Bar(document.getElementById('selling_chart_div'));
			    var formatter = new google.visualization.NumberFormat({pattern:'###,###'});
		    	formatter.format(dataTable, 1); // Apply formatter to second column
		    	formatter.format(dataTable, 2); // Apply formatter to second column
		    	formatter.format(dataTable, 3); // Apply formatter to second column
		        chart.draw(dataTable, google.charts.Bar.convertOptions(options));
			}
		},
		error:function(request, status, errorThrown){

		}			
	});	
}

function changeFormat(val) {
	var formatter = new  google.visualization.NumberFormat({pattern:'###,###'});
	return formatter.format(val,1);
}
function loadApprCount() {
	var URL = "../approval/apprCountTypeAjax";
	var reg = 0;
	var comp = 0;
	var ret = 0;
	$.ajax({
		type:"POST",
		url:URL,
		data:{
		},
		dataType:"json",
		success:function(data) {
			data.forEach(function (item) {
				if( item.lastState == '0' ) {
					reg = item.apprCount;
				} else if( item.lastState == '1' ) {
					comp = item.apprCount;
				} else if( item.lastState == '2' ) {
					ret = item.apprCount;
				}
			});
			$("#appr_reg").html(reg);
			$("#appr_ret").html(ret);
			$("#appr_comp").html(comp);
		},
		error:function(request, status, errorThrown){			
		}			
	});	
}

function loadMyCount() {
	var URL = "../approval/myCountTypeAjax";
	var reg = 0;
	var comp = 0;
	var ret = 0;
	$.ajax({
		type:"POST",
		url:URL,
		data:{
		},
		dataType:"json",
		success:function(data) {
			data.forEach(function (item) {
				if( item.lastState == '0' ) {
					reg = item.apprCount;
				} else if( item.lastState == '1' ) {
					comp = item.apprCount;
				} else if( item.lastState == '2' ) {
					ret = item.apprCount;
				}
			});
			$("#my_reg").html(reg);
			$("#my_ret").html(ret);
			$("#my_comp").html(comp);
		},
		error:function(request, status, errorThrown){			
		}			
	});	
}

function loadRefCount() {
	var URL = "../approval/refTotalCountAjax";
	var reg = 0;
	var comp = 0;
	var ret = 0;
	$.ajax({
		type:"POST",
		url:URL,
		data:{
		},
		dataType:"json",
		success:function(data) {
			$("#ref_today").html(data.refCount);
			$("#ref_total").html(data.totalCount);
		},
		error:function(request, status, errorThrown){			
		}			
	});	
}

function loadMailCheck() {
	var mailCheck1 = '${userUtil:getMailCheck1(pageContext.request)}';
	var mailCheck2 = '${userUtil:getMailCheck2(pageContext.request)}';
	var mailCheck3 = '${userUtil:getMailCheck3(pageContext.request)}';
	if(mailCheck1 == null || mailCheck1 == '' || mailCheck1 == 'Y') {
		$("#mailCheck1").prop("class","check_on");
		$("#mailCheck1Value").val("Y");
	} else {
		$("#mailCheck1").prop("class","check_off");
		$("#mailCheck1Value").val("N");
	}
	if(mailCheck2 == null || mailCheck2 == '' || mailCheck2 == 'Y') {
		$("#mailCheck2").prop("class","check_on");
		$("#mailCheck2Value").val("Y");
	} else {
		$("#mailCheck2").prop("class","check_off");
		$("#mailCheck2Value").val("N");
	}
	if(mailCheck3 == null || mailCheck3 == '' || mailCheck3 == 'Y') {
		$("#mailCheck3").prop("class","check_on");
		$("#mailCheck3Value").val("Y");
	} else {
		$("#mailCheck3").prop("class","check_off");
		$("#mailCheck3Value").val("N");
	}
}

function setPersonalizationMain(type) {
	var URL = "../user/setPersonalizationAjax";
	var value = "N";
	if( $("#"+type+"Value").val() == 'Y') {
		value = "N";
	} else {
		value = "Y";
	}
	$.ajax({
		type:"POST",
		url:URL,
		data:{
			"type" : type,
			"value" : value
		},
		dataType:"json",
		success:function(data) {
			if( value == 'Y' ) {
				$("#"+type).prop("class","check_on");
				$("#"+type+"Value").val("Y");
			} else {
				$("#"+type).prop("class","check_off");
				$("#"+type+"Value").val("N");
			}
		},
		error:function(request, status, errorThrown){
		}			
	});	
}

//알림 팝업 호출
function showLeftMain(){
	resetleftLi();
	loadNotificationList();
	$("#showLeft2").addClass('active');
	$('#cbp-spmenu-s2').addClass('cbp-spmenu-open');
}

function loadCompany(companyCode) {
	/* var URL = "../common/companyListAjax";
	$.ajax({
		type:"POST",
		url:URL,
		data:{
		},
		dataType:"json",
		success:function(data) {
			var html = "";
			$("#main_company_ul").html(html);
			var count = 0;
			data.RESULT.forEach(function (item) {
				if( companyCode == '' ) {
					if( count == 0 ) {
						html += "<li class=\"select\"><a href=\"#\">"+item.companyName+"</a></li>";
						$("#searchCompay").val(item.companyCode);
						loadPlant( item.companyCode );
					} else {
						html += "<li class=\"\"><a href=\"javascript:loadCompany('"+item.companyCode+"')\">"+item.companyName+"</a></li>";
					}
					count++;
				} else {
					if( companyCode == item.companyCode ) {
						html += "<li class=\"select\"><a href=\"#\">"+item.companyName+"</a></li>";
						$("#searchCompay").val(item.companyCode);
						loadPlant( item.companyCode );
					} else {
						html += "<li class=\"\"><a href=\"javascript:loadCompany('"+item.companyCode+"')\">"+item.companyName+"</a></li>";
					}
				}
			});
			$("#main_company_ul").html(html);
		},
		error:function(request, status, errorThrown){
		}			
	}); */
}

function loadPlant( companyCode ) {
	var URL = "../common/plantListAjax";
	$.ajax({
		type:"POST",
		url:URL,
		data:{
			"companyCode":companyCode
		},
		dataType:"json",
		success:function(data) {
			var html = "";
			$("#main_plant_ul").html(html);
			//html += "<li class=\"select\"><a href=\"#\">전체</a></li>";
			var count = 0;
			data.RESULT.forEach(function (item) {
				if( count == 0 ) {
					html += "<li id=\"main_plant_li_"+item.plantCode+"\" class=\"select\"><a href=\"javascript:changePlant('"+item.plantCode+"')\">"+item.plantName+"</a></li>";
					$("#searchPlant").val(item.plantCode);
				} else {
					html += "<li id=\"main_plant_li_"+item.plantCode+"\" class=\"\"><a href=\"javascript:changePlant('"+item.plantCode+"')\">"+item.plantName+"</a></li>";
				}
				count++;
			});
			$("#main_plant_ul").html(html);
		},
		error:function(request, status, errorThrown){
		}			
	});
}
function changePlant( plantCode ) {
	$("#main_plant_ul").children().toArray().forEach(function (v, i) {
		$(v).prop("class","");
		if ($(v).prop("id") == "main_plant_li_"+plantCode){
			$(v).prop("class","select");
		}
	});
	$("#searchPlant").val(plantCode);
}

function searchManufacturingNo(searchListType, pageNo) {
	$("#searchListType").val(searchListType);
	var companyCode = '';
	var plantCode = '';
	var searchType = '';
	var searchValue = '';
	var searchListType = $("#searchListType").val();
	if( searchListType != 'ALL' ) {
		var companyCode = $("#searchCompany").val();
		var plantCode = $("#searchPlant").val();
		var searchType = $(":input:radio[name=searchType]:checked").val();
		var searchValue = $("#searchValue").val();
		if( searchType == 'NO' ) {
			var regexp = /^[0-9]*$/
			if( !regexp.test(searchValue) ) {
				alert("품목번호는 숫자만 입력가능합니다.");
				$("#searchValue").val("");
				$("#searchValue").focus();
				return;
			}
		}	
	}
	var URL = "../manufacturingNo/manufacturingNoListAjax";
	$.ajax({
		type:"POST",
		url:URL,
		data:{
			"searchCompany":companyCode,
			"searchPlant":plantCode,
			"searchType":searchType,
			"searchValue":searchValue,
			"pageNo":pageNo
		},
		dataType:"json",
		success:function(data) {
			var html = "";
			$("#manufacturingNoCount").html(data.totalCount);
			if( data.totalCount > 0 ) {
				$("#manufacturingNoList").html(html);
				data.manufacturingNoList.forEach(function (item) {
					var productCode = item.productCodes.split(',');
					html += "<tr>"
					html += "	<td>"+item.plantName+"</td>";
					html += "	<td>"+item.manufacturingNo+"</td>";
					html += "	<td>"+nvl(item.keepConditionName,"")+"</td>";
					html += "	<td>"+item.manufacturingName+"";
					html += "	<br/>("+nvl(item.sellDate,"")+")";
					html += "	</td>";
					html += "	<td>";
					for( var i = 0 ; i < productCode.length ; i++ ) {
						if( i != 0 ) {
							html += "<div style='margin-top:3px;'>";
						} else {
							html += "<div>";
						}
						html += productCode[i]+"</div>";
					}
					html += "	</td>";
					if( item.fmNo != '' && item.fmNo != null ) {
						html += "	<td><a href=\"javascript:fileDownload('"+item.fmNo+"')\"><img src=\"/resources/images/icon_file01.png\" style=\"vertical-align:middle;\"/></td>";
					} else {
						html += "	<td>&nbsp;</td>";
					}
					html += "	<td>"+item.userName+"</td>";
					html += "	<td>"+item.regDate+"</td>";
					html += "	<td>"+item.regTypeName+"</td>";
					html += "</tr>"
				});
				$('.page_navi').html(data.navi.prevBlock+data.navi.pageList+data.navi.nextBlock);
				$('#pageNo').val(data.navi.pageNo);
			} else {
				$("#manufacturingNoList").html(html);
				html += "<tr><td align='center' colspan='9'>데이터가 없습니다.</td></tr>";
			}
			$("#manufacturingNoList").html(html);
			openDialog('dialog_manufacturingNo');
		},
		error:function(request, status, errorThrown){
		}
	});
}

function closeManufacturingNoList() {
	closeDialog('dialog_manufacturingNo');
}

//페이징
function paging(pageNo){
	//location.href = '../material/list?' + getParam(pageNo);
	searchManufacturingNo($("#searchListType").val(), pageNo);
}

//파일 다운로드
function fileDownload(fmNo){
	location.href="/file/fileDownload?fmNo="+fmNo;
}


// 공지사항 //
function fn_loadList(pageNo = 1) {
    const viewCount = 7;  // 공지사항 7개만 표시

    $.ajax({
        type: "POST",
        url: "/boardNotice/selectNoticeListAjax", // API 엔드포인트
        data: {
            searchType: $("#searchType").val(),
            searchValue: $("#searchValue").val(),
            searchStartDate: $("#searchStartDate").val(),
            searchEndDate: $("#searchEndDate").val(),
            searchNoticeType: $("#searchNoticeType").val(),
            viewCount: viewCount,
            pageNo: pageNo
        },
        dataType: "json",
        success: function (data) {
            fn_renderDashboardList(data.list);
            fn_noticePopupFromList(data.list);  // 여기에 팝업 조건 체크
        },
        error: function (xhr, status, err) {
            alert("조회 중 오류 발생: " + err);
        }
    });
}

function fn_renderDashboardList(list) {
    const $dashboard = $(".dashboard02");
    $dashboard.empty();

    if (!list || list.length === 0) {
        $dashboard.append("<p>공지사항이 없습니다.</p>");
        return;
    }

    let tableHtml = "<table class='tbl_dashboard' style='font-size: 14px; width: 100%;'><thead><tr>";
    tableHtml += "<th style='text-align: center;'></th><th style='text-align: center;'>제목</th><th style='text-align: center;'>작성자</th><th style='text-align: center;'>등록일</th><th style='text-align: center;'>조회수</th></tr></thead><tbody>";

    list.forEach(function (item) {
        const isNotice = item.TYPE === "I";
        const isValidPeriod = isNotice && isNoticePeriodValid(item.POST_START_DATE, item.POST_END_DATE);
        const trStyle = isNotice && isValidPeriod ? "style='background-color: rgba(255, 0, 0, 0.06);'" : "";

        let iconHtml = "";
        if (isNotice) {
            const iconStyle = isValidPeriod
                ? "filter: brightness(0) saturate(100%) invert(19%) sepia(94%) saturate(7468%) hue-rotate(353deg) brightness(89%) contrast(102%);"
                : "";

            iconHtml = "<span style='margin-left: 12px; display: inline-flex; align-items: center; gap: 15px;'>" +
                        "<img src='/resources/images/icon_megaphone.png' style='width: 14px; height: 14px; " + iconStyle + "' />" +
                        "<img src='/resources/images/lab_notice_handwriting.png' style='height: 14px; width: 60px; " + iconStyle + "' alt='Notice!'/>" +
                        "</span>";
        }

        tableHtml += "<tr " + trStyle + ">";
        tableHtml += "<td style='width: 140px; text-align:center;'>" + iconHtml + "</td>";
        tableHtml += "<td style='text-align: center; width: 500px;'><a href=\"javascript:fn_viewDetail(" + item.BNOTICE_IDX + ");\">" + item.TITLE + "</a></td>";
        tableHtml += "<td style='text-align: center;'>" + item.REG_USER + "</td>";
        tableHtml += "<td style='text-align: center;'>" + item.REG_DATE + "</td>";
        tableHtml += "<td style='text-align: center;'>" + item.HITS + "</td>"; // 조회수 추가
        tableHtml += "</tr>";
    });

    tableHtml += "</tbody></table>";
    $dashboard.append(tableHtml);
}

function isNoticePeriodValid(startDateStr, endDateStr) {
    if (!startDateStr || !endDateStr) return false;

    const startDate = new Date(startDateStr);
    const endDate = new Date(endDateStr);
    const today = new Date();

    // 시간을 00:00:00으로 설정하여 날짜 비교
    startDate.setHours(0, 0, 0, 0);
    endDate.setHours(23, 59, 59, 999);
    today.setHours(0, 0, 0, 0);

    return startDate <= today && today <= endDate;
}

function fn_viewDetail(idx) {
	location.href = "/boardNotice/view?idx=" + idx;
}

//공지사항 //

// popup //
function getCookie(name) {
    const match = document.cookie.match(new RegExp("(^| )" + name + "=([^;]+)"));
    return match ? match[2] : null;
}

let popupNoticeQueue = [];

function fn_noticePopupFromList(list) {
    if (!list || list.length === 0) return;

    const today = new Date();
    today.setHours(0, 0, 0, 0);

    popupNoticeQueue = list.filter(function(item) {
        if (item.IS_POPUP !== 'Y') return false;

        const skip = getCookie("notice_skip_" + item.BNOTICE_IDX);
        if (skip === "Y") return false;

        const start = new Date(item.POP_START_DATE);
        const end = new Date(item.POP_END_DATE);
        start.setHours(0, 0, 0, 0);
        end.setHours(23, 59, 59, 999);

        return start <= today && today <= end;
    });

    if (popupNoticeQueue.length > 0) {
        showNextNoticePopup();
    }
}

function showNextNoticePopup() {
    if (popupNoticeQueue.length === 0) {
        $("#noticeLayerPopup").hide();
        return;
    }

    const notice = popupNoticeQueue.shift();

    $("#popupNoticeTitle").text(notice.TITLE);
    $("#popupNoticeMeta").text("작성자: " + notice.REG_USER + " | 등록일: " + notice.REG_DATE);
    $("#popupNoticeContent").empty().html(notice.CONTENT);

    $("#popupNoticeTitle, .more-icon").data("noticeId", notice.BNOTICE_IDX);
    $("#popupTodaySkip").prop("checked", false);

    // 팝업 열기 + fadeIn 후 바로 스크롤 0
    $("#noticeLayerPopup").fadeIn(function () {
        $(".popup-container").scrollTop(0); // ✅ 정확한 스크롤 타겟
    });
}


function closeNoticeLayerPopup() {
    const currentId = $("#popupNoticeTitle").data("noticeId");
    const skip = $("#popupTodaySkip").is(":checked");

    if (skip && currentId) {
        const expires = new Date();
        expires.setHours(23, 59, 59, 999);
        document.cookie = "notice_skip_" + currentId + "=Y; expires=" + expires.toUTCString() + "; path=/";
    }

    $("#noticeLayerPopup").fadeOut(() => {
        showNextNoticePopup(); // 다음 팝업 표시
    });
}

function goToDetail() {
    const id = $("#popupNoticeTitle").data("noticeId");
    if (id) {
        location.href = "/boardNotice/view?idx=" + id;
    }
}
// popup //
</script>
<div class="wrap_in" id="fixNextTag">
	<span class="path"><a href="#">연구소</a>
	</span>
	<section class="type01">
				<h2 style="position:relative"><span class="title_s">System main</span>
	<span class="title">PDM 시스템</span>

	</h2>
		<div class="group01" >
		<!-- 내정보 start -->
			<div class="main_top_box">
			<div class="my_info">
			<div class="title2"><span class="txt">내 정보</span></div>
				<div class="my_info_box">
					<div class="my_info_box_top">
						<div class="main_logo_img"></div>
						<span class="user_name">${userUtil:getUserName(pageContext.request)}<strong class="ml5">${userUtil:getDeptCodeName(pageContext.request)}</strong></span>
						<span class="user_sub_info">제품 설계서 <strong id="countDesignDoc">0</strong> 건 <em>&nbsp;|&nbsp;</em> 제조공정서 <strong  id="countManufacturingDoc"></strong> 건</span>
						<div class="main_bell" onClick="showLeftMain()"><span class="bell01" id="main_bell">1</span></div>
						<!-- <span class="logout_txt"><a href="../user/logout">로그아웃</a></span> -->
						<span class="logout_txt">최근알림</span>
					</div>
					<div class="my_info_box_bottom">
						<div class="fl" style="width:70%; border-right:1px solid #c8c8c8;  box-sizing:border-box; ">
							<div class="title">결재함</div>
							<div class="bottom_box_con01">
							<ul>
							<li><span><strong><a href="../approval/list" id="my_reg">0</a></strong><em>/</em><a href="#" id="my_ret">0</a><em>/</em><span id="my_comp">0</span></span><br/>올린 결재 문서<br/><em>(대기/반려/완료)</em></li>
							<li><span><strong><a href="../approval/approvalList" id="appr_reg">0</a></strong><em>/</em><a href="#" id="appr_ret">0</a><em>/</em><span id="appr_comp">0</span></span><br/>받은 결재 문서<br/><em>(대기/반려/완료)</em></li>
							<li><span><strong><a href="../approval/refList" id="ref_today">0</a></strong><em>/</em><a href="#" id="ref_total">0</a></span><br/>참조,회신 문서<br/><em>(당일/전체)</em></li>
							</ul>
							</div>
					</div>
						<div class="fl" style="width:30%">
						<div class="title">메일 수신함 설정</div>
						<div class="bottom_box_con02">
							<ul>
							<li><span>BOM 반영수신</span><button type="button" class="check_on" onClick="setPersonalizationMain('mailCheck1')" id="mailCheck1"></button><input type="hidden" name="mailCheck1Value" id="mailCheck1Value" value="Y"></li>
							<li><span>제조공정 변경수신</span><button type="button" class="check_off" onClick="setPersonalizationMain('mailCheck2')" id="mailCheck2"></button><input type="hidden" name="mailCheck2Value" id="mailCheck2Value" value="Y"></li>
							<li><span>결재요청수신</span><button type="button" class="check_off" onClick="setPersonalizationMain('mailCheck3')" id="mailCheck3"></button><input type="hidden" name="mailCheck3Value" id="mailCheck3Value" value="Y"></li>
							</ul>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- 내정보 close-->
			<!-- 사이공백 -->
			<div class="main_top_box_blank"></div>
			<!-- 품목제조공정서 검색 start -->
			
			<div class="main_jejo">
			<div class="title2"><span class="txt">원료 검색</span></div>
			<div class="main_jejo_box" >
					<div class="tab05">
						<ul id="main_company_ul">
						<li class="select"><a href="#">삼립</a></li>
						<li><a href="#">샤니</a></li>
						<li><a href="#">밀다원</a></li>
						<li><a href="#">에그팜</a></li>
						<li><a href="#">그릭슈바인</a></li>
						</ul>
					</div>
					<div class="tab05_sub">
						<ul id="main_plant_ul">
						<li class="select"><a href="#">전체</a></li>
						<li><a href="#">시화</a></li>
						<li><a href="#">대구</a></li>
						</ul>
					</div>
					<form id="form1" method="post" action="">
					<div class="jejo_radio"><input type="radio" id="r1" name="searchType" value="NO" checked/ ><label for="r1"><span></span>품목번호</label></div>
					<div class="jejo_radio"><input type="radio" id="r2" name="searchType" value="NAME" /><label for="r2"><span></span>품목제조보고명</label></div>
					</form>
					<div class="fl" style="width:100%;">
						<div class="code_box">
							<input type="text" class="code_input" name="searchValue" id="searchValue" style="width:330px;background-color:#fafafa;" placeholder="검색어입력" style="background-color:#fafafa;"><a href="javascript:searchManufacturingNo('','1')"><img src="/resources/images/icon_code_search.png"/></a>
							<input type="hidden" name="searchCompay" id="searchCompay">
							<input type="hidden" name="searchPlant" id="searchPlant" >
							<input type="hidden" name="searchListType" id="searchListType" value="ALL">
						</div>
					</div>
					<div class="jejo_btn_box" style="padding:20px 5px 20px 20px;"></div>
					<div class="jejo_btn_box" style="padding:20px 20px 20px 5px;"><button type="button" class="btn_jejo" style="width:100%;" onClick="javascript:searchManufacturingNo('ALL','1')">전체 리스트 보기 </button></div>
				</div>
			</div>
			</div>
			
			<!-- 품목제조공정서 검색 close -->

	<div class="title2 mt10"><span class="txt">공지사항</span></div>
	<div class="dashboard02">
		
	</div>
	
	<div class="title2 mt30"><span class="txt">내문서 현황</span></div>
	<div class="dashboard01">
		<div class="title">${userUtil:getUserName(pageContext.request)}님의 분류별 문서 현황</div>
		<div class="title" style="width:5%">&nbsp;</div>
		<div class="title">${userUtil:getUserName(pageContext.request)}님의 결재 상태별 문서 현황</div>
		<div id="columnchart_values1" style="width: 47%; height:250px; float:left"></div>
		<div class="title" style="width:5%">&nbsp;</div>
		<div id="columnchart_values2" style=" width: 47%; height:250px; float:left"></div>
	</div>
				<div class="btn_box_con"></div>
			<hr class="con_mode"/><!-- 신규 추가 꼭 데려갈것 !-->
		</div>
		<!-- 컨텐츠 close-->	
	</section>
</div>	

<!-- 🔔 공지사항 팝업 레이어 -->
<div id="noticeLayerPopup" class="popup-overlay" style="display:none;">
  <div class="popup-wrapper">
    <!-- 헤더 -->
    <div class="popup-header">
        <img src="/resources/images/bbq_logo.png" alt="BBQ Logo">
    </div>

    <!-- 팝업 본체 -->
    <div class="popup-container">
      <div class="popup-title">
          <span class="notice-title" id="popupNoticeTitle" onclick="goToDetail()"></span>
          <div class="more-icon" onclick="goToDetail()">
              <img src="/resources/images/icon_more.png" alt="돋보기" />
              <div>More</div>
          </div>
      </div>
      <div class="popup-meta" id="popupNoticeMeta"></div>
      <div class="popup-content" id="popupNoticeContent"></div>
    </div>

    <!-- 푸터 고정 -->
    <div class="popup-footer-fixed">
        <label><input type="checkbox" id="popupTodaySkip"> 오늘 하루 보지 않기</label>
        <button class="btn-close" onclick="closeNoticeLayerPopup()">닫기</button>
    </div>
  </div>
</div>