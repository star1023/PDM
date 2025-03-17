<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ taglib prefix="userUtil" uri="/WEB-INF/tld/userUtil.tld"%>
<%@ page session="false" %>
<%@ page import="kr.co.aspn.util.*" %> 
<%
	String userGrade = UserUtil.getUserGrade(request);
	String userDept = UserUtil.getDeptCode(request);
	String userTeam = UserUtil.getTeamCode(request);
	String isAdmin = UserUtil.getIsAdmin(request);
%>
<script type="text/javascript">
	var globalExistingJson;
	//기존 값들 불러오기 모듈화
	function initializeProductType(){
		var productType1 	= '${manufacturingNo.productType1}';
		var productType2 	= '${manufacturingNo.productType2}';
		var productType3 	= '${manufacturingNo.productType3}';
		
		if(productType1.length > 0){ 
			$('#productType1_versionUp option[value='+productType1+']').prop('selected', true);
			$('#productType1_versionUp').change();
		}
		if(productType2.length > 0){ 
			$('#productType2_versionUp option[value='+productType2+']').prop('selected', true);
			$('#productType2_versionUp').change();
		}
		if(productType3.length > 0){
			$("#dd_dd_productType_versionUp").append('<select id="productType3" name="productType3"></select>')
			$('#productType3_versionUp option[value='+productType3+']').prop('selected', true);
			$('#productType3_versionUp').change();
		}
	}
	
	function initializeSterilization(){
		var sterilization = '${manufacturingNo.sterilization}';
		if(sterilization.length > 0){
			$('#sterilization_versionUp option[value='+sterilization+']').prop('selected', true);
			$('#sterilization_versionUp').change();
		}
	}
	
	function initializeKeepCondition(){
		if(keepCondition.length > 0){
			$('#keepCondition_versionUp option[value='+'${manufacturingNo.keepCondition}'+']').prop('selected', true);
			$('#keepCondition_versionUp').change();
		}
		
		var keepConditionText = '${manufacturingNo.keepConditionText}';
		if(keepConditionText.length > 0){
			$("#keepConditionText_versionUp").val('${manufacturingNo.keepConditionText}');
		}
	}

	function initializeSellDate(){
		var sellDate1 = '${manufacturingNo.sellDate1}';
		var sellDate3 = '${manufacturingNo.sellDate3}';
		if(sellDate1.length > 0){
			$('#sellDate1 option[value='+sellDate1+']').prop('selected', true);
			$("#sellDate2").val('${manufacturingNo.sellDate2}');
			$('#sellDate3 option[value='+sellDate3+']').prop('selected', true);
		}
		var sellDate4 = '${manufacturingNo.sellDate4}'.replaceAll(" ","");
		var sellDate6 = '${manufacturingNo.sellDate6}';
		if(sellDate4.length > 0){	
			$('#sellDate4 option[value='+sellDate4+']').prop('selected', true);
			$("#sellDate5").val('${manufacturingNo.sellDate5}');
			$('#sellDate6 option[value='+sellDate6+']').prop('selected', true);
		}else{
			$('#sellDate4 option[value=""]').prop('selected', true);
			$("#sellDate5").val('');
			$('#sellDate6 option[value=""]').prop('selected', true);
		}
	}
	
	function initializeCreatePlant(){
		var createPlantList = '${manufacturingNo.createPlant}';
		if( createPlantList.replaceAll(" ","").length > 0 ){
			$("#referral_versionUp").prop("checked", true);
			
			loadPlant();
			
			var createPlant = createPlantList.replaceAll(" ","").split(",");
			$(createPlant).each(function(i){
				$('#plant_'+createPlant[i]).prop("checked", true);
			})
		}
	}
	
	function initializeOem(){
		var oem = '${manufacturingNo.oem}';
		if(oem == 'Y'){
			$("#oem_versionUp").prop("checked", true);
			$("#oem_versionUp").val("Y");
			$("#li_oemText_versionUp").show();
			$("#oemText_versionUp").val('${manufacturingNo.oemText}');
		}else if(oem == 'N'){
			$("#oem_versionUp").prop("checked", false);
			$("#oem_versionUp").val("N");
			$("#li_oemText_versionUp").hide();
			$("#oemText_versionUp").val("");
		}
	}
	
	function initializePackageUnitList(){
		var packageUnitList = '${manufacturingNo.packageUnits}';
		if( packageUnitList.length > 0 ){
			var packageUnit = packageUnitList.replaceAll(" ","").split(",");
			$(packageUnit).each(function(i){
				$('#packageUnit_versionUp option[value='+packageUnit[i]+']').prop("selected", true);
			})
			if( $("#packageUnit_versionUp option[value='8']").prop("selected") ){
				$("#packageEtc_versionUp").show();
				$("#packageEtc_versionUp").val('${manufacturingNo.packageEtc}');
			}
		}
	}
	
	function initializeComment(){
		var comment = '${manufacturingNo.comment}';
		if( comment.length > 0 ){
			$("#dd_comment_versionUp textarea").val(comment);
		}else{
			$("#dd_comment_versionUp textarea").val("");
		}
	}
	
	
	$(document).ready(function(){
		//$(".isFirstImage").css("background-image", "url(../resources/images/bg_ver.png)");
		if(parseInt('${manufacturingNo.versionNo}') > 1){
			$("#div_versionUpReason").show();
			$("#tbl_versionUpReason").show();
		}else{
			$("#div_versionUpReason").hide();
			$("#tbl_versionUpReason").hide();
		}
		
		loadCodeList( "PRODCAT1", "productType1" );
		loadCodeList( "STERILIZATION2", "sterilization" );
		loadCodeList( "ETCDISPLAY", "etcDisplay" );
		loadCodeList( "KEEPCONDITION2", "keepCondition" );
		loadPackage("PACKAGE_UNIT");
		
		var companyCode 	= '${manufacturingNo.companyCode}';
		var plant 			= '${manufacturingNo.plantCode}';
		var licensingNo 	= '${manufacturingNo.licensingNo}';		
		
		initializeProductType();
		initializeSterilization();
		initializeKeepCondition();
		
		var sellDate1 = '${manufacturingNo.sellDate1}';
		var sellDate3 = '${manufacturingNo.sellDate3}';
		
		$("#dd_sellDate_versionUp").append('<select id="sellDate1" name="sellDate1"  class="selectbox_popup" style="width: 160px;" disabled="disabled"></select>');
		$('#sellDate1').append('<option value="">선택</option>');
		$('#sellDate1').append('<option value="D">제조일로부터</option>');
		$('#sellDate1').append('<option value="H">제조시간으로부터</option>');
		$('#sellDate1').append('<option value="B">할란 후</option>');
		
		$("#dd_sellDate_versionUp").append('<input type="text" id="sellDate2" name="sellDate2" style="width: 50px;" disabled="disabled"/>');
		$("#dd_sellDate_versionUp").append('<select id="sellDate3" name="sellDate3"  class="selectbox_popup" style="width: 160px;" disabled="disabled"></select>');
		$('#sellDate3').append('<option value="">선택</option>');
		$('#sellDate3').append('<option value="Y">년</option>');
		$('#sellDate3').append('<option value="M">개월</option>');
		$('#sellDate3').append('<option value="D">일</option>');
		$('#sellDate3').append('<option value="H">시간</option>');
		
		var sellDate4 = '${manufacturingNo.sellDate4}'.replaceAll(" ","");
		var sellDate6 = '${manufacturingNo.sellDate6}';
		
		$("#dd_sellDate_versionUp").append('<br/> <select id="sellDate4" name="sellDate4"  class="selectbox_popup" style="width: 160px;" disabled="disabled"></select>');
		$('#sellDate4').append('<option value="">선택</option>');
		$('#sellDate4').append('<option value="D">제조일로부터</option>');
		$('#sellDate4').append('<option value="H">제조시간으로부터</option>');
		$('#sellDate4').append('<option value="B">할란 후</option>');
		
		$("#dd_sellDate_versionUp").append('<input type="text" id="sellDate5" name="sellDate5" style="width: 50px;" disabled="disabled"/>');

		$("#dd_sellDate_versionUp").append('<select id="sellDate6" name="sellDate6"  class="selectbox_popup" style="width: 160px;" disabled="disabled"></select>');
		$('#sellDate6').append('<option value="">선택</option>');
		$('#sellDate6').append('<option value="Y">년</option>');
		$('#sellDate6').append('<option value="M">개월</option>');
		$('#sellDate6').append('<option value="D">일</option>');
		$('#sellDate6').append('<option value="H">시간</option>');
		
		initializeSellDate();
		initializeCreatePlant();
		initializeOem();
		initializePackageUnitList();
		initializeComment();
		
		
		if($("#list_versionUp input[type='radio']#versionUpRequestCheckable").length <= 0){
			$("#checkAllForVersionUp").prop("disabled", true);
			$("#checkAllForVersionStop").prop("disabled", true);
		}
		
		if('${versionUpReason }'!=null){
			var html = "";
			var htmlArray = new Array();
			var htmlArrayText = "";
			if('${versionUpReason.manufacturingNameChange }' == "Y"){
				html += "<tr>";
				html += "	<td colspan='2'>품보명</td>";
				html += "	<td>${versionUpReason.oldManufacturingName }</td>";
				html += "	<td class='boldArrow'>&#8594;</td>";
				html += "	<td>${versionUpReason.newManufacturingName }</td>";
				html += "</tr>";
			}
			if('${versionUpReason.keepConditionChange }' == "Y"){
				html += "<tr>";
				html += "	<td colspan='2'>보관조건</td>";
				html += "	<td>${versionUpReason.oldKeepCondition}</td>";
				html += "	<td class='boldArrow'>&#8594;</td>";
				html += "	<td>${versionUpReason.newKeepCondition}</td>";
				html += "</tr>";
			}
			if('${versionUpReason.sellDateChange }' == "Y"){
				var existingArray = new Array();
				existingArray.push('${versionUpReason.oldSellDate1 } &nbsp; ${versionUpReason.oldSellDate2 } ${versionUpReason.oldSellDate3 }');
				if('${versionUpReason.oldSellDate4 }'.length > 0){				
					existingArray.push('${versionUpReason.oldSellDate4 } &nbsp; ${versionUpReason.oldSellDate5 } ${versionUpReason.oldSellDate6 }');
				}
				var newArray = new Array();
				newArray.push("${versionUpReason.newSellDate1 } &nbsp; ${versionUpReason.newSellDate2 } ${versionUpReason.newSellDate3 }");
				if('${versionUpReason.newSellDate4 }'.length > 0){					
				newArray.push("${versionUpReason.newSellDate4 } &nbsp; ${versionUpReason.newSellDate5 } ${versionUpReason.newSellDate6 }");
				}
				
				html += "<tr>";
				html += "	<td colspan='2'>소비기한</td>";
				html += "	<td>" + existingArray.join(" / ") + "</td>";
				html += "	<td class='boldArrow'>&#8594;</td>";
				html += "	<td>" + newArray.join(" / ") + "</td>";
				html += "</tr>";
			}
			
			if("${versionUpReason.QNSChange}" == "Y"){
				var newQNS = "${versionUpReason.newQNS}".length > 0 ? "${versionUpReason.newQNS}" : "QNSH 검토 대상이 아님";
				html += "<tr>";
				html += "	<td colspan='2'>원재료명(원재료)</td>";
				html += "	<td>&nbsp;</td>";
				html += "	<td class='boldArrow'>&nbsp;</td>";
				html += "	<td>" + newQNS + "</td>";
				html += "</tr>";
			}
			
			var cnt = 0;
			
			if('${versionUpReason.oldSterilization }' != '${versionUpReason.newSterilization }'){
				html += "<tr>";
				html += "	<td id='td_for_merge'></td>";
				html += "	<td>살균여부</td>";
				html += "	<td>${versionUpReason.oldSterilization } </td>";
				html += "	<td class='boldArrow'>&#8594;</td>";
				html += "	<td>${versionUpReason.newSterilization }</td>";
				html += "</tr>";
				cnt ++;
			}
			
			if("${versionUpReason.oldOEM }" != "${versionUpReason.newOEM }"){
				html += "<tr>";
				html += "	<td id='td_for_merge'></td>";
				html += "	<td>oem</td>";
				if('${versionUpReason.oldOEM }' == "N" && '${versionUpReason.newOEM }' == "Y"){
					html += "	<td>해당없음</td>";
					html += "	<td class='boldArrow'>&#8594;</td>";
					html += "	<td>${versionUpReason.newOEMText }</td>";
				}else if('${versionUpReason.oldOEM }' == "Y" && '${versionUpReason.newOEM }' == "N"){
					html += "	<td>${versionUpReason.oldOEMText }</td>";
					html += "	<td class='boldArrow'>&#8594;</td>";
					html += "	<td>해당없음</td>";
				}else {
					html += "	<td>${versionUpReason.oldOEMText }</td>";
					html += "	<td class='boldArrow'>&#8594;</td>";
					html += "	<td>${versionUpReason.newOEMText }</td>";
				}
				html += "</tr>";
				cnt ++;
			}			
			
			if('${versionUpReason.oldCreatePlant }' != '${versionUpReason.newCreatePlant }'){
				html += "<tr>";
				html += "	<td id='td_for_merge'></td>";
				html += "	<td>위탁공장</td>";
				if('${versionUpReason.oldCreatePlant }'.replaceAll(" ", "").length <= 0){
					html += "	<td>해당없음</td>";
					html += "	<td class='boldArrow'>&#8594;</td>";
					html += "	<td>${versionUpReason.newCreatePlant }</td>";
				}else if('${versionUpReason.newCreatePlant }'.replaceAll(" ", "").length <= 0){
					html += "	<td>${versionUpReason.oldCreatePlant }</td>";
					html += "	<td class='boldArrow'>&#8594;</td>";
					html += "	<td>해당없음</td>";
				}else{
					html += "	<td>${versionUpReason.oldCreatePlant }</td>";
					html += "	<td class='boldArrow'>&#8594;</td>";
					html += "	<td>${versionUpReason.newCreatePlant }</td>";
				}
				html += "</tr>";
				cnt ++;
			}			
			
			if('${versionUpReason.oldComment }' != '${versionUpReason.newComment }'){
				html += "<tr>";
				html += "	<td id='td_for_merge'></td>";
				html += "	<td>비고</td>";
				if('${versionUpReason.oldComment }'.length <= 0){
					html += "	<td>내용없음</td>";
					html += "	<td class='boldArrow'>&#8594;</td>";
					html += "	<td>${versionUpReason.newComment }</td>";			
				}else if('${versionUpReason.newComment }'.length <= 0){
					html += "	<td>${versionUpReason.oldComment }</td>";
					html += "	<td class='boldArrow'>&#8594;</td>";
					html += "	<td>내용없음</td>";
				}else{
					html += "	<td>${versionUpReason.oldComment }</td>";
					html += "	<td class='boldArrow'>&#8594;</td>";
					html += "	<td>${versionUpReason.newComment }</td>";
				}
				html += "</tr>";
				cnt ++;
			}

			$("#list_versionUpReason").html(html);
			$("#td_for_merge").attr("rowspan", parseInt(cnt));
			if($("#list_versionUpReason").find("#td_for_merge:eq(0)").val()==''){
				$("#list_versionUpReason").find("#td_for_merge:eq(0)").html('기타');
			}
			for(var i = 1; i <= parseInt(cnt); i++){
				$("#list_versionUpReason").find("td#td_for_merge:eq(1)").remove();
			}
			$(".boldArrow").css("font-weight", "bold");
		}
	globalExistingJson = callExistingParams();
	});
	
	function showChildVersion(imgElement){
		var docNo = $(imgElement).parent().parent().attr('id').split('_')[1];
		var docVersion = $(imgElement).parent().parent().attr('id').split('_')[2];
		var elementImg = $(imgElement).attr('src').split('/')[$(imgElement).attr('src').split('/').length-1];
		
		var addImg = 'img_add_doc.png';
		
		if(elementImg == addImg){
			$(imgElement).attr('src', $(imgElement).attr('src').replace('_add_', '_m_')); 
			$('tr[id*=devDoc_old_'+docNo+']').show();
			//$('tr[id*=devDoc_old]').show();
		}else {
			$(imgElement).attr('src', $(imgElement).attr('src').replace('_m_', '_add_'));
			$('tr[id*=devDoc_old_'+docNo+']').toArray().forEach(function(v, i){
				$(v).hide();
			})
		}
	};

	/* function goUpdateForm(seq) {
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
						//[value=" + splitCode[idx] + "]"
						$("input[name=createPlant][value=" + productCode[i] + "]").prop("checked", true);
					}
				}
			},
			error:function(request, status, errorThrown){
				alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
			}			
		});
		
		openDialog('open');
	} */
	
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
				$("#create_plant_list_versionUp").html(html);
				var count = 0
				$.each(list, function( index, value ){ //배열-> index, value
					html += "	<input type=\"checkbox\" name=\"createPlant\" id=\"plant_"+value.plantCode+"\" value=\""+value.plantCode+"\" disabled><label for=\"plant_"+value.plantCode+"\"><span></span>"+value.plantName+"("+value.plantCode+")</label>";
					count++;
					if( count != 0 && count % 4 == 0 ) {
						html += "<br/>";
					}
				});
				$("#create_plant_list_versionUp").html(html);
				$("#li_create_plant_versionUp").show();
			},
			error:function(request, status, errorThrown){
					alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
			}			
		});
	}
	
	function oemCheck() {
		if( !$("input:checkbox[name=oem_versionUp]").is(":checked") ) {
			$("#li_oemText_versionUp").hide();
			$("#oem_versionUp").val("N");
		} else {
			$("#li_oemText_versionUp").show();
			$("#oem_versionUp").val("Y");
		}
	}
	
	function changeKeepCondition() {
		if( $("#keepCondition_versionUp").selectedValues()[0] == '4' ) {
			$("#keepConditionText_versionUp").show();
		} else {
			$("#keepConditionText_versionUp").val("");
			$("#keepConditionText_versionUp").hide();
		}
	}
	
	function addFile(fileIdx) {
		var filePath = document.getElementById(fileIdx).value;
		var fileName = filePath.substring(filePath.lastIndexOf('\\') + 1,	filePath.length);
		if (fileName.length == 0) {
			alert("파일을 선택해 주십시요. addFile");
			return;
		}
		
		var html = "";
		$("#up"+fileIdx).html(html);
		html += "		<a href='#' onClick='javascript:deleteFileFromInput(this)'><img src=\"/resources/images/icon_del_file.png\"></a>";
		html += "		"+ fileName + "";
		$("#up"+fileIdx).html(html);
		
		$("#"+fileIdx+"Label").html("");
	}
				
	function loadProductType( grade, objectId ) {
		var URL = "../common/productTypeListAjax";
		var groupCode = "PRODCAT"+grade;
		var codeValue = "";
		if( grade == '2' ) {
			codeValue = $("#productType1_versionUp").selectedValues()[0]+"-";
			$("#li_productType2_versionUp").hide();
			$("#li_productType3_versionUp").hide();
		} else if( grade == '3' ) {
			codeValue = $("#productType2_versionUp").selectedValues()[0]+"-";
			$("#li_productType3_versionUp").hide();
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
				//$("#label_"+objectId).html("전체");
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
		window.location.href="../manufacturingNo/dbView?seq="+seq;
	}
	
	function detailView(seq, popup) {
		var URL = "../manufacturingNo/manufacturingNoDataAjax";
		$.ajax({
			type:"POST",
			url:URL,
			data:{
				"seq":seq
			},
			dataType:"json",
			async:false,
			success:function(result) {
				var data = result.manufacturingNoData;
				$("#dd_productType").html(data.productType1Name+" / "+data.productType2Name+" / "+nvl(data.productType3Name,''));
				$("#dd_sterilization").html(data.sterilizationName);
				$("#dd_keepCondition").html(data.keepConditionName);
				//$("#dd_sellDate").html(data.sellDate1Text+" "+data.sellDate2+" "+data.sellDate3Text);
				if( nvl(data.sellDate4Text,'') != '') {
					$("#dd_sellDate").html(data.sellDate1Text+" "+data.sellDate2+" "+data.sellDate3Text+"<br/>"+data.sellDate4Text+" "+data.sellDate5+" "+data.sellDate6Text);
				} else {
					$("#dd_sellDate").html(data.sellDate1Text+" "+data.sellDate2+" "+data.sellDate3Text);
				}
				var oemText = "";
				if( data.referral == 'Y' ) {
					oemText += "위탁"
				}
				if( data.oem == 'Y' ) {
					if( oemText != "" ) {
						oemText += "/OEM"	
					}else {
						oemText += "OEM"
					}					
				}
				$("#dd_oem").html(oemText);
				if( data.createPlant != "" && data.referral == 'Y' ) {
					loadPlant2();
					$("#li_create_plant").show();
					var productCode = data.createPlant.split(',');
					for( var i = 0 ; i < productCode.length ; i++ ) {
						$("#plant_"+productCode[i].trim()).show();
					}
				}
				
				if( data.oemText != "" && data.oem == 'Y') {
					$("#li_oemText").show();
					$("#dd_oemText").html(data.oemText);
				}
				//$("#dd_manufacturingReportFile").html(data.manufacturingReportFileName);
				//$("#dd_sellDateReportFile").html(data.sellDateReportFileName);
				$("#dd_comment").html(data.comment);
				
			},
			error:function(request, status, errorThrown){
				alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
			}			
		});	
		openDialog(popup);
	}
	
	function loadPlant2() {
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
					html += "<span id=\"plant_"+value.plantCode+"\" style=\"display:none\">";
					if( count > 0 ) {
						html += " , ";
					}
					html += value.plantName
					html += "("+value.plantCode+")";
					html += "</span>";					
					count++;
				});
				$("#create_plant_list").html(html);
				$("#li_create_plant").show();
			},
			error:function(request, status, errorThrown){
					alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
			}			
		});
	}
	
	function addFilePopup(seq, popup) {
		$("#seq").val(seq);
		$("#mode").val('I');
		openDialog(popup);
	}
	
	function updateFilePopup(seq, fmNo, popup) {
		$("#seq").val(seq);
		$("#fmNo").val(fmNo);
		$("#mode").val('U');
		openDialog(popup);
	}
	
	function insertFile() {
		if(confirm("업로드 하시겠습니까?")){
			if( !chkNull($("#file3").val()) ) {
				 alert("품목제조보고서 파일을 선택하세요.");
				 return;
			} else {
				var formData = new FormData();
				formData.append("no_seq",$("#no_seq").val());
				formData.append("seq",$("#seq").val());
				formData.append("type",'manufacturingReport');
				formData.append("mode",$("#mode").val());
				formData.append("fmNo",$("#fmNo").val());
				formData.append("prevStatus",'${manufacturingNo.status}');				
				//첫번째 파일태그
				formData.append("file",$("input[name=file]")[0].files[0]);
				//두번째 파일태그
				formData.append("file",$("input[name=file]")[1].files[0]);
				var URL = "../manufacturingNo/insertFileAjax";
				$('#lab_loading').show();
				$.ajax({
					type:"POST",
					url:URL,
					traditional : true,
					data:formData,
					processData: false,
					contentType: false,
					success:function(result) {
						if( result.status == 'success') {
							alert("품목제조 보고서가 업로드 되었습니다.");
							window.location.href="../manufacturingNo/dbView?seq="+$("#no_seq").val();
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
	
	function insertFile2() {
		if(confirm("업로드 하시겠습니까?")){
			if( !chkNull($("#file4").val()) ) {
				 alert("소비기한설정사유서 파일을 선택하세요.");
				 return;
			} else {
				var formData = new FormData();
				formData.append("no_seq",$("#no_seq").val());
				formData.append("seq",$("#seq").val());
				formData.append("prevStatus",'${manufacturingNo.status}');
				formData.append("mode",$("#mode").val());
				formData.append("fmNo",$("#fmNo").val());
				formData.append("type",'sellDateReport');
				//첫번째 파일태그
				formData.append("file",$("input[name=file]")[0].files[0]);
				//두번째 파일태그
				formData.append("file",$("input[name=file]")[1].files[0]);
				var URL = "../manufacturingNo/insertFileAjax";
				$('#lab_loading').show();
				$.ajax({
					type:"POST",
					url:URL,
					traditional : true,
					data:formData,
					processData: false,
					contentType: false,
					success:function(result) {
						if( result.status == 'success') {
							alert("소비기한설정사유서가 업로드 되었습니다.");
							window.location.href="../manufacturingNo/dbView?seq="+$("#no_seq").val();
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
	
	function deleteFile(fmNo){
		if('파일을 삭제하시겠습니까?'){
			$('#lab_loading').show();
			$.ajax({
				url: '/file/deleteFileAjax',
				type: 'post',
				data: { fmNo: fmNo },
				success: function(data){
					if(data == 'S'){
						alert('정상적으로 삭제되었습니다')
						window.location.href="../manufacturingNo/dbView?seq="+$("#no_seq").val();
					} else if(data == 'E'){
						alert('파일 삭제 오류(1)');
						$('#lab_loading').hide();
					} else {
						alert('존재하지 않는 파일입니다');
						$('#lab_loading').hide();
					}
				},
				error: function(a,b,c){
					//console.log(a,b,c)
					alert('파일 삭제 오류(2)');
					$('#lab_loading').hide();
				}
			})
		}
	}
	
	//추가 파일 삭제 함수
	function deleteFileFromInput(e){
		var fileSpanId = $(e).parent().next().attr("id");
		var fileIndex = fileSpanId.slice(4);
		var fileId = "file"+fileIndex;
		$(e).parent().next().html("");
		if(fileId == "file3"){
			$("#"+ fileId+"Labe3").html("사용원재료 파일 등록");
		}else if(fileId == "file4"){
			$("#"+ fileId+"Labe4").html("포장지(표시사항) 파일 등록");
		}
		$("#"+ fileId).val("");
		$("#up"+ fileId).html("");
		return;
	}
	
	function qnsCheck(){
		if($("#checkQnsY").prop("checked")){
			$("#li_qns_versionUp").show();
			$("#li_filePacakge_versionUp").hide();
			$("#li_fileRawMaterial_versionUp").hide();
			$("#file3").prop("disabled", true);
			$("#file4").prop("disabled", true);
			$("#file3").val("");
			$("#file4").val("");
			$("#isQnsChanged").val("1");
		}else if($("#checkQnsN").prop("checked")){
			$("#qns").val("");
			$("#li_qns_versionUp").hide();
			$("#li_filePacakge_versionUp").show();
			$("#li_fileRawMaterial_versionUp").show();
			$("#file3").prop("disabled", false);
			$("#file4").prop("disabled", false);
			$("#isQnsChanged").val("2");
		}
	}
	
	function goCancel(id) {
		closeDialog(id);
		if(id == "versionUp"){
			$("#ul_versionUp dt").css("background-image", "url(../resources/images/img_dot.png)")
		}
	}
	
	function readProductDevDoc(docNo, docVersion){
		var form = document.createElement('form');
		//$(form).hide();
		form.style.display = 'none';
		$('body').append(form);
		form.action = '/dev/productDevDocDetail';
		form.target = '_blank';
		form.method = 'post';
		
		appendInput(form, 'docNo', docNo);
		appendInput(form, 'docVersion', docVersion);
		//appendInput(form, 'regUserId', regUserId);
		
		$(form).submit();
	}
	
	function loadCompany(selectBoxId) {
		var URL = "../common/companyListAjax";
		$.ajax({
			type:"POST",
			url:URL,
			data:{
			},
			dataType:"json",
			async:false,
			success:function(data) {
				var list = data.RESULT;
				$("#"+selectBoxId).removeOption(/./);
				$("#"+selectBoxId).addOption("", "전체", false);
				$("#label_"+selectBoxId).html("전체");
				$.each(list, function( index, value ){ //배열-> index, value
					$("#"+selectBoxId).addOption(value.companyCode, value.companyName, false);
				});
			},
			error:function(request, status, errorThrown){
					alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
			}			
		});
	}
	
	function companyChange(companySelectBoxId, selectBoxId) {
		var URL = "../common/plantListAjax";
		$.ajax({
			type:"POST",
			url:URL,
			data:{
				"companyCode" : $("#"+companySelectBoxId).selectedValues()[0]
			},
			dataType:"json",
			async:false,
			success:function(data) {
				var list = data.RESULT;
				$("#"+selectBoxId).removeOption(/./);
				$("#"+selectBoxId).addOption("", "전체", false);
				$("#label_"+selectBoxId).html("전체");
				$.each(list, function( index, value ){ //배열-> index, value
					$("#"+selectBoxId).addOption(value.plantCode, value.plantName, false);
				});
				$('#'+selectBoxId).parent().show();
			},
			error:function(request, status, errorThrown){
					alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
			}			
		});
	}
	
	function plantChange(licensingNo){
		var URL = "../manufacturingNo/licensingNoListAjax";
		if( licensingNo == 'searchLicensingNo' ) {
			if( $("#searchCompany").selectedValues()[0] != '' && $("#searchPlant").selectedValues()[0] != '') {	
				$.ajax({
					type:"POST",
					url:URL,
					data:{
						"companyCode" : $("#companyCode").selectedValues()[0],
						"plantCode" : $("#plant").selectedValues()[0]
					},
					dataType:"json",
					async:false,
					success:function(data) {
						var list = data;
						$("#licensingNo").removeOption(/./);
						$("#licensingNo").addOption("", "전체", false);
						//$("#label_searchLicensingNo").html("전체");
						$.each(list, function( index, value ){ //배열-> index, value
							var licensingNoTxt = "";
							if( nvl(value.plantName,'') == '' ) {
								licensingNoTxt = value.licensingNo;
							} else {
								licensingNoTxt = value.licensingNo+"("+value.plantName+")";
							}
							$("#licensingNo").addOption(value.licensingNo, licensingNoTxt, false);
						});
					},
					error:function(request, status, errorThrown){
							alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
					}			
				});	
			}
		} else {
			if( $("#companyCode").selectedValues()[0] != '' && $("#plant").selectedValues()[0] != '') {	
				$.ajax({
					type:"POST",
					url:URL,
					data:{
						"companyCode" : $("#companyCode").selectedValues()[0],
						"plantCode" : $("#plant").selectedValues()[0]
					},
					dataType:"json",
					async:false,
					success:function(data) {
						var list = data;
						$("#licensingNo").removeOption(/./);
						$("#licensingNo").addOption("", "전체", false);
						//$("#label_licensingNo").html("전체");
						$.each(list, function( index, value ){ //배열-> index, value
							var licensingNoTxt = "";
							if( nvl(value.plantName,'') == '' ) {
								licensingNoTxt = value.licensingNo;
							} else {
								licensingNoTxt = value.licensingNo+"("+value.plantName+")";
							}
							$("#licensingNo").addOption(value.licensingNo, licensingNoTxt, false);
						});
					},
					error:function(request, status, errorThrown){
							alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
					}			
				});	
			}
		}
	}
	
	function referralCheck() {
		if( $("input:checkbox[name=referral_versionUp]").is(":checked") == false ) {
			$("#createPlant").is("checked", false);
			$("#li_create_plant_versionUp").hide();
			$("#referral_versionUp").val("N");
		} else if($("input:checkbox[name=referral_versionUp]").is(":checked")){
			if($("#li_create_plant_versionUp").is(":visible") == false ) {
				if($("#create_plant_list_versionUp input").length <= 0 ) {
					loadPlant();
				}
				initializeCreatePlant();
				$("#li_create_plant_versionUp").show();
				$("#create_plant_list_versionUp input").prop("disabled", false);
			}
			$("#referral_versionUp").val("Y");
		}
	}
	
	function showPackageInput() {
		var count = 0;
		$('#packageUnit_versionUp :selected').each(function(i, sel){ 
		    if( $(sel).val() == '8' ) {
		    	count++;
		    }
		});
		if( count > 0 ) {
			$("#packageEtc_versionUp").val("");
			$("#packageEtc_versionUp").show();
		} else {
			$("#packageEtc_versionUp").val("");
			$("#packageEtc_versionUp").hide();
		}
	}
	
	function loadPackage(groupCode) {
		var URL = "../common/codeListAjax";
		$.ajax({
			type:"POST",
			url:URL,
			data:{
				"groupCode":groupCode
			}, dataType:"json",
			async:false,
			success:function(data) {
				var list = data.RESULT;			
				$("#packageUnit_versionUp").removeOption(/./);
				$.each(list, function( index, value ){ //배열-> index, value
					$("#packageUnit_versionUp").addOption(value.itemCode, value.itemName, false);
				});
			},
			error:function(request, status, errorThrown){
				$("#packageUnit_versionUp").removeOption(/./);
				alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
			}			
		});
	}
	
	//품보 변경 팝업
	function versionUpMNo(){
		var radioCounts = $("#list_versionUp input[type='radio']#versionUpRequestCheckable").length;
		var radioCheckedCount = $("#list_versionUp input[type='radio']:checked").length;
		if((radioCounts == radioCheckedCount) && radioCounts > 0){
			if($("#list_versionUp input[type='radio']#versionUpRequestCheckable:checked").length == 0){
				//전체 중단
				if(confirm("모든 제조공정서가 사용중단 처리되며, 품보 변경요청되지 않습니다. \n중단하시겠습니까?")){
					var html = "";
					html = manufacturingNoStop();
					alert("제조공정서번호 : \'" + html +"\'이(가) 사용중단 처리되었습니다.");
					location.reload();
				}else{
					return;
				}
			}else{
				openDialog('versionUp');		
			}
		}else if(radioCounts == 0){
			alert("변경/중단 가능한 제조공정서가 존재하지 않습니다. \n 품목제조보고 완료 상태에서만 변경/중단 요청 가능합니다.");
			return;
		}else{
			alert("변경/중단 대상을 모두 선택해주세요.");
			return;
		}
	}
	
	function manufacturingNoStop(){
		var stopDocNoArray = new Array();
		$($("#list_versionUp input[type='radio']#versionUpStopCheckable:checked")).each(function(){
			stopDocNoArray.push($(this).parent().parent().parent().find(":nth-child(3)").html());
		});
		
		var jsonData = {};
		for(var i = 0; i<stopDocNoArray.length; i++){
			$.ajax({
				url		: "/dev/stopManufacturingProcessDoc",
				type	: "POST",
				data	: { "dNo" : stopDocNoArray[i]},
				success	: function(result){
					if(result != "S"){
						alert("제조공정서 중단에 실패하였습니다. \n 관리자에게 문의 바랍니다.");
					}
				}
			});
		}
		return stopDocNoArray;
	}
	
	function updateQns(){
		html = "";
		var docNoArray = new Array();
		$($("#list_versionUp input[type='radio']#versionUpRequestCheckable:checked")).each(function(){
			docNoArray.push($(this).parent().parent().parent().find(":nth-child(3)").html());
		});
		
		var qns = $('#qns').val();
		var isQnsReviewTarget = $('input[name=isQnsReviewTarget]:checked').val()
		
		qns = isQnsReviewTarget == '1' ? qns : '';
		if(!qnsValid(qns, isQnsReviewTarget)){
			return;
		}
		
		docNoArray.forEach(function(e){
			var dNo = e;
			$.ajax({
			    url: '/dev/updateQns',
			    data: { 
			    	 dNo: dNo
			    	, qns: qns
			    	, isQnsReviewTarget: isQnsReviewTarget 
			    },
			    success: function(data){
			        //console.log(data);
			        if(data.status == "success"){
			        } else {
			        	alert("QNS 입력 중 실패하였습니다. 관리자에게 문의하시길 바랍니다.");
			        }
			    },
			    error: function(a,b,c){
			        alert("QNS 입력 중 실패하였습니다. 관리자에게 문의하시길 바랍니다.");
			    }
			})
		});
	}
	
	function qnsValid(qns, isQnsReviewTarget){
		
		// QNSH 검토 대상인 경우에만 적용
		if(isQnsReviewTarget == '1'){
			
			var regexp = /^[0-9]$/g;
			
			if(qns == ''){
				alert('QNSH 등록번호를 입력해주세요.');
				return false;
			}
			
			if(qns.length < 5){
				alert('QNSH 등록번호가 너무 짧습니다. 5자 이상 입력해주세요.' + '\n입력된 길이: ' + qns.length);
				return false;
			}
			
			if(qns.indexOf(' ') >= 0){
				alert('QNSH 등록번호에 공백값이 입력되었습니다.');
				return false;
			}
			
			if(isNumeric(qns)){
				alert('QNSH 등록번호에 숫자만 입력되었습니다.');
				return false;
			}
		}
		
		return true;
	}
	
	function isNumeric(num, opt){
		// 좌우 trim(공백제거)을 해준다.
		num = String(num).replace(/^\s+|\s+$/g, "");
		
		if(typeof opt == "undefined" || opt == "1"){
			// 모든 10진수 (부호 선택, 자릿수구분기호 선택, 소수점 선택)
			var regex = /^[+\-]?(([1-9][0-9]{0,2}(,[0-9]{3})*)|[0-9]+){1}(\.[0-9]+)?$/g;
		}else if(opt == "2"){
			// 부호 미사용, 자릿수구분기호 선택, 소수점 선택
			var regex = /^(([1-9][0-9]{0,2}(,[0-9]{3})*)|[0-9]+){1}(\.[0-9]+)?$/g;
		}else if(opt == "3"){
			// 부호 미사용, 자릿수구분기호 미사용, 소수점 선택
			var regex = /^[0-9]+(\.[0-9]+)?$/g;
		}else{
			// only 숫자만(부호 미사용, 자릿수구분기호 미사용, 소수점 미사용)
			var regex = /^[0-9]$/g;
		}
		
		if( regex.test(num) ){
		  num = num.replace(/,/g, "");
		  return isNaN(num) ? false : true;
		} else { 
			return false;  
		}
	}
	
	//품목제조보고서 변경(versionUp)
	function manufacturingNoVersionUp(){
		$("#ul_versionUp dt").css("background-image", "url(../resources/images/img_dot.png)");
		if($("#checkQnsY").prop("checked")){
			var qns = $('#qns').val();
			var isQnsReviewTarget = $('input[name=isQnsReviewTarget]:checked').val()
			qns = isQnsReviewTarget == '1' ? qns : '';
			if(!qnsValid(qns, isQnsReviewTarget)){
				return;
			}
		}
		
		var html = "";
		var sellDate1 = $("#sellDate1").selectedValues()[0] + $("#sellDate2").val() + $("#sellDate3").selectedValues()[0];
		var sellDate4 = $("#sellDate4").selectedValues()[0] + $("#sellDate5").val() + $("#sellDate6").selectedValues()[0];
		if($("#dd_versionUp_target_check input:checked").length == 0){
			alert("변경사항을 확인해주세요.");
			return;
			$("#dd_versionUp_target_check input").focus();
			$("#dd_versionUp_target_check").prev().css("background-image", "url(../resources/images/bg_menu_dot2.gif)");
		}else if($("#versionUp_for_manufacturingName").prop("checked") &&
				($("#isValid_versionUp").val() == "N" || globalExistingJson.manufacturingName == $("#input_manufacturingName_versionUp").val())){
			alert("품목명이 변경되지 않았습니다.");
			$("#input_manufacturingName_versionUp").focus();
			$("#input_manufacturingName_versionUp").parent().parent().parent().prev().css("background-image", "url(../resources/images/bg_menu_dot2.gif)");
			return;
		}else if($("#versionUp_for_keepCondition").prop("checked") &&
				($("#keepCondition_versionUp").selectedValues()[0] == ("" || globalExistingJson.keepCondition))){
			alert("보관조건이 변경되지 않았습니다.");
			$("#keepCondition_versionUp").focus();
			$("#keepCondition_versionUp").parent().prev().css("background-image", "url(../resources/images/bg_menu_dot2.gif)");
			return;
		}else if($("#versionUp_for_sellDate").prop("checked") && (sellDate1 == globalExistingJson.sellDate1) && (sellDate4 == globalExistingJson.sellDate4)){
			alert("소비기한이 변경되지 않았습니다.");
			$("#sellDate1").focus();
			$("#dd_sellDate_versionUp").prev().css("background-image", "url(../resources/images/bg_menu_dot2.gif)");
			return;
		}else if($("#versionUp_for_sellDate").prop("checked") && $("#sellDate4").selectedValues()[0].replaceAll(" ","").length > 0 && !chkNull($("#sellDate5").val())){
			alert("소비기한을 선택해주세요.");
			$("#sellDate5").focus();
			$("#dd_sellDate_versionUp").prev().css("background-image", "url(../resources/images/bg_menu_dot2.gif)");
			return;
		}else if($("#versionUp_for_sellDate").prop("checked") && $("#sellDate4").selectedValues()[0].replaceAll(" ","").length > 0 && !chkNull($("#sellDate6").selectedValues()[0])){
			alert("소비기한을 선택해주세요.");
			$("#sellDate6").focus();
			$("#dd_sellDate_versionUp").prev().css("background-image", "url(../resources/images/bg_menu_dot2.gif)");
			return;
		}else if($("#versionUp_for_sellDate").prop("checked") && $("#sellDate4").selectedValues()[0].replaceAll(" ","").length == 0 && chkNull($("#sellDate5").val())){
			alert("소비기한을 선택해주세요.");
			$("#sellDate4").focus();
			$("#dd_sellDate_versionUp").prev().css("background-image", "url(../resources/images/bg_menu_dot2.gif)");
			return;
		}else if($("#versionUp_for_sellDate").prop("checked") && $("#sellDate4").selectedValues()[0].replaceAll(" ","").length == 0 && chkNull($("#sellDate6").selectedValues()[0])){
			alert("소비기한을 선택해주세요.");
			$("#sellDate4").focus();
			$("#dd_sellDate_versionUp").prev().css("background-image", "url(../resources/images/bg_menu_dot2.gif)");
			return;
		}else if($("#versionUp_for_material").prop("checked") && $("input[name=checkQns]:checked").length <= 0 ){
			alert("QNSH가 검토되지 않았습니다.");
			$("#dd_qns_versionUp").prev().css("background-image", "url(../resources/images/bg_menu_dot2.gif)");
			return;
		}else if($("#versionUp_for_material").prop("checked") && $("#checkQnsN:checked").length >=1 && $("#file3").val().length == 0){
			alert("원재료 파일이 첨부되지 않았습니다.");
			$("#file3").parent().prev().css("background-image", "url(../resources/images/bg_menu_dot2.gif)");
			return;
		}else if($("#versionUp_for_material").prop("checked") && $("#checkQnsN:checked").length >=1 && $("#file4").val().length == 0){
			alert("포장지 시안이 첨부되지 않았습니다.");
			$("#file4").parent().prev().css("background-image", "url(../resources/images/bg_menu_dot2.gif)");
			return;
		}else if($("#versionUp_for_etc").prop("checked") && globalExistingJson.sterilization == $("#sterilization_versionUp").selectedValues()[0]
			&& globalExistingJson.referral == $("#referral_versionUp").prop("checked") && globalExistingJson.OEM == $("#oem_versionUp").prop("checked")
			&& globalExistingJson.comment == $("#comment_versionUp").val()){
			alert("기타 사항이 변경되지 않았습니다.")
			$("#dd_sterilization_versionUp").prev().css("background-image", "url(../resources/images/bg_menu_dot2.gif)");
			$("#dd_oem_versionUp").prev().css("background-image", "url(../resources/images/bg_menu_dot2.gif)");
			$("#dd_comment_versionUp").prev().css("background-image", "url(../resources/images/bg_menu_dot2.gif)");
			return;
		}else{
			var productType1, productType2, productType2, sterilization, keepCondition, keepConditionText, sellDate1, sellDate2, sellDate3, sellDate4, sellDate5, sellDate6;
			var referral, oem, oemText, createPlant, packageUnit, packageEtc, comment, qns;
			var manufacturingNameChange, keepConditionChange, sellDateChange, QNSChange, etcChange, OEMChange, referralChange, commentChange;
			
			packageArray = new Array();
			$('#packageUnit_versionUp :selected').each(function(i, sel){ 
				packageArray.push($(sel).val());
			});
			
			plantArray = new Array();
			$('input:checkbox[name="createPlant"]:checked').each(function(i, sel) {
				plantArray.push($(sel).val());
			});
			
			qns = $("#checkQnsY").is(":checked") ? $("#qns").val() : "QNSH 검토 대상이 아님";
						
			referral				= nullCheck(referral,					$("#referral_versionUp").val());
			oem						= nullCheck(oem,						$("#oem_versionUp").val());
			oemText					= nullCheck(oemText,					$("#oemText_versionUp").val().replace(/(?:\r\n|\r|\n)/g, " "));
			plantArray				= nullCheck(plantArray,					$("#referral_versionUp").is(":checked")? plantArray : "");
			packageArray			= nullCheck(packageArray,				packageArray);
			packageEtc				= nullCheck(packageEtc,					$('#packageEtc_versionUp').val());
			comment					= nullCheck(comment,					$("#comment_versionUp").val().replace(/(?:\r\n|\r|\n)/g, " "));
			qns						= nullCheck(qns,						qns);
			
			manufacturingNameChange = nullCheck(manufacturingNameChange,	$("#versionUp_for_manufacturingName").is(":checked")? "Y" : "N");
			keepConditionChange		= nullCheck(keepConditionChange, 		$("#versionUp_for_keepCondition").is(":checked")? "Y" : "N");
			sellDateChange			= nullCheck(sellDateChange, 			$("#versionUp_for_sellDate").is(":checked")? "Y" : "N");
			QNSChange				= nullCheck(QNSChange, 					$("#versionUp_for_material").is(":checked")? "Y" : "N");
			etcChange				= nullCheck(etcChange,					$("#versionUp_for_etc").is(":checked")? "Y" : "N");

			var versionUpDocNoArray = new Array();
			$($("#list_versionUp input[type='radio']#versionUpRequestCheckable:checked")).each(function(){
				versionUpDocNoArray.push($(this).parent().parent().parent().find(":nth-child(3)").html());
			});
			
			var stopDocNoArray = new Array();
			$($("#list_versionUp input[type='radio']#versionUpStopCheckable:checked")).each(function(){
				stopDocNoArray.push($(this).parent().parent().parent().find(":nth-child(3)").html());
			});
			
			var jsonData = {
					"seq"						: "${manufacturingNo.seq }",
					"manufacturingName"			: $("#input_manufacturingName_versionUp").val(),
					"companyCode"				: "${manufacturingNo.companyCode}",
					"plantCode"					: "${manufacturingNo.plantCode }",
					"licensingNo"				: "${manufacturingNo.licensingNo}",
					"manufacturingNo"			: "${manufacturingNo.manufacturingNo}",
					"isDelete"					: "N",
					"versionNo"					: "${manufacturingNo.versionNo +1}",
					"productType1"				: $("#productType1_versionUp").selectedValues()[0],
					"sterilization"				: $("#sterilization_versionUp").selectedValues()[0],
					"sellDate1"					: $("#sellDate1").selectedValues()[0],
					"sellDate2"					: $("#sellDate2").val(),
					"sellDate3"					: $("#sellDate3").selectedValues()[0],
					"packageUnit"				: packageArray,
					"requestDocNoArray"			: versionUpDocNoArray,
					"stopDocNoArray"			: stopDocNoArray,
					"comment"					: comment,
					"oem"						: oem,
					"oemText"					: oemText,
					"referral"					: referral,
					"regType"					: "C",
					"status"					: "RC",
					"prevStatus"				: "C",
					"keepCondition"				: $("#keepCondition_versionUp").selectedValues()[0],
					"packageUnit"				: packageArray,
					"packageEtc"				: packageEtc,
					"createPlant"				: plantArray,
					"manufacturingNameChange"	: manufacturingNameChange,
					"keepConditionChange"		: keepConditionChange,
					"sellDateChange"			: sellDateChange,
					"QNSChange"					: QNSChange,
					"etcChange"					: etcChange,
					"qns"						: qns
			}
			
			if($("#productType2_versionUp").selectedValues()[0].length > 0){
				jsonData.productType2	=  $("#productType2_versionUp").selectedValues()[0];
			}
			
			if($("#productType3_versionUp").selectedValues()[0].length > 0){
				jsonData.productType3	=  $("#productType3_versionUp").selectedValues()[0];
			}
			
			if($("#sellDate4").selectedValues()[0].length > 0){
				jsonData.sellDate4		= $("#sellDate4").selectedValues()[0];
				jsonData.sellDate5		= $("#sellDate2").val();
				jsonData.sellDate6		= $("#sellDate3").selectedValues()[0];
			}
			
			if($("#productType2_versionUp").selectedValues()[0].length > 0){
				jsonData.productType2	= $("#productType2_versionUp").selectedValues()[0];
			}
			
			if($("#productType3_versionUp").selectedValues()[0].length > 0){
				jsonData.productType3	= $("#productType3_versionUp").selectedValues()[0];
			}
			$('#lab_loading').show();
			
			//페이지 redirection에 필요한 params
			var seq = "";
			var no_seq = "";
			var newVersion = "";
			var licensingNo = "";
			var manufacturingNo = "";
			var versionNo = "";
			var hrefText ="";
			var html = "";
			var docNo = "";
			
			$.ajax({
				type		: "POST",
				url			: "/manufacturingNo/updateVersionUp",
				data		: jsonData,
				traditional : true,
				dataType	: "json",
				success		: function(result){
					//페이지 redirection에 필요한 params
					seq = parseInt(result.insert.seq);
					no_seq = parseInt(seq) + 100000;
					newVersion = result.insert.versionNo;
					licensingNo = result.insert.licensingNo;
					manufacturingNo = result.insert.manufacturingNo;
					versionNo = result.insert.versionNo;
					docNo = result.insert.docNo;
					hrefText = "/manufacturingNo/versionUp?licensingNo="+licensingNo+"&manufacturingNo="+manufacturingNo+"&versionNo="+versionNo+"&seq="+seq+"&docNo="+docNo;
					
					if($("#list_versionUp input[type='radio']#versionUpStopCheckable:checked").length > 0){
						manufacturingNoStop();
						html += "제조공정서번호 : \'" + stopDocNoArray.join(", ") +"\'이(가) 사용중단 처리되었습니다. \n" ;
					}
					html += "품목제조보고서(품보번호 : " + manufacturingNo +")가 변경요청 되었습니다. ";
					
					if($("#checkQnsN").prop("checked")){
						var formData = new FormData();
						var filePath = document.getElementById("file3").value;
						var fileName = filePath.substring(filePath.lastIndexOf('\\') + 1,	filePath.length);
						var existingManufacturingNo = "${manufacturingNo.licensingNo}" + "-" + "${manufacturingNo.manufacturingNo}";
						var newManufacturingNo = result.insert.licensingNo + "-" + result.insert.manufacturingNo;
						
						formData.append("seq", seq);
						formData.append("no_seq", no_seq);
						formData.append("prevStatus", "${manufacturingNo.status }");
						formData.append("type", "manufacturingVersionUpRawMaterial");
						formData.append("mode", "I");
						formData.append("tbKey", seq);
						formData.append("fmNo", seq);
						formData.append("file", $("#file3")[0].files[0]);
						$.ajax({
							type		: "POST",
							url			: "../manufacturingNo/insertFileAjax",
							traditional	: true,
							data		: formData,
							processData	: false,
							contentType	: false,
							success		: function(result){
								filePath = document.getElementById("file4").value;
								fileName = filePath.substring(filePath.lastIndexOf('\\') + 1,	filePath.length);
								formData = new FormData();
								formData.append("seq", seq);
								formData.append("no_seq", no_seq);
								formData.append("prevStatus", "${manufacturingNo.status }");
								formData.append("type", "manufacturingVersionUpPackage");
								formData.append("mode", "I");
								formData.append("tbKey", seq);
								formData.append("fmNo", seq);
								formData.append("file", $("#file4")[0].files[0]);
								$.ajax({
									type		: "POST",
									url			: "../manufacturingNo/insertFileAjax",
									traditional	: true,
									data		: formData,
									processData	: false,
									contentType	: false,
									success		: function(result){
									},
									error		: function(){
										$('#lab_loading').hide();
										html = "포장재 시안 등록 중 오류가 발생하였습니다.\n 관리자에게 문의 바랍니다.";
										window.location.href = hrefText;
									}
								});								
							}, error : function(request, status, errorThrown){
								$('#lab_loading').hide();
								html = "원재료 파일 등록 중 오류가 발생하였습니다.\n 관리자에게 문의 바랍니다.";
								window.location.href = hrefText;
							}
						});
					}else if($("#checkQnsY").prop("checked")){
						updateQns();
					}
				}, error: function(){
					html = "품목제조보고서 변경 요청 중 오류가 발생하였습니다.\n 관리자에게 문의 바랍니다.";
					alert(html);
					window.location.href = hrefText;
				}, complete : function(){
					alert(html);
					window.location.href = hrefText;
				}
			});
			
			//window.location.href = "/manufacturingNo/versionUp?licensingNo="+licensingNo+"&manufacturingNo="+manufacturingNo+"&versionNo="+versionNo+"&seq="+seq;
		}
	}
	
	function callExistingParams(){
		var existingJson = {
				"manufacturingName"	: "${manufacturingNo.manufacturingName }",
				"keepCondition"		: $("#keepCondition_versionUp").selectedValues()[0],
				"sellDate1"			: $("#sellDate1").selectedValues()[0] + $("#sellDate2").val() + $("#sellDate3").selectedValues()[0],
				"sellDate4"			: $("#sellDate4").selectedValues()[0] + $("#sellDate5").val() + $("#sellDate6").selectedValues()[0],
				"sterilization"		: $("#sterilization_versionUp").selectedValues()[0],
				"referral"			: $("#referral_versionUp").prop("checked"),
				"OEM"				: $("#oem_versionUp").prop("checked"),
				"comment"			: $("#dd_comment_versionUp textarea").val()		
		}
		return existingJson;
	}
	
	function nullCheck(varName, varValue){
		varName = varValue;
		(varName.length > 0) ? varName = varValue : '';
		return varName;
	}
	
	function checkName() {
		$('#lab_loading').show();
		var URL = "../manufacturingNo/checkName";
 		$.ajax({
			type: 'post',
			url: URL, 
			data:{
				"companyCode"		: '${manufacturingNo.companyCode}',
				"plantCode"			: '${manufacturingNo.plantCode }',
				"licensingNo"		: '${manufacturingNo.licensingNo}',
				"manufacturingName"	: $("#input_manufacturingName_versionUp").val()
			},
			dataType: 'json',
			async : true,
			success: function (data) {
				$('#lab_loading').hide();
				if(data.result == 'F'){
					$('#isValid_versionUp').val("N");
					$('#manufacturingName_versionUp_temp').val($('#input_manufacturingName_versionUp').val());				
					return;
				} else {
					if(data.checkName > 0){
						$('#checkName_versionUp').html('<font color="red" font-size="10px">이미 사용중인 품목명 입니다.</font>');
						$('#isValid_versionUp').val("N");
						$('#manufacturingName_versionUp_temp').val("");
					} else {
						$('#checkName_versionUp').html('<font color="blue" font-size="10px">사용가능한 품목명입니다.</font>');
						$('#isValid_verisonUp').val("Y");
						$('#manufacturingName_versionUp_temp').val($('#input_manufacturingName_versionUp').val());
						isValid = true;
					}
				}
			},error: function(XMLHttpRequest, textStatus, errorThrown){
				$('#lab_loading').hide();
				$('#isValid_versionUp').val("N");
				$('#manufacturingName_versionUp_temp').val("");
			}
		});
	};
	
	
	function versionUpTargetCheck(){
			if($("#versionUp_for_manufacturingName").prop("checked")){
				$("#div_manufacturingName_versionUp").show();
			}else{
				$("#input_manufacturingName_versionUp").val("${manufacturingNo.manufacturingName}");
				$("#div_manufacturingName_versionUp").hide();
			}
			
			if($("#versionUp_for_sellDate").prop("checked")){
				$("#sellDate1").prop("disabled", false);
				$("#sellDate2").prop("disabled", false);
				$("#sellDate3").prop("disabled", false);
				$("#sellDate4").prop("disabled", false);
				$("#sellDate5").prop("disabled", false);
				$("#sellDate6").prop("disabled", false);
				$("#sellDate1").show().focus().click();
			}else{
				$("#sellDate1").prop("disabled", true);
				$("#sellDate2").prop("disabled", true);
				$("#sellDate3").prop("disabled", true);
				$("#sellDate4").prop("disabled", true);
				$("#sellDate5").prop("disabled", true);
				$("#sellDate6").prop("disabled", true);
				initializeSellDate();
			}
			
			if($("#versionUp_for_keepCondition").prop("checked")){
				$("#keepCondition_versionUp").prop("disabled", false);
				$("#keepCondition_versionUp").show().focus().click();
			}else{
				$("#keepCondition_versionUp").prop("disabled", true);
				initializeKeepCondition();
			}
			
			if($("#versionUp_for_etc").prop("checked")){
				//살균, 위탁/oem, 비고
				$("#dd_sterilization_versionUp #sterilization_versionUp").prop("disabled", false);
				$("#dd_sterilization_versionUp #sterilization_versionUp").show().focus().click();
				$("#referral_versionUp").prop("disabled", false);
				$("#oem_versionUp").prop("disabled", false);
				$("input[name='createPlant']").prop("disabled", false);
				$("#dd_comment_versionUp textarea").prop("disabled", false);
			}else{
				$("#dd_sterilization_versionUp #sterilization_versionUp").prop("disabled", true);
				$('#dd_sterilization_versionUp #sterilization_versionUp option[value='+'${manufacturingNo.sterilization}'+']').prop('selected', true);
				$("#referral_versionUp").prop("disabled", true);
				$("#create_plant_list_versionUp input").prop("disabled", true);
				$("#oem_versionUp").prop("disabled", true);
				$("#dd_comment_versionUp textarea").prop("disabled", true);
				initializeComment();
				initializeCreatePlant();
				initializeOem();
			}
			
			if($("#versionUp_for_material").prop("checked")){
				$("input[name='checkQns']").prop("disabled", false);
				$("#qns").prop("disabled", false);
				$("#isQnsChanged").val('1');
			}else{
				$("input[name='checkQns']").prop("disabled", true);
				$("input[name='checkQns']").prop("checked", false);
				$("#qns").val("");
				$("#qns").prop("disabled", true);
				$("#li_qns_versionUp").hide();
				$("#li_fileRawMaterial_versionUp").hide();
				$("#li_filePacakge_versionUp").hide();
				$("#isQnsChanged").val('0');
			}
		}
	
	
	//전체 변경 or 전체 중단 클릭
	function checkAllRadios(target){
		if(target == 'versionUp'){
			$("#list_versionUp input[type='radio']#versionUpRequestCheckable").prop("checked", true);
		}else if(target == 'versionStop'){
			$("#list_versionUp input[type='radio']#versionUpStopCheckable").prop("checked", true);
		}
	}
	
	//radio 선택이 통일되지 않았을 때
	function checkRadios(){
		if($("#list_versionUp input[type='radio']#versionUpRequestCheckable:checked").length != $("#list_versionUp input[type='radio']#versionUpRequestCheckable").length){
			$("input[name='checkAll']").prop("checked", false);
		}
		if($("#list_versionUp input[type='radio']#versionUpRequestCheckable:checked").length == $("#list_versionUp input[type='radio']#versionUpRequestCheckable").length){
			$("#checkAllForVersionUp").prop("checked", true);
		}
		if($("#list_versionUp input[type='radio']#versionUpStopCheckable:checked").length == $("#list_versionUp input[type='radio']#versionUpStopCheckable").length){
			$("#checkAllForVersionStop").prop("checked", true);
		}
	}
	
	function changeVersion(versionNo, seq){
		var licensingNo 	= "${manufacturingNo.licensingNo}";
		var manufacturingNo = "${manufacturingNo.manufacturingNo}";
		var docNo 			= "${manufacturingNo.dNo}";
		window.location.href="/manufacturingNo/versionUp?licensingNo="+licensingNo+"&manufacturingNo="+manufacturingNo+"&seq="+seq+"&versionNo="+versionNo+"&docNo="+docNo;	
	}
	
	function chkQnsInput(event){
		var keyCode = event.keyCode;
		var objValue = event.target.value;
		var reg = /[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/;
		var availableKeys = [8, 144, 13, 17, 91, 18, 16, 46, 27, 36, 35, 21, 20, 9, 189, 109];
		//백스페이스, NumLock, enter, ctrl, window, alt, shift, delete, esc, home, end, 한/영, CapsLock, tab, 키패드 -, -
		var isValidKey = (
				  (keyCode >= 48 && keyCode <= 57) //숫자만
				||(keyCode >= 96 && keyCode <= 105) //키패드 숫자
				||(keyCode >= 65 && keyCode <= 90) //영어 알파벳만
				||(keyCode >= 112 && keyCode <= 123) //function키
				||(availableKeys.includes(keyCode)) 
		) && (keyCode != 229) // 한글;
		if(!isValidKey){
			alert("영어/숫자/특정 특수기호(-)만 입력할 수 있습니다.");
			$("#qns").val(objValue.slice(0, -1));
		}else if(/[^0-9a-zA-Z-]/.test($("#qns").val())){ //복사할 경우 대비
			alert("영어/숫자/특정 특수기호(-)만 입력할 수 있습니다.");
			$("#qns").val(objValue.replace(/[^0-9a-zA-Z-]/gi, ""));
		}
	}
	
</script>

<style>
.selectbox_popup { border: 1px solid #cf451b; border-radius:5px;/* 테두리 설정 */ z-index: 1; background-color:#fff;font-family:'맑은고딕',Malgun Gothic; color:#000; font-size:13px; padding: 2px 3px  5px 3px;}
input[type="checkbox"]:focus {		outline-color : #0078a5;	outline-style: solid;	outline-width : 1px;	}
textarea:focus {		outline-color : #0078a5;	outline-style: solid;	outline-width : 1px;	}

</style>

<div class="wrap_in" id="fixNextTag">
	<input type="hidden" name="pageNo" id="pageNo" value="${pageNo}" />
	<input type="hidden" name="maxVersionNo" id="maxVersionNo" value="${manufacturingVersion[0].maxVersionNo } " />
	<input type="hidden" id="isQnsChanged" />
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
			<!-- <div class="title5"><span class="txt">01.기준정보</span></div> -->
			<div class="tab03">
				<ul>
					<c:forEach var="versionItem" items="${manufacturingVersion }" varStatus="status">
						<a href="javascript:changeVersion(${versionItem.versionNo }, ${versionItem.seq })">
							<li class="${versionItem.versionNo == versionNo ? 'select' : '' }">
								<c:if test="${status.index == 0 }">[최신]</c:if> Version ${versionItem.versionNo }
							</li>
						</a>
					</c:forEach>
				</ul>
			</div>
			<div class="list_detail2">
				<ul>
					<li class="pt10">
						<dt>공장</dt>
						<dd>
							${manufacturingNo.companyName} - ${manufacturingNo.plantName}
						</dd>
						<dt>소비기한</dt>
						<dd>
							${manufacturingNo.sellDate1Text}&nbsp;${manufacturingNo.sellDate2}${manufacturingNo.sellDate3Text}&nbsp;까지
							<c:if test="${manufacturingNo.sellDate4Text != null && manufacturingNo.sellDate4Text != ''}">
							<br/>
							${manufacturingNo.sellDate4Text}&nbsp;${manufacturingNo.sellDate5}${manufacturingNo.sellDate6Text}&nbsp;까지
							</c:if>
							
						</dd>
					</li>
					<li>
						<dt>공장 인허가번호</dt>
						<dd>
							${manufacturingNo.licensingNo}
						</dd>
						<dt>보관조건</dt>
						<dd>
							${manufacturingNo.keepConditionName}&nbsp;${manufacturingNo.keepConditionText} 
						</dd>
					</li>
					<li>
						<dt>품목번호</dt>
						<dd>
							${manufacturingNo.manufacturingNo}
						</dd>
						<dt>살균여부</dt>
						<dd>
							${manufacturingNo.sterilizationName}
						</dd>
					</li>
					<li>
						<dt>품목명</dt>
						<dd>
							${manufacturingNo.manufacturingName}
						</dd>
						<dt>포장재질</dt>
						<dd>
							${manufacturingNo.packageUnitNames}
						</dd>
					</li>	
					<li>
						<dt>문서상태</dt>
						<dd>
							${manufacturingNo.statusName}
						</dd>
						<dt>위탁공장</dt>
						<dd>
							<c:if test="${fn:length(plantList) > 0}">
								<c:forEach items="${plantList}" var="item">
								${item.plantName}(${item.plantCode})&nbsp;/&nbsp; 
								</c:forEach>
							</c:if>
						</dd>
					</li>
					<li>
						<dt>식품유형</dt>
						<dd>
							${manufacturingNo.productType1Name} / ${manufacturingNo.productType2Name} / ${manufacturingNo.productType3Name}
						</dd>
						<dt>출시일</dt>
						<dd>
							${launchDate}
						</dd>
					</li>
					<li>
						<dt>생산일</dt>
						<dd>
							
						</dd>
						<dt>D-Day</dt>
						<dd>
							
						</dd>
					</li>
				</ul>			
			</div>
			<div class="title5" id="div_versionUpReason" style="display: none;"><span class="txt">변경 내용</span></div>
			<div class="main_tbl" id="tbl_versionUpReason" style="display: none;">
				<table class="tbl01">
					<colgroup>
						<col width="5%">
						<col width="5%">
						<col width="45%">
						<col width="5%">
						<col width="45%">
					</colgroup>
					<thead>
						<tr>
							<th colspan="2">변경사항</th>
							<th>변경 전</th>
							<th>&nbsp;</th>
							<th>변경 후</th>
						</tr>
					</thead>
					<tbody id="list_versionUpReason">
					</tbody>
				</table>
			</div>
			<div class="title5"><span class="txt">제조공정서</span></div>
			<div class="main_tbl">
				<table class="tbl01">
					<colgroup>
						<col width="45px">
						<col width="6%">
						<col width="8%">
						<col width="10%">						
						<col />
						<col width="15%">
						<col width="15%">
						<col width="10%">
						<col width="10%">
						<col width="10%">
					</colgroup>
					<thead>
						<tr>
							<th rowspan="2">&nbsp;</th>
							<th rowspan="2">제조공정서<br/>버전</th>
							<th rowspan="2">문서번호</th>
							<th rowspan="2">제품코드</th>
							<th rowspan="2">제품명</th>
							<th rowspan="2">담당자</th>
							<th rowspan="2">BOM 입력시점</th>
							<th rowspan="2">포장지 투입시점</th>
							<th colspan="2" style="border-bottom: none;">변경제품 확인</th>					
						</tr>
						<tr>
							<th><input type="radio" name="checkAll" id="checkAllForVersionUp" onclick="checkAllRadios('versionUp')"style="display: inline-block;"/><label for="checkAllForVersionUp">전체 변경</label></th>
							<th><input type="radio" name="checkAll" id="checkAllForVersionStop" onclick="checkAllRadios('versionStop')" style="display: inline-block;"/><label for="checkAllForVersionStop">전체 중단</label></th>
						</tr>
					</thead>
					<tbody id="list_versionUp">
						<c:set var="isMaxVersion" value="${manufacturingVersion[0].maxVersionNo }" />
						<c:if test="${fn:length(manufacturingDocList)==0}">
							<tr>
								<td colspan="7">데이터가 없습니다.</td>
							</tr>
						</c:if>
						<c:if test="${fn:length(manufacturingDocList)>0}">
							<c:forEach items="${manufacturingDocList}" var="item" varStatus="itemCount">
								<c:set var="isLatest" value="${item.docVersion == item.maxVersion }" />
								<c:set var="isFirst" value="${item.rowNumber ==1 }" />
								<c:set var="display" value="${isLatest ? 'display' : 'none' }" />
								<c:set var="hasChild" value="${(item.docVersion != 1 && isLatest && item.versionCount != 1) }" />
								<c:set var="isVisible" value="${item.isClose != 0 ? 'm_visible' : '' }" />
								<c:set var="isEditable" value="${item.devDocLastestVersion == item.docVersion }" />
								<c:set var="isStopped" value="${item.state == '6' }" /> <!-- 제조공정서 중지 여부 -->
								<c:choose>
									<c:when test="${isLatest }">									
										<tr id="devDoc_${item.docNo}_${item.docVersion}_${item.rowNumber}" style="${isStopped ? 'background:#e0e0e0; color:#8a8a8a;' : ''}">
											<c:choose>
												<c:when test="${hasChild && isFirst }">
													<td>
														<img src="/resources/images/img_add_doc.png" style="cursor: pointer;" onclick="showChildVersion(this)"/>
													</td>
												</c:when>
												<c:when test="${hasChild && !isFirst }"> <!-- 같은 버전이 최고 버전일 때 두 번째부터는 버튼 표시 X -->
													<td style="padding: 0;">
														<img src="/resources/images/bg_ver.png" style="margin-left: 10px;"/>
													</td>
												</c:when>
												<c:otherwise>
													<td></td>
												</c:otherwise>
											</c:choose>
											<td><span class="${hasChild ? 'font19' : ''}">${item.docVersion}</span></td>
											<td>${item.dNo}</td>
											<td>${item.productCode}</td>
											<td><div class="ellipsis_txt tgnl"><a href="#none" onclick="readProductDevDoc(${item.docNo},${item.docVersion})">${item.productName}</a></div></td>
											<td>${item.userName}</td>
											<td>${item.regDate}</td>
											<td>&nbsp;</td>
											<c:choose>
												<c:when test="${isEditable && (item.versionNo == isMaxVersion) && !isStopped && item.status =='C' }">
													<td>
														<label><input type="radio" name="versionUpRadio_${item.docNo}_${item.docVersion}_${item.rowNumber}" id="versionUpRequestCheckable" style="display: block;" onclick="checkRadios()"/>변경대상</label>
													</td>
													<td>
														<label><input type="radio" name="versionUpRadio_${item.docNo}_${item.docVersion}_${item.rowNumber}" id="versionUpStopCheckable" style="display: block;" onclick="checkRadios()"/>중단제품</label>
													</td>
												</c:when>
												<c:otherwise>
													<td>
														<label><input type="radio" id="versionUpRequest" disabled="disabled" style="display: block;" onclick="checkRadios()"/>변경불가</label>
													</td>
													<td>
														<label><input type="radio" id="versionUpStop" disabled="disabled" style="display: block;" onclick="checkRadios()"/>중단불가</label>
													</td>
												</c:otherwise>
											</c:choose>
										</tr>
									</c:when>
									<c:otherwise>
										<tr id="devDoc_old_${item.docNo}_${item.docVersion}_${item.rowNumber}" class="m_version ${isVisible}" style="display: none" ><!--  -->
											<td>
												<c:if test="${hasChild }">
													<img src="/resources/images/img_add_doc.png" style="cursor: pointer;" onclick=""/>
												</c:if>
											</td>
											<td><span class="${hasChild ? 'font19' : ''}">${item.docVersion}</span></td>
											<td>${item.dNo}</td>
											<td>${item.productCode}</td>
											<td><div class="ellipsis_txt tgnl"><a href="#none" onclick="readProductDevDoc(${item.docNo},${item.docVersion})">${item.productName}</a></div></td>
											<td>${item.userName}</td>
											<td>${item.regDate}</td>
											<td>&nbsp;</td>
											<c:choose>
												<c:when test="${isEditable  && (item.versionNo == isMaxVersion) && !isStopped && item.status =='C'}">
													<td>
														<label><input type="checkbox" id="versionUpRequestCheckable" name="versionUpRadio_${item.docNo}_${item.docVersion}_${item.rowNumber}" style="display: block;" onclick="checkRadios()"/>변경대상</label>
													</td>
													<td>
														<label><input type="checkbox" id="versionUpStopCheckable" name="versionUpRadio_${item.docNo}_${item.docVersion}_${item.rowNumber}" style="display: block;" onclick="checkRadios()"/>중단제품</label>
													</td>
												</c:when>
												<c:otherwise>
													<td>
														<label><input type="radio" id="versionUpRequest" disabled="disabled" style="display: block;" onclick="checkRadios()"/>변경불가</label>
													</td>
													<td>
														<label><input type="radio" id="versionUpStop" disabled="disabled" style="display: block;" onclick="checkRadios()"/>중단불가</label>
													</td>
												</c:otherwise>
											</c:choose>
										</tr>
									</c:otherwise>	
								</c:choose>
							</c:forEach>
						</c:if>
					</tbody>
				</table>	
			</div>
			
			
			<div class="title5"><span class="txt">상세정보</span></div>
			<div class="main_tbl">
				<table class="tbl01">
					<colgroup>
						<col width="35%">
						<col width="35%">
						<col width="10%">			
					</colgroup>
					<thead>
						<tr>
							<th>원재료 파일</th>
							<th>포장지 시안</th>
							<th>날짜</th>					
						</tr>
					</thead>
					<tbody id="list">
						<c:if test="${fn:length(manufacturingNoDataList)==0}">
							<tr>
								<td colspan="5">데이터가 없습니다.</td>
							</tr>
						</c:if>
						<c:if test="${fn:length(manufacturingNoDataList)>0}">
							<c:forEach items="${manufacturingNoDataList}" var="item" varStatus="status">
								<tr>
									<td>
										<c:if test="${item.rawMaterialReport != null && item.rawMaterialReport != ''}">
											<a href="#" onClick="fileDownload('${item.rawMaterialReport}', '${item.seq}', 'manufacturingVersionUpRawMaterial')"><img src="/resources/images/icon_file01.png" style="vertical-align:middle;"/>&nbsp;${item.rawMaterialReportFileName}</a>
										</c:if>
									</td>
									<td>
										<c:if test="${item.packageReport != null && item.packageReport != ''}">
											<a href="#" onClick="fileDownload('${item.packageReport}', '${item.seq}', 'manufacturingVersionUpPackage')"><img src="/resources/images/icon_file01.png" style="vertical-align:middle;"/>&nbsp;${item.packageReportFileName}</a>
										</c:if>
									</td>
									<td>${item.regDate}</td>
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
				<c:if test="${(manufacturingNo.status == 'N' && fn:contains(manufacturingNo.devDocRegUserId, manufacturingNo.loginUserId)) || isUserAdmin == 'Y'}">
					<button type="button" class="btn_admin_red" style="width: 120px;" onclick="versionUpMNo()">변경</button>
				</c:if>
			<% if( (userGrade != null && "3".equals(userGrade)) || (isAdmin != null && "Y".equals(isAdmin)) ) { %>
				<!--  
				<button class="btn_admin_navi" onClick="goUpdateForm('${manufacturingNoData.seq}')">수정</button> 
				<button class="btn_admin_gray"onClick="goDeleteForm('${manufacturingNoData.seq}')">삭제</button>
				-->
			<% } %>	
			</div>
			<hr class="con_mode"/><!-- 신규 추가 꼭 데려갈것 !-->	
		</div>
	</section>	
</div>

<!-- 변경 레이어 start-->
<div class="white_content" id="versionUp">
	<div class="modal" style="	width: 700px;margin-left:-350px;height: 670px;margin-top:-300px;">	
		<h5 style="position:relative">
			<span class="title">품목제조보고서 변경</span>
			<div  class="top_btn_box">
				<ul>
					<li>
						<button class="btn_madal_close" onClick="goCancel('versionUp')"></button>
					</li>
				</ul>
			</div>
		</h5>
		<div class="list_detail">
			<ul id="ul_versionUp">
				<li>
					<dt>변경사항</dt>
					<dd id="dd_versionUp_target_check">
						<input type="checkbox" id="versionUp_for_manufacturingName" onclick="versionUpTargetCheck()" style="display: inline-block;" /><label for="versionUp_for_manufacturingName">제품명</label>
						<input type="checkbox" id="versionUp_for_keepCondition" onclick="versionUpTargetCheck()" style="display: inline-block;" /><label for="versionUp_for_keepCondition">보관조건</label>
						<input type="checkbox" id="versionUp_for_sellDate" onclick="versionUpTargetCheck()" style="display: inline-block;" /><label for="versionUp_for_sellDate">소비기한</label>
						<input type="checkbox" id="versionUp_for_material" onclick="versionUpTargetCheck()" style="display: inline-block;" /><label for="versionUp_for_material">원재료명(원재료)</label>
						<input type="checkbox" id="versionUp_for_etc" onclick="versionUpTargetCheck()" style="display: inline-block;" /><label for="versionUp_for_etc" title="살균여부, 위탁/OEM, 비고 수정 가능" >기타</label>
					</dd>
				</li>
				<li class="pt10">
					<dt>공장 - 품목번호</dt>
					<dd style="display: inline-block;">
					${manufacturingNo.companyName} / ${manufacturingNo.plantName } / ${manufacturingNo.licensingNo} - ${manufacturingNo.manufacturingNo}
					</dd>
				</li>
				<li>
					<dt>품목명</dt>
					<dd>
					
						<li> ${manufacturingNo.manufacturingName }</li>
						<li>
							<div id="div_manufacturingName_versionUp" style="display: none;">
								<input id="input_manufacturingName_versionUp" name="manufacturingName" type="text" value='${manufacturingNo.manufacturingName}' class="req" style="width:250px;float:left;"  placeholder="입력후 확인버튼을 눌러주세요."  />
								<button type="button" class="btn_small01 ml5" onClick="checkName()">확인</button>	
									<input type="hidden" name="manufacturingName_versionUp_temp" id="manufacturingName_versionUp_temp">
								<input type="hidden" name="isValid_versionUp" id="isValid_versionUp" value="N">
								<span id="checkName_versionUp"></span>
							</div>
						</li>
					</dd>
				</li>
				<li>
					<dt>식품유형</dt>
					<dd id="dd_productType_versionUp">
						<select id="productType1_versionUp" name="productType1_versionUp" onChange="loadProductType('2','productType2')" class="selectbox_popup" style="width: 160px;" disabled="disabled">
						</select>
						<span id="li_productType2_versionUp" style="width:130px; display: none">
						<select id="productType2_versionUp" name="productType2_versionUp" onChange="loadProductType('3','productType3')" class="selectbox_popup" style="width: 130px;" disabled="disabled">
						</select>
						</span>	
						<span id="li_productType3_versionUp" style="width:130px; display: none">
						<select id="productType3_versionUp" name="productType3_versionUp" class="selectbox_popup" style="width: 130px;" disabled="disabled">
						</select>
						</span>	
					</dd>
				</li>
				<li>
					<dt>살균여부</dt>
					<dd id="dd_sterilization_versionUp">	
						<select id="sterilization_versionUp" name="sterilization_versionUp" class="selectbox_popup" style="width: 160px;" disabled="disabled"></select>
					</dd>
				</li>
				<li>
					<dt>보관조건</dt>
					<dd id="dd_keepCondition_versionUp">		
						<select id="keepCondition_versionUp" name="keepCondition_versionUp" class="selectbox_popup" style="width: 160px;" onchange="changeKeepCondition()" disabled="disabled"></select>
						<input type="text" name="keepConditionText_versionUp" id="keepConditionText_versionUp" class="req" style="width: 200px; display: none;" >				
					</dd>
				</li>
				<li>
					<dt>소비기한</dt>
					<dd id="dd_sellDate_versionUp">
					</dd>
				</li>
				<li>
					<dt>위탁/OEM</dt>
					<dd id="dd_oem_versionUp">
						<input type="checkbox" id="referral_versionUp" name="referral_versionUp" value="Y" onClick="referralCheck()" disabled="disabled" /><label for="referral_versionUp"><span></span>위탁</label>
						<input type="checkbox" id="oem_versionUp" name="oem_versionUp" value="Y" onClick="oemCheck()" disabled="disabled" /><label for="oem_versionUp"><span></span>OEM</label>
					</dd>
				</li>
				<li id="li_create_plant_versionUp" style="display:none">
					<dt>위탁 공장</dt>
					<dd id="create_plant_list_versionUp"> 
					</dd>
				</li>
				<li id="li_oemText_versionUp" style="display:none">
					<dt>OEM 내용</dt>
					<dd id="dd_oemText_versionUp">
						<textarea style="width:80%; height:40px" name="oemText_versionUp" id="oemText_versionUp"></textarea>
					</dd>
				</li>				
				<li>
					<dt>포장재질</dt>
					<dd>
						<select id="packageUnit_versionUp" name="packageUnit_versionUp" style="width:300px;" class="selectbox_popup" multiple size="3" onChange="showPackageInput()" disabled="disabled"> 
						</select>
						<input type="text" name="packageEtc_versionUp" id="packageEtc_versionUp"  class="req ml5" style="width:300px;display:none" />
					</dd>
				</li>
				<li>
					<dt>비고</dt>
					<dd id="dd_comment_versionUp">
						<textarea style="width:100%; height:40px" name="comment_versionUp" id="comment_versionUp" disabled="disabled"></textarea>				
					</dd>
				</li>
				<li>
					<dt>QNSH 검토대상</dt>
					<dd id="dd_qns_versionUp">
						<input type="radio" name="checkQns" id="checkQnsY" style="display: inline-block;" disabled="disabled" onclick="qnsCheck()" /><label for="checkQnsY"> 대상</label>
						<input type="radio" name="checkQns" id="checkQnsN" style="display: inline-block;" disabled="disabled" onclick="qnsCheck()" /><label for="checkQnsN"> 해당 제품은 QNSH 검토 대상이 아님. ex)수출용, 반제품</label>
					</dd>
				</li>
				<li id="li_qns_versionUp" style="display: none;">
					<dt>QNSH 등록번호</dt>
					<dd>
						<input type="text" id="qns" name="qns" class="req" onkeyup="chkQnsInput(event)" value="${manufacturingNo.qns }" disabled="disabled" placeholder="예) PSSL00LB000000-000" style="width: 165px;" />
					</dd>
				</li>
				<li id="li_fileRawMaterial_versionUp" style="display: none;">
					<dt>원재료 파일</dt>
					<dd>
						<span id="upfile3"></span>
						<input type="file" name="fileRawMaterial" id="file3" style="display: none;" onChange="addFile('file3')" disabled="disabled" /><label for="file3"><span id="file3Label">사용원재료 파일 등록</span> <img src="/resources/images/icon_add_file.png"></label>		
					</dd>
				</li>
				<li id="li_filePacakge_versionUp" style="display: none;">
					<dt>포장지 시안</dt>
					<dd>
						<span id="upfile4"></span>
						<input type="file" name="filePackage" id="file4" style="display: none;" onChange="addFile('file4')" disabled="disabled"/><label for="file4"><span id="file4Label">포장지(표시사항) 파일 등록</span><img src="/resources/images/icon_add_file.png"></label>
					</dd>
				</li>
					
			</ul>
		</div>
		<div class="btn_box_con">
            <button type="button" class="btn_admin_red" id="update" name="update" onclick="manufacturingNoVersionUp()">품목제조보고서 변경</button>
			<input type="button" value="닫기" class="btn_admin_gray" onClick="goCancel('versionUp')" >
		</div>
	</div>
</div>
<!-- 
<div class="white_content" id="open3">
	<div class="modal" style="	width: 700px;margin-left:-350px;height: 250px;margin-top:-250px;">
		<h5 style="position:relative">
			<span class="title">소비기한설정사유서 등록</span>
			<div  class="top_btn_box">
				<ul>
					<li>
						<button class="btn_madal_close" onClick="goCancel('open3')"></button>
					</li>
				</ul>
			</div>
		</h5>
		<div class="list_detail">
			<ul>
				<li>
					<dt>소비기한설정사유서</dt>
					<dd>
						<span id="upfile2"></span>
						<span class="file_load" id="fileSpan2">
							<input type="file" name="file" id="file2" onChange="javaScript:addFile('file2')" style="display:none"><label for="file2">첨부파일 등록 <img src="/resources/images/icon_add_file.png"></label>
						</span>
					</dd>
				</li>				
			</ul>
		</div>
		<div class="btn_box_con">
		<% if( (userGrade != null && "3".equals(userGrade)) || (isAdmin != null && "Y".equals(isAdmin)) ) { %>
			<input type="button" value="등록" class="btn_admin_red" id="addFile" onclick="javascript:insertFile2();"> 
		<% } %>		
			<input type="button" value="취소" class="btn_admin_gray" onclick="goCancel('open3')">
		</div>
	</div>
</div>
 -->

<!-- QNS 수정 레이어 start -->

<div class="white_content" id="dialog_qns">
	<input id="dialog_qns_dNo" type="hidden">

	<div class="modal positionCenter" style="width: 700px;">
		<h5 style="position: relative">
			<span class="title">QNSH 등록번호 입력</span>
			<div class="top_btn_box">
				<ul>
					<li>
						<button class="btn_madal_close" onClick="goCancel('dialog_qns')"></button>
					</li>
				</ul>
			</div>
		</h5>
		<div class="list_detail"> 
			<ul>
				<li>
					<dt style="width: 30%">QNSH 등록번호</dt>
					<dd style="width: 70%"><input id="dialog_qns_no" type="input" class="req"></dd>
				</li>
				<li>
					<dt style="width: 30%">QNSH 검토대상</dt>
					<dd style="width: 70%; padding-top:3px;">
						<input type="radio" id="isQnsReviewTarget1" name="isQnsReviewTarget" value="1" checked/> 
						<label for="isQnsReviewTarget1">대상</label>
						<input type="radio" id="isQnsReviewTarget2" name="isQnsReviewTarget" value="0"/>
						<label for="isQnsReviewTarget2">해당 제품은 QNSH 검토 대상이 아님. ex)수출용, 반제품</label>
					</dd>
				</li>
			</ul>
		</div>
		<div class="btn_box_con">
			<button class="btn_admin_red" onclick="updateQns()">수정</button>
			<button class="btn_admin_gray" onClick="closeQnsDialog('dialog_qns')">취소</button>
		</div>
	</div>
</div>
<!-- QNS 레이어 end -->
<!-- 레이어 close-->