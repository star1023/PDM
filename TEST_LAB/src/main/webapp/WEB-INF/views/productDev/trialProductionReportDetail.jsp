<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ page import="java.util.*,kr.co.aspn.vo.*,kr.co.aspn.util.*" %>
<%@ page import="kr.co.aspn.util.StringUtil" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ taglib prefix="userUtil" uri="/WEB-INF/tld/userUtil.tld"%>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>

<%@ page session="false" %>
<%
	pageContext.setAttribute("crcn", "\n");
	pageContext.setAttribute("br", "<br>");
%>
	
<div class="wrap_in" id="fixNextTag">
	<span class="path">
		시생산 보고서
		&nbsp;&nbsp;
		<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;
		게시판&nbsp;&nbsp;
		<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;
		<a href="#">${strUtil:getSystemName()}</a>
	</span>
	
	<form id="writeform" name="writeform">
	<input type="hidden" id="state" name="state" value="" />
	<input type="hidden" id="loginUser" name="loginUser" value="${userUtil:getUserId(pageContext.request)}" />
	<input type="hidden" id="createUser" name="createUser" value="${trialProductionReport.createUser}" />
	
	<section class="type01">
		<h2 style="position:relative">
			<span class="title_s">Notice</span>
			<span class="title">시생산 보고서 상세</span>
			<div class="top_btn_box">
				<ul><li><button class="btn_circle_nomal" id="btnList1">&nbsp;</button></li></ul>
			</div>
		</h2>
		<div class="group01" >
			<div class="title"><!--span class="txt">연구개발시스템 공지사항</span--></div>
<!-- 			<div class="notice_title"> -->
<!-- 				<span class="font17" id="title"></span> -->
<!-- 				<br/> -->
<!-- 				<span class="font18" id="description"> -->
					 
<!-- 				</span> -->
<!-- 			</div> -->

			<div class="title5"><span class="txt">01. 기본정보</span><!--span class="txt">01. 보고서명 : 영등포 점포 시장조사내역</span--></div>
			<div class="main_tbl">
				<table class="insert_proc01">
					<colgroup>
						<col width="10%">
						<col width="35%">
						<col width="auto">
					</colgroup>
					<tbody>
						<tr>
							<th style="border-left: none;">제조공정서 번호</th>
							<td id="dno"></td>
						</tr>
						<tr>
							<th style="border-left: none;">라인</th>
							<td id="lineName"></td>
						</tr>
						<tr>
							<th style="border-left: none;">시생산일</th>
							<td id="trialDate"></td>
						</tr>
						
					</tbody>
				</table>
			</div>
			
			<div class="title5" style="float:left; margin-top:30px;"><span class="txt">02. 시생산 주요사항</span></div>
			<div class="main_tbl">
				<table class="insert_proc01">
					<tbody>
						<tr><td id="importantNote"></td></tr>
					</tbody>
				</table>
			</div>
			
			<div class="main_tbl">
				<!-- 첨부파일 Start -->
				<ul class="notice_view">
					<li>
						<div class="con_file fl" id="fileArea" style="padding-bottom:-20px; padding-top:20px">
							<ul>
								<li>
									<dt>첨부파일</dt><dd>
										<ul id="fileList"></ul>
									</dd>
								</li>
							</ul>
						</div>
					</li>
				</ul>
				<!-- 첨부파일 End -->
				
				<div class="btn_box_con5">
					<button class="btn_admin_gray" id="btnList2" style="width:120px;">목록</button>
				</div>
				<div class="btn_box_con4">
					<!--  
					<button class="btn_admin_navi" id="btnModify">수정</button> 
					 -->	
					<button class="btn_admin_gray" id="btnDelete">삭제</button> 
				</div>
				<hr class="con_mode"/><!-- 신규 추가 꼭 데려갈것 !-->
			</div>
		</div>
	</section>
	</form>
</div>

<script type="text/javascript">
	
	(function( window, document, jQuery ){
		
		function _isEmpty( value ){
			return ( value === '' || value === null || value === undefined );
		}
	
		function _isNotEmpty( value ){
			return !( _isEmpty( value ) );
		}
		
		function _fnFindElement( identity ){
			return document.getElementById( identity );
		}
		
		function _fnFindElementValue( identity ){
			var element = document.getElementById(identity);
			var elementType = element.type;
			var elementValue;
			switch( elementType ){
				case 'text':
				case 'textarea':
				case 'hidden':
				case 'select-one':
					elementValue = element.value;
					break;
			}
			return elementValue;
		}
		
		function _fnCreateElement(configuration){
			var element = document.createElement( configuration.element );
			for(var key in configuration)
				element[key] = configuration[key];
			
			if( _isNotEmpty( configuration['appendNode'] ) ){
				element['appendNode'].appendChild( element );
			}
			return element;
		}
		
		function _fnFindURLParameterByName( name ){
			var result = null;
			var urlParams = document.location.search;
			urlParams = urlParams.replace(/\?/g, '');
			urlParams = urlParams.split('&');
			
			var index = 0;
			var length = urlParams.length;
			for(; index < length; index = index + 1){
				var _arr = urlParams[index];
				var oName = _arr.split('=')[0];
				var oValue = _arr.split('=')[1];
				if( name === oName )
					result = decodeURIComponent( oValue );
			}
			return result;
		}
		
		function _fnRemoveUrlParamByName(param, name){
			if( _isEmpty( param ) || _isEmpty( name ) ){
				throw Error('parameter is empty!');
				return;
			}
			
			var aParam = param.split('&');
			var result = '';
			var index = 0;
			if( aParam.length > 0 ){
				for(; index < aParam.length; index = index + 1){
					var _arr = aParam[index].split('=');
					if( _isNotEmpty( _arr[0] ) && _arr[0] !== name ){
						result = result + ( _isNotEmpty( result ) ? '&' : '');
						result = result + _arr[0] + '=' + _arr[1];
					}
				}
			}
			return result;
		}
		
		// 목록 버튼
		var _fnMoveList = function(event){
			if(_isNotEmpty( event ))
				event.preventDefault();
			
			var moveform	= _fnCreateElement({ element : 'form', id : 'moveform', name : 'moveform', action : '/dev/productDevDocDetail', method : 'post', target : '_self' });
			var docNo		= _fnCreateElement({ element : 'input',	type : 'hidden', id : 'docNo',		name : 'docNo',		 value : _fnFindURLParameterByName( 'docNo' ),		appendNode : moveform });
			var docVersion	= _fnCreateElement({ element : 'input',	type : 'hidden', id : 'docVersion',	name : 'docVersion', value : _fnFindURLParameterByName( 'docVersion' ),	appendNode : moveform });
//				var regUserId	= _fnCreateElement({ element : 'input',	type : 'hidden', id : 'regUserId',	name : 'regUserId',	 value : _fnFindURLParameterByName( 'regUserId' ),	appendNode : moveform });
			
			if(_isEmpty( document.body.moveform ))
				document.body.appendChild( moveform );
			
			moveform.submit();
			return;
		};
		_fnFindElement( 'btnList1' ).addEventListener('click', _fnMoveList);
		_fnFindElement( 'btnList2' ).addEventListener('click', _fnMoveList);
		
		// 수정 버튼 (비활성화)(고도화 이후 데이터 방지 차원)
		/*	
// 		_fnFindElement( 'btnModify' ).addEventListener('click', function(event){
// 			event.preventDefault();
			
// 			var state = _fnFindElementValue('state');				// 상태
// 			var loginUser = _fnFindElementValue('loginUser');		// 로그인 사용자 아이디
// 			var createUser = _fnFindElementValue('createUser');		// 보고서 작성자 아이디
			
// 			if(loginUser !== createUser){
// 				alert('작성자만 수정할 수 있습니다.');
// 				return;
// 			}
// 			if( state != '0' ){
// 				alert('등록 상태일 때만 수정 가능합니다.');
// 				return;
// 			}
// 			location.href = '/dev/trialProductionReportModify' + urlParams;
// 			return;
// 		});
		*/
		
		// 삭제 버튼
		_fnFindElement( 'btnDelete' ).addEventListener('click', function(event){
			event.preventDefault();
			
			var state = _fnFindElementValue('state');				// 상태
			var loginUser = _fnFindElementValue('loginUser');		// 로그인 사용자 아이디
			var createUser = _fnFindElementValue('createUser');		// 보고서 작성자 아이디
			
			if(loginUser !== createUser){
				alert('작성자만 삭제할 수 있습니다.');
				return;
			}
			if( state != '0' ){
				alert('등록 상태일 때만 삭제 가능합니다.');
				return;
			}
			
			if(confirm('정말 삭제하시겠습니까?\r\n삭제되면 복구할 수 없습니다.')){
				if(confirm('이 보고서를 삭제합니다.')){
					jQuery.ajax({
						async : false,
						type : 'GET',
						dataType : 'json',
						url : '/dev/deleteTrialProductionReport',
						data : { rNo : rNo },
						success : function( response ){
							if( response ){
								alert('삭제 완료되었습니다.');
								_fnMoveList();
								return;
							}else{
								alert('삭제에 실패했습니다.\r\n다시 시도하거나 관리자에게 문의해 주세요.');
								return;
							}
						},
						error : function(){
							alert('삭제에 실패했습니다.\r\n다시 시도하거나 관리자에게 문의해 주세요.');
							return;
						}
					});
				}
			}
		});
		
		var urlParams = document.location.search;		// Parameter
		var rNo = _fnFindURLParameterByName( 'rNo' );	// Index
		var docNo = _fnFindURLParameterByName( 'docNo' );
		var docVersion = _fnFindURLParameterByName( 'docVersion' );
		
		if( _isEmpty( rNo ) ){
			alert('잘못된 접근입니다.\r\n보고서 정보가 없습니다.');
// 			location.href = '/qareport/list?' + _fnRemoveUrlParamByName(urlParams, 'rNo');
			_fnMoveList();
			return
		}
		
		// Select Detail
		jQuery.ajax({
			async : false,
			type : 'GET',
			dataType : 'json',
			url : '/dev/selectTrialProductionReportDetail',
			data : { rNo : rNo, docNo : docNo, docVersion : docVersion },
			success : function( data ){
				var detail = data.detail;
				var files = data.files;
				var desc, index, ul, li, a;
				
				// Validation
				if( _isEmpty( data ) || _isEmpty( detail ) ){
					alert('잘못된 접근입니다.');
					_fnMoveList();
					return;
				}
				
				// 보고서 정보
				for(var key in detail){
					var element = _fnFindElement( key );
					if(_isNotEmpty( element )){
						
						if( element.type === 'hidden'){
							element.value = detail[key];
						}else{
							element.innerHTML = detail[key];
						}
					}
				}
				
				// 시생산 주요사항 추가 예외처리
				var importantNote = detail['importantNote'];
				importantNote = importantNote.replace(/(\n)/gi, '<br/>');
				importantNote = importantNote.replace(/(\t)/gi, '&nbsp;&nbsp;&nbsp;&nbsp;');
				_fnFindElement('importantNote').innerHTML = importantNote;
				
				// 첨부파일
				if( files != null && files.length ){
					for(index = 0; index < files.length; index++){
						ul = _fnCreateElement({ element : 'ul', appendNode : _fnFindElement( 'fileList' ) });
						li = _fnCreateElement({ element : 'li', appendNode : ul });
						a = _fnCreateElement({
							element : 'a',
							href : '/file/fileDownload?fmNo=' + files[index].fmNo + '&tbkey=' + files[index].tbKey + '&tbType=trialprodreport',
							innerHTML : files[index].orgFileName,
							appendNode : li
						});
						li.innerHTML += ' (' + files[index].regDate + ')';
					}
					return;
				}else{
					_fnFindElement( 'fileArea' ).style.display = 'none';
					return;
				}
			},
			error : function(){
				alert('시생산 보고서 상세 조회에 실패했습니다.\r\n다시 시도하거나 관리자에게 문의해 주세요.');
				return;
			}
		});
		
	})(window, document, jQuery);
	
</script>