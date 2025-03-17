<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="kr.co.aspn.util.*" %>
<%@ taglib prefix="userUtil" uri="/WEB-INF/tld/userUtil.tld"%>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ taglib prefix="dateUtil" uri="/WEB-INF/tld/dateUtil.tld"%>
<title>메뉴 개발완료보고서</title>
<style>
.positionCenter{
	position: absolute;
	transform: translate(-50%, -45%);
}
.ck-editor__editable { max-height: 400px; min-height:400px;}
</style>

<link href="../resources/css/mfg.css" rel="stylesheet" type="text/css">

<link href="../resources/css/tree.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="../resources/js/jstree.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		CreateEditor("contents");		
		fn_loadCategory();
	});
	
	var selectedArr = new Array();
	
	
	function loadCode(codeId,selectBoxId) {
		var URL = "../common/codeListAjax";
		$.ajax({
			type:"POST",
			url:URL,
			data:{ groupCode : codeId
			},
			dataType:"json",
			async:false,
			success:function(data) {
				var list = data.RESULT;
				$("#"+selectBoxId).removeOption(/./);
				$("#"+selectBoxId).addOption("", "전체", false);
				$.each(list, function( index, value ){ //배열-> index, value
					$("#"+selectBoxId).addOption(value.itemCode, value.itemName, false);
				});
			},
			error:function(request, status, errorThrown){
					alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
			}			
		});
	}
	
	function fn_loadCategory() {
		var URL = "../test/categoryListAjax";
		$.ajax({
			type:"POST",
			url:URL,
			data:{
				pId : "2"
			},
			dataType:"json",
			async:false,
			success:function(data) {
				fn_createJSTree(data);
			},
			error:function(request, status, errorThrown){
					alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
			}			
		});
	}
	
	function fn_createJSTree(data) {
		$("#jsTree").jstree(
			{
				'core' : {
					'data' : data
				},
				"plugins" : [ "wholerow" ]
		   	}
		).bind("loaded.jstree",function(){
			 $(this).jstree("open_all");
		}).on("select_node.jstree",function(e,data){
			selectedArr = new Array();
			console.log(e);
			console.log("data : "+data);
			var selectTxtFull = "";
			var parents = data.node.parents;
			var selectTxt = data.node.text;
			var selectId = data.node.id;
			console.log("parents : "+parents);
			console.log("selectTxt : "+selectTxt);
			selectedArr.push(selectId);
			selectTxtFull += selectTxt;
			
			$.each(parents, function( index, value ){ //배열-> index, value
				if( value != '#' ) { 
					console.log($.jstree.reference('#jsTree').get_node(value).text);
					//console.log($(this).jstree(true).get_node(value).text);					
					selectedArr.push(value);
					//selectTxtFull = $(this).jstree(true).get_node(value).text + ">" +selectTxtFull
					selectTxtFull = $.jstree.reference('#jsTree').get_node(value).text + ">" +selectTxtFull
				}
			});
			console.log(selectedArr);
			//$("#selectTxtFull").html(selectTxtFull);
			$("#selectTxtFull").val(selectTxtFull);
			closeDialog('dialog_menu');
		});
		//.bind("refresh.jstree",function(){
		//	
		//});
	}
	
	function fn_closeErpMatRayer(){
		$('#searchErpMatValue').val('')
		$('#erpMatLayerBody').empty();
		$('#erpMatLayerBody').append('<tr><td colspan="9">원료코드 혹은 원료코드명을 검색해주세요</td></tr>');
		$('#erpMatCount').text(0);
		closeDialog('dialog_erpMaterial');
	}

	function fn_searchErpMaterial(pageType) {
		var pageType = pageType;
		console.log(pageType);
		if(!pageType)
			$('#erpMatLayerPage').val(1);
		
		if(pageType == 'nextPage'){
			var totalCount = Number($('#erpMatCount').text());
			var maxPage = totalCount/10+1;
			var nextPage = Number($('#erpMatLayerPage').val())+1;
			
			if(nextPage >= maxPage) return; //nextPage = maxPage
			
			$('#erpMatLayerPage').val(nextPage);
		}

		if(pageType == 'prevPage'){
			var prevPage = Number($('#erpMatLayerPage').val())-1;
			if(prevPage <= 0) return; //prevPage = 1;
			
			$('#erpMatLayerPage').val(prevPage);
		}
		
		$('#lab_loading').show();
		
		$.ajax({
			url: '/test/selectErpMaterialListAjax',
			type: 'post',
			dataType: 'json',
			data: {
				searchValue: $('#searchErpMatValue').val(),
				pageNo: $('#erpMatLayerPage').val()
			},
			success: function(data){
				var jsonData = {};
				jsonData = data;
				$('#erpMatLayerBody').empty();
				$('#erpMatLayerBody').append('<input type="hidden" id="erpMatLayerPage" value="'+data.pageNo+'"/>');
				
				jsonData.list.forEach(function(item){
					
					var row = '<tr onClick="fn_setMaterialPopupData(\''+item.SAP_CODE+'\', \''+item.NAME+'\', \''+item.KEEP_CONDITION+'\', \''+item.WIDTH+'\', \''+item.LENGTH+'\', \''+item.HEIGHT+'\', \''+item.TOTAL_WEIGHT+'\', \''+item.STANDARD+'\', \''+item.ORIGIN+'\', \''+item.EXPIRATION_DATE+'\')">';
					//parentRowId, itemImNo, itemSAPCode, itemName, itemUnitPrice
					row += '<td></td>';
					//row += '<Td>'+item.companyCode+'('+item.plant+')'+'</Td>';
					row += '<Td>'+item.SAP_CODE+'</Td>';
					row += '<Td  class="tgnl">'+item.NAME+'</Td>';
					row += '<Td>'+item.KEEP_CONDITION+'</Td>';
					row += '<Td>'+item.WIDTH+'/'+item.LENGTH+'/'+item.HEIGHT+'</Td>';
					row += '<Td>'+item.TOTAL_WEIGHT+'('+item.TOTAL_WEIGHT_UNIT+')'+'</Td>';
					row += '<Td class="tgnl">'+item.STANDARD+'</Td>';
					row += '<Td>'+item.ORIGIN +'</Td>';
					row += '<Td>'+item.EXPIRATION_DATE+'</Td>';
					
					row += '</tr>';
					$('#erpMatLayerBody').append(row);
				})
				$('#erpMatCount').text(jsonData.totalCount)
				
				var isFirst = $('#erpMatLayerPage').val() == 1 ? true : false;
				var isLast = parseInt(jsonData.totalCount/10+1) == Number($('#erpMatLayerPage').val()) ? true : false;
				
				if(isFirst){
					$('#erpMatNextPrevDiv').children('button:first').attr('class', 'btn_code_left01');
				} else {
					$('#erpMatNextPrevDiv').children('button:first').attr('class', 'btn_code_left02');
				}
				
				if(isLast){
					$('#erpMatNextPrevDiv').children('button:last').attr('class', 'btn_code_right01');
				} else {
					$('#erpMatNextPrevDiv').children('button:last').attr('class', 'btn_code_right02');
				}
			},
			error: function(a,b,c){
				//console.log(a,b,c);
				alert('원료검색 실패[2] - 시스템 담당자에게 문의하세요');
			},
			complete: function(){
				$('#lab_loading').hide();
			}
		});
	}

	function bindDialogEnter(e){
		if(e.keyCode == 13)
			fn_searchErpMaterial();
	}
	
	function fn_setMaterialPopupData(SAP_CODE, NAME, KEEP_CONDITION, WIDTH, LENGTH, HEIGHT, TOTAL_WEIGHT, STANDARD, ORIGIN, EXPIRATION_DATE) {
		$("#menuName").val(NAME);
		$("#menuCode").val(SAP_CODE);
		$("#isSample").val("N");
		$("#keepCondition").val(KEEP_CONDITION);
		//$("#width").val(WIDTH);
		//$("#length").val(LENGTH);
		//$("#height").val(HEIGHT);
		$("#weight").val(TOTAL_WEIGHT);
		$("#standard").val(STANDARD);
		//$("#origin").val(ORIGIN);
		$("#expireDate").val(EXPIRATION_DATE);
		fn_closeErpMatRayer();
	}
	
	function selectNewCode() {
		console.log("새 코드를 조회한다.");
		var URL = "../menu/selectNewCodeAjax";
		$.ajax({
			type:"POST",
			url:URL,
			data:{},
			dataType:"json",
			async:false,
			success:function(data) {
				$("#menuCode").val("P"+data);
				$("#isSample").val("Y");
			},
			error:function(request, status, errorThrown){
				alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
			}			
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
		
		var childTag = '<li><a href="#none" onclick="removeTempFile(this, \''+randomId+'\')"><img src="/resources/images/icon_del_file.png"></a>&nbsp;'+fileName+'</li>'
		$('ul[name=popFileList]').append(childTag);
		$('#attatch_common').val('');
		$('#attatch_common').change();
	}
	function removeTempFile(element, tempId){
		$(element).parent().remove();
		attatchTempFileArr = attatchTempFileArr.filter(function(file){
			if(file.tempId != tempId) {
				return file;
			}
		})
		attatchTempFileTypeArr = attatchTempFileTypeArr.filter(function(typeObj){
			if(typeObj.tempId != tempId) 
				return typeObj;
		});
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
		
		if( $('input:checkbox[name=docType]:checked').length == 0 ) {
			alert("첨부파일 유형을 선택해주세요.");
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
	
	function changeNewMat(e){
		var newMat = $('input[name=newMat]:checked').val();
		if( newMat == "Y" ) {
			$("#matNewDiv").show();
		} else {
			$("#matNewDiv").hide();
		}
	}
	
	function addRow(element, type){
			
		var randomId = randomId = Math.random().toString(36).substr(2, 9);
		var randomId2 = randomId = Math.random().toString(36).substr(2, 9);
		
		var row= '<tr>'+$('tbody[name=tmpMatTbody]').children('tr').html()+'</tr>';

		$(element).parent().parent().next().children('tbody').append(row);
		var bodyId = $(element).parent().parent().next().children('tbody').attr('id').split('_')[1];
		$(element).parent().parent().next().children('tbody').children('tr:last').attr('id', type + 'Row_' + randomId);
		$(element).parent().parent().next().children('tbody').children('tr:last').children('td').children('input[type=checkbox]').attr('id', type+'_'+randomId);
		$(element).parent().parent().next().children('tbody').children('tr:last').children('td').children('label').attr('for', type+'_'+randomId);
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
	
	function checkMaterail(e){
		if(e.keyCode != 13){
			return;
		}
		var element = e.target
		
		var userSapCode = e.target.value;
		console.log(userSapCode);
		var rowId = $(element).parent().parent().attr('id');
		
		$.ajax({
			url: '/menu/checkMaterialAjax',
			type: 'post',
			dataType: 'json',
			data: {
				sapCode: userSapCode
			},
			success: function(data){
				var materailList = data;
				//if(false){
				if(materailList.length == 1){
					//pop
					var item = materailList[0];
					var varKeep = nvl2(item.KEEP_CONDITION,'');
					var varExp = nvl2(item.EXPIRATION_DATE,'');
					var varKeepExp = "";
					if( varKeep != '' && varExp != '' ) {
						varKeepExp = varKeep+" / "+varExp;
					} else {
						if( varKeep != '' ) {
							varKeepExp = varKeep;
						}
						
						if( varExp != '' ) {
							varKeepExp = varExp;
						}
					}
					$('#'+rowId + ' input[name$=itemMatIdx]').val(MATERIAL_IDX);
					$('#'+rowId + ' input[name$=itemSapCode]').val(SAP_CODE);
					$('#'+rowId + ' input[name$=itemName]').val(item.NAME);
					$('#'+rowId + ' input[name$=itemStandard]').val(nvl2(item.STANDARD,''));
					$('#'+rowId + ' input[name$=itemKeepExp]').val(varKeepExp);
					$('#'+rowId + ' input[name$=itemUnitPrice]').val(item.PRICE);
					
					if(item.isSample == 'Y'){
						$('#'+rowId).css('background-color', '#ffdb8c'); //#ffdb8c
					} else {
						$('#'+rowId).css('background-color', '#fff');
					}
					
				} else {
					// popup
					openMaterialPopup($(element).next());
				}
			},
			error: function(a,b,c){
				//console.log(a,b,c)
				alert('갱신 실패[2] - 시스템 담당자에게 문의하세요.');
			}
		})
	}
		
	function openMaterialPopup(element){
		var parentRowId = $(element).parent().parent('tr')[0].id;
		$('#targetID').val(parentRowId);
		openDialog('dialog_material');
		
		var matCode = $(element).prev().val();
		$('#searchMatValue').val(matCode);
		$('#itemType').val(itemType);
		
		searchMaterial();
	}
	
	function searchMaterial(pageType){
		var pageType = pageType;
		
		if(!pageType)
			$('#matLayerPage').val(1)
			
		if(pageType == 'nextPage'){
			var totalCount = Number($('#matCount').text());
			var maxPage = totalCount/10+1;
			var nextPage = Number($('#matLayerPage').val())+1;
			
			if(nextPage >= maxPage) return; //nextPage = maxPage
			
			$('#matLayerPage').val(nextPage);
		}
			
		if(pageType == 'prevPage'){
			var prevPage = Number($('#matLayerPage').val())-1;
			if(prevPage <= 0) return; //prevPage = 1;
			
			$('#matLayerPage').val(prevPage);
		}
			
		$('#lab_loading').show();
		console.log("searchMatValue  :  "+$('#searchMatValue').val());
		$.ajax({
			url: '/menu/selectMaterialAjax',
			type: 'post',
			dataType: 'json',
			data: {
				"searchValue": $('#searchMatValue').val(),
				"pageNo": $('#matLayerPage').val()
			},
			success: function(data){
				var jsonData = {};
				jsonData = data;
				$('#matLayerBody').empty();
				$('#matLayerBody').append('<input type="hidden" id="matLayerPage" value="'+data.pageNo+'"/>');
				
				jsonData.list.forEach(function(item){
					
					var row = '<tr onClick="setMaterialPopupData(\''+$('#targetID').val()+'\', \''+item.MATERIAL_IDX+'\', \''+item.SAP_CODE+'\', \''+item.NAME+'\', \''+item.PRICE+'\', \''+item.UNIT+'\', \''+item.STANDARD+'\', \''+item.KEEP_CONDITION+'\', \''+item.EXPIRATION_DATE+'\')">';
					//parentRowId, itemImNo, itemSAPCode, itemName, itemUnitPrice
					row += '<td></td>';
					//row += '<Td>'+item.companyCode+'('+item.plant+')'+'</Td>';
					row += '<Td>'+item.SAP_CODE+'</Td>';
					row += '<Td  class="tgnl">'+item.NAME+'</Td>';
					row += '<Td>'+nvl(item.KEEP_CONDITION,'')+'</Td>';
					row += '<Td>'+nvl(item.WIDTH,'')+'/'+nvl(item.LENGTH,'')+'/'+nvl(item.HEIGHT,'')+'</Td>';
					row += '<Td>'+nvl(item.TOTAL_WEIGHT,'')+'('+nvl(item.TOTAL_WEIGHT_UNIT,'')+')'+'</Td>';
					row += '<Td class="tgnl">'+nvl(item.STANDARD,'')+'</Td>';
					row += '<Td>'+nvl(item.ORIGIN,'') +'</Td>';
					row += '<Td>'+nvl(item.EXPIRATION_DATE,'')+'</Td>';
					
					row += '</tr>';
					$('#matLayerBody').append(row);
				})
				$('#matCount').text(jsonData.totalCount)
				
				var isFirst = $('#matLayerPage').val() == 1 ? true : false;
				var isLast = parseInt(jsonData.totalCount/10+1) == Number($('#matLayerPage').val()) ? true : false;
				
				if(isFirst){
					$('#matNextPrevDiv').children('button:first').attr('class', 'btn_code_left01');
				} else {
					$('#matNextPrevDiv').children('button:first').attr('class', 'btn_code_left02');
				}
				
				if(isLast){
					$('#matNextPrevDiv').children('button:last').attr('class', 'btn_code_right01');
				} else {
					$('#matNextPrevDiv').children('button:last').attr('class', 'btn_code_right02');
				}
			},
			error: function(a,b,c){
				//console.log(a,b,c);
				alert('자재검색 실패[2] - 시스템 담당자에게 문의하세요');
			},
			complete: function(){
				$('#lab_loading').hide();
			}
		})
	}
	
	function fn_closeMatRayer(){
		$('#searchMatValue').val('')
		$('#matLayerBody').empty();
		$('#matLayerBody').append('<tr><td colspan="9">원료코드 혹은 원료코드명을 검색해주세요</td></tr>');
		$('#matCount').text(0);
		closeDialog('dialog_material');
	}
	
	function setMaterialPopupData(parentRowId, itemMatIdx, itemSAPCode, itemName, itemUnitPrice, itemUnit, itemStandard, itemKeep, itemExp){
		var varKeep = nvl2(itemKeep,'');
		var varExp = nvl2(itemExp,'');
		var varKeepExp = "";
		if( varKeep != '' && varExp != '' ) {
			varKeepExp = varKeep+" / "+varExp;
		} else {
			if( varKeep != '' ) {
				varKeepExp = varKeep;
			}
			
			if( varExp != '' ) {
				varKeepExp = varExp;
			}
		}
		$('#'+parentRowId + ' input[name$=itemMatIdx]').val(itemMatIdx);
		$('#'+parentRowId + ' input[name$=itemSapCode]').val(itemSAPCode);
		$('#'+parentRowId + ' input[name$=itemName]').val(itemName);
		$('#'+parentRowId + ' input[name$=itemStandard]').val(nvl2(itemStandard,''));

		$('#'+parentRowId + ' input[name$=itemKeepExp]').val(varKeepExp);
		$('#'+parentRowId + ' input[name$=itemUnitPrice]').val(itemUnitPrice);
				
		fn_closeMatRayer();
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
	
	//입력확인
	function fn_insert(){
		var contents = editor.getData();
		if( !chkNull($("#title").val()) ) {
			alert("제목을 입력해 주세요.");
			$("#title").focus();
			return;
		} else if( !chkNull($("#menuCode").val()) ) {
			alert("메뉴 코드를 입력해 주세요.");
			$("#menuCode").focus();
			return;
		} else if( !chkNull($("#menuName").val()) ) {
			alert("메뉴명을 입력해 주세요.");
			$("#menuName").focus();
			return;
		} else if( !chkNull($("#selectTxtFull").val()) ) {
			alert("메뉴유형을 선택해 주세요.");
			return;
		} else if( selectedArr.length == 0 ) {
			alert("메뉴유형을 선택하여 주세요.");		
			return;
		} else if( attatchFileArr.length == 0 ) {
			alert("메뉴파일을 등록해주세요.");		
			return;
		} else if( !chkNull(contents) ) {
			alert("기안문을 작성해주세요.");		
			return;
		} else {
			if( $('input[name=newMat]:checked').val() == 'Y' ) {
				var matCount = 0;
				var validMat = true;
				$('tr[id^=matRow]').toArray().forEach(function(contRow){
					var rowId = $(contRow).attr('id');
					var itemSapCode = $('#'+ rowId + ' input[name=itemSapCode]').val();
					var itemName = $('#'+ rowId + ' input[name=itemName]').val();
					var mixingRatio = $('#'+ rowId + ' input[name=mixingRatio]').val();
					
					if(itemSapCode.length <= 0){
						validMat = false;
						return;
					}
					if(itemName.length <= 0){
						validMat = false;
						return;
					}
					matCount++;
				})
				if( matCount == 0 || !validMat) {
					alert('신규원료를 입력해주세요.');
					return;
				}
			}			
			//기존 데이터 확인
			var URL = "../menu/selectMenuDataCountAjax";
			$.ajax({
				type:"POST",
				url:URL,
				data:{
					"menuCode":$("#menuCode").val()
				},
				dataType:"json",
				success:function(result) {
					if( result.COUNT > 0 ) {
						alert("이미 존재하는 코드입니다.");
					    return;
					} else {
						var formData = new FormData();
						formData.append("title",$("#title").val());
						formData.append("menuCode",$("#menuCode").val());
						formData.append("menuName",$("#menuName").val());
						formData.append("contents",contents);
						formData.append("newMat",$('input[name=newMat]:checked').val());
						formData.append("menuType",selectedArr);
						
						for (var i = 0; i < attatchFileArr.length; i++) {
							formData.append('file', attatchFileArr[i])
						}
						
						for (var i = 0; i < attatchFileTypeArr.length; i++) {
							formData.append('fileTypeText', attatchFileTypeArr[i].fileTypeText)			
						}
						
						for (var i = 0; i < attatchFileTypeArr.length; i++) {
							formData.append('fileType', attatchFileTypeArr[i].fileType)			
						}
						
						$('select[name=docTypeTemp] option:selected').each(function(index){
							formData.append('docType', $(this).attr('value'));
							formData.append('docTypeText', $(this).text());
						});
						
						if( $('input[name=newMat]:checked').val() == 'Y' ) {
							var rowIdArr = new Array();
							var itemMatIdxArr = new Array();
							var itemSapCodeArr = new Array();
							var itemNameArr = new Array();
							var itemStandardArr = new Array();
							var itemKeepExpArr = new Array();
							var itemUnitPriceArr = new Array();
							var itemDescArr = new Array();
							$('tr[id^=matRow]').toArray().forEach(function(contRow){
								var rowId = $(contRow).attr('id');
								var itemMatIdx = $('#'+ rowId + ' input[name=itemMatIdx]').val();
								var itemSapCode = $('#'+ rowId + ' input[name=itemSapCode]').val();
								var itemName = $('#'+ rowId + ' input[name=itemName]').val();
								var itemStandard = $('#'+ rowId + ' input[name=itemStandard]').val();
								var itemKeepExp = $('#'+ rowId + ' input[name=itemKeepExp]').val();
								var itemUnitPrice = $('#'+ rowId + ' input[name=itemUnitPrice]').val();
								var itemDesc = $('#'+ rowId + ' input[name=itemDesc]').val();
								rowIdArr.push(rowId);
								itemMatIdxArr.push(itemMatIdx);
								itemSapCodeArr.push(itemSapCode);
								itemNameArr.push(itemName);
								itemStandardArr.push(itemStandard);
								itemKeepExpArr.push(itemKeepExp);
								itemUnitPriceArr.push(itemUnitPrice);
								itemDescArr.push(itemDesc);
							});
							formData.append("rowIdArr", rowIdArr);
							formData.append("itemMatIdxArr", itemMatIdxArr);
							formData.append("itemSapCodeArr", itemSapCodeArr);
							formData.append("itemNameArr", itemNameArr);
							formData.append("itemStandardArr", itemStandardArr);
							formData.append("itemKeepExpArr", itemKeepExpArr);
							formData.append("itemUnitPriceArr", itemUnitPriceArr);
							formData.append("itemDescArr", itemDescArr);
						}
						
						URL = "../menu/insertMenuAjax";
						$.ajax({
							type:"POST",
							url:URL,
							data: formData,
							processData: false,
					        contentType: false,
					        cache: false,
							dataType:"json",
							success:function(result) {
								if( result.RESULT == 'S' ) {
									alert($("#menuName").val()+"("+$("#menuCode").val()+")"+"가 정상적으로 생성되었습니다.");
									fn_list();
								} else {
									alert("오류가 발생하였습니다.\n"+result.MESSAGE);
								}
							},
							error:function(request, status, errorThrown){
								alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
							}			
						});
						
					}
				},
				error:function(request, status, errorThrown){
					alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
				}			
			});
			
			//formdata 설정 및 저장
		}
	}

	function fn_list() {
		location.href = '/menu/menuList';
	}
	
	function nvl2(str, defaultStr){
	    
	    if(typeof str == "undefined" || str == null || str == "" || str == "null")
	        str = defaultStr ;
	     
	    return str ;
	}
</script>
<div class="wrap_in" id="fixNextTag">
	<span class="path">
		메뉴 개발완료보고서&nbsp;&nbsp;
		<img src="/resources/images/icon_path.png" style="vertical-align: middle" />&nbsp;&nbsp;메뉴 완료보고서&nbsp;&nbsp;
		<img src="/resources/images/icon_path.png" style="vertical-align: middle" />&nbsp;&nbsp;<a href="#none">${strUtil:getSystemName()}</a>
	</span>
	<section class="type01">
		<h2 style="position:relative">
			<span class="title_s">Menu Complete Doc</span><span class="title">메뉴 개발완료보고서</span>
			<div class="top_btn_box">
				<ul>
					<li>
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
							<td colspan="5"><input type="text" name="title" id="title" style="width: 90%;" class="req" /></td>
						</tr>
						<tr>
							<th style="border-left: none;">메뉴코드</th>
							<td>
								<input type="hidden"  name="isSample" id="isSample" value="N"/>
								<input type="text"  style="width:200px; float: left" class="req" name="menuCode" id="menuCode" placeholder="코드를 조회/생성 하세요." readonly/>
								<button class="btn_small_search ml5" onclick="openDialog('dialog_erpMaterial')" style="float: left">조회</button>
								<button class="btn_small_search ml5" onclick="selectNewCode()" style="float: left">생성</button>
							</td>
							<th style="border-left: none;">메뉴명</th>
							<td>
								<input type="text"  style="width:200px; float: left" class="req" name="menuName" id="menuName"/>
							</td>
						</tr>
						<tr>
							<th style="border-left: none;">메뉴유형</th>
							<td colspan="5">
								<input class="" id="selectTxtFull" name="selectTxtFull" type="text" style="width: 450px; float: left" readonly>
								<button class="btn_small_search ml5" onclick="openDialog('dialog_menu')" style="float: left">조회</button>
							</td>
						</tr>
						<tr>
							<th style="border-left: none;">신규원료사용 유무</th>
							<td colspan="5">
								<input type="radio" name="newMat" id="newMat1" value="N" onclick="changeNewMat(event)" checked="checked">
								<label for="newMat1"><span></span>사용안함</label>
								<input type="radio" name="newMat" id="newMat2" onclick="changeNewMat(event)" value="Y">
								<label for="newMat2"><span></span>사용</label>
							</td>
						</tr>
						<tr>
							<th style="border-left: none;">첨부파일 유형</th>
							<td colspan="5">
								<div id="docTypeTxt"></div>
								<select id="docTypeTemp" name="docTypeTemp" multiple style='display:none'>
								</select>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			
			<div id="matNewDiv" style="display:none">
				<div class="title2" style="float: left; margin-top: 30px;">
					<span class="txt">신규원료</span>
				</div>
				<div id="matHeaderDiv" class="table_header07">
					<span class="table_order_btn"><button class="btn_up" onclick="moveUp(this)"></button><button class="btn_down" onclick="moveDown(this)"></button></span>
					<span class="table_header_btn_box">
						<button class="btn_add_tr" onclick="addRow(this, 'mat')"></button><button class="btn_del_tr" onclick="removeRow(this)"></button>
					</span>
				</div>
				<table id="matTable" class="tbl05">
					<colgroup>
						<col width="20">
						<col width="140">
						<col width="250">
						<col width="150">
						<col width="200">
						<col width="8%">
						<col />
					</colgroup>
					<thead>
						<tr>
							<th><input type="checkbox" id="matTable_1" onclick="checkAll(event)"><label for="matTable_1"><span></span></label></th>
							<th>원료코드</th>
							<th>원료명</th>
							<th>규격</th>
							<th>보관방법 및 유통기한</th>
							<th>공급가</th>
							<th>비고</th>
						</tr>
					</thead>
					<tbody id="matTbody" name="matTbody">
						<tr id="matRow_1" class="temp_color">
							<td>
								<input type="checkbox" id="mat_1"><label for="mat_1"><span></span></label>
								<input type="hidden" name="itemType"/>
								<input type="hidden" name="itemTypeName"/>
							</td>
							<td>
								<input type="hidden" name="itemMatIdx" style="width: 100px" class="req code_tbl" />
								<input type="text" name="itemSapCode" style="width: 100px" class="req code_tbl" onkeyup="checkMaterail(event)"/>
								<button class="btn_code_search2" onclick="openMaterialPopup(this)"></button>
							</td>
							<td>
								<input type="text" name="itemName" style="width: 85%" readonly="readonly" class="read_only" />
							</td>
							<td><input type="text" name="itemStandard" style="width: 100%" class=""/></td>
							<td><input type="text" name="itemKeepExp" style="width: 100%" class=""/></td>
							<td><input type="text" name="itemUnitPrice" style="width: 100%"  readonly="readonly" class="read_only"/></td>
							<td><input type="text" name="itemDesc" style="width: 100%"/></td>
						</tr>
					</tbody>
					<tfoot>
					</tfoot>
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
			
			<div class="title2 mt20"  style="width:90%;"><span class="txt">기안문</span></div>
			<div class="main_tbl">
				<ul>
					<li class="">
						<div class="text_insert" style="padding: 0px;">
							<textarea name="contents" id="contents" style="width: 666px; height: 200px; display: none;">
							<h2><strong>1. 제품명</strong></h2><p>&nbsp;</p><h2><strong>2. 개발목적</strong></h2><p>&nbsp;</p><h2><strong>3. 제품특징</strong></h2><p>&nbsp;</p><h2><strong>4. 용도</strong></h2><p>&nbsp;</p><h2><strong>5. 제품규격</strong></h2><p>&nbsp;</p><h2><strong>6. 도입예정일</strong></h2><p>&nbsp;</p><p>&nbsp;</p>
							</textarea>
							<script type="text/javascript" src="/resources/editor/build/ckeditor.js"></script>
						</div>
					</li>
				</ul>
			</div>
			
			<div class="main_tbl">
				<div class="btn_box_con5">
					<button class="btn_admin_gray" onClick="goDocDetail();" style="width: 120px;">목록</button>
				</div>
				<div class="btn_box_con4">
					<!-- 
					<button class="btn_admin_red">임시/템플릿저장</button>
					<button class="btn_admin_navi">임시저장</button>
					 -->
					<button class="btn_admin_sky" onclick="fn_insert()">저장</button>
					<button class="btn_admin_gray" onclick="goDocDetail()">취소</button>
				</div>
				<hr class="con_mode" />
			</div>
		</div>
	</section>
</div>

<table id="tmpMatTable" class="tbl05" style="display:none">
	<colgroup>
		<col width="20">
		<col width="140">
		<col />
		<col width="8%">
		<col width="5%">
		<col width="8%">
	</colgroup>
	<thead>
		<tr>
			<th><input type="checkbox" id="matTable_1" onclick="checkAll(event)"><label for="matTable_1"><span></span></label></th>
			<th>원료코드</th>
			<th>원료명</th>
			<th>단가</th>
			<th>수량</th>
			<th>가격</th>
		</tr>
	</thead>
	<tbody id="tmpMatTbody" name="tmpMatTbody">
		<tr id="tempMatRow_1" class="temp_color">
			<td>
				<input type="checkbox" id="mat_1"><label for="mat_1"><span></span></label>
				<input type="hidden" name="itemType"/>
				<input type="hidden" name="itemTypeName"/>
			</td>
			<td>
				<input type="hidden" name="itemMatIdx" style="width: 100px" class="req code_tbl" />
				<input type="text" name="itemSapCode" style="width: 100px" class="req code_tbl" onkeyup="checkMaterail(event)"/>
				<button class="btn_code_search2" onclick="openMaterialPopup(this)"></button>
			</td>
			<td>
				<input type="text" name="itemName" style="width: 85%" readonly="readonly" class="read_only" />
			</td>
			<td><input type="text" name="itemStandard" style="width: 100%" class=""/></td>
			<td><input type="text" name="itemKeepExp" style="width: 100%" class=""/></td>
			<td><input type="text" name="itemUnitPrice" style="width: 100%"  readonly="readonly" class="read_only"/></td>
			<td><input type="text" name="itemDesc" style="width: 100%"/></td>
		</tr>
	</tbody>
	<tfoot>
	</tfoot>
</table>

<!-- SAP 코드 검색 레이어 start-->
<!-- SAP 코드 검색 추가레이어 start-->
<!-- 신규로 레이어창을 생성하고싶을때는  아이디값 교체-->
<!-- 클래스 옆에 적힌 스타일 값을 인라인으로 작성해서 팝업 사이즈를 직접 조정 -->
<div class="white_content" id="dialog_erpMaterial">
	<input id="erpTargetID" type="hidden">
	<input id="erpItemType" type="hidden">
	<div class="modal positionCenter" style="width: 900px; height: 600px; margin-left: -55px; margin-top: -50px ">
		<h5 style="position: relative">
			<span class="title">원료코드 검색</span>
			<div class="top_btn_box">
				<ul>
					<li><button class="btn_madal_close" onClick="fn_closeErpMatRayer()"></button></li>
				</ul>
			</div>
		</h5>

		<div id="erpMatListDiv" class="code_box">
			<input id="searchErpMatValue" type="text" class="code_input" onkeyup="bindDialogEnter(event)" style="width: 300px;" placeholder="일부단어로 검색가능">
			<img src="/resources/images/icon_code_search.png" onclick="fn_searchErpMaterial()"/>
			<div class="code_box2">
				(<strong> <span id="erpMatCount">0</span> </strong>)건
			</div>
			<div class="main_tbl">
				<table class="tbl07">
					<colgroup>
						<col width="40px">
						<col width="10%">
						<col width="20%">
						<col width="8%">
						<col width="8%">
						<col width="8%">
						<col width="auto">
						<col width="10%">
						<col width="10%">
					</colgroup>
					<thead>
						<tr>
							<th></th>
							<th>SAP코드</th>
							<th>상품명</th>
							<th>보관기준</th>
							<th>사이즈</th>
							<th>중량</th>
							<th>규격</th>
							<th>원산지</th>
							<th>유통기한</th>
						<tr>
					</thead>
					<tbody id="erpMatLayerBody">
						<input type="hidden" id="erpMatLayerPage" value="0"/>
						<Tr>
							<td colspan="9">원료코드 혹은 원료코드명을 검색해주세요</td>
						</Tr>
					</tbody>
				</table>
				<!-- 뒤에 추가 리스트가 있을때는 클래스명 02로 숫자변경 -->
				<div id="erpMatNextPrevDiv" class="page_navi  mt10">
					<button class="btn_code_left01" onclick="fn_searchErpMaterial('prevPage')"></button>
					<button class="btn_code_right02" onclick="fn_searchErpMaterial('nextPage')"></button>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- 코드검색 추가레이어 close-->
<!-- SAP 코드 검색 레이어 close-->

<!-- 첨부파일 추가레이어 start-->
<!-- 신규로 레이어창을 생성하고싶을때는  아이디값 교체-->
<!-- 클래스 옆에 적힌 스타일 값을 인라인으로 작성해서 팝업 사이즈를 직접 조정 -->
<div class="white_content" id="dialog_attatch">
	<div class="modal" style="margin-left: -355px; width: 710px; height: 550px; margin-top: -250px">
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
								<input id="attatch_common_text" class="form-control form_point_color01" type="text" placeholder="파일을 선택해주세요." style="width:145px;/* width:308px;  */float:left; cursor: pointer; color: black;" onclick="callAddFileEvent()" readonly="readonly">
								<!-- <label class="btn-default" for="attatch_common" style="float:left; margin-left: 5px; width: 57px">파일 선택</label> -->
								<input id="attatch_common" type="file" style="display:none;" onchange="setFileName(this)">
							</span>
							<button class="btn_small02 ml5" onclick="addFile(this, '00')">파일등록</button>
						</div>
						<div style="float: left; display: inline-block; margin-top: 5px">
							
						</div>
					</dd>
				</li>
				<li class=" mb5">
					<dt style="width: 20%">파일유형</dt>
					<dd style="width: 80%;">
						<input id="checkbox_item1" name="docType" type="checkbox" value="10"/>
						<label for="checkbox_item1" style="vertical-align: middle;"><span></span>컨셉서-개발목적</label>
						<input id="checkbox_item2" name="docType" type="checkbox" value="20"/>
						<label for="checkbox_item2" style="vertical-align: middle;"><span></span>사전원가서</label>
						<input id="checkbox_item3" name="docType" type="checkbox" value="30"/>
						<label for="checkbox_item3" style="vertical-align: middle;"><span></span>조리메뉴얼</label>						
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

<!-- 원료 선택 레이어 start-->
<div class="white_content" id="dialog_menu">
	<div class="modal" style="	width: 400px;margin-left:-210px;height: 350px;margin-top:-100px;">
		<h5 style="position:relative">
			<span class="title">메뉴구분</span>
			<div  class="top_btn_box">
				<ul>
					<li>
						<button class="btn_madal_close" onClick="closeDialog('dialog_menu')"></button>
					</li>
				</ul>
			</div>
		</h5>
		<div style="height: 200px; overflow-x: hidden; overflow-y: auto;">
			<div id="jsTree"></div> 
		</div>
		<div class="btn_box_con">
			<button class="btn_small02" onclick="closeDialog('dialog_menu')"> 취소</button>
		</div>
	</div>
</div>
<!-- 원료 선택 레이어 close-->

<!-- 신규 자재코드 검색 추가레이어 start-->
<!-- 신규로 레이어창을 생성하고싶을때는  아이디값 교체-->
<!-- 클래스 옆에 적힌 스타일 값을 인라인으로 작성해서 팝업 사이즈를 직접 조정 -->
<div class="white_content" id="dialog_material">
	<input id="targetID" type="hidden">
	<input id="itemType" type="hidden">
	<div class="modal positionCenter" style="width: 900px; height: 600px">
		<h5 style="position: relative">
			<span class="title">원료코드 검색</span>
			<div class="top_btn_box">
				<ul>
					<li><button class="btn_madal_close" onClick="fn_closeMatRayer()"></button></li>
				</ul>
			</div>
		</h5>

		<div id="matListDiv" class="code_box">
			<input id="searchMatValue" type="text" class="code_input" onkeyup="bindDialogEnter(event)" style="width: 300px;" placeholder="일부단어로 검색가능">
			<img src="/resources/images/icon_code_search.png" onclick="searchMaterial()"/>
			<div class="code_box2">
				(<strong> <span id="matCount">0</span> </strong>)건
			</div>
			<div class="main_tbl">
				<table class="tbl07">
					<colgroup>
						<col width="40px">
						<col width="10%">
						<col width="20%">
						<col width="8%">
						<col width="8%">
						<col width="8%">
						<col width="auto">
						<col width="10%">
						<col width="10%">
					</colgroup>
					<thead>
						<tr>
							<th></th>
							<th>SAP코드</th>
							<th>상품명</th>
							<th>보관기준</th>
							<th>사이즈</th>
							<th>중량</th>
							<th>규격</th>
							<th>원산지</th>
							<th>유통기한</th>
						<tr>
					</thead>
					<tbody id="matLayerBody">
						<input type="hidden" id="matLayerPage" value="0"/>
						<Tr>
							<td colspan="9">원료코드 혹은 원료코드명을 검색해주세요</td>
						</Tr>
					</tbody>
				</table>
				<!-- 뒤에 추가 리스트가 있을때는 클래스명 02로 숫자변경 -->
				<div id="matNextPrevDiv" class="page_navi  mt10">
					<button class="btn_code_left01" onclick="searchMaterial('prevPage')"></button>
					<button class="btn_code_right02" onclick="searchMaterial('nextPage')"></button>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- 코드검색 추가레이어 close-->