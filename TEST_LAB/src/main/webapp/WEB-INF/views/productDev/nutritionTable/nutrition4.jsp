<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
.list_detail ul li dt.none-dt {background-image: none; }
.nutrientTable{ width:100%;font-family:'맑은고딕',Malgun Gothic; font-size:13px; float:left; font-weight: bold}
.nutrientTable{border:2px solid #111;}
.nutrientTable thead { text-align:center; color: #fff; background-color:#111; border:0; height:34px; font-size:12px; border-bottom:2px solid #111;}
.nutrientTable thead tr{height: 1.5em;}
.nutrientTable tbody tr{height: 2em;}
.nutrientTable tbody tr:nth-child(even) {background-color:#fff;}
.nutrientTable tbody tr:nth-child(odd) {background-color:#fff;}
.nutrientTable tbody tr:first-child td:nth-child(2) {border-right:1px solid #111;}
.nutrientTable tbody tr:first-child td:nth-child(3) {background-color: #ccc;}
.nutrientTable tbody tr:nth-child(n+2) td:nth-last-child(3) {border-right:1px solid #111;}
.nutrientTable tbody tr:nth-child(n+2) td:nth-last-child(-n+2) {background-color: #ccc;}
.nutrientTable tfoot tr{background-color:#fff; border-top:2px solid #111; border-bottom:1px solid #111;}
.bdTop{border-top: 1px solid #111;}
.bdTopGrey{border-top: 1px solid #ddd;}
.bl1{border-left: 1px solid #111;}
.pl10{padding-left: 10px;}
.designInput{padding-bottom: 2px; font-size: 12px; font-weight: bold; width: 42px; text-align: center;}

.table-nut .box{width: 100%; height: 100%;}
.box .left-box {display: inline-block; width: 40%; min-width: 300px; vertical-align: top;}
.box .right-box {display: inline-block; width: 57.5%; height: 310px; position: relative; background-color: #fff;}
.box .right-box .img-box { position: absolute; top: 50%; transform: translateY(-50%);}
.box .right-box .img-box img {width: 100%;}
.box .right-box .img-sodium{
	position: absolute;
	left: 48%;
	bottom: 30%;
	transform: translateX(-50%);
	font-size: 25px;
	font-weight: bold;
	color: #333;
}
.box .right-box .img-text{
	position: absolute;
	left: 48%;
	bottom: 17%;
	font-size: 17px;
	transform: translateX(-50%);
	font-weight: bold;
}
.box .right-box .img-category{
	position: absolute;
	left: 48%;
	bottom: 10%;
	transform: translateX(-50%);
	font-weight: bold;
	font-size: 11px;
	color: #777;
}
</style>
<script>
	$(document).ready(function(){
		$('input[name=nutritionLabel\\.contNatrium]').keyup();
		$('input[name=nutritionLabel\\.contCarbohydrate]').keyup();
		$('input[name=nutritionLabel\\.contSugars]').keyup();
		$('input[name=nutritionLabel\\.contFat]').keyup();
		$('input[name=nutritionLabel\\.contTransFat]').keyup();
		$('input[name=nutritionLabel\\.contSaturatedFat]').keyup();
		$('input[name=nutritionLabel\\.contCholesterol]').keyup();
		$('input[name=nutritionLabel\\.contProtein]').keyup();
		
		$('input[name=nutritionLabel\\.unitNatrium]').keyup();
		$('input[name=nutritionLabel\\.unitCarbohydrate]').keyup();
		$('input[name=nutritionLabel\\.unitSugars]').keyup();
		$('input[name=nutritionLabel\\.unitFat]').keyup();
		$('input[name=nutritionLabel\\.unitSaturatedFat]').keyup();
		$('input[name=nutritionLabel\\.unitCholesterol]').keyup();
		$('input[name=nutritionLabel\\.unitProtein]').keyup();
	})
	function changeNutrition(target, type){
		var targetElment = $(target).parent().next();
		var sodium = uncomma(target.value);
		
		if(type == 'na') {
			changeSodium(target);
			targetElment.text((sodium/2000*100).toFixed(0)+'%')
		}
		if(type == 'ca') targetElment.text((sodium/324*100).toFixed(0)+'%')
		if(type == 'su') targetElment.text((sodium/100*100).toFixed(0)+'%')
		if(type == 'fat') targetElment.text((sodium/54*100).toFixed(0)+'%')
		if(type == 'sf') targetElment.text((sodium/15*100).toFixed(0)+'%')
		if(type == 'ch') targetElment.text((sodium/300*100).toFixed(0)+'%')
		if(type == 'pr') targetElment.text((sodium/55*100).toFixed(0)+'%')
	}
	
	function changeNutrition2(target, type){
		var targetElment = $(target).parent().next();
		var sodium = uncomma(target.value);
		
		if(type == 'na') targetElment.text((sodium/2000*100).toFixed(0)+'%')
		if(type == 'ca') targetElment.text((sodium/324*100).toFixed(0)+'%')
		if(type == 'su') targetElment.text((sodium/100*100).toFixed(0)+'%')
		if(type == 'fat') targetElment.text((sodium/54*100).toFixed(0)+'%')
		if(type == 'sf') targetElment.text((sodium/15*100).toFixed(0)+'%')
		if(type == 'ch') targetElment.text((sodium/300*100).toFixed(0)+'%')
		if(type == 'pr') targetElment.text((sodium/55*100).toFixed(0)+'%')
	}
	
	/* function chkword(obj, maxlength) {
		var str = obj.value; // 이벤트가 일어난 컨트롤의 value 값
		var str_length = str.length; // 전체길이
		
		// 변수초기화
		var max_length = maxlength; // 제한할 글자수 크기
		var i = 0; // for문에 사용
		var ko_byte = 0; // 한글일경우는 2 그밗에는 1을 더함   
		var li_len = 0; // substring하기 위해서 사용
		var one_char = ""; // 한글자씩 검사한다
		var str2 = ""; // 글자수를 초과하면 제한할수 글자전까지만 보여준다.
		for (i = 0; i < str_length; i++) {
			// 한글자추출
			one_char = str.charAt(i);
			ko_byte++;
		}           // 전체 크기가 max_length를 넘지않으면
		if (ko_byte <= max_length) {
			li_len = i + 1;
		}
		// 전체길이를 초과하면
		if (ko_byte > max_length) {
			str2 = str.substr(0, max_length);
			obj.value = str2;
		}
		obj.focus();
	} */
</script>
<table class="nutrientTable">
	<colgroup>
		<col width="18px"/>
		<col width="20%"/>
		<col/>
		<col width="10%"/>
		<col width="25%"/>
		<col width="13%"/>
	</colgroup>
	<thead>
		<tr>
			<th rowspan="2" colspan="3"><span style="font-size: 17px; font-weight: bold;">영양정보</span></th>
			<th colspan="3" style="text-align: right">
				<span style="font-size: 9px">총 내용량 <input class="designInput" type="text" name="nutritionLabel.weight" value="00" style="padding: 2px; width: 20px; font-size: 11px"></span>
				<span style="font-size: 9px" id="unitSpan">${unit}</span>
				<span style="font-size: 9px">
					<input class="designInput" type="text" name="nutritionLabel.weightText" placeholder="(00g 0개)" style="padding: 2px; width: 60px; font-size: 11px">
				</span>
			</th>
		</tr>
		<tr>
			<th colspan="3" style="text-align: right">
				<span style="font-size: 9px">
					<input class="designInput" type="text" name="nutritionLabel.kcalText" placeholder="1개(00g)당" style="padding: 2px; width: 60%;" number>
					<input class="designInput" type="text" name="nutritionLabel.kcal" value="000" style="padding: 2px; width: 30px;" number>kcal
				</span>
			</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td colspan="2"><input class="designInput" type="text" name="nutritionLabel.pieceText" value="1개당" style="padding: 2px; width: 65px; font-size: 11px" onkeyup="chkword(this,5)"></td>
			<td colspan="2" style="text-align: right"><span style="font-size: 9px">1일 영양성분 기준치에 대한 비율</span></td>
			<td colspan="2" style="text-align: right"><span style="font-weight: bold;">총 내용량당</span></td>
		</tr>
		<tr class="bdTop">
			<td colspan="3">나트륨 <input class="designInput" type="text" name="nutritionLabel.contNatrium" value="0" style="padding: 2px;" onKeyUp="removeChar(event);inputNumberFormat(this, 'na');" number>mg</td>
			<td style="text-align: right">00%</td>
			<td style="text-align: left"><input class="designInput" type="text" name="nutritionLabel.unitNatrium" value="0" style="padding: 2px;" onKeyUp="removeChar(event);inputNumberFormat2(this, 'na');" number>mg</td>
			<td style="text-align: right">00%</td>
		</tr>
		<tr class="bdTop">
			<td colspan="3">탄수화물 <input class="designInput" type="text" name="nutritionLabel.contCarbohydrate" value="0" style="padding: 2px;" onKeyUp="removeChar(event);inputNumberFormat(this, 'ca');">g</td>
			<td style="text-align: right">00%</td>
			<td style="text-align: left"><input class="designInput" type="text" name="nutritionLabel.unitCarbohydrate" value="0" style="padding: 2px;" onKeyUp="removeChar(event);inputNumberFormat2(this, 'ca');" number>g</td>
			<td style="text-align: right">00%</td>
		</tr>
		<tr>
			<td></td>
			<td class="bdTopGrey" colspan="2"> 당류 <input class="designInput" type="text" name="nutritionLabel.contSugars" value="0" style="padding: 2px;" onKeyUp="removeChar(event);inputNumberFormat(this, 'su');">g</td>
			<td class="bdTopGrey" style="text-align: right">00%</td>
			<td class="bdTopGrey" style="text-align: left"><input class="designInput" type="text" name="nutritionLabel.unitSugars" value="0" style="padding: 2px;" onKeyUp="removeChar(event);inputNumberFormat2(this, 'su');" number>g</td>
			<td class="bdTopGrey" style="text-align: right">00%</td>
		</tr>
		<tr class="bdTop">
			<td colspan="3">지방<input class="designInput" type="text" name="nutritionLabel.contFat" value="0" style="padding: 2px;" onKeyUp="removeChar(event);inputNumberFormat(this, 'fat');">g</td>
			<td style="text-align: right">00%</td>
			<td style="text-align: left"><input class="designInput" type="text" name="nutritionLabel.unitFat" value="0" style="padding: 2px;" onKeyUp="removeChar(event);inputNumberFormat2(this, 'fat');" number>g</td>
			<td style="text-align: right">00%</td>
		</tr>
		<tr>
			<td></td>
			<td class="bdTopGrey" colspan="2">트랜스지방 <input class="designInput" type="text" name="nutritionLabel.contTransFat" value="0" style="padding: 2px;">g</td>
			<td class="bdTopGrey" style="text-align: right"></td>
			<td class="bdTopGrey" style="text-align: left"><input class="designInput" type="text" name="nutritionLabel.unitTransFat" value="0" style="padding: 2px;" number>g</td>
			<td class="bdTopGrey" style="text-align: right"></td>
		</tr>
		<tr>
			<td></td>
			<td class="bdTopGrey" colspan="2"> 포화지방 <input class="designInput" type="text" name="nutritionLabel.contSaturatedFat" value="0" style="padding: 2px;" onKeyUp="removeChar(event);inputNumberFormat(this, 'sf');">g</td>
			<td class="bdTopGrey" style="text-align: right">00%</td>
			<td class="bdTopGrey" style="text-align: left"><input class="designInput" type="text" name="nutritionLabel.unitSaturatedFat" value="0" style="padding: 2px;" onKeyUp="removeChar(event);inputNumberFormat2(this, 'sf');" number>g</td>
			<td class="bdTopGrey" style="text-align: right">00%</td>
		</tr>
		<tr class="bdTop">
			<td colspan="3">콜레스테롤 <input class="designInput" type="text" name="nutritionLabel.contCholesterol" value="0" style="padding: 2px;" onKeyUp="removeChar(event);inputNumberFormat(this, 'ch');">mg</td>
			<td style="text-align: right">00%</td>
			<td style="text-align: left"><input class="designInput" type="text" name="nutritionLabel.unitCholesterol" value="0" style="padding: 2px;" onKeyUp="removeChar(event);inputNumberFormat2(this, 'ch');" number>mg</td>
			<td style="text-align: right">00%</td>
		</tr>
		<tr class="bdTop">
			<td colspan="3">단백질 <input class="designInput" type="text" name="nutritionLabel.contProtein" value="0" style="padding: 2px;" onKeyUp="removeChar(event);inputNumberFormat(this, 'pr');">g</td>
			<td style="text-align: right">00%</td>
			<td style="text-align: left"><input class="designInput" type="text" name="nutritionLabel.unitProtein" value="0" style="padding: 2px;" onKeyUp="removeChar(event);inputNumberFormat2(this, 'pr');" number>g</td>
			<td style="text-align: right">00%</td>
		</tr>
	</tbody>
	<tfoot>
		<tr>
			<td colspan="6">
				<span style="font-size: 11px; font-weight: bold">1일 영양성분 기준치에 대한 비율(%)</span>
				<span style="font-size: 11px; font-weight: normal;">은 2,000kcal기준이므로 개인의 필요 열량에 따라 다를 수 있습니다.</span>
			</td>
		</tr>
	</tfoot>
</table>