<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ page session="false" %>
<title>신제품 매출관리</title>
<link href="/resources/js/jquery.auto-complete.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="/resources/js/jquery.auto-complete.js"></script>
<script type="text/javascript" src="/resources/js/jquery.mtz.monthpicker.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	loadList('1');
	loadTeam("searchTeam");
	/*
	$("#startDate").datepicker({
		dateFormat: 'yy-mm',
		buttonImage: '/resources/images/btn_calendar.png',
		buttonImageOnly: true,
		buttonText: "선택",  
		showOn: 'both',
		showMonthAfterYear: true,
		showOtherMonths: false,
		dayNames: ['일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일'],
		dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
		monthNames: [ "1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
		monthNamesShot: [ "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"],
		showOtherMonths: true,
		yearSuffix: "년"
	})
	
	$('.ui-datepicker-trigger').css('margin-left', '5px');
	$('.ui-datepicker-trigger').css('margin-top', '-5px');
	$('.ui-datepicker-trigger').css('cursor', 'pointer');
	*/
	var startYear = (new Date()).getFullYear();
	var currentYear = 2019+1;
	var options = {
		startYear: startYear,
	    finalYear: currentYear,
	    pattern: 'yyyy-mm',
	    monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월']
	};
	$('#startDate').monthpicker(options);
	
	var startYear = (new Date()).getFullYear();
	var currentYear = 2019+1;
	var options = {
		startYear: startYear,
	    finalYear: currentYear,
	    pattern: 'yyyy-mm',
	    monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월']
	};
	$('#startDate2').monthpicker(options);
});

function loadList( pageNo ) {
	var URL = "../selling/sellingMasterListAjax";
	$("#pageNo").val(pageNo);
	$.ajax({
		type:"POST",
		url:URL,
		data:{
			"pageNo":pageNo,
			"searchType": $("#searchType").selectedValues()[0],
			"searchValue": $("#searchValue").val(),
			"searchTeam": $("#searchTeam").selectedValues()[0],
			"searchUser": $("#searchUser").selectedValues()[0],
			"viewCount": $("#viewCount").val()
		},		
		dataType:"json",
		success:function(data) {
			var html = "";
			if( data.totalCount > 0 ) {
				$("#list").html(html);
				data.sellingMasterList.forEach(function (item) {
					html += "<tr>";
					html += "	<td>"+nvl(item.productName,'&nbsp;')+"</td>";
					html += "	<td>"+nvl(item.productCode,'&nbsp;')+"</td>";
					html += "	<td>"+nvl(item.erpProductCode,'&nbsp;')+"</td>";
					html += "	<td>"+nvl(item.userName,'&nbsp;')+"</td>";
					html += "	<td>"+nvl(item.userDeptName,'&nbsp;')+"</td>";
					html += "	<td>"+nvl(item.userTeamName,'&nbsp;')+"</td>";
					html += "	<td>"+nvl(item.startDate,'&nbsp;')+"</td>";
					html += "	<td>"+nvl(item.endDate,'&nbsp;')+"</td>";
					html += "	<td>";
					html += "		<ul class=\"list_ul\">";
					html += "			<li> <button class=\"btn_doc\" onClick=\"javascript:goUpdateForm('"+item.seq+"')\"><img src=\"/resources/images/icon_doc03.png\"> 수정</button></li>";
					html += "			<li> <button class=\"btn_doc\" onClick=\"javascript:goDelete('"+item.seq+"')\"><img src=\"/resources/images/icon_doc04.png\"> 삭제</button></li>";
					html += "		</ul>";
					html += "	</td>";
					html += "</tr>";
				});
				$("#list").html(html);				
			} else {
				$("#list").html(html);
				html += "<tr><td align='center' colspan='9'>데이터가 없습니다.</td></tr>";
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

$(function() {
	$('#searchUserId').autoComplete({
		minChars: 2,
		delay: 100,
		cache: false,
		source: function(term, response){
			$.ajax({
				type: 'POST',
				url: '../common/userListAjax2',
				dataType: 'json',
				data: {
					"searchUser" : $("#searchUserId").val()
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
		    return '<div class="autocomplete-suggestion" data-code="' + item[1] + '" data-nm="' + item[0] + '" style="font-size: 0.8em">' + item[0] + '</div>';
		},
		onSelect: function(e, term, item){
			$("#searchUserId").val(item.data('nm'));
			$("#userId").val(item.data('code'));
			$("#userName").val(item.data('nm'));
		},
		focus: function(event, ui) {
	         return false;
		}	
	});
});

$(function() {
	$('#searchUserId2').autoComplete({
		minChars: 2,
		delay: 100,
		cache: false,
		source: function(term, response){
			$.ajax({
				type: 'POST',
				url: '../common/userListAjax2',
				dataType: 'json',
				data: {
					"searchUser" : $("#searchUserId2").val()
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
		    return '<div class="autocomplete-suggestion" data-code="' + item[1] + '" data-nm="' + item[0] + '" style="font-size: 0.8em">' + item[0] + '</div>';
		},
		onSelect: function(e, term, item){
			$("#searchUserId2").val(item.data('nm'));
			$("#userId2").val(item.data('code'));
			$("#userName2").val(item.data('nm'));
		},
		focus: function(event, ui) {
	         return false;
		}	
	});
});

function goInsert() {
	if( !chkNull($("#productName").val()) ) {
		alert("제품명을 입력해 주세요.");
		$("#productName").focus();
		return;
	} else if( !chkNull($("#productCode").val()) ) {
		alert("제품코드를 입력해 주세요.");
		$("#productCode").focus();
		return;
	} else if( !chkNull($("#erpProductCode").val()) ) {
		alert("ERP 제품코드를 입력해 주세요.");
		$("#erpProductCode").focus();
		return;
	} else if( !chkNull($("#searchUserId").val()) ) {
		alert("개발자를 입력해 주세요.");
		$("#searchUserId").focus();
		return;
	} else if( !chkNull($("#userId").val()) ) {
		alert("개발자를 입력해 주세요.");
		$("#searchUserId").focus();
		return;
	} else if( !chkNull($("#startDate").val()) ) {
		alert("등록일을 입력해 주세요.");
		$("#startDate").focus();
		return;
	} else {
		var URL = "../selling/insertMasterAjax";
		var usreInfo = $("#searchUserId").val();
		var jbSplit = usreInfo.split('/');
		$.ajax({
			type:"POST",
			url:URL,
			data:{
				"productName":$("#productName").val(),
				"productCode":$("#productCode").val(),
				"erpProductCode":$("#erpProductCode").val(),
				"userId":$("#userId").val(),
				"startDate":$("#startDate").val()
			},		
			dataType:"json",
			success:function(data) {
				if( data.result == 'success' ) {
					alert("등록되었습니다.");
					loadList('1');
					closeDialog('open');
				} else {
					alert(data.message);
				}
			},
			error:function(request, status, errorThrown){
				alert("오류가 발생하였습니다.");
			}			
		});	
	}
}

function goInserForm() {
	$("#productName").val("");
	$("#productCode").val("");
	$("#erpProductCode").val("");
	$("#searchUserId").val("");
	$("#userId").val("");
	$("#userName").val("");
	$("#startDate").val("");
	openDialog('open');
}

function loadTeam(selectBoxId) {
	var URL = "../common/codeListAjax";
	$.ajax({
		type:"POST",
		url:URL,
		data:{
			"groupCode":"TEAM"
		},
		dataType:"json",
		async:false,
		success:function(data) {
			var list = data.RESULT;
			$("#"+selectBoxId).removeOption(/./);
			$("#"+selectBoxId).addOption("", "전체", false);
			$.each(list, function( index, value ){ //배열-> index, value
				$("#"+selectBoxId).addOption(value.itemCode, value.itemName, false);
			});
		},
		error:function(request, status, errorThrown){
				alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
		}			
	});
}

function teamChange( searchTeam, searchUser ) {
	var URL = "../selling/searchUserId";
	if( $("#"+searchTeam).selectedValues()[0] != '' ) {
		$.ajax({
			type:"POST",
			url:URL,
			data:{
				"teamCode":$("#"+searchTeam).selectedValues()[0]
			},
			dataType:"json",
			async:false,
			success:function(data) {
				var list = data;
				$("#"+searchUser).removeOption(/./);
				$("#"+searchUser).addOption("", "전체", false);
				$.each(list, function( index, value ){ //배열-> index, value
					$("#"+searchUser).addOption(value.userId, value.userName, false);
				});
			},
			error:function(request, status, errorThrown){
					alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
			}			
		});
	} else {
		$("#"+searchUser).removeOption(/./);
	}
}

function goSearch() {
	loadList( '1' );
}

function goClear() {
	$("#searchType").selectOptions("");
	$("#searchType_label").html("선택");
	$("#searchValue").val("");
	$("#searchTeam").selectOptions("");
	$("#searchTeam_label").html("선택");
	$("#searchUser").selectOptions("");
	$("#searchUser_label").html("선택");
	goSearch();
}

function goClose( id ) {
	closeDialog(id);
	goClear();
}

//페이징
function paging(pageNo){
	//location.href = '../material/list?' + getParam(pageNo);
	loadList(pageNo);
}	

function goDelete(seq) {
	var URL = "../selling/deleteSellingDataAjax";
	$.ajax({
		type:"POST",
		url:URL,
		data:{
			"seq":seq
		},
		dataType:"json",
		async:false,
		success:function(data) {
			if(data.status == 'success'){
				alert("삭제되었습니다.");
			} else if( data.status == 'fail' ){
				alert(data.msg);
			} else {
				alert("오류가 발생하였습니다.");
			}
			loadList('1');
		},
		error:function(request, status, errorThrown){
				alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
		}			
	});
}

function goUpdateForm(seq) {
	var URL = "../selling/sellingMasterAjax";
	$.ajax({
		type:"POST",
		url:URL,
		data:{
			"seq":seq
		},
		dataType:"json",
		async:false,
		success:function(data) {
			if( data.seq != '' && data.seq != null ) {
				$("#seq").val(data.seq);
				$("#productName2").val(data.productName);
				$("#productCode2").val(data.productCode);
				$("#erpProductCode_div").html(data.erpProductCode);
				$("#searchUserId2").val(data.userName);
				$("#userId2").val(data.userId);
				$("#userName2").val(data.userName);
				$("#startDate2").val(data.startDate);
				
				openDialog('open2');
				goClear();
			} else {
				alert("삭제된 데이터 입니다.");
				loadList('1');
			}
			
		},
		error:function(request, status, errorThrown){
				alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
		}			
	});
}

function goUpdate() {
	if( !chkNull($("#productName2").val()) ) {
		alert("제품명을 입력해 주세요.");
		$("#productName2").focus();
		return;
	} else if( !chkNull($("#productCode2").val()) ) {
		alert("제품코드를 입력해 주세요.");
		$("#productCode2").focus();
		return;
	} else if( !chkNull($("#searchUserId2").val()) ) {
		alert("개발자를 입력해 주세요.");
		$("#searchUserId2").focus();
		return;
	} else if( !chkNull($("#userId2").val()) ) {
		alert("개발자를 입력해 주세요.");
		$("#searchUserId2").focus();
		return;
	} else if( !chkNull($("#startDate2").val()) ) {
		alert("등록일을 입력해 주세요.");
		$("#startDate2").focus();
		return;
	} else {
		var URL = "../selling/updateMasterAjax";
		var usreInfo = $("#searchUserId2").val();
		var jbSplit = usreInfo.split('/');
		$.ajax({
			type:"POST",
			url:URL,
			data:{
				"seq":$("#seq").val(),
				"productName":$("#productName2").val(),
				"productCode":$("#productCode2").val(),
				"userId":$("#userId2").val(),
				"startDate":$("#startDate2").val()
			},		
			dataType:"json",
			success:function(data) {
				if( data.result == 'success' ) {
					alert("수정되었습니다.");
					loadList('1');
					closeDialog('open2');
				} else {
					alert(data.message);
				}
			},
			error:function(request, status, errorThrown){
				alert("오류가 발생하였습니다.");
			}			
		});	
	}
}
</script>
<div class="wrap_in" id="fixNextTag">
	<span class="path">신제품 매출관리&nbsp;&nbsp;
		<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;
		<a href="#">${strUtil:getSystemName()}</a>
	</span>
	<section class="type01">
	<!-- 상세 페이지  start-->
		<h2 style="position:relative"><span class="title_s">Selling management</span>
			<span class="title">신제품 매출관리</span>
			<div  class="top_btn_box">
				<ul>
					<li>
						<button type="button" class="btn_circle_red" onClick="goInserForm()">&nbsp;</button>
					</li>
				</ul>
			</div>
		</h2>
		<div class="group01" >
			<div class="title"><!--span class="txt">연구개발시스템 공지사항</span--></div>
			<div class="search_box" >
				<ul>
					<li>
						<dt>키워드</dt>
						<dd >
							<div class="selectbox" style="width:100px;">  
								<label for="searchType" id="searchType_label">전체</label> 
								<select name="searchType" id="searchType">
									<option value="">전체</option>
									<option value="name">제품명</option>
									<option value="code">제품코드</option>
									<option value="userName">개발자</option>
									<option value="deptName">부서명</option>
									<option value="teamName">팀명</option>
								</select>								
							</div>
							<input type="text" name="searchValue" id="searchValue" style="width:180px; margin-left:5px;">
						</dd>
					</li>
					<li>
						<dt>개발자</dt>
						<dd >
							<div class="selectbox" style="width:100px;">  
								<label for="searchTeam" id="searchTeam_label">전체</label> 
								<select name="searchTeam" id="searchTeam" onChange="teamChange('searchTeam','searchUser')">
								</select>
							</div>
							<div class="selectbox ml5" style="width:180px;">  
								<label for="searchUser" id="searchUser_label">전체</label> 
								<select name="searchUser" id="searchUser">
								</select>
							</div>
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
					<button type="button" class="btn_con_search" onClick="javascript:goSearch()"><img src="/resources/images/btn_icon_search.png" style="vertical-align:middle;"/> 검색</button>
					<button type="button" class="btn_con_search" onClick="javascript:goClear();"><img src="/resources/images/btn_icon_refresh.png" style="vertical-align:middle;"/> 검색 초기화</button>
				</div>
			</div>
			<div class="main_tbl">
				<table class="tbl01">
					<colgroup>
						<col width="20%">
						<col width="8%">
						<col width="8%">
						<col width="10%">
						<col width="13%">
						<col width="13%">
						<col width="8%">
						<col width="8%">
						<col width="12%">
					</colgroup>
					<thead>
						<tr>
							<th>제품명</th>
							<th>제품코드</th>
							<th>ERP제품코드</th>
							<th>개발자</th>
							<th>부서명</th>
							<th>팀명</th>
							<th>시작</th>
							<th>종료</th>
							<th>&nbsp;</th>
						<tr>
					</thead>
					<tbody id="list">						
					</tbody>
				</table>
				<div class="page_navi  mt10">
				</div>
			</div>
			<div class="btn_box_con"> 
				<button type="button" class="btn_admin_sky" onClick="goInserForm()">신제품 등록</button>
			</div>
	 		<hr class="con_mode"/><!-- 신규 추가 꼭 데려갈것 !-->
		</div>
	</section>
</div>
<!-- 신제품 등록레이어 start-->
<div class="white_content" id="open">
	<div class="modal" style="	width: 700px;margin-left:-350px;height: 420px;margin-top:-200px;">
		<h5 style="position:relative">
			<span class="title">신제품 매출 데이터 등록</span>
			<div  class="top_btn_box">
				<ul>
					<li>
						<button type="button" class="btn_madal_close" onClick="goClose('open')"></button>
					</li>
				</ul>
			</div>
		</h5>
		<div class="list_detail">
			<ul>
				<li class="pt10">
					<dt>제품명</dt>
					<dd>		
						<input type="text" class="req" style="width:302px;" name="productName" id="productName"/>				 
					</dd>
				</li>
				<li>
					<dt>제품코드</dt>
					<dd>		
						<input type="text" class="req" style="width:302px;" name="productCode" id="productCode"/>				 
					</dd>
				</li>
				<li>
					<dt>ERP 제품코드</dt>						
					<dd>				
						<input type="text" class="req" style="width:302px;" name="erpProductCode" id="erpProductCode"/>		 
					</dd>
				</li>
				<li>
					<dt>개발자</dt>						
					<dd>		
						<input type="text" class="req" style="width:302px;" name="searchUserId" id="searchUserId"/>				
						<input type="hidden" class="req" name="userId" id="userId"/>
						<input type="hidden" class="req" name="userName" id="userName"/>
					</dd>
				</li>
				<li>
					<dt>등록일</dt>						
					<dd>		
						<input type="text" class="req" style="width:120px;" name="startDate" id="startDate" readonly/>				
					</dd>
				</li>
			</ul>
		</div>
		<div class="btn_box_con">
			<button type="button" class="btn_admin_red" id="insertForm" onClick="goInsert();">등록</button> 
			<button type="button" class="btn_admin_gray"onclick="goClose('open')"> 취소</button>
		</div>
	</div>
</div>
<!-- 신제품 등록레이어 close-->
<!-- 신제품 변경레이어 start-->
<div class="white_content" id="open2">
	<div class="modal" style="	width: 700px;margin-left:-350px;height: 420px;margin-top:-200px;">
		<h5 style="position:relative">
			<span class="title">신제품 매출 데이터 변경</span>
			<div  class="top_btn_box">
				<ul>
					<li>
						<button type="button" class="btn_madal_close" onClick="goClose('open2')"></button>
					</li>
				</ul>
			</div>
		</h5>
		<div class="list_detail">
			<ul>
				<li class="pt10">
					<dt>제품명</dt>
					<dd>		
						<input type="hidden" name="seq" id="seq"/>
						<input type="text" class="req" style="width:302px;" name="productName2" id="productName2"/>				 
					</dd>
				</li>
				<li>
					<dt>제품코드</dt>
					<dd>		
						<input type="text" class="req" style="width:302px;" name="productCode2" id="productCode2"/>				 
					</dd>
				</li>
				<li>
					<dt>ERP 제품코드</dt>						
					<dd>				
						<div id="erpProductCode_div"></div>		 
					</dd>
				</li>
				<li>
					<dt>개발자</dt>						
					<dd>		
						<input type="text" class="req" style="width:302px;" name="searchUserId2" id="searchUserId2"/>				
						<input type="hidden" class="req" name="userId2" id="userId2"/>
						<input type="hidden" class="req" name="userName2" id="userName2"/>
					</dd>
				</li>
				<li>
					<dt>등록일</dt>						
					<dd>		
						<input type="text" class="req" style="width:120px;" name="startDate2" id="startDate2" readonly/>				
					</dd>
				</li>
			</ul>
		</div>
		<div class="btn_box_con">
			<button type="button" class="btn_admin_red" id="insertForm" onClick="goUpdate();">수정</button> 
			<button type="button" class="btn_admin_gray"onclick="goClose('open2')"> 취소</button>
		</div>
	</div>
</div>
<!-- 신제품 변경레이어 close-->