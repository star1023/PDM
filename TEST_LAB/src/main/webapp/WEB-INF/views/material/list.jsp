<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ taglib prefix="userUtil" uri="/WEB-INF/tld/userUtil.tld"%>
<%@ page session="false" %>
<title>자재관리</title>
<script type="text/javascript">
var PARAM = {
	isSample: '${paramVO.isSample}',
	searchCompany: '${paramVO.searchCompany}',
	searchPlant: '${paramVO.searchPlant}',
	searchType: '${paramVO.searchType}',
	searchValue: '${paramVO.searchValue}',
	pageNo: '${paramVO.pageNo}'
};

$(document).ready(function(){
	//document.location.href='#close';
	loadCompany('searchCompany');
	loadList('1');
	//if( '${paramVO.searchCompany}' != '') {
	//	loadPlant('${paramVO.searchCompany}');
	//}
	
	bindEnter('searchValue', goSearch);
});

function bindEnter(elementId, fn){
	$('#'+elementId).keyup(function(event){
		if(event.keyCode == 13){
			fn();
		}
	});
}

function loadList(pageNo) {
	var URL = "../material/materialListAjax";
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
	
	if( searchType =='itemCode' || searchType == 'itemCodeName' ) {
		var list_colgroup = "";
		var list_header = "";
		$("#list_colgroup").html(list_colgroup);
		list_colgroup +="<col width=\"7%\">";
		list_colgroup +="<col width=\"7%\">";
		list_colgroup +="<col width=\"10%\">";
		list_colgroup +="<col width=\"7%\">";
		list_colgroup +="<col width=\"20%\">";
		list_colgroup +="<col />";
		list_colgroup +="<col width=\"6%\">";
		list_colgroup +="<col width=\"6%\">";
		list_colgroup +="<col width=\"8%\">";
		list_colgroup +="<col width=\"15%\">";
		$("#list_colgroup").html(list_colgroup);
		$("#list_header").html(list_header);
		list_header += "<th>문서번호</th>";
		list_header += "<th>문서버전</th>";
		list_header += "<th>제조공정서번호</th>";
		list_header += "<th>제품코드</th>";
		list_header += "<th>제품명</th>";
		list_header += "<th>원료명</th>";
		list_header += "<th>백분율</th>";
		list_header += "<th>회사</th>";
		list_header += "<th>공장명</th>";	
		list_header += "<th>라인명</th>";		
		$("#list_header").html(list_header);
		$("#list").html("<tr><td align='center' colspan='10'>조회중입니다.</td></tr>");
	} else {
		var list_colgroup = "";
		var list_header = "";
		$("#list_colgroup").html(list_colgroup);
		list_colgroup +="<col width=\"10%\">";
		list_colgroup +="<col width=\"8%\">";
		list_colgroup +="<col />";
		list_colgroup +="<col width=\"8%\">";
		list_colgroup +="<col width=\"6%\">";
		list_colgroup +="<col width=\"20%\">";
		list_colgroup +="<col width=\"6%\">";
		list_colgroup +="<col width=\"15%\">";
		$("#list_colgroup").html(list_colgroup);
		$("#list_header").html(list_header);
		list_header += "<th>공장</th>";
		list_header += "<th>SAP코드</th>";
		list_header += "<th>자재명</th>";
		list_header += "<th>단가</th>";
		list_header += "<th>입고일</th>";
		list_header += "<th>공급업체</th>";
		list_header += "<th>작성일</th>";
		list_header += "<th>설정</th>";				
		$("#list_header").html(list_header);
		$("#list").html("<tr><td align='center' colspan='8'>조회중입니다.</td></tr>");
	}
	$("#list").html("<tr><td align='center' colspan='8'>조회중입니다.</td></tr>");
	$('.page_navi').html("");
	$.ajax({
		type:"POST",
		url:URL,
		data:{
				"isSample":isSample, "searchCompany":searchCompany, 
				"searchPlant":searchPlant, "searchType":searchType, 
				"searchValue":searchValue, "viewCount":viewCount, "pageNo":pageNo},
		dataType:"json",
		success:function(data) {
			var html = "";
			if( searchType =='itemCode' || searchType == 'itemCodeName' ) {
				if( data.totalCount > 0 ) {
					$("#list").html(html);
					data.materialList.forEach(function (item) {
						html += "<tr>"
						html += "	<td>"+nvl(item.docNo,'&nbsp;')+"</td>";
						html += "	<td>"+nvl(item.docVersion,'&nbsp;')+"</td>";
						html += "	<td>"+nvl(item.docNo,'&nbsp;')+"</td>";
						html += "	<td>"+nvl(item.itemCode,'&nbsp;')+"</td>";
						html += "	<td>"+nvl(item.productName,'&nbsp;')+"</td>";
						html += "	<td>"+nvl(item.itemName,'&nbsp;')+"</td>";
						html += "	<td>"+nvl(item.excRate,'&nbsp;')+"</td>";
						html += "	<td>"+nvl(item.companyName,'&nbsp;')+"</td>";
						html += "	<td>"+nvl(item.plantName,'&nbsp;')+"</td>";
						html += "	<td>"+nvl(item.lineName,'&nbsp;')+"</td>";
						html += "</tr>"					
					});				
				} else {
					$("#list").html(html);
					html += "<tr><td align='center' colspan='10'>데이터가 없습니다.</td></tr>";
				}			
				$("#list").html(html);
				$('.page_navi').html(data.navi.prevBlock+data.navi.pageList+data.navi.nextBlock);
				$('#pageNo').val(data.navi.pageNo);
			} else {
				if( data.totalCount > 0 ) {
					$("#list").html(html);
					data.materialList.forEach(function (item) {
						if( item.isHidden == 'Y' ) {
		                     html += "<tr class=\"m_visible\">"
		                  } if(item.statusCode == 'X') {
		                     html += "<tr class=\"m_visible\">"
		                  } if(item.isDelete == 'Y') {
		                     html += "<tr class=\"m_visible\">"
		                  } else {
		                     html += "<tr>"
		                  } 
						html += "	<td>"+nvl(item.plantName,'&nbsp;')+"</td>";
						html += "	<td>"+item.sapCode+"</td>";
						html += "	<td><div class=\"ellipsis_txt tgnl\"><a href=\"#\" onClick=\"javascript:loadView('"+item.imNo+"');\">"+item.name+"</a></div></td>";
						html += "	<td>"+item.price+"</td>";
						if( item.supplyDate == '0000-00-00' ) {
							html += "	<td>&nbsp;</td>";
						} else {
							html += "	<td>"+nvl(item.supplyDate,'&nbsp;')+"</td>";
						}
						html += "	<td>"+nvl(item.supplyCompany,'&nbsp;')+"</td>";
						html += "	<td>"+item.regDate+"</td>";
						html += "	<td>";
						html += "		<ul class=\"list_ul\">";
							if('${userUtil:getIsAdmin(pageContext.request)}' == 'Y'){
								if( item.isHidden == 'Y') {
									html += "			<li style=\"float:none; display:inline\"><button class=\"btn_doc\" onclick=\"javascript:goHidden('"+item.imNo+"', '"+item.sapCode+"', '"+item.isHidden+"');\"><img src=\"/resources/images/icon_doc13.png\"> 자재활성</button></li>";	
								} else {
									html += "			<li style=\"float:none; display:inline\"><button class=\"btn_doc\" onclick=\"javascript:goHidden('"+item.imNo+"', '"+item.sapCode+"', '"+item.isHidden+"');\"><img src=\"/resources/images/icon_doc14.png\"> 자재숨김</button></li>";
								}
								if( item.isSample == 'Y') {
									html += "			<li style=\"float:none; display:inline\"><button class=\"btn_doc\" onClick=\"javascript:goDelete('"+item.imNo+"')\"><img src=\"/resources/images/icon_doc04.png\"> 삭제</button></li>";		
								}
							}
							if( item.isSample != 'Y') {
								html += "			<li style=\"float:none; display:inline\"><button class=\"btn_doc\" onClick=\"javascript:goQnsPopup('"+item.sapCode+"')\"><img src=\"/resources/images/icon_doc01.png\"> Q&SH</button></li>";		
							}
						html += "		</ul>";
						html += "	</td>";
						html += "</tr>"					
					});				
				} else {
					$("#list").html(html);
					html += "<tr><td align='center' colspan='9'>데이터가 없습니다.</td></tr>";
				}			
				$("#list").html(html);
				$('.page_navi').html(data.navi.prevBlock+data.navi.pageList+data.navi.nextBlock);
				$('#pageNo').val(data.navi.pageNo);
			}
		},
		error:function(request, status, errorThrown){
			var html = "";
			$("#list").html(html);
			html += "<tr><td align='center' colspan='9'>오류가 발생하였습니다.</td></tr>";
			$("#list").html(html);
			$('.page_navi').html(data.navi.prevBlock+data.navi.pageList+data.navi.nextBlock);
			$('#pageNo').val(data.navi.pageNo);
		}			
	});	
}

/* //작성페이지 이동
function goInsrtForm(){
	window.location.href = "../material/insertForm";
}

//작성페이지 이동
function goMaterialCall(){
	var url = "../material/popupCallForm";
	var left = (window.screen.width - 1024) / 2;
    var top  = (window.screen.height - 768) / 2; 
	var iWindowFeatures = "width=550, height=250, toolbar=no,menubar=no,titlebar=no,status=no,resizable=yes, scrollbars=no, left="+left+",top="+top;
	window.open(url, "_blank", iWindowFeatures);

}

//조회
function goSearch(){
	$('#pageNo').val("1");
	$('#listForm').submit();
} 

//조회
function goView(imNo){
	window.location.href = "../material/view?imNo="+imNo+"&"+$.param(PARAM);
}*/

function goInsertForm() {
	$("#name").val("[임시]");
	$("#sapCode").val("");
	$("company").removeOption(/./);
	loadCompany('company');
	$("company").selectOptions("");
	$("plant").removeOption(/./);
	$("plant").selectOptions("");
	$("#price").val("");
	loadUnit();
	$("unit").selectOptions("");
	$("input:radio[name='type'][value='B']").prop('checked', true);
	$("#create").show();
	$("#update").hide();
}
//조회
function loadView(imNo){
	var URL = "../material/viewAjax";
	$.ajax({
		type:"POST",
		url:URL,
		data:{"imNo":imNo},
		dataType:"json",
		success:function(result) {
			var data = result.materialVO;
			if( data.imNo == '' ) {
				alert("삭제된 자재입니다.");
			} else {
				$("#viewMatName").html(data.name);
				$("#viewRegDate").html(data.regDate);
				$("#viewSapCode").html(data.sapCode);
				$("#viewCompany").html(data.companyName+"-"+data.plantName);
				$("#viewPrice").html(data.price+"/"+data.unit);
				$("#viewType").html(data.typeName);
				$("#viewSupplyDate").html(data.supplyDate);
				$("#viewSupplyCompany").html(data.supplyCompany);
				if( data.isSample == 'Y' ) {
					$("#delete").on('click', function(){
						goDelete(data.imNo);
						closeDialog("open3");
					});
					$("#updateForm").on('click', function(){
						URL = "../material/viewAjax";
						$.ajax({
							type:"POST",
							url:URL,
							data:{"imNo":data.imNo},
							dataType:"json",
							success:function(result) {
								var data = result.materialVO;
								if( data.imNo == '' ) {
									alert("삭제된 자재입니다.");
								} else {
									closeDialog("open3");
									$("#imNo").val(data.imNo);
									$("#name").val(data.name);
									$("#sapCode").val(data.sapCode);
									loadCompany('company');
									$("#company").selectOptions(data.company);
									companyChange('company','plant');
									$("#company").selectOptions(data.plant);
									$("#price").val(data.price);
									loadUnit();
									$("#unit").selectOptions(data.unit);
									$("input:radio[name='type'][value='"+data.type+"']").prop('checked', true);								$("#viewType").html(data.typeName);
									$("#create").hide();
									$("#update").show();
									openDialog("open");
								}
							},
							error:function(request, status, errorThrown){
								alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
							}			
						});	
					});
				} else {
					$("#delete").hide();
					$("#updateForm").hide();
				}
				
				openDialog("open3");
			}
		},
		error:function(request, status, errorThrown){
			alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
		}			
	});	
}

//작성페이지 이동
function goDelete(imNo){
	if(confirm("삭제후에는 복구할 수 없습니다. 삭제하시겠습니까? ")){
		//location.href = "../material/delete?mtNo="+mtNo;
		var URL = "../material/deleteAjax";
		$.ajax({
			type:"POST",
			url:URL,
			data:{"imNo":imNo},
			dataType:"json",
			success:function(data) {
				if(data.status == 'success'){
		        	alert("삭제되었습니다.");	
		        	loadList('1');
		        } else if( data.status == 'fail' ){
					alert(data.msg);
		        } else {
		        	alert("오류가 발생하였습니다.");
		        }
			},
			error:function(request, status, errorThrown){
				alert("오류가 발생하였습니다.");
			}			
		});	
	}
}

function goHidden(imNo, sapCode, isHidden){
	var str = "";
	var isHiddenValue = "N";
	
	if(isHidden == 'N'){
		str = sapCode +  " 자재를 숨기시겠습니까?\n(제품개발문서, 제품설계서에서 조회되지 않습니다.)";
		isHiddenValue = "Y";
	} else {
		str = sapCode + " 자재를 숨김 해제 하시겠습니까?\n(제품개발문서, 제품설계서에서 조회됩니다.)";
		isHiddenValue = "N";
	}
	
	if(confirm(str)){
		var URL = "../material/hiddenAjax";
		$.ajax({
			type:"POST",
			url:URL,
			data:{"imNo":imNo,"isHidden":isHiddenValue},
			dataType:"json",
			success:function(data) {
				if(data.status == 'success'){
		        	alert("변경되었습니다.");	
		        	loadList($("#pageNo").val());
		        } else if( data.status == 'fail' ){
					alert(data.msg);
		        } else {
		        	alert("오류가 발생하였습니다.");
		        }
			},
			error:function(request, status, errorThrown){
				alert("오류가 발생하였습니다.");
			}			
		});	
	}
}

function goUpdate() {
	if( !chkNull($("#name").val()) || $("#name").val() == "[임시]" ) {
		alert("자재명을 입력하여 주세요.");
		$("#name").focus();
		return;
	} else if ($("#name").val().indexOf("[임시]") == -1) {
		alert("자재명은 [임시]를 포함해야 합니다.");
		$("#name").val("[임시]"+$("#name").val());
		$("#name").focus();			
		return;
	} else if( !chkNull($("#sapCode").val()) ) {
		alert("SAP 코드를 입력하여 주세요.");
		$("#sapCode").focus();
		return;
	} else if( $("#company").selectedValues()[0] == '' ) {
		alert("회사를 선택하여 주세요.");
		$("#company").focus();
		return;
	} else if( $("#plant").selectedValues()[0] == '' ) {
		alert("공장을 선택하여 주세요.");
		$("#plant").focus();
		return;
	} else if( !chkNull($("#price").val()) ) {
		alert("단가를 입력하여 주세요.");
		$("#price").focus();
		return;
	} else if( $("#unit").selectedValues()[0] == '' ) {
		alert("단위를 선택하여 주세요.");
		$("#unit").focus();
		return;
	} else {
		URL = "../material/updateAjax";
		$.ajax({
			type:"POST",
			url:URL,
			data:{"imNo":$("#imNo").val() ,"name":$("#name").val() , "sapCode":$("#sapCode").val(),
				"company": $("#company").selectedValues()[0],"plant": $("#plant").selectedValues()[0],
				"price": $("#price").val(),"unit": $("#unit").selectedValues()[0],
				"type": $(":input:radio[name=type]:checked").val()						
			},
			dataType:"json",
			success:function(result) {
				if(result.status == 'success'){
		        	alert("수정되었습니다.");	
		        	loadList('1');
		        	clear();
		        	closeDialog("open3");
		        	closeDialog("open");
		        } else if( result.status == 'fail' ){
					alert(result.msg);
		        } else {
		        	alert("오류가 발생하였습니다.");
		        }
			},
			error:function(request, status, errorThrown){
				alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
			}			
		});	
	}
}

// 페이징
function paging(pageNo){
	//location.href = '../material/list?' + getParam(pageNo);
	loadList(pageNo);
}	

//파라미터 조회
function getParam(pageNo){
	PARAM.pageNo = pageNo || '${paramVO.pageNo}';
	return $.param(PARAM);
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
			$.each(list, function( index, value ){ //배열-> index, value
				$("#"+selectBoxId).addOption(value.plantCode, value.plantName, false);
			});
			
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
			$.each(list, function( index, value ){ //배열-> index, value
				$("#"+selectBoxId).addOption(value.companyCode, value.companyName, false);
			});
		},
		error:function(request, status, errorThrown){
				alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
		}			
	});
}

function loadPlant(company) {
	var URL = "../common/plantListAjax";
	$.ajax({
		type:"POST",
		url:URL,
		data:{
			"companyCode" : '${paramVO.searchCompany}'
		},
		dataType:"json",
		async:false,
		success:function(data) {
			var list = data.RESULT;
			$("#searchPlant").removeOption(/./);
			$.each(list, function( index, value ){ //배열-> index, value
				$("#searchPlant").addOption(value.plantCode, value.plantName, false);
			});
			$("#searchPlant").selectOptions('${paramVO.searchPlant}');
		},
		error:function(request, status, errorThrown){
				alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
		}			
	});
}

function loadUnit() {
	var URL = "../common/unitListAjax";
	$.ajax({
		type:"POST",
		url:URL,
		data:{
			
		},
		dataType:"json",
		async:false,
		success:function(data) {
			var list = data;
			$("#unit").removeOption(/./);
			$("#unit").addOption("", "전체", false);
			$.each(list, function( index, value ){ //배열-> index, value
				$("#unit").addOption(value.unitCode, value.unitName, false);
			});
		},
		error:function(request, status, errorThrown){
				alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
		}			
	});
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
	goSearch();
}

//입력확인
function goInsert(){
	if( !chkNull($("#name").val()) || $("#name").val() == "[임시]" ) {
		alert("자재명을 입력하여 주세요.");
		$("#name").focus();
		return;
	} else if ($("#name").val().indexOf("[임시]") == -1) {
		alert("자재명은 [임시]를 포함해야 합니다.");
		$("#name").val("[임시]"+$("#name").val());
		$("#name").focus();			
		return;
	} else if( !chkNull($("#sapCode").val()) ) {
		alert("SAP 코드를 입력하여 주세요.");
		$("#sapCode").focus();
		return;
	} else if( $("#company").selectedValues()[0] == '' ) {
		alert("회사를 선택하여 주세요.");
		$("#company").focus();
		return;
	} else if( $("#plant").selectedValues()[0] == '' ) {
		alert("공장을 선택하여 주세요.");
		$("#plant").focus();
		return;
	} else if( !chkNull($("#price").val()) ) {
		alert("단가를 입력하여 주세요.");
		$("#price").focus();
		return;
	} else if( $("#unit").selectedValues()[0] == '' ) {
		alert("단위를 선택하여 주세요.");
		$("#unit").focus();
		return;
	} else {
		var URL = "../material/materialCountAjax";
		$.ajax({
			type:"POST",
			url:URL,
			data:{"sapCode":$("#sapCode").val(),
				"company": $("#company").selectedValues()[0],
				"plant": $("#plant").selectedValues()[0]
			},
			dataType:"json",
			success:function(result) {
				if( result.RESULT >= 1) {
					alert("이미 존재하는 SAP코드입니다.");
				    return;
				} else {
					URL = "../material/insertAjax";
					$.ajax({
						type:"POST",
						url:URL,
						data:{"name":$("#name").val() , "sapCode":$("#sapCode").val(),
							"company": $("#company").selectedValues()[0],"plant": $("#plant").selectedValues()[0],
							"price": $("#price").val(),"unit": $("#unit").selectedValues()[0],
							"type": $(":input:radio[name=type]:checked").val()						
						},
						dataType:"json",
						success:function(result) {
							if(result.status == 'success'){
					        	alert("생성되었습니다.");	
					        	loadList('1');
					        	clear();
					        	closeDialog("open3");					        	
					        } else if( result.status == 'fail' ){
								alert(result.msg);
					        } else {
					        	alert("오류가 발생하였습니다.");
					        }
						},
						error:function(request, status, errorThrown){
							alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
						}			
					});	
				}
			},
			error:function(request, status, errorThrown){
				alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
			}			
		});	
	}
}

function goRfcCall(){
	if(  !chkNull($("#company2").selectedValues()[0]) ) {
		alert("회사를 선택해 주세요.");
		$("#company2").focus();
		return;
	} else if( !chkNull($("#sapCode2").val()) ) {
		alert("자재코드 입력하여 주세요.");
		$("#sapCode2").focus();
		return;
	} else {
		var URL = "../material/rfcCallAjax";
		$.ajax({
			type:"POST",
			url:URL,
			data:{"company":$("#company2").selectedValues()[0], "sapCode":$("#sapCode2").val()},
			dataType:"json",
			async:false,
			success:function(result) {
				if(result.status == 'success'){
					alert(result.msg);
					clear();
					loadList('1');
					closeDialog("open2");
		        } else if( result.status == 'fail' ){
					alert(result.msg);
		        } else {
		        	alert("오류가 발생하였습니다.");
		        }
			},
			error:function(request, status, errorThrown){
				alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
			}			
		});	
	}
}

function clear() {
	$("#name").val("[임시]");
	$("#sapCode").val(""),
	$("#company").selectOptions("");
	$("#company_label").html("선택");
	$("#plant").selectOptions("");
	$("#plant_label").html("선택");
	$("#price").val("");
	$("#unit").selectOptions("");
	$("#unit_label").html("선택");
	$("#sapCode2").val(""),
	$("#company2").selectOptions("");
	$("#company2_label").html("선택");
	$("#viewCount").selectOptions("");
	$("#viewCount").html("선택");
}

function goSearch() {
	loadList('1');
}

function goQnsPopup(sapCode){
	var url = 'https://qns.spc.co.kr/web/specification/rndsViewSpec.spc?MATERIAL_CD='+sapCode;
	
	var popupName = 'qnshPopup';
	var w=1100;
	var h=650;
	var winl = (screen.width-w)/2;
	var wint = (screen.height-h)/2;
	var option ='height='+h+',';
	option +='width='+w+',';
	option +='scrollbars=yes,';
	option +='resizable=no';
	
	//window.open(url, popupName, option);
	window.open(url, 'qnspopup', option);
}
</script>
<input type="hidden" name="pageNo" id="pageNo" value="${paramVO.pageNo}">
<input type="hidden" name="imNo" id="imNo" value="">
<div class="wrap_in" id="fixNextTag">
	<span class="path">자재관리&nbsp;&nbsp;
		<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;
		<a href="#">${strUtil:getSystemName()}</a>
	</span>
	<section class="type01">
	<!-- 상세 페이지  start-->
		<h2 style="position:relative"><span class="title_s">Material management</span>
			<span class="title">자재관리</span>
			<div  class="top_btn_box">
				<ul>
					<li>
						<button type="button" class="btn_circle_red" onClick="openDialog('open');javascript:goInsertForm();">&nbsp;</button>
					</li>
				</ul>
			</div>
		</h2>
		<div class="group01" >
			<div class="title"><!--span class="txt">연구개발시스템 공지사항</span--></div>
			<div class="tab02">
				<ul>
					<a href="/material/list"><li class="select">자재관리</li></a>
					<a href="/material/changeList"><li class="">변경관리</li></a>
				</ul>
			</div>
			<div class="search_box" >
				<ul style="border-top:none">
					<li>
						<dt>구분</dt>
						<dd >
							<!-- 초기값은 보통으로 -->
							 <input type="radio" name="isSample" id="r1" value=""   onclick="" <c:if test="${paramVO.isSample == '' or paramVO.isSample == null }">checked</c:if>/><label for="r1"><span></span>전체</label>
							 <input type="radio" name="isSample" id="r2" value="N"  onclick="" <c:if test="${paramVO.isSample != null and paramVO.isSample == 'N'  }">checked</c:if>/><label for="r2"><span></span>SAP</label>
							 <input type="radio" name="isSample" id="r3" value="Y" onclick="" <c:if test="${paramVO.isSample != null and paramVO.isSample == 'Y'  }">checked</c:if>/><label for="r3"><span></span>임시</label>
						</dd>
					</li>
					<li>
						<dt>공장</dt>
						<dd >
							<div class="selectbox" style="width:100px;">  
								<label for="searchCompany" id="searchCompany_label">전체</label> 
								<select name="searchCompany" id="searchCompany" onChange="companyChange('searchCompany','searchPlant')">
								</select>
							</div>
							<div class="selectbox ml5" style="width:180px;">  
								<label for="searchPlant" id="searchPlant_label">전체</label> 
								<select name="searchPlant" id="searchPlant">
								</select>
							</div>
						</dd>
					</li>
					<li>
						<dt>키워드</dt>
						<dd >
							<div class="selectbox" style="width:100px;">  
								<label for="searchType" id="searchType_label">선택</label> 
								<select name="searchType" id="searchType">
									<option value=""<c:if test="${paramVO.searchType == '' or paramVO.searchType == null }">selected</c:if>>선택</option>
									<option value="sapCode" <c:if test="${paramVO.searchType != null and paramVO.searchType == 'sapCode' }">selected</c:if>>SAP코드</option>
									<option value="name" <c:if test="${paramVO.searchType != null and paramVO.searchType == 'name' }">selected</c:if>>자재명</option>
									<option value="itemCode" <c:if test="${paramVO.searchType != null and paramVO.searchType == 'itemCode' }">selected</c:if>>원료코드</option>
									<option value="itemCodeName" <c:if test="${paramVO.searchType != null and paramVO.searchType == 'itemCodeName' }">selected</c:if>>원료명</option>
									<option value="regUserName" <c:if test="${paramVO.searchType != null and paramVO.searchType == 'regUserName' }">selected</c:if>>작성자</option>						
								</select>
							</div>
							<input type="text" name="searchValue" id="searchValue" value="${paramVO.searchValue}" style="width:180px; margin-left:5px;">
						</dd>
					</li>
					<li>
						<dt>표시수</dt>
						<dd >
							<div class="selectbox" style="width:100px;">  
								<label for="viewCount" id="viewCount_label">선택</label> 
								<select name="viewCount" id="viewCount">		
									<option value="">선택</option>													
									<option value="10">10</option>
									<option value="20">20</option>
									<option value="50">50</option>
									<option value="100">100</option>
								</select>
							</div>
						</dd>
					</li>
				</ul>
				<div class="fr pt5 pb10">
					<button type="button" class="btn_con_search" onClick="javascript:goSearch();"><img src="/resources/images/btn_icon_search.png" style="vertical-align:middle;"/> 검색</button>
					<button type="button" class="btn_con_search" onClick="javascript:searchClear();"><img src="/resources/images/btn_icon_refresh.png" style="vertical-align:middle;"/> 검색 초기화</button>					
				</div>
			</div>
			<div class="main_tbl">
				<table class="tbl01">
					<colgroup id="list_colgroup">
						<col width="8%">
						<col width="10%">
						<col width="8%">
						<col />
						<col width="8%">
						<col width="8%">
						<col width="20%">
						<col width="10%">
						<col width="15%">
					</colgroup>
					<thead id="list_header">
						<tr>
							<th>회사</th>
							<th>공장</th>
							<th>SAP코드</th>
							<th>자재명</th>
							<th>단가</th>
							<th>입고일</th>
							<th>공급업체</th>
							<th>작성일</th>
							<th>설정</th>
						<tr>
					</thead>
					<tbody id="list">						
					</tbody>
				</table>
				<div class="page_navi  mt10">
				</div>
			</div>
			<div class="btn_box_con"> 
				<button class="btn_admin_sky" onClick="openDialog('open2');javascript:loadCompany('company2');">자재 호출</button> 
				<button class="btn_admin_red" onclick="openDialog('open');javascript:goInsertForm();">자재 생성</button>
			</div>
	 		<hr class="con_mode"/><!-- 신규 추가 꼭 데려갈것 !-->
		</div>
	</section>
</div>

<!-- 자재 생성레이어 start-->
<div class="white_content" id="open">
	<div class="modal" style="	width: 700px;margin-left:-350px;height: 420px;margin-top:-200px;">
		<h5 style="position:relative">
			<span class="title">자재 생성</span>
			<div  class="top_btn_box">
				<ul>
					<li>
						<button class="btn_madal_close" onClick="closeDialog('open')"></button>
					</li>
				</ul>
			</div>
		</h5>
		<div class="list_detail">
			<ul>
				<li class="pt10">
					<dt>자재명</dt>
					<dd>
						<input type="text" value="[임시]" class="req" style="width:302px;" name="name" id="name"  /> [임시] 로 시작될 수 있도록 입력 
					</dd>
				</li>
				<li>
					<dt>SAP 코드</dt>
					<dd>
						<input type="text"  style="width:302px;" class="req" name="sapCode" id="sapCode" placeholder="임시코드 5자리를 입력해주세요"/>
					</dd>
				</li>
				<li>
					<dt>공장</dt>
					<dd>
						<div class="selectbox req" style="width:147px;">  
							<label for="company" id="company_label"> 선택</label> 
							<select id="company" name="company" onChange="companyChange('company','plant')">
							</select>
						</div>
						<div class="selectbox req ml5" style="width:147px;">  
							<label for="plant" id="plant_label"> 선택</label> 
							<select id="plant" name="plant">
							</select>
						</div>
					</dd>
				</li>
				<li>
					<dt>단가</dt>
					<dd>
						<input type="text" class="req" style="width:149px;" name="price" id="price">
					</dd>
				</li>
				<li>
					<dt>단위</dt>
					<dd>
						<div class="selectbox req" style="width:147px;">  
							<label for="unit" id="unit_label"> 선택</label> 
							<select id="unit" id="unit">
							</select>
						</div>
					</dd>
				</li>
				<li>
					<dt>구분</dt>
					<dd>
						<input type="radio" name="type" id="type1" value="B" checked/ ><label for="type1"><span></span>원료</label>
						<input type="radio" name="type" id="type2" value="R"/><label for="type2"><span></span>재료</label>
					</dd>
				</li>
			</ul>
		</div>
		<div class="btn_box_con">
			<button class="btn_admin_red" id="create" onclick="javascript:goInsert();">자재 생성</button> 
			<button class="btn_admin_red" id="update" onclick="javascript:goUpdate();" style="display:none">자재 수정</button>
			<button class="btn_admin_gray" onclick="closeDialog('open')"> 취소</button>
		</div>
	</div>
</div>
<!-- 자재 생성레이어 close-->
<!-- 자재 호출레이어 start-->
<div class="white_content" id="open2">
	<div class="modal" style="	width: 500px;margin-left:-250px;height: 300px;margin-top:-150px;">
		<h5 style="position:relative">
			<span class="title">자재 호출</span>
			<div  class="top_btn_box">
				<ul>
					<li>
						<button class="btn_madal_close" onClick="closeDialog('open2')"></button>
					</li>
				</ul>
			</div>
		</h5>
		<div class="list_detail">
			<ul>
				<li class="pt10">
					<dt>회사명</dt>
					<dd>
						<div class="selectbox req" style="width:147px;">  
							<label for="company2" id="company2_label"> 선택</label> 
							<select id="company2" name="company2">
							</select>
						</div> 
					</dd>
				</li>
				<li>
					<dt>자재코드</dt>
					<dd>
						<input type="text"  style="width:302px;" class="req" name="sapCode2" id="sapCode2" onKeyPress="if(window.event.keyCode == 13) { goRfcCall();}" />
					</dd>
				</li>
			</ul>
		</div>
		<div class="btn_box_con">
			<button class="btn_admin_red"onclick="javascript:goRfcCall();">적용</button> 
			<button class="btn_admin_gray"onclick="closeDialog('open2')"> 취소</button>
		</div>
	</div>
</div>
<!-- 자재 호출 레이어 close-->
<!-- 자재 상세보기레이어 start-->
<div class="white_content" id="open3">
	<div class="modal" style="	width: 700px;margin-left:-350px;height: 480px;margin-top:-200px;">
		<h5 style="position:relative">
			<span class="title">자재 상세보기</span>
			<div  class="top_btn_box">
				<ul>
					<li>
						<button class="btn_madal_close" onClick="closeDialog('open3')"></button>
					</li>
				</ul>
			</div>
		</h5>
		<div class="list_detail">
			<ul>
				<li class="pt10">
					<dt>자재명</dt>
					<dd id="viewMatName">						 
					</dd>
				</li>
				<li>
					<dt>생성일</dt>
					<dd id="viewRegDate">						 
					</dd>
				</li>
				<li>
					<dt>SAP 코드</dt>
					<dd id="viewSapCode">						
					</dd>
				</li>
				<li>
					<dt>공장</dt>
					<dd id="viewCompany">						
					</dd>
				</li>
				<li>
					<dt>단가/단위</dt>
					<dd id="viewPrice">						
					</dd>
				</li>
				<li>
					<dt>구분</dt>
					<dd id="viewType">
					</dd>
				</li>
				<li>
					<dt>입고일</dt>
					<dd id="viewSupplyDate">
					</dd>
				</li>
				<li>
					<dt>공급업체</dt>
					<dd id="viewSupplyCompany">
					</dd>
				</li>
			</ul>
		</div>
		<div class="btn_box_con">
			<button class="btn_admin_red" id="updateForm">자재 수정</button> 
			<button class="btn_admin_gray" id="delete"> 삭제</button>
			<button class="btn_admin_gray"onclick="closeDialog('open3')"> 취소</button>
		</div>
	</div>
</div>
<!-- 자재 생성레이어 close-->


<!-- Builder 개발서버 반영 원복 재실행을 위한 주석 추가 -->