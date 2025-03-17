<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ page session="false" %>
<title>결재함</title>
<script type="text/javascript">
var PARAM = {
		type : '${paramVO.type}',
		state : '${paramVO.state}',
		callType : '${paramVO.callType}',
		tbKey : '${paramVO.tbKey}',
		tbType : '${paramVO.tbType}',
		apprNo : '${paramVO.apprNo}',
		viewType : '${paramVO.viewType}',
		apprType : '${paramVO.apprType}'
	};
$(document).ready(function(){
	loadCount();
	loadList('1');
	if( '${paramVO.callType}' =='MAIL' ) {
		approvalInfo('${paramVO.apprNo}', '${paramVO.tbType}', '${paramVO.apprType}', '${paramVO.tbKey}', '${paramVO.viewType}');
	}
});	
	
	// 페이징
	function paging(pageNo){
		loadList(pageNo);
		//location.href = '/approval/list?' + getParam(pageNo);
	}	
	
	//파라미터 조회
	function getParam(pageNo){
		PARAM.pageNo = pageNo || '${paramVO.pageNo}';
		return $.param(PARAM);
	}
	
	function approvalInfo( apprNo, tbType, type, tbKey, viewType ) {
		var url = "";
		var mode = "";
		if( type == '0' ) {
			if( tbType == 'manufacturingProcessDoc' ) {
				url = "/approval/approvalDetailPopup?apprNo="+apprNo+'&tbKey='+tbKey+'&tbType='+tbType+'&viewType='+viewType;
				mode = "width=1100, height=600, left=100, top=10, scrollbars=yes";
			} else if( tbType == 'designRequestDoc' ) {
				url = "/approval/approvalDetailDesignPopup?apprNo="+apprNo+'&tbKey='+tbKey+'&tbType='+tbType+'&viewType='+viewType;
				mode = "width=1100, height=600, left=100, top=10, scrollbars=yes";
			} else if( tbType == 'materialManagement' ){
				url = "/approval/approvalDetailMaterialPopup?apprNo="+apprNo+'&tbKey='+tbKey+'&tbType='+tbType+'&viewType='+viewType;
				mode = "width=1100, height=550, left=100, top=10, scrollbars=yes";
			} else if( tbType == 'trialProductionReport' ){
				url = "/approval/approvalDetailTrialPopup?apprNo="+apprNo+'&tbKey='+tbKey+'&tbType='+tbType+'&viewType='+viewType;
				mode = "width=1100, height=550, left=100, top=10, scrollbars=yes";
			} else if( tbType == 'productDesignDocDetail' ){
				url = "/approval/approvalDetailProductPopup?apprNo="+apprNo+'&tbKey='+tbKey+'&tbType='+tbType+'&viewType='+viewType;
				mode = "width=1100, height=550, left=100, top=10, scrollbars=yes";
			} else if( tbType == 'manufacturingNoStopProcess' ){
				url = "/approval/approvalStopProcessPopup?apprNo="+apprNo+'&tbKey='+tbKey+'&tbType='+tbType+'&viewType='+viewType;
				mode = "width=1100, height=550, left=100, top=10, scrollbars=yes";
			} else if(tbType == 'trialReportCreate' || tbType == 'trialReportAppr2') {
				url = "/approval/approvalTrialReportCreatePopup?apprNo="+apprNo+'&tbKey='+tbKey+'&tbType='+tbType+'&viewType='+viewType;
				mode = "width=1100, height=550, left=100, top=10, scrollbars=yes";
			}else {
				url = "/approval/approvalDetailEtcPopup?apprNo="+apprNo+'&tbKey='+tbKey+'&tbType='+tbType+'&viewType='+viewType;
				mode = "width=1100, height=550, left=100, top=10, scrollbars=yes";
			}
		} else {
			if((tbType == 'trialReportCreate' || tbType == 'trialReportAppr2') && type != "3"){
				url = "/approval/approvalTrialReportCreatePopup?apprNo="+apprNo+'&tbKey='+tbKey+'&tbType='+tbType+'&viewType='+viewType;
				mode = "width=1100, height=550, left=100, top=10, scrollbars=yes";
			}else{
				url = "/approval/approvalDetailEtcPopup?apprNo="+apprNo+'&tbKey='+tbKey+'&tbType='+tbType+'&viewType='+viewType;
				mode = "width=1100, height=550, left=100, top=10, scrollbars=yes";
			}
		}
		window.open(url, "ApprovalPopup", mode );
	}
	
	function loadCount() {
		var URL = "../approval/apprCountInfoAjax";
		$.ajax({
			type:"POST",
			url:URL,
			data:{
			},
			dataType:"json",
			success:function(data) {
				$("#myCount").html("");
				$("#apprCount").html("");
				$("#refCount").html("");
				$("#apprCount").html("내가 받은 결재문서 (대기"+data.apprCount+"건)");
				$("#myCount").html("내가 올린 결재문서 (요청"+data.myCount+"건)");
				$("#refCount").html("참조 및 회람문서 (신규"+data.refCount+"건)");
			},
			error:function(request, status, errorThrown){
				$("#apprCount").html("내가 받은 결재문서 (대기0건)");
				$("#myCount").html("내가 올린 결재문서 (요청0건)");
				$("#refCount").html("참조 및 회람문서 (신규0건)");
			}			
		});	
	}

	function loadList( pageNo ) {
		var viewCount = $("#viewCount").selectedValues()[0];
		if( viewCount == '' ) {
			viewCount = "10";
		}
		var URL = "../approval/approvalListAjax";
		$.ajax({
			type:"POST",
			url:URL,
			data:{
					"pageNo":pageNo,
					"type":$(":input:radio[name=type]:checked").val(),
					"searchType":$("#searchType").selectedValues()[0],
					"searchValue":$("#searchValue").val(),
					"viewCount":viewCount
			},
			dataType:"json",
			success:function(data) {
				var html = "";
				if( data.totalCount > 0 ) {
					$("#list").html(html);
					data.approvalList.forEach(function (item) {
						html += "	<tr>";
						html += "		<td>"+item.apprNo+"</td>";
						html += "		<td>"+item.tbTypeName+"</td>";
						html += "		<td>"+item.typeName+"</td>";
						if( item.lastState == '0' ) {
							html += "		<td><span class=\"app01\">"+item.lastStateName+" ("+item.currentStep+"/"+item.totalStep+")</span></td>";
						} else if( item.lastState == '1' ) {
							html += "		<td><span class=\"app02\">"+item.lastStateName+"</span></td>";
						} else if( item.lastState == '2' ) {
							html += "		<td><span class=\"app03\">"+item.lastStateName+"</span></td>";
						}
						html += "		<td><div class=\"ellipsis_txt tgnl\">";
						html += "			<a href=\"#\" onclick=\"approvalInfo('"+item.apprNo+"', '"+item.tbType+"', '"+item.type+"', '"+item.tbKey+"','appr'); return false;\">"+item.title+"</a>";
						html += "		</td>";
						html += "		<td>"+nvl(item.regUserName,'')+"</td>";
						html += "		<td>"+item.modDate+"</td>";
						html += "	</tr>	";		
					});
					$("#list").html(html);
					$('.page_navi').html(data.navi.prevBlock+data.navi.pageList+data.navi.nextBlock);
					$('#pageNo').val(data.navi.pageNo);
				} else {
					$("#list").html(html);
					html += "<tr><td align='center' colspan='7'>데이터가 없습니다.</td></tr>";
					$("#list").html(html);
					$('.page_navi').html(data.navi.prevBlock+data.navi.pageList+data.navi.nextBlock);
					$('#pageNo').val(data.navi.pageNo);
				}
			},
			error:function(request, status, errorThrown){
				var html = "";
				$("#list").html(html);
				html += "<tr><td align='center' colspan='7'>오류가 발생하였습니다.</td></tr>";
				$("#list").html(html);
				$('.page_navi').html(data.navi.prevBlock+data.navi.pageList+data.navi.nextBlock);
				$('#pageNo').val(data.navi.pageNo);
			}			
		});	
	}	
	
	function goSearch() {
		loadList('1');
	}
	
	function goClear() {
		$("input:radio[name='type']:radio[value='']").prop('checked', true); // 선택하기
		$("#searchType").selectOptions("");
		$("#searchType_label").html("선택");
		$("#searchValue").val("");
		$("#viewCount").selectOptions("");
		$("#viewCount").html("선택");
		goSearch();
	}
	
</script>
<input type="hidden" name="pageNo" id="pageNo" value="${paramVO.pageNo}">
<div class="wrap_in" id="fixNextTag">
	<span class="path">결재함&nbsp;&nbsp;
		<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;
		<a href="#">${strUtil:getSystemName()}</a>
	</span>
	<section class="type01">
	<!-- 상세 페이지  start-->
		<h2 style="position:relative"><span class="title_s">Approval Doc</span>
			<span class="title">내가 받은 결재문서</span>
			<div  class="top_btn_box">
				<ul><li></li></ul>
			</div>
		</h2>
		<div class="group01" >
			<div class="title"><!--span class="txt">연구개발시스템 공지사항</span--></div>
			<div class="tab02">
				<ul>
				<!-- 선택됬을경우는 탭 클래스에 select를 넣어주세요 -->
				<!-- 내 제품설계서 같은경우는 change select 이렇게 change 그대로 두고 한칸 띄고 select 삽입 -->
				<a href="#"><li class="select" id="apprCount">내가 받은 결재문서</li></a>
				<a href="/approval/list"><li class="" id="myCount">내가 올린 결재문서</li></a>
				<a href="/approval/refList"><li class="" id="refCount">참조 및 회람문서</li></a>
				<a href="/approval/approvingList"><li class="" id="">결재진행중 문서</li></a>
				</ul>
			</div>
			<div class="search_box" >
				<ul style="border-top:none;">
					<li>
						<dt>문서상태</dt>
						<dd style="width:400px">
						<!-- 초기값은 보통으로 -->
							<input type="radio" id="r1" name="type" value="" checked/ ><label for="r1"><span></span>전체</label>
							<input type="radio" id="r2" name="type" value="0"/><label for="r2"><span></span>결재대기</label>
							<input type="radio" id="r3" name="type" value="1"><label for="r3"><span></span>결재완료</label>
							<input type="radio" id="r4" name="type" value="2"><label for="r4"><span></span>결재반려</label>
						</dd>
					</li>
					<li>
						<dt>키워드</dt>
						<dd style="widht:400px">
							<div class="selectbox" style="width:100px;">  
								<label for="searchType" id="searchType_label">선택</label> 
								<select id="searchType" name="searchType">
									<option value="">선택</option>
									<option value="U">기안자</option>
									<option value="K">제목</option>
								</select>
							</div>
							<input type="text" name="searchValue" id="searchValue" style="width:200px; margin-left:5px;"/>
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
					<button type="button" class="btn_con_search" onClick="goSearch()"><img src="/resources/images/btn_icon_search.png" style="vertical-align:middle;"/> 검색</button>
					<button type="button" class="btn_con_search" onClick="goClear()"><img src="/resources/images/btn_icon_refresh.png" style="vertical-align:middle;"/> 검색 초기화</button>
				</div>
			</div>
			<div class="main_tbl">
				<table class="tbl01">
					<colgroup>
						<col width="10%">
						<col width="10%">
						<col width="10%">
						<col width="13%">
						<col />
						<col width="10%">
						<col width="15%">
						<col width="8%">
					</colgroup>
					<thead>
						<tr>
							<th>결재번호</th>
							<th>문서구분</th>
							<th>결재유형</th>
							<th>결재진행단계</th>
							<th>결재문서명</th>
							<th>기안자</th>
							<th>상신일</th>
						</tr>
					</thead>
					<tbody id="list">
					</tbody>
				</table>	
				<div class="page_navi  mt10">
				</div>
			</div>
			<div class="btn_box_con"></div>
			<hr class="con_mode"/><!-- 신규 추가 꼭 데려갈것 !-->
		</div>
	</section>
</div>
<!-- 결재상태보기레이어 start-->
<div class="white_content" id="open3">
	<div class="modal" style="	width: 700px;margin-left:-350px;height: 420px;margin-top:-200px;">
		<h5 style="position:relative">
			<span class="title">결재상태 보기</span>
			<div  class="top_btn_box">
				<ul>
					<li>
						<button class="btn_madal_close" onClick="location.href='#close'"></button>
					</li>
				</ul>
			</div>
		</h5>
		<div class="title6">
			<span class="txt">프린트 및 다운로드 결재</span>
		</div>
		<div class="main_tbl">
			<table class="insert_proc01 tbl_app">
				<colgroup>
					<col width="13%"/>
					<col width="50%"/>
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th style="border-left: none;">요청사유</th>
						<td colspan="3">프린트 때문에 결재가 필요해요 해주세요</td></tr>
					<tr>
						<th style="border-left: none;"> 결재자</th>
						<td><div class="file_box_pop5">
								<ul>
									<li onMouseOver="location.href='#'"><span>1차결재</span> 이성희 <strong> 부장/총무부&nbsp;(</strong><i> 승인</i><strong> :2019:01:12 23:23 ) </strong> 의견 <img src="/resources/images/icon_app_mass.png"/></li>
									<li><span>2차결재</span> 이성희 <strong> 부장/마케팅본부 Bakery&nbsp;(</strong><i> 승인</i><strong> :2019:01:12 23:23 ) </strong> 의견 <img src="/resources/images/icon_app_mass.png"/></li>
									<li><span>3차결재</span> 이성희 <strong> 부장/총무부</strong></li>
								</ul>
							</div>
						</td>
						<td>결재자 리스트 클릭시 결재의견을 확인할 수 있습니다.</td>
					</tr>
					<tr>
						<th style="border-left: none; ">참조자 및 회람자</th>
						<td>
							<div class="file_box_pop4">
								<ul>
									<li><span> 회람</span> 이성희 <strong> 부장/총무부</strong></li>
									<li><span> 회람</span> 이성희 <strong> 부장/총무부</strong></li>
								</ul>
							</div>
						</td>
						<td>
							<div class="file_box_pop4">
								<ul>
									<li><span> 참조</span> 이성희 <strong> 부장/총무부</strong></li>
									<li><span> 참조</span> 이성희 <strong> 부장/총무부</strong></li>
								</ul>
							</div>
						</td>
					</tr>
					<tr>
						<th style="border-left: none; ">결재의견</th>
						<td colspan="3">
							<textarea style="width:100%; height:60px"></textarea>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div class="fr pt20 pb10" style="margin-bottom:10px;">
			<button class="btn_con_search"style="border-color:#09F; color:#09F"><img src="/resourcesimages/icon_s_approval.png"> 승인</button>
			<button class="btn_con_search" ><img src="/resourcesimages/icon_doc06.png"> 반려</button>
		</div>
	</div>
</div>
<!-- 결재상태보기레이어 close-->		