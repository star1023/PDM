<%@ page language="java" contentType="text/xml" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"    uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn"   uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%--
  Class Name : mfgProcessDocStoreMethodLayout.jsp
  Description : 제조방법 작성란 (트리그리드)
  Modification Information
 
    	수정일    	수정자                 수정내용
   -------    --------    ---------------------------
   23.11.06		정민균		최초생성
 
--%>
<%--<?xml version="1.0" encoding="UTF-8"?>--%>
<Grid>
	<Cfg	id="${gridId}"
			AcceptEnters   = "1"    Calculated  = "1"  CalculateSelected = "1"        DateStrings = "2" Deleting  = "0"
			Dragging       = "0"	Editing     = "1"  EnterMode         = "1"        Filtering   = "1" IdChars   = "0123456789"
			InEditMode     = "1"	MaxPages    = "20" NoFormatEscape    = "1"        NoHScroll   = "0" NoVScroll = "0"
			NumberId       = "1"	SafeCSS     = "1"  Selecting 		 = "1" 		  Alternate   = "2"
			SelectingCells = "0"	SortIcons   = "0"  Style             = "Standard" SuppressCfg = "1"
			Paging		   = "2" 	AllPages    = "1"  PageLength		 = "20"
			CopySelected   = "0"	CopyFocused = "1"  CopyCols			 = "0"
			ExportFormat   = "xlsx"	ExportCols  = "0"  ExportType  		 = "TextType"
			ClearSelected  = "2"
			Pasting = "1"
	/>

	<Cfg Validate="All" ValidateMessage="There are errors in grid!&lt;br>Data cannot be saved"/>
<%--	<Cfg Paging="2" PageLength="12" PageMin="1" MaxPages="10" />--%>
	
	<!-- Grid Header Setting Area Start  -->
	<Head>
	<Header	id="Header"	Align="center" Spanned="1"
			   METHODNAME			=	"구분" 
			   METHODEXPLAIN		=	"제조방법"
	/>
	<!-- Grid Header Setting Area End    -->
	
	<!-- Fileter Setting Area Start      -->
<%--		<Filter	id="Filter"	CanFocus="1" />--%>

	</Head>
	<!-- Fileter Setting Area End        -->
	
	<Cols>
		<C Name="METHODNAME"		Type="Text" RelWidth="50" CanEdit="${edit}" Visible="1" Align="left" CanExport="1" />
		<C Name="METHODEXPLAIN" 		Type="Lines" RelWidth="150" CanEdit="${edit}" Visible="1" Align="left" CanExport="1" AcceptEnters ='1' MaxHeight="100" />
	</Cols>

	<Foot>

	</Foot>

	<!-- Grid Paging Setting Area Start  -->	
	<Pager Visible="0" CanHide="0"/>
<%--
	<Solid>
		<I  id="PAGER"	Cells="NAV,LIST,ONE,GROUP"	Space="4"
			NAVType="Pager"
			LISTType="Pages"	LISTRelWidth="1"	LISTAlign="left"	LISTLeft="10"
			ONEType="Bool"		ONEFormula="Grid.AllPages?0:1" 			ONECanEdit="1"	ONELabelRight="페이지단위로보임"
			ONEOnChange="Grid.AllPages = !Value; Grid.OnePage = Value?7:0; Grid.RenderBody();"
			GROUPCanFocus="0"
			RECEIVE_NM="Cell text" RECEIVE_NMIcon="/resource/images/icon/web/add.png"  RECEIVE_NMOnClickSideButton="alert('Right icon clicked')" RECEIVE_NMTip="icons"
		/>
	</Solid>
--%>	
<%--	<!-- Grid Paging Setting Area End    -->--%>
<%--	--%>
	<Toolbar Space="0"	Styles="2"
			 Cells="Empty,Found,Del,새로고침,추가,삭제"
			 EmptyType = "Html"  EmptyWidth = "1" Empty="        "
			 ColumnsType = "Button"
			 CntType = "Html" CntFormula = '"Total : &lt;b>"+count(7)+"&lt;/b>"' CntWidth = '-1' CntWrap = '0'
			 FoundType = "Html" FoundFormula = "Grid.FilterCount==null ? '' : 'Found : &lt;b>'+Grid.FilterCount+'&lt;/b>'" FoundWidth = '-1' FoundWrap = '0'
			 DelType = "Html" DelFormula = 'var cnt=count("Row.Deleted>0",7);return cnt?" Del :&lt;b>"+cnt+"&lt;/b>":""' DelWidth = '-1' DelWrap = '0'
			 추가Type="Html" 추가="&lt;a href='#none' title='추가' class=&quot;defaultButton icon add&quot;
		 						onclick='GridFunctions.addGridRow(&quot;${gridId}&quot;)'>추가&lt;/a>"
			 삭제Type="Html" 삭제="&lt;a href='#none' title='삭제' class=&quot;defaultButton icon delete&quot;
		 						onclick='GridFunctions.removeGridRow(&quot;${gridId}&quot;)'>삭제&lt;/a>"

			 항목선택Type="Html" 항목선택="&lt;a href='#none' title='항목선택' class=&quot;treeButton treeSelect&quot;
		 						onclick='showColumns(&quot;${gridId}&quot;,&quot;xls&quot;)'>항목선택&lt;/a>"
			 새로고침Type = "Html" 새로고침 = "&lt;a href='#none' title='새로고침' class=&quot;defaultButton icon refresh&quot;
								onclick='GridFunctions.reloadGrid(&quot;${gridId}&quot;)'>새로고침&lt;/a>"
			 인쇄Type = "Html" 인쇄 = "&lt;a href='#none' title='인쇄' class=&quot;defaultButton icon printer&quot;
								onclick='printGrid(&quot;${gridId}&quot;)'>인쇄&lt;/a>"
			 엑셀Type = "Html" 엑셀 = "&lt;a href='#none' title='엑셀'class=&quot;defaultButton icon excel&quot;
								onclick='exportGrid(&quot;${gridId}&quot;,&quot;xls&quot;)'>엑셀&lt;/a>"
	/>
</Grid>