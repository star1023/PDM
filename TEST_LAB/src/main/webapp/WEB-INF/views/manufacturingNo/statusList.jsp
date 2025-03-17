<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ page session="false" %>
<%@ page import="kr.co.aspn.util.*" %> 
<%
	String userGrade = UserUtil.getUserGrade(request);
	String userDept = UserUtil.getDeptCode(request);
	String userTeam = UserUtil.getTeamCode(request);
	String isAdmin = UserUtil.getIsAdmin(request);
%>
<title>품목제조 보고서</title>
<link href="/resources/js/jquery.auto-complete.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="/resources/js/jquery.auto-complete.js"></script>
<script type="text/javascript">
var isValid ;
$(document).ready(function(){
	loadStatus();
	$("#currentStatus").val("N");
	loadList(1);
	//datepicker를 이용한 달력(기간) 설정
	$("#reportSDate").datepicker({
		dateFormat: "yy-mm-dd",
		showOn: "button",
	    buttonImage: "/resources/images/btn_calendar.png",
	    buttonImageOnly: true
	});
});

function initStatus() {
	$("#tab_list").children('a').toArray().some(function(a, i){		
		if( i == 0 ) {
			$(a).children('li').prop('class','select');
		} else {
			$(a).children('li').prop('class','');			
		}
		$(a).children('li').children('span').html("00");
	})
}
function loadStatus() {
	var URL = "../manufacturingNo/selectManufacturingStatusCountAjax";
	initStatus();
	$.ajax({
		type:"POST",
		url:URL,
		data:{},
		dataType:"json",
		success:function(data) {
			data.statusCount.forEach(function (item) {					
				$("#COUNT_"+item.status).html(item.CNT);
			});	
		},
		error:function(request, status, errorThrown){			
		}			
	});	
}

function changeTab(id) {
	$("#tab_list").children('a').toArray().some(function(a, j){		
		if( ("TAB_"+id) == $(a).children('li').prop('id') ) {
			$(a).children('li').prop('class','select');
			$("#currentStatus").val(id);
			loadList(1);
			changeHeader(id);
		} else {
			$(a).children('li').prop('class','');			
		}
	})
}
function changeHeader(id) {
	switch(id) {
		case 'N':
			$("#colgroup").html(document.getElementById("group1").innerHTML);
			$("#header").html(document.getElementById("head1").innerHTML);
		case 'P':
			$("#colgroup").html(document.getElementById("group1").innerHTML);
			$("#header").html(document.getElementById("head1").innerHTML);
			break;
		case 'RE':
			$("#colgroup").html(document.getElementById("group2").innerHTML);
			$("#header").html(document.getElementById("head2").innerHTML);
	    	break;
	  	case 'C':
	  		$("#colgroup").html(document.getElementById("group3").innerHTML);
			$("#header").html(document.getElementById("head3").innerHTML);
		    break;
	  	case 'RC':
	  		$("#colgroup").html(document.getElementById("group4").innerHTML);
			$("#header").html(document.getElementById("head4").innerHTML);
			break;
	  	case 'RS':
	  		$("#colgroup").html(document.getElementById("group5").innerHTML);
			$("#header").html(document.getElementById("head5").innerHTML);
	  		break;
	  	case 'S':
	  		$("#colgroup").html(document.getElementById("group6").innerHTML);
			$("#header").html(document.getElementById("head6").innerHTML);
		    break;
		case 'AS':
			$("#colgroup").html(document.getElementById("group7").innerHTML);
			$("#header").html(document.getElementById("head7").innerHTML);
			break;
	}	
}

function loadList( pageNo ) {
	$("#list").html("<tr><td align='center' colspan='9'>조회중입니다.</td></tr>");
	var URL = "../manufacturingNo/selectManufacturingNoStatusListAjax";
	var currentStatus = $("#currentStatus").val();
	$.ajax({
		type:"POST",
		url:URL,
		data:{
			"pageNo":pageNo,
			"status":currentStatus
		},
		dataType:"json",
		success:function(data) {
						
			//$("#list").html("<tr><td align='center' colspan='9'>데이터가 없습니다.</td></tr>");
			var html = "";
			if( data.totalCount > 0 ) {
				var index = 0;
				data.manufacturingNoList.forEach(function (item) {
					switch(currentStatus) {
						case 'N':
							html += "<tr>";
							html += "	<td>"+item.plnatName+"</td>";
							html += "	<td><a href=\"#\" onClick=\"goView('"+item.seq+"','"+item.versionNo+"','"+item.licensingNo+"','"+item.manufacturingNo+"')\">"+item.licensingNo+"-"+item.manufacturingNo+"</a></td>";
							html += "	<td><div class=\"ellipsis_txt tgnl\"><a href=\"#\" onClick=\"goView('"+item.seq+"','"+item.versionNo+"','"+item.licensingNo+"','"+item.manufacturingNo+"')\">"+item.manufacturingName+"</a></div></td>";
							html += "	<td><div class=\"ellipsis_txt tgnl\">"+item.productType1Name+" / "+nvl(item.productType2Name,"")+" / "+nvl(item.productType3Name,"")+"</div></td>";
							html += "	<td>"+nvl(item.launchDate,'')+"</td>";
							html += "	<td>"+nvl(item.regDate,'')+"</td>";
							html += "	<td>";
							html += "		<ul class=\"list_ul\">";
							html += "			<li><button type=\"button\" class=\"btn_doc\" onClick=\"openView('"+item.mNoD_seq+"');\"><img src=\"/resources/images/icon_doc01.png\">상세보기</button></li>";
							html += "		</ul>";
							html += "	</td>";
							html += "</tr>";
							break;
						case 'P':
							html += "<tr>";
							html += "	<td>"+item.plnatName+"</td>";
							html += "	<td><a href=\"#\" onClick=\"goView('"+item.seq+"','"+item.versionNo+"','"+item.licensingNo+"','"+item.manufacturingNo+"')\">"+item.licensingNo+"-"+item.manufacturingNo+"</a></td>";
							html += "	<td><div class=\"ellipsis_txt tgnl\"><a href=\"#\" onClick=\"goView('"+item.seq+"','"+item.versionNo+"','"+item.licensingNo+"','"+item.manufacturingNo+"')\">"+item.manufacturingName+"</a></div></td>";
							html += "	<td><div class=\"ellipsis_txt tgnl\">"+item.productType1Name+" / "+nvl(item.productType2Name,"")+" / "+nvl(item.productType3Name,"")+"</div></td>";
							html += "	<td>"+nvl(item.launchDate,'')+"</td>";
							html += "	<td>"+nvl(item.regDate,'')+"</td>";
							html += "	<td>";
							html += "		<ul class=\"list_ul\">";
							html += "			<li><button type=\"button\" class=\"btn_doc\" onClick=\"openPopup1('"+item.seq+"','"+item.status+"','open1');\"><img src=\"/resources/images/icon_doc02.png\">신고일</button></li>";
							html += "			<li><button type=\"button\" class=\"btn_doc\" onClick=\"openView('"+item.mNoD_seq+"');\"><img src=\"/resources/images/icon_doc01.png\">상세보기</button></li>";
							//html += "			<a href=\"javascript:openPopup1('"+item.seq+"','"+item.status+"','open1');\">신고일등록</a>";
							//html += "			<a href=\"javascript:openView('"+item.seq+"');\">상세</a>";
							html += "		</ul>";
							html += "	</td>";
							html += "</tr>";
							break;
						case 'RE':
							html += "<tr>";
							html += "	<td>"+item.plnatName+"</td>";
							html += "	<td><a href=\"#\" onClick=\"goView('"+item.seq+"','"+item.versionNo+"','"+item.licensingNo+"','"+item.manufacturingNo+"')\">"+item.licensingNo+"-"+item.manufacturingNo+"</a></td>";
							html += "	<td><div class=\"ellipsis_txt tgnl\"><a href=\"#\" onClick=\"goView('"+item.seq+"','"+item.versionNo+"','"+item.licensingNo+"','"+item.manufacturingNo+"')\">"+item.manufacturingName+"</a></div></td>";
							html += "	<td><div class=\"ellipsis_txt tgnl\">"+item.productType1Name+" / "+nvl(item.productType2Name,"")+" / "+nvl(item.productType3Name,"")+"</div></td>";
							html += "	<td>"+nvl(item.launchDate,'')+"</td>";
							html += "	<td>"+nvl(item.reportEDate,"")+"</td>";
							html += "	<td>"+nvl(item.prevStatusName,"")+"</td>";
							html += "	<td></td>";
							html += "	<td>";
							html += "		<ul class=\"list_ul\">";
							html += "			<li><button type=\"button\" class=\"btn_doc\" onClick=\"openView('"+item.mNoD_seq+"');\"><img src=\"/resources/images/icon_doc01.png\">상세보기</button></li>";
							html += "		</ul>";
							html += "	</td>";
							html += "</tr>";
					    	break;
					  	case 'C':
					  		html += "<tr>";
							var mnData = "data-licensingNo=\"" + item.licensingNo + "\" data-seq=\"" + item.seq + "\" ";
							mnData += "data-manufacturingNo=\"" + item.manufacturingNo + "\" data-companyCode=\"" + item.companyCode + "\" ";
							html += "	<td><input type=\"checkbox\" name=\"check_manufacturingNo\" id=\"mNo_"+index+"\" " + mnData + " /><label style=\"padding:0;\" for=\"mNo_"+index+"\"><span style=\"margin:0;\"></span></label></td>";
							html += "	<td>"+item.plnatName+"</td>";
							html += "	<td><a href=\"#\" onClick=\"goView('"+item.seq+"','"+item.versionNo+"','"+item.licensingNo+"','"+item.manufacturingNo+"')\">"+item.licensingNo+"-"+item.manufacturingNo+"</a></td>";
							html += "	<td><div class=\"ellipsis_txt tgnl\"><a href=\"#\" onClick=\"goView('"+item.seq+"','"+item.versionNo+"','"+item.licensingNo+"','"+item.manufacturingNo+"')\">"+item.manufacturingName+"</a></div></td>";
							html += "	<td><div class=\"ellipsis_txt tgnl\">"+item.productType1Name+" / "+nvl(item.productType2Name,"")+" / "+nvl(item.productType3Name,"")+"</div></td>";
							html += "	<td>"+nvl(item.reportEDate,"")+"</td>";
							html += "	<td>"+nvl(item.launchDate,'')+"</td>";
							html += "	<td>"+nvl(item.prevStatusName,"")+"</td>";
							html += "	<td>";
							html += "		<ul class=\"list_ul\">";
							html += "			<li><button type=\"button\" class=\"btn_doc\" onClick=\"openView('"+item.mNoD_seq+"');\"><img src=\"/resources/images/icon_doc01.png\">상세보기</button></li>";
							html += "			<li><button class=\"btn_doc\" onclick=\"apprFunc.openStopMNoAppr('" + item.seq + "');\"><img src=\"/resources/images/icon_doc06.png\">중단요청</button></li>";
							html += "		</ul>";
							html += "	</td>";
							html += "</tr>";
						    break;
					  	case 'RC':
					  		html += "<tr>";
							html += "	<td>"+item.plnatName+"</td>";
							html += "	<td><a href=\"#\" onClick=\"goView('"+item.seq+"','"+item.versionNo+"','"+item.licensingNo+"','"+item.manufacturingNo+"')\">"+item.licensingNo+"-"+item.manufacturingNo+"</a></td>";
							html += "	<td><div class=\"ellipsis_txt tgnl\"><a href=\"#\" onClick=\"goView('"+item.seq+"','"+item.versionNo+"','"+item.licensingNo+"','"+item.manufacturingNo+"')\">"+item.manufacturingName+"</a></div></td>";
							html += "	<td><div class=\"ellipsis_txt tgnl\">"+item.productType1Name+" / "+nvl(item.productType2Name,"")+" / "+nvl(item.productType3Name,"")+"</div></td>";
							html += "	<td>"+nvl(item.launchDate,'')+"</td>";
							html += "	<td>"+nvl(item.versionUpReqDate,'')+"</td>";
							html += "	<td>";
							html += "		<ul class=\"list_ul\">";
							html += "			<li><button type=\"button\" class=\"btn_doc\" onClick=\"openPopup1('"+item.seq+"','"+item.status+"','open1');\"><img src=\"/resources/images/icon_doc02.png\">신고일</button></li>";
							html += "			<li><button type=\"button\" class=\"btn_doc\" onClick=\"openView('"+item.mNoD_seq+"');\"><img src=\"/resources/images/icon_doc01.png\">상세보기</button></li>";
							html += "		</ul>";
							html += "	</td>";
							html += "</tr>";
							break;
					  	case 'RS':
							var gridCheckbox = "<input type='checkbox' name='check_seq' id='check_" + index + "' " +
									"data-seq='" + item.seq + "' " +
									"data-status='" + item.status + "' " +
									"data-nextStatus='S' " +
									"data-licensingNo='" + item.licensingNo + "' " +
									"data-manufacturingNo='" + item.manufacturingNo + "' />";
							gridCheckbox += "<label style=\"padding:0;\" for=\"check_"+index+"\"><span style=\"margin:0;\"></span></label>";
					  		html += "<tr>";
							html += "	<td>" + gridCheckbox + "</td>";
							html += "	<td>"+item.plnatName+"</td>";
							html += "	<td><a href=\"#\" onClick=\"goView('"+item.seq+"','"+item.versionNo+"','"+item.licensingNo+"','"+item.manufacturingNo+"')\">"+item.licensingNo+"-"+item.manufacturingNo+"</a></td>";
							html += "	<td><div class=\"ellipsis_txt tgnl\"><a href=\"#\" onClick=\"goView('"+item.seq+"','"+item.versionNo+"','"+item.licensingNo+"','"+item.manufacturingNo+"')\">"+item.manufacturingName+"</a></div></td>";
							html += "	<td><div class=\"ellipsis_txt tgnl\">"+item.productType1Name+" / "+nvl(item.productType2Name,"")+" / "+nvl(item.productType3Name,"")+"</div></td>";
							html += "	<td>"+nvl(item.stopReqDate,'')+"</td>";
							html += "	<td>";
							html += "		<ul class=\"list_ul\">";
							html += "			<li><button type=\"button\" class=\"btn_doc\" onClick=\"openView('"+item.mNoD_seq+"');\"><img src=\"/resources/images/icon_doc01.png\">상세보기</button></li>";
							html += "			<li><button type=\"button\" class=\"btn_doc\" onClick=\"updateStatus('"+item.seq+"','"+item.status+"','S');\"><img src=\"/resources/images/icon_doc03.png\">중단</button></li>";
							html += "		</ul>";
							html += "	</td>";
							html += "</tr>";
					  		break;
					  	case 'S':
					  		html += "<tr>";
							html += "	<td>"+item.plnatName+"</td>";
							html += "	<td><a href=\"#\" onClick=\"goView('"+item.seq+"','"+item.versionNo+"','"+item.licensingNo+"','"+item.manufacturingNo+"')\">"+item.licensingNo+"-"+item.manufacturingNo+"</a></td>";
							html += "	<td><div class=\"ellipsis_txt tgnl\"><a href=\"#\" onClick=\"goView('"+item.seq+"','"+item.versionNo+"','"+item.licensingNo+"','"+item.manufacturingNo+"')\">"+item.manufacturingName+"</a></div></td>";
							html += "	<td><div class=\"ellipsis_txt tgnl\">"+item.productType1Name+" / "+nvl(item.productType2Name,"")+" / "+nvl(item.productType3Name,"")+"</div></td>";
							html += "	<td>"+nvl(item.stopDate,'')+"</td>";
							html += "	<td>";
							html += "		<ul class=\"list_ul\">";
							html += "			<li><button type=\"button\" class=\"btn_doc\" onClick=\"openView('"+item.mNoD_seq+"');\"><img src=\"/resources/images/icon_doc01.png\">상세보기</button></li>";
							html += "		</ul>";
							html += "	</td>";
							html += "</tr>";
						    break;
						case 'AS':
							html += "<tr>";
							html += "	<td>"+item.plnatName+"</td>";
							html += "	<td><a href=\"#\" onClick=\"goView('"+item.seq+"','"+item.versionNo+"','"+item.licensingNo+"','"+item.manufacturingNo+"')\">"+item.licensingNo+"-"+item.manufacturingNo+"</a></td>";
							html += "	<td><div class=\"ellipsis_txt tgnl\"><a href=\"#\" onClick=\"goView('"+item.seq+"','"+item.versionNo+"','"+item.licensingNo+"','"+item.manufacturingNo+"')\">"+item.manufacturingName+"</a></div></td>";
							html += "	<td><div class=\"ellipsis_txt tgnl\">"+item.productType1Name+" / "+nvl(item.productType2Name,"")+" / "+nvl(item.productType3Name,"")+"</div></td>";
							html += "	<td>"+nvl(item.stopReqDate,'')+"</td>";
							html += "	<td>";
							html += "		<ul class=\"list_ul\">";
							html += "			<li><button type=\"button\" class=\"btn_doc\" onClick=\"openView('"+item.mNoD_seq+"');\"><img src=\"/resources/images/icon_doc01.png\">상세보기</button></li>";
							html += "		</ul>";
							html += "	</td>";
							html += "</tr>";
							break;
					}
					index++;
				});
				$("#list").html(html);
				$('.page_navi').html(data.navi.prevBlock+data.navi.pageList+data.navi.nextBlock);
				$('#pageNo').val(data.navi.pageNo);
			} else {				
				html += "<tr><td align='center' colspan='9'>데이터가 없습니다.</td></tr>";
				$("#list").html(html);
				$('.page_navi').html("");
				$('#pageNo').val("1");
			}			
		},
		error:function(request, status, errorThrown){
			$("#list").html("<tr><td align='center' colspan='9'>오류가 발생하였습니다.</td></tr>");
			$('.page_navi').html("");
			$('#pageNo').val("1");
		}			
	});	
}

//페이징
function paging(pageNo){
	//location.href = '../material/list?' + getParam(pageNo);
	loadList(pageNo);
}

//파일 다운로드
function fileDownload(fmNo){
	location.href="/file/fileDownload?fmNo="+fmNo;
}

/*function goView(seq) {
	window.location.href="../manufacturingNo/view3?seq="+seq;
}*/

function openPopup1(seq, status, popup) {
	$("#seq").val(seq);
	$("#status").val(status);
	$("#reportSDate").val("");
	openDialog(popup);
}



function goCancel(id) {
	closeDialog(id);
}

function updateReportDate() {
	if( !chkNull($("#reportSDate").val()) ) {
		alert("신고일을 입력해주세요.");
		return;
	} else {
		var URL = "../manufacturingNo/updateReportDateAjax";	
		$.ajax({
			type:"POST",
			url:URL,
			data:{
				"seq":$("#seq").val(),
				"prevStatus":$("#status").val(),
				"status":"RE",
				"reportSDate":$("#reportSDate").val(),
			},
			dataType:"json",
			success:function(data) {
				if(data.RESULT == 'Y') {
					alert("신고일이 등록되었습니다.");
					loadStatus();
					$("#currentStatus").val("P");
					loadList(1);
					closeDialog('open1');
				} else {
					alert("신고일 변경 오류가 발생하였습니다. \n 확인후 다시 처리해 주세요.");
					return;
				}
			},
			error:function(request, status, errorThrown){
				alert("시스템 오류가 발생하였습니다. \n 확인후 다시 처리해 주세요.");
				return;
			}			
		});	
	}
}

var manufacturingNoList = [];
var manufacturingNoMessage = "";
function updateStatusBatch(){
	manufacturingNoList = [];
	$.each($("input[name=check_seq]:checked"),function(index,item){
		var mnoObj = new Object();
		mnoObj.seq = $(item).data("seq");
		mnoObj.status = $(item).data("status");
		mnoObj.nextStatus = $(item).data("nextStatus");
		mnoObj.licensingNo = $(item).data("licensingNo");
		mnoObj.manufacturingNo = $(item).data("manufacturingNo");
		manufacturingNoList.push(mnoObj);
	});
	if(manufacturingNoList.length > 0){
		if(confirm("품목제조보고서 중단처리 하시겠습니까?")){
			$('#lab_loading').show();
			window.setTimeout(updateStatusProcess,100);
		}else{
			alert("선택된 품목제조보고서가 없습니다. 품목제조보고서를 선택해주세요. ");
		}
	}
}
function updateStatusProcess(){
	if(manufacturingNoList.length > 0){
		var obj = manufacturingNoList[0];
		$.ajax({
			type:"POST",
			url:"../manufacturingNo/updateManufacturingNoStatusAjax",
			async:true, //false:同步 true:异步
			data:{
				"no_seq": obj.seq,
				"prevStatus": obj.status,
				"status": obj.nextStatus,
				"isStop": 'Y'
			},
			dataType:"json",
			success:function(data){
				if(data.RESULT == 'Y') {
					manufacturingNoList.shift();
					window.setTimeout(updateStatusProcess,100);
				} else {
					loadStatus();
					loadList(1);
					$('#lab_loading').hide();
					var mno = obj.licensingNo + "-" + obj.manufacturingNo;
					alert(" 품보번호: " + mno + " \n 상태 변경 오류가 발생하였습니다. \n 확인후 다시 처리해 주세요.");
					manufacturingNoList = [];
					return;
				}
			},
			error:function(request, status, errorThrown){
				loadStatus();
				loadList(1);
				$('#lab_loading').hide();
				alert("시스템 오류가 발생하였습니다. \n 확인후 다시 처리해 주세요.");
				manufacturingNoList = [];
				return;
			}
		});
	}else{
		loadStatus();
		loadList(1);
		$('#lab_loading').hide();
		alert("중단처리 완료되었습니다.");
	}
}

function updateStatus( seq, status, nextStatus ) {
	var URL = "../manufacturingNo/updateManufacturingNoStatusAjax";
	var confirmMessage = "";
	var resultMessage = "처리 완료되었습니다.";
	if( status == 'RS' ) {
		confirmMessage = "품목제조보고서 중단처리 하시겠습니까?";
		resultMessage = "중단처리 완료되었습니다.";
	}
	if(confirm(confirmMessage)) {
		$.ajax({
			type:"POST",
			url:URL,
			data:{
				"no_seq":seq,
				"prevStatus":status,
				"status":nextStatus,
				"isStop":'Y'
			},
			dataType:"json",
			success:function(data) {
				if(data.RESULT == 'Y') {
					alert(resultMessage);	
					loadStatus();
					$("#currentStatus").val("P");
					loadList(1);									
				} else {
					alert("상태 변경 오류가 발생하였습니다. \n 확인후 다시 처리해 주세요.");
					return;
				}
			},
			error:function(request, status, errorThrown){
				alert("시스템 오류가 발생하였습니다. \n 확인후 다시 처리해 주세요.");
				return;
			}			
		});	
	}
}

function goView(seq, versionNo, licensingNo, manufacturingNo) {
	//window.location.href="../manufacturingNo/statusView?seq="+seq;
	var form = document.createElement("form"); // 폼객체 생성
	$('body').append(form);
	form.action = "/manufacturingNo/statusView";
	form.style.display = "none";
	form.method = "post";
	
	appendInput(form, "seq", seq);
	appendInput(form, "versionNo", versionNo);
	appendInput(form, "licensingNo", licensingNo);
	appendInput(form, "manufacturingNo", manufacturingNo);
	
	$(form).submit();
}

function openView(seq) {
	var URL = "../manufacturingNo/manufacturingNoDataAjax";	
	$.ajax({
		type:"POST",
		url:URL,
		data:{
			"seq":seq
		},
		dataType:"json",
		success:function(result) {
			var data = result.manufacturingNoData;
			$("#dd_company").html(data.companyName+" - "+data.plantName);
			$("#dd_licensingNo").html(data.licensingNo);
			$("#dd_manufacturingNo").html(data.manufacturingNo);
			$("#dd_manufacturingName").html(data.manufacturingName);
			$("#dd_productType").html(data.productType1Name+" / "+data.productType2Name+" / "+nvl(data.productType3Name,''));
			$("#dd_sterilization").html(data.sterilizationName);
			$("#dd_keepCondition").html(data.keepConditionName);
			if( nvl(data.sellDate4Text,'') != '') {
				$("#dd_sellDate").html(data.sellDate1Text+" "+data.sellDate2+" "+data.sellDate3Text+"<br/>"+data.sellDate4Text+" "+data.sellDate5+" "+data.sellDate6Text);
			} else {
				$("#dd_sellDate").html(data.sellDate1Text+" "+data.sellDate2+" "+data.sellDate3Text);
			}
			//$("#dd_sellDate").html(data.sellDate1Text+" "+data.sellDate2+" "+data.sellDate3Text);
			var oemText = "";
			if( data.referral == 'Y' ) {
				oemText += "위탁"
			}
			if( data.oem == 'Y' ) {
				if( oemText != "" ) {
					oemText += "/OEM"	
				}else {
					oemText += "OEM"
				}					
			}
			$("#dd_oem").html(oemText);
			if( data.createPlant != "" && data.referral == 'Y' ) {
				loadPlant2();
				$("#li_create_plant").show();
				var productCode = data.createPlant.split(',');
				for( var i = 0 ; i < productCode.length ; i++ ) {
					$("#plant_"+productCode[i].trim()).show();
				}
			}
			if( data.oemText != "" && data.oem == 'Y' ) {
				$("#li_oemText").show();
				$("#dd_oemText").html(data.oemText);
			}
			var html = "";
			if( nvl(data.manufacturingReport,'') != '' ) {
				$("#li_manufacturingReportFile").show();
				$("#dd_manufacturingReportFile").html("<a href=\"#\" onClick=\"fileDownload('"+data.manufacturingReport+"', '"+data.seq+"', 'manufacturingReport')\"><img src=\"/resources/images/icon_file01.png\" style=\"vertical-align:middle;\"/>&nbsp;"+data.manufacturingReportFileName+"</a>");
			} else {
				$("#li_manufacturingReportFile").hide();
				$("#dd_manufacturingReportFile").html("");
			}
			if( nvl(data.sellDateReport,'') != '' ) {
				$("#li_sellDateReportFile").show();
				$("#dd_sellDateReportFile").html("<a href=\"#\" onClick=\"fileDownload('"+data.sellDateReport+"', '"+data.seq+"', 'sellDateReport')\"><img src=\"/resources/images/icon_file01.png\" style=\"vertical-align:middle;\"/>&nbsp;"+data.manufacturingReportFileName+"</a>");
			} else {
				$("#li_sellDateReportFile").hide();
				$("#dd_sellDateReportFile").html("");
			}
			//$("#dd_manufacturingReportFile").html(data.manufacturingReportFileName);
			//$("#dd_sellDateReportFile").html(data.sellDateReportFileName);
			$("#dd_comment").html(data.comment);
			openDialog('open2');
		},
		error:function(request, status, errorThrown){
			alert("시스템 오류가 발생하였습니다. \n 확인후 다시 처리해 주세요.");
			return;
		}			
	});		
}

function loadPlant2() {
	var URL = "../common/plantListAjax";
	$.ajax({
		type:"POST",
		url:URL,
		data:{
		},
		dataType:"json",
		async:false,
		success:function(data) {
			var list = data.RESULT;
			var html = "";
			$("#create_plant_list").html(html);
			var count = 0
			$.each(list, function( index, value ){ //배열-> index, value
				html += "<span id=\"plant_"+value.plantCode+"\" style=\"display:none\">";
				if( count > 0 ) {
					html += " , ";
				}
				html += value.plantName
				html += "("+value.plantCode+")";
				html += "</span>";					
				count++;
			});
			$("#create_plant_list").html(html);
			$("#li_create_plant").show();
		},
		error:function(request, status, errorThrown){
				alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
		}			
	});
}
</script>
<input type="hidden" name="currentStatus" id="currentStatus" value="N">
<input type="hidden" name="pageNo" id="pageNo" value="">
<div class="wrap_in" id="fixNextTag">
	<span class="path">품목제조보고서 현황&nbsp;&nbsp;
		<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;
		<a href="#">${strUtil:getSystemName()}</a>
	</span>
	<section class="type01">
	<!-- 상세 페이지  start-->
		<h2 style="position:relative"><span class="title_s">Items Manufacturing Report Status</span>
			<span class="title">품목제조보고서 현황</span>
			<div  class="top_btn_box">
				<ul><li></li></ul>
			</div>
		</h2>
		<div class="group01" >
			<div class="title"><!--span class="txt">연구개발시스템 공지사항</span--></div>
			<div class="tab02">
				<ul id="tab_list">
				<!-- 선택됬을경우는 탭 클래스에 select를 넣어주세요 -->
				<!-- 내 제품설계서 같은경우는 change select 이렇게 change 그대로 두고 한칸 띄고 select 삽입 -->
				<a href="#" onClick="changeTab('N');"><li class="select" id="TAB_N">번호생성(<span id="COUNT_N">00</span>건)</li></a>
				<a href="#" onClick="changeTab('P');"><li class="select" id="TAB_P">진행중(<span id="COUNT_P">00</span>건)</li></a>
				<a href="#" onClick="changeTab('RC');"><li class="" id="TAB_RC">변경요청(<span id="COUNT_RC">00</span>건)</li></a>
				<a href="#" onClick="changeTab('RE');"><li class="" id="TAB_RE">신고중(<span id="COUNT_RE">00</span>건)</li></a>				
				<a href="#" onClick="changeTab('C');"><li class="" id="TAB_C">완료(<span id="COUNT_C">00</span>건)</li></a>
				<a href="#" onClick="changeTab('AS');"><li class="" id="TAB_AS">중단요청(<span id="COUNT_AS">00</span>건)</li></a>
				<a href="#" onClick="changeTab('RS');"><li class="" id="TAB_RS">중단요청승인완료(<span id="COUNT_RS">00</span>건)</li></a>
				<a href="#" onClick="changeTab('S');"><li class="" id="TAB_S">중단(<span id="COUNT_S">00</span>건)</li></a>
				</ul>
			</div>			
			<div class="main_tbl">
				<table class="tbl01">
					<colgroup id="colgroup">
						<col width="10%">
						<col width="12%">
						<col width="20%">			
						<col />
						<col width="12%">
						<col width="12%">
						<col width="20%">
					</colgroup>
					<thead id="header">
						<tr>
							<th id="thHead"><input type="checkbox" id="chkHead"></th>
							<th>공장</th>
							<th>품보번호</th>
							<th>품목제조보고서명</th>
							<th>식품유형</th>
							<th>출시일</th>
							<th>품보번호 발급일</th>
							<th></th>				
						</tr>
					</thead>
					<tbody id="list">
					</tbody>
				</table>	
				<div class="page_navi  mt10">
				</div>
			</div>
			<hr class="con_mode"/><!-- 신규 추가 꼭 데려갈것 !-->
		</div>
	</section>
</div>
<div style='display:none'>
	<table>
		<colgroup id="group1">
			<col width="10%">
			<col width="12%">
			<col width="20%">			
			<col />
			<col width="12%">
			<col width="12%">
			<col width="20%">
		</colgroup>
		<thead id="head1">
			<tr>
				<th>공장</th>
				<th>품보번호</th>
				<th>품목제조보고서명</th>
				<th>식품유형</th>
				<th>출시일</th>
				<th>품보번호 발급일</th>
				<th></th>				
			</tr>
		</thead>
		<colgroup id="group2">
			<col width="10%">
			<col width="12%">
			<col width="20%">			
			<col />
			<col width="10%">
			<col width="10%">
			<col width="6%">
			<col width="8%">
			<col width="10%">
		</colgroup>
		<thead id="head2">
			<tr>
				<th>공장</th>
				<th>품보번호</th>
				<th>품목제조보고서명</th>
				<th>식품유형</th>
				<th>출시일</th>
				<th>신고일</th>				
				<th>구분</th>
				<th>변경내용</th>
				<th></th>
			</tr>
		</thead>
		<colgroup id="group3">
			<col WIDTH="3%">
			<col width="8%">
			<col width="12%">
			<col width="20%">			
			<col />
			<col width="10%">
			<col width="10%">
			<col width="7%">
			<col width="15%">
		</colgroup>
		<thead id="head3">
			<tr>
				<th></th>
				<th>공장</th>
				<th>품보번호</th>
				<th>품목제조보고서명</th>
				<th>식품유형</th>
				<th>신고일</th>
				<th>출시일</th>
				<th>구분</th>
				<th><button class="btn_con_search" onClick="apprFunc.openApprovalDialog('approval_manufacturingNo')"><img src="/resources/images/icon_s_com.png" />중단요청</button></th>
			</tr>
		</thead>
		<colgroup id="group4">
			<col width="10%">
			<col width="12%">
			<col width="20%">			
			<col />
			<col width="10%">
			<col width="10%">
			<col width="12%">
			<col width="10%">
		</colgroup>
		<thead id="head4">
			<tr>
				<th>공장</th>
				<th>품보번호</th>
				<th>품목제조보고서명</th>
				<th>식품유형</th>
				<th>출시일</th>
				<th>변경요청일</th>
				<th>변경내용</th>
				<th></th>
			</tr>
		</thead>
		<colgroup id="group5">
			<col width="3%">
			<col width="10%">
			<col width="12%">
			<col width="20%">			
			<col />
			<col width="10%">
			<col width="14%">
		</colgroup>
		<thead id="head5">
			<tr>
				<th>
					<input type="checkbox" id="check_head5" onclick="$('[name=check_seq]').attr('checked',this.checked)">
					<label style="padding:0;" for="check_head5"><span style="margin:0;"></span></label>
				</th>
				<th>공장</th>
				<th>품보번호</th>
				<th>품목제조보고서명</th>
				<th>식품유형</th>
				<th>중단요청 승인일</th>
				<th>
					<button class="btn_con_search" onClick="updateStatusBatch()"><img src="/resources/images/icon_s_com.png" />중단</button>
				</th>
			</tr>
		</thead>
		<colgroup id="group6">
			<col width="10%">
			<col width="12%">
			<col width="20%">			
			<col />
			<col width="10%">
			<col width="14%">
		</colgroup>
		<thead id="head6">
			<tr>
				<th>공장</th>
				<th>품보번호</th>
				<th>품목제조보고서명</th>
				<th>식품유형</th>
				<th>중단일</th>
				<th></th>
			</tr>
		</thead>
		<colgroup id="group7">
			<col width="10%">
			<col width="12%">
			<col width="20%">
			<col />
			<col width="10%">
			<col width="14%">
		</colgroup>
		<thead id="head7">
		<tr>
			<th>공장</th>
			<th>품보번호</th>
			<th>품목제조보고서명</th>
			<th>식품유형</th>
			<th>중단요청일</th>
			<th>
			</th>
		</tr>
		</thead>
	</table>
</div>
<!-- 레이어 start-->
<div class="white_content" id="open1">
	<div class="modal" style="	width: 420px;margin-left:-220px;height: 230px;margin-top:-150px;">
		<h5 style="position:relative">
			<span class="title">신고일 등록</span>
			<div  class="top_btn_box">
				<ul>
					<li>
						<button type="button" class="btn_madal_close" onClick="goCancel('open1')"></button>
					</li>
				</ul>
			</div>
		</h5>
		<div class="list_detail">
			<ul>
				<li>
					<dt>신고일</dt>
					<dd>
						<input type="text" name="reportSDate" id="reportSDate" readonly>
						<input type="hidden" name="seq" id="seq" value="">
						<input type="hidden" name="status" id="status" value="">
					</dd>
				</li>				
			</ul>
		</div>
		<div class="btn_box_con">
			<input type="button" value="등록" class="btn_admin_red" id="addFile" onclick="javascript:updateReportDate();"> 
			<input type="button" value="취소" class="btn_admin_gray" onclick="goCancel('open1')">
		</div>
	</div>
</div>
<!-- 레이어 close-->

<!-- 레이어 start-->
<div class="white_content" id="open2">
	<div class="modal" style="	width: 700px;margin-left:-350px;height: 670px;margin-top:-300px;">
		<h5 style="position:relative">
			<span class="title">품목제조보고서 상세</span>
			<div  class="top_btn_box">
				<ul>
					<li>
						<button class="btn_madal_close" onClick="goCancel('open2')"></button>
					</li>
				</ul>
			</div>
		</h5>
		<div class="list_detail">
			<ul>
				<li class="pt10">
					<dt>공장</dt>
					<dd id="dd_company">
						${manufacturingNo.companyName} - ${manufacturingNo.plantName}						
					</dd>
				</li>
				<li>
					<dt>인허가번호</dt>
					<dd id="dd_licensingNo">
						${manufacturingNo.licensingNo}
					</dd>
				</li>
				<li>
					<dt>품목번호</dt>
					<dd id="dd_manufacturingNo">
						${manufacturingNo.manufacturingNo}
					</dd>
				</li>
				<li>
					<dt>품목명</dt>
					<dd id="dd_manufacturingName">
						${manufacturingNo.manufacturingName}						
					</dd>
				</li>
				<li>
					<dt>식품유형</dt>
					<dd id="dd_productType">						
					</dd>
				</li>
				<li>
					<dt>살균여부</dt>
					<dd id="dd_sterilization">						
					</dd>
				</li>
				<li>
					<dt>보관조건</dt>
					<dd id="dd_keepCondition">						
					</dd>
				</li>
				<li>
					<dt>소비기한</dt>
					<dd id="dd_sellDate">						
					</dd>
				</li>
				<li>
					<dt>위탁/OEM</dt>
					<dd id="dd_oem">						
					</dd>
				</li>
				<li id="li_create_plant" style="display:none">
					<dt>생산 공장</dt>
					<dd id="create_plant_list">
					</dd>
				</li>
				<li id="li_oemText" style="display:none">
					<dt>OEM 내용</dt>
					<dd id="dd_oemText">
					</dd>
				</li>
				<li id="li_manufacturingReportFile" style="display:none">
					<dt>품복제조보고서</dt>
					<dd id="dd_manufacturingReportFile">
					</dd>
				</li>
				<li id="li_sellDateReportFile" style="display:none">
					<dt>소비기한설정<br/>사유서</dt>
					<dd id="dd_sellDateReportFile">
					</dd>
				</li>
				<li>
					<dt>비고</dt>
					<dd id="dd_comment">						
					</dd>
				</li>
			</ul>
		</div>
		<div class="btn_box_con">
			<input type="button" value="닫기" class="btn_admin_gray" onclick="goCancel('open2')">
		</div>
	</div>
</div>
<!-- 레이어 close-->

<jsp:include page="manufacturingNoStopAppr.jsp" flush="true"></jsp:include>