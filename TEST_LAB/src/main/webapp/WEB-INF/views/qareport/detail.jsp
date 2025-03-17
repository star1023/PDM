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
		품질 보고서&nbsp;&nbsp;
		<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;
		보고서&nbsp;&nbsp;
		<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;
		<a href="#">${strUtil:getSystemName()}</a>
	</span>
	
	<section class="type01">
		<h2 style="position:relative">
			<span class="title_s">Report</span>
			<span id="categoryName" class="title"></span>
			<div class="top_btn_box">
				<ul><li><button class="btn_circle_nomal" id="btnList1">&nbsp;</button></li></ul>
			</div>
		</h2>
		<div class="group01" >
			<div class="title"><!--span class="txt">연구개발시스템 공지사항</span--></div>
			<div class="notice_title">
				<span class="font17" id="title"></span>
				<br/>
				<span class="font18" id="description">
					 
				</span>
			</div>
		
			<div class="main_tbl">
				<!-- 첨부파일 Start -->
				<ul class="notice_view">
					<li>
						<div class="text_view" id="content" style="border-bottom:1px solid #ddd;"></div>
						
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
					<button class="btn_admin_navi" id="btnModify">수정</button> 
					<button class="btn_admin_gray" id="btnDelete">삭제</button> 
				</div>
				<hr class="con_mode"/><!-- 신규 추가 꼭 데려갈것 !-->
			</div>
		</div>
	</section>
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
			var _urlParams = document.location.search.split('&');
			var result = null;
			var index = 0;
			var length = _urlParams.length;
			for(; index < length; index = index + 1){
				var _arr = _urlParams[index];
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
		
		
		
		var rNo = _fnFindURLParameterByName( 'rNo' );	// Index
		var urlParams = document.location.search;		// Parameter
		
		if( _isEmpty( rNo ) ){
			alert('잘못된 접근입니다.\r\n보고서 정보가 없습니다.');
			location.href = '/qareport/list?' + _fnRemoveUrlParamByName(urlParams, 'rNo');
			return
		}
		
		// 목록 버튼
		var _fnMoveList = function(event){
			event.preventDefault();
			location.href = '/qareport/list' + _fnRemoveUrlParamByName(urlParams, 'rNo');
			return;
		};
		_fnFindElement( 'btnList1' ).addEventListener('click', _fnMoveList);
		_fnFindElement( 'btnList2' ).addEventListener('click', _fnMoveList);
		
		// 수정 버튼
		_fnFindElement( 'btnModify' ).addEventListener('click', function(event){
			event.preventDefault();
			location.href = '/qareport/modify' + urlParams;
			return;
		});
		
		// 삭제 버튼
		_fnFindElement( 'btnDelete' ).addEventListener('click', function(event){
			event.preventDefault();
			
			if(confirm('정말 삭제하시겠습니까?\r\n삭제되면 복구할 수 없습니다.')){
				if(confirm('이 보고서를 삭제합니다.')){
					// Delete
					jQuery.ajax({
						async : false,
						type : 'DELETE',
						dataType : 'json',
						contentType : 'application/json; charset=utf-8',
						url : '/qareport/deleteQAReport',
						data : JSON.stringify({ rNo : rNo }),
						success : function( response ){
							if( response ){
								alert('삭제 완료되었습니다.');
								location.href = '/qareport/list?' + _fnRemoveUrlParamByName(urlParams, 'rNo');
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
		
		// Select Detail
		jQuery.ajax({
			async : false,
			type : 'GET',
			dataType : 'json',
			url : '/qareport/selectQAReportDetail',
			data : { rNo : rNo },
			success : function( data ){
				if( _isNotEmpty( data ) ){
					var detail = data.detail;
					var files = data.files;
					var desc, index, ul, li, a;
					
					// 상단메뉴명 설정
					_fnFindElement( 'categoryName' ).innerHTML = data.detail.categoryName;
					
					// 보고서 정보
					_fnFindElement( 'title' ).innerHTML = detail.title;
					desc = detail.categoryName;
					desc = desc + '<strong>&nbsp;|&nbsp;</strong>작성자 : ' + detail.createName;
					desc = desc + '<strong>&nbsp;|&nbsp;</strong><img src="../resources/images/btn_calendar2.png" style=" margin-top:-2px;"> 작성일 : ' + detail.createDate;
					_fnFindElement( 'description' ).innerHTML = desc;
					_fnFindElement( 'content' ).innerHTML = detail.content;
					
					// 첨부파일
					if( files != null && files.length ){
						for(index = 0; index < files.length; index++){
							ul = _fnCreateElement({ element : 'ul', appendNode : _fnFindElement( 'fileList' ) });
							li = _fnCreateElement({ element : 'li', appendNode : ul });
							a = _fnCreateElement({
								element : 'a',
								href : '/file/fileDownload?fmNo=' + files[index].fmNo + '&tbkey=' + files[index].tbkey + '&tbType=qareport',
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
				}else{
					alert('상세 정보 조회에 실패했습니다.\r\n다시 시도하거나 관리자에게 문의해 주세요.');
					return;
				}
			},
			error : function(){
				alert('상세 정보 조회에 실패했습니다.\r\n다시 시도하거나 관리자에게 문의해 주세요.');
				return;
			}
		});
		
	})(window, document, jQuery);
	
</script>