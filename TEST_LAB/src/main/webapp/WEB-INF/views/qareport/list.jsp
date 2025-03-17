<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ page session="false" %>
<title>레포트</title>
<script type="text/javascript" src='<c:url value="/resources/js/jquery.selectboxes.js"/>'></script>

<form name="listForm" id="listForm" method="post">
<input type="hidden" name="rNo" id="rNo"/>
<input type="hidden" name="pageNo" id="pageNo" value="${paramVO.pageNo}"/>

<div class="wrap_in" id="fixNextTag">
	<span class="path">품질 보고서&nbsp;&nbsp;
		<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;
		<a href="#">${strUtil:getSystemName()}</a>
	</span>
	<section class="type01">
	<!-- 상세 페이지  start-->
		<h2 style="position:relative">
			<span class="title_s">Report</span>
			<span class="title">품질 보고서</span>
			<div  class="top_btn_box">
				<div  class="top_btn_box">
					<ul><li><button type="button" class="btn_circle_red" id="writeButton1">&nbsp;</button></li></ul>
				</div>
			</div>
		</h2>
		<div class="group01">
			<div class="title"><!--span class="txt">연구개발시스템 공지사항</span--></div>
			<div class="search_box" >
				<ul>
					<li>
						<dt>키워드</dt>
						<dd>
							<div class="selectbox" style="width:150px;">  
								<label for="category" id="category_label">전체</label> 
								<select id="category" name="category">
									<option value="">전체</option>
								<c:forEach  items="${category }" var = "code">
									<c:choose>
										<c:when test="${code.itemCode eq  user.deptCode}">
											<option value="${code.itemCode}" selected>${code.itemName}</option>
										</c:when>
										<c:otherwise>
											<option value="${code.itemCode}">${code.itemName }</option>
										</c:otherwise>
									</c:choose>
								</c:forEach>
								</select>
							</div>
							<input type="text" name="skey" id="skey" value="${paramVO.skey}" class="ml5" style="width:150px;"/>
						</dd>
					</li>
					<li>
						<dt>표시수</dt>
						<dd >
							<div class="selectbox" style="width:100px;">  
								<label for="perPage" id="perPage_label">선택</label> 
								<select name="perPage" id="perPage">		
									<option value="">선택</option>													
									<option value="10">10</option>
									<option value="20">20</option>
									<option value="50">50</option>
									<option value="100">100</option>
								</select>
							</div>
						</dd>
					</li>
				</ul>
				<div class="fr pt5 pb10">
					<button type="button" class="btn_con_search" id="search"><img src="/resources/images/btn_icon_search.png" style="vertical-align:middle;"/> 검색</button>
					<button type="button" class="btn_con_search" id="clear"><img src="/resources/images/btn_icon_refresh.png" style="vertical-align:middle;"/> 검색 초기화</button>
				</div>
			</div>
			<div class="main_tbl">
				<table class="tbl01">
					<colgroup>
						<col width="5%">
						<col width="20%">
						<col width="5%">
						<col />
						<col width="10%">
						<col width="20%">
					</colgroup>
					<thead>
						<tr>
							<th>번호</th>
							<th>분류</th>
							<th>&nbsp;</th>
							<th>보고서명</th>
							<th>보고자</th>
							<th>등록일</th>
						</tr>	
					</thead>
					<tbody id="list"><!-- Listing Area --></tbody>
				</table>
				
				<div class="page_navi mt10" id="paging"><!-- Paging Area --></div>
				
				<div class="btn_box_con"><input type="button" class="btn_admin_red" id="writeButton2" value="보고서 작성"></div>
				
			 	<hr class="con_mode"/><!-- 신규 추가 꼭 데려갈것 !-->
			 	
			</div>
		</div>
	</section>	
</div>

</form>

<script type="text/javascript">
	
	(function(window, document, jQuery){ // IIFE
		
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
			var urlParams = document.location.search.split('&');
			var result = null;
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
		
		function _fnRefreshSelectBox( identity ){
			var selectBox = _fnFindElement( identity );
			var selectLabel = selectBox.parentNode.childNodes[1];
			var selectedValue = selectBox.value;
			var selectedText = selectBox.options[selectBox.selectedIndex].innerHTML;
			selectLabel.innerHTML = selectedText;
		}
		
		
		// PageManager Module
		function PageManager(config){
			
			this.listingTarget = 'list';
			this.listingTargetElement = null;
			this.ajaxUrl = '/qareport/selectListAndCount';
			this.param = {};
			
			this.rowCount = 0;
			this.rowData = [];
			
			this.endIndex = 0;
			this.startIndex = 0;
			
			this.perPage = 0;
			this.currentPage = 0;
			
			this.pageSize = 10;
			this.pagingTarget = 'paging';
			this.pagingTargetElement = undefined;
			
			this.startPage = 0;
			this.endPage = 0;
			
			this.pagingCount = 0;
			this.pagingGroupCount = 0;
			this.currentPageGroup = 0;
		}
		
		// 내부 함수 정의
		PageManager.prototype = {
			
			init : function(){
				var that = this;
				
				// 검색
				_fnFindElement( 'search' ).addEventListener('click', function(event){
					event.preventDefault();
					var oCategory = _fnFindElementValue( 'category' );
					var oSkey = _fnFindElementValue( 'skey' );
					that.param = { 'category' : oCategory, 'skey' : oSkey };
					that.loadList();
					return;
				});
				
				// 검색 초기화
				_fnFindElement( 'clear' ).addEventListener('click', function(event){
					event.preventDefault();
					_fnFindElement( 'skey' ).value = '';
					_fnFindElement( 'perPage' ).value = '';
					_fnRefreshSelectBox( 'perPage' );
					that.param = {};
					that.loadList();
					return;
				});
				
				// 글쓰기
				var _fnWrite = function(event){
					event.preventDefault();
					var paramStr = that.makeParamString(that);
					location.href = '/qareport/insert' + paramStr;
					return;
				};
				_fnFindElement( 'writeButton1' ).addEventListener('click', _fnWrite);
				_fnFindElement( 'writeButton2' ).addEventListener('click', _fnWrite);
				
				// 조회
				this.param = this.setSearchInputFromUrl();	// Parameter Setting
				this.loadList(this.param.pageNo);			// Listing
			},
			
			// 파라미터 문자열 생성
			makeParamString : function(that){
				var oSkey = _fnFindElementValue( 'skey' );
				var oPerPage = _fnFindElementValue( 'perPage' );
				var oCategory = _fnFindElementValue( 'category' );
				
				var paramStr = '';
				paramStr = paramStr + '?skey=' + oSkey;
				paramStr = paramStr + '&perPage=' + oPerPage;
				paramStr = paramStr + '&category=' + oCategory;
				
				if( _isNotEmpty( that ) )
					paramStr = paramStr + '&pageNo=' + that.currentPage;
				
				return paramStr;
			},
			
			// 검색 조건에 파라미터 세팅한 후 객체로 리턴
			setSearchInputFromUrl : function(){
				var oParams = document.location.search.replace('?', '');
				var aParams = oParams.split('&');
				var result = {};
				
				var index = 0;
				for(; index < aParams.length; index++){
					aParams[index] = decodeURIComponent( aParams[index] );
				}
				
				var arr, oName, oValue, element;
				for(index = 0; index < aParams.length; index++){
					arr = aParams[index].split('='), oName = arr[0], oValue = arr[1], element = _fnFindElement( oName );
					
					if( _isNotEmpty( element ) ){
						element.value = oValue;
						if(element.type === 'select-one') _fnRefreshSelectBox( oName );
					}
					result[ oName ] = oValue;
				}
				return result; 
			},
			
			/**
			 * Listing Start
			 */
			calculateStartIndex : function(){
				this.startIndex = ( ( +this.currentPage - 1 ) * +this.perPage ) + 1;
			},
			
			calculateEndIndex : function(){
				this.endIndex = ( +this.startIndex + +this.perPage ) - 1;
			},
			
			loadList : function(pageNo){
				var that = this;
				var selectedPerPage = _fnFindElementValue( 'perPage' );
				
				this.currentPage = ( _isNotEmpty( pageNo ) ) ? pageNo : 1;
				this.perPage = ( _isNotEmpty( selectedPerPage ) && selectedPerPage > 0) ? selectedPerPage : 10;
				
				this.calculateStartIndex();
				this.calculateEndIndex();
				
				this.param['startRow'] = this.startIndex;
				this.param['endRow'] = this.endIndex;
				
				jQuery.ajax({
					async : false,
					type : 'GET',
					dataType : 'json',
					url : this.ajaxUrl,
					data : this.param,
					success : function(response){
						
						that.rowData = response.list;
						that.rowCount = response.totalCount;
						that.listingTargetElement = _fnFindElement( that.listingTarget );
						
						// 리스트 초기화
						if( _isNotEmpty( that.listingTargetElement ) ) that.listingTargetElement.innerHTML = '';
						
						var td, a, rno, index = 0;
						for(; index < that.rowData.length; index = index + 1){
							var tr = _fnCreateElement({ element : 'tr' });
							// 번호
							_fnCreateElement({ element : 'td', innerHTML : that.rowData[index].rno, appendNode : tr });
							// 분류
							_fnCreateElement({ element : 'td', innerHTML : that.rowData[index].categoryName, appendNode : tr });
							// 빈값
							_fnCreateElement({ element : 'td', innerHTML : '', appendNode : tr });
							// 보고서명
							rno = that.rowData[index].rno;
							td = _fnCreateElement({ element : 'td', appendNode : tr });
							a = _fnCreateElement({
								element : 'a',
								href : 'javascript:void(0);',
								innerHTML : that.rowData[index].title,
								onclick : (function(index){
									var that = this;
									return function(event){
										event.preventDefault();
										that.viewDetail( that.rowData[index].rno );
									}
								}).call(that, index),
								appendNode : td
							});
							// 작성자
							_fnCreateElement({ element : 'td', innerHTML : that.rowData[index].createName, appendNode : tr });
							// 작성일
							_fnCreateElement({ element : 'td', innerHTML : that.rowData[index].createDate, appendNode : tr });
							// append
							that.listingTargetElement.appendChild(tr);
						}
						that.pageNavigator();
						return;
					},
					error : function(){
						alert('목록 조회에 실패했습니다.\r\n다시 시도하거나 관리자에게 문의해 주세요.');
						return;
					}
				});
			},
			
			viewDetail : function(rNo){
				var paramStr = this.makeParamString(this);
				location.href = '/qareport/detail' + paramStr + '&rNo=' + rNo;
			},
			
			/**
			 * Paging Start
			 */
			
			// 페이징 시작 번호
			calculateStartPage : function(){
				this.startPage = this.startPage ? this.startPage : 1;
			},
			
			// 페이징 끝 번호
			calculateEndPage : function(){
				this.endPage = this.startPage + this.pageSize - 1;
			},
			
			// 전체 페이징 개수
			calculatePagingCount : function(){
				this.pagingCount = Math.ceil(this.rowCount / this.perPage);
			},
			
			// 전체 페이지 그룹 개수
			calculatePagingGroupCount : function(){
				this.pagingGroupCount = Math.ceil(this.pagingCount / this.pageSize);
			},
			
			// 현재 페이지 그룹 번호
			calculateCurrentPageGroup : function(){
				this.currentPageGroup = Math.ceil((this.currentPage) / this.pageSize);
			},
			
			pageNavigator : function(){
				
				this.pagingTargetElement = _fnFindElement( this.pagingTarget );
				
				// 초기화
				if( _isNotEmpty( this.pagingTargetElement ) ){
					this.pagingTargetElement.innerHTML = '';
				}
				
				// 페이지 번호의 번호를 구함
				// ex) 1 ~ 10, 11 ~ 20, 21 ~ 30 ....
				this.calculateStartPage();
				this.calculateEndPage();
				
				// 페이징 개수를 구함
				this.calculatePagingCount();
				
				// 페이징 그룹 수를 구함
				this.calculatePagingGroupCount();
				
				// 현재 페이지 그룹 수를 구함
				this.calculateCurrentPageGroup();
				
				// ul 태그 생성
				var ul = _fnCreateElement({ element : 'ul' });
				
				// 이전 버튼
				if( this.pageSize < this.startPage ){
					var previousButton = _fnCreateElement({ element : 'li', appendNode : ul });
					var previousAnchor = _fnCreateElement({
						element : 'a',
						className : 'btn btn_prev3',
						href : 'javascript:void(0);',
						innerHTML : 'Prev',
						onclick : (function(){
							var that = this;
							return function(event){
								event.preventDefault();
								that.startPage = that.currentPage = (that.startPage > that.pageSize) ? that.startPage - that.pageSize : that.startPage;
								that.loadList(that.startPage);
								return;
							}
						}).call(this),
						appendNode : previousButton
					});
				}
				
				// 페이지 번호 버튼
				var thisPageNo, index;
				for(index = 0; index < this.pagingCount; index = index + 1){
					thisPageNo = index + 1;
					if ( this.startPage <= thisPageNo && thisPageNo <= this.endPage ) {
						var pagingButton = _fnCreateElement({
							element : 'li',
							className : ( ( this.currentPage == thisPageNo ) ? 'select' : '' ),
							appendNode : ul
						});
						var pagingAnchor = _fnCreateElement({
							element : 'a',
							href : 'javascript:void(0);',
							innerHTML : thisPageNo,
							onclick : (function(thisPageNo){
								var that = this;
								return function(event){
									event.preventDefault();
									that.loadList(thisPageNo);
									return;
								}
							}).call(this, thisPageNo),
							appendNode : pagingButton
						});
					}
				}
				
				// 다음 버튼
				if( this.pagingGroupCount > this.currentPageGroup ){
					var nextButton = _fnCreateElement({ element : 'li', appendNode : ul });
					var nextAnchor = _fnCreateElement({
						element : 'a',
						className : 'btn btn_next3',
						href : 'javascript:void(0);',
						innerHTML : 'Next',
						onclick : (function(){
							var that = this;
							return function(event){
								event.preventDefault();
								that.startPage = that.currentPage = that.endPage + 1;
								that.loadList(that.startPage);
								return;
							}
						}).call(this),
						appendNode : nextButton
					})
				}
				
				// 페이징 생성
				this.pagingTargetElement.append(ul);
			}
		};
		
		var pageManager = new PageManager();	// Create Instance
		pageManager.init();						// Initialize
		
	})(window, document, jQuery);

</script>