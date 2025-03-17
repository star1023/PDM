<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<title>자재검색 </title>
<script type="text/javascript">
	$(document).ready(function(){
		
	})
	
	function changePage(page){
		location.href = '/design/getMaterialListPopup?'
				+'showPage=' + page
				+ '&' + $('#searchForm').serialize();
	}
	
	function search(){
		location.href = '/design/getMaterialListPopup?' + $('#searchForm').serialize();
	}

	function setData(itemImNo, itemSAPCode, itemName, itemPrice, itemUnit) {
		var parentRowId = '${parentRowId}';
		window.opener.setMaterialPopupData(parentRowId, itemImNo, itemSAPCode, itemName, itemPrice, itemUnit);
		window.close();
	}
</script>

<section class="type01">
	<h2 style="position:relative">
		<span class="title">
			<img src="../resources/images/bg_bs_box_fast02.png">&nbsp;&nbsp;자재검색
		</span>
	</h2>
	<div  class="top_btn_box">
		<ul>
			<li><button type="button" class="btn_pop_close" onClick="javascript:self.close();"></button></li>
		</ul>
	</div>
	<div class="group01" >
		<div class="title"><!--span class="txt">연구개발시스템 공지사항</span--></div>
		<div class="tab" style="padding-bottom:1px">
			<ul>
				<a href="#"><li class="select selectboxC">자재검색</li></a>
				<!--a href="#"><li>포함배합관리</li></a-->
			</ul>
		</div>
		<div class="search_box">
			<form id="searchForm">
				<input type="hidden" name="parentRowId" value="${parentRowId}">
				<ul style="border-top:none;">
					<li  style="width:100% !important">
						<dt style="width:200px">자재명/자재코드</dt>
						<dd >
							<input type="text" name="searchValue" id="searchValue" value="" onKeyDown="if(event.keyCode==13){search();}return;">
						</dd>
					</li>
				</ul>
				<div class="fr pt5 pb10">
					<button type="button" class="btn_con_search" onClick="javascript:search()"><img src="../resources/images/btn_icon_search.png" style="vertical-align:middle;"/> 검색</button>
				</div>
			</form>
		</div>
		<div class="main_tbl">
			<table class="tbl01">
				<colgroup>
					<col width="80px">
					<col width="120px">
					<col/>
					<col width="100px">
					<col width="100px">
				</colgroup>
				<thead>
					<tr>
						<th>&nbsp;</th>
						<th>SAP 코드</th>
						<th>자재명</th>
						<th>단위</th>
						<th>단가</th>
					</tr>
				</thead>
				<tbody>
				<c:if test="${materialList.page.totalCount == 0 }">
					<tr>
						<td colspan="5" align="center">조회 결과가 없습니다.</td>
					</tr>
				</c:if>
				<c:if test="${materialList.page.totalCount > 0 }">
					<c:forEach items="${materialList.pagenatedList}" var="item">
					<tr>
						<td>
							<button type="button" class="btn_table_nomal" onClick="javascript:setData('${item.itemImNo}','${item.itemSAPCode}','${item.itemName}','${item.itemPrice}','${item.itemUnit}')">자재선택</button>
						</td>
						<td>${item.itemSAPCode}</td>
						<td>${item.itemName}</td>
						<td>${item.itemUnit}</td>
						<td>${item.itemPrice}</td>
					</tr>
					</c:forEach>
				</c:if>
				</tbody>
			</table>
			<div class="page_navi mt10">
				<ul>
					<c:if test="${materialList.page.hasPrev() == true}">
						<li style="border-right: none;">
							<a href="#none" class="btn btn_prev1" onclick="changePage(${materialList.page.pageBlock[0]-1})">Prev</a>
						</li>	
					</c:if>
					<c:forEach items="${materialList.page.getPageList()}" var="page">
						<c:if test="${page == materialList.page.showPage}">
							<li class="select" style="border-right: none;">
								<a href="#none" class="btn btn_prev1" onclick="changePage(${page})">${page}</a>
							</li>
						</c:if>
						<c:if test="${page != materialList.page.showPage}">
							<li style="border-right: none;">
								<a href="#none" class="btn btn_prev1" onclick="changePage(${page})">${page}</a>
							</li>
						</c:if>
					</c:forEach>
					<c:if test="${materialList.page.hasNext() == true}">
						<li style="border-right: none;">
							<a href="#none" class="btn btn_next3" onclick="changePage(${materialList.page.pageBlock[4]+1})">Next</a>
						</li>	
					</c:if>
				</ul>
			</div>
		</div>
	</div>
</section>