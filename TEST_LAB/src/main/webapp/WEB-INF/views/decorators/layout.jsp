<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="kr.co.aspn.util.*" %>
<%@ page import="java.util.Date" %>
<%
	String userId = UserUtil.getUserId(request);
	String userName = UserUtil.getUserName(request);
	
	String userGrade = UserUtil.getUserGrade(request);
	String userDept = UserUtil.getDeptCode(request);
	String userTeam = UserUtil.getTeamCode(request);
	String userGradeName = UserUtil.getUserGradeName(request);
	String userDeptName = UserUtil.getDeptCodeName(request);
	String userTeamName = UserUtil.getTeamCodeName(request);
	String isAdmin = UserUtil.getIsAdmin(request);
	String theme = UserUtil.getTheme(request);
	if( theme == null || "".equals(theme) ) {
		theme = "theme01";
	}
	String contentMode = UserUtil.getContentMode(request);
	if( contentMode == null || "".equals(contentMode) ) {
		contentMode = "content_theme01";
	}
	String widthMode = UserUtil.getWidthMode(request);
	if( widthMode == null || "".equals(widthMode) ) {
		widthMode = "wrap_in01";
	}

%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1" /> 
<html>
  <head>
    <!--title><sitemesh:write property='title'/></title-->
    <title>연구개발시스템</title>    
    <sitemesh:write property='head'/>
    <link rel="shortcut icon" href="../resources/images/favicon.ico"/>
    <link href="../resources/css/common.css" rel="stylesheet" type="text/css" />
	<link href="../resources/css/board.css" rel="stylesheet" type="text/css" />
	<link href="../resources/css/layout.css" rel="stylesheet" type="text/css" />
	<link href="../resources/css/theme.css" rel="stylesheet" type="text/css" />
	<link href="../resources/css/loading.css" rel="stylesheet" type="text/css" />
	<link href="../resources/css/tooltip/tooltipster.bundle.min.css" rel="stylesheet" type="text/css" />
	<link href="../resources/css/tooltip/plugins/tooltipster/sideTip/themes/tooltipster-sideTip-light.min.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="../resources/js/jquery-ui-1.12.1/jquery-ui.min.css">
    <link href="../resources/css/jquery.timepicker.min.css" rel="stylesheet" type="text/css" />
	  <!-- TreeGrid css start -->
	  <link href="../resources/css/cnc_treegrid.css?v=2" rel="stylesheet" type="text/css" />
	  <link href="../resources/css/component.css?v=<%=System.currentTimeMillis() %>" rel="stylesheet" type="text/css" />
	  <!-- TreeGrid css end -->
    
    <script type="text/javascript" src="../resources/js/jquery-3.3.1.js"></script>
    <script type="text/javascript" src="../resources/js/jquery-3.3.1.js"></script>
	<script type="text/javascript" src="../resources/js/jquery.form.js"></script>
	<script type="text/javascript" src="../resources/js/jquery.loading.js"></script>
	<script type="text/javascript" src="../resources/js/jquery.selectboxes.js"></script>
	<script type="text/javascript" src="../resources/js/jquery-ui-1.12.1/jquery-ui.min.js"></script>
	<script type="text/javascript" src="../resources/js/classie.js"></script>
	<script type="text/javascript" src="../resources/js/modernizr.custom.js"></script>
	<script type="text/javascript" src="../resources/js/percent.js"></script>
	<script type="text/javascript" src="../resources/js/star.js"></script>
	<script type="text/javascript" src="../resources/js/common.js"></script>
	<script type="text/javascript" src="../resources/js/tooltip/tooltipster.bundle.min.js"></script>
	<script type="text/javascript" src="../resources/js/jquery.timepicker.min.js"></script>
	  <!-- TreeGrid javascript start -->
	  <script type="text/javascript" src="../resources/js/treegrid/GridE.js"></script>
	  <script type="text/javascript" src="../resources/js/treegrid/GridToolBarBtn.js"></script>
	  <!-- TreeGrid javascript end -->
	<script type="text/javascript"> 
		$(document).ready(function(){
			initTimer();
			var selectTarget = $('.selectbox select');
		 	selectTarget.on('blur', function(){
			$(this).parent().removeClass('focus');			
	 		});
			selectTarget.change(function(){
				var select_name = $(this).children('option:selected').text();
				$(this).siblings('label').text(select_name);
			});
		});
	</script> 
	<!-- 스크롤됬을때 메뉴 디자인 변경 --> 
	<script type="text/javascript">
			$(document).ready(function(){
				
				// 로딩 시 스크롤 막기
				$('#fixNextTag').before('<div id="lab_loading" style="display:none"><div class="lab_loader"></div></div>');
				$('#lab_loading').on('scroll touchmove mousewheel', function(event) {
					event.preventDefault();
					event.stopPropagation();
					return false;
				});
				
				var topBar = $("#topBar").offset();
	
				$(window).scroll(function(){
					
					var docScrollY = $(document).scrollTop()
					var barThis = $("#topBar")
					var fixNext = $("#fixNextTag")
	
					if( docScrollY > topBar.top ) {
						barThis.addClass("top_bar_fix");
						fixNext.addClass("pd_top_80");
					}else{
						barThis.removeClass("top_bar_fix");
						fixNext.removeClass("pd_top_80");
					}
	
				});
	
			})
	</script>
	<script>function stepchage(id,step){document.getElementById(id).className = step;}</script>
	<script>
		// 사용자로부터 마우스 또는 키보드 이벤트가 없을경우의   자동로그아웃까지의 대기시간, 분단위
		var iMinute = 180;
		 
		var iSecond = iMinute * 60 ;
		var timerchecker = null;
		 
		initTimer=function()
		{
			//사용자부터 마우스 또는 키보드 이벤트가 발생했을경우자동로그아웃까지의 대기시간을 다시 초기화
		    if(window.event)
		    {
				iSecond = iMinute * 60 ;
				clearTimeout(timerchecker);
		    }
		    if(iSecond > 0)
		    {
		    	 //$("#timer").html("&nbsp;" + Lpad(rHour, 2) + "시간 " + Lpad(rMinute, 2)+ "분 " + Lpad(rSecond, 2) + "초 ");
		    	 //alert("&nbsp;" + Lpad(rHour, 2) + "시간 " + Lpad(rMinute, 2)+ "분 " + Lpad(rSecond, 2) + "초 ");
		    	/////지정한 시간동안 마우스, 키보드 이벤트가 발생되지 않았을 경우
		      	iSecond--;
				timerchecker = setTimeout("initTimer()", 1000); // 1초 간격으로 체크
		   	}
		   	else
		   	{
		    	clearTimeout(timerchecker);				
				location.href = "../user/logout"; // 로그아웃 처리 페이지
			}
		}
		document.onclick = initTimer; /// 현재 페이지의 사용자 마우스 클릭이벤트 캡춰
		document.onkeypress = initTimer;/// 현재 페이지의 키보트 입력이벤트 캡춰
		document.onmousemove = initTimer;
		</script>
  </head>
  <body class="<%=contentMode%>" id="content_d">
  <div class="<%=theme%>" id="theme">
	<div class="wrap">
	<!-- wrap_in01/02 -->
	<!-- 클래스명 숫자에 따라 넓이값변경-->
		<div class="<%=widthMode%>" id="width_wrap">		
		<% if( userDept != null && ( "dept1".equals(userDept) || "dept2".equals(userDept) || "dept3".equals(userDept) 
				|| "dept4".equals(userDept) || "dept5".equals(userDept) || "dept6".equals(userDept) || "dept10".equals(userDept)|| "dept11".equals(userDept) || "dept12".equals(userDept) || "dept13".equals(userDept)) || "Y".equals(isAdmin)) { %> 
		  	<jsp:include page="header.jsp" flush="true" />
		 <% } else { %>
		 	<jsp:include page="header_normal.jsp" flush="true" /> 	
		 <% } %>
		  	<div class="" id="bodyy">
		    <sitemesh:write property='body'/>
		    </div>
		    <jsp:include page="footer.jsp" flush="true" />
    	</div>
  	</div> 
  	</div>
  	<div id="timer"></div> 
  </body>


  <c:set var="webCubeEnable" value="false"></c:set><!--webCubeEnable=true 스크린캡쳐방지 활성화, false:비활성화  -->
  <c:if test="${webCubeEnable}">
	  <!-- WebCubeAgent start -->
	  <script type="text/javascript" src="/resources/WebCube/WebCubeAgent_UserSet.js"></script>
	  <script  type="text/javascript">
		  //################ 관리자 페이지 사용시 입력 파라메터 #################################################
		  // id 입력 변수
		  WebCube_AdminPageObj.id = "";
		  // domain 입력 변수
		  WebCube_AdminPageObj.domain = "";
		  // company 입력 변수
		  WebCube_AdminPageObj.company = "";
		  // NextPage로 이동
		  WebCube_Go_NextPage = false;
		  //#####################################################################################################
	  </script>
	  <script language="javascript" for="Obj" event="CtrlStatus( nCode, nResult)" src="/resources/WebCube/ActiveX1.js"></script>
	  <script language="javascript" for="Obj" event="CtrlInitComplete()" src="/resources/WebCube/ActiveX2.js"></script>
	  <script type="text/javascript" src="/resources/WebCube/WebCubeAgent_Msg.js"></script>
	  <script type="text/javascript" src="/resources/WebCube/WebCubeAgent_Setup.js"></script>
	  <script type="text/javascript" src="/resources/WebCube/WebCubeAgent_I.js"></script>
	  <script type="text/javascript" src="/resources/WebCube/ActiveX3.js"></script>
	  <!-- WebCubeAgent end -->
  </c:if>

</html>