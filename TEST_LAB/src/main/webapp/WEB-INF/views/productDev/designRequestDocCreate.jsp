<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page import="kr.co.aspn.util.*" %>
<%@ taglib prefix="userUtil" uri="/WEB-INF/tld/userUtil.tld"%>

<%-- <%  
response.setHeader("Cache-Control","no-store");  
response.setHeader("Pragma","no-cache");  
response.setDateHeader("Expires",0);  
if (request.getProtocol().equals("HTTP/1.1"))
	response.setHeader("Cache-Control", "no-cache");
%> --%>

<title>제품개발문서>디자인의뢰서</title>
<script type="text/javascript">
	/* 
	history.pushState(null, null, location.href);
	window.onpopstate = function () {
		alert(window.location.href);
		location.href = '/dev/productDevDocDetail' + '?docNo=${docNo}&docVersion=${docVersion}'
	};
	 */
	
	$(document).ready(function(){
		var userName = '<%=UserUtil.getUserName(request)%>';
		var deptName =  '<%=UserUtil.getDeptCodeName(request)%>';
		
		$('#director').val(userName);
		$('#department').val(deptName)
		$('#content').cleditor({ width: '100%' });
		
		applyDatePicker('reqDate');
		$('#reqDate').val(getCurrentDate())
		
		$('input[name=nutritionLabel\\.nutritionType]').change(function(e){
			changeNutritionType(e)
		});
		
		$('input[name=nutritionLabel\\.unit]').change(function(e){
			changeUnit(e)
		});
		
		$('input[name$=nutritionType]:first').change()
	});
	
	function changeNaType(e){
		var naTypeText = e.target.options[event.target.selectedIndex].text
		var naTypeValue = e.target.options[event.target.selectedIndex].value
		if(naTypeValue.length > 0){
			$('#natriumTypeText').text(naTypeText);
		} else {
			$('#natriumTypeText').text('');
		}
	}
	
	function changeNutritionType(e){
		$('#lab_loading').show();
		var type = e.target.value;
		var unit = $('input[name=nutritionLabel\\.unit]:checked').val();
		
		if(type == 0){
			$('#nutritionLi').hide();
			$('#nutritionUnitLi').hide();
			$('#natriumTypeLi').hide();
			$('table.nutrientTable:first').empty();
		} else {
			$('#nutritionUnitLi').show();
			$('#natriumTypeLi').show();
		}
		
		if(type != 0){
			$.ajax({
				url: '/dev/getNutritionTable',
				tyle: 'get',
				data: {type: type, unit: unit},
				success: function(data){
					$('table.nutrientTable:first').empty();
					$('#nutrientTable').append(data);
				},
				error: function(a,b,c){
					//console.log(a,b,c)
					alert('영양성분타입 변경 실패[2]');
				},
				complete: function(){
					$('#nutritionLi').show();
					$('#lab_loading').hide();
				}
			})
		} else {
			$('#lab_loading').hide();
		}
	}
	
	function changeUnit(e){
		$('#unitSpan').text(e.target.value);
	}
	
	function saveValidation(){
		if($('#department').val().length <= 0){
			alert('부서명을 입력하세요');
			$('#department').focus();
			return false;
		}
		
		if($('#reqDate').val().length <= 0){
			alert('의뢰일자를 입력하세요');
			$('#reqDate').focus();
			return false;
		}
		
		if($('#title').val().length <= 0){
			alert('제목을 입력하세요');
			$('#title').focus();
			return false;
		}
		
		/* if($('input[name=nutritionLabel\\.nutritionType]:checked').val() != 0){
			if($('#natriumType').val().length <= 0){
				alert('대상 식품유형을 선택해주세요');
				$('#natriumType').focus();
				return false;
			}
		} */
		
		if($('#content').val().length <= 0){
			alert('내용을 입력해주세요');
			$('#content').focus();
			return false;
		}
		
		return true;
	}
	
	function saveDesignRequestDoc(){
		$('#lab_loading').show();
		
		if(!saveValidation()){
			$('#lab_loading').hide();
			return;
		}
		
		$.ajax({
			url: '/dev/saveDesignRequestDoc',
			type: 'post',
			data : getPostData(),
			success: function(data){
				if(data == 'S'){
					alert('저장되었습니다.');
					location.href = '/dev/productDevDocDetail?docNo='+'${docNo}'+'&docVersion='+'${docVersion}';
					$('#lab_loading').hide();
				} else {
					$('#lab_loading').hide();
					alert('디자인의뢰서 등록 오류[1]')
				}
			},
			error: function(a,b,c){
				//console.log(a,b,c)
				$('#lab_loading').hide();
				alert('디자인의뢰서 등록 오류[2]')
			}
		})
	}
	
	function changeSodium(target){
		var sodium =uncomma(target.value);
		$('.img-sodium').text(comma(target.value)+'mg')
		
		if(sodium <= 800){
			chamgeImage(1)
		} else if(800 < sodium && sodium <= 1000){
			chamgeImage(2)
		} else if(1000 < sodium && sodium <= 1200){
			chamgeImage(3)
		} else if(1200 < sodium && sodium <= 1400){
			chamgeImage(4)
		} else if(1400 < sodium && sodium <= 1600){
			chamgeImage(5)
		} else if(1600 < sodium && sodium <= 1800){
			chamgeImage(6)
		} else if(1800 < sodium && sodium <= 2000){
			chamgeImage(7)
		} else if(2000 < sodium){
			chamgeImage(8)
		} else {
			return alert('wrong sodium');
		}
	}
	
	function chamgeImage(num){
		var srcPath = '/resources/images/disp/';
		var imageName = 'sodium'+num+'.png'
		
		$('#sodium').attr('src', srcPath+imageName);
	}
	
	function clearNoNum(obj){
		var needToSet = false;
		var numStr = obj.value;
		var temps = numStr.split("."); //소수점 체크를 위해 입력값을 '.'을 기준으로 나누고 temps는 배열이됨
		var CaretPos = doGetCaretPosition(obj); //input field에서의 캐럿의 위치를 확인
		if(2 < temps.length){ //배열 사이즈가 2보다 크면, '.' 가 두개 이상인 경우임.
			var tempIdx = 0;
			numStr = "";
			for(i=0;i<temps.length;i++) {
				numStr += temps[i];   //최종 문자에 현재 스트링을 합한다.
			}
			needToSet = true;
			alert("소수점은 두개이상 입력 하시면 안됩니다.");
		} 
		if((/[^\d.]/g).test(numStr)) {  //숫자 '.'  이외 엔 없는지 확인 후 있으면 replace
			numStr = numStr.replace(/[^\d.]/g,"");
			CaretPos--;
			alert("입력은 숫자와 소수점 만 가능 합니다.");('.')
			needToSet = true;
		} 
		if ((/^\./g).test(numStr)){ //첫번째가 '.' 이면 .를 삭제
			numStr = numStr.replace(/^\./g, "");
			alert("소수점이 첫 글자이면 안됩니다.");
			needToSet = true;
		}
		if(needToSet) { //변경이 필요할 경우에만 셋팅함.
			obj.value = numStr;
			setCaretPosition(obj, CaretPos)
		}
	}
	
	function goMfgDetail(){
		var docNo = '${docNo}';
		var docVersion = '${docVersion}';
		
		var form = document.createElement('form');
		$('body').append(form);
		form.action = '/dev/productDevDocDetail';
		form.method = 'post';
		
		appendInput(form, 'docNo', docNo);
		appendInput(form, 'docVersion', docVersion);
		
		$(form).submit();
	}
	
	//문자 제거
	function removeChar(event) {
	    event = event || window.event;
	    var keyID = (event.which) ? event.which : event.keyCode;
	    if (keyID == 46 || keyID == 37 || keyID == 39)
	        return;
	    else
	        //숫자와 소수점만 입력가능
	        event.target.value = event.target.value.replace(/[^-\.0-9]/g, "");
	}
	//콤마 찍기
    function comma(obj) {
        var regx = new RegExp(/(-?\d+)(\d{3})/);
        var bExists = obj.indexOf(".", 0);//0번째부터 .을 찾는다.
        var strArr = obj.split('.');
        while (regx.test(strArr[0])) {//문자열에 정규식 특수문자가 포함되어 있는지 체크
            //정수 부분에만 콤마 달기 
            strArr[0] = strArr[0].replace(regx, "$1,$2");//콤마추가하기
        }
        if (bExists > -1) {
            //. 소수점 문자열이 발견되지 않을 경우 -1 반환
            obj = strArr[0] + "." + strArr[1];
        } else { //정수만 있을경우 //소수점 문자열 존재하면 양수 반환 
            obj = strArr[0];
        }
        return obj;//문자열 반환
    }
	//콤마 풀기
	function uncomma(str) {
		// null 처리
		str = str == null ? "" : str;
	    str = "" + str.replace(/,/gi, ''); // 콤마 제거 
	    str = str.replace(/(^\s*)|(\s*$)/g, ""); // trim()공백,문자열 제거 
	    return (new Number(str));//문자열을 숫자로 반환
	}
	//input box 콤마달기
	function inputNumberFormat(obj, type) {
	    obj.value = comma(obj.value);
	    changeNutrition(obj, type);
	}
	function inputNumberFormat2(obj, type) {
	    obj.value = comma(obj.value);
	    changeNutrition2(obj, type);
	}
	//input box 콤마풀기 호출
	function uncomma_call(){
	    var input_value = document.getElementById('input1');
	    input_value.value = uncomma(input_value.value);
	}
	
	function getPostData(){
		var resultData = {};
		
		resultData['content'] = $('#content').val()
		resultData['department'] = $('#department').val()
		resultData['director'] = $('#director').val()
		resultData['docNo'] = '${docNo}'
		resultData['docVersion'] = '${docVersion}'
		resultData['regUserId'] = '${SESS_AUTH.userId}'
		resultData['reqDate'] = $('#reqDate').val()
		resultData['state'] = '0';
		resultData['title'] = $('#title').val()
		
		resultData['nutritionLabel.weight'] = $('input[name=nutritionLabel\\.weight]').val()
		resultData['nutritionLabel.kcal'] = $('input[name=nutritionLabel\\.kcal]').val()
		resultData['nutritionLabel.unit'] = $('input[name=nutritionLabel\\.unit]:checked').val()
		resultData['nutritionLabel.nutritionType'] =$('input[name=nutritionLabel\\.nutritionType]:checked').val()
		resultData['nutritionLabel.natriumType'] = $('#natriumType').val()
		
		resultData['nutritionLabel.contNatrium'] = uncomma($('input[name=nutritionLabel\\.contNatrium]').val())
		resultData['nutritionLabel.contCarbohydrate'] = uncomma($('input[name=nutritionLabel\\.contCarbohydrate]').val())
		resultData['nutritionLabel.contSugars'] = uncomma($('input[name=nutritionLabel\\.contSugars]').val())
		resultData['nutritionLabel.contFat'] = uncomma($('input[name=nutritionLabel\\.contFat]').val())
		resultData['nutritionLabel.contTransFat'] = uncomma($('input[name=nutritionLabel\\.contTransFat]').val())
		resultData['nutritionLabel.contSaturatedFat'] = uncomma($('input[name=nutritionLabel\\.contSaturatedFat]').val())
		resultData['nutritionLabel.contCholesterol'] = uncomma($('input[name=nutritionLabel\\.contCholesterol]').val())
		resultData['nutritionLabel.contProtein'] = uncomma($('input[name=nutritionLabel\\.contProtein]').val())
		
		if('3'.indexOf($('input[name=nutritionLabel\\.nutritionType]:checked').val()) >= 0){
			resultData['nutritionLabel.weightText'] = $('input[name=nutritionLabel\\.weightText]').val()
			resultData['nutritionLabel.kcalText'] = $('input[name=nutritionLabel\\.kcalText]').val()
			resultData['nutritionLabel.pieceText'] = $('input[name=nutritionLabel\\.pieceText]').val()
		}
		
		if('4'.indexOf($('input[name=nutritionLabel\\.nutritionType]:checked').val()) >= 0){
			resultData['nutritionLabel.weightText'] = $('input[name=nutritionLabel\\.weightText]').val()
			resultData['nutritionLabel.kcalText'] = $('input[name=nutritionLabel\\.kcalText]').val()
			resultData['nutritionLabel.pieceText'] = $('input[name=nutritionLabel\\.pieceText]').val()
		}
		
		if('5'.indexOf($('input[name=nutritionLabel\\.nutritionType]:checked').val()) >= 0){
			resultData['nutritionLabel.kcalText'] = $('input[name=nutritionLabel\\.kcalText]').val()
			resultData['nutritionLabel.pieceText'] = $('input[name=nutritionLabel\\.pieceText]').val()
		}
		
		var extraNutType = ['4', '5'];
		if(extraNutType.indexOf($('input[name=nutritionLabel\\.nutritionType]:checked').val()) >= 0){
			resultData['nutritionLabel.unitNatrium'] = uncomma($('input[name=nutritionLabel\\.unitNatrium]').val())
			resultData['nutritionLabel.unitCarbohydrate'] = uncomma($('input[name=nutritionLabel\\.unitCarbohydrate]').val())
			resultData['nutritionLabel.unitSugars'] = uncomma($('input[name=nutritionLabel\\.unitSugars]').val())
			resultData['nutritionLabel.unitFat'] = uncomma($('input[name=nutritionLabel\\.unitFat]').val())
			resultData['nutritionLabel.unitTransFat'] = uncomma($('input[name=nutritionLabel\\.unitTransFat]').val())
			resultData['nutritionLabel.unitSaturatedFat'] = uncomma($('input[name=nutritionLabel\\.unitSaturatedFat]').val())
			resultData['nutritionLabel.unitCholesterol'] = uncomma($('input[name=nutritionLabel\\.unitCholesterol]').val())
			resultData['nutritionLabel.unitProtein'] = uncomma($('input[name=nutritionLabel\\.unitProtein]').val())
		}
		return resultData;
	}
</script>

<link rel="stylesheet" href="/resources/CLEditor/jquery.cleditor.css?param=1" />
<script type="text/javascript" src="/resources/CLEditor/jquery.cleditor.min.js?param=1"></script>

<div class="wrap_in" id="fixNextTag">
	<span class="path">제품개발문서&nbsp;&nbsp;<img src="/resources/images/icon_path.png" style="vertical-align: middle" />&nbsp;&nbsp;<a href="#none">SPC 삼립연구소</a></span>
	<section class="type01">
		<!-- 상세 페이지  start-->
		<h2 style="position: relative">
			<span class="title_s">Design Request Doc</span> <span class="title">디자인의뢰서 생성</span>
			<div class="top_btn_box">
				<ul>
					<li><button class="btn_circle_nomal" onClick="goMfgDetail()">&nbsp;</button></li>
				</ul>
			</div>
		</h2>
		<div class="group01">
			<div class="title">
				<!--span class="txt">연구개발시스템 공지사항</span-->
			</div>
			<div class="list_detail">
				<form id="designReqForm">
					<input type="hidden" name="regUserId" value="${SESS_AUTH.userId}">
					<input type="hidden" name="docNo" value="${docNo}">
					<input type="hidden" name="docVersion" value="${docVersion}">
					<input type="hidden" name="state" value="0">
					<ul>
						<li class="normalReport">
							<dt>부서</dt>
							<dd class="pr20 pb10">
								<input type="text" name="department" id="department" value="" style="width: 70%;" />
							</dd>
						</li>
						<li class="normalReport">
							<dt>담당자</dt>
							<dd class="pr20 pb10">
								<input type="text" name="director" id="director" placeholder="" style="width: 70%;" />
							</dd>
						</li>
						<li class="normalReport">
							<dt>의뢰일자</dt>
							<dd class="pr20 pb10">
								<input type="text" name="reqDate" id="reqDate" placeholder="" style="width: 20%;" />
							</dd>
						</li>
						<li class="normalReport">
							<dt>제목</dt>
							<dd class="pr20 pb10">
								<input type="text" name="title" class="req" id="title" placeholder="" style="width: 70%;" />
							</dd>
						</li>
						<li class="normalReport">
							<dt>영양성분표</dt>
							<dd class="pr20 pb10">
								<input type="radio" name="nutritionLabel.nutritionType" id="nutType1" value="1" checked="checked"/>
								<label for="nutType1"><span></span>유형1</label>
								<input type="radio" name="nutritionLabel.nutritionType" id="nutType2" value="2"/>
								<label for="nutType2"><span></span>유형2</label>
								<input type="radio" name="nutritionLabel.nutritionType" id="nutType3" value="3"/>
								<label for="nutType3"><span></span>유형3</label>
								<input type="radio" name="nutritionLabel.nutritionType" id="nutType4" value="4"/>
								<label for="nutType4"><span></span>유형4</label>
								<input type="radio" name="nutritionLabel.nutritionType" id="nutType5" value="5"/>
								<label for="nutType5"><span></span>유형5</label>
								<input type="radio" name="nutritionLabel.nutritionType" id="nutType0" value="0"/>
								<label for="nutType0"><span></span>간소화</label>
								<br>
							</dd>
						</li>
						<li id="nutritionUnitLi" style="display: block;">
							<dt>총내용량 단위</dt>
							<dd>
								<input type="radio" name="nutritionLabel.unit" id="nutUnit1" value="g" checked="checked"/>
								<label for="nutUnit1"><span></span>g</label>
								<input type="radio" name="nutritionLabel.unit" id="nutUnit2" value="ml"/>
								<label for="nutUnit2"><span></span>ml</label>
								<input type="radio" name="nutritionLabel.unit" id="nutUnit3" value="L"/>
								<label for="nutUnit3"><span></span>L</label>
							</dd>
						</li>
						<li id="natriumTypeLi" style="display: block;">
							<dt>대상 식품유형</dt>
							<dd>
								<div class="selectbox req" style="width:45%">
		                            <select id="natriumType" name="nutritionLabel.natriumType" onchange="changeNaType(event)">
		                            	<option value="">-- 대상 식품유형 선택 --</option>
		                            	<option value="A1">국수(국물형) 나트륨 평균함량은 1,640mg</option>
		                            	<option value="A2">국수(비국물형) 나트륨 평균함량은 1,230mg</option>
		                            	<option value="B1">냉면(국물형) 나트륨 평균함량은 1,520mg</option>
		                            	<option value="B2">냉면(비국물형) 나트륨 평균함량은 1,160mg</option>
		                            	<option value="C1">유탕면류(국물형) 나트륨 평균함량은 1,730mg</option>
		                            	<option value="C2">유탕면류(비국물형) 나트륨 평균함량은 1,140mg</option>
		                            	<option value="D1">즉섭섭취식품(햄버거) 나트륨 평균함량은 1,220mg</option>
		                            	<option value="D2">즉섭섭취식품(샌드위치) 나트륨 평균함량은 730mg</option>
		                            </select>
									<label for="natriumType">-- 대상 식품유형 선택 --</label>
								</div>
							</dd>
						</li>
						<li id="nutritionLi" style="display: block">
							<dt class="none-dt"></dt>
							<dd>
								<div class="box">
									<div class="left-box">
										<div class="table-nut" style="width: 300px; background-color: #fff;">
											<table id="nutrientTable" class="nutrientTable"></table>
										</div>
									</div>
									<div class="right-box">
										<div class="img-box">
											<img id="sodium" src="/resources/images/disp/sodium1.png" alt="graph" />
										</div>
										<div class="img-sodium">0mg</div>
										<div class="img-text">나트륨 함량 비교 표시</div>
										<div class="img-category">
											<span id="natriumTypeText"></span>
										</div>
									</div>
								</div>
							</dd>
						</li>
						<li class="normalReport">
							<dt>메모</dt>
							<dd class="pr20 pb10">
							<!-- textarea 내 <div>가 좌측으로 된 이유는 <textarea와 줄맞출경우 DB에 Tab이 입력된것처럼 저장됨. -->
								<textarea id="content" name="content" style="width: 100%; height: 180px">
<div><font face="Arial"><span style="font-size: 12px;font-weight: bold;">1. 영양성분 (실측,이론 적용 방법 작성) :</span><span style="font-size: 12px;">&nbsp;</span></font></div>
<div><font face="Arial"><span style="font-size: 12px;font-weight: bold;">2. 마케팅문구 (특정성분 입력 시 필요) :</span><span style="font-size: 12px;">&nbsp;</span></font></div>
<div><font face="Arial"><span style="font-size: 12px;font-weight: bold;">3. 변경사항 (기존 제품에서 원료 등 변경 사항 입력) :</span><span style="font-size: 12px;">&nbsp;</span></font></div>
<div><font face="Arial"><span style="font-size: 12px;font-weight: bold;">4. 신규원료 (신규 원료 유무) :</span><span style="font-size: 12px;">&nbsp;</span></font></div>
<div><font face="Arial"><span style="font-size: 12px;font-weight: bold;">5. 간소화 여부 (간소화 필요 시 작성) :</span><span style="font-size: 12px;">&nbsp;</span></font></div>
<div><font face="Arial"><span style="font-size: 12px;font-weight: bold;">6. 손실제품 유무 (손실 제품일 경우 해당 중량 기록 必) :</span><span style="font-size: 12px;">&nbsp;</span></font></div>
<div><font face="Arial"><span style="font-size: 12px;font-weight: bold;">7. 냉동제품(식품 : 가열 섭취 or 가열하지 않고 섭취 / 축산물 : 살균 or 비살균 여부) :</span><span style="font-size: 12px;">&nbsp;</span></font></div>
<div><font face="Arial"><span style="font-size: 12px;font-weight: bold;">8. 기타사항(특이사항 기록) :</span><span style="font-size: 12px;">&nbsp;</span></font></div></textarea>
							</dd>
						</li>
					</ul>
				</form>
			</div>
			<div class="btn_box_con5">
				<button class="btn_admin_gray" onClick="goMfgDetail()" style="width: 120px;">목록</button>
			</div>
			
			<div class="btn_box_con4">
				<button class="btn_admin_red" onclick="saveDesignRequestDoc()">저장</button>
				<button class="btn_admin_navi" onClick="goMfgDetail()">취소</button>
			</div>
			<hr class="con_mode" />
			<!-- 신규 추가 꼭 데려갈것 !-->
		</div>
	</section>
</div>

