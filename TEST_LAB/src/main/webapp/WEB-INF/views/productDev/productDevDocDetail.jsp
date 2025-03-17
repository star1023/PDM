<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="kr.co.aspn.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="userUtil" uri="/WEB-INF/tld/userUtil.tld"%>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ taglib prefix="dateUtil" uri="/WEB-INF/tld/dateUtil.tld"%>

<%
	String userGrade = UserUtil.getUserGrade(request);
	String userDept = UserUtil.getDeptCode(request);
	String userTeam = UserUtil.getTeamCode(request);
	String userId = UserUtil.getUserId(request);
	String isAdmin = UserUtil.getIsAdmin(request);

	Boolean doAdmin = false;
	//권한자: 관리자, 사용자 권한-BOM, 사용자 권한-연구원
	if( (isAdmin != null && "Y".equals(isAdmin)) || "3".equals(userGrade) || "4".equals(userGrade)){
		doAdmin = true;
	}
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
<!--점포용, OEM 제품명처리-->
<script type="text/javascript" src="../resources/js/productdevapproval.js"></script>
<script type="text/javascript" src="../resources/js/jquery.bpopup2.min.js"></script>

<style>
.badgeCnt {background-color: #ed554b; padding: 1px 5px 1px 5px; border-radius: 10px; font-size: 11px; color: #fff;}
</style>
<style>
.positionCenter{
	position: absolute;
	transform: translate(-50%, -45%);
}
</style>

<title>제품개발문서 상세</title>

<div class="wrap_in" id="fixNextTag">
	<span class="path"> 제품개발문서&nbsp;&nbsp;<img src="/resources/images/icon_path.png" style="vertical-align: middle" />
		&nbsp;&nbsp;<a href="#">SPC 삼립연구소</a>
	</span>
	<section class="type01">
		<!-- 상세 페이지  start-->
		<h2 style="position: relative">
			<span class="title_s">Product Design Doc</span> <span class="title">제품개발문서 상세</span>
			<div class="top_btn_box">
				<c:if test="${userUtil:getIsAdmin(pageContext.request) == 'Y' || userUtil:getUserId(pageContext.request) == productDevDoc.regUserId || userUtil:getUserGrade(pageContext.request) == '3'}">
					<ul>
						<c:if test="${productDevDoc.isLatest == 1 && productDevDoc.isClose == 0}">
							<li><button class="btn_circle_del" onClick="deleteDevDoc()">&nbsp;</button></li>
							<li><button class="btn_circle_modifiy" onClick="openDialog('dialog_modify')">&nbsp;</button></li>
							<li><button class="btn_circle_version" onClick="callVersionUpDialog()">&nbsp;</button></li>
						</c:if>
						<c:if test="${userUtil:getIsAdmin(pageContext.request) == 'Y' || userUtil:getUserGrade(pageContext.request) == '3'}">
							<c:if test="${productDevDoc.productDocType != '1' and productDevDoc.productDocType != '2'}">
								<li><button id="updateBOM" class="btn_circle_bom" onClick="updateBOM()">&nbsp;</button></li>
							</c:if>
						</c:if>
					</ul>
				</c:if>
				<c:if test="${userUtil:getUserGrade(pageContext.request) == '6'}">
					<ul>
						<c:if test="${productDevDoc.isLatest == 1 && productDevDoc.isClose == 0}">
							<li><button class="btn_circle_modifiy" onClick="openDialog('dialog_modify')">&nbsp;</button></li>
						</c:if>
					</ul>
				</c:if>
			</div>
		</h2>
		<div class="group01">
			<div class="title"></div>
			<div class="tab03">
				<ul>
					<!-- 선택됬을경우는 탭 클래스에 select를 넣어주세요 -->
					<!-- 내 제품설계서 같은경우는 change select 이렇게 change 그대로 두고 한칸 띄고 select 삽입 -->
					<c:forEach var="version" items="${docVersionList}" varStatus="status">
						<a href="javascript:changeVersion(${version})">
							<li class="${version == docVersion ? 'select': ''}">
								<c:if test="${status.index == 0}">[최신] </c:if>Version ${version}
							</li>
						</a>
					</c:forEach>
				</ul>
			</div>
			<div class="prodoc_title" style="margin-bottom: 30px;">
				<!-- <script>console.log('${productDevDoc.isOldFile}' ,'${productDevDoc.imageFileName}', '${productDevDoc.oldFileName}')</script> -->
				<div style="width: 100px; height: 100px; display: inline-block; vertical-align: top; padding-top: 15px" class="product_img">
					<c:if test="${productDevDoc.imageFileName != null and productDevDoc.imageFileName != ''}"> 
						<c:if test="${productDevDoc.isOldFile == 'Y'}">
							<img src="/oldFile/devDoc/${strUtil:getDevdocFileName(productDevDoc.oldFileName)}">
						</c:if>
						<c:if test="${productDevDoc.isOldFile != 'Y'}">
							<img src="/devDocImage/${strUtil:getDevdocFileName(productDevDoc.imageFileName)}">
						</c:if>
					</c:if>
					<c:if test="${productDevDoc.imageFileName == null or productDevDoc.imageFileName == ''}">
						<img src="/resources/images/img_product_default.png">
					</c:if>
				</div>
				<div style="display: inline-block; height: 80px; width: 85%; padding-top: 10px;">
					<c:if test="${productDevDoc.isNew == 'Y'}">
						<div style="float: right; border: 1px solid #d15b47; border-radius: 15px; padding: 0px 3px; background-color: #d15b47;"><span style="font-size: 12px; color: #fff; font-weight: 700;">신제품</span></div>
					</c:if>
					<%-- <span class="font17">제품명 : ${fn:escapeXml(productDevDoc.productName)}</span><span> --%>
					<span class="font17">제품명 : ${productNamePrefix}${strUtil:getHtmlBr(productDevDoc.productName)}</span><span>
						<!-- devDoc isClose 1: 제품중단, 2: 보류, 0: 진행중 -->
						<!-- manufacturingProcessDoc state 4: 제품출시, 1: 결재완료, 0: 진행중 -->
						<c:if test="${userUtil:getIsAdmin(pageContext.request) == 'Y' || userUtil:getUserId(pageContext.request) == productDevDoc.regUserId || userUtil:getUserGrade(pageContext.request) == '3'}">
							<c:if test="${productDevDoc.isLatest == 1}">
								<ul class="list_ul3">
									<c:if test="${productDevDoc.isClose == 0}">
										<li class="select"><a href="javascript:;">진행(생산)중</a>
										</li><li><a href="javascript:openStateDialog(2)">보류</a>
										</li><li><a href="javascript:openStateDialog(1)">제품중단</a></li>
									</c:if>
									<c:if test="${productDevDoc.isClose == '2'}">
										<li><a href="javascript:openStateDialog(0)">진행(생산)중</a>
										</li><li class="select"><a href="javascript:;">보류</a>
										</li><li><a href="javascript:javascript:openStateDialog(1)">제품중단</a></li>
									</c:if>
									<c:if test="${productDevDoc.isClose == '1'}">
										</li><li class="select"><a href="javascript:;">제품중단</a></li>
										<!-- </li><li class="select"><a href="javascript:changeDevDocCloseState(2)">제품중단</a></li> -->
									</c:if>
								</ul>
							</c:if>
						</c:if>
					</span>
					
					<c:if test="${productDevDoc.productType1 != null and productDevDoc.productType1 != ''}">
						<c:set var="productTypeText" value="${productDevDoc.productType1Text}" />
					</c:if>
					<c:if test="${productDevDoc.productType2 != null and productDevDoc.productType2 != ''}">
						<c:set var="productTypeText" value="${productTypeText}>${productDevDoc.productType2Text}" />
					</c:if>
					<c:if test="${productDevDoc.productType3 != null and productDevDoc.productType3 != ''}">
						<c:set var="productTypeText" value="${productTypeText}>${productDevDoc.productType3Text}" />
					</c:if>
					
					<input id="explanation_hidden" type="hidden" value="${productDevDoc.explanation}"> 
					<br><span class="font20">제품설명 : ${productDevDoc.explanation}</span>
					<br><span class="font18">제품유형 : [${productTypeText}] <strong>&nbsp;|&nbsp;</strong> 출시일 : ${fn:substring(productDevDoc.launchDate, 0, 10)}</span>
					<c:if test="${productDevDoc.productDocType == '0'}">
						<br><span class="font18">기타 : ${productDevDoc.sterilizationText} <strong>&nbsp;|&nbsp;</strong>${productDevDoc.etcDisplayText}</span>
						<br><span class="font18">제품번호 : ${productDevDoc.productCode} <strong>&nbsp;|&nbsp;</strong> 품목제조보고번호 : ${productDevDoc.manufacturingNo}</span>
					</c:if>
					<c:if test="${productDevDoc.productDocType == '2'}">
						<br><span class="font18">기타 : ${productDevDoc.sterilizationText} <strong>&nbsp;|&nbsp;</strong>${productDevDoc.etcDisplayText}</span>
						<br><span class="font18">제품번호 : ${productDevDoc.productCode}
					</c:if>
					<c:if test="${productDevDoc.docVersion > 1 }">
						<br><span class="font21">버전업사유 : ${fn:replace(productDevDoc.versionUpMemo, enter, br)}</span>
					</c:if>
					<c:if test="${fn:length(productDevDoc.closeMemo) > 1 }">
						<br><span class="font21" style="color: red">보류/중단사유 : ${fn:replace(productDevDoc.closeMemo, enter, br)}</span>
					</c:if>
				</div>
			</div>
			
			<c:if test="${userUtil:getIsAdmin(pageContext.request) == 'Y' || userUtil:getUserId(pageContext.request) == productDevDoc.regUserId}">
				<c:if test="${productDevDoc.isLatest == 1 && productDevDoc.isClose == 0}">
					<div class="fr pt10">
						<c:if test="${productDevDoc.productDocType != '1' and productDevDoc.productDocType != '2'}">
							<button class="btn_con_search" onClick="openManuNo()">품목제조보고서 생성</button>
							<button class="btn_con_search" onClick="openDialog('dialog_set_qnsh')"> QNSH 정보 저장</button>
						</c:if>
						<button class="btn_con_search" onClick="callCreateDialog()"><img src="/resources/images/icon_s_write.png" />${productDocTypeName}제조공정서 생성</button>
						<button class="btn_con_search" onClick="openApprovalDialog('approval_manu'); return false;"><img src="/resources/images/icon_s_approval.png" />${productDocTypeName}제조공정서 결재상신</button>
					</div>
				</c:if>
			</c:if>
			<div class="title2">
				<span class="txt">${productDocTypeName}제조공정서</span>
			</div>
			<div class="main_tbl" style="padding-bottom: 40px;">
				<table class="tbl04" id="mfgTable">
					<colgroup>
						<c:choose>
							<c:when test="${productDevDoc.productDocType == '0'}">
								<col width="25px">
								<col width="70px">
									<col width="70px">
									<col width="90px">
									<col width="206px">
								<col />
								<col width="90px">
								<col width="80px">
								<col width="70px">
								<col width="70px">
								<col width="70px">
								<col width="19%">
							</c:when>
							<c:when test="${productDevDoc.productDocType == '1' or productDevDoc.productDocType == '2'}">
								<col width="25px">
								<col width="70px">
								<col />
								<col width="100px">
								<col width="150px">
								<col width="100px">
								<col width="150px">
								<col width="100px">
								<col width="19%">
							</c:when>
							<c:otherwise></c:otherwise>
						</c:choose>

					</colgroup>
					<thead>
						<tr>
							<th></th>
							<th>번호</th>
							<c:if test="${productDevDoc.productDocType != '1' and productDevDoc.productDocType != '2'}">
							<th>대체BOM</th>
							<th>공장</th>
							<th>라인</th>
							</c:if>
							<th>QNSH</th>
							<th>상태</th>
							<th>작성일</th>
							<th>작성자</th>
							<th>수정일</th>
							<th>수정자</th>
							<th>문서설정</th>
						</tr>
					</thead>
					<tbody>
						<c:if test="${fn:length(manufacturingProcessDocList) == 0}">
							<tr>
								<td colspan="12">제조공정서가 존재하지 않습니다.</td>
							</tr>
						</c:if>
						<c:forEach items="${manufacturingProcessDocList}" var="mfgProcDoc" varStatus="status">
							<c:set var="hasMfgApproval" value="${mfgProcDoc.state == 3 ? true : false}"/>
							<input type="hidden" name="hasMfgApproval" value="${hasMfgApproval}">
							
							<c:set var="sumExcRate" value="${mfgProcDoc.sumExcRate}"/>
							<fmt:formatNumber var="formatSumExcRate" type="number" pattern="0.000" value="${((sumExcRate*1000)-((sumExcRate*1000)%1))*(1/1000)}"></fmt:formatNumber>
							<c:set var="sumIncRate" value="${mfgProcDoc.sumIncRate}"/>
							<fmt:formatNumber var="formatSumIncRate" type="number" pattern="0.000" value="${((sumIncRate*1000)-((sumIncRate*1000)%1))*(1/1000)}"></fmt:formatNumber>
							<c:set var="m_visible" value="${mfgProcDoc.state == '6' ? 'm_visible' : ''}" />
							<tr id="mgf_tr_${mfgProcDoc.dNo}" class="${m_visible}">
								<td>
									<input type="checkbox" name="check_mfg_doc" id="mfgDoc_${status.index}" value="${mfgProcDoc.dNo}" data-state="${mfgProcDoc.state}" onclick="checkMfgDoc(event, '${mfgProcDoc.term}', '${mfgProcDoc.state}', '${mfgProcDoc.stateText}')"><label style="padding:0;" for="mfgDoc_${status.index}"><span style="margin:0;"></span></label>
									<input type="hidden" name="hidden_mfg_cd" id="mfgDoc_${status.index}_cd" value="${mfgProcDoc.companyCode}">
									<input type="hidden" name="hidden_mfg_status" id="hidden_mfg_status" value="${mfgProcDoc.state}">
									<input type="hidden" name="hidden_mfg_qns" id="hidden_mfg_qns" value="${mfgProcDoc.qns}">
									<input type="hidden" name="hidden_mfg_isQnsReviewTarget" id="hidden_mfg_isQnsReviewTarget_${status.index}" value="${mfgProcDoc.isQnsReviewTarget}">
									<input type="hidden" name="hidden_mfg_dNo" id="hidden_mfg_dNo" value="${mfgProcDoc.dNo}">
								</td>
								<c:choose>
									<c:when test="${userUtil:getDeptCode(pageContext.request) == 'dept7' || userUtil:getDeptCode(pageContext.request) == 'dept8' || userUtil:getDeptCode(pageContext.request) == 'dept9'}">
										<c:choose>
											<c:when test="${userUtil:getTeamCode(pageContext.request) == '6' && userUtil:getUserGrade(pageContext.request) != '6' }">
												<td>${mfgProcDoc.dNo}</td>
											</c:when>
											<c:otherwise>
												<td><a href="javascript:goMfgDetail(${mfgProcDoc.dNo}, ${mfgProcDoc.docNo}, ${mfgProcDoc.docVersion})">${mfgProcDoc.dNo}</a></td>
											</c:otherwise>
										</c:choose>		
									</c:when>
									<c:when test="${userUtil:getDeptCode(pageContext.request) == 'dept1' || userUtil:getDeptCode(pageContext.request) == 'dept2' || userUtil:getDeptCode(pageContext.request) == 'dept3' || userUtil:getDeptCode(pageContext.request) == 'dept4' || userUtil:getDeptCode(pageContext.request) == 'dept5' || userUtil:getDeptCode(pageContext.request) == 'dept6' || userUtil:getDeptCode(pageContext.request) == 'dept10' || userUtil:getDeptCode(pageContext.request) == 'dept11' || userUtil:getDeptCode(pageContext.request) == 'dept12' || userUtil:getDeptCode(pageContext.request) == 'dept13'}"> 		
										<td><a href="javascript:goMfgDetail(${mfgProcDoc.dNo}, ${mfgProcDoc.docNo}, ${mfgProcDoc.docVersion})">${mfgProcDoc.dNo}</a></td>
									</c:when>
									<c:otherwise>
										<td>${mfgProcDoc.dNo}</td>
									</c:otherwise>
								</c:choose>
								<c:if test="${productDevDoc.productDocType != '1' and productDevDoc.productDocType != '2'}">
								<td>${mfgProcDoc.stlal}</td>
								<td>${mfgProcDoc.plantCode}(${mfgProcDoc.plantName})</td>
								<td>
									<c:choose>
										<c:when test="${mfgProcDoc.lineCode == null || mfgProcDoc.lineCode == ''}">
											
										</c:when>
										<c:otherwise>
											${mfgProcDoc.lineName}
										</c:otherwise>
									</c:choose>
								</td>
								</c:if>
								<td>
									<%-- ${mfgProcDoc.companyCode} ${mfgProcDoc.calcType} --%>
									<!-- 
									<c:choose>
										<c:when test="${mfgProcDoc.companyCode == 'MD'}">
											<c:if test="${fn:trim(mfgProcDoc.calcType) == '3'}">3번코드</c:if>
											<c:if test="${fn:trim(mfgProcDoc.calcType) == '7'}">7번코드</c:if>
											<c:if test="${fn:trim(mfgProcDoc.calcType) == '10'}">프리믹스</c:if>
										</c:when>
										<c:otherwise>
											<c:if test="${fn:trim(mfgProcDoc.calcType) == '10'}">일반제품</c:if>
											<c:if test="${fn:trim(mfgProcDoc.calcType) == '20'}">기준수량<br>기준제품</c:if>
											<c:if test="${fn:trim(mfgProcDoc.calcType) == '30'}">크림제품</c:if>
										</c:otherwise>
									</c:choose>
									 -->
									 <c:choose>
									 	<c:when test='${mfgProcDoc.isQnsReviewTarget == "1"}'>
										 	<a href="javascript:openPopupQNSH('${mfgProcDoc.qns}')">${mfgProcDoc.qns}</a>
										</c:when>
										<c:when test='${mfgProcDoc.isQnsReviewTarget == "0"}'>
										 	해당사항<br>없음
										</c:when>
										<c:otherwise>
											
										</c:otherwise>
									 </c:choose>
									 
								</td>
								<td><a href="javascript:approvalDetail('${mfgProcDoc.dNo}','manufacturingProcessDoc');">${mfgProcDoc.stateText}</a></td>
								<td>${mfgProcDoc.regDate}</td>
								<td>${mfgProcDoc.regUserName}</td>
								<td>${mfgProcDoc.modDate}</td>
								<td>${mfgProcDoc.modUserName}</td>
								<td>
									<c:choose>
										<c:when test="${(userUtil:getDeptCode(pageContext.request) == 'dept7' || userUtil:getDeptCode(pageContext.request) == 'dept8' || userUtil:getDeptCode(pageContext.request) == 'dept9') && userUtil:getTeamCode(pageContext.request) == '6' && userUtil:getUserGrade(pageContext.request) != '6'}"></c:when>
										<c:otherwise>
											<c:if test="${userUtil:getIsAdmin(pageContext.request) == 'Y'  || userUtil:getUserId(pageContext.request) == productDevDoc.regUserId || userUtil:getUserGrade(pageContext.request) == '3' || userUtil:getUserGrade(pageContext.request) == '6'}">
												<ul class="list_ul">
													<!-- '보기'변경 -->
													<c:choose>
														<c:when test="${productDevDoc.productDocType == '1'}">
															<li>
																<button class="btn_doc" onclick="preView('manufacturingProcessDocForStores', '${mfgProcDoc.dNo}', '${mfgProcDoc.docNo}', '${mfgProcDoc.docVersion}')">
																	<img src="/resources/images/icon_doc01.png">보기
																</button>
															</li>
														</c:when>
														<c:otherwise>
															<li>
																<button class="btn_doc" onclick="preView('manufacturingProcessDoc', '${mfgProcDoc.dNo}', '${mfgProcDoc.docNo}', '${mfgProcDoc.docVersion}')">
																	<img src="/resources/images/icon_doc01.png">보기
																</button>
															</li>
														</c:otherwise>
													</c:choose>
													
													
													<!-- <li><button class="btn_doc"><img src="/resources/images/icon_doc02.png">복사</button></li> -->
													<!-- productDevDoc.isLatest == 1 && productDevDoc.isClose == 0 && -->
													<c:if test="${productDevDoc.isLatest == 1 && productDevDoc.isClose == 0}">
														<c:if test="${mfgProcDoc.state != '3' && mfgProcDoc.state != '6'}">
															<c:choose>
																<c:when test="${userUtil:getIsAdmin(pageContext.request) == 'Y' || userUtil:getUserId(pageContext.request) == productDevDoc.regUserId}">
																	<c:choose>
																		<c:when test="${userUtil:getUserId(pageContext.request) == productDevDoc.regUserId && (mfgProcDoc.state == '0' || mfgProcDoc.state == '2' || mfgProcDoc.state == '7')}">
																			<%-- 사용자와 등록자가 같으면서 문서 상태가  0(등록)  또는 2(반려) 또는 7(임시저장) 일경우  --%>
																			<li><button class="btn_doc" onclick="editMfg('${mfgProcDoc.dNo}', '${mfgProcDoc.companyCode}', '${mfgProcDoc.plantCode}')"><img src="/resources/images/icon_doc03.png">수정</button></li>
																		</c:when>
																		<c:when test="${userUtil:getIsAdmin(pageContext.request) == 'Y'}">
																			<%-- 사용자가 관리자 권한일 경우 --%>
																			<li><button class="btn_doc" onclick="editMfg('${mfgProcDoc.dNo}', '${mfgProcDoc.companyCode}', '${mfgProcDoc.plantCode}')"><img src="/resources/images/icon_doc03.png">수정</button></li>
																		</c:when>
																		<c:when test="${userUtil:getUserId(pageContext.request) == productDevDoc.regUserId && (mfgProcDoc.state == '1' || mfgProcDoc.state == '4')}">
																			<%-- 사용자와 등록자가 같으면서 문서 상태가  1(승인) 또는 4(ERP반영 완료) 일경우  --%>
																			<li><button class="btn_doc" onclick="editMfgSpec('${mfgProcDoc.dNo}', '${mfgProcDoc.companyCode}', '${mfgProcDoc.plantCode}')"><img src="/resources/images/icon_doc03.png">수정</button></li>
																		</c:when>
																	</c:choose>
																	<%-- 
																	<c:if test="${userUtil:getUserId(pageContext.request) == productDevDoc.regUserId && (mfgProcDoc.state == '0' || mfgProcDoc.state == '2' || mfgProcDoc.state == '7')}">
																	</c:if>
																	<c:if test="${userUtil:getIsAdmin(pageContext.request) == 'Y'}">
																	</c:if>
																	 --%>
																	<li><button class="btn_doc" onclick="stopMfgDOc('${mfgProcDoc.dNo}')"><img src="/resources/images/icon_doc06.png">중지</button></li>
																	<li><button class="btn_doc" onclick="deleteMfgDoc('${mfgProcDoc.dNo}')"><img src="/resources/images/icon_doc04.png">삭제</button></li>
																	<%-- <li><button class="btn_doc" onclick="copyMfgDoc('${mfgProcDoc.dNo}')"><img src="/resources/images/icon_doc02.png">복사</button></li> --%>
																</c:when>
																<c:otherwise>
																	<c:if test="${userUtil:getUserGrade(pageContext.request) == '3' || userUtil:getUserGrade(pageContext.request) == '6'}">
																		<li><button class="btn_doc" onclick="editMfg('${mfgProcDoc.dNo}', '${mfgProcDoc.companyCode}', '${mfgProcDoc.plantCode}')"><img src="/resources/images/icon_doc03.png">수정</button></li>
																	</c:if>
																</c:otherwise>
															</c:choose>
															<li><button class="btn_doc" onclick="callQnsDialog('${mfgProcDoc.dNo}', '${mfgProcDoc.qns}', '${mfgProcDoc.isQnsReviewTarget}')">QNS</button></li>
														</c:if>
													</c:if>
													<c:if test="${productDevDoc.isLatest == 0}">
														<c:if test="${mfgProcDoc.state != '3' && mfgProcDoc.state != '6'}"> 
															<c:if test="${userUtil:getIsAdmin(pageContext.request) == 'Y' || userUtil:getUserGrade(pageContext.request) == '3' || userUtil:getUserGrade(pageContext.request) == '6'}">
																<li><button class="btn_doc" onclick="editMfg('${mfgProcDoc.dNo}', '${mfgProcDoc.companyCode}', '${mfgProcDoc.plantCode}')"><img src="/resources/images/icon_doc03.png">수정</button></li>
															</c:if>
															<c:if test="${userUtil:getUserId(pageContext.request) == productDevDoc.regUserId && (mfgProcDoc.state =='0' || mfgProcDoc.state =='2') }">
																<li><button class="btn_doc" onclick="editMfg('${mfgProcDoc.dNo}', '${mfgProcDoc.companyCode}', '${mfgProcDoc.plantCode}')"><img src="/resources/images/icon_doc03.png">수정</button></li>
															</c:if>
															<c:if test="${userUtil:getUserId(pageContext.request) == productDevDoc.regUserId && (mfgProcDoc.state == '4')}">
																<li><button class="btn_doc" onclick="editMfgSpec('${mfgProcDoc.dNo}', '${mfgProcDoc.companyCode}', '${mfgProcDoc.plantCode}')"><img src="/resources/images/icon_doc03.png">수정</button></li>
															</c:if>
															<li><button class="btn_doc" onclick="callQnsDialog('${mfgProcDoc.dNo}', '${mfgProcDoc.qns}', '${mfgProcDoc.isQnsReviewTarget}')">QNS</button></li>
														</c:if>
													</c:if>
													<li id="commentLi">
														<button class="btn_doc" onclick="openComment('${mfgProcDoc.dNo}', 'manufacturingProcessDoc')"><img src="/resources/images/icon_doc05.png">수정내역</button>
														<c:if test="${mfgProcDoc.commentCnt > 0}"><span class="badgeCnt">${mfgProcDoc.commentCnt}</span></c:if>
													</li>
													<c:if test="${userUtil:getIsAdmin(pageContext.request) == 'Y' || userUtil:getUserId(pageContext.request) == productDevDoc.regUserId}">
														<li><button class="btn_doc" onclick="openHistoryDialog('${mfgProcDoc.dNo}')"><img src="/resources/images/icon_doc08.png">이력</button></li>
													</c:if>
													 <!-- || userUtil:getUserId(pageContext.request) == productDevDoc.regUserId -->
													<c:if test="${userUtil:getIsAdmin(pageContext.request) == 'Y' || userUtil:getUserGrade(pageContext.request) == '3'}">
														<c:if test="${productDevDoc.productDocType != '1' and  productDevDoc.productDocType != '2'}">
															<li><button class="btn_doc" onclick='openDispPopup("${mfgProcDoc.dNo}", "${mfgProcDoc.docProdName}")'><img src="/resources/images/icon_doc07.png"></button></li>
														</c:if>
													</c:if>
												</ul>
											</c:if>
											<c:if test="${userUtil:getIsAdmin(pageContext.request) != 'Y' && userUtil:getUserId(pageContext.request) != productDevDoc.regUserId && userUtil:getUserGrade(pageContext.request) != '3' && userUtil:getUserGrade(pageContext.request) != '6'}">
												<ul class="list_ul">
													<li>
														<button class="btn_doc" onclick="preView('manufacturingProcessDoc', '${mfgProcDoc.dNo}', '${mfgProcDoc.docNo}', '${mfgProcDoc.docVersion}')">
															<img src="/resources/images/icon_doc01.png">보기
														</button>
													</li>
													<c:if test="${userUtil:getTeamCode(pageContext.request) == '9'}">
														<li><button class="btn_doc" onclick="editMfgPackage('${mfgProcDoc.dNo}', '${mfgProcDoc.companyCode}', '${mfgProcDoc.plantCode}')"><img src="/resources/images/icon_doc03.png">수정</button></li>
													</c:if>
													<li>
														<button class="btn_doc" onclick="openComment('${mfgProcDoc.dNo}', 'manufacturingProcessDoc')"><img src="/resources/images/icon_doc05.png">수정내역</button>
														<c:if test="${mfgProcDoc.commentCnt > 0}"><span class="badgeCnt">${mfgProcDoc.commentCnt}</span></c:if>
													</li>
												</ul>
											</c:if>
										</c:otherwise>
									</c:choose>	
								</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>

			<div style="${displayNone}">
			<!-- 품목제조 보고서 Start -->
			<div class="fr pt10 pb10">
<%--				<button class="btn_con_search" onClick="openApprovalDialog('approval_manufacturingNo'); return false;"><img src="/resources/images/icon_s_com.png" />중단요청 결재상신</button>--%>
			</div>
			<div class="title2">
               <span class="txt">품목제조보고서</span>
            </div>
            <div class="main_tbl" style="padding-bottom: 40px;">
               <table class="tbl04" id="manufacturingNoTable">
                  <colgroup>
<%--					  <col width="3%">--%>
                     <col width="3%">
                     <col width="3%">
                     <col width="10%">
                     <col width="6%">
                     <col width="8%">
                     <col width="8%">
                     <col width="8%">
                     <col width="5%">
                     <col width="10%">
                     <col width="19%">
                     <col width="20%">
                  </colgroup>
                  <thead>
                     <tr>
<%--						<th></th>--%>
                        <th>&nbsp;</th>
                        <th>버전</th>
                        <th>품보번호</th>
                        <th>제조공정서<br/>번호</th>
                        <th>공장</th>
                        <th>상태</th>
                        <th>품보번호<br/>발급일</th>
                        <th>요청자</th>
                        <th>신고일</th>
                        <th>첨부파일</th>
                        <th>&nbsp;</th>
                     </tr>
                  </thead>
                  <tbody id="manufacturingNoList">                     
                  </tbody>
               </table>
            </div>

			<!-- 디자인 의뢰서 Start -->
			<c:if test="${!(userUtil:getTeamCode(pageContext.request) == '6' && userUtil:getUserGrade(pageContext.request) != '6')}">
				<c:if test="${userUtil:getIsAdmin(pageContext.request) == 'Y' || userUtil:getUserGrade(pageContext.request) == '6' || userUtil:getUserId(pageContext.request) == productDevDoc.regUserId}">
					<div class="fr pt10 pb10">
						<c:if test="${productDevDoc.isLatest == 1 && productDevDoc.isClose == 0}">
							<button class="btn_con_search" onClick="ceateDesignRequest()"><img src="/resources/images/icon_s_write.png" />디자인의뢰서 생성</button>
							<button class="btn_con_search" onClick="openApprovalDialog('approval_design'); return false;"><img src="/resources/images/icon_s_com.png" />디자인의뢰서 검토요청</button>
						</c:if>
					</div>
				</c:if>
				<div class="title3">
					<span class="txt">디자인의뢰서</span>
				</div>
				<div class="main_tbl" style="padding-bottom: 40px;">
					<table class="tbl04" id="designReqDocTable">
						<colgroup>
							<col width="40px">
							<col width="90px">
							<col />
							<col width="10%">
							<col width="14%">
							<col width="6%">
							<col width="12%">
							<col width="6%">
							<col width="150px">
						</colgroup>
						<thead>
							<tr>
								<th></th>
								<th>번호</th>
								<th>문서명</th>
								<th>상태</th>
								<th>작성일</th>
								<th>작성자</th>
								<th>수정일</th>
								<th>수정자</th>
								<th>문서설정</th>
							</tr>
						</thead>
						<tbody>
							<c:if test="${fn:length(designRequestDocList) == 0}">
								<tr>
									<td colspan="9">디자인의뢰서가 존재하지 않습니다.</td>
								</tr>
							</c:if>
							<c:forEach items="${designRequestDocList}" var="designReqDoc" varStatus="status">
								<c:set var="hasDesignApproval" value="${designReqDoc.state == 3 ? true : false}"/>								
								<tr>
									<td>
										<input type="checkbox" name="check_design_doc" id="designDoc_${status.index}" value="${designReqDoc.drNo}"><label for="designDoc_${status.index}"><span></span></label>
										<input type="hidden" name="designReqDocState" id="designReqDocState" value="${designReqDoc.state}">
										<input type="hidden" name="designReqDocNo" id="designReqDocNo" value="${designReqDoc.drNo}">
										<input type="hidden" name="designReqDocregUserId" id="designReqDocregUserId" value="${designReqDoc.regUserId}">
									</td>
									<td>${designReqDoc.drNo}</td>
									<td>
										<div class="ellipsis_txt tgnl">
											<c:set var="gradeCode" value="${userUtil:getUserGrade(pageContext.request)}" />
											<c:if test="${userUtil:getIsAdmin(pageContext.request) == 'Y' || userUtil:getUserId(pageContext.request) == productDevDoc.regUserId || gradeCode == '2' || gradeCode == '3' || gradeCode == '4' || gradeCode == '5' || gradeCode == '6'}">
												<!--a href="/dev/designRequestDocView?drNo=${designReqDoc.drNo}">${designReqDoc.title}</a-->
												<a href="javascript:designReqView('${designReqDoc.drNo}','${productDevDoc.isLatest}');">${designReqDoc.title}</a>
											</c:if>
										</div>
									</td>
									<td><a href="javascript:approvalDetail('${designReqDoc.drNo}','designRequestDoc');">${designReqDoc.stateText}</a></td>
									
									
									<td>${designReqDoc.regDate}</td>
									<td>${designReqDoc.regUserName}</td>
									<td>${designReqDoc.modDate}</td>
									<td>${designReqDoc.modUserName}</td>
									<td>
										<ul class="list_ul">
											<li><button class="btn_doc" onClick="javascript:preView('designRequestDoc', '${designReqDoc.drNo}', '', '')"><img src="/resources/images/icon_doc01.png">보기</button></li>
											<c:if test="${userUtil:getIsAdmin(pageContext.request) == 'Y' || userUtil:getUserGrade(pageContext.request) == '6' || userUtil:getUserId(pageContext.request) == productDevDoc.regUserId}">
												<li><button class="btn_doc" onclick="copyDesignReqDoc('${designReqDoc.drNo}')"><img src="/resources/images/icon_doc02.png">복사</button></li>
												<%-- <c:if test="${productDevDoc.isLatest == 1 && productDevDoc.isClose == 0}">
													<c:if test="${designReqDoc.state == 0}">
														<li><button class="btn_doc" onclick="editDesignReqDoc('${designReqDoc.drNo}','${productDevDoc.isLatest}')"><img src="/resources/images/icon_doc03.png">수정</button></li>
														<li><button class="btn_doc" onclick="deleteDesignReqDoc('${designReqDoc.drNo}','${productDevDoc.isLatest}')"><img src="/resources/images/icon_doc04.png">삭제</button></li>
													</c:if>
												</c:if> --%>
											</c:if>
										</ul>
									</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
			</c:if>
			
			<!-- 시생산 보고서 Start -->
			<div class="fr pt10 pb10">
				<% if(doAdmin){ %>
				<button class="btn_con_search" onclick="location.href='/trialReport/createReport?docNo=${productDevDoc.docNo}&docVersion=${productDevDoc.docVersion}';">
					<img src="/resources/images/icon_s_write.png" />시생산 보고서 생성
				</button>
				<% } %>
					<!-- 
					<button class="btn_con_search" onclick="openTrialProdReportApproval();">
						<img src="/resources/images/icon_s_com.png" />시생산 보고서 결재상신
					</button>
					 -->
			</div>
			<div class="title3">
				<span class="txt">시생산보고서</span>
			</div>
			<div class="main_tbl" style="padding-bottom: 40px;">
				<table class="tbl04" id="trialProductionReport">
					<colgroup>
<%--						<col width="40px">--%>
<%--						<col width="90px">--%>
<%--						<col width="100px">--%>
<%--						<col />--%>
<%--						<col width="8%">--%>
<%--						<col width="8%">--%>
<%--						<col width="8%">--%>
<%--						<col width="7%">--%>
<%--						<col width="10%">--%>
<%--						<col width="70px">--%>
<%--						<col width="170px">--%>
						<col width=""/>
						<col width=""/>
						<col width=""/>
						<col width=""/>
						<col width=""/>
						<col width=""/>
						<col width=""/>
					</colgroup>
					<thead>
						<tr>
							<th></th>
							<th>번호</th>
							<th>제조공정서 번호</th>
							<th>라인</th>
<%--							<th>시생산일</th>--%>
<%--							<th>개발강도</th>--%>
							<th>결과</th>
							<th>상태</th>
							<th>출시일(목표)</th>
<%--							<th>첨부파일</th>--%>
<%--							<th>문서설정</th>--%>
						</tr>
					</thead>
					<tbody>
						<c:if test="${fn:length(trialProductionReportList) == 0}">
							<tr>
								<td colspan="7">시생산 보고서가 존재하지 않습니다.</td>
							</tr>
						</c:if>
						<c:forEach items="${trialProductionReportList}" var="trialProductionReport" varStatus="status">
							<c:choose>
								<c:when test="${trialProductionReport.type == 'V2'}">
									<c:set var="m_visible" value="${trialProductionReport.state == '21' || trialProductionReport.state == '51' ? 'm_visible' : ''}" />
									<tr class="${m_visible }">
										<td></td>
										<td>
											<a href="#" onclick="openTrailReportDetail(${trialProductionReport.rNo})">&nbsp;${trialProductionReport.rNo}&nbsp;</a>
										</td>   <!-- 상세 링크 -->
										<td>${trialProductionReport.dNo}</td>
										<td>${trialProductionReport.lineName}</td>
										<td>${trialProductionReport.resultName}</td>
										<c:set var="tbType" value="trialReportCreate"/><c:set var="type" value="5"/>
										<c:if test="${trialProductionReport.apprNo2 != null and trialProductionReport.apprNo2 != ''}">
											<c:set var="tbType" value="trialReportAppr2"/><c:set var="type" value="6"/>
										</c:if>
										<td><a href="javascript:approvalDetail('${trialProductionReport.rNo}','${tbType}', '${type}');">${trialProductionReport.stateName}</a></td>
										<td>${trialProductionReport.releasePlanDate}</td>
									</tr>
								</c:when>
								<c:otherwise>
									<c:set var="m_visible" value="${trialProductionReport.state == '6' ? 'm_visible' : ''}" />
									<tr class="${m_visible }">
										<!-- 선택 -->
										<td>
											<input type="checkbox" name="check_tiral_report" id="trialProdReport_${status.index}" value="${trialProductionReport.rNo}"><label for="trialProdReport_${status.index}"><span></span></label>
											<input type="hidden" name="trialProdReportState" id="trialProdReportState_${status.index}" value="${trialProductionReport.state}">
										</td>
										<!-- 번호 -->
											<%-- <td><a href="javascript:void(0);" onclick="goTrialDetail('${trialProductionReport.rNo}', '${productDevDoc.docNo}', '${productDevDoc.docVersion}')">${trialProductionReport.rNo}</a></td> --%>
										<td><a href="javascript:void(0);" onclick="location.href='/dev/trialProductionReportDetail?docNo=${productDevDoc.docNo}&docVersion=${productDevDoc.docVersion}&rNo=${trialProductionReport.rNo}'">${trialProductionReport.rNo}</a></td>

										<!-- 제조공정서번호 -->
										<td>${trialProductionReport.dNo}</td>

										<!-- 라인 -->
										<td>${trialProductionReport.lineName}</td>

										<!-- 시생산일 -->
<%--										<td>${trialProductionReport.trialDate}</td>--%>

										<!-- 개발강도 -->
<%--										<td>${trialProductionReport.devIntensityName}</td>--%>

										<!-- 결과 -->
										<td>${trialProductionReport.resultName}</td>

										<!-- 상태 -->
										<td>${trialProductionReport.stateName}</td>

										<!-- 작성자 -->
<%--										<td>${trialProductionReport.createName}</td>--%>

										<!-- 첨부파일 존재유무 표시 -->
<%--										<td>--%>
<%--											<c:if test="${trialProductionReport.fileCount > 0 }">--%>
<%--												<img src="/resources/images/icon_file01.png" style="vertical-align:middle;">--%>
<%--											</c:if>--%>
<%--										</td>--%>

<%--										<!-- 문서 설정 -->--%>
<%--										<td>--%>
<%--											<ul class="list_ul">--%>
<%--												<!-- 수정 -->--%>
<%--												<li><button class="btn_doc" onclick="modifyTrialProdReport('${trialProductionReport.rNo}', '${productDevDoc.docNo}', '${productDevDoc.docVersion}', '${trialProductionReport.state}', '${userUtil:getUserId(pageContext.request)}', '${trialProductionReport.createUser}');"><img src="/resources/images/icon_doc03.png">수정</button></li>--%>
<%--												<!-- 삭제 -->--%>
<%--												<li><button class="btn_doc" onclick="deleteTrialProdReport('${trialProductionReport.rNo}', '${trialProductionReport.state}');"><img src="/resources/images/icon_doc04.png">삭제</button></li>--%>
<%--												<li>--%>
<%--													<button class="btn_doc" onclick="openComment('${trialProductionReport.rNo}', 'trialProductionReport')"><img src="/resources/images/icon_doc05.png">수정내역</button>--%>
<%--													<c:if test="${trialProductionReport.commentCnt > 0}"><span class="badgeCnt">${trialProductionReport.commentCnt}</span></c:if>--%>
<%--												</li>--%>
<%--											</ul>--%>
<%--										</td>--%>
										<td></td>
									</tr>
								</c:otherwise>
							</c:choose>

						</c:forEach>
					</tbody>
				</table>
			</div>
			</div>
			<!-- 첨부파일 Start -->
			<div class="fr pt10">
			<c:if test="${userUtil:getIsAdmin(pageContext.request) == 'Y' || userUtil:getUserId(pageContext.request) == productDevDoc.regUserId || userUtil:getUserGrade(pageContext.request) == '3'}">
				<c:if test="${productDevDoc.isLatest == 1 && productDevDoc.isClose == 0}">
					<button class="btn_con_search" onClick="openDialog('dialog_attatch')">
						<img src="/resources/images/icon_s_file.png" />파일첨부
					</button>
				</c:if>
			</c:if>
			
			</div>
			<div class="title4">
				<span class="txt">파일첨부</span>
			</div>
			<div class="con_file" style="padding-bottom: 40px;">
				<ul>
					<li class="point_img">
						<dt>1. 제품이미지</dt><dd>
							<ul>
								<c:forEach items="${attatchFile}" var="file">
									<c:if test="${file.gubun == '60'}">
										<li>
											<c:choose>
												<c:when test="${userUtil:getDeptCode(pageContext.request) != 'dept8' && userUtil:getDeptCode(pageContext.request) != 'dept9' || userUtil:getUserGrade(pageContext.request) == '6' || userUtil:getTeamCode(pageContext.request) == '10' || userUtil:getTeamCode(pageContext.request) == '11'}">
													<a href="javascript:downloadFile('${file.ddfNo}')">${file.orgFileName}</a> ( ${file.regUserName}/${file.regDate} )
												</c:when>
												<c:otherwise>
													${file.orgFileName} ( ${file.regUserName}/${file.regDate} )
												</c:otherwise>
											</c:choose>			
											<c:if test="${userUtil:getIsAdmin(pageContext.request) == 'Y' || userUtil:getUserId(pageContext.request) == productDevDoc.regUserId || userUtil:getUserGrade(pageContext.request) == '3'}">
												<button class="btn_doc" onclick="deleteFile('${file.ddfNo}', '${file.orgFileName}')"><img src="/resources/images/icon_doc04.png">삭제</button>
											</c:if>
											<%-- 
											<c:if test="${file.reviewUserName == null or file.reviewUserName == ''}">
												&nbsp;| <button class="btn_doc" onclick="checkFile('${file.ddfNo}', '${file.orgFileName}')"><img src="/resources/images/icon_doc11.png">이미지확인</button>
											</c:if>
											&nbsp;| <button class="btn_doc" onclick="changeDispImage('${file.ddfNo}')"><!-- <img src="/resources/images/icon_doc11.png">대표이미지</button> -->
											 --%>
										</li>
									</c:if>
								</c:forEach>
							</ul>
						</dd>
					</li>
					<li>
						<dt>2. 포장지시안</dt><dd>
							<ul>
								<c:forEach items="${attatchFile}" var="file">
									<c:if test="${file.gubun == '10'}">
										<li>
											<c:choose>
												<c:when test="${userUtil:getDeptCode(pageContext.request) != 'dept8' && userUtil:getDeptCode(pageContext.request) != 'dept9' || userUtil:getUserGrade(pageContext.request) == '6' || userUtil:getTeamCode(pageContext.request) == '10' || userUtil:getTeamCode(pageContext.request) == '11'}">
													<a href="javascript:downloadFile('${file.ddfNo}')">${file.orgFileName}</a> ( ${file.regUserName}/${file.regDate} )
												</c:when>
												<c:otherwise>
													${file.orgFileName} ( ${file.regUserName}/${file.regDate} )
												</c:otherwise>
											</c:choose>
											
											<c:if test="${userUtil:getIsAdmin(pageContext.request) == 'Y' || userUtil:getUserId(pageContext.request) == productDevDoc.regUserId || userUtil:getUserGrade(pageContext.request) == '3'}">
												<button class="btn_doc" onclick="deleteFile('${file.ddfNo}', '${file.orgFileName}')"><img src="/resources/images/icon_doc04.png">삭제</button>
											</c:if>
										</li>
									</c:if>
								</c:forEach>
							</ul>
						</dd>
					</li>
					<li>
                  <dt>3. 기타</dt><dd>
                     <ul id="manufacturingNoFileList">
                        <%-- 2021.12.01 수정--%>
                        <c:forEach items="${attatchFile}" var="file">
                           <c:if test="${file.gubun == '30'}">
                              <li>                                 
                                 <c:choose>
                                    <c:when test="${userUtil:getDeptCode(pageContext.request) != 'dept8' && userUtil:getDeptCode(pageContext.request) != 'dept9' || userUtil:getUserGrade(pageContext.request) == '6' || userUtil:getTeamCode(pageContext.request) == '10' || userUtil:getTeamCode(pageContext.request) == '11'}">
                                       <a href="javascript:downloadFile('${file.ddfNo}')">${file.orgFileName}</a> ( ${file.regUserName}/${file.regDate} )
                                    </c:when>
                                    <c:otherwise>
                                       ${file.orgFileName} ( ${file.regUserName}/${file.regDate} )
                                    </c:otherwise>
                                 </c:choose>
                                 
                                 <c:if test="${userUtil:getIsAdmin(pageContext.request) == 'Y' || userUtil:getUserId(pageContext.request) == productDevDoc.regUserId || userUtil:getUserGrade(pageContext.request) == '3'}">
                                    <button class="btn_doc" onclick="deleteFile('${file.ddfNo}', '${file.orgFileName}')"><img src="/resources/images/icon_doc04.png">삭제</button>
                                 </c:if>
                                 
                                 <%-- --%>
                                 <c:if test="${file.reviewUserName == null or file.reviewUserName == ''}">
                                    &nbsp;| <button class="btn_doc" onclick="checkFile('${file.ddfNo}', '${file.orgFileName}')"><img src="/resources/images/icon_doc11.png">이미지확인</button>
                                 </c:if>
                                  
                        <%-- 2021.12.01 수정        --%>  
                              </li>
                           </c:if>
                        </c:forEach>
                        
                     </ul>
                  </dd>
               </li>
					<%-- <li>
						<dt>4. QNS 허들정보</dt><dd>
							<ul>
								<c:forEach items="${manufacturingProcessDocList}" var="mfgProcDoc" varStatus="status">
									<c:if test="${mfgProcDoc.qns != null}">
										<li id="qns${status.index}" style='background-image: url("/resources/images/img_dot2.png"); background-position: left; background-repeat: no-repeat; width: 100%;'>
											<div style="width: 35%; float:left">
												[제조공정서: ${mfgProcDoc.dNo}] [공장: ${mfgProcDoc.plantCode}(${mfgProcDoc.plantName})]
											</div>
											<div style="width: 55%; float:left">
												${mfgProcDoc.qns}
											</div>
										</li>
									</c:if>
								</c:forEach>
							</ul>
						</dd>
					</li> --%>
				</ul>
			</div>
			<div class="btn_box_con5">
				<button class="btn_admin_gray" onClick="goList()" style="width: 120px;">목록</button>
			</div>
			
			
			<c:if test="${userUtil:getIsAdmin(pageContext.request) == 'Y' || userUtil:getUserId(pageContext.request) == productDevDoc.regUserId || userUtil:getUserGrade(pageContext.request) == '3'}">
				<div class="btn_box_con4">
					<c:if test="${userUtil:getIsAdmin(pageContext.request) == 'Y' || userUtil:getUserGrade(pageContext.request) == '3'}">
						<c:if test="${productDevDoc.productDocType != '1' and productDevDoc.productDocType != '2'}">
							<button class="btn_admin_red" onclick="updateBOM()">BOM 반영</button>
						</c:if>
					</c:if>
					<c:if test="${productDevDoc.isLatest == 1 && productDevDoc.isClose == 0}">
						<button class="btn_admin_sky" onclick="callVersionUpDialog()">제품버전업</button>
						<button class="btn_admin_navi" style="width: 120px;" onclick="openDialog('dialog_modify')">수정</button>
						<button class="btn_admin_gray" style="width: 120px;" onclick="deleteDevDoc()">버전삭제</button>
					</c:if>
				</div>
			</c:if>
			<c:if test="${userUtil:getUserGrade(pageContext.request) == '6'}">
				<div class="btn_box_con4">
					<c:if test="${productDevDoc.isLatest == 1 && productDevDoc.isClose == 0}">
						<button class="btn_admin_navi" style="width: 120px;" onclick="openDialog('dialog_modify')">수정</button>
					</c:if>
				</div>
			</c:if>
			
			<%-- 
			<c:if test="${userUtil:getIsAdmin(pageContext.request) == 'Y'}">
				<div class="btn_box_con4">
					<button class="btn_admin_red" onclick="updateBOM()">BOM 반영</button>
					<button class="btn_admin_sky" onclick="callVersionUpDialog()">제품버전업</button>
					<button class="btn_admin_navi" style="width: 120px;" onclick="openDialog('dialog_modify')">수정</button>
					<button class="btn_admin_gray" style="width: 120px;" onclick="deleteDevDoc()">버전삭제</button>
				</div>
			</c:if>
			<c:if test="${userUtil:getIsAdmin(pageContext.request) != 'Y'}">
				<c:if test="${userUtil:getDeptCode(pageContext.request) != 'dept7' && userUtil:getDeptCode(pageContext.request) != 'dept8' && userUtil:getDeptCode(pageContext.request) != 'dept9'}">
					<div class="btn_box_con4">
						<c:if test="${userUtil:getDeptCode(pageContext.request) == 'dept1' &&  userUtil:getUserGrade(pageContext.request) =='3'}">
							<button class="btn_admin_red" onclick="updateBOM()">BOM 반영</button>
						</c:if>
						<c:if test="${userId eq productDevDoc.regUserId}">
							<c:if test="${productDevDoc.isLatest == 1}">
								<button class="btn_admin_sky" onclick="callVersionUpDialog()">제품버전업</button>
								<button class="btn_admin_navi" style="width: 120px;" onclick="openDialog('dialog_modify')">수정</button>
								<button class="btn_admin_gray" style="width: 120px;" onclick="deleteDevDoc()">버전삭제</button>
							</c:if>
						</c:if>
					</div>
				</c:if>
			</c:if> --%>
			<hr class="con_mode" />
			<!-- 신규 추가 꼭 데려갈것 !-->
		</div>
	</section>
</div>

<form id="mfgCreateForm" method="post">
	<input type="hidden" name="docNo" value="${productDevDoc.docNo}">
	<input type="hidden" name="docVersion" value="${productDevDoc.docVersion}">
	<input type="hidden" name="productName" value="${productDevDoc.productName}">
</form>
<input id="selectedDocProdName" type="hidden"/>

<!-- 제품개발문서 버전업 레이어 start-->
<div class="white_content" id="dialog_versionUp">
	<div class="modal positionCenter" style="width: 800px; height: 440px;">
		<h5 style="position: relative">
			<span class="title">제품개발문서 버전업</span>
			<div class="top_btn_box">
				<ul>
					<li>
						<button class="btn_madal_close" onClick="closeDialogWithClean('dialog_versionUp')"></button>
					</li>
				</ul>
			</div>
		</h5>
		<div class="list_detail">
			<div class="main_tbl" style="padding-bottom: 40px;">
				<c:if test="${productDevDoc.productDocType != '1'}">
					<table class="tbl04">
						<colgroup>
							<col width="40px">
							<col width="90px">
							<col />
							<col width="10%">
							<col width="25%">
							<col width="8%">
						</colgroup>
						<tHead>
						<tr>
							<th></th>
							<th>문서번호</th>
							<th>문서명</th>
							<th>상태</th>
							<th>작성일</th>
							<th>작성자</th>
						</tr>
						</tHead>
						<tBody>
						<c:if test="${fn:length(designRequestDocList) == 0}">
							<tr>
								<td colspan="9">디자인의뢰서가 존재하지 않습니다.</td>
							</tr>
						</c:if>
						<c:forEach items="${designRequestDocList}" var="designReqDoc" varStatus="status">
							<tr>
								<td>
									<input type="checkbox" name="dialog_check_design_doc" id="dialog_designDoc_${status.index}"><label for="dialog_designDoc_${status.index}"><span></span></label>
								</td>
								<td>${designReqDoc.drNo}</td>
								<td>
									<div class="ellipsis_txt tgnl">
											${designReqDoc.title} <span class="icon_new">N</span>
									</div>
								</td>
								<td>${designReqDoc.state}</td>
								<td>${designReqDoc.regDate}</td>
								<td>${designReqDoc.regUserId}</td>
							</tr>
						</c:forEach>
						</tBody>
					</table>
				</c:if>
				<br>
				<form id="versionUpForm">
					<input type="hidden" name="ddNo" value="${productDevDoc.ddNo}">
					<input type="hidden" name="docNo" value="${productDevDoc.docNo}">
					<input type="hidden" name="docVersion" value="${productDevDoc.docVersion}">
					<ul>
						<li>
							<dt>버전업메모</dt>
							<dd class="pr20 pb20">
								<textarea name="versionUpMemo" style="width: 100%; height: 60px"></textarea>
							</dd>
						</li>
					</ul>
				</form>
			</div>
		</div>
		<div class="btn_box_con">
			<button id="versionUpBtn" class="btn_admin_red" onclick="versionUp()">제품버전업</button>
			<button class="btn_admin_gray" onClick="closeDialogWithClean('dialog_versionUp')">취소</button>
		</div>
	</div>
</div>
<!-- 제품개말분서 버전업 레이어 close-->
<!-- 제품개발문서 수정 레이어 start-->
<div class="white_content" id="dialog_modify">
	<div class="modal positionCenter" style="width: 700px; height: 620px;">
		<h5 style="position: relative">
			<span class="title">제품개발문서 수정</span>
			<div class="top_btn_box">
				<ul>
					<li>
						<button class="btn_madal_close" onClick="closeDialogWithClean('dialog_modify')"></button>
					</li>
				</ul>
			</div>
		</h5>
		<div class="list_detail">
			<form id="devDocEditForm">
				<input type="hidden" name="ddNo" value="${productDevDoc.ddNo}">
				<input type="hidden" name="productCategoryText" value="" >
				<ul>
					<li class="pt10">
						<dt>유형</dt>
						<dd>
							<input type="radio" name="productDocType" id="productDocType0" value="0" onclick="productDocTypeOnClick(0)" /><label for="productDocType0"><span></span>일반</label>
							<input type="radio" name="productDocType" id="productDocType1" value="1" onclick="productDocTypeOnClick(1)" /><label for="productDocType1"><span></span>점포용</label>
							<input type="radio" name="productDocType" id="productDocType2" value="2" onclick="productDocTypeOnClick(2)" /><label for="productDocType2"><span></span>OEM</label>
						</dd>
					</li>
					<li id="li_store_div"  style="display: none">
						<dt>구분</dt>
						<dd>
							<div class="selectbox req" style="width:130px;">
								<label for="select_store_div" id="label_store_div">선택</label>
								<select id="select_store_div" name="select_store_div">
								</select>
							</div>
						</dd>
					</li>
					<li>
						<dt>제품명</dt>
						<dd>
							<input name="productName" type="text" class="req" style="width: 302px;" placeholder="입력필수" value="${strUtil:getHtmlBr(productDevDoc.productName)}" />
							<%--${productDevDoc.productName} --%>
						</dd>
					</li>
					<li id="li_productCode">
						<dt>제품코드</dt>
						<dd>
							<input class="" id="productCode" name="productCode" type="text" value="${productDevDoc.productCode}" style="width: 150px; float: left" />
							<input id="imNo" type="hidden" name="imNo" value="${productDevDoc.imNo}">
							<button class="btn_small_search ml5" onclick="getPrdCode(event)" style="float: left">검색</button>
							<div id="prdCodeDiv" class="selectbox req ml5" style="width:200px; position: relative; display:none;">  
								<select id="productCode_select" name="productCode_select" onchange="changePrdCode(event)">
									<option value="">선택</option>
								</select>
								<label id="label_productCode_select" for="productCode_select">선택</label> 
							</div>
						</dd>
					</li>
					<li id="li_manufacturingNoSeq">
						<dt>품목제조보고번호</dt>
						<dd>
							<input class="" id="reqNum" name="manufacturingNo" type="text" value="${productDevDoc.manufacturingNo}" style="width: 150px; float: left" />
							<input id="manufacturingNoSeq" type="hidden" name="manufacturingNoSeq" value="${productDevDoc.manufacturingNoSeq}">
							<button class="btn_small_search ml5" onclick="getMfgNo(event)" style="float: left">검색</button>
							<div id="reqDiv" class="selectbox req ml5" style="width:200px; position: relative; display:none; ">  
								<select id="reqNum_select" name="reqNum_select" onchange="changeRegNum(event)">
									<option value="">선택</option>
								</select>
								<label for="reqNum_select">선택</label> 
							</div>
						</dd>
					</li>
					<li id="li_isNew">
						<dt>신제품</dt>
						<dd>
							<input id="isNew" name="isNew" type="checkbox" value="Y" ${productDevDoc.isNew == 'Y' ? 'checked' : '' }/>
							<label for="isNew" style="vertical-align: middle;"><span></span>관리대상</label>
						</dd>
					</li>
					<li>
						<dt>출시일</dt>
						<dd>
							<input id="launchDate" name="launchDate" type="text" style="width: 170px;" readonly="readonly" 
								value="${fn:substring(productDevDoc.launchDate, 0, 10)}">
						</dd>
					</li>
					<li id="li_productType">
						<dt>제품유형</dt>
						<dd>
							<div class="selectbox req" style="width:130px;">
								<label for="dialog_productType1" id="label_dialog_productType1"> 선택</label>
								<select id="dialog_productType1" name="productType1" onChange="loadProductType(event,'2','dialog_productType2')">
									<option value="">선택</option>
								</select>
							</div>
							<div class="selectbox req ml5" style="width:130px;display:none">
								<label for="dialog_productType2" id="label_dialog_productType2"> 선택</label>
								<select id="dialog_productType2" name="productType2" onChange="loadProductType(event,'3','dialog_productType3')">
									<option value="">선택</option>
								</select>
							</div>
							<div class="selectbox req ml5" style="width:130px;display:none">
								<label for="dialog_productType3" id="label_dialog_productType3"> 선택</label>
								<select id="dialog_productType3" name="productType3">
									<option value="">선택</option>
								</select>
							</div>
						</dd>
					</li>
					<li id="li_etcDisplay">
						<dt>기타</dt>
						<dd>
							<div class="selectbox" style="width:130px;">  
								<label for="sterilization" id="label_sterilization">선택</label> 
								<select id="sterilization" name="sterilization">
								</select>
							</div>
							<div class="selectbox ml5" style="width:250px;">  
								<label for="etcDisplay" id="label_etcDisplay">선택</label> 
								<select id="etcDisplay" name="etcDisplay">
								</select>
							</div>
						</dd>
					</li>
					<li>
						<dt>제품설명</dt>
						<dd class="pr20 pb20">
							<textarea name="explanation" style="width: 100%; height: 100px">${productDevDoc.explanation}</textarea>
						</dd>
					</li>
				</ul>
			</form>
		</div>
		<div class="btn_box_con">
			<button class="btn_admin_red" onclick="updateDevDoc()">수정</button>
			<button class="btn_admin_gray" onClick="closeDialogWithClean('dialog_modify')">취소</button>
		</div>
	</div>
</div>
<!-- 제품개발문서 수정 레이어 close-->
<!-- 제조공정서 생성레이어 start-->
<!-- 신규로 레이어창을 생성하고싶을때는  아이디값 교체-->
<!-- 클래스 옆에 적힌 스타일 값을 인라인으로 작성해서 팝업 사이즈를 직접 조정 -->
<div class="white_content" id="dialog_create">
    <div class="modal positionCenter" style="width: 550px;">
        <h5 style="position:relative">
            <span class="title">${productDocTypeName}제조공정서 생성</span>
            <div class="top_btn_box">
                <ul>
                    <li>
                        <button class="btn_madal_close" onClick="closeDialogWithClean('dialog_create')"></button>
                    </li>
                </ul>
            </div>
        </h5>
        <div class="list_detail">
            <ul>
                <li style="${displayNone}">
                    <dt>공장</dt>
                    <dd>
                    	<div class="selectbox req" style="width:130px;">  
							<label id="label_companyCode" for="companyCode">선택</label>
							<select id="companyCode" name="companyCode" onChange="companyChange('companyCode','plant')">
                            </select>
						</div>
						<div class="selectbox req ml5" style="width:130px; display:none;"> 
							<label id="label_plant" for="plant">선택</label>
                            <select id="plant" name="plant">
                            </select>
						</div>
                    </dd>
                </li>
                <li id="calcTypeLi1">
                    <dt>수식타입</dt>
                    <dd>
						<c:if test="${productDevDoc.productDocType == '0'}">
							<input type="radio" name="dialog_calcType" id="radio_caclType1" value="10" checked="checked"/><label for="radio_caclType1"><span></span>일반제품</label>
							<input type="radio" name="dialog_calcType" id="radio_caclType2" value="20" ><label for="radio_caclType2"><span></span>기준수량 기준제품</label>
							<input type="radio" name="dialog_calcType" id="radio_caclType3" value="30" ><label for="radio_caclType3"><span></span>크림제품</label>
						</c:if>
						<c:if test="${productDevDoc.productDocType == '1'}">
							<input type="radio" name="dialog_calcType" id="radio_caclType40" value="40" checked="checked" ><label for="radio_caclType40"><span></span>점포용 제품</label>
						</c:if>
						<c:if test="${productDevDoc.productDocType == '2'}">
							<input type="radio" name="dialog_calcType" id="radio_caclType40" value="50" checked="checked" ><label for="radio_caclType40"><span></span>OEM 제품</label>
						</c:if>
                    </dd>
                </li>
                <li id="calcTypeLi2" style="display:none">
                    <dt>수식타입</dt>
                    <dd>
                    	<input type="radio" name="dialog_calcType" id="radio_caclType4" value="3" ><label for="radio_caclType4"><span></span>3번코드</label>
						<input type="radio" name="dialog_calcType" id="radio_caclType5" value="7" ><label for="radio_caclType5"><span></span>7번코드</label>
						<input type="radio" name="dialog_calcType" id="radio_caclType10" value="10" ><label for="radio_caclType10"><span></span>프리믹스</label>
                    </dd>
                </li>
             </ul>
        </div>
        <div class="btn_box_con">
            <button class="btn_admin_red" onclick="goCreateMfgDoc()">${productDocTypeName}제조공정서 생성</button>
            <button class="btn_admin_gray" onClick="closeDialogWithClean('dialog_create')">생성 취소</button>
        </div>
    </div>
</div>
<!-- 제조공정서 생성레이어 close-->
<!-- 디자인의뢰서 생성레이어 start-->
<!-- 신규로 레이어창을 생성하고싶을때는  아이디값 교체-->
<!-- 클래스 옆에 적힌 스타일 값을 인라인으로 작성해서 팝업 사이즈를 직접 조정 -->
<div class="white_content" id="dialog_design">
    <div class="modal" style="margin-left:-305px;width:610px;height: 380px;margin-top:-160px">
        <h5 style="position:relative">
            <span class="title">디자인의뢰서 생성</span>
            <div class="top_btn_box">
                <ul>
                    <li>
                        <button class="btn_madal_close" onClick="closeDialog('dialog_design')"></button>
                    </li>
                </ul>
            </div>
        </h5>
        <div class="list_detail">
        	<form id="designRequestForm">
	            <ul>
	                <li class="pt10 mb5">
	                    <dt style="width:35%">생성타입</dt>
	                    <dd style="width:65%">
                            <input type="radio" id="radio_design1" name="createType" value="N" checked><label for="radio_design1"><span></span>신규생성</label>
                            <input type="radio" id="radio_design2" name="createType" value="S"><label for="radio_design2"><span></span>임시저장파일</label>
                            <input type="radio" id="radio_design3" name="createType" value="T"><label for="radio_design3"><span></span>템플릿</label>
	                    </dd>
	                </li>
	                <li class=" mb5">
	                    <dt style="width:35%">디자인의뢰서 리스트</dt>
	                    <dd style="width:65%">
	                        <div class="selectbox req" style="width:347px;">
	                            <label for="ex_select3">디자인의뢰서 리스트 선택</label>
	                            <select id="ex_select3">
	                                <option selected>1</option>
	                                <option>2</option>
	                            </select>
	                        </div>
	                    </dd>
	                </li>
	            </ul>
            </form>
        </div>
        <div class="btn_box_con">
            <button class="btn_admin_red" onclick="ceateDesignRequest()">디자인의뢰서 생성</button>
            <button class="btn_admin_gray" onClick="closeDialog('dialog_design')">생성 취소</button>
        </div>
    </div>
</div>
<!-- 디자인의뢰서 생성레이어 close-->

<!-- 첨부파일 추가레이어 start-->
<!-- 신규로 레이어창을 생성하고싶을때는  아이디값 교체-->
<!-- 클래스 옆에 적힌 스타일 값을 인라인으로 작성해서 팝업 사이즈를 직접 조정 -->
<div class="white_content" id="dialog_attatch">
	<div class="modal" style="margin-left: -355px; width: 710px; height: 500px; margin-top: -250px">
		<h5 style="position: relative">
			<span class="title">첨부파일 추가</span>
			<div class="top_btn_box">
				<ul>
					<li>
						<button class="btn_madal_close" onClick="closeDialogWithClean('dialog_attatch')"></button>
					</li>
				</ul>
			</div>
		</h5>
		<div class="list_detail">
			<ul>
				<li class="pt10 mb5">
					<dt style="width: 20%">파일 선택</dt>
					<dd style="width: 80%" class="ppp">
						<div style="float: left; display: inline-block;">
							<span class="file_load" id="fileSpan">
								<input id="attatch_common_text" class="form-control form_point_color01" type="text" placeholder="파일을 선택해주세요." style="width:145px;/* width:308px;  */float:left; cursor: pointer; color: black;" onclick="callAddFileEvent()" readonly="readonly">
								<!-- <label class="btn-default" for="attatch_common" style="float:left; margin-left: 5px; width: 57px">파일 선택</label> -->
								<input id="attatch_common" type="file" style="display:none;" onchange="setFileName(this)">
							</span>
							<button class="btn_small02 ml5" onclick="addFile(this, '60')">제품이미지</button>
							<button class="btn_small02 ml5" onclick="addFile(this, '10')">포장지 시안</button>
							<button class="btn_small02 ml5" onclick="addFile(this, '30')">품목제조보고서 사본</button>
							<!-- 
							<button class="btn_small02 ml5" onclick="addFile(this, '40')">HACCP 문서</button>
							 -->
						</div>
						<div style="float: left; display: inline-block; margin-top: 5px">
							
						</div>
					</dd>
				</li>
				<li class=" mb5">
					<dt style="width: 20%">파일리스트</dt>
					<dd style="width: 80%;">
						<div class="file_box_pop" style="width:95%">
							<ul name="popFileList"></ul>
						</div>
					</dd>
				</li>
			</ul>
		</div>
		<div class="btn_box_con">
			<button class="btn_admin_red" onclick="uploadFiles();">파일 등록</button>
			<button class="btn_admin_gray" onClick="closeDialogWithClean('dialog_attatch')">등록 취소</button>
		</div>
	</div>
</div>
<!-- 파일 생성레이어 close-->
<!-- 수정내역 레이어 start-->
<!-- 신규로 레이어창을 생성하고싶을때는  아이디값 교체-->
<!-- 클래스 옆에 적힌 스타일 값을 인라인으로 작성해서 팝업 사이즈를 직접 조정 -->
<div class="white_content" id="dialog_comment">
	<input id="userGrade" type="hidden" value="${userUtil:getUserGrade(pageContext.request)}">
	<input id="isAdmin" type="hidden" value="${userUtil:getIsAdmin(pageContext.request)}">
	
	<div class="modal" style="margin-left: -500px; width: 1000px; height: 600px; margin-top: -300px">
		<h5 style="position: relative">
			<span class="title">수정내역</span>
			<div class="top_btn_box"><ul><li><button class="btn_madal_close" onClick="closeDialogWithClean('dialog_comment')"></button></li></ul></div>
		</h5>
		<div class="list_detail">
			<ul>
				<li class="pt10">
					<dt id="layerCommentCnt" style="width: 20%">의견</dt>
					<dd style="width: 80%;">
						<div class="insert_comment">
							<table style="width: 756px">
								<tr>
									<td>
										<input id="commentTbType" type="hidden" value="">
										<input id="commentTbKey" type="hidden" value="">
										<textarea id="commentText" style="width: 100%; height: 50px" placeholder="의견을 입력하세요"></textarea>
									</td>
									<td width="98px">
										<button style="width: 100%; height: 52px; margin-top: -2px; font-size: 13px" onclick="addComment()">등록</button>
									</td>
								</tr>
							</table>
						</div>
						<div id="commentListDiv" class="app_comment" style="height: 350px; margin-top:15px;">
							<!-- 일반댓글obj start-->
							<div class="comment_obj2">
								<span class="comment_id">동동이 관리자</span>
								<span class="comment_date">2019.01.12 22:22:00
								<a href="#"><img src="/resources/images/icon_doc03.png"> 수정</a>
								 | <a href="#"><img src="/resources/images/icon_doc04.png"> 삭제</a>
								<span class="comment_data">(Reply 내용)</span>
							</div>
							<!-- 일반댓글obj close-->

							<!-- 일반댓글수정  start-->
							<div class="comment_obj2">
								<div class="insert_comment">
									<table style="width: 738px; margin-left: 2px;">
										<tr>
											<td><textarea style="width: 100%; height: 50px; background-color: #fffeea;" placeholder="의견을 입력하세요"></textarea></td>
											<td width="81px"><button style="width: 95%; height: 52px; margin-top: -2px; font-size: 13px;">수정</button></td>
											<td width="80px"><button style="width: 100%; height: 52px; margin-top: -2px; font-size: 13px;">수정취소</button></td>
										</tr>
									</table>
								</div>
							</div>
							<!-- 일반댓글 수정obj close-->
							<!-- 일반댓글obj start-->
							<div class="comment_obj2">
								<span class="comment_id">persepho</span>
								<span class="comment_date">2019.01.12 22:22:00</span>
								<span class="comment_data">리플내용리플내용리플내용리플내용리플내용리플내용리플내용</span>
							</div>
							<!-- 일반댓글obj close-->
							<!-- 일반댓글obj start-->
							<div class="comment_obj2">
								<span class="comment_data">입력된 수정내역이 없습니다.</span>
							</div>
							<!-- 일반댓글obj close-->
						</div>
					</dd>
				</li>
			</ul>
		</div>
	</div>
</div>
<!-- 수정내역 레이어 생성레이어 close-->

<!-- 이력내역 레이어 start-->
<div class="white_content" id="dialog_history">
	<div class="modal"
		style="margin-left: -300px; width: 500px; height: 420px; margin-top: -210px">
		<h5 style="position: relative">
			<span class="title">이력</span>
			<div class="top_btn_box">
				<ul>
					<li><button class="btn_madal_close" onClick="closeDialog('dialog_history')"></button></li>
				</ul>
			</div>
		</h5>
		<div class="list_detail">
			<ul id="historyDiv" class="pop_notice_con history_option">
				<!-- 
				<li>신선한 생크신선한 생크림신선한 생크림신선한 생크림신선한 생크림신선한 생크림신선한 생크림신선한 생크림신선한
					생크림신선한 생크림신선한 생크림신선한 생크림림빵 문서가 <strong>수정</strong>되었습니다.<span
					class="icon_new">N</span><br /> <span class="date">2019.01.12
						02:02:02</span>
				</li>
				<li>신선한 생크림빵 문서가 <strong>수정</strong>되었습니다.<span
					class="icon_new">N</span><br /> <span class="date">2019.01.12
						02:02:02</span>
				</li>
				<li>신선한 생크림빵 문서가 <strong>수정</strong>되었습니다.<span
					class="icon_new">N</span><br /> <span class="date">2019.01.12
						02:02:02</span>
				</li>
				<li>신선한 생크림빵 문서가 <strong>수정</strong>되었습니다.<span
					class="icon_new">N</span><br /> <span class="date">2019.01.12
						02:02:02</span>
				</li>
				<li>신선한 생크림빵 문서가 <strong>수정</strong>되었습니다.<span
					class="icon_new">N</span><br /> <span class="date">2019.01.12
						02:02:02</span>
				</li>
				<li><span class="notice_none">등록된 이력이 없습니다.</span></li>
				
				<li><span class="notice_none">이력은 최근 3일치만 제공합니다.</span></li>
				 -->
			</ul>
		</div>
		<div class="btn_box_con4" style="padding: 15px 0 20px 0">
			<button class="btn_admin_red" onclick="closeDialog('dialog_history')">확인</button>
		</div>
	</div>
</div>
<!-- 이력내역 레이어 생성레이어 close-->

<!-- 제품개발문서 상태변경 레이어 start-->
<div class="white_content" id="dialog_state">
	<div class="modal positionCenter" style="width: 800px; height: 320px;">
		<h5 style="position: relative">
			<span class="title">제품개발문서 상태변경</span>
			<div class="top_btn_box">
				<ul>
					<li>
						<button class="btn_madal_close" onClick="closeDialogWithClean('dialog_state')"></button>
					</li>
				</ul>
			</div>
		</h5>
		<div class="list_detail">
			<div class="main_tbl" style="padding-bottom: 40px;">
				<form id="changeStateForm">
					<input type="hidden" name="ddNo" value="${productDevDoc.ddNo}">
					<input type="hidden" name="docNo" value="${productDevDoc.docNo}">
					<input type="hidden" name="docVersion" value="${productDevDoc.docVersion}">
					<input type="hidden" name="regUserId" value="${productDevDoc.regUserId}">
					<input type="hidden" name="isClose" value="">
					<ul>
						<li>
							<dt>중단/보류 메모</dt>
							<dd class="pr20 pb20">
								<textarea name="closeMemo" style="width: 100%; height: 60px"></textarea>
							</dd>
						</li>
					</ul>
				</form>
			</div>
		</div>
		<div class="btn_box_con">
			<button class="btn_admin_red" onclick="changeDevDocState()">보류/중단</button>
			<button class="btn_admin_gray" onClick="closeDialogWithClean('dialog_state')">취소</button>
		</div>
	</div>
</div>
<!-- 제품개발문서 상태변경 레이어 close-->






<input type="hidden" id="hiddenDocNo" value="${docNo}"/>
<input type="hidden" id="hiddenDocVersion" value="${docVersion}"/>
<input type="hidden" id="deptFulName" />
<input type="hidden" id="titCodeName" />
<input type="hidden" id="userId" />
<input type="hidden" id="userName"/>
<input type="hidden" id="loginUserId"/> 

<div class="white_content" id="approval_design">
 
					<input type="hidden" name="tbKey"  id="tbKey" value="" />					
					<input type="hidden" name="tempKey" id="tempKey" value=""/>
					<input type="hidden" name="userId1" id="userId1"  />
					<input type="hidden" name="userId2" id="userId2" />
					<input type="hidden" name="userId3" id="userId3" />
					<input type="hidden" name="userId4" id="userId4" />
					<input type="hidden" name="userId5" id="userId5" />
					<input type="hidden" name="userId6" id="userId6" />
 					<input type="hidden" name="userIdDesignArr" id="userIdDesignArr" />
 					
		<div class="modal" style="	margin-left:-500px;width:1000px;height: 620px;margin-top:-330px">
		  <h5 style="position:relative">
				<span class="title">디자인의뢰서 결재 상신</span>
				<div  class="top_btn_box">
					<ul><li><button class="btn_madal_close" onClick="closeDialog('approval_design'); return false;"></button></li></ul>
				</div>
			</h5>
			<div class="list_detail">
		<ul>
		<li class="pt10 mb5">
		<dt style="width:20%">제목</dt>
				<dd style="width:80%">
		<input type="text" class="req" style="width:573px" id="designTitle">
				</dd>
			</li>
								<li>
		
			
			<dt style="width:20%">의견</dt><dd style="width:80%;">
				
								<div class="insert_comment">
									<table style=" width:756px">
										<tr><td><textarea style="width:100%; height:50px" placeholder="의견을 입력하세요" id="design_comment"></textarea></td><td width="98px"></td></tr>
									</table>
								</div>
				</dd>
			</li>
			<li>
		
			
			<dt style="width:20%">결재자 입력</dt><dd style="width:80%;" class="ppp">
				<input type="text" placeholder="결재자명 2자이상 입력후 선택" style="width:230px; float:left;" class="req" id="designKeyword"><button class="btn_small01 ml5" onclick="approvalAddLine(this); return false;" name="baseApprovalDesign">결재자 추가</button><!-- <button class="btn_small01 ml5" onclick="approvalAddLine(this); return false;" name="firstPayment">1차결재자로 추가</button><button class="btn_small01 ml5" onclick="approvalAddLine(this); return false;" name="secondPayment">2차결재 </button><button class="btn_small01 ml5" onclick="approvalAddLine(this); return false;" name="marketingPayment">마케팅</button> --><button class="btn_small02  ml5" onclick="approvalAddLine(this); return false;" name="circulationPayment">회람</button><button class="btn_small02  ml5" onclick="approvalAddLine(this); return false;" name="referPayment">참조</button>
				
				
				<div class="selectbox ml5" style="width:180px;">
				<label for="apprLineSelect">---- 결재선 불러오기 ----</label>
						<select id="apprLineSelect" onchange="changeApprLine(this); return false;">
						<!-- 	<option selected>디자인의뢰기본결재1</option>
							<option>기본2</option> -->
						</select>
						</div>
				<button class="btn_small02  ml5" onclick="deleteApprovalLine(this); return false;">선택 결재선 삭제</button>
				</dd>
			</li>
				<li  class="mt5">
		
			
				<dt style="width:20%; background-image:none;" ></dt><dd style="width:80%;">
				<div class="file_box_pop2" >
	
	<ul id="apprLine">
		
		<!-- <li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="s01"> 기안자</span> 이성희 <strong> 부장/총무부</strong></li>
		
		<li id="designPayment1"><img src="../resources/images/icon_del_file.png" name="delImg"><span>1차 검토 </span>  <strong></strong></li>
		
		<li> <a href="11.html"> <img src="../resources/images/icon_del_file.png"></a> <span> 2차결재자</span> 이성희 <strong> 부장/총무부</strong></li>
		
		<li id="designPaymentMarketing"><img src="../resources/images/icon_del_file.png" name="delImg"><span>마케팅 </span>  <strong></strong></li> -->
	</ul>
						</div>
						<div class="file_box_pop3" >
	
	<ul id="CirculationRefLine">
<!-- 	<li> <a href="11.html"> <img src="../resources/images/icon_del_file.png"></a> <span> 회람</span> 이성희 <strong> 부장/총무부</strong></li>
		<li> <a href="11.html"> <img src="../resources/images/icon_del_file.png"></a> <span> 참조</span> 이성희 <strong> 부장/총무부</strong></li> -->

	</ul>
						</div>
						<!-- 현재 추가된 결재선 저장 버튼을 누르면 안보이게 처리 start -->
						<!--div class="app_line_edit">
						<button class="btn_doc"><img src="images/icon_doc11.png"> 현재 추가된 결재선 저장</button>  |  <button class="btn_doc"><img src="images/icon_doc04.png"> 현재 표시된 결재선 삭제</button></div-->	
						<!-- 현재 추가된 결재선 저장 버튼을 누르면 안보이게 처리 close -->
						<!-- 현재 추가된 결재선 저장 버튼 눌렀을때 보이게 처리 start -->
						<div class="app_line_edit">저장 결재선명 입력 :  <input type="text" class="req" style="width:280px;"/> <button class="btn_doc" onclick="approvalLineSave(this); return false;"><img src="../resources/images/icon_doc11.png"> 저장</button> |  <button class="btn_doc" onclick="approvalLineCancel(this); return false;"><img src="../resources/images/icon_doc04.png">취소</button>
						</div>
						<!-- 현재 추가된 결재선 저장 버튼 눌렀을때 보이게 처리 close -->
		</dd>	</li>
		</ul>
	</div>
			<div class="btn_box_con4" style="padding:15px 0 20px 0"><button class="btn_admin_red" onclick="doSubmit(); return false;">결재상신</button> <button class="btn_admin_gray" onclick="closeDialog('approval_design'); return false;">상신 취소</button></div>
</div>
</div>

	<!-- 디자인의뢰서 결재 레이어 생성레이어 close-->
 <div class="white_content" id="approval_manu">
 		<input type="hidden" name="jobtypeManu" id="jobtypeManu" value="popup"/>
					<input type="hidden" name="userId1Manu" id="userId1Manu" value="${userId}" />
					<input type="hidden" name="userId2Manu" id="userId2Manu" />
					<input type="hidden" name="userId3Manu" id="userId3Manu" />
					<input type="hidden" name="userId4Manu" id="userId4Manu" />
					<input type="hidden" name="userId5Manu" id="userId5Manu" />
					<input type="hidden" name="userId6Manu" id="userId6Manu" />
					<input type="hidden" name="userId7Manu" id="userId7Manu" />					
					<input type="hidden" name="userId8Manu" id="userId8Manu" />
					<input type="hidden" name="userIdManuArr" id="userIdManuArr"/>
					<!-- <input type="hidden" name="referenceId" id="referenceId" />
					<input type="hidden" name="circulationId" id="circulationId" /> -->
					<input type="hidden" name="tbKeyManu" id="tbKeyManu" value=""/>
					<input type="hidden" name="totalStepManu" id="totalStepManu" value="6"/>
					<input type="hidden" name="typeManu" id="typeManu" value="0"/>
					<input type="hidden" name="docNoManu" id="docNoManu" value="${docNo}" />
					<input type="hidden" name="docVersionManu" id="docVersionManu" value="${docVersion}" />
 					<input type="hidden" name="ManuCompanyCd" id="ManuCompanyCd" />
		<div class="modal" style="	margin-left:-500px;width:1000px;height: 550px;margin-top:-300px">
		  <h5 style="position:relative">
				<span class="title">제조공정서 결재 상신</span>
				<div  class="top_btn_box">
					<ul><li><button class="btn_madal_close" onClick="closeDialog('approval_manu'); return false;"></button></li></ul>
				</div>
			</h5>
			<div class="list_detail">
		<ul>
		<li class="pt10">
		<dt style="width:20%">제목</dt>
				<dd style="width:80%">
		<input type="text" class="req"/ style="width:573px" id="manuTitle">
				</dd>
			</li>

<li><dt style="width:20%">제품출시일</dt><dd style="width:80%"><input type="text" style="width:170px;" class="req" id="launchDateManu"/> <!-- <a href="#"><img src="../resources/images/btn_calendar.png" style=" margin-top:-4px;"></a> --></dd></li>

<li>
		
			
			<dt style="width:20%">의견</dt><dd style="width:80%;">
				
								<div class="insert_comment">
									<table style=" width:756px">
										<tr><td><textarea style="width:100%; height:50px" placeholder="의견을 입력하세요" id="manu_comment"></textarea></td><td width="98px"></td></tr>
									</table>
								</div>
				</dd>
			</li>
			<li class="pt5">
		
			
			<dt style="width:20%">결재자 입력</dt><dd style="width:80%;" class="ppp">
			<input type="text" placeholder="결재자명 2자이상 입력후 선택" style="width:198px; float:left;" class="req" id="manufacKeyword" name="manufacKeyword"><!-- <button class="btn_small01 ml5" onclick="approvalAddLine(this); return false;" name="firstPayment">합의1</button><button class="btn_small01 ml5" onclick="approvalAddLine(this); return false;" name="secondPayment">합의2</button><button class="btn_small01 ml5" onclick="approvalAddLine(this); return false;" name="parterPayment">파트장</button><button class="btn_small01 ml5" onclick="approvalAddLine(this); return false;" name="leaderPayment">팀장</button><button class="btn_small01 ml5" onclick="approvalAddLine(this); return false;" name="directorPayment">연구소장</button> --><button class="btn_small01 ml5" onclick="approvalAddLine(this); return false;" name="baseApprovalManu">결재자 추가</button><button class="btn_small02  ml5" onclick="approvalAddLine(this); return false;" name="circulationPayment">회람</button><button class="btn_small02  ml5" onclick="approvalAddLine(this); return false;" name="referPayment">참조</button>
				
				
					<div class="selectbox ml5" style="width:180px;">
						<label for="apprLineSelectManu">---- 결재선 불러오기 ----</label>
						<select id="apprLineSelectManu" onchange="changeApprLine(this); return false;"></select>
					</div>
					<button class="btn_small02  ml5" onclick="deleteApprovalLine(this); return false;">선택 결재선 삭제</button>
				</dd>
			</li>
				<li  class="mt5">
		
			
				<dt style="width:20%; background-image:none;" ></dt><dd style="width:80%;">
				<div class="file_box_pop2" style="height:190px;">
	<ul id="apprLineManu">
		<!-- <li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="s01"> 기안자</span> 이성희 <strong> 부장/총무부</strong></li>
		<li> <a href="11.html"> <img src="../resources/images/icon_del_file.png"></a> <span>합의1</span> 이성희 <strong> 부장/총무부</strong></li>
		<li> <a href="11.html"> <img src="../resources/images/icon_del_file.png"></a> <span>합의2</span> 이성희 <strong> 부장/총무부</strong></li>
		<li> <a href="11.html"> <img src="../resources/images/icon_del_file.png"></a> <span>팀장</span> 이성희 <strong> 부장/총무부</strong></li>
		<li> <a href="11.html"> <img src="../resources/images/icon_del_file.png"></a><span>연구소장</span> 이성희 <strong> 부장/총무부</strong></li>
		<li> <a href="11.html"> <img src="../resources/images/icon_del_file.png"></a><span>파트장</span> 이성희 <strong> 부장/총무부</strong></li> -->

	</ul>
						</div>
						<div class="file_box_pop3" style="height:190px;">
	<ul id="CirculationRefLineManu">
		<!-- <li> <a href="11.html"> <img src="../resources/images/icon_del_file.png"></a> <span> 회람</span> 이성희 <strong> 부장/총무부</strong></li>
		<li> <a href="11.html"> <img src="../resources/images/icon_del_file.png"></a> <span> 참조</span> 이성희 <strong> 부장/총무부</strong></li> -->

	</ul>
						</div>
							
							
					
						
						<!-- 현재 추가된 결재선 저장 버튼을 누르면 안보이게 처리 start -->
						<!--div class="app_line_edit">
						<button class="btn_doc"><img src="images/icon_doc11.png"> 현재 추가된 결재선 저장</button>  |  <button class="btn_doc"><img src="images/icon_doc04.png"> 현재 표시된 결재선 삭제</button></div-->	
						<!-- 현재 추가된 결재선 저장 버튼을 누르면 안보이게 처리 close -->
						<!-- 현재 추가된 결재선 저장 버튼 눌렀을때 보이게 처리 start -->
						<div class="app_line_edit">저장 결재선명 입력 :  <input type="text" class="req" style="width:280px;"/> <button class="btn_doc" onclick=" approvalLineSave(this);  return false;"><img src="../resources/images/icon_doc11.png"> 저장</button> |  <button class="btn_doc" onclick="approvalLineCancel(this); return false;"><img src="../resources/images/icon_doc04.png">취소</button>
						</div>
						<!-- 현재 추가된 결재선 저장 버튼 눌렀을때 보이게 처리 close -->
		</dd>	</li>
		
		</ul>
	</div>
			<div class="btn_box_con4" style="padding:15px 0 20px 0"><button class="btn_admin_red" onclick="doSubmitManu(); return false;">결재상신</button> <button class="btn_admin_gray" onclick="closeDialog('approval_manu'); return false;">상신 취소</button></div>
</div>
</div>

<div class="white_content" id="dialog_qns">
	<input id="dialog_qns_dNo" type="hidden">

	<div class="modal positionCenter" style="width: 700px;">
		<h5 style="position: relative">
			<span class="title">QNSH 등록번호 입력</span>
			<div class="top_btn_box">
				<ul>
					<li>
						<button class="btn_madal_close" onClick="closeQnsDialog('dialog_qns')"></button>
					</li>
				</ul>
			</div>
		</h5>
		<div class="list_detail"> 
			<ul>
				<li>
					<dt style="width: 30%">QNSH 등록번호</dt>
					<dd style="width: 70%"><input id="dialog_qns_no" type="input" class="req"></dd>
				</li>
				<li>
					<dt style="width: 30%">QNSH 검토대상</dt>
					<dd style="width: 70%; padding-top:3px;">
						<input type="radio" id="isQnsReviewTarget1" name="isQnsReviewTarget" value="1" checked/> 
						<label for="isQnsReviewTarget1"><span></span>대상</label>
						<input type="radio" id="isQnsReviewTarget2" name="isQnsReviewTarget" value="0"/>
						<label for="isQnsReviewTarget2"><span></span>해당 제품은 QNSH 검토 대상이 아님. ex)수출용, 반제품</label>
					</dd>
				</li>
			</ul>
		</div>
		<div class="btn_box_con">
			<button class="btn_admin_red" onclick="updateQns()">수정</button>
			<button class="btn_admin_gray" onClick="closeQnsDialog('dialog_qns')">취소</button>
		</div>
	</div>
</div>

<div class="white_content" id="dialog_set_qnsh">
	<input id="dialog_qns_dNo" type="hidden">

	<div class="modal positionCenter" style="width: 450px;">
		<h5 style="position: relative">
			<span class="title">QNSH 항목 선택</span>
			<div class="top_btn_box">
				<ul>
					<li>
						<button class="btn_madal_close" onClick="closeSetQnshDialog('dialog_set_qnsh')"></button>
					</li>
				</ul>
			</div>
		</h5>
		<div class="list_detail">
			<ul>
				<li>
					<dt>QNSH 항목</dt>
					<dd>
						<div id="dialog_set_qnsh_category" class="selectbox req ml5" style="width:200px; position: relative;">  
							<select id="qnsh_category_select" name="qnsh_category_select">
								<option value="">선택</option>
								<option value="01">전략직수입</option>
								<option value="02">수출품</option>
								<option value="03">직수입</option>
								<option value="04">내자(국내)</option>
								<option value="05">내자(수입)</option>
								<option value="06">상품(국내)</option>
								<option value="07">상품(수입)</option>
								<option value="08">OEM</option>
								<option value="09">표시사항</option>
								<option value="10">기구,용기포장(국내)</option>
								<option value="11">기구,용기포장(수입)</option>
								<option value="12">화학제</option>
								<option value="13">위생용품</option>
								<option value="14">판촉물</option>
								<option value="15">네임텍</option>
								<option value="16">홍보물</option>
								<option value="17">보도자료</option>
								<option value="18">홈페이지</option>
							</select>
							<label id="label_qnsh_category_select" for="qnsh_category_select">선택</label> 
						</div>					
					</dd>
				</li>
			</ul>
		</div>
		<div class="btn_box_con">
			<button class="btn_admin_red" onclick="setQNSDocument()">저장</button>
			<button class="btn_admin_gray" onClick="closeSetQnshDialog('dialog_set_qnsh')">취소</button>
		</div>
	</div>
</div>

<!-- 시생산보고서 결재 레이어 생성레이어 close-->
<div class="white_content" id="approval_trialprodreport">
	<input type="hidden" name="jobtypeTrial" id="jobtypeTrial" value="popup"/>
	<input type="hidden" name="userId1Trial" id="userId1Trial" value="${userId}" />
	<input type="hidden" name="userId2Trial" id="userId2Trial" />
	<input type="hidden" name="userId3Trial" id="userId3Trial" />
	<input type="hidden" name="userId4Trial" id="userId4Trial" />
	<input type="hidden" name="userId5Trial" id="userId5Trial" />
	<input type="hidden" name="userId6Trial" id="userId6Trial" />
	<input type="hidden" name="userId7Trial" id="userId7Trial" />
	<input type="hidden" name="userId8Trial" id="userId8Trial" />
	<input type="hidden" name="userIdTrialArr" id="userIdTrialArr"/>
	<input type="hidden" name="tbKeyTrial" id="tbKeyTrial" value=""/>
	<input type="hidden" name="totalStepTrial" id="totalStepTrial" value="6"/>
	<input type="hidden" name="typeTrial" id="typeTrial" value="0"/>
	<input type="hidden" name="docNoTrial" id="docNoTrial" value="${docNo}" />
	<input type="hidden" name="docVersionTrial" id="docVersionTrial" value="${docVersion}" />
	<input type="hidden" name="TrialCompanyCd" id="TrialCompanyCd" />
	
	<div class="modal" style="	margin-left:-500px;width:1000px;height: 550px;margin-top:-300px">
		<h5 style="position:relative">
			<span class="title">시생산 보고서 결재 상신</span>
			<div  class="top_btn_box">
				<ul><li><button class="btn_madal_close" onClick="closeDialog('approval_trialprodreport'); return false;"></button></li></ul>
			</div>
		</h5>
		<div class="list_detail">
			<ul>
				<li class="pt10">
					<dt style="width:20%">제목</dt>
					<dd style="width:80%"><input type="text" class="req" style="width:573px" id="trialTitle"></dd>
				</li>
				<!--
				<li>
					<dt style="width:20%">제품출시일</dt>
					<dd style="width:80%"><input type="text" style="width:170px;" class="req" id="launchDateTrial"/></dd>
				</li>
				-->
				<li>
					<dt style="width:20%">의견</dt>
					<dd style="width:80%;">
						<div class="insert_comment">
							<table style=" width:756px">
								<tr><td><textarea style="width:100%; height:50px" placeholder="의견을 입력하세요" id="trialComment"></textarea></td><td width="98px"></td></tr>
							</table>
						</div>
					</dd>
				</li>
				<li class="pt5">
					<dt style="width:20%">결재자 입력</dt>
					<dd style="width:80%;" class="ppp">
						<input type="text" placeholder="결재자명 2자이상 입력후 선택" style="width:198px; float:left;" class="req" id="trialKeyword" name="trialKeyword">
						<button class="btn_small01 ml5" onclick="approvalAddLine(this); return false;" name="baseApprovalTrial">결재자 추가</button>
						<button class="btn_small02  ml5" onclick="approvalAddLine(this); return false;" name="circulationPayment">회람</button>
						<button class="btn_small02  ml5" onclick="approvalAddLine(this); return false;" name="referPayment">참조</button>
						
						<div class="selectbox ml5" style="width:180px;">
							<label for="apprLineSelectTrial">---- 결재선 불러오기 ----</label>
							<select id="apprLineSelectTrial" onchange="changeApprLine(this); return false;"></select>
						</div>
						<button class="btn_small02  ml5" onclick="deleteApprovalLine(this); return false;">선택 결재선 삭제</button>
					</dd>
				</li>
				<li  class="mt5">
					<dt style="width:20%; background-image:none;" ></dt>
					<dd style="width:80%;">
						<div class="file_box_pop2" style="height:190px;">
							<ul id="apprLineTrial"></ul>
						</div>
						<div class="file_box_pop3" style="height:190px;">
							<ul id="CirculationRefLineTrial">
							</ul>
						</div>
						<div class="app_line_edit">
							저장 결재선명 입력 :  <input type="text" class="req" style="width:280px;"/>
							<button class="btn_doc" onclick=" approvalLineSave(this);  return false;">
							<img src="../resources/images/icon_doc11.png">저장</button> |  <button class="btn_doc" onclick="approvalLineCancel(this); return false;">
							<img src="../resources/images/icon_doc04.png">취소</button>
						</div>
					</dd>
				</li>
			</ul>
		</div>
		<div class="btn_box_con4" style="padding:15px 0 20px 0">
			<button class="btn_admin_red" onclick="doSubmitTrial(); return false;">결재상신</button>
			<button class="btn_admin_gray" onclick="closeDialog('approval_trialprodreport'); return false;">상신 취소</button>
		</div>
	</div>
</div>
<!-- BOM 반영 사전 확인 결과 레이어 start-->
<div class="white_content" id="bom_item_check">
   <div class="modal" style="margin-left: -350px; width:700px; height: 720px; margin-top: -320px">
      <h5 style="position: relative">
         <span class="title">BOM 항목 사전 점검</span>
         <div class="top_btn_box"><ul><li><button class="btn_madal_close" onClick="closeDialogWithClean('bom_item_check')"></button></li></ul></div>
      </h5>
      <div class="group01">
         <div class="tab03">
            <ul id="bom_item_check_tab">
               <!-- 선택됬을경우는 탭 클래스에 select를 넣어주세요 -->
               <!-- 내 제품개발문서 같은경우는 change select 이렇게 change 그대로 두고 한칸 띄고 select 삽입 -->
               <a href="javascript:changeOwnerType('all')"><li class="select">전체</li></a>                           
            </ul>
         </div>
         <div id="bom_item_check_body">
            <div class="prodoc_title" style="margin-bottom: 30px;">
               <div style="display: inline-block; height: 80px; width: 100%; padding-top: 10px;">
                  <span class="font17">제품명 : 꼬베)온가족꿀호떡 - BOM 테스트 문서</span>
                  <br><span class="font18">제품코드 : 100001</span>
                  <br><span class="font18">회사 : [과자류, 빵류, 떡류&gt;빵류] <strong>&nbsp;|&nbsp;</strong> 공장 : </span>                  
                   
               </div>
            </div>
            <div class="main_tbl">
               <table class="tbl01" >
                  <colgroup>
                     <col width="25%">
                     <col width="25%">
                     <col width="25%">
                     <col width="25%">
                  </colgroup>
                  <thead>
                     <tr>
                        <th>SAP코드</th>
                        <th>자재명</th>
                        <th>단위</th>
                        <th>상태</th>
                     <tr>
                  </thead>
                  <tbody>
                     <tr>
                        <td colspan="4">원료코드 혹은 원료코드명을 검색해주세요</td>
                     </tr>
                  </tbody>
               </table>
            </div>   
      </div>
      </div>
   </div>
</div>
<!-- BOM 반영 사전 확인 결과 레이어 close-->
<div id="element_to_pop_up" class='popup_style'>
<div class="popup_content"></div>



    <!--품목제조보고서 중단요청 결재상신 start-->
    <div class="white_content" id="approval_manufacturingNo">
        <%--	<input type="hidden" name="jobtypeManu" id="jobtypeManu" value="popup"/>--%>
        <input type="hidden" name="userId1ManufacturingNo" id="userId1ManufacturingNo" value="${userId}" />
        <input type="hidden" name="userId2ManufacturingNo" id="userId2ManufacturingNo" />
        <input type="hidden" name="userId3ManufacturingNo" id="userId3ManufacturingNo" />
        <input type="hidden" name="userId4ManufacturingNo" id="userId4ManufacturingNo" />
        <input type="hidden" name="userId5ManufacturingNo" id="userId5ManufacturingNo" />
        <input type="hidden" name="userId6ManufacturingNo" id="userId6ManufacturingNo" />
        <input type="hidden" name="userId7ManufacturingNo" id="userId7ManufacturingNo" /><!--참조-->
        <input type="hidden" name="userId8ManufacturingNo" id="userId8ManufacturingNo" /><!--회람-->
        <input type="hidden" name="userIdManufacturingNoArr" id="userIdManufacturingNoArr"/>
        <input type="hidden" name="tbKeyManufacturingNo" id="tbKeyManufacturingNo" value=""/>
        <input type="hidden" name="totalStepManufacturingNo" id="totalStepManufacturingNo" value="6"/>
        <input type="hidden" name="typeManufacturingNo" id="typeManu" value="0"/>
        <input type="hidden" name="docNoManufacturingNo" id="docNoManufacturingNo" value="${docNo}" />
        <input type="hidden" name="docVersionManufacturingNo" id="docVersionManufacturingNo" value="${docVersion}" />
        <input type="hidden" name="ManufacturingNoCompanyCd" id="ManufacturingNoCompanyCd" />
        <div class="modal" style="	margin-left:-500px;width:1000px;height: 590px;margin-top:-300px">
            <h5 style="position:relative">
                <span class="title">품목제조보고서 중단요청 결재 상신</span>
                <div  class="top_btn_box">
                    <ul><li><button class="btn_madal_close" onClick="closeDialog('approval_manufacturingNo'); return false;"></button></li></ul>
                </div>
            </h5>
            <div class="list_detail">
                <ul>
                    <li class="pt10">
                        <dt style="width:20%">제목</dt>
                        <dd style="width:80%">
                            <input type="text" class="req" style="width:573px" id="ManufacturingNoTitle">
                        </dd>
                    </li>
                    <li>
                        <dt style="width:20%">제품중단월</dt>
                        <dd style="width:80%">
                            <input type="text" style="width:170px;" class="req" id="stopMonthManufacturingNo"/>
                        </dd>
                    </li>
                    <li>
                        <dt style="width:20%">의견</dt>
                        <dd style="width:80%;">
                            <div class="insert_comment">
                                <table style=" width:756px">
                                    <tr><td><textarea style="width:100%; height:50px" placeholder="의견을 입력하세요" id="manufacturingNo_comment"></textarea></td><td width="98px"></td></tr>
                                </table>
                            </div>
                        </dd>
                    </li>
                    <li class="pt5">
                        <dt style="width:20%">결재자 입력</dt><dd style="width:80%;" class="ppp">
                        <input type="text" placeholder="결재자명 2자이상 입력후 선택" style="width:198px; float:left;" class="req" id="manufacturingNoKeyword" name="manufacturingNoKeyword">
                        <button class="btn_small01 ml5" onclick="approvalAddLine(this); return false;" name="baseApprovalManufacturingNo">결재자 추가</button>
                        <button class="btn_small02  ml5" onclick="approvalAddLine(this); return false;" name="circulationPaymentManufacturingNo">회람</button>
                        <button class="btn_small02  ml5" onclick="approvalAddLine(this); return false;" name="referPaymentManufacturingNo">참조</button>
                        <div class="selectbox ml5" style="width:180px;">
                            <label for="apprLineSelectManufacturingNo">---- 결재선 불러오기 ----</label>
                            <select id="apprLineSelectManufacturingNo" onchange="changeApprLine(this); return false;"></select>
                        </div>
                        <button class="btn_small02  ml5" onclick="deleteApprovalLine(this); return false;">선택 결재선 삭제</button>
                    </dd>
                    </li>
                    <li  class="mt5">
                        <dt style="width:20%; background-image:none;" ></dt><dd style="width:80%;">
                        <div class="file_box_pop2" style="height:190px;">
                            <ul id="apprLineManufacturingNo"></ul>
                        </div>
                        <div class="file_box_pop3" style="height:190px;">
                            <ul id="CirculationRefLineManufacturingNo"></ul>
                        </div>




                        <!-- 현재 추가된 결재선 저장 버튼을 누르면 안보이게 처리 start -->
                        <!--div class="app_line_edit">
                        <button class="btn_doc"><img src="images/icon_doc11.png"> 현재 추가된 결재선 저장</button>  |  <button class="btn_doc"><img src="images/icon_doc04.png"> 현재 표시된 결재선 삭제</button></div-->
                        <!-- 현재 추가된 결재선 저장 버튼을 누르면 안보이게 처리 close -->
                        <!-- 현재 추가된 결재선 저장 버튼 눌렀을때 보이게 처리 start -->
                        <div class="app_line_edit">저장 결재선명 입력 :  <input type="text" class="req" style="width:280px;" data-type="111"/> <button class="btn_doc" onclick=" approvalLineSave(this);  return false;"><img src="../resources/images/icon_doc11.png"> 저장</button> |  <button class="btn_doc" onclick="approvalLineCancel(this); return false;"><img src="../resources/images/icon_doc04.png">취소</button>
                        </div>
                        <!-- 현재 추가된 결재선 저장 버튼 눌렀을때 보이게 처리 close -->
                    </dd>	</li>

                </ul>
            </div>
            <div class="btn_box_con4" style="padding:15px 0 20px 0"><button class="btn_admin_red" onclick="doSubmitManufacturingNo(); return false;">결재상신</button> <button class="btn_admin_gray" onclick="closeDialog('approval_manufacturingNo'); return false;">상신 취소</button></div>
        </div>
    </div>

    <!--품목제조보고서 중단요청 결재상신 end-->

</div>

<script type="text/javascript"> 
	var attatchFileArr = [];
	var attatchFileTypeArr = [];
	
	$(document).ready(function(){
		
		loadCompany('companyCode');
		loadManufacturingNo();
		
		var isNewChangable = '${isNewChangable}';
		var isAdmin = '${userUtil:getIsAdmin(pageContext.request)}';
		if(isNewChangable != 'Y' && isAdmin != 'Y'){
			$('#isNew').parent().parent().hide()
		}
		
		$('input[name=mfg_create_type]').change(function(e){
			changemfg_create_type(e)
		})
		applyDatePicker('launchDate');
		applyDatePicker('launchDateManu');
		applyMonthPicker('stopMonthManufacturingNo');
		
		loadCodeList( "PRODCAT1", "dialog_productType1" );
		loadCodeList( "STERILIZATION", "sterilization" );
		loadCodeList( "ETCDISPLAY", "etcDisplay" );
		loadCodeList( "STORE", "select_store_div");					//23.10.11 점포명 공통코드화
		
		var productType1 = '${productDevDoc.productType1}';
		var productType2 = '${productDevDoc.productType2}';
		var productType3 = '${productDevDoc.productType3}';
		
		if(productType1.length > 0){ 
			$('#dialog_productType1 option[value='+productType1+']').prop('selected', true);
			$('#dialog_productType1').change();
		}
		if(productType2.length > 0){ 
			$('#dialog_productType2 option[value='+productType2+']').prop('selected', true);
			$('#dialog_productType2').change();
		}
		if(productType3.length > 0){ 
			$('#dialog_productType3 option[value='+productType3+']').prop('selected', true);
			$('#dialog_productType3').change();
		}
		
		$("#loginUserId").val('${userId}');
		
		var sterilization = '${productDevDoc.sterilization}';
		var etcDisplay = '${productDevDoc.etcDisplay}';
		if(sterilization.length > 0){ 
			$('#sterilization option[value='+sterilization+']').prop('selected', true);
			$('#sterilization').change();
		}
		if(etcDisplay.length > 0){ 
			$('#etcDisplay option[value='+etcDisplay+']').prop('selected', true);
			$('#etcDisplay').change();
		}
		
		$('input[type=radio][name=isQnsReviewTarget]').change(function(e){
			if(e.target.value=='1'){
				document.getElementById('dialog_qns_no').disabled = false;
				document.getElementById('dialog_qns_no').className = 'req';
				document.getElementById('dialog_qns_no').placeholder = ''
			} else {
				document.getElementById('dialog_qns_no').disabled = true;
				document.getElementById('dialog_qns_no').className = '';
				document.getElementById('dialog_qns_no').value = ''
				document.getElementById('dialog_qns_no').placeholder = '해당 제품은 QNSH 검토 대상이 아님. ex)수출용, 반제품'
			}
		})

		$("#productDocType${productDevDoc.productDocType}").click();

		<c:if test="${productDevDoc.productDocType == '1'}">
		$("#select_store_div option[value='${productDevDoc.storeDiv}']").prop('selected', true);
		$('#select_store_div').change();
		</c:if>

	});

	function productDocTypeOnClick(productDocType){
		if(productDocType == 1){
			$("#li_store_div").show();
			$("#li_productCode").hide();
			$("#li_manufacturingNoSeq").hide();
			$("#li_isNew").hide();
			$("#li_etcDisplay").hide();
			$("#li_productType").show();
		}else if(productDocType == 2){
			$("#li_store_div").hide();
			$("#li_productCode").show();
			$("#li_manufacturingNoSeq").hide();
			$("#li_isNew").hide();
			$("#li_productType").show();
			$("#li_etcDisplay").show();
		} else {
			$("#li_store_div").hide();
			$("#li_productCode").show();
			$("#li_manufacturingNoSeq").show();
			$("#li_isNew").show();
			$("#li_etcDisplay").show();
			$("#li_productType").show();
		}
	}

	function loadCompany(selectBoxId) {
		var URL = "../common/companyListAjax";
		$.ajax({
			type:"POST",
			url:URL,
			data:{},
			dataType:"json",
			async:false,
			success:function(data) {
				var list = data.RESULT;
				$("#"+selectBoxId).removeOption(/./);
				$("#"+selectBoxId).addOption("", "전체", false);
				$("#label_"+selectBoxId).html("전체");
				$.each(list, function( index, value ){ //배열-> index, value
					$("#"+selectBoxId).addOption(value.companyCode, value.companyName, false);
				});
			},
			error:function(request, status, errorThrown){
					alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
			}			
		});
	}
	
	function companyChange(companySelectBoxId, selectBoxId) {
		var URL = "../common/plantListAjax";
		var companyCode = $("#"+companySelectBoxId).selectedValues()[0];
		$.ajax({
			type:"POST",
			url:URL,
			data:{
				"companyCode" : companyCode
			},
			dataType:"json",
			async:false,
			success:function(data) {
				var list = data.RESULT;
				$("#"+selectBoxId).removeOption(/./);
				$("#"+selectBoxId).addOption("", "전체", false);
				$("#label_"+selectBoxId).html("전체");
				$.each(list, function( index, value ){ //배열-> index, value
					$("#"+selectBoxId).addOption(value.plantCode, value.plantName, false);
				});
				$('#'+selectBoxId).parent().show();
				
				
				if(companyCode == 'MD'){
					$('#calcTypeLi1').hide();
					$('#calcTypeLi2').show();
					
					$('#radio_caclType4').click()
				} else {
					$('#calcTypeLi1').show();
					$('#calcTypeLi2').hide();
					
					$('#radio_caclType1').click()
				}
			},
			error:function(request, status, errorThrown){
					alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
			}			
		});
	}
	
	/* 파일첨부 관련 함수 START */
	function callAddFileEvent(){
		$('#attatch_common').click();
	}
	function setFileName(element){
		if(element.files.length > 0)
			$(element).parent().children('input[type=text]').val(element.files[0].name);
		else 
			$(element).parent().children('input[type=text]').val('');
	}
	function addFile(element, fileType){
		var randomId = Math.random().toString(36).substr(2, 9);
		
		if($('#attatch_common').val() == null || $('#attatch_common').val() == ''){
			return alert('파일을 선택해주세요');
		}
		
		fileElement = document.getElementById('attatch_common');
		
		var file = fileElement.files;
		var fileName = file[0].name
		var fileTypeText = $(element).text();
		var isDuple = false;
		attatchFileArr.forEach(function(file){
			if(file.name == fileName)
				isDuple = true;
		})
		
		if(isDuple){
			if(!confirm('같은 이름의 파일이 존재합니다. 계속 진행하시겠습니까?')){
				return;
			};
		}
		
		attatchFileArr.push(file[0]);
		attatchFileArr[attatchFileArr.length-1].tempId = randomId;
		attatchFileTypeArr.push({fileType: fileType, fileTypeText: fileTypeText, tempId: randomId});
		
		var childTag = '<li><a href="#none" onclick="removeFile(this, \''+randomId+'\')"><img src="/resources/images/icon_del_file.png"></a><span>'+fileTypeText+'</span>&nbsp;'+fileName+'</li>'
		$('ul[name=popFileList]').append(childTag);
		$('#attatch_common').val('');
		$('#attatch_common').change();
	}
	function removeFile(element, tempId){
		$(element).parent().remove();
		attatchFileArr = attatchFileArr.filter(function(file){
			if(file.tempId != tempId) {
				return file;
			}
		})
		attatchFileTypeArr = attatchFileTypeArr.filter(function(typeObj){
			if(typeObj.tempId != tempId) 
				return typeObj;
		});
	}
	function uploadFiles(){
		$('#lab_loading').show();
		var docNo = '${productDevDoc.docNo}';
		var docVersion = '${productDevDoc.docVersion}';
		
		var formData = new FormData();
		formData.append('docNo', docNo);
		formData.append('docVersion', docVersion);
		
		/* attatchFileArr.forEach(function(file){
			formData.append('file', file)
		})
		
		attatchFileTypeArr.forEach(function(option, ndx){
			formData.append('fileType', option.fileType)
			formData.append('fileTypeText', option.fileTypeText)
		}) */
		
		for (var i = 0; i < attatchFileArr.length; i++) {
			formData.append('file', attatchFileArr[i])
		}
		
		for (var i = 0; i < attatchFileTypeArr.length; i++) {
			formData.append('fileType', attatchFileTypeArr[i].fileType)
			formData.append('fileTypeText', attatchFileTypeArr[i].fileTypeText)
		}
		
		$.ajax({
			url: '/dev/uploadDevDocFile',
			contentType: 'multipart/form-data', 
			type: 'post',
			data: formData,
			processData: false,
            contentType: false,
            cache: false,
            success: function(data){
            	if(data == 'S'){
            		alert('저장되었습니다');
            		reload();
            	} else if(data == 'E') {
            		$('#lab_loading').hide();
            		return alert('파일저장 오류');
            	} else {
            		$('#lab_loading').hide();
            		return alert('파일이 전달되지 않았습니다');
            	}
            },
            error: function(a,b,c){
            	//console.log(a,b,c)
            	alert('파일저장 오류[2]');
            	$('#lab_loading').hide();
            }
		})
	}
	/* 파일첨부 관련 함수 END */
	
	/* 페이지 이동 관련 START */
	function goCreateMfgDoc(){
		var productCode = '${productDevDoc.productCode}';
		var imNo = '${productDevDoc.imNo}';
		
		var companyCode = $('#companyCode').val();
		var plantCode = $('#plant').val();
		var qns = $('#qns').val();

		if(${productDevDoc.productDocType} == 0){
			if(companyCode.length <= 0) return alert('회사, 공장을 선택하세요');
			if(plantCode.length <= 0) return alert('회사, 공장을 선택하세요');
		}
		//if(qns.length <= 0) return alert('QNS 허들정보를 입력하세요');
		
		var form = document.createElement('form');
		$(form).css('display', 'none');
		$('body').append(form);
		form.action = '/dev/manufacturingProdcessCreate';
		form.method = 'post'
		$(form).append('<input name="docNo" type="hidden" value="'+${docNo}+'">');
		$(form).append('<input name="docVersion" type="hidden" value="'+${docVersion}+'">');
		$(form).append('<input name="companyCode" type="hidden" value="'+companyCode+'">');
		$(form).append('<input name="plantCode" type="hidden" value="'+plantCode+'">');
		$(form).append('<input name="calcType" type="hidden" value="'+$('input[name=dialog_calcType]:checked').val()+'">')
		$(form).append('<input name="qns" type="hidden" value="'+qns+'">');
		$(form).append('<input name="productDocType" type="hidden" value="${productDevDoc.productDocType}">');
		
		form.submit();
	}
	
	function goMfgDetail(dNo, docNo, docVersion){
		var form = document.createElement('form');
		form.style.display = 'none';
		$('body').append(form);
		form.action = "/dev/manufacturingProdcessDetail";
		form.target = '_blank';
		form.method = 'post';
		
		appendInput(form, 'dNo', dNo);
		appendInput(form, 'docNo', docNo);
		appendInput(form, 'docVersion', docVersion);
		
		$(form).submit();
	}
	
	function changeVersion(docVersion){
		var docNo = '${productDevDoc.docNo}';
		
		var form = document.createElement('form');
		$('body').append(form);
		form.action = '/dev/productDevDocDetail';
		form.method = 'post';
		
		appendInput(form, 'docNo', docNo);
		appendInput(form, 'docVersion', docVersion);
		
		$(form).submit();
	}
	
	function ceateDesignRequest(){
		var docNo = '${productDevDoc.docNo}';
		var docVersion = '${productDevDoc.docVersion}';
		
		var form = document.createElement('form');
		$('body').append(form);
		form.action = '/dev/designRequestDocCreate';
		form.method = 'post';
		
		appendInput(form, 'docNo', docNo);
		appendInput(form, 'docVersion', docVersion);
		appendInput(form, 'createType', 'N');
		
		$(form).submit();
	}
	
	function initForm(formId, inputName){
	   var jqId = formId + ' input[name='+inputName+']';
	   $('#'+jqId).remove();
	}
	
	function editMfg(dNo, companyCode, plantCode){
		initForm('mfgCreateForm', 'dNo');
		initForm('mfgCreateForm', 'companyCode');
		initForm('mfgCreateForm', 'plantCode');
		
		var URL = "../approval/countReviewDoc";
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
					var form = $('#mfgCreateForm');
					<c:choose>
					<c:when test="${productDevDoc.productDocType == '1'}">
					form.attr('action', '/dev/manufacturingProdcessCreateForStores');
					</c:when>
					<c:when test="${productDevDoc.productDocType == '2'}">
					form.attr('action', '/dev/manufacturingProdcessCreateForStores');
					</c:when>
					<c:otherwise>
					form.attr('action', '/dev/manufacturingProdcessEdit');
					</c:otherwise>
					</c:choose>
					form.append('<input type="hidden" name="dNo" value="'+dNo+'">');
					form.append('<input type="hidden" name="companyCode" value="'+companyCode+'">');
					form.append('<input type="hidden" name="plantCode" value="'+plantCode+'">');
					form.submit();
				}
			},
			error:function(request, status, errorThrown){
				alert("오류가 발생하였습니다. \n다시 처리해주세요.");
			}			
		});	
	}
	
	function editMfgPackage(dNo, companyCode, plantCode){
		var form = $('#mfgCreateForm');
		form.attr('action', '/dev/manufacturingProdcessEditMarketing')
		form.append('<input type="hidden" name="dNo" value="'+dNo+'">');
		form.append('<input type="hidden" name="companyCode" value="'+companyCode+'">');
		form.append('<input type="hidden" name="plantCode" value="'+plantCode+'">');
		form.submit();
	}
	
	function editMfgSpec(dNo, companyCode, plantCode){
		var form = $('#mfgCreateForm');
		form.attr('action', '/dev/manufacturingProdcessEditSpec')
		form.append('<input type="hidden" name="dNo" value="'+dNo+'">');
		form.append('<input type="hidden" name="companyCode" value="'+companyCode+'">');
		form.append('<input type="hidden" name="plantCode" value="'+plantCode+'">');
		form.submit();
	}
	
	/* function editMfgMarketing(dNo, companyCode, plantCode){
		var form = $('#mfgCreateForm');
		form.attr('action', '/dev/manufacturingProdcessEditMarketing')
		form.append('<input type="hidden" name="dNo" value="'+dNo+'">');
		form.append('<input type="hidden" name="companyCode" value="'+companyCode+'">');
		form.append('<input type="hidden" name="plantCode" value="'+plantCode+'">');
		form.submit();
	} */
	
	function goList(){
		var form = document.createElement('form');
		$('body').append(form);
		form.action = '/dev/productDevDocList';
		form.method = 'post';
		
		$(form).submit();
	}
	
	/* 페이지 이동 관련 END */
	
	
	function changemfg_create_type(e){
		var type = e.target.value.split('type_')[1];
		if(type == 'new'){
			$('#dialog_create div.modal').css('height', '340px');
			$('li[id*=dialog_create_li]').hide();
		} else {
			if(type == 'mfg'){
				$('#dialog_create div.modal').css('height', '430px');
			} else {
				$('#dialog_create div.modal').css('height', '385px');
			}
			$('li[id*=dialog_create_li]').hide();
			$('li[id=dialog_create_li_'+type+']').show();
		}
	}
	
	function stopMfgDOc(dNo){
		if(confirm('제조공정서(문서번호:'+dNo+')의 사용을 중지합니다. 진행 할 경우 더이상 수정 및 삭제가 불가능합니다. 계속하시겠습니까?')){
			$.ajax({
				url: '/dev/stopManufacturingProcessDoc',
				type: 'post',
				data: {
					dNo: dNo
				},
				success: function(data){
					if(data == 'S'){
						alert('문서상태가 변경되었습니다.');
						reload();
					} else {
						return alert('사용중지 오류[1]');
					}
				},
				error: function(a,b,c){
					return alert('사용중지 오류[2]');
				}
			})
		}
	}
	
	function deleteMfgDoc(dNo){
		var docNo = '${productDevDoc.docNo}';
		var docVersion = '${productDevDoc.docVersion}';
		
		if(confirm('제조공정서(문서번호:'+dNo+')를 정말 삭제하시겠습니까?')){
			$.ajax({
				url: '/dev/deleteManufacturingProcessDoc',
				type: 'post',
				data: {
					dNo: dNo,
					docNo: docNo,
					docVersion: docVersion
				},
				success: function(data){
					if(data == 'S'){
						alert('정삭적으로 삭제되었습니다.');
						reload();
					} else {
						return alert('삭제 오류[1]');
					}
				},
				error: function(a,b,c){
					return alert('삭제 오류[2]');
				}
			})
		} else {
			return;
		}
	}
	
	function copyMfgDoc(dNo){
		var docNo = '${productDevDoc.docNo}';
		var docVersion = '${productDevDoc.docVersion}';
		
		if(confirm('제조공정서(문서번호:'+dNo+')를 복사 생성하시겠습니까?')){
			$.ajax({
				url: '/dev/copyManufacturingProcessDoc',
				type: 'post',
				data: {
					dNo: dNo,
					docNo: docNo,
					docVersion: docVersion
				},
				success: function(data){
					if(data.length > 0){
						alert('문서번호:'+data+'로 복사되었습니다');
						reload();
					} else {
						return alert('복사 오류[1]');
					}
				},
				error: function(a,b,c){
					return alert('복사 오류[2]');
				}
			})
		} else {
			return;
		}
	}
	
	function deleteFile(ddfNo, fileName){
		if(confirm('첨부 이미지['+fileName+']을(를) 정말 삭제하시겠습니까?')){
			$('#lab_loading').show();
			$.ajax({
				url: '/file/deleteDevDocFile',
				type: 'post',
				data: { ddfNo: ddfNo },
				success: function(data){
					if(data == 'S'){
						alert('정상적으로 삭제되었습니다')
						reload();
					} else if(data == 'E'){
						alert('파일 삭제 오류(1)');
						$('#lab_loading').hide();
					} else {
						alert('존재하지 않는 파일입니다');
						$('#lab_loading').hide();
					}
				},
				error: function(a,b,c){
					//console.log(a,b,c)
					alert('파일 삭제 오류(2)');
					$('#lab_loading').hide();
				}
			})
		}
	}
	
	function checkFile(ddfNo, fileName){
		if(confirm('파일['+fileName+']을 확인체크 하시겠습니까?')){
			$.ajax({
				url: '/dev/checkDevDocFile',
				type: 'post',
				data: {
					ddfNo: ddfNo,
				},
				success: function(data){
					if(data == 'S'){
						alert('확인체크 되었습니다.');
						reload();
					} else {
						alert('체크 오류[1]');
					}
				},
				error: function(a,b,c){
					//console.log(a,b,c)
					alert('체크 오류[2]');
				}
			})
		}
		
	}
	
	function changeDevDocCloseState(state){
		var ddNo = '${productDevDoc.ddNo}';
		var docNo = '${productDevDoc.docNo}';
		var docVersion = '${productDevDoc.docVersion}';
		var currentState = '${productDevDoc.isClose}';
		var chageStateText;
		var alertMessage = '';
		
		if(state == 0) alertMessage = '문서의 상태를 [진행중]으로 변경하시겠습니까?';
		if(state == 1) alertMessage = '결재중인 문서는 모두 상신취소됩니다. 보류하시겠습니까?';
		if(state == 2) alertMessage = '제품명에 [중단] 표시가 추가됩니다. 계속하시겠습니까?';
		
		if(currentState != state && confirm(alertMessage)){
			$.ajax({
				url: '/dev/updateDevDocCloseState',
				data: {
					ddNo: ddNo,
					docNo: docNo,
					docVersion: docVersion,
					isClose: state
				},
				success: function(data){
					if(data == 'S'){
						alert('변경되었습니다');
						reload();
					} else {
						return alert('변경 오류[1]');
					}
				},
				error: function(a,b,c){
					//console.log(a,b,c)
					return alert('변경 오류[2]');
				}
			})
		}
	}
	
	function downloadFile(ddfNo){
		location.href = '/file/downloadDevDocFile?ddfNo='+ddfNo;
	}
	
	/* function changeDispImage(ddfNo){
		console.log('changeDispImage()', ddfNo);
	} */
	
	function devDocValid(){
		var userGrade = "<%=UserUtil.getUserGrade(request)%>";
		
		if($('#devDocEditForm input[name=productName]').val().length<= 0){
			alert('제품명을 입력해주세요');
			$('#devDocEditForm input[name=productName]').focus();
			return false;
		}
		
		/* if(userGrade != 8){
			if($('#productCode_select').val().length <= 0 && $('#imNo').val().length <= 0){
				alert('제품코드를 검색 후 선택해주세요');
				$('#productCode_select').focus();
				return false;
			}
			
			if($('#reqNum_select').val().length <= 0){
				alert('품목제조보고번호를 검색 후 선택해주세요');
				$('#reqNum_select').focus();
				return false;
			}
		} */
		
		
		if($('#dialog_productType1').val().length <= 0){
			alert('제품유형을 선택해주세요');
			return false;
		}
		
		return true;
	}
	
	function updateDevDoc(){
		if(!devDocValid())
			return;

		var postData = new Object();
		postData.ddNo = $('#devDocEditForm input[name=ddNo]').val()
		postData.productCategoryText = $('#devDocEditForm input[name=productCategoryText]').val()
		postData.productDocType = $("input[name=productDocType]:checked").val();
		postData.productName = $('#devDocEditForm input[name=productName]').val();
		postData.launchDate = $('#devDocEditForm input[name=launchDate]').val();
		postData.productType1 = $('#devDocEditForm select[name=productType1]').val();
		postData.productType2 = $('#devDocEditForm select[name=productType2]').val();
		postData.productType3 = $('#devDocEditForm select[name=productType3]').val();
		postData.explanation = $('#devDocEditForm textarea[name=explanation]').val();
		if(postData.productDocType == 1){
			postData.storeDiv = $("#select_store_div").val();
		}else if(postData.productDocType == 2){
			postData.productCode = $('#devDocEditForm input[name=productCode]').val() == '' ? '0' : $('#devDocEditForm input[name=productCode]').val();
			postData.etcDisplay = $('#devDocForm select[name=etcDisplay]').val();
		}else{
			postData.imNo = $('#devDocEditForm input[name=imNo]').val() == '' ? '0' : $('#devDocEditForm input[name=imNo]').val();
			postData.productCode = $('#devDocEditForm input[name=productCode]').val() == '' ? '0' : $('#devDocEditForm input[name=productCode]').val();
			postData.manufacturingNo = $('#devDocEditForm input[name=manufacturingNo]').val() == '' ? '0' : $('devDocEditForm input[name=manufacturingNo]').val();
			postData.manufacturingNoSeq = $('#devDocEditForm input[name=manufacturingNoSeq]').val() == '' ? '0' : $('#devDocEditForm input[name=manufacturingNoSeq]').val();
			postData.sterilization = $('#devDocEditForm select[name=sterilization]').val();
			postData.etcDisplay = $('#devDocEditForm select[name=etcDisplay]').val();
			postData.isNew = $('#devDocEditForm input[name=isNew]:checked').val();
		}
		
		$.ajax({
			url: '/dev/updateProductDevDoc',
			type: 'post',
			data: postData,
			success: function(data){
				if(data == 'S'){
					alert('수정되었습니다');
					reload();
				} else {
					alert('제품개발문서 수정 오류[1]');
				}
			},
			error: function(a,b,c){
				//console.log(a,b,c)
				alert('제품개발문서 수정 오류[2]');
			}
		})
	}
	
	function versionUp(){
		$('#lab_loading').show();
		$('#versionUpBtn').attr('disabled', true);
		var drNoArr = [];
		
		$('input[name^=dialog_check_design_doc]').toArray().forEach(function(element){
			if($(element).is(':checked') == true)
				drNoArr.push($(element).parent().next().text())
		});

		var postData = new Object();
		postData.ddNo = "${productDevDoc.ddNo}";
		postData.docNo = "${productDevDoc.docNo}";
		postData.docVersion = "${productDevDoc.docVersion}";
		postData.versionUpMemo = $("#versionUpForm textarea[name=versionUpMemo]").val();
		//postData.drNoArr = drNoArr;
		console.log(postData);
		$.ajax({
			url: '/dev/versionUpDevDoc',
			type: 'post',
			// data: $('#versionUpForm').serialize()+'&drNoArr='+drNoArr,
			data: postData,
			success: function(data){
				if(data > 0){
					alert('제품개발문서 버전업 되었습니다');
					changeVersion(data);
				} else {
					return alert('제품개발문서 버전업 오류[1]');
					reload();
				}
				
			},
			error: function(a,b,c){
				console.log(a);
				console.log(b);
				console.log(c);
				alert('제품개발문서 버전업 오류[2]');
				reload();
			}
		})
		
		//reload();
	}
	
	function callVersionUpDialog(){
		var hasMfgApproval = false;
		var hasDesignApproval = false;
		
		$('input[name=hasMfgApproval]').toArray().forEach(function(element){
			if(element.value == 'true')
				hasMfgApproval = true;
		})
		
		$('input[name=hasDesignApproval]').toArray().forEach(function(element){
			if(element.value == 'true')
				hasDesignApproval = true;
		})
		
		if(hasMfgApproval)
			return alert('결재중인 제조공정서가 있어 버젼을 올릴 수 없습니다.');
		
		if(hasDesignApproval)
			return alert('결재중인 디자인의뢰서가 있어 버젼을 올릴 수 없습니다.');
		
		var designReqDocSize = '${fn:length(designRequestDocList) == 0 ? 1 : fn:length(designRequestDocList)}';
		
		var dialogHeight = 410 + ((designReqDocSize-1)*39);
		$('#dialog_versionUp div:first').css('height', dialogHeight)
		openDialog('dialog_versionUp');
	}
	
	function openApprovalDialog(id){
		
		if(id=='approval_design'){
			
			var isValid = checkDesignApprValid();
			if(!isValid){
				return;
			}
			
			var tbKey = "N";
			
			var tempKey = "${productDevDoc.ddNo}";
			
			var cnt = 0;
			$("input[name=check_design_doc]").each(function(){
				if($(this).is(":checked")){
					cnt++;						
				}
			});
			
			if(cnt > 1){
				return alert("디자인의뢰서는 1개만 결재 상신 가능합니다.!");
			}
			
			$("input[name=check_design_doc]").each(function(){
				if($(this).is(":checked")){
					
					tempKey = "0";
					
					if(tbKey == "N"){
						tbKey = $(this).val();
					}else{
						tbKey = tbKey+","+$(this).val();
					}
					
				}				
			});
			
			 /*  $.ajax({
				url: '/dev/approvalRequestPopup',
				type: 'post',
				 data: {
					tbType : "designRequestDoc"
				}, 
				async : false,
				success: function(data){
					if(data.status == 'S'){
						openDialog(id);
						$("#userId1").val(data.userId);
						$("#userId3").val(data.defaultUserList[0].userId);
						$("#tbKey").val(tbKey);
						$("#tempKey").val(tempKey);
						
						$("#apprLine").empty();
						$("#apprLineSelect").empty();
						
						for(var i=0; i<data.regUserData.length; i++){
							$("#apprLine").append("<li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class='s01'>기안자</span>"+data.regUserData[i].userName+"<strong>"+data.regUserData[i].titCodeName+"/"+data.regUserData[i].deptFullName+"</strong></li>");
						}
	
						$("#apprLine").append("<li id='designPayment1'><img src='../resources/images/icon_del_file.png' name='delImg'><span>1차 검토 </span><strong></strong></li>");
					
						for(var i=0; i<data.defaultUserList.length; i++){
							$("#apprLine").append("<li id='designPayment2'><img src='../resources/images/icon_del_file.png' name='delImg'><span >"+data.defaultUserList[i].type+"</span>"+data.defaultUserList[i].userName+"<strong>"+data.defaultUserList[i].titCodeName+"/"+data.defaultUserList[i].deptFullName+"</strong><input type='hidden' value="+data.defaultUserList[i].userId+"></li>");
						}
						
						$("#apprLine").append("<li id='designPaymentMarketing'><img src='../resources/images/icon_del_file.png' name='delImg'><span>마케팅 </span><strong></strong></li>");
					
						for(var i=0; i<data.approvalLineList.length; i++){
							$("#apprLineSelect").append("<option value"+data.approvalLineList[i].apprLineNo+">"+data.approvalLineList[i].lineName+"</option>");
						}
						
					} else {
						return alert('오류(F)');
					}
				},
				error: function(a,b,c){
					return alert('오류(http error)');
				}
			});   */
			
			$.ajax({
				url: '/dev/approvalRequestPopup',
				type: 'post',
				 data: {
					tbType : "designRequestDoc"
				}, 
				async : false,
				success: function(data){
					if(data.status == 'S'){
						openDialog(id);
						$("#deptFulName").val('');
					   	$("#titCodeName").val('');
					    $("#userId").val('');
					    $("#userName").val('');  
						$("#userIdDesignArr").val('');
						$("#userIdDesignArr").val(data.userId);
						$("#designTitle").val('');
						$("#design_comment").val('');
						$("#designKeyword").val('');
/* 						$("#userId1").val(data.userId);
						$("#userId3").val(data.defaultUserList[0].userId); */
						$("#tbKey").val(tbKey);
						$("#tempKey").val(tempKey);
						
						$("#CirculationRefLine").empty()
						
						$("#apprLine").empty();
						$("#userId5").val('');
						$("#userId6").val('');
						$("#apprLineSelect").empty();
						$(".app_line_edit .req").eq(0).val('');
						
						for(var i=0; i<data.regUserData.length; i++){
							$("#apprLine").append("<li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class='s01'>기안자</span>  "+data.regUserData[i].userName+"<strong>"+"/"+data.regUserData[i].userId+"/"+data.regUserData[i].deptCodeName+"/"+data.regUserData[i].teamCodeName+"</strong><input type='hidden' value="+data.regUserData[i].userId+"></li>");
						}
	
						/* $("#apprLine").append("<li id='designPayment1'><img src='../resources/images/icon_del_file.png' name='delImg'><span>1차 검토 </span><strong></strong></li>");
					
						for(var i=0; i<data.defaultUserList.length; i++){
							$("#apprLine").append("<li id='designPayment2'><img src='../resources/images/icon_del_file.png' name='delImg'><span >"+data.defaultUserList[i].type+"</span>"+data.defaultUserList[i].userName+"<strong>"+data.defaultUserList[i].titCodeName+"/"+data.defaultUserList[i].deptFullName+"</strong><input type='hidden' value="+data.defaultUserList[i].userId+"></li>");
						}
						
						$("#apprLine").append("<li id='designPaymentMarketing'><img src='../resources/images/icon_del_file.png' name='delImg'><span>마케팅 </span><strong></strong></li>"); */
					
						$("label[for=apprLineSelect]").html("----결재선 불러오기----");
						$("#apprLineSelect").append("<option value=''>----결재선 불러오기----</option>");
						
						for(var i=0; i<data.approvalLineList.length; i++){
							$("#apprLineSelect").append("<option value="+data.approvalLineList[i].apprLineNo+">"+data.approvalLineList[i].lineName+"</option>");
						}
						
					} else {
						return alert('오류(F)');
					}
				},
				error: function(a,b,c){
					return alert('오류(http error)');
				}
			});
			
		}
		if(id=="approval_manu"){
			
			/* 		
			if(!validateManufac()){
				return ;
			} */
			
			/*===== 제조공정서 결재상신 체크 =====*/
			// 1. 선택항목 여부 확인 (필) 	+ (24.02.16 추가)제조공정서도 여러개가 아닌 한개만 선택해서 진행함.
			// 2. 선택항목 중 상태체크 (필) 	+ (24.02.16 추가)등록/반려 상태일때만 결재상신 가능 
			// 3. 제품개발문서 첨부파일 등록여부 (필)
			// 4. 제품개발문서 제품코드 등록여부 (필)
			// 5. 제조공정서 QNS 등록여부 확인 ( QNSH번호 미기입 혹은 대상아님을 선택했을 경우, )
			// 6. 제조공정서 품목제조보고서 매핑여부 확인 (품보 맵핑이 이루어지지 않았을 경우 )
			
			
			// 1
			var tbKey = '';
			var companyCd = '';
			
			var cnt = 0; 
			$("input[name=check_mfg_doc]").each(function(){
				if($(this).is(":checked")){
					cnt++;						
				}
			});
			if(cnt > 1){
				return alert("하나의 제조공정서만 선택해주세요.");
			}
			
			$("input[name=check_mfg_doc]").each(function(){
				if($(this).is(":checked")){
					if(tbKey == ""){
						tbKey = $(this).val();
						companyCd = $(this).siblings("input[name='hidden_mfg_cd']").val();
						//1 개 일경우

					}else {
						tbKey = tbKey +","+$(this).val();
						companyCd = companyCd + ","+$(this).siblings("input[name='hidden_mfg_cd']").val();
						//2개 이상 일경우(사용하지않음)
						return alert("하나의 제조공정서만 선택해주세요.");

					}
				}	
			});
			if(tbKey == ""){
				return alert("상신하실 제조공정서를 선택해주세요.");
			}
			
			
			// 2
			var mfgTargetObj = $('input[type=checkbox][name=check_mfg_doc]:checked');
			for(var i=0; i< mfgTargetObj.length; i++){
				var stateStr = "";
				var stateVal = $(mfgTargetObj[i]).data("state");
				
				if(stateVal == '0'){
					stateStr = "등록";
				}else if(stateVal == '1'){
					stateStr = "승인";
				}else if(stateVal == '2'){
					stateStr = "반려";
				}else if(stateVal == '3'){
					stateStr = "결재중";
				}else if(stateVal == '4'){
					stateStr = "ERP반영완료";
				}else if(stateVal == '5'){
					stateStr = "ERP반영오류";
				}else if(stateVal == '6'){
					stateStr = "사용중지";
				}else if(stateVal == '7'){
					stateStr = "임시저장";
				}
				
				// state = 0(등록) , 2(반려)가 아니면 결재상신 제한 
				if(stateVal == "1" || stateVal == "3" || stateVal == "4" || stateVal == "5" || stateVal == "6" || stateVal == "7"){
					console.log("상태값 :: "+$(mfgTargetObj[i]).data("state") + "|| " + stateStr);
					return  alert( "제조공정서가 "+stateStr+" 상태이므로 결재상신이 불가능합니다.");
				}
			}
			
			
			// 3, 4
			/* 제품개발문서 내 첨부파일(1. 제품사진, 2. 포장지시안) 미첨부시 제조공정서 결재 상신 불가 + 해당 파일 첨부 안내메세지 구현.*/
			var existFile6 = $(".con_file ul:eq(0) dd:eq(0) li").length;  // 제품사진 		//addfile60
			var existFile1 = $(".con_file ul:eq(0) dd:eq(1) li").length;  // 디자인시안		//addfile10
			
			/* 제품개발문서의 제품코드 미입력 시 결재상신 불가 및 안내메세지 구현 */
			var productCode = '${productDevDoc.productCode}';  // 제품코드를 작성하지않을 경우 0 , 작성할 경우 6자리코드
			
			
			/*=============================
			= 제품개발 유형에 따른 처리			  =
			= productDocType : 제품개발 유형	  =
			= 공장 : 0, 점포용 : 1, OEM: 2	  =
			=============================*/
			var productDocType = "${productDevDoc.productDocType}";  
		
			if(productDocType != null &&productDocType == '1'){
				// 점포용 제조공정서
				if(existFile6 == 0){
					return alert(" <1. 제품이미지> 파일 첨부가 완료된 후에 \n결재상신 가능합니다.");
				}
				
			}else if(productDocType != null && (productDocType == '0' || productDocType == '2')){
				// 공장 제조공정서  , OEM
				if((existFile1 == 0 || existFile6 == 0) &&(productCode == null || productCode == "0")) { //추가요구사항에 따른 모든 메세지 출력
					return alert(" <1. 제품이미지>과 <2. 포장지시안> 파일 첨부 및\n <제품(번호)코드>를 등록 후 결재상신 가능합니다.");
				}else if(existFile1 == 0 || existFile6 == 0){
					return alert(" <1. 제품이미지>과 <2. 포장지시안> 파일 첨부가 완료된 후에 \n결재상신 가능합니다.");
				}else if(productCode == null || productCode == "0"){
					return alert(" <제품(번호)코드>를 등록 후 결재상신 가능합니다.");
				}
			}

			
			// 5 , 6
			/* QNS 기입 여부 와 매핑 여부 확인 */
			var qnsFlag = true;			// QNS선택값이 null이거나 0이면서, qns가 없을 경우 (flag1,2 합친거)
			var mappingFlag = true;		// 제조공정서 맵핑된 품보가 있을경우
			
			//console.log("5. tbKey ::  "+ tbKey);
			tbKey.split(',').forEach(function(item){	// 선택한 제조공정서 수만큼 반복
				
				var qns = $('input[name=hidden_mfg_dNo][value='+item+']').siblings('input[name=hidden_mfg_qns]').val();
				var isQnsReviewTarget = $('input[name=hidden_mfg_dNo][value='+item+']').siblings('input[name=hidden_mfg_isQnsReviewTarget]').val();				
				var mfgDNo = $('input[name=hidden_mfg_dNo][value='+item+']').val();	 // 제조공정서가 물고 있는 
				
				// 제조공정서의 QNS 등록여부 확인(5번항목)
				if((isQnsReviewTarget == null || isQnsReviewTarget == "" || isQnsReviewTarget == '0') && (qns.length <= 0)){ //QNS선택값이 null이거나 0이면서, qns가 없을 경우
					qnsFlag = false;
					//console.log("QNS 없음 X");
				}else{
					//console.log("QNS 있음 O");
				}
				
				// 제조공정서의 품보매핑 확인 (6번항목)
				jQuery.ajax({
					type : 'POST',
					dataType : 'json',
					data : { dNo : mfgDNo},
					url : '/manufacturingNo/selectManufacturingNoMappingCountAjax',
					async : false,
					success : function(response){						
						if(response.COUNT <= 0 ){
							//제조공정서 맵핑이 없을때
							//console.log("맵핑 없음 X");
							mappingFlag = false;

						}else{
							//console.log("맵핑 있음 O");
						}

					},
					error : function(){
						alert("오류가 발생하였습니다.\n관리자에게 문의하시기 바랍니다.");
						console.log("[5] 품보매핑 조회 오류");
						return;
					}	
				});
// 				console.log("QNS :: "+ qns + "QNSLength :: "+ qns.length+ "isQnsReviewTarget :: "+ isQnsReviewTarget + "mfgDNo :: "+ mfgDNo);

			});

			if(!qnsFlag){		//QNS선택값이 null이거나 0이면서, qns가 없을 경우  false
				if(confirm("해당 제조공정서[QNSH 미기입] 혹은 [QNSH 대상 아님] 상태입니다.\n결재 상신 하시겠습니까?")){
					console.log("QNS 체크 확인");
				}else{
					return;
				}
			}
			
			// 점포용 / OEM은 해당 x
			if(productDocType != null && (productDocType == '1' || productDocType == '2')){
				console.log("점포용 / OEM");
			}else{
				if(!mappingFlag){
					if(confirm("해당 제조공정서에 [맵핑된 품목제조보고서]가 없습니다.\n결재 상신 하시겠습니까?")){
						console.log("맵핑 체크 확인");	
					}else{
						return;
					}
				}
			}

			
			$.ajax({
				url: '/dev/disableStr?tbKey='+tbKey,
				type: 'POST',
				async:false,
				success: function(data){
					if(data.status=='S'){
						var list = data.list;
						
						/* for(var i=0; i<list.length; i++){
							
							
							var stateStr = "";
							
							if(list[i].state == '0'){
								stateStr = "등록";
							}else if(list[i].state == '1'){
								stateStr = "승인";
							}else if(list[i].state == '2'){
								stateStr = "반려";
							}else if(list[i].state == '3'){
								stateStr = "결재중";
							}else if(list[i].state == '4'){
								stateStr = "ERP반영완료";
							}else if(list[i].state == '5'){
								stateStr = "ERP반영오류";
							}else if(list[i].state == '6'){
								stateStr = "사용중지";
							}else if(list[i].state == '7'){
								stateStr = "임시저장";
							}
							
							if(list[i].docType == "E"){
								alert("본 문서(문서번호:"+list[i].dNo+")는 엑셀로 업로드 제조공정서 이므로 결재 상신을 할 수 없습니다.");
								return;
							}else if(list[i].state=="1" || list[i].state=="3" || list[i].state=="4" || list[i].state=="5" || list[i].state=="6" || list[i].state=="7"){
								alert("본 문서(문서번호:"+list[i].dNo+")는 "+stateStr+" 상태이므로 결재상신을 할수 없습니다.");
								return;
							}
							else if(!hasAuthority(data.userId,list[i].regUserId,data.grade,list[i].hasAuthorityCnt)){
								alert("본 문서(문서번호:"+list[i].dNo+")의 작성자가 아니므로 결재상신을 할 수 없습니다.");
								return;
							}
							else{
								if("1" == list[i].subProdCnt){
									
									var sumExcRate = parseFloat(list[i].sumExcRate).toFixed(3);
									
									var sumIncRate = parseFloat(list[i].sumIncRate).toFixed(3);
									
									if(sumExcRate != '100.000' || sumIncRate != '100.000' ){
										alert("본 문서(문서번호:"+list[i].dNo+")는 표시사항 배합비의 합계가 100이 아니므로 결재 상신을 할수 없습니다. * 백분율:" +sumExcRate+" *급수포함: "+sumIncRate);
										return;
									}
									
								}
							} 
						}
						
						var existFile1 = $(".con_file ul:eq(0) dd:eq(1) li").length;
						
						var existFile6 = $(".con_file ul:eq(0) dd:eq(0) li").length;
						
						if(existFile1 == 0 || existFile6 == 0){	
							return alert("<1. 포장지시안>과 <4. 제품이미지> 파일 첨부가 완료된 후에 \n결재상신 가능합니다.");
						} 
						 */
						/* S210304-00010 시생산보고서 결재 유효성검사 제거 요청 - 김성훈 차장
						if(!checkTrailValid(tbKey)){
							return; 
						}
						*/
						
						$("#tbKeyManu").val(tbKey);
						
						$.ajax({
							url: '/dev/approvalRequestPopup',
							type: 'post',
							data: {
								tbType: "manufacturingProcessDoc"
							}, 
							async : false,
							success: function(data){
								if(data.status == 'S'){
									if(data.grade == '6'){
										return alert("권한이 없습니다.");
									}else{
										// S201110-00001
		                                $('#lab_loading').show();
		                                var selectedMfgDNoArr = [];
		                                tbKey.split(',').forEach(function(item){
		                                    selectedMfgDNoArr.push(item)
		                                });
		                                $.ajax({
		                                    url: '/dev/bomItemCheck?dNoList='+selectedMfgDNoArr,
		                                    type: 'POST',
		                                    dataType: 'JSON',
		                                    success: function(data2){
			                                    if( data2.resultFlag == 'S') {
			                                        openDialog(id);
			                                        $("#deptFulName").val('');
			                                        $("#titCodeName").val('');
			                                        $("#userId").val('');
			                                        $("#userName").val('');
			                                        $("#userIdManuArr").val('');
			                                        $("#userIdManuArr").val(data.userId);
			                                        $("#manuTitle").val('');
			                                        $("#launchDateManu").val('');

			                                        $("#CirculationRefLineManu").empty();
			                                        $("#userId7Manu").val('');
			                                        $("#userId8Manu").val('');
			                                        $("#apprLineManu").empty();
			                                        $("#apprLineSelectManu").empty();
			                                        $("#manufacKeyword").val('');
			                                        $(".app_line_edit .req").eq(1).val('');
			                                        $("#ManuCompanyCd").val(companyCd);

			                                        for(var i=0 ;i<data.regUserData.length;i++){
			                                            $("#apprLineManu").append("<li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class='s01'>기안자</span>  "+data.regUserData[i].userName+"<strong>"+"/"+data.regUserData[i].userId+"/"+data.regUserData[i].deptCodeName+"/"+data.regUserData[i].teamCodeName+"</strong><input type='hidden' value="+data.regUserData[i].userId+"></li>");
			                                        }

			                                        $("label[for=apprLineSelectManu]").html("----결재선 불러오기----");
			                                        $("#apprLineSelectManu").append("<option value=''>----결재선 불러오기----</option>");

			                                        for(var i=0; i<data.approvalLineList.length; i++){
			                                            $("#apprLineSelectManu").append("<option value="+data.approvalLineList[i].apprLineNo+">"+data.approvalLineList[i].lineName+"</option>");
			                                        }
			                                        $('#lab_loading').hide();
			                                    } else {
			                                       var list = data2.resultArray;
			                                       var tabHtml = "";
			                                       var bodyHtml = "";
			                                       $.each(list, function( index, value ){ //배열-> index, value
			                                          var header = value.header;
			                                          if( index == 0 ) {
			                                             tabHtml += "<a href=\"javascript:changeItemCheckTab('"+index+"')\"><li class=\"select\">"+header.productCode+"</li></a>";
			                                          } else {
			                                             tabHtml += "<a href=\"javascript:changeItemCheckTab('"+index+"')\"><li class=\"\">"+header.productCode+"</li></a>";
			                                          }
			                                          if( index == 0 ) {
			                                             bodyHtml += "   <div id=\"bom_item_check_tab_div_"+index+"\">";
			                                          } else {
			                                             bodyHtml += "   <div id=\"bom_item_check_tab_div_"+index+"\" style=\"display:none\">";
			                                          }
			                                          bodyHtml += "   <div class=\"prodoc_title\" style=\"margin-bottom: 30px;\">";
			                                          bodyHtml += "      <div style=\"display: inline-block; height: 80px; width: 100%; padding-top: 10px;\">";
			                                          bodyHtml += "         <span class=\"font17\">제품명 : "+header.productName+"</span>";
			                                          bodyHtml += "         <br><span class=\"font18\">제품코드 : "+header.productCode+"</span>";
			                                          bodyHtml += "         <br><span class=\"font18\">회사 : "+header.companyName+" <strong>&nbsp;|&nbsp;</strong> 공장 : "+header.plantName+"</span>";
			                                          bodyHtml += "      </div>";
			                                          bodyHtml += "   </div>";

			                                          var item = value.item;
			                                          bodyHtml += "      <div class=\"main_tbl\">";
			                                          bodyHtml += "         <table class=\"tbl01\">";
			                                          bodyHtml += "            <colgroup>";
			                                          bodyHtml += "               <col width=\"20%\">";
			                                          bodyHtml += "               <col width=\"45%\">";
			                                          bodyHtml += "               <col width=\"15%\">";
			                                          bodyHtml += "               <col width=\"20%\">";
			                                          bodyHtml += "            </colgroup>";
			                                          bodyHtml += "            <thead>";
			                                          bodyHtml += "               <tr>";
			                                          bodyHtml += "                  <th>SAP코드</th>";
			                                          bodyHtml += "                  <th>자재명</th>";
			                                          bodyHtml += "                  <th>단위</th>";
			                                          bodyHtml += "                  <th>자재상태</th>";
			                                          bodyHtml += "               <tr>";
			                                          bodyHtml += "            </thead>";
			                                          bodyHtml += "            <tbody>";
			                                          $.each(item, function( index, value ){
			                                             bodyHtml += "            <tr>";
			                                             bodyHtml += "               <td>"+value.itemCode+"</td>";
			                                             bodyHtml += "               <td>"+value.itemName+"</td>";
			                                             bodyHtml += "               <td>"+value.unit+"</td>";
			                                             if( value.matStatus == 'X' ) {
			                                                bodyHtml += "               <td>삭제</td>";
			                                             } else if( value.matStatus == 'B' ) {
			                                                bodyHtml += "               <td>블락</td>";
			                                             } else if( value.isSample == 'Y') {
			                                                bodyHtml += "               <td>임시</td>";
			                                             } else {
			                                                bodyHtml += "               <td>&nbsp;</td>";
			                                             }
			                                             bodyHtml += "            </tr>";
			                                          });
			                                          bodyHtml += "            </tbody>";
			                                          bodyHtml += "         </table>";
			                                          bodyHtml += "      </div>";
			                                          bodyHtml += "   </div>";
			                                       });
			                                       $("#bom_item_check_tab").html("");
			                                       $("#bom_item_check_body").html("");
			                                       $("#bom_item_check_tab").html(tabHtml);
			                                       $("#bom_item_check_body").html(bodyHtml);
			                                       openDialog('bom_item_check');
			                                    }
			                                    $('#lab_loading').hide();
		                                    },
		                                    error: function(a,b,c){
			                                    $('#lab_loading').hide();
			                                    alert("오류가 발생하였습니다.");
			                                    return;
		                                    }
		                                });
									}
									
								}
								else {
									return alert('오류(F)');
								}
							},
							error: function(a,b,c){
								return alert('오류(http error)');
							}
						}); 
						
					} else {
						alert('오류[1]');
						return;
					}
				},
				error: function(a,b,c){
					alert('오류[2]');
					return;
				}
				
			});
			
			
/* 			var existFile1 = $(".con_file ul:eq(0) dd:eq(1) li").length;
			
			var existFile6 = $(".con_file ul:eq(0) dd:eq(0) li").length; */
			
		/* 	
		주석 풀것..
		if(existFile1 == 0 || existFile6 == 0){
				
				return alert("<1. 포장지시안>과 <4. 제품이미지> 파일 첨부가 완료된 후에 \n결재상신 가능합니다.");
			} */
			
/* 			var tbKey = "";
			
			$("input[name=check_mfg_doc]").each(function(){
				if($(this).is(":checked")){
					if(tbKey == ""){
						tbKey = $(this).val();		
					}else {
						tbKey = tbKey +","+$(this).val();
					}
				}	
			}); */
			
		/* 	$("#tbKeyManu").val(tbKey); */
			
			
			
			/* $.ajax({
				url: '/dev/approvalRequestPopup',
				type: 'post',
				data: {
					tbType: "manufacturingProcessDoc"
				}, 
				async : false,
				success: function(data){
					if(data.status == 'S'){
						if(data.grade == '6'){
							alert("<1. 포장지시안>과 <4. 제품이미지> 파일 첨부가 완료된 후에 \n결재상신 가능합니다.");
						}else{
							openDialog(id);
							$("#userId1Manu").val(data.userId);
							
							$("#apprLineManu").empty();
							$("#apprLineSelectManu").empty();
							
							for(var i=0 ;i<data.regUserData.length;i++){
								$("#apprLineManu").append("<li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class='s01'> 기안자</span>"+data.regUserData[i].userName+"<strong>"+data.regUserData[i].titCodeName+"/"+data.regUserData[i].deptFullName+"</strong></li>");
							}
							
							$("#apprLineManu")
							.append("<li id='manufacPayment1'><img src='../resources/images/icon_del_file.png'><span>합의1</span><strong></strong></li>")
							.append("<li id='manufacPayment2'><img src='../resources/images/icon_del_file.png'><span>합의2</span><strong></strong></li>")
							.append("<li id='manufacPaymentLeader'><img src='../resources/images/icon_del_file.png'><span>팀장</span><strong></strong></li>")
							.append("<li id='manufacPaymentDirector'><img src='../resources/images/icon_del_file.png'><span>연구소장</span> <strong></strong></li>")
							.append("<li id='manufacPaymentParter'><img src='../resources/images/icon_del_file.png'><span>파트장</span><strong></strong></li>");
							
							for(var i=0; i<data.approvalLineList.length; i++){
								$("#apprLineSelectManu").append("<option value"+data.approvalLineList[i].apprLineNo+">"+data.approvalLineList[i].lineName+"</option>");
							}
						}
						
					}
					else {
						return alert('오류(F)');
					}
				},
				error: function(a,b,c){
					return alert('오류(http error)');
				}
			}); */
			/* $.ajax({
				url: '/dev/approvalRequestPopup',
				type: 'post',
				data: {
					tbType: "manufacturingProcessDoc"
				}, 
				async : false,
				success: function(data){
					if(data.status == 'S'){
						if(data.grade == '6'){
							alert("권한이 없습니다.");
						}else{
							openDialog(id);			
							$("#userIdManuArr").val('');
							$("#userIdManuArr").val(data.userId);
							$("#manuTitle").val('');
							$("#launchDateManu").val('');
							
							$("#CirculationRefLineManu").empty();
							$("#userId7Manu").val('');
							$("#userId8Manu").val('');
							$("#apprLineManu").empty();
							$("#apprLineSelectManu").empty();
							
							for(var i=0 ;i<data.regUserData.length;i++){
								$("#apprLineManu").append("<li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class='s01'> 기안자</span>"+data.regUserData[i].userName+"<strong>"+data.regUserData[i].titCodeName+"/"+data.regUserData[i].deptFullName+"</strong><input type='hidden' value="+data.regUserData[i].userId+"></li>");
							}
							
							for(var i=0; i<data.approvalLineList.length; i++){
								$("#apprLineSelectManu").append("<option value="+data.approvalLineList[i].apprLineNo+">"+data.approvalLineList[i].lineName+"</option>");
							}
						}
						
					}
					else {
						return alert('오류(F)');
					}
				},
				error: function(a,b,c){
					return alert('오류(http error)');
				}
			});  */
			
		}
		if(id=="approval_manufacturingNo"){
			var tbKey = '';
			var companyCd = '';
            var tbKeyList = [];
			$("input[name=check_manufacturingNo]").each(function (searchElement, fromIndex){
				if($(this).is(":checked")){
                    var tbKeyItem = $(this).data("seq") + "";
                    if(tbKeyList.indexOf(tbKeyItem) == -1){ //중복제거
                        tbKeyList.push(tbKeyItem);
                        if(tbKey == ""){
                            tbKey = tbKeyItem;
                            companyCd = $(this).data("companyCode");
                        }else {
                            tbKey = tbKey + "," + tbKeyItem;
                            companyCd = companyCd + "," + $(this).data("companyCode");
                        }
                    }
				}
			});

			if(tbKey == ""){
				return alert("중단요청 상신하실 품목제조보고서를 선택해주세요.");
			}
			// TODO 대응 제조공정서 중지 여부 판단 (중지:state = 6) , 중지되지 않았을경우 메세지 띄우고 끝: 해당 제조공정서가 중지되지 않았습니다. data("state")
			console.log(tbKey);
			$('#lab_loading').show();
			checkDocState(tbKey,function(){
				$.ajax({
					url: '/dev/approvalRequestPopup',
					type: 'post',
					data: {
						tbType: "manufacturingNoStopProcess"
					},
					async : false,
					success: function(data){
						console.log(data);
						if(data.status == 'S'){
							if(data.grade == '6'){
								return alert("권한이 없습니다.");
							}else{
								var selectedSeqArr = [];
								tbKey.split(',').forEach(function(item){
									selectedSeqArr.push(item)
								});
								openDialog(id);

								$("#deptFulName").val('');
								$("#titCodeName").val('');
								$("#userId").val('');
								$("#userName").val('');

								$("#userIdManufacturingNoArr").val('');
								$("#userIdManufacturingNoArr").val(data.userId);
								$("#ManufacturingNoTitle").val('');
								$("#stopMonthManufacturingNo").val(''); //제품출시일

								$("#CirculationRefLineManufacturingNo").empty();
								$("#userId7ManufacturingNo").val('');
								$("#userId8ManufacturingNo").val('');
								$("#apprLineManufacturingNo").empty();
								$("#apprLineSelectManufacturingNo").empty();
								$("#manufacturingNoKeyword").val('');
								$(".app_line_edit .req").eq(3).val('');
								$("#ManufacturingNoCompanyCd").val(companyCd);
								$("#tbKeyManufacturingNo").val(tbKey);

								for(var i=0 ;i<data.regUserData.length;i++){
									$("#apprLineManufacturingNo").append("<li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class='s01'>기안자</span>  "+data.regUserData[i].userName+"<strong>"+"/"+data.regUserData[i].userId+"/"+data.regUserData[i].deptCodeName+"/"+data.regUserData[i].teamCodeName+"</strong><input type='hidden' value="+data.regUserData[i].userId+"></li>");
								}

								$("label[for=apprLineSelectManufacturingNo]").html("----결재선 불러오기----");
								$("#apprLineSelectManufacturingNo").append("<option value=''>----결재선 불러오기----</option>");

								for(var i=0; i<data.approvalLineList.length; i++){
									$("#apprLineSelectManufacturingNo").append("<option value="+data.approvalLineList[i].apprLineNo+">"+data.approvalLineList[i].lineName+"</option>");
								}
								$('#lab_loading').hide();
							}
						} else {
							return alert('오류(F)');
						}
					},
					error: function(a,b,c){
						return alert('오류(http error)');
					}
				});
			});
		}
	}

	//품목제조보고서와 맵핑된 제조공정서가 상태값이 사용중지 여부를 체크 (사용중지:manufacturingProcessDoc.state=6)
	function checkDocState(seqKeys,callback){
		var url = "/dev/getDocStateListBySeq?seqKeys=" + seqKeys;
		$.post(url,null,function(data){
			console.log(data);
			var result = true;
			var message = "";
			data.forEach(function(item,index){
				if(item.state != 6){
					result = false;
					message += "품보번호:[" + item.licensingNo + "-" + item.manufacturingNo + "]" +
						" 해당 제조공정서:" + "[" + item.docNo + "]" + //item.productName +
						" 사용중지 되지 않았습니다.\n";
				}
			});
			if(result){
				callback();
			}else{
				$('#lab_loading').hide();
				alert(message);
			}
		});
	}
	
	function checkTrailValid(tbKey){
		var docNo = '${productDevDoc.docNo}';
		var docVersion = '${productDevDoc.docVersion}';
		
		var resultStats = true;
		
		$.ajax({
			url: '/dev/checkTrailValid',
			type: 'POST',
			async: false,
			data: {
				docNo: docNo
				, docVersion: docVersion
				, tbKey: tbKey
			},
			success: function(data){
				if(data.length > 0){
					for (var i = 0; i < data.length; i++) {
						var row = data[i];
						var status = row.valid;
						if(status == false){
							alert("본 문서(문서번호:"+row.dNo+")는 시생산 보고서가 등록되지 않아 결재상신을 할수 없습니다.");
							resultStats = false;
						}
					}
				}
			},
			error: function(a,b,c){
				//console.log(a,b,c);
				alert('시생산보고서 유효성 검사 오류');
				resultStats = false;
			}			
		})
		
		return resultStats;
	}
	
	function hasAuthority(userId,regUserId,grade,hasAuthorityCnt){
		
		if(grade == '8'){
			return true;
		}else if(userId == regUserId){
			return true;
		}else if(hasAuthorityCnt > 0){
			return true;
		}else{
			return false;
		}
		
	}
	
	function checkDesignApprValid(){
		var drNoCnt = $('input[type=checkbox][name=check_design_doc]:checked').length;
		
		if(drNoCnt == 0){
			alert('선택된 디자인의뢰서가 없습니다. 디자인의뢰서를 선택해주세요');
			$('#lab_loading').hide();
			return false;
		}
		if(drNoCnt > 1){
			alert('하나의 디자인의뢰서만 선택해주세요.');
			$('#lab_loading').hide();
			return false;
		}
		
		var drTargetObj = $('input[type=checkbox][name=check_design_doc]:checked');
		var state = drTargetObj.siblings('input[name=designReqDocState]').val();
		var designReqDocregUserId = drTargetObj.siblings('input[name=designReqDocregUserId]').val();
		var loginUserId = '${userUtil:getUserId(pageContext.request)}';
		
		if(loginUserId != designReqDocregUserId){
			alert("본 문서의 작성자가 아니므로 결재 상신을 할 수 없습니다.");
			return false;
		}
		
		if(state == '1'){
			alert("이미 검토중입니다.");
			$(obj).prop("checked",false);
			return false;
		} else if(state == '2'){
			alert("검토완료된 문서입니다.");
			$(obj).prop("checked",false);
			return false;
		}
		
		return true;
	}
	
	function targetCheck(obj,state,regUserId){
		
		var userId = "${userId}";
		
		if(state == '1'){
			alert("이미 검토중입니다.");
			$(obj).prop("checked",false);
			return;
		} else if(state == '2'){
			alert("검토완료된 문서입니다.");
			$(obj).prop("checked",false);
			return;
		}
		
		if(userId != regUserId){
			alert("본 문서의 작성자가 아니므로 결재 상신을 할 수 없습니다.");
			$(obj).prop("checked",false);
			return;
		}
		
	   var cnt = 0;
		$("input[name=check_design_doc]").each(function(){
			if($(this).is(":checked")){
				cnt++;						
				if(cnt > 1){
					alert("이미 선택된 건이 있습니다.");
					$(this).prop("checked", false);
					return;
				}
			}
		});
		
	}
	
	
	function disableStr(obj,state,docType,subProdCnt,sumExcRate,sumIncRate){
		
		return;
	
		var stateStr = "";
		
		var hasAuthority = "${hasAuthority}"
		
		if(state == "0"){
			stateStr = "등록";
		}else if(state == "1"){
			stateStr = "승인";
		}else if(state == "2"){
			stateStr = "반려";
		}else if(state == "3"){
			stateStr = "결재중";
		}else if(state == "4"){
			stateStr = "ERP반영완료";
		}else if(state == "5"){
			stateStr = "ERP반영오류";
		}else if(state == "6"){
			stateStr = "사용중지";
		}else if(state == "7"){
			stateStr = "임시저장";
		}
		
		if(docType == "E"){
			alert("본 문서는 엑셀로 업로드 제조공정서 이므로 결재 상신을 할 수 없습니다.");
			$(obj).prop("checked",false);
		} else if(state=="1" || state=="3" || state=="4" || state=="5" || state=="6" || state=="7"){
			alert("본 문서는 "+stateStr+" 상태이므로 결재상신을 할수 없습니다.");
			$(obj).prop("checked",false);
		} else if(hasAuthority == "false"){
			alert("본 문서의 작성자가 아니므로 결재상신을 없습니다.");
			$(obj).prop("checked",false);
		} else{
			
			if("1"==subProdCnt){
				
				if(sumExcRate != '100.000' || sumIncRate != '100.000' ){
					alert("본 문서는 표시사항 배합비의 합계가 100이 아니므로 결재 상신을 할수 없습니다. * 백분율:" +sumExcRate+" *급수포함: "+sumIncRate);
					$(obj).prop("checked",false);
				}
			}
		}
	}
	
	function loadCodeList( groupCode, objectId ) {
		var URL = "../common/codeListAjax";
		$.ajax({
			type:"POST",
			url:URL,
			data:{
				"groupCode":groupCode
			},
			dataType:"json",
			async:false,
			success:function(data) {
				var list = data.RESULT;
				$("#"+objectId).removeOption(/./);
				$("#"+objectId).addOption("", "전체", false);
				$("#label_"+objectId).html("전체");
				$.each(list, function( index, value ){ //배열-> index, value
					$("#"+objectId).addOption(value.itemCode, value.itemName, false);
				});
				
			},
			error:function(request, status, errorThrown){
				$("#"+objectId).removeOption(/./);
				alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
			}			
		});
	}
	
	function loadProductType( e, grade, objectId ) {
		var URL = "../common/productTypeListAjax";
		var groupCode = "PRODCAT"+grade;
		var codeValue = e.target.value;
		
		$(e.target).parent().parent().children().toArray().forEach(function(prodTypeDiv, index){
			if(index >= (Number(grade)-1)) $(prodTypeDiv).hide();
		})
		
		$.ajax({
			type:"POST",
			url:URL,
			data:{
				"groupCode":groupCode,
				"codeValue":codeValue
			},
			dataType:"json",
			async:false,
			success:function(data) {
				var list = data.RESULT;
				$("#"+objectId).removeOption(/./);
				$("#"+objectId).addOption("", "전체", false);
				$("#label_"+objectId).html("전체");
				$.each(list, function( index, value ){ //배열-> index, value
					$("#"+objectId).addOption(value.itemCode, value.itemName, false);
				});
				if(list.length > 0) $(e.target).parent().next().show();
			},
			error:function(request, status, errorThrown){
				element.removeOption(/./);
				$("#li_"+element.prop("id")).hide();
				alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
			}			
		});
	}
	
	function getPrdCode(e){
		$('#lab_loading').show();
		$('#prdCodeDiv').hide();
		e.preventDefault();
		
		var productCode = $('#productCode').val();
		if(productCode.length != 6){
			alert('제품코드 6자리를 입력해주세요');
			$('#lab_loading').hide();
			return;
		}
		
		var searchValue = $('#productCode').val();
		$.ajax({
			url: '/data/getMaterialList',
			type: 'post',
			dataType: 'json',
			data: {
				searchValue: searchValue
			},
			success: function(data){
				if(data.length <= 0){
					alert('제품코드와 일치하는 정보를 찾을 수 없습니다.');
					$('#lab_loading').hide();
					return;
				}
				
				$('#productCode_select').empty();
				$('#productCode_select').append('<option value="">선택</option>')
				$('#label_productCode_select').text('선택');
				data.forEach(function(mat){
					var text = '[' + mat.company + '-'+mat.plant + '] ' + mat.name + '(' + mat.regDate +')';
					$('#productCode_select').append('<option value="'+mat.imNo+','+mat.sapCode+'">' + text + '</option>')
				})
				
				$('#prdCodeDiv').show();
				$('#lab_loading').hide();
			},
			error: function(a,b,c){
				//console.log(a,b,c)
				alert('제품코드 검색 실패[2] - 시스템 담당자에게 문의하세요');
				$('#lab_loading').hide();
			}
		})
	}
	
	// 홍원석
	
	function changePrdCode(e){
		var imNo = e.target.value.split(',')[0];
		var sapCdoe = e.target.value.split(',')[1];
		var name = $('#productCode_select option:selected').text();
		
		var startNdx = $('#productCode_select option:selected').text().indexOf('] ');
		var endNdx = $('#productCode_select option:selected').text().lastIndexOf('(');
		var name = name.substr(startNdx+2, endNdx-(startNdx+2));
		
		$('#productCode').val(sapCdoe);
		$('#imNo').val(imNo);
		$('input[name=productName]').val(name)
	}
	
	function getMfgNo(e){
		$('#lab_loading').show();
		$('#reqDiv').hide();
		e.preventDefault();
		
		var mfgNo = $('input[name=manufacturingNo]').val();
		$.ajax({
			url: '/manufacturingNo/getMfgNoList',
			type: 'post',
			dataType: 'json',
			data: {
				mfgNo: mfgNo
			},
			success: function(data){
				if(data.length <= 0){
					alert('품목제조보고 번호를 찾을 수 없습니다.');
					$('#lab_loading').hide();
					return;
				}
				
				$('#reqNum_select').empty();
				$('#reqNum_select').append('<option value="">선택</option>')
				data.forEach(function(row){
					var text = '[' + row.manufacturingNo + '] ' + row.companyCode + ' ' + row.manufacturingName;
					$('#reqNum_select').append('<option value="'+ row.seq+','+ row.manufacturingNo+'">' + text + '</option>')
				})
				
				$('#reqDiv').show();
				$('#lab_loading').hide();
			},
			error: function(a,b,c){
				//console.log(a,b,c)
				alert('품목제조보고번호 검색 실패[2] - 시스템 담당자에게 문의하세요');
				$('#lab_loading').hide();
			}
		})
	}
	
	function changeRegNum(e){
		var manufacturingNo = e.target.value.split(',')[1];
		var seq = e.target.value.split(',')[0];
		
		$('#reqNum').val(manufacturingNo);
		$('#manufacturingNoSeq').val(seq);
	}
	
	function openStateDialog(state){
		var docNo = '${productDevDoc.docNo}';
		var docVersion = '${productDevDoc.docVersion}';
		var stateText = ( (state == 2) ? '보류' : (state == 1) ? '제품중단' : '진행(생산)중' );
		
		$('#changeStateForm input[name=isClose]').val(state);
		
		if(confirm('제품개발문서의 상태를 ['+stateText+'](으)로 변경하시겠습니까?')){
			if(state == 0){
				$.ajax({
					url: '/dev/updateDevDocCloseState',
					type: 'post',
					data: $('#changeStateForm').serialize(),
					success:function(data){
						if(data == 'S'){
							alert('상태가 변경되었습니다');
							reload();
							return;
						} else {
							return ('상태 변경 오류[1]');
						}
					},
					error: function(a,b,c){
						//console.log(a,b,c)
						return ('상태 변경 오류[2]');
					}
				})
			}
			
			if(state == 1 || state == 2){
				openDialog('dialog_state');
			}
		}
	}
	
	function changeDevDocState(state){
		$.ajax({
			url: '/dev/updateDevDocCloseState',
			type: 'post',
			data: $('#changeStateForm').serialize(),
			success:function(data){
				if(data == 'S'){
					alert('상태가 변경되었습니다');
					reload();
					return;
				} else {
					alert('상태변경 오류');
					return ('상태 변경 오류[1]');
				}
			},
			error: function(a,b,c){
				//console.log(a,b,c)
				return ('상태 변경 오류[2]');
			}
		})
	}
	
	function changeApprLine(obj){
		
		var obj =  $(obj);
	
		var selectId = obj.attr("id");
		
		var apprLineNo = $("#"+selectId).val();
		
		$.ajax({
			url: '/approval/getDetailApprovalLineList',
			type: 'post',
			data: {
				apprLineNo: apprLineNo
			}, 
			async : false,
			success: function(data){
				if(data.status == 'S'){
					
					var length = '';
					
					var approvalLineList = data.approvalLineList;
					
					var approvalLineAppr = [];
					
					var approvalLineRef = [];
					
					var html = "";
					
					if(selectId == 'apprLineSelect'){
						
						length = $("#apprLine li").length;
						
						for(var i=1; i<length; i++){
							$("#apprLine li").eq(1).remove();
						} 
						
						var userIdDesignArr = $("#userIdDesignArr").val().split(",");
						
						$("#userIdDesignArr").val(userIdDesignArr[0]);
						
						$("#CirculationRefLine").empty();
						$("#userId5").val('');
						$("#userId6").val('');
						
						for(var i=0; i<approvalLineList.length; i++){
							if(approvalLineList[i].apprType !='R' && approvalLineList[i].apprType !='C'){
								approvalLineAppr.push(approvalLineList[i]);
							}else{
								approvalLineRef.push(approvalLineList[i]);
							}
						}
						
						var newUserDesignIdArr =  $("#userIdDesignArr").val().split(",");
						
						
						for(var i=0; i<approvalLineAppr.length; i++){
							
							html = '<li><img src="../resources/images/icon_del_file.png" name="delImg"><span>'+(i+1)+'차 결재</span>  '+approvalLineAppr[i].userName+'<strong>'+"/"+approvalLineAppr[i].targetUserId+"/"+approvalLineAppr[i].deptCodeName+'/'+approvalLineAppr[i].teamCodeName+'</strong><input type="hidden" value='+approvalLineAppr[i].targetUserId+'></li>';
							
							$("#apprLine").append(html);
							
							newUserDesignIdArr.push(approvalLineAppr[i].targetUserId);
						}
						
						$("#userIdDesignArr").val(newUserDesignIdArr.join(","));
						
						var newUserId5Arr = [];
						
						var newUserId6Arr = [];
						
						for(var i=0; i<approvalLineRef.length; i++){
							
							if(approvalLineRef[i].apprType == 'R'){
								html = '<li><img src="../resources/images/icon_del_file.png" name="delImg"><span>참조</span>  '+approvalLineRef[i].userName+'<strong>'+'/'+approvalLineRef[i].targetUserId+"/"+approvalLineRef[i].deptCodeName+'/'+approvalLineRef[i].teamCodeName+'</strong><input type="hidden" name="userId" value='+approvalLineRef[i].targetUserId+'><input type="hidden" name="apprType" value="R"></li>';
								newUserId5Arr.push(approvalLineRef[i].targetUserId);
							
							}else{
								html = '<li><img src="../resources/images/icon_del_file.png" name="delImg"><span>회람</span>  '+approvalLineRef[i].userName+'<strong>'+'/'+approvalLineRef[i].targetUserId+"/"+approvalLineRef[i].deptCodeName+'/'+approvalLineRef[i].teamCodeName+'</strong><input type="hidden" name="userId" value='+approvalLineRef[i].targetUserId+'><input type="hidden" name="apprType" value="C"></li>';
								newUserId6Arr.push(approvalLineRef[i].targetUserId);
							}
							
							$("#CirculationRefLine").append(html);
								
						}
						
						$("#userId5").val(newUserId5Arr.join(","));
						
						$("#userId6").val(newUserId6Arr.join(","));
						
					}else if(selectId === 'apprLineSelectTrial'){
						
						length = $("#apprLineTrial li").length;
						for(var i=1; i<length; i++){
							$("#apprLineTrial li").eq(1).remove();
						}
						
						var userIdTrialArr = $("#userIdTrialArr").val().split(",");
						$("#userIdTrialArr").val(userIdTrialArr[0]);
						
						$("#CirculationRefLineTrial").empty();
						$("#userId7Trial").val('');
						$("#userId8Trial").val('');
						
						for(var i=0; i<approvalLineList.length; i++){
							if(approvalLineList[i].apprType != 'R' && approvalLineList[i].apprType != 'C'){
								approvalLineAppr.push(approvalLineList[i]);
							}else{
								approvalLineRef.push(approvalLineList[i]);
							}
						}
						
						var newUserTrialIdArr = $("#userIdTrialArr").val().split(",");
						for(var i=0; i<approvalLineAppr.length; i++){
							html = '<li><img src="../resources/images/icon_del_file.png" name="delImg"><span>'+(i+1)+'차 결재</span>  '+approvalLineAppr[i].userName+'<strong>'+"/"+approvalLineAppr[i].targetUserId+"/"+approvalLineAppr[i].deptCodeName+'/'+approvalLineAppr[i].teamCodeName+'</strong><input type="hidden" value='+approvalLineAppr[i].targetUserId+'></li>';
							$("#apprLineTrial").append(html);
							newUserTrialIdArr.push(approvalLineAppr[i].targetUserId);
						}
						$("#userIdTrialArr").val(newUserTrialIdArr.join(","));
						
						var newUserId7Arr = [];
						var newUserId8Arr = [];
						
						for(var i=0; i<approvalLineRef.length; i++){
							if(approvalLineRef[i].apprType == 'R'){
								html = '<li><img src="../resources/images/icon_del_file.png" name="delImg"><span>참조</span>  '+approvalLineRef[i].userName+'<strong>'+'/'+approvalLineRef[i].targetUserId+"/"+approvalLineRef[i].deptCodeName+'/'+approvalLineRef[i].teamCodeName+'</strong><input type="hidden" name="userId" value='+approvalLineRef[i].targetUserId+'><input type="hidden" name="apprType" value="R"></li>';
								newUserId7Arr.push(approvalLineRef[i].targetUserId);
							}else{
								html = '<li><img src="../resources/images/icon_del_file.png" name="delImg"><span>회람</span>  '+approvalLineRef[i].userName+'<strong>'+'/'+approvalLineRef[i].targetUserId+"/"+approvalLineRef[i].deptCodeName+'/'+approvalLineRef[i].teamCodeName+'</strong><input type="hidden" name="userId" value='+approvalLineRef[i].targetUserId+'><input type="hidden" name="apprType" value="C"></li>';
								newUserId8Arr.push(approvalLineRef[i].targetUserId);
							}
							$("#CirculationRefLineTrial").append(html);
						}
						$("#userId7Trial").val(newUserId7Arr.join(","));
						$("#userId8Trial").val(newUserId8Arr.join(","));
						
						console.log( $("#userId7Trial").val() ); 
						console.log( $("#userId8Trial").val() ); 
						
					}else if(selectId == "apprLineSelectManu"){
						
						length = $("#apprLineManu li").length;

						for(var i=1; i<length; i++){
							$('#apprLineManu li').eq(1).remove();
						}

						var userIdManuArr = $("#userIdManuArr").val().split(",");

						$("#userIdManuArr").val(userIdManuArr[0]);

						$("#CirculationRefLineManu").empty();
						$("#userId7Manu").val('');
						$("#userId8Manu").val('');

						for(var i=0; i<approvalLineList.length; i++){
							if(approvalLineList[i].apprType !='R' && approvalLineList[i].apprType !='C'){
								approvalLineAppr.push(approvalLineList[i]);
							}else{
								approvalLineRef.push(approvalLineList[i]);
							}
						}

						var newUserManuIdArr =  $("#userIdManuArr").val().split(",");

						for(var i=0; i<approvalLineAppr.length; i++){

							html = '<li><img src="../resources/images/icon_del_file.png" name="delImg"><span>'+(i+1)+'차 결재</span>  '+approvalLineAppr[i].userName+'<strong>'+'/'+approvalLineAppr[i].targetUserId+'/'+approvalLineAppr[i].deptCodeName+'/'+approvalLineAppr[i].teamCodeName+'</strong><input type="hidden" value='+approvalLineAppr[i].targetUserId+'></li>';

							$("#apprLineManu").append(html);

							newUserManuIdArr.push(approvalLineAppr[i].targetUserId);
						}

						$("#userIdManuArr").val(newUserManuIdArr.join(","));

						var newUserId7ManuArr = [];

						var newUserId8ManuArr = [];

						for(var i=0; i<approvalLineRef.length; i++){

							if(approvalLineRef[i].apprType == 'R'){
								html = '<li><img src="../resources/images/icon_del_file.png" name="delImg"><span>참조</span>  '+approvalLineRef[i].userName+'<strong>'+'/'+approvalLineRef[i].targetUserId+'/'+approvalLineRef[i].deptCodeName+'/'+approvalLineRef[i].teamCodeName+'</strong><input type="hidden" name="userId" value='+approvalLineRef[i].targetUserId+'><input type="hidden" name="apprType" value="R"></li>';
								newUserId7ManuArr.push(approvalLineRef[i].targetUserId);
							}else{
								html = '<li><img src="../resources/images/icon_del_file.png" name="delImg"><span>회람</span>  '+approvalLineRef[i].userName+'<strong>'+'/'+approvalLineRef[i].targetUserId+'/'+approvalLineRef[i].deptCodeName+'/'+approvalLineRef[i].teamCodeName+'</strong><input type="hidden" name="userId" value='+approvalLineRef[i].targetUserId+'><input type="hidden" name="apprType" value="C"></li>';
								newUserId8ManuArr.push(approvalLineRef[i].targetUserId);
							}

							$("#CirculationRefLineManu").append(html);
						}

						$("#userId7Manu").val(newUserId7ManuArr.join(","));

						$("#userId8Manu").val(newUserId8ManuArr.join(","));
						
					}else if(selectId == "apprLineSelectManufacturingNo"){
						length = $("#apprLineManufacturingNo li").length;

						for(var i=1; i<length; i++){
							$('#apprLineManufacturingNo li').eq(1).remove();
						}

						var userIdManufacturingNoArr = $("#userIdManufacturingNoArr").val().split(",");

						$("#userIdManufacturingNoArr").val(userIdManufacturingNoArr[0]);

						$("#CirculationRefLineManufacturingNo").empty();
						$("#userId7ManufacturingNo").val('');
						$("#userId8ManufacturingNo").val('');

						for(var i=0; i<approvalLineList.length; i++){
							if(approvalLineList[i].apprType !='R' && approvalLineList[i].apprType !='C'){
								approvalLineAppr.push(approvalLineList[i]);
							}else{
								approvalLineRef.push(approvalLineList[i]);
							}
						}

						var newUserIdManufacturingNoArr =  $("#userIdManufacturingNoArr").val().split(",");

						for(var i=0; i<approvalLineAppr.length; i++){

							html = '<li><img src="../resources/images/icon_del_file.png" name="delImg"><span>'+(i+1)+'차 결재</span>  '+approvalLineAppr[i].userName+'<strong>'+'/'+approvalLineAppr[i].targetUserId+'/'+approvalLineAppr[i].deptCodeName+'/'+approvalLineAppr[i].teamCodeName+'</strong><input type="hidden" value='+approvalLineAppr[i].targetUserId+'></li>';

							$("#apprLineManufacturingNo").append(html);

							newUserIdManufacturingNoArr.push(approvalLineAppr[i].targetUserId);
						}

						$("#userIdManufacturingNoArr").val(newUserIdManufacturingNoArr.join(","));

						var newUserId7ManufacturingNoArr = [];

						var newUserId8ManufacturingNoArr = [];

						for(var i=0; i<approvalLineRef.length; i++){

							if(approvalLineRef[i].apprType == 'R'){
								html = '<li><img src="../resources/images/icon_del_file.png" name="delImg"><span>참조</span>  '+approvalLineRef[i].userName+'<strong>'+'/'+approvalLineRef[i].targetUserId+'/'+approvalLineRef[i].deptCodeName+'/'+approvalLineRef[i].teamCodeName+'</strong><input type="hidden" name="userId" value='+approvalLineRef[i].targetUserId+'><input type="hidden" name="apprType" value="R"></li>';
								newUserId7ManufacturingNoArr.push(approvalLineRef[i].targetUserId);
							}else{
								html = '<li><img src="../resources/images/icon_del_file.png" name="delImg"><span>회람</span>  '+approvalLineRef[i].userName+'<strong>'+'/'+approvalLineRef[i].targetUserId+'/'+approvalLineRef[i].deptCodeName+'/'+approvalLineRef[i].teamCodeName+'</strong><input type="hidden" name="userId" value='+approvalLineRef[i].targetUserId+'><input type="hidden" name="apprType" value="C"></li>';
								newUserId8ManufacturingNoArr.push(approvalLineRef[i].targetUserId);
							}

							$("#CirculationRefLineManufacturingNo").append(html);
						}

						$("#userId7ManufacturingNo").val(newUserId7ManufacturingNoArr.join(","));

						$("#userId8ManufacturingNo").val(newUserId8ManufacturingNoArr.join(","));
					}
					

				}
				else {
					return alert('오류(F)');
				}
			},
			error: function(a,b,c){
				return alert('오류(http error)');
			}
		});
		
	}
	
	function updateBOM(){
		$('#lab_loading').show();
		var selectedMfgDNoArr = [];
		var selectedStateArr = [];
		var productCode = '${productDevDoc.productCode}';
		
		var mfgBody = $('#mfgTable').children('tbody');
		mfgBody.children('tr').children('td').children('input[type=checkbox]').toArray().forEach(function(input){
			if($(input).is(':checked')){
				selectedMfgDNoArr.push($(input).parent().next().children('a').text())
				selectedStateArr.push($(input).next().next().next().val());
			}
		})
		
		if(productCode == null || productCode == '0'){
			alert('필수값 입력 오류: 제품코드를 입력 하지 않았습니다.');
			$('#lab_loading').hide();
			return;
		}
		
		
		if(selectedMfgDNoArr.length <= 0){
			alert('선택된 제조공정서가 없습니다. 제조공정서를 선택해주세요');
			$('#lab_loading').hide();
			return 
		} 
		
		/* 
		if(selectedMfgDNoArr.length > 1){
			return alert('하나의 제조공정서만 선택해주세요.');
		}
		 */
		var count = 0;
		selectedStateArr.forEach(function(item){
			// BOM반영 가능 state값  = 1: 승인, 4: ERP반영 완료, 5: ERP반영 오류
			if( item != '1' && item != '4' && item != '5' ) {
				count++;
			}
		});
		
		if( count > 0 ) {
			//alert("BOM 반영을 할 수 없습니다.");
			alert("BOM 반영을 할 수 없는 상태의 제조공정서가 포함되어 있습니다.")
			$('#lab_loading').hide();
		} else {
			$.ajax({
				url: '/dev/updateBOM?dNoList='+selectedMfgDNoArr,
				type: 'POST',
				dataType: 'JSON',
				success: function(data){
					var alertStr = "";
					
					if(data.header == null){
						alert("BOM등록 오류");
						reload();
						
						$('#lab_loading').hide();
						return;
					}
					
					if(data.header.resultFlag == 'S'){
						if(data.item != undefined){
							if(data.item.resultFlag == 'S' || data.item.resultFlag == 'X'){
								alertStr = '등록되었습니다.';
								if(data.item.resultFlag == 'X'){
									alertStr += '\n(세부항목은 변경되지 않았습니다)'
								}
							} else {
								alertStr = 'BOM등록 오류['+data.item.resultFlag+'] '+data.item.resultMessage;
								if(data.item.itemErrMessage != undefined){
									alertStr += "\n\n" + data.item.itemErrMessage;
								}
							}
						} else {
							alertStr = '등록되었습니다.';
						}
					} else {
						alertStr = 'BOM등록 오류['+data.header.resultFlag+'] '+data.header.resultMessage;
						
						if(data.header.itemErrMessage != undefined){
							alertStr += "\n\n" + data.header.itemErrMessage;
						}
					}
					
					alert(alertStr);
					reload();

					$('#lab_loading').hide();
				},
				error: function(a,b,c){
					//console.log(a,b,c)
					alert('BOM업데이트 오류[2]');
					reload();
					
					$('#lab_loading').hide();
					return;
				}
			});
		}
		
	}
	
	function deleteDevDoc(){
		if(!confirm('현재버전의 제품개발문서를 삭제하시겠습니까?')){
			return;
		}
		var ddNo = '${productDevDoc.ddNo}';
		var docNo = '${productDevDoc.docNo}';
		var docVersion = '${productDevDoc.docVersion}';
		
		$.ajax({
			url: '/dev/deleteProductDevDoc',
			type: 'post',
			data: {
				ddNo: ddNo,
				docNo: docNo,
				docVersion: docVersion
			},
			success: function(data){
				//console.log(data);
				if(data == 'S'){
					alert('정상적으로 삭제되었습니다');
					
					var docVersionList = '${docVersionList}';
					docVersionList = docVersionList.replace('[','').replace(']','').replace(/"/g,'').split(',');
					if(docVersionList.length > 1){
						changeVersion(docVersionList[1].trim());
					} else {
						location.href = '/dev/productDevDocList';
					}
				} else {
					return alert('제품개발문서 삭제오류[1]')
				}
			},
			error: function(a,b,c){
				//console.log(a,b,c)
				return alert('제품개발문서 삭제오류[2]')
			}
		})
	}
	
	function deleteDesignReqDoc(drNo){
		if(!confirm('디자인의뢰서[문서번호:'+drNo+']를 삭제하시겠습니까?')){
			return;
		}
		
		$.ajax({
			url: '/dev/deleteDesignRequestDoc',
			type: 'post',
			data: {
				drNo: drNo
			},
			success: function(data){
				if(data == 'S'){
					alert('정상적으로 삭제되었습니다');
					reload();
				} else {
					return alert('제품개발문서 삭제오류[1]')
				}
			},
			error: function(a,b,c){
				//console.log(a,b,c)
				return alert('제품개발문서 삭제오류[2]')
			}
		})
	}
	
	function editCommentMode(e, cNo, dNo){
		var comment = $(e.target).parent().children('span.comment_data').html().replace(/<br>/g, '\n');
		$(e.target).parent().parent().hide();
		
		var editElement = '<div class="comment_obj2">';
		editElement += '<div class="insert_comment">';
		editElement += '<table style="width: 738px; margin-left: 2px;">';
		editElement += '<tr>';
		editElement += '<td><textarea style="width: 100%; height: 50px; background-color: #fffeea;" placeholder="의견을 입력하세요">'+comment+'</textarea></td>';
		editElement += '<td width="81px"><button style="width: 95%; height: 52px; margin-top: -2px; font-size: 13px;" onclick="updateComment(event, \''+cNo+'\', \''+dNo+'\')">수정</button></td>';
		editElement += '<td width="80px"><button style="width: 100%; height: 52px; margin-top: -2px; font-size: 13px;" onclick="editCommentCancel(event)">수정취소</button></td>';
		editElement += '</tr>';
		editElement += '</table>';
		editElement += '</div>';
		editElement += '</div>';
		
		$(e.target).parent().parent().after(editElement);
	}
	
	function updateComment(e, cNo, dNo){
		$('#lab_loading').show();
		var comment = $(e.target).parent().prev().children('textarea').val();
		
		$.ajax({
		    url: '/comment/updateComment',
		    type: 'post',
		    data: {
		        cNo: cNo,
		        dNo: dNo,
		        comment: comment,
		    },
		    success: function(data){
		    	if(data == 'S'){
		    		alert('수정되었습니다.');
		    		openComment(dNo, 'manufacturingProcessDoc');
		    	} else {
		    		alert('수정 오류[1]');
		    	}
		    },
		    error: function(a,b,c){
		    	//console.log(a,b,c);
		    	return alert('수정 오류[2]');
		    },
		    complete: function(){
		    	$('#lab_loading').hide();
		    }
		})
		
	}
	
	function editCommentCancel(e){
		$(e.target).parent().parent().parent().parent().parent().parent().prev().show();
		$(e.target).parent().parent().parent().parent().parent().parent().remove();
	}
	
	function openComment(tbKey, tbType){
		var docNo = '${productDevDoc.docNo}';
		var docVersion = '${productDevDoc.docVersion}';
		
		var url = '/comment/commentPopup';
		url += "?tbKey="+tbKey;
		url += "&tbType="+tbType;
				
		var popupName = 'commentPopup';
		var w=1100;
		var h=650;
		var winl = (screen.width-w)/2;
		var wint = (screen.height-h)/2;
		var option ='height='+h+',';
		option +='width='+w+',';
		option +='scrollbars=yes,';
		option +='resizable=no';
		
		window.open(url, '', option);
	}
	
	
	function deleteComment(cNo, dNo){
		if(!confirm('선택한 의견을 정말 삭제하시겠습니까?')){
			return;
		}
		$('#lab_loading').show();
		var dNo = $('#commentTbKey').val();
		
		$.ajax({
		    url: '/comment/deleteComment',
		    type: 'post',
		    data: { cNo: cNo, dNo: dNo},
		    success: function(data){
		    	if(data == 'S'){
		    		$('#commentText').val('');
		    		alert('삭제되었습니다.');
		    		openComment(dNo, 'manufacturingProcessDoc');
		    	} else {
		    		alert('삭제 오류[1]');
		    	}
		    },
		    error: function(a,b,c){
		    	//console.log(a,b,c);
		    	return alert('삭제 오류[2]');
		    },
		    complete: function(){
		    	$('#lab_loading').hide();
		    }
		})
	}
	
	function addComment(){
		$('#lab_loading').show();
		var dNo = $('#commentTbKey').val();
		var docNo = '${productDevDoc.docNo}';
		var docVersion = '${productDevDoc.docVersion}';
		
		$.ajax({
		    url: '/comment/addComment',
		    type: 'post',
		    data: {
		        tbType: $('#commentTbType').val(),
		        tbKey: dNo,
		        comment: $('#commentText').val(),
		        docNo: docNo,
		        docVersion : docVersion
		    },
		    success: function(data){
		    	if(data == 'S'){
		    		$('#commentText').val('');
		    		alert('등록되었습니다.');
		    		openComment(dNo, 'manufacturingProcessDoc');
		    	} else {
		    		alert('등록 오류[1]');
		    	}
		    },
		    error: function(a,b,c){
		    	//console.log(a,b,c);
		    	return alert('등록 오류[2]');
		    },
		    complete: function(){
		    	$('#lab_loading').hide();
		    }
		})
	}
	
	function openDispPopup(dNo, docProdName){
		$('#selectedDocProdName').val(docProdName);
		
		var url = '/dev/dispPopup';
		url += "?dNo="+dNo;
		url += "&docProdName="+encodeURIComponent(docProdName);
		/* 
		if(confirm("백분율 출력은 '확인' 급수포함 출력은 '취소'를 선택해주세요.")){
			url += "&type=exc";
		} else {
			url += "&type=inc";
		}
		 */		
		var popupName = 'dispPopup';
		var w=1100;
		var h=650;
		var winl = (screen.width-w)/2;
		var wint = (screen.height-h)/2;
		var option ='height='+h+',';
		option +='width='+w+',';
		option +='scrollbars=yes,';
		option +='resizable=no';
		
		//window.open(url, popupName, option);
		window.open(url, '', option);
	}
	
	function callCreateDialog(){
		var imNo = '${productDevDoc.imNo}';
		var companyCode = $('#companyCode').val();
		if(companyCode == 'MD'){
			$('#radio_caclType4').click();
		} else {
			$('#radio_caclType1').click();
		}
		
		var count = 0;
		$("#designReqDocTable").children('tbody').children('tr').toArray().forEach(function(v, i){
			if( $(v).children('td').find('input[name=designReqDocState]').val() == '1' ){
				count++	
			}
		});
		if( count > 0 ) {
			alert("디자인의뢰서가 검토중일 때는 제조공정서를 생성할 수 없습니다.");
		} else {
			var form = document.createElement('form');
			$('body').append(form);
			form.action = '/dev/manufacturingProdcessCreate';
			form.method = 'post';
			$('#mfgCreateForm').remove();
			form.id = 'mfgCreateForm';
			$(form).append('<input name="docNo" type="hidden" value="'+${docNo}+'">');
			$(form).append('<input name="docVersion" type="hidden" value="'+${docVersion}+'">');
			$(form).append('<input name="calcType" type="hidden" value="">');
			
			openDialog('dialog_create');
		}
	}
	
	function preView( tbType, tbKey, docNo, docVersion ) {
		var url = "";
		var mode = "";
		if( tbType == 'manufacturingProcessDoc' ) {
			url = "/dev/manufacturingProcessDetailPopup?tbKey="+tbKey+"&tbType="+tbType+"&docNo="+docNo+"&docVersion="+docVersion;
			mode = "width=1100, height=650, left=100, top=50, scrollbars=yes";
		} else if( tbType == 'designRequestDoc' ) {
			url = "/dev/designRequestDetailPopup?tbKey="+tbKey+"&tbType="+tbType;
			mode = "width=1100, height=650, left=100, top=50, scrollbars=yes";
		} else if( tbType == 'manufacturingProcessDocForStores'){
			/*점포용 제조공정서*/
			url = "/dev/manufacturingProcessDetailPopupForStores?tbKey="+tbKey+"&tbType="+tbType+"&docNo="+docNo+"&docVersion="+docVersion;
			mode = "width=1100, height=650, left=100, top=50, scrollbars=yes";
		}	
		//window.open(url, "devDocPopup", mode );
		window.open(url, "", mode );
	}
	
	function editDesignReqDoc(drNo,isLatest){
		var docNo = '${productDevDoc.docNo}';
		var docVersion = '${productDevDoc.docVersion}';
		
		var form = document.createElement('form');
		form.style.display = 'none';
		$('body').append(form);
		form.action = '/dev/designRequestDocEdit';
		form.method = 'post';

		appendInput(form, 'docNo', docNo);
		appendInput(form, 'docVersion', form);
		appendInput(form, 'drNo', drNo);
		appendInput(form, 'isLatest', isLatest);
		
		form.submit();
	}
	
	function designReqView(drNo,isLatest){
		var docNo = '${productDevDoc.docNo}';
		var docVersion = '${productDevDoc.docVersion}';
		
		var form = document.createElement('form');
		form.style.display = 'none';
		$('body').append(form);
		form.action = '/dev/designRequestDocView';
		form.target = '_blank';
		form.method = 'post';

		appendInput(form, 'docNo', docNo);
		appendInput(form, 'docVersion', form);
		appendInput(form, 'drNo', drNo);
		appendInput(form, 'isLatest', isLatest);
		
		form.submit();
	}
	
	function copyDesignReqDoc(drNo){
		$('#lab_loading').show();
		
		if(!confirm('선택하신 디자인의뢰서를 복사하시겠습니까?')){
			$('#lab_loading').hide();
			return;
		}
		
		var docNo = '${productDevDoc.docNo}';
		var docVersion = '${productDevDoc.docVersion}';
		
		$.ajax({
			url: '/dev/designRequestDocCopy',
			type: 'post',
			data: {
				drNo: drNo,
				docNo: docNo,
				docVersion: docVersion
			},
			success: function(data){
				if(data == "S"){
					alert('디자인의뢰서가 복사되었습니다.');
					reload();
					window.opener.location.href = window.opener.location.href
				} else {
					alert('복사 실패[1] - 시스템 담당자에게 문의하세요');
					$('#lab_loading').hide();
				}
			},
			error: function(a,b,c){
				alert('복사 실패[1] - 시스템 담당자에게 문의하세요');
				$('#lab_loading').hide();
			}
		})
	}
	
	function deleteApprovalLine(obj){
		
		var id = $(obj).siblings("div").children("select").attr("id");
		
		var selectApprNo = $("#"+id).val();
		
		if(selectApprNo =='' || selectApprNo == undefined){
			alert('삭제하실 결재선을 선택해주세요!');
			return false;
		}
		
		var tbType = "";
        console.log(id);
		if(id == "apprLineSelectManufacturingNo"){
			tbType = "manufacturingNoStopProcess";
		}else if(id=='apprLineSelectManu'){
			tbType = 'manufacturingProcessDoc';
		}else if(id === 'apprLineSelectTrial'){
			tbType = 'trialProductionReport';
		}else{
			tbType = 'designRequestDoc';
		}
		
		$.ajax({
			type:'POST',
			url:"/approval/approvalLineDelete",
			data:{"apprLineNo" : selectApprNo
			},
			async:false,
			success:function(data){
				if(data.status == 'S'){
					
					$.ajax({
						type:"POST",
						url:"/approval/getApprLineList",
						data:{
							"tbType":tbType
						},
						dataType:"json",
						async:false,
						success:function(data){
							if(data.status=='S'){
								alert("성공적으로 삭제되었습니다.");
								
								var apprLineList = data.approvalLineList;

		        				if(tbType == "manufacturingNoStopProcess"){
                                    $("#deptFulName").val('');
                                    $("#titCodeName").val('');
                                    $("#userId").val('');
                                    $("#userName").val('');
                                    $("#userIdManufacturingNoArr").val('');
                                    $("#userIdManufacturingNoArr").val(data.userId);
                                    $("#ManufacturingNoTitle").val('');
                                    $("#stopMonthManufacturingNo").val('');
                                    $("#CirculationRefLineManufacturingNo").empty();
                                    $("#userId7ManufacturingNo").val('');
                                    $("#userId8ManufacturingNo").val('');
                                    $("#manufacturingNoKeyword").val('');
                                    $(".app_line_edit .req").eq(3).val('');

                                    var apprLength = $("#apprLineManufacturingNo li").length;

                                    for(var i=1; i<apprLength;i++){
                                        $("#apprLineManufacturingNo li").eq(1).remove();
                                    }

                                    $("#apprLineSelectManufacturingNo").empty();

                                    $("label[for=apprLineSelectManufacturingNo]").html("---- 결재선 불러오기 ----");
                                    $("#apprLineSelectManufacturingNo").append("<option value=''>---- 결재선 불러오기 ----</option>");

                                    for(var i=0;i<apprLineList.length;i++){
                                        $("#apprLineSelectManufacturingNo").append("<option value="+apprLineList[i].apprLineNo+">"+apprLineList[i].lineName+"</option>");
                                    }

                                }else if(tbType == 'designRequestDoc'){
			    	        		$("#deptFulName").val('');
								   	$("#titCodeName").val('');
								    $("#userId").val('');
								    $("#userName").val('');  
									$("#userIdDesignArr").val('');
									$("#userIdDesignArr").val(data.userId);
									$("#designTitle").val('');
									$("#design_comment").val('');
									$("#designKeyword").val('');
			    	        		
									$("#CirculationRefLine").empty()
									
									$("#userId5").val('');
									$("#userId6").val('');
									$(".app_line_edit .req").eq(0).val('');
									
									var apprLength = $("#apprLine li").length;
									
									for(var i=1; i<apprLength;i++){
										$("#apprLine li").eq(1).remove();
									}
									
			    	        		$("#apprLineSelect").empty();
			    	        		
			    	        		$("label[for=apprLineSelect]").html("---- 결재선 불러오기 ----");
			    	        		$("#apprLineSelect").append("<option value=''>---- 결재선 불러오기 ----</option>");
			    	        		
			    	        		for(var i=0;i<apprLineList.length;i++){
			    	        			$("#apprLineSelect").append("<option value="+apprLineList[i].apprLineNo+">"+apprLineList[i].lineName+"</option>");
			    	        		}
			    	        	}else if(tbType == 'trialProductionReport'){
			    	        		
			    	        		$("#deptFulName").val('');
								   	$("#titCodeName").val('');
								    $("#userId").val('');
								    $("#userName").val(''); 
								    $("#userIdTrialArr").val('');
									$("#userIdTrialArr").val(data.userId);
									
									$("#CirculationRefLineTrial").empty();
									$("#userId7Trial").val('');
									$("#userId8Trial").val('');
									$("#trialKeyword").val('');
									$(".app_line_edit .req").eq(2).val('');
									
									var apprLength = $("#apprLineTrial li").length;
									
									for(var i=1; i<apprLength;i++){
										$("#apprLineTrial li").eq(1).remove();
									}
									
			    	        		$("#apprLineSelectTrial").empty();
			    	        		
			    	        		$("label[for=apprLineSelectTrial]").html("---- 결재선 불러오기 ----");
			    	        		$("#apprLineSelectTrial").append("<option value=''>---- 결재선 불러오기 ----</option>");
			    	        		
			    	        		for(var i=0;i<apprLineList.length;i++){
			    	        			$("#apprLineSelectTrial").append("<option value="+apprLineList[i].apprLineNo+">"+apprLineList[i].lineName+"</option>");
			    	        		}
									
			    	        	}else{
			    	        		
			    	        		$("#deptFulName").val('');
								   	$("#titCodeName").val('');
								    $("#userId").val('');
								    $("#userName").val('');  
								    $("#userIdManuArr").val('');
									$("#userIdManuArr").val(data.userId);
									$("#manuTitle").val('');
									$("#launchDateManu").val('');
									$("#CirculationRefLineManu").empty();
									$("#userId7Manu").val('');
									$("#userId8Manu").val('');
									$("#manufacKeyword").val('');
									$(".app_line_edit .req").eq(1).val('');
									
									var apprLength = $("#apprLineManu li").length;
									
									for(var i=1; i<apprLength;i++){
										$("#apprLineManu li").eq(1).remove();
									}
									
			    	        		$("#apprLineSelectManu").empty();
			    	        		
			    	        		$("label[for=apprLineSelectManu]").html("---- 결재선 불러오기 ----");
			    	        		$("#apprLineSelectManu").append("<option value=''>---- 결재선 불러오기 ----</option>");
			    	        		
			    	        		for(var i=0;i<apprLineList.length;i++){
			    	        			$("#apprLineSelectManu").append("<option value="+apprLineList[i].apprLineNo+">"+apprLineList[i].lineName+"</option>");
			    	        		}
			    	        	}
								
							}else if(data.status=='F'){
								alert(data.msg);
							}else{
								alert("오류가 발생하였습니다.");
							}
						},
						error:function(request,status,errorThrown){
							alert("오류 발생");
						}
					});
					
				}else{
					alert("삭제 실패되었습니다.");
				}
			},
			error:function(a,b,c){
				return alert('오류(http error)');
			}
			
		})
		
	}
	
	function openHistoryDialog(dNo){
		$('#lab_loading').show();
		
		$.ajax({
			url: '/dev/getHistoryList',
			type: 'post',
			dataType: 'json',
			data: {
				tbType: 'manufacturingProcessDoc',
				tbKey: dNo
			},
			success: function(data){
				var historyList = data;
				
				$('#historyDiv').empty();
				
				if(historyList.length > 0){
					historyList.forEach(function(history){
						var historyElement = '<li>'
						historyElement += '<strong>['+history.typeText+']</strong> ' + history.comment
						historyElement += ' - ' +  history.regUserName + '(' + history.regUserId + ')<br/>'
						historyElement += '<span class="date">'+history.regDate+'</span>'
						historyElement +='</li>';
						/* var historyElement = '<li>'
						historyElement += '<strong>('+history.resultFlagText+') '+history.regUserName+'</strong>님이 '
						historyElement += '제조공정서['+dNo+']를 <strong>'+history.typeText+'</strong>했습니다.<br />'
						historyElement += '<span class="date">'+history.regDate+'</span>'
						historyElement +='</li>' */
						$('#historyDiv').append(historyElement);
					})
				} else {
					var historyElement = '<li><span class="notice_none">등록된 이력이 없습니다.</span></li>';
					$('#historyDiv').append(historyElement);
				}
			},
			error: function(a,b,c){
				//console.log(a,b,c)
				alert('조회 실패[2] - 시스템 담당자에게 문의하세요');
			},
			complete: function(){
				openDialog('dialog_history');
				$('#lab_loading').hide();
			}
		})
	}
	
	
	function approvalDetail( tbKey, tbType, type ) {
		var url = "";
		var mode = "";
		url = "/approval/approvalInfoPopup?tbKey="+tbKey+"&tbType="+tbType;
		if(type != null){ url += "&type=" + type; }
		mode = "width=1100, height=300, left=100, top=50, scrollbars=yes";
		
		window.open(url, "ApprovalPopup", mode );
	}
	
	function initDialog(){
		// 문서상태변경
		$('textarea[name=closeMemo]').val('');
		
		// 제품개발문서 수정
		$('#devDocEditForm input[name=productName]').val('${fn:escapeXml(productDevDoc.productName)}');
		$('#productCode').val('${productDevDoc.productCode}');
		$('#imNo').val('${productDevDoc.imNo}');
		$('#prdCodeDiv').hide();
		$('#reqNum').val('${productDevDoc.manufacturingNo}');
		$('#manufacturingNoSeq').val('${productDevDoc.manufacturingNoSeq}');
		$('#reqDiv').hide();
		$('#launchDate').val('${fn:substring(productDevDoc.launchDate, 0, 10)}')
		var productType1 = '${productDevDoc.productType1}';
		var productType2 = '${productDevDoc.productType2}';
		var productType3 = '${productDevDoc.productType3}';
		if(productType1.length > 0){ 
			$('#dialog_productType1 option[value='+productType1+']').prop('selected', true);
			$('#dialog_productType1').change();
		}
		if(productType2.length > 0){ 
			$('#dialog_productType2 option[value='+productType2+']').prop('selected', true);
			$('#dialog_productType2').change();
		}
		if(productType3.length > 0){ 
			$('#dialog_productType3 option[value='+productType3+']').prop('selected', true);
			$('#dialog_productType3').change();
		}
		var sterilization = '${productDevDoc.sterilization}';
		var etcDisplay = '${productDevDoc.etcDisplay}';
		
		if(sterilization.length > 0){ 
			$('#sterilization option[value='+sterilization+']').prop('selected', true);
			$('#sterilization').change();
		}
		if(etcDisplay.length > 0){ 
			$('#etcDisplay option[value='+etcDisplay+']').prop('selected', true);
			$('#etcDisplay').change();
		}
		
		$('textarea[name=explanation]').val($('#explanation_hidden').val());
		
		// 버전업
		$('input[name=dialog_check_design_doc]').toArray().forEach(function(input){
		    $(input).prop('checked',false);
		})
		$('textarea[name=versionUpMemo]').val('');
		
		// 제조공정서 생성
		$('#companyCode option:first').prop('selected', true);
		$('#companyCode').change();
		$('#plant').parent().hide();
		$('input[name=dialog_calcType]:first').click();
		
		
		// 파일첨부
		attatchFileArr = [];
		$('ul[name=popFileList]').empty();
		$('#attatch_common_text').val('');
		$('#attatch_common').val('')
	}
	
	function closeDialogWithClean(dialogId){
		initDialog();
		closeDialog(dialogId);
	}
	
	function reload(){
		var form = document.createElement('form');
		form.style.display = 'none';
		$('body').append(form);
		form.action = '/dev/productDevDocDetail';
		form.method = 'post';

		appendInput(form, 'docNo', '${productDevDoc.docNo}');
		appendInput(form, 'docVersion', '${productDevDoc.docVersion}');

		$(form).submit();
	}
	
	function checkMfgDoc(e, term, state, stateText){
		var userType = '${userUtil:getUserGrade(pageContext.request)}'; // 3: BOM담당자
		var isChecked = $(e.target).is(':checked'); // checkbox 클릭 시 상태
		
		// BOM 담당자인 경우에만 아래 메시지
		/* if( isChecked && userType == 3 ){
			if( !(state == 1 || state == 4 || state == 5) ){
				return alert("본 문서는 "+stateText+" 상태 이므로 BOM반영을 할 수 없습니다.");
			} */
			/* 
			if( (term < 1) && (state == 1 || state == 4 || state == 5) ){
				return alert("SAP BOM의 헤더는 1일 1회 반영 가능하며, 오늘은 더이상 반영할 수 없습니다. BOM Item만 변경합니다.");
			}
			 */
		//}
	}
	
	// 230629 '로 인한 오류 제품명, 품보명에만 `(백틱)을 사용
	function getProductName(){
		var productName = `${strUtil:getHtmlBr(productDevDoc.productName)}`;
		return productName;
	}
	
	function getDocVersion(){
		var docVersion = '${productDevDoc.docVersion}';
		return docVersion;
	}
	
	function getParentParams(){
		var result = {};
		result.productName = `${strUtil:getHtmlBr(productDevDoc.productName)}`;
		result.docProdName = $('#selectedDocProdName').val();
		result.docNo = '${productDevDoc.docNo}';
		result.docVersion = '${productDevDoc.docVersion}';
		result.modDate = '${productDevDoc.modDate}';
		return result;
	}
	
	function isNumeric(num, opt){
		// 좌우 trim(공백제거)을 해준다.
		num = String(num).replace(/^\s+|\s+$/g, "");
		
		if(typeof opt == "undefined" || opt == "1"){
			// 모든 10진수 (부호 선택, 자릿수구분기호 선택, 소수점 선택)
			var regex = /^[+\-]?(([1-9][0-9]{0,2}(,[0-9]{3})*)|[0-9]+){1}(\.[0-9]+)?$/g;
		}else if(opt == "2"){
			// 부호 미사용, 자릿수구분기호 선택, 소수점 선택
			var regex = /^(([1-9][0-9]{0,2}(,[0-9]{3})*)|[0-9]+){1}(\.[0-9]+)?$/g;
		}else if(opt == "3"){
			// 부호 미사용, 자릿수구분기호 미사용, 소수점 선택
			var regex = /^[0-9]+(\.[0-9]+)?$/g;
		}else{
			// only 숫자만(부호 미사용, 자릿수구분기호 미사용, 소수점 미사용)
			var regex = /^[0-9]$/g;
		}
		
		if( regex.test(num) ){
		  num = num.replace(/,/g, "");
		  return isNaN(num) ? false : true;
		} else { 
			return false;  
		}
	}
	
	function qnsValid(qns, isQnsReviewTarget){
		
		// QNSH 검토 대상인 경우에만 적용
		if(isQnsReviewTarget == '1'){
			
			var regexp = /^[0-9]$/g;
			
			if(qns == ''){
				alert('QNSH 등록번호를 입력해주세요.');
				return false;
			}
			
			if(qns.length < 5){
				alert('QNSH 등록번호가 너무 짧습니다. 5자 이상 입력해주세요.' + '\n입력된 길이: ' + qns.length);
				return false;
			}
			
			if(qns.indexOf(' ') >= 0){
				alert('QNSH 등록번호에 공백값이 입력되었습니다.');
				return false;
			}
			
			if(isNumeric(qns)){
				alert('QNSH 등록번호에 숫자만 입력되었습니다.');
				return false;
			}
		}
		
		return true;
	}
	
	function updateQns(){
		var dNo = $('#dialog_qns_dNo').val();
		var qns = $('#dialog_qns_no').val();
		var isQnsReviewTarget = $('input[name=isQnsReviewTarget]:checked').val()
		qns = isQnsReviewTarget == '1' ? qns : '';
		
		if(!qnsValid(qns, isQnsReviewTarget)){
			return;
		}
		
		
		$.ajax({
		    url: '/dev/updateQns',
		    data: { 
		    	 dNo: dNo
		    	, qns: qns
		    	, isQnsReviewTarget: isQnsReviewTarget 
		    },
		    success: function(data){
		        //console.log(data);
		        if(data.status == "success"){1
		        	alert("저장되었습니다.");
		        	reload();
		        } else {
		        	alert(data.msg);
		        }
		    },
		    error: function(a,b,c){
		        alert("시스템 오류 - 담당자에게 문의하세요.");
		    }
		})
	}
	
	function callQnsDialog(dNo, qns, isQnsReviewTarget){
		var qnsFlag = isQnsReviewTarget == '1' ? 1 : 0;
		
		$('#dialog_qns_no').val(qns);
		$('#dialog_qns_dNo').val(dNo)
		$('input[name=isQnsReviewTarget][value='+qnsFlag+']').click();
		openDialog('dialog_qns')
	}
	
	function closeQnsDialog(){
		$('#dialog_qns_no').val("");
		$('#dialog_qns_dNo').val("");
		closeDialog('dialog_qns')
	}
	
	function closeSetQnshDialog(){
		$('#qnsh_category_select option:first').prop('selected', true);
		$('#qnsh_category_select').change();
		closeDialog('dialog_set_qnsh')
	}
	
	
	function setQNSDocument(){
		$('#lab_loading').show();
		
		var dNoCnt = $('input[type=checkbox][name=check_mfg_doc]:checked').length;
		var drNoCnt = $('input[type=checkbox][name=check_design_doc]:checked').length;
		var qnshCategory = $('#qnsh_category_select').val();
		 
		if(dNoCnt == 0){
			alert('선택된 제조공정서가 없습니다. 제조공정서를 선택해주세요');
			$('#lab_loading').hide();
			return;
		}
		if(dNoCnt > 1){
			alert('하나의 제조공정서만 선택해주세요.');
			$('#lab_loading').hide();
			return;
		}
		
		if(drNoCnt == 0){
			alert('선택된 디자인의뢰서가 없습니다. 디자인의뢰서를 선택해주세요');
			$('#lab_loading').hide();
			return;
		}
		if(drNoCnt > 1){
			alert('하나의 디자인의뢰서만 선택해주세요.');
			$('#lab_loading').hide();
			return;
		}
		if(qnshCategory.length <= 0){
			alert('QNSH 항목을 선택해주세요.');
			$('#lab_loading').hide();
			return;
		}
		
		var dNo = '';
		var qns = '';
		var drNo = '';
		
		
		var mfgTargetObj = $('input[type=checkbox][name=check_mfg_doc]:checked');
		dNo = mfgTargetObj.siblings('input[name=hidden_mfg_dNo]').val();
		qns = mfgTargetObj.siblings('input[name=hidden_mfg_qns]').val();
		
		var drTargetObj = $('input[type=checkbox][name=check_design_doc]:checked');
		drNo = drTargetObj.parent().next().text();
		
		if(dNo == ''){
			alert('제조공정서를 찾을 수 없습니다.');
			$('#lab_loading').hide();
			return;
		}
		/* if(qns == ''){
			alert('QNSH를 찾을 수 없습니다.');
			$('#lab_loading').hide();
			return;
		} */
		if(drNo == ''){
			alert('디자인의뢰서를 찾을 수 없습니다.');
			$('#lab_loading').hide();
			return;
		}
		
		$.ajax({
			url: '/qns/setQNSDocument',
			type: 'post',
			data: {
				tbType: 'manufacturingProcessDoc',
				tbKey: dNo,
				docNo: '${productDevDoc.docNo}',
				docVersion: '${productDevDoc.docVersion}',
				dNo: dNo,
				drNo: drNo,
				qns: qns,
				qnshCategory: qnshCategory
			},
			success: function(data){
				//console.log(data);
				if(data.status == 'S'){
					alert('저장되었습니다.');
					closeSetQnshDialog('dialog_set_qnsh');
				} else {
					alert('저장 오류');
				}
			},
			error: function(a,b,c){console.log(a,b,c)},
			complete: function(){
				$('#lab_loading').hide();
			}
			
		})
	}
	
	function openPopupQNSH(_qns){
		var url = 'https://qns.spc.co.kr/api/paboard/rndsViewDoc.spc?PS_NO='+_qns;
				
		var popupName = 'qnshPopup';
		var w=1100;
		var h=650;
		var winl = (screen.width-w)/2;
		var wint = (screen.height-h)/2;
		var option ='height='+h+',';
		option +='width='+w+',';
		option +='scrollbars=yes,';
		option +='resizable=no';
		
		//window.open(url, popupName, option);
		window.open(url, 'qnshpopup', option);
	}
	
	// 시생산 보고서 결재상신 팝업
	function openTrialProdReportApproval(){
		var checkboxes = document.getElementsByName('check_tiral_report');
		var selected = 0;
		var dNo = 0;
		var state = 0;
		
		// 선택된 보고서 체크
		if( checkboxes != null ){
			for(var index = 0; index < checkboxes.length; index = index + 1){
				if( checkboxes[index].checked ){
					rNo = checkboxes[index].value;
					selected = selected + 1;
					state = document.getElementById( 'trialProdReportState_' + index ).value;
				}
			}
		}
		if( selected === 0 ){
			alert('선택된 시생산 보고서가 없습니다.');
			return;
		}else if( selected > 1 ){
			alert('2개 이상 상신할 수 없습니다.');
			return;
		}else if( state != '0'){
			alert('등록 상태에서만 상신할 수 있습니다.');
			return;
		}
		
		// 테이블 키 세팅
		document.getElementById('tbKeyTrial').value = rNo;
		
		// 기안자 세팅 + 결재 라인 리스트 세팅
		$.ajax({
			async : false,
			type : 'post',
			url : '/dev/approvalRequestPopup',
			data : { tbType : 'trialProductionReport' }, 
			success: function(data){
				var grade = data.grade;
				var status = data.status;
				var regUserData = data.regUserData;
				var approvalLineList = data.approvalLineList;
				
				var index = 0;
				var html = new Array();
				var defaultSelectedOptionHTML = '----결재선 불러오기----';
				
				if( status !== 'S' ){
					alert('오류가 발생했습니다.\r\n다시 시도하거나 관리자에게 문의해 주세요.');
					return;
				}
				if( grade == '6' ){
					alert('권한이 없습니다.');
					return false;
				}
				
				jQuery('#deptFulName').val('');
			   	jQuery('#titCodeName').val('');
			    jQuery('#userId').val('');
			    jQuery('#userName').val('');  
				jQuery('#userIdTrialArr').val('');
				jQuery('#userIdTrialArr').val(data.userId);
				
				jQuery('#CirculationRefLineTrial').empty();
				jQuery('#userId7Manu').val('');
				jQuery('#userId8Manu').val('');
				jQuery('#apprLineTrial').empty();
				jQuery('#apprLineSelectTrial').empty();
				jQuery('#trialKeyword').val('');
				jQuery('.app_line_edit .req').eq(2).val('');
				
				// 기안자 세팅
				for(index = 0; index < regUserData.length; index++){
					html = new Array();
					html.push('<li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
					html.push('		<span class="s01">기안자</span> ' + regUserData[index].userName);
					html.push('		<strong>' + '/' + regUserData[index].userId + '/' + regUserData[index].deptCodeName + '/' + regUserData[index].teamCodeName + '</strong>');
					html.push('		<input type="hidden" value="' + regUserData[index].userId + '">');
					html.push('	</li>');
					jQuery('#apprLineTrial').append( html.join('') );
				}
				
				// 결재라인 SelectBox 세팅
				jQuery('label[for=apprLineSelectTrial]').html(defaultSelectedOptionHTML);
				jQuery('#apprLineSelectTrial').append('<option value="">' + defaultSelectedOptionHTML + '</option>');
				
				for(index = 0; index < approvalLineList.length; index++){
					jQuery('#apprLineSelectTrial').append('<option value=' + approvalLineList[index].apprLineNo+'>' + approvalLineList[index].lineName + '</option>');
				}
			},
			error : function(a,b,c){
				alert('오류(http error)');
				return false;
			}
		});
		
		// 자동 완성 설정
		jQuery('#trialKeyword').autocomplete({
			minLength: 1,
		    delay: 300,
			source: function( request, response ) {
				jQuery.ajax({
					async : false,
					type : 'POST',
					dataType: 'json',
					url: '/approval/searchUser',
					data: { 'keyword' : jQuery('#trialKeyword').val(), 'userGrade' : '' },
					success: function( data ) {
						response(jQuery.map(data.data, function(item){
							return {
								label : item.userName + ' / '+item.userId + ' / ' + nvl(item.deptCodeName, '') + ' / ' + nvl(item.teamCodeName, ''),
								value : item.userName + ' / '+item.userId + ' / ' + nvl(item.deptCodeName, '') + ' / ' + nvl(item.teamCodeName, ''),
								userId : item.userId,
								deptFulName : item.deptCodeName,
								titCodeName : item.teamCodeName,
								userName : item.userName
							};
						}));
					}
				});
			},
			select : function(event, ui){
				
				jQuery('#deptFulName').val('');
				jQuery('#deptFulName').val(ui.item.deptFulName);
				
				jQuery('#titCodeName').val('');
				jQuery('#titCodeName').val(ui.item.titCodeName);
				
				jQuery('#userId').val('');
				jQuery('#userId').val(ui.item.userId);
				
				jQuery('#userName').val('');
				jQuery('#userName').val(ui.item.userName);
				
			},
			focus : function( event, ui ) {
				return false;
			}
		});
		
		openDialog('approval_trialprodreport');
		return;
	}
	
	// 시생산 보고서 수정 이동
	function modifyTrialProdReport(rNo, docNo, docVersion, state, loginUser, createUser){
		if(loginUser !== createUser){
			alert('작성자만 수정할 수 있습니다.');
			return;
		}
		if(state != '0'){
			alert('결재 중이거나 결재 완료된 문서는 수정할 수 없습니다.');
			return;
		}
		location.href = '/dev/trialProductionReportModify?docNo=' + docNo + '&docVersion=' + docVersion + '&rNo=' + rNo;
		return;
	}
	
	// 시생산 보고서 삭제 처리
	function deleteTrialProdReport(rNo, state){
		
		if(state != '0'){
			alert('결재 중이거나 결재 완료된 문서는 수정할 수 없습니다.');
			return;
		}
		
		if(confirm('정말 삭제하시겠습니까?\r\n삭제되면 복구할 수 없습니다.')){
			if(confirm('이 보고서를 삭제합니다.')){
				jQuery.ajax({
					async : false,
					type : 'GET',
					dataType : 'json',
					url : '/dev/deleteTrialProductionReport',
					data : { rNo : rNo },
					success : function( response ){
						if( response ){
							alert('삭제 완료되었습니다.');
							reload();
							return;
						}else{
							alert('삭제에 실패했습니다.\r\n다시 시도하거나 관리자에게 문의해 주세요.');
							return;
						}
					},
					error : function(){
						alert('삭제에 실패했습니다.\r\n다시 시도하거나 관리자에게 문의해 주세요.');
						return;
					}
				});
			}
		}
	}
	
	// 시생산보고서 상세보기
	function goTrialDetail(rNo, docNo, docVersion){
		var form = document.createElement('form');
		form.style.display = 'none';
		$('body').append(form);
		form.action = '/dev/trialProductionReportDetail';
		form.target = '_blank';
		
		appendInput(form, 'rNo', rNo);
		appendInput(form, 'docNo', docNo);
		appendInput(form, 'docVersion', docVersion);
		
		$(form).submit();
	}
	
	function openInsertMNoForm(dNo) {
	      
	      var width = window.innerWidth - 200;
	      var height = window.innerHeight - 190;
	      if( width > 1000 ) {
	         width = 1000;
	      }
	      if(height > 900) {
	         height = 800;
	      }
	      var positionX = (window.innerWidth - width)/2;
	      var positionY = (window.innerHeight - height)/2;
	      $('#element_to_pop_up').bPopup({
	          content:'iframe',
	            contentContainer:'.popup_content',
	            //iframeAttr:'width:100%;height:900px;scrolling="yes"',
	            iframeAttr:'scrolling=yes',
	            position:[positionX,positionY],
	          loadUrl:'../manufacturingNo/insertPopup?dNo='+dNo       
	      });
	      
	      $(".popup_style").css("width", width);
	      $(".popup_style").css("height", height);
	      $(".b-iframe2").css("width", width);
	      $(".b-iframe2").css("height", height);
	   }
	   
	   function bPopup_close() {
	      loadManufacturingNo();
	      $('#element_to_pop_up').bPopup().close();
	      $('.popup_content').html("");      
	   }
	   
	   function bPopup_close2() {
	      $('#element_to_pop_up').bPopup().close();
	      $('.popup_content').html("");      
	   }
	   
	   function loadManufacturingNo() {      
	      var docNo = '${productDevDoc.docNo}';
	      var docVersion = '${productDevDoc.docVersion}';
	      jQuery.ajax({
	         async : false,
	         type : 'POST',
	         dataType : 'json',
	         url : '/manufacturingNo/selectManufacturingNoListAjax',
	         data : { 
	            docNo : '${productDevDoc.docNo}',
	            docVersion : '${productDevDoc.docVersion}'
	         },
	         success : function( response ){
				var html = "";
	            $("#manufacturingNoList").html(html);
	            response.list.forEach(function (item, index) {
	            	if( item.manufacturingMaxVersionNo >= 1 && (item.rowNumber == 1) && (item.manufacturingMaxVersionNo == item.versionNo)){
						html += "<tr id='manufacturing_"+item.manufacturingNo+"_"+item.dNo+"_"+item.seq+"' style='height: 40px;'>";        	   
					}else if( item.manufacturingMaxVersionNo >= 1 && (item.rowNumber == 1) && (item.manufacturingMaxVersionNo != item.versionNo)){
						html += "<tr id='manufacturing_"+item.manufacturingNo+"_"+item.dNo+"_"+item.seq+"' style='height: 40px; background-color: #e0e0e0;'>";        	  
					}else{
						html += "<tr id='old_manufacturing_"+item.manufacturingNo+"_"+item.dNo+"_"+item.seq+"' style='height: 40px; background-color: #e0e0e0; display: none;'>";
					}
	            	
					//if( (item.status).trim() == "C" ) {
					//   html += "<td><input type=\"checkbox\" name=\"mNo\" id=\"mNo_"+index+"\" value=\""+item.seq+"\" onclick=\"\"><label style=\"padding:0;\" for=\"mNo_"+index+"\"><span style=\"margin:0;\"></span></label></td>";   
					//} else {
					//   html += "<td>&nbsp;</td>";
					//}
					//console.log(item);
		            <!-- 중단요청 체크박스 start -->
					// if( (item.status).trim() == "C" && (item.manufacturingMaxVersionNo == item.versionNo)){
					// 	console.log(item);
					// 	var mnData = "data-licensingNo=\"" + item.licensingNo + "\" data-seq=\"" + item.seq + "\" ";
					// 	mnData += "data-manufacturingNo=\"" + item.manufacturingNo + "\" data-dNo=\"" + item.dNo + "\" ";
					// 	mnData += "data-status=\"" + item.status + "\" data-companyCode=\"" + item.companyCode + "\" ";
					// 	html += "<td><input type=\"checkbox\" name=\"check_manufacturingNo\" id=\"mNo_"+index+"\" " + mnData + " /><label style=\"padding:0;\" for=\"mNo_"+index+"\"><span style=\"margin:0;\"></span></label></td>";
					// }else{
					// 	html += "<td></td>";
					// }
		            <!-- 중단요청 체크박스 end -->
					if( item.manufacturingMaxVersionNo > 1 && ((item.manufacturingMaxVersionNo == item.versionNo) || item.rowNumber == 1)){
						html += "<td style='padding: 0;'> <img src='/resources/images/img_add_doc.png' style='cursor: pointer;' onclick='showChildVersion(this)'/> </td>";
						html += "<td>"+item.versionNo+"</td>"
					}else if(item.manufacturingMaxVersionNo  > 1){
						html += "<td style='padding: 0;'> <img src='/resources/images/bg_ver.png' style='margin-left: 10px;'/> </td>"
						html += "<td>"+item.versionNo+"</td>"
					}else{
						html += "<td> &nbsp; </td>"
						html += "<td>"+item.versionNo+"</td>"
					}
					html += "<td>";
					html += ""+item.licensingNo+"-"+item.manufacturingNo+"";
					html += "<input type=\"hidden\" name=\"mno_seq\" id=\"mno_seq\" value=\""+item.seq+"\">";
					html += "<input type=\"hidden\" name=\"mno_status\" id=\"mno_status\" value=\""+item.status+"\">";
					html += "</td>";
					html += "<td>"+item.dNo+"</td>";
					html += "<td>"+item.plantName+"</td>";
					html += "<td>"+item.statusName+"</td>";
					html += "<td>"+item.regDate+"</td>";
					html += "<td>"+item.userName+"</td>";
					html += "<td>"+nvl(item.reportEDate,"")+"</td>";
					if( item.manufacturingReport != null && item.manufacturingReport != "" ) {
						html += "<td style='max-width: 0;overflow: hidden;text-overflow: ellipsis; white-space: nowrap;' title="+item.manufacturingReportFileName+">";
						html += "<a href=\"javascript:mNoFileDownload('"+item.manufacturingReport+"','"+item.seq+"','manufacturingReport')\">"+item.manufacturingReportFileName+"</a></td>";                  
					} else {
						html += "<td>&nbsp;</td>";
					}               
					html += "<td>";
					html += "   <ul class=\"list_ul\">";
					html += "      <li>";
					html += "          <button class=\"btn_doc\" onclick=\"openViewMNo('"+item.seq+"');\"><img src=\"/resources/images/icon_doc01.png\">보기</button>";
					html += "      </li>";
					html += "      <li>";
					html += "          <button class=\"btn_doc\" onclick=\"openChangeMNo('"+item.licensingNo+"', '"+item.manufacturingNo+"', '"+item.versionNo+"', '"+item.seq+"', '"+item.dNo+"');\"><img src=\"/resources/images/icon_doc03.png\">변경요청</button>";
					html += "      </li>";
					// if( (item.status).trim() == "C" && (item.manufacturingMaxVersionNo == item.versionNo)) {
					// 	html += "      <li>";
					// 	html += "          <button class=\"btn_doc\" onclick=\"openStopMNoAppr(this);\"><img src=\"/resources/images/icon_doc06.png\">중단요청</button>";
					// 	html += "      </li>";
					// }
					var isAdmin = '${userUtil:getIsAdmin(pageContext.request)}';
					if( (item.status).trim() == "N" ){
						if( '${userId}' == '${productDevDoc.regUserId}' || isAdmin == "Y"){
							html += "      <li>";
							html += "          <button class=\"btn_doc\" onclick=\"updateStatus("+item.seq + ", " + item.licensingNo + ", " + item.manufacturingNo + ", \`" + item.manufacturingName + "\`)\"><img src=\"/resources/images/img_next_tab.png\">신고요청</button>";
							<%-- html += "          <button class=\"btn_doc\" onclick=\"updateStatus("+item.seq + ", " + item.licensingNo + ", " + item.manufacturingNo + ", \'" + item.manufacturingName + "\')\"><img src=\"/resources/images/img_next_tab.png\">신고요청</button>"; --%>
							html += "      </li>";
						}
					}
					html += "   </ul>";
					html += "</td>";
					html += "</tr>";
				});
				$("#manufacturingNoList").html(html);
			},error : function(){
				alert('오류가 발생하였습니다.');
				var html = "";
				$("manufacturingNoList").html(html);
				return;
				}
			});
		}
	   
	   function openViewMNo(no) {
	      var width = window.innerWidth - 200;
	      var height = window.innerHeight - 190;
	      if( width > 1000 ) {
	         width = 1000;
	      }
	      if(height > 900) {
	         height = 800;
	      }
	      var positionX = (window.innerWidth - width)/2;
	      var positionY = (window.innerHeight - height)/2;
	      $('#element_to_pop_up').bPopup({
	          content:'iframe',
	            contentContainer:'.popup_content',
	            //iframeAttr:'width:100%;height:900px;scrolling="yes"',
	            iframeAttr:'scrolling=yes',
	            position:[positionX,positionY],
	          loadUrl:'../manufacturingNo/viewPopup?seq='+no       
	      });
	      
	      $(".popup_style").css("width", width);
	      $(".popup_style").css("height", height);
	      $(".b-iframe2").css("width", width);
	      $(".b-iframe2").css("height", height);
	   }
	   
	function openChangeMNo(licsngNo, mnfctringNo, versionNo, seq, docNo) {
		var form = document.createElement("form"); // 폼객체 생성
		$('body').append(form);
		form.action = "/manufacturingNo/dbView";
		form.style.display = "none";
		form.method = "post";
		
		appendInput(form, "seq", seq);
		appendInput(form, "versionNo", versionNo);
		appendInput(form, "licensingNo", licsngNo);
		appendInput(form, "manufacturingNo", mnfctringNo);
		
		$(form).submit();
	}

    function openStopMNoAppr(obj){
        var seq = $(obj).parent().parent().parent().parent().children().children('input[id=mno_seq]').val();
        console.log("target: " + seq)
        $.each($("input[type=checkbox][name=check_manufacturingNo]"),function(index,item){
			item.checked = false;
            if($(item).data("seq") == seq){
				item.checked = true;
            }
        });
        openApprovalDialog("approval_manufacturingNo");
		$.each($("input[type=checkbox][name=check_manufacturingNo]"),function(index,item){
			item.checked = false;
		});
    }
	   //중단요청 처리
	   function openStopMNo(obj) {
	      if( confirm('중단요청을 하시겠습니까?') ) {
	         alert('전자결재에서 중단 협조전 상신하여 주시기 바랍니다.');
	         var seq = $(obj).parent().parent().parent().parent().children().children('input[id=mno_seq]').val();
	         var status = $(obj).parent().parent().parent().parent().children().children('input[name=mno_status]').val();
	         jQuery.ajax({
	            async : false,
	            type : 'POST',
	            dataType : 'json',
	            url : '/manufacturingNo/updateManufacturingNoStatusAjax',
	            data : { 
	               'no_seq' : seq,
	               'prevStatus' : status,
	               'status' : 'RS',
	               'isStopReq' : 'Y'
	            },
	            success : function(data){
	               if( data.RESULT == 'Y' ) {
	                  alert("중단요청 되었습니다.");
	                  loadManufacturingNo();
	                  return;   
	               } else {
	                  alert("중단요청 실패했습니다. \n 다시 시도해주세요.");
	                  return;
	               }               
	            },
	            error : function(){
	               alert("오류가 발생하였습니다. \n 확인 후 다시 처리해주세요.");
	            }
	         });
	      }
	   }
	   
	   function loadManufacturingNoFile() {      
	      var docNo = '${productDevDoc.docNo}';
	      var docVersion = '${productDevDoc.docVersion}';
	      jQuery.ajax({
	         async : false,
	         type : 'POST',
	         dataType : 'json',
	         url : '/manufacturingNo/selectManufacturingNoFileAjax',
	         data : { 
	            docNo : '${productDevDoc.docNo}',
	            docVersion : '${productDevDoc.docVersion}'
	         },
	         success : function( response ){
	            var html = "";
	            $("#manufacturingNoFileList").html(html);
	            response.manufacturingNoFile.forEach(function (item, index) {               
	               if( index > 0 ) {
	                  //html+= "<br>";
	               }               
	               html+= "<li><a href=\"javascript:mNoFileDownload('"+item.fmNo+"','"+item.tbKey+"','"+item.tbType+"')\">"+item.orgFileName+"</a> ( "+item.userName+"/"+item.regDate+" )</li>";
	            });
	            $("#manufacturingNoFileList").html(html);
	         },
	         error : function(){
	            var html = "";
	            $("manufacturingNoFileList").html(html);
	            return;
	         }
	      });
	   }
	   
	   //파일 다운로드
	   function mNoFileDownload(fmNo, tbkey, tbType){
	      location.href="/file/fileDownload?fmNo="+fmNo+"&tbkey="+tbkey+"&tbType="+tbType;
	   }
	    
	   function openManuNo() {
		      var dNoCnt = $('input[type=checkbox][name=check_mfg_doc]:checked').length;      
		      if(dNoCnt == 0){
		         alert('선택된 제조공정서가 없습니다. 제조공정서를 선택해주세요');
		         $('#lab_loading').hide();
		         return;
		      }
		      if(dNoCnt > 1){
		         alert('하나의 제조공정서만 선택해주세요.');
		         $('#lab_loading').hide();
		         return;
		      }

		      var mfgTargetObj = $('input[type=checkbox][name=check_mfg_doc]:checked');
			  //제조공정서가 사용중지시 품목제조보고서를 생성할수 없다. mfgProcDoc.state
			  for(var i = 0 ; i < mfgTargetObj.length ; i++){
				  if($(mfgTargetObj[i]).data("state") == "6"){
					  alert("사용중지 된 제조공정서는 품목제조보고서를 생성할수 없습니다.");
					  return;
				  }
			  }
		      //신규 등록인지 기존에 품보가 있는지 체크
		      dNo = mfgTargetObj.siblings('input[name=hidden_mfg_dNo]').val();
		      jQuery.ajax({
		         async : false,
		         type : 'POST',
		         dataType : 'json',
		         url : '/manufacturingNo/selectManufacturingNoMappingCountAjax',
		         data : { dNo : dNo },
		         success : function( response ){
		            if( response.COUNT == 0 ) {
		               openInsertMNoForm(dNo);
		            } else {
		               alert("이미 품목제조 보고서가 등록된 제조공정서입니다.");
		               return;
		            }
		         },
		         error : function(){
		            alert('오류가 발생하였습니다.');
		            return;
		         }
		      });
		   }
	   
	   function updateStatus(seq, licensingNo, manufacturingNo, manufacturingName){
		   if(confirm(manufacturingName + '의 품목제조보고서(품보번호:' + licensingNo + '-' + manufacturingNo+')를 신고요청하시겠습니까?\n신고요청 후 상태가 진행중으로 변경되며 수정이 불가능합니다.\n계속하시겠습니까?')){
			   $.ajax({
					url 		 : '../manufacturingNo/updateManufacturingNoStatusAjax',
					type 		 : 'POST',
					data 		 : {
						"no_seq" : seq,
						"status" : "P"
					},
					dataType 	 : "json",
					success		 : function(){
						alert("품목제조 보고서(품보번호 : " + licensingNo + '-' + manufacturingNo + ")의 상태가 변경되었습니다.");
						location.reload();
					},
					error		 : function(){
						alert("품목제조 보고서(품보번호 : " + licensingNo + '-' + manufacturingNo + ")의 상태 변경 중 오류가 발생하였습니다.");
					}
			   });
		   };
	   };
	   
	   function showChildVersion(imgElement){
			var mNo = $(imgElement).parent().parent().attr('id').split('_')[1];
			var docNo = $(imgElement).parent().parent().attr('id').split('_')[2];
			var seq = $(imgElement).parent().parent().attr('id').split('_')[3];
			var elementImg = $(imgElement).attr('src').split('/')[$(imgElement).attr('src').split('/').length-1];
			
			var addImg = 'img_add_doc.png';
			
			if(elementImg == addImg){
				$(imgElement).attr('src', $(imgElement).attr('src').replace('_add_', '_m_')); 
				$('tr[id*=old_manufacturing_'+mNo+'_'+docNo+']').show();
				//$('tr[id*=devDoc_old]').show();
			}else {
				$(imgElement).attr('src', $(imgElement).attr('src').replace('_m_', '_add_'));
				$('tr[id*=old_manufacturing_'+mNo+'_'+docNo+']').toArray().forEach(function(v, i){
					$(v).hide();
				})
			}
		};

	   function openTrailReportDetail(rNo){
		   var form = document.createElement('form');
		   form.style.display = 'none';
		   $('body').append(form);
		   form.action = "/trialReport/trialReportDetail";
		   form.target = '_self';
		   form.method = 'post';

		   appendInput(form, 'cNo', 0);
		   appendInput(form, 'rNo', rNo);
		   appendInput(form, 'mode','read');

		   appendInput(form, 'docNo', "${productDevDoc.docNo}");
		   appendInput(form, 'docVersion', "${productDevDoc.docVersion}");
		   appendInput(form, 'from',"productDevDocDetail");

		   $(form).submit();
		   $(form).remove();
	   }
</script>