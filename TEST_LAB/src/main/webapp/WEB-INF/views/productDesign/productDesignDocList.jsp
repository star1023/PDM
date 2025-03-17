<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="kr.co.aspn.util.*" %>
<%@ taglib prefix="userUtil" uri="/WEB-INF/tld/userUtil.tld"%>
<title>제품설계서</title>
<style>
.input[type=text] {
	-webkit-ime-mode:active;
	-moz-ime-mode:active;
	-ms-ime-mode:active;
	ime-mode:active;
}
.positionCenter{
	position: absolute;
	transform: translate(-50%, -45%);
}
</style>
<script type="text/javascript">
	$(document).ready(function(){
		var searchField = '${search.searchField}';
		var searchValue = '${search.searchValue}';
		
		if(searchField.length > 0){
			$('#searchField option[value='+searchField+']').prop('selected', true);
			$('#searchField').change()
		}
		
		loadCompany('companyCode');
		loadCodeList( "PRODCAT1", "productType1" );
		loadCodeList( "STERILIZATION", "sterilization" );
		loadCodeList( "ETCDISPLAY", "etcDisplay" );
		
		var searchField = '${search.searchField}';
		var searchValue = '${search.searchValue}';
		var countPerPage = '${productDevDocList.page.countPerPage}';
		
		$('#searchForm, #productDesignCreateForm').on('submit', function(event){
			event.preventDefault();
		})
		
		if(searchField != '' || searchField != null){
			$('#searchField').children().toArray().forEach(function(element, i){
				if($(element).val() == searchField){
					$(element).attr('selected', true);
					$('#searchField').prev().text($(element).text())
				} else {
					$(element).attr('selected', false);
				}
			})
		}
		
		$('#searchValue').val(searchValue);
	});
	
	function readProductDesign(pNo){
		var form = document.createElement('form');
		$('body').append(form);
		$(form).css('diplay', 'none');
		form.action = '/design/productDesignDocDetail';
		form.style.display = 'none';
		form.target = '_blank';
		form.method = 'post';
		
		appendInput(form, 'pNo', pNo)
		
		$(form).submit();
	}
	
	function initSearch(){
		var form = document.createElement('form');
		$('body').append(form);
		$(form).css('diplay', 'none');
		form.action = '/design/productDesignDocList';
		form.method = 'post';
		
		$(form).submit();
	}
	
	function search(page, ownerType){
		page = page + "";
		
		var searchField = $('#searchField').selectedValues()[0];
		var searchValue = $('#searchValue').val();
		var countPerPage = $('#viewCount').val();
		if( countPerPage == "" ) {
			countPerPage = 10;
		}
		
		var form = document.createElement('form');
		$(form).css('diplay', 'none');
		$('body').append(form);
		$(form).css('diplay', 'none');
		form.action = '/design/productDesignDocList';
		form.method = 'post';
		
		if(searchField.length > 0){
			appendInput(form, 'searchField', searchField)
			appendInput(form, 'searchValue', searchValue)
		}
		
		if(page.length > 0 || page > 0) appendInput(form, 'showPage', page)
		if(ownerType.length > 0) {
			appendInput(form, 'ownerType', ownerType)
		} else {
			appendInput(form, 'ownerType', '${search.ownerType}')
		}
		
		appendInput(form, 'countPerPage', countPerPage)
		
		$(form).submit();
	}
	
	function changeOwnerType(ownerType){
		search('', ownerType);
	}
	
	function changePage(page){
		search(page, '');
	}
	
	function changeCompayCode(event){
		$('#companyCode').change(function(e){
			if(e.target.value){
				var plantList = '${plantList}';
				$('#plant').empty();
				$('#plant').append('<option value="">선택하세요</option>');
				JSON.parse(plantList).forEach(function(v){
					if(v.companyCode == event.target.value){
						$('#plant').append('<option value="'+v.plant+'">'+v.plantName+'</option>')
					}
				});
				$('#plant').change();
			} else {
				$('#plant').empty();
				$('#plant').append('<option value="">선택하세요</option>');
				$('#plant').change();
			}
		})
	}
	
	function saveProductDesignDoc(){
		if(saveValid()){
			var formData = $('#productDesignCreateForm').serialize();
			$.ajax({
				url: '/design/saveProductDesignDoc',
				type: 'POST',
				data: formData,
				success: function(data){
					if(data > 0){
						alert('저장되었습니다.');
					} else {
						return alert('[ERR-1]제품설계서 저장 오류');
					}
				},
				error: function(){
					return alert('[ERR-2]제품설계서 저장 오류');
				},
				complete: function(){
					reloadPage();
				}
			});
		} else {
			return;
		}
	}
	
	function saveValid(){
		if($('#productName').val().trim().length <= 0){
			alert('제품명을 선택하세요');
			return false;
		}
		
		if($('#productType1').val() == '' || $('#productType1').val() == null){
			alert('제품유형을 선택하세요');
			return false;
		}
		
		if($('#companyCode').val().trim().length <= 0){
			alert('공장을 선택하세요');
			return false;
		}
		
		if($('#plant').val().trim().length <= 0){
			alert('공장을 선택하세요');
			return false;
		}
		
		return true;
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
				$("#"+objectId).addOption("", "전체", false);
				$("#label_"+objectId).html("전체");
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
				$('#'+selectBoxId).parent().show();
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
	
	function onkeyupSearchValue(e){
		if(e.keyCode == 13){
			search('', '');
		}
	}
	
	function reloadPage(){
		
		var searchField = search.searchField;
		var searchValue = search.searchValue;
		var showPage = '${productDesignList.page.showPage}';
		var ownerType = '${search.ownerType}';
		
		var form = document.createElement('form');
		$('body').append(form);
		$(form).css('diplay', 'none');
		form.action = '/design/productDesignDocList';
		form.method = 'post';
		$(form).submit();
	}
</script>

<div class="wrap_in" id="fixNextTag">
	<span class="path">제품설계서&nbsp;&nbsp;<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;<a >SPC 삼립연구소</a></span>
	<section class="type01">
		<h2 style="position:relative">
			<span class="title_s">Product Design Doc</span>
			<span class="title">제품설계서</span>
			<div class="top_btn_box">
				<ul><li><button class="btn_circle_red" onclick="openDialog('dialog_create')">&nbsp;</button></li></ul>
			</div>
		</h2>
		
		<div class="group01">
			<div class="title"></div>
			<div class="tab02">
				<ul>
					<c:choose>
						<c:when test='${userUtil:getIsAdmin(pageContext.request) == "Y"}'>
							<c:if test="${search.ownerType == 'all'}">
								<a href="javascript:changeOwnerType('all')"><li class="select">전체</li></a>
								<c:if test="${userUtil:getTeamCode(pageContext.request) == ''}">
									<a href="javascript:changeOwnerType('team')"><li class=""><%=UserUtil.getDeptCodeName(request)%></li></a>										
								</c:if>
								<c:if test="${userUtil:getTeamCode(pageContext.request) != ''}">
									<a href="javascript:changeOwnerType('team')"><li class=""><%=UserUtil.getDeptCodeName(request)%>(<%=UserUtil.getTeamCodeName(request)%>)</li></a>										
								</c:if>
								<a href="javascript:changeOwnerType('user')"><li class="change">'<%=UserUtil.getUserName(request)%>'님의 제품설계서</li></a>
							</c:if>
							<c:if test="${search.ownerType == 'team'}">
								<a href="javascript:changeOwnerType('all')"><li class="">전체</li></a>
								<c:if test="${userUtil:getTeamCode(pageContext.request) == ''}">
									<a href="javascript:changeOwnerType('team')"><li class="select"><%=UserUtil.getDeptCodeName(request)%></li></a>										
								</c:if>
								<c:if test="${userUtil:getTeamCode(pageContext.request) != ''}">
									<a href="javascript:changeOwnerType('team')"><li class="select"><%=UserUtil.getDeptCodeName(request)%>(<%=UserUtil.getTeamCodeName(request)%>)</li></a>										
								</c:if>
								<a href="javascript:changeOwnerType('user')"><li class="change">'${SESS_AUTH.userName}'님의 제품설계서</li></a>
							</c:if>
							<c:if test="${search.ownerType == 'user'}">
								<a href="javascript:changeOwnerType('all')"><li class="">전체</li></a>
								<c:if test="${userUtil:getTeamCode(pageContext.request) == ''}">
									<a href="javascript:changeOwnerType('team')"><li class=""><%=UserUtil.getDeptCodeName(request)%></li></a>										
								</c:if>
								<c:if test="${userUtil:getTeamCode(pageContext.request) != ''}">
									<a href="javascript:changeOwnerType('team')"><li class=""><%=UserUtil.getDeptCodeName(request)%>(<%=UserUtil.getTeamCodeName(request)%>)</li></a>										
								</c:if>
								<a href="javascript:changeOwnerType('user')"><li class="change select">'${SESS_AUTH.userName}'님의 제품설계서</li></a>
							</c:if>
						</c:when>
						<c:when test='${userUtil:getIsAdmin(pageContext.request) != "Y"}'>
							<c:choose>
								<c:when test='${userUtil:getUserGrade(pageContext.request) == "3" || userUtil:getUserId(pageContext.request) == "cha"}'>
									<c:if test="${search.ownerType == 'all'}">
										<a href="javascript:changeOwnerType('all')"><li class="select">전체</li></a>
										<c:if test="${userUtil:getTeamCode(pageContext.request) == ''}">
											<a href="javascript:changeOwnerType('team')"><li class=""><%=UserUtil.getDeptCodeName(request)%></li></a>										
										</c:if>
										<c:if test="${userUtil:getTeamCode(pageContext.request) != ''}">
											<a href="javascript:changeOwnerType('team')"><li class=""><%=UserUtil.getDeptCodeName(request)%>(<%=UserUtil.getTeamCodeName(request)%>)</li></a>										
										</c:if>
										<a href="javascript:changeOwnerType('user')"><li class="change">'<%=UserUtil.getUserName(request)%>'님의 제품설계서</li></a>
									</c:if>
									<c:if test="${search.ownerType == 'team'}">
										<a href="javascript:changeOwnerType('all')"><li class="">전체</li></a>
										<c:if test="${userUtil:getTeamCode(pageContext.request) == ''}">
											<a href="javascript:changeOwnerType('team')"><li class="select"><%=UserUtil.getDeptCodeName(request)%></li></a>										
										</c:if>
										<c:if test="${userUtil:getTeamCode(pageContext.request) != ''}">
											<a href="javascript:changeOwnerType('team')"><li class="select"><%=UserUtil.getDeptCodeName(request)%>(<%=UserUtil.getTeamCodeName(request)%>)</li></a>										
										</c:if>
										<a href="javascript:changeOwnerType('user')"><li class="change">'${SESS_AUTH.userName}'님의 제품설계서</li></a>
									</c:if>
									<c:if test="${search.ownerType == 'user'}">
										<a href="javascript:changeOwnerType('all')"><li class="">전체</li></a>
										<c:if test="${userUtil:getTeamCode(pageContext.request) == ''}">
											<a href="javascript:changeOwnerType('team')"><li class=""><%=UserUtil.getDeptCodeName(request)%></li></a>										
										</c:if>
										<c:if test="${userUtil:getTeamCode(pageContext.request) != ''}">
											<a href="javascript:changeOwnerType('team')"><li class=""><%=UserUtil.getDeptCodeName(request)%>(<%=UserUtil.getTeamCodeName(request)%>)</li></a>										
										</c:if>
										<a href="javascript:changeOwnerType('user')"><li class="change select">'${SESS_AUTH.userName}'님의 제품설계서</li></a>
									</c:if>
								</c:when>
								<c:when test='${userUtil:getUserGrade(pageContext.request) == "2" && (userUtil:getDeptCode(pageContext.request) == "dept1" || userUtil:getDeptCode(pageContext.request) == "dept2" || userUtil:getDeptCode(pageContext.request) == "dept3" || userUtil:getDeptCode(pageContext.request) == "dept4" || userUtil:getDeptCode(pageContext.request) == "dept5" ||userUtil:getDeptCode(pageContext.request) == "dept6" || userUtil:getDeptCode(pageContext.request) == "dept11" || userUtil:getDeptCode(pageContext.request) == "dept12" || userUtil:getDeptCode(pageContext.request) == "dept13")}'> 
									<c:if test="${search.ownerType == 'team'}">
										<c:if test="${userUtil:getTeamCode(pageContext.request) == ''}">
											<a href="javascript:changeOwnerType('team')"><li class="select"><%=UserUtil.getDeptCodeName(request)%></li></a>										
										</c:if>
										<c:if test="${userUtil:getTeamCode(pageContext.request) != ''}">
											<a href="javascript:changeOwnerType('team')"><li class="select"><%=UserUtil.getDeptCodeName(request)%>(<%=UserUtil.getTeamCodeName(request)%>)</li></a>										
										</c:if>
										<a href="javascript:changeOwnerType('user')"><li class="change">'${SESS_AUTH.userName}'님의 제품개발문서</li></a>
									</c:if>
									<c:if test="${search.ownerType == 'user'}">
										<c:if test="${userUtil:getTeamCode(pageContext.request) == ''}">
											<a href="javascript:changeOwnerType('team')"><li class=""><%=UserUtil.getDeptCodeName(request)%></li></a>										
										</c:if>
										<c:if test="${userUtil:getTeamCode(pageContext.request) != ''}">
											<a href="javascript:changeOwnerType('team')"><li class=""><%=UserUtil.getDeptCodeName(request)%>(<%=UserUtil.getTeamCodeName(request)%>)</li></a>										
										</c:if>
										<a href="javascript:changeOwnerType('user')"><li class="change select">'${SESS_AUTH.userName}'님의 제품개발문서</li></a>
									</c:if>
								</c:when>
								<c:when test='${userUtil:getUserGrade(pageContext.request) != "2" && (userUtil:getDeptCode(pageContext.request) == "dept1" || userUtil:getDeptCode(pageContext.request) == "dept2" || userUtil:getDeptCode(pageContext.request) == "dept3" || userUtil:getDeptCode(pageContext.request) == "dept4" || userUtil:getDeptCode(pageContext.request) == "dept5" ||userUtil:getDeptCode(pageContext.request) == "dept6" || userUtil:getDeptCode(pageContext.request) == "dept11" || userUtil:getDeptCode(pageContext.request) == "dept12" || userUtil:getDeptCode(pageContext.request) == "dept13")}'>
									<a href="javascript:changeOwnerType('user')"><li class="change select">'${SESS_AUTH.userName}'님의 제품개발문서</li></a>
								</c:when>
								<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept7" || userUtil:getDeptCode(pageContext.request) == "dept8" || userUtil:getDeptCode(pageContext.request) == "dept9"}'>
									<c:if test="${search.ownerType == 'all'}">
										<a href="javascript:changeOwnerType('all')"><li class="select">전체</li></a>
										<a href="javascript:changeOwnerType('user')"><li class="change">'<%=UserUtil.getUserName(request)%>'님의 제품설계서</li></a>
									</c:if>
									<c:if test="${search.ownerType == 'user'}">
										<a href="javascript:changeOwnerType('all')"><li class="">전체</li></a>
										<a href="javascript:changeOwnerType('user')"><li class="change select">'${SESS_AUTH.userName}'님의 제품설계서</li></a>
									</c:if>
								</c:when>
								<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept10"}'>
									<c:if test="${search.ownerType == 'all'}">
										<a href="javascript:changeOwnerType('all')"><li class="select">전체</li></a>										
									</c:if>
								</c:when>								
							</c:choose>
						</c:when>
					</c:choose>			
				</ul>
			</div>
			
			<div class="search_box">
				<form id="searchForm">
					<input type="hidden" name="ownerType" value="${search.ownerType}">
					<ul style="border-top: none;">
						<li>
							<dt>키워드</dt>
							<dd>
								<div class="selectbox" style="width: 100px;">
									<label for="searchField">선택</label>
									<select name="searchField" id="searchField">
										<option value="" selected="selected">선택</option>
										<option value="pNo">문서번호</option>
										<option value="productName">제품명</option>
										<option value="userName">작성자</option>
										<!-- <option value="categoryName">제품유형</option> -->
										<!-- <option value="plant">공장</option> -->
									</select>
								</div>
								<input id="searchValue" name="searchValue" type="text" style="width: 165px; margin-left: 5px;" onkeyup="onkeyupSearchValue(event)"/>
							</dd>
						</li>
						<li>
						<dt>표시수</dt>
						<dd >
							<div class="selectbox" style="width:100px;">  
								<label for="viewCount" id="viewCount_label">${productDesignList.page.countPerPage}</label> 
								<select name="viewCount" id="viewCount">		
									<option value="10" ${productDesignList.page.countPerPage == 10 ? 'selected' : ''}>10</option>
									<option value="20" ${productDesignList.page.countPerPage == 20 ? 'selected' : ''}>20</option>
									<option value="50" ${productDesignList.page.countPerPage == 50 ? 'selected' : ''}>50</option>
									<option value="100" ${productDesignList.page.countPerPage == 100 ? 'selected' : ''}>100</option>
								</select>
							</div>
						</dd>
					</li>
					</ul>
				</form>
				<div class="fr pt5 pb10">
					<button class="btn_con_search" onclick="search('', '')"><img src="/resources/images/btn_icon_search.png"style="vertical-align: middle;" /> 검색 </button>
					<button class="btn_con_search" onclick="initSearch()"><img src="/resources/images/btn_icon_refresh.png"style="vertical-align: middle;" /> 검색 초기화 </button>
				</div>
			</div>
			<div class="main_tbl">
				<table class="tbl01">
					<colgroup>
						<col width="7%">
						<col/>
						<col width="10%">
						<col width="30%">
						<col width="15%">
						<col width="15%">
					</colgroup>
					<thead>
						<tr>
							<th>번호</th>
							<th>제품명</th>
							<th>작성자</th>
							<th>제품유형</th>
							<th>공장</th>
							<th>업데이트일</th>
						</tr>
					</thead>
					<c:if test="${productDesignList.pagenatedList == null }">
						<tr>
							<td colspan="8" align="center">자재 조회 결과가 없습니다.</td>
						</tr>
					</c:if>
					<c:if test="${productDesignList.pagenatedList != null }">
					<tbody>
						<c:forEach items="${productDesignList.pagenatedList}" var="productDesignList">
						<tr>
							<td>${productDesignList.pNo}</td>
							<td><div class="ellipsis_txt tgnl"><a href="#none" onclick="readProductDesign(${productDesignList.pNo})">${productDesignList.ProductName}</a></div></td>
							<td>${productDesignList.userName}</td>
							<td>
								<c:if test="${fn:length(productDesignList.productType1Text) > 0}">[${productDesignList.productType1Text}]</c:if>
								<c:if test="${fn:length(productDesignList.productType2Text) > 0}">[${productDesignList.productType2Text}]</c:if>
								<c:if test="${fn:length(productDesignList.productType3Text) > 0}">[${productDesignList.productType3Text}]</c:if>
							</td>
							<td>${productDesignList.plantName}</td>
							<td>${productDesignList.modDate != null ? productDesignList.modDate : productDesignList.regDate}</td>
							<%-- <td>&nbsp;
								<input type="checkbox" name="hiddenChk" id="hiddenChk${item.mtNo}" onclick="goHidden('${item.mtNo}', '${item.sapCode}', this);" <c:if test="${item.isHidden == 'Y'}">checked</c:if>/><label for="hiddenChk${item.mtNo}"><span></span></label>
							</td> --%>
						</tr>
						</c:forEach>
					</tbody>
					</c:if>
				</table>
				<div class="page_navi mt10">
					<ul>
						<c:if test="${productDesignList.page.totalCount != 0}">
							<c:if test="${productDesignList.page.hasPrev() == true}">
								<li style="border-right: none;">
									<a href="#none" class="btn btn_prev1" onclick="changePage(${productDesignList.page.pageList[0]-1})">Prev</a>
								</li>	
							</c:if>
							<c:forEach items="${productDesignList.page.getPageList()}" var="page">
								<c:if test="${page == productDesignList.page.showPage}">
									<li class="select" style="border-right: none;">
										<a href="#none" class="btn btn_prev1" onclick="changePage(${page})">${page}</a>
									</li>
								</c:if>
								<c:if test="${page != productDesignList.page.showPage}">
									<li style="border-right: none;">
										<a href="#none" class="btn btn_prev1" onclick="changePage(${page})">${page}</a>
									</li>
								</c:if>
							</c:forEach>
							<c:if test="${productDesignList.page.hasNext() == true}">
								<li style="border-right: none;">
									<a href="#none" class="btn btn_next3" onclick="changePage(${productDesignList.page.pageList[4]+1})">Next</a>
								</li>	
							</c:if>
						</c:if>
					</ul>
				</div>
				<div class="btn_box_con">
					<button class="btn_admin_red" onclick="openDialog('dialog_create')">제품설계서 생성</button>
				</div>
				<hr class="con_mode"/>
			</div>
		</div>
	</section>
</div>
	
<!-- 제품설계서 생성레이어 open-->
<!-- 클래스 옆에 적힌 스타일 값을 인라인으로 작성해서 팝업 사이즈를 직접 조정 -->
<div class="white_content" id="dialog_create">
	<div class="modal positionCenter" style="width:710px;height: 400px">
    <!-- <div class="modal" style="	margin-left:-355px;width:710px;height: 400px;margin-top:-200px"> -->
        <h5 style="position:relative">
            <span class="title">제품설계서 생성</span>
            <div class="top_btn_box">
                <ul>
                    <li>
                        <button class="btn_madal_close" onClick="closeDialog('dialog_create')"></button>
                    </li>
                </ul>
            </div>
        </h5>
        <div class="list_detail">
        	<form id="productDesignCreateForm">
				<input type="hidden" name="regUserId" value="${SESS_AUTH.userId}"/>
	            <ul>
	                <li>
	                    <dt>제품명</dt>
	                    <dd>
	                        <input type="text" class="req" style="width:390px;" placeholder="입력필수" name="productName" id="productName" onkeyup=""/>
	                    </dd>
	                </li>
	                <li>
						<dt>제품유형</dt>
						<dd>
							<div class="selectbox req" style="width:130px;">  
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
	                    <dt>공장</dt>
	                    <dd>
	                    	<div class="selectbox req" style="width:130px;">  
								<label id="label_companyCode" for="companyCode">선택</label>
								<select id="companyCode" name="companyCode" onChange="companyChange('companyCode','plant')">
	                            </select>
							</div>
							<div class="selectbox req ml5" style="width:130px; display:none;"> 
								<label id="label_plant" for="plant">선택</label>
	                            <select id="plant" name="plant">
	                            </select>
							</div>
	                    </dd>
	                </li>
					<li>
						<dt>기타</dt>
						<dd>
							<div class="selectbox" style="width:130px;">  
								<label for="sterilization" id="label_sterilization">선택</label> 
								<select id="sterilization" name="sterilization">
								</select>
							</div>
							<div class="selectbox ml5" style="width:250px;">  
								<label for="etcDisplay" id="label_etcDisplay">선택</label> 
								<select id="etcDisplay" name="etcDisplay">
								</select>
							</div>
						</dd>
					</li>
	            </ul>
            </form>
        </div>
        <div class="btn_box_con">
            <button class="btn_admin_red" onclick="saveProductDesignDoc()">제품설계서 생성</button>
            <button class="btn_admin_gray" onClick="closeDialog('dialog_create')">생성 취소</button>
        </div>
    </div>
</div>
<!-- 제품설계서 생성레이어 close-->


