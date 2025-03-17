<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ page import="kr.co.aspn.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ page session="false" %>
<%
	String userId = UserUtil.getUserId(request);
    String userName = UserUtil.getUserName(request);
	String userGrade = UserUtil.getUserGrade(request);
	String userDept = UserUtil.getDeptCode(request);
    String userDeptName = UserUtil.getDeptCodeName(request);
	String userTeam = UserUtil.getTeamCode(request);
    String userTeamName = UserUtil.getTeamCodeName(request);
	String isAdmin = UserUtil.getIsAdmin(request);
%>
<title>레포트</title>
<link rel="stylesheet" href="/resources/CLEditor/jquery.cleditor.css?param=1" />
<script type="text/javascript" src="/resources/CLEditor/jquery.cleditor.min.js?param=1"></script>
<link href="/resources/js/jquery.auto-complete.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="/resources/js/jquery.auto-complete.js"></script>
<%--<script type="text/javascript" src="../resources/js/productdevapproval.js"></script>--%>

<input type="hidden" id="state" name="state" value="0" />

<input type="hidden" id="docNo" name="docNo" value="" />
<input type="hidden" id="docVersion" name="docVersion" value="" />


<div class="wrap_in" id="fixNextTag">
	<span class="path">시생산 보고서&nbsp;&nbsp;<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;보고서&nbsp;&nbsp;<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;<a href="#">${strUtil:getSystemName()}</a></span>
	<section class="type01">
		<h2 style="position:relative"><span class="title_s">Trial Production Report</span>
			<span class="title" id="span_reportTitle">시생산 보고서 생성</span>
			<div  class="top_btn_box">
				<ul>
					<li>
						<button class="btn_circle_nomal" id="list" onclick="window.history.back()">&nbsp;</button>
					</li>
				</ul>
			</div>
		</h2>
		<div class="group01" >
			<div class="title"><!--span class="txt">연구개발시스템 공지사항</span--></div>
			<div class="list_detail">
				<ul style="border-top:none;">
					<li>
						<dt>제조공정서 번호</dt>
						<dd class="pr20 pb10">
<!-- 							<input type="text" name="dNo" id="dNo" style="width:70%;" placeholder="제조공정서 번호를 입력해주세요. (숫자만 입력)" maxlength="10" /> -->
							<input type="hidden" id="dNo" name="dNo" value="" />
							<div class="selectbox req" style="width:45%">
	                            <select id="dNoSelect" name="dNoSelect" onchange="trialReport.manufacturingProcessDocOnchange(this)">
	                            	<option value="">-- 제조공정서번호 선택 --</option>
	                            </select>
								<label for="dNoSelect">-- 제조공정서번호 선택 --</label>
							</div>
						</dd>
					</li>
					<li class="mb5">
						<dt>라인</dt>
						<dd class="pr20" style="line-height:0px;">
							<input type="hidden" id="line" name="line" value="" />
							<input type="text" class="" id="lineName" name="lineName" value="" style="width:70%;" readonly="readonly" maxlength="100" />
						</dd>
					</li>
					<li class="mb5">
						<dt>시생산결과보고서 양식</dt>
						<dd class="pr20" style="line-height:0px;">
							<select id="trialProductionReportTemplates" name="trialProductionReportTemplates" size="10">
								<option value="0" selected="selected">브래드,케익</option>
								<option value="1">면</option>
								<option value="2">빚은(떡)</option>
								<option value="3">당류가공품&앙금&호남잼&버터크림&조리내용물</option>
								<option value="4">휘핑크림(테트라)</option>
								<option value="5">샐러드</option>
								<option value="6">볼샐러드</option>
								<option value="7">음료,소스,기타가공품</option>
								<option value="8">육가공</option>
								<option value="9">샌드팜</option>
							</select>
						</dd>
					</li>
					<li>
						<dt>작성자 지정</dt>
						<dd>
							<input type="text" placeholder="작성자 5명 입력후 선택" style="width:295px; float:left;" class="req" id="writerKeyword">
							<button class="btn_small01 ml5" onclick="trialReport.writerAddLine(); return false;" name="baseApprovalDesign">작성자 추가</button></br>
						</dd>
					</li>
					<li>
						<dt style="background-image: none"></dt>
						<dd>
							<div class="file_box_pop2" style="height: 145px">
								<ul id="writerLine">
									<li><img src="../resources/images/icon_del_file.png" onclick="trialReport.writerRemoveLine(this)">  <%=userName%><strong>/<%=userId%>/<%=userDeptName%>/<%=userTeamName%></strong><input type="hidden" name="writerUserId" value='<%=userId%>'></li>
								</ul>
							</div>
						</dd>
					</li>
				</ul>
			</div>
			<div class="btn_box_con5">
			</div>
			<div class="btn_box_con4">
				<input type="button" class="btn_admin_sky" id="save" value="자재검토 요청" onclick="apprClass.openApprovalDialog('approval_trialReportCreate');" ><!-- 시생산결과보고서 생성 결재상신 -->
				<input type="button" class="btn_admin_gray" id="cancel" value="취소" onclick="window.history.back()">
			</div>
		</div>
	</section>	
</div>
	<input type="hidden" id="hiddenDocNo" value="${docNo}"/>
	<input type="hidden" id="hiddenDocVersion" value="${docVersion}"/>
	<input type="hidden" id="deptFulName" />
	<input type="hidden" id="titCodeName" />
	<input type="hidden" id="userId" />
	<input type="hidden" id="userName"/>
	<input type="hidden" id="loginUserId"/>

	<input type="hidden" id="writerUserIdArr"/>

	<!-- 시생산보고서 생성 결재 레이어 start-->
	<div class="white_content" id="approval_trialReportCreate">
		<input type="hidden" name="jobtypeTrialCreate" id="jobtypeTrialCreate" value="popup"/>
		<input type="hidden" name="userId1TrialCreate" id="userId1TrialCreate" value="<%=userId%>" />
		<input type="hidden" name="userId2TrialCreate" id="userId2TrialCreate" />
		<input type="hidden" name="userId3TrialCreate" id="userId3TrialCreate" />
		<input type="hidden" name="userId4TrialCreate" id="userId4TrialCreate" />
		<input type="hidden" name="userId5TrialCreate" id="userId5TrialCreate" />
		<input type="hidden" name="userId6TrialCreate" id="userId6TrialCreate" />
		<input type="hidden" name="userId7TrialCreate" id="userId7TrialCreate" />
		<input type="hidden" name="userId8TrialCreate" id="userId8TrialCreate" />
		<input type="hidden" name="userIdTrialCreateArr" id="userIdTrialCreateArr"/>
		<input type="hidden" name="tbKeyTrialCreate" id="tbKeyTrialCreate" value=""/>
		<input type="hidden" name="totalStepTrialCreate" id="totalStepTrialCreate" value="6"/>
		<input type="hidden" name="typeTrialCreate" id="typeTrialCreate" value="0"/>
		<input type="hidden" name="docNoTrialCreate" id="docNoTrialCreate" value="${docNo}" />
		<input type="hidden" name="docVersionTrialCreate" id="docVersionTrialCreate" value="${docVersion}" />
		<input type="hidden" name="TrialCreateCompanyCd" id="TrialCreateCompanyCd" />

		<div class="modal" style="	margin-left:-500px;width:1000px;height: 550px;margin-top:-300px">
			<h5 style="position:relative">
				<span class="title">자재검토 요청</span><!-- 시생산 보고서 결재 상신 -->
				<div  class="top_btn_box">
					<ul><li><button class="btn_madal_close" onClick="closeDialog('approval_trialReportCreate'); return false;"></button></li></ul>
				</div>
			</h5>
			<div class="list_detail">
				<ul>
					<li class="pt10">
						<dt style="width:20%">제목</dt>
						<dd style="width:80%"><input type="text" class="req" style="width:573px" id="trialCreateTitle"></dd>
					</li>
					<li>
						<dt style="width:20%">의견</dt>
						<dd style="width:80%;">
							<div class="insert_comment">
								<table style=" width:756px">
									<tr><td><textarea style="width:100%; height:50px" placeholder="의견을 입력하세요" id="trialCreateComment"></textarea></td><td width="98px"></td></tr>
								</table>
							</div>
						</dd>
					</li>
					<li class="pt5">
						<dt style="width:20%">자재담당자</dt>
						<dd style="width:80%;" class="ppp">
							<input type="text" placeholder="결재자명 2자이상 입력후 선택" style="width:198px; float:left;" class="req" id="trialCreateKeyword" name="trialCreateKeyword">
							<button class="btn_small01 ml5" onclick="apprClass.approvalAddLine(this); return false;" name="baseApprovalTrialCreate">결재자 추가</button>
<%--							<button class="btn_small02  ml5" onclick="approvalAddLine(this); return false;" name="circulationPayment">회람</button>--%>
							<button class="btn_small02  ml5" onclick="apprClass.approvalAddLine(this); return false;" name="referPaymentCreate">참조</button>

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
								<ul id="apprLineTrialCreate"></ul>
							</div>
							<div class="file_box_pop3" style="height:190px;">
								<ul id="CirculationRefLineTrialCreate">
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
				<button class="btn_admin_red" onclick="trialReport.doApprSubmit(); return false;">결재상신</button>
				<button class="btn_admin_gray" onclick="closeDialog('approval_trialReportCreate'); return false;">상신 취소</button>
			</div>
		</div>
	</div>
	<!-- 시생산보고서 생성 결재 레이어 end-->


<script type="text/javascript">
	var trialReport = new Object();
	trialReport.tbType = "trialReportCreate";
	trialReport.selectId = "apprLineSelectTrial";       // 결재선 라인 select
	trialReport.settingManufacturingProcessDoc = function(docNo, docVersion) {

		var selectElement = $("#dNoSelect");

		jQuery.ajax({
			async: false,
			type: 'GET',
			dataType: 'json',
			url: '/dev/selectboxManufacturingProcessDoc',
			data: {docNo: docNo, docVersion: docVersion},
			success: function (data) {
				var index;

				// 초기화
				selectElement.empty();
				selectElement.append("<option>-- 제조공정서번호 선택 --</option>");
				// 옵션 추가
				for (index = 0; index < data.length; index++){
					var opt = $("<option>" + data[index].dNo + "</option>");
					opt.attr({
						'value' : data[index].dNo ,
						'data-lineCode' : data[index].lineCode ,
						'data-companyCode' : data[index].companyCode ,
						'data-plantCode' : data[index].plantCode
					});
					selectElement.append(opt);
				}
			},
			error: function () {
				alert('제조공정서 불러오기에 실패했습니다.');
				return;
			}
		});
	}
	trialReport.manufacturingProcessDocOnchange = function(select){
		var selected = $($(select).find("option:selected"));
		console.log(selected);
		trialReport.setLineCode(selected.data("linecode"),selected.data("companycode"),selected.data("plantcode"));
	}
	trialReport.setLineCode = function( lineCode, companyCode, plantCode ){
		console.log("trialReport.setLineCode lineCode=" + lineCode + ", companyCode=" + companyCode + ", plantCode=" + plantCode);
		$('#line').val("");
		$('#lineName').val("");
		$.ajax({
			type:"POST",
			url:"/common/plantLineListAjax?companyCode=" + companyCode + "&plantCode=" + plantCode,
			dataType:"json",
			async:false,
			success:function(data) {
				var list = data.RESULT;
				$.each(list, function( index, value ){ //배열-> index, value
					if(lineCode == value.lineCode){
						$('#line').val(nvl(value.lineCode));
						$('#lineName').val(nvl(value.lineName));
					}
				});
			},
			error:function(request, status, errorThrown){
				alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
			}
		});
		// jQuery.ajax({
		// 	async : false,
		// 	type : 'GET',
		// 	dataType : 'json',
		// 	url : '/dev/selectLineDetailFromPlantLine',
		// 	data : { lineCode : lineCode, companyCode : companyCode, plantCode: plantCode },
		// 	success : function(data){
		// 		console.log(data);
		//
		// 		if( data == null ){
		// 			return;
		// 		}
		//
		// 		var lineCode = data.lineCode;
		// 		var lineName = data.lineName;
		//
		// 		if( nvl(lineCode) != "" ){
		// 			$('#line').value = nvl(lineCode);
		// 			$('#lineName').value = nvl(lineName);
		// 			return;
		// 		}
		// 	},
		// 	error : function(){
		// 		alert('라인 불러오기에 실패했습니다.\r\n다시 시도하거나 관리자에게 문의해 주세요.');
		// 		return;
		// 	}
		// });
	}
	trialReport.writerAddLine = function(){
		// 시생산보고서 작성자 추가
		var tarId = $("#userId").val();
		if(nvl(tarId,"") == ""){return;}
		var objIds = $("[name=writerUserId]");
		if(objIds.length == 5){return;}
		var arrIds = new Array();
		$.each(objIds,function(index,objId){ arrIds.push($(objId).val()); });
		arrIds.push(tarId);
		$("#writerUserIdArr").val(arrIds.join(","));
		var html = '<li><img src="../resources/images/icon_del_file.png" onclick="trialReport.writerRemoveLine(this)">  '+$("#userName").val()+'<strong>'+'/'+$("#userId").val()+'/'+$("#deptFulName").val()+'/'+$("#titCodeName").val()+'</strong><input type="hidden" name="writerUserId" value='+$("#userId").val()+'></li>';
		$("#writerLine").append(html);

		$("#deptFulName").val('');
		$("#titCodeName").val('');
		$("#userId").val('');
		$("#userName").val('');
		$("#writerKeyword").val("");
	}
	trialReport.writerRemoveLine = function(delbtn){
		$(delbtn).parent().remove();
		var objIds = $("[name=writerUserId]");
		var arrIds = new Array();
		$.each(objIds,function(index,objId){ arrIds.push($(objId).val()); });
		$("#writerUserIdArr").val(arrIds.join(","));
	}
	trialReport.checkTrialReportCreate = function(){
		if(nvl($("#dNoSelect").find("option:selected").eq(0).attr("value"),"") == ""){
			alert("제조공정서 번호를 선택하십시오.");
			return false;
		}
		var writerUserIdArr = $("#writerUserIdArr").val().split(",");
		// TODO 작성자 중복체크
		if(writerUserIdArr.length != 5){
			alert("작성자 5명을 지정하십시오.");
			return false;
		}
		return true;
	}
	trialReport.checkApprBeforSubmit = function(){
		var length =  $("#userIdTrialCreateArr").val().split(",").length;

		if(length == 0){
			alert("결재선을 지정하세요.");
			fn.hideloading();
			return false;
		}

		if($("#trialCreateTitle").val() == ""){
			$("#trialCreateTitle").focus();
			fn.hideloading();
			alert("결재 제목을 입력하세요.");
			return false;
		}
		return true;
	}
	trialReport.trialReportCreate = function(){
		var checkResult = trialReport.checkApprBeforSubmit();
		if(!checkResult)return;

		var postData = new Object();
		postData.dNo = $("#dNoSelect").val();
		//postData.lineName = $("#lineName").val();
		postData.line = $("#line").val();
		postData.reportTemplateNo = $("#trialProductionReportTemplates").find("option:selected").eq(0).attr("value");
		postData.reportTemplateName = $("#trialProductionReportTemplates").find("option:selected").eq(0).text();
		postData.writerUserIdArr = $("#writerUserIdArr").val();

		var successsFn = function(data){
			console.log(data);
			if(data.status == "S"){
				var rNo = data.rNo;
				apprClass.doApprSubmit("approval_trialReportCreate",rNo,function(res){
					if(res.status == 'S'){
						var form = document.createElement('form');
						form.style.display = 'none';
						$('body').append(form);
						form.action = '/dev/productDevDocDetail';
						form.target = '_self';
						form.method = 'post';
						appendInput(form, 'docNo', "${docNo}");
						appendInput(form, 'docVersion', "${docVersion}");
						$(form).submit();
					}
				});
			}else{
				alert("시생산보고서 생성 실패(http error)");
				fn.hideloading();
				console.log(data.resultMsg);
			}
		};
		fn.ajax("/trialReport/trialReportCreate",postData,successsFn,fn.ajaxErrorFn);
	}
	trialReport.doApprSubmit = function(){
		fn.showloading();
		window.setTimeout(trialReport.trialReportCreate,100);
	}

	$(document).ready(function(){
		fn.autoComplete($("#writerKeyword"));
		fn.autoComplete($("#trialCreateKeyword"));

		trialReport.settingManufacturingProcessDoc(${docNo},${docVersion});
	});
</script>
<script src="/resources/js/apprClass.js?v=<%= System.currentTimeMillis()%>" type="text/javascript"></script>