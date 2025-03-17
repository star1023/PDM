<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ page import="kr.co.aspn.util.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ page session="false" %>
<title>레포트</title>
<link rel="stylesheet" href="/resources/CLEditor/jquery.cleditor.css?param=1" />
<script type="text/javascript" src="/resources/CLEditor/jquery.cleditor.min.js?param=1"></script>
<link href="/resources/js/jquery.auto-complete.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="/resources/js/jquery.auto-complete.js"></script>
<script type="text/javascript">
var tbType = "report";
var row = "";
$(document).ready(function() {
	closeDialog('open');
	if('${reportlData.category1}' == ''){
		$(".title").show();
		$(".content").show();
		$(".prdTitle").hide();
		$(".reportDate").hide();
		$(".prdFeature").hide();
		$(".adviserPrd").hide();
		$(".bomData").hide();
		$(".imageFile").hide();
		$(".confirm").hide();
		$(".isRelease").hide();
		$(".result").hide();
		$(".developer").hide();
	} else if('${reportlData.category1}' == 1){				// 실험보고서
		$(".title").show();
		$(".content").show();
		$(".prdTitle").hide();
		$(".reportDate").hide();
		$(".prdFeature").hide();
		$(".adviserPrd").hide();
		$(".bomData").hide();
		$(".imageFile").hide();
		$(".confirm").hide();
		$(".isRelease").hide();
		$(".result").hide();
		$(".developer").hide();
	} else if('${reportlData.category1}' == 2){	// 출장보고서
		$(".title").show();
		$(".content").show();
		$(".prdTitle").hide();
		$(".reportDate").hide();
		$(".prdFeature").hide();
		$(".adviserPrd").hide();
		$(".bomData").hide();
		$(".imageFile").hide();
		$(".confirm").hide();
		$(".isRelease").hide();
		$(".result").hide();
		$(".developer").hide();
	} else if('${reportlData.category1}' == 3){	// 시장조사
		$(".title").show();
		$(".content").show();
		$(".prdTitle").hide();
		$(".reportDate").hide();
		$(".prdFeature").hide();
		$(".adviserPrd").hide();
		$(".bomData").hide();
		$(".imageFile").hide();
		$(".confirm").hide();
		$(".isRelease").hide();
		$(".result").hide();
		$(".developer").hide();
	} else if('${reportlData.category1}' == 4 || '${reportlData.category1}' == 5){	// 보고 제품, 기술고문 제품
		$(".title").hide();
		$(".content").hide();
		$(".prdTitle").show();
		$(".reportDate").show();
		$(".prdFeature").show();
		$(".adviserPrd").show();
		$("#adviserPrd").cleditor({
			width: '80%',
			height: 500
		});
		$(".bomData").hide();
		$(".imageFile").hide();
		$(".confirm").hide();
		$(".isRelease").hide();
		$(".result").hide();
		$(".developer").hide();
	} else if('${reportlData.category1}' == 6){	// 기술고문보고서
		$(".title").show();
		$(".content").show();
		$(".prdTitle").hide();
		$(".reportDate").hide();
		$(".prdFeature").hide();
		$(".adviserPrd").hide();
		$(".bomData").hide();
		$(".imageFile").hide();
		$(".confirm").hide();
		$(".isRelease").hide();
		$(".result").hide();
		$(".developer").hide();
	} else if('${reportlData.category1}' == 7){	// 기술고문보고서
		$(".title").show();
		$(".content").hide();
		$(".prdTitle").hide();
		$(".reportDate").hide();
		$(".prdFeature").show();
		$(".adviserPrd").hide();
		$(".bomData").show();
		$(".imageFile").show();
		$(".confirm").show();
		if( '${reportlData.isConfirm}' == 'Y'){
			$(".isRelease").show();	
		} else {
			$(".isRelease").hide();
		}
		$(".result").show();
		$(".developer").show();
	}
	
	//datepicker를 이용한 달력(기간) 설정
	$("#reportDate").datepicker({
		dateFormat: "yy-mm-dd",
		showOn: "button",
	    buttonImage: "/resources/images/btn_calendar.png",
	    buttonImageOnly: true
	});
	$("#ui-datepicker-div").css('font-size','0.8em');
	
	fileListCheck();
	
	var file = document.querySelector('#imageFile');

	file.onchange = function () {
		var filePath = document.getElementById("imageFile").value;
		var fileName = filePath.substring(filePath.lastIndexOf('\\') + 1,	filePath.length);
		if (fileName.length == 0) {
			document.querySelector('#preview').src = "";
			return;
		}
		var html = "";
		$("#imageUpfile").html(html);
		html += "		<a href='#' onClick='javascript:deleteImageFile(this)'><img src=\"/resources/images/icon_del_file.png\"></a>";
		html += "		"+ fileName + "";
		$("#imageUpfile").html(html);
		
		var fileList = file.files ;
	    // 읽기
	    var reader = new FileReader();
	    reader.readAsDataURL(fileList [0]);
	    //로드 한 후
	    reader.onload = function  () {
	        document.querySelector('#preview').src = reader.result ;
	    };
	};
	row += "<tr id=\"row_1_1\">";
	row += "<td><input type=\"checkbox\" id=\"rowCheck_1_1\" name=\"c2\" ><label for=\"rowCheck_1_1\"><span></span></label></td>";
	row += "<td><input type=\"text\" name=\"itemName\" id=\"itemName\" style=\"width:100%\" class=\"req\"/></td>";
	row += "<td><input type=\"text\" name=\"itemBom\" id=\"itemBom\" style=\"width:100%\" class=\"req\"/></td>";								
	row += "</tr>";
});
var PARAM = {
		
	};

function goList() {
	location.href="/report/list?"+getParam('${paramVO.pageNo}');
}

//파라미터 조회
function getParam(pageNo){
	PARAM.pageNo = pageNo || '${paramVO.pageNo}';
	return $.param(PARAM);
}

function checkboxToRadio(checkboxname, checkboxid) {
	$("input:checkbox[name='"+checkboxname+"']:checked").length
	if( $("input:checkbox[name='"+checkboxname+"']:checked").length > 1 ) {
		$("input[name='"+checkboxname+"']:checkbox").prop("checked",false);
		$("input[id='"+checkboxid+"']:checkbox").prop("checked",true);
	}
}

function fileListCheck() {
	var nodes=$("#fileData").children();
	if( nodes.length > 0 ) {
		$("#add_file2").prop("class","add_file");
		$("#fileList").show();
	} else {
		$("#add_file2").prop("class","add_file2");
		$("#fileList").hide();
	}
}

//파일 다운로드
function fileDownload(fmNo, tbkey){
	location.href="/file/fileDownload?fmNo="+fmNo+"&tbkey="+tbkey+"&tbType=report";
}

function fileListCheck() {
	var nodes=$("#fileData").children();
	if( nodes.length > 0 ) {
		$("#fileList").show();
	} else {
		$("#fileList").hide();
	}
}

var tmpNo = 1;

function addFile(fileIdx) {
	var filePath = document.getElementById("file"+fileIdx).value;
	var fileName = filePath.substring(filePath.lastIndexOf('\\') + 1,	filePath.length);
	if (fileName.length == 0) {
		alert("파일을 선택해 주십시요.");
		return;
	}
	// 파일 추가
	$("#fileSpan"+fileIdx).hide();
	var html = "";
	html += "<li id='selfile" + fileIdx 	+ "'>";
	html += "		<a href='#' onClick='javascript:deleteFile(this)'><img src=\"/resources/images/icon_del_file.png\"></a>";
	html += "		"+ fileName + "";
	html += "</li>"
	$("#fileData").append(html);
	tmpNo = ++fileIdx;
	html = "";
	html += "<span class=\"file_load\" id=\"fileSpan" + fileIdx + "\">";
	html += "<input type=\"file\" name=\"file\" id='file" + fileIdx + "' onChange=\"javaScript:addFile(tmpNo)\" style=\"display:none\"><label for=\"file" + fileIdx + "\">첨부파일 등록 <img src=\"/resources/images/icon_add_file.png\"></label>";
	html += "</span>";
	$("#upFile").append(html);
	fileListCheck();
}

function addImageFile() {
	var filePath = document.getElementById("imageFile").value;
	var fileName = filePath.substring(filePath.lastIndexOf('\\') + 1,	filePath.length);
	if (fileName.length == 0) {
		document.querySelector('#preview').src = "";
		return;
	}
	var html = "";
	$("#imageUpfile").html(html);
	html += "		<a href='#' onClick='javascript:deleteImageFile(this)'><img src=\"/resources/images/icon_del_file.png\"></a>";
	html += "		"+ fileName + "";
	$("#imageUpfile").html(html);
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

//추가 파일 삭제 함수
function deleteImageFile(e){
	$("#imageUpfile").html("");
	$("#imageFile").val("");
	return;
}

function checkboxToRadio(checkboxname, checkboxid) {
	$("input:checkbox[name='"+checkboxname+"']:checked").length
	if( $("input:checkbox[name='"+checkboxname+"']:checked").length > 1 ) {
		$("input[name='"+checkboxname+"']:checkbox").prop("checked",false);
		$("input[id='"+checkboxid+"']:checkbox").prop("checked",true);
	}
}


function goUpdate() {
	var category1 = ${reportlData.category1};
	if(  category1 == 1 || category1 == 2 || category1 == 6 ) {
		if( !chkNull($("#title").val()) ){
			alert("제목을 입력하여 주세요.");
			$("#title").focus();
			return;
		} else if( !chkNull($("#visitPurpose").val()) ){
			alert("방문목적을 입력하여 주세요.");
			$("#visitPurpose").focus();
			return;
		}  else if( !chkNull($("#visitPlace").val()) ){
			alert("방문장소를 입력하여 주세요.");
			$("#visitPlace").focus();
			return;
		}  else if( !chkNull($("#visitUser").val()) ){
			alert("참석자를 입력하여 주세요.");
			$("#visitUser").focus();
			return;
		} else if( !chkNull($("#visitTime").val()) ){
			alert("방문시간을 입력하여 주세요.");
			$("#visitTime").focus();
			return;
		} 
	} else if(  category1 == 4 || category1 == 5 ) {
		if( !chkNull($("#prdTitle").val()) ){
			alert("제품명을 입력하여 주세요.");
			$("#prdTitle").focus();
			return;
		} else if( !chkNull($("#reportDate").val()) ) {
			alert("보고일자를 지정하십시오.");
			$("#reportDate").focus();
			return;
		}
	} else if(  category1 == 7 ) {
		if( !chkNull($("#title").val()) ){
			alert("제목을 입력하여 주세요.");
			$("#title").focus();
			return;
		} else if( !chkNull($("#prdFeature").val()) ) {
			alert("제품특징을 입력하세요.");
			$("#prdFeature").focus();
			return;
		} else if( !chkNull($("#imageFile").val()) ) {
			alert("제품이미지를 등록하세요.");
			$("#imageFile").focus();
			return;
		} else if( !chkNull($("#result").val()) ) {
			aalert("보고결과를 입력하세요.");
			$("#result").focus();
			return;
		}
	} else {
		if( !chkNull($("#title").val()) ){
			alert("제목을 입력하여 주세요.");
			$("#title").focus();
			return;
		} else if( !chkNull($("#visitPurpose").val()) ){
			alert("방문목적을 입력하여 주세요.");
			$("#visitPurpose").focus();
			return;
		}  else if( !chkNull($("#visitPlace").val()) ){
			alert("방문장소를 입력하여 주세요.");
			$("#visitPlace").focus();
			return;
		}  else if( !chkNull($("#visitUser").val()) ){
			alert("참석자를 입력하여 주세요.");
			$("#visitUser").focus();
			return;
		} else if( !chkNull($("#visitTime").val()) ){
			alert("방문시간을 입력하여 주세요.");
			$("#visitTime").focus();
			return;
		} 
	}
	
	if(confirm("변경하시겠습니까?")){
		$("#updateForm").submit();    
	}
}

function goView() {
	history.back(-1);
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
				fileListCheck();
				//document.location.href="/processLine/list"
			}
		},
		error:function(request, status, errorThrown){
				alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
		}			
	}); 
}

function imageFileDelete( fmNo ) {
	var URL = "../file/deleteImageFileAjax";
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
				$("#imageFileDiv").show();
				document.querySelector('#preview').src = "";
				$("#imageUpfile").html("");
			}
		},
		error:function(request, status, errorThrown){
				alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
		}			
	}); 
}

function nvl(str, defaultStr){
    
    if(typeof str == "undefined" || str == null || str == "")
        str = defaultStr ;
     
    return str ;
}


function addRow( element ) {
	var randomId = Math.random().toString(36).substr(2, 9);
	
	$(element).parent().parent().next().children('tbody').append(row);
	$(element).parent().parent().next().children('tbody').children('tr:last').attr('id', 'row_1'+ '_' + randomId);
	$(element).parent().parent().next().children('tbody').children('tr:last').children('td').children('input[type=checkbox]').attr('id', 'rowCheck_'+randomId);
	$(element).parent().parent().next().children('tbody').children('tr:last').children('td').children('label').attr('for', 'rowCheck_'+randomId);
}

function delRow(element){
	$(element).parent().parent().next().children('tbody').children('tr').toArray().forEach(function(v, i){
		var checkBoxId = $(v).children('td:first').children('input[type=checkbox]')[0].id;
		if($('#'+checkBoxId).is(':checked')) $(v).remove();
	})
}

function checkAll() {
	if($('#check').is(':checked')) {
		//$(element).parent().parent().next().children('tbody').children('tr').toArray().forEach(function(v, i){
		$('#tbody').children('tr').toArray().forEach(function(v, i){
			var checkBoxId = $(v).children('td:first').children('input[type=checkbox]')[0].id;
			$('#'+checkBoxId).prop('checked',true);
		})
	} else {
		//$(element).parent().parent().next().children('tbody').children('tr').toArray().forEach(function(v, i){
		$('#tbody').children('tr').toArray().forEach(function(v, i){	
			var checkBoxId = $(v).children('td:first').children('input[type=checkbox]')[0].id;
			$('#'+checkBoxId).prop('checked',false);
		})
	}
}
	
function moveUp(element){
	var tbody = $(element).parent().parent().next().children('tbody');
	var checkboxArr = tbody.children('tr').children('td').children('input[type=checkbox]').toArray();
	
	var checkedCnt = 0;
	var checkedId;
	checkboxArr.forEach(function(v, i){
		if($(v).is(':checked')){
			checkedCnt++;
			checkedId = v.id
			
			var $element = $(v).parent().parent();
			$element.prev().before($element);
		}
	});
	
	//if(checkedCnt > 1) return alert('열을 이동하는 하는 경우에는 1개의 열만 선택해주세요');
	//if(checkedCnt == 0) return alert('이동시키려는 열을 선택해주세요');
	
	//var $element = $('#'+checkedId).parent().parent();
	//$element.prev().before($element);
}

function moveDown(element){
	var tbody = $(element).parent().parent().next().children('tbody');
	var checkboxArr = tbody.children('tr').children('td').children('input[type=checkbox]').toArray();
	
	var checkedCnt = 0;
	var checkedId;
	checkboxArr.reverse().forEach(function(v, i){
		if($(v).is(':checked')){
			//checkedCnt++;
			//checkedId = v.id
			var $element = $(v).parent().parent();
			$element.next().after($element);
		}
	});
	
	//if(checkedCnt > 1) return alert('열을 이동하는 하는 경우에는 1개의 열만 선택해주세요');
	//if(checkedCnt == 0) return alert('이동시키려는 열을 선택해주세요');
	
	//var $element = $('#'+checkedId).parent().parent();
	//$element.next().after($element);
}

function loadRelease() {
	if ($("input[id='isConfirm']:checkbox").is(':checked') ) {
		$(".isRelease").show();
	} else {
		$("input[id='isRelease']:checkbox").prop("checked",false);
		$(".isRelease").hide();
	}
}
</script>
<title>레포트</title>
<link rel="stylesheet" href="/resources/CLEditor/jquery.cleditor.css?param=1" />
<script type="text/javascript" src="/resources/CLEditor/jquery.cleditor.min.js?param=1"></script>
<form name="updateForm" id="updateForm" action="/report/update" method="post" enctype="multipart/form-data">
<input type="hidden" name="rNo" id="rNo" value="${reportlData.reportKey}"/>
<input type="hidden" name="category1" id="category1" value="${reportlData.category1}"/>
<input type="hidden" name="apprNo" id="apprNo" value="${reportlData.apprNo}"/>
<div class="wrap_in" id="fixNextTag">
	<span class="path">보고서&nbsp;&nbsp;<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;게시판&nbsp;&nbsp;<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;<a href="#">삼립식품 연구개발시스템</a></span>
	<section class="type01">
		<h2 style="position:relative"><span class="title_s">Report Update</span>
			<span class="title">보고서 수정</span>
			<div  class="top_btn_box">
				<ul>
					<li>
						<button class="btn_circle_nomal" onClick="location.href='main.html'">&nbsp;</button>
					</li>
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
					<li class="title">
						<dt>제목</dt>
						<dd class="pr20 pb10">
							<input type="text" name="title" id="title" value="${reportlData.title}" style="width:70%;"/>
						</dd>
					</li>
					<li class="content">
						<dt>메모</dt>
						<dd class="pr20 pb10">
							<textarea id="content" name="content" style="width:100%; height:180px">${reportlData.content}</textarea>
						</dd>
					</li>
					<li class="content">
						<dt>방문목적</dt>
						<dd class="pr20 pb10">
							<textarea id="visitPurpose" name="visitPurpose" style="width:97.5%; height:60px"></textarea>
						</dd>
					</li>
					<li class="content">
						<dt>방문장소</dt>
						<dd class="pr20 pb10">
							<textarea id="visitPlace" name="visitPlace" style="width:97.5%; height:60px"></textarea>
						</dd>
					</li>
					<li class="content">
						<dt>참석자</dt>
						<dd class="pr20 pb10">
							<input type="text" name="visitUser" id="visitUser" placeholder="참석자를 입력해주세요." style="width:70%;"/>
						</dd>
					</li>
					<li class="content">
						<dt>방문시간</dt>
						<dd class="pr20 pb10">
							<input type="text" name="visitTime" id="visitTime" placeholder="방문시간을 입력해주세요." style="width:70%;"/>
						</dd>
					</li>
					<li class="prdTitle">
						<dt>제품명</dt>
						<dd class="pr20 pb10">
							<input type="text" name="prdTitle" id="prdTitle" value="${reportlData.prdTitle}" style="width:70%;"/>
						</dd>
					</li>
					<li class="reportDate">
						<dt>보고일자</dt>
						<dd class="pr20 pb10">
							<input type="text" name="reportDate" id="reportDate" value="${reportlData.reportDate}" style="width:20%;" readonly/>
						</dd>
					</li>
					<li class="prdFeature">
						<dt>제품특징</dt>
						<dd class="pr20 pb10">
							<textarea id="prdFeature" name="prdFeature" style="width:100%; height:60px">${reportlData.prdFeature}</textarea>
						</dd>
					</li>
					<li class="adviserPrd">
						<dt>제조방법
							<c:if test="${tempFile.fileName != null && tempFile.fileName != '' }">
								<br/><br/><br/>
								<a href="/file/fileDownload?fmNo=${tempFile.fmNo}&tbkey=${tempFile.tbKey}&tbType=report"><img src="/resources/images/icon_file01.png" style="vertical-align:middle;"/>
								<c:choose>
									<c:when test="${tempFile.isOld == 'Y'}">
										${strUtil:getOldFileName(tempFile.fileName) }
									</c:when>
									<c:otherwise>
										${tempFile.orgFileName}
									</c:otherwise>
								</c:choose>
								</a>
							</c:if>	
						</dt>
						<dd class="pr20 pb10">
							<textarea id="adviserPrd" name="adviserPrd" style="width:100%; height:60px">${reportlData.adviserPrd}</textarea>
						</dd>
					</li>
					<li class="bomData">
						<dt>배합비</dt>
						<dd>
							<div class="table_header07" style="width:98%;">
				 				<span class="table_order_btn">
				 					<input type="button" class="btn_up" onclick="moveUp(this)">
				 					<input type="button" class="btn_down" onclick="moveDown(this)">
				 				</span>
								<span class="table_header_btn_box">
									<input type="button" class="btn_add_tr" onClick="addRow(this);">
									<input type="button" class="btn_del_tr" onClick="delRow(this);">
								</span>
							</div>
							<table class="tbl05" style="width:98%;">
								<colgroup>
									<col width="5%">
									<col width="20%">
									<col />
								</colgroup>
								<thead>
									<tr>
										<th><input type="checkbox" id="check" name="check" onChange="javascript:checkAll();"><label for="check"><span></span></label></th>
										<th>원료명</th>
										<th>배합비</th>
									</tr>
								</thead>
								<tbody id="tbody">
								<c:choose>
								<c:when test="${fn:length(bomList) > 0 }">
								<c:forEach items="${bomList}" var="bom" varStatus="status">
									<tr id="row_1_1">
										<td><input type="checkbox" id="rowCheck_1_${status.count}" name="c2" ><label for="rowCheck_1_${status.count}"><span></span></label></td>
										<td><input type="text" name="itemName" id="itemName" style="width:100%" class="req" value="${bom.name}"/></td>
										<td><input type="text" name="itemBom" id="itemBom" style="width:100%" class="req" value="${bom.bom}"/></td>										
									</tr>
								</c:forEach>
								</c:when>		
								<c:otherwise>
									<tr id="row_1_1">
										<td><input type="checkbox" id="rowCheck_1_1" name="c2" ><label for="rowCheck_1_1"><span></span></label></td>
										<td><input type="text" name="itemName" id="itemName" style="width:100%" class="req"/></td>
										<td><input type="text" name="itemBom" id="itemBom" style="width:100%" class="req"/></td>										
									</tr>	
								</c:otherwise>	
								</c:choose>							
								</tbody>
							</table>
						</dd>
					</li>
					<li  class="imageFile">
						<dt>제품이미지</dt>
						<dd>
							<span id="imageUpfile">
								<c:choose>
								<c:when test="${fn:length(imageFileList) > 0}">
									<c:forEach items="${imageFileList}" var="image">
									<a href="#" onClick="imageFileDelete('${image.fmNo}')"><img src="/resources/images/icon_doc04.png" style="vertical-align:middle;"/></a>
									${image.orgFileName}
									</c:forEach>
								</c:when>
								<c:otherwise>
									&nbsp;
								</c:otherwise>
								</c:choose>
							</span>
							<br/>
							<c:choose>
								<c:when test="${fn:length(imageFileList) > 0}">
									<c:forEach items="${imageFileList}" var="image">
									<!--img id="preview" src="${item.path}/${item.fileName}" width="300px"><br/-->
									<img id="preview" src="/uploaded/images/201911/${image.fileName}" width="300px"><br/>
									</c:forEach>
								</c:when>
								<c:otherwise>
									<img id="preview" src="" width="300px" alt="미리보기"><br/>
								</c:otherwise>							
							</c:choose>
							<div class="add_file2" id="imageFileDiv" <c:choose><c:when test='${fn:length(imageFileList) > 0}'>style="width:17%; display:none"</c:when><c:otherwise>style="width:17%;"</c:otherwise></c:choose> >
							<span class="file_load">
								<input type="file" name="file" id="imageFile" accept="image/*" style="display:none"><label for="imageFile">제품이미지 등록 <img src="/resources/images/icon_add_file.png"></label>
							</span>
							</div>
						</dd>
					</li>
					<li class="confirm">
						<dt>컨펌완료</dt>
						<dd>
							<input type="checkbox" id="isConfirm" name="isConfirm" value="Y" onClick="checkboxToRadio('isConfirm','isConfirm');loadRelease()" <c:if test="${reportlData.isConfirm == 'Y' }">checked</c:if>><label for="isConfirm"><span></span>승인</label>
							<input type="checkbox" id="isDelay" name="isConfirm" value="D" onClick="checkboxToRadio('isConfirm','isDelay');loadRelease()" <c:if test="${reportlData.isConfirm == 'D' }">checked</c:if>><label for="isDelay"><span></span>보류</label>
							<input type="checkbox" id="noConfirm" name="isConfirm" value="N" onClick="checkboxToRadio('isConfirm','noConfirm');loadRelease()" <c:if test="${reportlData.isConfirm == 'N' }">checked</c:if>><label for="noConfirm"><span></span>미승인</label>
						</dd>
					</li>
					<li class="isRelease" <c:if test="${reportlData.isConfirm != 'Y' }">style='display:none'</c:if>>
						<dt>출시여부</dt>
						<dd>
							<input type="checkbox" id="isRelease" name="isRelease" value="Y" <c:if test="${reportlData.isRelease == 'Y' }">checked</c:if>><label for="isRelease"><span></span>출시</label>							
						</dd>
					</li>
					<li class="result">
						<dt>보고결과</dt>
						<dd>
							<textarea id="result" name="result" style="width:97.5%; height:55px">${reportlData.result}</textarea>							
						</dd>
					</li>
					<!--
					<li class="apprvalTr">
						<dt>결재자</dt>
						<dd class="pr20 pb10">
							<span id="apprUserName"></span>
							<select name="apprUser" id="apprUser"  style="display:none" multiple>
							</select>
							<a href="#open" onClick="javascript:openAppr();" rel="modal:open">결재선지정</a>
						</dd>
					</li>
					<li class="apprvalTr">
						<dt>참조자</dt>
						<dd class="pr20 pb10">
							<span id="refUserName">
							<c:if test="${fn:length(apprList) > 0}">
								<c:forEach items="${apprList}" var="apprList">
								</c:forEach>
							</c:if>
							</span>
							<select name="refUser" id="refUser"  style="display:none" multiple>
							</select>
							<input type="hidden" name="apprTitle">
							<input type="hidden" name="apprComment">
						</dd>
					</li>
					<li class="apprvalTr">
						<dt>회람</dt>
						<dd class="pr20 pb10">
							<span id="circUserName"></span>
							<select name="circUser" id="circUser"  style="display:none" multiple>
							</select>
						</dd>
					</li>
					-->
					<li>
						<dt>파일 첨부</dt>
						<dd>
							<div class="add_file2" id="add_file2" style="width:97.5%">
								<span class="file_load" id="fileSpan1">
									<input type="file" name="file" id="file1" onChange="javaScript:addFile(tmpNo)" style="display:none"><label for="file1">첨부파일 등록 <img src="/resources/images/icon_add_file.png"></label>
								</span>
								<span id="upFile"></span>
							</div>
							<div class="file_box_pop" style=" height:85px; width:97.5%; border-top-left-radius:0px;border-top-right-radius:0px; border-top:1px solid #ddd;box-sizing:border-box;" id="fileList">
								<ul id="fileData">
									<c:forEach items="${fileList}" var="fileList" varStatus="status">
										<li id="selfile${status.index}">
										<a href="#" onClick="fileDelete('${fileList.fmNo}','${status.index}')"><img src="/resources/images/icon_doc04.png" style="vertical-align:middle;"/></a>
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
							<!--div class="form-group form_file" style="padding-bottom:10px;">
								<input class="form-control form_point_color01" type="text" title="첨부된 파일명" readonly="readonly" style="width:400px">
								<span class="file_load" id="fileSpan1"><input type="file" name="file" id="file1" onChange="javaScript:addFile(tmpNo)"><label class="btn-default" for="file1" style="margin-top:-1px;">파일첨부</label></span>
								<span id="upFile"></span>
							</div-->
						</dd>
					</li>
					<!--li>
						<dt>파일 첨부</dt>
						<dd>
							<div class="form-group form_file" style="padding-bottom:10px;">
								<input class="form-control form_point_color01" type="text" title="첨부된 파일명" readonly="readonly" style="width:400px">
								<span class="file_load" id="fileSpan1"><input type="file" name="file" id="file1" onChange="javaScript:addFile(tmpNo)"><label class="btn-default" for="file1" style="margin-top:-1px;">파일첨부</label></span>
								<span id="upFile"></span>
							</div>
						</dd>
					</li-->
					<!--  첨부된 파일리스트 start 첨부된 파일이 없을 경우 안보이게 해주세요 -->
				<!--	
				<c:choose>
					<c:when test="${fn:length(fileList) > 0}">
					<li class="mb5" id="fileList">
						<dt>파일리스트 </dt>
						<dd>
							<div class="file_box_pop"style=" height:100px; width:97.5%;" >
							<ul id="fileData">
							<c:forEach items="${fileList}" var="fileList" varStatus="status">
								<li id="currentFile${status.index}">
								<a href="#" onClick="fileDelete('${fileList.fmNo}','${status.index}')"><img src="/resources/images/icon_doc04.png" style="vertical-align:middle;"/></a>
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
					</c:when>
					<c:otherwise>
					<li class="mb5" id="fileList">
						<dt>파일리스트 </dt>
						<dd>
							<div class="file_box_pop"style=" height:100px; width:97.5%;" >
								<ul id="fileData">
								</ul>
							</div>
						</dd>
					</li>
					</c:otherwise>	
				</c:choose>	
				-->				
					<!--  첨부된 파일리스트 close 첨부된 파일이 없을 경우 안보이게 해주세요 -->
				</ul>
			</div>
			<div class="btn_box_con5">
			</div>
			<div class="btn_box_con4"> 
				<!--input type='button' value="상신" class="btn_admin_red" id="request" onclick="javascript:goUpdate();"-->
				<input type='button' value="저장" class="btn_admin_sky" id="save" onclick="javascript:goUpdate();">
				<input type='button' value="취소" class="btn_admin_gray" id="cancel" onclick="javascript:goView();">
			</div>
		</div>
	</section>	
</div>
</form>
<!-- 디자인의뢰서 결재 레이어 start-->
<!-- 신규로 레이어창을 생성하고싶을때는  아이디값 교체-->
<!-- 클래스 옆에 적힌 스타일 값을 인라인으로 작성해서 팝업 사이즈를 직접 조정 -->
<div class="white_content" id="open">
	<div class="modal" style="	margin-left:-530px;width:1000px;height: 520px;margin-top:-230px">
		<h5 style="position:relative">
			<span class="title">레포트 결재 상신</span>
			<div  class="top_btn_box">
				<ul><li><button class="btn_madal_close" onClick="closeDialog('open');"></button></li></ul>
			</div>
		</h5>
		<div class="list_detail">
			<ul>
				<li class="pt10">
					<dt style="width:20%">제목</dt>
					<dd style="width:80%">
						<input type="text" id="apprTitle" class="req" style="width:573px">
					</dd>
				</li>
				<li>
					<dt style="width:20%">요청사유</dt>
					<dd style="width:80%;">
						<textarea style="width:573px; height:50px" id="apprComment" placeholder="요청사유를 입력하세요"></textarea>
					</dd>
				</li>
				<li>
					<dt style="width:20%">결재자 입력</dt>
					<dd style="width:80%;" class="ppp">
						<input type="text" placeholder="결재자명 2자이상 입력후 선택" style="width:340px; float:left;" class="req" name="searchUser" id="searchUser">
						<input type="hidden" name="selectUserId" id="selectUserId">
						<input type="hidden" name="selectUserInfo" id="selectUserInfo">
						<button class="btn_small01 ml5" onClick="addApprList('1')">1차결재자로 추가</button>
						<button class="btn_small02  ml5" onClick="addRefList('R')">참조</button>
						<button class="btn_small02  ml5" onClick="addRefList('C')">회람</button>
						<div class="selectbox ml5" style="width:200px;">
							<label for="apprLine">---- 결재선 불러오기 ----</label>
							<select id="apprLine" name="apprLine" onChange="getApprItem();">
							</select>
						</div>
					</dd>
				</li>
				<li  class="mt5">
					<dt style="width:20%; background-image:none;" ></dt>
					<dd style="width:80%;">
						<div class="file_box_pop2" >
							<ul id="apprList">
								<li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="s01"> 기안자</span> <%=UserUtil.getUserName(request)%><strong> <%=UserUtil.getUserGradeName(request)%>/<%=UserUtil.getDeptCode(request)%></strong></li>								
								<li id="apprList1"></li>
							</ul>
						</div>
						<div class="file_box_pop3" >
							<ul id="refList">
							</ul>
						</div>
						<!-- 현재 추가된 결재선 저장 버튼을 누르면 안보이게 처리 start -->
						<!--div class="app_line_edit">
							<button class="btn_doc"><img src="/resources/images/icon_doc11.png"> 현재 추가된 결재선 저장</button>  |  
							<button class="btn_doc"><img src="/resources/images/icon_doc04.png"> 현재 표시된 결재선 삭제</button>
						</div-->	
						<!-- 현재 추가된 결재선 저장 버튼을 누르면 안보이게 처리 close -->
						<!-- 현재 추가된 결재선 저장 버튼 눌렀을때 보이게 처리 start -->
						<div class="app_line_edit">저장 결재선명 입력 :  
							<input type="text" name="lineName" id="lineName" class="req" style="width:280px;"/> 
							<button class="btn_doc" onClick="insertApprLine();"><img src="/resources/images/icon_doc11.png"> 저장</button> |  
							<button class="btn_doc" onClick="deleteApprLine()"><img src="/resources/images/icon_doc04.png">삭제</button>
						</div>
						<!-- 현재 추가된 결재선 저장 버튼 눌렀을때 보이게 처리 close -->
					</dd>	
				</li>
			</ul>
		</div>
		<div class="btn_box_con4" style="padding:15px 0 20px 0">
			<button class="btn_admin_red" onClick="javascript:addApprUser();">결재상신</button> 
			<button class="btn_admin_gray" onClick="closeDialog('open');">상신 취소</button>
		</div>
	</div>
</div>
<!-- 디자인의뢰서 결재 레이어 생성레이어 close-->