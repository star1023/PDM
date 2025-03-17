<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="kr.co.aspn.util.*" %>
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
		$('#subProdAddBtn_0').click();
		
		loadCodeList( "KEEPCONDITION", "keepConditionCode" );
		
		var keepConditionCode = '${mfgProcessDoc.keepConditionCode}';
		if(keepConditionCode.length > 0){
			$('#keepConditionCode option[value='+keepConditionCode+']').prop('selected', true);
			$('#label_keepConditionCode').text($('#keepConditionCode option[value='+keepConditionCode+']').text())
		}
			
		
		subProdTabBtn = '<a href="javascript:;">'+$('#subProdAddBtn_temp').html()+'</a>';
		
		subProdHead = '<div name="subProdHead">'+$('div[name=subProdHead]:first').html()+'</div>';
		subProdDiv = '<div name="subProdDiv">'+$('#subProdDiv_temp').html()+'</div>'
		
		mixTable = '<div class="nomal_mix">'+$('#mixDiv_temp').html()+'</div>';
		contentTable = '<div class="nomal_mix">'+$('#contDiv_temp').html()+'</div>';
		
		mixRow = '<tr>'+$('#mixRow_temp').html()+'</tr>';
		contentRow = '<tr>'+$('#contRow_temp').html()+'</tr>';
		dispRow = '<tr>'+$('#dispRow_temp').html()+'</tr>';
		packageRow = '<tr>'+$('#pkgRow_temp').html()+'</tr>';
		consumeRow = '<tr>'+$('#consRow_temp').html()+'</tr>';
		
		$('#dispTable_temp').remove();
		$('#pkgTable_temp').remove();
		$('#consTable_temp').remove();
		
		$('#btn_temp').remove();
		$('#subProdDiv_temp').remove();
		/* 
		$('#productDesignCreateForm').on('submit', function(event){
			event.preventDefault();
		});
		 */
		 
		$('input[name=itemSapCode]').bind('keyup', function(e){ if(e.keyCode== 13) $(e.target).next().click() });
		$('input[name=subProdDivUnitWeight]').keyup();
		
		
		var companyCode = '${mfgProcessDoc.companyCode}'
		var plantList = '${plantList}'
		var selectedPlantList = JSON.parse(plantList).filter(function(v){
			if(v.companyCode == companyCode) {
				return v;
			}
		})
		
		selectedPlantList.forEach(function(v, i){
			if(v.companyCode == companyCode) {
				if(i == 0){
					$('#'+'mfg_plant_select').append('<option value="'+v.plantCode+'" selected>'+v.plantName+'</option>')
					$('#'+'mfg_plant_select').change();
				} else {
					$('#'+'mfg_plant_select').append('<option value="'+v.plantCode+'">'+v.plantName+'</option>')
				}
			}
		})
		
		
		
		
		var plantCode = '${mfgProcessDoc.plantCode}';
		var lineCode = '${mfgProcessDoc.lineCode}';
		
		if(plantCode.length > 0){
			$('#mfg_plant_select option[value='+plantCode+']').prop('selected', true);
			$('#mfg_plant_select').change();
		}
		
		if(lineCode.length > 0){
			$('#mfg_plantline_select option[value='+lineCode+']').prop('selected', true);
			$('#mfg_plantline_select').change();
		}
	});
	
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
	
	function bindEnterKeySapCode(element){
		$(element).bind('keyup', function(e){ if(e.keyCode== 13) $(e.target).next().click() });
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
		$('#'+parentRowId + ' input[name$=itemOrgUnit]').val(itemUnit);
		$('#'+parentRowId + ' input[name$=itemCalculatedPrice]').val(itemUnitPrice);
		
		if(itemName.indexOf('[임시]') >= 0){
			$('#'+parentRowId).css('background-color', '#ffdb8c');
		} else {
			$('#'+parentRowId).css('background-color', '#fff');
		}
		closeMatRayer();
	}
	
		
	function setUniqueId(tagName, duplId){
		var parentId = $(tagName+'[id='+duplId+']:first').attr('id').split('_')[0]+'_';
		var randomId = Math.random().toString(36).substr(2, 9);
		
		var targetElement = $(tagName+'[id='+duplId+']:last');
		var targetLabelElement =$(tagName+'[id='+duplId+']:last').parent().children('label');
		
		targetElement.attr('id', parentId+randomId);
		targetLabelElement.attr('for', parentId+randomId);
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
		var itemSapCodeElement = $(element).parent().parent().next().children('tbody').children('tr:last').children('td').children('input[name=itemSapCode]');
		bindEnterKeySapCode(itemSapCodeElement);
		
		if(type == 'disp'){
			var tr = $(element).parent().parent().next().children('tbody').children('tr:last');
			tr.children('td').toArray().forEach(function(td){
				$(td).children('input[name=matName]').attr('readonly', false);
				$(td).children('input[name=excRate]').attr('readonly', false);
				$(td).children('input[name=incRate]').attr('readonly', false);
			})
		}
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
	
	/* function changeMixWeight(element){
		clearNoNum(element);
		
		var subProdDivWeight = 0;
		$('input[name=mixWeight]').toArray().forEach(function(input){
			subProdDivWeight += Number($(input).val());
		})
		$(element).parent().parent().parent().parent().parent().parent().children('input[name=subProdDivWeight]:first').val(subProdDivWeight);
	} */
	
	function saveValid(){
		var pkgValid = true;
		if($('tr[id^=pkgRow_]').length > 0){
			$('tr[id^=pkgRow_]').toArray().forEach(function(pkgRow){
				if(!pkgValid) return;
				
				var rowId = $(pkgRow).attr('id');
				var itemSapCode = $('#'+ rowId + ' input[name=itemSapCode]').val();
				var itemName = $('#'+ rowId + ' input[name=itemName]').val();
				
				if(itemSapCode.length <= 0){
					pkgValid = false;
					alert('원료코드를 입력해주세요');
					$('#'+ rowId + ' input[name=itemSapCode]').focus();
					return;
				}
				if(itemName.length <= 0){
					pkgValid = false;
					alert('원료를 검색하여 선택해주세요');
					$('#'+ rowId + ' input[name=itemSapCode]').next().focus();
					return;
				}
			})
		}
		if(!pkgValid) return false;
		
		return true;
	}
	
	function updateMfgProcessDocPackage(){
		//$('#lab_loading').show();
		if(!saveValid()){
			return;
		}
		
		var docNo = '${docNo}';
		var docVersion = '${docVersion}';
		$.post('updateManufacturingProcessDocPakcage', getPostData(), function(data){
			if(data == 'S') {
				alert('문서 수정 완료');
				location.reload();
			} else {
				alert('문서 수정 실패(1) - 시스템 담당자에게 문의해주세요');
			}
			$('#lab_loading').hide();
		}).fail(function(res){
			//console.log('Error: ' + res.responseText)
			alert('문서 수정 실패(2) - 시스템 담당자에게 문의해주세요');
			$('#lab_loading').hide();
			return ;
		})
	}
	
	function getPostData(){
		var postData = {};
		
		// 기준정보
		postData['dNo'] = '${dNo}';
		postData['docNo'] = '${docNo}';
		postData['docVersion'] = '${docVersion}';
		
		// 재료
		$('tbody[name=packageTbody]').children('tr').toArray().forEach(function(pkg, pkgNdx){
			//var pkgPath = 'sub['+subProdNdx+'].pkg['+pkgNdx+'].';
			var pkgPath = 'pkg['+pkgNdx+'].';
			setPostItem(postData, pkgPath, pkg, pkgNdx)
		})
		
		return postData;
	}
	
	function setPostItem(postData, propPath, item, itemNdx){
		postData[propPath+'itemCode'] = $(item).children('td').children('input[name=itemSapCode]').val();
		postData[propPath+'itemName'] = $(item).children('td').children('input[name=itemName]').val();
		postData[propPath+'bomRate'] = $(item).children('td').children('input[name=itemBomRate]').val();
		postData[propPath+'bomAmount'] = $(item).children('td').children('input[name=itemBomAmount]').val();
		postData[propPath+'unit'] = $(item).children('td').children('input[name=itemUnit]').val();
		postData[propPath+'fomulaType'] = $(item).children('td').children('input[name=itemFomulaType]').val();
		postData[propPath+'orgUnit'] = $(item).children('td').children('input[name=itemOrgUnit]').val();
		postData[propPath+'weight'] = $(item).children('td').children('input[name=itemWeight]').val();
		postData[propPath+'posnr'] = $(item).children('td').children('input[name=itemPosnr]').val();
		postData[propPath+'scrap'] = $(item).children('td').children('input[name=itemScrap]').val();
		postData[propPath+'storageCode'] = $(item).children('td').children('input[name=itemStorageCode]').val();
		postData[propPath+'storageName'] = '';
		
		return postData;
	}
	
	function changeAutoDisp(isAuto){
		$('input[name=isAutoDisp]').val(isAuto);
		if(isAuto == 1){
			$('input[name=isAutoDisp]').prev().children('li:first').attr('class', '');
			$('input[name=isAutoDisp]').prev().children('li:last').attr('class', 'select');
			
			setDisp();
			$('input[name=isAutoDisp]').parent().parent().next().children().css('display', 'none')
			
			
		} else {
			$('input[name=isAutoDisp]').prev().children('li:first').attr('class', 'select');
			$('input[name=isAutoDisp]').prev().children('li:last').attr('class', '');
			
			$('input[name=isAutoDisp]').parent().parent().next().children().css('display', 'block')
			
			var dispTable = $('#dispHeaderDiv').next();
			dispTable.children('tbody').children('tr').toArray().forEach(function(tr){
				$(tr).children('td').children('input[name=matName]').attr('readonly', false);
				$(tr).children('td').children('input[name=excRate]').attr('readonly', false);
				$(tr).children('td').children('input[name=incRate]').attr('readonly', false);
			})
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
	
	function caclWeight(element){
		clearNoNum(element);
		
		var tBody = $(element).parent().parent().parent();
		
		var amountTotal = 0;
		tBody.children('tr').toArray().forEach(function(tr, i){
			amountTotal += Number($(tr).children('td').children('input[name=itemWeight]').val());
		});
		
		var totalRow = tBody.next().children('tr');
		$(totalRow).children('td').children('input[name=itemWeightTotal]').val(amountTotal.toFixed(3));
	}
	
	function copyBakery(element){
		var amountTotal = 0;
		
		var tBody = $(element).parent().parent().parent().next();
		tBody.children('tr').toArray().forEach(function(tr, i){
			var bakery = $(tr).children('td').children('input[name=itemBomRate]').val();
			$(tr).children('td').children('input[name=itemWeight]').val(bakery);
			
			amountTotal += Number(bakery);
		});
		
		var totalRow = $(element).parent().parent().parent().next().next().children('tr');
		$(totalRow).children('td').children('input[name=itemWeightTotal]').val(amountTotal.toFixed(3));
	}
	
	function copyBakeryAll(){
		if(confirm('베이커리의 입력 값을 중량에 복사합니다. 기존 입력 하신 중량값은 베이커리 값으로 변경됩니다. 계속 하시겠습니까?'))
		$('a[name=copyBakery]').toArray().forEach(function(copyBakery){
			$(copyBakery).click()
		})
	}
	
	function convertItem(){
		if(!confirm('자재정보를 최상상태로 갱신하시겠습니까?')){
			return;
		}
		
		var dNo = '${dNo}';
		var errorLog = '';
		$('input[name=itemImNo]').toArray().forEach(function(input, index, arr){
			var tr = $(input).parent().parent();
			var rowId = tr.id;
			
			var itemImNo = $(input).val() == null ? '' : $(input).val();
			var itemName = tr.children('td').children('input[name=itemName]').val();
			var itemSapCode = tr.children('td').children('input[name=itemSapCode]').val();
			
			$.ajax({
				url: 'getLatestMaterail',
				type: 'post',
				dataType: 'json',
				data: {
					dNo: dNo,
					itemImNo: itemImNo,
					itemSapCode: itemSapCode
				},
				success: function(data){
					if(data.length > 0){
						setMaterialPopupData(rowId, data.imNo, data.sapCode, data.name, data.price)
					} else {
						if(errorLog.length <= 0){
							errorLog = itemName+'['+ itemSapCode + ']에 대한 정보가 존재하지 않습니다.'
						} else {
							errorLog += '\n'+itemName+'['+ itemSapCode + ']에 대한 정보가 존재하지 않습니다.'
						}
					}
					
					if(index == arr.length-1) convertItemCallback(errorLog);
				},
				error: function(a,b,c){
					// TODO 에러처리
					// console.log(a,b,c);
				}
			})
		})
	}
	
	function changeMfgPlant(e, targetId){
		var plantCode = e.target.value
		var plantLineList = '${plantLineList}'
		$('#'+targetId).empty();
		
		var companyCode;
		JSON.parse(plantLineList).forEach(function(obj){
			if(obj.plantCode == plantCode)
				companyCode = obj.companyCode
		});
		
		var selectdPlantlineList = JSON.parse(plantLineList).filter(function(v){
			if(v.companyCode == companyCode && v.plantCode == plantCode){
				return v;
			}
		});
		
		selectdPlantlineList.forEach(function(v, i){
			if(i == 0){
				$('#'+targetId).append('<option value="'+v.lineCode+'" selected>'+v.lineName+'('+v.lineCode+')</option>');
				$('#'+targetId).change();
			} else {
				$('#'+targetId).append('<option value="'+v.lineCode+'">'+v.lineName+'('+v.lineCode+')</option>')
			}
		})
	}
	
	function convertItemCallback(errorLog){
		if(errorLog){
			return alert(errorLog + '\n\n상기 건을 제외한 자재정보가 갱신되었습니다.')
		} else {
			return alert('모든 자재정보가 갱신되었습니다.');
		}
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
				companyCode: '${mfgProcessDoc.companyCode}',
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
					row += '<Td>'+item.companyCode+'('+item.plant+')'+'</Td>';
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
	
	function setSubProdDivWeight(e){
		var unitWeight = Number($(e.target).parent().children('input[name=subProdDivUnitWeight]').val());
		var volume = Number($(e.target).parent().children('input[name=subProdDivUnitVolume]').val());
		var subProdDivWeight = (unitWeight * volume);
		//$(e.target).parent().children('input[name=subProdDivWeight]').val(subProdDivWeight);
		//$(e.target).parent().children('input[name=subProdDivWeight]').keyup();
	}
	
	function callDialog(e, dialogId){
		$('#lab_loading').show();
		
		var randomId = Math.random().toString(36).substr(2, 9);
		
		if(dialogId == 'dialog_storage'){
			var companyCode = '${companyCode}'
			var plantCode= '${plantCode}'
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
			
			var storageList = JSON.parse('${storageList}')
			var filteredList = storageList.filter(function(storage){
				return (storage.companyCode == companyCode && storage.plantCode == plantCode);
			});
			
			filteredList.sort(function(a, b){return a.storageCode - b.storageCode}).forEach(function(storage){
				$('#dialogStorage').append('<option value="'+storage.storageCode+'">'+'['+storage.storageCode+']'+storage.storageName+'</option>')
			})
			
			openDialog('dialog_storage')
		}
		
		if(dialogId == 'dialog_unit'){
			$(e.target).attr('id', targetId);
			$('#targetUnitId').val(targetId);
			
			var stdAmount = $('input[name=stdAmount]').val();
			$('#dialig_stdAmount').text(stdAmount);
			$('#targetUnitStdAmount').val(stdAmount);
			
			openDialog('dialog_unit');
		}
		
		$('#lab_loading').hide();
	}
	
	function setItemStorage(type){
		var storage = $('#dialogStorage').val();
		var type = $('#storageSetType').val();
		
		if(type == 'item'){
			$('#'+$('#targetStorageId').val()).val(storage);
		} else {
			$('input[name=itemStorageCode]').toArray().forEach(function(element){
				$(element).val(storage);
			})
		}
		
		closeDialog('dialog_storage');
	}
	
	function bindDialogEnter(e){
		if(e.keyCode == 13)
			$(e.target).next().click();
	}
	
	function goBack(){
		var docNo = '${productDevDoc.docNo}'
		var docVersion = '${productDevDoc.docVersion}'
		
		location.href='/dev/productDevDocDetail?docNo='+docNo+'&docVersion='+docVersion
	}
	
	function goList(){
		location.href='/dev/productDevDocList';
	}
	
	function openUnitDialog(e){
		var targetRowId = $(e.target).parent().parent().attr('id');
		var targetValue = $(e.target).prev().val();
		
		var labelText = $('#selectUnitType option:first').text();
		$('#selectUnitType option:first').prop('selected', true);
		$('#selectUnitType').parent().children('label').text(labelText);
		$('#targetRowId').val(targetRowId);
		$('#convertUserValue').val(targetValue);
		$('#targetUnitValue').val(targetValue);
		$('#convertUserValue').keyup();
		$('#selectUnitType').change();
		
		openDialog('dialog_convert');
	}
	
	function calcUnitChange(e){
		var stdAmount = '${mfgProcessDoc.stdAmount}';
		
		$(e.target).prev('span').text(stdAmount);
		var userValue = $(e.target).val();
		var calcType = $(e.target).parent().parent().prev().children('dd').children('div').children('select').val();
		var targetElement = $(e.target).parent().parent().next().next().children('dd').children('input');
		var targetUnitElement = $(e.target).parent().parent().next().children('dd').children('input');
		var numbong = '${mfgProcessDoc.numBong}';
		var numbox = '${mfgProcessDoc.numBox}';
		
		if(calcType == 1){
			targetElement.val( round(Number(stdAmount) * Number(userValue) / 500000,3) );
			targetUnitElement.val("ROL");
		} else if(calcType == 2){
			targetElement.val( round(Number(stdAmount) * Number(userValue) / 1000000,3) );
			targetUnitElement.val("ROL");
		} else if(calcType == 6){
			targetElement.val( round(Number(stdAmount) * Number(userValue) / 1500000,3) );
			targetUnitElement.val("ROL");
		} else if(calcType == 7){
			targetElement.val( round(Number(stdAmount) * Number(userValue) / 1800000,3) );
			targetUnitElement.val("ROL");
		} else if(calcType == 3){
			targetElement.val( round(Number(stdAmount) * Number(userValue) / 2000000,3) );
			targetUnitElement.val("ROL");
		} else if(calcType == 4){
			targetElement.val( round(Number(stdAmount) * Number(userValue) / 800000,3) );
			targetUnitElement.val("ROL");
		} else if(calcType == 5){
			targetElement.val( round(Number(stdAmount) * Number(userValue) *2 / 800000,3) );
			targetUnitElement.val("ROL");
		}
		
		 else if(calcType == 8){
			targetElement.val( round(Number(stdAmount), 3) );
			targetUnitElement.val("EA");
		} else if(calcType == 9){
			targetElement.val( round(Number(stdAmount) * Number(numbong) ,3) );
			targetUnitElement.val("EA");
		} else if(calcType == 10){
			targetElement.val( round(Number(stdAmount) * Number(userValue) / 1000000 * Number(numbong),3) );
			targetUnitElement.val("ROL");
		} else if(calcType == 11){
			targetElement.val( round(Number(stdAmount) / Number(numbox), 3) );
			targetUnitElement.val("ROL");
		}
	}
	
	function changeConvertType(e){
		var convertType = e.target.value;
		var stdAmount = '${mfgProcessDoc.stdAmount}';
		var convertUserValue = $('#targetUnitValue').val();
		var numbong = '${mfgProcessDoc.numBong}';
		var numbox = '${mfgProcessDoc.numBox}';
		
		var targetHtml = '기준수량('+stdAmount+')';
		targetHtml += ' x 포장지 길이(';
		targetHtml += '<input type="text" id="convertUserValue" value="'+convertUserValue+'" onkeyup="calcUnitChange(event)" style="width: 60px" class="req">';
		if(convertType == 1){
			targetHtml += ') / 500,000mm)';
		} else if(convertType == 2){
			targetHtml += ') / 1,000,000mm)';
		} else if(convertType == 6){
			targetHtml += ') / 1,500,000mm)';
		} else if(convertType == 7){
			targetHtml += ') / 1,800,000mm)';
		} else if(convertType == 3){
			targetHtml += ') / 2,000,000mm)';
		} else if(convertType == 4){
			targetHtml += ') / 800,000mm)';
		} else if(convertType == 5){
			targetHtml += ') x 2 / 800,000mm)';
		
		} else if(convertType == 8){
			var targetHtml = '기준수량('+stdAmount+')';
			targetHtml += '<input type="hidden" id="convertUserValue" onkeyup="calcUnitChange(event)" value="'+convertUserValue+'">';
		} else if(convertType == 9){
			var targetHtml = '기준수량('+stdAmount+')';
			targetHtml += '<input type="hidden" id="convertUserValue" onkeyup="calcUnitChange(event)" value="'+convertUserValue+'">' + ' x 봉당 들이수('+numbong+')';
		} else if(convertType == 10){
			targetHtml += ') ' + '<input type="hidden" id="convertUserValue" value="'+convertUserValue+'">' +' / 1,000,000 x 봉당 들이수('+numbong+')'
		} else if(convertType == 11){
			var targetHtml = '기준수량('+stdAmount+')';
			targetHtml+= '<input type="hidden" id="convertUserValue" onkeyup="calcUnitChange(event)" value="'+convertUserValue+'">' + ' / 상자 들이수('+numbox+')';
		}
		
		$('#convertDD').empty();
		$('#convertDD').append(targetHtml)
		
		$('#targetUnitCalcType').val(convertType);
		$('#convertUserValue').keyup();
	}
	
	function setCovertResult(){
		var targetRowId = $('#targetRowId').val();
		var convertResult = $('#convertResult').val();
		var convertResultUnit = $('#convertResultUnit').val();
		var convertUserValue = $('#convertUserValue').val();
		convertUserValue == 'undefined' ? '' : convertUserValue;
		
		$('#'+targetRowId).children('td').children('input[name=itemBomAmount]').val(convertUserValue);
		$('#'+targetRowId).children('td').children('input[name=itemBomRate]').val(convertResult);
		$('#'+targetRowId).children('td').children('input[name=itemUnit]').val(convertResultUnit);
		$('#'+targetRowId).children('td').children('input[name=itemFomulaType]').val($('#selectUnitType').val());
		
		closeDialog('dialog_convert')
	}
	
	//반올림 처리
	function round(n, digits) {
	  if (digits >= 0) return parseFloat(Number(n).toFixed(digits)); // 소수부 반올림
	  digits = Math.pow(10, digits); // 정수부 반올림
	  var t = Math.round(n * digits) / digits;
	  return parseFloat(t.toFixed(0));
	}
	
	//퍼센트로 정렬 하기
	function SortByPecent(a, b){
		  var aEXCRATE = a.EXCRATE;
		  var bEXCRATE = b.EXCRATE; 
		  //return ((aINCRATE < bINCRATE) ? -1 : ((aINCRATE > bINCRATE) ? 1 : 0)); //오름차순
		  return ((aEXCRATE < bEXCRATE) ? 1 : ((aEXCRATE > bEXCRATE) ? -1 : 0)); //내림차순		  
	}
</script>


<div class="wrap_in" id="fixNextTag">
	<span class="path">
		제조공정서 수정&nbsp;&nbsp;
		<img src="/resources/images/icon_path.png" style="vertical-align: middle" />&nbsp;&nbsp;제품개발문서&nbsp;&nbsp;
		<img src="/resources/images/icon_path.png" style="vertical-align: middle" />&nbsp;&nbsp;<a href="javascript:;">삼립식품 연구개발시스템</a>
	</span>
	<section class="type01">
		<!-- 상세 페이지  start-->
		<h2 style="position: relative">
			<span class="title_s">Manufacturing Process Doc</span><span class="title">제조공정서 수정</span>
			<div class="top_btn_box">
				<ul>
					<li>
						<button class="btn_circle_save" onclick="updateMfgProcessDocPackage()">&nbsp;</button>
					</li>
				</ul>
			</div>
		</h2>
		<div class="group01 mt20">
			<!-- 복잡하니 잘따라오소-->
			<!-- 기준정보 start --------------------------------------------------------------------------------------------------------------------------------------------------------->
			<div class="title5">
				<span class="txt">01. '${productDevDoc.productName}' 기준정보</span>
			</div>
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
							<td colspan="5">${mfgProcessDoc.memo}</td>
						</tr>
						<tr>
							<th style="border-left: none;">공장</th>
							<td>${mfgProcessDoc.plantName}${mfgProcessDoc.plantCode}</td>
							<th>생산라인</th>
							<td>${mfgProcessDoc.lineName}</td>
							<th>기준수량</th>
							<td>${mfgProcessDoc.stdAmount}</td>
						</tr>
						<tr>
							<th style="border-left: none;">대체BOM</th>
							<td>${mfgProcessDoc.stlal}</td>
							<th>배합중량</th>
							<td>${mfgProcessDoc.mixWeight} Kg (${mfgProcessDoc.bagAmout} 포)
							</td>
							<th>BOM수율</th>
							<td>${mfgProcessDoc.bomRate} %</td>
						</tr>
						<tr>
							<th style="border-left: none;">봉당 들이수</th>
							<td>${mfgProcessDoc.numBong} /ea</td>
							<th>상자 들이수</th>
							<td>${mfgProcessDoc.numBox}</td>
							<th>분할중량 총합계(g)</th>
							<td>${mfgProcessDoc.totWeight}</td>
						</tr>
						<tr>
							<th style="border-left: none;">소성손실(g/%)</th>
							<td>${mfgProcessDoc.loss} %</td>
							<th>품목제조보고서명</th>
							<td>${mfgProcessDoc.docProdName}</td>
							<th>제조공정도 유형</th>
							<td>${mfgProcessDoc.lineProcessType}</td>
						</tr>
					</tbody>
				</table>
			</div>
			<!-- 기준정보 close --------------------------------------------------------------------------------------------------------------------------------------------------------->
			<!-- <div class="fl pt20 pb10">
				<button class="btn_con_search" onclick="convertItem()"><img src="/resources/images/btn_icon_convert.png"> 자재정보 갱신</button>
			</div>
			<div class="fr pt20 pb10">
				<button class="btn_con_search" onclick="calcAll()"><img src="/resources/images/btn_icon_calc.png"> 전체 수식계산</button>
				<button class="btn_con_search" onclick="setAllPosnr()"><img src="/resources/images/btn_icon_setting.png"> BOM항목 일괄설정</button>
				<button class="btn_con_search" onclick="callDialog(event, 'dialog_storage')"><img src="/resources/images/btn_icon_setting.png"> 저장위치 일괄설정</button>
				<button class="btn_con_search" onclick="copyBakeryAll()"><img src="/resources/images/btn_icon_setting.png"> 중량 일괄설정</button>
			</div> -->
			<!-- 원료 start --------------------------------------------------------------------------------------------------------------------------------------------------------->
			<div class="title5" style="padding-top: 50px;">
				<span class="txt">02. 원료</span>
			</div>
			<%-- 
			<div class="tab03">
				<ul>
					<!-- 선택됬을경우는 탭 클래스에 select를 넣어주세요 -->
					<c:forEach items="${mfgProcessDoc.sub}" var="sub" varStatus="subStatus">
						<c:set var="liClass" value="${subStatus.index == 0 ? 'select' : ''}"/>
						<a href="javascript:;" id="subProdAddBtn_${subStatus.index}"><li class="${liClass}" onclick="changeTab(this)">
							<input type="text" name="subProdName" style="width: 200px;" placeholder="부속제품명 입력" class="req" value="${sub.subProdName}" />
							<button class="tab_btn_del"  onclick="removeSubProduct(event)"><img src="/resources/images/btn_table_header01_del02.png"></button>
						</li></a>
					</c:forEach>
					<!-- 부속제품추가됬으나 감춰진탭 -->
					<a href="javascript:;"><li class="" onclick="addSubProduct(this)">
						<button class="tab_btn_add"><img src="/resources/images/btn_pop_add.png"> 부속제품추가</button>
					</li></a>
					<!-- 부속제품 추가시 -->
				</ul>
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
									<th>분할 중량</th>
									<td>
										<input type="text" name="subProdDivWeight" style="width: 25%;" value="${sub.divWeight}" class="read_only" readonly="readonly" onkeyup="calcStdAmount(event)"/> g
										(
										<input type="text" name="subProdDivUnitWeight" class="req" style="width: 20%" value="${sub.unitWeight}" onkeyup="setSubProdDivWeight(event)">g
										x
										<input type="text" name="subProdDivUnitVolume" class="req" style="width: 15%" value="${sub.unitVolume}" onkeyup="setSubProdDivWeight(event)">ea
										)
									</td>
									<th>분할중량 설명</th>
									<td><input type="text" name="subProdDivWeightTxt" style="width: 100%;" value="${sub.divWeightTxt}"/></td>
									<th>기준수량</th>
									<td>
										<c:if test="${mfgProcessDoc.calcType == '20'}">
											<input type="text" name="subProdStdAmount" style="width: 100%;" class="req" value="${sub.stdAmount}"/>
										</c:if>
										<c:if test="${mfgProcessDoc.calcType != '20'}">
											<input type="text" name="subProdStdAmount" style="width: 100%;" readonly="readonly" class="read_only" value="${sub.stdAmount}"/>
										</c:if>
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
											<col width="8%">
											<col width="8%">
											<col width="8%">
											<col width="8%">
											<col width="12%">
										</colgroup>
										<thead>
											<tr>
												<th><input type="checkbox" id="mixTable_${baseStatus.index}" onclick="checkAll(event)"><label for="mixTable_${baseStatus.index}"><span></span></label></th>
												<th>원료코드</th>
												<th>원료명</th>
												<th>배합%</th>
												<th>BOM수량</th>
												<th>단위</th>
												<th>중량g( <a href="javascript:;" name="copyBakery" onclick="copyBakery(this)">복제</a> )</th>
												<th>BOM항목</th>
												<th>스크랩</th>
												<th>저장위치</th>
											</tr>
										</thead>
										<tbody>
											<c:forEach items="${mix.item}" var="item" varStatus="itemStatus">
												<c:set var="bomRateTotal" value="${bomRateTotal + item.bomRate}"/>
												<c:set var="bomAmountTotal" value="${bomAmountTotal + item.bomAmount}"/>
												<c:set var="weightTotal" value="${weightTotal + item.weight}"/>
												<Tr id="mixRow_${itemStatus.index}" class="temp_color">
													<Td><input type="checkbox" id="mix_${itemStatus.index}"><label for="mix_${itemStatus.index}"><span></span></label></Td>
													<Td>
														<input type="hidden" name="itemImNo" style="width: 100px" class="req code_tbl" value="${item.itemImNo}"/>		
														<input type="text" name="itemSapCode" style="width: 100px" class="req code_tbl" value="${item.itemCode}"/>
														<button class="btn_code_search2" onclick="openMaterialPopup(this, 'B')"></button>
													</Td>
													<Td><input type="text" name="itemName" style="width: 85%" readonly="readonly" class="read_only" value="${item.itemName}"/><button class="btn_code_info2"></button></Td>
													<Td><input type="text" name="itemBomAmount" style="width: 100%" class="read_only" onkeyup="calcBomAmountMix(this)" value="${item.bomAmount}"/></Td>
													<Td><input type="text" name="itemBomRate" style="width: 100%" class="req" value="${item.bomRate}" /></Td>
													<Td><input type="text" name="itemUnit" style="width: 100%" class="readonly" readonly="readonly" value="${item.unit}"/></Td>
													<Td><input type="text" name="itemWeight" style="width: 100%" class="req" onkeyup="caclWeight(this)" value="${item.weight}"/></Td>
													<Td><input type="text" name="itemPosnr" style="width: 100%" value="${item.posnr}"/></Td>
													<Td><input type="text" name="itemScrap" style="width: 80%" value="${item.scrap}"/>%</Td>
													<Td><input type="text" name="itemStorageCode" style="width: 100%; cursor: pointer" class="read_only" readonly="readonly" onclick="callDialog(event, 'dialog_storage')"/></Td>
												</Tr>
											</c:forEach>
										</tbody>
										<tfoot>
											<Tr>
												<Td colspan="3">합계</Td>
												<Td><input type="text" name="bomAmountTotal" style="width: 100%" readonly="readonly" class="read_only" value="${bomAmountTotal}"/></Td>
												<Td><input type="text" name="bomRateTotal" style="width: 100%" readonly="readonly" class="read_only" value="<fmt:formatNumber value='${bomRateTotal}' pattern='.000'></fmt:formatNumber>"/></Td>
												<Td>&nbsp;</Td>
												<Td><input type="text" name="itemWeightTotal" style="width: 100%" readonly="readonly" class="read_only" value="${weightTotal}"/></Td>
												<Td>&nbsp;</Td>
												<Td>&nbsp;</Td>
												<Td>&nbsp;</Td>
											</Tr>
										</tfoot>
									</table>
								</div>
							</c:forEach>
							<div name="addMixDiv" class="add_nomal_mix" onclick="addTable(this, 'mix')">
								<span><img src="/resources/images/btn_pop_add2.png"> 배합비 추가</span>
							</div>
						</div>
						<div class="tbl_in_title">▼ 내용물</div>
						<div class="tbl_in_con">
							<c:forEach items="${sub.cont}" var="cont" varStatus="baseStatus">
								<script>console.log('${cont}'')</script>
								<div class="nomal_mix">
									<div class="table_header02">
										<input type="hidden" name="baseType" value="CI"/>
										<span class="table_order_btn">
											<button class="btn_up" onclick="moveUp(this)"></button><button class="btn_down" onclick="moveDown(this)"></button>
										</span><span class="title" style="width:70%"><img
											src="/resources/images/img_table_header.png">&nbsp;&nbsp;내용물명 : <input
											type="text" name="baseName" style="width: 200px" value="${cont.baseName}" />&nbsp;분할중량 : <input
											type="text" name="divWeight" style="width: 50px" value="${cont.divWeight}" /> g <input
											type="text" name="divWeightTxt" style="width: 100px; border-color: #ab9e95;" value="${cont.divWeightTxt}" />
										</span><span class="table_header_btn_box">
											<button class="btn_del_table_header">내용물 삭제</button>
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
											<col width="8%">
											<col width="8%">
											<col width="8%">
											<col width="12%">
										</colgroup>
										<thead>
											<tr>
												<th><input type="checkbox" id="contentTable_${baseStatus.index}" onclick="checkAll(event)"><label for="contentTable_${baseStatus.index}"><span></span></label></th>
												<th>원료코드</th>
												<th>원료명</th>
												<th>배합%</th>
												<th>BOM수량</th>
												<th>단위</th>
												<th>중량g( <a href="javascript:;" name="copyBakery" onclick="copyBakery(this)">복제</a> )</th>
												<th>BOM항목</th>
												<th>스크랩</th>
												<th>저장위치</th>
											</tr>
										</thead>
										<tbody>
											<c:forEach items="${cont.item}" var="item" varStatus="itemStatus">
												<c:set var="bomRateTotal" value="${bomRateTotal + item.bomRate}"/>
												<c:set var="bomAmountTotal" value="${bomAmountTotal + item.bomAmount}"/>
												<c:set var="weightTotal" value="${weightTotal + item.weight}"/>
												<Tr id="contRow_${itemStatus.index}" class="temp_color">
													<Td><input type="checkbox" id="content_${itemStatus.index}"><label for="content_${itemStatus.index}"><span></span></label></Td>
													<Td>
														<input type="hidden" name="itemImNo" style="width: 100px" class="req code_tbl" value="${item.itemImNo}"/>
														<input type="text" name="itemSapCode" style="width: 100px" class="req code_tbl" value="${item.itemCode}"/>
														<button class="btn_code_search2" onclick="openMaterialPopup(this, 'B')"></button>
													</Td>
													<Td><input type="text" name="itemName" style="width: 85%" readonly="readonly" class="read_only" value="${item.itemName}"/><button class="btn_code_info2"></button></Td>
													<Td><input type="text" name="itemBomAmount" style="width: 100%" class="read_only" onkeyup="calcBomAmountMix(this)" value="${item.bomAmount}"/></Td>
													<Td><input type="text" name="itemBomRate" style="width: 100%" class="req" value="${item.bomRate}"/></Td>
													<Td><input type="text" name="itemUnit" style="width: 100%" class="readonly" readonly="readonly" value="${item.unit}"/></Td>
													<Td><input type="text" name="itemWeight" style="width: 100%" class="req" onkeyup="caclWeight(this)" value="${item.weight}"/></Td>
													<Td><input type="text" name="itemPosnr" style="width: 100%" value="${item.posnr}"/></Td>
													<Td><input type="text" name="itemScrap" style="width: 80%" value="${item.scrap}"/>%</Td>
													<Td><input type="text" name="itemStorageCode" style="width: 100%; cursor: pointer" class="read_only" readonly="readonly" onclick="callDialog(event, 'dialog_storage')"/></Td>
												</Tr>
											</c:forEach>
										</tbody>
										<tfoot>
											<Tr>
												<Td colspan="3">합계</Td>
												<Td><input type="text" name="bomAmountTotal" style="width: 100%" readonly="readonly" class="read_only" value="${bomAmountTotal}"/></Td>
												<Td><input type="text" name="bomRateTotal" style="width: 100%" readonly="readonly" class="read_only" value="<fmt:formatNumber value='${bomRateTotal}' pattern='.000'></fmt:formatNumber>"/></Td>
												<Td>&nbsp;</Td>
												<Td><input type="text" name="itemWeightTotal" style="width: 100%" readonly="readonly" class="read_only" value="${weightTotal}"/></Td>
												<Td>&nbsp;</Td>
												<Td>&nbsp;</Td>
												<Td>&nbsp;</Td>
											</Tr>
										</tfoot>
									</table>
								</div>
							</c:forEach>
							<div class="add_nomal_mix" onclick="addTable(this, 'content')">
								<span><img src="/resources/images/btn_pop_add3.png"> 내용물 추가</span>
							</div>
						</div>
					</div>
				</div>
			</c:forEach>
			--%>
			
			<!-- 원료 close --------------------------------------------------------------------------------------------------------------------------------------------------------->
			<!-- 표시사항 배합비 start --------------------------------------------------------------------------------------------------------------------------------------------------------->
			<div class="title5" style="float: left; margin-top: 30px;"><span class="txt">03. 표시사항 배합비</span></div>
			<%-- 
			<div class="title5" style="float: left; margin-top: 30px;">
				<span class="txt">
					03. 표시사항 배합비
					<ul class="list_ul3">
						<li><a href="javascript:changeAutoDisp(0)">직접입력</a></li><li class="select"><a href="javascript:changeAutoDisp(1)">자동계산</a></li>
					</ul>
					<input type="hidden" name="isAutoDisp" value="1"/>
				</span>
			</div>
			<div id="dispHeaderDiv" class="table_header07">
				<!-- 자동계산으로 넣을경우 바로 아래 span 값만 안보이게 할것 -->
				<span class="table_header_btn_box" style="display:none">
					<button class="btn_add_tr" onclick="addRow(this, 'disp')"></button><button class="btn_del_tr" onclick="removeRow(this)"></button>
				</span>
			</div>
			<table class="tbl05">
				<colgroup>
					<col width="20">
					<col width="30%">
					<col width="30%">
					<col />
				</colgroup>
				<thead>
					<tr>
						<th><input type="checkbox" id="dispTable_${dispStatus.index}" onclick="checkAll(event)"><label for="dispTable_${dispStatus.index}"><span></span></label></th>
						<th>원료명</th>
						<th>백분율</th>
						<th>급수포함</th>
					</tr>
				</thead>
				<tbody name="dispTbody">
					<c:forEach items="${mfgProcessDoc.disp}" var="disp" varStatus="dispStatus">
						<c:set var="excRateTotal" value="${excRateTotal + disp.excRate}"/>
						<c:set var="incRateTotal" value="${incRateTotal + disp.incRate}"/>
						<Tr>
							<Td><input type="checkbox" id="disp_${dispSutats.index}"><label for="disp_${dispSutats.index}"><span></span></label></Td>
							<Td>
								<input type="hidden" name="itemSapCode">
								<input type="text" name="matName" style="width: 80%" value="${disp.matName}" readonly="readonly"/>
							</Td>
							<Td><input type="text" name="excRate" style="width: 80%" value="${disp.excRate}" readonly="readonly"/></Td>
							<Td><input type="text" name="incRate" style="width: 80%" value="${disp.incRate}" readonly="readonly"/></Td>
						</Tr>
					</c:forEach>
				</tbody>
				<tfoot>
					<Tr>
						<Td><label for="c1"><span></span></label></Td>
						<Td>합계</Td>
						<Td><input type="text" style="width: 80%" readonly="readonly" class="read_only" value="<fmt:formatNumber pattern=".0" value="${excRateTotal}"/>"/></Td>
						<Td><input type="text" style="width: 80%" readonly="readonly" class="read_only" value="<fmt:formatNumber pattern=".0" value="${incRateTotal}"/>"/></Td>
					</Tr>
				</tfoot>
			</table>
			--%>
			
			
			<!-- 표시사항 배합비 close --------------------------------------------------------------------------------------------------------------------------------------------------------->
			<!-- 재료 start --------------------------------------------------------------------------------------------------------------------------------------------------------->
			<div class="title5" style="float: left; margin-top: 30px;">
				<span class="txt">04. 재료</span>
			</div>
			<div class="table_header07">
				<span class="table_order_btn">
					<button class="btn_up" onclick="moveUp(this)"></button><button class="btn_down" onclick="moveDown(this)"></button>
				</span>
				<span class="table_header_btn_box">
					<button class="btn_add_tr"  onclick="addRow(this, 'package')"></button><button class="btn_del_tr" onclick="removeRow(this)"></button>
				</span>
			</div>
			<table class="tbl05">
				<colgroup>
					<col width="20">
					<col width="140">
					<col />
					<col width="12%">
					<col width="8%">
					<col width="8%">
					<col width="8%">
					<col width="8%">
					<col width="8%">
					<col width="12%">
				</colgroup>
				<thead>
					<tr>
						<th><input type="checkbox" id="packageTable_1" onclick="checkAll(event)"><label for="packageTable_1"><span></span></label></th>
						<th>재료코드</th>
						<th>재료명</th>
						<th>재료사양</th>
						<th>단위</th>
						<th>BOM 수량</th>
						<th>BOM 단위</th>
						<th>BOM 항목</th>
						<th>스크랩</th>
						<th>저장위치</th>
					</tr>
				</thead>
				<tbody name="packageTbody">
					<c:forEach items="${mfgProcessDoc.pkg}" var="pkg" varStatus="pkgStatus">
						<Tr id="pkgRow_${pkgStatus.index}" class="temp_color">
							<Td><input type="checkbox" id="package_${pkgStatus.index}"><label for="package_${pkgStatus.index}"><span></span></label></Td>
							<Td>
								<input type="hidden" name="itemImNo" style="width: 100px" class="req code_tbl" value="${pkg.itemImNo}" />
								<input type="text" name="itemSapCode" style="width: 100px" class="req code_tbl" value="${pkg.itemCode}" />
								<button class="btn_code_search2" onclick="openMaterialPopup(this, 'R')"></button>
							</Td>
							<Td><input type="text" name="itemName" style="width: 85%" readonly="readonly" class="read_only" value='${pkg.itemName}'/><button class="btn_code_info2"></button></Td>
							<td><input type="text" name="itemBomAmount" style="width:80%" class="req code_tbl" value="${pkg.bomAmount}"><button class="btn_code_search3" onclick="openUnitDialog(event)"></button></td>
							<Td>
								<input type="text" name="itemOrgUnit" style="width: 100%" class="readonly" readonly="readonly" value="${pkg.orgUnit}"/>
								<input type="hidden" name="itemFomulaType"/>
							</Td>
							<td><input type="text" name="itemBomRate" style="width:100%" class="req" value="${pkg.bomRate}" ></td>
							<Td><input type="text" name="itemUnit" style="width: 100%" class="req" value="${pkg.unit}" /></Td>
							<Td><input type="text" name="itemPosnr" style="width: 100%" value="${pkg.posnr}" /></Td>
							<Td><input type="text" name="itemScrap" style="width: 80%" value="${pkg.scrap}" />%</Td>
							<Td><input type="text" name="itemStorageCode" style="width: 100%; cursor: pointer" class="read_only" readonly="readonly" onclick="callDialog(event, 'dialog_storage')"/></Td>
						</Tr>
					</c:forEach>
				</tbody>
			</table>
			<!-- 재료 close --------------------------------------------------------------------------------------------------------------------------------------------------------->
			<!-- 관련정보 start --------------------------------------------------------------------------------------------------------------------------------------------------------->
			<div class="title5" style="float: left; margin-top: 30px;">
				<span class="txt">05. 관련정보</span>
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
						<th style="border-left: none;">식품유형</th>
						<td colspan="3">${productDevDoc.productCategoryText}</td>
						</tr>
						<th style="border-left: none;">완제중량</th>
						<td>
							${mfgProcessDoc.compWeight}
						</td>
						<th>관리중량</th>
						<td>
							${mfgProcessDoc.adminWeightFrom} ${mfgProcessDoc.adminWeightUnitFrom}
							 ~ ${mfgProcessDoc.adminWeightTo} ${mfgProcessDoc.adminWeightUnitTo}
						</td>
						</tr>
						<tr>
							<th style="border-left: none;">표기중량</th>
							<td>
								${mfgProcessDoc.dispWeight}
							</td>
							<th>개별관리중량</th>
							<td>${mfgProcessDoc.distPeriSite}</td>
						</tr>
						<tr>
							<th style="border-left: none;">품목보고번호</th>
							<td>
								
								<c:if test="${mfgProcessDoc.regGubun == 'N'}">신규</c:if>
								<c:if test="${mfgProcessDoc.regGubun == 'E'}">기존</c:if>
								<c:if test="${mfgProcessDoc.regGubun == 'C'}">변경</c:if>
								&nbsp;${mfgProcessDoc.manufacturingNo}
							</td>
							<th>소비기한</th>
							<td>
								 등록서류: ${mfgProcessDoc.distPeriDoc}&nbsp;&nbsp;현장: ${mfgProcessDoc.distPeriSite}
							</td>
						</tr>
						<tr>
							<th style="border-left: none;">성상</th>
							<td>${mfgProcessDoc.ingredient}</td>
							<th>보관조건</th>
							<td>${mfgProcessDoc.keepCondition}</td>
						</tr>
						<tr>
							<th style="border-left: none;">용도용법</th>
							<td colspan="3">${mfgProcessDoc.usage}</td>
						</tr>
						<tr>
							<th style="border-left: none;">포장재질</th>
							<td colspan="3">${mfgProcessDoc.packMaterial}</td>
						</tr>
						<tr>
							<th style="border-left: none;">품목제조보고서 포장단위</th>
							<td colspan="3">${mfgProcessDoc.packUnit}</td>
						</tr>
						<tr>
							<th style="border-left: none;">어린이 기호식품 고열량 저영양 해당 유무</th>
							<td colspan="3">
								<c:if test="${mfgProcessDoc.childHarm == '1'}">예</c:if>
								<c:if test="${mfgProcessDoc.childHarm == '2'}">아니오</c:if>
								<c:if test="${mfgProcessDoc.childHarm == '3'}">해당 없음</c:if>
							</td>
						</tr>
						<tr>
							<th style="border-left: none;">비고</th>
							<td colspan="3">${mfgProcessDoc.note}</td>
						</tr>
						<!-- S201109-00014 -->
						<tr>
							<th style="border-left: none;">QNS 허들정보</th>
							<td>${mfgProcessDoc.qns}</td>
							<th style="border-left: none;"></th>
							<td></td>
						</tr>
					</tbody>
				</table>
			</div>
			<!-- 관련정보 close --------------------------------------------------------------------------------------------------------------------------------------------------------->
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
									<td style="border-left: none;">${fn:replace(mfgProcessDoc.menuProcess, enter, br)}</td>
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
									<td style="border-left: none;">${fn:replace(mfgProcessDoc.standard, enter, br)}</td>
								</tr>
							</tbody>
						</table>
					</div>
					<!-- 제조규격 close --------------------------------------------------------------------------------------------------------------------------------------------------------->
				</div>
			</div>
			<!-- 생산소모품 start --------------------------------------------------------------------------------------------------------------------------------------------------------->
			<div class="title5" style="float: left; margin-top: 30px;">
				<span class="txt">08. 생산 소모품</span>
			</div>
			<c:if test="${userUtil:getUserGrade(pageContext.request) == '3'}">
				<div class="table_header07">
					<span class="table_order_btn">
						<button class="btn_up" onclick="moveUp(this)"></button><button class="btn_down" onclick="moveDown(this)"></button>
					</span>
					<span class="table_header_btn_box">
						<button class="btn_add_tr" onclick="addRow(this, 'consume')"></button><button class="btn_del_tr" onclick="removeRow(this)"></button>
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
						<col width="8%">
						<col width="12%">
					</colgroup>
					<thead>
						<tr>
							<th><input type="checkbox" id="consTable_1" onclick="checkAll(event)"><label for="consTable_1"><span></span></label></th>
							<th>재료코드</th>
							<th>재료명</th>
							<th>BOM 수량</th>
							<th>BOM 단위</th>
							<th>BOM 항목</th>
							<th>스크랩</th>
							<th>저장위치</th>
						</tr>
					</thead>
					<tbody name="consumeTbody">
						<c:forEach items="${mfgProcessDoc.cons}" var="cons" varStatus="consStatus">
							<Tr id="consRow_1">
								<Td><input type="checkbox" id="consume_${consStatus.index}"><label for="consume_${consStatus.index}"><span></span></label></Td>
								<Td>
									<input type="hidden" name="itemImNo" style="width: 100px" class="req code_tbl" value="${cons.itemImNo}"/>
									<input type="text" name="itemSapCode" style="width: 100px" class="req code_tbl" value="${cons.itemCode}"/>
									<button class="btn_code_search2" onclick="openMaterialPopup(this, 'R')"></button>
								</Td>
								<Td>
									<input type="text" name="itemName" style="width: 85%" readonly="readonly" class="read_only" value="${cons.itemName}"/>
									<button class="btn_code_info2"></button>
								</Td>
								<Td><input type="text" name="itemBomRate" style="width: 100%" class="req" value="${cons.bomRate}"/></Td>
								<Td><input type="text" name="itemWeight" style="width: 100%" class="req" value="${cons.weight}" /></Td>
								<Td><input type="text" name="itemPosnr" style="width: 100%" value="${cons.posnr}"/></Td>
								<Td><input type="text" name="itemScrap" style="width: 80%" value="${cons.scrap}"/>%</Td>
								<Td><input type="text" name="itemStorageCode" style="width: 100%; cursor: pointer" class="read_only" readonly="readonly" onclick="callDialog(event, 'dialog_storage')"/></Td>
							</Tr>
						</c:forEach>
					</tbody>
				</table>
			</c:if>
			<!-- 생산소모품 close --------------------------------------------------------------------------------------------------------------------------------------------------------->
			<!-- 제품규격 start --------------------------------------------------------------------------------------------------------------------------------------------------------->
			<div class="title5" style="float: left; margin-top: 30px;">
				<span class="txt">09. 제품규격</span>
			</div>
			<div class="main_tbl">
				<table class="insert_proc01">
					<colgroup>
						<col width="12%">
						<col width="12%">
						<col />
						<col width="12%">
						<col width="12%">
						<col width="12%">
						<col width="12%">
					</colgroup>
					<tbody>
						<c:if test="${mfgProcessDoc.spec.size == '' or mfgProcessDoc.spec.size == null}">
							<c:if test="${mfgProcessDoc.spec.feature == '' or mfgProcessDoc.spec.size == feature}">
								<c:if test="${!mfgProcessDoc.spec.hasProduct and !mfgProcessDoc.spec.hasContent}">
									<c:if test="${mfgProcessDoc.spec.deoxidizer == '' or mfgProcessDoc.spec.deoxidizer == null}">
										<c:if test="${mfgProcessDoc.spec.nitrogenous == '' or mfgProcessDoc.spec.nitrogenous == null}">
											<tr>
												<td><p style="text-align: center">입력된 제품규격 정보가 없습니다.</p></td>
											</tr>
										</c:if>
									</c:if>
								</c:if>
							</c:if>
						</c:if>
						
						<c:if test="${mfgProcessDoc.spec.size != '' and mfgProcessDoc.spec.size != null}">
							<tr>
								<th>전체</th>
								<td>크기 </td>
								<td colspan="4">${mfgProcessDoc.spec.size}</td>
								<td>± ${mfgPRocessDoc.spec.sizeErr} %</td>
							</tr>
						</c:if>
						<c:if test="${mfgProcessDoc.spec.feature != '' and mfgProcessDoc.spec.size != feature}">
							<tr>
								<th>성상</th>
								<td>토핑,착색 </td>
								<td colspan="4">${mfgProcessDoc.spec.feature}</td>
								<td></td>
							</tr>
						</c:if>
						<c:if test="${mfgProcessDoc.spec.hasProduct or mfgProcessDoc.spec.hasContent}">
							<tr>
								<th rowspan="6">전체</th>
								<td>수분(%)</td>
								<td>${mfgProcessDoc.spec.productWater}</td>
								<th rowspan="6">내용물</th>
								<td>수분(%)</td>
								<td>${mfgProcessDoc.spec.contentWater}</td>
								<td>± ${mfgProcessDoc.spec.contentWaterErr}</td>
							</tr>
							<tr>
								<td>AW</td>
								<td>${mfgProcessDoc.spec.productAw}</td>
								<td>AW</td>
								<td>${mfgProcessDoc.spec.contentAw}</td>
								<td>± ${mfgProcessDoc.spec.contentAwErr}</td>
							</tr>
							<tr>
								<td>pH</td>
								<td>${mfgProcessDoc.spec.productPh}</td>
								<td>pH</td>
								<td>${mfgProcessDoc.spec.contentPh}</td>
								<td>± ${mfgProcessDoc.spec.contentPhErr}</td>
							</tr>
							<tr>
								<td>명도</td>
								<td>${mfgProcessDoc.spec.productBrightness}</td>
								<td>염도</td>
								<td>${mfgProcessDoc.spec.contentSalinity}</td>
								<td>± ${mfgProcessDoc.spec.contentSalinityErr}</td>
							</tr>
							<tr>
								<td>색도 </td>
								<td>${mfgProcessDoc.spec.productTone}</td>
								<td>당도</td>
								<td>${mfgProcessDoc.spec.contentBrix}</td>
								<td>± ${mfgProcessDoc.spec.contentBrixErr}</td>
							</tr>
							<tr>
								<td>Hardness </td>
								<td>${mfgProcessDoc.spec.productHardness}</td>
								<td>색도</td>
								<td>${mfgProcessDoc.spec.contentTone}</td>
								<td>± ${mfgProcessDoc.spec.contentToneErr}</td>
							</tr>
						</c:if>
						<c:if test="${mfgProcessDoc.spec.hasNoodles}">
							<tr>
								<th rowspan="3">국수(면류)<br /> * 주정침지제품에<br />한함.
								</th>
								<td>수분(%)</td>
								<td colspan="4">${mfgProcessDoc.spec.noodlesWater}</td>
								<td></td>
							</tr>
							<tr>
								<td>pH</td>
								<td colspan="4">${mfgProcessDoc.spec.noodlesPh}</td>
								<td></td>
							</tr>
							<tr>
								<td>산도</td>
								<td colspan="4">${mfgProcessDoc.spec.noodlesAcidity}</td>
								<td></td>
							</tr>
						</c:if>
						<c:if test="${mfgProcessDoc.spec.deoxidizer != '' and mfgProcessDoc.spec.deoxidizer != null}">
							<tr>
								<th style="border-left: none;" colspan="2">탈산소제</th>
								<td colspan="4">${mfgProcessDoc.spec.deoxidizer}</td>
								<td></td>
							</tr>
						</c:if>
						<c:if test="${mfgProcessDoc.spec.nitrogenous != '' and mfgProcessDoc.spec.nitrogenous != null}">
							<tr>
								<th style="border-left: none;" colspan="2">질소충전제품</th>
								<td colspan="4">${mfgProcessDoc.spec.nitrogenous}</td>
								<td></td>
							</tr>
						</c:if>
					</tbody>
				</table>
				<!-- 제품규격 close --------------------------------------------------------------------------------------------------------------------------------------------------------->
				<!-- 첨부파일 start --------------------------------------------------------------------------------------------------------------------------------------------------------->
				<!-- 
				<div class="fr pt50">
					<button class="btn_con_search" onClick="location.href='#open4'"><img src="/resources/images/icon_s_file.png" /> 파일첨부</button>
				</div>
				<div class="title5" style="float: left; margin-top: 30px;">
					<span class="txt">10. 첨부파일</span>
				</div>
				<div class="con_file fl" style="padding-bottom: 40px;">
					<ul>
						<li>
							<dt>1, 파일리스트</dt><dd>
								<ul>
									<li><a href="javascript:;">sample_filename_1</a> ( 2018-07-11 21:27:18 )
										<button class="btn_doc"><img src="/resources/images/icon_doc04.png"> 삭제</button>
									</li>
									<li><a href="javascript:;">sample_filename_2</a> ( 2018-07-11 21:27:18 )
										<button class="btn_doc"><img src="/resources/images/icon_doc04.png"> 삭제</button>
									</li>
								</ul>
							</dd>
						</li>
					</ul>
				</div>
				 -->
				<!-- 첨부파일 close --------------------------------------------------------------------------------------------------------------------------------------------------------->
				<div class="btn_box_con5">
					<button class="btn_admin_gray" onClick="goList()" style="width: 120px;">목록</button>
				</div>
				<div class="btn_box_con4">
					<!--
					<button class="btn_admin_red">임시/템플릿저장</button>
					<button class="btn_admin_navi">임시저장</button>
					-->
					<button class="btn_admin_sky" onclick="updateMfgProcessDocPackage()">저장</button>
					<button class="btn_admin_gray" onclick="goBack()">취소</button>
				</div>
				<hr class="con_mode" />
				<!-- 신규 추가 꼭 데려갈것 !-->
			</div>
		</div>
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

<!-- 단위환산 레이어 START -->
<div class="white_content" id="dialog_convert">
	<input type="hidden" id="targetRowId">
	<input type="hidden" id="targetUnitCalcType">
	<input type="hidden" id="targetUnitStdAmount">
	<input type="hidden" id="targetUnitValue">
	<div class="modal positionCenter" style="width: 650px;">
		<h5 style="position: relative">
			<span class="title">단위 환산</span>
			<div class="top_btn_box">
				<ul>
					<li>
						<button class="btn_madal_close" onClick="closeDialog('dialog_convert')"></button>
					</li>
				</ul>
			</div>
		</h5>
		<div class="list_detail">
			<ul>
				<li>
					<dt style="width: 20%">종류</dt>
					<dd style="width: 80%">
						<div class="selectbox req" style="width:25%">
                            <label for="selectUnitType">일반포장지(500m)</label>
                            <select id="selectUnitType" name="changeUnitType" onchange="changeConvertType(event)">
                            	<option value="1" selected>포장지(500m)</option>
                            	<option value="2">포장지(1000m)</option>
                            	<!-- 삭제요청 S201013-00009 
                            	<option value="6">포장지(1500m)</option>
                            	<option value="7">포장지(1800m)</option>
                            	 -->
                            	<option value="3">포장지(2000m)</option>
                            	<option value="4">와사오르-1줄</option>
                            	<option value="5">와사오르-2줄</option>
                            	<option value="8">트레이</option>
                            	<option value="9">밀지</option>
                            	<option value="10">내포장지(낱개포장)</option>
                            	<option value="11">박스</option>
                            </select>
                        </div>
					</dd>
				</li>
				<li>
					<dt style="width: 20%">수식</dt>
					<dd style="width: 80%" id="convertDD">
						기준수량() x 포장지 길이(<input type="text" id="convertUserValue" onkeyup="calcUnitChange(event)" style="width: 60px" class="req">mm) / 500,000mm
					</dd>
				</li>
				<li>
					<dt style="width: 20%">단위</dt>
					<dd style="width: 80%"><input type="text" id="convertResultUnit" style="width: 100px" class="read_only" readonly="readonly"></dd>
				</li>
				<li>
					<dt style="width: 20%">환산결과</dt>
					<dd style="width: 80%"><input type="text" id="convertResult" style="width: 100px" class="read_only" readonly="readonly"></dd>
				</li>
			</ul>
		</div>
		<div class="btn_box_con">
			<button class="btn_admin_red" onclick="setCovertResult()">적용</button>
			<button class="btn_admin_gray" onClick="closeDialog('dialog_convert')">취소</button>
		</div>
	</div>
</div>
<!-- 단위환산 레이어 END -->


<table id="pkgTable_temp" class="tbl05">
	<Tr id="pkgRow_temp" class="temp_color">
		<Td><input type="checkbox" id="package_1"><label for="package_1"><span></span></label></Td>
		<Td>
			<input type="hidden" name="itemImNo" style="width: 100px" class="req code_tbl"/>
			<input type="text" name="itemSapCode" style="width: 100px" class="req code_tbl" />
			<button class="btn_code_search2" onclick="openMaterialPopup(this, 'R')"></button>
		</Td>
		<Td><input type="text" name="itemName" style="width: 85%" readonly="readonly" class="read_only" /><button class="btn_code_info2"></button></Td>
		<td><input type="text" name="itemBomAmount" style="width:80%" class="req code_tbl"><button class="btn_code_search3" onclick="openUnitDialog(event)"></button></td>
		<Td>
			<input type="text" name="itemUnit" style="width: 100%" class="readonly" readonly="readonly"/>
			<input type="hidden" name="itemFomulaType"/>
		</Td>
		<td><input type="text" name="itemBomRate" style="width:100%" class="req"></td>
		<Td><input type="text" name="itemOrgUnit" style="width: 100%" class="req" /></Td>
		<Td><input type="text" name="itemPosnr" style="width: 100%" /></Td>
		<Td><input type="text" name="itemScrap" style="width: 80%"/>%</Td>
		<Td><input type="text" name="itemStorageCode" style="width: 100%; cursor: pointer" class="read_only" readonly="readonly" onclick="openStorageDialog(event, 'dialog_storage')"/></Td>
	</Tr>
</table>