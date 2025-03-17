<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="kr.co.aspn.util.*" %>
<%@ taglib prefix="userUtil" uri="/WEB-INF/tld/userUtil.tld"%>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ taglib prefix="dateUtil" uri="/WEB-INF/tld/dateUtil.tld"%>

<title>제품설계서>설계서 신규작성</title>

<style>
.positionCenter{
	position: absolute;
	transform: translate(-50%, -45%);
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
		loadCodeList( "PRODCAT1", "productType1" );
		
		subProdTabBtn = '<li id="subProdAddBtn_1" class="select" onclick="changeTab(this)">'+$('#subProdAddBtn_1').html()+'</li>';
		
		subProdHead = '<div name="subProdHead">'+$('div[name=subProdHead]:first').html()+'</div>';
		subProdDiv = '<div name="subProdDiv">'+$('div[name=subProdDiv]:first').html()+'</div>'
		
		mixTable = '<div class="nomal_mix">'+$('div.nomal_mix:first').html()+'</div>';
		contentTable = '<div class="nomal_mix">'+$('div.nomal_mix:last').html()+'</div>';
		
		mixRow = '<tr>'+$('div.nomal_mix:first table tbody tr:first').html()+'</tr>';
		contentRow = '<tr>'+$('div.nomal_mix:last table tbody tr:first').html()+'</tr>';
		dispRow = '<tr>'+$('tbody[name=dispTbody]').children('tr').html()+'</tr>';
		packageRow = '<tr>'+$('tbody[name=packageTbody]').children('tr').html()+'</tr>';
		
		//$('input[name=itemSapCode]').bind('keyup', function(e){ if(e.keyCode== 13) $(e.target).next().click() });
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
	
	function loadProductType( grade, objectId ) {
		var URL = "../common/productTypeListAjax";
		var groupCode = "PRODCAT"+grade;
		var codeValue = "";
		if( grade == '2' ) {
			codeValue = $("#productType1").selectedValues()[0]+"-";
			$("#productType2").removeOption(/./);
			$("#productType2").addOption("", "전체", false);
			$("#label_productType2").html("전체");
			
			$("#productType3").removeOption(/./);
			$("#productType3").addOption("", "전체", false);
			$("#label_productType3").html("전체");
		} else if( grade == '3' ) {
			codeValue = $("#productType2").selectedValues()[0]+"-";
			
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
					return alert('제품설계서 검색 실패[1] - 시스템 담당자에게 문의하세요');
				}
			}, error: function(a,b,c){
				return alert('제품설계서 검색 실패[1] - 시스템 담당자에게 문의하세요');
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
	
	function changeMfgCompanySelect(e, targetId){
		if($(e.target).children('option:first').text() == '--회사선택--')
			$(e.target).children('option:first').remove();
		
		var companyCode = e.target.value;
		var plantList = '${plantList}';
		$('#'+targetId).empty();
		
		var selectedPlantList = JSON.parse(plantList).filter(function(v){
			if(v.companyCode == companyCode) {
				return v;
			}
		})
		
		selectedPlantList.forEach(function(v, i){
			if(v.companyCode == companyCode) {
				if(i == 0){
					$('#'+targetId).append('<option value="'+v.plantCode+'" selected>'+v.plantName+'</option>')
					$('#'+targetId).change();
				} else {
					$('#'+targetId).append('<option value="'+v.plantCode+'">'+v.plantName+'</option>')
				}
			}
		})
	}
	
	function searchDevDoc(){
		var productType1 = $('#productType1').val();
		var productType2 = $('#productType2').val();
		var productType3 = $('#productType3').val();
		var productName = $('#dialog_mfg_productName').val();
		
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
					var devDocList = JSON.parse(data)
					
					if(devDocList.length <= 0){
						return alert('');
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
	
	/* function openMaterailPopup(element){
		var parentRowId = $(element).parent().parent('tr')[0].id;
		
		var url = '/design/getMaterialListPopup';
		url += "?parentRowId="+parentRowId
		var popupName = 'materialPopup';
		var w=700;
		var h=720;
		var winl = (screen.width-w)/2;
		var wint = (screen.height-h)/2;
		var option ='height='+h+',';
		option +='width='+w+',';
		option +='scrollbars=yes,';
		option +='resizable=no';
		
		window.open(url, popupName, option);
	} */
	
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
			$('#'+parentRowId).css('background-color', '#ffdb8c');
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
		
		var tempSubProdDiv = subProdDiv.replace(/mixTbody_1/gi, mixTableParentId);
		tempSubProdDiv = tempSubProdDiv.replace(/mixRow_1/gi, mixRowParentId);
		tempSubProdDiv = tempSubProdDiv.replace(/mix_1/gi, mixParentId);
		tempSubProdDiv = tempSubProdDiv.replace(/contentTbody_1/gi, contentTableParentId);
		tempSubProdDiv = tempSubProdDiv.replace(/contentRow_1/gi, contentRowParentId);
		tempSubProdDiv = tempSubProdDiv.replace(/content_1/gi, contentParentId);
		
		/* var tab = $('div.tab03').children('ul').children('a[id^=sub]:last');
		tab.children('li:first').click(changeTab(tab.click())); */
		
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
		setSpecificId('tbody', contentTableParentId, Math.random().toString(36).substr(2, 9));
		setSpecificId('tr', contentRowParentId, Math.random().toString(36).substr(2, 9));
		setSpecificId('input', contentParentId, Math.random().toString(36).substr(2, 9));
		setUniqueId('input', 'mixTable_1');
		setUniqueId('input', 'contentTable_1');
		
		/* setUniqueId('input', 'mixTable_1');
		setUniqueId('input', 'contentTable_1');
		setUniqueId('input', 'mix_1');
		setUniqueId('input', 'content_1'); */
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
		
		var randomId = Math.random().toString(36).substr(2, 9);
		$(element).parent().children('div.add_nomal_mix').before(tableBody);
		var insertedTbody = $(element).prev().children('table').children('thead');
		insertedTbody.children('tr').children('th:first').children('input[type=checkbox]').attr('id', type+'_'+randomId+'th')
		insertedTbody.children('tr').children('th:first').children('label').attr('for', type+'_'+randomId+'th')
		var insertedTbody = $(element).prev().children('table').children('tbody');
		insertedTbody.attr('id', bodyId+randomId);
		insertedTbody.children('tr').attr('id', type+'Row_'+randomId);
		insertedTbody.children('tr').children('td:first').children('input[type=checkbox]').attr('id', type+'_'+randomId)
		insertedTbody.children('tr').children('td:first').children('label').attr('for', type+'_'+randomId)
		//setUniqueId('input', type+'Table_1');
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
		var bodyId = $(element).parent().parent().next().children('tbody').attr('id').split('_')[1];
		$(element).parent().parent().next().children('tbody').children('tr:last').attr('id', type + 'Row_' + bodyId + '_' + randomId);
		$(element).parent().parent().next().children('tbody').children('tr:last').children('td').children('input[type=checkbox]').attr('id', type+'_'+randomId);
		$(element).parent().parent().next().children('tbody').children('tr:last').children('td').children('label').attr('for', type+'_'+randomId);
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
	}
	
	function removeRow(element){
		$(element).parent().parent().next().children('tbody').children('tr').toArray().forEach(function(v, i){
			var checkBoxId = $(v).children('td:first').children('input[type=checkbox]')[0].id;
			if($('#'+checkBoxId).is(':checked')) $(v).remove();
		})
		calcBaseTable(event);
		calcPkgTable();
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
		
		if($('input[name=subProdName]').val().length <= 0){
			$('input[name=subProdName]').focus()
			alert('부속제품명을 입력해주세요');
			return false;
		}
		
		if($('input[name=subProdDesc]').val().length <= 0){
			$('input[name=subProdDesc]').focus()
			alert('부속제품 설명을 입력해주세요');
			return false;
		}
		
		if($('input[name=subProdDesc]').val().length <= 0){
			$('input[name=subProdDesc]').focus()
			alert('부속제품 설명을 입력해주세요');
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
		
		return true;
	}
	
	function saveDocDetail(){
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
			url: '/design/saveProductDesignDocDetail',
			contentType: 'multipart/form-data',
			processData: false,
            contentType: false,
			type: 'post',
			data: formData, 
			success: function(data){
				if(data == 'S'){
					alert('생성되었습니다');
					location.href='/design/productDesignDocDetail?pNo='+'${pNo}';
					$('#lab_loading').hide();
				} else {
					$('#lab_loading').hide();
					return alert('문서 생성 오류[1]');
				}
			},
			error: function(a,b,c){
				//console.log(a,b,c);
				$('#lab_loading').hide();
				return alert('문서 생성 오류[2]');
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
		postData[propPath+'itemSapPrice'] = $(item).children('td').children('input[name=itemSapPrice]').val();
		postData[propPath+'itemVolume'] = $(item).children('td').children('input[name=itemVolume]').val();
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
		    		var itemSapPrice = $(pkgItem).children('td').children('input[name$=itemSapPrice]').val();
		    		var itemVolume = $(pkgItem).children('td').children('input[name$=itemVolume]').val();
		    		var itemUnitPrice = $(pkgItem).children('td').children('input[name$=itemUnitPrice]').val();
		    		
		    		postData['pkg['+pkgItemIndex+'].itemSapCode'] = itemSapCode;
		    		postData['pkg['+pkgItemIndex+'].itemName'] = itemName;
		    		postData['pkg['+pkgItemIndex+'].itemSapPrice'] = itemSapPrice;
		    		postData['pkg['+pkgItemIndex+'].itemVolume'] = itemVolume;
		    		postData['pkg['+pkgItemIndex+'].itemUnitPrice'] = itemVolume;
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
					
					$(item).children('td').children('input[name=itemCustomPrice]').val(round(mixingRatio*itemUnitPrice, 3));
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
						itemProportion = round(mixingRatio/(sumMixingRatio-sumWaterRatio)*100, 3);
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
						$(td).children('input').val(round(sumMixingRatio, 2))
						$(td).children('span').text(round(sumMixingRatio, 2))
					}
					if(ndx == 4){
						$(td).children('input').val(round(sumPrice, 0))
						$(td).children('span').text(round(sumPrice, 0))
					}
					if(ndx == 5){
						$(td).children('input').val(round(sumProportion, 0))
						$(td).children('span').text(round(sumProportion, 0))
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
					
					$(item).children('td').children('input[name=itemCustomPrice]').val(round(mixingRatio*itemUnitPrice, 3));
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
						itemProportion = round(mixingRatio/(sumMixingRatio-sumWaterRatio)*100, 3);
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
						$(td).children('input').val(round(sumMixingRatio, 2))
						$(td).children('span').text(round(sumMixingRatio, 2))
					}
					if(ndx == 4){
						$(td).children('input').val(round(sumPrice, 0))
						$(td).children('span').text(round(sumPrice, 0))
					}
					if(ndx == 5){
						$(td).children('input').val(round(sumProportion, 0))
						$(td).children('span').text(round(sumProportion, 0))
					}
				})
			})
		})
		
		//calcTotalTable();
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
		$('#packageTable').children('tfoot').children('tr').children('td:last').text(round(pkgPriceTotal, 3))
		
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
				if( unitPrice != '-') {
					unitPrice = round(unitPrice, 3);
				}
				
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
					combineTr += '<td>'+round((unitPrice/1000*divWeight*yieldRate), 3)+'</td>';
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
				if( unitPrice != '-') {
					unitPrice = round(unitPrice, 3);
				}
				
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
					combineTr += '<td>'+round((unitPrice/1000*divWeight*yieldRate), 3)+'</td>';
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
		
		var totalRate = round(Number(combineData['total'].sumRawPrice/(retailPrice*rawPriceRate)*100), 2);
		var componentRate = round(Number(combineData['component'].sumRawPrice/(retailPrice*rawPriceRate)*100), 2);
		var packageRate = round(Number(combineData['package'].sumRawPrice/retailPrice*rawPriceRate*100), 2);
		var productRateTotal = 0;
		totalRate = isNaN(totalRate) ? '-' : totalRate;
		componentRate = isNaN(componentRate) ? '-' : componentRate;
		packageRate = isNaN(packageRate) ? '-' : packageRate;
		productRateTotal= Number(componentRate) + Number(packageRate);
		productRateTotal = isNaN(productRateTotal) ? '-' : productRateTotal;
		combineData['total'].sumRawPrice = round(combineData.total.sumRawPrice, 3);
		combineData['component'].sumRawPrice = round(combineData['component'].sumRawPrice, 3);
		combineData['package'].sumRawPrice = round(combineData['package'].sumRawPrice, 3); 
		
		var resultRawPrice = isNaN(combineData.total.sumRawPrice) ? '-' : combineData.total.sumRawPrice;
		productTotalPrie = isNaN(productTotalPrie) ? '-' : productTotalPrie;
		if( productTotalPrie != '-' ) {
			productTotalPrie = round(productTotalPrie, 3);
		}
		
		var combineFootTr;
		combineFootTr += '<tr><td colspan="3">합계</td><td>원료</td><td>'+combineData.total.weight+'</td><td>'+resultRawPrice+' ('+totalRate+'%)</td></tr>'
		combineFootTr += '<tr><td colspan="3"></td><td>재료</td><td></td><td>'+combineData['package'].sumRawPrice+' ('+packageRate+'%)</td></tr>'
		combineFootTr += '<tr><td colspan="3"></td><td>총 가격</td><td></td><td>'+ productTotalPrie +' ('+ productRateTotal +'%)</td></tr>'
		combineFootTr += '<tr><td colspan="2"></td><td></td><td>소매가격</td><td></td><td>'+ retailPrice +'</td></tr>'
		combineFootTr += '<tr><td colspan="2"></td><td></td><td>출하가</td><td>'+round((rawPriceRate*100), 2)+' %</td><td>'+ retailPrice*rawPriceRate +'</td></tr>'
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
	
	function getImportData(){
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
					
					$('input[name=productPrice]').val(designDocDetail.productPrice);
					$('input[name=volume]').val(designDocDetail.volume);
					$('input[name=rawPriceRate]').val(designDocDetail.plantPrice);
					//$('input[name=yieldRate]').val(designDocDetail.yieldRate);
					// TODO 임시적용 2.17 - 서준우대리 요청
					$('input[name=yieldRate]').val(100);
					$('input[name=memo]').val(designDocDetail.memo);
					// TODO 이미지파일 관련
					$('textarea[name=makeProcess]').val(designDocDetail.makeProcess);
					
					designDocDetail.sub.forEach(function(sub, subIndex){
						addSubProduct($('#subScroll').children('li:last')[0]);
						
						var subProdDivWeight = 0;
						sub.subMix.forEach(function(mix, mixIndex){
							subProdDivWeight += Number(mix.weight);
						})
						sub.subContent.forEach(function(sub, mixIndex){
							subProdDivWeight += Number(sub.weight);
						})
						
						var subProdName = sub.subProdName == null ? designDocDetail.productName : sub.subProdName;
						$('input[name=subProdName]:last').val(subProdName)
						$('input[name=subProdName]:last').siblings('span').text(subProdName)
						
						$('div[name=subProdDiv]:last').children('div:last').children('div:nth-child(2)').children('div:first').remove();
						sub.subMix.forEach(function(mix, mixIndex){
							addTable($('div[name=addMixDiv]:last')[0], 'mix');
							
							var mixDiv = $('div[name=subProdDiv]:last').children('div:last').children('div:nth-child(2)');
							var mixHeader = mixDiv.children('div.nomal_mix:last').children('div');
							var mixBody = mixDiv.children('div.nomal_mix:last').children('table').children('tbody');
							
							mixHeader.children('span').children('input[name=baseName]').val(mix.name);
							mixHeader.children('span').children('input[name=divWeight]').val(mix.weight);
							
							mixBody.empty();
							mix.subMixItem.forEach(function(item, itemIndex){
								mixHeader.children('span').children('button.btn_add_tr').click();
								mixBody.children('tr:last').children('td').children('input[name=itemSapCode]').val(item.itemSapCode);
								mixBody.children('tr:last').children('td').children('input[name=itemName]').val(item.itemName);
								mixBody.children('tr:last').children('td').children('input[name=mixingRatio]').val(item.mixingRatio);
								mixBody.children('tr:last').children('td').children('input[name=itemUnitPrice]').val(item.itemUnitPrice);
								mixBody.children('tr:last').children('td').children('input[name=itemUnit]').val(item.itemUnit);
								
								mixBody.children('tr:last').children('td').children('input[name=mixingRatio]').keyup();
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
								contBody.children('tr:last').children('td').children('input[name=mixingRatio]').val(item.mixingRatio);
								contBody.children('tr:last').children('td').children('input[name=itemUnitPrice]').val(item.itemUnitPrice);
								contBody.children('tr:last').children('td').children('input[name=itemUnit]').val(item.itemUnit);
								
								contBody.children('tr:last').children('td').children('input[name=mixingRatio]').keyup();
							})
						})
					})
					
					// 재료
					var pkgHeaderDiv = $('#packageHeaderDiv');
					var pkgBody = $('tbody[name=packageTbody]')
					pkgBody.empty();
					designDocDetail.pkg.forEach(function(pkg, pkgIndex){
						addRow(pkgHeaderDiv.children('span').children('button.btn_add_tr')[0], 'package')
						
						pkgBody.children('tr:last').children('td').children('input[name=itemSapCode]').val(pkg.itemSapCode);
						pkgBody.children('tr:last').children('td').children('input[name=itemName]').val(pkg.itemName);
						pkgBody.children('tr:last').children('td').children('input[name=itemUnitPrice]').val(pkg.itemUnitPrice);
						pkgBody.children('tr:last').children('td').children('input[name=itemUnit]').val(pkg.itemUnit);
						
					})
				}
			}, error: function(a,b,c){
				//console.log(a,b,c)
				return alert('제품개발문서 불러오기 실패[2] - 시스템 담당자에게 문의하세요');
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
					//console.log(mgfProcDoc)
					
					$('input[name=productPrice]').val('');
					$('input[name=volume]').val(mgfProcDoc.numBong);
					$('input[name=rawPriceRate]').val(mgfProcDoc.plantPrice);
					//$('input[name=yieldRate]').val(mgfProcDoc.bomRate);
					// TODO 임시적용 2.17 - 서준우대리 요청 수율 100
					$('input[name=yieldRate]').val(100);
					$('input[name=memo]').val(mgfProcDoc.memo);
					// TODO 이미지파일 관련
					$('textarea[name=makeProcess]').val(mgfProcDoc.menuProcess);
					
					// 원료
					mgfProcDoc.sub.forEach(function(sub, subIndex){
						addSubProduct($('#subScroll').children('li:last')[0]);
						
						$('input[name=subProdName]:last').val(sub.subProdName)
						$('input[name=subProdName]:last').siblings('span').text(sub.subProdName)
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
								mixBody.children('tr:last').children('td').children('input[name=mixingRatio]').val(item.bomAmount);
								mixBody.children('tr:last').children('td').children('input[name=itemUnitPrice]').val('');
								mixBody.children('tr:last').children('td').children('input[name=itemUnit]').val(item.unit);
								
								mixBody.children('tr:last').children('td').children('input[name=mixingRatio]').keyup();
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
					
					// 재료
					var pkgHeaderDiv = $('#packageHeaderDiv');
					var pkgBody = $('tbody[name=packageTbody]')
					pkgBody.empty();
					mgfProcDoc.pkg.forEach(function(pkg, pkgIndex){
						addRow(pkgHeaderDiv.children('span').children('button.btn_add_tr')[0], 'package')
						
						pkgBody.children('tr:last').children('td').children('input[name=itemSapCode]').val(pkg.itemCode);
						pkgBody.children('tr:last').children('td').children('input[name=itemName]').val(pkg.itemName);
						pkgBody.children('tr:last').children('td').children('input[name=itemUnitPrice]').val('');
						pkgBody.children('tr:last').children('td').children('input[name=itemUnit]').val(pkg.unit);
					})
				}
			},
			error: function(a,b,c){
				
			}
		})
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
		$('li[id^=subProdAddBtn]').toArray().forEach(function(element){$(element).remove()})
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
						$('#'+rowId).css('background-color', '#ffdb8c'); //#ffdb8c
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
	
	//반올림 처리
	function round(n, digits) {
	  if (digits >= 0) return parseFloat(Number(n).toFixed(digits)); // 소수부 반올림
	  digits = Math.pow(10, digits); // 정수부 반올림
	  var t = Math.round(n * digits) / digits;
	  return parseFloat(t.toFixed(0));
	}
	
	function closeMatRayer(){
		$('#searchMatValue').val('')
		$('#matLayerBody').empty();
		$('#matLayerBody').append('<tr><td colspan="9">원료코드 혹은 원료코드명을 검색해주세요</td></tr>');
		$('#matCount').text(0);
		closeDialog('dialog_material')
	}
	
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
			return alert('원료정보 최신화 오류[1]');
	}
	
	function calcPackagePrice(e){
		clearNoNum(e.target)
		
		var tr = $(e.target).parent().parent();
		var itemSapPrice = Number(tr.children('td').children('input[name=itemSapPrice]').val());
		var itemVolume = Number(tr.children('td').children('input[name=itemVolume]').val());
		var itemUnitPrice = Number(tr.children('td').children('input[name=itemUnitPrice]').val());
		
		tr.children('td').children('input[name=itemUnitPrice]').val( round((itemSapPrice*itemVolume), 3) )
		calcPkgTable()
	}
	
	function bindDialogEnter(e){
		if(e.keyCode == 13)
			$(e.target).next().click();
	}
	
	function openImportDialog(){
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
		
		$('#select_designDocDetail').removeOption(/./);
		$('#select_designDocDetail').addOption('', '설계서  선택', true);
		$('#label_select_designDocDetail').text('설계서 선택');
		
		openDialog('dialog_import');
	}
	
	function goDocDetail(){
		var pNo = '${designDocInfo.pNo}';
		
		var form = document.createElement('form');
		$('body').append(form);
		form.action = '/design/productDesignDocDetail';
		form.method = 'post';
		
		appendInput(form, 'pNo', pNo)
		
		$(form).submit();
		
		/* 
		appendInput(form, 'searchField', searchField)
		appendInput(form, 'searchValue', searchValue)
		
		if(page.length > 0) appendInput(form, 'showPage', showPage)
		if(ownerType.length > 0) appendInput(form, 'ownerType', ownerType)
		 */
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
			<span class="title_s">Product Design Doc</span><span class="title">설계서 생성</span>
			<div class="top_btn_box">
				<ul>
					<li>
						<button class="btn_circle_save" onclick="saveDocDetail()">&nbsp;</button>
					</li>
				</ul>
			</div>
		</h2>
		<div class="group01 mt20">
			<div class="title5"  style="width: 80%;"><span class="txt">01. 제품명: '${designDocInfo.productName}'</span></div>
			<div class="title5" style="width: 20%; display: inline-block;">
				<button style="float: right;" class="btn_con_search" onclick="openImportDialog()"><img src="/resources/images/btn_icon_convert.png"> 불러오기</button>
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
							<th style="border-left: none;">소매가격</th>
							<td><input type="text" name="productPrice" style="width: 30%;" class="req" onkeyup="clearNoNum(this)"/> ￦</td>
							<th>들이수</th>
							<td><input type="text" name="volume" style="width: 30%;" class="req" onkeyup="clearNoNum(this)"/> ea</td>
							<th style="border-left: none;">원가비율</th>
							<td><input type="text" name="rawPriceRate" style="width: 30%;" class="req" onkeyup="clearNoNum(this)"/> %</td>
						</tr>
						<tr>
							<th style="border-left: none;">수율</th>
							<td><input type="text" name="yieldRate" style="width: 30%;" class="read_only" onkeyup="clearNoNum(this)" value="100" readonly="readonly"/> %</td>
							<th>설명</th>
							<td colspan="3"><input type="text" name="memo" style="width: 100%;" class="req"/></td>
						</tr>
						<tr>
						</tr>
						<tr>
							<th style="border-left: none;" rowspan="3">이미지 파일</th>
							<td rowspan="3">
								
								<!-- <input id="fileImageInput" type="file" onchange="changeImageFile(this, event)" style="width: 100%;"> -->
								
								<p><img id="preview" src="/resources/images/img_noimg3.png" style="border:1px solid #e1e1e1; border-radius:5px; width:258px; height:193px;"></p>
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
							<th>제조공정</th>
							<td colspan="3" rowspan="3"><textarea name="makeProcess" class="req" style="width: 100%; height: 225px"></textarea></td>
						</tr>
						<!-- 
						<tr>
							<td rowspan="2"><img id="fileImage" width="100%" height="auto"></td>
						</tr>
						 -->
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
					<ul id="subScroll" class="ul">
						<!-- 선택됬을경우는 탭 클래스에 select를 넣어주세요 -->
						<!-- 케이스는 적으나 탭이 길어져서 넘어갈 경우가 있습니다. 예외처리는 11월이후 해봅시다. -->
						<%-- <a href="#none" id="subProdAddBtn_1"><li class="select" onclick="changeTab(this)">
							<input type="text" name="subProdName" style="width: 200px;" placeholder="부속제품명 입력" class="req" value="${productName}"/>
							<button name="subProdDelBtn" class="tab_btn_del" onclick="removeSubProduct('1')"><img src="/resources/images/btn_table_header01_del02.png"></button>
						</li></a>
						<a href="#none"><li class="" onclick="addSubProduct(this)">
							<button class="tab_btn_add"><img src="/resources/images/btn_pop_add.png"> 부속제품추가</button>
						</li></a> --%>
						<!-- 부속제품 추가시 -->
						
						<li id="subProdAddBtn_1" class="select" onclick="changeTab(this)">
							<span class="unselectable" ondblclick="changeSubProdName(event)">${productName}</span>
							<input type="text" name="subProdName" onkeyup="subProdNameKeyup(event)" style="width: 180px;" placeholder="부속제품명 입력" class="" value="${productName}" />
							<button name="subProdDelBtn" class="tab_btn_del" onclick="removeSubProduct('1')"><img src="/resources/images/btn_table_header01_del02.png"></button>
						</li><li class="none" onclick="addSubProduct(this)">
							<span class="unselectable">&nbsp;</span>
							<button class="tab_btn_add"><img src="/resources/images/btn_pop_add.png"></button>
							<span class="unselectable">&nbsp;</span>
						</li>
					</ul>
				</div>
				<div class="toRight unselectable" onclick="moveRight()"><span class="span_left">&gt;</span></div>
			</div>
			<div id="subProdDiv_1" name="subProdDiv">
				<div class="main_tbl">
					<table class="insert_proc01" style="border-top: none; border-right: 1px solid #d1d1d1">
						<colgroup>
							<col width="13%" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th>부속제품 설명</th>
								<td><input type="text" name="subProdDesc" style="width: 100%;" class="req"/></td>
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
								<span class="table_order_btn"><button class="btn_up" onclick="moveUp(this)"></button><button class="btn_down" onclick="moveDown(this)"></button></span>
								<span class="title" style="width:50%">
									<img src="/resources/images/img_table_header.png">
									&nbsp;&nbsp;배합비명 : <input type="text" name="baseName" style="width: 200px" />
									&nbsp;분할중량 : <input type="text" name="divWeight" style="width: 50px" onkeyup="clearNoNum(this)"/> g
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
										<th><input type="checkbox" id="mixTable_1" onclick="checkAll(event)"><label for="mixTable_1"><span></span></label></th>
										<th>원료코드</th>
										<th>원료명</th>
										<th>배합율</th>
										<th>단가</th>
										<th>단위</th>
										<th>가격</th>
										<th>비급수 비율(%)</th>
									</tr>
								</thead>
								<tbody id="mixTbody_1">
									<Tr id="mixRow_1" class="temp_color">
										<Td>
											<input type="checkbox" id="mix_1"><label for="mix_1"><span></span></label>
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
						<div class="nomal_mix">
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
										<th><input type="checkbox" id="contentTable_1" onclick="checkAll(event)"><label for="contentTable_1"><span></span></label></th>
										<th>원료코드</th>
										<th>원료명</th>
										<th>배합율</th>
										<th>단가</th>
										<th>단위</th>
										<th>가격</th>
										<th>비급수 비율(%)</th>
									</tr>
								</thead>
								<tbody id="contentTbody_1">
									<Tr id="contentRow_1" class="temp_color">
										<Td>
											<input type="checkbox" id="content_1"><label for="content_1"><span></span></label>
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
			<div class="title5" style="float: left; margin-top: 30px;">
				<span class="txt">03. 재료</span>
			</div>
			<div id="packageHeaderDiv" class="table_header07">
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
				<tbody id="packageTbody" name="packageTbody">
					<Tr id="packageRow_1" class="temp_color">
						<Td>
							<input type="checkbox" id="package_1"><label for="package_1"><span></span></label>
							<input type="hidden" name="itemType"/>
							<input type="hidden" name="itemTypeName"/>
						</Td>
						<Td>
							<input type="hidden" name="itemImNo" style="width: 100px" class="req code_tbl" />
							<input type="text" name="itemSapCode" style="width: 100px" class="req code_tbl" onkeyup="checkMaterail(event, 'R', '')"/>
							<button class="btn_code_search2" onclick="openMaterialPopup(this, 'R')"></button>
						</Td>
						<Td>
							<input type="text" name="itemName" style="width: 85%" readonly="readonly" class="read_only" />
							<button class="btn_code_info2"></button>
						</Td>
						<Td><input type="text" name="itemSapPrice" style="width: 100%" class="req" onkeyup="calcPackagePrice(event)"/></Td>
						<Td><input type="text" name="itemVolume" style="width: 100%" class="req" onkeyup="calcPackagePrice(event)"/></Td>
						<Td><input type="text" name="itemUnitPrice" style="width: 100%"  readonly="readonly" class="read_only"/></Td>
					</Tr>
				</tbody>
				<tfoot>
					<tr>
						<td colspan="4">합계</td>
						<td>-</td>
						<td>0</td>
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
					<button class="btn_admin_gray" onClick="goDocDetail();" style="width: 120px;">목록</button>
				</div>
				<div class="btn_box_con4">
					<!-- 
					<button class="btn_admin_red">임시/템플릿저장</button>
					<button class="btn_admin_navi">임시저장</button>
					 -->
					<button class="btn_admin_sky" onclick="saveDocDetail()">저장</button>
					<button class="btn_admin_gray" onclick="goDocDetail()">취소</button>
				</div>
				<hr class="con_mode" />
			</div>
		</div>
	</section>
</div>


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
					<dt style="width:20%">생성타입</dt>
					<dd style="width:80%">
						<input type="radio" name="docImportType" id="docImportTypeDesign" value="design" onchange="changeImportType(event)" checked>
						<label for="docImportTypeDesign" style="width: 400px"><span></span>제품설계서 가져오기</label>
						<input type="radio" name="docImportType" id="docImportTypeDev" value="dev" onchange="changeImportType(event)">
						<label for="docImportTypeDev" style="width: 400px"><span></span>제조공정서 가져오기</label>
					</dd>
				</li>
				<li id="dialog_create_li_design" class="mb5" style="display: block">
					<dt style="width:20%">제품설계서 검색</dt>
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
						<input id="dialog_design_productName" type="text" style="width:25%; margin-left:5px; padding-bottom:3px" placeholder="제품명으로 검색"
						/><button class="btn_small_search ml5" onclick="searchDesignDoc()">검색</button>
						
						<div id="designDocSelectDiv" style="display: none">
							<br>
	                        <div class="selectbox req" style="width:207px;">
	                            <label id="label_select_designDoc" for="select_designDoc">제품개발문서 선택</label>
	                            <select id="select_designDoc" onchange="searchDesignDocDetailList(event)">
	                            	<option selected>제품개발문서 선택</option>
	                            </select>
	                        </div>
	                        <div class="selectbox req ml5" style="width:350px;">
	                            <label id="label_select_designDocDetail" for="select_designDocDetail">설계서 선택</label>
	                            <select id="select_designDocDetail">
	                            	<option selected>설계서 선택</option>
	                            </select>
	                        </div>
                        </div>
					</dd>
				</li>
                <li id="dialog_create_li_mfg" class="mb5" style="display: none">
					<dt style="width:20%">제조공정서 검색</dt>
					<dd style="width:80%">
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