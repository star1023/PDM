<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page session="false" %>
	<title>공지사항</title>
<script type="text/javascript">
	
	$(document).ready(function(){
		
		$(document).on("click",".addBtn",function(){
			addRow($(this).parent().parent());
		});	
		
		$(document).on("click",".delBtn",function(){
			$(this).parent().parent().remove();
		});
		
		 $("#keyword").autocomplete({
		      source: function( request, response ) {
		        $.ajax( {
		          type:"POST",
		          url: "/approval/searchUser",
		          dataType: "json",
		          data: {
		        	  "keyword": $("#keyword").val(),
					   "userGrade" : ''
		          },
		          async:false,
		          success: function( data ) {
		        	response($.map(data.data, function(item){
		        		return {
	                      label: item.userName,
	                      value: item.userName
	        			};
	       			}));
		          }
		        } );
		      },
		      minLength: 1,
		      delay: 300,
		      focus: function( event, ui ) {
		    	return false;
		      }
		    });


		
	})
	
	function searchUserResp(regNum, userGrade){
		var keyword = $("#keyword").val();			
		$.ajax({
			type:"POST",
			url:"/approval/searchUser",
			data:{"keyword": keyword,
				   "userGrade" : userGrade},
			dataType:"json",
			async:false,
			success:function(data) {
				if(data.status == 'success'){
		        	alert("성공");
		        	$("#userList tr").remove();
						if(data.data.length > 0){
							for(var i=0; i<data.data.length; i++){
								var userId = data.data[i].userId;
								var userName = data.data[i].userName;
								var deptFullName = data.data[i].deptFullName;
								var titCodeName = data.data[i].titCodeName;	
								
								$("#userList").append("<tr><td><img alt='' src='../resources/images/icon_path.png' class='addBtn'></td><td>"+deptFullName+"</td><td>"+titCodeName+"</td><td>"+userName+"<input type='hidden' name='targetId' value="+ userId+"></td></tr>");
							}
						}else if(data.data.length == 0){
								$("#userList").append("<tr id='noData'><td colspan='4'>조회된 데이터가 없습니다.</td></tr>");
						}
					} else if( data.status == 'fail' ){
					alert(data.msg);
		        } else {
		        	alert("오류가 발생하였습니다.");
		        }
			},
			error:function(request, status, errorThrown){
				alert("오류가 발생하였습니다.");
			}			
		});	
	}
	
	function addRow(OBJ){
		
		var tbType = '${tbType}';
		
		$("#apprList").append("<tbody><tr><td><img src='../resources/images/icon_path.png' alt='삭제' class='delBtn' /></td><td></td></tr></tbody>");
	
		if(tbType ==  "manufacturingProcessDoc" ){
			$("#select_mpd").clone().appendTo("#apprList tr:last td:eq(1)");	
		} else if(tbType ==  "designRequestDoc"){
			$("#select_drd").clone().appendTo("#apprList tr:last td:eq(1)");
		} else if(tbType ==  "designRequestDoc"){
			$("#select_imd").clone().appendTo("#apprList tr:last td:eq(1)");
		}
		
		OBJ.find("td:eq(1)").clone().appendTo("#apprList tr:last").css("background-color", "");
		OBJ.find("td:eq(2)").clone().appendTo("#apprList tr:last").css("background-color", "");
		OBJ.find("td:eq(3)").clone().appendTo("#apprList tr:last").css("background-color", "");
	}
	
	function changeApprLine(){
		var apprLineNo = $("#apprLineSelect").val();						
		$("#apprList tbody").empty();
		
		
		$.ajax({
			type:"POST",
			url:"/approval/searchApprLine",
			data:{ "apprLineNo" :apprLineNo},
			dataType:"json",
			async:false,
			success:function(data) {
				if(data.status == 'success'){
		        	alert("성공");
						if(data.data.length > 0){
							for(var i=0; i<data.data.length; i++){
								
								var apprType = data.data[i].apprType;
								var deptName = data.data[i].deptFullName;
								var titleName = data.data[i].titCodeName;
								var userName = data.data[i].userName;
								var targetUserId = data.data[i].targetUserId;
								
								apprListAddQuery(i, deptName, titleName, userName, apprType, targetUserId);	
							}
						}
				}else if( data.status == 'fail' ){
					alert(data.msg);
		        } else {
		        	alert("오류가 발생하였습니다.");
		        }
			},
			error:function(request, status, errorThrown){
				alert("오류가 발생하였습니다.");
			}			
		});
		
/* 		$.post("/menu/common/searchApprLine.jsp", { apprLineNo :apprLineNo},					
				function(data){
					if(data.length > 0){
						for(var i=0; i<data.length; i++){
							var apprType = data[i].apprType;
							var deptName = data[i].deptName;
							var titleName = data[i].titleName;
							var userName = data[i].userName;
							var targetUserId = data[i].targetUserId;
							
							apprListAddQuery(i, deptName, titleName, userName, apprType, targetUserId);								
						}
					}
				}
		, "json");	 */		
	}
	
	function apprListAddQuery(idx, deptName, titleName, userName, apprType, targetUserId){
		
		var tbType = '${tbType}';
		
		var query = "<tbody><tr><td><img src='../resources/images/icon_path.png' alt='삭제' class='delBtn' /></td><td></td><td>"+deptName+"</td><td>"+titleName+"</td><td>"+userName+"</td></tr></tbody>";
		$("#apprList").append(query);
		
		if(tbType == "manufacturingProcessDoc"){
			$("#select_mpd").clone().appendTo("#apprList tr:eq("+idx+") td:eq(1)");	
		} else if(tbType = "designRequestDoc"){
			$("#select_drd").clone().appendTo("#apprList tr:eq("+idx+") td:eq(1)");
		} else if(tbType = "designRequestDoc"){
			$("#select_imd").clone().appendTo("#apprList tr:eq("+idx+") td:eq(1)");
		}

		$("#apprList tr:eq("+idx+") td:eq(1)").find("select[name=apprType]").val(apprType);
		$("#apprList tr:eq("+idx+") td:eq(4)").append("<input type='hidden' name='targetId' value=\""+targetUserId+"\">");
	}
	
	function approvalLineDelete(){
		if($("#apprLineSelect").val() == ""){
			alert("삭제할 결재선을 선택하세요.");
			$("#apprLineSelect").focus();
			return;
		}
		
		if(confirm("삭제하시겠습니까?")){
			
			var apprLineNo = $("#apprLineSelect").val();
			
			$.ajax({
				type:"POST",
				url:"/approval/deleteApprovalLine",
				data:{ "apprLineNo" :apprLineNo},
				dataType:"json",
				async:false,
				success:function(data) {
					if(data.status == 'success'){
			        	alert("성공");

					}else if( data.status == 'fail' ){
						alert(data.msg);
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
	
	function approvalLineSavePopup(){
		var len = $("#apprList").find("tr").length;
		if(len == 0){
			alert("최소 한명이상 결재선을 지정하세요.");
			return false;
		}
		
		var tbType = '${tbType}';
		
		var apprTypeArr = [];
		
		var targetIdArr = [];
		
		$("#apprList [name=apprType]").each(function(i){
			apprTypeArr.push($(this).val());
		});
		
		$("#apprList [name=targetId]").each(function(i){
			targetIdArr.push($(this).val());
		});
		
		var iTop = (window.screen.height-30-600)/2;
		var iLeft = (window.screen.width-10-600)/2;
		
		var iWindowFeatures = "height=420, width=800, top="+iTop+", left="+iLeft+", toolbar=no, scrollbars=yes, resizable=no, menubar=no, location=no, status=no"; 
		window.open("/approval/approvalLineSavePopup?tbType="+tbType+"&apprTypeArr="+apprTypeArr+"&targetIdArr="+targetIdArr, "Reservation Info", iWindowFeatures);
		
	}
	
	function applyApprLine(){
		
		if(!validate_MPD()){
			return;
		}

		// 결재/회람/참조자 리스트
		var apprArray = [];
		var refArray = [];
		var calArray = [];
		
		// 오픈창의 저장리스트 초기화
		opener.initToOpener();
		
		$("#apprList tr").each(function(idx){
			var apprType = $(this).find("td:eq(1)").find("select[name=apprType]").val();
			var apprTypeText = $(this).find("td:eq(1)").find("select[name=apprType] option:selected").text();
			var dept = $(this).find("td:eq(2)").text();
			var grade = $(this).find("td:eq(3)").text();
			var name = $(this).find("td:eq(4)").text();
			var targetId = $(this).find("td:eq(4)").find("input[name=targetId]").val();
		
			//alert("apprType : "+apprType+" apprTypeText : "+apprTypeText+" name : "+name);
			if(apprType == "R"){
				var txt = name + "("+grade + "/" + dept+")";
				refArray.push({TXT: txt, ID: targetId});
				//alert(txt);
			} else if(apprType == "C"){
				var txt = name + "("+grade + "/" + dept+")";
				calArray.push({TXT: txt, ID: targetId});
				//alert(txt);
			} else {
				//alert(apprType + ":" + apprTypeText + " : " + dept + " : " + grade + " : " + name);
				apprArray.push({SEQ: apprType, TYPE: apprTypeText, NAME: name, DEPT: dept, GRADE: grade, ID: targetId});
			}
			
			// 오픈창에 저장(결재선 팝업을 재오픈을 위함)
			opener.saveToOpener(apprType, name, dept, grade, targetId);
		});
		
		// 내림차순 정렬
		apprArray.sort(SortBySeq);
		opener.sortToOpener();
		
		// 결재선 추가
		opener.$("#apprListTable tbody").find(".exLine").remove();
		
		for(var k=2; k<9; k++){
			opener.$("#userId"+k).val(''); // hidden type value들 모두 초기화
		}
		
		for(var i=0;i<apprArray.length;i++){
			var seq = apprArray[i].SEQ;
			var type = apprArray[i].TYPE;
			var name = apprArray[i].NAME;
			var dept = apprArray[i].DEPT;
			var grade = apprArray[i].GRADE;
			var targetId = apprArray[i].ID;
			
			var query = "<tr class=\"exLine\"><td>"+seq+"</td><td>"+type+"</td><td>"+name+"</td><td>"+dept+"</td><td>"+grade+"</td></tr>";
			opener.$("#apprListTable").prepend(query);
			opener.$("#userId"+ seq).val(targetId);
		}
		
		// 참조 추가
		var refValue = "";
		opener.$("#refListBox").empty();	
		for(var i=0;i<refArray.length;i++){
			var query = "<div class=\"refBox\">"+refArray[i].TXT+"</div>";
			opener.$("#refListBox").append(query);
			
			if(i>0){ refValue = refValue + ",";	}
			refValue = refValue + refArray[i].ID;
		}
		//제조공정서에 합의가 추가되며 제조공정서는 참조를 userId7에 넣는다.
		if("manufacturingProcessDoc" == '${tbType}'){
			opener.$("#userId7").val(refValue);
		}else{
			opener.$("#userId5").val(refValue);
		}
		
		var calValue = "";
		opener.$("#calListBox").empty();
		for(var i=0;i<calArray.length;i++){
			var query = "<div class=\"refBox\">"+calArray[i].TXT+"</div>";
			opener.$("#calListBox").append(query);
			
			if(i>0){ calValue = calValue + ",";	}
			calValue = calValue + calArray[i].ID;
		}
		//제조공정서에 합의가 추가되며 제조공정서는 회람을 userId8에 넣는다.
		if("manufacturingProcessDoc" == '${tbType}'){
			opener.$("#userId8").val(calValue);
		}else{
			opener.$("#userId6").val(calValue);
		}
		
		// 팝업창 닫기
		window.close();	
		
	}
	
	function SortBySeq(a, b){
		var aSEQ = a.SEQ;
		var bSEQ = b.SEQ; 
		return ((aSEQ < bSEQ) ? -1 : ((aSEQ > bSEQ) ? 1 : 0)); //오름차순
		//return ((aSEQ < bSEQ) ? 1 : ((aSEQ > bSEQ) ? -1 : 0)); //내림차순		  
	}	
	
	function validate_MPD(){
		var len = $("#apprList").find("tr").length;
		
		if(len == 0){
			alert("최소 한명이상 결재선을 지정하세요.");
			return false;
		}
		
		var apprCnt = 0;
		
		var overApprTypeText = "";
		var drCon = ['yeorin', 'dlach8', 'admin'];
		var tarId = "";
		var retVal = true;
		
		$("#apprList tr").each(function(idx){
			var apprType = $(this).find("td:eq(1)").find("select[name=apprType]").val();
			
			var checkYn = true;
			if(apprType != "R" && apprType != "C"){			
				apprCnt++;
				
				// 결재자를 중복지정 했는지 체크한다.
				$("#apprList").find("select[name=apprType]").each(function(idx2){						
					if(idx !=idx2 && apprType == $(this).val()){							
						checkYn = false;
						return false;
					}	
				});
			}
			if('${tbType}' == "designRequestDoc"){
				if(apprType == 2){
					tarId = $(this).find("td:eq(4)").find("input[name=targetId]").val(); //1차 검토자 아이디
					retVal =$.inArray(tarId, drCon);//1차 검토자 id와 drCon배열 값 비교. tarId가 drCon에 없을 경우 0 미만
					if(retVal < 0){
						alert("디자인의뢰서 1차 검토자는 \n임초롱, 유여린 연구원입니다.");
						retVal = false;
					}else{
						retVal = true;
					}
				}
			}
			
			if(!checkYn){
				overApprTypeText = $(this).find("td:eq(1)").find("select[name=apprType] option:selected").text();
				return false;
			}
		});
		
		if(!retVal){ // 1차 검토자에 검토자 이외의 사람을 넣었을 경우 return;
			return;
		}
		
		if(apprCnt == 0){
			alert("최소 한명이상 결재자를 지정하세요.");
			return false;
		}
		
		if(overApprTypeText != ""){
			alert(overApprTypeText+" 은/는 한명만 지정해주세요.");
			return false;
		}
		
		return true;
	}
</script>


<jsp:useBean id="toDay" class="java.util.Date" />
	<span class="path">
		공지사항&nbsp;&nbsp;<img src="../resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;
		<a href="#">파리크라상 식품기술 연구개발시스템</a>
	</span>
	<section class="type01">


		<div class="group01" >
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
										<!-- <input type="text" name="keyword" id="keyword" style="width: 150px; font-size:12px; height:18px; padding:2px 4px;border:1px solid #dadada; margin: 0 2px 0 7px;" onKeyPress="if(event.keyCode==13) searchUserResp('','');"/>
										<img src="" align="absmiddle" style="cursor: pointer;" onClick="searchUserResp('','');"/> -->
										<input type="text" name="keyword" id="keyword" style="width: 150px; font-size:12px; height:18px; padding:2px 4px;border:1px solid #dadada; margin: 0 2px 0 7px;"/>
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


