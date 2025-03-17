<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
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
	
	function goDelete(rmrNo){
		
		var userId = '${userId}';
		
		if(confirm('삭제하시겠습니까?')){
			var URL = "/Reserve/ReserveDelete";
			$.ajax({
				type:"POST",
				url:URL,
				data:{"rmrNo":rmrNo,
					  "userId":userId},
				dataType:"json",
				success:function(data){
					if(data.result=='S'){
						alert("삭제되었습니다.");
						window.opener.location.reload();
						window.close();
					}else if(data.result=='F'){
						alert(data.msg);
					}else{
						alert("오류가 발생하였습니다.");
					}
				},
				error:function(request, status, errorThrown){
					alert("오류가 발생하였습니다.");
				}	
			});
		}
	}
	
	function goEdit(rmrNo){
		if(confirm('수정하시겠습니까?')){
			
			location.href = "/Reserve/ReserveEdit?rmrNo="+rmrNo;
			
		}
	}
	
	function goClose(){
		window.close();
	}
</script>
<form name="listForm" id="listForm" method="get" >
	<span class="path">
	공지사항&nbsp;&nbsp;
	<img src="../resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;
	<a href="#">파리크라상 식품기술 연구개발시스템</a>
	</span>
	<section class="type01">
		<h2 style="position:relative">
		<span class="title_s">Notice Doc</span>
		<span class="title">회의실 예약 상세정보</span>
		</h2>
		<div class="group01">
			<div class="title">&nbsp;</div>
			<div class="notice_title">
			<span class="font04">회의명 : ${data.title }</span><br>
			<span> 예약 회의실:
				<c:choose>
					<c:when test="${data.reserveCode == 'V'}">
							비전룸
					</c:when>
					<c:when test="${data.reserveCode == 'Y'}">
							열정룸
					</c:when>
					<c:when test="${data.reserveCode == 'G'}">
							가치룸
					</c:when>
					<c:when test="${data.reserveCode == 'S'}">
							신뢰룸
					</c:when>
				</c:choose>
			</span> <br>
			<span class="font18">
				<c:choose>
					<c:when test="${empty data.reserveDate}">
						-
					</c:when>
					<c:otherwise>
						<fmt:formatDate value="${data.reserveDate}" pattern="yyyy-MM-dd"/>(${data.dw}) ${data.reserveTime}
					</c:otherwise>
				</c:choose>
			</span>
			</div>
			<div class="main_tbl">
				<ul class="notice_view">
					<li>
						<div class="text_view">${data.memo}</div> 
					</li>
				</ul>				
			</div>
			<div class="btn_box_con" >
				<c:if test="${userId == 'admin' && grade == '8'}">
					<input type="button" value="수정" class="btn_admin_red" onclick="goEdit('${data.rmrNo}');  return false;"> 
					<input type="button" value="삭제"  class="btn_admin_gray" onclick="goDelete('${data.rmrNo}'); return false;">
				</c:if>
					<input type="button" value="닫기"  class="btn_admin_gray" onclick="goClose(); return false;">
			</div>		
		</div>
	</section>
</form>

