<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="userUtil" uri="/WEB-INF/tld/userUtil.tld"%>
<jsp:useBean id="now" class="java.util.Date"/>
<%@ page session="false" %>
	<title>회의실 예약리스트</title>
	<link href="../resources/css/main.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/resources/js/jquery.ui.monthpicker.js"></script>
<script type="text/javascript">
$(document).ready(function(){

 var startYear = (new Date()).getFullYear();
 
 var options = {
	dateFormat: 'yy-mm',
	showOn: 'button',
	buttonImage: '../resources/images/btn_calendar.png',
	buttonImageOnly: true,
	
	monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
	monthNamesShort:['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
	yearRange:String(startYear-2)+":"+String(startYear+2),
	onSelect: function(dateText,inst){
		$("#displayDateInput").parent().children("strong").html(dateText);
		
		$.ajax({
			type:"POST",
			url:"/dev/devDocLaunchListCal",
			data:{
				"year":dateText.substr(0,4),
				"month":dateText.substr(5,7)
			},
			dataType:"json",
			async:false,
			success:function(data){
				var launchList = $("#launchList");
				
				launchList.empty();
				
				var data = data.launchList;
				
				for(var i=0; i<data.length;i++){
					launchList.append("<tr><td><span style=color:"+data[i].dayColor+";>("+data[i].DayOfWeek+") "+data[i].day+"일</span></td><td id=launch_"+data[i].day+"></td><tr>");
					
					for(var j=0; j<data[i].launchProductList.length;j++){
						
					/* 	$("#launch_"+data[i].day).append("<a href=#none onclick=goDevDocDetail("+data[i].launchProductList[j].docNo+","+data[i].launchProductList[j].docVersion+")>"+index+". ( "+data[i].launchProductList[j].productName+" ) , </a>"); */
							$("#launch_"+data[i].day).append("<button type=button style=margin:5px 5px; class=btn_small01 ml5 onclick=goDevDocDetail("+data[i].launchProductList[j].docNo+","+data[i].launchProductList[j].docVersion+"); return false;>"+data[i].launchProductList[j].productName+" </button>");
					}
					
				}
				
			},
			error:function(request,status,errorThrown){
				alert("오류가 발생하였습니다.");
			}
		});
	}
 };
 
 $("#displayDateInput").monthpicker(options);

/*  $("#monthSelect").bind('click',function(){
	 $("#displayDateInput").monthpicker('show');		 
 }); */
 
	$('.ui-monthpicker-trigger').css('margin-left', '8px');
	$('.ui-monthpicker-trigger').css('margin-top', '-5px');
	$('.ui-monthpicker-trigger').css('cursor', 'pointer');
 
});

function goDevDocDetail(docNo,docVersion){
	
	location.href = "/dev/productDevDocDetail?docNo="+docNo+"&docVersion="+docVersion;
}

function launchDateUpdate(){
	
	$("#launchDatetBody").empty();
	
 	openDialog("open");
}

function closePopup(){
	
	$("#searchValue").val('');
	
	closeDialog("open");
}

function searchProduct(){
	
	var regexp = /^[0-9]*$/;
	
	if($("#searchValue").val()=='' || $("#searchValue").val() == undefined){
		alert("키워드를 입력하세요!");
		return false;
	}
	
	if($("#searchType").val()=='number'){
		if(!regexp.test($("#searchValue").val())){
			alert("제품번호는 숫자만 검색 가능합니다.");
			return false;
		}
	}
	
	$.ajax({
		type:"POST",
		url:"/dev/searchDevDocLatestList",
		data:{
			"searchType":$("#searchType").val(),
			"searchValue":$("#searchValue").val()
		},
		dataType:"json",
		async:false,
		success:function(data){
			
			$("#launchDatetBody").empty();
			
			var launchDatetBody = $("#launchDatetBody");
			
			for(var i=0; i<data.length; i++){
				
				var year = String(new Date(data[i].launchDate).getFullYear());
				
				var month = "";
					
					if(String((new Date(data[i].launchDate).getMonth())+1).length == 1){
						month = "0"+String((new Date(data[i].launchDate).getMonth())+1)
					}else{
						month = String((new Date(data[i].launchDate).getMonth())+1);
					}
				
				var date = "";
				
					if(String(new Date(data[i].launchDate).getDate()).length == 1 ){
						date = "0"+String(new Date(data[i].launchDate).getDate());
					}else{
						date = String(new Date(data[i].launchDate).getDate());
					}
					
				launchDatetBody.append("<tr><td><input type='checkbox' id='launchDateCheck_"+data[i].ddNo+"' name='launchDateCheck_"+data[i].ddNo+"'/><label for='launchDateCheck_"+data[i].ddNo+"' style='padding-right:0px;'><span></span></label></td><td>"+data[i].docVersion+"</td><td>"+data[i].docNo+"</td><td>"+data[i].productCode+"</td><td>"+data[i].productName+"</td><td><input type='text' style='width:180px; margin-left:5px; float:left;' value="+year+"-"+month+"-"+date+"></td></tr>");
			}
			
		},
		error:function(request,status,errorThrown){
			alert("오류가 발생하였습니다.");
		}
	});
	
}

function updateLaunchDate(){
		
	var date_pattern = /^(19|20)\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[0-1])$/; 
	
	var checkCount = 0;	

	var successCount = 0;
	
	if($("#launchDatetBody tr").length == 0){
		return alert("제품을 검색해주세요!");
		
	}
	
	$("#launchDatetBody input[type=checkbox]:checked").each(function(){
		
		checkCount ++;
		
		console.log(($(this).attr("id").split("launchDateCheck_"))[1]);
		
		console.log($(this).parent("td").siblings().eq("4").children("input").val());
		
		if(!date_pattern.test($(this).parent("td").siblings().eq("4").children("input").val())){
			alert("날짜를 정확히 입력해주세요!");
			return false;
		}
		
		$.ajax({
			type:"POST",
			url:"/dev/updateProductLaunchDate",
			data:{
				"launchDate":$(this).parent("td").siblings().eq("4").children("input").val(),
				"ddNo":($(this).attr("id").split("launchDateCheck_"))[1]
			},
			dataType:"json",
			async:false,
			success:function(data){
				if(data.result == "S"){
					successCount ++;
				}else{
					
				}
			},
			error:function(request,status,errorThrown){
				alert("오류가 발생하였습니다.");
			}
		})
		
	});
	
	
	if(checkCount == 0 ){
		
		return alert("제품정보를 체크해 주세요!");
		
	}
	
	if(successCount > 0){
		alert("성공적으로 업데이트 되었습니다.");
		$("#launchDatetBody").empty();
		$("#searchValue").val('');
		closeDialog('open');
		location.href = "/dev/newProductLaunchDate";
	}
	
}
</script>
	<div class="wrap_in" id="fixNextTag">
				<span class="path">신제품 출시일 리스트&nbsp;&nbsp;<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;<a href="#">삼립식품 연구개발시스템</a></span>
				<section class="type01">
				<!-- 상세 페이지  start-->
					<h2 style="position:relative"><span class="title_s">newProductLaunchName</span>
						<span class="title">신제품 출시일 리스트</span>
						<div  class="top_btn_box">

						</div>
					</h2>
						<div class="group01" >
	<div class="title"><!--span class="txt">연구개발시스템 공지사항</span--></div>
			<c:if test='${userUtil:getDeptCode(pageContext.request) == "dept8"}'>
					<div class="fr pb10"><button class="btn_circle_red" onClick="launchDateUpdate(); return false;"> &nbsp;</button>
					</div>
			</c:if>
				<!-- 	<div class="title7"><span class="txt">회의실 예약<strong> 연구소외에는 회의실 예약 사용이 금지되어 있습니다. </strong></span></div> -->
					<div class="tab04">
				<ul>
				<!-- 선택됬을경우는 탭 클래스에 select를 넣어주세요 -->
				<!-- 회의실이 하나밖에 없을경우는 ul은 그대로 두고 a 링크부터 li 포함한 부분 안보이게 처리 여기부터  -->
				<a href="#"><li class="select">회의실 명1</li></a>
				<a href="#"><li class="">회의실 명2</li></a>
				<!-- 회의실이 하나밖에 없을경우는 ul은 그대로 두고 a 링크부터 li 포함한 부분 안보이게 처리 여기까지  -->
				</ul>
				</div>
	<div class="re_meeting" >
		<div class="cal_header">
		<!-- 이미 지난 날짜일경우 아래 버튼 클래스에 비활성화 클래스 nouse (연한회색처리됨)를 넣어줍니다.--> 

		<!-- 캘린더 아이콘 클릭시 먼날짜 이동 -->
		<span style="display:block; width:100%; text-align:center; height:80px;"><strong><fmt:formatDate value="${now}" pattern="yyyy-MM" /><!-- <a href="#" id="monthSelect"><img src="../resources/images/btn_calendar.png"/></a> --></strong><input id="displayDateInput" type="hidden"/><br/>
		</span>
			<!-- 버튼 클릭시 일주일 단위로 전환 -->

		</div>
		<!-- <table class="tbl_meeting"> -->
		<table class="tbl01">
		<colgroup>
		<col width="10%">
		<col width="90%">
		</colgroup>
		
		<thead>
		<tr>
		<th>일자</th>
		<th>제품명</th>
		</tr>
		</thead>
		<tbody id="launchList">
		 <c:if test="${not empty launchList}">
		 	<c:forEach items="${launchList}" var="launch" varStatus="status" >
				<tr>		 	
		 			<td><span style="color:${launch.dayColor}">(${launch.DayOfWeek}) ${launch.day}일</span></td>
		 			
		 			<c:if test="${not empty launch.launchProductList }">
		 					<td>
		 				<c:forEach items="${launch.launchProductList}" var="launchProduct" varStatus="status" >
		 	
		 					<%-- <a href="#none" onclick="goDevDocDetail(${launchProduct.docNo},${launchProduct.docVersion})">${status.count}. ( ${launchProduct.productName} ) ,</a>  --%>
		 					<button type="button" style="margin:5px 5px;" class="btn_small01 ml5" onclick='goDevDocDetail(${launchProduct.docNo},${launchProduct.docVersion}); return false;'>${launchProduct.productName} </button>
		 				</c:forEach>
		 					</td>
		 			</c:if>
		 			<c:if test="${empty launch.launchProductList }">
		 				<td></td>
		 			</c:if>
				</tr>
			</c:forEach>
		 </c:if>
		</tbody>
		</table>
		 
		
		
	</div>
	
	
		
		<c:if test='${userUtil:getDeptCode(pageContext.request) == "dept8"}'>
			<div class="btn_box_con"><button type="button" class="btn_admin_red" onClick="launchDateUpdate(); return false;" >신제품 출시일 업데이트</button></div>
		</c:if>	
			 <hr class="con_mode"/><!-- 신규 추가 꼭 데려갈것 !-->
			</div>
				</section>
		</div>

<div class="white_content" id="open">
	<div class="modal" style="	width: 700px;margin-left:-350px;height: 420px;margin-top:-200px;">
		<h5 style="position:relative">
			<span class="title">신제품 출시일 업데이트</span>
			<div  class="top_btn_box">
				<ul>
					<li>
						<button type="button" class="btn_madal_close" onClick="closePopup(); return false;"></button>
					</li>
				</ul>
			</div>
		</h5>
		<div class="list_detail">
			<ul>
				<li class="pt10">
					<dt>키워드</dt>
					<dd>
						<div class="selectbox" style="width:100px;">  
								<label for="searchType" id="searchType_label">제품번호</label> 
								<select name="searchType" id="searchType">
									<option value="number">제품번호</option>
									<option value="name">제품명</option>
									<option value="code">제품코드</option>
								</select>								
						</div>		
						<input type="text" style="width:180px; margin-left:5px; float:left;" name="searchValue" id="searchValue"/>				 
						<button type="button" class="btn_small01 ml5" onClick="searchProduct(); return false;">검색</button>
					</dd>
				</li>
				<li>
					<dt>제품정보</dt>
					<dd>		
						<table class="tbl01">
							<colgroup>
							<col width="10%">
							<col width="10%">
							<col width="10%">
							<col width="20%">
							<col width="20%">
							<col width="30%">
							</colgroup> 
							<thead>
								<tr>
									<th>체크</th>
									<th>버전</th>
									<th>제품번호</th>
									<th>제품코드</th>
									<th>제품명</th>
									<th>출시일</th>
								</tr>
							</thead>
							<tbody id="launchDatetBody">
								<!-- <tr>
									<td><input type="checkbox" id="launchDateCheck" name="launchDateCheck"/>
										<label for="launchDateCheck" style="padding-right:0px;"><span></span></label>
									</td>
									<td>12</td>
									<td>22</td>
									<td>22</td>
									<td>22</td>
									<td><input type="text" style="width:180px; margin-left:5px; float:left;"/></td>
								</tr> -->
							</tbody>
						</table>	 
					</dd>
				</li>
			</ul>
		</div>
		<div class="btn_box_con">
			<button type="button" class="btn_admin_red" id="insertForm" onClick="updateLaunchDate(); return false;">출시일 수정</button> 
			<button type="button" class="btn_admin_gray"onclick="closePopup(); return false;"> 취소</button>
		</div>
	</div>
</div>

 