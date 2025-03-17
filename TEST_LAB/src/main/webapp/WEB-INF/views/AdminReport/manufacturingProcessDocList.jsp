<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ page session="false" %>
<title>제조공정서 리스트</title>
<script type="text/javascript">
	$(document).ready(function(){
		Grids.OnReadData = function(grid,source,Func){
			if(grid.id == "manufacturingProcessDocList"){
				if(source.Name == "Data"){
					$("#lab_loading").show();
				}
			}
		}
		Grids.OnDataReceive = function(grid,source){
			if(grid.id == "manufacturingProcessDocList"){
				if(source.Name == "Data"){
					$("#lab_loading").hide();
				}
			}
		}
	});
</script>
<div class="wrap_in" id="fixNextTag">
	<span class="path">
		제조공정서 리스트&nbsp;&nbsp;<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;
		관리자레프트&nbsp;&nbsp;<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;
		<a href="#">${strUtil:getSystemName()}</a>
	</span>
	<section class="type01">
	<!-- 상세 페이지  start-->
		<h2 style="position:relative">
			<span class="title_s">Manufacturing Process Doc List</span>
			<span class="title">제조공정서 리스트</span>
			<div  class="top_btn_box">
<%--				<ul>--%>
<%--					<li>--%>
<%--					</li>--%>
<%--				</ul>--%>
			</div>
		</h2>
		<div class="group01" >
			<div class="title"><!--span class="txt">연구개발시스템 공지사항</span--></div>

			<div class="main_tbl">
				<div class="fl-box panel-wrap">
<%--					<h5 class="bullet-tit">계정 리스트</h5>--%>

					<div id="userList" style="width: 100%" >
						<bdo Debug=""
							 Layout_Url="/AdminReport/manufacturingProcessDocListLayout?gridId=manufacturingProcessDocList"
							 Data_Url="/AdminReport/manufacturingProcessDocListData" >
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
