<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
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
	var PARAM = {
		searchType: '${paramVO.searchType}',
		searchValue: '${paramVO.searchValue}'
	};
	
	function stepchage(id,step){document.getElementById("width_wrap").className = step;}
	
	//공지사항 수정
	function modifyFaq(){
		if(confirm("수정하시겠습니까? ")){

			$('#modifyFaqForm').ajaxForm({
	            beforeSubmit: function (data,form,option) {
	                //validation체크 
	                //막기위해서는 return false를 잡아주면됨
	                return true;
	            },
	            success: function(response,status){
	            	if(status == 'success'){
	                	//성공후 서버에서 받은 데이터 처리
	                	alert("수정되었습니다.");
	                	location.href = '/faqNotice/FaqnoticeList?pageNo='+'${paramVO.pageNo}'+"&keyword="+encodeURI(encodeURIComponent('${paramVO.keyword}'))+'&searchName='+encodeURI(encodeURIComponent('${paramVO.searchName}'));
	            	} else {
	            		alert('수정실패하였습니다.');
	            	}
	            },
	            error: function(){
	                //에러발생을 위한 code페이지
	            	alert("오류가 발생하였습니다.");
	            }                               
	        }).submit();
		}
	}
	
	function deleteNotice(no){
		if(confirm("삭제하시겠습니까? ")){
			var URL = "/faqNotice/FaqNoticeDelete";
			$.ajax({
				type:"POST",
				url:URL,
				data:{"nNo":no,
					  "tbType":"faq"},
				dataType:"json",
				success:function(data) {
					if(data.status == 'success'){
			        	alert("삭제되었습니다.");	
			        	location.href = '/faqNotice/FaqnoticeList?pageNo='+'${paramVO.pageNo}'+"&keyword="+encodeURI(encodeURIComponent('${paramVO.keyword}'))+'&searchName='+encodeURI(encodeURIComponent('${paramVO.searchName}'));
			        } else if( data.status == 'fail' ){
						alert("오류 발생");
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
	
	var tmpNo = 1;
	
	function addFile(fileIdx) {
		var filePath = document.getElementById("file"+fileIdx).value;
		var fileName = filePath.substring(filePath.lastIndexOf('\\') + 1,	filePath.length);
		if (fileName.length == 0) {
			alert("파일을 선택해 주십시요.");
			return;
		}
		// 파일 추가
		$("#fileSpan"+fileIdx).hide();
		tmpNo = ++fileIdx;
		var html = "";
		html += "<span class=\"file_load\" id=\"fileSpan" + fileIdx + "\">";
		html += "	<input type='file' name='files' id='file" + fileIdx + "' onChange=\"javaScript:addFile(tmpNo)\">";
		html += "	<label class=\"btn-default\" for=\"file" + fileIdx + "\">파일첨부</label>";
		html += "</span>"
		//$("#upFile").append("<span class=\"file_load\" id=\"fileSpan" + fileIdx + "\"><input type='file' name='file' id='file" + fileIdx + "' onChange=\"javaScript:addFile(tmpNo)\"><label class=\"btn-default\" for=\"file" + fileIdx + "\">파일첨부</label></span>");
		$("#upFile").append(html);
		html = "";
		html += "<li style='width:100%;'>";
		html += "	<span id='selfile" + fileIdx 	+ "'>";
		html += "		<a href='#'>"+ fileName + "</a>";
		html += "		<button class=\"btn_table_nomal\" type=\"button\" onClick='javascript:deleteFile(this)'>";
		html += "			<img src=\"../resources/images/icon_del.png\">삭제";
		html += "		</button>";
		html += "	</span>";
		html += "</li>"
		$("#filelist").append(html);
	}
	
	//추가 파일 삭제 함수
	function deleteFile(e){
		var fileSpanId = $(e).parent().attr("id");
		var fileIndex = fileSpanId.slice(7);
		var fileId = "file"+fileIndex;
		var fileNo = fileIndex - 1;
		$(e).parent().parent().remove();
		$("#file"+ fileNo).remove();
		return;
	}
	
	//추가 파일 삭제 함수 - 기존 목록
	function deleteFileList(e){
		
		var fileDelete = $(e).siblings("input[name=fileDeleteInput]").val();
		
		$("#hidden").append("<input type='hidden' name='fileDelete' value='"+fileDelete+"'/>");
		
		var fileSpanId = $(e).parent().attr("id")+"list";
		var fileIndex = fileSpanId.slice(7);
		var fileId = "file"+fileIndex;
		var fileNo = fileIndex - 1;
		$(e).parent().parent().remove();
		$("#file"+ fileNo).remove();
		return;
	}
	
	function goFaqList(){
		location.href = '/faqNotice/FaqnoticeList?pageNo='+'${paramVO.pageNo}'+"&keyword="+encodeURI(encodeURIComponent('${paramVO.keyword}'))+'&searchName='+encodeURI(encodeURIComponent('${paramVO.searchName}'));
	}
	
</script>

<form name="modifyFaqForm" id="modifyFaqForm" method="post" enctype="multipart/form-data" action = "/faqNotice/modifyFaqNoticeAjax">
	<%-- <input type="hidden" id="nNo"name="nNo" value="${data1.nNo }">
	<span class="path">
	공지사항 작성&nbsp;&nbsp;<img src="../resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;
	<a href="#">파리크라상 식품기술 연구개발시스템</a>
	</span>
	<section class="type01">
		<h2 style="position:relative">
		<span class="title_s">Notice Doc</span>
		<span class="title">공지사항 수정</span>
		<div class="top_btn_box">
			<ul>
				<li>
					<input type="button" onclick="goNoticeList(); return false;"  class="btn_circle_nomal">&nbsp;</input>
				</li>
			</ul>
		</div>
		</h2>		
		<div class="group01" >
			<div class="title"><!--span class="txt">연구개발시스템 공지사항</span--></div>
			<div class="notice_title">
				<span class="font04">제목 :&nbsp;<input type="text"style="width:500px; border-radius: 5px; background-color: #ffffff; border: 1px solid #c5c5c5; padding: 3px 5px 5px 5px; box-sizing: border-box;" name="title" id="title" value="${data1.title }"/></span><br>
				<span class="font18">작성자 :  ${data1.userName }<strong>&nbsp;|&nbsp;</strong> 작성일 :   ${fn:substring(data1.regDate,0,19)}</span>
			</div>
			<div class="main_tbl">
				<ul class="notice_view">
					<li>
						<div class="text_view">
							<textarea style="width:100%; height:260px;" name="contents" id="contents" >${data1.content }</textarea>
						</div>
						<li style="margin-left:30px;">
							<dt>첨부파일</dt>
							<dd>
								<div class="form-group form_file">
									<input class="form-control form_point_color01" type="text" title="첨부된 파일명" readonly="readonly" style="width:200px">
									<span class="file_load" id="fileSpan1">
										<input type="file" id="file1" name="files" value="" onChange="javaScript:addFile(tmpNo)" /><label class="btn-default" for="file1">파일첨부</label>
									</span>	
									<span id="upFile"></span>
									<ul class="view_list_file" id="filelist">
									</ul>
								</div>
							</dd>	 
						</li>
						<div id="hidden" style="display:none"></div>
						<ul class="view_list_file" id="filelist">
							<c:forEach items="${FaqfileNames}" var="item" varStatus="status">
								<li>
									<span id='selfile${(status.count+1) }list'>
										<input type="hidden" name="fileDeleteInput" value="${item.fmNo }">${item.fileName}
										<button class="btn_table_nomal" type="button" onClick='javascript:deleteFileList(this);'> 
											<img src="../resources/images/icon_del.png">삭제
										</button>
									</span>
								</li>
							</c:forEach>
						</ul>
					</li>
				</ul>
			</div>
			<div class="btn_box_con" >
				<input type="button" value="수정" class="btn_admin_red" onclick="modifyNotice(); return false;"> 
				<input type="button" value="삭제"  class="btn_admin_gray" onclick="deleteNotice('${data1.nNo}'); return false;">
			</div>			
		</div>
	</section> --%>
		<div class="wrap_in" id="fixNextTag">
			<input type="hidden" id="nNo"name="nNo" value="${data1.nNo }">
			<span class="path">자주 하는 질문&nbsp;&nbsp;<img src="../resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;게시판&nbsp;&nbsp;<img src="../resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;<a href="#">${strUtil:getSystemName()}</a></span>
			<section class="type01">
			<h2 style="position:relative"><span class="title_s">FAQ</span>
			<span class="title">자주 하는 질문 수정</span>
			<div class="top_btn_box">
				<ul>
					<li><button class="btn_circle_nomal" onclick="goFaqList(); return false;">&nbsp;</button></li>
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
						<input type="text" style="width:70%;" placeholder="제목을 입력해주세요." name="title" id="title" value="${data1.title}"/>
						</dd>
				</li>
				<li>
					<dt>작성자</dt>
					<dd class="pr20 pb10">
						${data1.userName}
					</dd>
				</li>			
				<li>
					<dt>작성일</dt>
					<dd class="pr20 pb10">
						${fn:substring(data1.regDate,0,19)}
					</dd>
				</li>
				<li>
					<dt>내용</dt>
						<dd class="pr20 pb10">
						<textarea style="width:100%; height:300px" name="contents" id="contents">${fn:replace(data1.content,br,crcn)}</textarea>
						</dd>
				</li>
			</ul>
			</div>
				<div class="btn_box_con5">
			</div>
			<div class="btn_box_con4"> <button class="btn_admin_sky"onClick="modifyFaq(); return false;">수정</button></div>
			 <hr class="con_mode"/><!-- 신규 추가 꼭 데려갈것 !-->
			</div>
				</section>
		</div>
</form>

