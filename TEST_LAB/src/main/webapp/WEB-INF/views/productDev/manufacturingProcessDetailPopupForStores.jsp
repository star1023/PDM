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

/* 제조순서 번호css */
.imgbox {
    position: relative;
    text-align:left;
  }
.imgNumbox{position: absolute; width:21.5px; height:18px; border: 0.5px solid #000; top:-21px; left:-0.5px; text-align:center; background-color: #fff;}
.imgDescriptbox{width: 90%;}

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
		url: '/excel/mainTask3',
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
			<div class="watermark"><img src="/resources/images/watermark.png"></div>
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
					<td rowspan="2">
						<c:choose>
							<c:when test="${productDevDoc.productDocType == '1'}">
								<span class="big_font">${productNamePrefix}${productDevDoc.productName}</span> <!-- 24.01.18 점포용 제조공정서 경우 제품코드,공장코드 X -->
							</c:when>
							<c:otherwise>
								<span class="big_font">${productNamePrefix}${productDevDoc.productName}(${productDevDoc.productCode})/${mfgProcessDoc.plantName}</span>
							</c:otherwise>
						</c:choose>
					</td>
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
			<c:if test="${!(userUtil:getDeptCode(pageContext.request) == 'dept9' && userUtil:getUserGrade(pageContext.request) != '13') && userUtil:getDeptCode(pageContext.request) != 'dept8' }">
			<c:forEach items="${mfgProcessDoc.sub}" var="sub" varStatus="subStatus">					
			<table width="100%" class="intable linetop">
				<tr>
					<td class="color05">  제품명  : ${sub.subProdName}  </td>
				</tr>
			</table>
			<!-- 배합비 2개씩 반복 --->
			<div class="hold">
				<table width="100%"  class="intable lineside" >
					<colgroup>
						<col width="50%">
						<col width="50%">
					</colgroup>
					<tr >
						<td width="50%" style=" border-right:2px solid #000; vertical-align:top;" class="color06"> 제품사진 </td>
						<!-- 첫번째 요소만 사용 -->
						<td class="color06" > &nbsp; </td>
					</tr>
					<tr>
						<td valign="top" style="border-right:2px solid #000;">
							<c:choose>
								<c:when test="${productDevDoc.imageFileName != null and productDevDoc.imageFileName != ''}">
									<c:if test="${productDevDoc.isOldImage == 'Y'}">
										<img src="/oldFile/devDoc/${strUtil:getDevdocFileName(productDevDoc.oldFileName)}" style="width:100%; height:auto; max-height:200px;">
									</c:if>
									<c:if test="${productDevDoc.isOldImage != 'Y'}">
										<img src="/devDocImage/${strUtil:getDevdocFileName(productDevDoc.imageFileName)}" style="width:100%; height:auto; max-height:200px; object-fit:contain;">
									</c:if>
								</c:when>
								<c:otherwise>
									<img src="/resources/images/img_noimg.png" style="width:100%; height:auto; max-height:200px;">
								</c:otherwise>
							</c:choose>
						</td>
						<!-- 첫번째 요소만 사용 -->
						<td valign="top" style="border-right:2px solid #000">
							<table width="100%" class="intable02">
								<colgroup>
									<col width="20%">
									<col width="50%">
									<col width="15%">
									<col width="15%">
								</colgroup>
								<thead>
								<tr style="border: 1px solid #666">
									<th>&nbsp;</th>
									<th>&nbsp;</th>
									<th>&nbsp;</th>
									<th>&nbsp;</th>
								</tr>
								</thead>
								<tbody>
								
								<tr>
									<th>&nbsp;</th>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									
								</tr>
								
								<tr>
									<th>합계</th>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
								</tr>
								</tbody>
							</table>
						</td>	

					</tr>
				</table>
			</div>
		
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
								
									<c:when test="${productDevDoc.productDocType == '1' or productDevDoc.productDocType == '2'}">
										<table width="100%" class="intable02">
											<colgroup>
												<col width="20%">
												<col width="50%">
												<col width="15%">
												<col width="15%">
											</colgroup>
											<thead>
											<tr>
												<th>코드</th>
												<th>원료명</th>
												<th>중량(g)</th>
												<th>비고</th>
											</tr>
											</thead>
											<tbody>
											<c:set var="mixItemLength" value="${fn:length(mix.item)}" />
											<c:set var= "mixBomAmountSum" value="0"/>
											<c:forEach items="${mix.item}" var="item">
												<tr>
													<th>${item.itemCode}</th>
													<td>${strUtil:getHtmlBr(item.itemName)}</td>
													<td>${item.weight}</td>
													<td>${item.ingradient}</td>
													<c:set var="wegihtTotal" value="${wegihtTotal + item.weight}"/>
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
												<th>완제품 총 증량</th>
												<td>&nbsp;</td>
												<td><fmt:formatNumber value="${wegihtTotal}" pattern="0.###"/></td>
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
									<c:when test="${productDevDoc.productDocType == '1' or productDevDoc.productDocType == '2'}">
										<table width="100%" class="intable02">
											<colgroup>
												<col width="20%">
												<col width="50%">
												<col width="15%">
												<col width="15%">
											</colgroup>
											<thead>
											<tr>
												<th>코드</th>
												<th>원료명</th>
												<th>중량(g)</th>
												<th>비고</th>
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
												<th>완제품 총 증량</th>
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
								<c:when test="${productDevDoc.productDocType == '1' or productDevDoc.productDocType == '2'}">
									<td width="50%" style=" border-right:2px solid #000; vertical-align:top;">
										<!-- 배합비 타이틀 start--><!-- 우측 -->
										<table width="100%"  class="intable04" >
											<tr>
												<td class="color06">  배합비명  : ${mix.baseName}  </td>
											</tr>
										</table>
										<!-- 배합비 타이틀 close-->
										<table width="100%" class="intable02">
											<colgroup>
												<col width="20%">
												<col width="50%">
												<col width="15%">
												<col width="15%">
											</colgroup>
											<thead>
											<tr>
												<th>코드</th>
												<th>원료명</th>
												<th>중량(g)</th>
												<th>성분</th>
											</tr>
											</thead>
											<tbody>
											<c:set var="wegihtTotal" value="0"/>
											<c:set var="mixItemLength2" value="${fn:length(mix.item)}" />
											<c:forEach items="${mix.item}" var="item">
												<tr>
													<th>${item.itemCode}</th>
													<td>${strUtil:getHtmlBr(item.itemName)}</td>
													<td>${item.weight}</td>
													<td>${item.ingradient}</td>
													<c:set var="wegihtTotal" value="${wegihtTotal + item.weight}"/>
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
												<th>완제품 총 증량</th>
												<td>&nbsp;</td>
												<td><fmt:formatNumber value="${wegihtTotal}" pattern="0.###"/></td>
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
			<!-- 배합비 2개씩 반복 --->
			<div class="hold">
				<div class="watermark"><img src="/resources/images/watermark.png"></div>
				<table width="100%"  class="intable lineside" >
					<c:set var="contLength" value="${fn:length(sub.cont)}" />
					<c:forEach items="${sub.cont}" var="cont" varStatus="status">
					<c:set var="rigthItemLength" value="${fn:length(sub.cont[status.index+1].item)}" />
					<c:if test="${status.index %2 == 0 }">
					<tr>
					</c:if>
					<c:choose>
						<c:when test="${status.index %2 == 0 }">
							<td width="50%" style=" border-right:2px solid #000; vertical-align:top;">
								<!-- 배합비 타이틀 start-->
								<table width="100%"  class="intable04" >
									<tr>
										<td class="color06">  내용물명  : ${cont.baseName}  </td>
									</tr>
								</table>
								<!-- 배합비 타이틀 close-->
								<c:choose>
								
									<c:when test="${productDevDoc.productDocType == '1' or productDevDoc.productDocType == '2'}">
										<table width="100%" class="intable02">
											<colgroup>
												<col width="20%">
												<col width="50%">
												<col width="15%">
												<col width="15%">
											</colgroup>
											<thead>
											<tr>
												<th>코드</th>
												<th>원료명</th>
												<th>중량(g)</th>
												<th>비고</th>
											</tr>
											</thead>
											<tbody>
											<c:set var="contItemLength" value="${fn:length(cont.item)}" />
											<c:set var= "wegihtTotal" value="0"/>
											<c:forEach items="${cont.item}" var="item">
												<tr>
													<th>${item.itemCode}</th>
													<td>${strUtil:getHtmlBr(item.itemName)}</td>
													<td>${item.weight}</td>
													<td>${item.ingradient}</td>
													<c:set var="wegihtTotal" value="${wegihtTotal + item.weight}"/>
												</tr>
											</c:forEach>
											<c:if test="${contItemLength<rigthItemLength}">
												<c:forEach var="i" begin="1" end="${rigthItemLength - contItemLength}">
													<tr>
														<th></th>
														<td></td>
														<td></td>
														<td></td>
													</tr>
												</c:forEach>
											</c:if>
											<tr>
												<th>내용물 총증량(g)</th>
												<td>&nbsp;</td>
												<td><fmt:formatNumber value="${wegihtTotal}" pattern="0.###"/></td>
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
									<c:when test="${productDevDoc.productDocType == '1' or productDevDoc.productDocType == '2'}">
										<table width="100%" class="intable02">
											<colgroup>
												<col width="20%">
												<col width="50%">
												<col width="15%">
												<col width="15%">
											</colgroup>
											<thead>
											<tr>
												<th>코드</th>
												<th>원료명</th>
												<th>중량(g)</th>
												<th>비고</th>
											</tr>
											</thead>
											<tbody>
											<c:forEach var="i" begin="1" end="${contItemLength}">
												<tr>
													<th></th>
													<td></td>
													<td></td>
													<td></td>
												</tr>
											</c:forEach>
											<tr>
												<th>내용물 총증량(g)</th>
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
								<c:when test="${productDevDoc.productDocType == '1' or productDevDoc.productDocType == '2'}">
									<td width="50%" style=" border-right:2px solid #000; vertical-align:top;">
										<!-- 배합비 타이틀 start--><!-- 우측 -->
										<table width="100%"  class="intable04" >
											<tr>
												<td class="color06">  내용물명  : ${cont.baseName}  </td>
											</tr>
										</table>
										<!-- 배합비 타이틀 close-->
										<table width="100%" class="intable02">
											<colgroup>
												<col width="20%">
												<col width="50%">
												<col width="15%">
												<col width="15%">
											</colgroup>
											<thead>
											<tr>
												<th>코드</th>
												<th>원료명</th>
												<th>중량(g)</th>
												<th>비고</th>
											</tr>
											</thead>
											<tbody>
											<c:set var="wegihtTotal" value="0"/>
											<c:set var="contItemLength2" value="${fn:length(cont.item)}" />
											<c:forEach items="${cont.item}" var="item">
												<tr>
													<th>${item.itemCode}</th>
													<td>${strUtil:getHtmlBr(item.itemName)}</td>
													<td>${item.weight}</td>
													<td>${item.ingradient}</td>
													<c:set var="wegihtTotal" value="${wegihtTotal + item.weight}"/>
												</tr>
											</c:forEach>
											<c:if test="${contItemLength2<contItemLength}">
												<c:forEach var="i" begin="1" end="${contItemLength - contItemLength2}">
													<tr>
														<th></th>
														<td></td>
														<td></td>
														<td></td>
													</tr>
												</c:forEach>
											</c:if>
											<tr>
												<th>내용물 총증량(g)</th>
												<td>&nbsp;</td>
												<td><fmt:formatNumber value="${wegihtTotal}" pattern="0.###"/></td>
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
					<c:if test="${status.index == contLength-1 or status.index%2 == 1 }">
					</tr>
					</c:if>
					</c:forEach>
				</table>
			</div>
			<!-- 내용물 end -->
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
		<!-- 제조방법 -->
		
		<div class="hold">
			<div class="watermark"><img src="/resources/images/watermark.png"></div>
			<table width="100%" class="intable linetop">
				<tr>
					<td class="color05">  제조방법  </td>
				</tr>
			</table>
			<table width="100%"  class="intable lineside" >
				<c:set var="storeMethodLength" value="${fn:length(mfgProcessDoc.storeMethod)}" />			
				<c:forEach items="${mfgProcessDoc.storeMethod}" var="storeMethod" varStatus="status"> 
					<c:if test="${status.index %2 == 0 }">
					<tr>
					</c:if>
					
					<c:choose>
						<%-- 짝수번째일때  --%>
						<c:when test="${status.index %2 == 0 }">
							<td width="50%" style=" border-right:1px solid #000; vertical-align:top;">
								<table width="100%"  class="intable04">
									<tr>
										<td class="color05"> ${storeMethod.methodName} </td>
									</tr>
								</table>
								<table width="100%"  class="intable04">
									<tr>
										<td valign="top" style="text-align:left; padding:10px; border:none;">
											${strUtil:getHtmlBr(storeMethod.methodExplain)}
										</td>
									</tr>
								</table>								
							</td>
							<%-- 갯수가 홀수이면서  --%>
							<c:if test="${ storeMethodLength %2 != 0}">
							<c:choose>
								<%-- 마지막 요소일경우 빈 테이블 포함  --%>
       							 <c:when test="${status.last}">
       							 	<td width="50%" style="vertical-align:top;">
										<table width="100%"  class="intable04">
											<tr>
												<td class="color05"> &nbsp; </td>
											</tr>
										</table>
										<table width="100%"  class="intable02">
											<tr>
												<td valign="top" style="text-align:left; padding:10px; border:none;">
													&nbsp;
												</td>
											</tr>
										</table>
									</td>	
       							 </c:when>
       							 <c:otherwise>
       							 </c:otherwise>
       						</c:choose>		 
							</c:if>
						</c:when>
						<c:otherwise>
							<td width="50%" style="vertical-align:top;" >
								<table width="100%"  class="intable04">
									<tr>
										<td class="color05"> ${storeMethod.methodName} </td>
									</tr>
								</table>
								<table width="100%"  class="intable04">
									<tr>
										<td valign="top" style="text-align:left; padding:10px; border:none;">
											${strUtil:getHtmlBr(storeMethod.methodExplain)}
										</td>
									</tr>
								</table>
							</td>
						</c:otherwise>
					</c:choose>
					<c:if test="${status.index == storeMethodLength-1 or status.index%2 == 1 }">
					</tr>
					</c:if>
				</c:forEach>
			</table>
		</div>
		
		
		<%--제조순서 --%>
		<div class="hold">
			<table class="intable linetop" width="100%">
				<colgroup>
					<col width="75%">
					<col width="25%">
				</colgroup>
				<tr>
					<td class="color05">제조공정 순서</td>
					<td class="color05">완제품 제조시 주의사항</td>
				</tr>
				<tr>
					<td>
						<table width="100%" >
							<colgroup>
								<col width="25%">
								<col width="25%">
								<col width="25%">
								<col width="25%">
							</colgroup>
							
							<c:set var="img10" value="/resources/images/img_noimg.png"/>
					        <c:set var="img20" value="/resources/images/img_noimg.png"/>
					        <c:set var="img30" value="/resources/images/img_noimg.png"/>
					        <c:set var="img40" value="/resources/images/img_noimg.png"/>
					        <c:set var="img50" value="/resources/images/img_noimg.png"/>
					        <c:set var="img60" value="/resources/images/img_noimg.png"/>
					        <c:set var="img70" value="/resources/images/img_noimg.png"/>
					        <c:set var="img80" value="/resources/images/img_noimg.png"/>
					        <c:set var="img90" value="/resources/images/img_noimg.png"/>
					        <c:set var="img100" value="/resources/images/img_noimg.png"/>
					        <c:set var="img110" value="/resources/images/img_noimg.png"/>
					        <c:set var="img120" value="/resources/images/img_noimg.png"/>
							<c:forEach var="imageFileForStores" items="${imageFileForStores}" >
								<c:choose>
									<c:when test="${imageFileForStores.gubun == '10'}">
				                    	<c:set var="img10" value="/devDocImage/${imageFileForStores.webUrl}"/>
				                    	<c:set var="imgDescript10" value="${imageFileForStores.imgDescript }"/>
				               		</c:when>
				               		<c:when test="${imageFileForStores.gubun == '20'}">
				                    	<c:set var="img20" value="/devDocImage/${imageFileForStores.webUrl}"/>
				                    	<c:set var="imgDescript20" value="${imageFileForStores.imgDescript }"/>
				               		</c:when>
				               		<c:when test="${imageFileForStores.gubun == '30'}">
				                    	<c:set var="img30" value="/devDocImage/${imageFileForStores.webUrl}"/>
				                    	<c:set var="imgDescript30" value="${imageFileForStores.imgDescript }"/>
				               		</c:when>
				               		<c:when test="${imageFileForStores.gubun == '40'}">
				                    	<c:set var="img40" value="/devDocImage/${imageFileForStores.webUrl}"/>
				                    	<c:set var="imgDescript40" value="${imageFileForStores.imgDescript }"/>
				               		</c:when>
				               		<c:when test="${imageFileForStores.gubun == '50'}">
				                    	<c:set var="img50" value="/devDocImage/${imageFileForStores.webUrl}"/>
				                    	<c:set var="imgDescript50" value="${imageFileForStores.imgDescript }"/>
				               		</c:when>
				               		<c:when test="${imageFileForStores.gubun == '60'}">
				                    	<c:set var="img60" value="/devDocImage/${imageFileForStores.webUrl}"/>
				                    	<c:set var="imgDescript20" value="${imageFileForStores.imgDescript }"/>
				               		</c:when>
				               		<c:when test="${imageFileForStores.gubun == '70'}">
				                    	<c:set var="img70" value="/devDocImage/${imageFileForStores.webUrl}"/>
				                    	<c:set var="imgDescript70" value="${imageFileForStores.imgDescript }"/>
				               		</c:when>
				               		<c:when test="${imageFileForStores.gubun == '80'}">
				                    	<c:set var="img80" value="/devDocImage/${imageFileForStores.webUrl}"/>
				                    	<c:set var="imgDescript80" value="${imageFileForStores.imgDescript }"/>
				               		</c:when>
				               		<c:when test="${imageFileForStores.gubun == '90'}">
				                    	<c:set var="img90" value="/devDocImage/${imageFileForStores.webUrl}"/>
				                    	<c:set var="imgDescript90" value="${imageFileForStores.imgDescript }"/>
				               		</c:when>
				               		<c:when test="${imageFileForStores.gubun == '100'}">
				                    	<c:set var="img100" value="/devDocImage/${imageFileForStores.webUrl}"/>
				                    	<c:set var="imgDescript100" value="${imageFileForStores.imgDescript }"/>
				               		</c:when>
				               		<c:when test="${imageFileForStores.gubun == '110'}">
				                    	<c:set var="img110" value="/devDocImage/${imageFileForStores.webUrl}"/>
				                    	<c:set var="imgDescript110" value="${imageFileForStores.imgDescript }"/>
				               		</c:when>
				               		<c:when test="${imageFileForStores.gubun == '120'}">
				                    	<c:set var="img120" value="/devDocImage/${imageFileForStores.webUrl}"/>
				                    	<c:set var="imgDescript120" value="${imageFileForStores.imgDescript }"/>
				               		</c:when>
								</c:choose>
							</c:forEach>
							<c:set var="rowCnt" value="${fn:length(imageFileForStores)}"/>
							
							<tr>
								<td style="height: 120px; vertical-align:top;"> 
									<img src="${img10}" style="width:100%; height:160px; max-height:200px;" alt=""/>
									<div class="imgbox">
										<div class="imgNumbox">	
											1
										</div>
										<div class="imgDescriptbox">	
											 &nbsp;${imgDescript10 }
										</div>
									</div>
									
								</td>
								<td style="vertical-align:top;">
									<img src="${img20}" style="width:100%; height:160px; max-height:200px;" alt=""/>
									<div class="imgbox">
										<div class="imgNumbox">	
											2
										</div>
										<div class="imgDescriptbox">	
											 &nbsp;${imgDescript20 }
										</div>
									</div>
								</td>
								<td style="vertical-align:top;">
									<img src="${img30}" style="width:100%; height:160px; max-height:200px;" alt=""/>
									<div class="imgbox">
										<div class="imgNumbox">	
											3
										</div>
										<div class="imgDescriptbox">	
											 &nbsp;${imgDescript30 }
										</div>
									</div>	
								</td>
								<td style="vertical-align:top;">
									<img src="${img40}" style="width:100%; height:160px; max-height:200px;" alt=""/>
									<div class="imgbox">
										<div class="imgNumbox">	
											4
										</div>
										<div class="imgDescriptbox">	
										 	${strUtil:getHtmlBr(imgDescript40) }
										</div>
									</div>
								</td>
							</tr>
							<c:if test="${rowCnt > 4}" > 
							<tr>
								<td style="height: 120px; vertical-align:top;">
									<img src="${img50}" style="width:100%; height:160px; max-height:200px;" alt=""/>
									<div class="imgbox">
										<div class="imgNumbox">
											5
										</div>
										<div class="imgDescriptbox">	
										 	${imgDescript50 }
										</div>
									</div>	
								</td>
								<td style="vertical-align:top;">
									<img src="${img60}" style="width:100%; height:160px; max-height:200px;" alt=""/>
									<div class="imgbox">
										<div class="imgNumbox">
											6
										</div>
										<div class="imgDescriptbox">	
										 	&nbsp;${imgDescript60 }
										</div>
									</div>	
								</td>
								<td style="vertical-align:top;">
									<img src="${img70}" style="width:100%; height:160px; max-height:200px;" alt=""/>
									<div class="imgbox">
										<div class="imgNumbox">	
											7
										</div>
										<div class="imgDescriptbox">	
										 	&nbsp;${imgDescript70 }
										</div>
									</div>	
								</td>
								<td style="vertical-align:top;">
									<img src="${img80}" style="width:100%; height:160px; max-height:200px;" alt=""/>
									<div class="imgbox">
										<div class="imgNumbox">	
											8
										</div>
										<div class="imgDescriptbox">	
										 	&nbsp;${imgDescript80 }
										</div>
									</div>	
								</td>
							</tr>
							<c:if test="${rowCnt > 8}" > 
							<tr>
								<td style="height: 120px; vertical-align:top;">
									<img src="${img90}" style="width:100%; height:160px; max-height:200px;" alt=""/>
									<div class="imgbox">
										<div class="imgNumbox">	
											9
										</div>
										<div class="imgDescriptbox">	
										 	${imgDescript90 }
										</div>
									</div>	
								</td>
								<td style="vertical-align:top;">
									<img src="${img100}" style="width:100%; height:160px; max-height:200px;" alt=""/>
									<div class="imgbox">
										<div class="imgNumbox">	
											10
										</div>
										<div class="imgDescriptbox">	
										 	${imgDescript100 }
										</div>
									</div>	
								</td>
								<td style="vertical-align:top;">
									<img src="${img110}" style="width:100%; height:160px; max-height:200px;" alt=""/>
									<div class="imgbox">
										<div class="imgNumbox">	
											11
										</div>
										<div class="imgDescriptbox">	
										 	${imgDescript110 }
										</div>
									</div>	
								</td>
								<td style="vertical-align:top;">
									<img src="${img120}" style="width:100%; height:160px; max-height:200px;" alt=""/>
									<div class="imgbox">
										<div class="imgNumbox">	
											12
										</div>
										<div class="imgDescriptbox">	
										 	${imgDescript120 }
										</div>
									</div>	
								</td>
							</tr>
							</c:if>
							</c:if>
						</table>
					</td>
					<td valign="top" style="text-align:left; padding:10px;">
						${strUtil:getHtmlBr(mfgProcessDoc.memo)}
					</td>
				</tr>
			
			</table>
		</div>
		
		<c:choose>
			<c:when test="${productDevDoc.productDocType == '1' or productDevDoc.productDocType == '2'}">
				<div class="hold">
					<table width="100%" class="intable linetop">
						<tr>
							<td class="color05">  비고  </td>
						</tr>
					</table>
				
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
							<th>완제중량</th>
							<td>${strUtil:getHtmlBr(mfgProcessDoc.compWeight)}</td>
							<th>관리중량</th>
							<td>${strUtil:getHtmlBr(mfgProcessDoc.adminWeight)}</td>
							<th>표기중량</th>
							<td>${strUtil:getHtmlBr(mfgProcessDoc.dispWeight)}</td>
						</tr>
						<tr>
							<th>용도용법</th>
							<td>${strUtil:getHtmlBr(mfgProcessDoc.usage)}</td>
							<th>보관조건</th>
							<td>${strUtil:getHtmlBr(mfgProcessDoc.keepCondition)}</td>
							<th>소비기한</th>
							<td>${strUtil:getHtmlBr(mfgProcessDoc.sellDate)}</td>
						</tr>
						<tr>
							<th>제품설명</th>
							<td colspan="5" valign="top" style="text-align:left; padding:10px;">${strUtil:getHtmlBr(mfgProcessDoc.menuProcess)}</td>
						</tr>
						<tr>
							<th>제품규격</th>
							<td colspan="5" valign="top" style="text-align:left; padding:10px;">${strUtil:getHtmlBr(mfgProcessDoc.standard)}</td>
						</tr>
					</table>
				</div>
				
<!-- 				<div class="hold"> -->
<!-- 					<table class="intable04 linebottom" width="100%"> -->
<%-- 						<colgroup> --%>
<%-- 							<col width="20%"> --%>
<%-- 							<col> --%>
<%-- 						</colgroup> --%>
<!-- 						<tr> -->
<%-- 							<th>보관조건</th><td style="text-align:left;">${strUtil:getHtmlBr(mfgProcessDoc.keepCondition)}</td> --%>
<!-- 						</tr> -->
<!-- 						<tr> -->
<%-- 							<th>소비기한</th><td style="text-align:left;">${strUtil:getHtmlBr(mfgProcessDoc.sellDate)}</td> --%>
<!-- 						</tr> -->
<!-- 						<tr> -->
<%-- 							<th>QNS 정보</th><td style="text-align:left;">${mfgProcessDoc.qns}</td> --%>
<!-- 						</tr> -->
<!-- 						<tr> -->
<%-- 							<th>기타설명</th><td style="text-align:left;">${strUtil:getHtmlBr(mfgProcessDoc.memo)}</td> --%>
<!-- 						</tr> -->
<!-- 					</table> -->
<!-- 				</div> -->
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
