<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ page session="false" %>
<%
	pageContext.setAttribute("crcn", "\n");
	pageContext.setAttribute("br", "<br>");
%>
	<title>공지사항</title>
	<script type="text/javascript">
	
	//공지사항 작성페이지
	function registNotice(){
		location.href = "/faqNotice/FaqRegistForm?pageNo="+'${pageNo}'+"&keyword="+encodeURI(encodeURIComponent('${paramVO.keyword}'))+'&searchName='+encodeURI(encodeURIComponent('${paramVO.searchName}'));
	}
	
	//게시물 상세정보 가져오기
	function getDetail(no){
		location.href="/faqNotice/getFaqNoticeDetail?nNo="+no+"&pageNo="+"${pageNo}"+"&keyword="+encodeURI(encodeURIComponent('${paramVO.keyword}'))+'&searchName='+encodeURI(encodeURIComponent('${paramVO.searchName}'))+"&tbType=faq";
	}
	
	function goSearch(){
		
		var keyword = encodeURI(encodeURIComponent($("#searchValue").val()));
		
		var searchName = encodeURI(encodeURIComponent($("#searchName").val()));
		
		location.href="/faqNotice/FaqnoticeList?keyword="+keyword+"&searchName="+searchName;
	}
	
	function changePage(page){
		
		location.href = '/faqNotice/FaqnoticeList?pageNo=' + page + '&keyword='+encodeURI(encodeURIComponent('${paramVO.keyword}'))+'&searchName='+encodeURI(encodeURIComponent('${paramVO.searchName}'));
	}
	
	function deleteFaq(no){
		if(confirm("삭제하시겠습니까? ")){
			var URL = "/faqNotice/FaqNoticeDelete";
			$.ajax({
				type:"POST",
				url:URL,
				data:{"nNo": no,
					   "tbType":"faq"},
				dataType:"json",
				success:function(data) {
					if(data.status == 'success'){
			        	alert("삭제되었습니다.");	
			        	location.href = '/faqNotice/FaqnoticeList?pageNo='+'${pageNo}'+"&keyword="+encodeURI(encodeURIComponent('${paramVO.keyword}'))+'&searchName='+encodeURI(encodeURIComponent('${paramVO.searchName}'));
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
	
	function modifyFaq(no){
		
		location.href = "/faqNotice/FaqModifyForm?nNo="+no+"&pageNo="+'${pageNo}'+"&keyword="+encodeURI(encodeURIComponent('${paramVO.keyword}'))+'&searchName='+encodeURI(encodeURIComponent('${paramVO.searchName}'))+"&tbType=faq";
	}
	
	function OpenCloseFaq(obj){
		
		var src = $(obj).attr("src");
		
		if(src == '../resources/images/img_add_doc.png'){
			$(obj).attr("src","../resources/images/img_m_doc.png");
		}else{
			$(obj).attr("src","../resources/images/img_add_doc.png");
		}
		
		var style = $(obj).parent().parent().next().attr("style");
		
		if(style == "display:none"){
			$(obj).parent().parent().next().attr("style","display:show");
		}else{
			$(obj).parent().parent().next().attr("style","display:none");
		}
		
	}
	
	function searchInitialize(){
		
		$("#searchValue").val('');
	 	location.href = "/faqNotice/FaqnoticeList";
		
	}
</script>

<%-- <form name="listForm" id="listForm" method="get" action="/faqNotice/FaqnoticeList">
<jsp:useBean id="toDay" class="java.util.Date" />
	<span class="path">
		공지사항&nbsp;&nbsp;<img src="../resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;
		<a href="#">파리크라상 식품기술 연구개발시스템</a>
	</span>
	<section class="type01">
		<h2 style="position:relative">
			<span class="title_s">Notice</span>
			<span class="title">공지사항</span>
			<div class="top_btn_box">
			<c:if test="${sessionId eq 'admin'}">
				<ul>
					<li>
						<button type="button" onclick="registNotice(); return false;"  class="btn_circle_red">&nbsp;</button>
					</li>
				</ul>
			</c:if>
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
					<c:if test="${fn:length(FaqnoticeList) == 0 }">
						<tr>
							<td colspan="4">조회 결과가 없습니다.</td>
						</tr>	
					</c:if>
					<c:if test="${fn:length(FaqnoticeList) > 0 }">
						<c:forEach items="${FaqnoticeList}" var="item" varStatus="status">
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
					<c:if test="${FaqnoticeList.page.hasPrev() == true}">
						<li style="border-right: none;">
							<a href="#none" class="btn btn_prev1" onclick="">Prev</a>
						</li>	
					</c:if>
					<c:forEach items="${FaqnoticeList.page.getPageList()}" var="page">
						<c:if test="${page == FaqnoticeList.page.showPage}">
							<li class="select" style="border-right: none;">
								<a href="#none" class="btn btn_prev1" onclick="changePage(${page})">${page}</a>
							</li>
						</c:if>
						<c:if test="${page != FaqnoticeList.page.showPage}">
							<li style="border-right: none;">
								<a href="#none" class="btn btn_prev1" onclick="changePage(${page})">${page}</a>
							</li>
						</c:if>
					</c:forEach>
					<c:if test="${FaqnoticeList.page.hasNext() == true}">
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
	</section>
</form> --%>
<form name="listForm" id="listForm" method="get" action="/faqNotice/FaqnoticeList">
	<div class="wrap_in" id="fixNextTag">
				<span class="path">자주 하는 질문&nbsp;&nbsp;<img src="../resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;게시판&nbsp;&nbsp;<img src="../resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;<a href="#">${strUtil:getSystemName()}</a></span>
				<section class="type01">
				<!-- 상세 페이지  start-->
					<h2 style="position:relative"><span class="title_s">FAQ</span>
						<span class="title">자주 하는 질문</span>
						<div  class="top_btn_box">
							<c:if test="${sessionId eq 'admin'}">
								<ul><li><button class="btn_circle_red" onClick="registNotice(); return false;">&nbsp;</button></li></ul>
							</c:if>
						</div>
					</h2>
						<div class="group01" >
	<div class="title"><!--span class="txt">연구개발시스템 공지사항</span--></div>
	
	<div class="search_box" >
				<ul>
					<li style="margin-left:25%">
						<dt>키워드</dt>
						<dd>
						
						<div class="selectbox" style="width:130px;">  
								<label for="searchName">
									<c:if test="${paramVO.searchName eq '' || paramVO.searchName eq null || paramVO.searchName eq undefined}">
										제목+내용
									</c:if>
									<c:if test="${paramVO.searchName eq 'title'}">
										제목
									</c:if>
									<c:if test="${paramVO.searchName eq 'content'}">
										내용
									</c:if>
								</label> 
								<select id="searchName">
									<option value="" <c:if test="${paramVO.searchName eq '' || paramVO.searchName eq null || paramVO.searchName eq undefined}">selected</c:if> >제목+내용</option>
									<option value="title"  <c:if test="${paramVO.searchName eq 'title'}">selected</c:if>>제목</option>
									<option value="content" <c:if test="${paramVO.searchName eq 'content'}">selected</c:if>>내용</option>
								</select>
								</div>
								<input type="text" class="ml5" style="width:180px;"  id="searchValue" name="searchValue"  value="${paramVO.keyword}"/>
						</dd>
					</li>
			
			
				
				</ul>
		<div class="fr pt5 pb10">
			<button class="btn_con_search" onclick="goSearch(); return false;"><img src="../resources/images/btn_icon_search.png" style="vertical-align:middle;"/> 검색</button>
			<button class="btn_con_search" onclick="searchInitialize(); return false;"><img src="../resources/images/btn_icon_refresh.png" style="vertical-align:middle;"/> 검색 초기화</button>
		</div>
		</div>
			<div class="main_tbl">
				<table class="tbl06">
					<colgroup>
					<col width="10%">
					<col />
					<col width="10%">
					</colgroup>
				
						<tbody>
				
						<c:if test="${fn:length(FaqnoticeList) == 0 }">
							<tr><td colspan="3">' 작성된 게시물이 없습니다. '</td></tr> 
						</c:if>
						<c:if test="${fn:length(FaqnoticeList) > 0 }">
							<c:forEach items="${FaqnoticeList}" var="item" varStatus="status">
								<tr>
									<td><img src="../resources/images/img_add_doc.png" onclick="OpenCloseFaq(this);"></td>
									<td><span class="qna_txt"><a href="#">${item.title}</a></span></td>
									<td>
										<ul class="list_ul">
											<li><button class="btn_doc" onclick="modifyFaq('${item.nNo}'); return false;"><img src="../resources/images/icon_doc03.png" > 수정</button></li>
											<li><button class="btn_doc" onclick="deleteFaq('${item.nNo}'); return false;"><img src="../resources/images/icon_doc04.png"> 삭제</button></li>
										</ul> 
									</td>
								</tr>
								<tr style="display:none">
									<td class="qna_rec" colspan="3">${strUtil:getHtml(fn:replace(item.content,br,crcn))}</td>
								</tr>
							</c:forEach>
						</c:if>
						</tbody>
				</table>
			<c:if test="${totalCount > 0}">
				<div class="page_navi mt10">
					${navi.prevBlock}
					${navi.pageList}
					${navi.nextBlock}
				</div>
			</c:if>
		</div>
			<div class="btn_box_con"> 
				<c:if test="${sessionId eq 'admin'}">
					<button class="btn_admin_red" onClick="registNotice(); return false;">작성하기</button>
				</c:if>
			</div>
			 <hr class="con_mode"/><!-- 신규 추가 꼭 데려갈것 !-->
			</div>
			</section>
		</div>
</form>