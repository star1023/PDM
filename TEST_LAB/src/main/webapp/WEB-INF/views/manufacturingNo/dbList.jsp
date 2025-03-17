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
	loadCodeList( "KEEPCONDITION2", "searchKeepCondition" );
	loadCodeList( "STERILIZATION2", "searchSterilization" );
	loadCodeList( "PRODCAT1", "searchProductType1" );
	//loadCodeList( "ETCDISPLAY", "etcDisplay" );
	//loadPackage("PACKAGE_UNIT");
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
	var statusArray = new Array();
	$('input:checkbox[name="searchStatus"]').each(function() {
	      if(this.checked){//checked 처리된 항목의 값
	    	  statusArray.push(this.value);
	      }
	});
	if( statusArray.length == 0 ) {
		$('input:checkbox[name="searchStatus"]').each(function() {
		     	  statusArray.push(this.value);		     
		});
		//statusArray.push('P');
	}
	//console.log(statusArray);
	$.ajax({
		type:"POST",
		url:URL,
		traditional : true,
		data:{
				"searchCompany":$("#searchCompany").selectedValues()[0],
				"searchPlant":$("#searchPlant").selectedValues()[0],
				"searchManufacturingNo":$("#searchManufacturingNo").val(),
				"searchManufacturingName":$("#searchManufacturingName").val(),
				"searchSterilization":$("#searchSterilization").selectedValues()[0],
				"searchKeepCondition":$("#searchKeepCondition").selectedValues()[0],
				"searchKeepConditionText":$("#searchKeepConditionText").val(),
				"searchSellDate1":$("#searchSellDate1").selectedValues()[0],
				"searchSellDate2":$("#searchSellDate2").val(),
				"searchSellDate3":$("#searchSellDate3").selectedValues()[0],
				"searchProductType1":$("#searchProductType1").selectedValues()[0],
				"searchProductType2":$("#searchProductType2").selectedValues()[0],
				"searchProductType3":$("#searchProductType3").selectedValues()[0],
				//"searchPackageUnit":$("#searchPackageUnit").selectedValues()[0],
				//"searchPackageEtc":$("#searchPackageEtc").val(),
				"searchStatus":statusArray,
				"viewCount":viewCount,
				"pageNo":pageNo
		},
		dataType:"json",
		success:function(data) {
			var html = "";
			if( data.totalCount > 0 ) {
				$("#list").html(html);
				data.manufacturingNoList.forEach(function (item) {					
					html += "<tr>"
					html += "	<td>"+item.plnatName+"</td>";
					html += "	<td><a href=\"#\" onClick=\"goView('"+item.seq+"','"+item.versionNo+"','"+item.licensingNo+"','"+item.manufacturingNo+"')\">"+item.licensingNo+"-"+item.manufacturingNo+"</a></td>";
					html += "	<td>"+item.versionNo+"</td>"
					html += "	<td><a href=\"#\" onClick=\"goView('"+item.seq+"','"+item.versionNo+"','"+item.licensingNo+"','"+item.manufacturingNo+"')\">"+nvl(item.manufacturingName,"")+"</a></td>";
					html += "	<td>";
					html += item.keepConditionName;
					if( item.keepConditionText != '' && item.keepConditionText != null ) {
						html += "("+item.keepConditionText+")";
					}
					html += " <br/> ";
					html += item.sellDate1Text + " "+item.sellDate2+" "+item.sellDate3Text+" 까지";
					html += "	</td>";
					html += "	<td>";
					html += item.productType1Name;
					if( item.productType2Name != '' && item.productType2Name != null ) {
						html += "/"+item.productType2Name;
					}
					if( item.productType3Name != '' && item.productType3Name != null ) {
						html += "/"+item.productType3Name;
					}
					html += "	</td>";
					html += "	<td>"+item.sterilizationName+"</td>";
					html += "	<td>";
					html += 	nvl(item.packageUnitNames,"");
					if( item.packageEtc != '' && item.packageEtc != null ) {
						html += "("+item.packageEtc+")";
					}
					html += "	</td>";
					html += "	<td>"+item.statusName+"</td>";
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
			$('.page_navi').html("");
			$('#pageNo').val("1");
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
	$("#searchProductType1").selectOptions("");
	$("#label_searchProductType1").html("전체");	
	$("#searchProductType2").removeOption(/./);
	$("#label_searchProductType2").html("전체");
	$("#div_searchProductType2").hide();
	$("#searchProductType3").removeOption(/./);
	$("#label_searchProductType3").html("전체");
	$("#div_searchProductType3").hide();
	goSearch();
}

//페이징
function paging(pageNo){
	//location.href = '../material/list?' + getParam(pageNo);
	loadList(pageNo);
}

function goExcel() {
	$('#form').attr('action', '/manufacturingNo/excelDownload').submit();
}

//파일 다운로드
function fileDownload(fmNo){
	location.href="/file/fileDownload?fmNo="+fmNo;
}

function showKeepCondition() {
	if( $("#searchKeepCondition").selectedValues()[0] == '4' ) {
		$("#searchKeepConditionText").val("");
		$("#searchKeepConditionText").show();
	} else {
		$("#searchKeepConditionText").val("");
		$("#searchKeepConditionText").hide();
	}
}

/*
function showPackageInput() {
	var count = 0;
    if( $("#searchPackageUnit").selectedValues()[0] == '8' ) {
    	$("#searchPackageEtc").val("");
		$("#searchPackageEtc").show();
    } else {
    	$("#searchPackageEtc").val("");
		$("#searchPackageEtc").hide();
    }
}
*/

function loadProductType( grade, objectId ) {
	var URL = "../common/productTypeListAjax";
	var groupCode = "PRODCAT"+grade;
	var codeValue = "";
	if( grade == '2' ) {
		codeValue = $("#searchProductType1").selectedValues()[0]+"-";
		$("#div_searchProductType2").hide();
		$("#div_searchProductType3").hide();
	} else if( grade == '3' ) {
		codeValue = $("#searchProductType2").selectedValues()[0]+"-";
		$("#div_searchProductType3").hide();
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
				$("#div_"+objectId).show();
			} else {
				$("#div_"+objectId).hide();
			}
		},
		error:function(request, status, errorThrown){
			element.removeOption(/./);
			$("#div_"+element.prop("id")).hide();
			alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
		}			
	});
}

function goView(seq, versionNo, licensingNo, manufacturingNo) {
//	window.location.href="../manufacturingNo/dbView?seq="+seq+"&versionNo="+versionNo+"&licensingNo="+licensingNo+"&manufacturingNo="+manufacturingNo;
	var form = document.createElement("form"); // 폼객체 생성
	$('body').append(form);
	form.action = "/manufacturingNo/dbView";
	form.style.display = "none";
	form.method = "post";
	
	appendInput(form, "seq", seq);
	appendInput(form, "versionNo", versionNo);
	appendInput(form, "licensingNo", licensingNo);
	appendInput(form, "manufacturingNo", manufacturingNo);
	
	$(form).submit();
}

// -- 230720 실루엣 반영을 위한 주석 (품목DB - 중단요청(AS) 검색 조건 추가)
</script>
<form name="form" id="form" method="post" action="">
<input type="hidden" name="pageNo" id="pageNo" value="${paramVO.pageNo}">
<div class="wrap_in" id="fixNextTag">
	<span class="path">품목제조보고서DB&nbsp;&nbsp;
		<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;
		<a href="#">${strUtil:getSystemName()}</a>
	</span>
	<section class="type01">
	<!-- 상세 페이지  start-->
		<h2 style="position:relative"><span class="title_s">Items Manufacturing Report Database</span>
			<span class="title">품목제조보고서DB</span>
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
							<div class="selectbox ml5" style="width:150px;">  
								<label for="searchCompany" id="label_searchCompany">선택</label> 
								<select id="searchCompany" name="searchCompany"  onChange="companyChange('searchCompany','searchPlant')">
								</select>								
							</div>
							<div class="selectbox ml5" style="width:150px;">  
								<label for="searchPlant"  id="label_searchPlant">전체</label> 
								<select name="searchPlant" id="searchPlant">
								</select>
							</div>
						</dd>
					</li>
					<li>
						<dt>품목보고번호</dt>
						<dd>
							<input type="text" name="searchManufacturingNo" id="searchManufacturingNo" class="ml5" style="width:180px;">
						</dd>
					</li>
					<li>
						<dt>품보명</dt>
						<dd>
							<input type="text" name="searchManufacturingName" id="searchManufacturingName" class="ml5" style="width:180px;"  onkeydown="if(event.keyCode == 13)goSearch();">
						</dd>
					</li>
					<li>
						<dt>살균여부</dt>
						<dd>
							<div class="selectbox ml5" style="width:150px;">
							<label for=searchSterilization  id="label_searchSterilization">전체</label>   
							<select id="searchSterilization" name="searchSterilization">
							</select>
							</div>
						</dd>
					</li>
					<li>
						<dt>보관조건</dt>
						<dd>
							<div class="selectbox ml5" style="width:200px;">  
								<label for="searchKeepCondition" id="label_searchKeepCondition">선택</label> 
								<select id="searchKeepCondition" name="searchKeepCondition" onChange="showKeepCondition();">
								</select>																
							</div>
							<input type="text" class="req ml5" style="width:100px;display:none" name="searchKeepConditionText" id="searchKeepConditionText">
						</dd>
					</li>
					<li>
						<dt>소비기한</dt>
						<dd>
							<div class="selectbox ml5" style="width:100px;">
							<label for="searchSellDate1" id="label_searchSellDate1">선택</label> 
							<select id="searchSellDate1" name="searchSellDate1">
								<option value="">선택</option>
								<option value="D">제조일로부터</option>
								<option value="H">제조시간으로부터</option>
								<option value="B">할란 후</option>
							</select>
							</div>
							<input type="text" class="req ml5 fl" style="width:50px;" name="searchSellDate2" id="searchSellDate2">
							<div class="selectbox ml5" style="width:100px;"> 
							<label for="searchSellDate3" id="label_searchSellDate3">선택</label>
							<select id="searchSellDate3" name="searchSellDate3">
								<option value="">선택</option>
								<option value="Y">년</option>
								<option value="M">개월</option>
								<option value="D">일</option>
								<option value="H">시간</option>
							</select>
							</div>
							까지
						</dd>
					</li>
					<li>
						<dt>상태</dt>
						<dd>
							<input type="checkbox" name="searchStatus" id="searchStatus_N" value="N" ><label for="searchStatus_N"><span></span>번호생성</label>	
							<input type="checkbox" name="searchStatus" id="searchStatus_P" value="P" ><label for="searchStatus_P"><span></span>진행중</label>							
							<input type="checkbox" name="searchStatus" id="searchStatus_C" value="C" ><label for="searchStatus_C"><span></span>완료</label>
							<input type="checkbox" name="searchStatus" id="searchStatus_D" value="D" ><label for="searchStatus_D"><span></span>삭제</label>
 							<input type="checkbox" name="searchStatus" id="searchStatus_AS" value="AS" ><label for="searchStatus_AS"><span></span>중단요청</label> 
							<input type="checkbox" name="searchStatus" id="searchStatus_RS" value="RS" ><label for="searchStatus_RS"><span></span>중단요청승인</label>
							<input type="checkbox" name="searchStatus" id="searchStatus_S" value="S" ><label for="searchStatus_S"><span></span>중단</label>
							<input type="checkbox" name="searchStatus" id="searchStatus_RC" value="RC" ><label for="searchStatus_RC"><span></span>변경요청</label>
							<input type="checkbox" name="searchStatus" id="searchStatus_RE" value="RE" ><label for="searchStatus_RE"><span></span>신고중</label>
						</dd>
					</li>
					<li>
						<dt>식품유형</dt>
						<dd>
							<div class="selectbox ml5" style="width:150px;" id="div_searchProductType1"> 
								<label for="searchProductType1" id="label_searchProductType1">선택</label>
								<select id="searchProductType1" name="searchProductType1" onChange="loadProductType('2','searchProductType2')">
								</select>																
							</div>
							<div class="selectbox ml5" style="width:150px;display:none;" id="div_searchProductType2"> 
								<label for="searchProductType2" id="label_searchProductType2">선택</label>
								<select id="searchProductType2" name="searchProductType2" onChange="loadProductType('3','searchProductType3')">
								</select>															
							</div>
							<div class="selectbox ml5" style="width:150px;display:none;" id="div_searchProductType3">   
								<label for="searchProductType3" id="label_searchProductType3">선택</label>
								<select id="searchProductType3" name="searchProductType3" style="width:130px;">
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
						<col width="5%">
						<col width="8%">
						<col width="3%">			
						<col width="17%">
						<col width="15%">
						<col width="12%">
						<col width="6%">
						<col width="25"/>
						<col width="8%">
					</colgroup>
					<thead>
						<tr>
							<th>공장</th>
							<th>품보번호</th>
							<th>버전</th>
							<th>품보명</th>
							<th>보관조건 및 소비기한</th>
							<th>식품유형</th>
							<th>살균여부</th>
							<th>포장재질</th>
							<th>상태</th>
						</tr>
					</thead>
					<tbody id="list">
					</tbody>
				</table>	
				<div class="page_navi  mt10">
				</div>
			</div>
			<hr class="con_mode"/><!-- 신규 추가 꼭 데려갈것 !-->
		</div>
	</section>
</div>
</form>
