<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="userUtil" uri="/WEB-INF/tld/userUtil.tld"%>
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
.font_mm{font-size:15px;font-family:'맑은고딕',Malgun Gothic;}
</style>
<script type="text/javascript">
$(document).ready(function() {
	var drNo = '${designReqDoc.drNo}';
	var nutritionType = '${designReqDoc.nutritionLabel.nutritionType}';
	
	
	var data = {
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
	};
	
	var mmHeader = '${mmHeader}';
	var mmItemList = '${mmItemList}';
	
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

function approvalSubmit() {
	/* if( !chkNull($("#note").val()) ) {
		alert("결재 의견을 입력해주세요.");
		$("#note").focus();
		return;
	} else  */{
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
/*
var initBody;

function beforePrint() { //인쇄 하기 전에 실행되는 내용
	initBody = document.body.innerHTML;
	document.body.innerHTML = $("#print_page").html();
	
}

function afterPrint(){ //인쇄가 끝난 후 실행되는 내용
	document.body.innerHTML = initBody;
}
*/

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
	$("#water_mark_td").append("");
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
<c:when test='${userUtil:getUserId(pageContext.request) eq designReqDoc.regUserId || userUtil:getUserGrade(pageContext.request) == "3" || userUtil:getIsAdmin(pageContext.request) == "Y"}'>
function printCheck() {
	window.onbeforeprint = beforePrint;
	window.onafterprint = afterPrint;
	window.print();
	insertPrintLog("","P");
}

function excelDownloadCheck() {
	//$('#form').attr('action', '/approval/excelDownload').submit();
	excelDownload()
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

function goList(docNo, docVersion) {
	opener.document.location = "/dev/productDevDocDetail?docNo="+docNo+"&docVersion="+docVersion;
}

function goUpdate(drNo, docNo, docVersion) {
	opener.document.location = "/dev/designRequestDocEdit?drNo="+drNo+"&docNo="+docNo+"&docVersion="+docVersion;
}
</script>

<h2 style=" position:fixed;" class="print_hidden">
	<span class="title"><img src="/resources/images/bg_bs_box_fast02.png">&nbsp;&nbsp;원료변경요청서 결재</span>
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
				<!--button type="button" class="btn_admin_green" onClick="excelDownloadCheck();"><img src="/resources/images/icon_excel.png" style="vertical-align:middle"> 엑셀 다운로드</button-->
				<c:if test='${userUtil:getUserGrade(pageContext.request) == "6" }'>
				<button type="button" class="btn_admin_green" onClick="goList('${designReqDoc.docNo}','${designReqDoc.docVersion}');">목록보기</button>
				<button type="button" class="btn_admin_sky" onClick="goUpdate('${designReqDoc.drNo}','${designReqDoc.docNo}','${designReqDoc.docVersion}');">수정</button>
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
	<input type="hidden" name="regUserId" id="regUserId" value="${designReqDoc.regUserId }">
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
															<c:when test="${item.seq eq '2' }">
																프린트결재
															</c:when>
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
	<div class="print_box">
		<div>
			<div class="watermark"><img src="/resources/images/watermark.png"></div>
			<!-- 유출금지 정보출력 start-->
			<table width="100%"  class="intable lineside" style="display:none" id="water_mark_table">
				<tr>
					<td id="water_mark_td">!- 유출금지 정보출력 -!</td>
				</tr>
			</table>
			<!-- 유출금지 정보출력 close-->
		</div>	
		<div class="mt10">
			<!-- 세부 내용 -->
				<div class="prodoc_title" style="margin-bottom: 10px; border-top: 2px solid #4b5165">
					<div style="display: inline-block; height: 60px; width: 100%;">
						<span class="font_mm">변경 전 원료 : [${mmHeader.preSapCode}] ${mmHeader.preName}&nbsp;</span>
						<br><span class="font_mm">변경 후 원료 : [${mmHeader.postSapCode}] ${mmHeader.postName}&nbsp;</span>
					</div>
					<%--
					<div style="display: inline-block; height: 80px; width: 100%;">
						<div style="display: inline-block; width:10%; text-align: center; border: 1px solid black;"><span style="font-size: 18px; font-weight: bold;">${mmHeader.preSapCode}</span>&nbsp;</div>
						<div style="display: inline-block; width:20%; text-align: center; border: 1px solid red;"><span style="font-size: 18px; font-weight: bold;">${mmHeader.preName}</span>&nbsp;</div>
						<div style="display: inline-block; width:10%; text-align: center; border: 1px solid green;"><span style="font-size: 18px; font-weight: bold;">${mmHeader.postSapCode}</span>&nbsp;</div>
						<div style="display: inline-block; width:20%; text-align: center; border: 1px solid black;"><span style="font-size: 18px; font-weight: bold;">${mmHeader.postName}</span>&nbsp;</div>
						<div style="display: inline-block; width:37%; text-align: center; border: 1px solid blue;">5&nbsp;</div>
					</div> 
					--%>
				</div>
				
				<div class="main_tbl" style="height: 100%; float: left; width: 100%; background-color: rgb(245, 245, 245)">
					<table class="tbl04">
						<colgroup>
							<col width="8%">
							<col width="7%">
							<col width="10%">
							<col />
							<%-- <col width="8%"> --%>
							<col width="18%">
							<col width="20%">
						</colgroup>
						<thead>
							<tr>
								<th>제품코드</th>
								<th>대체BOM</th>
								<th>공장</th>
								<th>제품명</th>
								<!-- <th>SAP코드</th> -->
								<!-- <th>단가</th> -->
								<th>작성일</th>
								<th>연관 제조공정서 번호</th>
							<tr>
						</thead>
						<tbody id="list" style="overflow: auto;">
							<c:forEach var="item" items="${mmItemList}">
								<tr id="row_${item.miNo}" class="${item.isExcept=='Y' ? 'm_visible' : ''}">
									<td>${item.productCode}</td>
									<td>${item.posnr}</td>
									<td>${item.plantName}</td>
									<td>${item.productName}</td>
									<td>${item.regDate}</td>
									<c:if test="${item.mfgState == 9}">
										<td style="text-align: left;">
											<c:forEach var="mfgNo" items="${fn:split(item.dNoList, ',')}">
												<c:if test="${fn:length(item.dNoList) > 0}">
													<img src="/resources/images/icon_doc01.png">
													<a href="javascript:preViewMfgDoc('${mfgNo}')">
														<span style="color: #e83346; font-weight: bold;">${mfgNo}</span>
													</a>
												</c:if>
											</c:forEach>
										</td>
									</c:if>
									<c:if test="${item.mfgState != 9}">
										<td style="text-align: left;">
											<c:forEach var="mfgNo" items="${fn:split(item.dNoList, ',')}">
												<c:if test="${fn:length(item.dNoList) > 0}">
													<span>${mfgNo}</span>
												</c:if>
											</c:forEach>
										</td>
									</c:if>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
				<hr class="con_mode" />
				<!-- 신규 추가 꼭 데려갈것 !-->
			
		</div>	
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
			<button class="btn_admin_red"onclick="javascript:goPrintRequest();">결재요청</button> 
			<button class="btn_admin_gray"onclick="closeDialog('open')"> 취소</button>
		</div>
	</div>
</div>