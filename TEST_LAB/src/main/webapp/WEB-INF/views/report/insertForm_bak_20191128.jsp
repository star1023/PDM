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


<script>
var PARAM = {
		category1 : '${paramVO.category1}',
		//category2 : '${paramVO.category2}',
		//category3 : '${paramVO.category3}',
		keyword : '${paramVO.keyword}',
		pageNo : '${paramVO.pageNo}'
	};
var row = "";	
var tbType = "report";	
$(document).ready(function() {
	closeDialog('open');
	//상신버튼 숨김
	//$("#request").hide();
	//메모 기본 값 설정
	$("#content").val("목적 : \r\n\r\n방문장소 : \r\n\r\n참석자 : \r\n\r\n방문시간 : ");
	//카테고리 숨김
	$("#selectboxDiv2").hide();	
	$("#selectboxDiv3").hide();	
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
	//결재박스 숨김
	//$(".apprvalTr").hide();
	
	
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
	row = $('#tbody').html();
});


function onChangeCategory1(){
	var  category1 = nvl($("#category1").selectedValues()[0],"");
	//getCategory( 'category1', category1 );
	if(category1 == ''){
		$("#selectboxDiv2").hide();	
		$("#selectboxDiv3").hide();	
		$(".title").show();
		//$("#content").val("목적 : \r\n\r\n방문장소 : \r\n\r\n참석자 : \r\n\r\n방문시간 : ");
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
	} else if(category1 == 1){				// 실험보고서
		$(".title").show();
		//$("#content").val("목적 : \r\n\r\n방문장소 : \r\n\r\n참석자 : \r\n\r\n방문시간 : ");
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
	} else if(category1 == 2){	// 출장보고서
		$(".title").show();
		//$("#content").val("목적 : \r\n\r\n방문장소 : \r\n\r\n참석자 : \r\n\r\n방문시간 : ");
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
	} else if(category1 == 3){	// 시장조사
		$(".title").show();
		//$("#content").val("목적 : \r\n\r\n방문장소 : \r\n\r\n참석자 : \r\n\r\n방문시간 : ");
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
	} else if(category1 == 4 || category1 == 5){	// 보고 제품, 기술고문 제품
		$(".title").hide();
		$(".content").hide();
		$(".prdTitle").show();
		$(".reportDate").show();
		$(".prdFeature").show();
		$(".adviserPrd").show();
		//에디터(제조방법)
		$("#adviserPrd").cleditor({
			width: '100%',
			height: 400
		});
		$(".bomData").hide();
		$(".imageFile").hide();
		$(".confirm").hide();
		$(".isRelease").hide();
		$(".result").hide();
		$(".developer").hide();
	} else if(category1 == 6){	// 기술고문보고서
		$(".title").show();
		//$("#content").val("목적 : \r\n\r\n방문장소 : \r\n\r\n참석자 : \r\n\r\n방문시간 : ");
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
	} else if(category1 == 7){	// 기술고문보고서
		$(".title").show();
		$(".content").hide();
		$(".prdTitle").hide();
		$(".reportDate").hide();
		$(".prdFeature").show();
		$(".adviserPrd").hide();
		$(".bomData").show();
		$(".imageFile").show();
		$(".confirm").show();
		$(".isRelease").hide();
		$(".result").show();
		$(".developer").show();
	}
}
function onChangeCategory2(){
	/*var  category1 = nvl($("#category1").selectedValues()[0],"");
	if( category1 == '4' || category1 == '5') {
		getCategory( 'category2', '' );
	}*/
}

function getCategory( div, value ) {
	var URL = "../report/getCategoryAjax";
	$.ajax({
		type:"POST",
		url:URL,
		data:{
			"categoryDiv" : div,
			"categoryValue" : value
		},
		dataType:"json",
		async:false,
		success:function(data) {
			var list = data;
			if( div == 'category1') {
				$("#category2").removeOption(/./);
				$("#selectboxDiv2").hide();
				$("#category3").removeOption(/./);
				$("#selectboxDiv3").hide();
				if( list.length > 0 ) {
					$("#category2").addOption('', '전체', true);
					$.each(list, function( index, value ){ //배열-> index, value
						$("#category2").addOption(value.itemCode, value.itemName, false);
					});
					$("#selectboxDiv2").show();
				} else {
					$("#category2").removeOption(/./);
					$("#selectboxDiv2").hide();
				}
				
			} else {
				if( list.length > 0 ) {
					$("#category3").removeOption(/./);
					$("#category3").addOption('', '전체', true);
					$.each(list, function( index, value ){ //배열-> index, value
						$("#category3").addOption(value.itemCode, value.itemName, false);
					});
					$("#selectboxDiv3").show();
				} else {
					$("#category3").removeOption(/./);
					$("#selectboxDiv3").show();
				}
			}
		},
		error:function(request, status, errorThrown){
				alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
		}			
	});
}

function goInsert() {
	if( !chkNull(nvl($("#category1").selectedValues()[0],"")) ) {
		alert("분류를 선택하여 주세요.");
		$("#category1").focus();
		return;
	} 
	var category1 = nvl($("#category1").selectedValues()[0],"");
	if(  category1 == 1 || category1 == 2 || category1 == 6 ) {
		/*
		if( !chkNull(nvl($("#category2").selectedValues()[0],""))  ){
			alert("상세분류를 선택하여 주세요.");
			$("#category2").focus();
			return;
		} else if( !chkNull($("#title").val()) ){
			alert("제목을 입력하여 주세요.");
			$("#title").focus();
			return;
		} 
		if( category1 == 1 && $("#apprUser").selectedValues().length < 1 ) {
			alert("결재자를 선택하여 주세요.");
			return;
		}*/
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
		/*if( !chkNull(nvl($("#category2").selectedValues()[0],""))  ){
			alert("상세분류를 선택하여 주세요.");
			$("#category2").focus();
			return;
		} else if( !chkNull(nvl($("#category3").selectedValues()[0],"")) ) {
			alert("상세분류를 선택하여 주세요.");
			$("#category3").focus();
			return;
		} else*/ if( !chkNull($("#prdTitle").val()) ){
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
	
	if(confirm("저장하시겠습니까?")){
		$("#insertForm").submit();    
	}
}

function goList() {
	location.href="/report/list?"+getParam('${paramVO.pageNo}');
}

//페이징
function paging(pageNo){
	searchUser(pageNo,type);
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
	//html += "<span class=\"file_load\" id=\"fileSpan" + fileIdx + "\">";
	//html += "	<input type='file' name='file' id='file" + fileIdx + "' onChange=\"javaScript:addFile(tmpNo)\">";
	//html += "	<label class=\"btn-default\" for=\"file" + fileIdx + "\">파일첨부</label>";
	//html += "</span>"
	//$("#upFile").append("<span class=\"file_load\" id=\"fileSpan" + fileIdx + "\"><input type='file' name='file' id='file" + fileIdx + "' onChange=\"javaScript:addFile(tmpNo)\"><label class=\"btn-default\" for=\"file" + fileIdx + "\">파일첨부</label></span>");
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




//결재관련 함수 start
function openAppr() {
	clearApprLine();
	getApprLineList();
	$("#apprTitle").val($("#title").val());
	openDialog('open');
}

function clearApprLine() {
	var apprNodes=$("#apprList").children();
	apprNodes.each(function(){ 
		var apprId = $(this).find($("input[name=apprSelectUserId]")).val();
		if( nvl(apprId, '' ) != '' ) {
			$(this).html("");
		}
	});
	$("#refList").html("");
}
function getApprLineList() {
	var URL = "../approval/approvalLineListAjax";
	$.ajax({
		type:"POST",
		url:URL,
		data:{
			"tbType" : tbType
		},
		dataType:"json",
		async:false,
		success:function(data) {
			var list = data;
			$("#apprLine").removeOption(/./);
			$("#apprLine").addOption('','',false);
			$.each(list, function( index, value ){ //배열-> index, value
				$("#apprLine").addOption(value.apprLineNo, value.lineName, false);
			});
		},
		error:function(request, status, errorThrown){
				alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
		}			
	});
}

function getApprItem() {
	var URL = "../approval/detailApprovalLineListAjax";
	$.ajax({
		type:"POST",
		url:URL,
		data:{
			"apprLineNo" : $("#apprLine").selectedValues()[0]			
		},
		dataType:"json",
		async:false,
		success:function(data) {
			var list = data;
			var num = 1;
			$.each(list, function( index, value ){ //배열-> index, value
				var html = "";
				var apprTypeText = "";
				if( value.apprType != 'C' && value.apprType != 'R' ) {
					if( value.apprType == '2' ) {
						apprTypeText = "1차결재자";
					} 
					html += "<a href=\"javascript:delApprList('"+num+"')\"><img src=\"/resources/images/icon_del_file.png\"></a>";
					html += "<span>"+apprTypeText+"</span> "+value.userName;
					html += "<strong> "+value.gradeCodeName+"/"+value.deptCodeName+"</strong>"
					html += "<input type=\"hidden\" name=\"apprSelectUserId\" id=\"apprSelectUserId\" value=\""+value.targetUserId+"\">";
					html += "<input type=\"hidden\" name=\"apprSelectUserName\" id=\"apprSelectUserName\" value=\""+value.userName+"\">";
					$("#apprList"+num).html(html);
					num++;
				} else {
					if( value.apprType == 'R' ) {
						apprTypeText = "참조";
					} else if( value.apprType == 'C' ) {
						apprTypeText = "회람";
					}
					html += "<li id=\"refItem"+refCount+"\">";
					html += "<a href=\"javascript:delRefList('"+refCount+"')\"><img src=\"/resources/images/icon_del_file.png\"></a>";
					html += "<span>"+apprTypeText+"</span> "+value.userName;
					html += "<strong> "+value.gradeCodeName+"/"+value.deptCodeName+"</strong>"
					html += "<input type=\"hidden\" name=\"refId\" id=\"refId\" value=\""+value.targetUserId+"\">";
					html += "<input type=\"hidden\" name=\"refName\" id=\"refName\" value=\""+value.userName+"\">";
					html += "<input type=\"hidden\" name=\"refType\" id=\"refType\" value=\""+value.apprType+"\">";
					html += "</li>";
					$("#refList").append(html);
					refCount++;
				}
			});
		},
		error:function(request, status, errorThrown){
				alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
		}			
	});
}

function insertApprLine() {
	var apprNodes=$("#apprList").children();
	var apprArray = new Array();
	apprNodes.each(function(){
		var apprId = $(this).find($("input[name=apprSelectUserId]")).val();
		if( nvl(apprId, '' ) != '' ) {
			apprArray.push(apprId);
		}
	});
	var refNodes=$("#refList").children();
	var refArray = new Array();
	var circArray = new Array();
	refNodes.each(function(){ 
		var refId = nvl($(this).find($("input[name=refId]")).val(), '');
		var refType = nvl($(this).find($("input[name=refType]")).val(), '');
		if( refType == 'R' ) {
			refArray.push(refId);
		} else if( refType == 'C' ){
			circArray.push(refId);
		}
	});
	var URL = "../approval/approvalLineSaveAjax";
	$.ajax({
		type:"POST",
		url:URL,
		data:{
			"apprArray" : apprArray,
			"refArray" : refArray,
			"circArray" : circArray,
			"circArray" : circArray,
			"tbType" : tbType,
			"lineName" : $("#lineName").val()
		},
		traditional : true,
		dataType:"json",
		async:false,
		success:function(data) {
			if(data.status = 'success') {
				alert("결재라인이  저장되었습니다.");
				getApprLineList();
			} else {
				alert("결재라인 저장 오류가 발생하였습니다.");
				return;
			}
		},
		error:function(request, status, errorThrown){
			alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
		}			
	});
}

function deleteApprLine() {
	var URL = "../approval/deleteApprovalLine";
	$.ajax({
		type:"POST",
		url:URL,
		data:{
			"apprLineNo" : $("#apprLine").selectedValues()[0]
		},
		traditional : true,
		dataType:"json",
		async:false,
		success:function(data) {
			if(data.status = 'success') {
				alert("결재라인 삭제되었습니다.");
				clearApprLine();
				getApprLineList();
			} else {
				alert("결재라인 저장 오류가 발생하였습니다.");
				return;
			}
		},
		error:function(request, status, errorThrown){
			alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
		}			
	});
}

$(function() {
	$('#searchUser').autoComplete({
		minChars: 2,
		delay: 100,
		cache: false,
		source: function(term, response){
			$.ajax({
				type: 'POST',
				url: '../common/userListAjax2',
				dataType: 'json',
				data: {
					"searchUser" : $("#searchUser").val()
				},			
				global: false,
				async: false,
				success: function (data) {
					if(!data){
						return;
					}
					var list = data;
					var completes = [];
					for(var i = 0, len = list.length; i < len; i++){
						var name = list[i].userName + " / " + list[i].userId + " / " + list[i].deptCodeName+ " / " + list[i].teamCodeName;
						completes.push([name, list[i].userId]);  
					}
					response(completes);	
				}
			});
		},
		renderItem: function (item, search){
		    return '<div class="autocomplete-suggestion" data-code="' + item[1] + '" data-nm="' + item[0] + '" style="font-size: 0.8em">' + item[0] + '</div>';
		},
		onSelect: function(e, term, item){
			$("#searchUser").val(item.data('nm'));
			$("#selectUserId").val(item.data('code'));	
			$("#selectUserInfo").val(item.data('nm'));	
		},
		focus: function(event, ui) {
	         return false;
		}	
	});
});

function addApprList(num) {
	var usreId = $("#selectUserId").val();
	if( !chkNull(usreId) ) {
		alert("결재자를 선택해주세요.");
		return;
	} else {
		var usreInfo = $("#selectUserInfo").val();
		var jbSplit = usreInfo.split('/');
		var html = "";
		html += "<a href=\"javascript:delApprList('"+num+"')\"><img src=\"/resources/images/icon_del_file.png\"></a>";
		html += "<span>"+num+"차결재자</span> "+jbSplit[0];
		html += "<strong> "+jbSplit[2]+"/"+jbSplit[3]+"</strong>"
		html += "<input type=\"hidden\" name=\"apprSelectUserId\" id=\"apprSelectUserId\" value=\""+usreId+"\">";
		html += "<input type=\"hidden\" name=\"apprSelectUserName\" id=\"apprSelectUserName\" value=\""+jbSplit[0]+"\">";
		$("#apprList"+num).html(html);
		$('#searchUser').val("");
		$("#selectUserId").val("");
		$("#selectUserInfo").val("");
	}
}

function delApprList(num) {
	var html = "";
	$("#apprList"+num).html(html);
}

var refCount = 0;
function addRefList(type) {
	var usreId = $("#selectUserId").val();
	if( !chkNull(usreId) ) {
		alert("참조/회람자를 선택해주세요.");
		return;
	} else {
		var nodes=$("#refList").children();
		var usreInfo = $("#selectUserInfo").val();
		var jbSplit = usreInfo.split('/');
		var refType="";
		var html = "";
		html += "<li id=\"refItem"+refCount+"\">";
		html += "<a href=\"javascript:delRefList('"+refCount+"')\"><img src=\"/resources/images/icon_del_file.png\"></a>";
		if( type == 'R' ) {
			html += "<span>참조</span> "+jbSplit[0];
			refType = "R"
		} else {
			html += "<span>회람</span> "+jbSplit[0];
			refType = "C"
		}
		html += "<strong> "+jbSplit[2]+"/"+jbSplit[3]+"</strong>"
		html += "<input type=\"hidden\" name=\"refId\" id=\"refId\" value=\""+usreId+"\">";
		html += "<input type=\"hidden\" name=\"refName\" id=\"refName\" value=\""+jbSplit[0]+"\">";
		html += "<input type=\"hidden\" name=\"refType\" id=\"refType\" value=\""+refType+"\">";
		html += "</li>";
		$("#refList").append(html);
		$('#searchUser').val("");
		$("#selectUserId").val("");
		$("#selectUserInfo").val("");
		refCount++;
	}
}

function delRefList(usreId) {
	var html = "";
	$("#refItem"+usreId).remove();
}



function addApprUser() {
	
	if( !chkNull($("#apprTitle").val()) ){
		alert("결재 제목을 입력하여 주세요.");
		$("#apprTitle").focus();
		return;
	} else if( !chkNull($("#apprComment").val()) ) {
		alert("요청사유를 입력하여 주세요.");
		$("#apprComment").focus();
		return;
	} else {
		$("input[name=apprTitle]").val($("#apprTitle").val());
		$("input[name=apprComment]").val($("#apprComment").val());
		var apprNodes=$("#apprList").children();
		apprNodes.each(function(){ 
			var apprId = $(this).find($("input[name=apprSelectUserId]")).val();
			var apprName = $(this).find($("input[name=apprSelectUserName]")).val();
			if( nvl(apprId, '' ) != '' ) {
				$("#apprUser").removeOption(/./);
				$("#apprUser").addOption(apprId, apprName, true);
			}
		});
		var refNodes=$("#refList").children();
		refNodes.each(function(){ 
			var refId = nvl($(this).find($("input[name=refId]")).val(), '');
			var refName = nvl($(this).find($("input[name=refName]")).val(), '');
			var refType = nvl($(this).find($("input[name=refType]")).val(), '');
			if( refId != '' ) {
				if( refType == 'R' ) {
					$("#refUser").addOption(refId, refName, true);
				} else if( refType == 'C' ) {
					$("#circUser").addOption(refId, refName, true);
				}
			}
		});
		loadText("apprUser");
		loadText("refUser");
		loadText("circUser");
		closeDialog('open');
	}
}

function loadText(selectId) {
	var txt = "";
	$("#"+selectId).selectedOptions().each(function(){
			this.text;
			this.value;
			if( txt != '' ) {
				txt += "&nbsp;&nbsp;"+this.text+"&nbsp;<a href=\"javascript:deleteApprUser( '"+this.value+"', '"+selectId+"' )\"><img src=\"/resources/images/icon_del.png\" style=\"vertical-align:middle;cursor:hand\"/></a>";
			} else {
				txt += this.text+"&nbsp;<a href=\"javascript:deleteApprUser( '"+this.value+"', '"+selectId+"' )\"><img src=\"/resources/images/icon_del.png\" style=\"vertical-align:middle\"/></a>";
			} 
		}
	);
	$("#"+selectId+"Name").html(txt);
}

function deleteApprUser( id, selectId ) {
	if( selectId == 'apprUser') {
		$("#apprUser").removeOption(id);
		loadText(selectId);
	} else if( selectId == 'refUser') {
		$("#refUser").removeOption(id);
		loadText(selectId);
	} else if( selectId == 'circUser') {
		$("#circUser").removeOption(id);
		loadText(selectId);
	}
}
//결재관련 함수 end

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
<form name="insertForm" id="insertForm" action="/report/insert" method="post" enctype="multipart/form-data">
<div class="wrap_in" id="fixNextTag">
	<span class="path">보고서&nbsp;&nbsp;<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;게시판&nbsp;&nbsp;<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;<a href="#">삼립식품 연구개발시스템</a></span>
	<section class="type01">
		<h2 style="position:relative"><span class="title_s">Report</span>
			<span class="title">보고서 작성</span>
			<div  class="top_btn_box">
				<ul>
					<li>
						<button class="btn_circle_nomal" onClick="">&nbsp;</button>
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
							<div class="selectbox" style="width:180px;">  
								<label for="category1">전체</label> 
								<select id="category1" name="category1" onChange="onChangeCategory1()">
									<option value="">전체</option>
									<c:forEach items="${category1}" var="category1">
									<option value="${category1.itemCode}"<c:if test="${category1.itemCode == paramVO.category1 }">selected</c:if>>${category1.itemName}</option>
									</c:forEach>
								</select>
							</div>
							<div class="selectbox ml5" style="width:180px;" id="selectboxDiv2">  
								<label for="category2">전체</label> 
								<select id="category2" name="category2" onChange="onChangeCategory2()">																									
								</select>
							</div>
							<div class="selectbox ml5" style="width:180px;" id="selectboxDiv3">  
								<label for="category3">전체</label> 
								<select id="category3" name="category3">
								</select>								
							</div>
							
						</dd>
					</li>
					<li class="title">
						<dt>제목</dt>
						<dd class="pr20 pb10">
							<input type="text" name="title" id="title" placeholder="제목을 입력해주세요." style="width:70%;"/>
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
							<input type="text" name="prdTitle" id="prdTitle" placeholder="제품명을 입력해주세요." style="width:70%;"/>
						</dd>
					</li>
					<li class="reportDate">
						<dt>보고일자</dt>
						<dd class="pr20 pb10">
							<input type="text" name="reportDate" id="reportDate" placeholder="보고일자를 선택해주세요." style="width:20%;" readonly/>
						</dd>
					</li>
					<li class="prdFeature">
						<dt>제품특징</dt>
						<dd class="pr20 pb10">
							<textarea id="prdFeature" name="prdFeature" style="width:100%; height:60px"></textarea>
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
							<textarea id="adviserPrd" name="adviserPrd" style="width:100%; height:60px"></textarea>
						</dd>
					</li>
					<!--li class="apprvalTr">
						<dt>결재자</dt>
						<dd class="pr20 pb10">
							<span id="apprUserName"></span>
							<select name="apprUser" id="apprUser"  style="display:none" multiple>
							</select>
							<input type="hidden" name="apprTitle">
							<input type="hidden" name="apprComment">							
							<a href="#open" onClick="javascript:openAppr();" rel="modal:open">결재선지정</a>
						</dd>
					</li>
					<li class="apprvalTr">
						<dt>참조자</dt>
						<dd class="pr20 pb10">
							<span id="refUserName"></span>
							<select name="refUser" id="refUser"  style="display:none" multiple>
							</select>
						</dd>
					</li>
					<li class="apprvalTr">
						<dt>회람</dt>
						<dd class="pr20 pb10">
							<span id="circUserName"></span>
							<select name="circUser" id="circUser"  style="display:none" multiple>
							</select>
						</dd>
					</li-->
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
									<tr id="row_1_1">
										<td><input type="checkbox" id="rowCheck_1_1" name="c2" ><label for="rowCheck_1_1"><span></span></label></td>
										<td><input type="text" name="itemName" id="itemName" style="width:100%" class="req"/></td>
										<td><input type="text" name="itemBom" id="itemBom" style="width:100%" class="req"/></td>										
									</tr>						
								</tbody>
							</table>
						</dd>
					</li>
					<li  class="imageFile">
						<dt>제품이미지</dt>
						<dd>
							<span id="imageUpfile"></span><br/>
							<img id="preview" src="" width="300px" alt="미리보기"><br/>
							<div class="add_file2" style="width:17%">
							<span class="file_load">
								<input type="file" name="file" id="imageFile" accept="image/*" style="display:none"><label for="imageFile">제품이미지 등록 <img src="/resources/images/icon_add_file.png"></label>
							</span>
							</div>		
						</dd>
					</li>
					<li class="confirm">
						<dt>컨펌완료</dt>
						<dd>
							<input type="checkbox" id="isConfirm" name="isConfirm" value="Y" onClick="checkboxToRadio('isConfirm','isConfirm');loadRelease()"><label for="isConfirm"><span></span>승인</label>
							<input type="checkbox" id="isDelay" name="isConfirm" value="D" onClick="checkboxToRadio('isConfirm','isDelay');loadRelease()"><label for="isDelay"><span></span>보류</label>
							<input type="checkbox" id="noConfirm" name="isConfirm" value="N" onClick="checkboxToRadio('isConfirm','noConfirm');loadRelease()"><label for="noConfirm"><span></span>미승인</label>
						</dd>
					</li>
					<li class="isRelease">
						<dt>출시여부</dt>
						<dd>
							<input type="checkbox" id="isRelease" name="isRelease" value="Y"><label for="isRelease"><span></span>출시</label>							
						</dd>
					</li>
					<li class="result">
						<dt>보고결과</dt>
						<dd>
							<textarea id="result" name="result" style="width:97.5%; height:55px"></textarea>							
						</dd>
					</li>
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
								</ul>
							</div>
							<!--div class="form-group form_file" style="padding-bottom:10px;">
								<input class="form-control form_point_color01" type="text" title="첨부된 파일명" readonly="readonly" style="width:400px">
								<span class="file_load" id="fileSpan1"><input type="file" name="file" id="file1" onChange="javaScript:addFile(tmpNo)"><label class="btn-default" for="file1" style="margin-top:-1px;">파일첨부</label></span>
								<span id="upFile"></span>
							</div-->
						</dd>
					</li>
					<!--  첨부된 파일리스트 start 첨부된 파일이 없을 경우 안보이게 해주세요 -->
					<!--li class="mb5" id="fileList">
						<dt>파일리스트 </dt>
						<dd>
							<div class="file_box_pop"style=" height:100px; width:97.5%;" >
								<ul id="fileData">
								</ul>
							</div>
						</dd>
					</li-->
					<!--  첨부된 파일리스트 close 첨부된 파일이 없을 경우 안보이게 해주세요 -->
				</ul>
			</div>
			<div class="btn_box_con5">
			</div>
			<div class="btn_box_con4"> 
				<!--input type='button' value="상신" class="btn_admin_red" id="request" onclick="javascript:goInsert();"-->
				<input type='button' value="저장" class="btn_admin_sky" id="save" onclick="javascript:goInsert();">
				<input type='button' value="취소" class="btn_admin_gray" id="cancel" onclick="javascript:goList();">
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