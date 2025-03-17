<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ page session="false" %>
<title>사용자 관리</title>
<style type="text/css">
	.ui-datepicker{z-index: 1000 !important}
</style>
<script type="text/javascript">
	var startDt = "${startDt}";
	var endDt = "${endDt}";

	$(document).ready(function(){
		$("#startDate").datepicker({
			showOn: 'button',
			buttonImage: '<c:url value="../resources/images/btn_calendar.png"/>',
			buttonImageOnly: true,
			dateFormat: 'yy-mm-dd',
			constrainInput: false
		});

		$("#endDate").datepicker({
			showOn: 'button',
			buttonImage: '<c:url value="../resources/images/btn_calendar.png"/>',
			buttonImageOnly: true,
			dateFormat: 'yy-mm-dd',
			constrainInput: false
		});
		$("#ui-datepicker-div").css('font-size','0.8em');
		$('.ui-datepicker-trigger').css('margin-left', '8px');
		$('.ui-datepicker-trigger').css('margin-top', '-5px');
		$('.ui-datepicker-trigger').css('cursor', 'pointer');


		Grids.OnReadData = function(grid,source,Func){
			if(grid.id == "userLoginLog"){
				if(source.Name == "Data"){
					$("#lab_loading").show();
				}
			}
		}
		Grids.OnDataReceive = function(grid,source){
			if(grid.id == "userLoginLog"){
				if(source.Name == "Data"){
					$("#lab_loading").hide();
				}
			}
		}
	});

	function goSearch(){
		var start = $("#startDate").val();
		var end = $("#endDate").val();
		Grids.userLoginLog.Source.Data.Url = "/AdminReport/userLoginLogData?startDt=" + start + "&endDt=" + end;
		Grids.userLoginLog.ReloadBody();
	}
	function searchInitialize(){
		$("#startDate").val("${startDt}");
		$("#endDate").val("${endDt}");
		goSearch();
	}
</script>
<div class="wrap_in" id="fixNextTag">
	<span class="path">
		접속이력&nbsp;&nbsp;<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;
		관리자레프트&nbsp;&nbsp;<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;
		<a href="#">${strUtil:getSystemName()}</a>
	</span>
	<section class="type01">
	<!-- 상세 페이지  start-->
		<h2 style="position:relative">
			<span class="title_s">user login log</span>
			<span class="title">접속이력</span>
			<div  class="top_btn_box">


			</div>
		</h2>
		<div class="group01" >
			<div class="title"><!--span class="txt">연구개발시스템 공지사항</span--></div>
			<div class="search_box" >
				<ul>
					<li>
						<dt>기간</dt>
						<dd>
							<input type="text" class="ml5" style="width:110px;" id="startDate" name="startDate" value="${startDt}" readonly="readonly"/> <!-- <a href="#"><img src="../resources/images/btn_calendar.png" style=" margin-top:-4px;"></a> --> ~
							<input type="text" class="ml5" style="width:110px;" id="endDate" name="endDate" value="${endDt}" readonly="readonly"/> <!-- <a href="#"><img src="../resources/images/btn_calendar.png"  style=" margin-top:-4px;"></a> -->
						</dd>
					</li>
				</ul>
				<div class="fr pt5 pb10">
					<button  onclick="goSearch(); return false;" class="btn_con_search"><img src="../resources/images/btn_icon_search.png" style="vertical-align:middle;"/> 검색</button>
					<button class="btn_con_search" onclick="searchInitialize(); return false;"><img src="../resources/images/btn_icon_refresh.png" style="vertical-align:middle;"/> 검색 초기화</button>
				</div>
			</div>

			<div class="main_tbl">
				<div class="fl-box panel-wrap">
<%--					<h5 class="bullet-tit">계정 리스트</h5>--%>

					<div id="userList" style="width: 100%" >
						<bdo Debug=""
							 Layout_Url="/AdminReport/userLoginLogLayout?gridId=userLoginLog"
							 Data_Url="/AdminReport/userLoginLogData?startDt=${startDt}&endDt=${endDt}" >
						</bdo>
					</div>
				</div>

			</div>


				<div class="btn_box_con">
<%--					<button type="button" class="btn_admin_red" onClick="javascript:insertUser2();">사용자 등록</button>--%>
				</div>
				<hr class="con_mode"/>
			</div>
	</section>	
</div>	
