<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.aspn.util.*" %>    
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
%>    
<header>
	<nav>
		<div class="main_nav" id="topBar">
			<div  class="menu_position01">
				<!--로고-->
				<a href="../main/main"><h1></h1></a>
				<!-- 추후 수정될 가능성 높음/ 메뉴가 많아질경우 테마 조정 필요 -->
				<ul class="main_menu" id="main_menu">
				<% if( userTeam != null && "6".equals(userTeam) || "8".equals(userTeam) || "10".equals(userTeam) ) { 
						if( userGrade != null && "6".equals(userGrade) ) {
				%>
					<li class="" id="dev">
						<a href="/dev/productDevDocList">제품개발</a>
						<ul>
							<li><a href="/dev/productDevDocList">제품개발문서</a></li>
							<li><a href="/trialReport/trialReportList">시생산결과보고서</a></li>
						</ul>
					</li>
					<li class="" id="manufacturingNo">
	                  <a href="../manufacturingNo/dbList">품목제조보고서</a>
	                  <ul>
	                      <li><a href="../manufacturingNo/dbList">품목제조보고서 DB</a></li>
		                  <li><a href="../manufacturingNo/statusList2">품목제조보고서 현황</a></li>
	                  </ul>
	               </li>
					<li class="" id="approval"><a href="../approval/approvalList">결재함</a></li>
					<li class="" id="material"><a href="../material/list">자재관리</a></li>
					<li class="" id="notice"><a href="../adminNotice/noticeList">게시판</a>
						<ul>
							<li><a href="../adminNotice/noticeList">관리자공지</a></li>
							<li><a href="../teamNotice/TeamnoticeList">팀공지사항</a></li>
							<li><a href="../QnaNotice/QnaNoticeList">Q&A</a></li>
							<li><a href="../faqNotice/FaqnoticeList">FAQ</a></li>
						</ul>
					</li>
				<%			
						} else {
				%>
					<li class="" id="dev">
						<a href="/dev/productDevDocList">제품개발</a>
						<ul>
							<li><a href="/dev/productDevDocList">제품개발문서</a></li>
							<li><a href="/trialReport/trialReportList">시생산결과보고서</a></li>
						</ul>
					</li>
					<li class="" id="manufacturingNo">
	                  <a href="../manufacturingNo/dbList">품목제조보고서</a>
	                  <ul>
	                      <li><a href="../manufacturingNo/dbList">품목제조보고서 DB</a></li>
		                  <li><a href="../manufacturingNo/statusList2">품목제조보고서 현황</a></li>
	                  </ul>
	              	</li>
	              	<li class="" id="approval"><a href="../approval/approvalList">결재함</a></li>
					<li class="" id="material"><a href="../material/list">자재관리</a></li>
					<li class="" id="notice"><a href="../adminNotice/noticeList">게시판</a>
						<ul>
							<li><a href="../adminNotice/noticeList">관리자공지</a></li>
							<li><a href="../teamNotice/TeamnoticeList">팀공지사항</a></li>
							<li><a href="../QnaNotice/QnaNoticeList">Q&A</a></li>
							<li><a href="../faqNotice/FaqnoticeList">FAQ</a></li>
						</ul>
					</li>
				<%			
						}
				%>
					
				<% } else { %>
					<li class="" id="dev">
						<a href="/dev/productDevDocList">제품개발</a>
						<ul>
							<li><a href="/dev/productDevDocList">제품개발문서</a></li>
							<li><a href="/trialReport/trialReportList">시생산결과보고서</a></li>
						</ul>
					</li>
					<!-- <li class="" id="manufacturingNo"><a href="../manufacturingNo/list">품목제조보고서</a></li> -->
					<li class="" id="approval"><a href="../approval/approvalList">결재함</a></li>
					<li class="" id="notice"><a href="../adminNotice/noticeList">게시판</a>
						<ul>
							<li><a href="../adminNotice/noticeList">관리자공지</a></li>
							<li><a href="../teamNotice/TeamnoticeList">팀공지사항</a></li>
							<li><a href="../QnaNotice/QnaNoticeList">Q&A</a></li>
							<li><a href="../faqNotice/FaqnoticeList">FAQ</a></li>
						</ul>
					</li>
				<% }  %>
				</ul>
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
						<!-- 알림종류에 따라서 title01/02/03/04 를 사용해주세요 -->
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
					<ul>
						<!--a onClick="javascript:;" id="showLeft" class="tooltip" title="개인설정"><li class="select"><dd><img src="../resources/images/icon_quick01.png"></dd><dt></dt></li></a--><!-- 개인설정-->
						<!-- 알림이 있을경우는 dt에 class명 bell02 / 없을경우는 01 -->
						<a onClick="javascript:;" id="showLeft2" class="tooltip" title="알림"><li><dd><img src="../resources/images/icon_quick02.png"></dd><dt id="notiCount" class="bell01">0</dt></li></a><!--알림-->
						<a onClick="javascript:;" id="showLeft3" class="tooltip" title="테마설정"><li><dd><img src="../resources/images/icon_quick03.png"></dd><dt></dt></li></a><!--테마설정-->
						<a href="http://30.10.60.45:8080/" target="_blank" class="tooltip" title="구 홈페이지"><li><dd><img src="../resources/images/icon_quick07.png"></dd><dt></dt></li></a><!-- 구 홈페이지-->
						<a href="../user/logout" class="tooltip" title="로그아웃"><li><dd><img src="../resources/images/icon_quick04.png"></dd><dt></dt></li></a><!-- 로그아웃-->
					</ul>
				</section>
			</aside>
			<script src="../../resources/js/classie.js"></script>
			<script>
			$(document).ready(function(){
				<% if( theme != null && !"".equals(theme) ) { %>
					stepchage('theme','<%=theme%>')
				<% } %>
				<% if( contentMode != null && !"".equals(contentMode) ) { %>
					stepchage('content_d','<%=contentMode%>')
				<% } %>
				<% if( widthMode != null && !"".equals(widthMode) ) { %>
					stepchage('width_wrap','<%=widthMode%>')
				<% } %>
				var requestPath = "${requestScope['javax.servlet.forward.servlet_path']}";
				console.log('in header.jsp - request url parent: ' + requestPath);
				var count = 0;
				var nodes = $("#main_menu").children();
				nodes.each(function(element_li){
					<% if( userTeam != null && "6".equals(userTeam)|| "8".equals(userTeam) || "10".equals(userTeam) ) { 
						if( userGrade != null && "6".equals(userGrade) ) {
					%>
					if(requestPath.split('/')[1] == 'dev'  && count == 0)
						$(this).prop('class','select');
					else if(requestPath.split('/')[1] == 'manufacturingNo'  && count == 1)
						$(this).prop('class','select');
					else if(requestPath.split('/')[1] == 'approval'  && count == 2)
						$(this).prop('class','select');					
					else if(requestPath.split('/')[1] == 'material'  && count == 3)
						$(this).prop('class','select');					
					else if( (requestPath.split('/')[1] == 'adminNotice' || requestPath.split('/')[1] == 'teamNotice'
						|| requestPath.split('/')[1] == 'QnaNotice' || requestPath.split('/')[1] == 'faqNotice')&& count == 4)
						$(this).prop('class','select');
					else
					$(this).prop('class','');	
					<%
						} else {
					%>
					if(requestPath.split('/')[1] == 'dev'  && count == 0)
						$(this).prop('class','select');
					else if(requestPath.split('/')[1] == 'manufacturingNo'  && count == 1)
						$(this).prop('class','select');
					else if(requestPath.split('/')[1] == 'material'  && count == 2)
						$(this).prop('class','select');
					else if( (requestPath.split('/')[1] == 'adminNotice' || requestPath.split('/')[1] == 'teamNotice'
						|| requestPath.split('/')[1] == 'QnaNotice' || requestPath.split('/')[1] == 'faqNotice')&& count == 3)
						$(this).prop('class','select');
					else
					$(this).prop('class','');
					<%
					 	}						
					  } else {
					%>
					if(requestPath.split('/')[1] == 'dev'  && count == 0)
						$(this).prop('class','select');
					//else if(requestPath.split('/')[1] == 'manufacturingNo'  && count == 1)
					//	$(this).prop('class','select');
					else if(requestPath.split('/')[1] == 'approval'  && count == 1)
						$(this).prop('class','select');		
					else if( (requestPath.split('/')[1] == 'adminNotice' || requestPath.split('/')[1] == 'teamNotice'
						|| requestPath.split('/')[1] == 'QnaNotice' || requestPath.split('/')[1] == 'faqNotice')&& count == 2)
						$(this).prop('class','select');
					else
					$(this).prop('class','');
					<%
					  }
					 %>
					
					count++;
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
			/*
			var menuLeft = document.getElementById( 'cbp-spmenu-s1' ),
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
		</script>