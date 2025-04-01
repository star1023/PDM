<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="kr.co.aspn.util.*" %>
<%@ taglib prefix="userUtil" uri="/WEB-INF/tld/userUtil.tld"%>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ taglib prefix="dateUtil" uri="/WEB-INF/tld/dateUtil.tld"%>
<title>개발완료보고서 상세</title>
<style>
.positionCenter{
	position: absolute;
	transform: translate(-50%, -45%);
}
.ck-editor__editable { max-height: 400px; min-height:400px;}
</style>

<link href="../resources/css/mfg.css" rel="stylesheet" type="text/css">
<script type="text/javascript">
	$(document).ready(function(){
		//history.replaceState({}, null, location.pathname);
	});
	
	function downloadFile(idx){
		location.href = '/test/fileDownload?idx='+idx;
	}
	
	function fn_view(idx) {
		var URL = "../test/selectMaterialDataAjax";
		$.ajax({
			type:"POST",
			url:URL,
			data:{
				"idx" : idx
			},
			dataType:"json",
			async:false,
			success:function(data) {
				$("#nameTxt").html(data.data.NAME);
				$("#sapCodeTxt").html(data.data.SAP_CODE);
				$("#plantTxt").html(data.data.PLANT);
				$("#priceTxt").html(data.data.PRICE);
				$("#unitTxt").html(data.data.UNIT_NAME);
				$("#keepConditionTxt").html(data.data.KEEP_CONDITION);
				$("#sizeTxt").html(nvl(data.data.WIDTH,"0")+" / "+nvl(data.data.LENGTH,"0")+" / "+nvl(data.data.HEIGHT,"0"));
				$("#weightTxt").html(data.data.TOTAL_WEIGHT);
				$("#standardTxt").html(data.data.STANDARD);
				$("#originTxt").html(data.data.ORIGIN);
				$("#expireDateTxt").html(data.data.EXPIRATION_DATE);
				var typeName = "";
				if( chkNull(data.data.MATERIAL_TYPE_NAME1) ) {
					typeName += data.data.MATERIAL_TYPE_NAME1;
				}
				if( chkNull(data.data.MATERIAL_TYPE_NAME2) ) {
					typeName += " > "+data.data.MATERIAL_TYPE_NAME2;
				}
				if( chkNull(data.data.MATERIAL_TYPE_NAME3) ) {
					typeName += " > "+data.data.MATERIAL_TYPE_NAME3;
				}
				$("#typeTxt").html(typeName);
				var fileTypeTxt = "";
				data.fileType.forEach(function (item, index) {
					if( index == 0 ) {
						fileTypeTxt += item.FILE_TEXT
					} else {
						fileTypeTxt += ", "+item.FILE_TEXT
					}
				});
				$("#fileTypeTxt").html(fileTypeTxt);
				$("#fileDataList").html("");
				data.fileList.forEach(function (item) {
					var childTag = '<li>&nbsp;<a href="javascript:downloadFile(\''+item.FILE_IDX+'\')">'+item.ORG_FILE_NAME+'</a></li>'
					$("#fileDataList").append(childTag);
				});
				
				openDialog('open3');
			},
			error:function(request, status, errorThrown){
					alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
			}			
		});
	}
	
	function fn_list() {
		location.href = '/menu/menuList';
	}
	
	function fn_versionUp(idx) {
		location.href = '/menu/versionUpMenuForm?idx='+idx;
	}
	
</script>
<div class="wrap_in" id="fixNextTag">
	<span class="path">
		메뉴 완료보고서 상세&nbsp;&nbsp;
		<img src="/resources/images/icon_path.png" style="vertical-align: middle" />&nbsp;&nbsp;메뉴 완료보고서&nbsp;&nbsp;
		<img src="/resources/images/icon_path.png" style="vertical-align: middle" />&nbsp;&nbsp;<a href="#none">${strUtil:getSystemName()}</a>
	</span>
	<section class="type01">
		<h2 style="position:relative">
			<span class="title_s">Menu Complete Document</span><span class="title">메뉴 완료보고서 상세</span>
			<div class="top_btn_box">
				<ul>
					<li>
						<button class="btn_circle_version" onclick="fn_versionUp('${menuData.data.MENU_IDX}')">&nbsp;</button>
					</li>
				</ul>
			</div>
		</h2>
		<div class="group01 mt20">
			<div class="title2"  style="width: 80%;"><span class="txt">기본정보</span></div>
			<div class="title2" style="width: 20%; display: inline-block;">
				
			</div>
			<div class="main_tbl">
				<table class="insert_proc01">
					<colgroup>
						<col width="15%" />
						<col width="35%" />
						<col width="15%" />
						<col width="35%" />
					</colgroup>
					<tbody>
						<tr>
							<th style="border-left: none;">제목</th>
							<td colspan="5">${menuData.data.TITLE}</td>
						</tr>
						<tr>
							<th style="border-left: none;">제품코드</th>
							<td>
								${menuData.data.MENU_CODE}
							</td>
							<th style="border-left: none;">제품명</th>
							<td>
								${menuData.data.NAME}
							</td>
						</tr>
						<tr>
							<th style="border-left: none;">제품유형</th>
							<td colspan="5">
								<c:if test="${menuData.data.MENU_TYPE1 != null }">
								${menuData.data.MENU_TYPE_NAME1}
								</c:if>
								<c:if test="${menuData.data.MENU_TYPE2 != null }">
								&gt; ${menuData.data.MENU_TYPE_NAME2}
								</c:if>
								<c:if test="${menuData.data.MENU_TYPE3 != null }">
								&gt; ${menuData.data.MENU_TYPE_NAME3}
								</c:if>
							</td>
						</tr>
						<tr>
							<th style="border-left: none;">첨부파일 유형</th>
							<td colspan="5">
								<c:forEach items="${menuData.fileType}" var="fileType" varStatus="status">
									<c:if test="${status.index != 0 }">
									,
									</c:if>
									${fileType.FILE_TEXT}
								</c:forEach>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			
			<div class="title2" style="float: left; margin-top: 30px;">
				<span class="txt">원료</span>
			</div>
			<div class="main_tbl">				
				<table class="tbl01 " style="border-bottom: 2px solid #4b5165;">
					<colgroup>
						<col width="140">
						<col width="250">
						<col width="150">
						<col width="200">
						<col width="8%">
						<col />
					</colgroup>
					<thead>
						<tr>
							<th>원료코드</th>
							<th>원료명</th>
							<th>규격</th>
							<th>보관방법 및 유통기한</th>
							<th>공급가</th>
							<th>비고</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${menuMaterialData}" var="menuMaterialData" varStatus="status">
					<c:if test="${menuMaterialData.MATERIAL_TYPE == 'N' }">
						<tr>
							<td>
								<div class=""><a href="#" onClick="fn_erpview('${menuMaterialData.SAP_CODE}')">${menuMaterialData.SAP_CODE}</a></div>
							</td>
							<td>
								${menuMaterialData.NAME}
							</td>
							<td>
								${menuMaterialData.STANDARD}
							</td>
							<td>
								${menuMaterialData.KEEP_EXP}
							</td>
							<td>
								${menuMaterialData.UNIT_PRICE}
							</td>
							<td>
								${menuMaterialData.DESCRIPTION}
							</td>
						</tr>
					</c:if>	
					</c:forEach>	
					</tbody>
					<tfoot>
					</tfoot>
				</table>
			</div>
			
			<c:if test="${menuData.data.IS_NEW_MATERIAL == 'Y' }">
			<div class="title2" style="float: left; margin-top: 30px;">
				<span class="txt">신규원료</span>
			</div>
			<div class="main_tbl">				
				<table class="tbl01 " style="border-bottom: 2px solid #4b5165;">
					<colgroup>
						<col width="140">
						<col width="250">
						<col width="150">
						<col width="200">
						<col width="8%">
						<col />
					</colgroup>
					<thead>
						<tr>
							<th>원료코드</th>
							<th>원료명</th>
							<th>규격</th>
							<th>보관방법 및 유통기한</th>
							<th>공급가</th>
							<th>비고</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${menuMaterialData}" var="menuMaterialData" varStatus="status">
						<c:if test="${menuMaterialData.MATERIAL_TYPE == 'Y' }">
						<tr>
							<td>
								<div class=""><a href="#" onClick="fn_view('${menuMaterialData.MATERIAL_IDX}')">${menuMaterialData.SAP_CODE}</a></div>
							</td>
							<td>
								${menuMaterialData.NAME}
							</td>
							<td>
								${menuMaterialData.STANDARD}
							</td>
							<td>
								${menuMaterialData.KEEP_EXP}
							</td>
							<td>
								${menuMaterialData.UNIT_PRICE}
							</td>
							<td>
								${menuMaterialData.DESCRIPTION}
							</td>
						</tr>
						</c:if>
					</c:forEach>	
					</tbody>
					<tfoot>
					</tfoot>
				</table>
			</div>
			</c:if>
			
			<div class="title2 mt20"  style="width:90%;"><span class="txt">첨부파일</span></div>
			<div class="con_file" style="">
				<ul>
					<li class="point_img">
						<dt>첨부파일</dt><dd>
							<ul>
								<c:forEach items="${menuData.fileList}" var="fileList" varStatus="status">
									<li>&nbsp;<a href="javascript:downloadFile('${fileList.FILE_IDX}')">${fileList.ORG_FILE_NAME}</a></li>
								</c:forEach>
							</ul>
						</dd>
					</li>
				</ul>
			</div>
			
			<div class="title2 mt20"  style="width:90%;"><span class="txt">기안문</span></div>
			<div>
				<table class="insert_proc01">
					<tr>
						<td>${menuData.data.CONTENTS}</td>
					</tr>
				</table>
			</div>
			
			<div class="main_tbl">
				<div class="btn_box_con5">					
				</div>
				<div class="btn_box_con4">
					<button class="btn_admin_gray" onClick="fn_list();" style="width: 120px;">목록</button>
				</div>
				<hr class="con_mode" />
			</div>
			
		</div>
	</section>
</div>

<!-- 자재조회 레이어 start-->
<div class="white_content" id="open3">
	<div class="modal" style="	width: 700px;margin-left:-350px;height: 780px;margin-top:-400px;">
		<h5 style="position:relative">
			<span class="title">원료 상세 정보</span>
			<div  class="top_btn_box">
				<ul>
					<li>
						<button class="btn_madal_close" onClick="closeDialog('open3')"></button>
					</li>
				</ul>
			</div>
		</h5>
		<div class="list_detail">
			<ul>
				<li class="pt10">
					<dt>원료명</dt>
					<dd>
						 <div id="nameTxt"></div>
					</dd>
				</li>
				<li>
					<dt>SAP 코드</dt>
					<dd>
						<div id="sapCodeTxt"></div>
					</dd>
				</li>
				<li>
					<dt>단가</dt>
					<dd>
						<div id="priceTxt"></div>
					</dd>
				</li>
				<li>
					<dt>단위</dt>
					<dd>
						<div id="unitTxt"></div>
					</dd>
				</li>
				<li>
					<dt>보관기준</dt>
					<dd>
						<div id="keepConditionTxt"></div>
					</dd>
				</li>
				<li>
					<dt>사이즈</dt>
					<dd>
						<div id="sizeTxt"></div>
					</dd>
				</li>
				<li>
					<dt>중량</dt>
					<dd>
						<div id="weightTxt"></div>
					</dd>
				</li>
				<li>
					<dt>규격</dt>
					<dd>
						<div id="standardTxt"></div>
					</dd>
				</li>
				<li>
					<dt>원산지</dt>
					<dd>
						<div id="originTxt"></div>
					</dd>
				</li>
				<li>
					<dt>유통기한</dt>
					<dd>
						<div id="expireDateTxt"></div>
					</dd>
				</li>
				<li>
					<dt>원료구분상세</dt>
					<dd>
						<div id="typeTxt"></div>
					</dd>
				</li>
				<li>
					<dt>첨부파일 유형</dt>
					<dd>
						<div id="fileTypeTxt"></div>
					</dd>
				</li>
				<li>
					<div class="add_file2" style="width:97.5%">
						<span class="" >
							<label>첨부파일</label>
						</span>						
					</div>
					<div class="file_box_pop" style=" height:120px; width:97.5%; border-top-left-radius:0px;border-top-right-radius:0px; border-top:1px solid #ddd;box-sizing:border-box;">
						<ul id="fileDataList">									
						</ul>
					</div>
				</li>
			</ul>
		</div>
		<div class="btn_box_con">
			<button class="btn_admin_gray" onclick="closeDialog('open3')"> 닫기</button>
		</div>
	</div>
</div>
<!-- 자재조회 레이어 close-->