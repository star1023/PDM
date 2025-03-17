<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="userUtil" uri="/WEB-INF/tld/userUtil.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="kr.co.aspn.util.*" %> 
<%@ page session="false" %>
<title>품목제조보고서 등록</title>
<script type="text/javascript">
var isValid ;
$(document).ready(function(){
	loadCompany('company');
	loadCompany('searchCompany');
	loadCodeList( "PRODCAT1", "productType1" );
	loadCodeList( "KEEPCONDITION2", "keepCondition" );
	loadCodeList( "STERILIZATION2", "sterilization" );
	//loadCodeList( "ETCDISPLAY", "etcDisplay" );
	loadPackage("PACKAGE_UNIT");
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
			$("#licensingNo").removeOption(/./);
			$("#searchLicensingNo").removeOption(/./);
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
	//$("#label_"+companySelectBoxId).html($("#"+companySelectBoxId).selectedTexts());
}

function plantChange(licensingNo){
	var URL = "../manufacturingNo/licensingNoListAjax";
	if( licensingNo == 'searchLicensingNo' ) {
		if( $("#searchCompany").selectedValues()[0] != '' && $("#searchPlant").selectedValues()[0] != '') {	
			$.ajax({
				type:"POST",
				url:URL,
				data:{
					"companyCode" : $("#searchCompany").selectedValues()[0],
					"plantCode" : $("#searchPlant").selectedValues()[0]
				},
				dataType:"json",
				async:false,
				success:function(data) {
					var list = data;
					$("#searchLicensingNo").removeOption(/./);
					$("#searchLicensingNo").addOption("", "전체", false);
					$("#label_searchLicensingNo").html("전체");
					$.each(list, function( index, value ){ //배열-> index, value
						var licensingNoTxt = "";
						if( nvl(value.plantName,'') == '' ) {
							licensingNoTxt = value.licensingNo;
						} else {
							licensingNoTxt = value.licensingNo+"("+value.plantName+")";
						}
						$("#searchLicensingNo").addOption(value.licensingNo, licensingNoTxt, false);
					});
				},
				error:function(request, status, errorThrown){
						alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
				}			
			});	
		}
	} else {
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
						var licensingNoTxt = "";
						if( nvl(value.plantName,'') == '' ) {
							licensingNoTxt = value.licensingNo;
						} else {
							licensingNoTxt = value.licensingNo+"("+value.plantName+")";
						}
						$("#licensingNo").addOption(value.licensingNo, licensingNoTxt, false);
					});
				},
				error:function(request, status, errorThrown){
						alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
				}			
			});	
		}
	}
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
			//if( groupCode == 'STERILIZATION' || groupCode == 'ETCDISPLAY' ) {
			if( groupCode == 'STERILIZATION2' ) {
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
	if( $("#keepCondition").selectedValues()[0] == '4' ) {
		$("#keepConditionText").show();
	} else {
		$("#keepConditionText").val("");
		$("#keepConditionText").hide();
	}
}

function referralCheck() {
	if( $("input:checkbox[name=referral]").is(":checked") == false ) {
		$("#create_plant_li").hide();
		$("#create_plant_list").html("");
	} else {
		if($("#create_plant_li").is(":visible") == false ) {
			loadPlant();	
		}
	}
}

function oemCheck() {
	if( $("input:checkbox[name=oem]").is(":checked") == false ) {
		$("#create_oem_li").hide();
		$("#oem_text").val("");
	} else {
		$("#create_oem_li").show();
	}
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

function loadPackage(groupCode) {
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
			$("#packageUnit").removeOption(/./);
			$.each(list, function( index, value ){ //배열-> index, value
				$("#packageUnit").addOption(value.itemCode, value.itemName, false);
			});
		},
		error:function(request, status, errorThrown){
			$("#packageUnit").removeOption(/./);
			alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
		}			
	});
}

function showPackageInput() {
	var count = 0;
	$('#packageUnit :selected').each(function(i, sel){ 
	    if( $(sel).val() == '8' ) {
	    	count++;
	    }
	});
	if( count > 0 ) {
		$("#packageEtc").val("");
		$("#packageEtc").show();
	} else {
		$("#packageEtc").val("");
		$("#packageEtc").hide();
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
	} else if( !chkNull($("#productType2").selectedValues()[0]) ) {
		alert("식품유형을 선택해주세요.");
		$("#productType2").focus();
		$("#create").prop('disabled', false);
		return;
	} else if( !chkNull($("#sterilization").selectedValues()[0]) ) {
		alert("살균여부를 선택해주세요.");
		$("#sterilization").focus();
		$("#create").prop('disabled', false);
		return;
	} else if( !chkNull($("#keepCondition").selectedValues()[0]) ) {
		alert("보관조건을 선택해주세요.");
		$("#keepCondition").focus();
		$("#create").prop('disabled', false);
		return;
	} else if( $("#keepCondition").selectedValues()[0] == '4' && !chkNull($("#keepConditionText").val()) ) {
		alert("보관조건을 입력해주세요.");
		$("#keepConditionText").focus();
		$("#create").prop('disabled', false);
		return;
	} else if( !chkNull($("#sellDate1").selectedValues()[0]) ) {
		alert("소비기한을 선택해주세요.");
		$("#sellDate1").focus();
		$("#create").prop('disabled', false);
		return;
	} else if( !chkNull($("#sellDate2").val()) ) {
		alert("소비기한을 입력해주세요.");
		$("#sellDate2").focus();
		$("#create").prop('disabled', false);
		return;
	} else if( !chkNull($("#sellDate3").selectedValues()[0]) ) {
		alert("소비기한을 선택해주세요.");
		$("#sellDate3").focus();
		$("#create").prop('disabled', false);
		return;
	} else if( $("input:checkbox[name=oem]").is(":checked") == true && !chkNull($("#oemText").val())) {
		alert("OEM 내용을 입력하세요.");
		$("#oemText").focus();
		return;
	}/*else if( $("#mailing").selectedValues().length == 0 ) {
		alert("메일 전송 담당자를 선택해주세요.");
		$("#searchUser").focus();
		return;
	}*/ else if( $('#packageUnit').selectedValues().length == 0 ) {
		alert("포장재질을 선택해주세요.");
		$("#create").prop('disabled', false);
		return;
	} else {
		var count = 0;
		$('#packageUnit :selected').each(function(i, sel){ 
		    if( $(sel).val() == '8' ) {
		    	count++;
		    }
		});
		if( count > 0 ) {
			if( !chkNull($('#packageEtc').val()) ) {
				alert("포장재질을 입력해주세요.");
				$("#packageEtc").focus();
				$("#create").prop('disabled', false);
				return;
			}
		}
		if(confirm("품목제조보고번호를 생성하시겠습니까?")){
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
			var packageArray = new Array();
			$('#packageUnit :selected').each(function(i, sel){ 
				packageArray.push($(sel).val());
			});
			var URL = "../manufacturingNo/insertAjax";
			$.ajax({
				type:"POST",
				url:URL,
				traditional : true,
				data:{
					"dNo":'${paramVO.dNo}',
					"companyCode":$("#company").selectedValues()[0],
					"plantCode": $("#plant").selectedValues()[0],
					"licensingNo": $("#licensingNo").selectedValues()[0],
					"manufacturingName": $("#manufacturingName").val(),
					"productType1": $("#productType1").selectedValues()[0],
					"productType2": $("#productType2").selectedValues()[0],
					"productType3": $("#productType3").selectedValues()[0],
					"sterilization": $("#sterilization").selectedValues()[0],
					//"etcDisplay": $("#etcDisplay").selectedValues()[0],
					"keepCondition": $("#keepCondition").selectedValues()[0],
					"keepConditionText": $("#keepConditionText").val(),
					"sellDate1": $("#sellDate1").selectedValues()[0],
					"sellDate2": $("#sellDate2").val(),
					"sellDate3": $("#sellDate3").selectedValues()[0],
					"sellDate4": $("#sellDate4").selectedValues()[0],
					"sellDate5": $("#sellDate5").val(),
					"sellDate6": $("#sellDate6").selectedValues()[0],
					"referral": referral,
					"oem": oem,
					"oemText": $("#oemText").val(),
					"createPlant": plantArray,
					"packageUnit": packageArray,
					"packageEtc": $('#packageEtc').val(),
					//"mailing": $("#mailing").selectedValues(),
					"comment": $("#comment").val(),
					"versionNo" : "1"
				},
				dataType:"json",
				success:function(result) {
					if( result.status == 'success') {
						alert("품목제조 보고서 번호 "+result.msg+"가 생성되었습니다.");
						parent.loadManufacturingNo();
						bPopup_close();
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

function changeTab(div) {
	$("#item_tab").children().each(function(i, v){
		if( div == $(v).attr("id") ) {
			$(v).children().attr("class","select");
			$("#div_"+$(v).attr("id")).show();
		} else {
			$(v).children().attr("class","");
			$("#div_"+$(v).attr("id")).hide();
		}
	});
	if( div == 'create_tab' ) {
		$("#create").show();
	} else {
		$("#create").hide();
	}
}

function goSearch() {
	/*if( !chkNull($("#searchManufacturingName").val()) ) {
		alert("품목제조보고서명을 입력하세요.");
		$("#searchManufacturingName").focus();
		return;
	} else */{
		//조건에 맞는 품목제조보고서 리스트를 가져온다.
		var URL = "../manufacturingNo/searchManufacturingNoListAjax";
		$.ajax({
			type:"POST",
			url:URL,
			traditional : true,
			data:{
				"searchCompany":$("#searchCompany").selectedValues()[0],
				"searchPlant":$("#searchPlant").selectedValues()[0],
				"searchLicensingNo": $("#searchLicensingNo").selectedValues()[0],
				"searchManufacturingName": $("#searchManufacturingName").val(),
				"searchManufacturingNo": $("#searchManufacturingNo").val()
			},
			dataType:"json",
			success:function(result) {
				var html = "";
				var list = result.list;
				$("#list").html(html);
				if( list.length > 0 ) {
					result.list.forEach(function (item) {					
						html += "<tr>"					
						html += "	<td>"+item.licensingNo+item.manufacturingNo+"</td>";
						html += "	<td>"+item.versionNo+"</td>";
						html += "	<td>"+nvl(item.manufacturingName,"")+"</td>";
						html += "	<td>"+item.companyName+"</td>";
						html += "	<td>"+item.plantName+"</td>";
						html += "	<td>";
						html += "		<ul class=\"list_ul\">";
						html += "			<li> <button class=\"btn_doc\" onClick=\"javascript:addMapping('"+item.seq+"','"+item.licensingNo+"','"+item.manufacturingNo+"')\"><img src=\"/resources/images/icon_doc03.png\">등록</button></li>";
						html += "		</ul>";
						html += "	</td>";
						html += "</tr>"
					});
				} else {
					html += "<tr>"					
						html += "	<td colspan=\"5\">데이터가 없습니다.</td>";
						html += "</tr>"
				}
				
				$("#list").html(html);
			},
			error:function(request, status, errorThrown){
				var html = "";
				$("#list").html(html);
				html += "<tr>"
				html += "	<td colspan='5'>데이터가 없습니다.</td>";
				html += "</tr>";
				$("#list").html(html);
			}			
		});	
	}
}

function addMapping(seq, licensingNo, manufacturingNo) {
	var URL = "../manufacturingNo/addManufacturingMappingAjax";
	$.ajax({
		type:"POST",
		url:URL,
		traditional : true,
		data:{
			"dNo"				: '${paramVO.dNo}',
			"no_seq"			: seq,
			"licensingNo"		: licensingNo,
			"manufacturingNo"	: manufacturingNo
		},
		dataType:"json",
		success:function(result) {
			if( result.status == 'success') {
				alert("품목제조보고번호가 추가되었습니다.");
				parent.loadManufacturingNo();
				parent.loadManufacturingNoFile();
				bPopup_close();
			} else if( result.status == 'fail') {
				alert(result.msg);
			} else {
				alert(result.msg+"오류가 발생하였습니다.\n다시 시도하여 주세요.");
			}
		},
		error:function(request, status, errorThrown){

		}			
	});	
}

function bPopup_close() {
	parent.bPopup_close();
}
</script>
<style>
.selectbox_popup { border: 1px solid #cf451b; border-radius:5px;/* 테두리 설정 */ z-index: 1; background-color:#fff;font-family:'맑은고딕',Malgun Gothic; color:#000; font-size:13px; padding: 2px 3px  5px 3px;}
</style>
<h2 style=" position:fixed;" class="print_hidden">
	<span class="title"><img src="/resources/images/bg_bs_box_fast02.png">&nbsp;&nbsp;품목제조보고서 등록</span>
</h2>
<div  class="top_btn_box" style=" position:fixed;">
	<ul>
		<li><button type="button" class="btn_pop_close" onClick="bPopup_close();"></button></li>
	</ul>
</div>
<br/>
<br/><br/>
<div class="wrap_in" id="fixNextTag">
	<section class="type01">
		<div class="group01">
			<div class="tab03">
				<ul id="item_tab">
					<!-- 선택됬을경우는 탭 클래스에 select를 넣어주세요 -->
					<!-- 내 제품개발문서 같은경우는 change select 이렇게 change 그대로 두고 한칸 띄고 select 삽입 -->
					<a href="javascript:changeTab('create_tab')" id="create_tab"><li class="select">신규생성</li></a>									
					<a href="javascript:changeTab('search_tab')" id="search_tab"><li class="">품목제조보고 조회</li></a>
				</ul>
			</div>
			<div class="list_detail" id="div_create_tab">
				<ul>
					<li class="pt10">
						<dt>공장</dt>
						<dd>
							<!--  div class="selectbox req" style="width:150px;">  
								<label for="company" id="label_company"> 선택</label> 
								<select id="company" name="company" onChange="companyChange('company','plant')">
								</select>
							</div> 
							<div class="selectbox req ml5" style="width:150px;">  
								<label for="plant" id="label_plant"> 선택</label> 
								<select id="plant" name="plant" onChange="plantChange('licensingNo')">
								</select>
							</div>
							<div class="selectbox req ml5" style="width:150px;">  
								<label for="licensingNo" id="label_licensingNo"> 선택</label> 
								<select id="licensingNo" name="licensingNo">
								</select>
							</div-->
							<select id="company" name="company" onChange="companyChange('company','plant')" style="width:150px;" class="selectbox_popup">
							</select>
							
							<select id="plant" name="plant" onChange="plantChange('licensingNo')" style="width:150px;" class="selectbox_popup">
							</select>
							
							<select id="licensingNo" name="licensingNo" style="width:200px;" class="selectbox_popup">
							</select>
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
						<dt>품목보고명</dt>
						<dd>
							<input type="text" class="req" style="width:250px;float:left;" placeholder="입력후 확인버튼을 눌러주세요." name="manufacturingName" id="manufacturingName" value="">
							<button type="button" class="btn_small01 ml5" onClick="checkName()">확인</button>
							<input type="hidden" name="manufacturingName_temp" id="manufacturingName_temp">
							<input type="hidden" name="isValid" id="isValid" value="N">
							&nbsp;&nbsp;<span id="checkName"></span>
						</dd>
					</li>
					<li>
						<dt>식품유형</dt>
						<dd>
							<!--div class="selectbox req" style="width:160px;">  
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
							</div-->
							<select id="productType1" name="productType1" onChange="loadProductType('2','productType2')" style="width:160px;" class="selectbox_popup">
							</select>
							<span id="li_productType2" style="width:130px;display:none">
							<select id="productType2" name="productType2" onChange="loadProductType('3','productType3')" style="width:130px;" class="selectbox_popup">
							</select>
							</span>
							<span id="li_productType3" style="width:130px;display:none">
							<select id="productType3" name="productType3" style="width:130px;" class="selectbox_popup">
							</select>
							</span>
						</dd>
					</li>	
					<li>
						<dt>살균여부</dt>
						<dd>
							<!--  div class="selectbox req" style="width:130px;">  
								<label for="sterilization" id="label_sterilization">선택안함</label> 
								<select id="sterilization" name="sterilization">
								</select>
							</div-->
							<select id="sterilization" name="sterilization" style="width:130px;" class="selectbox_popup">
							</select>
							<!--  
							<div class="selectbox req ml5" style="width:250px;">  
								<label for="etcDisplay" id="label_etcDisplay">선택안함</label> 
								<select id="etcDisplay" name="etcDisplay">
								</select>
							</div>
							-->
						</dd>
					</li>
					<li>
						<dt>보관조건</dt>
						<dd>
							<!-- div class="selectbox req" style="width:180px;">  
								<label for="keepCondition" id="label_keepCondition"> 선택</label> 
								<select id="keepCondition" name="keepCondition" onChange="changeKeepCondition()">
								</select>
							</div-->
							<select id="keepCondition" name="keepCondition" onChange="changeKeepCondition()" style="width:180px;" class="selectbox_popup">
							</select>
							<input type="text" class="req" style="width:200px;display:none" name="keepConditionText" id="keepConditionText">
						</dd>
					</li>
					<li>
						<dt>소비기한</dt>
						<dd>
							<!--  
							<input type="text" class="req" style="width:400px;" name="sellDate" id="sellDate">
							-->
							<!--div class="selectbox req" style="width:180px;">  
								<label for="sellDate1" id="label_keepCondition1"> 선택</label> 
								<select id="sellDate1" name="sellDate1">
									<option value="">선택</option>
									<option value="D">제조일로부터</option>
									<option value="H">제조시간으로부터</option>
								</select>
							</div>
							<input type="text" class="req ml5" style="width:50px;" name="sellDate2" id="sellDate2">
							<div class="selectbox req ml5" style="width:120px;">  
								<label for="sellDate3" id="label_keepCondition3"> 선택</label> 
								<select id="sellDate3" name="sellDate3">
									<option value="">선택</option>
									<option value="M">개월</option>
									<option value="D">일</option>
									<option value="H">시간</option>
								</select>
							</div>
							까지
							-->
							<select id="sellDate1" name="sellDate1" style="width:180px;" class="selectbox_popup">
								<option value="">선택</option>
								<option value="D">제조일로부터</option>
								<option value="H">제조시간으로부터</option>
								<option value="B">할란 후</option>
							</select>
							<input type="text" class="req ml5" style="width:80px;" name="sellDate2" id="sellDate2" onkeyup="clearNoNum(this)">
							<select id="sellDate3" name="sellDate3" style="width:120px;" class="selectbox_popup">
								<option value="">선택</option>
								<option value="Y">년</option>
								<option value="M">개월</option>
								<option value="D">일</option>
								<option value="H">시간</option>
							</select>
							까지<br/>
							<select id="sellDate4" name="sellDate4" style="width:180px;" class="selectbox_popup">
								<option value="">선택</option>
								<option value="D">제조일로부터</option>
								<option value="H">제조시간으로부터</option>
								<option value="B">할란 후</option>
							</select>
							<input type="text" class="req ml5" style="width:80px;" name="sellDate5" id="sellDate5" onkeyup="clearNoNum(this)">
							<select id="sellDate6" name="sellDate6" style="width:120px;" class="selectbox_popup">
								<option value="">선택</option>
								<option value="Y">년</option>
								<option value="M">개월</option>
								<option value="D">일</option>
								<option value="H">시간</option>
							</select>
							까지
						</dd>
					</li>
					<li>
						<dt>위탁/OEM</dt>
						<dd>
							<input type="checkbox" id="referral" name="referral" value="Y" onClick="referralCheck()"><label for="referral"><span></span>위탁</label>
							<input type="checkbox" id="oem" name="oem" value="Y" onClick="oemCheck()"><label for="oem"><span></span>OEM</label>
						</dd>
					</li>
					<li id="create_plant_li" style="display:none">
						<dt>생산 공장</dt>
						<dd id="create_plant_list">
						</dd>
					</li>
					<li id="create_oem_li" style="display:none">
						<dt>OEM 내용</dt>
						<dd>
							<textarea style="width:80%; height:40px" name="oemText" id="oemText"></textarea>
						</dd>
					</li>
					<li>
						<dt>포장재질</dt>
						<dd>
							<select id="packageUnit" name="packageUnit" style="width:300px;" class="selectbox_popup" multiple size="3" onChange="showPackageInput()"> 
							</select>
							<input type="text" class="req ml5" style="width:300px;display:none" name="packageEtc" id="packageEtc">
							<br>다중선택 : Ctrl or Shift + 클릭
						</dd>
					</li>
					<!--  
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
					-->
					<li>
						<dt>비고</dt>
						<dd>
							<textarea style="width:100%; height:40px" name="comment" id="comment"></textarea>
						</dd>
					</li>
				</ul>
			</div>
			<div id="div_search_tab" style='display:none'>
				<div class="list_detail">
					<ul>
						<li>
							<dt>공장</dt>
							<dd>
								<!--div class="selectbox req" style="width:150px;">  
									<label for="searchCompany" id="label_searchCompany"> 선택</label> 
									<select id="searchCompany" name="searchCompany" onChange="companyChange('searchCompany','searchPlant')">
									</select>
								</div> 
								<div class="selectbox req ml5" style="width:150px;">  
									<label for="searchPlant" id="label_searchPlant"> 선택</label> 
									<select id="searchPlant" name="searchPlant" onChange="plantChange('searchLicensingNo')">
									</select>
								</div>
								<div class="selectbox req ml5" style="width:150px;">  
									<label for="searchLicensingNo" id="label_searchLicensingNo"> 선택</label> 
									<select id="searchLicensingNo" name="searchLicensingNo">
									</select>
								</div-->
								<select id="searchCompany" name="searchCompany" onChange="companyChange('searchCompany','searchPlant')" style="width:150px;" class="selectbox_popup">
								</select>
								<select id="searchPlant" name="searchPlant" onChange="plantChange('searchLicensingNo')" style="width:150px;" class="selectbox_popup">
								</select>
								<select id="searchLicensingNo" name="searchLicensingNo" style="width:200px;" class="selectbox_popup">
								</select>
							</dd>
						</li>
						<li>
							<dt>품목제조보고서명</dt>
							<dd>
								<input type="text" class="req" style="width:250px;float:left;" placeholder="입력후 검색버튼을 눌러주세요." name="searchManufacturingName" id="searchManufacturingName" value="">															
							</dd>
						</li>		
						<li>
							<dt>품목제조보고번호</dt>
							<dd>
								<input type="text" class="req" style="width:250px;float:left;" placeholder="입력후 검색버튼을 눌러주세요." name="searchManufacturingNo" id="searchManufacturingNo" value="">															
							</dd>
						</li>			
					</ul>
					<div class="fr pt5 pb10">
						<button type="button" class="btn_con_search" onClick="javascript:goSearch()"><img src="/resources/images/btn_icon_search.png" style="vertical-align:middle;"/> 검색</button>											
					</div>
				</div>
				
				<div class="title3">
					<span class="txt">품목제조보고서</span>
				</div>
				<div class="main_tbl" style="padding-bottom: 40px;">
					<table class="tbl04" id="">
						<colgroup>							
							<col width="25%">
							<col width="5%"/>
							<col width="30%">
							<col width="20%">
							<col width="10%">
							<col width="15%">
						</colgroup>
						<thead>
							<tr>								
								<th>품목제조보고번호</th>
								<th>버전</th>
								<th>품목제조보고명</th>
								<th>회사</th>
								<th>플랜트</th>
								<th></th>
							</tr>
						</thead>
						<tbody id="list">
							
						</tbody>
					</table>
				</div>
			</div>
			<div class="btn_box_con">
				<button type="button" class="btn_admin_red" id="create" onclick="javascript:goInsert();">발급</button>
				<button type="button" class="btn_admin_gray" onclick="bPopup_close();"> 취소</button>
			</div>			
		</div>
	</section>
</div>
