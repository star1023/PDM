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
.ck-editor__editable { max-height: 400px; min-height:150px;}
</style>

<link href="../resources/css/mfg.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="/resources/editor/build/ckeditor.js"></script>
<script type="text/javascript" src="/resources/js/appr/apprClass.js?v=<%= System.currentTimeMillis()%>"></script>
<script type="text/javascript">
	var editor1;
	var editor2;
	$(document).ready(function(){
		$("#tripStartDate").datepicker({
			showOn: "both",
			buttonImage: "../resources/images/btn_calendar.png",
			buttonImageOnly: true,
			buttonText: "Select date",
			dateFormat: "yy-mm-dd",
			showButtonPanel: true,
			showAnim: "",
			onClose: function(selectedDate){
				$("#tripEndDate").datepicker("option", "minDate", selectedDate);
			}
		});	//당일 선택 가능 0, 당일 선택 불가능 1
		
		$("#tripEndDate").datepicker({
			showOn: "both",
			buttonImage: "../resources/images/btn_calendar.png",
			buttonImageOnly: true,
			buttonText: "Select date",
			dateFormat: "yy-mm-dd",
			minDate: 0,
			showButtonPanel: true,
			showAnim: "",
			onClose: function(selectedDate){
				$("#tripStartDate").datepicker("option", "maxdate", selectedDate)
			}
		});
		
		ClassicEditor
        .create(document.getElementById("tripContents"), {
			language: 'ko',
        }).then( editor => {
        	editor1 = editor;
    		console.log( editor1 );
    	}).catch( error => {
    		console.error( error );
    	});
		
		ClassicEditor
        .create(document.getElementById("tripCost"), {
			language: 'ko',
        }).then( editor => {
        	editor2 = editor;
    		console.log( editor2 );
    	}).catch( error => {
    		console.error( error );
    	});
		
		fn.autoComplete($("#keyword"));
	});
	
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
		//var tripContents = editor1.getData();
		var tripContents = editor1.getData();
		var tripCost = editor2.getData();
		console.log(editor1.getData());
		console.log(editor2.getData());
		if( !chkNull($("#title").val()) ) {
			alert("제목을 입력해 주세요.");
			$("#title").focus();
			return;
		} else if( !chkNull($("#dept").val()) ) {
			alert("소속을 입력해 주세요.");
			$("#dept").focus();
			return;
		} else if( !chkNull($("#position").val()) ) {
			alert("직위(직급)을 입력해 주세요.");
			$("#position").focus();
			return;
		} else if( !chkNull($("#name").val()) ) {
			alert("성명을 입력해 주세요.");
			$("#name").focus();
			return;
		} else if( !chkNull($("#tripPurpose").val()) ) {
			alert("출장목적을 입력해 주세요.");
			$("#tripPurpose").focus();
			return;
		} else if( !chkNull($("#tripStartDate").val()) ) {
			alert("출장일을 입력해 주세요.");
			$("#tripStartDate").focus();
			return;
		} else if( !chkNull($("#tripDestination").val()) ) {
			alert("출장지를 입력해 주세요.");
			$("#tripDestination").focus();
			return;
		} else if( !chkNull(tripContents) ) {
			alert("업무수행내용을 입력해주세요.");		
			return;
		} else if( !chkNull(tripCost) ) {
			alert("경비를 입력해주세요.");		
			return;
		} else if( $("#temp_attatch_file").children("li").length == 0 && attatchFileArr.length == 0 ) {
			alert("첨부파일을 등록해주세요.");		
			return;
		} else {
			var formData = new FormData();
			formData.append("idx",$("#idx").val());
			formData.append("currentStatus",$("#currentStatus").val());
			formData.append("tripType",$("#tripType").selectedValues()[0]);
			formData.append("title",$("#title").val());
			formData.append("dept",$("#dept").val());
			formData.append("position",$("#position").val());
			formData.append("name",$("#name").val());
			formData.append("tripPurpose",$("#tripPurpose").val());
			formData.append("tripStartDate",$("#tripStartDate").val());
			formData.append("tripEndDate",$("#tripEndDate").val());
			formData.append("tripDestination",$("#tripDestination").val());
			formData.append("tripTransit",$("#tripTransit").val());
			formData.append("tripContents",tripContents);
			formData.append("tripCost",tripCost);
			formData.append("overReason",$("#overReason").val());
			formData.append("tripEffect",$("#tripEffect").val());
			formData.append("docType","TRIP");
			
			for (var i = 0; i < attatchFileArr.length; i++) {
				formData.append('file', attatchFileArr[i])
			}
			
			for (var i = 0; i < attatchFileTypeArr.length; i++) {
				formData.append('fileTypeText', attatchFileTypeArr[i].fileTypeText)			
			}
			
			for (var i = 0; i < attatchFileTypeArr.length; i++) {
				formData.append('fileType', attatchFileTypeArr[i].fileType)			
			}
			
			URL = "../report2/updateBusinessTripAjax";
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
		location.href = '/report2/businessTripList';
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
		출장결과 보고서&nbsp;&nbsp;
		<img src="/resources/images/icon_path.png" style="vertical-align: middle" />&nbsp;&nbsp;보고서&nbsp;&nbsp;
		<img src="/resources/images/icon_path.png" style="vertical-align: middle" />&nbsp;&nbsp;<a href="#none">${strUtil:getSystemName()}</a>
	</span>
	<section class="type01">
		<h2 style="position:relative">
			<span class="title_s">Design Change Report</span><span class="title">출장결과보고서</span>
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
							<th style="border-left: none;">출장구분</th>
							<td>
								<input type="hidden" name="idx" id="idx" value="${businessTripData.data.TRIP_IDX}"/>
								<input type="hidden" name="currentStatus" id="currentStatus" value="${businessTripData.data.STATUS}"/>
								<div class="selectbox" style="width:100px;">  
									<label for="tripType" id="tripType_label">${businessTripData.data.TRIP_TYPE_TXT}</label> 
									<select name="tripType" id="tripType">
										<option value="">선택</option>
										<option value="I" ${businessTripData.data.TRIP_TYPE == 'I' ? 'select' : ''}>국내</option>
										<option value="O" ${businessTripData.data.TRIP_TYPE == 'O' ? 'select' : ''}>해외</option>
									</select>
								</div>
							</td>
							<th style="border-left: none;">출장기간</th>
							<td>
								<input type="text" name="tripStartDate" id="tripStartDate" style="width: 120px;" class="req" value="${businessTripData.data.TRIP_START_DATE}"/>
								&nbsp;~&nbsp;
								<input type="text" name="tripEndDate" id="tripEndDate" style="width: 120px;" class="req" value="${businessTripData.data.TRIP_END_DATE}"/>
							</td>
						</tr>
						<tr>
							<th style="border-left: none;">제목</th>
							<td colspan="3"><input type="text" name="title" id="title" style="width: 90%;" class="req" value="${businessTripData.data.TITLE}"/></td>
						</tr>
						<tr>
							<th style="border-left: none;">소속</th>
							<td>
								<input type="text"  style="width:200px; float: left" class="req" name="dept" id="dept" placeholder="" value="${businessTripData.data.DEPT}"/>
							</td>
							<th style="border-left: none;">직위(직급)</th>
							<td>
								<input type="text"  style="width:200px; float: left" class="req" name="position" id="position" placeholder="" value="${businessTripData.data.POSITION}"/>
							</td>
						</tr>
						<tr>
							<th style="border-left: none;">성명</th>
							<td colspan="3"><input type="text" name="name" id="name" style="width: 90%;" class="req" value="${businessTripData.data.NAME}"/></td>
						</tr>
						<tr>
							<th style="border-left: none;">출장목적</th>
							<td colspan="3"><input type="text" name="tripPurpose" id="tripPurpose" style="width: 90%;" class="req" value="${businessTripData.data.TRIP_PURPOSE}"/></td>
						</tr>
						<tr>
							<th style="border-left: none;">출장지</th>
							<td>
								<input type="text"  style="width:95%; float: left" class="req" name="tripDestination" id="tripDestination" placeholder="" value="${businessTripData.data.TRIP_DESTINATION}"/>
							</td>
							<th style="border-left: none;">경유지</th>
							<td>
								<input type="text"  style="width:95%; float: left" class="req" name="tripTransit" id="tripTransit" placeholder="" value="${businessTripData.data.TRIP_TRANSIT}"/>
							</td>
						</tr>
						<tr>
							<th style="border-left: none;">업무수행내용</th>
							<td colspan="3">
								<textarea rows='5' cols="130" name="tripContents" id="tripContents" style="width: 466px; height: 40px; display: none;">${businessTripData.data.CONTENTS}</textarea>
							</td>
						</tr>
						<tr>
							<th style="border-left: none;">경비</th>
							<td colspan="3">
								<textarea rows='2' cols="130" name="tripCost" id="tripCost" style="width: 466px; height: 40px; display: none;">${businessTripData.data.TRIP_COST}</textarea>
							</td>
						</tr>
						<tr>
							<th style="border-left: none;">초과사유</th>
							<td colspan="3">
								<textarea rows='2' cols="130" name="overReason" id="overReason">${businessTripData.data.OVER_REASON}</textarea>
							</td>
						</tr>
						<tr>
							<th style="border-left: none;">출장효과</th>
							<td colspan="3">
								<textarea rows='2' cols="130" name="tripEffect" id="tripEffect">${businessTripData.data.TRIP_EFFECT}</textarea>
							</td>
						</tr>						
					</tbody>
				</table>
			</div>
			
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
								<c:forEach items="${businessTripData.fileList}" var="fileList" varStatus="status">
									<li><a href="#none" onclick="fn_removeTempFile(this, '${fileList.FILE_IDX}')"><img src="/resources/images/icon_del_file.png"></a>&nbsp;<a href="javascript:downloadFile('${fileList.FILE_IDX}')">${fileList.ORG_FILE_NAME}</a></li>
								</c:forEach>
							</ul>
							<ul id="attatch_file">								
							</ul>
						</dd>
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
					<button class="btn_admin_sky" onclick="fn_update()">저장</button>
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
