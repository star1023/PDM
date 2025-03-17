<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ taglib prefix="userUtil" uri="/WEB-INF/tld/userUtil.tld"%>
<%@ page import="java.util.*,kr.co.aspn.vo.*,kr.co.aspn.util.*" %>
<%@ page import="kr.co.aspn.util.StringUtil" %>
<%@ page session="false" %>
<%
	pageContext.setAttribute("crcn", "\n");
	pageContext.setAttribute("br", "<br>");
%>
	<link href="/resources/css/common.css?param=1" rel="stylesheet" type="text/css" />
	<link href="/resources/css/board.css" rel="stylesheet" type="text/css" />
	<link href="/resources/css/layout.css" rel="stylesheet" type="text/css" />
	<title>공지사항</title>
	<script type="text/javascript">
	$(document).ready(function (){
		  var selectTarget = $('.selectbox select');

		  selectTarget.on('blur', function(){
		    $(this).parent().removeClass('focus');
		  });

		   selectTarget.change(function(){
		     var select_name = $(this).children('option:selected').text();

		   $(this).siblings('label').text(select_name);
		   });
		   
			var topBar = $("#topBar").offset();

			$(window).scroll(function(){
				
				var docScrollY = $(document).scrollTop()
				var barThis = $("#topBar")
				var fixNext = $("#fixNextTag")

				if( docScrollY > topBar.top ) {
					barThis.addClass("top_bar_fix");
					fixNext.addClass("pd_top_80");
				}else{
					barThis.removeClass("top_bar_fix");
					fixNext.removeClass("pd_top_80");
				}

			});
	});
	
	
	//공지사항 수정페이지
	function modifyNotice (no){
		location.href = "/adminNotice/modifyForm?nNo="+no+"&pageNo="+'${paramVO.pageNo}'+"&keyword="+encodeURI(encodeURIComponent('${paramVO.keyword}'))+'&searchName='+encodeURI(encodeURIComponent('${paramVO.searchName}'))+"&startDate="+'${paramVO.startDate}'+"&endDate="+'${paramVO.endDate}'+"&tbType=notice";
	}
	
	function golist(){
		location.href="/adminNotice/noticeList?pageNo="+'${paramVO.pageNo}'+"&keyword="+encodeURI(encodeURIComponent('${paramVO.keyword}'))+'&searchName='+encodeURI(encodeURIComponent('${paramVO.searchName}'))+"&startDate="+'${paramVO.startDate}'+"&endDate="+'${paramVO.endDate}';
	}
	
	function deleteNotice(no){
		if(confirm("삭제하시겠습니까? ")){
			var URL = "/adminNotice/noticeDelete";
			$.ajax({
				type:"POST",
				url:URL,
				data:{"nNo": no,
					   "tbType":"notice"},
				dataType:"json",
				success:function(data) {
					if(data.status == 'success'){
			        	alert("삭제되었습니다.");	
			        	location.href="/adminNotice/noticeList?pageNo="+'${paramVO.pageNo}'+"&keyword="+encodeURI(encodeURIComponent('${paramVO.keyword}'))+'&searchName='+encodeURI(encodeURIComponent('${paramVO.searchName}'))+"&startDate="+'${paramVO.startDate}'+"&endDate="+'${paramVO.endDate}';
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
	
	//파일 다운로드
	function fileDownload(fmNo, tbkey){
		location.href="/file/fileDownload?fmNo="+fmNo+"&tbkey="+tbkey+"&tbType=notice";
	}
	
</script>
<%-- <form name="listForm" id="listForm" method="get" >
	<span class="path">
	공지사항&nbsp;&nbsp;
	<img src="../resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;
	<a href="#">파리크라상 식품기술 연구개발시스템</a>
	</span>
	<section class="type01">
		<h2 style="position:relative">
		<span class="title_s">Notice Doc</span>
		<span class="title">공지사항</span>
			<div  class="top_btn_box">
				<ul>
					<li>
						<button type="button" onclick="golist(); return false;"  class="btn_circle_nomal">&nbsp;</button>
					</li>
				</ul>
			</div>
		</h2>
		<div class="group01">
			<div class="title">&nbsp;</div>
			<div class="notice_title">
			<span class="font04">제목 : ${noticeView.title }</span><br>
			<span class="font18">작성자 :  ${noticeView.userName }<strong>&nbsp;|&nbsp;</strong> 작성일 :  ${fn:substring(noticeView.regDate,0,19)}</span>
			</div>
			<div class="main_tbl">
				<ul class="notice_view">
					<li>
						<div class="text_view"><c:set var="selValue" value="${StringUtil.getHtml(notice.contents)}" />${selValue}</div>
						<jsp:useBean id="test" class="kr.co.spc.util.StringUtil"/>
						<div class="text_view">${noticeView.content}</div> 
						<!-- 첨부파일 있을시 노출-->
						<ul class="view_list_file">
							<c:forEach items="${fileView}" var="item" varStatus="status">
								<li>
									<span>
										<a  href="/adminNotice/fileDownload2?fmNo=${item.fmNo }&tbkey=${item.tbkey}&tbType=notice">${item.subSequence}</a>
									</span>
								</li>
							</c:forEach>
						</ul>
					</li>
				</ul>				
			</div>
			<div class="btn_box_con" >
				<c:if test="${sessionId eq 'admin'}">
					<input type="button" value="수정" class="btn_admin_red" onclick="modifyNotice('${noticeView.nNo}');  return false;"> 
					<input type="button" value="삭제"  class="btn_admin_gray" onclick="deleteNotice('${noticeView.nNo}'); return false;">
				</c:if>
			</div>		
		</div>
	</section>
</form> --%>
 <div class="wrap_in" id="fixNextTag">
				<span class="path">공지사항&nbsp;&nbsp;<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;게시판&nbsp;&nbsp;<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;<a href="#">${strUtil:getSystemName()}</a></span>
				<section class="type01">
				<h2 style="position:relative"><span class="title_s">Notice</span>
	<span class="title">공지사항 상세</span>
	<div  class="top_btn_box">
			<ul>
					<li><button class="btn_circle_nomal" onclick="golist(); return false;">&nbsp;</button></li>
			
			</ul>

	</div>
	</h2>
		<div class="group01" >
	<div class="title"><!--span class="txt">연구개발시스템 공지사항</span--></div>
	<div class="notice_title">
	<span class="font17"> ${noticeView.title }</span><br/>
	<span class="font18">작성자 :  ${noticeView.userName } <strong>&nbsp;|&nbsp;</strong> <img src="../resources/images/btn_calendar2.png" style=" margin-top:-2px;"> 작성일 :  ${fn:substring(noticeView.regDate,0,19)}</span>
	</div>

	<div class="main_tbl">
				<ul class="notice_view">
				<li>
					<div class="text_view"  style="border-bottom:1px solid #ddd;"> ${strUtil:getHtml(fn:replace(noticeView.content,br,crcn))} </div>
				<!-- 첨부파일 start 없을때는 아예 노출 하지 않도록 -->
					<c:if test="${fn:length(fileView) !=0 }">
						<div class="con_file fl" style="padding-bottom:-20px; padding-top:20px">
							<ul>
								<li>
									<dt>첨부파일</dt><dd>
										<c:forEach items="${fileView}" var="item" varStatus="status">
											<ul>
												<li><a href="/file/fileDownload?fmNo=${item.fmNo }&tbkey=${item.tbkey}&tbType=notice">${item.orgFileName}</a>( ${fn:substring(noticeView.regDate,0,19)} )</li>
											</ul>
										</c:forEach> 
									</dd>
								</li>
							</ul>
						</div>
					</c:if>

								<!-- 첨부파일 close -->
		
	
			<div class="btn_box_con5">
				<button class="btn_admin_gray" onclick="golist(); return false;"  style="width:120px;">목록</button>
			</div>
			<div class="btn_box_con4">
			<c:if test="${userUtil:getIsAdmin(pageContext.request) == 'Y' || userUtil:getUserGrade(pageContext.request) == '3'}">
				<button class="btn_admin_navi" onclick="modifyNotice('${noticeView.nNo}');  return false;">게시글 수정</button> 
				<button class="btn_admin_gray" onclick="deleteNotice('${noticeView.nNo}'); return false;">게시글 삭제</button> 
			</c:if>
			</div>
			 <hr class="con_mode"/><!-- 신규 추가 꼭 데려갈것 !-->
			</div>
				</div>
			</section>
		</div> 
