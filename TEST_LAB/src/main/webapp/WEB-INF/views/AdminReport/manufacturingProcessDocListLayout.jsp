<%@ page language="java" contentType="text/xml" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"    uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn"   uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%--
  Class Name : faturingProcessDocListLayout.jsp
  Description : 제조공정서 전체 리스트 - ERP반영 완료 건
  Modification Information
 
       수정일    	     수정자                   수정내용
   -------    --------    ---------------------------
   2023.01.12  최광해	              최초 생성

    author   : 최광해
    since    : 2023.01.12
    
   2023.12.27 정민균 		 라인, 문서상태, 품보상태 추가 	
--%>
<%--<?xml version="1.0" encoding="UTF-8"?>--%>
<Grid>
	<Cfg	id="${gridId}"
			AcceptEnters   = "1"    Calculated  = "1"  CalculateSelected = "1"        DateStrings = "2" Deleting  = "0"
			Dragging       = "0"	Editing     = "1"  EnterMode         = "4"        Filtering   = "1" IdChars   = "0123456789"
			InEditMode     = "1"	MaxPages    = "20" NoFormatEscape    = "1"        NoHScroll   = "0" NoVScroll = "0"
			NumberId       = "1"	SafeCSS     = "1"  Selecting 		 = "0" 		  Alternate   = "2"
			SelectingCells = "0"	SortIcons   = "0"  Style             = "Standard" SuppressCfg = "1"
			Paging		   = "2" 	AllPages    = "1"  PageLength		 = "20"
			CopySelected   = "0"	CopyFocused = "1"  CopyCols			 = "0"
			ExportFormat   = "xlsx"	ExportCols  = "0"  ExportType  		 = "TextType"
			ClearSelected  = "2"
			Pasting = "0"
	/>

	<Cfg Validate="All" ValidateMessage="There are errors in grid!&lt;br>Data cannot be saved"/>
<%--	<Cfg Paging="2" PageLength="12" PageMin="1" MaxPages="10" />--%>
	
	<!-- Grid Header Setting Area Start  -->
	<Head>
	<Header	id="Header"	Align="center" Spanned="1"
			   DOCNO			=	"문서번호"
			   DNO				=	"제조공정서번호"
			   PRODUCTCODE		=	"제품코드"
			   PRODUCTNAME		=	"제품명"
			   PLANTNAME		=	"공장"
			   lineName			=	"라인"
			   STATE			=	"상태"
			   isCloseName		= 	"문서상태"
			   DOCVERSION		=	"문서버전"
			   DOC_REGUSER		=	"문서작성자"
			   PROCESS_REGUSER	=	"제조공정서작성자"
			   LMNO				=	"품목보고번호"
			   MANUFACTURINGNAME=	"품목보고명"
			   status			= 	"품보상태"
	/>
	<!-- Grid Header Setting Area End    -->
	
	<!-- Fileter Setting Area Start      -->
		<Filter	id="Filter"	CanFocus="1" />
		
	</Head>
	<!-- Fileter Setting Area End        -->
	
	<Cols>
		<C Name="DOCNO" 			Type="Text" Width="100" CanEdit="0" Visible="0" Align="center" CanExport="0" />
		<C Name="DNO"	 			Type="Text" Width="120" CanEdit="0" Visible="1" Align="center" CanExport="1" />
		<C Name="PRODUCTCODE"		Type="Text" Width="80" CanEdit="0" Visible="1" Align="center" CanExport="1" />
		<C Name="PRODUCTNAME"		Type="Text" Width="220" CanEdit="0" Visible="1" Align="center" CanExport="1" />
		<C Name="PLANTNAME" 		Type="Text" Width="130" CanEdit="0" Visible="1" Align="center" CanExport="1" />
		<C Name="lineName" 			Type="Text" Width="100" CanEdit="0" Visible="1" Align="center" CanExport="1" />
		<C Name="STATE"				Type="Enum" Width="120" CanEdit="0" Visible="1" Align="center" CanExport="1" Enum="|등록|승인|반려|결재중|ERP반영 완료|ERP반영 오류|사용중지|임시저장" EnumKeys="|0|1|2|3|4|5|6|7"/>
		<C Name="isCloseName"		Type="Enum" Width="120" CanEdit="0" Visible="1" Align="center" CanExport="1" Enum="|진행(생산)중|제품중단|보류" EnumKeys="|0|1|2"/>
		<C Name="DOCVERSION"		Type="Text" Width="80" CanEdit="0" Visible="1" Align="center" CanExport="1" />
		<C Name="DOC_REGUSER"		Type="Text" Width="100" CanEdit="0" Visible="1" Align="center" CanExport="1" />
		<C Name="PROCESS_REGUSER"	Type="Text" Width="130" CanEdit="0" Visible="1" Align="center" CanExport="1" />
		<C Name="LMNO"				Type="Text" Width="180" CanEdit="0" Visible="1" Align="center" CanExport="1" />
		<C Name="MANUFACTURINGNAME"	Type="Text" Width="180" CanEdit="0" Visible="1" Align="center" CanExport="1" />
		<C Name="status"		Type="Enum" Width="80" CanEdit="0" Visible="1" Align="center" CanExport="1" Enum="|번호생성|진행중|완료|삭제|중단요청|중단요청 승인|중단|변경요청|신고중" EnumKeys="|N|P|C|D|AS|RS|S|RC|RE"/>
		<!--  <C Name="statusName"		Type="Text" Width="80" CanEdit="0" Visible="1" Align="center" CanExport="1" />-->


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
			 Cells="Empty,Cnt,Found,Del,새로고침,엑셀"
			 EmptyType = "Html"  EmptyWidth = "1" Empty="        "
			 ColumnsType = "Button"
			 CntType = "Html" CntFormula = '"Total : &lt;b>"+count(7)+"&lt;/b>"' CntWidth = '-1' CntWrap = '0'
			 FoundType = "Html" FoundFormula = "Grid.FilterCount==null ? '' : 'Found : &lt;b>'+Grid.FilterCount+'&lt;/b>'" FoundWidth = '-1' FoundWrap = '0'
			 DelType = "Html" DelFormula = 'var cnt=count("Row.Deleted>0",7);return cnt?" Del :&lt;b>"+cnt+"&lt;/b>":""' DelWidth = '-1' DelWrap = '0'

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