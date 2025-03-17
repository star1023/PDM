<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="userUtil" uri="/WEB-INF/tld/userUtil.tld"%>
<%@ taglib prefix="dateUtil" uri="/WEB-INF/tld/dateUtil.tld"%>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="kr.co.aspn.util.*" %>
<%@ page session="false" %>

<!--점포용, OEM 제품명처리-->
<c:if test="${productDevDoc.productDocType == null}">
    <c:set target="${productDevDoc}" property="productDocType" value="0"/>
</c:if>
<c:set var="productDocTypeName" value="" />
<c:set var="productNamePrefix" value="" />
<c:set var="titlePrefix" value="" />
<c:set var="displayNone" value=""/>
<c:choose>
    <c:when test="${productDevDoc.productDocType == '1'}">
        <c:set var="productDocTypeName" value="점포용 " />
        <c:set var="productNamePrefix" value="[${productDevDoc.storeDiv}]" />
        <c:set var="titlePrefix" value="[BF] " />
        <c:set var="displayNone" value="display:none"/>
    </c:when>
    <c:when test="${productDevDoc.productDocType == '2'}">
        <c:set var="productDocTypeName" value="OEM " />
        <c:set var="displayNone" value="display:none"/>
    </c:when>
    <c:otherwise>
    </c:otherwise>
</c:choose>

<link href="/resources/css/print.css" rel="stylesheet" type="text/css" />
<style type="text/css">
    table{font-size: 12px}
    .intable_title{ border:0; table-layout:fixed;}
    .intable_title td{border:1px solid #666; text-align:center; height:22px;}

    .intable{ border:0; table-layout:fixed; }
    .intable td{border:1px solid #666; text-align:center; height:22px;word-break: break-all;}
    .intable th{ }
    .intable tfoot td{ background-color:#f2f2f2; border-bottom:none;}
    .intable tfoot th{ background-color:#f2f2f2; border-bottom:none;}
    .lineall{ border:2px solid #000}
    .big_font{ font-size:20px;}
    .hftitle{background-color:#f3f3f3;}
    .inputText{
        width: 70%;
        height: 25px;
        border: none;
    }
</style>

<table width="100%"  class="intable lineside" style="display:none" id="water_mark_table">
    <tr>
        <td id="water_mark_td" align="center">!- 유출금지 정보출력 -!</td>
    </tr>
</table>

<table border="0" width="100%" height="60" style="display:none" id="confi">
    <tr>
        <td align="left">
            <img src="/resources/images/btn_confi.png"  border="0" style="margin-left:3px;"/>
        </td>
    </tr>
</table>

<div class="watermark"><img src="/resources/images/watermark.png"></div>

<input type="hidden" id="createUser" value="${trialReportHeader.createUser}"/>
<input type="hidden" id="productName" value="${productNamePrefix}${productDevDoc.productName}(${productDevDoc.productCode})/${mfgProcessDoc.plantName}"/>
<!-- 제조공정서 Link start -->
<c:if test="${devDocLink == '1'}">
<div>
    <table style="width: 100%"  class="intable lineall mb5" >
        <tr>
            <td class="hftitle">
                <a href="#" onclick="window.open('/dev/manufacturingProcessDetailPopup?tbKey=${trialReportHeader.DNo}&tbType=manufacturingProcessDoc&docNo=${trialReportHeader.docNo}&docVersion=${trialReportHeader.docVersion}', '', 'width=1100, height=650, left=100, top=50, scrollbars=yes' );return false;" >제조공정서 보기</a>
            </td>
        </tr>
    </table>
</div>
</c:if>
<!-- 제조공정서 Link end-->

<!--head start-->
<div class="hold">
    <table style="width: 100%"  class="intable lineall mb5" >
        <colgroup>
          <col width="10%">
          <col width="10%">
          <col width="10%">
          <col width="10%">
          <col width="10%">
          <col width="10%">
          <col width="10%">
          <col width="10%">
          <col width="10%">
          <col width="10%">
        </colgroup>
        <tr>
            <td rowspan="4" ><div style="background-image:url(/resources/images/bg_main_logo.png); width:100px; height:100px; background-repeat:no-repeat;background-size: contain; float:left; "></div></td>
            <td rowspan="4" colspan="7" class="hftitle"><span class="big_font">시생산결과보고서</span></td>
            <td class="hftitle">문서번호</td>
            <td>${trialReportHeader.RNo}</td>
        </tr>
        <tr>
            <td class="hftitle">일시(시작일)</td>
            <td>${trialReportHeader.startDate}</td>
        </tr>
        <tr>
            <td class="hftitle">일시(종료일)</td>
            <td>${trialReportHeader.endDate}</td>
        </tr>
        <tr>
            <td class="hftitle">담당연구원</td>
            <td>${trialReportHeader.createName}</td>
        </tr>
        <tr>
            <td colspan="5" class="hftitle">제품명</td>
            <td colspan="2" class="hftitle">유형</td>
            <td class="hftitle">생산라인</td>
            <td class="hftitle">유통채널</td>
            <td class="hftitle">출시일</td>
        </tr>
        <tr>
            <td colspan="5"><span class="big_font">${productNamePrefix}${productDevDoc.productName}(${productDevDoc.productCode})/${mfgProcessDoc.plantName}</span></td>
            <td colspan="2">
                ${productDevDoc.productType1Text}
                <c:if test="${productDevDoc.productType2Text != '' && productDevDoc.productType2Text != null }">
                    &gt; ${productDevDoc.productType2Text}
                </c:if>
                <c:if test="${productDevDoc.productType3Text != '' && productDevDoc.productType3Text != null }">
                    &gt; ${productDevDoc.productType3Text}
                </c:if>
            </td>
            <td>${trialReportHeader.lineName}</td>
            <td><input type="text" class="inputText" id="distChannel" name="distChannel" style="width: 90%" value="${trialReportHeader.distChannel}" placeholder="유통채널" /></td>
            <td><input type="text" class="inputText" id="releasePlanDate" name="releasePlanDate" value="${trialReportHeader.releasePlanDate}" placeholder="yyyy-mm-dd" readonly="readonly"/></td>
        </tr>
        <tr>
            <td colspan="3" class="hftitle">시생산 결과</td>
            <td colspan="5" style="text-align: center">
                <div>
                    <c:choose>
                        <c:when test="${trialReportHeader.result == 'pass'}"><c:set var="pass" value="checked='checked'"/> </c:when>
                        <c:when test="${trialReportHeader.result == 'progress'}"><c:set var="progress" value="checked='checked'"/> </c:when>
                        <c:when test="${trialReportHeader.result == 'retest'}"><c:set var="retest" value="checked='checked'"/> </c:when>
                        <c:when test="${trialReportHeader.result == 'fail'}"><c:set var="fail" value="checked='checked'"/> </c:when>
                    </c:choose>
                    <input type="checkbox" id="pass" ${pass} onclick="editTrialReport.resultCheckBox(this)"/><label for="pass"><span></span>합격</label>&nbsp;&nbsp;&nbsp;
                    <input type="checkbox" id="progress" ${progress} onclick="editTrialReport.resultCheckBox(this)"/><label for="progress"><span></span>조건부 진행</label>&nbsp;&nbsp;&nbsp;
                    <input type="checkbox" id="retest" ${retest} onclick="editTrialReport.resultCheckBox(this)"/><label for="retest"><span></span>재실험</label>&nbsp;&nbsp;&nbsp;
                    <input type="checkbox" id="fail" ${fail} onclick="editTrialReport.resultCheckBox(this)"/><label for="fail"><span></span>불가</label>
                </div>
            </td>
            <td class="hftitle">시생산 일자</td>
            <td><input type="text" class="inputText" id="releaseRealDate" name="releaseRealDate" value="${trialReportHeader.releaseRealDate}" placeholder="yyyy-mm-dd" readonly="readonly"/></td>
        </tr>
        <c:forEach var="trialReportComment" items="${trialReportHeader.trialReportComment}" varStatus="status" >
        <tr>
            <c:if test="${status.index == 0}">
                <td colspan="2" rowspan="${fn:length(trialReportHeader.trialReportComment)}" class="hftitle">작성자/의견</td>
            </c:if>
            <td class="hftitle">${trialReportComment.writerDeptCodeName}<br>${trialReportComment.writerTeamCodeName}</td>
            <td colspan="2"><input type="hidden" name="writerUserId" value="${trialReportComment.writerUserId}"/>${trialReportComment.writerUserName}</td>
            <td colspan="5" style="text-align: left; vertical-align: top">
                <c:choose>
                    <c:when test="${cNo == trialReportComment.CNo}">
                        <textarea id="writerComment" name="writerComment" style="width: 98%" placeholder="작성자 의견을 입력하세요.">${trialReportComment.writerComment}</textarea>
                    </c:when>
                    <c:otherwise>${strUtil:getHtmlBr(trialReportComment.writerComment)}</c:otherwise>
                </c:choose>
            </td>
        </tr>
        </c:forEach>
    </table>
</div>
<!--head end-->

<!-- body start -->
<div id="reportBody">
    ${trialReportHeader.reportContents}
</div>
<!-- body end -->

<!-- footer start -->
<div>
    <table style="width: 100%"  class="intable lineall mb5" >
        <colgroup>
            <col width="10%">
            <col width="22.5%">
            <col width="22.5%">
            <col width="22.5%">
            <col width="22.5%">
        </colgroup>
        
        <c:set var="reportTemplateNo" value="${trialReportHeader.reportTemplateNo }" />
        <c:choose>
        	<c:when test="${reportTemplateNo eq '9' }"> <!-- 샌드팜 양식일때 -->
        	<tr>
	            <td rowspan="2" class="hftitle">사진</td>
	            <td class="hftitle">내용물1</td>
	            <td class="hftitle">내용물2</td>
	            <td class="hftitle">내용물3</td>
	            <td class="hftitle">완제품</td>
        	</tr>
        	</c:when>
        	<c:otherwise>
        	<tr>
	            <td rowspan="2" class="hftitle">사진</td>
	            <td class="hftitle">완제품</td>
	            <td class="hftitle">포장1</td>
	            <td class="hftitle">포장2 (PVC, 적재 등)</td>
	            <td class="hftitle">기타 첨부 이미지</td>
        	</tr>
        	</c:otherwise>
        </c:choose>
        <c:set var="img10" value="/resources/images/img_noimg.png"/>
        <c:set var="img20" value="/resources/images/img_noimg.png"/>
        <c:set var="img30" value="/resources/images/img_noimg.png"/>
        <c:set var="img40" value="/resources/images/img_noimg.png"/>
        <c:forEach var="trialReportFile" items="${trialReportFiles}" >
            <c:choose>
                <c:when test="${trialReportFile.gubun == '10'}">
                    <c:set var="img10" value="/devDocImage/${trialReportFile.webUrl}"/>
                </c:when>
                <c:when test="${trialReportFile.gubun == '20'}">
                    <c:set var="img20" value="/devDocImage/${trialReportFile.webUrl}"/>
                </c:when>
                <c:when test="${trialReportFile.gubun == '30'}">
                    <c:set var="img30" value="/devDocImage/${trialReportFile.webUrl}"/>
                </c:when>
                <c:when test="${trialReportFile.gubun == '40'}">
                    <c:set var="img40" value="/devDocImage/${trialReportFile.webUrl}"/>
                </c:when>
                <c:otherwise></c:otherwise>
            </c:choose>
        </c:forEach>
        <tr>
            <td style="height: 160px">
                <input id="file01" class="form-control form_point_color01" data-gubun="10" type="file" style="width:92%;float:left; cursor: pointer; color: black;" accept="image/*" onchange="editTrialReport.uploadReportImage(this);"/>
                <img id="img10" src="${img10}" style="width:100%; height:160px; max-height:200px;" alt=""/>
            </td>
            <td>
                <input id="file02" class="form-control form_point_color01" data-gubun="20" type="file" style="width:92%;float:left; cursor: pointer; color: black;" accept="image/*" onchange="editTrialReport.uploadReportImage(this);"/>
                <img id="img20" src="${img20}" style="width:100%; height:160px; max-height:200px;" alt=""/>
            </td>
            <td>
                <input id="file03" class="form-control form_point_color01" data-gubun="30" type="file" style="width:92%;float:left; cursor: pointer; color: black;" accept="image/*" onchange="editTrialReport.uploadReportImage(this);"/>
                <img id="img30" src="${img30}" style="width:100%; height:160px; max-height:200px;" alt=""/>
            </td>
            <td>
                <input id="file04" class="form-control form_point_color01" data-gubun="40" type="file" style="width:92%;float:left; cursor: pointer; color: black;" accept="image/*" onchange="editTrialReport.uploadReportImage(this);"/>
                <img id="img40" src="${img40}" style="width:100%; height:160px; max-height:200px;" alt=""/>
            </td>
        </tr>
    </table>
    
     <table style="width: 100%"  class="intable lineall mb5" >
		 	<colgroup>
	            <col width="10%">
	            <col width="80%">
	            <col width="10%">
	           
	        </colgroup>
	        <tr>
	        	<td rowspan="2" class="hftitle">첨부파일</td>
	  	        <td>
	  	        	<ul id="attachmentList">
	  	        		<c:forEach items="${trialAttachFiles}" var="file" >
		  	        		<li id="file_li_${file.fNo}" style="list-style:none; padding-bottom: 5px;">
		  	        			<a href="javascript:downloadFile('${file.fNo}')">${file.orgFileName}</a>&nbsp;&nbsp;&nbsp;
		  	        			<span>( ${file.regUserName} / ${file.regDate} )</span>
		  	        			<button class="btn_doc" onclick="deleteFile('${file.fNo}', '${file.orgFileName}')"><img src="/resources/images/icon_doc04.png">삭제</button>
		  	        		</li>
			  	        </c:forEach> 
	  	        	</ul>
	  	        </td>
				<td>
					<button class="btn_con_search" onClick="openDialog('dialog_trial_attatch')">
						<img src="/resources/images/icon_s_file.png" />파일첨부
					</button>
				</td>
	        </tr>
	</table>
 
</div>
<!-- footer end -->