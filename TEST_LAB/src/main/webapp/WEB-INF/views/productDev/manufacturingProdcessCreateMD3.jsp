<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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

<link href="/resources/css/mfg.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="/resources/js/jquery.auto-complete.js"></script>

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
		
		var calcType = '${calcType}';
		if(calcType != '10'){
			var manuProcessText = '원료분 생산'
				+'\n1. 원맥의 가수 및 수분함량(1차, 2차, 1B)을 체크 한다.'
				+'\n2. Milling 기기를 이용하여 분쇄하고, 가공상태(HMI, 스토크, 수율)를 체크한다.'
				+'\n3. 생산된 맥분에 대해 일반 성분 및 2차물성분석을 진행한다.'
				+'\n4. 밀가루 규격이탈시 가동정지 및 조치 규격이탈된 밀가루는 재분석 및 분리한다.'
				+'\n5. 생산된 맥분은 반제품 Silo로 이송하여 보관한다.'
				+'\n'
				+'\n제품생산'
				+'\n6. Silo에 보관된 원료 맥분을 필요에 따라 숙성기간을 거친 후 배합비율에 맞게 혼합한다.'
				+'\n7. 숙성 완료된 맥분을 혼합 후 체질 하여 자동포장한다.'
				+'\n* 벌크제품은 벌크차량에 상차 후 출하 한다.';
			$('textarea[name=menuProcess]').val(manuProcessText);
		}
	
		//setCalcType('${calcType}')
		
		loadCodeList( "PRODCAT1", "productType1" );
		
		//subProdTabBtn = '<a href="javascript:;">'+$('#subProdAddBtn_1').html()+'</a>';
		subProdTabBtn = '<li id="subProdAddBtn_1" class="select" onclick="changeTab(this)">'+$('#subProdAddBtn_1').html()+'</li>';
		
		subProdHead = '<div name="subProdHead">'+$('div[name=subProdHead]:first').html()+'</div>';
		subProdDiv = '<div name="subProdDiv">'+$('div[name=subProdDiv]:first').html()+'</div>'
		
		mixTable = '<div class="nomal_mix">'+$('div.nomal_mix:first').html()+'</div>';
		contentTable = '<div class="nomal_mix">'+$('div.nomal_mix:last').html()+'</div>';
		
		mixRow = '<tr>'+$('div.nomal_mix:first table tbody tr:first').html()+'</tr>';
		contentRow = '<tr>'+$('div.nomal_mix:last table tbody tr:first').html()+'</tr>';
		dispRow = '<tr>'+$('tbody[name=dispTbody]').children('tr').html()+'</tr>';
		packageRow = '<tr>'+$('tbody[name=packageTbody]').children('tr').html()+'</tr>';
		consumeRow = '<tr>'+$('tbody[name=consumeTbody]').children('tr').html()+'</tr>';
		
		/* 
		$('#productDesignCreateForm').on('submit', function(event){
			event.preventDefault();
		});
		*/
		loadCodeList( "KEEPCONDITION", "keepConditionCode" );
		
		//$('input[name=itemSapCode]').bind('keyup', function(e){ if(e.keyCode== 13) $(e.target).next().click() });
		
		/* 
		$('input[name=itemStorageCode]').each(function(i, element){
			addStorageAutocomplete(element);
		})
		*/
		
		
		//$('#mfg_company_select').change();
		$('#mfg_plant_select').change();
		/* var plantCode = '${plantCode}';
		if(plantCode.length > 0){
			$('#mfg_plant_select option[value='+plantCode+']').prop('selected',true);
			$('#mfg_plant_select').change();			
		} */
	});
	
	function setCalcType(calcType){
		if(calcType == '10'){
			$('input[name=mixWeight]').attr('readonly', false);
			$('input[name=mixWeight]').attr('class', 'req');
			$('input[name=bagAmout]').attr('readonly', false);
			$('input[name=bagAmout]').attr('class', 'req');
			
			$('div.nomal_mix').children('table').children('tbody').children('tr').children('td').children('input[name=itemBomRate]').attr('readonly', true);
			$('div.nomal_mix').children('table').children('tbody').children('tr').children('td').children('input[name=itemBomRate]').attr('class', 'read_only');
			
			$('div.nomal_mix').children('table').children('tbody').children('tr:first').children('td').children('input[name=itemBomAmount]').keyup();
			
			$('input[name=subProdStdAmount]').toArray().forEach(function(element){
				$(element).attr('readonly', true);
				$(element).attr('class', 'read_only');
			});
		} else if(calcType == '20'){
			$('input[name=mixWeight]').attr('readonly', true);
			$('input[name=mixWeight]').attr('class', 'read_only');
			$('input[name=bagAmout]').attr('readonly', true);
			$('input[name=bagAmout]').attr('class', 'read_only');
			
			//$('div.nomal_mix').children('table').children('tbody').children('tr').children('td').children('input[name=itemBomRate]').attr('readonly', true);
			//$('div.nomal_mix').children('table').children('tbody').children('tr').children('td').children('input[name=itemBomRate]').attr('class', 'read_only');
			
			$('div.nomal_mix').children('table').children('tbody').children('tr:first').children('td').children('input[name=itemBomAmount]').keyup();
			
			$('div.nomal_mix').children('table').children('tbody').children('tr').toArray().forEach(function(tr){
				var itemUnit = $(tr).children('td').children('input[name=itemUnit]').val();
				if(itemUnit == 'KG' || itemUnit == 'L'){
					$(tr).children('td').children('input[name=itemBomRate]').attr('readonly', true);
					$(tr).children('td').children('input[name=itemBomRate]').attr('class', 'read_only');
				} else {
					$(tr).children('td').children('input[name=itemBomRate]').attr('readonly', false);
					$(tr).children('td').children('input[name=itemBomRate]').attr('class', 'req');
				}
			})
			
			$('input[name=subProdStdAmount]').toArray().forEach(function(element){
				$(element).attr('readonly', false);
				$(element).attr('class', 'req');
			});
		} else if(calcType == '30'){
			$('input[name=mixWeight]').attr('readonly', true);
			$('input[name=mixWeight]').attr('class', 'read_only');
			$('input[name=bagAmout]').attr('readonly', true);
			$('input[name=bagAmout]').attr('class', 'read_only');
			$('input[name=numBong]').attr('class', '');
			$('input[name=numBox]').attr('class', '');
			$('input[name=numBox]').attr('class', '');
			$('input[name=loss]').attr('class', '');
			
			$('div.nomal_mix').children('table').children('tbody').children('tr').children('td').children('input[name=itemBomRate]').attr('readonly', false);
			$('div.nomal_mix').children('table').children('tbody').children('tr').children('td').children('input[name=itemBomRate]').attr('class', 'req');
			
			$('input[name=subProdStdAmount]').toArray().forEach(function(element){
				$(element).attr('readonly', true);
				$(element).attr('class', 'read_only');
			});
		} else {
			alert('Unvalid Type Error');
		}
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
					
					if(item.sapCode.indexOf('400023') == 0){
						$('#'+rowId + ' input[name=itemBomRate]').css('background-color', '#ffe8d9');
						$('#'+rowId + ' input[name=itemWeight]').css('background-color', '#ffe8d9');
					} else {
						$('#'+rowId + ' input[name=itemBomRate]').css('background-color', '#fff');
						$('#'+rowId + ' input[name=itemWeight]').css('background-color', '#fff');
					}
					$('#'+rowId + ' input[name=itemBomRate]').keyup();
					
					if(isExceptCode(item.sapCode)){
						$('#'+rowId + ' select[name=itemStorageCode]').attr('disabled', true);
						$('#'+rowId + ' select[name=itemStorageCode] option:first').prop('selected', true);
						$('#'+rowId + ' select[name=itemStorageCode]').change()
					} else {
						$('#'+rowId + ' select[name=itemStorageCode]').attr('disabled', false);
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
	
	/* 
	function addStorageAutocomplete(element){
		$(element).autoComplete({
			minChars: 2,
			delay: 100,
			cache: false,
			source: function(term, response){
				var companyCode = $('#mfg_company_select').val();;
				var plantCode= $('#mfg_plant_select').val();
				if(companyCode.length <= 0){
					return alert('회사를 선택해주세요');
				}
				if(plantCode.length <= 0){
					return alert('플랜트를 선택해주세요');
				}
				
				var storageList = JSON.parse('${storageList}')
				var filteredList = storageList.filter(function(storage){
					return (storage.companyCode == companyCode && storage.plantCode == plantCode && storage.storageCode.indexOf(term) >= 0);
				});
				
				response(filteredList)
			},
			renderItem: function (item, searchTerm){
				console.log(item, searchTerm)
			    return '<div class="autocomplete-suggestion" data-code="' + item.storageCode + '" data-nm="' + item.storageName + '" style="font-size: 0.8em">' + '[' + item.storageCode + ']'+ item.storageName + '</div>';
			},
			onSelect: function(e, term, item){
				$(element).val(item.data('code'))
			},
			focus: function(event, ui) {
		         return true;
			}	
		});
	}
	 */
	
	function bindEnterKeySapCode(element){
		$(element).bind('keyup', function(e){ if(e.keyCode== 13) $(e.target).next().click() });
	}
	
	function changeImportType(e){
		var docType = e.target.value;
		if(docType == 'design'){
			$('#dialog_create_li_design').show();
			$('#dialog_create_li_mfg').hide();
			
			$('#designDocSelectDiv').hide();
			$('#mfgDocSelectDiv').show();
		} else {
			$('#dialog_create_li_design').hide();
			$('#dialog_create_li_mfg').show();
			
			$('#designDocSelectDiv').show();
			$('#mfgDocSelectDiv').hide();
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
	
	function changeCalcType(e){
		var calcType = $('input[name=calcType]:checked').val();
		
		if(calcType == '10'){
			$('input[name=mixWeight]').attr('readonly', false);
			$('input[name=mixWeight]').attr('class', 'req');
			$('input[name=bagAmout]').attr('readonly', false);
			$('input[name=bagAmout]').attr('class', 'req');
			$('input[name=numBong]').attr('readonly', false);
			$('input[name=numBong]').attr('class', 'req');
			$('input[name=numBox]').attr('readonly', false);
			$('input[name=numBox]').attr('class', 'req');
			
			$('div.nomal_mix').children('table').children('tbody').children('tr').children('td').children('input[name=itemBomRate]').attr('readonly', true);
			$('div.nomal_mix').children('table').children('tbody').children('tr').children('td').children('input[name=itemBomRate]').attr('class', 'read_only');
			
			$('div.nomal_mix').children('table').children('tbody').children('tr:first').children('td').children('input[name=itemBomAmount]').keyup();
			
			$('input[name=subProdStdAmount]').toArray().forEach(function(element){
				$(element).attr('readonly', true);
				$(element).attr('class', 'read_only');
			});
		} else if(calcType == '20'){
			$('input[name=mixWeight]').attr('readonly', true);
			$('input[name=mixWeight]').attr('class', 'read_only');
			$('input[name=bagAmout]').attr('readonly', true);
			$('input[name=bagAmout]').attr('class', 'read_only');
			$('input[name=itemBomRate]').attr('readonly', true);
			
			$('div.nomal_mix').children('table').children('tbody').children('tr').children('td').children('input[name=itemBomRate]').attr('readonly', true);
			$('div.nomal_mix').children('table').children('tbody').children('tr').children('td').children('input[name=itemBomRate]').attr('class', 'read_only');
			
			$('div.nomal_mix').children('table').children('tbody').children('tr:first').children('td').children('input[name=itemBomAmount]').keyup();
			
			$('input[name=subProdStdAmount]').toArray().forEach(function(element){
				$(element).attr('readonly', false);
				$(element).attr('class', 'req');
			});
		} else if(calcType == '30'){
			$('input[name=mixWeight]').attr('readonly', true);
			$('input[name=mixWeight]').attr('class', 'read_only');
			$('input[name=bagAmout]').attr('readonly', true);
			$('input[name=bagAmout]').attr('class', 'read_only');
			$('input[name=numBong]').attr('class', '');
			$('input[name=numBox]').attr('class', '');
			$('input[name=loss]').attr('class', '');
			
			$('div.nomal_mix').children('table').children('tbody').children('tr').children('td').children('input[name=itemBomRate]').attr('readonly', false);
			$('div.nomal_mix').children('table').children('tbody').children('tr').children('td').children('input[name=itemBomRate]').attr('class', 'req');
			
			$('input[name=subProdStdAmount]').toArray().forEach(function(element){
				$(element).attr('readonly', true);
				$(element).attr('class', 'read_only');
			});
		} else {
			return alert('Unvalid Type Error');
		}
		//calcAll();
	}
	
	function setImportForm(calcType){
		if(calcType == '10'){
			$('input[name=mixWeight]').attr('readonly', false);
			$('input[name=mixWeight]').attr('class', 'req');
			$('input[name=bagAmout]').attr('readonly', false);
			$('input[name=bagAmout]').attr('class', 'req');
			$('input[name=numBong]').attr('readonly', false);
			$('input[name=numBong]').attr('class', 'req');
			$('input[name=numBox]').attr('readonly', false);
			$('input[name=numBox]').attr('class', 'req');
			
			
			$('input[name=subProdStdAmount]').toArray().forEach(function(element){
				$(element).val('');
				$(element).attr('readonly', true);
				$(element).attr('class', 'read_only');
			});
		} else if(calcType == '20'){
			$('input[name=mixWeight]').val('');
			$('input[name=mixWeight]').attr('readonly', true);
			$('input[name=mixWeight]').attr('class', 'read_only');
			$('input[name=bagAmout]').val('');
			$('input[name=bagAmout]').attr('readonly', true);
			$('input[name=bagAmout]').attr('class', 'read_only');
			
			$('input[name=subProdStdAmount]').toArray().forEach(function(element){
				$(element).val('');
				$(element).attr('readonly', false);
				$(element).attr('class', 'req');
			});
		} else if(calcType == '30'){
			$('input[name=mixWeight]').val('');
			$('input[name=mixWeight]').attr('readonly', true);
			$('input[name=mixWeight]').attr('class', 'read_only');
			$('input[name=bagAmout]').attr('readonly', true);
			$('input[name=bagAmout]').val('');
			$('input[name=bagAmout]').attr('class', 'read_only');
			
			$('input[name=subProdStdAmount]').toArray().forEach(function(element){
				$(element).val('');
				$(element).attr('readonly', true);
				$(element).attr('class', 'read_only');
			});
		} else {
			return alert('Unvalid Type Error');
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
		var calcType = $('input[name=calcType]:checked').val();
		
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
		
		if(itemSAPCode.indexOf('400023') == 0){
			$('#'+parentRowId + ' input[name*=itemBomRate]').css('background-color', '#ffe8d9');
			$('#'+parentRowId + ' input[name*=itemWeight]').css('background-color', '#ffe8d9');
		} else {
			$('#'+parentRowId + ' input[name*=itemBomRate]').css('background-color', '#fff');
			$('#'+parentRowId + ' input[name*=itemWeight]').css('background-color', '#fff');
		}
		$('#'+parentRowId + ' input[name*=itemBomRate]').keyup();
		
		/* if(itemUnit == 'KG' || itemUnit == 'L'){
			if(parentRowId.indexOf('cons') < 0){
				$('#'+parentRowId+' input[name=itemBomRate]').attr('readonly', true);
				$('#'+parentRowId+' input[name=itemBomRate]').attr('class', 'read_only');
				$('#'+parentRowId+' input[name=itemBomAmount]').keyup();
			}
		} else {
			if(parentRowId.indexOf('cons') < 0){
				$('#'+parentRowId+' input[name=itemBomRate]').attr('readonly', false);
				$('#'+parentRowId+' input[name=itemBomRate]').attr('class', 'req');
			}
		} */
		
		if(isExceptCode(itemSAPCode)){
			$('#'+parentRowId + ' select[name=itemStorageCode]').attr('disabled', true);
			$('#'+parentRowId + ' select[name=itemStorageCode] option:first').prop('selected', true);
			$('#'+parentRowId + ' select[name=itemStorageCode]').change()
		} else {
			$('#'+parentRowId + ' select[name=itemStorageCode]').attr('disabled', false);
		}
		
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
		
		var tempSubProdDiv = subProdDiv.replace(/mixTbody_1/gi, mixTableParentId);
		tempSubProdDiv = tempSubProdDiv.replace(/mixRow_1/gi, mixRowParentId);
		tempSubProdDiv = tempSubProdDiv.replace(/mix_1/gi, mixParentId);
		
		if($('div[name=subProdDiv]').length > 0) {
			$('div[name=subProdDiv]:last').after(tempSubProdDiv);
		} else {
			$(element).parent().parent().parent().after(tempSubProdDiv);
		}
		$('div[name=subProdDiv]:last').attr('id', 'subProdDiv_'+randomId);
		$('#subProdAddBtn_'+randomId).children('span').text('더블클릭하여 부속제품명 입력')
		$('#subProdAddBtn_'+randomId).children('input').val('더블클릭하여 부속제품명 입력')
		$('#subScroll')[0].scrollLeft = 99999;
		$('#subProdAddBtn_'+randomId).click()
		
		setSpecificId('tbody', mixTableParentId, Math.random().toString(36).substr(2, 9));
		setSpecificId('tr', mixRowParentId, Math.random().toString(36).substr(2, 9));
		setSpecificId('input', mixParentId, Math.random().toString(36).substr(2, 9));
		setUniqueId('input', 'mixTable_1');
		
		/* setUniqueId('input', 'mixTable_1');
		setUniqueId('input', 'contentTable_1');
		setUniqueId('input', 'mix_1');
		setUniqueId('input', 'content_1');
		setUniqueId('select', 'select_storage_mix_1');
		setUniqueId('select', 'select_origin_mix_1');
		setUniqueId('select', 'select_storage_content_1');
		
		changeCalcType();
		*/
		if($('div[id^=subProdDiv_]').length >= 4){
			$('#addSubProdA').hide();
		}
		
		$('select[id^=select_storage]').change(function(e){
		    var select_name = $(e.target).children("option:selected").text();
		    $(e.target).siblings("label").text(select_name);
		})
	}
	
	function setUniqueId(tagName, duplId){
		var parentId = $(tagName+'[id='+duplId+']:first').attr('id').split('_')[0]+'_';
		var randomId = Math.random().toString(36).substr(2, 9);
		
		var targetElement = $(tagName+'[id='+duplId+']:last');
		var targetLabelElement =$(tagName+'[id='+duplId+']:last').parent().children('label');
		
		targetElement.attr('id', parentId+randomId);
		targetLabelElement.attr('for', parentId+randomId);
	}
	
	function setSpecificId(tagName, parentId, specificId){
		var targetElement = $(tagName+'[id='+parentId+']');
		var targetLabelElement =$(tagName+'[id='+parentId+']').parent().children('label');
		
		targetElement.attr('id', parentId+specificId);
		targetLabelElement.attr('for', parentId+specificId);
	}
	
	function removeSubProduct(tabId){
		if($('div[id^=subProdDiv_]').length == 1){
			return alert('부속제품은 최소 1개 이상이어야 합니다.');
		}
		var subProdName = $('#subProdAddBtn_'+tabId).children('li').children('input[name=subProdName]').val();
		
		if(!confirm('부속제품['+subProdName+']을 삭제하시겠습니까?')){
			return;
		}
		
		$('#subProdAddBtn_'+tabId).remove();
		$('#subProdDiv_'+tabId).remove();
		$('a[id*=subProdAddBtn]:last li').click();
		
		if($('div[id^=subProdDiv_]').length < 4){
			$('#addSubProdA').show();
		}
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
		insertedTbody.children('tr').children('td').children('div').children('select[id^=select_storage]').attr('id', 'select_storage_'+type+'_'+randomId)
		
		$('select[id^=select_storage]').change(function(){
		    var select_name = $(this).children("option:selected").text();
		    $(this).siblings("label").text(select_name);
		})
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
		var bodyId = $(element).parent().parent().next().children('tbody').attr('id').split('_')[1];
		$(element).parent().parent().next().children('tbody').children('tr:last').attr('id', type + 'Row_' + bodyId + '_' + randomId);
		$(element).parent().parent().next().children('tbody').children('tr:last').children('td').children('input[type=checkbox]').attr('id', type+'_'+randomId);
		$(element).parent().parent().next().children('tbody').children('tr:last').children('td').children('label').attr('for', type+'_'+randomId);
		$(element).parent().parent().next().children('tbody').children('tr:last').children('td').children('div').children('select[id^=select_storage]').attr('id', 'select_storage_'+type+'_'+randomId);
		$(element).parent().parent().next().children('tbody').children('tr:last').children('td').children('div').children('label[id^=select_storage]').attr('id', 'select_storage_'+type+'_'+randomId);
		$(element).parent().parent().next().children('tbody').children('tr:last').children('td').children('div').children('label').attr('for', 'select_storage_'+type+'_'+randomId);
		//var itemSapCodeElement = $(element).parent().parent().next().children('tbody').children('tr:last').children('td').children('input[name=itemSapCode]');
		//bindEnterKeySapCode(itemSapCodeElement);
		
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
		
		$('select[id^=select_storage]').change(function(e){
		    var select_name = $(e.target).children("option:selected").text();
		    $(e.target).siblings("label").text(select_name);
		})
	}
	
	function removeRow(element){
		$(element).parent().parent().next().children('tbody').children('tr').toArray().forEach(function(v, i){
			var checkBoxId = $(v).children('td:first').children('input[type=checkbox]')[0].id;
			if($('#'+checkBoxId).is(':checked')) $(v).remove();
		})
		
		calcTableFooter(element);
		doDisp();
	}
	
	function calcTableFooter(element){
		var table = $(element).parent().parent().next();
		var rowCnt = table.children('tbody').children('tr').length;
		
		if(rowCnt > 0){
			table.children('tbody').children('tr:first').children('td').children('input[name=itemBomAmount]').keyup();
		} else {
			table.children('tfoot').children('tr').children('td').children('input[name=bomAmountTotal]').val(0);
			table.children('tfoot').children('tr').children('td').children('input[name=bomRateTotal]').val(0);
		}
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
	
	function changeMixWeight(element){
		clearNoNum(element);
		
		var subProdDivWeight = 0;
		$('input[name=mixWeight]').toArray().forEach(function(input){
			subProdDivWeight += Number($(input).val());
		})
		$(element).parent().parent().parent().parent().parent().parent().children('input[name=subProdDivWeight]:first').val(subProdDivWeight);
	}
	
	function validCalcAll(){
		var calcType = $('input[name=calcType]:checked').val();
		
		if(calcType == '10'){
			if($('input[name=mixWeight]').val() == null || $('input[name=mixWeight]').val() == ''){
				alert('배합KG을 입력하셔야 계산이 가능 합니다.');
				$('input[name=mixWeight]').focus();
				return false;
			}
			if($('input[name=bagAmout]').val() == null || $('input[name=bagAmout]').val() == ''){
				alert('포수를 입력하셔야 계산이 가능 합니다.');
				$('input[name=bagAmout]').focus();
				return false;
			}
			if($('input[name=bomRate]').val() == null || $('input[name=bomRate]').val() == ''){
				alert('BOM 수율을 입력하셔야 계산이 가능 합니다.');
				$('input[name=bomRate]').focus();
				return false;
			}
			if($('input[name=numBong]').val() == null || $('input[name=numBong]').val() == ''){
				alert('봉당 들이수를 입력하셔야 계산이 가능 합니다.');
				$('input[name=numBong]').focus();
				return false;
			}
			if($('input[name=numBox]').val() == null || $('input[name=numBox]').val() == ''){
				alert('상자 들이수를 입력하셔야 계산이 가능 합니다.');
				$('input[name=numBox]').focus();
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
			
			var contValid = true;
			var contElement;
			$('input[name=divWeight]').toArray().forEach(function(divWeight){
				if($(divWeight).val() == null || $(divWeight).val() == ''){
					contValid =  false;
					contElement = divWeight;
					return;
				}
			})
			
			if(!contValid){
				alert('내용물에 대한 분할 중량을 입력 하셔야 계산이 가능 합니다.');
				$(contElement).focus();
				return false;
			}
		}
		
		if(calcType == '20'){
			if($('input[name=bomRate]').val() == null || $('input[name=bomRate]').val() == ''){
				alert('BOM 수율을 입력하셔야 계산이 가능 합니다.');
				$('input[name=bomRate]').focus();
				return false;
			}
			if($('input[name=numBong]').val() == null || $('input[name=numBong]').val() == ''){
				alert('봉당 들이수를 입력하셔야 계산이 가능 합니다.');
				$('input[name=numBong]').focus();
				return false;
			}
			if($('input[name=numBox]').val() == null || $('input[name=numBox]').val() == ''){
				alert('상자 들이수를 입력하셔야 계산이 가능 합니다.');
				$('input[name=numBox]').focus();
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
			
			var contValid = true;
			var contElement;
			$('input[name=divWeight]').toArray().forEach(function(divWeight){
				if($(divWeight).val() == null || $(divWeight).val() == ''){
					contValid =  false;
					contElement = divWeight;
					return;
				}
			})
			
			if(!contValid){
				alert('내용물에 대한 분할 중량을 입력 하셔야 계산이 가능 합니다.');
				$(contElement).focus();
				return false;
			}
		}
		
		
		if(calcType == '20'){
			if($('input[name=bomRate]').val() == null || $('input[name=bomRate]').val() == ''){
				alert('BOM 수율을 입력하셔야 계산이 가능 합니다.');
				$('input[name=bomRate]').focus();
				return false;
			}
		}
		
		
		return true;
	}
	
	function calcAll(){
		validCalcAll();
		calcTotWeight();
		calcBomCall();
		//calcStdAmount();
		doDisp();
	}
	
	function calcTotWeight(){
		var totWeight = 0;
		
		// 부속제품 중량 합
		$('input[name=subProdDivWeight]').toArray().forEach(function(subProdWiehgt){
			totWeight += Number($(subProdWiehgt).val());
		});
		
		/* // 내용물 중량 합
		$('input[name=divWeight]').toArray().forEach(function(contWeight){
			totWeight += Number($(contWeight).val());
		}); */
		
		$('input[name=totWeight]').val(round(totWeight,3));
	}
	
	function calcBomCall(){
		//$('input[name=itemBomAmount]:first').keyup();
		
		$('div[name=subProdDiv]').toArray().forEach(function(sub, subIndex){
			var mixDiv = $(sub).children('div:last').children('div:nth-child(2)');
			var mixBody = mixDiv.children('div.nomal_mix').children('table').children('tbody');
			mixBody.toArray().forEach(function(tBody, tBodyIndex){
				$(tBody).children('tr').children('td').children('input[name=itemBomAmount]:first').keyup();
			})

			var contDiv = $(sub).children('div:last').children('div:nth-child(4)');
			var contBody = contDiv.children('div.nomal_mix').children('table').children('tbody');
			contBody.toArray().forEach(function(tBody, tBodyIndex){
				$(tBody).children('tr').children('td').children('input[name=itemBomAmount]:first').keyup();
			})
		})
		
	}
	
	function bomRateKeyup(element){
		clearNoNum(element);
		$(element).parent().prev().children('input').keyup();
	}
	
	function divWeightKeyup(e){
		if(e.keyCode == 13){
			var firstRow = $(e.target).parent().parent().next().children('tbody').children('tr:first');
			firstRow.children('td').children('input[name="itemBomAmount"]').keyup();
		}
	}
	
	function adjustNumber(numValue){
		if(!isNaN(numValue)){
			if(isFinite(numValue)){
				numValue = parseFloat(numValue.toFixed(3));
			} else {
				numValue = '';
			}
		} else {
			numValue = '';
		}
		return numValue;
	}
	
	function calcBomAmountMix(element){
		clearNoNum(element);
		$(element).parent().parent().children('td').children('input[name=itemWeight]').val($(element).val());
		
		// 문서의 타입과 관련하여 변수명은 calcType 으로 정의
		// 10: 일바제품
		// 20: 기준수량 기준 제품
		// 30: 크림제품
		
		// 30인 경우 BOM 배합비중을 계산하지 않는다.
		// 10, 20인 경우 각각의 배합비중 계산법이 존재
		// 10: 배합중량(Kg) * (베이커리/100)
		// 20: 부속제품분할중량 * 부속제품기준수량 * (베이커리/베이커리총합) / 1000 / (문서의BOM수율/100)
		
		var subProdHead = $(element).parent().parent().parent().parent().parent().parent().parent().prev();
		var subProdDivWeight = Number($(subProdHead).children().children('tbody').children().children('td').children('input[name=subProdDivWeight]').val());
		var subProdStdAmount = Number($(subProdHead).children().children('tbody').children().children('td').children('input[name=subProdStdAmount]').val());
		/* 
		var subProdHead = $('input[name=itemBomRate]:first').parent().parent().parent().parent().parent().parent().parent().prev();
		$(subProdHead).children().children('tbody').children().children('td').children('input')
		var subProdDivWeight = $(element).parent().parent().parent().parent().parent().parent().parent().prev().children('input[name=subProdDivWeight]').val();
		var subProdStdAmount = $(element).parent().parent().parent().parent().parent().parent().parent().prev().children('input[name=subProdStdAmount]').val();
		 */
		var productBomRatio = Number($('#productBomRatio').val());
		var calcType = $('input[name=calcType]:checked').val();
		calcType = calcType == '3' ? '10' : calcType;
		var tableBakeryTotal = 0;
		
		var subProdNdx = subProdHead.parent().attr('id').split('subProdDiv_')[1];
		var mixTbodyGroup = 'mixTbody_'+subProdNdx;
		$('tbody[id^='+mixTbodyGroup+']').toArray().forEach(function(tbody){
			$(tbody).children('tr').each(function(i, tr){
				tableBakeryTotal += Number($(tr).children('td').children('input[name=itemBomAmount]').val());
			})
		});

		$('tbody[id^='+mixTbodyGroup+']').toArray().forEach(function(tbody){
		    var bomRateTotal = 0;
		    var bomAmountTotal = 0;

		    if(calcType != "30"){
		    	$(tbody).children('tr').toArray().forEach(function(tr){
		            var itemBomAmount = Number($(tr).children('td').children('input[name=itemBomAmount]').val());
		            var itemBomRate;
		            var itemWeight;
		            var itemUnit = $(tr).children('td').children('input[name=itemUnit]').val();

		            if(calcType == "10"){
		                var mixWeight = $('input[name=mixWeight]').val();
		                itemBomRate = mixWeight*(itemBomAmount/100);
		            } else {
		                itemBomRate = subProdDivWeight * subProdStdAmount * (itemBomAmount / tableBakeryTotal) / 1000 / (productBomRatio / 100);
		            }

		            itemBomRate = adjustNumber(itemBomRate);
		            
		            if((itemUnit == "KG" || itemUnit == "L")){
		                $(tr).children('td').children('input[name=itemBomRate]').val(itemBomRate);
		            }

		            bomAmountTotal += Number(itemBomAmount);
		            bomRateTotal += Number(itemBomRate);
		        })
		    } else {m
		        $(element).parent().parent().parent().children('tr').toArray().forEach(function(tr){
		            var itemBomAmount = Number($(tr).children('td').children('input[name=itemBomAmount]').val());
		            var itemBomRate = Number($(tr).children('td').children('input[name=itemBomRate]').val());

		            bomAmountTotal += Number(itemBomAmount);
		            bomRateTotal += Number(itemBomRate);
		        })
		    }

		    var totalRow = $(tbody).next().children('tr');
		    

		    totalRow.children('td').children('input[name=bomRateTotal]').val(bomRateTotal.toFixed(3));
		    totalRow.children('td').children('input[name=bomAmountTotal]').val(adjustNumber(bomAmountTotal));
		    //totalRow.children('td').children('input[name=bomAmountTotal]').val(bomAmountTotal.toFixed(3));

		    $('input[name=subProdDivWeight]').toArray().forEach(function(subWeight){
		        $(subWeight).keyup();
		    })
		})
		
		doDisp();
	}
	
	function calcStdAmount(event){
		if(event.target.value == 0)
			return;
		if(event.target.value == null)
			return;
		var subProdTab = $(event.target).parent().parent().parent().parent().parent();
		var subProdStdAmountElement = $(event.target).parent().parent().children('td').children('input[name=subProdStdAmount]');
		var mix = subProdTab.next().children('div').children('div').children('div.table_header01');
		var cont = subProdTab.next().children('div').children('div').children('div.table_header02');
		//console.log($(event.target).parent().parent().parent().parent().parent().next().children('div').children('div.table_header05'));
		/*  
		* 부속제품 기준수량	(** 부속제품이 복수로 존재할 수 있음)
		* 10: BOM수량총합*1000(BOM수율/100)/부속제품분할중량
		* 20: 사용자입력값
		* 30: BOM수량총합*(BOM수율/100)
		*/
		
		var calcType = $('input[name=calcType]:checked').val();
		if(calcType == '3') calcType = '10'; 
		var mixBomRateTotal = 0;
		var bomRate = Number($('input[name=bomRate]').val());
		var subProdDivWeight = Number(event.target.value);
		
		if(calcType != 20){ // !20
			if(calcType == 10){ // 10
				mix.toArray().forEach(function(mixHeader){
					var bomRateTotal = $(mixHeader).next().children('tfoot').children('tr').children('td').children('input[name=bomRateTotal]').val();
					mixBomRateTotal += Number(bomRateTotal);
				})
				
				var subProdStdAmount = (mixBomRateTotal*1000*(bomRate/100)/subProdDivWeight).toFixed(1);
				
				if(subProdStdAmount != Infinity)
					subProdStdAmountElement.val(Math.floor(subProdStdAmount))
					//subProdStdAmountElement.val(subProdStdAmount.toFixed(3))
			} else { // 30
				mix.toArray().forEach(function(mixHeader){
					var bomRateTotal = $(mixHeader).next().children('tfoot').children('tr').children('td').children('input[name=bomRateTotal]').val();
					mixBomRateTotal += Number(bomRateTotal);
				})
				
				var subProdStdAmount = mixBomRateTotal*1000*(bomRate/100);
			
				if(subProdStdAmount != Infinity)
					subProdStdAmountElement.val(Math.floor(subProdStdAmount))
			}
		}
	}
	
	function calcBomAmountCont(element){
		clearNoNum(element);
		$(element).parent().parent().children('td').children('input[name=itemWeight]').val($(element).val())
		
		var subProdHead = $(element).parent().parent().parent().parent().parent().parent().parent().prev()
		
		var subProdDivWeight = $(subProdHead).children().children('tbody').children().children('td').children('input[name=subProdDivWeight]').val();
		var subProdStdAmount = $(subProdHead).children().children('tbody').children().children('td').children('input[name=subProdStdAmount]').val();
		
		var productBomRatio = $('#productBomRatio').val();
		var tableBakeryTotal = 0;
		$(element).parent().parent().parent().children('tr').toArray().forEach(function(tr){
			tableBakeryTotal += Number($(tr).children('td').children('input[name=itemBomRate]').val());
		})
		
		var calcType = $('input[name=calcType]:checked').val();
		var bomRateTotal = 0;
		var bomAmountTotal = 0;
		var contDivWeight = $(element).parent().parent().parent().parent().prev().children('span').children('input[name=divWeight]').val();
		
		/* var itemUnit = $(element).parent().parent().parent().children('tr').children('td').children('input[name=itemUnit]:first').val();
		if(!(itemUnit == "KG" || itemUnit == "L")){
			//console.log(itemUnit, " - !KG or !L 계산 안함")
			setBaseTotal();
			return
		} */
		
		if(calcType != "30"){
			// 부속제품 기준수량 * 내용물 분할중량 * (베이커리 / 내용물의 베이커리의 합) / 1000)
			$(element).parent().parent().parent().children('tr').toArray().forEach(function(tr){
				var itemBomAmount = Number($(tr).children('td').children('input[name=itemBomAmount]').val());
				bomAmountTotal += itemBomAmount;
			});
			
			$(element).parent().parent().parent().children('tr').toArray().forEach(function(tr){
				var itemBomAmount = $(tr).children('td').children('input[name=itemBomAmount]').val();
				var itemBomRate;
				var itemUnit = $(tr).children('td').children('input[name=itemUnit]').val();
				
				itemBomRate = subProdStdAmount * contDivWeight * (itemBomAmount/bomAmountTotal) / 1000 ;
				
				if((itemUnit == "KG" || itemUnit == "L")){
					$(tr).children('td').children('input[name=itemBomRate]').val(itemBomRate.toFixed(3));
					bomRateTotal += itemBomRate;
				}
			})
		} else {
			$(element).parent().parent().parent().children('tr').toArray().forEach(function(tr){
				var itemBomAmount = Number($(tr).children('td').children('input[name=itemBomAmount]').val());
				var itemBomRate = Number($(tr).children('td').children('input[name=itemBomRate]').val());
				
				bomAmountTotal += Number(itemBomAmount);
				bomRateTotal += Number(itemBomRate);
			})
		}
		var totalRow = $(element).parent().parent().parent().parent().children('tfoot').children('tr');
		totalRow.children('td').children('input[name=bomRateTotal]').val(bomRateTotal.toFixed(3));
		totalRow.children('td').children('input[name=bomAmountTotal]').val(bomAmountTotal.toFixed(3));
	}
	
	function calcDisp(e){
		/* if(e != undefined) {
			clearNoNum(e.target);
			var value =  e.target.value
			if(value.indexOf('.')>0 && value.substr(value.indexOf('.')+1).length > 2){
				e.target.value = e.target.value.substr(0, e.target.value.indexOf('.')+3)
			}
		} */
		
		var excRateTotal = 0;
		var incRateTotal = 0;
		
		$('#dispHeaderDiv').next().children('tbody').children('tr').toArray().forEach(function(tr){
			var excRate = Number($(tr).children('td').children('input[name=excRate]').val());
			var incRate = Number($(tr).children('td').children('input[name=incRate]').val());
			
			excRateTotal += excRate;
			incRateTotal += incRate;
		})
		
		excRateTotal = excRateTotal.toFixed(2);
		incRateTotal = incRateTotal.toFixed(2);
		
		
		var footer = $('#dispHeaderDiv').next().children('tfoot').children('tr');
		footer.children('td:nth-child(3)').children('input').val(excRateTotal);
		footer.children('td:nth-child(4)').children('input').val(incRateTotal);
	}
	
	//배열의 특정값의 인덱스 가지고 오기
	function getArrIdx(array , name, parcode) {
		var arrIdx = -1;
		for(i=0;i<array.length;i++){
			if(array[i].NAME == name) {
				if(parcode=="") { 
					arrIdx = i;
					break;
				} else {
					if(array[i].PARCODE == parcode) {
						arrIdx = i;
						break;						
					}
				}
			}
		}
		return arrIdx;
	}
	
	function isWaterCode(code) {
		var result = false;
		var waterCodes = ['P001', 'P10001']
		for ( var i = 0; i < waterCodes.length; i++ ) {
			if(code == waterCodes[i]) {
				result = true;
				break;
			}
		}
		return result
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
	
	function doDisp(){
		var calcType = $('input[name=calcType]:checked').val();
		if($('input[name=isAutoDisp]').val() != '1'){
			// 자동계산이 아닌 경우
			return;
		}
		$('#dispHeaderDiv').next().children('tbody').empty();
		if($('div[name=subProdDiv]').length > 1){
			// 부속제품이 2개 이상인 경우
			return;
		}

		var dispArray = []; //출력용 배열		
		if(calcType=="10" || calcType=="20") {
			var pecentArray = []; //배합과 각각 내용물들의 퍼센트 저장용 배열
			var calcArray = []; //계산용 배열		
			var mixDivWeight = parseFloat($("input[name=subProdDivWeight]").val()); // 첫번째 제품의 분할 중량 //195
			var prodCode = 'MI';
			var totDivWeightSum = mixDivWeight; //분할중량의 합.
			pecentArray.push({NAME: prodCode, PERCENT: 0, DIVWEIGHT: mixDivWeight, SUMINW:0, SUMEXW:0});
			//내용물별 분할 중량을 배열에 담고, 분할중량의 총합을 구함.
			$('input[name=divWeight]').toArray().forEach(function(input){
				var contDivWeight = parseFloat($(input).val());
				var parCode = $(input).parent().parent().next().children('tbody').attr('id');
				pecentArray.push({NAME: parCode, PERCENT: 0, DIVWEIGHT: contDivWeight, SUMINW:0, SUMEXW:0});
				totDivWeightSum += parseFloat($(input).val());
			})
			
			//배합과 각각의 내용물들의 퍼센트를 계산함.
			for(var i=0;pecentArray.length>i;i++) {
				var pecent = pecentArray[i].DIVWEIGHT/totDivWeightSum*100;  // 82.~~ 17.~~
				pecentArray[i].PERCENT = pecent;			
				//alert(pecent);
			}
			
			//배합과 각각의 내용물들의 중량의 합을 계산함.
			$("input[name='itemName']").each(function(index){
				var rowId = $(this).parent().parent().attr("id");
				if(!(rowId.indexOf('mix') >= 0 || rowId.indexOf('cont') >= 0)){
					return true;
				}
			
				// name이 itName 개수만큼 each문을 수행
				var dispName = $(this).val(); 
				if(dispName!="") {//제품명이 비어있지 않으면, 즉, item에서 조회된 데이터이면,
					var trId = $(this).parent().parent().attr("id"); //html 코딩이 바뀔경우 parent를 수정할 필요 있음.
					var itDisp  = $(this).val(); //표시명
					var itCode = $(this).parent().siblings('td').children('input[name=itemSapCode]').val();
					var itType  = "";
					if(trId.indexOf('mix')>=0) itType = 'MI';
					if(trId.indexOf('cont')>=0) itType = 'CI';
					var itWeight = parseFloat($(this).parent().siblings('td').children('input[name=itemWeight]').val());
					if( itDisp != "") 	dispName = itDisp; //표시명에 값이 있으면, 표시명을 이름으로 함.
					
					var parCode = itType; //원료의 부모코드
					if(itType=="MI") { //배합원료
						parCode = prodCode;
					} else if(itType=="CI") { //내용물 원료
						parCode = $(this).parent().parent().parent().attr('id');
					}
					
					var perIdx = getArrIdx(pecentArray , parCode, '');
					if(!isWaterCode(itCode)) pecentArray[perIdx].SUMEXW += itWeight; //급수 제외 중량 합산
					pecentArray[perIdx].SUMINW += itWeight; // 급수 포함 중량 합산				
					
					var arrIdx = getArrIdx(calcArray , dispName, parCode); //배열에서 인덱스를 찾음: 없으면 -1
					if (arrIdx == -1) {
						calcArray.push({NAME: dispName, CODE: itCode, WEIGHT: itWeight, PARCODE: parCode});
					} else {
						calcArray[arrIdx].WEIGHT += itWeight;
					}
				}
			});
			
			for(var i=0;i<calcArray.length;i++){
				var dispName = calcArray[i].NAME;
				var parCode = calcArray[i].PARCODE;
				var excRate  = 0;
				
				var perIdx = getArrIdx(pecentArray , parCode, '');
				
				var incRate = round(pecentArray[perIdx].PERCENT * calcArray[i].WEIGHT / pecentArray[perIdx].SUMINW,3); 
				if(!isWaterCode(calcArray[i].CODE)) { //급수코드이면, 퍼센트 값에는 값을 넣지 않는다.
					excRate = round(pecentArray[perIdx].PERCENT * calcArray[i].WEIGHT / pecentArray[perIdx].SUMEXW,3);
				}
				var arrIdx = getArrIdx(dispArray , dispName, ''); //배열에서 인덱스를 찾음: 없으면 -1
				if (arrIdx == -1) {
					dispArray.push({NAME: dispName, EXCRATE: excRate, INCRATE: incRate});
				} else {
					dispArray[arrIdx].INCRATE += incRate;
					dispArray[arrIdx].EXCRATE += excRate;
				}
			}
		} else { // calcType=="30" 인 경우
			var TOTEXW = 0;
			var TOTINW = 0;
			var calcArray = []; //계산용 배열
			
			$("input[name='itemName']").each(function(index){
				var rowId = $(this).parent().parent().attr("id");
				if(!(rowId.indexOf('mix') >= 0 || rowId.indexOf('cont') >= 0)){
					return true;
				}
				
				// name이 itName 개수만큼 each문을 수행
				var dispName = $(this).val(); 
				if(dispName!="") {//제품명이 비어있지 않으면, 즉, item에서 조회된 데이터이면,
					var trId = $(this).parent().parent().attr("id"); //html 코딩이 바뀔경우 parent를 수정할 필요 있음.
					var itDisp  = $(this).val(); //표시명
					var itCode = $(this).parent().siblings('td').children('input[name=itemSapCode]').val();
					var itType  = "";
					if(trId.indexOf('mix')>=0) itType = 'MI';
					if(trId.indexOf('cont')>=0) itType = 'CI';
					//var itWeight = parseFloat($(this).parent().siblings('td').children('input[name=itemWeight]').val());
					var itBomRate = parseFloat($(this).parent().siblings('td').children('input[name=itemBomRate]').val());
					var itWeight = itBomRate;
					
					if( itDisp != "") 	dispName = itDisp; //표시명에 값이 있으면, 표시명을 이름으로 함.
					
					var incWeight = itWeight;
					var excWeight = itWeight;
					
					if(!isWaterCode(itCode)) { 
						TOTEXW += itWeight; //급수 제외 중량 합산
					} else {
						excWeight = 0;
					}
					TOTINW += itWeight; // 급수 포함 중량 합산	
					
					var arrIdx = getArrIdx(calcArray , dispName, ''); //배열에서 인덱스를 찾음: 없으면 -1
					if (arrIdx == -1) {
						calcArray.push({NAME: dispName, EXCSUM: excWeight, INCSUM: incWeight});
					} else {
						calcArray[arrIdx].INCSUM += incWeight;
						calcArray[arrIdx].EXCSUM += excWeight;
					}
				}
			});
			
			//%를 계산
			for(var i=0;i<calcArray.length;i++){
				var dispName = calcArray[i].NAME;
				var excRate  = 0;
				var incRate = round(calcArray[i].INCSUM  / TOTINW * 100,5); 		// 급수포함
				var excRate = round(calcArray[i].EXCSUM  / TOTEXW * 100,5);	// 급수미포함
								
				var arrIdx = getArrIdx(dispArray , dispName, ''); //배열에서 인덱스를 찾음: 없으면 -1
				if (arrIdx == -1) {
					dispArray.push({NAME: dispName, EXCRATE: excRate, INCRATE: incRate});
				} else {
					dispArray[arrIdx].INCRATE += incRate;
					dispArray[arrIdx].EXCRATE += excRate;
				}
			}
		}
		
		var dispBody = $('tbody[name=dispTbody]');
		dispBody.children('tr').remove();

		var totalPerWithoutWater = 0;
		var totalPerWithWater = 0;
		
		dispArray.sort(SortByPecent);
		
		dispArray.forEach(function(v){
			dispBody.parent().prev().children('span').children('button.btn_add_tr').click()
			dispBody.children('tr:last').children('td').children('input[name=matName]').val(v.NAME);
			var excRate = v.EXCRATE;
			if(excRate=="0") {
				excRate = "";
			} else {
				excRate = round(excRate,5);
				totalPerWithoutWater += excRate;
			}
			var incRate  =  v.INCRATE;
			if(incRate=="0") {
				incRate = "";
			} else {
				incRate = round(incRate,5);
				totalPerWithWater += incRate;
			}
			dispBody.children('tr:last').children('td').children('input[name=excRate]').val(round(excRate,3));
			dispBody.children('tr:last').children('td').children('input[name=incRate]').val(round(incRate,3));
		})
		
		dispBody.next().children('tr').children('td').children('input:first').val(round(totalPerWithoutWater, 3));
		dispBody.next().children('tr').children('td').children('input:last').val(round(totalPerWithWater, 3));
	}
	
	/* function setDisp(){
		calcTotWeight();
		$('#dispHeaderDiv').next().children('tbody').empty();
		
		if($('input[name=isAutoDisp]').val() != '1'){
			// 자동계산이 아닌 경우
			return;
		}
		if($('div[name=subProdDiv]').length > 1){
			// 부속제품이 2개 이상인 경우
			return;
		}
		var dispArr = [];
		
		var mixPortion = Number($('input[name=subProdDivWeight]').val())/Number($('input[name=totWeight]').val());
		var mixDiv = $('div[name=subProdDiv]:last').children('div:last').children('div:nth-child(2)');
		var allMixBody = mixDiv.children('div.nomal_mix').children('table').children('tbody');
		
		var mixWeightTotal = 0;
		var mixWeightTotal2 = 0;
		
		allMixBody.children('tr').toArray().forEach(function(tr){
			var itemCode = $(tr).children('td').children('input[name=itemSapCode]').val();
			var itemBomAmount = $(tr).children('td').children('input[name=itemWeight]').val();
			
			mixWeightTotal += Number(itemBomAmount);
			mixWeightTotal2 += (['P10001', 'P001'].indexOf(itemCode) < 0 ? parseFloat(itemBomAmount) : 0)
		})
		allMixBody.children('tr').toArray().forEach(function(tr){
			var itemCode = $(tr).children('td').children('input[name=itemSapCode]').val();
			var itemName = $(tr).children('td').children('input[name=itemName]').val();
			var itemWeight = $(tr).children('td').children('input[name=itemWeight]').val();
			
			if(itemCode != '' && itemCode != null){
				var hasItem = false;
				
				dispArr.forEach(function(obj){
					if(obj.itemCode == itemCode){
						hasItem = true;
						obj.itemWeight += parseFloat(itemWeight);
						obj.tempWeight += (['P10001', 'P001'].indexOf(itemCode) < 0 ? parseFloat(itemWeight) : 0);
					}
				})
				
				if(!hasItem){
					dispArr.push({
						itemCode: itemCode
						, itemName: itemName
						, itemWeight: parseFloat(itemWeight)
						, tempWeight: (['P10001', 'P001'].indexOf(itemCode) < 0 ? parseFloat(itemWeight) : 0)
						, portion: mixPortion.toFixed(3)
						, totalWeight: mixWeightTotal
						, totalWeightWithoutWater: mixWeightTotal2
					});
				}
			}
		})
		
		var contPortion = Number($('input[name=subProdDivWeight]').val())/Number($('input[name=totWeight]').val());
		var contDiv = $('div[name=subProdDiv]:last').children('div:last').children('div:nth-child(4)');
		var allContBody = contDiv.children('div.nomal_mix').children('table').children('tbody');
		
		
		allContBody.toArray().forEach(function(tbody){
			var contPortion = Number($(tbody).parent().prev().children('span').children('input[name=divWeight]').val());
			contPortion = contPortion/Number($('input[name=totWeight]').val());
			
			var contWeightTotal = 0;
			var contWeightTotal2 = 0;
			$(tbody).children('tr').toArray().forEach(function(tr){
				var itemCode = $(tr).children('td').children('input[name=itemSapCode]').val();
				var itemWeight = $(tr).children('td').children('input[name=itemWeight]').val();
				
				contWeightTotal += Number(itemWeight);
				contWeightTotal2 += (['P10001', 'P001'].indexOf(itemCode) < 0 ? parseFloat(itemWeight) : 0);
			})
			$(tbody).children('tr').toArray().forEach(function(tr){
				var itemCode = $(tr).children('td').children('input[name=itemSapCode]').val();
				var itemName = $(tr).children('td').children('input[name=itemName]').val();
				var itemWeight = $(tr).children('td').children('input[name=itemWeight]').val();
				
				if(itemCode != '' && itemCode != null){
					var hasItem = false;
					
					dispArr.forEach(function(obj){
						if(obj.itemCode == itemCode){
							hasItem = true;
							obj.itemWeight += parseFloat(itemWeight);
							obj.tempWeight += (['P10001', 'P001'].indexOf(itemCode) < 0 ? parseFloat(itemWeight) : 0);
						}
					})
					
					if(!hasItem){
						dispArr.push({
							itemCode: itemCode
							, itemName: itemName
							, itemWeight: parseFloat(itemWeight)
							, tempWeight: (['P10001', 'P001'].indexOf(itemCode) < 0 ? parseFloat(itemWeight) : 0)
							, portion: contPortion.toFixed(3)
							, totalWeight : contWeightTotal
							, totalWeightWithoutWater: contWeightTotal2
						});
					}
				}
			})
		})
		
		dispArr.sort(function(a,b){
			return b.tempWeight*b.portion - a.tempWeight*a.portion;
		})
		
		var totalBomAmountWithoutWater = 0;
		var totalBomAmountWithWater = 0;
		
		var dispBody = $('tbody[name=dispTbody]');
		dispBody.children('tr').remove();
		
		var totalPerWithoutWater = 0;
		var totalPerWithWater = 0;
		
		dispArr.forEach(function(v){
			dispBody.parent().prev().children('span').children('button.btn_add_tr').click()
			dispBody.children('tr:last').children('td').children('input[name=itemSapCode]').val(v.itemCode);
			dispBody.children('tr:last').children('td').children('input[name=matName]').val(v.itemName);
			var excRate = v.tempWeight/v.totalWeightWithoutWater*v.portion*100
			var incRate = v.itemWeight/v.totalWeight*v.portion*100
			dispBody.children('tr:last').children('td').children('input[name=excRate]').val(excRate.toFixed(2));
			dispBody.children('tr:last').children('td').children('input[name=incRate]').val(incRate.toFixed(2));
			
			totalPerWithoutWater += excRate;
			totalPerWithWater += incRate;
		})
		dispBody.next().children('tr').children('td').children('input:first').val(totalPerWithoutWater.toFixed(2));
		dispBody.next().children('tr').children('td').children('input:last').val(totalPerWithWater.toFixed(2));
	} */
	
	function setDispRow(dispArr, itemCode){
		dispArr.forEach(function(obj){
			if(obj.itemCode == itemCode)
				return true;
		})
		return false;
	}
	
	function saveValid(){
		if($('textarea[name=memo]').val().length == 0){
			alert('설명을 입력하세요');
			$('textarea[name=memo]').focus();
			return false;
		}
		
		/* if( !chkNull($("#mfg_plantline_select").selectedValues()[0]) ) {
			alert('생산라인을 선택하세요.');
			$('select[id=mfg_plantline_select]').focus();
			return false;
		} */
		
		var calcType = $('input[name=calcType]:checked').val();
		/* if(calcType != '20'){
			if($('#mixWeight').val().length == 0){
				alert('배합중량을 입력하세요');
				$('#mixWeight').focus();
				return false;;
			}
			if($('input[name=bagAmout]').val().length == 0){
				alert('배합중량 포수를 입력하세요');
				$('input[name=bagAmout]').focus();
				return false;;
			}
		} */
		
		if($('input[name=bomRate]').val().length == 0){
			alert('BOM수율을 입력하세요');
			$('input[name=bomRate]').focus();
			return false;;
		}
		
		/* if($('input[name=docProdName]').val().length == 0){
			alert('품목제조보고서명을 입력하세요');
			$('input[name=docProdName]').focus();
			return false;;
		} */
		/* if($('input[name=subProdName]').val().length == 0){
			alert('부속제품명을 입력하세요');
			$('input[name=subProdName]').focus();
			return false;
		} */
		/* if( calcType != '30' ) {
			if($('input[name=subProdDivWeight]').val().length == 0){
				alert('부속제품 분할중량을 입력하세요');
				$('input[name=subProdDivWeight]').focus();
				return false;;
			}
		} */
		
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
		
		baseValid = true;
		if($('input[name=divWeight]').length > 0){
			$('input[name=divWeight]').toArray().forEach(function(contDivWeight){
				if(!baseValid) return;
				var divWeight = $(contDivWeight).val();
				if(divWeight.length <= 0){
					baseValid = false;
					$(contDivWeight).focus();
					alert('내용물의 분할중량을 입력해주세요');
					return;
				}
			})
		}
		if(!baseValid) return false;
		
		var mixValid = true;
		$('tr[id^=mixRow]').toArray().forEach(function(mixRow){
			if(!mixValid) return;
			
			var rowId = $(mixRow).attr('id');
			var itemSapCode = $('#'+ rowId + ' input[name=itemSapCode]').val();
			var itemName = $('#'+ rowId + ' input[name=itemName]').val();
			var itemBomAmount = $('#'+ rowId + ' input[name=itemBomAmount]').val();
			var itemWeight = $('#'+ rowId + ' input[name=itemWeight]').val();
			
			if(itemSapCode.length>0 || itemName.length>0 || itemBomAmount.length>0){
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
				/* if(itemBomAmount.length <= 0){
					mixValid = false;
					alert('배합%를 입력해주세요');
					return;
				} */
				/* if(itemWeight.length <= 0){
					mixValid = false;
					alert('중량을 입력해주세요');
					return;
				} */
			}
		})
		if(!mixValid) return false;
		
		var contValid = true;
		$('tr[id^=contentRow]').toArray().forEach(function(contRow){
			if(!contValid) return;
			
			var rowId = $(contRow).attr('id');
			var itemSapCode = $('#'+ rowId + ' input[name=itemSapCode]').val();
			var itemName = $('#'+ rowId + ' input[name=itemName]').val();
			var itemBomAmount = $('#'+ rowId + ' input[name=itemBomAmount]').val();
			var itemWeight = $('#'+ rowId + ' input[name=itemWeight]').val();
			
			if(itemSapCode.length>0 || itemName.length>0 || itemBomAmount.length>0){
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
				/* if(itemBomAmount.length <= 0){
					contValid = false;
					alert('배합%를 입력해주세요');
					return;
				} */
				/* if(itemWeight.length <= 0){
					contValid = false;
					alert('중량을 입력해주세요');
					return;
				} */
			}
		})
		if(!contValid) return false;
		
		
		var pkgValid = true;
		if($('tr[id^=pkgRow]').length > 0){
			$('tr[id^=pkgRow]').toArray().forEach(function(pkgRow){
				if(!pkgValid) return;
				
				var rowId = $(pkgRow).attr('id');
				var itemSapCode = $('#'+ rowId + ' input[name=itemSapCode]').val();
				var itemName = $('#'+ rowId + ' input[name=itemName]').val();
				var itemBomAmount = $('#'+ rowId + ' input[name=itemBomAmount]').val();
				var itemBomRate = $('#'+ rowId + ' input[name=itemBomRate]').val();
				
				if(itemSapCode.length >0 || itemName.length>0 || itemBomRate>0){
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
					if(itemBomAmount.length <= 0){
						pkgValid = false;
						alert('재료사양을 입력해주세요');
						return;
					}
					if(itemBomRate.length <= 0){
						pkgValid = false;
						alert('BOM수량을 입력해주세요');
						return;
					}
				}
			})
		}
		if(!pkgValid) return false;
		
		
		if($('input[name=compWeight]').val().length == 0){
			alert('완제중량을 입력하세요');
			$('input[name=compWeight]').focus();
			return false;
		}
		
		if($('input[name=dispWeight]').val().length == 0){
			alert('관리중량을 입력하세요');
			$('input[name=dispWeight]').focus();
			return false;
		}
		
		if($('input[name=ingredient]').val().length == 0){
			alert('성상을 입력하세요');
			$('input[name=ingredient]').focus();
			return false;
		}
		
		if($('#keepConditionCode').val().length == 0){
			alert('보관조건을 선택하세요');
			$('#keepConditionCode').focus();
			return false;
		} else {
			if($('input[name=keepCondition]').val() == '7'){
				alert('보관조건 텍스트를 선택하세요');
				$('input[name=keepCondition]').focus();
				return false;
			}
		}
		
		if($('input[name=usage]').val().length == 0){
			alert('용도용법을 입력하세요');
			$('input[name=usage]').focus();
			return false;
		}
		
		if($('input[name=packMaterial]').val().length == 0){
			alert('포장재질을 입력하세요');
			$('input[name=packMaterial]').focus();
			return false;
		}
		
		return true;
	}
	
	function saveMfgProcessDoc(state){
		if(!confirm('제조공정서를 ' + (state == '7' ? '임시저장' : '저장') + '하시겠습니까?')){
			return;
		}
		
		if(state != '7'){
			if(!saveValid()){
				return;
			}
		}
		
		var docNo = '${docNo}';
		var docVersion = '${docVersion}';
		$.post('saveManufacturingProcessDoc', getPostData(state), function(data){
			if(data == 'S') {
				alert('문서 생성 완료');
				location.href = '/dev/productDevDocDetail?docNo='+docNo+'&docVersion='+docVersion
			} else {
				alert('문서 생성 실패[1] - 시스템 담당자에게 문의해주세요');
			}
			
		}).fail(function(res){
			//console.log('Error: ' + res.responseText)
			alert('문서 생성 실패[2] - 시스템 담당자에게 문의해주세요');
		})
	}
	
	function setBaseTotal(){
		$('div[name=subProdDiv]').toArray().forEach(function(subProd, subProdNdx){
			var mixDiv = $(subProd).children('div:last').children('div:nth-child(2)').children('div.nomal_mix');
			var contDiv = $(subProd).children('div:last').children('div:nth-child(4)').children('div.nomal_mix');
			
			// 배합(table)
			mixDiv.toArray().forEach(function(mix, mixNdx){
				
				mixBody = $(mix).children('table');
				
				var bomRateTotal = 0;
				var bomAmountTotal = 0;
				var weightTotal = 0;
				
				mixBody.children('tbody').children('tr').toArray().forEach(function(item, itemNdx){
					var bomRate = $(item).children('td').children('input[name=itemBomRate]').val();
					var bomAmount = $(item).children('td').children('input[name=itemBomAmount]').val();
					var weight = $(item).children('td').children('input[name=itemWeight]').val();
					
					bomRateTotal += Number(bomRate);
					bomAmountTotal += Number(bomAmount);
					weightTotal += Number(weight);
				})
				
				mixBody.children('tfoot').children('tr').children('td').children('input[name=bomRateTotal]').val(bomRateTotal.toFixed(3))
				mixBody.children('tfoot').children('tr').children('td').children('input[name=bomAmountTotal]').val(bomAmountTotal.toFixed(3));
				//mixBody.children('tfoot').children('tr').children('td').children('input[name=itemWeightTotal]').val(weightTotal.toFixed(3));
				
			})
			
			//내용물(table)
			contDiv.toArray().forEach(function(cont, contNdx){
				
				contBody = $(cont).children('table');
				
				var bomRateTotal = 0;
				var bomAmountTotal = 0;
				var weightTotal = 0;
				
				contBody.children('tbody').children('tr').toArray().forEach(function(item, itemNdx){
					var bomRate = $(item).children('td').children('input[name=itemBomRate]').val();
					var bomAmount = $(item).children('td').children('input[name=itemBomAmount]').val();
					var weight = $(item).children('td').children('input[name=itemWeight]').val();
					
					bomRateTotal += Number(bomRate);
					bomAmountTotal += Number(bomAmount);
					weightTotal += Number(weight);
				})
				
				contBody.children('tfoot').children('tr').children('td').children('input[name=bomRateTotal]').val(bomRateTotal.toFixed(3))
				contBody.children('tfoot').children('tr').children('td').children('input[name=bomAmountTotal]').val(bomAmountTotal.toFixed(3));
				//contBody.children('tfoot').children('tr').children('td').children('input[name=itemWeightTotal]').val(weightTotal.toFixed(3));
				
			})
		})
	}
	
	function getPostData(state){
		var postData = {};
		
		// 기준정보
		postData['dNo'] = '${dNo}';
		postData['docNo'] = '${docNo}';
		postData['docVersion'] = '${docVersion}';
		postData['state'] = state;
		postData['docType'] = 'N'; // N: 일반,  E: 엑셀
		postData['calcType'] = $('input[name=calcType]:checked').val();
		postData['companyCode'] = $('#mfg_company_select').val();
		postData['memo'] = $('textarea[name=memo]').val();
		postData['plantCode'] = $('#mfg_plant_select').val();
		postData['plantName'] = $('#mfg_plant_select option:selected').text();
		//postData['stdAmount'] = $('input[name=stdAmount]').val();
		postData['stdAmount'] = $('input[name=subProdStdAmount]').val();
		var lineCode = $('#mfg_plantline_select').val();
		postData['lineCode'] =lineCode;
		if(lineCode != ''){
			postData['lineName'] = '';
		} else {
			postData['lineName'] = $('#mfg_plantline_select option:selected').text();
		}
		//postData['mixWeight'] = $('input[name=mixWeight]').val();
		postData['mixWeight'] = $('input[name=subProdStdAmount]').val();
		postData['bagAmout'] = $('input[name=bagAmout]').val();
		postData['bomRate'] = $('input[name=bomRate]').val();
		postData['numBong'] = $('input[name=numBong]').val();
		postData['numBox'] = $('input[name=numBox]').val();
		postData['totWeight'] = $('input[name=totWeight]').val();
		postData['docProdName'] = $('input[name=docProdName]').val();
		postData['loss'] = $('input[name=loss]').val();
		postData['compWeight'] = $('input[name=compWeight]').val();
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
		postData['childHarm'] = $('input[name=childHarm]:checked').val()
		postData['noteText'] = $('textarea[name=noteText]').val();
		postData['menuProcess'] = $('textarea[name=menuProcess]').val();
		postData['standard'] = $('textarea[name=standard]').val();
		postData['stlal'] = $('input[name=stlal]').val();
		postData['isAutoDisp'] = $('input[name=isAutoDisp]').val();
		postData['adminWeightFrom'] =  $('input[name=adminWeightFrom]').val();
		postData['adminWeightUnitFrom'] = $('#select_adminWeightUnitFrom').val();
		postData['adminWeightTo'] = $('input[name=adminWeightTo]').val();
		postData['adminWeightUnitTo'] = $('#select_adminWeightUnitTo').val();
		postData['lineProcessType'] = $('select[name=lineProcessType]').val();
		postData['usage'] = $('input[name=usage]').val();
		postData['packMaterial'] = $('input[name=packMaterial]').val();
		postData['qns'] = $('input[name=qns]').val();
		
		
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
			
			// 배합(table)
			mixDiv.toArray().forEach(function(mix, mixNdx){
				var path = 'sub['+subProdNdx+'].mix['+mixNdx+'].';
				
				mixHead = $(mix).children('div');
				mixBody = $(mix).children('table');
				
				postData[path+'baseType'] = mixHead.children('input[name=baseType]').val();
				postData[path+'baseName'] = mixHead.children('span.title').children('input[name=baseName]').val();
				
				mixBody.children('tbody').children('tr').toArray().forEach(function(item, itemNdx){
					var itemImNo = $(item).children('td').children('input[name=itemImNo]').val();
					var sapCode = $(item).children('td').children('input[name=itemSapCode]').val();
					var itemName = $(item).children('td').children('input[name=itemName]').val();
					var bomAmount = $(item).children('td').children('input[name=itemBomAmount]').val();
					//var itemWeight = $(item).children('td').children('input[name=itemWeight]').val();
				
					if(sapCode.length>0 || itemName.length>0 || bomAmount.length>0){
						var propPath = 'sub['+subProdNdx+'].mix['+mixNdx+'].item['+itemNdx+'].';
						setPostItem(postData, propPath, item, itemNdx);
					}
				})
				var baseBakerySum = mixBody.children('tfoot').children('tr').children('td').children('input[name=bomAmountTotal]').val();
				var baseBomRateSum = mixBody.children('tfoot').children('tr').children('td').children('input[name=bomRateTotal]').val();
				
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
					var sapCode = $(item).children('td').children('input[name=itemSapCode]').val();
					var itemName = $(item).children('td').children('input[name=itemName]').val();
					var bomAmount = $(item).children('td').children('input[name=itemBomAmount]').val();
					//var itemWeight = $(item).children('td').children('input[name=itemWeight]').val();
				
					if(sapCode.length>0 || itemName.length>0 || bomAmount.length>0){
						var propPath = 'sub['+subProdNdx+'].cont['+contNdx+'].item['+itemNdx+'].';
						setPostItem(postData, propPath, item, itemNdx)
					}
				})
				
				var baseBakerySum = contBody.children('tfoot').children('tr').children('td').children('input[name=bomAmountTotal]').val();
				var baseBomRateSum = contBody.children('tfoot').children('tr').children('td').children('input[name=bomRateTotal]').val();
				
				postData[contPath+'baseBakerySum'] = baseBakerySum;
				postData[contPath+'baseBomRateSum'] = baseBomRateSum;
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
			var sapCode = $(pkg).children('td').children('input[name=itemSapCode]').val();
			var itemName = $(pkg).children('td').children('input[name=itemName]').val();
		
			if(sapCode.length>0 || itemName.length>0){
				var pkgPath = 'pkg['+pkgNdx+'].';
				setPostItem(postData, pkgPath, pkg, pkgNdx)
			}
		})
		
		// 생산소모품
		$('tbody[name=consumeTbody]').children('tr').toArray().forEach(function(cons, consNdx){
			var sapCode = $(cons).children('td').children('input[name=itemSapCode]').val();
			var itemName = $(cons).children('td').children('input[name=itemName]').val();
		
			if(sapCode.length>0 || itemName.length>0){
				var consPath = 'cons['+consNdx+'].'
				setPostItem(postData, consPath, cons, consNdx)
			}
		});
		
		// 제품규격
		postData['spec.size'] = $('tbody[name=specTbody] input[name=size]').val();
		postData['spec.sizeErr'] = $('tbody[name=specTbody] input[name=sizeErr]').val();
		postData['spec.feature'] = $('tbody[name=specTbody] input[name=feature]').val();
		postData['spec.productWater'] = $('tbody[name=specTbody] input[name=productWater]').val();
		postData['spec.productAw'] = $('tbody[name=specTbody] input[name=productAw]').val();
		postData['spec.productPh'] = $('tbody[name=specTbody] input[name=productPh]').val();
		postData['spec.productTone'] = $('tbody[name=specTbody] input[name=productTone]').val();
		postData['spec.productBrightness'] = $('tbody[name=specTbody] input[name=productBrightness]').val();
		postData['spec.productHardness'] = $('tbody[name=specTbody] input[name=productHardness]').val();
		postData['spec.contentWater'] = $('tbody[name=specTbody] input[name=contentWater]').val();
		postData['spec.contentWaterErr'] = $('tbody[name=specTbody] input[name=contentWaterErr]').val();
		postData['spec.contentAw'] = $('tbody[name=specTbody] input[name=contentAw]').val();
		postData['spec.contentAwErr'] = $('tbody[name=specTbody] input[name=contentAwErr]').val();
		postData['spec.contentPh'] = $('tbody[name=specTbody] input[name=contentPh]').val();
		postData['spec.contentPhErr'] = $('tbody[name=specTbody] input[name=contentPhErr]').val();
		postData['spec.contentBrix'] = $('tbody[name=specTbody] input[name=contentBrix]').val();
		postData['spec.contentBrixErr'] = $('tbody[name=specTbody] input[name=contentBrixErr]').val();
		postData['spec.contentSalinity'] = $('tbody[name=specTbody] input[name=contentSalinity]').val();
		postData['spec.contentSalinityErr'] = $('tbody[name=specTbody] input[name=contentSalinityErr]').val();
		postData['spec.contentTone'] = $('tbody[name=specTbody] input[name=contentTone]').val();
		postData['spec.contentToneErr'] = $('tbody[name=specTbody] input[name=contentToneErr]').val();
		postData['spec.noodlesWater'] = $('tbody[name=specTbody] input[name=noodlesWater]').val();
		postData['spec.noodlesPh'] = $('tbody[name=specTbody] input[name=noodlesPh]').val();
		postData['spec.noodlesAcidity'] = $('tbody[name=specTbody] input[name=noodlesAcidity]').val();
		postData['spec.deoxidizer'] = $('tbody[name=specTbody] input[name=deoxidizer]').val();
		postData['spec.nitrogenous'] = $('tbody[name=specTbody] input[name=nitrogenous]').val();
		
		// 제품규격(밀다원)
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
		postData[propPath+'orgUnit'] = $(item).children('td').children('input[name=itemOrgUnit]').val();;
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
		if(isAuto == $('input[name=isAutoDisp]').val()) return;
		
		if(isAuto == '1'){
			if(!confirm("자동계산을 선택 하시면, 변경하신 배합비가 모두 없어집니다. 그래도 선택 하시겠습니까?")){
				return;
			}
		}
		
		if(isAuto == '0'){
			if(!confirm("자동계산을 해제 하시면, 배합의 내용의 변경이 반영되지 않습니다. 그래도 선택 하시겠습니까?")){
				return;
			}
		}
		
		$('input[name=isAutoDisp]').val(isAuto);
		if(isAuto == 1){
			$('input[name=isAutoDisp]').prev().children('li:first').attr('class', '');
			$('input[name=isAutoDisp]').prev().children('li:last').attr('class', 'select');
			
			doDisp();
			$('input[name=isAutoDisp]').parent().parent().next().children().css('display', 'none')
			
			var dispTable = $('#dispHeaderDiv').next();
			dispTable.children('tbody').children('tr').toArray().forEach(function(tr){
				$(tr).children('td').children('input[name=matName]').attr('readonly', true);
				$(tr).children('td').children('input[name=matName]').attr('class', 'read_only');
				$(tr).children('td').children('input[name=excRate]').attr('readonly', true);
				$(tr).children('td').children('input[name=excRate]').attr('class', 'read_only');
				$(tr).children('td').children('input[name=incRate]').attr('readonly', true);
				$(tr).children('td').children('input[name=incRate]').attr('class', 'read_only');
			})
		} else {
			$('input[name=isAutoDisp]').prev().children('li:first').attr('class', 'select');
			$('input[name=isAutoDisp]').prev().children('li:last').attr('class', '');
			
			$('input[name=isAutoDisp]').parent().parent().next().children().css('display', 'block')
			
			var dispTable = $('#dispHeaderDiv').next();
			dispTable.children('tbody').children('tr').toArray().forEach(function(tr){
				$(tr).children('td').children('input[name=matName]').attr('readonly', false);
				$(tr).children('td').children('input[name=matName]').attr('class', '');
				$(tr).children('td').children('input[name=excRate]').attr('readonly', false);
				$(tr).children('td').children('input[name=excRate]').attr('class', '');
				$(tr).children('td').children('input[name=incRate]').attr('readonly', false);
				$(tr).children('td').children('input[name=incRate]').attr('class', '');
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
	
	function calcWeight(element){
		clearNoNum(element);
		
		var tBody = $(element).parent().parent().parent();
		
		var amountTotal = 0;
		tBody.children('tr').toArray().forEach(function(tr, i){
			amountTotal += Number($(tr).children('td').children('input[name=itemWeight]').val());
		});
		
		//var totalRow = tBody.next().children('tr');
		//$(totalRow).children('td').children('input[name=itemWeightTotal]').val(amountTotal.toFixed(3));
	}
	
	function copyBakery(element){
		var amountTotal = 0;
		
		var tBody = $(element).parent().parent().parent().next();
		tBody.children('tr').toArray().forEach(function(tr, i){
			var bakery = $(tr).children('td').children('input[name=itemBomAmount]').val();
			$(tr).children('td').children('input[name=itemWeight]').val(bakery);
			
			amountTotal += Number(bakery);
		});
		
		//var totalRow = $(element).parent().parent().parent().next().next().children('tr');
		//$(totalRow).children('td').children('input[name=itemWeightTotal]').val(amountTotal.toFixed(3));
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
				alert('자재검색 실패[2] - 시스템 담당자에게 문의하세요');
			}
		})
	}
	
	function clearForm(){
		// 기준정보
		$('textarea[name=memo]').val('');
		$('input[name=calcType][value=10]').prop('checked', true);
		$('#currentCalcType').val('10');
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
		$('input[name=regNum]').val('');
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
		$('input[name=moisture]').val('');
		$('input[name=ash]').val('');
		$('input[name=protein]').val('');
		$('input[name=water_abs]').val('');
		$('input[name=stability]').val('');
		$('input[name=dev_time]').val('');
		$('input[name=pl]').val('');
		$('input[name=max_visc]').val('');
		$('input[name=fn]').val('');
		$('input[name=color]').val('');
		$('input[name=visc]').val('');
		$('input[name=particle_size]').val('');
		
		// 제조방법, 제조규격
		$('textarea[name=menuProcess]').val('');
		$('textarea[name=standard]').val('');
		
		// 부속제품 모두 제거 및 1개 생성 (배합, 내용물이 모두 지워짐)
		$('div[name=subProdDiv]').toArray().forEach(function(element){$(element).remove()})
		$('a[id^=subProdAddBtn]').toArray().forEach(function(element){$(element).remove()})
		$('div.tab03').children('ul').children('a:last').children('li').click();
		
		// 표시사항배합비
		$('#dispHeaderDiv').next().children('tbody').empty();
		$('#dispHeaderDiv').next().children('tfoot').children('tr').children('td:nth-child(3)').children('input').val('');
		$('#dispHeaderDiv').next().children('tfoot').children('tr').children('td:nth-child(4)').children('input').val('');
		
		// 재료
		$('#packageHeaderDiv').next().children('tbody').empty();
		
		// 생산소모품
		$('#consumeHeaderDiv').next().children('tbody').empty();
	}
	
	function getImportData(){
		if($('#mfg_company_select').val().length <= 0)
			return alert('회사, 공장, 생산라인을 선택해주세요');
		
		var companyCode = $('#mfg_company_select').val();
		var plantCode = $('#mfg_plant_select').val();
		
		var docType = $('input[name=docImportType]:checked').val();
		
		if(docType == 'design'){
			
			if($('#select_designDoc').val().length <= 0){
				return alert('제품설계서를 선택해주세요');
			}
			
			if($('#select_designDocDetail').val().length <= 0){
				return alert('설계서를 선택해주세요');
			}
			
			var pNo = $('#select_designDoc').val();
			var pdNo = $('#select_designDocDetail').val();
			
			getDesignDocData(pNo, pdNo)
			
			closeDialog('dialog_import');
		}
		
		if(docType == 'dev'){
			if($('#select_devDoc').val().length <= 0){
				return alert('제품개발문서를 선택해주세요');
			}
			
			if($('#select_docVersion').val().length <= 0){
				return alert('버전을 선택해주세요');
			}
			
			if($('#select_mfgDoc').val().length <= 0){
				return alert('제조공정서를 선택해주세요');
			}
			
			var dNo = $('#select_mfgDoc').val()
			var docNo = $('#select_devDoc').val()
			var docVersion = $('#select_docVersion').val()
			
			getMfgDocData(dNo, docNo, docVersion, companyCode);
			
			closeDialog('dialog_import');
		}
	}
	
	function getDesignDocData(pNo, pdNo){
		$('#lab_loading').show();
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
					
					//changeAutoDisp(0);
					var isAutoDisp = $('input[name=isAutoDisp]').val()
					//changeDispAuto(isAutoDisp)
					if(isAutoDisp == '1'){
						$('#autoDispUl').children('li:first').attr('class', 'select');
						$('#autoDispUl').children('li:last').attr('class', '');
					} else {
						$('#autoDispUl').children('li:first').attr('class', '');
						$('#autoDispUl').children('li:last').attr('class', 'select');
					}
					
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
								mixBody.children('tr:last').children('td').children('input[name=itemUnit]').val(item.itemUnit);
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
				$('#lab_loading').hide();
			}, error: function(a,b,c){
				//console.log(a,b,c)
				alert('제품개발문서 불러오기 실패[2] - 시스템 담당자에게 문의하세요')
				$('#lab_loading').hide();
			}
		});
	}
	
	function getMfgDocData(dNo, docNo, docVersion, companyCode){
		$('#lab_loading').show();
		$.ajax({
			url: '/dev/getMfgData',
			type: 'post',
			dataType: 'json',
			data: {
				dNo: dNo, 
				docNo: docNo, 
				docVersion: docVersion,
				companyCode: companyCode
			},
			success:function(data){
				if(data){
					clearForm()
					var mgfProcDoc = data;
					
					$('input[name=isAutoDisp]').val(mgfProcDoc.isAutoDisp);
					if(mgfProcDoc.isAutoDisp == '0'){
						$('#autoDispUl li:first').attr('class', 'select');
						$('#autoDispUl li:last').attr('class', '');
						changeAutoDisp(0)
					} else {
						$('#autoDispUl li:first').attr('class', '');
						$('#autoDispUl li:last').attr('class', 'select');
					}
					
					// 기준정보
					$('textarea[name=memo]').val(restoreStr(restoreStrAmp(mgfProcDoc.memo)));
					var calcType = mgfProcDoc.calcType.trim();
					calcType = (calcType == null || calcType == '') ? 10 : calcType; 
					$('#currentCalcType').val(calcType);
					$('input[name=calcType][value='+calcType+']').click()
					setImportForm(calcType);
					var plantCode = mgfProcDoc.plantCode;
					var lineCode = mgfProcDoc.lineCode;
					
					if(plantCode.length > 0){
						$('#mfg_plant_select option[value='+mgfProcDoc.plantCode+']').prop('selected', true);
						$('#mfg_plant_select').change();
					}
					if(lineCode.length > 0){
						$('#mfg_plantline_select option[value='+mgfProcDoc.lineCode+']').prop('selected', true);
						$('#mfg_plantline_select').change();
					}
					
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
					var compWeight = mgfProcDoc.compWeight;
					if(compWeight.match(/[^\d*(\.?\d*)]/) != null){
						var value = compWeight.substr(0, compWeight.match(/[^\d*(\.?\d*)]/).index);
						$('input[name=compWeight]').val(value);
						
						if(compWeight.match(/\(/) == null){
							var unit = compWeight.substr(compWeight.match(/[^\d*(\.?\d*)]/).index)
							var text = '';
							
							$('select[name=compWeightUnit] option[value='+unit+']').prop('selected', true);
							$('select[name=compWeightUnit]').change();
							$('input[name=compWeightText]').val(text);
						} else {
							var unit = compWeight.substr(compWeight.match(/[^\d*(\.?\d*)]/).index, compWeight.match(/\(/).index-compWeight.match(/[^\d*(\.?\d*)]/).index)
							var text = compWeight.substr(compWeight.match(/\(/).index+1, compWeight.length-(compWeight.match(/\(/).index+1)-1);
							
							$('select[name=compWeightUnit] option[value='+unit+']').prop('selected', true);
							$('select[name=compWeightUnit]').change();
							$('input[name=compWeightText]').val(text);
						}
					} else {
						$('input[name=compWeight]').val(compWeight);
						var compWeightUnit = mgfProcDoc.compWeightUnit;
						if(compWeightUnit != null && compWeightUnit.length > 0 ){
							$('select[name=compWeightUnit] option[value='+compWeightUnit+']').prop('selected', true);
							$('select[name=compWeightUnit]').change();
						}
						$('input[name=compWeightText]').val(mgfProcDoc.compWeightText);
					}
					
					var dispWeight = mgfProcDoc.dispWeight;
					if(dispWeight.match(/[^\d*(\.?\d*)]/) != null){
						var value = dispWeight.substr(0, dispWeight.match(/[^\d*(\.?\d*)]/).index);
						$('input[name=dispWeight]').val(value);
						
						if(dispWeight.match(/\(/) == null){
							var unit = dispWeight.substr(dispWeight.match(/[^\d*(\.?\d*)]/).index)
							var text = '';
							
							$('select[name=dispWeightUnit] option[value='+unit+']').prop('selected', true);
							$('select[name=dispWeightUnit]').change();
							$('input[name=dispWeightText]').val(text);
						} else {
							var unit = dispWeight.substr(dispWeight.match(/[^\d*(\.?\d*)]/).index, dispWeight.match(/\(/).index-dispWeight.match(/[^\d*(\.?\d*)]/).index)
							var text = dispWeight.substr(dispWeight.match(/\(/).index+1, dispWeight.length-(dispWeight.match(/\(/).index+1)-1);
							
							$('select[name=dispWeightUnit] option[value='+unit+']').prop('selected', true);
							$('select[name=dispWeightUnit]').change();
							$('input[name=dispWeightText]').val(text);
						}
					} else {
						$('input[name=dispWeight]').val(dispWeight);
						var dispWeightUnit = mgfProcDoc.dispWeightUnit;
						if(dispWeightUnit != null && dispWeightUnit.length > 0 ){
							$('select[name=dispWeightUnit] option[value='+dispWeightUnit+']').prop('selected', true);
							$('select[name=dispWeightUnit]').change();
						}
						$('input[name=dispWeightText]').val(mgfProcDoc.dispWeightText);
					}
					
					$('input[name=adminWeightFrom]').val(mgfProcDoc.adminWeightFrom);
					$('input[name=adminWeightTo]').val(mgfProcDoc.adminWeightTo);
					$('input[name=adminWeightFromUnit]').val(mgfProcDoc.adminWeightFromUnit);
					$('input[name=adminWeightToUnit]').val(mgfProcDoc.adminWeightToUnit);
					$('input[name=distPeriSite]').val(mgfProcDoc.distPeriSite);
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
					//$('textarea[name=menuProcess]').val(mgfProcDoc.menuProcess);
					//$('textarea[name=standard]').val(mgfProcDoc.standard);
					
					$('textarea[name=menuProcess]').val(restoreStr(restoreStrAmp(mgfProcDoc.menuProcess)));
					$('textarea[name=standard]').val(restoreStr(restoreStrAmp(mgfProcDoc.standard)));
					
					// 제품규격
					if(mgfProcDoc.spec != null){
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
					}
					
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
							var mixFoot = mixDiv.children('div.nomal_mix:last').children('table').children('tfoot');
							
							mixHeader.children('span').children('input[name=baseName]').val(mix.baseName);
							
							var weightTotal = 0;
							
							mixBody.empty();
							mix.item.forEach(function(item, itemIndex){
								mixHeader.children('span').children('button.btn_add_tr').click();
								var itemCode = item.itemCode
								mixBody.children('tr:last').children('td').children('input[name=itemSapCode]').val(itemCode);
								mixBody.children('tr:last').children('td').children('input[name=itemSapCode]').attr('onkeyup', "checkMaterail(event, 'B', '"+item.itemCode+"')");
								mixBody.children('tr:last').children('td').children('input[name=itemName]').val(item.itemName);
								mixBody.children('tr:last').children('td').children('input[name=itemBomRate]').val(item.bomRate);
								mixBody.children('tr:last').children('td').children('input[name=itemBomAmount]').val(item.bomAmount);
								mixBody.children('tr:last').children('td').children('input[name=itemUnit]').val(item.unit);
								//weightTotal += Number(item.weight);
								mixBody.children('tr:last').children('td').children('input[name=itemWeight]').val(item.weight);
								mixBody.children('tr:last').children('td').children('input[name=itemPosnr]').val(item.posnr);
								mixBody.children('tr:last').children('td').children('input[name=itemScrap]').val(item.scrap);
								
								//if(itemCode == )
								var storageCode = item.storageCode;
								if(storageCode != null && storageCode != ''){
									mixBody.children('tr:last').children('td').children('div').children('select[name=itemStorageCode]').children('option[value='+storageCode+']').prop('selected', true);
									mixBody.children('tr:last').children('td').children('div').children('select[name=itemStorageCode]').change()
								}
								
								mixBody.children('tr:last').children('td').children('input[name=itemBomAmount]').keyup();
							})
							
							//mixFoot.children('tr').children('td').input('input[name=bomAmountTotal]').val();
							//mixFoot.children('tr').children('td').input('input[name=bomRateTotal]').val();
							//mixFoot.children('tr').children('td').input('input[name=itemWeightTotal]').val(weightTotal.toFixed(3));
							
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
								contBody.children('tr:last').children('td').children('input[name=itemWeight]').val(item.weight);
								contBody.children('tr:last').children('td').children('input[name=itemUnit]').val(item.unit);
								contBody.children('tr:last').children('td').children('input[name=itemPosnr]').val(item.posnr);
								contBody.children('tr:last').children('td').children('input[name=itemScrap]').val(item.scrap);
								contBody.children('tr:last').children('td').children('input[name=itemBomAmount]').keyup();
								
								//contBody.children('tr:last').children('td').children('input[name=itemStorageCode]').val(item.storageCode);
								var storageCode = item.storageCode;
								if(storageCode != null && storageCode != ''){
									contBody.children('tr:last').children('td').children('div').children('select[name=itemStorageCode]').children('option[value='+storageCode+']').prop('selected', true);
									contBody.children('tr:last').children('td').children('div').children('select[name=itemStorageCode]').change()
								}
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
					dispBody.next().children('tr').children('td:nth-child(3)').children('input').val(round(excRateTotal, 3));
					dispBody.next().children('tr').children('td:nth-child(4)').children('input').val(round(incRateTotal, 3));
					
					
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
						pkgBody.children('tr:last').children('td').children('input[name=itemFomulaType]').val(pkg.fomulaType);
						pkgBody.children('tr:last').children('td').children('input[name=itemOrgUnit]').val(pkg.orgUnit);
						pkgBody.children('tr:last').children('td').children('input[name=itemUnit]').val(pkg.unit);
						pkgBody.children('tr:last').children('td').children('input[name=itemWeight]').val(pkg.weight);
						pkgBody.children('tr:last').children('td').children('input[name=itemPosnr]').val(pkg.posnr);
						pkgBody.children('tr:last').children('td').children('input[name=itemScrap]').val(pkg.scrap);
						//pkgBody.children('tr:last').children('td').children('input[name=itemStorageCode]').val(pkg.storageCode);
						var storageCode = pkg.storageCode;
						if(storageCode != null && storageCode != ''){
							pkgBody.children('tr:last').children('td').children('div').children('select[name=itemStorageCode]').children('option[value='+storageCode+']').prop('selected', true);
							pkgBody.children('tr:last').children('td').children('div').children('select[name=itemStorageCode]').change()
						}
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
						consBody.children('tr:last').children('td').children('input[name=itemWeight]').val(cons.unit);
						consBody.children('tr:last').children('td').children('input[name=itemUnit]').val(cons.unit);
						consBody.children('tr:last').children('td').children('input[name=itemPosnr]').val(cons.posnr);
						consBody.children('tr:last').children('td').children('input[name=itemScrap]').val(cons.scrap);
						//consBody.children('tr:last').children('td').children('input[name=itemStorageCode]').val(cons.storageCode);
						
						var storageCode = cons.storageCode;
						if(storageCode != null && storageCode != ''){
							consBody.children('tr:last').children('td').children('div').children('select[name=itemStorageCode]').children('option[value='+storageCode+']').prop('selected', true);
							consBody.children('tr:last').children('td').children('div').children('select[name=itemStorageCode]').change()
						}
					})
				}
				$('#lab_loading').hide();
			},
			error: function(a,b,c){
				alert('제조공정서 불러오기 실패[2] - 시스템 담당자에게 문의하세요')
				$('#lab_loading').hide();
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
	
	function changeWeight(e){
		clearNoNum($(e.target)[0]);
	}
	
	function changeDispWeightUnit(e){
		var dispWeightUnit = e.target.value;
		
		$('#select_adminWeightUnitFrom option[value="'+dispWeightUnit+'"]').prop('selected', true);
		$('#select_adminWeightUnitFrom').change();
		
		$('#select_adminWeightUnitTo option[value="'+dispWeightUnit+'"]').prop('selected', true);
		$('#select_adminWeightUnitTo').change();
		
		alert('표기중량 단위가 변경되어 관리중량 단위 '+dispWeightUnit+'(으)로 동일하게 변경됩니다.');
	}
	
	function changeDispWeight(){
		clearNoNum($('input[name=dispWeight]')[0]);
		
		var dispWeight = $('input[name=dispWeight]').val();
		var dispWeightUnit = $('select[name=dispWeightUnit]').val();
		
		if(dispWeightUnit == 'Kg' || dispWeightUnit == 'L'){
			dispWeight = dispWeight*1000;
		}
		
		if(dispWeight <= 50){
			// 허용오차 9%;
			caclDispWeightError('multi', dispWeight, dispWeightUnit, 0.09);
		} else if(dispWeight <= 100){
			// 허용오차 4.5g;
			caclDispWeightError('add', dispWeight, dispWeightUnit,  4.5);
		} else if(dispWeight <= 200){
			// 허용오차 4.5%;
			caclDispWeightError('multi', dispWeight, dispWeightUnit, 0.045);
		} else if(dispWeight <= 300){
			// 허용오차 9g;
			caclDispWeightError('add', dispWeight, dispWeightUnit,  9);
		} else if(dispWeight <= 500){
			// 허용오차 3%;
			caclDispWeightError('multi', dispWeight, dispWeightUnit, 0.03);
		} else if(dispWeight <= 1000){
			// 허용오차 15g;
			caclDispWeightError('add', dispWeight, dispWeightUnit,  15);
		} else if(dispWeight <= 10000){
			// 허용오차 1.5%;
			caclDispWeightError('multi', dispWeight, dispWeightUnit, 0.015);
		} else if(dispWeight <= 15000){
			// 허용오차 150g;
			caclDispWeightError('add', dispWeight, dispWeightUnit,  150);
		} else {
			// 허용오차 1%;
			caclDispWeightError('multi', dispWeight, dispWeightUnit, 0.01);
		}
	}
	
	function caclDispWeightError(type, dispWeight, dispWeightUnit, error){
		if(type != 'add' && type != 'multi'){
			return alert('Wrong Arithmetic Type');
		}
		if(type == 'add' ){
			var adminWeightFrom = Number(dispWeight) - error;
			var adminWeightTo = Number(dispWeight) + error;
			
			if(dispWeightUnit == 'Kg' || dispWeightUnit == 'L'){
				adminWeightFrom = Number(adminWeightFrom)/1000;
				adminWeightTo = Number(adminWeightTo)/1000;
			}
			
			//$('input[name=adminWeightFrom]').val(adminWeightFrom);
			//$('input[name=adminWeightTo]').val(adminWeightTo);
			
			//$('input[name=adminWeightUnitFrom]').val(dispWeightUnit);
			//$('input[name=adminWeightUnitTo]').val(dispWeightUnit);
			
			$('#select_adminWeightUnitFrom option[value="'+dispWeightUnit+'"]').prop('selected', true);
			$('#select_adminWeightUnitFrom').change();
			
			$('#select_adminWeightUnitTo option[value="'+dispWeightUnit+'"]').prop('selected', true);
			$('#select_adminWeightUnitTo').change();
		} 
		if(type == 'multi'){
			var adminWeightFrom = Number(dispWeight) - Number(dispWeight) * error;
			var adminWeightTo = Number(dispWeight) + Number(dispWeight) * error;
			
			if(dispWeightUnit == 'Kg' || dispWeightUnit == 'L'){
				adminWeightFrom = adminWeightFrom/1000;
				adminWeightTo = adminWeightTo/1000;
			}
			
			//$('input[name=adminWeightFrom]').val(adminWeightFrom);
			//$('input[name=adminWeightTo]').val(adminWeightTo);
			
			//$('input[name=adminWeightUnitFrom]').val(dispWeightUnit);
			//$('input[name=adminWeightUnitTo]').val(dispWeightUnit);
			
			$('#select_adminWeightUnitFrom option[value="'+dispWeightUnit+'"]').prop('selected', true);
			$('#select_adminWeightUnitFrom').change();
			
			$('#select_adminWeightUnitTo option[value="'+dispWeightUnit+'"]').prop('selected', true);
			$('#select_adminWeightUnitTo').change();
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
		
		$('#mfgDocSelectDiv').hide();
		
		$('#select_designDoc').removeOption(/./);
		$('#select_designDoc').addOption('', '제품설계서 선택', true);
		$('#label_select_designDoc').text('제품설계서  선택');
		
		$('#select_designDocDetail').removeOption(/./);
		$('#select_designDocDetail').addOption('', '설계서  선택', true);
		$('#label_select_designDocDetail').text('설계서 선택');
		
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
					
					if(designDocList.length == 0){
						return alert('검색조건과 일치하는 사용자의 제품개발문서가 없습니다');
					}
					
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
		
		$('#select_designDocDetail').removeOption(/./);
		$('#select_designDocDetail').addOption('', '설계서 선택', true);
		$('#label_select_designDocDetail').text('설계서 선택');
		
		$.ajax({
			url: '/design/getDesignDocDetailSummaryList',
			data: {
				pNo: pNo
			},
			type: 'post',
			success: function(data){
				if(data){
					var designDocDetailList = JSON.parse(data)
					
					if(designDocDetailList.length <= 0){
						return alert('해당 제품설계서의 하위 설계서 항목이 존재하지않습니다');
					}
					
					designDocDetailList.forEach(function(obj, index){
						var text = '[' + obj.pdNo + '] ' + obj.userName + ' - ' + obj.regDate;
						$('#select_designDocDetail').addOption(obj.pdNo, text, false);
					});
				} else {
					return alert('설계서 조회 실패[1] - 시스템 담당자에게 문의하세요')
				}
			},
			error: function(a,b,c){
				return alert('설계서 조회 실패[2] - 시스템 담당자에게 문의하세요')
			}
		})
	}
	
	function searchDevDoc(){
		var productType1 = $('#productType1').val();
		var productType2 = $('#productType2').val();
		var productType3 = $('#productType3').val();
		var productName = $('#dialog_mfg_productName').val();
		
		$('#designDocSelectDiv').hide();
		$('#select_devDoc').removeOption(/./);
		$('#select_devDoc').addOption('', '제품개발문서 선택', true);
		$('#label_select_devDoc').text('제품개발문서 선택');
		
		$('#select_docVersion').removeOption(/./);
		$('#select_docVersion').addOption('', '버전', true);
		$('#label_select_docVersion').text('버전');
		
		$('#select_mfgDoc').removeOption(/./);
		$('#select_mfgDoc').addOption('', '제조공정서 선택', true);
		$('#label_select_mfgDoc').text('제조공정서 선택');
		
		
		$.ajax({
			url: '/dev/getDevDocSummaryList',
			data: {
				productType1: productType1, 
				productType2: productType2, 
				productType3: productType3, 
				productName: productName
			},
			type: 'post',
			success: function(data){
				if(data){
					var devDocList = JSON.parse(data);
					
					if(devDocList.length == 0){
						return alert('검색조건과 일치하는 사용자의 제조공정서가 없습니다');
					}
					
					var uniqueDevDocList = devDocList.filter(function(obj, index, thisArr){
						if(index >0 ){
							if(obj.docNo == thisArr[index-1].docNo){
								return false;
							} else {
								return true;
							}
						} else {
							return true;
						}
					})
					
					uniqueDevDocList.forEach(function(obj, index){
						$('#select_devDoc').addOption(obj.docNo, '['+obj.docNo+'] '+obj.productName, false);
					});
					
					$('#mfgDocSelectDiv').show()
				} else {
					$('#mfgDocSelectDiv').hide()
					return alert('제조공정서 조회 실패[1] - 시스템 담당자에게 문의하세요')
				}
			},
			error: function(a,b,c){
				return alert('제조공정서 조회 실패[2] - 시스템 담당자에게 문의하세요')
			}
		})
	}
	
	function searchDocVersion(e){
		var docNo = e.target.value;
		
		$.ajax({
			url: '/dev/getDevDocVersion',
			data: {
				docNo: docNo
			},
			type: 'post',
			success: function(data){
				if(data){
					var docVersionList = JSON.parse(data)
					
					$('#select_docVersion').removeOption(/./);
					$('#select_docVersion').addOption('', '버전', true);
					$('#label_select_docVersion').text('버전');
					
					docVersionList.forEach(function(obj, index){
						$('#select_docVersion').addOption(obj.docVersion, obj.docVersion, false);
					});
				} else {
					return alert('제조공정서 조회 실패[1] - 시스템 담당자에게 문의하세요')
				}
			},
			error: function(a,b,c){
				return alert('제조공정서 조회 실패[2] - 시스템 담당자에게 문의하세요')
			}
		})
	}
	
	function searchMfgDoc(){
		var docNo = $('#select_devDoc').val()
		var docVersion = $('#select_docVersion').val();
		
		$.ajax({
			url: '/dev/getMfgsummaryList',
			data: {
				docNo: docNo,
				docVersion: docVersion
			},
			type: 'post',
			success: function(data){
				if(data){
					var mfgDocList = JSON.parse(data)
					
					$('#select_mfgDoc').removeOption(/./);
					$('#select_mfgDoc').addOption('', '제조공정서 선택', true);
					$('#label_select_mfgDoc').text('제조공정서 선택');
					
					mfgDocList.forEach(function(obj, index){
						$('#select_mfgDoc').addOption(obj.dNo, '['+obj.plantName+'-'+obj.lineName+'] '+ obj.memo, false);
					});
				} else {
					return alert('제조공정서 조회 실패[1] - 시스템 담당자에게 문의하세요')
				}
			},
			error: function(a,b,c){
				return alert('제조공정서 조회 실패[2] - 시스템 담당자에게 문의하세요')
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
	
	
	function openMaterialPopup(element, itemType){
		if($('#mfg_company_select').val().length <= 0)
			return alert('회사, 공장, 생산라인을 선택해주세요');
		
		var parentRowId = $(element).parent().parent('tr')[0].id;
		$('#targetID').val(parentRowId);
		openDialog('dialog_material');
		
		var matCode = $(element).prev().val()
		if(typeof(matCode) == 'string') matCode = matCode.toUpperCase();
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
				plant: $('#mfg_plant_select').val(),
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
	
	function openImportDialog(){
		return alert('=== 해당기능은 관리팀 요청에 의해 비활성화되었습니다 ===');
		
		$('#designDocSelectDiv').hide();
		
		$('#select_devDoc').removeOption(/./);
		$('#select_devDoc').addOption('', '제품개발문서 선택', true);
		$('#label_select_devDoc').text('제품개발문서 선택');
		
		$('#select_docVersion').removeOption(/./);
		$('#select_docVersion').addOption('', '버전', true);
		$('#label_select_docVersion').text('버전');
		
		$('#select_mfgDoc').removeOption(/./);
		$('#select_mfgDoc').addOption('', '제조공정서 선택', true);
		$('#label_select_mfgDoc').text('제조공정서 선택');
		
		$('#mfgDocSelectDiv').hide();
		
		$('#select_designDoc').removeOption(/./);
		$('#select_designDoc').addOption('', '제품설계서 선택', true);
		$('#label_select_designDoc').text('제품설계서  선택');
		
		$('#select_docVersion').removeOption(/./);
		$('#select_docVersion').addOption('', '버전', true);
		$('#label_select_docVersionc').text('버전');
		
		$('#select_designDocDetail').removeOption(/./);
		$('#select_designDocDetail').addOption('', '설계서  선택', true);
		$('#label_select_designDocDetail').text('설계서 선택');
		
		openDialog('dialog_import');
	}
	
	function calcBomRate(e){
		clearNoNum(e.target);
		calcBomRateTotal(e);
		
		$(e.target).prev().val(e.target.value);
	}
	
	function calcBomRateTotal(e){
		var tbodyId = $(e.target).parent().parent().parent().attr('id');
		var bomRateTableTotal = 0;
		$('tbody[id='+tbodyId+']').children('tr').each(function(i, tr){
			var sapCode = $(tr).children('td').children('input[name=itemSapCode]').val();
			if(sapCode != '400023'){
				var bomRate = Number($(tr).children('td').children('input[name=itemBomRate]').val())
				if(bomRate == NaN) bomRate = 0;
				
				bomRateTableTotal += parseFloat(bomRate);
			}
		})
		
		$('tbody[id='+tbodyId+']').siblings('tfoot').children('tr').children('td').children('input[name=bomRateTotal]').val(round(bomRateTableTotal,3))
		
		var bomRateTotal = 0;
		$('tbody[id^=mixTbody_').siblings('tfoot').children('tr').each(function(i, tr){
			bomRateTotal += Number($(tr).children('td').children('input[name=bomRateTotal]').val())
		})
		$('input[name=subProdStdAmount]').val(round(bomRateTotal,3)) //기준수량
		$('input[name=stdAmount]').val(round(bomRateTotal,3))
		
		var calcType = '${calcType}';
		if(calcType != '10')
			$('input[name=mixWeight]').val(round(bomRateTotal,3))
		
		doDisp();
	}
	
	function calcBomAmountTotal(e){
		var tbodyId = $(e.target).parent().parent().parent().attr('id');
		var bomAmountTableTotal = 0;
		$('tbody[id^='+tbodyId+']').children('tr').each(function(i, tr){
			var sapCode = $(tr).children('td').children('input[name=itemSapCode]').val();
			var bomAmount = Number($(tr).children('td').children('input[name=itemBomAmount]').val())
			if(bomAmount == NaN) bomAmount = 0;
			
			bomAmountTableTotal += parseFloat(bomAmount);
		})
		
		$('tbody[id^='+tbodyId+']').siblings('tfoot').children('tr').children('td').children('input[name=bomAmountTotal]').val(round(bomAmountTableTotal,3))
	}
	
	function closeMatRayer(){
		$('#searchMatValue').val('')
		$('#matLayerBody').empty();
		$('#matLayerBody').append('<tr><td colspan="9">원료코드 혹은 원료코드명을 검색해주세요</td></tr>');
		$('#matCount').text(0);
		closeDialog('dialog_material')
	}
	
	function setSubProdDivWeight(e){
		clearNoNum(e.target);
		
		var unitWeight = Number($(e.target).parent().children('input[name=subProdDivUnitWeight]').val());
		var volume = Number($(e.target).parent().children('input[name=subProdDivUnitVolume]').val());
		var subProdDivWeight = round((unitWeight * volume), 3);
		$(e.target).parent().children('input[name=subProdDivWeight]').val(subProdDivWeight);
		$('input[name=totWeight]').val(subProdDivWeight);
		
		if(e.keyCode == 13){
			calcAll();
		}
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
	
	function openUnitDialog(e){
		var targetRowId = $(e.target).parent().parent().attr('id');
		var targetValue = $(e.target).prev().val();
		
		var labelText = $('#selectUnitType option:first').text();
		$('#selectUnitType option:first').change()
		$('#selectUnitType').parent().children('label').text(labelText);
		$('#targetRowId').val(targetRowId);
		$('#convertUserValue').val(targetValue);
		$('#targetUnitValue').val(targetValue);
		$('#convertUserValue').keyup();
		$('#selectUnitType').change();
		
		openDialog('dialog_convert');
	}
	
	function calcUnitChange(e){
		var stdAmount = $('input[name=stdAmount]').val();
		
		$(e.target).prev('span').text(stdAmount);
		var userValue = $(e.target).val();
		var calcType = $(e.target).parent().parent().prev().children('dd').children('div').children('select').val();
		var targetElement = $(e.target).parent().parent().next().next().children('dd').children('input');
		//var numbong = $('input[name=numBong]').val();
		//var numbox = $('input[name=numBox]').val();
		var numbong = 1;
		var numbox = 1;
		
		if(calcType == 1){
			targetElement.val( round(Number(stdAmount) * Number(userValue) / 500000,3) );
		} else if(calcType == 2){
			targetElement.val( round(Number(stdAmount) * Number(userValue) / 1000000,3) );
		} else if(calcType == 6){
			targetElement.val( round(Number(stdAmount) * Number(userValue) / 1500000,3) );
		} else if(calcType == 7){
			targetElement.val( round(Number(stdAmount) * Number(userValue) / 1800000,3) );
		} else if(calcType == 3){
			targetElement.val( round(Number(stdAmount) * Number(userValue) / 2000000,3) );
		} else if(calcType == 4){
			targetElement.val( round(Number(stdAmount) * Number(userValue) / 800000,3) );
		} else if(calcType == 5){
			targetElement.val( round(Number(stdAmount) * Number(userValue) *2 / 800000,3) );
		}
		
		 else if(calcType == 8){
			targetElement.val( round(Number(stdAmount), 3) );
		} else if(calcType == 9){
			targetElement.val( round(Number(stdAmount) * Number(numbong) ,3) );
		} else if(calcType == 10){
			targetElement.val( round(Number(stdAmount) * Number(userValue) / 1000000 * Number(numbong),3) );
		} else if(calcType == 11){
			targetElement.val( round(Number(stdAmount) * Number(numbox), 3) );
		}
	}
	
	function changeConvertType(e){
		var convertType = e.target.value;
		var stdAmount = $('input[name=stdAmount]').val();
		var convertUserValue = $('#targetUnitValue').val();
		//var numbong = $('input[name=numBong]').val();
		//var numbox = $('input[name=numBox]').val();
		var numbong = 1;
		var numbox = 1;
		
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
			targetHtml += '<input type="hidden" id="convertUserValue" value="'+convertUserValue+'">';
		} else if(convertType == 9){
			var targetHtml = '기준수량('+stdAmount+')';
			targetHtml += '<input type="hidden" id="convertUserValue" value="'+convertUserValue+'">' + ' x 봉당 들이수('+numbong+')';
		} else if(convertType == 10){
			targetHtml += ') ' + '<input type="hidden" id="convertUserValue" value="'+convertUserValue+'">' +' / 1,000,000 x 봉당 들이수('+numbong+')'
		} else if(convertType == 11){
			var targetHtml = '기준수량('+stdAmount+')';
			targetHtml+= '<input type="hidden" id="convertUserValue" value="'+convertUserValue+'">' + ' / 상자 들이수('+numbox+')';
		}
		
		$('#targetUnitCalcType').val(convertType);
		$('#convertUserValue').keyup();
		
		$('#convertDD').empty();
		$('#convertDD').append(targetHtml)
	}
	
	function setCovertResult(){
		var targetRowId = $('#targetRowId').val();
		var convertResult = $('#convertResult').val();
		var convertUserValue = $('#convertUserValue').val();
		convertUserValue == 'undefined' ? '' : convertUserValue;
		
		$('#'+targetRowId).children('td').children('input[name=itemBomAmount]').val(convertUserValue);
		$('#'+targetRowId).children('td').children('input[name=itemBomRate]').val(convertResult);
		$('#'+targetRowId).children('td').children('input[name=itemFomulaType]').val($('#selectUnitType').val());
		
		closeDialog('dialog_convert')
	}
	
	function setStdAmount(e){
		clearNoNum(e.target)
		$('input[name=stdAmount]').val(e.target.value)
		//$('input[name=mixWeight]').val(e.target.value)
		
		if(e.target.value.length > 0)
			calcAll();
	}
	
	function bindDialogEnter(e){
		if(e.keyCode == 13)
			$(e.target).next().click();
	}
	
	function productBomRateKeyup(e){
		clearNoNum(e.target);
		$('input[name=itemBomAmount]:first').keyup()
	}
	
	function mixWeightKeyUp(e){
		clearNoNum(e.target)
		
		if(e.target.value.length > 0)
			calcAll();
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
</script>

<!-- <div id="lab_loading" style="display:none"><div class="lab_loader"></div></div> -->
<div class="wrap_in" id="fixNextTag">
	<span class="path">
		제조공정서 신규작성&nbsp;&nbsp;
		<img src="/resources/images/icon_path.png" style="vertical-align: middle" />&nbsp;&nbsp;제품개발문서&nbsp;&nbsp;
		<img src="/resources/images/icon_path.png" style="vertical-align: middle" />&nbsp;&nbsp;<a href="javascript:;">SPC 삼립연구소</a>
	</span>
	<section class="type01">
		<!-- 상세 페이지  start-->
		<h2 style="position: relative">
			<span class="title_s">Manufacturing Process Doc</span><span class="title">제조공정서 신규작성</span>
			<div class="top_btn_box">
				<ul>
					<li>
						<button class="btn_circle_save" onclick="saveMfgProcessDoc('0')">&nbsp;</button>
					</li>
				</ul>
			</div>
		</h2>
		<div class="group01 mt20">
			<c:if test="${calcType == '10'}"><c:set var="calcTypeText" value="프리믹스"/></c:if>
			<c:if test="${calcType == '3'}"><c:set var="calcTypeText" value="일반제품-밀다원3번코드"/></c:if>
			<c:if test="${calcType == '7'}"><c:set var="calcTypeText" value="일반제품-밀다원7번코드"/></c:if>
			<!-- 기준정보 start --------------------------------------------------------------------------------------------------------------------------------------------------------->
			<div class="title5" style="width: 80%">
				<span class="txt">01. '${productName}' 기준정보 (${calcTypeText})</span>
			</div>
			<div class="title5" style="width: 20%; display: inline-block;">
				<!-- <button style="float: right;" class="btn_con_search" onclick="openImportDialog()"><img src="/resources/images/btn_icon_setting.png"> 불러오기</button> -->
			</div>
			<c:choose>
				<c:when test="${calcType == 3}">
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
									<td colspan="5"><textarea name="memo" style="width: 100%; height: 60px" class="req"></textarea></td>
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
				                        	<label for="mfg_company_select">${selectedCompanyName}</label>
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
				                            <label id="label_mfg_plant_select" for="mfg_plant_select">${selectedPlantName}</label>
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
										<input type="radio" name="calcType" id="radio_caclType3" value="3" checked="checked" onchange="changeCalcType(event)"/><label for="radio_caclType3"><span></span>일반제품 (밀다원 3번코드)</label>
									</td>
									<th>BOM수율</th>
									<td><input type="text" id="productBomRatio" name="bomRate" onkeyup="productBomRateKeyup(event)" style="width: 30%;" class="req" readonly="readonly" value="100"/> %</td>
								</tr>
								<tr>
									<th style="border-left: none;">대체BOM</th>
									<td>
										<c:if test="${userUtil:getUserGrade(pageContext.request) == '3'}">
											<input type="text" name="stlal" style="width: 100%;" placeholder="BOM담당자만 입력" />
										</c:if>
									</td>
									<th>품목제조보고서명</th>
									<td><input type="text" name="docProdName" style="width: 90%;" class="req" value="${productDevDoc.productName}"/></td>
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
									<td><input type="text" name="numBong" onkeyup="clearNoNum(this)" style="width: 30%;" class="req" /> /ea</td>
									<th>상자 들이수</th>
									<td><input type="text" name="numBox" onkeyup="clearNoNum(this)" style="width: 30%;" class="req" /></td>
									<th>분할중량 총합계(g)</th>
									<td><input type="text" name="totWeight" onkeyup="clearNoNum(this)" style="width: 100%;" readonly="readonly" class="read_only" /></td>
								</tr>
								<tr style="display: none">
									<th style="border-left: none;">소성손실(g/%)</th>
									<td><input type="text" name="loss" onkeyup="clearNoNum(this)" style="width: 30%;"/> %</td>
									<th>배합중량</th>
									<td>
										<input type="text" id="mixWeight" name="mixWeight" onkeyup="clearNoNum(this)" style="width: 30%;" class="req" value="0"/> kg
											( <input type="text" name="bagAmout" onkeyup="clearNoNum(this)" style="width: 20%;" class="req" value="0" /> 포)
									</td>
									<th>기준수량</th>
									<td><input type="text" name="stdAmount" style="width: 100%;" readonly="readonly" class="read_only" /></td>
								</tr>
							</tbody>
						</table>
					</div>
				</c:when>
				<c:otherwise>
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
									<td colspan="5"><textarea name="memo" style="width: 100%; height: 60px" class="req"></textarea></td>
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
				                        	<label for="mfg_company_select">${selectedCompanyName}</label>
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
										<input type="radio" name="calcType" id="radio_caclType10" value="10" checked="checked" onclick="changeCalcType(event)" disabled="disabled"/><label for="radio_caclType10"><span></span>프리믹스</label>
									</td>
									<th>기준수량</th>
									<td><input type="text" name="stdAmount" style="width: 100%;" readonly="readonly" class="read_only" /></td>
								</tr>
								<tr>
									<th style="border-left: none;">대체BOM</th>
									<td>
										<c:if test="${userUtil:getUserGrade(pageContext.request) == '3'}">
											<input type="text" name="stlal" style="width: 100%;" placeholder="BOM담당자만 입력" />
										</c:if>
									</td>
									<th>배합중량</th>
									<td>
										<input type="text" id="mixWeight" name="mixWeight" onkeyup="clearNoNum(this)" style="width: 30%;"/> kg
											( <input type="text" name="bagAmout" onkeyup="clearNoNum(this)" style="width: 20%;"/> 포)
									</td>
									<th>BOM수율</th>
									<td><input type="text" id="productBomRatio" name="bomRate" onkeyup="productBomRateKeyup(event)" style="width: 30%;" class="req" value=""/> %</td>
								</tr>
								<tr>
									<th style="border-left: none;">봉당 들이수</th>
									<td><input type="text" name="numBong" onkeyup="clearNoNum(this)" style="width: 30%;"/> /ea</td>
									<th>상자 들이수</th>
									<td><input type="text" name="numBox" onkeyup="clearNoNum(this)" style="width: 30%;"/></td>
									<th>분할중량 총합계(g)</th>
									<td><input type="text" name="totWeight" onkeyup="clearNoNum(this)" style="width: 100%;" readonly="readonly" class="read_only" /></td>
								</tr>
								<tr>
									<th style="border-left: none;">소성손실(g/%)</th>
									<td><input type="text" name="loss" onkeyup="clearNoNum(this)" style="width: 30%;"/> %</td>
									<th>품목제조보고서명</th>
									<td><input type="text" name="docProdName" style="width: 90%;" value="${productName}"/></td>
									<th>제조공정도 유형</th>
									<td><input type="text" name="lineProcessType" style="width: 100%;" class="" placeholder="(예1_1라인 A형)" /></td>
								</tr>
							</tbody>
						</table>
					</div>
				</c:otherwise>
			</c:choose>
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
					<ul id="subScroll" class="ul">
						<li id="subProdAddBtn_1" class="select" onclick="changeTab(this)" ondblclick="changeSubProdName(event)">
							<span class="unselectable" ondblclick="dblSubProdNameSpan(event)">${productDevDoc.productName}</span>
							<input type="text" name="subProdName" onkeyup="subProdNameKeyup(event)" style="width: 180px;" placeholder="부속제품명 입력" class="" value="${productDevDoc.productName}" />
							<!-- <button name="subProdDelBtn" class="tab_btn_del" onclick="removeSubProduct('1')"><img src="/resources/images/btn_table_header01_del02.png"></button> -->
						</li><!-- <li class="none" onclick="addSubProduct(this)">
							<span class="unselectable">&nbsp;</span>
							<button class="tab_btn_add"><img src="/resources/images/btn_pop_add.png"></button>
							<span class="unselectable">&nbsp;</span>
						</li> -->
					</ul>
				</div>
				<div class="toRight unselectable" onclick="moveRight()"><span class="span_left">&gt;</span></div>
			</div>
			<div id="subProdDiv_1" name="subProdDiv">
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
									<input type="text" name="subProdDivWeight" style="width: 25%;" class="read_only" readonly="readonly" onkeyup="calcStdAmount(event)"/> g
									(
									<input type="text" name="subProdDivUnitWeight" style="width: 20%" onkeyup="setSubProdDivWeight(event)">g
									x
									<input type="text" name="subProdDivUnitVolume" style="width: 15%" onkeyup="setSubProdDivWeight(event)">ea
									)
								</td>
								<th>분할중량 설명</th>
								<td><input type="text" name="subProdDivWeightTxt" style="width: 100%;" /></td>
								<th>기준수량</th>
								<td>
									<input type="text" name="subProdStdAmount" style="width: 100%;" class="read_only" readonly="readonly" onkeyup="setStdAmount(event)"/>
									<%-- 
									<c:if test="${productType == 20}">
										<input type="text" name="subProdStdAmount" style="width: 100%;" class="req" />
									</c:if>
									<c:if test="${productType != 20}">
										<input type="text" name="subProdStdAmount" style="width: 100%;" readonly="readonly" class="read_only" />
									</c:if>
									 --%>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div>
					<div class="tbl_in_title">▼ 배합비</div>
					<div class="tbl_in_con">
						<!-- 일반배합obj start-->
						<div class="nomal_mix">
							<div class="table_header01">
								<input type="hidden" name="baseType" value="MI"/>
								<span class="table_order_btn">
									<button class="btn_up" onclick="moveUp(this)"></button><button class="btn_down" onclick="moveDown(this)"></button>
								</span><span class="title" style="width:70%"><img
									src="/resources/images/img_table_header.png">&nbsp;&nbsp;배합비명 : <input
									type="text" name="baseName" style="width: 200px" value="${productDevDoc.productName}"/>
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
									<%-- <col width="8%"> --%>
									<col width="8%">
									<col width="8%">
									<col width="7%">
									<col width="7%">
								</colgroup>
								<thead>
									<tr>
										<th><input type="checkbox" id="mixTable_1" onclick="checkAll(event)"><label for="mixTable_1"><span></span></label></th>
										<th>원료코드</th>
										<th>원료명</th>
										<th>배합%</th>
										<th>BOM수량</th>
										<th>단위</th>
										<!-- <th>중량g( <a href="javascript:;" name="copyBakery" onclick="copyBakery(this)">복제</a> )</th> -->
										<th>BOM항목</th>
										<th>공정로스</th>
										<th>저장위치</th>
										<th>원산지</th>
									</tr>
								</thead>
								<tbody id="mixTbody_1">
									<Tr id="mixRow_1" class="temp_color">
										<Td><input type="checkbox" id="mix_1"><label for="mix_1"><span></span></label></Td>
										<Td>
											<input type="hidden" name="itemImNo" style="width: 100px" class="req code_tbl"/>
											<input type="text" name="itemSapCode" style="width: 100px" class="req code_tbl" onkeyup="checkMaterail(event, 'B', '')" value=""/>
											<button class="btn_code_search2" onclick="openMaterialPopup(this, 'B')"></button>
										</Td>
										<Td><input type="text" name="itemName" style="width: 85%" readonly="readonly" class="read_only" /><button class="btn_code_info2"></button></Td>
										<Td><input type="text" name="itemBomAmount" style="width: 100%" onkeyup="calcBomAmountTotal(event)"/></Td>
										<Td><input type="text" name="itemBomRate" style="width: 100%" class="req" onkeyup="calcBomRate(event)"/></Td>
										<Td><input type="text" name="itemUnit" style="width: 100%" class="readonly" readonly="readonly"/></Td>
										<!-- <Td><input type="text" name="itemWeight" style="width: 100%" class="req" onkeyup="calcWeight(this)"/></Td> -->
										<Td><input type="text" name="itemPosnr" style="width: 100%" /></Td>
										<Td><input type="text" name="itemScrap" style="width: 80%" />%</Td>
										<Td>
											<!-- <input type="text" name="itemStorageCode" style="width: 100%; cursor: pointer" class="read_only" readonly="readonly" onclick="openStorageDialog(event, 'dialog_storage')"/> -->
											<div class="selectbox" style="width: 90%">
												<select name="itemStorageCode" id="select_storage_mix_1">
													<option value="" selected>선택</option>
													<c:forEach items="${specificStorageList}" var="sotrage">
														<option value="${sotrage.storageCode}">${sotrage.storageCode}</option>
													</c:forEach>
												</select>
												<label for="select_storage_mix_1">선택</label>
											</div>
										</Td>
										<Td>
											<div class="selectbox" style="width: 90%">
												<select name="itemOrigin" id="select_origin_mix_1">
													<option value="" selected>없음</option>
													<option value="C">캐나다(C)</option>
													<option value="U">미국(U)</option>
													<option value="A">호주(A)</option>
													<option value="K">한국(K)</option>
													<option value="F">프랑스(F)</option>
													<option value="G">독일(G)</option>
												</select>
												<label for="select_origin_mix_1">선택</label>
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
										<!-- <Td>&nbsp;</Td> -->
										<Td>&nbsp;</Td>
										<Td>&nbsp;</Td>
										<Td>&nbsp;</Td>
										<Td>&nbsp;</Td>
									</Tr>
								</tfoot>
							</table>
						</div>
						<!-- 일반배합obj close-->
						<div name="addMixDiv" class="add_nomal_mix" onclick="addTable(this, 'mix')">
							<span><img src="/resources/images/btn_pop_add2.png"> 배합비 추가</span>
						</div>
					</div>
					<%-- <c:if test="${calcType != '3'}">
						<div class="tbl_in_title">▼ 내용물</div>
						<div class="tbl_in_con">
							<!-- 내용물obj start-->
							<div class="nomal_mix">
								<div class="table_header02">
									<input type="hidden" name="baseType" value="CI"/>
									<span class="table_order_btn">
										<button class="btn_up" onclick="moveUp(this)"></button><button class="btn_down" onclick="moveDown(this)"></button>
									</span><span class="title" style="width:70%"><img
										src="/resources/images/img_table_header.png">&nbsp;&nbsp;내용물명 : <input
										type="text" name="baseName" style="width: 200px" />&nbsp;분할중량 : <input
										type="text" name="divWeight" style="width: 50px" onkeyup="divWeightKeyup(event)"/> g <input
										type="text" name="divWeightTxt" style="width: 100px; border-color: #ab9e95;" />
									</span><span class="table_header_btn_box">
										<button class="btn_del_table_header" onclick="removeTable(this, 'content')">내용물 삭제</button>
										<button class="btn_add_tr" onclick="addRow(this, 'content')"></button><button class="btn_del_tr" onclick="removeRow(this)"></button>
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
										<col width="7%">
									</colgroup>
									<thead>
										<tr>
											<th><input type="checkbox" id="contentTable_1" onclick="checkAll(event)"><label for="contentTable_1"><span></span></label></th>
											<th>원료코드</th>
											<th>원료명</th>
											<th>배합%</th>
											<th>BOM수량</th>
											<th>단위</th>
											<th>BOM항목</th>
											<th>공정로스</th>
											<th>저장위치</th>
										</tr>
									</thead>
									<tbody id="contentTbody_1">
										<Tr id="contentRow_1" class="temp_color">
											<Td><input type="checkbox" id="content_1"><label for="content_1"><span></span></label></Td>
											<Td>
												<input type="hidden" name="itemImNo" style="width: 100px" class="req code_tbl"/>
												<input type="text" name="itemSapCode" style="width: 100px" class="req code_tbl" onkeyup="checkMaterail(event, 'B', '')" value=""/>
												<button class="btn_code_search2" onclick="openMaterialPopup(this, 'B')"></button>
											</Td>
											<Td><input type="text" name="itemName" style="width: 85%" readonly="readonly" class="read_only" /><button class="btn_code_info2"></button></Td>
											<Td><input type="text" name="itemBomAmount" style="width: 100%" class="req" onkeyup="calcBomAmountCont(this)" /></Td>
											<Td><input type="text" name="itemBomRate" style="width: 100%" class="read_only" onkeyup="bomRateKeyup(this)" readonly="readonly"/></Td>
											<Td><input type="text" name="itemUnit" style="width: 100%" class="readonly" readonly="readonly"/></Td>
											<Td><input type="text" name="itemPosnr" style="width: 100%" /></Td>
											<Td><input type="text" name="itemScrap" style="width: 80%" />%</Td>
											<Td>
												<!-- <input type="text" name="itemStorageCode" style="width: 100%; cursor: pointer" class="read_only" readonly="readonly" onclick="openStorageDialog(event, 'dialog_storage')"/> -->
												<div class="selectbox" style="width: 90%">
													<select name="itemStorageCode" id="select_storage_content_1">
														<option value="" selected>선택</option>
														<c:forEach items="${specificStorageList}" var="sotrage">
															<option value="${sotrage.storageCode}">${sotrage.storageCode}</option>
														</c:forEach>
													</select>
													<label for="select_storage_content_1">선택</label>
												</div>
											</Td>
										</Tr>
									</tbody>
									<tfoot>
										<Tr>
											<Td colspan="3">합계</Td>
											<Td><input type="text" name="bomAmountTotal" style="width: 100%" readonly="readonly" class="read_only" /></Td>
											<Td><input type="text" name="bomRateTotal" style="width: 100%" readonly="readonly" class="read_only" /></Td>
											<Td>&nbsp;</Td>
											<Td>&nbsp;</Td>
											<Td>&nbsp;</Td>
											<Td>&nbsp;</Td>
										</Tr>
									</tfoot>
								</table>
							</div>
							<!-- 내용물obj close-->
							<div name="addContDiv" class="add_nomal_mix" onclick="addTable(this, 'content')">
								<span><img src="/resources/images/btn_pop_add3.png"> 내용물 추가</span>
							</div>
						</div>
					</c:if> --%>
				</div>
			</div>
			<!-- 원료 close --------------------------------------------------------------------------------------------------------------------------------------------------------->
			<!-- 표시사항 배합비 start --------------------------------------------------------------------------------------------------------------------------------------------------------->
			<%-- <div class="title5" style="float: left; margin-top: 30px;">
				<span class="txt">
					03. 표시사항 배합비
					<ul id="autoDispUl" class="list_ul3">
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
						<th><input type="checkbox" id="dispTable_1" onclick="checkAll(event)"><label for="dispTable_1"><span></span></label></th>
						<th>원료명</th>
						<th>백분율</th>
						<th>급수포함</th>
					</tr>
				</thead>
				<tbody id="dispTbody_1" name="dispTbody">
					<Tr>
						<Td><input type="checkbox" id="disp_1"><label for="disp_1"><span></span></label></Td>
						<Td>
							<input type="hidden" name="itemSapCode">
							<input type="text" name="matName" style="width: 80%" class="read_only" readonly="readonly"/>
						</Td>
						<Td><input type="text" name="excRate" style="width: 80%" class="read_only" onkeyup="calcDisp(event)" readonly="readonly"/></Td>
						<Td><input type="text" name="incRate" style="width: 80%" class="read_only" onkeyup="calcDisp(event)" readonly="readonly"/></Td>
					</Tr>
				</tbody>
				<tfoot>
					<Tr>
						<Td><label for="c1"><span></span></label></Td>
						<Td>합계</Td>
						<Td><input type="text" style="width: 80%" readonly="readonly" class="read_only" /></Td>
						<Td><input type="text" style="width: 80%" readonly="readonly" class="read_only" /></Td>
					</Tr>
				</tfoot>
			</table> --%>
			<!-- 표시사항 배합비 close --------------------------------------------------------------------------------------------------------------------------------------------------------->
			<!-- 재료 start --------------------------------------------------------------------------------------------------------------------------------------------------------->
			<div class="title5" style="float: left; margin-top: 30px;">
				<span class="txt">04. 재료</span>
			</div>
			<div id="packageHeaderDiv" class="table_header07">
				<span class="table_order_btn">
					<button class="btn_up" onclick="moveUp(this)"></button><button class="btn_down" onclick="moveDown(this)"></button>
				</span>
				<span class="table_header_btn_box">
					<button class="btn_add_tr" onclick="addRow(this, 'pkg')"></button><button class="btn_del_tr" onclick="removeRow(this)"></button>
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
					<col width="7%">
				</colgroup>
				<thead>
					<tr>
						<th><input type="checkbox" id="packageTable_1" onclick="checkAll(event)"><label for="packageTable_1"><span></span></label></th>
						<th>재료코드</th>
						<th>재료명</th>
						<th>재료사양</th>
						<th>단위</th>
						<th>BOM수량</th>
						<th>BOM 단위</th>
						<th>BOM 항목</th>
						<th>공정로스</th>
						<th>저장위치</th>
					</tr>
				</thead>
				<tbody id="packageTbody_1" name="packageTbody">
					<Tr id="pkgRow_1" class="temp_color">
						<Td><input type="checkbox" id="package_1"><label for="package_1"><span></span></label></Td>
						<Td>
							<input type="hidden" name="itemImNo" style="width: 100px" class="req code_tbl"/>
							<input type="text" name="itemSapCode" style="width: 100px" class="req code_tbl" onkeyup="checkMaterail(event, 'R', '')" value=""/>
							<button class="btn_code_search2" onclick="openMaterialPopup(this, 'R')"></button>
						</Td>
						<Td><input type="text" name="itemName" style="width: 85%" readonly="readonly" class="read_only" /><button class="btn_code_info2"></button></Td>
						<td><input type="text" name="itemBomAmount" onkeyup="clearNoNum(this)" style="width:80%" class="req code_tbl"><button class="btn_code_search3" onclick="openUnitDialog(event)"></button></td>
						<Td>
							<input type="text" name="itemOrgUnit" style="width: 100%" class="readonly" readonly="readonly"/>
							<input type="hidden" name="itemFomulaType"/>
						</Td>
						<td><input type="text" name="itemBomRate" style="width:100%" class="req" onkeyup="clearNoNum(this)"></td>
						<Td><input type="text" name="itemUnit" style="width: 100%" class="readonly" readonly="readonly" /></Td>
						<Td><input type="text" name="itemPosnr" style="width: 100%" /></Td>
						<Td><input type="text" name="itemScrap" style="width: 80%"/>%</Td>
						<Td>
							<!-- <input type="text" name="itemStorageCode" style="width: 100%; cursor: pointer" class="read_only" readonly="readonly" onclick="openStorageDialog(event, 'dialog_storage')"/> -->
							<div class="selectbox" style="width: 90%">
								<select name="itemStorageCode" id="select_storage_package_1">
									<option value="" selected>선택</option>
									<c:forEach items="${specificStorageList}" var="sotrage">
										<option value="${sotrage.storageCode}">${sotrage.storageCode}</option>
									</c:forEach>
								</select>
								<label for="select_storage_package_1">선택</label>
							</div>
						</Td>
					</Tr>
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
					
					<c:if test="${productDevDoc.productType1 != null and productDevDoc.productType1 != ''}">
						<c:set var="productTypeText" value="${productDevDoc.productType1Text}" />
					</c:if>
					<c:if test="${productDevDoc.productType2 != null and productDevDoc.productType2 != ''}">
						<c:set var="productTypeText" value="${productTypeText}>${productDevDoc.productType2Text}" />
					</c:if>
					<c:if test="${productDevDoc.productType3 != null and productDevDoc.productType3 != ''}">
						<c:set var="productTypeText" value="${productTypeText}>${productDevDoc.productType3Text}" />
					</c:if>
					
					<tbody>
						<tr>
							<th style="border-left: none;">식품유형</th>
							<td colspan="3">
								${productDevDoc.productType1Text}
								<c:if test="${productDevDoc.productType2Text != '' && productDevDoc.productType2Text != null }">
									&gt; ${productDevDoc.productType2Text}
								</c:if>	
								<c:if test="${productDevDoc.productType3Text != '' && productDevDoc.productType3Text != null }">
									&gt; ${productDevDoc.productType3Text}
								</c:if>
								<c:if test="${(productDevDoc.sterilizationText != '' && productDevDoc.sterilizationText != null) && (productDevDoc.etcDisplayText != '' && productDevDoc.etcDisplayText != null)}">
									&lpar;
									${(productDevDoc.sterilizationText != '' && productDevDoc.sterilizationText != null)? productDevDoc.sterilizationText : '-'} 
									&sol;
									${(productDevDoc.etcDisplayText != '' && productDevDoc.etcDisplayText != null)? productDevDoc.etcDisplayText : '-'} 
									&rpar;
								</c:if>
							</td>
						</tr>
						<tr>
							<th style="border-left: none;">완제중량</th>
							<td>
								<input type="text" name="compWeight" style="width: 20%; float: left" class="req" onkeyup="clearNoNum(this)"/>
								<div class="selectbox req ml5" style="width: 15%">
									<label for="select_compWeightUnit">Kg</label>
									<select name="compWeightUnit" id="select_compWeightUnit">
										<option value="g">g</option>
										<option value="Kg" selected>Kg</option>
										<option value="mL">mL</option>
										<option value="L">L</option>
									</select>
								</div>
								<input name="compWeightText" type="text" style="width: 50%;" class="ml5"/>
							</td>
							<th></th><td></td>
						</tr>
						<tr>
							<th style="border-left: none;">표기중량</th>
							<td>
								<input type="text" name="dispWeight" onkeyup="changeWeight(event)" style="width: 20%; float: left" class="req" />
								<div class="selectbox req ml5" style="width: 15%">
									<label for="select_dispWeightUnit">Kg</label>
									<select name="dispWeightUnit" id="select_dispWeightUnit" onchange="changeDispWeightUnit(event)">
										<option value="g">g</option>
										<option value="Kg" selected>Kg</option>
										<option value="mL">mL</option>
										<option value="L">L</option>
									</select>
								</div>
								<input name="dispWeightText" type="text" style="width: 50%;" class="ml5"/>
							</td>
							<!-- <th>개별관리중량</th>
							<td><input type="text" style="width: 50%;" class="ml5" name="distPeriSite"></td> -->
							<th>관리중량</th>
							<td>
								<input type="text" name="adminWeightFrom" onkeyup="changeWeight(event)" style="width: 20%; float: left" class="req"/>
								<div class="selectbox req ml5" style="width: 15%">
									<label for="select_adminWeightUnitFrom">Kg</label>
									<select name="adminWeightUnitFrom" id="select_adminWeightUnitFrom">
										<option value="g">g</option>
										<option value="Kg" selected>Kg</option>
										<option value="mL">mL</option>
										<option value="L">L</option>
									</select>
								</div>
								<span style="float:left; margin-left:  2px;">~</span>
								<input type="text" name="adminWeightTo" onkeyup="changeWeight(event)" style="width: 20%; float: left; margin-left: 2px" class="req"/>
								<div class="selectbox req ml5" style="width: 15%">
									<label for="select_adminWeightUnitTo">Kg</label>
									<select name="adminWeightUnitTo" id="select_adminWeightUnitTo">
										<option value="g">g</option>
										<option value="Kg" selected>Kg</option>
										<option value="mL">mL</option>
										<option value="L">L</option>
									</select>
								</div>
							</td>
						</tr>
						<tr>
							<th style="border-left: none;">품목보고번호</th>
							<td>
								<div class="selectbox req" style="width: 36%">
									<label for="select_regGubun">신규</label>
									<select name="regGubun" id="select_regGubun">
										<option value="N" selected>신규</option>
							    		<option value="E">기존</option>
							    		<option value="C">변경</option>
									</select>
								</div>
								<input type="text" name="regNum" style="width: 50%;" class="ml5" />
							</td>
							<th>소비기한</th>
							<td>
								 등록서류: <input type="text" name="distPeriDoc" style="width: 130px;" class="req" />&nbsp;&nbsp;현장: <input type="text" name="distPeriSite" style="width: 130px;" class="req" />
							</td>
						</tr>
						<tr>
							<th style="border-left: none;">성상</th>
							<td><input type="text" name="ingredient" style="width: 100%;" class="req" /></td>
							<th>보관조건</th>
							<td>
								<div class="selectbox req" style="width: 99%">
									<select id="keepConditionCode" name="keepConditionCode" onchange="selectChange(event)"></select>
									<label for="keepConditionCode">선택</label>
								</div>
								<input class="ml5" type="text" name="keepCondition" style="width: 60%; display:none">
							</td>
						</tr>
						<tr>
							<th style="border-left: none;">용도용법</th>
							<td colspan="3"><input type="text" name="usage" style="width: 100%;" class="req" /></td>
						</tr>
						<tr>
							<th style="border-left: none;">포장재질</th>
							<td colspan="3"><input type="text" name="packMaterial" style="width: 100%;" class="req" /></td>
						</tr>
						<tr>
							<th style="border-left: none;">품목제조보고서 포장단위</th>
							<td colspan="3"><input type="text" name="packUnit" style="width: 100%;" /></td>
						</tr>
						<tr>
							<th style="border-left: none;">어린이 기호식품 고열량 저영양 해당 유무</th>
							<td colspan="3">
								<input type="radio" name="childHarm" id="radio_childHarm1" value="1" checked /><label for="radio_childHarm1"><span></span>예</label>
								<input type="radio" name="childHarm" id="radio_childHarm2" value="2"><label for="radio_childHarm2"><span></span>아니요</label>
								<input type="radio" name="childHarm" id="radio_childHarm3" value="3"><label for="radio_childHarm3"><span></span>해당 없음</label>
							</td>
						</tr>
						<tr>
							<th style="border-left: none;">비고</th>
							<!-- <td colspan="3"><input type="text" name="note" style="width: 100%;" /></td> -->
							<td colspan="3"><textarea type="text" name="noteText" style="width: 100%; height: 130px"></textarea></td>
						</tr>
						<!-- S201109-00014 -->
						<tr>
							<th style="border-left: none;">QNS 허들정보</th>
							<td>
								<%-- 
								<input type="text" name="qns" name="note" style="width: 100%;" value="${qns}"/>
								 --%>
							</td>
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
									<td style="border-left: none;">
										<textarea name="menuProcess" style="width: 100%; height: 130px"></textarea>
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
										<textarea name="standard" style="width: 100%; height: 130px"></textarea>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					<!-- 제조규격 close --------------------------------------------------------------------------------------------------------------------------------------------------------->
				</div>
			</div>
			<!-- 생산소모품 start --------------------------------------------------------------------------------------------------------------------------------------------------------->
			<div class="title5" style="float: left; margin-top: 30px;">
				<span class="txt">08. 생산 소모품 (BOM 담당자만 입력)</span>
			</div>
			<c:if test="${userUtil:getIsAdmin(pageContext.request) == 'Y' || userUtil:getUserGrade(pageContext.request) == '3'}">
				<div id="consumeHeaderDiv" class="table_header07">
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
						<col width="7%">
					</colgroup>
					<thead>
						<tr>
							<th><input type="checkbox" id="consTable_1" onclick="checkAll(event)"><label for="consTable_1"><span></span></label></th>
							<th>재료코드</th>
							<th>재료명</th>
							<th>BOM수량</th>
							<th>BOM 단위</th>
							<th>BOM 항목</th>
							<th>공정로스</th>
							<th>저장위치</th>
						</tr>
					</thead>
					<tbody id="consumeTbody_1" name="consumeTbody">
						<Tr id="consumeRow_1">
							<Td><input type="checkbox" id="consume_1"><label for="consume_1"><span></span></label></Td>
							<Td>
								<input type="hidden" name="itemImNo" style="width: 100px" class="req code_tbl"/>
								<input type="text" name="itemSapCode" style="width: 100px" class="req code_tbl" onkeyup="checkMaterail(event, '', '')" value=""/>
								<button class="btn_code_search2" onclick="openMaterialPopup(this, '')"></button>
							</Td>
							<Td><input type="text" name="itemName" style="width: 85%" readonly="readonly" class="read_only" /><button class="btn_code_info2"></button></Td>
							<Td><input type="text" name="itemBomRate" style="width: 100%" class="req" onkeyup="clearNoNum(this)"/></Td>
							<Td><input type="text" name="itemUnit" style="width: 100%" class="readonly" readonly="readonly"/></Td>
							<Td><input type="text" name="itemPosnr" style="width: 100%" /></Td>
							<Td><input type="text" name="itemScrap" style="width: 80%" />%</Td>
							<Td>
								<!-- <input type="text" name="itemStorageCode" style="width: 100%; cursor: pointer" class="read_only" readonly="readonly" onclick="openStorageDialog(event, 'dialog_storage')"/> -->
								<div class="selectbox" style="width: 90%">
									<select name="itemStorageCode" id="select_storage_consume_1">
										<option value="" selected>선택</option>
										<c:forEach items="${specificStorageList}" var="sotrage">
											<option value="${sotrage.storageCode}">${sotrage.storageCode}</option>
										</c:forEach>
									</select>
									<label for="select_storage_consume_1">선택</label>
								</div>
							</Td>
						</Tr>
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
						<%-- <col width="50px"> --%>
						<col width="12%">
						<col width="12%">
						<col />
						<col width="12%">
						<col width="12%">
						<col width="12%">
						<col width="12%">
					</colgroup>
					<tbody name="specTbody">
						<tr>
							<th style="border-left: none;">전체</th>
							<td>크기 </td>
							<td colspan="4"><input type="text" name="size" style="width: 100%" /></td>
							<td>± <input type="text" name="sizeErr" style="width: 50px" /> %
							</td>
						</tr>
						<tr>
							<th style="border-left: none;">성상</th>
							<td>토핑,착색,흐름성 </td>
							<td colspan="4"><input type="text" name="feature" style="width: 100%" /></td>
							<td></td>
						</tr>
						<tr>
							<th style="border-left: none;" rowspan="6">전체</th>
							<td>수분(%)</td>
							<td><input type="text" name="productWater" style="width: 150px" /></td>
							<th rowspan="6">내용물</th>
							<td>수분(%)</td>
							<td><input type="text" name="contentWater" style="width: 150px" /></td>
							<td>± <input type="text" name="contentWaterErr" style="width: 50px" />
							</td>
						</tr>
						<tr>
							<td>AW</td>
							<td><input type="text" name="productAw" style="width: 150px" /></td>
							<td>AW</td>
							<td><input type="text" name="contentAw" style="width: 150px" /></td>
							<td>± <input type="text" name="contentAwErr" style="width: 50px" />
							</td>
						</tr>
						<tr>
							<td>pH</td>
							<td><input type="text" name="productPh" style="width: 150px" /></td>
							<td>pH</td>
							<td><input type="text" name="contentPh" style="width: 150px" /></td>
							<td>± <input type="text" name="contentPhErr" style="width: 50px" />
							</td>
						</tr>
						<tr>
							<td>염도</td><!-- 명도 >> 염도 -->
							<td><input type="text" name="productBrightness" style="width: 150px" /></td>
							<td>염도</td>
							<td><input type="text" name="contentSalinity" style="width: 150px" /></td>
							<td>± <input type="text" name="contentSalinityErr" style="width: 50px" />
							</td>
						</tr>
						<tr>
							<td>당도</td><!-- 색도 >> 당도  -->
							<td><input type="text" name="productTone" style="width: 150px" /></td>
							<td>당도</td>
							<td><input type="text" name="contentBrix" style="width: 150px" /></td>
							<td>± <input type="text" name="contentBrixErr" style="width: 50px" />
							</td>
						</tr>
						<tr>
							<td>점도</td><!-- Hardness >> 점도 -->
							<td><input type="text" name="productHardness" style="width: 150px" /></td>
							<td>Hardness</td><!-- 색도 >> Hardness  -->
							<td><input type="text" name="contentTone" style="width: 150px" /></td>
							<td>± <input type="text" name="contentToneErr" style="width: 50px" />
							</td>
						</tr>
						<tr>
							<th style="border-left: none;">추가</th>
							<td>기타 관리규격</td><!-- 산도 >> 기타관리 규격 -->
							<td colspan="4"><input type="text" name="noodlesAcidity" style="width: 100%" /></td>
							<td></td>
						</tr>
						<tr>
							<th style="border-left: none;" rowspan="2">국수(면류)<br /> * 주정침지제품에<br />한함.
							</th>
							<td>수분(%)</td>
							<td colspan="4"><input type="text" name="noodlesWater" style="width: 150px" /></td>
							<td></td>
						</tr>
						<tr>
							<td>pH</td>
							<td colspan="4"><input type="text" name="noodlesPh" style="width: 150px" /></td>
							<td></td>
						</tr>
						<tr>
							<th style="border-left: none;" colspan="2">탈산소제</th>
							<td colspan="4"><input type="text" name="deoxidizer" style="width: 100%" /></td>
							<td></td>
						</tr>
						<tr>
							<th style="border-left: none;" colspan="2">질소충전제품</th>
							<td colspan="4"><input type="text" name="nitrogenous" style="width: 100%" /></td>
							<td></td>
						</tr>
					</tbody>
				</table>
			</div>
			<!-- 제품규격 close --------------------------------------------------------------------------------------------------------------------------------------------------------->
			<!-- 제품규격(밀다원) start --------------------------------------------------------------------------------------------------------------------------------------------------------->
			<div class="title5" style="float: left; margin-top: 30px;">
				<span class="txt">10. 제품규격(밀다원)</span>
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
								<input type="text" name="moisture" style="float:left; width: 70%"/>
								<div class="selectbox" style="width: 30%">
									<label for="moistureUnit">↑</label>
									<select name="moistureUnit" id="moistureUnit">
										<option value="gt" selected>↑</option>
										<option value="lt">↓</option>
									</select>
								</div>
							</td>
							<th>Ash(%)</th>
							<td>
								<!-- <input type="text" name="ash" style="width: 100%"/> -->
								<input type="text" name="ashFrom" style="width: 45%"/>
								~<input type="text" name="ashTo" style="width: 45%" />
							</td>
							<th>Protein(%)</th>
							<td>
								<input type="text" name="protein" style="width: 50%" />
								<input type="text" name="proteinErr" style="width: 20%; float:right"/>
								<div  style="float:right;"><span>±</span></div>
							</td>
						</tr>
						<tr>
							<th>Water absorption(%)</th>
							<td>
								<!-- <input type="text" name="waterAbs" style="width: 100%"/> -->
								<input type="text" name="waterAbsFrom" style="width: 45%"/>
								~<input type="text" name="waterAbsTo" style="width: 45%"/>
							</td>
							<th>Stability(min)</th>
							<td>
								<!-- <input type="text" name="stability" style="width: 100%" /> -->
								<input type="text" name="stabilityFrom" style="width: 45%" />
								~<input type="text" name="stabilityTo" style="width: 45%" />
							</td>
							<th>Development time(min)</th>
							<td>
								<input type="text" name="devTime" style="float: left; width: 70%" />
								<div class="selectbox" style="width: 30%">
									<label for="devTimeUnit">↑</label>
									<select name="devTimeUnit" id="devTimeUnit">
										<option value="gt" selected>↑</option>
										<option value="lt">↓</option>
									</select>
								</div>
							</td>
						</tr>
						<tr>
							<th>P/L</th>
							<td>
								<!-- <input type="text" name="pl" style="width: 100%" /> -->
								<input type="text" name="plFrom" style="width: 45%" />
								~<input type="text" name="plTo" style="width: 45%" />
							</td>
							<th>Maximum viscosity(BU)</th>
							<td>
								<input type="text" name="maxVisc" style="float:left; width: 70%"/>
								<div class="selectbox" style="width: 30%">
									<label for="maxViscUnit">↑</label>
									<select name="maxViscUnit" id="maxViscUnit">
										<option value="gt" selected>↑</option>
										<option value="lt">↓</option>
									</select>
								</div>
							</td>
							<th>FN(sec)</th>
							<td>
								<!-- <input type="text" name="fn" style="width: 100%" /> -->
								<input type="text" name="fnFrom" style="width: 45%" />
								~<input type="text" name="fnTo" style="width: 45%" />
							</td>
						</tr>
						<tr>
							<th>Color(Lightness)</th>
							<td>
								<input type="text" name="color" style="float:left; width: 70%"/>
								<div class="selectbox" style="width: 30%">
									<label for="colorUnit">↑</label>
									<select name="colorUnit" id="colorUnit">
										<option value="gt" selected>↑</option>
										<option value="lt">↓</option>
									</select>
								</div>
							</td>
							<th>Wet gluten(%)</th>
							<td>
								<!-- <input type="text" name="wetGluten" style="width: 100%" /> -->
								<input type="text" name="wetGlutenFrom" style="width: 45%" />
								~<input type="text" name="wetGlutenTo" style="width: 45%" />
							</td>
							<th>Viscosity(Batter)mm</th>
							<td>
								<input type="text" name="visc" style="float: left; width: 70%" />
								<div class="selectbox" style="width: 30%">
									<label for="viscUnit">↑</label>
									<select name="viscUnit" id="viscUnit">
										<option value="gt" selected>↑</option>
										<option value="lt">↓</option>
									</select>
								</div>
							</td>
						</tr>
						<tr>
							<th>Particle size(Average)㎛</th>
							<td><input type="text" name="particleSize" style="width: 100%"/></td>
							<th></th>
							<td></td>
							<th></th>
							<td></td>
						</tr>
					</tbody>
				</table>
			</div>
			<!-- 제품규격(밀다원) close --------------------------------------------------------------------------------------------------------------------------------------------------------->
			
			<div class="btn_box_con5">
				<button class="btn_admin_gray" onClick="goMfgDetail()" style="width: 120px;">목록</button>
			</div>
			<div class="btn_box_con4">
				<button class="btn_admin_navi" onclick="saveMfgProcessDoc('7')">임시저장</button>
				<button class="btn_admin_sky" onclick="saveMfgProcessDoc('0')">저장</button>
				<button class="btn_admin_gray" onclick="goMfgDetail()">취소</button>
			</div>
			<hr class="con_mode" />
			<!-- 신규 추가 꼭 데려갈것 !-->
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
							<label id="label_dialogStorage" for="dialogStorage">선택</label>
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
					<dd style="width: 80%"><span>ROL</span></dd>
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

<!-- 제조공정서/제품개발문서 가져오기 START -->
<div class="white_content" id="dialog_import">
	<div class="modal positionCenter">
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
					<dt style="width:23%">생성타입</dt>
					<dd style="width:77%">
						<input type="radio" name="docImportType" id="docImportTypeDesign" value="design" onchange="changeImportType(event)" checked>
						<label for="docImportTypeDesign" style="width: 400px"><span></span>제품설계서 가져오기</label>
						<input type="radio" name="docImportType" id="docImportTypeDev" value="dev" onchange="changeImportType(event)">
						<label for="docImportTypeDev" style="width: 400px"><span></span>제조공정서 가져오기</label>
					</dd>
				</li>
				<li id="dialog_create_li_design" class="mb5" style="display: block">
					<dt style="width:23%">제품설계서 검색</dt>
					<dd style="width:77%">
						<div class="selectbox req" style="width:30%;">  
							<label for="dialog_companyCode">선택</label> 
							<select id="dialog_companyCode" onchange="companyChange(event, 'dialog_plantCode')">
								<option value="" selected>--회사선택--</option>
								<c:forEach items="${companyList}" var="company" varStatus="status">
									<c:set var="selected" value="${status.index == 0 ? 'selected' : ''}"></c:set>
									<option value="${company.companyCode}">${company.companyName}</option>
								</c:forEach>
							</select>
							</div>
							<div class="selectbox  ml5" style="width:30%;">  
							<label id="label_dialog_plantCode" for="dialog_plantCode">공장상세선택</label> 
							<select id="dialog_plantCode">
								<option value="">공장상세선택</option>
							</select>
						</div>
						<input id="dialog_design_productName" type="text" style="width:25%; margin-left:5px; padding-bottom:3px" placeholder="제품명으로 검색"
						/><button class="btn_small_search ml5" onclick="searchDesignDoc()">검색</button>
						
						<div id="designDocSelectDiv" style="display: none">
							<br>
	                        <div class="selectbox req" style="width:35%;">
	                            <label id="label_select_designDoc" for="select_designDoc">제품개발문서 선택</label>
	                            <select id="select_designDoc" onchange="searchDesignDocDetailList(event)">
	                            	<option selected>제품개발문서 선택</option>
	                            </select>
	                        </div>
	                        <div class="selectbox req ml5" style="width:50%;">
	                            <label id="label_select_designDocDetail" for="select_designDocDetail">설계서 선택</label>
	                            <select id="select_designDocDetail">
	                            	<option selected>설계서 선택</option>
	                            </select>
	                        </div>
                        </div>
					</dd>
				</li>
                <li id="dialog_create_li_mfg" class="mb5" style="display: none">
					<dt style="width:23%">제조공정서 검색</dt>
					<dd style="width:77%">
						<div class="selectbox req" style="width:20%;">  
							<label for="productType1" id="label_productType1"> 전체</label> 
							<select id="productType1" name="productType1" onChange="loadProductType('2','productType2')">
							</select>
						</div>
						<div class="selectbox req ml5" style="width:20%;" id="li_productType2">  
							<label for="productType2" id="label_productType2"> 전체</label> 
							<select id="productType2" name="productType2" onChange="loadProductType('3','productType3')">
							</select>
						</div>
						<div class="selectbox req ml5" style="width:20%;" id="li_productType3">  
							<label for="productType3" id="label_productType3"> 전체</label> 
							<select id="productType3" name="productType3">
							</select>
						</div>
						<input id="dialog_mfg_productName" type="text" style="width:25%; margin-left:5px; padding-bottom:3px" placeholder="제품명으로 검색"
						/><button class="btn_small_search ml5" onclick="searchDevDoc()">검색</button>
						<div id="mfgDocSelectDiv" style="display: none">
							<br>
	                        <div class="selectbox req" style="width:25%;">
	                            <label id="label_select_devDoc" for="select_devDoc">제품개발문서 선택</label>
	                            <select id="select_devDoc" onchange="searchDocVersion(event)">
	                            	<option selected>제품개발문서 선택</option>
	                            </select>
	                        </div>
	                        <div class="selectbox req ml5" style="width:10%;">
	                            <label id="label_select_docVersionc" for="select_docVersion">버전</label>
	                            <select id="select_docVersion" onchange="searchMfgDoc()">
	                            	<option selected>버전</option>
	                            </select>
	                        </div>
	                        <div class="selectbox req ml5" style="width:57%;">
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