<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page session="false" %>
<title>제품개발문서 담당자 변경</title>
<script type="text/javascript">
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
	
	function loadDevdoc() {
		var userId = $("#userId").selectedValues()[0];
		if( userId == '' ) {
			$('#changeList').html("");
		} else {
			$.ajax({
				type: 'post',
				url: '../devdocManagement/devDocList',
				data: {
					"userId" : userId
				},
				dataType: 'json',
				success: function (data) {
					var list = data;
					var html = '';
					$('#changeList').html(html);
					list.forEach(function (item) {
						html += "<tr>"
						html += "	<td><input type='checkbox' name='ddNo' id='ddNo' value='"+item.ddNo+"'></td>";
						html += "	<td>"+item.productCode+"<input type='hidden' name='productCode' id='productCode' value='"+item.productCode+"'></td>";
						html += "	<td>"+item.docVersion+"<input type='hidden' name='docVersion' id='docVersion' value='"+item.docVersion+"'></td>";
						html += "	<td>"+item.productName+"<input type='hidden' name='productName' id='productName' value='"+item.productName+"'></td>";
						html += "	<td>"+item.productCategoryName+"<input type='hidden' name='productCategoryName' id='productCategoryName' value='"+item.productCategoryName+"'>";
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
					});
					$('#changeList').html(html);
				},error: function(XMLHttpRequest, textStatus, errorThrown){
					alert("에러발생");
				}
			});
		}
	}
	
	function add() {
		var nodes = $("#table1 > tbody").children();
		var cnt =  nodes.find("input[name=ddNo]:checked").length;
		if( cnt > 0 ) {
			nodes.each(function(){
				if($(this).find("input[name=ddNo]").is(':checked')) {
					var html = "";
					var ddNo = $(this).find("input[name=ddNo]").val();
					if( containSelectbox('target_ddNo_sel',ddNo) == 0 ) {
						$("#target_ddNo_sel").addOption(ddNo, ddNo,false);
						html += "<tr>";
						html += "<td>";
						html += "<input type='checkbox' name='target_ddNo' id='target_ddNo' value='"+$(this).find("input[name=ddNo]").val()+"'>";
						html += "<input type='hidden' name='changeDdNo' id='changeDdNo' value='"+$(this).find("input[name=ddNo]").val()+"'>";
						html += "</td>";
						html += "<td>"+$(this).find("input[name=productCode]").val()+"</td>";
						html += "<td>"+$(this).find("input[name=docVersion]").val()+"</td>";
						html += "<td>"+$(this).find("input[name=productName]").val()+"</td>";
						html += "<td>"+$(this).find("input[name=productCategoryName]").val()+"</td>";
						html += "<td>"+$(this).find("input[name=regUserName]").val()+"<input type='hidden' name='changeRegUserId' id='changeRegUserId' value='"+$(this).find("input[name=regUserId]").val()+"'>";
						html += "</td>";
						html += "<td>"+$(this).find("input[name=state]").val()+"</td>";
						html += "</tr>";
						$('#targetList').append(html);
					} 
				}
			})
		} else {
			alert("추가할 항목을 선택하세요.");
		}
	}
	
	function deleData() {
		var nodes = $("#table2 > tbody").children();
		var cnt =  nodes.find("input[name=target_ddNo]:checked").length;
		if( cnt > 0 ) {
			nodes.each(function(){
				if($(this).find("input[name=target_ddNo]").is(':checked')) {
					var html = "";
					var ddNo = $(this).find("input[name=target_ddNo]").val();
					$("#target_ddNo_sel").removeOption(ddNo);
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
	
	function userChange(){
		 $('#target_ddNo_sel option').prop('selected', true);
		 if( $("#targetUserId").selectedValues()[0] == "" ) {
			 alert("이관 대상자를 선택해주세요.");
			 $("#targetUserId").foscu();
		 } else {
		 	document.form.submit();
		 }
	}
</script>
<section class="type01">


		<div class="group01">
			<div style="width:100%; height:30px;">
				<div style="width: 49%; float: left; padding-left: 55px;">제조공정서 결재상신</div>
				<div style="width: 45%; float: left;  height: 30px;">
						<button  style="float:right">닫기</button>
						<button  type="submit" name="submit"  style="float:right; margin-right:5px;">상신</button>
				</div>
			</div>
			<div class="main_tbl" style="bottom:0;">
				<table class="tbl01"  cellpadding="0" cellspacing="0" border="1" style="width: 100%; border-top: none; border-bottom: none;">
					<colgroup>
						<col width="45%">
						<col/>
					</colgroup>
					<tr>
						<td valign="top" style="border-bottom:none;">
					<table style="width: 100%; margin-bottom: 2px; border: 1px solid #D5D5D5;">
								<tr>
									<td style="background-color: #eaeaea; padding: 5px;">
										<img alt="" src=""  align="absmiddle"/>						
										<span style="font-weight: bold; margin-bottom: 1px;">이름</span>
										<input type="text" name="keyword" id="keyword" style="width: 150px; font-size:12px; height:18px; padding:2px 4px;border:1px solid #dadada; margin: 0 2px 0 7px;" onKeyPress="if(event.keyCode==13) searchUserResp('','');"/>
										<img src="" align="absmiddle" style="cursor: pointer;" onClick="searchUserResp('','');"/>
									</td>
								</tr>
							</table>
							<table border="0" cellspacing="0" style="width: 100%;">
								<colgroup>
									<col width="9%" />
									<col width="48%" />
									<col width="23%" />
									<col width="20%" />
								</colgroup>
								<tr>
								  	<th style="text-align: center;">추가</th>
									<th style="text-align: center;">부서명</th>
									<th style="text-align: center;">직급</th>
									<th style="text-align: center;">이름</th>
								  </tr>	
							</table>
							<div style="width: 100%; height: 250px; overflow-y: auto;">
								<table id="userList" border="0" cellspacing="0" style="width: 100%; border-top: none; text-align: center;" onselectstart="return false">
									<colgroup>
										<col width="10%" />
										<col width="48%" />
										<col width="25%" />
										<col width="17%" />
									</colgroup>
								</table>
							</div>
						</td>
						<td valign="top" style="border-bottom:none;">
						<form name="apprLineForm" id="apprLineForm" method="post">
								<input type="hidden" name="lineName" id="lineName" >
								<input type="hidden" name="mode" id="mode" >
								<input type="hidden" name="tbType" id="tbType">
								<input type="hidden" name="apprLineNo" id="apprLineNo" >
								<table style="width: 100%; margin-bottom: 2px; border: 1px solid #D5D5D5;">
									<tr>
										<td style="background-color: #eaeaea; padding: 3px;" align="right">
											<select id="apprLineSelect"  style="float: right; width: 300px;" onChange="changeApprLine();">
													<option value="">========= 결재선 불러오기 =========</option>
												<c:forEach var="apprLine" items="${apprLineList}">
													<option value="${apprLine.apprLineNo}" <c:if test="${apprLineNo eq apprLine.apprLineNo}">selected="selected"</c:if>>${apprLine.lineName}</option>
												</c:forEach>
											</select>
										</td>
									</tr>
								</table>
								<table border="0" cellspacing="0" style="width: 100%;">
									<colgroup>
										<col width="7%" />
										<col width="14%" />
										<col width="44%" />
										<col width="18%" />
										<col width="17%" />
									</colgroup>
									<tr style="cursor: pointer;">
										<th style="text-align: center;">삭제</th>
									  	<th style="text-align: center;">유형</th>
										<th style="text-align: center;">부서명</th>
										<th style="text-align: center;">직급</th>
										<th style="text-align: center;">이름</th>
									  </tr>	
								</table>
								<div style="width: 100%; height: 250px; overflow-y: auto;">
									<table id="apprList" border="1" cellspacing="0" style="width:100%; text-align: center; border-top: none; text-align: center;" onselectstart="return false">
										<colgroup>
											<col width="6%" />
											<col width="14%" />
											<col width="45%" />
											<col width="18%" />
											<col width="16%" />
										</colgroup>
									</table>
								</div>
							</form>
						</td>
					</tr>
					<tr>
						<td style="border-bottom: none; border-top: 2px solid #6A6562;">
							<button type="button"  style="float:left; " onClick="approvalLineSavePopup(); return false;">결재선 저장</button>&nbsp;
							<button type="button"  style="float:left; margin-left:5px;" onClick="approvalLineDelete(); return false;">결재선 삭제</button>&nbsp;						
						</td>
						<td style="border-bottom: none;  border-top: 2px solid #6A6562;">
							<button type="button"  style="float:right; margin-left:5px;">닫기</button>&nbsp;
							<button type="button"   style="float:right" >적용</button>&nbsp;
						</td>
					</tr>
					<tr>
						<td colspan="2" style="border-bottom: none;">
							<div style="width : 100%;">
								<div style="padding: 2px;"> 조회된 이름의 행을 <b>더블클릭</b>하면 오른쪽 결재선에 자동으로 추가됩니다. 추가된 결재선의 행을 <b>더블클릭</b>하면 삭제됩니다. <br /></div>
							 	<div style="padding: 2px;"> 모든 결재선을 지정 후 <b>[결재선 저장]</b> 버튼을 저장하고, 오른쪽 상단에서 박스에서 선택하여 불러올 수 있습니다.</div>
							</div>
						</td>
					</tr>
				</table>
			</div>
		</div>
<div style="visibility: hidden; padding: 0px; margin: 0px; height: 0px;">
	<select name="apprType" class="i_text_needselect" style="width: 80px;" id="select_mpd">
		<option value="2" selected="selected" >합의1</option>
		<option value="3">합의2</option>
		<option value="4">파트장</option>
		<option value="5">팀장</option>
		<option value="6">연구소장</option>
		<option value="R">참조</option>
		<option value="C">회람</option>
	</select>
	<select name="apprType" class="i_text_needselect" style="width: 80px;" id="select_drd">
		<option value="2" selected="selected">1차검토</option>
		<option value="3">2차검토</option>
		<option value="4" >마케팅</option>
		<option value="R">참조</option>
		<option value="C">회람</option>
	</select>
	<select name="apprType" class="i_text_needselect" style="width: 80px;" id="select_imd">
		<option value="2">1차검토</option>
		<option value="3">2차검토</option>
		<option value="R" selected="selected">참조</option>
		<option value="C">회람</option>
	</select>
</div>
	</section>
