<%@ page language="java" contentType="text/xml" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"    uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn"   uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%--
  Class Name : statusListLayout.jsp
  Description : 품목제조보고서 현황
  Modification Information
 
       수정일    	     수정자                   수정내용
   -------    --------    ---------------------------
   2023.03.17  최광해	              최초 생성

    author   : 최광해
    since    : 2023.03.17
--%>
<c:set var="Selecting" value="0"/>
<c:set var="toolbarBtn" value=""/>
<c:set var="Width" value="Width"/>
<c:choose>
	<c:when test="${gridId == 'statusListC'}">
		<c:set var="Selecting" value="1"/>
		<c:set var="toolbarBtn" value="중단요청,"/>
	</c:when>
	<c:when test="${gridId == 'statusListRS'}">
		<c:set var="Selecting" value="1"/>
		<c:set var="toolbarBtn" value="중단,"/>
		<c:set var="Width" value="RelWidth"/>
	</c:when>
	<c:otherwise>
		<c:set var="Selecting" value="0"/>
		<c:set var="Width" value="RelWidth"/>
	</c:otherwise>
</c:choose>
<%--<?xml version="1.0" encoding="UTF-8"?>--%>
<Grid>
	<Cfg	id="${gridId}"
	        AcceptEnters   = "1"    Calculated  = "1"  CalculateSelected = "1"        DateStrings = "2" Deleting  = "0"
	        Dragging       = "0"	Editing     = "1"  EnterMode         = "4"        Filtering   = "1" IdChars   = "0123456789"
	        InEditMode     = "1"	MaxPages    = "10" NoFormatEscape    = "1"        NoHScroll   = "0" NoVScroll = "0"
	        NumberId       = "1"	SafeCSS     = "1"  Selecting 		 = "${Selecting}" 		  Alternate   = "2"
	        SelectingCells = "0"	SortIcons   = "0"  Style             = "Standard" SuppressCfg = "1"
	        Paging		   = "2" 	AllPages    = "0"  PageLength		 = "10"
	        CopySelected   = "1"	CopyFocused = "1"  CopyCols			 = "0"
	        ExportFormat   = "xlsx"	ExportCols  = "0"  ExportType  		 = "TextType"
	        ClearSelected  = "2"
	        Pasting = "0"
	        MainCol="versionNo"
	/>

	<Cfg Validate="All" ValidateMessage="There are errors in grid!&lt;br>Data cannot be saved"/>
<%--	<Cfg Paging="2" PageLength="12" PageMin="1" MaxPages="10" />--%>
	
	<!-- Grid Header Setting Area Start  -->
	<Head>
	<Header	id="Header"	Align="center" Spanned="1"
	           plnatName			=   "공장"
	           manufacturingNo2		=	"품보번호"
	           manufacturingName	=	"품목제조보고서명"
	           productTypeName	    =	"식품유형"
	           launchDate			=	"출시일"
	           regDate			    =	"품보번호 발급일"
	           openView		        =	"상세"
	           openViewText         =   "상세"
	           versionUpReqDate     =   "변경요청일"
	           versionUpView        =   "변경내용"
	           reportEDate          =   "신고일"
	           prevStatusName       =   "구분"
	           openStop             =   "중단요청"
	           stopReqDate          =   "중단요청일"
	           stopApprDate         =   "중단요청승인일"
	           stopDate             =   "중단일"
	           stop                 =   "중단"
	           devDocCount          =   "제조공정서 생성 수"
	           noStopCount          =   "제조공정서 미중단 수"
	           isMaxVersion         =   "isMaxVersion"
	           versionNo            =   "버전"
	           stopAble             =   "중단"

	/>
		<!-- stopApprDate = stopReqDate -->
	<!-- Grid Header Setting Area End    -->

	<!-- Fileter Setting Area Start      -->
		<Filter	id="Filter"	CanFocus="1" />
		
	</Head>
	<!-- Fileter Setting Area End        -->
	
	<Cols>
		<c:if test="${gridId == 'statusListC'}">
			<C Name="versionNo"      	    Type="Text" Width="60" CanEdit="0" Visible="1" Align="center" CanExport="1" />
			<C Name="stopAble"              Type="Enum" Width="60" CanEdit="0" Visible="1" Align="center" CanExport="0" Enum='|가능|불가' EnumKeys='|1|0'/>
		</c:if>
		<C Name="plnatName" 		    Type="Text" Width="150" CanEdit="0" Visible="1" Align="center" CanExport="1" />
		<C Name="manufacturingNo2" 		Type="Text" Width="150" CanEdit="0" Visible="1" Align="center" CanExport="1" />
<%--		<C Name="manufacturingNo2" 		Type="Link" Width="150" CanEdit="0" Visible="1" Align="center" CanExport="1" Text="manufacturingNo2" Url="javascript:goView(Row);return false;" />--%>
		<C Name="manufacturingName" 	Type="Text" ${Width}="250" CanEdit="0" Visible="1" Align="left" CanExport="1" />
		<C Name="productTypeName" 	    Type="Text" ${Width}="200" CanEdit="0" Visible="1" Align="left" CanExport="1" />
		<c:choose>
			<c:when test="${gridId == 'statusListN'}">
				<C Name="launchDate" 		    Type="Date" Width="120" CanEdit="0" Visible="1" Align="center" CanExport="1" Format="yyyy-MM-dd" />
				<C Name="regDate" 		        Type="Date" Width="120" CanEdit="0" Visible="1" Align="center" CanExport="1" Format="yyyy-MM-dd"/>
				<C Name="openView" 		        Type="Icon" Width="60" CanEdit="0" Visible="1" Align="center" CanExport="0"
				   Switch="1" Icon="/resources/images/com/new_eAcc/approval_icon_pp_04.png"
				   OnClickSideIcon="openView(Row)"
				/>
			</c:when>
			<c:when test="${gridId == 'statusListP'}">
				<C Name="launchDate" 		    Type="Date" Width="120" CanEdit="0" Visible="1" Align="center" CanExport="1" Format="yyyy-MM-dd" />
				<C Name="regDate" 		        Type="Date" Width="120" CanEdit="0" Visible="1" Align="center" CanExport="1" Format="yyyy-MM-dd"/>
				<C Name="reportEDate" 		    Type="Icon" Width="80" CanEdit="0" Visible="1" Align="center" CanExport="1"
				   Switch="1" Icon="/resources/images/com/new_eAcc/approval_icon_pp_01.png"
				   OnClickSideIcon="openReportEDate(Row)"/>
				<C Name="openView" 		        Type="Icon" Width="60" CanEdit="0" Visible="1" Align="center" CanExport="0"
				   Switch="1" Icon="/resources/images/com/new_eAcc/approval_icon_pp_04.png"
				   OnClickSideIcon="openView(Row)"
				/>
			</c:when>
			<c:when test="${gridId == 'statusListRC'}">
				<C Name="launchDate" 		    Type="Date" Width="120" CanEdit="0" Visible="1" Align="center" CanExport="1" Format="yyyy-MM-dd" />
				<C Name="versionUpReqDate" 		Type="Date" Width="120" CanEdit="0" Visible="1" Align="center" CanExport="1" Format="yyyy-MM-dd" />
				<C Name="reportEDate" 		    Type="Icon" Width="80" CanEdit="0" Visible="1" Align="center" CanExport="1"
				   Switch="1" Icon="/resources/images/com/new_eAcc/approval_icon_pp_01.png"
				   OnClickSideIcon="openReportEDate(Row)"/>
				<C Name="openView" 		        Type="Icon" Width="60" CanEdit="0" Visible="1" Align="center" CanExport="0"
				   Switch="1" Icon="/resources/images/com/new_eAcc/approval_icon_pp_04.png"
				   OnClickSideIcon="openView(Row)"
				/>
			</c:when>
			<c:when test="${gridId == 'statusListRE'}">
				<C Name="launchDate" 		    Type="Date" Width="120" CanEdit="0" Visible="1" Align="center" CanExport="1" Format="yyyy-MM-dd" />
				<C Name="reportEDate" 		    Type="Date" Width="120" CanEdit="0" Visible="1" Align="center" CanExport="1" Format="yyyy-MM-dd" />
				<C Name="prevStatusName" 	    Type="Text" Width="60" CanEdit="0" Visible="1" Align="center" CanExport="1" />
				<C Name="openView" 		        Type="Icon" Width="60" CanEdit="0" Visible="1" Align="center" CanExport="0"
				   Switch="1" Icon="/resources/images/com/new_eAcc/approval_icon_pp_04.png"
				   OnClickSideIcon="openView(Row)"
				/>
			</c:when>
			<c:when test="${gridId == 'statusListC'}">
				<C Name="devDocCount" 	        Type="Text" Width="100" CanEdit="0" Visible="1" Align="center" CanExport="1" />
				<C Name="noStopCount" 	        Type="Text" Width="100" CanEdit="0" Visible="1" Align="center" CanExport="1" />
				<C Name="reportEDate" 		    Type="Date" Width="120" CanEdit="0" Visible="1" Align="center" CanExport="1" Format="yyyy-MM-dd" />
				<C Name="launchDate" 		    Type="Date" Width="120" CanEdit="0" Visible="1" Align="center" CanExport="1" Format="yyyy-MM-dd" />
				<C Name="prevStatusName" 	    Type="Text" Width="60" CanEdit="0" Visible="1" Align="center" CanExport="1" />
				<C Name="openView" 		        Type="Icon" Width="60" CanEdit="0" Visible="1" Align="center" CanExport="0"
				   Switch="1" Icon="/resources/images/com/new_eAcc/approval_icon_pp_04.png"
				   OnClickSideIcon="openView(Row)"
				/>
			</c:when>
			<c:when test="${gridId == 'statusListAS'}">
				<C Name="stopReqDate" 		    Type="Date" Width="120" CanEdit="0" Visible="1" Align="center" CanExport="1" Format="yyyy-MM-dd" />
				<C Name="openView" 		        Type="Icon" Width="60" CanEdit="0" Visible="1" Align="center" CanExport="0"
				   Switch="1" Icon="/resources/images/com/new_eAcc/approval_icon_pp_04.png"
				   OnClickSideIcon="openView(Row)"
				/>
			</c:when>
			<c:when test="${gridId == 'statusListRS'}">
				<C Name="stopApprDate" 		    Type="Date" Width="120" CanEdit="0" Visible="1" Align="center" CanExport="1" Format="yyyy-MM-dd" />
				<C Name="openView" 		        Type="Icon" Width="60" CanEdit="0" Visible="1" Align="center" CanExport="0"
				   Switch="1" Icon="/resources/images/com/new_eAcc/approval_icon_pp_04.png"
				   OnClickSideIcon="openView(Row)"
				/>
<%--				<C Name="stop" 		            Type="Text" Width="60" CanEdit="0" Visible="1" Align="center" CanExport="1" />--%>
			</c:when>
			<c:when test="${gridId == 'statusListS'}">
				<C Name="stopDate" 		    Type="Date" Width="120" CanEdit="0" Visible="1" Align="center" CanExport="1" Format="yyyy-MM-dd" />
				<C Name="openView" 		        Type="Icon" Width="60" CanEdit="0" Visible="1" Align="center" CanExport="0"
				   Switch="1" Icon="/resources/images/com/new_eAcc/approval_icon_pp_04.png"
				   OnClickSideIcon="openView(Row)"
				/>
			</c:when>
			<c:otherwise></c:otherwise>
		</c:choose>
	</Cols>

	<!-- Grid Paging Setting Area Start  -->	
	<Pager Visible="0" CanHide="0"/>
	
	<Solid>
		<I  id="PAGER"	Cells="NAV,LIST,ONE,GROUP"	Space="4"
			NAVType="Pager"
			LISTType="Pages"	LISTRelWidth="1"	LISTAlign="left"	LISTLeft="10"
			ONEType="Bool"		ONEFormula="Grid.AllPages?0:1" 			ONECanEdit="1"	ONELabelRight="페이지단위로보임" <%--페이지단위로보임--%>
			ONEOnChange="Grid.AllPages = !Value; Grid.OnePage = Value?7:0; Grid.RenderBody();"
			GROUPCanFocus="0" 
			RECEIVE_NM="Cell text" RECEIVE_NMIcon="/resource/images/icon/web/add.png"  RECEIVE_NMOnClickSideButton="alert('Right icon clicked')" RECEIVE_NMTip="icons"
		/>
	</Solid>
	<!-- Grid Paging Setting Area End    -->
	
	<Toolbar Space="0"	Styles="2"
			 Cells = "Empty,Cnt,Found,Del,${toolbarBtn}새로고침,엑셀"
			 EmptyType = "Html"  EmptyWidth = "1" Empty="        "
			 ColumnsType = "Button"
			 CntType = "Html" CntFormula = '"Total : &lt;b>"+count(7)+"&lt;/b>"' CntWidth = '-1' CntWrap = '0'
			 FoundType = "Html" FoundFormula = "Grid.FilterCount==null ? '' : 'Found : &lt;b>'+Grid.FilterCount+'&lt;/b>'" FoundWidth = '-1' FoundWrap = '0'
			 DelType = "Html" DelFormula = 'var cnt=count("Row.Deleted>0",7);return cnt?" Del :&lt;b>"+cnt+"&lt;/b>":""' DelWidth = '-1' DelWrap = '0'

			 중단요청Type="Html" 중단요청="&lt;a href='#none' title='중단요청' class=&quot;treeButton0 treeSelect&quot;
								onclick='openStopArr(&quot;${gridId}&quot;)'>중단요청&lt;/a>"
			중단Type="Html" 중단="&lt;a href='#none' title='중단' class=&quot;treeButton0 treeSelect&quot;
								onclick='executeStopProcess(&quot;${gridId}&quot;)'>중단&lt;/a>"
			 항목선택Type="Html" 항목선택="&lt;a href='#none' title='항목선택' class=&quot;treeButton treeSelect&quot;
		 						onclick='showColumns(&quot;${gridId}&quot;,&quot;xls&quot;)'>항목선택&lt;/a>"
			 새로고침Type = "Html" 새로고침 = "&lt;a href='#none' title='새로고침' class=&quot;defaultButton icon refresh&quot;
								onclick='reloadStatusList(&quot;${gridId}&quot;)'>새로고침&lt;/a>"
			 인쇄Type = "Html" 인쇄 = "&lt;a href='#none' title='인쇄' class=&quot;defaultButton icon printer&quot;
								onclick='printGrid(&quot;${gridId}&quot;)'>인쇄&lt;/a>"
			 엑셀Type = "Html" 엑셀 = "&lt;a href='#none' title='엑셀'class=&quot;defaultButton icon excel&quot;
								onclick='exportGrid(&quot;${gridId}&quot;,&quot;xls&quot;)'>엑셀&lt;/a>"
	/>
</Grid>