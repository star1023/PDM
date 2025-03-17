<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
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
		location.href = "/teamNotice/modifyForm?nNo="+no+"&pageNo="+'${paramVO.pageNo}'+"&keyword="+encodeURI(encodeURIComponent('${paramVO.keyword}'))+'&searchName='+encodeURI(encodeURIComponent('${paramVO.searchName}'))+"&startDate="+'${paramVO.startDate}'+"&endDate="+'${paramVO.endDate}'+"&tbType=team";
	}
	
	function golist(){
		location.href="/teamNotice/TeamnoticeList?pageNo="+'${paramVO.pageNo}'+"&keyword="+encodeURI(encodeURIComponent('${paramVO.keyword}'))+'&searchName='+encodeURI(encodeURIComponent('${paramVO.searchName}'))+"&startDate="+'${paramVO.startDate}'+"&endDate="+'${paramVO.endDate}';
	}
	
	function deleteNotice(no){
		if(confirm("삭제하시겠습니까? ")){
			var URL = "/teamNotice/noticeDelete";
			$.ajax({
				type:"POST",
				url:URL,
				data:{"nNo": no,
					   "tbType":"team"},
				dataType:"json",
				success:function(data) {
					if(data.status == 'success'){
			        	alert("삭제되었습니다.");	
			        	location.href="/teamNotice/TeamnoticeList?pageNo="+'${paramVO.pageNo}'+"&keyword="+encodeURI(encodeURIComponent('${paramVO.keyword}'))+'&searchName='+encodeURI(encodeURIComponent('${paramVO.searchName}'))+"&startDate="+'${paramVO.startDate}'+"&endDate="+'${paramVO.endDate}';
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
		location.href="/file/fileDownload?fmNo="+fmNo+"&tbkey="+tbkey+"&tbType=team";
	}
	
function registReply(nNo){
		
		var comment = $("#comment").val();
		
		if(confirm("댓글 등록 하시겠습니까? ")){
			var URL = "/teamNotice/replyRegistByNo";
			$.ajax({
				type:"POST",
				url:URL,
				data:{"tbKey": nNo,
						"commentTemp":comment},
				dataType:"json",
				success:function(data) {
					if(data.status == 'success'){
			        	alert("등록되었습니다.");	
			        	location.href="/teamNotice/TeamnoticeList?pageNo="+'${paramVO.pageNo}'+"&keyword="+encodeURI(encodeURIComponent('${paramVO.keyword}'))+'&searchName='+encodeURI(encodeURIComponent('${paramVO.searchName}'))+"&startDate="+'${paramVO.startDate}'+"&endDate="+'${paramVO.endDate}';
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
function deleteReply(nNo,cNo){
	if(confirm("댓글삭제하시겠습니까? ")){
		var URL = "/teamNotice/replyDeleteByNo";
		$.ajax({
			type:"POST",
			url:URL,
			data:{"tbKey": nNo,
				   "cNo":cNo},
			dataType:"json",
			success:function(data) {
				if(data.status == 'success'){
		        	alert("삭제되었습니다.");	
		        	location.href="/teamNotice/TeamnoticeList?pageNo="+'${paramVO.pageNo}'+"&keyword="+encodeURI(encodeURIComponent('${paramVO.keyword}'))+'&searchName='+encodeURI(encodeURIComponent('${paramVO.searchName}'))+"&startDate="+'${paramVO.startDate}'+"&endDate="+'${paramVO.endDate}';
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
function openModifyForm(obj){
	
	var obj = $(obj);
	
	obj.parent().parent().parent().next().attr("style","display:show");
	obj.parent().parent().parent().attr("style","display:none");
}

function closeReplyModForm(obj){
	
	var obj = $(obj);
	
	obj.parent().parent().parent().attr("style","display:none");
	obj.parent().parent().parent().prev().attr("style","display:show");
	
}

function modifyReply(tbKey,cNo,obj){
	
	var commentTemp = $(obj).parent().prev().children().eq(0).val();
	
 	if(confirm("해당댓글수정하시겠습니까? ")){
		var URL = "/teamNotice/ReplyUpdateByNo";
		$.ajax({
			type:"POST",
			url:URL,
			data:{"tbKey": tbKey,
				   "cNo":cNo,
				   "commentTemp":commentTemp},
			dataType:"json",
			success:function(data) {
				if(data.status == 'success'){
		        	alert("수정되었습니다.");	
		        	location.href="/teamNotice/TeamnoticeList?pageNo="+'${paramVO.pageNo}'+"&keyword="+encodeURI(encodeURIComponent('${paramVO.keyword}'))+'&searchName='+encodeURI(encodeURIComponent('${paramVO.searchName}'))+"&startDate="+'${paramVO.startDate}'+"&endDate="+'${paramVO.endDate}';
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
</script>
<form name="listForm" id="listForm" method="get" >
	<%-- <span class="path">
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
		<div class="group01" >
			<div class="title">&nbsp;</div>
			<div class="notice_title">
			<span class="font04">제목 : ${TeamnoticeView.title }</span><br>
			<span class="font18">작성자 :  ${TeamnoticeView.userName }<strong>&nbsp;|&nbsp;</strong> 작성일 :  ${fn:substring(TeamnoticeView.regDate,0,19)}</span>
			</div>
			<div class="main_tbl">
				<ul class="notice_view">
					<li>
						<div class="text_view"><c:set var="selValue" value="${StringUtil.getHtml(notice.contents)}" />${selValue}</div>
						<jsp:useBean id="test" class="kr.co.spc.util.StringUtil"/>
						<div class="text_view">${TeamnoticeView.content}</div> 
						<!-- 첨부파일 있을시 노출-->
						<ul class="view_list_file">
							<c:forEach items="${TeamfileView}" var="item" varStatus="status">
								<li>
									<span>
										<a  href="/teamNotice/fileDownload2?fmNo=${item.fmNo }&tbkey=${item.tbkey}&tbType=team">${item.subSequence}</a>
									</span>
								</li>
							</c:forEach>
						</ul>
					</li>
				</ul>				
			</div>
			<div class="btn_box_con" >
				<c:if test="${sessionId eq noticeView.regUserId }">
					<input type="button" value="수정" class="btn_admin_red" onclick="modifyNotice('${noticeView.nNo}');  return false;"> 
					<input type="button" value="삭제"  class="btn_admin_gray" onclick="deleteNotice('${noticeView.nNo}'); return false;">
				</c:if>
				<input type="button" value="수정" class="btn_admin_red" onclick="modifyNotice('${TeamnoticeView.nNo}');  return false;"> 
					<input type="button" value="삭제"  class="btn_admin_gray" onclick="deleteNotice('${TeamnoticeView.nNo}'); return false;">
			</div>		
		</div>
	</section> --%>
		<div class="wrap_in" id="fixNextTag">
				<span class="path">${TeamnoticeView.deptCodeName}&nbsp;공지사항<img src="../resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;게시판&nbsp;&nbsp;<img src="../resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;<a href="#">${strUtil:getSystemName()}</a></span>
				<section class="type01">
				<h2 style="position:relative"><span class="title_s">Team</span>
	<span class="title">${TeamnoticeView.deptCodeName}팀 게시글 상세</span>
	<div  class="top_btn_box">
			<ul>
					<li><button class="btn_circle_nomal" onclick="golist(); return false;">&nbsp;</button></li>
			
			</ul>

	</div>
	</h2>
		<div class="group01" >
	<div class="title"><!--span class="txt">연구개발시스템 공지사항</span--></div>
	<div class="notice_title">
	<span class="font17">${TeamnoticeView.title}</span><br/>
	<span class="font18">작성자 :  ${TeamnoticeView.userName } <strong>&nbsp;|&nbsp;</strong> <img src="../resources/images/btn_calendar2.png" style=" margin-top:-2px;"> 작성일 :  ${fn:substring(TeamnoticeView.regDate,0,19)}</span>
	</div>

	<div class="main_tbl">
				<ul class="notice_view">
				<li>
					<div class="text_view">${strUtil:getHtml(fn:replace(TeamnoticeView.content,br,crcn))}</div>
				<!-- 첨부파일 start 없을때는 아예 노출 하지 않도록 -->
				<c:if test="${fn:length(TeamfileView) !=0 }">
					<div class="con_file fl" style="padding-bottom:-20px; padding-top:20px">
						<ul>
							<li>
								<dt>첨부파일</dt><dd>
									<c:forEach items="${TeamfileView}" var="item" varStatus="status">
										<ul>
											<li><a  href="/file/fileDownload?fmNo=${item.fmNo }&tbkey=${item.tbkey}&tbType=team">${item.orgFileName}</a>( ${fn:substring(TeamnoticeView.regDate,0,19)} )</li>
										</ul>
									</c:forEach>	
								</dd>
							</li>
						</ul>
					</div>
				</c:if>
								<!-- 첨부파일 close -->
								
								<!-- 댓글영역 start-->
								<div class="comment_txt">댓글(<strong>${fn:length(replyList)}</strong>) <i>|</i> 조회수(<strong>${TeamnoticeView.hits}</strong>)</div>
								<div class="comment_box">
								<div class="insert_comment">
									<table style=" width:100%">
										<tr><td><textarea style="width:100%; height:70px" placeholder="댓글을 입력하세요"  id="comment"></textarea></td><td width="130px"><button style="width:100%" onclick="registReply('${TeamnoticeView.nNo}'); return false;">등록</button></td></tr>
									</table>
								</div>
								
															
							<c:if test="${fn:length(replyList) ne 0 }">
							 
								<div class="view_comment">
								<!-- 일반댓글obj start-->
								<c:forEach items="${replyList}" var="item" varStatus="status">
									<div class="comment_obj">
										<span class="comment_id">${item.regUserId}</span>
										<span class="comment_date">${item.regDate}</span>
										<span class="comment_data">${item.comment}</span>
									
										<c:if test="${sessionId eq item.regUserId}">
											<ul class="list_ul">
												<li><button class="btn_doc" onclick="openModifyForm(this); return false;"><img src="../resources/images/icon_doc03.png"> 수정</button></li>
												<li><button class="btn_doc"  onclick="deleteReply('${TeamnoticeView.nNo}','${item.cNo}'); return false;"><img src="../resources/images/icon_doc04.png"> 삭제</button></li>
											</ul>  
										</c:if>
									</div>
									<div class="comment_obj" style="display:none">
										<div class="insert_comment">
											<table style=" width:100%">
												<tr><td><textarea style="width:100%; height:70px" placeholder="댓글을 입력하세요" >${item.comment}</textarea></td>
													<td width="130px"><button style="width:100%" onclick="modifyReply('${TeamnoticeView.nNo}','${item.cNo}',this); return false;">등록</button></td></tr>
											</table>
										</div>
										<ul class="list_ul">
											<li><button class="btn_doc" onclick="closeReplyModForm(this); return false;"><img src="../resources/images/icon_doc03.png"> 수정취소</button></li>
										</ul> 	
									</div>
								</c:forEach>
								<!-- 일반댓글obj close-->	
									<!-- 대댓글obj start-->
									<!-- 대댓글일 때는 클래스명에 rec 하나더 추가 -->
									<!-- 대댓글의 댓글은 지원하지않음 -->
									<!-- <div class="comment_obj rec ">
									<span class="comment_id">persepho</span>
									<span class="comment_date">2019.01.12 22:22:00</span>
									<span class="comment_data">리플내용리플내용리플내용리플내용리플내용리플내용리플내용 리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용</span>
									<ul class="list_ul">
										<li><button class="btn_doc"><img src="images/icon_doc03.png"> 수정</button></li>
										<li><button class="btn_doc"><img src="images/icon_doc04.png"> 삭제</button></li>
										<li><button class="btn_doc"><img src="images/icon_doc12.png"> 댓글취소</button></li>
										</ul> 
								
								</div> -->
								<!-- 대댓글obj close-->	
									<!-- 대댓글작성obj start-->
									<!-- 대댓글일 때는 클래스명에 rec 하나더 추가 -->
									<!-- 대댓글 작성을 누르면 보이고 대댓작성취소를 누르면 안보이게 처리-->
<!-- 									<div class="comment_obj rec ">
									<div class="insert_comment">
									<table style=" width:100%">
										<tr><td><textarea style="width:100%; height:70px" placeholder="댓글을 입력하세요"></textarea></td><td width="130px"><button style="width:100%">등록</button></td></tr>
									</table>
									</div>	
									</div> -->
								<!-- 대댓글작성obj close-->	
								</div>				
						</c:if>		
		</div>
		
				<!-- 댓글영역 close-->
				
				
				<div class="btn_box_con5">
			<button class="btn_admin_gray" onclick="golist(); return false;" style="width:120px;">목록</button>
			</div>
			<div class="btn_box_con4"><button class="btn_admin_navi"onclick="modifyNotice('${TeamnoticeView.nNo}');  return false;">게시글 수정</button> <button class="btn_admin_gray"  onclick="deleteNotice('${TeamnoticeView.nNo}'); return false;">게시글 삭제</button> </div>
			 <hr class="con_mode"/><!-- 신규 추가 꼭 데려갈것 !-->
			</div>
		</div>
				</section>
			</div>
</form>

