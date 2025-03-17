<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ page import="java.util.*" %>
<%@ page session="false" %>
<%
List<Map<String,Object>> bomList =  (List<Map<String,Object>>)request.getAttribute("bomList");
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
<script type="text/javascript">
var PARAM = {
		category1 : '${paramVO.category1}',
		category2 : '${paramVO.category2}',
		category3 : '${paramVO.category3}',
		keyword : '${paramVO.keyword}',
		pageNo : '${paramVO.pageNo}'
	};

$(document).ready(function() {

});
var initBody;
function pageprint() {
	window.onbeforeprint = beforePrint;
	window.onafterprint = afterPrint;
	window.print();
}

function beforePrint() { //인쇄 하기 전에 실행되는 내용
	//$("#buttonArea1").hide();
	//$("#buttonArea2").hide();
	//$(".print_hidden").hide();
	initBody = document.body.innerHTML;
	//alert(initBody);
	//document.body.innerHTML = print_page.innerHTML;
	document.body.innerHTML = $("#print_page").html();
}

function afterPrint(){ //인쇄가 끝난 후 실행되는 내용
	 document.body.innerHTML = initBody;
	 //$(".print_hidden").show();
	//$("#buttonArea1").show();
	//$("#buttonArea2").show();
}

/*if (window.matchMedia) {	//크롬 브라우저에도 적용되도록 추가
    var mediaQueryList = window.matchMedia('print');
    mediaQueryList.addListener(function(mql) {
        if (mql.matches) {
            beforePrint();
        } else {
            afterPrint();
        }
    });
}*/
</script>
<h2 style=" position:fixed;" class="print_hidden">
	<span class="title">
		<img src="../resources/images/bg_bs_box_fast02.png">&nbsp;&nbsp;경영층 보고서 출력
	</span>
</h2>
<div  class="top_btn_box" style=" position:fixed;" class="print_hidden">
	<ul>
		<li><button type="button" class="btn_pop_close" onClick="self.close();"></button></li>
	</ul>
</div>
<div id='print_page'  style="padding:10px 0 20px 20px;">
	<table width="1046" cellpadding="0" cellspacing="0" class="print_hidden">
		<tr>
			<td align="right" height="50" valign="top"></td>
		</tr>
	</table>
	<table width="1046" cellpadding="0" cellspacing="0" class="print_hidden">
		<tr>
			<td align="right" height="50" valign="top">
				<button type="button" class="btn_admin_nomal" onClick="pageprint()">프린트</button> 
				<button type="button" class="btn_admin_gray" onClick="self.close();">취소</button>
			</td>
		</tr>
	</table>
	<div class="main_tbl" style="width:1046px;">
		<div class="watermark"><img src="../resources/images/watermark.png"></div>
		<table class="insert_proc01" width="1046" cellpadding="0" cellspacing="0">
			<colgroup>
				<col width="15%"/>
				<col width="45%"/>
				<col width="40%"/>
			</colgroup>
			<tbody>
				<tr>
					<th style="border-left: none; height:20px;">구분</th>
					<td>${reportlData.subCategoryName}</td>
					<td rowspan="8" style="padding:10px;" valign="top">
						<c:choose>
							<c:when test="${fn:length(imageFileList) > 0}">
							<c:forEach items="${imageFileList}" var="image">
								<img src="/picture/${strUtil:getImagePath(image.path)}/${image.fileName}" style="width:100%; height:auto; border-radius:10px; max-height:400px;">
							</c:forEach>
							</c:when>
							<c:otherwise>
								<img src="../resources/images/img_noimg.png" style="width:100%; height:auto; border-radius:10px; max-height:400px;">
							</c:otherwise>
						</c:choose>
					</td>
				</tr>
				<tr>
					<th style="border-left: none; height:20px;">보고서명</th>
					<td>${reportlData.regDate} / ${reportlData.deptName} / ${reportlData.title}</td>
				</tr>
				<tr>
					<th style="border-left: none;height:20px;">작성자</th>
					<td>${reportlData.userName}</td>
				</tr>
				<tr>
					<th style="border-left: none;height:20px;">컨펌여부</th>
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
					<th style="border-left: none;height:20px;">제품 출시 여부</th>
					<td>${reportlData.isReleaseText}</td>
				</tr>
				<tr>
					<th style="border-left: none;">제품특징</th>
					<td>${strUtil:getHtml(reportlData.prdFeature)} </td>
				</tr>
				<tr>
					<th style="border-left: none;">보고 결과</th>
					<td>${strUtil:getHtml(reportlData.result) }</td>
				</tr>
			</tbody>
		</table>
	</div>
	<div class="main_tbl" style="width:1046px; margin-top:20px;">
		<table class="tbl01 option1" style="border-bottom:2px solid #4b5165;">
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
					if( bomList != null && bomList.size() > 0 ) {
						for( int i = 0 ; i < viewCount ; i++ ) {
							int idx1 = i;
							int idx2 = i+viewCount;
							int idx3 = i+(viewCount*2);
							Map<String,Object> bomData1 =  bomList.get(idx1);
							Map<String,Object> bomData2 =  bomList.get(idx2);
							Map<String,Object> bomData3 =  bomList.get(idx3);
				%>
				<tr>
					<% if( bomData1.get("Level") != null && "1".equals(String.valueOf(bomData1.get("Level"))) ) { %>
						<td class="sum" style="background-color:#878896; padding-left:120px; color:#FFF;">▼ <%=bomData1.get("name")%></td>
						<td class="sum" style="background-color:#878896"></td>
					<% } else { %>
						<td><%=bomData1.get("name")%></td>
						<td><%=bomData1.get("bom")%></td>
					<% } %>
					<% if( bomData2.get("Level") != null && "1".equals(String.valueOf(bomData2.get("Level"))) ) { %>
						<td class="sum" style="background-color:#878896; padding-left:120px; color:#FFF;">▼ <%=bomData2.get("name")%></td>
						<td class="sum" style="background-color:#878896"></td>
					<% } else { %>
						<td><%=bomData2.get("name")%></td>
						<td><%=bomData2.get("bom")%></td>
					<% } %>
					<% if( bomData3.get("Level") != null && "1".equals(String.valueOf(bomData3.get("Level"))) ) { %>
						<td class="sum" style="background-color:#878896; padding-left:120px; color:#FFF;">▼ <%=bomData3.get("name")%></td>
						<td class="sum" style="background-color:#878896"></td>
					<% } else { %>
						<td><%=bomData3.get("name")%></td>
						<td><%=bomData3.get("bom")%></td>
					<% } %>
				</tr>
				<%				 
						 }
					} else {
						for( int i = 0 ; i < viewCount ; i++ ) {
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
	<table width="1046" cellpadding="0" cellspacing="0" class="print_hidden">
		<tr>
			<td align="right" height="50" valign="bottom">
				<button type="button" class="btn_admin_nomal" onClick="pageprint()">프린트</button> 
				<button type="button" class="btn_admin_gray" onClick="self.close()">취소</button>
			</td>
		</tr>
	</table>
</div>