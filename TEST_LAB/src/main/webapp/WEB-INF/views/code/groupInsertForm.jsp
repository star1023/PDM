<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ page session="false" %>
<script type="text/javascript">
function insertProc(){
 	if ( !chkNull($("#groupCode").val()) ) {
        alert('그룹코드를 입력하세요.');
        $("#groupCode").focus();
        return;
    } else if ( !chkNull($("#groupName").val()) ) {
        alert('그룹코드명을 입력하세요.');
        $("#groupName").focus();
        return;
    } else if ( !chkNull($("#description").val()) ) {
        alert('그룹코드 설명을 입력하세요.');
        $("#description").focus();
        return;
    } else {
    	var URL = "../code/gruopInsertAjax";
		$.ajax({
			type:"POST",
			url:URL,
			data:{"groupCode":$("#groupCode").val(),"groupName":$("#groupName").val(),"description":$("#description").val()},
			dataType:"json",
			async:false,
			success:function(result) {
				if(result.status == 'success'){
		        	clear();
		        	alert("등록되었습니다.");	
		        	opener.loadGroupList();
		        } else if( result.status == 'fail' ){
					alert(result.msg);
		        } else {
		        	alert("오류가 발생하였습니다.");
		        }
			},
			error:function(request, status, errorThrown){
				alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
			}			
		});
    }	
}

function clear() {
	$("#groupCode").val("");
	$("#groupName").val("");
	$("#description").val("");
}

// 그룹코드 대문자로
function toUpper(obj){
	var str = obj.value;
	obj.value = str.toUpperCase();
}

function chkNull(ObjSrc) {
	var str = ObjSrc;
	var blank_flg = false;
	if(str == null || str == "") return false;
		for(cnt=0;cnt<str.length;cnt++) {
			if( str.charAt(cnt) != " "){
				blank_flg = true;
			}
			}
		if(!blank_flg) return false;
		return true;
}
</script>
<title>코드관리</title>
<form name="insertForm" id="insertForm" method="post">
	<h2 style="position:relative">
		<span class="title">
			<img src="../resources/images/bg_bs_box_fast02.png">&nbsp;&nbsp;코드그룹 관리
		</span>
	</h2>
	<div  class="top_btn_box">
		<ul>
			<li><button type="button" class="btn_pop_close" onClick="javascript:self.close();"></button></li>
		</ul>
	</div>
	<div class="main_tbl">
		<div class="insert_obj" style="padding-top:0;">
			<div class="insert_input_box ">
				<ul>
					<li style="width:100%">
						<dt style="width:30%">그룹코드</dt>
						<dd style="width:70%">
							<input type="text" style="width:85%;" class="req" name="groupCode" id="groupCode" onkeyup="toUpper(this);"/>
						</dd>
					</li>
					<li style="width:100%">
						<dt style="width:30%">그룹코드명</dt>
						<dd style="width:70%">
							<input type="text" style="width:85%;"class="req" name="groupName" id="groupName"/>					
						</dd>
					</li>
					<li style="width:100%">
						<dt style="width:30%">그룹코드 설명</dt>
						<dd style="width:70%">
							<input type="text" style="width:85%;"class="req" name="description" id="description"/>
						</dd>
					</li>					
				</ul>
			</div>
		</div>
		<div class="btn_box_con">
			<button type="button" class="btn_admin_red" onClick="javascript:insertProc()">저장</button>
			&nbsp;&nbsp;&nbsp;&nbsp;
		</div>
	</div>
	</form>