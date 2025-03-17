<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ page import="kr.co.aspn.util.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ taglib prefix="userUtil" uri="/WEB-INF/tld/userUtil.tld"%>
<%@ page session="false" %>

<link rel="stylesheet" href="/resources/CLEditor/jquery.cleditor.css?param=1" />
<script type="text/javascript" src="/resources/CLEditor/jquery.cleditor.min.js?param=1"></script>
<link href="/resources/js/jquery.auto-complete.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="/resources/js/jquery.auto-complete.js"></script>

<script src="//cdnjs.cloudflare.com/ajax/libs/babel-standalone/6.26.0/babel.min.js"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/babel-polyfill/7.4.3/polyfill.js"></script>

<title>자재 변경관리</title>

<style type="text/css">
.readOnly {
	background-color: #ddd
}
.positionCenter{
	position: absolute;
	transform: translate(-50%, -50%);
}
</style>
<script type="text/javascript">
	var PARAM = {
		isSample: '${paramVO.isSample}',
		searchCompany: '${paramVO.searchCompany}',
		searchPlant: '${paramVO.searchPlant}',
		searchType: '${paramVO.searchType}',
		searchValue: '${paramVO.searchValue}',
		pageNo: '${paramVO.pageNo}'
	};
	var tbType = "materialManagement";
	
	$(document).ready(function(){
		loadList(1);
		
		$('#mtch_company').change();
	});
	
	function bindEnter(elementId, fn){
		$('#'+elementId).keyup(function(event){
			if(event.keyCode == 13){
				fn();
			}
		});
	}
	
	function bindDialogEnter(e){
		if(e.keyCode == 13)
			$(e.target).next().click();
	}
	
	function paging(pageNo){
		loadList(pageNo);
	}
	
	function searchClear(){
		$("#searchCompany").selectOptions("");
		$("#searchCompany_label").html("선택");
		$("#searchPlant").removeOption(/./);
		$("#searchPlant_label").html("선택");
		$("#searchType").selectOptions("");	
		$("#searchType_label").html("선택");
		$("#searchValue").val("");
		$("#viewCount").selectOptions("");
		$("#viewCount_label").html("선택");
		loadList();
	}
	
	function loadList(pageNo){
		var isSample = $(":input:radio[name=isSample]:checked").val();
		var searchCompany = $("#searchCompany").selectedValues()[0];
		var searchPlant = $("#searchPlant").selectedValues()[0];
		var searchType = $("#searchType").selectedValues()[0];	
		var searchValue = $("#searchValue").val();	
		var viewCount = $("#viewCount").selectedValues()[0];
		if( viewCount == '' ) {
			viewCount = "10";
		}
		$("#pageNo").val(pageNo);
		
		$("#list").html("<tr><td align='center' colspan='12'>조회중입니다.</td></tr>");
		$('#list_page').html("");
		$.ajax({
			url:"/material/changeListAjax",
			type:"POST",
			data:{
				"isSample":isSample, "searchCompany":searchCompany, 
				"searchPlant":searchPlant, "searchType":searchType, 
				"searchValue":searchValue, "viewCount":viewCount, "pageNo":pageNo
			},
			dataType:"json",
			success:function(data) {
				var html = "";
				
				if(data.materialManagementList.length <= 0){
					html = "<tr><td align='center' colspan='12'>등록된 내용이 없습니다.</td></tr>"
				} else {
					//html = "<tr><td align='center' colspan='10'>개발듕..</td></tr>";
					
					for (var i = 0; i < data.materialManagementList.length; i++) {
						var row = data.materialManagementList[i];
						
						html += "<tr>";
						html += '	<td>';
						html += '		<input type="checkbox" name="row_chk" id="row_'+i+'" onchange="checkOnly(event)"><label for="row_'+i+'"><span></span></label>';
						html += '		<input type="hidden" name="row_mmNo" value="'+row.mmNo+'">';
						html += '		<input type="hidden" name="row_state" value="'+row.state+'">';
						html += '	</td>';
						html += "	<td>"+row.mmNo+"</td>";
						html += "	<td>"+row.plantName+"</td>";
						html += "	<td>"+row.preSapCode+"</td>";
						html += "	<td><img src='/resources/images/icon_arr.png'></td>";
						html += "	<td class='font05'>"+row.postSapCode+"</td>";
						html += "	<td>";
						html += '		<div class="ellipsis_txt tgnc"><a href="javascript:showDetail('+row.mmNo+');">'+row.preName+'</a><span class="icon_new">N</span></div>';
						html += "	</td>";
						html += "	<td><img src='/resources/images/icon_arr.png'></td>";
						html += "	<td>";
						html += '		<div class="ellipsis_txt tgnc"><a href="javascript:showDetail('+row.mmNo+');">'+row.postName+'</a><span class="icon_new">N</span></div>';
						html += "	</td>";
						if(row.state == '5' || row.state == '6'){
							var innerText = '<a href="javascript:approvalDetail('+row.mmNo+', \'materialManagement\');"><span style=\"color: #e83346; font-weight: bold;\">'+row.stateText+'</span></a>';
							html += "	<td>"+innerText+"</td>"
							//html += "	<td style=\"color: #e83346; font-weight: bold;\">"+row.stateText+"</td>";
						} else {
							if(row.state == '0'){
		 						html += "	<td>"+row.stateText+"</td>";
							} else {
								var innerText = '<a href="javascript:approvalDetail('+row.mmNo+', \'materialManagement\');">'+row.stateText+'</a>';
								html += "	<td>"+innerText+"</td>";
							}
						}
						html += "	<td>"+row.regUserName+"</td>";
						//html += "	<td>"+row.modUserId+"</td>";
						if(row.modDate != null){
							html += "	<td>"+row.modDate+"</td>";
						} else {
							html += "	<td>"+row.regDate+"</td>";
						}
						html += "</tr>";
					}
				}
				
				$("#list").html(html);
				$('#list_page').html(data.navi.prevBlock+data.navi.pageList+data.navi.nextBlock);
				$('#pageNo').val(data.navi.pageNo);
			},
			error:function(request, status, errorThrown){
				var html = "";
				$("#list").html(html);
				html += "<tr><td align='center' colspan='12'>오류가 발생하였습니다.</td></tr>";
				$("#list").html(html);
				$('#list_page').html(data.navi.prevBlock+data.navi.pageList+data.navi.nextBlock);
				$('#pageNo').val(data.navi.pageNo);
			}			
		});	
	}
	
	function companyChange(companySelectBoxId, selectBoxId) {
		var URL = "/common/plantListAjax";
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
				$("#companyNo_li").hide();
				$("#companyNo_span").html("");
				$("#companyNo").val("");
			},
			error:function(request, status, errorThrown){
					alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
			}			
		});
	}
	
	function openMtchDialog(){
		openDialog('dialog_mtch');
	}
	
	function closeMtchDialog(){
		closeDialog('dialog_mtch');
	}
	
	function openMaterialPopup(element, itemType){
		if($('#mtch_plant').val().length <= 0)
			return alert('회사, 공장, 생산라인을 선택해주세요');
		
		var targetId = $(element).prev().attr('id');
		$('#targetID').val(targetId);
		openDialog('dialog_material');
		
		var matCode = $(element).prev().val()
		if(typeof(matCode) == 'string') matCode = matCode.toUpperCase();
		$('#searchMatValue').val(matCode);
		$('#itemType').val(itemType);
		
		searchMaterial();
	}
	
	function closeMatRayer(){
		$('#searchMatValue').val('')
		$('#matLayerBody').empty();
		$('#matLayerBody').append('<tr><td colspan="9">원료코드 혹은 원료코드명을 검색해주세요</td></tr>');
		$('#matCount').text(0);
		closeDialog('dialog_material')
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
				companyCode: $('#mtch_company').val(),
				plant: $('#mtch_plant').val(),
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
	
	function setMaterialPopupData(parentRowId, itemImNo, itemSAPCode, itemName, itemUnitPrice, itemUnit){
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
		$('#'+parentRowId).val(itemSAPCode);
		closeMatRayer();
	}
	
	function changeCompany(e){
		var companyCode = e.target.value;
		var URL = "/common/plantListAjax";
		
		$.ajax({
			type:"POST",
			url:URL,
			data:{
				"companyCode" : companyCode
			},
			dataType:"json",
			async:false,
			success:function(data) {
				var selectBoxId = 'mtch_plant';
				var list = data.RESULT;
				$("#"+selectBoxId).removeOption(/./);
				$("#"+selectBoxId).addOption("", "전체", false);
				$("label[for="+selectBoxId+"]").html("전체");
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
	
	function submitMtch(type){
		var preSapCode = $('#preSapCode').val();
		var postSapCode = $('#postSapCode').val();
		var companyCode = $('#mtch_company').val();
		var plantCode = $('#mtch_plant').val();
		
		if(plantCode.length <= 0){
			alert("공장을 선택해주세요.");
			$('#mtch_plant').focus();
			return;
		}
		
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
		appendInput(form, 'plantCode', plantCode);
		
		$('body').append(form);
		$(form).submit();
	}
	
	function showDetail(mmNo){
		var form = document.createElement('form');
		form.style.display = 'none';
		form.action = '/material/changeRequestDetail';
		form.method = 'post';
		
		appendInput(form, 'mmNo', mmNo);
		
		$('body').append(form);
		$(form).submit();
	}
	
	//결재관련 함수 start
	function openAppr() {
		
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
		/* var apprNodes=$("#apprList").children();
		apprNodes.each(function(){ 
			var apprId = $(this).find($("input[name=apprSelectUserId]")).val();
			if( nvl(apprId, '' ) != '' ) {
				$(this).html("");
			}
		}); */
		
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
				clearApprLine()
				
				arr = data;
				
				//var apprLineArr = data.filter(row => (row.apprType != 'R' && row.apprType != 'C'))
				//var rcLineArr = data.filter(row => (row.apprType == 'R' || row.apprType == 'C'))
				
				var apprLineArr = data.map(function(row){
					if(row.apprType != 'R' && row.apprType != 'C')
						return row;
				})
				
				var rcLineArr = data.map(function(row){
					if((row.apprType == 'R' || row.apprType == 'C')) return row;
				})
				
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
				})
				
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
				})
				
				
				/* var list = data;
				var num = 1;
				$.each(list, function( index, value ){ //배열-> index, value
					var html = "";
					var apprTypeText = "";
					if( value.apprType != 'C' && value.apprType != 'R' ) {
						if( value.apprType == '2' ) {
							apprTypeText = "1차결재자";
						} 
						html += "<a href=\"javascript:delApprList('"+num+"')\"><img src=\"/resources/images/icon_del_file.png\"></a>";
						html += "<span>"+apprTypeText+"</span> "+value.userName;
						html += "<strong> "+value.gradeCodeName+"/"+value.deptCodeName+"</strong>"
						html += "<input type=\"hidden\" name=\"apprSelectUserId\" id=\"apprSelectUserId\" value=\""+value.targetUserId+"\">";
						html += "<input type=\"hidden\" name=\"apprSelectUserName\" id=\"apprSelectUserName\" value=\""+value.userName+"\">";
						$("#apprList"+num).html(html);
						num++;
					} else {
						if( value.apprType == 'R' ) {
							apprTypeText = "참조";
						} else if( value.apprType == 'C' ) {
							apprTypeText = "회람";
						}
						html += "<li id=\"refItem"+refCount+"\">";
						html += "<a href=\"javascript:delRefList('"+refCount+"')\"><img src=\"/resources/images/icon_del_file.png\"></a>";
						html += "<span>"+apprTypeText+"</span> "+value.userName;
						html += "<strong> "+value.gradeCodeName+"/"+value.deptCodeName+"</strong>"
						html += "<input type=\"hidden\" name=\"refId\" id=\"refId\" value=\""+value.targetUserId+"\">";
						html += "<input type=\"hidden\" name=\"refName\" id=\"refName\" value=\""+value.userName+"\">";
						html += "<input type=\"hidden\" name=\"refType\" id=\"refType\" value=\""+value.apprType+"\">";
						html += "</li>";
						$("#refList").append(html);
						refCount++;
					}
				}); */
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
		param['tbKey'] = $('input[name=row_chk]:checked').siblings('input[name=row_mmNo]').val();
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
			url: '/approval/approvalRequest',
			type: 'POST',
			dataType: 'json',
			data: param,
			success: function(data){
				if(data.status == 'S'){
					alert('원료변경요청서가 상신되었습니다.');
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
	//결재관련 함수 end
	
	
	function changeBomList(){
		$('#lab_loading').show();
		
		var chkCnt = $('input[name=row_chk]:checked').length;
		var mmNo = $('input[name=row_chk]:checked').siblings('input[name=row_mmNo]').val();
		var state = $('input[name=row_chk]:checked').siblings('input[name=row_state]').val();
		
		if(chkCnt == 0){
			alert("한영할 항목을 한 건 선택해주세요");
			$('#lab_loading').hide();
			return;
		}
		
		if(chkCnt > 1){
			alert("항목은 한 건만 선택해주세요");
			$('#lab_loading').hide();
			return;
		}
		
		if( !(state == 1 || state == 5 || state == 6) ){
			alert("BOM 반영을 할 수 없는 상태의 문서입니다. \n(BOM반영 대상: 승인, BOM 반영 오류, BOM 반영 미완결)");
			$('#lab_loading').hide();
			return;
		}
		
		var stateText = '';
		var itemText = '';
		
		$.ajax({
			url: '/material/changeBomList',
			type: 'post',
			data: { mmNo: mmNo },
			success: function(data){
				console.log(data);
				var state = data.state;
				
				
				switch (state) {
				case '4':
					stateText = 'BOM 반영이 완료되었습니다.';
					break;
				case '5':
					stateText = 'BOM 실패했습니다.';
					for(var i=0; i<data.tables.IT_RETURN.length; i++){
						var material = data.tables.IT_RETURN[i];
						
						if(material.COM != "S")
							itemText += '\n' + material.MATNR + '_' + material.WERKS + '_'+ material.STLAL + ' - ' + material.MESSAGE;						
					}
					break;
				case '99':
					stateText = 'BOM 반영 실행 중 시스템 오류가 발생했습니다.';
					stateText += '\n시스템 담당자에게 문의하세요'; 
				default:
					break;
				}
			},
			error: function(a,b,c){
				alert('BOM 반영 오류');
				//console.log(a,b,c)
				//$('#lab_loading').hide();
			},
			complete: function(){
				$('#lab_loading').hide();
				var alertStr = stateText;
				alertStr = itemText.length > 0 ? stateText + '\n' + itemText : stateText;
				
				alert(alertStr);
				loadList();
			}
		})
	}
	
	function checkOnly(e){
		for(var i=0; i<document.getElementsByName('row_chk').length; i++){
			element = document.getElementsByName('row_chk')[i];
			element.checked = false;
		}
		
		e.target.checked = true;
	}
	
	function approvalDetail( tbKey, tbType ) {
		var url = "";
		var mode = "";
		url = "/approval/approvalInfoPopup?tbKey="+tbKey+"&tbType="+tbType;
		mode = "width=1100, height=300, left=100, top=50, scrollbars=yes";
		
		window.open(url, "ApprovalPopup", mode );
	}
	
</script>

<input type="hidden" name="pageNo" id="pageNo" value="${paramVO.pageNo}">
<input type="hidden" name="imNo" id="imNo" value="">
<div class="wrap_in" id="fixNextTag">
	<span class="path">자재 변경관리&nbsp;&nbsp;
		<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;
		<a href="#">${strUtil:getSystemName()}</a>
	</span>
	<section class="type01">
		<!-- 상세 페이지  start-->
		<h2 style="position: relative">
			<span class="title_s">Material Change Control</span> <span class="title">자재 변경관리</span>
			<div class="top_btn_box">
				<ul>
					<li>
						<button class="btn_circle_bom" onClick="changeBomList()">&nbsp;</button>
						<button class="btn_circle_wirte_dark" onClick="openMtchDialog();">&nbsp;</button>
					</li>
				</ul>
			</div>
		</h2>
		<div class="group01">
			<div class="title">
				<!--span class="txt">연구개발시스템 공지사항</span-->
			</div>
			<!-- 
			<div class="tab02">
				<ul>
					<a href="/material/list"><li class="">자재 코드</li></a>
					<a href="/material/changeList"><li class="select">자재 코드 변경</li></a>
				</ul>
			</div>
			-->
			<div class="tab02">
				<ul>
					<a href="/material/list"><li class="">자재관리</li></a>
					<a href="/material/changeList"><li class="change select">변경관리</li></a>
				</ul>
			</div>
			<div class="search_box">
				<ul style="border-top:none">
					<li>
						<dt>공장</dt>
						<dd>
							<div class="selectbox" style="width: 100px;">
								<label for="searchCompany" id="searchCompany_label">전체</label>
								<select name="searchCompany" id="searchCompany" onChange="companyChange('searchCompany','searchPlant')">
									<option value="">전체</option>
									<c:forEach items="${company}" var="com">
										<option value="${com.companyCode}">${com.companyName}</option>
									</c:forEach>
								</select>
							</div>
							<div class="selectbox ml5" style="width: 180px;">
								<label for="searchPlant" id="searchPlant_label">전체</label> <select name="searchPlant" id="searchPlant">
								</select>
							</div>
						</dd>
					</li>
					
					<li>
						<dt>표시수</dt>
						<dd>
							<div class="selectbox" style="width: 100px;">
								<label for="viewCount" id="viewCount_label">선택</label> <select name="viewCount" id="viewCount">
									<option value="">선택</option>
									<option value="10">10</option>
									<option value="20">20</option>
									<option value="50">50</option>
									<option value="100">100</option>
								</select>
							</div>
						</dd>
					</li>
					
					<li>
						<dt>키워드</dt>
						<dd>
							<div class="selectbox" style="width: 100px;">
								<label for="searchType" id="searchType_label">선택</label> <select name="searchType" id="searchType">
									<option value="" <c:if test="${paramVO.searchType == '' or paramVO.searchType == null }">selected</c:if>>선택</option>
									<option value="mmNo" <c:if test="${paramVO.searchType != null and paramVO.searchType == 'mmNo' }">selected</c:if>>고유번호</option>
									<option value="preSapCode" <c:if test="${paramVO.searchType != null and paramVO.searchType == 'preSapCode' }">selected</c:if>>과거 자재코드</option>
									<option value="postSapCode" <c:if test="${paramVO.searchType != null and paramVO.searchType == 'postSapCode' }">selected</c:if>>변경 자재코드</option>
									<option value="preName" <c:if test="${paramVO.searchType != null and paramVO.searchType == 'preName' }">selected</c:if>>과거 자재명</option>
									<option value="postName" <c:if test="${paramVO.searchType != null and paramVO.searchType == 'postName' }">selected</c:if>>변경 자재명</option>
									<option value="state" <c:if test="${paramVO.searchType != null and paramVO.searchType == 'state' }">selected</c:if>>상태</option>
									<option value="regUserName" <c:if test="${paramVO.searchType != null and paramVO.searchType == 'regUserName' }">selected</c:if>>작성자</option>
								</select>
							</div>
							<input type="text" name="searchValue" id="searchValue" value="${paramVO.searchValue}" style="width: 180px; margin-left: 5px;">
						</dd>
					</li>
				</ul>
				<div class="fr pt5 pb10">
					<button type="button" class="btn_con_search" onClick="javascript:loadList();">
						<img src="/resources/images/btn_icon_search.png" style="vertical-align: middle;" /> 검색
					</button>
					<button type="button" class="btn_con_search" onClick="javascript:searchClear();">
						<img src="/resources/images/btn_icon_refresh.png" style="vertical-align: middle;" /> 검색 초기화
					</button>
					<button class="btn_con_search" onclick="openAppr();">
						<img src="/resources/images/icon_s_approval.png" style="vertical-align: middle;"> 자재변경 결재상신
					</button>
				</div>
			</div>
			<div class="main_tbl">
				<table class="tbl01">
					<colgroup>
						<col width="40px">
						<col width="5%">
						<col width="10%">
						
						<col width="8%">
						<col width="3%">
						<col width="8%">
						
						<col/>
						<col width="3%">
						<col/>
						
						<col width="10%">
						<col width="8%">
						<col width="10%">
					</colgroup>
					<thead>
						<tr>
							<th></th>
							<th>고유번호</th>
							<th>공장</th>
							<th>과거 자재코드</th>
							<th></th>
							<th>변경 자재코드</th>
							<th>과거 자재명</th>
							<th></th>
							<th>변경 자재명</th>
							<th>상태</th>
							<th>작성자</th>
							<th>등록/변경일</th>
						<tr>
					</thead>
					<tbody id="list">
						<tr><td align='center' colspan='12'>조회중입니다.</td></tr>
					</tbody>
				</table>
				<div id="list_page" class="page_navi mt10"></div>
			</div>
			<div class="btn_box_con">
				<button class="btn_admin_red" onclick="changeBomList()">BOM 반영</button>
				<button class="btn_admin_navi" onClick="openMtchDialog()">변경요청서 작성</button>
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
									<option value="${com.companyCode}" "${status.index == 0 ? 'selected' : ''}">${com.companyName}</option>
								</c:forEach>
							</select>
							<label for="mtch_company">${company[0].companyName}</label>
						</div>
						<div class="selectbox ml5" style="width: 150px;">
							<select id="mtch_plant">
								<option selected>전체</option>
							</select>
							<label for="mtch_plant">전체</label>
						</div>
					</dd>
				</li>
				<li>
					<dt style="width: 35%;">기존 자재코드</dt>
					<dd style="width: 65%;">
						<input id="preSapCode" type="text" class="req fl" style="width: 258px;" placeholder="기존 자재코드 입력" onkeyup="bindDialogEnter(event)"/>
						<button class="btn_code_search2" style="border-bottom: none; margin-left: 5px;" onclick="openMaterialPopup(this)"></button>
					</dd>
				</li>
				<li>
					<dt style="width: 35%;">신규 자재코드</dt>
					<dd style="width: 65%;">
						<input id="postSapCode" type="text" style="width: 258px;" class="req fl" placeholder="신규 자재코드 입력 "  onkeyup="bindDialogEnter(event)"/>
						<button class="btn_code_search2" style="border-bottom: none; margin-left: 5px;" onclick="openMaterialPopup(this)"></button>
					</dd>
				</li>
				<li>
					<dt style="background-image: none; width: 35%;"></dt>
					<dd style="width: 65%;">
						- BOM 반영은 <span class="font05">결재 완료</span> 후 실행가능합니다.
					</dd>
				</li>
			</ul>
			<!-- 일괄 변경 클릭 후 변경시간이 오래걸리면 오래걸릴수 있다는 알림/ 1231건 변경완료되었습니다. 알림 -->
			<div class="btn_box_con">
				<!-- <button class="btn_admin_sky" onclick="submitMtch('all')">자재코드 일괄 변경</button> -->
				<button class="btn_admin_navi" onclick="submitMtch('part')">자재코드 변경</button>
			</div>
		</div>
	</div>
</div>
<!--  자재 코드 변경 레이어 close-->

<!--  자재 검색 레이어 start -->
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
				<div id="matNextPrevDiv" class="page_navi mt10">
					<button class="btn_code_left01" onclick="searchMaterial('prevPage')"></button>
					<button class="btn_code_right02" onclick="searchMaterial('nextPage')"></button>
				</div>
			</div>
		</div>
	</div>
</div>
<!--  자재 검색 레이어 close -->

<!-- 결재문서 생성레이어 start -->
<div class="white_content" id="dialog_approval">
	<div class="modal positionCenter" style="width:1000px; height: 520px;">
		<h5 style="position:relative">
			<span class="title">원료변경 결재 상신</span>
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

<!-- Builder 개발서버 반영 원복 재실행을 위한 주석 추가 -->