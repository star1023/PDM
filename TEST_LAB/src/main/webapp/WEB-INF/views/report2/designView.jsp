<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="kr.co.aspn.util.*" %>
<%@ taglib prefix="userUtil" uri="/WEB-INF/tld/userUtil.tld"%>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ taglib prefix="dateUtil" uri="/WEB-INF/tld/dateUtil.tld"%>
<title>상품설계변경보고서</title>
<style>
.positionCenter{
	position: absolute;
	transform: translate(-50%, -45%);
}
</style>

<link href="../resources/css/mfg.css" rel="stylesheet" type="text/css">
<script type="text/javascript">
function downloadFile(idx){
	location.href = '/test/fileDownload?idx='+idx;
}

function fn_list() {
	location.href = '/report2/designList';
}

$(function() {
	// 자동 완성 설정
	jQuery('#keyword').autocomplete({
		minLength: 1,
	    delay: 300,
		source: function( request, response ) {
			jQuery.ajax({
				async : false,
				type : 'POST',
				dataType: 'json',
				url: '/approval2/searchUserAjax',
				data: { 'keyword' : jQuery('#keyword').val() },
				success: function( data ) {
					console.log(data);
					response(jQuery.map(data, function(item){
						return {
							label : item.USER_NAME + ' / '+item.USER_ID + ' / '+'부서명' + ' / '+'팀명',
							value : item.USER_NAME + ' / '+item.USER_ID + ' / '+'부서명' + ' / '+'팀명',
							userId : item.USER_ID,
							deptName : '부서명',
							teamName : '팀명',
							userName : item.USER_NAME
						};
					}));
				}
			});
		},
		select : function(event, ui){
			jQuery('#deptName').val('');
			jQuery('#deptName').val(ui.item.deptName);
			
			jQuery('#teamName').val('');
			jQuery('#teamName').val(ui.item.teamName);
			
			jQuery('#userId').val('');
			jQuery('#userId').val(ui.item.userId);
			
			jQuery('#userName').val('');
			jQuery('#userName').val(ui.item.userName);
		},
		focus : function( event, ui ) {
			return false;
		}
	});	
});


function fn_loadApprovalLine() {
	var URL = "../approval2/selectApprovalLineAjax";
	$.ajax({
		type:"POST",
		url:URL,
		data:{
			/* "docType" : "PROD" */
		},
		dataType:"json",
		async:false,
		success:function(data) {
			console.log(data);
			$("#apprLineSelect").removeOption(/./);
			data.forEach(function(item){
				$("#apprLineSelect").addOption(item.LINE_IDX, item.NAME, false);	
			});
			
		},
		error:function(request, status, errorThrown){
				alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
		}			
	});
}

function fn_approvalAddLine(obj) {
	var id = $(obj).attr("id");
	var html = "";
	if( id == 'appr_add_btn' ) {
		if( $("#userId").val() == '' ) {
			alert("결재자를 선택해주세요.");
			return;
		}
		if( $("#apprLine").containsOption($("#userId").val()) ) {
			alert("이미 등록된 결재자입니다.");
			$("#keyword").val("");
			$("#userId").val("");
			$("#userName").val("");
			$("#deptName").val("");
			$("#teamName").val("");
			return;
		}
		$("#apprLine").addOption($("#userId").val(), $("#userName").val(), true);
		var lineLength = $("#apprLineList").children().length+1;
		html = "<li>";
		html += "<img src='../resources/images/icon_del_file.png' name='delImg' alt='' data-apprtype='A' onclick='fn_approvalRemoveLine(this);' >";
		html += "<span id=\"lineLength\">"+lineLength+"차 결재</span> " + $("#userName").val();
		html += "<strong>/" + $("#userId").val() + "/" + $("#deptName").val() + "/" + $("#teamName").val() + "</strong>";
		html += "<input type='hidden' name='userIds' data-apprtype='A' value='" + $("#userId").val() + "'/>";
		html += "</li>";
		$("#apprLineList").append(html);
		$("#keyword").val("");
		$("#userId").val("");
		$("#userName").val("");
		$("#deptName").val("");
		$("#teamName").val("");
		
		$("#apprLineList").children("li").toArray().forEach(function(item,index) { 
			$(item).children("span").html((index+1)+"차 결재");
		});
		
	} else if( id == 'ref_add_btn' ){
		if( $("#userId").val() == '' ) {
			return;
		}
		if( $("#refLine").containsOption($("#userId").val()) ) {
			alert("이미 등록된 참조자입니다.");
			$("#keyword").val("");
			$("#userId").val("");
			$("#userName").val("");
			$("#deptName").val("");
			$("#teamName").val("");
			return;
		}
		$("#refLine").addOption($("#userId").val(), $("#userName").val(), true);
		html = "<li>";
		html += "<img src='../resources/images/icon_del_file.png' name='delImg' alt='' data-apprtype='R' onclick='fn_approvalRemoveLine(this);' >";
		html += "<span>참조</span> " + $("#userName").val();
		html += "<strong>/" + $("#userId").val() + "/" + $("#deptName").val() + "/" + $("#teamName").val() + "</strong>";
		html += "<input type='hidden' name='userIds' data-apprtype='R' value='" + $("#userId").val() + "'/>";
		html += "</li>";
		$("#refLineList").append(html);
		$("#keyword").val("");
		$("#userId").val("");
		$("#userName").val("");
		$("#deptName").val("");
		$("#teamName").val("");
	}
	
}

function fn_approvalRemoveLine(obj) {
	var apprtype = $(obj).data("apprtype");
	console.log(apprtype);
	if( apprtype == 'A' ) {
		console.log("결재자 삭제");
		$("#apprLine").removeOption($(obj).parent().children("input").val());
		$(obj).parent().remove();
		$("#apprLineList").children("li").toArray().forEach(function(item,index) { 
			$(item).children("span").html((index+1)+"차 결재");
		});
	} else if( apprtype == 'R' ) {
		console.log("참조자 삭제");
		$("#refLine").removeOption($(obj).parent().children("input").val());
		$(obj).parent().remove();
	}
}


function fn_apprSubmit(){
	if( $("#apprLine option").length == 0 ) {
		alert("등록된 결재라인이 없습니다. 결재 라인 추가 후 결재상신 해 주세요.");
		return;
	} else {
		var formData = new FormData();
		formData.append("docIdx",'${designData.data.DESIGN_IDX}');
		formData.append("apprComment", $("#apprComment").val());
		formData.append("apprLine", $("#apprLine").selectedValues());
		formData.append("refLine", $("#refLine").selectedValues());
		formData.append("title", '${designData.data.TITLE}');
		formData.append("docType", "DESIGN");
		formData.append("status", "N");
		var URL = "../approval2/insertApprAjax";
		$.ajax({
			type:"POST",
			url:URL,
			dataType:"json",
			data: formData,
			processData: false,
	        contentType: false,
	        cache: false,
			success:function(data) {
				if(data.RESULT == 'S') {
					alert("등록되었습니다.");
					fn_list();
				} else {
					alert("결재선 상신 오류가 발생하였습니다."+data.MESSAGE);
					return;
				}
			},
			error:function(request, status, errorThrown){
				alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
			}			
		});
	}
}

function fn_apprOpen() {
	fn_loadApprovalLine();
	openDialog('approval_dialog')
}
function fn_apprCancel(){
	$("#apprLine").removeOption(/./);
	$("#refLine").removeOption(/./);
	$("#apprLineList").html("");
	$("#refLineList").html("");
	$("#keyword").val("");
	$("#userId").val("");
	$("#userName").val("");
	$("#deptName").val("");
	$("#teamName").val("");
	closeDialog('approval_dialog');
}

function fn_apprLineSave(obj){
	//apprLineName
	if( !chkNull($("#apprLineName").val()) ) {
		alert("결재라인 명을 입력해주세요.");
		$("#apprLineName").focus();
		return;
	} else {
		if( $("#apprLine option").length == 0 ) {
			alert("등록된 결재라인이 없습니다. 결재 라인 추가 후 저장해주세요.");
			return;
		} else {
			var formData = new FormData();
			formData.append("apprLineName", $("#apprLineName").val());
			formData.append("apprLine", $("#apprLine").selectedValues());
			formData.append("docType", "DESIGN");
			
			var URL = "../approval2/insertApprLineAjax";
			$.ajax({
				type:"POST",
				url:URL,
				dataType:"json",
				data: formData,
				processData: false,
		        contentType: false,
		        cache: false,
				success:function(data) {
					if(data.RESULT == 'S') {
						alert("등록되었습니다.");
						fn_loadApprovalLine();
					} else {
						alert("결재선 저장시 오류가 발생하였습니다."+data.MESSAGE);
						return;
					}
				},
				error:function(request, status, errorThrown){
					alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
				}			
			});
		}
	}
}

function fn_apprLineSaveCancel(obj){
	$("#apprLineName").val("");
}

function fn_changeApprLine(obj) {
	console.log($("#apprLineSelect").selectedValues()[0]);
	if( $("#apprLineSelect").selectedValues()[0] != "" ) {
		var URL = "../approval2/selectApprovalLineItemAjax";
		$.ajax({
			type:"POST",
			url:URL,
			data:{
				"lineIdx" : $("#apprLineSelect").selectedValues()[0]
			},
			dataType:"json",
			async:false,
			success:function(data) {
				console.log(data);
				$("#apprLine").removeOption(/./);
				$("#apprLineList").html("");
				data.forEach(function(item){
					$("#apprLine").addOption(item.USER_ID, item.USER_NAME, true);
					var lineLength = $("#apprLineList").children().length+1;
					html = "<li>";
					html += "<img src='../resources/images/icon_del_file.png' name='delImg' alt='' data-apprtype='A' onclick='fn_approvalRemoveLine(this);' >";
					html += "<span id=\"lineLength\">"+lineLength+"차 결재</span> " + item.USER_NAME;
					html += "<strong>/" + item.USER_ID + "/" + item.DEPT_NAME + "/" + item.TEAM_NAME + "</strong>";
					html += "<input type='hidden' name='userIds' data-apprtype='A' value='" + item.USER_ID + "'/>";
					html += "</li>";
					$("#apprLineList").append(html);
				});
			},
			error:function(request, status, errorThrown){
					alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
			}			
		});
	}
}

function fn_deleteApprLine(obj){
	if( $("#apprLineSelect").selectedValues()[0] != "" ) {
		var URL = "../approval2/deleteApprLineAjax";
		$.ajax({
			type:"POST",
			url:URL,
			data:{
				"lineIdx" : $("#apprLineSelect").selectedValues()[0]
			},
			dataType:"json",
			async:false,
			success:function(data) {
				if( data.RESULT == 'S' ) {
					alert("삭제하였습니다.");
					fn_loadApprovalLine();
				} else {
					alert("오류가 발생했습니다."+data.MESSAGE);
				}
				
			},
			error:function(request, status, errorThrown){
				console.log(request);
				console.log(status);
				console.log(errorThrown);
				alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
			}			
		});
	}
}
</script>

<div class="wrap_in" id="fixNextTag">
	<span class="path">
		상품설계변경 보고서&nbsp;&nbsp;
		<img src="/resources/images/icon_path.png" style="vertical-align: middle" />&nbsp;&nbsp;보고서&nbsp;&nbsp;
		<img src="/resources/images/icon_path.png" style="vertical-align: middle" />&nbsp;&nbsp;<a href="#none">${strUtil:getSystemName()}</a>
	</span>
	<section class="type01">
		<h2 style="position:relative">
			<span class="title_s">Design Change Report</span><span class="title">상품설계변경보고서</span>
			<div class="top_btn_box">
				<ul>
					<li>
						<c:if test="${designData.data.STATUS == 'REG' }">
							<button class="btn_small_search ml5" onclick="fn_apprOpen()" style="float: left">결재</button>
						</c:if>
					</li>
				</ul>
			</div>
		</h2>
		<div class="group01 mt20">
			<div class="title2"  style="width: 80%;"><span class="txt">기본정보</span></div>
			<div class="title2" style="width: 20%; display: inline-block;">
				
			</div>
			<div class="main_tbl">
				<table class="insert_proc01">
					<colgroup>
						<col width="15%" />
						<col width="35%" />
						<col width="15%" />
						<col width="35%" />
					</colgroup>
					<tbody>
						<tr>
							<th style="border-left: none;">제목</th>
							<td colspan="3">${designData.data.TITLE}</td>
						</tr>
						<tr>
							<th style="border-left: none;">상품코드</th>
							<td>
								${designData.data.PRODUCT_CODE}
							</td>
							<th style="border-left: none;">ERP코드</th>
							<td>
								${designData.data.SAP_CODE}
							</td>
						</tr>
						<tr>
							<th style="border-left: none;">제품명</th>
							<td colspan="3">
								${designData.data.PRODUCT_NAME}
							</td>
						</tr>
						<tr>
							<th style="border-left: none;">변경사유</th>
							<td colspan="3">
								${designData.data.CHANGE_COMMENT}
							</td>
						</tr>
						<tr>
							<th style="border-left: none;">변경시점</th>
							<td colspan="3">
								${designData.data.CHANGE_TIME}
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			
			<div class="title2" style="float: left; margin-top: 30px;">
				<span class="txt">변경사항</span>
			</div>
			<table id="changeTable" class="tbl05">
				<colgroup>
					<col width="15%">
					<col width="34%">
					<col />
					<col width="15%">
				</colgroup>
				<thead>
					<tr>
						<th>구분</th>
						<th>기존</th>
						<th>변경</th>
						<th>비고</th>
					</tr>
				</thead>
				<tbody>
				<c:forEach items="${designChangeList}" var="designChangeList" varStatus="status">
					<tr>
						<td>
							${designChangeList.ITEM_DIV}				
						</td>
						<td>
							${strUtil:getHtml(designChangeList.ITEM_CURRENT)}							
						</td>
						<td>
							${strUtil:getHtml(designChangeList.ITEM_CHANGE)}							
						</td>
						<td>
							${designChangeList.ITEM_NOTE}
						</td>
					</tr>
				</c:forEach>	
				</tbody>
			</table>
			
			<div class="title2 mt20"  style="width:90%;"><span class="txt">첨부파일</span></div>
			<div class="con_file" style="">
				<ul>
					<li class="point_img">
						<dt>첨부파일</dt><dd>
							<ul>
								<c:forEach items="${designData.fileList}" var="fileList" varStatus="status">
									<li>&nbsp;<a href="javascript:downloadFile('${fileList.FILE_IDX}')">${fileList.ORG_FILE_NAME}</a></li>
								</c:forEach>
							</ul>
						</dd>
					</li>
				</ul>
			</div>
			
			<div class="title2 mt20"  style="width:90%;"><span class="txt">기안문</span></div>
			<div>
				<table class="insert_proc01">
					<tr>
						<td>${designData.data.CONTENTS}</td>
					</tr>
				</table>
			</div>
			
			<div class="main_tbl">
				<div class="btn_box_con5">					
				</div>
				<div class="btn_box_con4">
					<button class="btn_admin_gray" onClick="fn_list();" style="width: 120px;">목록</button>
				</div>
				<hr class="con_mode" />
			</div>
		</div>
	</section>
</div>

<!-- 결재 상신 레이어  start-->
<div class="white_content" id="approval_dialog">
 	<input type="hidden" id="deptName" />
	<input type="hidden" id="teamName" />
	<input type="hidden" id="userId" />
	<input type="hidden" id="userName"/>
 	<select style="display:none" id=apprLine name="apprLine" multiple>
 	</select>
 	<select style="display:none" id=refLine name="refLine" multiple>
 	</select>
	<div class="modal" style="	margin-left:-500px;width:1000px;height: 550px;margin-top:-300px">
		<h5 style="position:relative">
			<span class="title">개발완료보고서 결재 상신</span>
			<div  class="top_btn_box">
				<ul><li><button class="btn_madal_close" onClick="fn_apprCancel(); return false;"></button></li></ul>
			</div>
		</h5>
		<div class="list_detail">
			<ul>
				<li>
					<dt style="width:20%">결재요청의견</dt>
					<dd style="width:80%;">
						<div class="insert_comment">
							<table style=" width:756px">
								<tr>
									<td>
										<textarea style="width:100%; height:50px" placeholder="의견을 입력하세요" name="apprComment" id="apprComment"></textarea>
									</td>
									<td width="98px"></td>
								</tr>
							</table>
						</div>
					</dd>
				</li>
				<li class="pt5">
					<dt style="width:20%">결재자 입력</dt>
					<dd style="width:80%;" class="ppp">
						<input type="text" placeholder="결재자명 2자이상 입력후 선택" style="width:198px; float:left;" class="req" id="keyword" name="keyword">
						<button class="btn_small01 ml5" onclick="fn_approvalAddLine(this); return false;" name="appr_add_btn" id="appr_add_btn">결재자 추가</button>
						<button class="btn_small02  ml5" onclick="fn_approvalAddLine(this); return false;" name="ref_add_btn" id="ref_add_btn">참조</button>
						<div class="selectbox ml5" style="width:180px;">
							<label for="apprLineSelect">---- 결재라인 불러오기 ----</label>
							<select id="apprLineSelect" name="apprLineSelect" onchange="fn_changeApprLine(this);">
								<option value="">---- 결재라인 불러오기 ----</option>
							</select>
						</div>
						<button class="btn_small02  ml5" onclick="fn_deleteApprLine(this); return false;">선택 결재라인 삭제</button>
					</dd>
				</li>
				<li  class="mt5">
					<dt style="width:20%; background-image:none;" ></dt>
					<dd style="width:80%;">
						<div class="file_box_pop2" style="height:190px;">
							<ul id="apprLineList">
							</ul>
						</div>
						<div class="file_box_pop3" style="height:190px;">
							<ul id="refLineList">
							</ul>
						</div>
						<!-- 현재 추가된 결재선 저장 버튼을 누르면 안보이게 처리 start -->
						<div class="app_line_edit">
							저장 결재선라인 입력 :  <input type="text" name="apprLineName" id="apprLineName" class="req" style="width:280px;"/> 
							<button class="btn_doc" onclick="fn_apprLineSave(this);  return false;"><img src="../resources/images/icon_doc11.png"> 저장</button> 
							<button class="btn_doc" onclick="fn_apprLineSaveCancel(this); return false;"><img src="../resources/images/icon_doc04.png">취소</button>
						</div>
						<!-- 현재 추가된 결재선 저장 버튼 눌렀을때 보이게 처리 close -->
					</dd>
				</li>
			</ul>
		</div>
		<div class="btn_box_con4" style="padding:15px 0 20px 0">
			<button class="btn_admin_red" onclick="fn_apprSubmit(); return false;">결재상신</button> 
			<button class="btn_admin_gray" onclick="fn_apprCancel(); return false;">상신 취소</button>
		</div>
	</div>
</div>
<!-- 결재 상신 레이어  close-->