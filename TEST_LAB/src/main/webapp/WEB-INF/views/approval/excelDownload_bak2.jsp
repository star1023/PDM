<%@ page language="java" contentType="application/vnd.ms-excel; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.aspn.util.DateUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page session="false" %>
<%
	String currentDate = DateUtil.getDate();
	response.setContentType("application/vnd.msexcel;charset=UTF-8");
	response.setHeader("Content-Disposition", "attachment; filename=\"EXCEL_"+currentDate+".xls\";");
	response.setHeader("Content-Description", "JSP Generated Data");
	response.setHeader("Pragma", "public");
	response.setHeader("Cache-Control", "max-age=0");
%>
<div class="print_box" style="table-layout:fixed;">
		<!-- 상단 머리정보 start-->
		<div class="hold">
			<table width="100%"  border="1" class="intable lineall mb5" >
				<colgroup>
					<col width="50%">
					<col width="30%">
					<col width="10%">
					<col width="10%">
				</colgroup>
				<tr>
					<td class="color05">제품제조공정서</td>
					<td rowspan="3">&nbsp;</td>
					<td class="color05">문서번호</td>
					<td>SHA-L-001</td>
				</tr>
				<tr>
					<td rowspan="2"><span class="big_font">${productDevDoc.productName}</span></td>
					<td class="color05">제개정일</td>
					<td>${productDevDoc.modDate}</td>
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
			<c:forEach items="${mfgProcessDoc.sub}" var="sub" varStatus="subStatus">
			<table border="1" width="100%" class="intable linetop">
				<tr>
					<td class="color05">  부속제품명  : ${sub.subProdName}  </td>
				</tr>
			</table>
			<!-- 배합비 2개씩 반복 --->
			<div class="hold">
				<table border="1" width="100%"  class="intable lineside" >
					<c:set var="mixLength" value="${fn:length(sub.mix)}" />
					<c:forEach items="${sub.mix}" var="mix" varStatus="status">					
					<c:if test="${status.index %2 == 0 }">
					<tr>
					</c:if>
					<c:choose>
						<c:when test="${status.index %2 == 0 }">
							<td width="50%" style=" border-right:2px solid #000; vertical-align:top;">
								<!-- 배합비 타이틀 start-->
								<table border="1" width="100%"  class="intable04" >
									<tr>
										<td class="color06">  배합비명  : ${mix.baseName}  </td>
									</tr>
								</table>
								<!-- 배합비 타이틀 close-->
								<table border="1" width="100%" class="intable02">
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
											<th>베이커리%</th>
											<th>BOM</th>
											<th>수량<br/>스크랩</th>
										</tr>
									</thead>
									<tbody>
										<c:set var="mixItemLength" value="${fn:length(mix.item)}" />
										<c:forEach items="${mix.item}" var="item">
										<tr>
											<th>${item.itemName}</th>
											<td>${item.itemCode}</td>
											<td>${item.bomRate}</td>
											<td>${item.bomAmount}</td>
											<td>${item.scrap}</td>	
											<c:set var= "mixBomRateSum" value="${mixBomRateSum + item.bomRate}"/>
											<c:set var= "mixBomAmountSum" value="${mixBomAmountSum + item.bomAmount}"/>
										</tr>
										</c:forEach>	
										<tr>
											<th colspan="2">합계</th>
											<td><fmt:formatNumber value="${mixBomRateSum}" pattern=".00"/></td>
											<td><fmt:formatNumber value="${mixBomAmountSum}" pattern=".00"/></td>
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
							</td>
							<c:if test="${(mixLength-1 == status.index) && mixLength%2 == 1 }">
							<td width="50%" style=" border-right:2px solid #000; vertical-align:top;">
								<!-- 배합비 타이틀 start-->
								<table border="1" width="100%"  class="intable04" >
									<tr>
										<td class="color06"> &nbsp;  </td>
									</tr>
								</table>
								<!-- 배합비 타이틀 close-->
								<table border="1" width="100%" class="intable02">
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
											<th>베이커리%</th>
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
									</c:forEach>
										</tr>
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
							</td>	
							</c:if>
						</c:when>
						<c:otherwise>
							<td width="50%" style=" border-right:2px solid #000; vertical-align:top;">
								<!-- 배합비 타이틀 start-->
								<table border="1" width="100%"  class="intable04" >
									<tr>
										<td class="color06">  배합비명  : ${mix.baseName}  </td>
									</tr>
								</table>
								<!-- 배합비 타이틀 close-->
								<table border="1" width="100%" class="intable02">
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
											<th>베이커리%</th>
											<th>BOM</th>
											<th>수량<br/>스크랩</th>
										</tr>
									</thead>
									<tbody>
										<c:forEach items="${mix.item}" var="item">
										<tr>
											<th>${item.itemName}</th>
											<td>${item.itemCode}</td>
											<td>${item.bomRate}</td>
											<td>${item.bomAmount}</td>
											<td>${item.scrap}</td>	
											<c:set var= "mixBomRateSum" value="${mixBomRateSum + item.bomRate}"/>
											<c:set var= "mixBomAmountSum" value="${mixBomAmountSum + item.bomAmount}"/>
										</tr>
										</c:forEach>	
										<tr>
											<th colspan="2">합계</th>
											<td><fmt:formatNumber value="${mixBomRateSum}" pattern=".00"/></td>
											<td><fmt:formatNumber value="${mixBomAmountSum}" pattern=".00"/></td>
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
				<table border="1" width="100%"  class="intable lineside" >
				<c:set var="contLength" value="${fn:length(sub.cont)}" />
				<c:forEach items="${sub.cont}" var="cont" varStatus="status">					
				<c:if test="${status.index %2 == 0 }">
					<tr>
				</c:if>
				<c:choose>
					<c:when test="${status.index %2 == 0 }">
						<td width="50%" style=" border-right:2px solid #000; vertical-align:top;">
							<!-- 배합비 타이틀 start-->
							<table border="1" width="100%"  class="intable04" >
								<tr>
									<td class="color07">  내용물  : ${cont.baseName}  </td>
								</tr>
							</table>
							<!-- 배합비 타이틀 close-->
							<table border="1" width="100%" class="intable02">
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
										<th>베이커리%</th>
										<th>BOM</th>
										<th>수량<br/>스크랩</th>
									</tr>
								</thead>
								<tbody>
									<c:set var="contItemLength" value="${fn:length(cont.item)}" />
									<c:forEach items="${cont.item}" var="item">
									<tr>
										<th>${item.itemName}</th>
										<td>${item.itemCode}</td>
										<td>${item.bomRate}</td>
										<td>${item.bomAmount}</td>
										<td>${item.scrap}</td>	
										<c:set var= "contBomRateSum" value="${mixBomRateSum + item.bomRate}"/>
										<c:set var= "contBomAmountSum" value="${mixBomAmountSum + item.bomAmount}"/>
									</tr>
									</c:forEach>
									<tr>
										<th colspan="2">합계</th>
										<td><fmt:formatNumber value="${contBomRateSum}" pattern=".00"/></td>
										<td><fmt:formatNumber value="${contBomAmountSum}" pattern=".00"/></td>
										<td>&nbsp;</td>									
									</tr>
								</tbody>
							</table>								
						</td>
						<c:if test="${(contLength-1 == status.index) && contLength%2 == 1 }">
						<td width="50%" style=" border-right:2px solid #000; vertical-align:top;">
							<!-- 배합비 타이틀 start-->
							<table border="1" width="100%"  class="intable04" >
								<tr>
									<td class="color07">  &nbsp;  </td>
								</tr>
							</table>
							<!-- 배합비 타이틀 close-->
							<table border="1" width="100%" class="intable02">
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
										<th>베이커리%</th>
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
								</tbody>
							</table>								
						</td>
						</c:if>
					</c:when>
					<c:otherwise>
						<!-- 배합비 타이틀 start-->
							<table border="1" width="100%"  class="intable04" >
								<tr>
									<td class="color07">  내용물  : ${cont.baseName}  </td>
								</tr>
							</table>
							<!-- 배합비 타이틀 close-->
							<table border="1" width="100%" class="intable02">
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
										<th>베이커리%</th>
										<th>BOM</th>
										<th>수량<br/>스크랩</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach items="${cont.item}" var="item">
									<tr>
										<th>${item.itemName}</th>
										<td>${item.itemCode}</td>
										<td>${item.bomRate}</td>
										<td>${item.bomAmount}</td>
										<td>${item.scrap}</td>	
										<c:set var= "contBomRateSum" value="${mixBomRateSum + item.bomRate}"/>
										<c:set var= "contBomAmountSum" value="${mixBomAmountSum + item.bomAmount}"/>
									</tr>
									</c:forEach>
									<tr>
										<th colspan="2">합계</th>
										<td><fmt:formatNumber value="${contBomRateSum}" pattern=".00"/></td>
										<td><fmt:formatNumber value="${contBomAmountSum}" pattern=".00"/></td>
										<td>&nbsp;</td>									
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
		</div>
	<!-- 부속제품  close-->
	<!-- 표시사항배합비,제조방법,제품사진,제조방법 start-->
		<div class="hold">
				<table border="1" class="intable lineside" width="100%">
					<colgroup>
						<col width="38%">
						<col width="32%">
						<col width="30%">
					</colgroup>
					<tr >
						<td class="color05" style="border-right:2px solid #000"> 표시사항배합비 </td>
						<td class="color05" style="border-right:2px solid #000"> 제조방법 </td>
						<td class="color05"> 제품사진 </td>
					</tr>
					<tr>
						<td valign="top" style="border-right:2px solid #000">
							<table border="1" width="100%" class="intable02">
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
										<td>${disp.excRate}</td>
										<td>${disp.incRate}</td>
									</tr>
									<c:set var= "excRateSum" value="${excRateSum + disp.excRate}"/>
									<c:set var= "incRateSum" value="${incRateSum + disp.incRate}"/>
								</c:forEach>
									<tr>
										<th>합계</th>
										<td><fmt:formatNumber value="${excRateSum}" pattern=".00"/></td>
										<td><fmt:formatNumber value="${incRateSum}" pattern=".00"/></td>
									</tr>	
								</tbody>
							</table>
						</td>
						<td valign="top" style="border-right:2px solid #000; text-align:left; padding:10px;">
							${fn:replace(mfgProcessDoc.menuProcess, enter, br)}
						</td>
						<td valign="top">
							<img src="/resources/images/img_noimg.png" style="width:100%; height:auto; max-height:200px;">
							<table border="1" class="intable03" width="100%">
								<tr>
									<td class="color05">제조방법</td>
								</tr>
								<tr>
									<td style="text-align:left; padding:10px;">
										${fn:replace(mfgProcessDoc.standard, enter, br)}
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</div>
			<!-- 표시사항배합비,제조방법,제품사진,제조방법 close-->
			<!-- 비고 start-->
			<div class="hold">
				<table border="1" class="intable04 linebottom" width="100%">
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
						<td>${mfgProcessDoc.totWeight}</td>
						<th>소성손실(g/%)</th>
						<td>${mfgProcessDoc.loss} %</td>
						<th>&nbsp;</th>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<th>완제중량</th>
						<td>${mfgProcessDoc.compWeight}</td>
						<th>관리중량</th>
						<td>${mfgProcessDoc.adminWeightFrom} ${mfgProcessDoc.adminWeightUnitFrom}
							 ~ ${mfgProcessDoc.adminWeightTo} ${mfgProcessDoc.adminWeightUnitTo}</td>
						<th>표기중량</th>
						<td>${mfgProcessDoc.dispWeight}</td>
					</tr>
					<tr>
						<th>성상</th>
						<td>${mfgProcessDoc.ingredient}</td>
						<th>용도용법</th>
						<td>${mfgProcessDoc.usage}</td>
						<th>등록서류제품명</th>
						<td>${mfgProcessDoc.docProdName}</td>
					</tr>
					<tr>
						<th>식품유형</th>
						<td>${productDevDoc.productCategoryText}</td>
						<th>등록번호</th>
						<td>${mfgProcessDoc.manufacturingNo}</td>
						<th>&nbsp;</th>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<th>유통기한 - 등록서류</th>
						<td>${mfgProcessDoc.distPeriDoc}</td>
						<th>유통기한 - 현장</th>
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
						<td colspan="5">${mfgProcessDoc.note}</td>
					</tr>
				</table>
			</div>
			<!--비고 close-->
	</div>
