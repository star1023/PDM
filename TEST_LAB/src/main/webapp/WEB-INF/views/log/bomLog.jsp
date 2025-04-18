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

<title>시스템 로그</title>

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
	
	$(document).ready(function(){
		loadList(1);
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
		
		$("#list").html("<tr><td align='center' colspan='9'>조회중입니다.</td></tr>");
		$('.page_navi').html("");
		$.ajax({
			url:"/log/bomLogListAjax",
			type:"POST",
			data:{
				"isSample":isSample, "searchCompany":searchCompany, 
				"searchPlant":searchPlant, "searchType":searchType, 
				"searchValue":searchValue, "viewCount":viewCount, "pageNo":pageNo
			},
			dataType:"json",
			success:function(data) {
				var html = "";
				if(data.bomLogList.length <= 0){
					html = "<tr><td align='center' colspan='9'>등록된 내용이 없습니다.</td></tr>"
				} else {
					for (var i = 0; i < data.bomLogList.length; i++) {
						var row = data.bomLogList[i];
						
						html += "<tr>";
						html += "	<td>"+row.rn+"</td>";
						html += "	<td>"+row.bhNo+"</td>";
						html += "	<td style='text-align:left;'>"+row.MAKTX2+"</td>";
						html += "	<td>"+row.companyName+"</td>";
						html += "	<td>"+row.plant+"</td>";
						html += "	<td>"+row.MATNR+"</td>";
						html += "	<td>"+row.STLAL+"</td>";
						html += "	<td>"+row.userName+"</td>";
						html += "	<td>"+row.regDate+"</td>";
						html += "</tr>";
					}
				}
				
				$("#list").html(html);
				$('.page_navi').html(data.navi.prevBlock+data.navi.pageList+data.navi.nextBlock);
				$('#pageNo').val(data.navi.pageNo);
			},
			error:function(request, status, errorThrown){
				console.log(request, status, errorThrown)
				var html = "";
				$("#list").html(html);
				html += "<tr><td align='center' colspan='9'>오류가 발생하였습니다.</td></tr>";
				$("#list").html(html);
				$('.page_navi').html(data.navi.prevBlock+data.navi.pageList+data.navi.nextBlock);
				$('#pageNo').val(data.navi.pageNo);
			}			
		});	
	}
	
	
</script>

<input type="hidden" name="pageNo" id="pageNo" value="${paramVO.pageNo}">
<input type="hidden" name="imNo" id="imNo" value="">
<div class="wrap_in" id="fixNextTag">
	<span class="path">시스템 로그&nbsp;&nbsp;
		<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;
		<a href="#">${strUtil:getSystemName()}</a>
	</span>
	<section class="type01">
		<!-- 상세 페이지  start-->
		<h2 style="position: relative">
			<span class="title_s">System Log</span> <span class="title">시스템 로그</span>
			<div class="top_btn_box">
				<ul>
					<li>
						<button type="button" class="btn_circle_red" onClick="openMtchDialog();">&nbsp;</button>
					</li>
				</ul>
			</div>
		</h2>
		<div class="group01">
			<div class="title">
				<!--span class="txt">연구개발시스템 공지사항</span-->
			</div>
			<div class="tab02">
				<ul>
					<!-- 선택됬을경우는 탭 클래스에 select를 넣어주세요 -->
					<!-- 내 제품설계서 같은경우는 change select 이렇게 change 그대로 두고 한칸 띄고 select 삽입 -->
					<a href="/log/loginLog"><li class="">로그인</li></a>
					<a href="/log/accessLog"><li class="">사용자 접근기록</li></a>
					<a href="/log/bomLog"><li class="select">BOM 반영</li></a>
					<a href="/log/printLog"><li class="">프린트/엑셀다운로드</li></a>
					<!-- <a href="/log/mfgNo"><li class="">품목제조보고서</li></a> -->
				</ul>
			</div>
			<div class="search_box">
				<ul style="border-top:none;">
					<li>
						<dt>키워드</dt>
						<dd>
							<div class="selectbox" style="width: 100px;">
								<label for="searchType" id="searchType_label">선택</label> <select name="searchType" id="searchType">
									<option value="" selected>선택</option>
									<option value="MAKTX2">제품명</option>
									<option value="regUserId">사용자ID</option>
									<option value="userName">사용자명</option>
									<option value="companyName">회사</option>
									<option value="plant">공장</option>
									<option value="MATNR">제품코드</option>
									
								</select>
							</div>
							<input type="text" name="searchValue" id="searchValue" value="${paramVO.searchValue}" style="width: 180px; margin-left: 5px;">
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
						<col width="5%">
						<col width="5%">
						<col/>
						<col width="10%">
						<col width="15%">
						<col width="5%">
						<col width="7%">
						<%-- <col width="5%"> --%>
						<col width="8%">
						<col width="12%">
					</colgroup>
					<thead>
						<tr>
							<th>번호</th>
							<th>LogID</th>
							<th>제품명</th>
							<th>회사</th>
							<th>공장</th>
							<th>제품코드</th>
							<th>대체BOM</th>
							<!-- <th>Flag</th> -->
							<th>실행자명</th>
							<th>실행일시</th>
						<tr>
					</thead>
					<tbody id="list">
						<tr><td align='center' colspan='9'>조회중입니다.</td></tr>
					</tbody>
				</table>
				<div class="page_navi  mt10"></div>
			</div>
			<hr class="con_mode" />
			<!-- 신규 추가 꼭 데려갈것 !-->
		</div>
	</section>
</div>