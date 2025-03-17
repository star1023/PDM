<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page session="false" %>
<title>차트 테스트</title>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script type="text/javascript">
google.charts.load('current', {'packages':['corechart']});
google.charts.setOnLoadCallback(drawVisualization);

	function drawVisualization(){
		
		var data = google.visualization.arrayToDataTable([
			['Month','Bolivia','Ecuador','Madagascar','Papua New Guinea','Rwanda','Average'],
			['2004/05',0,0,0,0,0,0],
			['2005/06',135,1120,599,1268,288,682],
			['2006/07',157,1167,587,807,397,623],
			['2007/08',139,1110,615,968,215,609.4],
			['2008/09',136,691,629,1026,366,569.6]
		]);
		
		var options  = {
				title : '테스트',
				seriesType : 'bars',
				series : {5:{type:'line'}}
		};
		
		var chart = new google.visualization.ComboChart(document.getElementById('chart_div'));
		chart.draw(data,options);
	}
	function goDownload() {
		$("#form").submit();  
	}
</script>
<form id="form" name="form" method="post" action="../file/multiFileDownload">
<div class="wrap_in" id="fixNextTag">
	<span class="path">
		파일다운로드 테스트&nbsp;&nbsp;<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;
		테스트&nbsp;&nbsp;<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;
		<a href="#">삼립식품 연구개발시스템</a>
	</span>
	<section class="type01">
	<!-- 상세 페이지  start-->
		<h2 style="position:relative">
			<span class="title_s">test</span>
			<span class="title">테스트</span>
			<div  class="top_btn_box">
				<ul>
					<li>
						<button class="btn_circle_red" onClick="location.href='#open'">&nbsp;</button>
					</li>
				</ul>
			</div>
		</h2>
		<div class="group01" >
			<div class="title"><!--span class="txt">연구개발시스템 공지사항</span--></div>
			<div class="list_detail">
				<ul>
					<li class="pt10">
						<dt>이름</dt>
						<dd class="pr20 pb10">
							<input type="checkbox" name="fmNo" id="fmNo1" value="4952"><label for="fmNo1"><span></span>4952</label>
							<input type="checkbox" name="fmNo" id="fmNo2" value="4903"><label for="fmNo2"><span></span>4903</label>
						</dd>
					</li>
				</ul>
			</div>
			<div class="btn_box_con5">
			</div>
			<div class="btn_box_con4"> 
				<button type="button" class="btn_admin_gray" onClick="javascript:goDownload()">다운받기</button>
			</div>
			 <hr class="con_mode"/><!-- 신규 추가 꼭 데려갈것 !-->
		</div>
		<div id="chart_div" style="width:900px; height:500px"></div>
	</section>	
</div>
<!-- 컨텐츠 close-->	
</form>