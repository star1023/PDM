<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ taglib prefix="userUtil" uri="/WEB-INF/tld/userUtil.tld"%>

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
		<c:set var="productNamePrefix" value="[${productDevDoc.storeDivText}]" /> <!-- 23.10.11 점포명 공통코드화 -->
		<c:set var="titlePrefix" value="[BF] " />
		<c:set var="displayNone" value="display:none"/>
	</c:when>
	<c:when test="${productDevDoc.productDocType == '2'}">
		<c:set var="productDocTypeName" value="OEM " />
		<c:set var="displayNone" value="display:none"/>
	</c:when>
	<c:otherwise></c:otherwise>
</c:choose>

<title>제품개발문서>제조공정서</title>
<style type="text/css">
.readOnly {
	background-color: #ddd
}

/* 제조순서 번호css */
.imgbox {
    position: relative;
    text-align:left;
    padding: 10px;
  }
.imgNumbox{position: absolute; width:21.5px; height:18px; border: 0.5px solid #000; top:-21px; left:-0.5px; text-align:center; background-color: #fff;}
.imgDescriptbox{width: 90%;}

</style>
<script type="text/javascript">
	$(document).ready(function(){

	});
	var imgFilesSize = 9;
	var createBoxCnt = (imgFilesSize / 4) + (imgFilesSize %4 >0 ? 1: 0); //값을 4개당 1줄씩 표현하기 위한 줄 수
	
	console.log("::::"+createBoxCnt);
	
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
	
	function fileDownload(fmNo, tbKey, tbType){
		location.href = '/file/fileDownload?fmNo='+fmNo+'&tbKey='+tbKey+'&tbType='+tbType;
	}
	
	function goList(){
		location.href = '/dev/productDevDocList';
	}
	
	function goMfgDetail(){
		/* var docNo = '${productDevDoc.docNo}'
		var docVersion = '${productDevDoc.docVersion}'
		
		location.href='/dev/productDevDocDetail?docNo='+docNo+'&docVersion='+docVersion */
				
		var docNo = '${productDevDoc.docNo}';
		var docVersion = '${productDevDoc.docVersion}';
		
		var form = document.createElement('form');
		$('body').append(form);
		form.action = '/dev/productDevDocDetail';
		form.method = 'post';
		
		appendInput(form, 'docNo', docNo);
		appendInput(form, 'docVersion', docVersion);
		
		$(form).submit();
	}
	
	function editMfg(dNo, companyCode, plantCode){

		var form = document.createElement('form');
		$('body').append(form);
		$(form).hide();
		$(form).attr('action', '/dev/manufacturingProdcessCreateForStores');
		$(form).append('<input type="hidden" name="dNo" value="' + dNo + '">');
		$(form).append('<input type="hidden" name="docNo" value="${productDevDoc.docNo}">');
		$(form).append('<input type="hidden" name="docVersion" value="${productDevDoc.docVersion}">');
		$(form).append('<input type="hidden" name="companyCode" value="' + companyCode + '">');
		$(form).append('<input type="hidden" name="plantCode" value="' + plantCode + '">');
		$(form).append('<input type="hidden" name="calcType" value="40">');
		$(form).append('<input type="hidden" name="productDocType" value="${productDevDoc.productDocType}">');
		form.method = "post";
		$(form).submit();

	}
	
	function approvalSubmit(){
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
						location.reload();
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
	
	function approvalReject(){
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
							location.reload();
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
</script>

<div class="wrap_in" id="fixNextTag">
	<span class="path">${productDocTypeName}제조공정서&nbsp;&nbsp;<img
		src="/resources/images/icon_path.png" style="vertical-align: middle" />&nbsp;&nbsp;제품개발문서&nbsp;&nbsp;<img
		src="/resources/images/icon_path.png" style="vertical-align: middle" />&nbsp;&nbsp;<a
		href="#none">SPC 삼립연구소</a>
	</span>
	<section class="type01">
		<!-- 상세 페이지  start-->
		<h2 style="position: relative">
			<span class="title_s">Manufacturing Process Doc</span> <span class="title">${productDocTypeName}제조공정서 상세보기</span>
			
			<c:if test="${userUtil:getDeptCode(pageContext.request) !='dept7' &&  userUtil:getDeptCode(pageContext.request) !='dept8' && userUtil:getDeptCode(pageContext.request) !='dept9'}">
				<div class="top_btn_box">
					<ul>
						<li><button type="button" class="btn_circle_nomal" onClick="goMfgDetail()">&nbsp;</button></li>
						<c:if test="${productDevDoc.isLatest == 1 && productDevDoc.isClose == 0}">
							<c:if test="${mfgProcessDoc.state != '3' && mfgProcessDoc.state != '6'}">
								<c:choose>
									<c:when test="${userUtil:getIsAdmin(pageContext.request) == 'Y' || userUtil:getUserId(pageContext.request) == productDevDoc.regUserId}">
										<c:choose>
											<c:when test="${userUtil:getUserId(pageContext.request) == productDevDoc.regUserId && (mfgProcessDoc.state == '0' || mfgProcessDoc.state == '2' || mfgProcessDoc.state == '7')}">
												<li><button type="button" class="btn_circle_modifiy" onclick="editMfg('${mfgProcessDoc.getDNo()}', '${mfgProcessDoc.companyCode}', '${mfgProcessDoc.plantCode}')">&nbsp;</button></li>
											</c:when>
											<c:when test="${userUtil:getIsAdmin(pageContext.request) == 'Y'}">
												<li><button type="button" class="btn_circle_modifiy" onclick="editMfg('${mfgProcessDoc.getDNo()}', '${mfgProcessDoc.companyCode}', '${mfgProcessDoc.plantCode}')">&nbsp;</button></li>
											</c:when>
										</c:choose>
									</c:when>
									<c:otherwise>
										<c:if test="${userUtil:getUserGrade(pageContext.request) == '3' || userUtil:getUserGrade(pageContext.request) == '6'}">
											<li><button type="button" class="btn_circle_modifiy" onclick="editMfg('${mfgProcessDoc.getDNo()}', '${mfgProcessDoc.companyCode}', '${mfgProcessDoc.plantCode}')">&nbsp;</button></li>
										</c:if>
									</c:otherwise>
								</c:choose>
							</c:if>
						</c:if>
					</ul>
				</div>
			</c:if>
		</h2>
		<div class="group01 mt20">
			<!-- 복잡하니 잘따라오소-->
			<!-- 기준정보 start --------------------------------------------------------------------------------------------------------------------------------------------------------->
			<c:if test="${apprItemHeader.apprNo != null && apprItemHeader.apprNo != ''}">
				<div class="title5">
					<span class="txt">결재정보</span>
				</div>
				<div class="main_tbl">
					<table width="95%" cellpadding="0" cellspacing="0">
						<tr>
							<td valign="top">
								<div class="main_tbl">
									<table class="insert_proc01 tbl_app">
										<colgroup>
											<col width="13%" />
											<col width="50%" />
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
												<th style="border-left: none;">결재자</th>
												<td>
													<div class="file_box_pop5">
														<ul>
															<c:forEach items="${apprItemList}" var="item" varStatus="status">
																<input type="hidden" name="seq" id="seq" value="${item.seq }">
																<fmt:parseNumber var="seq" type="number" value="${item.seq}" />
																<li onMouseOver="location.href='#'">
																	<span>
																		<c:choose>
																			<c:when test="${apprItemHeader.type=='3' }">
																				<c:choose>
																					<c:when test="${item.seq eq '1' }">상신</c:when>
																					<c:when test="${item.seq eq '2' }">프린트결재</c:when>
																				</c:choose>
																			</c:when>
																			<c:otherwise>
																				<c:choose>
																					<c:when test="${apprItemHeader.tbType eq 'designRequestDoc'}">
																						<c:choose>
																							<c:when test="${item.seq eq '1' }">기안</c:when>
																							<c:otherwise>${item.seq-1}차 결재</c:otherwise>
																						</c:choose>
																					</c:when>
																					<c:when test="${apprItemHeader.tbType eq 'manufacturingProcessDoc' }">
																						<c:choose>
																							<c:when test="${item.seq eq '1' }">기안</c:when>
																							<c:otherwise>${item.seq-1}차 결재</c:otherwise>
																						</c:choose>
																					</c:when>
																					<c:when test="${apprItemHeader.tbType eq 'report' }">
																						<c:choose>
																							<c:when test="${item.seq eq '1' }">기안</c:when>
																							<c:when test="${item.seq eq '2' }">결재</c:when>
																						</c:choose>
																					</c:when>
																					<c:otherwise>
																						<c:choose>
																							<c:when test="${item.seq eq '1' }">기안</c:when>
																							<c:otherwise>결재</c:otherwise>
																						</c:choose>
																					</c:otherwise>
																				</c:choose>
																			</c:otherwise>
																		</c:choose>
																	</span> ${item.userName} 
																	<c:if test="${item.proxyYN eq 'Y' }">(대결:${item.proxyId})</c:if>
																	<strong>
																		${item.authName}/${item.deptCodeName}&nbsp;(</strong><i>${item.stateText}</i>
																	<strong> 
																		<c:choose>
																			<c:when test="${item.seq eq '1' }">:${item.regDate}</c:when>
																			<c:otherwise>
																				<c:if test="${item.modDate != '' && item.modDate != null}">:${item.modDate}</c:if>
																			</c:otherwise>
																		</c:choose> )
																	</strong>
																	<c:if test="${item.note !=null && item.note ne '' }">
																		<a href="#" onclick="viewNote('${item.apbNo}');">
																			의견 <img src="/resources/images/icon_app_mass.png" />
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
												<th style="border-left: none;">참조자 및 회람자</th>
												<td>
													<div class="file_box_pop4">
														<ul>
															<c:forEach items="${referenceList}" var="ref">
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
															<c:forEach items="${referenceList}" var="ref">
																<c:if test="${ref.type eq 'R'}">
																	<li><span> 참조</span> ${ref.userName} <strong> ${ref.authName}/${ref.deptCodeName}</strong></li>
																</c:if>
															</c:forEach>
														</ul>
													</div>
												</td>
											</tr>
											<c:if test="${apprItemHeader.lastState eq '0' }">
												<c:if test="${apprItemHeader.currentUserId eq userId || proxyCheck > 0}">
													<tr>
														<th style="border-left: none;">결재의견</th>
														<td colspan="3">
															<textarea style="width: 100%; height: 60px" name="note" id="note"></textarea>
														</td>
													</tr>
												</c:if>
											</c:if>
										</tbody>
									</table>
								</div>
								<div class="fr pt20 pb10" style="margin-bottom: 10px;">
									<c:if test="${apprItemHeader.lastState eq '0' }">
										<c:if test="${apprItemHeader.currentUserId eq userUtil:getUserId(pageContext.request) || proxyCheck > 0}">
											<button class="btn_con_search" style="border-color: #09F; color: #09F" onclick="approvalSubmit(); return false;" id="btn_submit">
												<img src="/resources/images/icon_s_approval.png"> 승인
											</button>
											<button class="btn_con_search" onclick="approvalReject(); return false;" id="btn_reject">
												<img src="/resources/images/icon_doc06.png"> 반려
											</button>
										</c:if>
									</c:if>
								</div>
							</td>
						</tr>
					</table>

				</div>
			</c:if>

			<div class="title5">
				<span class="txt">01. '${productNamePrefix}${productDevDoc.productName}' 기준정보</span>
			</div>
			<div class="main_tbl">
				<table class="insert_proc01">
					<colgroup>
						<col width="13%" />
						<col width="20%" />
						<col width="13%" />
						<col width="20%" />
						<col width="14%" />
						<col width="20%" />
					</colgroup>
					<tbody>
					<tr>
						<th style="border-left: none;">제품설명</th>
						<td colspan="5">
							${fn:replace(mfgProcessDoc.menuProcess, enter, br)}
						</td>
					</tr>
					<tr>
						<th style="border-left: none;">제품규격</th>
						<td colspan="5">
							${fn:replace(mfgProcessDoc.standard, enter, br)}
						</td>
					</tr>
					
					<tr>
						<th style="border-left: none;">보관조건</th>
						<td colspan="1">
							${fn:replace(mfgProcessDoc.keepCondition, enter, br)}
						</td>
						<th style="border-left: none;">완제중량</th>
						<td colspan="1">
							${fn:replace(mfgProcessDoc.compWeight, enter, br)}
						</td>
						<th style="border-left: none;">표기중량</th>
						<td colspan="1">
							${fn:replace(mfgProcessDoc.dispWeight, enter, br)}
						</td>
					</tr>
					
					<tr>
						<th style="border-left: none;">소비기한</th>
						<td colspan="1">
							${fn:replace(mfgProcessDoc.sellDate, enter, br)}
						</td>
						<th style="border-left: none;">관리중량</th>
						<td colspan="1">
							${fn:replace(mfgProcessDoc.adminWeight, enter, br)}
						</td>
						<th style="border-left: none;">용도용법</th>
						<td colspan="1">
							${fn:replace(mfgProcessDoc.usage, enter, br)}
						</td>
					</tr>
					<tr>
						<th style="border-left: none;">QNS 허들정보</th>
						<td colspan="5">
							<c:choose>
								<c:when test='${mfgProcessDoc.isQnsReviewTarget == "1"}'>
									<a href="javascript:openPopupQNSH('${mfgProcessDoc.qns}')">${mfgProcessDoc.qns}</a>
								</c:when>
								<c:when test='${mfgProcessDoc.isQnsReviewTarget == "0"}'>
									해당사항<br>없음
								</c:when>
								<c:otherwise>

								</c:otherwise>
							</c:choose>
						</td>
					</tr>
					<tr>
						<th style="border-left: none;">완제품 제조 시</br>주의사항</th>
						<td colspan="5">
							${fn:replace(mfgProcessDoc.memo, enter, br)}
						</td>
					</tr>
					</tbody>
				</table>
			</div>

			<!-- 기준정보 close --------------------------------------------------------------------------------------------------------------------------------------------------------->
			<!-- 원료 start --------------------------------------------------------------------------------------------------------------------------------------------------------->
			<div class="title5" style="padding-top: 50px;">
				<span class="txt">02. 원료</span>
			</div>
			<c:forEach items="${mfgProcessDoc.sub}" var="sub" varStatus="subStatus">
<%--				<div class="title mt${subStatus.index == 0 ? '5' : '10'}">--%>
<%--					<span class="txt">부속제품명: ${sub.subProdName}</span>--%>
<%--				</div>--%>
				<div id="subProdDiv_1" name="subProdDiv">
<%--					<div class="main_tbl">--%>
<%--						<table class="insert_proc01" style="border-right:1px solid #d1d1d1">--%>
<%--							<colgroup>--%>
<%--								<col width="13%" />--%>
<%--								<col width="20%" />--%>
<%--								<col width="13%" />--%>
<%--								<col width="20%" />--%>
<%--								<col width="14%" />--%>
<%--								<col width="20%" />--%>
<%--							</colgroup>--%>
<%--							<tbody>--%>
<%--							<tr>--%>
<%--								<th>분할 중량</th>--%>
<%--								<td>${sub.divWeight} g | ${sub.unitWeight} g ${sub.unitVolume} ea</td>--%>
<%--								<th>$분할중량 설명</th>--%>
<%--								<td>${sub.divWeightTxt}</td>--%>
<%--								<th>기준수량</th>--%>
<%--								<td>${sub.stdAmount}</td>--%>
<%--							</tr>--%>
<%--							</tbody>--%>
<%--						</table>--%>
<%--					</div>--%>
					<div>
						<c:forEach items="${sub.mix}" var="mix">
							<div class="tbl_in_title" style="border-top:1px solid #dddddd">▼ 배합비</div>
							<div class="tbl_in_con">
								<!-- 일반배합obj start-->
								<div class="nomal_mix">
									<div class="table_header01">
										<span class="title mt5"><img src="/resources/images/img_table_header.png">&nbsp;&nbsp;배합비명 : ${mix.baseName}</span>
									</div>
									<table class="tbl05">
										<colgroup>
											<col width="25%">
											<col width="25%">
											<col width="25%">
											<col width="25%">
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
										<c:forEach items="${mix.item}" var="item">
											<c:set var="wegihtTotal" value="${wegihtTotal + item.weight}"/>
											<Tr>
												<Td>${item.itemCode}</Td>
												<Td>${item.itemName}</Td>
												<Td>${item.weight}</Td>
												<Td>${item.ingradient}</Td>
											</Tr>
										</c:forEach>
										</tbody>
										<tfoot>
										<Tr>
											<Td>완제품 총 증량</Td>
											<Td>&nbsp;</Td>
											<Td><fmt:formatNumber value="${wegihtTotal}" pattern="0.###"/></Td>
											<Td>&nbsp;</Td>
										</Tr>
										</tfoot>
									</table>
								</div>
								<!-- 일반배합obj close-->
							</div>
						</c:forEach>
						<!-- 내용물 -->
						<c:forEach items="${sub.cont}" var="cont">
							<div class="tbl_in_title" style="border-top:1px solid #dddddd">▼ 내용물</div>
							<div class="tbl_in_con">
								<!-- 일반배합obj start-->
								<div class="nomal_mix">
									<div class="table_header01">
										<span class="title mt5"><img src="/resources/images/img_table_header.png">&nbsp;&nbsp;내용물명 : ${cont.baseName}</span>
									</div>
									<table class="tbl05">
										<colgroup>
											<col width="25%">
											<col width="25%">
											<col width="25%">
											<col width="25%">
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
										<c:forEach items="${cont.item}" var="item">
											<c:set var="wegihtTotal" value="${wegihtTotal + item.weight}"/>
											<Tr>
												<Td>${item.itemCode}</Td>
												<Td>${item.itemName}</Td>
												<Td>${item.weight}</Td>
												<Td>${item.ingradient}</Td>
											</Tr>
										</c:forEach>
										</tbody>
										<tfoot>
										<Tr>
											<Td>내용물 총 증량(g)</Td>
											<Td>&nbsp;</Td>
											<Td><fmt:formatNumber value="${wegihtTotal}" pattern="0.###"/></Td>
											<Td>&nbsp;</Td>
										</Tr>
										</tfoot>
									</table>
								</div>
								<!-- 일반배합obj close-->
							</div>
						</c:forEach>
					</div>
				</div>
			</c:forEach>
			<!-- 원료 close --------------------------------------------------------------------------------------------------------------------------------------------------------->
			<!-- 제조방법 start --------------------------------------------------------------------------------------------------------------------------------------------------------->
			
			<div class="title5" style="padding-top: 50px;">
				<span class="txt">03. 제조방법</span>
			</div>
			<div class="main_tbl">
				<table class="insert_proc01">
					<colgroup>
						<col width="25%" />
						<col width="75%" />
					</colgroup>
					<tbody>
					<tr>
						<th style="border-left: none;"> 구분 </th>
						<th> 제조방법 </th>
					<tr>
					<c:forEach items="${mfgProcessDoc.storeMethod}" var="storeMethod" varStatus="subStatus">
						<tr>
							<td style="border-left: none;">${fn:replace(storeMethod.methodName, enter, br)}</td>
							<td colspan="5">
								${fn:replace(storeMethod.methodExplain, enter, br)}
							</td>
						</tr>
					</c:forEach>
						
					</tbody>
				</table>
			</div>		
			<!-- 제조방법 end --------------------------------------------------------------------------------------------------------------------------------------------------------->
			
			<!-- 제조순서 start --------------------------------------------------------------------------------------------------------------------------------------------------------->
			
			<div class="title5" style="padding-top: 50px;">
				<span class="txt">04. 제조공정 순서</span>
			</div>
			<div class="fl-box panel-wrap" style="border-top:2px solid #4b5165;"></div>
			<br>
			
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
	        <c:forEach var="imageFileForStores" items="${imageFileForStores}" varStatus="vs">
	        	<!-- 첨부파일이 등록되어있을 경우 -->
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
			<div class="main_tbl">
				<table class="insert_proc01">
					<colgroup>
							<col width="10">
							<col width="22.5%">
							<col width="22.5%">
							<col width="22.5%">
							<col width="22.5%">
						</colgroup>
					<tr>
			        	<th rowspan="2" class="hftitle">사진/설명</th>
			        </tr>
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
						<td style="height: 120px">
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
			        	<th rowspan="2" class="hftitle">사진/설명</th>
			        </tr>
					<tr>
						<td style="vertical-align:top;">
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
			        	<th rowspan="2" class="hftitle">사진/설명</th>
			        </tr> 
					<tr>
						<td>
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
						<td>
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
						<td>
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
						<td>
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
			</div>
			
			<!-- 제조방법 end --------------------------------------------------------------------------------------------------------------------------------------------------------->
			
			<div class="btn_box_con5" style="padding-top: 50px;">
				<button class="btn_admin_gray" onClick="goMfgDetail()" style="width: 120px;">목록</button>
			</div>
			<hr class="con_mode" />
			<!-- 신규 추가 꼭 데려갈것 !-->
		</div>
	</section>
</div>
