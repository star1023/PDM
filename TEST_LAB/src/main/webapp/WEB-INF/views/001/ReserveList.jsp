<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page session="false" %>
	<title>공지사항</title>
<script type="text/javascript">
	
	var iTop = (window.screen.height-30-600)/2;
	var iLeft = (window.screen.width-10-600)/2;
	
	
	//공지사항 작성페이지
	function goReserve(){
		var iWindowFeatures = "height=420, width=800, top="+iTop+", left="+iLeft+", toolbar=no, scrollbars=yes, resizable=no, menubar=no, location=no, status=no"; 
		window.open("/Reserve/ReserveSave", "Reservation Info", iWindowFeatures);
	}	
	
	
	function paging(page) {
		
		location.href = '/Reserve/ReserveList?pageNo=' + page;
		
	}
	
	function goReserveView(no){
		
		var iWindowFeatures = "height=420, width=800, top="+iTop+", left="+iLeft+", toolbar=no, scrollbars=yes, resizable=no, menubar=no, location=no, status=no"; 
		
		var url = '/Reserve/ReserveView?rmrNo='+ no;
		
		window.open( url , "Reservation Info", iWindowFeatures);
	
	}
</script>

<form name="listForm" id="listForm" method="get" action="/Reserve/ReserveList">
<jsp:useBean id="toDay" class="java.util.Date" />
	<span class="path">
		공지사항&nbsp;&nbsp;<img src="../resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;
		<a href="#">SPC삼립연구소</a>
	</span>
	<section class="type01">
		<h2 style="position:relative">
			<span class="title_s">Notice</span>
			<span class="title">공지사항</span>
			<div class="top_btn_box">
				<ul>
					<li>
						<button type="button" onclick="goReserve(); return false;"  class="btn_circle_red">&nbsp;</button>
					</li>
				</ul>
			</div>
		</h2>
		<br>
		<div class="group01" >
			<div class="main_tbl" >
				<table class="tbl01" >
					<colgroup>
						<col width="5%">
						<col width="40%">
						<col width="30%">
						<col width="15%">
						<col width="10%">
					</colgroup>
					<thead>
					<tr>
						<th>번호</th>
						<th>회의일시</th>
						<th>회의명</th>
						<th>작성자</th>
						<th>작성일</th>
					</tr>
					</thead>
					<tbody>
					<c:if test="${fn:length(reserveNotiList) > 0 }">
						<c:forEach items="${reserveNotiList}" var="item" varStatus="status">
							<tr style="font-weight: bold; background-color: #F6F6F6;">
								<td>공지</td>
								<td><fmt:formatDate value="${item.reserveDate}" pattern="yyyy-MM-dd"/>(${item.dw}) ${item.reserveTime}</td>
								<td style="text-align:left"><a style="cursor:pointer;" onclick="goReserveView(${item.rmrNo})">&nbsp;${item.title}</a></td>
								<td>${item.regUserName}</td>
								<td>
								 <c:choose>
								 	<c:when test="${empty item.modDate}">
										${item.regDate}
									</c:when>
									<c:otherwise>
										${item.modDate}
									</c:otherwise>
								</c:choose>
								</td>
							</tr>
						</c:forEach>		
					</c:if>
					<c:if test="${fn:length(reserveList) > 0}">
						<c:forEach items="${reserveList}" var="item" varStatus="status">
							<tr>
								<td>${item.rn}</td>
								<td><fmt:formatDate value="${item.reserveDate}" pattern="yyyy-MM-dd"/>(${item.dw}) ${item.reserveTime}</td>
								<td style="text-align:left"><a style="cursor:pointer;" onclick="goReserveView(${item.rmrNo})">&nbsp;${item.title}</a></td>
								<td>${item.regUserName}</td>
								<td>
								 <c:choose>
								 	<c:when test="${empty item.modDate}">
										${item.regDate}
									</c:when>
									<c:otherwise>
										${item.modDate}
									</c:otherwise>
								</c:choose>
								</td>
							</tr>
						</c:forEach>	
					</c:if>
					<c:if test="${fn:length(reserveList) == 0}">
						<tr>
							<td colspan="5">조회 결과가 없습니다.</td>
						</tr>	
					</c:if>
					</tbody>
				</table>
			</div>
			<c:if test="${totalCount > 0}">
				<div class="page_navi mt10">
					${navi.prevBlock}
					${navi.pageList}
					${navi.nextBlock}
				</div>
			</c:if>
		</div>
	</section>
</form>

