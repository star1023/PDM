<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ page import="kr.co.aspn.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ taglib prefix="userUtil" uri="/WEB-INF/tld/userUtil.tld"%>
<%@ page session="false" %>
<%
	String isAdmin = UserUtil.getIsAdmin(request);
%>
<title>제조공정도</title>
<script type="text/javascript">
var PARAM = {

	};
$(document).ready(function() {
	fileListCheck();
});

function fileListCheck() {
	var nodes=$("#fileData").children();
	if( nodes.length > 0 ) {
		$("#fileList").show();
	} else {
		$("#fileList").hide();
	}
}

function changePlant() {
	var URL = "../processLine/getLineCodeAjax";
	$.ajax({
		type:"POST",
		url:URL,
		data:{ 'plantName' : $("#plant").selectedValues()[0]
		},
		dataType:"json",
		async:false,
		success:function(data) {
			$("#line").removeOption(/./);
			if( data.length > 0 ) {
				$("#line").addOption('', '==라인==', true);
				$.each(data, function( index, value ){ //배열-> index, value
					$("#line").addOption(value.ptNo, value.lineCode, false);
				});
			}
			
		},
		error:function(request, status, errorThrown){
				alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
		}			
	}); 
}

var tmpNo = 1;

function addFile(fileIdx) {
	if( !chkNull($("#plant").selectedValues()[0]) ) {
		alert("공장을 선택하세요.");
		$("#plant").focus();
		return;
	} else if( !chkNull($("#line").selectedValues()[0]) ) {
		alert("라인을 선택하세요.");
		$("#line").focus();
		return;
	} else {
		var filePath = document.getElementById("file"+fileIdx).value;
		var fileName = filePath.substring(filePath.lastIndexOf('\\') + 1,	filePath.length);
		if (fileName.length == 0) {
			alert("파일을 선택해 주십시요.");
			return;
		}
		// 파일 추가
		$("#fileSpan"+fileIdx).hide();
		var html = "";
		html += "<li id='selfile" + fileIdx 	+ "' style='width:100%'>";
		html += "&nbsp;&nbsp;"+$("#plant").selectedTexts()[0];
		html += "&nbsp;&nbsp;"+$("#line").selectedTexts()[0]+"&nbsp;&nbsp;&nbsp;";
		html += "		<a href='#' onClick='javascript:deleteFile(this)'><img src=\"/resources/images/icon_del_file.png\"></a>";
		html += "		"+ fileName + "";
		html += "		<input type='hidden' name='plantCode' value='"+$("#plant").selectedValues()[0]+"' />";
		html += "		<input type='hidden' name='lineCode' value='"+$("#line").selectedValues()[0]+"' />";
		html += "</li>"
		$("#fileData").append(html);
		tmpNo = ++fileIdx;
		html = "";
		html += "<span class=\"file_load\" id=\"fileSpan" + fileIdx + "\">";
		html += "	<input type='file' name='file' id='file" + fileIdx + "' onChange=\"javaScript:addFile(tmpNo)\">";
		html += "	<label class=\"btn-default\" for=\"file" + fileIdx + "\">파일첨부</label>";
		html += "</span>"
		//$("#upFile").append("<span class=\"file_load\" id=\"fileSpan" + fileIdx + "\"><input type='file' name='file' id='file" + fileIdx + "' onChange=\"javaScript:addFile(tmpNo)\"><label class=\"btn-default\" for=\"file" + fileIdx + "\">파일첨부</label></span>");
		$("#upFile").append(html);
		fileListCheck();
	}
}

//추가 파일 삭제 함수
function deleteFile(e){
	var fileSpanId = $(e).parent().prop("id");
	var fileIndex = fileSpanId.slice(7);
	var fileId = "file"+fileIndex;
	var fileNo = fileIndex - 1;
	$(e).parent().remove();
	$("#file"+ fileNo).remove();
	$("#fileSpan"+fileNo).remove();
	fileListCheck();
	return;
}

//파일 다운로드
function fileDownload(fmNo, tbkey){
	location.href="/file/fileDownload?fmNo="+fmNo+"&tbkey="+tbkey+"&tbType=lineProcessTree";
}

function fileDelete( fmNo ) {
	var URL = "../file/deleteFileAjax";
	$.ajax({
		type:"POST",
		url:URL,
		data:{ 'fmNo' : fmNo
		},
		dataType:"json",
		async:false,
		success:function(data) {
			if( data.result > 0 ) {
				alert("삭제되었습니다.");
				document.location.href="/processLine/list"
			}
		},
		error:function(request, status, errorThrown){
				alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
		}			
	}); 
}

//저장
function goInsert(){
	var nodes=$("#fileData").children();
	if(nodes.length < 1){
		alert("파일을 추가하세요.");
		return;
	}
	if(confirm("저장하시겠습니까?")){
		document.listForm.submit();
	}
}

//저장
function clear2(){
	$("#plant").selectOptions("");
	$("#line").selectOptions("");
	$("#fileData").html("");
	fileListCheck();
}

</script>
<div class="wrap_in" id="fixNextTag">
	<span class="path">보고서&nbsp;&nbsp;
		<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;
		<a href="#">${strUtil:getSystemName()}</a>
	</span>
	<section class="type01">
	<!-- 상세 페이지  start-->
		<h2 style="position:relative">
			<span class="title_s">Process Line</span>
			<span class="title">제조공정도</span>
			<div  class="top_btn_box">
				<div  class="top_btn_box">
					<ul><li></li></ul>
				</div>
			</div>
		</h2>
		<div class="group01">
			<div class="title"><!--span class="txt">연구개발시스템 공지사항</span--></div>
			<div class="search_box" >
				<% if( isAdmin != null && "Y".equals(isAdmin) ) { %>
				<form name="listForm" id="listForm" method="post" action="/processLine/insert" enctype="multipart/form-data">
				<ul>
					<li style=" width:100%">
						<dt>파일업로드</dt>
						<dd style=" width:900px">
							<div class="selectbox" style="width:180px;">  
							<label for="plant">공장</label> 
							<select id="plant" name="plant" onchange="changePlant()">
								<option value="">==공장==</option>
								<option value="성남">성남</option>
								<option value="시화">시화</option>
								<option value="대구">대구</option>
							</select>
							</div>
							<div class="selectbox" style="width:180px;">  
							<label for="line">라인</label> 
							<select id="line" name="line">
								<option value="">==라인==</option>
							</select>
							</div>&nbsp;
							<div class="form-group form_file" style="padding-bottom:10px;">
								<input class="form-control form_point_color01" type="text" title="첨부된 파일명" readonly="readonly" style="width:400px">
								<span class="file_load" id="fileSpan1"><input type="file" name="file" id="file1" onChange="javaScript:addFile(tmpNo)"><label class="btn-default" for="file1" style="margin-top:-1px;">파일첨부</label></span>
								<span id="upFile"></span>
							</div>
						</dd>
					</li>
					<!--  첨부된 파일리스트 start 첨부된 파일이 없을 경우 안보이게 해주세요 -->
					<li class="mb5"  style=" width:100%" id="fileList">
						<dt>파일리스트 </dt>
						<dd style=" width:900px">
							<div class="file_box_pop"style=" height:100px; width:97.5%;" >
								<ul id="fileData" style="width:100%;">
								</ul>
							</div>
						</dd>
					</li>
					<!--  첨부된 파일리스트 close 첨부된 파일이 없을 경우 안보이게 해주세요 -->
				</ul>
				</form>
				<div class="fr pt5 pb10">
					<button class="btn_con_search" onClick="javascript:clear2();"><img src="/resources/images/btn_icon_refresh.png" style="vertical-align:middle;"/> 취소</button> 
					<button class="btn_con_search" onClick="goInsert();"><img src="/resources/images/btn_icon_search.png" style="vertical-align:middle;"/> 등록</button>
				</div>
				<% } %>
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
											<div align="left">
												
												<c:if test="${userUtil:getIsAdmin(pageContext.request) == 'Y'}">
												<a href="#" onclick="fileDelete('${file.fmNo}')"><img src="/resources/images/icon_doc04.png" alt="" align="middle" /></a>
												</c:if>
												<a href="/file/fileDownload?fmNo=${file.fmNo}&tbkey=${file.tbKey}&tbType=lineProcessTree">
												<c:choose>
													<c:when test="${file.isOld == 'Y'}">
													${strUtil:getOldFileName(file.fileName) }
													</c:when>
													<c:otherwise>
													${file.orgFileName}
													</c:otherwise>
												</c:choose>
												</a>
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
