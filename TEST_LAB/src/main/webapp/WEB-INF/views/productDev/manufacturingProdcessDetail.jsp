<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ taglib prefix="userUtil" uri="/WEB-INF/tld/userUtil.tld"%>
<title>제품개발문서>제조공정서</title>
<style type="text/css">
.readOnly {
	background-color: #ddd
}
</style>
<script type="text/javascript">
	$(document).ready(function(){
		var compWeight = '${mfgProcessDoc.compWeight}';
		if(compWeight.match(/[^\d*(\.?\d*)]/) != null){
			var value = compWeight.substr(0, compWeight.match(/[^\d*(\.?\d*)]/).index);
			$('input[name=compWeight]').val(value);
			
			if(compWeight.match(/\(/) == null){
				var unit = compWeight.substr(compWeight.match(/[^\d*(\.?\d*)]/).index)
				var text = '';
				
				$('select[name=compWeightUnit] option[value='+unit+']').prop('selected', true);
				$('select[name=compWeightUnit]').change();
				$('input[name=compWeightText]').val(text);
			} else {
				var unit = compWeight.substr(compWeight.match(/[^\d*(\.?\d*)]/).index, compWeight.match(/\(/).index-compWeight.match(/[^\d*(\.?\d*)]/).index)
				var text = compWeight.substr(compWeight.match(/\(/).index+1, compWeight.length-(compWeight.match(/\(/).index+1)-1);
				
				$('select[name=compWeightUnit] option[value='+unit+']').prop('selected', true);
				$('select[name=compWeightUnit]').change();
				$('input[name=compWeightText]').val(text);
			}
		} else {
			$('input[name=compWeight]').val(compWeight);
			var compWeightUnit = '${mfgProcessDoc.compWeightUnit}';
			if(compWeightUnit != null && compWeightUnit.length > 0 ){
				$('select[name=compWeightUnit] option[value='+compWeightUnit+']').prop('selected', true);
				$('select[name=compWeightUnit]').change();
			}
			$('input[name=compWeightText]').val('${mfgProcessDoc.compWeightText}');
		}
		
		var dispWeight = '${mfgProcessDoc.dispWeight}';
		if(dispWeight.match(/[^\d*(\.?\d*)]/) != null){
			var value = dispWeight.substr(0, dispWeight.match(/[^\d*(\.?\d*)]/).index);
			$('input[name=dispWeight]').val(value);
			
			if(dispWeight.match(/\(/) == null){
				var unit = dispWeight.substr(dispWeight.match(/[^\d*(\.?\d*)]/).index)
				var text = '';
				
				$('select[name=dispWeightUnit] option[value='+unit+']').prop('selected', true);
				$('select[name=dispWeightUnit]').change();
				$('input[name=dispWeightText]').val(text);
			} else {
				var unit = dispWeight.substr(dispWeight.match(/[^\d*(\.?\d*)]/).index, dispWeight.match(/\(/).index-dispWeight.match(/[^\d*(\.?\d*)]/).index)
				var text = dispWeight.substr(dispWeight.match(/\(/).index+1, dispWeight.length-(dispWeight.match(/\(/).index+1)-1);
				
				$('select[name=dispWeightUnit] option[value='+unit+']').prop('selected', true);
				$('select[name=dispWeightUnit]').change();
				$('input[name=dispWeightText]').val(text);
			}
		} else {
			$('input[name=dispWeight]').val(dispWeight);
			var dispWeightUnit = '${mfgProcessDoc.dispWeightUnit}';
			if(dispWeightUnit != null && dispWeightUnit.length > 0 ){
				$('select[name=dispWeightUnit] option[value='+dispWeightUnit+']').prop('selected', true);
				$('select[name=dispWeightUnit]').change();
			}
			$('input[name=dispWeightText]').val('${mfgProcessDoc.dispWeightText}');
		}
	});
	
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
		var URL = "/approval/countReviewDoc";
		var docNo = '${productDevDoc.docNo}';
		var docVersion = '${productDevDoc.docVersion}';
		var userGrade = '${userUtil:getUserGrade(pageContext.request)}';
		
		$.ajax({
			type:"POST",
			url:URL,
			data:{
				"docNo" : docNo,
				"docVersion" : docVersion				
			},
			dataType:"json",
			success:function(data) {
				
				if(data.count  > 0 && userGrade != '6' ) {
					alert("디자인의뢰서가 1차 검토중일 때는 수정할 수 없습니다.");
					return;
				} else {
					var form = document.createElement('form');
					$('body').append(form);
					$(form).hide();
					$(form).attr('action', '/dev/manufacturingProdcessEdit')
					$(form).append('<input type="hidden" name="dNo" value="'+dNo+'">');
					$(form).append('<input type="hidden" name="docNo" value="'+docNo+'">');
					$(form).append('<input type="hidden" name="docVersion" value="'+docVersion+'">');
					$(form).append('<input type="hidden" name="companyCode" value="'+companyCode+'">');
					$(form).append('<input type="hidden" name="plantCode" value="'+plantCode+'">');
					$(form).submit();
				}
			},
			error:function(request, status, errorThrown){
				alert("오류가 발생하였습니다. \n다시 처리해주세요.");
			}			
		});	
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
	<span class="path">제조공정서&nbsp;&nbsp;<img
		src="/resources/images/icon_path.png" style="vertical-align: middle" />&nbsp;&nbsp;제품개발문서&nbsp;&nbsp;<img
		src="/resources/images/icon_path.png" style="vertical-align: middle" />&nbsp;&nbsp;<a
		href="#none">SPC 삼립연구소</a>
	</span>
	<section class="type01">
		<!-- 상세 페이지  start-->
		<h2 style="position: relative">
			<span class="title_s">Manufacturing Process Doc</span> <span class="title">제조공정서 상세보기</span>
			
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

			<c:if test="${!(userUtil:getDeptCode(pageContext.request) == 'dept7' && userUtil:getUserGrade(pageContext.request) != '6') && userUtil:getDeptCode(pageContext.request) != 'dept8' && userUtil:getDeptCode(pageContext.request) != 'dept9'}">
				<c:if test="${mfgProcessDoc.calcType == '10'}"><c:set var="calcTypeText" value="일반제품"/></c:if>
				<c:if test="${mfgProcessDoc.calcType == '20'}"><c:set var="calcTypeText" value="기준수량 기준제품"/></c:if>
				<c:if test="${mfgProcessDoc.calcType == '30'}"><c:set var="calcTypeText" value="크림제품"/></c:if>	
				<div class="title5">
					<span class="txt">01. '${productDevDoc.productName}' 기준정보 (${calcTypeText})</span>
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
							<c:if test="${mfgProcessDoc.calcType == '10' || mfgProcessDoc.calcType == '20' || mfgProcessDoc.calcType == '30'}">
								<tr>
									<th style="border-left: none;">설명</th>
									<td colspan="5">${mfgProcessDoc.memo}</td>
								</tr>
								<tr>
									<th style="border-left: none;">공장</th>
									<td>${mfgProcessDoc.plantName}(${mfgProcessDoc.plantCode})</td>
									<th>생산라인</th>
									<td>${mfgProcessDoc.lineName}</td>
									<th>기준수량</th>
									<td>${mfgProcessDoc.stdAmount}</td>
								</tr>
								<tr>
									<th style="border-left: none;">대체BOM</th>
									<td>${mfgProcessDoc.stlal}</td>
									<th>배합중량</th>
									<td>${mfgProcessDoc.mixWeight} Kg (${mfgProcessDoc.bagAmout} 포)
									</td>
									<th>BOM수율</th>
									<td>${mfgProcessDoc.bomRate} %</td>
								</tr>
								<tr>
									<th style="border-left: none;">봉당 들이수</th>
									<td>${mfgProcessDoc.numBong} /ea</td>
									<th>상자 들이수</th>
									<td>${mfgProcessDoc.numBox}</td>
									<th>분할중량 총합계(g)</th>
									<td>${mfgProcessDoc.totWeight}</td>
								</tr>
								<tr>
									<th style="border-left: none;">소성손실(g/%)</th>
									<td>${mfgProcessDoc.loss} %</td>
									<th>품목제조보고서명</th>
									<td>${mfgProcessDoc.docProdName}</td>
									<th>제조공정도 유형</th>
									<td>${mfgProcessDoc.lineProcessType}</td>
								</tr>
							</c:if>
							<c:if test="${mfgProcessDoc.calcType == '3' || mfgProcessDoc.calcType == '7'}">
								<tr>
									<th style="border-left: none;">설명</th>
									<td colspan="5">${mfgProcessDoc.memo}</td>
								</tr>
								<tr>
									<th style="border-left: none;">회사</th>
									<td>밀다원</td>
									<th>공장</th>
									<td>${mfgProcessDoc.plantName}(${mfgProcessDoc.plantCode})</td>
									<th>생산라인</th>
									<td>${mfgProcessDoc.lineName}</td>
								</tr>
								<tr>
									<th style="border-left: none;">대체BOM</th>
									<td>${mfgProcessDoc.stlal}</td>
									<th>품목제조보고서명</th>
									<td>${mfgProcessDoc.docProdName}</td>
									<th>제조공정도 유형</th>
									<td>${mfgProcessDoc.lineProcessType}</td>
								</tr>
							</c:if>
						</tbody>
					</table>
				</div>
			</c:if>
			<!-- 기준정보 close --------------------------------------------------------------------------------------------------------------------------------------------------------->
			<!-- 원료 start --------------------------------------------------------------------------------------------------------------------------------------------------------->
			
			<c:if test="${!(userUtil:getDeptCode(pageContext.request) == 'dept9' && userUtil:getUserGrade(pageContext.request) != '13') && userUtil:getDeptCode(pageContext.request) != 'dept8'}">	
				<div class="title5" style="padding-top: 50px;">
					<span class="txt">02. 원료</span>
				</div>
				<c:forEach items="${mfgProcessDoc.sub}" var="sub" varStatus="subStatus">
					<div class="title mt${subStatus.index == 0 ? '5' : '10'}">
						<span class="txt">부속제품명: ${sub.subProdName}</span>
					</div>
					<div id="subProdDiv_1" name="subProdDiv">
						<div class="main_tbl">
							<table class="insert_proc01" style="border-right:1px solid #d1d1d1">
								<colgroup>
									<c:if test="${mfgProcessDoc.calcType != '10'}">
									<col width="13%" />
									<col width="20%" />
									<col width="13%" />
									<col width="20%" />
									<col width="14%" />
									<col width="20%" /> 
								</c:if>
								<c:if test="${mfgProcessDoc.calcType == '10'}">
									<col width="13%" />
									<col width="20%" />
									<col width="13%" />
									<col width="10%" />
									<col width="12%" />
									<col width="10%" />
									<col width="10%" />
									<col width="10%" />
								</c:if>
								</colgroup>
								<tbody>
									<tr>
										<th>분할 중량</th>
										<td>${sub.divWeight} g | ${sub.unitWeight} g ${sub.unitVolume} ea</td>
										<th>분할중량 설명</th>
										<td>${sub.divWeightTxt}</td>
										<c:if test="${mfgProcessDoc.calcType == '10'}">
											<th>배합 총합</th>
											<td>${sub.subProdBomRateTotal}</td>
										</c:if>
										<th>기준수량</th>
										<td>${sub.stdAmount}</td>
									</tr>
								</tbody>
							</table>
						</div>
						<div>
							<c:forEach items="${sub.mix}" var="mix">
								<div class="tbl_in_title">▼ 배합비</div>
								<div class="tbl_in_con">
									<!-- 일반배합obj start-->
									<div class="nomal_mix">
										<div class="table_header01">
											<span class="title mt5"><img src="/resources/images/img_table_header.png">&nbsp;&nbsp;배합비명 : ${mix.baseName}</span>
										</div>
										<table class="tbl05">
											<colgroup>
												<col width="140">
												<col />
												<col width="8%">
												<col width="8%">
												<col width="8%">
												<col width="8%">
												<col width="8%">
												<col width="8%">
												<col width="12%">
											</colgroup>
											<thead>
												<tr>
													<th>원료코드</th>
													<th>원료명</th>
													<th>배합%</th>
													<th>BOM수량</th>
													<th>단위</th>
													<th>중량g</th>
													<th>BOM항목</th>
													<th>스크랩</th>
													<th>저장위치</th>
												</tr>
											</thead>
											<tbody>
												<c:set var="bomRateTotal" value="0"/>
												<c:set var="bomAmountTotal" value="0"/>
												<c:set var="weightTotal" value="0"/>
												<c:forEach items="${mix.item}" var="item">
													<c:set var="bgColor" value="#fff" />
													<c:if test='${fn:indexOf(item.itemName, "[임시]") >= 0}'>
														<c:set var="bgColor" value="#ffdb8c" />
													</c:if>
													<c:choose>
														<c:when test="${mfgProcessDoc.calcType =='7'}">
															<c:if test="${!(fn:startsWith(item.itemCode, '4') || fn:startsWith(item.itemCode, '5'))}">
																<c:set var="bomRateTotal" value="${bomRateTotal + item.bomRate}"/>
																<c:set var="bomAmountTotal" value="${bomAmountTotal + item.bomAmount}"/>
															</c:if>
														</c:when>
														<c:when test="${mfgProcessDoc.calcType =='10' && mfgProcessDoc.companyCode == 'MD'}">
															<c:if test="${item.itemCode != '400023'}">
																<c:set var="bomRateTotal" value="${bomRateTotal + item.bomRate}"/>
																<c:set var="bomAmountTotal" value="${bomAmountTotal + item.bomAmount}"/>
															</c:if>
														</c:when>
														<c:otherwise>
															<c:set var="bomRateTotal" value="${bomRateTotal + item.bomRate}"/>
															<c:set var="bomAmountTotal" value="${bomAmountTotal + item.bomAmount}"/>
														</c:otherwise>
													</c:choose>
													<c:set var="weightTotal" value="${weightTotal + item.weight}"/>
													<Tr style="background-color: ${bgColor}">
														<Td>${item.itemCode}</Td>
														<Td>
															${strUtil:getHtmlBr(item.itemName)}
															<c:if test="${item.coo != null && item.coo != ''}">
																[${item.cooName}]
															</c:if>
														</Td>
														<Td>${item.bomAmount}</Td>
														
														<c:set var="tdColor" value=""/>
														<c:if test="${mfgProcessDoc.calcType =='7'}">
															<c:if test="${fn:startsWith(item.itemCode, '4') || fn:startsWith(item.itemCode, '5')}">
																<c:set var="tdColor" value="#ffe8d9"/>
															</c:if>
														</c:if>
														<c:if test="${mfgProcessDoc.calcType =='10' && mfgProcessDoc.companyCode == 'MD'}">
															<c:if test="${item.itemCode == '400023'}">
																<c:set var="tdColor" value="#ffe8d9"/>
															</c:if>
														</c:if>
														
														<Td style="background-color: ${tdColor};">${item.bomRate}</Td>
														<Td>${item.unit}</Td>
														<Td>${item.weight}</Td>
														<Td>${item.posnr}</Td>
														<Td>${item.scrap} %</Td>
														<Td>${item.storageCode}</Td>
													</Tr>
												</c:forEach>
											</tbody>
											<tfoot>
												<Tr>
													<Td colspan="2">합계</Td>
													<Td><fmt:formatNumber value="${bomAmountTotal}" pattern="0.###"/></Td>
													<Td><fmt:formatNumber value="${bomRateTotal}" pattern="0.###"/></Td>
													<Td>&nbsp;</Td>
													<Td>&nbsp;<%-- <fmt:formatNumber value="${weightTotal}" pattern="#.##"/> --%></Td>
													<Td>&nbsp;</Td>
													<Td>&nbsp;</Td>
													<Td>&nbsp;</Td>
												</Tr>
											</tfoot>
										</table>
									</div>
									<!-- 일반배합obj close-->
								</div>
							</c:forEach>
							<c:forEach items="${sub.cont}" var="cont">
								<div class="tbl_in_title">▼ 내용물</div>
								<div class="tbl_in_con">
									<!-- 내용물obj start-->
									<div class="nomal_mix">
										<div class="table_header02">
											<span class="title mt5">
												<img src="/resources/images/img_table_header.png">&nbsp;&nbsp;내용물명 : ${cont.baseName} / 분할중량 : ${cont.divWeight} g / ${cont.divWeightTxt}
											</span>
										</div>
										<table class="tbl05">
											<colgroup>
												<col width="140">
												<col />
												<col width="8%">
												<col width="8%">
												<col width="8%">
												<col width="8%">
												<col width="8%">
												<col width="8%">
												<col width="12%">
											</colgroup>
											<thead>
												<tr>
													<th>원료코드</th>
													<th>원료명</th>
													<th>배합%</th>
													<th>BOM수량</th>
													<th>단위</th>
													<th>중량g</th>
													<th>BOM항목</th>
													<th>스크랩</th>
													<th>저장위치</th>
												</tr>
											</thead>
											<tbody>
												
												<c:set var="bomRateTotal" value="0"/>
												<c:set var="bomAmountTotal" value="0"/>
												<c:set var="weightTotal" value="0"/>
												<c:forEach items="${cont.item}" var="item">
													<c:set var="bgColor" value="#fff" />
													<c:if test='${fn:indexOf(item.itemName, "[임시]") >= 0}'>
														<c:set var="bgColor" value="#ffdb8c" />
													</c:if>
													<c:set var="bomRateTotal" value="${bomRateTotal + item.bomRate}"/>
													<c:set var="bomAmountTotal" value="${bomAmountTotal + item.bomAmount}"/>
													<c:set var="weightTotal" value="${weightTotal + item.weight}"/>
													<Tr style="background-color: ${bgColor}"><!--  class="temp_color" -->
														<Td>${item.itemCode}</Td>
														<Td>${strUtil:getHtmlBr(item.itemName)}</Td>
														<Td>${item.bomAmount}</Td>
														<Td>${item.bomRate}</Td>
														<Td>${item.unit}</Td>
														<Td>${item.weight}</Td>
														<Td>${item.posnr}</Td>
														<Td>${item.scrap} %</Td>
														<Td>${item.storageCode}</Td>
													</Tr>
												</c:forEach>
											</tbody>
											<tfoot>
												<Tr>
													<Td colspan="2">합계</Td>
													<Td><fmt:formatNumber value="${bomAmountTotal}" pattern="0.###"/></Td>
													<Td><fmt:formatNumber value="${bomRateTotal}" pattern="0.###"/></Td>
													<Td>&nbsp;</Td>
													<Td>&nbsp;<%-- <fmt:formatNumber value="${weightTotal}" pattern="#.##"/> --%></Td>
													<Td>&nbsp;</Td>
													<Td>&nbsp;</Td>
													<Td>&nbsp;</Td>
												</Tr>
											</tfoot>
										</table>
									</div>
								</div>
							</c:forEach>
						</div>
					</div>
				</c:forEach>
				<!-- 원료 close --------------------------------------------------------------------------------------------------------------------------------------------------------->
			</c:if>
			<!-- 표시사항 배합비 start --------------------------------------------------------------------------------------------------------------------------------------------------------->
			<c:if test="${mfgProcessDoc.calcType != '7'}">
				<div class="title5" style="float: left; margin-top: 30px;">
					<span class="txt">03. 표시사항 배합비</span>
				</div>
				<table class="tbl05" style="border-top: 2px solid #4b5165;">
					<colgroup>
						<col width="20">
						<col width="30%">
						<col width="30%">
						<col />
					</colgroup>
					<thead>
						<tr>
							<th>원료명</th>
							<th>백분율</th>
							<th>급수포함</th>
						</tr>
					</thead>
					<tbody name="dispTbody">
						<c:forEach items="${mfgProcessDoc.disp}" var="disp">
						<c:set var="excRateTotal" value="${excRateTotal + disp.excRate}"/>
						<c:set var="incRateTotal" value="${incRateTotal + disp.incRate}"/>
							<Tr>
								<Td>${strUtil:getHtmlBr(disp.matName)}</Td>
								<Td>${disp.excRate}</Td>
								<Td>${disp.incRate}</Td>
							</Tr>
						</c:forEach>
					</tbody>
					<tfoot>
						<Tr>
							<Td>합계</Td>
							<Td><fmt:formatNumber value="${excRateTotal}" pattern="0.###"/> %</Td>
							<Td><fmt:formatNumber value="${incRateTotal}" pattern="0.###"/> %</Td>
						</Tr>
					</tfoot>
				</table>
			</c:if>
			<!-- 표시사항 배합비 close --------------------------------------------------------------------------------------------------------------------------------------------------------->
			<!-- 재료 start --------------------------------------------------------------------------------------------------------------------------------------------------------->
			<c:if test="${mfgProcessDoc.calcType != '7'}">
				<div class="title5" style="float: left; margin-top: 30px;">
					<span class="txt">04. 재료</span>
				</div>
				<table class="tbl05" style="border-top: 2px solid #4b5165;">
					<colgroup>
						<col width="140">
						<col />
						<col width="12%">
						<col width="8%">
						<col width="8%">
						<col width="8%">
						<col width="8%">
						<col width="8%">
						<col width="12%">
					</colgroup>
					<thead>
						<tr>
							<th>재료코드</th>
							<th>재료명</th>
							<th>재료사양</th>
							<th>단위</th>
							<th>BOM 수량</th>
							<th>BOM 단위</th>
							<th>BOM 항목</th>
							<th>스크랩</th>
							<th>저장위치</th>
						</tr>
					</thead>
					<tbody name="packageTbody">
						<c:forEach items="${mfgProcessDoc.pkg}" var="pkg">
							<c:set var="bgColor" value="#fff" />
							<c:if test='${fn:indexOf(pkg.itemName, "[임시]") >= 0}'>
								<c:set var="bgColor" value="#ffdb8c" />
							</c:if>
							<Tr style="background-color: ${bgColor}">
								<Td>${pkg.itemCode}</Td>
								<Td>${strUtil:getHtmlBr(pkg.itemName)}</Td>
								<Td>${pkg.bomAmount}</Td>
								<Td>${pkg.orgUnit}</Td>
								<Td>${pkg.bomRate}</Td>
								<Td>${pkg.unit}</Td>
								<Td>${pkg.posnr}</Td>
								<Td>${pkg.scrap} %</Td>
								<Td>${pkg.storageCode}</Td>
							</Tr>
						</c:forEach>
					</tbody>
				</table>
			</c:if>
			<!-- 재료 close --------------------------------------------------------------------------------------------------------------------------------------------------------->
			
			<c:if test="${!(userUtil:getDeptCode(pageContext.request) == 'dept7' && userUtil:getUserGrade(pageContext.request) != '6') && userUtil:getDeptCode(pageContext.request) != 'dept8' && userUtil:getDeptCode(pageContext.request) != 'dept9'}">	
				<!-- 관련정보 start --------------------------------------------------------------------------------------------------------------------------------------------------------->
				<c:if test="${mfgProcessDoc.calcType != '7'}">
					<div class="title5" style="float: left; margin-top: 30px;">
						<span class="txt">05. 관련정보</span>
					</div>
					<div class="main_tbl">
						<table class="insert_proc01">
							<colgroup>
								<col width="15%" />
								<col width="35%" />
								<col width="15%" />
								<col width="35%" />
							</colgroup>
							<tbody>
								<tr>
									<th style="border-left: none;">식품유형</th>
									<td colspan="3">
										${productDevDoc.productType1Text}
										<c:if test="${productDevDoc.productType2Text != '' && productDevDoc.productType2Text != null }">
											&gt; ${productDevDoc.productType2Text}
										</c:if>	
										<c:if test="${productDevDoc.productType3Text != '' && productDevDoc.productType3Text != null }">
											&gt; ${productDevDoc.productType3Text}
										</c:if>
										&lpar;
										${(productDevDoc.sterilizationText != '' && productDevDoc.sterilizationText != null)? productDevDoc.sterilizationText : '-'} 
										&sol;
										${(productDevDoc.etcDisplayText != '' && productDevDoc.etcDisplayText != null)? productDevDoc.etcDisplayText : '-'} 
										&rpar;
									</td>
								</tr>
								<tr>
									<th style="border-left: none;">완제중량</th>
									<td>${mfgProcessDoc.compWeight} ${mfgProcessDoc.compWeightUnit}</td>
									<th>관리중량</th>
									<td>
										${mfgProcessDoc.adminWeightFrom} ${mfgProcessDoc.adminWeightUnitFrom}
										 ~ ${mfgProcessDoc.adminWeightTo} ${mfgProcessDoc.adminWeightUnitTo}
									</td>
								</tr>
								<tr>
									<th style="border-left: none;">표기중량</th>
									<td>
										${mfgProcessDoc.dispWeight} ${mfgProcessDoc.dispWeightUnit}
									</td>
									<th><!-- 개별관리중량 --></th>
									<td><%-- ${mfgProcessDoc.distPeriSite} --%>
										<%-- <c:if test="${mfgProcessDoc.numBong  != '0'}">
											${mfgProcessDoc.adminWeightFrom/mfgProcessDoc.numBong} ${mfgProcessDoc.adminWeightUnitFrom}
										 	~ ${mfgProcessDoc.adminWeightTo/mfgProcessDoc.numBong} ${mfgProcessDoc.adminWeightUnitTo}
										</c:if> --%>
									</td>
								</tr>
								<tr>
									<th style="border-left: none;">품목보고번호</th>
									<td>
										<c:if test="${mfgProcessDoc.regGubun == 'N'}">신규</c:if>
										<c:if test="${mfgProcessDoc.regGubun == 'E'}">기존</c:if>
										<c:if test="${mfgProcessDoc.regGubun == 'C'}">변경</c:if>
										&nbsp;${mfgProcessDoc.regNum}
									</td>
									<th>소비기한</th>
									<td>
										 등록서류: ${mfgProcessDoc.distPeriDoc}&nbsp;&nbsp;현장: ${mfgProcessDoc.distPeriSite}
									</td>
								</tr>
								<tr>
									<th style="border-left: none;">성상</th>
									<td>${mfgProcessDoc.ingredient}</td>
									<th>보관조건</th>
									<td>${mfgProcessDoc.keepCondition}</td>
								</tr>
								<tr>
									<th style="border-left: none;">용도용법</th>
									<td colspan="3">${mfgProcessDoc.usage}</td>
								</tr>
								<tr>
									<th style="border-left: none;">포장재질</th>
									<td colspan="3">${mfgProcessDoc.packMaterial}</td>
								</tr>
								<tr>
									<th style="border-left: none;">품목제조보고서 포장단위</th>
									<td colspan="3">${mfgProcessDoc.packUnit}</td>
								</tr>
								<tr>
									<th style="border-left: none;">어린이 기호식품 고열량 저영양 해당 유무</th>
									<td colspan="3">
										<c:if test="${mfgProcessDoc.childHarm == '1'}">예</c:if>
										<c:if test="${mfgProcessDoc.childHarm == '2'}">아니오</c:if>
										<c:if test="${mfgProcessDoc.childHarm == '3'}">해당 없음</c:if>
									</td>
								</tr>
								<tr>
									<th style="border-left: none;">비고</th>
									<c:if test="${mfgProcessDoc.companyCode == 'MD'}">
										<td colspan="3">${fn:replace(mfgProcessDoc.noteText, enter, br)}</td>
									</c:if>
									<c:if test="${mfgProcessDoc.companyCode != 'MD'}">
										<td colspan="3">${mfgProcessDoc.note}</td>
									</c:if>
								</tr>
								<!-- S201109-00014 -->
								<tr>
									<th style="border-left: none;">QNS 허들정보</th>
									<td>
										<c:choose>
										 	<c:when test='${mfgProcessDoc.isQnsReviewTarget == "1"}'>
											 	<a href="javascript:openPopupQNSH('${mfgProcDoc.qns}')">${mfgProcDoc.qns}</a>
											</c:when>
											<c:when test='${mfgProcessDoc.isQnsReviewTarget == "0"}'>
											 	해당사항<br>없음
											</c:when>
											<c:otherwise>
												
											</c:otherwise>
										 </c:choose>
									</td>
									<th style="border-left: none;"></th>
									<td></td>
								</tr>
							</tbody>
						</table>
					</div>
				</c:if>
				<!-- 관련정보 close --------------------------------------------------------------------------------------------------------------------------------------------------------->
				<div class="fl" style="width: 100%">
					<div class="fl" style="width: 50%;">
						<!-- 제조방법 start --------------------------------------------------------------------------------------------------------------------------------------------------------->
						<div class="title5" style="float: left; margin-top: 30px;">
							<span class="txt">06. 제조방법</span>
						</div>
						<div class="main_tbl">
							<table class="insert_proc01">
								<tbody>
									<tr>
										<td style="border-left: none;">${fn:replace(mfgProcessDoc.menuProcess, enter, br)}</td>
									</tr>
								</tbody>
							</table>
						</div>
						<!-- 제조방법 close --------------------------------------------------------------------------------------------------------------------------------------------------------->
					</div>
					<div class="fl" style="width: 50%;">
						<!-- 제조규격 start --------------------------------------------------------------------------------------------------------------------------------------------------------->
						<div class="title5" style="float: left; margin-top: 30px;">
							<span class="txt">07. 제조규격</span>
						</div>
						<div class="main_tbl">
							<table class="insert_proc01">
								<tbody>
									<tr>
										<td style="border-left: none;">${fn:replace(mfgProcessDoc.standard, enter, br)}</td>
									</tr>
								</tbody>
							</table>
						</div>
						<!-- 제조규격 close --------------------------------------------------------------------------------------------------------------------------------------------------------->
					</div>
				</div>
				<!-- 생산소모품 start --------------------------------------------------------------------------------------------------------------------------------------------------------->
				<c:if test="${mfgProcessDoc.calcType != '7'}">
					<div class="title5" style="float: left; margin-top: 30px;">
						<span class="txt">08. 생산 소모품 (BOM 담당자만 입력)</span>
					</div>
					<table class="tbl01">
						<colgroup>
							<col width="140">
							<col />
							<col width="8%">
							<col width="8%">
							<col width="8%">
							<col width="8%">
							<col width="12%">
						</colgroup>
						<thead>
							<tr>
								<th>재료코드</th>
								<th>재료명</th>
								<th>BOM 수량</th>
								<th>BOM 단위</th>
								<th>BOM 항목</th>
								<th>스크랩</th>
								<th>저장위치</th>
							</tr>
						</thead>
						<tbody name="consumeTbody">
							<c:forEach items="${mfgProcessDoc.cons}" var="cons">
								<c:set var="bgColor" value="#fff" />
								<c:if test='${fn:indexOf(cons.itemName, "[임시]") >= 0}'>
									<c:set var="bgColor" value="#ffdb8c" />
								</c:if>
								<Tr style="background-color: ${bgColor}">
									<Td>${cons.itemCode}</Td>
									<Td>${strUtil:getHtmlBr(cons.itemName)}</Td>
									<Td>${cons.bomRate}</Td>
									<Td>${cons.unit}</Td>
									<Td>${cons.posnr}</Td>
									<Td>${cons.scrap} %</Td>
									<Td>${cons.storageCode}</Td>
								</Tr>
							</c:forEach>
						</tbody>
					</table>
				</c:if>
				<!-- 생산소모품 close --------------------------------------------------------------------------------------------------------------------------------------------------------->
				<!-- 제품규격 start --------------------------------------------------------------------------------------------------------------------------------------------------------->
				<div class="title5" style="float: left; margin-top: 30px;">
					<span class="txt">09. 제품규격</span>
				</div>
				<c:if test="${mfgProcessDoc.calcType == '10' || mfgProcessDoc.calcType == '20' || mfgProcessDoc.calcType == '30' || (mfgProcessDoc.calcType == '3' && mfgProcessDoc.companyCode == 'MD')}">
					<div class="main_tbl">
						<table class="insert_proc01">
							<colgroup>
								<col width="12%">
								<col width="12%">
								<col />
								<col width="12%">
								<col width="12%">
								<col width="12%">
								<col width="12%">
							</colgroup>
							<tbody>
								<c:if test="${mfgProcessDoc.spec.size == '' or mfgProcessDoc.spec.size == null}">
									<c:if test="${mfgProcessDoc.spec.feature == '' or mfgProcessDoc.spec.size == feature}">
										<c:if test="${!mfgProcessDoc.spec.hasProduct and !mfgProcessDoc.spec.hasContent}">
											<c:if test="${mfgProcessDoc.spec.deoxidizer == '' or mfgProcessDoc.spec.deoxidizer == null}">
												<c:if test="${mfgProcessDoc.spec.nitrogenous == '' or mfgProcessDoc.spec.nitrogenous == null}">
													<tr>
														<td><p style="text-align: center">입력된 제품규격 정보가 없습니다.</p></td>
													</tr>
												</c:if>
											</c:if>
										</c:if>
									</c:if>
								</c:if>
								<c:if test="${mfgProcessDoc.spec.size != '' and mfgProcessDoc.spec.size != null}">
									<tr>
										<th style="border-left: none;">전체</th>
										<td>크기 </td>
										<td colspan="4">${mfgProcessDoc.spec.size}</td>
										<td>± ${mfgProcessDoc.spec.sizeErr} %</td>
									</tr>
								</c:if>
								<c:if test="${mfgProcessDoc.spec.feature != '' and mfgProcessDoc.spec.size != feature}">
									<tr>
										<th style="border-left: none;" >성상</th>
										<td>토핑,착색,흐름성 </td>
										<td colspan="4">${mfgProcessDoc.spec.feature}</td>
										<td></td>
									</tr>
								</c:if>
								<c:if test="${mfgProcessDoc.spec.hasProduct or mfgProcessDoc.spec.hasContent}">
									<tr>
										<th style="border-left: none;" rowspan="6">전체</th>
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
								<c:if test="${mfgProcessDoc.spec.hasNoodles}">
									<tr> 
										<th style="border-left: none;" >전체</th>
										<td>기타 관리규격</td><!-- 산도 >> 기타관리 규격 -->
										<td colspan="4">${mfgProcessDoc.spec.noodlesAcidity}</td>
										<td></td>
									</tr>
									
									<tr>
										<th style="border-left: none;" rowspan="2">국수(면류)<br /> * 주정침지제품에<br />한함.
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
								
								<c:if test="${mfgProcessDoc.spec.deoxidizer != '' and mfgProcessDoc.spec.deoxidizer != null}">
									<tr>
										<th style="border-left: none;" colspan="2">탈산소제</th>
										<td colspan="4">${mfgProcessDoc.spec.deoxidizer}</td>
										<td></td>
									</tr>
								</c:if>
								<c:if test="${mfgProcessDoc.spec.nitrogenous != '' and mfgProcessDoc.spec.nitrogenous != null}">
									<tr>
										<th style="border-left: none;" colspan="2">질소충전제품</th>
										<td colspan="4">${mfgProcessDoc.spec.nitrogenous}</td>
										<td></td>
									</tr>
								</c:if>
							</tbody>
						</table>
					</div>
				</c:if>
				<c:if test="${mfgProcessDoc.calcType == '3' || mfgProcessDoc.calcType == '7'}">
					<div class="title5" style="float: left; margin-top: 30px;">
						<span class="txt">10. 제품규격(밀다원)</span>
					</div>
					<div class="main_tbl">
						<table class="insert_proc01">
							<colgroup>
								<col width="16%">
								<col width="18%">
								<col width="15%">
								<col width="18%">
								<col width="15%">
								<col width="18%">
							</colgroup>
							<tbody name="specMDTbody">
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
									<th></th>
									<td></td>
									<th></th>
									<td></td>
								</tr>
							</tbody>
						</table>
					</div>
				</c:if>
				<!-- 제품규격 close --------------------------------------------------------------------------------------------------------------------------------------------------------->
				<!-- 첨부파일 start --------------------------------------------------------------------------------------------------------------------------------------------------------->
				<%-- <div class="title5" style="float: left; margin-top: 30px;">
					<span class="txt">10. 첨부파일</span>
				</div>
				<div class="con_file fl" style="padding-bottom: 40px;">
					<ul>
						<li>
							<dt>1, 파일리스트</dt><dd>
								<ul>
									<c:forEach items="${mfgProcessDoc.file}" var="file">
										<li>
											<a href="javascript:fileDownload('${file.fmNo}','${file.tbKey}','${file.tbType}')">
												<c:if test="${file.isOld == 'Y'}">
													${strUtil:getOldFileName(file.fileName) }
												</c:if>
												<c:if test="${file.isOld != 'Y'}">
													${file.orgFileName}
												</c:if>
											</a> ( ${file.regDate} )
											<button class="btn_doc"><img src="/resources/images/icon_doc04.png"> 삭제</button>
										</li>
									</c:forEach>
								</ul>
							</dd>
						</li>
					</ul>
				</div> --%>
				<!-- 첨부파일 close --------------------------------------------------------------------------------------------------------------------------------------------------------->
			</c:if>
			<div class="btn_box_con5">
				<button class="btn_admin_gray" onClick="goMfgDetail()" style="width: 120px;">목록</button>
			</div>
			<hr class="con_mode" />
			<!-- 신규 추가 꼭 데려갈것 !-->
		</div>
	</section>
</div>
