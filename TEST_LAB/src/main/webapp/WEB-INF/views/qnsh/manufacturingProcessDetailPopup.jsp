<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="userUtil" uri="/WEB-INF/tld/userUtil.tld"%>
<%@ taglib prefix="dateUtil" uri="/WEB-INF/tld/dateUtil.tld"%>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="kr.co.aspn.util.*" %> 
<%@ page session="false" %>
<title>제조공정서 미리보기</title>
<style>
/*추가*/
.outside{ border:0; font-family:'맑은고딕',Malgun Gothic; font-size:12px;}
.outside td{border:2px solid #666;}
.intable_title{ border:0;}
.intable_title td{border:1px solid #666; text-align:center; height:22px;}
.jungjong{ border:0; text-align:center;}
.jungjong th,.jungjong td{ border:1px solid #666; height:18px;}
.jungjong tbody td{ border-bottom:1px solid #ddd !important; border-top:1px solid #ddd !important;}
.jungjong th, .jungjong tfoot td{ background-color:#ebebeb;}

.material{border:0; text-align:center;}
.material th,.material td{ border:1px solid #666; height:18px;}
.material tr th{ background-color:#ebebeb;}

.material_inbox{ border:1px solid #999; text-align:center;}
.material_inbox th,.material_inbox td{  height:18px;}
.material_inbox tbody td{ border-top:1px solid #ddd !important;}
.material_inbox th{ }
.water_mark{font-family:'맑은고딕',Malgun Gothic; font-size:13px; margin-top:10px; float:left;}
.big_font{ font-size:20px;}
.color01{ background-color:#eaf1dd;}
.color02{background-color:#fde9d9;}
.color03{background-color:#dbe5f1;}
.color04{background-color:#ddd9c3;}
.color05{background-color:#f3f3f3;}

</style>

<input type="hidden" name="tbKey" id="tbKey" value="${paramVO.tbKey }">
	<input type="hidden" name="tbType" id="tbType" value="manufacturingProcessDoc">
	<input type="hidden" name="currentUserid" id="currentUserid" value="${apprItemHeader.currentUserId }">
	<input type="hidden" name="currentStep" id="currentStep" value="${apprItemHeader.currentStep }">
	<input type="hidden" name="apprNo" id="apprNo" value="${apprItemHeader.apprNo }">
	<input type="hidden" name="title" id="title" value="${apprItemHeader.title }">
	<input type="hidden" name="regUserId" id="regUserId" value="${mfgProcessDoc.regUserId }">
	<input type="hidden" name="tbTypeName" id="tbTypeName" value="${apprItemHeader.tbTypeName }">
<h2 style=" position:fixed;" class="print_hidden">
	<span class="title"><img src="${domain}/resources/images/bg_bs_box_fast02.png">&nbsp;&nbsp;제조공정서 미리보기</span>
</h2>
<div  class="top_btn_box" style=" position:fixed;">
	<ul>
		<li><button type="button" class="btn_pop_close" onClick="self.close();"></button></li>
	</ul>
</div>
<!--여기서부터 프린트 -->
<div id='print_page'  style="padding:10px 0 20px 20px;">
	<table width="1046" cellpadding="0" cellspacing="0" class="print_hidden">
		<tr>
			<td height="50"></td>
		</tr>
	</table>
	<!-- 출력버튼 -->
	<!-- 실제 출력대상 start ------------------------------------------------------------------------------------------------------------------------------------------------>
	<div class="print_box" style="table-layout:fixed;">
		<!-- 상단 머리정보 start-->
		<div class="hold">
			<table border="0" width="100%" height="60" style="display:none" id="confi">
				<tr>
					<td align="left">
						<img src="${domain}/resources/images/btn_confi.png"  border="0" style="margin-left:3px;"/>
					</td>
				</tr>
			</table>
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
												<c:otherwise>
													프린트결재
												</c:otherwise>
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
					<td>SHA-L-${productDevDoc.docNo}</td>
				</tr>
				<tr>
					<td rowspan="2"><span class="big_font">${productDevDoc.productName}(${productDevDoc.productCode})/${mfgProcessDoc.plantName}</span></td>
					<td class="color05">제개정일</td>
					<td>${dateUtil:convertDate(productDevDoc.modDate,"yyyy-MM-dd HH:mm:ss","yyyy-MM-dd")}</td>
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
			<div class="watermark"><img src="${domain}/resources/images/watermark.png"></div>
			<c:if test="${!(userUtil:getDeptCode(pageContext.request) == 'dept9' && userUtil:getUserGrade(pageContext.request) != '13') && userUtil:getDeptCode(pageContext.request) != 'dept8' }">
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
								<c:if test="${fn:trim(mfgProcessDoc.calcType) != '7'}">
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
												<th>수량<br/>스크랩</th>
											</tr>
										</thead>
										<tbody>
											<c:set var="mixItemLength" value="${fn:length(mix.item)}" />
											<c:set var= "mixBomRateSum" value="0"/>
											<c:set var= "mixBomAmountSum" value="0"/>
											<c:forEach items="${mix.item}" var="item">
											
											<c:set var="backgroundColor" value=""/>												
											<c:if test="${mfgProcessDoc.companyCode == 'MD' && mfgProcessDoc.calcType == '10' && item.itemCode == '400023'}">
												<c:set var="backgroundColor" value="#ffe8d9"/>
											</c:if>
											
											<tr>
												<th>${strUtil:getHtmlBr(item.itemName)}
													<c:if test="${item.coo != null && item.coo != ''}">
														[${item.cooName}]
													</c:if>
												</th>
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
												<td style="background-color: ${backgroundColor}">
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
												<c:if test="${!(mfgProcessDoc.companyCode == 'MD' && mfgProcessDoc.calcType == '10' && item.itemCode == '400023')}">
													<c:set var= "mixBomRateSum" value="${mixBomRateSum + item.bomRate}"/>
													<c:set var= "mixBomAmountSum" value="${mixBomAmountSum + item.bomAmount}"/>
												</c:if>	
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
														<fmt:formatNumber value="${mixBomAmountSum}" pattern="0.###"/>
														</c:when>
														<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
														0.00
														</c:when>
														<c:otherwise>
														<fmt:formatNumber value="${mixBomAmountSum}" pattern="0.###"/>
														</c:otherwise>
													</c:choose>
												</td>
												<td>
													<c:choose>
														<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) == "13"}'>
														<fmt:formatNumber value="${mixBomRateSum}" pattern="0.###"/>
														</c:when>
														<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
														0.00
														</c:when>
														<c:otherwise>
														<fmt:formatNumber value="${mixBomRateSum}" pattern="0.###"/>
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
								</c:if>
								<c:if test="${fn:trim(mfgProcessDoc.calcType) == '7'}">
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
												<th>BOM항목</th>
												<th>수량<br/>스크랩</th>
											</tr>
										</thead>
										<tbody>
											<c:set var="mixItemLength" value="${fn:length(mix.item)}" />
											<c:set var= "mixBomRateSum" value="0"/>
											<c:set var= "mixBomAmountSum" value="0"/>
											
											<c:forEach items="${mix.item}" var="item">
											
											<c:set var="backgroundColor" value=""/>												
											<c:if test="${fn:startsWith(item.itemCode, '4') || fn:startsWith(item.itemCode, '5')}">
												<c:set var="backgroundColor" value="#ffe8d9"/>
											</c:if>
											
											<tr>
												<th>${strUtil:getHtmlBr(item.itemName)}
													<c:if test="${item.coo != null && item.coo != ''}">
														[${item.cooName}]
													</c:if>
												</th>
												<td>
													${item.itemCode}
												</td>
												<td>-</td>
												<td style="background-color: ${backgroundColor}">
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
												<td>-</td>	
												<c:if test="">
												
												</c:if>
												<c:if test="${!(fn:startsWith(item.itemCode, '4') || fn:startsWith(item.itemCode, '5'))}">
													<c:set var= "mixBomRateSum" value="${mixBomRateSum + item.bomRate}"/>
													<c:set var= "mixBomAmountSum" value="${mixBomAmountSum + item.bomAmount}"/>
												</c:if>
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
												<td>&nbsp;</td>
												<td>
													<c:choose>
														<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) == "13"}'>
														<fmt:formatNumber value="${mixBomRateSum}" pattern="0.###"/>
														</c:when>
														<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
														0.00
														</c:when>
														<c:otherwise>
														<fmt:formatNumber value="${mixBomRateSum}" pattern="0.###"/>
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
								</c:if>
							</td>
							<%-- <c:if test="${(mixLength-1 == status.index) || mixLength%2 == 1 }"> --%>
							<c:if test="${ rigthItemLength == 0}">
							<td width="50%" style=" border-right:2px solid #000; vertical-align:top;">
								<!-- 배합비 타이틀 start-->
								<table width="100%"  class="intable04" >
									<tr>
										<td class="color06"> &nbsp;  </td>
									</tr>
								</table>
								<c:if test="${fn:trim(mfgProcessDoc.calcType) != '7' }">
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
												<th>수량<br/>스크랩</th>
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
								</c:if>
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
											<th>수량<br/>스크랩</th>
										</tr>
									</thead>
									<tbody>
										<c:set var= "mixBomRateSum2" value="0"/>
										<c:set var= "mixBomAmountSum2" value="0"/>
										<c:set var="mixItemLength2" value="${fn:length(mix.item)}" />
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
													<fmt:formatNumber value="${mixBomAmountSum2}" pattern="0.###"/>
													</c:when>
													<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
													0.00
													</c:when>
													<c:otherwise>
													<fmt:formatNumber value="${mixBomAmountSum2}" pattern="0.###"/>
													</c:otherwise>
												</c:choose>
											</td>
											<td>
												<c:choose>
													<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) == "13"}'>
													<fmt:formatNumber value="${mixBomRateSum2}" pattern="0.###"/>
													</c:when>
													<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
													0.00
													</c:when>
													<c:otherwise>
													<fmt:formatNumber value="${mixBomRateSum2}" pattern="0.###"/>
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
							</td>
						</c:otherwise>
					</c:choose>
					<c:if test="${status.index == mixLength-1 or status.index%2 == 1 }">
					</tr>
					</c:if>
					</c:forEach>
				</table>
			</div>
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
										<th>수량<br/>스크랩</th>
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
												<fmt:formatNumber value="${contBomAmountSum}" pattern="0.###"/>
												</c:when>
												<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
												0.00
												</c:when>
												<c:otherwise>
												<fmt:formatNumber value="${contBomAmountSum}" pattern="0.###"/>
												</c:otherwise>
											</c:choose>
										</td>
										<td>
											<c:choose>
												<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) == "13"}'>
												<fmt:formatNumber value="${contBomRateSum}" pattern="0.###"/>
												</c:when>
												<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
												0.00
												</c:when>
												<c:otherwise>
												<fmt:formatNumber value="${contBomRateSum}" pattern="0.###"/>
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
										<th>수량<br/>스크랩</th>
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
										<th>수량<br/>스크랩</th>
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
												<fmt:formatNumber value="${contBomAmountSum2}" pattern="0.###"/>
												</c:when>
												<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
												0.00
												</c:when>
												<c:otherwise>
												<fmt:formatNumber value="${contBomAmountSum2}" pattern="0.###"/>
												</c:otherwise>
											</c:choose>
										</td>
										<td>
											<c:choose>
												<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) == "13"}'>
												<fmt:formatNumber value="${contBomRateSum2}" pattern="0.###"/>
												</c:when>
												<c:when test='${userUtil:getDeptCode(pageContext.request) == "dept9" && userUtil:getUserGrade(pageContext.request) != "13"}'>
												0.00
												</c:when>
												<c:otherwise>
												<fmt:formatNumber value="${contBomRateSum2}" pattern="0.###"/>
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
		</c:forEach>
		</c:if>
		</div>
	<!-- 부속제품  close-->
	<!-- 유출금지 정보출력 start-->
		<table width="100%"  class="intable lineside" style="display:none" id="water_mark_table">
			<tr>
				<td id="water_mark_td">!- 유출금지 정보출력 -!</td>
			</tr>
		</table>
	<!-- 유출금지 정보출력 close-->
	<!-- 표시사항배합비,제조방법,제품사진,제조방법 start-->
		<div class="hold">
			<div class="watermark"><img src="/resources/images/watermark.png"></div>
				<c:if test="${fn:trim(mfgProcessDoc.calcType) != '7'}">
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
										<col width="69%">
										<col width="16%">
										<col width="16%">
									</colgroup>							
									<thead>
										<tr style="border: 1px solid #666">
											<th>재료명</th>
											<th>코드번호</th>
											<th>재료사양</th>
										</tr>
									</thead>
									<tbody>
									<c:forEach items="${mfgProcessDoc.pkg}" var="pkg">
										<tr>
											<th>${strUtil:getHtmlBr(pkg.itemName)}</th>
											<td>${pkg.itemCode}</td>
											<td>${pkg.bomAmount}(${pkg.unit})</td>
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
											<th>${strUtil:getHtmlBr(disp.matName)}</th>
											<td>${disp.excRate}</td>
											<td>${disp.incRate}</td>
										</tr>
										<c:set var= "excRateSum" value="${excRateSum + disp.excRate}"/>
										<c:set var= "incRateSum" value="${incRateSum + disp.incRate}"/>
									</c:forEach>
										<tr>
											<th>합계</th>
											<td id="excRateTotal"><fmt:formatNumber value="${excRateSum}" pattern="0.###"/></td>
											<td id="incRateSum"><fmt:formatNumber value="${incRateSum}" pattern="0.###"/></td>
										</tr>
									</tbody>
								</table>
							</td>						
						</tr>
					</table>
				</c:if>
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
						<td valign="top" style="border-right:2px solid #000; text-align:left; padding:10px;"">
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
									<img src="${domain}/resources/images/img_noimg.png" style="width:100%; height:auto; max-height:200px;">
								</c:otherwise>
							</c:choose>
						</td>
					</tr>
				</table>
			</div>
			<!-- 표시사항배합비,제조방법,제품사진,제조방법 close-->
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
						<td colspan="6" class="color05"> 비고 </td>
					</tr>
					<c:choose>
						<c:when test="${fn:trim(mfgProcessDoc.calcType) == '3' or fn:trim(mfgProcessDoc.calcType) == '7'}">
							<tr>
								<th>생산라인</th>
								<td>${mfgProcessDoc.lineName}</td>
								<th>BOM 수율</th>
								<td>${mfgProcessDoc.bomRate} %</td>
								<th>제조공정도 유형</th>
								<td>${mfgProcessDoc.lineProcessType}</td>
							</tr>
							<c:if test="${fn:trim(mfgProcessDoc.calcType) != '7' }">
								<tr>
									<th>완제중량</th>
									<td>
										${mfgProcessDoc.compWeight} ${mfgProcessDoc.compWeightUnit} 
										<c:if test='${mfgProcessDoc.compWeightText != null && mfgProcessDoc.compWeightText != ""}'> (${mfgProcessDoc.compWeightText})</c:if>
									</td>
									<th>관리중량</th>
									<td>${mfgProcessDoc.adminWeightFrom} ${mfgProcessDoc.adminWeightUnitFrom}
										 ~ ${mfgProcessDoc.adminWeightTo} ${mfgProcessDoc.adminWeightUnitTo}</td>
									<th>표기중량</th>
									<td>
										${mfgProcessDoc.dispWeight} ${mfgProcessDoc.dispWeightUnit}
										<c:if test='${mfgProcessDoc.dispWeightText != null && mfgProcessDoc.dispWeightText != ""}'> (${mfgProcessDoc.dispWeightText})</c:if>
									</td>
								</tr>
								<tr>
									<th>성상</th>
									<td>${mfgProcessDoc.ingredient}</td>
									<th>용도용법</th>
									<td>${mfgProcessDoc.usage}</td>
									<th>품목제조보고서명</th>
									<td>${mfgProcessDoc.docProdName}</td>
								</tr>
								<tr>
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
									<th>품목보고번호</th>
									<td>${mfgProcessDoc.regNum}</td>
								</tr>
								<tr>
									<th>소비기한 - 등록서류</th>
									<td>${mfgProcessDoc.distPeriDoc}</td>
									<th>소비기한 - 현장</th>
									<td>${mfgProcessDoc.distPeriSite}</td>
									<th>보관조건</th>
									<td>${mfgProcessDoc.keepCondition}</td>
								</tr>
								<tr>
									<th>포장재질</th>
									<td>${mfgProcessDoc.packMaterial}</td>
									<th>품목제조보고서 포장단위</th>
									<td>${mfgProcessDoc.packUnit}</td>
									<th>어린이 기호식품 <br/>고열량 저영양 해당유무</th>
									<td>
										[<c:if test="${mfgProcessDoc.childHarm == '1'}">●</c:if>]예   [<c:if test="${mfgProcessDoc.childHarm == '2'}">●</c:if>]아니오   [<c:if test="${mfgProcessDoc.childHarm == '3'}">●</c:if>]해당 없음 
									</td>
								</tr>
								<tr>
									<th>비고</th>
									<c:if test="${mfgProcessDoc.calcType == '3'}">
										<td colspan="3" style="border-right:2px solid #000; text-align:left;">${strUtil:getHtmlBr(mfgProcessDoc.noteText)}</td>
									</c:if>
									<c:if test="${mfgProcessDoc.calcType != '3'}">
										<td colspan="3">${mfgProcessDoc.note}</td>
									</c:if>
									<th>비고</th>
									<!-- S201109-00014 -->
									<td>${mfgProcessDoc.qns}</td>
								</tr>
							</c:if>
						</c:when>
						<c:otherwise>
							<tr>
								<th>생산라인</th>
								<td>${mfgProcessDoc.lineName}</td>
								<th>배합중량</th>
								<td>${mfgProcessDoc.mixWeight} Kg (${mfgProcessDoc.bagAmout} 포)</td>
								<th>BOM 수율</th>
								<td>${mfgProcessDoc.bomRate} %</td>
							</tr>
							<tr>
								<th>봉당 들이수</th>
								<td>${mfgProcessDoc.numBong} /ea</td>
								<th>상자 들이수</th>
								<td>${mfgProcessDoc.numBox}</td>
								<th>제조공정도 유형</th>
								<td>${mfgProcessDoc.lineProcessType}</td>
							</tr>
							<tr>
								<th>분할중량총합계(g)</th>
								<td>${mfgProcessDoc.totWeight} g</td>
								<th>소성손실(g/%)</th>
								<td>${mfgProcessDoc.loss} %</td>
								<th>&nbsp;</th>
								<td>&nbsp;</td>
							</tr>
							<tr>
								<th>완제중량</th>
								<td>
									${mfgProcessDoc.compWeight} ${mfgProcessDoc.compWeightUnit} 
									<c:if test='${mfgProcessDoc.compWeightText != null && mfgProcessDoc.compWeightText != ""}'> (${mfgProcessDoc.compWeightText})</c:if>
								</td>
								<th>관리중량</th>
								<td>${mfgProcessDoc.adminWeightFrom} ${mfgProcessDoc.adminWeightUnitFrom}
									 ~ ${mfgProcessDoc.adminWeightTo} ${mfgProcessDoc.adminWeightUnitTo}</td>
								<th>표기중량</th>
								<td>
									${mfgProcessDoc.dispWeight} ${mfgProcessDoc.dispWeightUnit}
									<c:if test='${mfgProcessDoc.dispWeightText != null && mfgProcessDoc.dispWeightText != ""}'> (${mfgProcessDoc.dispWeightText})</c:if>
								</td>
							</tr>
							<tr>
								<th>성상</th>
								<td>${mfgProcessDoc.ingredient}</td>
								<th>용도용법</th>
								<td>${mfgProcessDoc.usage}</td>
								<th>품목제조보고서명</th>
								<td>${mfgProcessDoc.docProdName}</td>
							</tr>
							<tr>
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
								<th>품목보고번호</th>
								<td>${mfgProcessDoc.regNum}</td>
							</tr>
							<tr>
								<th>소비기한 - 등록서류</th>
								<td>${mfgProcessDoc.distPeriDoc}</td>
								<th>소비기한 - 현장</th>
								<td>${mfgProcessDoc.distPeriSite}</td>
								<th>보관조건</th>
								<td>${mfgProcessDoc.keepCondition}</td>
							</tr>
							<tr>
								<th>포장재질</th>
								<td>${mfgProcessDoc.packMaterial}</td>
								<th>품목제조보고서 포장단위</th>
								<td>${mfgProcessDoc.packUnit}</td>
								<th>어린이 기호식품 <br/>고열량 저영양 해당유무</th>
								<td>
									[<c:if test="${mfgProcessDoc.childHarm == '1'}">●</c:if>]예   [<c:if test="${mfgProcessDoc.childHarm == '2'}">●</c:if>]아니오   [<c:if test="${mfgProcessDoc.childHarm == '3'}">●</c:if>]해당 없음 
								</td>
							</tr>
							<tr>
								<th>비고</th>
								<td colspan="3">${mfgProcessDoc.note}</td>
								<th>QNS 등록번호</th>
								<td>${mfgProcessDoc.isQnsReviewTarget=="1" ? mfgProcessDoc.qns : "해당 제품은 QNSH 검토 대상이 아님. ex)수출용, 반제품"}</td>
							</tr>
						</c:otherwise>
					</c:choose>
				</table>
			</div>
			<!-- 비고 close-->
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
		<!-- 여기까지 프린트 -->
	</div>
</div>