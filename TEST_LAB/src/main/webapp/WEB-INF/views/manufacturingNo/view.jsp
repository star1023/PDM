<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ page session="false" %>
<%@ page import="kr.co.aspn.util.*" %> 
<%
	String userGrade = UserUtil.getUserGrade(request);
	String userDept = UserUtil.getDeptCode(request);
	String userTeam = UserUtil.getTeamCode(request);
	String isAdmin = UserUtil.getIsAdmin(request);
%>
<script type="text/javascript">
	function goUpdateForm(seq) {
		loadCodeList( "PRODCAT1", "productType1" );
		loadCodeList( "KEEPCONDITION", "keepCondition" );
		loadCodeList( "STERILIZATION", "sterilization" );
		loadCodeList( "ETCDISPLAY", "etcDisplay" );
		$("#keepConditionText").hide();
		var URL = "../manufacturingNo/manufacturingNoLogAjax";
		$.ajax({
			type:"POST",
			url:URL,
			data:{
				"seq":seq
			},
			dataType:"json",
			async:false,
			success:function(data) {
				$("#no_seq").val(seq);
				$("#productType1").selectOptions(data.productType1);
				$("#label_productType1").html(data.productType1Name);
				if( data.productType2 != '' ) {
					loadProductType( '2', 'productType2' );	
					$("#productType2").selectOptions(data.productType2);
					$("#label_productType2").html(data.productType2Name);
				}
				if( data.productType3 != '' ) {
					loadProductType( '3', 'productType3' );	
					$("#productType3").selectOptions(data.productType3);
					$("#label_productType2").html(data.productType2Name);
				}
				
				$("#sterilization").selectOptions(data.sterilization);
				if( data.sterilization == '' ) {
					$("#label_sterilization").html("선택안함");
				} else {
					$("#label_sterilization").html(data.sterilizationName);
				}
				//$("#label_sterilization").html(data.sterilizationName);
				$("#etcDisplay").selectOptions(data.etcDisplay);
				if( data.etcDisplay == '' ) {
					$("#label_etcDisplay").html("선택안함");
				} else {
					$("#label_etcDisplay").html(data.sterilizationName);
				}
				//$("#label_etcDisplay").html(data.etcDisplayName);
				$("#keepCondition").selectOptions(data.keepCondition);
				if( data.keepCondition == '7' ) {
					$("#label_keepCondition").html("직접입력");
					$("#keepConditionText").show();
					$("#keepConditionText").val(data.keepConditionText);
				} else {
					$("#label_keepCondition").html(data.keepConditionName);
				}
				$("#sellDate").val(data.sellDate);
				if( data.referral == 'Y' ) {
					$("input:checkbox[name='referral']").prop("checked", true);
				}
				if( data.oem == 'Y' ) {
					$("input:checkbox[name='oem']").prop("checked", true);
				}
				if( data.referral == 'Y' || data.oem == 'Y' ) {
					loadPlant();
					var productCode = data.createPlant.split(',');
					for( var i = 0 ; i < productCode.length ; i++ ) {
						//[value=" + splitCode[idx] + "] "
						$("input[name=createPlant][value=" + productCode[i] + "]").prop("checked", true);
					}
				}
			},
			error:function(request, status, errorThrown){
				alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
			}			
		});
		
		openDialog('open');
	}
	
	function goDeleteForm(seq) {
		$("#no_seq").val(seq);
		openDialog('open2');
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
				$("#"+objectId).removeOption(/./);
				if( groupCode == 'STERILIZATION' || groupCode == 'ETCDISPLAY' ) {
					$("#"+objectId).addOption("", "선택안함", false);
					$("#label_"+objectId).html("선택안함");
				} else {
					$("#"+objectId).addOption("", "전체", false);
					$("#label_"+objectId).html("전체");
				}
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
	
	function loadPlant() {
		var URL = "../common/plantListAjax";
		$.ajax({
			type:"POST",
			url:URL,
			data:{
			},
			dataType:"json",
			async:false,
			success:function(data) {
				var list = data.RESULT;
				var html = "";
				$("#create_plant_list").html(html);
				var count = 0
				$.each(list, function( index, value ){ //배열-> index, value
					html += "	<input type=\"checkbox\" name=\"createPlant\" id=\"plant_"+value.plantCode+"\" value=\""+value.plantCode+"\"><label for=\"plant_"+value.plantCode+"\"><span></span>"+value.plantName+"("+value.plantCode+")</label>";
					count++;
					if( count != 0 && count % 4 == 0 ) {
						html += "<br/>";
					}
					
				});
				$("#create_plant_list").html(html);
				$("#create_plant_li").show();
			},
			error:function(request, status, errorThrown){
					alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
			}			
		});
	}
	
	function oemCheck() {
		if( $("input:checkbox[name=referral]").is(":checked") == false && $("input:checkbox[name=oem]").is(":checked") == false ) {
			$("#create_plant_li").hide();
			$("#create_plant_list").html("");
		} else {
			if($("#create_plant_li").is(":visible") == false ) {
				loadPlant();	
			}
		}
	}
	
	function changeKeepCondition() {
		if( $("#keepCondition").selectedValues()[0] == '7' ) {
			$("#keepConditionText").show();
		} else {
			$("#keepConditionText").val("");
			$("#keepConditionText").hide();
		}
	}
	
	function goCancel(id) {
		goClear();
		closeDialog(id);
	}
	
	function addFile(fileIdx) {
		var filePath = document.getElementById(fileIdx).value;
		var fileName = filePath.substring(filePath.lastIndexOf('\\') + 1,	filePath.length);
		if (fileName.length == 0) {
			//alert("파일을 선택해 주십시요.");
			return;
		}

		var html = "";
		$("#up"+fileIdx).html(html);
		html += "		<a href='#' onClick='javascript:deleteFile(this)'><img src=\"/resources/images/icon_del_file.png\"></a>";
		html += "		"+ fileName + "";
		$("#up"+fileIdx).html(html);
	}
	
	//추가 파일 삭제 함수
	function deleteFile(e){
		var fileSpanId = $(e).parent().prop("id");
		var fileIndex = fileSpanId.slice(6);
		var fileId = "file"+fileIndex;
		$(e).parent().html("");
		$("#"+ fileId).val("");
		return;
	}
	
	function goClear() {
		$("#upfile1").html("");
		$("#file1").val("");
		$("#upfile2").html("");
		$("#file2").val("");
		$("#comment").val("");
	}
	
	function goUpdate() {
		//var formData = new FormData();
		//첫번째 파일태그
		//formData.append("uploadfile",$("input[name=uploadfile]")[0].files[0]);
		//두번째 파일태그
		//formData.append("uploadfile",$("input[name=uploadfile]")[1].files[0]);
		if( !chkNull($("#manufacturingName").val()) ) {
			alert("품목명을 입력해주세요.");
			$("#manufacturingName").focus();
			return;
		} else if( !chkNull($("#productType1").selectedValues()[0]) ) {
			alert("식품유형을 선택해주세요.");
			$("#productType1").focus();
			return;
		} else if( !chkNull($("#productType2").selectedValues()[0]) ) {
			alert("식품유형을 선택해주세요.");
			$("#productType2").focus();
			return;
		} else if( !chkNull($("#keepCondition").selectedValues()[0]) ) {
			alert("보관조건을 선택해주세요.");
			$("#keepCondition").focus();
			return;
		} else if( $("#keepCondition").selectedValues()[0] == '7' && !chkNull($("#keepConditionText").val()) ) {
			alert("보관조건을 입력해주세요.");
			$("#keepConditionText").focus();
			return;
		} else if( !chkNull($("#sellDate").val()) ) {
			alert("소비기한을 입력해주세요.");
			$("#sellDate").focus();
			return;
		} else {
			if(confirm("품목제조 보고서를 수정하시겠습니까?")){
				var referral = "N";
				var oem = "N";
				if($('input:checkbox[name="referral"]').is(':checked')) {
					referral = "Y";
				}
				if($('input:checkbox[name="oem"]').is(':checked')) {
					oem = "Y";
				}
				var plantArray = new Array();
				$('input:checkbox[name="createPlant"]').each(function() {
				      if(this.checked){//checked 처리된 항목의 값
				    	  plantArray.push(this.value);
				      }
				});
				var formData = new FormData();
				formData.append("no_seq",$("#no_seq").val());
				formData.append("plantName",$("#plantName").val());
				formData.append("manufacturingNo",$("#manufacturingNo").val());
				formData.append("manufacturingName",$("#manufacturingName").val());
				formData.append("productType1",$("#productType1").selectedValues()[0]);
				formData.append("productType2",$("#productType2").selectedValues()[0]);
				formData.append("productType3",$("#productType3").selectedValues()[0]);
				formData.append("sterilization",$("#sterilization").selectedValues()[0]);
				formData.append("etcDisplay",$("#etcDisplay").selectedValues()[0]);
				formData.append("keepCondition",$("#keepCondition").selectedValues()[0]);
				formData.append("keepConditionText",$("#keepConditionText").val());
				formData.append("sellDate",$("#sellDate").val());
				formData.append("referral",referral);
				formData.append("oem",oem);
				formData.append("createPlant",plantArray);
				formData.append("comment",$("#comment").val());
				//첫번째 파일태그
				formData.append("file",$("input[name=file]")[0].files[0]);
				//두번째 파일태그
				formData.append("file",$("input[name=file]")[1].files[0]);
				var URL = "../manufacturingNo/updateAjax";
				$.ajax({
					type:"POST",
					url:URL,
					traditional : true,
					data:formData,
					processData: false,
					contentType: false,
					success:function(result) {
						if( result.status == 'success') {
							alert("품목제조 보고서가 수정 되었습니다.");
							goCancel('open');
							goView($("#no_seq").val());
						} else {
							alert(result.msg+"오류가 발생하였습니다.\n다시 시도하여 주세요.");
						}
					},
					error:function(request, status, errorThrown){
						alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
					}			
				});	
			}
		}
	}
	
	function goDelete() {
		if( !chkNull($("#deleteComment").val()) ) {
			alert("삭제 사유를 입력해주세요.");
			$("#deleteComment").focus();
			return;
		} else {
			if(confirm("품목제조 보고서를 삭제하시겠습니까?")){
				var URL = "../manufacturingNo/deleteAjax";
				$.ajax({
					type:"POST",
					url:URL,
					data:{
						"seq":$("#no_seq").val(),
						"no_seq":$("#no_seq").val(),
						"plantName":$("#plantName").val(),
						"manufacturingNo":$("#manufacturingNo").val(),
						"manufacturingName":$("#manufacturingName").val(),
						"comment":$("#deleteComment").val()
					},
					dataType:"json",
					async:false,
					success:function(result) {
						if( result.status == 'success') {
							alert("품목제조 보고서가 삭제처리 되었습니다.");
							goCancel('open2');
							goView($("#no_seq").val());
						} else {
							alert(result.msg+"오류가 발생하였습니다.\n다시 시도하여 주세요.");
						}
					},
					error:function(request, status, errorThrown){
						alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
					}			
				});	
			}
		}
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
	
	//파일 다운로드
	function fileDownload(fmNo, tbkey, tbType){
		location.href="/file/fileDownload?fmNo="+fmNo+"&tbkey="+tbkey+"&tbType="+tbType;
	}
	
	function goView(seq) {
		window.location.href="../manufacturingNo/view?seq="+seq;
	}
	
	function goList() {
		window.location.href="../manufacturingNo/list";
	}
</script>
<div class="wrap_in" id="fixNextTag">
	<span class="path">품목제조 보고서&nbsp;&nbsp;
		<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;
		<a href="#">${strUtil:getSystemName()}</a>
	</span>
	<section class="type01">
	<!-- 상세 페이지  start-->
		<h2 style="position:relative">
			<span class="title_s">Items Manufacturing Report</span>
			<span class="title">품목제조보고서</span>
			<div  class="top_btn_box">
				<ul>
					<li><button class="btn_circle_nomal" onClick="goList();">&nbsp;</button></li>
				</ul>
			</div>
		</h2>
		<div class="group01" >
			<div class="title"><!--span class="txt">연구개발시스템 공지사항</span--></div>
			<div class="title5"><span class="txt">01.기준정보</span></div>
			<div class="list_detail">
				<ul>
					<li class="pt10">
						<dt>공장</dt>
						<dd>
							${manufacturingNoData.companyName} - ${manufacturingNoData.plantName}
						</dd>
					</li>
					<li>
						<dt>공장 인허가번호</dt>
						<dd>
							${manufacturingNoData.licensingNo}
						</dd>
					</li>
					<li>
						<dt>품목번호</dt>
						<dd>
							${manufacturingNoData.manufacturingNo}
						</dd>
					</li>
					<li>
						<dt>품목명</dt>
						<dd>
							${manufacturingNoData.manufacturingName}
						</dd>
					</li>	
					<li>
						<dt>문서상태</dt>
						<dd>
							${manufacturingNoData.isDeleteName}
						</dd>
					</li>				
				</ul>			
			</div>
			
			<div class="title5"><span class="txt">02.제품개발문서</span></div>
			<div class="main_tbl">
				<table class="tbl01">
					<colgroup>
						<col width="8%">
						<col width="5%">
						<col width="10%">
						<col width="20%">
						<col />
						<col width="10%">
						<col width="10%">
					</colgroup>
					<thead>
						<tr>
							<th>문서번호</th>
							<th>버젼</th>
							<th>제품코드</th>
							<th>제품명</th>
							<th>제품유형</th>
							<th>생성자</th>
							<th>생성일</th>							
						</tr>
					</thead>
					<tbody id="list">
					<c:if test="${fn:length(devDocData)==0}">
						<tr>
							<td colspan="9">데이터가 없습니다.</td>
						</tr>
					</c:if>
					<c:if test="${fn:length(devDocData)>0}">
						<c:forEach items="${devDocData}" var="item">
							<tr>
								<td>${item.docNo}</td>
								<td>${item.docVersion}</td>
								<td>${item.productCode}</td>
								<td>${item.productName}</td>
								<td>${item.productCategoryName}</td>
								<td>${item.userName}</td>
								<td>${item.regDate}</td>
							</tr>	
						</c:forEach>
					</c:if>
					</tbody>
				</table>	
			</div>
			
			
			<div class="title5"><span class="txt">03.상세정보</span></div>
			<div class="main_tbl">
				<table class="tbl01">
					<colgroup>
						<col width="20%">
						<col width="15%">
						<col width="20%">
						<col width="5%">
						<col width="5%">
						<col width="18%">
						<col width="5%">
						<col width="7%">
						<col width="5%">						
					</colgroup>
					<thead>
						<tr>
							<th style="border-bottom:1px dotted #aaa">제품유형</th>
							<th style="border-bottom:1px dotted #aaa">보관조건</th>
							<th style="border-bottom:1px dotted #aaa">소비기한</th>
							<th style="border-bottom:1px dotted #aaa">위탁</th>
							<th style="border-bottom:1px dotted #aaa">OEM</th>
							<th style="border-bottom:1px dotted #aaa">생산공장</th>
							<th style="border-bottom:1px dotted #aaa">담당자</th>
							<th style="border-bottom:1px dotted #aaa">처리일</th>
							<th style="border-bottom:1px dotted #aaa">상태</th>
						</tr>
						<tr>
							<th>품복제조보고명</th>
							<th>품복제조보고서</th>
							<th>소비기한설정사유서</th>
							<th colspan="7">비고(변경사유)</th>						
						</tr>
					</thead>
					<tbody id="list">
					<c:if test="${fn:length(manufacturingNoLogData)==0}">
						<tr>
							<td colspan="9">데이터가 없습니다.</td>
						</tr>
					</c:if>
					<c:if test="${fn:length(manufacturingNoLogData)>0}">
						<c:forEach items="${manufacturingNoLogData}" var="item" varStatus="status">
							<tr>
								<td style="border-bottom:1px dotted #ccc;<c:if test='${status.index%2==1}'>background-color:#f4f4f4;</c:if>">
									[
									${item.productType1Name}
									<c:if test="${item.productType2Name != null && item.productType2Name != '' }">
									>${item.productType2Name}
									</c:if>
									<c:if test="${item.productType3Name != null && item.productType3Name != '' }">
									${item.productType3Name}
									</c:if>
									]<br/>
									${item.sterilizationName}/${item.etcDisplayName}
								</td>
								<td style="border-bottom:1px dotted #ccc;<c:if test='${status.index%2==1}'>background-color:#f4f4f4;</c:if>">${item.keepConditionName}</td>
								<td style="border-bottom:1px dotted #ccc;<c:if test='${status.index%2==1}'>background-color:#f4f4f4;</c:if>">${item.sellDate}</td>
								<td style="border-bottom:1px dotted #ccc;<c:if test='${status.index%2==1}'>background-color:#f4f4f4;</c:if>">${item.referral}</td>
								<td style="border-bottom:1px dotted #ccc;<c:if test='${status.index%2==1}'>background-color:#f4f4f4;</c:if>">${item.oem}</td>
								<td style="border-bottom:1px dotted #ccc;<c:if test='${status.index%2==1}'>background-color:#f4f4f4;</c:if>">
									<c:forEach items="${fn:split(item.createPlant, ',') }" var="plant">
    									${plant} / 
									</c:forEach>
								</td>
								<td style="border-bottom:1px dotted #ccc;<c:if test='${status.index%2==1}'>background-color:#f4f4f4;</c:if>">${item.userName}</td>
								<td style="border-bottom:1px dotted #ccc;<c:if test='${status.index%2==1}'>background-color:#f4f4f4;</c:if>">${item.regDate}</td>
								<td style="border-bottom:1px dotted #ccc;<c:if test='${status.index%2==1}'>background-color:#f4f4f4;</c:if>">${item.regTypeName}</td>
							</tr>
							<tr>
								<td style="border-bottom:1px dotted #ccc;<c:if test='${status.index%2==1}'>background-color:#f4f4f4;</c:if>">
									${item.manufacturingName}
								</td>
								<td style="border-bottom:1px solid #d1d1d1;<c:if test='${status.index%2==1}'>background-color:#f4f4f4;</c:if>">
									<c:choose>
										<c:when test="${item.manufacturingReport != null && item.manufacturingReport != ''}">
											<% if( (isAdmin != null && "Y".equals(isAdmin)) || "dept1".equals(userDept) || "dept2".equals(userDept)|| "dept3".equals(userDept) || "dept4".equals(userDept) || "dept5".equals(userDept) || "dept6".equals(userDept) || "dept10".equals(userDept) || "dept11".equals(userDept) || "dept12".equals(userDept) || "dept13".equals(userDept)) { %>
											<a href="#" onClick="fileDownload('${item.manufacturingReport}', '${item.seq}', 'manufacturingReport')"><img src="/resources/images/icon_file01.png" style="vertical-align:middle;"/>${item.manufacturingReportFileName}</a>
											<% } else { %>
											<img src="/resources/images/icon_file01.png" style="vertical-align:middle;"/>${item.manufacturingReportFileName}
											<% } %>
										</c:when>
										<c:otherwise>
										&nbsp;
										</c:otherwise>
									</c:choose>	
								</td>
								<td style="border-bottom:1px solid #d1d1d1;<c:if test='${status.index%2==1}'>background-color:#f4f4f4;</c:if>">
									<c:choose>
										<c:when test="${item.sellDateReport != null && item.sellDateReport != ''}">
											<% if( (isAdmin != null && "Y".equals(isAdmin)) || "dept1".equals(userDept) || "dept2".equals(userDept)|| "dept3".equals(userDept) || "dept4".equals(userDept) || "dept5".equals(userDept) || "dept6".equals(userDept) || "dept10".equals(userDept) || "dept11".equals(userDept) || "dept13".equals(userDept)) { %>
											<a href="#" onClick="fileDownload('${item.sellDateReport}', '${item.seq}', 'sellDateReport')"><img src="/resources/images/icon_file01.png" style="vertical-align:middle;"/>${item.sellDateReportFileName}</a>
											<% } else { %>
											<img src="/resources/images/icon_file01.png" style="vertical-align:middle;"/>${item.sellDateReportFileName}	
											<% } %>
										</c:when>
										<c:otherwise>
											&nbsp;
										</c:otherwise>
									</c:choose>	
								</td>
								<td style="border-bottom:1px solid #d1d1d1;<c:if test='${status.index%2==1}'>background-color:#f4f4f4;</c:if>" colspan="6">${item.comment}</td>
							</tr>	
						</c:forEach>
					</c:if>
					</tbody>
				</table>	
			</div>
				
			<div class="btn_box_con5">
				<button class="btn_admin_gray" onClick="goList()"  style="width:120px;">목록</button>
			</div>
			<div class="btn_box_con4"> 
			<% if( (userGrade != null && "3".equals(userGrade)) || (isAdmin != null && "Y".equals(isAdmin)) ) { %>
				<button class="btn_admin_navi" onClick="goUpdateForm('${manufacturingNoData.seq}')">수정</button> 
				<button class="btn_admin_gray"onClick="goDeleteForm('${manufacturingNoData.seq}')">삭제</button>
			<% } %>	
			</div>	
			<hr class="con_mode"/><!-- 신규 추가 꼭 데려갈것 !-->	
		</div>
	</section>	
</div>

<!-- 레이어 start-->
<div class="white_content" id="open">
	<div class="modal" style="	width: 700px;margin-left:-350px;height: 670px;margin-top:-300px;">
		<h5 style="position:relative">
			<span class="title">품목제조 보고서 수정</span>
			<div  class="top_btn_box">
				<ul>
					<li>
						<button class="btn_madal_close" onClick="goCancel('open')"></button>
					</li>
				</ul>
			</div>
		</h5>
		<div class="list_detail">
			<ul>
				<li class="pt10">
					<dt>공장</dt>
					<dd>
						<input type="hidden" name="no_seq" id="no_seq">
						${manufacturingNoData.companyName} - ${manufacturingNoData.plantName}
						<input type="hidden" name="companyName" id="companyName" value="${manufacturingNoData.companyName}">
						<input type="hidden" name="plantName" id="plantName" value="${manufacturingNoData.plantName}">
					</dd>
				</li>
				<li>
					<dt>인허가번호</dt>
					<dd>
						${manufacturingNoData.licensingNo}
						<input type="hidden" name="licensingNo" id="licensingNo" value="${manufacturingNoData.licensingNo}">
					</dd>
				</li>
				<li>
					<dt>품목번호</dt>
					<dd>
						${manufacturingNoData.manufacturingNo}
						<input type="hidden" name="manufacturingNo" id="manufacturingNo" value="${manufacturingNoData.manufacturingNo}">
					</dd>
				</li>
				<li>
					<dt>품목명</dt>
					<dd>
						<%-- ${manufacturingNoData.manufacturingName} --%>
						<input type="text" class="req" name="manufacturingName" id="manufacturingName" value="${manufacturingNoData.manufacturingName}">
					</dd>
				</li>
				<li>
					<dt>식품유형</dt>
					<dd>
						<div class="selectbox req" style="width:160px;">  
							<label for="productType1" id="label_productType1"> 선택</label> 
							<select id="productType1" name="productType1" onChange="loadProductType('2','productType2')">
							</select>
						</div>
						<div class="selectbox req ml5" style="width:130px;display:none" id="li_productType2">  
							<label for="productType2" id="label_productType2"> 선택</label> 
							<select id="productType2" name="productType2" onChange="loadProductType('3','productType3')">
							</select>
						</div>
						<div class="selectbox req ml5" style="width:130px;display:none" id="li_productType3">  
							<label for="productType3" id="label_productType3"> 선택</label> 
							<select id="productType3" name="productType3">
							</select>
						</div>
					</dd>
				</li>
				<li>
					<dt>기타표시</dt>
					<dd>
						<div class="selectbox req" style="width:130px;">  
							<label for="sterilization" id="label_sterilization">선택안함</label> 
							<select id="sterilization" name="sterilization">
							</select>
						</div>
						<div class="selectbox req ml5" style="width:250px;">  
							<label for="etcDisplay" id="label_etcDisplay">선택안함</label> 
							<select id="etcDisplay" name="etcDisplay">
							</select>
						</div>
					</dd>
				</li>
				<li>
					<dt>보관조건</dt>
					<dd>
						<div class="selectbox req" style="width:180px;">  
							<label for="keepCondition" id="label_keepCondition"> 선택</label> 
							<select id="keepCondition" name="keepCondition" onChange="changeKeepCondition()">
							</select>
						</div>
						<input type="text" class="req" style="width:200px;" name="keepConditionText" id="keepConditionText">
					</dd>
				</li>
				<li>
					<dt>소비기한</dt>
					<dd>
						<input type="text" class="req" style="width:400px;" name="sellDate" id="sellDate" value="">
					</dd>
				</li>
				<li>
					<dt>위탁/OEM</dt>
					<dd>
						<input type="checkbox" id="referral" name="referral" value="Y" onClick="oemCheck()"><label for="referral"><span></span>위탁</label>
						<input type="checkbox" id="oem" name="oem" value="Y" onClick="oemCheck()"><label for="oem"><span></span>OEM</label>
					</dd>
				</li>
				<li id="create_plant_li" style="display:none">
					<dt>생산 공장</dt>
					<dd id="create_plant_list">
					</dd>
				</li>
				<li>
					<dt>품복제조보고서</dt>
					<dd>
						<span id="upfile1"></span>
						<span class="file_load" id="fileSpan1">
							<input type="file" name="file" id="file1" onChange="javaScript:addFile('file1')" style="display:none"><label for="file1">첨부파일 등록 <img src="/resources/images/icon_add_file.png"></label>
						</span>
					</dd>
				</li>
				<li>
					<dt>소비기한설정<br/>사유서</dt>
					<dd>
						<span id="upfile2"></span>
						<span class="file_load" id="fileSpan2">
							<input type="file" name="file" id="file2" onChange="javaScript:addFile('file2')" style="display:none"><label for="file2">첨부파일 등록 <img src="/resources/images/icon_add_file.png"></label>
						</span>
					</dd>
				</li>
				<li>
					<dt>비고(변경사유)</dt>
					<dd>
						<textarea style="width:95%; height:40px" name="comment" id="comment"></textarea>
					</dd>
				</li>
			</ul>
		</div>
		<div class="btn_box_con">
		<% if( (userGrade != null && "3".equals(userGrade)) || (isAdmin != null && "Y".equals(isAdmin)) ) { %>
			<input type="button" value="수정" class="btn_admin_red" id="create" onclick="javascript:goUpdate();">
		<% } %>	 
			<input type="button" value="취소" class="btn_admin_gray" onclick="goCancel('open')">
		</div>
	</div>
</div>
<!-- 레이어 close-->

<!-- 레이어 start-->
<div class="white_content" id="open2">
	<div class="modal" style="	width: 700px;margin-left:-350px;height: 240px;margin-top:-250px;">
		<h5 style="position:relative">
			<span class="title">품목제조 보고서 삭제</span>
			<div  class="top_btn_box">
				<ul>
					<li>
						<button class="btn_madal_close" onClick="goCancel('open2')"></button>
					</li>
				</ul>
			</div>
		</h5>
		<div class="list_detail">
			<ul>
				<li>
					<dt>비고(변경사유)</dt>
					<dd>
						<textarea style="width:95%; height:60px" name="deleteComment" id="deleteComment"></textarea>
					</dd>
				</li>
			</ul>
		</div>
		<div class="btn_box_con">
		<% if( (userGrade != null && "3".equals(userGrade)) || (isAdmin != null && "Y".equals(isAdmin)) ) { %>
			<input type="button" value="삭제" class="btn_admin_red" id="delete" onclick="javascript:goDelete();"> 
		<% } %>		
			<input type="button" value="취소" class="btn_admin_gray" onclick="goCancel('open2')">
		</div>
	</div>
</div>
<!-- 레이어 close-->