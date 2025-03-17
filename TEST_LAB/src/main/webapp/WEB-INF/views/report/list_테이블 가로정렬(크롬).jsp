<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ page session="false" %>
<title>레포트</title>
<script type="text/javascript" src='<c:url value="/resources/js/jquery.selectboxes.js"/>'></script>
<script type="text/javascript">
	var PARAM = {
		category1 : '${paramVO.category1}',
		//category2 : '${paramVO.category2}',
		//category3 : '${paramVO.category3}',
		keyword : '${paramVO.keyword}',
		pageNo : '${paramVO.pageNo}'
	};
	
	$(document).ready(function(){
		loadCategory("category1");
		//$("#category1").selectOptions('${paramVO.category1}');
		$("#keyword").val('${paramVO.keyword}');
		loadList('${paramVO.pageNo}');
	});	
	
	function loadList( pageNo ) {
		var URL = "../report/listAjax";
		$.ajax({
			type:"POST",
			url:URL,
			data:{
					"pageNo":pageNo,
					"category1":$("#category1").selectedValues()[0],
					"keyword":$("#keyword").val(),
					"viewCount":$("#viewCount").val()
			},
			dataType:"json",
			success:function(data) {
				var html = "";
				if( data.totalCount > 0 ) {
					$("#list").html(html);
					data.reportList.forEach(function (item) {
						html += "	<tr>";
						html += "		<td>"+item.category1Name+"</td>";
						html += "		<td>";
						if( item.fileCount > 0 ) {
							html += "			<img src=\"/resources/images/icon_file01.png\" style=\"vertical-align:middle;\"/>";
						} else {
							html += "&nbsp";
						}
						html += "		</td>";
						html += "		<td>";
						html += "			<div class=\"ellipsis_txt tgnl\">";
						html += "			<a href=\"#\" onclick=\"goView('"+item.reportKey+"', '"+item.regUserId+"')\">";
						/*if( item.category1 == '8' ) {
							html += item.testTitle;
						} else if( item.category1 == '9' ) {
							html += item.seminarTitle;
						} else */
						if( (item.title == null || item.title == '') && item.reportDate != null ) {
							html += "		[보고일자: "+item.reportDate+" "+item.prdTitle+"]";
						} else {
							html += item.title;
						}
						html += "			</a>";
						html += "			</div>";
						html += "		</td>";	
						html += "		<td>"+item.userName+"</td>";
						html += "		<td>"+item.regDate+"</td>";
						html += "	</tr>	";		
					});
					$("#list").html(html);
					$('.page_navi').html(data.navi.prevBlock+data.navi.pageList+data.navi.nextBlock);
					$('#pageNo').val(data.navi.pageNo);
				} else {
					$("#list").html(html);
					html += "<tr><td align='center' colspan='5'>데이터가 없습니다.</td></tr>";
					$("#list").html(html);
					$("#list").html(html);
					$('.page_navi').html(data.navi.prevBlock+data.navi.pageList+data.navi.nextBlock);
					$('#pageNo').val(data.navi.pageNo);
				}
			},
			error:function(request, status, errorThrown){
				var html = "";
				$("#list").html(html);
				html += "<tr><td align='center' colspan='5'>오류가 발생하였습니다.</td></tr>";
				$("#list").html(html);
				$('.page_navi').html(data.navi.prevBlock+data.navi.pageList+data.navi.nextBlock);
				$('#pageNo').val(data.navi.pageNo);
			}			
		});	
	}
	
	function loadCategory(selectBoxId) {
		var URL = "../common/codeListAjax";
		$.ajax({
			type:"POST",
			url:URL,
			data:{
					"groupCode":"REPORTCATEGORY1"
			},
			dataType:"json",
			success:function(data) {
				var list = data.RESULT;
				$("#"+selectBoxId).removeOption(/./);
				$("#"+selectBoxId).addOption("", "전체", false);
				$.each(list, function( index, value ){ //배열-> index, value
					if( value.itemCode == '${paramVO.category1}' ) {
						$("#"+selectBoxId).addOption(value.itemCode, value.itemName, true);
						$("#category1_label").html(value.itemName);
					} else {
						$("#"+selectBoxId).addOption(value.itemCode, value.itemName, false);
					}
				});
			},
			error:function(request, status, errorThrown){
			}			
		});	
	}
	
	function goView(rNo, regUserId){
		var URL = "/user/reportViewAuthCheck";
		
		var valid = false;
			
		$.ajax({
			url: URL,
			async: false,
			data: { regUserId: regUserId },
			success: function(data){
				if(data.result == 'T'){
					valid = true;
				} else {
					alert(data.resultText);
				}
				
			},
			error: function(a,b,c){
				//console.log(a,b,c);
				alert('권한 체크 오류 - 시스템 담당자에게 문의하세요')
				return;
			}
		});
		
		if(!valid) return;
		
		$("#rNo").val(rNo);
		document.listForm.action="/report/view";
		document.listForm.submit();
	}
	
	function goInsertForm(pageNo){
		location.href = '/report/insertForm?' + getParam(pageNo);
	}
	
	//페이징
	function paging(pageNo){
		loadList(pageNo);
		//location.href = '/report/list?' + getParam(pageNo);
	}	
	
	//파라미터 조회
	function getParam(pageNo){
		PARAM.pageNo = pageNo || '${paramVO.pageNo}';
		return $.param(PARAM);
	}
	
	function nvl(str, defaultStr){
        
        if(typeof str == "undefined" || str == null || str == "")
            str = defaultStr ;
         
        return str ;
    }
	
	function goSearch() {
		loadList('1');
	}
	
	function goClear() {
		$("#category1").selectOptions("");
		$("#category1_label").html("선택");
		$("#keyword").val("");
		goSearch();
	}

</script>
<form name="listForm" id="listForm" method="post">
<input type="hidden" name="rNo" id="rNo"/>
<input type="hidden" name="pageNo" id="pageNo" value="${paramVO.pageNo}"/>
<div class="wrap_in" id="fixNextTag">
	<span class="path">보고서&nbsp;&nbsp;
		<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;
		<a href="#">${strUtil:getSystemName()}</a>
	</span>
	<section class="type01">
	<!-- 상세 페이지  start-->
		<h2 style="position:relative">
			<span class="title_s">Report</span>
			<span class="title">보고서</span>
			<div  class="top_btn_box">
				<div  class="top_btn_box">
					<ul><li><button type="button" class="btn_circle_red" onclick="javascript:goInsertForm('${paramVO.pageNo}');">&nbsp;</button></li></ul>
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
							<div class="selectbox" style="width:150px;">  
								<label for="category1" id="category1_label">전체</label> 
								<select id="category1" name="category1">
									<option value="">전체</option>
								</select>
							</div>
							<input type="text" name="keyword" id="keyword" value="${paramVO.keyword}" class="ml5" style="width:150px;"/>
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
					<button type="button" class="btn_con_search" onClick="goSearch();"><img src="/resources/images/btn_icon_search.png" style="vertical-align:middle;"/> 검색</button>
					<button type="button" class="btn_con_search" onClick="goClear();"><img src="/resources/images/btn_icon_refresh.png" style="vertical-align:middle;"/> 검색 초기화</button>
				</div>
			</div>
			<div class="main_tbl">
				<div style="width: 100%; display: inline-flex; ">
					<div style="width: 20%; position: relative;">
						<table class="tbl01">
							<colgroup>
								<col width="100%">
							</colgroup>
							<thead>
								<tr>
									<th></th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td rowspan="10">
										전체
										<br>제품보고서
										<br>품질보고서
										
										<br>제품보고서
										<br>품질보고서
										
										<br>제품보고서
										<br>품질보고서
										
										<br>제품보고서
										<br>품질보고서
										
										<br>제품보고서
										<br>품질보고서
										
										<br>제품보고서
										<br>품질보고서
										
										<br>제품보고서
										<br>품질보고서
										
										<br>제품보고서
										<br>품질보고서
										
										<br>제품보고서
										<br>품질보고서
									<td>
								</tr>
							</tbody>
						</table>
					</div>
					<div style="width: 70%; position: relative;">
						<table class="tbl01">
							<colgroup>
								<col width="20%">
								<col width="5%">
								<col />
								<col width="10%">
								<col width="20%">
							</colgroup>
							<thead>
								<tr>
									<th>분류</th>
									<th>&nbsp;</th>
									<th>보고서명</th>
									<th>보고자</th>
									<th>등록일</th>
								</tr>	
							</thead>
							<tbody id="list">
							</tbody>
						</table>
					</div>
				</div>
				<div class="page_navi  mt10">
				</div>
				<div class="btn_box_con">
					<input type='button' value="보고서 작성" class="btn_admin_red" onclick="javascript:goInsertForm('${paramVO.pageNo}');">
				</div>
			 		<hr class="con_mode"/><!-- 신규 추가 꼭 데려갈것 !-->
				</div>
		</div>
	</section>	
</div>
</form>
