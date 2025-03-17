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
	if('${reportlData.category1}' == 4 || '${reportlData.category1}' == 5){	// 보고 제품, 기술고문 제품
		$("#adviserPrd").cleditor({
			width: '80%',
			height: 500
		});
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
	
	if( '${reportlData.category1}' == '7') {
		var file = document.querySelector('#imageFile');
	
		file.onchange = function () {
			var filePath = document.getElementById("imageFile").value;
			var fileName = filePath.substring(filePath.lastIndexOf('\\') + 1,	filePath.length);
			if (fileName.length == 0) {
				document.querySelector('#preview').src = "/resources/images/img_noimg3.png";
				return;
			}
			var fileList = file.files ;
		    // 읽기
		    var reader = new FileReader();
		    reader.readAsDataURL(fileList [0]);
		    //로드 한 후
		    reader.onload = function  () {
		        var tempImage = new Image(); //drawImage 메서드에 넣기 위해 이미지 객체화
	        	tempImage.src = reader.result; //data-uri를 이미지 객체에 주입
	        	tempImage.onload = function () {
	                //리사이즈를 위해 캔버스 객체 생성
	                var canvas = document.createElement('canvas');
	                var canvasContext = canvas.getContext("2d");
	
	                //캔버스 크기 설정
	                canvas.width = 258; //가로 100px
	                canvas.height = 193; //세로 100px
	
	                //이미지를 캔버스에 그리기
	                canvasContext.drawImage(this, 0, 0, 258, 193);
	
	                //캔버스에 그린 이미지를 다시 data-uri 형태로 변환
	                var dataURI = canvas.toDataURL("image/jpeg");
	
	                //썸네일 이미지 보여주기
	                document.querySelector('#preview').src = dataURI;
	
	                //썸네일 이미지를 다운로드할 수 있도록 링크 설정
	                //document.querySelector('#download').href = dataURI;
	            };
		    };
		};
		row += "<tr id=\"row_1_1\">";
		row += "<td><input type=\"checkbox\" id=\"rowCheck_1_1\" name=\"c2\" ><label for=\"rowCheck_1_1\"><span></span></label></td>";
		row += "<td><input type=\"text\" name=\"itemName\" id=\"itemName\" style=\"width:80%\"/></td>";
		row += "<td><input type=\"text\" name=\"itemBom\" id=\"itemBom\" style=\"width:80%\" onkeyup=\"calcBomSum(this)\"/></td>";								
		row += "</tr>";
	}
	
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

function checkboxToRadio(checkboxname, checkboxid) {
	$("input:checkbox[name='"+checkboxname+"']:checked").length
	if( $("input:checkbox[name='"+checkboxname+"']:checked").length > 1 ) {
		$("input[name='"+checkboxname+"']:checkbox").prop("checked",false);
		$("input[id='"+checkboxid+"']:checkbox").prop("checked",true);
	}
}


function goUpdate() {
	var category1 = ${reportlData.category1};
	var isBreak = false;
	if(  category1 == 2 || category1 == 3 ) {
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
	} else if(  category1 == 4 ) {
		if( !chkNull($("#prdTitle").val()) ){
			alert("제품명을 입력하여 주세요.");
			$("#prdTitle").focus();
			return;
		} else if( !chkNull($("#reportDate").val()) ) {
			alert("보고일자를 지정하십시오.");
			$("#reportDate").focus();
			return;
		}
	} else if(  category1 == 5 ) {
		if( !chkNull($("#title").val()) ){
			alert("보고서명을 입력하여 주세요.");
			$("#title").focus();
			return;
		} else if( !chkNull($("#prdFeature").val()) ) {
			alert("제품특징을 입력하세요.");
			$("#prdFeature").focus();
			return;
		} else if( $('#preview').prop("src").indexOf($("#imageFileTemp").val()) == -1 ) {
			if( !chkNull($("#imageFile").val()) ) {
				alert("제품이미지를 등록하세요.");
				$("#imageFile").focus();
				return;
			}
		} else if( !chkNull($("#result").val()) ) {
			aalert("보고결과를 입력하세요.");
			$("#result").focus();
			return;
		} else {
			
			$("#tbody").children('tr').toArray().some(function(tr){
				var itemName = $(tr).children('td').children('input[name=itemName]').val();
				var itemBom = $(tr).children('td').children('input[name=itemBom]').val();
				
				if( !chkNull(itemName) || !chkNull(itemBom) ) {
					if( chkNull(itemName) ) {
						if( !chkNull(itemBom) ) {
							alert("배합비를 입력하세요.");
							isBreak = true;
							return true;
						}
					} else if( chkNull(itemBom) ) {
						if( !chkNull(itemName) ) {
							alert("원료명을 입력하세요.");
							isBreak = true;
							return true;
						}
					}
				}
			});
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
	if( !isBreak ) {
		if(confirm("변경하시겠습니까?")){
			$("#updateForm").submit();    
		}
	}
}

function goView() {
	history.back(-1);
}

function fileDelete( fmNo, index ) {
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
				var fileSpanId = "selfile"+index;
				$("#"+fileSpanId).remove();
				fileListCheck();
			}
		},
		error:function(request, status, errorThrown){
				alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
		}			
	});  
}
/*
function deleteImageFile( fmNo ) {
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
				if( !chkNull($("#imageFile").val()) ) {
					document.querySelector('#preview').src = "/resources/images/img_noimg3.png";	
				}
				$("#imageFile").val("");
			}
		},
		error:function(request, status, errorThrown){
				alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
		}			
	}); 
}
*/
//추가 파일 삭제 함수
function deleteImageFile(){
	if( !chkNull($("#imageFile").val()) ) {
		document.querySelector('#preview').src = "/resources/images/img_noimg3.png";	
	}
	$("#imageFile").val("");
	return;
}

function nvl(str, defaultStr){
    
    if(typeof str == "undefined" || str == null || str == "")
        str = defaultStr ;
     
    return str ;
}


function addRow( element ) {
	var randomId = Math.random().toString(36).substr(2, 9);
	
	$(element).parent().parent().next().children('tbody:last').append(row);
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
		$("#li_isRelease").show();
	} else {
		$("input[id='isRelease']:checkbox").prop("checked",false);
		$("#li_isRelease").hide();
	}
}

function calcBomSum(element){
	clearNoNum(element);
	var bomTotal = 0;
	$(element).parent().parent().parent().children('tr').toArray().forEach(function(tr){
		var itemBom = $(tr).children('td').children('input[name=itemBom]').val();
		if( chkNull(itemBom) ) {
			bomTotal += parseFloat(itemBom);
		}
	})	
	$("#bomTotal").val(bomTotal);
}

function clearNoNum(obj){
	var needToSet = false;
	var numStr = obj.value;
	var temps = numStr.split("."); //소수점 체크를 위해 입력값을 '.'을 기준으로 나누고 temps는 배열이됨
	var CaretPos = doGetCaretPosition(obj); //input field에서의 캐럿의 위치를 확인
	if(2 < temps.length){ //배열 사이즈가 2보다 크면, '.' 가 두개 이상인 경우임.
		var tempIdx = 0;
		numStr = "";
		for(i=0;i<temps.length;i++) {
			numStr += temps[i];   //최종 문자에 현재 스트링을 합한다.
		}
		needToSet = true;
		alert("소수점은 두개이상 입력 하시면 안됩니다.");
	} 
	if((/[^\d.]/g).test(numStr)) {  //숫자 '.'  이외 엔 없는지 확인 후 있으면 replace
		numStr = numStr.replace(/[^\d.]/g,"");
		CaretPos--;
		alert("입력은 숫자와 소수점 만 가능 합니다.");('.')
		needToSet = true;
	} 
	if ((/^\./g).test(numStr)){ //첫번째가 '.' 이면 .를 삭제
		numStr = numStr.replace(/^\./g, "");
		alert("소수점이 첫 글자이면 안됩니다.");
		needToSet = true;
	}
	if(needToSet) { //변경이 필요할 경우에만 셋팅함.
		obj.value = numStr;
		setCaretPosition(obj, CaretPos)
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
			<div class="tab02">
				<ul>
				<!-- 선택됬을경우는 탭 클래스에 select를 넣어주세요 -->
				<!-- 내 제품설계서 같은경우는 change select 이렇게 change 그대로 두고 한칸 띄고 select 삽입 -->
				<a href="#"><li class="change select">${reportlData.category1Name}</li></a>
				</ul>
			</div>
			<div class="list_detail">
				<c:choose>
				<c:when test="${reportlData.category1 == '2'|| reportlData.category1 == '3'}">
				<ul style="border-top:none;">
					<li class="pt10">
						<dt>보고서명</dt>
						<dd class="pr20 pb10">
							<input type="text" name="title" id="title" value="${reportlData.title}" style="width:70%;"/>
						</dd>
					</li>
					<c:choose>
					<c:when test="${reportlData.isOld != null && reportlData.isOld == 'Y'}">
					<li class="mb5">
						<dt>메모</dt>
						<dd class="pr20 pb10">
							<textarea id="content" name="content" style="width:100%; height:180px">${reportlData.content}</textarea>
						</dd>
					</li>
					</c:when>
					<c:otherwise>
					<li class="mb5">
						<dt>방문목적</dt>
						<dd class="pr20" style="line-height:0px;">
							<textarea id="visitPurpose" name="visitPurpose" style="width:100%; height:100px; box-shadow:none; border:1px solid #c5c5c5; border-bottom:1px solid #ebebeb; border-bottom-left-radius:0px; border-bottom-right-radius:0px;resize: none;">${reportlData.visitPurpose}</textarea>
						</dd>
						<dt>방문장소</dt>
						<dd class="pr20" style="line-height:0px;">
							<textarea id="visitPlace" name="visitPlace" style="width:100%; height:100px; box-shadow:none; border:1px solid #c5c5c5;border-top:none;  border-bottom:1px solid #ebebeb; border-radius:0px;resize: none;">${reportlData.visitPlace}</textarea>
						</dd>
						<dt>참석자</dt>
						<dd class="pr20" style="line-height:0px;">
							<input type="text" name="visitUser" id="visitUser" style="width:100%; height:35px; border:1px solid #c5c5c5;border-top:none;  border-bottom:1px solid #ebebeb; border-radius:0px;" value="${reportlData.visitUser}">
						</dd>
						<dt>방문시간</dt>
						<dd class="pr20" style="line-height:0px;">
							<input type="text" name="visitTime" id="visitTime" style="width:100%; height:35px; border:1px solid #c5c5c5;border-top:none;  border-top-left-radius:0px; border-top-right-radius:0px;" value="${reportlData.visitTime}">
						</dd>
					</li>
					<li class=" mb5">
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
					</c:otherwise>
					</c:choose>
				</ul>
				</c:when>
				<c:when test="${reportlData.category1 == '4' }">
				<ul style="border-top:none;">
					<li class="pt10" style="padding-bottom:10px">
						<dt>제품명 및 보고날짜</dt>
						<dd class="pr20">
							<input type="text" name="prdTitle" id="prdTitle" value="${reportlData.prdTitle}" style="width:50%;" placeholder="제품명을 입력해주세요."/> 
							<input type="text" name="reportDate" id="reportDate" value="${reportlData.reportDate}" style="width:110px;" placeholder="보고날짜선택" readonly/>
						</dd>
					</li>
					<li class="mb5">
						<dt>제품특징</dt>
						<dd class="pr20" style="line-height:0px;">
							<textarea id="prdFeature" name="prdFeature" style="width:100%; height:70px;resize: none;">${reportlData.prdFeature}</textarea>
						</dd>
					</li>
					<li class="mb5 s_down">
						<dt>
							제조방법
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
						<dd class="pr20" style="line-height:0px;">
							<textarea id="adviserPrd" name="adviserPrd" style="width:100%; height:300px;resize: none;">${reportlData.adviserPrd}</textarea>
						</dd>
					</li>
					<li class=" mb5">
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
				</ul>
				</c:when>
				<c:when test="${reportlData.category1 == '5' }">
				<ul style="border-top:none;">
					<li class="pt10" style="padding-bottom:10px">
						<dt>보고서명</dt>
						<dd class="pr20">
							<input type="text" name="title" id="title" value="${reportlData.title}" style="width:60%;" placeholder="제목을 입력해주세요."/>&nbsp;&nbsp;
							<input type="checkbox" id="isConfirm" name="isConfirm" value="Y" onClick="checkboxToRadio('isConfirm','isConfirm');loadRelease()" <c:if test="${reportlData.isConfirm == 'Y' }">checked</c:if>><label for="isConfirm"><span></span>승인</label>
							<input type="checkbox" id="isDelay" name="isConfirm" value="D" onClick="checkboxToRadio('isConfirm','isDelay');loadRelease()" <c:if test="${reportlData.isConfirm == 'D' }">checked</c:if>><label for="isDelay"><span></span>보류</label>
							<input type="checkbox" id="noConfirm" name="isConfirm" value="N" onClick="checkboxToRadio('isConfirm','noConfirm');loadRelease()" <c:if test="${reportlData.isConfirm == 'N' }">checked</c:if>><label for="noConfirm"><span></span>미승인</label>
						</dd>
					</li>
					<li id="li_isRelease" style="padding-bottom:10px">
						<dt>제품 출시여부</dt>
						<dd class="pr20">
							<input type="checkbox" id="isRelease" name="isRelease" value="Y" <c:if test="${reportlData.isRelease == 'Y' }">checked</c:if>><label for="isRelease"><span></span>출시</label>
						</dd>
					</li>
					<li class="mb5">
						<dt>제품특징</dt>
						<dd class="pr20" style="line-height:0px;">
							<textarea id="prdFeature" name="prdFeature" style="width:100%; height:70px;resize: none;">${reportlData.prdFeature}</textarea>
						</dd>
					</li>
					<li class="mb5">
						<dt>보고결과</dt>
						<dd class="pr20" style="line-height:0px;">
							<textarea id="result" name="result" style="width:100%; height:70px;resize: none;">${reportlData.result}</textarea>
						</dd>
					</li>
					<li class="mb5 s_down pt10" id="li_bomData">
						<dt>배합비</dt>
						<dd class="pr20">
							<table style="width:100%;"> 
								<tr>
									<td style="vertical-align:top">
										<div class="table_header07" style="border-top:1px solid #cccccc;">
										  	<span class="table_order_btn">
										  		<button type="button" class="btn_up" onclick="moveUp(this)"></button>
				 								<button type="button" class="btn_down" onclick="moveDown(this)"></button>
										  	</span>
											<span class="table_header_btn_box">
												<button type="button" class="btn_add_tr" onClick="addRow(this);"></button>
												<button type="button" class="btn_del_tr" onClick="delRow(this);"></button>
											</span>
										</div>
										<table class="tbl05 insert_sp ">
											<colgroup>
												<col width="20">
												<col width="60%">
												<col />
											</colgroup>
											<thead>
												<tr>
													<th>
														<input type="checkbox" id="check" name="check" onChange="javascript:checkAll();"><label for="check"><span></span></label>
													</th>
													<th>원료명</th>
													<th>배합비</th>
												</tr>
											</thead>
											<tbody id="tbody">
											<c:choose>
											<c:when test="${fn:length(bomList) > 0 }">
											<c:forEach items="${bomList}" var="bom" varStatus="status">
												<tr id="row_1_${status.count}">
													<td><input type="checkbox" id="rowCheck_1_${status.count}" name="c2" ><label for="rowCheck_1_${status.count}"><span></span></label></td>
													<td><input type="text" name="itemName" id="itemName" style="width:80%" value="${bom.name}"/></td>
													<td><input type="text" name="itemBom" id="itemBom" style="width:80%" value="${bom.bom}" onkeyup="calcBomSum(this)"/></td>										
												</tr>
												<c:set var= "sum" value="${sum + bom.bom}"/>
											</c:forEach>
											</c:when>		
											<c:otherwise>
												<tr id="row_1_1">
													<td><input type="checkbox" id="rowCheck_1_1" name="c2" ><label for="rowCheck_1_1"><span></span></label></td>
													<td><input type="text" name="itemName" id="itemName" style="width:80%"/></td>
													<td><input type="text" name="itemBom" id="itemBom" style="width:80%" onkeyup="calcBomSum(this)"/></td>										
												</tr>
												<tr id="row_1_2">
													<td><input type="checkbox" id="rowCheck_1_2" name="c2" ><label for="rowCheck_1_2"><span></span></label></td>
													<td><input type="text" name="itemName" id="itemName" style="width:80%"/></td>
													<td><input type="text" name="itemBom" id="itemBom" style="width:80%" onkeyup="calcBomSum(this)"/></td>										
												</tr>
												<tr id="row_1_3">
													<td><input type="checkbox" id="rowCheck_1_3" name="c2" ><label for="rowCheck_1_3"><span></span></label></td>
													<td><input type="text" name="itemName" id="itemName" style="width:80%"/></td>
													<td><input type="text" name="itemBom" id="itemBom" style="width:80%" onkeyup="calcBomSum(this)"/></td>										
												</tr>
											</c:otherwise>	
											</c:choose>	
											</tbody>
											<tfoot>
												<tr>
													<td><label for="c1"><span></span></label></td>
													<td>합계</td>
													<td><input type="text" name="bomTotal" id="bomTotal" style="width:80%"readonly="readonly" class="read_only" value="${sum}"/></td>
												</tr>											
											</tfoot>
										</table>
									</td>
									<td style="width:20px"></td>
									<!-- 이미지 첨부 start-->
									<td style=" width:260px; vertical-align:top; position:relative">
										<c:choose>
										<c:when test="${fn:length(imageFileList) > 0}">
											<c:forEach items="${imageFileList}" var="image">
											<p><img id="preview" src="/uploaded/images/201911/${image.fileName}" style="border:1px solid #e1e1e1; border-radius:5px; width:258px; height:193px;"></p>
											<c:set var= "fmNo" value="${image.fmNo}"/>
											<input type="hidden" name="imageFileTemp" id="imageFileTemp" value="${image.fileName}">
											</c:forEach>
										</c:when>
										<c:otherwise>
											<p><img id="preview" src="/resources/images/img_noimg3.png" style="border:1px solid #e1e1e1; border-radius:5px; width:258px; height:193px;"></p>
										</c:otherwise>
										</c:choose>
										<p class="pt10">
										<div class="add_file2" style="width:100%" >
											<input type="file" name="file" id="imageFile" accept="image/*" style="display:none"><label for="imageFile">이미지파일 등록 <img src="/resources/images/icon_add_file.png"></label>
										</div>	
										</p>
										<div style=" z-index:3; position:absolute;right:-6px; top:-8px;"><a href="javascript:deleteImageFile()"><img src="/resources/images/btn_table_header01_del02.png"></a></div>
									</td>
									<!-- 첨부됬을때 이미지 파일명은 보이지 않아요. 꼭 보고싶다면 롤오버시에 보여주는 정도로 처리 해주세요. -->
									<!-- 이미지 첨부 close-->
								</tr>
							</table>
						</dd>						
					</li>
					<li class=" mb5">
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
						</dd>
					</li>
				</ul>
				</c:when>
				</c:choose>
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