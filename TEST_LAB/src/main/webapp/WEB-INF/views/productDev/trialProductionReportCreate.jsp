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

<form name="insertForm" id="insertForm" action="/dev/insertTrialProductionReport" method="POST" enctype="multipart/form-data">
<input type="hidden" id="state" name="state" value="0" />

<input type="hidden" id="docNo" name="docNo" value="" />
<input type="hidden" id="docVersion" name="docVersion" value="" />


<div class="wrap_in" id="fixNextTag">
	<span class="path">시생산 보고서&nbsp;&nbsp;<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;보고서&nbsp;&nbsp;<img src="/resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;<a href="#">${strUtil:getSystemName()}</a></span>
	<section class="type01">
		<h2 style="position:relative"><span class="title_s">Report</span>
			<span class="title" id="span_reportTitle">시생산 보고서 작성</span>
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
			<div class="list_detail">
				<ul style="border-top:none;">
					<li>
						<dt>제조공정서 번호</dt>
						<dd class="pr20 pb10">
<!-- 							<input type="text" name="dNo" id="dNo" style="width:70%;" placeholder="제조공정서 번호를 입력해주세요. (숫자만 입력)" maxlength="10" /> -->
							<input type="hidden" id="dNo" name="dNo" value="" />
							<div class="selectbox req" style="width:45%">
	                            <select id="dNoSelect" name="dNoSelect">
	                            	<option value="">-- 제조공정서번호 선택 --</option>
	                            </select>
								<label for="dNoSelect">-- 제조공정서번호 선택 --</label>
							</div>
						</dd>
					</li>
					<li class="mb5">
						<dt>라인</dt>
						<dd class="pr20" style="line-height:0px;">
							<input type="hidden" id="line" name="line" value="" />
							<input type="text" class="" id="lineName" name="lineName" value="" style="width:70%;" readonly="readonly" maxlength="100" />
						</dd>
					</li>
					<li class="mb5">
						<dt>시생산일</dt>
						<dd class="pr20" style="line-height:0px;"><input type="text" class="req" id="trialDate" name="trialDate" style="width:70%;" placeholder="시생산일을 입력해주세요." readonly="readonly" maxlength="100"/></dd>
					</li>
					<li class="mb5">
						<dt>개발강도</dt>
						<dd class="pr20">
							
							<input type="checkbox" class="devIntensity" id="devIntensity_high" name="devIntensity_high" value="high" />
							<label for="devIntensity_high"><span></span>상</label>
							
							<input type="checkbox" class="devIntensity" id="devIntensity_medium" name="devIntensity_medium" value="medium" />
							<label for="devIntensity_medium"><span></span>중</label>
							
							<input type="checkbox" class="devIntensity" id="devIntensity_low" name="devIntensity_low" value="low" />
							<label for="devIntensity_low"><span></span>하</label>
							
							<input type="hidden" id="devIntensity" name="devIntensity" value="" />
						</dd>
					</li>
					<li class="mb5">
						<dt>결과</dt>
						<dd class="pr20" >
							
							<input type="checkbox" class="result" id="result_pass" name="result_pass" value="pass" />
							<label for="result_pass"><span></span>합격</label>
							
							<input type="checkbox" class="result" id="result_progress" name="result_progress" value="progress" />
							<label for="result_progress"><span></span>조건부 진행</label>
							
							<input type="checkbox" class="result" id="result_retest" name="result_retest" value="retest" />
							<label for="result_retest"><span></span>재실험</label>
							
							<input type="checkbox" class="result" id="result_fail" name="result_fail" value="fail" />
							<label for="result_fail"><span></span>불가</label>
							
							<input type="hidden" id="result" name="result" value="" />
						</dd>
					</li>
					<li class="mb5">
						<dt>시생산 중요사항</dt>
						<dd class="pr20" style="line-height:0px;"><textarea class="" id="importantNote" name="importantNote" style="width:100%; height:300px;resize: none;"></textarea></dd>
					</li>
					<li>
						<dt>파일 첨부</dt>
						<dd>
							<div class="add_file2" id="add_file2" style="width:97.5%">
								<span class="file_load" id="fileSpan1">
									<input type="file" name="file" id="file1" style="display:none;">
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
				case 'hidden':
				case 'textarea':
				case 'select-one':
				case 'file':
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
		
		// PageManager Module
		function PageManager(){
			this.pageName = 'trialProductionReportCreate';
		}
		
		PageManager.prototype = {
				
			init : function(){
				
				var _Self = this;
				var docNo = _fnFindURLParameterByName( 'docNo' );
				var docVersion = _fnFindURLParameterByName( 'docVersion' );
				
				// 제품개발문서 번호 체크
				if( _isEmpty( docNo ) || _isEmpty( docVersion ) ){
					alert('잘못된 접근입니다.');
					document.location.href = '/main/main';
					return;
				}
				
				// 파라미터 세팅 (문서번호, 버전)
				_fnFindElement('docNo').value = docNo;
				_fnFindElement('docVersion').value = docVersion;
				
				// 제조공정서번호 셀렉트 박스 세팅
				_Self.settingManufacturingProcessDoc(docNo, docVersion);
				
				// 시생산일 DatePicker 세팅
				applyDatePicker('trialDate');
				
				// 개발강도 체크박스 하나만 선택
				_Self.settingCheckboxes('devIntensity');
				
				// 결과 체크박스 하나만 선택
				_Self.settingCheckboxes('result');
				
				
				// 목록버튼
				_fnFindElement( 'list' ).addEventListener('click', function(event){
					event.preventDefault();
					_Self.moveToDocumentDetail();
					return;
				});
				
				// 저장 버튼
				_fnFindElement( 'save' ).addEventListener('click', function(event){
					event.preventDefault();
					
					jQuery('#insertForm').ajaxForm({
						beforeSubmit: function (data, form, option) {
							if(_isEmpty(_fnFindElementValue( 'dNoSelect' ))){
								alert('제조공정서번를 선택해 주세요.');
								_fnFindElement( 'dNo' ).focus();
								return false;
							}
 							if(_isEmpty(_fnFindElementValue( 'line' ))){
 								alert('생산라인이 입력된 제조공정서를 선택해주세요.');
 								_fnFindElement( 'line' ).focus();
 								return false;
 							}
							if(_isEmpty(_fnFindElementValue( 'trialDate' ))){
								alert('시생산일을 입력해 주세요.');
								_fnFindElement( 'trialDate' ).focus();
								return false;
							}
							if(_isEmpty(_fnFindElementValue( 'devIntensity' ))){
								alert('개발강도를 선택해 주세요.');
								return false;
							}
							if(_isEmpty(_fnFindElementValue( 'result' ))){
								alert('결과를 선택해 주세요.');
								return false;
							}
							if(_isEmpty(_fnFindElementValue( 'importantNote' ))){
								alert('시생산 중요사항을 입력해 주세요.');
								_fnFindElement( 'importantNote' ).focus();
								return false;
							}
							
						},
						success : function( response ){
							if( response ){
								alert('등록 되었습니다.');
								_Self.moveToDocumentDetail();
								return;
							}else{
								alert('저장에 실패했습니다.\r\n다시 시도하거나 관리자에게 문의해주세요.');
								return;
							}
						},
						error : function(){
							alert('저장에 실패했습니다.\r\n다시 시도하거나 관리자에게 문의해주세요.');
							return;
						}
			        }).submit();
				});
				
				// 취소 버튼
				_fnFindElement( 'cancel' ).addEventListener('click', function(event){
					event.preventDefault();
					this.moveToDocumentDetail();
					return;
				});
				
				// 첨부파일
				_fnFindElement( 'file1' ).addEventListener('change', _Self.addFile());
			},
			
			// 체크 박스 하나만 선택 + hidden value 세팅
			settingCheckboxes : function( identity, value ){
				
				var checkboxes = Array.prototype.slice.call( document.getElementsByClassName( identity ) );
				
				for(var index = 0; index < checkboxes.length; index++){
					(function(index){
						checkboxes[index].addEventListener('click', function(event){
							for(var index2 = 0; index2 < checkboxes.length; index2++){
								if( index !== index2 ){
									checkboxes[index2].checked = false;
								}else{
									_fnFindElement( identity ).value = checkboxes[index2].value;
								}
							}
						});
						
						if( _isNotEmpty(value) && checkboxes[index].value === value ){
							checkboxes[index].checked = true;
							_fnFindElement( identity ).value = value;
						}
						
					})(index);
				}
			},
			
			// 제조공정서 번호 셀렉트 박스 세팅
			settingManufacturingProcessDoc : function(docNo, docVersion){
				
				var _Self = this;
				var selectElement = _fnFindElement( 'dNoSelect' );
				
				jQuery.ajax({
					async : false,
					type : 'GET',
					dataType : 'json',
					url : '/dev/selectboxManufacturingProcessDoc',
					data : { docNo : docNo, docVersion : docVersion },
					success : function(data){
						var index;
						
						if( _isEmpty( data ) || !data.length ){
							alert('등록된 제조공정서가 없습니다.');
							_Self.moveToDocumentDetail();
							return;
						}
						
						// 초기화
						selectElement.innerHTML = '';
						_fnCreateElement({ element : 'option', value : '', text : '-- 제조공정서번호 선택 --', appendNode : selectElement });
						
						// 옵션 추가
						for(index = 0; index < data.length; index++)
							_fnCreateElement({ element : 'option', value : data[index].dNo + '|' + data[index].lineCode + '|' + data[index].companyCode + '|' + data[index].plantCode, text : data[index].dNo, appendNode : selectElement });
					},
					error : function(){
						alert('제조공정서 불러오기에 실패했습니다.');
						_Self.moveToDocumentDetail();
						return;
					}
				});
				
				// 변경 이벤트 추가 : 제조공정서번호 변경 시, 라인정보 불러오기 & 세팅
				selectElement.addEventListener('change', function(oEvent){
					oEvent.preventDefault();
					
					var thisValue = this.value.split('|')[0];
					var thisLine = this.value.split('|')[1];
					var thisCompany = this.value.split('|')[2];
					var thisPlant = this.value.split('|')[3];
					
					// 값이 없으면 공백 처리
					if( _isEmpty( thisValue ) || _isEmpty( thisLine ) ){
						
						// 제조공정서번호 초기화
						_fnFindElement( 'dNo' ).value = '';
						
						// 라인 정보 초기화
						_fnFindElement( 'line' ).value = '';
						_fnFindElement( 'lineName' ).value = '';
						return;
					}
					
					// 제조공정서번호 세팅
					_fnFindElement( 'dNo' ).value = thisValue;
					
					// 라인정보 세팅
					_Self.changeLineWhenChangingSelectBox( thisLine, thisCompany, thisPlant );
				});
			},
			
			// 제조공정서번호 변경 시, 라인정보 불러오기 & 세팅
			changeLineWhenChangingSelectBox : function( lineCode, companyCode, plantCode ){
				jQuery.ajax({
					async : false,
					type : 'GET',
					dataType : 'json',
					url : '/dev/selectLineDetailFromPlantLine',
					data : { lineCode : lineCode, companyCode : companyCode, plantCode: plantCode },
					success : function(data){
						if( _isEmpty( data ) ){
							return;
						}
						
						var lineCode = data.lineCode;
						var lineName = data.lineName;
						
						if( _isNotEmpty( lineCode ) ){
							_fnFindElement( 'line' ).value = lineCode;
							_fnFindElement( 'lineName' ).value = lineName;
							return;
						}
					},
					error : function(){
						alert('라인 불러오기에 실패했습니다.\r\n다시 시도하거나 관리자에게 문의해 주세요.');
						return;
					}
				});
			},
			
			// 제품개발문서 이동
			moveToDocumentDetail : function(){
				
				var moveform	= _fnCreateElement({ element : 'form', id : 'moveform', name : 'moveform', action : '/dev/productDevDocDetail', method : 'post', target : '_self' });
				var docNo		= _fnCreateElement({ element : 'input',	type : 'hidden', id : 'docNo',		name : 'docNo',		 value : _fnFindURLParameterByName( 'docNo' ),		appendNode : moveform });
				var docVersion	= _fnCreateElement({ element : 'input',	type : 'hidden', id : 'docVersion',	name : 'docVersion', value : _fnFindURLParameterByName( 'docVersion' ),	appendNode : moveform });
// 				var regUserId	= _fnCreateElement({ element : 'input',	type : 'hidden', id : 'regUserId',	name : 'regUserId',	 value : _fnFindURLParameterByName( 'regUserId' ),	appendNode : moveform });
				
				if(_isEmpty( document.body.moveform ))
					document.body.appendChild( moveform );
				
				moveform.submit();
				return;
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
					}, false);
					
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
			}
		};
		
		var pageManager = new PageManager();
		pageManager.init();
		
	})( window, document, jQuery );
	
</script>