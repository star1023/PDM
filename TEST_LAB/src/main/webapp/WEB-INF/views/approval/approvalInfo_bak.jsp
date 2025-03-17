<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page session="false" %>
<title>결재함</title>
<script type="text/javascript">
</script>

<input type="hidden" name="tbKey" id="tbKey" value="${apprItemHeader.tbKey }">
<input type="hidden" name="tbType" id="tbType" value="${apprItemHeader.tbType }">
<input type="hidden" name="currentUserid" id="currentUserid" value="${apprItemHeader.currentUserId }">
<input type="hidden" name="currentStep" id="currentStep" value="${apprItemHeader.currentStep }">
<input type="hidden" name="apprNo" id="apprNo" value="${apprItemHeader.apprNo }">
<input type="hidden" name="title" id="title" value="${apprItemHeader.title }">
<input type="hidden" name="regUserId" id="regUserId" value="${apprItemHeader.regUserId }">
<input type="hidden" name="tbTypeName" id="tbTypeName" value="${apprItemHeader.tbTypeName }">
<div class="wrap_in" id="fixNextTag">
	<span class="path">
		결재&nbsp;&nbsp;<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>
		&nbsp;&nbsp;<a href="#">삼립식품 연구개발시스템</a>
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
								<c:choose>
									<c:when test="${apprItemHeader.type != null && apprItemHeader.type == '3' }">
									${apprItemHeader.reason}
									</c:when>
									<c:otherwise>
									${apprItemHeader.comment}
									</c:otherwise>
								</c:choose>
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
													프린트 결재
												</c:when>
												<c:otherwise>
													<c:choose>
														<c:when test="${apprItemHeader.tbType eq 'designRequestDoc'}">
															<c:choose>
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
													</c:choose>
												</c:otherwise>
											</c:choose>	
											</span> 
											${apprItemHeader.userName}
											<c:if test="${item.proxyYN eq 'Y' }">
												(대결:${item.proxyId})
											</c:if> <strong> ${apprItemHeader.authName}/${apprItemHeader.deptCodeName}&nbsp;(</strong><i>${apprItemHeader.stateText}</i><strong> :${apprItemHeader.modDate} ) </strong> 
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
							<td>결재자 리스트 클릭시 결재의견을 확인할 수 있습니다.</td>
						</tr>
						<tr>
							<th style="border-left: none; ">참조자 및 회람자</th>
							<td>
								<div class="file_box_pop4">
									<ul>
										<li><span> 회람</span> 이성희 <strong> 부장/총무부</strong></li>
										<li><span> 회람</span> 이성희 <strong> 부장/총무부</strong></li>
									</ul>
								</div>
							</td>
							<td>
								<div class="file_box_pop4">
									<ul>
										<li><span> 참조</span> 이성희 <strong> 부장/총무부</strong></li>
										<li><span> 참조</span> 이성희 <strong> 부장/총무부</strong></li>
									</ul>
								</div>
							</td>
						</tr>
						<tr>
							<th style="border-left: none; ">결재의견</th>
							<td colspan="3">
								<textarea style="width:100%; height:60px"></textarea>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="fr pt20 pb10" style="margin-bottom:10px;">
				<button class="btn_con_search"style="border-color:#09F; color:#09F"><img src="/resources/images/icon_s_approval.png"> 승인</button>
				<button class="btn_con_search" ><img src="/resources/images/icon_doc06.png"> 반려</button>
			</div>
			<!-- 결재 close --------------------------------------------------------------------------------------------------------------------------------------------------------->
		</div>
	</section>	
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
	<table class="tbl01">
		<colgroup>
			<col width="50px">
			<col width="5%">
			<col width="5%">
			<col width="5%">
			<col width="10%">
			<col width="20%">
			<col width="15%">
			<col width="15%">
			<col width="10%">
			<col width="15%">
		</colgroup>
		<thead>
			<tr>
				<th>&nbsp;</th>
				<th>순서</th>
				<th>구분</th>
				<th>상태</th>
				<th>이름</th>
				<th>부서</th>
				<th>직책</th>
				<th>결재시간</th>
				<th>의견</th>
				<th>대리결재자</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach items = "${apprItemList}" var = "item" varStatus= "status">
				<input type="hidden" name="seq" id="seq" value="${item.seq }">
				<fmt:parseNumber var="seq" type="number" value="${item.seq}" />
				<tr>
					<td>&nbsp;</td>
					<td>${(fn:length(apprItemList) -(status.index))}</td>
					<td>
					<c:choose>
						<c:when test="${apprItemHeader.type=='3' }">
							프린트 결재
						</c:when>
						<c:otherwise>
							<c:choose>
									<c:when test="${apprItemHeader.tbType eq 'designRequestDoc' || headerInfo.tbType eq 'itemManufacturingProcessDoc' || headerInfo.tbType eq 'report' || headerInfo.tbType eq 'techTransfer' }">
										<c:choose>
											<c:when test="${item.seq eq '2' }">
												1차검토
											</c:when>
											<c:when test="${item.seq eq '3' }">
												2차검토
											</c:when>
											<c:when test="${item.seq eq '4' }">
												마케팅
											</c:when>
										</c:choose>
									</c:when>
									<c:when test="${apprItemHeader.tbType eq 'manufacturingProcessDoc' }">
										<c:choose>
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
								</c:choose>
							</c:otherwise>
						</c:choose>
					</td>
					<td>${item.stateText }</td>
					<td>${item.userName }</td>
					<td>${item.deptCodeName }</td>
					<td>${item.authName }</td>
					<td>${item.modDate }</td>
					<td>
						<c:if test="${item.note !=null && item.note ne '' }">
							<input type="button" class="btn_table_nomal" onclick="viewNote('${item.note}');" value="의견">
						</c:if>
					</td>
					<td>
						<c:if test="${item.proxyYN eq 'Y' }">
							${item.proxyId }
						</c:if>
					</td>
				</tr>				
			</c:forEach>
			<!--tr>
				<td>&nbsp;</td>
				<td>1</td>
				<td>기안</td>
				<td>기안</td>
				<td>${headerInfo.userName }</td>
				<td>${headerInfo.deptCodeName }</td>
				<td>${headerInfo.userAuthName }</td>
				<td>${headerInfo.regDate }</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			</tr-->
		</tbody>
		<!-- 결재 의견 -->
		<tbody>
			<tr>
				<td colspan="10" style="padding: 1px;"></td>
			</tr>
			<tr height="90">
				<th colspan="3" style="background-color:#f6efd3;">결재의견</th>
				<td colspan="7" style="text-align: left; vertical-align: top;">
	  				<div id="dispNote" style="margin: 5px 0 0 4px;"></div>
	  			</td>									
			</tr>
		</tbody>
	</table>
	
	
	<table class="tbl01" style="margin-top:10px;">
		<tr>
			<th style="width:100px; background-color:#f6efd3;">프린트사유</th>
			<td>
				${reason }
			</td>
		</tr>
	</table>
	<c:if test = "${apprItemHeader.currentUserId eq userId || proxyCheck > 0}">
		<table class="tbl01" style="margin-top:30px;">
			<tr>
				<th style="width:100px; background-color:#f6efd3;">결재의견</th>
				<td colspan="6" style="text-align: left; vertical-align: top;">
		  			<textarea name="note" id="note" style="width:90%;height:100px; padding: 0px; margin: 0px; margin-left:40px;"></textarea>
		  		</td>		
			</tr>
		</table>
	</c:if>
	
	<c:if test="${apprItemHeader.lastState eq '0' }">
		<c:if test = "${apprItemHeader.currentUserId eq userId || proxyCheck > 0}">
			<div class="btn_box_con" >
				<input type="button" value="승인" class="btn_admin_red" onclick="permitDoc('${apprItemHeader.apprNo}'); return false;"> 
				<input type="button" value="반려"  class="btn_admin_gray" onclick="returnDoc('${apprItemHeader.apprNo}'); return false;">
			</div>
		</c:if>
	</c:if>
	
</form>