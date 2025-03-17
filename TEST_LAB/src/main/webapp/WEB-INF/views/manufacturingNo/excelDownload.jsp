<%@ page language="java" contentType="application/vnd.ms-excel; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.aspn.util.DateUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page session="false" %>
<%
	String currentDate = DateUtil.getDate();
	response.setContentType("application/vnd.msexcel;charset=UTF-8");
	response.setHeader("Content-Disposition", "attachment; filename=\"EXCEL_"+currentDate+".xls\";");
	response.setHeader("Content-Description", "JSP Generated Data");
	response.setHeader("Pragma", "public");
	response.setHeader("Cache-Control", "max-age=0");
%>
<table border="1" cellpadding="0" cellspacing="0" style=" border:2px solid #666" class="outside">
	<tr>
		<td rowspan="2">회사</td>
		<td rowspan="2">플랜트</td>
		<td rowspan="2">인허가번호</td>
		<td rowspan="2">품목제조보고 번호</td>
		<td rowspan="2">품목명</td>
		<td rowspan="2">보관조건</td>
		<td rowspan="2">소비기한</td>
		<td rowspan="2">제품유형</td>
		<td rowspan="2">제품코드</td>
		<td rowspan="2">위탁</td>
		<td rowspan="2">OEM</td>
		<td colspan="${fn:length(plantList)}" align="center">생산공장</td>
		<td rowspan="2">담당자</td>
		<td rowspan="2">처리일</td>
		<td rowspan="2">상태</td>
		<td rowspan="2">비고</td>
	</tr>
	<tr>
		<c:forEach items="${plantList}" var="item">
		<td>${item.plantName}</td>
		</c:forEach>
	</tr>
	<c:choose>
	<c:when test="${fn:length(manufacturingNoList) > 0}">
	<c:set var="temp" value="" />
	<c:forEach items="${manufacturingNoList}" var="list" varStatus="status">
	<tr id="row${status.count}">
		<c:if test="${temp != list.seq}">
		<td rowspan="${list.logCount}">${list.companyName}</td>
		<td rowspan="${list.logCount}">${list.plantName}</td>
		<td rowspan="${list.logCount}">${list.licensingNo}</td>
		<td rowspan="${list.logCount}">${list.manufacturingNo}</td>
		</c:if>
		<td>${list.manufacturingName}</td>
		<td>${list.keepConditionName}</td>
		<td>${list.sellDate}</td>
		<td>
			[${list.productType1Name}
			<c:if test="${list.productType2Name != null && list.productType2Name != '' }">
			>${list.productType2Name}
			</c:if>
			<c:if test="${list.productType3Name != null && list.productType3Name != '' }">
			${list.productType3Name}
			</c:if>
			]
			${list.sterilizationName}/${list.etcDisplayName}
		</td>
		<td>${list.productCodes}</td>
		<td align="center">
			<c:if test="${list.referral != null && list.referral == 'Y' }">
			●
			</c:if>
		</td>
		<td align="center">
			<c:if test="${list.oem != null && list.oem == 'Y' }">
			●
			</c:if>
		</td>
		<c:forEach items="${plantList}" var="item">
		<td align="center">
			<c:forEach items="${fn:split(list.createPlant, ',') }" var="plant">
    		<c:if test="${item.plantCode != null && item.plantCode == fn:trim(plant) }">
    		●
    		</c:if>
    		</c:forEach>			
		</td>
		</c:forEach>
		<td>${list.userName}</td>
		<td>${list.regDate}</td>
		<td>${list.regTypeName}</td>
		<td>${list.comment}</td>
	</tr>
	<c:set var="temp" value="${list.seq}" />
	</c:forEach>
	</c:when>
	<c:otherwise>
	<tr>
		<td colspan="15">데이터가 없습니다.</td>
	</tr>
	</c:otherwise>
	</c:choose>	
</table>