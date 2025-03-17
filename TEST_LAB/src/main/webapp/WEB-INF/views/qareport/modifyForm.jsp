<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ page import="kr.co.aspn.util.*" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ page session="false" %>
<title>레포트</title>
<link rel="stylesheet" href="/resources/CLEditor/jquery.cleditor.css?param=1" />
<script type="text/javascript" src="/resources/CLEditor/jquery.cleditor.min.js?param=1"></script>
<link href="/resources/js/jquery.auto-complete.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="/resources/js/jquery.auto-complete.js"></script>

<form name="insertForm" id="insertForm" action="/qareport/updateQAReport" method="POST" enctype="multipart/form-data">
<input type="hidden" name="rNo" id="rNo" value="" />
<input type="hidden" name="delfile" id="delfile" value="" />

<div class="wrap_in" id="fixNextTag">
	<span class="path">품질보고서&nbsp;&nbsp;<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;보고서&nbsp;&nbsp;<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;<a href="#">${strUtil:getSystemName()}</a></span>
	<section class="type01">
		<h2 style="position:relative"><span class="title_s">Report</span>
			<span class="title" id="span_reportTitle">품질보고서 수정</span>
			<div  class="top_btn_box">
				<ul>
					<li>
						<button class="btn_circle_nomal" id="list">&nbsp;</button>
					</li>
				</ul>
			</div>
		</h2>
		<div class="group01" >
			<div class="title"><!--span class="txt">연구개발시스템 공지사항</span--></div>
			
			<!--
			<div class="tab02">
				<ul>
					<c:forEach items="${category1}" var="category1" varStatus="status">
					<a href="#" onClick="changeReportType('${category1.itemCode}',this)"><li id="li_reportType${category1.itemCode}" class="<c:if test='${status.count == 1 }'>select</c:if>">${category1.itemName}</li></a>
					</c:forEach>
				</ul>
			</div>
			-->

			<div class="list_detail">
				<ul style="border-top:none;">
					<li>
						<dt>카테고리</dt>
						<dd>
							<div class="selectbox req" style="width:300px;">  
								<label for="category">선택</label>
								<select name="category" id="category">
									<option value="">선택</option>
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
						</dd>
					</li>
					<li>
						<dt>보고서명</dt>
						<dd class="pr20 pb10"><input type="text" name="title" id="title" style="width:70%;" placeholder="제목을 입력해주세요."/></dd>
					</li>
					<li class="mb5">
						<dt>방문목적</dt>
						<dd class="pr20" style="line-height:0px;"><textarea id="content" name="content" style="width:100%; height:300px;resize: none;"></textarea></dd>
					</li>
					<li class="mb5">
						<dt>점검자</dt>
						<dd class="pr20" style="line-height:0px;"><input type="text" name="inspector" id="inspector" style="width:70%;" placeholder="점검자를 입력해주세요."/></dd>
					</li>
					<li class="mb5">
						<dt>참석자</dt>
						<dd class="pr20" style="line-height:0px;"><input type="text" name="attendees" id="attendees" style="width:70%;" placeholder="참석자를 입력해주세요."/></dd>
					</li>
					<li>
						<dt>파일 첨부</dt>
						<dd>
							<div class="add_file2" id="add_file2" style="width:97.5%">
								<span class="file_load" id="fileSpan1">
									<input type="file" name="file" id="file1" style="display:none">
									<label for="file1">첨부파일 등록 <img src="/resources/images/icon_add_file.png"></label>
								</span>
								<span id="upFile"></span>
							</div>
							<div class="file_box_pop" style=" height:85px; width:97.5%; border-top-left-radius:0px;border-top-right-radius:0px; border-top:1px solid #ddd;box-sizing:border-box;" id="fileList">
								<ul id="fileData"></ul>
							</div>
						</dd>
					</li>
				</ul>
			</div>
			<div class="btn_box_con5">
			</div>
			<div class="btn_box_con4"> 
				<!--input type='button' value="상신" class="btn_admin_red" id="request" onclick="javascript:goInsert();"-->
				<input type="button" class="btn_admin_sky" id="save" value="저장" >
				<input type="button" class="btn_admin_gray" id="cancel" value="취소">
			</div>
		</div>
	</section>	
</div>
</form>

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
		
		function _fnFindElementValue(identity){
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
		
		function _fnRefreshSelectBox( identity ){
			var selectBox = _fnFindElement( identity );
			var selectLabel = selectBox.parentNode.childNodes[1];
			var selectedValue = selectBox.value;
			var selectedText = selectBox.options[selectBox.selectedIndex].innerHTML;
			selectLabel.innerHTML = selectedText;
		}
		
		// PageManager Module
		function PageManager(){
			this.listButtonName = 'list';
			this.saveButtonName = 'save';
			this.cancelButtonName = 'cancel';
			this.pageName = 'QAReportInsertForm';
		}
		
		PageManager.prototype = {
			init : function(){
				
				// 목록버튼
				_fnFindElement( this.listButtonName ).addEventListener('click', this.moveList);
				
				// 저장 버튼
				_fnFindElement( this.saveButtonName ).addEventListener('click', this.save);
				
				// 취소 버튼
				_fnFindElement( this.cancelButtonName ).addEventListener('click', this.cancel);
				
				// 첨부파일
				_fnFindElement( 'file1' ).addEventListener('change', this.addFile());
				
				// Index
				var rNo = _fnFindURLParameterByName( 'rNo' );
				var urlParams = document.location.search;
				_fnFindElement( 'rNo' ).value = rNo;
				
				if( _isEmpty( rNo ) ){
					alert('잘못된 접근입니다.\r\n보고서 정보가 없습니다.');
					location.href = '/qareport/list?' + _fnRemoveUrlParamByName(urlParams, 'rNo');
					return
				}
				
				this.getDetail( rNo );
			},
			
			// 상세 정보 불러오기
			getDetail : function( rNo ){
				
				// Select Detail
				jQuery.ajax({
					async : false,
					type : 'GET',
					dataType : 'json',
					url : '/qareport/selectQAReportDetail',
					data : { rNo : rNo },
					success : function(data){
						if( _isNotEmpty( data ) ){
							var detail = data.detail;
							var files = data.files;
							var li, a, image;
							
							// 보고서 정보
							_fnFindElement( 'category' ).value = detail.category;
							_fnRefreshSelectBox( 'category' );
							_fnFindElement( 'title' ).value = detail.title;
							_fnFindElement( 'content' ).value = detail.content;
							_fnFindElement( 'inspector' ).value = detail.inspector;
							_fnFindElement( 'attendees' ).value = detail.attendees;
							
							// 첨부파일
							if( files != null && files.length ){
								for(index = 0; index < files.length; index++){
									var oItem = files[index];
									
									li = _fnCreateElement({
										element : 'li',
										id : 'exist_file' + index,
									});
									(function(li, oItem){
										li.addEventListener('click', function(event){
											// X버튼을 클릭 했을 때만 적용한다.
											if( event.target !== event.currentTarget ){
												var item = this.childNodes[0];
							 					var identity = item.getAttribute('id');
							 					var num = identity.replace(/[^0-9]/g, '');
							 					
							 					// 삭제할 파일 인덱스 저장
							 					var delfile = _fnFindElement( 'delfile' ).value;
							 					_fnFindElement( 'delfile' ).value += ( _isNotEmpty( delfile ) ? '||' : '') + oItem.fmNo + '@' + oItem.fileName;
					 							this.remove();	// 파일 목록에서 삭제
												return;
											}
										});
									})(li, oItem);
									
									a = _fnCreateElement({
										element : 'a',
										id : 'exist_a' + index,
										href : 'javascript:void(0);',
										appendNode : li
									});
									
									image = _fnCreateElement({
										element : 'img',
										src : '/resources/images/icon_del_file.png',
										appendNode : a,
									});
									
									li.innerHTML += files[index].orgFileName;// fileName;
									
// 									_fnFindElement( 'fileSpan' + (index + 1) ).style.display = 'none';
									_fnFindElement( 'fileData' ).appendChild(li);
								}
								return;
							}
						}
						return;
					},
					error : function(){
						alert('상세 정보 조회에 실패했습니다.\r\n다시 시도하거나 관리자에게 문의해 주세요.');
						return;
					}
				});
			},
			
			// 목록 이동
			moveList : function(event){
				event.preventDefault();
				var urlParams = document.location.search;
				location.href = '/qareport/list' + _fnRemoveUrlParamByName(urlParams, 'rNo');
			},
			
			// 첨부파일 추가
			addFile : function(){
				var _that = this;

				return function(event){
					event.preventDefault();
					
					var li, a, image, span, input, label;
					var identity = this.getAttribute('id');
					var num = identity.replace(/[^0-9]/g, '');
					var filePath = this.value;
					var fileName = filePath.substring(filePath.lastIndexOf('\\') + 1, filePath.length);
					
					if( _isEmpty( fileName ) || fileName.length == 0 ){
						alert('파일을 선택해 주세요.');
						return;
					}
					
					li = _fnCreateElement({
						element : 'li',
						id : 'selfile' + num,
					});
					li.addEventListener('click', function(event){
						// X버튼을 클릭 했을 때만 적용한다.
						if( event.target !== event.currentTarget ){
							var item = this.childNodes[0];
		 					var identity = item.getAttribute('id');
		 					var num = identity.replace(/[^0-9]/g, '');
		 					var real = _fnFindElement( 'fileSpan' + num );
		 					
 							this.remove();	// 파일 목록에서 삭제
		 					real.remove();	// 실제 파일 엘리먼트 삭제
							return;
						}
					});
					
					a = _fnCreateElement({
						element : 'a',
						id : 'sel_a' + num,
						href : 'javascript:void(0);',
						appendNode : li
					});
					
					image = _fnCreateElement({
						element : 'img',
						src : '/resources/images/icon_del_file.png',
						appendNode : a,
					});
					
					li.innerHTML += fileName;
					
					_fnFindElement( 'fileSpan' + num ).style.display = 'none';
					_fnFindElement( 'fileData' ).appendChild(li);
					
					num++;
					
					span = _fnCreateElement({
						element : 'span',
						className : 'file_load',
						id : 'fileSpan' + num
					});
					
					input = _fnCreateElement({
						element : 'input',
						type : 'file',
						name : 'file',
						id : 'file' + num,
						style : 'display:none;',
						appendNode : span
					});
	 				input.addEventListener('change', _that.addFile());
					
					label = _fnCreateElement({
						element : 'label',
						innerHTML : '첨부파일 등록',
						appendNode : span
					});
					label.setAttribute('for', 'file' + num);
					
					image = _fnCreateElement({
						element : 'img',
						src : '/resources/images/icon_add_file.png',
						appendNode : label
					});
					_fnFindElement( 'upFile' ).appendChild(span);
				}
			},
			
			// 저장
			save : function(event){
				
				event.preventDefault();
				
				jQuery('#insertForm').ajaxForm({
					
					beforeSubmit: function (data,form,option) {
						var rNo = _fnFindURLParameterByName( 'rNo' );
						var category = _fnFindElementValue('category');
						var title = _fnFindElementValue('title');
						var content = _fnFindElementValue('content');
						var inspector = _fnFindElementValue('inspector');
						var attendees = _fnFindElementValue('attendees');
						
						if( _isEmpty( category ) ){
							alert('카테고리를 선택해 주세요.');
							return false;
						}
						if( _isEmpty( title ) ){
							alert('보고서명을 입력해 주세요.');
							return false;
						}
						if( _isEmpty( content ) ){
							alert('방문 목적을 입력해 주세요.');
							return false;
						}
//		 				if( _isEmpty( inspector ) ){
//		 					alert('점검자를 입력해 주세요.');
//		 					return false;
//		 				}
//		 				if( _isEmpty( attendees ) ){
//		 					alert('참석자를 입력해 주세요.');
//		 					return false;
//		 				}
					},
					success : function( response ){
						if( response ){
							alert('수정 되었습니다.');
							var urlParams = document.location.search;
							location.href = '/qareport/list' + _fnRemoveUrlParamByName(urlParams, 'rNo');
							return;
						}else{
							alert('수정에 실패했습니다.\r\n다시 시도하거나 관리자에게 문의해주세요.');
							return;
						}
					},
					error : function(){
						alert('수정에 실패했습니다.\r\n다시 시도하거나 관리자에게 문의해주세요.');
						return;
					}
					
				}).submit();
			},
			
			// 취소
			cancel : function(event){
				event.preventDefault();
				var urlParams = document.location.search;
				location.href = '/qareport/list' + _fnRemoveUrlParamByName(urlParams, 'rNo');
				return;
			}
		};
		
		var pageManager = new PageManager();
		pageManager.init();
		
	})( window, document, jQuery );
	
</script>