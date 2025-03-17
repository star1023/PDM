<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page session="false"%>

<script type="text/javascript">
	$(document).ready(function() {
		//datepicker를 이용한 달력(기간) 설정
		$("#startDate").datepicker({
			showOn : 'button',
			buttonImage : '<c:url value="../resources/images/btn_calendar.png"/>',
			buttonImageOnly : true,
			dateFormat : 'yy-mm-dd',
			constrainInput : false
		});

		$("#endDate").datepicker({
			showOn : 'button',
			buttonImage : '<c:url value="../resources/images/btn_calendar.png"/>',
			buttonImageOnly : true,
			dateFormat : 'yy-mm-dd',
			constrainInput : false
		});
		
		$("#ui-datepicker-div").css('font-size', '0.8em');
		$('.ui-datepicker-trigger').css('margin-left', '8px');
		$('.ui-datepicker-trigger').css('margin-top', '-5px');
		$('.ui-datepicker-trigger').css('cursor', 'pointer');

	});
	//공지사항 작성페이지
	function registNotice() {
		var form = document.createElement('form');
		form.style.display = 'none';
		$('body').append(form);
		form.action = '/board/registForm';
		form.method = 'post';
		
		appendInput(form, 'type', '${type}');
		
		form.submit();
	}

	//게시물 상세정보 가져오기
	function getDetail(nNo) {
		var form = document.createElement('form');
		form.style.display = 'none';
		$('body').append(form);
		form.action = '/board/postDetail';
		form.method = 'post';
		
		appendInput(form, 'type', '${type}');
		appendInput(form, 'nNo', nNo);
		
		form.submit();
	}

	function paging(page) {
		searchBoardList(page);
		return;
	}
	
	function searchBoardList(pageNo){
		pageNo = pageNo == null ? 1 : pageNo;
		
		$.ajax({
		    url: '/board/boardListAjax',
		    data: {
		    	type: 'lab'
		    	, pageNo: pageNo
		    	, searchField: $('#searchField').val()
		    	, searchValue: $('#searchValue').val()
		    	, startDate: $('#startDate').val()
		    	, endDate: $('#endDate').val()
		    },
		    success: function(data){
		    	var date = new Date();
		    	var year = date.getFullYear();
		    	var month = date.getMonth()+1;
		    	if(month < 10)
		    		month = "0" + month;
		    	else
		    		month = ""+month;
		    	var day = date.getDate();
		    	var today = year + "-" + month + "-"+day;
		    	date = new Date(today);
		    	var unixTimeToday = date.getTime();
		    	
		    	console.log(data)
		    	
		    	if( data.totalCount > 0 ) {
		    		var html= "";
		    		data.boardList.forEach(function(item) {
		    			var element = "";
		    			element += '<Tr>'
		    			element += '	<Td>'+item.nNo+'</Td>'
		    			element += '	<Td>'
		    			if(item.fileCount > 0){
			    			element += '	<img src="../resources/images/icon_file01.png">'
		    			}
		    			element += '	</Td>'
		    			element += '	<Td>'
		    			element += '		<div class="ellipsis_txt tgnl">'
		    			element += '			<a href="#" onclick="getDetail('+item.nNo+')">'+item.title+'</a>'
		    			if(item.regDate > unixTimeToday){
			    			element += '		<span class="icon_new">N</span>'
		    			}
		    			element += '		</div>'
		    			element += '	</Td>'
		    			element += '	<Td>'+item.regUserName+'</Td>'
		    			element += '	<Td>'+item.regDateText+'</Td>'
		    			element += '	<Td>'+item.hits+'</Td>'
		    			element += '</Tr>';
		    			html += element;
		    		});
		    		$('#listBody').empty();
		    		$('#listBody').append(html);
		    		$('.page_navi').html(data.navi.prevBlock+data.navi.pageList+data.navi.nextBlock);
		    	} else {
		    		$('#listBody').empty();
		    		$('#listBody').append('<tr><td colspan="6">검색조건과 일치하는 게시물이 존재하지 않습니다.</td></tr>');
		    		$('.page_navi').html(data.navi.prevBlock+data.navi.pageList+data.navi.nextBlock);
		    	}
		    },
		    error: function(a,b,c){
		        alert("리스트 갱신 오류 - 관리자에게 문의하세요")
		    }
		})
	}

	function searchInitialize() {
		$('#searchField option[value=both]').prop('selected', true);
		$('#searchField').change();
		$("#searchValue").val('');
		
		$('#startDate').val('');
		$('#endDate').val('');
	}
</script>

<form name="listForm" id="listForm" method="get" action="/teamNotice/TeamnoticeList">
	<div class="wrap_in" id="fixNextTag">
		<span class="path">${typeText} 게시판<img src="../resources/images/icon_path.png" style="vertical-align: middle" />&nbsp;&nbsp;게시판&nbsp;&nbsp;<img src="../resources/images/icon_path.png" style="vertical-align: middle" />&nbsp;&nbsp;<a href="#">${strUtil:getSystemName()}</a></span>
		<section class="type01">
			<!-- 상세 페이지  start-->
			<h2 style="position: relative">
				<span class="title_s">${type} Borard</span> <span class="title">${typeText} 게시판</span>
				<div class="top_btn_box">
					<ul>
						<li><button class="btn_circle_red" onclick="registNotice(); return false;">&nbsp;</button></li>
					</ul>
				</div>
			</h2>
			<div class="group01">
				<div class="title"><!--span class="txt">연구개발시스템 공지사항</span--></div>
				<div class="search_box">
					<ul>
						<li>
							<dt>키워드</dt>
							<dd>
								<div class="selectbox" style="width: 130px;">
									<label for="searchField">작성자+제목</label>
									<select id="searchField">
										<option value="both" selected>작성자+제목</option>
										<option value="regUserId">작성자</option>
										<option value="title">제목</option>
									</select>
								</div>
								<input type="text" class="ml5" style="width: 180px;" id="searchValue" name="searchValue" value=""/>
							</dd>
						</li>
						<li>
							<dt>기간</dt>
							<dd>
								<input type="text" class="ml5" style="width: 110px;" id="startDate" name="startDate" value="" /> ~ <input type="text" class="ml5" style="width: 110px;" id="endDate" name="endDate" value="" />
							</dd>
						</li>
					</ul>
					<div class="fr pt5 pb10">
						<button class="btn_con_search" onclick="searchBoardList(); return false;">
							<img src="../resources/images/btn_icon_search.png" style="vertical-align: middle;" /> 검색
						</button>
						<button class="btn_con_search" onclick="searchInitialize(); return false;">
							<img src="../resources/images/btn_icon_refresh.png" style="vertical-align: middle;" /> 검색 초기화
						</button>
					</div>
				</div>
				<div class="main_tbl">
					<table class="tbl01">
						<colgroup>
							<col width="10%">
							<col width="3%">
							<col />
							<col width="10%">
							<col width="20%">
							<col width="7%">
						</colgroup>
						<thead>
							<tr>
								<th>번호</th>
								<th>&nbsp;</th>
								<th>제목</th>
								<th>작성자</th>
								<th>작성일</th>
								<th>조회수</th>
						</thead>
						<tbody id="listBody">
							<c:set var="now" value="<%=new java.util.Date()%>" />
							<fmt:formatDate var="nowDate" value="${now}" pattern="yyyy.MM.dd" />
							<c:if test="${fn:length(boardList) > 0 }">
								<c:forEach items="${boardList}" var="item" varStatus="status">
									<Tr>
										<Td>${item.nNo}</Td>
										<Td>
											<c:if test="${item.fileCount != 0 }"><img src="../resources/images/icon_file01.png"></c:if>
										</Td>
										<fmt:formatDate var="parseRegDate" pattern="yyyy.MM.dd" value="${item.regDate}" />
										<Td><div class="ellipsis_txt tgnl">
												<a href="#" onclick="getDetail('${item.nNo}')">${item.title} </a>
												<c:if test="${nowDate <= parseRegDate}">
													<span class="icon_new">N</span>
												</c:if>
											</div></Td>
										<Td>${item.regUserName}</Td>
										<Td>${item.regDateText}</Td>
										<Td>${item.hits}</Td>
									</Tr>
								</c:forEach>
							</c:if>
							<c:if test="${fn:length(boardList) == 0}">
								<Tr>
									<Td colspan="6">' 작성된 게시물이 없습니다. '</Td>
								</Tr>
							</c:if>
						</tbody>
					</table>
					<c:if test="${totalCount > 0}">
						<div class="page_navi  mt10">${navi.prevBlock} ${navi.pageList} ${navi.nextBlock}</div>
					</c:if>
				</div>
				<div class="btn_box_con">
					<!-- <button class="btn_admin_red" onclick="registNotice(); return false;">문의하기</button> -->
					<!-- <button class="btn_admin_red" onclick="fileDown(); return false;">선택 파일 다운로드</button> -->
					<button class="btn_admin_red" onclick="registNotice(); return false;">작성하기</button>
				</div>
				<hr class="con_mode" />
				<!-- 신규 추가 꼭 데려갈것 !-->
			</div>
		</section>
	</div>
</form>