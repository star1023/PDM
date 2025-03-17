<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="userUtil" uri="/WEB-INF/tld/userUtil.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="kr.co.aspn.util.*" %> 
<%@ page session="false" %>
<title>결재함</title>
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
<form name="form" id="form" method="post" action="">
<input type="hidden" name="tbKey" id="tbKey" value="${paramVO.tbKey }">
	<input type="hidden" name="tbType" id="tbType" value="${paramVO.tbType }">
	<input type="hidden" name="regUserId" id="regUserId" value="${designReqDoc.regUserId }">
</form>	
<h2 style=" position:fixed;" class="print_hidden">
	<span class="title"><img src="/resources/images/bg_bs_box_fast02.png">&nbsp;&nbsp;디자인의뢰서 미리보기</span>
</h2>
<div  class="top_btn_box" style=" position:fixed;">
	<ul>
		<li><button type="button" class="btn_pop_close" onClick="self.close();"></button></li>
	</ul>
</div>
<!--여기서부터 프린트 -->
<div id='print_page'  style="padding:10px 0 20px 20px;">
	<table width="1046" cellpadding="0" cellspacing="0" class="print_hidden">
		<tr>
			<td height="50"></td>
		</tr>
		<tr>
			<td align="right" height="50" valign="top">
				<button type="button" class="btn_admin_green" onClick="excelDownload();"><img src="/resources/images/icon_excel.png" style="vertical-align:middle"> 엑셀 다운로드</button>
				<button type="button" class="btn_admin_nomal" onClick="printCheck();">프린트</button>
				<button type="button" class="btn_admin_gray" onClick="self.close();">취소</button>
			</td>
		</tr>
	</table>
	<!-- 출력버튼 -->
	<div class="print_box">
		<!-- 상단 머리정보 start-->
		<div class="hold">
			<table width="100%"  class="intable lineall mb5" >
				<colgroup>
					<col width="20%">
					<col width="30%">
					<col width="20%">
					<col width="30%">
				</colgroup>
				<tr>
					<th class="color05">부서명</th>
					<td>${designReqDoc.department}</td>
					<th class="color05">제목</th>
					<td>${designReqDoc.title}</td>
				</tr>
				<tr>
					<th class="color05">담당자</th>
					<td>${designReqDoc.regUserId}</td>
					<th class="color05">의뢰일자</th>
					<td>${designReqDoc.regDate}</td>
				</tr>
			</table>
		</div>
		<div>
			<div class="watermark"><img src="/resources/images/watermark.png"></div>
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
			<div style="border:1px solid gray; border-radius:0.5em;">
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
			</div>
			<!-- 유출금지 정보출력 start-->
			<table width="100%"  class="intable lineside" style="display:none" id="water_mark_table">
				<tr>
					<td id="water_mark_td">!- 유출금지 정보출력 -!</td>
				</tr>
			</table>
			<!-- 유출금지 정보출력 close-->
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
	</div>	
</div>
