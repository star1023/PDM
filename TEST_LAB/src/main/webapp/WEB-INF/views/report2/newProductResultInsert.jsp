<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="kr.co.aspn.util.*" %>
<%@ taglib prefix="userUtil" uri="/WEB-INF/tld/userUtil.tld"%>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ taglib prefix="dateUtil" uri="/WEB-INF/tld/dateUtil.tld"%>
<title>신제품 품질 결과 보고서 생성</title>
<link href="../resources/css/mfg.css" rel="stylesheet" type="text/css">
<link href="../resources/css/common.css" rel="stylesheet" type="text/css" />
<link href="../resources/css/tree.css" rel="stylesheet" type="text/css" />
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
<script src="/resources/js/jquery.ui.monthpicker.js"></script>
<script type="text/javascript">
	var editor1;
	var editor2;
	let _multiSelectCache = {
		    store: [],
		    product: []
	};
	$(document).ready(function() {
	    var startYear = (new Date()).getFullYear();

	    $("#excuteDate").monthpicker({
	        dateFormat: 'yy-mm',
	        showOn: 'button',
	        buttonImage: '../resources/images/btn_calendar.png',
	        buttonImageOnly: true,
	        monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
	        monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
	        yearRange: (startYear - 2) + ":" + (startYear + 2)
	    });

	    // 버튼 위치 조정
	    $('.ui-monthpicker-trigger').css({
	        'cursor': 'pointer'
	    });
	});
	
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
	
	// 입력 확인 및 저장 요청 함수
	function fn_insert() {
	    var title = document.getElementById("title").value.trim();
	    var excuteDate = document.getElementById("excuteDate").value.trim();
	    var storeCodes = document.getElementById("storeCodeValues_1").value.trim();
	    // var productCodes = document.getElementById("productCodeValues_1") ? document.getElementById("productCodeValues_1").value.trim() : "";

	    if (!chkNull(title)) {
	        alert("제목을 입력해 주세요.");
	        document.getElementById("title").focus();
	        return;
	    } else if (!chkNull(excuteDate)) {
	        alert("시행월을 입력해 주세요.");
	        document.getElementById("excuteDate").focus();
	        return;
	    } else if (!chkNull(storeCodes)) {
	        alert("매장을 입력해 주세요.");
	        return;
	        /*
	    } else if (!chkNull(productCodes)) {
	        alert("제품을 입력해 주세요.");
	        return;
	        */
	    } else if (attatchFileArr.length == 0) {
	        alert("첨부파일을 등록해주세요.");
	        return;
	    }

	    var formData = new FormData();
	    formData.append("title", title);
	    formData.append("excuteDate", excuteDate);
	    formData.append("storeCodes", storeCodes);
	    //formData.append("productCodes", productCodes);

	    for (var i = 0; i < attatchFileArr.length; i++) {
	        formData.append("file", attatchFileArr[i]);
	    }
	    for (var i = 0; i < attatchFileTypeArr.length; i++) {
	        formData.append("fileTypeText", attatchFileTypeArr[i].fileTypeText);
	        formData.append("fileType", attatchFileTypeArr[i].fileType);
	    }

	    console.log("🔎 FormData 내용");
	    for (let pair of formData.entries()) {
	        console.log(pair[0] + ":", pair[1]);
	    }
		/*
	    $.ajax({
	        type: "POST",
	        url: "../report2/insertNewProductResultAjax",
	        data: formData,
	        processData: false,
	        contentType: false,
	        cache: false,
	        dataType: "json",
	        success: function(result) {
	            console.log(result);
	            if (result.RESULT === 'S' && result.IDX > 0) {
	                if (document.getElementById("apprLine").options.length > 0) {
	                    var apprFormData = new FormData();
	                    apprFormData.append("docIdx", result.IDX);
	                    apprFormData.append("apprComment", document.getElementById("apprComment").value);
	                    apprFormData.append("apprLine", $("#apprLine").selectedValues());
	                    apprFormData.append("refLine", $("#refLine").selectedValues());
	                    apprFormData.append("title", title);
	                    apprFormData.append("docType", document.getElementById("docType").value);
	                    apprFormData.append("status", "N");

	                    $.ajax({
	                        type: "POST",
	                        url: "../approval2/insertApprAjax",
	                        dataType: "json",
	                        data: apprFormData,
	                        processData: false,
	                        contentType: false,
	                        cache: false,
	                        success: function(data) {
	                            if (data.RESULT === 'S') {
	                                alert("결재상신이 완료되었습니다.");
	                                fn_goList();
	                            } else {
	                                alert("결재선 상신 오류가 발생하였습니다." + data.MESSAGE);
	                                fn_goList();
	                            }
	                        },
	                        error: function() {
	                            alert("결재 요청 중 오류가 발생하였습니다.");
	                            fn_goList();
	                        }
	                    });
	                } else {
	                    alert(title + "가 정상적으로 생성되었습니다.");
	                    fn_goList();
	                }
	            } else {
	                alert("저장 중 오류가 발생하였습니다.\n" + result.MESSAGE);
	            }
	        },
	        error: function() {
	            alert("저장 요청 중 오류가 발생하였습니다.");
	        }
	    });
	    */
	}

	function fn_goList() {
		location.href = '/report2/newProductResultList';
	}
	
	function fn_apprSubmit(){
		if( $("#apprLine option").length == 0 ) {
			alert("등록된 결재라인이 없습니다. 결재 라인 추가 후 결재상신 해 주세요.");
			return;
		} else {
			var apprTxtFull = "";
			$("#apprLine").selectedTexts().forEach(function( item, index ){
				console.log(item);
				if( apprTxtFull != "" ) {
					apprTxtFull += " > ";
				}
				apprTxtFull += item;
			});
			$("#apprTxtFull").val(apprTxtFull);
			var refTxtFull = "";
			$("#refLine").selectedTexts().forEach(function( item, index ){
				if( refTxtFull != "" ) {
					refTxtFull += ", ";
				}
				refTxtFull += item;
			});
			$("#refTxtFull").html("&nbsp;"+refTxtFull);
		}
		closeDialog('approval_dialog');
	}
	
	function fn_copySearch() {
		openDialog('dialog_search');
	}
	
	function fn_closeSearch() {
		closeDialog('dialog_search');
		$("#searchValue").val("");
		$("#searchCategory1").removeOption(/./);
		$("#searchCategory2").removeOption(/./);
		$("#searchCategory2_div").hide();
		$("#searchCategory3").removeOption(/./);
		$("#searchCategory3_div").hide();
		$("#productLayerBody").html("<tr><td colspan=\"4\">검색해주세요</td></tr>");
	}
	
	function fn_search() {
		var URL = "../report2/searchNewProductResultListAjax";
		$.ajax({
			type:"POST",
			url:URL,
			data:{
				searchValue : $("#searchValue").val()
			},
			dataType:"json",
			success:function(result) {
				console.log(result);
				//productLayerBody
				var jsonData = {};
				jsonData = result;
				$('#productLayerBody').empty();
				if( jsonData.length == 0 ) {
					var html = "";
					$("#productLayerBody").html(html);
					html += "<tr><td align='center' colspan='5'>데이터가 없습니다.</td></tr>";
					$("#productLayerBody").html(html);
				} else {
					jsonData.forEach(function(item){
						var row = '<tr onClick="fn_copy(\''+item.RESULT_IDX+'\')">';
						row += '<td></td>';
						row += '<td class="tgnl">'+item.TITLE+'</td>';
						row += '<td>'+item.EXCUTE_DATE+'</td>';
						row += '</tr>';
						$('#productLayerBody').append(row);
					})
				}
			},
			error:function(request, status, errorThrown){
				var html = "";
				$("#productLayerBody").html(html);
				html += "<tr><td align='center' colspan='5'>오류가 발생하였습니다.</td></tr>";
				$("#productLayerBody").html(html);
			}			
		});
	}
	
	function fn_copy(idx) {
		var URL = "../report2/selectBusinessTripPlanDataAjax";
		$.ajax({
			type:"POST",
			url:URL,
			data:{
				"idx" : idx
			},
			dataType:"json",
			success:function(result) {
				console.log(result);
				$("#tripType").selectOptions(result.TRIP_TYPE);
				$("#tripType_label").html($("#tripType").selectedTexts());
				$("#tripStartDate").val(result.TRIP_START_DATE);
				$("#tripEndDate").val(result.TRIP_END_DATE);
				$("#title").val(result.TITLE);
				$("#dept").val(result.DEPT);
				$("#position").val(result.POSITION);
				$("#name").val(result.NAME);
				$("#tripPurpose").val(result.TRIP_PURPOSE);
				$("#tripDestination").val(result.TRIP_DESTINATION);
				$("#tripTransit").val(result.TRIP_TRANSIT);
				editor1.setData(result.CONTENTS);
				editor2.setData(result.TRIP_COST);
				$("#tripEffect").val(result.TRIP_EFFECT);
				fn_closeSearch();
			},
			error:function(request, status, errorThrown){
				
			}			
		});
	}
	
// ---------------------------------------- STORE POP -----------------------------------------	
	function openMultiSelectDialog(targetType, idx) {
	    window._multiSelectTarget = {
	        type: targetType, // 'store' 또는 'product'
	        idx: idx
	    };

	    document.getElementById("dialog_store").style.display = "block";

	    // 데이터가 이미 로드된 경우엔 필터 없이 다시 표시
	    if (_multiSelectCache[targetType]?.length > 0) {
	        renderMultiSelectTable(_multiSelectCache[targetType]);
	        return;
	    }

	    // AJAX로 데이터 로드
	    $.ajax({
	        type: "POST",
	        url: "../common/codeListAjax",
	        data: { groupCode: targetType.toUpperCase() }, // 'STORE', 'PRODUCT'
	        dataType: "json",
	        success: function (data) {
	            _multiSelectCache[targetType] = data.RESULT;
	            renderMultiSelectTable(data.RESULT);
	        },
	        error: function () {
	            alert(targetType + " 정보를 불러오는데 실패했습니다.");
	        }
	    });
	}

	function renderMultiSelectTable(list) {
	    const { type, idx } = window._multiSelectTarget;
	    var selectedEl = document.getElementById(type + "CodeValues_" + idx);
	    var selectedCodesStr = selectedEl ? selectedEl.value : "";
	    const selectedCodes = selectedCodesStr.split(',').map(code => code.trim());

	    const tbody = document.getElementById("storeLayerBody");
	    tbody.innerHTML = "";

	    if (!list || list.length === 0) {
	        tbody.innerHTML = "<tr><td colspan='3'>검색 결과가 없습니다.</td></tr>";
	        document.getElementById("storeCount").textContent = "0";
	        return;
	    }

	    list.forEach(item => {
	        const isChecked = selectedCodes.includes(item.itemCode);

	        const row = document.createElement("tr");
	        row.innerHTML =
	            "<td><input type='checkbox' style='width:20px; height:20px;' name='multiChk' value='" + item.itemCode + "' data-name='" + item.itemName + "'" + (isChecked ? " checked" : "") + "></td>" +
	            "<td>" + item.itemCode + "</td>" +
	            "<td>" + item.itemName + "</td>";
	        tbody.appendChild(row);
	    });

	    document.getElementById("storeCount").textContent = list.length;
	}

	function chooseMultiSelect() {
	    const { type, idx } = window._multiSelectTarget;
	    const checked = document.querySelectorAll("input[name='multiChk']:checked");

	    const tokenBox = document.getElementById(type + "TokenBox_" + idx);
	    const hiddenInput = document.getElementById(type + "CodeValues_" + idx);

	    tokenBox.innerHTML = '';
	    const selectedCodes = [];

	    checked.forEach(item => {
	        const code = item.value;
	        const name = item.getAttribute("data-name");
	        selectedCodes.push(code);

	        const token = document.createElement("span");
	        token.className = "store-token";
	        token.setAttribute("data-code", code);
	        token.style = `
	            display: flex;
	            align-items: center;
	            background: #e0e0e0;
	            border-radius: 12px;
	            padding: 4px 8px;
	            margin-right: 5px;
	            font-size: 13px;
	        `;

	        const removeBtn = document.createElement("span");
	        removeBtn.textContent = "✕";
	        removeBtn.style = `
	            font-weight: bold;
	            margin-right: 6px;
	            cursor: pointer;
	            color: #666;
	        `;
	        removeBtn.onclick = function () {
	            token.remove();
	            updateHiddenCodes(type, idx);
	        };

	        token.appendChild(removeBtn);
	        token.append(name);
	        tokenBox.appendChild(token);
	    });

	    hiddenInput.value = selectedCodes.join(',');
	    closeDialog('dialog_' + type);
	}

	function updateHiddenCodes(type, idx) {
	    const tokens = document.querySelectorAll(`#${type}TokenBox_${idx} .brand-token`);
	    const codes = [...tokens].map(t => t.getAttribute("data-code"));
	    document.getElementById(`${type}CodeValues_${idx}`).value = codes.join(',');
	}

	function searchMultiSelectKeyword() {
	    const keyword = document.getElementById("searchStoreValue").value.trim().toLowerCase();
	    const list = _multiSelectCache[window._multiSelectTarget.type];

	    const filtered = list.filter(item =>
	        item.itemCode.toLowerCase().includes(keyword) ||
	        item.itemName.toLowerCase().includes(keyword)
	    );

	    renderMultiSelectTable(filtered);
	}
	function clearStoreToken(idx) {
		const tokenBox = document.getElementById("storeTokenBox_" + idx);
		const hiddenInput = document.getElementById("storeCodeValues_" + idx);

		if (tokenBox) tokenBox.innerHTML = '';
		if (hiddenInput) hiddenInput.value = '';
	}
	function clearProductToken(idx) {
		const tokenBox = document.getElementById("productTokenBox_" + idx);
		const hiddenInput = document.getElementById("productCodeValues_" + idx);

		if (tokenBox) tokenBox.innerHTML = '';
		if (hiddenInput) hiddenInput.value = '';
	}
	
	function bindStoreDialogEnter(e) {
	    if (e.key === 'Enter') {
	        searchStore();
	    }
	}
	
	function searchStore() {
	    var keyword = document.getElementById("searchStoreValue").value.trim().toLowerCase();
	    var list = _multiSelectCache["store"] || [];

	    var filtered = list.filter(function (item) {
	        return item.itemCode.toLowerCase().includes(keyword) ||
	               item.itemName.toLowerCase().includes(keyword);
	    });

	    renderMultiSelectTable(filtered);
	}

	function bindProductDialogEnter(e) {
	    if (e.key === 'Enter') {
	        searchProduct();
	    }
	}

	function searchProduct() {
	    var keyword = document.getElementById("searchProductValue").value.trim().toLowerCase();
	    var list = _multiSelectCache["product"] || [];

	    var filtered = list.filter(function (item) {
	        return item.itemCode.toLowerCase().includes(keyword) ||
	               item.itemName.toLowerCase().includes(keyword);
	    });

	    renderMultiSelectTable(filtered);
	}

// ---------------------------------------- STORE POP -----------------------------------------
</script>
<div class="wrap_in" id="fixNextTag">
	<span class="path">
		신제품 품질 결과 보고서&nbsp;&nbsp;
		<img src="/resources/images/icon_path.png" style="vertical-align: middle" />&nbsp;&nbsp;보고서&nbsp;&nbsp;
		<img src="/resources/images/icon_path.png" style="vertical-align: middle" />&nbsp;&nbsp;<a href="#none">${strUtil:getSystemName()}</a>
	</span>
	<section class="type01">
		<h2 style="position:relative">
			<span class="title_s">New Product Result Report</span><span class="title">신제품 품질 결과 보고서</span>
			<div class="top_btn_box">
				<ul>
					<li>
						<button class="btn_circle_modifiy" onclick="fn_copySearch()">&nbsp;</button>
						<button class="btn_circle_save" onclick="fn_insert()">&nbsp;</button>
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
							<td colspan="3"><input type="text" name="title" id="title" style="width: 90%;" class="req" /></td>
						</tr>					
						<tr>
							<th style="border-left: none;">시행월</th>
							<td colspan="3"><input type="text" id="excuteDate" readonly class="req" placeholder="시행월 선택 (예: 2024-05)" style="width: 170px;"></td>
						</tr>					
						<tr>
							<th style="border-left: none;">매장명</th>
							<td colspan="3">
								<div style="display:flex; gap:10px; margin-top:20px;">
									<div id="storeTokenBox_1" class="token-box" style="flex: 1; display: flex; flex-wrap: wrap; gap: 5px;"></div>
									<button type="button" onclick="openMultiSelectDialog('store', 1)" class="btn_small_search ml5">조회</button>
									<button type="button" onclick="clearStoreToken(1)" class="btn_small_search ml5">초기화</button>
									<input type="hidden" id="storeCodeValues_1" name="storeCodeValues_1">
								</div>
							</td>
						</tr>
						<tr>
							<th style="border-left: none;">제품명</th>
							<td colspan="3">
								<div style="display:flex; gap:10px; margin-top:20px">
									<div id="productTokenBox_1" class="token-box" style="flex: 1; display: flex; flex-wrap: wrap; gap: 5px;"></div>
									<button type="button" onclick="openMultiSelectDialog('product', 1)" class="btn_small_search ml5">조회</button>
									<button type="button" onclick="clearProductToken(1)" class="btn_small_search ml5">초기화</button>
									<input type="hidden" id="productCodeValues_1" name="productCodeValues_1">
								</div>
							</td>
						</tr>	
						<tr>
							<th style="border-left: none;">결재라인</th>
							<td colspan="3">
								<input class="" id="apprTxtFull" name="apprTxtFull" type="text" style="width: 450px; float: left" readonly>
								<button class="btn_small_search ml5" onclick="apprClass.openApprovalDialog()" style="float: left">결재</button>
							</td>
						</tr>
						<tr>
							<th style="border-left: none;">참조자</th>
							<td colspan="3">
								<div id="refTxtFull" name="refTxtFull"></div>								
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
					<button class="btn_admin_sky" onclick="fn_insert()">저장</button>
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
			<span class="title">출장결과보고서 결재 상신</span>
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

<!-- 문서 검색 레이어 start-->
<div class="white_content" id="dialog_search">
	<div class="modal" style="	width: 700px;margin-left:-360px;height: 550px;margin-top:-300px;">
		<h5 style="position:relative">
			<span class="title">신제품 품질 결과 보고서 검색</span>
			<div  class="top_btn_box">
				<ul>
					<li>
						<button class="btn_madal_close" onClick="closeDialog('dialog_search')"></button>
					</li>
				</ul>
			</div>
		</h5>
		<div class="list_detail">
			<ul>
				<li>
					<dt>보고서검색</dt>
					<dd>
						<input type="text" value="" class="req" style="width:302px; float: left" name="searchValue" id="searchValue" placeholder="제목으로 검색하십시오."/>
						<button class="btn_small_search ml5" onclick="fn_search()" style="float: left">조회</button>
					</dd>
				</li>
			</ul>
		</div>
		<div class="main_tbl" style="height: 300px; overflow-y: auto">
			<table class="tbl07">
				<colgroup>
					<col width="40px">
					<col/>
					<col width="23%">
				</colgroup>
				<thead>
					<tr>
						<th></th>
						<th>제목</th>
						<th>시행월</th>
					<tr>
				</thead>
				<tbody id="productLayerBody">
					<tr>
						<td colspan="4">검색해주세요</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
</div>
<!-- 문서 검색 레이어 close-->
<!-- 스토어 선택 레이어 open --> 
<div class="white_content" id="dialog_store" style="display: none;">
	<input id="targetID" type="hidden">
	<input id="itemType" type="hidden">
	<input id="searchType" type="hidden">
	<div class="modal" style="width: 700px; margin-left: -400px; height: 650px; margin-top: -300px;">
		<h5 style="position:relative">
			<span class="title">매장 선택</span> 
			<div class="top_btn_box">
				<ul>
					<li><button class="btn_madal_close" onclick="closeDialog('dialog_store')"></button></li> 
				</ul>
			</div>
		</h5>
		<div style="width:100%; text-align:center;">
			<input id="searchStoreValue" type="text" class="code_input" onkeyup="bindStoreDialogEnter(event)" style="width: 300px;" placeholder="일부단어로 검색가능"> 
			<img src="/resources/images/icon_code_search.png" onclick="searchStore()"/> 
		</div>
		<div class="code_box2">
			(<strong> <span id="storeCount">0</span> </strong>)건 
		</div>
		<div class="main_tbl" style="height: 400px; overflow-y: auto;">
			<table class="tbl02">
				<colgroup>
					<col width="20%">
					<col width="40%">
					<col width="40%">
				</colgroup>
				<thead>
					<tr>
						<th></th>	
						<th>매장 코드</th>
						<th>매장명</th>
					</tr>
				</thead>
				<tbody id="storeLayerBody"> 
					<input type="hidden" id="storeLayerPage" value="0"/> 
					<Tr>
						<td colspan="10">매장코드 혹은 매장명을 검색해주세요</td> 
					</Tr>
				</tbody>
			</table>
		</div>
		<div style="margin-top: 40px;">
		    <!-- ✅ 선택 완료 버튼 추가 -->
		    <div style="text-align: center;">
		      <button class="btn_large_search" onclick="chooseMultiSelect()">선택 완료</button> 
		    </div>
		</div>
	</div>
</div>
<!-- 스토어 선택 레이어 close -->