<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
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
<table class="nutrientTable">
	<colgroup>
		<col width="3%"/>
		<col width="20%"/>
		<col width="auto"/>
		<col width="10%"/>
		<col width="25%"/>
		<col width="13%"/>
	</colgroup>
	<thead>
		<tr>
			<th rowspan="2" colspan="3"><span style="font-size: 17px; font-weight: bold;">영양정보</span></th>
			<th colspan="3" style="text-align: right">
				<span style="font-size: 9px">총 내용량 ${nutritionLabel.weight} ${nutritionLabel.unit}</span>
			</th>
		</tr>
		<tr>
			<th colspan="3" style="text-align: right">
				<span style="font-size: 9px">${nutritionLabel.kcalText} </span>
				<span style="font-size: 12px">${nutritionLabel.kcal}kcal</span>
			</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td colspan="2">${nutritionLabel.pieceText}</td>
			<td colspan="2" style="text-align: right"><span style="font-size: 9px">1일 영양성분 기준치에 대한 비율</span></td>
			<td colspan="2" style="text-align: right"><span style="font-weight: bold;">총 내용량당</span></td>
		</tr>
		<tr class="bdTop">
			<td colspan="3">나트륨 <fmt:formatNumber value="${nutritionLabel.contNatrium}" type="number" groupingUsed="true"/>mg</td>
			<td style="text-align: right">
				${strUtil:roundData(nutritionLabel.contNatrium/2000*100)}%
			</td>
			<td><fmt:formatNumber value="${nutritionLabel.unitNatrium}" type="number" groupingUsed="true"/>mg</td>
			<td style="text-align: right">
				${strUtil:roundData(nutritionLabel.unitNatrium/2000*100)}%
			</td>
		</tr>
		<tr>
			<td class="bdTop" colspan="3">탄수화물 <fmt:formatNumber value="${nutritionLabel.contCarbohydrate}" type="number" groupingUsed="true"/>g</td>
			<td class="bdTop" style="text-align: right">
				${strUtil:roundData(nutritionLabel.contCarbohydrate/324*100)}%
			</td>
			<td class="bdTop"><fmt:formatNumber value="${nutritionLabel.unitCarbohydrate}" type="number" groupingUsed="true"/>g</td>
			<td class="bdTop" style="text-align: right">
				${strUtil:roundData(nutritionLabel.unitCarbohydrate/324*100)}%
			</td>
		</tr>
		<tr>
			<td></td>
			<td class="bdTopGrey" colspan="2"> 당류 <fmt:formatNumber value="${nutritionLabel.contSugars}" type="number" groupingUsed="true"/>g</td>
			<td class="bdTopGrey" style="text-align: right">
				${strUtil:roundData(nutritionLabel.contSugars/100*100)}%
			</td>
			<td><fmt:formatNumber value="${nutritionLabel.unitSugars}" type="number" groupingUsed="true"/>g</td>
			<td style="text-align: right">
				${strUtil:roundData(nutritionLabel.unitSugars/100*100)}%
			</td>
		</tr>
		<tr class="bdTop">
			<td colspan="3">지방 <fmt:formatNumber value="${nutritionLabel.contFat}" type="number" groupingUsed="true"/>g</td>
			<td class="bdTop" style="text-align: right">
				${strUtil:roundData(nutritionLabel.contFat/54*100)}%
			</td>
			<td><fmt:formatNumber value="${nutritionLabel.unitFat}" type="number" groupingUsed="true"/>g</td>
			<td style="text-align: right">
				${strUtil:roundData(nutritionLabel.unitFat/54*100)}%
			</td>
		</tr>
		<tr>
			<td></td>
			<td class="bdTopGrey" colspan="2">트랜스지방 <fmt:formatNumber value="${nutritionLabel.contTransFat}" type="number" groupingUsed="true"/>g</td>
			<td class="bdTopGrey" style="text-align: right"></td>
			<td><fmt:formatNumber value="${nutritionLabel.unitTransFat}" type="number" groupingUsed="true"/>g</td>
			<td style="text-align: right"></td>
		</tr>
		<tr>
			<td></td>
			<td class="bdTopGrey" colspan="2"> 포화지방 <fmt:formatNumber value="${nutritionLabel.contSaturatedFat}" type="number" groupingUsed="true"/>g</td>
			<td class="bdTopGrey" style="text-align: right">
				${strUtil:roundData(nutritionLabel.contSaturatedFat/15*100)}%
			</td>
			<td><fmt:formatNumber value="${nutritionLabel.unitSaturatedFat}" type="number" groupingUsed="true"/>g</td>
			<td style="text-align: right">
				${strUtil:roundData(nutritionLabel.unitSaturatedFat/15*100)}%
			</td>
		</tr>
		<tr class="bdTop">
			<td colspan="3">콜레스테롤 <fmt:formatNumber value="${nutritionLabel.contCholesterol}" type="number" groupingUsed="true"/>mg</td>
			<td class="bdTop" style="text-align: right">
				${strUtil:roundData(nutritionLabel.contCholesterol/300*100)}%
			</td>
			<td><fmt:formatNumber value="${nutritionLabel.unitCholesterol}" type="number" groupingUsed="true"/>mg</td>
			<td style="text-align: right">
				${strUtil:roundData(nutritionLabel.unitCholesterol/300*100)}%
			</td>
		</tr>
		<tr class="bdTop">
			<td colspan="3">단백질 <fmt:formatNumber value="${nutritionLabel.contProtein}" type="number" groupingUsed="true"/>g</td>
			<td class="bdTop" style="text-align: right">
				${strUtil:roundData(nutritionLabel.contProtein/55*100)}%
			</td>
			<td><fmt:formatNumber value="${nutritionLabel.unitProtein}" type="number" groupingUsed="true"/>g</td>
			<td style="text-align: right">
				${strUtil:roundData(nutritionLabel.unitProtein/55*100)}%
			</td>
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