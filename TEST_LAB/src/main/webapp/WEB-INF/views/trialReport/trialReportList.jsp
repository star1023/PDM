<%--
  Created by IntelliJ IDEA.
  User: solit
  Date: 2023/4/14
  Time: 13:28
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ page import="kr.co.aspn.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%
    String userGrade = UserUtil.getUserGrade(request);
    String userDept = UserUtil.getDeptCode(request);
    String userTeam = UserUtil.getTeamCode(request);
    String userId = UserUtil.getUserId(request);
    String isAdmin = UserUtil.getIsAdmin(request);

    Boolean doAdmin = false;
   
    String authCheckType;
    
    /*
    	-------------------------------------------------------------------------------------------------------------------------
    	시생산보고서 조회권한 23.09.25
    	
    	/작성완료(ALL)  	: 	전체공개
    	/승인완료(ALL)  	:	전체 문서 확인 가능 			( 권한 : 관리자 , BOM담당자(grade : 3), 부서 : 품질경영(dept7), 연구소장(dept10), 자재과(dept99) )
    		   (TEAM)	: 	소속팀원이 작성한 문서 확인		( 부서 : 연구기획(dept1) , 개발1(dept2), 개발2(dept3), 신선편의개발(dept4), 맥분제품개발(dept5), 
    			  								 	               조리개발(dept11), 육가공개발(dept6), 빚은상품기획(dept12), bakery(dept13) )
    		   (OTHER)		작성/결재/참조				( 이하 나머지 권한, 부서 )
    	
    	오류문의 조치_23.10.12 
    	/사용자가 시생산보고서 작성자이면 해당 문서 결재상신 권한 추가.	 (185줄)
    	-------------------------------------------------------------------------------------------------------------------------
    */
    
    
    //권한: 관리자, 사용자 권한-BOM
    if( (isAdmin != null && "Y".equals(isAdmin)) || "3".equals(userGrade)){
        doAdmin = true;
    }
    		   
    if(doAdmin || userId.equals("cha") || userDept.equals("dept7") || userDept.equals("dept10") || userDept.equals("dept99") ){
        authCheckType = "ALL";
    }else if(userDept.equals("dept1") || userDept.equals("dept2") || userDept.equals("dept3") || userDept.equals("dept4") || userDept.equals("dept5")
    		|| userDept.equals("dept6") || userDept.equals("dept11") || userDept.equals("dept12") || userDept.equals("dept13")){	
    	authCheckType = "TEAM";
    }else {
    	authCheckType = "OTHER";
    }
    
//이전 권한 
//    if(doAdmin || userId.equals("cha") || userDept.equals("dept7") || userDept.equals("dept8") || userDept.equals("dept9") || userDept.equals("dept10")){
//        authCheckType = "ALL";
//    }else if(userDept.equals("dept1") || userDept.equals("dept2") || userDept.equals("dept3")
//            || userDept.equals("dept4") || userDept.equals("dept5") || userDept.equals("dept6")
//            || userDept.equals("dept11") || userDept.equals("dept12")|| userDept.equals("dept13")){
//        authCheckType = "DEPT";
//    }

%>
<title>시생산보고서</title>
<script type="text/javascript">
    $(document).ready(function(){
        var thisUrl = window.location.href;
        if(thisUrl.indexOf("historyBack") > 0){
            $("#pageNo").val(window.localStorage.getItem("pageNo"));
            $("#searchType").val(window.localStorage.getItem("searchType")).change();
            $("#searchValue").val(window.localStorage.getItem("searchValue"));
            $("#viewCount").val(window.localStorage.getItem("viewCount")).change();
            changeTab(window.localStorage.getItem("status"),$("#pageNo").val());
        }else{
            changeTab("writeStart");
        }
    });

    function paging(pageNo){
        loadList(pageNo);
    }

    function trialReportDetail(cNo, rNo,mode) {
        var form = document.createElement('form');
        form.style.display = 'none';
        $('body').append(form);
        form.action = "/trialReport/trialReportDetail";
        form.target = '_self';
        form.method = 'post';

        appendInput(form, 'cNo', cNo);
        appendInput(form, 'rNo', rNo);
        appendInput(form, 'mode',mode);
        if(mode == "write"){
            appendInput(form, 'docLink',1);
        }
        appendInput(form, 'from',"trialReportList");

        $(form).submit();
        //$(form).remove();
    }

    function initCount() {
        $("#tab_list").children('a').toArray().some(function(a, i){
            $(a).children('li').children('span').html("00");
        })
    }

    function changeTab(id,pageNo) {
        setSelect(id);
        $("#currentStatus").val(id);
        if(pageNo == null){pageNo = 1}
        loadList(pageNo);
    }

    function setSelect(id){
        $("#TAB_writeStart").removeAttr("class");
        $("#TAB_writeEnd").removeAttr("class");
        $("#TAB_apprEnd").removeAttr("class");
        $("#TAB_" + id).attr("class","select");
    }

    function loadList( pageNo ) {
        $("#lab_loading").show();
        window.localStorage.setItem("pageNo",pageNo);
        window.localStorage.setItem("searchType",$("#searchType").selectedValues()[0]);
        window.localStorage.setItem("searchValue",$("#searchValue").val());
        window.localStorage.setItem("viewCount",$("#viewCount").selectedValues()[0]);
        window.localStorage.setItem("status",$("#currentStatus").val());

        var currentStatus = $("#currentStatus").val();
        var viewCount = $("#viewCount").selectedValues()[0];
        if( viewCount == "" ) {
            viewCount = "10";
        }
        if( currentStatus == "writeEnd" || currentStatus == "apprEnd" ){
            $("#th_7").text("시작일");
            $("#th_8").text("종료일");
        }else{
            $("#th_7").text("작성자");
            $("#th_8").text("작성일");
        }
        $("#list").html("");
        $(".page_navi").html("");
        var URL = "/trialReport/trialReportListAjax";
        $.ajax({
            type:"POST",
            url:URL,
            data:{
                "pageNo":pageNo,
                "searchType":$("#searchType").selectedValues()[0],
                "searchValue":$("#searchValue").val(),
                "viewCount":viewCount,
                "status":currentStatus,
                "authCheckType":"<%=authCheckType%>"
            },
            dataType:"json",
            success:function(data) {
                var html = "";
                initCount();
                $.each(data.mapCount,function(name,value){
                    if(value == 0){ value = "00"}
                    $("#" + name).html(value);
                });
                if( data.totalCount > 0 ) {
                    $("#list").empty();
                    $.each(data.trialReportList,function(index,item){
                        html = "<tr>";
                        html += "   <td>" + item.rNo + "</td>";        //문서번호
                        html += "   <td>" + item.dNo + "</td>";        //공정서번호
                        //작성단계
                        if( item.writedCount == item.totalCount ){
                            html += "   <td><span class=\"app02\">작성완료 (" + item.writedCount + "/" + item.totalCount+ ")</span></td>";
                        }else{
                            html += "   <td><span class=\"app01\">작성중 (" + item.writedCount + "/" + item.totalCount+ ")</span></td>";
                        }
                        //제품명
                        console.log(item);
                        var mode = "read";
                        if(currentStatus == 'writeStart' && item.writeDate == null){
                            mode = "write";
                        }         
                        // 23.10.12 오류문의 조치_사용자가 시생산보고서 작성자이면 해당 문서 결재상신 권한 추가. 
                        if(currentStatus == 'writeEnd'){
                            if("<%=authCheckType%>" == "ALL" && item.state == "35" || item.createUser == "<%=UserUtil.getUserId(request)%>"){
                                mode = "appr2";
                            }
                        }
                        if(currentStatus == 'apprEnd'){
                            mode = "readFull";
                        }
                        html += "   <td>";
                        html += "       <div class=\"ellipsis_txt tgnl\">";
                        html += "			<a href=\"#\" onclick=\"trialReportDetail('" + item.cNo + "', '" + item.rNo + "','" + mode + "'); return false;\">" + item.productName + "</a>";
                        html += "       </div>";
                        html += "   </td>";
                        html += "   <td>" + nvl(item.lineName,"") + "</td>";        //라인
                        html += "   <td>" + nvl(item.resultName,"") + "</td>";        //결과
                        var tbType = "trialReportCreate",type = "5";
                        if(nvl(item.apprNo2,"") != ""){tbType = "trialReportAppr2"; type = "6"}
                        html += "   <td><a href=\"javascript:approvalDetail('" + item.rNo + "','" + tbType + "', '" + type + "');\">" + nvl(item.stateName,"") + "</a></td>";        //상태
                        if( currentStatus == "writeEnd" || currentStatus == "apprEnd"){
                            html += "   <td>" + nvl(item.startDate,"") + "</td>";        //작성자
                            html += "   <td>" + nvl(item.endDate,"") + "</td>";        //작성일
                        }else{
                            html += "   <td>" + nvl(item.writerUserName,"") + "</td>";        //작성자
                            html += "   <td>" + nvl(item.writeDate,"") + "</td>";        //작성일
                        }
                        html += "</tr>";
                        $("#list").append(html)
                    });

                    $(".page_navi").html(data.navi.prevBlock+data.navi.pageList+data.navi.nextBlock);
                    $("#pageNo").val(data.navi.pageNo);
                } else {
                    $("#list").html(html);
                    html += "<tr><td align='center' colspan='7'>데이터가 없습니다.</td></tr>";
                    $("#list").html(html);
                    $(".page_navi").html(data.navi.prevBlock+data.navi.pageList+data.navi.nextBlock);
                    $("#pageNo").val(data.navi.pageNo);
                }
                $("#lab_loading").hide();
            },
            error:function(request, status, errorThrown){
                var html = "";
                $("#list").html(html);
                html += "<tr><td align='center' colspan='8'>오류가 발생하였습니다.</td></tr>";
                $("#list").html(html);
                $('.page_navi').html(data.navi.prevBlock+data.navi.pageList+data.navi.nextBlock);
                $('#pageNo').val(data.navi.pageNo);
                $("#lab_loading").hide();
            }
        });
    }

    function goSearch() {
        loadList('1');
    }

    function goClear() {
        $("#searchType").selectOptions("");
        $("#searchType_label").html("선택");
        $("#searchValue").val("");
        $("#viewCount").selectOptions("");
        $("#viewCount_label").html("선택");
        goSearch();
    }

    function approvalDetail( tbKey, tbType, type ) {
        var url = "";
        var mode = "";
        url = "/approval/approvalInfoPopup?tbKey="+tbKey+"&tbType="+tbType;
        if(type != null){ url += "&type=" + type; }
        mode = "width=1100, height=300, left=100, top=50, scrollbars=yes";
        window.open(url, "ApprovalPopup", mode );
    }
</script>
<input type="hidden" name="currentStatus" id="currentStatus" value="writeStart"/>
<input type="hidden" name="pageNo" id="pageNo" value="1"/>
<div class="wrap_in" id="fixNextTag">
    <span class="path">시생산결과보고서&nbsp;&nbsp;
		<img src="/resources/images/icon_path.png" style="vertical-align:middle" alt=""/>&nbsp;&nbsp;
		<a href="#">${strUtil:getSystemName()}</a>
	</span>
    <section class="type01">
        <!-- 상세 페이지  start-->
        <h2 style="position:relative"><span class="title_s">Trial Production Result Report</span>
            <span class="title">시생산결과보고서</span>
            <div  class="top_btn_box">
                <ul><li></li></ul>
            </div>
        </h2>
        <div class="group01" >
            <div class="title"></div>
            <div class="tab02">
                <ul id="tab_list">
                    <a href="#" onClick="changeTab('writeStart');return false;"><li id="TAB_writeStart">작성(<span id="COUNT_writeStart">00</span>건)</li></a><!-- 시생산결과보고서 작성 -->
                    <a href="#" onClick="changeTab('writeEnd');return false;"><li id="TAB_writeEnd">작성완료(<span id="COUNT_writeEnd">00</span>건)</li></a><!-- 시생산결과보고서 작성완료 -->
                    <a href="#" onClick="changeTab('apprEnd');return false;"><li id="TAB_apprEnd">승인완료(<span id="COUNT_apprEnd">00</span>건)</li></a><!-- 시생산결과보고서 승인완료 -->
                </ul>
            </div>
            <div class="search_box" >
                <ul style="border-top:none;">
                    <li>
                        <dt>키워드</dt>
                        <dd style="widht:400px">
                            <div class="selectbox" style="width:100px;">
                                <label for="searchType" id="searchType_label">선택</label>
                                <select id="searchType" name="searchType">
                                    <option value="">선택</option>
                                    <option value="rNo">문서번호</option>
                                    <option value="dNo">공정서번호</option>
                                    <option value="productName">제품명</option>
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
                    <button type="button" class="btn_con_search" onClick="goSearch()"><img src="/resources/images/btn_icon_search.png" style="vertical-align:middle;" alt=""/> 검색</button>
                    <button type="button" class="btn_con_search" onClick="goClear()"><img src="/resources/images/btn_icon_refresh.png" style="vertical-align:middle;" alt=""/> 검색 초기화</button>
                </div>
            </div>
            <div class="main_tbl">
                <table class="tbl01">
                    <colgroup>
                        <col width="5%">
                        <col width="8%">
                        <col width="10%">
                        <col>
                        <col width="15%">
                        <col width="15%">
                        <col width="10%">
                        <col width="8%">
                        <col width="8%">
                    </colgroup>
                    <thead>
                        <tr>
                            <th>문서번호</th>
                            <th>공정서번호</th>
                            <th>작성단계</th>
                            <th>제품명</th>
                            <th>라인</th>
                            <th>결과</th>
                            <th>상태</th>
                            <th id="th_7">작성자</th>
                            <th id="th_8">작성일</th>
                        </tr>
                    </thead>
                    <tbody id="list"></tbody>
                </table>
                <div class="page_navi  mt10"></div>
            </div>
            <div class="btn_box_con"></div>
            <hr class="con_mode"/><!-- 신규 추가 꼭 데려갈것 !-->
        </div>
        <!-- 상세 페이지  end  -->
    </section>
</div>

