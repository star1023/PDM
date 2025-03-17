<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="userUtil" uri="/WEB-INF/tld/userUtil.tld"%>
<%@ taglib prefix="dateUtil" uri="/WEB-INF/tld/dateUtil.tld"%>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="kr.co.aspn.util.*" %> 
<%@ page session="false" %>
<%
	String userDept = UserUtil.getDeptCode(request);
%>
<!--점포용, OEM 제품명처리-->
<c:if test="${productDevDoc.productDocType == null}">
    <c:set target="${productDevDoc}" property="productDocType" value="0"/>
</c:if>
<c:set var="productDocTypeName" value="" />
<c:set var="productNamePrefix" value="" />
<c:set var="titlePrefix" value="" />
<c:set var="displayNone" value=""/>
<c:choose>
    <c:when test="${productDevDoc.productDocType == '1'}">
        <c:set var="productDocTypeName" value="점포용 " />
        <c:set var="productNamePrefix" value="[${productDevDoc.storeDivText}]" /> 
        <c:set var="titlePrefix" value="[BF] " />
        <c:set var="displayNone" value="display:none"/>
    </c:when>
    <c:when test="${productDevDoc.productDocType == '2'}">
        <c:set var="productDocTypeName" value="OEM " />
        <c:set var="displayNone" value="display:none"/>
    </c:when>
    <c:otherwise></c:otherwise>
</c:choose>
<title>제조공정서 미리보기</title>
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

/*
 * 230816
 * 엑셀 다운로드 및 프린트 권한 수정
 * 기존 : Grade : BOM, 디자인, 관리자, 제조공정서 작성자
 * 변경 : 제조공정서 작성자 --> 제품담당자(제품개발문서 작성자) //나머진 그대로 유지.
 */
<c:choose>
<%-- <c:when test='${userUtil:getUserId(pageContext.request) eq mfgProcessDoc.regUserId || userUtil:getUserGrade(pageContext.request) == "3" || userUtil:getUserGrade(pageContext.request) == "6" || userUtil:getIsAdmin(pageContext.request) == "Y"}'>  --%>
<c:when test='${userUtil:getUserId(pageContext.request) eq productDevDoc.regUserId || userUtil:getUserGrade(pageContext.request) == "3" || userUtil:getUserGrade(pageContext.request) == "6" || userUtil:getIsAdmin(pageContext.request) == "Y"}'>
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
		data: {tbKey: '${paramVO.tbKey }', tbType:'manufacturingProcessDoc'},
		xhrFields: { responseType: 'blob' },
		success : function(data, b, xhr) {
			var contentDis = xhr.getResponseHeader('content-disposition');
	        var fileName = decodeURIComponent(contentDis.replace(/";/g,'').substr(contentDis.indexOf('filename=')+('filename=').length));
			var blob = new Blob([data]);
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
	        //console.log(a,b,c);
	        return alert('파일 다운로드 오류[2]')
	    }
	});
}

//반올림 처리
function round(n, digits) {
	if (digits >= 0) return parseFloat(Number(n).toFixed(digits)); // 소수부 반올림
	digits = Math.pow(10, digits); // 정수부 반올림
	var t = Math.round(n * digits) / digits;
	return parseFloat(t.toFixed(0));
}
</script>

<input type="hidden" name="tbKey" id="tbKey" value="${paramVO.tbKey }">
	<input type="hidden" name="tbType" id="tbType" value="manufacturingProcessDoc">
	<input type="hidden" name="currentUserid" id="currentUserid" value="${apprItemHeader.currentUserId }">
	<input type="hidden" name="currentStep" id="currentStep" value="${apprItemHeader.currentStep }">
	<input type="hidden" name="apprNo" id="apprNo" value="${apprItemHeader.apprNo }">
	<input type="hidden" name="title" id="title" value="${apprItemHeader.title }">
	<input type="hidden" name="regUserId" id="regUserId" value="${mfgProcessDoc.regUserId }">
	<input type="hidden" name="tbTypeName" id="tbTypeName" value="${apprItemHeader.tbTypeName }">
<h2 style=" position:fixed;" class="print_hidden">
	<span class="title"><img src="/resources/images/bg_bs_box_fast02.png">&nbsp;&nbsp;${productDocTypeName}제조공정서 미리보기</span>
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
			<%-- <c:if test='${userUtil:getUserGrade(pageContext.request) == "2" || userUtil:getUserGrade(pageContext.request) == "3" || userUtil:getUserGrade(pageContext.request) == "4" || userUtil:getUserGrade(pageContext.request) == "5"}'> --%>
			<c:if test='${userUtil:getUserGrade(pageContext.request) == "3" || userUtil:getUserGrade(pageContext.request) == "6" || userUtil:getIsAdmin(pageContext.request) == "Y" || userUtil:getUserId(pageContext.request) == productDevDoc.regUserId}'>
				<button type="button" class="btn_admin_green" onClick="excelDownloadCheck();"><img src="/resources/images/icon_excel.png" style="vertical-align:middle"> 엑셀 다운로드</button>
			</c:if>
				<button type="button" class="btn_admin_nomal" onClick="printCheck();">프린트</button>
				<button type="button" class="btn_admin_gray" onClick="self.close();">취소</button>
			</td>
		</tr>
	</table>
	<!-- 출력버튼 -->
	<!-- 실제 출력대상 start ------------------------------------------------------------------------------------------------------------------------------------------------>
	<div class="print_box" style="table-layout:fixed;">
		<!-- 상단 머리정보 start-->
		<div class="hold">
			<table border="0" width="100%" height="60" style="display:none" id="confi">
				<tr>
					<td align="left">
						<img src="/resources/images/btn_confi.png"  border="0" style="margin-left:3px;"/>
					</td>
				</tr>
			</table>
			<table width="100%"  class="intable lineall mb5" >
				<colgroup>
					<col width="50%">
					<col width="30%">
					<col width="10%">
					<col width="10%">
				</colgroup>
				<tr>
					<td class="color05">제품제조공정서</td>
					<td rowspan="3">
						<table style="width:100%;height:90%" class="intable02">
						<c:forEach items = "${apprItemList}" var = "item" varStatus= "status">
						<c:set var="apprLength" value="${fn:length(apprItemList)}" />
							<tr>
								<td width="25%">
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
								</td>
								<td width="30%">
									${item.userName}
								</td>
								<td width="45%">
									<c:choose>
									<c:when test="${item.seq eq '1' }">
									${item.regDate}
									</c:when>
									<c:otherwise>
									<c:if test="${item.modDate != '' && item.modDate != null}">
									${item.modDate}
									</c:if>
									</c:otherwise>												
									</c:choose>
								</td>
							</tr>						
						</c:forEach>
						<c:if test="${apprLength<4}">
						<c:forEach var="i" begin="1" end="${4-apprLength}">
							<tr>
								<td></td>
								<td></td>
								<td></td>
							</tr>
						</c:forEach>
						</c:if>
						</table>
					</td>
					<td class="color05">문서번호</td>
					<td>SHA-L-${mfgProcessDocNo }</td> <!-- 제조공정서 번호 -->
				</tr>
				<tr>
					<td rowspan="2"><span class="big_font">${productNamePrefix}${productDevDoc.productName}(${productDevDoc.productCode})/${mfgProcessDoc.plantName}</span></td>
					<td class="color05">제개정일</td>
					<td>${dateUtil:convertDate(mfgProcessDoc.modDate,"yyyy-MM-dd HH:mm:ss","yyyy-MM-dd")}</td>
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
			<c:if test="${!(userUtil:getDeptCode(pageContext.request) == 'dept9' && userUtil:getUserGrade(pageContext.request) != '13') && userUtil:getDeptCode(pageContext.request) != 'dept8' }">
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
								<c:choose>
									<c:when test="${productDevDoc.productDocType == '0'}">
										<c:if test="${fn:trim(mfgProcessDoc.calcType) != '7'}">
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
													<th>스크랩(%)</th>
												</tr>
												</thead>
												<tbody>
												<c:set var="mixItemLength" value="${fn:length(mix.item)}" />
												<c:set var= "mixBomRateSum" value="0"/>
												<c:set var= "mixBomAmountSum" value="0"/>
												<c:forEach items="${mix.item}" var="item">

													<c:set var="backgroundColor" value=""/>
													<c:if test="${mfgProcessDoc.companyCode == 'MD' && mfgProcessDoc.calcType == '10' && item.itemCode == '400023'}">
														<c:set var="backgroundColor" value="#ffe8d9"/>
													</c:if>

													<tr>
														<th>${strUtil:getHtmlBr(item.itemName)}
															<c:if test="${item.coo != null && item.coo != ''}">
																[${item.cooName}]
															</c:if>
														</th>
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
														<td style="background-color: ${backgroundColor}">
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
														<c:if test="${!(mfgProcessDoc.companyCode == 'MD' && mfgProcessDoc.calcType == '10' && item.itemCode == '400023')}">
															<c:set var= "mixBomRateSum" value="${mixBomRateSum + item.bomRate}"/>
															<c:set var= "mixBomAmountSum" value="${mixBomAmountSum + item.bomAmount}"/>
														</c:if>
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
																<fmt:formatNumber value="${mixBomAmountSum}" pattern="0.###"/>
															</c:when>
															<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
																0.00
															</c:when>
															<c:otherwise>
																<fmt:formatNumber value="${mixBomAmountSum}" pattern="0.###"/>
															</c:otherwise>
														</c:choose>
													</td>
													<td>
														<c:choose>
															<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) == "13"}'>
																<fmt:formatNumber value="${mixBomRateSum}" pattern="0.###"/>
															</c:when>
															<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
																0.00
															</c:when>
															<c:otherwise>
																<fmt:formatNumber value="${mixBomRateSum}" pattern="0.###"/>
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
										</c:if>
										<c:if test="${fn:trim(mfgProcessDoc.calcType) == '7'}">
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
													<th>BOM항목</th>
													<th>스크랩(%)</th>
												</tr>
												</thead>
												<tbody>
												<c:set var="mixItemLength" value="${fn:length(mix.item)}" />
												<c:set var= "mixBomRateSum" value="0"/>
												<c:set var= "mixBomAmountSum" value="0"/>

												<c:forEach items="${mix.item}" var="item">

													<c:set var="backgroundColor" value=""/>
													<c:if test="${fn:startsWith(item.itemCode, '4') || fn:startsWith(item.itemCode, '5')}">
														<c:set var="backgroundColor" value="#ffe8d9"/>
													</c:if>

													<tr>
														<th>${strUtil:getHtmlBr(item.itemName)}
															<c:if test="${item.coo != null && item.coo != ''}">
																[${item.cooName}]
															</c:if>
														</th>
														<td>
																${item.itemCode}
														</td>
														<td>-</td>
														<td style="background-color: ${backgroundColor}">
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
														<td>-</td>
														<c:if test="">

														</c:if>
														<c:if test="${!(fn:startsWith(item.itemCode, '4') || fn:startsWith(item.itemCode, '5'))}">
															<c:set var= "mixBomRateSum" value="${mixBomRateSum + item.bomRate}"/>
															<c:set var= "mixBomAmountSum" value="${mixBomAmountSum + item.bomAmount}"/>
														</c:if>
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
													<td>&nbsp;</td>
													<td>
														<c:choose>
															<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) == "13"}'>
																<fmt:formatNumber value="${mixBomRateSum}" pattern="0.###"/>
															</c:when>
															<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
																0.00
															</c:when>
															<c:otherwise>
																<fmt:formatNumber value="${mixBomRateSum}" pattern="0.###"/>
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
										</c:if>
									</c:when>
									<c:when test="${productDevDoc.productDocType == '1' or productDevDoc.productDocType == '2'}">
										<table width="100%" class="intable02">
											<colgroup>
												<col width="30%">
												<col width="20%">
												<col width="25%">
												<col width="25%">
											</colgroup>
											<thead>
											<tr>
												<th>원료명</th>
												<th>배합%</th>
												<th>제조사</th>
												<th>성분</th>
											</tr>
											</thead>
											<tbody>
											<c:set var="mixItemLength" value="${fn:length(mix.item)}" />
											<c:set var= "mixBomAmountSum" value="0"/>
											<c:forEach items="${mix.item}" var="item">
												<tr>
													<th>${strUtil:getHtmlBr(item.itemName)}</th>
													<td>${item.bomAmount}</td>
													<td>${item.manuCompany}</td>
													<td>${item.ingradient}</td>
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
													</tr>
												</c:forEach>
											</c:if>
											<tr>
												<th>합계</th>
												<td><fmt:formatNumber value="${mixBomAmountSum}" pattern="0.###"/></td>
												<td>&nbsp;</td>
												<td>&nbsp;</td>
											</tr>
											</tbody>
										</table>
									</c:when>
									<c:otherwise></c:otherwise>
								</c:choose>
							</td>
							<%-- <c:if test="${(mixLength-1 == status.index) || mixLength%2 == 1 }"> --%>
							<c:if test="${ rigthItemLength == 0}">
							<td width="50%" style=" border-right:2px solid #000; vertical-align:top;">
								<!-- 배합비 타이틀 start-->
								<table width="100%"  class="intable04" >
									<tr>
										<td class="color06"> &nbsp;  </td>
									</tr>
								</table>
                                <!-- 배합비 타이틀 close-->
								<c:choose>
									<c:when test="${productDevDoc.productDocType == '0'}">
										<c:if test="${fn:trim(mfgProcessDoc.calcType) != '7' }">
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
													<th>스크랩(%)</th>
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
										</c:if>
									</c:when>
									<c:when test="${productDevDoc.productDocType == '1' or productDevDoc.productDocType == '2'}">
										<table width="100%" class="intable02">
											<colgroup>
												<col width="30%">
												<col width="20%">
												<col width="25%">
												<col width="25%">
											</colgroup>
											<thead>
											<tr>
												<th>원료명</th>
												<th>배합%</th>
												<th>제조사</th>
												<th>성분</th>
											</tr>
											</thead>
											<tbody>
											<c:forEach var="i" begin="1" end="${mixItemLength}">
												<tr>
													<th></th>
													<td></td>
													<td></td>
													<td></td>
												</tr>
											</c:forEach>
											<tr>
												<th>합계</th>
												<td>&nbsp;</td>
												<td>&nbsp;</td>
												<td>&nbsp;</td>
											</tr>
											</tbody>
										</table>
									</c:when>
									<c:otherwise></c:otherwise>
								</c:choose>
							</td>	
							</c:if>
						</c:when>
						<c:otherwise>
							<c:choose>
								<c:when test="${productDevDoc.productDocType == '0'}">
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
												<th>스크랩(%)</th>
											</tr>
											</thead>
											<tbody>
											<c:set var= "mixBomRateSum2" value="0"/>
											<c:set var= "mixBomAmountSum2" value="0"/>
											<c:set var="mixItemLength2" value="${fn:length(mix.item)}" />
											<c:forEach items="${mix.item}" var="item">
												<tr>
													<th>${strUtil:getHtmlBr(item.itemName)}</th>
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
											<c:if test="${mixItemLength2<mixItemLength}">
												<c:forEach var="i" begin="1" end="${mixItemLength - mixItemLength2}">
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
															<fmt:formatNumber value="${mixBomAmountSum2}" pattern="0.###"/>
														</c:when>
														<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
															0.00
														</c:when>
														<c:otherwise>
															<fmt:formatNumber value="${mixBomAmountSum2}" pattern="0.###"/>
														</c:otherwise>
													</c:choose>
												</td>
												<td>
													<c:choose>
														<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) == "13"}'>
															<fmt:formatNumber value="${mixBomRateSum2}" pattern="0.###"/>
														</c:when>
														<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
															0.00
														</c:when>
														<c:otherwise>
															<fmt:formatNumber value="${mixBomRateSum2}" pattern="0.###"/>
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
								</c:when>
								<c:when test="${productDevDoc.productDocType == '1' or productDevDoc.productDocType == '2'}">
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
												<col width="30%">
												<col width="20%">
												<col width="25%">
												<col width="25%">
											</colgroup>
											<thead>
											<tr>
												<th>원료명</th>
												<th>배합%</th>
												<th>제조사</th>
												<th>성분</th>
											</tr>
											</thead>
											<tbody>
											<c:set var= "mixBomAmountSum2" value="0"/>
											<c:set var="mixItemLength2" value="${fn:length(mix.item)}" />
											<c:forEach items="${mix.item}" var="item">
												<tr>
													<th>${strUtil:getHtmlBr(item.itemName)}</th>
													<td>${item.bomAmount}</td>
													<td>${item.manuCompany}</td>
													<td>${item.ingradient}</td>
													<c:set var= "mixBomAmountSum2" value="${mixBomAmountSum2 + item.bomAmount}"/>
												</tr>
											</c:forEach>
											<c:if test="${mixItemLength2<mixItemLength}">
												<c:forEach var="i" begin="1" end="${mixItemLength - mixItemLength2}">
													<tr>
														<th></th>
														<td></td>
														<td></td>
														<td></td>
													</tr>
												</c:forEach>
											</c:if>
											<tr>
												<th>합계</th>
												<td><fmt:formatNumber value="${mixBomAmountSum2}" pattern="0.###"/></td>
												<td> </td>
												<td>&nbsp;</td>
											</tr>
											</tbody>
										</table>
									</td>
								</c:when>
								<c:otherwise></c:otherwise>
							</c:choose>
						</c:otherwise>
					</c:choose>
					<c:if test="${status.index == mixLength-1 or status.index%2 == 1 }">
					</tr>
					</c:if>
					</c:forEach>
				</table>
			</div>
			<!-- 내용물 start -->
			<c:choose>
				<c:when test="${productDevDoc.productDocType == '0'}">
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
													<th>스크랩(%)</th>
												</tr>
												</thead>
												<tbody>
												<c:set var="contItemLength" value="${fn:length(cont.item)}" />
												<c:set var= "contBomRateSum" value="0"/>
												<c:set var= "contBomAmountSum" value="0"/>
												<c:forEach items="${cont.item}" var="item">
													<tr>
														<th>${strUtil:getHtmlBr(item.itemName)}</th>
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
													<c:forEach var="i" begin="1" end="${rigthContLength - contItemLength}">
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
																<fmt:formatNumber value="${contBomAmountSum}" pattern="0.###"/>
															</c:when>
															<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
																0.00
															</c:when>
															<c:otherwise>
																<fmt:formatNumber value="${contBomAmountSum}" pattern="0.###"/>
															</c:otherwise>
														</c:choose>
													</td>
													<td>
														<c:choose>
															<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) == "13"}'>
																<fmt:formatNumber value="${contBomRateSum}" pattern="0.###"/>
															</c:when>
															<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
																0.00
															</c:when>
															<c:otherwise>
																<fmt:formatNumber value="${contBomRateSum}" pattern="0.###"/>
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
														<th>스크랩(%)</th>
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
													<th>스크랩(%)</th>
												</tr>
												</thead>
												<tbody>
												<c:set var="contItemLength2" value="${fn:length(cont.item)}" />
												<c:set var= "contBomRateSum2" value="0"/>
												<c:set var= "contBomAmountSum2" value="0"/>
												<c:forEach items="${cont.item}" var="item">
													<tr>
														<th>${strUtil:getHtmlBr(item.itemName)}</th>
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
																<fmt:formatNumber value="${contBomAmountSum2}" pattern="0.###"/>
															</c:when>
															<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
																0.00
															</c:when>
															<c:otherwise>
																<fmt:formatNumber value="${contBomAmountSum2}" pattern="0.###"/>
															</c:otherwise>
														</c:choose>
													</td>
													<td>
														<c:choose>
															<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) == "13"}'>
																<fmt:formatNumber value="${contBomRateSum2}" pattern="0.###"/>
															</c:when>
															<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
																0.00
															</c:when>
															<c:otherwise>
																<fmt:formatNumber value="${contBomRateSum2}" pattern="0.###"/>
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
				</c:when>
				<c:when test="${productDevDoc.productDocType == '1' or productDevDoc.productDocType == '2'}"></c:when>
				<c:otherwise></c:otherwise>
			</c:choose>
			<!-- 내용물 end -->
			<!-- 배합총합 -->
			<c:choose>
				<c:when test="${fn:trim(mfgProcessDoc.calcType) == '10'}">
					<div class="hold">
						<table width="100%"  class="intable lineside">
							<tr>
								<td width="50%" style=" border-right:2px solid #000; border-top-width :0px; vertical-align:top;">
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
											<th colspan="2" style="background-color :#f2f4f4; font-weight: normal; text-align: left; text-indent: 10px;">배합 총합</th>
											<td colspan="3" style=" border: none;">${sub.subProdBomRateTotal}</td>
										</tr>
										</thead>
									</table>
								</td>
								<td width="50%"  style=" border-right:2px solid #000; border-top-width :0px; vertical-align:top;"></td>
							</tr>
						</table>
					</div>
				</c:when>
			</c:choose>
			
			<!-- 배합총합end -->
			
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
		<c:choose>
			<c:when test="${productDevDoc.productDocType == '0'}">
				<!-- 표시사항배합비,제조방법,제품사진,제조방법 start-->
				<div class="hold">
					<div class="watermark"><img src="/resources/images/watermark.png"></div>
					<c:if test="${fn:trim(mfgProcessDoc.calcType) != '7'}">
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
											<col width="53%">
											<col width="12%">
											<col width="12%">
											<col width="12%">
											<col width="12%">
										</colgroup>
										<thead>
										<tr style="border: 1px solid #666">
											<th>재료명</th>
											<th>코드번호</th>
											<th>재료사양</th>
											<th>BOM</th>
											<th>스크랩(%)</th>
										</tr>
										</thead>
										<tbody>
										<c:forEach items="${mfgProcessDoc.pkg}" var="pkg">
											<tr>
												<th>${strUtil:getHtmlBr(pkg.itemName)}</th>
												<td>${pkg.itemCode}</td>
												<td>${pkg.bomAmount}(${pkg.unit})</td>
												<td>${pkg.bomRate}</td>
												<td>${pkg.scrap}</td>
											</tr>
											<c:set var= "bomRateSum" value="${bomRateSum + pkg.bomRate}"/>
										</c:forEach>
										<tr>
												<%--
                                                <th>합계</th>
                                                <td>&nbsp;</td>
                                                <td><fmt:formatNumber value="${bomRateSum}" pattern="0.00"/></td>
                                                 --%>
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
												<th>${strUtil:getHtmlBr(disp.matName)}</th>
												<td><fmt:formatNumber value="${disp.excRate}" pattern="0.####" minFractionDigits="4"/></td>
												<td><fmt:formatNumber value="${disp.incRate}" pattern="0.####" minFractionDigits="4"/></td>
											</tr>
											<c:set var= "excRateSum" value="${excRateSum + disp.excRate}"/>
											<c:set var= "incRateSum" value="${incRateSum + disp.incRate}"/>
										</c:forEach>
										<tr>
											<th>합계</th>
											<td id="excRateTotal"><fmt:formatNumber value="${excRateSum}" pattern="0.####" minFractionDigits="4"/></td>
											<td id="incRateSum"><fmt:formatNumber value="${incRateSum}" pattern="0.####" minFractionDigits="4"/></td>
										</tr>
										</tbody>
									</table>
								</td>
							</tr>
						</table>
					</c:if>
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
				
				<!-- 제품규격 start -->
				<div class="hold">
					<table class="intable04 linebottom" width="100%">
						<colgroup>
							<col width="16%">
							<col width="17%">
							<col width="16%"/>
							<col width="17%">
							<col width="16%">
							<col width="12%">
							<col width="6%">

						</colgroup>
						<tr>
							<td colspan="7" class="color05"> 제품규격 </td>
						</tr>
						
						<%-- 전체 /크기 --%>
						<tr>
							<th>전체</th>
							<td>크기</td>
							<td colspan="4">${strUtil:getHtmlBr(mfgProcessDoc.spec.size)}</td>
							<td>± ${mfgProcessDoc.spec.sizeErr} %</td>
						</tr>
						<%-- 성상 /토핑 --%>
						<tr>
							<th>성상</th>
							<td>토핑,착색,흐름성 </td>
							<td colspan="4">${mfgProcessDoc.spec.feature}</td>
							<td></td>
						</tr>
						
						<%-- 전체 / 내용물 --%>
						<c:if test="${mfgProcessDoc.spec.hasProduct or mfgProcessDoc.spec.hasContent}">
							<tr>
								<th rowspan="6">전체</th>
								<td>수분(%)</td>
								<td>${mfgProcessDoc.spec.productWater}</td>
								<th rowspan="6">내용물</th>
								<td>수분(%)</td>
								<td>${mfgProcessDoc.spec.contentWater}</td>
								<td>± ${mfgProcessDoc.spec.contentWaterErr}</td>
							</tr>
							<tr>
								<td>AW</td>
								<td>${mfgProcessDoc.spec.productAw}</td>
								<td>AW</td>
								<td>${mfgProcessDoc.spec.contentAw}</td>
								<td>± ${mfgProcessDoc.spec.contentAwErr}</td>
							</tr>
							<tr>
								<td>pH</td>
								<td>${mfgProcessDoc.spec.productPh}</td>
								<td>pH</td>
								<td>${mfgProcessDoc.spec.contentPh}</td>
								<td>± ${mfgProcessDoc.spec.contentPhErr}</td>
							</tr>
							<tr>
								<td>염도</td><!-- 명도 >> 염도 -->
								<td>${mfgProcessDoc.spec.productBrightness}</td> 
								<td>염도</td>
								<td>${mfgProcessDoc.spec.contentSalinity}</td>
								<td>± ${mfgProcessDoc.spec.contentSalinityErr}</td>
							</tr>
							<tr>
								<td>당도</td><!-- 색도 >> 당도  -->
								<td>${mfgProcessDoc.spec.productTone}</td>
								<td>당도</td>
								<td>${mfgProcessDoc.spec.contentBrix}</td>
								<td>± ${mfgProcessDoc.spec.contentBrixErr}</td>
							</tr>
							<tr>
								<td>점도</td><!-- Hardness >> 점도 -->
								<td>${mfgProcessDoc.spec.productHardness}</td>
								<td>Hardness</td><!-- 색도 >> Hardness  -->
								<td>${mfgProcessDoc.spec.contentTone}</td>
								<td>± ${mfgProcessDoc.spec.contentToneErr}</td>
							</tr>
						</c:if>
						
						<%-- 국수(면류) --%>
						<c:if test="${mfgProcessDoc.spec.hasNoodles}">
							<tr> 
								<th>전체</th>
								<td>기타 관리규격</td><!-- 산도 >> 기타관리 규격 -->
								<td colspan="4">${mfgProcessDoc.spec.noodlesAcidity}</td>
								<td></td>
							</tr>
							
							<tr>
								<th rowspan="2">국수(면류)<br /> * 주정침지제품에<br />한함.
								</th>
								<td>수분(%)</td>
								<td colspan="4">${mfgProcessDoc.spec.noodlesWater}</td>
								<td></td>
							</tr>
							<tr>
								<td>pH</td>
								<td colspan="4">${mfgProcessDoc.spec.noodlesPh}</td>
								<td></td>
							</tr>
						</c:if>
						
						<%-- 탈산소제 --%>
						<c:if test="${mfgProcessDoc.spec.deoxidizer != '' and mfgProcessDoc.spec.deoxidizer != null}">
							<tr>
								<th style="border-left: none;" colspan="2">탈산소제</th>
								<td colspan="4">${mfgProcessDoc.spec.deoxidizer}</td>
								<td></td>
							</tr>
						</c:if>
						
						<%-- 질소충전제품 --%>
						<c:if test="${mfgProcessDoc.spec.nitrogenous != '' and mfgProcessDoc.spec.nitrogenous != null}">
							<tr>
								<th style="border-left: none;" colspan="2">질소충전제품</th>
								<td colspan="4">${mfgProcessDoc.spec.nitrogenous}</td>
								<td></td>
							</tr>
						</c:if>
					</table>
				</div>
				<!-- 제품규격 close -->
							
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
							<td colspan="4" class="color05"> 관련정보 </td>
							<td colspan="2" class="color05"> 품목제조보고서 정보 </td>
						</tr>
						<c:choose>
							<c:when test="${fn:trim(mfgProcessDoc.calcType) == '3' or fn:trim(mfgProcessDoc.calcType) == '7'}">
								<tr>
									<th>생산라인</th>
									<td>${mfgProcessDoc.lineName}</td>
									<th>BOM 수율</th>
									<td>${mfgProcessDoc.bomRate} %</td>
									<th>품목제조보고서명</th>
									<td>
										<c:choose>
											<c:when test="${manufacturingNoData.manufacturingNo != '' && manufacturingNoData.manufacturingNo != null}">
												${manufacturingNoData.manufacturingName}
											</c:when>
											<c:otherwise>
												${mfgProcessDoc.docProdName}
											</c:otherwise>
										</c:choose>
									</td>
								</tr>
								<c:if test="${fn:trim(mfgProcessDoc.calcType) != '7' }">
									<tr>
										<th></th><!-- 배합중량 -->
										<td></td><!-- ${mfgProcessDoc.mixWeight} Kg (${mfgProcessDoc.bagAmout} 포) -->
										<th></th><!-- 분할중량총합계(g) -->
										<td></td><!-- ${mfgProcessDoc.totWeight} g -->
										<th>품목제조보고번호</th>
										<td>
											<c:choose>
												<c:when test="${manufacturingNoData.manufacturingNo != '' && manufacturingNoData.manufacturingNo != null}">
													${manufacturingNoData.licensingNo}-${manufacturingNoData.manufacturingNo}
												</c:when>
												<c:otherwise>
													${mfgProcessDoc.regNum}
												</c:otherwise>
											</c:choose>
										</td>
									</tr>
									<tr>
										<th></th><!-- 봉당 들이수 -->
										<td></td><!-- ${mfgProcessDoc.numBong} /ea -->
										<th>성상</th>
										<td>${mfgProcessDoc.ingredient}</td>
										<th>식품유형</th>
										<td>
											<c:choose>
												<c:when test="${manufacturingNoData.manufacturingNo != '' && manufacturingNoData.manufacturingNo != null}">
													${manufacturingNoData.productType1Name}
													<c:if test="${manufacturingNoData.productType2Name != '' && manufacturingNoData.productType2Name != null }">
														&gt; ${manufacturingNoData.productType2Name}
													</c:if>
													<c:if test="${manufacturingNoData.productType3Name != '' && manufacturingNoData.productType3Name != null }">
														&gt; ${manufacturingNoData.productType3Name}
													</c:if>
												</c:when>
												<c:otherwise>
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
												</c:otherwise>
											</c:choose>
										</td>
									</tr>
									<tr>
										<th></th><!-- 상자 들이수 -->
										<td></td><!-- ${mfgProcessDoc.numBox} -->
										<th></th><!-- 소성손실(g/%) -->
										<td></td><!-- ${mfgProcessDoc.loss} % -->
										<th>보관조건</th>
										<td>
											<c:choose>
												<c:when test="${manufacturingNoData.manufacturingNo != '' && manufacturingNoData.manufacturingNo != null}">
													<c:if test="${manufacturingNoData.keepConditionText == '' || manufacturingNoData.keepConditionText == null}">
														${manufacturingNoData.keepConditionName}
													</c:if>
													<c:if test="${manufacturingNoData.keepConditionText != '' && manufacturingNoData.keepConditionText != null}">
														${manufacturingNoData.keepConditionText}
													</c:if>
												</c:when>
												<c:otherwise>
													${mfgProcessDoc.keepCondition}
												</c:otherwise>
											</c:choose>
										</td>
									</tr>
									
									<tr>
										<th>완제중량</th>
										<td>
												${mfgProcessDoc.compWeight} ${mfgProcessDoc.compWeightUnit}
											<c:if test='${mfgProcessDoc.compWeightText != null && mfgProcessDoc.compWeightText != ""}'> (${mfgProcessDoc.compWeightText})</c:if>
										</td>
										<th>소비기한(현장)</th>
										<td>${mfgProcessDoc.distPeriSite}</td>
										<th>소비기한(등록서류)</th>
										<td>
											<c:choose>
												<c:when test="${manufacturingNoData.manufacturingNo != '' && manufacturingNoData.manufacturingNo != null}">
													${manufacturingNoData.sellDate1Text}&nbsp;${manufacturingNoData.sellDate2}&nbsp;${manufacturingNoData.sellDate3Text}
												</c:when>
												<c:otherwise>
													${mfgProcessDoc.distPeriDoc}
												</c:otherwise>
											</c:choose>
										</td>
									</tr>
									<tr>
										<th>관리중량</th>
										<td>${mfgProcessDoc.adminWeightFrom} ${mfgProcessDoc.adminWeightUnitFrom}
											~ ${mfgProcessDoc.adminWeightTo} ${mfgProcessDoc.adminWeightUnitTo}</td>
										<th>제조공정도 유형</th>
										<td>${mfgProcessDoc.lineProcessType}</td>
										<th>용도용법</th>
										<td>${mfgProcessDoc.usage}</td>
									</tr>
									<tr>
										<th>표기중량</th>
										<td>
												${mfgProcessDoc.dispWeight} ${mfgProcessDoc.dispWeightUnit}
											<c:if test='${mfgProcessDoc.dispWeightText != null && mfgProcessDoc.dispWeightText != ""}'> (${mfgProcessDoc.dispWeightText})</c:if>
										</td>
										<th>QNS 등록번호</th>
										<td>${mfgProcessDoc.qns}</td>
										<th>포장재질</th>
										<td>
											<c:choose>
												<c:when test="${manufacturingNoData.manufacturingNo != '' && manufacturingNoData.manufacturingNo != null}">
													${manufacturingNoData.packageUnitNames}
													<c:if test="${manufacturingNoData.packageEtc != '' || manufacturingNoData.packageEtc != null}">
														(${manufacturingNoData.packageEtc})
													</c:if>
												</c:when>
												<c:otherwise>
													${mfgProcessDoc.packMaterial}
												</c:otherwise>
											</c:choose>
										</td>
									</tr>
									<tr>
										<th rowspan="2">비고</th>
											<c:if test="${mfgProcessDoc.calcType == '3'}">
												<td rowspan="2" colspan="3" style="border-right:2px solid #000; text-align:left;">${strUtil:getHtmlBr(mfgProcessDoc.noteText)}</td>
											</c:if>
											<c:if test="${mfgProcessDoc.calcType != '3'}">
												<td rowspan="2" colspan="3">${mfgProcessDoc.note}</td>
											</c:if>
										<th>품목제조보고서 포장단위</th>
										<td>${mfgProcessDoc.packUnit}</td>	
									</tr>
									<tr>
										<th>어린이 기호식품 <br/>고열량 저영양 해당유무</th>
										<td>
											[<c:if test="${mfgProcessDoc.childHarm == '1'}">●</c:if>]예   [<c:if test="${mfgProcessDoc.childHarm == '2'}">●</c:if>]아니오   [<c:if test="${mfgProcessDoc.childHarm == '3'}">●</c:if>]해당 없음
										</td>
									</tr>
								</c:if>
							</c:when>
							
							<c:otherwise>
							<%-- 제조공정서 비고 --%>
								<tr>
									<th>생산라인</th>
									<td>${mfgProcessDoc.lineName}</td>
									<th>BOM 수율</th>
									<td>${mfgProcessDoc.bomRate} %</td>
									<th>품목제조보고서명</th>
									<td>
										<c:choose>
											<c:when test="${manufacturingNoData.manufacturingNo != '' && manufacturingNoData.manufacturingNo != null}">
												${manufacturingNoData.manufacturingName}
											</c:when>
											<c:otherwise>
												${mfgProcessDoc.docProdName}
											</c:otherwise>
										</c:choose>
									</td>
								</tr> 
								
								<tr>
									<th>배합중량</th>
									<td>${mfgProcessDoc.mixWeight} Kg (${mfgProcessDoc.bagAmout} 포)</td>
									<th>분할중량총합계(g)</th>
									<td>${mfgProcessDoc.totWeight} g</td>
									<th>품목제조보고번호</th>
									<td>
										<c:choose>
											<c:when test="${manufacturingNoData.manufacturingNo != '' && manufacturingNoData.manufacturingNo != null}">
												${manufacturingNoData.licensingNo}-${manufacturingNoData.manufacturingNo}
											</c:when>
											<c:otherwise>
												${mfgProcessDoc.regNum}
											</c:otherwise>
										</c:choose>
									</td>
								</tr>
								
								<tr>
									<th>봉당 들이수</th>
									<td>${mfgProcessDoc.numBong} /ea</td>
									<th>성상</th>
									<td>${mfgProcessDoc.ingredient}</td>
									<th>식품유형</th>
									<td>
										<c:choose>
											<c:when test="${manufacturingNoData.manufacturingNo != '' && manufacturingNoData.manufacturingNo != null}">
												${manufacturingNoData.productType1Name}
												<c:if test="${manufacturingNoData.productType2Name != '' && manufacturingNoData.productType2Name != null }">
													&gt; ${manufacturingNoData.productType2Name}
												</c:if>
												<c:if test="${manufacturingNoData.productType3Name != '' && manufacturingNoData.productType3Name != null }">
													&gt; ${manufacturingNoData.productType3Name}
												</c:if>
											</c:when>
											<c:otherwise>
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
											</c:otherwise>
										</c:choose>
									</td>
								</tr>
								
								<tr>
									<th>상자 들이수</th>
									<td>${mfgProcessDoc.numBox}</td>
									<th>소성손실(g/%)</th>
									<td>${mfgProcessDoc.loss} %</td>
									<th>보관조건</th>
									<td>
										<c:choose>
											<c:when test="${manufacturingNoData.manufacturingNo != '' && manufacturingNoData.manufacturingNo != null}">
												<c:if test="${manufacturingNoData.keepConditionText == '' || manufacturingNoData.keepConditionText == null}">
													${manufacturingNoData.keepConditionName}
												</c:if>
												<c:if test="${manufacturingNoData.keepConditionText != '' && manufacturingNoData.keepConditionText != null}">
													${manufacturingNoData.keepConditionText}
												</c:if>
											</c:when>
											<c:otherwise>
												${mfgProcessDoc.keepCondition}
											</c:otherwise>
										</c:choose>
									</td>
								</tr>
								
								<tr>
									<th>완제중량</th>
									<td>
											${mfgProcessDoc.compWeight} ${mfgProcessDoc.compWeightUnit}
										<c:if test='${mfgProcessDoc.compWeightText != null && mfgProcessDoc.compWeightText != ""}'> (${mfgProcessDoc.compWeightText})</c:if>
									</td>
									<th>소비기한(현장)</th>
									<td>${mfgProcessDoc.distPeriSite}</td>
									<th>소비기한(등록서류)</th>
									<td>
										<c:choose>
											<c:when test="${manufacturingNoData.manufacturingNo != '' && manufacturingNoData.manufacturingNo != null}">
												${manufacturingNoData.sellDate1Text}&nbsp;${manufacturingNoData.sellDate2}&nbsp;${manufacturingNoData.sellDate3Text}
											</c:when>
											<c:otherwise>
												${mfgProcessDoc.distPeriDoc}
											</c:otherwise>
										</c:choose>
									</td>
								</tr>
								
								<tr>
									<th>관리중량</th>
									<td>${mfgProcessDoc.adminWeightFrom} ${mfgProcessDoc.adminWeightUnitFrom}
										~ ${mfgProcessDoc.adminWeightTo} ${mfgProcessDoc.adminWeightUnitTo}</td>
									<th>제조공정도 유형</th>
									<td>${mfgProcessDoc.lineProcessType}</td>
									<th>용도용법</th>
									<td>${mfgProcessDoc.usage}</td>
								</tr>
								
								<tr>
									<th>표기중량</th>
									<td>
											${mfgProcessDoc.dispWeight} ${mfgProcessDoc.dispWeightUnit}
										<c:if test='${mfgProcessDoc.dispWeightText != null && mfgProcessDoc.dispWeightText != ""}'> (${mfgProcessDoc.dispWeightText})</c:if>
									</td>
									<th>QNS 등록번호</th>
									<td>${mfgProcessDoc.qns}</td>
									<th>포장재질</th>
									<td>
										<c:choose>
											<c:when test="${manufacturingNoData.manufacturingNo != '' && manufacturingNoData.manufacturingNo != null}">
												${manufacturingNoData.packageUnitNames}
												<c:if test="${manufacturingNoData.packageEtc != '' || manufacturingNoData.packageEtc != null}">
													(${manufacturingNoData.packageEtc})
												</c:if>
											</c:when>
											<c:otherwise>
												${mfgProcessDoc.packMaterial}
											</c:otherwise>
										</c:choose>
									</td>
								</tr>
								<tr>
									<th rowspan="2">비고</th>
									<td rowspan="2" colspan="3">${mfgProcessDoc.note}</td>
									<th>품목제조보고서 포장단위</th>
									<td>${mfgProcessDoc.packUnit}</td>	
								</tr>
								<tr>
									<th>어린이 기호식품 <br/>고열량 저영양 해당유무</th>
									<td>
										[<c:if test="${mfgProcessDoc.childHarm == '1'}">●</c:if>]예   [<c:if test="${mfgProcessDoc.childHarm == '2'}">●</c:if>]아니오   [<c:if test="${mfgProcessDoc.childHarm == '3'}">●</c:if>]해당 없음
									</td>
								</tr>
							</c:otherwise>
						</c:choose>
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
			</c:when>
			<c:when test="${productDevDoc.productDocType == '1' or productDevDoc.productDocType == '2'}">
				<div class="hold">
					<div class="watermark"><img src="/resources/images/watermark.png"></div>
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
							<td valign="top" style="border-right:2px solid #000; text-align:left; padding:10px;">
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
				<div class="hold">
					<table class="intable04 linebottom" width="100%">
						<colgroup>
							<col width="20%">
							<col>
						</colgroup>
						<tr>
							<th>보관조건</th><td style="text-align:left;">${strUtil:getHtmlBr(mfgProcessDoc.keepCondition)}</td>
						</tr>
						<tr>
							<th>소비기한</th><td style="text-align:left;">${strUtil:getHtmlBr(mfgProcessDoc.sellDate)}</td>
						</tr>
						<tr>
							<th>QNS 정보</th><td style="text-align:left;">${mfgProcessDoc.qns}</td>
						</tr>
						<tr>
							<th>기타설명</th><td style="text-align:left;">${strUtil:getHtmlBr(mfgProcessDoc.memo)}</td>
						</tr>
					</table>
				</div>
			</c:when>
			<c:otherwise></c:otherwise>
		</c:choose>

		<!-- 출력버튼 -->
		<table width="1046" cellpadding="0" cellspacing="0" class="print_hidden">
				<tr>
					<td align="right" height="50" valign="bottom">
					<%-- <c:if test='${userUtil:getUserGrade(pageContext.request) == "2" || userUtil:getUserGrade(pageContext.request) == "3" || userUtil:getUserGrade(pageContext.request) == "4" || userUtil:getUserGrade(pageContext.request) == "5"}'> --%>
					<c:if test='${userUtil:getUserGrade(pageContext.request) == "3" || userUtil:getIsAdmin(pageContext.request) == "Y" || userUtil:getUserId(pageContext.request) == productDevDoc.regUserId}'>
						<button type="button" class="btn_admin_green" onClick="excelDownloadCheck();"><img src="/resources/images/icon_excel.png" style="vertical-align:middle"> 엑셀 다운로드</button>
					</c:if>	
						<button type="button" class="btn_admin_nomal" onClick="printCheck();">프린트</button>
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
