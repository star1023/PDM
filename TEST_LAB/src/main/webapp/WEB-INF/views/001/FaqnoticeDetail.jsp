<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ page import="java.util.*,kr.co.aspn.vo.*,kr.co.aspn.util.*" %>
<%@ page import="kr.co.aspn.util.StringUtil" %>
<%@ page session="false" %>
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
		location.href = "/faqNotice/FaqModifyForm?nNo="+no+"&page="+'${page}'+"&keyword="+'${keyword}'+"&tbType=faq";
	}
	
	function golist(){
		location.href="/faqNotice/FaqnoticeList?pageNo="+'${page}'+"&keyword="+'${keyword}';
	}
	
	function deleteNotice(no){
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
						document.location="/faqNotice/FaqnoticeList";
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
		location.href="/file/fileDownload?fmNo="+fmNo+"&tbkey="+tbkey+"&tbType=faq";
	}
	
</script>
<form name="listForm" id="listForm" method="get" >
	<span class="path">
	공지사항&nbsp;&nbsp;
	<img src="../resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;
	<a href="#">${strUtil:getSystemName()}</a>
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
		<div class="group01" >
			<div class="title">&nbsp;</div>
			<div class="notice_title">
			<span class="font04">제목 : ${FaqnoticeView.title }</span><br>
			<span class="font18">작성자 :  ${FaqnoticeView.userName }<strong>&nbsp;|&nbsp;</strong> 작성일 :  ${fn:substring(FaqnoticeView.regDate,0,19)}</span>
			</div>
			<div class="main_tbl">
				<ul class="notice_view">
					<li>
<%-- 						<div class="text_view"><c:set var="selValue" value="${StringUtil.getHtml(notice.contents)}" />${selValue}</div> --%>
						<jsp:useBean id="test" class="kr.co.aspn.util.StringUtil"/>
						<div class="text_view">${FaqnoticeView.content}</div> 
						<!-- 첨부파일 있을시 노출-->
						<ul class="view_list_file">
							<c:forEach items="${FaqfileView}" var="item" varStatus="status">
								<li>
									<span>
										<a  href="/faqNotice/fileDownload2?fmNo=${item.fmNo }&tbkey=${item.tbkey}&tbType=faq">${item.subSequence}</a>
									</span>
								</li>
							</c:forEach>
						</ul>
					</li>
				</ul>				
			</div>
			<div class="btn_box_con" >
				<c:if test="${sessionId eq 'admin'}">
					<input type="button" value="수정" class="btn_admin_red" onclick="modifyNotice('${FaqnoticeView.nNo}');  return false;"> 
					<input type="button" value="삭제"  class="btn_admin_gray" onclick="deleteNotice('${FaqnoticeView.nNo}'); return false;">
				</c:if>
			</div>		
		</div>
	</section>
</form>

