<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ page session="false" %>
<title>레포트</title>
<script type="text/javascript">
var PARAM = {
		category1 : '${paramVO.category1}',
		category2 : '${paramVO.category2}',
		category3 : '${paramVO.category3}',
		keyword : '${paramVO.keyword}',
		pageNo : '${paramVO.pageNo}'
	};

function goList() {
	location.href="/report/list?"+getParam('${paramVO.pageNo}');
}

//파라미터 조회
function getParam(pageNo){
	PARAM.pageNo = pageNo || '${paramVO.pageNo}';
	return $.param(PARAM);
}

//파일 다운로드
function fileDownload(fmNo, tbkey){
	location.href="/file/fileDownload?fmNo="+fmNo+"&tbkey="+tbkey+"&tbType=report";
}

function goUpdate() {
	location.href="/report/updateForm?rNo="+${reportlData.reportKey}+"&"+getParam('${paramVO.pageNo}');
}

function goDelete() {
	if(confirm("삭제하시겠습니까?")){
		location.href="/report/delete?rNo="+${reportlData.reportKey}+"&apprNo="+${reportlData.apprNo};    
	}
}
</script>
<div class="wrap_in" id="fixNextTag">
	<span class="path">보고서&nbsp;&nbsp;
		<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;
		<a href="#">삼립식품 연구개발시스템</a>
	</span>
	<section class="type01">
	<!-- 상세 페이지  start-->
		<h2 style="position:relative">
			<span class="title_s">Report</span>
			<span class="title">보고서</span>
			<div  class="top_btn_box">
				<ul>
					<li><button class="btn_circle_nomal" onClick="location.href='main.html'">&nbsp;</button></li>
				</ul>
			</div>
		</h2>
		<div class="group01" >
			<div class="title"><!--span class="txt">연구개발시스템 공지사항</span--></div>
			<div class="list_detail">
				<ul>
					<li class="pt10">
						<dt>분류</dt>
						<dd class="pr20 pb10">
							<c:choose>
								<c:when test="${reportlData.category1 == '4' || reportlData.category1 == '5'}">
								${reportlData.category1Name} - ${reportlData.category2Name} - ${reportlData.category3Name} 
								</c:when>
								<c:otherwise>
								${reportlData.category1Name}
								<c:if test="${reportlData.category1 != '3'}">
									- ${reportlData.category2Name}
								</c:if>
								</c:otherwise>	
							</c:choose>
						</dd>
					</li>
					<li class="normalReport">
						<c:choose>
							<c:when test="${reportlData.category1 == '4' || reportlData.category1 == '5'}">
							<dt>제품명</dt>
							<dd class="pr20 pb10">${reportlData.prdTitle}</dd>
							</c:when>
							<c:otherwise>
							<dt>제목</dt>
							<dd class="pr20 pb10">${reportlData.title}</dd>
							</c:otherwise>
						</c:choose>
					</li>
					<c:if test="${reportlData.category1 == '4' || reportlData.category1 == '5' && (reportlData.reportDate != null && reportlData.reportDate != '') }">
					<li class="espReport">
						<dt>보고일자</dt>
						<dd class="pr20 pb10">
							${reportlData.reportDate}
						</dd>
					</li>
					</c:if>
					<c:if test="${reportlData.category1 == '4' || reportlData.category1 == '5'}">
					<li class="espReport">
						<dt>제품특징</dt>
						<dd class="pr20 pb10">
							${strUtil:getHtml(reportlData.prdFeature) }
						</dd>
					</li>
					</c:if>
					<li class="espReport">
						<c:choose>
							<c:when test="${reportlData.category1 == '4' || reportlData.category1 == '5'}">
							<dt>제조방법</dt>
							<dd class="pr20 pb10">
								${strUtil:getHtml(reportlData.adviserPrd) }
							</dd>
							</c:when>
							<c:otherwise>
							<dt>메모</dt>
							<dd class="pr20 pb10">
								${strUtil:getHtml(reportlData.content) }
							</dd>
							</c:otherwise>
						</c:choose>
					</li>
					<c:if test="${fn:length(fileList) > 0}">
					<li class="mb5" id="fileList">
						<dt>파일리스트 </dt>
						<dd>
							<div class="file_box_pop"style=" height:100px; width:97.5%;" >
							<ul id="fileData">
							<c:forEach items="${fileList}" var="fileList">
								<li>
								<a href="/file/fileDownload?fmNo=${fileList.fmNo}&tbkey=${fileList.tbKey}&tbType=report"><img src="/resources/images/icon_file01.png" style="vertical-align:middle;"/></a>
									<c:choose>
										<c:when test="${fileList.isOld == 'Y'}">
										${strUtil:getOldFileName(fileList.fileName) }
										</c:when>
										<c:otherwise>
										${fileList.orgFileName}
										</c:otherwise>
									</c:choose>
								</li>
							</c:forEach>
							</ul>
							</div>
						</dd>
					</li>
					</c:if>
				</ul>			
		</div>	
		<div class="btn_box_con5">
			<button class="btn_admin_gray" onClick="goList()"  style="width:120px;">목록</button>
		</div>
		<div class="btn_box_con4"> 
		<c:if test="${reportlData.state != '1'}">
			<button class="btn_admin_navi" onClick="goUpdate()">수정</button> 
		</c:if>	
			<button class="btn_admin_gray"onClick="goDelete()">삭제</button>
		</div>	
		<hr class="con_mode"/><!-- 신규 추가 꼭 데려갈것 !-->	
					
		</div>
	</section>	
</div>