<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script type="text/javascript">
	var tBodyNumber = 1;
	var rowNumber = 1;
	
	var subProdDiv;
	
	var mixTable;
	var mixRow;
	
	var contentTable;
	var contentRow;
	
	var packageTable;
	var packageRow;
	
	var costRow;
	
	$(document).ready(function(){
		mixTable = $('#mixDiv').html();
		mixRow = $('#mixTbody').html();
		
		contentTable = $('#contentDiv').html();
		contentRow = $('#contentTbody').html();
		
		packageTable = $('#packageDiv').html();
		packageRow = $('#packageTbody').html();
		/* 
		console.log('${designDocInfo}')
		console.log('${designDocDetail}')
		 */
		subProdDiv = $('#subProdDiv').html();
		
		costRow = '<ul>'+$('#costBody_mix').parent().children().first().html()+'</ul>'
		
		$('#productDesignCreateForm').on('submit', function(event){
			event.preventDefault();
		});
		
		//addSubProduct()
		$('input[name=mixNumber]').toArray().forEach(function(v){$(v).keyup()})
	});
	
	function openMaterailPopup(element){
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
	}
	
	function setMaterialPopupData(parentRowId, itemSAPCode, itemName, itemUnitPrice){
		$('#'+parentRowId + ' input[name*=itemSapCode]').val(itemSAPCode);
		$('#'+parentRowId + ' input[name*=itemName]').val(itemName);
		$('#'+parentRowId + ' input[name*=itemUnitPrice]').val(itemUnitPrice);
		$('#'+parentRowId + ' input[name*=itemCustomPrice]').val(itemUnitPrice);
		$('#'+parentRowId + ' input[name*=itemCalculatedPrice]').val(itemUnitPrice);
		
		calTableItemCost($('#'+parentRowId + ' input[name*=itemUnitPrice]')[0]);
	}
	
	function addSubProduct(){
		var randomId;
		$('#productDesignItemForm').children('div.insert_obj:last').before(subProdDiv)
		
		var mixTable = $('div[name=subProduct]:last').children('div:first').children('div:last').children('div').children('table')
		var contentTable = $('div[name=subProduct]:last').children('div:last').children('div:last').children('div').children('table')
		
		randomId = Math.random().toString(36).substr(2, 9);
		var mixTbody = mixTable.children('tbody');
		mixTbody.children('tr').children('td:first').children('input[type=checkbox]').attr('id', 'cbox_' + randomId);
		mixTbody.children('tr').children('td:first').children('label').attr('for', 'cbox_' + randomId);
		
		randomId = Math.random().toString(36).substr(2, 9);
		var contentTbody = contentTable.children('tbody');
		contentTbody.children('tr').children('td:first').children('input[type=checkbox]').attr('id', 'cbox_' + randomId);
		contentTbody.children('tr').children('td:first').children('label').attr('for', 'cbox_' + randomId);
	}
	
	function addTable(element, type){
		rowNumber++;
		tBodyNumber++;
		
		var bodyId;
		var tableBody;
		
		if(type == 'mix') {
			bodyId = 'mixTbody_';
			tableBody = mixTable;
		}
		if(type == 'content') {
			bodyId = 'contentTbody_';
			tableBody = contentTable;
		}
		if(type == 'package') {
			bodyId = 'packageTbody_';
			tableBody = packageTable;
		}
		
		var randomId = randomId = Math.random().toString(36).substr(2, 9);
		
		$(element).parent().parent().children('div:last').children('div').append(tableBody);
		var insertedTbody = $(element).parent().parent().children('div:last').children('div').children('table:last').children('tbody');
		insertedTbody.children('tr').children('td:first').children('input[type=checkbox]').attr('id', bodyId+randomId)
		insertedTbody.children('tr').children('td:first').children('label').attr('for', bodyId+randomId)
		
		$('#costDiv').append(costRow);
		$('#costDiv').children().last('ul')[0].id = 'costBody_' + type + '_' + rowNumber;
	}
	
	function removeTable(element, type){
		var elementType = $(element).parent().parent().children('span.title').text().trim().split(' ')[0];
		var elementName = $(element).parent().parent().children('span.title').children('input[name=detailTableName]').val();
		var message = (type == 'package' ? elementType + ' 테이블을 지우시겠습니까?' : elementType + ' [' + elementName + '] 테이블을 지우시겠습니까?'); 
				
		if(confirm(message)){
			$(element).parent().parent().next().remove();
			$(element).parent().parent().remove();
		}
	}
	
	var test;
	function addRow(element){
		test = element
		var randomId = randomId = Math.random().toString(36).substr(2, 9);
		
		//var tboydId = $(element).parent().parent().next('table').children('tbody')[0].id;
		var type = $(element).parent().parent().next('table').children('tbody:first').attr('name').split('Tbody')[0];
		
		var row;
		if(type == 'mix') row = mixRow;
		if(type == 'content') row = contentRow;
		if(type == 'package') row = packageRow;
		
		$(element).parent().parent().next().children('tbody').append(row);
		$(element).parent().parent().next().children('tbody').children('tr:last').attr('id', type + 'Row_' + tBodyNumber + '_' + randomId);
		$(element).parent().parent().next().children('tbody').children('tr:last').children('td').children('input[type=checkbox]').attr('id', type+'_'+randomId);
		$(element).parent().parent().next().children('tbody').children('tr:last').children('td').children('label').attr('for', type+'_'+randomId);
	}
	
	function removeRow(element){
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
				checkedId = v.id
			}
		});
		
		if(checkedCnt > 1) return alert('열을 이동하는 하는 경우에는 1개의 열만 선택해주세요');
		if(checkedCnt == 0) return alert('이동시키려는 열을 선택해주세요');
		
		var $element = $('#'+checkedId).parent().parent();
		$element.prev().before($element);
	}
	
	function moveDown(element){
		var tbody = $(element).parent().parent().next().children('tbody');
		var checkboxArr = tbody.children('tr').children('td').children('input[type=checkbox]').toArray();
		
		var checkedCnt = 0;
		var checkedId;
		checkboxArr.forEach(function(v, i){
			if($(v).is(':checked')){
				checkedCnt++;
				checkedId = v.id
			}
		});
		
		if(checkedCnt > 1) return alert('열을 이동하는 하는 경우에는 1개의 열만 선택해주세요');
		if(checkedCnt == 0) return alert('이동시키려는 열을 선택해주세요');
		
		var $element = $('#'+checkedId).parent().parent();
		$element.next().after($element);
	}
	
	function productDesignItemSubmit(){
		$.ajax({
			url: '/design/testCall',
			type: 'post',
			data: $('#productDesignItemForm').serialize(),
			success: function(data){
				console.log(data);
			},
			error: function(a,b,c){
				console.log(a,b,c)
			}
			
		})
	}
	
	function tSubmit(){
		
	}
	
	function editDocDetail(){
		var formRootArr = $('#productDesignItemForm').children('div').toArray();
		var makeProcess = $('#productDesignItemForm').children('textarea').val()
		
		var postData = {};
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
		        postData['sub['+detail_ndx+'].pdsNo'] = $(sub).children('input[name=pdsNo]').val();
		        postData['sub['+detail_ndx+'].subProdName'] = $(sub).children('input[name=subProdName]').val();
		        postData['sub['+detail_ndx+'].subProdDesc'] = $(sub).children('textarea[name=subProdDesc]').val();
		        
		        $(sub).children('div').toArray().forEach(function(subElement, ndx_subProd){
		        	if(ndx_subProd == 0){
		        		// subMix
		        		var subMixElement = subElement;
		        		
		        		$(subMixElement).children('div:last').children().children('table').toArray().forEach(function(subMix, subMixIndex){
		        			postData['sub['+detail_ndx+'].subMix['+subMixIndex+'].pdsmNo'] = $(subMix).prev().children('span.title').children('input[name$=pdsmNo]').val();
		        			postData['sub['+detail_ndx+'].subMix['+subMixIndex+'].name'] = $(subMix).prev().children('span.title').children('input[name$=Name]').val();
		        			postData['sub['+detail_ndx+'].subMix['+subMixIndex+'].weight'] = $(subMix).prev().children('span.title').children('input[name$=Weight]').val();
		        			
		        			
		        			$(subMix).children('tbody').children('tr').toArray().forEach(function(mixItem, itemIndex){
		        				
		        				var pdsmiNo = $(mixItem).children('td').children('input[name$=pdsmiNo]').val();
		        				var itemSapCode = $(mixItem).children('td').children('input[name$=itemSapCode]').val();
		        				var itemName = $(mixItem).children('td').children('input[name$=itemName]').val();
		        				var itemUnitPrice = $(mixItem).children('td').children('input[name$=itemUnitPrice]').val();
		        				var mixingRatio = $(mixItem).children('td').children('input[name$=mixNumber]').val();
		        				
		        				postData['sub['+detail_ndx+'].subMix['+subMixIndex+'].subMixItem['+itemIndex+'].pdsmiNo'] = pdsmiNo
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
		        			postData['sub['+detail_ndx+'].subContent['+subContentIndex+'].pdscNo'] = $(subContent).prev().children('span.title').children('input[name$=pdscNo]').val();
		        			postData['sub['+detail_ndx+'].subContent['+subContentIndex+'].name'] = $(subContent).prev().children('span.title').children('input[name$=Name]').val();
		        			postData['sub['+detail_ndx+'].subContent['+subContentIndex+'].weight'] = $(subContent).prev().children('span.title').children('input[name$=Weight]').val();
		        			
		        			$(subContent).children('tbody').children('tr').toArray().forEach(function(contentItem, contentIndex){
		        				var pdsciNo = $(contentItem).children('td').children('input[name$=pdsciNo]').val();
		        				var itemSapCode = $(contentItem).children('td').children('input[name$=itemSapCode]').val();
		        				var itemName = $(contentItem).children('td').children('input[name$=itemName]').val();
		        				var itemUnitPrice = $(contentItem).children('td').children('input[name$=itemUnitPrice]').val();
		        				var mixingRatio = $(contentItem).children('td').children('input[name$=mixNumber]').val();
		        				
		        				postData['sub['+detail_ndx+'].subContent['+subContentIndex+'].subContentItem['+contentIndex+'].pdsciNo'] = pdsciNo;
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
		    		var pdpNo = $(pkgItem).children('td').children('input[name$=pdpNo]').val();
		    		var itemSapCode = $(pkgItem).children('td').children('input[name$=itemSapCode]').val();
		    		var itemName = $(pkgItem).children('td').children('input[name$=itemName]').val();
		    		var itemUnitPrice = $(pkgItem).children('td').children('input[name$=itemUnitPrice]').val();
		    		
		    		postData['pkg['+pkgItemIndex+'].pdpNo'] = pdpNo;
		    		postData['pkg['+pkgItemIndex+'].itemSapCode'] = itemSapCode;
		    		postData['pkg['+pkgItemIndex+'].itemName'] = itemName;
		    		postData['pkg['+pkgItemIndex+'].itemUnitPrice'] = itemUnitPrice;
		    	});
		    	
		    	pkgIndex++;
		    }
		})
		console.log(postData);
		
		$.ajax({
			url: '/design/editProductDesignDocDetail',
			type: 'post',
			data: postData, 
			dataType: 'json',
			success: function(data){
				console.log(data)
			},
			error: function(a,b,c){
				console.log(a,b,c)
			}
		});
	}
	
	function setFormInputName(){
		var detailTalbeListIndex = 0;
		$('tbody[id*=Tbody_]').toArray().forEach(function(tbody, tbodyIndex){
			var itemType = tbody.id.split('Tbody')[0];
			var itemTypeName = $('#'+tbody.id).parent().prev().children('span').children('input[name=detailTableName]').val();
		    $('#'+tbody.id).children().toArray().forEach(function(tr, trIndex){
		        $('#'+tr.id).children().toArray().forEach(function(td, i){
		        	$(td).children('input[name$=itemType]').attr('name', 'detailTableList['+detailTalbeListIndex+'].itemType');
		        	$(td).children('input[name$=itemType]').val(itemType);
		        	$(td).children('input[name$=itemTypeName]').attr('name', 'detailTableList['+detailTalbeListIndex+'].itemTypeName');
		        	$(td).children('input[name$=itemTypeName]').val(itemTypeName);
		        	
					$(td).children('input[name$=itemSapCode]').attr('name', 'detailTableList['+detailTalbeListIndex+'].itemSapCode');
					$(td).children('input[name$=itemName]').attr('name', 'detailTableList['+detailTalbeListIndex+'].itemName');
					$(td).children('input[name$=itemUnitPrice]').attr('name', 'detailTableList['+detailTalbeListIndex+'].itemUnitPrice');
					$(td).children('input[name$=mixNumber]').attr('name', 'aaa[].adfa[].adetailTableList['+detailTalbeListIndex+'].mixNumber');
		        });
		        detailTalbeListIndex++;
		    });
		})
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
		
		var tableUnitTotal = (tableTotal/tableMixRateTotal).toFixed(2);
		
		if(tbodyId.startsWith('package')){
			tFoot.children('tr[name$=Unit]').children('td[name=tdTableUnitPrice]').children('div').text(tableTotal);
			tFoot.children('tr[name$=Unit]').children('td[name=tdTableUnitPrice]').children('input').val(tableTotal);
			tFoot.children('tr[name$=Total]').children('td[name=tdTableTotalPrice]').children('div').text(tableTotal);
			tFoot.children('tr[name$=Total]').children('td[name=tdTableTotalPrice]').children('input').val(tableTotal);
		} else {
			if(mixRate > 0) {
				var mixPrice = (tableTotal/tableMixRateTotal).toFixed(2);
				tFoot.children('tr[name$=Unit]').children('td[name=tdTableUnitPrice]').children('div').text(tableTotal);
				tFoot.children('tr[name$=Unit]').children('td[name=tdTableUnitPrice]').children('input').val(tableTotal);
				tFoot.children('tr[name$=Total]').children('td[name=tdTableTotalPrice]').children('div').text(mixPrice);
				tFoot.children('tr[name$=Total]').children('td[name=tdTableTotalPrice]').children('input').val(mixPrice);
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
</script>
<span class="path">제품설계서&nbsp;&nbsp;<img src="../resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;<a href="#">파리크라상 식품기술 연구개발시스템</a></span>
<section class="type01">
	<h2 style="position:relative">
		<span class="title_s">Product Design Document</span>
		<span class="title">설계서생성</span>
	</h2>
	<div class="group01">
	<div class="title"></div>
	<div class="predoc_title">
		<span class="font17">제품명 : ${designDocInfo.productName}</span>
		<br/>
		<span class="font18">
			제품유형 : ${designDocInfo.categoryName}<strong>&nbsp;|&nbsp;</strong>
			<%-- 브랜드 : ${designDocInfo.brandName} <strong>&nbsp;|&nbsp;</strong> --%>
			공장 : ${designDocInfo.plantName}
		</span>
		<br/>
		<span class="p10"><input type="text" name="memo" placeholder="제품설명을 입력해주세요(* 필수)" style="width:100%; margin-top:15px;" class="req" value="${designDocDetail.memo}"/></span>
	</div>
	<div class="insert_input_box">
		<ul>
			<li>
				<dt>배합중량</dt>
				<dd>
					<input type="text" style="width:200px;" name="productWeight" value="${designDocDetail.sumMixWeight}" onkeyup="clearNoNum(this)"/> KG
				</dd>
			</li>
			<li>
				<dt></dt>
				<dd>
					<!-- <input type="text" style="width:200px;" name="" id="" onkeyup="clearNoNum(this)"/> 포 -->
				</dd>
			</li>
			<li>
				<dt>가격</dt>
				<dd>
					<input type="text" style="width:200px;" name="productPrice" value="${designDocDetail.productPrice}" onkeyup="clearNoNum(this)"/> 원
				</dd>
			</li>
			<li>
				<dt>공장도가</dt>
				<dd>
					<input type="text" style="width:200px;" name="plantPrice" value="${designDocDetail.plantPrice}" onkeyup="clearNoNum(this)"/> %
				</dd>
			</li>
			<li style="width:100%;border-bottom:1px dotted #ddd; margin-bottom:10px">
				<dt style="width:15%">사진 첨부</dt>
				<dd style="width:75%">
					<div class="form-group form_file" style="text-align:left;" id="preFileDiv">
						<input class="form-control form_point_color01" type="text" title="첨부된 파일명" readonly="readonly" style="width:600px;">
						<span class="file_load">
							<input type="file" name="file" id="pre_file" onChange="">
							<label class="btn-default" for="pre_file">파일첨부</label>
						</span>
					</div>
					<ul class="view_list_file" id="preFileList">
					</ul>
				</dd>
			</li>
		</ul>
		<ul>
			<li>
				<dt>제조공정</dt>
				<dd>
					<textarea style="width:220%; height:250px;border-radius:5px; background-color:#ffffff;  border: 1px solid transparent; padding:3px 5px 5px 5px;box-shadow: 0 0 0 1px #c5c5c5; box-sizing:border-box;font-family:'맑은고딕',Malgun Gothic; line-height:20px;" class="req" name=""  placeholder="제조공정을 입력해주세요.">${designDocDetail.makeProcess}</textarea>
				</dd>
			</li>
		</ul>
	</div>
	<div class="main_tbl">
		<form id="productDesignItemForm" action="/design/testCall">
			<input type="hidden" name="makeProcess" value="" />
			<input type="button" onclick="addSubProduct()" value="부속제품 추가">
			
			<!-- 부속제품 BLOCK START -->
			<c:forEach items="${designDocDetail.sub}" var="sub" varStatus="subStatus">
				<div class="insert_obj" name="subProduct" style="border: 1px dotted black;">
					<input type="hidden" name="pdsNo" value="${sub.pdsNo}">
					부속제품명: <input name="subProdName" value="${sub.subProdName}"><Br>
					설명: <textarea name="subProdDesc" value="${sub.subProdDesc}"></textarea>
					
					<!-- 배합 START -->
					<div class="insert_obj">
						<div class="title">
							<span class="txt">배합</span>
						</div>
						<div class="btn_box_con2">
							<button type="button" class="btn_con_search" onclick="addTable(this, 'mix')"><img src="../resources/images/icon_s_write.png"/> 배합 추가</button>
							<!-- <button type="button" class="btn_con_search" onclick="manageIncludeMix();"><img src="../resources/images/icon_s_write.png"/> 포함배합 관리</button> -->
						</div>
						<div class="nomal_mix">
							<c:forEach items="${sub.subMix}" var="subMix" varStatus="subMixStatus">
								<div name="mixDiv">
									<div class="table_header01">
										<span class="table_order_btn">
											<button type="button" class="btn_up" onclick="moveUp(this)"></button>
											<button type="button" class="btn_down" onclick="moveDown(this)"></button>
										</span>
										<span class="title">
											<input type="hidden" name="pdsmNo" value="${subMix.pdsmNo}">
											<img src="../resources/images/img_table_header.png">&nbsp;&nbsp;
											배합명 : <input type="text" style="width:200px" name="mixName" value="${subMix.name}"/>
											 
											&nbsp;|&nbsp; 중량 : <input type="text" style="width:50px" name="mixWeight" value="${subMix.weight}"/> g
											<!--
											&nbsp;|&nbsp; 수율 : <input type="text" style="width:50px" name="yield" id="yield" value="1" onchange="calSum('mix', '');" onkeyup="clearNoNum(this)"/>
											 -->
										</span>
										<span class="table_header_btn_box">
											<button type="button" class="btn_del_table_header" onclick="removeTable(this)"> 배합 삭제</button>
											<button type="button" class="btn_add_tr" onClick="addRow(this)"></button>
											<button type="button" class="btn_del_tr" onClick="removeRow(this)"></button>
										</span>
									</div>
									<table class="tbl05">
										<colgroup>
											<col width="20">
											<col width="140">
											<col width="auto"/>
											<col width="100">
											<col width="50">
											<col width="100">
											<col width="100">
											<col width="100">
											<col width="80">
										</colgroup>
										<thead>
											<tr>
												<th></th>
												<th>원료코드</th>
												<th>원료명</th>
												<th>배합비</th>
												<th>단위</th>
												<th>단가</th>
												<th>입력단가</th>
												<th>금액</th>
												<th>원료입고업체</th>
											</tr>
										</thead>
										<tbody name="mixTbody">
											<c:forEach items="${subMix.subMixItem}" var="subMixItem" varStatus="subMixItemStatus">
												<tr id="mixRow_${subMixStatus.index}_${subMixItemStatus.index}">
													<td>
														<input type="hidden" name="pdsmiNo" value="${subMixItem.pdsmiNo}"/>
														<input type="hidden" name="itemType"/>
														<input type="hidden" name="itemTypeName"/>
														<input type="checkbox" id="mixRowCheck_${subMixStatus.index}_${subMixItemStatus.index}" name=""><label for="mixRowCheck_${subMixStatus.index}_${subMixItemStatus.index}"><span></span></label>
													</td>
													<td>
														<input type="text" name="itemSapCode" style="width:100px" class="req"" value="${subMixItem.itemSapCode}">
														<button type="button" class="btn_code_search" onclick="openMaterailPopup(this);"></button>
													</td>
													<td><input type="text" name="itemName" style="width:100%" value="${subMixItem.itemName}" readonly="readonly" class="read_only"/></td>
													<td name="tdMixRate"><input type="text" name="mixNumber" value="${subMixItem.mixingRatio}" onkeyup="calTableItemCost(this);" style="width:100%" class="req"/></td>
													<td><select name=""><option value="">선택</option></select></td>
													<td name="tdUnitCost"><input type="text" name="itemUnitPrice" value="${subMixItem.itemUnitPrice}" style="width:100%" readonly="readonly" class="read_only"/></td>
													<td name="tdCustomUnitCost"><input type="text" name="itemCustomPrice" value="" onkeyup="calTableItemCost(this);" style="width:100%" class="req"/></td>
													<td name="tdRowCost"><input type="text" name="itemCalculatedPrice" value="${subMixItem.itemUnitPrice * subMixItem.mixingRatio}" style="width:100%" readonly="readonly" class="read_only"/></td>
													<td><input type="text" name="" style="width:120px;"/></td>
												</tr>
											</c:forEach>
										</tbody>
										<tfoot>
											<tr>
												<td colspan="3">총합</td>
												<td>
													<div id="totalMixRateDiv"> - </div>
													<input type="hidden" name="mixTotalMixRate" id="mixTotalMixRate" value="">
												</td>
												<td>&nbsp;</td>						
												<td>
													<div id="totalKgPriceDiv"> - </div>							
													<input type="hidden" name="mixTotalKgPrice" id="mixTotalKgPrice" value="">
												</td>
												<td>
													<div id="totalPriceDiv"> - </div>
													<input type="hidden" name="mixTotalPrice" id="mixTotalPrice" value="">
												</td>
												<td>
													<div id="totalMixPriceDiv"> - </div>
													<input type="hidden" name="mixTotalMixPrice" id="mixTotalMixPrice" value="">
												</td>
												<td>&nbsp;</td>
											</tr>
											<tr name="trUnit">
												<td colspan="3">kg/단가</td>
												<td>&nbsp;</td>
												<td>&nbsp;</td>
												<td>&nbsp;</td>
												<td name="tdTableUnitPrice">
													<div id="">0</div>
													<input type="hidden" name="" id="" value="">
												</td>
												<td>원</td>
												<td>&nbsp;</td>
											</tr>
											<tr name="trTotal">
												<td colspan="3">배합금액</td>
												<td>&nbsp;</td>
												<td>&nbsp;</td>
												<td>&nbsp;</td>
												<td name="tdTableTotalPrice">
													<div id="">0</div>
													<input type="hidden" name="" id="" value="">
												</td>
												<td>원</td>
												<td>&nbsp;</td>
											</tr>
										</tfoot>
									</table>
								</div>
							</c:forEach>
						</div>
					</div>
					<!-- 배합 END -->
					
					<!-- 내용물 START -->
					<div class="insert_obj">
						<div class="title">
							<span class="txt">내용물</span>
						</div>
						<div class="btn_box_con2">
							<button type="button" class="btn_con_search" onclick="addTable(this, 'content')"><img src="../resources/images/icon_s_write.png"/> 내용물 추가</button>
							<!-- <button type="button" class="btn_con_search" onclick="manageIncludeMix();"><img src="../resources/images/icon_s_write.png"/> 포함배합 관리</button> -->
						</div>
						<div class="nomal_mix" id="mixArea">
							<c:forEach items="${sub.subContent}" var="subContent" varStatus="subContentStatus">
								<div id="contentDiv" name="contentDiv">
									<div class="table_header02">
										<span class="table_order_btn">
											<button type="button" class="btn_up" onclick="moveUp(this)"></button>
											<button type="button" class="btn_down" onclick="moveDown(this)"></button>
										</span>
										<span class="title">
											<input type="hidden" name="pdscNo" value="${subContent.pdscNo}"/>
											<img src="../resources/images/img_table_header.png">&nbsp;&nbsp;
											내용물명 : <input type="text" style="width:200px" name="contentName" value="${subContent.name}"/>
											
											&nbsp;|&nbsp; 중량 : <input type="text" style="width:50px" name="contentWeight" value="${subContent.weight}"/> g
											<!-- 
											&nbsp;|&nbsp; 수율 : <input type="text" style="width:50px" name="yield" id="yield" value="1" onchange="calSum('mix', '');" onkeyup="clearNoNum(this)"/>
											 -->
										</span>
										<span class="table_header_btn_box">
											<button type="button" class="btn_del_table_header" onclick="removeTable(this)"> 내용물 삭제</button>
											<button type="button" class="btn_add_tr" onClick="addRow(this)"></button>
											<button type="button" class="btn_del_tr" onClick="removeRow(this)"></button>
										</span>
									</div>
									<table class="tbl05">
										<colgroup>
											<col width="20">
											<col width="140">
											<col width="auto"/>
											<col width="100">
											<col width="50">
											<col width="100">
											<col width="100">
											<col width="100">
											<col width="80">
										</colgroup>
										<thead>
											<tr>
												<th></th>
												<th>원료코드</th>
												<th>원료명</th>
												<th>배합비</th>
												<th>단위</th>
												<th>단가</th>
												<th>입력단가</th>
												<th>금액</th>
												<th>원료입고업체</th>
											</tr>
										</thead>
										<tbody name="contentTbody">
											<c:forEach items="${subContent.subContentItem}" var="subContentItem" varStatus="subContentItemStatus">
												<tr id="contentRow_${subContentStatus.index}_${subContentItemStatus.index}">
													<td>
														<input type="hidden" name="pdsciNo" value="${subContentItem.pdsciNo}"/>
														<input type="hidden" name="itemType"/>
														<input type="hidden" name="itemTypeName"/>
														<input type="checkbox" id="contentRowCheck_${subContentStatus.index}_${subContentItemStatus.index}" name=""><label for="contentRowCheck_${subContentStatus.index}_${subContentItemStatus.index}"><span></span></label>
													</td>
													<td>
														<input type="text" name="itemSapCode" value="${subContentItem.itemSapCode}" style="width:100px" class="req"">
														<button type="button" class="btn_code_search" onclick="openMaterailPopup(this);"></button>
													</td>
													<td><input type="text" name="itemName" value="${subContentItem.itemName}" style="width:100%" readonly="readonly" class="read_only"/></td>
													<td name="tdMixRate"><input type="text" name="mixNumber" value="${subContentItem.mixingRatio}" onkeyup="calTableItemCost(this);" style="width:100%" class="req"/></td>
													<td><select name=""><option value="">선택</option></select></td>
													<td name="tdUnitCost"><input type="text" name="itemUnitPrice" value="${subContentItem.itemUnitPrice}" style="width:100%" readonly="readonly" class="read_only"/></td>
													<td name="tdCustomUnitCost"><input type="text" name="itemCustomPrice" onkeyup="calTableItemCost(this);" style="width:100%" class="req"/></td>
													<td name="tdRowCost"><input type="text" name="itemCalculatedPrice" value="${subContentItem.itemUnitPrice * subContentItem.mixingRatio}" style="width:100%" readonly="readonly" class="read_only"/></td>
													<td><input type="text" name="" style="width:120px;"/></td>
												</tr>
											</c:forEach>
										</tbody>
										<tfoot>
											<tr>
												<td colspan="3">총합</td>
												<td>
													<div id="totalMixRateDiv"> - </div>
													<input type="hidden" name="mixTotalMixRate" id="mixTotalMixRate" value="">
												</td>
												<td>&nbsp;</td>						
												<td>
													<div id="totalKgPriceDiv"> - </div>							
													<input type="hidden" name="mixTotalKgPrice" id="mixTotalKgPrice" value="">
												</td>
												<td>
													<div id="totalPriceDiv"> - </div>
													<input type="hidden" name="mixTotalPrice" id="mixTotalPrice" value="">
												</td>
												<td>
													<div id="totalMixPriceDiv"> - </div>
													<input type="hidden" name="mixTotalMixPrice" id="mixTotalMixPrice" value="">
												</td>
												<td>&nbsp;</td>
											</tr>
											<tr name="trUnit">
												<td colspan="3">kg/단가</td>
												<td>&nbsp;</td>
												<td>&nbsp;</td>
												<td>&nbsp;</td>
												<td name="tdTableUnitPrice">
													<div id=""> 0 </div>
													<input type="hidden" name="" id="" value="">
												</td>
												<td>원</td>
												<td>&nbsp;</td>
											</tr>
											<tr name="trTotal">
												<td colspan="3">배합금액</td>
												<td>&nbsp;</td>
												<td>&nbsp;</td>
												<td>&nbsp;</td>
												<td name="tdTableTotalPrice">
													<div id=""> 0 </div>
													<input type="hidden" name="" id="" value="">
												</td>
												<td>원</td>
												<td>&nbsp;</td>
											</tr>
										</tfoot>
									</table>
								</div>
							</c:forEach>
						</div>
					</div>
					<!-- 내용물 END -->
				</div>
			</c:forEach>
			<!-- 부속제품 BLOCK END -->
			
			<!-- 재료 START -->
			<div class="insert_obj">
				<div class="title">
					<span class="txt">재료</span>
				</div>
				<div class="btn_box_con2">
					<button type="button" class="btn_con_search" onclick="addTable(this, 'package')"><img src="../resources/images/icon_s_write.png"/> 재료 추가</button>
				</div>
				<div class="nomal_mix">
					<div name="packageDiv">
						<div class="table_header03">
							<span class="table_order_btn">
								<button type="button" class="btn_up" onclick="moveUp(this)"></button>
								<button type="button" class="btn_down" onclick="moveDown(this)"></button>
							</span>
							<span class="title">
								<img src="../resources/images/img_table_header.png">&nbsp;&nbsp;
								재료 
							</span>
							<span class="table_header_btn_box">
								<button type="button" class="btn_del_table_header" onclick="removeTable(this, 'package')"> 재료 삭제</button>
								<button type="button" class="btn_add_tr" onClick="addRow(this)"></button>
								<button type="button" class="btn_del_tr" onClick="removeRow(this)"></button>
							</span>
						</div>
						<table class="tbl05">
							<colgroup>
								<col width="20">
								<col width="140">
								<col width="auto"/>
								<col width="100">
								<%-- <col width="100"> --%>
								<col width="100">
								<col width="80">
							</colgroup>
							<thead>
								<tr>
									<th></th>
									<th>재료코드</th>
									<th>재료명</th>
									<th>단가</th>
									<!-- <th>입력단가</th> -->
									<th>금액</th>
									<th>원료입고업체</th>
								</tr>
							</thead>
							<tbody name="packageTbody">
								<c:forEach items="${designDocDetail.pkg}" var="pkg" varStatus="packageStatus">
									<tr id="packageRow_${packageStatus.index}">
										<td>
											<input type="hidden" name="pdpNo" value="${pkg.pdpNo}"/>
											<input type="hidden" name="itemType"/>
											<input type="hidden" name="itemTypeName"/>
											<input type="checkbox" id="packageRowCheck_${packageStatus.index}" name=""><label for="packageRowCheck_${packageStatus.index}"><span></span></label>
										</td>
										<td>
											<input type="text" name="itemSapCode" value="${pkg.itemSapCode}" style="width:100px" class="req"">
											<button type="button" class="btn_code_search" onclick="openMaterailPopup(this)"/>
										</td>
										<td><input type="text" name="itemName" value="${pkg.itemName}" style="width:100%" readonly="readonly" class="read_only"/></td>
										<td name="tdUnitCost"><input type="text" value="${pkg.itemUnitPrice}" name="itemUnitPrice" style="width:100%" readonly="readonly" class="read_only"/></td>
										<!-- <td name="tdCustomUnitCost"><input type="text" name="itemCustomPrice" onkeyup="calTableItemCost(this);" style="width:100%" class="req"/></td> -->
										<td name="tdRowCost"><input type="text" name="itemCalculatedPrice" value="${pkg.itemUnitPrice}" style="width:100%" readonly="readonly" class="read_only"/></td>
										<td><input type="text" name="" style="width:120px;"/></td>
									</tr>
								</c:forEach>
							</tbody>
							<tfoot>
								<tr>
									<td colspan="3">총합</td>
									<td>
										<div id="totalMixRateDiv"> - </div>
										<input type="hidden" name="mixTotalMixRate" id="mixTotalMixRate" value="">
									</td>
									<td>
										<div id="totalPriceDiv"> - </div>
										<input type="hidden" name="mixTotalPrice" id="mixTotalPrice" value="">
									</td>
									<td>&nbsp;</td>
								</tr>
								<tr name="trUnit">
									<td colspan="3">kg/단가</td>
									<td name="tdTableUnitPrice">
										<div id=""> 0 </div>
										<input type="hidden" name="" id="" value="">
									</td>
									<td>원</td>
									<td>&nbsp;</td>
								</tr>
								<tr name="trTotal">
									<td colspan="3">배합금액</td>
									<td name="tdTableTotalPrice">
										<div id=""> 0 </div>
										<input type="hidden" name="" id="" value="">
									</td>
									<td>원</td>
									<td>&nbsp;</td>
								</tr>
							</tfoot>
						</table>
					</div>
				</div>
			</div>
			<!-- 재료 END -->
		</form>
		
		<!-- 총 비용 START -->
		<div class="insert_obj">
			<div class="nomal_mix" style="padding-top:0; width:57%">
				<div class="table_header03"><span class="title"><img src="../resources/images/img_table_header2.png">&nbsp;&nbsp;총 비용</span></div>
				<table class="tbl05">
					<colgroup>
						<col />
						<col width="160">
					</colgroup>
					<thead>
						<tr>
							<th>구분</th>
							<th>명칭</th>
							<th>중량(g)</th>
							<th>kg가격</th>
							<th>원가</th>
						</tr>
					</thead>
					<tbody>
						<c:set var="priceTotal"/>
						<c:forEach var="sub" items="${designDocDetail.sub}">
							<c:forEach var="subMix" items="${sub.subMix}">
								<c:set var="mixingRatioTotal" value="0"/>
								<c:set var="mixTotalPrice" value="0"/>
								<c:forEach var="item" items="${subMix.subMixItem}">
									<c:set var="mixingRatioTotal" value="${mixingRatioTotal + item.mixingRatio}"/>
									<c:set var="mixTotalPrice" value="${mixTotalPrice + (item.itemUnitPrice*item.mixingRatio)}"/>
								</c:forEach>
								<c:set var="weightTotal" value="${weightTotal + subMix.weight}"></c:set>
								<c:set var="kgPriceTotal" value="${kgPriceTotal + mixTotalPrice/mixingRatioTotal}"/>
								<c:set var="priceTotal" value="${priceTotal + mixTotalPrice/mixingRatioTotal*(subMix.weight/1000)}"/>
								
								<tr>
									<td>배합</td>
									<td>${subMix.name}</td>
									<td><fmt:formatNumber value="${subMix.weight}" pattern=".000"/></td>
									<td><fmt:formatNumber value="${mixTotalPrice/mixingRatioTotal}" pattern=".000"/></td>
									<td><fmt:formatNumber value="${mixTotalPrice/mixingRatioTotal*(subMix.weight/1000)}" pattern=".000"/></td>
								</tr>
							</c:forEach>
							<c:forEach var="subContent" items="${sub.subContent}">
								<c:set var="mixingRatioTotal" value="0"/>
								<c:set var="mixTotalPrice" value="0"/>
								<c:forEach var="item" items="${subContent.subContentItem}">
									<c:set var="mixingRatioTotal" value="${mixingRatioTotal + item.mixingRatio}"/>
									<c:set var="mixTotalPrice" value="${mixTotalPrice + (item.itemUnitPrice*item.mixingRatio)}"/>
								</c:forEach>
								<c:set var="weightTotal" value="${weightTotal + subContent.weight}"></c:set>
								<c:set var="kgPriceTotal" value="${kgPriceTotal + mixTotalPrice/mixingRatioTotal}"/>
								<c:set var="priceTotal" value="${priceTotal + mixTotalPrice/mixingRatioTotal*(subContent.weight/1000)}"/>
								
								<tr>
									<td>내용물</td>
									<td>${subContent.name}</td>
									<td><fmt:formatNumber value="${subContent.weight}" pattern=".000"/></td>
									<td><fmt:formatNumber value="${mixTotalPrice/mixingRatioTotal}" pattern=".000"/></td>
									<td><fmt:formatNumber value="${mixTotalPrice/mixingRatioTotal*(subContent.weight/1000)}" pattern=".000"/></td>
								</tr>
							</c:forEach>
						</c:forEach>
					</tbody>
					<tfoot>
						<tr>
							<td colspan="4">총 합계</td>
							<%-- 
							<td><fmt:formatNumber value="${weightTotal}" pattern=".000"/></td>
							<td><fmt:formatNumber value="${kgPriceTotal}" pattern=".000"/></td>
							--%>
							<td><fmt:formatNumber value="${priceTotal}" pattern=".000"/></td>
						</tr>
					</tfoot>
				</table>
			</div>
			<div style="width:2%; float:left;">&nbsp;</div>
			<!-- 총 비용 END -->
			<!-- 이미지 -->
			<div style="width:41%; float:left;">
				<%-- <img src="../uploaded/images/<%=imagePath%>/<%=fileName%>" style="width:400px; height:285px;"> --%>
				첨부된 이미지가 없습니다.
			</div>
			
			<div class="btn_box_con">
				<button type="button" class="btn_admin_red" onClick="productDesignItemSubmit()">설계서(임시)저장</button>
				<button type="button" class="btn_admin_gray" onClick="window.history.go(-1); return false;">목록으로</button>
			</div>
		</div>
	</div>
</section>










<div style="display:none" id="subProdDiv">
	<!-- 부속제품 START -->
	<div class="insert_obj" name="subProduct" style="border: 1px dotted black;">
		부속제품명: <input name="subProdName"><Br>
		설명: <textarea name="subProdDesc"></textarea>
		<!-- 배합 START -->
		<div class="insert_obj">
			<div class="title">
				<span class="txt">배합</span>
			</div>
			<div class="btn_box_con2">
				<button type="button" class="btn_con_search" onclick="addTable(this, 'mix')"><img src="../resources/images/icon_s_write.png"/> 배합 추가</button>
				<!-- <button type="button" class="btn_con_search" onclick="manageIncludeMix();"><img src="../resources/images/icon_s_write.png"/> 포함배합 관리</button> -->
			</div>
			<div class="nomal_mix" id="mixArea">
				<div id="mixDiv" name="mixDiv">
					<div class="table_header01">
						<span class="table_order_btn">
							<button type="button" class="btn_up" onclick="moveUp(this)"></button>
							<button type="button" class="btn_down" onclick="moveDown(this)"></button>
						</span>
						<span class="title">
							<img src="../resources/images/img_table_header.png">&nbsp;&nbsp;
							배합명 : <input type="text" style="width:200px" name="mixName"/>
							 
							&nbsp;|&nbsp; 중량 : <input type="text" style="width:50px" name="mixWeight"/> g
							<!--
							&nbsp;|&nbsp; 수율 : <input type="text" style="width:50px" name="yield" id="yield" value="1" onchange="calSum('mix', '');" onkeyup="clearNoNum(this)"/>
							 -->
						</span>
						<span class="table_header_btn_box">
							<button type="button" class="btn_del_table_header" onclick="removeTable(this)"> 배합 삭제</button>
							<button type="button" class="btn_add_tr" onClick="addRow(this)"></button>
							<button type="button" class="btn_del_tr" onClick="removeRow(this)"></button>
						</span>
					</div>
					<table class="tbl05">
						<colgroup>
							<col width="20">
							<col width="140">
							<col width="auto"/>
							<col width="100">
							<col width="50">
							<col width="100">
							<col width="100">
							<col width="100">
							<col width="80">
						</colgroup>
						<thead>
							<tr>
								<th></th>
								<th>원료코드</th>
								<th>원료명</th>
								<th>배합비</th>
								<th>단위</th>
								<th>단가</th>
								<th>입력단가</th>
								<th>금액</th>
								<th>원료입고업체</th>
							</tr>
						</thead>
						<tbody id="mixTbody" name="mixTbody">
							<tr id="mixRow_1_1">
								<td>
									<input type="hidden" name="itemType"/>
									<input type="hidden" name="itemTypeName"/>
									<input type="checkbox" id="mixRowCheck_1_1" name=""><label for="mixRowCheck_1_1"><span></span></label>
								</td>
								<td>
									<input type="text" name="itemSapCode" style="width:100px" class="req"">
									<button type="button" class="btn_code_search" onclick="openMaterailPopup(this);"></button>
								</td>
								<td><input type="text" name="itemName" style="width:100%" readonly="readonly" class="read_only"/></td>
								<td name="tdMixRate"><input type="text" name="mixNumber" id="" onkeyup="calTableItemCost(this);" style="width:100%" class="req"/></td>
								<td><select name=""><option value="">선택</option></select></td>
								<td name="tdUnitCost"><input type="text" name="itemUnitPrice" style="width:100%" readonly="readonly" class="read_only"/></td>
								<td name="tdCustomUnitCost"><input type="text" name="itemCustomPrice" onkeyup="calTableItemCost(this);" style="width:100%" class="req"/></td>
								<td name="tdRowCost"><input type="text" name="itemCalculatedPrice" style="width:100%" readonly="readonly" class="read_only"/></td>
								<td><input type="text" name="" style="width:120px;"/></td>
							</tr>
						</tbody>
						<tfoot>
							<tr>
								<td colspan="3">총합</td>
								<td>
									<div id="totalMixRateDiv"> - </div>
									<input type="hidden" name="mixTotalMixRate" id="mixTotalMixRate" value="">
								</td>
								<td>&nbsp;</td>						
								<td>
									<div id="totalKgPriceDiv"> - </div>							
									<input type="hidden" name="mixTotalKgPrice" id="mixTotalKgPrice" value="">
								</td>
								<td>
									<div id="totalPriceDiv"> - </div>
									<input type="hidden" name="mixTotalPrice" id="mixTotalPrice" value="">
								</td>
								<td>
									<div id="totalMixPriceDiv"> - </div>
									<input type="hidden" name="mixTotalMixPrice" id="mixTotalMixPrice" value="">
								</td>
								<td>&nbsp;</td>
							</tr>
							<tr name="trUnit">
								<td colspan="3">kg/단가</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td name="tdTableUnitPrice">
									<div id="">0</div>
									<input type="hidden" name="" id="" value="">
								</td>
								<td>원</td>
								<td>&nbsp;</td>
							</tr>
							<tr name="trTotal">
								<td colspan="3">배합금액</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td name="tdTableTotalPrice">
									<div id="">0</div>
									<input type="hidden" name="" id="" value="">
								</td>
								<td>원</td>
								<td>&nbsp;</td>
							</tr>
						</tfoot>
					</table>
				</div>
			</div>
		</div>
		<!-- 배합 END -->
		
		<!-- 내용물 START -->
		<div class="insert_obj">
			<div class="title">
				<span class="txt">내용물</span>
			</div>
			<div class="btn_box_con2">
				<button type="button" class="btn_con_search" onclick="addTable(this, 'content')"><img src="../resources/images/icon_s_write.png"/> 내용물 추가</button>
				<!-- <button type="button" class="btn_con_search" onclick="manageIncludeMix();"><img src="../resources/images/icon_s_write.png"/> 포함배합 관리</button> -->
			</div>
			<div class="nomal_mix" id="mixArea">
				<div id="contentDiv" name="contentDiv">
					<div class="table_header02">
						<span class="table_order_btn">
							<button type="button" class="btn_up" onclick="moveUp(this)"></button>
							<button type="button" class="btn_down" onclick="moveDown(this)"></button>
						</span>
						<span class="title">
							<img src="../resources/images/img_table_header.png">&nbsp;&nbsp;
							내용물명 : <input type="text" style="width:200px" name="contentName"/>
							
							&nbsp;|&nbsp; 중량 : <input type="text" style="width:50px" name="contentWeight"/> g
							<!-- 
							&nbsp;|&nbsp; 수율 : <input type="text" style="width:50px" name="yield" id="yield" value="1" onchange="calSum('mix', '');" onkeyup="clearNoNum(this)"/>
							 -->
						</span>
						<span class="table_header_btn_box">
							<button type="button" class="btn_del_table_header" onclick="removeTable(this)"> 내용물 삭제</button>
							<button type="button" class="btn_add_tr" onClick="addRow(this)"></button>
							<button type="button" class="btn_del_tr" onClick="removeRow(this)"></button>
						</span>
					</div>
					<table class="tbl05">
						<colgroup>
							<col width="20">
							<col width="140">
							<col width="auto"/>
							<col width="100">
							<col width="50">
							<col width="100">
							<col width="100">
							<col width="100">
							<col width="80">
						</colgroup>
						<thead>
							<tr>
								<th></th>
								<th>원료코드</th>
								<th>원료명</th>
								<th>배합비</th>
								<th>단위</th>
								<th>단가</th>
								<th>입력단가</th>
								<th>금액</th>
								<th>원료입고업체</th>
							</tr>
						</thead>
						<tbody id="contentTbody" name="contentTbody">
							<tr id="contentRow_1_1">
								<td>
									<input type="hidden" name="itemType"/>
									<input type="hidden" name="itemTypeName"/>
									<input type="checkbox" id="contentRowCheck_1_1" name=""><label for="contentRowCheck_1_1"><span></span></label>
								</td>
								<td>
									<input type="text" name="itemSapCode" style="width:100px" class="req"">
									<button type="button" class="btn_code_search" onclick="openMaterailPopup(this);"></button>
								</td>
								<td><input type="text" name="itemName" style="width:100%" readonly="readonly" class="read_only"/></td>
								<td name="tdMixRate"><input type="text" name="mixNumber" id="" onkeyup="calTableItemCost(this);" style="width:100%" class="req"/></td>
								<td><select name=""><option value="">선택</option></select></td>
								<td name="tdUnitCost"><input type="text" name="itemUnitPrice" style="width:100%" readonly="readonly" class="read_only"/></td>
								<td name="tdCustomUnitCost"><input type="text" name="itemCustomPrice" onkeyup="calTableItemCost(this);" style="width:100%" class="req"/></td>
								<td name="tdRowCost"><input type="text" name="itemCalculatedPrice" style="width:100%" readonly="readonly" class="read_only"/></td>
								<td><input type="text" name="" style="width:120px;"/></td>
							</tr>
						</tbody>
						<tfoot>
							<tr>
								<td colspan="3">총합</td>
								<td>
									<div id="totalMixRateDiv"> - </div>
									<input type="hidden" name="mixTotalMixRate" id="mixTotalMixRate" value="">
								</td>
								<td>&nbsp;</td>						
								<td>
									<div id="totalKgPriceDiv"> - </div>							
									<input type="hidden" name="mixTotalKgPrice" id="mixTotalKgPrice" value="">
								</td>
								<td>
									<div id="totalPriceDiv"> - </div>
									<input type="hidden" name="mixTotalPrice" id="mixTotalPrice" value="">
								</td>
								<td>
									<div id="totalMixPriceDiv"> - </div>
									<input type="hidden" name="mixTotalMixPrice" id="mixTotalMixPrice" value="">
								</td>
								<td>&nbsp;</td>
							</tr>
							<tr name="trUnit">
								<td colspan="3">kg/단가</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td name="tdTableUnitPrice">
									<div id=""> 0 </div>
									<input type="hidden" name="" id="" value="">
								</td>
								<td>원</td>
								<td>&nbsp;</td>
							</tr>
							<tr name="trTotal">
								<td colspan="3">배합금액</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td name="tdTableTotalPrice">
									<div id=""> 0 </div>
									<input type="hidden" name="" id="" value="">
								</td>
								<td>원</td>
								<td>&nbsp;</td>
							</tr>
						</tfoot>
					</table>
				</div>
			</div>
		</div>
		<!-- 내용물 END -->
	</div>
	<!-- 부속제품 END -->
	
	<!-- 재료 START -->
	<div class="insert_obj">
		<div class="title">
			<span class="txt">재료</span>
		</div>
		<div class="btn_box_con2">
			<button type="button" class="btn_con_search" onclick="addTable(this, 'package')"><img src="../resources/images/icon_s_write.png"/> 재료 추가</button>
		</div>
		<div class="nomal_mix" id="mixArea">
			<div id="packageDiv" name="packageDiv">
				<div class="table_header03">
					<span class="table_order_btn">
						<button type="button" class="btn_up" onclick="moveUp(this)"></button>
						<button type="button" class="btn_down" onclick="moveDown(this)"></button>
					</span>
					<span class="title">
						<img src="../resources/images/img_table_header.png">&nbsp;&nbsp;
						재료 
					</span>
					<span class="table_header_btn_box">
						<button type="button" class="btn_del_table_header" onclick="removeTable(this, 'package')"> 재료 삭제</button>
						<button type="button" class="btn_add_tr" onClick="addRow(this)"></button>
						<button type="button" class="btn_del_tr" onClick="removeRow(this)"></button>
					</span>
				</div>
				<table class="tbl05">
					<colgroup>
						<col width="20">
						<col width="140">
						<col width="auto"/>
						<col width="100">
						<%-- <col width="100"> --%>
						<col width="100">
						<col width="80">
					</colgroup>
					<thead>
						<tr>
							<th></th>
							<th>재료코드</th>
							<th>재료명</th>
							<th>단가</th>
							<!-- <th>입력단가</th> -->
							<th>금액</th>
							<th>원료입고업체</th>
						</tr>
					</thead>
					<tbody id="packageTbody">
						<tr id="packageRow_1_1">
							<td>
								<input type="hidden" name="itemType"/>
								<input type="hidden" name="itemTypeName"/>
								<input type="checkbox" id="packageRowCheck_1_1" name=""><label for="packageRowCheck_1_1"><span></span></label>
							</td>
							<td>
								<input type="text" name="itemSapCode" style="width:100px" class="req"">
								<button type="button" class="btn_code_search" onclick="openMaterailPopup(this)"/>
							</td>
							<td><input type="text" name="itemName" style="width:100%" readonly="readonly" class="read_only"/></td>
							<td name="tdUnitCost"><input type="text" name="itemUnitPrice" style="width:100%" readonly="readonly" class="read_only"/></td>
							<!-- <td name="tdCustomUnitCost"><input type="text" name="itemCustomPrice" onkeyup="calTableItemCost(this);" style="width:100%" class="req"/></td> -->
							<td name="tdRowCost"><input type="text" name="itemCalculatedPrice" style="width:100%" readonly="readonly" class="read_only"/></td>
							<td><input type="text" name="" style="width:120px;"/></td>
						</tr>
					</tbody>
					<tfoot>
						<tr>
							<td colspan="3">총합</td>
							<td>
								<div id="totalMixRateDiv"> - </div>
								<input type="hidden" name="mixTotalMixRate" id="mixTotalMixRate" value="">
							</td>
							<td>
								<div id="totalPriceDiv"> - </div>
								<input type="hidden" name="mixTotalPrice" id="mixTotalPrice" value="">
							</td>
							<td>&nbsp;</td>
						</tr>
						<tr name="trUnit">
							<td colspan="3">kg/단가</td>
							<td name="tdTableUnitPrice">
								<div id=""> 0 </div>
								<input type="hidden" name="" id="" value="">
							</td>
							<td>원</td>
							<td>&nbsp;</td>
						</tr>
						<tr name="trTotal">
							<td colspan="3">배합금액</td>
							<td name="tdTableTotalPrice">
								<div id=""> 0 </div>
								<input type="hidden" name="" id="" value="">
							</td>
							<td>원</td>
							<td>&nbsp;</td>
						</tr>
					</tfoot>
				</table>
			</div>
		</div>
	</div>
	<!-- 재료 END -->
</div>