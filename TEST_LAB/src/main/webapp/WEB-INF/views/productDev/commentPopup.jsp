<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="userUtil" uri="/WEB-INF/tld/userUtil.tld"%>

<title>수정내역</title>

<script type="text/javascript" src="/resources/js/jquery.auto-complete.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		var params = window.opener.getParentParams();
		console.log(params)
		$('#docNo').val(params.docNo);
		$('#docVersion').val(params.docVersion);
		
		loadCommentList();
	})
	
	function loadCommentList(){
		var tbKey = '${tbKey}';
		var tbType = '${tbType}';
		var tr_id = 'mgf_tr_'+tbKey;
		
		var userGrade = '${userUtil:getUserGrade(pageContext.request)}';
		var isAdmin = '${userUtil:getIsAdmin(pageContext.request)}';
		
		$('#commentListDiv').empty();
		$('#commentTbType').val(tbType);
		$('#commentTbKey').val(tbKey);
		
		$.ajax({
		    url: '/comment/getCommentList',
		    type: 'post',
		    dataType: 'json',
		    data: {
		        tbKey: tbKey,
		        tbType: tbType,
		    },
		    success: function(data){
		        if(data.length>0){
		        	$('#layerCommentCnt').text('의견('+data.length+')');
		        	
		        	var parentLi = window.opener.$("#mgf_tr_"+tbKey+" #commentLi");
		        	if(parentLi.children('span').length > 0){
		        		window.opener.$("#mgf_tr_"+tbKey+" td:last ul li span.badgeCnt").text(data.length);
		        	} else {
		        		var element = '<span class="badgeCnt">'+data.length+'</span>'
		        		parentLi.append(element);
		        	}
		        	
		        	
		        	$('#'+tr_id+' td:last span.badgeCnt').text(data.length)
			        data.forEach(function(comment){
				        var commentElement = '<div class="comment_obj2">';
				        commentElement += '<span class="comment_id">'+comment.userName+'</span>';
				        commentElement += '<span class="comment_date"> '+comment.regDate;
				        if(userGrade == '3' || isAdmin == 'Y'){
				        //if(currentUserId == comment.reguserId){
					        commentElement += '&nbsp;&nbsp&nbsp;&nbsp;<a href="javascript:;" onclick="editCommentMode(event, \''+comment.cNo+'\', \''+tbKey+'\', \''+tbType+'\')"><img src="/resources/images/icon_doc03.png"> 수정</a>';
					        commentElement += ' | <a href="javascript:;" onclick="deleteComment(\''+comment.cNo+'\', \''+tbKey+'\')"><img src="/resources/images/icon_doc04.png"> 삭제</a>';
				        }
				        commentElement += '<span class="comment_data">'+comment.comment.replace(/(?:\r\n|\r|\n)/g, '<br />')+'</span>';
				        commentElement += '</div>';
				        $('#commentListDiv').append(commentElement);
			        })
		        } else {
		        	var commentElement = '<div class="comment_obj2"><span class="comment_data">입력된 수정내역이 없습니다.</span></div>';
		        	$('#commentListDiv').append(commentElement);
		        }
		        
		    },
		    error: function(a,b,c){
		        //console.log(a,b,c)
		        alert('코멘트 불러오기 실패[2] - 시스템 담당자에게 문의하세요');
		    }
		    , complete: function(){
		    	$('#lab_loading').hide();
		    }
		})
	}
		
	function editCommentMode(e, cNo, tbKey, tbType){
		var comment = $(e.target).parent().children('span.comment_data').html().replace(/<br>/g, '\n');
		$(e.target).parent().parent().hide();
		
		var editElement = '<div class="comment_obj2">';
		editElement += '<div class="insert_comment">';
		editElement += '<table style="width: 738px; margin-left: 2px;">';
		editElement += '<tr>';
		editElement += '<td><textarea style="width: 100%; height: 50px; background-color: #fffeea;" placeholder="의견을 입력하세요">'+comment+'</textarea></td>';
		editElement += '<td width="81px"><button style="width: 95%; height: 52px; margin-top: -2px; font-size: 13px;" onclick="updateComment(event, \''+cNo+'\', \''+tbKey+'\', \''+tbType+'\')">수정</button></td>';
		editElement += '<td width="80px"><button style="width: 100%; height: 52px; margin-top: -2px; font-size: 13px;" onclick="editCommentCancel(event)">수정취소</button></td>';
		editElement += '</tr>';
		editElement += '</table>';
		editElement += '</div>';
		editElement += '</div>';
		
		$(e.target).parent().parent().after(editElement);
	}
	
	function updateComment(e, cNo, tbKey, tbType){
		$('#lab_loading').show();
		var comment = $(e.target).parent().prev().children('textarea').val();
		var docNo = $('#docNo').val()
		var docVersion = $('#docVersion').val();
		
		$.ajax({
		    url: '/comment/updateComment',
		    type: 'post',
		    data: {
		        cNo: cNo,
		        tbKey: tbKey,
		        tbType: tbType,
		        comment: comment,
		    },
		    success: function(data){
		    	if(data == 'S'){
		    		alert('수정되었습니다.');
		    		loadCommentList();
		    	} else {
		    		alert('수정 오류[1]');
		    	}
		    },
		    error: function(a,b,c){
		    	//console.log(a,b,c);
		    	return alert('수정 오류[2]');
		    },
		    complete: function(){
		    	$('#lab_loading').hide();
		    }
		})
		
	}
	
	function editCommentCancel(e){
		$(e.target).parent().parent().parent().parent().parent().parent().prev().show();
		$(e.target).parent().parent().parent().parent().parent().parent().remove();
	}
	
	function deleteComment(cNo, tbKey){
		if(!confirm('선택한 의견을 정말 삭제하시겠습니까?')){
			return;
		}
		$('#lab_loading').show();
		var tbKey = $('#commentTbKey').val();
		
		$.ajax({
		    url: '/comment/deleteComment',
		    type: 'post',
		    data: { cNo: cNo, tbKey: tbKey, tbType: 'manufacturingProcessDoc'},
		    success: function(data){
		    	if(data == 'S'){
		    		$('#commentText').val('');
		    		alert('삭제되었습니다.');
		    		loadCommentList();
		    	} else {
		    		alert('삭제 오류[1]');
		    	}
		    },
		    error: function(a,b,c){
		    	//console.log(a,b,c);
		    	return alert('삭제 오류[2]');
		    },
		    complete: function(){
		    	$('#lab_loading').hide();
		    }
		})
	}
	
	function addComment(){
		$('#lab_loading').show();
		var tbKey = '${tbKey}';
		var tbType = '${tbType}';
		var docNo = $('#docNo').val()
		var docVersion = $('#docVersion').val();
		
		/* alert('tbKey : ' + tbKey);
		alert('tbType : ' + tbType);
		alert('comment : ' + $('#commentText').val());
		return; */
		
		$.ajax({
		    url: '/comment/addComment',
		    type: 'post',
		    data: {
		        tbKey: tbKey,
		        tbType: tbType,
		        comment: $('#commentText').val()
		    },
		    success: function(data){
		    	if(data == 'S'){
		    		$('#commentText').val('');
		    		alert('등록되었습니다.');
		    		loadCommentList();
		    	} else {
		    		alert('등록 오류[1]');
		    	}
		    },
		    error: function(a,b,c){
		    	//console.log(a,b,c);
		    	return alert('등록 오류[2]');
		    },
		    complete: function(){
		    	$('#lab_loading').hide();
		    }
		})
	}
</script>

<input id="commentTbType" type="hidden" value="">
<input id="commentTbKey" type="hidden" value="">
<input id="docNo" type="hidden" value="">
<input id="docVersion" type="hidden" value="">

<div class="wrap_pop">
	<div class="wrap_in02">
		<div class="wrap_in">
			<h2 style="position: fixed;" class="print_hidden">
				<span class="title"><img src="/resources/images/bg_bs_box_fast02.png">&nbsp;&nbsp;수정내역</span>
			</h2>
			<div class="top_btn_box" style="position: fixed;">
				<ul>
					<li><button class="btn_pop_close"></button></li>
				</ul>
			</div>

			<div id='print_page' style="padding: 70px 20px 20px 20px;">
				<!-- 수정리스트 start --------------------------------------------------------------------------------------------------------------------------------------------------------->
				<div class="list_detail">
					<ul>
						<li class="pt10">
							<dt id="layerCommentCnt" style="width: 20%">의견</dt>
							<dd style="width: 80%;">
								<div class="insert_comment">
									<table style="width: 756px">
										<tr>
											<td><textarea id="commentText" style="width: 100%; height: 50px" placeholder="의견을 입력하세요"></textarea></td>
											<td width="98px"><button style="width: 100%; height: 52px; margin-top: -2px; font-size: 13px" onclick="addComment()">등록</button></td>
										</tr>
									</table>
								</div>
								<div id="commentListDiv" class="app_comment" style="height: 100%;">
									<!-- 일반댓글obj start-->
									<!-- <div class="comment_obj2">
										<span class="comment_id">관리자1</span> <span class="comment_date">2019.01.12 22:22:00&nbsp;&nbsp;&nbsp;&nbsp;<a href="#"><img src="images/icon_doc03.png"> 수정</a> | <a href="#"><img src="images/icon_doc04.png"> 삭제</a> <span class="comment_data">입력된 코멘트1</span>
									</div> -->
									<!-- 일반댓글obj close-->

									<!-- 일반댓글수정  start-->
									<!-- <div class="comment_obj2">
										<div class="insert_comment">
											<table style="width: 738px; margin-left: 2px;">
												<tr>
													<td><textarea style="width: 100%; height: 50px; background-color: #fffeea;" placeholder="의견을 입력하세요">ㅁㄴㅇ럼ㄴ이ㅏ럼ㅇㄹ만얾;ㄴ이ㅏ럼ㄴ;이ㅏ러;이</textarea></td>
													<td width="81px"><button style="width: 95%; height: 52px; margin-top: -2px; font-size: 13px;">수정</button></td>
													<td width="80px"><button style="width: 100%; height: 52px; margin-top: -2px; font-size: 13px;">수정취소</button></td>
												</tr>
											</table>
										</div>
									</div> -->
									<!-- 일반댓글 수정obj close-->
									<!-- 일반댓글obj start-->
									<!-- <div class="comment_obj2">
										<span class="comment_id">관리자2</span> <span class="comment_date">2019.01.12 22:22:00</span> <span class="comment_data">입력된 코멘트2</span>
									</div> -->
									<!-- 일반댓글obj close-->
									<!-- 일반댓글obj start-->
									<div class="comment_obj2">
										<span class="comment_data">입력된 수정내역이 없습니다.</span>
									</div>
									<!-- 일반댓글obj close-->
								</div>
							</dd>
						</li>
					</ul>
				</div>
				<!-- 수정리스트 close --------------------------------------------------------------------------------------------------------------------------------------------------------->
			</div>
		</div>
	</div>
</div>
