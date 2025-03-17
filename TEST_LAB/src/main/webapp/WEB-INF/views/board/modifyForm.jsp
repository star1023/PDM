<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ page session="false"%>

<link href="css/common.css" rel="stylesheet" type="text/css" />
<link href="css/board.css" rel="stylesheet" type="text/css" />
<link href="css/layout.css" rel="stylesheet" type="text/css" />

<script type="text/javascript">
	var deleteFmNo = [];
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

		fileListCheck();
	});

	function stepchage(id, step) {
		document.getElementById("width_wrap").className = step;
	}

	function registPost() {

		if ($('#title').val() == '') {
			alert('제목을 입력해 주세요.');
			$('#title').focus();
			return false;
		}
		if ($('#contentTemp').val() == '') {
			alert('내용을 입력해 주세요.');
			$('#contentTemp').focus();
			return false;
		}
		
		var deleteFileInput = '<input type="hidden" name="deleteFmNoArr" value="'+deleteFmNo.toString()+'">'
		$('#modifyPostForm').append(deleteFileInput);

		$('#modifyPostForm').ajaxForm({
			beforeSubmit : function(data, form, option) {
				//validation체크 
				//막기위해서는 return false를 잡아주면됨
				return true;
			},
			success : function(response, result) {
				console.log(response);
				console.log(result)
				if (response.status == 'success') {
					//성공후 서버에서 받은 데이터 처리
					alert("글이 등록되었습니다.");
					location.href = "/board/labNotice";
				} else {
					alert('등록 실패 - ' + response.msg);
				}
			},
			error : function() {
				//에러발생을 위한 code페이지
				alert("오류가 발생하였습니다.");
			}
		}).submit();
	}

	function goBoard() {
		location.href = "/board/labNotice";
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
	function deleteFile(e) {
		var fileSpanId = $(e).parent().attr("id");
		var fileIndex = fileSpanId.slice(7);
		var fileId = "file" + fileIndex;
		var fileNo = fileIndex - 1;
		$(e).parent().remove();
		$("#file" + fileNo).remove();
		$("#fileSpan" + fileNo).remove();
		fileListCheck();
		return;
	}

	function fileListCheck() {
		var nodes = $("#fileData").children();
		if (nodes.length > 0) {
			$("#add_file2").prop("class", "add_file");
			$("#fileList").show();
		} else {
			$("#add_file2").prop("class", "add_file2");
			$("#fileList").hide();
		}
	}
	
	function addDeleteFile(e, fmNo){
		$(e.target).parent().parent().remove();
		deleteFmNo.push(fmNo);
	}
</script>
<form id="modifyPostForm" name="noticeRegistForm" method="post" enctype="multipart/form-data" action="/board/modifyPost">
	<input type="hidden" name="type" value="${type}">
	<input type="hidden" name="typeText" value="${typeText}">
	<input type="hidden" name="nNo" value="${postDetail.nNo}">

	<div class="wrap_in" id="fixNextTag">
		<span class="path">게시글 수정&nbsp;&nbsp;<img src="../resources/images/icon_path.png" style="vertical-align: middle" />&nbsp;&nbsp;${typeText} 게시판&nbsp;&nbsp;<img src="../resources/images/icon_path.png" style="vertical-align: middle" />&nbsp;&nbsp;게시판&nbsp;&nbsp;<img src="../resources/images/icon_path.png" style="vertical-align: middle" />&nbsp;&nbsp;<a href="#">${strUtil:getSystemName()}</a></span>
		<section class="type01">
			<h2 style="position: relative">
				<span class="title_s">Modify Post</span> <span class="title">게시글 수정</span>
				<div class="top_btn_box">
					<ul>
						<li><button class="btn_circle_nomal" onclick="goNoticeList(); return false;">&nbsp;</button></li>
					</ul>
				</div>
			</h2>
			<div class="group01">
				<div class="title"><!--span class="txt">연구개발시스템 공지사항</span--></div>
				<div class="list_detail">
					<ul>
						<li class="pt10">
							<dt>제목</dt>
							<dd class="pr20 pb10">
								<input type="text" style="width: 70%;" placeholder="제목을 입력해주세요." name="title" id="title" value="${postDetail.title}"/>
							</dd>
						</li>
						<li>
							<dt>내용</dt>
							<dd class="pr20 pb10">
								<textarea style="width: 100%; height: 300px" name="contentTemp" id="contentTemp">${strUtil:getHtml(fn:replace(postDetail.content,br,crcn))}</textarea>
							</dd>
						</li>
						<li class="mt5">
							<dt>첨부파일</dt> <!-- 첨부파일 최대 3개까지 -->
							<dd>
								<!-- 첨부파일이 하나도 없을때는 add_file2 / 하나라도 생성되면 add_file 로 클래스명 교체해주세요-->
								<div class="add_file2" id="add_file2" style="width: 97.5%">
									<span class="file_load" id="fileSpan1">
										<input type="file" name="files" id="file1" value="" onChange="javaScript:addFile(tmpNo)" style="display: none"><label for="file1">첨부파일 등록 <img src="/resources/images/icon_add_file.png"></label>
									</span>
									<span id="upFile"></span>
								</div>
								<!--  첨부된 파일리스트 start 첨부된 파일이 없을 경우 안보이게 해주세요 -->

								<div id="fileList" class="file_box_pop" style="height: 59px; width: 97.5%; border-top-left-radius: 0px; border-top-right-radius: 0px; border-top: 1px solid #ddd; box-sizing: border-box;">
									<ul id="fileData">
										<c:forEach items="${fileList}" var="file" varStatus="status">
											<li><input type='hidden' name='files' value="${file.fmNo}"/><a href='#' onClick="addDeleteFile(event, '${file.fmNo}')"><img src="/resources/images/icon_del_file.png"></a> ${file.orgFileName}</li>
										</c:forEach>
									</ul>
								</div>
								<!--  첨부된 파일리스트 close 첨부된 파일이 없을 경우 안보이게 해주세요 -->
							</dd>
						</li>
						<!--  첨부된 파일리스트 close 첨부된 파일이 없을 경우 안보이게 해주세요 -->
					</ul>
				</div>

				<div class="btn_box_con5"></div>
				<div class="btn_box_con4">
					<button class="btn_admin_sky" onClick="registPost(); return false;">작성 완료</button>
				</div>
				<hr class="con_mode" />
				<!-- 신규 추가 꼭 데려갈것 !-->
			</div>
		</section>
	</div>
</form>
