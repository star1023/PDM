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
<div class="wrap_in" id="fixNextTag">
	<section class="type01">
	<!-- 상세 페이지  start-->
			<div class="main_tbl">
				<table width="1246" border="1" cellpadding="0" cellspacing="0" style=" border:2px solid #666" class="outside">
					<tr>
						<td colspan="6" width="49%" class="color05">제품제조공정서</td>
						<td colspan="6" width="51%">									
							${productDevDoc.productName}
						</td>	
					</tr>
					<tr>
						<td colspan="2" class="color05" width="16">문서번호</td>
						<td colspan="2" width="16">SHA - L- 001</td>
						<td colspan="2" class="color05" width="17">제개정일</td>
						<td colspan="2" width="17">${productDevDoc.modDate}</td>
						<td colspan="2" class="color05" width="17">제정판수</td>
						<td colspan="2" width="17">${productDevDoc.docVersion}</td>
					</tr>
				</table>
				<table width="1246" border="1" cellpadding="0" cellspacing="0" style=" border:2px solid #666" class="outside">
					<c:forEach items="${mfgProcessDoc.sub}" var="sub" varStatus="subStatus">
						<tr>
							<td align="left" class="color01" width="1246">
								부속제품명: ${sub.subProdName}
							</td>
						</tr>
						<tr>
							<td width="1246">
							<c:forEach items="${sub.mix}" var="mix">
								<table style="width:100%">
									<tr>
										<td colspan="2"  class="color02">배합비명 : ${mix.baseName}</td>
									</tr>
									<tr>
										<td style="width:49%"  valign="top">
											<table border="1" style="width:100%">
													<tr>
														<th class="color03" colspan="2" width="40%">원료명</th>
														<th class="color03" width="16%">코드번호</th>
														<th class="color03" width="15%">베이커리%</th>
														<th class="color03" width="14%">BOM</th>
														<th class="color03" width="15%">수량 스크랩</th>
													</tr>
													<c:forEach items="${mix.item}" var="item">
														<tr>
															<td class="color05" colspan="2">${item.itemName}&nbsp;</td>
															<td>${item.itemCode}&nbsp;</td>
															<td>${item.bomRate}&nbsp;</td>
															<td>${item.bomAmount}&nbsp;</td>
															<td>${item.scrap}&nbsp;</td>
														</tr>
														<c:set var= "mixBomRateSum" value="${mixBomRateSum + item.bomRate}"/>
														<c:set var= "mixBomAmountSum" value="${mixBomAmountSum + item.bomAmount}"/>
													</c:forEach>
													<tr>
														<td colspan="3" class="color05">합계</td>
														<td><fmt:formatNumber value="${mixBomRateSum}" pattern=".00"/></td>
														<td><fmt:formatNumber value="${mixBomAmountSum}" pattern=".00"/></td>
														<td>&nbsp;</td>
													</tr>
													<tr>
														<td colspan="3" class="color05">기준수량</td>
														<td colspan="3">${sub.stdAmount}</td>
													</tr>
											</table>
										</td>
										<td style="width:51%" valign="top">
											<table border="1" style="width:100%">
													<tr>
														<th class="color03" colspan="2" width="40%">원료명</th>
														<th class="color03" width="16%">코드번호</th>
														<th class="color03" width="15%">베이커리%</th>
														<th class="color03" width="14%">BOM</th>
														<th class="color03" width="15%">수량 스크랩</th>
													</tr>
													<c:forEach items="${cont.item}" var="item">
														<tr>
															<td class="color05" colspan="2">${item.itemName}&nbsp;</td>
															<td>${item.itemCode}&nbsp;</td>
															<td>${item.bomRate}&nbsp;</td>
															<td>${item.bomAmount}&nbsp;</td>
															<td>${item.scrap}&nbsp;</td>
														</tr>
														<c:set var= "contBomRateSum" value="${contBomRateSum + item.bomRate}"/>
														<c:set var= "contBomAmountSum" value="${contBomAmountSum + item.bomAmount}"/>
													</c:forEach>
													<c:forEach var="i" begin="1" end="${fn:length(mix.item)-fn:length(cont.item)}">
														<tr>
															<td  colspan="2">&nbsp;</td>
															<td>&nbsp;</td>
															<td>&nbsp;</td>
															<td>&nbsp;</td>
															<td>&nbsp;</td>
														</tr>
													</c:forEach>
													<tr>
														<td colspan="3" class="color05">합계</Td>
														<td><fmt:formatNumber value="${contBomRateSum}" pattern=".00"/></td>
														<td><fmt:formatNumber value="${contBomAmountSum}" pattern=".00"/></td>
														<td>&nbsp;</td>
													</tr>
													<tr>
														<td colspan="3" class="color05">분할중량</td>
														<td colspan="3">${sub.divWeight} g</td>
													</tr>
											</table>
										</td>
									</tr>
								</table>
							</c:forEach>
							</td>
						</tr>			
					</c:forEach>
				</table>
				<table width="1246" border="1" cellpadding="0" cellspacing="0" style=" border:2px solid #666" class="outside">	
					<tr>
						<td class="color02" colspan="6" width="49%">
							표시사항배합비
						</td>
						<td class="color02"  colspan="6" width="51%">
							제조방법
						</td>
					</tr>
					<tr>
						<td valign="top" colspan="6" width="49%">
							<table width="100%" border="1" cellpadding="0" cellspacing="0" style=" border:2px solid #666" class="outside">	
								<tr>
									<th class="color03" width="50%" colspan="4">원료명</th>
									<th class="color03" width="30%">백분율</th>
									<th class="color03" width="30%">급수포함</th>
								</tr>
								<c:forEach items="${mfgProcessDoc.disp}" var="disp">
									<tr>
										<td width="50%" colspan="4">${disp.matName}</td>
										<td width="30%">${disp.excRate}</td>
										<td width="30%">${disp.incRate}</td>
									</tr>
									<c:set var= "excRateSum" value="${excRateSum + disp.excRate}"/>
									<c:set var= "incRateSum" value="${incRateSum + disp.incRate}"/>
								</c:forEach>
								<tr>
									<td class="color05" width="50%" colspan="4">합계</td>
									<td width="30%"><fmt:formatNumber value="${excRateSum}" pattern=".00"/></td>
									<td width="30%"><fmt:formatNumber value="${incRateSum}" pattern=".00"/></td>
								</tr>
							</table>
						</td>
						<td valign="top" colspan="6" width="51%">
							${fn:replace(mfgProcessDoc.menuProcess, enter, br)}
						</td>
					</tr>
				</table>
				<table width="1246" border="1" cellpadding="0" cellspacing="0" style=" border:2px solid #666" class="outside">
					<tr>
						<td colspan="2" class="color05" style="width:17%">생산라인</td>
						<td colspan="2"  style="width:16%">${mfgProcessDoc.lineName}</td>
						<td colspan="2" class="color05" style="width:17%">배합중량</td>
						<td colspan="2"  style="width:16%">${mfgProcessDoc.mixWeight} Kg (${mfgProcessDoc.bagAmout} 포)</td>
						<td colspan="2" class="color05" style="width:17%">BOM 수율</td>
						<td colspan="2"  style="width:17%">${mfgProcessDoc.bomRate} %</td>
					</tr>
					<tr>
						<td colspan="2" class="color05" style="width:17%">봉당 들이수</td>
						<td colspan="2" style="width:16%">${mfgProcessDoc.numBong} /ea</td>
						<td colspan="2" class="color05" style="width:17%">상자 들이수</td>
						<td colspan="2" style="width:16%">${mfgProcessDoc.numBox}</td>
						<td colspan="2" class="color05" style="width:17%">제조공정도유형</td>
						<td colspan="2" style="width:17%">${mfgProcessDoc.lineProcessType}</td>
					</tr>
					<tr>
						<td colspan="2" class="color05" style="width:17%">분할중량총합계(g)</td>
						<td colspan="2" style="width:16%">${mfgProcessDoc.totWeight}</td>
						<td colspan="2" class="color05" style="width:17%">소성손실(g/%)</td>
						<td colspan="2" style="width:16%">${mfgProcessDoc.loss} %</td>
						<td colspan="2" class="color05" style="width:17%">&nbsp;</td>
						<td colspan="2" style="width:17%">&nbsp;</td>
					</tr>
					<tr>
						<td colspan="2" class="color05" style="width:17%">완제중량</td>
						<td colspan="2" style="width:16%">${mfgProcessDoc.compWeight}</td>
						<td colspan="2" class="color05" style="width:17%">관리중량</td>
						<td colspan="2" style="width:16%">${mfgProcessDoc.adminWeightFrom} ${mfgProcessDoc.adminWeightUnitFrom}
				 ~ ${mfgProcessDoc.adminWeightTo} ${mfgProcessDoc.adminWeightUnitTo}</td>
						<td colspan="2" class="color05" style="width:17%">표기중량</td>
						<td colspan="2" style="width:17%">${mfgProcessDoc.dispWeight}</td>
					</tr>
					<tr>
						<td colspan="2" class="color05" style="width:17%">성상</td>
						<td colspan="2" style="width:16%">${mfgProcessDoc.ingredient}</td>
						<td colspan="2" class="color05" style="width:17%">용도용법</td>
						<td colspan="2" style="width:16%">${mfgProcessDoc.usage}</td>
						<td colspan="2" class="color05" style="width:17%">등록서류제품명</td>
						<td colspan="2" style="width:17%">${mfgProcessDoc.docProdName}</td>
					</tr>
					<tr>
						<td colspan="2" class="color05" style="width:17%">식품유형</td>
						<td colspan="2"  style="width:16%">${productDevDoc.productCategoryText}</td>
						<td colspan="2" class="color05" style="width:17%">등록번호</td>
						<td colspan="2" style="width:16%">${mfgProcessDoc.manufacturingNo}</td>
						<td colspan="2" class="color05" style="width:17%">&nbsp;</td>
						<td colspan="2" style="width:17%">&nbsp;</td>
					</tr>
					<tr>
						<td colspan="2" class="color05" style="width:17%">소비기한 - 등록서류</td>
						<td colspan="2" style="width:16%">${mfgProcessDoc.distPeriDoc}</td>
						<td colspan="2" class="color05" style="width:17%">소비기한 - 현장</td>
						<td colspan="2" style="width:16%">${mfgProcessDoc.distPeriSite}</td>
						<td colspan="2" class="color05" style="width:17%">보관조건</td>
						<td colspan="2" style="width:17%">${mfgProcessDoc.keepCondition}</td>
					</tr>
					<tr>
						<td colspan="2" class="color05" style="width:17%">포장재질</td>
						<td colspan="2" style="width:16%">${mfgProcessDoc.packMaterial}</td>
						<td colspan="2" class="color05" style="width:17%">품목제조보고서 포장단위</td>
						<td colspan="2" style="width:16%">${mfgProcessDoc.packUnit}</td>
						<td colspan="2" class="color05" style="width:17%">어린이 기호식품 고열량 저영양<br/>해당 유무</td>
						<td colspan="2" style="width:17%">
							[<c:if test="${mfgProcessDoc.childHarm == '1'}">●</c:if>]예   [<c:if test="${mfgProcessDoc.childHarm == '2'}">●</c:if>]아니오   [<c:if test="${mfgProcessDoc.childHarm == '3'}">●</c:if>]해당 없음 
						</td>
					</tr>
					<tr>
						<td colspan="2" class="color05" style="width:17%">비고</td>
						<td colspan="10">${mfgProcessDoc.note}</td>
					</tr>
				</table>
			</div>
		</section>
	</div>