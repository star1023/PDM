<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page import="kr.co.aspn.util.*" %>
<%@ taglib prefix="userUtil" uri="/WEB-INF/tld/userUtil.tld"%>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ taglib prefix="dateUtil" uri="/WEB-INF/tld/dateUtil.tld"%>

<link rel="stylesheet" href="/resources/CLEditor/jquery.cleditor.css?param=1" />
<script type="text/javascript" src="/resources/CLEditor/jquery.cleditor.min.js?param=1"></script>
<link href="/resources/js/jquery.auto-complete.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="/resources/js/jquery.auto-complete.js"></script>

<title>제품설계서>설계서 목록</title>

<style type="text/css">
.readOnly {
	background-color: #ddd
}
.positionCenter{
	position: absolute;
	transform: translate(-50%, -50%);
}
#popupBody tr{
	background: url('');
}
</style>

<script type="text/javascript">
	
	var tbType = "productDesignDocDetail";
	
	$(document).ready(function(){
		loadCompany('companyCode');
		loadCodeList( "PRODCAT1", "productType1" );
		loadCodeList( "STERILIZATION", "sterilization" );
		loadCodeList( "ETCDISPLAY", "etcDisplay" );
		
		loadList(1);
		
		
		/* 제품설계서 수정레이어 초기값 설정 START */
		var companyCode = '${designDocInfo.companyCode}';
		var plant = '${designDocInfo.plant}';
		if(companyCode.length > 0){
			$('#companyCode option[value='+companyCode+']').prop('selected', true)
			$('#companyCode option[value='+companyCode+']').trigger('change');
		}
		if(plant.length > 0){
			$('#plant option[value='+plant+']').prop('selected', true)
			$('#plant option[value='+plant+']').trigger('change');
		}
		
		var productType1 = '${designDocInfo.productType1}';
		var productType2 = '${designDocInfo.productType2}';
		var productType3 = '${designDocInfo.productType3}';
		if(productType1.length > 0){
			$('#productType1 option[value='+productType1+']').prop('selected', true)
			$('#productType1 option[value='+productType1+']').trigger('change');
		}
		if(productType2.length > 0){
			$('#productType2 option[value='+productType2+']').prop('selected', true)
			$('#productType2 option[value='+productType2+']').trigger('change');
		}
		if(productType3.length > 0){
			$('#productType3 option[value='+productType3+']').prop('selected', true)
			$('#productType3 option[value='+productType3+']').trigger('change');
		}
		
		var sterilization = '${designDocInfo.sterilization}';
		var etcDisplay = '${designDocInfo.etcDisplay}';
		if(sterilization.length > 0){
			$('#sterilization option[value='+sterilization+']').prop('selected', true)
			$('#sterilization option[value='+sterilization+']').trigger('change');
		}
		if(etcDisplay.length > 0){
			$('#etcDisplay option[value='+etcDisplay+']').prop('selected', true)
			$('#etcDisplay option[value='+etcDisplay+']').trigger('change');
		}
		/* 제품설계서 수정레이어 초기값 설정 END */
	});
	
	function readItemDetail(pNo, pdNo, pdaNo){
		var form = document.createElement('form');
		$('body').append(form);
		$(form).css('diplay', 'none');
		
		form.action = '/design/productDesignDocDetailView';
		form.style.display = 'none';
		form.target = '_blank';
		form.method = 'post';
		
		appendInput(form, 'pNo', pNo)
		appendInput(form, 'pdNo', pdNo)
		appendInput(form, 'pdaNo', pdaNo)
		
		$(form).submit();
	}
	
	function popupItemDetail(pNo, pdNo, pdaNo){
		var url = "/design/productDesignDocDetailViewPopup?pNo="+pNo+"&pdNo="+pdNo;
		var mode = "width=1100, height=650, left=100, top=50, scrollbars=yes";
		window.open(url, "", mode );
	}
	
	function productDesignItemCreateForm(pNo){
		$('#createForm').submit();
	}
	
	function copyProductDesignDocDetail(pNo, pdNo){
		if(confirm("문서를 복사하시겠습니까?")){
			$('#lab_loading').show();
			$.ajax({
			    url: '/design/copyProductDesignDocDetail',
			    type: 'post',
			    data: {pNo: pNo, pdNo: pdNo},
			    success: function(data){
			    	if(data == 'S'){
				    	alert('문서 생성 완료');
				    	reload();
			    	} else {
			    		$('#lab_loading').hide();
			    		return alert("복사 오류[1]");
			    	}
			    },
			    error: function(a,b,c){
			    	//console.log(a,b,c);
			    	$('#lab_loading').hide();
			    	return alert("복사 오류[2]");
			    }
			})
		}
	}
	
	function reload(){
		var pNo = ${designDocInfo.pNo};
		var form = document.createElement('form');
		$('body').append(form);
		$(form).css('diplay', 'none');
		form.action = '/design/productDesignDocDetail';
		form.style.display = 'none';
		//form.target = '_blank';
		form.method = 'post';
		
		appendInput(form, 'pNo', pNo)
		
		$(form).submit();
	}
	
	function deleteProductDesignDoc(pNo){
		if(confirm('보고 계신 제품설계서를 정말 삭제하시겠습니까?')){
			$.ajax({
				url: '/design/deleteProductDesignDoc',
				type: 'post',
				data: {
					pNo: pNo
				},
				success: function(data){
					if(data == 'S'){
						alert('정상적으로 삭제되었습니다');
						location.href='/design/productDesignDocList';
					} else {
						return alert('문서 삭제 오류[1]');
					}
				},
				error: function(a,b,c){
					//console.log(a,b,c)
					return alert('문서 삭제 오류[2]');
				}
			})
		}
	}
	
	function editProductDesignDocDetail(pNo, pdNo){
		var form = document.createElement('form');
		$('body').append(form);
		$(form).css('diplay', 'none');
		form.action = '/design/productDesignDocDetailEdit';
		form.style.display = 'none';
		form.method = 'post';
		
		appendInput(form, 'pNo', pNo);
		appendInput(form, 'pdNo', pdNo);
		
		$(form).submit();
	}
	
	function deleteProductDesignDocDetail(pNo, pdNo){
		if(confirm('설계서[문서번호: '+pdNo+']를 정말 삭제하시겠습니까?')){
			$.ajax({
				url: '/design/deleteProductDesignDocDetail',
				type: 'post',
				data: {
					pNo: pNo,
					pdNo: pdNo
				},
				success: function(data){
					if(data == 'S'){
						alert('정상적으로 삭제되었습니다');
						reload();
					} else {
						return alert('문서 삭제 오류[1]');
					}
				},
				error: function(a,b,c){
					//console.log(a,b,c)
					return alert('문서 삭제 오류[2]');
				}
			})
		}
	}
	
	function updateValid(){
		if($('#productType1').val().trim().length <= 0){
			alert('제품유형을 선택하세요');
			return false;
		}
		
		if($('#productName').val().trim().length <= 0){
			alert('제품명을 입력하세요');
			return false;
		}
		
		if($('#companyCode').val().trim().length <= 0){
			alert('공장을 선택하세요');
			return false;
		}
		
		if($('#plant').val().trim().length <= 0){
			alert('공장을 선택하세요');
			return false;
		}
		
		return true;
	}
	
	function updateProductDesignDoc(){
		if(updateValid()){
			var formData = $('#productDesignUpdateForm').serialize();
			$.ajax({
				url: '/design/updateProductDesignDoc',
				type: 'POST',
				data: formData,
				success: function(data){
					if(data > 0){
						alert('저장되었습니다.');
						reload();
					} else {
						return alert('제품설계서 수정 오류[1]');
					}
					
				},
				error: function(){
					return alert('제품설계서 수정 오류[2]');
				}
			});
		} else {
			return;
		}
	}
	
	function changeMfgCompanySelect(e){
		$('#plant').empty();
		
		var companyCode = e.target.value;
		
		if(companyCode == ''){
			$('#plant').append('<option value="">공장상세선택</option>');
			$('#plant').next().text('공장상세선택')
			$('#plant').change();
		} else {
			var plantList = '${plantList}';
			
			var selectedPlantList = JSON.parse(plantList).filter(function(v){
				if(v.companyCode == companyCode) {
					return v;
				}
			})
			
			$('#plant').append('<option value="">공장상세선택</option>');
			$('#plant').next().text('공장상세선택')
			selectedPlantList.forEach(function(v, i){
				$('#plant').append('<option value="'+v.plantCode+'">'+v.plantName+'</option>')
			})
		}
	}
	
	function goList(){
		var page = JSON.parse('${page}')
		var search = JSON.parse('${search}')
		
		var searchField = search.searchField;
		var searchValue = search.searchValue;
		var showPage = page.showPage;
		var ownerType = search.ownerType;
		
		var form = document.createElement('form');
		$('body').append(form);
		$(form).css('diplay', 'none');
		form.action = '/design/productDesignDocList';
		form.method = 'post';
		/* 
		appendInput(form, 'searchField', searchField)
		appendInput(form, 'searchValue', searchValue)
		
		if(page.length > 0) appendInput(form, 'showPage', showPage)
		if(ownerType.length > 0) appendInput(form, 'ownerType', ownerType)
		 */
		$(form).submit();
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
	
	function loadProductType( grade, objectId ) {
		var URL = "../common/productTypeListAjax";
		var groupCode = "PRODCAT"+grade;
		var codeValue = "";
		if( grade == '2' ) {
			codeValue = $("#productType1").selectedValues()[0]+"-";
			$("#li_productType2").hide();
			$("#li_productType3").hide();
		} else if( grade == '3' ) {
			codeValue = $("#productType2").selectedValues()[0]+"-";
			$("#li_productType3").hide();
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
				$("#"+objectId).removeOption(/./);
				$("#"+objectId).addOption("", "전체", false);
				$("#label_"+objectId).html("전체");
				$.each(list, function( index, value ){ //배열-> index, value
					$("#"+objectId).addOption(value.itemCode, value.itemName, false);
				});
				if( list.length > 0 ) {
					$("#li_"+objectId).show();
				} else {
					$("#li_"+objectId).hide();
				}
			},
			error:function(request, status, errorThrown){
				element.removeOption(/./);
				$("#li_"+element.prop("id")).hide();
				alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
			}			
		});
	}
	
	function companyChange(companySelectBoxId, selectBoxId) {
		var URL = "../common/plantListAjax";
		$.ajax({
			type:"POST",
			url:URL,
			data:{
				"companyCode" : $("#"+companySelectBoxId).selectedValues()[0]
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
				$('#'+selectBoxId).parent().show();
			},
			error:function(request, status, errorThrown){
					alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
			}			
		});
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
	
	function openCopyDialog(){
		searchCopyDialog();
		openDialog('dialog_copy')
	}
	
	function closeCopyPopup(){
		closeDialog('dialog_copy');
		$('#searchValue').val('');
	}
	
	function searchCopyDialog(pageType){
		var pageType = pageType;
		
		if(!pageType)
			$('#copyPopupPage').val(1)
			
		if(pageType == 'nextPage'){
			var totalCount = Number($('#popupCount').text());
			var maxPage = totalCount/10+1;
			var nextPage = Number($('#copyPopupPage').val())+1;
			
			if(nextPage >= maxPage) return; //nextPage = maxPage
			
			$('#copyPopupPage').val(nextPage);
		}
			
		if(pageType == 'prevPage'){
			var prevPage = Number($('#copyPopupPage').val())-1;
			if(prevPage <= 0) return; //prevPage = 1;
			
			$('#copyPopupPage').val(prevPage);
		}
		
		$('#lab_loading').show();
		$.ajax({
			url: '/design/getPagenatedPopupList',
			type: 'post',
			dataType: 'json',
			data: {
				searchField: 'productName',
				searchValue: $('#searchValue').val(),
				showPage: $('#copyPopupPage').val(),
				countPerPage: 10,
				ownerType: 'admin'
			},
			success: function(data){
				$('#popupCount').text(data.page.totalCount);
				if(data.pagenatedList.length > 0){
					$('#popupBody tr').empty();
					
					data.pagenatedList.forEach(function(v, i, arr){
						var row = '<tr onclick="copyProductDesignDocDetail(${designDocInfo.pNo} , '+v.pdNo+')">'
							+'<td>'+v.pNo+'</td>'
							+'<td>'+v.pdNo+'</td>'
							+'<td>'+v.productName+'</td>'
							+'</tr>';
						$('#popupBody').append(row);
					})
				} else {
					$('#popupBody tr').empty();
					$('#popupBody').append('<tr><td colspan="3">결과가 존재하지 않습니다. 다시 검색해주세요</td></tr>');
				}
				
				var isFirst = $('#copyPopupPage').val() == 1 ? true : false;
				var isLast = parseInt(data.page.totalCount/10+1) == Number($('#copyPopupPage').val()) ? true : false;
				
				if(isFirst){
					$('#copyNextPrevDiv').children('button:first').attr('class', 'btn_code_left01');
				} else {
					$('#copyNextPrevDiv').children('button:first').attr('class', 'btn_code_left02');
				}
				
				if(isLast){
					$('#copyNextPrevDiv').children('button:last').attr('class', 'btn_code_right01');
				} else {
					$('#copyNextPrevDiv').children('button:last').attr('class', 'btn_code_right02');
				}
				
			}
		})
		$('#lab_loading').hide();
	}
	
	function bindDialogEnter(e){
		if(e.keyCode == 13)
			$(e.target).next().click();
	}
	
	function paging(pageNo){
		loadList(pageNo);
	}
	
	function loadList(pageNo){
		var pNo = '${designDocInfo.pNo}';
		var isAdmin = "${userUtil:getIsAdmin(pageContext.request)}";
		var userId = "${userUtil:getUserId(pageContext.request)}";
		
		$.ajax({
			url: '/design/getProductDesingDocDetailListAjax',
			type: 'post',
			data: {pNo: pNo, pageNo: pageNo},
			success: function(data){
				if(data.list.length > 0){
					$('#detailTableBody').empty();
					var html="";
					for (var i = 0; i < data.list.length; i++) {
						var row = data.list[i];
						html += "<tr>";
						html += '	<td>';
						html += '		<input type="checkbox" name="row_chk" id="row_'+i+'" onchange="checkOnly(event)"><label for="row_'+i+'"><span></span></label>';
						html += '		<input type="hidden" name="row_pNo" value="'+pNo+'">';
						html += '		<input type="hidden" name="row_pdNo" value="'+row.pdNo+'">';
						html += '		<input type="hidden" name="row_state" value="'+row.state+'">';
						html += '	</td>';
						html += "	<td><a href=\"javascript:readItemDetail('"+pNo+"', '"+row.pdNo+"', '"+row.pdaNo+"')\">"+row.pdNo+"</a></td>";
						html += "	<td><a href=\"javascript:readItemDetail('"+pNo+"', '"+row.pdNo+"', '"+row.pdaNo+"')\">"+row.memo+"</a></td>";
						html += "	<td>"+row.stateText+"</td>";
						html += "	<td>"+row.userName+"</td>";
						html += "	<td>"+row.regDate+"</td>";
						html += "	<td>"+isNull(row.modUserName)+"</td>";
						html += "	<td>"+isNull(row.modDate)+"</td>";
						html += "	<td>";
						html += "		<ul class=\"list_ul\">";
						html += "			<li><button type=\"button\" class=\"btn_doc\" onclick=\"popupItemDetail('"+pNo+"', '"+row.pdNo+"', '"+row.pdaNo+"'); return false;\"><img src=\"/resources/images/icon_doc01.png\">미리보기</button></li>";
						html += "			<li><button type=\"button\" class=\"btn_doc\" onclick=\"copyProductDesignDocDetail('"+pNo+"', '"+row.pdNo+"')\"><img src=\"/resources/images/icon_doc02.png\">복사</button></li>";
						if(isAdmin == 'Y' || userId == row.userName){
							html += "				<li><button type=\"button\" class=\"btn_doc\" onclick=\"editProductDesignDocDetail('"+pNo+"', '"+row.pdNo+"')\"><img src=\"/resources/images/icon_doc03.png\">수정</button></li>";
							html += "				<li><button type=\"button\" class=\"btn_doc\" onclick=\"deleteProductDesignDocDetail('"+pNo+"', '"+row.pdNo+"')\"><img src=\"/resources/images/icon_doc04.png\">삭제</button></li>";
						} else {
							
						}
						html += "		</ul>";
						html += "	</td>";
						html += "</tr>";
					}
					$('#detailTableBody').append(html);
					$('.page_navi').html(data.navi.prevBlock+data.navi.pageList+data.navi.nextBlock);
				} else {
					var html = '<tr><td colspan="7">입력된 설계서가 없습니다. 설계서를 등록해주세요</td></tr>';
					$('#detailTableBody').empty();
					$('#detailTableBody').append(html);
					$('.page_navi').html(data.navi.prevBlock+data.navi.pageList+data.navi.nextBlock);
				}
			},
			error: function(jqXHR, textStatus, errorThrown){
				alert('설계서 목록 불러오기 오류');
				//console.log(jqXHR, textStatus, errorThrown);
			}
		});
	}
	
	function isNull(str){
		if(str == null || str === undefined)
			return "";
		else
			return str;
	}
	
	function checkOnly(e){
		for(var i=0; i<document.getElementsByName('row_chk').length; i++){
			element = document.getElementsByName('row_chk')[i];
			element.checked = false;
		}
		
		e.target.checked = true;
	}
	
	//제품설계서 결재
	function openAppr() {
		var pNo = $('input[name=row_chk]:checked').siblings('input[name=row_pNo]').val();
		var pdNo = $('input[name=row_chk]:checked').siblings('input[name=row_pdNo]').val();
		
		if($('input[name=row_chk]:checked').length <= 0){
			return alert('결재할 문서를 선택해주세요');
		}
		
		if($('input[name=row_chk]:checked').length > 1){
			return alert('결재 문서는 1개만 선택해주세요');
		}
		
		var state = $('input[name=row_chk]:checked').siblings('input[name=row_state]').val();
		
		if( state != '0' ){
			return alert('결재는 등록 문서만 상신 가능합니다.');
		}
		
		clearApprLine();
		getApprLineList();
		$("#apprTitle").val($("#title").val());
		openDialog('dialog_approval');
	}
	
	function clearApprLine() {
		$('#apprList li').each(function(index, element){
			if(index != 0) $(element).remove();
		});
		
		$("#refList").html("");
	}
	
	function getApprLineList() {
		var URL = "/approval/approvalLineListAjax";
		$.ajax({
			type:"POST",
			url:URL,
			data:{
				"tbType" : tbType
			},
			dataType:"json",
			async:false,
			success:function(data) {
				var list = data;
				$("#apprLine").removeOption(/./);
				$("#apprLine").addOption('','',false);
				$.each(list, function( index, value ){ //배열-> index, value
					$("#apprLine").addOption(value.apprLineNo, value.lineName, false);
				});
			},
			error:function(request, status, errorThrown){
					alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
			}			
		});
	}
	
	var arr;

	function getApprItem() {
		var URL = "/approval/detailApprovalLineListAjax";
		$.ajax({
			type:"POST",
			url:URL,
			data:{
				"apprLineNo" : $("#apprLine").selectedValues()[0]			
			},
			dataType:"json",
			async:false,
			success:function(data) {
				clearApprLine();
				
				arr = data;
				
				//var apprLineArr = data.filter(row => (row.apprType != 'R' && row.apprType != 'C'));
				//var rcLineArr = data.filter(row => (row.apprType == 'R' || row.apprType == 'C'));
				
				var apprLineArr = $.map(arr,function(row, index){
					if(row.apprType != 'R' && row.apprType != 'C'){
						return row;
					}
				});
			
				var rcLineArr = $.map(arr,function(row, index){
					if(row.apprType == 'R' || row.apprType == 'C'){
						return row;
					}
				});
				
				apprLineArr.map( function(row, index){
					var html = "";
					var tagName = $('#apprList li').length + "차결재자";
					
					html += "<li>";
					html += "	<a href=\"javascript:;\" onclick=\"delApprList(event)\"><img src=\"/resources/images/icon_del_file.png\"></a>";
					html += "	<span>"+tagName+"</span> "+ row.userName;
					html += "	<strong> "+row.deptCodeName+" / "+row.teamCodeName+"</strong>"
					html += "	<input type=\"hidden\" name=\"apprSelectUserId\" id=\"apprSelectUserId\" value=\""+row.targetUserId+"\">";
					html += "	<input type=\"hidden\" name=\"apprSelectUserName\" id=\"apprSelectUserName\" value=\""+row.userName+"\">";
					html += "</li>"
					
					$('#apprList').append(html);
				});
				
				rcLineArr.map( function(row, index) {
					var html = "";
					var tagName = row.apprType == 'R' ? '참조' : '회람';
					html += "<li>";
					html += "	<a href=\"javascript:;\" onclick=\"delApprList(event)\"><img src=\"/resources/images/icon_del_file.png\"></a>";
					html += "	<span>"+tagName+"</span> "+ row.userName;
					html += "	<strong> "+row.deptCodeName+" / "+row.teamCodeName+"</strong>"
					html += "	<input type=\"hidden\" name=\"refId\" id=\"refId\" value=\""+row.targetUserId+"\">";
					html += "	<input type=\"hidden\" name=\"refName\" id=\"refName\" value=\""+row.userName+"\">";
					html += "	<input type=\"hidden\" name=\"refType\" id=\"refType\" value=\""+row.apprType+"\">";
					html += "</li>"
					
					$('#refList').append(html);
				});
			},
			error:function(request, status, errorThrown){
					alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
			}			
		});
	}

	function insertApprLine() {
		
		var param = {};
		
		$('#apprList input[name=apprSelectUserId]').each(function(i, element){
			var apprId = $(element).val()
			if( nvl(apprId, '' ) != '' ) {
				param['apprArray['+i+']']=apprId;
			}
		})
		
		$('#refList input[name=refType][value=R]').each(function(i, element){
			var apprId = $(element).siblings('input[id=refId]').val()
			if( nvl(apprId, '' ) != '' ) {
				param['refArray['+i+']']=apprId;
			}
		})
		
		$('#refList input[name=refType][value=C]').each(function(i, element){
			var apprId = $(element).siblings('input[id=refId]').val()
			if( nvl(apprId, '' ) != '' ) {
				param['circArray['+i+']']=apprId;
			}
		})
		
		param['tbType'] = tbType;
		param['lineName'] = $("#lineName").val();
		
		$.ajax({
			type:"POST",
			url:'/approval/approvalLineSaveAjax',
			data: param,
			traditional : true,
			dataType:"json",
			async:false,
			success:function(data) {
				console.log(data);
				if(data.status == 'success') {
					alert("결재라인이  저장되었습니다.");
					getApprLineList();
				} else {
					alert("결재라인 저장 오류가 발생하였습니다.");
					return;
				}
			},
			error:function(request, status, errorThrown){
				alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
			}			
		});
	}

	function deleteApprLine() {
		var URL = "/approval/deleteApprovalLine";
		$.ajax({
			type:"POST",
			url:URL,
			data:{
				"apprLineNo" : $("#apprLine").selectedValues()[0]
			},
			traditional : true,
			dataType:"json",
			async:false,
			success:function(data) {
				if(data.status = 'success') {
					alert("결재라인 삭제되었습니다.");
					clearApprLine();
					getApprLineList();
				} else {
					alert("결재라인 저장 오류가 발생하였습니다.");
					return;
				}
			},
			error:function(request, status, errorThrown){
				alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
			}			
		});
	}

	$(function() {
		$('#searchUser').autoComplete({
			minChars: 2,
			delay: 100,
			cache: false,
			source: function(term, response){
				$.ajax({
					type: 'POST',
					url: '/common/userListAjax2',
					dataType: 'json',
					data: {
						"searchUser" : $("#searchUser").val()
					},			
					global: false,
					async: false,
					success: function (data) {
						if(!data){
							return;
						}
						var list = data;
						var completes = [];
						for(var i = 0, len = list.length; i < len; i++){
							var name = list[i].userName + " / " + list[i].userId + " / " + list[i].deptCodeName+ " / " + list[i].teamCodeName;
							completes.push([name, list[i].userId]);  
						}
						response(completes);
					}
				});
			},
			renderItem: function (item, search){
			    return '<div class="autocomplete-suggestion" data-code="' + item[1] + '" data-nm="' + item[0] + '" style="font-size: 0.8em">' + item[0] + '</div>';
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
	});

	function addApprList() {
		var usreId = $("#selectUserId").val();
		if( !chkNull(usreId) ) {
			alert("결재자를 선택해주세요.");
			return;
		} else {
			var num = $('#apprList li').length
			var usreInfo = $("#selectUserInfo").val();
			var jbSplit = usreInfo.split('/');
			var html = "";
			html += "<li>";
			html += "	<a href=\"javascript:;\" onclick=\"delApprList(event)\"><img src=\"/resources/images/icon_del_file.png\"></a>";
			html += "	<span>"+num+"차결재자</span> "+jbSplit[0];
			html += "	<strong> "+jbSplit[2]+"/"+jbSplit[3]+"</strong>"
			html += "	<input type=\"hidden\" name=\"apprSelectUserId\" id=\"apprSelectUserId\" value=\""+usreId+"\">";
			html += "	<input type=\"hidden\" name=\"apprSelectUserName\" id=\"apprSelectUserName\" value=\""+jbSplit[0]+"\">";
			html += "</li>"
			//$("#apprList"+num).html(html);
			$('#apprList').append(html);
			$('#searchUser').val("");
			$("#selectUserId").val("");
			$("#selectUserInfo").val("");
		}
	}

	function delApprList(e) {
		$(e.target).parent().parent().remove();
		setApprLineNum();
		return;
		var html = "";
		$("#apprList"+num).html(html);
	}
	
	function setApprLineNum(){
		$('#apprList li').each(function(index, element){
		    if(index != 0)
		        $(element).children('span').text(index+'차결재자')
		})
	}

	var refCount = 0;
	function addRefList(type) {
		var usreId = $("#selectUserId").val();
		if( !chkNull(usreId) ) {
			alert("참조/회람자를 선택해주세요.");
			return;
		} else {
			var nodes=$("#refList").children();
			var usreInfo = $("#selectUserInfo").val();
			var jbSplit = usreInfo.split('/');
			var refType="";
			var html = "";
			html += "<li id=\"refItem"+refCount+"\">";
			html += "<a href=\"javascript:delRefList('"+refCount+"')\"><img src=\"/resources/images/icon_del_file.png\"></a>";
			if( type == 'R' ) {
				html += "<span>참조</span> "+jbSplit[0];
				refType = "R"
			} else {
				html += "<span>회람</span> "+jbSplit[0];
				refType = "C"
			}
			html += "<strong> "+jbSplit[2]+"/"+jbSplit[3]+"</strong>"
			html += "<input type=\"hidden\" name=\"refId\" id=\"refId\" value=\""+usreId+"\">";
			html += "<input type=\"hidden\" name=\"refName\" id=\"refName\" value=\""+jbSplit[0]+"\">";
			html += "<input type=\"hidden\" name=\"refType\" id=\"refType\" value=\""+refType+"\">";
			html += "</li>";
			$("#refList").append(html);
			$('#searchUser').val("");
			$("#selectUserId").val("");
			$("#selectUserInfo").val("");
			refCount++;
		}
	}

	function delRefList(usreId) {
		var html = "";
		$("#refItem"+usreId).remove();
	}

	function approvalRequest(){
		if( !chkNull($("#apprTitle").val()) ){
			alert("결재 제목을 입력하여 주세요.");
			$("#apprTitle").focus();
			return;
		}
		
		if( !chkNull($("#apprComment").val()) ) {
			alert("요청사유를 입력하여 주세요.");
			$("#apprComment").focus();
			return;
		}
		
		if($('input[name=row_chk]:checked').length > 1){
			return alert('결재 문서는 1개만 선택해주세요');
		}
		
		var param = {};
		param['tbType'] = tbType;
		param['tbKey'] = $('input[name=row_chk]:checked').siblings('input[name=row_pdNo]').val();
		param['title'] = $("#apprTitle").val()
		param['comment'] = $("#apprComment").val()
		
		$('#apprList input[name=apprSelectUserId]').each(function(i, element){
			var apprId = $(element).val()
			if( nvl(apprId, '' ) != '' ) {
				param['apprArray['+i+']']=apprId;
			}
		})
		
		$('#refList input[name=refType][value=R]').each(function(i, element){
			var apprId = $(element).siblings('input[id=refId]').val()
			if( nvl(apprId, '' ) != '' ) {
				param['refArray['+i+']']=apprId;
			}
		})
		
		$('#refList input[name=refType][value=C]').each(function(i, element){
			var apprId = $(element).siblings('input[id=refId]').val()
			if( nvl(apprId, '' ) != '' ) {
				param['circArray['+i+']']=apprId;
			}
		})
		
		$.ajax({
			url: '/approval/approvalProductDesign',
			type: 'POST',
			dataType: 'json',
			data: param,
			success: function(data){
				if(data.status == 'S'){
					alert('제품설계서가 상신되었습니다.');
					closeDialog('dialog_approval');
					loadList();
				}
			},
			error: function(a,b,c){
				console.log(a,b,c)
			}
		})
	}

	function addApprUser() {
		
		if( !chkNull($("#apprTitle").val()) ){
			alert("결재 제목을 입력하여 주세요.");
			$("#apprTitle").focus();
			return;
		} else if( !chkNull($("#apprComment").val()) ) {
			alert("요청사유를 입력하여 주세요.");
			$("#apprComment").focus();
			return;
		} else {
			$("input[name=apprTitle]").val($("#apprTitle").val());
			$("input[name=apprComment]").val($("#apprComment").val());
			var apprNodes=$("#apprList").children();
			apprNodes.each(function(){ 
				var apprId = $(this).find($("input[name=apprSelectUserId]")).val();
				var apprName = $(this).find($("input[name=apprSelectUserName]")).val();
				if( nvl(apprId, '' ) != '' ) {
					$("#apprUser").removeOption(/./);
					$("#apprUser").addOption(apprId, apprName, true);
				}
			});
			var refNodes=$("#refList").children();
			refNodes.each(function(){ 
				var refId = nvl($(this).find($("input[name=refId]")).val(), '');
				var refName = nvl($(this).find($("input[name=refName]")).val(), '');
				var refType = nvl($(this).find($("input[name=refType]")).val(), '');
				if( refId != '' ) {
					if( refType == 'R' ) {
						$("#refUser").addOption(refId, refName, true);
					} else if( refType == 'C' ) {
						$("#circUser").addOption(refId, refName, true);
					}
				}
			});
			loadText("apprUser");
			loadText("refUser");
			loadText("circUser");
			closeDialog('open');
		}
	}

	function loadText(selectId) {
		var txt = "";
		$("#"+selectId).selectedOptions().each(function(){
				this.text;
				this.value;
				if( txt != '' ) {
					txt += "&nbsp;&nbsp;"+this.text+"&nbsp;<a href=\"javascript:deleteApprUser( '"+this.value+"', '"+selectId+"' )\"><img src=\"/resources/images/icon_del.png\" style=\"vertical-align:middle;cursor:hand\"/></a>";
				} else {
					txt += this.text+"&nbsp;<a href=\"javascript:deleteApprUser( '"+this.value+"', '"+selectId+"' )\"><img src=\"/resources/images/icon_del.png\" style=\"vertical-align:middle\"/></a>";
				} 
			}
		);
		$("#"+selectId+"Name").html(txt);
	}

	function deleteApprUser( id, selectId ) {
		if( selectId == 'apprUser') {
			$("#apprUser").removeOption(id);
			loadText(selectId);
		} else if( selectId == 'refUser') {
			$("#refUser").removeOption(id);
			loadText(selectId);
		} else if( selectId == 'circUser') {
			$("#circUser").removeOption(id);
			loadText(selectId);
		}
	}
	
</script>

<c:set var="productImage" value=""/>
<c:forEach items="${productDesignItemList.pagenatedList}" var="list">
	<c:if test="${productImage == '' && list.imageFileName != null && imageFileName != ''}">
		<c:set var="productImage" value="${list.imageFileName}"/>
	</c:if>
</c:forEach>

<c:choose>
	<c:when test="${productImage == ''}">
		<c:set var="productImage" value="/resources/images/img_sample.png"/> 
	</c:when>
	<c:when test="${productImage != ''}">
		<c:set var="productImage" value="/picture/${productImage}"/>
	</c:when>
</c:choose>


<div class="wrap_in" id="fixNextTag">
	<span class="path">제품설계서&nbsp;&nbsp;<img src="../resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;<a href="#">SPC 삼립연구소</a></span>
	<section class="type01">
		<h2 style="position:relative">
			<span class="title_s">Product Design Doc</span>
			<span class="title">제품설계서 상세</span>
			<div class="top_btn_box">
				<ul>
					<c:if test="${userUtil:getIsAdmin(pageContext.request) == 'Y' || userUtil:getUserId(pageContext.request) == designDocInfo.regUserId}">
						<li>
							<button type="button" class="btn_circle_modifiy" onClick="openDialog('dialog_modify')">&nbsp;</button>
							<button type="button" class="btn_circle_del" onClick="deleteProductDesignDoc('${pNo}')">&nbsp;</button>
						</li>
					</c:if>
				</ul>
			</div>
		</h2>
		<div class="group01" >
			<div class="title"></div>
			<div class="predoc_title">
				<div style="width: 100px; height: 100px; display: inline-block; vertical-align: top;" class="product_img">
					<img src="${productImage}">
				</div>
				<div style="display: inline-block; height: 80px; width: 600px; padding-top: 20px;">
					<span class="font17">제품명 : ${designDocInfo.productName}</span>
					<br/>
					<span class="font18">
						제품유형 : <c:if test="${fn:length(designDocInfo.productType1Text) > 0}">[${designDocInfo.productType1Text}]</c:if>
						<c:if test="${fn:length(designDocInfo.productType2Text) > 0}">[${designDocInfo.productType2Text}]</c:if>
						<c:if test="${fn:length(designDocInfo.productType3Text) > 0}">[${designDocInfo.productType3Text}]</c:if>
						<strong>&nbsp;|&nbsp;</strong>
						브랜드 : ${designDocInfo.companyName}
						<strong>&nbsp;|&nbsp;</strong>
						공장 : ${designDocInfo.plantName}
					</span>
				</div>
			</div>
			<div class="fr pt10 pb10">
				<c:if test="${userUtil:getIsAdmin(pageContext.request) == 'Y' || userUtil:getUserId(pageContext.request) == designDocInfo.regUserId}">
					<!-- <button type="button" class="btn_con_search" onclick="openCopyDialog()">
						<img src="/resources/images/icon_s_file.png"/> 타제품 복사
					</button> -->
					<button class="btn_con_search" onclick="openAppr();">
						<img src="/resources/images/icon_s_approval.png" style="vertical-align: middle;"> 제품설계서 결재상신
					</button>
					<button type="button" class="btn_con_search" onclick="productDesignItemCreateForm()">
						<img src="/resources/images/icon_s_write.png" /> 설계서 생성
					</button>
					<%-- <button class="btn_con_search" onclick="openDialog('dialog_modify')">
						<img src="/resources/images/icon_s_write.png" />제품 수정
					</button>
					<button class="btn_con_search" onclick="deleteProductDesignDoc('${pNo}')">
						<img src="/resources/images/icon_s_del.png" />제품 삭제
					</button> --%>
				</c:if>
			</div>
			<div class="main_tbl">
				<table class="tbl04">
					<colgroup>
						<col width="40px">
						<col width="5%">
						<col />
						<col width="5%">
						<col width="7%">
						<col width="15%">
						<col width="7%">
						<col width="15%">
						<col width="230px">
					</colgroup>
					<thead>
						<tr>
							<th></th>
							<th>문서번호</th>
							<th>설명</th>
							<th>상태</th>
							<th>작성자</th>
							<th>작성일</th>
							<th>수정자</th>
							<th>수정일</th>
							<th>문서설정</th>
						</tr>
					</thead>
					<tbody id="detailTableBody">
						<%-- <c:if test="${fn:length(productDesignItemList.pagenatedList) <= 0}">
							<tr>
								<td colspan="7">입력된 설계서가 없습니다. 설계서를 등록해주세요</td>
							</tr>
						</c:if>
						<c:if test="${fn:length(productDesignItemList.pagenatedList) > 0}">
							<c:forEach items="${productDesignItemList.pagenatedList}" var="list">
								<tr>
									<td><a href="javascript:readItemDetail('${pNo}', '${list.pdNo}', '${list.pdaNo}')">${list.pdNo}</a></td>
									<td><a href="javascript:readItemDetail('${pNo}', '${list.pdNo}', '${list.pdaNo}')">${list.memo}</a></td>
									<td>${list.userName}</td>
									<td>${list.regDate}</td>
									<td>${list.modUserName}</td>
									<td>${list.modDate}</td>
									<td>
										<ul class="list_ul">
											<li><button type="button" class="btn_doc" onclick="popupItemDetail('${pNo}', '${list.pdNo}', '${list.pdaNo}'); return false;"><img src="/resources/images/icon_doc01.png">미리보기</button></li>
											<li><button type="button" class="btn_doc" onclick="copyProductDesignDocDetail('${pNo}', '${list.pdNo}')"><img src="/resources/images/icon_doc02.png">복사</button></li>
											<c:if test="${userUtil:getIsAdmin(pageContext.request) == 'Y' || userUtil:getUserId(pageContext.request) == designDocInfo.regUserId}">
												<li><button type="button" class="btn_doc" onclick="editProductDesignDocDetail('${pNo}', '${list.pdNo}')"><img src="/resources/images/icon_doc03.png">수정</button></li>
												<li><button type="button" class="btn_doc" onclick="deleteProductDesignDocDetail('${pNo}', '${list.pdNo}')"><img src="/resources/images/icon_doc04.png">삭제</button></li>
											</c:if>
										</ul>
									</td>
								</tr>
							</c:forEach>
						</c:if>
					</tbody> --%>
				</table>
			</div>
			<div class="page_navi mt10">
				<ul>
					<c:if test="${productDesignItemList.page.totalCount != 0}">
						<c:if test="${productDesignItemList.page.hasPrev() == true}">
							<li style="border-right: none;">
								<a href="#none" class="btn btn_prev1" onclick="changePage(${productDesignItemList.page.pageBlock[0]-1})">Prev</a>
							</li>	
						</c:if>
						<c:forEach items="${productDesignItemList.page.pageBlock}" var="page">
							<c:if test="${page == productDesignItemList.page.showPage}">
								<li class="select" style="border-right: none;">
									<a href="#none" class="btn btn_prev1" onclick="">${page}</a>
								</li>
							</c:if>
							<c:if test="${page != productDesignItemList.page.showPage}">
								<li style="border-right: none;">
									<a href="#none" class="btn btn_prev1" onclick="changePage(${page})">${page}</a>
								</li>
							</c:if>
						</c:forEach>
						<c:if test="${productDesignItemList.page.hasNext() == true}">
							<li style="border-right: none;">
								<a href="#none" class="btn btn_next3" onclick="changePage(${productDesignItemList.page.pageBlock[4]+1})">Next</a>
							</li>	
						</c:if>
					</c:if>
				</ul>
			</div>
			<div class="btn_box_con5">
				<button type="button" class="btn_admin_gray" onclick="goList()" style="width: 120px;">목록</button>
			</div>
			<div class="btn_box_con4">
				<c:if test="${userUtil:getIsAdmin(pageContext.request) == 'Y' || userUtil:getUserId(pageContext.request) == designDocInfo.regUserId}">
					<!-- <button class="btn_admin_red" onclick="productDesignItemCreateForm()">설계서 생성</button> -->
					<button type="button" class="btn_admin_navi" style="width: 120px;" onclick="openDialog('dialog_modify')">수정</button>
					<button type="button" class="btn_admin_gray" style="width: 120px;" onclick="deleteProductDesignDoc('${pNo}')">제품삭제</button>
				</c:if>
			</div>
		</div>
	</section>
	
	<form id="createForm" action="/design/productDesignDocDetailCreate" method="post">
		<input type="hidden" name="pNo" value="${pNo}">
		<input type="hidden" name="productName" value="${designDocInfo.productName}">
	</form>
</div>




<!-- 제품설계서 수정레이어 open-->
<!-- 클래스 옆에 적힌 스타일 값을 인라인으로 작성해서 팝업 사이즈를 직접 조정 -->
<div class="white_content" id="dialog_modify">
    <div class="modal" style="	margin-left:-355px;width:710px;height: 400px;margin-top:-200px">
        <h5 style="position:relative">
            <span class="title">제품설계서 수정</span>
            <div class="top_btn_box">
                <ul>
                    <li>
                        <button type="button" class="btn_madal_close" onClick="closeDialog('dialog_modify')"></button>
                    </li>
                </ul>
            </div>
        </h5>
        <div class="list_detail">
        	<form id="productDesignUpdateForm" action="/design/saveProductDesignDoc">
				<input type="hidden" name="pNo" value="${designDocInfo.pNo}"/>
				<input type="hidden" name="regUserId" value="${userUtil:getUserId(pageContext.request)}"/>
	            <ul>
	                <li>
	                    <dt>제품명</dt>
	                    <dd>
	                        <input type="text" class="req" style="width:390px;" placeholder="입력필수" name="productName" id="productName" value="${designDocInfo.productName}"/>
	                    </dd>
	                </li>
	                <li>
						<dt>제품유형</dt>
						<dd>
							<div class="selectbox req" style="width:130px;">  
								<label for="productType1" id="label_productType1"> 선택</label> 
								<select id="productType1" name="productType1" onChange="loadProductType('2','productType2')">
								</select>
							</div>
							<div class="selectbox req ml5" style="width:130px;display:none" id="li_productType2">  
								<label for="productType2" id="label_productType2"> 선택</label> 
								<select id="productType2" name="productType2" onChange="loadProductType('3','productType3')">
								</select>
							</div>
							<div class="selectbox req ml5" style="width:130px;display:none" id="li_productType3">  
								<label for="productType3" id="label_productType3"> 선택</label> 
								<select id="productType3" name="productType3">
								</select>
							</div>
						</dd>
					</li>
					<li>
	                    <dt>공장</dt>
	                    <dd>
	                    	<div class="selectbox req" style="width:130px;">  
								<label id="label_companyCode" for="companyCode">선택</label>
								<select id="companyCode" name="companyCode" onChange="companyChange('companyCode','plant')">
	                            </select>
							</div>
							<div class="selectbox req ml5" style="width:130px; display:none;"> 
								<label id="label_plant" for="plant">선택</label>
	                            <select id="plant" name="plant">
	                            </select>
							</div>
	                    </dd>
	                </li>
					<li>
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
	            </ul>
            </form>
        </div>
        <div class="btn_box_con">
            <button type="button" class="btn_admin_red" onclick="updateProductDesignDoc()">제품설계서 수정</button>
            <button type="button" class="btn_admin_gray" onClick="closeDialog('dialog_modify')">생성 취소</button>
        </div>
    </div>
</div>
<!-- 제품설계서 수정레이어 close-->


<!-- 타제품 검색 레이어 start-->
<div class="white_content" id="dialog_copy">
	<input id="targetID" type="hidden">
	<input id="itemType" type="hidden">
	<div class="modal positionCenter" style="width: 600px; height: 600px">
		<h5 style="position: relative">
			<span class="title">설계서 검색</span>
			<div class="top_btn_box">
				<ul>
					<li><button type="button" class="btn_madal_close" onClick="closeCopyPopup()"></button></li>
				</ul>
			</div>
		</h5>

		<div id="matListDiv" class="code_box">
			<input id="searchValue" type="text" class="code_input" onkeyup="bindDialogEnter(event)" style="width: 300px;" placeholder="일부단어로 검색가능">
			<img src="/resources/images/icon_code_search.png" onclick="searchCopyDialog()"/>
			<div class="code_box2">
				(<strong> <span id="popupCount">0</span> </strong>)건
			</div>
			<div class="main_tbl">
				<table class="tbl07">
					<colgroup>
						<col width="15%">
						<col width="10%">
						<col width="auto">
					</colgroup>
					<thead>
						<tr>
							<th>제품설계서<br>번호</th>
							<th>설계서<br>번호</th>
							<th>제품명</th>
						<tr>
					</thead>
					<tbody id="popupBody">
						<input type="hidden" id="copyPopupPage" value="0"/>
						<Tr>
							<td colspan="3">설계서를 검색해주세요</td>
						</Tr>
					</tbody>
				</table>
				<!-- 뒤에 추가 리스트가 있을때는 클래스명 02로 숫자변경 -->
				<div id="copyNextPrevDiv" class="page_navi mt10">
					<button type="button" class="btn_code_left01" onclick="searchCopyDialog('prevPage')"></button>
					<button type="button" class="btn_code_right02" onclick="searchCopyDialog('nextPage')"></button>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- 타제품 검색 레이어 close-->

<!-- 결재문서 생성레이어 start -->
<div class="white_content" id="dialog_approval">
	<div class="modal positionCenter" style="width:1000px; height: 520px;">
		<h5 style="position:relative">
			<span class="title">제품설계 결재 상신</span>
			<div  class="top_btn_box">
				<ul><li><button class="btn_madal_close" onClick="closeDialog('dialog_approval');"></button></li></ul>
			</div>
		</h5>
		<div class="list_detail">
			<ul>
				<li class="pt10">
					<dt style="width:20%">제목</dt>
					<dd style="width:80%">
						<input type="text" id="apprTitle" class="req" style="width:573px">
					</dd>
				</li>
				<li>
					<dt style="width:20%">요청사유</dt>
					<dd style="width:80%;">
						<textarea style="width:573px; height:50px" id="apprComment" placeholder="요청사유를 입력하세요"></textarea>
					</dd>
				</li>
				<li>
					<dt style="width:20%">결재자 입력</dt>
					<dd style="width:80%;" class="ppp">
						<input type="text" placeholder="결재자명 2자이상 입력후 선택" style="width:340px; float:left;" class="req" name="searchUser" id="searchUser">
						<input type="hidden" name="selectUserId" id="selectUserId">
						<input type="hidden" name="selectUserInfo" id="selectUserInfo">
						<button class="btn_small01 ml5" onClick="addApprList()">결재</button>
						<button class="btn_small02  ml5" onClick="addRefList('R')">참조</button>
						<button class="btn_small02  ml5" onClick="addRefList('C')">회람</button>
						<div class="selectbox ml5" style="width:200px;">
							<label for="apprLine">---- 결재선 불러오기 ----</label>
							<select id="apprLine" name="apprLine" onChange="getApprItem();">
							</select>
						</div>
					</dd>
				</li>
				<li  class="mt5">
					<dt style="width:20%; background-image:none;" ></dt>
					<dd style="width:80%;">
						<div class="file_box_pop2" >
							<ul id="apprList">
								<li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="s01"> 기안자</span> <%=UserUtil.getUserName(request)%><strong> <%=UserUtil.getDeptCodeName(request)%> / <%=UserUtil.getTeamCodeName(request)%></strong></li>								
								<!-- <li id="apprList1"></li> -->
							</ul>
						</div>
						<div class="file_box_pop3" >
							<ul id="refList">
							</ul>
						</div>
						<!-- 현재 추가된 결재선 저장 버튼을 누르면 안보이게 처리 start -->
						<!--div class="app_line_edit">
							<button class="btn_doc"><img src="/resources/images/icon_doc11.png"> 현재 추가된 결재선 저장</button>  |  
							<button class="btn_doc"><img src="/resources/images/icon_doc04.png"> 현재 표시된 결재선 삭제</button>
						</div-->	
						<!-- 현재 추가된 결재선 저장 버튼을 누르면 안보이게 처리 close -->
						<!-- 현재 추가된 결재선 저장 버튼 눌렀을때 보이게 처리 start -->
						<div class="app_line_edit">저장 결재선명 입력 :  
							<input type="text" name="lineName" id="lineName" class="req" style="width:280px;"/> 
							<button class="btn_doc" onClick="insertApprLine();"><img src="/resources/images/icon_doc11.png"> 저장</button> |  
							<button class="btn_doc" onClick="deleteApprLine()"><img src="/resources/images/icon_doc04.png">삭제</button>
						</div>
						<!-- 현재 추가된 결재선 저장 버튼 눌렀을때 보이게 처리 close -->
					</dd>	
				</li>
			</ul>
		</div>
		<div class="btn_box_con4" style="padding:15px 0 20px 0">
			<button class="btn_admin_red" onClick="javascript:approvalRequest();">결재상신</button> 
			<button class="btn_admin_gray" onClick="closeDialog('dialog_approval');">상신 취소</button>
		</div>
	</div>
</div>
<!-- 결재문서 생성레이어 close-->