<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="userUtil" uri="/WEB-INF/tld/userUtil.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="kr.co.aspn.util.*" %> 
<%@ page session="false" %>
<title>품목제조보고서 등록</title>
<script type="text/javascript">
var isValid ;
$(document).ready(function(){
});

function goInsert() {
	$("#create").attr('disabled', true);
	if( !chkNull($("#company").selectedValues()[0]) ) {
		alert("공장을 선택하여 주세요.");
		$("#company").focus();
		$("#create").attr('disabled', false);
		return;
	} else if( !chkNull($("#plant").selectedValues()[0]) ) {
		alert("공장을 선택하여 주세요.");
		$("#plant").focus();
		$("#create").prop('disabled', false);
		return;
	} else if( !chkNull($("#licensingNo").selectedValues()[0]) ) {
		alert("공장 인허가번호를 선택하여 주세요.");
		$("#licensingNo").focus();
		$("#create").prop('disabled', false);
		return;
	} else if( !chkNull($("#manufacturingName").val()) ) {
		alert("품목명을 입력해주세요.");
		$("#manufacturingName").focus();
		$("#create").prop('disabled', false);
		return;
	} else if( $("#isValid").val() == 'N' ) {
		alert("품목명 확인을 해주세요.");
		$("#create").prop('disabled', false);
		return;
	} else if( $("#manufacturingName").val() != $("#manufacturingName_temp").val() ) {
		alert("품목명 확인을 해주세요.");
		$("#create").prop('disabled', false);
		return;
	} else if( !chkNull($("#productType1").selectedValues()[0]) ) {
		alert("식품유형을 선택해주세요.");
		$("#productType1").focus();
		$("#create").prop('disabled', false);
		return;
	} else if( !chkNull($("#productType2").selectedValues()[0]) ) {
		alert("식품유형을 선택해주세요.");
		$("#productType2").focus();
		$("#create").prop('disabled', false);
		return;
	} else if( !chkNull($("#productType2").selectedValues()[0]) ) {
		alert("식품유형을 선택해주세요.");
		$("#productType2").focus();
		$("#create").prop('disabled', false);
		return;
	} else if( !chkNull($("#sterilization").selectedValues()[0]) ) {
		alert("살균여부를 선택해주세요.");
		$("#sterilization").focus();
		$("#create").prop('disabled', false);
		return;
	} else if( !chkNull($("#keepCondition").selectedValues()[0]) ) {
		alert("보관조건을 선택해주세요.");
		$("#keepCondition").focus();
		$("#create").prop('disabled', false);
		return;
	} else if( $("#keepCondition").selectedValues()[0] == '4' && !chkNull($("#keepConditionText").val()) ) {
		alert("보관조건을 입력해주세요.");
		$("#keepConditionText").focus();
		$("#create").prop('disabled', false);
		return;
	} else if( !chkNull($("#sellDate1").selectedValues()[0]) ) {
		alert("소비기한을 선택해주세요.");
		$("#sellDate1").focus();
		$("#create").prop('disabled', false);
		return;
	} else if( !chkNull($("#sellDate2").val()) ) {
		alert("소비기한을 입력해주세요.");
		$("#sellDate2").focus();
		$("#create").prop('disabled', false);
		return;
	} else if( !chkNull($("#sellDate3").selectedValues()[0]) ) {
		alert("소비기한을 선택해주세요.");
		$("#sellDate3").focus();
		$("#create").prop('disabled', false);
		return;
	} else if( $("input:checkbox[name=oem]").is(":checked") == true ) {
		if( !chkNull($("#oemText").val()) ) {
			alert("OEM 내용을 입력하세요.");
			$("#oemText").focus();
			return;
		}
	}/*else if( $("#mailing").selectedValues().length == 0 ) {
		alert("메일 전송 담당자를 선택해주세요.");
		$("#searchUser").focus();
		return;
	}*/ else if( $('#packageUnit').selectedValues().length == 0 ) {
		alert("포장재질을 선택해주세요.");
		$("#create").prop('disabled', false);
		return;
	} else {
		var count = 0;
		$('#packageUnit :selected').each(function(i, sel){ 
		    if( $(sel).val() == '8' ) {
		    	count++;
		    }
		});
		if( count > 0 ) {
			if( !chkNull($('#packageEtc').val()) ) {
				alert("포장재질을 입력해주세요.");
				$("#packageEtc").focus();
				$("#create").prop('disabled', false);
				return;
			}
		}
		if(confirm("품목제조보고번호를 생성하시겠습니까?")){
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
			var packageArray = new Array();
			$('#packageUnit :selected').each(function(i, sel){ 
				packageArray.push($(sel).val());
			});
			var URL = "../manufacturingNo/insertAjax";
			$.ajax({
				type:"POST",
				url:URL,
				traditional : true,
				data:{
					"dNo":'${paramVO.dNo}',
					"companyCode":$("#company").selectedValues()[0],
					"plantCode": $("#plant").selectedValues()[0],
					"licensingNo": $("#licensingNo").selectedValues()[0],
					"manufacturingName": $("#manufacturingName").val(),
					"productType1": $("#productType1").selectedValues()[0],
					"productType2": $("#productType2").selectedValues()[0],
					"productType3": $("#productType3").selectedValues()[0],
					"sterilization": $("#sterilization").selectedValues()[0],
					//"etcDisplay": $("#etcDisplay").selectedValues()[0],
					"keepCondition": $("#keepCondition").selectedValues()[0],
					"keepConditionText": $("#keepConditionText").val(),
					"sellDate1": $("#sellDate1").selectedValues()[0],
					"sellDate2": $("#sellDate2").val(),
					"sellDate3": $("#sellDate3").selectedValues()[0],
					"sellDate4": $("#sellDate4").selectedValues()[0],
					"sellDate5": $("#sellDate5").val(),
					"sellDate6": $("#sellDate6").selectedValues()[0],
					"referral": referral,
					"oem": oem,
					"oemText": $("#oemText").val(),
					"createPlant": plantArray,
					"packageUnit": packageArray,
					"packageEtc": $('#packageEtc').val(),
					//"mailing": $("#mailing").selectedValues(),
					"comment": $("#comment").val()
				},
				dataType:"json",
				success:function(result) {
					if( result.status == 'success') {
						alert("품목제조 보고서 번호 "+result.msg+"가 생성되었습니다.");
						parent.loadManufacturingNo();
						bPopup_close();
					} else if( result.status == 'fail') {
						alert(result.msg);
					} else {
						alert(result.msg+"오류가 발생하였습니다.\n다시 시도하여 주세요.");
					}
					$("#create").prop('disabled', false);
				},
				error:function(request, status, errorThrown){
					alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
					$("#create").prop('disabled', false);
				}			
			});	
		} else {
			$("#create").prop('disabled', false);
		}
	}
}

function goStop() {
	var totalCnt = $("#list").children().length;
	var dNoCnt = $('input[type=checkbox][name=mNoSeq]:checked').length;
	if( totalCnt == dNoCnt ) {
		if( confirm('중단요청을 하시겠습니까?') ) {
			alert('전자결재에서 중단 협조전 상신하여 주시기 바랍니다.');
			jQuery.ajax({
				async : false,
				type : 'POST',
				dataType : 'json',
				url : '/manufacturingNo/updateManufacturingNoStatusAjax',
				data : { 
					'no_seq' : '${paramVO.seq}',
					'prevStatus' : '${paramVO.status}',
					'status' : 'RS',
					'isStopReq' : 'Y'
				},
				success : function(data){
					if( data.RESULT == 'Y' ) {
						alert("중단요청 되었습니다.");
						bPopup_close();
						return;	
					} else {
						alert("중단요청 실패했습니다. \n 다시 시도해주세요.");
						return;
					}					
				},
				error : function(){
					alert("오류가 발생하였습니다. \n 확인 후 다시 처리해주세요.");
				}
			});
		}
	} else {
		alert("모든 제품 확인 후 중단요청이 가능합니다.");
		return;
	}
}

function bPopup_close() {
	parent.bPopup_close();
}
</script>
<style>
.selectbox_popup { border: 1px solid #cf451b; border-radius:5px;/* 테두리 설정 */ z-index: 1; background-color:#fff;font-family:'맑은고딕',Malgun Gothic; color:#000; font-size:13px; padding: 2px 3px  5px 3px;}
</style>
<h2 style=" position:fixed;" class="print_hidden">
	<span class="title"><img src="/resources/images/bg_bs_box_fast02.png">&nbsp;&nbsp;품목제조보고서 맵핑 리스트</span>
</h2>
<div  class="top_btn_box" style=" position:fixed;">
	<ul>
		<li><button type="button" class="btn_pop_close" onClick="bPopup_close();"></button></li>
	</ul>
</div>
<br/>
<br/><br/>
<div class="wrap_in" id="fixNextTag">
	<section class="type01">
		<div class="group01">
			<div class="title3">
				<span class="txt">제품리스트</span>
			</div>
			<div class="main_tbl" style="padding-bottom: 40px;">
				<table class="tbl04" id="">
					<colgroup>		
						<col width="5%">					
						<col width="10%">
						<col width="7%">
						<col width="10%">
						<col />
						<col width="15%">
					</colgroup>
					<thead>
						<tr>				
							<th>확인</th>				
							<th>문서번호</th>
							<th>버젼</th>
							<th>제품코드</th>
							<th>제품명</th>
							<th>담당자</th>
						</tr>
					</thead>
					<tbody id="list">
						<c:forEach items="${list}" var="item" varStatus="status">
							<tr>				
								<td>
									<input type="checkbox" name="mNoSeq" id="mNoSeq_${status.index}" value="${item.mNoSeq}">
									<label style="padding:0;" for="mNoSeq_${status.index}">
									<span style="margin:0;"></span></label>
								</td>				
								<td>${item.docNo}</td>
								<td>${item.docVersion}</td>
								<td>${item.productCode}</td>
								<td>${item.productName}</td>
								<td>${item.userName}</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
			<div class="btn_box_con">
				<button type="button" class="btn_admin_red" id="create" onclick="javascript:goStop();">중단요청</button>
				<button type="button" class="btn_admin_gray" onclick="bPopup_close();"> 취소</button>
			</div>			
		</div>
	</section>
</div>
