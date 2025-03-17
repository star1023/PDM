<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ page session="false" %>
<title>제품개발문서 담당자 변경</title>
<style>
.btn_remove{margin-top: 10px; background-image: url(/resources/images/bg_btn_s_reverse.png); background-repeat:no-repeat; background-position:bottom 0px;height:32px;  background-color:#d15b47; font-family:'맑은고딕',Malgun Gothic; font-size:14px; color:#fff; padding:0 20px 3px 30px; cursor:pointer; border:none; min-width:100px}
.btn_remove:hover{background-color:#e87663;}

.btn_add{background-image: url(/resources/images/bg_btn_s.png); background-repeat:no-repeat; background-position:right 0px; height:32px;  background-color:#00a0e9;; font-family:'맑은고딕',Malgun Gothic; font-size:14px; color:#fff;padding:0 30px 3px 20px;  cursor:pointer; border:none;min-width:100px}
.btn_add:hover{background-color:#27adea;}
</style>
<script type="text/javascript">
	$(document).ready(function(){
		$('button').keydown(function(e){
			e.preventDefault()
		})
	})
	function searchUserId( target ) {
		var deptCode = "";
		var teamCode = "";
		if( target == 'change' ) {
			deptCode = $("#deptCode").selectedValues()[0];
			teamCode = $("#teamCode").selectedValues()[0]
		} else {
			deptCode = $("#targetDeptCode").selectedValues()[0];
			teamCode = $("#targetTeamCode").selectedValues()[0]
		}
		if( deptCode == '' && teamCode == '' ) {
			if( target == 'change' ) {
				$("#userId").removeOption(/./);
				$("#userId").addOption("", "==선택하세요==", true);
				$('#changeList').html("");
			} else {
				$("#targetUserId").removeOption(/./);
				$("#targetUserId").addOption("", "==선택하세요==", true);
			}
		} else {
			$.ajax({
				type: 'post',
				url: '../../devdocManagement/searchUserId',
				data: {
					"deptCode" : deptCode,
					"teamCode" : teamCode
				},
				dataType: 'json',
				success: function (data) {
					var list = data;
					if( target == 'change' ) {
						$('#changeList').html("");
						$("#userId").removeOption(/./);
						$("#userId").addOption("", "==선택하세요==", true);
						$.each(list, function( index, value ){ //배열-> index, value
							$("#userId").addOption(value.userId, value.userId+"("+value.userName+")", false);
						});
					} else {
						$("#targetUserId").removeOption(/./);
						$("#targetUserId").addOption("", "==선택하세요==", true);
						$.each(list, function( index, value ){ //배열-> index, value
							$("#targetUserId").addOption(value.userId, value.userId+"("+value.userName+")", false);
						});
					}
				},error: function(XMLHttpRequest, textStatus, errorThrown){
					alert("에러발생");
				}
			});
		}
	}
	
	function userIdChange(){
		loadDevdoc();
	}
	
	function docTypeChange(){
		var docType = $("#docType").selectedValues()[0];
		
		initOptions();
		if( docType == 'D' ) {
			$('#designDocOptions').show();
			$('#devDocOptions').hide();
		} else {
			$('#devDocOptions').show();
			$('#designDocOptions').hide();
		}
		
		loadDevdoc();
	}
	
	function loadDevdoc() {
		var userId = $("#userId").selectedValues()[0];
		var docType = $("#docType").selectedValues()[0];
		var searchField;
		var searchValue;
		
		if( docType == 'D' ) {
			searchField = $('#designDocKeyword').val();
			searchValue = $('#designDocSearch').val();
		} else {
			searchField = $('#devDocKeyword').val();
			searchValue = $('#devDocSearch').val();
		}
		
		if( userId == '' ) {
			$('#changeList').html("");
		} else if( docType == '' ) {
			$('#changeList').html("");
		} else {
			var url = "../devdocManagement/devDocList";
			$.ajax({
				type: 'post',
				url: url,
				data: {
					"userId" : userId,
					"docType" : docType,
					"searchField" : searchField,
					"searchValue" : searchValue
				},
				dataType: 'json',
				success: function (data) {
					console.log(data)
					var list = data;
					var html = '';
					$('#changeList').html(html);
					if( list.length > 0 ) {
						if( docType == 'D' ) {
							html += "<tr>";
							html += "	<th>&nbsp;</th>";
							html += "	<th>회사</th>";
							html += "	<th>공장</th>";
							html += "	<th colspan='3'>제품명</th>";
							html += "</tr>";
						} else {
							html += "<tr>";
							html += "	<th>&nbsp;</th>";
							html += "	<th>제품코드</th>";
							html += "	<th>제품버젼</th>";
							html += "	<th>제품명</th>";
							html += "	<th>제품유형</th>";
							html += "	<th>작업상태</th>";						
							html += "</tr>";
						}
					}
					
					list.forEach(function (item) {
						if( docType == 'D' ) {
							html += "<tr>";
							html += "	<td><input type='checkbox' name='pNo' id='pNo"+item.pNo+"' value='"+item.pNo+"'><label for=\"pNo"+item.pNo+"\"><span></span></label></td>";
							html += "	<td>"+nvl(item.companyName,'')+"<input type='hidden' name='companyName' id='companyName' value='"+item.companyName+"'></td>";
							html += "	<td>"+nvl(item.plantName,'')+"<input type='hidden' name='plantName' id='plantName' value='"+item.plantName+"'></td>";
							html += "	<td colspan='3'>"+nvl(item.productName,'')+"<input type='hidden' name='productName' id='productName' value='"+item.productName+"'>";
							//html += "	<td colspan='2'>"+item.productCategoryName+"<input type='hidden' name='productCategoryName' id='productCategoryName' value='"+item.productCategoryName+"'>";
							html += "		<input type='hidden' name='regUserId' id='regUserId' value='"+item.regUserId+"'>"
							html += "		<input type='hidden' name='regUserName' id='regUserName' value='"+item.regUserName+"'>"
							html += "	</td>";
							html += "</tr>";
						} else {
							html += "<tr>";
							html += "	<td><input type='checkbox' name='docNo' id='docNo"+item.docNo+"' value='"+item.docNo+"'><label for=\"docNo"+item.docNo+"\"><span></span></label></td>";
							html += "	<td>"+nvl(item.productCode,'')+"<input type='hidden' name='productCode' id='productCode' value='"+item.productCode+"'></td>";
							html += "	<td>"+nvl(item.docVersion,'')+"<input type='hidden' name='docVersion' id='docVersion' value='"+item.docVersion+"'></td>";
							html += "	<td>"+nvl(item.productName,'')+"<input type='hidden' name='productName' id='productName' value='"+item.productName+"'></td>";
							//html += "	<td>"+nvl(item.productCategoryName,'')+"<input type='hidden' name='productCategoryName' id='productCategoryName' value='"+item.productCategoryName+"'>";
							html += "	<td>"+nvl(item.productType2Text,'')+"<input type='hidden' name='productType2Text' id='productType2Text' value='"+item.productType2Text+"'>";
							html += "		<input type='hidden' name='regUserId' id='regUserId' value='"+item.regUserId+"'>"
							html += "		<input type='hidden' name='regUserName' id='regUserName' value='"+item.regUserName+"'>"
							html += "</td>";
							var state = "";
							if( item.isClose == '1') {
								state = "제품중단";
							} else if( item.isClose == '2') {
								state = "보류";
							} else {
								if( parseInt(item.stateCnt4) > 0) {
									state = "제품출시";
								} else {
									if( parseInt(item.stateCnt1) > 0 ) {
										state = "결재완료";
									} else {
										state = "진행중";
									}
								}
							}
							html += "	<td>"+state+"<input type='hidden' name='state' id='state' value='"+state+"'></td>";
							html += "</tr>"
						}
						
					});
					$('#changeList').html(html);
				},error: function(XMLHttpRequest, textStatus, errorThrown){
					alert("에러발생");
				}
			});
		}
	}
	
	function add(type) {
		var nodes = $("#table1 > tbody").children('tr:gt(0)');
		var docType = $("#docType").selectedValues()[0];
		var cnt;
		
		if( docType == 'D' ) {
			cnt =  nodes.find("input[name=pNo]:checked").length;
		} else {
			cnt =  nodes.find("input[name=docNo]:checked").length;
		}
		
		if ( type == 'all'){
			type = nodes.length == 0 ? 'none' : type;
		}
		
		if( cnt > 0 || type == 'all') {
			nodes.each(function(){
				if( docType == 'D' ) {
					console.log($(this));
					if(type == 'all' || $(this).find("input[name=pNo]").is(':checked')) {
						var html = "";
						var pNo = $(this).find("input[name=pNo]").val();
						if( containSelectbox('target_pNo_sel',pNo) == 0 ) {
							$("#target_pNo_sel").addOption(pNo, pNo,false);
							html += "<tr>";
							html += "<td>";
							html += "<input type='checkbox' name='target_pNo' id='target_pNo"+$(this).find("input[name=pNo]").val()+"' value='"+$(this).find("input[name=pNo]").val()+"'><label for=\"target_pNo"+$(this).find("input[name=pNo]").val()+"\"><span></span></label>";
							html += "<input type='hidden' name='changePNo' id='changePNo' value='"+$(this).find("input[name=pNo]").val()+"'>";
							html += "</td>";
							html += "<td>제품설계서</td>";
							html += "<td>"+$(this).find("input[name=companyName]").val()+"</td>";
							html += "<td>"+$(this).find("input[name=plantName]").val()+"</td>";
							html += "<td>"+$(this).find("input[name=productName]").val()+"</td>";
							html += "<td>"+$(this).find("input[name=regUserName]").val()+"<input type='hidden' name='changePNoRegUserId' id='changePNoRegUserId' value='"+$(this).find("input[name=regUserId]").val()+"'>";
							html += "</td>";
							html += "</tr>";
							$('#targetList').append(html);
						} 
					}
				} else {
					if(type == 'all' || $(this).find("input[name=docNo]").is(':checked')) {
						var html = "";
						var docNo = $(this).find("input[name=docNo]").val();
						if( containSelectbox('target_docNo_sel',docNo) == 0 ) {
							$("#target_docNo_sel").addOption(docNo, docNo,false);
							html += "<tr>";
							html += "<td>";
							html += "<input type='checkbox' name='target_docNo' id='target_docNo"+$(this).find("input[name=docNo]").val()+"' value='"+$(this).find("input[name=docNo]").val()+"'><label for=\"target_docNo"+$(this).find("input[name=docNo]").val()+"\"><span></span></label>";
							html += "<input type='hidden' name='changeDocNo' id='changeDocNo' value='"+$(this).find("input[name=docNo]").val()+"'>";
							html += "</td>";
							html += "<td>제품개발문서</td>";
							html += "<td>"+$(this).find("input[name=productCode]").val()+"</td>";
							html += "<td>V."+$(this).find("input[name=docVersion]").val()+"</td>";
							html += "<td>"+$(this).find("input[name=productName]").val()+"</td>";
							html += "<td>"+$(this).find("input[name=regUserName]").val()+"<input type='hidden' name='changeDocNoRegUserId' id='changeDocNoRegUserId' value='"+$(this).find("input[name=regUserId]").val()+"'>";
							html += "</td>";
							html += "</tr>";
							$('#targetList').append(html);
						} 
					}
				}
				
			})
		} else {
			alert("추가할 항목을 선택하세요.");
		}
	}
	
	function deleData(type) {
		var nodes = $("#table2 > tbody").children();
		var cnt =  nodes.find("input[name=target_docNo]:checked").length+nodes.find("input[name=target_pNo]:checked").length;
		
		if(type == 'all'){
			type = nodes.length == 0 ? 'none' : type;
		}
		
		if( cnt > 0 || type == 'all') {
			nodes.each(function(){
				if(type == 'all' || $(this).find("input[name=target_docNo]").is(':checked')) {
					var html = "";
					var docNo = $(this).find("input[name=target_docNo]").val();
					$("#target_docNo_sel").removeOption(docNo);
					$(this).remove(); 
				}
				
				if(type == 'all' || $(this).find("input[name=target_pNo]").is(':checked')) {
					var html = "";
					var pNo = $(this).find("input[name=target_pNo]").val();
					$("#target_pNo_sel").removeOption(pNo);
					$(this).remove(); 
				}
			})
		} else {
			alert("삭제할 항목을 선택하세요.");
		}
	}
	
	function containSelectbox( optionName, data ) {
		var exists = 0;
		$('#'+optionName+' option').each(function(){ 
			if (this.value == data) { 
				exists++;
			}
		});
		return exists;
	}
	
	function userChange(e){
		e.preventDefault();
		 $('#target_docNo_sel option').prop('selected', true);
		 $('#target_pNo_sel option').prop('selected', true);
		 if( $("#targetUserId").selectedValues()[0] == "" ) {
			 alert("이관 대상자를 선택해주세요.");
			 $("#targetUserId").focus();
		 } else {
		 	document.form.submit();
		 }
	}
	
	function designDocKeywordChange(){
		console.log('designDocKeywordChange()')
	}
	
	
	function devDocKeywordChange(e){
		if(e.target.value == 'productType'){
			$('#devDocSearch').val('');
			$('#devDocSearch').hide();
			loadCodeList( "PRODCAT1", "productType1" );
			$('#devDocProductType').show();
		} else {
			$('#devDocSearch').show();
			$('#devDocProductType').hide();
		}
	}
	
	function initOptions(){
		$('#designDocKeyword option:first').prop('selected', true);
		$('#designDocKeyword').change();
		$('#devDocKeyword option:first').prop('selected', true);
		$('#devDocKeyword').change();
	}
	
	function loadCodeList( groupCode, objectId ) {
		var URL = "../common/codeListAjax";
		$.ajax({
			type:"POST",
			url:URL,
			data:{
				"groupCode":groupCode
			},
			dataType:"json",
			async:false,
			success:function(data) {
				var list = data.RESULT;
				$("#"+objectId).removeOption(/./);
				$("#"+objectId).addOption("", "전체", false);
				$("#label_"+objectId).html("전체");
				$.each(list, function( index, value ){ //배열-> index, value
					$("#"+objectId).addOption(value.itemCode, value.itemName, false);
				});
				
			},
			error:function(request, status, errorThrown){
				$("#"+objectId).removeOption(/./);
				alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
			}			
		});
	}
	
	function loadProductType( grade, objectId ) {
		var URL = "../common/productTypeListAjax";
		var groupCode = "PRODCAT"+grade;
		var codeValue = "";
		if( grade == '2' ) {
			codeValue = $("#productType1").selectedValues()[0]+"-";
			$("#li_productType2").hide();
			$("#li_productType3").hide();
		} else if( grade == '3' ) {
			codeValue = $("#productType2").selectedValues()[0]+"-";
			$("#li_productType3").hide();
		}
		$.ajax({
			type:"POST",
			url:URL,
			data:{
				"groupCode":groupCode,
				"codeValue":codeValue
			},
			dataType:"json",
			async:false,
			success:function(data) {
				var list = data.RESULT;
				$("#"+objectId).removeOption(/./);
				$("#"+objectId).addOption("", "전체", false);
				$("#label_"+objectId).html("전체");
				$.each(list, function( index, value ){ //배열-> index, value
					$("#"+objectId).addOption(value.itemCode, value.itemName, false);
				});
				if( list.length > 0 ) {
					$("#li_"+objectId).show();
				} else {
					$("#li_"+objectId).hide();
				}
			},
			error:function(request, status, errorThrown){
				element.removeOption(/./);
				$("#li_"+element.prop("id")).hide();
				alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
			}			
		});
	}
	
	function doSearch(e){
		if(e.keyCode == 13)
			loadDevdoc();
	}
</script>
<form id="form" name="form" action="../devdocManagement/userChangeAdmin" method="post">
<div class="wrap_in" id="fixNextTag">
	<span class="path">문서이관&nbsp;&nbsp;
		<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;
		<a href="#">${strUtil:getSystemName()}</a>
	</span>
	<section class="type01">
	<!-- 상세 페이지  start-->
		<h2 style="position:relative">
			<span class="title_s">User Change</span>
			<span class="title">문서이관</span>
			<div  class="top_btn_box">
				<div  class="top_btn_box">
					<ul><li><input type="button" class="btn_circle_modifiy" onClick="userChange()"/></li></ul>
					
				</div>
			</div>
		</h2>
		<div class="group01" >
			<div class="title"><!--span class="txt">연구개발시스템 공지사항</span--></div>
			<div class="search_box" >
				<ul>
					<li>
						<dt>변경부서</dt>
						<dd>
							<div class="selectbox" style="width:150px;"> 															
								<label for="deptCode">부서</label>
								<select name="deptCode" id="deptCode" onChange="searchUserId('change')">
									<option value="">==선택하세요==</option>
									<c:forEach  items="${deptList}" var = "dept">
										<option value="${dept.itemCode}">${dept.itemName}</option>
									</c:forEach>											
								</select>
							</div>
							<%-- 
							<div class="selectbox ml5" style="width:150px;"> 															
								<label for="teamCode">팀</label>
								<select name="teamCode" id="teamCode" onChange="searchUserId('change')">
									<option value="">==선택하세요==</option>
									<c:forEach  items="${teamList}" var = "team">
									<option value="${team.itemCode}">${team.itemName}</option>
									</c:forEach>
								</select>
							</div>
							 --%>
						</dd>
					</li>
					<li>
						<dt>이관부서</dt>
						<dd>
							<div class="selectbox" style="width:150px;"> 															
								<label for="targetDeptCode">부서</label>
								<select name="targetDeptCode" id="targetDeptCode" onChange="searchUserId('target')">
									<option value="">==선택하세요==</option>
									<c:forEach  items="${deptList}" var = "dept">
										<option value="${dept.itemCode}">${dept.itemName}</option>
									</c:forEach>											
								</select>
							</div>
							<%-- 
							<div class="selectbox ml5" style="width:150px;"> 															
								<label for="targetTeamCode">팀</label>
								<select name="targetTeamCode" id="targetTeamCode" onChange="searchUserId('target')">
									<option value="">==선택하세요==</option>
									<c:forEach  items="${teamList}" var = "team">
									<option value="${team.itemCode}">${team.itemName}</option>
									</c:forEach>
								</select>
							</div>
							 --%>
						</dd>
					</li>
					<li>
						<dt>변경아이디</dt>
						<dd>
							<div class="selectbox" style="width:150px;"> 															
								<label for="userId">아이디</label>
								<select name="userId" id="userId" onChange="userIdChange()">
									<option value="">==선택하세요==</option>
								</select>	
							</div>	
						</dd>
					</li>
					<li>
						<dt>이관아이디</dt>
						<dd>
							<div class="selectbox" style="width:150px;"> 															
								<label for="targetUserId">아이디</label>
								<select name="targetUserId" id="targetUserId">
									<option value="">==선택하세요==</option>
								</select>
							</div>	
						</dd>
					</li>
					<li>
						<dt>문서유형</dt>
						<dd>
							<div class="selectbox" style="width:150px;"> 															
								<label for="docType">문서유형</label>
								<select name="docType" id="docType" onChange="docTypeChange()">
									<option value="">==선택하세요==</option>
									<option value="D">제품설계서</option>
									<option value="P">제품개발문서</option>
								</select>	
							</div>	
						</dd>
					</li>
					<li>
						<dd></dd>
					</li>
					<li id="designDocOptions" style="display:none;">
						<dt>검색옵션</dt>
						<dd>
							<div class="selectbox" style="width:150px;"> 															
								<label for="designDocKeyword">==선택하세요==</label>
								<select name="designDocKeyword" id="designDocKeyword" onChange="designDocKeywordChange()">
									<option value="">==선택하세요==</option>
									<option value="pNo">문서번호</option>
									<option value="productName">제품명</option>
								</select>	
							</div>
							<input id="designDocSearch" class="inputbox" style="margin-left: 5px; width: 150px;" onkeydown="doSearch(event)">
						</dd>
					</li>
					<li id="devDocOptions" style="display:none; width: 100%;">
						<dt>검색옵션</dt>
						<dd>
							<div class="selectbox" style="width:150px;"> 															
								<label for="devDocKeyword">==선택하세요==</label>
								<select name="devDocKeyword" id="devDocKeyword" onChange="devDocKeywordChange(event)">
									<option value="">==선택하세요==</option>
									<option value="docNo">문서번호</option>
									<option value="productCode">제품코드</option>
									<option value="productName">제품명</option>
									<!-- <option value="productType">제품유형</option> -->
								</select>	
							</div>
							<input id="devDocSearch" class="inputbox" style="margin-left: 5px; width: 150px;" onkeydown="doSearch(event)">
							<!-- <div id="devDocProductType" style="margin-left: 5px;">
								<div class="selectbox req" style="width:60px;">  
									<label for="productType1" id="label_productType1"> 선택</label> 
									<select id="productType1" name="productType1" onChange="loadProductType('2','productType2')">
									</select>
								</div>
								<div class="selectbox req ml5" style="width:60px;display:none" id="li_productType2">  
									<label for="productType2" id="label_productType2"> 선택</label> 
									<select id="productType2" name="productType2" onChange="loadProductType('3','productType3')">
									</select>
								</div>
								<div class="selectbox req ml5" style="width:60px;display:none" id="li_productType3">  
									<label for="productType3" id="label_productType3"> 선택</label> 
									<select id="productType3" name="productType3">
									</select>
								</div>
							</div> -->
						</dd>
					</li>
				</ul>
			</div>
			<div class="main_tbl">
				<table style="width:100%" class="tbl01">
					<!-- colgroup>
						<col width="45%">
						<col />
						<col width="45%">
					</colgroup-->
					<thead>
						<tr>
							<th colspan="6" width="45%">변경대상</th>
							<th>&nbsp;</th>
							<th colspan="7" width="45%">이관대상</th>
						</tr>	
						<!--tr>
							<th>&nbsp;</th>
							<th>제품코드</th>
							<th>제품버젼</th>
							<th>제품명</th>
							<th>제품유형</th>						
							<th>작업상태</th>
							<th>&nbsp;</th>
							<th>&nbsp;</th>
							<th>제품코드</th>
							<th>제품버젼</th>
							<th>제품명</th>
							<th>제품유형</th>
							<th>담당자</th>
							<th>작업상태</th>
						</tr-->
					</thead>
					<tbody>
						<tr>
							<td width="45%" colspan="6" style="vertical-align:top;">
								<table style="width:100%" id="table1">
									<colgroup>
										<col width="5%">
										<col width="15%">
										<col width="15%">
										<col width="25%">
										<col />
										<col width="15%">
									</colgroup>
									<tbody id="changeList"></tbody>
								</table>
							</td>
							<td valign="top">
								<!-- <a href="#" onClick="add()">추가</a>
								<a href="#" onClick="deleData()">삭제</a> -->
								<button type="button" class="btn_add" onClick="add()">추가</button>
								<button type="button" class="btn_add" onClick="add('all')" style="margin:10px 0 0;">전체</button>
								<button type="button" class="btn_remove" onClick="deleData()">삭제</button>
								<button type="button" class="btn_remove" onClick="deleData('all')">전체</button>
								<!-- <input type="button" class="btn_add" onClick="add()" value="추가"/>
								<input type="button" class="btn_remove" onClick="deleData()" value="삭제"> -->
							</td>
							<td colspan="7"  width="45%" valign="top">
								<table id="table2" style="width:100%">
									<colgroup>
										<col width="5%">
										<col width="16%">
										<col width="12%">														
										<col width="25%">
										<col />	
										<col width="10%">													
									</colgroup>
									<tbody id="targetList"></tbody>
								</table>
							</td>
						</tr>
					</tbody>
				</table>
				<select id="target_docNo_sel" name="target_docNo_sel" multiple="multiple" style="display:none">				
				</select>
				<select id="target_pNo_sel" name="target_pNo_sel" multiple="multiple" style="display:none">				
				</select>
			</div>
			<div class="btn_box_con4">
				<input type="button" value="문서담당자 변경" class="btn_admin_navi" onClick="userChange(event)"> 
			</div>
			<hr class="con_mode"/><!-- 신규 추가 꼭 데려갈것 !-->
		</div>
	</section>
</div>	
</form>