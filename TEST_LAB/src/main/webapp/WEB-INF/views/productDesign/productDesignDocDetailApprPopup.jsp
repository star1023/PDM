<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="userUtil" uri="/WEB-INF/tld/userUtil.tld"%>
<%@ taglib prefix="dateUtil" uri="/WEB-INF/tld/dateUtil.tld"%>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="kr.co.aspn.util.*" %> 
<%@ page session="false" %>

<link rel="stylesheet" href="/resources/CLEditor/jquery.cleditor.css?param=1" />
<script type="text/javascript" src="/resources/CLEditor/jquery.cleditor.min.js?param=1"></script>
<link href="/resources/js/jquery.auto-complete.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="/resources/js/jquery.auto-complete.js"></script>

<%
	String userDept = UserUtil.getDeptCode(request);
%> 
<title>제품설계서 결재</title>
<style>
/*추가*/
.outside{ border:0; font-family:'맑은고딕',Malgun Gothic; font-size:12px;}
.outside td{border:2px solid #666;}
.intable_title{ border:0;}
.intable_title td{border:1px solid #666; text-align:center; height:22px;}
.jungjong{ border:0; text-align:center;}
.jungjong th,.jungjong td{ border:1px solid #666; height:18px;}
.jungjong tbody td{ border-bottom:1px solid #ddd !important; border-top:1px solid #ddd !important;}
.jungjong th, .jungjong tfoot td{ background-color:#ebebeb;}

.material{border:0; text-align:center;}
.material th,.material td{ border:1px solid #666; height:18px;}
.material tr th{ background-color:#ebebeb;}

.material_inbox{ border:1px solid #999; text-align:center;}
.material_inbox th,.material_inbox td{  height:18px;}
.material_inbox tbody td{ border-top:1px solid #ddd !important;}
.material_inbox th{ }
.water_mark{font-family:'맑은고딕',Malgun Gothic; font-size:13px; margin-top:10px; float:left;}
.big_font{ font-size:20px;}
.color01{ background-color:#eaf1dd;}
.color02{background-color:#fde9d9;}
.color03{background-color:#dbe5f1;}
.color04{background-color:#ddd9c3;}
.color05{background-color:#f3f3f3;}

</style>
<script type="text/javascript">

var tbType = "productDesignDocDetail";

$(document).ready(function() {
	  document.oncontextmenu = function (e) {
		   return false;
	  }
	  document.ondragstart = function (e) {
		   return false;
	 }
	  document.onselectstart = function (e) {
		   return false;
	 }
	  
	  getApprLineList();
});

function getTextareaHTML(note) {
    return "</p><p>"+ note.trim().replace(/\n\r?/g,"</p><p>") +"</p>";
}

$("#goPrintRequest").off("click").on('click', function() {
	goPrintRequest()
});


function goPrintRequest() {
	if( !chkNull($("#requestReason").val()) ) {
		alert("요청사유를 입력해주세요.");
		$("#requestReason").focus();
		return;
	} else {
		if(confirm("상신하시겠습니까?")) {
			var URL = "../approval/printRequestAjax";
			$.ajax({
				type:"POST",
				url:URL,
				data:{
					"tbType" : tbType,
					"tbKey" : $("#tbKey").val(),
					"requestReason" : $("#requestReason").val(),
					"reqUserId" : $("#regUserId").val(),
					"title" : "${productDevDoc.productName} 다운로드/프린트 결재 요청"
				},
				dataType:"json",
				success:function(data) {
					if(data.status == 'S') {
						alert("프린트/다운로드 결재를 요청했습니다.");
						closeDialog('open');
					} else {
						alert("프린트/다운로드 결재를 요청중 오류가 발생했습니다.\n다시 시도해주세요.");
					}
				},
				error:function(request, status, errorThrown){
					alert("오류가 발생하였습니다.");
				}			
			});
		}
	}
}

var initBody;

function beforePrint() { //인쇄 하기 전에 실행되는 내용
	initBody = document.body.innerHTML;
	var html= "";
	$("#water_mark_td").html(html);
	html += "!! ---------------------------- ";
	html += "<%=UserUtil.getUserId(request)%>";
	html += "&nbsp;&nbsp;|&nbsp;&nbsp;";
	html += "<%=UserUtil.getUserName(request)%>";
	html += "&nbsp;&nbsp;|&nbsp;&nbsp;";
	html += "<%=UserUtil.getDeptCodeName(request)%>";
	html += "&nbsp;&nbsp;|&nbsp;&nbsp;";
	html += "IP:"+"<%=UserUtil.getUserIp(request)%>";
	html += "&nbsp;&nbsp;|&nbsp;&nbsp;";
	html += getCurrentDate();
	html += "----------------------------- !!";
	$("#water_mark_td").append(html);
	$("#water_mark_table").show();
	document.body.innerHTML = $("#print_page").html();
	
}

function afterPrint(){ //인쇄가 끝난 후 실행되는 내용
	$("#water_mark_td").append("");
	$("#water_mark_table").hide(); 
	document.body.innerHTML = initBody;
}

function getCurrentDate() {
	var toDay = "";
	var date =new Date();
	toDay += date.getFullYear()+"-";
	toDay += date.getMonth()+"-";
	toDay += date.getDate();
	toDay += " "+date.getHours()+":";
	toDay += date.getMinutes()+":";
	toDay += date.getSeconds();
	return toDay;
}

function insertPrintLog(apprNo,type) {
	$.ajax({
		type: 'POST',
		data:{
			"apprNo" : apprNo,
			"tbType" : tbType,
			"tbKey" : $("#tbKey").val(),
			"type" : type
		},
		url: '../common/insertPrintLogAjax',
		dataType: 'json',
		async : true,
		success: function (data) {
			
		},error: function(XMLHttpRequest, textStatus, errorThrown){
			alert("에러발생");
		}
	});
}

<c:choose>
<c:when test='${userUtil:getUserId(pageContext.request) eq mfgProcessDoc.regUserId || userUtil:getUserGrade(pageContext.request) == "3" || userUtil:getIsAdmin(pageContext.request) == "Y"}'>
function printCheck() {
	window.onbeforeprint = beforePrint;
	window.onafterprint = afterPrint;
	window.print();
	insertPrintLog("","P");
}

function excelDownloadCheck() {
	//$('#form').attr('action', '/approval/excelDownload').submit();
	excelDownload();
	insertPrintLog("","D");
}
</c:when>
<c:otherwise>

//프린트 결재
function printCheck() {
	var URL = "../approval/printConfirmDataAjax";
	$.ajax({
		type:"POST",
		url:URL,
		data:{
			"tbType" : tbType,
			"tbKey" : $("#tbKey").val()
		},
		dataType:"json",
		success:function(data) {
			 if( typeof data.apprNo == 'undefined' || data.apprNo == null || data.apprNo == "" ) {
				if(confirm("프린트/다운로드 결재를 받으셔야 합니다.\n결재를 요청하시겠습니까?")) {
					$("#requestReason").val("");	
					openDialog('open');
				}
			} else {
				window.onbeforeprint = beforePrint;
				window.onafterprint = afterPrint;
				if( data.lastState == '1' ) {
					//여기는 프린트를 해준다.
					if( data.printCount == 0 ) {
						window.print();
						insertPrintLog(data.apprNo,"P");
					} else {
						if(confirm("이미 출력/다운로드를 하셨습니다.\n결재를 다시 요청하시겠습니까?")) {
							$("#requestReason").val("");	
							openDialog('open');
						}
					}
				} else if( data.lastState == '2' ){
					if(confirm("프린트/다운로드 요청에 대한 결재 반려되었습니다.\n결재를 요청하시겠습니까?")) {
						$("#requestReason").val("");	
						openDialog('open');
					}
				} else if( data.lastState == '0' ) {
					alert("프린트/다운로드 요청에 대한 결재가 완료되지 않았습니다.\n결재 완료 후 다시 진행해주세요.");
				}
			}
		},
		error:function(request, status, errorThrown){
			alert("오류가 발생하였습니다.");
		}			
	});
}

function excelDownloadCheck() {
	var URL = "../approval/printConfirmDataAjax";
	$.ajax({
		type:"POST",
		url:URL,
		data:{
			"tbType" : $("#tbType").val(),
			"tbKey" : $("#tbKey").val(),
		},
		dataType:"json",
		success:function(data) {
			 if( typeof data.apprNo == 'undefined' || data.apprNo == null || data.apprNo == "" ) {
				if(confirm("프린트/다운로드 결재를 받으셔야 합니다.\n결재를 요청하시겠습니까?")) {
					$("#requestReason").val("");	
					openDialog('open');
				}
			} else {
				if( data.lastState == '1' ) {
					//여기는 프린트를 해준다.
					if( data.printCount == 0 ) {
						//$('#form').attr('action', '/approval/excelDownload').submit();
						excelDownload();
						insertPrintLog(data.apprNo,"D");
					} else {
						if(confirm("이미 출력/다운로드를 하셨습니다.\n결재를 다시 요청하시겠습니까?")) {
							$("#requestReason").val("");	
							openDialog('open');
						}
					}
				} else if( data.lastState == '2' ){
					if(confirm("프린트/다운로드 요청에 대한 결재 반려되었습니다.\n결재를 요청하시겠습니까?")) {
						$("#requestReason").val("");	
						openDialog('open');
					}
				} else if( data.lastState == '0' ) {
					alert("프린트/다운로드 요청에 대한 결재가 완료되지 않았습니다.\n결재 완료 후 다시 진행해주세요.");
				}
			}
		},
		error:function(request, status, errorThrown){
			alert("오류가 발생하였습니다.");
		}			
	});
}
</c:otherwise>
</c:choose>


function excelDownload() {
	$.ajax({
		url: '/excel/productDesignDocDetail',
		type : 'post',
		data: {pNo: '${paramVO.pNo}', pdNo:'${paramVO.pdNo}'},
		xhrFields: { responseType: 'blob' },
		success : function(data, b, xhr) {
			var contentDis = xhr.getResponseHeader('content-disposition');
	        var fileName = decodeURIComponent(contentDis.replace(/";/g,'').substr(contentDis.indexOf('filename=')+('filename=').length));
			var blob = new Blob([data]);
			//파일저장
			if (navigator.msSaveBlob) {
				return navigator.msSaveBlob(blob, fileName);
			} else {
				var link = document.createElement('a');
				link.href = window.URL.createObjectURL(blob);
				link.download = fileName;
				link.click();
			}
		},
	    error: function(a,b,c){
	        //console.log(a,b,c);
	        return alert('파일 다운로드 오류[2]')
	    }
	});
}

//반올림 처리
function round(n, digits) {
	if (digits >= 0) return parseFloat(Number(n).toFixed(digits)); // 소수부 반올림
	digits = Math.pow(10, digits); // 정수부 반올림
	var t = Math.round(n * digits) / digits;
	return parseFloat(t.toFixed(0));
}

$(function() {
	$('#searchUser').autoComplete({
		minChars: 2,
		delay: 100,
		cache: false,
		source: function(term, response){
			$.ajax({
				type: 'POST',
				url: '/common/userListAjax2',
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

function addApprList() {
	var usreId = $("#selectUserId").val();
	if( !chkNull(usreId) ) {
		alert("결재자를 선택해주세요.");
		return;
	} else {
		var num = $('#apprList li').length
		var usreInfo = $("#selectUserInfo").val();
		var jbSplit = usreInfo.split('/');
		var html = "";
		html += "<li>";
		html += "	<a href=\"javascript:;\" onclick=\"delApprList(event)\"><img src=\"/resources/images/icon_del_file.png\"></a>";
		html += "	<span>"+num+"차결재자</span> "+jbSplit[0];
		html += "	<strong> "+jbSplit[2]+"/"+jbSplit[3]+"</strong>"
		html += "	<input type=\"hidden\" name=\"apprSelectUserId\" id=\"apprSelectUserId\" value=\""+usreId+"\">";
		html += "	<input type=\"hidden\" name=\"apprSelectUserName\" id=\"apprSelectUserName\" value=\""+jbSplit[0]+"\">";
		html += "</li>"
		//$("#apprList"+num).html(html);
		$('#apprList').append(html);
		$('#searchUser').val("");
		$("#selectUserId").val("");
		$("#selectUserInfo").val("");
	}
}

function delApprList(e) {
	$(e.target).parent().parent().remove();
	setApprLineNum();
	return;
	var html = "";
	$("#apprList"+num).html(html);
}

function setApprLineNum(){
	$('#apprList li').each(function(index, element){
	    if(index != 0)
	        $(element).children('span').text(index+'차결재자')
	})
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

function approvalRequest(){
	
	if( !chkNull($("#apprTitle").val()) ){
		alert("결재 제목을 입력하여 주세요.");
		$("#apprTitle").focus();
		return;
	}
	
	if( !chkNull($("#apprComment").val()) ) {
		alert("요청사유를 입력하여 주세요.");
		$("#apprComment").focus();
		return;
	}
	
	var param = {};
	param['tbType'] = tbType;
	param['tbKey'] = '${paramVO.pdNo}';
	param['title'] = $("#apprTitle").val()
	param['comment'] = $("#apprComment").val()
	
	$('#apprList input[name=apprSelectUserId]').each(function(i, element){
		var apprId = $(element).val()
		if( nvl(apprId, '' ) != '' ) {
			param['apprArray['+i+']']=apprId;
		}
	})
	
	$('#refList input[name=refType][value=R]').each(function(i, element){
		var apprId = $(element).siblings('input[id=refId]').val()
		if( nvl(apprId, '' ) != '' ) {
			param['refArray['+i+']']=apprId;
		}
	})
	
	$('#refList input[name=refType][value=C]').each(function(i, element){
		var apprId = $(element).siblings('input[id=refId]').val()
		if( nvl(apprId, '' ) != '' ) {
			param['circArray['+i+']']=apprId;
		}
	})
	
	$.ajax({
		url: '/approval/approvalProductDesign',
		type: 'POST',
		dataType: 'json',
		data: param,
		success: function(data){
			if(data.status == 'S'){
				alert('제품설계서가 상신되었습니다.');
				window.opener.loadList('1');
				self.close();
			}
		},
		error: function(a,b,c){
			console.log(a,b,c)
		}
	})
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

function clearApprLine() {
	/* var apprNodes=$("#apprList").children();
	apprNodes.each(function(){ 
		var apprId = $(this).find($("input[name=apprSelectUserId]")).val();
		if( nvl(apprId, '' ) != '' ) {
			$(this).html("");
		}
	}); */
	
	$('#apprList li').each(function(index, element){
		if(index != 0) $(element).remove();
	});
	
	$("#refList").html("");
}

function getApprLineList() {
	var URL = "/approval/approvalLineListAjax";
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

var arr;

function getApprItem() {
	var URL = "/approval/detailApprovalLineListAjax";
	$.ajax({
		type:"POST",
		url:URL,
		data:{
			"apprLineNo" : $("#apprLine").selectedValues()[0]			
		},
		dataType:"json",
		async:false,
		success:function(data) {
			clearApprLine()
			
			arr = data;
			
			//var apprLineArr = data.filter(row => (row.apprType != 'R' && row.apprType != 'C'))
			//var rcLineArr = data.filter(row => (row.apprType == 'R' || row.apprType == 'C'))
			
			var apprLineArr = data.map(function(row){
				if(row.apprType != 'R' && row.apprType != 'C')
					return row;
			});
			
			var rcLineArr = data.map(function(row){
				if(row.apprType == 'R' || row.apprType == 'C')
					return row;
			});
			
			apprLineArr.map( function(row, index){
				var html = "";
				var tagName = $('#apprList li').length + "차결재자";
				
				html += "<li>";
				html += "	<a href=\"javascript:;\" onclick=\"delApprList(event)\"><img src=\"/resources/images/icon_del_file.png\"></a>";
				html += "	<span>"+tagName+"</span> "+ row.userName;
				html += "	<strong> "+row.deptCodeName+" / "+row.teamCodeName+"</strong>"
				html += "	<input type=\"hidden\" name=\"apprSelectUserId\" id=\"apprSelectUserId\" value=\""+row.targetUserId+"\">";
				html += "	<input type=\"hidden\" name=\"apprSelectUserName\" id=\"apprSelectUserName\" value=\""+row.userName+"\">";
				html += "</li>"
				
				$('#apprList').append(html);
			});
			
			rcLineArr.map( function(row, index) {
				var html = "";
				var tagName = (row.apprType == 'R' ? '참조' : '회람');
				
				html += "<li>";
				html += "	<a href=\"javascript:;\" onclick=\"delApprList(event)\"><img src=\"/resources/images/icon_del_file.png\"></a>";
				html += "	<span>"+tagName+"</span> "+ row.userName;
				html += "	<strong> "+row.deptCodeName+" / "+row.teamCodeName+"</strong>"
				html += "	<input type=\"hidden\" name=\"refId\" id=\"refId\" value=\""+row.targetUserId+"\">";
				html += "	<input type=\"hidden\" name=\"refName\" id=\"refName\" value=\""+row.userName+"\">";
				html += "	<input type=\"hidden\" name=\"refType\" id=\"refType\" value=\""+row.apprType+"\">";
				html += "</li>"
				
				$('#refList').append(html);
			});
			
			
			/* var list = data;
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
			}); */
		},
		error:function(request, status, errorThrown){
				alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
		}			
	});
}

function insertApprLine() {
	
	var param = {};
	
	$('#apprList input[name=apprSelectUserId]').each(function(i, element){
		var apprId = $(element).val()
		if( nvl(apprId, '' ) != '' ) {
			param['apprArray['+i+']']=apprId;
		}
	})
	
	$('#refList input[name=refType][value=R]').each(function(i, element){
		var apprId = $(element).siblings('input[id=refId]').val()
		if( nvl(apprId, '' ) != '' ) {
			param['refArray['+i+']']=apprId;
		}
	})
	
	$('#refList input[name=refType][value=C]').each(function(i, element){
		var apprId = $(element).siblings('input[id=refId]').val()
		if( nvl(apprId, '' ) != '' ) {
			param['circArray['+i+']']=apprId;
		}
	})
	
	param['tbType'] = tbType;
	param['lineName'] = $("#lineName").val();
	
	$.ajax({
		type:"POST",
		url:'/approval/approvalLineSaveAjax',
		data: param,
		traditional : true,
		dataType:"json",
		async:false,
		success:function(data) {
			console.log(data);
			if(data.status == 'success') {
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
	var URL = "/approval/deleteApprovalLine";
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

</script>

<input type="hidden" name="pNo" id="pNo" value="${paramVO.pNo}">
<input type="hidden" name="pdNo" id="pdNo" value="${paramVO.pdNo}">

<input type="hidden" name="tbKey" id="tbKey" value="${paramVO.pdNo}">
	<input type="hidden" name="currentUserid" id="currentUserid" value="${apprItemHeader.currentUserId }">
	<input type="hidden" name="currentStep" id="currentStep" value="${apprItemHeader.currentStep }">
	<input type="hidden" name="apprNo" id="apprNo" value="${apprItemHeader.apprNo }">
	<input type="hidden" name="title" id="title" value="${apprItemHeader.title }">
	<input type="hidden" name="regUserId" id="regUserId" value="${mfgProcessDoc.regUserId }">
	<input type="hidden" name="tbTypeName" id="tbTypeName" value="${apprItemHeader.tbTypeName }">
<h2 style=" position:fixed;" class="print_hidden">
	<span class="title"><img src="/resources/images/bg_bs_box_fast02.png">&nbsp;&nbsp;제품설계서 결재</span>
</h2>
<div  class="top_btn_box" style=" position:fixed;">
	<ul>
		<li><button type="button" class="btn_pop_close" onClick="self.close();"></button></li>
	</ul>
</div>
<!--여기서부터 프린트 -->
<div id='print_page'  style="padding:10px 0 20px 20px;">
	<table width="1046" cellpadding="0" cellspacing="0" class="print_hidden">
		<tr>
			<td height="50"></td>
		</tr>
		<tr>
			<td align="right" height="50" valign="top">
			<c:if test='${userUtil:getUserId(pageContext.request) == designDocInfo.regUserId || userUtil:getIsAdmin(pageContext.request) == "Y"}'>
				<!-- <button type="button" class="btn_admin_green" onClick="excelDownloadCheck();"><img src="/resources/images/icon_excel.png" style="vertical-align:middle"> 엑셀 다운로드</button> -->
				<button class="btn_admin_red" onClick="javascript:approvalRequest();">결재상신</button> 
				<button type="button" class="btn_admin_nomal" onClick="printCheck();">프린트</button>
			</c:if>
				<button type="button" class="btn_admin_gray" onClick="self.close();">취소</button>
			</td>
		</tr>
	</table>
	<div class="list_detail print_hidden">
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
						<button class="btn_small01 ml5" onClick="addApprList()">결재</button>
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
								<li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="s01"> 기안자</span> <%=UserUtil.getUserName(request)%><strong> <%=UserUtil.getDeptCodeName(request)%> / <%=UserUtil.getTeamCodeName(request)%></strong></li>								
								<!-- <li id="apprList1"></li> -->
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
	<!-- 출력버튼 -->
	<!-- 실제 출력대상 start ------------------------------------------------------------------------------------------------------------------------------------------------>
	<div class="print_box" style="table-layout:fixed;">
		<!-- 상단 머리정보 start-->
		<div class="hold">
			<script>console.log('${designDocInfo}')</script>
			<table width="100%"  class="intable lineall mb5" >
				<colgroup>
					<col width="50%">
					<col width="30%">
					<col width="10%">
					<col width="10%">
				</colgroup>
				<tr>
					<td class="color05">제품설계서</td>
					<td rowspan="3"></td>
					<td class="color05">문서번호</td>
					<td>${designDocInfo.pNo}</td>
				</tr>
				<tr>
					<td rowspan="2"><span class="big_font">${designDocInfo.productName}/${designDocInfo.plantName}(${designDocInfo.plant})</span></td>
					<td class="color05">제개정일</td>
					<c:choose>
						<c:when test="${productDevDoc.modDate != null && fn:length(productDevDoc.modDate) > 0 }">
							<td>${dateUtil:convertDate(designDocInfo.modDate,"yyyy-MM-dd HH:mm:ss","yyyy-MM-dd")}</td>
						</c:when>
						<c:otherwise>
							<td>${dateUtil:convertDate(designDocInfo.regDate,"yyyy-MM-dd HH:mm:ss","yyyy-MM-dd")}</td>
						</c:otherwise>
					</c:choose>
				</tr>
				<tr>
					<td class="color05">&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
			</table>
		</div>
		<!-- 상단 머리정보 close-->
		<!-- 부속정보 start-->
		<div>
			<div class="watermark"><img src="/resources/images/watermark.png"></div>
			<c:if test="${userUtil:getDeptCode(pageContext.request) != 'dept8' }">
			<c:forEach items="${designDocDetail.sub}" var="sub" varStatus="subStatus">					
			<table width="100%" class="intable linetop">
				<tr>
					<td class="color05">  부속제품명  : ${sub.subProdName}  </td>
				</tr>
			</table>
			<!-- 배합비 2개씩 반복 --->
			<div class="hold">
				<table width="100%"  class="intable lineside" >
					<c:set var="mixLength" value="${fn:length(sub.subMix)}" />
					<c:forEach items="${sub.subMix}" var="mix" varStatus="status">
					<c:set var="rigthItemLength" value="${fn:length(sub.subMix[status.index+1].subMixItem)}" />					
					<c:if test="${status.index %2 == 0 }">
					<tr>
					</c:if>
					<c:choose>
						<c:when test="${status.index %2 == 0 }">
							<td width="50%" style=" border-right:2px solid #000; vertical-align:top;">
								<!-- 배합비 타이틀 start-->
								<table width="100%"  class="intable04" >
									<tr>
										<td class="color06">  배합비명  : ${mix.name}  </td>
									</tr>
								</table>
								<!-- 배합비 타이틀 close-->
								<table width="100%" class="intable02">
									<colgroup>
										<col width="40%">
										<col width="12%">
										<col width="12%">
										<col width="12%">
										<col width="12%">
										<col width="12%">
									</colgroup>
									<thead>
										<tr>
											<th>원료명</th>
											<th>코드번호</th>
											<th>배합율</th>
											<th>단가[단위]</th>
											<th>가격</th>
											<th>비급수<br>비율(%)</th>
										</tr>
									</thead>
									<tbody>
										<c:set var="mixItemLength" value="${fn:length(mix.subMixItem)}" />
										<c:set var="mixMixingRatioTotal" value="0"/>
										<c:set var="mixWaterRatioTotal" value="0"/>
										<c:set var="mixProportionTotal" value="0"/>
										<c:forEach items="${mix.subMixItem}" var="item">
											<c:set var="mixMixingRatioTotal" value="${mixMixingRatioTotal + item.mixingRatio}"/>
											<c:if test="${item.itemSapCode == 'P10001'}">
												<c:set var="mixWaterRatioTotal" value="${mixWaterRatioTotal + item.mixingRatio}"/>
											</c:if>
										</c:forEach>
										<c:forEach items="${mix.subMixItem}" var="item">
										<c:set var="mixPriceTotal" value="${mixPriceTotal + (item.itemUnitPrice*item.mixingRatio)}"/>
										<tr>
											<th>${item.itemName}</th>
											<td>${item.itemSapCode}</td>
											<td>
												<c:choose>
													<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) == "13"}'>
													${item.mixingRatio}
													</c:when>
													<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
													&nbsp;
													</c:when>
													<c:otherwise>
													${item.mixingRatio}
													</c:otherwise>
												</c:choose>												
											</td>
											<td>${item.itemUnitPrice}<c:if test="${item.itemUnit != null && fn:length(item.itemUnit)>0}">[${item.itemUnit}]</c:if></td>
											<td><fmt:formatNumber value="${item.itemUnitPrice*item.mixingRatio}" pattern="#.####"/></td>
											<td>
												<c:choose>
													<c:when test="${item.itemSapCode == 'P10001'}">0</c:when>
													<c:otherwise>
														<fmt:formatNumber value="${(item.mixingRatio/(mixMixingRatioTotal-mixWaterRatioTotal))*100}" type="number" pattern="#.###"/>
														<c:set var="mixProportionTotal" value="${mixProportionTotal + (item.mixingRatio/(mixMixingRatioTotal-mixWaterRatioTotal)*100)}"/>
													</c:otherwise>
												</c:choose>
											</td>
											<c:set var= "mixBomRateSum" value="${mixBomRateSum + item.mixingRatio}"/>
										</tr>
										</c:forEach>
										<c:if test="${mixItemLength<rigthItemLength}">
										<c:forEach var="i" begin="1" end="${rigthItemLength - mixItemLength}">
											<tr>
												<th></th>
												<td></td>
												<td></td>
												<td></td>
												<td></td>
											</tr>	
										</c:forEach>
										</c:if>	
										<tr>
											<th colspan="2">합계</th>
											<Td><fmt:formatNumber value="${mixMixingRatioTotal}" pattern=".000"/></Td>
											<Td>&nbsp;</Td>
											<Td><fmt:formatNumber value="${mixPriceTotal}" pattern=".000"/></Td>
											<Td><fmt:formatNumber value="${mixProportionTotal}" pattern="0"/></Td>
										</tr>
									</tbody>
								</table>
							</td>
							<c:if test="${ rigthItemLength == 0}">
							<td width="50%" style=" border-right:2px solid #000; vertical-align:top;">
								<!-- 배합비 타이틀 start-->
								<table width="100%"  class="intable04" >
									<tr>
										<td class="color06"> &nbsp;  </td>
									</tr>
								</table>
								<!-- 배합비 타이틀 close-->
								<table width="100%" class="intable02">
									<colgroup>
										<col width="40%">
										<col width="12%">
										<col width="12%">
										<col width="12%">
										<col width="12%">
										<col width="12%">
									</colgroup>
									<thead>
										<tr>
											<th>원료명</th>
											<th>코드번호</th>
											<th>배합율</th>
											<th>단가[단위]</th>
											<th>가격</th>
											<th>비급수<br>비율(%)</th>
										</tr>
									</thead>
									<tbody>
									<c:forEach var="i" begin="1" end="${mixItemLength}">
										<tr>
											<th></th>
											<td></td>
											<td></td>
											<td></td>
											<td></td>
											<td></td>
										</tr>	
									</c:forEach>										
										<tr>
											<th colspan="2">합계</th>
											<td>&nbsp;</td>
											<td>&nbsp;</td>
											<td>&nbsp;</td>
											<td>&nbsp;</td>									
										</tr>
									</tbody>
								</table>								
							</td>	
							</c:if>
						</c:when>
						<c:otherwise>
							<td width="50%" style=" border-right:2px solid #000; vertical-align:top;">
								<!-- 배합비 타이틀 start-->
								<table width="100%"  class="intable04" >
									<tr>
										<td class="color06">  배합비명  : ${mix.name}  </td>
									</tr>
								</table>
								<!-- 배합비 타이틀 close-->
								<table width="100%" class="intable02">
									<colgroup>
										<col width="40%">
										<col width="12%">
										<col width="12%">
										<col width="12%">
										<col width="12%">
										<col width="12%">
									</colgroup>
									<thead>
										<tr>
											<th>원료명</th>
											<th>코드번호</th>
											<th>배합율</th>
											<th>단가[단위]</th>
											<th>가격</th>
											<th>비급수 비율</th>
										</tr>
									</thead>
									<tbody>
										<c:set var="mixItemLength" value="${fn:length(mix.subMixItem)}" />
										<c:set var="mixMixingRatioTotal" value="0"/>
										<c:set var="mixWaterRatioTotal" value="0"/>
										<c:set var="mixProportionTotal" value="0"/>
										<c:forEach items="${mix.subMixItem}" var="item">
											<c:set var="mixMixingRatioTotal" value="${mixMixingRatioTotal + item.mixingRatio}"/>
											<c:if test="${item.itemSapCode == 'P10001'}">
												<c:set var="mixWaterRatioTotal" value="${mixWaterRatioTotal + item.mixingRatio}"/>
											</c:if>
										</c:forEach>
										<c:forEach items="${mix.subMixItem}" var="item">
										<c:set var="mixPriceTotal" value="${mixPriceTotal + (item.itemUnitPrice*item.mixingRatio)}"/>
										<tr>
											<th>${item.itemName}</th>
											<td>${item.itemSapCode}</td>
											<td>
												<c:choose>
													<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) == "13"}'>
													${item.mixingRatio}
													</c:when>
													<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
													&nbsp;
													</c:when>
													<c:otherwise>
													${item.mixingRatio}
													</c:otherwise>
												</c:choose>												
											</td>
											<td>${item.itemUnitPrice}<c:if test="${item.itemUnit != null && fn:length(item.itemUnit)>0}">[${item.itemUnit}]</c:if></td>
											<td><fmt:formatNumber value="${item.itemUnitPrice*item.mixingRatio}" pattern="#.####"/></td>
											<td>
												<c:choose>
													<c:when test="${item.itemSapCode == 'P10001'}">0</c:when>
													<c:otherwise>
														<fmt:formatNumber value="${(item.mixingRatio/(mixMixingRatioTotal-mixWaterRatioTotal))*100}" type="number" pattern="#.###"/>
														<c:set var="mixProportionTotal" value="${mixProportionTotal + (item.mixingRatio/(mixMixingRatioTotal-mixWaterRatioTotal)*100)}"/>
													</c:otherwise>
												</c:choose>
											</td>
											<c:set var= "mixBomRateSum" value="${mixBomRateSum + item.mixingRatio}"/>
										</tr>
										</c:forEach>
										<c:if test="${mixItemLength<rigthItemLength}">
										<c:forEach var="i" begin="1" end="${rigthItemLength - mixItemLength}">
											<tr>
												<th></th>
												<td></td>
												<td></td>
												<td></td>
												<td></td>
											</tr>	
										</c:forEach>
										</c:if>	
										<tr>
											<th colspan="2">합계</th>
											<Td><fmt:formatNumber value="${mixMixingRatioTotal}" pattern=".000"/></Td>
											<Td>&nbsp;</Td>
											<Td><fmt:formatNumber value="${mixPriceTotal}" pattern=".000"/></Td>
											<Td><fmt:formatNumber value="${mixProportionTotal}" pattern="0"/></Td>
										</tr>
									</tbody>
								</table>								
							</td>
						</c:otherwise>
					</c:choose>
					<c:if test="${status.index == mixLength-1 or status.index%2 == 1 }">
					</tr>
					</c:if>
					</c:forEach>
				</table>
			</div>
			<div class="hold">
				<table width="100%"  class="intable lineside" >
				<c:set var="contLength" value="${fn:length(sub.subContent)}" />
				<c:forEach items="${sub.subContent}" var="cont" varStatus="status">
				<c:set var="rigthContLength" value="${fn:length(sub.subContent[status.index+1].subContentItem)}" />				
				
				<c:if test="${status.index %2 == 0 }">
					<tr>
				</c:if>
				<c:choose>
					<c:when test="${status.index %2 == 0 }">
						<td width="50%" style=" border-right:2px solid #000; vertical-align:top;">
							<!-- 배합비 타이틀 start-->
							<table width="100%"  class="intable04" >
								<tr>
									<td class="color07">  내용물  : ${cont.name}  </td>
								</tr>
							</table>
							<!-- 배합비 타이틀 close-->
							<table width="100%" class="intable02">
								<colgroup>
									<col width="40%">
									<col width="12%">
									<col width="12%">
									<col width="12%">
									<col width="12%">
									<col width="12%">
								</colgroup>
								<thead>
									<tr>
										<th>원료명</th>
										<th>코드번호</th>
										<th>배합율</th>
										<th>단가[단위]</th>
										<th>가격</th>
										<th>비급수 비율</th>
									</tr>
								</thead>
								<tbody>
									<c:set var="contItemLength" value="${fn:length(cont.subContentItem)}" />
									<c:set var="contMixingRatioTotal" value="0"/>
									<c:set var="contWaterRatioTotal" value="0"/>
									<c:set var="contProportionTotal" value="0"/>
									<c:forEach items="${cont.subContentItem}" var="item">
										<c:set var="contMixingRatioTotal" value="${contMixingRatioTotal + item.mixingRatio}"/>
										<c:if test="${item.itemSapCode == 'P10001'}">
											<c:set var="contWaterRatioTotal" value="${contWaterRatioTotal + item.mixingRatio}"/>
										</c:if>
									</c:forEach>
									
									<c:forEach items="${cont.subContentItem}" var="item">
									<c:set var="contPriceTotal" value="${contPriceTotal + (item.itemUnitPrice*item.mixingRatio)}"/>
									<tr>
										<th>${item.itemName}</th>
										<td>${item.itemSapCode}</td>
										<td>
											<c:choose>
												<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) == "13"}'>
												${item.mixingRatio}
												</c:when>
												<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
												&nbsp;
												</c:when>
												<c:otherwise>
												${item.mixingRatio}
												</c:otherwise>
											</c:choose>												
										</td>
										<td>${item.itemUnitPrice}<c:if test="${item.itemUnit != null && fn:length(item.itemUnit)>0}">[${item.itemUnit}]</c:if></td>
										<td><fmt:formatNumber value="${item.itemUnitPrice*item.mixingRatio}" pattern="#.####"/></td>
										<td>
											<c:choose>
												<c:when test="${item.itemSapCode == 'P10001'}">0</c:when>
												<c:otherwise>
													<fmt:formatNumber value="${(item.mixingRatio/(contMixingRatioTotal-contWaterRatioTotal))*100}" type="number" pattern="#.###"/>
													<c:set var="contProportionTotal" value="${contProportionTotal + (item.mixingRatio/(contMixingRatioTotal-contWaterRatioTotal)*100)}"/>
												</c:otherwise>
											</c:choose>
										</td>
										<c:set var= "contBomRateSum" value="${contBomRateSum + item.mixingRatio}"/>
									</tr>
									</c:forEach>
									<c:if test="${contItemLength<rigthContLength}">
									<c:forEach var="i" begin="1" end="${rigthContLength - contItemLength}">
										<tr>
											<th>&nbsp; </th>
											<td>&nbsp; </td>
											<td>&nbsp; </td>
											<td>&nbsp; </td>
											<td>&nbsp; </td>
											<td>&nbsp; </td>
										</tr>	
									</c:forEach>
									</c:if>	
									<tr>
										<th colspan="2">합계</th>
										<Td><fmt:formatNumber value="${contMixingRatioTotal}" pattern=".000"/></Td>
										<Td>&nbsp;</Td>
										<Td><fmt:formatNumber value="${contPriceTotal}" pattern=".000"/></Td>
										<Td><fmt:formatNumber value="${contProportionTotal}" pattern="0"/></Td>
									</tr>
								</tbody>
							</table>								
						</td>
						<%-- <c:if test="${(contLength-1 == status.index) && contLength%2 == 1 }"> --%>
						<c:if test="${ rigthContLength == 0 }">
						<td width="50%" style=" border-right:2px solid #000; vertical-align:top;">
							<!-- 배합비 타이틀 start-->
							<table width="100%"  class="intable04" >
								<tr>
									<td class="color07">  &nbsp;  </td>
								</tr>
							</table>
							<!-- 배합비 타이틀 close-->
							<table width="100%" class="intable02">
								<colgroup>
									<col width="40%">
									<col width="12%">
									<col width="12%">
									<col width="12%">
									<col width="12%">
									<col width="12%">
								</colgroup>
								<thead>
									<tr>
										<th>원료명</th>
										<th>코드번호</th>
										<th>배합율</th>
										<th>단가[단위]</th>
										<th>가격</th>
										<th>비급수 비율</th>
									</tr>
								</thead>
								<tbody>
								<c:forEach var="i" begin="1" end="${contItemLength}">
									<tr>
										<th>&nbsp; </th>
										<td>&nbsp; </td>
										<td>&nbsp; </td>
										<td>&nbsp; </td>
										<td>&nbsp; </td>
										<td>&nbsp; </td>
									</tr>
								</c:forEach>	
									<tr>
										<th colspan="2">합계</th>
										<td>&nbsp; </td>
										<td>&nbsp; </td>
										<td>&nbsp; </td>
										<td>&nbsp; </td>									
									</tr>
								</tbody>
							</table>								
						</td>
						</c:if>
					</c:when>
					<c:otherwise>
						<!-- 배합비 타이틀 start-->
						<td width="50%" style=" border-right:2px solid #000; vertical-align:top;">
							<table width="100%"  class="intable04" >
								<tr>
									<td class="color07">  내용물  : ${cont.name}  </td>
								</tr>
							</table>
							<!-- 배합비 타이틀 close-->
							<table width="100%" class="intable02">
								<colgroup>
									<col width="40%">
									<col width="12%">
									<col width="12%">
									<col width="12%">
									<col width="12%">
									<col width="12%">
								</colgroup>
								<thead>
									<tr>
										<th>원료명</th>
										<th>코드번호</th>
										<th>배합율</th>
										<th>단가[단위]</th>
										<th>가격</th>
										<th>비급수 비율</th>
									</tr>
								</thead>
								<tbody>
									<c:set var="contMixingRatioTotal" value="0"/>
									<c:set var="contWaterRatioTotal" value="0"/>
									<c:set var="contProportionTotal" value="0"/>
									<c:forEach items="${cont.subContentItem}" var="item">
										<c:set var="contMixingRatioTotal" value="${contMixingRatioTotal + item.mixingRatio}"/>
										<c:if test="${item.itemSapCode == 'P10001'}">
											<c:set var="contWaterRatioTotal" value="${contWaterRatioTotal + item.mixingRatio}"/>
										</c:if>
									</c:forEach>
									
									<c:forEach items="${cont.subContentItem}" var="item">
									<c:set var="contPriceTotal" value="${contPriceTotal + (item.itemUnitPrice*item.mixingRatio)}"/>
									<tr>
										<th>${item.itemName}</th>
										<td>${item.itemSapCode}</td>
										<td>
											<c:choose>
												<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) == "13"}'>
												${item.mixingRatio}
												</c:when>
												<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
												&nbsp;
												</c:when>
												<c:otherwise>
												${item.mixingRatio}
												</c:otherwise>
											</c:choose>												
										</td>
										<td>${item.itemUnitPrice}<c:if test="${item.itemUnit != null && fn:length(item.itemUnit)>0}">[${item.itemUnit}]</c:if></td>
										<td><fmt:formatNumber value="${item.itemUnitPrice*item.mixingRatio}" pattern="#.####"/></td>
										<td>
											<c:choose>
												<c:when test="${item.itemSapCode == 'P10001'}">0</c:when>
												<c:otherwise>
													<fmt:formatNumber value="${(item.mixingRatio/(contMixingRatioTotal-contWaterRatioTotal))*100}" type="number" pattern="#.###"/>
													<c:set var="contProportionTotal" value="${contProportionTotal + (item.mixingRatio/(contMixingRatioTotal-contWaterRatioTotal)*100)}"/>
												</c:otherwise>
											</c:choose>
										</td>
										<c:set var= "contBomRateSum" value="${contBomRateSum + item.mixingRatio}"/>
									</tr>
									</c:forEach>
									<c:if test="${contItemLength<rigthContLength}">
									<c:forEach var="i" begin="1" end="${rigthContLength - contItemLength}">
										<tr>
											<th>&nbsp; </th>
											<td>&nbsp; </td>
											<td>&nbsp; </td>
											<td>&nbsp; </td>
											<td>&nbsp; </td>
											<td>&nbsp; </td>
										</tr>	
									</c:forEach>
									</c:if>	
									<tr>
										<th colspan="2">합계</th>
										<Td><fmt:formatNumber value="${contMixingRatioTotal}" pattern=".000"/></Td>
										<Td>&nbsp;</Td>
										<Td><fmt:formatNumber value="${contPriceTotal}" pattern=".000"/></Td>
										<Td><fmt:formatNumber value="${contProportionTotal}" pattern="0"/></Td>
									</tr>
								</tbody>
							</table>								
						</td>
					</c:otherwise>
				</c:choose>		
				<c:if test="${status.index == contLength-1 or status.index%2 == 1 }">
					</tr>
				</c:if>
				</c:forEach>
				</table>
			</div>
		</c:forEach>
		</c:if>
		</div>
	<!-- 부속제품  close-->
	<!-- 유출금지 정보출력 start-->
		<table width="100%"  class="intable lineside" style="display:none" id="water_mark_table">
			<tr>
				<td id="water_mark_td">!- 유출금지 정보출력 -!</td>
			</tr>
		</table>
	<!-- 유출금지 정보출력 close-->
	<!-- 표시사항배합비,제조방법,제품사진,제조방법 start-->
		<div class="hold">
			<div class="watermark"><img src="/resources/images/watermark.png"></div>
				<table class="intable lineside" width="100%">
					<colgroup>
						<col width="50%">
						<col width="50%">
					</colgroup>
					<tr >
						<td class="color05" style="border-right:2px solid #000"> 재료 </td>
						<td class="color05"></td>
					</tr>
					<tr>
						<td valign="top" style="border-right:2px solid #000">
							<table width="100%" class="intable02">
								<colgroup>
									<col width="52%">
									<col width="12%">
									<col width="12%">
									<col width="12%">
									<col width="12%">
								</colgroup>							
								<thead>
									<tr style="border: 1px solid #666">
										<th>재료명</th>
										<th>재료코드</th>
										<th>단가</th>
										<th>수량</th>
										<th>가격</th>
									</tr>
								</thead>
								<tbody>
								<c:set var="pkgPriceTotal" value="0"/>
								<c:forEach items="${designDocDetail.pkg}" var="pkg">
									<tr>
										<th>${pkg.itemName}</th>
										<td>${pkg.itemSapCode}</td>
										<td>${pkg.itemSapPrice}</td>
										<td>${pkg.itemVolume}</td>
										<td>${pkg.itemUnitPrice}</td>
										<c:set var="pkgPriceTotal" value="${pkgPriceTotal + pkg.itemUnitPrice}"/>
									</tr>
								</c:forEach>
								<tr>
									<th colspan="2">합계</th>
									<td></td>
									<td></td>
									<td><fmt:formatNumber value="${pkgPriceTotal}" pattern="0.00"/></td>
								</tr>
								</tbody>
							</table>
						</td>
						<td>
							<table width="100%" class="intable02">
								<colgroup>
									<col width="52%">
									<col width="12%">
									<col width="12%">
									<col width="12%">
									<col width="12%">
								</colgroup>							
								<thead>
									<tr style="border: 1px solid #666">
										<th>재료명</th>
										<th>재료코드</th>
										<th>단가</th>
										<th>수량</th>
										<th>가격</th>
									</tr>
								</thead>
								<tbody>
								<c:forEach items="${designDocDetail.pkg}" var="pkg">
									<tr>
										<th></th>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
									</tr>
								</c:forEach>
								<tr>
									<th colspan="2"></th>
									<td></td>
									<td></td>
									<td></td>
								</tr>
								</tbody>
							</table>
						</td>
					</tr>
				</table>
			</div>
			<!-- 표시사항배합비,제조방법,제품사진,제조방법 close-->
			<!-- 비고 start-->
			<div class="hold">
				<table class="intable04 linebottom" style="border-bottom: 1px solid balck;" width="100%">
					<colgroup>
						<col width="19%">
						<col width="12%">
						<col width="auto">
						<col width="12%">
						<col width="12%">
						<col width="12%">
					</colgroup>
					<thead>
						<tr>
							<td colspan="6" class="color05">원재료비</td>
						</tr>
						<tr style="border: 1px solid #666">
							<th>부속제품명</th>
							<th>구분</th>
							<th>배합/내용물명</th>
							<th>단가(KG)</th>
							<th>분할중량</th>
							<th>원가</th>
						</tr>
					</thead>
					<c:forEach items="${designDocDetail.cost}" var="item" varStatus="subStatus">
						<c:set var="costPriceTotal" value="${costPriceTotal+item.orgPrice}"/>
						<c:set var="costWeightTotal" value="${costWeightTotal+item.weight}"/>
						<tr>
							<td>${item.subProdName}</td>
							<td>
								<c:if test="${item.type == 'mix'}">배합</c:if>
								<c:if test="${item.type == 'content'}">내용물</c:if>
							</td>
							<td>${item.name}</td>
							<td><fmt:formatNumber value="${item.kgPrice}" pattern=".000"/></td>
							<td>${item.weight}</td>
							<td><fmt:formatNumber value="${item.kgPrice/1000*item.weight*(designDocDetail.yieldRate/100)}" pattern=".000"/></td>
						</tr>
					</c:forEach>
					<tfoot style="border-top: 2px solid black;">
						<c:set var="price" value="${designDocDetail.productPrice*designDocDetail.plantPrice/100}"/>
						<c:set var="costPriceTotal" value="${costPriceTotal*(designDocDetail.yieldRate/100)}"/>
						<tr>
							<td colspan="3" style="background-color: #f2f2f2;">합계</td><td>원료</td><td>${costWeightTotal}</td>
							<td><fmt:formatNumber value="${costPriceTotal}" pattern=".000"/> (<fmt:formatNumber value="${costPriceTotal/price*100}" pattern=".00"/>%)</td>
						</tr>
						<tr>
							<td colspan="3" style="background-color: #f2f2f2; border-bottom: 1px solid #f2f2f2;"></td><td>재료</td><td></td>
							<td><fmt:formatNumber value="${pkgPriceTotal}" pattern=".000"/> (<fmt:formatNumber value="${pkgPriceTotal/price*100}" pattern=".00"/>%)</td>
						</tr>
						<tr>
							<td colspan="3" style="background-color: #f2f2f2; border-bottom: 1px solid #f2f2f2;"></td><td>총 가격</td><td></td>
							<td><fmt:formatNumber value="${costPriceTotal+pkgPriceTotal}" pattern=".000"/> (<fmt:formatNumber value="${(costPriceTotal+pkgPriceTotal)/price*100}" pattern=".00"/>%)</td>
						</tr>
						<tr><td colspan="3" style="background-color: #f2f2f2; border-bottom: 1px solid #f2f2f2;"></td><td>소매가격</td><td></td><td>${designDocDetail.productPrice}</td></tr>
						<tr><td colspan="3" style="background-color: #f2f2f2;"></td><td>출하가</td><td><fmt:formatNumber value="${(designDocDetail.plantPrice)}" pattern=".00"/> %</td><td>${price}</td></tr>
					</tfoot>
				</table>
			</div>
			<!-- 비고 close-->
			<!-- 제품규격(밀다원) start-->
			<c:if test="${fn:trim(mfgProcessDoc.calcType) == '3' or fn:trim(mfgProcessDoc.calcType) == '7'}">
				<div class="hold">
					<table class="intable04 linebottom" width="100%">
						<colgroup>
							<col width="16%">
							<col width="17%">
							<col width="16%">
							<col width="17%">
							<col width="16%">
							<col width="18%">
						</colgroup>
						<tr>
							<td colspan="6" class="color05"> 제품규격(밀다원) </td>
						</tr>
						<tr>
							<th>Moisture(%)</th>
							<td>
								${mfgProcessDoc.specMD.moisture} 
								<c:if test="${fn:length(mfgProcessDoc.specMD.moisture) > 0}">
									${mfgProcessDoc.specMD.moistureUnit == 'gt' ? '↑' : '↓'}
								</c:if>
							</td>
							<th>Ash(%)</th>
							<td>
								<c:if test="${fn:length(mfgProcessDoc.specMD.ashFrom) > 0 or fn:length(mfgProcessDoc.specMD.ashTo) > 0}">
									${mfgProcessDoc.specMD.ashFrom} ~ ${mfgProcessDoc.specMD.ashTo}
								</c:if>
							</td>
							<th>Protein(%)</th>
							<td>
								${mfgProcessDoc.specMD.protein}
								<c:if test="${fn:length(mfgProcessDoc.specMD.proteinErr) > 0}">
									 ± ${mfgProcessDoc.specMD.proteinErr}
								</c:if>
							</td>
						</tr>
						<tr>
							<th>Water absorption(%)</th>
							<td>
								<c:if test="${fn:length(mfgProcessDoc.specMD.waterAbsFrom) > 0 or fn:length(mfgProcessDoc.specMD.waterAbsTo) > 0}">
									${mfgProcessDoc.specMD.waterAbsFrom} ~ ${mfgProcessDoc.specMD.waterAbsTo}
								</c:if>
							</td>
							<th>Stability(min)</th>
							<td>
								<c:if test="${fn:length(mfgProcessDoc.specMD.stabilityFrom) > 0 or fn:length(mfgProcessDoc.specMD.stabilityTo) > 0}">
									${mfgProcessDoc.specMD.stabilityFrom} ~ ${mfgProcessDoc.specMD.stabilityTo}
								</c:if>
							</td>
							<th>Development time(min)</th>
							<td>
								${mfgProcessDoc.specMD.devTime}
								<c:if test="${fn:length(mfgProcessDoc.specMD.devTime) > 0}">
									${mfgProcessDoc.specMD.devTimeUnit == 'gt' ? '↑' : '↓'}
								</c:if>
							</td>
						</tr>
						<tr>
							<th>P/L</th>
							<td>
								<c:if test="${fn:length(mfgProcessDoc.specMD.plFrom) > 0 or fn:length(mfgProcessDoc.specMD.plTo) > 0}">
								  	${mfgProcessDoc.specMD.plFrom} ~ ${mfgProcessDoc.specMD.plTo}
								</c:if>
							</td>
							<th>Maximum viscosity(BU)</th>
							<td>
								${mfgProcessDoc.specMD.maxVisc}
								<c:if test="${fn:length(mfgProcessDoc.specMD.maxVisc) > 0}">
									${mfgProcessDoc.specMD.maxViscUnit == 'gt' ? '↑' : '↓'}
								</c:if>
							</td>
							<th>FN(sec)</th>
							<td>
								<c:if test="${fn:length(mfgProcessDoc.specMD.fnFrom) > 0 or fn:length(mfgProcessDoc.specMD.fnTo) > 0}">
									${mfgProcessDoc.specMD.fnFrom} ~ ${mfgProcessDoc.specMD.fnTo}
								</c:if>
							</td>
						</tr>
						<tr>
							<th>Color(Lightness)</th>
							<td>
								${mfgProcessDoc.specMD.color}
								<c:if test="${fn:length(mfgProcessDoc.specMD.color) > 0}">
									${mfgProcessDoc.specMD.colorUnit == 'gt' ? '↑' : '↓'}
								</c:if>
							</td>
							<th>Wet gluten(%)</th>
							<td>
								<c:if test="${fn:length(mfgProcessDoc.specMD.wetGlutenFrom) > 0 or fn:length(mfgProcessDoc.specMD.wetGlutenTo) > 0}">
									${mfgProcessDoc.specMD.wetGlutenFrom} ~ ${mfgProcessDoc.specMD.wetGlutenTo}
								</c:if>
							</td>
							<th>Viscosity(Batter)mm</th>
							<td>
								${mfgProcessDoc.specMD.visc}
								<c:if test="${fn:length(mfgProcessDoc.specMD.visc) > 0}">
									${mfgProcessDoc.specMD.viscUnit == 'gt' ? '↑' : '↓'}
								</c:if>
							</td>
						</tr>
						<tr>
							<th>Particle size(Average)㎛</th>
							<td>${strUtil:getHtmlBr(mfgProcessDoc.specMD.particleSize)}</td>
							<td colspan="4"></td>
							<!-- <th></th>
							<td></td>
							<th></th>
							<td></td> -->
						</tr>
					</table>
				</div>
			</c:if>
			<!-- 제품규격(밀다원) close-->
			<!-- 출력버튼 -->
			<table width="1046" cellpadding="0" cellspacing="0" class="print_hidden">
				<tr>
					<td align="right" height="50" valign="bottom">
					<c:if test='${userUtil:getUserId(pageContext.request) == designDocInfo.regUserId || userUtil:getIsAdmin(pageContext.request) == "Y"}'>
						<!-- <button type="button" class="btn_admin_green" onClick="excelDownloadCheck();"><img src="/resources/images/icon_excel.png" style="vertical-align:middle"> 엑셀 다운로드</button> -->
						<button type="button" class="btn_admin_nomal" onClick="printCheck();">프린트</button>
					</c:if>	
						<button type="button" class="btn_admin_gray" onClick="self.close();">취소</button>
					</td>
				</tr>
			</table>
			<!-- 여기까지 프린트 -->
	</div>
</div>


<!-- 자재 호출레이어 start-->
<div class="white_content" id="open">
	<div class="modal" style="	width: 700px;margin-left:-350px;height: 350px;margin-top:-150px;">
		<h5 style="position:relative">
			<span class="title">다운로드 및 프린트 요청</span>
			<div  class="top_btn_box">
				<ul>
					<li>
						<button class="btn_madal_close" onClick="closeDialog('open')"></button>
					</li>
				</ul>
			</div>
		</h5>
		<div class="list_detail">
			<ul>
				<li class="pt10">
					<dt>주의사항</dt>
					<dd>
						본 문서는 대외비로 간주되오니 외부에 유출되지 않도록 철저하게 관리 바라며,<br/> 사용이 완료된 자료는 파쇄하여 주시기 바랍니다.<br/>
						결재완료 시점부터 1회 다운로드 및 프린트가 가능합니다.<br/>
					</dd>
				</li>
				<li>
					<dt>요청사유</dt>
					<dd>
						<textarea id="requestReason" name="requestReason" style="width:98%; height:70px;resize: none;"></textarea>
					</dd>
				</li>
			</ul>
		</div>
		<div class="btn_box_con">
			<button class="btn_admin_red" id="goPrintRequest" onclick="javascript:goPrintRequest();">결재요청</button> 
			<button class="btn_admin_gray"onclick="closeDialog('open')"> 취소</button>
		</div>
	</div>
</div>
