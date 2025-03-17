<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ taglib prefix="userUtil" uri="/WEB-INF/tld/userUtil.tld"%>
<%@ page session="false"%>

<script src="//cdnjs.cloudflare.com/ajax/libs/babel-standalone/6.26.0/babel.min.js"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/babel-polyfill/7.4.3/polyfill.js"></script>

<title>자재 변경관리</title>

<style type="text/css">
.readOnly {
	background-color: #ddd
}

.positionCenter {
	position: absolute;
	transform: translate(-50%, -50%);
}
</style>
<script type="text/javascript">
	var bomList;
	
	var PARAM = {
		isSample : '${paramVO.isSample}',
		searchCompany : '${paramVO.searchCompany}',
		searchPlant : '${paramVO.searchPlant}',
		searchType : '${paramVO.searchType}',
		searchValue : '${paramVO.searchValue}',
		pageNo : '${paramVO.pageNo}'
	};

	$(document).ready(function() {
		$('#lab_loading').show();
		
		//console.log('${userUtil:getIsAdmin(pageContext.request)}')
		//console.log('${materialManagementList}');
		//loadList(1);
		//$('#mtch_company').change();
		
		//var param = '${paramVO}';
		
		
		loadBomList();
		
		$('input[name=showType]').change(function(el){
			setList();
		})
	});

	function bindEnter(elementId, fn) {
		$('#' + elementId).keyup(function(event) {
			if (event.keyCode == 13) {
				fn();
			}
		});
	}

	function bindDialogEnter(e) {
		if (e.keyCode == 13)
			$(e.target).next().click();
	}

	function loadBomList() {
		$('#lab_loading').show();
		$("#list").html("<tr><td align='center' colspan='10'>조회중입니다.</td></tr>");
		
		var listData = [];
		
		var postData = {
			preSapCode : '${paramVO.preSapCode}'
			, postSapCode : '${paramVO.postSapCode}'
			, companyCode : '${paramVO.companyCode}'
			, plantCode : '${paramVO.plantCode}'
		};
		
		$.ajax({
			url: '/material/getBomListOfMaterial',
			type: 'POST',
			data: postData,
			success: function(data){
				//console.log(data);
				if(data.tables.IT_RETURN.length > 0){
					data.tables.IT_RETURN.map( function(row, index) {
						listData.push({
							id: index,
							MATNR: row.MATNR,
							WERKS: row.WERKS,
							VWALT: row.VWALT,
							OJTXB: row.OJTXB,
							IDNRK: row.IDNRK,
							dNoList: row.dNoList,
							isExcept: false
						})
					})
					for (var i = 0; i < data.tables.IT_RETURN.length; i++) {
						
					}
				}
				bomList = listData;
				setList();
			},
			error: function(a,b,c){
				//console.log(a,b,c)
				$("#list").html("<tr><td align='center' colspan='10'>오류가 발생하였습니다.</td></tr>");
			},
			complete: function(){
				$('#lab_loading').hide();
			}
		})
	}
	
	function autoSearch(e){
		if (timer) {
			clearTimeout(timer);
		}
		timer = setTimeout(function() { 
			setList();
		}, 200);
	}
	
	function setList(){
		var searchField = $('#searchField').val();
		var searchText = $('#searchValue').val()
		
		var radioVal = $('input[name=showType]:checked').val();
		
		var html = "";
		
		var filteredList;
		if(searchText.length > 0){
			if(searchField == 'productCode'){
				filteredList = bomList.filter(function(row){
				    return row.MATNR.indexOf(searchText) >= 0
				})
			} else if(searchField == 'stlal'){
				filteredList = bomList.filter(function(row){
				    return row.POSNR.indexOf(searchText) >= 0
				})
			} else if(searchField == 'plant'){
				filteredList = bomList.filter(function(row){
				    return row.PLANT.indexOf(searchText) >= 0
				})
			}
		} else {
			filteredList = bomList;
		}
		
		for (var i = 0; i < filteredList.length; i++) {
			switch (radioVal) {
			case "1":
				html = setHtml(html, filteredList[i]);
				break;
			case "2":
				if(!filteredList[i].isExcept) 
					html = setHtml(html, filteredList[i]);
				break;
			case "3":
				if(filteredList[i].isExcept) 
					html = setHtml(html, filteredList[i]);
				break;
			default:
				break;
			}
		}
		$("#list").html(html);
		setTotal();
	}
	
	function setHtml(html, rowData){
		if(rowData.isExcept){
			html += '<tr id="row'+rowData.id+'" class="m_visible">';
		} else {
			html += '<tr id="row'+rowData.id+'">';	
		}
		html += "	<td>"+rowData.MATNR+"</td>";
		html += "	<td>"+rowData.VWALT+"</td>";
		html += "	<td>"+rowData.WERKS+"</td>";
		html += '	<td><div class="ellipsis_txt tgnl"><a href="#">'+rowData.OJTXB+'</a><span class="icon_new">n</span></div></td>';
		html += "	<td style='text-align: left'>";
		//html += rowData.dNoList;
		var dNoList = rowData.dNoList.split(',');
		for (var i = 0; i < dNoList.length; i++) {
			if(dNoList[i].length>0)
				html += "&nbsp;<img src=\"/resources/images/icon_doc01.png\"><a href=\"javascript:preViewMfgDoc('"+dNoList[i]+"')\">"+dNoList[i]+"</a>"
		}
		html += "	</td>";
		html += "	<td></td>";
		html += "	<td></td>";
		if(rowData.isExcept){
			html += '	<td><button class="btn_doc" onclick="exceptRow('+rowData.id+')"><img src="/resources/images/icon_doc17.png">&nbsp;제외취소</button></td>';
		} else {
			html += '	<td><button class="btn_doc" onclick="exceptRow('+rowData.id+')"><img src="/resources/images/icon_doc16.png">&nbsp;변경제외</button></td>';	
		}
		
		return html;
	}
	
	function setTotal(){
		var totalCount = bomList.length;
		var exceptCount = 0;
		
		for (var i = 0; i < bomList.length; i++) {
			if(bomList[i].isExcept == true) exceptCount++;
		}
		
		$('#totDiv').html('<span class="font13">총 '+totalCount+'건 / </span><span style="font-size: 15px; color: #e83346"> '+exceptCount+'개 변경제외 </span>')
	}
	
	function exceptRow(id){
		var radioVal = $('input[name=showType]:checked').val();
		
		for (var i = 0; i < bomList.length; i++) {
			if(bomList[i].id == id) {
				if(bomList[i].isExcept){
					bomList[i].isExcept = !bomList[i].isExcept;
					$('#row'+id).attr('class', '')
					$('#row'+id+' td:nth-child(8)').html('<button class="btn_doc" onclick="exceptRow('+bomList[i].id+')"><img src="/resources/images/icon_doc16.png">&nbsp;변경제외</button>')
				} else {
					bomList[i].isExcept = !bomList[i].isExcept;
					$('#row'+id).attr('class', 'm_visible')
					$('#row'+id+' td:nth-child(8)').html('<button class="btn_doc" onclick="exceptRow('+bomList[i].id+')"><img src="/resources/images/icon_doc17.png">&nbsp;제외취소</button>')
				}
			}
		}
		
		if(radioVal == "2" || radioVal == "3"){
			setList();
		}
		setTotal();
	}
	
	function exceptAll(flag){
		var radioVal = $('input[name=showType]:checked').val();
		
		for (var i = 0; i < bomList.length; i++) {
			bomList[i].isExcept = flag;
		}
		
		setList();
		setTotal();
	}

	function openMtchDialog() {
		openDialog('dialog_mtch');
	}

	function closeMtchDialog() {
		closeDialog('dialog_mtch');
	}

	function openMaterialPopup(element, itemType) {
		if ($('#mtch_plant').val().length <= 0)
			return alert('회사, 공장, 생산라인을 선택해주세요');

		var targetId = $(element).prev().attr('id');
		$('#targetID').val(targetId);
		openDialog('dialog_material');

		var matCode = $(element).prev().val()
		if (typeof (matCode) == 'string')
			matCode = matCode.toUpperCase();
		$('#searchMatValue').val(matCode);
		$('#itemType').val(itemType);

		searchMaterial();
	}

	function closeMatRayer() {
		$('#searchMatValue').val('')
		$('#matLayerBody').empty();
		$('#matLayerBody').append('<tr><td colspan="10">원료코드 혹은 원료코드명을 검색해주세요</td></tr>');
		$('#matCount').text(0);
		closeDialog('dialog_material')
	}

	function searchMaterial(pageType) {
		var pageType = pageType;

		if (!pageType)
			$('#matLayerPage').val(1)

		if (pageType == 'nextPage') {
			var totalCount = Number($('#matCount').text());
			var maxPage = totalCount / 10 + 1;
			var nextPage = Number($('#matLayerPage').val()) + 1;

			if (nextPage >= maxPage)
				return; //nextPage = maxPage

			$('#matLayerPage').val(nextPage);
		}

		if (pageType == 'prevPage') {
			var prevPage = Number($('#matLayerPage').val()) - 1;
			if (prevPage <= 0)
				return; //prevPage = 1;

			$('#matLayerPage').val(prevPage);
		}

		$('#lab_loading').show();
		$.ajax({
			url : '/design/getMaterialList',
			type : 'post',
			dataType : 'json',
			data : {
				searchValue : $('#searchMatValue').val(),
				companyCode : $('#mtch_company').val(),
				plant : $('#mtch_plant').val(),
				itemType : $('#itemType').val(),
				showPage : $('#matLayerPage').val()
			},
			success : function(data) {
				var jsonData = {};
				jsonData = data;
				$('#matLayerBody').empty();
				$('#matLayerBody').append('<input type="hidden" id="matLayerPage" value="'+data.page.showPage+'"/>');

				jsonData.pagenatedList.forEach(function(item) {
					var row = '<tr onClick="setMaterialPopupData(\''
							+ $('#targetID').val()
							+ '\', \''
							+ item.itemImNo
							+ '\', \''
							+ item.itemSAPCode
							+ '\', \''
							+ item.itemName
							+ '\', \''
							+ item.itemPrice
							+ '\', \''
							+ item.itemUnit + '\')">';
					row += '<td></td>';
					row += '<Td>' + item.plantName + '</Td>';
					row += '<Td>' + item.itemSAPCode + '</Td>';
					row += '<Td class="tgnl">' + item.itemName + '</Td>';
					row += '<Td>' + item.itemPrice + '</Td>';
					row += '<Td>' + (item.itemType == 'B' ? '원료' : (item.itemType == 'R' ? '재료' : '')) + '</Td>';
					row += '<Td>' + item.regDate + '</Td>';
					row += '<Td>' + item.supplyDate + '</Td>';
					row += '<Td>' + item.supplyCompany + '</Td>';

					row += '</tr>';
					$('#matLayerBody').append(row);
				})
				
				$('#matCount').text(jsonData.page.totalCount)

				var isFirst = $('#matLayerPage').val() == 1 ? true : false;
				var isLast = parseInt(jsonData.page.totalCount / 10 + 1) == Number($('#matLayerPage').val()) ? true : false;

				if (isFirst) {
					$('#matNextPrevDiv').children('button:first').attr('class', 'btn_code_left01');
				} else {
					$('#matNextPrevDiv').children('button:first').attr('class', 'btn_code_right02');
				}
				

				if (isLast) {
					$('#matNextPrevDiv').children('button:last').attr('class', 'btn_code_right01');
				} else {
					$('#matNextPrevDiv').children('button:last').attr('class', 'btn_code_right02');
				}
			},
			error : function(a, b, c) {
				//console.log(a,b,c);
				alert('자재검색 실패[2] - 시스템 담당자에게 문의하세요');
			},
			complete : function() {
				$('#lab_loading').hide();
			}
		})
	}

	function setMaterialPopupData(parentRowId, itemImNo, itemSAPCode, itemName, itemUnitPrice, itemUnit) {
		/* 
		$('#'+parentRowId + ' input[name$=itemImNo]').val(itemImNo);
		$('#'+parentRowId + ' input[name$=itemSapCode]').val(itemSAPCode);
		$('#'+parentRowId + ' input[name$=itemName]').val(itemName);
		$('#'+parentRowId + ' input[name$=itemUnitPrice]').val(itemUnitPrice);
		$('#'+parentRowId + ' input[name$=itemCustomPrice]').val(itemUnitPrice);
		$('#'+parentRowId + ' input[name$=itemUnit]').val(itemUnit);
		$('#'+parentRowId + ' input[name$=itemOrgUnit]').val(itemUnit);
		$('#'+parentRowId + ' input[name$=itemCalculatedPrice]').val(itemUnitPrice);
		 */
		$('#' + parentRowId).val(itemSAPCode);
		closeMatRayer();
	}

	function changeCompany(e) {
		var companyCode = e.target.value;
		var URL = "../common/plantListAjax";

		$.ajax({
			type : "POST",
			url : URL,
			data : {
				"companyCode" : companyCode
			},
			dataType : "json",
			async : false,
			success : function(data) {
				var selectBoxId = 'mtch_plant';
				var list = data.RESULT;
				$("#" + selectBoxId).removeOption(/./);
				$("#" + selectBoxId).addOption("", "전체", false);
				$("label[for=" + selectBoxId + "]").html("전체");
				$.each(list, function(index, value) { //배열-> index, value
					$("#" + selectBoxId).addOption(value.plantCode, value.plantName, false);
				});
				$("#companyNo_li").hide();
				$("#companyNo_span").html("");
				$("#companyNo").val("");

			},
			error : function(request, status, errorThrown) {
				alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
			}
		});
	}
	
	function submitMtch(type){
		var preSapCode = $('#preSapCode').val();
		var postSapCode = $('#postSapCode').val();
		var companyCode = $('#mtch_company').val();
		var planyCode = $('#mtch_plant').val();
		
		if(preSapCode.length <= 0){
			alert("기존 자재코드를 입력해주세요");
			$('#preSapCode').focus();
			return;
		}
		
		if(postSapCode.length <= 0){
			alert("신규 자재코드를 입력해주세요");
			$('#postSapCode').focus();
			return;
		}
		
		var form = document.createElement('form');
		form.style.display = 'none';
		form.action = '/material/changeRequest';
		form.method = 'post';
		
		appendInput(form, 'type', type);
		appendInput(form, 'preSapCode', preSapCode);
		appendInput(form, 'postSapCode', postSapCode);
		appendInput(form, 'companyCode', companyCode);
		appendInput(form, 'planyCode', planyCode);
		
		$('body').append(form);
		$(form).submit();
	}
	
	function changeMaterial(){
		$('#lab_loading').show();
		var postData = getPostData();
		postData.itemList = getPostItemList();
		
		$.ajax({
			url: '/material/requestMaterialChange',
			type: 'post',
			data: JSON.stringify(postData),
			contentType: 'application/json',
			success: function(data){
				if(data.status == 'success'){
					alert('등록되었습니다');
					location.href = '/material/changeList';
				} else {
					$('#lab_loading').hide();
					return alert(data.msg);
				}
			},
			error: function(a,b,c){
				//console.log(a,b,c)
				$('#lab_loading').hide();
				return alert('변경요청 작성 오류[2] - 시스템 관리자에게 문의하세요');
			}
		})
	}
	
	function getPostData(){
		var returnData = {};
		
		returnData.preSapCode = '${paramVO.preSapCode}';
		returnData.postSapCode = '${paramVO.postSapCode}';
		returnData.companyCode = '${paramVO.companyCode}';
		returnData.plantCode = '${paramVO.plantCode}';
		
		return returnData;
	}
	
	function getPostItemList(){
		var itemList = [];
		bomList.map(function(row, index){
			if(!row.isExcept){
				var item = {};
				item.id = row.id;
				item.productCode = row.MATNR;
				item.productName = row.OJTXB;
				item.sapCode = row.IDNRK;
				item.plant = row.WERKS;
				item.posnr = row.VWALT;
				item.dNoList = row.dNoList
				itemList.push(item);
			}
		})
		
		return itemList;
	}
	
	function preViewMfgDoc( dNo ) {
		var url = "/dev/manufacturingProcessDetailPopup2?dNo="+dNo;
		var mode = "width=1100, height=650, left=100, top=50, scrollbars=yes";
		window.open(url, "", mode );
	}
</script>

<input type="hidden" name="pageNo" id="pageNo" value="${paramVO.pageNo}">
<input type="hidden" name="imNo" id="imNo" value="">
<div class="wrap_in" id="fixNextTag">
	<span class="path">자재 변경요청&nbsp;&nbsp; <img src="/resources/images/icon_path.png" style="vertical-align: middle" />자재 변경관리&nbsp;&nbsp; <img src="/resources/images/icon_path.png" style="vertical-align: middle" />&nbsp;&nbsp; <a href="#">${strUtil:getSystemName()}</a>
	</span>
	<section class="type01">
		<!-- 상세 페이지  start-->
		<h2 style="position: relative">
			<span class="title_s">Material Change Control</span> <span class="title">자재 변경관리</span>
			<div class="top_btn_box">
				<ul>
					<li>
						<button type="button" class="btn_circle_save" onClick="changeMaterial()">&nbsp;</button>
					</li>
				</ul>
			</div>
		</h2>
		<div class="group01">
			<div class="title">
				<!--span class="txt">연구개발시스템 공지사항</span-->
			</div>
			<div class="prodoc_title" style="margin-bottom: 10px; border-top: 2px solid #4b5165">
				<div style="width: 100px; height: 100px; display: inline-block; vertical-align: top;" class="product_img">
					<img src="/resources/images/img_change_code.png">
				</div>
				<div style="display: inline-block; height: 80px; width: 900px; padding-top: 10px;">
					<span class="font13">자재코드 변경 : [${mmHeader.preSapCode}]${mmHeader.preName}&nbsp;<img src="/resources/images/icon_arr.png">&nbsp;<strong style="color: #e83346;">[${mmHeader.postSapCode}]${mmHeader.postName} </strong></span><br />
					<span class="font18">공장 : ${mmHeader.plantName} </span> <br />
					<span class="font16">* 검색 옵션을 이용해 아래의 리스트 중 변경 제외 할 항목을 선택해주세요.</span><br />
					
				</div>
			</div>
			<div class="fr pt5 pb10">
				<button class="btn_con_search" onclick="openMtchDialog()">
					<img src="/resources/images/btn_icon_refresh.png" style="vertical-align: middle;" /> 변경 자재코드 재입력
				</button>
			</div>
			<div id="totDiv" class="fl" style="height: 30px; padding: 10px 0 0 15px;">
				<span class="font13">총 0건 / </span><span style="font-size: 15px; color: #e83346"> 0개 변경제외 </span>
			</div>
			<div class="search_box ">
				<ul>
					<li>
						<dt>검색</dt>
						<dd>
							<div class="selectbox" style="width: 100px;">
								<select id="searchField">
									<option value="productCode" selected>제품코드</option>
									<option value="stlal">대체BOM</option>
									<option value="plant">공장</option>
								</select> <label for="searchField">제품코드</label>
							</div>
							<input id="searchValue" type="text" style="width: 180px; margin-left: 5px;" onkeyup="autoSearch(event)" />
						</dd>
					</li>
					<li>
						<dt>보기</dt>
						<dd>
							<input type="radio" name="showType" id="st1" value="1" checked="checked" /><label for="st1" style="vertical-align: sub"><span></span>전체</label> <input type="radio" name="showType" id="st2" value="2" /><label for="st2" style="vertical-align: sub"><span></span>변경대상</label> <input type="radio" name="showType" id="st3" value="3" /><label for="st3" style="vertical-align: sub"><span></span>변경제외</label>
						</dd>
					</li>
				</ul>
			</div>
			
			<div class="fr pt5 pb10">
				<button class="btn_con_search" onclick="exceptAll(true)">모두 변경제외</button>
				<button class="btn_con_search" onclick="exceptAll(false)">모두 변경대상</button>
			</div>

			<div class="main_tbl" style="height: 800px; overflow-y: scroll; overflow-x: auto; float: left; width: 100%; background-color: rgb(245, 245, 245)">
				<table class="tbl04">
					<colgroup>
						<col width="8%">
						<col width="7%">
						<col width="10%">
						<col />
						<col width="15%">
						<col width="8%">
						<col width="8%">
						<col width="15%">
					</colgroup>
					<thead>
						<tr>
							<th>제품코드</th>
							<th>대체BOM</th>
							<th>공장</th>
							<th>제품명</th>
							<th>연관 제조공정서</th>
							<th>작성자</th>
							<th>작성일</th>
							<th>변경여부</th>
						<tr>
					</thead>
					<tbody id="list"></tbody>
				</table>
			</div>
			<div class="btn_box_con">
				<button class="btn_admin_gray" onclick="javascript:history.back()">변경 취소</button>
				<button class="btn_admin_sky" onclick="changeMaterial()">변경요청서 저장</button>
			</div>
			<hr class="con_mode" />
			<!-- 신규 추가 꼭 데려갈것 !-->
		</div>
	</section>
</div>


<!-- 자재 코드 변경 레이어 start-->
<div class="white_content" id="dialog_mtch">
	<div class="modal" style="width: 500px; margin-left: -250px; height: 350px; margin-top: -200px;">
		<h5 style="position: relative">
			<span class="title">자재코드 변경</span>
			<div class="top_btn_box">
				<ul>
					<li><button class="btn_madal_close" onClick="closeMtchDialog()"></button></li>
				</ul>
			</div>
		</h5>
		<div class="list_detail">
			<ul>
				<li class="pt10">
					<dt style="width: 35%;">공장</dt>
					<dd style="width: 65%;">
						<div class="selectbox" style="width: 100px;">
							<select id="mtch_company" onchange="changeCompany(event)">
								<c:forEach items="${company}" var="com" varStatus="status">
									<option value="${com.companyCode}""${status.index == 0 ? 'selected' : ''}">${com.companyName}</option>
								</c:forEach>
							</select> <label for="mtch_company">${company[0].companyName}</label>
						</div>
						<div class="selectbox ml5" style="width: 150px;">
							<select id="mtch_plant">
								<option selected>전체</option>
							</select> <label for="mtch_plant">전체</label>
						</div>
					</dd>
				</li>
				<li>
					<dt style="width: 35%;">기존 자재코드</dt>
					<dd style="width: 65%;">
						<input id="preSapCode" type="text" class="req fl" style="width: 258px;" placeholder="기존 자재코드 입력" onkeyup="bindDialogEnter(event)" />
						<button class="btn_code_search2" style="border-bottom: none; margin-left: 5px;" onclick="openMaterialPopup(this)"></button>
					</dd>
				</li>
				<li>
					<dt style="width: 35%;">신규 자재코드</dt>
					<dd style="width: 65%;">
						<input id="postSapCode" type="text" style="width: 258px;" class="req fl" placeholder="신규 자재코드 입력 " onkeyup="bindDialogEnter(event)" />
						<button class="btn_code_search2" style="border-bottom: none; margin-left: 5px;" onclick="openMaterialPopup(this)"></button>
					</dd>
				</li>
				<li>
					<dt style="background-image: none; width: 35%;"></dt>
					<dd style="width: 65%;">
						- 자재코드 변경시 <span class="font05">결재 완료</span> 후 반영됩니다.
					</dd>
				</li>
			</ul>
			<!-- 일괄 변경 클릭 후 변경시간이 오래걸리면 오래걸릴수 있다는 알림/ 1231건 변경완료되었습니다. 알림 -->
			<div class="btn_box_con">
				<button class="btn_admin_sky" onclick="submitMtch('all')">자재코드 일괄 변경</button>
				<button class="btn_admin_navi" onclick="submitMtch('part')">자재코드 부분 변경</button>
			</div>
		</div>
	</div>
</div>
<!--  자재 코드 변경 레이어 close-->

<!--  자재 검색 레이어 start -->
<div class="white_content" id="dialog_material">
	<input id="targetID" type="hidden"> <input id="itemType" type="hidden">
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
			<input id="searchMatValue" type="text" class="code_input" onkeyup="bindDialogEnter(event)" style="width: 300px;" placeholder="일부단어로 검색가능"> <img src="/resources/images/icon_code_search.png" onclick="searchMaterial()" />
			<div class="code_box2">
				(<strong> <span id="matCount">0</span>
				</strong>)건
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
						<input type="hidden" id="matLayerPage" value="0" />
						<Tr>
							<td colspan="10">원료코드 혹은 원료코드명을 검색해주세요</td>
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
<!--  자재 검색 레이어 close -->


<!-- Builder 개발서버 반영 원복 재실행을 위한 주석 추가 -->