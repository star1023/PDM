<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ page session="false" %>
<title>제조공정도</title>
<div class="wrap_in" id="fixNextTag">
	<span class="path">보고서&nbsp;&nbsp;
		<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;
		<a href="#">삼립식품 연구개발시스템</a>
	</span>
	<section class="type01">
	<!-- 상세 페이지  start-->
		<h2 style="position:relative">
			<span class="title_s">Process Line</span>
			<span class="title">제조공정도</span>
			<div  class="top_btn_box">
				<div  class="top_btn_box">
					<ul><li><button class="btn_circle_red" onClick="location.href='#open'">&nbsp;</button></li></ul>
				</div>
			</div>
		</h2>
		<div class="group01">
			<div class="title"><!--span class="txt">연구개발시스템 공지사항</span--></div>
			<div class="search_box" >
				<ul style="border-top:none;">
					<li style=" width:100%">
					</li>
				</ul>
				<div class="fr pt5 pb10">
					<button class="btn_con_search"><img src="/resources/images/btn_icon_refresh.png" style="vertical-align:middle;"/> 검색 초기화</button> 
					<button class="btn_con_search"><img src="/resources/images/btn_icon_search.png" style="vertical-align:middle;"/> 검색</button>
				</div>
			</div>
			<div class="main_tbl">
				<table class="tbl01">
					<colgroup>
						<col width="10%">
						<col width="15%">
						<col width="10%">
						<col />
					</colgroup>
					<thead>
						<tr>
							<th>공장</th>
							<th>라인</th>
							<th>생산제품</th>
							<th>첨부파일</th>
						</tr>	
					</thead>
					<tbody>
					
						<c:set var="temp" value="" />
						<c:forEach items="${processLineList}" var="item" varStatus="status">
						<tr id="row${status.count}">
							<c:if test="${temp != item.plantName}">
							<td rowspan="${item.plantCnt}">${item.plantName}</td>
							</c:if>
							<td>${item.lineCode}</td>
							<td>${item.lineName}</td>
							<td>
								<c:forEach  items="${fileMap}" var="fileData">
									<c:set var="keyVal" value="${fileData.key}"/>
									<c:if test="${keyVal == item.ptNo}">
										<c:set var="fileList" value="${fileData.value}"/>
										<c:forEach items="${fileList}" var="file">
											<div>
												<c:choose>
													<c:when test="${file.isOld == 'Y'}">
													${strUtil:getOldFileName(file.fileName) }
													</c:when>
													<c:otherwise>
													${file.orgFileName}
													</c:otherwise>
												</c:choose>
											</div>
										</c:forEach>
									</c:if>
								</c:forEach>
							</td>
							<c:set var="temp" value="${item.plantName}" />
						</tr>
						</c:forEach>
						
					</tbody>
				</table>
				<div class="btn_box_con">					
				</div>
			 		<hr class="con_mode"/><!-- 신규 추가 꼭 데려갈것 !-->
				</div>
		</div>
	</section>	
</div>