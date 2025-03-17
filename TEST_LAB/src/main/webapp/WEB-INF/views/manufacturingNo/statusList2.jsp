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
    String userId = UserUtil.getUserId(request);
	String isAdmin = UserUtil.getIsAdmin(request);

    Boolean doAdmin = false;
    Boolean topAdmin = false;
    //신고일,중단 권한:관리자, 사용자 권한-BOM
	if((isAdmin != null && "Y".equals(isAdmin)) || "3".equals(userGrade)){
		topAdmin = true;
	}
	// 중단요청 권한: 권한-연구원
	if( topAdmin || "4".equals(userGrade) ){
		doAdmin = true;
	}
    //제품개발문서 보기 권한
	String authCheckType = "";
	if(doAdmin || userId.equals("cha") || userDept.equals("dept7") || userDept.equals("dept8") || userDept.equals("dept9") || userDept.equals("dept10")){
		authCheckType = "ALL";
	}
//	if((isAdmin != null && "Y".equals(isAdmin))
//			|| "3".equals(userGrade)
//			|| userId.equals("cha")
//			|| userDept.equals("dept7") || userDept.equals("dept8") || userDept.equals("dept9") || userDept.equals("dept10")){
//		authCheckType = "ALL";
//	}
//    else if(userDept.equals("dept1") || userDept.equals("dept2") || userDept.equals("dept3")
//		    || userDept.equals("dept4") || userDept.equals("dept5") || userDept.equals("dept6")
//		    || userDept.equals("dept11") || userDept.equals("dept12")|| userDept.equals("dept13")){
//	    authCheckType = "DEPT";
//    }
%>
<title>품목제조 보고서</title>
<link href="/resources/js/jquery.auto-complete.css" rel="stylesheet" type="text/css">
<style type="text/css">
    .main_tbl{min-height: 600px}
</style>
<script type="text/javascript" src="/resources/js/jquery.auto-complete.js"></script>
<script type="text/javascript">

	var topAdmin = <%=topAdmin%>;   //신고일,중단 권한
	var doAdmin = <%=doAdmin%>;     //중단요청 권한

	var gridData = new Object();

var isValid ;
$(document).ready(function(){
	loadStatus();
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
			$(".main_tbl").hide();
			$("#main_tbl_"+id).show();
		} else {
			$(a).children('li').prop('class','');			
		}
	})
}

function loadList( pageNo ) {
	$("#lab_loading").show();
	var URL = "../manufacturingNo/selectManufacturingNoStatusListData";
	var currentStatus = $("#currentStatus").val();
	gridData.requestTime = new Date();
	$.ajax({
		type:"POST",
		url:URL,
		data:{
			"pageNo":pageNo,
			"status":currentStatus,
			"authCheckType":"<%=authCheckType%>",
			"userDept":"<%=userDept%>",
			"userTeam":"<%=userTeam%>"
		},
		dataType:"json",
		success:function(data) {
			// data.manufacturingNoList
			gridData.startTime = new Date();
			console.log("loadList: Loading data time:" + parseInt(gridData.startTime - gridData.requestTime)/1000);
			var gridId = "statusList" + currentStatus;
			gridData[gridId] =  {Body:[data.manufacturingNoList]};
			Grids[gridId].Source.Data.Script = "gridData." + gridId;
			Grids[gridId].ReloadBody();
			gridData.endTime = new Date();
			console.log("loadList: Loading Grid time:" + parseInt(gridData.endTime - gridData.startTime)/1000);
			$("#COUNT_"+currentStatus).html(data.totalCount);
			$("#lab_loading").hide();
		},
		error:function(request, status, errorThrown){
			//$('#pageNo').val("1");
			$("#lab_loading").hide();
		}			
	});	
}

//파일 다운로드
function fileDownload(fmNo){
	location.href="/file/fileDownload?fmNo="+fmNo;
}

function openPopup1(seq,status, popup) {
	$("#seq").val(seq);
	$("#status").val(status);
	$("#reportSDate").val("");
	openDialog(popup);
}

function openReportEDate(row){
	if(!topAdmin){alert("권한이 부족합니다.");return;}
	var seq = row.seq, status = row.status;
	openPopup1(seq,status, "open1");
	Grids.Active = null;
	Grids.Focused = null;
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
function updateStatusBatch(seqArr){
	manufacturingNoList = [];
	$.each(seqArr,function(index,item){
		var mnoObj = new Object();
		mnoObj.seq = item.seq;                              //$(item).data("seq");
		mnoObj.status = item.status;                        //$(item).data("status");
		mnoObj.nextStatus = "S";                            //$(item).data("nextStatus");
		mnoObj.licensingNo = item.licensingNo;              //$(item).data("licensingNo");
		mnoObj.manufacturingNo = item.manufacturingNo;      //$(item).data("manufacturingNo");
		manufacturingNoList.push(mnoObj);
	});
	if(manufacturingNoList.length > 0){
		if(confirm("품목제조보고서 중단처리 하시겠습니까?")){
			$('#lab_loading').show();
			window.setTimeout(updateStatusProcess,100);
		}
	}else{
		alert("선택된 품목제조보고서가 없습니다. 품목제조보고서를 선택해주세요. ");
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

function goView(row) {
	//window.location.href="../manufacturingNo/statusView?seq="+seq;
	var seq = row.seq, versionNo = row.versionNo, licensingNo = row.licensingNo, manufacturingNo = row.manufacturingNo;
	var form = document.createElement("form"); // 폼객체 생성
	$('body').append(form);
	form.action = "/manufacturingNo/statusView";
	form.target = "_blank";
	form.style.display = "none";
	form.method = "post";
	
	appendInput(form, "seq", seq);
	appendInput(form, "versionNo", versionNo);
	appendInput(form, "licensingNo", licensingNo);
	appendInput(form, "manufacturingNo", manufacturingNo);
	
	$(form).submit();
	$(form).remove();
}

function openView(row) {
	var seq = row.openView;
	var URL = "../manufacturingNo/manufacturingNoDataAjax";
	var successFn = function(result){
		var data = result.manufacturingNoData;
		var packList = result.packageList;
		
		$("#dd_company").html(data.companyName+" - "+data.plantName);
		$("#dd_licensingNo").html(data.licensingNo);
		$("#dd_manufacturingNo").html(data.manufacturingNo);
		$("#dd_manufacturingName").html(data.manufacturingName);
		$("#dd_productType").html(data.productType1Name+" / "+data.productType2Name+" / "+nvl(data.productType3Name,''));
		$("#dd_sterilization").html(data.sterilizationName);
		$("#dd_keepCondition").html(data.keepConditionName+ " / " + data.keepConditionText );
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
		
		if( packList && packList.length > 0 ){ //240206_포장재질
			var htmlP = "";
			for(var i=0; i <packList.length; i++){
				var packageUnit 	= packList[i].packageUnit;
				var packageUnitName = packList[i].packageUnitName;
				
				if(packageUnit != '8'){
					htmlP += packageUnitName + "</br>";
				}else if(packageUnit == '8'){
					htmlP += packageUnitName+" / "+data.packageEtc;
				}
			}
			$("#dd_packageList").html(htmlP);
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
	}
	var errorFn = function(request, status, errorThrown){
		alert("시스템 오류가 발생하였습니다. \n 확인후 다시 처리해 주세요.");
		return;
	}
	var ajaxConfig = {
		type:"POST",
		url:URL,
		data:{ "seq":seq },
		dataType:"json",
		success:successFn,
		error:errorFn
	}

	var authCheckType = "<%=authCheckType%>"
	if(authCheckType == "ALL"){
		$.ajax(ajaxConfig);
	} else {
		// 제품개발문서 권한체크
		$.post("/manufacturingNo/getAuthDevDoc?seq=" + seq,null,function(data){
			var auth = false;
			if(data != null){
				$.each(data,function(index,row){
					if(readProductDevDocAuth(row)){
						auth = true;
					}
				});
			}
			console.log("auth=" + auth);
			if(!auth){alert("권한이 부족합니다.");return;}
			$.ajax(ajaxConfig);
		});
	}
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

function readProductDevDoc(Row){
	var docNo = Row.docNo, docVersion = Row.docVersion,regUserId = Row.regUserId;
	var form = document.createElement('form');
	form.style.display = 'none';
	$('body').append(form);
	form.action = '/dev/productDevDocDetail';
	form.target = '_blank';
	form.method = 'post';

	appendInput(form, 'docNo', docNo);
	appendInput(form, 'docVersion', docVersion);
	appendInput(form, 'regUserId', regUserId);

	$(form).submit();
	$(form).remove();
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
			<div class="main_tbl" id="main_tbl_N" >
				<div class="fl-box panel-wrap">
					<div id="statusListN" style="width: 100%" >
						<bdo Debug=""
						     Layout_Url="/manufacturingNo/statusListLayout?gridId=statusListN" >
						</bdo>
					</div>
				</div>
			</div>
			<div class="main_tbl" id="main_tbl_P" style="display: none">
				<div class="fl-box panel-wrap">
					<div id="statusListP" style="width: 100%" >
						<bdo Debug=""
						     Layout_Url="/manufacturingNo/statusListLayout?gridId=statusListP" >
						</bdo>
					</div>
				</div>
			</div>
			<div class="main_tbl" id="main_tbl_RC" style="display: none">
				<div class="fl-box panel-wrap">
					<div id="statusListRC" style="width: 100%" >
						<bdo Debug=""
						     Layout_Url="/manufacturingNo/statusListLayout?gridId=statusListRC" >
						</bdo>
					</div>
				</div>
			</div>
			<div class="main_tbl" id="main_tbl_RE" style="display: none">
				<div class="fl-box panel-wrap">
					<div id="statusListRE" style="width: 100%" >
						<bdo Debug=""
						     Layout_Url="/manufacturingNo/statusListLayout?gridId=statusListRE" >
						</bdo>
					</div>
				</div>
			</div>
			<div class="main_tbl" id="main_tbl_C" style="display: none">
				<div class="fl-box panel-wrap">
					<div id="statusListC" style="width: 100%" >
						<bdo Debug=""
						     Layout_Url="/manufacturingNo/statusListLayout?gridId=statusListC" >
						</bdo>
					</div>
				</div>
			</div>
			<div class="main_tbl" id="main_tbl_AS" style="display: none">
				<div class="fl-box panel-wrap">
					<div id="statusListAS" style="width: 100%" >
						<bdo Debug=""
						     Layout_Url="/manufacturingNo/statusListLayout?gridId=statusListAS" >
						</bdo>
					</div>
				</div>
			</div>
			<div class="main_tbl" id="main_tbl_RS" style="display: none">
				<div class="fl-box panel-wrap">
					<div id="statusListRS" style="width: 100%" >
						<bdo Debug=""
						     Layout_Url="/manufacturingNo/statusListLayout?gridId=statusListRS" >
						</bdo>
					</div>
				</div>
			</div>
			<div class="main_tbl" id="main_tbl_S" style="display: none">
				<div class="fl-box panel-wrap">
					<div id="statusListS" style="width: 100%" >
						<bdo Debug=""
						     Layout_Url="/manufacturingNo/statusListLayout?gridId=statusListS" >
						</bdo>
					</div>
				</div>
			</div>
			<hr class="con_mode"/><!-- 신규 추가 꼭 데려갈것 !-->
		</div>
	</section>
</div>
<!-- 신고일 레이어 start-->
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

<!-- 상세보기 레이어 start-->
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
					<dt>포장재질</dt>
					<dd id="dd_packageList">
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

<!-- 제조공정서 리스트 레이어 start-->
<div class="white_content" id="open3" style="z-index:100">
	<div class="modal" style="	width: 1200px;margin-left:-650px;height: 670px;margin-top:-300px;">
		<h5 style="position:relative">
			<span class="title">제조공정서</span>
			<div  class="top_btn_box">
				<ul>
					<li>
						<button class="btn_madal_close" onClick="goCancel('open3')"></button>
					</li>
				</ul>
			</div>
		</h5>
		<div class="list_detail">
			<bdo Debug=""
			     Layout_Url="/manufacturingNo/mpdListLayout?gridId=mpdList" >
			</bdo>
		</div>
		<div class="btn_box_con">
			<input type="button" value="닫기" class="btn_admin_gray" onclick="goCancel('open3')">
		</div>
	</div>
</div>
<!-- 레이어 close-->

<script type="text/javascript">
	var isPageInit = true;
	var authTeamCode = "${authTeamCode}";

	$(document).ready(function(){
		Grids.OnRenderFinish  = function(grid){
			console.log("Grids.OnRenderFinish grid=" + grid.id + ", isPageInit=" + isPageInit);
			if(grid.id == "statusListN" && isPageInit){
				$("#currentStatus").val("N");
				loadList(1);
				isPageInit = false;
			}
		};
		// Grids.OnReady = function(grid){
		// 	if(grid.id == "statusListC"){
		// 		for(var row = grid.GetFirstVisible(); row; row = grid.GetNextVisible(row)){
		// 			if(row.noStopCount > 0 || row.isMaxVersion == 0){
		// 				grid.SetValue(row, "CanSelect", 0, 1);
		// 			}
		// 		}
		// 	}
		// };
		Grids.OnDblClick = function(grid, row, col){
			console.log("Grids.OnDblClick grid=" + grid.id + ", col=" + col + ", row.Kind=" + row.Kind);
			if(row.Kind != "Data"){return;}
			if(row.id == "Header" || row.id == "spanHeader" || row.id == "Toolbar" || col =="Panel"|| row.id == "Filter" || row.id == "PAGER" || row.id == "_ConstHeight"
				|| row.Kind == "Header") {
				return;
			}
			if(grid.id.startsWith("statusList")){
				if(col == "manufacturingNo2" || col == "manufacturingName"){
					readManufacturingNo(row);
				}
			}

			if(grid.id == "mpdList"){
				readProductDevDoc(row);
				// if(row.viewAuth == 1){
				//
				// }else{
				// 	alert("권한이 없습니다.");
				// 	return;
				// }
			}
		};
		Grids.OnClick = function(grid, row, col, e){
			if(row.Kind != "Data"){return;}
			console.log("Grids.OnClick grid=" + grid.id + ", col=" + col );
			if(grid.id == "statusListC" && col == "devDocCount"){
				goManufacturingProcessDocList(row);
			}
		};
	});

	var reloadStatusList = function(gridId){
		var status = gridId.replace("statusList","");
		console.log("reloadStatusList gridId=" + gridId + ", status=" + status);
		changeTab(status);
	}

	//중단요청
	var openStopArr = function(gridId){
		console.log("openStopArr gridId=" + gridId + ", isPageInit=" + isPageInit);
		if(gridId != "statusListC") return;
		if(!doAdmin){alert("권한이 부족합니다.");return;}
		var selRow = Grids[gridId].GetSelRows();
		apprFunc.openStopMNoAppr(selRow);
	}

	//중단
	var executeStopProcess = function(gridId){
		console.log("executeStopProcess gridId=" + gridId);
		if(!topAdmin){alert("권한이 부족합니다.");return;}
		if(gridId != "statusListRS") return;
		var selRow = Grids[gridId].GetSelRows();
		updateStatusBatch(selRow);
	}
	// 폐기
	var goManufacturingProcessDocList = function(Row){
		console.log(Row);
		// for(var row = Grids.mpdList.GetFirst(); row; row = Grids.mpdList.GetNext(row)){
		// 	Grids.mpdList.RemoveRow(row);
		// }
		var rows = Grids.mpdList.Rows;
		$.each(rows,function(index,row){
			if(row.Kind == "Data"){
				Grids.mpdList.RemoveRow(row);
			}
		});
		Grids.mpdList.Source.Data.Url = "/manufacturingNo/mpdListData?seq=" + Row.seq;
		Grids.mpdList.ReloadBody();
		openDialog("open3");
	}

	// 권한체크
	var readProductDevDocAuth = function(row){
		var authCheckType = "<%=authCheckType%>";
		console.log(row);
		console.log("readProductDevDocAuth: authCheckType=" + authCheckType + ", row.teamCode=" + row.teamCode + ", teamCode=<%=userTeam%>");
		if(authCheckType == "ALL"){
			return true;
		} else {
			var teamCode = "<%=userTeam%>";
			if(row.teamCode == teamCode){
				return true;
			}
		}
		return false;
	}

	// 품목제조보고서 권한체크
	var readManufacturingNo = function(Row){
		var authCheckType = "<%=authCheckType%>"
		if(authCheckType == "ALL"){
			goView(Row);
		} else {
			// 제품개발문서 권한체크
			$.post("/manufacturingNo/getAuthDevDoc?seq=" + Row.seq,null,function(data){
				var auth = false;
				if(data != null){
					$.each(data,function(index,row){
						if(readProductDevDocAuth(row)){
							auth = true;
						}
					});
				}
				console.log("auth=" + auth);
				if(!auth){alert("권한이 부족합니다.");return;}
				goView(Row);
			});
		}
	}

	// 제품개발문서 보기
	var readProductDevDoc = function(row){

		if(!readProductDevDocAuth(row)){alert("권한이 부족합니다.");return;}

		var docNo = row.docNo, docVersion = row.docVersion;
		var form = document.createElement('form');
		form.style.display = 'none';
		$('body').append(form);
		form.action = '/dev/productDevDocDetail';
		form.target = '_blank';
		form.method = 'post';

		appendInput(form, 'docNo', docNo);
		appendInput(form, 'docVersion', docVersion);
		appendInput(form, 'regUserId', null);

		$(form).submit();
		$(form).remove();
	}
</script>

<jsp:include page="manufacturingNoStopAppr.jsp" flush="true"></jsp:include>

<script type="text/javascript">
	// callback function after Appr
	apprFunc.onAfterDoSubmit = function (){
		changeTab("C");
	}
</script>