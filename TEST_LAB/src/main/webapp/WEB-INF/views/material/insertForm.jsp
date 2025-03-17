<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page session="false" %>
<script type="text/javascript" src='<c:url value="/resources/js/jquery-3.3.1.js"/>'></script>
<script type="text/javascript" src='<c:url value="/resources/js/jquery.form.js"/>'></script>
<script type="text/javascript" src='<c:url value="/resources/js/jquery.selectboxes.js"/>'></script>
<script type="text/javascript">
	var PARAM = {
		isSample: '${paramVO.isSample}',
		plantCode: '${paramVO.plantCode}',
		searchType: '${paramVO.searchType}',
		searchValue: '${paramVO.searchValue}',
		pageNo: '${paramVO.searchValue}'
	};
	
	function companyChange() {
		var URL = "../common/plantListAjax";
		$.ajax({
			type:"POST",
			url:URL,
			data:{
				"companyCode" : $("#company").selectedValues()[0]
			},
			dataType:"json",
			async:false,
			success:function(data) {
				var list = data.RESULT;
				$("#plant").removeOption(/./);
				$.each(list, function( index, value ){ //배열-> index, value
					$("#plant").addOption(value.plantCode, value.plantName, false);
				});
				
			},
			error:function(request, status, errorThrown){
					alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
			}			
		});
	}

	//입력확인
	function goInsrt(){
		if( !chkNull($("#name").val()) || $("#name").val() == "[임시]" ) {
			alert("자재명을 입력하여 주세요.");
			$("#name").focus();
			return;
		} else if ($("#name").val().indexOf("[임시]") == -1) {
			alert("자재명은 [임시]를 포함해야 합니다.");
			$("#name").val("[임시]"+$("#name").val());
			$("#name").focus();			
			return;
		} else if( !chkNull($("#sapCode").val()) ) {
			alert("SAP 코드를 입력하여 주세요.");
			$("#sapCode").focus();
			return;
		} else if( $("#company").selectedValues()[0] == '' ) {
			alert("회사를 선택하여 주세요.");
			$("#company").focus();
			return;
		} else if( $("#plant").selectedValues()[0] == '' ) {
			alert("공장을 선택하여 주세요.");
			$("#plant").focus();
			return;
		} else if( !chkNull($("#price").val()) ) {
			alert("단가를 입력하여 주세요.");
			$("#price").focus();
			return;
		} else if( $("#unit").selectedValues()[0] == '' ) {
			alert("단위를 선택하여 주세요.");
			$("#unit").focus();
			return;
		} else if( $("#type").selectedValues()[0] == '' ) {
			alert("구분을 선택하여 주세요.");
			$("#type").focus();
			return;
		} else {
			var URL = "../material/materialCountAjax";
			$.ajax({
				type:"POST",
				url:URL,
				data:{"sapCode":$("#sapCode").val(),"company": $("#company").selectedValues()[0],"plant": $("#plant").selectedValues()[0]},
				dataType:"json",
				success:function(result) {
					if( result.RESULT >= 1) {
						alert("이미 존재하는 SAP코드입니다.");
					    return;
					} else {
						document.insertForm.action = "../material/insert";
						document.insertForm.submit();			
					}
				},
				error:function(request, status, errorThrown){
					alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
				}			
			});	
		}
	}
	function goList() {
		location.href = '../material/list?' + $.param(PARAM);
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
	
	//숫자 + 도트만  입력 가능
	function clearNoNum(obj){
		var needToSet = false;
		var numStr = obj.value;
		var temps = numStr.split("."); //소수점 체크를 위해 입력값을 '.'을 기준으로 나누고 temps는 배열이됨
		var CaretPos = doGetCaretPosition(obj); //input field에서의 캐럿의 위치를 확인
		if(2 < temps.length){ //배열 사이즈가 2보다 크면, '.' 가 두개 이상인 경우임.
			var tempIdx = 0;
			numStr = "";
			for(i=0;i<temps.length;i++) {
				numStr += temps[i];   //최종 문자에 현재 스트링을 합한다.
			}
			needToSet = true;
			alert("소수점은 두개이상 입력 하시면 안됩니다.");
		} 
		if((/[^\d.]/g).test(numStr)) {  //숫자 '.'  이외 엔 없는지 확인 후 있으면 replace
			numStr = numStr.replace(/[^\d.]/g,"");
			CaretPos--;
			alert("입력은 숫자와 소수점 만 가능 합니다.");('.')
			needToSet = true;
		} 
		if ((/^\./g).test(numStr)){ //첫번째가 '.' 이면 .를 삭제
			numStr = numStr.replace(/^\./g, "");
			alert("소수점이 첫 글자이면 안됩니다.");
			needToSet = true;
		}
		if(needToSet) { //변경이 필요할 경우에만 셋팅함.
			obj.value = numStr;
			setCaretPosition(obj, CaretPos)
		}
	}
	
	//숫자만 입력 가능
	function clearNoNumNoDot(obj){
		var needToSet = false;
		var numStr = obj.value;
		var CaretPos = doGetCaretPosition(obj); //input field에서의 캐럿의 위치를 확인
		if((/[^\d]/g).test(numStr)) {  //숫자 '.'  이외 엔 없는지 확인 후 있으면 replace
			numStr = numStr.replace(/[^\d]/g,"");
			CaretPos--;
			alert("입력은 숫자와 소수점 만 가능 합니다.");('.')
			needToSet = true;
		} 
		if(needToSet) { //변경이 필요할 경우에만 셋팅함.
			obj.value = numStr;
			setCaretPosition(obj, CaretPos)
		}
	}
	
	//input field에서의 캐럿의 위치를 리턴함.
	function doGetCaretPosition (ctrl){
		var CaretPos = 0;
		if (document.selection){//IE
			ctrl.focus ();
			var Sel = document.selection.createRange ();
			Sel.moveStart ('character', -ctrl.value.length);
			CaretPos = Sel.text.length;
		}else if (ctrl.selectionStart || ctrl.selectionStart == '0'){// Firefox support
			CaretPos = ctrl.selectionStart;
		}
		return (CaretPos);
	}
	
	//input field에 캐럿의 위치를 지정함.
	function setCaretPosition(ctrl, pos){
		if(ctrl.setSelectionRange){
			ctrl.focus();
			ctrl.setSelectionRange(pos,pos);
		}else if (ctrl.createTextRange){
			var range = ctrl.createTextRange();
			range.collapse(true);
			range.moveEnd('character', pos);
			range.moveStart('character', pos);
			range.select();
		}
	}
</script>	
	<title>자재생성</title>
	<form name="insertForm" method="post">
		<table>
			<tr>
				<td>자재명</td>
				<td>
					<input type="text" name="name" id="name" value="[임시]">
					"[임시]"로 시작 하도록 입력 해 주십시요. 
				</td>
			</tr>
			<tr>
				<td>SAP 코드</td>
				<td>
					<input type="text" name="sapCode" id="sapCode" value="">
					임시 코드 5자리를 입력 해 주십시요. 	
				</td>
			</tr>
			<tr>
				<td>공장</td>
				<td>
					<select name="company" id="company" onChange="companyChange()">
						<option value="">==선택하세요==</option>
						<c:forEach items="${company}" var="company">
							<option value="${company.companyCode}">${company.companyName}</option>
						</c:forEach>
					</select>
					&nbsp;&nbsp;
					<select name="plant" id="plant">
						<option value="">==선택하세요==</option>						
					</select>
					공장코드와 관계없이 조회 가능합니다. 
				</td>
			</tr>
			<tr>
				<td>단가</td>
				<td><input type="text" name="price" id="price" value=""></td>
			</tr>
			<tr>
				<td>단위</td>
				<td>
					<select name="unit" id="unit">
						<option value="">==선택하세요==</option>
						<c:forEach items="${unit}" var="unit">
							<option value="${unit.unitCode}">${unit.unitName}</option>
						</c:forEach>
					</select>					
				</td>
			</tr>
			<tr>
				<td>구분</td>
				<td>
					<select name="type" id="type">
						<option value = "">선택하세요</option>
						<option value="B">원료</option>
						<option value ="R">재료</option>
					</select>
				</td>
			</tr>
		</table>
		<div class="btn_box_con">
			<button type="button" class="btn_admin_red" onclick="javascript:goInsrt();">저장</button> 
			<button type="button" class="btn_admin_gray" onclick="javascript:goList();">목록</button>
		</div>
	</form>