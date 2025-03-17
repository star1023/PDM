<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<title>표시사항배합비</title>

<script type="text/javascript" src="/resources/js/jquery.auto-complete.js"></script>
<script type="text/javascript">
	var initBody;
	function beforePrint() {
		initBody = document.body.innerHTML;
		document.body.innerHTML = print_page.innerHTML;
	}

	function afterPrint() {
		document.body.innerHTML = initBody;
	}

	function pageprint() {
		window.onbeforeprint = beforePrint;
		window.onafterprint = afterPrint;
		window.print();
	}
	
	function saveDispInfo(){
		var postData = {}
		
		$('#dispBody').children('tr').toArray().forEach(function(tr, i){
			var paramPath = 'disp['+i+'].';
			
			var dNo = $(tr).children('td').children('input[name=dNo]').val();
			var dpNo = $(tr).children('td').children('input[name=dpNo]').val();
			var etc = $(tr).children('td').children('input[name=etc]').val();
			
			postData[paramPath+'dNo'] = dNo;
			postData[paramPath+'dpNo'] = dpNo;
			postData[paramPath+'etc'] = etc;
			
			postData['dNo'] = dNo;
		});
		
		postData['docProdName'] = $('#docProdName').val();
		
		$.post('/dev/editDispInfo', postData, function(data){
			if(data > 0){
				alert('정상적으로 수정되었습니다.');
				reloadDispInfo();
			} else {
				alert('수정 오류[1]')
			}
		}).fail(function(res){
			//console.log('Error: ' + res.responseText)
			alert('수정 오류[2]')
		})
	}
	
	function reloadDispInfo(){
		var url = '/dev/dispPopup';
		
		var dNo = '${dNo}';
		
		var form = document.createElement('form');
		form.style.display = 'none';
		$('body').append(form);
		form.action = url;
		form.method = 'post';
		
		appendInput(form, 'dNo', dNo);
		
		$(form).submit();
	}
</script>

<div class="wrap_pop">
	<div class="wrap_in02">
		<div class="wrap_in">
			<h2 style="position: fixed;" class="print_hidden">
				<span class="title"><img src="/resources/images/bg_bs_box_fast02.png">&nbsp;&nbsp;배합비</span>
			</h2>
			<div class="top_btn_box" style="position: fixed;">
				<ul>
					<li><button class="btn_pop_close" onclick="self.close();"></button></li>
				</ul>
			</div>

			<!--여기서부터 프린트 -->
			<div id='print_page' style="padding: 10px 0 20px 20px;">
				<table width="1046" cellpadding="0" cellspacing="0" class="print_hidden">
					<tr>
						<td align="right" height="90" valign="bottom">
							<button class="btn_admin_red" onclick="saveDispInfo()">수정 완료</button>
							<button class="btn_admin_gray" onclick="history.back()">취소</button>
						</td>
					</tr>
				</table>

				<!-- 출력버튼 -->

				<!-- 실제 출력대상 start ------------------------------------------------------------------------------------------------------------------------------------------------>
				<div class="group01" style="padding: 0; width: 1046px;">
					<div class="title5" style="margin-top: -40px;"><span class="txt"><input id="docProdName" type="text" style="height:30px;font-size: 23px; width: 50%" value="${docProdName}"/></span></div>
					<!-- <div class="title5" style="margin-top: -40px;"><span class="txt" id="docProdName"></span></div> -->
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
									<th style="border-left: none;">문서번호</th>
									<td>SHA-L-001</td>
									<th>제개정일</th>
									<td id="modDate"></td>
									<th>개정판수</th>
									<td id="docVersion"></td>
								</tr>
							</tbody>
						</table>
					</div>
					<div class="hold">
						<!-- 표시사항 배합비 start --------------------------------------------------------------------------------------------------------------------------------------------------------->
						<table class="tbl01 mt20">
							<colgroup>
								<col width="40%">
								<col width="30%">
								<col />
							</colgroup>
							<thead>
								<tr>
									<th>원료명</th>
									<th>백분율</th>
									<th>급수포함</th>
								</tr>
							</thead>
							<tbody id="dispBody">
								<c:forEach items="${dispInfo}" var="disp" varStatus="dispStatus">
									<c:set var="excRateTotal" value="${disp.excRate + excRateTotal}"/>
									<c:set var="incRateTotal" value="${disp.incRate + incRateTotal}"/>
									<tr>
										<td style="padding-left: 30px;">
											<input type="hidden" name="dNo" value="${dNo}"/>
											<input type="hidden" name="dpNo" value="${disp.dPNo}"/>
											<input type="text" name="etc" style="width: 100%" value="${disp.etc == null ? disp.matName : disp.etc}">
										</td>
										<td>${disp.excRate}</td>
										<td>${disp.incRate}</td>
									</tr>	
								</c:forEach>
							</tbody>
							<tfoot>
								<tr>
									<th>합계</th>
									<td><fmt:formatNumber value="${excRateTotal}" pattern=".000"/></td>
									<td><fmt:formatNumber value="${incRateTotal}" pattern=".000"/></td>
								</tr>
							</tfoot>
						</table>

						<!-- 표시사항 배합비 close --------------------------------------------------------------------------------------------------------------------------------------------------------->
					</div>

					<!-- 실제 출력대상 close ------------------------------------------------------------------------------------------------------------------------------------------------>
					<!-- 출력버튼 -->
					<table width="1046" cellpadding="0" cellspacing="0"
						class="print_hidden">
						<tr>
							<td align="right" height="50" valign="bottom">
								<button class="btn_admin_red" onclick="saveDispInfo()">수정 완료</button>
								<button class="btn_admin_gray" onclick="history.back()">취소</button>
							</td>
						</tr>
					</table>
					<!-- 여기까지 프린트 -->
				</div>
			</div>
		</div>
	</div>