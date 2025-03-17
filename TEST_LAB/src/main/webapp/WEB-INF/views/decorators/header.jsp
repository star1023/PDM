<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.aspn.util.*, org.json.simple.*" %>    
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
	String contentMode = UserUtil.getContentMode(request);
	String widthMode = UserUtil.getWidthMode(request);
	JSONArray USER_MENU = (JSONArray)session.getAttribute("USER_MENU");
%>    
<header>
	<nav>
		<div class="main_nav" id="topBar">
			<div  class="menu_position01">
				<!--로고-->
				<a href="../main/main"><h1></h1></a>
				<!-- 추후 수정될 가능성 높음/ 메뉴가 많아질경우 테마 조정 필요 -->
				<ul class="main_menu" id="main_menu" style="display:none">
					<li class="select" id="design"><a href="/design/productDesignDocList">제품설계서</a></li>
					<li class="" id="dev">
						<a href="/dev/productDevDocList">제품개발</a>
						<ul>
							<li><a href="/dev/productDevDocList">제품개발문서</a></li>
							<li><a href="/trialReport/trialReportList">시생산결과보고서</a></li>
						</ul>
					</li>
					<!-- 수정 전 원래 조건 (isAdmin != null && "Y".equals(isAdmin)) || "3".equals(userGrade) -->
	               <li class="" id="manufacturingNo">
	                  <a href="../manufacturingNo/dbList">품목제조보고서</a>
	                  <ul>
	                    <li><a href="../manufacturingNo/dbList">품목제조보고서 DB</a></li>
		                <li><a href="../manufacturingNo/statusList2">품목제조보고서 현황</a></li>
	                  </ul>
	               </li>
					<li class="" id="report">
						<a href="../report/list">보고서</a>
						<ul>
							<li><a href="../report/list">제품보고서</a></li>
							<li><a href="../qareport/list">품질보고서</a></li>
						</ul>
					</li>
					<li class="" id="approval"><a href="../approval/approvalList">결재함</a>
					<!-- 2차메뉴처리-->
					<!--	<ul>
							<li><a href="../approval/approvalList">결재함</a></li>
							<li><a href="#">결재진행</a></li>
							<li><a href="#">결재완료</a></li>
							<li><a href="#">결재반려</a></li>
							<li><a href="#">결재참조</a></li>
						</ul>리-->
					</li>
					<li class="" id="material"><a href="../material/list">자재</a>
						<ul>
							<li><a href="../material/list">자재관리</a></li>
							<li><a href="../material/changeList">변경관리</a></li>
						</ul>
					</li>
					<li class="" id="notice"><a href="../adminNotice/noticeList">게시판</a>
						<ul>
							<li><a href="../adminNotice/noticeList">관리자공지</a></li>
							<% if( userDept != null && ( "dept1".equals(userDept) || "dept2".equals(userDept) || "dept3".equals(userDept) 
									|| "dept4".equals(userDept) || "dept5".equals(userDept) || "dept6".equals(userDept) || "dept10".equals(userDept) || "dept12".equals(userDept) || "dept13".equals(userDept)) || "Y".equals(isAdmin)) { %> 
								<li><a href="../board/labNotice">연구소게시판</a></li>	
							 <% } %>
							<li><a href="../teamNotice/TeamnoticeList">팀공지사항</a></li>
							<li><a href="../QnaNotice/QnaNoticeList">Q&A</a></li>
							<li><a href="../faqNotice/FaqnoticeList">FAQ</a></li>
						</ul>
					</li>
					<% if( isAdmin != null && "Y".equals(isAdmin) ) { %>
					<li class="" id="admin"><a href="../code/groupList">시스템관리</a>
						<ul>
							<li><a href="../code/groupList">코드관리</a></li>
							<li><a href="../user/userList">계정관리</a></li>
							<!--li><a href="../devdocManagement/list">문서이관</a></li-->
							<li><a href="../devdocManagement/adminList">문서이관</a></li>
							<li><a href="../proxy/list">대결자관리</a></li>
							<li><a href="../Reserve/ReserveList">회의실예약</a></li>
							<% if( isAdmin != null && "Y".equals(isAdmin) ) { %>
							<li><a href="../processLine/list">제조공정도</a></li>
							<% } %>
							<li><a href="../selling/list">신제품 매출관리</a></li>
							<!-- <li><a href="../log/loginLog">시스템 로그</a></li> -->
							<li><a href="../AdminReport/userList">계정 리스트</a></li>
							<li><a href="../AdminReport/userLoginLog">접속이력 리스트</a></li>
							<li><a href="../AdminReport/manufacturingProcessDocList">제조공정서 리스트</a></li>
						</ul>
					</li>
					<% } else { %>
					<li class="" id="admin"><a href="../Reserve/ReserveList">관리</a>
						<ul>
							<li><a href="../Reserve/ReserveList">회의실예약</a></li>
							<% if( userGrade != null && ("2".equals(userGrade) || "5".equals(userGrade)) ) { %>
							<li><a href="../proxy/list">대결자관리</a></li>
							<li><a href="../devdocManagement/list">문서이관</a></li>
							<% } %>
							<% if( userDept != null && "dept1".equals(userDept) && "1".equals(userTeam)) { %>
							<li><a href="../selling/list">신제품 매출관리</a></li>
							<% } %>	
							<!--li><a href="../processLine/list">제조공정도</a></li-->
						</ul>
					</li>
					<% } %>
				</ul>
				<ul id="menuDiv" class="main_menu" style=""></ul>
			</div>
		</div>
	</nav>
</header>
<!--header close-->
				<!-- 퀵메뉴 팝업 start-->
				<!-- 퀵메뉴 개인설정 start-->
				<!-- 추후에 삭제되거나 홈아이콘으로 변경될 수 있음 -->
				<div class="cbp-spmenu cbp-spmenu-vertical cbp-spmenu-left" id="cbp-spmenu-s1">
					<h3><span class="title">개인설정</span><span class="right_box"><a href="javascript:resetleftLi();" id="showClose"><img src="../resources/images/btn_quick_close.png" alt="닫기"></a></span></h3>
					<div class="group03 pop"></div>
				</div>
				<!-- 퀵메뉴 개인설정 close-->
				<!-- 퀵메뉴 알림설정 start-->
				<div class="cbp-spmenu cbp-spmenu-vertical cbp-spmenu-left" id="cbp-spmenu-s2">
					<h3><span class="title">알림</span><span class="right_box"><a href="javascript:resetleftLi();" id="showClose2"><img src="../resources/images/btn_quick_close.png" alt="닫기"></a></span></h3>
					<div class="group03 pop" style=" height:100%; ">
						<ul class="pop_notice_con" id="notiList">
						<!-- 알림종류에 따라서 title01/02/03/04 를 사용해주세요  -->
							<li>
								<span class="title01">제품개발문서</span><br/>신선한 생크림빵 문서가 <strong>수정</strong>되었습니다.<span class="icon_new">N</span><br/>


								<span class="date">2019.01.12 02:02:02</span>
							</li>
							<li>
								<span class="title02">제품개발문서</span><br/>신선한 생크림빵 문서가 <strong>수정</strong>되었습니다.<span class="icon_new">N</span><br/>
								<span class="date">2019.01.12 02:02:02</span>
							</li>
							<li>
								<span class="title03">제품개발문서</span><br/>신선한 생크림빵 문서가 <strong>수정</strong>되었습니다.<span class="icon_new">N</span><br/>
								<span class="date">2019.01.12 02:02:02</span>
							</li>
								<li>
								<span class="title04">제품개발문서</span><br/>신선한 생크림빵 문서가 <strong>수정</strong>되었습니다.<span class="icon_new">N</span><br/>
								<span class="date">2019.01.12 02:02:02</span>
							</li>
							<li>
								<span class="title01">제품개발문서</span><br/>신선한 생크림빵 문서가 <strong>수정</strong>되었습니다.<span class="icon_new">N</span><br/>
								<span class="date">2019.01.12 02:02:02</span>
							</li>
							<li>
								<span class="title02">제품개발문서</span><br/>신선한 생크림빵 문서가 <strong>수정</strong>되었습니다.<span class="icon_new">N</span><br/>
								<span class="date">2019.01.12 02:02:02</span>
							</li>
							<li>
								<span class="title03">제품개발문서</span><br/>신선한 생크림빵 문서가 <strong>수정</strong>되었습니다.<span class="icon_new">N</span><br/>
								<span class="date">2019.01.12 02:02:02</span>
							</li>
								<li>
								<span class="title04">제품개발문서</span><br/>신선한 생크림빵 문서가 <strong>수정</strong>되었습니다.<span class="icon_new">N</span><br/>
								<span class="date">2019.01.12 02:02:02</span>
							</li>
							<li>
								<span class="title01">제품개발문서</span><br/>신선한 생크림빵 문서가 <strong>수정</strong>되었습니다.<span class="icon_new">N</span><br/>
								<span class="date">2019.01.12 02:02:02</span>
							</li>
							<li>
								<span class="title02">제품개발문서</span><br/>신선한 생크림빵 문서가 <strong>수정</strong>되었습니다.<span class="icon_new">N</span><br/>
								<span class="date">2019.01.12 02:02:02</span>
							</li>
							<li>
								<span class="title03">제품개발문서</span><br/>신선한 생크림빵 문서가 <strong>수정</strong>되었습니다.<span class="icon_new">N</span><br/>
								<span class="date">2019.01.12 02:02:02</span>
							</li>
								<li>
								<span class="title04">제품개발문서</span><br/>신선한 생크림빵 문서가 <strong>수정</strong>되었습니다.<span class="icon_new">N</span><br/>
								<span class="date">2019.01.12 02:02:02</span>
							
							</li>
							<!-- 기간은 알아서 조정해주세요 -->
							<li><span class="notice_none">알림은 최근 3일치만 제공합니다.</span></li>
							<li><span class="notice_none">등록된 알림이 없습니다.</span></li>

						</ul>
					
				
					
					</div>
				</div>
				<!-- 퀵메뉴 알림설정 close-->
				<!-- 퀵메뉴 테마설정 start-->
				<div class="cbp-spmenu cbp-spmenu-vertical cbp-spmenu-left" id="cbp-spmenu-s3">
					<h3><span class="title">테마설정</span><span class="right_box"><a href="javascript:resetleftLi();" id="showClose3"><img src="../resources/images/btn_quick_close.png" alt="닫기"></a></span></h3>
					<div class="group05 pop">
						<ul class="theme_cont">
							<li>
								<dt>스킨</dt>
								<dd><span class="theme_cont_title">컬러선택</span>
									<ul class="theme_choice">
										<li class="theme_color01"><button onClick="stepchage('theme','theme01');setPersonalization('theme','theme01');" class="btn_theme01"></button></li>
										<li class="theme_color02"><button onClick="stepchage('theme','theme02');setPersonalization('theme','theme02');" class="btn_theme02"></button></li>
										<li class="theme_color03"><button onClick="stepchage('theme','theme03');setPersonalization('theme','theme03');" class="btn_theme03"></button></li>
										<li class="theme_color04"><button onClick="stepchage('theme','theme04');setPersonalization('theme','theme04');" class="btn_theme04"></button></li>
										<li class="theme_color05"><button onClick="stepchage('theme','theme05');setPersonalization('theme','theme05');" class="btn_theme05"></button></li>
									</ul>
						</dd>
					</li>
				<li>
						<dt>인터페이스</dt>
						<dd>
							<span class="theme_cont_title">심플컨텐츠 모드</span>
							<span class="theme_cont_btnbox">
								<button  onClick="stepchage('content_d','content_theme01');setPersonalization('contentMode','content_theme01');" class="btn_cont01"></button><button  onClick="stepchage('content_d','content_theme02');setPersonalization('contentMode','content_theme02');" class="btn_cont02"></button>
								</span>
						<span class="theme_exp">심플 컨텐츠 모드 활성화시, 상하단의 여백을 최소화하여 밀도있는 화면을 지원합니다.</span>
						<span class="exp_img">&nbsp;</span>
	

						
						<hr/>
						<span class="theme_cont_title">화면 최대화</span>
						<span class="theme_cont_btnbox">
								<button  onClick="stepchage('width_wrap','wrap_in01');setPersonalization('widthMode','wrap_in01');"class="btn_extend"></button><button  onClick="stepchage('width_wrap','wrap_in02');setPersonalization('widthMode','wrap_in02');" class="btn_reduce"></button>
								</span>
							<span class="theme_exp">화면 최대화 활성화시, 좌우 여백없이 모니터의 해상도에 맞춰 컨텐츠가 배치됩니다.</span>
						<span class="exp_img02">&nbsp;</span>
						</dd>
					</li>
				
					</ul>
					<!--div class="submit_report"><button class="btn_b_red">요청서 등록</button></div-->
					 </div>
					
				</div>
			<!-- 퀵메뉴 팝업 close-->
 			<!-- 퀵메뉴 start--> 
			<aside>
		 		<section class="quick">
					<ul class="quick_menu">
						<!--a onClick="javascript:;" id="showLeft" class="tooltip" title="개인설정"><li class="select"><dd><img src="../resources/images/icon_quick01.png"></dd><dt></dt></li></a--><!-- 개인설정-->
						<!-- 알림이 있을경우는 dt에 class명 bell02 / 없을경우는 01 -->
						<a onClick="javascript:;" id="showLeft2" class="tooltip" title="알림"><li><dd><img src="../resources/images/icon_quick02.png"></dd><dt id="notiCount" class="bell01">0</dt></li></a><!--알림-->
						<a onClick="javascript:;" id="showLeft3" class="tooltip" title="테마설정"><li><dd><img src="../resources/images/icon_quick03.png"></dd><dt></dt></li></a><!--테마설정-->
						<a href="javascript:openCreateMaterial();" class="tooltip" title="자재생성"><li><dd><img src="../resources/images/icon_quick05.png"></dd><dt></dt></li></a>
						<a href="javascript:openCallMaterial();" class="tooltip" title="자재호출"><li><dd><img src="../resources/images/icon_quick06.png"></dd><dt></dt></li></a>
						<a href="http://30.10.60.45:8080/" target="_blank" class="tooltip" title="구 홈페이지"><li><dd><img src="../resources/images/icon_quick07.png"></dd><dt></dt></li></a><!-- 구 홈페이지-->
						<a href="../user/logout" class="tooltip" title="로그아웃"><li><dd><img src="../resources/images/icon_quick04.png"></dd><dt></dt></li></a><!-- 로그아웃-->
					</ul>
				</section>
			</aside>
			<script src="../../resources/js/classie.js"></script>
			<script>
			$(document).ready(function(){
				console.log('${USER_MENU}');
				setHeaderMenu();
				<% //if( theme != null && !"".equals(theme) ) { %>
					/*stepchage('theme','<%//=theme%>')*/
				<% //} %>
				<%// if( contentMode != null && !"".equals(contentMode) ) { %>
					/*stepchage('content_d','<%//=contentMode%>')*/
				<% //} %>
				<% //if( widthMode != null && !"".equals(widthMode) ) { %>
					/*stepchage('width_wrap','<%//=widthMode%>')*/
				<% //} %>
				var requestPath = "${requestScope['javax.servlet.forward.servlet_path']}";
				console.log('in header.jsp - request url parent: ' + requestPath);
				var count = 0;
				var nodes = $("#main_menu").children();
				nodes.each(function(element_li){
					<% if( isAdmin != null && "Y".equals(isAdmin) ) { %>
					if(requestPath.split('/')[1] == 'design' && count == 0) 
						$(this).prop('class','select');
					else if(requestPath.split('/')[1] == 'dev'  && count == 1)
						$(this).prop('class','select');
					else if(requestPath.split('/')[1] == 'manufacturingNo'  && count == 2)
						$(this).prop('class','select');
					else if(requestPath.split('/')[1] == 'report'  && count == 3)
						$(this).prop('class','select');
					else if(requestPath.split('/')[1] == 'approval'  && count == 4)
						$(this).prop('class','select');
					else if(requestPath.split('/')[1] == 'material'  && count == 5)
						$(this).prop('class','select');
					else if( (requestPath.split('/')[1] == 'adminNotice' || requestPath.split('/')[1] == 'teamNotice'
						|| requestPath.split('/')[1] == 'QnaNotice' || requestPath.split('/')[1] == 'faqNotice')&& count == 6)
						$(this).prop('class','select');
					else if( (requestPath.split('/')[1] == 'code' || requestPath.split('/')[1] == 'user' ||requestPath.split('/')[1] == 'devdocManagement'
						|| requestPath.split('/')[1] == 'proxy' || requestPath.split('/')[1] == 'Reserve' || requestPath.split('/')[1] == 'processLine')&& count == 7)
					$(this).prop('class','select');
					else
					$(this).prop('class','');
					count++;
					<% 
						} else {
					%>
					if(requestPath.split('/')[1] == 'design' && count == 0) 
						$(this).prop('class','select');
					else if(requestPath.split('/')[1] == 'dev'  && count == 1)
						$(this).prop('class','select');
					else if(requestPath.split('/')[1] == 'manufacturingNo'  && count == 2)
						$(this).prop('class','select');
					else if(requestPath.split('/')[1] == 'report'  && count == 3)
						$(this).prop('class','select');
					else if(requestPath.split('/')[1] == 'approval'  && count == 4)
						$(this).prop('class','select');
					else if(requestPath.split('/')[1] == 'material'  && count == 5)
						$(this).prop('class','select');
					else if( (requestPath.split('/')[1] == 'adminNotice' || requestPath.split('/')[1] == 'teamNotice'
						|| requestPath.split('/')[1] == 'QnaNotice' || requestPath.split('/')[1] == 'faqNotice')&& count == 6)
						$(this).prop('class','select');
					else if( (requestPath.split('/')[1] == 'code' || requestPath.split('/')[1] == 'user' ||requestPath.split('/')[1] == 'devdocManagement'
						|| requestPath.split('/')[1] == 'proxy' || requestPath.split('/')[1] == 'Reserve' || requestPath.split('/')[1] == 'processLine')&& count == 7)
					$(this).prop('class','select');
					else
					$(this).prop('class','');
					count++;
					<%
						}
					%>
					
				});				
				loadNotificationCount();
				setInterval(loadNotificationCount, 300000);
				/*[document.getElementsByClassName('main_menu')[0].children].forEach(function(element_li){
					//console.log('몇번호출되려나' + element_li.className);
					//element_li.className = '';
					alert(count);
					$(this).prop('class','');
					count++;
				});*/
				
				/*
				if(requestPath.split('/')[1] == 'design')
					[document.getElementsByClassName('main_menu')[0].children][0].prop('class','');
					//[document.getElementsByClassName('main_menu')[0].children][0].className = 'select';					
				if(requestPath.split('/')[1] == 'dev')
					[document.getElementsByClassName('main_menu')[0].children][1].prop('class','');
					//[document.getElementsByClassName('main_menu')[0].children][1].className = 'select';
				if(requestPath.split('/')[1] == 'report')
					[document.getElementsByClassName('main_menu')[0].children][2].prop('class','');
					//[document.getElementsByClassName('main_menu')[0].children][2].className = 'select';
				if(requestPath.split('/')[1] == 'approval')
					[document.getElementsByClassName('main_menu')[0].children][3].prop('class','');
					//[document.getElementsByClassName('main_menu')[0].children][3].className = 'select';
				if(requestPath.split('/')[1] == 'material')
					[document.getElementsByClassName('main_menu')[0].children][4].prop('class','');
					//[document.getElementsByClassName('main_menu')[0].children][4].className = 'select';
				*/
				
				 $('.tooltip').tooltipster({
					    theme: 'tooltipster-light',
					    side : 'right'
				 });
			});	
			//window.onload = function(){
			//}
			/*var menuLeft = document.getElementById( 'cbp-spmenu-s1' ),
				menuClose = document.getElementById( 'cbp-spmenu-s1' ),
				menuLeft2 = document.getElementById( 'cbp-spmenu-s2' ),
				menuClose2 = document.getElementById( 'cbp-spmenu-s2' )
				menuLeft3 = document.getElementById( 'cbp-spmenu-s3' ),
				menuClose3 = document.getElementById( 'cbp-spmenu-s3' )
				
				body = document.body;
	
			showLeft.onclick = function() {
				classie.toggle( this, 'active' );
				classie.toggle( menuLeft, 'cbp-spmenu-open' );
			
			};showClose.onclick = function() {
				classie.toggle( this, 'active' );
				classie.toggle( menuClose, 'cbp-spmenu-open' );
			
			};
			
			showLeft2.onclick = function() {
				loadNotificationList();
				classie.toggle( this, 'active' );
				classie.toggle( menuLeft2, 'cbp-spmenu-open' );
			};
			showClose2.onclick = function() {
				classie.toggle( this, 'active' );
				classie.toggle( menuClose2, 'cbp-spmenu-open' );
				
			};
			showLeft3.onclick = function() {
				classie.toggle( this, 'active' );
				classie.toggle( menuLeft3, 'cbp-spmenu-open' );
			
			};
			showClose3.onclick = function() {
				classie.toggle( this, 'active' );
				classie.toggle( menuClose3, 'cbp-spmenu-open' );
				
			};
			*/
			function setPersonalization(type,value) {
				var URL = "../user/setPersonalizationAjax";
				$.ajax({
					type:"POST",
					url:URL,
					data:{
						"type" : type,
						"value" : value
					},
					dataType:"json",
					success:function(data) {
						
					},
					error:function(request, status, errorThrown){
					}			
				});	
			}
			
			function loadNotificationCount() {
				var URL = "../common/notificationCountAjax";
				var requestPath = "${requestScope['javax.servlet.forward.servlet_path']}";
				$.ajax({
					type:"POST",
					url:URL,
					data:{
					},
					dataType:"json",
					success:function(data) {
						if( data.notiCount > 0 ) {
							$("#notiCount").html(data.notiCount);
							$("#notiCount").prop('class','bell02');
							if(requestPath.split('/')[1] == 'main'){
								$("#main_bell").html(data.notiCount);
								$("#main_bell").prop('class','bell02');
							}
						} else {
							$("#notiCount").html("0");
							$("#notiCount").prop('class','bell01');
							if(requestPath.split('/')[1] == 'main'){
								$("#main_bell").html("0");
								$("#main_bell").prop('class','bell01');
							}
						}
					},
					error:function(request, status, errorThrown){
						$("#notiCount").html("0");
						$("#notiCount").prop('class','bell01');
						if(requestPath.split('/')[1] == 'main'){
							$("#main_bell").html("0");
							$("#main_bell").prop('class','bell01');
						}
					}			
				});	
			}
			
			function loadNotificationList() {
				var URL = "../common/notificationListAjax";
				$.ajax({
					type:"POST",
					url:URL,
					data:{
					},
					dataType:"json",
					success:function(data) {
						var list = data;
						var html = "";
						$("#notiList").html(html);
						if( list.length > 0 ) {
							var nIdArray = new Array();
							list.forEach(function (item) {
								html += "<li>";
								html += "	<span class=\"title"+item.type+"\">"+item.typeText+"</span><br/>";
								html += "	"+item.message;
								if( item.isRead == 'N' ) {
									html += "	<span class=\"icon_new\">N</span><br/>";
									nIdArray.push(item.nId);
								} else {
									html += "	<span class=\"icon_new\"></span><br/>";
								}
								html += "	<span class=\"date\">"+item.regDate+"</span>";
								html += "</li>";
								
							});
							html += "<li><span class=\"notice_none\">알림은 최근 3일치만 제공합니다.</span></li>";
							$("#notiList").html(html);
							updateNotificationData(nIdArray);
						} else {
							html += "<li><span class=\"notice_none\">알림은 최근 3일치만 제공합니다.</span></li>";
							html += "<li><span class=\"notice_none\">등록된 알림이 없습니다.</span></li>";
							$("#notiList").html(html);
						}
					},
					error:function(request, status, errorThrown){
						var html = "";
						$("#notiList").html("");
						html += "<li><span class=\"notice_none\">오류가 발생하였습니다.</span></li>";
						html += "<li><span class=\"notice_none\">알림은 최근 3일치만 제공합니다.</span></li>";
						html += "<li><span class=\"notice_none\">등록된 알림이 없습니다.</span></li>";
						$("#notiList").html(html);
					}			
				});	
			}
			
			function updateNotificationData(nIdArray) {
				var URL = "../common/updateNotificationAjax";
				$.ajax({
					type:"POST",
					url:URL,
					data:{
						"nId":nIdArray
					},
					traditional : true,
					dataType:"json",
					success:function(data) {
						loadNotificationCount();
					},
					error:function(request, status, errorThrown){
						
					}			
				});	
			}
			
			function openCreateMaterial() {
				openDialog('createMaterial');
				$("#mat_name").val("[임시]");
				$("#mat_sapCode").val("");
				$("mat_company").removeOption(/./);
				loadMatCompany('mat_company');
				$("#mat_company").selectOptions("");
				$("#mat_plant").removeOption(/./);
				$("#mat_plant").selectOptions("");
				$("#mat_price").val("");
				loadMatUnit();
				$("mat_unit").selectOptions("");
				$("input:radio[name='mat_type'][value='B']").prop('checked', true);
				$("#mat_create").show();
				$("#mat_update").hide();
			}
			
			function closeCreateMaterial() {
				closeDialog('createMaterial');
				matClear();
			} 
			
			function openCallMaterial() {
				matClear();
				openDialog('callMaterial');
				loadMatCompany('mat_company2');
			}
			
			function closeCallMaterial() {
				closeDialog('callMaterial');
				matClear();
			} 
			
			function loadMatCompany(selectBoxId) {
				var URL = "../common/companyListAjax";
				$.ajax({
					type:"POST",
					url:URL,
					data:{
					},
					dataType:"json",
					async:false,
					success:function(data) {
						var list = data.RESULT;
						$("#"+selectBoxId).removeOption(/./);
						$("#"+selectBoxId).addOption("", "전체", false);
						$.each(list, function( index, value ){ //배열-> index, value
							$("#"+selectBoxId).addOption(value.companyCode, value.companyName, false);
						});
					},
					error:function(request, status, errorThrown){
							alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
					}			
				});
			}
			function loadMatUnit() {
				var URL = "../common/unitListAjax";
				$.ajax({
					type:"POST",
					url:URL,
					data:{
						
					},
					dataType:"json",
					async:false,
					success:function(data) {
						var list = data;
						$("#mat_unit").removeOption(/./);
						$("#mat_unit").addOption("", "전체", false);
						$.each(list, function( index, value ){ //배열-> index, value
							$("#mat_unit").addOption(value.unitCode, value.unitName, false);
						});
					},
					error:function(request, status, errorThrown){
							alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
					}			
				});
			}
			
			function matCompanyChange(companySelectBoxId, selectBoxId) {
				var URL = "../common/plantListAjax";
				$.ajax({
					type:"POST",
					url:URL,
					data:{
						"companyCode" : $("#"+companySelectBoxId).selectedValues()[0]
					},
					dataType:"json",
					async:false,
					success:function(data) {
						var list = data.RESULT;
						$("#"+selectBoxId).removeOption(/./);
						$("#"+selectBoxId).addOption("", "전체", false);
						$.each(list, function( index, value ){ //배열-> index, value
							$("#"+selectBoxId).addOption(value.plantCode, value.plantName, false);
						});
						
					},
					error:function(request, status, errorThrown){
							alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
					}			
				});
			}
			
			//입력확인
			function goMatInsert(){
				if( !chkNull($("#mat_name").val()) || $("#mat_name").val() == "[임시]" ) {
					alert("자재명을 입력하여 주세요.");
					$("#mat_name").focus();
					return;
				} else if ($("#mat_name").val().indexOf("[임시]") == -1) {
					alert("자재명은 [임시]를 포함해야 합니다.");
					$("#mat_name").val("[임시]"+$("#mat_name").val());
					$("#mat_name").focus();			
					return;
				} else if( !chkNull($("#mat_sapCode").val()) ) {
					alert("SAP 코드를 입력하여 주세요.");
					$("#mat_sapCode").focus();
					return;
				} else if( $("#mat_company").selectedValues()[0] == '' ) {
					alert("회사를 선택하여 주세요.");
					$("#mat_company").focus();
					return;
				} else if( $("#mat_plant").selectedValues()[0] == '' ) {
					alert("공장을 선택하여 주세요.");
					$("#mat_plant").focus();
					return;
				} else if( !chkNull($("#mat_price").val()) ) {
					alert("단가를 입력하여 주세요.");
					$("#mat_price").focus();
					return;
				} else if( $("#mat_unit").selectedValues()[0] == '' ) {
					alert("단위를 선택하여 주세요.");
					$("#mat_unit").focus();
					return;
				} else {
					var URL = "../material/materialCountAjax";
					$.ajax({
						type:"POST",
						url:URL,
						data:{"sapCode":$("#mat_sapCode").val(),
							"company": $("#mat_company").selectedValues()[0],
							"plant": $("#mat_plant").selectedValues()[0]
						},
						dataType:"json",
						success:function(result) {
							if( result.RESULT >= 1) {
								alert("이미 존재하는 SAP코드입니다.");
							    return;
							} else {
								URL = "../material/insertAjax";
								$.ajax({
									type:"POST",
									url:URL,
									data:{"name":$("#mat_name").val() , "sapCode":$("#mat_sapCode").val(),
										"company": $("#mat_company").selectedValues()[0],"plant": $("#mat_plant").selectedValues()[0],
										"price": $("#mat_price").val(),"unit": $("#mat_unit").selectedValues()[0],
										"type": $(":input:radio[name=mat_type]:checked").val()						
									},
									dataType:"json",
									success:function(result) {
										if(result.status == 'success'){
								        	alert("생성되었습니다.");	
								        	matClear();
								        	closeDialog("createMaterial");					        	
								        } else if( result.status == 'fail' ){
											alert(result.msg);
								        } else {
								        	alert("오류가 발생하였습니다.");
								        }
									},
									error:function(request, status, errorThrown){
										alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
									}			
								});	
							}
						},
						error:function(request, status, errorThrown){
							alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
						}			
					});	
				}
			}
			
			function goMatRfcCall(){
				if(  !chkNull($("#mat_company2").selectedValues()[0]) ) {
					alert("회사를 선택해 주세요.");
					$("#mat_company2").focus();
					return;
				} else if( !chkNull($("#mat_sapCode2").val()) ) {
					alert("자재코드 입력하여 주세요.");
					$("#mat_sapCode2").focus();
					return;
				} else {
					$('#lab_loading').show();
					var URL = "../material/rfcCallAjax";
					$.ajax({
						type:"POST",
						url:URL,
						data:{"company":$("#mat_company2").selectedValues()[0], "sapCode":$("#mat_sapCode2").val()},
						dataType:"json",
						async:false,
						success:function(result) {
							if(result.status == 'success'){
								alert(result.msg);
								closeCallMaterial();
					        } else if( result.status == 'fail' ){
								alert(result.msg);
					        } else {
					        	alert("오류가 발생하였습니다.");
					        }
							$('#lab_loading').hide();
						},
						error:function(request, status, errorThrown){
							alert("오류가 발생하였습니다.\n다시 시도하여 주세요.");
							$('#lab_loading').hide();
						}			
					});	
				}
			}
			
			function matClear() {
				$("#mat_name").val("[임시]");
				$("#mat_sapCode").val(""),
				$("#mat_company_label").html("선택");
				$("#mat_company").selectOptions("");
				$("#mat_plant_label").html("선택");
				$("#mat_plant").selectOptions("");
				$("#mat_price").val("");
				$("#mat_unit_label").html("선택");
				$("#mat_unit").selectOptions("");
				$("#mat_sapCode2").val("");
				$("#mat_company2_label").html("선택");
				$("#mat_company2").selectOptions("");
			}

			// 개인설정 팝업 호출
			$('#showLeft').click(function(){
				// 초기화
				resetleftLi();
				$(this).addClass('active');
				$('#cbp-spmenu-s1').addClass('cbp-spmenu-open');
			});

			// 알림 팝업 호출
			$('#showLeft2').click(function(){
				// 초기화
				resetleftLi();
				loadNotificationList();
				$(this).addClass('active');
				$('#cbp-spmenu-s2').addClass('cbp-spmenu-open');
			});

			// 전화요청 작성 팝업 호출
			$('#showLeft3').click(function(){
				// 초기화
				resetleftLi();
				$(this).addClass('active');
				$('#cbp-spmenu-s3').addClass('cbp-spmenu-open');
			});
			
			// left 팝업 리셋
			function resetleftLi(){
				$('.quick_menu li').each(function(){
					$(this).removeClass('select');
				});
				$('.quick_menu a').each(function(){
					$(this).removeClass('active');
				});

				if($('#cbp-spmenu-s1').hasClass('cbp-spmenu-open')){
					$('#cbp-spmenu-s1').removeClass('cbp-spmenu-open');
				}
				if($('#cbp-spmenu-s2').hasClass('cbp-spmenu-open')){
					$('#cbp-spmenu-s2').removeClass('cbp-spmenu-open');
				}
				if($('#cbp-spmenu-s3').hasClass('cbp-spmenu-open')){
					$('#cbp-spmenu-s3').removeClass('cbp-spmenu-open');
				}
			}
			
			function setHeaderMenu(){
				var USER_MENU = '${USER_MENU}'; // 로그인 시 session에 저장되어있는 메뉴목록 (JSON형식 String)
				var userMenuList = JSON.parse(USER_MENU);
				
				userMenuList.forEach(function(menu){
					var menuCode = menu.menuId;
					var depth = menu.level;
					var url = menu.url;
					var name = menu.menuName;
					var sortOrder = menu.displayOrder;
					
					if(depth == 1){
						var parent_li_a = document.createElement("a");
						parent_li_a.setAttribute("href", url);
						// parent_li_a.appendChild(name);
						parent_li_a.innerText = name;

						var parent_li = document.createElement("li");
						parent_li.appendChild(parent_li_a);
						
						// var childMenuList = userMenuList.filter(childMenu => menuCode == childMenu.PARENT_CODE);
						var childMenuList = userMenuList.filter(function(childMenu){
							return (menuCode == childMenu.pMenuId);
						});

						if(childMenuList.length > 0){
							var child_ul = document.createElement("ul");
							// childMenuList.map( childMenu => {
							childMenuList.map(function(childMenu){
								var child_li_a = document.createElement("a");
								child_li_a.setAttribute("href", childMenu.url);
								// child_li_a.appendChild(childMenu.MENU_NAME);
								child_li_a.innerText = childMenu.menuName;

								var child_li = document.createElement("li");
								child_li.appendChild(child_li_a);
								
								child_ul.appendChild(child_li);
							} )
							parent_li.appendChild(child_ul);
						}
						
						var menuDiv = document.getElementById("menuDiv")
						menuDiv.appendChild(parent_li);
					}
				});
			}
		</script>
<!-- 자재 생성레이어 start-->
<div class="white_content" id="createMaterial">
	<div class="modal" style="	width: 700px;margin-left:-350px;height: 420px;margin-top:-200px;">
		<h5 style="position:relative">
			<span class="title">자재 생성</span>
			<div  class="top_btn_box">
				<ul>
					<li>
						<button class="btn_madal_close" onClick="closeCreateMaterial()"></button>
					</li>
				</ul>
			</div>
		</h5>
		<div class="list_detail">
			<ul>
				<li class="pt10">
					<dt>자재명</dt>
					<dd>
						<input type="text" class="req" style="width:302px;" name="mat_name" id="mat_name" value="[임시]" /> [임시] 로 시작될 수 있도록 입력 
					</dd>
				</li>
				<li>
					<dt>SAP 코드</dt>
					<dd>
						<input type="text"  style="width:302px;" class="req" name="mat_sapCode" id="mat_sapCode" placeholder="임시코드 5자리를 입력해주세요"/>
					</dd>
				</li>
				<li>
					<dt>공장</dt>
					<dd>
						<div class="selectbox req" style="width:147px;">  
							<label for="mat_company" id="mat_company_label"> 선택</label> 
							<select id="mat_company" name="mat_company" onChange="matCompanyChange('mat_company','mat_plant')">
							</select>
						</div>
						<div class="selectbox req ml5" style="width:147px;">  
							<label for="mat_plant" id="mat_plant_label"> 선택</label> 
							<select id="mat_plant" name="mat_plant">
							</select>
						</div>
					</dd>
				</li>
				<li>
					<dt>단가</dt>
					<dd>
						<input type="text" class="req" style="width:149px;" name="mat_price" id="mat_price">
					</dd>
				</li>
				<li>
					<dt>단위</dt>
					<dd>
						<div class="selectbox req" style="width:147px;">  
							<label for="mat_unit" id="mat_unit_label"> 선택</label> 
							<select id="mat_unit" id="mat_unit">
							</select>
						</div>
					</dd>
				</li>
				<li>
					<dt>구분</dt>
					<dd>
						<input type="radio" name="mat_type" id="mat_type1" value="B" checked/ ><label for="mat_type1"><span></span>원료</label>
						<input type="radio" name="mat_type" id="mat_type2" value="R"/><label for="mat_type2"><span></span>재료</label>
					</dd>
				</li>
			</ul>
		</div>
		<div class="btn_box_con">
			<button class="btn_admin_red" id="mat_create" onclick="javascript:goMatInsert();">자재 생성</button> 
			<button class="btn_admin_red" id="mat_update" onclick="javascript:goMatUpdate();" style="display:none">자재 수정</button>
			<button class="btn_admin_gray" onclick="closeCreateMaterial()"> 취소</button>
		</div>
	</div>
</div>
<!-- 자재 생성레이어 close-->
<!-- 자재 호출레이어 start-->
<div class="white_content" id="callMaterial">
	<div class="modal" style="	width: 500px;margin-left:-250px;height: 300px;margin-top:-150px;">
		<h5 style="position:relative">
			<span class="title">자재 호출</span>
			<div  class="top_btn_box">
				<ul>
					<li>
						<button class="btn_madal_close" onClick="closeCallMaterial();"></button>
					</li>
				</ul>
			</div>
		</h5>
		<div class="list_detail">
			<ul>
				<li class="pt10">
					<dt>회사명</dt>
					<dd>
						<div class="selectbox req" style="width:147px;">  
							<label for="mat_company2" id="mat_company2_label"> 선택</label> 
							<select id="mat_company2" name="mat_company2">
							</select>
						</div> 
					</dd>
				</li>
				<li>
					<dt>자재코드</dt>
					<dd>
						<input type="text"  style="width:302px;" class="req" name="mat_sapCode2" id="mat_sapCode2" onKeyPress="if(window.event.keyCode == 13) { goMatRfcCall();}" />
					</dd>
				</li>
			</ul>
		</div>
		<div class="btn_box_con">
			<button class="btn_admin_red"onclick="javascript:goMatRfcCall();">적용</button> 
			<button class="btn_admin_gray"onclick="closeCallMaterial();"> 취소</button>
		</div>
	</div>
</div>
<!-- 자재 호출 레이어 close-->	