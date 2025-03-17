<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="userUtil" uri="/WEB-INF/tld/userUtil.tld"%>
<%@ taglib prefix="dateUtil" uri="/WEB-INF/tld/dateUtil.tld"%>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
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
function approvalSubmit() {
	/*if( !chkNull($("#note").val()) ) {
		alert("결재 의견을 입력해주세요.");
		$("#note").focus();
		return;
	} else*/ {
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


$("#goPrintRequest").off("click").on('click', function() {
	goPrintRequest()
});

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
					"title" : "${designDocDetail.memo} 다운로드/프린트 결재 요청"
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
	$("#confi").show();
	document.body.innerHTML = $("#print_page").html();
	
}

function afterPrint(){ //인쇄가 끝난 후 실행되는 내용
	$("#water_mark_td").append("");
	$("#water_mark_table").hide(); 
	$("#confi").hide();
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

/*
if (window.matchMedia) {	//크롬 브라우저에도 적용되도록 추가
    var mediaQueryList = window.matchMedia('print');
    mediaQueryList.addListener(function(mql) {
        if (mql.matches) {
            beforePrint();
        } else {
            afterPrint();
        }
    });
}
*/

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
<c:when test='${userUtil:getUserId(pageContext.request) eq designDocDetail.regUserId || userUtil:getUserGrade(pageContext.request) == "3" || userUtil:getIsAdmin(pageContext.request) == "Y"}'>
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
			 	if(data.pCount == 0){
					window.onbeforeprint = beforePrint;
					window.onafterprint = afterPrint;
					window.print();
					insertPrintLog(data.apprNo,"P");
				 } else{
					 if(confirm("프린트/다운로드 결재를 받으셔야 합니다.\n결재를 요청하시겠습니까?")) {
						$("#requestReason").val("");	
						openDialog('open');
					 }
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
				 if(data.pCount == 0){
						window.onbeforeprint = beforePrint;
						window.onafterprint = afterPrint;
						window.print();
						insertPrintLog(data.apprNo,"P");
					 } else{
						 if(confirm("프린트/다운로드 결재를 받으셔야 합니다.\n결재를 요청하시겠습니까?")) {
							$("#requestReason").val("");	
							openDialog('open');
						 }
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
			console.log(contentDis);
	        var fileName = decodeURIComponent(contentDis.replace(/";/g,'').substr(contentDis.indexOf('filename=')+('filename=').length));
	        console.log(fileName);
			var blob = new Blob([data]);
			console.log(data);
			console.log(data);
			//파일저장
			if (navigator.msSaveBlob) {
				return navigator.msSaveBlob(blob, fileName);
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
	<span class="title"><img src="/resources/images/bg_bs_box_fast02.png">&nbsp;&nbsp;제품설계서 결재</span>
</h2>
<div  class="top_btn_box" style=" position:fixed;">
	<ul>
		<li><button type="button" class="btn_pop_close" onClick="self.close();"></button></li>
	</ul>
</div>
<!--여기서부터 프린트 -->
<div id='print_page'  style="padding:10px 0 20px 20px;">
	<table width="1046" cellpadding="0" cellspacing="0" class="print_hidden">
		<tr>
			<td height="50"></td>
		</tr>
		<tr>
			<td align="right" height="50" valign="top">
			<c:if test='${userUtil:getUserGrade(pageContext.request) == "2" || userUtil:getUserGrade(pageContext.request) == "3" || userUtil:getUserGrade(pageContext.request) == "4" || userUtil:getUserGrade(pageContext.request) == "5"}'>
				<button type="button" class="btn_admin_green" onClick="excelDownloadCheck();"><img src="/resources/images/icon_excel.png" style="vertical-align:middle"> 엑셀 다운로드</button>
			</c:if>	
				<button type="button" class="btn_admin_nomal" onClick="printCheck();">프린트</button>
				<button type="button" class="btn_admin_gray" onClick="self.close();">취소</button>
			</td>
		</tr>
	</table>
	<!-- 출력버튼 -->
	<!-- 결재 start --------------------------------------------------------------------------------------------------------------------------------------------------------->
	<form name="form" id="form" method="post" action="">
	<input type="hidden" name="tbKey" id="tbKey" value="${apprItemHeader.tbKey }">
	<input type="hidden" name="tbType" id="tbType" value="${apprItemHeader.tbType }">
	<input type="hidden" name="type" id="type" value="${apprItemHeader.type }">
	<input type="hidden" name="currentUserid" id="currentUserid" value="${apprItemHeader.currentUserId }">
	<input type="hidden" name="currentStep" id="currentStep" value="${apprItemHeader.currentStep }">
	<input type="hidden" name="apprNo" id="apprNo" value="${apprItemHeader.apprNo }">
	<input type="hidden" name="title" id="title" value="${apprItemHeader.title }">
	<input type="hidden" name="regUserId" id="regUserId" value="${designDocDetail.regUserId }">
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
						<button class="btn_con_search" style="border-color:#09F; color:#09F"  onclick="approvalSubmit(); return false;" id="btn_submit"><img src="/resources/images/icon_s_approval.png"> 승인</button>
						<button class="btn_con_search" onclick="approvalReject(); return false;" id="btn_reject"><img src="/resources/images/icon_doc06.png"> 반려</button>					
					</c:if>	
				</c:if>
				</c:if>
				</div>
			</td>
		</tr>
	</table>
	</form>
	<!-- 결재 close --------------------------------------------------------------------------------------------------------------------------------------------------------->			
	<!-- 실제 출력대상 start ------------------------------------------------------------------------------------------------------------------------------------------------>
	<div class="print_box" style="table-layout:fixed;">
		<!-- 상단 머리정보 start-->
		<div class="hold">
			<script>console.log('${designDocInfo}')</script>
			<table width="100%"  class="intable lineall mb5" >
				<colgroup>
					<col width="50%">
					<col width="30%">
					<col width="10%">
					<col width="10%">
				</colgroup>
				<tr>
					<td class="color05">제품설계서</td>
					<td rowspan="3"></td>
					<td class="color05">문서번호</td>
					<td>${designDocInfo.pNo}</td>
				</tr>
				<tr>
					<td rowspan="2"><span class="big_font">${designDocInfo.productName}/${designDocInfo.plantName}(${designDocInfo.plant})</span></td>
					<td class="color05">제개정일</td>
					<c:choose>
						<c:when test="${productDevDoc.modDate != null && fn:length(productDevDoc.modDate) > 0 }">
							<td>${dateUtil:convertDate(designDocInfo.modDate,"yyyy-MM-dd HH:mm:ss","yyyy-MM-dd")}</td>
						</c:when>
						<c:otherwise>
							<td>${dateUtil:convertDate(designDocInfo.regDate,"yyyy-MM-dd HH:mm:ss","yyyy-MM-dd")}</td>
						</c:otherwise>
					</c:choose>
				</tr>
				<tr>
					<td class="color05">&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
			</table>
		</div>
		<!-- 상단 머리정보 close-->
		<!-- 부속정보 start-->
		<div>
			<div class="watermark"><img src="/resources/images/watermark.png"></div>
			<c:if test="${userUtil:getDeptCode(pageContext.request) != 'dept8' }">
			<c:forEach items="${designDocDetail.sub}" var="sub" varStatus="subStatus">					
			<table width="100%" class="intable linetop">
				<tr>
					<td class="color05">  부속제품명  : ${sub.subProdName}  </td>
				</tr>
			</table>
			<!-- 배합비 2개씩 반복 --->
			<div class="hold">
				<table width="100%"  class="intable lineside" >
					<c:set var="mixLength" value="${fn:length(sub.subMix)}" />
					<c:forEach items="${sub.subMix}" var="mix" varStatus="status">
					<c:set var="rigthItemLength" value="${fn:length(sub.subMix[status.index+1].subMixItem)}" />					
					<c:if test="${status.index %2 == 0 }">
					<tr>
					</c:if>
					<c:choose>
						<c:when test="${status.index %2 == 0 }">
							<td width="50%" style=" border-right:2px solid #000; vertical-align:top;">
								<!-- 배합비 타이틀 start-->
								<table width="100%"  class="intable04" >
									<tr>
										<td class="color06">  배합비명  : ${mix.name}  </td>
									</tr>
								</table>
								<!-- 배합비 타이틀 close-->
								<table width="100%" class="intable02">
									<colgroup>
										<col width="40%">
										<col width="12%">
										<col width="12%">
										<col width="12%">
										<col width="12%">
										<col width="12%">
									</colgroup>
									<thead>
										<tr>
											<th>원료명</th>
											<th>코드번호</th>
											<th>배합율</th>
											<th>단가[단위]</th>
											<th>가격</th>
											<th>비급수<br>비율(%)</th>
										</tr>
									</thead>
									<tbody>
										<c:set var="mixItemLength" value="${fn:length(mix.subMixItem)}" />
										<c:set var="mixMixingRatioTotal" value="0"/>
										<c:set var="mixWaterRatioTotal" value="0"/>
										<c:set var="mixProportionTotal" value="0"/>
										<c:forEach items="${mix.subMixItem}" var="item">
											<c:set var="mixMixingRatioTotal" value="${mixMixingRatioTotal + item.mixingRatio}"/>
											<c:if test="${item.itemSapCode == 'P10001'}">
												<c:set var="mixWaterRatioTotal" value="${mixWaterRatioTotal + item.mixingRatio}"/>
											</c:if>
										</c:forEach>
										<c:forEach items="${mix.subMixItem}" var="item">
										<c:set var="mixPriceTotal" value="${mixPriceTotal + (item.itemUnitPrice*item.mixingRatio)}"/>
										<tr>
											<th>${item.itemName}</th>
											<td>${item.itemSapCode}</td>
											<td>
												<c:choose>
													<c:when test='${userUtil:getDeptCode(pageContext.request) != "dept99"}'>
													${item.mixingRatio}
													</c:when>
													<c:otherwise>
													&nbsp;
													</c:otherwise>
												</c:choose>												
											</td>
											<td>
												<c:choose>
													<c:when test='${userUtil:getDeptCode(pageContext.request) != "dept99"}'>
													${item.itemUnitPrice}<c:if test="${item.itemUnit != null && fn:length(item.itemUnit)>0}">[${item.itemUnit}]</c:if>
													</c:when>
													<c:otherwise>
													&nbsp;
													</c:otherwise>
												</c:choose>												
											</td>
											<td>
												<c:choose>
													<c:when test='${userUtil:getDeptCode(pageContext.request) != "dept99"}'>
													<fmt:formatNumber value="${item.itemUnitPrice*item.mixingRatio}" pattern="#.####"/>
													</c:when>
													<c:otherwise>
													&nbsp;
													</c:otherwise>
												</c:choose>												
											</td>
											<td>
												<c:choose>
													<c:when test='${userUtil:getDeptCode(pageContext.request) != "dept99"}'>
														<c:choose>
															<c:when test="${item.itemSapCode == 'P10001'}">0</c:when>
															<c:otherwise>
																<fmt:formatNumber value="${(item.mixingRatio/(mixMixingRatioTotal-mixWaterRatioTotal))*100}" type="number" pattern="#.###"/>
																<c:set var="mixProportionTotal" value="${mixProportionTotal + (item.mixingRatio/(mixMixingRatioTotal-mixWaterRatioTotal)*100)}"/>
															</c:otherwise>
														</c:choose>
													</c:when>
													<c:otherwise>
													&nbsp;
													</c:otherwise>
												</c:choose>												
											</td>
											<c:set var= "mixBomRateSum" value="${mixBomRateSum + item.mixingRatio}"/>
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
													<c:when test='${userUtil:getDeptCode(pageContext.request) != "dept99"}'>
													<fmt:formatNumber value="${mixMixingRatioTotal}" pattern=".000"/>
													</c:when>
													<c:otherwise>
													&nbsp;
													</c:otherwise>
												</c:choose>												
											</td>
											<Td>&nbsp;</Td>
											<td>
												<c:choose>
													<c:when test='${userUtil:getDeptCode(pageContext.request) != "dept99"}'>
													<fmt:formatNumber value="${mixPriceTotal}" pattern=".000"/>
													</c:when>
													<c:otherwise>
													&nbsp;
													</c:otherwise>
												</c:choose>												
											</td>
											<td>
												<c:choose>
													<c:when test='${userUtil:getDeptCode(pageContext.request) != "dept99"}'>
													<fmt:formatNumber value="${mixProportionTotal}" pattern="0"/>
													</c:when>
													<c:otherwise>
													&nbsp;
													</c:otherwise>
												</c:choose>												
											</td>
										</tr>
									</tbody>
								</table>
							</td>
							<c:if test="${ rigthItemLength == 0}">
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
										<col width="40%">
										<col width="12%">
										<col width="12%">
										<col width="12%">
										<col width="12%">
										<col width="12%">
									</colgroup>
									<thead>
										<tr>
											<th>원료명</th>
											<th>코드번호</th>
											<th>배합율</th>
											<th>단가[단위]</th>
											<th>가격</th>
											<th>비급수<br>비율(%)</th>
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
											<td></td>
										</tr>	
									</c:forEach>										
										<tr>
											<th colspan="2">합계</th>
											<td>&nbsp;</td>
											<td>&nbsp;</td>
											<td>&nbsp;</td>
											<td>&nbsp;</td>									
										</tr>
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
										<td class="color06">  배합비명  : ${mix.name}  </td>
									</tr>
								</table>
								<!-- 배합비 타이틀 close-->
								<table width="100%" class="intable02">
									<colgroup>
										<col width="40%">
										<col width="12%">
										<col width="12%">
										<col width="12%">
										<col width="12%">
										<col width="12%">
									</colgroup>
									<thead>
										<tr>
											<th>원료명</th>
											<th>코드번호</th>
											<th>배합율</th>
											<th>단가[단위]</th>
											<th>가격</th>
											<th>비급수 비율</th>
										</tr>
									</thead>
									<tbody>
										<c:set var="mixItemLength" value="${fn:length(mix.subMixItem)}" />
										<c:set var="mixMixingRatioTotal" value="0"/>
										<c:set var="mixWaterRatioTotal" value="0"/>
										<c:set var="mixProportionTotal" value="0"/>
										<c:forEach items="${mix.subMixItem}" var="item">
											<c:set var="mixMixingRatioTotal" value="${mixMixingRatioTotal + item.mixingRatio}"/>
											<c:if test="${item.itemSapCode == 'P10001'}">
												<c:set var="mixWaterRatioTotal" value="${mixWaterRatioTotal + item.mixingRatio}"/>
											</c:if>
										</c:forEach>
										<c:forEach items="${mix.subMixItem}" var="item">
										<c:set var="mixPriceTotal" value="${mixPriceTotal + (item.itemUnitPrice*item.mixingRatio)}"/>
										<tr>
											<th>${item.itemName}</th>
											<td>${item.itemSapCode}</td>
											<td>
												<c:choose>
													<c:when test='${userUtil:getDeptCode(pageContext.request) != "dept99"}'>
													${item.mixingRatio}
													</c:when>
													<c:otherwise>
													&nbsp;
													</c:otherwise>
												</c:choose>												
											</td>
											<td>
												<c:choose>
													<c:when test='${userUtil:getDeptCode(pageContext.request) != "dept99"}'>
													${item.itemUnitPrice}<c:if test="${item.itemUnit != null && fn:length(item.itemUnit)>0}">[${item.itemUnit}]</c:if>
													</c:when>
													<c:otherwise>
													&nbsp;
													</c:otherwise>
												</c:choose>												
											</td>
											<td>
												<c:choose>
													<c:when test='${userUtil:getDeptCode(pageContext.request) != "dept99"}'>
													<fmt:formatNumber value="${item.itemUnitPrice*item.mixingRatio}" pattern="#.####"/>
													</c:when>
													<c:otherwise>
													&nbsp;
													</c:otherwise>
												</c:choose>												
											</td>
											<td>
												<c:choose>
													<c:when test='${userUtil:getDeptCode(pageContext.request) != "dept99"}'>
														<c:choose>
															<c:when test="${item.itemSapCode == 'P10001'}">0</c:when>
															<c:otherwise>
																<fmt:formatNumber value="${(item.mixingRatio/(mixMixingRatioTotal-mixWaterRatioTotal))*100}" type="number" pattern="#.###"/>
																<c:set var="mixProportionTotal" value="${mixProportionTotal + (item.mixingRatio/(mixMixingRatioTotal-mixWaterRatioTotal)*100)}"/>
															</c:otherwise>
														</c:choose>
													</c:when>
													<c:otherwise>
													&nbsp;
													</c:otherwise>
												</c:choose>												
											</td>
											<c:set var= "mixBomRateSum" value="${mixBomRateSum + item.mixingRatio}"/>
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
													<c:when test='${userUtil:getDeptCode(pageContext.request) != "dept99"}'>
													<fmt:formatNumber value="${mixMixingRatioTotal}" pattern=".000"/>
													</c:when>
													<c:otherwise>
													&nbsp;
													</c:otherwise>
												</c:choose>												
											</td>
											<Td>&nbsp;</Td>
											<td>
												<c:choose>
													<c:when test='${userUtil:getDeptCode(pageContext.request) != "dept99"}'>
													<fmt:formatNumber value="${mixPriceTotal}" pattern=".000"/>
													</c:when>
													<c:otherwise>
													&nbsp;
													</c:otherwise>
												</c:choose>												
											</td>
											<td>
												<c:choose>
													<c:when test='${userUtil:getDeptCode(pageContext.request) != "dept99"}'>
													<fmt:formatNumber value="${mixProportionTotal}" pattern="0"/>
													</c:when>
													<c:otherwise>
													&nbsp;
													</c:otherwise>
												</c:choose>												
											</td>
										</tr>
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
				<c:set var="contLength" value="${fn:length(sub.subContent)}" />
				<c:forEach items="${sub.subContent}" var="cont" varStatus="status">
				<c:set var="rigthContLength" value="${fn:length(sub.subContent[status.index+1].subContentItem)}" />				
				
				<c:if test="${status.index %2 == 0 }">
					<tr>
				</c:if>
				<c:choose>
					<c:when test="${status.index %2 == 0 }">
						<td width="50%" style=" border-right:2px solid #000; vertical-align:top;">
							<!-- 배합비 타이틀 start-->
							<table width="100%"  class="intable04" >
								<tr>
									<td class="color07">  내용물  : ${cont.name}  </td>
								</tr>
							</table>
							<!-- 배합비 타이틀 close-->
							<table width="100%" class="intable02">
								<colgroup>
									<col width="40%">
									<col width="12%">
									<col width="12%">
									<col width="12%">
									<col width="12%">
									<col width="12%">
								</colgroup>
								<thead>
									<tr>
										<th>원료명</th>
										<th>코드번호</th>
										<th>배합율</th>
										<th>단가[단위]</th>
										<th>가격</th>
										<th>비급수 비율</th>
									</tr>
								</thead>
								<tbody>
									<c:set var="contItemLength" value="${fn:length(cont.subContentItem)}" />
									<c:set var="contMixingRatioTotal" value="0"/>
									<c:set var="contWaterRatioTotal" value="0"/>
									<c:set var="contProportionTotal" value="0"/>
									<c:forEach items="${cont.subContentItem}" var="item">
										<c:set var="contMixingRatioTotal" value="${contMixingRatioTotal + item.mixingRatio}"/>
										<c:if test="${item.itemSapCode == 'P10001'}">
											<c:set var="contWaterRatioTotal" value="${contWaterRatioTotal + item.mixingRatio}"/>
										</c:if>
									</c:forEach>
									
									<c:forEach items="${cont.subContentItem}" var="item">
									<c:set var="contPriceTotal" value="${contPriceTotal + (item.itemUnitPrice*item.mixingRatio)}"/>
									<tr>
										<th>${item.itemName}</th>
										<td>${item.itemSapCode}</td>
										<td>
											<c:choose>
												<c:when test='${userUtil:getDeptCode(pageContext.request) != "dept99"}'>
												${item.mixingRatio}
												</c:when>
												<c:otherwise>
												&nbsp;
												</c:otherwise>
											</c:choose>												
										</td>
										<td>
											<c:choose>
												<c:when test='${userUtil:getDeptCode(pageContext.request) != "dept99"}'>
												${item.itemUnitPrice}<c:if test="${item.itemUnit != null && fn:length(item.itemUnit)>0}">[${item.itemUnit}]</c:if>
												</c:when>
												<c:otherwise>
												&nbsp;
												</c:otherwise>
											</c:choose>												
										</td>
										<td>
											<c:choose>
												<c:when test='${userUtil:getDeptCode(pageContext.request) != "dept99"}'>
												<fmt:formatNumber value="${item.itemUnitPrice*item.mixingRatio}" pattern="#.####"/>
												</c:when>
												<c:otherwise>
												&nbsp;
												</c:otherwise>
											</c:choose>												
										</td>
										<td>
											<c:choose>
												<c:when test='${userUtil:getDeptCode(pageContext.request) != "dept99"}'>
													<c:choose>
														<c:when test="${item.itemSapCode == 'P10001'}">0</c:when>
														<c:otherwise>
															<fmt:formatNumber value="${(item.mixingRatio/(contMixingRatioTotal-contWaterRatioTotal))*100}" type="number" pattern="#.###"/>
															<c:set var="contProportionTotal" value="${contProportionTotal + (item.mixingRatio/(contMixingRatioTotal-contWaterRatioTotal)*100)}"/>
														</c:otherwise>
													</c:choose>
												</c:when>
												<c:otherwise>
												&nbsp;
												</c:otherwise>
											</c:choose>												
										</td>
										<c:set var= "contBomRateSum" value="${contBomRateSum + item.mixingRatio}"/>
									</tr>
									</c:forEach>
									<c:if test="${contItemLength<rigthContLength}">
									<c:forEach var="i" begin="1" end="${rigthContLength - contItemLength}">
										<tr>
											<th>&nbsp; </th>
											<td>&nbsp; </td>
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
												<c:when test='${userUtil:getDeptCode(pageContext.request) != "dept99"}'>
												<fmt:formatNumber value="${contMixingRatioTotal}" pattern=".000"/>
												</c:when>
												<c:otherwise>
												&nbsp;
												</c:otherwise>
											</c:choose>												
										</td>
										<Td>&nbsp;</Td>
										<td>
											<c:choose>
												<c:when test='${userUtil:getDeptCode(pageContext.request) != "dept99"}'>
												<fmt:formatNumber value="${contPriceTotal}" pattern=".000"/>
												</c:when>
												<c:otherwise>
												&nbsp;
												</c:otherwise>
											</c:choose>												
										</td>
										<td>
											<c:choose>
												<c:when test='${userUtil:getDeptCode(pageContext.request) != "dept99"}'>
												<fmt:formatNumber value="${contProportionTotal}" pattern="0"/>
												</c:when>
												<c:otherwise>
												&nbsp;
												</c:otherwise>
											</c:choose>												
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
									<col width="40%">
									<col width="12%">
									<col width="12%">
									<col width="12%">
									<col width="12%">
									<col width="12%">
								</colgroup>
								<thead>
									<tr>
										<th>원료명</th>
										<th>코드번호</th>
										<th>배합율</th>
										<th>단가[단위]</th>
										<th>가격</th>
										<th>비급수 비율</th>
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
										<td>&nbsp; </td>
									</tr>
								</c:forEach>	
									<tr>
										<th colspan="2">합계</th>
										<td>&nbsp; </td>
										<td>&nbsp; </td>
										<td>&nbsp; </td>
										<td>&nbsp; </td>									
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
									<td class="color07">  내용물  : ${cont.name}  </td>
								</tr>
							</table>
							<!-- 배합비 타이틀 close-->
							<table width="100%" class="intable02">
								<colgroup>
									<col width="40%">
									<col width="12%">
									<col width="12%">
									<col width="12%">
									<col width="12%">
									<col width="12%">
								</colgroup>
								<thead>
									<tr>
										<th>원료명</th>
										<th>코드번호</th>
										<th>배합율</th>
										<th>단가[단위]</th>
										<th>가격</th>
										<th>비급수 비율</th>
									</tr>
								</thead>
								<tbody>
									<c:set var="contMixingRatioTotal" value="0"/>
									<c:set var="contWaterRatioTotal" value="0"/>
									<c:set var="contProportionTotal" value="0"/>
									<c:forEach items="${cont.subContentItem}" var="item">
										<c:set var="contMixingRatioTotal" value="${contMixingRatioTotal + item.mixingRatio}"/>
										<c:if test="${item.itemSapCode == 'P10001'}">
											<c:set var="contWaterRatioTotal" value="${contWaterRatioTotal + item.mixingRatio}"/>
										</c:if>
									</c:forEach>
									
									<c:forEach items="${cont.subContentItem}" var="item">
									<c:set var="contPriceTotal" value="${contPriceTotal + (item.itemUnitPrice*item.mixingRatio)}"/>
									<tr>
										<th>${item.itemName}</th>
										<td>${item.itemSapCode}</td>
										<td>
											<c:choose>
												<c:when test='${userUtil:getDeptCode(pageContext.request) != "dept99"}'>
												${item.mixingRatio}
												</c:when>
												<c:otherwise>
												&nbsp;
												</c:otherwise>
											</c:choose>												
										</td>
										<td>
											<c:choose>
												<c:when test='${userUtil:getDeptCode(pageContext.request) != "dept99"}'>
												${item.itemUnitPrice}<c:if test="${item.itemUnit != null && fn:length(item.itemUnit)>0}">[${item.itemUnit}]</c:if>
												</c:when>
												<c:otherwise>
												&nbsp;
												</c:otherwise>
											</c:choose>												
										</td>
										<td>
											<c:choose>
												<c:when test='${userUtil:getDeptCode(pageContext.request) != "dept99"}'>
												<fmt:formatNumber value="${item.itemUnitPrice*item.mixingRatio}" pattern="#.####"/>
												</c:when>
												<c:otherwise>
												&nbsp;
												</c:otherwise>
											</c:choose>												
										</td>
										<td>
											<c:choose>
												<c:when test='${userUtil:getDeptCode(pageContext.request) != "dept99"}'>
													<c:choose>
														<c:when test="${item.itemSapCode == 'P10001'}">0</c:when>
														<c:otherwise>
															<fmt:formatNumber value="${(item.mixingRatio/(contMixingRatioTotal-contWaterRatioTotal))*100}" type="number" pattern="#.###"/>
															<c:set var="contProportionTotal" value="${contProportionTotal + (item.mixingRatio/(contMixingRatioTotal-contWaterRatioTotal)*100)}"/>
														</c:otherwise>
													</c:choose>
												</c:when>
												<c:otherwise>
												&nbsp;
												</c:otherwise>
											</c:choose>												
										</td>
										<c:set var= "contBomRateSum" value="${contBomRateSum + item.mixingRatio}"/>
									</tr>
									</c:forEach>
									<c:if test="${contItemLength<rigthContLength}">
									<c:forEach var="i" begin="1" end="${rigthContLength - contItemLength}">
										<tr>
											<th>&nbsp; </th>
											<td>&nbsp; </td>
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
												<c:when test='${userUtil:getDeptCode(pageContext.request) != "dept99"}'>
												<fmt:formatNumber value="${contMixingRatioTotal}" pattern=".000"/>
												</c:when>
												<c:otherwise>
												&nbsp;
												</c:otherwise>
											</c:choose>												
										</td>
										<Td>&nbsp;</Td>
										<td>
											<c:choose>
												<c:when test='${userUtil:getDeptCode(pageContext.request) != "dept99"}'>
												<fmt:formatNumber value="${contPriceTotal}" pattern=".000"/>
												</c:when>
												<c:otherwise>
												&nbsp;
												</c:otherwise>
											</c:choose>												
										</td>
										<td>
											<c:choose>
												<c:when test='${userUtil:getDeptCode(pageContext.request) != "dept99"}'>
												<fmt:formatNumber value="${contProportionTotal}" pattern="0"/>
												</c:when>
												<c:otherwise>
												&nbsp;
												</c:otherwise>
											</c:choose>												
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
						<td class="color05"></td>
					</tr>
					<tr>
						<td valign="top" style="border-right:2px solid #000">
							<table width="100%" class="intable02">
								<colgroup>
									<col width="52%">
									<col width="12%">
									<col width="12%">
									<col width="12%">
									<col width="12%">
								</colgroup>							
								<thead>
									<tr style="border: 1px solid #666">
										<th>재료명</th>
										<th>재료코드</th>
										<th>단가</th>
										<th>수량</th>
										<th>가격</th>
									</tr>
								</thead>
								<tbody>
								<c:set var="pkgPriceTotal" value="0"/>
								<c:forEach items="${designDocDetail.pkg}" var="pkg">
									<tr>
										<th>${pkg.itemName}</th>
										<td>${pkg.itemSapCode}</td>
										<td>
											<c:choose>
												<c:when test='${userUtil:getDeptCode(pageContext.request) != "dept99"}'>
												${pkg.itemSapPrice}
												</c:when>
												<c:otherwise>
												&nbsp;
												</c:otherwise>
											</c:choose>												
										</td>
										<td>
											<c:choose>
												<c:when test='${userUtil:getDeptCode(pageContext.request) != "dept99"}'>
												${pkg.itemVolume}
												</c:when>
												<c:otherwise>
												&nbsp;
												</c:otherwise>
											</c:choose>												
										</td>
										<td>
											<c:choose>
												<c:when test='${userUtil:getDeptCode(pageContext.request) != "dept99"}'>
												${pkg.itemUnitPrice}
												</c:when>
												<c:otherwise>
												&nbsp;
												</c:otherwise>
											</c:choose>												
										</td>
										<c:set var="pkgPriceTotal" value="${pkgPriceTotal + pkg.itemUnitPrice}"/>
									</tr>
								</c:forEach>
								<tr>
									<th colspan="2">합계</th>
									<td></td>
									<td></td>
									<td>
										<c:choose>
											<c:when test='${userUtil:getDeptCode(pageContext.request) != "dept99"}'>
											<fmt:formatNumber value="${pkgPriceTotal}" pattern="0.00"/>
											</c:when>
											<c:otherwise>
											&nbsp;
											</c:otherwise>
										</c:choose>												
									</td>
								</tr>
								</tbody>
							</table>
						</td>
						<td>
							<table width="100%" class="intable02">
								<colgroup>
									<col width="52%">
									<col width="12%">
									<col width="12%">
									<col width="12%">
									<col width="12%">
								</colgroup>							
								<thead>
									<tr style="border: 1px solid #666">
										<th>재료명</th>
										<th>재료코드</th>
										<th>단가</th>
										<th>수량</th>
										<th>가격</th>
									</tr>
								</thead>
								<tbody>
								<c:forEach items="${designDocDetail.pkg}" var="pkg">
									<tr>
										<th></th>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
									</tr>
								</c:forEach>
								<tr>
									<th colspan="2"></th>
									<td></td>
									<td></td>
									<td></td>
								</tr>
								</tbody>
							</table>
						</td>
					</tr>
				</table>
			</div>
			<!-- 표시사항배합비,제조방법,제품사진,제조방법 close-->
			<!-- 비고 start-->
			<div class="hold">
				<table class="intable04 linebottom" style="border-bottom: 1px solid balck;" width="100%">
					<colgroup>
						<col width="19%">
						<col width="12%">
						<col width="auto">
						<col width="12%">
						<col width="12%">
						<col width="12%">
					</colgroup>
					<thead>
						<tr>
							<td colspan="6" class="color05">원재료비</td>
						</tr>
						<tr style="border: 1px solid #666">
							<th>부속제품명</th>
							<th>구분</th>
							<th>배합/내용물명</th>
							<th>단가(KG)</th>
							<th>분할중량</th>
							<th>원가</th>
						</tr>
					</thead>
					<c:forEach items="${designDocDetail.cost}" var="item" varStatus="subStatus">
						<c:set var="costPriceTotal" value="${costPriceTotal+item.orgPrice}"/>
						<c:set var="costWeightTotal" value="${costWeightTotal+item.weight}"/>
						<tr>
							<td>${item.subProdName}</td>
							<td>
								<c:if test="${item.type == 'mix'}">배합</c:if>
								<c:if test="${item.type == 'content'}">내용물</c:if>
							</td>
							<td>${item.name}</td>
							<td><fmt:formatNumber value="${item.kgPrice}" pattern=".000"/></td>
							<td>${item.weight}</td>
							<td><fmt:formatNumber value="${item.kgPrice/1000*item.weight*(designDocDetail.yieldRate/100)}" pattern=".000"/></td>
						</tr>
					</c:forEach>
					<tfoot style="border-top: 2px solid black;">
						<c:set var="price" value="${designDocDetail.productPrice*designDocDetail.plantPrice/100}"/>
						<c:set var="costPriceTotal" value="${costPriceTotal*(designDocDetail.yieldRate/100)}"/>
						<tr>
							<td colspan="3" style="background-color: #f2f2f2;">합계</td><td>원료</td><td>${costWeightTotal}</td>
							<td><fmt:formatNumber value="${costPriceTotal}" pattern=".000"/> (<fmt:formatNumber value="${costPriceTotal/price*100}" pattern=".00"/>%)</td>
						</tr>
						<tr>
							<td colspan="3" style="background-color: #f2f2f2; border-bottom: 1px solid #f2f2f2;"></td><td>재료</td><td></td>
							<td><fmt:formatNumber value="${pkgPriceTotal}" pattern=".000"/> (<fmt:formatNumber value="${pkgPriceTotal/price*100}" pattern=".00"/>%)</td>
						</tr>
						<tr>
							<td colspan="3" style="background-color: #f2f2f2; border-bottom: 1px solid #f2f2f2;"></td><td>총 가격</td><td></td>
							<td><fmt:formatNumber value="${costPriceTotal+pkgPriceTotal}" pattern=".000"/> (<fmt:formatNumber value="${(costPriceTotal+pkgPriceTotal)/price*100}" pattern=".00"/>%)</td>
						</tr>
						<tr><td colspan="3" style="background-color: #f2f2f2; border-bottom: 1px solid #f2f2f2;"></td><td>소매가격</td><td></td><td>${designDocDetail.productPrice}</td></tr>
						<tr><td colspan="3" style="background-color: #f2f2f2;"></td><td>출하가</td><td><fmt:formatNumber value="${(designDocDetail.plantPrice)}" pattern=".00"/> %</td><td>${price}</td></tr>
					</tfoot>
				</table>
			</div>
			<!-- 비고 close-->
			<!-- 제품규격(밀다원) start-->
			<c:if test="${fn:trim(mfgProcessDoc.calcType) == '3' or fn:trim(mfgProcessDoc.calcType) == '7'}">
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
							<td colspan="6" class="color05"> 제품규격(밀다원) </td>
						</tr>
						<tr>
							<th>Moisture(%)</th>
							<td>
								${mfgProcessDoc.specMD.moisture} 
								<c:if test="${fn:length(mfgProcessDoc.specMD.moisture) > 0}">
									${mfgProcessDoc.specMD.moistureUnit == 'gt' ? '↑' : '↓'}
								</c:if>
							</td>
							<th>Ash(%)</th>
							<td>
								<c:if test="${fn:length(mfgProcessDoc.specMD.ashFrom) > 0 or fn:length(mfgProcessDoc.specMD.ashTo) > 0}">
									${mfgProcessDoc.specMD.ashFrom} ~ ${mfgProcessDoc.specMD.ashTo}
								</c:if>
							</td>
							<th>Protein(%)</th>
							<td>
								${mfgProcessDoc.specMD.protein}
								<c:if test="${fn:length(mfgProcessDoc.specMD.proteinErr) > 0}">
									 ± ${mfgProcessDoc.specMD.proteinErr}
								</c:if>
							</td>
						</tr>
						<tr>
							<th>Water absorption(%)</th>
							<td>
								<c:if test="${fn:length(mfgProcessDoc.specMD.waterAbsFrom) > 0 or fn:length(mfgProcessDoc.specMD.waterAbsTo) > 0}">
									${mfgProcessDoc.specMD.waterAbsFrom} ~ ${mfgProcessDoc.specMD.waterAbsTo}
								</c:if>
							</td>
							<th>Stability(min)</th>
							<td>
								<c:if test="${fn:length(mfgProcessDoc.specMD.stabilityFrom) > 0 or fn:length(mfgProcessDoc.specMD.stabilityTo) > 0}">
									${mfgProcessDoc.specMD.stabilityFrom} ~ ${mfgProcessDoc.specMD.stabilityTo}
								</c:if>
							</td>
							<th>Development time(min)</th>
							<td>
								${mfgProcessDoc.specMD.devTime}
								<c:if test="${fn:length(mfgProcessDoc.specMD.devTime) > 0}">
									${mfgProcessDoc.specMD.devTimeUnit == 'gt' ? '↑' : '↓'}
								</c:if>
							</td>
						</tr>
						<tr>
							<th>P/L</th>
							<td>
								<c:if test="${fn:length(mfgProcessDoc.specMD.plFrom) > 0 or fn:length(mfgProcessDoc.specMD.plTo) > 0}">
								  	${mfgProcessDoc.specMD.plFrom} ~ ${mfgProcessDoc.specMD.plTo}
								</c:if>
							</td>
							<th>Maximum viscosity(BU)</th>
							<td>
								${mfgProcessDoc.specMD.maxVisc}
								<c:if test="${fn:length(mfgProcessDoc.specMD.maxVisc) > 0}">
									${mfgProcessDoc.specMD.maxViscUnit == 'gt' ? '↑' : '↓'}
								</c:if>
							</td>
							<th>FN(sec)</th>
							<td>
								<c:if test="${fn:length(mfgProcessDoc.specMD.fnFrom) > 0 or fn:length(mfgProcessDoc.specMD.fnTo) > 0}">
									${mfgProcessDoc.specMD.fnFrom} ~ ${mfgProcessDoc.specMD.fnTo}
								</c:if>
							</td>
						</tr>
						<tr>
							<th>Color(Lightness)</th>
							<td>
								${mfgProcessDoc.specMD.color}
								<c:if test="${fn:length(mfgProcessDoc.specMD.color) > 0}">
									${mfgProcessDoc.specMD.colorUnit == 'gt' ? '↑' : '↓'}
								</c:if>
							</td>
							<th>Wet gluten(%)</th>
							<td>
								<c:if test="${fn:length(mfgProcessDoc.specMD.wetGlutenFrom) > 0 or fn:length(mfgProcessDoc.specMD.wetGlutenTo) > 0}">
									${mfgProcessDoc.specMD.wetGlutenFrom} ~ ${mfgProcessDoc.specMD.wetGlutenTo}
								</c:if>
							</td>
							<th>Viscosity(Batter)mm</th>
							<td>
								${mfgProcessDoc.specMD.visc}
								<c:if test="${fn:length(mfgProcessDoc.specMD.visc) > 0}">
									${mfgProcessDoc.specMD.viscUnit == 'gt' ? '↑' : '↓'}
								</c:if>
							</td>
						</tr>
						<tr>
							<th>Particle size(Average)㎛</th>
							<td>${strUtil:getHtmlBr(mfgProcessDoc.specMD.particleSize)}</td>
							<td colspan="4"></td>
							<!-- <th></th>
							<td></td>
							<th></th>
							<td></td> -->
						</tr>
					</table>
				</div>
			</c:if>
			<!-- 제품규격(밀다원) close-->
			<!-- 출력버튼 -->
			<table width="1046" cellpadding="0" cellspacing="0" class="print_hidden">
				<tr>
					<td align="right" height="50" valign="bottom">
					<c:if test='${userUtil:getUserId(pageContext.request) == designDocInfo.regUserId || userUtil:getIsAdmin(pageContext.request) == "Y"}'>
						<!-- <button type="button" class="btn_admin_green" onClick="excelDownloadCheck();"><img src="/resources/images/icon_excel.png" style="vertical-align:middle"> 엑셀 다운로드</button> -->
						<button type="button" class="btn_admin_nomal" onClick="printCheck();">프린트</button>
					</c:if>	
						<button type="button" class="btn_admin_gray" onClick="self.close();">취소</button>
					</td>
				</tr>
			</table>
			<!-- 여기까지 프린트 -->
	</div>
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
