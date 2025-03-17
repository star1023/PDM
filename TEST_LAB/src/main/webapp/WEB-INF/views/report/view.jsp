<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ taglib prefix="userUtil" uri="/WEB-INF/tld/userUtil.tld"%>
<%@ page import="java.util.*"%>
<%@ page session="false"%>
<%
	List<Map<String, Object>> bomList = (List<Map<String, Object>>) request.getAttribute("bomList");
	int viewCount = 15;
	/* if( bomList != null && bomList.size() > 0 ) {
		for( int i = bomList.size() ; i < viewCount*3 ; i++ ) {
			Map<String,Object>	blankData = new HashMap<String,Object>();
			blankData.put("Level","");
			blankData.put("name","");
			blankData.put("bom","");
			bomList.add(i,blankData);
		}
	} */
%>
<title>레포트</title>
<style>
	.group01 .title5 {
		width: 100%;
	}

</style>
<script type="text/javascript">
	var PARAM = {
		category1 : '${paramVO.category1}',
		keyword : '${paramVO.keyword}',
		pageNo : '${paramVO.pageNo}'
	};

	$(document).ready(function() {
		
	});

	function goList() {
		location.href = "/report/list?" + getParam('${paramVO.pageNo}');
	}

	//파라미터 조회
	function getParam(pageNo) {
		PARAM.pageNo = pageNo || '${paramVO.pageNo}';
		return $.param(PARAM);
	}

	//파일 다운로드
	function fileDownload(fmNo, tbkey) {
		location.href = "/file/fileDownload?fmNo=" + fmNo + "&tbkey=" + tbkey + "&tbType=report";
	}

	function goUpdate() {
		location.href = "/report/updateForm?rNo=${reportlData.reportKey}&" + getParam('${paramVO.pageNo}');
	}

	function goDelete() {
		if (confirm("삭제하시겠습니까?")) {
			location.href = "/report/delete?rNo=" + ${reportlData.reportKey};
		}
	}

	function goPreview(rNo) {
		var url = "/report/viewPopup?rNo=" + rNo;
		var mode = "width=1100, height=600, left=100, top=10, scrollbars=yes";
		window.open(url, "ApprovalPopup", mode);
	}
</script>
<div class="wrap_in" id="fixNextTag">
	<span class="path">보고서&nbsp;&nbsp;<img src="/resources/images/icon_path.png" style="vertical-align: middle" />&nbsp;&nbsp;<a href="#">${strUtil:getSystemName()}</a></span>
	<section class="type01">
		<!-- 상세 페이지  start-->
		<h2 style="position: relative">
			<span class="title_s">Report</span>
			<span class="title">
				<c:choose>
					<c:when test="${reportlData.isOld != null && reportlData.isOld == 'Y'}">
						${reportlData.oldCategoryName}
					</c:when>
					<c:otherwise>
						${reportlData.category1Name}
					</c:otherwise>
				</c:choose>
			</span>
			<div class="top_btn_box">
				<ul>
					<li>
						<button type="button" class="btn_circle_nomal" onClick="goList()">&nbsp;</button>
						<c:if test="${reportlData.isOld != 'Y' && reportlData.category1 == 'PRD_REPORT_5' }">
							<button type="button" class="btn_circle_dark" onClick="goPreview('${reportlData.reportKey}')">&nbsp;</button>
						</c:if>
					</li>
				</ul>
			</div>
		</h2>
		<div class="group01 mt20">
			<c:choose>
				<c:when test="${reportlData.isOld != null && reportlData.isOld == 'Y'}">
					<c:choose>
						<c:when test="${reportlData.oldCategory == '1' || reportlData.oldCategory == '2' || reportlData.oldCategory == '3' || reportlData.oldCategory == '6' }">
							<div class="title5">
								<span class="txt">01. 기본정보</span>
								<!--span class="txt">01. 보고서명 : 영등포 점포 시장조사내역</span-->
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
											<th style="border-left: none;">보고서명</th>
											<td colspan="3">${reportlData.title}</td>
										</tr>
										<tr>
											<th style="border-left: none;">메모</th>
											<td colspan="3">${strUtil:getHtml(reportlData.content) }</td>
										</tr>
									</tbody>
								</table>
							</div>
							<div class="title5" style="float: left; margin-top: 30px;">
								<span class="txt">02. 첨부파일</span>
							</div>
							<div class="con_file fl" style="padding-bottom: 40px;">
								<c:if test="${fn:length(fileList)> 0}">
									<ul>
										<li>
											<dt>1. 파일리스트</dt>
											<dd>
												<ul>
													<c:forEach items="${fileList}" var="fileList">
														<li><a href="/file/fileDownload?fmNo=${fileList.fmNo}&tbkey=${fileList.tbKey}&tbType=report">
															<c:choose>
																<c:when test="${fileList.isOld == 'Y'}">
																	${strUtil:getOldFileName(fileList.fileName) }
																</c:when>
																<c:otherwise>
																	${fileList.orgFileName}
																</c:otherwise>
															</c:choose>
														</a></li>
													</c:forEach>
												</ul>
											</dd>
										</li>
									</ul>
								</c:if>
							</div>
						</c:when>
						<c:otherwise>
							<div class="title5 ">
								<span class="txt">01. 제품명 : ${reportlData.prdTitle}</span>
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
											<th style="border-left: none;">작성자명</th>
											<td>${reportlData.userName}</td>
											<th>작성일자</th>
											<td>${reportlData.regDate}</td>
										</tr>
										<tr>
											<th style="border-left: none;">보고날짜</th>
											<td colspan="3">${reportlData.reportDate}</td>
										</tr>
										<tr>
											<th style="border-left: none;">제품특징</th>
											<td colspan="3">${strUtil:getHtml(reportlData.prdFeature)}</td>
										</tr>
									</tbody>
								</table>
							</div>
							<div class="title5" style="float: left; margin-top: 30px;">
								<span class="txt">02. 제조방법</span>
							</div>
							<div class="main_tbl">
								<table class="insert_proc01">
									<tbody>
										<tr>
											<td style="border-left: none;">${reportlData.adviserPrd }</td>
										</tr>
									</tbody>
								</table>
							</div>
							<div class="title5" style="float: left; margin-top: 30px;">
								<span class="txt">03. 첨부파일</span>
							</div>
							<div class="con_file fl" style="padding-bottom: 40px;">
								<c:if test="${fn:length(fileList)> 0}">
									<ul>
										<li>
											<dt>1. 파일리스트</dt>
											<dd>
												<ul>
													<c:forEach items="${fileList}" var="fileList">
														<li><a href="/file/fileDownload?fmNo=${fileList.fmNo}&tbkey=${fileList.tbKey}&tbType=report">
															<c:choose>
																<c:when test="${fileList.isOld == 'Y'}">
																	${strUtil:getOldFileName(fileList.fileName) }
																</c:when>
																<c:otherwise>
																	${fileList.orgFileName}
																</c:otherwise>
															</c:choose>
														</a></li>
													</c:forEach>
												</ul>
											</dd>
										</li>
									</ul>
								</c:if>
							</div>
						</c:otherwise>
					</c:choose>
				</c:when>
				<c:otherwise>
					<c:choose>
						<c:when test="${reportlData.category1 == 'PRD_REPORT_2' || reportlData.category1 == 'PRD_REPORT_3' }">
							<div class="title5">
								<span class="txt">01. 기본정보</span>
								<!--span class="txt">01. 보고서명 : 영등포 점포 시장조사내역</span-->
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
										<!--tr>
											<th style="border-left: none;">보고서명</th>
											<td colspan="3">${reportlData.title}</td>
										</tr-->
										<tr>
											<th style="border-left: none;">보고서명</th>
											<td>${reportlData.title}</td>
											<th>구분</th>
											<td>${reportlData.subCategoryName}</td>
										</tr>
										<c:choose>
											<c:when test="${reportlData.isOld != null && reportlData.isOld == 'Y'}">
												<tr>
													<th style="border-left: none;">메모</th>
													<td colspan="3">${strUtil:getHtml(reportlData.content) }</td>
												</tr>
											</c:when>
											<c:otherwise>
												<tr>
													<th style="border-left: none;">작성자명</th>
													<td>${reportlData.userName}</td>
													<th>작성일자</th>
													<td>${reportlData.regDate}</td>
												</tr>
												<tr>
													<th style="border-left: none;">방문목적</th>
													<td colspan="3">${strUtil:getHtml(reportlData.visitPurpose) }</td>
												</tr>
												<tr>
													<th style="border-left: none;">방문장소</th>
													<td colspan="3">${strUtil:getHtml(reportlData.visitPlace) }</td>
												</tr>
												<tr>
													<th style="border-left: none;">참석자</th>
													<td colspan="3">${reportlData.visitUser}</td>
												</tr>
												<tr>
													<th style="border-left: none;">방문시간</th>
													<td colspan="3">${reportlData.visitTime}</td>
												</tr>
											</c:otherwise>
										</c:choose>
									</tbody>
								</table>
							</div>
							<div class="title5" style="float: left; margin-top: 30px;">
								<span class="txt">02. 첨부파일</span>
							</div>
							<div class="con_file fl" style="padding-bottom: 40px;">
								<c:if test="${fn:length(fileList)> 0}">
									<ul>
										<li>
											<dt>1. 파일리스트</dt>
											<dd>
												<ul>
													<c:forEach items="${fileList}" var="fileList">
														<li><a href="/file/fileDownload?fmNo=${fileList.fmNo}&tbkey=${fileList.tbKey}&tbType=report">
															<c:choose>
																<c:when test="${fileList.isOld == 'Y'}">
																	${strUtil:getOldFileName(fileList.fileName) }
																</c:when>
																<c:otherwise>
																	${fileList.orgFileName}
																</c:otherwise>
															</c:choose>
														</a></li>
													</c:forEach>
												</ul>
											</dd>
										</li>
									</ul>
								</c:if>
							</div>
						</c:when>
						<c:when test="${reportlData.category1 == 'PRD_REPORT_4'}">
							<div class="title5 ">
								<span class="txt">01. 제품명 : ${reportlData.prdTitle}</span>
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
											<th style="border-left: none;">작성자명</th>
											<td>${reportlData.userName}</td>
											<th>구분</th>
											<td>${reportlData.subCategoryName}</td>
										</tr>
										<tr>
											<th style="border-left: none;">보고날짜</th>
											<td>${reportlData.reportDate}</td>
											<th>작성일자</th>
											<td>${reportlData.regDate}</td>
										</tr>
										<tr>
											<th style="border-left: none;">제품특징</th>
											<td colspan="3">${strUtil:getHtml(reportlData.prdFeature)}</td>
										</tr>
									</tbody>
								</table>
							</div>
							<div class="title5" style="float: left; margin-top: 30px;">
								<span class="txt">02. 제조방법</span>
							</div>
							<div class="main_tbl">
								<table class="insert_proc01">
									<tbody>
										<tr>
											<td style="border-left: none;">${reportlData.adviserPrd }</td>
										</tr>
									</tbody>
								</table>
							</div>
							<div class="title5" style="float: left; margin-top: 30px;">
								<span class="txt">03. 첨부파일</span>
							</div>
							<div class="con_file fl" style="padding-bottom: 40px;">
								<c:if test="${fn:length(fileList)> 0}">
									<ul>
										<li>
											<dt>1. 파일리스트</dt>
											<dd>
												<ul>
													<c:forEach items="${fileList}" var="fileList">
														<li><a href="/file/fileDownload?fmNo=${fileList.fmNo}&tbkey=${fileList.tbKey}&tbType=report">
															<c:choose>
																<c:when test="${fileList.isOld == 'Y'}">
																	${strUtil:getOldFileName(fileList.fileName) }
																</c:when>
																<c:otherwise>
																	${fileList.orgFileName}
																</c:otherwise>
															</c:choose>
														</a></li>
													</c:forEach>
												</ul>
											</dd>
										</li>
									</ul>
									</c:if>
							</div>
						</c:when>
						<c:when test="${reportlData.category1 == 'PRD_REPORT_8'}">
							<div class="title5 ">
								<span class="txt">01. 실험제목 : ${reportlData.title}</span>
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
											<th style="border-left: none;">작성자명</th>
											<td>${reportlData.userName}</td>
											<th>구분</th>
											<td>${reportlData.subCategoryName}</td>
										</tr>
										<tr>
											<th style="border-left: none;">실험목적</th>
											<td>${strUtil:getHtml(reportlData.testPurpose)}</td>
											<th>작성일자</th>
											<td>${reportlData.regDate}</td>
										</tr>
										<tr>
											<th style="border-left: none;">실험일자</th>
											<td colspan="3">${reportlData.testDate}</td>
										</tr>
										<tr>
											<th style="border-left: none;">실험품목</th>
											<td colspan="3">${reportlData.testObject}</td>
										</tr>
									</tbody>
								</table>
							</div>
							<div class="title5" style="float: left; margin-top: 30px;">
								<span class="txt">02. 첨부파일</span>
							</div>
							<div class="con_file fl" style="padding-bottom: 40px;">
								<c:if test="${fn:length(fileList)> 0}">
									<ul>
										<li>
											<dt>1. 파일리스트</dt>
											<dd>
												<ul>
													<c:forEach items="${fileList}" var="fileList">
														<li><a href="/file/fileDownload?fmNo=${fileList.fmNo}&tbkey=${fileList.tbKey}&tbType=report">
															<c:choose>
																<c:when test="${fileList.isOld == 'Y'}">
																	${strUtil:getOldFileName(fileList.fileName) }
																</c:when>
																<c:otherwise>
																	${fileList.orgFileName}
																</c:otherwise>
															</c:choose>
														</a></li>
													</c:forEach>
												</ul>
											</dd>
										</li>
									</ul>
								</c:if>
							</div>
						</c:when>
						<c:when test="${reportlData.category1 == 'PRD_REPORT_9' || reportlData.category1 == 'PRD_REPORT_11'}">
							<div class="title5 ">
								<span class="txt">01. 제목 : ${reportlData.title}</span>
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
											<th style="border-left: none;">작성자명</th>
											<td>${reportlData.userName}</td>
											<th>작성일자</th>
											<td>${reportlData.regDate}</td>
										</tr>
										<tr>
											<th style="border-left: none;">일자</th>
											<td colspan="3">${reportlData.seminarDate}</td>
										</tr>
										<tr>
											<th style="border-left: none;">주최</th>
											<td colspan="3">${reportlData.seminarHost}</td>
										</tr>
										<tr>
											<th style="border-left: none;">주요내용</th>
											<td colspan="3">${strUtil:getHtml(reportlData.seminarContent)}</td>
										</tr>

									</tbody>
								</table>
							</div>
							<div class="title5" style="float: left; margin-top: 30px;">
								<span class="txt">02. 첨부파일</span>
							</div>
							<div class="con_file fl" style="padding-bottom: 40px;">
								<c:if test="${fn:length(fileList)> 0}">
									<ul>
										<li>
											<dt>1. 파일리스트</dt>
											<dd>
												<ul>
													<c:forEach items="${fileList}" var="fileList">
														<li><a href="/file/fileDownload?fmNo=${fileList.fmNo}&tbkey=${fileList.tbKey}&tbType=report">
															<c:choose>
																<c:when test="${fileList.isOld == 'Y'}">
																	${strUtil:getOldFileName(fileList.fileName) }
																</c:when>
																<c:otherwise>
																	${fileList.orgFileName}
																</c:otherwise>
															</c:choose>
														</a></li>
													</c:forEach>
												</ul>
											</dd>
										</li>
									</ul>
								</c:if>
							</div>
						</c:when>
						<c:when test="${reportlData.category1 == 'PRD_REPORT_10'}">
							<div class="title5 ">
								<span class="txt">01. 제목 : ${reportlData.title}</span>
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
											<th style="border-left: none;">보고서명</th>
											<td coslpan="3">${reportlData.regularTitle}</td>
										</tr>
									</tbody>
								</table>
							</div>
							<div class="title5" style="float: left; margin-top: 30px;">
								<span class="txt">02. 첨부파일</span>
							</div>
							<div class="con_file fl" style="padding-bottom: 40px;">
								<c:if test="${fn:length(fileList)> 0}">
									<ul>
										<li>
											<dt>1. 파일리스트</dt>
											<dd>
												<ul>
													<c:forEach items="${fileList}" var="fileList">
														<li><a href="/file/fileDownload?fmNo=${fileList.fmNo}&tbkey=${fileList.tbKey}&tbType=report">
															<c:choose>
																<c:when test="${fileList.isOld == 'Y'}">
																	${strUtil:getOldFileName(fileList.fileName) }
																</c:when>
																<c:otherwise>
																	${fileList.orgFileName}
																</c:otherwise>
															</c:choose>
														</a></li>
													</c:forEach>
												</ul>
											</dd>
										</li>
									</ul>
								</c:if>
							</div>
						</c:when>
						<c:otherwise>
							<div class="title5 ">
								<span class="txt">01. 기본정보</span>
							</div>
							<div class="main_tbl">
								<table class="insert_proc01" width="1046" cellpadding="0" cellspacing="0">
									<colgroup>
										<col width="15%" />
										<col width="45%" />
										<col width="40%" />
									</colgroup>
									<tbody>
										<tr>
											<th style="border-left: none; height: 20px;">구분</th>
											<td>${reportlData.subCategoryName}</td>
											<td rowspan="7" style="padding: 10px;" valign="top">
												<c:choose>
													<c:when test="${fn:length(imageFileList) > 0}">
														<c:forEach items="${imageFileList}" var="image">
															<img id="preview" src="/picture/${strUtil:getImagePath(image.path)}/${image.fileName}" style="width: 100%; height: auto; border-radius: 10px; max-height: 400px;">
														</c:forEach>
													</c:when>
													<c:otherwise>
														<img src="/resources/images/img_noimg.png" style="width: 100%; height: auto; border-radius: 10px; max-height: 400px;">
													</c:otherwise>
												</c:choose>
											</td>
										</tr>
										<tr>
											<th style="border-left: none; height: 20px;">보고서명</th>
											<td>${reportlData.regDate}/ ${reportlData.deptName} / ${reportlData.title}</td>
										</tr>
										<tr>
											<th style="border-left: none; height: 20px;">작성자</th>
											<td>${reportlData.userName}</td>
										</tr>
										<tr>
											<th style="border-left: none; height: 20px;">컨펌여부</th>
											<td>
												<c:choose>
													<c:when test="${reportlData.isConfirm == 'Y'}">
														[●]제품승인 &nbsp; [ &nbsp;]승인보류&nbsp; [ &nbsp;]비승인 
													</c:when>
													<c:when test="${reportlData.isConfirm == 'D'}">
														[ &nbsp;]제품승인 &nbsp; [●]승인보류&nbsp; [ &nbsp;]비승인 
													</c:when>
													<c:when test="${reportlData.isConfirm == 'N'}">
														[ &nbsp;]제품승인 &nbsp; [ &nbsp;]승인보류&nbsp; [●]비승인 
													</c:when>
												</c:choose>
											</td>
										</tr>
										<tr>
											<th style="border-left: none; height: 20px;">제품 출시 여부</th>
											<td>${reportlData.isReleaseText}</td>
										</tr>
										<tr>
											<th style="border-left: none;">제품특징</th>
											<td>${strUtil:getHtml(reportlData.prdFeature)}</td>
										</tr>
										<tr>
											<th style="border-left: none;">보고 결과</th>
											<td>${strUtil:getHtml(reportlData.result) }</td>
										</tr>
								</table>
							</div>

							<div class="title5" style="float: left; margin-top: 30px;">
								<span class="txt">02. 배합비 </span>
							</div>
							<div class="main_tbl">
								<table class="tbl01 option1" style="border-bottom: 2px solid #4b5165;">
									<colgroup>
										<col width="23%">
										<col width="10%">
										<col width="23%">
										<col width="10%">
										<col width="24%">
										<col width="10%">
									</colgroup>
									<thead>
										<tr>
											<th>원료명</th>
											<th>백분율</th>
											<th>원료명</th>
											<th>백분율</th>
											<th>원료명</th>
											<th>백분율</th>
										</tr>
									</thead>
									<tbody>
										<%
											if (bomList != null && bomList.size() > 0) {
											for (int i = 0; i < viewCount; i++) {
												int idx1 = i;
												int idx2 = i + viewCount;
												int idx3 = i + (viewCount * 2);
												Map<String, Object> bomData1 = bomList.get(idx1);
												Map<String, Object> bomData2 = bomList.get(idx2);
												Map<String, Object> bomData3 = bomList.get(idx3);
										%>
										<tr>
											<%
												if (bomData1.get("Level") != null && "1".equals(String.valueOf(bomData1.get("Level")))) {
											%>
											<td class="sum" style="background-color: #878896; padding-left: 120px; color: #FFF;">▼ <%=bomData1.get("name")%></td>
											<td class="sum" style="background-color: #878896"></td>
											<%
												} else {
											%>
											<td><%=bomData1.get("name")%></td>
											<td><%=bomData1.get("bom")%></td>
											<%
												}
											%>
											<%
												if (bomData2.get("Level") != null && "1".equals(String.valueOf(bomData2.get("Level")))) {
											%>
											<td class="sum" style="background-color: #878896; padding-left: 120px; color: #FFF;">▼ <%=bomData2.get("name")%></td>
											<td class="sum" style="background-color: #878896"></td>
											<%
												} else {
											%>
											<td><%=bomData2.get("name")%></td>
											<td><%=bomData2.get("bom")%></td>
											<%
												}
											%>
											<%
												if (bomData3.get("Level") != null && "1".equals(String.valueOf(bomData3.get("Level")))) {
											%>
											<td class="sum" style="background-color: #878896; padding-left: 120px; color: #FFF;">▼ <%=bomData3.get("name")%></td>
											<td class="sum" style="background-color: #878896"></td>
											<%
												} else {
											%>
											<td><%=bomData3.get("name")%></td>
											<td><%=bomData3.get("bom")%></td>
											<%
												}
											%>
										</tr>
										<%
											}
										} else {
											for (int i = 0; i < viewCount; i++) {
										%>
										<tr>
											<td>&nbsp;</td>
											<td>&nbsp;</td>
											<td>&nbsp;</td>
											<td>&nbsp;</td>
											<td>&nbsp;</td>
											<td>&nbsp;</td>
										</tr>
										<%
											}
										}
										%>
									</tbody>
								</table>
							</div>
							<div class="title5" style="float: left; margin-top: 30px;">
								<span class="txt">03. 첨부파일</span>
							</div>
							<div class="con_file fl" style="padding-bottom: 40px;">
								<c:if test="${fn:length(fileList)> 0}">
									<ul>
										<li>
											<dt>1. 파일리스트</dt>
											<dd>
												<ul>
													<c:forEach items="${fileList}" var="fileList">
														<li>
															<c:choose>
																<c:when test="${fileList.isOld == 'Y'}">
																	<a href="/file/fileDownload?fmNo=${fileList.fmNo}&tbkey=${fileList.tbKey}&tbType=report">${strUtil:getOldFileName(fileList.fileName) }</a>
																</c:when>
																<c:otherwise>
																	<a href="/file/fileDownload?fmNo=${fileList.fmNo}&tbkey=${fileList.tbKey}&tbType=report">${fileList.orgFileName}</a>
																</c:otherwise>
															</c:choose>
														</li>
													</c:forEach>
												</ul>
											</dd>
										</li>
									</ul>
								</c:if>
							</div>
						</c:otherwise>
					</c:choose>
				</c:otherwise>
			</c:choose>
			<div class="btn_box_con5">
				<button class="btn_admin_gray" onClick="goList()" style="width: 120px;">목록</button>
			</div>
			<div class="btn_box_con4">
				<c:if test="${userUtil:getUserId(pageContext.request) == reportlData.regUserId}">
					<c:if test="${reportlData.isOld != 'Y' && reportlData.category1 == 'PRD_REPORT_5' }">
						<button class="btn_admin_nomal" onClick="goPreview('${reportlData.reportKey}')">미리보기</button>
					</c:if>
					<c:if test="${reportlData.isOld != 'Y'}">
						<button class="btn_admin_navi" onClick="goUpdate()">수정</button>
					</c:if>
					<button class="btn_admin_gray" onClick="goDelete()">삭제</button>
				</c:if>
			</div>

			<hr class="con_mode" />
			<!-- 신규 추가 꼭 데려갈것 !-->
		</div>
	</section>
</div>