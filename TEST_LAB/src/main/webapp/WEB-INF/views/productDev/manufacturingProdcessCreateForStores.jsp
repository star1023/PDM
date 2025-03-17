﻿<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="kr.co.aspn.util.*" %>
<%@ taglib prefix="userUtil" uri="/WEB-INF/tld/userUtil.tld"%>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ taglib prefix="dateUtil" uri="/WEB-INF/tld/dateUtil.tld"%>

<!--점포용, OEM 제품명처리-->
<c:if test="${productDevDoc.productDocType == null}">
	<c:set target="${productDevDoc}" property="productDocType" value="0"/>
</c:if>
<c:if test="${docDNo != null}">
	<c:set var="dNo" value="${docDNo}" />
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

<title>제품개발문서>제조공정서</title>
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


table{font-size: 12px}
.intable_title{ border:0; table-layout:fixed;}
.intable_title td{border:1px solid #666; text-align:center; height:22px;}

.intable{ border:0; table-layout:fixed; }
.intable td{border:1px solid #666; text-align:center; height:22px;word-break: break-all;}
.intable th{ }
.intable tfoot td{ background-color:#f2f2f2; border-bottom:none;}
.intable tfoot th{ background-color:#f2f2f2; border-bottom:none;}
.lineall{ border:2px solid #000}
.big_font{ font-size:20px;}
.hftitle{background-color:#f3f3f3;}
.inputText{
    width: 70%;
    height: 25px;
    border: none;
}

/* 제조순서 번호 css */
.imgbox {
    position: relative;
    text-align:left;
  }
.imgNumbox{position: absolute; width:21.5px; height:18px; border: 0.5px solid #000; top:-21px; left:-0.5px; text-align:center; background-color: #fff;}
</style>
<link href="/resources/js/jquery.auto-complete.css" rel="stylesheet" type="text/css">
<link href="/resources/css/mfg.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="/resources/js/jquery.auto-complete.js"></script>
<script type="text/javascript">	
	// 배합비 그리드
	var gridDataListMix = []
	<c:set var="mixItemIndex" value="0"></c:set>
	<c:forEach items="${mfgProcessDoc.sub}" var="sub" varStatus="subStatus">
		<c:forEach items="${sub.mix}" var="mix">
		var mixItemList${mixItemIndex} = [];
			<c:forEach items="${mix.item}" var="item" >
		mixItemList${mixItemIndex}.push({"ITEMCODE":"${item.itemCode}","ITEMNAME":"${item.itemName}", "WEIGHT":"${item.weight}","INGRADIENT":"${item.ingradient}"});
			</c:forEach>
		var gridDataMix${mixItemIndex} = {Body:[mixItemList${mixItemIndex}]};
		console.log(gridDataMix${mixItemIndex});
		console.log(":::: 배합 그리드 :::::");
		gridDataListMix.push({gridDataName:"gridDataMix${mixItemIndex}",mixBaseName:"${mix.baseName}"});
		<c:set var="mixItemIndex" value="${mixItemIndex + 1}"></c:set>
		</c:forEach>
	</c:forEach>
	
	// 내용물 그리드  		
	var gridDataListCont = []
	<c:set var="contItemIndex" value="0"></c:set>
	<c:forEach items="${mfgProcessDoc.sub}" var="sub" varStatus="subStatus">
		<c:forEach items="${sub.cont}" var="cont">
		var contItemList${contItemIndex} = [];
			<c:forEach items="${cont.item}" var="item" >
		contItemList${contItemIndex}.push({"ITEMCODE":"${item.itemCode}","ITEMNAME":"${item.itemName}", "WEIGHT":"${item.weight}","INGRADIENT":"${item.ingradient}"});
			</c:forEach>
		var gridDataCont${contItemIndex} = {Body:[contItemList${contItemIndex}]};								// 어떠한 경우로 grid 레이아웃 충돌.
	console.log(gridDataCont${contItemIndex});
	console.log(":::: 내용물 그리드 :::::");
	gridDataListCont.push({gridDataName:"gridDataCont${contItemIndex}",contBaseName:"${cont.baseName}"});
	<c:set var="contItemIndex" value="${contItemIndex + 1}"></c:set>
		</c:forEach>
	</c:forEach>


	$(document).ready(function(){
		// 트리그리드 row 선택시 
		// ========================================================
		//	배합과 내용물에도 똑같이 명시되어있는 이유
		// 		- 기존에 구현되어있어 선택 삭제가 가능하지만
		//    	제조방법 트리그리드에선 동작하지않아서 아래와 같이 선언함.
		// ========================================================	
		Grids.OnSelect = function(grid,row,deselect){
			console.log("Grids.OnSelected - grid: " + grid.id + ", row: " + row.id);
				if(deselect == 0){
					grid. DeleteRowT(row,2);
				}
				if(deselect == 1){
					grid. DeleteRowT(row,3);
				}
		}
		
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
		
        
        // 배합비
		gridDataListMix.forEach(function (gridDataMix,index){
			addMixTable(gridDataMix.gridDataName,gridDataMix.mixBaseName);
		});

		if(GridListMix.length == 0){
			addMixTable();
		}
		
		// 내용물
		gridDataListCont.forEach(function (gridDataCont,index){
			addContTable(gridDataCont.gridDataName,gridDataCont.contBaseName);
		});

		if(GridListCont.length == 0){
			addContTable();
		}
		
	});
	
	// 트리그리드 옵션
	var GridFunctions = new Object();
	GridFunctions.Data = new Object();
	GridFunctions.reloadGrid = function(gridId){
        console.log("Grids.reloadGrid - grid: " +gridId );
		Grids[gridId].ReloadBody();
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
	GridFunctions.OnSelectRow = function(gridId){
		console.log("Grids.OnSelected - grid: " + grid.id + ", row: " + row.id);
		if(grid.id == "mfgProcessDocStoreMethodEdit"){
			if(deselect == 0){
				grid. DeleteRowT(row,2);
			}
			if(deselect == 1){
				grid. DeleteRowT(row,3);
			}
		}
	}
	
	// 제조방법 트리그리드에 들어갈 Data
	var mfgProcessDocStoreMethodEdit_Data = {Body:[${StoreMethod_JsonData}]};
	
	// 점포용 배합 
	var GridListMix = new Array();
	function addMixTable(Data_Script,baseName){
		
		var gridIndex = GridListMix.length;
		var gridId = "mfgProcessDocSubMix" + gridIndex;
		var divId = "divMfgProcessDocSubMix" + gridIndex;
		var border = gridIndex==0?"border-top:2px solid #4b5165;":"";
		var div = $("<div style='width: 100%' id='mixDiv"+ gridIndex +"'></div>");
		var mainDiv = $("<div class=\"fl-box panel-wrap\" id=\"main" + divId + "\" style='margin-top: 15px' ></div>");
		var divPanelbody = $("<div class='panel-body' style='" + border + "'></div>");
		var gridDiv = $("<div id=\"" + divId + "\" ></div>");	//border-top:2px solid #4b5165;
		var deleteBtn = "<a href='#none' title='배합 삭제' class='treeButton gridDelete' onclick='deleteMixTable(" + gridIndex + ")'>배합 삭제</a>";
		divPanelbody.append(gridDiv);
		mainDiv.append("<div class=\"bullet-tit baseName\">배합비명: <input type='text' id='mixbaseName" + gridIndex + "' value='" + (baseName!=null?baseName:"") + "' style='width: 300px' onfocus='setForcs()'/>&nbsp;&nbsp;&nbsp;" + deleteBtn + "</div>");
		mainDiv.append(divPanelbody);
		div.append(mainDiv);
		$("#div_GridAreaMix").append(div);

		var mfgProcessDocSubMix = TreeGrid({
					Debug:''
					, Layout: { Url:"/dev/mfgProcessDocSubMixReLayout?gridId=" + gridId + "&edit=1" }
					, Sync: "1"
					, Data: { Script: Data_Script }
				}
				, divId
				, {id:gridId}
		);

		GridListMix.push(mfgProcessDocSubMix);

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
	}// 점포용 배합end
	
	function deleteMixTable(gridIndex){
		var mixBaseName = $("#mixbaseName" + gridIndex).val();
		if(window.confirm("배합비명 [" + mixBaseName + "] 테이블을 지우시겠습니까?")){
			if(GridListMix[gridIndex] != null){
				GridListMix[gridIndex].Dispose();
				GridListMix.splice(gridIndex,1);
				$("#mixDiv"+gridIndex).remove();
			}
		}
	}
	//-----------------------------------------------------------------------------------------배합
	
	// 점포용 내용물
	var GridListCont = new Array();
	function addContTable(Data_Script,baseName){
		
		var gridIndex = GridListCont.length;
		var gridId = "mfgProcessDocSubCont" + gridIndex;
		var divId = "divMfgProcessDocSubCont" + gridIndex;
		var border = gridIndex==0?"border-top:2px solid #4b5165;":"";
		var div = $("<div style='width: 100%' id='contDiv"+ gridIndex +"'></div>");
		var mainDiv = $("<div class=\"fl-box panel-wrap\" id=\"main" + divId + "\" style='margin-top: 15px' ></div>");
		var divPanelbody = $("<div class='panel-body' style='" + border + "'></div>");
		var gridDiv = $("<div id=\"" + divId + "\" ></div>");	//border-top:2px solid #4b5165;
		var deleteBtn = "<a href='#none' title='내용물 삭제' class='treeButton gridDelete' onclick='deleteContTable(" + gridIndex + ")'>내용물 삭제</a>";
		divPanelbody.append(gridDiv);
		mainDiv.append("<div class=\"bullet-tit baseName\">내용물명: <input type='text' id='contbaseName" + gridIndex + "' value='" + (baseName!=null?baseName:"") + "' style='width: 300px' onfocus='setForcs()'/>&nbsp;&nbsp;&nbsp;" + deleteBtn + "</div>");
		mainDiv.append(divPanelbody);
		div.append(mainDiv);
		$("#div_GridAreaCont").append(div);

		var mfgProcessDocSubCont = TreeGrid({
					Debug:''
					, Layout: { Url:"/dev/mfgProcessDocSubMixReLayout?gridId=" + gridId + "&edit=1" }
					, Sync: "1"
					, Data: { Script: Data_Script }
				}
				, divId
				, {id:gridId}
		);

		GridListCont.push(mfgProcessDocSubCont);

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

	function deleteContTable(gridIndex){
		var contBaseName = $("#contbaseName" + gridIndex).val();
		if(window.confirm("내용물명 [" + contBaseName + "] 테이블을 지우시겠습니까?")){
			if(GridListCont[gridIndex] != null){
				GridListCont[gridIndex].Dispose();
				GridListCont.splice(gridIndex,1);
				$("#contDiv"+gridIndex).remove();
			}
		}
	}
	//-----------------------------------------------------------------------------------------내용물
	
	// QNSH
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
	//-----------------------------------------------------------------------------------------QNSH
	
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
	
	//save
	function saveMfgProcessDoc(state){
		if(state != '7'){
			if(!saveValid()){
				return;
			}
		}

		if(!confirm('제조공정서를 ' + (state == '7' ? '임시저장' : '저장') + '하시겠습니까?')){
			return;
		}

		var url = "saveManufacturingProcessDocStores"
		//var url = "saveManufacturingProcessDoc"
		if("${dNo}" != ""){
			url = "updateManufacturingProcessDocStores";
		}
		
		var docNo = '${docNo}';
		var docVersion = '${docVersion}';
 		var postData = getPostData(state); // 원본
		
		var formData = new FormData();
		
		for(key in postData){
			formData.append(key, postData[key]);
		}
		
		//이미지파일 추가
	    addImgToFormData("file10", formData);
	    addImgToFormData("file20", formData);
	    addImgToFormData("file30", formData);
	    addImgToFormData("file40", formData);
	    
	    addImgToFormData("file50", formData);
	    addImgToFormData("file60", formData);
	    addImgToFormData("file70", formData);
	    addImgToFormData("file80", formData);
	    
	    addImgToFormData("file90", formData);
	    addImgToFormData("file100", formData);
	    addImgToFormData("file110", formData);
	    addImgToFormData("file120", formData);

		$.ajax({
			url : url,
			type: 'POST',
			data: formData,
			processData: false,
		    contentType: false,
			success : function(data){
	 			if(data == 'S') {
					if("${dNo}" != ""){
						alert('문서 수정 완료');
					}else{
						alert('문서 생성 완료');
					}
					location.href = '/dev/productDevDocDetail?docNo='+docNo+'&docVersion='+docVersion;
				} else {
					if("${dNo}" != ""){
						alert('문서 수정 실패[1] - 시스템 담당자에게 문의해주세요');
					}else{
						alert('문서 생성 실패[1] - 시스템 담당자에게 문의해주세요');
					}
				}
			},error: function(res) {
		        // console.log('Error: ' + res.responseText);
		        alert('문서 생성 실패[2] - 시스템 담당자에게 문의해주세요');
		    }
		});
		
		//원본
// 		$.post(url, postData, function(data){
// 			if(data == 'S') {
// 				if("${dNo}" != ""){
// 					alert('문서 수정 완료');
// 				}else{
// 					alert('문서 생성 완료');
// 				}
// 				location.href = '/dev/productDevDocDetail?docNo='+docNo+'&docVersion='+docVersion;// + "&productDocType=${productDevDoc.productDocType}";
// 			} else {
// 				if("${dNo}" != ""){
// 					alert('문서 수정 실패[1] - 시스템 담당자에게 문의해주세요');
// 				}else{
// 					alert('문서 생성 실패[1] - 시스템 담당자에게 문의해주세요');
// 				}
// 			}

// 		}).fail(function(res){
// 			//console.log('Error: ' + res.responseText)
// 			alert('문서 생성 실패[2] - 시스템 담당자에게 문의해주세요');
// 		});
	}//--------------------------------------------------------save
	
	
	//이미지 업로드 
	function uploadImage(input, imgId){
		var fileInput 	= input;
		var imgElement 	= document.getElementById(imgId);
		
		if(fileInput.files && fileInput.files[0]){
			var reader = new FileReader();
			
			reader.onload = function(e){
				imgElement.src = e.target.result;
			};
			
			reader.readAsDataURL(fileInput.files[0]);
		}
	}
	//----------------------------------------------------------이미지 업로드
	
	
	//저장데이터 set
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
		
		
		postData['keepCondition'] = $('input[name=keepCondition]').val();				//보관조건
		postData['compWeight'] = $('input[name=compWeight]').val();						//완제중량
		postData['dispWeight'] = $('input[name=dispWeight]').val();						//표기중량
		postData['sellDate'] = $('input[name=sellDate]').val();							//소비기한
		postData['adminWeight'] = $('input[name=adminWeight]').val();					//관리중량
		postData['usage'] = $('input[name=usage]').val();								//용도용법
		
		postData['memo'] = $('textarea[name=memo]').val();
		//if("${dNo}" != ""){
		postData['regUserId'] = '${mfgProcessDoc.regUserId}';
		postData['isQnsReviewTarget'] = $('input[name=isQnsReviewTarget]:checked').val();
		postData['qns'] = postData['isQnsReviewTarget'] == '1' ? $('input[name=qns]').val() : '';
		//}

		postData['sub[0].subProdName'] = "${productNamePrefix}${productDevDoc.productName}";
		console.log(postData);
		
		// 배합
		GridListMix.forEach(function(grid, mixIndex){
			var path = 'sub[0].mix[' + mixIndex + '].';

			var itemNdx = 0;
			for(var row = grid.GetFirst(); row; row = grid.GetNext(row)){
				var propPath = path + 'item[' + itemNdx + '].';
				postData[propPath+'itemCode'] 	= row.ITEMCODE;
				postData[propPath+'itemName'] 	= row.ITEMNAME;
				postData[propPath+'Weight'] 	= row.WEIGHT;
				postData[propPath+'ingradient'] = row.INGRADIENT;
				itemNdx++;
			}

			if(itemNdx > 0){
				postData[path + 'baseType'] = "MI";
				postData[path + 'baseName'] = $("#mixbaseName" + mixIndex).val();
			}
		});
		
		// 내용물
		GridListCont.forEach(function(grid, contIndex){
			var path = 'sub[0].cont[' + contIndex + '].';

			var itemNdx = 0;
			for(var row = grid.GetFirst(); row; row = grid.GetNext(row)){
				var propPath = path + 'item[' + itemNdx + '].';
				postData[propPath+'itemCode'] 	= row.ITEMCODE;
				postData[propPath+'itemName'] 	= row.ITEMNAME;
				postData[propPath+'Weight'] 	= row.WEIGHT;
				postData[propPath+'ingradient'] = row.INGRADIENT;
				itemNdx++;
			}

			if(itemNdx > 0){
				postData[path + 'baseType'] = "CI";
				postData[path + 'baseName'] = $("#contbaseName" + contIndex).val();
			}
		});
		
		// 제조방법
		var methodNdx = 0;
		for(var row = Grids.mfgProcessDocStoreMethodEdit.GetFirst(); row; row = Grids.mfgProcessDocStoreMethodEdit.GetNext(row)){
			var storeMethodPath = 'storeMethod['+methodNdx+'].'
			postData[storeMethodPath+'methodName'] = row.METHODNAME;
			postData[storeMethodPath+'methodExplain'] = row.METHODEXPLAIN;
			methodNdx++;
		}
		
		// 제조순서
		var inputElements = document.querySelectorAll('input[name="imgDescript"]');
		var imgDescripts = [];
		
		var imgDescriptNdx = 0;
		for (var inputElement of inputElements) {
			 var imgDescript = inputElement.value;
			 var gubun = inputElement.dataset.gubun;
			 
			 var imgDesciptPath = 'imageFileStores['+imgDescriptNdx+'].';
			 if(inputElement.value != null && inputElement.value != ""){
				postData[imgDesciptPath+'imgDescript'] = imgDescript;
				postData[imgDesciptPath+'gubun'] = gubun;
				imgDescriptNdx++;
			}
		}

		return postData;
	}
	
	//이미지 파일을 FormData에 추가하는 함수
	function addImgToFormData(fileInputId , formData){
		
		var fileInput = document.getElementById(fileInputId);
	    var files = fileInput.files;
	    var gubun = fileInput.getAttribute("data-gubun"); // data-gubun 값을 가져옵
	    var tbType = "manufacturingProcessDocForStores";

	 	// 이미지가 등록되어 있을 때만 FormData에 추가합니다.
	    if (files.length > 0) {

	        for (var i = 0; i < files.length; i++) {
	            var file = files[i];
	            formData.append("files", file); // 이미지 파일을 FormData에 추가합니다.
	            formData.append('gubun', gubun); // 해당 파일의 gubun 값을 추가합니다.
	        }
	    }
	}
	
	//----------------------------------------------------------저장데이터 set
	function saveValid(){
		var qns = $('input[name=qns]').val();
		var isQnsReviewTarget = $('input[name=isQnsReviewTarget]:checked').val();
		if(!qnsValid(qns, isQnsReviewTarget)){
			return false;
		};
		
		// 제품설명
		var menuProcess = $('textarea[name=menuProcess]').val();
		
		// 공백제거
		var trimMenuProcess = menuProcess.trim();
		// 값 유무확인
		if(trimMenuProcess.length == 0){
			alert('제품설명을 입력해주세요.');
			return false;
		}
		
		return true;
	}
	
	
	function setForcs(){
		Grids.Active = null;
		Grids.Focused = null;
	}
	
	function goMfgDetail(){
		var docNo = '${productDevDoc.docNo}';
		var docVersion = '${productDevDoc.docVersion}';
		
		var form = document.createElement('form');
		$('body').append(form);
		form.action = '/dev/productDevDocDetail';
		form.method = 'post';
		
		appendInput(form, 'docNo', docNo);
		appendInput(form, 'docVersion', docVersion);
		
		$(form).submit();
	}
	
</script>

<div class="wrap_in" id="fixNextTag">
	<input type="hidden" name="docDNo" id="docDNo" value="${docDNo}"/>
	
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
							<th style="border-left: none;">제품설명</th>
							<td colspan="5">
								<textarea name="menuProcess" style="width: 100%; height: 60px" maxlength="1000" placeholder="제품설명을 입력해주세요.">${mfgProcessDoc.menuProcess}</textarea>
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
							<td colspan="1">
								<input type="text" name="keepCondition" maxlength="500" style="width: 100%" value="${mfgProcessDoc.keepCondition}" placeholder="보관조건을 입력해주세요."/>
<%--								<textarea name="keepCondition" style="width: 100%; height: 30px" maxlength="500">${mfgProcessDoc.keepCondition}</textarea>--%>
							</td>
							<th style="border-left: none;">완제중량</th>
							<td colspan="1">
								<input type="text" id="" name="compWeight" style="width: 100%;" value="${mfgProcessDoc.compWeight}" placeholder="완제중량"/>
							</td>
							<th style="border-left: none;">표기중량</th>
							<td colspan="1">
								<input type="text" id="" name="dispWeight" style="width: 100%;" value="${mfgProcessDoc.dispWeight}" placeholder="표기중량"/>
							</td>
						</tr>
						<tr>
							<th style="border-left: none;">소비기한</th>
							<td colspan="1">
								<input type="text" name="sellDate" maxlength="500" style="width: 100%" value="${mfgProcessDoc.sellDate}" placeholder="소비기한을 입력해주세요"/>
<%--								<textarea name="sellDate" style="width: 100%; height: 30px" maxlength="500">${mfgProcessDoc.sellDate}</textarea>--%>
							</td>
							<th style="border-left: none;">관리중량</th>
							<td colspan="1">
								<input type="text" id="" name="adminWeight" style="width: 100%;" value="${mfgProcessDoc.adminWeight}" placeholder="관리중량"/>
							</td>
							<th style="border-left: none;">용도용법</th>
							<td colspan="1">
								<input type="text" id="" name="usage" style="width: 100%;" value="${mfgProcessDoc.usage}" placeholder="용도용법"/>
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
							<th style="border-left: none;">완제품 제조 시</br>주의사항</th>
							<td colspan="5">
								<textarea name="memo" style="width: 100%; height: 130px" class="req" maxlength="1000" placeholder="완제품 제조시 주의사항을 입력해주세요.">${mfgProcessDoc.memo}</textarea>
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
				</span>
			</div>
			<div id="div_GridAreaMix">
			</div>
			<div name="addMixDiv" class="add_nomal_mix" onclick="addMixTable()">
				<span><img src="/resources/images/btn_pop_add2.png"> 배합비 추가</span>
			</div>
			
			<div id="div_GridAreaCont">
			</div>
			<div name="addContDiv" class="add_nomal_mix" onclick="addContTable()">
				<span><img src="/resources/images/btn_pop_add2.png"> 내용물 추가</span>
			</div>
			<!-- 원료 end --------------------------------------------------------------------------------------------------------------------------------------------------------->

			<!-- 제조방법  start ---------------------------------------------------------------------------------------------------------------------------------------------------->
			<div class="title5" style="float: left; margin-top: 30px;">
				<span class="txt">
					03. 제조방법
				</span>
			</div>

			<div class="fl-box panel-wrap" style="border-top:2px solid #4b5165;">
				<bdo Debug=""
					 Layout_Url="/dev/mfgProcessDocStoreMethodLayout?gridId=mfgProcessDocStoreMethodEdit&edit=1" 
					 Data_Script="mfgProcessDocStoreMethodEdit_Data" >
				</bdo>
			</div>
			<!-- 제조방법  End ------------------------------------------------------------------------------------------------------------------------------------------------------>

			<!-- 제조공정(첨부파일) 순서  start ---------------------------------------------------------------------------------------------------------------------------------------------------->
			<div class="title5" style="float: left; margin-top: 30px;">
				<span class="txt">
					04. 제조공정 순서
				</span>
			</div>
			<div class="fl-box panel-wrap" style="border-top:2px solid #4b5165;"></div>
			<br>
			
			<c:set var="img10" value="/resources/images/img_noimg.png"/>
	        <c:set var="img20" value="/resources/images/img_noimg.png"/>
	        <c:set var="img30" value="/resources/images/img_noimg.png"/>
	        <c:set var="img40" value="/resources/images/img_noimg.png"/>
	        <c:set var="img50" value="/resources/images/img_noimg.png"/>
			<c:set var="img60" value="/resources/images/img_noimg.png"/>
			<c:set var="img70" value="/resources/images/img_noimg.png"/>
			<c:set var="img80" value="/resources/images/img_noimg.png"/>
	        <c:set var="img90" value="/resources/images/img_noimg.png"/>
			<c:set var="img100" value="/resources/images/img_noimg.png"/>
			<c:set var="img110" value="/resources/images/img_noimg.png"/>
			<c:set var="img120" value="/resources/images/img_noimg.png"/>
	       
	        <c:forEach var="imageFileForStores" items="${imageFileForStores}" >
	        	<!-- 첨부파일이 등록되어있을 경우 -->
	        	<c:choose>
	        		<c:when test="${imageFileForStores.gubun == '10'}">
                    	<c:set var="img10" value="/devDocImage/${imageFileForStores.webUrl}"/>
                    	<c:set var="imgDescript10" value="${imageFileForStores.imgDescript }"/>
               		</c:when>
               		<c:when test="${imageFileForStores.gubun == '20'}">
                    	<c:set var="img20" value="/devDocImage/${imageFileForStores.webUrl}"/>
                    	<c:set var="imgDescript20" value="${imageFileForStores.imgDescript }"/>
               		</c:when>
               		<c:when test="${imageFileForStores.gubun == '30'}">
                    	<c:set var="img30" value="/devDocImage/${imageFileForStores.webUrl}"/>
                    	<c:set var="imgDescript30" value="${imageFileForStores.imgDescript }"/>
               		</c:when>
               		<c:when test="${imageFileForStores.gubun == '40'}">
                    	<c:set var="img40" value="/devDocImage/${imageFileForStores.webUrl}"/>
                    	<c:set var="imgDescript40" value="${imageFileForStores.imgDescript }"/>
               		</c:when>
               		
               		<c:when test="${imageFileForStores.gubun == '50'}">
                    	<c:set var="img50" value="/devDocImage/${imageFileForStores.webUrl}"/>
                    	<c:set var="imgDescript50" value="${imageFileForStores.imgDescript }"/>
               		</c:when>
               		<c:when test="${imageFileForStores.gubun == '60'}">
                    	<c:set var="img60" value="/devDocImage/${imageFileForStores.webUrl}"/>
                    	<c:set var="imgDescript60" value="${imageFileForStores.imgDescript }"/>
               		</c:when>
               		<c:when test="${imageFileForStores.gubun == '70'}">
                    	<c:set var="img70" value="/devDocImage/${imageFileForStores.webUrl}"/>
                    	<c:set var="imgDescript70" value="${imageFileForStores.imgDescript }"/>
               		</c:when>
               		<c:when test="${imageFileForStores.gubun == '80'}">
                    	<c:set var="img80" value="/devDocImage/${imageFileForStores.webUrl}"/>
                    	<c:set var="imgDescript80" value="${imageFileForStores.imgDescript }"/>
               		</c:when>
               		
               		<c:when test="${imageFileForStores.gubun == '90'}">
                    	<c:set var="img90" value="/devDocImage/${imageFileForStores.webUrl}"/>
                    	<c:set var="imgDescript90" value="${imageFileForStores.imgDescript }"/>
               		</c:when>
               		<c:when test="${imageFileForStores.gubun == '100'}">
                    	<c:set var="img100" value="/devDocImage/${imageFileForStores.webUrl}"/>
                    	<c:set var="imgDescript100" value="${imageFileForStores.imgDescript }"/>
               		</c:when>
               		<c:when test="${imageFileForStores.gubun == '110'}">
                    	<c:set var="img110" value="/devDocImage/${imageFileForStores.webUrl}"/>
                    	<c:set var="imgDescript110" value="${imageFileForStores.imgDescript }"/>
               		</c:when>
               		<c:when test="${imageFileForStores.gubun == '120'}">
                    	<c:set var="img120" value="/devDocImage/${imageFileForStores.webUrl}"/>
                    	<c:set var="imgDescript120" value="${imageFileForStores.imgDescript }"/>
               		</c:when>
	        	</c:choose>
	        </c:forEach>
			
			<div>
				 <table style="width: 100%"  id="table1" class="intable lineall mb5" >
				 	<colgroup>
			            <col width="10%">
			            <col width="22.5%">
			            <col width="22.5%">
			            <col width="22.5%">
			            <col width="22.5%">
			        </colgroup>
			        <tr>
			        	<td rowspan="2" class="hftitle">사진</td>
			        </tr>
			        <tr>
			        	<td style="height: 120px">
			                <input id="file10" class="form-control form_point_color01" data-gubun="10" type="file" style="width:92%;float:left; cursor: pointer; color: black;" accept="image/*" onchange="uploadImage(this, 'img10');;"/>
			                <img id="img10" src="${img10}" style="width:100%; height:160px; max-height:200px;" alt=""/>
			                <div class="imgbox">
								<div class="imgNumbox">	
									1
								</div>
							</div>
			            </td>
			            <td style="height: 120px">
			                <input id="file20" class="form-control form_point_color01" data-gubun="20" type="file" style="width:92%;float:left; cursor: pointer; color: black;" accept="image/*" onchange="uploadImage(this, 'img20');;"/>
			                <img id="img20" src="${img20}" style="width:100%; height:160px; max-height:200px;" alt=""/>
			                <div class="imgbox">
								<div class="imgNumbox">	
									2
								</div>
							</div>
			            </td>
			            <td style="height: 120px">
			                <input id="file30" class="form-control form_point_color01" data-gubun="30" type="file" style="width:92%;float:left; cursor: pointer; color: black;" accept="image/*" onchange="uploadImage(this, 'img30');;"/>
			                <img id="img30" src="${img30}" style="width:100%; height:160px; max-height:200px;" alt=""/>
			                <div class="imgbox">
								<div class="imgNumbox">	
									3
								</div>
							</div>
			            </td>
			            <td style="height: 120px">
			                <input id="file40" class="form-control form_point_color01" data-gubun="40" type="file" style="width:92%;float:left; cursor: pointer; color: black;" accept="image/*" onchange="uploadImage(this, 'img40');;"/>
			                <img id="img40" src="${img40}" style="width:100%; height:160px; max-height:200px;" alt=""/>
			                <div class="imgbox">
								<div class="imgNumbox">	
									4
								</div>
							</div>
			            </td>
			        </tr> 
			        <tr>
			        	<td class="hftitle"> 설명 </td>
			        	<td>
			        		<input style="border: none; width:98%; height: 30px;" type="text" id="imgDescript10" data-gubun="10" name="imgDescript" value="${imgDescript10 }" placeholder="사진을 등록 후 작성"/>
			        	</td>
			        	<td>
			        		<input style="border: none; width:98%; height: 30px;" type="text" id="imgDescript20" data-gubun="20" name="imgDescript" value="${imgDescript20 }" placeholder="사진을 등록 후 작성"/>
			        	</td>
			        	<td>
			        		<input style="border: none; width:98%; height: 30px;" type="text" id="imgDescript30" data-gubun="30" name="imgDescript" value="${imgDescript30 }" placeholder="사진을 등록 후 작성"/>
			        	</td>
			        	<td>
			        		<input style="border: none; width:98%; height: 30px;" type="text" id="imgDescript40" data-gubun="40" name="imgDescript" value="${imgDescript40 }" placeholder="사진을 등록 후 작성"/>
			        	</td>
			        </tr>
			      </table> <!-- 첨부파일 고정 -->
			</div>
			
			<div>
				 <table style="width: 100%"  id="table1" class="intable lineall mb5" >
				 	<colgroup>
			            <col width="10%">
			            <col width="22.5%">
			            <col width="22.5%">
			            <col width="22.5%">
			            <col width="22.5%">
			        </colgroup>
			        <tr>
			        	<td rowspan="2" class="hftitle">사진</td>
			        </tr>
			        <tr>
			        	<td style="height: 120px">
			                <input id="file50" class="form-control form_point_color01" data-gubun="50" type="file" style="width:92%;float:left; cursor: pointer; color: black;" accept="image/*" onchange="uploadImage(this, 'img50');;"/>
			                <img id="img50" src="${img50}" style="width:100%; height:160px; max-height:200px;" alt=""/>
			                <div class="imgbox">
								<div class="imgNumbox">	
									5
								</div>
							</div>
			            </td>
			            <td style="height: 120px">
			                <input id="file60" class="form-control form_point_color01" data-gubun="60" type="file" style="width:92%;float:left; cursor: pointer; color: black;" accept="image/*" onchange="uploadImage(this, 'img60');;"/>
			                <img id="img60" src="${img60}" style="width:100%; height:160px; max-height:200px;" alt=""/>
			                <div class="imgbox">
								<div class="imgNumbox">	
									6
								</div>
							</div>
			            </td>
			            <td style="height: 120px">
			                <input id="file70" class="form-control form_point_color01" data-gubun="70" type="file" style="width:92%;float:left; cursor: pointer; color: black;" accept="image/*" onchange="uploadImage(this, 'img70');;"/>
			                <img id="img70" src="${img70}" style="width:100%; height:160px; max-height:200px;" alt=""/>
			                <div class="imgbox">
								<div class="imgNumbox">	
									7
								</div>
							</div>
			            </td>
			            <td style="height: 120px">
			                <input id="file80" class="form-control form_point_color01" data-gubun="80" type="file" style="width:92%;float:left; cursor: pointer; color: black;" accept="image/*" onchange="uploadImage(this, 'img80');;"/>
			                <img id="img80" src="${img80}" style="width:100%; height:160px; max-height:200px;" alt=""/>
			                <div class="imgbox">
								<div class="imgNumbox">	
									8
								</div>
							</div>
			            </td>
			        </tr>
			        
			        <tr>
			        	<td class="hftitle"> 설명 </td>
			        	<td>
			        		<input style="border: none; width:98%; height: 30px;" type="text" id="imgDescript50" data-gubun="50" name="imgDescript" value="${imgDescript50 }" placeholder="사진을 등록 후 작성"/>
			        	</td>
			        	<td>
			        		<input style="border: none; width:98%; height: 30px;" type="text" id="imgDescript60" data-gubun="60" name="imgDescript" value="${imgDescript60 }" placeholder="사진을 등록 후 작성"/>
			        	</td>
			        	<td>
			        		<input style="border: none; width:98%; height: 30px;" type="text" id="imgDescript70" data-gubun="70" name="imgDescript" value="${imgDescript70 }" placeholder="사진을 등록 후 작성"/>
			        	</td>
			        	<td>
			        		<input style="border: none; width:98%; height: 30px;" type="text" id="imgDescript80" data-gubun="80" name="imgDescript" value="${imgDescript80 }" placeholder="사진을 등록 후 작성"/>
			        	</td>
			        </tr>
			      </table> <!-- 첨부파일 고정 -->
			</div>
			
			<div>
				 <table style="width: 100%"  id="table1" class="intable lineall mb5" >
				 	<colgroup>
			            <col width="10%">
			            <col width="22.5%">
			            <col width="22.5%">
			            <col width="22.5%">
			            <col width="22.5%">
			        </colgroup>
			        <tr>
			        	<td rowspan="2" class="hftitle">사진</td>
			        </tr>
			        <tr>
			        	<td style="height: 120px">
			                <input id="file90" class="form-control form_point_color01" data-gubun="90" type="file" style="width:92%;float:left; cursor: pointer; color: black;" accept="image/*" onchange="uploadImage(this, 'img90');;"/>
			                <img id="img90" src="${img90}" style="width:100%; height:160px; max-height:200px;" alt=""/>
			                <div class="imgbox">
								<div class="imgNumbox">	
									9
								</div>
							</div>
			            </td>
			            <td style="height: 120px">
			                <input id="file100" class="form-control form_point_color01" data-gubun="100" type="file" style="width:92%;float:left; cursor: pointer; color: black;" accept="image/*" onchange="uploadImage(this, 'img100');;"/>
			                <img id="img100" src="${img100}" style="width:100%; height:160px; max-height:200px;" alt=""/>
			                <div class="imgbox">
								<div class="imgNumbox">	
									10
								</div>
							</div>
			            </td>
			            <td style="height: 120px">
			                <input id="file110" class="form-control form_point_color01" data-gubun="110" type="file" style="width:92%;float:left; cursor: pointer; color: black;" accept="image/*" onchange="uploadImage(this, 'img110');;"/>
			                <img id="img110" src="${img110}" style="width:100%; height:160px; max-height:200px;" alt=""/>
			                <div class="imgbox">
								<div class="imgNumbox">	
									11
								</div>
							</div>
			            </td>
			            <td style="height: 120px">
			                <input id="file120" class="form-control form_point_color01" data-gubun="120" type="file" style="width:92%;float:left; cursor: pointer; color: black;" accept="image/*" onchange="uploadImage(this, 'img120');;"/>
			                <img id="img120" src="${img120}" style="width:100%; height:160px; max-height:200px;" alt=""/>
			                <div class="imgbox">
								<div class="imgNumbox">	
									12
								</div>
							</div>
			            </td>
			        </tr>
			        
			        <tr>
			        	<td class="hftitle"> 설명 </td>
			        	<td>
			        		<input style="border: none; width:98%; height: 30px;" type="text" id="imgDescript90" data-gubun="90" name="imgDescript" value="${imgDescript90 }" placeholder="사진을 등록 후 작성"/>
			        	</td>
			        	<td>
			        		<input style="border: none; width:98%; height: 30px;" type="text" id="imgDescript100" data-gubun="100" name="imgDescript" value="${imgDescript100 }" placeholder="사진을 등록 후 작성"/>
			        	</td>
			        	<td>
			        		<input style="border: none; width:98%; height: 30px;" type="text" id="imgDescript110" data-gubun="110" name="imgDescript" value="${imgDescript110 }" placeholder="사진을 등록 후 작성"/>
			        	</td>
			        	<td>
			        		<input style="border: none; width:98%; height: 30px;" type="text" id="imgDescript120" data-gubun="120" name="imgDescript" value="${imgDescript120 }" placeholder="사진을 등록 후 작성"/>
			        	</td>
			        </tr>
			      </table> <!-- 첨부파일 고정 -->
			</div>
			
			<!-- 제조공정 순서  End ------------------------------------------------------------------------------------------------------------------------------------------------------>

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
	

</script>
