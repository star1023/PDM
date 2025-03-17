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
</script>
<table class="nutrientTable" style="position: relative;">
	<colgroup>
		<col width="18px"/>
		<col width="25%"/>
		<col/>
		<col width="10%"/>
	</colgroup>
	<thead>
		<tr>
			<th rowspan="2" colspan="2"><span style="font-size: 17px; font-weight: bold;">영양정보</span></th>
			<th colspan="2" style="text-align: right">
				<span style="font-size: 9px">총 내용량  <input class="designInput" type="text" name="nutritionLabel.weight" value="00" style="padding: 2px; width: 25px; font-size: 11px"></span>
				<span style="font-size: 9px" id="unitSpan">${unit}</span>
			</th>
		</tr>
		<tr>
			<th colspan="2" style="text-align: right">
				<span style="font-size: 9px">100g당 <input class="designInput" type="text" name="nutritionLabel.kcal" value="000" style="padding: 2px; width: 30px;" number>kcal</span>
			</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td colspan="2">100g당</td>
			<td colspan="2" style="text-align: right"><span style="font-size: 9px">1일 영양성분 기준치에 대한 비율</span></td>
		</tr>
		<tr class="bdTop">
			<td colspan="3">나트륨 <input class="designInput" type="text" name="nutritionLabel.contNatrium" value="0" style="padding: 2px;" onKeyUp="removeChar(event);inputNumberFormat(this, 'na');">mg</td>
			<td style="text-align: right">00%</td>
		</tr>
		<tr>
			<td class="bdTop" colspan="3">탄수화물 <input class="designInput" type="text" name="nutritionLabel.contCarbohydrate" value="0" style="padding: 2px;" onKeyUp="removeChar(event);inputNumberFormat(this, 'ca');">g</td>
			<td class="bdTop" style="text-align: right">00%</td>
		</tr>
		<tr>
			<td></td>
			<td class="bdTopGrey" colspan="2"> 당류 <input class="designInput" type="text" name="nutritionLabel.contSugars" value="0" style="padding: 2px;" onKeyUp="removeChar(event);inputNumberFormat(this, 'su');">g</td>
			<td class="bdTopGrey" style="text-align: right">00%</td>
		</tr>
		<tr class="bdTop">
			<td colspan="3">지방<input class="designInput" type="text" name="nutritionLabel.contFat" value="0" style="padding: 2px;" onKeyUp="removeChar(event);inputNumberFormat(this, 'fat');">g</td>
			<td style="text-align: right">00%</td>
		</tr>
		<tr>
			<td></td>
			<td class="bdTopGrey" colspan="2">트랜스지방 <input class="designInput" type="text" name="nutritionLabel.contTransFat" value="0" style="padding: 2px;" onKeyUp="removeChar(event);inputNumberFormat(this, 'tf');">g</td>
			<td class="bdTopGrey" style="text-align: right"></td>
		</tr>
		<tr>
			<td></td>
			<td class="bdTopGrey" colspan="2"> 포화지방 <input class="designInput" type="text" name="nutritionLabel.contSaturatedFat" value="0" style="padding: 2px;" onKeyUp="removeChar(event);inputNumberFormat(this, 'sf');">g</td>
			<td class="bdTopGrey" style="text-align: right">00%</td>
		</tr>
		<tr class="bdTop">
			<td colspan="3">콜레스테롤 <input class="designInput" type="text" name="nutritionLabel.contCholesterol" value="0" style="padding: 2px;" onKeyUp="removeChar(event);inputNumberFormat(this, 'ch');">mg</td>
			<td style="text-align: right">00%</td>
		</tr>
		<tr class="bdTop">
			<td colspan="3">단백질 <input class="designInput" type="text" name="nutritionLabel.contProtein" value="0" style="padding: 2px;" onKeyUp="removeChar(event);inputNumberFormat(this, 'pr');">g</td>
			<td style="text-align: right">00%</td>
		</tr>
	</tbody>
	<tfoot>
		<tr>
			<td colspan="4">
				<span style="font-size: 11px; font-weight: bold">1일 영양성분 기준치에 대한 비율(%)</span>
				<span style="font-size: 11px; font-weight: normal;">은 2,000kcal기준이므로 개인의 필요 열량에 따라 다를 수 있습니다.</span>
			</td>
		</tr>
	</tfoot>
</table>