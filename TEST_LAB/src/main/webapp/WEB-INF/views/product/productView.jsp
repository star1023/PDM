<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page import="kr.co.aspn.util.*" %>
<%@ taglib prefix="userUtil" uri="/WEB-INF/tld/userUtil.tld"%>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ taglib prefix="dateUtil" uri="/WEB-INF/tld/dateUtil.tld"%>
<title>제품완료보고서 상세</title>
<style>
.positionCenter{
	position: absolute;
	transform: translate(-50%, -45%);
}
.ck-editor__editable { max-height: 400px; min-height:400px;}
</style>

<link href="../resources/css/mfg.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="/resources/js/appr/apprClass.js?v=<%= System.currentTimeMillis()%>"></script>
<script type="text/javascript">
	$(document).ready(function(){
		//history.replaceState({}, null, location.pathname);
		
		fn.autoComplete($("#keyword"));
	});
	
	function downloadFile(idx){
		location.href = '/test/fileDownload?idx='+idx;
	}
	
	function fn_view(idx) {
		var URL = "../test/selectMaterialDataAjax";
		$.ajax({
			type:"POST",
			url:URL,
			data:{
				"idx" : idx
			},
			dataType:"json",
			async:false,
			success:function(data) {
				$("#nameTxt").html(data.data.NAME);
				$("#sapCodeTxt").html(data.data.SAP_CODE);
				$("#plantTxt").html(data.data.PLANT);
				$("#priceTxt").html(data.data.PRICE);
				$("#unitTxt").html(data.data.UNIT_NAME);
				$("#keepConditionTxt").html(data.data.KEEP_CONDITION);
				$("#sizeTxt").html(nvl(data.data.WIDTH,"0")+" / "+nvl(data.data.LENGTH,"0")+" / "+nvl(data.data.HEIGHT,"0"));
				$("#weightTxt").html(data.data.TOTAL_WEIGHT);
				$("#standardTxt").html(data.data.STANDARD);
				$("#originTxt").html(data.data.ORIGIN);
				$("#expireDateTxt").html(data.data.EXPIRATION_DATE);
				var typeName = "";
				if( chkNull(data.data.MATERIAL_TYPE_NAME1) ) {
					typeName += data.data.MATERIAL_TYPE_NAME1;
				}
				if( chkNull(data.data.MATERIAL_TYPE_NAME2) ) {
					typeName += " > "+data.data.MATERIAL_TYPE_NAME2;
				}
				if( chkNull(data.data.MATERIAL_TYPE_NAME3) ) {
					typeName += " > "+data.data.MATERIAL_TYPE_NAME3;
				}
				$("#typeTxt").html(typeName);
				var fileTypeTxt = "";
				data.fileType.forEach(function (item, index) {
					if( index == 0 ) {
						fileTypeTxt += item.FILE_TEXT
					} else {
						fileTypeTxt += ", "+item.FILE_TEXT
					}
				});
				$("#fileTypeTxt").html(fileTypeTxt);
				$("#fileDataList").html("");
				data.fileList.forEach(function (item) {
					var childTag = '<li>&nbsp;<a href="javascript:downloadFile(\''+item.FILE_IDX+'\')">'+item.ORG_FILE_NAME+'</a></li>'
					$("#fileDataList").append(childTag);
				});
				
				openDialog('open3');
			},
			error:function(request, status, errorThrown){
					alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
			}			
		});
	}
	
	function fn_erpview(code) {
		var URL = "../product/selectErpMaterialDataAjax";
		$.ajax({
			type:"POST",
			url:URL,
			data:{
				"sapCode" : code
			},
			dataType:"json",
			async:false,
			success:function(data) {
				$("#nameTxtErp").html(data.NAME);
				$("#sapCodeTxtErp").html(data.SAP_CODE);
				$("#keepConditionTxtErp").html(data.KEEP_CONDITION);
				$("#categoryErp").html(data.CATEGORY_DIV1+" > "+data.CATEGORY_DIV2);
				$("#sizeTxtErp").html(nvl(data.WIDTH,"0")+" / "+nvl(data.LENGTH,"0")+" / "+nvl(data.HEIGHT,"0"));
				$("#weightTxtErp").html(data.TOTAL_WEIGHT+""+data.TOTAL_WEIGHT_UNIT);
				$("#standardTxtErp").html(data.STANDARD);
				$("#originTxtErp").html(data.ORIGIN);
				$("#expireDateTxtErp").html(data.EXPIRATION_DATE);
				
				openDialog('open4');
			},
			error:function(request, status, errorThrown){
					alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
			}			
		});
	}
	
	function fn_list() {
		location.href = '/product/productList';
	}
	
	function fn_versionUp(idx) {
		location.href = '/product/versionUpProductForm?idx='+idx;
	}
	
	/*
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
				console.log(ui.item.userId);
				console.log(ui.item.userName);
				console.log(ui.item.deptName);
				console.log(ui.item.teamName);
				
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
				"docType" : "PROD"
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
	*/
	
	function fn_apprSubmit(){
		if( $("#apprLine option").length == 0 ) {
			alert("등록된 결재라인이 없습니다. 결재 라인 추가 후 결재상신 해 주세요.");
			return;
		} else {
			var formData = new FormData();
			formData.append("docIdx",'${productData.data.PRODUCT_IDX}');
			formData.append("apprComment", $("#apprComment").val());
			formData.append("apprLine", $("#apprLine").selectedValues());
			formData.append("refLine", $("#refLine").selectedValues());
			formData.append("title", '${productData.data.TITLE}');
			formData.append("docType", "PROD");
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
	
	/*
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
				formData.append("title", '${productData.data.TITLE}');
				formData.append("apprLineName", $("#apprLineName").val());
				formData.append("apprLine", $("#apprLine").selectedValues());
				formData.append("docType", "PROD");
				
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
					alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
				}			
			});
		}
	}	
	*/
	
	function tabChange(tabId) {
		if( tabId == 'tab1' ) {
			$("#tab1_div").show();
			$("#tab1_li").prop("class","select");
			$("#tab2_div").hide();
			$("#tab2_li").prop("class","");
		} else {
			$("#tab1_div").hide();
			$("#tab1_li").prop("class","");
			$("#tab2_div").show();
			$("#tab2_li").prop("class","select");
		}
	}
	
	function fn_update(idx) {
		location.href = '/product/productUpdateForm?idx='+idx;
	}
</script>
<div class="wrap_in" id="fixNextTag">
	<span class="path">
		제품완료보고서 상세&nbsp;&nbsp;
		<img src="/resources/images/icon_path.png" style="vertical-align: middle" />&nbsp;&nbsp;개발완료보고서&nbsp;&nbsp;
		<img src="/resources/images/icon_path.png" style="vertical-align: middle" />&nbsp;&nbsp;<a href="#none">${strUtil:getSystemName()}</a>
	</span>
	<section class="type01">
		<h2 style="position:relative">
			<span class="title_s">Complete Document</span><span class="title">제품완료보고서 상세</span>
			<div class="top_btn_box">
				<ul>
					<li>
						<c:if test="${productData.data.STATUS == 'TMP' and productData.data.IS_LAST == 'Y'}">
						<button class="btn_circle_modifiy" onclick="fn_update('${productData.data.PRODUCT_IDX}')">&nbsp;</button>
						</c:if>
						<c:if test="${productData.data.STATUS == 'COMP' and productData.data.IS_LAST == 'Y'}">
						<button class="btn_circle_version" onclick="fn_versionUp('${productData.data.PRODUCT_IDX}')">&nbsp;</button>
						</c:if>
					</li>
				</ul>
			</div>
		</h2>
		<div class="group01 mt20">
			<div class="title"><!--span class="txt">연구개발시스템 공지사항</span--></div>
			<div class="tab02">
				<ul>
					<!-- 선택됬을경우는 탭 클래스에 select를 넣어주세요 -->
					<!-- 내 제품설계서 같은경우는 change select 이렇게 change 그대로 두고 한칸 띄고 select 삽입 -->
					<a href="#" onClick="tabChange('tab1')"><li  class="select" id="tab1_li">기안내용</li></a>
					<a href="#" onClick="tabChange('tab2')"><li class="" id="tab2_li">완료보고서상세정보</li></a>
				</ul>
			</div>
			
			<div id="tab1_div">
				<div class="title2"  style="width: 80%;"><span class="txt">제목 </span></div>
				<div class="title2" style="width: 20%; display: inline-block;">						
				</div>
				<div class="main_tbl">
					<table class="tbl05" style="border-top: 2px solid #4b5165;">
						<colgroup>
							<col  />							
						</colgroup>
						<tbody>
							<tr>
								<td>
									<div class="ellipsis_txt tgnl">
									${productData.data.TITLE}
									</div>
									<input type="hidden" name="idx" id="idx" value="${productData.data.PRODUCT_IDX}"/>
									<input type="hidden" name="docNo" id="docNo" value="${productData.data.DOC_NO}"/>
									<input type="hidden" name="currentVersionNo" id="currentVersionNo" value="${productData.data.VERSION_NO}"/>
									<input type="hidden" name="currentStatus" id="currentStatus" value="${productData.data.STATUS}"/>
									<input type="hidden" name="productCode" id="productCode" value="${productData.data.PRODUCT_CODE}"/>	
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="title2"  style="width: 80%;"><span class="txt">제품명</span></div>
				<div class="title2" style="width: 20%; display: inline-block;">
				</div>
				<div class="main_tbl">
					<table class="tbl05" style="border-top: 2px solid #4b5165;">
						<colgroup>
							<col  />							
						</colgroup>
						<tbody>
							<tr>
								<td>
									<div class="ellipsis_txt tgnl">
									${productData.data.NAME}
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				
				<c:if test="${addInfoCount.PUR_CNT > 0 }">
				<div class="title2"  style="width: 80%;"><span class="txt">개발 목적</span></div>
				<div class="title2" style="width: 20%; display: inline-block;">
				</div>
				<div class="main_tbl">
					<table class="tbl05" style="border-top: 2px solid #4b5165;">
						<colgroup>
							<col  />							
						</colgroup>
						<tbody id="purpose_tbody" name="purpose_tbody">
							<c:forEach items="${addInfoList}" var="addInfoList" varStatus="status">
								<c:if test="${addInfoList.INFO_TYPE == 'PUR' }">
								<tr id="purpose_tr_${status.count}">
									<td>
										<div class="ellipsis_txt tgnl">
										${addInfoList.INFO_TEXT}
										</div>
									</td>
								</tr>
								</c:if>
							</c:forEach>
						</tbody>
					</table>
				</div>
				</c:if>
				
				<c:if test="${addInfoCount.FEA_CNT > 0 }">
				<div class="title2"  style="width: 80%;"><span class="txt">제품 특징</span></div>
				<div class="title2" style="width: 20%; display: inline-block;">
				</div>
				<div class="main_tbl">
					<table class="tbl05" style="border-top: 2px solid #4b5165;">
						<colgroup>
							<col  />							
						</colgroup>
						<tbody id="feature_tbody" name="feature_tbody">
							<c:forEach items="${addInfoList}" var="addInfoList" varStatus="status">
								<c:if test="${addInfoList.INFO_TYPE == 'FEA' }">
								<tr id="feature_tr_${status.count}">
									<td>
										<div class="ellipsis_txt tgnl">
										${addInfoList.INFO_TEXT}
										</div>
									</td>
								</tr>
								</c:if>
							</c:forEach>
						</tbody>
					</table>
				</div>
				</c:if>
				
				<c:if test="${fn:length(imporvePurposeList) > 0 }">
					<div class="title2" style="float: left; margin-top: 30px;">
						<span class="txt">개선 목적</span>
					</div>
					<table id="improve_pur_Table" class="tbl01">
						<colgroup>
							<col width="30%">
							<col width="30%">
							<col />
						</colgroup>
						<thead>
							<tr>
								<th>개선</th>
								<th>기존</th>
								<th>비고</th>
							</tr>
						</thead>
						<tbody id="improve_pur_tbody" name="improve_pur_tbody">
							<c:forEach items="${imporvePurposeList}" var="imporvePurposeList" varStatus="status">
								<tr id="improve_pur_tr__${status.count}" class="temp_color">
									<td>
										${imporvePurposeList.IMPROVE}
									</td>
									<td>
										${imporvePurposeList.EXIST}
									</td>
									<td>
										${imporvePurposeList.NOTE}
									</td>
								</tr>
							</c:forEach>	
						</tbody>
						<tfoot>
						</tfoot>
					</table>
				</c:if>
				
				<c:if test="${addInfoCount.IMP_CNT > 0 }">
				<div class="title2"  style="width: 80%;"><span class="txt">개선 사항</span></div>
				<div class="title2" style="width: 20%; display: inline-block;">
				</div>
				<div class="main_tbl">
					<table class="tbl05" style="border-top: 2px solid #4b5165;">
						<colgroup>
							<col  />							
						</colgroup>
						<tbody id="feature_tbody" name="feature_tbody">
							<c:forEach items="${addInfoList}" var="addInfoList" varStatus="status">
								<c:if test="${addInfoList.INFO_TYPE == 'IMP' }">
								<tr id="feature_tr_${status.count}">
									<td>
										<div class="ellipsis_txt tgnl">
										${addInfoList.INFO_TEXT}
										</div>
									</td>
								</tr>
								</c:if>
							</c:forEach>
						</tbody>
					</table>
				</div>
				</c:if>
				
				
				<div class="title2"  style="width: 80%;"><span class="txt">용도</span></div>
				<div class="title2" style="width: 20%; display: inline-block;">
				</div>
				
				<div id="">
					<div class="title2" style="float: left; margin-top: 30px;">
						<span class="txt">신규도입품/제품규격</span>
					</div>
					<table id="new_Table" class="tbl01" style="border-bottom: 2px solid #4b5165;">
						<colgroup>
							<col width="140">
							<col width="140">
							<col width="250">
							<col width="150">
							<col />
						</colgroup>
						<thead>
							<tr>
								<th>제품명</th>
								<th>포장규격</th>
								<th>공급처 및 담당자</th>
								<th>보관조건 및 소비기한</th>
								<th>비고</th>
							</tr>
						</thead>
						<tbody id="new_tbody" name="new_tbody">
							<c:forEach items="${newDataList}" var="newDataList" varStatus="status">
								<tr id="new_tr_${status.count}" class="temp_color">
									<td>
										${newDataList.PRODUCT_NAME}
									</td>
									<td>
										${newDataList.PACKAGE_STANDARD}
									</td>
									<td>
										${newDataList.SUPPLIER}
									</td>
									<td>${newDataList.KEEP_EXP}</td>
									<td>${newDataList.NOTE}</td>
								</tr>
							</c:forEach>							
						</tbody>
					</table>
				</div>
				
				<div class="title2"  style="width: 80%;"><span class="txt">도입 예정일</span></div>
				<div class="title2" style="width: 20%; display: inline-block;">
				</div>
				<div class="main_tbl">
					<table class="tbl05" style="border-top: 2px solid #4b5165;">
						<colgroup>
							<col  />							
						</colgroup>
						<tbody>
							<tr>
								<td>
									<div class="ellipsis_txt tgnl">
									${productData.data.SCHEDULE_DATE}
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				
				<div class="title2 mt20"  style="width:90%;"><span class="txt">첨부파일</span></div>
				<div class="con_file" style="">
					<ul>
						<li class="point_img">
							<dt>첨부파일</dt><dd>
								<ul>
									<c:forEach items="${productData.fileList}" var="fileList" varStatus="status">
										<li>&nbsp;<a href="javascript:downloadFile('${fileList.FILE_IDX}')">${fileList.ORG_FILE_NAME}</a></li>
									</c:forEach>
								</ul>
							</dd>
						</li>
					</ul>
				</div>
				
			</div>
			<div id="tab2_div" style="display:none">
				<div class="title2"  style="width: 80%;"><span class="txt">기본정보</span></div>
				<div class="title2" style="width: 20%; display: inline-block;">
					
				</div>
				<div class="main_tbl">
					<table class="insert_proc01" style="border-bottom: 2px solid #4b5165;">
						<colgroup>
							<col width="15%" />
							<col width="35%" />
							<col width="15%" />
							<col width="35%" />
						</colgroup>
						<tbody>
							<c:if test="${productData.data.IS_LAST == 'Y' and productData.data.STATUS == 'REG' }">
							<tr>
								<th style="border-left: none;">결재라인</th>
								<td colspan="3">
									<button class="btn_small_search ml5" onclick="apprClass.openApprovalDialog()" style="float: left">결재</button>
								</td>
							</tr>
							</c:if>
							<tr>
								<th style="border-left: none;">제품코드</th>
								<td>
									${productData.data.PRODUCT_CODE}
								</td>
								<th style="border-left: none;">상품코드</th>
								<td>
									${productData.data.SAP_CODE}
								</td>
							</tr>
							<tr>
								<th style="border-left: none;">버젼 No.</th>
								<td colspan="3">
									${productData.data.VERSION_NO}
								</td>
							</tr>
							<tr>
								<th style="border-left: none;">중량</th>
								<td>
									${productData.data.TOTAL_WEIGHT}
								</td>
								<th style="border-left: none;">제품규격</th>
								<td>
									${productData.data.STANDARD}								
								</td>
								
							</tr>
							<tr>
								<th style="border-left: none;">보관방법</th>
								<td>
									${productData.data.KEEP_CONDITION}	
								</td>
								<th style="border-left: none;">소비기한</th>
								<td>
									${productData.data.EXPIRATION_DATE}									
								</td>							
							</tr>
							<tr>
								<th style="border-left: none;">제품유형</th>
								<td colspan="5">
									<c:if test="${productData.data.PRODUCT_TYPE1 != null }">
									${productData.data.PRODUCT_TYPE_NAME1}
									</c:if>
									<c:if test="${productData.data.PRODUCT_TYPE2 != null }">
									&gt; ${productData.data.PRODUCT_TYPE_NAME2}
									</c:if>
									<c:if test="${productData.data.PRODUCT_TYPE3 != null }">
									&gt; ${productData.data.PRODUCT_TYPE_NAME3}
									</c:if>
								</td>
							</tr>
							<tr>
								<th style="border-left: none;">첨부파일 유형</th>
								<td colspan="3">
									<c:forEach items="${productData.fileType}" var="fileType" varStatus="status">
										<c:if test="${status.index != 0 }">
										,
										</c:if>
										${fileType.FILE_TEXT}
									</c:forEach>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<c:if test="${productData.data.IS_NEW_MATERIAL == 'Y' }">
				<div class="title2" style="float: left; margin-top: 30px;">
					<span class="txt">신규원료</span>
				</div>
				<div class="main_tbl">				
					<table class="tbl01 " style="border-bottom: 2px solid #4b5165;">
						<colgroup>
							<col width="140">
							<col width="140">
							<col width="250">
							<col width="150">
							<col width="200">
							<col width="8%">
							<col />
						</colgroup>
						<thead>
							<tr>
								<th>원료코드</th>
								<th>ERP코드</th>
								<th>원료명</th>
								<th>규격</th>
								<th>보관방법 및 유통기한</th>
								<th>공급가</th>
								<th>비고</th>
							</tr>
						</thead>
						<tbody>
						<c:forEach items="${productMaterialData}" var="productMaterialData" varStatus="status">
						<c:if test="${productMaterialData.MATERIAL_TYPE == 'Y' }">
							<tr>
								<td>
									<div class=""><a href="#" onClick="fn_view('${productMaterialData.MATERIAL_IDX}')">${productMaterialData.MATERIAL_CODE}</a></div>
								</td>
								<td>
									${productMaterialData.SAP_CODE}
								</td>
								<td>
									${productMaterialData.NAME}
								</td>
								<td>
									${productMaterialData.STANDARD}
								</td>
								<td>
									${productMaterialData.KEEP_EXP}
								</td>
								<td>
									${productMaterialData.UNIT_PRICE}
								</td>
								<td>
									${productMaterialData.DESCRIPTION}
								</td>
							</tr>
						</c:if>	
						</c:forEach>	
						</tbody>
						<tfoot>
						</tfoot>
					</table>
				</div>
				</c:if>
				
				<div class="title2" style="float: left; margin-top: 30px;">
					<span class="txt">원료</span>
				</div>
				<div class="main_tbl">				
					<table class="tbl01 " style="border-bottom: 2px solid #4b5165;">
						<colgroup>
							<col width="140">
							<col width="140">
							<col width="250">
							<col width="150">
							<col width="200">
							<col width="8%">
							<col />
						</colgroup>
						<thead>
							<tr>
								<th>원료코드</th>
								<th>ERP코드</th>
								<th>원료명</th>
								<th>규격</th>
								<th>보관방법 및 유통기한</th>
								<th>공급가</th>
								<th>비고</th>
							</tr>
						</thead>
						<tbody>
						<c:forEach items="${productMaterialData}" var="productMaterialData" varStatus="status">
						<c:if test="${productMaterialData.MATERIAL_TYPE == 'N' }">
							<tr>
								<td>
									<div class=""><a href="#" onClick="fn_erpview('${productMaterialData.SAP_CODE}')">${productMaterialData.MATERIAL_CODE}</a></div>
								</td>
								<td>
									<a href="#" onClick="fn_erpview('${productMaterialData.SAP_CODE}')">${productMaterialData.SAP_CODE}</a>
								</td>
								<td>
									${productMaterialData.NAME}
								</td>
								<td>
									${productMaterialData.STANDARD}
								</td>
								<td>
									${productMaterialData.KEEP_EXP}
								</td>
								<td>
									${productMaterialData.UNIT_PRICE}
								</td>
								<td>
									${productMaterialData.DESCRIPTION}
								</td>
							</tr>
						</c:if>	
						</c:forEach>	
						</tbody>
						<tfoot>
						</tfoot>
					</table>
				</div>
				
				<div class="title2 mt20"  style="width:90%;"><span class="txt">비고</span></div>
				<div>
					<table class="insert_proc01" style="border-bottom: 2px solid #4b5165;">
						<tr>
							<td>${productData.data.CONTENTS}</td>
						</tr>
					</table>
				</div>
			</div>
			<div class="main_tbl">
				<div class="btn_box_con5">					
				</div>
				<div class="btn_box_con4">
					<c:if test="${productData.data.STATUS == 'TMP' and productData.data.IS_LAST == 'Y'}">
						<button class="btn_admin_sky" onclick="fn_update('${productData.data.PRODUCT_IDX}')">수정</button>
					</c:if>	
					<button class="btn_admin_gray" onClick="fn_list();" style="width: 120px;">목록</button>
				</div>
				<hr class="con_mode" />
			</div>
			
		</div>
	</section>
</div>

<!-- 자재조회 레이어 start-->
<div class="white_content" id="open3">
	<div class="modal" style="	width: 700px;margin-left:-350px;height: 780px;margin-top:-400px;">
		<h5 style="position:relative">
			<span class="title">원료 상세 정보</span>
			<div  class="top_btn_box">
				<ul>
					<li>
						<button class="btn_madal_close" onClick="closeDialog('open3')"></button>
					</li>
				</ul>
			</div>
		</h5>
		<div class="list_detail">
			<ul>
				<li class="pt10">
					<dt>원료명</dt>
					<dd>
						 <div id="nameTxt"></div>
					</dd>
				</li>
				<li>
					<dt>SAP 코드</dt>
					<dd>
						<div id="sapCodeTxt"></div>
					</dd>
				</li>
				<li>
					<dt>단가</dt>
					<dd>
						<div id="priceTxt"></div>
					</dd>
				</li>
				<li>
					<dt>단위</dt>
					<dd>
						<div id="unitTxt"></div>
					</dd>
				</li>
				<li>
					<dt>보관기준</dt>
					<dd>
						<div id="keepConditionTxt"></div>
					</dd>
				</li>
				<li>
					<dt>사이즈</dt>
					<dd>
						<div id="sizeTxt"></div>
					</dd>
				</li>
				<li>
					<dt>중량</dt>
					<dd>
						<div id="weightTxt"></div>
					</dd>
				</li>
				<li>
					<dt>규격</dt>
					<dd>
						<div id="standardTxt"></div>
					</dd>
				</li>
				<li>
					<dt>원산지</dt>
					<dd>
						<div id="originTxt"></div>
					</dd>
				</li>
				<li>
					<dt>유통기한</dt>
					<dd>
						<div id="expireDateTxt"></div>
					</dd>
				</li>
				<li>
					<dt>원료구분상세</dt>
					<dd>
						<div id="typeTxt"></div>
					</dd>
				</li>
				<li>
					<dt>첨부파일 유형</dt>
					<dd>
						<div id="fileTypeTxt"></div>
					</dd>
				</li>
				<li>
					<div class="add_file2" style="width:97.5%">
						<span class="" >
							<label>첨부파일</label>
						</span>						
					</div>
					<div class="file_box_pop" style=" height:120px; width:97.5%; border-top-left-radius:0px;border-top-right-radius:0px; border-top:1px solid #ddd;box-sizing:border-box;">
						<ul id="fileDataList">									
						</ul>
					</div>
				</li>
			</ul>
		</div>
		<div class="btn_box_con">
			<button class="btn_admin_gray" onclick="closeDialog('open3')"> 닫기</button>
		</div>
	</div>
</div>
<!-- 자재조회 레이어 close-->

<!-- 자재조회 레이어 start-->
<div class="white_content" id="open4">
	<div class="modal" style="	width: 700px;margin-left:-350px;height: 520px;margin-top:-400px;">
		<h5 style="position:relative">
			<span class="title">원료 상세 정보</span>
			<div  class="top_btn_box">
				<ul>
					<li>
						<button class="btn_madal_close" onClick="closeDialog('open4')"></button>
					</li>
				</ul>
			</div>
		</h5>
		<div class="list_detail">
			<ul>
				<li class="pt10">
					<dt>원료명</dt>
					<dd>
						 <div id="nameTxtErp"></div>
					</dd>
				</li>
				<li>
					<dt>SAP 코드</dt>
					<dd>
						<div id="sapCodeTxtErp"></div>
					</dd>
				</li>
				<li>
					<dt>보관기준</dt>
					<dd>
						<div id="keepConditionTxtErp"></div>
					</dd>
				</li>
				<li>
					<dt>원료유형</dt>
					<dd>
						<div id="categoryErp"></div>
					</dd>
				</li>
				<li>
					<dt>사이즈(W/L/H)</dt>
					<dd>
						<div id="sizeTxtErp"></div>
					</dd>
				</li>
				<li>
					<dt>중량</dt>
					<dd>
						<div id="weightTxtErp"></div>
					</dd>
				</li>
				<li>
					<dt>규격</dt>
					<dd>
						<div id="standardTxtErp"></div>
					</dd>
				</li>
				<li>
					<dt>원산지</dt>
					<dd>
						<div id="originTxtErp"></div>
					</dd>
				</li>
				<li>
					<dt>유통기한</dt>
					<dd>
						<div id="expireDateTxtErp"></div>
					</dd>
				</li>
			</ul>
		</div>
		<div class="btn_box_con">
			<button class="btn_admin_gray" onclick="closeDialog('open4')"> 닫기</button>
		</div>
	</div>
</div>
<!-- 자재조회 레이어 close-->

<!-- 결재 상신 레이어  start-->
<div class="white_content" id="approval_dialog">
	<input type="hidden" id="docType" value="TRIP"/>
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
				<ul><li><button class="btn_madal_close" onClick="apprClass.apprCancel(); return false;"></button></li></ul>
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
						<button class="btn_small01 ml5" onclick="apprClass.approvalAddLine(this); return false;" name="appr_add_btn" id="appr_add_btn">결재자 추가</button>
						<button class="btn_small02  ml5" onclick="apprClass.approvalAddLine(this); return false;" name="ref_add_btn" id="ref_add_btn">참조</button>
						<div class="selectbox ml5" style="width:180px;">
							<label for="apprLineSelect" id="apprLineSelect_label">---- 결재라인 불러오기 ----</label>
							<select id="apprLineSelect" name="apprLineSelect" onchange="apprClass.changeApprLine(this);">
								<option value="">---- 결재라인 불러오기 ----</option>
							</select>
						</div>
						<button class="btn_small02  ml5" onclick="apprClass.deleteApprovalLine(this); return false;">선택 결재라인 삭제</button>
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
							<button class="btn_doc" onclick="apprClass.approvalLineSave(this);  return false;"><img src="../resources/images/icon_doc11.png"> 저장</button> 
							<button class="btn_doc" onclick="apprClass.apprLineSaveCancel(this); return false;"><img src="../resources/images/icon_doc04.png">취소</button>
						</div>
						<!-- 현재 추가된 결재선 저장 버튼 눌렀을때 보이게 처리 close -->
					</dd>
				</li>
			</ul>
		</div>
		<div class="btn_box_con4" style="padding:15px 0 20px 0">
			<button class="btn_admin_red" onclick="fn_apprSubmit(); return false;">결재등록</button> 
			<button class="btn_admin_gray" onclick="apprClass.apprCancel(); return false;">결재삭제</button>
		</div>
	</div>
</div>
<!-- 결재 상신 레이어  close-->