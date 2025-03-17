<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page session="false" %>
	<title>공지사항</title>
<script type="text/javascript">
	
	$(document).ready(function(){
	
		var targetIdArr = '${targetIdArr}';
		
	})
	
	function goPopupCancel(){
		
		window.parent.document.getElementById("#keyword");
		
		window.close();
	}

	function approvalLineSave(){
		if($("#approvalLineName").val() == ""){
			alert("결재선 이름을 입력하세요.");
			$("#approvalLineName").focus();
			return;
		}
		
		var lineName = $("#approvalLineName").val();
		
		if(confirm("저장하시겠습니까?")){
			location.href = "/approval/approvalLineSave?lineName="+lineName+"&tbType="+'${tbType}'+"&apprTypeArr="+'${apprTypeArr}'+"&targetIdArr="+'${targetIdArr}';
		}
	}
</script>

<jsp:useBean id="toDay" class="java.util.Date" />
	<span class="path">
		공지사항&nbsp;&nbsp;<img src="../resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;
		<a href="#">파리크라상 식품기술 연구개발시스템</a>
	</span>
	<section class="type01">


		<div class="group01" >
			<div class="main_tbl" style="bottom:0; position:absolute;">
				<table class="tbl01"  cellpadding="0" cellspacing="0" border="1" style="width: 100%; border-top: none; border-bottom: none;">
					<tr>
						<th style="width: 150px;">결재선 이름</th>
						<td style="width: 350px;"><input id="approvalLineName" type="text" style="width: 250px;" > </td>
					</tr>
				</table>
				<div style=" padding:10px 0 0 0; text-align:right;">
					<button type="button" class="btn2" onClick="approvalLineSave();" type="submit">저장</button>
					<span class="b-close">
					<button type="button" class="btn3" onClick="goPopupCancel();">취소</button>
				</div>
			</div>
		</div>
	</section>


