<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page session="false" %>
<script type="text/javascript" src='<c:url value="/resources/js/jquery-3.3.1.js"/>'></script>
<script type="text/javascript" src='<c:url value="/resources/js/jquery.form.js"/>'></script>
<script type="text/javascript" src='<c:url value="/resources/js/jquery.selectboxes.js"/>'></script>
<script type="text/javascript">
	//작성페이지 이동
	function goCreate(){
		if(  !chkNull($("#company").selectedValues()[0]) ) {
			alert("회사를 선택해 주세요.");
			$("#company").focus();
			return;
		} else if( !chkNull($("#sapCode").val()) ) {
			alert("자재코드 입력하여 주세요.");
			$("#sapCode").focus();
			return;
		} else {
			var URL = "../material/rfcCallAjax";
			$.ajax({
				type:"POST",
				url:URL,
				data:{"company":$("#company").selectedValues()[0], "sapCode":$("#sapCode").val()},
				dataType:"json",
				async:false,
				success:function(result) {
					if(result.status == 'success'){
						$("#sapCode").val("");
			        	alert("등록되었습니다.");	
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
<title>자재호출</title>
<form>
	<table>
		<tr>
			<td>회사</td>
			<td>
				<select name="company" id="company">
					<option value="">==선택하세요==</option>
				<c:forEach items="${company}" var="company">
					<option value="${company.companyCode}">${company.companyName}</option>
				</c:forEach>
				</select>
			</td>
		</tr>
		<tr>
			<td>자재코드</td>
			<td>
				<input type="text" name="sapCode" id="sapCode" value="">
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<button type="button" class="btn_con_search" onclick="goCreate();">ERP 호출</button>
			</td>
		</tr>
	</table>
</form>