<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ taglib prefix="userUtil" uri="/WEB-INF/tld/userUtil.tld"%>
<%@ page session="false" %>
<title>디자인의뢰서</title>
<script type="text/javascript">
	$(document).ready(function() {
		var docNo = '${docNo}';
		var docVersion = '${docVersion}';
		
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
					//console.log(a,b,c)
					alert('영양성분타입 불러오기 실패[2]');
				},
				complete: function(){
					$('#nutritionDiv').show();
					$('#nutritionDiv').next().show();
				}
			})
		}
	});
	
	function goList() {
		location.href = "/dev/productDevDocList";
	}

	function viewNote(apbNo) {
		var URL = "../approval/viewNoteAjax";
		$.ajax({
			type : "POST",
			url : URL,
			data : {
				"apbNo" : apbNo
			},
			dataType : "json",
			success : function(data) {
				$("#viewNote").html(getTextareaHTML(data.note));
			},
			error : function(request, status, errorThrown) {
				alert("오류가 발생하였습니다.");
			}
		});
	}

	function getTextareaHTML(note) {
		return "</p><p>" + note.trim().replace(/\n\r?/g, "</p><p>") + "</p>";
	}

	function goMfgDetail() {
		var docNo = '${designReqDoc.docNo}';
		var docVersion = '${designReqDoc.docVersion}';

		var form = document.createElement('form');
		$('body').append(form);
		form.action = '/dev/productDevDocDetail';
		form.method = 'post';

		appendInput(form, 'docNo', docNo);
		appendInput(form, 'docVersion', docVersion);

		$(form).submit();
	}

	function goMfgDetail() {
		var docNo = '${designReqDoc.docNo}';
		var docVersion = '${designReqDoc.docVersion}';

		var form = document.createElement('form');
		$('body').append(form);
		form.action = '/dev/productDevDocDetail';
		form.method = 'post';

		appendInput(form, 'docNo', docNo);
		appendInput(form, 'docVersion', docVersion);

		$(form).submit();
	}

	function editDesignReqDoc(drNo) {
		var docNo = '${designReqDoc.docNo}';
		var docVersion = '${designReqDoc.docVersion}';
		
		var form = document.createElement('form');
		form.style.display = 'none';
		$('body').append(form);
		form.action = '/dev/designRequestDocEdit';
		form.method = 'post';

		appendInput(form, 'docNo', docNo);
		appendInput(form, 'docVersion', docVersion);
		appendInput(form, 'drNo', drNo);
		
		form.submit();
	}

	function deleteDesignReqDoc(drNo) {
		if (!confirm('디자인의뢰서[문서번호:' + drNo + ']를 삭제하시겠습니까?')) {
			return;
		}
		var docNo = '${designReqDoc.docNo}';
		var docVersion = '${designReqDoc.docVersion}';
		$.ajax({
			url : '/dev/deleteDesignRequestDoc',
			type : 'post',
			data : {
				drNo : drNo
			},
			success : function(data) {
				if (data == 'S') {
					alert('정상적으로 삭제되었습니다');
					readProductDevDoc(docNo, docVersion);
				} else {
					return alert('디자인의뢰서 삭제오류[1]')
				}
			},
			error : function(a, b, c) {
				//console.log(a,b,c)
				return alert('디자인의뢰서 삭제오류[2]')
			}
		})
	}

	function readProductDevDoc(docNo, docVersion) {
		var form = document.createElement('form');
		$('body').append(form);
		form.action = '/dev/productDevDocDetail';
		form.method = 'post';

		appendInput(form, 'docNo', docNo);
		appendInput(form, 'docVersion', docVersion);

		$(form).submit();
	}

	function excelDownload() {
		$('#form').attr('action', '/dev/designRequestExcelDownload').submit();
	}

	function approvalSubmit() {

		if (confirm("승인하시겠습니까?")) {
			var URL = "../approval/approvalSubmitAjax";
			$('#lab_loading').show();
			$.ajax({
				type : "POST",
				url : URL,
				data : {
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
				dataType : "json",
				success : function(data) {
					if (data.status == 'S') {
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
				error : function(request, status, errorThrown) {
					alert("결재 승인 중 오류가 발생하였습니다. \n다시 처리해주세요.");
				},
				complete : function() {
					$('#lab_loading').hide();
				}
			});
		}

	}

	function approvalReject() {
		if (!chkNull($("#note").val())) {
			alert("결재 의견을 입력해주세요.");
			$("#note").focus();
			return;
		} else {
			if (confirm("반려하시겠습니까?")) {
				var URL = "../approval/approvalRejectAjax";
				$('#lab_loading').show();
				$.ajax({
					type : "POST",
					url : URL,
					data : {
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
					dataType : "json",
					success : function(data) {
						if (data.status == 'S') {
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
					error : function(request, status, errorThrown) {
						alert("반려 처리중 오류가 발생하였습니다. \n다시 처리해주세요.");
					},
					complete : function() {
						$('#lab_loading').hide();
					}
				});
			}
		}
	}
</script>

<form name="form" id="form" method="post" action="">
<input type="hidden" name="tbKey" id="tbKey" value="${designReqDoc.drNo }">
	<input type="hidden" name="tbType" id="tbType" value="designRequestDoc">
	<input type="hidden" name="regUserId" id="regUserId" value="${designReqDoc.regUserId }">
</form>	
<div class="wrap_in" id="fixNextTag">
	<span class="path">보고서&nbsp;&nbsp;
		<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;
		<a href="#">삼립식품 연구개발시스템</a>
	</span>
	<section class="type01">
	<!-- 상세 페이지  start-->
		<h2 style="position:relative">
			<span class="title_s">Design Request Doc</span>
			<span class="title">
				디자인의뢰서
			</span>
			<div class="top_btn_box">
				<ul>
					<li><button type="button" class="btn_circle_nomal" onClick="goMfgDetail()">&nbsp;</button></li>
				</ul>
			</div>
		</h2>
		<div class="group01 mt20">
		<c:if test="${apprItemHeader.apprNo != null && apprItemHeader.apprNo != ''}">
			<div class="title5"><span class="txt">결재정보</span></div>
			<div class="main_tbl">
				<table width="95%" cellpadding="0" cellspacing="0">
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
										<c:if test="${apprItemHeader.lastState eq '0' }">
											<c:if test = "${apprItemHeader.currentUserId eq userId || proxyCheck > 0}">
												<tr>
													<th style="border-left: none; ">결재의견</th>
													<td colspan="3">
														<textarea style="width:100%; height:60px" name="note" id="note"></textarea>
													</td>
												</tr>
											</c:if>
										</c:if>
									</tbody>
								</table>
							</div>
							<div class="fr pt20 pb10" style="margin-bottom:10px;">
							<c:if test="${apprItemHeader.lastState eq '0' }">
								<c:if test = "${apprItemHeader.currentUserId eq userUtil:getUserId(pageContext.request) || proxyCheck > 0}">
									<button class="btn_con_search" style="border-color:#09F; color:#09F"  onclick="approvalSubmit(); return false;" id="btn_submit"><img src="/resources/images/icon_s_approval.png"> 승인</button>
									<button class="btn_con_search" onclick="approvalReject(); return false;" id="btn_reject"><img src="/resources/images/icon_doc06.png"> 반려</button>					
								</c:if>	
							</c:if>
							</div>
						</td>
					</tr>
				</table>
			</div>
			</c:if>
			<div class="title5"><span class="txt">01. 기본정보</span><!--span class="txt">01. 보고서명 : 영등포 점포 시장조사내역</span--></div>
			<div class="main_tbl">
				<table class="insert_proc01">
					<colgroup>
						<col width="10%"/>
						<col width="35%"/>
						<%-- <col width="15%"/> --%>
						<col width="auto"/>
					</colgroup>
					<tbody>
						<tr>
							<th style="border-left: none;">부서명</th>
							<td>${designReqDoc.department}</td>
							<!-- <th rowspan="3" style="border-left: none;">제목</th> -->
							<td rowspan="4" style="font-size: 15px; font-weight: bold">
								${designReqDoc.title}
							</td>
						</tr>
						<tr>
							<th style="border-left: none;">담당자</th>
							<td>${designReqDoc.director}</td>
						</tr>
						<tr>
							<th style="border-left: none;">의뢰일자</th>
							<td>${fn:substring(designReqDoc.reqDate, 0, 10)}</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="title5" style="float:left; margin-top:30px;"><span class="txt">02. 영양성분 표시</span></div>
			<div class="main_tbl">
				<table class="insert_proc01" style="border-bottom: 0px solid #fff;">
					<tbody>
						<tr style="border-bottom: 0px solid #fff;">
							<td style="border-left: 0px solid #fff;"></td>
						</tr>
					</tbody>
				</table>
				<div style="">
					<div id="nutritionDiv" style="maring: 0px 20px; width: 35%; display:none;"></div>
					<div class="box" style="width: 75%; padding-left: 15%; display:none;">
						<div class="left-box">
							<div class="table-nut" style="width: 300px; background-color: #fff;">
								<table id="nutrientTable" class="nutrientTable"></table>
							</div>
						</div>
						<div class="right-box">
							<div class="img-box">
								<img id="sodium" src="/resources/images/disp/sodium${designReqDoc.nutritionLabel.natriumLevel}.png" alt="graph" />
							</div>
							<div class="img-sodium"><fmt:formatNumber value="${designReqDoc.nutritionLabel.contNatrium}" type="number" groupingUsed="true"/>mg</div>
							<div class="img-text">나트륨 함량 비교 표시</div>
							<div class="img-category" >
								<span id="natriumTypeText">${designReqDoc.nutritionLabel.natriumTypeText}</span>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="title5" style="float:left; margin-top:30px;"><span class="txt">03. 내용</span></div>
			<div class="main_tbl">
				<table class="insert_proc01">
					<tbody>
						<tr>
							<td>
								${designReqDoc.content}
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="btn_box_con5">
				<button class="btn_admin_gray" onClick="goMfgDetail()"  style="width:120px;">목록</button>
			</div>
			<c:set var="editButton" value="display:none"/>
			<c:set var="deleteButton" value="display:none"/>
			<c:if test="${!(userUtil:getIsAdmin(pageContext.request) == 'Y' || userUtil:getUserGrade(pageContext.request) == '6' || userUtil:getUserId(pageContext.request) == designReqDoc.regUserId)}">
				<c:set var="editButton" value="display:none"/>
				<c:if test="${userUtil:getDeptCode(pageContext.request) == 'dept7' || userUtil:getDeptCode(pageContext.request) == 'dept8' || userUtil:getDeptCode(pageContext.request) == 'dept9'}">
				<c:set var="deleteButton" value="display:none"/>
				</c:if>
			</c:if>	
			<c:if test="${designReqDoc.state != '0' }">
				<c:set var="editButton" value="display:none"/>
				<c:set var="deleteButton" value="display:none"/>
				<c:if test="${designReqDoc.state == '1'  && apprItemHeader.currentStep == '3' && apprItemHeader.currentUserId ==  userUtil:getUserId(pageContext.request) }">
				<c:set var="editButton" value=""/>
				</c:if>
			</c:if>
			<c:if test="${(userUtil:getIsAdmin(pageContext.request) == 'Y' || userUtil:getUserGrade(pageContext.request) == '6' || userUtil:getUserId(pageContext.request) == designReqDoc.regUserId)}">
				<c:set var="editButton" value=""/>
				<c:set var="deleteButton" value=""/>
			</c:if>	
			<c:if test="${userUtil:getUserGrade(pageContext.request) == '6' }">
				<c:set var="editButton" value=""/>
				<c:set var="deleteButton" value=""/>
			</c:if>
			<c:if test="${isLatest == '0' }">
				<c:set var="editButton" value="display:none"/>
				<c:set var="deleteButton" value="display:none"/>
			</c:if>
			<div class="btn_box_con4">
			
			<!--<c:if test="${designReqDoc.state == 2 || userUtil:getUserId(pageContext.request) == designReqDoc.regUserId || userUtil:getIsAdmin(pageContext.request) == 'Y'}"></c:if>-->
			<button type="button" class="btn_admin_green" onclick="excelDownload();"><img src="/resources/images/icon_excel.png" style="vertical-align:middle"> 엑셀 다운로드</button>

			<button class="btn_admin_navi" onClick="editDesignReqDoc('${designReqDoc.drNo}')" style="${editButton}">수정</button>
			<c:if test="${designReqDoc.state != '2'}">
				<button class="btn_admin_gray" onClick="deleteDesignReqDoc('${designReqDoc.drNo}')" style="${editButton}")">삭제</button>			
			</c:if> 
			</div>				
			<hr class="con_mode"/><!-- 신규 추가 꼭 데려갈것 !-->	
		</div>
	</section>	
</div>