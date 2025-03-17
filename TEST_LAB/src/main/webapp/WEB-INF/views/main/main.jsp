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
.positionCenter{
	position: absolute;
	transform: translate(-50%, -45%);
}
</style>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	loadApprCount();
	loadMyCount();
	loadRefCount();
	loadMailCheck();
	loadCompany('');
	
	google.charts.load("current", {packages:['corechart']});
	google.charts.setOnLoadCallback(drawVisualization);
	google.charts.setOnLoadCallback(drawVisualization2);
	
	drawSellingChart();
	
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
	
	/*
	var data = google.visualization.arrayToDataTable([
		["문서", "갯수", { role: "style" } ],
        ["제품설계서", countDesignDoc, "#62acc7"],
        ["제품개발문서", countDevDoc, "#62c6c7"],
		["제조공정서", countManufacturingDoc, "#62c7b1"],
        ["디자인의뢰서", countDesignRequest, "#81909c"]
	]);
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
	*/		
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
	
	/*
	var countRegist = parseInt('${countForState.regist}');
	var countOnGoing = parseInt('${countForState.ongoing}');
	var countApprove = parseInt('${countForState.approve}');
	var countRestoration = parseInt('${countForState.restoration}');
	var loginUserId =  '${loginUserId}';
	var data = google.visualization.arrayToDataTable([
		["문서상태", "갯수", { role: "style" } ],
		["등록", countRegist, "#4b5165"],
		["진행중", countOnGoing, "#4b5165"],
		["결재완료", countApprove, "#4b5165"],
		["반려", countRestoration, "#e5584e"]
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
			fontSize: 12,
			color: '#5d6564',
			}
		}  ,
		chartArea:{left:40,top:30,width:'90%',height:'80%'}
	};
	
	var chart = new google.visualization.ColumnChart(document.getElementById("columnchart_values2"));
    chart.draw(view, options);
    */
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
	var URL = "../common/companyListAjax";
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
	});
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
			<div class="title2"><span class="txt">품목제조보고서 검색</span></div>
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
					<div class="jejo_btn_box" style="padding:20px 5px 20px 20px;"><!--button class="btn_jejo" style="width:100%;">최근일주일 리스트보기</button--></div>
					<div class="jejo_btn_box" style="padding:20px 20px 20px 5px;"><button type="button" class="btn_jejo" style="width:100%;" onClick="javascript:searchManufacturingNo('ALL','1')">전체 리스트 보기 </button></div>
				</div>
			</div>
			</div>
			<!-- 품목제조공정서 검색 close -->
	
	<div class="title2 mt30" id="selling_chart_title"><span class="txt"><strong>2019</strong> 신제품 매출</span></div>
	<div class="dashboard01">
		<div class="title" style="height:40px;">신제품 매출내역</div>
		<div id="selling_chart_div" style=""></div>
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

<form name="insert_meeting_form" id="insert_meeting_form" action="/Reserve/ReserveSaveAjax" method="post" enctype="multipart/form-data"> 
<div class="white_content" id="insert_meeting">
		<div class="modal positionCenter" id="insert_meeting_body" style="width:500px;height:440px;">
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
				<label for="startTime" id="startTime_label">선택</label>
						<select id="startTime" name="startTime">
							<option value="">선택</option>
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
				<label for="endTime" id="endTime_label">선택</label>
					<select id="endTime" name="endTime">
							<option value="">선택</option>
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
			<li>
			<dt>회의유형</dt>

<dd><input type="checkbox" id="meetingCategory"><label for="meetingCategory" style="padding-right:0px;"><span></span></label>세미나 / 외부강의
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
	<!-- 	<input type="hidden" name="reserveRoomCode" id="reserveRoomCode"/> -->
		<input type="hidden" name="isTopReserve" id="isTopReserve"/>
		<input type="hidden" name="timeCode" id="timeCode"/>
		<input type="hidden" name="meetingCategoryVal" id="meetingCategoryVal"/>
		<input type="hidden" name="weekParam" id="weekParam" value = "${weekParam}"/>
		<input type="hidden" name="selectDay" id="selectDay" value = "${selectDayParam}"/>
</div>
</form>
<!-- 품목제조보고서 검색 추가레이어 start-->
<!-- 신규로 레이어창을 생성하고싶을때는  아이디값 교체-->
<!-- 클래스 옆에 적힌 스타일 값을 인라인으로 작성해서 팝업 사이즈를 직접 조정 -->
<div class="white_content" id="dialog_manufacturingNo">
	<div class="modal positionCenter" style="width: 1000px; height: 700px">
		<h5 style="position: relative">
			<span class="title">품목제조보고서 검색</span>
			<div class="top_btn_box">
				<ul>
					<li><button class="btn_madal_close" onClick="closeManufacturingNoList()"></button></li>
				</ul>
			</div>
		</h5>

		<div id="manufacturingNoListDiv" class="code_box">
			<div class="code_box2">
				(<strong> <span id="manufacturingNoCount">0</span> </strong>)건
			</div>
			<div class="main_tbl">
				<table class="tbl08">
					<colgroup>
						<col width="8%">
						<col width="10%">
						<col width="10%">
						<col />
						<col width="8%">
						<col width="10%">
						<col width="10%">
						<col width="10%">
						<col width="10%">
					</colgroup>
					<thead>
						<tr>
							<th>플랜트</th>
							<th>보고서 번호</th>
							<th>보관조건</th>
							<th>품목명</th>
							<th>제품코드</th>
							<th>품목제조보고서</th>
							<th>처리자</th>
							<th>처리일</th>
							<th>상태</th>							
						</tr>
					</thead>
					<tbody id="manufacturingNoList">
						<tr>
							<td colspan="9">데이터가 없습니다.</td>
						</tr>
					</tbody>
				</table>
				<!-- 뒤에 추가 리스트가 있을때는 클래스명 02로 숫자변경 -->
				<div id="manufacturingNoNextPrevDiv" class="page_navi  mt10">
					<button class="btn_code_left01" onclick="searchManufacturingNo('prevPage')"></button>
					<button class="btn_code_right02" onclick="searchManufacturingNo('nextPage')"></button>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- 코드검색 추가레이어 close-->

 
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
		<li id="detailRegUser"><dt>작성자</dt><dd>AM 09:30</dd></li> 
		<li id="detailPn"><dt>인원</dt><dd>3명</dd></li>
		<li id="detailTitle"><dt>회의목적</dt><dd><strong>[중요]</strong>마켓컬리 MD초청 상품 제안 품평회</dd></li>
		<li id="detailMeetingCategory"><dt>회의유형</dt><dd>세미나/외부강의</dd></li>
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