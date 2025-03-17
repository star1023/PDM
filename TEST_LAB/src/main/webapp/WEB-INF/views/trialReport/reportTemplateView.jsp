<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ page import="kr.co.aspn.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ page session="false" %>
<%
	String userId = UserUtil.getUserId(request);
%>
<title>레포트</title>
<link rel="stylesheet" href="/resources/CLEditor/jquery.cleditor.css?param=1" />
<script type="text/javascript" src="/resources/CLEditor/jquery.cleditor.min.js?param=1"></script>
<link href="/resources/js/jquery.auto-complete.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="/resources/js/jquery.auto-complete.js"></script>

<div class="wrap_in" id="fixNextTag">
	<span class="path">시생산 보고서&nbsp;&nbsp;<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;보고서&nbsp;&nbsp;<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;<a href="#">${strUtil:getSystemName()}</a></span>
	<section class="type01">
		<h2 style="position:relative"><span class="title_s">Trial Production Report</span>
			<span class="title" id="span_reportTitle">시생산 보고서 작성</span>
			<div  class="top_btn_box">
				<ul>
					<li>
						<button class="btn_circle_nomal" id="list" onclick="editReportCancel()">&nbsp;</button>
					</li>
				</ul>
			</div>
		</h2>
		<div class="group01" >
			<div class="title"></div>
			<!-- 문서 본체 start -->
			<div id="reportContents">
				<style type="text/css">
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
				</style>
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
							<td></td>
						</tr>
						<tr>
							<td class="hftitle">일시(시작일)</td>
							<td></td>
						</tr>
						<tr>
							<td class="hftitle">일시(종료일)</td>
							<td></td>
						</tr>
						<tr>
							<td class="hftitle">연구원</td>
							<td></td>
						</tr>
						<tr>
							<td colspan="5" class="hftitle">제품명</td>
							<td colspan="2" class="hftitle">유형</td>
							<td class="hftitle">생산센터</td>
							<td class="hftitle">유통채널</td>
							<td class="hftitle">출시일(목표)</td>
						</tr>
						<tr>
							<td colspan="5"><span class="big_font">xxxx(xxxx)/xxxx</span></td>
							<td colspan="2">
							</td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<td colspan="3" class="hftitle">시상산 결과</td>
							<td colspan="5" style="text-align: center">
								<div>
									<input type="checkbox" id="pass" /><label for="pass"><span></span>합격</label>&nbsp;&nbsp;&nbsp;
									<input type="checkbox" id="progress" /><label for="progress"><span></span>조건부 진행</label>&nbsp;&nbsp;&nbsp;
									<input type="checkbox" id="retest" /><label for="retest"><span></span>재실험</label>&nbsp;&nbsp;&nbsp;
									<input type="checkbox" id="fail" /><label for="fail"><span></span>불가</label>
								</div>
							</td>
							<td class="hftitle">출시가능일</td>
							<td></td>
						</tr>
						<tr>
							<td colspan="2" rowspan="5" class="hftitle">작성자/의견</td>
							<td class="hftitle"></td>
							<td colspan="2"></td>
							<td colspan="5" style="text-align: left; vertical-align: top"></td>
						</tr>
						<tr>
							<td class="hftitle"></td>
							<td colspan="2"></td>
							<td colspan="5" style="text-align: left; vertical-align: top"></td>
						</tr>
						<tr>
							<td class="hftitle"></td>
							<td colspan="2"></td>
							<td colspan="5" style="text-align: left; vertical-align: top"></td>
						</tr>
						<tr>
							<td class="hftitle"></td>
							<td colspan="2"></td>
							<td colspan="5" style="text-align: left; vertical-align: top"></td>
						</tr>
						<tr>
							<td class="hftitle"></td>
							<td colspan="2"></td>
							<td colspan="5" style="text-align: left; vertical-align: top"></td>
						</tr>
					</table>
				</div>
				<!--head end-->


				<div>
					${reportBody}
				</div>

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
						<tr>
							<td rowspan="2" class="hftitle">사진</td>
							<td class="hftitle">완제품</td>
							<td class="hftitle">포장1</td>
							<td class="hftitle">포장2 (PVC, 적재 등)</td>
							<td class="hftitle">기타 첨부 이미지</td>
						</tr>
						<tr>
							<td style="height: 160px">
								<img src="/resources/images/img_noimg.png" style="width:100%; height:160px; max-height:200px;" alt=""/>
							</td>
							<td>
								<img src="/resources/images/img_noimg.png" style="width:100%; height:160px; max-height:200px;" alt=""/>
							</td>
							<td>
								<img src="/resources/images/img_noimg.png" style="width:100%; height:160px; max-height:200px;" alt=""/>
							</td>
							<td>
								<img src="/resources/images/img_noimg.png" style="width:100%; height:160px; max-height:200px;" alt=""/>
							</td>
						</tr>
					</table>
				</div>
				<!-- footer end -->
			</div>
			<!-- 문서 본체 close -->
			<div class="btn_box_con5"></div>
			<div class="btn_box_con4">
				<input type="button" class="btn_admin_sky" id="editStart" value="작성시작" onclick="editReportStart();" >
				<input type="button" class="btn_admin_sky" id="editEnd" value="작성완료" onclick="editReportEnd();" >
				<input type="button" class="btn_admin_gray" id="cancel" value="취소" onclick="editReportCancel()">
			</div>
		</div>
	</section>	
</div>

<script type="text/javascript">

	var editReportStart = function(){
		var editableElements = $("[name=contenteditable]");
		$.each(editableElements,function(index,element){
			var inputs = $(element).find("input[type=checkbox]");
			if(inputs.length > 0){
				$(inputs).removeAttr("disabled");
				//$(element).attr("contenteditable",true);
			}else{
				$(element).attr("contenteditable",true);
				$(element).css("text-align","left");
				$(element).css("vertical-align","top");
			}
		});
	}

	var editReportEnd = function(){
		var editableElements = $("[name=contenteditable]");
		$.each(editableElements,function(index,element){
			var inputs = $(element).find("input[type=checkbox]");
			if(inputs.length > 0){
				$.each(inputs,function(index,item){
					if($(item).prop("checked")) {
						$(item).attr("checked", "checked");
					}else{
						$(item).removeAttr("checked");
					}
					$(item).attr("disabled","disabled");
				});
			}else{
				$(element).attr("contenteditable",false);
			}
		});
	}

	var editReportCancel = function(){
		if("${from}" == "trialReportList"){
			// TODO bug  상태 변경 않됨
			console.log(editTrialReport.pageMode);
			if(editTrialReport.pageMode == "edit"){
				$.post("/trialReport/editCancel?rNo=${rNo}&cNo=${cNo}",null,function(data){
					console.log(data);
					window.location.href = "/trialReport/trialReportList?func=historyBack";
				})
			}else{
				window.location.href = "/trialReport/trialReportList?func=historyBack";
			}
		}else if("${from}" == "productDevDocDetail"){
			var form = document.createElement('form');
			form.style.display = 'none';
			$('body').append(form);
			form.action = '/dev/productDevDocDetail';
			form.target = '_self';
			form.method = 'post';
			appendInput(form, 'docNo', "${docNo}");
			appendInput(form, 'docVersion', "${docVersion}");

			$(form).submit();
		}else{
			window.history.back();
		}
	}

	$(document).ready(function(){
		//editTrialReport.editable();
	});

</script>

