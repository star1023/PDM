<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script type="text/javascript">
	$(document).ready(function(){
		$('#productDesignCreateForm').on('submit', function(event){
			event.preventDefault();
		});
	});
	
	function productDesignList(){
		location.href = '/design/productDesignDocList'
	}
	
	function changeCompayCode(event){
		$('#companyCode').change(function(e){
			if(e.target.value){
				var plantList = '${plantList}';
				$('#plant').empty();
				$('#plant').append('<option value="">선택하세요</option>');
				JSON.parse(plantList).forEach(function(v){
					if(v.companyCode == event.target.value){
						$('#plant').append('<option value="'+v.plant+'">'+v.plantName+'</option>')
					}
				});
				$('#plant').change();
			} else {
				$('#plant').empty();
				$('#plant').append('<option value="">선택하세요</option>');
				$('#plant').change();
			}
		})
	}
	
	function setCategoryName(event){
		var categoryName = $('#'+event.target.id + ' option:selected').text();
		$('input[name=productCategoryText]').val(categoryName);
	}
	
	function saveProductDesignDoc(){
		if(saveValid()){
			var formData = $('#productDesignCreateForm').serialize();
			$.ajax({
				url: '/design/saveProductDesignDoc',
				type: 'POST',
				data: formData,
				success: function(data){
					if(data > 0){
						if(confirm('저장되었습니다. 목록으로 이동하시겠습니까?')){
							location.href='/design/productDesignDocList';
						} else {
							return;
						}
					} else {
						return alert('[ERR-1]제품설계서 저장 오류');
					}
				},
				error: function(){
					return alert('[ERR-2]제품설계서 저장 오류');
				}
			});
		} else {
			return;
		}
	}
	
	function saveValid(){
		if($('#productCategory').val().trim().length <= 0){
			alert('제품유형을 선택하세요');
			return false;
		}
		
		if($('#productName').val().trim().length <= 0){
			alert('제품명을 선택하세요');
			return false;
		}
		
		if($('#companyCode').val().trim().length <= 0){
			alert('공장을 선택하세요');
			return false;
		}
		
		if($('#plant').val().trim().length <= 0){
			alert('공장을 선택하세요');
			return false;
		}
		
		return true;
	}
</script>
<span class="path">제품설계서&nbsp;&nbsp;<img src="../resources/images/icon_path.png" style="vertical-align:middle"/>&nbsp;&nbsp;<a href="#">파리크라상 식품기술 연구개발시스템</a></span>
<section class="type01">
	<h2 style="position:relative">
		<span class="title_s">Product Design Document</span>
		<span class="title">제품설계서생성</span>
		<div class="top_btn_box">
			<ul>
				<li>
					<button type="button" class="btn_circle_nomal" onClick="productDesignList();">&nbsp;</button>
				</li>
			</ul>
		</div>
	</h2>
	<div class="group01" >
		<div class="title"></div>
		<form id="productDesignCreateForm" action="/design/saveProductDesignDoc">
			<input type="hidden" name="regUserId" value="${SESS_AUTH.userId}"/>
			<input type="hidden" name="productCategoryText" value=""/>
			<div class="list_detail">
				<ul>
					<li>
						<dt>제품유형</dt>
						<dd>
							<div class="selectbox req" style="width:600px;">  
								<label for="productCategory">제품유형 선택</label> 
								<select name="productCategory" id="productCategory" onchange="setCategoryName(event)">
									<option value="">====선택하세요=====</option>
									<c:forEach items="${codeList}" var="code">
										<option value="${code.ITEMCODE}">${code.ITEMNAME}</option>
									</c:forEach>
								</select>
							</div>
						</dd>
					</li>
					<li>
						<dt>제품명</dt>
						<dd>
							<input type="text" class="req" style="width:200px;" placeholder="입력필수" name="productName" id="productName"/>
						</dd>
					</li>
					<li>
						<dt>공장</dt>
						<dd>
							<div class="selectbox req" style="width:100px">
								<label>대분류</label>
								<select id="companyCode" name="companyCode" onchange="changeCompayCode(event)">
									<option value="">선택하세요</option>
									<option value="SL">삼립ERP</option>
									<option value="SN">샤니ERP</option>
								</select>
							</div>
							<div class="selectbox req" style="width:100px">
								<label>소분류</label>
								<select id="plant" name="plant">
									<option value="">선택하세요</option>
								</select>
							</div>
						</dd>
					</li>
				</ul>
			</div>
		</form>
		<div class="btn_box_con">
			<input type="button" value="저장" class="btn_admin_red" onclick="saveProductDesignDoc()"> 
			<input type="button" value="취소" class="btn_admin_navi">
			<input type="button" value="목록" class="btn_admin_gray" onClick="productDesignList();">
		</div>
	</div>
</section>

