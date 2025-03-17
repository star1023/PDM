<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ page session="false" %>
<title>결재함</title>
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

function permitDoc( apprNo ) {
	alert("결재 승인 : "+apprNo);
	if( !chkNull($("#note").val()) ) {
		alert("결재 의견을 입력해주세요.");
		$("#note").focus();
		return;
	} else {
		
	}
}

function returnDoc( apprNo ) {
	alert("결재 반려 : "+apprNo);
	if( !chkNull($("#note").val()) ) {
		alert("결재 의견을 입력해주세요.");
		$("#note").focus();
		return;
	} else {
		
	}
}

function viewNote(note) {
	$("#note").html(note);
}

function goList() {
	document.location = "../approval/approvalList";
}
</script>

<div class="wrap_in" id="fixNextTag">
	<span class="path">
		결재&nbsp;&nbsp;<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>
		&nbsp;&nbsp;<a href="#">${strUtil:getSystemName()}</a>
	</span>
	<section class="type01">
	<!-- 상세 페이지  start-->
		<h2 style="position:relative">
			<span class="title_s">Approval</span>
			<span class="title">결재</span>
			<div  class="top_btn_box">
				<ul>
					<li>
					</li>
				</ul>
			</div>
		</h2>
		<div class="group01 mt20">
			<div class="title6">
				<span class="txt">
					${apprItemHeader.tbTypeName }
					<c:if test='${apprItemHeader.type != null && apprItemHeader.type == "3" }'>
					프린트
					</c:if>
					결재
				</span>
			</div>
			<form name="form" id="form" method="post" action="">
			<input type="hidden" name="tbKey" id="tbKey" value="${apprItemHeader.tbKey }">
			<input type="hidden" name="tbType" id="tbType" value="${apprItemHeader.tbType }">
			<input type="hidden" name="currentUserid" id="currentUserid" value="${apprItemHeader.currentUserId }">
			<input type="hidden" name="currentStep" id="currentStep" value="${apprItemHeader.currentStep }">
			<input type="hidden" name="apprNo" id="apprNo" value="${apprItemHeader.apprNo }">
			<input type="hidden" name="title" id="title" value="${apprItemHeader.title }">
			<input type="hidden" name="regUserId" id="regUserId" value="${apprItemHeader.regUserId }">
			<input type="hidden" name="tbTypeName" id="tbTypeName" value="${apprItemHeader.tbTypeName }">
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
																<c:when test="${item.seq eq '2' }">
																	1차검토
																</c:when>
																<c:when test="${item.seq eq '3' }">
																	2차검토
																</c:when>
																<c:when test="${item.seq eq '4' }">
																	3차검토
																</c:when>
																<c:when test="${item.seq eq '5' }">
																	마케팅
																</c:when>
															</c:choose>
														</c:when>
														<c:when test="${apprItemHeader.tbType eq 'manufacturingProcessDoc' }">
															<c:choose>
																<c:when test="${item.seq eq '1' }">
																	기안
																</c:when>
																<c:when test="${item.seq eq '2' }">
																	합의1
																</c:when>
																<c:when test="${item.seq eq '3' }">
																	합의2
																</c:when>
																<c:when test="${item.seq eq '4' }">
																	파트장
																</c:when>	
																<c:when test="${item.seq eq '5' }">
																	팀장
																</c:when>
																<c:when test="${item.seq eq '6' }">
																	연구소장
																</c:when>
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
												<a href="#" onclick="viewNote('${item.note}');">
													의견 <img src="/resources/images/icon_app_mass.png"/>
												</a>
											</c:if>
										</li>										
										</c:forEach>
									</ul>
								</div>
							</td>
							<td id="note">결재자 리스트 클릭시 결재의견을 확인할 수 있습니다.</td>
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
						<c:if test = "${apprItemHeader.currentUserId eq paramVO.userId || proxyCheck > 0}">
						<tr>
							<th style="border-left: none; ">결재의견</th>
							<td colspan="3">
								<textarea style="width:100%; height:60px" name="note" id="note"></textarea>
							</td>
						</tr>
						</c:if>
					</tbody>
				</table>
			</div>
			</form>
			<div class="btn_box_con5">
			<button class="btn_admin_gray" onClick="goList();"  style="width:120px;">목록</button>
			</div>				
			<div class="fr pt20 pb10" style="margin-bottom:10px;">
			<c:if test="${apprItemHeader.lastState eq '0' }">
				<c:if test = "${apprItemHeader.currentUserId eq paramVO.userId || proxyCheck > 0}">
					<button class="btn_con_search"style="border-color:#09F; color:#09F"  onclick="permitDoc('${apprItemHeader.apprNo}'); return false;"><img src="/resources/images/icon_s_approval.png"> 승인</button>
					<button class="btn_con_search" onclick="returnDoc('${apprItemHeader.apprNo}'); return false;"><img src="/resources/images/icon_doc06.png"> 반려</button>					
				</c:if>	
			</c:if>
			</div>
			<!-- 결재 close --------------------------------------------------------------------------------------------------------------------------------------------------------->
		</div>
	</section>	
</div>
