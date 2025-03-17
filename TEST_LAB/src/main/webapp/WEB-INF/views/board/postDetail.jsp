<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ taglib prefix="userUtil" uri="/WEB-INF/tld/userUtil.tld"%>
<%@ page import="java.util.*,kr.co.aspn.vo.*,kr.co.aspn.util.*"%>
<%@ page import="kr.co.aspn.util.StringUtil"%>
<%@ page session="false"%>

<%
	pageContext.setAttribute("crcn", "\n");
	pageContext.setAttribute("br", "<br>");
%>

<script type="text/javascript">
	$(document).ready(function() {
		var selectTarget = $('.selectbox select');

		selectTarget.on('blur', function() {
			$(this).parent().removeClass('focus');
		});

		selectTarget.change(function() {
			var select_name = $(this).children('option:selected').text();

			$(this).siblings('label').text(select_name);
		});

		var topBar = $("#topBar").offset();

		$(window).scroll(function() {

			var docScrollY = $(document).scrollTop()
			var barThis = $("#topBar")
			var fixNext = $("#fixNextTag")

			if (docScrollY > topBar.top) {
				barThis.addClass("top_bar_fix");
				fixNext.addClass("pd_top_80");
			} else {
				barThis.removeClass("top_bar_fix");
				fixNext.removeClass("pd_top_80");
			}

		});
	});

	function modifyForm(nNo){
		var form = document.createElement('form');
		form.style.display = 'none';
		$('body').append(form);
		form.action = '/board/modifyForm';
		form.method = 'post';
		
		appendInput(form, 'type', '${type}');
		appendInput(form, 'nNo', nNo);
		
		form.submit();
	}

	function golist() {
		var form = document.createElement('form');
		form.style.display = 'none';
		$('body').append(form);
		form.action = '/board/labNotice';
		form.method = 'post';
		
		form.submit();
		
		/* location.href = "/adminNotice/noticeList?pageNo=" + '${paramVO.pageNo}'
				+ "&keyword="
				+ encodeURI(encodeURIComponent('${paramVO.keyword}'))
				+ '&searchName='
				+ encodeURI(encodeURIComponent('${paramVO.searchName}'))
				+ "&startDate=" + '${paramVO.startDate}' + "&endDate="
				+ '${paramVO.endDate}';
		
			 */
	}
	
	function deletePost(nNo){
		if (confirm("삭제하시겠습니까? ")) {
			var URL = "/board/deletePost";
			$.ajax({
				type : "POST",
				url : URL,
				data : {
					"nNo" : nNo
				},
				success: function(data){
					if(data.status == 'success'){
						alert('삭제되었습니다');
						golist();
					} else {
						alert('삭제 오류');
					}
				},
				error: function(a,b,c){
					alert('[F]시스템 오류 시스템 담당자에게 문의하세요');
				}
			})
		}
	}

	//파일 다운로드
	function fileDownload(fmNo, tbkey) {
		location.href = "/file/fileDownload?fmNo=" + fmNo + "&tbkey=" + tbkey
				+ "&tbType=notice";
	}
</script>
<div class="wrap_in" id="fixNextTag">
	<span class="path">게시글 보기&nbsp;&nbsp;<img src="../resources/images/icon_path.png" style="vertical-align: middle" />&nbsp;&nbsp;${typeText} 게시판&nbsp;&nbsp;<img src="../resources/images/icon_path.png" style="vertical-align: middle" />&nbsp;&nbsp;게시판&nbsp;&nbsp;<img src="../resources/images/icon_path.png" style="vertical-align: middle" />&nbsp;&nbsp;<a href="#">${strUtil:getSystemName()}</a></span>
	<section class="type01">
		<h2 style="position: relative">
			<span class="title_s">Post Detail</span> <span class="title">게시글 보기</span>
			<div class="top_btn_box">
				<ul>
					<li><button class="btn_circle_nomal" onclick="golist(); return false;">&nbsp;</button></li>

				</ul>

			</div>
		</h2>
		<div class="group01">
			<div class="title">
				<!--span class="txt">연구개발시스템 공지사항</span-->
			</div>
			<div class="notice_title">
				<span class="font17">${postDetail.title}</span><br /> <span class="font18">작성자 : ${postDetail.userName } <strong>&nbsp;|&nbsp;</strong> <img src="../resources/images/btn_calendar2.png" style="margin-top: -2px;"> 작성일 : ${fn:substring(postDetail.regDate,0,19)}
				</span>
			</div>

			<div class="main_tbl">
				<ul class="notice_view">
					<li>
						<div class="text_view" style="border-bottom: 1px solid #ddd;">${strUtil:getHtml(fn:replace(postDetail.content,br,crcn))}</div> 
						<!-- 첨부파일 start 없을때는 아예 노출 하지 않도록 --> 
						<c:if test="${fn:length(fileList) !=0 }">
							<div class="con_file fl" style="padding-bottom: -20px; padding-top: 20px">
								<ul>
									<li>
										<dt>첨부파일</dt><dd>
											<c:forEach items="${fileList}" var="file" varStatus="status">
												<ul>
													<li><a href="/file/fileDownload?fmNo=${file.fmNo }&tbkey=${file.tbKey}&tbType=${file.tbType}">${file.orgFileName}</a>( ${fn:substring(postDetail.regDate,0,19)} )</li>
												</ul>
											</c:forEach>
										</dd>
									</li>
								</ul>
							</div>
						</c:if>
						<!-- 첨부파일 close -->


						<div class="btn_box_con5">
							<button class="btn_admin_gray" onclick="golist(); return false;" style="width: 120px;">목록</button>
						</div>
						<div class="btn_box_con4">
							<c:if test="${userUtil:getIsAdmin(pageContext.request) == 'Y' || userUtil:getUserGrade(pageContext.request) == '3'}">
								<button class="btn_admin_navi" onclick="modifyForm('${postDetail.nNo}');  return false;">게시글 수정</button>
								<button class="btn_admin_gray" onclick="deletePost('${postDetail.nNo}'); return false;">게시글 삭제</button>
							</c:if>
						</div>
						<hr class="con_mode" />
						<!-- 신규 추가 꼭 데려갈것 !-->
					</li>
				</ul>
			</div>
		</div>
	</section>
</div>
