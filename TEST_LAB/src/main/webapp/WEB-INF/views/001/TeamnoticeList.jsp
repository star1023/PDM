<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page session="false" %>
	<title>공지사항</title>
	<script type="text/javascript">
	$(document).ready(function() {
		//datepicker를 이용한 달력(기간) 설정
		$("#startDate").datepicker({
			showOn: 'button',
			buttonImage: '<c:url value="../resources/images/btn_calendar.png"/>',
			buttonImageOnly: true,
			dateFormat: 'yy-mm-dd',
			constrainInput: false
		});
		
		$("#endDate").datepicker({
			showOn: 'button',
			buttonImage: '<c:url value="../resources/images/btn_calendar.png"/>',
			buttonImageOnly: true,
			dateFormat: 'yy-mm-dd',
			constrainInput: false
		});
		$("#ui-datepicker-div").css('font-size','0.8em');
		$('.ui-datepicker-trigger').css('margin-left', '8px');
		$('.ui-datepicker-trigger').css('margin-top', '-5px');
		$('.ui-datepicker-trigger').css('cursor', 'pointer');
		

	});
	//공지사항 작성페이지
	function registNotice(){
		location.href = "/teamNotice/registForm?&pageNo="+'${pageNo}'+"&keyword="+encodeURI(encodeURIComponent('${paramVO.keyword}'))+'&searchName='+encodeURI(encodeURIComponent('${paramVO.searchName}'))+'&startDate='+'${paramVO.startDate}'+"&endDate="+'${paramVO.endDate}';
	}
	
	//게시물 상세정보 가져오기
	function getDetail(no){
		
		location.href="/teamNotice/getTeamNoticeDetail?nNo="+no+"&pageNo="+'${pageNo}'+"&keyword="+encodeURI(encodeURIComponent('${paramVO.keyword}'))+'&searchName='+encodeURI(encodeURIComponent('${paramVO.searchName}'))+'&startDate='+'${paramVO.startDate}'+"&endDate="+'${paramVO.endDate}'+"&tbType=team";
	}
	
	function goSearch(){
		
		var keyword = encodeURI(encodeURIComponent($("#searchValue").val()));
		
		var searchName = encodeURI(encodeURIComponent($("#searchName").val()));
		
		var startDate =  $("#startDate").val();
		
		var endDate =  $("#endDate").val();
		
		location.href="/teamNotice/TeamnoticeList?keyword="+keyword+"&searchName="+searchName+"&startDate="+startDate+"&endDate="+endDate;
	}
	
	// S210204-00003 표시사항배합비 오류 동시처리
	function paging(pageNo){
		changePage(pageNo)
	}
	
	function changePage(page){
		location.href = '/teamNotice/TeamnoticeList?pageNo=' + page + '&keyword='+encodeURI(encodeURIComponent('${paramVO.keyword}'))+'&searchName='+encodeURI(encodeURIComponent('${paramVO.searchName}'))+'&startDate='+'${paramVO.startDate}'+'&endDate='+'${paramVO.endDate}';
	}
	
	function searchInitialize(){
		
		$("#searchValue").val('');
		
		$("#startDate").val('');
		
		$("#endDate").val('');	
		
		location.href = "/teamNotice/TeamnoticeList";
	}
	
	function fileDown(){
		
		var length =  $("input[name=fileCheckBox]").length;
		
		var fmNo = '';
		
		var count = 0;
		
		if(length > 0){
			for(var i=0; i<length; i++){
				if($("input[name=fileCheckBox]").eq(i).prop("checked")){
					
					var nNo = $("input[name=fileCheckBox]").eq(i).val();
					
					$.ajax({
						type:"POST",
						url:"/teamNotice/TeamNoticefmNo",
						data:{
							"nNo" : nNo
						},
						dataType:"json",
						async:false,
						success:function(data){
							
							if(data.fmNoList != '' && data.fmNoList !=null){
								for(var i=0; i<data.fmNoList.length; i++){
									if(fmNo == '' || fmNo == undefined){
										fmNo = data.fmNoList[i].fmNo;
									}else{
										fmNo = fmNo +","+data.fmNoList[i].fmNo;
									}
								}
								location.href = "/file/multiFileDownload?fmNo="+String(fmNo).split(",");
							}else{
								return alert('다운 가능한 파일이 없습니다.');
							}
							
						},
						error:function(request,status,errorThrown){
							alert("오류 발생");
						}
						
					});
				
				}else {
					count = count+1;
				}
			}
		}else{
			alert("선택가능한 파일 목록이 없습니다.");
		}
		
		if(count > 0 ){
			alert("선택한 파일 목록이 없습니다.");
		}
		
	}
</script>

<form name="listForm" id="listForm" method="get" action="/teamNotice/TeamnoticeList">
<%-- <jsp:useBean id="toDay" class="java.util.Date" />
	<span class="path">
		공지사항&nbsp;&nbsp;<img src="../resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;
		<a href="#">파리크라상 식품기술 연구개발시스템</a>
	</span>
	<section class="type01">
		<h2 style="position:relative">
			<span class="title_s">Notice</span>
			<span class="title">공지사항</span>
			<div class="top_btn_box">
				<ul>
					<li>
						<button type="button" onclick="registNotice(); return false;"  class="btn_circle_red">&nbsp;</button>
					</li>
				</ul>
			</div>
		</h2>
		<br>
		<div class="group01" >
			<div class="search_box" style="margin-bottom:10px">
				<ul >
					<li>
						<dt>키워드</dt>
						<dd >
							<input type="text"  id="searchValue" name="searchValue" class="ml5" style="width:180px;" value="${keyword}"/>
							<input type="button" class="btn_con_search" >
								<img  onclick="goSearch();" src="../resources/images/btn_icon_search.png" style="vertical-align:middle;"/> 검색
							</input> 
						</dd>
					</li>
				</ul>
			</div>
			<div class="main_tbl" >
				<table class="tbl01" >
					<colgroup>
						<col width="10%">
						<col width="50%">
						<col width="20%">
						<col width="20%">
					</colgroup>
					<thead>
					<tr>
						<th>번호</th>
						<th>제목</th>
						<th>작성자</th>
						<th>작성일</th>
					</tr>
					</thead>
					<tbody>
					<c:if test="${fn:length(TeamnoticeList) == 0 }">
						<tr>
							<td colspan="4">조회 결과가 없습니다.</td>
						</tr>	
					</c:if>
					<c:if test="${fn:length(TeamnoticeList) > 0 }">
						<c:forEach items="${TeamnoticeList}" var="item" varStatus="status">
							<tr style="cursor: pointer" onclick="getDetail('${item.nNo}')">
								<td>${item.nNo}</td>
								<td style="text-align:left">${item.title}
								</td>
								<td>${item.userName}</td>
								<td>${fn:substring(item.regDate,0,19)}</td>
							</tr>
						</c:forEach>		
					</c:if>
					</tbody>
				</table>
			</div>
		<div class="page_navi mt10">
				<ul>
					<c:if test="${TeamnoticeList.page.hasPrev() == true}">
						<li style="border-right: none;">
							<a href="#none" class="btn btn_prev1" onclick="">Prev</a>
						</li>	
					</c:if>
					<c:forEach items="${TeamnoticeList.page.getPageList()}" var="page">
						<c:if test="${page == TeamnoticeList.page.showPage}">
							<li class="select" style="border-right: none;">
								<a href="#none" class="btn btn_prev1" onclick="changePage(${page})">${page}</a>
							</li>
						</c:if>
						<c:if test="${page != TeamnoticeList.page.showPage}">
							<li style="border-right: none;">
								<a href="#none" class="btn btn_prev1" onclick="changePage(${page})">${page}</a>
							</li>
						</c:if>
					</c:forEach>
					<c:if test="${TeamnoticeList.page.hasNext() == true}">
						<li style="border-right: none;">
							<a href="#none" class="btn btn_next3" onclick="">Next</a>
						</li>	
					</c:if>
				</ul>
			</div>
			<c:if test="${totalCount > 0}">
				<div class="page_navi mt10">
					${navi.prevBlock}
					${navi.pageList}
					${navi.nextBlock}
				</div>
			</c:if>
		</div>
	</section> --%>
		<div class="wrap_in" id="fixNextTag">
				<span class="path">${deptName}&nbsp;공지사항<img src="../resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;게시판&nbsp;&nbsp;<img src="../resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;<a href="#">${strUtil:getSystemName()}</a></span>
				<section class="type01">
				<!-- 상세 페이지  start-->
					<h2 style="position:relative"><span class="title_s">Team</span>
						<span class="title">${deptName}팀 게시판</span>
						<div  class="top_btn_box">
							<ul><li><button class="btn_circle_red"  onclick="registNotice(); return false;">&nbsp;</button></li></ul>
						</div>
					</h2>
						<div class="group01" >
	<div class="title"><!--span class="txt">연구개발시스템 공지사항</span--></div>
	<div class="search_box" >
				<ul>
					<li>
						<dt>키워드</dt>
						<dd>
						
						<div class="selectbox" style="width:130px;">  
								<label for="searchName">
									<c:if test="${paramVO.searchName eq '' || paramVO.searchName eq null || paramVO.searchName eq undefined }">
										작성자+제목
									</c:if>
									<c:if test="${paramVO.searchName eq 'writer'}">
										작성자
									</c:if>
									<c:if test="${paramVO.searchName eq 'title'}">
										제목
									</c:if>
								</label> 
								<select id="searchName">
									<option value="" <c:if test="${paramVO.searchName eq '' || paramVO.searchName eq null || paramVO.searchName eq undefined }">selected</c:if>>작성자+제목</option>
									<option value="writer" <c:if test="${paramVO.searchName eq 'writer'}">selected</c:if>>작성자</option>
									<option value="title" <c:if test="${paramVO.searchName eq 'title'}">selected</c:if>>제목</option>
								</select>
								</div>
								<input type="text" class="ml5" style="width:180px;" id="searchValue" name="searchValue" value="${paramVO.keyword}"/>
						</dd>
					</li>
				<li>
						<dt>기간</dt>
						<dd>
<input type="text" class="ml5" style="width:110px;" id="startDate" name="startDate" value="${paramVO.startDate}"/> ~ 
								<input type="text" class="ml5" style="width:110px;" id="endDate" name="endDate" value="${paramVO.endDate}"/>
						</dd>
					</li>
			
				
				</ul>
			<div class="fr pt5 pb10">
				<button class="btn_con_search" onclick="goSearch(); return false;"><img src="../resources/images/btn_icon_search.png" style="vertical-align:middle;"/> 검색</button>
				<button class="btn_con_search" onclick="searchInitialize(); return false;"><img src="../resources/images/btn_icon_refresh.png" style="vertical-align:middle;"/> 검색 초기화</button>
			</div>
</div>
	
			<div class="main_tbl">
				<table class="tbl01">
					<colgroup>
					<col width="10%">
					<col width="10%">					
					<col width="10%">
					<col width="30%">
					<col width="10%">
					</colgroup>
					<thead>
					<tr>
					<th>번호</th>
					<th>제목</th>
					<th>작성자</th>
					<th>작성일</th>
					<th>파일다운로드</th>
					</thead>
						<tbody>
							<c:set var="now" value="<%=new java.util.Date()%>"/> 
							<fmt:formatDate var="nowDate" value="${now}" pattern="yyyy.MM.dd"/>
					<c:if test="${fn:length(TeamnoticeList) > 0 }">
						<c:forEach items="${TeamnoticeList}" var="item" varStatus="status">
						<Tr>
							<Td>${item.nNo}</Td>
							<fmt:formatDate var="parseRegDate" pattern="yyyy.MM.dd" value="${item.regDate}"/>
							<Td ><div class="ellipsis_txt tgnl"><a href="#" onclick="getDetail('${item.nNo}')"> ${item.title}</a> (${item.commentCount})<c:if test="${nowDate <= parseRegDate}"><span class="icon_new">N</span></c:if></div></Td>
							<Td>${item.userName}</Td>
							<Td>${fn:substring(item.regDate,0,19)}</Td>
							<Td><input type="checkbox"  id="teamFile_${status.index}" name="fileCheckBox" value="${item.nNo}"/><label for="teamFile_${status.index}"><span></span></label></Td>
						</Tr>
						</c:forEach>
					</c:if>
					<c:if test="${fn:length(TeamnoticeList) == 0 }">
						<Tr>
							<Td colspan="5">' 작성된 게시물이 없습니다. '</Td>
						</Tr>
					</c:if>
						</tbody>
				</table>
				<c:if test="${totalCount > 0}">
					<div class="page_navi  mt10">				
						${navi.prevBlock}
						${navi.pageList}
						${navi.nextBlock}
					</div>
				</c:if>
		</div>
			<div class="btn_box_con"> <!-- <button class="btn_admin_red" onclick="registNotice(); return false;">문의하기</button> -->
			<button class="btn_admin_red" onclick="fileDown(); return false;">선택 파일 다운로드</button>
			<button class="btn_admin_red" onclick="registNotice(); return false;">작성하기</button> 
			</div>
			 <hr class="con_mode"/><!-- 신규 추가 꼭 데려갈것 !-->
			</div>
			</section>
		</div>
		
</form>

