<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="userUtil" uri="/WEB-INF/tld/userUtil.tld"%>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="kr.co.aspn.util.*" %> 
<%@ page session="false" %>
<title>품목제조보고서 등록</title>
<script type="text/javascript">
function bPopup_close() {
	parent.bPopup_close2();
}
</script>
<style>
.selectbox_popup { border: 1px solid #cf451b; border-radius:5px;/* 테두리 설정 */ z-index: 1; background-color:#fff;font-family:'맑은고딕',Malgun Gothic; color:#000; font-size:13px; padding: 2px 3px  5px 3px;}
</style>
<h2 style=" position:fixed;" class="print_hidden">
	<span class="title"><img src="/resources/images/bg_bs_box_fast02.png">&nbsp;&nbsp;품목제조보고서 상세</span>
</h2>
<div  class="top_btn_box" style=" position:fixed;">
	<ul>
		<li><button type="button" class="btn_pop_close" onClick="bPopup_close();"></button></li>
	</ul>
</div>
<br/>
<br/><br/>
<div class="wrap_in" id="fixNextTag">
	<section class="type01">
		<div class="group01">			
			<div class="list_detail" id="div_create_tab">
				<ul>
					<li class="pt10">
						<dt>공장</dt>
						<dd>
							${mNoData.companyName}&nbsp;/&nbsp;${mNoData.plantName}
						</dd>
					</li>
					<li>
						<dt>품보번호</dt>
						<dd>
							${mNoData.licensingNo}-${mNoData.manufacturingNo}
						</dd>
					</li>
					<li>
						<dt>품목보고명</dt>
						<dd>
							${strUtil:getHtmlBr(mNoData.manufacturingName)}
							<%-- ${mNoData.manufacturingName} --%>
						</dd>
					</li>
					<li>
						<dt>식품유형</dt>
						<dd>
							${mNoData.productType1Name}&nbsp;/&nbsp; ${mNoData.productType2Name}&nbsp;/&nbsp;${mNoData.productType3Name}
						</dd>
					</li>	
					<li>
						<dt>살균여부</dt>
						<dd>
							${mNoData.sterilizationName}
						</dd>
					</li>
					<li>
						<dt>보관조건</dt>
						<dd>	
							${mNoData.keepConditionName} / ${mNoData.keepConditionText}						
						</dd>
					</li>
					<li>
						<dt>소비기한</dt>
						<dd>
							${mNoData.sellDate1Text}&nbsp;${mNoData.sellDate2}&nbsp;${mNoData.sellDate3Text}&nbsp;까지
							<c:if test="${mNoData.sellDate4Text != null && mNoData.sellDate4Text != ''}">
							<br/>
							${mNoData.sellDate4Text}&nbsp;${mNoData.sellDate5}${mNoData.sellDate6Text}&nbsp;까지
							</c:if>
						</dd>
					</li>
					<li>
						<dt>위탁/OEM</dt>
						<dd>
							<c:if test="${mNoData.referral == 'Y'}">
							위탁
							<c:if test="${mNoData.oem == 'Y'}">
							&nbsp;/&nbsp;
							</c:if>
							</c:if>
							<c:if test="${mNoData.oem == 'Y'}">
							OEM
							</c:if>
						</dd>
					</li>
					<c:if test="${mNoData.createPlant != ''}">
					<li>
						<dt>위탁 공장</dt>
						<dd>
							<c:forEach items="${plantList}" var="item">
							${item.plantCode}(${item.plantName})/
							</c:forEach>
						</dd>
					</li>
					</c:if>
					<c:if test="${mNoData.oemText != ''}">
					<li>
						<dt>OEM 내용</dt>
						<dd>
							${mNoData.oemText} 
						</dd>
					</li>
					</c:if>
					<li>
						<dt>포장재질</dt>
						<dd>		
							<c:forEach items="${packageList}" var="item">
							<c:if test="${item.packageUnit != '8'}">
							${item.packageUnitName}<br/>
							</c:if>
							<c:if test="${item.packageUnit == '8'}">
							${item.packageUnitName}/${mNoData.packageEtc}<br/>
							</c:if>
							</c:forEach>				
						</dd>
					</li>					
					<li>
						<dt>비고</dt>
						<dd>
							${mNoData.comment}
						</dd>
					</li>
				</ul>
			</div>			
			<div class="btn_box_con">				
				<button type="button" class="btn_admin_gray" onclick="bPopup_close();">닫기</button>
			</div>			
		</div>
	</section>
</div>
