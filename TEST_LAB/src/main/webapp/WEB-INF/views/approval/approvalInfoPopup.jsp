<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ page session="false" %>
<title>결재함</title>
<script type="text/javascript">
function viewNote(apbNo) {
	var URL = "../approval/viewNoteAjax";
	$.ajax({
		type:"POST",
		url:URL,
		data:{
			"apbNo" : apbNo
		},
		dataType:"json",
		success:function(data) {
			$("#viewNote").html(getTextareaHTML(data.note));
		},
		error:function(request, status, errorThrown){
			alert("오류가 발생하였습니다.");
		}			
	});
}

function getTextareaHTML(note) {
    return "</p><p>"+ note.trim().replace(/\n\r?/g,"</p><p>") +"</p>";
}
</script>
<h2 style=" position:fixed;" class="print_hidden">
	<span class="title"><img src="/resources/images/bg_bs_box_fast02.png">&nbsp;&nbsp;결재상세보기</span>
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
			<td valign="top">
				<div class="main_tbl">
					<table class="insert_proc01 tbl_app">
						<colgroup>
							<col width="13%"/>
							<col width="50%"/>
							<col />
						</colgroup>
						<tbody>
							<tr>
							<td style="border-left: none;" height="50" colspan="4">
								&nbsp;
					        </td>
							</tr>
							<tr>
								<th style="border-left: none;">요청사유</th>
								<td colspan="3">
									${apprItemHeader.comment}
								</td>
							</tr>
							<tr>
								<th style="border-left: none;"> 결재자</th>
								<td>
									<div class="file_box_pop5">
										<ul>
											<c:forEach items = "${apprItemList}" var = "item" varStatus= "status">
											<input type="hidden" name="seq" id="seq" value="${item.seq }">
											<fmt:parseNumber var="seq" type="number" value="${item.seq}" />
											<li onMouseOver="location.href='#'">
												<span>
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
												</span> 
												${item.userName}
												<c:if test="${item.proxyYN eq 'Y' }">
													(대결:${item.proxyId})
												</c:if> <strong> ${item.authName}/${item.deptCodeName}&nbsp;(</strong><i>${item.stateText}</i>
												<strong>
													<c:choose>
													<c:when test="${item.seq eq '1' }">
													:${item.regDate}
													</c:when>
													<c:otherwise>
													<c:if test="${item.modDate != '' && item.modDate != null}">
													:${item.modDate}
													</c:if>
													</c:otherwise>												
													</c:choose>
													 ) 
												</strong> 
												<c:if test="${item.note !=null && item.note ne '' }">
													<a href="#" onclick="viewNote('${item.apbNo}');">
														의견 <img src="/resources/images/icon_app_mass.png"/>
													</a>
												</c:if>
											</li>										
											</c:forEach>
										</ul>
									</div>
								</td>
								<td id="viewNote">결재자 리스트 클릭시 결재의견을 확인할 수 있습니다.</td>
							</tr>
							<tr>
								<th style="border-left: none; ">참조자 및 회람자</th>
								<td>
									<div class="file_box_pop4">
										<ul>
											<c:forEach items = "${referenceList}" var = "ref">
											<c:if test="${ref.type eq 'C'}">
												<li><span> 회람</span> ${ref.userName} <strong> ${ref.authName}/${ref.deptCodeName}</strong></li>
											</c:if>
											</c:forEach>
										</ul>
									</div>
								</td>
								<td>
									<div class="file_box_pop4">
										<ul>
											<c:forEach items = "${referenceList}" var = "ref">
											<c:if test="${ref.type eq 'R'}">
												<li><span> 참조</span> ${ref.userName} <strong> ${ref.authName}/${ref.deptCodeName}</strong></li>
											</c:if>
											</c:forEach>
										</ul>
									</div>
								</td>
							</tr>							
						</tbody>
					</table>
				</div>
			</td>
		</tr>
	</table>
</div>
<div class="btn_box_con5">
</div>				
<div class="btn_box_con4">
	<!--button class="btn_admin_gray" onClick="self.close();"  style="width:120px;">닫기</button-->
</div>

