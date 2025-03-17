<%@ page language="java" contentType="application/vnd.ms-excel; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.aspn.util.DateUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page session="false" %>
<%
	String currentDate = DateUtil.getDate();
	response.setContentType("application/vnd.msexcel;charset=UTF-8");
	response.setHeader("Content-Disposition", "attachment; filename=\"EXCEL_"+currentDate+".xls\";");
	response.setHeader("Content-Description", "JSP Generated Data");
	response.setHeader("Pragma", "public");
	response.setHeader("Cache-Control", "max-age=0");
%>
<style>
/*추가*/
.outside{ border:0; font-family:'맑은고딕',Malgun Gothic; font-size:12px;}
.outside td{border:2px solid #666;}
.intable_title{ border:0;}
.intable_title td{border:1px solid #666; text-align:center; height:22px;}
.jungjong{ border:0; text-align:center;}
.jungjong th,.jungjong td{ border:1px solid #666; height:18px;}
.jungjong tbody td{ border-bottom:1px solid #ddd !important; border-top:1px solid #ddd !important;}
.jungjong th, .jungjong tfoot td{ background-color:#ebebeb;}

.material{border:0; text-align:center;}
.material th,.material td{ border:1px solid #666; height:18px;}
.material tr th{ background-color:#ebebeb;}

.material_inbox{ border:1px solid #999; text-align:center;}
.material_inbox th,.material_inbox td{  height:18px;}
.material_inbox tbody td{ border-top:1px solid #ddd !important;}
.material_inbox th{ }
.water_mark{font-family:'맑은고딕',Malgun Gothic; font-size:13px; margin-top:10px; float:left;}
.big_font{ font-size:20px;}
.color01{ background-color:#eaf1dd;}
.color02{background-color:#fde9d9;}
.color03{background-color:#dbe5f1;}
.color04{background-color:#ddd9c3;}
.color05{background-color:#f3f3f3;}

</style>
<script type="text/javascript">
$(document).ready(function() {
	$("#designReqDoc_content > table").attr("width","100%");
	$("#designReqDoc_content > table").attr("style","");
	$("#designReqDoc_content > table").attr("font-size","12px !important");
});

function getTextareaHTML(note) {
    return "</p><p>"+ note.trim().replace(/\n\r?/g,"</p><p>") +"</p>";
}
</script>
<div>
	<table width="100%" class="intable lineall">
		<!--tr>
			<td width="40%" align="center">
				<div class="table-nut" style="width: 300px; background-color: #fff;">
					<table id="nutrientTable" class="nutrientTable"></table>
				</div>
			</td>
			<td width="60%">
				<div class="img-box">
					<img id="sodium" src="/resources/images/disp/sodium${designReqDoc.nutritionLabel.natriumLevel}.png" alt="graph" width="600px"/>
				</div>
				<div class="img-sodium">${designReqDoc.nutritionLabel.contNatrium}mg</div>
				<div class="img-text">나트륨 함량 비교 표시</div>
				<div class="img-category" >
					<span id="natriumTypeText">${designReqDoc.nutritionLabel.natriumTypeText}</span>
				</div>						
			</td>
		</tr-->
	</table>
	<!-- <div style="border:1px solid gray; border-radius:0.5em;">
		<div id="nutritionDiv" style="maring: 0px 20px; width: 35%; display:none;"></div>
		<div class="box" style="width: 75%; padding-left: 15%; display:none;">
			<div class="left-box">
				<div class="table-nut" style="width: 300px; background-color: #fff;">
					<table id="nutrientTable" class="nutrientTable"></table>
				</div>
			</div>
			<div class="right-box">
				<div class="img-box">
					<img id="sodium" src="/resources/images/disp/sodium${designReqDoc.nutritionLabel.natriumLevel}.png" alt="graph" />
			</div>
			<div class="img-sodium">${designReqDoc.nutritionLabel.contNatrium}mg</div>
			<div class="img-text">나트륨 함량 비교 표시</div>
			<div class="img-category" >
				<span id="natriumTypeText">${designReqDoc.nutritionLabel.natriumTypeText}</span>
				</div>
			</div>
		</div>
	</div> -->
</div>	
<div class="mt10">
	<table width="100%" class="intable linetop">
		<tr>
			<td id="designReqDoc_content">
				${designReqDoc.content}
			</td>
		</tr>	
	</table>
</div>