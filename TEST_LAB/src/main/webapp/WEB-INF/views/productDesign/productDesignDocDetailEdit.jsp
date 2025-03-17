<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<title>제품설계서>설계서 신규작성</title>

<style>
.positionCenter{
	position: absolute;
	transform: translate(-50%, -47%);
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
	
	$(document).ready(function(){
		subProdTabBtn = '<li id="" class="select" onclick="changeTab(this)">' + $('#subProdAddBtn_temp').html() + '</li>';
		
		subProdHead = '<div name="subProdHead">'+$('div[name=subProdHead]:first').html()+'</div>';
		subProdDiv = '<div name="subProdDiv">'+$('#subProdDiv_temp').html()+'</div>'
		
		mixTable = '<div class="nomal_mix">'+$('#mixDiv_temp').html()+'</div>';
		contentTable = '<div class="nomal_mix">'+$('#contDiv_temp').html()+'</div>';
		
		mixRow = '<tr>'+$('#mixRow_temp').html()+'</tr>';
		contentRow = '<tr>'+$('#contentRow_temp').html()+'</tr>';
		dispRow = '<tr>'+$('#dispRow_temp').html()+'</tr>';
		packageRow = '<tr>'+$('#pkgRow_temp').html()+'</tr>';
		consumeRow = '<tr>'+$('#consRow_temp').html()+'</tr>';
		
		$('#dispTable_temp').remove();
		$('#pkgTable_temp').remove();
		$('#consTable_temp').remove();
		
		$('#btn_temp').remove();
		$('#subProdDiv_temp').remove();
		
		 $('input[name=mixingRatio]:first').keyup();
		 //calcTotalTable();
		 
		 //$('input[name=itemSapCode]').bind('keyup', function(e){ if(e.keyCode== 13) $(e.target).next().click() });
	});
	
	function bindEnterKeySapCode(element){
		$(element).bind('keyup', function(e){ if(e.keyCode== 13) $(e.target).next().click() });
	}
	
	function selectChange(e){
		var target = $(e.target);
		var value = e.target.value;
		
		target.prev().text(value);
		target.children('option').toArray().forEach(function(option){
			if($(option).val() == value) {
				$(option).attr('checked', true)
			} else {
				$(option).attr('checked', false)
			}
		})
	}
	
	function setMaterialPopupData(parentRowId, itemImNo, itemSAPCode, itemName, itemUnitPrice, itemUnit){
		$('#'+parentRowId + ' input[name$=itemImNo]').val(itemImNo);
		$('#'+parentRowId + ' input[name$=itemSapCode]').val(itemSAPCode);
		$('#'+parentRowId + ' input[name$=itemName]').val(itemName);
		$('#'+parentRowId + ' input[name$=itemSapPrice]').val(itemUnitPrice);
		$('#'+parentRowId + ' input[name$=itemVolume]').val(0);
		$('#'+parentRowId + ' input[name$=itemUnitPrice]').val(itemUnitPrice);
		//$('#'+parentRowId + ' input[name$=itemCustomPrice]').val(itemUnitPrice);
		$('#'+parentRowId + ' input[name$=itemUnit]').val(itemUnit);
		$('#'+parentRowId + ' input[name$=itemCalculatedPrice]').val(itemUnitPrice);
		
		if(itemName.indexOf('[임시]') >= 0){
			$('#'+parentRowId).css('background-color', '#ffdb8c'); //#e7efef
		} else {
			$('#'+parentRowId).css('background-color', '#fff');
		}
		
		$('#'+parentRowId+' input[name=mixingRatio]').keyup();
		
		closeMatRayer();
	}
	
	function addSubProduct(element){
		var randomId = Math.random().toString(36).substr(2, 9);

		$(element).before(subProdTabBtn);
		$(element).prev().attr('id', 'subProdAddBtn_'+randomId);
		$('button[name=subProdDelBtn]:last').attr('onclick',"removeSubProduct('"+randomId+"')")
		
		var mixTableParentId = 'mixTbody_'+randomId+'_';
		var mixRowParentId = 'mixRow_'+randomId+'_';
		var mixParentId = 'mix_'+randomId+'_';
		var contentTableParentId = 'contentTbody_'+randomId+'_';
		var contentRowParentId = 'contentRow_'+randomId+'_';
		var contentParentId = 'content_'+randomId+'_';
		
		var tempSubProdDiv = subProdDiv.replace(/mixTbody_temp/gi, mixTableParentId);
		tempSubProdDiv = tempSubProdDiv.replace(/mixRow_temp/gi, mixRowParentId);
		tempSubProdDiv = tempSubProdDiv.replace(/mix_temp/gi, mixParentId);
		tempSubProdDiv = tempSubProdDiv.replace(/contentTbody_temp/gi, contentTableParentId);
		tempSubProdDiv = tempSubProdDiv.replace(/contentRow_temp/gi, contentRowParentId);
		tempSubProdDiv = tempSubProdDiv.replace(/content_temp/gi, contentParentId);
		
		if($('div[name=subProdDiv]').length > 0) {
			$('div[name=subProdDiv]:last').after(tempSubProdDiv);
		} else {
			$(element).parent().parent().parent().after(tempSubProdDiv);
		}
		$('div[name=subProdDiv]:last').attr('id', 'subProdDiv_'+randomId);
		$('#subScroll')[0].scrollLeft = 99999;
		$('#subProdAddBtn_'+randomId).click();
		
		setSpecificId('tbody', mixTableParentId, Math.random().toString(36).substr(2, 9));
		setSpecificId('tr', mixRowParentId, Math.random().toString(36).substr(2, 9));
		setSpecificId('input', mixParentId, Math.random().toString(36).substr(2, 9));
		setSpecificId('tbody', contentTableParentId, Math.random().toString(36).substr(2, 9));
		setSpecificId('tr', contentRowParentId, Math.random().toString(36).substr(2, 9));
		setSpecificId('input', contentParentId, Math.random().toString(36).substr(2, 9));
		setUniqueId('input', 'mixTable_temp');
		setUniqueId('input', 'contentTable_temp');
		
		/* setUniqueId('input', 'mixTable_temp');
		setUniqueId('input', 'contentTable_temp');
		setUniqueId('input', 'mix_temp');
		setUniqueId('input', 'content_temp'); */
	}
	
	function setUniqueId(tagName, duplId){
		var parentId = $(tagName+'[id='+duplId+']:first').attr('id').split('_')[0]+'_';
		var randomId = Math.random().toString(36).substr(2, 9);
		
		var targetElement = $(tagName+'[id='+duplId+']:last');
		var targetLabelElement =$(tagName+'[id='+duplId+']:last').parent().children('label');
		
		targetElement.attr('id', parentId+randomId);
		targetLabelElement.attr('for', parentId+randomId);
	}
	
	function removeSubProduct(tabId){
		if($('div[id^=subProdDiv_]').length == 1){
			return alert('부속제품은 최소 1개 이상이어야 합니다.');
		}
		var subProdName = $('#subProdAddBtn_'+tabId).children('input[name=subProdName]').val();
		
		if(!confirm('부속제품['+subProdName+']을 삭제하시겠습니까?')){
			return;
		}
		
		$('#subProdAddBtn_'+tabId).remove();
		$('#subProdDiv_'+tabId).remove();
		$('li[id*=subProdAddBtn]:last').click();
		
		if($('div[id^=subProdDiv_]').length < 4){
			$('#addSubProdA').show();
		}
	}
	
	function setSpecificId(tagName, parentId, specificId){
		var targetElement = $(tagName+'[id='+parentId+']');
		var targetLabelElement =$(tagName+'[id='+parentId+']').parent().children('label');
		
		targetElement.attr('id', parentId+specificId);
		targetLabelElement.attr('for', parentId+specificId);
	}
	
	function changeTab(element){
		var selectedId = element.id
		$(element).attr('class', 'select');
		$(element).siblings().each(function(index, li){
			if(li.id != selectedId)
				$(li).attr('class', '');
		})
		
		var tabId = selectedId.split('_')[1];
		if($('#subProdAddBtn_'+tabId)[0] !== undefined){
			$('li[id*=subProdAddBtn]').toArray().forEach(function(li){
				if(li.id == 'subProdAddBtn_'+tabId) {
					$(li).attr('class', 'select');
				} else {
					$(li).attr('class', '');
				}
			})
		}
		
		if($('#subProdDiv_'+tabId)[0] !== undefined){
			$('div[name*=subProdDiv]').toArray().forEach(function(element){
				if(element.id == 'subProdDiv_'+tabId) {
					$(element).show();
				} else {
					$(element).hide();
				}
			})
		}
	}
	
	function addTable(element, type){
		rowNumber++;
		tBodyNumber++;
		
		var bodyId;
		var tableBody;
		var subProdNdx = $(element).parent().parent().parent().attr('id').split('subProdDiv_')[1];
		
		if(type == 'mix') {
			bodyId = 'mixTbody_'+subProdNdx+'_';
			tableBody = mixTable;
		}
		if(type == 'content') {
			bodyId = 'contentTbody_'+subProdNdx+'_';
			tableBody = contentTable;
		}
		
		var randomId = randomId = Math.random().toString(36).substr(2, 9);
		
		$(element).parent().children('div.add_nomal_mix').before(tableBody);
		var insertedTbody = $(element).prev().children('table').children('thead');
		insertedTbody.children('tr').children('th:first').children('input[type=checkbox]').attr('id', type+'_'+randomId+'th')
		insertedTbody.children('tr').children('th:first').children('label').attr('for', type+'_'+randomId+'th')
		var insertedTbody = $(element).prev().children('table').children('tbody');
		insertedTbody.attr('id', bodyId+randomId);
		insertedTbody.children('tr').attr('id', type+'Row_'+randomId)
		insertedTbody.children('tr').children('td:first').children('input[type=checkbox]').attr('id', type+'_'+randomId)
		insertedTbody.children('tr').children('td:first').children('label').attr('for', type+'_'+randomId)
		$(element).parent().parent().next().children('tbody').children('tr:last').children('td').children('input[type=checkbox]').attr('id', type+'_'+randomId);
		$(element).parent().parent().next().children('tbody').children('tr:last').children('td').children('label').attr('for', type+'_'+randomId);
		
		/* if(type == 'mix') {
			setUniqueId('input', 'mixTable_temp');
		}
		if(type == 'content') {
			setUniqueId('input', 'contentTable_temp');
		} */
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
		if(type == 'package') row = packageRow;
		if(type == 'consume') row = consumeRow;
		
		$(element).parent().parent().next().children('tbody').append(row);
		$(element).parent().parent().next().children('tbody').children('tr:last').attr('id', type + 'Row_' + tBodyNumber + '_' + randomId);
		$(element).parent().parent().next().children('tbody').children('tr:last').children('td').children('input[type=checkbox]').attr('id', type+'_'+randomId);
		$(element).parent().parent().next().children('tbody').children('tr:last').children('td').children('label').attr('for', type+'_'+randomId);
		//var itemSapCodeElement = $(element).parent().parent().next().children('tbody').children('tr:last').children('td').children('input[name=itemSapCode]');
		//bindEnterKeySapCode(itemSapCodeElement);
		
		$(element).parent().parent().next().children('tbody').children('tr:last').children('td:last').children('div').children('label').attr('for', 'select_storage_'+randomId2);
		$(element).parent().parent().next().children('tbody').children('tr:last').children('td:last').children('div').children('select').attr('id', 'select_storage_'+randomId2);
	}
	
	function removeRow(element){
		$(element).parent().parent().next().children('tbody').children('tr').toArray().forEach(function(v, i){
			var checkBoxId = $(v).children('td:first').children('input[type=checkbox]')[0].id;
			if($('#'+checkBoxId).is(':checked')) $(v).remove();
		})
		calcBaseTable(event);
		calcPkgTable();
		
		//calcTableFooter(element)
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
	
	function checkAll(e){
		var tbody = $(e.target).parent().parent().parent().next();
		tbody.children('tr').children('td').children('input[type=checkbox]').toArray().forEach(function(checkbox){
			if(e.target.checked)
				checkbox.checked = true;
			else 
				checkbox.checked = false;
		})
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
	
function designDocValid(){
		
		if($('input[name=productPrice]').val().length <= 0){
			$('input[name=productPrice]').focus()
			alert('소매가격을 입력해주세요');
			return false;
		}
		
		if($('input[name=volume]').val().length <= 0){
			$('input[name=volume]').focus()
			alert('들이수를 입력해주세요');
			return false;
		}
		
		if($('input[name=rawPriceRate]').val().length <= 0){
			$('input[name=rawPriceRate]').focus()
			alert('원가비율을 입력해주세요');
			return false;
		}
		
		if($('input[name=yieldRate]').val().length <= 0){
			$('input[name=yieldRate]').focus()
			alert('수율을 입력해주세요');
			return false;
		}
		
		if($('input[name=memo]').val().length <= 0){
			$('input[name=memo]').focus()
			alert('설명을 입력해주세요');
			return false;
		}
		
		if($('textarea[name=makeProcess]').val().length <= 0){
			$('textarea[name=makeProcess]').focus()
			alert('제조공정을 입력해주세요');
			return false;
		}
		
		var subValid = true;
		var subElement;
		$('input[name=subProdDivWeight]').toArray().forEach(function(subProdDivWeight){
			if($(subProdDivWeight).val() == null || $(subProdDivWeight).val() == ''){
				subValid =  false;
				subElement = subProdDivWeight;
				return;
			}
		})
		if(!subValid){
			alert('서브제품에 대한 분할 중량을 입력 하셔야 계산이 가능 합니다.');
			$(subElement).focus();
			return false;
		}
		
		
		var mixValid = true;
		$('tr[id^=mixRow]').toArray().forEach(function(mixRow){
			if(!mixValid) return;
			
			var rowId = $(mixRow).attr('id');
			var itemSapCode = $('#'+ rowId + ' input[name=itemSapCode]').val();
			var itemName = $('#'+ rowId + ' input[name=itemName]').val();
			var mixingRatio = $('#'+ rowId + ' input[name=mixingRatio]').val();
			
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
			if(mixingRatio.length <= 0){
				mixValid = false;
				alert('배합율을 입력해주세요');
				return;
			}
		})
		if(!mixValid) return false;
		
		var contValid = true;
		$('tr[id^=contentRow]').toArray().forEach(function(contRow){
			if(!contValid) return;
			
			var rowId = $(contRow).attr('id');
			var itemSapCode = $('#'+ rowId + ' input[name=itemSapCode]').val();
			var itemName = $('#'+ rowId + ' input[name=itemName]').val();
			var mixingRatio = $('#'+ rowId + ' input[name=mixingRatio]').val();
			
			if(itemSapCode.length <= 0){
				contValid = false;
				alert('원료코드를 입력해주세요');
				return;
			}
			if(itemName.length <= 0){
				contValid = false;
				alert('원료를 검색하여 선택해주세요');
				return;
			}
			if(mixingRatio.length <= 0){
				contValid = false;
				alert('배합율을 입력해주세요');
				return;
			}
		})
		if(!contValid) return false;
		
		/* 
		var pkgValid = true;
		$('tr[id^=packageRow_1]').toArray().forEach(function(pkgRow){
			if(!pkgValid) return;
			
			var rowId = $(pkgRow).attr('id');
			var itemSapCode = $('#'+ rowId + ' input[name=itemSapCode]').val();
			var itemName = $('#'+ rowId + ' input[name=itemName]').val();
			
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
		})
		if(!pkgValid) return false;
		 */
		
		return true;
	}
	
	function updateDocDetail(){
		$('#lab_loading').show();
		if(!designDocValid()){
			$('#lab_loading').hide();
			return;
		}
		
		var postData = getPostData2();
		var formData = new FormData();
		
		for(key in postData){
			formData.append(key, postData[key]);
		}
		formData.append('imageFile', $('#fileImageInput')[0].files[0]);
		
		$.ajax({
			url: '/design/updateProductDesignDocDetail',
			contentType: 'multipart/form-data',
			processData: false,
            contentType: false,
			type: 'post',
			data: formData, 
			success: function(data){
				if(data == 'S'){
					alert('수정되었습니다');
					location.href='/design/productDesignDocDetail?pNo='+'${pNo}';
					$('#lab_loading').hide();
				} else {
					$('#lab_loading').hide();
					return alert('문서 수정 실패[1] - 시스템 담당자에게 문의하세요');
				}
			},
			error: function(a,b,c){
				//console.log(a,b,c);
				$('#lab_loading').hide();
				return alert('문서 수정 실패[2] - 시스템 담당자에게 문의하세요');
			}
		});
	}
	
	function getPostData2(){
		var postData = {};
		
		var makeProcess = $('textarea[name=makeProcess]').val()
		
		pNo = '${pNo}';
		pdNo = '${pdNo}'
		
		postData['pNo']= pNo;
		postData['pdNo']= pdNo;
		postData['makeProcess'] = makeProcess;
		postData['yieldRate'] = $('input[name=yieldRate]').val();
		postData['productPrice'] = $('input[name=productPrice]').val();
		postData['plantPrice'] = $('input[name=rawPriceRate]').val();
		postData['volume'] = $('input[name=volume]').val();
		postData['memo'] = $('input[name=memo]').val();
		
		sumWeight = 0;
		$('input[name=divWeight]').toArray().forEach(function(divWeightElement){
			sumWeight += Number($(divWeightElement).val());
		});
		postData['sumMixWeight'] = isNaN(sumWeight) ? 0 : sumWeight ;
		
		$('div[name=subProdDiv]').toArray().forEach(function(subProd, subProdNdx){
			// 부속제품 대표정보
			subProdHeadTbody = $(subProd).children('div:first').children('table').children('tbody');
			
			postData['sub['+subProdNdx+'].subProdName'] = $('input[name=subProdName]')[subProdNdx].value
			postData['sub['+subProdNdx+'].subProdDesc'] = subProdHeadTbody.children('tr').children('td').children('input[name=subProdDesc]').val();
			
			// 부속제품 원료부분
			var mixDiv = $(subProd).children('div:last').children('div:nth-child(2)').children('div.nomal_mix');
			var contDiv = $(subProd).children('div:last').children('div:nth-child(4)').children('div.nomal_mix');
			
			// 배합(table)
			mixDiv.toArray().forEach(function(mix, mixNdx){
				var path = 'sub['+subProdNdx+'].subMix['+mixNdx+'].';
				
				mixHead = $(mix).children('div');
				mixBody = $(mix).children('table');
				
				postData[path+'itemType'] = mixHead.children('input[name=baseType]').val();
				postData[path+'name'] = mixHead.children('span.title').children('input[name=baseName]').val();
				postData[path+'weight'] = mixHead.children('span.title').children('input[name=divWeight]').val();
				
				mixBody.children('tbody').children('tr').toArray().forEach(function(item, itemNdx){
        			
					var propPath = 'sub['+subProdNdx+'].subMix['+mixNdx+'].subMixItem['+itemNdx+'].';
					setPostItem(postData, propPath, item, itemNdx);
				})
				var baseBakerySum = mixBody.children('tfoot').children('tr').children('td').children('input[name=bomRateTotal]').val();
				var baseBomRateSum = mixBody.children('tfoot').children('tr').children('td').children('input[name=bomAmountTotal]').val();
				
				postData[path+'baseBakerySum'] = baseBakerySum;
				postData[path+'baseBomRateSum'] = baseBomRateSum;
			})
			
			//내용물(table)
			contDiv.toArray().forEach(function(cont, contNdx){
				var contPath = 'sub['+subProdNdx+'].subContent['+contNdx+'].';
				
				contHead = $(cont).children('div');
				contBody = $(cont).children('table');
				
				postData[contPath+'itemType'] = contHead.children('input[name=baseType]').val();
				postData[contPath+'name'] = contHead.children('span.title').children('input[name=baseName]').val();
				postData[contPath+'weight'] = contHead.children('span.title').children('input[name=divWeight]').val();
				postData[contPath+'divWeightTxt'] = contHead.children('span.title').children('input[name=divWeightTxt]').val();
				
				contBody.children('tbody').children('tr').toArray().forEach(function(item, itemNdx){
					var propPath = 'sub['+subProdNdx+'].subContent['+contNdx+'].subContentItem['+itemNdx+'].';
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
			var pkgPath = 'pkg['+pkgNdx+'].';
			setPostItem(postData, pkgPath, pkg, pkgNdx)
		})
		
		// 생산소모품
		$('tbody[name=consumeTbody]').children('tr').toArray().forEach(function(cons, consNdx){
			var consPath = 'cons['+consNdx+'].'
			setPostItem(postData, consPath, cons, consNdx)
		});
		
		return postData;
	}
	
	function setPostItem(postData, propPath, item, itemNdx){
		postData[propPath+'itemImNo'] = $(item).children('td').children('input[name=itemImNo]').val();
		postData[propPath+'itemSapCode'] = $(item).children('td').children('input[name=itemSapCode]').val();
		postData[propPath+'itemInnerType'] = $(item).children('td').children('input[name=itemInnerType]').val();
		postData[propPath+'itemName'] = $(item).children('td').children('input[name=itemName]').val();
		postData[propPath+'mixingRatio'] = $(item).children('td').children('input[name=mixingRatio]').val();
		postData[propPath+'itemUnitPrice'] = $(item).children('td').children('input[name=itemUnitPrice]').val();
		postData[propPath+'itemUnit'] = $(item).children('td').children('input[name=itemUnit]').val();
		postData[propPath+'itemCustomPrice'] = $(item).children('td').children('input[name=itemCustomPrice]').val();
		postData[propPath+'itemProportion'] = $(item).children('td').children('input[name=itemProportion]').val();
		
		return postData;
	}
	
	function getPostData(){
		var postData = {};
		
		var formRootArr = $('#productDesignItemForm').children('div').toArray();
		var makeProcess = $('#productDesignItemForm').children('textarea').val()
		
		pNo = '${pNo}';
		pdNo = '${pdNo}';
		postData['pNo']= pNo;
		postData['pdNo']= pdNo;
		postData['makeProcess'] = makeProcess;
		postData['sumMixWeight'] = $('input[name=productWeight]').val()
		postData['productPrice'] = $('input[name=productPrice]').val();
		postData['plantPrice'] = $('input[name=plantPrice]').val();
		postData['memo'] = $('input[name=memo]').val();
		
		formRootArr.forEach(function(docDetail, detail_ndx){
			var subIndex = 0;
			var pkgIndex = 0;
		    if(detail_ndx+1 != formRootArr.length){
		    	var sub = docDetail;
		        // sub
		        postData['sub['+detail_ndx+'].subProdName'] = $(sub).children('input[name=subProdName]').val();
		        postData['sub['+detail_ndx+'].subProdDesc'] = $(sub).children('textarea[name=subProdDesc]').val();
		        
		        $(sub).children('div').toArray().forEach(function(subElement, ndx_subProd){
		        	if(ndx_subProd == 0){
		        		// subMix
		        		var subMixElement = subElement;
		        		
		        		$(subMixElement).children('div:last').children().children('table').toArray().forEach(function(subMix, subMixIndex){
		        			postData['sub['+detail_ndx+'].subMix['+subMixIndex+'].name'] = $(subMix).prev().children('span.title').children('input[name$=Name]').val();
		        			postData['sub['+detail_ndx+'].subMix['+subMixIndex+'].weight'] = $(subMix).prev().children('span.title').children('input[name$=Weight]').val();
		        			
		        			
		        			$(subMix).children('tbody').children('tr').toArray().forEach(function(mixItem, itemIndex){
		        				
		        				var itemSapCode = $(mixItem).children('td').children('input[name$=itemSapCode]').val();
		        				var itemName = $(mixItem).children('td').children('input[name$=itemName]').val();
		        				var itemUnitPrice = $(mixItem).children('td').children('input[name$=itemUnitPrice]').val();
		        				var mixingRatio = $(mixItem).children('td').children('input[name$=mixNumber]').val();
		        				
		        				postData['sub['+detail_ndx+'].subMix['+subMixIndex+'].subMixItem['+itemIndex+'].itemSapCode'] = itemSapCode
		        				postData['sub['+detail_ndx+'].subMix['+subMixIndex+'].subMixItem['+itemIndex+'].itemName'] = itemName
		        				postData['sub['+detail_ndx+'].subMix['+subMixIndex+'].subMixItem['+itemIndex+'].itemUnitPrice'] = itemUnitPrice
		        				postData['sub['+detail_ndx+'].subMix['+subMixIndex+'].subMixItem['+itemIndex+'].mixingRatio'] = mixingRatio
		        			})
		        		});
		        	} else {
		        		// subContent
		        		var subContentElement = subElement;
		        		
		        		$(subContentElement).children('div:last').children().children('table').toArray().forEach(function(subContent, subContentIndex){
		        			postData['sub['+detail_ndx+'].subContent['+subContentIndex+'].name'] = $(subContent).prev().children('span.title').children('input[name$=Name]').val();
		        			postData['sub['+detail_ndx+'].subContent['+subContentIndex+'].weight'] = $(subContent).prev().children('span.title').children('input[name$=Weight]').val();
		        			
		        			$(subContent).children('tbody').children('tr').toArray().forEach(function(contentItem, contentIndex){
		        				var itemSapCode = $(contentItem).children('td').children('input[name$=itemSapCode]').val();
		        				var itemName = $(contentItem).children('td').children('input[name$=itemName]').val();
		        				var itemUnitPrice = $(contentItem).children('td').children('input[name$=itemUnitPrice]').val();
		        				var mixingRatio = $(contentItem).children('td').children('input[name$=mixNumber]').val();
		        				
		        				postData['sub['+detail_ndx+'].subContent['+subContentIndex+'].subContentItem['+contentIndex+'].itemSapCode'] = itemSapCode;
		        				postData['sub['+detail_ndx+'].subContent['+subContentIndex+'].subContentItem['+contentIndex+'].itemName'] = itemName;
		        				postData['sub['+detail_ndx+'].subContent['+subContentIndex+'].subContentItem['+contentIndex+'].itemUnitPrice'] = itemUnitPrice;
		        				postData['sub['+detail_ndx+'].subContent['+subContentIndex+'].subContentItem['+contentIndex+'].mixingRatio'] = mixingRatio;
		        				
		        			})
		        		})
		        	}
		        })
		        
		        subIndex++;
		    } else {
		    	// pkg
		    	var pkg = docDetail;
		    	var pkgRow = $(pkg).children('div').children('div:last').children('table').children('tbody').children('tr');
		    	$(pkgRow).toArray().forEach(function(pkgItem, pkgItemIndex){
		    		var itemSapCode = $(pkgItem).children('td').children('input[name$=itemSapCode]').val();
		    		var itemName = $(pkgItem).children('td').children('input[name$=itemName]').val();
		    		var itemUnitPrice = $(pkgItem).children('td').children('input[name$=itemUnitPrice]').val();
		    		
		    		postData['pkg['+pkgItemIndex+'].itemSapCode'] = itemSapCode;
		    		postData['pkg['+pkgItemIndex+'].itemName'] = itemName;
		    		postData['pkg['+pkgItemIndex+'].itemUnitPrice'] = itemUnitPrice;
		    	});
		    	
		    	pkgIndex++;
		    }
		})
		
		return postData;
	}
	
	//숫자 + 도트만  입력 가능
	function clearNoNum(obj){
		var needToSet = false;
		var numStr = obj.value;
		var temps = numStr.split("."); //소수점 체크를 위해 입력값을 '.'을 기준으로 나누고 temps는 배열이됨
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
			alert("입력은 숫자와 소수점 만 가능 합니다.");
			//('.')
			needToSet = true;
		} 
		if ((/^\./g).test(numStr)){ //첫번째가 '.' 이면 .를 삭제
			numStr = numStr.replace(/^\./g, "");
			alert("소수점이 첫 글자이면 안됩니다.");
			needToSet = true;
		}
		if(needToSet) { //변경이 필요할 경우에만 셋팅함.
			obj.value = numStr;
		}
	}
	
	function calTableItemCost(element){
		clearNoNum(element);
		var row = $(element).parent().parent();
		var tbodyId = row.parent()[0].id;
		
		// 각 열에 대한 배합비*(단가or입력단가) 금액 계산
		var unitCost = Number(row.children('td[name$=UnitCost]').children('input').val());
		var customUnitCost =  Number(row.children('td[name$=CustomUnitCost]').children('input').val());
		var mixRate = Number(row.children('td[name$=MixRate]').children('input').val());
		
		if(tbodyId.startsWith('package')){
			row.children('td[name$=tdRowCost]').children('input').val(unitCost);
			row.children('td[name$=tdRowCost]').children('input').val(unitCost);
		} else {
			if(customUnitCost){
				row.children('td[name$=tdRowCost]').children('input').val(customUnitCost*mixRate);
			} else {
				row.children('td[name$=tdRowCost]').children('input').val(unitCost*mixRate);
			}
		}
		
		
		// 배합, 내용물, 재료 테이블의 변화에 따른 각 테이블별 합계 계산
		var tFoot = $(element).parent().parent().parent().parent().children('tfoot')
		var tableWeightTotal = Number($(element).parent().parent().parent().parent().parent().children('div:first').children('span.title').children('input[name$=Weight]').val());
		var tableMixRateTotal = 0;
		var tableTotal = 0;
		
		row.parent().children().toArray().forEach(function(tr){
			tableMixRateTotal += Number($(tr).children('td[name$=MixRate]').children('input[name$=mixNumber]').val());
			tableTotal += Number($(tr).children('td[name$=RowCost]').children('input[name$=itemCalculatedPrice]').val());
		});
		
		var tableUnitTotal = Math.round(tableTotal/tableMixRateTotal, 2);
		
		if(tbodyId.startsWith('package')){
			tFoot.children('tr[name$=Unit]').children('td[name=tdTableUnitPrice]').children('div').text(tableTotal);
			tFoot.children('tr[name$=Unit]').children('td[name=tdTableUnitPrice]').children('input').val(tableTotal);
			tFoot.children('tr[name$=Total]').children('td[name=tdTableTotalPrice]').children('div').text(tableTotal);
			tFoot.children('tr[name$=Total]').children('td[name=tdTableTotalPrice]').children('input').val(tableTotal);
		} else {
			if(mixRate > 0) {
				tFoot.children('tr[name$=Unit]').children('td[name=tdTableUnitPrice]').children('div').text(tableUnitTotal);
				tFoot.children('tr[name$=Unit]').children('td[name=tdTableUnitPrice]').children('input').val(tableUnitTotal);
				tFoot.children('tr[name$=Total]').children('td[name=tdTableTotalPrice]').children('div').text(tableUnitTotal*tableWeightTotal/1000);
				tFoot.children('tr[name$=Total]').children('td[name=tdTableTotalPrice]').children('input').val(tableUnitTotal*tableWeightTotal/1000);
			}
		}
	}
	
	function nvl(value){
		if(value == null || value == undefined){
			return 0;
		} else {
			return value;
		}
	}
	
	function isWater(element){
		if($(element).parent().parent().children('td').children('input[name=itemSapCode]').val() == 'P10001'){
			return true;
		} else {
			return false;
		}
	}
	
	/* function calcRow(element){
		clearNoNum(element)
		
		var tr = $(element).parent().parent();
		var mixingRatio = tr.children('td')
		
		var mixingRatio = Number(tr.children('td').children('input[name=mixingRatio]').val());
		var unitPrice = Number(tr.children('td').children('input[name=itemUnitPrice]').val());
		
		tr.children('td').children('input[name=itemCustomPrice]').val(mixingRatio * unitPrice)
		calcRowsProportion(tr[0]);
	}
	
	function calcRowsProportion(tr){
		var totalMixingRatio = 0;
		var totalWaterRatio = 0;
		$('input[name=mixingRatio]').toArray().forEach(function(element){
			totalMixingRatio += Number(element.value);
			if(isWater(element)){
				totalWaterRatio += Number(element.value);
			}
			
		})
		
		var tableMixingRatio = 0;
		var tablePrice = 0;
		var tableProportion = 0;
		
		var tBody = $(tr).parent();
		tBody.children().toArray().forEach(function(trElement){
			var tr = $(trElement);
			var mixingRatio = Number(tr.children('td').children('input[name=mixingRatio]').val());
			var itemProportion = (mixingRatio / (totalMixingRatio - totalWaterRatio) * 100).toFixed(3);
			tr.children('td').children('input[name=itemProportion]').val(itemProportion);
		})
		
		var tFoot = tBody.next();
		tFoot.children('tr').children('td').toArray().forEach(function(tdElement, ndx){
			if(ndx == 1) $(tdElement).children('input').val()
		})
	}
	 */
	
	//반올림 처리
	function round(n, digits) {
	  if (digits >= 0) return parseFloat(Number(n).toFixed(digits)); // 소수부 반올림
	  digits = Math.pow(10, digits); // 정수부 반올림
	  var t = Math.round(n * digits) / digits;
	  return parseFloat(t.toFixed(0));
	}
 	
	function calcBaseTable(e){
		if(e != undefined){
			clearNoNum(e.target)
		}
		
		$('div[name=subProdDiv]').toArray().forEach(function(subProd, subProdNdx){
			var subProdName = $('input[name=subProdName]')[subProdNdx].value;
			
			
			var mixDiv = $(subProd).children('div:last').children('div:nth-child(2)').children('div.nomal_mix');
			var contDiv = $(subProd).children('div:last').children('div:nth-child(4)').children('div.nomal_mix');
			
			mixDiv.toArray().forEach(function(mix, mixNdx){
				mixHead = $(mix).children('div');
				mixBody = $(mix).children('table');
				
				var baseName = mixHead.children('span.title').children('input[name=baseName]').val();
				var divWeight = mixHead.children('span.title').children('input[name=divWeight]').val();
				
				var sumMixingRatio = 0;
				var sumWaterRatio = 0;
				var sumPrice = 0;
				var sumProportion = 0;
				
				// 단가계산
				mixBody.children('tbody').children('tr').toArray().forEach(function(item, itemNdx){
					var itemSapCode = $(item).children('td').children('input[name=itemSapCode]').val()
					var mixingRatio = Number($(item).children('td').children('input[name=mixingRatio]').val());
					var itemUnitPrice = Number($(item).children('td').children('input[name=itemUnitPrice]').val());
					
					$(item).children('td').children('input[name=itemCustomPrice]').val(round(mixingRatio*itemUnitPrice,3));
				})
				
				// 비급수 비율 계산을 위한 합계데이터 계산
				mixBody.children('tbody').children('tr').toArray().forEach(function(item, itemNdx){
					sumMixingRatio += Number($(item).children('td').children('input[name=mixingRatio]').val());
					sumPrice += Number($(item).children('td').children('input[name=itemCustomPrice]').val());
					
					if($(item).children('td').children('input[name=itemSapCode]').val() == 'P10001'){
						sumWaterRatio += Number($(item).children('td').children('input[name=mixingRatio]').val());
					}
				})
				
				// 비급수 비율 계산 및 총 비율 계산
				mixBody.children('tbody').children('tr').toArray().forEach(function(item, itemNdx){
					var itemSapCode = $(item).children('td').children('input[name=itemSapCode]').val()
					var mixingRatio = Number($(item).children('td').children('input[name=mixingRatio]').val());
					var itemProportion;
					
					if(itemSapCode != 'P10001'){
						itemProportion = round((mixingRatio/(sumMixingRatio-sumWaterRatio)*100), 3);
					} else {
						itemProportion = 0;
					}
					
					itemProportion = isNaN(itemProportion) ? 0 : itemProportion;
					$(item).children('td').children('input[name=itemProportion]').val(itemProportion);
					
					sumProportion += Number(itemProportion);
				})
				
				mixFoot = mixBody.children('tfoot');
				mixFoot.children('tr').children('td').toArray().forEach(function(td, ndx){
					if(ndx == 1){
						$(td).children('input').val(round(sumMixingRatio,2))
						$(td).children('span').text(round(sumMixingRatio,2))
					}
					if(ndx == 4){
						$(td).children('input').val(round(sumPrice,0))
						$(td).children('span').text(round(sumPrice,0))
					}
					if(ndx == 5){
						$(td).children('input').val(round(sumProportion,0))
						$(td).children('span').text(round(sumProportion,0))
					}
				})
			})
			
			contDiv.toArray().forEach(function(cont, contNdx){
				contHead = $(cont).children('div');
				contBody = $(cont).children('table');
				
				var baseName = contHead.children('span.title').children('input[name=baseName]').val();
				var divWeight = contHead.children('span.title').children('input[name=divWeight]').val();
				
				var sumMixingRatio = 0;
				var sumWaterRatio = 0;
				var sumPrice = 0;
				var sumProportion = 0;
				
				// 단가계산
				contBody.children('tbody').children('tr').toArray().forEach(function(item, itemNdx){
					var itemSapCode = $(item).children('td').children('input[name=itemSapCode]').val()
					var mixingRatio = Number($(item).children('td').children('input[name=mixingRatio]').val());
					var itemUnitPrice = Number($(item).children('td').children('input[name=itemUnitPrice]').val());
					
					$(item).children('td').children('input[name=itemCustomPrice]').val(round(mixingRatio*itemUnitPrice,3));
				})
				
				// 비급수 비율 계산을 위한 합계데이터 계산
				contBody.children('tbody').children('tr').toArray().forEach(function(item, itemNdx){
					sumMixingRatio += Number($(item).children('td').children('input[name=mixingRatio]').val());
					sumPrice += Number($(item).children('td').children('input[name=itemCustomPrice]').val());
					
					if($(item).children('td').children('input[name=itemSapCode]').val() == 'P10001'){
						sumWaterRatio += Number($(item).children('td').children('input[name=mixingRatio]').val());
					}
				})
				
				// 비급수 비율 계산 및 총 비율 계산
				contBody.children('tbody').children('tr').toArray().forEach(function(item, itemNdx){
					var itemSapCode = $(item).children('td').children('input[name=itemSapCode]').val()
					var mixingRatio = Number($(item).children('td').children('input[name=mixingRatio]').val());
					var itemProportion;
					
					if(itemSapCode != 'P10001'){
						itemProportion = round((mixingRatio/(sumMixingRatio-sumWaterRatio)*100),3);
					} else {
						itemProportion = 0;
					}
					
					itemProportion = isNaN(itemProportion) ? 0 : itemProportion;
					$(item).children('td').children('input[name=itemProportion]').val(itemProportion);
					
					sumProportion += Number(itemProportion);
				})
				
				contFoot = contBody.children('tfoot');
				contFoot.children('tr').children('td').toArray().forEach(function(td, ndx){
					if(ndx == 1){
						$(td).children('input').val(round(sumMixingRatio,2))
						$(td).children('span').text(round(sumMixingRatio,2))
					}
					if(ndx == 4){
						$(td).children('input').val(round(sumPrice,0))
						$(td).children('span').text(round(sumPrice,0))
					}
					if(ndx == 5){
						$(td).children('input').val(round(sumProportion,0))
						$(td).children('span').text(round(sumProportion,0))
					}
				})
			})
		})
	}
	
	function calcTableFooter(element){
		var table = $(element).parent().parent().next();
		var rowCnt = table.children('tbody').children('tr').length;
		
		if(rowCnt > 0){
			table.children('tbody').children('tr:first').children('td').children('input[name=mixingRatio]').keyup();
		} else {
			table.children('tfoot').children('tr').children('td').children('input[name=mixingRatioTotal]').val(0);
			table.children('tfoot').children('tr').children('td').children('input[name=priceTotal]').val(0);
			table.children('tfoot').children('tr').children('td').children('input[name=proportionTotal]').val(0); 
		}
	}
	
	function calcPkgTable(){
		var pkgPriceTotal = 0;
		$('#packageTable').children('tbody').children('tr').toArray().forEach(function(trElement){
			pkgPriceTotal += Number($(trElement).children('td').children('input[name=itemUnitPrice]').val());
		})
		$('#packageTable').children('tfoot').children('tr').children('td:last').text(round(pkgPriceTotal,3))
		
		//calcTotalTable()
	}
	
	function calcTotalTable(){
		if($('input[name=productPrice]').val().length <= 0){
			$('input[name=productPrice]').focus()
			alert('소매가격을 입력해주세요');
			return;
		}
		
		if($('input[name=volume]').val().length <= 0){
			$('input[name=volume]').focus()
			alert('들이수를 입력해주세요');
			return;
		}
		
		if($('input[name=rawPriceRate]').val().length <= 0){
			$('input[name=rawPriceRate]').focus()
			alert('원가비율을 입력해주세요');
			return;
		}
		
		if($('input[name=yieldRate]').val().length <= 0){
			$('input[name=yieldRate]').focus()
			alert('수율을 입력해주세요');
			return;
		}
		
		var retailPrice = Number($('input[name=productPrice]').val());
		var yieldRate = Number($('input[name=yieldRate]').val())/100;
		var rawPriceRate = Number($('input[name=rawPriceRate]').val())/100;
		var combineTable = $('#combineTable');
		var combineBody = combineTable.children('tBody');
		var combineFoot = combineTable.children('tFoot');
		combineBody.empty();
		combineFoot.empty();
		
		$('div[name=subProdDiv]').toArray().forEach(function(subProd, subProdNdx){
			var tabId = subProd.id.split('_')[1];
			var subProdName = $('#subProdAddBtn_'+tabId).children('input[name=subProdName]').val();
			
			var mixDiv = $(subProd).children('div:last').children('div:nth-child(2)').children('div.nomal_mix');
			var contDiv = $(subProd).children('div:last').children('div:nth-child(4)').children('div.nomal_mix');
			
			mixDiv.toArray().forEach(function(mix, mixNdx){
				mixHead = $(mix).children('div');
				mixBody = $(mix).children('table');
				
				mixFoot = mixBody.children('tfoot');
				
				var baseName = mixHead.children('span.title').children('input[name=baseName]').val();
				var divWeight = Number(mixHead.children('span.title').children('input[name=divWeight]').val());
				
				var mixingRatioTotal = Number(mixFoot.children('tr:first').children('td').children('input[name=mixingRatioTotal]').val());
				var priceTotal = Number(mixFoot.children('tr:first').children('td').children('input[name=priceTotal]').val());
				var proportionTotal = Number(mixFoot.children('tr:first').children('td').children('input[name=proportionTotal]').val());
				var unitPrice = isNaN(priceTotal/mixingRatioTotal) ? '-' : priceTotal/mixingRatioTotal;
				unitPrice = isNaN(unitPrice) ? unitPrice : round(unitPrice,3);
				
				var combineTr;
				combineTr += '<tr>';
				combineTr += '<td>'+subProdName+'</td>';
				combineTr += '<td>'+'배합'+'</td>';
				combineTr += '<td>'+baseName+'</td>';
				combineTr += '<td>'+unitPrice+'</td>';
				combineTr += '<td>'+divWeight+'</td>';
				if(isNaN(unitPrice)){
					combineTr += '<td>'+unitPrice+'</td>';
				} else {
					combineTr += '<td>'+round((unitPrice/1000*divWeight*yieldRate),3)+'</td>';
				}
				combineTr += '</tr>';
				
				combineBody.append(combineTr);
			})
			
			contDiv.toArray().forEach(function(cont, contNdx){
				contHead = $(cont).children('div');
				contBody = $(cont).children('table');
				
				contFoot = contBody.children('tfoot');
				
				var baseName = contHead.children('span.title').children('input[name=baseName]').val();
				var divWeight = Number(contHead.children('span.title').children('input[name=divWeight]').val());
				
				var mixingRatioTotal = Number(contFoot.children('tr:first').children('td').children('input[name=mixingRatioTotal]').val());
				var priceTotal = Number(contFoot.children('tr:first').children('td').children('input[name=priceTotal]').val());
				var proportionTotal = Number(contFoot.children('tr:first').children('td').children('input[name=proportionTotal]').val());
				var unitPrice = isNaN(priceTotal/mixingRatioTotal) ? '-' : priceTotal/mixingRatioTotal;
				unitPrice = isNaN(unitPrice) ? unitPrice : round(unitPrice,3);
				
				var combineTr;
				combineTr += '<tr>';
				combineTr += '<td>'+subProdName+'</td>';
				combineTr += '<td>'+'배합'+'</td>';
				combineTr += '<td>'+baseName+'</td>';
				combineTr += '<td>'+unitPrice+'</td>';
				combineTr += '<td>'+divWeight+'</td>';
				if(isNaN(unitPrice)){
					combineTr += '<td>'+unitPrice+'</td>';
				} else {
					combineTr += '<td>'+round((unitPrice/1000*divWeight*yieldRate),3)+'</td>';
				}
				combineTr += '</tr>';
				
				combineBody.append(combineTr);
			})
		})
		
		var packagePriceTotal = 0;
		$('#packageTable').children('tbody').children('tr').toArray().forEach(function(packageRow){
			packagePriceTotal += Number($(packageRow).children('td').children('input[name=itemUnitPrice]').val());
		})
		
		var combineData = {
			'total': {sumRawPrice: 0, weight: 0},
			'component': {sumRawPrice: 0},
			'package': {sumRawPrice: packagePriceTotal}
		};
		
		combineBody.children('tr').toArray().forEach(function(trElement, i, arr){
			var subProdName = $(trElement).children('td:nth-child(1)').text(); // 구분
			var type = $(trElement).children('td:nth-child(2)').text(); // 부속제품명
			var baseName = $(trElement).children('td:nth-child(3)').text(); // 원료명
			var unitPrice = Number($(trElement).children('td:nth-child(4)').text()); // 단가
			var divWeight = Number($(trElement).children('td:nth-child(5)').text()); // 분할중량
			var rawPrice = Number($(trElement).children('td:nth-child(6)').text()); // 원가
			
			combineData['total'].sumRawPrice += rawPrice;
			combineData['total'].weight += divWeight;
			
			
			if(type == '배합' || type == '내용물'){
				combineData['component'].sumRawPrice += rawPrice;
			}
			 
			var subProdName = $(trElement).children('td:nth-child(2)').text();
		})

		var productTotalPrie = combineData['total'].sumRawPrice + packagePriceTotal;
		
		var totalRate = round((combineData['total'].sumRawPrice/(retailPrice*rawPriceRate)*100),2);
		var componentRate = round((combineData['component'].sumRawPrice/(retailPrice*rawPriceRate)*100),2);
		var packageRate = round((combineData['package'].sumRawPrice/retailPrice*rawPriceRate*100),2);
		var productRateTotal = 0;
		totalRate = isNaN(totalRate) ? '-' : totalRate;
		componentRate = isNaN(componentRate) ? '-' : componentRate;
		packageRate = isNaN(packageRate) ? '-' : packageRate;
		productRateTotal= Number(componentRate) + Number(packageRate);
		productRateTotal = isNaN(productRateTotal) ? '-' : productRateTotal;
		combineData['total'].sumRawPrice = combineData.total.sumRawPrice
		combineData['component'].sumRawPrice = combineData['component'].sumRawPrice
		combineData['package'].sumRawPrice = combineData['package'].sumRawPrice
		
		var resultRawPrice = isNaN(combineData.total.sumRawPrice) ? '-' : combineData.total.sumRawPrice;
		productTotalPrie = isNaN(productTotalPrie) ? '-' : productTotalPrie;
		productTotalPrie = isNaN(productTotalPrie) ? productTotalPrie : round(productTotalPrie,3);
		
		var combineFootTr;
		combineFootTr += '<tr><td colspan="3">합계</td><td>원료</td><td>'+combineData.total.weight+'</td><td>'+resultRawPrice+' ('+totalRate+'%)</td></tr>'
		combineFootTr += '<tr><td colspan="3"></td><td>재료</td><td></td><td>'+combineData['package'].sumRawPrice+' ('+packageRate+'%)</td></tr>'
		combineFootTr += '<tr><td colspan="3"></td><td>총 가격</td><td></td><td>'+ productTotalPrie +' ('+ productRateTotal +'%)</td></tr>'
		combineFootTr += '<tr><td colspan="2"></td><td></td><td>소매가격</td><td></td><td>'+ retailPrice +'</td></tr>'
		combineFootTr += '<tr><td colspan="2"></td><td></td><td>출하가</td><td>'+round((rawPriceRate*100),2)+' %</td><td>'+ round(retailPrice*rawPriceRate,3) +'</td></tr>'
		combineFoot.append(combineFootTr);
	}
	
	function changeImageFile(element, e){
		var reader = new FileReader();

		reader.onload = function (e) {
			//document.getElementById("fileImage").src = e.target.result;
			document.getElementById("preview").src = e.target.result;
		};
		reader.readAsDataURL(element.files[0]);
	}
	
	function deleteImageFile(){
		document.getElementById("preview").src = '/resources/images/img_noimg3.png';
		$('#fileImageInput').val('');
	}
	
	function clearForm(){
		// 기본정보
		$('input[name=productPrice]').val('');
		$('input[name=volume]').val('');
		$('input[name=rawPriceRate]').val('');
		$('input[name=yieldRate]').val('');
		$('input[name=memo]').val('');
		// TODO 이미지파일 관련
		$('textarea[name=makeProcess]').val('');
		
		// 부속제품 모두 제거 및 1개 생성 (배합, 내용물이 모두 지워짐)
		$('div[name=subProdDiv]').toArray().forEach(function(element){$(element).remove()})
		$('a[id^=subProdAddBtn]').toArray().forEach(function(element){$(element).remove()})
		$('div.tab03').children('ul').children('a:last').children('li').click();
		
		// 재료
		$('#packageTable').children('tbody').empty();
		
		// 원재료비
		$('#combineTable').children('tbody').empty();
		$('#combineTable').children('tfoot').empty();
	}
	
	function fileDivClick(e){
		e.stopPropagation();
		$(e.target).children('input').click();
	}
	
	function checkMaterail(e, type, sapCode){
		if(e.keyCode != 13){
			return;
		}
		var element = e.target
		
		var userSapCode = e.target.value;
		var rowId = $(element).parent().parent().attr('id');
		var plant = '${designDocInfo.plant}';
		var company = '${designDocInfo.companyCode}';
		
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
				//if(false){
				if(materailList.length == 1){
					//pop
					var item = materailList[0];
					$('#'+rowId+' input[name=itemSapCode]').val(item.sapCode);
					$('#'+rowId+' input[name=itemImNo]').val(item.imNo);
					$('#'+rowId+' input[name=itemName]').val(item.name);
					$('#'+rowId+' input[name=itemUnitPrice]').val(item.price);
					$('#'+rowId+' input[name=itemUnit]').val(item.unit);
					$('#'+rowId+' input[name=itemOrgUnit]').val(item.unit);
					
					if(item.name.indexOf('[임시]') >= 0 || item.isSample == 'Y'){
						$('#'+rowId).css('background-color', '#ffdb8c');
					} else {
						$('#'+rowId).css('background-color', '#fff');
					}
					
					$('#'+rowId+' input[name=mixingRatio]').keyup();
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
				plant: '${designDocInfo.plant}',
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
					row += '<Td>'+item.regDate+'</Td>';
					row += '<Td>'+item.supplyDate+'</Td>';
					row += '<Td>'+item.supplyCompany+'</Td>';
					
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
				alert('자재검색 실패[2] - 시스템 담당자에게 문의하세요');
			},
			complete: function(){
				$('#lab_loading').hide();
			}
		})
	}
	
	function closeMatRayer(){
		$('#searchMatValue').val('')
		$('#matLayerBody').empty();
		$('#matLayerBody').append('<tr><td colspan="9">원료코드 혹은 원료코드명을 검색해주세요</td></tr>');
		$('#matCount').text(0);
		closeDialog('dialog_material')
	}
	
	/* function renewMaterial(){
		$('#lab_loading').show();
		
		var imNoArr = [];
		$('input[name=itemImNo]').toArray().forEach(function(inputImNo){
			var imNo = $(inputImNo).val();
			if(imNo.length > 0)
				imNoArr.push(imNo);
		})
		
		var errFlag = false;
		var updateCnt = 0;
		
		if(imNoArr.length <= 0){
			alert('입력된 화면 원료의 고유번호가 존재하지 않습니다');
			$('#lab_loading').hide();
			return;
		}
		
		$.ajax({
			url: '/design/getLatestMaterialList',
			type: 'post',
			dataType: 'json',
			traditional : true,
			data: {
				imNoArr: imNoArr
			},
			success: function(data){
				if(data){
					alert('운영서버의 데이터가 조회되었습니다');
					$('input[name=itemImNo]').toArray().forEach(function(inputImNo, i, arr){
						var imNo = $(inputImNo).val();
						
						data.forEach(function(mat){
							if(mat.imNo == imNo){
								var rowId = $(inputImNo).parent().parent().attr('id');
								
								$('#'+rowId + ' input[name=itemImNo]').val(mat.imNo)
								$('#'+rowId + ' input[name=itemSapCode]').val(mat.sapCode)
								$('#'+rowId + ' input[name=itemUnitPrice]').val(mat.price)
								$('#'+rowId + ' input[name=itemUnit]').val(mat.unit)
								$('#'+rowId + ' input[name=itemCustomPrice]').val(mat.price)
								
								$('#'+rowId + ' input[name=mixingRatio]').keyup();
								
								updateCnt++;
							}
						});
						if(i+1 == arr.length)
							matCallback(false)
					})
				}
			},
			error: function(a,b,c){
				//console.log(a,b,c)
				alert('원료정보 갱신 실패[2] - 시스템 담당자에게 문의하세요');
			},
			complete: function(){
				$('#lab_loading').hide();
			}
		})
	} */
	
	function renewMaterial(){
		$('#lab_loading').show();
		
		var totalSize = $('input[name=itemSapCode]').length;
		var count = 0;
		var errCount = 0;
		$('input[name=itemSapCode]').toArray().forEach(function(input){
			var userSapCode = $(input).val();
			var rowId = $(input).parent().parent().attr('id');
			var plant = '${designDocInfo.plant}';
			var company = '${designDocInfo.companyCode}';
			
			var rowCheckId = $(input).parent().siblings('td:first').children('input[type=checkbox]').attr('id');
			var type;
			if(rowCheckId.indexOf('mix_') >= 0 || rowCheckId.indexOf('content_') >= 0){
				type = 'B';
			} else {
				type = 'R'
			}
			count++;
			if(userSapCode.length > 0){
				$.ajax({
					url: '/data/checkMaterial',
					type: 'POST',
					dataType: 'json',
					async: false,
					data: {
						sapCode: userSapCode,
						plant: plant,
						type: '',
						company: company
					},
					success: function(data){
						var materailList = data;
						//if(false){
						if(materailList.length == 1){
							//pop
							var item = materailList[0];
							$('#'+rowId+' input[name=itemSapCode]').val(item.sapCode);
							$('#'+rowId+' input[name=itemImNo]').val(item.imNo);
							$('#'+rowId+' input[name=itemName]').val(item.name);
							$('#'+rowId+' input[name=itemUnitPrice]').val(item.price);
							$('#'+rowId+' input[name=itemUnit]').val(item.unit);
							$('#'+rowId+' input[name=itemOrgUnit]').val(item.unit);
							
							if(item.name.indexOf('[임시]') >= 0 || item.isSample == 'Y'){
								$('#'+rowId).css('background-color', '#ffdb8c');
							} else {
								$('#'+rowId).css('background-color', '#fff');
							}
							
							$('#'+rowId+' input[name=mixingRatio]').keyup();
						} else {
							$('#'+rowId).css('background-color', '#ffdb8c');
							//console.log('원재료가 존재하지 않거나 복수가 존재하여 pass');
							//console.log('원료(재료)['+userSapCode+']가 존재하지 않거나 중복되어 갱신이 불가능합니다.');
							errCount++;
						}
					},
					error: function(a,b,c){
						//console.log(a,b,c)
						//alert('갱신 실패[2] - 시스템 담당자에게 문의하세요.');
						errCount++;
					},
					complete: function(){
						
					}
				})
			}
		})
		if(totalSize == count){
			//console.log(count, errCount, totalSize)
			if(errCount > 0){
				alert('식별되지 않은 원료(재료)코드가 존재합니다 .');
			}
			$('#lab_loading').hide();
		}
	}
	
	function matCallback(errFlag){
		if(!errFlag){
			alert('모든 원료가 최신정보로 업데이트 되었습니다.');
			$('#lab_loading').hide();
			return;
		}
		else 
			return alert('원료정보 갱신 실패[1] - 시스템 담당자에게 문의하세요');
	}
	
	function calcPackagePrice(e){
		clearNoNum(e.target)
		
		var tr = $(e.target).parent().parent();
		var itemSapPrice = Number(tr.children('td').children('input[name=itemSapPrice]').val());
		var itemVolume = Number(tr.children('td').children('input[name=itemVolume]').val());
		var itemUnitPrice = Number(tr.children('td').children('input[name=itemUnitPrice]').val());
		
		tr.children('td').children('input[name=itemUnitPrice]').val( round((itemSapPrice*itemVolume),3) )
		calcPkgTable()
	}
	
	function bindDialogEnter(e){
		if(e.keyCode == 13)
			$(e.target).next().click();
	}
	
	function goDocDetail(){
		var pNo = '${designDocInfo.pNo}';
		
		var form = document.createElement('form');
		$('body').append(form);
		form.action = '/design/productDesignDocDetail';
		form.method = 'post';
		
		appendInput(form, 'pNo', pNo)
		
		$(form).submit();
	}
	
	function moveLeft(){
		var leftOffset = $('#subScroll')[0].scrollLeft;
		$('#subScroll')[0].scrollLeft = leftOffset-350
	}
	
	function moveRight(){
		var leftOffset = $('#subScroll')[0].scrollLeft;
		$('#subScroll')[0].scrollLeft = leftOffset+350
	}
	
	function changeSubProdName(e){
		$(e.target).hide();
		$(e.target).next().show();
		$(e.target).next().focus();
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
</script>
<div class="wrap_in" id="fixNextTag">
	<span class="path">
		설계서 신규작성&nbsp;&nbsp;
		<img src="/resources/images/icon_path.png" style="vertical-align: middle" />&nbsp;&nbsp;제품설계서&nbsp;&nbsp;
		<img src="/resources/images/icon_path.png" style="vertical-align: middle" />&nbsp;&nbsp;<a href="#none">SPC 삼립연구소</a>
	</span>
	<section class="type01">
		<h2 style="position:relative">
			<span class="title_s">Product Design Doc</span><span class="title">설계서 수정</span>
			<div class="top_btn_box">
				<ul>
					<li>
						<button class="btn_circle_save" onclick="updateDocDetail()">&nbsp;</button>
					</li>
				</ul>
			</div>
		</h2>
		<div class="group01 mt20">
			<div class="title5"><span class="txt">01. 제품명: '${designDocInfo.productName}'</span></div>
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
							<th style="border-left: none;">소매가격</th>
							<td><input type="text" name="productPrice" style="width: 30%;" class="req" onkeyup="clearNoNum(this)" value="${designDocDetail.productPrice}"/> ￦</td>
							<th style="border-left: none;">들이수</th>
							<td><input type="text" name="volume" style="width: 30%;" class="req" onkeyup="clearNoNum(this)" value="${designDocDetail.volume}"/> ea</td>
							<th style="border-left: none;">원가비율</th>
							<td><input type="text" name="rawPriceRate" style="width: 30%;" class="req" onkeyup="clearNoNum(this)" value="${designDocDetail.plantPrice}"/> %</td>
						</tr>
						<tr>
							<th style="border-left: none;">수율</th>
							<td><input type="text" name="yieldRate" style="width: 30%;" class="read_only" onkeyup="clearNoNum(this)" value="${designDocDetail.yieldRate}" readonly="readonly"/> %</td>
							<th style="border-left: none;">설명</th>
							<td colspan="3"><input type="text" name="memo" style="width: 100%;" class="req" value="${designDocDetail.memo}"/></td>
						</tr>
						<tr>
						</tr>
						<tr>
							<th style="border-left: none;" rowspan="3">이미지 파일</th>
							<td>
								
								<!-- <input id="fileImageInput" type="file" onchange="changeImageFile(this, event)" style="width: 100%;"> -->
								
								<p><img id="preview" src="/picture/${designDocDetail.imageFileName}" style="border:1px solid #e1e1e1; border-radius:5px; width:258px; height:193px;"></p>
								<p class="pt10">
									<div class="add_file2" style="width:100%" onclick="fileDivClick(event)">
										<input type="file" name="file" id="fileImageInput" accept="image/*" style="display:none;" onchange="changeImageFile(this, event)">
										<label for="fileImageInput" style="cursor: pointer;">이미지파일 등록 <img src="/resources/images/icon_add_file.png"></label>
									</div>	
								</p>
								<div style=" z-index:3; position:relative;right:-245px; top:-238px; width: 25px; height: 25px;">
									<a href="javascript:deleteImageFile()"><img src="/resources/images/btn_table_header01_del02.png"></a>
								</div>
							</td>
							<th style="border-left: none;" rowspan="3">제조공정</th>
							<td colspan="3" rowspan="3"><textarea name="makeProcess" class="req" style="width: 100%; height: 225px">${designDocDetail.makeProcess}</textarea></td>
						</tr>
						<%-- 
						<tr>
							<td rowspan="2"><img id="fileImage" width="100%" height="auto" src="/local_img/${designDocDetail.imageFileName}"></td>
						</tr>
						 --%>
					</tbody>
				</table>
			</div>
			<div class="title5" style="width: 80%; padding-top: 50px;">
				<span class="txt">02. 원료</span>
			</div>
			<div class="title5" style="width: 20%; padding-top: 50px; display: inline-block;">
				<button style="float: right;" class="btn_con_search" onclick="renewMaterial()"><img src="/resources/images/btn_icon_convert.png"> 원료 최신화</button>
			</div>
			<div class="_tab03" style="position: relative;">
				<div class="toLeft unselectable" onclick="moveLeft()"><span class="span_left">&lt;</span></div>
				<div style="display: inline-block; width:96%; margin-left:2%">
					<%-- <ul>
						<!-- 선택됬을경우는 탭 클래스에 select를 넣어주세요 -->
						<!-- 케이스는 적으나 탭이 길어져서 넘어갈 경우가 있습니다. 예외처리는 11월이후 해봅시다. -->
						<c:forEach items="${designDocDetail.sub}" var="sub" varStatus="subStatus">
							<c:set var="liClass" value="${subStatus.index == 0 ? 'select' : ''}"/>
							<a href="#none" id="subProdAddBtn_${subStatus.index}"><li class="${liClass}" onclick="changeTab(this)" style="z-index:0;">
								<input type="text" name="subProdName" style="width: 200px; z-index: 100" placeholder="부속제품명 입력" class="req" value="${sub.subProdName}"/>
								<button name="subProdDelBtn" class="tab_btn_del" onclick="removeSubProduct('${subStatus.index}')"><img src="/resources/images/btn_table_header01_del02.png"></button>
							</li></a>
						</c:forEach>
						<a href="#none"><li class="" onclick="addSubProduct(this)">
							<button class="tab_btn_add"><img src="/resources/images/btn_pop_add.png"> 부속제품추가</button>
						</li></a>
						
						<!-- 부속제품 추가시 -->
					</ul> --%>
					<ul id="subScroll" class="ul">
						<c:forEach items="${designDocDetail.sub}" var="sub" varStatus="subStatus">
						<c:set var="liClass" value="${subStatus.index == 0 ? 'select' : ''}"/>
						<li id="subProdAddBtn_${subStatus.index}" class="${liClass}" onclick="changeTab(this)">
							<span class="unselectable" ondblclick="changeSubProdName(event)">${sub.subProdName}</span>
							<input type="text" name="subProdName" onkeyup="subProdNameKeyup(event)" style="width: 180px;" placeholder="부속제품명 입력" class="" value="${sub.subProdName}" />
							<button name="subProdDelBtn" class="tab_btn_del" onclick="removeSubProduct('${subStatus.index}')"><img src="/resources/images/btn_table_header01_del02.png"></button>
						</li></c:forEach><li class="none" onclick="addSubProduct(this)">
							<span class="unselectable">&nbsp;</span>
							<button class="tab_btn_add"><img src="/resources/images/btn_pop_add.png"></button>
							<span class="unselectable">&nbsp;</span>
						</li>
					</ul>
				</div>
				<div class="toRight unselectable" onclick="moveRight()"><span class="span_left">&gt;</span></div>
			</div>
			
			<c:forEach items="${designDocDetail.sub}" var="sub" varStatus="subStatus">
				<c:set var="isVisible" value="${subStatus.index == 0 ? 'block' : 'none'}"/>
				<div id="subProdDiv_${subStatus.index}" name="subProdDiv">
					<div class="main_tbl">
						<table class="insert_proc01" style="border-top: none; border-right: 1px solid #d1d1d1">
							<colgroup>
								<col width="13%" />
								<col />
							</colgroup>
							<tbody>
								<tr>
									<th>부속제품 설명</th>
									<td><input type="text" name="subProdDesc" style="width: 100%;" class="req" value="${sub.subProdDesc}"/></td>
								</tr>
							</tbody>
						</table>
					</div>
					<div>
						<div class="tbl_in_title">▼ 배합비</div>
						<div class="tbl_in_con">
							<c:forEach items="${sub.subMix}" var="mix" varStatus="baseStatus">
								<div class="nomal_mix">
									<div class="table_header01">
										<input type="hidden" name="baseType" value="MI"/>
										<span class="table_order_btn"><button class="btn_up" onclick="moveUp(this)"></button><button class="btn_down" onclick="moveDown(this)"></button></span>
										<span class="title" style="width:50%">
											<img src="/resources/images/img_table_header.png">
											&nbsp;&nbsp;배합비명 : <input type="text" name="baseName" style="width: 200px" value="${mix.name}"/>
											&nbsp;분할중량 : <input type="text" name="divWeight" style="width: 50px" value="${mix.weight}" onkeyup="clearNoNum(this)"/> g
										</span>
										<span class="table_header_btn_box">
											<button class="btn_del_table_header" onclick="removeTable(this, 'mix')">배합 삭제</button>
											<button class="btn_add_tr" onclick="addRow(this, 'mix')"></button><button class="btn_del_tr" onclick="removeRow(this)"></button>
										</span>
									</div>
									<table class="tbl05">
										<colgroup>
											<col width="20">
											<col width="140">
											<col />
											<col width="10%">
											<col width="10%">
											<col width="5%">
											<col width="10%">
											<col width="10%">
										</colgroup>
										<thead>
											<tr>
												<th><input type="checkbox" id="mixTable_${subStatus.index}_${baseStatus.index}" onclick="checkAll(event)"><label for="mixTable_${subStatus.index}_${baseStatus.index}"><span></span></label></th>
												<th>원료코드</th>
												<th>원료명</th>
												<th>배합율</th>
												<th>단가</th>
												<th>단위</th>
												<th>가격</th>
												<th>비급수 비율(%)</th>
											</tr>
										</thead>
										<tbody>
											<c:forEach items="${mix.subMixItem}" var="item" varStatus="itemStatus">
												<Tr id="mixRow_${subStatus.index}_${baseStatus.index}_${itemStatus.index}" class="temp_color">
													<Td>
														<input type="checkbox" id="mix_${subStatus.index}_${baseStatus.index}_${itemStatus.index}"><label for="mix_${subStatus.index}_${baseStatus.index}_${itemStatus.index}"><span></span></label>
														<input type="hidden" name="itemType" value="MI"/>
													</Td>
													<Td>
														<input type="hidden" name="itemImNo" style="width: 100px" class="req code_tbl" value="${item.itemImNo}"/>
														<input type="text" name="itemSapCode" style="width: 100px" class="req code_tbl" value="${item.itemSapCode}" onkeyup="checkMaterail(event, 'B', '${item.itemSapCode}')"/>
														<button class="btn_code_search2" onclick="openMaterialPopup(this, 'B')"></button>
													</Td>
													<Td><input type="text" name="itemName" style="width: 85%" readonly="readonly" class="read_only" value="${item.itemName}"/><button class="btn_code_info2"></button></Td>
													<Td><input type="text" name="mixingRatio" style="width: 100%" class="req" onkeyup="calcBaseTable(event)" value="${item.mixingRatio}"/></Td>
													<Td><input type="text" name="itemUnitPrice" style="width: 100%" class="" onkeyup="calcBaseTable(event)" value="${item.itemUnitPrice}"/></Td>
													<Td><input type="text" name="itemUnit" style="width: 100%" class="readonly" readonly="readonly" value="${item.itemUnit}"/></Td>
													<Td><input type="text" name="itemCustomPrice" style="width: 100%" readonly="readonly" value="${item.itemCustomPrice*item.mixingRatio}"/></Td>
													<Td><input type="text" name="itemProportion" style="width: 100%" readonly="readonly" value=""/></Td>
												</Tr>
											</c:forEach>
										</tbody>
										<tfoot>
											<Tr>
												<Td colspan="3">합계</Td>
												<Td><input type="hidden" name="mixingRatioTotal"/><span>0</span></Td>
												<Td> - </Td>
												<Td> - </Td>
												<Td><input type="hidden" name="priceTotal"/><span>0</span></Td>
												<Td><input type="hidden" name="proportionTotal"/><span>0</span></Td>
											</Tr>
										</tfoot>
									</table>
								</div>
							</c:forEach>
							<!-- 일반배합obj close-->
							<div class="add_nomal_mix" onclick="addTable(this, 'mix')">
								<span><img src="/resources/images/btn_pop_add2.png"> 배합비 추가</span>
							</div>
						</div>
						
						<div class="tbl_in_title">▼ 내용물</div>
						<div class="tbl_in_con">
							<c:forEach items="${sub.subContent}" var="cont" varStatus="baseStatus">
								<div class="nomal_mix">
									<div class="table_header02">
										<input type="hidden" name="baseType" value="CI"/>
										<span class="table_order_btn"><button class="btn_up" onclick="moveUp(this)"></button><button class="btn_down" onclick="moveDown(this)"></button></span>
										<span class="title" style="width:50%">
											<img src="/resources/images/img_table_header.png">
											&nbsp;&nbsp;내용물명 : <input type="text" name="baseName" style="width: 200px" value="${cont.name}"/>
											&nbsp;분할중량 : <input type="text" name="divWeight" style="width: 50px" value="${cont.weight}"/> g
										</span>
										<span class="table_header_btn_box">
											<button class="btn_del_table_header" onclick="removeTable(this, 'content')">내용물 삭제</button>
											<button class="btn_add_tr" onclick="addRow(this, 'content')"></button><button class="btn_del_tr" onclick="removeRow(this)"></button>
										</span>
									</div>
									<table class="tbl05">
										<colgroup>
											<col width="20">
											<col width="140">
											<col />
											<col width="10%">
											<col width="10%">
											<col width="5%">
											<col width="10%">
											<col width="10%">
										</colgroup>
										<thead>
											<tr>
												<th><input type="checkbox" id="contentTable_${subStatus.index}_${baseStatus.index}" onclick="checkAll(event)"><label for="contentTable_${subStatus.index}_${baseStatus.index}"><span></span></label></th>
												<th>원료코드</th>
												<th>원료명</th>
												<th>배합율</th>
												<th>단가</th>
												<th>단위</th>
												<th>가격</th>
												<th>비급수 비율(%)</th>
											</tr>
										</thead>
										<tbody>
											<c:forEach items="${cont.subContentItem}" var="item" varStatus="itemStatus">
												<Tr id="contentRow_${subStatus.index}_${baseStatus.index}_${itemStatus.index}" class="temp_color">
													<Td>
														<input type="checkbox" id="content_${subStatus.index}_${baseStatus.index}_${itemStatus.index}"><label for="content_${subStatus.index}_${baseStatus.index}_${itemStatus.index}"><span></span></label>
														<input type="hidden" name="itemType" value="CI"/>
													</Td>
													<Td>
														<input type="hidden" name="itemImNo" style="width: 100px" class="req code_tbl" value="${item.itemImNo}"/>
														<input type="text" name="itemSapCode" style="width: 100px" class="req code_tbl" value="${item.itemSapCode}" onkeyup="checkMaterail(event, 'B', '${item.itemSapCode}')"/>
														<button class="btn_code_search2" onclick="openMaterialPopup(this, 'B')"></button>
													</Td>
													<Td><input type="text" name="itemName" style="width: 85%" readonly="readonly" class="read_only" value="${item.itemName}"/><button class="btn_code_info2"></button></Td>
													<Td><input type="text" name="mixingRatio" style="width: 100%" class="req" onkeyup="calcBaseTable(event)" value="${item.mixingRatio}"/></Td>
													<Td><input type="text" name="itemUnitPrice" style="width: 100%" class="" onkeyup="calcBaseTable(event)" value="${item.itemUnitPrice}"/></Td>
													<Td><input type="text" name="itemUnit" style="width: 100%" class="readonly" readonly="readonly" value="${item.itemUnit}"/></Td>
													<Td><input type="text" name="itemCustomPrice" style="width: 100%" readonly="readonly" value="${item.itemCustomPrice*item.mixingRatio}"/></Td>
													<Td><input type="text" name="itemProportion" style="width: 100%" readonly="readonly" value=""/></Td>
												</Tr>
											</c:forEach>
										</tbody>
										<tfoot>
											<Tr>
												<Td colspan="3">합계</Td>
												<Td><input type="hidden" name="mixingRatioTotal"/><span>0</span></Td>
												<Td> - </Td>
												<Td> - </Td>
												<Td><input type="hidden" name="priceTotal"/><span>0</span></Td>
												<Td><input type="hidden" name="proportionTotal"/><span>0</span></Td>
											</Tr>
										</tfoot>
									</table>
								</div>
							</c:forEach>
							<!-- 내용물obj close-->
							<div class="add_nomal_mix" onclick="addTable(this, 'content')">
								<span><img src="/resources/images/btn_pop_add3.png"> 내용물 추가</span>
							</div>
						</div>
					</div>
				</div>
			</c:forEach>
			
			
			<div class="title5" style="float: left; margin-top: 30px;">
				<span class="txt">03. 재료</span>
			</div>
			<div class="table_header07">
				<span class="table_order_btn"><button class="btn_up" onclick="moveUp(this)"></button><button class="btn_down" onclick="moveDown(this)"></button></span>
				<span class="table_header_btn_box">
					<button class="btn_add_tr" onclick="addRow(this, 'package')"></button><button class="btn_del_tr" onclick="removeRow(this)"></button>
				</span>
			</div>
			<table id="packageTable" class="tbl05">
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
						<th><input type="checkbox" id="packageTable_1" onclick="checkAll(event)"><label for="packageTable_1"><span></span></label></th>
						<th>재료코드</th>
						<th>원료명</th>
						<th>단가</th>
						<th>수량</th>
						<th>가격</th>
					</tr>
				</thead>
				<tbody name="packageTbody">
					<c:forEach items="${designDocDetail.pkg}" var="item" varStatus="pkgStatus">
						<c:set var="pkgPriceTotal" value="${pkgPriceTotal+item.itemUnitPrice}"/>
						<Tr id="packageRow_1" class="temp_color">
							<Td>
								<input type="hidden" name="itemType" value="MT"/>
								<input type="checkbox" id="package_${pkgStatus.index}"><label for="package_${pkgStatus.index}"><span></span></label>
							</Td>
							<Td>
								<input type="hidden" name="itemImNo" style="width: 100px" class="req code_tbl" value="${item.itemImNo}"/>
								<input type="text" name="itemSapCode" style="width: 100px" class="req code_tbl" value="${item.itemSapCode}" onkeyup="checkMaterail(event, 'R', '${item.itemSapCode}')"/>
								<button class="btn_code_search2" onclick="openMaterialPopup(this, 'R')"></button>
							</Td>
							<Td>
								<input type="text" name="itemName" style="width: 85%" readonly="readonly" class="read_only" value="${item.itemName}"/>
								<button class="btn_code_info2"></button>
							</Td>
							<Td><input type="text" name="itemSapPrice" style="width: 100%" class="req" value="${item.itemUnitPrice}" onkeyup="calcPackagePrice(event)"/></Td>
							<Td><input type="text" name="itemVolume" style="width: 100%" class="req" value="${item.itemVolume}" onkeyup="calcPackagePrice(event)"/></Td>
							<Td><input type="text" name="itemUnitPrice" style="width: 100%" readonly="readonly" class="read_only" value="${item.itemUnitPrice}"/></Td>
						</Tr>
					</c:forEach>
				</tbody>
				<tfoot>
					<tr>
						<td colspan="4">합계</td>
						<td>-</td>
						<td>${pkgPriceTotal}</td>
					</tr>
				</tfoot>
			</table>
			<div class="title5" style="float: left; margin-top: 30px; width: 100%">
				<span style="display: inline;" class="txt">04. 원재료비</span>
				<button style="float: right;" class="btn_con_search" onclick="calcTotalTable()"><img src="/resources/images/btn_icon_calc.png"> 계산</button>
			</div>
			<table class="tbl05" id="combineTable">
				<colgroup>
					<col width="20%">
					<col width="14%">
					<col />
					<col width="14%">
					<col width="14%">
					<col width="14%">
				</colgroup>
				<thead>
					<tr style="border-top: 2px solid #4b5165">
						<th>부속제품명</th>
						<th>구분</th>
						<th>원료명</th>
						<th>단가(KG)</th>
						<th>분할중량(g)</th>
						<th>원가</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td colspan="6">배합, 내용물을 입력하고 계산버튼을 눌러주세요</td>
					</tr>
				</tbody>
				<tfoot></tfoot>
			</table>
			
			
			<div class="main_tbl">
				<div class="btn_box_con5">
					<button class="btn_admin_gray" onClick="goDocDetail()" style="width: 120px;">목록</button>
				</div>
				<div class="btn_box_con4">
					<button class="btn_admin_sky" onclick="updateDocDetail()">저장</button>
					<button class="btn_admin_gray" onclick="goDocDetail()">취소</button>
				</div>
				<hr class="con_mode" />
			</div>
		</div>
	</section>
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
							<th>등록일자</th>
							<th>공급일자</th>
							<th>공급업체</th>
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







<div id=btn_temp class="tab03">
	<ul>
		<li id="subProdAddBtn_temp" class="select" onclick="changeTab(this)">
			<span class="unselectable" ondblclick="changeSubProdName(event)">더블클릭하여 부속제품명 입력</span>
			<input type="text" name="subProdName" onkeyup="subProdNameKeyup(event)" style="width: 180px;" placeholder="더블클릭하여 부속제품명 입력" value="더블클릭하여 부속제품명 입력" />
			<button name="subProdDelBtn" class="tab_btn_del" onclick="removeSubProduct('temp')""><img src="/resources/images/btn_table_header01_del02.png"></button>
		</li>
	</ul>
</div>
<div id="subProdDiv_temp" name="subProdDiv">
	<div id="subProdHead" class="main_tbl">
		<table class="insert_proc01" style="border-top: none; border-right: 1px solid #d1d1d1">
			<colgroup>
				<col width="13%" />
				<col />
			</colgroup>
			<tbody>
				<tr>
					<th>부속제품 설명</th>
					<td><input type="text" name="subProdDesc" style="width: 100%;" class="req" value="${sub.subProdDesc}"/></td>
				</tr>
			</tbody>
		</table>
	</div>
	<div>
		<div class="tbl_in_title">▼ 배합비</div>
		<div class="tbl_in_con">
			<!-- 일반배합obj start-->
			<div id="mixDiv_temp" class="nomal_mix">
				<div class="table_header01">
					<input type="hidden" name="baseType" value="MI"/>
					<span class="table_order_btn"><button class="btn_up" onclick="moveUp(this)"></button><button class="btn_down" onclick="moveDown(this)"></button></span>
					<span class="title" style="width:50%">
						<img src="/resources/images/img_table_header.png">
						&nbsp;&nbsp;배합비명 : <input type="text" name="baseName" style="width: 200px" />
						&nbsp;분할중량 : <input type="text" name="divWeight" style="width: 50px" /> g
					</span>
					<span class="table_header_btn_box">
						<button class="btn_del_table_header" onclick="removeTable(this, 'mix')">배합 삭제</button>
						<button class="btn_add_tr" onclick="addRow(this, 'mix')"></button><button class="btn_del_tr" onclick="removeRow(this)"></button>
					</span>
				</div>
				<table class="tbl05">
					<colgroup>
						<col width="20">
						<col width="140">
						<col />
						<col width="10%">
						<col width="10%">
						<col width="5%">
						<col width="10%">
						<col width="10%">
					</colgroup>
					<thead>
						<tr>
							<th><input type="checkbox" id="mixTable_temp" onclick="checkAll(event)"><label for="mixTable_temp"><span></span></label></th>
							<th>원료코드</th>
							<th>원료명</th>
							<th>배합율</th>
							<th>단가</th>
							<th>단위</th>
							<th>가격</th>
							<th>비급수 비율(%)</th>
						</tr>
					</thead>
					<tbody>
						<Tr id="mixRow_temp" class="temp_color">
							<Td>
								<input type="checkbox" id="mix_temp"><label for="mix_temp"><span></span></label>
								<input type="hidden" name="itemType"/>
								<input type="hidden" name="itemTypeName"/>
							</Td>
							<Td>
								<input type="hidden" name="itemImNo" style="width: 100px" class="req code_tbl" />
								<input type="text" name="itemSapCode" style="width: 100px" class="req code_tbl" onkeyup="checkMaterail(event, 'B', '')"/>
								<button class="btn_code_search2" onclick="openMaterialPopup(this, 'B')"></button>
							</Td>
							<Td><input type="text" name="itemName" style="width: 85%" readonly="readonly" class="read_only" /><button class="btn_code_info2"></button></Td>
							<Td><input type="text" name="mixingRatio" style="width: 100%" class="req" onkeyup="calcBaseTable(event)"/></Td>
							<Td><input type="text" name="itemUnitPrice" style="width: 100%" class="" onkeyup="calcBaseTable(event)"/></Td>
							<Td><input type="text" name="itemUnit" style="width: 100%" class="readonly" readonly="readonly"/></Td>
							<Td><input type="text" name="itemCustomPrice" style="width: 100%" readonly="readonly"/></Td>
							<Td><input type="text" name="itemProportion" style="width: 100%" readonly="readonly"/></Td>
						</Tr>
					</tbody>
					<tfoot>
						<Tr>
							<Td colspan="3">합계</Td>
							<Td><input type="hidden" name="mixingRatioTotal"/><span>0</span></Td>
							<Td> - </Td>
							<Td> - </Td>
							<Td><input type="hidden" name="priceTotal"/><span>0</span></Td>
							<Td><input type="hidden" name="proportionTotal"/><span>0</span></Td>
						</Tr>
					</tfoot>
				</table>
			</div>
			<!-- 일반배합obj close-->
			<div name="addMixDiv" class="add_nomal_mix" onclick="addTable(this, 'mix')">
				<span><img src="/resources/images/btn_pop_add2.png"> 배합비 추가</span>
			</div>
		</div>
		<div class="tbl_in_title">▼ 내용물</div>
		<div class="tbl_in_con">
			<!-- 내용물obj start-->
			<div id="contDiv_temp" class="nomal_mix">
				<div class="table_header02">
					<input type="hidden" name="baseType" value="CI"/>
					<span class="table_order_btn"><button class="btn_up" onclick="moveUp(this)"></button><button class="btn_down" onclick="moveDown(this)"></button></span>
					<span class="title" style="width:50%">
						<img src="/resources/images/img_table_header.png">
						&nbsp;&nbsp;내용물명 : <input type="text" name="baseName" style="width: 200px" />
						&nbsp;분할중량 : <input type="text" name="divWeight" style="width: 50px" /> g
					</span>
					<span class="table_header_btn_box">
						<button class="btn_del_table_header" onclick="removeTable(this, 'content')">내용물 삭제</button>
						<button class="btn_add_tr" onclick="addRow(this, 'content')"></button><button class="btn_del_tr" onclick="removeRow(this)"></button>
					</span>
				</div>
				<table class="tbl05">
					<colgroup>
						<col width="20">
						<col width="140">
						<col />
						<col width="10%">
						<col width="10%">
						<col width="5%">
						<col width="10%">
						<col width="10%">
					</colgroup>
					<thead>
						<tr>
							<th><input type="checkbox" id="contentTable_temp" onclick="checkAll(event)"><label for="contentTable_temp"><span></span></label></th>
							<th>원료코드</th>
							<th>원료명</th>
							<th>배합율</th>
							<th>단가</th>
							<th>단위</th>
							<th>가격</th>
							<th>비급수 비율(%)</th>
						</tr>
					</thead>
					<tbody>
						<Tr id="contentRow_temp" class="temp_color">
							<Td>
								<input type="checkbox" id="content_temp"><label for="content_temp"><span></span></label>
								<input type="hidden" name="itemType"/>
								<input type="hidden" name="itemTypeName"/>
							</Td>
							<Td>
								<input type="hidden" name="itemImNo" style="width: 100px" class="req code_tbl" />
								<input type="text" name="itemSapCode" style="width: 100px" class="req code_tbl" onkeyup="checkMaterail(event, 'B', '')"/>
								<button class="btn_code_search2" onclick="openMaterialPopup(this, 'B')"></button>
							</Td>
							<Td><input type="text" name="itemName" style="width: 85%" readonly="readonly" class="read_only" /><button class="btn_code_info2"></button></Td>
							<Td><input type="text" name="mixingRatio" style="width: 100%" class="req" onkeyup="calcBaseTable(event)"/></Td>
							<Td><input type="text" name="itemUnitPrice" style="width: 100%" class="" onkeyup="calcBaseTable(event)"/></Td>
							<Td><input type="text" name="itemUnit" style="width: 100%" class="readonly" readonly="readonly"/></Td>
							<Td><input type="text" name="itemCustomPrice" style="width: 100%" readonly="readonly"/></Td>
							<Td><input type="text" name="itemProportion" style="width: 100%" readonly="readonly"/></Td>
						</Tr>
					</tbody>
					<tfoot>
						<Tr>
							<Td colspan="3">합계</Td>
							<Td><input type="hidden" name="mixingRatioTotal"/><span>0</span></Td>
							<Td> - </Td>
							<Td> - </Td>
							<Td><input type="hidden" name="priceTotal"/><span>0</span></Td>
							<Td><input type="hidden" name="proportionTotal"/><span>0</span></Td>
						</Tr>
					</tfoot>
				</table>
			</div>
			<!-- 내용물obj close-->
			<div name="addContDiv" class="add_nomal_mix" onclick="addTable(this, 'content')">
				<span><img src="/resources/images/btn_pop_add3.png"> 내용물 추가</span>
			</div>
		</div>
	</div>
</div>


<table id="pkgTable_temp" class="tbl05">
	<Tr id="pkgRow_temp" class="temp_color">
		<Td>
			<input type="hidden" name="itemType" value="MT"/>
			<input type="checkbox" id="package_tempCh"><label for="package_tempCh"><span></span></label>
		</Td>
		<Td>
			<input type="hidden" name="itemImNo" style="width: 100px" class="req code_tbl"/>
			<input type="text" name="itemSapCode" style="width: 100px" class="req code_tbl" onkeyup="checkMaterail(event, 'R', '')"/>
			<button class="btn_code_search2" onclick="openMaterialPopup(this, 'R')"></button>
		</Td>
		<Td>
			<input type="text" name="itemName" style="width: 85%" readonly="readonly" class="read_only"/>
			<button class="btn_code_info2"></button>
		</Td>
		<Td><input type="text" name="itemSapPrice" style="width: 100%" class="req"/></Td>
		<Td><input type="text" name="itemVolume" style="width: 100%" class="req" onkeyup="calcPackagePrice(event)"/></Td>
		<Td><input type="text" name="itemUnitPrice" style="width: 100%"/></Td>
	</Tr>
</table>
