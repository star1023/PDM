<%@ page import="kr.co.aspn.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="userUtil" uri="/WEB-INF/tld/userUtil.tld"%>
<title>제품개발문서</title>

<style>
.input[type=text] {
	-webkit-ime-mode:active;
	-moz-ime-mode:active;
	-ms-ime-mode:active;
	ime-mode:active;
}
.positionCenter{
	position: absolute;
	transform: translate(-50%, -45%);
}

.hidden-element {
  display: none;
}
</style>

<script type="text/javascript" src="/resources/js/jquery.auto-complete.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		
		loadCodeList( "PRODCAT1", "dialog_productType1" );
		loadCodeList( "PRODCAT1", "search_productType1" );
		loadCodeList( "STERILIZATION", "sterilization" );
		loadCodeList( "ETCDISPLAY", "etcDisplay" );
		loadCodeList( "STORE", "select_store_div"); 	//23.10.11 점포명 공통코드화
		loadCodeList( "STORE", "search_store_div");		//24.01.18 점포용 검색조건추가
		
		applyDatePicker('launchDate');
		
		var productCategory = '${search.productCategory}';
		var productType1 = '${search.productType1}';
		var productType2 = '${search.productType2}';
		var productType3 = '${search.productType3}';
		var compnayCode = '${search.companyCode}';
		var plantCode = '${search.plantCode}';
		var nonHeat = '${search.nonHeat}';
		var searchField = '${search.searchField}';
		var searchValue = '${search.searchValue}';
		var productDocType = '${search.productDocType}';
		var storeDiv = '${search.storeDiv}';			// 24.01.18
		
		if(productCategory != '' || productCategory != null){
			$('#productCategory').children().toArray().forEach(function(element){
				if($(element).val() == productCategory){
					$(element).attr('selected', true)
					$('#productCategory').prev().text($(element).text())
				} else {
					$(element).attr('selected', false)
				}
			})
		}
		 
		if(productType1.length > 0){ 
			$('#search_productType1 option[value='+productType1+']').prop('selected', true);
			$('#search_productType1').change();
		}
		if(productType2.length > 0){ 
			$('#search_productType2 option[value='+productType2+']').prop('selected', true);
			$('#search_productType2').change();
		}
		if(productType3.length > 0){ 
			$('#search_productType3 option[value='+productType3+']').prop('selected', true);
			$('#search_productType3').change();
		}
		
		if(compnayCode != '' || compnayCode != null){
			$('#companyCode').children().toArray().forEach(function(element, i){
				if($(element).val() == compnayCode){
					$(element).attr('selected', true);
					$(element).change();
					$('#companyCode').prev().text($(element).text())
				} else {
					$(element).attr('selected', false);
				}
			})
		}
		
		if(plantCode != '' || plantCode != null){
			$('#plantCode').children().toArray().forEach(function(element, i){
				if($(element).val() == plantCode){
					$(element).attr('selected', true);
					$('#plantCode').prev().text($(element).text())
				} else {
					$(element).attr('selected', false);
				}
			})
		}
		
		if(searchField != '' || searchField != null){
			$('#searchField').children().toArray().forEach(function(element, i){
				if($(element).val() == searchField){
					$(element).attr('selected', true);
					$('#searchField').prev().text($(element).text())
				} else {
					$(element).attr('selected', false);
				}
			})
		}
		
		if(nonHeat.length <= 0) $('#searchForm input[name=nonHeat][value=""]').click();
		else $('#searchForm input[name=nonHeat][value=\"'+nonHeat+'\"]').prop('checked', true);
		$('#searchValue').val(searchValue);
		console.log(productDocType);
		$("#search_productDocType option[value='"+productDocType+"']").prop("selected",true);
		$("#search_productDocType").change();
		
		$("#search_productDocType").change(function(){	// 제품개발문서 유형  // 24.01.18
			var productDocTypeVal = $(this).val();
			$("#search_store_div").val("");
			
			// 선택한 값이 1(점포용)인경우  점포 항목 show , 이외는 hide
			if(productDocTypeVal == "1"){
				$(".storeDivBox").show();
			}else{
				$(".storeDivBox").hide();
				$("#search_store_div").prop('selectedIndex', -1);
				$("#search_store_div").children().prop("selected", false);
			}	
		});
		
		if(storeDiv != '' || storeDiv != null){		//검색 후 유형(점포)에 선택한 점포항목 표시  // 24.01.18
			if(productDocType != '1'){
				$(".storeDivBox").hide();
			}
			
			$('#search_store_div').children().toArray().forEach(function(element, i){
				if($(element).val() == storeDiv){
					$(element).attr('selected', true);
					$('#search_store_div').prev().text($(element).text())
				} else {
					$(element).attr('selected', false);
				}
			})
		}
		
		
		/* 제품개발문서 생성시 점포용제조공정서 목록 */
		$('#select_store_div option:first').prop('selected', true);
		$('#select_store_div').change();

		/* 
		$(function() {
			$('#reqNum').autoComplete({
				minChars: 1,
				delay: 100,
				cache: false,
				source: function(term, response){
					$.ajax({
						type: 'POST',
						url: '../manufacturingNo/getMfgNoList',
						dataType: 'json',
						data: {
							"mfgNo" : $('#reqNum').val()
						},			
						global: false,
						async: false,
						success: function (data) {
							//console.log(data);
							if(!data){
								return;
							}
							var list = data; 
							var completes = [];
							for(var i = 0, len = list.length; i < len; i++){
								var name = list[i].companyCode + " / " + list[i].plantCode + " / " + list[i].manufacturingName+ " / " + list[i].manufacturingNo;
								completes.push([name, list[i].manufacturingNo]);  
							}
							console.log(completes);
							response(completes);	
						}
					});
				},
				renderItem: function (item, search){
					console.log(item, search)
				    return '<div class="autocomplete-suggestion" data-code="' + item[1] + '" data-nm="' + item[0] + '" style="font-size: 0.8em">' + item[1] + '</div>';
				},
				onSelect: function(e, term, item){
					$("#searchUser").val(item.data('nm'));
					$("#selectUserId").val(item.data('code'));	
					$("#selectUserInfo").val(item.data('nm'));	
				},
				focus: function(event, ui) {
			         return false;
				}	
			});
		})
		 */
	});
	
	
	function changePage(page){
		search(page);
	}
	
	function readProductDevDoc(docNo, docVersion,regUserId){
		var form = document.createElement('form');
		//$(form).hide();
		form.style.display = 'none';
		$('body').append(form);
		form.action = '/dev/productDevDocDetail';
		form.target = '_blank';
		form.method = 'post';
		
		appendInput(form, 'docNo', docNo);
		appendInput(form, 'docVersion', docVersion);
		appendInput(form, 'regUserId', regUserId);
		
		$(form).submit();
	}
	
	function changeOwnerType(ownerType){
		$('input[name=ownerType]').val(ownerType);
		search('');
	}
	
	function showChildVersion(imgElement){
		var docNo = $(imgElement).parent().parent().attr('id').split('_')[1];
		var elementImg = $(imgElement).attr('src').split('/')[$(imgElement).attr('src').split('/').length-1];
		
		var addImg = 'img_add_doc.png';
		
		if(elementImg == addImg){
			$(imgElement).attr('src', $(imgElement).attr('src').replace('_add_', '_m_')); 
			$('tr[id*=devDoc_'+docNo+']').show();
		} else {
			$(imgElement).attr('src', $(imgElement).attr('src').replace('_m_', '_add_'));
			$('tr[id*=devDoc_'+docNo+']').toArray().forEach(function(v, i){
				if(i != 0){
					$(v).hide();
				}
			})
		}
	}
	
	function initSearch(){
		var form = document.createElement('form');
		//$(form).hide();
		form.style.display = 'none';
		$('body').append(form);
		form.action = '/dev/productDevDocList';
		form.method = 'post';
		
		var ownerType = $('input[name=ownerType]').val();
		if(ownerType != null ) appendInput(form, 'ownerType', ownerType);
		
		$(form).submit();

	}
	
	function search(page){
		page = page + "";
		
		var search_productType1 = $('#search_productType1').val();
		var search_productType2 = $('#search_productType2').val();
		var search_productType3 = $('#search_productType3').val();
		var companyCode = $('#companyCode').val();
		var plantCode = $('#plantCode').val();
		var isNew = $('#search_isNew').is(':checked') ? 'Y' : 'N';
		var searchField = $('#searchField').val();
		var searchValue = $('#searchValue').val();
		var ownerType = $('input[name=ownerType]').val();
		var teamCode = '${userUtil:getTeamCode(pageContext.request)}'
		var countPerPage = $('#viewCount').val();
		if( countPerPage == "" ) {
			countPerPage = 10;
		}
		var search_productDocType 	= $("#search_productDocType").val();
		var search_storeDiv 		= $("#search_store_div").val();							// 24.01.18
				
		var form = document.createElement('form');
		//$(form).hide();
		form.style.display = 'none';
		$('body').append(form);
		form.action = '/dev/productDevDocList';
		form.method = 'post';
		
		if(search_productType1 != null ) appendInput(form, 'productType1', search_productType1);
		if(search_productType2 != null ) appendInput(form, 'productType2', search_productType2);
		if(search_productType3 != null ) appendInput(form, 'productType3', search_productType3);
		if(companyCode != null ) appendInput(form, 'companyCode', companyCode);
		if(plantCode != null ) appendInput(form, 'plantCode', plantCode);
		if(isNew != null ) appendInput(form, 'isNew', isNew);
		if(searchField != null ) appendInput(form, 'searchField', searchField);
		if(searchValue != null ) appendInput(form, 'searchValue', searchValue);
		if(ownerType != null ) appendInput(form, 'ownerType', ownerType);
		if(page.length > 0) appendInput(form, 'showPage', page);
		appendInput(form, 'countPerPage', countPerPage)
		appendInput(form, 'teamCode', teamCode);
		if(search_productDocType != null) appendInput(form, "productDocType", search_productDocType);
		if(search_storeDiv != null) appendInput(form,"storeDiv", search_storeDiv); 					// 24.01.18
		
		$(form).submit();
	}
	
	function getSearchParam(){
		var productCategory = $('#productCategory').val();
		var companyCode = $('#companyCode').val();
		var plantCode = $('#plantCode').val();
		var nonHeat = $('input[name=radio_nonHeat]:checked').val();
		var ownerType = $('input[name=ownerType]').val();
		
		var searchField = $('#searchField').val();
		var searchValue = $('#searchValue').val();
		
		var param = "?ownerType="+ownerType;
		
		if(productCategory != '') param += "&productCategory="+productCategory;
		if(companyCode != '')	param += "&companyCode="+companyCode;
		if(plantCode != '')		param += "&plantCode="+plantCode
		if(nonHeat != '')		param += "&nonHeat="+nonHeat;
		if(searchValue != '')	param += "&searchField="+searchField + "&searchValue="+searchValue;
		
		return param;
	}
	
	function devDocValid(){
		var userGrade = "<%=UserUtil.getUserGrade(request)%>";
		
		if($('#devDocForm input[name=productName]').val().length <= 0){
			alert('제품명을 입력해주세요');
			$('#devDocForm input[name=productName]').focus();
			return false;
		}
		
		if($('#dialog_productType1').val().length <= 0){
			alert('제품유형을 선택해주세요');
			return false;
		}
		
		return true;
	}
	
	function saveDevDoc(){
		if(!devDocValid())
			return;
		
		var data = new Object();
		data.productDocType = $("input[name=productDocType]:checked").val();
		data.productName = $('#devDocForm input[name=productName]').val();
		data.launchDate = $('#devDocForm input[name=launchDate]').val();
		data.productType1 = $('#devDocForm select[name=productType1]').val();
		data.productType2 = $('#devDocForm select[name=productType2]').val();
		data.productType3 = $('#devDocForm select[name=productType3]').val();
		data.explanation = $('#devDocForm textarea[name=explanation]').val();
		if(data.productDocType == 1){
			data.etcDisplay = null;
			data.storeDiv = $("#select_store_div").val();
		}else if(data.productDocType == 2){
			data.productCode = $('#devDocForm input[name=productCode]').val() == '' ? '0' : $('#devDocForm input[name=productCode]').val();
			data.etcDisplay = $('#devDocForm select[name=etcDisplay]').val();
			data.storeDiv = null;
		}else{
			data.imNo = $('#devDocForm input[name=imNo]').val() == '' ? '0' : $('#devDocForm input[name=imNo]').val();
			data.productCode = $('#devDocForm input[name=productCode]').val() == '' ? '0' : $('#devDocForm input[name=productCode]').val();
			data.manufacturingNo = $('#devDocForm input[name=manufacturingNo]').val() == '' ? '0' : $('#devDocForm input[name=manufacturingNo]').val();
			data.manufacturingNoSeq = $('#devDocForm input[name=manufacturingNoSeq]').val() == '' ? '0' : $('#devDocForm input[name=manufacturingNoSeq]').val();
			data.sterilization = $('#devDocForm select[name=sterilization]').val();
			data.etcDisplay = $('#devDocForm select[name=etcDisplay]').val();
			data.isNew = $('#devDocForm input[name=isNew]:checked').val();
			data.storeDiv = null;
		}
		console.log(data);
		$.ajax({
			url: '/dev/saveProductDevDoc',
			type: 'post',
			data: data,
			success: function(data){
				if(data){
					alert('문서번호 ' + data + '로 생성되었습니다');
					location.href='/dev/productDevDocList';
				} else {
					alert('생성 실패[1] - 시스템 담당자에게 문의하세요');
				}				
		    },
		    error: function(a,b,c){
		    	alert('생성 실패[2] - 시스템 담당자에게 문의하세요');
		    }
		})
	}
	
	function changeMfgCompanySelect(e){
		$('#plantCode').empty();
		
		var companyCode = e.target.value;
		
		if(companyCode == ''){
			$('#plantCode').append('<option value="">- 공장  -</option>');
			$('#plantCode').prev().text('- 공장 -')
			$('#plantCode').change();
		} else {
			var plantList = '${plantList}';
			
			var selectedPlantList = JSON.parse(plantList).filter(function(v){
				if(v.companyCode == companyCode) {
					return v;
				}
			})
			
			$('#plantCode').append('<option value="">- 공장 -</option>');
			$('#plantCode').prev().text('- 공장 -')
			selectedPlantList.forEach(function(v, i){
				$('#plantCode').append('<option value="'+v.plantCode+'">'+v.plantName+'</option>')
			})
		}
	}
	
	function loadCodeList( groupCode, objectId ) {
		var URL = "../common/codeListAjax";
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
	
	function loadProductType( e, grade, objectId ) {
		var URL = "../common/productTypeListAjax";
		var groupCode = "PRODCAT"+grade;
		var codeValue = e.target.value;
		
		$(e.target).parent().parent().children().toArray().forEach(function(prodTypeDiv, index){
			if(index >= (Number(grade)-1)) $(prodTypeDiv).hide();
		})
		
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
				$("#"+objectId).removeOption(/./);
				$("#"+objectId).addOption("", "전체", false);
				$("#label_"+objectId).html("전체");
				$.each(list, function( index, value ){ //배열-> index, value
					$("#"+objectId).addOption(value.itemCode, value.itemName, false);
				});
				if(list.length > 0) $(e.target).parent().next().show();
			},
			error:function(request, status, errorThrown){
				element.removeOption(/./);
				$("#li_"+element.prop("id")).hide();
				alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
			}			
		});
	}
	
	function getPrdCode(e){
		$('#lab_loading').show();
		$('#prdCodeDiv').hide();
		e.preventDefault();
		
		var productCode = $('#productCode').val();
		if(productCode.length != 6){
			alert('제품코드 6자리를 입력해주세요');
			$('#lab_loading').hide();
			return;
		}
		
		var searchValue = $('#productCode').val();
		$.ajax({
			url: '/data/getMaterialList',
			type: 'post',
			dataType: 'json',
			data: {
				searchValue: searchValue
			},
			success: function(data){
				if(data.length <= 0){
					alert('제품코드와 일치하는 정보를 찾을 수 없습니다.');
					$('#lab_loading').hide();
					return;
				}
				
				$('#productCode_select').empty();
				$('#productCode_select').append()
				$('#productCode_select').append('<option value="">선택</option>')
				data.forEach(function(mat){
					var text = '[' + mat.sapCode + '] ' + mat.name + '(' + mat.company + '-'+mat.plant+')';
					$('#productCode_select').append('<option value="'+mat.imNo+','+mat.sapCode+'">' + text + '</option>')
				})
				
				$('#prdCodeDiv').show();
				$('#lab_loading').hide();
			},
			error: function(a,b,c){
				//console.log(a,b,c)
				alert('제품코드 검색 실패[2] - 시스템 담당자에게 문의하세요');
				$('#lab_loading').hide();
			}
		})
	}
	
	function changePrdCode(e){
		var imNo = e.target.value.split(',')[0];
		var sapCdoe = e.target.value.split(',')[1];
		var name = $('#productCode_select option:selected').text();
		
		var startNdx = $('#productCode_select option:selected').text().indexOf('] ');
		var endNdx = $('#productCode_select option:selected').text().lastIndexOf('(');
		var name = name.substr(startNdx+2, endNdx-(startNdx+2));
		
		$('#productCode').val(sapCdoe);
		$('#imNo').val(imNo);
		$('input[name=productName]').val(name)
	}
	
	function getMfgNo(e){
		$('#lab_loading').show();
		$('#reqDiv').hide();
		e.preventDefault();
		
		var mfgNo = $('input[name=manufacturingNo]').val();
		$.ajax({
			url: '/manufacturingNo/getMfgNoList',
			type: 'post',
			dataType: 'json',
			data: {
				mfgNo: mfgNo
			},
			success: function(data){
				if(data.length <= 0){
					alert('품목제조보고 번호를 찾을 수 없습니다.');
					$('#lab_loading').hide();
					return;
				}
				
				$('#reqNum_select').empty();
				$('#reqNum_select').append('<option value="">선택</option>')
				data.forEach(function(row){
					var text = '[' + row.manufacturingNo + '] ' + row.companyCode + ' ' + row.manufacturingName;
					$('#reqNum_select').append('<option value="'+ row.seq+','+ row.manufacturingNo+'">' + text + '</option>')
				})
				
				$('#reqDiv').show();
				$('#lab_loading').hide();
			},
			error: function(a,b,c){
				//console.log(a,b,c)
				alert('품목제조보고번호 검색 실패[2] - 시스템 담당자에게 문의하세요');
				$('#lab_loading').hide();
			}
		})
	}
	
	function changeRegNum(e){
		var manufacturingNo = e.target.value.split(',')[1];
		var seq = e.target.value.split(',')[0];
		
		$('#reqNum').val(manufacturingNo);
		$('#manufacturingNoSeq').val(seq);
	}
	
	function preView( tbType, tbKey, docNo, docVersion ) {
		var url = "";
		var mode = "";
		if( tbType == 'manufacturingProcessDoc' ) {
			url = "/dev/manufacturingProcessDetailPopup?tbKey="+tbKey+"&tbType="+tbType+"&docNo="+docNo+"&docVersion="+docVersion;
			mode = "width=1100, height=650, left=100, top=50, scrollbars=yes";
		} else if( tbType == 'manufacturingProcessDocForStores'){
			/*점포용 제조공정서*/
			url = "/dev/manufacturingProcessDetailPopupForStores?tbKey="+tbKey+"&tbType="+tbType+"&docNo="+docNo+"&docVersion="+docVersion;
			mode = "width=1100, height=650, left=100, top=50, scrollbars=yes";
		}	
		//window.open(url, "devDocPopup", mode );
		window.open(url, "", mode );
	}
	
	function initDialog(){
		// 제품개발문서 수정
		$('#devDocForm input[name=productName]').val('');
		$('#productCode').val('');
		$('#imNo').val('');
		$('#prdCodeDiv').hide();
		$('#reqNum').val('');
		$('#manufacturingNoSeq').val('');
		$('#reqDiv').hide();
		$('#launchDate').val('')
		
		$('#dialog_productType1 option:first').prop('selected', true);
		$('#dialog_productType1').change();
		$('#dialog_productType2 option:first').prop('selected', true);
		$('#dialog_productType2').change();
		$('#dialog_productType3 option:first').prop('selected', true);
		$('#dialog_productType3').change();
		
		$('#dialog_productType2').parent().hide();
		$('#dialog_productType3').parent().hide();
		
		$('#sterilization option:first').prop('selected', true);
		$('#sterilization').change();
		$('#etcDisplay option:first').prop('selected', true);
		$('#etcDisplay').change();
		
		$('textarea[name=explanation]').val('');
	}
	
	function closeDialogWithClean(dialogId){
		initDialog();
		closeDialog(dialogId);
	}
	
	function onkeyupSearchValue(e){
		if(e.keyCode == 13){
			search('');
		}
	}

	function productDocTypeOnClick(productDocType){
		if(productDocType == 1){
			$("#li_store_div").show();
			$("#li_productCode").hide();
			$("#li_manufacturingNoSeq").hide();
			$("#li_isNew").hide();
			$("#li_etcDisplay").hide();
			$("#li_productType").show();
		}else if(productDocType == 2){
			$("#li_store_div").hide();
			$("#li_productCode").show();
			$("#li_manufacturingNoSeq").hide();
			$("#li_isNew").hide();
			$("#li_productType").show();
			$("#li_etcDisplay").show();
		} else {
			$("#li_store_div").hide();
			$("#li_productCode").show();
			$("#li_manufacturingNoSeq").show();
			$("#li_isNew").show();
			$("#li_etcDisplay").show();
			$("#li_productType").show();
		}
	}
</script>

<div class="wrap_in" id="fixNextTag">
	<span class="path">제품개발문서&nbsp;&nbsp;<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;<a href="#none">SPC 삼립연구소</a></span>
	<section class="type01">
	<!-- 상세 페이지  start-->
		<h2 style="position:relative"><span class="title_s">Product Development Document</span>
			<span class="title">제품개발문서</span>
			<div class="top_btn_box">
				<c:set var="gradeCode" value="${userUtil:getUserGrade(pageContext.request)}" />
				<c:if test='${gradeCode == "2" || gradeCode == "3" || gradeCode == "4" || gradeCode == "5" || userUtil:getIsAdmin(pageContext.request) == "Y"}'>
					<ul><li><button class="btn_circle_red" onclick="openDialog('dialog_create')">&nbsp;</button></li></ul>
				</c:if>
			</div>
		</h2>
		<div class="group01" >
			<div class="title"><!--span class="txt">연구개발시스템 공지사항</span--></div>
			<div class="tab02">
				<ul>
					<!-- 선택됬을경우는 탭 클래스에 select를 넣어주세요 -->
					<!-- 내 제품개발문서 같은경우는 change select 이렇게 change 그대로 두고 한칸 띄고 select 삽입 -->
					<c:choose>
						<c:when test='${userUtil:getIsAdmin(pageContext.request) == "Y"}'>
							<c:if test="${search.ownerType == 'all'}">
								<a href="javascript:changeOwnerType('all')"><li class="select">전체</li></a>
								<c:if test="${userUtil:getTeamCode(pageContext.request) == ''}">
									<a href="javascript:changeOwnerType('team')"><li class=""><%=UserUtil.getDeptCodeName(request)%></li></a>										
								</c:if>
								<c:if test="${userUtil:getTeamCode(pageContext.request) != ''}">
									<a href="javascript:changeOwnerType('team')"><li class=""><%=UserUtil.getDeptCodeName(request)%>(<%=UserUtil.getTeamCodeName(request)%>)</li></a>										
								</c:if>
								<a href="javascript:changeOwnerType('user')"><li class="change">'<%=UserUtil.getUserName(request)%>'님의 제품개발문서</li></a>
							</c:if>
							<c:if test="${search.ownerType == 'team'}">
								<a href="javascript:changeOwnerType('all')"><li class="">전체</li></a>
								<c:if test="${userUtil:getTeamCode(pageContext.request) == ''}">
									<a href="javascript:changeOwnerType('team')"><li class="select"><%=UserUtil.getDeptCodeName(request)%></li></a>										
								</c:if>
								<c:if test="${userUtil:getTeamCode(pageContext.request) != ''}">
									<a href="javascript:changeOwnerType('team')"><li class="select"><%=UserUtil.getDeptCodeName(request)%>(<%=UserUtil.getTeamCodeName(request)%>)</li></a>										
								</c:if>
								<a href="javascript:changeOwnerType('user')"><li class="change">'${SESS_AUTH.userName}'님의 제품개발문서</li></a>
							</c:if>
							<c:if test="${search.ownerType == 'user'}">
								<a href="javascript:changeOwnerType('all')"><li class="">전체</li></a>
								<c:if test="${userUtil:getTeamCode(pageContext.request) == ''}">
									<a href="javascript:changeOwnerType('team')"><li class=""><%=UserUtil.getDeptCodeName(request)%></li></a>										
								</c:if>
								<c:if test="${userUtil:getTeamCode(pageContext.request) != ''}">
									<a href="javascript:changeOwnerType('team')"><li class=""><%=UserUtil.getDeptCodeName(request)%>(<%=UserUtil.getTeamCodeName(request)%>)</li></a>										
								</c:if>
								<a href="javascript:changeOwnerType('user')"><li class="change select">'${SESS_AUTH.userName}'님의 제품개발문서</li></a>
							</c:if>
						</c:when>
						<c:when test='${userUtil:getIsAdmin(pageContext.request) != "Y"}'>
							<c:choose>
								<c:when test='${userUtil:getUserGrade(pageContext.request) == "3" || userUtil:getUserId(pageContext.request) == "cha"}'>
									<c:if test="${search.ownerType == 'all'}">
										<a href="javascript:changeOwnerType('all')"><li class="select">전체</li></a>
										<c:if test="${userUtil:getTeamCode(pageContext.request) == ''}">
											<a href="javascript:changeOwnerType('team')"><li class=""><%=UserUtil.getDeptCodeName(request)%></li></a>										
										</c:if>
										<c:if test="${userUtil:getTeamCode(pageContext.request) != ''}">
											<a href="javascript:changeOwnerType('team')"><li class=""><%=UserUtil.getDeptCodeName(request)%>(<%=UserUtil.getTeamCodeName(request)%>)</li></a>										
										</c:if>
										<a href="javascript:changeOwnerType('user')"><li class="change">'<%=UserUtil.getUserName(request)%>'님의 제품개발문서</li></a>
									</c:if>
									<c:if test="${search.ownerType == 'team'}">
										<a href="javascript:changeOwnerType('all')"><li class="">전체</li></a>
										<c:if test="${userUtil:getTeamCode(pageContext.request) == ''}">
											<a href="javascript:changeOwnerType('team')"><li class="select"><%=UserUtil.getDeptCodeName(request)%></li></a>										
										</c:if>
										<c:if test="${userUtil:getTeamCode(pageContext.request) != ''}">
											<a href="javascript:changeOwnerType('team')"><li class="select"><%=UserUtil.getDeptCodeName(request)%>(<%=UserUtil.getTeamCodeName(request)%>)</li></a>										
										</c:if>
										<a href="javascript:changeOwnerType('user')"><li class="change">'${SESS_AUTH.userName}'님의 제품개발문서</li></a>
									</c:if>
									<c:if test="${search.ownerType == 'user'}">
										<a href="javascript:changeOwnerType('all')"><li class="">전체</li></a>
										<c:if test="${userUtil:getTeamCode(pageContext.request) == ''}">
											<a href="javascript:changeOwnerType('team')"><li class=""><%=UserUtil.getDeptCodeName(request)%></li></a>										
										</c:if>
										<c:if test="${userUtil:getTeamCode(pageContext.request) != ''}">
											<a href="javascript:changeOwnerType('team')"><li class=""><%=UserUtil.getDeptCodeName(request)%>(<%=UserUtil.getTeamCodeName(request)%>)</li></a>										
										</c:if>
										<a href="javascript:changeOwnerType('user')"><li class="change select">'${SESS_AUTH.userName}'님의 제품개발문서</li></a>
									</c:if>
								</c:when>
								<c:when test='${userUtil:getUserGrade(pageContext.request) == "2" && (userUtil:getDeptCode(pageContext.request) == "dept1" || userUtil:getDeptCode(pageContext.request) == "dept2" || userUtil:getDeptCode(pageContext.request) == "dept3" || userUtil:getDeptCode(pageContext.request) == "dept4" || userUtil:getDeptCode(pageContext.request) == "dept5" ||userUtil:getDeptCode(pageContext.request) == "dept6" || userUtil:getDeptCode(pageContext.request) == "dept11" || userUtil:getDeptCode(pageContext.request) == "dept12" || userUtil:getDeptCode(pageContext.request) == "dept13")}'> 
									<c:if test="${search.ownerType == 'team'}">
										<c:if test="${userUtil:getTeamCode(pageContext.request) == ''}">
											<a href="javascript:changeOwnerType('team')"><li class="select"><%=UserUtil.getDeptCodeName(request)%></li></a>										
										</c:if>
										<c:if test="${userUtil:getTeamCode(pageContext.request) != ''}">
											<a href="javascript:changeOwnerType('team')"><li class="select"><%=UserUtil.getDeptCodeName(request)%>(<%=UserUtil.getTeamCodeName(request)%>)</li></a>										
										</c:if>
										<a href="javascript:changeOwnerType('user')"><li class="change">'${SESS_AUTH.userName}'님의 제품개발문서</li></a>
									</c:if>
									<c:if test="${search.ownerType == 'user'}">
										<c:if test="${userUtil:getTeamCode(pageContext.request) == ''}">
											<a href="javascript:changeOwnerType('team')"><li class=""><%=UserUtil.getDeptCodeName(request)%></li></a>										
										</c:if>
										<c:if test="${userUtil:getTeamCode(pageContext.request) != ''}">
											<a href="javascript:changeOwnerType('team')"><li class=""><%=UserUtil.getDeptCodeName(request)%>(<%=UserUtil.getTeamCodeName(request)%>)</li></a>										
										</c:if>
										<a href="javascript:changeOwnerType('user')"><li class="change select">'${SESS_AUTH.userName}'님의 제품개발문서</li></a>
									</c:if>
								</c:when>
								<c:when test='${userUtil:getUserGrade(pageContext.request) != "2" && (userUtil:getDeptCode(pageContext.request) == "dept1" || userUtil:getDeptCode(pageContext.request) == "dept2" || userUtil:getDeptCode(pageContext.request) == "dept3" || userUtil:getDeptCode(pageContext.request) == "dept4" || userUtil:getDeptCode(pageContext.request) == "dept5" ||userUtil:getDeptCode(pageContext.request) == "dept6" || userUtil:getDeptCode(pageContext.request) == "dept11" || userUtil:getDeptCode(pageContext.request) == "dept12" || userUtil:getDeptCode(pageContext.request) == "dept13")}'>
									<%-- <a href="javascript:changeOwnerType('user')"><li class="change select">'${SESS_AUTH.userName}'님의 제품개발문서</li></a> --%>
									<c:if test="${search.ownerType == 'team'}">
										<c:if test="${userUtil:getTeamCode(pageContext.request) == ''}">
											<a href="javascript:changeOwnerType('team')"><li class="select"><%=UserUtil.getDeptCodeName(request)%></li></a>										
										</c:if>
										<c:if test="${userUtil:getTeamCode(pageContext.request) != ''}">
											<a href="javascript:changeOwnerType('team')"><li class="select"><%=UserUtil.getDeptCodeName(request)%>(<%=UserUtil.getTeamCodeName(request)%>)</li></a>										
										</c:if>
										<a href="javascript:changeOwnerType('user')"><li class="change">'${SESS_AUTH.userName}'님의 제품개발문서</li></a>
									</c:if>
									<c:if test="${search.ownerType == 'user'}">
										<c:if test="${userUtil:getTeamCode(pageContext.request) == ''}">
											<a href="javascript:changeOwnerType('team')"><li class=""><%=UserUtil.getDeptCodeName(request)%></li></a>										
										</c:if>
										<c:if test="${userUtil:getTeamCode(pageContext.request) != ''}">
											<a href="javascript:changeOwnerType('team')"><li class=""><%=UserUtil.getDeptCodeName(request)%>(<%=UserUtil.getTeamCodeName(request)%>)</li></a>										
										</c:if>
										<a href="javascript:changeOwnerType('user')"><li class="change select">'${SESS_AUTH.userName}'님의 제품개발문서</li></a>
									</c:if>
								</c:when>
								<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept7" || userUtil:getDeptCode(pageContext.request) == "dept8" || userUtil:getDeptCode(pageContext.request) == "dept9"}'>
									<c:if test="${search.ownerType == 'all'}">
										<a href="javascript:changeOwnerType('all')"><li class="select">전체</li></a>
										<a href="javascript:changeOwnerType('user')"><li class="change">'<%=UserUtil.getUserName(request)%>'님의 제품개발문서</li></a>
									</c:if>
									<c:if test="${search.ownerType == 'user'}">
										<a href="javascript:changeOwnerType('all')"><li class="">전체</li></a>
										<a href="javascript:changeOwnerType('user')"><li class="change select">'${SESS_AUTH.userName}'님의 제품개발문서</li></a>
									</c:if>
								</c:when>
								<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept10"}'>
									<c:if test="${search.ownerType == 'all'}">
										<a href="javascript:changeOwnerType('all')"><li class="select">전체</li></a>										
									</c:if>
								</c:when>							
							</c:choose>
						</c:when>
					</c:choose>					
				</ul>
			</div>
			
			<div class="search_box">
				<form id="searchForm" method="post" action="/dev/productDevDocList">
					<input type="hidden" name="ownerType" value="${search.ownerType == '' ? 'user' : search.ownerType}">
					<ul style="border-top: none;">
						<li>
							<dt>제품유형</dt>
							<dd>
								<div class="selectbox" style="width:100px;">
									<label for="search_productType1" id="label_search_productType1"> 선택</label>
									<select id="search_productType1" name="productType1" onChange="loadProductType(event,'2','search_productType2')">
									</select>
								</div>
								<div class="selectbox ml5" style="width:100px;display:none">
									<label for="search_productType2" id="label_search_productType2"> 선택</label>
									<select id="search_productType2" name="productType2" onChange="loadProductType(event,'3','search_productType3')">
									</select>
								</div>
								<div class="selectbox ml5" style="width:100px;display:none">
									<label for="search_productType3" id="label_search_productType3"> 선택</label>
									<select id="search_productType3" name="productType3">
									</select>
								</div>
							</dd>
						</li>
						<li>
							<dt>공장</dt>
							<dd>
								<div class="selectbox" style="width: 100px;">
									<label for="companyCode">- 회사  -</label>
									<select id="companyCode" name="companyCode" onchange="changeMfgCompanySelect(event)">
		                            	<option value="" selected>- 회사  -</option>
		                                <c:forEach items="${companyList}" var="company" varStatus="status">
		                                	<option value="${company.companyCode}">${company.companyName}</option>
		                                </c:forEach>
		                            </select>
								</div>
								<div class="selectbox ml5" style="width: 163px;">
									<label for="plantCode">- 공장  -</label>
		                            <select id="plantCode" name="plantCode">
		                            	<option value="" selected></option>
		                            </select>
								</div>
							</dd>
						</li>
						<!-- 
						<li>
							<dt>가열여부</dt>
							<dd>
								<input type="radio" id="heat_all" name="nonHeat" value="" checked /><label for="heat_all"><span></span>전체</label>
								<input type="radio" id="heat_y" name="nonHeat" value="0" /><label for="heat_y"><span></span>가열</label>
								<input type="radio" id="heat_x" name="nonHeat" value="1"><label for="heat_x"><span></span>비가열</label>
							</dd>
						</li>
						 -->
						<li>
							<dt>키워드</dt>
							<dd>
								<div class="selectbox" style="width: 100px;">
									<label for="searchField">문서번호</label>
									<select id="searchField" name="searchField">
										<option value="docNo" selected>문서번호</option>
										<option value="manufacturingNo">품목제조보고번호</option>
										<option value="productCode">제품코드</option>
										<option value="productName">제품명</option>
										<option value="explanation">제품설명</option>
										<option value="userName">작성자</option>
									</select>
								</div>
								<input id="searchValue" name="searchValue" type="text" style="width: 165px; margin-left: 5px;" onkeyup="onkeyupSearchValue(event)"/>
								<!-- 
								<button class="btn_small_search ml5">검색</button>
								 -->
							</dd>
						</li>
						<li>
							<dt>표시수</dt>
							<dd>
								<div class="selectbox" style="width:100px;">  
									<label for="viewCount" id="viewCount_label">${productDevDocList.page.countPerPage}</label> 
									<select name="viewCount" id="viewCount">		
										<option value="10" ${productDevDocList.page.countPerPage == 10 ? 'selected' : ''}>10</option>
										<option value="20" ${productDevDocList.page.countPerPage == 20 ? 'selected' : ''}>20</option>
										<option value="50" ${productDevDocList.page.countPerPage == 50 ? 'selected' : ''}>50</option>
										<option value="100" ${productDevDocList.page.countPerPage == 100 ? 'selected' : ''}>100</option>
									</select>
								</div>
							</dd>
						</li>
						<li>
							<dt>신제품</dt>
							<dd style="padding-top: 4px;">
								<input id="search_isNew" name="isNew" type="checkbox" value="Y" ${search.isNew == 'Y' ? 'checked' : '' }/>
								<label for="search_isNew" style="vertical-align: middle;"><span></span>관리대상</label>
							</dd>
						</li>
						<li>
							<dt>유형</dt>
							<dd>
								<div class="selectbox" style="width:130px;">
									<label for="search_productDocType" > 선택</label>
									<select id="search_productDocType" name="search_productDocType">
										<option value="">전체</option>
										<option value="0">공장</option>
										<option value="1">점포</option>
										<option value="2">OEM</option>
									</select>
								</div>
								<div class="selectbox ml5 storeDivBox" style="width: 163px;">
									<label for="search_store_div">- 점포  -</label>
									<select id="search_store_div" name="storeDiv">
										<option value="" selected></option>
									</select>
								</div>
							</dd>
						</li>
					</ul>
				</form>
				<div class="fr pt5 pb10">
					<button class="btn_con_search" onclick="search('')"><img src="/resources/images/btn_icon_search.png"style="vertical-align: middle;" /> 검색 </button>
					<button class="btn_con_search" onclick="initSearch()"><img src="/resources/images/btn_icon_refresh.png"style="vertical-align: middle;" /> 검색 초기화 </button>
				</div>
			</div>
			<div class="main_tbl">
				<table class="tbl01">
					<colgroup>
					<col width="45px">
					<col width="45px">
					<col width="45px">
					<col width="8%">
					<col width="8%">
					<col />
					<col width="15%">
					<col width="9%">
					<col width="10%">
					<col width="6%">
					<col width="8%">
					<col width="8%">
				
					</colgroup>
					<thead>
					<tr>
						<th>&nbsp;</th>
						<th>유형</th>
						<th>버전</th>
						<th>번호</th>
						<th>제품코드</th>
						<th>제품명</th>
						<th>품목제조보고명</th>
						<th>작업상태</th>
						<th>문서첨부</th>
						<th>작성자</th>
						<th>출시일</th>
						<th>문서설정</th>
					<tr>
					</thead>
					<c:if test="${productDevDocList.pagenatedList == null }">
						<tr>
							<td colspan="12" align="center">자재 조회 결과가 없습니다.</td>
						</tr>
					</c:if>
					<c:if test="${productDevDocList.pagenatedList != null }">
					<tbody>
						<c:forEach items="${productDevDocList.pagenatedList}" var="devDoc" varStatus="status">
							<c:set var="isLatest" value="${devDoc.docNo != prevDocNo}"/>
							<c:set var="display" value="${devDoc.docNo != prevDocNo ? 'display' : 'none'}"/>
							<c:set var="hasChild" value="${(devDoc.docVersion != 1 && isLatest)}"/>
							<c:set var="isVisible" value="${devDoc.isClose != 0 ? 'm_visible' : ''}"/>
							
							<c:if test="${devDoc.isClose == 0}">
								<c:if test="${devDoc.state1cnt > 0}">
									<c:set var="docState" value="결재완료"/>
								</c:if>
								<c:if test="${devDoc.state4cnt > 0}">
									<c:set var="docState" value="제품출시"/>
								</c:if>
								<c:if test="${devDoc.state4cnt == 0 && devDoc.state1cnt == 0}">
									<c:set var="docState" value="진행중"/>
								</c:if>
							</c:if>
							<c:if test="${devDoc.isClose == 1}">
								<c:set var="docState" value="제품중단"/>
							</c:if>
							<c:if test="${devDoc.isClose == 2}">
								<c:set var="docState" value="보류"/>
							</c:if>
							
							<c:if test="${isLatest}">
								<tr id="devDoc_${devDoc.docNo}_${devDoc.docVersion}" class="${isVisible}">
									<td>
										<c:if test="${hasChild == true }">
											<img src="/resources/images/img_add_doc.png" style="cursor: pointer;" onclick="showChildVersion(this)"/>
										</c:if>
									</td>
									<td>
										<c:choose>
											<c:when test="${devDoc.productDocType == '0'}">공장</c:when>
											<c:when test="${devDoc.productDocType == '1'}">점포</c:when>
											<c:when test="${devDoc.productDocType == '2'}">OEM</c:when>
											<c:otherwise>공장</c:otherwise>
										</c:choose>
									</td>
									<td><span class="${hasChild ? 'font19' : ''}">${devDoc.docVersion}</span></td>
									<td><a href="#none" onclick="readProductDevDoc(${devDoc.docNo},${devDoc.docVersion})">${devDoc.docNo}</a></td>
									<td>${devDoc.productCode == '0' ? '' : devDoc.productCode}</td>
									<td><div class="ellipsis_txt tgnl"><a href="#none" onclick="readProductDevDoc(${devDoc.docNo},${devDoc.docVersion})">${devDoc.productName}</a></div></td>
									<td>${devDoc.manufacturingName}</td>
									<%-- <td>${devDoc.isClose == '1' ? '중단' : devDoc.isClose == '2' ? '보류' : '진행(생산)중'}</td> --%>
									<td>${docState}</td>
									<td>
										<ul class="list_ul2">
											<%-- 
											<li class="${devDoc.draftCnt == 0 ? 's01' : 's02'}">포장지</li>
											<li class="${devDoc.imageCnt == 0 ? 's01' : 's02'}">제품</li>
											<li class="${devDoc.trialCnt == 0 ? 's01' : 's02'}">시생산</li>
											 --%>
											<li class="${devDoc.draftCnt == 0 ? 's01' : 's02'}">포</li>
											<li class="${devDoc.imageCnt == 0 ? 's01' : 's02'}">제</li>
											<li class="${devDoc.trialCnt == 0 ? 's01' : 's02'}">시</li>
										</ul>
									</td>
									<td>${devDoc.userName}</td>
									<td>${fn:substring(devDoc.launchDate, 0, 10)}</td>
									<td>
										<ul class="list_ul">
											<c:if test="${devDoc.dNo != null}">
												<c:choose>
													<c:when test="${userUtil:getTeamCode(pageContext.request) == '6' && userUtil:getUserGrade(pageContext.request) != '6' }"></c:when>
													<c:otherwise>
														<c:choose>
															<c:when test="${devDoc.productDocType == '1'}">
																<li><button class="btn_doc" onClick="preView('manufacturingProcessDocForStores', '${devDoc.dNo}', '${devDoc.docNo}', '${devDoc.docVersion}')"><img src="/resources/images/icon_doc01.png"> 미리보기</button></li>
															</c:when>
															<c:otherwise>
																<li><button class="btn_doc" onClick="preView('manufacturingProcessDoc', '${devDoc.dNo}', '${devDoc.docNo}', '${devDoc.docVersion}')"><img src="/resources/images/icon_doc01.png"> 미리보기</button></li>
															</c:otherwise>
														</c:choose>
													</c:otherwise>
												</c:choose>
											</c:if>
											<!-- <li><button class="btn_doc"><img src="/resources/images/icon_doc02.png"> 복사</button></li> -->
										</ul>
									</td>
								</tr>
							</c:if>
							<c:if test="${!isLatest}">
								<tr id="devDoc_${devDoc.docNo}_${devDoc.docVersion}" class="m_version ${isVisible}" style="display: none">
									<td></td>
									<td>
										<c:choose>
											<c:when test="${devDoc.productDocType == '0'}">공장</c:when>
											<c:when test="${devDoc.productDocType == '1'}">점포</c:when>
											<c:when test="${devDoc.productDocType == '2'}">OEM</c:when>
											<c:otherwise>공장</c:otherwise>
										</c:choose>
									</td>
									<td>${devDoc.docVersion}</td>
									<td>${devDoc.docNo}</td>
									<td>${devDoc.productCode == '0' ? '' : devDoc.productCode}</td>
									<td><div class="ellipsis_txt tgnl"><a href="#none" onclick="readProductDevDoc(${devDoc.docNo},${devDoc.docVersion})">${devDoc.productName}</a></div></td>
									<td>${devDoc.manufacturingName}</td>
									<td>${docState}</td>
									<td>
										<ul class="list_ul2">
											<%-- 
											<li class="${devDoc.draftCnt == 0 ? 's01' : 's02'}">포장지</li>
											<li class="${devDoc.imageCnt == 0 ? 's01' : 's02'}">제품</li>
											<li class="${devDoc.trialCnt == 0 ? 's01' : 's02'}">시생산</li>
											 --%>
											<li class="${devDoc.draftCnt == 0 ? 's01' : 's02'}">포</li>
											<li class="${devDoc.imageCnt == 0 ? 's01' : 's02'}">제</li>
											<li class="${devDoc.trialCnt == 0 ? 's01' : 's02'}">시</li>
										</ul>
									</td>
									<td>${devDoc.userName}</td>
									<td>${fn:substring(devDoc.launchDate, 0, 10)}</td>
									<td>
										<ul class="list_ul">
											<c:choose>
												<c:when test="${userUtil:getTeamCode(pageContext.request) == '6' && userUtil:getUserGrade(pageContext.request) != '6' }"></c:when>
												<c:otherwise>
													<c:choose>
														<c:when test="${devDoc.productDocType == '1'}">
															<li><button class="btn_doc" onClick="preView('manufacturingProcessDocForStores', '${devDoc.dNo}', '${devDoc.docNo}', '${devDoc.docVersion}')"><img src="/resources/images/icon_doc01.png"> 미리보기</button></li>
														</c:when>
														<c:otherwise>
															<li><button class="btn_doc" onClick="preView('manufacturingProcessDoc', '${devDoc.dNo}', '${devDoc.docNo}', '${devDoc.docVersion}')"><img src="/resources/images/icon_doc01.png"> 미리보기</button></li>
														</c:otherwise>
													</c:choose>
												</c:otherwise>
											</c:choose>
											<!-- <li><button class="btn_doc"><img src="/resources/images/icon_doc02.png"> 복사</button></li> -->
										</ul>
									</td>
								</tr>
							</c:if>
							<c:set var="prevDocNo" value="${devDoc.docNo}"/>
						</c:forEach>
					</tbody>
					</c:if>
				</table>
				<div class="page_navi mt10">
					<ul>
						<c:if test="${productDevDocList.page.totalCount != 0}">
							<c:if test="${productDevDocList.page.hasPrev() == true}">
								<li>
									<a href="#none" class="btn btn_prev1" onclick="changePage(${productDevDocList.page.pageBlock[0]-1})">Prev</a>
								</li>	
							</c:if>
							<c:forEach items="${productDevDocList.page.pageBlock}" var="page">
								<c:if test="${page == productDevDocList.page.showPage}">
									<li class="select">
										<a href="#none" class="btn btn_prev1" onclick="">${page}</a>
									</li>
								</c:if>
								<c:if test="${page != productDevDocList.page.showPage}">
									<li>
										<a href="#none" class="btn btn_prev1" onclick="changePage(${page})">${page}</a>
									</li>
								</c:if>
							</c:forEach>
							<c:if test="${productDevDocList.page.hasNext() != null && productDevDocList.page.hasNext() == true}">
								<li>
									<a href="#none" class="btn btn_next3" onclick="changePage(${productDevDocList.page.pageBlock[4]+1})">Next</a>
								</li>	
							</c:if>
						</c:if>
					</ul>
				</div>
			</div>
			<div class="btn_box_con">
				<c:set var="gradeCode" value="${userUtil:getUserGrade(pageContext.request)}" />
				<c:if test='${gradeCode == "2" || gradeCode == "3" || gradeCode == "4" || gradeCode == "5" || userUtil:getIsAdmin(pageContext.request) == "Y"}'>
					<button class="btn_admin_red" onclick="openDialog('dialog_create')">제품 생성</button>
				</c:if>	
			</div>
			<hr class="con_mode" />
			<!-- 신규 추가 꼭 데려갈것 !-->
		</div>
	</section>
</div>


<!-- 제품개발문서 생성레이어 start-->
<div class="white_content" id="dialog_create">
	<div class="modal positionCenter" style="width: 700px; height: 600px;">
		<h5 style="position: relative">
			<span class="title">제품개발문서 생성</span>
			<div class="top_btn_box">
				<ul>
					<li>
						<button class="btn_madal_close" onClick="closeDialogWithClean('dialog_create')"></button>
					</li>
				</ul>
			</div>
		</h5>
		<div class="list_detail">
			<form id="devDocForm">
				<ul>
					<li class="pt10">
						<dt>유형</dt>
						<dd>
							<input type="radio" name="productDocType" id="productDocType0" value="0" onclick="productDocTypeOnClick(0)" checked="checked"/><label for="productDocType0"><span></span>공장</label>
							<input type="radio" name="productDocType" id="productDocType1" value="1" onclick="productDocTypeOnClick(1)" /><label for="productDocType1"><span></span>점포</label>
							<input type="radio" name="productDocType" id="productDocType2" value="2" onclick="productDocTypeOnClick(2)" /><label for="productDocType2"><span></span>OEM</label>
						</dd>
					</li>
					<li id="li_store_div" style="display: none">
						<dt>구분</dt>
						<dd>
							<div class="selectbox req" style="width:130px;">
								<label for="select_store_div" id="label_store_div"> 선택</label>
								<select id="select_store_div" name="storeDiv">
									<!-- 
									<option value="에그슬럿">에그슬럿</option>
									<option value="시티델리">시티델리</option>
									<option value="BK(베이커리팩토리)">BF(베이커리팩토리)</option>
									<option value="TD(트레이더스)">TD(트레이더스)</option>
									<option value="BK(전채널)">BK(전채널)</option>
									 -->
								</select>
							</div>
						</dd>
					</li>
					<li>
						<dt>제품명</dt>
						<dd>
							<input name="productName" type="text" class="req" style="width: 302px;" placeholder="입력필수" />
						</dd>
					</li>
					<li id="li_productCode">
						<dt>제품코드</dt>
						<dd>
							<input class="" id="productCode" name="productCode" onkeyup="clearNoNum(this)" type="text" style="width: 150px; float: left" />
							<input id="imNo" type="hidden" name="imNo">
							<button class="btn_small_search ml5" onclick="getPrdCode(event)" style="float: left">검색</button>
							<div id="prdCodeDiv" class="selectbox req ml5" style="width:200px; position: relative; display:none;">  
								<select id="productCode_select" name="productCode" onchange="changePrdCode(event)">
									<option value="">선택</option>
								</select>
								<label for="productCode_select">선택</label> 
							</div>
						</dd>
					</li>
					<li id="li_manufacturingNoSeq">
						<dt>품목제조보고번호</dt>
						<dd>
							<input class="" id="reqNum" name="manufacturingNo" type="text" style="width: 150px; float: left" />
							<input id="manufacturingNoSeq" type="hidden" name="manufacturingNoSeq">
							<button class="btn_small_search ml5" onclick="getMfgNo(event)" style="float: left">검색</button>
							<div id="reqDiv" class="selectbox req ml5" style="width:200px; position: relative; display:none; ">  
								<select id="reqNum_select" name="reqNum" onchange="changeRegNum(event)">
									<option value="">선택</option>
								</select>
								<label for="reqNum_select">선택</label> 
							</div>
						</dd>
					</li>
					<li id="li_isNew">
						<dt>신제품</dt>
						<dd>
							<input id="isNew" name="isNew" type="checkbox" value="Y"/>
							<label for="isNew" style="vertical-align: middle;"><span></span>관리대상</label>
						</dd>
					</li>
					<li>
						<dt>출시일</dt>
						<dd>
							<input id="launchDate" name="launchDate" type="text" style="width: 170px;" readonly="readonly" value="">
						</dd>
					</li>
					<li id="li_productType">
						<dt>제품유형</dt>
						<dd>
							<div class="selectbox req" style="width:130px;">
								<label for="dialog_productType1" id="label_dialog_productType1"> 선택</label>
								<select id="dialog_productType1" name="productType1" onChange="loadProductType(event,'2','dialog_productType2')">
								</select>
							</div>
							<div class="selectbox req ml5" style="width:130px;display:none">
								<label for="dialog_productType2" id="label_dialog_productType2"> 선택</label>
								<select id="dialog_productType2" name="productType2" onChange="loadProductType(event,'3','dialog_productType3')">
								</select>
							</div>
							<div class="selectbox req ml5" style="width:130px;display:none">
								<label for="dialog_productType3" id="label_dialog_productType3"> 선택</label>
								<select id="dialog_productType3" name="productType3">
								</select>
							</div>
						</dd>
					</li>
					<li id="li_etcDisplay">
						<dt>기타</dt>
						<dd>
							<div class="selectbox" style="width:130px;">  
								<label for="sterilization" id="label_sterilization">선택</label> 
								<select id="sterilization" name="sterilization">
								</select>
							</div>
							<div class="selectbox ml5" style="width:250px;">  
								<label for="etcDisplay" id="label_etcDisplay">선택</label> 
								<select id="etcDisplay" name="etcDisplay">
								</select>
							</div>
						</dd>
					</li>
					<li>
						<dt>제품설명</dt>
						<dd class="pr20 pb20">
							<textarea name="explanation" style="width: 100%; height: 100px"></textarea>
						</dd>
					</li>
				</ul>
			</form>
		</div>
		<div class="btn_box_con">
			<button class="btn_admin_red" onclick="saveDevDoc()">생성</button>
			<button class="btn_admin_gray" onClick="closeDialogWithClean('dialog_create')">생성 취소</button>
		</div>
	</div>
</div>
<!-- 제품개발문서 생성레이어 close-->