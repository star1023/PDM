<%@ page language="java" contentType="text/xml" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"    uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn"   uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%--
  Class Name : mpdListLayout.jsp
  Description : 품목제조보고서 현황 -> 제조공정서 리스트
  Modification Information
 
       수정일    	     수정자                   수정내용
   -------    --------    ---------------------------
   2023.03.22  최광해	              최초 생성

    author   : 최광해
    since    : 2023.03.22
--%>
<%--<?xml version="1.0" encoding="UTF-8"?>--%>
<Grid>
	<Cfg	id="${gridId}"
	        AcceptEnters   = "1"    Calculated  = "1"  CalculateSelected = "1"        DateStrings = "2" Deleting  = "0"
	        Dragging       = "0"	Editing     = "1"  EnterMode         = "4"        Filtering   = "0" IdChars   = "0123456789"
	        InEditMode     = "1"	MaxPages    = "10" NoFormatEscape    = "1"        NoHScroll   = "0" NoVScroll = "0"
	        NumberId       = "1"	SafeCSS     = "1"  Selecting 		 = "0" 		  Alternate   = "2"
	        SelectingCells = "0"	SortIcons   = "0"  Style             = "Standard" SuppressCfg = "1"
	        Paging		   = "2" 	AllPages    = "0"  PageLength		 = "10"
	        CopySelected   = "1"	CopyFocused = "1"  CopyCols			 = "0"
	        ExportFormat   = "xlsx"	ExportCols  = "0"  ExportType  		 = "TextType"
	        ClearSelected  = "2"
	        Pasting = "0"
	/>

	<Cfg Validate="All" ValidateMessage="There are errors in grid!&lt;br>Data cannot be saved"/>
<%--	<Cfg Paging="2" PageLength="12" PageMin="1" MaxPages="10" />--%>
	
	<!-- Grid Header Setting Area Start  -->
	<Head>
	<Header	id="Header"	Align="center" Spanned="1"
	           docNo                =   "제품개발문서 번호"
	           docVersion           =   "버전"
	           dNo                  =   "제조공정서 번호"
	           productCode          =   "제품코드"
	           productName          =   "제품명"
	           userName             =   "담당자"
	           state                =   "상태"
	           viewAuth             =   "권한"
	           regDate              =   "BOM 입력시점"


	/>
		<!-- stopApprDate = stopReqDate -->
	<!-- Grid Header Setting Area End    -->
	
	<!-- Fileter Setting Area Start      -->
<%--		<Filter	id="Filter"	CanFocus="1" />--%>
		
	</Head>
	<!-- Fileter Setting Area End        -->
	
	<Cols>
		<C Name="docNo"	 			Type="Text" RelWidth="120" CanEdit="0" Visible="1" Align="center" CanExport="1" />
		<C Name="docVersion"		Type="Text" RelWidth="120" CanEdit="0" Visible="1" Align="center" CanExport="1" />
		<C Name="dNo"	 			Type="Text" RelWidth="120" CanEdit="0" Visible="1" Align="center" CanExport="1" />
		<C Name="productCode"		Type="Text" RelWidth="80" CanEdit="0" Visible="1" Align="center" CanExport="1" />
		<C Name="productName"		Type="Text" RelWidth="220" CanEdit="0" Visible="1" Align="center" CanExport="1" />
		<C Name="userName" 			Type="Text" RelWidth="120" CanEdit="0" Visible="1" Align="center" CanExport="1" />
		<C Name="regDate" 		    Type="Date" RelWidth="120" CanEdit="0" Visible="1" Align="center" CanExport="1" Format="yyyy-MM-dd" />
		<C Name="state"				Type="Enum" RelWidth="120" CanEdit="0" Visible="1" Align="center" CanExport="1" Enum="|등록|승인|반려|결재중|ERP반영 완료|ERP반영 오류|사용중지|임시저장" EnumKeys="|0|1|2|3|4|5|6|7"/>
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
			 Cells="Empty,Cnt,Found,Del,${toolbarBtn}새로고침"
			 EmptyType = "Html"  EmptyWidth = "1" Empty="        "
			 ColumnsType = "Button"
			 CntType = "Html" CntFormula = '"Total : &lt;b>"+count(7)+"&lt;/b>"' CntWidth = '-1' CntWrap = '0'
			 FoundType = "Html" FoundFormula = "Grid.FilterCount==null ? '' : 'Found : &lt;b>'+Grid.FilterCount+'&lt;/b>'" FoundWidth = '-1' FoundWrap = '0'
			 DelType = "Html" DelFormula = 'var cnt=count("Row.Deleted>0",7);return cnt?" Del :&lt;b>"+cnt+"&lt;/b>":""' DelWidth = '-1' DelWrap = '0'

			 중단요청Type="Html" 중단요청="&lt;a href='#none' title='중단요청' class=&quot;treeButton0 treeSelect&quot;
								onclick='openStopArr(&quot;${gridId}&quot;)'>중단요청&lt;/a>"
			 항목선택Type="Html" 항목선택="&lt;a href='#none' title='항목선택' class=&quot;treeButton treeSelect&quot;
		 						onclick='showColumns(&quot;${gridId}&quot;,&quot;xls&quot;)'>항목선택&lt;/a>"
			 새로고침Type = "Html" 새로고침 = "&lt;a href='#none' title='새로고침' class=&quot;defaultButton icon refresh&quot;
								onclick='reloadGrid(&quot;${gridId}&quot;)'>새로고침&lt;/a>"
			 인쇄Type = "Html" 인쇄 = "&lt;a href='#none' title='인쇄' class=&quot;defaultButton icon printer&quot;
								onclick='printGrid(&quot;${gridId}&quot;)'>인쇄&lt;/a>"
			 엑셀Type = "Html" 엑셀 = "&lt;a href='#none' title='엑셀'class=&quot;defaultButton icon excel&quot;
								onclick='exportGrid(&quot;${gridId}&quot;,&quot;xls&quot;)'>엑셀&lt;/a>"
	/>
</Grid>