<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="userUtil" uri="/WEB-INF/tld/userUtil.tld"%>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ taglib prefix="dateUtil" uri="/WEB-INF/tld/dateUtil.tld"%>
<title>제품개발문서>제조공정서</title>
<style type="text/css">
.readOnly {
	background-color: #ddd
}
</style>

<style>
.positionCenter{
	position: absolute;
	transform: translate(-50%, -50%);
}
</style>

<link href="/resources/css/mfg.css" rel="stylesheet" type="text/css">
<script type="text/javascript">
	var tBodyNumber = 1;
	var rowNumber = 1;
	
	var subProdDiv;
	
	var mixTable;
	var contentTable;
	
	var mixRow;
	var contentRow;
	var dispRow;
	var packageRow;
	var consumeRow;
	
	$(document).ready(function(){
		$(document).keydown(function(e){   
	        if(e.target.nodeName != "INPUT" && e.target.nodeName != "TEXTAREA"){       
	            if(e.keyCode === 8){   
	            return false;
	            }
	        }
	    });
		
		loadCompany('company');
		loadCodeList( "KEEPCONDITION", "keepConditionCode" );
		
		var keepConditionCode = '${mfgProcessDoc.keepConditionCode}';
		if(keepConditionCode.length > 0){
			$('#keepConditionCode option[value='+keepConditionCode+']').prop('selected', true);
			$('#keepConditionCode').change()
		}
		
		var keepConditionCode = '${mfgProcessDoc.keepConditionCode}';
		if(keepConditionCode.length > 0){
			$('#keepConditionCode option[value='+keepConditionCode+']').prop('selected', true);
			$('#keepConditionCode').change();
			$('#label_keepConditionCode').text($('#keepConditionCode option[value='+keepConditionCode+']').text())
		}
		
		mixTable = '<div class="nomal_mix">'+$('#mixDiv_temp').html()+'</div>';
		mixRow = '<tr>'+$('#mixRow_temp').html()+'</tr>';
		dispRow = '<tr>'+$('#dispRow_temp').html()+'</tr>';
		packageRow = '<tr>'+$('#pkgRow_temp').html()+'</tr>';
		consumeRow = '<tr>'+$('#consumeRow_temp').html()+'</tr>';
		
		$('#mixDiv_temp').remove();
		$('#dispTable_temp').remove();
		$('#pkgTable_temp').remove();
		$('#consTable_temp').remove();
		
		$('#btn_temp').remove();
		
		var companyCode = '${mfgProcessDoc.companyCode}'
		var plantCode = '${mfgProcessDoc.plantCode}';
		var lineCode = '${mfgProcessDoc.lineCode}';
		var lineProcessType = '${mfgProcessDoc.lineProcessType}';
		
		if(plantCode.length > 0){
			$('#mfg_plant_select option[value='+plantCode+']').prop('selected', true);
			$('#mfg_plant_select').change();
		}
		
		if(lineCode.length > 0){
			$('#mfg_plantline_select option[value='+lineCode+']').prop('selected', true);
			$('#mfg_plantline_select').change();
		}
		
		if(lineProcessType.length > 0){
			$('#lineProcessType option[value='+lineProcessType+']').prop('selected', true);
			$('#lineProcessType').change();
		}
	});
	
	function bindEnterKeySapCode(element){
		$(element).bind('keyup', function(e){ if(e.keyCode== 13) $(e.target).next().click() });
	}
	
	function changeImportType(e){
		var docType = e.target.value;
		if(docType == 'design'){
			$('#dialog_create_li_design').show()
			$('#dialog_create_li_mfg').hide()
		} else {
			$('#dialog_create_li_design').hide()
			$('#dialog_create_li_mfg').show()
		}
	}
	
	
	function selectChange(e){
		var target = $(e.target);
		var value = e.target.value;
		
		target.parent().children('label').text(value);
		target.children('option').toArray().forEach(function(option){
			if($(option).val() == value) {
				$(option).attr('checked', true)
			} else {
				$(option).attr('checked', false)
			}
		})
		
		if(e.target.name == 'keepConditionCode' && value == 7){
			target.parent().children('label').text('직접입력');
			$('input[name=keepCondition]').show();
			$('input[name=keepCondition]').attr('disabled', false);
			$('input[name=keepCondition]').addClass('req')
			target.parent().css('width', '36%')
		} else {
			$('input[name=keepCondition]').hide();
			$('input[name=keepCondition]').val('');
			$('input[name=keepCondition]').attr('disabled', true);
			$('input[name=keepCondition]').removeClass('req')
			target.parent().css('width', '99%')
		}
	}
	
	function setMaterialPopupData(parentRowId, itemImNo, itemSAPCode, itemName, itemUnitPrice, itemUnit){
		$('#'+parentRowId + ' input[name$=itemImNo]').val(itemImNo);
		$('#'+parentRowId + ' input[name$=itemSapCode]').val(itemSAPCode);
		$('#'+parentRowId + ' input[name$=itemName]').val(itemName);
		$('#'+parentRowId + ' input[name$=itemUnitPrice]').val(itemUnitPrice);
		$('#'+parentRowId + ' input[name$=itemCustomPrice]').val(itemUnitPrice);
		$('#'+parentRowId + ' input[name$=itemUnit]').val(itemUnit);
		$('#'+parentRowId + ' input[name$=itemCalculatedPrice]').val(itemUnitPrice);
		
		if(itemName.indexOf('[임시]') >= 0){
			$('#'+parentRowId).css('background-color', '#ffdb8c');
		} else {
			$('#'+parentRowId).css('background-color', '#fff');
		}
		
		if(itemSAPCode.indexOf('4') == 0 || itemSAPCode.indexOf('5') == 0){
			$('#'+parentRowId + ' input[name*=itemBomRate]').css('background-color', '#ffe8d9');
			$('#'+parentRowId + ' input[name*=itemWeight]').css('background-color', '#ffe8d9');
		} else {
			$('#'+parentRowId + ' input[name*=itemBomRate]').css('background-color', '#fff');
			$('#'+parentRowId + ' input[name*=itemWeight]').css('background-color', '#fff');
		}
			
		closeMatRayer();
		calcTotalWeight();
	}		
	
	function setUniqueId(tagName, duplId){
		var parentId = $(tagName+'[id='+duplId+']:first').attr('id').split('_')[0]+'_';
		var randomId = Math.random().toString(36).substr(2, 9);
		
		var targetElement = $(tagName+'[id='+duplId+']:last');
		var targetLabelElement =$(tagName+'[id='+duplId+']:last').parent().children('label');
		
		targetElement.attr('id', parentId+randomId);
		targetLabelElement.attr('for', parentId+randomId);
	}
	
	function addTable(element, type){
		rowNumber++;
		tBodyNumber++;
		
		var target;
		var bodyId;
		var tableBody;
		
		if(type == 'mix') {
			bodyId = 'mixTbody_';
			tableBody = mixTable;
			target = $('div.tbl_in_con:first div.nomal_mix');
		}
		if(type == 'content') {
			bodyId = 'contentTbody_';
			tableBody = contentTable;
			target = $('div.tbl_in_con:last div.nomal_mix')
		}
		
		var randomId = randomId = Math.random().toString(36).substr(2, 9);
		
		$(element).parent().children('div.add_nomal_mix').before(tableBody);
		var insertedTbody = $(element).prev().children('table').children('tbody');
		insertedTbody.children('tr').children('td:first').children('input[type=checkbox]').attr('id', type+'_'+randomId)
		insertedTbody.children('tr').children('td:first').children('label').attr('for', type+'_'+randomId)
	}
	
	function removeTable(element, type){
		var elementType = $(element).parent().parent().children('span.title').text().trim().split(' ')[0];
		var elementName = $(element).parent().parent().children('span.title').children('input[name=baseName]').val();
		var message = (type == 'package' ? elementType + ' 테이블을 지우시겠습니까?' : elementType + ' [' + elementName + '] 테이블을 지우시겠습니까?'); 
				
		if(confirm(message)){
			$(element).parent().parent().parent().remove();
		}
	}
	
	function addRow(element, type){
		var randomId = randomId = Math.random().toString(36).substr(2, 9);
		var randomId2 = randomId = Math.random().toString(36).substr(2, 9);
		
		var row;
		if(type == 'mix') row = mixRow;
		if(type == 'content') row = contentRow;
		if(type == 'disp') row = dispRow;
		if(type == 'pkg') row = packageRow;
		if(type == 'consume') row = consumeRow;
		
		$(element).parent().parent().next().children('tbody').append(row);
		$(element).parent().parent().next().children('tbody').children('tr:last').attr('id', type + 'Row_' + tBodyNumber + '_' + randomId);
		$(element).parent().parent().next().children('tbody').children('tr:last').children('td').children('input[type=checkbox]').attr('id', type+'_'+randomId);
		$(element).parent().parent().next().children('tbody').children('tr:last').children('td').children('label').attr('for', type+'_'+randomId);
		$(element).parent().parent().next().children('tbody').children('tr:last').children('td').children('div').children('select[id^=select_storage]').attr('id', 'select_storage_'+type+'_'+randomId);
		$(element).parent().parent().next().children('tbody').children('tr:last').children('td').children('div').children('label[id^=select_storage]').attr('id', 'select_storage_'+type+'_'+randomId);
		$(element).parent().parent().next().children('tbody').children('tr:last').children('td').children('div').children('label').attr('for', 'select_storage_'+type+'_'+randomId);
		$(element).parent().parent().next().children('tbody').children('tr:last').children('td').children('div').children('label').attr('for', 'select_origin_'+type+'_'+randomId);
		//var itemSapCodeElement = $(element).parent().parent().next().children('tbody').children('tr:last').children('td').children('input[name=itemSapCode]');
		//bindEnterKeySapCode(itemSapCodeElement);
		
		$('input[name=calcType]:checked').click()
		
		if(type == 'disp' && $('input[name=isAutoDisp]').val() == '0'){
			var tr = $(element).parent().parent().next().children('tbody').children('tr:last');
			tr.children('td').toArray().forEach(function(td){
				$(td).children('input[name=matName]').attr('readonly', false);
				$(td).children('input[name=matName]').attr('class', '');
				$(td).children('input[name=excRate]').attr('readonly', false);
				$(td).children('input[name=excRate]').attr('class', '');
				$(td).children('input[name=incRate]').attr('readonly', false);
				$(td).children('input[name=incRate]').attr('class', '');
			})
		}
		
		$('select[id^=select_storage]').change(function(){
		    var select_name = $(this).children("option:selected").text();
		    $(this).siblings("label").text(select_name);
		})
		
		$('select[id^=select_origin]').change(function(){
		    var select_name = $(this).children("option:selected").text();
		    $(this).siblings("label").text(select_name);
		})
	}
	
	function removeRow(element){
		$(element).parent().parent().next().children('tbody').children('tr').toArray().forEach(function(v, i){
			var checkBoxId = $(v).children('td:first').children('input[type=checkbox]')[0].id;
			if($('#'+checkBoxId).is(':checked')) $(v).remove();
		})
	}
	
	function moveUp(element){
		if(checkedCnt == 0) return alert('이동시키려는 열을 선택해주세요');
		
		var tbody = $(element).parent().parent().next().children('tbody');
		var checkboxArr = tbody.children('tr').children('td').children('input[type=checkbox]').toArray();
		
		var checkedCnt = 0;
		var checkedId;
		checkboxArr.forEach(function(v, i){
			if($(v).is(':checked')){
				checkedCnt++;
				checkedId = v.id
				
				var $element = $('#'+checkedId).parent().parent();
				$element.prev().before($element);
			}
		});
		//if(checkedCnt > 1) return alert('열을 이동하는 하는 경우에는 1개의 열만 선택해주세요');
	}
	
	function moveDown(element){
		if(checkedCnt == 0) return alert('이동시키려는 열을 선택해주세요');
		
		var tbody = $(element).parent().parent().next().children('tbody');
		var checkboxArr = tbody.children('tr').children('td').children('input[type=checkbox]').toArray();
		
		var checkedCnt = 0;
		var checkedId;
		checkboxArr.reverse().forEach(function(v, i){
			if($(v).is(':checked')){
				checkedCnt++;
				checkedId = v.id
				
				var $element = $('#'+checkedId).parent().parent();
				$element.next().after($element);
			}
		});
		//if(checkedCnt > 1) return alert('열을 이동하는 하는 경우에는 1개의 열만 선택해주세요');
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
		if ((/^\./g).test(numStr)){ //첫번째가 '.' 이면 .를 삭제
			numStr = numStr.replace(/^\./g, "");
			alert("소수점이 첫 글자이면 안됩니다.");
			needToSet = true;
		}
		if((/[^\d.]/g).test(numStr)) {  //숫자 '.'  이외 엔 없는지 확인 후 있으면 replace
			numStr = numStr.replace(/[^\d.]/g,"");
			CaretPos--;
			alert("입력은 숫자와 소수점 만 가능 합니다.");('.')
			needToSet = true;
		}
		if(needToSet) { //변경이 필요할 경우에만 셋팅함.
			obj.value = numStr;
			setCaretPosition(obj, CaretPos)
		}
	}
	
	function clearNoNum2(obj){
		var needToSet = false;
		var isMinus = true;
		if(obj.value == '-')
			return true;
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
		if(numStr < 0){
			isMinus = true;
			numStr = numStr*-1
		}
		if ((/^\./g).test(numStr)){ //첫번째가 '.' 이면 .를 삭제
			numStr = numStr.replace(/^\./g, "");
			alert("소수점이 첫 글자이면 안됩니다.");
			needToSet = true;
		}
		if((/[^\d.]/g).test(numStr)) {  //숫자 '.'  이외 엔 없는지 확인 후 있으면 replace
			numStr = numStr.replace(/[^\d.]/g,"");
			CaretPos--;
			alert("입력은 숫자와 소수점 만 가능 합니다.");('.')
			needToSet = true;
		}
		if(isMinus){
			numStr = numStr*-1;
		}
		if(needToSet) { //변경이 필요할 경우에만 셋팅함.
			obj.value = numStr;
			setCaretPosition(obj, CaretPos)
		}
	}
	
	function doGetCaretPosition (ctrl){
		var CaretPos = 0;
		if (document.selection){//IE
			ctrl.focus ();
			var Sel = document.selection.createRange ();
			Sel.moveStart ('character', -ctrl.value.length);
			CaretPos = Sel.text.length;
		}else if (ctrl.selectionStart || ctrl.selectionStart == '0'){// Firefox support
			CaretPos = ctrl.selectionStart;
		}
		return (CaretPos);
	}
	
	function setCaretPosition(ctrl, pos){
		if(ctrl.setSelectionRange){
			ctrl.focus();
			ctrl.setSelectionRange(pos,pos);
		}else if (ctrl.createTextRange){
			var range = ctrl.createTextRange();
			range.collapse(true);
			range.moveEnd('character', pos);
			range.moveStart('character', pos);
			range.select();
		}
	}
	
	function saveValid(){
		if($('textarea[name=memo]').val().length == 0){
			alert('설명을 입력하세요');
			$('textarea[name=memo]').focus();
			return false;
		}
		
		var calcType = $('input[name=calcType]:checked').val();
		
		if($('input[name=bomRate]').val().length == 0){
			alert('BOM수율을 입력하세요');
			$('input[name=bomRate]').focus();
			return false;;
		}
		
		if($('input[name=docProdName]').val().length == 0){
			alert('품목제조보고서명을 입력하세요');
			$('input[name=docProdName]').focus();
			return false;;
		}
		
		var baseValid = true;
		$('input[name=baseName]').toArray().forEach(function(baseName){
			if(!baseValid) return;
		    var type = $(baseName).parent().siblings('input').val();
		    var typeText;
		    if(type == 'MI') typeText = '배합비';
		    if(type == 'CI') typeText = '내용물';
		    var baseNameText = $(baseName).val();
		    if(baseNameText.length <= 0){
				baseValid = false;
				$(baseName).focus();
				alert(typeText+'명을 입력해주세요');
				return false;
			}
		})
		if(!baseValid) return false;
		
		var mixValid = true;
		$('tr[id^=mixRow]').toArray().forEach(function(mixRow){
			if(!mixValid) return;
			
			var rowId = $(mixRow).attr('id');
			var itemSapCode = $('#'+ rowId + ' input[name=itemSapCode]').val();
			var itemName = $('#'+ rowId + ' input[name=itemName]').val();
			//var itemWeight = $('#'+ rowId + ' input[name=itemWeight]').val();
			
			//if(itemSapCode.length>0 || itemName.length>0 || itemWeight.length>0){
			if(itemSapCode.length>0 || itemName.length>0){
				if(itemSapCode.length <= 0){
					mixValid = false;
					alert('원료코드를 입력해주세요');
					return;
				}
				if(itemName.length <= 0){
					mixValid = false;
					alert('원료를 검색하여 선택해주세요');
					return;
				}
				/* if(itemWeight.length <= 0){
					mixValid = false;
					alert('중량을 입력해주세요');
					return;
				} */
			}
		})
		if(!mixValid) return false;
		
		var pkgValid = true;
		$('tr[id^=packageRow_1]').toArray().forEach(function(pkgRow){
			if(!pkgValid) return;
			
			var rowId = $(pkgRow).attr('id');
			var itemSapCode = $('#'+ rowId + ' input[name=itemSapCode]').val();
			var itemName = $('#'+ rowId + ' input[name=itemName]').val();
			
			if(itemSapCode.length >0 || itemName.length>0){
				if(itemSapCode.length <= 0){
					pkgValid = false;
					alert('원료코드를 입력해주세요');
					return;
				}
				if(itemName.length <= 0){
					pkgValid = false;
					alert('원료를 검색하여 선택해주세요');
					return;
				}
			}
		})
		if(!pkgValid) return false;
		
		return true;
	}
	
	function updateMfgProcessDoc(state){
		if(typeof state == "undefined" || state == null || state == ""){
			if( '${mfgProcessDoc.state}' == '7' ){
				state = '0';
			} else {
				state = '${mfgProcessDoc.state}';
			}
		} else if( state != '7' ) {
			state = '${mfgProcessDoc.state}';
		} else { 
			state = state;
		}
		
		if(!confirm('제조공정서를 ' + (state == '7' ? '임시저장' : '저장') + '하시겠습니까?')){
			return;
		}
		
		if(state != '7'){
			if(!saveValid()){
				return;
			}	
		}
		
		var docNo = '${mfgProcessDoc.docNo}'
		var docVersion = '${mfgProcessDoc.docVersion}'
		$.post('updateManufacturingProcessDoc', getPostData(state), function(data){
			if(data == 'S') {
				alert('문서 수정 완료');
				location.href = '/dev/productDevDocDetail?docNo='+docNo+'&docVersion='+docVersion
			} else {
				alert('문서 수정 실패(1) - 시스템 담당자에게 문의해주세요');
			}
			
		}).fail(function(res){
			//console.log('Error: ' + res.responseText)
			alert('문서 수정 실패(2) - 시스템 담당자에게 문의해주세요');
		})
	}
	
	
	var test;
	function getPostData(state){
		var postData = {};
		
		// 기준정보
		postData['dNo'] = '${dNo}';
		postData['docNo'] = '${mfgProcessDoc.docNo}';
		postData['docVersion'] = '${docVersion}';
		postData['regUserId'] = '${mfgProcessDoc.regUserId}';
		postData['state'] = state;
		postData['docType'] = 'N'; // N: 일반,  E: 엑셀
		postData['calcType'] = $('input[name=calcType]:checked').val();
		postData['companyCode'] = $('#mfg_company_select').val();
		postData['memo'] = $('textarea[name=memo]').val();
		postData['plantCode'] = $('#mfg_plant_select').val();
		postData['plantName'] = $('#mfg_plant_select option:selected').text();
		postData['stdAmount'] = $('input[name=subProdStdAmount]').val();
		var lineCode = $('#mfg_plantline_select').val();
		postData['lineCode'] =lineCode;
		if(lineCode != ''){
			postData['lineName'] = '';
		} else {
			postData['lineName'] = $('#mfg_plantline_select option:selected').text();
		}
		postData['mixWeight'] = $('input[name=subProdDivWeight]').val();	// 밀다원 배합중량 = 부속제품 분할 중량
		postData['bagAmout'] = $('input[name=bagAmout]').val();		// 밀다원 사용x
		postData['bomRate'] = $('input[name=bomRate]').val();	// 밀다원  100%
		postData['numBong'] = $('input[name=numBong]').val();		// 밀다원 사용x
		postData['numBox'] = $('input[name=numBox]').val();		// 밀다원 사용x
		//postData['totWeight'] = $('input[name=totWeight]').val();
		//postData['totWeight'] = $('input[name=subProdDivWeight]').val();	// 밀다원 분할중량총합계 = 부속제품 분할 중량
		postData['docProdName'] = $('input[name=docProdName]').val();	// 밀다원 사용x
		//postData['loss'] = $('input[name=loss]').val();			// 밀다원 사용x
		postData['compWeightUnit'] = $('select[name=compWeightUnit]').val();
		postData['compWeightText'] = $('input[name=compWeightText]').val();
		postData['regNum'] = $('input[name=regNum]').val();
		postData['regGubun'] = $('select[name=regGubun]').val();
		//postData['adminWeight'] = ''
		postData['distPeriDoc'] = $('input[name=distPeriDoc]').val();
		postData['dispWeight'] = $('input[name=dispWeight]').val();
		postData['dispWeightUnit'] = $('select[name=dispWeightUnit]').val();
		postData['dispWeightText'] = $('input[name=dispWeightText]').val();
		postData['distPeriSite'] = $('input[name=distPeriSite]').val();
		//postData['prodStandard']
		postData['ingredient'] = $('input[name=ingredient]').val();
		postData['keepConditionCode'] = $('select[name=keepConditionCode]').val();
		postData['keepCondition'] = $('input[name=keepCondition]').val();
		postData['packUnit'] = $('input[name=packUnit]').val();
		postData['childHarm'] = $('input[name=childHarm]').val();
		postData['note'] = $('input[name=note]').val();
		postData['menuProcess'] = $('textarea[name=menuProcess]').val();
		postData['standard'] = $('textarea[name=standard]').val();
		postData['stlal'] = $('input[name=stlal]').val();
		postData['isAutoDisp'] = $('input[name=isAutoDisp]').val();
		postData['adminWeightFrom'] =  $('input[name=adminWeightFrom]').val();
		postData['adminWeightUnitFrom'] = $('select[name=adminWeightUnitFrom]').val();
		postData['adminWeightTo'] = $('input[name=adminWeightTo]').val();
		postData['adminWeightUnitTo'] = $('select[name=adminWeightUnitTo]').val();
		postData['lineProcessType'] = $('select[name=lineProcessType]').val();
		postData['usage'] = $('input[name=usage]').val();
		postData['packMaterial'] = $('input[name=packMaterial]').val();
		
		
		$('div[name=subProdDiv]').toArray().forEach(function(subProd, subProdNdx){
			// 부속제품 대표정보
			subProdHeadTbody = $(subProd).children('div:first').children('table').children('tbody');
			
			postData['sub['+subProdNdx+'].subProdName'] = $('input[name=subProdName]')[subProdNdx].value
			postData['sub['+subProdNdx+'].divWeight'] = subProdHeadTbody.children('tr').children('td').children('input[name=subProdDivWeight]').val();
			postData['sub['+subProdNdx+'].divWeightTxt'] = subProdHeadTbody.children('tr').children('td').children('input[name=subProdDivWeightTxt]').val();
			postData['sub['+subProdNdx+'].unitWeight'] = subProdHeadTbody.children('tr').children('td').children('input[name=subProdDivUnitWeight]').val();
			postData['sub['+subProdNdx+'].unitVolume'] = subProdHeadTbody.children('tr').children('td').children('input[name=subProdDivUnitVolume]').val();
			postData['sub['+subProdNdx+'].stdAmount'] = subProdHeadTbody.children('tr').children('td').children('input[name=subProdStdAmount]').val();
			
			// 부속제품 원료부분
			var mixDiv = $(subProd).children('div:last').children('div:nth-child(2)').children('div.nomal_mix');
			var contDiv = $(subProd).children('div:last').children('div:nth-child(4)').children('div.nomal_mix');
			
			test = subProd
			
			// 배합(table)
			mixDiv.toArray().forEach(function(mix, mixNdx){
				var path = 'sub['+subProdNdx+'].mix['+mixNdx+'].';
				
				mixHead = $(mix).children('div');
				mixBody = $(mix).children('table');
				
				postData[path+'baseType'] = mixHead.children('input[name=baseType]').val();
				postData[path+'baseName'] = mixHead.children('span.title').children('input[name=baseName]').val();
				
				mixBody.children('tbody').children('tr').toArray().forEach(function(item, itemNdx){
					var propPath = 'sub['+subProdNdx+'].mix['+mixNdx+'].item['+itemNdx+'].';
					setPostItem(postData, propPath, item, itemNdx);
				})
				var baseBakerySum = mixBody.children('tfoot').children('tr').children('td').children('input[name=bomRateTotal]').val();
				var baseBomRateSum = mixBody.children('tfoot').children('tr').children('td').children('input[name=bomAmountTotal]').val();
				
				postData[path+'baseBakerySum'] = baseBakerySum;
				postData[path+'baseBomRateSum'] = baseBomRateSum;
			})
			
			//내용물(table)
			contDiv.toArray().forEach(function(cont, contNdx){
				var contPath = 'sub['+subProdNdx+'].cont['+contNdx+'].';
				
				contHead = $(cont).children('div');
				contBody = $(cont).children('table');
				
				postData[contPath+'baseType'] = contHead.children('input[name=baseType]').val();
				postData[contPath+'baseName'] = contHead.children('span.title').children('input[name=baseName]').val();
				postData[contPath+'divWeight'] = contHead.children('span.title').children('input[name=divWeight]').val();
				postData[contPath+'divWeightTxt'] = contHead.children('span.title').children('input[name=divWeightTxt]').val();
				
				contBody.children('tbody').children('tr').toArray().forEach(function(item, itemNdx){
					var propPath = 'sub['+subProdNdx+'].cont['+contNdx+'].item['+itemNdx+'].';
					setPostItem(postData, propPath, item, itemNdx)
				})
			})
		});
		
		// 표시사항 배합비
		$('tbody[name=dispTbody]').children('tr').toArray().forEach(function(disp, dispNdx){
			var dispPath = 'disp['+dispNdx+'].'
			//postData[dispPath+'itemName'] = $(disp).children('td').children('input[name=itemCode]');
			postData[dispPath+'matName'] = $(disp).children('td').children('input[name=matName]').val();
			postData[dispPath+'excRate'] = $(disp).children('td').children('input[name=excRate]').val();
			postData[dispPath+'incRate'] = $(disp).children('td').children('input[name=incRate]').val();
			
			
		})
		
		// 재료
		$('tbody[name=packageTbody]').children('tr').toArray().forEach(function(pkg, pkgNdx){
			//var pkgPath = 'sub['+subProdNdx+'].pkg['+pkgNdx+'].';
			var pkgPath = 'pkg['+pkgNdx+'].';
			setPostItem(postData, pkgPath, pkg, pkgNdx)
		})
		
		// 생산소모품
		$('tbody[name=consumeTbody]').children('tr').toArray().forEach(function(cons, consNdx){
			var consPath = 'cons['+consNdx+'].'
			setPostItem(postData, consPath, cons, consNdx)
		});
		
		// 제품규격
		postData['specMD.moisture'] = $('tbody[name=specMDTbody] input[name=moisture]').val();
		postData['specMD.moistureUnit'] = $('tbody[name=specMDTbody] select[name=moistureUnit]').val();
		postData['specMD.ashFrom'] = $('tbody[name=specMDTbody] input[name=ashFrom]').val();
		postData['specMD.ashTo'] = $('tbody[name=specMDTbody] input[name=ashTo]').val();
		postData['specMD.protein'] = $('tbody[name=specMDTbody] input[name=protein]').val();
		postData['specMD.proteinErr'] = $('tbody[name=specMDTbody] input[name=proteinErr]').val();
		postData['specMD.waterAbsFrom'] = $('tbody[name=specMDTbody] input[name=waterAbsFrom]').val();
		postData['specMD.waterAbsTo'] = $('tbody[name=specMDTbody] input[name=waterAbsTo]').val();
		postData['specMD.stabilityFrom'] = $('tbody[name=specMDTbody] input[name=stabilityFrom]').val();
		postData['specMD.stabilityTo'] = $('tbody[name=specMDTbody] input[name=stabilityTo]').val();
		postData['specMD.devTime'] = $('tbody[name=specMDTbody] input[name=devTime]').val();
		postData['specMD.devTimeUnit'] = $('tbody[name=specMDTbody] select[name=devTimeUnit]').val();
		postData['specMD.plFrom'] = $('tbody[name=specMDTbody] input[name=plFrom]').val();
		postData['specMD.plTo'] = $('tbody[name=specMDTbody] input[name=plTo]').val();
		postData['specMD.maxVisc'] = $('tbody[name=specMDTbody] input[name=maxVisc]').val();
		postData['specMD.maxViscUnit'] = $('tbody[name=specMDTbody] select[name=maxViscUnit]').val();
		postData['specMD.fnFrom'] = $('tbody[name=specMDTbody] input[name=fnFrom]').val();
		postData['specMD.fnTo'] = $('tbody[name=specMDTbody] input[name=fnTo]').val();
		postData['specMD.color'] = $('tbody[name=specMDTbody] input[name=color]').val();
		postData['specMD.colorUnit'] = $('tbody[name=specMDTbody] select[name=colorUnit]').val();
		postData['specMD.wetGlutenFrom'] = $('tbody[name=specMDTbody] input[name=wetGlutenFrom]').val();
		postData['specMD.wetGlutenTo'] = $('tbody[name=specMDTbody] input[name=wetGlutenTo]').val();
		postData['specMD.visc'] = $('tbody[name=specMDTbody] input[name=visc]').val();
		postData['specMD.viscUnit'] = $('tbody[name=specMDTbody] select[name=viscUnit]').val();
		postData['specMD.particleSize'] = $('tbody[name=specMDTbody] input[name=particleSize]').val();
		
		return postData;
	}
	
	function setPostItem(postData, propPath, item, itemNdx){
		postData[propPath+'itemImNo'] = $(item).children('td').children('input[name=itemImNo]').val();
		postData[propPath+'itemCode'] = $(item).children('td').children('input[name=itemSapCode]').val();
		postData[propPath+'itemName'] = $(item).children('td').children('input[name=itemName]').val();
		postData[propPath+'bomRate'] = $(item).children('td').children('input[name=itemBomRate]').val();
		postData[propPath+'bomAmount'] = $(item).children('td').children('input[name=itemBomAmount]').val();
		postData[propPath+'unit'] = $(item).children('td').children('input[name=itemUnit]').val();
		postData[propPath+'fomulaType'] = $(item).children('td').children('input[name=itemFomulaType]').val();
		postData[propPath+'orgUnit'] = '';
		postData[propPath+'weight'] = $(item).children('td').children('input[name=itemWeight]').val();
		postData[propPath+'posnr'] = $(item).children('td').children('input[name=itemPosnr]').val();
		postData[propPath+'scrap'] = $(item).children('td').children('input[name=itemScrap]').val();
		postData[propPath+'storageCode'] = $(item).children('td').children('div').children('select[name=itemStorageCode]').val();
		postData[propPath+'storageName'] = '';
		postData[propPath+'coo'] = $(item).children('td').children('div').children('select[name=itemOrigin]').val();
		postData[propPath+'cooName'] = $(item).children('td').children('div').children('select[name=itemOrigin]').siblings('label').text();
		
		return postData;
	}
	
	function changeAutoDisp(isAuto){
		$('input[name=isAutoDisp]').val(isAuto);
		if(isAuto == 1){
			$('input[name=isAutoDisp]').prev().children('li:first').attr('class', '');
			$('input[name=isAutoDisp]').prev().children('li:last').attr('class', 'select');
			
			setDisp();
			$('input[name=isAutoDisp]').parent().parent().next().children().css('display', 'block')
		} else {
			$('input[name=isAutoDisp]').prev().children('li:first').attr('class', 'select');
			$('input[name=isAutoDisp]').prev().children('li:last').attr('class', '');
			
			$('input[name=isAutoDisp]').parent().parent().next().children().css('display', 'none')
		}
	}
	
	function setTotalDivAmount(){
		$('input[name=divWeight]')
		$('input[name=totWeight]').val();
	}
	
	function setAllPosnr(){
		$('input[name=itemPosnr]').toArray().forEach(function(posnr, i){
			$(posnr).val(lpad(((i+1)*10), 4, "0"));
		})
	}
	
	function lpad(str, padLen, padStr) {
	    if (padStr.length > padLen) {
	        //console.log("오류 : 채우고자 하는 문자열이 요청 길이보다 큽니다");
	        return str;
	    }
	    str += ""; // 문자로
	    padStr += ""; // 문자로
	    while (str.length < padLen)
	        str = padStr + str;
	    str = str.length >= padLen ? str.substring(0, padLen) : str;
	    return str;
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
	
	function copyBakery(element){
		var amountTotal = 0;
		
		var tBody = $(element).parent().parent().parent().next();
		tBody.children('tr').toArray().forEach(function(tr, i){
			var bakery = $(tr).children('td').children('input[name=itemBomRate]').val();
			$(tr).children('td').children('input[name=itemWeight]').val(bakery);
			
			amountTotal += Number(bakery);
		});
		
		calcTotalWeight();
	}
	
	function copyBakeryAll(){
		if(confirm('베이커리의 입력 값을 중량에 복사합니다. 기존 입력 하신 중량값은 베이커리 값으로 변경됩니다. 계속 하시겠습니까?'))
		$('a[name=copyBakery]').toArray().forEach(function(copyBakery){
			$(copyBakery).click()
		})
	}
	
	function materialSearch(){
		$.ajax({
			url: '/design/getMaterialList',
			type: 'get',
			dataType: 'json',
			data: {
				searchValue: $('#sapCode').val()
			},
			success: function(data){
				data.pagenatedList.forEach(function(item){
					var element = '';
					element += '<tr>';
					element += '<td>'+'<button type="button" class="btn_table_nomal">선택</button>'+'</td>';
					element += '<td>'+item.itemSAPCode+'</td>';
					element += '<td>'+item.itemName+'</td>';
					element += '<td>'+item.plant+'</td>';
					element += '<td>'+item.itemUnit+'</td>';
					element += '<td>'+item.itemPrice.toFixed(3)+'</td>';
					element += '</tr>';
					$('#materialPopupBody').append(element);
				})
			},
			error: function(a,b,c){
				//console.log(a,b,c)
				alert('자재검색 실패[2]')
			}
		})
	}
	
	function clearForm(){
		// 기준정보
		$('textarea[name=memo]').val('');
		$('input[name=calcType][value=10]').click()
		//$('#select_lineCode').val(data.lineCode).trigger('change')
		$('input[name=stdAmount]').val('');
		$('input[name=stlal]').val('');
		$('input[name=mixWeight]').val('');
		$('input[name=bagAmout]').val('');
		$('input[name=bomRate]').val('');
		$('input[name=numBong]').val('');
		$('input[name=numBox]').val('');
		$('input[name=totWeight]').val('');
		$('input[name=loss]').val('');
		$('input[name=docProdName]').val('');
		$('input[name=lineProcessType]').val('');
		
		//관련정보
		$('input[name=compWeight]').val('');
		$('input[name=adminWeightFrom]').val('');
		$('input[name=adminWeightTo]').val('');
		$('input[name=adminWeightFromUnit]').val('');
		$('input[name=adminWeightToUnit]').val('');
		$('input[name=dispWeight]').val('');
		$('input[name=distPeriSite]').val('');
		$('input[name=manufacturingNo]').val('');
		$('input[name=distPeriDoc]').val('');
		$('input[name=ingredient]').val('');
		$('input[name=ingredient]').val('');
		//$('#keepConditionCode').val(data.keepConditionCode).trigger('change');
		$('input[name=keepCondition]').val('');
		$('input[name=usage]').val('');
		$('input[name=packMaterial]').val('');
		$('input[name=packUnit]').val('');
		$('input[name=childHarm][value=1]').click();
		$('input[name=size]').val('');
		
		// 제품규격
		$('input[name=size]').val('');
		$('input[name=sizeErr]').val('');
		$('input[name=feature]').val('');
		$('input[name=productWater]').val('');
		$('input[name=contentWater]').val('');
		$('input[name=contentWaterErr]').val('');
		$('input[name=productAw]').val('');
		$('input[name=contentAw]').val('');
		$('input[name=contentAwErr]').val('');
		$('input[name=productPh]').val('');
		$('input[name=contentPh]').val('');
		$('input[name=contentPhErr]').val('');
		$('input[name=productBrightness]').val('');
		$('input[name=contentSalinity]').val('');
		$('input[name=contentSalinityErr]').val('');
		$('input[name=productTone]').val('');
		$('input[name=contentBrix]').val('');
		$('input[name=contentBrixErr]').val('');
		$('input[name=productHardness]').val('');
		$('input[name=contentTone]').val('');
		$('input[name=contentToneErr]').val('');
		$('input[name=noodlesWater]').val('');
		$('input[name=noodlesPh]').val('');
		$('input[name=noodlesAcidity]').val('');
		$('input[name=deoxidizer]').val('');
		$('input[name=nitrogenous]').val('');
		
		// 제조방법, 제조규격
		$('textarea[name=menuProcess]').val('');
		$('textarea[name=standard]').val('');
		
		// 부속제품 모두 제거 및 1개 생성 (배합, 내용물이 모두 지워짐)
		$('div[name=subProdDiv]').toArray().forEach(function(element){$(element).remove()})
		$('a[id^=subProdAddBtn]').toArray().forEach(function(element){$(element).remove()})
		$('div.tab03').children('ul').children('a:last').children('li').click();
		
		// 표시사항배합비
		$('#dispHeaderDiv').next().children('tbody').empty();
		$('#dispHeaderDiv').next().children('tfoot').children('tr').children('td:nth-child(3)').text('');
		$('#dispHeaderDiv').next().children('tfoot').children('tr').children('td:nth-child(4)').text('');
		
		// 재료
		$('#packageHeaderDiv').next().children('tbody').empty();
		
		// 생산소모품
		$('#consumeHeaderDiv').next().children('tbody').empty();
	}
	
	function getImportData(){
		var docType = $('input[name=docImportType]:checked').val();
		
		if(docType == 'design'){
			var pNo = $('#select_designDoc').val();
			var pdNo = $('#select_designDocDetail').val();
			
			getDesignDocData(pNo, pdNo)
			
			closeDialog('dialog_import');
		}
		
		if(docType == 'dev'){
			var dNo = $('#select_mfgDoc').val()
			var docNo = $('#select_devDoc').val()
			var docVersion = $('#select_docVersion').val()
			
			getMfgDocData(dNo, docNo, docVersion);
			
			closeDialog('dialog_import');
		}
	}
	
	function getDesignDocData(pNo, pdNo){
		$.ajax({
			url: '/design/getDesignDocData',
			type: 'POST',
			dataType: 'json',
			data: {
				pNo: pNo,
				pdNo: pdNo
			},
			success:function(data){
				if(data){
					clearForm()
					var designDocDetail = data;
					
					changeAutoDisp(0);
					$('input[name=mixWeight]').val(designDocDetail.sumMixWeight);
					$('input[name=bagAmout]').val(designDocDetail.volume);
					
					designDocDetail.sub.forEach(function(sub, subIndex){
						if(subIndex > 0)
							addSubProduct($('a[id^=subProdAddBtn]:last').next().children('li')[0]);
						
						var subProdDivWeight = 0;
						sub.subMix.forEach(function(mix, mixIndex){
							subProdDivWeight += Number(mix.weight);
						})
						sub.subContent.forEach(function(sub, mixIndex){
							subProdDivWeight += Number(sub.weight);
						})
						
						$('input[name=subProdName]:last').val(sub.subProdName)
						$('div[name=subProdDiv]:last input[name=subProdDivWeight]').val(subProdDivWeight)
						$('div[name=subProdDiv]:last input[name=subProdDivWeightTxt]').val(sub.divWeightTxt)
						$('div[name=subProdDiv]:last input[name=subProdStdAmount]').val(sub.stdAmount)
						
						$('div[name=subProdDiv]:last').children('div:last').children('div:nth-child(2)').children('div:first').remove();
						sub.subMix.forEach(function(mix, mixIndex){
							addTable($('div[name=addMixDiv]:last')[0], 'mix');
							
							var mixDiv = $('div[name=subProdDiv]:last').children('div:last').children('div:nth-child(2)');
							var mixHeader = mixDiv.children('div.nomal_mix:last').children('div');
							var mixBody = mixDiv.children('div.nomal_mix:last').children('table').children('tbody');
							
							mixHeader.children('span').children('input[name=baseName]').val(mix.name);
							
							mixBody.empty();
							mix.subMixItem.forEach(function(item, itemIndex){
								mixHeader.children('span').children('button.btn_add_tr').click();
								mixBody.children('tr:last').children('td').children('input[name=itemSapCode]').val(item.itemSapCode);
								mixBody.children('tr:last').children('td').children('input[name=itemName]').val(item.itemName);
								//mixBody.children('tr:last').children('td').children('input[name=itemBomRate]').val('');
								mixBody.children('tr:last').children('td').children('input[name=itemBomAmount]').val(item.mixingRatio);
								mixBody.children('tr:last').children('td').children('input[name=itemWeight]').val(0);
								//mixBody.children('tr:last').children('td').children('select[name=]').val(item.unit);
								
								mixBody.children('tr:last').children('td').children('input[name=itemBomAmount]').keyup();
							})
						});
						
						$('div[name=subProdDiv]:last').children('div:last').children('div:nth-child(4)').children('div:first').remove();
						sub.subContent.forEach(function(cont, contIndex){
							addTable($('div[name=addContDiv]:last')[0], 'content');
							
							var contDiv = $('div[name=subProdDiv]:last').children('div:last').children('div:nth-child(4)');
							var contHeader = contDiv.children('div.nomal_mix:last').children('div');
							var contBody = contDiv.children('div.nomal_mix:last').children('table').children('tbody');
							
							contHeader.children('span').children('input[name=baseName]').val(cont.name);
							contHeader.children('span').children('input[name=divWeight]').val(cont.weight);
							
							contBody.empty();
							cont.subContentItem.forEach(function(item, itemIndex){
								contHeader.children('span').children('button.btn_add_tr').click();
								contBody.children('tr:last').children('td').children('input[name=itemSapCode]').val(item.itemSapCode);
								contBody.children('tr:last').children('td').children('input[name=itemName]').val(item.itemName);
								//contBody.children('tr:last').children('td').children('input[name=itemBomRate]').val('');
								contBody.children('tr:last').children('td').children('input[name=itemBomAmount]').val(item.mixingRatio);
								contBody.children('tr:last').children('td').children('input[name=itemWeight]').val(0);
								//contBody.children('tr:last').children('td').children('select[name=]').val(item.unit);
								
								contBody.children('tr:last').children('td').children('input[name=itemBomAmount]').keyup();
							})
						})
					})
					
					// 재료
					var pkgHeaderDiv = $('#packageHeaderDiv');
					var pkgBody = $('tbody[name=packageTbody]')
					pkgBody.empty();
					designDocDetail.pkg.forEach(function(pkg, pkgIndex){
						addRow(pkgHeaderDiv.children('span').children('button.btn_add_tr')[0], 'pkg')
						
						pkgBody.children('tr:last').children('td').children('input[name=itemSapCode]').val(pkg.itemSapCode);
						pkgBody.children('tr:last').children('td').children('input[name=itemName]').val(pkg.itemName);
						//pkgBody.children('tr:last').children('td').children('input[name=itemBomRate]').val('');
						pkgBody.children('tr:last').children('td').children('input[name=itemBomAmount]').val(pkg.mixingRatio);
						//pkgBody.children('tr:last').children('td').children('select[name=]').val(pkg.unit);
					})
				}
			}, error: function(a,b,c){
				//console.log(a,b,c)
				alert('제품개발문서 불러오기 실패[2]')
			}
		});
	}
	
	function getMfgDocData(dNo, docNo, docVersion){
		$.ajax({
			url: '/dev/getMfgData',
			type: 'post',
			dataType: 'json',
			data: {
				dNo: dNo, 
				docNo: docNo, 
				docVersion: docVersion
			},
			success:function(data){
				if(data){
					clearForm()
					var mgfProcDoc = data;
					
					changeAutoDisp(mgfProcDoc.isAutoDisp);
					
					// 기준정보
					$('textarea[name=memo]').val(mgfProcDoc.memo);
					$('input[name=calcType][value='+mgfProcDoc.calcType+']').click()
					$('#select_lineCode').val(mgfProcDoc.lineCode).trigger('change')
					$('input[name=stdAmount]').val(mgfProcDoc.stdAmount);
					$('input[name=stlal]').val(mgfProcDoc.stlal);
					$('input[name=mixWeight]').val(mgfProcDoc.mixWeight);
					$('input[name=bagAmout]').val(mgfProcDoc.bagAmout);
					$('input[name=bomRate]').val(mgfProcDoc.bomRate);
					$('input[name=numBong]').val(mgfProcDoc.numBong);
					$('input[name=numBox]').val(mgfProcDoc.numBox);
					$('input[name=totWeight]').val(mgfProcDoc.totWeight);
					$('input[name=loss]').val(mgfProcDoc.loss);
					$('input[name=docProdName]').val(mgfProcDoc.docProdName);
					$('input[name=lineProcessType]').val(mgfProcDoc.lineProcessType);
					
					//관련정보
					//$('input[name=prodType]').val(mgfProcDoc.prodType);
					$('input[name=compWeight]').val(mgfProcDoc.compWeight);
					$('input[name=adminWeightFrom]').val(mgfProcDoc.adminWeightFrom);
					$('input[name=adminWeightTo]').val(mgfProcDoc.adminWeightTo);
					$('input[name=adminWeightFromUnit]').val(mgfProcDoc.adminWeightFromUnit);
					$('input[name=adminWeightToUnit]').val(mgfProcDoc.adminWeightToUnit);
					$('input[name=dispWeight]').val(mgfProcDoc.dispWeight);
					$('input[name=distPeriSite]').val(mgfProcDoc.distPeriSite);
					$('input[name=manufacturingNo]').val(mgfProcDoc.manufacturingNo);
					$('input[name=distPeriDoc]').val(mgfProcDoc.distPeriDoc);
					$('input[name=ingredient]').val(mgfProcDoc.ingredient);
					$('input[name=ingredient]').val(mgfProcDoc.ingredient);
					$('#keepConditionCode').val(mgfProcDoc.keepConditionCode).trigger('change');
					$('input[name=keepCondition]').val(mgfProcDoc.keepCondition);
					$('input[name=usage]').val(mgfProcDoc.usage);
					$('input[name=packMaterial]').val(mgfProcDoc.packMaterial);
					$('input[name=packUnit]').val(mgfProcDoc.packUnit);
					if(mgfProcDoc.childHarm != ''){
						$('input[name=childHarm][value='+mgfProcDoc.childHarm+']').click();
					} else {
						$('input[name=childHarm]:last').click();
					}
					$('input[name=size]').val(mgfProcDoc.size);
					
					// 제조방법, 제조규격
					$('textarea[name=menuProcess]').val(mgfProcDoc.menuProcess);
					$('textarea[name=standard]').val(mgfProcDoc.standard);
					
					// 제품규격
					$('input[name=size]').val(mgfProcDoc.spec.size);
					$('input[name=sizeErr]').val(mgfProcDoc.spec.sizeErr);
					$('input[name=feature]').val(mgfProcDoc.spec.feature);
					$('input[name=productWater]').val(mgfProcDoc.spec.productWater);
					$('input[name=contentWater]').val(mgfProcDoc.spec.contentWater);
					$('input[name=contentWaterErr]').val(mgfProcDoc.spec.contentWaterErr);
					$('input[name=productAw]').val(mgfProcDoc.spec.productAw);
					$('input[name=contentAw]').val(mgfProcDoc.spec.contentAw);
					$('input[name=contentAwErr]').val(mgfProcDoc.spec.contentAwErr);
					$('input[name=productPh]').val(mgfProcDoc.spec.productPh);
					$('input[name=contentPh]').val(mgfProcDoc.spec.contentPh);
					$('input[name=contentPhErr]').val(mgfProcDoc.spec.contentPhErr);
					$('input[name=productBrightness]').val(mgfProcDoc.spec.productBrightness);
					$('input[name=contentSalinity]').val(mgfProcDoc.spec.contentSalinity);
					$('input[name=contentSalinityErr]').val(mgfProcDoc.spec.contentSalinityErr);
					$('input[name=productTone]').val(mgfProcDoc.spec.productTone);
					$('input[name=contentBrix]').val(mgfProcDoc.spec.contentBrix);
					$('input[name=contentBrixErr]').val(mgfProcDoc.spec.contentBrixErr);
					$('input[name=productHardness]').val(mgfProcDoc.spec.productHardness);
					$('input[name=contentTone]').val(mgfProcDoc.spec.contentTone);
					$('input[name=contentToneErr]').val(mgfProcDoc.spec.contentToneErr);
					$('input[name=noodlesWater]').val(mgfProcDoc.spec.noodlesWater);
					$('input[name=noodlesPh]').val(mgfProcDoc.spec.noodlesPh);
					$('input[name=noodlesAcidity]').val(mgfProcDoc.spec.noodlesAcidity);
					$('input[name=deoxidizer]').val(mgfProcDoc.spec.deoxidizer);
					$('input[name=nitrogenous]').val(mgfProcDoc.spec.nitrogenous);
					
					// 원료
					mgfProcDoc.sub.forEach(function(sub, subIndex){
						if(subIndex > 0)
							addSubProduct($('a[id^=subProdAddBtn]:last').next().children('li')[0]);
						
						$('input[name=subProdName]:last').val(sub.subProdName)
						$('div[name=subProdDiv]:last input[name=subProdDivWeight]').val(sub.divWeight)
						$('div[name=subProdDiv]:last input[name=subProdDivWeightTxt]').val(sub.divWeightTxt)
						$('div[name=subProdDiv]:last input[name=subProdStdAmount]').val(sub.stdAmount)
						
						$('div[name=subProdDiv]:last').children('div:last').children('div:nth-child(2)').children('div:first').remove();
						sub.mix.forEach(function(mix, mixIndex){
							addTable($('div[name=addMixDiv]:last')[0], 'mix');
							
							var mixDiv = $('div[name=subProdDiv]:last').children('div:last').children('div:nth-child(2)');
							var mixHeader = mixDiv.children('div.nomal_mix:last').children('div');
							var mixBody = mixDiv.children('div.nomal_mix:last').children('table').children('tbody');
							
							mixHeader.children('span').children('input[name=baseName]').val(mix.baseName);
							
							mixBody.empty();
							mix.item.forEach(function(item, itemIndex){
								mixHeader.children('span').children('button.btn_add_tr').click();
								mixBody.children('tr:last').children('td').children('input[name=itemSapCode]').val(item.itemCode);
								mixBody.children('tr:last').children('td').children('input[name=itemName]').val(item.itemName);
								mixBody.children('tr:last').children('td').children('input[name=itemBomRate]').val(item.bomRate);
								mixBody.children('tr:last').children('td').children('input[name=itemBomAmount]').val(item.bomAmount);
								//mixBody.children('tr:last').children('td').children('select[name=]').val(item.unit);
								mixBody.children('tr:last').children('td').children('input[name=itemWeight]').val(item.weight);
								mixBody.children('tr:last').children('td').children('input[name=itemPosnr]').val(item.posnr);
								mixBody.children('tr:last').children('td').children('input[name=itemScrap]').val(item.scrap);
								//mixBody.children('tr:last').children('td').children('input[select=itemStorageCode]').val(item.storageCode);
								
								mixBody.children('tr:last').children('td').children('input[name=itemBomAmount]').keyup();
							})
						})
						
						$('div[name=subProdDiv]:last').children('div:last').children('div:nth-child(4)').children('div:first').remove();
						sub.cont.forEach(function(cont, contIndex){
							addTable($('div[name=addContDiv]:last')[0], 'content');
							
							var contDiv = $('div[name=subProdDiv]:last').children('div:last').children('div:nth-child(4)');
							var contHeader = contDiv.children('div.nomal_mix:last').children('div');
							var contBody = contDiv.children('div.nomal_mix:last').children('table').children('tbody');
							
							contHeader.children('span').children('input[name=baseName]').val(cont.baseName);
							contHeader.children('span').children('input[name=divWeight]').val(cont.divWeight);
							contHeader.children('span').children('input[name=divWeightTxt]').val(cont.divWeightTxt);
							
							contBody.empty();
							cont.item.forEach(function(item, itemIndex){
								contHeader.children('span').children('button.btn_add_tr').click();
								contBody.children('tr:last').children('td').children('input[name=itemSapCode]').val(item.itemCode);
								contBody.children('tr:last').children('td').children('input[name=itemName]').val(item.itemName);
								contBody.children('tr:last').children('td').children('input[name=itemBomRate]').val(item.bomRate);
								contBody.children('tr:last').children('td').children('input[name=itemBomAmount]').val(item.bomAmount);
								//contBody.children('tr:last').children('td').children('select[name=]').val(item.unit);
								contBody.children('tr:last').children('td').children('input[name=itemWeight]').val(item.weight);
								contBody.children('tr:last').children('td').children('input[name=itemPosnr]').val(item.posnr);
								contBody.children('tr:last').children('td').children('input[name=itemScrap]').val(item.scrap);
								//contBody.children('tr:last').children('td').children('input[select=itemStorageCode]').val(item.storageCode);
								
								contBody.children('tr:last').children('td').children('input[name=itemBomAmount]').keyup();
							})
						})
					})
					
					// 표시사항바햅비
					var dispHeaderDiv = $('#dispHeaderDiv');
					var dispBody = $('tbody[name=dispTbody]')
					var excRateTotal = 0;
					var incRateTotal = 0;
					dispBody.empty();
					mgfProcDoc.disp.forEach(function(disp, dispIndex){
						addRow(dispHeaderDiv.children('span').children('button.btn_add_tr')[0], 'disp')
						
						dispBody.children('tr:last').children('td').children('input[name=itemSapCode]').val(disp.itemCode)
						dispBody.children('tr:last').children('td').children('input[name=matName]').val(disp.matName);
						dispBody.children('tr:last').children('td').children('input[name=excRate]').val(disp.excRate);
						dispBody.children('tr:last').children('td').children('input[name=incRate]').val(disp.incRate);
						
						excRateTotal += Number(disp.excRate);
						incRateTotal += Number(disp.incRate);
					});
					dispBody.next().children('tr').children('td:nth-child(3)').text(excRateTotal.toFixed(2));
					dispBody.next().children('tr').children('td:nth-child(4)').text(incRateTotal.toFixed(2));
					
					// 재료
					var pkgHeaderDiv = $('#packageHeaderDiv');
					var pkgBody = $('tbody[name=packageTbody]')
					pkgBody.empty();
					mgfProcDoc.pkg.forEach(function(pkg, pkgIndex){
						addRow(pkgHeaderDiv.children('span').children('button.btn_add_tr')[0], 'pkg')
						
						pkgBody.children('tr:last').children('td').children('input[name=itemSapCode]').val(pkg.itemCode);
						pkgBody.children('tr:last').children('td').children('input[name=itemName]').val(pkg.itemName);
						pkgBody.children('tr:last').children('td').children('input[name=itemBomRate]').val(pkg.bomRate);
						pkgBody.children('tr:last').children('td').children('input[name=itemBomAmount]').val(pkg.bomAmount);
						//pkgBody.children('tr:last').children('td').children('select[name=]').val(pkg.unit);
						pkgBody.children('tr:last').children('td').children('input[name=itemWeight]').val(pkg.weight);
						pkgBody.children('tr:last').children('td').children('input[name=itemPosnr]').val(pkg.posnr);
						pkgBody.children('tr:last').children('td').children('input[name=itemScrap]').val(pkg.scrap);
						//contBody.children('tr:last').children('td').children('input[select=itemStorageCode]').val(pkg.storageCode);
					})
					
					// 생산소모품
					var consHeaderDiv = $('#consumeHeaderDiv');
					var consBody = $('tbody[name=consumeTbody]');
					consBody.empty();
					mgfProcDoc.cons.forEach(function(cons, consIndex){
						addRow(consHeaderDiv.children('span').children('button.btn_add_tr')[0], 'consume');
						
						consBody.children('tr:last').children('td').children('input[name=itemSapCode]').val(cons.itemCode);
						consBody.children('tr:last').children('td').children('input[name=itemName]').val(cons.itemName);
						consBody.children('tr:last').children('td').children('input[name=itemBomRate]').val(cons.bomRate);
						consBody.children('tr:last').children('td').children('input[name=itemBomAmount]').val(cons.bomAmount);
						//consBody.children('tr:last').children('td').children('select[name=]').val(cons.unit);
						consBody.children('tr:last').children('td').children('input[name="itemBomUnit"]').val(cons.unit);
						consBody.children('tr:last').children('td').children('input[name=itemPosnr]').val(cons.posnr);
						consBody.children('tr:last').children('td').children('input[name=itemScrap]').val(cons.scrap);
						//consBody.children('tr:last').children('td').children('input[select=itemStorageCode]').val(cons.storageCode);
					})
				}
			},
			error: function(a,b,c){
				alert('제조공정서 불러오기 실패[2]')
			}
		})
	}
	
	function loadCodeList( groupCode, objectId ) {
		var URL = "/common/codeListAjax";
		$.ajax({
			type:"POST",
			url:URL,
			data:{
				"groupCode":groupCode
			},
			dataType:"json",
			async:false,
			success:function(data) {
				var list = data.RESULT;
				$("#"+objectId).removeOption(/./);
				$("#"+objectId).addOption("", "전체", false);
				$("#label_"+objectId).html("전체");
				$.each(list, function( index, value ){ //배열-> index, value
					$("#"+objectId).addOption(value.itemCode, value.itemName, false);
				});
				
			},
			error:function(request, status, errorThrown){
				$("#"+objectId).removeOption(/./);
				alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
			}			
		});
	}
	
	
	function changeCompWeight(){
		clearNoNum($('input[name=compWeight]')[0]);
		
		var compWeight = $('input[name=compWeight]').val();
		var compWeightUnit = $('select[name=compWeightUnit]').val();
		
		if(compWeightUnit == 'Kg' || compWeightUnit == 'L'){
			compWeight = compWeight*1000;
		}
		
		if(compWeight <= 50){
			// 허용오차 9%;
			caclCompWeightError('multi', compWeight, compWeightUnit, 0.09);
		} else if(compWeight <= 100){
			// 허용오차 4.5g;
			caclCompWeightError('add', compWeight, compWeightUnit,  4.5);
		} else if(compWeight <= 200){
			// 허용오차 4.5%;
			caclCompWeightError('multi', compWeight, compWeightUnit, 0.045);
		} else if(compWeight <= 300){
			// 허용오차 9g;
			caclCompWeightError('add', compWeight, compWeightUnit,  9);
		} else if(compWeight <= 500){
			// 허용오차 3%;
			caclCompWeightError('multi', compWeight, compWeightUnit, 0.03);
		} else if(compWeight <= 1000){
			// 허용오차 15g;
			caclCompWeightError('add', compWeight, compWeightUnit,  15);
		} else if(compWeight <= 10000){
			// 허용오차 1.5%;
			caclCompWeightError('multi', compWeight, compWeightUnit, 0.015);
		} else if(compWeight <= 15000){
			// 허용오차 150g;
			caclCompWeightError('add', compWeight, compWeightUnit,  150);
		} else {
			// 허용오차 1%;
			caclCompWeightError('multi', compWeight, compWeightUnit, 0.01);
		}
	}
	
	function caclCompWeightError(type, compWeight, compWeightUnit, error){
		if(type != 'add' && type != 'multi'){
			return alert('Wrong Arithmetic Type');
		}
		if(type == 'add' ){
			var adminWeightFrom = Number(compWeight) - error;
			var adminWeightTo = Number(compWeight) + error;
			
			if(compWeightUnit == 'Kg' || compWeightUnit == 'L'){
				adminWeightFrom = Number(adminWeightFrom)/1000;
				adminWeightTo = Number(adminWeightTo)/1000;
			}
			
			$('input[name=adminWeightFrom]').val(adminWeightFrom);
			$('input[name=adminWeightTo]').val(adminWeightTo);
			
			$('input[name=adminWeightUnitFrom]').val(compWeightUnit);
			$('input[name=adminWeightUnitTo]').val(compWeightUnit);
		} 
		if(type == 'multi'){
			var adminWeightFrom = Number(compWeight) - Number(compWeight) * error;
			var adminWeightTo = Number(compWeight) + Number(compWeight) * error;
			
			if(compWeightUnit == 'Kg' || compWeightUnit == 'L'){
				adminWeightFrom = adminWeightFrom/1000;
				adminWeightTo = adminWeightTo/1000;
			}
			
			$('input[name=adminWeightFrom]').val(adminWeightFrom);
			$('input[name=adminWeightTo]').val(adminWeightTo);
			
			$('input[name=adminWeightUnitFrom]').val(compWeightUnit);
			$('input[name=adminWeightUnitTo]').val(compWeightUnit);
		}
	}
	
	function loadCompany(selectBoxId) {
		var URL = "../common/companyListAjax";
		$.ajax({
			type:"POST",
			url:URL,
			data:{
			},
			dataType:"json",
			async:false,
			success:function(data) {
				var list = data.RESULT;
				$("#"+selectBoxId).removeOption(/./);
				$("#"+selectBoxId).addOption("", "전체", false);
				$("#label_"+selectBoxId).html("전체");
				$.each(list, function( index, value ){ //배열-> index, value
					$("#"+selectBoxId).addOption(value.companyCode, value.companyName, false);
				});
			},
			error:function(request, status, errorThrown){
					alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
			}			
		});
	}
	
	function companyChange(e, selectBoxId) {
		var companyCode = e.target.value;
		var URL = "../common/plantListAjax";
		
		$.ajax({
			type:"POST",
			url:URL,
			data:{
				"companyCode" : companyCode
			},
			dataType:"json",
			async:false,
			success:function(data) {
				var list = data.RESULT;
				$("#"+selectBoxId).removeOption(/./);
				$("#"+selectBoxId).addOption("", "전체", false);
				$("#label_"+selectBoxId).html("전체");
				$.each(list, function( index, value ){ //배열-> index, value
					$("#"+selectBoxId).addOption(value.plantCode, value.plantName, false);
				});
				$("#companyNo_li").hide();
				$("#companyNo_span").html("");
				$("#companyNo").val("");
			},
			error:function(request, status, errorThrown){
					alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
			}			
		});
	}
	
	function plantChange(e, companySelectBoxId, selectBoxId){
		var companyCode = $('#'+companySelectBoxId).val();
		var plantCode = e.target.value;
		var URL = "../common/plantLineListAjax";
		
		if( companyCode != '' && plantCode != '') {	
			$.ajax({
				type:"POST",
				url:URL,
				data:{
					"companyCode" : companyCode,
					"plantCode" : plantCode
				},
				dataType:"json",
				async:false,
				success:function(data) {
					var list = data.RESULT;
					$("#"+selectBoxId).removeOption(/./);
					$("#"+selectBoxId).addOption("", "전체", false);
					$("#label_"+selectBoxId).html("전체");
					$.each(list, function( index, value ){ //배열-> index, value
						$("#"+selectBoxId).addOption(value.lineCode, value.lineName+'('+value.lineCode+')', false);
					});
				},
				error:function(request, status, errorThrown){
						alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
				}			
			});	
		}
	}
	
	function searchDesignDoc(){
		var companyCode = $('#dialog_companyCode').val();
		var plantCode = $('#dialog_plantCode').val();
		var productName = $('#dialog_design_productName').val();
		
		$.ajax({
			url: '/design/getDesignDocSummaryList',
			data: {
				companyCode: companyCode, 
				plantCode: plantCode,
				productName: productName
			},
			type: 'post',
			success: function(data){
				if(data){
					var designDocList = JSON.parse(data);
					
					$('#select_designDoc').removeOption(/./);
					$('#select_designDoc').addOption('', '제품설계서 선택', true);
					$('#label_select_designDoc').text('제품설계서  선택');
					
					$('#select_designDocDetail').removeOption(/./);
					$('#select_designDocDetail').addOption('', '설계서  선택', true);
					$('#label_select_designDocDetail').text('설계서 선택');
					
					designDocList.forEach(function(obj, index){
						$('#select_designDoc').addOption(obj.pNo, '['+obj.pNo+'] '+obj.productName, false);
					})
					
					$('#designDocSelectDiv').show();
				} else {
					$('#designDocSelectDiv').hide();
					return alert('제품설계서 검색 오류[1]');
				}
			}, error: function(a,b,c){
				return alert('제품설계서 검색 오류[1]');
			}
		});
	}
	
	function searchDesignDocDetailList(e){
		var pNo = e.target.value;
		
		$.ajax({
			url: '/design/getDesignDocDetailSummaryList',
			data: {
				pNo: pNo
			},
			type: 'post',
			success: function(data){
				if(data){
					var designDocDetailList = JSON.parse(data)
					
					$('#select_designDocDetail').removeOption(/./);
					$('#select_designDocDetail').addOption('', '설계서 선택', true);
					$('#label_select_designDocDetail').text('설계서 선택');
					
					designDocDetailList.forEach(function(obj, index){
						var text = '[' + obj.pdNo + '] ' + obj.userName + ' - ' + obj.regDate;
						$('#select_designDocDetail').addOption(obj.pdNo, text, false);
					});
				} else {
					return alert('설계서 조회 실패[1]')
				}
			},
			error: function(a,b,c){
				return alert('설계서 조회 실패[2]')
			}
		})
	}
	
	function loadProductType( grade, objectId ) {
		var URL = "../common/productTypeListAjax";
		var groupCode = "PRODCAT"+grade;
		var codeValue = "";
		if( grade == '2' ) {
			codeValue = $("#productType1").selectedValues()[0]+"-";
			//$("#li_productType2").hide();
			//$("#li_productType3").hide();
			$("#productType2").removeOption(/./);
			$("#productType2").addOption("", "전체", false);
			$("#label_productType2").html("전체");
			
			$("#productType3").removeOption(/./);
			$("#productType3").addOption("", "전체", false);
			$("#label_productType3").html("전체");
		} else if( grade == '3' ) {
			codeValue = $("#productType2").selectedValues()[0]+"-";
			//$("#li_productType3").hide();
			
			$("#productType3").removeOption(/./);
			$("#productType3").addOption("", "전체", false);
			$("#label_productType3").html("전체");
		}
		$.ajax({
			type:"POST",
			url:URL,
			data:{
				"groupCode":groupCode,
				"codeValue":codeValue
			},
			dataType:"json",
			async:false,
			success:function(data) {
				var list = data.RESULT;
				
				//$("#label_"+objectId).html("전체");
				$.each(list, function( index, value ){ //배열-> index, value
					$("#"+objectId).addOption(value.itemCode, value.itemName, false);
				});
				if( list.length > 0 ) {
					$("#li_"+objectId).show();
				} else {
					//$("#li_"+objectId).hide();
				}
			},
			error:function(request, status, errorThrown){
				element.removeOption(/./);
				$("#li_"+element.prop("id")).hide();
				alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
			}			
		});
	}
	
	function changeDivWeight(e){
		clearNoNum(e.target);
		
		var value = e.target.value;
		
		// 부속제품 기준수량
		$('input[name=subProdStdAmount]').val(value);
		// 분할중량 총합계
		$('input[name=totWeight]').val(value);
		// 기준수량
		$('input[name=stdAmount]').val(value);
		
	}
	
	function openMaterialPopup(element, itemType){
		var parentRowId = $(element).parent().parent('tr')[0].id;
		$('#targetID').val(parentRowId);
		openDialog('dialog_material');
		
		var matCode = $(element).prev().val()
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
		$.ajax({
			url: '/design/getMaterialList',
			type: 'post',
			dataType: 'json',
			data: {
				searchValue: $('#searchMatValue').val(),
				companyCode: $('#mfg_company_select').val(),
				itemType: $('#itemType').val(),
				showPage: $('#matLayerPage').val()
			},
			success: function(data){
				var jsonData = {};
				jsonData = data;
				$('#matLayerBody').empty();
				$('#matLayerBody').append('<input type="hidden" id="matLayerPage" value="'+data.page.showPage+'"/>');
				
				jsonData.pagenatedList.forEach(function(item){
					var row = '<tr onClick="setMaterialPopupData(\''+$('#targetID').val()+'\', \''+item.itemImNo+'\', \''+item.itemSAPCode+'\', \''+item.itemName+'\', \''+item.itemPrice+'\', \''+item.itemUnit+'\')">';
					//parentRowId, itemImNo, itemSAPCode, itemName, itemUnitPrice
					row += '<td></td>';
					//row += '<Td>'+item.companyCode+'('+item.plant+')'+'</Td>';
					row += '<Td>'+item.plantName+'</Td>';
					row += '<Td>'+item.itemSAPCode+'</Td>';
					row += '<Td class="tgnl">'+item.itemName+'</Td>';
					row += '<Td>'+item.itemPrice+'</Td>';
					row += '<Td>'+ (item.itemType == 'B' ? '원료' : ( item.itemType == 'R' ? '재료' : '' )) +'</Td>';
					//row += '<Td>'+item.regUserId+'</Td>';
					row += '<Td>'+item.regDate+'</Td>';
					row += '<Td>'+'비고'+'</Td>';
					row += '</tr>';
					$('#matLayerBody').append(row);
				})
				$('#matCount').text(jsonData.page.totalCount)
				
				var isFirst = $('#matLayerPage').val() == 1 ? true : false;
				var isLast = parseInt(jsonData.page.totalCount/10+1) == Number($('#matLayerPage').val()) ? true : false;
				
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
				alert('자재검색 실패[2]');
			},
			complete: function(){
				$('#lab_loading').hide();
			}
		})
	}
	
	function closeMatRayer(){
		$('#searchMatValue').val('')
		$('#matLayerBody').empty();
		$('#matLayerBody').append('<tr><td colspan="8">원료코드 혹은 원료코드명을 검색해주세요</td></tr>');
		$('#matCount').text(0);
		closeDialog('dialog_material')
	}
	
	function calcItemWeight(e){
		clearNoNum(e.target);
		calcTotalWeight();
	}
	
	function calcTotalWeight(){
		var total = 0;
		$('tbody[id^=mixTbody_').children('tr').each(function(i, tr){
			var sapCode = $(tr).children('td').children('input[name=itemSapCode]').val();
			if(!(sapCode.indexOf('4') == 0 || sapCode.indexOf('5') == 0)){
				var itemWeight = Number($(tr).children('td').children('input[name=itemWeight]').val())
				if(itemWeight == NaN) itemWeight = 0;
				
				total += parseFloat(itemWeight);	
			}
		})
		$('input[name=itemWeightTotal]').val(round(total,3));
		//$('input[name=subProdDivWeight]').val(total);
		//$('input[name=subProdStdAmount]').val(total);
		//$('input[name=totWeight]').val(total);
		//$('input[name=stdAmount]').val(total);
	}
	
	function calcStdAmount(e){
		$('input[name=subProdStdAmount]').val(e.target.value);
		$('input[name=stdAmount]').val(e.target.value);
		$('input[name=mixWeight]').val(e.target.value);
	}
	
	function round(n, digits) {
		if (digits >= 0) return parseFloat(Number(n).toFixed(digits)); // 소수부 반올림
		digits = Math.pow(10, digits); // 정수부 반올림
		var t = Math.round(n * digits) / digits;
		return parseFloat(t.toFixed(0));
	}
	
	function calcBomRate(e){
		clearNoNum(e.target);
		calcBomRateTotal();
		
		$(e.target).prev().val(e.target.value);
	}
	
	function calcBomRateTotal(){
		var bomRateTotal = 0;
		$('tbody[id^=mixTbody_').children('tr').each(function(i, tr){
			var sapCode = $(tr).children('td').children('input[name=itemSapCode]').val();
			if(!(sapCode.indexOf('4') == 0 || sapCode.indexOf('5') == 0)){
				var bomRate = Number($(tr).children('td').children('input[name=itemBomRate]').val())
				if(bomRate == NaN) bomRate = 0;
				
				bomRateTotal += parseFloat(bomRate);
			}
		})
		$('input[name=bomRateTotal]').val(round(bomRateTotal,3))
		$('input[name=subProdStdAmount]').val(round(bomRateTotal,3)) //기준수량
		//$('input[name=subProdDivWeight]').val(round(bomRateTotal,3)) //분할중량
	}
	
	function setSubProdDivWeight(e){
		var unitWeight = Number($(e.target).parent().children('input[name=subProdDivUnitWeight]').val());
		var volume = Number($(e.target).parent().children('input[name=subProdDivUnitVolume]').val());
		var subProdDivWeight = round((unitWeight * volume), 3);
		$(e.target).parent().children('input[name=subProdDivWeight]').val(subProdDivWeight);
		$(e.target).parent().children('input[name=subProdDivWeight]').keyup();
	}
	
	function openStorageDialog(e, dialogId){
		$('#lab_loading').show();
		
		var randomId = Math.random().toString(36).substr(2, 9);
		var companyCode = $('#mfg_company_select').val();;
		var plantCode= $('#mfg_plant_select').val();
		var targetId = 'storage_'+randomId
		
		$(e.target).attr('id', targetId);
		$('#targetStorageId').val(targetId);
		
		if(e.target.name == 'itemStorageCode'){
			$('#storageSetType').val('item')
		} else {
			$('#storageSetType').val('all')
		}
		
		if(companyCode.length <= 0){
			alert('회사를 선택해주세요');
			$('#lab_loading').hide();
			return;
		}
		if(plantCode.length <= 0){
			alert('플랜트를 선택해주세요');
			$('#lab_loading').hide();
			return;
		}
		
		$.ajax({
		    url: '/common/storageListAjax',
		    type: 'post',
		    async: false,
		    dataType: 'JSON',
		    data:{
		        companyCode: companyCode
		        , plantCode: plantCode
		    },
		    success: function(data){
		        var storageList = data.RESULT;
		        $('#dialogStorage').empty();
				$('#dialogStorage').append('<option value="" selected>선택</option>');
				$('#label_dialogStorage').text('선택');
				storageList.sort(function(a, b){return a.storageCode - b.storageCode}).forEach(function(storage){
					$('#dialogStorage').append('<option value="'+storage.storageCode+'">'+'['+storage.storageCode+']'+storage.storageName+'</option>')
				})
		    }
		})
		openDialog('dialog_storage')
	
		$('#lab_loading').hide();
	}
	
	function isExceptCode(code) {
		var exceptCodes = [ "P001", "P10001", "P10002", "P10003" ];
		
		var result = false;
		for ( var i = 0; i < exceptCodes.length; i++ ) {
			if(code == exceptCodes[i]) {
				result = true;
				break;
			}
		}
		return result
	}
	
	function setItemStorage(type){
		var storage = $('#dialogStorage').val();
		var type = $('#storageSetType').val();
		
		if(type == 'item'){
			$('#'+$('#targetStorageId').val()).val(storage);
		} else {
			$('select[name=itemStorageCode]').toArray().forEach(function(element){
				var sapCode = $(element).parent().parent().parent().children('td').children('input[name=itemSapCode]').val()
				if(sapCode == '') return;
				if(isExceptCode(sapCode)){
					$(element).children('option:first').prop('selected',true);
					$(element).change();
					$(element).attr('disabled', true);
				} else {
					$(element).children('option[value='+storage+']').prop('selected',true);
					$(element).change();
					$(element).attr('disabled', false);
				}
			})
		}
		closeDialog('dialog_storage');
	}
	
	function bindDialogEnter(e){
		if(e.keyCode == 13)
			$(e.target).next().click();
	}
	
	function checkMaterail(e, type, sapCode){
		if(e.keyCode != 13){
			return;
		}
		var element = e.target
		
		var calcType = $('input[name=calcType]:checked').val();
		
		var userSapCode = e.target.value;
		if(typeof(userSapCode) == 'string') userSapCode = userSapCode.toUpperCase();
		var rowId = $(element).parent().parent().attr('id');
		var plant = $('#mfg_plant_select').val();
		var company = $('#mfg_company_select').val();
		
		$.ajax({
			url: '/data/checkMaterial',
			type: 'post',
			dataType: 'json',
			data: {
				sapCode: userSapCode,
				plant: plant,
				type: type,
				company: company
			},
			success: function(data){
				var materailList = data;
				if(materailList.length == 1){
					//pop
					var item = materailList[0];
					$('#'+rowId+' input[name=itemSapCode]').val(item.sapCode);
					$('#'+rowId+' input[name=itemImNo]').val(item.imNo);
					$('#'+rowId+' input[name=itemName]').val(item.name);
					$('#'+rowId+' input[name=itemUnit]').val(item.unit);
					$('#'+rowId+' input[name=itemOrgUnit]').val(item.unit);
					
					if(item.name.indexOf('[임시]') >= 0){
						$('#'+rowId).css('background-color', '#ffdb8c');
					} else {
						$('#'+rowId).css('background-color', '#fff');
					}
					
					if(isExceptCode(item.sapCode)){
						$('#'+rowId + ' select[name=itemStorageCode]').attr('disabled', true);
						$('#'+rowId + ' select[name=itemStorageCode] option:first').prop('selected', true);
						$('#'+rowId + ' select[name=itemStorageCode]').change()
					} else {
						$('#'+rowId + ' select[name=itemStorageCode]').attr('disabled', false);
					}
					
					if(item.sapCode.indexOf('4') == 0|| item.sapCode.indexOf('5') == 0){
						$('#'+rowId + ' input[name=itemBomRate]').css('background-color', '#ffe8d9');
						$('#'+rowId + ' input[name=itemWeight]').css('background-color', '#ffe8d9');
					} else {
						$('#'+rowId + ' input[name=itemBomRate]').css('background-color', '#fff');
						$('#'+rowId + ' input[name=itemWeight]').css('background-color', '#fff');
					}
				} else {
					// popup
					openMaterialPopup($(element).next(), type);
				}
			},
			error: function(a,b,c){
				//console.log(a,b,c)
				alert('갱신 실패[2] - 시스템 담당자에게 문의하세요.');
			}
		})
	}
	
	function moveLeft(){
		var leftOffset = $('#subScroll')[0].scrollLeft;
		$('#subScroll')[0].scrollLeft = leftOffset-350
	}
	
	function moveRight(){
		var leftOffset = $('#subScroll')[0].scrollLeft;
		$('#subScroll')[0].scrollLeft = leftOffset+350
	}
	
	function dblSubProdNameSpan(e){
		$(e.target).parent().dblclick();
	}
	
	function changeSubProdName(e){
		$(e.target).children('span').hide();
		$(e.target).children('input').show();
		$(e.target).children('input').focus();
	}
	
	function subProdNameKeyup(e){
		$(e.target).prev().text(e.target.value);
		if(e.keyCode == 13){
			if(e.target.value.length <= 0){
				return alert('부속제품명을 입력해주세요. ');
			} else {
				$(e.target).hide();
				$(e.target).prev().show();
			}
		}
	}
	
	function goMfgDetail(){
		var docNo = '${productDevDoc.docNo}';
		var docVersion = '${productDevDoc.docVersion}';
		
		var form = document.createElement('form');
		$('body').append(form);
		form.action = '/dev/productDevDocDetail';
		form.method = 'post';
		
		appendInput(form, 'docNo', docNo);
		appendInput(form, 'docVersion', docVersion);
		
		$(form).submit();
	}
</script>



<div class="wrap_in" id="fixNextTag">
	<span class="path">
		제조공정서 수정&nbsp;&nbsp;
		<img src="/resources/images/icon_path.png" style="vertical-align: middle" />&nbsp;&nbsp;제품개발문서&nbsp;&nbsp;
		<img src="/resources/images/icon_path.png" style="vertical-align: middle" />&nbsp;&nbsp;<a href="#none">SPC 삼립연구소</a>
	</span>
	<section class="type01">
		<!-- 상세 페이지  start-->
		<h2 style="position: relative">
			<span class="title_s">Manufacturing Process Doc</span><span class="title">제조공정서 수정</span>
			<div class="top_btn_box">
				<ul>
					<li>
						<button class="btn_circle_save" onclick="updateMfgProcessDoc()">&nbsp;</button>
					</li>
				</ul>
			</div>
		</h2>
		<div class="group01 mt20">
			<!-- 복잡하니 잘따라오소-->
			<!-- 기준정보 start --------------------------------------------------------------------------------------------------------------------------------------------------------->
			<div class="title5" style="width: 80%">
				<span class="txt">01. '${productName}' 기준정보</span>
			</div>
			<!-- 
			<div class="title5" style="width: 20%; display: inline-block;">
				<button style="float: right;" class="btn_con_search" onclick="openDialog('dialog_import')"><img src="/resources/images/btn_icon_convert.png"> 불러오기</button>
			</div>
			 -->
			 
			 
			<div class="main_tbl">
				<table class="insert_proc01">
					<colgroup>
						<col width="13%" />
						<col width="20%" />
						<col width="13%" />
						<col width="20%" />
						<col width="14%" />
						<col width="20%" />
					</colgroup>
					<tbody>
						<tr>
							<th style="border-left: none;">설명</th>
							<td colspan="5"><textarea name="memo" style="width: 100%; height: 60px" class="req">${mfgProcessDoc.memo}</textarea></td>
						</tr>
						<tr>
							<th style="border-left: none;">회사</th>
							<td>
								<div class="selectbox req" style="width:100%">
									<c:forEach items="${companyList}" var="company" varStatus="status">
										<c:if test="${company.companyCode == companyCode}">
											<c:set var="selectedCompanyName" value="${company.companyName}"/>
										</c:if>
									</c:forEach>
		                        	<label for="mfg_company_select" id="label_mfg_company_select">${selectedCompanyName}</label>
		                            <select id="mfg_company_select" name="companyCode" onchange="companyChange(event, 'mfg_plant_select')">
		                            	<option value="${companyCode}" selected>${selectedCompanyName}</option>
		                            </select>
		                        </div>
							</td>
							<th>공장</th>
							<td>
								<div class="selectbox  ml5 req" style="width:100%">
		                            <c:forEach items="${plantList}" var="plant" varStatus="status">
										<c:if test="${plant.plantCode == plantCode}">
											<c:set var="selectedPlantName" value="${plant.plantName}"/>
										</c:if>
									</c:forEach>
		                            <label for="mfg_plant_select" id="label_mfg_plant_select">${selectedPlantName}</label>
		                            <select id="mfg_plant_select" name="plantCode" onchange="plantChange(event, 'mfg_company_select', 'mfg_plantline_select')">
		                            	<option value="${plantCode}" selected>${selectedPlantName}</option>
		                            </select>
		                        </div>
							</td>
							<th>생산라인</th>
							<td>
								<div class="selectbox  ml5" style="width:100%">
		                            <label for="mfg_plantline_select">--생산라인선택--</label>
		                            <select id="mfg_plantline_select" name="plantLineCode">
		                            	<option value="">--생산라인선택--</option>
		                            </select>
		                        </div>
							</td>
						</tr>
						<tr>
							<th style="border-left: none;">수식타입</th>
							<td colspan="3">
								<c:if test="${mfgProcessDoc.calcType == 10}">
									<input type="radio" name="calcType" id="radio_caclType1" value="10" checked="checked" onclick="changeCalcType(event)" disabled="disabled"/><label for="radio_caclType1"><span></span>일반제품</label>
								</c:if>
								<c:if test="${mfgProcessDoc.calcType == 20}">
									<input type="radio" name="calcType" id="radio_caclType2" value="20" checked="checked" onclick="changeCalcType(event)" disabled="disabled"/><label for="radio_caclType2"><span></span>기준수량 기준제품</label>
								</c:if>
								<c:if test="${mfgProcessDoc.calcType == 30}">
									<input type="radio" name="calcType" id="radio_caclType3" value="30" checked="checked" onclick="changeCalcType(event)" disabled="disabled"/><label for="radio_caclType3"><span></span>크림제품</label>
								</c:if>
								<c:if test="${mfgProcessDoc.calcType == 3}">
									<input type="radio" name="calcType" id="radio_caclType3" value="3" checked="checked" onchange="changeCalcType(event)"/><label for="radio_caclType3"><span></span>일반제품 (밀다원 3번코드)</label>
								</c:if>
								<c:if test="${mfgProcessDoc.calcType == 7}">
									<input type="radio" name="calcType" id="radio_caclType7" value="7" checked="checked" onchange="changeCalcType(event)"/><label for="radio_caclType3"><span></span>일반제품 (밀다원 7번코드)</label>
								</c:if>
							</td>
							<th>BOM수율</th>
							<td><input type="text" id="productBomRatio" name="bomRate" onkeyup="productBomRateKeyup(event)" style="width: 30%;" class="req" readonly="readonly" value="${mfgProcessDoc.bomRate}"/> %</td>
						</tr>
						<tr>
							<th style="border-left: none;">대체BOM</th>
							<td>
								<c:if test="${userUtil:getUserGrade(pageContext.request) == '3'}">
									<input type="text" name="stlal" style="width: 100%;" value="${mfgProcessDoc.stlal}" placeholder="BOM담당자만 입력" />
								</c:if>
							</td>
							<th>품목제조보고서명</th>
							<td><input type="text" name="docProdName" style="width: 90%;" class="req" value="${mfgProcessDoc.docProdName}"/></td>
							<th>제조공정도 유형</th>
							<td>
								<!-- <input type="text" name="lineProcessType" style="width: 100%;" class="" placeholder="(예1_1라인 A형)" /> -->
								<div class="selectbox" style="width: 100%">
									<label for="lineProcessType">-- 제조공정도 유형 --</label>
									<select name="lineProcessType" id="lineProcessType">
										<option value="" selected>-- 제조공정도 유형 --</option>
										<option value="강력" selected>강력</option>
										<option value="중력" selected>중력</option>
										<option value="박력" selected>박력</option>
									</select>
								</div>
							</td>
						</tr>
						<tr style="display: none">
							<th style="border-left: none;">봉당 들이수</th>
							<td><input type="text" name="numBong" onkeyup="clearNoNum(this)" style="width: 30%;" class="req" value="${mfgProcessDoc.numBong}"/> /ea</td>
							<th>상자 들이수</th>
							<td><input type="text" name="numBox" onkeyup="clearNoNum(this)" style="width: 30%;" class="req" value="${mfgProcessDoc.numBox}"/></td>
							<th>분할중량 총합계(g)</th>
							<td><input type="text" name="totWeight" onkeyup="clearNoNum(this)" style="width: 100%;" readonly="readonly" class="read_only" value="${mfgProcessDoc.totWeight}"/></td>
						</tr>
						<tr style="display: none">
							<th style="border-left: none;">소성손실(g/%)</th>
							<td><input type="text" name="loss" onkeyup="clearNoNum(this)" style="width: 30%;" value="${mfgProcessDoc.loss}"/> %</td>
							<th>배합중량</th>
							<td>
								<input type="text" id="mixWeight" name="mixWeight" onkeyup="mixWeightKeyUp(event)" style="width: 30%;" class="req" value="${mfgProcessDoc.mixWeight}"/> kg
								( <input type="text" name="bagAmout" onkeyup="clearNoNum(this)" style="width: 20%;" class="req" value="${mfgProcessDoc.bagAmout}" /> 포)
							</td>
							<th>기준수량</th>
							<td><input type="text" name="stdAmount" style="width: 100%;" readonly="readonly" class="read_only" value="${mfgProcessDoc.stdAmount}"/></td>
						</tr>
					</tbody>
				</table>
			</div>
			<!-- 기준정보 close --------------------------------------------------------------------------------------------------------------------------------------------------------->
			<div class="fr pt20 pb10">
				<!-- <button class="btn_con_search" onclick="calcAll()"><img src="/resources/images/btn_icon_calc.png"> 전체 수식계산</button> -->
				<button class="btn_con_search" onclick="setAllPosnr()"><img src="/resources/images/btn_icon_setting.png"> BOM항목 일괄설정</button>
				<button class="btn_con_search" onclick="openStorageDialog(event, 'dialog_storage')"><img src="/resources/images/btn_icon_setting.png"> 저장위치 일괄설정</button>
				<button class="btn_con_search" onclick="copyBakeryAll()"><img src="/resources/images/btn_icon_setting.png"> 중량 일괄설정</button>
			</div>
			<!-- 원료 start --------------------------------------------------------------------------------------------------------------------------------------------------------->
			<div class="title5" style="padding-top: 50px;">
				<span class="txt">02. 원료</span>
			</div>
			<div class="_tab03" style="position: relative;">
				<div class="toLeft unselectable" onclick="moveLeft()"><span class="span_left">&lt;</span></div>
				<div style="display: inline-block; width:96%; margin-left:2%">
					<ul id="subScroll" class="ul"><c:forEach items="${mfgProcessDoc.sub}" var="sub" varStatus="subStatus"><c:set var="liClass" value="${subStatus.index == 0 ? 'select' : ''}"/><li id="subProdAddBtn_${subStatus.index}" class="${liClass}" onclick="changeTab(this)" ondblclick="changeSubProdName(event)">
							<span class="unselectable" ondblclick="dblSubProdNameSpan(event)">${sub.subProdName}</span>
							<input type="text" name="subProdName" onkeyup="subProdNameKeyup(event)" style="width: 180px;" placeholder="부속제품명 입력" class="" value="${sub.subProdName}" />
							<%-- <button name="subProdDelBtn" class="tab_btn_del" onclick="removeSubProduct('${subStatus.index}')"><img src="/resources/images/btn_table_header01_del02.png"></button> --%>
						</li></c:forEach>
					</ul>
				</div>
				<div class="toRight unselectable" onclick="moveRight()"><span class="span_left">&gt;</span></div>
			</div>
			
			<c:forEach items="${mfgProcessDoc.sub}" var="sub" varStatus="subStatus">
				<c:set var="isVisible" value="${subStatus.index == 0 ? 'block' : 'none'}"/>
				<div id="subProdDiv_${subStatus.index}" name="subProdDiv" style="display:${isVisible};">
					<div class="main_tbl">
						<table class="insert_proc01" style="border-top: none; border-right: 1px solid #d1d1d1">
							<colgroup>
								<col width="13%" />
								<col width="20%" />
								<col width="13%" />
								<col width="20%" />
								<col width="14%" />
								<col width="20%" />
							</colgroup>
							<tbody>
								<tr>
									<%-- <th>분할 중량</th>
									<td>
										<input type="text" name="subProdDivWeight" value="${sub.stdAmount}" style="width: 25%;" class="read_only" readonly="readonly" onkeyup="calcStdAmount(event)"/> g
										(
										<input type="text" name="subProdDivUnitWeight" value="${sub.unitWeight}" class="req" style="width: 20%" onkeyup="setSubProdDivWeight(event)">g
										x
										<input type="text" name="subProdDivUnitVolume" value="${sub.unitVolume}" class="req" style="width: 15%" onkeyup="setSubProdDivWeight(event)">ea
										)
									</td>
									<th>분할중량 설명</th>
									<td><input type="text" name="subProdDivWeightTxt" style="width: 100%;" value="${sub.divWeightTxt}"/></td> --%>
									<td colspan="4"></td>
									<th>기준수량</th>
									<td>
										<%-- <input type="text" name="subProdDivWeight" value="${sub.divWeight}" style="display:none;"/> --%>
										<input type="text" name="subProdStdAmount" style="width: 100%;" readonly="readonly" class="read_only" value="${sub.stdAmount}"/>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					<div>
						<div class="tbl_in_title">▼ 배합비</div>
						<div class="tbl_in_con">
							<c:forEach items="${sub.mix}" var="mix" varStatus="baseStatus">
								<div class="nomal_mix">
									<div class="table_header01">
										<input type="hidden" name="baseType" value="MI"/>
										<span class="table_order_btn">
											<button class="btn_up" onclick="moveUp(this)"></button><button class="btn_down" onclick="moveDown(this)"></button>
										</span><span class="title" style="width: 70%"><img
											src="/resources/images/img_table_header.png">&nbsp;&nbsp;배합비명 : <input
											type="text" name="baseName" style="width: 200px" value="${mix.baseName}"/>
										</span><span class="table_header_btn_box">
											<!-- <button class="btn_del_table_header" onclick="removeTable(this, 'mix')">배합 삭제</button> -->
											<button class="btn_add_tr" onclick="addRow(this, 'mix')"></button><button class="btn_del_tr" onclick="removeRow(this)"></button>
										</span>
									</div>
									<table class="tbl05">
										<colgroup>
											<col width="20">
											<col width="140">
											<col />
											<col width="8%">
											<col width="8%">
											<col width="8%">
											<%-- <col width="8%"> --%>
											<col width="8%">
											<%-- <col width="8%"> --%>
											<col width="7%">
											<col width="7%">
										</colgroup>
										<thead>
											<tr>
												<th><input type="checkbox" id="mixTable_${baseStatus.index}" onclick="checkAll(event)"><label for="mixTable_${baseStatus.index}"><span></span></label></th>
												<th>원료코드</th>
												<th>원료명</th>
												<!-- <th>배합%</th> -->
												<th>BOM수량</th>
												<th>단위</th>
												<!-- <th>중량g( <a href="#none" name="copyBakery" onclick="copyBakery(this)">복제</a> )</th> -->
												<th>BOM항목</th>
												<!-- <th>공정로스</th> -->
												<th>저장위치</th>
												<th>원산지</th>
											</tr>
										</thead>
										<tbody id="mixTbody_${subStatus.index}_${baseStatus.index}">
											<c:set var="bomRateTotal" value="0"/>
											<c:set var="weightTotal" value="0"/>
											<c:forEach items="${mix.item}" var="item" varStatus="itemStatus">
												<c:if test="${!(fn:startsWith(item.itemCode, '4') || fn:startsWith(item.itemCode, '5'))}">
													<c:set var="bomRateTotal" value="${bomRateTotal + item.bomRate}"/>
													<c:set var="weightTotal" value="${weightTotal + item.weight}"/>
												</c:if>
												
												<c:set var="backgroundColor" value=""/>												
												<c:if test="${fn:startsWith(item.itemCode, '4') || fn:startsWith(item.itemCode, '5')}">
													<c:set var="backgroundColor" value="#ffe8d9"/>
												</c:if>
												<Tr id="mixRow_${itemStatus.index}" class="temp_color">
													<Td><input type="checkbox" id="mix_${itemStatus.index}"><label for="mix_${itemStatus.index}"><span></span></label></Td>
													<Td>
														<input type="hidden" name="itemImNo" style="width: 100px" class="req code_tbl" value="${item.itemImNo}"/>		
														<input type="text" name="itemSapCode" style="width: 100px" class="req code_tbl" value="${item.itemCode}" onkeyup="checkMaterail(event, 'B', '')"/>
														<button class="btn_code_search2" onclick="openMaterialPopup(this, 'B')"></button>
													</Td>
													<Td><input type="text" name="itemName" style="width: 85%" readonly="readonly" class="read_only" value="${item.itemName}"/><button class="btn_code_info2"></button></Td>
													<Td>
														<input type="text" name="itemBomRate" style="width: 100%; background-color: ${backgroundColor};" class="req" value="${item.bomRate}" onkeyup="calcBomRate(event)"/>
													</Td>
													<Td><input type="text" name="itemUnit" style="width: 100%" class="read_only" readonly="readonly" value="${item.unit}"/></Td>
													<%-- <Td><input type="text" name="itemWeight" style="width: 100%; background-color: ${backgroundColor};" class="req" onkeyup="calcItemWeight(event)" value="${item.weight}"/></Td> --%>
													<Td><input type="text" name="itemPosnr" style="width: 100%" value="${item.posnr}"/></Td>
													<Td>
														<c:choose>
															<c:when test="${item.itemCode == 'P001' || item.itemCode == 'P10001' || item.itemCode == 'P10002' || item.itemCode == 'P10003'}">
																<c:set var="disabled" value="disabled"/>
															</c:when>
															<c:otherwise>
																<c:set var="disabled" value=""/>
															</c:otherwise>
														</c:choose>
														<div class="selectbox" style="width: 90%">
															<select name="itemStorageCode" id="select_storage_mix_${itemStatus.index}" ${disabled}>
																<c:set var="itemStorageCodeText" value=""/>
																<option value="">선택</option>
																<c:forEach items="${specificStorageList}" var="storage">
																	<c:set var="selected" value="${storage.storageCode == item.storageCode ? 'selected' : ''}"/>
																	<c:if test="${storage.storageCode == item.storageCode}">
																		<c:set var="itemStorageCodeText" value="${storage.storageCode}"/>
																	</c:if>
																	<option value="${storage.storageCode}" ${selected}>${storage.storageCode}</option>
																</c:forEach>
															</select>
															<c:set var="itemStorageCodeText" value="${itemStorageCodeText == '' ? '선택' : itemStorageCodeText}"/>
															<label for="select_storage_mix_${itemStatus.index}">${itemStorageCodeText}</label>
														</div>
													</Td>
													<Td>
														<div class="selectbox" style="width: 90%">
															<select name="itemOrigin" id="select_origin_mix_${itemStatus.index}">
																<option value="" <c:out value='${item.coo == "" ? "selected" : ""}'/>>없음</option>
																<option value="C" <c:out value='${item.coo == "C" ? "selected" : ""}'/>>캐나다(C)</option>
																<option value="U" <c:out value='${item.coo == "U" ? "selected" : ""}'/>>미국(U)</option>
																<option value="A" <c:out value='${item.coo == "A" ? "selected" : ""}'/>>호주(A)</option>
																<option value="K" <c:out value='${item.coo == "K" ? "selected" : ""}'/>>한국(K)</option>
																<option value="F" <c:out value='${item.coo == "F" ? "selected" : ""}'/>>프랑스(F)</option>
																<option value="G" <c:out value='${item.coo == "G" ? "selected" : ""}'/>>독일(G)</option>
															</select>
															<label for="select_origin_mix_${itemStatus.index}">${item.cooName}</label>
														</div>
													</Td>
												</Tr>
											</c:forEach>
										</tbody>
										<tfoot>
											<Tr>
												<Td colspan="3">합계</Td>
												<%-- <Td><input type="text" name="bomAmountTotal" style="width: 100%" readonly="readonly" class="read_only" value="${bomAmountTotal}"/></Td> --%>
												<Td><input type="text" name="bomRateTotal" style="width: 100%" readonly="readonly" class="read_only" value="${bomRateTotal}"/></Td>
												<Td>&nbsp;</Td>
												<%-- <Td><input type="text" name="itemWeightTotal" style="width: 100%" readonly="readonly" class="read_only" value="${weightTotal}"/></Td> --%>
												<Td>&nbsp;</Td>
												<!-- <Td>&nbsp;</Td> -->
												<Td>&nbsp;</Td>
												<Td>&nbsp;</Td>
											</Tr>
										</tfoot>
									</table>
								</div>
							</c:forEach>
							<!-- 
							<div class="add_nomal_mix" onclick="addTable(this, 'mix')">
								<span><img src="/resources/images/btn_pop_add2.png"> 배합비 추가</span>
							</div>
							 -->
						</div>
					</div>
				</div>
			</c:forEach>
			<div class="fl" style="width: 100%">
				<div class="fl" style="width: 50%;">
					<!-- 제조방법 start --------------------------------------------------------------------------------------------------------------------------------------------------------->
					<div class="title5" style="float: left; margin-top: 30px;">
						<span class="txt">06. 제조방법</span>
					</div>
					<div class="main_tbl">
						<table class="insert_proc01">
							<tbody>
								<tr>
									<td style="border-left: none;">
										<textarea name="menuProcess" style="width: 100%; height: 130px">${mfgProcessDoc.menuProcess}</textarea>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					<!-- 제조방법 close --------------------------------------------------------------------------------------------------------------------------------------------------------->
				</div>
				<div class="fl" style="width: 50%;">
					<!-- 제조규격 start --------------------------------------------------------------------------------------------------------------------------------------------------------->
					<div class="title5" style="float: left; margin-top: 30px;">
						<span class="txt">07. 제조규격</span>
					</div>
					<div class="main_tbl">
						<table class="insert_proc01">
							<tbody>
								<tr>
									<td style="border-left: none;">
										<textarea name="standard" style="width: 100%; height: 130px">${mfgProcessDoc.standard}</textarea>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					<!-- 제조규격 close --------------------------------------------------------------------------------------------------------------------------------------------------------->
				</div>
			</div>
			<!-- 제품규격 start --------------------------------------------------------------------------------------------------------------------------------------------------------->
			<div class="title5" style="float: left; margin-top: 30px;">
				<span class="txt">09. 제품규격(밀다원)</span>
			</div>
			<div class="main_tbl">
				<table class="insert_proc01">
					<colgroup>
						<col width="16%">
						<col width="18%">
						<col width="15%">
						<col width="18%">
						<col width="15%">
						<col width="18%">
					</colgroup>
					<tbody name="specMDTbody">
						<tr>
							<th>Moisture(%)</th>
							<td>
								<input type="text" name="moisture" style="float:left; width: 70%" value="${mfgProcessDoc.specMD.moisture}"/>
								<div class="selectbox" style="width: 30%">
									<label for="moistureUnit">${mfgProcessDoc.specMD.moistureUnit == 'gt' ? '↑' : '↓'}</label>
									<select name="moistureUnit" id="moistureUnit">
										<option value="gt" ${mfgProcessDoc.specMD.moistureUnit == 'gt' ? 'selected' : ''}>↑</option>
										<option value="lt" ${mfgProcessDoc.specMD.moistureUnit == 'lt' ? 'selected' : ''}>↓</option>
									</select>
								</div>
							</td>
							<th>Ash(%)</th>
							<td>
								<input type="text" name="ashFrom" style="width: 45%" value="${mfgProcessDoc.specMD.ashFrom}"/>
								~<input type="text" name="ashTo" style="width: 45%" value="${mfgProcessDoc.specMD.ashTo}"/>
							</td>
							<th>Protein(%)</th>
							<td>
								<input type="text" name="protein" style="width: 50%" value="${mfgProcessDoc.specMD.protein}"/>
								<input type="text" name="proteinErr" style="width: 20%; float:right" value="${mfgProcessDoc.specMD.proteinErr}"/>
								<div  style="float:right;"><span>±</span></div>
							</td>
						</tr>
						<tr>
							<th>Water absorption(%)</th>
							<td>
								<input type="text" name="waterAbsFrom" style="width: 45%" value="${mfgProcessDoc.specMD.waterAbsFrom}"/>
								~<input type="text" name="waterAbsTo" style="width: 45%" value="${mfgProcessDoc.specMD.waterAbsTo}"/>
							</td>
							<th>Stability(min)</th>
							<td>
								<input type="text" name="stabilityFrom" style="width: 45%" value="${mfgProcessDoc.specMD.stabilityFrom}"/>
								~<input type="text" name="stabilityTo" style="width: 45%" value="${mfgProcessDoc.specMD.stabilityTo}"/>
							</td>
							<th>Development time(min)</th>
							<td>
								<input type="text" name="devTime" style="float:left; width: 70%" value="${mfgProcessDoc.specMD.devTime}"/>
								<div class="selectbox" style="width: 30%">
									<label for="devTimeUnit">${mfgProcessDoc.specMD.devTimeUnit == 'gt' ? '↑' : '↓'}</label>
									<select name="devTimeUnit" id="devTimeUnit">
										<option value="gt" ${mfgProcessDoc.specMD.devTimeUnit == 'gt' ? 'selected' : ''}>↑</option>
										<option value="lt" ${mfgProcessDoc.specMD.devTimeUnit == 'lt' ? 'selected' : ''}>↓</option>
									</select>
								</div>
							</td>
						</tr>
						<tr>
							<th>P/L</th>
							<td>
								<input type="text" name="plFrom" style="width: 45%" value="${mfgProcessDoc.specMD.plFrom}"/>
								~<input type="text" name="plTo" style="width: 45%" value="${mfgProcessDoc.specMD.plTo}"/>
							</td>
							<th>Maximum viscosity(BU)</th>
							<td>
								<input type="text" name="maxVisc" style="float:left; width: 70%" value="${mfgProcessDoc.specMD.maxVisc}"/>
								<div class="selectbox" style="width: 30%">
									<label for="maxViscUnit">${mfgProcessDoc.specMD.maxViscUnit == 'gt' ? '↑' : '↓'}</label>
									<select name="maxViscUnit" id="maxViscUnit">
										<option value="gt" ${mfgProcessDoc.specMD.maxViscUnit == 'gt' ? 'selected' : ''}>↑</option>
										<option value="lt" ${mfgProcessDoc.specMD.maxViscUnit == 'lt' ? 'selected' : ''}>↓</option>
									</select>
								</div>
							</td>
							<th>FN(sec)</th>
							<td>
								<input type="text" name="fnFrom" style="width: 45%" value="${mfgProcessDoc.specMD.fnFrom}"/>
								~<input type="text" name="fnTo" style="width: 45%" value="${mfgProcessDoc.specMD.fnTo}"/>
							</td>
						</tr>
						<tr>
							<th>Color(Lightness)</th>
							<td>
								<input type="text" name="color" style="float:left; width: 70%" value="${mfgProcessDoc.specMD.color}"/>
								<div class="selectbox" style="width: 30%">
									<label for="colorUnit">${mfgProcessDoc.specMD.colorUnit == 'gt' ? '↑' : '↓'}</label>
									<select name="colorUnit" id="colorUnit">
										<option value="gt" ${mfgProcessDoc.specMD.colorUnit == 'gt' ? 'selected' : ''}>↑</option>
										<option value="lt" ${mfgProcessDoc.specMD.colorUnit == 'lt' ? 'selected' : ''}>↓</option>
									</select>
								</div>
							</td>
							<th>Wet gluten(%)</th>
							<td>
								<input type="text" name="wetGlutenFrom" style="width: 45%" value="${mfgProcessDoc.specMD.wetGlutenFrom}"/>
								~<input type="text" name="wetGlutenTo" style="width: 45%" value="${mfgProcessDoc.specMD.wetGlutenTo}"/>
							</td>
							<th>Viscosity(Batter)mm</th>
							<td>
								<input type="text" name="visc" style="float:left; width: 70%" value="${mfgProcessDoc.specMD.visc}"/>
								<div class="selectbox" style="width: 30%">
									<label for="viscUnit">${mfgProcessDoc.specMD.viscUnit == 'gt' ? '↑' : '↓'}</label>
									<select name="viscUnit" id="viscUnit">
										<option value="gt" ${mfgProcessDoc.specMD.viscUnit == 'gt' ? 'selected' : ''}>↑</option>
										<option value="lt" ${mfgProcessDoc.specMD.viscUnit == 'lt' ? 'selected' : ''}>↓</option>
									</select>
								</div>
							</td>
						</tr>
						<tr>
							<th>Particle size(Average)㎛</th>
							<td><input type="text" name="particleSize" style="width: 100%" value="${mfgProcessDoc.specMD.particleSize}"/></td>
							<th></th>
							<td></td>
							<th></th>
							<td></td>
						</tr>
					</tbody>
				</table>
			</div>
			<!-- 제품규격 close --------------------------------------------------------------------------------------------------------------------------------------------------------->
			<div class="btn_box_con5">
				<button class="btn_admin_gray" onClick="history.back()" style="width: 120px;">목록</button>
			</div>
			<div class="btn_box_con4">
				<c:if test="${mfgProcessDoc.state == '7'}">
					<button class="btn_admin_navi" onclick="updateMfgProcessDoc('7')">임시저장</button>
				</c:if>
				<button class="btn_admin_sky" onclick="updateMfgProcessDoc()">저장</button>
				<button class="btn_admin_gray" onclick="goMfgDetail()">취소</button>
			</div>
			<hr class="con_mode" />
			<!-- 신규 추가 꼭 데려갈것 !-->
	</section>
</div>


<!-- 레이어드 팝업 -->
<!-- 저장위치 설정 레이어 START -->
<div class="white_content" id="dialog_storage">
	<input id="targetStorageId" type="hidden" value="">
	<input id="storageSetType" type="hidden" value="">
	<div class="modal positionCenter" style="width: 410px;">
		<h5 style="position: relative">
			<span class="title">저장위치 설정</span>
			<div class="top_btn_box">
				<ul>
					<li>
						<button class="btn_madal_close" onClick="closeDialog('dialog_storage')"></button>
					</li>
				</ul>
			</div>
		</h5>
		<div class="list_detail">
			<ul>
				<li class="pt10 mb5">
					<dt style="width: 30%">저장 위치</dt>
					<dd style="width: 70%">
						<div class="selectbox req" style="width:60%">
							<label for="dialogStorage">선택</label>
							<select id="dialogStorage">
								<%-- <c:forEach items="${storageList}" var="sotrage">
									<option value="${sotrage.storageCode}">${sotrage.storageCode}[${sotrage.storageName}]</option>
								</c:forEach> --%>
							</select>
						</div>
					</dd>
				</li>
			</ul>
		</div>
		<div class="btn_box_con">
			<button class="btn_admin_red" onclick="setItemStorage()">설정하기</button>
			<button class="btn_admin_gray" onClick="closeDialog('dialog_storage')">취소</button>
		</div>
	</div>
</div>
<!-- 저장위치 설정 레이어 END -->


<!-- 제조공정서/제품개발문서 가져오기 START -->
<div class="white_content" id="dialog_import">
	<div class="modal" style="margin-left:-455px;width:910px;height: 340px;margin-top:-225px">
		<h5 style="position: relative">
			<span class="title">제조공정서/제품개발문서 가져오기</span>
			<div class="top_btn_box">
				<ul>
					<li>
						<button class="btn_madal_close" onClick="closeDialog('dialog_import')"></button>
					</li>
				</ul>
			</div>
		</h5>
		<div class="list_detail">
			<ul>
				<li class=" mb5">
					<dt style="width:20%">생성타입</dt>
					<dd style="width:80%">
						<input type="radio" name="docImportType" id="docImportTypeDesign" value="design" onchange="changeImportType(event)" checked>
						<label for="docImportTypeDesign" style="width: 400px"><span></span>제품설계서 가져오기</label>
						<input type="radio" name="docImportType" id="docImportTypeDev" value="dev" onchange="changeImportType(event)">
						<label for="docImportTypeDev" style="width: 400px"><span></span>제조공정서 가져오기</label>
					</dd>
				</li>
				<li id="dialog_create_li_design" class="mb5" style="display: block">
					<dt style="width:20%">제품설계문서 리스트</dt>
					<dd style="width:80%">
						<div class="selectbox req" style="width:170px;">  
							<label for="dialog_companyCode">선택</label> 
							<select id="dialog_companyCode" onchange="changeMfgCompanySelect(event, 'dialog_plantCode')">
								<option value="" selected>--회사선택--</option>
								<c:forEach items="${companyList}" var="company" varStatus="status">
									<c:set var="selected" value="${status.index == 0 ? 'selected' : ''}"></c:set>
									<option value="${company.companyCode}">${company.companyName}</option>
								</c:forEach>
							</select>
							</div>
							<div class="selectbox  ml5" style="width:170px;">  
							<label for="dialog_plantCode">공장상세선택</label> 
							<select id="dialog_plantCode">
								<option value="">공장상세선택</option>
							</select>
						</div>
						<input id="dialog_design_productName" type="text" style="width:300px; margin-left:5px; padding-bottom:3px" placeholder="제품명으로 검색"
						/><button class="btn_small_search ml5" onclick="searchDesignDoc()">검색</button>
						
						<div id="designDocSelectDiv" style="display: none">
							<br>
	                        <div class="selectbox req" style="width:207px;">
	                            <label id="label_select_designDoc" for="select_devDoc">제품개발문서 선택</label>
	                            <select id="select_designDoc" onchange="searchDesignDocDetailList(event)">
	                            	<option selected>제품개발문서 선택</option>
	                            </select>
	                        </div>
	                        <div class="selectbox req ml5" style="width:350px;">
	                            <label id="label_select_designDocDetail" for="select_mfgDoc">설계사 선택</label>
	                            <select id="select_designDocDetail">
	                            	<option selected>설계사 선택</option>
	                            </select>
	                        </div>
                        </div>
					</dd>
				</li>
                <li id="dialog_create_li_mfg" class="mb5" style="display: none">
					<dt style="width:20%">제조공정서 리스트</dt>
					<dd style="width:80%">
						<div class="selectbox req" style="width:130px;">  
							<label for="productType1" id="label_productType1"> 전체</label> 
							<select id="productType1" name="productType1" onChange="loadProductType('2','productType2')">
							</select>
						</div>
						<div class="selectbox req ml5" style="width:130px;" id="li_productType2">  
							<label for="productType2" id="label_productType2"> 전체</label> 
							<select id="productType2" name="productType2" onChange="loadProductType('3','productType3')">
							</select>
						</div>
						<div class="selectbox req ml5" style="width:130px;" id="li_productType3">  
							<label for="productType3" id="label_productType3"> 전체</label> 
							<select id="productType3" name="productType3">
							</select>
						</div>
						<input id="dialog_mfg_productName" type="text" style="width:160px; margin-left:5px; padding-bottom:3px" placeholder="제품명으로 검색"
						/><button class="btn_small_search ml5" onclick="searchDevDoc()">검색</button>
						<div id="mfgDocSelectDiv" style="display: none">
							<br>
	                        <div class="selectbox req" style="width:207px;">
	                            <label id="label_select_devDoc" for="select_devDoc">제품개발문서 선택</label>
	                            <select id="select_devDoc" onchange="searchDocVersion(event)">
	                            	<option selected>제품개발문서 선택</option>
	                            </select>
	                        </div>
	                        <div class="selectbox req ml5" style="width:70px;">
	                            <label id="label_select_docVersionc" for="select_docVersion">버전</label>
	                            <select id="select_docVersion" onchange="searchMfgDoc()">
	                            	<option selected>버전</option>
	                            </select>
	                        </div>
	                        <div class="selectbox req ml5" style="width:350px;">
	                            <label id="label_select_mfgDoc" for="select_mfgDoc">제조공정서 선택</label>
	                            <select id="select_mfgDoc">
	                            	<option selected>제조공정서 선택</option>
	                            </select>
	                        </div>
                        </div>
					</dd>
				</li> 
			</ul>
		</div>
		<div class="btn_box_con">
			<button class="btn_admin_red" onclick="getImportData()">불러오기</button>
			<button class="btn_admin_gray" onClick="closeDialog('dialog_import')">취소</button>
		</div>
	</div>
</div>
<!-- 제조공정서/제품개발문서 가져오기 END -->


<div id="mixDiv_temp" class="nomal_mix" style="display:none">
	<div class="table_header01">
		<input type="hidden" name="baseType" value="MI"/>
		<span class="table_order_btn">
			<button class="btn_up" onclick="moveUp(this)"></button><button class="btn_down" onclick="moveDown(this)"></button>
		</span><span class="title" style="width:70%"><img
			src="/resources/images/img_table_header.png">&nbsp;&nbsp;배합비명 : <input
			type="text" name="baseName" style="width: 200px" />
		</span><span class="table_header_btn_box">
			<button class="btn_del_table_header" onclick="removeTable(this, 'mix')">배합 삭제</button>
			<button class="btn_add_tr" onclick="addRow(this, 'mix')"></button><button class="btn_del_tr" onclick="removeRow(this)"></button>
		</span>
	</div>
	<table class="tbl05">
		<colgroup>
			<col width="20">
			<col width="140">
			<col />
			<col width="8%">
			<col width="8%">
			<%-- <col width="8%"> --%>
			<col width="8%">
			<col width="7%">
			<col width="7%">
		</colgroup>
		<thead>
			<tr>
				<th><input type="checkbox" id="mixTable_temp" onclick="checkAll(event)"><label for="mixTable_temp"><span></span></label></th>
				<th>원료코드</th>
				<th>원료명</th>
				<th>BOM수량</th>
				<th>단위</th>
				<th>BOM항목</th>
				<th>저장위치</th>
				<th>원산지</th>
			</tr>
		</thead>
		<tbody>
			<Tr id="mixRow_temp" class="temp_color">
				<Td><input type="checkbox" id="mix_1"><label for="mix_1"><span></span></label></Td>
				<Td>
					<input type="hidden" name="itemImNo" style="width: 100px" class="req code_tbl"/>
					<input type="text" name="itemSapCode" style="width: 100px" class="req code_tbl" onkeyup="checkMaterail(event, 'B', '')"/>
					<button class="btn_code_search2" onclick="openMaterialPopup(this, 'B')"></button>
				</Td>
				<Td><input type="text" name="itemName" style="width: 85%" readonly="readonly" class="read_only" /><button class="btn_code_info2"></button></Td>
				<Td><input type="text" name="itemBomRate" style="width: 100%" class="req" onkeyup="calcBomRate(event)"/></Td>
				<Td><input type="text" name="itemUnit" style="width: 100%" class="read_only" readonly="readonly"/></Td>
				<Td><input type="text" name="itemPosnr" style="width: 100%" /></Td>
				<Td>
					<div class="selectbox" style="width: 90%">
						<select name="itemStorageCode" id="select_storage_mix_temp">
							<option value="" selected>선택</option>
							<c:forEach items="${specificStorageList}" var="sotrage">
								<option value="${sotrage.storageCode}">${sotrage.storageCode}</option>
							</c:forEach>
						</select>
						<label for="select_storage_mix_temp">선택</label>
					</div>
				</Td>
				<Td>
					<div class="selectbox" style="width: 90%">
						<select name="itemOrigin" id="select_origin_mix_temp">
							<option value="" selected>없음</option>
							<option value="C">캐나다(C)</option>
							<option value="U">미국(U)</option>
							<option value="A">호주(A)</option>
							<option value="K">한국(K)</option>
							<option value="F">프랑스(F)</option>
							<option value="G">독일(G)</option>
						</select>
						<label for="select_origin_mix_temp">선택</label>
					</div>
				</Td>
			</Tr>
		</tbody>
		<tfoot>
			<Tr>
				<Td colspan="3">합계</Td>
				<Td><input type="text" name="bomAmountTotal" style="width: 100%" value="0" readonly="readonly" class="read_only" /></Td>
				<Td><input type="text" name="bomRateTotal" style="width: 100%" value="0" readonly="readonly" class="read_only" /></Td>
				<Td>&nbsp;</Td>
				<Td>&nbsp;</Td>
				<!-- <Td><input type="text" name="itemWeightTotal" style="width: 100%" value="0" readonly="readonly" class="read_only" /></Td> -->
				<Td>&nbsp;</Td>
				<Td>&nbsp;</Td>
				<Td>&nbsp;</Td>
				<Td>&nbsp;</Td>
			</Tr>
		</tfoot>
	</table>
</div>



<!-- 코드검색 추가레이어 start-->
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
					<li><button class="btn_madal_close" onClick="closeMatRayer()"></button></li>
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
						<col width="15%">
						<col width="10%">
						<col width="auto">
						<col width="8%">
						<col width="5%">
						<col width="10%">
						<col width="15%">
					</colgroup>
					<thead>
						<tr>
							<th></th>
							<th>공장</th>
							<th>SAP코드</th>
							<th>자재명</th>
							<th>단가</th>
							<th>구분</th>
							<th>공급일자</th>
							<th>공급업체</th>
						<tr>
					</thead>
					<tbody id="matLayerBody">
						<input type="hidden" id="matLayerPage" value="0"/>
						<Tr>
							<td colspan="8">원료코드 혹은 원료코드명을 검색해주세요</td>
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

<table id="dispTable_temp" class="tbl05">
	<colgroup>
		<col width="20">
		<col width="30%">
		<col width="30%">
		<col />
	</colgroup>
	<tbody name="dispTbody">
		<Tr id="dispRow_temp">
			<Td><input type="checkbox" id="disp_1"><label for="disp_1"><span></span></label></Td>
			<Td>
				<input type="hidden" name="itemSapCode">
				<input type="text" name="matName" style="width: 80%" class="read_only" readonly="readonly"/>
			</Td>
			<Td><input type="text" name="excRate" style="width: 80%" onkeyup="calcDisp(event)" class="read_only" readonly="readonly"/></Td>
			<Td><input type="text" name="incRate" style="width: 80%" onkeyup="calcDisp(event)" class="read_only" readonly="readonly"/></Td>
		</Tr>
	</tbody>
</table>