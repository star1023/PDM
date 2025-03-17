<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<title>표시사항배합비</title>

<script type="text/javascript" src="/resources/js/jquery.auto-complete.js"></script>
<script type="text/javascript">
	var initBody;
	var printTableId;
	function beforePrint() {
		
		if(confirm("백분율 출력은 '확인' 급수포함 출력은 '취소'를 선택해주세요.")){
			printTableId = 'printExcTableDiv'
		} else {
			printTableId = 'printIncTableDiv';
		}
		$('#printTableTd').empty();
		$('#printTableTd').append($('#'+printTableId).html());
		
		initBody = document.body.innerHTML;
		document.body.innerHTML = print_page.innerHTML;
		
	}

	function afterPrint() {
		document.body.innerHTML = initBody;
		
		$('#printTableTd').empty();
		$('#printTableTd').append($('#viewTableDiv').html());
	}

	function pageprint() {
		window.onbeforeprint = beforePrint;
		window.onafterprint = afterPrint;
		window.print();
	}
	
	function editDisp(){
		var dNo = '${dNo}';
		
		var url = '/dev/editDispPopup';
		
		var form = document.createElement('form');
		form.style.display = 'none';
		$('body').append(form);
		form.action = url;
		form.method = 'post';
		
		appendInput(form, 'dNo', dNo);
		
		$(form).submit();
	}
</script>
<!-- header start-->
<!-- 상단에 고정-->

<c:forEach items="${dispInfo}" var="disp" varStatus="dispStatus">
	<c:set var="excRateTotal" value="${disp.excRate + excRateTotal}"/>
	<c:set var="incRateTotal" value="${disp.incRate + incRateTotal}"/>
</c:forEach>
	
<div class="wrap_pop">
	<div class="wrap_in02">
		<div class="wrap_in">
			<h2 style="position: fixed;" class="print_hidden">
				<span class="title"><img src="/resources/images/bg_bs_box_fast02.png">&nbsp;&nbsp;배합비</span>
			</h2>
			<div class="top_btn_box" style="position: fixed;">
				<ul>
					<li><button class="btn_pop_close" onclick="self.close();"></button></li>
				</ul>
			</div>

			<!--여기서부터 프린트 -->
			<div id='print_page' style="padding: 10px 0 20px 20px;">
				<table width="1046" cellpadding="0" cellspacing="0"
					class="print_hidden">
					<tr>
						<td height="50"></td>
					</tr>
					<tr>
						<td align="right" height="50" valign="top">
							<button class="btn_admin_nomal" onClick="pageprint()">프린트</button>
							<button class="btn_admin_navi" onClick="editDisp()">수정</button>
							<button class="btn_admin_gray" onclick="self.close()">취소</button>
						</td>
					</tr>
				</table>
				<!-- 출력버튼 -->

				<!-- 실제 출력대상 start ------------------------------------------------------------------------------------------------------------------------------------------------>
				<div class="print_box">
					<!-- 상단 머리정보 start-->
					<div class="hold">
						<table width="100%" class="intable lineall mb5">
							<colgroup>
								<col width="50%">
								<col width="30%">
								<col width="10%">
								<col width="10%">
							</colgroup>
							<tr>
								<td class="color05">표시사항 배합비</td>
								<td rowspan="3">&nbsp;</td>
								<td class="color05">문서번호</td>
								<td>SHA-L-001</td>
							</tr>
							<tr>
								<td rowspan="2"><span class=" big_font" id="docProdName">${docProdName}</span></td>
								<td class="color05">제개정일</td>
								<%-- <td>${fn:split(modDate, ' ')[0]}<br>${fn:split(modDate, ' ')[1]}</td> --%>
								<td id="modDate"></td>
							</tr>
							<tr>
								<td class="color05">제정판수</td>
								<td id="docVersion"></td>
								<%-- <td>${docVersion}</td> --%>
							</tr>
						</table>
					</div>
					<!-- 상단 머리정보 close-->

					<!-- 유출금지 정보출력 close-->
					<!-- 표시사항배합비,제조방법,제품사진,제조방법 start-->
					<div class="hold">
						<div class="watermark">
							<img src="/resources/images/watermark.png">
						</div>
						<table class="intable lineall" width="100%">
							<tr>
								<td class="color05" style="border-right: 2px solid #000">표시사항배합비</td>
							</tr>
							<tr>
								<td id="printTableTd" valign="top" style="border-right: 2px solid #000">
									<table width="100%" class="intable02">
										<colgroup>
											<col width="50%">
											<col width="25%">
											<col width="25%">
										</colgroup>
										<thead>
											<tr>
												<th>원료명</th>
												<th>%</th>
												<th>급수포함</th>
												<!-- 
												<th>백분율</th>
												<th>급수포함</th>
												 -->
											</tr>
										</thead>
										<tbody>
											<c:forEach items="${dispInfo}" var="disp" varStatus="dispStatus">
												<tr>
													<th>${disp.etc == null ? disp.matName : disp.etc}</th>
													<th><fmt:formatNumber value="${disp.excRate}" pattern="0.####" minFractionDigits="4"/></th>
													<th><fmt:formatNumber value="${disp.incRate}" pattern="0.####" minFractionDigits="4"/></th>
													
													<c:choose>
														<c:when test="${type == 'exc'}">
														</c:when>
														<c:otherwise>
														</c:otherwise>
													</c:choose>
												</tr>	
											</c:forEach>
										</tbody>
										<tfoot>
											<tr>
												<th>합계</th>
												<td><fmt:formatNumber value="${excRateTotal}" pattern="0.####" minFractionDigits="4"/></td>
												<td><fmt:formatNumber value="${incRateTotal}" pattern="0.####" minFractionDigits="4"/></td>
												<c:choose>
													<c:when test="${type == 'exc'}">
													</c:when>
													<c:otherwise>
													</c:otherwise>
												</c:choose>
											</tr>
										</tfoot>
									</table>
								</td>
							</tr>
						</table>
					</div>
					<!-- 표시사항배합비 close-->
				</div>

				<!-- 실제 출력대상 close ------------------------------------------------------------------------------------------------------------------------------------------------>
				<!-- 출력버튼 -->
				<table width="1046" cellpadding="0" cellspacing="0"
					class="print_hidden">
					<tr>
						<td align="right" height="50" valign="bottom">
							<button class="btn_admin_nomal" onClick="pageprint()">프린트</button>
							<button class="btn_admin_navi" onClick="editDisp()">수정</button>
							<button class="btn_admin_gray" onclick="self.close()">취소</button>
						</td>
					</tr>
				</table>
				<!-- 여기까지 프린트 -->
			</div>
		</div>
	</div>
</div>


<div id="viewTableDiv" style="display:none">
	<table width="100%" class="intable02">
		<colgroup>
			<col width="50%">
			<col width="25%">
			<col width="25%">
		</colgroup>
		<thead>
			<tr>
				<th>원료명</th>
				<th>%</th>
				<th>급수포함</th>
				<!-- 
				<th>백분율</th>
				<th>급수포함</th>
				 -->
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${dispInfo}" var="disp" varStatus="dispStatus">
				<tr>
					<th>${disp.etc == null ? disp.matName : disp.etc}</th>
					<th><fmt:formatNumber value="${disp.excRate}" pattern="0.####" minFractionDigits="4"/></th>
					<th><fmt:formatNumber value="${disp.incRate}" pattern="0.####" minFractionDigits="4"/></th>
				</tr>	
			</c:forEach>
		</tbody>
		<tfoot>
			<tr>
				<th>합계</th>
				<td><fmt:formatNumber value="${excRateTotal}" pattern="0.####" minFractionDigits="4"/></td>
				<td><fmt:formatNumber value="${incRateTotal}" pattern="0.####" minFractionDigits="4"/></td>
			</tr>
		</tfoot>
	</table>
</div>
<div id="printExcTableDiv" style="display:none">
	<table width="100%" class="intable02">
		<colgroup>
			<col width="75%">
			<col width="25%">
		</colgroup>
		<thead>
			<tr>
				<th>원료명</th>
				<th>%</th>
				<!-- 
				<th>백분율</th>
				<th>급수포함</th>
				 -->
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${dispInfo}" var="disp" varStatus="dispStatus">
				<tr>
					<th>${disp.etc == null ? disp.matName : disp.etc}</th>
					<th><fmt:formatNumber value="${disp.excRate}" pattern="0.####" minFractionDigits="4"/></th>
				</tr>	
			</c:forEach>
		</tbody>
		<tfoot>
			<tr>
				<th>합계</th>
				<td><fmt:formatNumber value="${excRateTotal}" pattern="0.####" minFractionDigits="4"/></td>
			</tr>
		</tfoot>
	</table>
</div>
<div id="printIncTableDiv" style="display:none">
	<table width="100%" class="intable02">
		<colgroup>
			<col width="75%">
			<col width="25%">
		</colgroup>
		<thead>
			<tr>
				<th>원료명</th>
				<th>%</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${dispInfo}" var="disp" varStatus="dispStatus">
				<tr>
					<th>${disp.etc == null ? disp.matName : disp.etc}</th>
					<th><fmt:formatNumber value="${disp.incRate}" pattern="0.####" minFractionDigits="4"/></th>
				</tr>	
			</c:forEach>
		</tbody>
		<tfoot>
			<tr>
				<th>합계</th>
				<td><fmt:formatNumber value="${incRateTotal}" pattern="0.####" minFractionDigits="4"/></td>
			</tr>
		</tfoot>
	</table>
</div>
