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
		loadTeamList();
		
		$('#keyword').keydown(function() {
			if (event.keyCode === 13) {
				event.preventDefault();
				goSearch();
			};
		});
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
					"viewCount":$("#viewCount").val(),
					"deptCode":$('#deptCode').val(),
					"subCategory":$('#subCategory').val()
			},
			dataType:"json",
			success:function(data) {
				var html = "";
				if( data.totalCount > 0 ) {
					$("#list").html(html);
					data.reportList.forEach(function (item) {
						html += "	<tr>";
						html += "		<td>"+item.category1Name+"</td>";
						html += "		<td>"+item.subCategoryName+"</td>";
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
					html += "<tr><td align='center' colspan='6'>데이터가 없습니다.</td></tr>";
					$("#list").html(html);
					$("#list").html(html);
					$('.page_navi').html(data.navi.prevBlock+data.navi.pageList+data.navi.nextBlock);
					$('#pageNo').val(data.navi.pageNo);
				}
			},
			error:function(request, status, errorThrown){
				var html = "";
				$("#list").html(html);
				html += "<tr><td align='center' colspan='6'>오류가 발생하였습니다.</td></tr>";
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
		/*
			240724 조회 권한 변경 ( T 조회권한  / F 조회권한 없음)
			=> 등록자 / 관리자isAdmin / 연구소장(Grade:20)/ 동일한 팀코드(teamCode)의 파트장(Grade:5)/ 동일한 팀(부서)(dept)과 부서장(Grade:2)
		*/
		
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
		$("#subCategory").val("");
		$("#subCategoryLi").hide();
		goSearch();
	}
	
	function loadTeamList(){
		$.ajax({
		    url:'/code/itemListAjax',
		    data: {
		        groupCode: 'DEPT'
		    },
		    async: true,
		    success: function(data){
		        var element = '';
		        if(data.length > 0){
					for (var i = 0; i < data.length; i++) {
						var rowData = data[i];
						element += "<option value='"+rowData.itemCode+"'>"+rowData.itemName+"</option>"
					}
		        }
		        $('#deptCode').append(element);
		    }
		})
	}
	
	function changeCategory(e){
		var selectCategory = e.target.value;
		
		if(e.target.value.length <= 0){
			$('#subCategoryLi').hide();
		} else {
			var URL = "/report/getSubCategoryAjax";
			$.ajax({
				type:"POST",
				url:URL,
				data:{
						"category1":selectCategory
				},
				dataType:"json",
				success:function(data) {
					var element = '<button type="button" class="subCtg01" onclick="setSubCategory(event, \'\')">전체</button>';
					
					for(i=0; i<data.length; i++){
						var rowData = data[i];
						element += '<button type="button" class="subCtg01" onclick="setSubCategory(event, '+rowData.itemCode+')">'+rowData.itemName+' ('+rowData.subCategoryCnt+'건)</button>' 
						//'<input type="radio" id="subCategory'+i+'" name="subCategory" value="'+rowData.itemCode+'" checked><label for="subCategory'+i+'"><span></span>'+rowData.itemName+'</label>';
					}
					$('#subCategoryLi dd').empty();
					$('#subCategoryLi dd').append(element);
					$('#subCategoryLi').show();
				},
				error:function(request, status, errorThrown){
					alert("중분류 불러오기 오류");
					$('#subCategoryLi').hide();
				}			
			});
		}
		
		$('#subCategory').val('');
		
		loadList();
	}
	
	function setSubCategory(e, subCategory){
		if($('#subCategory').val() == subCategory){
			return;
		}
		
		$('#subCategory').val(subCategory)
		$('#subCategoryLi dd button').attr('class', 'subCtg01');
		e.target.className='subCtg01_chk';
		
		loadList();
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
								<select id="category1" name="category1" onchange="changeCategory(event)">
									<option value="">전체</option>
								</select>
							</div>
							<input type="text" name="keyword" id="keyword" value="${paramVO.keyword}" class="ml5" style="width:150px;"/>
						</dd>
					</li>
					<li>
						<dt>팀</dt>
						<dd >
							<div class="selectbox" style="width:150px;">
								<label for="deptCode" id="deptCode_label">선택</label>
								<select name="deptCode" id="deptCode" onchange="loadList()">
									<option value="">선택</option>											
								</select>
							</div>
						</dd>
					</li>
					<li id="subCategoryLi" style="display:none; width:100%">
						<input type="hidden" id="subCategory" name="subCategory" value=""/>
						<dt>중분류</dt>
						<dd style="padding-top:3px; width:80%">
							<button type="button" class="subCtg01" onclick="setSubCategory()">SubCategory</button>
						</dd>
					</li>
					<!-- 
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
					 -->
				</ul>
				<div class="fr pt5 pb10">
					<button type="button" class="btn_con_search" onClick="goSearch();"><img src="/resources/images/btn_icon_search.png" style="vertical-align:middle;"/> 검색</button>
					<button type="button" class="btn_con_search" onClick="goClear();"><img src="/resources/images/btn_icon_refresh.png" style="vertical-align:middle;"/> 검색 초기화</button>
				</div>
			</div>
			<div class="main_tbl">
				<table class="tbl01">
					<colgroup>
						<col width="15%">
						<col width="15%">
						<col width="5%">
						<col />
						<col width="10%">
						<col width="15%">
					</colgroup>
					<thead>
						<tr>
							<th>대분류</th>
							<th>중분류</th>
							<th>&nbsp;</th>
							<th>보고서명</th>
							<th>보고자</th>
							<th>등록일</th>
						</tr>	
					</thead>
					<tbody id="list">
					</tbody>
				</table>
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
