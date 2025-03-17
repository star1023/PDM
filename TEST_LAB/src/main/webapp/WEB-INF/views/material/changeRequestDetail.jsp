<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ taglib prefix="userUtil" uri="/WEB-INF/tld/userUtil.tld"%>
<%@ page session="false"%>

<script src="//cdnjs.cloudflare.com/ajax/libs/babel-standalone/6.26.0/babel.min.js"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/babel-polyfill/7.4.3/polyfill.js"></script>

<title>자재 변경관리</title>

<style type="text/css">
.readOnly {
	background-color: #ddd
}

.positionCenter {
	position: absolute;
	transform: translate(-50%, -50%);
}
</style>
<script type="text/javascript">

	$(document).ready(function() {
		//var header = '${mmHeader}';
		//var itemList = '${mmItemList}'
	});

	function bindEnter(elementId, fn) {
		$('#' + elementId).keyup(function(event) {
			if (event.keyCode == 13) {
				fn();
			}
		});
	}
	
	function preViewMfgDoc( dNo ) {
		var url = "/dev/manufacturingProcessDetailPopup2?dNo="+dNo;
		var mode = "width=1100, height=650, left=100, top=50, scrollbars=yes";
		window.open(url, "", mode );
	}
	
	function changeBomList(){
		$('#lab_loading').show();
		
		var mmNo = '${mmHeader.mmNo}'
		var state = '${mmHeader.state}'
		
		if( !(state == 1 || state == 5 || state == 6) ){
			alert("BOM 반영을 할 수 없는 상태의 문서입니다. \n(BOM반영 대상: 승인, BOM 반영 오류, BOM 반영 미완결)");
			$('#lab_loading').hide();
			return;
		}
		
		var stateText = '';
		var itemText = '';
		
		$.ajax({
			url: '/material/changeBomList',
			type: 'post',
			data: { mmNo: mmNo },
			success: function(data){
				var state = data.state;
				
				switch (state) {
				case '4':
					stateText = 'BOM 반영이 완료되었습니다.';
					break;
				case '5':
					stateText = 'BOM 실패했습니다.';
					for(var i=0; i<data.tables.IT_RETURN.length; i++){
						var material = data.tables.IT_RETURN[i];
						
						if(material.COM != "S")
							itemText += '\n' + material.MATNR + '_' + material.WERKS + '_'+ material.STLAL + ' - ' + material.MESSAGE;						
					}
					break;
				default:
					break;
				}
			},
			error: function(a,b,c){
				alert('BOM 반영 오류');
				//console.log(a,b,c)
				//$('#lab_loading').hide();
			},
			complete: function(){
				$('#lab_loading').hide();
				var alertStr = stateText;
				alertStr = itemText.length > 0 ? stateText + '\n' + itemText : stateText;
				
				alert(alertStr);
				location.reload();
			}
		})
	}

</script>

<input type="hidden" name="pageNo" id="pageNo" value="${paramVO.pageNo}">
<input type="hidden" name="imNo" id="imNo" value="">
<div class="wrap_in" id="fixNextTag">
	<span class="path">자재 변경요청&nbsp;&nbsp; <img src="/resources/images/icon_path.png" style="vertical-align: middle" />자재 변경관리&nbsp;&nbsp; <img src="/resources/images/icon_path.png" style="vertical-align: middle" />&nbsp;&nbsp; <a href="#">${strUtil:getSystemName()}</a>
	</span>
	<section class="type01">
		<!-- 상세 페이지  start-->
		<h2 style="position: relative">
			<span class="title_s">Material Change Control</span> <span class="title">자재 변경관리</span>
			<div class="top_btn_box">
				<ul>
					<li>
						<button type="button" class="btn_circle_bom" onClick="changeBomList()">&nbsp;</button>
					</li>
				</ul>
			</div>
		</h2>
		<div class="group01">
			
			<div class="title"></div>
			<div class="prodoc_title" style="margin-bottom: 10px; border-top: 2px solid #4b5165">
				<div style="width: 100px; height: 100px; display: inline-block; vertical-align: top;" class="product_img">
					<img src="/resources/images/img_change_code.png">
				</div>
				<div style="display: inline-block; height: 80px; width: 900px; padding-top: 10px;">
					<span class="font13">자재코드 변경 : [${mmHeader.preSapCode}]${mmHeader.preName}&nbsp;<img src="/resources/images/icon_arr.png">&nbsp;<strong style="color: #e83346;">[${mmHeader.postSapCode}]${mmHeader.postName} </strong></span>
					<br /> <span class="font18">공장 : ${mmHeader.plantName} </span>
					<br /> <span class="font18">상태 : ${mmHeader.stateText} </span>
					<br /> <!-- <span class="font16">* 검색 옵션을 이용해 아래의 리스트 중 변경 제외 할 항목을 선택해주세요.</span><br /> -->
				</div>
			</div>
			<!-- 
			<div class="fr pt5 pb10">
				<button class="btn_con_search" onclick="openMtchDialog()">
					<img src="/resources/images/btn_icon_refresh.png" style="vertical-align: middle;" /> 제조공정서 동기화
				</button>
			</div>
			 -->
			<!-- 
			<div id="totDiv" class="fl" style="height: 30px; padding: 10px 0 0 15px;">
				<span class="font13">총 0건 / </span><span style="font-size: 15px; color: #e83346"> 0개 변경제외 </span>
			</div>
			<div class="search_box ">
				<ul>
					<li>
						<dt>검색</dt>
						<dd>
							<div class="selectbox" style="width: 100px;">
								<select id="searchField">
									<option value="productCode" selected>제품코드</option>
									<option value="stlal">대체BOM</option>
									<option value="plant">공장</option>
								</select> <label for="searchField">제품코드</label>
							</div>
							<input id="searchValue" type="text" style="width: 180px; margin-left: 5px;" onkeyup="autoSearch(event)" />
						</dd>
					</li>
					<li>
						<dt>보기</dt>
						<dd>
							<input type="radio" name="showType" id="st1" value="1" checked="checked" /><label for="st1" style="vertical-align: sub"><span></span>전체</label> <input type="radio" name="showType" id="st2" value="2" /><label for="st2" style="vertical-align: sub"><span></span>변경대상</label> <input type="radio" name="showType" id="st3" value="3" /><label for="st3" style="vertical-align: sub"><span></span>변경제외</label>
						</dd>
					</li>
				</ul>
			</div>
			 -->
			
			<div class="main_tbl" style="height: 800px; overflow-y: scroll; overflow-x: auto; float: left; width: 100%; background-color: rgb(245, 245, 245)">
				<table class="tbl04">
					<colgroup>
						<col width="8%">
						<col width="7%">
						<col width="10%">
						<col />
						<%-- <col width="8%"> --%>
						<col width="8%">
						<col width="12%">
						<col width="16%">
					</colgroup>
					<thead>
						<tr>
							<th>제품코드</th>
							<th>대체BOM</th>
							<th>공장</th>
							<th>제품명</th>
							<!-- <th>SAP코드</th> -->
							<!-- <th>단가</th> -->
							<th>작성일</th>
							<th>상태</th>
							<th>연관 제조공정서</th>
						<tr>
					</thead>
					<tbody id="list" style="overflow: auto;">
						<c:forEach var="item" items="${mmItemList}">
							<tr id="row_${item.miNo}" class="${item.isExcept=='Y' ? 'm_visible' : ''}">
								<td>${item.productCode}</td>
								<td>${item.posnr}</td>
								<td>${item.plantName}</td>
								<td>${item.productName}</td>
								<td>${item.regDate}</td>
								<c:if test="${item.state == '5'}">
									<td style="color: #e83346; font-weight: bold;">${item.stateText}</td>
								</c:if>
								<c:if test="${item.state != '5'}">
									<td>${item.stateText}</td>
								</c:if>
								<c:if test="${item.mfgState == 9}">
									<td style="text-align: left;">
										<c:forEach var="mfgNo" items="${fn:split(item.dNoList, ',')}">
											<c:if test="${fn:length(item.dNoList) > 0}">
												<img src="/resources/images/icon_doc01.png">
												<a href="javascript:preViewMfgDoc('${mfgNo}')">
													<span style="color: #e83346; font-weight: bold;">${mfgNo}</span>
												</a>
											</c:if>
										</c:forEach>
									</td>
								</c:if>
								<c:if test="${item.mfgState != 9}">
									<td style="text-align: left;">
										<c:forEach var="mfgNo" items="${fn:split(item.dNoList, ',')}">
											<c:if test="${fn:length(item.dNoList) > 0}">
												<img src="/resources/images/icon_doc01.png">
												<a href="javascript:preViewMfgDoc('${mfgNo}')">${mfgNo}</a>
											</c:if>
										</c:forEach>
									</td>
								</c:if>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
			<div class="btn_box_con">
				<button class="btn_admin_red" onclick="changeBomList()">BOM 반영</button>
			</div>
			<hr class="con_mode" />
			<!-- 신규 추가 꼭 데려갈것 !-->
		</div>
	</section>
</div>

<!-- Builder 개발서버 반영 원복 재실행을 위한 주석 추가 -->