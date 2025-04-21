<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="kr.co.aspn.util.*" %>
<%@ taglib prefix="userUtil" uri="/WEB-INF/tld/userUtil.tld"%>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ taglib prefix="dateUtil" uri="/WEB-INF/tld/dateUtil.tld"%>
<title>상품설계변경 보고서 생성</title>
<style>
.positionCenter{
	position: absolute;
	transform: translate(-50%, -45%);
}
.ck-editor__editable { max-height: 400px; min-height:400px;}
</style>

<link href="../resources/css/mfg.css" rel="stylesheet" type="text/css">

<script type="text/javascript">
	$(document).ready(function(){
		CreateEditor("contents");
	});
	
	function addRow(element, type){
		
		var randomId = randomId = Math.random().toString(36).substr(2, 9);
		var randomId2 = randomId = Math.random().toString(36).substr(2, 9);
		var row= '<tr>'+$('tbody[name=tmpChangeTbody]').children('tr').html()+'</tr>';

		$(element).parent().parent().next().children('tbody').append(row);
		var bodyId = $(element).parent().parent().next().children('tbody').attr('id').split('_')[1];
		$(element).parent().parent().next().children('tbody').children('tr:last').attr('id', type + 'Row_' + randomId);
		$(element).parent().parent().next().children('tbody').children('tr:last').children('td').children('input[type=checkbox]').attr('id', type+'_'+randomId);
		$(element).parent().parent().next().children('tbody').children('tr:last').children('td').children('label').attr('for', type+'_'+randomId);
		$(element).parent().parent().next().children('tbody').children('tr:last').children('td').children('input[name=itemType]').val("N");
		//var itemSapCodeElement = $(element).parent().parent().next().children('tbody').children('tr:last').children('td').children('input[name=itemSapCode]');
		//bindEnterKeySapCode(itemSapCodeElement);
	}
	
	function removeRow(element){
		var tbody = $(element).parent().parent().next().children('tbody');
		var checkboxArr = tbody.children('tr').children('td').children('input[type=checkbox]').toArray();
		
		var checkedCnt = 0;
		var checkedId;
		checkboxArr.forEach(function(v, i){
			if($(v).is(':checked')){
				checkedCnt++;
			}
		});
		
		if(checkedCnt == 0) return alert('삭제하실 항목을 선택해주세요');
		
		$(element).parent().parent().next().children('tbody').children('tr').toArray().forEach(function(v, i){
			var checkBoxId = $(v).children('td:first').children('input[type=checkbox]')[0].id;
			if($('#'+checkBoxId).is(':checked')) $(v).remove();
		})
	}
	
	function moveUp(element){
		var tbody = $(element).parent().parent().next().children('tbody');
		var checkboxArr = tbody.children('tr').children('td').children('input[type=checkbox]').toArray();
		
		var checkedCnt = 0;
		var checkedId;
		checkboxArr.forEach(function(v, i){
			if($(v).is(':checked')){
				checkedCnt++;
			}
		});
		
		if(checkedCnt == 0) return alert('이동시키려는 열을 선택해주세요');
		
		if(checkedCnt > 1) return alert('열을 이동하는 하는 경우에는 1개의 열만 선택해주세요');
		
		
		checkboxArr.forEach(function(v, i){
			if($(v).is(':checked')){
				checkedId = v.id
				
				var $element = $('#'+checkedId).parent().parent();
				$element.prev().before($element);
			}
		});
	}
	
	function moveDown(element){
		var tbody = $(element).parent().parent().next().children('tbody');
		var checkboxArr = tbody.children('tr').children('td').children('input[type=checkbox]').toArray();
		
		var checkedCnt = 0;
		var checkedId;
		
		checkboxArr.reverse().forEach(function(v, i){
			if($(v).is(':checked')){
				checkedCnt++;
			}
		});
		
		if(checkedCnt == 0) return alert('이동시키려는 열을 선택해주세요');
		
		if(checkedCnt > 1) return alert('열을 이동하는 하는 경우에는 1개의 열만 선택해주세요');
		
		
		checkboxArr.reverse().forEach(function(v, i){
			if($(v).is(':checked')){
				checkedId = v.id
				
				var $element = $('#'+checkedId).parent().parent();
				$element.next().after($element);
			}
		});
	}
	
	function checkAll(e){
		var tbody = $(e.target).parent().parent().parent().next();
		tbody.children('tr').children('td').children('input[type=checkbox]').toArray().forEach(function(checkbox){
			if(e.target.checked)
				checkbox.checked = true;
			else 
				checkbox.checked = false;
		})
	}
	
	function fn_insert() {
		
	}
	
	function CreateEditor(editorId) {
	    ClassicEditor
	        .create(document.getElementById(editorId), {
				language: 'ko',
	        }).then( editor => {
	        	window.editor = editor;
	    		console.log( editor );
	    	}).catch( error => {
	    		console.error( error );
	    	});
	}
	
	/* 파일첨부 관련 함수 START */
	var attatchFileArr = [];
	var attatchFileTypeArr = [];
	var attatchTempFileArr = [];
	var attatchTempFileTypeArr = [];
	function callAddFileEvent(){
		$('#attatch_common').click();
	}
	function setFileName(element){
		if(element.files.length > 0)
			$(element).parent().children('input[type=text]').val(element.files[0].name);
		else 
			$(element).parent().children('input[type=text]').val('');
	}
	function addFile(element, fileType){
		var randomId = Math.random().toString(36).substr(2, 9);
		
		if($('#attatch_common').val() == null || $('#attatch_common').val() == ''){
			return alert('파일을 선택해주세요');
		}
		
		fileElement = document.getElementById('attatch_common');
		
		var file = fileElement.files;
		var fileName = file[0].name
		var fileTypeText = $(element).text();
		var isDuple = false;
		attatchTempFileArr.forEach(function(file){
			if(file.name == fileName)
				isDuple = true;
		})
		
		attatchFileArr.forEach(function(file){
			if(file.name == fileName)
				isDuple = true;
		})
		
		if(isDuple){
			if(!confirm('같은 이름의 파일이 존재합니다. 계속 진행하시겠습니까?')){
				return;
			};
		}
		
		if( !checkFileName(fileName) ) {			
			return;
		}
		
		
		
		attatchTempFileArr.push(file[0]);
		attatchTempFileArr[attatchTempFileArr.length-1].tempId = randomId;
		attatchTempFileTypeArr.push({fileType: fileType, fileTypeText: fileTypeText, tempId: randomId});
		
		var childTag = '<li><a href="#none" onclick="removeFile(this, \''+randomId+'\')"><img src="/resources/images/icon_del_file.png"></a>&nbsp;'+fileName+'</li>'
		$('ul[name=popFileList]').append(childTag);
		$('#attatch_common').val('');
		$('#attatch_common').change();
	}
	
	function removeFile(element, tempId){
		$(element).parent().remove();
		attatchFileArr = attatchFileArr.filter(function(file){
			if(file.tempId != tempId) {
				return file;
			}
		})
		attatchFileTypeArr = attatchFileTypeArr.filter(function(typeObj){
			if(typeObj.tempId != tempId) 
				return typeObj;
		});
		
		if( $("#attatch_file").children().length == 0 ) {
			$("#docTypeTemp").removeOption(/./);
			$("#docTypeTxt").html("");
		}
		//console.log($("#attatch_file").children().length);
	}
	
	
	function uploadFiles(){
		if( attatchTempFileArr.length == 0 ) {
			alert("파일을 등록해주세요.");
			return;
		}
		
		attatchTempFileArr.forEach(function(tempFile, idx1){
			attatchFileArr.push(tempFile);
			attatchFileTypeArr.push(attatchTempFileTypeArr[idx1]);		
		});
		
		$("#attatch_file").html("");
		attatchFileTypeArr.forEach(function(object,idx){
			var tempId = object.tempId;
			var childTag = '<li><a href="#none" onclick="removeFile(this, \''+tempId+'\')"><img src="/resources/images/icon_del_file.png"></a>'+attatchFileArr[idx].name+'</li>'
			$("#attatch_file").append(childTag);
		});
		
		$("#docTypeTemp").removeOption(/./);
		var docTypeTxt = "";
		$('input:checkbox[name=docType]').each(function (index) {
			if($(this).is(":checked")==true){
		    	$("#docTypeTemp").addOption($(this).val(), $(this).next("label").text(), true);
		    	//if( index != 0 ) {
	    		if( docTypeTxt != "" ){
	    			docTypeTxt += ", ";
	    		}
	    		docTypeTxt += $(this).next("label").text();
		    	//} else {
		    	//	docTypeTxt += $(this).next("label").text();
		    	//}
		    }
		});
		$("#docTypeTxt").html(docTypeTxt);
		closeDialogWithClean('dialog_attatch');
	}
	
	function checkFileName(str){
		var result = true;
	    //1. 확장자 체크
	    var ext =  str.split('.').pop().toLowerCase();
	    if($.inArray(ext, ['pdf']) == -1) {
	    	var message = "";
	    	message += ext+'파일은 업로드 할 수 없습니다.';
	    	//message += "\n";
	    	message += "(pdf 만 가능합니다.)";
	        alert(message);
	        result = false;
	    }
	    return result;
	}
	
	function closeDialogWithClean(dialogId){
		initDialog();
		closeDialog(dialogId);
	}
	
	function initDialog(){
		// 파일첨부
		attatchTempFileArr = [];
		attatchTempFileTypeArr = [];
		$('ul[name=popFileList]').empty();
		$('#attatch_common_text').val('');
		$('#attatch_common').val('')
	}
	
	//입력확인
	function fn_update(){
		var contents = editor.getData();
		if( !chkNull($("#title").val()) ) {
			alert("제목을 입력해 주세요.");
			$("#title").focus();
			return;
		} /*else if( !chkNull($("#productCode").val()) ) {
			alert("제품 코드를 입력해 주세요.");
			$("#productCode").focus();
			return;
		}*/ else if( !chkNull($("#productName").val()) ) {
			alert("제품명을 입력해 주세요.");
			$("#productName").focus();
			return;
		} else if( !chkNull($("#changeComment").val()) ) {
			alert("변경사유를 입력해 주세요.");
			$("#changeComment").focus();
			return;
		} else if( !chkNull($("#changeTime").val()) ) {
			alert("변경시점을 입력해 주세요.");
			$("#changeTime").focus();
			return;
		} else if( $("#temp_attatch_file").children("li").length == 0 && attatchFileArr.length == 0 ) {
			alert("첨부파일을 등록해주세요.");		
			return;
		} else if( !chkNull(contents) ) {
			alert("기안문을 작성해주세요.");		
			return;
		} else {
			var rowCount = 0;
			var validData = true;
			$('tr[id^=changeRow]').toArray().forEach(function(contRow){
				var rowId = $(contRow).attr('id');
				var itemDiv = $('#'+ rowId + ' input[name=itemDiv]').val();
				var itemCurrent = $('#'+ rowId + ' textarea[name=itemCurrent]').val();
				var itemChange = $('#'+ rowId + ' textarea[name=itemChange]').val();
				var itemNote = $('#'+ rowId + ' input[name=itemNote]').val();
				
				if(itemDiv.length <= 0){
					validData = false;
					return;
				}
				if(itemCurrent.length <= 0){
					validData = false;
					return;
				}
				if(itemChange.length <= 0){
					validData = false;
					return;
				}
				if(itemNote.length <= 0){
					validData = false;
					return;
				}
				rowCount++;
			});
			if( rowCount == 0 || !validData) {
				alert('변경사항을 입력해주세요.');
				return;
			}
			
			
			var formData = new FormData();
			formData.append("idx",$("#idx").val());
			formData.append("currentStatus",$("#currentStatus").val());
			formData.append("title",$("#title").val());
			formData.append("productCode",$("#productCode").val());
			formData.append("productSapCode",$("#productSapCode").val());
			formData.append("productName",$("#productName").val());
			formData.append("changeComment",$("#changeComment").val());
			formData.append("changeTime",$("#changeTime").val());
			formData.append("contents",contents);
			
			for (var i = 0; i < attatchFileArr.length; i++) {
				formData.append('file', attatchFileArr[i])
			}
			
			for (var i = 0; i < attatchFileTypeArr.length; i++) {
				formData.append('fileTypeText', attatchFileTypeArr[i].fileTypeText)			
			}
			
			for (var i = 0; i < attatchFileTypeArr.length; i++) {
				formData.append('fileType', attatchFileTypeArr[i].fileType)			
			}
			
			var rowIdArr = new Array();
			var itemDivArr = new Array();
			var itemCurrentArr = new Array();
			var itemChangeArr = new Array();
			var itemNoteArr = new Array();
			
			$('tr[id^=changeRow]').toArray().forEach(function(contRow){
				var rowId = $(contRow).attr('id');
				var itemDiv = $('#'+ rowId + ' input[name=itemDiv]').val();
				var itemCurrent = $('#'+ rowId + ' textarea[name=itemCurrent]').val();
				var itemChange = $('#'+ rowId + ' textarea[name=itemChange]').val();
				var itemNote = $('#'+ rowId + ' input[name=itemNote]').val();
				
				rowIdArr.push(rowId);
				itemDivArr.push(itemDiv);
				itemCurrentArr.push(itemCurrent);
				itemChangeArr.push(itemChange);
				itemNoteArr.push(itemNote);
			});
			
			formData.append("rowIdArr", rowIdArr);
			formData.append("itemDivArr", itemDivArr);
			formData.append("itemCurrentArr", itemCurrentArr);
			formData.append("itemChangeArr", itemChangeArr);
			formData.append("itemNoteArr", itemNoteArr);
			
			
			URL = "../report2/updateDesignAjax";
			$.ajax({
				type:"POST",
				url:URL,
				data: formData,
				processData: false,
		        contentType: false,
		        cache: false,
				dataType:"json",
				success:function(result) {
					console.log(result);
					if( result.RESULT == 'S' ) {
						alert("수정되었습니다.");
						fn_goList();
					} else {
						alert("오류가 발생하였습니다.\n"+result.MESSAGE);
					}
				},
				error:function(request, status, errorThrown){
					alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
				}			
			});
		}
	}

	function fn_goList() {
		location.href = '/report2/designList';
	}
	
	function fn_removeTempFile(element, tempId){
		//서버의 파일을 삭제한다.
		var URL = '/file/deleteFile2Ajax';
		$.ajax({
			type:"POST",
			url:URL,
			data: {
				"fileIdx": tempId
			},
			dataType:"json",
			success:function(result) {
				if( result.RESULT == 'S' ) {
					$(element).parent().remove();
				} else {
					alert("오류가 발생하였습니다.\n"+result.MESSAGE);
				}
			},
			error:function(request, status, errorThrown){
				alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
			}			
		});
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
						<button class="btn_circle_save" onclick="fn_update()">&nbsp;</button>
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
							<td colspan="5"><input type="text" name="title" id="title" style="width: 90%;" class="req" value="${designData.data.TITLE}"/></td>
						</tr>
						<tr>
							<th style="border-left: none;">상품코드</th>
							<td>
								<input type="hidden" name="idx" id="idx" value="${designData.data.DESIGN_IDX}"/>
								<input type="hidden" name="currentStatus" id="currentStatus" value="${designData.data.STATUS}"/>
								<input type="text"  style="width:200px; float: left" class="req" name="productCode" id="productCode" placeholder="코드를 생성 하세요." value="${designData.data.PRODUCT_CODE}" readonly/>
								<button class="btn_small_search ml5" onclick="selectNewCode()" style="float: left">조회</button>
							</td>
							<th style="border-left: none;">ERP코드</th>
							<td>
								<input type="text"  style="width:200px; float: left" class="req" name="productSapCode" id="productSapCode" placeholder="코드를 조회 하세요." value="${designData.data.SAP_CODE}" readonly/>
								<button class="btn_small_search ml5" onclick="openDialog('dialog_erpMaterial')" style="float: left">조회</button>
								<button class="btn_small_search ml5" onclick="fn_initForm()" style="float: left">초기화</button>
							</td>
						</tr>
						<tr>
							<th style="border-left: none;">제품명</th>
							<td colspan="3">
								<input type="text"  style="width:350px; float: left" class="req" name="productName" id="productName" value="${designData.data.PRODUCT_NAME}"/>
							</td>
						</tr>
						<tr>
							<th style="border-left: none;">변경사유</th>
							<td colspan="3">
								<textarea style="width:100%; height:50px" placeholder="변경사유를 입력하세요" name="changeComment" id="changeComment">${designData.data.CHANGE_COMMENT}</textarea>
							</td>
						</tr>
						<tr>
							<th style="border-left: none;">변경시점</th>
							<td colspan="3">
								<input type="text"  style="width:350px; float: left" class="req" name="changeTime" id="changeTime" value="${designData.data.CHANGE_TIME}"/>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			
			<div class="title2" style="float: left; margin-top: 30px;">
				<span class="txt">변경사항</span>
			</div>
			<div id="headerDiv" class="table_header07">
				<span class="table_order_btn"><button class="btn_up" onclick="moveUp(this)"></button><button class="btn_down" onclick="moveDown(this)"></button></span>
				<span class="table_header_btn_box">
					<button class="btn_add_tr" onclick="addRow(this, 'change')" id="matNew_add_btn"></button><button class="btn_del_tr" onclick="removeRow(this)"></button>
				</span>
			</div>
			<table id="changeTable" class="tbl05">
				<colgroup>
					<col width="20">
					<col width="15%">
					<col width="34%">
					<col />
					<col width="15%">
				</colgroup>
				<thead>
					<tr>
						<th><input type="checkbox" id="changeTable_2" onclick="checkAll(event)"><label for="changeTable_2"><span></span></label></th>
						<th>구분</th>
						<th>기존</th>
						<th>변경</th>
						<th>비고</th>
					</tr>
				</thead>
				<tbody id="changeTbody" name="changeTbody">
				<c:forEach items="${designChangeList}" var="designChangeList" varStatus="status">
					<tr id="changeRow_${status.count}" class="temp_color">
						<td>
							<input type="checkbox" id="change_${status.count}"><label for="change_${status.count}"><span></span></label>
						</td>
						<td>
							<input type="text" name="itemDiv" style="width: 99%" class="req code_tbl" value="${designChangeList.ITEM_DIV}"/>							
						</td>
						<td>
							<textarea style="width:95%; height:50px" placeholder="기존정보를 입력하세요." name="itemCurrent" id="itemCurrent" class="req code_tbl">${designChangeList.ITEM_CURRENT}</textarea>
						</td>
						<td>
							<textarea style="width:95%; height:50px" placeholder="변경정보를 입력하세요." name="itemChange" id="itemChange" class="req code_tbl">${designChangeList.ITEM_CHANGE}</textarea>
						</td>
						<td>
							<input type="text" name="itemNote" style="width: 99%" class="req code_tbl" value="${designChangeList.ITEM_NOTE}"/>
						</td>
					</tr>
				</c:forEach>	
				</tbody>
			</table>
			
			<div class="title2 mt20"  style="width:90%;"><span class="txt">파일첨부</span></div>
			<div class="title2 mt20" style="width:10%; display: inline-block;">
				<button class="btn_con_search" onClick="openDialog('dialog_attatch')">
					<img src="/resources/images/icon_s_file.png" />파일첨부 
				</button>
			</div>
			<div class="con_file" style="">
				<ul>
					<li class="point_img">
						<dt>첨부파일</dt><dd>
							<ul id="temp_attatch_file">
								<c:forEach items="${designData.fileList}" var="fileList" varStatus="status">
									<li><a href="#none" onclick="fn_removeTempFile(this, '${fileList.FILE_IDX}')"><img src="/resources/images/icon_del_file.png"></a>&nbsp;<a href="javascript:downloadFile('${fileList.FILE_IDX}')">${fileList.ORG_FILE_NAME}</a></li>
								</c:forEach>
							</ul>
							<ul id="attatch_file">								
							</ul>
						</dd>
					</li>
				</ul>
			</div>
			
			<div class="title2 mt20"  style="width:90%;"><span class="txt">기안문</span></div>
			<div class="main_tbl">
				<ul>
					<li class="">
						<div class="text_insert" style="padding: 0px;">
							<textarea name="contents" id="contents" style="width: 666px; height: 200px; display: none;">${designData.data.CONTENTS}</textarea>
							<script type="text/javascript" src="/resources/editor/build/ckeditor.js"></script>
						</div>
					</li>
				</ul>
			</div>
				
			<div class="main_tbl">
				<div class="btn_box_con5">
					<button class="btn_admin_gray" onClick="fn_goList();" style="width: 120px;">목록</button>
				</div>
				<div class="btn_box_con4">
					<!-- 
					<button class="btn_admin_red">임시/템플릿저장</button>
					<button class="btn_admin_navi">임시저장</button>
					 -->
					<button class="btn_admin_sky" onclick="fn_update()">수정</button>
					<button class="btn_admin_gray" onclick="fn_goList()">취소</button>
				</div>
				<hr class="con_mode" />
			</div>
		</div>
	</section>
</div>

<table id="tmpTable" class="tbl05" style="display:none">
	<tbody id="tmpChangeTbody" name="tmpChangeTbody">
		<tr id="tmpChangeRow_1" class="temp_color">
			<td>
				<input type="checkbox" id="change_1"><label for="change_1"><span></span></label>
			</td>
			<td>
				<input type="text" name="itemDiv" style="width: 99%" class="req code_tbl"/>							
			</td>
			<td>
				<textarea style="width:95%; height:50px" placeholder="기존정보를 입력하세요." name="itemCurrent" id="itemCurrent" class="req code_tbl"></textarea>
			</td>
			<td>
				<textarea style="width:95%; height:50px" placeholder="변경정보를 입력하세요." name="itemChange" id="itemChange" class="req code_tbl"></textarea>
			</td>
			<td>
				<input type="text" name="itemNote" style="width: 99%" class="req code_tbl"/>
			</td>
		</tr>
	</tbody>
</table>

<!-- 첨부파일 추가레이어 start-->
<!-- 신규로 레이어창을 생성하고싶을때는  아이디값 교체-->
<!-- 클래스 옆에 적힌 스타일 값을 인라인으로 작성해서 팝업 사이즈를 직접 조정 -->
<div class="white_content" id="dialog_attatch">
	<div class="modal" style="margin-left: -355px; width: 710px; height: 480px; margin-top: -250px">
		<h5 style="position: relative">
			<span class="title">첨부파일 추가</span>
			<div class="top_btn_box">
				<ul>
					<li>
						<button class="btn_madal_close" onClick="closeDialogWithClean('dialog_attatch')"></button>
					</li>
				</ul>
			</div>
		</h5>
		<div class="list_detail">
			<ul>
				<li class="pt10 mb5">
					<dt style="width: 20%">파일 선택</dt>
					<dd style="width: 80%" class="ppp">
						<div style="float: left; display: inline-block;">
							<span class="file_load" id="fileSpan">
								<input id="attatch_common_text" class="form-control form_point_color01" type="text" placeholder="파일을 선택해주세요." style="width:308px; float:left; cursor: pointer; color: black;" onclick="callAddFileEvent()" readonly="readonly">
								<input id="attatch_common" type="file" style="display:none;" onchange="setFileName(this)">
							</span>
							<button class="btn_small02 ml5" onclick="addFile(this, '00')">파일등록</button>
						</div>
						<div style="float: left; display: inline-block; margin-top: 5px">
							
						</div>
					</dd>
				</li>
				<li class=" mb5">
					<dt style="width: 20%">파일리스트</dt>
					<dd style="width: 80%;">
						<div class="file_box_pop" style="width:95%">
							<ul name="popFileList"></ul>
						</div>
					</dd>
				</li>
			</ul>
		</div>
		<div class="btn_box_con">
			<button class="btn_admin_red" onclick="uploadFiles();">파일 등록</button>
			<button class="btn_admin_gray" onClick="closeDialogWithClean('dialog_attatch')">등록 취소</button>
		</div>
	</div>
</div>
<!-- 파일 생성레이어 close-->