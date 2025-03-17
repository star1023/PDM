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
    
    /* 추가 */
    .water_mark{font-family:'맑은고딕',Malgun Gothic; font-size:13px; margin-top:10px; float:left;}
    .watermark{  opacity: 1; position: fixed; top: 50%; left: 50%;transform: translate(-50%, -50%); pointer-events: none; z-index:10;}
    .hold{page-break-inside:avoid; position:relative;}
</style>


<table border="0" width="100%" height="60" style="display:none" id="confi">
    <tr>
        <td align="left">
            <img src="/resources/images/btn_confi.png"  border="0" style="margin-left:3px;"/>
        </td>
    </tr>
</table>


<div class="print_box" style="table-layout:fixed;">
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
	
	<!-- 결재자 의견 -->
	<c:if test="${devDocView == '1'}">
		<div style="table-layout:fixed;font-size: 12px">
			<div class="hold">
				<!-- 시생산보고서 2차 결재자 -->
				<table width="100%"  class="intable lineall mb5" >
					<colgroup>
						<col width="10%">
			            <col>
					</colgroup>
					
					<tr>
						<td class="hftitle">팀장 결재</td>
						<td>
							<table style="width:100%;height:100%" class="intable02">
								<colgroup>
									<col width="45%">
						            <col>
								</colgroup>
						
								<c:forEach items="${Appr2.apprItemList}" var="item"  varStatus="status">
									<input type="hidden" name="seq" id="seq" value="${item.seq }">
									<fmt:parseNumber var="seq" type="number" value="${item.seq}" />
									
									<c:if test="${item.state != 0}">
									<tr>	
										
										<td>		
											<span>
												<c:choose>
													<c:when test="${item.seq eq '1' }">기안</c:when>
													<c:otherwise>결재</c:otherwise> 
												</c:choose>
											</span>
											
											${item.userName} 
											<c:if test="${item.proxyYN eq 'Y' }">(대결:${item.proxyId})</c:if>
											<strong>
												${item.authName}/${item.deptCodeName}&nbsp;</strong>(<i>${item.stateText}</i>
											<span>
												<c:choose>
													<c:when test="${item.seq eq '1' }">:${item.regDate}</c:when>
													<c:otherwise>
														<c:if test="${item.modDate != '' && item.modDate != null}">:${item.modDate}</c:if>
													</c:otherwise>
												</c:choose> )
											</span>
										</td>
												
										<td style="text-align: left;">
											<c:if test="${item.note !=null && item.note ne '' }">
												<span>${item.note}</span>
											</c:if>
										</td>
										
									</tr>
									</c:if>
								</c:forEach>
							</table>	
						</td>
					</tr>
				</table>
				<!-- 2차 결재자 end-->
			
				<!-- 시생산보고서 1차 결재자 -->
				<table width="100%"  class="intable lineall mb5" >
					<colgroup>
						<col width="10%">
			            <col>
					</colgroup>
					
					<tr>
						<td class="hftitle">자재검토 결재</td>
						<td>
							<table style="width:100%;height:100%" class="intable02">
								<colgroup>
									<col width="45%">
						            <col>
								</colgroup>
						
								<c:forEach items="${Appr1.apprItemList}" var="item"  varStatus="status">
									<input type="hidden" name="seq" id="seq" value="${item.seq }">
									<fmt:parseNumber var="seq" type="number" value="${item.seq}" />
									
									<c:if test="${item.state != 0}">
									<tr>	
										
										<td>		
											<span>
												<c:choose>
													<c:when test="${item.seq eq '1' }">기안</c:when>
													<c:otherwise>결재</c:otherwise>
												</c:choose>
											</span>
											
											${item.userName} 
											<c:if test="${item.proxyYN eq 'Y' }">(대결:${item.proxyId})</c:if>
											<strong>
												${item.authName}/${item.deptCodeName}&nbsp;</strong>(<i>${item.stateText}</i>
											<span>
												<c:choose>
													<c:when test="${item.seq eq '1' }">:${item.regDate}</c:when>
													<c:otherwise>
														<c:if test="${item.modDate != '' && item.modDate != null}">:${item.modDate}</c:if>
													</c:otherwise>
												</c:choose> )
											</span>
										</td>
												
										<td style="text-align: left;">
											<c:if test="${item.note !=null && item.note ne '' }">
												<span>${item.note}</span>
											</c:if>
										</td>
										
									</tr>
									</c:if>
								</c:forEach>
							</table>	
						</td>
					</tr>
				</table>
				<!-- 1차 결재자 end -->
			</div>
		</div>
		<!-- 결재자 의견  end-->
	</c:if>
	
	<!--head start-->
	<div class="hold">
		<div class="watermark"><img src="/resources/images/watermark.png"></div> 
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
	            <td colspan="5">
	                <c:if test="${docLink == 1}"><a href="/dev/productDevDocDetail?docNo=${trialReportHeader.docNo}&docVersion=${trialReportHeader.docVersion}" target="_blank"></c:if>
	                <span class="big_font">${productNamePrefix}${productDevDoc.productName}(${productDevDoc.productCode})/${mfgProcessDoc.plantName}</span>
	                <c:if test="${docLink == 1}"></a></c:if>
	            </td>
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
	            <td>${trialReportHeader.distChannel}</td>
	            <td>${trialReportHeader.releasePlanDate}</td>
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
	                    <input type="checkbox" id="pass" ${pass} disabled="disabled"/><label for="pass"><span></span>합격</label>&nbsp;&nbsp;&nbsp;
	                    <input type="checkbox" id="progress" ${progress} disabled="disabled"/><label for="progress"><span></span>조건부 진행</label>&nbsp;&nbsp;&nbsp;
	                    <input type="checkbox" id="retest" ${retest} disabled="disabled"/><label for="retest"><span></span>재실험</label>&nbsp;&nbsp;&nbsp;
	                    <input type="checkbox" id="fail" ${fail} disabled="disabled"/><label for="fail"><span></span>불가</label>
	                </div>
	            </td>
	            <td class="hftitle">시생산 일자</td>
	            <td>${trialReportHeader.releaseRealDate}</td>
	        </tr>
	        <c:forEach var="trialReportComment" items="${trialReportHeader.trialReportComment}" varStatus="status" >
	        <tr>
	            <c:if test="${status.index == 0}">
	                <td colspan="2" rowspan="${fn:length(trialReportHeader.trialReportComment)}" class="hftitle">작성자/의견</td>
	            </c:if>
	            <td class="hftitle">${trialReportComment.writerDeptCodeName}<br>${trialReportComment.writerTeamCodeName}</td>
	            <td colspan="2"><input type="hidden" name="writerUserId" value="${trialReportComment.writerUserId}"/>${trialReportComment.writerUserName}</td>
	            <td colspan="5" style="text-align: left; vertical-align: top">${strUtil:getHtmlBr(trialReportComment.writerComment)}</td>
	        </tr>
	        </c:forEach>
	    </table>   
	</div>
	<!--head end-->
	
	<!-- body start -->
	<div class="hold">
	    ${trialReportHeader.reportContents}
	</div>
	<!-- body end -->
		
	<!-- footer start -->
	<div class="hold">
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
	                <img src="${img10}" style="width:100%; height:160px; max-height:200px;" alt=""/>
	            </td>
	            <td>
	                <img src="${img20}" style="width:100%; height:160px; max-height:200px;" alt=""/>
	            </td>
	            <td>
	                <img src="${img30}" style="width:100%; height:160px; max-height:200px;" alt=""/>
	            </td>
	            <td>
	                <img src="${img40}" style="width:100%; height:160px; max-height:200px;" alt=""/>
	            </td>
	        </tr>
	    </table>
	    
	    <table style="width: 100%"  class="intable lineall mb5" >
		 	<colgroup>
	            <col width="10%">
	            <col width="90%">
	        </colgroup>
	        <tr>
	        	<td rowspan="2" class="hftitle">첨부파일</td>
	  	        <td>
	  	        	<ul>
			  	        <c:forEach items="${trialAttachFiles}" var="file" >
		  	        		<li id="file_li_${file.fNo}" style="list-style:none; padding-bottom: 5px;">
		  	        			<a href="javascript:downloadFile('${file.fNo}')">${file.orgFileName}</a>&nbsp;&nbsp;&nbsp;
		  	        			<span>( ${file.regUserName} / ${file.regDate} )</span>
		  	        		</li>
			  	        </c:forEach> 
		  	        </ul>
	  	        </td>
	        </tr>
		 </table>   
		
		<!-- 유출금지 정보출력 start -->
		<table width="100%"  class="intable lineside" style="display:none" id="water_mark_table">
		   <tr>
		       <td id="water_mark_td" align="center">!- 유출금지 정보출력 -!</td>
		   </tr>
		</table>
	    <!-- 유출금지 정보출력 close -->		
	</div>
	<!-- footer end -->

	<!-- 제조 공정서 내역 start -->
	<c:if test="${devDocView == '1'}">
	
	    <!--점포용, OEM 제품명처리-->
	    <br/><br/><br/>
	    <!-- 제조 공정서 내역 -->
	    <div style="table-layout:fixed;font-size: 12px">
	        <!-- 상단 머리정보 start-->
	        <div class="hold">
	            <table width="100%"  class="intable lineall mb5" >
	                <colgroup>
	                    <col width="50%">
	                    <col width="30%">
	                    <col width="10%">
	                    <col width="10%">
	                </colgroup>
	                <tr>
	                    <td class="color05">제품제조공정서</td>
	                    <td rowspan="3">
	                        <table style="width:100%;height:90%" class="intable02">
	                            <c:forEach items = "${apprItemList}" var = "item" varStatus= "status">
	                                <c:set var="apprLength" value="${fn:length(apprItemList)}" />
	                                <tr>
	                                    <td width="25%">
	                                        <c:choose>
	                                            <c:when test="${apprItemHeader.type=='3' }">
	                                                <c:choose>
	                                                    <c:when test="${item.seq eq '1' }">
	                                                        상신
	                                                    </c:when>
	                                                    <c:when test="${item.seq eq '2' }">
	                                                        프린트결재
	                                                    </c:when>
	                                                </c:choose>
	                                            </c:when>
	                                            <c:otherwise>
	                                                <c:choose>
	                                                    <c:when test="${apprItemHeader.tbType eq 'designRequestDoc'}">
	                                                        <c:choose>
	                                                            <c:when test="${item.seq eq '1' }">
	                                                                기안
	                                                            </c:when>
	                                                            <c:otherwise>
	                                                                ${item.seq-1}차 결재
	                                                            </c:otherwise>
	                                                        </c:choose>
	                                                    </c:when>
	                                                    <c:when test="${apprItemHeader.tbType eq 'manufacturingProcessDoc' }">
	                                                        <c:choose>
	                                                            <c:when test="${item.seq eq '1' }">
	                                                                기안
	                                                            </c:when>
	                                                            <c:otherwise>
	                                                                ${item.seq-1}차 결재
	                                                            </c:otherwise>
	                                                        </c:choose>
	                                                    </c:when>
	                                                    <c:when test="${apprItemHeader.tbType eq 'report' }">
	                                                        <c:choose>
	                                                            <c:when test="${item.seq eq '1' }">
	                                                                기안
	                                                            </c:when>
	                                                            <c:when test="${item.seq eq '2' }">
	                                                                결재
	                                                            </c:when>
	                                                        </c:choose>
	                                                    </c:when>
	                                                    <c:otherwise>
	                                                        <c:choose>
	                                                            <c:when test="${item.seq eq '1' }">
	                                                                기안
	                                                            </c:when>
	                                                            <c:otherwise>
	                                                                결재
	                                                            </c:otherwise>
	                                                        </c:choose>
	                                                    </c:otherwise>
	                                                </c:choose>
	                                            </c:otherwise>
	                                        </c:choose>
	                                    </td>
	                                    <td width="30%">
	                                            ${item.userName}
	                                    </td>
	                                    <td width="45%">
	                                        <c:choose>
	                                            <c:when test="${item.seq eq '1' }">
	                                                ${item.regDate}
	                                            </c:when>
	                                            <c:otherwise>
	                                                <c:if test="${item.modDate != '' && item.modDate != null}">
	                                                    ${item.modDate}
	                                                </c:if>
	                                            </c:otherwise>
	                                        </c:choose>
	                                    </td>
	                                </tr>
	                            </c:forEach>
	                            <c:if test="${apprLength<4}">
	                                <c:forEach var="i" begin="1" end="${4-apprLength}">
	                                    <tr>
	                                        <td></td>
	                                        <td></td>
	                                        <td></td>
	                                    </tr>
	                                </c:forEach>
	                            </c:if>
	                        </table>
	                    </td>
	                    <td class="color05">문서번호</td>
	                    <td>SHA-L-${mfgProcessDocNo }</td> <!-- 제조공정서 번호 -->
	                </tr>
	                <tr>
	                    <td rowspan="2"><span class="big_font">${productNamePrefix}${productDevDoc.productName}(${productDevDoc.productCode})/${mfgProcessDoc.plantName}</span></td>
	                    <td class="color05">제개정일</td>
	                    <td>${dateUtil:convertDate(mfgProcessDoc.modDate,"yyyy-MM-dd HH:mm:ss","yyyy-MM-dd")}</td>
	                </tr>
	                <tr>
	                    <td class="color05">제정판수</td>
	                    <td>${productDevDoc.docVersion}</td>
	                </tr>
	            </table>
	        </div>
	        <!-- 상단 머리정보 close-->
	        <!-- 부속정보 start-->
	        <div>
	        	<!-- <div class="watermark"><img src="/resources/images/watermark.png"></div> -->
	            <c:if test="${userUtil:getDeptCode(pageContext.request) != 'dept8' }">
	                <c:forEach items="${mfgProcessDoc.sub}" var="sub" varStatus="subStatus">
	                    <table width="100%" class="intable linetop">
	                        <tr>
	                            <td class="color05">  부속제품명  : ${sub.subProdName}  </td>
	                        </tr>
	                    </table>
	                    <!-- 배합비 2개씩 반복 --->
	                    <div class="hold">
	                        <table width="100%"  class="intable lineside" >
	                            <c:set var="mixLength" value="${fn:length(sub.mix)}" />
	                            <c:forEach items="${sub.mix}" var="mix" varStatus="status">
	                                <c:set var="rigthItemLength" value="${fn:length(sub.mix[status.index+1].item)}" />
	                                <c:if test="${status.index %2 == 0 }">
	                                    <tr>
	                                </c:if>
	                                <c:choose>
	                                    <c:when test="${status.index %2 == 0 }">
	                                        <td width="50%" style=" border-right:2px solid #000; vertical-align:top;">
	                                            <!-- 배합비 타이틀 start-->
	                                            <table width="100%"  class="intable04" >
	                                                <tr>
	                                                    <td class="color06">  배합비명  : ${mix.baseName}  </td>
	                                                </tr>
	                                            </table>
	                                            <!-- 배합비 타이틀 close-->
	                                            <c:choose>
	                                                <c:when test="${productDevDoc.productDocType == '0'}">
	                                                    <table width="100%" class="intable02">
	                                                        <colgroup>
	                                                            <col width="52%">
	                                                            <col width="12%">
	                                                            <col width="12%">
	                                                            <col width="12%">
	                                                            <col width="12%">
	                                                        </colgroup>
	                                                        <thead>
	                                                        <tr>
	                                                            <th>원료명</th>
	                                                            <th>코드번호</th>
	                                                            <th>배합%</th>
	                                                            <th>BOM</th>
	                                                            <th>스크랩(%)</th>
	                                                        </tr>
	                                                        </thead>
	                                                        <tbody>
	                                                        <c:set var="mixItemLength" value="${fn:length(mix.item)}" />
	                                                        <c:set var= "mixBomRateSum" value="0"/>
	                                                        <c:set var= "mixBomAmountSum" value="0"/>
	                                                        <c:forEach items="${mix.item}" var="item">
	                                                            <tr>
	                                                                <th>${strUtil:getHtmlBr(item.itemName)}</th>
	                                                                <td>${item.itemCode}</td>
	                                                                <td>
	                                                                    <c:choose>
	                                                                        <c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) == "13"}'>
	                                                                            ${item.bomAmount}
	                                                                        </c:when>
	                                                                        <c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
	                                                                            &nbsp;
	                                                                        </c:when>
	                                                                        <c:otherwise>
	                                                                            ${item.bomAmount}
	                                                                        </c:otherwise>
	                                                                    </c:choose>
	                                                                </td>
	                                                                <td>
	                                                                    <c:choose>
	                                                                        <c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) == "13"}'>
	                                                                            ${item.bomRate}
	                                                                        </c:when>
	                                                                        <c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
	                                                                            &nbsp;
	                                                                        </c:when>
	                                                                        <c:otherwise>
	                                                                            ${item.bomRate}
	                                                                        </c:otherwise>
	                                                                    </c:choose>
	                                                                </td>
	                                                                <td>
	                                                                    <c:choose>
	                                                                        <c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) == "13"}'>
	                                                                            ${item.scrap}
	                                                                        </c:when>
	                                                                        <c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
	                                                                            &nbsp;
	                                                                        </c:when>
	                                                                        <c:otherwise>
	                                                                            ${item.scrap}
	                                                                        </c:otherwise>
	                                                                    </c:choose>
	                                                                </td>
	                                                                <c:set var= "mixBomRateSum" value="${mixBomRateSum + item.bomRate}"/>
	                                                                <c:set var= "mixBomAmountSum" value="${mixBomAmountSum + item.bomAmount}"/>
	                                                            </tr>
	                                                        </c:forEach>
	                                                        <c:if test="${mixItemLength<rigthItemLength}">
	                                                            <c:forEach var="i" begin="1" end="${rigthItemLength - mixItemLength}">
	                                                                <tr>
	                                                                    <th></th>
	                                                                    <td></td>
	                                                                    <td></td>
	                                                                    <td></td>
	                                                                    <td></td>
	                                                                </tr>
	                                                            </c:forEach>
	                                                        </c:if>
	                                                        <tr>
	                                                            <th colspan="2">합계</th>
	                                                            <td>
	                                                                <c:choose>
	                                                                    <c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) == "13"}'>
	                                                                        <fmt:formatNumber value="${mixBomAmountSum}" pattern="0.000"/>
	                                                                    </c:when>
	                                                                    <c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
	                                                                        0.000
	                                                                    </c:when>
	                                                                    <c:otherwise>
	                                                                        <fmt:formatNumber value="${mixBomAmountSum}" pattern="0.000"/>
	                                                                    </c:otherwise>
	                                                                </c:choose>
	                                                            </td>
	                                                            <td>
	                                                                <c:choose>
	                                                                    <c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) == "13"}'>
	                                                                        <fmt:formatNumber value="${mixBomRateSum}" pattern="0.000"/>
	                                                                    </c:when>
	                                                                    <c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
	                                                                        0.000
	                                                                    </c:when>
	                                                                    <c:otherwise>
	                                                                        <fmt:formatNumber value="${mixBomRateSum}" pattern="0.000"/>
	                                                                    </c:otherwise>
	                                                                </c:choose>
	                                                            </td>
	                                                            <td>&nbsp;</td>
	                                                        </tr>
	                                                        <c:if test="${status.index<2}">
	                                                            <tr>
	                                                                <th colspan="2">기준수량</th>
	                                                                <td colspan="3">${sub.stdAmount}</td>
	                                                            </tr>
	                                                        </c:if>
	                                                        </tbody>
	                                                    </table>
	                                                </c:when>
	                                                <c:when test="${productDevDoc.productDocType == '1' or productDevDoc.productDocType == '2'}">
	                                                    <table width="100%" class="intable02">
	                                                        <colgroup>
	                                                            <col width="30%">
	                                                            <col width="20%">
	                                                            <col width="25%">
	                                                            <col width="25%">
	                                                        </colgroup>
	                                                        <thead>
	                                                        <tr>
	                                                            <th>원료명</th>
	                                                            <th>배합%</th>
	                                                            <th>제조사</th>
	                                                            <th>성분</th>
	                                                        </tr>
	                                                        </thead>
	                                                        <tbody>
	                                                        <c:set var="mixItemLength" value="${fn:length(mix.item)}" />
	                                                        <c:set var= "mixBomAmountSum" value="0"/>
	                                                        <c:forEach items="${mix.item}" var="item">
	                                                            <tr>
	                                                                <th>${strUtil:getHtmlBr(item.itemName)}</th>
	                                                                <td>${item.bomAmount}</td>
	                                                                <td>${item.manuCompany}</td>
	                                                                <td>${item.ingradient}</td>
	                                                                <c:set var= "mixBomAmountSum" value="${mixBomAmountSum + item.bomAmount}"/>
	                                                            </tr>
	                                                        </c:forEach>
	                                                        <c:if test="${mixItemLength<rigthItemLength}">
	                                                            <c:forEach var="i" begin="1" end="${rigthItemLength - mixItemLength}">
	                                                                <tr>
	                                                                    <th></th>
	                                                                    <td></td>
	                                                                    <td></td>
	                                                                    <td></td>
	                                                                </tr>
	                                                            </c:forEach>
	                                                        </c:if>
	                                                        <tr>
	                                                            <th>합계</th>
	                                                            <td><fmt:formatNumber value="${mixBomAmountSum}" pattern="0.###"/></td>
	                                                            <td>&nbsp;</td>
	                                                            <td>&nbsp;</td>
	                                                        </tr>
	                                                        </tbody>
	                                                    </table>
	                                                </c:when>
	                                                <c:otherwise></c:otherwise>
	                                            </c:choose>
	                                        </td>
	                                        <%-- <c:if test="${(mixLength-1 == status.index) && mixLength%2 == 1 }"> --%>
	                                        <c:if test="${ rigthItemLength == 0 }">
	                                            <td width="50%" style=" border-right:2px solid #000; vertical-align:top;">
	                                                <!-- 배합비 타이틀 start-->
	                                                <table width="100%"  class="intable04" >
	                                                    <tr>
	                                                        <td class="color06"> &nbsp;  </td>
	                                                    </tr>
	                                                </table>
	                                                <!-- 배합비 타이틀 close-->
	                                                <c:choose>
	                                                    <c:when test="${productDevDoc.productDocType == '0'}">
	                                                        <table width="100%" class="intable02">
	                                                            <colgroup>
	                                                                <col width="52%">
	                                                                <col width="12%">
	                                                                <col width="12%">
	                                                                <col width="12%">
	                                                                <col width="12%">
	                                                            </colgroup>
	                                                            <thead>
	                                                            <tr>
	                                                                <th>원료명</th>
	                                                                <th>코드번호</th>
	                                                                <th>배합%</th>
	                                                                <th>BOM</th>
	                                                                <th>스크랩(%)</th>
	                                                            </tr>
	                                                            </thead>
	                                                            <tbody>
	                                                            <c:forEach var="i" begin="1" end="${mixItemLength}">
	                                                                <tr>
	                                                                    <th></th>
	                                                                    <td></td>
	                                                                    <td></td>
	                                                                    <td></td>
	                                                                    <td></td>
	                                                                </tr>
	                                                            </c:forEach>
	                                                            <tr>
	                                                                <th colspan="2">합계</th>
	                                                                <td>&nbsp;</td>
	                                                                <td>&nbsp;</td>
	                                                                <td>&nbsp;</td>
	                                                            </tr>
	                                                            <c:if test="${status.index<2}">
	                                                                <tr>
	                                                                    <th colspan="2">분할중량</th>
	                                                                    <td colspan="3">${sub.divWeight} g</td>
	                                                                </tr>
	                                                            </c:if>
	                                                            </tbody>
	                                                        </table>
	                                                    </c:when>
	                                                    <c:when test="${productDevDoc.productDocType == '1' or productDevDoc.productDocType == '2'}">
	                                                        <table width="100%" class="intable02">
	                                                            <colgroup>
	                                                                <col width="30%">
	                                                                <col width="20%">
	                                                                <col width="25%">
	                                                                <col width="25%">
	                                                            </colgroup>
	                                                            <thead>
	                                                            <tr>
	                                                                <th>원료명</th>
	                                                                <th>배합%</th>
	                                                                <th>제조사</th>
	                                                                <th>성분</th>
	                                                            </tr>
	                                                            </thead>
	                                                            <tbody>
	                                                            <c:forEach var="i" begin="1" end="${mixItemLength}">
	                                                                <tr>
	                                                                    <th></th>
	                                                                    <td></td>
	                                                                    <td></td>
	                                                                    <td></td>
	                                                                </tr>
	                                                            </c:forEach>
	                                                            <tr>
	                                                                <th>합계</th>
	                                                                <td>&nbsp;</td>
	                                                                <td>&nbsp;</td>
	                                                                <td>&nbsp;</td>
	                                                            </tr>
	                                                            </tbody>
	                                                        </table>
	                                                    </c:when>
	                                                    <c:otherwise></c:otherwise>
	                                                </c:choose>
	                                            </td>
	                                        </c:if>
	                                    </c:when>
	                                    <c:otherwise>
	                                        <td width="50%" style=" border-right:2px solid #000; vertical-align:top;">
	                                            <!-- 배합비 타이틀 start-->
	                                            <table width="100%"  class="intable04" >
	                                                <tr>
	                                                    <td class="color06">  배합비명  : ${mix.baseName}  </td>
	                                                </tr>
	                                            </table>
	                                            <!-- 배합비 타이틀 close-->
	                                            <c:choose>
	                                                <c:when test="${productDevDoc.productDocType == '0'}">
	                                                    <table width="100%" class="intable02">
	                                                        <colgroup>
	                                                            <col width="52%">
	                                                            <col width="12%">
	                                                            <col width="12%">
	                                                            <col width="12%">
	                                                            <col width="12%">
	                                                        </colgroup>
	                                                        <thead>
	                                                        <tr>
	                                                            <th>원료명</th>
	                                                            <th>코드번호</th>
	                                                            <th>배합%</th>
	                                                            <th>BOM</th>
	                                                            <th>스크랩(%)</th>
	                                                        </tr>
	                                                        </thead>
	                                                        <tbody>
	                                                        <c:set var="mixItemLength2" value="${fn:length(mix.item)}" />
	                                                        <c:set var= "mixBomRateSum2" value="0"/>
	                                                        <c:set var= "mixBomAmountSum2" value="0"/>
	                                                        <c:forEach items="${mix.item}" var="item">
	                                                            <tr>
	                                                                <th>${strUtil:getHtmlBr(item.itemName)}</th>
	                                                                <td>${item.itemCode}</td>
	                                                                <td>
	                                                                    <c:choose>
	                                                                        <c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) == "13"}'>
	                                                                            ${item.bomAmount}
	                                                                        </c:when>
	                                                                        <c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
	                                                                            &nbsp;
	                                                                        </c:when>
	                                                                        <c:otherwise>
	                                                                            ${item.bomAmount}
	                                                                        </c:otherwise>
	                                                                    </c:choose>
	                                                                </td>
	                                                                <td>
	                                                                    <c:choose>
	                                                                        <c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) == "13"}'>
	                                                                            ${item.bomRate}
	                                                                        </c:when>
	                                                                        <c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
	                                                                            &nbsp;
	                                                                        </c:when>
	                                                                        <c:otherwise>
	                                                                            ${item.bomRate}
	                                                                        </c:otherwise>
	                                                                    </c:choose>
	                                                                </td>
	                                                                <td>
	                                                                    <c:choose>
	                                                                        <c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) == "13"}'>
	                                                                            ${item.scrap}
	                                                                        </c:when>
	                                                                        <c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
	                                                                            &nbsp;
	                                                                        </c:when>
	                                                                        <c:otherwise>
	                                                                            ${item.scrap}
	                                                                        </c:otherwise>
	                                                                    </c:choose>
	                                                                </td>
	                                                                <c:set var= "mixBomRateSum2" value="${mixBomRateSum2 + item.bomRate}"/>
	                                                                <c:set var= "mixBomAmountSum2" value="${mixBomAmountSum2 + item.bomAmount}"/>
	                                                            </tr>
	                                                        </c:forEach>
	                                                        <c:if test="${mixItemLength2<mixItemLength}">
	                                                            <c:forEach var="i" begin="1" end="${mixItemLength - mixItemLength2}">
	                                                                <tr>
	                                                                    <th></th>
	                                                                    <td></td>
	                                                                    <td></td>
	                                                                    <td></td>
	                                                                    <td></td>
	                                                                </tr>
	                                                            </c:forEach>
	                                                        </c:if>
	                                                        <tr>
	                                                            <th colspan="2">합계</th>
	                                                            <td>
	                                                                <c:choose>
	                                                                    <c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) == "13"}'>
	                                                                        <fmt:formatNumber value="${mixBomAmountSum2}" pattern="0.000"/>
	                                                                    </c:when>
	                                                                    <c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
	                                                                        0.000
	                                                                    </c:when>
	                                                                    <c:otherwise>
	                                                                        <fmt:formatNumber value="${mixBomAmountSum2}" pattern="0.000"/>
	                                                                    </c:otherwise>
	                                                                </c:choose>
	                                                            </td>
	                                                            <td>
	                                                                <c:choose>
	                                                                    <c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) == "13"}'>
	                                                                        <fmt:formatNumber value="${mixBomRateSum2}" pattern="0.000"/>
	                                                                    </c:when>
	                                                                    <c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
	                                                                        0.000
	                                                                    </c:when>
	                                                                    <c:otherwise>
	                                                                        <fmt:formatNumber value="${mixBomRateSum2}" pattern="0.000"/>
	                                                                    </c:otherwise>
	                                                                </c:choose>
	                                                            </td>
	                                                            <td>&nbsp;</td>
	                                                        </tr>
	                                                        <c:if test="${status.index<2}">
	                                                            <tr>
	                                                                <th colspan="2">분할중량</th>
	                                                                <td colspan="3">${sub.divWeight} g</td>
	                                                            </tr>
	                                                        </c:if>
	                                                        </tbody>
	                                                    </table>
	                                                </c:when>
	                                                <c:when test="${productDevDoc.productDocType == '1' or productDevDoc.productDocType == '2'}">
	                                                    <table width="100%" class="intable02">
	                                                        <colgroup>
	                                                            <col width="30%">
	                                                            <col width="20%">
	                                                            <col width="25%">
	                                                            <col width="25%">
	                                                        </colgroup>
	                                                        <thead>
	                                                        <tr>
	                                                            <th>원료명</th>
	                                                            <th>배합%</th>
	                                                            <th>제조사</th>
	                                                            <th>성분</th>
	                                                        </tr>
	                                                        </thead>
	                                                        <tbody>
	                                                        <c:set var= "mixBomAmountSum2" value="0"/>
	                                                        <c:set var="mixItemLength2" value="${fn:length(mix.item)}" />
	                                                        <c:forEach items="${mix.item}" var="item">
	                                                            <tr>
	                                                                <th>${strUtil:getHtmlBr(item.itemName)}</th>
	                                                                <td>${item.bomAmount}</td>
	                                                                <td>${item.manuCompany}</td>
	                                                                <td>${item.ingradient}</td>
	                                                                <c:set var= "mixBomAmountSum2" value="${mixBomAmountSum2 + item.bomAmount}"/>
	                                                            </tr>
	                                                        </c:forEach>
	                                                        <c:if test="${mixItemLength2<mixItemLength}">
	                                                            <c:forEach var="i" begin="1" end="${mixItemLength - mixItemLength2}">
	                                                                <tr>
	                                                                    <th></th>
	                                                                    <td></td>
	                                                                    <td></td>
	                                                                    <td></td>
	                                                                </tr>
	                                                            </c:forEach>
	                                                        </c:if>
	                                                        <tr>
	                                                            <th>합계</th>
	                                                            <td><fmt:formatNumber value="${mixBomAmountSum2}" pattern="0.###"/></td>
	                                                            <td> </td>
	                                                            <td>&nbsp;</td>
	                                                        </tr>
	                                                        </tbody>
	                                                    </table>
	                                                </c:when>
	                                                <c:otherwise></c:otherwise>
	                                            </c:choose>
	
	                                        </td>
	                                    </c:otherwise>
	                                </c:choose>
	                                <c:if test="${status.index == mixLength-1 or status.index%2 == 1 }">
	                                    </tr>
	                                </c:if>
	                            </c:forEach>
	                        </table>
	                    </div>
	                    <!-- 내용물 start -->
	                    <c:choose>
	                        <c:when test="${productDevDoc.productDocType == '0'}">
	                            <div class="hold">
	                                <table width="100%"  class="intable lineside" >
	                                    <c:set var="contLength" value="${fn:length(sub.cont)}" />
	                                    <c:forEach items="${sub.cont}" var="cont" varStatus="status">
	                                        <c:set var="rigthContLength" value="${fn:length(sub.cont[status.index+1].item)}" />
	                                        <c:if test="${status.index %2 == 0 }">
	                                            <tr>
	                                        </c:if>
	                                        <c:choose>
	                                            <c:when test="${status.index %2 == 0 }">
	                                                <td width="50%" style=" border-right:2px solid #000; vertical-align:top;">
	                                                    <!-- 배합비 타이틀 start-->
	                                                    <table width="100%"  class="intable04" >
	                                                        <tr>
	                                                            <td class="color07">  내용물  : ${cont.baseName}  </td>
	                                                        </tr>
	                                                    </table>
	                                                    <!-- 배합비 타이틀 close-->
	                                                    <table width="100%" class="intable02">
	                                                        <colgroup>
	                                                            <col width="52%">
	                                                            <col width="12%">
	                                                            <col width="12%">
	                                                            <col width="12%">
	                                                            <col width="12%">
	                                                        </colgroup>
	                                                        <thead>
	                                                        <tr>
	                                                            <th>원료명</th>
	                                                            <th>코드번호</th>
	                                                            <th>배합%</th>
	                                                            <th>BOM</th>
	                                                           	<th>스크랩(%)</th>
	                                                        </tr>
	                                                        </thead>
	                                                        <tbody>
	                                                        <c:set var="contItemLength" value="${fn:length(cont.item)}" />
	                                                        <c:set var= "contBomRateSum" value="0"/>
	                                                        <c:set var= "contBomAmountSum" value="0"/>
	                                                        <c:forEach items="${cont.item}" var="item">
	                                                            <tr>
	                                                               	<th>${strUtil:getHtmlBr(item.itemName)}</th>
	                                                                <td>${item.itemCode}</td>
	                                                                <td>
	                                                                    <c:choose>
	                                                                        <c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) == "13"}'>
	                                                                            ${item.bomAmount}
	                                                                        </c:when>
	                                                                        <c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
	                                                                            &nbsp;
	                                                                        </c:when>
	                                                                        <c:otherwise>
	                                                                            ${item.bomAmount}
	                                                                        </c:otherwise>
	                                                                    </c:choose>
	                                                                </td>
	                                                                <td>
	                                                                    <c:choose>
	                                                                        <c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) == "13"}'>
	                                                                            ${item.bomRate}
	                                                                        </c:when>
	                                                                        <c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
	                                                                            &nbsp;
	                                                                        </c:when>
	                                                                        <c:otherwise>
	                                                                            ${item.bomRate}
	                                                                        </c:otherwise>
	                                                                    </c:choose>
	                                                                </td>
	                                                                <td>
	                                                                    <c:choose>
	                                                                        <c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) == "13"}'>
	                                                                            ${item.scrap}
	                                                                        </c:when>
	                                                                        <c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
	                                                                            &nbsp;
	                                                                        </c:when>
	                                                                        <c:otherwise>
	                                                                            ${item.scrap}
	                                                                        </c:otherwise>
	                                                                    </c:choose>
	                                                                </td>
	                                                                <c:set var= "contBomRateSum" value="${contBomRateSum + item.bomRate}"/>
	                                                                <c:set var= "contBomAmountSum" value="${contBomAmountSum + item.bomAmount}"/>
	                                                            </tr>
	                                                        </c:forEach>
	                                                        <c:if test="${contItemLength<rigthContLength}">
	                                                            <c:forEach var="i" begin="1" end="${rigthContLength - contItemLength}">
	                                                                <tr>
	                                                                    <th>&nbsp; </th>
	                                                                    <td>&nbsp; </td>
	                                                                    <td>&nbsp; </td>
	                                                                    <td>&nbsp; </td>
	                                                                    <td>&nbsp; </td>
	                                                                </tr>
	                                                            </c:forEach>
	                                                        </c:if>
	                                                        <tr>
	                                                            <th colspan="2">합계</th>
	                                                            <td>
	                                                                <c:choose>
	                                                                    <c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) == "13"}'>
	                                                                        <fmt:formatNumber value="${contBomAmountSum}" pattern="0.000"/>
	                                                                    </c:when>
	                                                                    <c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
	                                                                        0.000
	                                                                    </c:when>
	                                                                    <c:otherwise>
	                                                                        <fmt:formatNumber value="${contBomAmountSum}" pattern="0.000"/>
	                                                                    </c:otherwise>
	                                                                </c:choose>
	                                                            </td>
	                                                            <td>
	                                                                <c:choose>
	                                                                    <c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) == "13"}'>
	                                                                        <fmt:formatNumber value="${contBomRateSum}" pattern="0.000"/>
	                                                                    </c:when>
	                                                                    <c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
	                                                                        0.000
	                                                                    </c:when>
	                                                                    <c:otherwise>
	                                                                        <fmt:formatNumber value="${contBomRateSum}" pattern="0.000"/>
	                                                                    </c:otherwise>
	                                                                </c:choose>
	                                                            </td>
	                                                            <td>&nbsp;</td>
	                                                        </tr>
	                                                        <tr>
	                                                            <th colspan="2">${cont.baseName}중량(g)</th>
	                                                            <td colspan="3">
	                                                                    ${cont.divWeight}
	                                                            </td>
	                                                        </tr>
	                                                        </tbody>
	                                                    </table>
	                                                </td>
	                                                <%-- <c:if test="${(contLength-1 == status.index) && contLength%2 == 1 }"> --%>
	                                                <c:if test="${ rigthContLength == 0 }">
	                                                    <td width="50%" style=" border-right:2px solid #000; vertical-align:top;">
	                                                        <!-- 배합비 타이틀 start-->
	                                                        <table width="100%"  class="intable04" >
	                                                            <tr>
	                                                                <td class="color07">  &nbsp;  </td>
	                                                            </tr>
	                                                        </table>
	                                                        <!-- 배합비 타이틀 close-->
	                                                        <table width="100%" class="intable02">
	                                                            <colgroup>
	                                                                <col width="52%">
	                                                                <col width="12%">
	                                                                <col width="12%">
	                                                                <col width="12%">
	                                                                <col width="12%">
	                                                            </colgroup>
	                                                            <thead>
	                                                            <tr>
	                                                                <th>원료명</th>
	                                                                <th>코드번호</th>
	                                                                <th>배합%</th>
	                                                                <th>BOM</th>
	                                                                <th>스크랩(%)</th>
	                                                            </tr>
	                                                            </thead>
	                                                            <tbody>
	                                                            <c:forEach var="i" begin="1" end="${contItemLength}">
	                                                                <tr>
	                                                                    <th>&nbsp; </th>
	                                                                    <td>&nbsp; </td>
	                                                                    <td>&nbsp; </td>
	                                                                    <td>&nbsp; </td>
	                                                                    <td>&nbsp; </td>
	                                                                </tr>
	                                                            </c:forEach>
	                                                            <tr>
	                                                                <th colspan="2">합계</th>
	                                                                <td>&nbsp; </td>
	                                                                <td>&nbsp; </td>
	                                                                <td>&nbsp; </td>
	                                                            </tr>
	                                                            <tr>
	                                                                <th colspan="2"></th>
	                                                                <td colspan="3">&nbsp; </td>
	                                                            </tr>
	                                                            </tbody>
	                                                        </table>
	                                                    </td>
	                                                </c:if>
	                                            </c:when>
	                                            <c:otherwise>
	                                                <!-- 배합비 타이틀 start-->
	                                                <td width="50%" style=" border-right:2px solid #000; vertical-align:top;">
	                                                    <table width="100%"  class="intable04" >
	                                                        <tr>
	                                                            <td class="color07">  내용물  : ${cont.baseName}  </td>
	                                                        </tr>
	                                                    </table>
	                                                    <!-- 배합비 타이틀 close-->
	                                                    <table width="100%" class="intable02">
	                                                        <colgroup>
	                                                            <col width="52%">
	                                                            <col width="12%">
	                                                            <col width="12%">
	                                                            <col width="12%">
	                                                            <col width="12%">
	                                                        </colgroup>
	                                                        <thead>
	                                                        <tr>
	                                                            <th>원료명</th>
	                                                            <th>코드번호</th>
	                                                            <th>배합%</th>
	                                                            <th>BOM</th>
	                                                            <th>스크랩(%)</th>
	                                                        </tr>
	                                                        </thead>
	                                                        <tbody>
	                                                        <c:set var="contItemLength2" value="${fn:length(cont.item)}" />
	                                                        <c:set var= "contBomRateSum2" value="0"/>
	                                                        <c:set var= "contBomAmountSum2" value="0"/>
	                                                        <c:forEach items="${cont.item}" var="item">
	                                                            <tr>
	                                                                <th>${strUtil:getHtmlBr(item.itemName)}</th>
	                                                                <td>${item.itemCode}</td>
	                                                                <td>
	                                                                    <c:choose>
	                                                                        <c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) == "13"}'>
	                                                                            ${item.bomAmount}
	                                                                        </c:when>
	                                                                        <c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
	                                                                            &nbsp;
	                                                                        </c:when>
	                                                                        <c:otherwise>
	                                                                            ${item.bomAmount}
	                                                                        </c:otherwise>
	                                                                    </c:choose>
	                                                                </td>
	                                                                <td>
	                                                                    <c:choose>
	                                                                        <c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) == "13"}'>
	                                                                            ${item.bomRate}
	                                                                        </c:when>
	                                                                        <c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
	                                                                            &nbsp;
	                                                                        </c:when>
	                                                                        <c:otherwise>
	                                                                            ${item.bomRate}
	                                                                        </c:otherwise>
	                                                                    </c:choose>
	                                                                </td>
	                                                                <td>
	                                                                    <c:choose>
	                                                                        <c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) == "13"}'>
	                                                                            ${item.scrap}
	                                                                        </c:when>
	                                                                        <c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
	                                                                            &nbsp;
	                                                                        </c:when>
	                                                                        <c:otherwise>
	                                                                            ${item.scrap}
	                                                                        </c:otherwise>
	                                                                    </c:choose>
	                                                                </td>
	                                                                <c:set var= "contBomRateSum2" value="${contBomRateSum2 + item.bomRate}"/>
	                                                                <c:set var= "contBomAmountSum2" value="${contBomAmountSum2 + item.bomAmount}"/>
	                                                            </tr>
	                                                        </c:forEach>
	                                                        <c:if test="${contItemLength>contItemLength2}">
	                                                            <c:forEach var="i" begin="1" end="${contItemLength-contItemLength2}">
	                                                                <tr>
	                                                                    <th>&nbsp; </th>
	                                                                    <td>&nbsp; </td>
	                                                                    <td>&nbsp; </td>
	                                                                    <td>&nbsp; </td>
	                                                                    <td>&nbsp; </td>
	                                                                </tr>
	                                                            </c:forEach>
	                                                        </c:if>
	                                                        <tr>
	                                                            <th colspan="2">합계</th>
	                                                            <td>
	                                                                <c:choose>
	                                                                    <c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) == "13"}'>
	                                                                        <fmt:formatNumber value="${contBomAmountSum2}" pattern="0.000"/>
	                                                                    </c:when>
	                                                                    <c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
	                                                                        0.000
	                                                                    </c:when>
	                                                                    <c:otherwise>
	                                                                        <fmt:formatNumber value="${contBomAmountSum2}" pattern="0.000"/>
	                                                                    </c:otherwise>
	                                                                </c:choose>
	                                                            </td>
	                                                            <td>
	                                                                <c:choose>
	                                                                    <c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) == "13"}'>
	                                                                        <fmt:formatNumber value="${contBomRateSum2}" pattern="0.000"/>
	                                                                    </c:when>
	                                                                    <c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
	                                                                        0.000
	                                                                    </c:when>
	                                                                    <c:otherwise>
	                                                                        <fmt:formatNumber value="${contBomRateSum2}" pattern="0.000"/>
	                                                                    </c:otherwise>
	                                                                </c:choose>
	                                                            </td>
	                                                            <td>&nbsp;</td>
	                                                        </tr>
	                                                        <tr>
	                                                            <th colspan="2">${cont.baseName}중량(g)</th>
	                                                            <td colspan="3">
	                                                                    ${cont.divWeight}
	                                                            </td>
	                                                        </tr>
	                                                        </tbody>
	                                                    </table>
	                                                </td>
	                                            </c:otherwise>
	                                        </c:choose>
	                                        <c:if test="${status.index == contLength-1 or status.index%2 == 1 }">
	                                            </tr>
	                                        </c:if>
	                                    </c:forEach>
	                                </table>
	                            </div>
	                        </c:when>
	                        <c:when test="${productDevDoc.productDocType == '1' or productDevDoc.productDocType == '2'}"></c:when>
	                        <c:otherwise></c:otherwise>
	                    </c:choose>
	                    <!-- 내용물 end -->
	                </c:forEach>
	            </c:if>
	        </div>
	        <!-- 부속제품  close-->
	
	        <c:choose>
	            <c:when test="${productDevDoc.productDocType == '0'}">
	                <!-- 표시사항배합비,제조방법,제품사진,제조방법 start-->
	                <div class="hold">
	                	<!-- <div class="watermark"><img src="/resources/images/watermark.png"></div> -->
	                    <table class="intable lineside" width="100%">
	                        <colgroup>
	                            <col width="50%">
	                            <col width="50%">
	                        </colgroup>
	                        <tr >
	                            <td class="color05" style="border-right:2px solid #000"> 재료 </td>
	                            <td class="color05"> 표시사항 배합비  </td>
	                        </tr>
	                        <tr>
	                            <td valign="top" style="border-right:2px solid #000">
	                                <table width="100%" class="intable02">
	                                    <colgroup>
											<col width="53%">
											<col width="12%">
											<col width="12%">
											<col width="12%">
											<col width="12%">
	                                    </colgroup>
	                                    <thead>
	                                   	<tr style="border: 1px solid #666">
	                                        <th>재료명</th>
	                                        <th>코드번호</th>
	                                        <th>재료사양</th>
	                                        <th>BOM</th>
											<th>스크랩(%)</th>
	                                    </tr>
	                                    </thead>
	                                    <tbody>
	                                    <c:forEach items="${mfgProcessDoc.pkg}" var="pkg">
	                                        <tr>
	                                            <th>${strUtil:getHtmlBr(pkg.itemName)}</th>
	                                            <td>${pkg.itemCode}</td>
	                                            <td>${pkg.bomRate}(${pkg.unit})</td>
	                                            <td>${pkg.bomRate}</td>
												<td>${pkg.scrap}</td>
	                                        </tr>
	                                        <c:set var= "bomRateSum" value="${bomRateSum + pkg.bomRate}"/>
	                                    </c:forEach>
										<tr>
												<%--
                                                <th>합계</th>
                                                <td>&nbsp;</td>
                                                <td><fmt:formatNumber value="${bomRateSum}" pattern="0.00"/></td>
                                                 --%>
										</tr>
	                                    </tbody>
	                                </table>
	                            </td>
	                            <td valign="top" style="border-right:2px solid #000">
	                                <table width="100%" class="intable02">
	                                    <colgroup>
	                                        <col width="69%">
	                                        <col width="16%">
	                                        <col width="16%">
	                                    </colgroup>
	                                    <thead>
	                                    <tr>
	                                        <th>원료명</th>
	                                        <th>백분율</th>
	                                        <th>급수포함</th>
	                                    </tr>
	                                    </thead>
	                                    <tbody>
	                                    <c:forEach items="${mfgProcessDoc.disp}" var="disp">
	                                        <tr>
	                                            <th>${disp.matName}</th>
	                                            <td><fmt:formatNumber value="${disp.excRate}" pattern="0.####" minFractionDigits="4"/></td>
	                                            <td><fmt:formatNumber value="${disp.incRate}" pattern="0.####" minFractionDigits="4"/></td>
	                                        </tr>
	                                        <c:set var= "excRateSum" value="${excRateSum + disp.excRate}"/>
	                                        <c:set var= "incRateSum" value="${incRateSum + disp.incRate}"/>
	                                    </c:forEach>
	                                    <tr>
	                                        <th>합계</th>
	                                        <td><fmt:formatNumber value="${excRateSum}" pattern="0.####" minFractionDigits="4"/></td>
	                                        <td><fmt:formatNumber value="${incRateSum}" pattern="0.####" minFractionDigits="4"/></td>
	                                    </tr>
	                                    </tbody>
	                                </table>
	                            </td>
	                        </tr>
	                    </table>
	                    <table class="intable lineside" width="100%">
	                        <colgroup>
	                            <col width="32%">
	                            <col width="38%">
	                            <col width="30%">
	                        </colgroup>
	                        <tr >
	                            <td class="color05" style="border-right:2px solid #000"> 제조방법 </td>
	                            <td class="color05" style="border-right:2px solid #000"> 제조규격 </td>
	                            <td class="color05"> 제품사진 </td>
	                        </tr>
	                        <tr>
	                            <td valign="top" style="border-right:2px solid #000; text-align:left; padding:10px;">
	                                    ${strUtil:getHtmlBr(mfgProcessDoc.menuProcess)}
	                            </td>
	                            <td valign="top" style="border-right:2px solid #000; text-align:left; padding:10px;">
	                                    ${strUtil:getHtmlBr(mfgProcessDoc.standard)}
	                            </td>
	                            <td valign="top">
	                                <c:choose>
	                                    <c:when test="${productDevDoc.imageFileName != null and productDevDoc.imageFileName != ''}">
	                                        <c:if test="${productDevDoc.isOldImage == 'Y'}">
	                                            <img src="/oldFile/devDoc/${strUtil:getDevdocFileName(productDevDoc.oldFileName)}" style="width:100%; height:auto; max-height:200px;">
	                                        </c:if>
	                                        <c:if test="${productDevDoc.isOldImage != 'Y'}">
	                                            <img src="/devDocImage/${strUtil:getDevdocFileName(productDevDoc.imageFileName)}" style="width:100%; height:auto; max-height:200px;">
	                                        </c:if>
	                                    </c:when>
	                                    <c:otherwise>
	                                        <img src="/resources/images/img_noimg.png" style="width:100%; height:auto; max-height:200px;">
	                                    </c:otherwise>
	                                </c:choose>
	                            </td>
	                        </tr>
	                    </table>
	                </div>
	                <!-- 표시사항배합비,제조방법,제품사진,제조방법 close-->
	                
	               	<!-- 제품규격 start -->
					<div class="hold">
						<table class="intable04 linebottom" width="100%">
							<colgroup>
								<col width="16%">
								<col width="17%">
								<col width="16%"/>
								<col width="17%">
								<col width="16%">
								<col width="12%">
								<col width="6%">
	
							</colgroup>
							<tr>
								<td colspan="7" class="color05"> 제품규격 </td>
							</tr>
							
							<%-- 전체 /크기 --%>
							<tr>
								<th>전체</th>
								<td>크기</td>
								<td colspan="4">${strUtil:getHtmlBr(mfgProcessDoc.spec.size)}</td>
								<td>± ${mfgProcessDoc.spec.sizeErr} %</td>
							</tr>
							<%-- 성상 /토핑 --%>
							<tr>
								<th>성상</th>
								<td>토핑,착색,흐름성 </td>
								<td colspan="4">${mfgProcessDoc.spec.feature}</td>
								<td></td>
							</tr>
							
							<%-- 전체 / 내용물 --%>
							<c:if test="${mfgProcessDoc.spec.hasProduct or mfgProcessDoc.spec.hasContent}">
								<tr>
									<th rowspan="6">전체</th>
									<td>수분(%)</td>
									<td>${mfgProcessDoc.spec.productWater}</td>
									<th rowspan="6">내용물</th>
									<td>수분(%)</td>
									<td>${mfgProcessDoc.spec.contentWater}</td>
									<td>± ${mfgProcessDoc.spec.contentWaterErr}</td>
								</tr>
								<tr>
									<td>AW</td>
									<td>${mfgProcessDoc.spec.productAw}</td>
									<td>AW</td>
									<td>${mfgProcessDoc.spec.contentAw}</td>
									<td>± ${mfgProcessDoc.spec.contentAwErr}</td>
								</tr>
								<tr>
									<td>pH</td>
									<td>${mfgProcessDoc.spec.productPh}</td>
									<td>pH</td>
									<td>${mfgProcessDoc.spec.contentPh}</td>
									<td>± ${mfgProcessDoc.spec.contentPhErr}</td>
								</tr>
								<tr>
									<td>염도</td><!-- 명도 >> 염도 -->
									<td>${mfgProcessDoc.spec.productBrightness}</td>
									<td>염도</td>
									<td>${mfgProcessDoc.spec.contentSalinity}</td>
									<td>± ${mfgProcessDoc.spec.contentSalinityErr}</td>
								</tr>
								<tr>
									<td>당도</td><!-- 색도 >> 당도  -->
									<td>${mfgProcessDoc.spec.productTone}</td>
									<td>당도</td>
									<td>${mfgProcessDoc.spec.contentBrix}</td>
									<td>± ${mfgProcessDoc.spec.contentBrixErr}</td>
								</tr>
								<tr>
									<td>점도</td><!-- Hardness >> 점도 -->
									<td>${mfgProcessDoc.spec.productHardness}</td>
									<td>Hardness</td><!-- 색도 >> Hardness  -->
									<td>${mfgProcessDoc.spec.contentTone}</td>
									<td>± ${mfgProcessDoc.spec.contentToneErr}</td>
								</tr>
							</c:if>
							
							<%-- 국수(면류) --%>
							<c:if test="${mfgProcessDoc.spec.hasNoodles}">
								<tr> 
									<th>전체</th>
									<td>기타 관리규격</td><!-- 산도 >> 기타관리 규격 -->
									<td colspan="4">${mfgProcessDoc.spec.noodlesAcidity}</td>
									<td></td>
								</tr>
								
								<tr>
									<th rowspan="2">국수(면류)<br /> * 주정침지제품에<br />한함.
									</th>
									<td>수분(%)</td>
									<td colspan="4">${mfgProcessDoc.spec.noodlesWater}</td>
									<td></td>
								</tr>
								<tr>
									<td>pH</td>
									<td colspan="4">${mfgProcessDoc.spec.noodlesPh}</td>
									<td></td>
								</tr>
							</c:if>
							
							<%-- 탈산소제 --%>
							<c:if test="${mfgProcessDoc.spec.deoxidizer != '' and mfgProcessDoc.spec.deoxidizer != null}">
								<tr>
									<th style="border-left: none;" colspan="2">탈산소제</th>
									<td colspan="4">${mfgProcessDoc.spec.deoxidizer}</td>
									<td></td>
								</tr>
							</c:if>
							
							<%-- 질소충전제품 --%>
							<c:if test="${mfgProcessDoc.spec.nitrogenous != '' and mfgProcessDoc.spec.nitrogenous != null}">
								<tr>
									<th style="border-left: none;" colspan="2">질소충전제품</th>
									<td colspan="4">${mfgProcessDoc.spec.nitrogenous}</td>
									<td></td>
								</tr>
							</c:if>
						</table>
					</div>
					<!-- 제품규격 close -->
	                
	                <!-- 비고 start-->
	                <div class="hold">
	                    <table class="intable04 linebottom" width="100%">
	                        <colgroup>
	                            <col width="16%">
	                            <col width="17%">
	                            <col width="16%">
	                            <col width="17%">
	                            <col width="16%">
	                            <col width="18%">
	                        </colgroup>
	                        <tr>
								<td colspan="4" class="color05"> 관련정보 </td>
								<td colspan="2" class="color05"> 품목제조보고서 정보 </td>
								
							</tr>
							<c:choose>
								<c:when test="${fn:trim(mfgProcessDoc.calcType) == '3' or fn:trim(mfgProcessDoc.calcType) == '7'}">
								<tr>
									<th>생산라인</th>
									<td>${mfgProcessDoc.lineName}</td>
									<th>BOM 수율</th>
									<td>${mfgProcessDoc.bomRate} %</td>
									<th>품목제조보고서명</th>
									<td>
										<c:choose>
											<c:when test="${manufacturingNoData.manufacturingNo != '' && manufacturingNoData.manufacturingNo != null}">
												${manufacturingNoData.manufacturingName}
											</c:when>
											<c:otherwise>
												${mfgProcessDoc.docProdName}
											</c:otherwise>
										</c:choose>
									</td>
								</tr>
								<c:if test="${fn:trim(mfgProcessDoc.calcType) != '7' }">
								<tr>
									<th></th><!-- 배합중량 -->
									<td></td><!-- ${mfgProcessDoc.mixWeight} Kg (${mfgProcessDoc.bagAmout} 포) -->
									<th></th><!-- 분할중량총합계(g) -->
									<td></td><!-- ${mfgProcessDoc.totWeight} g -->
									<th>품목제조보고번호</th>
									<td>
										<c:choose>
											<c:when test="${manufacturingNoData.manufacturingNo != '' && manufacturingNoData.manufacturingNo != null}">
												${manufacturingNoData.licensingNo}-${manufacturingNoData.manufacturingNo}
											</c:when>
											<c:otherwise>
												${mfgProcessDoc.regNum}
											</c:otherwise>
										</c:choose>
									</td>
								</tr>
								<tr>
									<th></th><!-- 봉당 들이수 -->
									<td></td><!-- ${mfgProcessDoc.numBong} /ea -->
									<th>성상</th>
									<td>${mfgProcessDoc.ingredient}</td>
									<th>식품유형</th>
									<td>
										<c:choose>
											<c:when test="${manufacturingNoData.manufacturingNo != '' && manufacturingNoData.manufacturingNo != null}">
												${manufacturingNoData.productType1Name}
												<c:if test="${manufacturingNoData.productType2Name != '' && manufacturingNoData.productType2Name != null }">
													&gt; ${manufacturingNoData.productType2Name}
												</c:if>
												<c:if test="${manufacturingNoData.productType3Name != '' && manufacturingNoData.productType3Name != null }">
													&gt; ${manufacturingNoData.productType3Name}
												</c:if>
											</c:when>
											<c:otherwise>
												${productDevDoc.productType1Text}
												<c:if test="${productDevDoc.productType2Text != '' && productDevDoc.productType2Text != null }">
													&gt; ${productDevDoc.productType2Text}
												</c:if>
												<c:if test="${productDevDoc.productType3Text != '' && productDevDoc.productType3Text != null }">
													&gt; ${productDevDoc.productType3Text}
												</c:if>
												<c:if test="${(productDevDoc.sterilizationText != '' && productDevDoc.sterilizationText != null) && (productDevDoc.etcDisplayText != '' && productDevDoc.etcDisplayText != null)}">
													&lpar;
													${(productDevDoc.sterilizationText != '' && productDevDoc.sterilizationText != null)? productDevDoc.sterilizationText : '-'}
													&sol;
													${(productDevDoc.etcDisplayText != '' && productDevDoc.etcDisplayText != null)? productDevDoc.etcDisplayText : '-'}
													&rpar;
												</c:if>
											</c:otherwise>
										</c:choose>
									</td>
								</tr>
								<tr>
									<th></th><!-- 상자 들이수 -->
									<td></td><!-- ${mfgProcessDoc.numBox} -->
									<th></th><!-- 소성손실(g/%) -->
									<td></td><!-- ${mfgProcessDoc.loss} % -->
									<th>보관조건</th>
									<td>
										<c:choose>
											<c:when test="${manufacturingNoData.manufacturingNo != '' && manufacturingNoData.manufacturingNo != null}">
												<c:if test="${manufacturingNoData.keepConditionText == '' || manufacturingNoData.keepConditionText == null}">
													${manufacturingNoData.keepConditionName}
												</c:if>
												<c:if test="${manufacturingNoData.keepConditionText != '' && manufacturingNoData.keepConditionText != null}">
													${manufacturingNoData.keepConditionText}
												</c:if>
											</c:when>
											<c:otherwise>
												${mfgProcessDoc.keepCondition}
											</c:otherwise>
										</c:choose>
									</td>
								</tr>
								
								<tr>
									<th>완제중량</th>
									<td>
											${mfgProcessDoc.compWeight} ${mfgProcessDoc.compWeightUnit}
										<c:if test='${mfgProcessDoc.compWeightText != null && mfgProcessDoc.compWeightText != ""}'> (${mfgProcessDoc.compWeightText})</c:if>
									</td>
									<th>소비기한(현장)</th>
									<td>${mfgProcessDoc.distPeriSite}</td>
									<th>소비기한(등록서류)</th>
									<td>
										<c:choose>
											<c:when test="${manufacturingNoData.manufacturingNo != '' && manufacturingNoData.manufacturingNo != null}">
												${manufacturingNoData.sellDate1Text}&nbsp;${manufacturingNoData.sellDate2}&nbsp;${manufacturingNoData.sellDate3Text}
											</c:when>
											<c:otherwise>
												${mfgProcessDoc.distPeriDoc}
											</c:otherwise>
										</c:choose>
									</td>
								</tr>
								<tr>
									<th>관리중량</th>
									<td>${mfgProcessDoc.adminWeightFrom} ${mfgProcessDoc.adminWeightUnitFrom}
										~ ${mfgProcessDoc.adminWeightTo} ${mfgProcessDoc.adminWeightUnitTo}</td>
									<th>제조공정도 유형</th>
									<td>${mfgProcessDoc.lineProcessType}</td>
									<th>용도용법</th>
									<td>${mfgProcessDoc.usage}</td>
								</tr>
								<tr>
									<th>표기중량</th>
									<td>
										${mfgProcessDoc.dispWeight} ${mfgProcessDoc.dispWeightUnit}
										<c:if test='${mfgProcessDoc.dispWeightText != null && mfgProcessDoc.dispWeightText != ""}'> (${mfgProcessDoc.dispWeightText})</c:if>
									</td>
									<th>QNS 등록번호</th>
									<td>${mfgProcessDoc.qns}</td>
									<th>포장재질</th>
									<td>
										<c:choose>
											<c:when test="${manufacturingNoData.manufacturingNo != '' && manufacturingNoData.manufacturingNo != null}">
												${manufacturingNoData.packageUnitNames}
												<c:if test="${manufacturingNoData.packageEtc != '' || manufacturingNoData.packageEtc != null}">
													(${manufacturingNoData.packageEtc})
												</c:if>
											</c:when>
											<c:otherwise>
												${mfgProcessDoc.packMaterial}
											</c:otherwise>
										</c:choose>
									</td>
								</tr>
								<tr>
									<th rowspan="2">비고</th>
										<c:if test="${mfgProcessDoc.calcType == '3'}">
											<td rowspan="2" colspan="3" style="border-right:2px solid #000; text-align:left;">${strUtil:getHtmlBr(mfgProcessDoc.noteText)}</td>
										</c:if>
										<c:if test="${mfgProcessDoc.calcType != '3'}">
											<td rowspan="2" colspan="3">${mfgProcessDoc.note}</td>
										</c:if>
									<th>품목제조보고서 포장단위</th>
									<td>${mfgProcessDoc.packUnit}</td>	
								</tr>
								<tr>
									<th>어린이 기호식품 <br/>고열량 저영양 해당유무</th>
									<td>
										[<c:if test="${mfgProcessDoc.childHarm == '1'}">●</c:if>]예   [<c:if test="${mfgProcessDoc.childHarm == '2'}">●</c:if>]아니오   [<c:if test="${mfgProcessDoc.childHarm == '3'}">●</c:if>]해당 없음
									</td>
								</tr>
								</c:if>
								</c:when>
								
								<c:otherwise>
									<tr>
			                            <th>생산라인</th>
			                            <td>${mfgProcessDoc.lineName}</td>
										<th>BOM 수율</th>
										<td>${mfgProcessDoc.bomRate} %</td>
										<th>품목제조보고서명</th>
			                            <td>${mfgProcessDoc.docProdName}</td>
			                        </tr>
			                        <tr>
										<th>배합중량</th>
										<td>${mfgProcessDoc.mixWeight} Kg (${mfgProcessDoc.bagAmout} 포)</td>
										<th>분할중량총합계(g)</th>
										<td>${mfgProcessDoc.totWeight} g</td>
										<th>품목제조보고번호</th>
			                            <td>${mfgProcessDoc.regNum}</td>
			                        </tr>
			                        <tr>
			                            <th>봉당 들이수</th>
										<td>${mfgProcessDoc.numBong} /ea</td>
										<th>성상</th>
										<td>${mfgProcessDoc.ingredient}</td>
										<th>식품유형</th>
			                            <td colspan="3">
			                                    ${productDevDoc.productType1Text}
			                                <c:if test="${productDevDoc.productType2Text != '' && productDevDoc.productType2Text != null }">
			                                    &gt; ${productDevDoc.productType2Text}
			                                </c:if>
			                                <c:if test="${productDevDoc.productType3Text != '' && productDevDoc.productType3Text != null }">
			                                    &gt; ${productDevDoc.productType3Text}
			                                </c:if>
			                                <c:if test="${(productDevDoc.sterilizationText != '' && productDevDoc.sterilizationText != null) && (productDevDoc.etcDisplayText != '' && productDevDoc.etcDisplayText != null)}">
			                                    &lpar;
			                                    ${(productDevDoc.sterilizationText != '' && productDevDoc.sterilizationText != null)? productDevDoc.sterilizationText : '-'}
			                                    &sol;
			                                    ${(productDevDoc.etcDisplayText != '' && productDevDoc.etcDisplayText != null)? productDevDoc.etcDisplayText : '-'}
			                                    &rpar;
			                                </c:if>
			                            </td>
			                        </tr>
			                        <tr>
			                            <th>상자 들이수</th>
										<td>${mfgProcessDoc.numBox}</td>
										<th>소성손실(g/%)</th>
										<td>${mfgProcessDoc.loss} %</td>
										<th>보관조건</th>
			                            <td>${mfgProcessDoc.keepCondition}</td>
			                        </tr>
			                        <tr>
			                           	<th>완제중량</th>
			                            <td>${mfgProcessDoc.compWeight} ${mfgProcessDoc.compWeightUnit}</td>
			                            <th>소비기한(현장)</th>
										<td>${mfgProcessDoc.distPeriSite}</td>
			                            <th>소비기한(등록서류)</th>
			                            <td>${mfgProcessDoc.distPeriDoc}</td>
		
			                        </tr>
			                        <tr>
			                            <th>관리중량</th>
										<td>${mfgProcessDoc.adminWeightFrom} ${mfgProcessDoc.adminWeightUnitFrom}
											~ ${mfgProcessDoc.adminWeightTo} ${mfgProcessDoc.adminWeightUnitTo}</td>
										<th>제조공정도 유형</th>
										<td>${mfgProcessDoc.lineProcessType}</td>
										<th>용도용법</th>
										<td>${mfgProcessDoc.usage}</td>
			                        </tr>
			                        <tr>
			                            <th>표기중량</th>
										<td>${mfgProcessDoc.dispWeight} ${mfgProcessDoc.dispWeightUnit}</td>
										<th>QNS 등록번호</th>
										<td>${mfgProcessDoc.qns}</td>
										<th>포장재질</th>
										<td>${mfgProcessDoc.packMaterial}</td>
			                        </tr>
			                        <tr>
			                            <th rowspan="2">비고</th>
										<td rowspan="2" colspan="3">${mfgProcessDoc.note}</td>
										<th>품목제조보고서 포장단위</th>
										<td>${mfgProcessDoc.packUnit}</td>
			                        </tr>
			                        <tr>
			                           <th>어린이 기호식품 <br/>고열량 저영양 해당유무</th>
										<td>
											[<c:if test="${mfgProcessDoc.childHarm == '1'}">●</c:if>]예   [<c:if test="${mfgProcessDoc.childHarm == '2'}">●</c:if>]아니오   [<c:if test="${mfgProcessDoc.childHarm == '3'}">●</c:if>]해당 없음
										</td>
			                        </tr>
								</c:otherwise>
							</c:choose>
	                    </table>
	                </div>
	                <!--비고 close-->
					<!-- 제품규격(밀다원) start-->
					<c:if test="${fn:trim(mfgProcessDoc.calcType) == '3' or fn:trim(mfgProcessDoc.calcType) == '7'}">
						<div class="hold">
							<table class="intable04 linebottom" width="100%">
								<colgroup>
									<col width="16%">
									<col width="17%">
									<col width="16%">
									<col width="17%">
									<col width="16%">
									<col width="18%">
								</colgroup>
								<tr>
									<td colspan="6" class="color05"> 제품규격(밀다원) </td>
								</tr>
								<tr>
									<th>Moisture(%)</th>
									<td>
											${mfgProcessDoc.specMD.moisture}
										<c:if test="${fn:length(mfgProcessDoc.specMD.moisture) > 0}">
											${mfgProcessDoc.specMD.moistureUnit == 'gt' ? '↑' : '↓'}
										</c:if>
									</td>
									<th>Ash(%)</th>
									<td>
										<c:if test="${fn:length(mfgProcessDoc.specMD.ashFrom) > 0 or fn:length(mfgProcessDoc.specMD.ashTo) > 0}">
											${mfgProcessDoc.specMD.ashFrom} ~ ${mfgProcessDoc.specMD.ashTo}
										</c:if>
									</td>
									<th>Protein(%)</th>
									<td>
											${mfgProcessDoc.specMD.protein}
										<c:if test="${fn:length(mfgProcessDoc.specMD.proteinErr) > 0}">
											± ${mfgProcessDoc.specMD.proteinErr}
										</c:if>
									</td>
								</tr>
								<tr>
									<th>Water absorption(%)</th>
									<td>
										<c:if test="${fn:length(mfgProcessDoc.specMD.waterAbsFrom) > 0 or fn:length(mfgProcessDoc.specMD.waterAbsTo) > 0}">
											${mfgProcessDoc.specMD.waterAbsFrom} ~ ${mfgProcessDoc.specMD.waterAbsTo}
										</c:if>
									</td>
									<th>Stability(min)</th>
									<td>
										<c:if test="${fn:length(mfgProcessDoc.specMD.stabilityFrom) > 0 or fn:length(mfgProcessDoc.specMD.stabilityTo) > 0}">
											${mfgProcessDoc.specMD.stabilityFrom} ~ ${mfgProcessDoc.specMD.stabilityTo}
										</c:if>
									</td>
									<th>Development time(min)</th>
									<td>
											${mfgProcessDoc.specMD.devTime}
										<c:if test="${fn:length(mfgProcessDoc.specMD.devTime) > 0}">
											${mfgProcessDoc.specMD.devTimeUnit == 'gt' ? '↑' : '↓'}
										</c:if>
									</td>
								</tr>
								<tr>
									<th>P/L</th>
									<td>
										<c:if test="${fn:length(mfgProcessDoc.specMD.plFrom) > 0 or fn:length(mfgProcessDoc.specMD.plTo) > 0}">
											${mfgProcessDoc.specMD.plFrom} ~ ${mfgProcessDoc.specMD.plTo}
										</c:if>
									</td>
									<th>Maximum viscosity(BU)</th>
									<td>
											${mfgProcessDoc.specMD.maxVisc}
										<c:if test="${fn:length(mfgProcessDoc.specMD.maxVisc) > 0}">
											${mfgProcessDoc.specMD.maxViscUnit == 'gt' ? '↑' : '↓'}
										</c:if>
									</td>
									<th>FN(sec)</th>
									<td>
										<c:if test="${fn:length(mfgProcessDoc.specMD.fnFrom) > 0 or fn:length(mfgProcessDoc.specMD.fnTo) > 0}">
											${mfgProcessDoc.specMD.fnFrom} ~ ${mfgProcessDoc.specMD.fnTo}
										</c:if>
									</td>
								</tr>
								<tr>
									<th>Color(Lightness)</th>
									<td>
											${mfgProcessDoc.specMD.color}
										<c:if test="${fn:length(mfgProcessDoc.specMD.color) > 0}">
											${mfgProcessDoc.specMD.colorUnit == 'gt' ? '↑' : '↓'}
										</c:if>
									</td>
									<th>Wet gluten(%)</th>
									<td>
										<c:if test="${fn:length(mfgProcessDoc.specMD.wetGlutenFrom) > 0 or fn:length(mfgProcessDoc.specMD.wetGlutenTo) > 0}">
											${mfgProcessDoc.specMD.wetGlutenFrom} ~ ${mfgProcessDoc.specMD.wetGlutenTo}
										</c:if>
									</td>
									<th>Viscosity(Batter)mm</th>
									<td>
											${mfgProcessDoc.specMD.visc}
										<c:if test="${fn:length(mfgProcessDoc.specMD.visc) > 0}">
											${mfgProcessDoc.specMD.viscUnit == 'gt' ? '↑' : '↓'}
										</c:if>
									</td>
								</tr>
								<tr>
									<th>Particle size(Average)㎛</th>
									<td>${strUtil:getHtmlBr(mfgProcessDoc.specMD.particleSize)}</td>
									<td colspan="4"></td>
									<!-- <th></th>
	                                <td></td>
	                                <th></th>
	                                <td></td> -->
								</tr>
							</table>
						</div>
					</c:if>
					<!-- 제품규격(밀다원) close-->
	            </c:when>
	            <c:when test="${productDevDoc.productDocType == '1' or productDevDoc.productDocType == '2'}">
	                <div class="hold">
	                    <!-- <div class="watermark"><img src="/resources/images/watermark.png"></div> -->
	                    <table class="intable lineside" width="100%">
	                        <colgroup>
	                            <col width="32%">
	                            <col width="38%">
	                            <col width="30%">
	                        </colgroup>
	                        <tr >
	                            <td class="color05" style="border-right:2px solid #000"> 제조방법 </td>
	                            <td class="color05" style="border-right:2px solid #000"> 제조규격 </td>
	                            <td class="color05"> 제품사진 </td>
	                        </tr>
	                        <tr>
	                            <td valign="top" style="border-right:2px solid #000; text-align:left; padding:10px;">
	                                    ${strUtil:getHtmlBr(mfgProcessDoc.menuProcess)}
	                            </td>
	                            <td valign="top" style="border-right:2px solid #000; text-align:left; padding:10px;">
	                                    ${strUtil:getHtmlBr(mfgProcessDoc.standard)}
	                            </td>
	                            <td valign="top">
	                                <c:choose>
	                                    <c:when test="${productDevDoc.imageFileName != null and productDevDoc.imageFileName != ''}">
	                                        <c:if test="${productDevDoc.isOldImage == 'Y'}">
	                                            <img src="/oldFile/devDoc/${strUtil:getDevdocFileName(productDevDoc.oldFileName)}" style="width:100%; height:auto; max-height:200px;">
	                                        </c:if>
	                                        <c:if test="${productDevDoc.isOldImage != 'Y'}">
	                                            <img src="/devDocImage/${strUtil:getDevdocFileName(productDevDoc.imageFileName)}" style="width:100%; height:auto; max-height:200px;">
	                                        </c:if>
	                                    </c:when>
	                                    <c:otherwise>
	                                        <img src="/resources/images/img_noimg.png" style="width:100%; height:auto; max-height:200px;">
	                                    </c:otherwise>
	                                </c:choose>
	                            </td>
	                        </tr>
	                    </table>
	                </div>
	                <div class="hold">
	                    <table class="intable04 linebottom" width="100%">
	                        <colgroup>
	                            <col width="20%">
	                            <col>
	                        </colgroup>
	                        <tr>
	                            <th>보관조건</th><td style="text-align:left;">${strUtil:getHtmlBr(mfgProcessDoc.keepCondition)}</td>
	                        </tr>
	                        <tr>
	                            <th>소비기한</th><td style="text-align:left;">${strUtil:getHtmlBr(mfgProcessDoc.sellDate)}</td>
	                        </tr>
	                        <tr>
	                            <th>QNS 정보</th><td style="text-align:left;">${mfgProcessDoc.qns}</td>
	                        </tr>
	                        <tr>
	                            <th>기타설명</th><td style="text-align:left;">${strUtil:getHtmlBr(mfgProcessDoc.memo)}</td>
	                        </tr>
	                    </table>
	                </div>
	            </c:when>
	            <c:otherwise></c:otherwise>
	        </c:choose>
	    </div>
	</c:if>
	<!-- 제조 공정서 내역 end -->
</div>
<!-- print_box end 230607 -->
