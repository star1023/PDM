9<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ taglib prefix="userUtil" uri="/WEB-INF/tld/userUtil.tld"%>
<%@ page session="false" %>
<title>로그</title>
<div class="wrap_in" id="fixNextTag">
	<span class="path">로그&nbsp;&nbsp;<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;시스템관리&nbsp;&nbsp;<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;<a href="#">${strUtil:getSystemName()}</a></span>
	<section class="type01">
	<!-- 상세 페이지  start-->
		<h2 style="position:relative">
			<span class="title_s">Log</span>
			<span class="title">로그</span>
			<div  class="top_btn_box">
				<ul><li></li></ul>
			</div>
		</h2>
		<div class="group01" >
			<div class="title"><!--span class="txt">연구개발시스템 공지사항</span--></div>
			<!-- <div class="tab02">
				<ul>
					<a href="/approval/approvalList"><li class="" id="apprCount">내가 받은 결재문서</li></a>
					<a href="#"><li  class="select" id="myCount">내가 올린 결재문서</li></a>
					<a href="/approval/refList"><li class="" id="refCount">참조 및 회람문서</li></a>
					<a href="/approval/approvingList"><li class="" id="">결재진행중 문서</li></a>
				</ul>
			</div> -->
			<div class="search_box" >
				<ul>
					<li>
						<dt>구분</dt>
						<dd style="width:400px">
							<div class="selectbox" style="width:150px;">
								<label for="logType">부서</label>
								<select name="logType" id="logType" onChange="searchLog()">
									<option value="login">로그인</option>
									<option value="access">사용자 접근기록</option>
									<option value="bom">BOM</option>
									<option value="dev">제품개발문서</option>
									<option value="design">제품설계서</option>
									<option value="print">프린트</option>
									<option value="mfgNo">품목제조보고서</option>
								</select>
							</div>
						</dd>
					</li>
					<li>
						<dt>키워드</dt>
						<dd style="widht:400px">
							<div class="selectbox" style="width:100px;">  
								<label for="searchType" id="searchType_label">선택</label> 
								<select id="searchType" name="searchType">
									<option value="">선택</option>
									<option value="U">결재자</option>
									<option value="K">제목</option>
								</select>
							</div>
							<input type="text" name="searchValue" id="searchValue" style="width:200px; margin-left:5px;"/>
						</dd>
					</li>
					<li>
						<dt>표시수</dt>
						<dd >
							<div class="selectbox" style="width:100px;">  
								<label for="viewCount" id="viewCount_label">선택</label> 
								<select name="viewCount" id="viewCount">		
									<option value="">선택</option>													
									<option value="10">10</option>
									<option value="20">20</option>
									<option value="50">50</option>
									<option value="100">100</option>
								</select>
							</div>
						</dd>
					</li>
				</ul>
				<div class="fr pt5 pb10">					 
					<button type="button" class="btn_con_search" onClick="javascript:goSearch()"><img src="/resources/images/btn_icon_search.png" style="vertical-align:middle;"/> 검색</button>
					<button type="button" class="btn_con_search" onClick="goClear()"><img src="/resources/images/btn_icon_refresh.png" style="vertical-align:middle;"/> 검색 초기화</button>
				</div>
			</div>
			<div class="main_tbl">
				<table class="tbl01">
					<colgroup>
						<col width="10%">
						<col width="10%">
						<col width="10%">
						<col width="13%">
						<col />
						<col width="10%">
						<col width="15%">
						<col width="8%">
					</colgroup>
					<thead>
						<tr>
							<th>결재번호</th>
							<th>문서구분</th>
							<th>결재유형</th>
							<th>결재진행단계</th>
							<th>결재문서명</th>
							<th>현재결재</th>
							<th>상신일</th>
							<th>결재설정</th>
						</tr>
					</thead>
					<tbody id="list">
					</tbody>
				</table>	
				<div class="page_navi  mt10">
				</div>
			</div>
			<div class="btn_box_con"></div>
			<hr class="con_mode"/><!-- 신규 추가 꼭 데려갈것 !-->
		</div>
	</section>
</div>