<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="kr.co.aspn.util.*" %>
<%@ taglib prefix="userUtil" uri="/WEB-INF/tld/userUtil.tld"%>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ taglib prefix="dateUtil" uri="/WEB-INF/tld/dateUtil.tld"%>

<!--점포용, OEM 제품명처리-->
<c:if test="${productDevDoc.productDocType == null}">
	<c:set target="${productDevDoc}" property="productDocType" value="0"/>
</c:if>
<c:set var="productDocTypeName" value="" />
<c:set var="productNamePrefix" value="" />
<c:set var="titlePrefix" value="" />
<c:set var="displayNone" value=""/>
<c:choose>
	<c:when test="${productDevDoc.productDocType == '1'}">
		<c:set var="productDocTypeName" value="점포용 " />
		<c:set var="productNamePrefix" value="[${productDevDoc.storeDivText}]" /> <!-- 23.10.11 점포명 공통코드화 -->
		<c:set var="titlePrefix" value="[BF] " />
		<c:set var="displayNone" value="display:none"/>
	</c:when>
	<c:when test="${productDevDoc.productDocType == '2'}">
		<c:set var="productDocTypeName" value="OEM " />
		<c:set var="displayNone" value="display:none"/>
	</c:when>
	<c:otherwise></c:otherwise>
</c:choose>

<title>제품개발문서>제조공정서</title><!--  -->
<style type="text/css">
.readOnly {
	background-color: #ddd
}
.positionCenter{
	position: absolute;
	transform: translate(-50%, -50%);
}

.baseName  input{border-radius:5px; background-color:#ffffff; border:1px solid #c5c5c5; padding:3px 5px 3px 5px; box-sizing:border-box;}
.baseName  input:hover{border:1px solid #cf451b;}
.baseName  input::placeholder {font-family:'맑은고딕',Malgun Gothic; color:#ccc; font-size:13px;}
textarea{font-family: '맑은고딕',Malgun Gothic;font-size: 13px}
</style>
<script type="text/javascript">


	var GridFunctions = new Object();
	GridFunctions.Data = new Object();
	GridFunctions.reloadGrid = function(gridId){
        console.log("Grids.reloadGrid - grid: " +gridId );
		Grids[gridId].ReloadBody();
		//GridFunctions.removeAllRows(gridId);
		// GridFunctions.Data.disp.forEach(function(disp, dispIndex){
		// 	var newRow = Grids[gridId].AddRow(null, null, 1, true);
        //
		// 	Grids[gridId].SetValue(newRow, "ITEMSAPCODE", disp.itemCode, 1);
		// 	Grids[gridId].SetValue(newRow, "MATNAME", disp.matName, 1);
		// 	Grids[gridId].SetValue(newRow, "EXCRATE", disp.excRate, 1);
		// 	Grids[gridId].SetValue(newRow, "INCRATE", disp.incRate, 1);
        //
		// });
	}
	GridFunctions.addGridRow = function(gridId){
        console.log("Grids.addGridRow - grid: " +gridId );
		Grids[gridId].AddRow(null, null, 1, true);
	}
	GridFunctions.removeGridRow = function(gridId){
        console.log("Grids.removeGridRow - grid: " +gridId );
		var rows = Grids[gridId].Rows;
		$.each(rows,function(index,row){
			if(row.Kind == "Data" && row.Deleted){
				Grids[gridId].RemoveRow(row);
			}
		});
	}
	GridFunctions.removeAllRows = function(gridId){

		for(var row = Grids[gridId].GetFirst(); row; row = Grids[gridId].GetNext(row)){
			Grids[gridId].DeleteRowT(row,2);
		}
		GridFunctions.removeGridRow(gridId);
	}
</script>
<link href="/resources/js/jquery.auto-complete.css" rel="stylesheet" type="text/css">
<link href="/resources/css/mfg.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="/resources/js/jquery.auto-complete.js"></script>

<div class="wrap_in" id="fixNextTag">
	<span class="path">
		${productDocTypeName}제조공정서 신규작성&nbsp;&nbsp;
		<img src="/resources/images/icon_path.png" style="vertical-align: middle" />&nbsp;&nbsp;제품개발문서&nbsp;&nbsp;
		<img src="/resources/images/icon_path.png" style="vertical-align: middle" />&nbsp;&nbsp;<a href="javascript:;">SPC 삼립연구소</a>
	</span>
	<section class="type01">
		<!-- 상세 페이지  start-->
		<h2 style="position: relative">
			<span class="title_s">Manufacturing Process Doc</span><span class="title">${productDocTypeName}제조공정서 신규작성</span>
			<div class="top_btn_box">
				<ul>
					<li>
						<button class="btn_circle_save" onclick="saveMfgProcessDoc('0')">&nbsp;</button>
					</li>
				</ul>
			</div>
		</h2>
		<div class="group01 mt20">
			<!-- 기준정보 start --------------------------------------------------------------------------------------------------------------------------------------------------------->
			<div class="title5" style="width: 80%">
				<span class="txt">01. '${productNamePrefix}${productDevDoc.productName}' 기준정보 </span>
			</div>
			<div class="title5" style="width: 20%; display: inline-block;">
<%--				<button style="float: right;" class="btn_con_search" onclick="openImportDialog()"><img src="/resources/images/btn_icon_setting.png"> 불러오기</button>--%>
			</div>
			<div class="main_tbl">
				<table class="insert_proc01">
					<colgroup>
						<col width="13%" />
						<col width="20%" />
						<col width="13%" />
						<col width="20%" />
						<col width="14%" />
						<col width="20%" />
					</colgroup>
					<tbody>
						<tr>
							<th style="border-left: none;">제조방법</th>
							<td colspan="5">
								<textarea name="menuProcess" style="width: 100%; height: 130px" maxlength="1000" placeholder="제조방법을 입력해주세요.">${mfgProcessDoc.menuProcess}</textarea>
							</td>
						</tr>
						<tr>
							<th style="border-left: none;">제품규격</th>
							<td colspan="5">
								<textarea name="standard" style="width: 100%; height: 130px" maxlength="1000" placeholder="제품규격을 입력해주세요.">${mfgProcessDoc.standard}</textarea>
							</td>
						</tr>
						<tr>
							<th style="border-left: none;">보관조건</th>
							<td colspan="5">
								<input type="text" name="keepCondition" maxlength="500" style="width: 100%" value="${mfgProcessDoc.keepCondition}" placeholder="보관조건을 입력해주세요."/>
<%--								<textarea name="keepCondition" style="width: 100%; height: 30px" maxlength="500">${mfgProcessDoc.keepCondition}</textarea>--%>
							</td>
						</tr>
						<tr>
							<th style="border-left: none;">소비기한</th>
							<td colspan="5">
								<input type="text" name="sellDate" maxlength="500" style="width: 100%" value="${mfgProcessDoc.sellDate}" placeholder="소비기한을 입력해주세요"/>
<%--								<textarea name="sellDate" style="width: 100%; height: 30px" maxlength="500">${mfgProcessDoc.sellDate}</textarea>--%>
							</td>
						</tr>
						<tr>
							<th style="border-left: none;">QNS 허들정보</th>
							<td colspan="2">
								<input type="text" id="qns" name="qns" style="width: 100%;" value="${mfgProcessDoc.qns}" placeholder="QNSH 문서(네임택)등록번호를 입력해주세요."/>
							</td>
							<th style="border-left: none;">QNSH 검토대상</th>
							<td colspan="2">
								<input type="radio" id="isQnsReviewTarget1" name="isQnsReviewTarget" value="1" checked/>
								<label for="isQnsReviewTarget1"><span></span>대상</label>
								<input type="radio" id="isQnsReviewTarget2" name="isQnsReviewTarget" value="0"/>
								<label for="isQnsReviewTarget2"><span></span>해당 제품은 QNSH 검토 대상이 아님. ex)수출용, 반제품</label>
							</td>
						</tr>
						<tr>
							<th style="border-left: none;">기타설명</th>
							<td colspan="5">
								<textarea name="memo" style="width: 100%; height: 60px" class="req" maxlength="1000" placeholder="기타 제품설명을 입력해주세요.">${mfgProcessDoc.memo}</textarea>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<!-- 기준정보 close --------------------------------------------------------------------------------------------------------------------------------------------------------->

			<!-- 원료 start --------------------------------------------------------------------------------------------------------------------------------------------------------->
			<div class="title5" style="float: left; margin-top: 30px;">
				<span class="txt">
					02. 원료
					<ul id="autoDispUl" class="list_ul3">
<%--						<li><a href="javascript:changeAutoDisp(0)">직접입력</a></li><li class="select"><a href="javascript:changeAutoDisp(1)">자동계산</a></li>--%>
					</ul>
					<input type="hidden" name="isAutoDisp" value="1"/>
				</span>
			</div>
			<div id="div_GridArea">
			</div>
			<div name="addMixDiv" class="add_nomal_mix" onclick="addMixTable()">
				<span><img src="/resources/images/btn_pop_add2.png"> 배합비 추가</span>
			</div>
			<!-- 원료 end --------------------------------------------------------------------------------------------------------------------------------------------------------->

			<div class="main_tbl">
				<div class="btn_box_con5">
					<button class="btn_admin_gray" onClick="goMfgDetail()" style="width: 120px;">목록</button>
				</div>
				<div class="btn_box_con4">
					<button class="btn_admin_navi" onclick="saveMfgProcessDoc('7')">임시저장</button>
					<button class="btn_admin_sky" onclick="saveMfgProcessDoc('0')">저장</button>
					<button class="btn_admin_gray" onclick="goMfgDetail()">취소</button>
				</div>
				<hr class="con_mode" />
				<!-- 신규 추가 꼭 데려갈것 !-->
			</div>
		</div>
	</section>
</div>


<!-- 레이어드 팝업 -->



<script type="text/javascript">
	var gridDataList = []
	<c:set var="mixItemIndex" value="0"></c:set>
	<c:forEach items="${mfgProcessDoc.sub}" var="sub" varStatus="subStatus">
		<c:forEach items="${sub.mix}" var="mix">
		var mixItemList${mixItemIndex} = [];
			<c:forEach items="${mix.item}" var="item" >
		mixItemList${mixItemIndex}.push({"ITEMNAME":"${item.itemName}", "BOMAMOUT":"${item.bomAmount}", "MANUCOMPANY":"${item.manuCompany}","INGRADIENT":"${item.ingradient}"});
			</c:forEach>
		var gridData${mixItemIndex} = {Body:[mixItemList${mixItemIndex}]};
		console.log(gridData${mixItemIndex});
		gridDataList.push({gridDataName:"gridData${mixItemIndex}",mixBaseName:"${mix.baseName}"});
		<c:set var="mixItemIndex" value="${mixItemIndex + 1}"></c:set>
		</c:forEach>
	</c:forEach>

	$(document).ready(function(){
		$(document).keydown(function(e){
			if(e.target.nodeName != "INPUT" && e.target.nodeName != "TEXTAREA"){
				if(e.keyCode === 8){
					return false;
				}
			}
		});

        $('input[type=radio][name=isQnsReviewTarget]').change(function(e){
            if(e.target.value=='1'){
                document.getElementById('qns').disabled = false;
                document.getElementById('qns').className = 'req';
                document.getElementById('qns').placeholder = ''
            } else {
                document.getElementById('qns').disabled = true;
                document.getElementById('qns').className = '';
                document.getElementById('qns').value = ''
                document.getElementById('qns').placeholder = '해당사항 없음'
            }
        })

		gridDataList.forEach(function (gridData,index){
			addMixTable(gridData.gridDataName,gridData.mixBaseName);
		});

		if(GridList.length == 0){
			addMixTable();
		}
	});
	<!-- 점포용 start -->
	var GridList = new Array();
	function addMixTable(Data_Script,baseName){
		var gridIndex = GridList.length;
		var gridId = "mfgProcessDocSubMix" + gridIndex;
		var divId = "divMfgProcessDocSubMix" + gridIndex;
		var border = gridIndex==0?"border-top:2px solid #4b5165;":"";
		var div = $("<div style='width: 100%' id='mixDiv"+ gridIndex +"'></div>");
		var mainDiv = $("<div class=\"fl-box panel-wrap\" id=\"main" + divId + "\" style='margin-top: 15px' ></div>");
		var divPanelbody = $("<div class='panel-body' style='" + border + "'></div>");
		var gridDiv = $("<div id=\"" + divId + "\" ></div>");	//border-top:2px solid #4b5165;
		var deleteBtn = "<a href='#none' title='배합 삭제' class='treeButton gridDelete' onclick='deleteMixTable(" + gridIndex + ")'>배합 삭제</a>";
		divPanelbody.append(gridDiv);
		mainDiv.append("<div class=\"bullet-tit baseName\">배합비명: <input type='text' id='baseName" + gridIndex + "' value='" + (baseName!=null?baseName:"") + "' style='width: 300px' onfocus='setForcs()'/>&nbsp;&nbsp;&nbsp;" + deleteBtn + "</div>");
		mainDiv.append(divPanelbody);
		div.append(mainDiv);
		$("#div_GridArea").append(div);

		var mfgProcessDocSubMix = TreeGrid({
					Debug:''
					, Layout: { Url:"/dev/mfgProcessDocSubMixLayout?gridId=" + gridId + "&edit=1" }
					, Sync: "1"
					, Data: { Script: Data_Script }
				}
				, divId
				, {id:gridId}
		);

		GridList.push(mfgProcessDocSubMix);

		TGSetEvent("OnSelect", gridId, function(grid,row,deselect){
			console.log("Grids.OnSelect - grid: " + grid.id + ", row: " + row.id);
			if(deselect == 0){
				grid.DeleteRowT(row,2);
			}
			if(deselect == 1){
				grid.DeleteRowT(row,3);
			}
		});
		// OnSelectAll
		TGSetEvent("OnSelectedAll", gridId, function(grid,select,type,test){
			if(type == 2){
				console.log("Grids.OnSelectedAll - grid: " + grid.id + ", select: " + select + ", type: " + type + ", test:" + test);

			}
		});

	}

	function deleteMixTable(gridIndex){
		var mixBaseName = $("#baseName" + gridIndex).val();
		if(window.confirm("배합비명 [" + mixBaseName + "] 테이블을 지우시겠습니까?")){
			if(GridList[gridIndex] != null){
				console.log(GridList[gridIndex]);
				GridList[gridIndex].Dispose();
				GridList.splice(gridIndex,1);
				$("#mixDiv"+gridIndex).remove();
			}
		}
	}

	function saveMfgProcessDoc(state){
		if(state != '7'){
			if(!saveValid()){
				return;
			}
		}

		if(!confirm('제조공정서를 ' + (state == '7' ? '임시저장' : '저장') + '하시겠습니까?')){
			return;
		}

		var url = "saveManufacturingProcessDoc"
		if("${dNo}" != ""){
			url = "updateManufacturingProcessDoc";
		}

		var docNo = '${docNo}';
		var docVersion = '${docVersion}';
		var postData = getPostData(state);
		console.log(postData);
		$.post(url, postData, function(data){
			if(data == 'S') {
				if("${dNo}" != ""){
					alert('문서 수정 완료');
				}else{
					alert('문서 생성 완료');
				}
				location.href = '/dev/productDevDocDetail?docNo='+docNo+'&docVersion='+docVersion;// + "&productDocType=${productDevDoc.productDocType}";
			} else {
				if("${dNo}" != ""){
					alert('문서 수정 실패[1] - 시스템 담당자에게 문의해주세요');
				}else{
					alert('문서 생성 실패[1] - 시스템 담당자에게 문의해주세요');
				}
			}

		}).fail(function(res){
			//console.log('Error: ' + res.responseText)
			alert('문서 생성 실패[2] - 시스템 담당자에게 문의해주세요');
		})
	}

	function saveValid(){
		var qns = $('input[name=qns]').val();
		var isQnsReviewTarget = $('input[name=isQnsReviewTarget]:checked').val();
		if(!qnsValid(qns, isQnsReviewTarget)){
			return false;
		};
		return true;
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
		var regex = null;
		if(typeof opt == "undefined" || opt == "1"){
			// 모든 10진수 (부호 선택, 자릿수구분기호 선택, 소수점 선택)
			regex = /^[+\-]?(([1-9][0-9]{0,2}(,[0-9]{3})*)|[0-9]+){1}(\.[0-9]+)?$/g;
		}else if(opt == "2"){
			// 부호 미사용, 자릿수구분기호 선택, 소수점 선택
			regex = /^(([1-9][0-9]{0,2}(,[0-9]{3})*)|[0-9]+){1}(\.[0-9]+)?$/g;
		}else if(opt == "3"){
			// 부호 미사용, 자릿수구분기호 미사용, 소수점 선택
			regex = /^[0-9]+(\.[0-9]+)?$/g;
		}else{
			// only 숫자만(부호 미사용, 자릿수구분기호 미사용, 소수점 미사용)
			regex = /^[0-9]$/g;
		}
		console.log(regex.test(num));
		if( regex.test(num) ){
			num = num.replace(/,/g, "");
			return isNaN(num) ? false : true;
		} else {
			return false;
		}
	}

	function getPostData(state){
		var postData = {};

		// 기준정보
		postData['dNo'] = '${dNo}';
		postData['docNo'] = '${docNo}';
		postData['docVersion'] = '${docVersion}';
		postData['state'] = state;
		postData['docType'] = 'N'; // N: 일반,  E: 엑셀
		postData['calcType'] = '40';
		postData['companyCode'] = "${companyCode}";
		postData['menuProcess'] = $('textarea[name=menuProcess]').val();
		postData['standard'] = $('textarea[name=standard]').val();
		postData['keepCondition'] = $('input[name=keepCondition]').val();
		postData['sellDate'] = $('input[name=sellDate]').val();
		postData['memo'] = $('textarea[name=memo]').val();
		//if("${dNo}" != ""){
		postData['regUserId'] = '${mfgProcessDoc.regUserId}';
		postData['isQnsReviewTarget'] = $('input[name=isQnsReviewTarget]:checked').val();
		postData['qns'] = postData['isQnsReviewTarget'] == '1' ? $('input[name=qns]').val() : '';
		//}

		postData['sub[0].subProdName'] = "${productNamePrefix}${productDevDoc.productName}";
		console.log(postData);
		GridList.forEach(function(grid, mixIndex){
			var path = 'sub[0].mix[' + mixIndex + '].';

			var itemNdx = 0;
			for(var row = grid.GetFirst(); row; row = grid.GetNext(row)){
				var propPath = path + 'item[' + itemNdx + '].';
				postData[propPath+'itemName'] = row.ITEMNAME;
				postData[propPath+'bomAmount'] = row.BOMAMOUT;
				postData[propPath+'manuCompany'] = row.MANUCOMPANY;
				postData[propPath+'ingradient'] = row.INGRADIENT;
				itemNdx++;
			}

			if(itemNdx > 0){
				postData[path + 'baseType'] = "MI";
				postData[path + 'baseName'] = $("#baseName" + mixIndex).val();
			}
		});

		return postData;
	}

	function setForcs(){
		Grids.Active = null;
		Grids.Focused = null;
	}
	<!-- 점포용 end -->
</script>
