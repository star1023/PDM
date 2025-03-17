<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page session="false" %>
<script type="text/javascript" src='<c:url value="/resources/js/jquery-3.3.1.js"/>'></script>
<script type="text/javascript" src='<c:url value="/resources/js/jquery.form.js"/>'></script>
<script type="text/javascript" src='<c:url value="/resources/js/jquery.selectboxes.js"/>'></script>
<script type="text/javascript">
	var PARAM = {
			isSample: '${paramVO.isSample}',
			searchCompany: '${paramVO.searchCompany}',
			searchPlant: '${paramVO.searchPlant}',
			searchType: '${paramVO.searchType}',
			searchValue: '${paramVO.searchValue}',
			pageNo: '${paramVO.pageNo}'
	};
	function goList() {
		location.href = '../material/list?' + $.param(PARAM);
	}

</script>	
	<title>자재관리</title>
	<form name="viewForm" method="post">
		<table>
			<tr>
				<td>자재명</td>
				<td>
					${materialVO.name}
				</td>
			</tr>
			<tr>
				<td>작성일</td>
				<td>
					${materialVO.regDate}
				</td>
			</tr>
			<tr>
				<td>SAP 코드</td>
				<td>
					 ${materialVO.sapCode}
				</td>
			</tr>
			<tr>
				<td>공장</td>
				<td>
					${materialVO.companyName}(${materialVO.plantName})
				</td>
			</tr>
			<tr>
				<td>단가/단위</td>
				<td>
					${materialVO.price}/${materialVO.unit}
				</td>
			</tr>
			<tr>
				<td>구분</td>
				<td>
					${materialVO.typeName}
				</td>
			</tr>
		</table>
		<div class="btn_box_con">
			<button type="button" class="btn_admin_gray" onclick="javascript:goList();">목록</button>
		</div>
	</form>