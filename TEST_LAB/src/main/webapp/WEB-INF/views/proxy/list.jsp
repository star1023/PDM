<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ page import="kr.co.aspn.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ page session="false" %>
<%
	String isAdmin = UserUtil.getIsAdmin(request);
	String userId = UserUtil.getUserId(request);
	String userName = UserUtil.getUserName(request);
%>
<title>대결자 지정</title>
<link href="/resources/js/jquery.auto-complete.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="/resources/js/jquery.auto-complete.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	loadList('1');
	$("#startDate").datepicker({
		showOn: "both",
		buttonImage: "../resources/images/btn_calendar.png",
		buttonImageOnly: true,
		buttonText: "Select date",
		dateFormat: "yy-mm-dd",
		minDate: 0,
		showButtonPanel: true,
		showAnim: "",
		onClose: function(selectedDate){
			$("#endDate").datepicker("option", "minDate", selectedDate);
		}
	});	//당일 선택 가능 0, 당일 선택 불가능 1
	
	$("#endDate").datepicker({
		showOn: "both",
		buttonImage: "../resources/images/btn_calendar.png",
		buttonImageOnly: true,
		buttonText: "Select date",
		dateFormat: "yy-mm-dd",
		minDate: 0,
		showButtonPanel: true,
		showAnim: "",
		onClose: function(selectedDate){
			$("#startDate").datepicker("option", "maxdate", selectedDate)
		}
	});
	$("#searchStartDate").datepicker({
		showOn: "both",
		buttonImage: "../resources/images/btn_calendar.png",
		buttonImageOnly: true,
		buttonText: "Select date",
		dateFormat: "yy-mm-dd",
		showButtonPanel: true,
		showAnim: "",
		onClose: function(selectedDate){
			$("#searchEndDate").datepicker("option", "minDate", selectedDate);
		}
	});	//당일 선택 가능 0, 당일 선택 불가능 1
	
	$("#searchEndDate").datepicker({
		showOn: "both",
		buttonImage: "../resources/images/btn_calendar.png",
		buttonImageOnly: true,
		buttonText: "Select date",
		dateFormat: "yy-mm-dd",
		showButtonPanel: true,
		showAnim: "",
		onClose: function(selectedDate){
			$("#searchStartDate").datepicker("option", "maxdate", selectedDate);
		}
	});
	$("img.ui-datepicker-trigger").css({
		marginLeft: '2px',
		verticalAlign: 'middle',
		cursor: 'Pointer'
	});
});

function loadList( pageNo ) {
	var URL = "../proxy/proxyListAjax";
	$("#pageNo").val(pageNo);
	$.ajax({
		type:"POST",
		url:URL,
		data:{
			"searchType":$("#searchType").selectedValues()[0],
			"keyword":$('#keyword').val(),
			"searchStartDate":$('#searchStartDate').val(),
			"searchEndDate":$('#searchEndDate').val(),
			"pageNo":pageNo
		},		
		dataType:"json",
		success:function(data) {
			var html = "";
			if( data.totalCount > 0 ) {
				$("#list").html(html);
				data.proxyList.forEach(function (item) {
					html += "<tr>";
					html += "	<td>"+item.sourceUserName+"("+item.sourceUserDeptName+")</td>";
					html += "	<td>"+item.targetUserName+"("+item.targetUserDeptName+")</td>";
					html += "	<td>"+item.startDate+"</td>";
					html += "	<td>"+item.endDate+"</td>";
					html += "	<td>";
					if( item.isDeleteData == 'Y' ) {
						html += "		<ul class=\"list_ul\">";
						html += "			<li><button class=\"btn_doc\" onClick=\"javascript:goDelete('"+item.paNo+"')\"><img src=\"/resources/images/icon_doc04.png\"> 삭제</button></li>";
						html += "		</ul>";	
					} 
					html += "	</td>";
					html += "</tr>";
				});
				$("#list").html(html);
				
			} else {
				$("#list").html(html);
				html += "<tr><td align='center' colspan='5'>데이터가 없습니다.</td></tr>";
			}
			$('.page_navi').html(data.navi.prevBlock+data.navi.pageList+data.navi.nextBlock);
			$('#pageNo').val(data.navi.pageNo);
			$("#list").html(html);			
		},
		error:function(request, status, errorThrown){
			var html = "";
			$("#list").html(html);
			html += "<tr><td align='center' colspan='5'>오류가 발생하였습니다.</td></tr>";
			$("#list").html(html);
		}			
	});	
}

$(function() {
	$('#searchSourceUserId').autoComplete({
		minChars: 2,
		delay: 100,
		cache: false,
		source: function(term, response){
			$.ajax({
				type: 'POST',
				url: '../common/userListAjax2',
				dataType: 'json',
				data: {
					"searchUser" : $("#searchSourceUserId").val()
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
			$("#searchSourceUserId").val(item.data('nm'));
			$("#sourceUserId").val(item.data('code'));
			$("#sourceUserName").val(item.data('nm'));
		},
		focus: function(event, ui) {
	         return false;
		}	
	});
});

$(function() {
	$('#searchTargetUserId').autoComplete({
		minChars: 2,
		delay: 100,
		cache: false,
		source: function(term, response){
			$.ajax({
				type: 'POST',
				url: '../common/userListAjax2',
				dataType: 'json',
				data: {
					"searchUser" : $("#searchTargetUserId").val()
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
			$("#searchTargetUserId").val(item.data('nm'));
			$("#targetUserId").val(item.data('code'));
		},
		focus: function(event, ui) {
	         return false;
		}	
	});
});

function goInsert() {
	if( !chkNull($("#sourceUserId").val())  ) {
		alert("결재자를 입력하여 주세요.");
		$("#searchSourceUserId").focus();
		return;
	} else if( !chkNull($("#targetUserId").val()) ) {
		alert("대결자를 입력하여 주세요.");
		$("#searchTargetUserId").focus();
		return;
	} else if( !chkNull($("#startDate").val()) ) {
		alert("결재시작일을 입력하여 주세요.");
		$("#startDate").focus();
		return;
	} else if( !chkNull($("#endDate").val()) ) {
		alert("결재종료일을 입력하여 주세요.");
		$("#endDate").focus();
		return;
	} else {
		var URL = "../proxy/insertAjax";
		var usreInfo = $("#sourceUserName").val();
		var jbSplit = usreInfo.split('/');
		$.ajax({
			type:"POST",
			url:URL,
			data:{
				"sourceUserId":$("#sourceUserId").val(),
				"sourceUserName":jbSplit[0],
				"targetUserId":$("#targetUserId").val(),
				"startDate":$("#startDate").val(),
				"endDate":$("#endDate").val()
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

function goDelete( paNo ) {
	if(confirm("삭제후에는 복구할 수 없습니다. 삭제하시겠습니까? ")){
		var URL = "../proxy/deleteAjax";
		$.ajax({
			type:"POST",
			url:URL,
			data:{"paNo":paNo},
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

function goSearch() {
	loadList('1');
}

function goClear() {
	$("#searchType").selectOptions("");
	$('#keyword').val("");
	$('#searchStartDate').val("");
	$('#searchEndDate').val("");
	$("#searchType_label").html("전체");
	goSearch();
}
</script>
<input type="hidden" name="pageNo" id="pageNo" value="">
<div class="wrap_in" id="fixNextTag">
	<span class="path">대결자 관리&nbsp;&nbsp;
		<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;
		<a href="#">${strUtil:getSystemName()}</a>
	</span>
	<section class="type01">
	<!-- 상세 페이지  start-->
		<h2 style="position:relative">
			<span class="title_s">Proxy Approve Management</span>
			<span class="title">대결자 관리</span>
			<div  class="top_btn_box">
				<div  class="top_btn_box">
					<ul><li><button class="btn_circle_red" onClick="openDialog('open')">&nbsp;</button></li></ul>
				</div>
			</div>
		</h2>
		<div class="group01">
			<div class="title"><!--span class="txt">연구개발시스템 공지사항</span--></div>
			<div class="search_box" >
				<ul>
					<li>
						<dt>키워드</dt>
						<dd>
							<div class="selectbox" style="width:120px;">  
								<label for="searchType" id="searchType_label">전체</label> 
								<select name="searchType" id="searchType">
									<option value="">전체</option>
									<% if( isAdmin != null && "Y".equals(isAdmin)) {%>
									<option value="C">현재결재자</option>
									<% } %>
									<option value="P">대리결재자</option>
								</select>
							</div>
							<input type="text" name="keyword" id="keyword" value="" class="ml5" style="width:180px;"/>
						</dd>
					</li>
					<li>
						<dt>결재기간</dt>
						<dd>
							<input type="text" name="searchStartDate" id="searchStartDate" value="" style="width:110px;" readonly/> ~ 
							<input type="text" name="searchEndDate" id="searchEndDate" value="" style="width:110px;" readonly/>
						</dd>
					</li>
				</ul>
				<div class="fr pt5 pb10">					 
					<button type="button" class="btn_con_search" onClick="goSearch();"><img src="/resources/images/btn_icon_search.png" style="vertical-align:middle;"/> 검색</button>
					<button type="button" class="btn_con_search" onClick="goClear();"><img src="/resources/images/btn_icon_refresh.png" style="vertical-align:middle;"/> 검색 초기화</button>
				</div>
			</div>
			<div class="main_tbl">
				<table class="tbl01">
					<colgroup>
						<col width="30%">
						<col width="30%">
						<col width="17%">
						<col width="17%">
						<col width="6%">
					</colgroup>
					<thead>
						<tr>
							<th>현재결재자</th>
							<th>대리결재자</th>
							<th>대리결재 시작일</th>
							<th>대리결재 종료일</th>
							<th>&nbsp;</th>
						</tr>	
					</thead>
					<tbody id="list">
					
					</tbody>
				</table>
				<div class="page_navi  mt10">
				</div>
				<div class="btn_box_con">
					<input type='button' value="대결자 등록" class="btn_admin_red" onclick="openDialog('open')">
				</div>
			 		<hr class="con_mode"/><!-- 신규 추가 꼭 데려갈것 !-->
				</div>
		</div>
	</section>	
</div>

<!-- 대결자 등록 레이어 start-->
<div class="white_content" id="open">
	<div class="modal" style="	width: 500px;margin-left:-250px;height: 320px;margin-top:-150px;">
		<h5 style="position:relative">
			<span class="title">대결자 등록</span>
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
					<dt>결재자</dt>
					<dd>
						<% if( isAdmin != null && "Y".equals(isAdmin)) {%>
						<input type="text" style="width:302px;" class="req" name="searchSourceUserId" id="searchSourceUserId" placeholder="결재자명 2자이상 입력후 선택"/>
						<input type="hidden" class="req" name="sourceUserId" id="sourceUserId"/>
						<input type="hidden" class="req" name="sourceUserName" id="sourceUserName"/>
						<% } else { %>
						<%=userName%>
						<input type="hidden" class="req" name="sourceUserId" id="sourceUserId" value="<%=userId%>"/>
						<input type="hidden" class="req" name="sourceUserName" id="sourceUserName" value="<%=userName%>"/>
						<% } %>
					</dd>
				</li>
				<li>
					<dt>대리 결재자</dt>
					<dd>
						<input type="text"  style="width:302px;" class="req" name="searchTargetUserId" id="searchTargetUserId" placeholder="대리 결재자명 2자이상 입력후 선택"/>
						<input type="hidden"  class="req" name="targetUserId" id="targetUserId"/>
					</dd>
				</li>
				<li>
					<dt>결재 기간</dt>
					<dd>
						<input type="text"  style="width:120px;" class="req" name="startDate" id="startDate" readonly/> ~
						<input type="text"  style="width:120px;" class="req" name="endDate" id="endDate" readonly/>
					</dd>
				</li>
			</ul>
		</div>
		<div class="btn_box_con">
			<button type="button" class="btn_admin_red" onclick="goInsert();">등록</button> 
			<button type="button" class="btn_admin_gray" onclick="closeDialog('open')"> 취소</button>
		</div>
	</div>
</div>
<!-- 대결자 등록 레이어 close-->