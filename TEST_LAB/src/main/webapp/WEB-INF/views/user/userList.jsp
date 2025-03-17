<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ page session="false" %>
<title>사용자 관리</title>
<script type="text/javascript">
	$(document).ready(function(){
		getUserList('1');
		
		bindSearchEnter('searchValue');
	});
	
	function bindSearchEnter(elementId){
		document.getElementById(elementId).addEventListener("keydown", function(e){
			if(e.keyCode == 13)
				getUserList(1);
		})
	}
	
	//사용자권한관리 리스트 ajax
	function getUserList(pageNo){
		$.ajax({
			type: 'POST',
			url: '../user/userListAjax',
			data: {
				searchValue : $("#searchValue").val(),
				deptCode : $("#dept").selectedValues()[0],
				teamCode : $("#team").selectedValues()[0],
				userGrade : $("#grade").selectedValues()[0],
				pageNo : pageNo
			},
			dataType: 'json',
			async : true,
			success: function (data) {
				if(data.resultCd == 'F'){
					alert("리스트 로딩 중 오류 발생");
					return;
				}
				var html = '';
				data.list.forEach(function (item) {
					if(item.isDelete == 'Y'){
						html += "<tr class='m_visible'>"
					} else {
						html += "<tr>"
					}
					
					html += "	<td>"+item.userName+"</td>";
					html += "	<td>"+item.userId+"</td>";
					html += "	<td>"+nvl(item.userGradeName,'')+"</td>";
					html += "	<td>"+nvl(item.deptCodeName,'')+"</td>";
					html += "	<td>"+nvl(item.teamCodeName,'')+"</td>";
					if( item.isAdmin == 'Y' ) {
						html += "	<td>관리자</td>";
					} else {
						html += "	<td>&nbsp;</td>";
					}
					if( item.isLock == 'Y' ) {
						html += "	<td>잠김</td>";
					} else {
						html += "	<td>&nbsp;</td>";
					}
					html += "	<td>"+item.regDate+"</td>";
					html += "	<td>";
					html += "		<ul class=\"list_ul\">";
					html += "		<li><button class=\"btn_doc\" onClick=\"javascript:updateUser('"+item.userId+"')\"><img src=\"/resources/images/icon_doc03.png\">수정</button></li>";
					
					if(item.isDelete != 'Y'){
						html += "		<li><button class=\"btn_doc\" onClick=\"javascript:deleteUser('"+item.userId+"')\"><img src=\"/resources/images/icon_doc04.png\">퇴직처리</button></li>";
					} else {
						html += "		<li><button class=\"btn_doc\" onClick=\"javascript:restoreUser('"+item.userId+"')\"><img src=\"/resources/images/icon_doc17.png\">재직처리</button></li>";
					}
					
					if( item.isDelete != 'Y' && item.isLock == 'Y' ){
						html += "		<li><button class=\"btn_doc\" onClick=\"javascript:unlockUser('"+item.userId+"')\"><img src=\"/resources/images/icon_unlock.png\">잠금해제</button></li>";	
					}
					
					html += "		</ul>";
					//html += "		<button type=\"button\" class=\"btn_table_nomal\" onClick=\"javascript:updateUser('"+item.userId+"')\">수정</button>"; 
					//html += "		<button type=\"button\" class=\"btn_table_gray\" onClick=\"javascript:deleteUser('"+item.userId+"')\"><img src=\"../resources/images/icon_del.png\"> 퇴직처리</button>";
					html += "	</td>";
					html += "</tr>"					
				});
				
				$('#userList').html(html);
				//페이징
				$('.page_navi').html(data.navi.prevBlock+data.navi.pageList+data.navi.nextBlock);
				$('#pageNo').val(data.navi.pageNo);
			},error: function(XMLHttpRequest, textStatus, errorThrown){
				alert('리스트 로딩 중 오류가 발생 하였습니다. 잠시 후 다시 시도 해주십시오.\n' +'errorCode : ' + textStatus );
				submitBool = true;
			}
		});
	}
	// 페이징
	function paging(pageNo){
		getUserList(pageNo);
	}	
	
	//파라미터 조회
	function getParam(pageNo){
		PARAM.pageNo = pageNo || '${paramVO.pageNo}';
		return $.param(PARAM);
	}
	
	//사용자 등록 페이지 이동
	function insertUser(){
		window.location.href="../user/insertForm2";
	}
	
	//사용자 등록 페이지 이동
	function insertUser2(){
		window.location.href="../user/insertForm";
	}
	
	//사용자 수정 페이지 이동
	function updateUser(userId){
		window.location.href="../user/updateForm?userId="+userId+"&pageNo="+$('#pageNo').val();
	}
	
	//퇴직처리
	function deleteUser(userId){
		$.ajax({
			type: 'POST',
			url: '../user/delete?userId='+userId,
			dataType: 'json',
			async : true,
			success: function (data) {
				if(data.resultCd == 'F'){
					alert("사용자 퇴직처리 실패");
					return;
				} else {
					alert("사용자 퇴직처리 성공");
					//window.location.reload();
					paging();
				}
			},error: function(XMLHttpRequest, textStatus, errorThrown){
				alert('작업 중 오류가 발생 하였습니다. 잠시 후 다시 시도 해주십시오.\n' +'errorCode : ' + textStatus );
				submitBool = true;
			}
		});
	}
	
	//재적처리
	function restoreUser(userId){
		$.ajax({
			type: 'POST',
			url: '../user/restore?userId='+userId,
			dataType: 'json',
			async : true,
			success: function (data) {
				if(data.resultCd == 'F'){
					alert("사용자 재직처리 실패");
					return;
				} else {
					alert("사용자 재직처리 성공");
					//window.location.reload();
					paging();
				}
			},error: function(XMLHttpRequest, textStatus, errorThrown){
				alert('작업 중 오류가 발생 하였습니다. 잠시 후 다시 시도 해주십시오.\n' +'errorCode : ' + textStatus );
				submitBool = true;
			}
		});
	}
	
	// 사용자 잠금해제
	function unlockUser(userId){
		$.ajax({
			type: 'POST',
			url: '../user/unlock?userId='+userId,
			dataType: 'json',
			async : true,
			success: function (data) {
				if(data.resultCd == 'F'){
					alert("사용자 잠금해제 실패");
					return;
				} else {
					alert("사용자 잠금해제를 성공하였습니다.");
					//window.location.reload();
					paging();
				}
			},error: function(XMLHttpRequest, textStatus, errorThrown){
				alert('처리중 오류가 발생 하였습니다. 잠시 후 다시 시도 해주십시오.\n' +'errorCode : ' + textStatus );
				submitBool = true;
			}
		});
	}
	
	function goClear() {
		$("#searchValue").val("");
		$("#dept").selectOptions("");
		$("#team").selectOptions("");
		$("#grade").selectOptions("");
		$("#deptL").html("부서");
		$("#teamL").html("팀");
		$("#gradeL").html("권한");
		getUserList('1');
	}
	
	function goSearch() {
		getUserList('1');
	}

</script>
<input type="hidden" name="pageNo" id="pageNo" value="${paramVO.pageNo}">
<div class="wrap_in" id="fixNextTag">
	<span class="path">
		사용자관리&nbsp;&nbsp;<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;
		관리자&nbsp;&nbsp;<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;
		<a href="#">${strUtil:getSystemName()}</a>
	</span>
	<section class="type01">
	<!-- 상세 페이지  start-->
		<h2 style="position:relative">
			<span class="title_s">user management</span>
			<span class="title">사용자 관리</span>
			<div  class="top_btn_box">
				<ul>
					<li>
						<button type="button" class="btn_circle_red" onClick="javascript:insertUser2();">&nbsp;</button>
					</li>
				</ul>
			</div>
		</h2>
		<div class="group01" >
			<div class="title"><!--span class="txt">연구개발시스템 공지사항</span--></div>
				<div class="search_box" >
					<ul>
						<li style=" width:100%">
							<dt>검색조건</dt>
							<dd style="width:700px;">
								<div class="selectbox ml5" style="width:180px;">  
									<label for="dept" id="deptL">부서</label> 
									<select id="dept" name="dept">
										<option value="">전체</option>
										<c:forEach  items="${deptList}" var = "dept">
											<option value="${dept.itemCode}">${dept.itemName}</option>
										</c:forEach>										
									</select>
								</div>
								
								<div class="selectbox ml5" style="width:180px;">  
									<label for="team" id="teamL">팀</label> 
									<select id="team" name="team">
										<option value="">전체</option>
										<c:forEach  items="${teamList}" var = "team">
										<option value="${team.itemCode}">${team.itemName}</option>
										</c:forEach>
									</select>
								</div>
								
								<div class="selectbox ml5" style="width:180px;">  
									<label for="grade" id="gradeL">권한</label> 
									<select id="grade" name="grade">
										<option value="">전체</option>
										<c:forEach  items="${gradeList}" var = "grade">
										<option value="${grade.itemCode}">${grade.itemName}</option>
										</c:forEach>
									</select>
								</div>
							</dd>
						</li>
						<li style=" width:100%">
							<dt>검색어</dt>
							<dd style="width:700px;">
								<input type="text" class="ml5" name="searchValue" id="searchValue" style="width:180px;"/>
							</dd>
						</li>
						
					</ul>
					<div class="fr pt5 pb10">
						<button type="button" class="btn_con_search"  onClick="goSearch();"><img src="/resources/images/btn_icon_search.png" style="vertical-align:middle;"/> 검색</button>
						<button type="button" class="btn_con_search" onClick="goClear();"><img src="/resources/images/btn_icon_refresh.png" style="vertical-align:middle;"/> 검색 초기화</button>
					</div>
				</div>
				<div class="main_tbl">
					<table class="tbl01">
						<colgroup>
							<col width="9%">
							<col width="9%">
							<col width="10%">
							<col width="16%">
							<col width="10%">
							<col width="10%">
							<col width="6%">
							<col width="12%">
							<col width="18%">
						</colgroup>
						<thead>
							<tr>
								<th>사용자명</th>
								<th>아이디</th>
								<th>권한</th>
								<th>부서</th>
								<th>팀</th>
								<th>관리자</th>
								<th>잠김</th>
								<th>생성일</th>
								<th>사용자설정</th>
							</tr>
						</thead>
						<tbody  id="userList">
						</tbody>
					</table>
					<div class="page_navi mt10" id="page_navi">
					</div>
				</div>
				<div class="btn_box_con">
					<button type="button" class="btn_admin_red" onClick="javascript:insertUser2();">사용자 등록</button>
				</div>
				<hr class="con_mode"/>
			</div>
	</section>	
</div>	
