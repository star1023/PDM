<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.HashMap"%>
<%@page import="org.springframework.http.HttpRequest"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<% pageContext.setAttribute("LF", "\n"); %>
<script type="text/javascript">
	$(document).ready(function() {
		
	});

	function productDesignView() {
		location.href = '/design/productDesignDocDetail?pNo=' + '${productDesignVO.getPNo()}'
	}
	
	function goDocDetail(){
		var pNo = '${designDocInfo.pNo}';
		
		var form = document.createElement('form');
		$('body').append(form);
		form.action = '/design/productDesignDocDetail';
		form.method = 'post';
		
		appendInput(form, 'pNo', pNo)
		
		$(form).submit();
	}
	
	function editProductDesignDocDetail(pNo, pdNo){
		var form = document.createElement('form');
		$('body').append(form);
		form.action = '/design/productDesignDocDetailEdit';
		form.method = 'post';
		
		appendInput(form, 'pNo', pNo);
		appendInput(form, 'pdNo', pdNo);
		
		$(form).submit();
	}
</script>

<div class="wrap_in">
	<span class="path">설계서 상세&nbsp;&nbsp;<img
		src="/resources/images/icon_path.png" style="vertical-align: middle" />&nbsp;&nbsp;제품설계서&nbsp;&nbsp;<img
		src="/resources/images/icon_path.png" style="vertical-align: middle" />&nbsp;&nbsp;<a
		href="#none">SPC 삼립연구소</a>
	</span>
	<section class="type01">
		<!-- 상세 페이지  start-->
		<h2 style="position: relative">
			<span class="title_s">Product Design Doc</span> <span class="title">제품설계서 상세보기</span>
			<div class="top_btn_box">
				<ul>
					<li>
						<button type="button" class="btn_circle_modifiy" onClick="editProductDesignDocDetail('${designDocInfo.pNo}', '${designDocDetail.pdNo}')">&nbsp;</button>
						<button type="button" class="btn_circle_nomal" onClick="goDocDetail()">&nbsp;</button>
					</li>
				</ul>
			</div>
		</h2>
		
		<div class="group01 mt20">
			<div class="title5">
				<span class="txt">01. '${designDocInfo.productName}' 기준정보</span>
			</div>
			<div class="main_tbl">
				<table class="insert_proc01">
					<colgroup>
						<col width="13%" />
						<col width="20%" />
						<col width="13%" />
						<col width="20%" />
						<col width="14%" />
						<col width="20%" />
					</colgroup>
					<tbody>
						<tr>
							<th style="border-left: none;">소매가격</th>
							<td>${designDocDetail.productPrice} ￦</td>
							<th style="border-left: none;">들이수</th>
							<td>${designDocDetail.volume} ea</td>
							<th style="border-left: none;">원가비율</th>
							<td>${designDocDetail.plantPrice} %</td>
						</tr>
						<tr>
							<th style="border-left: none;">수율</th>
							<td>${designDocDetail.yieldRate} %</td>
							<th style="border-left: none;">설명</th>
							<td colspan="3">${designDocDetail.memo}</td>
						</tr>
						<tr>
							<th style="border-left: none;">이미지 파일</th>
							<td style="height: 200px"><img src="/picture/${designDocDetail.imageFileName}" width="100%"></td>
							<th style="border-left: none;" rowspan="3">제조공정</th>
							<td colspan="3">${fn:replace(designDocDetail.makeProcess, LF, '<br>')}</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="title5" style="padding-top: 50px;">
				<span class="txt">02. 원료</span>
			</div>
			<c:forEach items="${designDocDetail.sub}" var="sub" varStatus="subStatus">
				<div class="title mt${subStatus.index == 0 ? '5' : '10'}">
					<span class="txt">부속제품명: ${sub.subProdName}</span>
				</div>
				<div id="subProdDiv_1" name="subProdDiv">
					<div class="main_tbl">
						<table class="insert_proc01" style="border-right:1px solid #d1d1d1">
							<colgroup>
								<col width="13%" />
								<col width="20%" />
								<col width="13%" />
								<col width="20%" />
								<col width="14%" />
								<col width="20%" />
							</colgroup>
							<tbody>
								<tr>
									<th>부속제품설명</th>
									<td colspan="5">${sub.subProdDesc}</td>
								</tr>
								<!-- 
								<tr>
									<th>분할 중량</th>
									<td>sub.divWeight g</td>
									<th>분할중량 설명</th>
									<td>sub.divWeightTxt</td>
									<th>기준수량</th>
									<td> - </td>
								</tr>
								 -->
							</tbody>
						</table>
					</div>
					<div>
						<c:forEach items="${sub.subMix}" var="mix">
						 	<div class="tbl_in_title">▼ 배합비</div>
							<div class="tbl_in_con">
								<div class="nomal_mix">
									<div class="table_header01">
										<span class="title mt5"><img src="/resources/images/img_table_header.png">&nbsp;&nbsp;배합비명 : ${mix.name} / 분할중량 : ${mix.weight} g </span>
									</div>
									<table class="tbl05">
										<colgroup>
											<col width="140">
											<col />
											<col width="10%">
											<col width="10%">
											<col width="5%">
											<col width="10%">
											<col width="10%">
										</colgroup>
										<thead>
											<tr>
												<th>원료코드</th>
												<th>원료명</th>
												<th>배합율</th>
												<th>단가</th>
												<th>단위</th>
												<th>가격</th>
												<th>비급수 비율(%)</th>
											</tr>
										</thead>
										<tbody>
											<c:set var="mixMixingRatioTotal" value="0"/>
											<c:set var="mixWaterRatioTotal" value="0"/>
											<c:set var="mixProportionTotal" value="0"/>
											<c:forEach items="${mix.subMixItem}" var="item">
												<c:set var="mixMixingRatioTotal" value="${mixMixingRatioTotal + item.mixingRatio}"/>
												<c:if test="${item.itemSapCode == 'P10001'}">
													<c:set var="mixWaterRatioTotal" value="${mixWaterRatioTotal + item.mixingRatio}"/>
												</c:if>
											</c:forEach>
											<c:forEach items="${mix.subMixItem}" var="item">
												<c:set var="mixPriceTotal" value="${mixPriceTotal + (item.itemUnitPrice*item.mixingRatio)}"/>
												<Tr>
													<Td>${item.itemSapCode}</Td>
													<Td>${item.itemName}</Td>
													<Td>${item.mixingRatio}</Td>
													<Td>${item.itemUnitPrice}</Td>
													<Td>${item.itemUnit}</Td>
													<Td><fmt:formatNumber value="${item.itemUnitPrice*item.mixingRatio}" pattern="#.####"/></Td>
													<Td>
														<c:choose>
															<c:when test="${item.itemSapCode == 'P10001'}">0</c:when>
															<c:otherwise>
																<fmt:formatNumber value="${(item.mixingRatio/(mixMixingRatioTotal-mixWaterRatioTotal))*100}" type="number" pattern="#.###"/>
																<c:set var="mixProportionTotal" value="${mixProportionTotal + (item.mixingRatio/(mixMixingRatioTotal-mixWaterRatioTotal)*100)}"/>
															</c:otherwise>
														</c:choose>
													</Td>
												</Tr>
											</c:forEach>
										</tbody>
										<tfoot>
											<Tr>
												<Td colspan="2">합계</Td>
												<Td><fmt:formatNumber value="${mixMixingRatioTotal}" pattern=".000"/></Td>
												<Td>&nbsp;</Td>
												<Td>&nbsp;</Td>
												<Td><fmt:formatNumber value="${mixPriceTotal}" pattern=".000"/></Td>
												<Td><fmt:formatNumber value="${mixProportionTotal}" pattern="0"/></Td>
											</Tr>
										</tfoot>
									</table>
								</div>
							</div>
						</c:forEach>
						<c:forEach items="${sub.subContent}" var="cont">
							<div class="tbl_in_title">▼ 내용물</div>
							<div class="tbl_in_con">
								<div class="nomal_mix">
									<div class="table_header02">
										<span class="title mt5">
											<img src="/resources/images/img_table_header.png">&nbsp;&nbsp;내용물명 : ${cont.name} / 분할중량 : ${cont.weight} g
										</span>
									</div>
									<table class="tbl05">
										<colgroup>
											<col width="140">
											<col />
											<col width="10%">
											<col width="10%">
											<col width="5%">
											<col width="10%">
											<col width="10%">
										</colgroup>
										<thead>
											<tr>
												<th>원료코드</th>
												<th>원료명</th>
												<th>배합율</th>
												<th>단가</th>
												<th>단위</th>
												<th>가격</th>
												<th>비급수 비율(%)</th>
											</tr>
										</thead>
										<tbody>
											<c:set var="contMixingRatioTotal" value="0"/>
											<c:set var="contWaterRatioTotal" value="0"/>
											<c:set var="contProportionTotal" value="0"/>
											<c:forEach items="${cont.subContentItem}" var="item">
												<c:set var="contMixingRatioTotal" value="${contMixingRatioTotal + item.mixingRatio}"/>
												<c:if test="${item.itemSapCode == 'P10001'}">
													<c:set var="contWaterRatioTotal" value="${contWaterRatioTotal + item.mixingRatio}"/>
												</c:if>
											</c:forEach>
											<c:forEach items="${cont.subContentItem}" var="item">
												<c:set var="contPriceTotal" value="${contPriceTotal + (item.itemUnitPrice*item.mixingRatio)}"/>
												<Tr><!--  class="temp_color" -->
													<Td>${item.itemSapCode}</Td>
													<Td>${item.itemName}</Td>
													<Td>${item.mixingRatio}</Td>
													<Td>${item.itemUnitPrice}</Td>
													<Td>${item.itemUnit}</Td>
													<Td><fmt:formatNumber value="${item.itemUnitPrice*item.mixingRatio}" pattern=".000"/></Td>
													<Td>
														<c:choose>
															<c:when test="${item.itemSapCode == 'P10001'}">0</c:when>
															<c:otherwise>
																<fmt:formatNumber value="${(item.mixingRatio/(contMixingRatioTotal-contWaterRatioTotal))*100}" type="number" pattern="#.###"/>
																<c:set var="contProportionTotal" value="${contProportionTotal + (item.mixingRatio/(contMixingRatioTotal-contWaterRatioTotal)*100)}"/>
																<%-- <c:set var="contProportionTotal" value="${contProportionTotal + (item.mixingRatio/(contMixingRatioTotal-contWaterRatioTotal))*100)}"/> --%>
															</c:otherwise>
														</c:choose>
													</Td>
												</Tr>
											</c:forEach>
										</tbody>
										<tfoot>
											<Tr>
												<Td colspan="2">합계</Td>
												<Td><fmt:formatNumber value="${contMixingRatioTotal}" pattern=".000"/></Td>
												<Td>&nbsp;</Td>
												<Td>&nbsp;</Td>
												<Td><fmt:formatNumber value="${contPriceTotal}" pattern=".000"/></Td>
												<Td><fmt:formatNumber value="${contProportionTotal}" pattern="#"/></Td>
											</Tr>
										</tfoot>
									</table>
								</div>
							</div>
						</c:forEach>
					</div>
				</div>
			</c:forEach>
			<div class="title5" style="float: left; margin-top: 30px;">
				<span class="txt">03. 재료</span>
			</div>
			<table class="tbl05" style="border-top: 2px solid #4b5165;">
				<colgroup>
					<col width="140">
					<col />
					<col width="8%">
					<col width="5%">
					<col width="8%">
				</colgroup>
				<thead>
					<tr>
						<th>원료코드</th>
						<th>원료명</th>
						<th>단가</th>
						<th>수량</th>
						<th>가격</th>
					</tr>
				</thead>
				<tbody name="packageTbody">
					<c:forEach items="${designDocDetail.pkg}" var="item">
						<c:set var="pkgPriceTotal" value="${pkgPriceTotal+item.itemUnitPrice}"/>
						<Tr>
							<Td>${item.itemSapCode}</Td>
							<Td>${item.itemName}</Td>
							<Td>${item.itemSapPrice}</Td>
							<Td>${item.itemVolume}</Td>
							<Td>${item.itemUnitPrice}</Td>
						</Tr>
					</c:forEach>
				</tbody>
				<tfoot>
					<tr>
						<td colspan="3">합계</td>
						<td> - </td>
						<td>${pkgPriceTotal}</td>
					</tr>
				</tfoot>
			</table>
			<div class="title5" style="float: left; margin-top: 30px;">
				<span class="txt">04. 원재료비</span>
			</div>
			<table class="tbl05" id="combineTable">
				<colgroup>
					<col width="20%">
					<col width="14%">
					<col />
					<col width="14%">
					<col width="14%">
					<col width="14%">
				</colgroup>
				<thead>
					<tr style="border-top: 2px solid #4b5165">
						<th>부속제품명</th>
						<th>구분</th>
						<th>원료명</th>
						<th>단가(KG)</th>
						<th>분할중량(g)</th>
						<th>원가(수율적용)</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${designDocDetail.cost}" var="item">
						<c:set var="costPriceTotal" value="${costPriceTotal+item.orgPrice}"/>
						<c:set var="costWeightTotal" value="${costWeightTotal+item.weight}"/>
						<tr>
							<td><%-- [${item.pdsmNo}] --%>${item.subProdName}</td>
							<td>
								<c:if test="${item.type == 'mix'}">배합</c:if>
								<c:if test="${item.type == 'content'}">내용물</c:if>
							</td>
							<td>${item.name}</td>
							<td><fmt:formatNumber value="${item.kgPrice}" pattern=".000"/></td>
							<td>${item.weight}</td>
							<td><fmt:formatNumber value="${item.kgPrice/1000*item.weight*(designDocDetail.yieldRate/100)}" pattern=".000"/></td>
						</tr>
					</c:forEach>
				</tbody>
				<tfoot>
					<c:set var="price" value="${designDocDetail.productPrice*designDocDetail.plantPrice/100}"/>
					<c:set var="costPriceTotal" value="${costPriceTotal*(designDocDetail.yieldRate/100)}"/>
					<tr>
						<td colspan="3">합계</td><td>원료</td><td>${costWeightTotal}</td>
						<td><fmt:formatNumber value="${costPriceTotal}" pattern=".000"/> (<fmt:formatNumber value="${costPriceTotal/price*100}" pattern=".00"/>%)</td>
					</tr>
					<tr>
						<td colspan="3"></td><td>재료</td><td></td>
						<td><fmt:formatNumber value="${pkgPriceTotal}" pattern=".000"/> (<fmt:formatNumber value="${pkgPriceTotal/price*100}" pattern=".00"/>%)</td>
					</tr>
					<tr>
						<td colspan="3"></td><td>총 가격</td><td></td>
						<td><fmt:formatNumber value="${costPriceTotal+pkgPriceTotal}" pattern=".000"/> (<fmt:formatNumber value="${(costPriceTotal+pkgPriceTotal)/price*100}" pattern=".00"/>%)</td>
					</tr>
					<tr><td colspan="3"></td><td>소매가격</td><td></td><td>${designDocDetail.productPrice}</td></tr>
					<tr><td colspan="3"></td><td>출하가</td><td><fmt:formatNumber value="${(designDocDetail.plantPrice)}" pattern=".00"/> %</td><td>${price}</td></tr>
				</tfoot>
			</table>
			
			<div class="main_tbl">
				<div class="btn_box_con5">
					<button class="btn_admin_gray" onClick="goDocDetail()" style="width: 120px;">목록</button>
				</div>
				<div class="btn_box_con4">
					<button class="btn_admin_navi" onclick="editProductDesignDocDetail('${designDocInfo.pNo}', '${designDocDetail.pdNo}')">수정</button>
				</div>
				<hr class="con_mode" />
			</div>
		</div>
	</section>
</div>