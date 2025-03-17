<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="userUtil" uri="/WEB-INF/tld/userUtil.tld"%>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ taglib prefix="dateUtil" uri="/WEB-INF/tld/dateUtil.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="kr.co.aspn.util.*" %>
<%@ page session="false" %>
<title>결재함</title>
<style>
/*추가*/
.outside{ border:0; font-family:'맑은고딕',Malgun Gothic; font-size:12px;}
.outside td{border:2px solid #666;}
.intable_title{ border:0;}
.intable_title td{border:1px solid #666; text-align:center; height:22px;}
.jungjong{ border:0; text-align:center;}
.jungjong th,.jungjong td{ border:1px solid #666; height:18px;}
.jungjong tbody td{ border-bottom:1px solid #ddd !important; border-top:1px solid #ddd !important;}
.jungjong th, .jungjong tfoot td{ background-color:#ebebeb;}

.material{border:0; text-align:center;}
.material th,.material td{ border:1px solid #666; height:18px;}
.material tr th{ background-color:#ebebeb;}

.material_inbox{ border:1px solid #999; text-align:center;}
.material_inbox th,.material_inbox td{  height:18px;}
.material_inbox tbody td{ border-top:1px solid #ddd !important;}
.material_inbox th{ }
.water_mark{font-family:'맑은고딕',Malgun Gothic; font-size:13px; margin-top:10px; float:left;}
.big_font{ font-size:20px;}
.color01{ background-color:#eaf1dd;}
.color02{background-color:#fde9d9;}
.color03{background-color:#dbe5f1;}
.color04{background-color:#ddd9c3;}
.color05{background-color:#f3f3f3;}

</style>
<script type="text/javascript">
<c:if test="${paramVO.tbType eq 'designRequestDoc' }">
$(document).ready(function() {
	var drNo = '${designReqDoc.drNo}';
	var nutritionType = '${designReqDoc.nutritionLabel.nutritionType}';
	if(nutritionType != 0){
		$.ajax({
			url: '/dev/getNutritionTableView',
			tyle: 'get',
			data: {drNo: drNo, type: nutritionType},
			success: function(data){
				$('#nutrientTable').append(data);
			},
			error: function(a,b,c){
				console.log(a,b,c)
			},
			complete: function(){
				$('#nutritionDiv').show();
				$('#nutritionDiv').next().show();
			}
		})
	}
	$("#designReqDoc_content > table").attr("width","100%");
	$("#designReqDoc_content > table").attr("style","");
	$("#designReqDoc_content > table").attr("font-size","12px !important");
});
</c:if>

<c:if test="${paramVO.tbType eq 'manufacturingProcessDoc' }">
$(document).ready(function() {
	  document.oncontextmenu = function (e) {
		   return false;
	  }
	  document.ondragstart = function (e) {
		   return false;
	 }
	  document.onselectstart = function (e) {
		   return false;
	 }
});
</c:if>

function approvalSubmit() {
	/* if( !chkNull($("#note").val()) ) {
		alert("결재 의견을 입력해주세요.");
		$("#note").focus();
		return;
	} else */ {
		if(confirm("승인하시겠습니까?")) {
			var URL = "../approval/approvalSubmitAjax";
			$('#lab_loading').show();
			$.ajax({
				type:"POST",
				url:URL,
				data:{
					"apprNo" : '${apprItemHeader.apprNo}',
					"tbKey" : '${apprItemHeader.tbKey}',
					"tbType" : '${apprItemHeader.tbType}',
					"type" : '${apprItemHeader.type}',
					"title" : '${apprItemHeader.title}',
					"totalStep" : '${apprItemHeader.totalStep}',
					"currentStep" : '${apprItemHeader.currentStep}',
					"currentUserId" : '${apprItemHeader.currentUserId}',
					"regUserId" : '${apprItemHeader.regUserId}',
					"proxyCheck" : "${proxyCheck}",
					"state" : '1',
					"note" : $("#note").val()
				},
				dataType:"json",
				success:function(data) {
					if(data.status == 'S' ) {
						alert("결재가 완료되었습니다.");
						window.opener.loadList('1');
						self.close();
						//var url = "/approval/approvalDetailPopup?apprNo=${apprItemHeader.apprNo}&tbKey=${apprItemHeader.tbKey}&tbType=${apprItemHeader.tbType}";
						//document.location.href = url;
					} else {
						if(data.apprCount == 0){
							alert("상신취소 되였거나 존재하지 않는 결재입니다.");
							self.close();
						}else{
							alert("결재 승인 중 오류가 발생하였습니다. \n다시 처리해주세요.");
						}
					}
				},
				error:function(request, status, errorThrown){
					alert("결재 승인 중 오류가 발생하였습니다. \n다시 처리해주세요.");
				},
				complete: function(){
					$('#lab_loading').hide();
				}
			
			});	
		}
	}
}

function approvalReject() {
	if( !chkNull($("#note").val()) ) {
		alert("결재 의견을 입력해주세요.");
		$("#note").focus();
		return;
	} else {
		if(confirm("반려하시겠습니까?")) {
			var URL = "../approval/approvalRejectAjax";
			$('#lab_loading').show();
			$.ajax({
				type:"POST",
				url:URL,
				data:{
					"apprNo" : '${apprItemHeader.apprNo}',
					"tbKey" : '${apprItemHeader.tbKey}',
					"tbType" : '${apprItemHeader.tbType}',
					"type" : '${apprItemHeader.type}',
					"title" : '${apprItemHeader.title}',
					"totalStep" : '${apprItemHeader.totalStep}',
					"currentStep" : '${apprItemHeader.currentStep}',
					"currentUserId" : '${apprItemHeader.currentUserId}',
					"regUserId" : '${apprItemHeader.regUserId}',
					"proxyCheck" : "${proxyCheck}",
					"state" : '2',
					"note" : $("#note").val()
				},
				dataType:"json",
				success:function(data) {
					if(data.status == 'S' ) {
						alert("결재가 반려되었습니다.");
						window.opener.loadList('1');
						self.close();
						//var url = "/approval/approvalDetailPopup?apprNo=${apprItemHeader.apprNo}&tbKey=${apprItemHeader.tbKey}&tbType=${apprItemHeader.tbType}";
						//document.location.href = url;
					} else {
						if(data.apprCount == 0){
							alert("상신취소 되였거나 존재하지 않는 결재입니다.");
							self.close();
						}else{
							alert("반려 처리중 오류가 발생하였습니다. \n다시 처리해주세요.");
						}
					}
				},
				error:function(request, status, errorThrown){
					alert("반려 처리중 오류가 발생하였습니다. \n다시 처리해주세요.");
				},
				complete: function(){
					$('#lab_loading').hide();
				}			
			});
		}
	}
}

function viewNote(apbNo) {
	var URL = "../approval/viewNoteAjax";
	$.ajax({
		type:"POST",
		url:URL,
		data:{
			"apbNo" : apbNo
		},
		dataType:"json",
		success:function(data) {
			$("#viewNote").html(getTextareaHTML(data.note));
		},
		error:function(request, status, errorThrown){
			alert("오류가 발생하였습니다.");
		}			
	});
}

function getTextareaHTML(note) {
    return "</p><p>"+ note.trim().replace(/\n\r?/g,"</p><p>") +"</p>";
}

function goPrintRequest() {
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
					"tbType" : $("#tbType").val(),
					"tbKey" : $("#tbKey").val(),
					"requestReason" : $("#requestReason").val(),
					"reqUserId" : $("#regUserId").val(),
					"title" : "${productDevDoc.productName} 다운로드/프린트 결재 요청"
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

var initBody;
function beforePrint() { //인쇄 하기 전에 실행되는 내용
	initBody = document.body.innerHTML;
	var html= "";
	$("#water_mark_td").html(html);
	html += "!! ---------------------------- ";
	html += "<%=UserUtil.getUserId(request)%>";
	html += "&nbsp;&nbsp;|&nbsp;&nbsp;";
	html += "<%=UserUtil.getUserName(request)%>";
	html += "&nbsp;&nbsp;|&nbsp;&nbsp;";
	html += "<%=UserUtil.getDeptCodeName(request)%>";
	html += "&nbsp;&nbsp;|&nbsp;&nbsp;";
	html += "IP:"+"<%=UserUtil.getUserIp(request)%>";
	html += "&nbsp;&nbsp;|&nbsp;&nbsp;";
	html += getCurrentDate();
	html += "----------------------------- !!";
	$("#water_mark_td").append(html);
	$("#water_mark_table").show();
	document.body.innerHTML = $("#print_page").html();
	
}

function afterPrint(){ //인쇄가 끝난 후 실행되는 내용
	$("#water_mark").append("");
	$("#water_mark_table").hide(); 
	document.body.innerHTML = initBody;
}

function getCurrentDate() {
	var toDay = "";
	var date =new Date();
	toDay += date.getFullYear()+"-";
	toDay += date.getMonth()+"-";
	toDay += date.getDate();
	toDay += " "+date.getHours()+":";
	toDay += date.getMinutes()+":";
	toDay += date.getSeconds();
	return toDay;
}

function insertPrintLog(apprNo,type) {
	$.ajax({
		type: 'POST',
		data:{
			"apprNo" : apprNo,
			"tbType" : $("#tbType").val(),
			"tbKey" : $("#tbKey").val(),
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


<c:choose>
<c:when test='${(paramVO.tbType == "designRequestDoc" && userUtil:getUserId(pageContext.request) eq designReqDoc.regUserId) ||  (paramVO.tbType == "manufacturingProcessDoc" && userUtil:getUserId(pageContext.request) eq mfgProcessDoc.regUserId ) || userUtil:getUserGrade(pageContext.request) == "3" || userUtil:getIsAdmin(pageContext.request) == "Y"}'>
function printCheck() {
	window.onbeforeprint = beforePrint;
	window.onafterprint = afterPrint;
	window.print();
	insertPrintLog("","P");
}

function excelDownloadCheck() {
	//$('#form').attr('action', '/approval/excelDownload').submit();
	excelDownload();
	insertPrintLog("","D");
}
</c:when>
<c:otherwise>
function printCheck() {
	var URL = "../approval/printConfirmDataAjax";
	$.ajax({
		type:"POST",
		url:URL,
		data:{
			"tbType" : $("#tbType").val(),
			"tbKey" : $("#tbKey").val()
		},
		dataType:"json",
		success:function(data) {
			 if( typeof data.apprNo == 'undefined' || data.apprNo == null || data.apprNo == "" ) {
				if(confirm("프린트/다운로드 결재를 받으셔야 합니다.\n결재를 요청하시겠습니까?")) {
					$("#requestReason").val("");	
					openDialog('open');
				}
			} else {
				window.onbeforeprint = beforePrint;
				window.onafterprint = afterPrint;
				if( data.lastState == '1' ) {
					//여기는 프린트를 해준다.
					if( data.printCount == 0 ) {
						window.print();
						insertPrintLog(data.apprNo,"P");
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

function excelDownloadCheck() {
	var URL = "../approval/printConfirmDataAjax";
	$.ajax({
		type:"POST",
		url:URL,
		data:{
			"tbType" : $("#tbType").val(),
			"tbKey" : $("#tbKey").val(),
		},
		dataType:"json",
		success:function(data) {
			 if( typeof data.apprNo == 'undefined' || data.apprNo == null || data.apprNo == "" ) {
				if(confirm("프린트/다운로드 결재를 받으셔야 합니다.\n결재를 요청하시겠습니까?")) {
					$("#requestReason").val("");	
					openDialog('open');
				}
			} else {
				if( data.lastState == '1' ) {
					//여기는 프린트를 해준다.
					if( data.printCount == 0 ) {
						//$('#form').attr('action', '/approval/excelDownload').submit();
						excelDownload();
						insertPrintLog(data.apprNo,"D");
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
</c:otherwise>
</c:choose>

function excelDownload() {
	$.ajax({
		url: '/excel/mainTask',
		type : 'post',
		data: {tbKey: '${apprItemHeader.tbKey }', tbType:'${apprItemHeader.tbType}'},
		xhrFields: { responseType: 'blob' },
		success : function(data, b, xhr) {
			var contentDis = xhr.getResponseHeader('content-disposition');
	        var fileName = decodeURIComponent(contentDis.replace(/";/g,'').substr(contentDis.indexOf('filename=')+('filename=').length));
			var blob = new Blob([data]);
			//파일저장
			if (navigator.msSaveBlob) {
				return navigator.msSaveBlob(blob, '/excel/mainTask');
			} else {
				var link = document.createElement('a');
				link.href = window.URL.createObjectURL(blob);
				link.download = fileName;
				link.click();
			}
		},
	    error: function(a,b,c){
	        console.log(a,b,c);
	        return alert('파일 다운로드 오류[2]')
	    }
	});
}
</script>
<h2 style=" position:fixed;" class="print_hidden">
	<span class="title"><img src="/resources/images/bg_bs_box_fast02.png">&nbsp;&nbsp;프린트 및 다운로드 결재</span>
</h2>
<div  class="top_btn_box" style=" position:fixed;">
	<ul>
		<li><button type="button" class="btn_pop_close" onClick="self.close();"></button></li>
	</ul>
</div>
<div id='print_page'  style="padding:10px 0 20px 20px;">
	<table width="1046" cellpadding="0" cellspacing="0" class="print_hidden">
		<tr>
			<td height="50"></td>
		</tr>
		<tr>
			<td align="right" height="50" valign="top">
				<c:if test="${paramVO.viewType eq 'my' }">
				<c:if test="${apprItemHeader.lastState eq '1' }">
				<c:if test='${userUtil:getUserGrade(pageContext.request) == "2" || userUtil:getUserGrade(pageContext.request) == "3" || userUtil:getUserGrade(pageContext.request) == "4" || userUtil:getUserGrade(pageContext.request) == "5"}'>
				<button type="button" class="btn_admin_green" onClick="excelDownloadCheck();"><img src="/resources/images/icon_excel.png" style="vertical-align:middle"> 엑셀 다운로드</button>
				</c:if>
				<button type="button" class="btn_admin_nomal" onClick="printCheck();">프린트</button>
				</c:if>
				</c:if>	
				<button type="button" class="btn_admin_gray" onClick="self.close();">취소</button>
			</td>
		</tr>
	</table>
			<form name="form" id="form" method="post" action="">
			<input type="hidden" name="tbKey" id="tbKey" value="${apprItemHeader.tbKey }">
			<input type="hidden" name="tbType" id="tbType" value="${apprItemHeader.tbType }">
			<input type="hidden" name="type" id="type" value="${apprItemHeader.type }">
			<input type="hidden" name="currentUserid" id="currentUserid" value="${apprItemHeader.currentUserId }">
			<input type="hidden" name="currentStep" id="currentStep" value="${apprItemHeader.currentStep }">
			<input type="hidden" name="apprNo" id="apprNo" value="${apprItemHeader.apprNo }">
			<input type="hidden" name="title" id="title" value="${apprItemHeader.title }">
			<%-- <input type="hidden" name="regUserId" id="regUserId" value="${apprItemHeader.regUserId }"> --%>
			
			<c:if test="${paramVO.tbType eq 'manufacturingProcessDoc'}">
				<input type="hidden" name="regUserId" id="regUserId" value="${mfgProcessDoc.regUserId }">
			</c:if>
			<c:if test="${paramVO.tbType eq 'designRequestDoc'}">
				<input type="hidden" name="regUserId" id="regUserId" value="${designReqDoc.regUserId }">
			</c:if>
			
			<input type="hidden" name="tbTypeName" id="tbTypeName" value="${apprItemHeader.tbTypeName }">
			<table width="1046" cellpadding="0" cellspacing="0" class="print_hidden">
				<tr>
					<td valign="top">
						<div class="main_tbl">
							<table class="insert_proc01 tbl_app">
								<colgroup>
									<col width="13%"/>
									<col width="50%"/>
									<col />
								</colgroup>
								<tbody>
									<tr>
										<th colspan="4" style="border-left: none; font-size: 20px; text-align: center;">
											${apprItemHeader.tbTypeName } 프린트 및 다운로드 결재
										</th>
									</tr>
									<tr>
										<th style="border-left: none;">제품명</th>
										<td colspan="3">
											<%-- ${fn:substringBefore(apprItemHeader.title, '다운로드') } --%>
											<c:choose>
												<c:when test="${apprItemHeader.tbType eq 'manufacturingProcessDoc' }">
													${fn:substringBefore(apprItemHeader.title, '다운로드') }
												</c:when>
												<c:otherwise>
													${apprItemHeader.title}
												</c:otherwise>
											</c:choose>
										</td>
									</tr>
									<tr>
									<tr>
										<th style="border-left: none;">요청사유</th>
										<td colspan="3">
											${apprItemHeader.comment}
										</td>
									</tr>
									<tr>
										<th style="border-left: none;"> 결재자</th>
										<td>
											<div class="file_box_pop5">
												<ul>
													<c:forEach items = "${apprItemList}" var = "item" varStatus= "status">
													<input type="hidden" name="seq" id="seq" value="${item.seq }">
													<fmt:parseNumber var="seq" type="number" value="${item.seq}" />
													<li onMouseOver="location.href='#'">
														<span>
														<c:choose>
															<c:when test="${apprItemHeader.type=='3' }">
																<c:choose>
																	<c:when test="${item.seq eq '1' }">
																		상신
																	</c:when>
																	<c:otherwise>
																		프린트결재
																	</c:otherwise>
																</c:choose>
															</c:when>
															<c:otherwise>
																<c:choose>
																	<c:when test="${apprItemHeader.tbType eq 'designRequestDoc'}">
																		<c:choose>
																			<c:when test="${item.seq eq '1' }">
																				기안
																			</c:when>
																			<c:otherwise>
																				${item.seq-1}차 결재
																			</c:otherwise>
																		</c:choose>
																	</c:when>
																	<c:when test="${apprItemHeader.tbType eq 'manufacturingProcessDoc' }">
																		<c:choose>
																			<c:when test="${item.seq eq '1' }">
																				기안
																			</c:when>
																			<c:otherwise>
																				${item.seq-1}차 결재
																			</c:otherwise>
																		</c:choose>
																	</c:when>
																	<c:when test="${apprItemHeader.tbType eq 'report' }">
																		<c:choose>
																			<c:when test="${item.seq eq '1' }">
																				기안
																			</c:when>
																			<c:when test="${item.seq eq '2' }">
																				결재
																			</c:when>																
																		</c:choose>
																	</c:when>
																	<c:otherwise>
																		<c:choose>
																			<c:when test="${item.seq eq '1' }">
																				기안
																			</c:when>	
																			<c:otherwise>
																				결재
																			</c:otherwise>													
																		</c:choose>															
																	</c:otherwise>
																</c:choose>
															</c:otherwise>
														</c:choose>	
														</span> 
														${item.userName}
														<c:if test="${item.proxyYN eq 'Y' }">
															(대결:${item.proxyId})
														</c:if> <strong> ${item.authName}/${item.deptCodeName}&nbsp;(</strong><i>${item.stateText}</i>
														<strong>
															<c:choose>
															<c:when test="${item.seq eq '1' }">
															:${item.regDate}
															</c:when>
															<c:otherwise>
															<c:if test="${item.modDate != '' && item.modDate != null}">
															:${item.modDate}
															</c:if>
															</c:otherwise>												
															</c:choose>
															 ) 
														</strong> 
														<c:if test="${item.note !=null && item.note ne '' }">
															<a href="#" onclick="viewNote('${item.apbNo}');">
																의견 <img src="/resources/images/icon_app_mass.png"/>
															</a>
														</c:if>
													</li>										
													</c:forEach>
												</ul>
											</div>
										</td>
										<td id="viewNote">결재자 리스트 클릭시 결재의견을 확인할 수 있습니다.</td>
									</tr>
									<tr>
										<th style="border-left: none; ">참조자 및 회람자</th>
										<td>
											<div class="file_box_pop4">
												<ul>
													<c:forEach items = "${referenceList}" var = "ref">
													<c:if test="${ref.type eq 'C'}">
														<li><span> 회람</span> ${ref.userName} <strong> ${ref.authName}/${ref.deptCodeName}</strong></li>
													</c:if>
													</c:forEach>
												</ul>
											</div>
										</td>
										<td>
											<div class="file_box_pop4">
												<ul>
													<c:forEach items = "${referenceList}" var = "ref">
													<c:if test="${ref.type eq 'R'}">
														<li><span> 참조</span> ${ref.userName} <strong> ${ref.authName}/${ref.deptCodeName}</strong></li>
													</c:if>
													</c:forEach>
												</ul>
											</div>
										</td>
									</tr>
									<c:if test="${paramVO.viewType eq 'appr' }">
									<c:if test="${apprItemHeader.lastState eq '0' }">
									<c:if test = "${apprItemHeader.currentUserId eq paramVO.userId || proxyCheck > 0}">
									<tr>
										<th style="border-left: none; ">결재의견</th>
										<td colspan="3">
											<textarea style="width:100%; height:60px" name="note" id="note"></textarea>
										</td>
									</tr>
									</c:if>
									</c:if>
									</c:if>
								</tbody>
							</table>
						</div>
						<div class="fr pt20 pb10" style="margin-bottom:10px;"  id="buttonArea2">
						<c:if test="${paramVO.viewType eq 'appr' }">
						<c:if test="${apprItemHeader.lastState eq '0' }">
							<c:if test = "${apprItemHeader.currentUserId eq paramVO.userId || proxyCheck > 0}">
								<button class="btn_con_search"style="border-color:#09F; color:#09F"  onclick="approvalSubmit(); return false;"><img src="/resources/images/icon_s_approval.png"> 승인</button>
								<button class="btn_con_search" onclick="approvalReject(); return false;"><img src="/resources/images/icon_doc06.png"> 반려</button>					
							</c:if>	
						</c:if>
						</c:if>
						</div>
					</td>
				</tr>
			</table>
			</form>
			<!-- 결재 close --------------------------------------------------------------------------------------------------------------------------------------------------------->
		<c:if test="${paramVO.viewType eq 'my' }">
		<c:if test="${apprItemHeader.lastState eq '1' }">
		<c:choose>
			<c:when test="${paramVO.tbType eq 'manufacturingProcessDoc' }">
			<!-- 실제 출력대상 start ------------------------------------------------------------------------------------------------------------------------------------------------>
			<div class="print_box" style="table-layout:fixed;">
				<!-- 상단 머리정보 start-->
				<div class="hold">
					<table width="100%"  class="intable lineall mb5" >
						<colgroup>
							<col width="50%">
							<col width="30%">
							<col width="10%">
							<col width="10%">
						</colgroup>
						<tr>
							<td class="color05">제품제조공정서</td>
							<td rowspan="3">&nbsp;</td>
							<td class="color05">문서번호</td>
							<td>SHA-L-001</td>
						</tr>
						<tr>
							<td rowspan="2"><span class="big_font">${productDevDoc.productName}(${productDevDoc.productCode})/${mfgProcessDoc.plantName}</span></td>
							<td class="color05">제개정일</td>
							<td>${dateUtil:convertDate(productDevDoc.modDate,"yyyy-MM-dd HH:mm:ss","yyyy-MM-dd")}</td>
						</tr>
						<tr>
							<td class="color05">제정판수</td>
							<td>${productDevDoc.docVersion}</td>
						</tr>
					</table>
				</div>
				<!-- 상단 머리정보 close-->
				<!-- 부속정보 start-->
				<div>
					<div class="watermark"><img src="/resources/images/watermark.png"></div>
					<c:if test="${userUtil:getDeptCode(pageContext.request) != 'dept8' }">
					<c:forEach items="${mfgProcessDoc.sub}" var="sub" varStatus="subStatus">
					<table width="100%" class="intable linetop">
						<tr>
							<td class="color05">  부속제품명  : ${sub.subProdName}  </td>
						</tr>
					</table>
					<!-- 배합비 2개씩 반복 --->
					<div class="hold">
						<table width="100%"  class="intable lineside" >
							<c:set var="mixLength" value="${fn:length(sub.mix)}" />
							<c:forEach items="${sub.mix}" var="mix" varStatus="status">
							<c:set var="rigthItemLength" value="${fn:length(sub.mix[status.index+1].item)}" />					
							<c:if test="${status.index %2 == 0 }">
							<tr>
							</c:if>
							<c:choose>
								<c:when test="${status.index %2 == 0 }">
									<td width="50%" style=" border-right:2px solid #000; vertical-align:top;">
										<!-- 배합비 타이틀 start-->
										<table width="100%"  class="intable04" >
											<tr>
												<td class="color06">  배합비명  : ${mix.baseName}  </td>
											</tr>
										</table>
										<!-- 배합비 타이틀 close-->
										<table width="100%" class="intable02">
											<colgroup>
												<col width="52%">
												<col width="12%">
												<col width="12%">
												<col width="12%">
												<col width="12%">
											</colgroup>
											<thead>
												<tr>
													<th>원료명</th>
													<th>코드번호</th>
													<th>배합%</th>
													<th>BOM</th>
													<th>수량<br/>스크랩</th>
												</tr>
											</thead>
											<tbody>
												<c:set var="mixItemLength" value="${fn:length(mix.item)}" />
												<c:set var= "mixBomRateSum" value="0"/>
												<c:set var= "mixBomAmountSum" value="0"/>
												<c:forEach items="${mix.item}" var="item">
												<tr>
													<th>${item.itemName}</th>
													<td>${item.itemCode}</td>
													<td>
														<c:choose>
															<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) == "13"}'>
															${item.bomAmount}
															</c:when>
															<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
															&nbsp;
															</c:when>
															<c:otherwise>
															${item.bomAmount}
															</c:otherwise>
														</c:choose>
													</td>
													<td>
														<c:choose>
															<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) == "13"}'>
															${item.bomRate}
															</c:when>
															<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
															&nbsp;
															</c:when>
															<c:otherwise>
															${item.bomRate}
															</c:otherwise>
														</c:choose>
													</td>
													<td>
														<c:choose>
															<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) == "13"}'>
															${item.scrap}
															</c:when>
															<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
															&nbsp;
															</c:when>
															<c:otherwise>
															${item.scrap}
															</c:otherwise>
														</c:choose>													
													</td>	
													<c:set var= "mixBomRateSum" value="${mixBomRateSum + item.bomRate}"/>
													<c:set var= "mixBomAmountSum" value="${mixBomAmountSum + item.bomAmount}"/>
												</tr>
												</c:forEach>
												<c:if test="${mixItemLength<rigthItemLength}">
												<c:forEach var="i" begin="1" end="${rigthItemLength - mixItemLength}">
													<tr>
														<th></th>
														<td></td>
														<td></td>
														<td></td>
														<td></td>
													</tr>	
												</c:forEach>
												</c:if>	
												<tr>
													<th colspan="2">합계</th>
													<td>
														<c:choose>
															<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) == "13"}'>
															<fmt:formatNumber value="${mixBomAmountSum}" pattern="0.000"/>
															</c:when>
															<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
															0.000
															</c:when>
															<c:otherwise>
															<fmt:formatNumber value="${mixBomAmountSum}" pattern="0.000"/>
															</c:otherwise>
														</c:choose>
													</td>
													<td>
														<c:choose>
															<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) == "13"}'>
															<fmt:formatNumber value="${mixBomRateSum}" pattern="0.000"/>
															</c:when>
															<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
															0.000
															</c:when>
															<c:otherwise>
															<fmt:formatNumber value="${mixBomRateSum}" pattern="0.000"/>
															</c:otherwise>
														</c:choose>
													</td>
													<td>&nbsp;</td>									
												</tr>
												<c:if test="${status.index<2}">	
												<tr>
													<th colspan="2">기준수량</th>
													<td colspan="3">${sub.stdAmount}</td>
												</tr>					
												</c:if>
											</tbody>
										</table>								
									</td>
									<%-- <c:if test="${(mixLength-1 == status.index) && mixLength%2 == 1 }"> --%>
									<c:if test="${ rigthItemLength == 0 }">
									<td width="50%" style=" border-right:2px solid #000; vertical-align:top;">
										<!-- 배합비 타이틀 start-->
										<table width="100%"  class="intable04" >
											<tr>
												<td class="color06"> &nbsp;  </td>
											</tr>
										</table>
										<!-- 배합비 타이틀 close-->
										<table width="100%" class="intable02">
											<colgroup>
												<col width="52%">
												<col width="12%">
												<col width="12%">
												<col width="12%">
												<col width="12%">
											</colgroup>
											<thead>
												<tr>
													<th>원료명</th>
													<th>코드번호</th>
													<th>배합%</th>
													<th>BOM</th>
													<th>수량<br/>스크랩</th>
												</tr>
											</thead>
											<tbody>
											<c:forEach var="i" begin="1" end="${mixItemLength}">
												<tr>
													<th></th>
													<td></td>
													<td></td>
													<td></td>
													<td></td>
												</tr>	
											</c:forEach>												
												<tr>
													<th colspan="2">합계</th>
													<td>&nbsp;</td>
													<td>&nbsp;</td>
													<td>&nbsp;</td>									
												</tr>
												<c:if test="${status.index<2}">		
												<tr>
													<th colspan="2">분할중량</th>
													<td colspan="3">${sub.divWeight} g</td>
												</tr>					
												</c:if>
											</tbody>
										</table>								
									</td>	
									</c:if>
								</c:when>
								<c:otherwise>
									<td width="50%" style=" border-right:2px solid #000; vertical-align:top;">
										<!-- 배합비 타이틀 start-->
										<table width="100%"  class="intable04" >
											<tr>
												<td class="color06">  배합비명  : ${mix.baseName}  </td>
											</tr>
										</table>
										<!-- 배합비 타이틀 close-->
										<table width="100%" class="intable02">
											<colgroup>
												<col width="52%">
												<col width="12%">
												<col width="12%">
												<col width="12%">
												<col width="12%">
											</colgroup>
											<thead>
												<tr>
													<th>원료명</th>
													<th>코드번호</th>
													<th>배합%</th>
													<th>BOM</th>
													<th>수량<br/>스크랩</th>
												</tr>
											</thead>
											<tbody>
												<c:set var="mixItemLength2" value="${fn:length(mix.item)}" />
												<c:set var= "mixBomRateSum2" value="0"/>
												<c:set var= "mixBomAmountSum2" value="0"/>
												<c:forEach items="${mix.item}" var="item">
												<tr>
													<th>${item.itemName}</th>
													<td>${item.itemCode}</td>
													<td>
														<c:choose>
															<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) == "13"}'>
															${item.bomAmount}
															</c:when>
															<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
															&nbsp;
															</c:when>
															<c:otherwise>
															${item.bomAmount}
															</c:otherwise>
														</c:choose>
													</td>
													<td>
														<c:choose>
															<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) == "13"}'>
															${item.bomRate}
															</c:when>
															<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
															&nbsp;
															</c:when>
															<c:otherwise>
															${item.bomRate}
															</c:otherwise>
														</c:choose>
													</td>
													<td>
														<c:choose>
															<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) == "13"}'>
															${item.scrap}
															</c:when>
															<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
															&nbsp;
															</c:when>
															<c:otherwise>
															${item.scrap}
															</c:otherwise>
														</c:choose>
													</td>	
													<c:set var= "mixBomRateSum2" value="${mixBomRateSum2 + item.bomRate}"/>
													<c:set var= "mixBomAmountSum2" value="${mixBomAmountSum2 + item.bomAmount}"/>
												</tr>
												</c:forEach>
												<c:if test="${mixItemLength>mixItemLength2}">
												<c:forEach var="i" begin="1" end="${mixItemLength-mixItemLength2}">
													<tr>
														<th>&nbsp; </th>
														<td>&nbsp; </td>
														<td>&nbsp; </td>
														<td>&nbsp; </td>
														<td>&nbsp; </td>
													</tr>	
												</c:forEach>
												</c:if>		
												<tr>
													<th colspan="2">합계</th>
													<td>
														<c:choose>
															<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) == "13"}'>
															<fmt:formatNumber value="${mixBomAmountSum2}" pattern="0.000"/>
															</c:when>
															<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
															0.000
															</c:when>
															<c:otherwise>
															<fmt:formatNumber value="${mixBomAmountSum2}" pattern="0.000"/>
															</c:otherwise>
														</c:choose>
													</td>
													<td>
														<c:choose>
															<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) == "13"}'>
															<fmt:formatNumber value="${mixBomRateSum2}" pattern="0.000"/>
															</c:when>
															<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
															0.000
															</c:when>
															<c:otherwise>
															<fmt:formatNumber value="${mixBomRateSum2}" pattern="0.000"/>
															</c:otherwise>
														</c:choose>
													</td>
													<td>&nbsp;</td>									
												</tr>
												<c:if test="${status.index<2}">		
												<tr>
													<th colspan="2">분할중량</th>
													<td colspan="3">${sub.divWeight} g</td>
												</tr>				
												</c:if>
											</tbody>
										</table>								
									</td>
								</c:otherwise>
							</c:choose>
							<c:if test="${status.index == mixLength-1 or status.index%2 == 1 }">
							</tr>
							</c:if>
							</c:forEach>
						</table>
					</div>
					<div class="hold">
						<table width="100%"  class="intable lineside" >
						<c:set var="contLength" value="${fn:length(sub.cont)}" />
						<c:forEach items="${sub.cont}" var="cont" varStatus="status">
						<c:set var="rigthContLength" value="${fn:length(sub.cont[status.index+1].item)}" />					
						<c:if test="${status.index %2 == 0 }">
							<tr>
						</c:if>
						<c:choose>
							<c:when test="${status.index %2 == 0 }">
								<td width="50%" style=" border-right:2px solid #000; vertical-align:top;">
									<!-- 배합비 타이틀 start-->
									<table width="100%"  class="intable04" >
										<tr>
											<td class="color07">  내용물  : ${cont.baseName}  </td>
										</tr>
									</table>
									<!-- 배합비 타이틀 close-->
									<table width="100%" class="intable02">
										<colgroup>
											<col width="52%">
											<col width="12%">
											<col width="12%">
											<col width="12%">
											<col width="12%">
										</colgroup>
										<thead>
											<tr>
												<th>원료명</th>
												<th>코드번호</th>
												<th>배합%</th>
												<th>BOM</th>
												<th>수량<br/>스크랩</th>
											</tr>
										</thead>
										<tbody>
											<c:set var="contItemLength" value="${fn:length(cont.item)}" />
											<c:set var= "contBomRateSum" value="0"/>
											<c:set var= "contBomAmountSum" value="0"/>
											<c:forEach items="${cont.item}" var="item">
											<tr>
												<th>${item.itemName}</th>
												<td>${item.itemCode}</td>
												<td>
													<c:choose>
														<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) == "13"}'>
														${item.bomAmount}
														</c:when>
														<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
														&nbsp;
														</c:when>
														<c:otherwise>
														${item.bomAmount}
														</c:otherwise>
													</c:choose>
												</td>
												<td>
													<c:choose>
														<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) == "13"}'>
														${item.bomRate}
														</c:when>
														<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
														&nbsp;
														</c:when>
														<c:otherwise>
														${item.bomRate}
														</c:otherwise>
													</c:choose>
												</td>
												<td>
													<c:choose>
														<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) == "13"}'>
														${item.scrap}
														</c:when>
														<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
														&nbsp;
														</c:when>
														<c:otherwise>
														${item.scrap}
														</c:otherwise>
													</c:choose>
												</td>	
												<c:set var= "contBomRateSum" value="${contBomRateSum + item.bomRate}"/>
												<c:set var= "contBomAmountSum" value="${contBomAmountSum + item.bomAmount}"/>
											</tr>
											</c:forEach>
											<c:if test="${contItemLength<rigthContLength}">
											<c:forEach var="i" begin="1" end="${rigthItemLength - contItemLength}">
												<tr>
													<th>&nbsp; </th>
													<td>&nbsp; </td>
													<td>&nbsp; </td>
													<td>&nbsp; </td>
													<td>&nbsp; </td>
												</tr>	
											</c:forEach>
											</c:if>	
											<tr>
												<th colspan="2">합계</th>
												<td>
													<c:choose>
														<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) == "13"}'>
														<fmt:formatNumber value="${contBomAmountSum}" pattern="0.000"/>
														</c:when>
														<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
														0.000
														</c:when>
														<c:otherwise>
														<fmt:formatNumber value="${contBomAmountSum}" pattern="0.000"/>
														</c:otherwise>
													</c:choose>
												</td>
												<td>
													<c:choose>
														<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) == "13"}'>
														<fmt:formatNumber value="${contBomRateSum}" pattern="0.000"/>
														</c:when>
														<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
														0.000
														</c:when>
														<c:otherwise>
														<fmt:formatNumber value="${contBomRateSum}" pattern="0.000"/>
														</c:otherwise>
													</c:choose>
												</td>
												<td>&nbsp;</td>									
											</tr>
											<tr>
												<th colspan="2">${cont.baseName}중량(g)</th>										
												<td colspan="3">
													${cont.divWeight}
												</td>																			
											</tr>
										</tbody>
									</table>								
								</td>
								<%-- <c:if test="${(contLength-1 == status.index) && contLength%2 == 1 }"> --%>
								<c:if test="${ rigthContLength == 0 }">
								<td width="50%" style=" border-right:2px solid #000; vertical-align:top;">
									<!-- 배합비 타이틀 start-->
									<table width="100%"  class="intable04" >
										<tr>
											<td class="color07">  &nbsp;  </td>
										</tr>
									</table>
									<!-- 배합비 타이틀 close-->
									<table width="100%" class="intable02">
										<colgroup>
											<col width="52%">
											<col width="12%">
											<col width="12%">
											<col width="12%">
											<col width="12%">
										</colgroup>
										<thead>
											<tr>
												<th>원료명</th>
												<th>코드번호</th>
												<th>배합%</th>
												<th>BOM</th>
												<th>수량<br/>스크랩</th>
											</tr>
										</thead>
										<tbody>
										<c:forEach var="i" begin="1" end="${contItemLength}">
											<tr>
												<th>&nbsp; </th>
												<td>&nbsp; </td>
												<td>&nbsp; </td>
												<td>&nbsp; </td>
												<td>&nbsp; </td>
											</tr>
										</c:forEach>	
											<tr>
												<th colspan="2">합계</th>
												<td>&nbsp; </td>
												<td>&nbsp; </td>
												<td>&nbsp; </td>									
											</tr>
											<tr>
												<th colspan="2"></th>
												<td colspan="3">&nbsp; </td>
											</tr>
										</tbody>
									</table>								
								</td>
								</c:if>
							</c:when>
							<c:otherwise>
								<!-- 배합비 타이틀 start-->
								<td width="50%" style=" border-right:2px solid #000; vertical-align:top;">
									<table width="100%"  class="intable04" >
										<tr>
											<td class="color07">  내용물  : ${cont.baseName}  </td>
										</tr>
									</table>
									<!-- 배합비 타이틀 close-->
									<table width="100%" class="intable02">
										<colgroup>
											<col width="52%">
											<col width="12%">
											<col width="12%">
											<col width="12%">
											<col width="12%">
										</colgroup>
										<thead>
											<tr>
												<th>원료명</th>
												<th>코드번호</th>
												<th>배합%</th>
												<th>BOM</th>
												<th>수량<br/>스크랩</th>
											</tr>
										</thead>
										<tbody>
											<c:set var="contItemLength2" value="${fn:length(cont.item)}" />
											<c:set var= "contBomRateSum2" value="0"/>
											<c:set var= "contBomAmountSum2" value="0"/>
											<c:forEach items="${cont.item}" var="item">
											<tr>
												<th>${item.itemName}</th>
												<td>${item.itemCode}</td>
												<td>
													<c:choose>
														<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) == "13"}'>
														${item.bomAmount}
														</c:when>
														<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
														&nbsp;
														</c:when>
														<c:otherwise>
														${item.bomAmount}
														</c:otherwise>
													</c:choose>
												</td>
												<td>
													<c:choose>
														<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) == "13"}'>
														${item.bomRate}
														</c:when>
														<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
														&nbsp;
														</c:when>
														<c:otherwise>
														${item.bomRate}
														</c:otherwise>
													</c:choose>
												</td>
												<td>
													<c:choose>
														<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) == "13"}'>
														${item.scrap}
														</c:when>
														<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
														&nbsp;
														</c:when>
														<c:otherwise>
														${item.scrap}
														</c:otherwise>
													</c:choose>
												</td>	
												<c:set var= "contBomRateSum2" value="${contBomRateSum2 + item.bomRate}"/>
												<c:set var= "contBomAmountSum2" value="${contBomAmountSum2 + item.bomAmount}"/>
											</tr>
											</c:forEach>
											<c:if test="${contItemLength>contItemLength2}">
											<c:forEach var="i" begin="1" end="${contItemLength-contItemLength2}">
												<tr>
													<th>&nbsp; </th>
													<td>&nbsp; </td>
													<td>&nbsp; </td>
													<td>&nbsp; </td>
													<td>&nbsp; </td>
												</tr>	
											</c:forEach>
											</c:if>	
											<tr>
												<th colspan="2">합계</th>
												<td>
													<c:choose>
														<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) == "13"}'>
														<fmt:formatNumber value="${contBomAmountSum2}" pattern="0.000"/>
														</c:when>
														<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
														0.000
														</c:when>
														<c:otherwise>
														<fmt:formatNumber value="${contBomAmountSum2}" pattern="0.000"/>
														</c:otherwise>
													</c:choose>
												</td>
												<td>
													<c:choose>
														<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) == "13"}'>
														<fmt:formatNumber value="${contBomRateSum2}" pattern="0.000"/>
														</c:when>
														<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
														0.000
														</c:when>
														<c:otherwise>
														<fmt:formatNumber value="${contBomRateSum2}" pattern="0.000"/>
														</c:otherwise>
													</c:choose>
												</td>
												<td>&nbsp;</td>									
											</tr>
											<tr>
												<th colspan="2">${cont.baseName}중량(g)</th>										
												<td colspan="3">
													${cont.divWeight}
												</td>																			
											</tr>
										</tbody>
									</table>								
								</td>
							</c:otherwise>
						</c:choose>		
						<c:if test="${status.index == contLength-1 or status.index%2 == 1 }">
							</tr>
						</c:if>
						</c:forEach>
						</table>
					</div>
				</c:forEach>
				</c:if>	
				</div>
			<!-- 부속제품  close-->
			<!-- 유출금지 정보출력 start-->
				<table width="100%"  class="intable lineside" style="display:none" id="water_mark_table">
					<tr>
						<td id="water_mark_td">!- 유출금지 정보출력 -!</td>
					</tr>
				</table>
			<!-- 유출금지 정보출력 close-->
			<!-- 표시사항배합비,제조방법,제품사진,제조방법 start-->
				<div class="hold">
					<div class="watermark"><img src="/resources/images/watermark.png"></div>
						<table class="intable lineside" width="100%">
							<colgroup>
								<col width="50%">
								<col width="50%">
							</colgroup>
							<tr >
								<td class="color05" style="border-right:2px solid #000"> 재료 </td>
								<td class="color05"> 표시사항 배합비  </td>
							</tr>
							<tr>
								<td valign="top" style="border-right:2px solid #000">
									<table width="100%" class="intable02">
										<colgroup>
											<col width="69%">
											<col width="16%">
											<col width="16%">
										</colgroup>							
										<thead>
											<tr>
												<th>재료명</th>
												<th>코드번호</th>
												<th>재료사양</th>
											</tr>
										</thead>
										<tbody>
										<c:forEach items="${mfgProcessDoc.pkg}" var="pkg">
											<tr>
												<th>${pkg.itemName}</th>
												<td>${pkg.itemCode}</td>
												<td>${pkg.bomRate}(${pkg.unit})</td>
											</tr>
											<c:set var= "bomRateSum" value="${bomRateSum + pkg.bomRate}"/>
										</c:forEach>
											<tr>
												<th>합계</th>
												<td>&nbsp;</td>
												<td><fmt:formatNumber value="${bomRateSum}" pattern="0.000"/></td>
											</tr>	
										</tbody>
									</table>
								</td>
								<td valign="top" style="border-right:2px solid #000">
									<table width="100%" class="intable02">
										<colgroup>
											<col width="69%">
											<col width="16%">
											<col width="16%">
										</colgroup>							
										<thead>
											<tr>
												<th>원료명</th>
												<th>백분율</th>
												<th>급수포함</th>
											</tr>
										</thead>
										<tbody>
										<c:forEach items="${mfgProcessDoc.disp}" var="disp">
											<tr>
												<th>${disp.matName}</th>
												<td>${disp.excRate}</td>
												<td>${disp.incRate}</td>
											</tr>
											<c:set var= "excRateSum" value="${excRateSum + disp.excRate}"/>
											<c:set var= "incRateSum" value="${incRateSum + disp.incRate}"/>
										</c:forEach>
											<tr>
												<th>합계</th>
												<td><fmt:formatNumber value="${excRateSum}" pattern=".00"/></td>
												<td><fmt:formatNumber value="${incRateSum}" pattern=".00"/></td>
											</tr>	
										</tbody>
									</table>
								</td>						
							</tr>
						</table>
						<table class="intable lineside" width="100%">
							<colgroup>
								<col width="32%">
								<col width="38%">
								<col width="30%">
							</colgroup>
							<tr >
								<td class="color05" style="border-right:2px solid #000"> 제조방법 </td>
								<td class="color05" style="border-right:2px solid #000"> 제조규격 </td>
								<td class="color05"> 제품사진 </td>
							</tr>
							<tr>
								<td valign="top" style="border-right:2px solid #000; text-align:left; padding:10px;"">
									${strUtil:getHtmlBr(mfgProcessDoc.menuProcess)}
								</td>
								<td valign="top" style="border-right:2px solid #000; text-align:left; padding:10px;">
									${strUtil:getHtmlBr(mfgProcessDoc.standard)}
								</td>
								<td valign="top">
									<c:choose>
										<c:when test="${productDevDoc.imageFileName != null and productDevDoc.imageFileName != ''}">
											<c:if test="${productDevDoc.isOldImage == 'Y'}">
												<img src="/oldFile/devDoc/${strUtil:getDevdocFileName(productDevDoc.oldFileName)}" style="width:100%; height:auto; max-height:200px;">
											</c:if>
											<c:if test="${productDevDoc.isOldImage != 'Y'}">
												<img src="/devDocImage/${strUtil:getDevdocFileName(productDevDoc.imageFileName)}" style="width:100%; height:auto; max-height:200px;">
											</c:if>
										</c:when>
										<c:otherwise>
											<img src="/resources/images/img_noimg.png" style="width:100%; height:auto; max-height:200px;">
										</c:otherwise>
									</c:choose>
								</td>
							</tr>
						</table>
					</div>
					<!-- 표시사항배합비,제조방법,제품사진,제조방법 close-->
					<!-- 비고 start-->
					<div class="hold">
						<table class="intable04 linebottom" width="100%">
							<colgroup>
								<col width="16%">
								<col width="17%">
								<col width="16%">
								<col width="17%">
								<col width="16%">
								<col width="18%">
							</colgroup>
							<tr>
								<td colspan="6" class="color05"> 비고 </td>
							</tr>
							<tr>
								<th>생산라인</th>
								<td>${mfgProcessDoc.lineName}</td>
								<th>배합중량</th>
								<td>${mfgProcessDoc.mixWeight} Kg (${mfgProcessDoc.bagAmout} 포)</td>
								<th>BOM 수율</th>
								<td>${mfgProcessDoc.bomRate} %</td>
							</tr>
							<tr>
								<th>봉당 들이수</th>
								<td>${mfgProcessDoc.numBong} /ea</td>
								<th>상자 들이수</th>
								<td>${mfgProcessDoc.numBox}</td>
								<th>제조공정도 유형</th>
								<td>${mfgProcessDoc.lineProcessType}</td>
							</tr>
							<tr>
								<th>분할중량총합계(g)</th>
								<td>${mfgProcessDoc.totWeight} g</td>
								<th>소성손실(g/%)</th>
								<td>${mfgProcessDoc.loss} %</td>
								<th>&nbsp;</th>
								<td>&nbsp;</td>
							</tr>
							<tr>
								<th>완제중량</th>
								<td>${mfgProcessDoc.compWeight} ${mfgProcessDoc.compWeightUnit}</td>
								<th>관리중량</th>
								<td>${mfgProcessDoc.adminWeightFrom} ${mfgProcessDoc.adminWeightUnitFrom}
									 ~ ${mfgProcessDoc.adminWeightTo} ${mfgProcessDoc.adminWeightUnitTo}</td>
								<th>표기중량</th>
								<td>${mfgProcessDoc.dispWeight} ${mfgProcessDoc.dispWeightUnit}</td>
							</tr>
							<tr>
								<th>성상</th>
								<td>${mfgProcessDoc.ingredient}</td>
								<th>용도용법</th>
								<td>${mfgProcessDoc.usage}</td>
								<th>품목제조보고서명</th>
								<td>${mfgProcessDoc.docProdName}</td>
							</tr>
							<tr>
								<th>식품유형</th>
								<td colspan="3">
									${productDevDoc.productType1Text}
									<c:if test="${productDevDoc.productType2Text != '' && productDevDoc.productType2Text != null }">
										&gt; ${productDevDoc.productType2Text}
									</c:if>	
									<c:if test="${productDevDoc.productType3Text != '' && productDevDoc.productType3Text != null }">
										&gt; ${productDevDoc.productType3Text}
									</c:if>
									<c:if test="${(productDevDoc.sterilizationText != '' && productDevDoc.sterilizationText != null) && (productDevDoc.etcDisplayText != '' && productDevDoc.etcDisplayText != null)}">
										&lpar;
										${(productDevDoc.sterilizationText != '' && productDevDoc.sterilizationText != null)? productDevDoc.sterilizationText : '-'} 
										&sol;
										${(productDevDoc.etcDisplayText != '' && productDevDoc.etcDisplayText != null)? productDevDoc.etcDisplayText : '-'} 
										&rpar;
									</c:if>
								</td>
								<th>품목보고번호</th>
								<td>${mfgProcessDoc.regNum}</td>
							</tr>
							<tr>
								<th>소비기한 - 등록서류</th>
								<td>${mfgProcessDoc.distPeriDoc}</td>
								<th>소비기한 - 현장</th>
								<td>${mfgProcessDoc.distPeriSite}</td>
								<th>보관조건</th>
								<td>${mfgProcessDoc.keepCondition}</td>
							</tr>
							<tr>
								<th>포장재질</th>
								<td>${mfgProcessDoc.packMaterial}</td>
								<th>품목제조보고서 포장단위</th>
								<td>${mfgProcessDoc.packUnit}</td>
								<th>어린이 기호식품 <br/>고열량 저영양 해당유무</th>
								<td>
									[<c:if test="${mfgProcessDoc.childHarm == '1'}">●</c:if>]예   [<c:if test="${mfgProcessDoc.childHarm == '2'}">●</c:if>]아니오   [<c:if test="${mfgProcessDoc.childHarm == '3'}">●</c:if>]해당 없음 
								</td>
							</tr>
							<tr>
								<th>비고</th>
								<td colspan="5">${mfgProcessDoc.note}</td>
							</tr>
						</table>
					</div>
					<!--비고 close-->
					<!-- 출력버튼 -->
					<table width="1046" cellpadding="0" cellspacing="0" class="print_hidden">
						<tr>
							<td align="right" height="50" valign="bottom">
								<button type="button" class="btn_admin_green" onClick="excelDownloadCheck();"><img src="/resources/images/icon_excel.png" style="vertical-align:middle"> 엑셀 다운로드</button>
								<button type="button" class="btn_admin_nomal" onClick="printCheck();">프린트</button>
								<button type="button" class="btn_admin_gray" onClick="self.close();">취소</button>
							</td>
						</tr>
					</table>
					<!-- 여기까지 프린트 -->
				</div>
			</c:when>
			<c:when test="${paramVO.tbType eq 'designRequestDoc' }">
			<div class="print_box">
				<!-- 상단 머리정보 start-->
				<div class="hold">
					<table width="100%"  class="intable lineall mb5" >
						<colgroup>
							<col width="20%">
							<col width="30%">
							<col width="20%">
							<col width="30%">
						</colgroup>
						<tr>
							<th class="color05">부서명</th>
							<td>${designReqDoc.department}</td>
							<th class="color05">제목</th>
							<td>${designReqDoc.title}</td>
						</tr>
						<tr>
							<th class="color05">담당자</th>
							<td>${designReqDoc.regUserId}</td>
							<th class="color05">의뢰일자</th>
							<td>${designReqDoc.regDate}</td>
						</tr>
					</table>
				</div>
				<div>
					<div class="watermark"><img src="/resources/images/watermark.png"></div>
					<table width="100%" class="intable lineall">
						<tr>
							<td>
								<div class="img-box">
									<img id="sodium" src="/resources/images/disp/sodium${designReqDoc.nutritionLabel.natriumLevel}.png" alt="graph" />
								</div>
								<div class="img-sodium">${designReqDoc.nutritionLabel.contNatrium}mg</div>
								<div class="img-text">나트륨 함량 비교 표시</div>
								<div class="img-category" >
									<span id="natriumTypeText">${designReqDoc.nutritionLabel.natriumTypeText}</span>
								</div>
							</td>
						</tr>
					</table>
					<!-- 유출금지 정보출력 start-->
					<table width="100%"  class="intable lineside" style="display:none" id="water_mark_table">
						<tr>
							<td id="water_mark_td">!- 유출금지 정보출력 -!</td>
						</tr>
					</table>
					<!-- 유출금지 정보출력 close-->
				</div>	
				<div class="mt10">
					<table width="100%" class="intable linetop">
						<tr>
							<td id="designReqDoc_content">
								${designReqDoc.content}
							</td>
						</tr>	
					</table>
				</div>	
			</div>	
			</c:when>
			<c:when test="${paramVO.tbType eq 'manufacturingNoStopProcess' }">
				<div class="print_box" style="table-layout:fixed;">
					<!-- 상단 머리정보 start-->

					<!-- 상단 머리정보 close-->
					<!-- 품보내역 start-->
					<div class="list_detail">
						<ul>
							<li class="pt10">
								<dt>공장</dt>
								<dd id="dd_company">
										${manufacturingNoData.companyName} - ${manufacturingNoData.plantName}
								</dd>
							</li>
							<li>
								<dt>인허가번호</dt>
								<dd id="dd_licensingNo">
										${manufacturingNoData.licensingNo}
								</dd>
							</li>
							<li>
								<dt>품목번호</dt>
								<dd id="dd_manufacturingNo">
										${manufacturingNoData.manufacturingNo}
								</dd>
							</li>
							<li>
								<dt>품목명</dt>
								<dd id="dd_manufacturingName">
										${manufacturingNoData.manufacturingName}
								</dd>
							</li>
							<li>
								<dt>식품유형</dt>
								<dd id="dd_productType">
										${manufacturingNoData.productType1Name} / ${manufacturingNoData.productType2Name} / ${manufacturingNoData.productType3Name}
								</dd>
							</li>
							<li>
								<dt>살균여부</dt>
								<dd id="dd_sterilization">
										${manufacturingNoData.sterilizationName}
								</dd>
							</li>
							<li>
								<dt>보관조건</dt>
								<dd id="dd_keepCondition">
										${manufacturingNoData.keepConditionName}
								</dd>
							</li>
							<li>
								<dt>소비기한</dt>
								<dd id="dd_sellDate">
										${manufacturingNoData.sellDate1Text} ${manufacturingNoData.sellDate2} ${manufacturingNoData.sellDate3Text}
									<c:if test="${manufacturingNoData.sellDate4Text != null && manufacturingNoData.sellDate4Text != ''}">
										<br/>${manufacturingNoData.sellDate4Text} ${manufacturingNoData.sellDate5} ${manufacturingNoData.sellDate6Text}
									</c:if>
								</dd>
							</li>
							<li>
								<dt>위탁/OEM</dt>
								<dd id="dd_oem">
									<c:if test="${manufacturingNoData.referral == 'Y' && manufacturingNoData.oem == 'Y'}">
										위탁/OEM
									</c:if>
									<c:if test="${manufacturingNoData.referral == 'Y' && manufacturingNoData.oem != 'Y'}">
										위탁
									</c:if>
									<c:if test="${manufacturingNoData.referral != 'Y' && manufacturingNoData.oem == 'Y'}">
										OEM
									</c:if>
								</dd>
							</li>
							<c:if test="${manufacturingNoData.plantName != '' || manufacturingNoData.plantName != null}">
								<li id="li_create_plant">
									<dt>생산 공장</dt>
									<dd id="create_plant_list">
											${manufacturingNoData.plantName}
									</dd>
								</li>
							</c:if>
							<c:if test="${manufacturingNoData.oemText != '' && manufacturingNoData.oem == 'Y'}">
								<li id="li_oemText">
									<dt>OEM 내용</dt>
									<dd id="dd_oemText">
											${manufacturingNoData.oemText}
									</dd>
								</li>
							</c:if>
							<c:if test="${manufacturingNoData.manufacturingReport != null}">
								<li id="li_manufacturingReportFile" >
									<dt>품복제조보고서</dt>
									<dd id="dd_manufacturingReportFile">
										<a href="#" onClick="fileDownload('${manufacturingNoData.manufacturingReport}', '${manufacturingNoData.dNoSeq}', 'manufacturingReport')"><img src="/resources/images/icon_file01.png" style="vertical-align:middle;"/>&nbsp;${manufacturingNoData.manufacturingReportFileName}</a>
									</dd>
								</li>
							</c:if>
							<c:if test="${manufacturingNoData.sellDateReport != null}">
								<li id="li_sellDateReportFile" >
									<dt>소비기한설정<br/>사유서</dt>
									<dd id="dd_sellDateReportFile">
										<a href="#" onClick="fileDownload('${manufacturingNoData.sellDateReport}', '${manufacturingNoData.dNoSeq}', 'sellDateReport')"><img src="/resources/images/icon_file01.png" style="vertical-align:middle;"/>&nbsp;${manufacturingNoData.sellDateReportFileName}</a>
									</dd>
								</li>
							</c:if>
							<li>
								<dt>비고</dt>
								<dd id="dd_comment">
										${manufacturingNoData.comment}
								</dd>
							</li>
						</ul>
					</div>
					<!-- 품보내역 close-->
					<!-- 출력버튼 -->
					<table width="1046" cellpadding="0" cellspacing="0" class="print_hidden">
						<tr>
							<td align="right" height="50" valign="bottom">
								<c:if test='${userUtil:getUserGrade(pageContext.request) == "2" || userUtil:getUserGrade(pageContext.request) == "3" || userUtil:getUserGrade(pageContext.request) == "4" || userUtil:getUserGrade(pageContext.request) == "5"}'>
									<button type="button" class="btn_admin_green" onClick="excelDownloadCheck();"><img src="/resources/images/icon_excel.png" style="vertical-align:middle"> 엑셀 다운로드</button>
								</c:if>
								<button type="button" class="btn_admin_nomal" onClick="printCheck();">프린트</button>
								<button type="button" class="btn_admin_gray" onClick="self.close();">취소</button>
							</td>
						</tr>
					</table>
					<!-- 여기까지 프린트 -->
				</div>
			</c:when>
			<c:otherwise>
			</c:otherwise>
			</c:choose>
		</c:if>	
		</c:if>
</div>
