<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ page session="false" %>
<%@ page import="kr.co.aspn.util.*" %> 
<%
	String userGrade = UserUtil.getUserGrade(request);
	String userDept = UserUtil.getDeptCode(request);
	String userTeam = UserUtil.getTeamCode(request);
	String isAdmin = UserUtil.getIsAdmin(request);
%>
<title>품목제조 보고서</title>
<link href="/resources/js/jquery.auto-complete.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="/resources/js/jquery.auto-complete.js"></script>
<script type="text/javascript">
var isValid ;
$(document).ready(function(){
	loadCompany('searchCompany');
	loadList('1');
});

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

function loadList( pageNo ) {
	var URL = "../manufacturingNo/manufacturingNoListAjax";
	var viewCount = $("#viewCount").selectedValues()[0];
	if( viewCount == '' ) {
		viewCount = "10";
	}
	
	if( $("#searchType").selectedValues()[0] == 'NO' ) {
		var regexp = /^[0-9]*$/
		if( !regexp.test($("#searchValue").val()) ) {
			alert("품목번호는 숫자만 입력가능합니다.");
			$("#searchValue").val("");
			$("#searchValue").focus();
			return;
		}
	}
	$.ajax({
		type:"POST",
		url:URL,
		data:{
				"searchCompany":$("#searchCompany").selectedValues()[0],
				"searchPlant":$("#searchPlant").selectedValues()[0],
				"searchType":$("#searchType").selectedValues()[0],
				"searchState":$("#searchState").selectedValues()[0],
				"searchValue":$("#searchValue").val(),
				"viewCount":viewCount,
				"pageNo":pageNo
		},
		dataType:"json",
		success:function(data) {
			var html = "";
			if( data.totalCount > 0 ) {
				$("#list").html(html);
				data.manufacturingNoList.forEach(function (item) {
					var productCode = item.productCodes.split(',');
					
							html += "<tr>"
							html += "	<td>"+item.plantName+"</td>";
							html += "	<td>"+item.manufacturingNo+"</td>";
							html += "	<td>"+nvl(item.keepConditionName,"")+"</td>";
							html += "	<td><a href=\"#\" onClick=\"goView('"+item.seq+"')\">"+item.manufacturingName+"</a>";
							html += "	<br/>("+nvl(item.sellDate,"")+")";
							html += "	</td>";
							html += "	<td>";
							for( var i = 0 ; i < productCode.length ; i++ ) {
								if( i != 0 ) {
									html += "<div style='margin-top:3px;'>";
								} else {
									html += "<div>";
								}
								html += productCode[i]+"</div>";
							}
							html += "	</td>";
							if( item.fmNo != '' && item.fmNo != null ) {
							<% if( (isAdmin != null && "Y".equals(isAdmin)) || "dept1".equals(userDept) || "dept2".equals(userDept)|| "dept3".equals(userDept) || "dept4".equals(userDept) || "dept5".equals(userDept) || "dept6".equals(userDept) || "dept10".equals(userDept) || "dept11".equals(userDept) || "dept12".equals(userDept) || "dept13".equals(userDept)) { %>
								html += "	<td><a href=\"javascript:fileDownload('"+item.fmNo+"')\"><img src=\"/resources/images/icon_file01.png\" style=\"vertical-align:middle;\"/></td>";
							<% } else { %>
							html += "	<td>&nbsp;</td>";
							<%
								}
							%>
							} else {
								html += "	<td>&nbsp;</td>";
							}
							html += "	<td>"+item.userName+"</td>";
							html += "	<td>"+item.regDate+"</td>";
							html += "	<td>"+item.regTypeName+"</td>";
							html += "</tr>"
				});				
			} else {
				$("#list").html(html);
				html += "<tr><td align='center' colspan='8'>데이터가 없습니다.</td></tr>";
			}
			$("#list").html(html);
			$('.page_navi').html(data.navi.prevBlock+data.navi.pageList+data.navi.nextBlock);
			$('#pageNo').val(data.navi.pageNo);
		},
		error:function(request, status, errorThrown){
			var html = "";
			$("#list").html(html);
			html += "<tr><td align='center' colspan='8'>오류가 발생하였습니다.</td></tr>";
			$("#list").html(html);
			$('.page_navi').html(data.navi.prevBlock+data.navi.pageList+data.navi.nextBlock);
			$('#pageNo').val(data.navi.pageNo);
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
			$("#companyNo_li").hide();
			$("#companyNo_span").html("");
			$("#companyNo").val("");
		},
		error:function(request, status, errorThrown){
				alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
		}			
	});
}

function loadPlant() {
	var URL = "../common/plantListAjax";
	$.ajax({
		type:"POST",
		url:URL,
		data:{
		},
		dataType:"json",
		async:false,
		success:function(data) {
			var list = data.RESULT;
			var html = "";
			$("#create_plant_list").html(html);
			var count = 0
			$.each(list, function( index, value ){ //배열-> index, value
				html += "	<input type=\"checkbox\" name=\"createPlant\" id=\"plant_"+value.plantCode+"\" value=\""+value.plantCode+"\"><label for=\"plant_"+value.plantCode+"\"><span></span>"+value.plantName+"("+value.plantCode+")</label>";
				count++;
				if( count != 0 && count % 4 == 0 ) {
					html += "<br/>";
				}
				
			});
			$("#create_plant_list").html(html);
			$("#create_plant_li").show();
		},
		error:function(request, status, errorThrown){
				alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
		}			
	});
}

function goInsertForm() {
	loadCompany('company');
	loadCodeList( "PRODCAT1", "productType1" );
	loadCodeList( "KEEPCONDITION", "keepCondition" );
	loadCodeList( "STERILIZATION", "sterilization" );
	loadCodeList( "ETCDISPLAY", "etcDisplay" );
	$("#keepConditionText").hide();
	$("#companyNo_li").hide();
	$("#companyNo_span").html("");
	$("#companyNo").val("");
	openDialog('open');
}

function oemCheck() {
	if( $("input:checkbox[name=referral]").is(":checked") == false && $("input:checkbox[name=oem]").is(":checked") == false ) {
		$("#create_plant_li").hide();
		$("#create_plant_list").html("");
	} else {
		if($("#create_plant_li").is(":visible") == false ) {
			loadPlant();	
		}
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
			if( groupCode == 'STERILIZATION' || groupCode == 'ETCDISPLAY' ) {
				$("#"+objectId).addOption("", "선택안함", false);
				$("#label_"+objectId).html("선택안함");
			} else {
				$("#"+objectId).addOption("", "전체", false);
				$("#label_"+objectId).html("전체");
			}
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

function changeKeepCondition() {
	if( $("#keepCondition").selectedValues()[0] == '7' ) {
		$("#keepConditionText").show();
	} else {
		$("#keepConditionText").val("");
		$("#keepConditionText").hide();
	}
}

function goInsert() {
	$("#create").attr('disabled', true);
	if( !chkNull($("#company").selectedValues()[0]) ) {
		alert("공장을 선택하여 주세요.");
		$("#company").focus();
		$("#create").attr('disabled', false);
		return;
	} else if( !chkNull($("#plant").selectedValues()[0]) ) {
		alert("공장을 선택하여 주세요.");
		$("#plant").focus();
		$("#create").prop('disabled', false);
		return;
	} else if( !chkNull($("#licensingNo").selectedValues()[0]) ) {
		alert("공장 인허가번호를 선택하여 주세요.");
		$("#licensingNo").focus();
		$("#create").prop('disabled', false);
		return;
	} else if( !chkNull($("#manufacturingName").val()) ) {
		alert("품목명을 입력해주세요.");
		$("#manufacturingName").focus();
		$("#create").prop('disabled', false);
		return;
	} else if( $("#isValid").val() == 'N' ) {
		alert("품목명 확인을 해주세요.");
		$("#create").prop('disabled', false);
		return;
	} else if( $("#manufacturingName").val() != $("#manufacturingName_temp").val() ) {
		alert("품목명 확인을 해주세요.");
		$("#create").prop('disabled', false);
		return;
	} else if( !chkNull($("#productType1").selectedValues()[0]) ) {
		alert("식품유형을 선택해주세요.");
		$("#productType1").focus();
		$("#create").prop('disabled', false);
		return;
	} else if( !chkNull($("#productType2").selectedValues()[0]) ) {
		alert("식품유형을 선택해주세요.");
		$("#productType2").focus();
		$("#create").prop('disabled', false);
		return;
	} else if( !chkNull($("#keepCondition").selectedValues()[0]) ) {
		alert("보관조건을 선택해주세요.");
		$("#keepCondition").focus();
		$("#create").prop('disabled', false);
		return;
	} else if( $("#keepCondition").selectedValues()[0] == '7' && !chkNull($("#keepConditionText").val()) ) {
		alert("보관조건을 입력해주세요.");
		$("#keepConditionText").focus();
		$("#create").prop('disabled', false);
		return;
	} else if( !chkNull($("#sellDate").val()) ) {
		alert("소비기한을 입력해주세요.");
		$("#sellDate").focus();
		$("#create").prop('disabled', false);
		return;
	} /*else if( $("#mailing").selectedValues().length == 0 ) {
		alert("메일 전송 담당자를 선택해주세요.");
		$("#searchUser").focus();
		return;
	}*/else {
		if(confirm("품목제조 보고서번호를 발급하시겠습니까?")){
			var referral = "N";
			var oem = "N";
			if($('input:checkbox[name="referral"]').is(':checked')) {
				referral = "Y";
			}
			if($('input:checkbox[name="oem"]').is(':checked')) {
				oem = "Y";
			}
			var plantArray = new Array();
			$('input:checkbox[name="createPlant"]').each(function() {
			      if(this.checked){//checked 처리된 항목의 값
			    	  plantArray.push(this.value);
			      }
			});
			var URL = "../manufacturingNo/insertAjax";
			$.ajax({
				type:"POST",
				url:URL,
				traditional : true,
				data:{"companyCode":$("#company").selectedValues()[0],
					"plantCode": $("#plant").selectedValues()[0],
					"licensingNo": $("#licensingNo").selectedValues()[0],
					"manufacturingName": $("#manufacturingName").val(),
					"productType1": $("#productType1").selectedValues()[0],
					"productType2": $("#productType2").selectedValues()[0],
					"productType3": $("#productType3").selectedValues()[0],
					"sterilization": $("#sterilization").selectedValues()[0],
					"etcDisplay": $("#etcDisplay").selectedValues()[0],
					"keepCondition": $("#keepCondition").selectedValues()[0],
					"keepConditionText": $("#keepConditionText").val(),
					"sellDate": $("#sellDate").val(),
					"referral": referral,
					"oem": oem,
					"createPlant": plantArray,
					"mailing": $("#mailing").selectedValues(),
					"comment": $("#comment").val()
				},
				dataType:"json",
				success:function(result) {
					if( result.status == 'success') {
						alert("품목제조 보고서 번호 "+result.msg+"가 생성되었습니다.");
						goCancel();
						loadList('1');
					} else if( result.status == 'fail') {
						alert(result.msg);
					} else {
						alert(result.msg+"오류가 발생하였습니다.\n다시 시도하여 주세요.");
					}
					$("#create").prop('disabled', false);
				},
				error:function(request, status, errorThrown){
					alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
					$("#create").prop('disabled', false);
				}			
			});	
		} else {
			$("#create").prop('disabled', false);
		}
	}
}

$(function() {
	$('#searchUser').autoComplete({
		minChars: 2,
		delay: 100,
		cache: false,
		source: function(term, response){
			$.ajax({
				type: 'POST',
				url: '../common/userListAjax2',
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
						var name = list[i].userName + " / " + list[i].userId + " / " + nvl(list[i].deptCodeName,'')+ " / " + nvl(list[i].teamCodeName,'');
						completes.push([name, list[i].userId]);  
					}
					response(completes);	
				}
			});
		},
		renderItem: function (item, search){
			console.log(search)
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

function addMailingList() {
	var usreId = $("#selectUserId").val();
	if( !chkNull(usreId) ) {
		alert("메일 발송 대상자를 선택해주세요.");
		return;
	} else {
		var usreInfo = $("#selectUserInfo").val();
		var jbSplit = usreInfo.split('/');
		$("#mailing").addOption(usreId, jbSplit[0], true);
		$('#searchUser').val("");
		$("#selectUserId").val("");
		$("#selectUserInfo").val("");
		loadText('mailing');
	}
}

function loadText(selectId) {
	var txt = "";
	$("#"+selectId).selectedOptions().each(function(){
			this.text;
			this.value;
			if( txt != '' ) {
				txt += "&nbsp;&nbsp;"+this.text+"&nbsp;<a href=\"javascript:deleteMailingUser( '"+this.value+"', '"+selectId+"' )\"><img src=\"/resources/images/icon_del.png\" style=\"vertical-align:middle;cursor:hand\"/></a>";
			} else {
				txt += this.text+"&nbsp;<a href=\"javascript:deleteMailingUser( '"+this.value+"', '"+selectId+"' )\"><img src=\"/resources/images/icon_del.png\" style=\"vertical-align:middle\"/></a>";
			} 
		}
	);
	if( $("#"+selectId).selectedOptions().length > 0 ) {
		$("#mailing_list_li").show();
	} else {
		$("#mailing_list_li").hide();
	}
	$("#mailing_list").html(txt);
}

function deleteMailingUser( id, selectId ) {
	$("#"+selectId).removeOption(id);
	loadText(selectId);
}

function checkName() {
	if( !chkNull($("#company").selectedValues()[0]) ) {
		alert("공장을 선택하여 주세요.");
		$("#company").focus();
		$('#isValid').val("N");
		return;
	} else if( !chkNull($("#plant").selectedValues()[0]) ) {
		alert("공장을 선택하여 주세요.");
		$("#plant").focus();
		$('#isValid').val("N");
		return;
	} else if( !chkNull($("#licensingNo").selectedValues()[0]) ) {
		alert("공장 인허가번호를 선택하여 주세요.");
		$("#licensingNo").focus();
		$('#isValid').val("N");
		return;
	} else if( !chkNull($('#manufacturingName').val()) ){
		alert("품목명을 입력해주세요.");
		$('#manufacturingName').focus();
		$('#manufacturingName_temp').val($('#manufacturingName').val());
		$('#isValid').val("N");
		return;
	} else {
		var URL = "../manufacturingNo/checkName";
 		$.ajax({
			type: 'post',
			url: URL, 
			data:{
				"companyCode":$("#company").selectedValues()[0],
				"plantCode": $("#plant").selectedValues()[0],
				"licensingNo": $("#licensingNo").selectedValues()[0],
				"manufacturingName":$('#manufacturingName').val()
			},
			dataType: 'json',
			async : true,
			success: function (data) {
				if(data.result == 'F'){
					$('#isValid').val("N");
					$('#manufacturingName_temp').val($('#manufacturingName').val());				
					return;
				} else {
					if(data.checkName > 0){
						$('#checkName').html('<font color="red" font-size="10px">이미 사용중인 품목명 입니다.</font>');
						$('#isValid').val("N");
						$('#manufacturingName_temp').val("");
					} else {
						$('#checkName').html('<font color="blue" font-size="10px">사용가능한 품목명입니다.</font>');
						$('#isValid').val("Y");
						$('#manufacturingName_temp').val($('#manufacturingName').val());
						isValid = true;
					}
				}
			},error: function(XMLHttpRequest, textStatus, errorThrown){
				$('#isValid').val("N");
				$('#manufacturingName_temp').val("");
			}
		});
	}
}

function goCancel() {
	goClear();
	closeDialog('open');
}

function goClear() {
	$("#company").removeOption(/./);
	$("#label_company").html("전체");
	$("#plant").removeOption(/./);
	$("#label_plant").html("전체");
	$("#licensingNo").removeOption(/./);
	$("#label_licensingNo").html("전체");
	$("#manufacturingName").val("");
	$("#manufacturingName_temp").val("");
	$("#isValid").val("N");
	$("#checkName").html("");
	$("#productType1").removeOption(/./);
	$("#label_productType1").html("전체");
	$("#productType2").removeOption(/./);
	$("#label_productType2").html("전체");
	$("#productType3").removeOption(/./);
	$("#label_productType3").html("전체");
	$("#sterilization").removeOption(/./)
	$("#label_sterilization").html("선택안함");
	$("#etcDisplay").removeOption(/./)
	$("#label_etcDisplay").html("선택안함");
	$("#keepCondition").removeOption(/./);
	$("#label_keepCondition").html("전체");
	$("#keepConditionText").val("");
	$("#keepConditionText").hide();
	$("#sellDate").val("");
	$("input:checkbox[name='referral']").prop("checked", false);
	$("input:checkbox[name='oem']").prop("checked", false);
	$("#searchUser").val("");
	$("#mailing").removeOption(/./);
	loadText('mailing');
	$("#create_plant_li").hide();
	$("#create_plant_list").html("");
	$("#comment").val("");
	$("#companyNo_li").hide();
	$("#companyNo_span").html("");
	$("#companyNo").val("");
}

function changeType() {
	if( $("#searchType").selectedValues()[0] == 'STATE') {
		$("#div_searchState").show();
		$("#searchState").selectOptions("");
		$("#label_searchState").html("전체");
		$("#searchValue").val("");
		$("#searchValue").hide();
	} else {
		$("#div_searchState").hide();
		$("#searchState").selectOptions("");
		$("#label_searchState").html("전체");
		$("#searchValue").val("");
		$("#searchValue").show();
	}
}

function goView(seq) {
	window.location.href="../manufacturingNo/view?seq="+seq;
}

function goSearch() {
	loadList('1');
}

function goSearchClear() {
	$("#searchCompany").selectOptions("");
	$("#label_searchCompany").html("전체");
	$("#searchPlant").removeOption(/./);
	$("#label_searchPlant").html("전체");
	$("#searchType").selectOptions("");
	$("#label_searchType").html("전체");
	$("#div_searchState").hide();
	$("#searchState").selectOptions("");
	$("#label_searchState").html("전체");
	$("#searchValue").val("");
	$("#searchValue").show();
	goSearch();
}

//페이징
function paging(pageNo){
	//location.href = '../material/list?' + getParam(pageNo);
	loadList(pageNo);
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

function goExcel() {
	$('#form').attr('action', '/manufacturingNo/excelDownload').submit();
}

//파일 다운로드
function fileDownload(fmNo){
	location.href="/file/fileDownload?fmNo="+fmNo;
}

function plantChange(){
	var URL = "../manufacturingNo/licensingNoListAjax";
	if( $("#company").selectedValues()[0] != '' && $("#plant").selectedValues()[0] != '') {	
		$.ajax({
			type:"POST",
			url:URL,
			data:{
				"companyCode" : $("#company").selectedValues()[0],
				"plantCode" : $("#plant").selectedValues()[0]
			},
			dataType:"json",
			async:false,
			success:function(data) {
				var list = data;
				$("#licensingNo").removeOption(/./);
				$("#licensingNo").addOption("", "전체", false);
				$("#label_licensingNo").html("전체");
				$.each(list, function( index, value ){ //배열-> index, value
					$("#licensingNo").addOption(value.licensingNo, value.licensingNo, false);
				});
				/* $("#companyNo_div").html("");
				$.each(list, function( index, value ){ //배열-> index, value
					$("#companyNo_li").show();
					$("#companyNo_span").html(value.companyNo);
					$("#companyNo").val(value.companyNo);
				}); */
			},
			error:function(request, status, errorThrown){
					alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
			}			
		});	
	}
}
</script>
<form name="form" id="form" method="post" action="">
<input type="hidden" name="pageNo" id="pageNo" value="${paramVO.pageNo}">
<div class="wrap_in" id="fixNextTag">
	<span class="path">품목제조 보고서&nbsp;&nbsp;
		<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;
		<a href="#">${strUtil:getSystemName()}</a>
	</span>
	<section class="type01">
	<!-- 상세 페이지  start-->
		<h2 style="position:relative"><span class="title_s">Items Manufacturing Report</span>
			<span class="title">품목제조보고서</span>
			<div  class="top_btn_box">
				<ul><li></li></ul>
			</div>
		</h2>
		<div class="group01" >
			<div class="title"><!--span class="txt">연구개발시스템 공지사항</span--></div>
			<div class="search_box" >
				<ul>
					<li>
						<dt>플랜트</dt>
						<dd>
							<div class="selectbox" style="width:150px;">  
								<label for="searchCompany" id="label_searchCompany">선택</label> 
								<select id="searchCompany" name="searchCompany"  onChange="companyChange('searchCompany','searchPlant')">
								</select>								
							</div>
							<div class="selectbox ml5" style="width:150px;">  
								<label for="plant"  id="label_searchPlant">전체</label> 
								<select name="searchPlant" id="searchPlant">
								</select>
							</div>
						</dd>
					</li>
					<li>
						<dt>키워드</dt>
						<dd>
							<div class="selectbox" style="width:120px;">  
								<label for="searchType" id="label_searchType">전체</label> 
								<select id="searchType" name="searchType" onChange="changeType()">
									<option value="">전체</option>
									<option value="NO">품목번호</option>
									<option value="NAME">품목명</option>
									<option value="STATE">상태</option>
								</select>								
							</div>
							<div class="selectbox ml5" style="width:100px;display:none" id="div_searchState">  
								<label for="searchState" id="label_searchState">전체</label> 
								<select id="searchState" name="searchState">
									<option value="">전체</option>
									<option value="N">사용중</option>
									<option value="Y">삭제</option>
								</select>								
							</div>
							<input type="text" name="searchValue" id="searchValue" class="ml5" style="width:180px;">
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
					<button type="button" class="btn_con_search" onClick="javascript:goExcel()">엑셀다운로드</button> 
					<button type="button" class="btn_con_search" onClick="javascript:goSearch()"><img src="/resources/images/btn_icon_search.png" style="vertical-align:middle;"/> 검색</button>
					<button type="button" class="btn_con_search" onClick="javascript:goSearchClear()"><img src="/resources/images/btn_icon_refresh.png" style="vertical-align:middle;"/> 검색 초기화</button>					
				</div>
			</div>
			<div class="main_tbl">
				<table class="tbl01">
					<colgroup>
						<col width="8%">
						<col width="10%">
						<col width="10%">
						<col />
						<col width="8%">
						<col width="10%">
						<col width="10%">
						<col width="10%">
						<col width="10%">
					</colgroup>
					<thead>
						<tr>
							<th>플랜트</th>
							<th>보고서 번호</th>
							<th>보관조건</th>
							<th>품목명</th>
							<th>제품코드</th>
							<th>품목제조보고서</th>
							<th>처리자</th>
							<th>처리일</th>
							<th>상태</th>							
						</tr>
					</thead>
					<tbody id="list">
					</tbody>
				</table>	
				<div class="page_navi  mt10">
				</div>
			</div>
			<div class="btn_box_con">
				<% if( (userGrade != null && ("2".equals(userGrade) || "3".equals(userGrade)|| "4".equals(userGrade) || "5".equals(userGrade) )) || (isAdmin != null && "Y".equals(isAdmin)) ) { %>
				<button type="button" class="btn_admin_red" onClick="javascript:goInsertForm();">품목제조보고서 번호 발급</button>
				<% } %>				
			</div>
			<hr class="con_mode"/><!-- 신규 추가 꼭 데려갈것 !-->
		</div>
	</section>
</div>
</form>
<!-- 자재 생성레이어 start-->
<div class="white_content" id="open">
	<div class="modal" style="	width: 700px;margin-left:-350px;height: 620px;margin-top:-300px;">
		<h5 style="position:relative">
			<span class="title">품목제조 보고서 발급</span>
			<div  class="top_btn_box">
				<ul>
					<li>
						<button type="button" class="btn_madal_close" onClick="goCancel()"></button>
					</li>
				</ul>
			</div>
		</h5>
		<div class="list_detail">
			<ul>
				<li class="pt10">
					<dt>공장</dt>
					<dd>
						<div class="selectbox req" style="width:150px;">  
							<label for="company" id="label_company"> 선택</label> 
							<select id="company" name="company" onChange="companyChange('company','plant')">
							</select>
						</div> 
						<div class="selectbox req ml5" style="width:150px;">  
							<label for="plant" id="label_plant"> 선택</label> 
							<select id="plant" name="plant" onChange="plantChange()">
							</select>
						</div>
						<div class="selectbox req ml5" style="width:150px;">  
							<label for="licensingNo" id="label_licensingNo"> 선택</label> 
							<select id="licensingNo" name="licensingNo">
							</select>
						</div>
					</dd>
				</li>
				<!--li id="companyNo_li" style="display:none">
					<dt>인허가번호</dt>
					<dd>
						<span id="companyNo_span"></span>
						<input type="hidden" name="companyNo" id="companyNo">
					</dd>
				</li-->
				<li>
					<dt>품목명</dt>
					<dd>
						<input type="text" class="req" style="width:250px;float:left;" placeholder="입력후 확인버튼을 눌러주세요." name="manufacturingName" id="manufacturingName">
						<button type="button" class="btn_small01 ml5" onClick="checkName()">확인</button>
						<input type="hidden" name="manufacturingName_temp" id="manufacturingName_temp">
						<input type="hidden" name="isValid" id="isValid" value="N">
						&nbsp;&nbsp;<span id="checkName"></span>
					</dd>
				</li>
				<li>
					<dt>식품유형</dt>
					<dd>
						<div class="selectbox req" style="width:160px;">  
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
					<dt>기타표시</dt>
					<dd>
						<div class="selectbox req" style="width:130px;">  
							<label for="sterilization" id="label_sterilization">선택안함</label> 
							<select id="sterilization" name="sterilization">
							</select>
						</div>
						<div class="selectbox req ml5" style="width:250px;">  
							<label for="etcDisplay" id="label_etcDisplay">선택안함</label> 
							<select id="etcDisplay" name="etcDisplay">
							</select>
						</div>
					</dd>
				</li>
				<li>
					<dt>보관조건</dt>
					<dd>
						<div class="selectbox req" style="width:180px;">  
							<label for="keepCondition" id="label_keepCondition"> 선택</label> 
							<select id="keepCondition" name="keepCondition" onChange="changeKeepCondition()">
							</select>
						</div>
						<input type="text" class="req" style="width:200px;" name="keepConditionText" id="keepConditionText">
					</dd>
				</li>
				<li>
					<dt>소비기한</dt>
					<dd>
						<input type="text" class="req" style="width:400px;" name="sellDate" id="sellDate">
					</dd>
				</li>
				<li>
					<dt>위탁/OEM</dt>
					<dd>
						<input type="checkbox" id="referral" name="referral" value="Y" onClick="oemCheck()"><label for="referral"><span></span>위탁</label>
						<input type="checkbox" id="oem" name="oem" value="Y" onClick="oemCheck()"><label for="oem"><span></span>OEM</label>
					</dd>
				</li>
				<li id="create_plant_li" style="display:none">
					<dt>생산 공장</dt>
					<dd id="create_plant_list">
					</dd>
				</li>
				<li>
					<dt>메일전송</dt>
					<dd>
						<input type="text" placeholder="메일발송자 이름 2자이상 입력후 선택" style="width:400px; float:left;" class="req" name="searchUser" id="searchUser">
						<input type="hidden" name="selectUserId" id="selectUserId">
						<input type="hidden" name="selectUserInfo" id="selectUserInfo">
						<button type="button" class="btn_small01 ml5" onClick="addMailingList()">추가</button>
						<select id="mailing" name="mailing"  multiple style="display:none">
						</select>
					</dd>
				</li>
				<li id="mailing_list_li" style="display:none">
					<dt>메일발송자</dt>
					<dd id="mailing_list">
					</dd>
				</li>
				<li>
					<dt>비고</dt>
					<dd>
						<textarea style="width:100%; height:40px" name="comment" id="comment"></textarea>
					</dd>
				</li>
			</ul>
		</div>
		<div class="btn_box_con">
			<% //if( (userGrade != null && "3".equals(userGrade)) || (isAdmin != null && "Y".equals(isAdmin)) ) { %>
			<button type="button" class="btn_admin_red" id="create" onclick="javascript:goInsert();">발급</button> 
			<% //} %>
			<button type="button" class="btn_admin_gray" onclick="goCancel()"> 취소</button>
		</div>
	</div>
</div>
<!-- 자재 생성레이어 close-->
