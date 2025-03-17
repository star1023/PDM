<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page session="false" %>
	<link href="/resources/css/common.css?param=1" rel="stylesheet" type="text/css" />
	<link href="/resources/css/board.css" rel="stylesheet" type="text/css" />
	<link href="/resources/css/layout.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
$(document).ready(function(){
	$("#designKeyword").autocomplete({
		minLength: 1,
	    delay: 300,
		source: function( request, response ) {
	        $.ajax( {
	          type:"POST",
	          url: "/approval/searchUser",
	          dataType: "json",
	          data: {
	        	  "keyword": $("#designKeyword").val(),
				   "userGrade" : ''
	          },
	          async:false,
	          success: function( data ) {
	        	response($.map(data.data, function(item){
	        		/* return {
                      label: item.userName+" / "+item.deptFullName,
                      value: item.userName,
                      userId : item.userId,
                      deptFulName : item.deptFullName,
                      titCodeName: item.titCodeName,
                      userName : item.userName
        			}; */
        			return {
                        label: item.userName+" / "+item.deptFullName,
                        value: item.userName,
                        userId : item.userId,
                        deptFulName : item.deptFullName,
                        titCodeName: item.titCodeName,
                        userName : item.userName
          			};
       			}));
	          }
	        } );
	      },
	      
	      select : function(event,ui){
	    	
	    	$("#deptFulName").val('');
		   	$("#titCodeName").val('');
		    $("#userId").val('');
		    $("#userName").val('');  
	    	  
	    	$("#deptFulName").val(ui.item.deptFulName);
	    	$("#titCodeName").val(ui.item.titCodeName);
	    	$("#userId").val(ui.item.userId);
	    	$("#userName").val(ui.item.userName);
	      },
	      focus: function( event, ui ) {
	    	return false;
	      }
	});
	
	$("#manufacKeyword").autocomplete({
		minLength: 1,
	    delay: 300,
		source: function( request, response ) {
	        $.ajax( {
	          type:"POST",
	          url: "/approval/searchUser",
	          dataType: "json",
	          data: {
	        	  "keyword": $("#manufacKeyword").val(),
				   "userGrade" : ''
	          },
	          async:false,
	          success: function( data ) {
	        	response($.map(data.data, function(item){
	        		return {
                      label: item.userName+" / "+item.deptFullName,
                      value: item.userName,
                      userId : item.userId,
                      deptFulName : item.deptFullName,
                      titCodeName: item.titCodeName,
                      userName : item.userName
        			};
       			}));
	          }
	        } );
	      },
	      
	      select : function(event,ui){
	    	
	    	$("#deptFulName").val('');
		   	$("#titCodeName").val('');
		    $("#userId").val('');
		    $("#userName").val('');  
	    	  
	    	$("#deptFulName").val(ui.item.deptFulName);
	    	$("#titCodeName").val(ui.item.titCodeName);
	    	$("#userId").val(ui.item.userId);
	    	$("#userName").val(ui.item.userName);
	      },
	      focus: function( event, ui ) {
	    	return false;
	      }
	});
	
	$(document).on("click","[name=delImg]",function(){ 
		
		var id = $(this).parent().attr("id");
		
		var popupId = $(this).parents("div.white_content").attr("id");
		
		if(id == 'designPayment1' || id== "manufacPayment1"){
			
			$(this).parent().html('<img src="../resources/images/icon_del_file.png" name="delImg"><span>1차 검토 </span>  <strong></strong>');
		
			if(popupId == 'open5'){
				$("#userId2").val('');
			}else{
				$("#userId2Manu").val('');
			}
			
		}else if(id == 'designPayment2' || id =="manufacPayment2"){
			
			$(this).parent().html('<img src="../resources/images/icon_del_file.png" name="delImg"><span>2차 검토 </span>  <strong></strong>');
			
			if(popupId =='open5'){
				$("#userId3").val('');
			}else{
				$("#userId3Manu").val('');
			}
				
		}else if(id == 'designPaymentMarketing'){
		
			$(this).parent().html('<img src="../resources/images/icon_del_file.png" name="delImg"><span>마케팅 </span>  <strong></strong>');
		
			$("#userId4").val('');
			
		}else if(id=='manufacPaymentParter'){
		
			$(this).parent().html('<img src="../resources/images/icon_del_file.png" name="delImg"><span>파트장</span>  <strong></strong>');
			
			$("#userId4Manu").val('');
			
		}else if(id=='manufacPaymentLeader'){
			
			$(this).parent().html('<img src="../resources/images/icon_del_file.png" name="delImg"><span>팀장</span>  <strong></strong>');
			
			$("#userId5Manu").val('');
			
		}else if(id=='manufacPaymentDirector'){
			
			$(this).parent().html('<img src="../resources/images/icon_del_file.png" name="delImg"><span>연구소장</span>  <strong></strong>');
			
			$("#userId6Manu").val('');
			
		}else{
			$(this).parent().remove();
			
			var userId = $(this).parent().children("input").val();
			
			if($(this).parent().children("span").text()=='참조'){
				
				var userIdTemp = [];
				
				if(popupId == 'open5'){
					userIdTemp =  $("#userId5").val().split(",");
				}else{
					userIdTemp =  $("#userId7Manu").val().split(",");
				}
				
				for(var i = 0; i<userIdTemp.length; i++){
					
					if(userId == userIdTemp[i]){
						
						userIdTemp.splice(i,1);
						
					   break;
					}
		
				}
				
				if(popupId == 'open5'){
					$("#userId5").val(userIdTemp.reverse().join(","));
				}else{
					$("#userId7Manu").val(userIdTemp.reverse().join(","));
				}
				
			}else{
				
				var userIdTemp =  [];
				
				if(popupId == 'open5'){
					userIdTemp =  $("#userId6").val().split(",");
				}else{
					userIdTemp =  $("#userId8Manu").val().split(",");
				}
				
				for(var i = 0; i<userIdTemp.length; i++){
					
					if(userId == userIdTemp[i]){
						
						userIdTemp.splice(i,1);
						
					   break;
					}
					
				 }
				
				if(popupId == 'open5'){
					$("#userId6").val(userIdTemp.reverse().join(","));
				}else{
					$("#userId8Manu").val(userIdTemp.reverse().join(","));
				}
				
			}
			
		}
		
		
	});
})

var payment1 = 0;

var payment2 = 0;

var paymentMarketing = 0;

function approvalAddLine(obj){
	
	//apprType 1차:2 2차:3    마케팅:4    참조:R 회람:C
	
	popupId = $(obj).parents("div.white_content").attr("id");
	
	if(popupId == 'open5'){
		
		if($("#designKeyword").val() =='' && $("#userName").val() ==''){
			alert("정확한 사원을 입력하세요!");
			return false;
		}
		
	}else{
		
		if($("#manufacKeyword").val() ==''  && $("#userName").val() ==''){
			alert("정확한 사원을 입력하세요!");
			return false;
		}
		
	}

	var overApprTypeText = "";
	var drCon = ['yeorin', 'dlach8', 'admin']; // 1차 검토자 아이디가 여기 없을경우 얼럿
	var tarId = "";
	var retVal = true;

	var name = $(obj).attr("name");
	
	var html = '';
	
	tarId = $("#userId").val();
	
	if(name=="firstPayment"){
		
		html = '<img src="../resources/images/icon_del_file.png" name="delImg"><span>1차 검토</span>'+$("#userName").val()+'<strong>'+$("#titCodeName").val()+'/'+$("#deptFulName").val()+'</strong><input type="hidden" value='+$("#userId").val()+'>';
		
		if(popupId == "open5"){
			var retVal = $.inArray(tarId,drCon);
			
			if(retVal < 0 ){
				alert("디자인의뢰서 1차 검토자는 \n임초롱, 유여린 연구원입니다.");
				return false;
			}
		
		
			if($("#designPayment1 strong").text()!='' && $("#designPayment1 strong").text() != null){
				alert("이미 추가된 1차 결제자가 있습니다.");
				return false;
			}
		
			$("#designPayment1").html(html);
		
			$("#userId2").val($("#userId").val());
		
		}else{
			
			if($("#manufacPayment1 strong").text()!='' && $("#manufacPayment1 strong").text() != null){
				alert("이미 추가된 1차 결제자가 있습니다.");
				return false;
			}
			
			$("#manufacPayment1").html(html);
			
			$("#userId2Manu").val($("#userId").val());
			
		}

	}else if(name=="secondPayment"){
		
		html = '<img src="../resources/images/icon_del_file.png" name="delImg"><span>2차 검토</span>'+$("#userName").val()+'<strong>'+$("#titCodeName").val()+'/'+$("#deptFulName").val()+'</strong><input type="hidden" value='+$("#userId").val()+'>';
		
		if(popupId == "open5"){
			
			if($("#designPayment2 strong").text()!='' && $("#designPayment2 strong").text() != null){
				alert("이미 추가된 2차 결제자가 있습니다.");
				return;
			}
			
			$("#designPayment2").html(html);
			
			$("#userId3").val($("#userId").val());
			
		}else{
			
			if($("#manufacPayment2 strong").text()!='' && $("#manufacPayment2 strong").text() != null){
				alert("이미 추가된 2차 결제자가 있습니다.");
				return false;
			}
			
			$("#manufacPayment2").html(html);
			
			$("#userId3Manu").val($("#userId").val());
			
		}
		
	}else if(name=="marketingPayment"){
		
			
			if($("#designPaymentMarketing strong").text()!='' && $("#designPaymentMarketing strong").text() != null){
				alert("이미 추가된 마케팅 결제자가 있습니다.");
				return;
			}
			
			html = '<img src="../resources/images/icon_del_file.png" name="delImg"><span>마케팅</span>'+$("#userName").val()+'<strong>'+$("#titCodeName").val()+'/'+$("#deptFulName").val()+'</strong><input type="hidden" value='+$("#userId").val()+'>';
			
			$("#designPaymentMarketing").html(html);
			
			$("#userId4").val($("#userId").val());
			
	}else if(name=="circulationPayment" || name=="referPayment"){
		
		if(popupId == 'open5'){
			if(name=="referPayment"){

				if($("#userId5").val() == ""){
					$("#userId5").val($("#userId").val());
				}else{
					
					var existId = $("#userId5").val();
					
					$("#userId5").val(existId+","+$("#userId").val());
					
				}
				
				$("#CirculationRefLi").append('<li><img src="../resources/images/icon_del_file.png" name="delImg"><span>참조</span>'+$("#userName").val()+'<strong>'+$("#titCodeName").val()+'/'+$("#deptFulName").val()+'</strong><input type="hidden" name="userId" value='+$("#userId").val()+'><input type="hidden" name="apprType" value="R"></li>');
			}else{
				
				if($("#userId6").val() == ""){
					$("#userId6").val($("#userId").val());
				}else{
					
					var existId = $("#userId6").val();
					
					$("#userId6").val(existId+","+$("#userId").val());
					
				}
				
				$("#CirculationRefLi").append('<li><img src="../resources/images/icon_del_file.png" name="delImg"><span>회람</span>'+$("#userName").val()+' <strong>'+$("#titCodeName").val()+'/'+$("#deptFulName").val()+'</strong><input type="hidden" name="userId" value='+$("#userId").val()+'><input type="hidden" name="apprType" value="C"></li>');
			}
		}else{
			
			if(name=="referPayment"){
				if($("#userId7Manu").val() == ""){
					$("#userId7Manu").val($("#userId").val());
				}else{
					
					var existId = $("#userId7Manu").val();
					
					$("#userId7Manu").val(existId+","+$("#userId").val());
					
				}
				
				$("#CirculationLefLiManu").append('<li><img src="../resources/images/icon_del_file.png" name="delImg"><span>참조</span>'+$("#userName").val()+'<strong>'+$("#titCodeName").val()+'/'+$("#deptFulName").val()+'</strong><input type="hidden" name="userId" value='+$("#userId").val()+'><input type="hidden" name="apprType" value="R"></li>');
			}else{
				if($("#userId8Manu").val() == ""){
					$("#userId8Manu").val($("#userId").val());
				}else{
					
					var existId = $("#userId8Manu").val();
					
					$("#userId8Manu").val(existId+","+$("#userId").val());
					
				}
				
				$("#CirculationLefLiManu").append('<li><img src="../resources/images/icon_del_file.png" name="delImg"><span>회람</span>'+$("#userName").val()+' <strong>'+$("#titCodeName").val()+'/'+$("#deptFulName").val()+'</strong><input type="hidden" name="userId" value='+$("#userId").val()+'><input type="hidden" name="apprType" value="C"></li>');
			}
			
		}
		
		
		}else if(name=='parterPayment'){
			if($("#manufacPaymentParter strong").text()!='' && $("#manufacPaymentParter strong").text() != null){
				alert("이미 추가된 파트장 결제자가 있습니다.");
				return;
			}
			
			html = '<img src="../resources/images/icon_del_file.png" name="delImg"><span>파트장</span>'+$("#userName").val()+'<strong>'+$("#titCodeName").val()+'/'+$("#deptFulName").val()+'</strong><input type="hidden" value='+$("#userId").val()+'>';
			
			$("#manufacPaymentParter").html(html);
			
			$("#userId4Manu").val($("#userId").val());
		}else if(name=='leaderPayment'){
			if($("#manufacPaymentLeader strong").text()!='' && $("#manufacPaymentLeader strong").text() != null){
				alert("이미 추가된 팀장 결제자가 있습니다.");
				return;
			}
			
			html = '<img src="../resources/images/icon_del_file.png" name="delImg"><span>팀장</span>'+$("#userName").val()+'<strong>'+$("#titCodeName").val()+'/'+$("#deptFulName").val()+'</strong><input type="hidden" value='+$("#userId").val()+'>';
			
			$("#manufacPaymentLeader").html(html);
			
			$("#userId5Manu").val($("#userId").val());
		}else{
			if($("#manufacPaymentDirector strong").text()!='' && $("#manufacPaymentDirector strong").text() != null){
				alert("이미 추가된 연구소장 결제자가 있습니다.");
				return;
			}
			
			html = '<img src="../resources/images/icon_del_file.png" name="delImg"><span>연구소장</span>'+$("#userName").val()+'<strong>'+$("#titCodeName").val()+'/'+$("#deptFulName").val()+'</strong><input type="hidden" value='+$("#userId").val()+'>';
			
			$("#manufacPaymentDirector").html(html);
			
			$("#userId6Manu").val($("#userId").val());
		}
	
}

function changeApprLine(){
	var apprLineNo = $("#apprLineSelect").val();
	
	$("#designPayment1").html('<img src="../resources/images/icon_del_file.png" name="delImg"><span>1차 검토 </span>  <strong></strong>');
	
	$("#designPayment2").html('<img src="../resources/images/icon_del_file.png" name="delImg"><span>2차 검토 </span>  <strong></strong>');
	
	$("#designPaymentMarketing").html('<img src="../resources/images/icon_del_file.png" name="delImg"><span>마케팅 </span>  <strong></strong>');
	
	$("#CirculationRefLi").empty();
	
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
							var deptName = data.data[i].deptCodeName;
							var titleName = data.data[i].gradeCodeName;
							var userName = data.data[i].userName;
							var targetUserId = data.data[i].targetUserId;
							
							//결제선 리스트 뿌리기 향후 진행...
							
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
}

function approvalLineSave(obj){
	
	var obj = $(obj);
	
	var lineName = obj.parent().children("input").val();
	
	var tbType = "";
	
	if(lineName =='' || lineName == undefined){
		alert("저장 결제선명 입력하세요!");
		return;
	}
	
	/* var CirRefLength = $("#CirculationRefLi li").length; */
	
	var CirRefLength = 0;
	
	var popupId = obj.parents("div.white_content").attr("id");
	
	var Payment1Id = '';
	
	var Payment2Id = '';
	
	if(popupId == 'open5'){
		
		CirRefLength = $("#CirculationRefLi li").length;
		Payment1Id = $("#designPayment1 input").val();
		Payment2Id = $("#designPayment2 input").val();
		
	}else{
		
		CirRefLength = $("#CirculationLefLiManu li").length;
		Payment1Id = $("#manufacPayment1 input").val();
		Payment2Id = $("#manufacPayment2 input").val();
		
	}
		
	var PaymentMarketingId = $("#designPaymentMarketing input").val();
	
	var PaymentParterId = $("#manufacPaymentParter input").val();
	
	var PaymentLeaderId = $("#manufacPaymentLeader input").val();
	
	var PaymentDirectorId = $("#manufacPaymentDirector input").val();
	
	if(CirRefLength == 0 && Payment1Id == '' && Payment2Id == ''){
	
		if(popupId == 'open5'){
			if(PaymentMarketingId == ''){
				alert("최소 한명 이상 결재선을 지정해주세요.!");
				return;
			}
		}else{
			if(PaymentParterId == '' && PaymentLeaderId == '' && PaymentDirectorId == ''){
				alert("최소 한명 이상 결재선을 지정해주세요.!");
				return;
			}	
		}
	
	}
	
	var targetIdArr = [];
	
	var apprTypeArr = [];
	
	if(Payment1Id != '' && Payment1Id != undefined){
		targetIdArr.push(Payment1Id);
		apprTypeArr.push("2");
	}
	
	if(Payment2Id != '' && Payment2Id != undefined){
		targetIdArr.push(Payment2Id);
		apprTypeArr.push("3");
	}
	
	if(popupId == 'open5'){
		
		if(PaymentMarketingId !='' && PaymentMarketingId != undefined){
			targetIdArr.push(PaymentMarketingId);
			apprTypeArr.push("4");
		}
		
	}else{
		
		if(PaymentParterId !='' && PaymentParterId != undefined){
			targetIdArr.push(PaymentParterId);
			apprTypeArr.push("4");
		}
		
		if(PaymentLeaderId !='' && PaymentLeaderId != undefined){
			targetIdArr.push(PaymentLeaderId);
			apprTypeArr.push("5");
		}
		
		if(PaymentDirectorId !='' && PaymentDirectorId != undefined){
			targetIdArr.push(PaymentDirectorId);
			apprTypeArr.push("6");
		}
	}
	
	if(CirRefLength != 0){
		
		for(var i =0; i<CirRefLength; i++){
			
			if(popupId == 'open5'){
				targetIdArr.push($("#CirculationRefLi li input[name=userId]").eq(i).val());
				apprTypeArr.push($("#CirculationRefLi li input[name=apprType]").eq(i).val());
			}else{
				targetIdArr.push($("#CirculationLefLiManu li input[name=userId]").eq(i).val());
				apprTypeArr.push($("#CirculationLefLiManu li input[name=apprType]").eq(i).val());
			}
				
		}
		
	}
	
	switch(popupId)
	{
		case "open":
	
		break;
		case "open2":
		
		break;
		case "open5":
			tbType = "designRequestDoc";
		break;
		case "open6":
			tbType = "manufacturingProcessDoc";
		default:
			
	}
	
	$.ajax({
		type:"POST",
		url:"/approval/approvalLineSave",
		data:{"lineName": lineName,
			   "tbType":tbType,
			   "targetIdArr":targetIdArr,
			   "apprTypeArr":apprTypeArr},
		dataType:"json",
		async:false,
		traditional:true,
		success:function(data) {
			if(data.status == 'success'){
	        	alert("성공적으로 저장되었습니다	.");	
				document.location="/devdocManagement/docReviewRequestPopup";
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

var manuTbKey = "";

function doSubmit(obj){
	var obj = $(obj);
	
	var popupId = obj.parents("div.white_content").attr("id");
	
	var msg = "상신하시겠습니까?";
	
	if(!validate(obj)){
		return;
	}
	
	if(popupId == 'open5'){
		
		var tbType = "designRequestDoc";
		var chkKey = "";
/* 선택한 디자인의뢰서 개수 	var dataSize =   */
		
		<%-- 
		디자인의뢰서 상신 클릭시  디자인 의뢰서를 몇개 선택했는지에 따라 로직을 처리한다.
		if(dataSize > 1) {
			$("input[name=chk]").each(function(){
				if($(this).is(":checked")){
					chkKey = $(this).val(); 
					return;
				}
			});						
			if(chkKey == ""){
				alert("대상 <%=pageTitle%>를 선택하세요.");
				return;
			}					
			
			//체크된 해당 디자인의뢰서번호
			document.approvalForm.tbKey.value = chkKey;
			document.approvalForm.tempKey.value = "0";					
		} else {
			document.approvalForm.tbKey.value = "0";
			//해당버버전고유번호를 넘겨줌.
			document.approvalForm.tempKey.value = "<%=tbKey%>";
		}	 --%>
	}else{
		
	}
	
	if(confirm(msg)){
		
		if(popupId == 'open5'){
			$.ajax({
				type:"POST",
				url:"/devdocManagement/docReviewRequestSave",
				data:{ 
					   "tbType":"designRequestDoc",
					   "tbKey": "",
					   "tempKey": "",
					   "title" : $("#designTitle").val(),
					   "userId2" : $("#userId2").val(),
					   "userId3" : $("#userId3").val(),
					   "userId4" : $("#userId4").val(),
					   "referenceId" : $("#userId5").val(),
					   "circulationId" : $("#userId6").val()
					   },
				dataType:"json",
				async:false,
				traditional:true,
				success:function(data) {
					if(data.status == 'success'){
			        	alert(data.nextText);	
						document.location="/devdocManagement/docReviewRequestPopup";
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
			
		}else{
			$.ajax({
				type:"POST",
				url:"/approval/approvalLineSave",
				data:{"lineName": lineName,
					   "tbType":"manufacturingProcessDoc",
					   "targetIdArr":targetIdArr,
					   "apprTypeArr":apprTypeArr},
				dataType:"json",
				async:false,
				traditional:true,
				success:function(data) {
					if(data.status == 'success'){
			        	alert("성공적으로 처리되었습니다	.");	
						document.location="/devdocManagement/docReviewRequestPopup";
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
		
		
	} }
	


function validate(obj){
	
	var popupId = obj.parents("div.white_content").attr("id");
	
	if(popupId == 'open5'){
		
		if($("#userId2").val() == "" && $("#userId2").val() == undefined){
			alert("1차 검토자를 지정하세요.");
			return false;
		}
		
		if($("#userId3").val() == "" && $("#userId3").val() == undefined){
			alert("2차 검토자를 지정하세요.");
			return false;
		}
		
		if($("#userId4").val () == "" && $("#userId4").val() == undefined)
			alert("마케팅 담당자를 지정하세요.");
			return false;
		
		if($("#designTitle").val() == "" && $("#designTitle").val() == undefined){
			alert("제목을 입력하세요.");
			return false;
		}	
			
	}else{
		
		var user2 = $("#userId2Manu").val();		//합의1
		var user3 = $("#userId3Manu").val();		//합의2
		var user4 = $("#userId4Manu").val();		//파트장
		var user5 = $("#userId5Manu").val();		//팀장
		var user6 = $("#userId6Manu").val();		//연구소장
		var user7 = $("#userId7Manu").val();		//참조
		var user8 = $("#userId8Manu").val();		//회람
		
		var title = $("#manuTitle").val();
		var tbKey  = "";
		
		if($("#launchDate").val() == ""){
			alert("제품 출시일을 지정하세요.");
			return false;
		}
		
		if(user4 == "" && user5 == "" && user6 ==""){
			alert("1명 이상의 결재선을 지정하세요.");
			return false;
		}
		
		
	}
	
	
}

function openDialog(id){
	
	$('#'+id).show();
}

function closeDialog(id){
	
	$('#'+id).hide();
	
}
</script>
<div class="wrap_in" id="fixNextTag">
				<span class="path">제품개발문서&nbsp;&nbsp;<img src="../resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;<a href="#">삼립식품 연구개발시스템</a></span>
				<section class="type01">
				<!-- 상세 페이지  start-->
					<h2 style="position:relative"><span class="title_s">Product Design Doc</span>
						<span class="title">제품개발문서 상세</span>
						<div  class="top_btn_box">
							<ul>
							
							<li><button class="btn_circle_del" onClick="location.href='predoc.html'">&nbsp;</button></li>
							<li><button class="btn_circle_modifiy" onClick="location.href='#open'">&nbsp;</button></li>
							<li><button class="btn_circle_version" onClick="location.href='predoc.html'">&nbsp;</button></li>
							<li><button class="btn_circle_bom" onClick="location.href='predoc.html'">&nbsp;</button></li>
							</ul>
						</div>
					</h2>
					
					<div class="group01">
						<div class="title"><!--span class="txt">그룹소제목</span--></div>
						<div class="tab03">
				<ul>
				<!-- 선택됬을경우는 탭 클래스에 select를 넣어주세요 -->
				<!-- 내 제품설계서 같은경우는 change select 이렇게 change 그대로 두고 한칸 띄고 select 삽입 -->
				<a href="#"><li class="select">[최신] Version 3</li></a>
				<a href="#"><li class="">Version 2</li></a>
				<a href="#"><li class="">Version 1</li></a>
				</ul>
				</div>
						<div class="prodoc_title" style="margin-bottom:30px;">
							<div style=" width:100px; height:100px; display:inline-block; vertical-align:top;" class="product_img"><img src="../resources/images/img_sample.png"></div>
							<div style="display:inline-block; height:80px; width:900px; padding-top:20px;">
								<span class="font17">제품명 : 츄러스</span>
								<span>
									<ul class="list_ul3">
										<li ><a href="#">진행중</a></li><li ><a href="#">보류</a></li><li class="select"><a href="#">진행중단</a></li>
									</ul>
									</span>
								<br/><span class="font20">제품설명 : 뿜뿜 제품설명 뿜뿜제품 설명 뿜뿜 제품설명 뿜뿜제품 설명 뿜뿜\</span><br/>
									<span class="font18">제품유형 :  빵류(가열하여 섭취하는 냉동식품) <strong>&nbsp;|&nbsp;</strong>출시일 :  2019-01-12</span><br/>
								
								
								<span class="font21">버전업사유 : 신규 선물세트 출시로 인한 구성변경</span>
						</div>
					</div>
						<div class="fr pt10"><button class="btn_con_search" onClick="location.href='#open2'"><img src="../resources/images/icon_s_write.png"/> 제조공정서 생성</button> <button class="btn_con_search" onClick="openDialog('open6'); return false;"><img src="../resources/images/icon_s_approval.png"/> 선택 제조공정서 결재상신</button>
					</div>
					<div class="title2"><span class="txt">제조공정서</span></div>
					<div class="main_tbl" style="padding-bottom:40px;">
								<table class="tbl04">
									<colgroup>
									<col width="40px">
									<col width="60px">
									<col width="90px">
									<col width="90px">
									<col />
									<col width="110px">
									<col width="80px">
									<col width="70px">
									<col width="70px">
									<col width="70px">
									<col width="31%">
									</colgroup>
									<thead>
									<tr>
										<th></th>
									<th>번호</th>
									<th>대체BOM</th>
									<th>공장</th>
									<th>라인</th>
									<th>상태</th>
									<th>작성일</th>
									<th>작성자</th>
									<th>수정일</th>
									<th>수정자</th>
									<th>문서설정</th>
									</tr>
									</thead>
										<tbody>
									
											<Tr>
											<td><input type="checkbox" checked/  id="c1" name="cc" ><label for="c1"><span></span></label></td>
										<Td>01</Td>
										<Td>01</Td>
										<Td>대구샌드팜</Td>
										<Td><a href="#">샌드위치 라인(WF101)</a></Td>
										<Td><a href="#">ERP 반영 완료</a></Td>
										<Td>2017.01.12 22:01:12</Td>
										<Td>김진영</Td>
										<Td>2017.01.12 22:01:12</Td>
										<Td>김진영</Td>
										<Td>
										<ul class="list_ul">
										<li><button class="btn_doc"><img src="../resources/images/icon_doc01.png"> 보기</button></li>
										<li><button class="btn_doc" ><img src="../resources/images/icon_doc02.png"> 복사</button></li>
										<li><button class="btn_doc" ><img src="../resources/images/icon_doc03.png"> 수정</button></li>
										<li><button class="btn_doc" onClick="location.href='#open7'"><img src="../resources/images/icon_doc05.png" > 수정내역</button> <span style="background-color:#ed554b; padding:1px 5px 1px 5px; border-radius:10px; font-size:11px; color:#fff;">9</span></li>
										<li><button class="btn_doc"><img src="../resources/images/icon_doc09.png"> 링크복사</button></li>
										<li><button class="btn_doc"><img src="../resources/images/icon_doc08.png"> 이력</button></li>
										<li><button class="btn_doc"><img src="../resources/images/icon_doc06.png"> 중지</button></li>
										<li><button class="btn_doc"><img src="../resources/images/icon_doc04.png"> 삭제</button></li>
								
										<li><button class="btn_doc"><img src="../resources/images/icon_doc07.png"></button></li>
										</ul> 
										</Td>
							</Tr>
								<Tr>
								<td><input type="checkbox" checked/  id="c1" name="cc" ><label for="c1"><span></span></label></td>
										<Td>01</Td>
										<Td>01</Td>
										<Td>대구샌드팜</Td>
										<Td><a href="#">샌드위치 라인(WF101)</a></Td>
										<Td><a href="#">ERP 반영 완료</a></Td>
										<Td>2017.01.12 22:01:12</Td>
										<Td>김진영</Td>
										<Td>2017.01.12 22:01:12</Td>
										<Td>김진영</Td>
										<Td>
										<ul class="list_ul">
										<li><button class="btn_doc"><img src="../resources/images/icon_doc01.png"> 보기</button></li>
										<li><button class="btn_doc" ><img src="../resources/images/icon_doc02.png"> 복사</button></li>
										<li><button class="btn_doc" ><img src="../resources/images/icon_doc03.png"> 수정</button></li>
										<li><button class="btn_doc" onClick="location.href='#open7'"><img src="../resources/images/icon_doc05.png" > 수정내역</button></li>
										<li><button class="btn_doc"><img src="../resources/images/icon_doc09.png"> 링크복사</button></li>
										<li><button class="btn_doc"><img src="../resources/images/icon_doc08.png"> 이력</button></li>
										<li><button class="btn_doc"><img src="../resources/images/icon_doc06.png"> 중지</button></li>
										<li><button class="btn_doc"><img src="../resources/images/icon_doc04.png"> 삭제</button></li>
								
										<li><button class="btn_doc"><img src="../resources/images/icon_doc07.png"></button></li>
										</ul> 
										</Td>
							</Tr>
									
										</tbody>
								</table>
						</div>
					<div class="fr pt10 pb10"><button class="btn_con_search"  onClick="openDialog('open3'); return false;"><img src="../resources/images/icon_s_write.png"/> 디자인의뢰서 생성</button> <button class="btn_con_search" onClick="openDialog('open5'); return false;" id="test"><img src="../resources/images/icon_s_com.png"/> 선택 디자인의뢰서 검토요청</button></div>
									<div class="title3"><span class="txt">디자인의뢰서</span></div>
									
									<div class="main_tbl" style="padding-bottom:40px;">
												<table class="tbl04">
													<colgroup>
													<col width="40px">
													<col width="60px">
													<col />
													<col width="12%">
													
													<col width="12%">
													<col width="6%">
													
													<col width="12%">
													<col width="6%">
													<col width="250px">
												
													</colgroup>
													<thead>
													<tr>
													<th></th>
													<th>번호</th>
													<th>문서명</th>
													<th>상태</th>
													<th>작성일</th>
													<th>작성자</th>
													<th>수정일</th>
													<th>수정자</th>
													<th>문서설정</th>
													</tr>
													</thead>
														<tbody>
														
															<Tr>
															<td><input type="checkbox" checked/  id="c1" name="cc" ><label for="c1"><span></span></label></td>
																	<Td>01</Td>
																	<Td ><div class="ellipsis_txt tgnl"><a href="#">츄러스2차 설계</a><span class="icon_new">N</span></div></Td>
																	<Td><a href="#">최종반영완료</a></Td>
																	<Td>2017.01.12 22:01:12</Td>
																	<Td>서현민</Td>
																	<Td>2017.01.12 22:01:12</Td>
																	<Td>서현민</Td>
																	<Td>
																			<ul class="list_ul">
																					<li><button class="btn_doc"><img src="../resources/images/icon_doc01.png"> 보기</button></li>
																					<li><button class="btn_doc"><img src="../resources/images/icon_doc02.png"> 복사</button></li>
																					<li><button class="btn_doc"><img src="../resources/images/icon_doc03.png"> 링크복사</button></li>
																					<li><button class="btn_doc"><img src="../resources/images/icon_doc04.png"> 삭제</button></li>
																					</ul> 
																			</Td>
															</Tr>
														<Tr>
														<td><input type="checkbox" checked/  id="c1" name="cc" ><label for="c1"><span></span></label></td>
																	<Td>02</Td>
																	<Td ><div class="ellipsis_txt tgnl"><a href="#">츄러스2차 설계</a><span class="icon_new">N</span></div></Td>
																	<Td><a href="#">최종반영완료</a></Td>
																	<Td>2017.01.12 22:01:12</Td>
																	<Td>서현민</Td>
																	<Td>2017.01.12 22:01:12</Td>
																	<Td>서현민</Td>
																	<Td>
																			<ul class="list_ul">
																					<li><button class="btn_doc"><img src="../resources/images/icon_doc01.png"> 보기</button></li>
																					<li><button class="btn_doc"><img src="../resources/images/icon_doc02.png"> 복사</button></li>
																					<li><button class="btn_doc"><img src="../resources/images/icon_doc03.png"> 링크복사</button></li>
																					<li><button class="btn_doc"><img src="../resources/images/icon_doc04.png"> 삭제</button></li>
																					</ul> 
																			</Td>
															</Tr>
														
														
													
														</tbody>
												</table>
							
						
						</div>
									
								<div class="fr pt10"><button class="btn_con_search" onClick="location.href='#open4'"><img src="../resources/images/icon_s_file.png"/> 파일첨부</button></div>
								<div class="title4"><span class="txt">파일첨부</span></div>
								<div class="con_file" style="padding-bottom:40px;">
									<ul>
										<li class="point_img">
											<dt>1, 제품이미지</dt><dd>
												<ul>
													<li><a href="#">ddd</a> ( 관리자/2018-07-11 21:27:18 ) <button class="btn_doc"><img src="../resources/images/icon_doc04.png"> 삭제</button> | <button class="btn_doc"><img src="../resources/images/icon_doc11.png"> 이미지확인</button></li>
													<li><a href="#">ddd</a> ( 관리자/2018-07-11 21:27:18 ) <button class="btn_doc"><img src="../resources/images/icon_doc04.png"> 삭제</button> | <button class="btn_doc"><img src="../resources/images/icon_doc11.png"> 이미지확인</button></li>
												</ul>
											
											
											</dd>
										</li>
										<li>
											<dt>2, 포장지시안</dt><dd></dd>
										</li>
									<li>
											<dt>3, 품목제조보고서사본</dt><dd></dd>
										</li>
										<li>
											<dt>4, HACCP 문서</dt><dd></dd>
										</li>
				
								</div>
											
									
		<div class="btn_box_con5">
			<button class="btn_admin_gray" onClick="location.href='predoc_design.html'"  style="width:120px;">목록</button>
			</div>
			<div class="btn_box_con4">
			
			<button class="btn_admin_red">BOM 반영</button>
			<button class="btn_admin_sky">제품버전업</button>
			<button class="btn_admin_navi" style="width:120px;" onClick="location.href='#open'">수정</button>
			<button class="btn_admin_gray" style="width:120px;">삭제</button>
			</div>
			 <hr class="con_mode"/><!-- 신규 추가 꼭 데려갈것 !-->
			</div>
			</section>
		</div>
	
		<!-- 유저 선택시 해당 값 히든처리 -->
			<input type="hidden" id="deptFulName" />
			<input type="hidden" id="titCodeName" />
			<input type="hidden" id="userId" />
			<input type="hidden" id="userName"/>
			
<!-- 제품개발문서생성레이어 start-->
	 <div class="white_content" id="open">
		<div class="modal" style="	width: 700px;margin-left:-350px;height: 510px;margin-top:-250px;">
		  <h5 style="position:relative">
				<span class="title">제품 개발문서 수정</span>
				<div  class="top_btn_box">
					<ul><li><button class="btn_madal_close" onClick="location.href='#close'"></button></li></ul>
				</div>
			</h5>
			<div class="list_detail">
		<ul>
		<li class="pt10">
			<dt>제품명</dt>
				<dd>
				<input type="text" class="req" style="width:302px;" placeholder="입력필수"/>
				</dd>
			</li>
			<li>
			<dt>제품코드</dt>
				<dd>
				<input type="text"  style="width:202px;"/><button class="btn_small_search ml5" >검색</button>
				</dd>
			</li>
			
				<li>
			<dt>가열여부</dt>
				<dd>
							<!-- 초기값은 전체로 -->
							<form id="form3" method="post" action="">
							 <input type="radio" id="r22" name="rr" checked/><label for="r22"><span></span>가열</label>
							 <input type="radio" id="r33" name="rr" ><label for="r33"><span></span>비가열</label>
							 </form>
				</dd>
			</li>
				<li>
			<dt>출시일</dt>
				<dd>
				<input type="text" style="width:170px;"readonly="readonly" value="2018.01.12"> <a href="#"><img src="../resources/images/btn_calendar.png"></a>
				</dd>
			</li>
				<li>
				
			<dt>제품유형</dt>
				<dd>
				<div class="selectbox req" style="width:500px;">  
						<label for="ex_select">제품유형 선택</label> 
						<select id="ex_select">
						
							<option selected>제품유형1</option>
							<option>제품유형2</option>
							<option>제품유형3</option>
						</select>
						</div>
				</dd>
			</li>
			<li>
			<dt>제품설명</dt>
				<dd class="pr20 pb20">
							<textarea style="width:100%; height:100px"></textarea>
						
						</dd>
			</li>
			
			
		</ul>
	</div>
	<div class="btn_box_con"><button class="btn_admin_red"onclick="location.href='predoc.html'">생성</button></div>
	</div>
</div>
	<!-- 제품개말분서생성레이어 close-->
	<!-- 제조공정서 생성레이어 start-->
	<!-- 신규로 레이어창을 생성하고싶을때는  아이디값 교체-->
	<!-- 클래스 옆에 적힌 스타일 값을 인라인으로 작성해서 팝업 사이즈를 직접 조정 -->
	 <div class="white_content" id="open2">
		<div class="modal" style="	margin-left:-455px;width:910px;height: 450px;margin-top:-225px">
		  <h5 style="position:relative">
				<span class="title">제조공정서 생성</span>
				<div  class="top_btn_box">
					<ul><li><button class="btn_madal_close" onClick="location.href='#close'"></button></li></ul>
				</div>
			</h5>
			<div class="list_detail">
		<ul>
		<li class="pt10 mb5">
			<dt style="width:20%">공장 및 라인</dt>
				<dd style="width:80%">
	<div class="selectbox req" style="width:170px;">  
						<label for="ex_select2">선택</label> 
						<select id="ex_select2">
						
							<option selected>삼립ERP</option>
							<option>샤니ERP</option>
						</select>
						</div>
						<div class="selectbox  ml5 req" style="width:170px;">  
						<label for="ex_select3">공장상세선택</label> 
						<select id="ex_select3">
							<option selected>시화</option>
							<option>대구 샌드팜(10000)</option>
						</select>
						</div>
							<div class="selectbox  ml5 req" style="width:330px;">  
						<label for="ex_select3">라인생성</label> 
						<select id="ex_select3">
							<option selected>1</option>
							<option>2</option>
						</select>
						</div>
				</dd>
			</li>
			
			<li class=" mb5">
			<dt style="width:20%">생성라인</dt>
				<dd style="width:80%">
			
							<form id="form1" method="post" action="">
							 <input type="radio" id="r1" name="rr" checked/ ><label for="r1"><span></span>신규생성</label>
							 <input type="radio" id="r2" name="rr" /><label for="r2"><span></span>임시저장파일</label>
							 <input type="radio" id="r3" name="rr" ><label for="r3"><span></span>템플릿</label>
							  <input type="radio" id="r4" name="rr" checked/ ><label for="r4"><span></span>제품설계서 호출</label>
							 <input type="radio" id="r5" name="rr" /><label for="r5"><span></span>엑셀업로드</label>
							 <input type="radio" id="r6" name="rr" ><label for="r6"><span></span>제조공정서 호출</label>
							 </form>
				</dd>
			</li>
			<!-- 임시저장파일 / 템플릿 사용시 노출 
			<li class=" mb5">
		
			
			<dt style="width:20%">제조공정서 리스트</dt><dd style="width:80%">
				<div class="selectbox req" style="width:347px;">
				<label for="ex_select3">제조공정서 리스트 선택</label><select id="ex_select3">
							<option selected>1</option>
							<option>2</option>
						</select>
						</div>
				</dd>
			</li>
			
			<!-- 제품설계서 호출시 노출  -->
			<!--
			<li class="mb5">
			<dt style="width:20%">제품설계문서 리스트</dt>
				<dd style="width:80%">
					<div class="selectbox req" style="width:170px;">  
						<label for="ex_select2">선택</label> 
						<select id="ex_select2">
						
							<option selected>삼립ERP</option>
							<option>샤니ERP</option>
						</select>
						</div>
						<div class="selectbox  ml5" style="width:170px;">  
						<label for="ex_select3">공장상세선택</label> 
						<select id="ex_select3">
							<option selected>시화</option>
							<option>대구 샌드팜(10000)</option>
						</select>
						</div>
							<input type="text" style="width:300px; margin-left:5px; padding-bottom:3px" placeholder="제품명으로 검색"/><button class="btn_small_search ml5">검색</button>
				</dd>
			</li>
			
			<!-- 엑셀업로드시 노출  -->
			<!--
			<li class="mb5">
			<dt style="width:20%">엑셀업로드</dt>
				<dd style="width:80%">
				<div class="form-group form_file">
									<input class="form-control form_point_color01" type="text" title="첨부된 파일명" readonly="readonly" style="width:259px">
									<span class="file_load"><input type="file" id="find_file01"><label class="btn-default" for="find_file01" style="margin-top:-1px;">파일첨부</label></span>
								</div>
				</dd>
			</li>
			<!-- 제조공정서 호출시 노출--> 
			
			<li class="mb5">
			<dt style="width:20%">기존 제조공정서</dt>
				<dd style="width:80%">
				
					
					<div class="selectbox req" style="width:100px;">  
						<label for="ex_select2">선택</label> 
						<select id="ex_select2">
						
							<option selected>삼립ERP</option>
							<option>샤니ERP</option>
						</select>
						</div>
						<div class="selectbox  ml5" style="width:100px;">  
						<label for="ex_select3">공장선택</label> 
						<select id="ex_select3">
							<option selected>시화</option>
							<option>대구 샌드팜(10000)</option>
						</select>
						</div>
						<div class="selectbox  ml5" style="width:283px;">  
						<label for="ex_select3">라인 선택</label> 
						<select id="ex_select3">
							<option selected>시화</option>
							<option>대구 샌드팜(10000)</option>
						</select>
						</div>
							<input type="text" style="width:150px; margin-left:5px; padding-bottom:3px" placeholder="제품명으로 검색"/><button class="btn_small_search ml5">검색</button>
						<!-- 선택후 보여질때 br두개 포함해서 보여지게 묶어주세요 -->
						
						<br/><br/>
						<div class="selectbox req" style="width:207px;">  
						<label for="ex_select2">제품개발문서 선택</label> 
						<select id="ex_select2">
						
							<option selected>1</option>
							<option>2</option>
						</select>
						</div>
						<div class="selectbox req ml5" style="width:100px;">  
						<label for="ex_select3">버전선택</label> 
						<select id="ex_select3">
							<option selected>1</option>
							<option>2</option>
						</select>
						</div>
						<div class="selectbox req ml5" style="width:376px;">  
						<label for="ex_select3">제조공정서 선택</label> 
						<select id="ex_select3">
							<option selected>1</option>
							<option>2</option>
						</select>
						</div>
							
				</dd>
				
			</li>
				
			<li  class="mb5">
			<dt style="width:20%">수식타입</dt>
				<dd style="width:80%">
					
							<form id="form2" method="post" action="">
							 <input type="radio" id="m1" name="mm" checked/ ><label for="m1"><span></span>일반제품</label>
							 <input type="radio" id="m2" name="mm" /><label for="m2"><span></span>기준수량 기준제품</label>
							 <input type="radio" id="m3" name="mm" ><label for="m3"><span></span>크림제품</label>
							 </form>
				</dd>
			</li>
		</ul>
	</div>
	<div class="btn_box_con">
	<button class="btn_admin_red"onclick="location.href='predoc.html'">제조공정서 생성</button>
	<button class="btn_admin_gray" onClick="location.href='#close'">생성 취소</button></div>
	</div>
</div>
	<!-- 제조공정서 생성레이어 close-->
	<!-- 디자인의뢰서 생성레이어 start-->
	<!-- 신규로 레이어창을 생성하고싶을때는  아이디값 교체-->
	<!-- 클래스 옆에 적힌 스타일 값을 인라인으로 작성해서 팝업 사이즈를 직접 조정 -->
	 <div class="white_content" id="open3">
		<div class="modal" style="	margin-left:-305px;width:610px;height: 380px;margin-top:-160px">
		  <h5 style="position:relative">
				<span class="title">디자인의뢰서 생성</span>
				<div  class="top_btn_box">
					<ul><li><button class="btn_madal_close" onClick="location.href='#close'"></button></li></ul>
				</div>
			</h5>
			<div class="list_detail">
		<ul>
		<li class="pt10 mb5">
		<dt style="width:35%">생성타입</dt>
				<dd style="width:65%">
			
							<form id="form3" method="post" action="">
							 <input type="radio" id="a1" name="aa" checked/ ><label for="a1"><span></span>신규생성</label>
							 <input type="radio" id="a2" name="aa" /><label for="a2"><span></span>임시저장파일</label>
							 <input type="radio" id="a3" name="aa" ><label for="a3"><span></span>템플릿</label>
							 </form>
				</dd>
			</li>
			
			<li class=" mb5">
		
			
			<dt style="width:35%">디자인의뢰서 리스트</dt><dd style="width:65%">
				<div class="selectbox req" style="width:347px;">
				<label for="ex_select3">디자인의뢰서 리스트 선택</label><select id="ex_select3">
							<option selected>1</option>
							<option>2</option>
						</select>
						</div>
				</dd>
			</li>
			
		
		</ul>
	</div>
	<div class="btn_box_con">
	<button class="btn_admin_red"onclick="location.href='predoc.html'">디자인의뢰서 생성</button>
	<button class="btn_admin_gray" onClick="location.href='#close'">생성 취소</button></div>
	</div>
</div>
	<!-- 디자인의뢰서 생성레이어 close-->
	<!-- 첨부파일 추가레이어 start-->
	<!-- 신규로 레이어창을 생성하고싶을때는  아이디값 교체-->
	<!-- 클래스 옆에 적힌 스타일 값을 인라인으로 작성해서 팝업 사이즈를 직접 조정 -->
	 <div class="white_content" id="open4">
		<div class="modal" style="	margin-left:-355px;width:710px;height: 500px;margin-top:-250px">
		  <h5 style="position:relative">
				<span class="title">첨부파일 추가</span>
				<div  class="top_btn_box">
					<ul><li><button class="btn_madal_close" onClick="location.href='#close'"></button></li></ul>
				</div>
			</h5>
			<div class="list_detail">
		<ul>
		<li class="pt10 mb5">
		<dt style="width:30%">파일 선택</dt>
				<dd style="width:70%">
			<div class="selectbox req" style="width:150px;">
				<label for="ex_select3">파일 구분 선택</label><select id="ex_select3">
							<option selected>1</option>
							<option>2</option>
						</select>
						</div>
							<div class="form-group form_file ml5">
									<input class="form-control form_point_color01" type="text" title="첨부된 파일명" readonly="readonly" style="width:200px">
									<span class="file_load"><input type="file" id="find_file01"><label class="btn-default" for="find_file01" style="margin-top:-1px;">파일첨부</label></span>
								</div>
				</dd>
			</li>
			
			<li class=" mb5">
		
			
			<dt style="width:30%">파일리스트 리스트</dt><dd style="width:70%;">
				<div class="file_box_pop" >
	<ul>
	<li> <a href="11.html"> <img src="../resources/images/icon_del_file.png"></a> <span> 제품이미지</span> asdfkasdflkj;a동그라미 첨부파일 .png </li>
	<li> <a href="11.html"> <img src="../resources/images/icon_del_file.png"></a> <span> 품목제조보고서사본</span> asdfkasdflkj;a동그라미 첨부파일 .png </li>
	<li> <a href="11.html"> <img src="../resources/images/icon_del_file.png"></a> <span> 품목제조보고서사본</span> asdfk그라미 첨부파일 .png</li>

	</ul>
						</div>
				</dd>
			</li>
			
		
		</ul>
	</div>
	<div class="btn_box_con">
	<button class="btn_admin_red"onclick="location.href='predoc.html'">파일 등록</button>
	<button class="btn_admin_gray" onClick="location.href='#close'">등록 취소</button></div>
	</div>
</div>
	<!-- 파일 생성레이어 close-->
	
	
	
	
	<!-- 디자인의뢰서 결재 레이어 start-->
	<!-- 신규로 레이어창을 생성하고싶을때는  아이디값 교체-->
	<!-- 클래스 옆에 적힌 스타일 값을 인라인으로 작성해서 팝업 사이즈를 직접 조정 -->
	<div class="white_content" id="open5">
	 	
	 				<input type="hidden" name="tbType" value="${tbType}"/>
					<input type="hidden" name="tbKey"  value="" />					
					<input type="hidden" name="tempKey" value=""/>
					<input type="hidden" name="userId1" id="userId1" value="${userId}" />
					<input type="hidden" name="userId2" id="userId2" />
					<input type="hidden" name="userId3" id="userId3" value="${defaultUserList[0].userId}" />
					<input type="hidden" name="userId4" id="userId4" />
					<input type="hidden" name="userId5" id="userId5" />
					<input type="hidden" name="userId6" id="userId6" />
					
				<div class="modal" style="	margin-left:-500px;width:1000px;height: 620px;margin-top:-330px">
		  <h5 style="position:relative">
				<span class="title">디자인의뢰서 결재 상신</span>
				<div class="top_btn_box">
					<ul><li><button class="btn_madal_close" onClick="closeDialog('open5'); return false;"></button></li></ul>
				</div>
			</h5>
			<div class="list_detail">
		<ul>
		<li class="pt10 mb5">
		<dt style="width:20%">제목</dt>
				<dd style="width:80%">
		<input type="text" class="req"/ style="width:573px" id="designTitle">
				</dd>
			</li>

			<li>
		
			
			<dt style="width:20%">결재자 입력</dt><dd style="width:80%;" class="ppp">
				<input type="text" placeholder="결재자명 2자이상 입력후 선택" style="width:230px; float:left;" class="req" id="designKeyword" name="designKeyword"><button class="btn_small01 ml5" onclick="approvalAddLine(this); return false;" name="firstPayment">1차결재자로 추가</button><button class="btn_small01 ml5" onclick="approvalAddLine(this); return false;" name="secondPayment" >2차결재 </button><button class="btn_small01 ml5" onclick="approvalAddLine(this); return false;" name="marketingPayment">마케팅</button><button class="btn_small02  ml5" onclick="approvalAddLine(this); return false;" name="circulationPayment">회람</button><button class="btn_small02  ml5" onclick="approvalAddLine(this); return false;" name="referPayment" >참조</button>
				
				
				<div class="selectbox ml5" style="width:180px;">
				<label for="apprLineSelect">---- 결재선 불러오기 ----</label> 
							<select id="apprLineSelect" onchange="changeApprLine();">
							   <c:forEach items="${approvalLineList}" var="item">
							   		<option value="${item.apprLineNo}">${item.lineName}</option>
							   </c:forEach>
							</select>
						</div>
				</dd>
			</li>
				<li  class="mt5">
		
			
				<dt style="width:20%; background-image:none;" ></dt><dd style="width:80%;">
				<div class="file_box_pop2" >
	<ul>
		<c:if test="${fn:length(regUserData) > 0}">
			<c:forEach items="${regUserData}" var="userData">
				<li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="s01"> 기안자</span> ${userData.userName }<strong> ${userData.titCodeName}/${userData.deptFullName}</strong></li>
			</c:forEach>
		</c:if>
		<li id="designPayment1"><img src="../resources/images/icon_del_file.png" name="delImg"><span>1차 검토 </span>  <strong></strong></li>
		
		<c:if test="${fn:length(defaultUserList) > 0 }">
			<c:forEach items="${defaultUserList}" var="defaultUser">
				<li id="designPayment2"><img src="../resources/images/icon_del_file.png" name="delImg"><span> ${defaultUser.type}</span> ${defaultUser.userName} <strong> ${defaultUser.titCodeName}/${defaultUser.deptFullName}</strong><input type="hidden" value="${defaultUser.userId}"></li>
			</c:forEach>
		</c:if>
		
		<li id="designPaymentMarketing"><img src="../resources/images/icon_del_file.png" name="delImg"><span>마케팅 </span>  <strong></strong></li>
	</ul>
						</div>
						<div class="file_box_pop3" >
	<ul id="CirculationRefLi">
	<!-- <li> <a href="11.html"> <img src="../resources/images/icon_del_file.png"></a> <span> 회람</span> 이성희 <strong> 부장/총무부</strong></li>
		<li> <a href="11.html"> <img src="../resources/images/icon_del_file.png"></a> <span> 참조</span> 이성희 <strong> 부장/총무부</strong></li> -->

	</ul>
						</div>
							
							
					
						
						<!-- 현재 추가된 결재선 저장 버튼을 누르면 안보이게 처리 start -->
						<!--div class="app_line_edit">
						<button class="btn_doc"><img src="../resources/images/icon_doc11.png"> 현재 추가된 결재선 저장</button>  |  <button class="btn_doc"><img src="../resources/images/icon_doc04.png"> 현재 표시된 결재선 삭제</button></div-->	
						<!-- 현재 추가된 결재선 저장 버튼을 누르면 안보이게 처리 close -->
						<!-- 현재 추가된 결재선 저장 버튼 눌렀을때 보이게 처리 start -->
						<div class="app_line_edit">저장 결재선명 입력 :  <input type="text" class="req" style="width:280px;"/> <button class="btn_doc" onclick="approvalLineSave(this); return false;"><img src="../resources/images/icon_doc11.png"> 저장</button> |  <button class="btn_doc"><img src="../resources/images/icon_doc04.png">취소</button>
						</div>
						<!-- 현재 추가된 결재선 저장 버튼 눌렀을때 보이게 처리 close -->
		</dd>	</li>
					<li>
		
			
			<dt style="width:20%">의견(3)</dt><dd style="width:80%;">
				
								<div class="insert_comment">
									<table style=" width:756px">
										<tr><td><textarea style="width:100%; height:50px" placeholder="의견을 입력하세요"></textarea></td><td width="98px"><button style="width:100%; height:52px; margin-top:-2px; font-size:13px">등록</button></td></tr>
									</table>
								</div>
								<div class="app_comment"> 
									<!-- 일반댓글obj start-->
									<div class="comment_obj2">
									<span class="comment_id">동동이 관리자</span>
									<span class="comment_date">2019.01.12 22:22:00&nbsp;&nbsp;&nbsp;&nbsp;<a href="#"><img src="../resources/images/icon_doc03.png"> 수정</a> | <a href="#"><img src="../resources/images/icon_doc04.png"> 삭제</a>
									<span class="comment_data">리플내용리플내용리플내용리플내용리플내용리플내용리플내용 리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내</span>
								</div>
								<!-- 일반댓글obj close-->	
								
									<!-- 일반댓글수정  start-->
									<div class="comment_obj2">
								<div class="insert_comment">
									<table style="width:738px; margin-left:2px;">
										<tr><td><textarea style="width:100%; height:50px; background-color:#fffeea;" placeholder="의견을 입력하세요" >ㅁㄴㅇ럼ㄴ이ㅏ럼ㅇㄹ만얾;ㄴ이ㅏ럼ㄴ;이ㅏ러;이</textarea></td><td width="81px"><button style=" width:95%; height:52px; margin-top:-2px; font-size:13px;">수정</button></td><td width="80px"><button style="width:100%; height:52px; margin-top:-2px; font-size:13px;">수정취소</button></td></tr>
									</table>
								</div>
								</div>
								<!-- 일반댓글 수정obj close-->	
										<!-- 일반댓글obj start-->
									<div class="comment_obj2">
									<span class="comment_id">persepho</span>
									<span class="comment_date">2019.01.12 22:22:00</span>
									<span class="comment_data">리플내용리플내용리플내용리플내용리플내용리플내용리플내용 리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내</span>
								</div>
								<!-- 일반댓글obj close-->	
								</div>
				</dd>
			</li>
		</ul>
	</div>
			<div class="btn_box_con4" style="padding:15px 0 20px 0"><button class="btn_admin_red" onclick="doSubmit(this); return false;">결재상신</button> <button class="btn_admin_gray">상신 취소</button></div>
</div> 	
	 	
	 	
	</div>
	<!-- 디자인의뢰서 결재 레이어 생성레이어 close-->
	
	
	

	<!-- 제조공정서 결재 레이어 start-->
	<!-- 신규로 레이어창을 생성하고싶을때는  아이디값 교체-->
	<!-- 클래스 옆에 적힌 스타일 값을 인라인으로 작성해서 팝업 사이즈를 직접 조정 -->
	 <div class="white_content" id="open6">
					<input type="hidden" name="jobtype" id="jobtype" value="popup"/>
	 				<input type="hidden" name="tbType" value="${tbType}"/>
					<input type="hidden" name="userId1Manu" id="userId1Manu" value="${userId}" />
					<input type="hidden" name="userId2Manu" id="userId2Manu" />
					<input type="hidden" name="userId3Manu" id="userId3Manu" />
					<input type="hidden" name="userId4Manu" id="userId4Manu" />
					<input type="hidden" name="userId5Manu" id="userId5Manu" />
					<input type="hidden" name="userId6Manu" id="userId6Manu" />
					<input type="hidden" name="userId7Manu" id="userId7Manu" />					
					<input type="hidden" name="userId8Manu" id="userId8Manu" />
					<input type="hidden" name="referenceId" id="referenceId" />
					<input type="hidden" name="circulationId" id="circulationId" />
					<input type="hidden" name="tbType" id="tbType" value="manufacturingProcessDoc"/>
					<input type="hidden" name="tbKey" id="tbKey" value=""/>
					<input type="hidden" name="totalStep" id="totalStep" value="6"/>
					<input type="hidden" name="type" id="type" value="0"/>
			<%-- 		<input type="hidden" name="docNo" id="docNo" value="<%=docNo %>"/>
					<input type="hidden" name="docVersion" id="docVersion" value="<%=docVersion %>"/> --%>
					
		<div class="modal" style="	margin-left:-500px;width:1000px;height: 550px;margin-top:-300px">
		  <h5 style="position:relative">
				<span class="title">제조공정서 결재 상신</span>
				<div  class="top_btn_box">
					<ul><li><button class="btn_madal_close" onClick="closeDialog('open6'); return false;"></button></li></ul>
				</div>
			</h5>
			<div class="list_detail">
		<ul>
		<li class="pt10">
		<dt style="width:20%">제목</dt>
				<dd style="width:80%">
		<input type="text" class="req"/ style="width:573px" id="manuTitle">
				</dd>
			</li>

<li><dt style="width:20%">제품출시일</dt><dd style="width:80%"><input type="text" style="width:170px;" class="req" id="launchDate"/> <a href="#"><img src="../resources/images/btn_calendar.png" style=" margin-top:-4px;"></a></dd></li>

			<li class="pt5">
		
			
			<dt style="width:20%">결재자 입력</dt><dd style="width:80%;" class="ppp">
				<input type="text" placeholder="결재자명 2자이상 입력후 선택" style="width:198px; float:left;" class="req" id="manufacKeyword" name="manufacKeyword"><button class="btn_small01 ml5" onclick="approvalAddLine(this); return false;" name="firstPayment">합의1</button><button class="btn_small01 ml5" onclick="approvalAddLine(this); return false;" name="secondPayment">합의2</button><button class="btn_small01 ml5" onclick="approvalAddLine(this); return false;" name="parterPayment">파트장</button><button class="btn_small01 ml5" onclick="approvalAddLine(this); return false;" name="leaderPayment">팀장</button><button class="btn_small01 ml5" onclick="approvalAddLine(this); return false;" name="directorPayment">연구소장</button><button class="btn_small02  ml5" onclick="approvalAddLine(this); return false;" name="circulationPayment">회람</button><button class="btn_small02  ml5" onclick="approvalAddLine(this); return false;" name="referPayment">참조</button>
				
				
				<div class="selectbox ml5" style="width:180px;">
				<label for="ex_select4">---- 결재선 불러오기 ----</label><select id="ex_select4">
							<option selected>디자인의뢰기본결재1</option>
							<option>기본2</option>
						</select>
						</div>
				</dd>
			</li>
				<li  class="mt5">
		
			
				<dt style="width:20%; background-image:none;" ></dt><dd style="width:80%;">
				<div class="file_box_pop2" style="height:190px;">
	<ul>
	
	<c:if test="${fn:length(regUserData) > 0}">
			<c:forEach items="${regUserData}" var="userData">
				<li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="s01"> 기안자</span> ${userData.userName }<strong> ${userData.titCodeName}/${userData.deptFullName}</strong></li>
			</c:forEach>
		</c:if>
				<li id="manufacPayment1"><img src="../resources/images/icon_del_file.png"><span>합의1</span><strong></strong></li>
				<li id="manufacPayment2"><img src="../resources/images/icon_del_file.png"><span>합의2</span><strong></strong></li>
				<li id="manufacPaymentLeader"><img src="../resources/images/icon_del_file.png"><span>팀장</span><strong></strong></li>
				<li id="manufacPaymentDirector"><img src="../resources/images/icon_del_file.png"><span>연구소장</span> <strong></strong></li>
				<li id="manufacPaymentParter"><img src="../resources/images/icon_del_file.png"><span>파트장</span><strong></strong></li>

	</ul>
						</div>
						<div class="file_box_pop3" style="height:190px;">
	<ul id="CirculationLefLiManu">
	<!-- 	<li> <a href="11.html"> <img src="../resources/images/icon_del_file.png"></a> <span> 회람</span> 이성희 <strong> 부장/총무부</strong></li>
		<li> <a href="11.html"> <img src="../resources/images/icon_del_file.png"></a> <span> 참조</span> 이성희 <strong> 부장/총무부</strong></li> -->

	</ul>
						</div>
							
							
					
						
						<!-- 현재 추가된 결재선 저장 버튼을 누르면 안보이게 처리 start -->
						<!--div class="app_line_edit">
						<button class="btn_doc"><img src="../resources/images/icon_doc11.png"> 현재 추가된 결재선 저장</button>  |  <button class="btn_doc"><img src="../resources/images/icon_doc04.png"> 현재 표시된 결재선 삭제</button></div-->	
						<!-- 현재 추가된 결재선 저장 버튼을 누르면 안보이게 처리 close -->
						<!-- 현재 추가된 결재선 저장 버튼 눌렀을때 보이게 처리 start -->
						<div class="app_line_edit">저장 결재선명 입력 :  <input type="text" class="req" style="width:280px;"/> <button class="btn_doc" onclick=" approvalLineSave(this);  return false;"><img src="../resources/images/icon_doc11.png"> 저장</button> |  <button class="btn_doc"><img src="../resources/images/icon_doc04.png">취소</button>
						</div>
						<!-- 현재 추가된 결재선 저장 버튼 눌렀을때 보이게 처리 close -->
		</dd>	</li>
		
		</ul>
	</div>
			<div class="btn_box_con4" style="padding:15px 0 20px 0"><button class="btn_admin_red" onclick="doSubmit(this); return false;">결재상신</button> <button class="btn_admin_gray">상신 취소</button></div>
</div>
</div>
	<!-- 제조공정서 결재 레이어 생성레이어 close-->
	
	
	
		<!-- 수정내역 레이어 start-->
	<!-- 신규로 레이어창을 생성하고싶을때는  아이디값 교체-->
	<!-- 클래스 옆에 적힌 스타일 값을 인라인으로 작성해서 팝업 사이즈를 직접 조정 -->
	 <div class="white_content" id="open7">
		<div class="modal" style="	margin-left:-500px;width:1000px;height: 600px;margin-top:-300px">
		  <h5 style="position:relative">
				<span class="title">수정내역</span>
				<div  class="top_btn_box">
					<ul><li><button class="btn_madal_close" onClick="location.href='#close'"></button></li></ul>
				</div>
			</h5>
			<div class="list_detail">
		<ul>
	
					<li class="pt10">
		
			
			<dt style="width:20%">의견(3)</dt><dd style="width:80%;">
				
								<div class="insert_comment">
									<table style=" width:756px">
										<tr><td><textarea style="width:100%; height:50px" placeholder="의견을 입력하세요"></textarea></td><td width="98px"><button style="width:100%; height:52px; margin-top:-2px; font-size:13px">등록</button></td></tr>
									</table>
								</div>
								<div class="app_comment" style=" height:350px;"> 
									<!-- 일반댓글obj start-->
									<div class="comment_obj2">
									<span class="comment_id">동동이 관리자</span>
									<span class="comment_date">2019.01.12 22:22:00&nbsp;&nbsp;&nbsp;&nbsp;<a href="#"><img src="../resources/images/icon_doc03.png"> 수정</a> | <a href="#"><img src="../resources/images/icon_doc04.png"> 삭제</a>
									<span class="comment_data">리플내용리플내용리플내용리플내용리플내용리플내용리플내용 리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내</span>
								</div>
								<!-- 일반댓글obj close-->	
								
									<!-- 일반댓글수정  start-->
									<div class="comment_obj2">
								<div class="insert_comment">
									<table style="width:738px; margin-left:2px;">
										<tr><td><textarea style="width:100%; height:50px; background-color:#fffeea;" placeholder="의견을 입력하세요" >ㅁㄴㅇ럼ㄴ이ㅏ럼ㅇㄹ만얾;ㄴ이ㅏ럼ㄴ;이ㅏ러;이</textarea></td><td width="81px"><button style=" width:95%; height:52px; margin-top:-2px; font-size:13px;">수정</button></td><td width="80px"><button style="width:100%; height:52px; margin-top:-2px; font-size:13px;">수정취소</button></td></tr>
									</table>
								</div>
								</div>
								<!-- 일반댓글 수정obj close-->	
										<!-- 일반댓글obj start-->
									<div class="comment_obj2">
									<span class="comment_id">persepho</span>
									<span class="comment_date">2019.01.12 22:22:00</span>
									<span class="comment_data">리플내용리플내용리플내용리플내용리플내용리플내용리플내용 리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내용리플내</span>
								</div>
								<!-- 일반댓글obj close-->	
									<!-- 일반댓글obj start-->
									<div class="comment_obj2">
									<span class="comment_data">입력된 수정내역이 없습니다.</span>
								</div>
								<!-- 일반댓글obj close-->	
								</div>
				</dd>
			</li>
		</ul>
	</div>
			<div class="btn_box_con4" style="padding:15px 0 20px 0"><button class="btn_admin_red">결재상신</button> <button class="btn_admin_gray">상신 취소</button></div>
</div>
</div>
	<!-- 수정내역 레이어 생성레이어 close-->
			