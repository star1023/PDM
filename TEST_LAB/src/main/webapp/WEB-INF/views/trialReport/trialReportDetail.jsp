<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ page import="kr.co.aspn.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ taglib prefix="userUtil" uri="/WEB-INF/tld/userUtil.tld"%>
<%@ page session="false" %>
<%
	String userId = UserUtil.getUserId(request);
%>
<title>레포트</title>
<link rel="stylesheet" href="/resources/CLEditor/jquery.cleditor.css?param=1" />
<script type="text/javascript" src="/resources/CLEditor/jquery.cleditor.min.js?param=1"></script>
<link href="/resources/js/jquery.auto-complete.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="/resources/js/jquery.auto-complete.js"></script>

<div class="wrap_in" id="fixNextTag">
	<span class="path">시생산 보고서&nbsp;&nbsp;<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;보고서&nbsp;&nbsp;<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;<a href="#">${strUtil:getSystemName()}</a></span>
	<section class="type01">
		<h2 style="position:relative"><span class="title_s">Trial Production Report</span>
			<span class="title" id="span_reportTitle">시생산 보고서 작성</span>
			<div  class="top_btn_box">
				<ul>
					<li>
						<button class="btn_circle_nomal" id="list" onclick="editReportCancel()">&nbsp;</button>
					</li>
					<c:if test="${mode == 'readFull'}">

					</c:if>
					<li>
						<button class="btn_circle_dark" id="print" onclick="editTrialReport.printCheck()">&nbsp;</button>
					</li>
				</ul>
			</div>
		</h2>
		<div class="group01" >

			<div class="title"></div>
			<!-- 문서 본체 start -->
			<div id="reportContents">
				<c:if test="${mode == 'readFull'}">
					<c:set var="devDocView" value="1"/>
				</c:if>
				<jsp:include page="/trialReport/viewReport?rNo=${rNo}&devDocLink=0&devDocView=${devDocView}" flush="false"></jsp:include>
			</div>
			<!-- 문서 본체 close -->
			<div class="btn_box_con5"></div>
			<div class="btn_box_con4">
				<c:choose>
					<c:when test="${mode == 'write'}">
						<input type="button" class="btn_admin_sky" id="editStart" value="작성시작" onclick="editReportStart();" >
						<input type="button" class="btn_admin_sky" id="editEnd" value="작성완료" onclick="editReportEnd();" >
					</c:when>
					<c:when test="${mode == 'appr2'}">
						<input type="button" class="btn_admin_sky" id="editStart" value="결재상신" onclick="apprClass.openApprovalDialog('approval_trialReportAppr2')" >
					</c:when>
				</c:choose>
				<input type="button" class="btn_admin_gray" id="cancel" value="목록" onclick="editReportCancel()">
			</div>
		</div>
	</section>	
</div>

<!-- 자재 호출레이어 start-->
<div class="white_content" id="open">
	<div class="modal" style="	width: 700px;margin-left:-350px;height: 350px;margin-top:-150px;">
		<h5 style="position:relative">
			<span class="title">다운로드 및 프린트 요청</span>
			<div  class="top_btn_box">
				<ul>
					<li>
						<button class="btn_madal_close" onClick="closeDialog('open')"></button>
					</li>
				</ul>
			</div>
		</h5>
		<div class="list_detail">
			<ul>
				<li class="pt10">
					<dt>주의사항</dt>
					<dd>
						본 문서는 대외비로 간주되오니 외부에 유출되지 않도록 철저하게 관리 바라며,<br/> 사용이 완료된 자료는 파쇄하여 주시기 바랍니다.<br/>
						결재완료 시점부터 1회 다운로드 및 프린트가 가능합니다.<br/>
					</dd>
				</li>
				<li>
					<dt>요청사유</dt>
					<dd>
						<textarea id="requestReason" name="requestReason" style="width:98%; height:70px;resize: none;"></textarea>
					</dd>
				</li>
			</ul>
		</div>
		<div class="btn_box_con">
			<button class="btn_admin_red" id="goPrintRequest" onclick="javascript:goPrintRequest();">결재요청</button>
			<button class="btn_admin_gray"onclick="closeDialog('open')"> 취소</button>
		</div>
	</div>
</div>


<c:if test="${mode == 'appr2'}">

	<input type="hidden" id="deptFulName" />
	<input type="hidden" id="titCodeName" />
	<input type="hidden" id="userId" />
	<input type="hidden" id="userName"/>
	<input type="hidden" id="loginUserId"/>

	<!-- 시생산보고서 작성 완료 레이어 start-->
	<div class="white_content" id="approval_trialReportAppr2">
		<input type="hidden" name="jobtypeTrialAppr2" id="jobtypeTrialAppr2" value="popup"/>
		<input type="hidden" name="userId1TrialAppr2" id="userId1TrialAppr2" value="<%=userId%>" />
		<input type="hidden" name="userId2TrialAppr2" id="userId2TrialAppr2" />
		<input type="hidden" name="userId3TrialAppr2" id="userId3TrialAppr2" />
		<input type="hidden" name="userId4TrialAppr2" id="userId4TrialAppr2" />
		<input type="hidden" name="userId5TrialAppr2" id="userId5TrialAppr2" />
		<input type="hidden" name="userId6TrialAppr2" id="userId6TrialAppr2" />
		<input type="hidden" name="userId7TrialAppr2" id="userId7TrialAppr2" />
		<input type="hidden" name="userId8TrialAppr2" id="userId8TrialAppr2" />
		<input type="hidden" name="userIdTrialAppr2Arr" id="userIdTrialAppr2Arr"/>
		<input type="hidden" name="tbKeyTrialAppr2" id="tbKeyTrialAppr2" value=""/>
		<input type="hidden" name="totalStepTrialAppr2" id="totalStepTrialAppr2" value="6"/>
		<input type="hidden" name="typeTrialAppr2" id="typeTrialAppr2" value="0"/>
		<input type="hidden" name="TrialAppr2CompanyCd" id="TrialAppr2CompanyCd" />

		<div class="modal" style="	margin-left:-500px;width:1000px;height: 550px;margin-top:-300px">
			<h5 style="position:relative">
				<span class="title">시생산결과보고서 결재상신</span>
				<div  class="top_btn_box">
					<ul><li><button class="btn_madal_close" onClick="closeDialog('approval_trialReportAppr2'); return false;"></button></li></ul>
				</div>
			</h5>
			<div class="list_detail">
				<ul>
					<li class="pt10">
						<dt style="width:20%">제목</dt>
						<dd style="width:80%"><input type="text" class="req" style="width:573px" id="trialAppr2Title"></dd>
					</li>
					<li>
						<dt style="width:20%">의견</dt>
						<dd style="width:80%;">
							<div class="insert_comment">
								<table style=" width:756px">
									<tr><td><textarea style="width:100%; height:50px" placeholder="의견을 입력하세요" id="trialAppr2Comment"></textarea></td><td width="98px"></td></tr>
								</table>
							</div>
						</dd>
					</li>
					<li class="pt5">
						<dt style="width:20%">결재자 입력</dt>
						<dd style="width:80%;" class="ppp">
							<input type="text" placeholder="결재자명 2자이상 입력후 선택" style="width:198px; float:left;" class="req" id="trialAppr2Keyword" name="trialAppr2Keyword">
							<button class="btn_small01 ml5" onclick="apprClass.approvalAddLine(this); return false;" name="baseApprovalTrialAppr2">결재자 추가</button>
								<%--							<button class="btn_small02  ml5" onclick="approvalAddLine(this); return false;" name="circulationPayment">회람</button>--%>
							<button class="btn_small02  ml5" onclick="apprClass.approvalAddLine(this); return false;" name="referPaymentAppr2">참조</button>

							<div class="selectbox ml5" style="width:180px;">
								<label for="apprLineSelectTrial">---- 결재선 불러오기 ----</label>
								<select id="apprLineSelectTrial" onchange="apprClass.changeApprLine(this); return false;"></select>
							</div>
							<button class="btn_small02  ml5" onclick="apprClass.deleteApprovalLine(this); return false;">선택 결재선 삭제</button>
						</dd>
					</li>
					<li  class="mt5">
						<dt style="width:20%; background-image:none;" ></dt>
						<dd style="width:80%;">
							<div class="file_box_pop2" style="height:190px;">
								<ul id="apprLineTrialAppr2"></ul>
							</div>
							<div class="file_box_pop3" style="height:190px;">
								<ul id="CirculationRefLineTrialAppr2">
								</ul>
							</div>
							<div class="app_line_edit">
								저장 결재선명 입력 :
								<input type="text" class="req" style="width:280px;"/>
								<button class="btn_doc" onclick="apprClass.approvalLineSave(this);  return false;">
									<img src="../resources/images/icon_doc11.png" alt="">저장
								</button> |
								<button class="btn_doc" onclick="apprClass.approvalLineCancel(this); return false;">
									<img src="../resources/images/icon_doc04.png" alt="">취소
								</button>
							</div>
						</dd>
					</li>
				</ul>
			</div>
			<div class="btn_box_con4" style="padding:15px 0 20px 0">
				<button class="btn_admin_red" onclick="trialAppr2.doApprSubmit(); return false;">결재상신</button>
				<button class="btn_admin_gray" onclick="closeDialog('approval_trialReportAppr2'); return false;">상신 취소</button>
			</div>
		</div>
	</div>
	<!-- 시생산보고서 작성 완료 결재 레이어 end-->
</c:if>


<!-- 첨부파일 추가레이어 start-->
<!-- 신규로 레이어창을 생성하고싶을때는  아이디값 교체-->
<!-- 클래스 옆에 적힌 스타일 값을 인라인으로 작성해서 팝업 사이즈를 직접 조정 -->
<div class="white_content" id="dialog_trial_attatch">
	<!--  <div class="modal" style="margin-left: -355px; width: 710px; height: 500px; margin-top: -250px">-->
	<div class="modal" style="margin-left: -355px; width: 600px; height: 500px; margin-top: -250px">
		<h5 style="position: relative">
			<span class="title">첨부파일 추가</span>
			<div class="top_btn_box">
				<ul>
					<li>
						<button class="btn_madal_close" onClick="closeDialogWithClean('dialog_trial_attatch')"></button>
					</li>
				</ul>
			</div>
		</h5>
		<div class="list_detail">
			<ul>
				<li class="pt10 mb5">
					<dt style="width: 20%">파일 선택</dt>
					<dd style="width: 80%" class="ppp">
						<div style="float: left; display: inline-block;">
							<span class="file_load" id="fileSpan">
								<input id="attatch_common_text" class="form-control form_point_color01" type="text" placeholder="파일을 선택해주세요." style="width:145px;/* width:308px;  */float:left; cursor: pointer; color: black;" onclick="callAddFileEvent()" readonly="readonly">
								<!-- <label class="btn-default" for="attatch_common" style="float:left; margin-left: 5px; width: 57px">파일 선택</label> -->
								<input id="attatch_common" type="file" style="display:none;" onchange="setFileName(this)">
							</span>
							<button class="btn_small02 ml5" onclick="addFile(this, '50')">시생산보고서</button>
						</div>
						<div style="float: left; display: inline-block; margin-top: 5px">
							
						</div>
					</dd>
				</li>
				<li class=" mb5">
					<dt style="width: 20%">파일리스트</dt>
					<dd style="width: 80%;">
						<div class="file_box_pop" style="width:95%">
							<ul name="popFileList"></ul>
						</div>
					</dd>
				</li>
			</ul>
		</div>
		<div class="btn_box_con">
			<button class="btn_admin_red" onclick="trial_uploadFiles();">파일 등록</button>
			<button class="btn_admin_gray" onClick="closeDialogWithClean('dialog_trial_attatch')">등록 취소</button>
		</div>
	</div>
</div>
<!-- end -->

<script type="text/javascript">

	var editReportStart = function(){
		var timestamp = Date.parse(new Date());
		console.log("editReportStart: timestamp=" + timestamp);
		$('#lab_loading').show();
		$.post("/trialReport/isEditing?rNo=${rNo}&cNo=${cNo}",null,function(data){
			if(data.status == "S"){
				$("#reportContents").load("/trialReport/editReport?rNo=${rNo}&cNo=${cNo}&devDocLink=0&docLink=1&timestamp=" + timestamp,null,function(responseTxt,statusTxt,xhr){
					$('#lab_loading').hide();
					if(statusTxt == "success"){
						if($.isFunction(editTrialReport.editable)){
							editTrialReport.editable();
						}
						editTrialReport.pageMode = "edit";
					}
					if(statusTxt=="error"){
						alert("Error: "+xhr.status+": "+xhr.statusText);
					}
				});
			} else if(data.status == "F"){
				$('#lab_loading').hide();
				alert("작성자:" + data.message + " 작성중입니다.");
			} else if(data.status == "E"){
				$('#lab_loading').hide();
				alert(data.message);
			}
		});
	}

	var editReportEnd = function(){
		if(editTrialReport.pageMode != "edit")return;

		if(chkNull($("#writerComment").val())){
			if(!window.confirm("작성완료 하시겠습니까?")){
				return;
			}
		}

		if($.isFunction(editTrialReport.saveTrialReport)){
			editTrialReport.saveTrialReport(function (data){
				editTrialReport.pageMode = "view";
				window.location.href = "/trialReport/trialReportList?func=historyBack";
				<%--$('#lab_loading').show();--%>
				<%--var timestamp = Date.parse(new Date());--%>
				<%--$("#reportContents").load("/trialReport/viewReport?rNo=${rNo}&cNo=${cNo}&devDocLink=0&timestamp=" + timestamp,null,function(){--%>
				<%--	$('#lab_loading').hide();--%>
				<%--});--%>
			});
		}
	}

	var editReportCancel = function(){
		if("${from}" == "trialReportList"){
			// TODO bug  상태 변경 않됨
			console.log(editTrialReport.pageMode);
			if(editTrialReport.pageMode == "edit"){
				$.post("/trialReport/editCancel?rNo=${rNo}&cNo=${cNo}",null,function(data){
					console.log(data);
					window.location.href = "/trialReport/trialReportList?func=historyBack";
				})
			}else{
				window.location.href = "/trialReport/trialReportList?func=historyBack";
			}
		}else if("${from}" == "productDevDocDetail"){
			var form = document.createElement('form');
			form.style.display = 'none';
			$('body').append(form);
			form.action = '/dev/productDevDocDetail';
			form.target = '_self';
			form.method = 'post';
			appendInput(form, 'docNo', "${docNo}");
			appendInput(form, 'docVersion', "${docVersion}");

			$(form).submit();
		}else{
			window.history.back();
		}
	}

	var editTrialReport = new Object();
	editTrialReport.pageMode = "view";
	editTrialReport.resultCheckBox = function(e){
		console.log("editTrialReport.resultCheckBox: e.id=" + e.id);
		var checkboxs = ["pass","progress","retest","fail"];
		$.each(checkboxs,function (index,checkboxId){
			if(checkboxId != e.id){
				$("#" + checkboxId).prop("checked",false);
			}
		});
	};
	//  API - 레포트 편집가능 function
	editTrialReport.editable = function(){
		//name="contenteditable"
		applyDatePicker('releasePlanDate');
		applyDatePicker('releaseRealDate');

		// body 입력 활성화
		var editableElements = $("[name=contenteditable]");
		$.each(editableElements,function(index,element){
			var inputs = $(element).find("input[type=checkbox]");
			if(inputs.length > 0){
				$(inputs).removeAttr("disabled");
				//$(element).attr("contenteditable",true);
			}else{
				$(element).attr("contenteditable",true);
				$(element).css("text-align","left");
				$(element).css("vertical-align","top");
			}
		});
	};
	//  API - 레포트 저장 function
	editTrialReport.saveTrialReport = function(callback){
		var trialReportData = new Object();
		trialReportData.cNo = "${cNo}";
		trialReportData.rNo = "${rNo}";
		trialReportData.distChannel = $("#distChannel").val();    //유통채널
		trialReportData.releasePlanDate = $("#releasePlanDate").val()     //출시일(목표)
		trialReportData.releaseRealDate = $("#releaseRealDate").val()     //출시가능일
		trialReportData.result = null;
		var checkboxs = ["pass","progress","retest","fail"];
		$.each(checkboxs,function (index,checkboxId){
			if($("#" + checkboxId).prop("checked")){
				trialReportData.result = checkboxId;
			}
		});
		trialReportData.writerComment = $("#writerComment").val();

		// body 입력 비 활성화
		var editableElements = $("[name=contenteditable]");
		$.each(editableElements,function(index,element){
			var inputs = $(element).find("input[type=checkbox]");
			if(inputs.length > 0){
				$.each(inputs,function(index,item){
					if($(item).prop("checked")) {
						$(item).attr("checked", "checked");
					}else{
						$(item).removeAttr("checked");
					}
					$(item).attr("disabled","disabled");
				});
			}else{
				$(element).attr("contenteditable",false);
			}
		});

		trialReportData.reportContents = $("#reportBody").html();

		console.log(trialReportData);

		$('#lab_loading').show();

		var successFn = function(data){
			//저장완료후 진행할 처리
			console.log("editTrialReport.saveTrialReport.successFn ");
			$('#lab_loading').hide();
			if( data.status == "S"){
				alert("성공적으로 저장되였습니다.");
			}
			if($.isFunction(callback)){
				callback(data);
			}
		}
		var errorFn = function(){
			$('#lab_loading').hide();
			return alert('오류(http error)');
		}
		//TODO 저장처리
		var ajaxConfig = new Object();
		ajaxConfig.type = "POST";
		ajaxConfig.url = "/trialReport/saveTrialReport";
		ajaxConfig.dataType = "json";
		ajaxConfig.data = trialReportData;
		ajaxConfig.async = true;
		ajaxConfig.success = successFn; //successFn(responseData);
		ajaxConfig.error = errorFn;     //errorFn(request, status, errorThrown);
		ajaxConfig.traditional = true;
		$.ajax(ajaxConfig);
	}
	// 이미지 업로드
	editTrialReport.uploadReportImage = function(fileElement){
		var files = fileElement.files;
		if(files.length <= 0){return;}
		var gubun = $(fileElement).data("gubun");
		console.log("editTrialReport.uploadReportImage gubun=" + gubun + ", filenName=" + files[0].name);
		var form = new FormData();
		form.append("trialReportFile",files[0]);

		var successFn = function(data){
			//저장완료후 진행할 처리
			console.log("editTrialReport.uploadReportImage.successFn ");
			console.log(data);
			if( data.status == "S"){
				//alert("성공적으로 저장되였습니다.");
				var files = data.trialReportFiles;
				if(files != null){
					$.each(files,function(index,item){
						var imgUrl = "/devDocImage/" + item.webUrl;
						console.log($("#img" + item.gubun));
						$("#img" + item.gubun).attr("src",imgUrl);
					});
				}
			}
			$('#lab_loading').hide();
			if(data.status == "E"){
				console.log(data.msg);
				alert("이미지 저장 실패 되였습니다.");
			}
		}
		var errorFn = function(){
			$('#lab_loading').hide();
			return alert('이미지 저장 오류(http error)');
		}

		$('#lab_loading').show();
		var ajaxConfig = new Object();
		ajaxConfig.type = "POST";
		ajaxConfig.url = "/trialReport/uploadTrialReportFile?rNo=${rNo}&type=img&gubun=" + gubun;
		ajaxConfig.processData = false;
		ajaxConfig.contentType = false;
		ajaxConfig.data = form;
		ajaxConfig.success = successFn; //successFn(responseData);
		ajaxConfig.error = errorFn;     //errorFn(request, status, errorThrown);
		ajaxConfig.cache = false;
		$.ajax(ajaxConfig);
	}

	editTrialReport.initBody = "";
	editTrialReport.beforePrint = function(){
		editTrialReport.initBody = document.body.innerHTML;
		var html= "";
		$("#water_mark_td").html(html);
		html += "!! ----------- ";
		html += "<%=UserUtil.getUserId(request)%>";
		html += "&nbsp;&nbsp;|&nbsp;&nbsp;";
		html += "<%=UserUtil.getUserName(request)%>";
		html += "&nbsp;&nbsp;|&nbsp;&nbsp;";
		html += "<%=UserUtil.getDeptCodeName(request)%>";
		html += "&nbsp;&nbsp;|&nbsp;&nbsp;";
		html += "IP:"+"<%=UserUtil.getUserIp(request)%>";
		html += "&nbsp;&nbsp;|&nbsp;&nbsp;";
		html += editTrialReport.getCurrentDate();
		html += "-------------- !!";
		$("#water_mark_td").append(html);
		$("#water_mark_table").show();
		$("#confi").show();
		document.body.innerHTML = $("#reportContents").html();
	}
	editTrialReport.afterPrint = function(){
		$("#water_mark_td").append("");
		$("#water_mark_table").hide();
		$("#confi").hide();
		document.body.innerHTML = editTrialReport.initBody;
	}
	editTrialReport.getCurrentDate = function(){
		var toDay = "";
		var date =new Date();
		toDay += date.getFullYear()+"-";
		toDay += (date.getMonth()+1)+"-";
		toDay += date.getDate();
		toDay += " "+date.getHours()+":";
		toDay += date.getMinutes()+":";
		toDay += date.getSeconds();
		return toDay;
	}
	editTrialReport.insertPrintLog = function(apprNo,type){
		$.ajax({
			type: 'POST',
			data:{
				"apprNo" : apprNo,
				"tbType" : "trialReportAppr2",
				"tbKey" : "${rNo}",
				"type" : type
			},
			url: '../common/insertPrintLogAjax',
			dataType: 'json',
			async : true,
			success: function (data) {

			},error: function(XMLHttpRequest, textStatus, errorThrown){
				alert("에러발생");
			}
		});
	}
	editTrialReport.printCheck = function(){
		var userId = "<%=userId%>";
		var isGrade3 = ("${userUtil:getUserGrade(pageContext.request)}" === "3"); // 3;
		var isAdmin = ("${userUtil:getIsAdmin(pageContext.request)}" === "Y"); //"Y";
		var arrObjWriterUserIds = $("[name=writerUserId]");
		var isWriter = false;
		$.each(arrObjWriterUserIds,function(index,objWriterId){
			if(userId == $(objWriterId).val()){isWriter = true;}
		});
		var isCreater = ($("#createUser").val() === "<%=userId%>");

		console.log("editTrialReport.printCheck: userId=" + userId + ", isGrade3=" + isGrade3 + ", isAdmin=" + isAdmin + ", isWriter=" + isWriter + ", isCreater=" + isCreater)

		if(isCreater || isWriter || isGrade3 || isAdmin){
			window.onbeforeprint = editTrialReport.beforePrint;
			window.onafterprint = editTrialReport.afterPrint;
			window.print();
			editTrialReport.insertPrintLog("","P");
		}else{
			var URL = "../approval/printConfirmDataAjax";
			$.ajax({
				type:"POST",
				url:URL,
				data:{
					"tbType" : "trialReportAppr2",
					"tbKey" : "${rNo}"
				},
				dataType:"json",
				success:function(data) {
					if( typeof data.apprNo == 'undefined' || data.apprNo == null || data.apprNo == "" ) {
						if(confirm("프린트/다운로드 결재를 받으셔야 합니다.\n결재를 요청하시겠습니까?")) {
							$("#requestReason").val("");
							openDialog('open');
						}
					} else {
						window.onbeforeprint = editTrialReport.beforePrint;
						window.onafterprint = editTrialReport.afterPrint;
						if( data.lastState == '1' ) {
							//여기는 프린트를 해준다.
							if( data.printCount == 0 ) {
								window.print();
								editTrialReport.insertPrintLog(data.apprNo,"P");
							} else {
								if(confirm("이미 출력/다운로드를 하셨습니다.\n결재를 다시 요청하시겠습니까?")) {
									$("#requestReason").val("");
									openDialog('open');
								}
							}
						} else if( data.lastState == '2' ){
							if(confirm("프린트/다운로드 요청에 대한 결재 반려되었습니다.\n결재를 요청하시겠습니까?")) {
								$("#requestReason").val("");
								openDialog('open');
							}
						} else if( data.lastState == '0' ) {
							alert("프린트/다운로드 요청에 대한 결재가 완료되지 않았습니다.\n결재 완료 후 다시 진행해주세요.");
						}
					}
				},
				error:function(request, status, errorThrown){
					alert("오류가 발생하였습니다.");
				}
			});
		}
	}

	var goPrintRequest = function() {
		if( !chkNull($("#requestReason").val()) ) {
			alert("요청사유를 입력해주세요.");
			$("#requestReason").focus();
			return;
		} else {
			if(confirm("상신하시겠습니까?")) {
				var URL = "../approval/printRequestAjax";
				$.ajax({
					type:"POST",
					url:URL,
					data:{
						"tbType" : "trialReportAppr2",
						"tbKey" : "${rNo}",
						"requestReason" : $("#requestReason").val(),
						"reqUserId" : "<%=userId%>",
						"title" : $("#productName").val() + " 시생산결과보고서 다운로드/프린트 결재 요청"
					},
					dataType:"json",
					success:function(data) {
						if(data.status == 'S') {
							alert("프린트/다운로드 결재를 요청했습니다.");
							closeDialog('open');
						} else {
							alert("프린트/다운로드 결재를 요청중 오류가 발생했습니다.\n다시 시도해주세요.");
						}
					},
					error:function(request, status, errorThrown){
						alert("오류가 발생하였습니다.");
					}
				});
			}
		}
	}
	
	
	/*파일 첨부 관련*/
	/* 파일첨부 관련 함수 START */
	var attatchFileArr = [];
	var attatchFileTypeArr = [];
	
	function callAddFileEvent(){
		$('#attatch_common').click();
	}
	
	function setFileName(element){
		if(element.files.length > 0)
			$(element).parent().children('input[type=text]').val(element.files[0].name);
		else 
			$(element).parent().children('input[type=text]').val('');
	}
	
	// 목록에 파일추가
	function addFile(element, fileType){
		var randomId = Math.random().toString(36).substr(2, 9);

		if($('#attatch_common').val() == null || $('#attatch_common').val() == ''){
			return alert('파일을 선택해주세요');
		}
		
		fileElement = document.getElementById('attatch_common');
		
		var file = fileElement.files;
		console.log("file :: "+file);
		var fileName = file[0].name
		console.log("fileName :: "+fileName);
		var fileTypeText = $(element).text();
		console.log("fileTypeText :: "+fileTypeText);
		var isDuple = false;
		attatchFileArr.forEach(function(file){
			if(file.name == fileName)
				isDuple = true;
		})
		
		if(isDuple){
			if(!confirm('같은 이름의 파일이 존재합니다. 계속 진행하시겠습니까?')){
				return;
			};
		}
		
		attatchFileArr.push(file[0]);
		attatchFileArr[attatchFileArr.length-1].tempId = randomId;
		attatchFileTypeArr.push({fileType: fileType, fileTypeText: fileTypeText, tempId: randomId});	
		
		var childTag = '<li><a href="#none" onclick="removeFile(this, \''+randomId+'\')"><img src="/resources/images/icon_del_file.png"></a><span>'+fileTypeText+'</span>&nbsp;'+fileName+'</li>'
		$('ul[name=popFileList]').append(childTag);
		$('#attatch_common').val('');
		$('#attatch_common').change();
		
	}
	
	// 목록에서 파일 삭제
	function removeFile(element, tempId){
		$(element).parent().remove();
		attatchFileArr = attatchFileArr.filter(function(file){
			if(file.tempId != tempId) {
				return file;
			}
		})
		attatchFileTypeArr = attatchFileTypeArr.filter(function(typeObj){
			if(typeObj.tempId != tempId) 
				return typeObj;
		});
	}
	
	//파일 업로드 
	function trial_uploadFiles(){
		
		var rNo = "${rNo}";
		
		var formData = new FormData();
		formData.append("rNo", rNo);
		
		for(var i = 0; i < attatchFileArr.length; i++){
			formData.append("file", attatchFileArr[i]);
		}
		
		for (var i = 0; i < attatchFileTypeArr.length; i++) {
			formData.append('fileType', attatchFileTypeArr[i].fileType)
			formData.append('fileTypeText', attatchFileTypeArr[i].fileTypeText)
		}
		
		$('#lab_loading').show();
		$.ajax({
			url: '/trialReport/uploadTrialReportAttachFile',
			contentType: 'multipart/form-data',
			type: 'POST',
			data: formData,
			processData: false,
            contentType: false,
            cache: false,
            success: function(data){
            	if( data.status == "S"){
            		var fileList = $("#attachmentList");
            		//fileList.empty();
            		
            		var files = data.uploadTrialReportAttatchFiles;
            		for(var i=0; i<files.length; i++){
            			var html = "";
            			html += "<li id=\"file_li_"+files[i].fno+"\" style=\"list-style:none; padding-bottom: 5px;\">";
            			html += "	<a href='javascript:downloadFile("+files[i].fno+")'>"+files[i].orgFileName+"</a>&nbsp;&nbsp;&nbsp;";
            			html += "	<button class=\"btn_doc\" onclick=\"deleteFile("+files[i].fno+",`" + files[i].orgFileName + "`)\"><img src=\"/resources/images/icon_doc04.png\">삭제</button>";
            			html += "</li>"
            			//var listItem = $("<li>").text(files[i]);
                        fileList.append(html);
            		}
            	}
            	$('#lab_loading').hide();
            	closeDialogWithClean('dialog_trial_attatch');
            },
		 	error: function () {
             console.log("[1] 파일 목록을 가져오는 동안 오류가 발생했습니다");
         }
    		
		});
	}
	
	

	//팝업창 닫기
	function closeDialogWithClean(dialogId){ 
		initDialog();
		closeDialog(dialogId);
	}
	
	//첨부파일 관련 목록 초기화.
	function initDialog(){
		attatchFileArr = [];
		$('ul[name=popFileList]').empty();
		$('#attatch_common_text').val('');
		$('#attatch_common').val('')
	}
	
	//시생산결과보고서 첨부파일 링크
	function downloadFile(fNo){
		location.href = '/file/downloadtrialFile?fNo='+fNo;
	}
	
	//시생산결과보고서 첨부파일 삭제
	function deleteFile(fNo, fileName){
		var tmpfNo = fNo;
		//console.log(tmpfNo);
		
		if(confirm('첨부파일 ['+fileName+']을(를) 정말 삭제하시겠습니까?')){
			$('#lab_loading').show();
			$.ajax({
				url: '/file/deleteTrialFile',
				type: 'post',
				data: { fNo: fNo },
				success: function(data){
					if(data == 'S'){
						alert('정상적으로 삭제되었습니다')
						console.log($("#file_li_"+tmpfNo)+"삭제");
						$("#file_li_"+tmpfNo).remove();
						$('#lab_loading').hide();
					} else if(data == 'E'){
						alert('파일 삭제 오류(1)');
						$('#lab_loading').hide();
					} else {
						alert('존재하지 않는 파일입니다');
						$('#lab_loading').hide();
					}
				},
				error: function(a,b,c){
					//console.log(a,b,c) //a:xhr ,b:status, c:error
					alert('파일 삭제 오류(2)');
					$('#lab_loading').hide();
				}
			})
		}
	}
	/* 파일첨부 관련 함수 END */
</script>

<c:if test="${mode == 'appr2'}">
	<script type="text/javascript" src="/resources/js/apprClass.js?v=<%= System.currentTimeMillis()%>"></script>
	<script type="text/javascript">
		$(document).ready(function(){
			console.log("$(document).ready ");
			fn.autoComplete($("#trialAppr2Keyword"));
		});

		var rNo = "${rNo}";
		var trialAppr2 = new Object();
		trialAppr2.tbType = "trialReportAppr2";
		trialAppr2.selectId = "apprLineSelectTrial";       // 결재선 라인 select
		trialAppr2.doApprSubmit = function(){
			var tbKey = "${rNo}";
			var popupId = "approval_trialReportAppr2";
			var sussesFn = function(){
				window.location.href = "/trialReport/trialReportList?func=historyBack";
			};
			apprClass.doApprSubmit(popupId,tbKey,sussesFn);
		}
	</script>
</c:if>