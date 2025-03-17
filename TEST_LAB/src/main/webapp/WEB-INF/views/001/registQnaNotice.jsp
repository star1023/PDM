<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ page session="false" %>
<html>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<head>
<title>공지사항 등록 페이지</title>
</head>
<link href="css/common.css" rel="stylesheet" type="text/css" />
<link href="css/board.css" rel="stylesheet" type="text/css" />
<link href="css/layout.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src='<c:url value="/resources/js/jquery-3.3.1.js"/>'></script>
<script type="text/javascript" src='<c:url value="/resources/js/jquery.form.js"/>'></script>
<script type="text/javascript">
	$(document).ready(function(){
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
		
		fileListCheck();
	});
	
	function stepchage(id,step){document.getElementById("width_wrap").className = step;}
	
	function noticeRegist() {
		
		if($('#title').val()==''){
			alert('제목을 입력해 주세요.');
			$('#title').focus();
			return false;
		}
		if($('#contentTemp').val()==''){
			alert('내용을 입력해 주세요.');
			$('#contentTemp').focus();
			return false;
		}
		
// 		$('#noticeRegistForm').submit();
		$('#noticeRegistForm').ajaxForm({
            beforeSubmit: function (data,form,option) {
                //validation체크 
                //막기위해서는 return false를 잡아주면됨
                return true;
            },
            success: function(response,result){
            	if(result == 'success'){
                	//성공후 서버에서 받은 데이터 처리
                	alert("게시글 작성에 성공하였습니다.");
                	location.href='/QnaNotice/QnaNoticeList?pageNo='+'${paramVO.pageNo}'+'&keyword='+encodeURI(encodeURIComponent('${paramVO.keyword}'))+'&searchName='+encodeURI(encodeURIComponent('${paramVO.searchName}'))+'&startDate='+'${paramVO.startDate}'+'&endDate='+'${paramVO.endDate}';
            	} else {
            		alert('게시글 작성 실패하였습니다.');
            	}
            },
            error: function(){
                //에러발생을 위한 code페이지
            	alert("오류가 발생하였습니다.");
            }                               
        }).submit();
	}
	
	function goNoticeList(){
		location.href='/QnaNotice/QnaNoticeList?pageNo='+'${paramVO.pageNo}'+'&keyword='+encodeURI(encodeURIComponent('${paramVO.keyword}'))+'&searchName='+encodeURI(encodeURIComponent('${paramVO.searchName}'))+'&startDate='+'${paramVO.startDate}'+'&endDate='+'${paramVO.endDate}';
	}
	
	var tmpNo = 1;
	
	function addFile(fileIdx) {
		var filePath = document.getElementById("file"+fileIdx).value;
		var fileName = filePath.substring(filePath.lastIndexOf('\\') + 1,	filePath.length);
		if (fileName.length == 0) {
			alert("파일을 선택해 주십시요.");
			return;
		}
		// 파일 추가
/* 		$("#fileSpan"+fileIdx).hide();
		tmpNo = ++fileIdx;
		var html = "";
		html += "<span class=\"file_load\" id=\"fileSpan" + fileIdx + "\">";
		html += "	<input type='file' name='files' id='file" + fileIdx + "' onChange=\"javaScript:addFile(tmpNo)\">";
		html += "	<label class=\"btn-default\" for=\"file" + fileIdx + "\" style=\"margin-top:-1px\">파일첨부</label>";
		html += "</span>"
		$("#upFile").append(html);
		html = "";
		html += "<li id='selfile" + fileIdx + "'>";
		html += "		<a href='#' onClick='javascript:deleteFile(this)'>";
		html += "			<img src=\"../resources/images/icon_del_file.png\">";
		html += "		</a>";
		html += "		"+fileName+"";
		html += "</li>"
		$("#fileList").append(html); */
		$("#fileSpan"+fileIdx).hide();
		tmpNo = ++fileIdx;
		var html = "";
		html += "<li id='selfile" + fileIdx 	+ "'>";
		html += "		<a href='#' onClick='javascript:deleteFile(this)'><img src=\"/resources/images/icon_del_file.png\"></a>";
		html += "		"+ fileName + "";
		html += "</li>"
		$("#fileData").append(html);
		html = "";
		html += "<span class=\"file_load\" id=\"fileSpan" + fileIdx + "\">";
		html += "<input type=\"file\" name=\"files\" id='file" + fileIdx + "' onChange=\"javaScript:addFile(tmpNo)\" style=\"display:none\"><label for=\"file" + fileIdx + "\">첨부파일 등록 <img src=\"/resources/images/icon_add_file.png\"></label>";
		html += "</span>";
		$("#upFile").append(html);
		fileListCheck();
	}
	
	//추가 파일 삭제 함수
	function deleteFile(e){
		var fileSpanId = $(e).parent().attr("id");
		var fileIndex = fileSpanId.slice(7);
		var fileId = "file"+fileIndex;
		var fileNo = fileIndex - 1;
		$(e).parent().remove();
		$("#file"+ fileNo).remove();
		$("#fileSpan"+ fileNo).remove();
		fileListCheck();
		return;
	}
	
	function fileListCheck(){
		var nodes=$("#fileData").children();
		if( nodes.length > 0 ) {
			$("#add_file2").prop("class","add_file");
			$("#fileList").show();
		} else {
			$("#add_file2").prop("class","add_file2");
			$("#fileList").hide();
		}
	}
</script>
	<form id="noticeRegistForm" name="noticeRegistForm" method="post" enctype="multipart/form-data" action="/QnaNotice/QnaNoticeRegistAction">
	<!-- 	<span class="path">
		공지사항 작성&nbsp;&nbsp;<img src="../resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;
		<a href="#">파리크라상 식품기술 연구개발시스템</a>
		</span>
		<section class="type01">
			<h2 style="position:relative">
			<span class="title_s">Notice</span>
			<span class="title">공지사항 작성</span>
			<div class="top_btn_box">
				<ul>
					<li>
						<button type="button" onclick="goNoticeList(); return false;"  class="btn_circle_nomal">&nbsp;</button>
					</li>
				</ul>
			</div>
			</h2>
			<div class="group01" >
			<div class="title">span class="txt">연구개발시스템 공지사항</span</div>
				<div class="list_detail">
					<ul>
						<li class="pt10">
							<dt>제목</dt>
							<dd class="pr20 pb10">
								<input type="text"style="width:70%;" name="title" id="title" placeholder="제목을 입력해주세요."/>
							</dd>
						</li>
						<li>
							<dt>내용</dt>
							<dd class="pr20 pb10">
								<textarea style="width:100%; height:230px" name="content" id="content"></textarea>
							</dd>
						</li>
						<li style="width:100%">
							<dt>첨부파일</dt>
							<dd class="pb20">
								<div class="form-group form_file">
									<input class="form-control form_point_color01" type="text" title="첨부된 파일명" readonly="readonly" style="width:200px">
									<span class="file_load" id="fileSpan1">
										<input type="file" name="files" id="file1" value="" onChange="javaScript:addFile(tmpNo)" /><label class="btn-default" for="file1">파일첨부</label>
									</span>	
									<span id="upFile"></span>
									<ul class="view_list_file" style="background-color:#fafafa !important;" id="filelist">
									</ul>
								</div>
							</dd>	 
						</li>		
					</ul>
				</div>
				<div class="btn_box_con" >
					<input type="button" value="저장" class="btn_admin_red" onclick="noticeRegist(); return false;"> 
					<input type="button" value="목록"  class="btn_admin_gray" onclick="goNoticeList(); return false;">
				</div>
			</div>
		</section> -->
			<div class="wrap_in" id="fixNextTag">
				<span class="path">문의 사항&nbsp;&nbsp;<img src="../resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;게시판&nbsp;&nbsp;<img src="../resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;<a href="#">${strUtil:getSystemName()}</a></span>
				<section class="type01">
				<h2 style="position:relative"><span class="title_s">Q&A</span>
	<span class="title">문의사항 작성</span>
	<div  class="top_btn_box">
			<ul>
					<li><button class="btn_circle_nomal" onClick="goNoticeList(); return false;">&nbsp;</button></li>
			
			</ul>

	</div>
	</h2>
		<div class="group01" >
	<div class="title"><!--span class="txt">연구개발시스템 공지사항</span--></div>
	<div class="list_detail">
				<ul>
				<li class="pt10">
					<dt>제목</dt>
						<dd class="pr20 pb10">
						<input type="text" style="width:70%;" placeholder="제목을 입력해주세요."  name="title" id="title"/>
						</dd>
					</li>
					
			<li>
					<dt>내용</dt>
						<dd class="pr20 pb10">
								<textarea name="contentTemp" id="contentTemp" style="width:100%; height:300px"></textarea>
						</dd>
		</li>
<!-- 		<li>
			<dt>파일 첨부</dt>
				<dd>
			
							<div class="form-group form_file" style="padding-bottom:10px;">
									<input class="form-control form_point_color01" type="text" title="첨부된 파일명" readonly="readonly" style="width:400px">
									<span class="file_load" id="fileSpan1"><input type="file" name="files" id="file1" value="" onChange="javaScript:addFile(tmpNo)"><label class="btn-default" for="file1" style="margin-top:-1px;">파일첨부</label></span>
									<span id="upFile"></span>	
							</div>
				</dd>
			</li> -->
			<!--  첨부된 파일리스트 start 첨부된 파일이 없을 경우 안보이게 해주세요 -->
<!-- 			<li class=" mb5">
			<dt >파일리스트 </dt><dd>
				<div class="file_box_pop"style=" height:100px; width:97.5%;" >
					<ul id="fileList">

					</ul>
			</div>
			</dd>
			</li> -->
			<li class="mt5">
			<dt>첨부파일</dt>
<!-- 첨부파일 최대 3개까지 -->
<dd><!-- 첨부파일이 하나도 없을때는 add_file2 / 하나라도 생성되면 add_file 로 클래스명 교체해주세요-->
			<div class="add_file2" id="add_file2" style="width:97.5%">
				<span class="file_load" id="fileSpan1">
						<input type="file" name="files" id="file1"  value="" onChange="javaScript:addFile(tmpNo)" style="display:none"><label for="file1">첨부파일 등록 <img src="/resources/images/icon_add_file.png"></label>
				</span>
				<span id="upFile"></span>
			</div>
			<!--  첨부된 파일리스트 start 첨부된 파일이 없을 경우 안보이게 해주세요 -->

					<div id="fileList" class="file_box_pop" style=" height:59px; width:97.5%; border-top-left-radius:0px;border-top-right-radius:0px; border-top:1px solid #ddd;box-sizing:border-box;" >
							<ul id="fileData">
									<!-- <li> <a href="11.html"><img src="/resources/images/icon_del_file.png"></a> asdfkasdflkj;a동그라미 첨부파일 .png </li>
									<li> <a href="11.html"><img src="/resources/images/icon_del_file.png"></a> asdfk그라미 첨부파일 .png</li>
									<li> <a href="11.html"><img src="/resources/images/icon_del_file.png"></a> asdfkasdflkj;a동그라미 첨부파일 .png </li>
									<li> <a href="11.html"> <img src="/resources/images/icon_del_file.png"></a> asdfkasdflkj;a동그라미 첨부파일 .png </li>
									<li> <a href="11.html"> <img src="/resources/images/icon_del_file.png"></a> asdfk그라미 첨부파일 .png</li>
									<li> <a href="11.html"> <img src="/resources/images/icon_del_file.png"></a> asdfkasdflkj;a동그라미 첨부파일 .png </li>
									<li> <a href="11.html"> <img src="/resources/images/icon_del_file.png"></a> asdfkasdflkj;a동그라미 첨부파일 .png </li>
									<li> <a href="11.html"> <img src="/resources/images/icon_del_file.png"></a> asdfk그라미 첨부파일 .png</li> -->
							</ul>
					</div>
					<!--  첨부된 파일리스트 close 첨부된 파일이 없을 경우 안보이게 해주세요 -->
</dd>
			</li>
<!--  첨부된 파일리스트 close 첨부된 파일이 없을 경우 안보이게 해주세요 -->
					</ul>
			</div>
			
				<div class="btn_box_con5">
			</div>
			<div class="btn_box_con4"> <button class="btn_admin_sky" onClick="noticeRegist(); return false;">작성 완료</button></div>
			 <hr class="con_mode"/><!-- 신규 추가 꼭 데려갈것 !-->
			</div>
			</section>
		</div>
	</form>
</html>