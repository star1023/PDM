<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page session="false" %>
<title>사용자 조회</title>
<script type="text/javascript" src='<c:url value="/resources/js/jquery-3.3.1.js"/>'></script>
<script type="text/javascript" src='<c:url value="/resources/js/jquery.form.js"/>'></script>
<script type="text/javascript" src='<c:url value="/resources/js/jquery.selectboxes.js"/>'></script>

<form name="listForm" id="listForm" method="post">
	<div class="wrap_in" id="fixNextTag">
	<section class="type01">
		<div class="group01">
			<div class="title"><span class="txt">직원찾기</span></div>
			<div class="search_box" >
				<ul style="border-top:none;">
					<li style=" width:100%">
						<dt>키워드</dt>
						<dd style=" width:900px">
							<input type="text" name="keyword" id="keyword" value="${paramVO.keyword}" class="ml5" style="width:180px;"/>
						</dd>
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
						<col width="25%">
						<col width="25%"/>
						<col width="20%">
						<col width="20%">
					</colgroup>
					<thead>
						<tr>
							<th>선택</th>
							<th>부서명</th>
							<th>팀명</th>
							<th>권한</th>
							<th>이름</th>
						</tr>	
					</thead>
					<tbody>
					<c:if test="${totalCount == 0 }">
						<tr>
							<td colspan="5">사용자가 없습니다.</td>
						</tr>
					</c:if>
					<c:if test="${totalCount > 0 }">
						<c:forEach items="${userList}" var="item">
						<tr>
							<td>
								선택
							</td>							
							<td>
								${item.deptCodeName}
							</td>
							<td>
								${item.teamCodeName}
							</td>
							<td>
								${item.userGradeName}
							</td>							
							<td>${item.userName}</td>							
						</tr>
						</c:forEach>
					</c:if>	
					</tbody>
				</table>
				<c:if test="${totalCount > 0 }">
				<div class="page_navi  mt10">
					${navi.prevBlock}
					${navi.pageList}
					${navi.nextBlock}
				</div>
				</c:if>
			 		<hr class="con_mode"/><!-- 신규 추가 꼭 데려갈것 !-->
			</div>
		</div>
	</section>	
</div>
</form>