package kr.co.aspn.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.TimeZone;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.ClientAnchor;
import org.apache.poi.ss.usermodel.ClientAnchor.AnchorType;
import org.apache.poi.ss.usermodel.CreationHelper;
import org.apache.poi.ss.usermodel.Drawing;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.ss.util.RegionUtil;
import org.apache.poi.util.IOUtils;
import org.apache.poi.xssf.usermodel.XSSFClientAnchor;
import org.apache.poi.xssf.usermodel.XSSFCreationHelper;
import org.apache.poi.xssf.usermodel.XSSFDrawing;
import org.apache.poi.xssf.usermodel.XSSFPicture;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.aspn.common.auth.AuthUtil;
import kr.co.aspn.service.ApprovalService;
import kr.co.aspn.service.FileService;
import kr.co.aspn.service.ManufacturingNoService;
import kr.co.aspn.service.ProductDesignService;
import kr.co.aspn.service.ProductDevService;
import kr.co.aspn.util.ExcelUtil;
import kr.co.aspn.util.StringUtil;
import kr.co.aspn.vo.ApprovalItemVO;
import kr.co.aspn.vo.DevDocFileVO;
import kr.co.aspn.vo.ImageFileForStores;
import kr.co.aspn.vo.MfgProcessDoc;
import kr.co.aspn.vo.MfgProcessDocBase;
import kr.co.aspn.vo.MfgProcessDocDisp;
import kr.co.aspn.vo.MfgProcessDocItem;
import kr.co.aspn.vo.MfgProcessDocProdSpec;
import kr.co.aspn.vo.MfgProcessDocProdSpecMD;
import kr.co.aspn.vo.MfgProcessDocStoreMethod;
import kr.co.aspn.vo.MfgProcessDocSubProd;
import kr.co.aspn.vo.ProductDesignDocDetail;
import kr.co.aspn.vo.ProductDesignDocVO;
import kr.co.aspn.vo.ProductDevDocVO;
import lombok.Data;

@Controller
@RequestMapping("excel")
public class ExcelController {
	Logger logger = LoggerFactory.getLogger(ExcelUtil.class);
	
	@Autowired
	ApprovalService approvalService;
	
	@Autowired
	ProductDesignService productDesignService;
	
	@Autowired
	ProductDevService productDevService;
	
	@Autowired
	FileService fileService;
	
	@Autowired
	ManufacturingNoService manufacturingNoService;
	
	@Autowired
	private Properties config;
	
	private String IMG_PATH = "";										// 이미지 파일 경로
	private String OUTPUT_FILE_PATH = "";						// 최종 파일 생성 경로

	private int rowNum = 0;												// Row Index
	int FIRST_CELLNUM = 0;
	int LAST_CELLNUM = 15;
	
	/**
	 * Constructor
	 */
	public ExcelController(){				
		// 다운로드 이미지 세팅
		//String downloadPath = "F:"+File.separator+"develop"+File.separator+"upload"+File.separator;//PSettings.prop.getProperty("file.downloadPath");
		try {
		String downloadPath = config.getProperty("excel.file.path");
		IMG_PATH = downloadPath  + "uploadImages" +File.separator;
		OUTPUT_FILE_PATH = downloadPath + "TEMP" +File.separator;
		} catch( Exception e ) {
			
		}
	}
	
	/**
	 * 엑셀 생성 및 다운로드
	 */
	@RequestMapping(value="productDesignDocDetail", produces="text/plain;charset=utf-8", method=RequestMethod.POST)
	@ResponseBody
	public void mainTask2(HttpServletRequest req, HttpServletResponse resp, @RequestParam Map<String, Object> param) throws Exception{
		String resultFilePath = "";
		
		param.put("userId", AuthUtil.getAuth(req).getUserId());
		ProductDesignDocVO docInfo = productDesignService.getProductDesignDoc(param.get("pNo").toString());
		ProductDesignDocDetail docDetail = productDesignService.getProductDesignDocDetail(param.get("pdNo").toString(),"");
		
		System.out.println(docInfo.toString());
		System.out.println(docDetail.toString());
	}
	
	
	/**
	 * 엑셀 생성 및 다운로드
	 */
	@RequestMapping(value="mainTask", produces="text/plain;charset=utf-8", method=RequestMethod.POST)
	@ResponseBody
	public void mainTask(HttpServletRequest req, HttpServletResponse resp, @RequestParam Map<String, Object> param) throws Exception{	
		String resultFilePath = "";
		
		param.put("userId", AuthUtil.getAuth(req).getUserId());
		Map<String,Object> docData = approvalService.getDocData(param);
		MfgProcessDoc mfgDoc = productDevService.getMfgProcessDocDetail(param.get("tbKey").toString(), docData.get("docNo").toString(), docData.get("docVersion").toString(), "");
		ProductDevDocVO devDoc = productDevService.getProductDevDoc(docData.get("docNo").toString(), docData.get("docVersion").toString());
		Map<String, Object> manufacturingNoData = manufacturingNoService.selectManufacturingNoDataByDocNo(param);
		
		param.put("tbKey",mfgDoc.getDNo());
		param.put("tbType", "manufacturingProcessDoc");
		param.put("type", '0');
		
		List<ApprovalItemVO> apprItemList = approvalService.apprItemInfoExcel(param);
		
		XSSFWorkbook workbook = new XSSFWorkbook();
		XSSFSheet sheet = workbook.createSheet("sheet");
		sheet.setDefaultColumnWidth(sheet.getDefaultColumnWidth());
		
		setDefaultMerge(sheet,0,0,0,7);
		setDefaultMerge(sheet,1,2,0,7);
		//setDefaultMerge(sheet,0,2,8,13);
		
		// [BODY] start
		Row row4 = sheet.createRow(4);
		
		setHeader(workbook, sheet, mfgDoc, apprItemList, devDoc);
		setSeparater(workbook, sheet);
		
		for (MfgProcessDocSubProd sub : mfgDoc.getSub()) {
			int subProdStartRow = rowNum;
			
			setSubProductName(workbook, sheet, sub.getSubProdName());
			setSubProduct(workbook, sheet, sub, mfgDoc.getCalcType());
			
			int subProdEndRow = rowNum-1;
			
			// setSubProdBorder
			setBorder(sheet, BorderStyle.THICK, subProdStartRow, subProdEndRow, 0, 15);
		}

		if(StringUtil.nvl(mfgDoc.getCalcType()).equals("40")){
			setTextAndImage(workbook, sheet, mfgDoc);
			setEtcInfo(workbook, sheet, mfgDoc, devDoc, manufacturingNoData);
		}else{
			// 7번코드의 경우 재료, 표시사항 배합비 X
			if(mfgDoc.getCalcType() != null && !mfgDoc.getCalcType().equals("7")){
				setMatDisp(workbook, sheet, mfgDoc.getPkg(), mfgDoc.getDisp());
			}
			setTextAndImage(workbook, sheet, mfgDoc);
			setEtcInfo(workbook, sheet, mfgDoc, devDoc, manufacturingNoData);
		}
		
		/*
		List<CellRangeAddress> rangeList = sheet.getMergedRegions();
		String log = " ragneList logger ";
		for (CellRangeAddress cellRangeAddress : rangeList) {
			int firstRow = cellRangeAddress.getFirstRow();
			int lastRow = cellRangeAddress.getLastRow();
			int firstColumn = cellRangeAddress.getFirstColumn();
			int lastColumn = cellRangeAddress.getLastColumn();
			
			log += "\n\t"+firstRow+", "+lastRow+", "+firstColumn+", "+lastColumn+", ";
		}
		
		System.out.println(log);
		*/
		
		String fileName = "제조공정서(" + mfgDoc.getDocNo() + "-"+mfgDoc.getDocVersion()+")_" + getNow() + ".xlsx";		// "제조공정서(12)_20150305150816.xlsx"
		resultFilePath = OUTPUT_FILE_PATH + fileName;
		
		makeOutputFile(resultFilePath, workbook);
		
		File file = new File(resultFilePath);

	    String downloadName = null;
	    String browser = req.getHeader("User-Agent");
	    //파일 인코딩
	    if(browser.contains("MSIE") || browser.contains("Trident") || browser.contains("Chrome")){
	      //브라우저 확인 파일명 encode  		             
	      downloadName = URLEncoder.encode(file.getName(), "UTF-8").replaceAll("\\+", "%20");		             
	    }else{		             
	      downloadName = new String(file.getName().getBytes("UTF-8"), "ISO-8859-1");
	    }  
		
		// 컨텐츠 타입과 파일명 지정
		//resp.setContentType("ms-vnd/excel");
		//resp.setHeader("Content-Disposition", "attachment;filename="+fileName);
		// 엑셀 출력
		//workbook.write(resp.getOutputStream());
		//workbook.close();
		
	    resp.setHeader("Content-Disposition", "attachment;filename=\"" + URLEncoder.encode(fileName, "UTF-8").replace("+", "%20") + "\";");             
		resp.setContentType("application/octer-stream");
		resp.setHeader("Content-Transfer-Encoding", "binary;");
		
		FileInputStream fis = new FileInputStream(file);
		try{
			ServletOutputStream sos = resp.getOutputStream();
			byte[] b = new byte[1024];
			
			int data = 0;
			
			while((data=(fis.read(b, 0, b.length))) != -1){
				sos.write(b, 0, data);
			}
			sos.flush();
		} catch(Exception e) {
			throw e;
		} finally{
			fis.close();
		}
		
		if(file.delete()){
			System.out.println(fileName);
		}
		//return resultFilePath;
		//return new ObjectMapper().writeValueAsString(mfgDoc);
	}
	
	/**
	 * 엑셀 생성 및 다운로드(점포용)
	 */
	@RequestMapping(value="mainTask3", produces="text/plain;charset=utf-8", method=RequestMethod.POST)
	@ResponseBody
	public void mainTask3(HttpServletRequest req, HttpServletResponse resp, @RequestParam Map<String, Object> param) throws Exception{	
		String resultFilePath = "";
		
		param.put("userId", AuthUtil.getAuth(req).getUserId());
		Map<String,Object> docData = approvalService.getDocData(param);
		MfgProcessDoc mfgDoc = productDevService.getMfgProcessDocDetail(param.get("tbKey").toString(), docData.get("docNo").toString(), docData.get("docVersion").toString(), "");
		ProductDevDocVO devDoc = productDevService.getProductDevDoc(docData.get("docNo").toString(), docData.get("docVersion").toString());
		Map<String, Object> manufacturingNoData = manufacturingNoService.selectManufacturingNoDataByDocNo(param);
		
		//List<ImageFileForStores> imgFiles = productDevService.getImageFileForStores(dNo);
		
		param.put("tbKey",mfgDoc.getDNo());
		param.put("tbType", "manufacturingProcessDoc");
		param.put("type", '0');
		
		List<ApprovalItemVO> apprItemList = approvalService.apprItemInfoExcel(param);
		
		XSSFWorkbook workbook = new XSSFWorkbook();
		XSSFSheet sheet = workbook.createSheet("sheet");
		sheet.setDefaultColumnWidth(sheet.getDefaultColumnWidth());
		
		setDefaultMerge(sheet,0,0,0,7);
		setDefaultMerge(sheet,1,2,0,7);
		//setDefaultMerge(sheet,0,2,8,13);
		
		// [BODY] start
		Row row4 = sheet.createRow(4);
		
		setHeader(workbook, sheet, mfgDoc, apprItemList, devDoc);
		setSeparater(workbook, sheet);
		
		for (MfgProcessDocSubProd sub : mfgDoc.getSub()) {
			int subProdStartRow = rowNum;
			
			setSubProductName3(workbook, sheet, sub.getSubProdName());
			if(StringUtil.nvl(mfgDoc.getCalcType()).equals("40")){
				setForStoreProductImg(workbook, sheet, mfgDoc); //제품사진
			}
			setSubProduct3(workbook, sheet, sub, mfgDoc.getCalcType()); // 배합비 내용물 모두 표시
			
			int subProdEndRow = rowNum-1;
			
			// setSubProdBorder
			setBorder(sheet, BorderStyle.THICK, subProdStartRow, subProdEndRow, 0, 15);
		}

		if(StringUtil.nvl(mfgDoc.getCalcType()).equals("40")){	
			setStoreMethod(mfgDoc.getStoreMethod(), workbook, sheet); 			// 제조방법
			setForStoreMethodImg(workbook, sheet, mfgDoc);						// 제조순서 , 완제품 주의시항
			setEtcInfo(workbook, sheet, mfgDoc, devDoc, manufacturingNoData); 	// 비고
		}else{
			// 7번코드의 경우 재료, 표시사항 배합비 X
			if(mfgDoc.getCalcType() != null && !mfgDoc.getCalcType().equals("7")){
				setMatDisp(workbook, sheet, mfgDoc.getPkg(), mfgDoc.getDisp());
			}
			setTextAndImage(workbook, sheet, mfgDoc);
			setEtcInfo(workbook, sheet, mfgDoc, devDoc, manufacturingNoData);
		}
		
		/*
		List<CellRangeAddress> rangeList = sheet.getMergedRegions();
		String log = " ragneList logger ";
		for (CellRangeAddress cellRangeAddress : rangeList) {
			int firstRow = cellRangeAddress.getFirstRow();
			int lastRow = cellRangeAddress.getLastRow();
			int firstColumn = cellRangeAddress.getFirstColumn();
			int lastColumn = cellRangeAddress.getLastColumn();
			
			log += "\n\t"+firstRow+", "+lastRow+", "+firstColumn+", "+lastColumn+", ";
		}
		
		System.out.println(log);
		*/
		
		String fileName = "제조공정서(" + mfgDoc.getDocNo() + "-"+mfgDoc.getDocVersion()+")_" + getNow() + ".xlsx";		// "제조공정서(12)_20150305150816.xlsx"
		resultFilePath = OUTPUT_FILE_PATH + fileName;
		
		makeOutputFile(resultFilePath, workbook);
		
		File file = new File(resultFilePath);

	    String downloadName = null;
	    String browser = req.getHeader("User-Agent");
	    //파일 인코딩
	    if(browser.contains("MSIE") || browser.contains("Trident") || browser.contains("Chrome")){
	      //브라우저 확인 파일명 encode  		             
	      downloadName = URLEncoder.encode(file.getName(), "UTF-8").replaceAll("\\+", "%20");		             
	    }else{		             
	      downloadName = new String(file.getName().getBytes("UTF-8"), "ISO-8859-1");
	    }  
		
		// 컨텐츠 타입과 파일명 지정
		//resp.setContentType("ms-vnd/excel");
		//resp.setHeader("Content-Disposition", "attachment;filename="+fileName);
		// 엑셀 출력
		//workbook.write(resp.getOutputStream());
		//workbook.close();
		
	    resp.setHeader("Content-Disposition", "attachment;filename=\"" + URLEncoder.encode(fileName, "UTF-8").replace("+", "%20") + "\";");             
		resp.setContentType("application/octer-stream");
		resp.setHeader("Content-Transfer-Encoding", "binary;");
		
		FileInputStream fis = new FileInputStream(file);
		try{
			ServletOutputStream sos = resp.getOutputStream();
			byte[] b = new byte[1024];
			
			int data = 0;
			
			while((data=(fis.read(b, 0, b.length))) != -1){
				sos.write(b, 0, data);
			}
			sos.flush();
		} catch(Exception e) {
			throw e;
		} finally{
			fis.close();
		}
		
		if(file.delete()){
			System.out.println(fileName);
		}
		//return resultFilePath;
		//return new ObjectMapper().writeValueAsString(mfgDoc);
	}

	private String getNow(){
		return new SimpleDateFormat("yyyyMMddHHmmss").format(Calendar.getInstance(TimeZone.getTimeZone("Asia/Seoul")).getTime());
	}
	
	private void makeOutputFile(String path, XSSFWorkbook workBook) throws Exception{
		FileOutputStream fo = new FileOutputStream(path);
		workBook.write(fo);
		fo.close();				
	}
	
	private void setHeader(Workbook workbook, Sheet sheet, MfgProcessDoc mfgDoc, List<ApprovalItemVO> apprItemList, ProductDevDocVO devDoc) throws Exception {
		// [HEADER] start
		Row row0 = sheet.createRow(0);
		Row row1 = sheet.createRow(1);
		Row row2 = sheet.createRow(2);
		
		/* 제조공정서 번호 */
		String mfgProcessDocNo = (String)mfgDoc.getDNo();
		
		rowNum = 3;
		
		for (int i = 0; i < ( apprItemList.size()<5 ? apprItemList.size() : 5 ) ; i++) {
			int startCellNum = 8;
			Cell cell0 = row0.createCell(startCellNum+i);
			String cell0Value = "";
			if(apprItemList.get(i).getSeq() == 1){
				cell0Value = "기안";
			} else {
				cell0Value = String.valueOf(apprItemList.get(i).getSeq()-1)+"차 결재";
			}
			cell0.setCellValue(cell0Value);
			cell0.setCellStyle(getCellStyle(workbook, "default"));
			setBorder(sheet, BorderStyle.THIN, cell0);
			
			Cell cell1 = row1.createCell(startCellNum+i);
			cell1.setCellValue(apprItemList.get(i).getUserName());
			cell1.setCellStyle(getCellStyle(workbook, "default"));
			setBorder(sheet, BorderStyle.THIN, cell1);
			
			Cell cell2 = row2.createCell(startCellNum+i);
			String cell2Value = "";
			if(apprItemList.get(i).getSeq() == 1){
				cell2Value = apprItemList.get(i).getRegDate();
			} else {
				if(apprItemList.get(i).getModDate() != null && !"".equals(apprItemList.get(i).getModDate())){
					cell2Value = apprItemList.get(i).getModDate();
				} else {
					cell2Value = "";
				}
			}
			cell2.setCellValue(cell2Value);
			cell2.setCellStyle(getCellStyle(workbook, "default"));
			setBorder(sheet, BorderStyle.THIN, cell2);
		}
		
		Cell cell = row0.createCell(0);
		cell.setCellValue("제품제조공정서");
		cell.setCellStyle(getCellStyle(workbook, "subTitle"));
		setBorder(sheet, BorderStyle.THIN, cell);
		
		/*Cell cell8 = row0.createCell(8);
		setBorder(sheet, BorderStyle.THIN, 0, 0, 8, 15);
		setBorder(sheet, BorderStyle.THIN, cell8);*/
		
		Cell cell10 = row0.createCell(14);
		cell10.setCellValue("문서번호");
		cell10.setCellStyle(getCellStyle(workbook, "subTitle"));
		setBorder(sheet, BorderStyle.THIN, cell10);
		
		Cell cell11 = row0.createCell(15);
		cell11.setCellValue("SHA-L-" + mfgProcessDocNo);
		cell11.setCellStyle(getCellStyle(workbook, "default"));
		setBorder(sheet, BorderStyle.THIN, cell10);
		
		Cell row1Cell0 = row1.createCell(0);
		String documentName ="";
		// 기존(공장)일때 헤더 명
		if(devDoc.getProductDocType() == null || devDoc.getProductDocType().equals("0") || devDoc.getProductDocType().equals("2")){ 
			documentName = StringUtil.nvl(devDoc.getStoreDiv()) + StringUtil.getHtmlBr(devDoc.getProductName())+"("+devDoc.getProductCode()+")/"+ StringUtil.nvl(mfgDoc.getPlantName());
		}else{ 
			// 23.10.11 점포명 공통코드화
			documentName = StringUtil.nvl(devDoc.getStoreDivText()) + StringUtil.getHtmlBr(devDoc.getProductName()); // 점포용일때 헤더 명	
		}
		row1Cell0.setCellValue(documentName);
		row1Cell0.setCellStyle(getCellStyle(workbook, "title"));
		setBorder(sheet, BorderStyle.THIN, row1Cell0);
		
		Cell row1Cell10 = row1.createCell(14);
		row1Cell10.setCellValue("제개정일");
		row1Cell10.setCellStyle(getCellStyle(workbook, "subTitle"));
		setBorder(sheet, BorderStyle.THIN, row1Cell10);
		
		Cell row1Cell11 = row1.createCell(15);
		String lastDate = "";
		if(mfgDoc.getModDate() != null){
			lastDate = mfgDoc.getModDate().split(" ")[0] == null ? "" : mfgDoc.getModDate().split(" ")[0];
		} else {
			lastDate = "";
		}
		
		//String lastDate = mfgDoc.getRegDate().split(" ")[0];
		row1Cell11.setCellValue(lastDate);
		row1Cell11.setCellStyle(getCellStyle(workbook, "default"));
		setBorder(sheet, BorderStyle.THIN, row1Cell11);
		
		Cell row2Cell10 = row2.createCell(14);
		row2Cell10.setCellValue("제정판수");
		row2Cell10.setCellStyle(getCellStyle(workbook, "subTitle"));
		setBorder(sheet, BorderStyle.THIN, row2Cell10);
		
		Cell row2Cell11 = row2.createCell(15);
		row2Cell11.setCellValue(mfgDoc.getDocVersion());
		row2Cell11.setCellStyle(getCellStyle(workbook, "default"));
		setBorder(sheet, BorderStyle.THIN, row2Cell11);
		
		setBorder(sheet, BorderStyle.THICK, 0,2,0,15);
		// [HEADER] end
	}
	
	private void setSeparater(Workbook workbook, Sheet sheet){
		Row row = sheet.createRow(rowNum);
		row.createCell(0);
		row.setHeight((short) 250);
		
		rowNum++;
	}
	
	private void setSubProductName(Workbook workbook, Sheet sheet, String subProdName){
		//System.out.println("setSubProductName rowNum: " + rowNum);
		Row row = sheet.createRow(rowNum);
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, FIRST_CELLNUM, LAST_CELLNUM));
		Cell cell = row.createCell(0);
		
		Font font = workbook.createFont();
		font.setFontName("맑은 고딕");
		font.setBold(false);
		font.setFontHeightInPoints((short) 9);
		
		CellStyle cellStyle = workbook.createCellStyle();
		cellStyle.setAlignment(HorizontalAlignment.CENTER);
		cellStyle.setVerticalAlignment(VerticalAlignment.CENTER);
		cellStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.index);
		cellStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
		cellStyle.setFont(font);
		
		cell.setCellStyle(cellStyle);
		cell.setCellValue("부속제품명 : " + subProdName);
		
		rowNum++;
	}
	
	private void setSubProductName3(Workbook workbook, Sheet sheet, String subProdName){
		//System.out.println("setSubProductName rowNum: " + rowNum);
		Row row = sheet.createRow(rowNum);
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, FIRST_CELLNUM, LAST_CELLNUM));
		Cell cell = row.createCell(0);
		
		Font font = workbook.createFont();
		font.setFontName("맑은 고딕");
		font.setBold(false);
		font.setFontHeightInPoints((short) 9);
		
		CellStyle cellStyle = workbook.createCellStyle();
		cellStyle.setAlignment(HorizontalAlignment.CENTER);
		cellStyle.setVerticalAlignment(VerticalAlignment.CENTER);
		cellStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.index);
		cellStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
		cellStyle.setFont(font);
		
		cell.setCellStyle(cellStyle);
		cell.setCellValue("제품명 : " + subProdName);
		
		rowNum++;
	}
	
	
	private void setSubProduct(Workbook workbook, Sheet sheet, MfgProcessDocSubProd sub, String calcType) throws Exception {
		setMixCont(sub, "mix", workbook, sheet, calcType);
		if(!StringUtil.nvl(calcType).equals("40")){
			setMixCont(sub, "cont", workbook, sheet, calcType);
		}
		
		if(StringUtil.nvl(calcType).equals("10")){
			setSubProdBomRateTotal(sub, workbook, sheet, calcType);
		}
	}
	
	private void setSubProdBomRateTotal(MfgProcessDocSubProd sub, Workbook workbook, Sheet sheet, String calcType)throws Exception{
		// 240724 배합총합 추가 (calcType 10)만 해당
		
		Row etcRow = sheet.createRow(rowNum);
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, 4));
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 5, 7));
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 8, 12));
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 13, 15));
		
		Cell stdAmountCell0 = etcRow.createCell(0);
		stdAmountCell0.setCellValue("배합 총합");
		stdAmountCell0.setCellStyle(getCellStyle(workbook, "itemName"));
		setBorder(sheet, BorderStyle.THIN, stdAmountCell0);
		
		Cell stdAmountCell5 = etcRow.createCell(5);
		stdAmountCell5.setCellValue(sub.getSubProdBomRateTotal());
		stdAmountCell5.setCellStyle(getCellStyle(workbook, "default"));
		setBorder(sheet, BorderStyle.THIN, stdAmountCell5);
		
		Cell divWeightCell8 = etcRow.createCell(8);
		//divWeightCell8.setCellValue("");
		divWeightCell8.setCellStyle(getCellStyle(workbook, "itemName"));
		setBorder(sheet, BorderStyle.THIN, divWeightCell8);

		Cell divWeightCell13 = etcRow.createCell(13);
		//divWeightCell13.setCellValue(sub.getDivWeight() + " g");
		divWeightCell13.setCellStyle(getCellStyle(workbook, "default"));
		setBorder(sheet, BorderStyle.THIN, divWeightCell13);
		
		rowNum += 1;
		
	}
	
	private void setSubProduct3(Workbook workbook, Sheet sheet, MfgProcessDocSubProd sub, String calcType) throws Exception {
		setMixCont3(sub, "mix", workbook, sheet, calcType);
		setMixCont3(sub, "cont", workbook, sheet, calcType);	
	}
	
	private void setMixCont(MfgProcessDocSubProd sub, String type, Workbook workbook, Sheet sheet, String calcType) throws Exception {
		List<MfgProcessDocBase> base = new ArrayList<MfgProcessDocBase>();
		if(type.equals("mix"))
			base = sub.getMix();
		
		if(type.equals("cont"))
			base = sub.getCont();
		
		int tempItemSize = 0;
		
		String tempLeftContName = "";
		String tempLeftContDivWieght = "";
		double tempTotalLeftBomRate = 0;
		double tempTotalLeftBomAmount = 0;
		
		for (int i=0; i < base.size();  i++) {
			MfgProcessDocBase mix = base.get(i);
			//System.out.println("setSubProduct Mix rowNum: " + (rowNum) + ", baseName: " + mix.getBaseName());
			
			double totalLeftBomRate = 0;
			double totalLeftBomAmount = 0;
			double totalRightBomRate = 0;
			double totalRightBomAmount = 0;

			if(i%2 == 0){
				for (int j=0; j < mix.getItem().size(); j++) {
					//System.out.println("\t i%2 rowNum+j: " + (rowNum+j) + ", tempItemSize: " + tempItemSize);
					
					if(j==0){
						// 배합,내용물 제목 열 추가
						Row baseTitle = sheet.createRow(rowNum);
						sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, 7));
						sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 8, 15));
						
						Cell headCell0 = baseTitle.createCell(0);
						String baseName = "";
						if(type.equals("mix")){
							baseName = "배합비명 : " + mix.getBaseName();
						} else if (type.equals("cont")){
							baseName = "내용물명 : " + mix.getBaseName();
						} else {
							baseName = mix.getBaseName();
						}
						headCell0.setCellValue(baseName);
						headCell0.setCellStyle(getCellStyle(workbook, type+"Title"));
						setBorder(sheet, BorderStyle.THIN, headCell0);
						
						Cell headCell8 = baseTitle.createCell(8);
						headCell8.setCellValue("");
						headCell8.setCellStyle(getCellStyle(workbook, type+"Title"));
						setBorder(sheet, BorderStyle.THIN, headCell8);
						
						// 카테고리명
						Row category = sheet.createRow(rowNum+1);
						if(StringUtil.nvl(calcType).equals("40")){
							sheet.addMergedRegion(new CellRangeAddress(rowNum+1, rowNum+1, 0, 1));
							sheet.addMergedRegion(new CellRangeAddress(rowNum+1, rowNum+1, 2, 3));
							sheet.addMergedRegion(new CellRangeAddress(rowNum+1, rowNum+1, 4, 5));
							sheet.addMergedRegion(new CellRangeAddress(rowNum+1, rowNum+1, 6, 7));
							sheet.addMergedRegion(new CellRangeAddress(rowNum+1, rowNum+1, 8, 9));
							sheet.addMergedRegion(new CellRangeAddress(rowNum+1, rowNum+1, 10, 11));
							sheet.addMergedRegion(new CellRangeAddress(rowNum+1, rowNum+1, 12, 13));
							sheet.addMergedRegion(new CellRangeAddress(rowNum+1, rowNum+1, 14, 15));
						}else{
							sheet.addMergedRegion(new CellRangeAddress(rowNum+1, rowNum+1, 0, 3));
							sheet.addMergedRegion(new CellRangeAddress(rowNum+1, rowNum+1, 8, 11));
						}

						if(StringUtil.nvl(calcType,"").equals("40")){
							// 점포용 제조공정서
							Cell categoryCell0 = category.createCell(0);
							categoryCell0.setCellValue("원료명");
							categoryCell0.setCellStyle(getCellStyle(workbook, "itemCategory"));
							setBorder(sheet, BorderStyle.THIN, categoryCell0);

							Cell categoryCell2 = category.createCell(2);
							categoryCell2.setCellValue("배합%");
							categoryCell2.setCellStyle(getCellStyle(workbook, "itemCategory"));
							setBorder(sheet, BorderStyle.THIN, categoryCell2);

							Cell categoryCell4 = category.createCell(4);
							categoryCell4.setCellValue("제조사");
							categoryCell4.setCellStyle(getCellStyle(workbook, "itemCategory"));
							setBorder(sheet, BorderStyle.THIN, categoryCell4);

							Cell categoryCell6 = category.createCell(6);
							categoryCell6.setCellValue("성분");
							categoryCell6.setCellStyle(getCellStyle(workbook, "itemCategory"));
							setBorder(sheet, BorderStyle.THIN, categoryCell6);

							Cell categoryCell8 = category.createCell(8);
							categoryCell8.setCellValue("원료명");
							categoryCell8.setCellStyle(getCellStyle(workbook, "itemCategory"));
							setBorder(sheet, BorderStyle.THIN, categoryCell8);

							Cell categoryCell10 = category.createCell(10);
							categoryCell10.setCellValue("배합%");
							categoryCell10.setCellStyle(getCellStyle(workbook, "itemCategory"));
							setBorder(sheet, BorderStyle.THIN, categoryCell10);

							Cell categoryCell12 = category.createCell(12);
							categoryCell12.setCellValue("제조사");
							categoryCell12.setCellStyle(getCellStyle(workbook, "itemCategory"));
							setBorder(sheet, BorderStyle.THIN, categoryCell12);

							Cell categoryCell14 = category.createCell(14);
							categoryCell14.setCellValue("성분");
							categoryCell14.setCellStyle(getCellStyle(workbook, "itemCategory"));
							setBorder(sheet, BorderStyle.THIN, categoryCell14);
						}else{
							Cell categoryCell0 = category.createCell(0);
							categoryCell0.setCellValue("원료명");
							categoryCell0.setCellStyle(getCellStyle(workbook, "itemCategory"));
							setBorder(sheet, BorderStyle.THIN, categoryCell0);

							Cell categoryCell4 = category.createCell(4);
							categoryCell4.setCellValue("코드번호");
							categoryCell4.setCellStyle(getCellStyle(workbook, "itemCategory"));
							setBorder(sheet, BorderStyle.THIN, categoryCell4);

							Cell categoryCell5 = category.createCell(5);
							categoryCell5.setCellValue("배합%");
							categoryCell5.setCellStyle(getCellStyle(workbook, "itemCategory"));
							setBorder(sheet, BorderStyle.THIN, categoryCell5);

							Cell categoryCell6 = category.createCell(6);
							categoryCell6.setCellValue("BOM");
							categoryCell6.setCellStyle(getCellStyle(workbook, "itemCategory"));
							setBorder(sheet, BorderStyle.THIN, categoryCell6);

							Cell categoryCell7 = category.createCell(7);
							categoryCell7.setCellValue("스크랩(%)");
							categoryCell7.setCellStyle(getCellStyle(workbook, "itemCategory"));
							setBorder(sheet, BorderStyle.THIN, categoryCell7);

							if(calcType != null && calcType.equals("7")){
								Cell categoryCell8 = category.createCell(8);
								categoryCell8.setCellValue("");
								categoryCell8.setCellStyle(getCellStyle(workbook, "itemCategory"));
								setBorder(sheet, BorderStyle.THIN, categoryCell8);

								Cell categoryCell12 = category.createCell(12);
								categoryCell12.setCellValue("");
								categoryCell12.setCellStyle(getCellStyle(workbook, "itemCategory"));
								setBorder(sheet, BorderStyle.THIN, categoryCell12);

								Cell categoryCell13 = category.createCell(13);
								categoryCell13.setCellValue("");
								categoryCell13.setCellStyle(getCellStyle(workbook, "itemCategory"));
								setBorder(sheet, BorderStyle.THIN, categoryCell13);

								Cell categoryCell14 = category.createCell(14);
								categoryCell14.setCellValue("");
								categoryCell14.setCellStyle(getCellStyle(workbook, "itemCategory"));
								setBorder(sheet, BorderStyle.THIN, categoryCell4);

								Cell categoryCell15 = category.createCell(15);
								categoryCell15.setCellValue("");
								categoryCell15.setCellStyle(getCellStyle(workbook, "itemCategory"));
								setBorder(sheet, BorderStyle.THIN, categoryCell15);
							} else {
								Cell categoryCell8 = category.createCell(8);
								categoryCell8.setCellValue("원료명");
								categoryCell8.setCellStyle(getCellStyle(workbook, "itemCategory"));
								setBorder(sheet, BorderStyle.THIN, categoryCell8);

								Cell categoryCell12 = category.createCell(12);
								categoryCell12.setCellValue("코드번호");
								categoryCell12.setCellStyle(getCellStyle(workbook, "itemCategory"));
								setBorder(sheet, BorderStyle.THIN, categoryCell12);

								Cell categoryCell13 = category.createCell(13);
								categoryCell13.setCellValue("배합%");
								categoryCell13.setCellStyle(getCellStyle(workbook, "itemCategory"));
								setBorder(sheet, BorderStyle.THIN, categoryCell13);

								Cell categoryCell14 = category.createCell(14);
								categoryCell14.setCellValue("BOM");
								categoryCell14.setCellStyle(getCellStyle(workbook, "itemCategory"));
								setBorder(sheet, BorderStyle.THIN, categoryCell4);

								Cell categoryCell15 = category.createCell(15);
								categoryCell15.setCellValue("스크랩(%)");
								categoryCell15.setCellStyle(getCellStyle(workbook, "itemCategory"));
								setBorder(sheet, BorderStyle.THIN, categoryCell15);
							}
						}
					}
					Row row = sheet.createRow(rowNum+2+j);

					if(StringUtil.nvl(calcType).equals("40")){
						sheet.addMergedRegion(new CellRangeAddress(rowNum+2+j, rowNum+2+j, 0, 1));
						sheet.addMergedRegion(new CellRangeAddress(rowNum+2+j, rowNum+2+j, 2, 3));
						sheet.addMergedRegion(new CellRangeAddress(rowNum+2+j, rowNum+2+j, 4, 5));
						sheet.addMergedRegion(new CellRangeAddress(rowNum+2+j, rowNum+2+j, 6, 7));
						sheet.addMergedRegion(new CellRangeAddress(rowNum+2+j, rowNum+2+j, 8, 9));
						sheet.addMergedRegion(new CellRangeAddress(rowNum+2+j, rowNum+2+j, 10, 11));
						sheet.addMergedRegion(new CellRangeAddress(rowNum+2+j, rowNum+2+j, 12, 13));
						sheet.addMergedRegion(new CellRangeAddress(rowNum+2+j, rowNum+2+j, 14, 15));
					}else{
						sheet.addMergedRegion(new CellRangeAddress(rowNum+2+j, rowNum+2+j, 0, 3));
						sheet.addMergedRegion(new CellRangeAddress(rowNum+2+j, rowNum+2+j, 8, 11));
					}

					if(StringUtil.nvl(calcType).equals("40")){
						// 점포용 제조공정서
						Cell nameCell0 = row.createCell(0);
						nameCell0.setCellValue(mix.getItem().get(j).getItemName());
						nameCell0.setCellStyle(getCellStyle(workbook, "itemName"));
						setBorder(sheet, BorderStyle.THIN, nameCell0);

						Cell nameCell2 = row.createCell(2);
						nameCell2.setCellValue(mix.getItem().get(j).getBomAmount());
						nameCell2.setCellStyle(getCellStyle(workbook, "default"));
						setBorder(sheet, BorderStyle.THIN, nameCell2);

						Cell nameCell4 = row.createCell(4);
						nameCell4.setCellValue(mix.getItem().get(j).getManuCompany());
						nameCell4.setCellStyle(getCellStyle(workbook, "default"));
						setBorder(sheet, BorderStyle.THIN, nameCell4);

						Cell nameCell6 = row.createCell(6);
						nameCell6.setCellValue(mix.getItem().get(j).getIngradient());
						nameCell6.setCellStyle(getCellStyle(workbook, "default"));
						setBorder(sheet, BorderStyle.THIN, nameCell6);

						try {
							totalLeftBomAmount += Double.parseDouble(mix.getItem().get(j).getBomAmount());
						} catch ( Exception e ){
							totalLeftBomAmount += 0;
						}

						Cell nameCell8 = row.createCell(8);
						nameCell8.setCellStyle(getCellStyle(workbook, "default"));
						setBorder(sheet, BorderStyle.THIN, nameCell8);
						Cell nameCell10 = row.createCell(10);
						nameCell10.setCellStyle(getCellStyle(workbook, "default"));
						setBorder(sheet, BorderStyle.THIN, nameCell10);
						Cell nameCell12 = row.createCell(12);
						nameCell12.setCellStyle(getCellStyle(workbook, "default"));
						setBorder(sheet, BorderStyle.THIN, nameCell12);
						Cell nameCell14 = row.createCell(14);
						nameCell14.setCellStyle(getCellStyle(workbook, "default"));
						setBorder(sheet, BorderStyle.THIN, nameCell14);
					}else{
						Cell nameCell0 = row.createCell(0);
						if(mix.getItem().get(j).getCoo() != null && !"".equals(mix.getItem().get(j).getCoo())){
							nameCell0.setCellValue(mix.getItem().get(j).getItemName()+" ["+mix.getItem().get(j).getCooName()+"]");
						} else {
							//nameCell0.setCellValue(mix.getItem().get(j).getItemName());
							nameCell0.setCellValue(StringUtil.getHtmlBr(mix.getItem().get(j).getItemName())); 
						}
						nameCell0.setCellStyle(getCellStyle(workbook, "itemName"));
						setBorder(sheet, BorderStyle.THIN, nameCell0);

						Cell nameCell1 = row.createCell(4);
						nameCell1.setCellValue(mix.getItem().get(j).getItemCode());
						nameCell1.setCellStyle(getCellStyle(workbook, "default"));
						setBorder(sheet, BorderStyle.THIN, nameCell1);

						Cell nameCell5 = row.createCell(5);
						if(calcType != null && calcType.equals("7")){
							nameCell5.setCellValue("-");
						} else {
							nameCell5.setCellValue(mix.getItem().get(j).getBomAmount());
						}
						nameCell5.setCellStyle(getCellStyle(workbook, "default"));
						setBorder(sheet, BorderStyle.THIN, nameCell5);
						try {
							totalLeftBomRate += Double.parseDouble(mix.getItem().get(j).getBomAmount());
						} catch ( Exception e ){
							totalLeftBomRate += 0;
						}

						Cell nameCell6 = row.createCell(6);
						nameCell6.setCellValue(mix.getItem().get(j).getBomRate());
						nameCell6.setCellStyle(getCellStyle(workbook, "default"));
						setBorder(sheet, BorderStyle.THIN, nameCell6);
						try {
							if(calcType != null && calcType.equals("7")){
								if(mix.getItem().get(j).getItemCode().startsWith("4") || mix.getItem().get(j).getItemCode().startsWith("5")){
									totalLeftBomAmount += 0;
								} else {
									totalLeftBomAmount += Double.parseDouble(mix.getItem().get(j).getBomRate());
								}
							} else {
								totalLeftBomAmount += Double.parseDouble(mix.getItem().get(j).getBomRate());
							}
						}catch( Exception e ) {
							totalLeftBomRate += 0;
						}

						Cell nameCell7 = row.createCell(7);
						if(calcType != null && calcType.equals("7")){
							nameCell7.setCellValue("-");
						} else {
							nameCell7.setCellValue(mix.getItem().get(j).getScrap());
						}
						nameCell7.setCellStyle(getCellStyle(workbook, "default"));
						setBorder(sheet, BorderStyle.THIN, nameCell7);

						Cell nameCell8 = row.createCell(8);
						nameCell8.setCellStyle(getCellStyle(workbook, "itemName"));
						setBorder(sheet, BorderStyle.THIN, nameCell8);

						Cell nameCell12 = row.createCell(12);
						nameCell12.setCellStyle(getCellStyle(workbook, "default"));
						setBorder(sheet, BorderStyle.THIN, nameCell12);

						Cell nameCell13 = row.createCell(13);
						nameCell13.setCellStyle(getCellStyle(workbook, "default"));
						setBorder(sheet, BorderStyle.THIN, nameCell13);

						Cell nameCell14 = row.createCell(14);
						nameCell14.setCellStyle(getCellStyle(workbook, "default"));
						setBorder(sheet, BorderStyle.THIN, nameCell14);

						Cell nameCell15 = row.createCell(15);
						nameCell15.setCellStyle(getCellStyle(workbook, "default"));
						setBorder(sheet, BorderStyle.THIN, nameCell15);
					}
				}
				tempItemSize =  mix.getItem().size();
			} else {
				for (int j=0; j < mix.getItem().size(); j++) {
					//System.out.println("\t !i%2 rowNum+j: " + (rowNum+j) + ", tempItemSize: " + tempItemSize);
					
					if(j==0){
						// 배합,내용물 제목 열 추가
						Row baseTitle = sheet.getRow(rowNum);
						
						Cell headCell = baseTitle.getCell(8);
						String baseName = "";
						if(type.equals("mix")){
							baseName = "배합비명 : " + mix.getBaseName();
						} else if (type.equals("cont")){
							baseName = "내용물명 : " + mix.getBaseName();
						} else {
							baseName = mix.getBaseName();
						}
						headCell.setCellValue(baseName);
						headCell.setCellStyle(getCellStyle(workbook, type+"Title"));
						setBorder(sheet, BorderStyle.THIN, headCell);
					}
					
					if(j < tempItemSize){
						Row row = sheet.getRow(rowNum+2+j);

						if(StringUtil.nvl(calcType).equals("40")){
							Cell nameCell8 = row.getCell(8);
							nameCell8.setCellValue(mix.getItem().get(j).getItemName());

							Cell nameCell10 = row.getCell(10);
							nameCell10.setCellValue(mix.getItem().get(j).getBomAmount());

							Cell nameCell12 = row.getCell(12);
							nameCell12.setCellValue(mix.getItem().get(j).getManuCompany());

							Cell nameCell14 = row.getCell(14);
							nameCell14.setCellValue(mix.getItem().get(j).getIngradient());

							try {
								totalRightBomAmount += Double.parseDouble(mix.getItem().get(j).getBomAmount());
							} catch( Exception e ) {
								totalRightBomAmount += 0;
							}

						}else{
							Cell nameCell = row.getCell(8);
							//nameCell.setCellValue(mix.getItem().get(j).getItemName());
							nameCell.setCellValue(StringUtil.getHtmlBr(mix.getItem().get(j).getItemName()));
							
							Cell nameCell12 = row.getCell(12);
							nameCell12.setCellValue(mix.getItem().get(j).getItemCode());

							Cell nameCell13 = row.getCell(13);
							nameCell13.setCellValue(mix.getItem().get(j).getBomAmount());
							try {
								totalRightBomRate += Double.parseDouble(mix.getItem().get(j).getBomAmount());
							} catch( Exception e ) {
								totalRightBomRate += 0;
							}

							Cell nameCell14 = row.getCell(14);
							nameCell14.setCellValue(mix.getItem().get(j).getBomRate());
							try {
								totalRightBomAmount += Double.parseDouble(mix.getItem().get(j).getBomRate());
							} catch( Exception e ) {
								totalRightBomAmount += 0;
							}

							Cell nameCell15 = row.getCell(15);
							nameCell15.setCellValue(mix.getItem().get(j).getScrap());
						}
					} else {
						Row row = sheet.createRow(rowNum+2+j);

						if(StringUtil.nvl(calcType).equals("40")){
							sheet.addMergedRegion(new CellRangeAddress(rowNum+2+j, rowNum+2+j, 0, 1));
							sheet.addMergedRegion(new CellRangeAddress(rowNum+2+j, rowNum+2+j, 2, 3));
							sheet.addMergedRegion(new CellRangeAddress(rowNum+2+j, rowNum+2+j, 4, 5));
							sheet.addMergedRegion(new CellRangeAddress(rowNum+2+j, rowNum+2+j, 6, 7));
							sheet.addMergedRegion(new CellRangeAddress(rowNum+2+j, rowNum+2+j, 8, 9));
							sheet.addMergedRegion(new CellRangeAddress(rowNum+2+j, rowNum+2+j, 10, 11));
							sheet.addMergedRegion(new CellRangeAddress(rowNum+2+j, rowNum+2+j, 12, 13));
							sheet.addMergedRegion(new CellRangeAddress(rowNum+2+j, rowNum+2+j, 14, 15));
						}else{
							sheet.addMergedRegion(new CellRangeAddress(rowNum+2+j, rowNum+2+j, 0, 3));
							sheet.addMergedRegion(new CellRangeAddress(rowNum+2+j, rowNum+2+j, 8, 11));
						}

						if(StringUtil.nvl(calcType).equals("40")){
							Cell nameCell0 = row.createCell(0);
							nameCell0.setCellStyle(getCellStyle(workbook, "itemName"));
							setBorder(sheet, BorderStyle.THIN, nameCell0);

							Cell nameCell2 = row.createCell(2);
							nameCell2.setCellStyle(getCellStyle(workbook, "default"));
							setBorder(sheet, BorderStyle.THIN, nameCell2);

							Cell nameCell4 = row.createCell(4);
							nameCell4.setCellStyle(getCellStyle(workbook, "default"));
							setBorder(sheet, BorderStyle.THIN, nameCell4);

							Cell nameCell6 = row.createCell(6);
							nameCell6.setCellStyle(getCellStyle(workbook, "default"));
							setBorder(sheet, BorderStyle.THIN, nameCell6);

							Cell nameCell8 = row.createCell(8);
							nameCell8.setCellValue(mix.getItem().get(j).getItemName());
							nameCell8.setCellStyle(getCellStyle(workbook, "itemName"));
							setBorder(sheet, BorderStyle.THIN, nameCell8);

							Cell nameCell10 = row.createCell(10);
							nameCell10.setCellValue(mix.getItem().get(j).getBomAmount());
							nameCell10.setCellStyle(getCellStyle(workbook, "default"));
							setBorder(sheet, BorderStyle.THIN, nameCell10);

							Cell nameCell12 = row.createCell(12);
							nameCell10.setCellValue(mix.getItem().get(j).getManuCompany());
							nameCell12.setCellStyle(getCellStyle(workbook, "default"));
							setBorder(sheet, BorderStyle.THIN, nameCell12);

							Cell nameCell14 = row.createCell(14);
							nameCell10.setCellValue(mix.getItem().get(j).getIngradient());
							nameCell14.setCellStyle(getCellStyle(workbook, "default"));
							setBorder(sheet, BorderStyle.THIN, nameCell14);

							try {
								totalRightBomAmount += Double.parseDouble(mix.getItem().get(j).getBomAmount());
							} catch( Exception e ) {
								totalRightBomAmount += 0;
							}
						}else{
							Cell nameCell0 = row.createCell(0);
							nameCell0.setCellStyle(getCellStyle(workbook, "itemName"));
							setBorder(sheet, BorderStyle.THIN, nameCell0);

							Cell nameCell1 = row.createCell(4);
							nameCell1.setCellStyle(getCellStyle(workbook, "default"));
							setBorder(sheet, BorderStyle.THIN, nameCell1);

							Cell nameCell5 = row.createCell(5);
							nameCell5.setCellStyle(getCellStyle(workbook, "default"));
							setBorder(sheet, BorderStyle.THIN, nameCell5);

							Cell nameCell6 = row.createCell(6);
							nameCell6.setCellStyle(getCellStyle(workbook, "default"));
							setBorder(sheet, BorderStyle.THIN, nameCell6);

							Cell nameCell7 = row.createCell(7);
							nameCell7.setCellStyle(getCellStyle(workbook, "default"));
							setBorder(sheet, BorderStyle.THIN, nameCell7);

							Cell nameCell8 = row.createCell(8);
							//nameCell8.setCellValue(mix.getItem().get(j).getItemName());
							nameCell8.setCellValue(StringUtil.getHtmlBr(mix.getItem().get(j).getItemName()));
							nameCell8.setCellStyle(getCellStyle(workbook, "itemName"));
							setBorder(sheet, BorderStyle.THIN, nameCell8);

							Cell nameCell12 = row.createCell(12);
							nameCell12.setCellValue(mix.getItem().get(j).getItemCode());
							nameCell12.setCellStyle(getCellStyle(workbook, "default"));
							setBorder(sheet, BorderStyle.THIN, nameCell12);

							Cell nameCell13 = row.createCell(13);
							nameCell13.setCellValue(mix.getItem().get(j).getBomAmount());
							nameCell13.setCellStyle(getCellStyle(workbook, "default"));
							setBorder(sheet, BorderStyle.THIN, nameCell13);
							try {
								totalRightBomRate += Double.parseDouble(mix.getItem().get(j).getBomAmount());
							} catch( Exception e ) {
								totalRightBomRate += 0;
							}

							Cell nameCell14 = row.createCell(14);
							nameCell14.setCellValue(mix.getItem().get(j).getBomRate());
							nameCell14.setCellStyle(getCellStyle(workbook, "default"));
							setBorder(sheet, BorderStyle.THIN, nameCell14);
							try {
								totalRightBomAmount += Double.parseDouble(mix.getItem().get(j).getBomRate());
							} catch( Exception e ) {
								totalRightBomAmount += 0;
							}

							Cell nameCell15 = row.createCell(15);
							nameCell15.setCellValue(mix.getItem().get(j).getScrap());
							nameCell15.setCellStyle(getCellStyle(workbook, "default"));
							setBorder(sheet, BorderStyle.THIN, nameCell15);
						}
						if (j == mix.getItem().size()){
							tempItemSize = mix.getItem().size();
						}
					}
				}
				tempItemSize = tempItemSize > mix.getItem().size() ? tempItemSize : mix.getItem().size();
			}
			
			
			if(base.size()%2 == 1 && base.size() == i+1){
				
			}
			//TODO 3.8 EXCEL 배합비합계
			if(StringUtil.nvl(calcType).equals("40")){
				if(i%2 == 0){
					if(base.size() == i+1){
						rowNum += tempItemSize+2;
						Row sumRow = sheet.createRow(rowNum);
						sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, 1));
						sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 2, 3));
						sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 4, 5));
						sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 6, 7));
						sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 8, 9));
						sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 10, 11));
						sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 12, 13));
						sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 14, 15));
						Cell leftSumCell0 = sumRow.createCell(0);
						leftSumCell0.setCellValue("합계");
						leftSumCell0.setCellStyle(getCellStyle(workbook, "itemName"));
						setBorder(sheet, BorderStyle.THIN, leftSumCell0);

						Cell leftSumCell2 = sumRow.createCell(2);
						leftSumCell2.setCellValue(totalLeftBomAmount);
						leftSumCell2.setCellStyle(getCellStyle(workbook, "default"));
						setBorder(sheet, BorderStyle.THIN, leftSumCell2);

						Cell leftSumCell4 = sumRow.createCell(4);
						leftSumCell4.setCellStyle(getCellStyle(workbook, "default"));
						setBorder(sheet, BorderStyle.THIN, leftSumCell4);
						Cell leftSumCell6 = sumRow.createCell(6);
						leftSumCell6.setCellStyle(getCellStyle(workbook, "default"));
						setBorder(sheet, BorderStyle.THIN, leftSumCell6);

						Cell rightSumCell8 = sumRow.createCell(8);
						rightSumCell8.setCellValue("합계");
						rightSumCell8.setCellStyle(getCellStyle(workbook, "itemName"));
						setBorder(sheet, BorderStyle.THIN, rightSumCell8);

						Cell rightSumCell10 = sumRow.createCell(10);
						rightSumCell10.setCellValue(totalRightBomAmount);
						rightSumCell10.setCellStyle(getCellStyle(workbook, "default"));
						setBorder(sheet, BorderStyle.THIN, rightSumCell10);

						Cell rightSumCell12 = sumRow.createCell(12);
						rightSumCell12.setCellStyle(getCellStyle(workbook, "default"));
						setBorder(sheet, BorderStyle.THIN, rightSumCell12);
						Cell rightSumCell14 = sumRow.createCell(14);
						rightSumCell14.setCellStyle(getCellStyle(workbook, "default"));
						setBorder(sheet, BorderStyle.THIN, rightSumCell14);

						rowNum += 1;
					}else{
						tempTotalLeftBomAmount = totalLeftBomAmount;
					}
				}
				if(i%2 == 1){
					rowNum += tempItemSize+2;

					Row sumRow = sheet.createRow(rowNum);
					sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, 1));
					sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 2, 3));
					sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 4, 5));
					sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 6, 7));
					sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 8, 9));
					sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 10, 11));
					sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 12, 13));
					sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 14, 15));
					Cell leftSumCell0 = sumRow.createCell(0);
					leftSumCell0.setCellValue("합계");
					leftSumCell0.setCellStyle(getCellStyle(workbook, "itemName"));
					setBorder(sheet, BorderStyle.THIN, leftSumCell0);

					Cell leftSumCell2 = sumRow.createCell(2);
					leftSumCell2.setCellValue(tempTotalLeftBomAmount);
					leftSumCell2.setCellStyle(getCellStyle(workbook, "default"));
					setBorder(sheet, BorderStyle.THIN, leftSumCell2);

					Cell leftSumCell4 = sumRow.createCell(4);
					leftSumCell4.setCellStyle(getCellStyle(workbook, "default"));
					setBorder(sheet, BorderStyle.THIN, leftSumCell4);
					Cell leftSumCell6 = sumRow.createCell(6);
					leftSumCell6.setCellStyle(getCellStyle(workbook, "default"));
					setBorder(sheet, BorderStyle.THIN, leftSumCell6);

					Cell rightSumCell8 = sumRow.createCell(8);
					rightSumCell8.setCellValue("합계");
					rightSumCell8.setCellStyle(getCellStyle(workbook, "itemName"));
					setBorder(sheet, BorderStyle.THIN, rightSumCell8);

					Cell rightSumCell10 = sumRow.createCell(10);
					rightSumCell10.setCellValue(totalRightBomAmount);
					rightSumCell10.setCellStyle(getCellStyle(workbook, "default"));
					setBorder(sheet, BorderStyle.THIN, rightSumCell10);

					Cell rightSumCell12 = sumRow.createCell(12);
					rightSumCell12.setCellStyle(getCellStyle(workbook, "default"));
					setBorder(sheet, BorderStyle.THIN, rightSumCell12);
					Cell rightSumCell14 = sumRow.createCell(14);
					rightSumCell14.setCellStyle(getCellStyle(workbook, "default"));
					setBorder(sheet, BorderStyle.THIN, rightSumCell14);

					rowNum += 1;
				}
			}else{
				if(i%2 == 0){
					if(base.size() == i+1){
						rowNum += tempItemSize+2;

						Row sumRow = sheet.createRow(rowNum);
						sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, 4));
						sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 8, 12));
						Cell leftSumCell0 = sumRow.createCell(0);
						leftSumCell0.setCellValue("합계");
						leftSumCell0.setCellStyle(getCellStyle(workbook, "itemName"));
						setBorder(sheet, BorderStyle.THIN, leftSumCell0);

						Cell leftSumCell5 = sumRow.createCell(5);
						if(calcType != null && calcType.equals("7")){
							leftSumCell5.setCellValue("");
						} else {
							leftSumCell5.setCellValue(totalLeftBomRate);
						}
						leftSumCell5.setCellStyle(getCellStyle(workbook, "default"));

						Cell leftSumCell6 = sumRow.createCell(6);
						leftSumCell6.setCellValue(totalLeftBomAmount);
						leftSumCell6.setCellStyle(getCellStyle(workbook, "default"));

						if(calcType != null && calcType.equals("7")){
							Cell rightSumCell0 = sumRow.createCell(8);
							rightSumCell0.setCellValue("");
							rightSumCell0.setCellStyle(getCellStyle(workbook, "itemName"));
							setBorder(sheet, BorderStyle.THIN, rightSumCell0);

							Cell rightSumCell13 = sumRow.createCell(13);
							rightSumCell13.setCellValue("");
							rightSumCell13.setCellStyle(getCellStyle(workbook, "default"));

							Cell rightSumCell14 = sumRow.createCell(14);
							rightSumCell14.setCellValue("");
							rightSumCell14.setCellStyle(getCellStyle(workbook, "default"));
						} else {
							Cell rightSumCell0 = sumRow.createCell(8);
							rightSumCell0.setCellValue("합계");
							rightSumCell0.setCellStyle(getCellStyle(workbook, "itemName"));
							setBorder(sheet, BorderStyle.THIN, rightSumCell0);

							Cell rightSumCell13 = sumRow.createCell(13);
							rightSumCell13.setCellValue(totalRightBomRate);
							rightSumCell13.setCellStyle(getCellStyle(workbook, "default"));

							Cell rightSumCell14 = sumRow.createCell(14);
							rightSumCell14.setCellValue(totalRightBomAmount);
							rightSumCell14.setCellStyle(getCellStyle(workbook, "default"));
						}

						if(i<=1 && type.equals("mix")){
							Row etcRow = sheet.createRow(rowNum+1);
							sheet.addMergedRegion(new CellRangeAddress(rowNum+1, rowNum+1, 0, 4));
							sheet.addMergedRegion(new CellRangeAddress(rowNum+1, rowNum+1, 5, 7));
							sheet.addMergedRegion(new CellRangeAddress(rowNum+1, rowNum+1, 8, 12));
							sheet.addMergedRegion(new CellRangeAddress(rowNum+1, rowNum+1, 13, 15));

							Cell stdAmountCell0 = etcRow.createCell(0);
							stdAmountCell0.setCellValue("기준수량");
							stdAmountCell0.setCellStyle(getCellStyle(workbook, "itemName"));
							setBorder(sheet, BorderStyle.THIN, stdAmountCell0);

							Cell stdAmountCell5 = etcRow.createCell(5);
							stdAmountCell5.setCellValue(sub.getStdAmount());
							stdAmountCell5.setCellStyle(getCellStyle(workbook, "default"));
							setBorder(sheet, BorderStyle.THIN, stdAmountCell5);

							if(calcType != null && calcType.equals("7")){
								Cell divWeightCell8 = etcRow.createCell(8);
								divWeightCell8.setCellValue("");
								divWeightCell8.setCellStyle(getCellStyle(workbook, "itemName"));
								setBorder(sheet, BorderStyle.THIN, divWeightCell8);

								Cell divWeightCell13 = etcRow.createCell(13);
								divWeightCell13.setCellValue("");
								divWeightCell13.setCellStyle(getCellStyle(workbook, "default"));
								setBorder(sheet, BorderStyle.THIN, divWeightCell13);
							} else {
								Cell divWeightCell8 = etcRow.createCell(8);
								divWeightCell8.setCellValue("분할중량");
								divWeightCell8.setCellStyle(getCellStyle(workbook, "itemName"));
								setBorder(sheet, BorderStyle.THIN, divWeightCell8);

								Cell divWeightCell13 = etcRow.createCell(13);
								divWeightCell13.setCellValue(sub.getDivWeight() + " g");
								divWeightCell13.setCellStyle(getCellStyle(workbook, "default"));
								setBorder(sheet, BorderStyle.THIN, divWeightCell13);
							}

							rowNum += 2;
						} else {
							if(type.equals("cont")){
								rowNum += 1;

								Row etcRow = sheet.createRow(rowNum);
								sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, 4));
								sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 5, 7));
								sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 8, 12));
								sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 13, 15));

								Cell stdAmountCell0 = etcRow.createCell(0);
								stdAmountCell0.setCellValue(mix.getBaseName() + "중량(g)");
								stdAmountCell0.setCellStyle(getCellStyle(workbook, "itemName"));
								setBorder(sheet, BorderStyle.THIN, stdAmountCell0);

								Cell stdAmountCell5 = etcRow.createCell(5);
								stdAmountCell5.setCellValue(mix.getDivWeight());
								stdAmountCell5.setCellStyle(getCellStyle(workbook, "default"));
								setBorder(sheet, BorderStyle.THIN, stdAmountCell5);

								Cell divWeightCell8 = etcRow.createCell(8);
								//divWeightCell8.setCellValue(mix.getBaseName() + "중량(g)");
								divWeightCell8.setCellStyle(getCellStyle(workbook, "itemName"));
								setBorder(sheet, BorderStyle.THIN, divWeightCell8);

								Cell divWeightCell13 = etcRow.createCell(13);
								//divWeightCell13.setCellValue(sub.getDivWeight());
								divWeightCell13.setCellStyle(getCellStyle(workbook, "default"));
								setBorder(sheet, BorderStyle.THIN, divWeightCell13);
							}

							rowNum += 1;
						}
					} else {
						tempLeftContName = mix.getBaseName();
						tempLeftContDivWieght = mix.getDivWeight();
						tempTotalLeftBomRate = totalLeftBomRate;
						tempTotalLeftBomAmount = totalLeftBomAmount;
					}
				}
				if(i%2 == 1){
					rowNum += tempItemSize+2;

					Row sumRow = sheet.createRow(rowNum);
					sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, 4));
					sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 8, 12));
					Cell leftSumCell0 = sumRow.createCell(0);
					leftSumCell0.setCellValue("합계");
					leftSumCell0.setCellStyle(getCellStyle(workbook, "itemName"));
					setBorder(sheet, BorderStyle.THIN, leftSumCell0);

					Cell leftSumCell5 = sumRow.createCell(5);
					leftSumCell5.setCellValue(tempTotalLeftBomRate);
					leftSumCell5.setCellStyle(getCellStyle(workbook, "default"));

					Cell leftSumCell6 = sumRow.createCell(6);
					leftSumCell6.setCellValue(tempTotalLeftBomAmount);
					leftSumCell6.setCellStyle(getCellStyle(workbook, "default"));

					if(calcType != null && calcType.equals("7")){
						Cell rightSumCell0 = sumRow.createCell(8);
						rightSumCell0.setCellValue("");
						rightSumCell0.setCellStyle(getCellStyle(workbook, "itemName"));
						setBorder(sheet, BorderStyle.THIN, rightSumCell0);

						Cell rightSumCell13 = sumRow.createCell(13);
						rightSumCell13.setCellValue("");
						rightSumCell13.setCellStyle(getCellStyle(workbook, "default"));

						Cell rightSumCell14 = sumRow.createCell(14);
						rightSumCell14.setCellValue("");
						rightSumCell14.setCellStyle(getCellStyle(workbook, "default"));

					} else {
						Cell rightSumCell0 = sumRow.createCell(8);
						rightSumCell0.setCellValue("합계");
						rightSumCell0.setCellStyle(getCellStyle(workbook, "itemName"));
						setBorder(sheet, BorderStyle.THIN, rightSumCell0);

						Cell rightSumCell13 = sumRow.createCell(13);
						rightSumCell13.setCellValue(totalRightBomRate);
						rightSumCell13.setCellStyle(getCellStyle(workbook, "default"));

						Cell rightSumCell14 = sumRow.createCell(14);
						rightSumCell14.setCellValue(totalRightBomAmount);
						rightSumCell14.setCellStyle(getCellStyle(workbook, "default"));
					}

					if(i<=1 && type.equals("mix")){
						Row etcRow = sheet.createRow(rowNum+1);
						sheet.addMergedRegion(new CellRangeAddress(rowNum+1, rowNum+1, 0, 4));
						sheet.addMergedRegion(new CellRangeAddress(rowNum+1, rowNum+1, 5, 7));
						sheet.addMergedRegion(new CellRangeAddress(rowNum+1, rowNum+1, 8, 12));
						sheet.addMergedRegion(new CellRangeAddress(rowNum+1, rowNum+1, 13, 15));

						Cell stdAmountCell0 = etcRow.createCell(0);
						stdAmountCell0.setCellValue("기준수량");
						stdAmountCell0.setCellStyle(getCellStyle(workbook, "itemName"));
						setBorder(sheet, BorderStyle.THIN, stdAmountCell0);

						Cell stdAmountCell5 = etcRow.createCell(5);
						stdAmountCell5.setCellValue(sub.getStdAmount());
						stdAmountCell5.setCellStyle(getCellStyle(workbook, "default"));
						setBorder(sheet, BorderStyle.THIN, stdAmountCell5);

						Cell divWeightCell8 = etcRow.createCell(8);
						divWeightCell8.setCellValue("분할중량");
						divWeightCell8.setCellStyle(getCellStyle(workbook, "itemName"));
						setBorder(sheet, BorderStyle.THIN, divWeightCell8);

						Cell divWeightCell13 = etcRow.createCell(13);
						divWeightCell13.setCellValue(sub.getDivWeight() + " g");
						divWeightCell13.setCellStyle(getCellStyle(workbook, "default"));
						setBorder(sheet, BorderStyle.THIN, divWeightCell13);

						rowNum += 2;
					} else {
						if(type.equals("cont")){
							rowNum += 1;

							Row etcRow = sheet.createRow(rowNum);
							sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, 4));
							sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 5, 7));
							sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 8, 12));
							sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 13, 15));

							Cell stdAmountCell0 = etcRow.createCell(0);
							stdAmountCell0.setCellValue(tempLeftContName + "중량(g)");
							stdAmountCell0.setCellStyle(getCellStyle(workbook, "itemName"));
							setBorder(sheet, BorderStyle.THIN, stdAmountCell0);

							Cell stdAmountCell5 = etcRow.createCell(5);
							stdAmountCell5.setCellValue(tempLeftContDivWieght);
							stdAmountCell5.setCellStyle(getCellStyle(workbook, "default"));
							setBorder(sheet, BorderStyle.THIN, stdAmountCell5);

							Cell divWeightCell8 = etcRow.createCell(8);
							divWeightCell8.setCellValue(mix.getBaseName() + "중량(g)");
							divWeightCell8.setCellStyle(getCellStyle(workbook, "itemName"));
							setBorder(sheet, BorderStyle.THIN, divWeightCell8);

							Cell divWeightCell13 = etcRow.createCell(13);
							divWeightCell13.setCellValue(mix.getDivWeight());
							divWeightCell13.setCellStyle(getCellStyle(workbook, "default"));
							setBorder(sheet, BorderStyle.THIN, divWeightCell13);
						}

						rowNum += 1;
					}
				}
			}

		}
	}
	
	private void setMixCont3(MfgProcessDocSubProd sub, String type, Workbook workbook, Sheet sheet, String calcType) throws Exception {
		//점포용
		List<MfgProcessDocBase> base = new ArrayList<MfgProcessDocBase>();
		if(type.equals("mix"))
			base = sub.getMix();
		
		if(type.equals("cont"))
			base = sub.getCont();
		
		int tempItemSize = 0;
		
		String tempLeftContName = "";
		String tempLeftContDivWieght = "";
		double tempTotalLeftBomRate = 0;
		double tempTotalLeftBomAmount = 0;
		
		double tempTotalLeftWeight = 0;
		double tempTotalRightWeight = 0;
		
		for (int i=0; i < base.size();  i++) {
			MfgProcessDocBase mix = base.get(i);
			//System.out.println("setSubProduct Mix rowNum: " + (rowNum) + ", baseName: " + mix.getBaseName());
			
			double totalLeftBomRate = 0;
			double totalLeftBomAmount = 0;
			double totalRightBomRate = 0;
			double totalRightBomAmount = 0;
			
			double totalLeftWeight = 0;
			double totalRightWeight = 0;
			

			if(i%2 == 0){
				for (int j=0; j < mix.getItem().size(); j++) {
					//System.out.println("\t i%2 rowNum+j: " + (rowNum+j) + ", tempItemSize: " + tempItemSize);
					
					if(j==0){
						// 배합,내용물 제목 열 추가
						Row baseTitle = sheet.createRow(rowNum);
						sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, 7));
						sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 8, 15));
						
						Cell headCell0 = baseTitle.createCell(0);
						String baseName = "";
						if(type.equals("mix")){
							baseName = "배합비명 : " + mix.getBaseName();
						} else if (type.equals("cont")){
							baseName = "내용물명 : " + mix.getBaseName();
						} else {
							baseName = mix.getBaseName();
						}
						headCell0.setCellValue(baseName);
						headCell0.setCellStyle(getCellStyle(workbook, type+"Title"));
						setBorder(sheet, BorderStyle.THIN, headCell0);
						
						Cell headCell8 = baseTitle.createCell(8);
						headCell8.setCellValue("");
						headCell8.setCellStyle(getCellStyle(workbook, type+"Title"));
						setBorder(sheet, BorderStyle.THIN, headCell8);
						
						// 카테고리명
						Row category = sheet.createRow(rowNum+1);
						if(StringUtil.nvl(calcType).equals("40")){
							//좌측
							sheet.addMergedRegion(new CellRangeAddress(rowNum+1, rowNum+1, 0, 1));
							sheet.addMergedRegion(new CellRangeAddress(rowNum+1, rowNum+1, 2, 4));
							sheet.addMergedRegion(new CellRangeAddress(rowNum+1, rowNum+1, 6, 7));
							//우측
							sheet.addMergedRegion(new CellRangeAddress(rowNum+1, rowNum+1, 8, 9));
							sheet.addMergedRegion(new CellRangeAddress(rowNum+1, rowNum+1, 10, 12));
							sheet.addMergedRegion(new CellRangeAddress(rowNum+1, rowNum+1, 14, 15));
						}else{
							sheet.addMergedRegion(new CellRangeAddress(rowNum+1, rowNum+1, 0, 3));
							sheet.addMergedRegion(new CellRangeAddress(rowNum+1, rowNum+1, 8, 11));
						}

						if(StringUtil.nvl(calcType,"").equals("40")){
							// 점포용 제조공정서
							Cell categoryCell0 = category.createCell(0);
							categoryCell0.setCellValue("코드번호");
							categoryCell0.setCellStyle(getCellStyle(workbook, "itemCategory"));
							setBorder(sheet, BorderStyle.THIN, categoryCell0);

							Cell categoryCell2 = category.createCell(2);
							categoryCell2.setCellValue("원료명");
							categoryCell2.setCellStyle(getCellStyle(workbook, "itemCategory"));
							setBorder(sheet, BorderStyle.THIN, categoryCell2);

							Cell categoryCell5 = category.createCell(5);
							categoryCell5.setCellValue("중량(g)");
							categoryCell5.setCellStyle(getCellStyle(workbook, "itemCategory"));
							setBorder(sheet, BorderStyle.THIN, categoryCell5);

							Cell categoryCell6 = category.createCell(6);
							categoryCell6.setCellValue("비고");
							categoryCell6.setCellStyle(getCellStyle(workbook, "itemCategory"));
							setBorder(sheet, BorderStyle.THIN, categoryCell6);

							Cell categoryCell8 = category.createCell(8);
							categoryCell8.setCellValue("코드번호");
							categoryCell8.setCellStyle(getCellStyle(workbook, "itemCategory"));
							setBorder(sheet, BorderStyle.THIN, categoryCell8);

							Cell categoryCell10 = category.createCell(10);
							categoryCell10.setCellValue("원료명");
							categoryCell10.setCellStyle(getCellStyle(workbook, "itemCategory"));
							setBorder(sheet, BorderStyle.THIN, categoryCell10);

							Cell categoryCell13 = category.createCell(13);
							categoryCell13.setCellValue("중량(g)");
							categoryCell13.setCellStyle(getCellStyle(workbook, "itemCategory"));
							setBorder(sheet, BorderStyle.THIN, categoryCell13);

							Cell categoryCell14 = category.createCell(14);
							categoryCell14.setCellValue("비고");
							categoryCell14.setCellStyle(getCellStyle(workbook, "itemCategory"));
							setBorder(sheet, BorderStyle.THIN, categoryCell14);
						}else{
							Cell categoryCell0 = category.createCell(0);
							categoryCell0.setCellValue("원료명");
							categoryCell0.setCellStyle(getCellStyle(workbook, "itemCategory"));
							setBorder(sheet, BorderStyle.THIN, categoryCell0);

							Cell categoryCell4 = category.createCell(4);
							categoryCell4.setCellValue("코드번호");
							categoryCell4.setCellStyle(getCellStyle(workbook, "itemCategory"));
							setBorder(sheet, BorderStyle.THIN, categoryCell4);

							Cell categoryCell5 = category.createCell(5);
							categoryCell5.setCellValue("배합%");
							categoryCell5.setCellStyle(getCellStyle(workbook, "itemCategory"));
							setBorder(sheet, BorderStyle.THIN, categoryCell5);

							Cell categoryCell6 = category.createCell(6);
							categoryCell6.setCellValue("BOM");
							categoryCell6.setCellStyle(getCellStyle(workbook, "itemCategory"));
							setBorder(sheet, BorderStyle.THIN, categoryCell6);

							Cell categoryCell7 = category.createCell(7);
							categoryCell7.setCellValue("스크랩(%)");
							categoryCell7.setCellStyle(getCellStyle(workbook, "itemCategory"));
							setBorder(sheet, BorderStyle.THIN, categoryCell7);

							if(calcType != null && calcType.equals("7")){
								Cell categoryCell8 = category.createCell(8);
								categoryCell8.setCellValue("");
								categoryCell8.setCellStyle(getCellStyle(workbook, "itemCategory"));
								setBorder(sheet, BorderStyle.THIN, categoryCell8);

								Cell categoryCell12 = category.createCell(12);
								categoryCell12.setCellValue("");
								categoryCell12.setCellStyle(getCellStyle(workbook, "itemCategory"));
								setBorder(sheet, BorderStyle.THIN, categoryCell12);

								Cell categoryCell13 = category.createCell(13);
								categoryCell13.setCellValue("");
								categoryCell13.setCellStyle(getCellStyle(workbook, "itemCategory"));
								setBorder(sheet, BorderStyle.THIN, categoryCell13);

								Cell categoryCell14 = category.createCell(14);
								categoryCell14.setCellValue("");
								categoryCell14.setCellStyle(getCellStyle(workbook, "itemCategory"));
								setBorder(sheet, BorderStyle.THIN, categoryCell4);

								Cell categoryCell15 = category.createCell(15);
								categoryCell15.setCellValue("");
								categoryCell15.setCellStyle(getCellStyle(workbook, "itemCategory"));
								setBorder(sheet, BorderStyle.THIN, categoryCell15);
							} else {
								Cell categoryCell8 = category.createCell(8);
								categoryCell8.setCellValue("원료명");
								categoryCell8.setCellStyle(getCellStyle(workbook, "itemCategory"));
								setBorder(sheet, BorderStyle.THIN, categoryCell8);

								Cell categoryCell12 = category.createCell(12);
								categoryCell12.setCellValue("코드번호");
								categoryCell12.setCellStyle(getCellStyle(workbook, "itemCategory"));
								setBorder(sheet, BorderStyle.THIN, categoryCell12);

								Cell categoryCell13 = category.createCell(13);
								categoryCell13.setCellValue("배합%");
								categoryCell13.setCellStyle(getCellStyle(workbook, "itemCategory"));
								setBorder(sheet, BorderStyle.THIN, categoryCell13);

								Cell categoryCell14 = category.createCell(14);
								categoryCell14.setCellValue("BOM");
								categoryCell14.setCellStyle(getCellStyle(workbook, "itemCategory"));
								setBorder(sheet, BorderStyle.THIN, categoryCell4);

								Cell categoryCell15 = category.createCell(15);
								categoryCell15.setCellValue("스크랩(%)");
								categoryCell15.setCellStyle(getCellStyle(workbook, "itemCategory"));
								setBorder(sheet, BorderStyle.THIN, categoryCell15);
							}
						}
					}
					Row row = sheet.createRow(rowNum+2+j);

					if(StringUtil.nvl(calcType).equals("40")){
						//좌측
						sheet.addMergedRegion(new CellRangeAddress(rowNum+2+j, rowNum+2+j, 0, 1));
						sheet.addMergedRegion(new CellRangeAddress(rowNum+2+j, rowNum+2+j, 2, 4));
						sheet.addMergedRegion(new CellRangeAddress(rowNum+2+j, rowNum+2+j, 6, 7));
						//우측
						sheet.addMergedRegion(new CellRangeAddress(rowNum+2+j, rowNum+2+j, 8, 9));
						sheet.addMergedRegion(new CellRangeAddress(rowNum+2+j, rowNum+2+j, 10, 12));
						sheet.addMergedRegion(new CellRangeAddress(rowNum+2+j, rowNum+2+j, 14, 15));
					}else{
						sheet.addMergedRegion(new CellRangeAddress(rowNum+2+j, rowNum+2+j, 0, 3));
						sheet.addMergedRegion(new CellRangeAddress(rowNum+2+j, rowNum+2+j, 8, 11));
					}

					if(StringUtil.nvl(calcType).equals("40")){
						// 점포용 제조공정서
						Cell nameCell0 = row.createCell(0);
						nameCell0.setCellValue(mix.getItem().get(j).getItemCode());
						nameCell0.setCellStyle(getCellStyle(workbook, "default"));
						setBorder(sheet, BorderStyle.THIN, nameCell0);

						Cell nameCell2 = row.createCell(2);
						nameCell2.setCellValue(mix.getItem().get(j).getItemName());
						nameCell2.setCellStyle(getCellStyle(workbook, "default"));
						setBorder(sheet, BorderStyle.THIN, nameCell2);

						Cell nameCell5 = row.createCell(5);
						nameCell5.setCellValue(mix.getItem().get(j).getWeight());
						nameCell5.setCellStyle(getCellStyle(workbook, "default"));
						setBorder(sheet, BorderStyle.THIN, nameCell5);
						try {
							//totalLeftBomAmount += Double.parseDouble(mix.getItem().get(j).getBomAmount());
							// 왼쪽 중량 합계
							totalLeftWeight += Double.parseDouble(mix.getItem().get(j).getWeight());
						} catch ( Exception e ){
							//totalLeftBomAmount += 0;
							totalLeftWeight += 0;
						}
						
						Cell nameCell6 = row.createCell(6);
						nameCell6.setCellValue(mix.getItem().get(j).getIngradient());
						nameCell6.setCellStyle(getCellStyle(workbook, "default"));
						setBorder(sheet, BorderStyle.THIN, nameCell6);
						Cell nameCell8 = row.createCell(8);
						nameCell8.setCellStyle(getCellStyle(workbook, "default"));
						setBorder(sheet, BorderStyle.THIN, nameCell8);
						Cell nameCell10 = row.createCell(10);
						nameCell10.setCellStyle(getCellStyle(workbook, "default"));
						setBorder(sheet, BorderStyle.THIN, nameCell10);
						Cell nameCell13 = row.createCell(13);
						nameCell13.setCellStyle(getCellStyle(workbook, "default"));
						setBorder(sheet, BorderStyle.THIN, nameCell13);
						Cell nameCell14 = row.createCell(14);
						nameCell14.setCellStyle(getCellStyle(workbook, "default"));
						setBorder(sheet, BorderStyle.THIN, nameCell14);
					}else{
						Cell nameCell0 = row.createCell(0);
						if(mix.getItem().get(j).getCoo() != null && !"".equals(mix.getItem().get(j).getCoo())){
							nameCell0.setCellValue(mix.getItem().get(j).getItemName()+" ["+mix.getItem().get(j).getCooName()+"]");
						} else {
							//nameCell0.setCellValue(mix.getItem().get(j).getItemName());
							nameCell0.setCellValue(StringUtil.getHtmlBr(mix.getItem().get(j).getItemName())); 
						}
						nameCell0.setCellStyle(getCellStyle(workbook, "itemName"));
						setBorder(sheet, BorderStyle.THIN, nameCell0);

						Cell nameCell1 = row.createCell(4);
						nameCell1.setCellValue(mix.getItem().get(j).getItemCode());
						nameCell1.setCellStyle(getCellStyle(workbook, "default"));
						setBorder(sheet, BorderStyle.THIN, nameCell1);

						Cell nameCell5 = row.createCell(5);
						if(calcType != null && calcType.equals("7")){
							nameCell5.setCellValue("-");
						} else {
							nameCell5.setCellValue(mix.getItem().get(j).getBomAmount());
						}
						nameCell5.setCellStyle(getCellStyle(workbook, "default"));
						setBorder(sheet, BorderStyle.THIN, nameCell5);
						try {
							totalLeftBomRate += Double.parseDouble(mix.getItem().get(j).getBomAmount());
						} catch ( Exception e ){
							totalLeftBomRate += 0;
						}

						Cell nameCell6 = row.createCell(6);
						nameCell6.setCellValue(mix.getItem().get(j).getBomRate());
						nameCell6.setCellStyle(getCellStyle(workbook, "default"));
						setBorder(sheet, BorderStyle.THIN, nameCell6);
						try {
							if(calcType != null && calcType.equals("7")){
								if(mix.getItem().get(j).getItemCode().startsWith("4") || mix.getItem().get(j).getItemCode().startsWith("5")){
									totalLeftBomAmount += 0;
								} else {
									totalLeftBomAmount += Double.parseDouble(mix.getItem().get(j).getBomRate());
								}
							} else {
								totalLeftBomAmount += Double.parseDouble(mix.getItem().get(j).getBomRate());
							}
						}catch( Exception e ) {
							totalLeftBomRate += 0;
						}

						Cell nameCell7 = row.createCell(7);
						if(calcType != null && calcType.equals("7")){
							nameCell7.setCellValue("-");
						} else {
							nameCell7.setCellValue(mix.getItem().get(j).getScrap());
						}
						nameCell7.setCellStyle(getCellStyle(workbook, "default"));
						setBorder(sheet, BorderStyle.THIN, nameCell7);

						Cell nameCell8 = row.createCell(8);
						nameCell8.setCellStyle(getCellStyle(workbook, "itemName"));
						setBorder(sheet, BorderStyle.THIN, nameCell8);

						Cell nameCell12 = row.createCell(12);
						nameCell12.setCellStyle(getCellStyle(workbook, "default"));
						setBorder(sheet, BorderStyle.THIN, nameCell12);

						Cell nameCell13 = row.createCell(13);
						nameCell13.setCellStyle(getCellStyle(workbook, "default"));
						setBorder(sheet, BorderStyle.THIN, nameCell13);

						Cell nameCell14 = row.createCell(14);
						nameCell14.setCellStyle(getCellStyle(workbook, "default"));
						setBorder(sheet, BorderStyle.THIN, nameCell14);

						Cell nameCell15 = row.createCell(15);
						nameCell15.setCellStyle(getCellStyle(workbook, "default"));
						setBorder(sheet, BorderStyle.THIN, nameCell15);
					}
				}
				tempItemSize =  mix.getItem().size();
			} else {
				for (int j=0; j < mix.getItem().size(); j++) {
					//System.out.println("\t !i%2 rowNum+j: " + (rowNum+j) + ", tempItemSize: " + tempItemSize);
					
					if(j==0){
						// 배합,내용물 제목 열 추가
						Row baseTitle = sheet.getRow(rowNum);
						
						Cell headCell = baseTitle.getCell(8);
						String baseName = "";
						if(type.equals("mix")){
							baseName = "배합비명 : " + mix.getBaseName();
						} else if (type.equals("cont")){
							baseName = "내용물명 : " + mix.getBaseName();
						} else {
							baseName = mix.getBaseName();
						}
						headCell.setCellValue(baseName);
						headCell.setCellStyle(getCellStyle(workbook, type+"Title"));
						setBorder(sheet, BorderStyle.THIN, headCell);
					}
					
					if(j < tempItemSize){
						Row row = sheet.getRow(rowNum+2+j);

						if(StringUtil.nvl(calcType).equals("40")){
							Cell nameCell8 = row.getCell(8);
							nameCell8.setCellValue(mix.getItem().get(j).getItemCode());

							Cell nameCell10 = row.getCell(10);
							nameCell10.setCellValue(mix.getItem().get(j).getItemName());

							Cell nameCell13 = row.getCell(13);
							nameCell13.setCellValue(mix.getItem().get(j).getWeight());	
							try {
								//totalRightBomAmount += Double.parseDouble(mix.getItem().get(j).getBomAmount());
								// 우측
								totalRightWeight += Double.parseDouble(mix.getItem().get(j).getWeight());
							} catch( Exception e ) {
								//totalRightBomAmount += 0;
								// 우측
								totalRightWeight += 0;
							}
							Cell nameCell14 = row.getCell(14);
							nameCell14.setCellValue(mix.getItem().get(j).getIngradient());

							

						}else{
							Cell nameCell = row.getCell(8);
							//nameCell.setCellValue(mix.getItem().get(j).getItemName());
							nameCell.setCellValue(StringUtil.getHtmlBr(mix.getItem().get(j).getItemName()));
							
							Cell nameCell12 = row.getCell(12);
							nameCell12.setCellValue(mix.getItem().get(j).getItemCode());

							Cell nameCell13 = row.getCell(13);
							nameCell13.setCellValue(mix.getItem().get(j).getBomAmount());
							try {
								totalRightBomRate += Double.parseDouble(mix.getItem().get(j).getBomAmount());
							} catch( Exception e ) {
								totalRightBomRate += 0;
							}

							Cell nameCell14 = row.getCell(14);
							nameCell14.setCellValue(mix.getItem().get(j).getBomRate());
							try {
								totalRightBomAmount += Double.parseDouble(mix.getItem().get(j).getBomRate());
							} catch( Exception e ) {
								totalRightBomAmount += 0;
							}

							Cell nameCell15 = row.getCell(15);
							nameCell15.setCellValue(mix.getItem().get(j).getScrap());
						}
					} else {
						Row row = sheet.createRow(rowNum+2+j);

						if(StringUtil.nvl(calcType).equals("40")){
							//좌측
							sheet.addMergedRegion(new CellRangeAddress(rowNum+2+j, rowNum+2+j, 0, 1));
							sheet.addMergedRegion(new CellRangeAddress(rowNum+2+j, rowNum+2+j, 2, 4));
							sheet.addMergedRegion(new CellRangeAddress(rowNum+2+j, rowNum+2+j, 6, 7));
							//우측
							sheet.addMergedRegion(new CellRangeAddress(rowNum+2+j, rowNum+2+j, 8, 9));
							sheet.addMergedRegion(new CellRangeAddress(rowNum+2+j, rowNum+2+j, 10, 12));
							sheet.addMergedRegion(new CellRangeAddress(rowNum+2+j, rowNum+2+j, 14, 15));
						}else{
							sheet.addMergedRegion(new CellRangeAddress(rowNum+2+j, rowNum+2+j, 0, 3));
							sheet.addMergedRegion(new CellRangeAddress(rowNum+2+j, rowNum+2+j, 8, 11));
						}

						if(StringUtil.nvl(calcType).equals("40")){
							Cell nameCell0 = row.createCell(0);
							nameCell0.setCellStyle(getCellStyle(workbook, "itemName"));
							setBorder(sheet, BorderStyle.THIN, nameCell0);

							Cell nameCell2 = row.createCell(2);
							nameCell2.setCellStyle(getCellStyle(workbook, "default"));
							setBorder(sheet, BorderStyle.THIN, nameCell2);

							Cell nameCell5 = row.createCell(5);
							nameCell5.setCellStyle(getCellStyle(workbook, "default"));
							setBorder(sheet, BorderStyle.THIN, nameCell5);

							Cell nameCell6 = row.createCell(6);
							nameCell6.setCellStyle(getCellStyle(workbook, "default"));
							setBorder(sheet, BorderStyle.THIN, nameCell6);

							Cell nameCell8 = row.createCell(8);
							nameCell8.setCellValue(mix.getItem().get(j).getItemCode());
							nameCell8.setCellStyle(getCellStyle(workbook, "default"));
							setBorder(sheet, BorderStyle.THIN, nameCell8);

							Cell nameCell10 = row.createCell(10);
							nameCell10.setCellValue(mix.getItem().get(j).getItemName());
							nameCell10.setCellStyle(getCellStyle(workbook, "default"));
							setBorder(sheet, BorderStyle.THIN, nameCell10);

							Cell nameCell13 = row.createCell(13);
							nameCell13.setCellValue(mix.getItem().get(j).getWeight());
							nameCell13.setCellStyle(getCellStyle(workbook, "default"));
							setBorder(sheet, BorderStyle.THIN, nameCell13);
							try {
								//totalRightBomAmount += Double.parseDouble(mix.getItem().get(j).getBomAmount());
								totalRightWeight += Double.parseDouble(mix.getItem().get(j).getWeight());
							} catch( Exception e ) {
								//totalRightBomAmount += 0;
								totalRightWeight += 0;
							}
							
							Cell nameCell14 = row.createCell(14);
							nameCell10.setCellValue(mix.getItem().get(j).getIngradient());
							nameCell14.setCellStyle(getCellStyle(workbook, "default"));
							setBorder(sheet, BorderStyle.THIN, nameCell14);

						}else{
							Cell nameCell0 = row.createCell(0);
							nameCell0.setCellStyle(getCellStyle(workbook, "itemName"));
							setBorder(sheet, BorderStyle.THIN, nameCell0);

							Cell nameCell1 = row.createCell(4);
							nameCell1.setCellStyle(getCellStyle(workbook, "default"));
							setBorder(sheet, BorderStyle.THIN, nameCell1);

							Cell nameCell5 = row.createCell(5);
							nameCell5.setCellStyle(getCellStyle(workbook, "default"));
							setBorder(sheet, BorderStyle.THIN, nameCell5);

							Cell nameCell6 = row.createCell(6);
							nameCell6.setCellStyle(getCellStyle(workbook, "default"));
							setBorder(sheet, BorderStyle.THIN, nameCell6);

							Cell nameCell7 = row.createCell(7);
							nameCell7.setCellStyle(getCellStyle(workbook, "default"));
							setBorder(sheet, BorderStyle.THIN, nameCell7);

							Cell nameCell8 = row.createCell(8);
							//nameCell8.setCellValue(mix.getItem().get(j).getItemName());
							nameCell8.setCellValue(StringUtil.getHtmlBr(mix.getItem().get(j).getItemName()));
							nameCell8.setCellStyle(getCellStyle(workbook, "itemName"));
							setBorder(sheet, BorderStyle.THIN, nameCell8);

							Cell nameCell12 = row.createCell(12);
							nameCell12.setCellValue(mix.getItem().get(j).getItemCode());
							nameCell12.setCellStyle(getCellStyle(workbook, "default"));
							setBorder(sheet, BorderStyle.THIN, nameCell12);

							Cell nameCell13 = row.createCell(13);
							nameCell13.setCellValue(mix.getItem().get(j).getBomAmount());
							nameCell13.setCellStyle(getCellStyle(workbook, "default"));
							setBorder(sheet, BorderStyle.THIN, nameCell13);
							try {
								totalRightBomRate += Double.parseDouble(mix.getItem().get(j).getBomAmount());
							} catch( Exception e ) {
								totalRightBomRate += 0;
							}

							Cell nameCell14 = row.createCell(14);
							nameCell14.setCellValue(mix.getItem().get(j).getBomRate());
							nameCell14.setCellStyle(getCellStyle(workbook, "default"));
							setBorder(sheet, BorderStyle.THIN, nameCell14);
							try {
								totalRightBomAmount += Double.parseDouble(mix.getItem().get(j).getBomRate());
							} catch( Exception e ) {
								totalRightBomAmount += 0;
							}

							Cell nameCell15 = row.createCell(15);
							nameCell15.setCellValue(mix.getItem().get(j).getScrap());
							nameCell15.setCellStyle(getCellStyle(workbook, "default"));
							setBorder(sheet, BorderStyle.THIN, nameCell15);
						}
						if (j == mix.getItem().size()){
							tempItemSize = mix.getItem().size();
						}
					}
				}
				tempItemSize = tempItemSize > mix.getItem().size() ? tempItemSize : mix.getItem().size();
			}
			
			
			if(base.size()%2 == 1 && base.size() == i+1){
				
			}
			//TODO 3.8 EXCEL 배합비합계
			if(StringUtil.nvl(calcType).equals("40")){			
				if(i%2 == 0){
					if(base.size() == i+1){
						rowNum += tempItemSize+2;
						Row sumRow = sheet.createRow(rowNum);
						//좌측
						sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, 1));
						sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 2, 4));
						sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 6, 7));
						//우측
						sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 8, 9));
						sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 10, 12));
						sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 14, 15));
						
						Cell leftSumCell0 = sumRow.createCell(0);
						leftSumCell0.setCellValue("총 증량");
						leftSumCell0.setCellStyle(getCellStyle(workbook, "itemName"));
						setBorder(sheet, BorderStyle.THIN, leftSumCell0);

						Cell leftSumCell2 = sumRow.createCell(2);
						leftSumCell2.setCellStyle(getCellStyle(workbook, "default"));
						setBorder(sheet, BorderStyle.THIN, leftSumCell2);

						Cell leftSumCell5 = sumRow.createCell(5);
						leftSumCell5.setCellValue(totalLeftWeight);
						leftSumCell5.setCellStyle(getCellStyle(workbook, "default"));
						setBorder(sheet, BorderStyle.THIN, leftSumCell5);
						Cell leftSumCell6 = sumRow.createCell(6);
						leftSumCell6.setCellStyle(getCellStyle(workbook, "default"));
						setBorder(sheet, BorderStyle.THIN, leftSumCell6);

						Cell rightSumCell8 = sumRow.createCell(8);
						rightSumCell8.setCellValue("총 증량");
						rightSumCell8.setCellStyle(getCellStyle(workbook, "itemName"));
						setBorder(sheet, BorderStyle.THIN, rightSumCell8);

						Cell rightSumCell10 = sumRow.createCell(10);	
						rightSumCell10.setCellStyle(getCellStyle(workbook, "default"));
						setBorder(sheet, BorderStyle.THIN, rightSumCell10);

						Cell rightSumCell13 = sumRow.createCell(13);
						rightSumCell13.setCellValue(totalRightWeight);
						rightSumCell13.setCellStyle(getCellStyle(workbook, "default"));
						setBorder(sheet, BorderStyle.THIN, rightSumCell13);
						Cell rightSumCell14 = sumRow.createCell(14);
						rightSumCell14.setCellStyle(getCellStyle(workbook, "default"));
						setBorder(sheet, BorderStyle.THIN, rightSumCell14);

						rowNum += 1;
					}else{
						//tempTotalLeftBomAmount = totalLeftBomAmount;
						tempTotalLeftWeight = totalLeftWeight;
					}
				}
				if(i%2 == 1){
					rowNum += tempItemSize+2;

					Row sumRow = sheet.createRow(rowNum);
					//좌측
					sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, 1));
					sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 2, 4));
					sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 6, 7));
					//우측
					sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 8, 9));
					sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 10, 12));
					sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 14, 15));
					
					Cell leftSumCell0 = sumRow.createCell(0);
					leftSumCell0.setCellValue("총 증량");
					leftSumCell0.setCellStyle(getCellStyle(workbook, "itemName"));
					setBorder(sheet, BorderStyle.THIN, leftSumCell0);

					Cell leftSumCell2 = sumRow.createCell(2);
					leftSumCell2.setCellStyle(getCellStyle(workbook, "default"));
					setBorder(sheet, BorderStyle.THIN, leftSumCell2);

					Cell leftSumCell5 = sumRow.createCell(5);
					leftSumCell5.setCellValue(totalLeftWeight);
					leftSumCell5.setCellStyle(getCellStyle(workbook, "default"));
					setBorder(sheet, BorderStyle.THIN, leftSumCell5);
					Cell leftSumCell6 = sumRow.createCell(6);
					leftSumCell6.setCellStyle(getCellStyle(workbook, "default"));
					setBorder(sheet, BorderStyle.THIN, leftSumCell6);

					Cell rightSumCell8 = sumRow.createCell(8);
					rightSumCell8.setCellValue("총 증량");
					rightSumCell8.setCellStyle(getCellStyle(workbook, "itemName"));
					setBorder(sheet, BorderStyle.THIN, rightSumCell8);

					Cell rightSumCell10 = sumRow.createCell(10);
					rightSumCell10.setCellStyle(getCellStyle(workbook, "default"));
					setBorder(sheet, BorderStyle.THIN, rightSumCell10);

					Cell rightSumCell13 = sumRow.createCell(13);
					rightSumCell13.setCellValue(totalRightWeight);
					rightSumCell13.setCellStyle(getCellStyle(workbook, "default"));
					setBorder(sheet, BorderStyle.THIN, rightSumCell13);
					Cell rightSumCell14 = sumRow.createCell(14);
					rightSumCell14.setCellStyle(getCellStyle(workbook, "default"));
					setBorder(sheet, BorderStyle.THIN, rightSumCell14);

					rowNum += 1;
				}
			}else{
				if(i%2 == 0){
					if(base.size() == i+1){
						rowNum += tempItemSize+2;

						Row sumRow = sheet.createRow(rowNum);
						sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, 4));
						sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 8, 12));
						Cell leftSumCell0 = sumRow.createCell(0);
						leftSumCell0.setCellValue("합계");
						leftSumCell0.setCellStyle(getCellStyle(workbook, "itemName"));
						setBorder(sheet, BorderStyle.THIN, leftSumCell0);

						Cell leftSumCell5 = sumRow.createCell(5);
						if(calcType != null && calcType.equals("7")){
							leftSumCell5.setCellValue("");
						} else {
							leftSumCell5.setCellValue(totalLeftBomRate);
						}
						leftSumCell5.setCellStyle(getCellStyle(workbook, "default"));

						Cell leftSumCell6 = sumRow.createCell(6);
						leftSumCell6.setCellValue(totalLeftBomAmount);
						leftSumCell6.setCellStyle(getCellStyle(workbook, "default"));

						if(calcType != null && calcType.equals("7")){
							Cell rightSumCell0 = sumRow.createCell(8);
							rightSumCell0.setCellValue("");
							rightSumCell0.setCellStyle(getCellStyle(workbook, "itemName"));
							setBorder(sheet, BorderStyle.THIN, rightSumCell0);

							Cell rightSumCell13 = sumRow.createCell(13);
							rightSumCell13.setCellValue("");
							rightSumCell13.setCellStyle(getCellStyle(workbook, "default"));

							Cell rightSumCell14 = sumRow.createCell(14);
							rightSumCell14.setCellValue("");
							rightSumCell14.setCellStyle(getCellStyle(workbook, "default"));
						} else {
							Cell rightSumCell0 = sumRow.createCell(8);
							rightSumCell0.setCellValue("합계");
							rightSumCell0.setCellStyle(getCellStyle(workbook, "itemName"));
							setBorder(sheet, BorderStyle.THIN, rightSumCell0);

							Cell rightSumCell13 = sumRow.createCell(13);
							rightSumCell13.setCellValue(totalRightBomRate);
							rightSumCell13.setCellStyle(getCellStyle(workbook, "default"));

							Cell rightSumCell14 = sumRow.createCell(14);
							rightSumCell14.setCellValue(totalRightBomAmount);
							rightSumCell14.setCellStyle(getCellStyle(workbook, "default"));
						}

						if(i<=1 && type.equals("mix")){
							Row etcRow = sheet.createRow(rowNum+1);
							sheet.addMergedRegion(new CellRangeAddress(rowNum+1, rowNum+1, 0, 4));
							sheet.addMergedRegion(new CellRangeAddress(rowNum+1, rowNum+1, 5, 7));
							sheet.addMergedRegion(new CellRangeAddress(rowNum+1, rowNum+1, 8, 12));
							sheet.addMergedRegion(new CellRangeAddress(rowNum+1, rowNum+1, 13, 15));

							Cell stdAmountCell0 = etcRow.createCell(0);
							stdAmountCell0.setCellValue("기준수량");
							stdAmountCell0.setCellStyle(getCellStyle(workbook, "itemName"));
							setBorder(sheet, BorderStyle.THIN, stdAmountCell0);

							Cell stdAmountCell5 = etcRow.createCell(5);
							stdAmountCell5.setCellValue(sub.getStdAmount());
							stdAmountCell5.setCellStyle(getCellStyle(workbook, "default"));
							setBorder(sheet, BorderStyle.THIN, stdAmountCell5);

							if(calcType != null && calcType.equals("7")){
								Cell divWeightCell8 = etcRow.createCell(8);
								divWeightCell8.setCellValue("");
								divWeightCell8.setCellStyle(getCellStyle(workbook, "itemName"));
								setBorder(sheet, BorderStyle.THIN, divWeightCell8);

								Cell divWeightCell13 = etcRow.createCell(13);
								divWeightCell13.setCellValue("");
								divWeightCell13.setCellStyle(getCellStyle(workbook, "default"));
								setBorder(sheet, BorderStyle.THIN, divWeightCell13);
							} else {
								Cell divWeightCell8 = etcRow.createCell(8);
								divWeightCell8.setCellValue("분할중량");
								divWeightCell8.setCellStyle(getCellStyle(workbook, "itemName"));
								setBorder(sheet, BorderStyle.THIN, divWeightCell8);

								Cell divWeightCell13 = etcRow.createCell(13);
								divWeightCell13.setCellValue(sub.getDivWeight() + " g");
								divWeightCell13.setCellStyle(getCellStyle(workbook, "default"));
								setBorder(sheet, BorderStyle.THIN, divWeightCell13);
							}

							rowNum += 2;
						} else {
							if(type.equals("cont")){
								rowNum += 1;

								Row etcRow = sheet.createRow(rowNum);
								sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, 4));
								sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 5, 7));
								sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 8, 12));
								sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 13, 15));

								Cell stdAmountCell0 = etcRow.createCell(0);
								stdAmountCell0.setCellValue(mix.getBaseName() + "중량(g)");
								stdAmountCell0.setCellStyle(getCellStyle(workbook, "itemName"));
								setBorder(sheet, BorderStyle.THIN, stdAmountCell0);

								Cell stdAmountCell5 = etcRow.createCell(5);
								stdAmountCell5.setCellValue(mix.getDivWeight());
								stdAmountCell5.setCellStyle(getCellStyle(workbook, "default"));
								setBorder(sheet, BorderStyle.THIN, stdAmountCell5);

								Cell divWeightCell8 = etcRow.createCell(8);
								//divWeightCell8.setCellValue(mix.getBaseName() + "중량(g)");
								divWeightCell8.setCellStyle(getCellStyle(workbook, "itemName"));
								setBorder(sheet, BorderStyle.THIN, divWeightCell8);

								Cell divWeightCell13 = etcRow.createCell(13);
								//divWeightCell13.setCellValue(sub.getDivWeight());
								divWeightCell13.setCellStyle(getCellStyle(workbook, "default"));
								setBorder(sheet, BorderStyle.THIN, divWeightCell13);
							}

							rowNum += 1;
						}
					} else {
						tempLeftContName = mix.getBaseName();
						tempLeftContDivWieght = mix.getDivWeight();
						tempTotalLeftBomRate = totalLeftBomRate;
						tempTotalLeftBomAmount = totalLeftBomAmount;
					}
				}
				if(i%2 == 1){
					rowNum += tempItemSize+2;

					Row sumRow = sheet.createRow(rowNum);
					sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, 4));
					sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 8, 12));
					Cell leftSumCell0 = sumRow.createCell(0);
					leftSumCell0.setCellValue("합계");
					leftSumCell0.setCellStyle(getCellStyle(workbook, "itemName"));
					setBorder(sheet, BorderStyle.THIN, leftSumCell0);

					Cell leftSumCell5 = sumRow.createCell(5);
					leftSumCell5.setCellValue(tempTotalLeftBomRate);
					leftSumCell5.setCellStyle(getCellStyle(workbook, "default"));

					Cell leftSumCell6 = sumRow.createCell(6);
					leftSumCell6.setCellValue(tempTotalLeftBomAmount);
					leftSumCell6.setCellStyle(getCellStyle(workbook, "default"));

					if(calcType != null && calcType.equals("7")){
						Cell rightSumCell0 = sumRow.createCell(8);
						rightSumCell0.setCellValue("");
						rightSumCell0.setCellStyle(getCellStyle(workbook, "itemName"));
						setBorder(sheet, BorderStyle.THIN, rightSumCell0);

						Cell rightSumCell13 = sumRow.createCell(13);
						rightSumCell13.setCellValue("");
						rightSumCell13.setCellStyle(getCellStyle(workbook, "default"));

						Cell rightSumCell14 = sumRow.createCell(14);
						rightSumCell14.setCellValue("");
						rightSumCell14.setCellStyle(getCellStyle(workbook, "default"));

					} else {
						Cell rightSumCell0 = sumRow.createCell(8);
						rightSumCell0.setCellValue("합계");
						rightSumCell0.setCellStyle(getCellStyle(workbook, "itemName"));
						setBorder(sheet, BorderStyle.THIN, rightSumCell0);

						Cell rightSumCell13 = sumRow.createCell(13);
						rightSumCell13.setCellValue(totalRightBomRate);
						rightSumCell13.setCellStyle(getCellStyle(workbook, "default"));

						Cell rightSumCell14 = sumRow.createCell(14);
						rightSumCell14.setCellValue(totalRightBomAmount);
						rightSumCell14.setCellStyle(getCellStyle(workbook, "default"));
					}

					if(i<=1 && type.equals("mix")){
						Row etcRow = sheet.createRow(rowNum+1);
						sheet.addMergedRegion(new CellRangeAddress(rowNum+1, rowNum+1, 0, 4));
						sheet.addMergedRegion(new CellRangeAddress(rowNum+1, rowNum+1, 5, 7));
						sheet.addMergedRegion(new CellRangeAddress(rowNum+1, rowNum+1, 8, 12));
						sheet.addMergedRegion(new CellRangeAddress(rowNum+1, rowNum+1, 13, 15));

						Cell stdAmountCell0 = etcRow.createCell(0);
						stdAmountCell0.setCellValue("기준수량");
						stdAmountCell0.setCellStyle(getCellStyle(workbook, "itemName"));
						setBorder(sheet, BorderStyle.THIN, stdAmountCell0);

						Cell stdAmountCell5 = etcRow.createCell(5);
						stdAmountCell5.setCellValue(sub.getStdAmount());
						stdAmountCell5.setCellStyle(getCellStyle(workbook, "default"));
						setBorder(sheet, BorderStyle.THIN, stdAmountCell5);

						Cell divWeightCell8 = etcRow.createCell(8);
						divWeightCell8.setCellValue("분할중량");
						divWeightCell8.setCellStyle(getCellStyle(workbook, "itemName"));
						setBorder(sheet, BorderStyle.THIN, divWeightCell8);

						Cell divWeightCell13 = etcRow.createCell(13);
						divWeightCell13.setCellValue(sub.getDivWeight() + " g");
						divWeightCell13.setCellStyle(getCellStyle(workbook, "default"));
						setBorder(sheet, BorderStyle.THIN, divWeightCell13);

						rowNum += 2;
					} else {
						if(type.equals("cont")){
							rowNum += 1;

							Row etcRow = sheet.createRow(rowNum);
							sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, 4));
							sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 5, 7));
							sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 8, 12));
							sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 13, 15));

							Cell stdAmountCell0 = etcRow.createCell(0);
							stdAmountCell0.setCellValue(tempLeftContName + "중량(g)");
							stdAmountCell0.setCellStyle(getCellStyle(workbook, "itemName"));
							setBorder(sheet, BorderStyle.THIN, stdAmountCell0);

							Cell stdAmountCell5 = etcRow.createCell(5);
							stdAmountCell5.setCellValue(tempLeftContDivWieght);
							stdAmountCell5.setCellStyle(getCellStyle(workbook, "default"));
							setBorder(sheet, BorderStyle.THIN, stdAmountCell5);

							Cell divWeightCell8 = etcRow.createCell(8);
							divWeightCell8.setCellValue(mix.getBaseName() + "중량(g)");
							divWeightCell8.setCellStyle(getCellStyle(workbook, "itemName"));
							setBorder(sheet, BorderStyle.THIN, divWeightCell8);

							Cell divWeightCell13 = etcRow.createCell(13);
							divWeightCell13.setCellValue(mix.getDivWeight());
							divWeightCell13.setCellStyle(getCellStyle(workbook, "default"));
							setBorder(sheet, BorderStyle.THIN, divWeightCell13);
						}

						rowNum += 1;
					}
				}
			}

		}
	}
	
	private void setStoreMethod(List<MfgProcessDocStoreMethod> storeMethod, Workbook workbook, Sheet sheet) throws Exception {
		/* [점포용] 제조방법 */
		int tiStartRow = 0;
		tiStartRow = rowNum;
		
		Row rowStoreMethod = sheet.createRow(rowNum);
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, 15));
		
		Cell cellStoreMethod = rowStoreMethod.createCell(0);
		cellStoreMethod.setCellValue("제조방법");
		cellStoreMethod.setCellStyle(getCellStyle(workbook, "subTitle"));
		setBorder(sheet, BorderStyle.THIN, cellStoreMethod);
		
		rowNum++;
		
		int contStartRow = 0;
		int tempItemSize = 0;
		
		if(storeMethod != null){
			for (int i=0; i < storeMethod.size();  i++) {
				MfgProcessDocStoreMethod storeMethodBase = storeMethod.get(i);
//				System.out.println("setSubProduct Mix rowNum: " + (rowNum) + ", baseName: " + mix.getBaseName());

				String storeMethodExReplace = "";
				storeMethodExReplace = StringUtil.getHtmlBr(storeMethodBase.getMethodExplain()).replaceAll("<BR>", "\n");
				
				int storeMethodExRowCnt = textRowCnt(storeMethodExReplace);

				if(i%2 == 0){//짝수번째
					//header
					contStartRow = rowNum;
					Row rowMethodName = sheet.createRow(rowNum);
					sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, 7));
					sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 8, 15));
					
					Cell titleMethodName0 = rowMethodName.createCell(0);
					titleMethodName0.setCellValue(storeMethodBase.getMethodName());
					titleMethodName0.setCellStyle(getCellStyle(workbook, "subTitle"));
					setBorder(sheet, BorderStyle.THIN, titleMethodName0);
					
					Cell titleMethodName8 = rowMethodName.createCell(8);
					titleMethodName8.setCellValue("");
					titleMethodName8.setCellStyle(getCellStyle(workbook, "subTitle"));
					setBorder(sheet, BorderStyle.THIN, titleMethodName8);
					
					rowNum += 1;
				
					int maxRowCnt = 8;
					if(storeMethodExRowCnt > 10){ // 좌 우의 길이 비교해서 최대row 변경
						maxRowCnt = storeMethodExRowCnt;
					}
					for (int p = 0; p < maxRowCnt; p++) {
						sheet.createRow(rowNum+p);
					}
					
					Row rowMethodEx = sheet.createRow(rowNum);
					sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum+maxRowCnt, 0, 7));
					sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum+maxRowCnt, 8, 15));
					
					Cell titleMethodEx0 = rowMethodEx.createCell(0);
					titleMethodEx0.setCellValue(storeMethodExReplace);
					titleMethodEx0.setCellStyle(getCellStyle(workbook, "text"));
					setBorder(sheet, BorderStyle.THIN, titleMethodEx0);
					Cell titleMethodEx8 = rowMethodEx.createCell(8);
					//titleMethodEx8.setCellValue("");
					titleMethodEx8.setCellStyle(getCellStyle(workbook, "text"));
					setBorder(sheet, BorderStyle.THIN, titleMethodEx8);
					
					rowNum += maxRowCnt;
					rowNum++;
					
				}else{
					Row rowMethodName = sheet.getRow(contStartRow);
					
					Cell titleMethodName8 = rowMethodName.getCell(8);
					titleMethodName8.setCellValue(storeMethodBase.getMethodName());
					
					contStartRow += 1;
					
					int maxRowCnt = 8;
					if(storeMethodExRowCnt > 10){ // 좌 우의 길이 비교해서 최대row 변경
						maxRowCnt = storeMethodExRowCnt;
					}
				
					Row rowMethodEx = sheet.getRow(contStartRow);
					Cell titleMethodEx8 = rowMethodEx.getCell(8);
					titleMethodEx8.setCellValue(storeMethodExReplace);
					
					contStartRow += maxRowCnt;
					contStartRow++;
				}
			}
		}
		
		setBorder(sheet, BorderStyle.THICK, tiStartRow, rowNum, 0, 7);
		setBorder(sheet, BorderStyle.THICK, tiStartRow, rowNum, 8, 15);
	}
	
	private void setMatDisp(Workbook workbook, Sheet sheet, List<MfgProcessDocItem> pkg, List<MfgProcessDocDisp> disp) {
		
		int matDispStartRow = rowNum;
		
		Row baseTitleRow = sheet.createRow(rowNum);
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, 7));
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 8, 15));
		Cell matTitleCell = baseTitleRow.createCell(0);
		matTitleCell.setCellValue("재료");
		matTitleCell.setCellStyle(getCellStyle(workbook, "subTitle"));
		setBorder(sheet, BorderStyle.THIN, matTitleCell);
		Cell dispTitleCell = baseTitleRow.createCell(8);
		dispTitleCell.setCellValue("표시사항 배합비");
		dispTitleCell.setCellStyle(getCellStyle(workbook, "subTitle"));
		setBorder(sheet, BorderStyle.THIN, dispTitleCell);
		
		rowNum++;
		
		Row cateroryRow = sheet.createRow(rowNum);
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, 3));
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 8, 13));
		
		// 재료명
		// 코드번호
		// 재료사양
		// BOM
		// 스크랩%
		Cell categoryCell0 = cateroryRow.createCell(0);
		categoryCell0.setCellValue("재료명");
		categoryCell0.setCellStyle(getCellStyle(workbook, "itemCategory"));
		setBorder(sheet, BorderStyle.THIN, categoryCell0);
		
		Cell categoryCell4 = cateroryRow.createCell(4);
		categoryCell4.setCellValue("코드번호");
		categoryCell4.setCellStyle(getCellStyle(workbook, "itemCategory"));
		setBorder(sheet, BorderStyle.THIN, categoryCell4);
		
		Cell categoryCell5 = cateroryRow.createCell(5);
		categoryCell5.setCellValue("재료사양");
		categoryCell5.setCellStyle(getCellStyle(workbook, "itemCategory"));
		setBorder(sheet, BorderStyle.THIN, categoryCell5);
		
		Cell categoryCell6 = cateroryRow.createCell(6);
		categoryCell6.setCellValue("BOM");
		categoryCell6.setCellStyle(getCellStyle(workbook, "itemCategory"));
		setBorder(sheet, BorderStyle.THIN, categoryCell6);
		
		Cell categoryCell7 = cateroryRow.createCell(7);
		categoryCell7.setCellValue("스크랩(%)");
		categoryCell7.setCellStyle(getCellStyle(workbook, "itemCategory"));
		setBorder(sheet, BorderStyle.THIN, categoryCell7);
		
		// 원료명
		// 백분율
		// 급수포함
		Cell categoryCell8 = cateroryRow.createCell(8);
		categoryCell8.setCellValue("원료명");
		categoryCell8.setCellStyle(getCellStyle(workbook, "itemCategory"));
		setBorder(sheet, BorderStyle.THIN, categoryCell8);
		Cell categoryCell13 = cateroryRow.createCell(14);
		categoryCell13.setCellValue("백분율");
		categoryCell13.setCellStyle(getCellStyle(workbook, "itemCategory"));
		setBorder(sheet, BorderStyle.THIN, categoryCell13);
		Cell categoryCell14 = cateroryRow.createCell(15);
		categoryCell14.setCellValue("급수포함");
		categoryCell14.setCellStyle(getCellStyle(workbook, "itemCategory"));
		setBorder(sheet, BorderStyle.THIN, categoryCell14);
		
		rowNum++;
		
		int matDispRows = pkg.size() > disp.size() ? pkg.size() : disp.size();
		for (int i = 0; i < matDispRows; i++) {
			Row matDispRow = sheet.createRow(rowNum+i);
			sheet.addMergedRegion(new CellRangeAddress(rowNum+i, rowNum+i, 0, 3));
			sheet.addMergedRegion(new CellRangeAddress(rowNum+i, rowNum+i, 8, 13));
			
			Cell cell0 = matDispRow.createCell(0);
			cell0.setCellStyle(getCellStyle(workbook, "itemName"));
			setBorder(sheet, BorderStyle.THIN, cell0);
			
			Cell cell4 = matDispRow.createCell(4);
			cell4.setCellStyle(getCellStyle(workbook, "default"));
			setBorder(sheet, BorderStyle.THIN, cell4);
			
			Cell cell5 = matDispRow.createCell(5);
			cell5.setCellStyle(getCellStyle(workbook, "default"));
			setBorder(sheet, BorderStyle.THIN, cell5);
			
			Cell cell6 = matDispRow.createCell(6);
			cell6.setCellStyle(getCellStyle(workbook, "default"));
			setBorder(sheet, BorderStyle.THIN, cell6);
			
			Cell cell7 = matDispRow.createCell(7);
			cell7.setCellStyle(getCellStyle(workbook, "default"));
			setBorder(sheet, BorderStyle.THIN, cell7);
			
			Cell cell8 = matDispRow.createCell(8);
			cell8.setCellStyle(getCellStyle(workbook, "itemName"));
			setBorder(sheet, BorderStyle.THIN, cell8);
			
			Cell cell14 = matDispRow.createCell(14);
			cell14.setCellStyle(getCellStyle(workbook, "default"));
			setBorder(sheet, BorderStyle.THIN, cell14);
			
			Cell cell15 = matDispRow.createCell(15);
			cell15.setCellStyle(getCellStyle(workbook, "default"));
			setBorder(sheet, BorderStyle.THIN, cell15);
		}
		
		double totalPkg = 0;
		for (int i = 0; i < pkg.size(); i++) {
			Row row = sheet.getRow(rowNum+i);
			Cell nameCell = row.getCell(0);
			nameCell.setCellValue(StringUtil.getHtmlBr(pkg.get(i).getItemName()));
			
			Cell codeCell = row.getCell(4);
			codeCell.setCellValue(pkg.get(i).getItemCode());
			
			Cell dataCell = row.getCell(5);
			String bomAmount = (pkg.get(i).getBomAmount() != null && !"".equals(pkg.get(i).getBomAmount())) ? pkg.get(i).getBomAmount() : "0";
			totalPkg += Double.parseDouble(bomAmount);
			bomAmount += "("+pkg.get(i).getUnit()+")";
			dataCell.setCellValue(bomAmount);
			
			Cell bomCell = row.getCell(6);
			// String bomRate = (pkg.get(i).getBomRate() != null && !"".equals(pkg.get(i).getBomRate())) ? pkg.get(i).getBomRate() : "0";
			// bomCell.setCellValue(bomRate);
			bomCell.setCellValue(pkg.get(i).getBomRate());
			
			Cell scrapCell = row.getCell(7);
			scrapCell.setCellValue(pkg.get(i).getScrap());
		}
		
		double totalExcRate = 0;
		double totalincRate = 0;
		for (int i = 0; i < disp.size(); i++) {
			Row row = sheet.getRow(rowNum+i);
			Cell nameCell = row.getCell(8);
			nameCell.setCellValue(StringUtil.getHtmlBr(disp.get(i).getMatName()));
			
			Cell perCell = row.getCell(14);
			
			//소수점 4자리로 변경
			String excRateStr = disp.get(i).getExcRate();
			String formatExcRate = formatDecimalFour(excRateStr);
			// --------------------------------------------
			perCell.setCellValue(formatExcRate); // disp.get(i).getExcRate()
			if(disp.get(i).getExcRate() != null && !disp.get(i).getExcRate().equals("")){
				totalExcRate += Double.parseDouble(disp.get(i).getExcRate());
			}
			totalExcRate += 0;
			
			Cell waterCell = row.getCell(15);
			//소수점 4자리로 변경
			String incRateStr = disp.get(i).getIncRate();
			String formatIncRate =  formatDecimalFour(incRateStr);	
			// --------------------------------------------
			waterCell.setCellValue(formatIncRate);
			if(disp.get(i).getIncRate() != null && !disp.get(i).getIncRate().equals("")){
				totalincRate += Double.parseDouble(disp.get(i).getIncRate());
			}
			totalincRate += 0;
		}
		
		rowNum += matDispRows;
		
		Row totalRow = sheet.createRow(rowNum);
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, 5));
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 6, 7));
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 8, 13));
		
		Cell matTotalCell0 = totalRow.createCell(0);
		//matTotalCell0.setCellValue("합계");
		matTotalCell0.setCellStyle(getCellStyle(workbook, "itemName"));
		setBorder(sheet, BorderStyle.THIN, matTotalCell0);
		Cell matTotalCell6 = totalRow.createCell(6);
		//matTotalCell6.setCellValue(totalPkg);
		matTotalCell6.setCellStyle(getCellStyle(workbook, "default"));
		setBorder(sheet, BorderStyle.THIN, matTotalCell6);
		
		//합계 값 소수점4로 변경
		String formatTotalIncRate = String.format("%.4f",totalincRate);	// 급수포함
		String formatTotalExcRate = String.format("%.4f",totalExcRate);	// 백분율
		
		Cell dispTotalCell8 = totalRow.createCell(8);
		dispTotalCell8.setCellValue("합계");
		dispTotalCell8.setCellStyle(getCellStyle(workbook, "itemName"));
		setBorder(sheet, BorderStyle.THIN, dispTotalCell8);
		Cell dispTotalCell14 = totalRow.createCell(14);
		dispTotalCell14.setCellValue(formatTotalExcRate);
		dispTotalCell14.setCellStyle(getCellStyle(workbook, "default"));
		setBorder(sheet, BorderStyle.THIN, dispTotalCell14);
		Cell dispTotalCell15 = totalRow.createCell(15);
		dispTotalCell15.setCellValue(formatTotalIncRate);
		dispTotalCell15.setCellStyle(getCellStyle(workbook, "default"));
		setBorder(sheet, BorderStyle.THIN, dispTotalCell15);
		
		rowNum++;
		
		setBorder(sheet, BorderStyle.THICK, matDispStartRow, rowNum-1, 0, 15);
	}

	private String formatDecimalFour(String rateStr) {
		double rateDouble = Double.parseDouble(rateStr);
		String formatRate = String.format("%.4f", rateDouble);
		return formatRate;
	}
	
	private void setTextAndImage(XSSFWorkbook workbook, XSSFSheet sheet, MfgProcessDoc mfgDoc) {
		String menuProcess = StringUtil.getHtmlBr(mfgDoc.getMenuProcess()).replaceAll("<BR>", "\n");
		String standard = StringUtil.getHtmlBr(mfgDoc.getStandard()).replaceAll("<BR>", "\n");
		String docNo = mfgDoc.getDocNo();
		String docVersion = mfgDoc.getDocVersion();
		
		int menuProcessRowCnt = textRowCnt(menuProcess);
		int standardRowCnt = textRowCnt(standard);
		
		int tiStartRow = rowNum;
		
		Row tiTitleRow = sheet.createRow(rowNum);
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, 5));
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 6, 10));
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 11, 15));
		
		Cell menuProcessCell = tiTitleRow.createCell(0);
		menuProcessCell.setCellValue("제조방법");
		menuProcessCell.setCellStyle(getCellStyle(workbook, "subTitle"));
		setBorder(sheet, BorderStyle.THIN, menuProcessCell);
		Cell prodStandardCell = tiTitleRow.createCell(6);
		prodStandardCell.setCellValue("제조규격");
		prodStandardCell.setCellStyle(getCellStyle(workbook, "subTitle"));
		setBorder(sheet, BorderStyle.THIN, prodStandardCell);
		Cell imageCell = tiTitleRow.createCell(11);
		imageCell.setCellValue("제품사진");
		imageCell.setCellStyle(getCellStyle(workbook, "subTitle"));
		setBorder(sheet, BorderStyle.THIN, imageCell);
		
		rowNum++;
		
		int maxRowCnt = 15;
		if(menuProcessRowCnt > 18 || standardRowCnt > 18){
			if(menuProcessRowCnt > standardRowCnt ){
				maxRowCnt = menuProcessRowCnt;
			} else {
				maxRowCnt = standardRowCnt;
			}
		}
		
		for (int i = 0; i < maxRowCnt; i++) {
			sheet.createRow(rowNum+i);
		}
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum+maxRowCnt, 0, 5));
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum+maxRowCnt, 6, 10));
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum+maxRowCnt, 11, 15));
		
		Row tiRow0 = sheet.createRow(rowNum);
		Cell menuProcessDataCell = tiRow0.createCell(0);
		menuProcessDataCell.setCellValue(menuProcess);
		menuProcessDataCell.setCellStyle(getCellStyle(workbook, "text"));
		Cell prodStandardDataCell = tiRow0.createCell(6);
		prodStandardDataCell.setCellValue(standard);
		prodStandardDataCell.setCellStyle(getCellStyle(workbook, "text"));
		Cell imageDataCell = tiRow0.createCell(11);
		
		// drawing
		try {
			
			HashMap<String, Object> param = new HashMap<String, Object>();
			param.put("docNo", docNo);
			param.put("docVersion", docVersion);
			DevDocFileVO devDocImageFile = new DevDocFileVO();
			List<DevDocFileVO> devDocFile = fileService.getDevDocFileList(param);
			
			for (DevDocFileVO devDocFileVO : devDocFile) {
				
				
				if("60".equals(devDocFileVO.getGubun())){
					devDocImageFile = fileService.getDevDocFileInfo(devDocFileVO);
					break;
				}
			}
			
			String imagePath = "";
			
			if(devDocImageFile != null) {
				if("Y".equals(devDocImageFile.getIsOld())){
					imagePath = config.getProperty("old.file.root") + File.separator + "uploadImages" + File.separator + devDocImageFile.getPath() + File.separator + devDocImageFile.getFileName();
				} else {
					imagePath = devDocImageFile.getPath() + File.separator + devDocImageFile.getFileName(); 
				}
			}
			
			File imageFile = new File(imagePath);
			if( imageFile.isFile() ) {
				InputStream inputStream = new FileInputStream(new File(imagePath));
				byte[] bytes = IOUtils.toByteArray(inputStream);
				int pictureIdx = workbook.addPicture(bytes, XSSFWorkbook.PICTURE_TYPE_JPEG);
				
//				XSSFCreationHelper helper = workbook.getCreationHelper();
//				XSSFDrawing drawing = sheet.createDrawingPatriarch();
//				XSSFClientAnchor anchor = helper.createClientAnchor();
//				
//				anchor.setCol1(11);
//				anchor.setRow1(tiRow0.getRowNum());
				
				// 이미지 삽입
				CreationHelper helper = sheet.getWorkbook().getCreationHelper();
				Drawing drawing = sheet.createDrawingPatriarch();
				ClientAnchor anchor = helper.createClientAnchor();
				anchor.setCol1(11);
				anchor.setRow1(tiRow0.getRowNum());
				anchor.setCol2(16);
				anchor.setRow2(tiRow0.getRowNum()+9);
				anchor.setAnchorType(AnchorType.DONT_MOVE_DO_RESIZE);
				drawing.createPicture(anchor, pictureIdx);
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		tiRow0.setHeight((short) -1);
		
		rowNum += maxRowCnt;
		/*
		rowNum ++;
		
		setThickBorder(sheet, tiStartRow, rowNum-1, 0, 5);
		setThickBorder(sheet, tiStartRow, rowNum-1, 6, 10);
		setThickBorder(sheet, tiStartRow, rowNum-1, 11, 15);
		*/

		setBorder(sheet, BorderStyle.THICK, tiStartRow, rowNum, 0, 5);
		setBorder(sheet, BorderStyle.THICK, tiStartRow, rowNum, 6, 10);
		setBorder(sheet, BorderStyle.THICK, tiStartRow, rowNum, 11, 15);
		
	}
	
	private void setForStoreMethodImg(XSSFWorkbook workbook, XSSFSheet sheet, MfgProcessDoc mfgDoc) {
		/* [점포용] 제조공정 순서 이미지 , 설명 */
		
		String docNo = mfgDoc.getDocNo();
		String docVersion = mfgDoc.getDocVersion();
		
		
		Map<Integer, String> mapImgPath = new HashMap<Integer, String>();	// 이미지 경로
		Map<Integer, String> mapImgText = new HashMap<Integer, String>();	// 이미지 설명 텍스트
		
		List<ImageFileForStores> imgFilesList = productDevService.getImageFileForStores(mfgDoc.getDNo()); // 이미지 목록
		
		
		for(int i=0; i<imgFilesList.size(); i++){
			mapImgPath.put(i, imgFilesList.get(i).getPath()+File.separator+imgFilesList.get(i).getFileName());
			mapImgText.put(i, imgFilesList.get(i).getImgDescript());
		}
		

		// **--------------------------------------------------------------- 제조공정 순서 이미지 경로 세팅
		int imgFilesSize = productDevService.getImageFileForStoresCnt(mfgDoc.getDNo()) ;
		int tiStartRow = rowNum;
		

		Row rowTitle = sheet.createRow(rowNum);
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, 11));
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 12, 15));
		
		Cell titleStoreMethodImg = rowTitle.createCell(0);
		titleStoreMethodImg.setCellValue("제조순서");
		titleStoreMethodImg.setCellStyle(getCellStyle(workbook, "subTitle"));
		setBorder(sheet, BorderStyle.THIN, titleStoreMethodImg);
		
		Cell titleStoreMethodmemo = rowTitle.createCell(12);
		titleStoreMethodmemo.setCellValue("완제품 제조시 주의사항");
		titleStoreMethodmemo.setCellStyle(getCellStyle(workbook, "subTitle"));
		setBorder(sheet, BorderStyle.THIN, titleStoreMethodmemo);
		// **--------------------------------------------------------------- 제조공정 순서 이미지 header
		
		
		
		int rowBoxCnt = (imgFilesSize / 4) + (imgFilesSize %4 >0 ? 1: 0); // 이미지 갯수 값을 4개당 1줄씩 표현하기 위한 줄 수(ex:4=1, 6=2)
		int rowHeightCnt = 4; 			//한박스의col 크기
		int memoStartRow = rowNum+1;	// '완제품 주의시항' 시작 row
		
		
		if(rowBoxCnt == 0){ // 이미지가 없을시 임의 칸 생성
			rowNum++;
			Row rowImage1 = sheet.createRow(rowNum); // 이미지를 저장하는 row
			
			sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum+rowHeightCnt, 0, 2));
			sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum+rowHeightCnt, 3, 5));
			sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum+rowHeightCnt, 6, 8));
			sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum+rowHeightCnt, 9, 11));
			
			rowNum+=rowHeightCnt;
			
			
			rowNum++;
			Row rowText = sheet.createRow(rowNum); // 이미지를 저장하는 row
			sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum+4, 0, 2));
			sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum+4, 3, 5));
			sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum+4, 6, 8));
			sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum+4, 9, 11));
			
			rowNum+=4;
		}else{
			// **--------------------------------------------------------------- 제조공정 순서 엑셀 세팅
			for(int i=0; i<rowBoxCnt; i++){
				rowNum++;
				
				Row rowImage1 = sheet.createRow(rowNum); // 이미지를 저장하는 row
				
				sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum+rowHeightCnt, 0, 2));
				sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum+rowHeightCnt, 3, 5));
				sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum+rowHeightCnt, 6, 8));
				sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum+rowHeightCnt, 9, 11));
				
				
				try {
					for(int j=0; j<4; j++){
						int forCnt = i*4+j;
						String checkImgPath = mapImgPath.get(forCnt);
						
						if(checkImgPath != null){
							File imageFile = new File(mapImgPath.get(forCnt));
							
							if( imageFile.isFile() ) {
								InputStream inputStream = new FileInputStream(new File(mapImgPath.get(forCnt)));
								byte[] bytes = IOUtils.toByteArray(inputStream);
								int pictureIdx = workbook.addPicture(bytes, XSSFWorkbook.PICTURE_TYPE_JPEG);
												
								// 이미지 삽입
								CreationHelper helper = sheet.getWorkbook().getCreationHelper();
								Drawing drawing = sheet.createDrawingPatriarch();
								ClientAnchor anchor = helper.createClientAnchor();
								
								anchor.setCol1(3*j);
								anchor.setRow1(rowImage1.getRowNum());
								anchor.setCol2(3*j+3);
								anchor.setRow2(rowImage1.getRowNum()+5);
								anchor.setAnchorType(AnchorType.DONT_MOVE_DO_RESIZE);
								drawing.createPicture(anchor, pictureIdx);
							}
						}
					}
				} catch (Exception e) {
					e.printStackTrace();
					logger.error("제조공정 순서 이미지에서 예외 발생 : {}", e.getMessage(), e);
				}
				
				rowNum+=rowHeightCnt;
				// **--------------------------------------------------------------- 제조공정 순서 이미지 img
				
				
				rowNum++;
				
				Row rowText = sheet.createRow(rowNum); // 이미지를 저장하는 row
				sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum+4, 0, 2));
				sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum+4, 3, 5));
				sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum+4, 6, 8));
				sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum+4, 9, 11));


				try {
					for(int j=0; j<4; j++){
						int forCnt = i*4+j; // 한 줄에 4개씩
						String checkImgText = mapImgText.get(forCnt);
						
						int numCnt = forCnt+1; // 상자 칸 숫자
						Cell cellText = rowText.createCell(j*3);
						if(checkImgText != null){
							cellText.setCellValue("["+numCnt+"] "+StringUtil.getHtmlBr(mapImgText.get(forCnt)).replaceAll("&nbsp;", ""));
							
						}else{
							cellText.setCellValue("["+numCnt+"] ");
						}
						cellText.setCellStyle(getCellStyle(workbook, "text"));
						setBorder(sheet, BorderStyle.THIN, cellText);
					}
				} catch (Exception e) {
					e.printStackTrace();
					logger.error("제조공정 순서 이미지 설명에서 예외 발생 : {}", e.getMessage(), e);
				}
				
				rowNum+=4;
				// **--------------------------------------------------------------- 제조공정 순서 이미지 설명
			}
		}
		
		Row rowMemo = sheet.getRow(memoStartRow);
		sheet.addMergedRegion(new CellRangeAddress(memoStartRow, rowNum, 12, 15));
		
		Cell CellMemo = rowMemo.createCell(12);
		String memoForStore = StringUtil.getHtmlBr(mfgDoc.getMemo()).replaceAll("<BR>", "\n");
		if(memoForStore != null){
			CellMemo.setCellValue(memoForStore);
		}else{
			CellMemo.setCellValue("");
		}
		CellMemo.setCellStyle(getCellStyle(workbook, "text"));
		setBorder(sheet, BorderStyle.THIN, CellMemo);
		// **--------------------------------------------------------------- 완제품시 주의사항 ( 12~15 )

		setBorder(sheet, BorderStyle.THICK, tiStartRow, rowNum, 0, 11);
		setBorder(sheet, BorderStyle.THICK, tiStartRow, rowNum, 12, 15);
	}
	
	
	private void setForStoreProductImg(XSSFWorkbook workbook, XSSFSheet sheet, MfgProcessDoc mfgDoc) {
		/* [점포용] 제품사진 이미지  */
		
		String docNo = mfgDoc.getDocNo();
		String docVersion = mfgDoc.getDocVersion();
		

		int tiStartRow = rowNum;
		
		Row tiTitleRow = sheet.createRow(rowNum);
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, 7));
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 8, 15));
		
		Cell imageCell = tiTitleRow.createCell(0);
		imageCell.setCellValue("제품사진");
		imageCell.setCellStyle(getCellStyle(workbook, "subTitle"));
		setBorder(sheet, BorderStyle.THIN, imageCell);
		
		rowNum++;
		
		int maxRowCnt = 12;
		
		for (int i = 0; i < maxRowCnt; i++) {
			sheet.createRow(rowNum+i);
		}
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum+maxRowCnt, 0, 7));
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum+maxRowCnt, 8, 15));
		
		Row tiRow0 = sheet.createRow(rowNum);
			
		// drawing
		try {
			
			HashMap<String, Object> param = new HashMap<String, Object>();
			param.put("docNo", docNo);
			param.put("docVersion", docVersion);
			DevDocFileVO devDocImageFile = new DevDocFileVO();
			List<DevDocFileVO> devDocFile = fileService.getDevDocFileList(param);
			
			for (DevDocFileVO devDocFileVO : devDocFile) {
				
				if("60".equals(devDocFileVO.getGubun())){
					devDocImageFile = fileService.getDevDocFileInfo(devDocFileVO);
					break;
				}
			}
			
			String imagePath = "";
			
			if(devDocImageFile != null) {
				if("Y".equals(devDocImageFile.getIsOld())){
					imagePath = config.getProperty("old.file.root") + File.separator + "uploadImages" + File.separator + devDocImageFile.getPath() + File.separator + devDocImageFile.getFileName();
				} else {
					imagePath = devDocImageFile.getPath() + File.separator + devDocImageFile.getFileName(); 
				}
			}
			
			File imageFile = new File(imagePath);
			if( imageFile.isFile() ) {
				InputStream inputStream = new FileInputStream(new File(imagePath));
				byte[] bytes = IOUtils.toByteArray(inputStream);
				int pictureIdx = workbook.addPicture(bytes, XSSFWorkbook.PICTURE_TYPE_JPEG);
				
//				XSSFCreationHelper helper = workbook.getCreationHelper();
//				XSSFDrawing drawing = sheet.createDrawingPatriarch();
//				XSSFClientAnchor anchor = helper.createClientAnchor();
//				
//				anchor.setCol1(11);
//				anchor.setRow1(tiRow0.getRowNum());
				
				// 이미지 삽입
				CreationHelper helper = sheet.getWorkbook().getCreationHelper();
				Drawing drawing = sheet.createDrawingPatriarch();
				ClientAnchor anchor = helper.createClientAnchor();
				anchor.setCol1(0);
				anchor.setRow1(tiRow0.getRowNum());
				anchor.setCol2(7);
				anchor.setRow2(tiRow0.getRowNum()+9);
				anchor.setAnchorType(AnchorType.DONT_MOVE_DO_RESIZE);
				drawing.createPicture(anchor, pictureIdx);
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		tiRow0.setHeight((short) -1);
		
		rowNum += maxRowCnt;
		/*
		rowNum ++;
		
		setThickBorder(sheet, tiStartRow, rowNum-1, 0, 5);
		setThickBorder(sheet, tiStartRow, rowNum-1, 6, 10);
		setThickBorder(sheet, tiStartRow, rowNum-1, 11, 15);
		*/

		setBorder(sheet, BorderStyle.THICK, tiStartRow, rowNum, 0, 7);
		setBorder(sheet, BorderStyle.THICK, tiStartRow, rowNum, 8, 15);
		
		rowNum++;
	}
	
	private void setEtcInfo(XSSFWorkbook workbook, XSSFSheet sheet, MfgProcessDoc mfgDoc, ProductDevDocVO devDoc, Map<String, Object> mfgNoData) {
		String calcType = mfgDoc.getCalcType();
		if(calcType.equals("40")){
			int etcStartRow = rowNum+1;
			
			//비고
			Row bego = sheet.createRow(++rowNum);
			sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, 15));
			Cell begoHeader = bego.createCell(0);
			begoHeader.setCellValue("비고");
			begoHeader.setCellStyle(getCellStyle(workbook, "subTitle"));
			setBorder(sheet, BorderStyle.THIN, begoHeader);
			
			
			//완제중량
			//관리중량
			//표기중량
			Row begoRow1 = sheet.createRow(++rowNum);
			sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, 1));
			sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 2, 4));
			sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 5, 6));
			sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 7, 9));
			sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 10, 12));
			sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 13, 15));
			//완제중량
			Cell titleCompWeight = begoRow1.createCell(0);
			titleCompWeight.setCellValue("완제중량");
			titleCompWeight.setCellStyle(getCellStyle(workbook, "subTitle"));
			setBorder(sheet, BorderStyle.THIN, titleCompWeight);
			
			Cell textCompWeight = begoRow1.createCell(2);
			textCompWeight.setCellValue(mfgDoc.getCompWeight());
			textCompWeight.setCellStyle(getCellStyle(workbook, "default"));
			setBorder(sheet, BorderStyle.THIN, textCompWeight);
			//관리중량
			Cell titleAdminWeight = begoRow1.createCell(5);
			titleAdminWeight.setCellValue("관리중량");
			titleAdminWeight.setCellStyle(getCellStyle(workbook, "subTitle"));
			setBorder(sheet, BorderStyle.THIN, titleAdminWeight);
			
			Cell textAdminWeight = begoRow1.createCell(7);
			textAdminWeight.setCellValue(mfgDoc.getAdminWeight());
			textAdminWeight.setCellStyle(getCellStyle(workbook, "default"));
			setBorder(sheet, BorderStyle.THIN, textAdminWeight);
			//표기중량
			Cell titleDispWeight = begoRow1.createCell(10);
			titleDispWeight.setCellValue("표기중량");
			titleDispWeight.setCellStyle(getCellStyle(workbook, "subTitle"));
			setBorder(sheet, BorderStyle.THIN, titleDispWeight);
			
			Cell textDispWeight = begoRow1.createCell(13);
			textDispWeight.setCellValue(mfgDoc.getDispWeight());
			textDispWeight.setCellStyle(getCellStyle(workbook, "default"));
			setBorder(sheet, BorderStyle.THIN,textDispWeight);
			//------------------------------------------------------row1
			
			//용도용법
			//보관조건
			//소비기한
			Row begoRow2 = sheet.createRow(++rowNum);
			sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, 1));
			sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 2, 4));
			sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 5, 6));
			sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 7, 9));
			sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 10, 12));
			sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 13, 15));
			//용도용법
			Cell titleUsage = begoRow2.createCell(0);
			titleUsage.setCellValue("완제중량");
			titleUsage.setCellStyle(getCellStyle(workbook, "subTitle"));
			setBorder(sheet, BorderStyle.THIN, titleUsage);
			
			Cell textUsage = begoRow2.createCell(2);
			textUsage.setCellValue(mfgDoc.getUsage());
			textUsage.setCellStyle(getCellStyle(workbook, "default"));
			setBorder(sheet, BorderStyle.THIN, textUsage);
			//보관조건
			Cell titleKeepCondition = begoRow2.createCell(5);
			titleKeepCondition.setCellValue("보관조건");
			titleKeepCondition.setCellStyle(getCellStyle(workbook, "subTitle"));
			setBorder(sheet, BorderStyle.THIN, titleKeepCondition);
			
			Cell textKeepCondition = begoRow2.createCell(7);
			textKeepCondition.setCellValue(mfgDoc.getKeepCondition());
			textKeepCondition.setCellStyle(getCellStyle(workbook, "default"));
			setBorder(sheet, BorderStyle.THIN, textKeepCondition);
			//소비기한
			Cell titleSellDate = begoRow2.createCell(10);
			titleSellDate.setCellValue("소비기한");
			titleSellDate.setCellStyle(getCellStyle(workbook, "subTitle"));
			setBorder(sheet, BorderStyle.THIN, titleSellDate);
			
			Cell textSellDate = begoRow2.createCell(13);
			textSellDate.setCellValue(mfgDoc.getSellDate());
			textSellDate.setCellStyle(getCellStyle(workbook, "default"));
			setBorder(sheet, BorderStyle.THIN,textSellDate);
			//------------------------------------------------------row2
			
			//제품설명menuProcess(점포용 제조공정서한정)
			Row begoRow3 = sheet.createRow(++rowNum);
			sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, 1));
			sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 2, 15));
			Cell titleMenuProcess = begoRow3.createCell(0);
			titleMenuProcess.setCellValue("제품설명");
			titleMenuProcess.setCellStyle(getCellStyle(workbook, "subTitle"));
			setBorder(sheet, BorderStyle.THIN, titleMenuProcess);
			Cell textMenuProcess = begoRow3.createCell(2);
			textMenuProcess.setCellValue(StringUtil.getHtmlBr(mfgDoc.getMenuProcess()).replaceAll("<BR>", "\n"));
			textMenuProcess.setCellStyle(getCellStyle(workbook, "default"));
			setBorder(sheet, BorderStyle.THIN, textMenuProcess);			
			//------------------------------------------------------row3
			
			//제품규격
			Row begoRow4 = sheet.createRow(++rowNum);
			sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum+9, 0, 1));
			sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum+9, 2, 15));
			Cell titleStandard = begoRow4.createCell(0);
			titleStandard.setCellValue("제품규격");
			titleStandard.setCellStyle(getCellStyle(workbook, "subTitle"));
			setBorder(sheet, BorderStyle.THIN, titleStandard);
			Cell textStandard = begoRow4.createCell(2);
			textStandard.setCellValue(StringUtil.getHtmlBr(mfgDoc.getStandard()).replaceAll("<BR>", "\n").replaceAll("&nbsp;", " "));
			textStandard.setCellStyle(getCellStyle(workbook, "text"));
			setBorder(sheet, BorderStyle.THIN, textStandard);			
			//------------------------------------------------------row4

			/*
			// 23.11.08 이전 점포용제조공정서
			Row tiSellDate = sheet.createRow(++rowNum);
			sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, 1));
			sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 2, 15));
			Cell titleSellDate = tiSellDate.createCell(0);
			titleSellDate.setCellValue("소비기한");
			titleSellDate.setCellStyle(getCellStyle(workbook, "subTitle"));
			setBorder(sheet, BorderStyle.THIN, titleSellDate);
			Cell textCellSellDate = tiSellDate.createCell(2);
			textCellSellDate.setCellValue(mfgDoc.getSellDate());
			textCellSellDate.setCellStyle(getCellStyle(workbook, "default"));
			setBorder(sheet, BorderStyle.THIN, textCellSellDate);
			Row tiqns = sheet.createRow(++rowNum);
			sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, 1));
			sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 2, 15));
			Cell titleQns = tiqns.createCell(0);
			titleQns.setCellValue("QNS 정보");
			titleQns.setCellStyle(getCellStyle(workbook, "subTitle"));
			setBorder(sheet, BorderStyle.THIN, titleQns);
			Cell textCellQns = tiqns.createCell(2);
			textCellQns.setCellValue(mfgDoc.getQns());
			textCellQns.setCellStyle(getCellStyle(workbook, "default"));
			setBorder(sheet, BorderStyle.THIN, textCellQns);
			Row tiMeno = sheet.createRow(++rowNum);
			sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, 1));
			sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 2, 15));
			Cell titleMeno = tiMeno.createCell(0);
			titleMeno.setCellValue("기타설명");
			titleMeno.setCellStyle(getCellStyle(workbook, "subTitle"));
			setBorder(sheet, BorderStyle.THIN, titleMeno);
			Cell textCellMeno = tiMeno.createCell(2);
			textCellMeno.setCellValue(mfgDoc.getMemo());
			textCellMeno.setCellStyle(getCellStyle(workbook, "default"));
			setBorder(sheet, BorderStyle.THIN, textCellMeno);
			*/
			
			setBorder(sheet, BorderStyle.THICK, etcStartRow, rowNum+9, 0, 15);
		}else if(calcType.equals("3") || calcType.equals("7")){
			int etcStartRow = rowNum+1;
			
			Row tiTitleRow = sheet.createRow(++rowNum);
			sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, 9));
			sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 10, 15));
			
			Cell titleCell = tiTitleRow.createCell(0);
			titleCell.setCellValue("관련정보");
			titleCell.setCellStyle(getCellStyle(workbook, "subTitle"));
			Cell titleCell2 = tiTitleRow.createCell(10);
			titleCell2.setCellValue("품목제조보고서 정보");
			titleCell2.setCellStyle(getCellStyle(workbook, "subTitle"));
			
			Row etcRow0 = sheet.createRow(++rowNum);
			String lineName = mfgDoc.getLineName();	
			String bomRate = mfgDoc.getBomRate() + " %";
			String applyName = "";
				if(mfgNoData != null && mfgNoData.get("manufacturingNo") != "" && mfgNoData.get("manufacturingNo") != null){
					applyName = String.valueOf(mfgNoData.get("manufacturingName"));
				}else{
					applyName = mfgDoc.getDocProdName();	
				}			
			mergeEtcRow1(rowNum, sheet);
			setEtcRowValue1("생산라인", lineName, "BOM수율", bomRate, "품목제조보고서명", applyName, etcRow0, workbook);
			
			if(calcType.equals("3")){
				Row etcRow1 = sheet.createRow(++rowNum);
				String weightText = mfgDoc.getMixWeight() +" kg ("+ mfgDoc.getBagAmout() + " 포)";
				String stdAmount = mfgDoc.getTotWeight() + " g";
				String mfgNo = ""; 
					if(mfgNoData != null && mfgNoData.get("manufacturingNo") != "" && mfgNoData.get("manufacturingNo") != null){
						mfgNo = String.valueOf(mfgNoData.get("licensingNo"))+"-"+String.valueOf(mfgNoData.get("manufacturingNo"));
					}else{
						mfgNo = mfgDoc.getRegNum();
					}

				/*if(mfgNo.equals("") || mfgNo.equals(null)){
					Map<String, Object> param = new HashMap<>();
					param.put("tbKey", mfgDoc.getDNo());
					try {
						mfgNo = manufacturingNoService.selectManufacturingNoDataByDocNo(param).get("licensingNo") + "-" + manufacturingNoService.selectManufacturingNoDataByDocNo(param).get("manufacturingNo");
					} catch (Exception e) {
						// TODO: handle exception
					}
				}*/
				mergeEtcRow1(rowNum, sheet);
				setEtcRowValue1("", "", "", "", "품목제조보고번호", mfgNo, etcRow1, workbook);
				//setEtcRowValue1("배합중량", weightText, "분할중량총합계(g)", stdAmount, "품목제조보고번호", mfgNo, etcRow1, workbook);
				
				Row etcRow2 = sheet.createRow(++rowNum);
				String numBong = mfgDoc.getNumBong() + " /ea";
				String ingredient = mfgDoc.getIngredient();
				String categoryText = devDoc.getProductType1Text();
					if(devDoc.getProductType2Text() != null && !"".equals(devDoc.getProductType2Text())){
						categoryText += " > " + devDoc.getProductType2Text();
					}
					if(devDoc.getProductType3Text() != null && !"".equals(devDoc.getProductType3Text())){
						categoryText += " > " + devDoc.getProductType3Text();
					}
					if( (devDoc.getSterilizationText() != null && !"".equals(devDoc.getSterilizationText())) && (devDoc.getEtcDisplayText() != null && !"".equals(devDoc.getEtcDisplayText())) ){
						String sterilizationText = (devDoc.getSterilizationText() != null && !"".equals(devDoc.getSterilizationText())) ? devDoc.getSterilizationText() : "-";
						String etcDisplayText = (devDoc.getEtcDisplayText() != null && !"".equals(devDoc.getEtcDisplayText())) ? devDoc.getEtcDisplayText() : "-";
						categoryText += "( " + sterilizationText + " / " + etcDisplayText + " )";
					}
				mergeEtcRow1(rowNum, sheet);
				setEtcRowValue1("", "", "성상", ingredient, "식품유형", categoryText, etcRow2, workbook);
				//setEtcRowValue1("봉당 들이수", numBong, "성상", ingredient, "식품유형", categoryText, etcRow2, workbook);
				
				Row etcRow3 = sheet.createRow(++rowNum);
				String numBox = mfgDoc.getNumBox();
				String loss = mfgDoc.getLoss() + " %";
				String keepCondition = "";
				if(mfgNoData != null && mfgNoData.get("manufacturingNo") != "" && mfgNoData.get("manufacturingNo") != null){
					if("".equals(String.valueOf(mfgNoData.get("keepConditionText")).trim()) ||  mfgNoData.get("keepConditionText") == null){
						keepCondition = String.valueOf(mfgNoData.get("keepConditionName"));
					}	
					if(!"".equals(String.valueOf(mfgNoData.get("keepConditionText")).trim()) &&  mfgNoData.get("keepConditionText") != null){
						keepCondition = String.valueOf(mfgNoData.get("keepConditionText"));
					}
				}else{
					keepCondition = mfgDoc.getKeepCondition();
				}
				mergeEtcRow1(rowNum, sheet);
				setEtcRowValue1("", "", "", "", "보관조건", keepCondition, etcRow3, workbook);
				//setEtcRowValue1("상자 들이수", numBox, "소성손실(g/%)", loss, "보관조건", keepCondition, etcRow3, workbook);
				
				Row etcRow4 = sheet.createRow(++rowNum);
				String compWeightUnit = (mfgDoc.getCompWeightUnit() != null && !"".equals(mfgDoc.getCompWeightUnit())) ? " "+ mfgDoc.getCompWeightUnit() : "";
				String compWeight = mfgDoc.getCompWeight() + compWeightUnit;
					if(mfgDoc.getCompWeightText() != null && !"".equals(mfgDoc.getCompWeightText().trim())){
						compWeight += "("+mfgDoc.getCompWeightText()+")";
					}
				String distPeriSite = mfgDoc.getDistPeriSite();
				String distPeriDoc = "";
					if(mfgNoData != null && mfgNoData.get("manufacturingNo") != "" && mfgNoData.get("manufacturingNo") != null){
						distPeriDoc = String.valueOf(mfgNoData.get("sellDate1Text"))+" "+String.valueOf(mfgNoData.get("sellDate2"))+" "+String.valueOf(mfgNoData.get("sellDate3Text"));
					}else{
						distPeriDoc = mfgDoc.getDistPeriDoc();
					}
				mergeEtcRow1(rowNum, sheet);
				setEtcRowValue1("완제중량", compWeight, "소비기한(현장)", distPeriSite, "소비기한(등록서류)", distPeriDoc, etcRow4, workbook);
				/*setEtcRowValue1("성상", ingredient, "용도용법", usage, "품목제조보고서명", applyName, etcRow4, workbook);*/
				
				Row etcRow5 = sheet.createRow(++rowNum);
				String adminWeight = mfgDoc.getAdminWeightFrom() + " " + mfgDoc.getAdminWeightUnitFrom();
					adminWeight += " ~ " + mfgDoc.getAdminWeightTo() + " " + mfgDoc.getAdminWeightUnitTo();
				String lineProcessType = mfgDoc.getLineProcessType();
				String usage = mfgDoc.getUsage();
				mergeEtcRow1(rowNum, sheet);
				setEtcRowValue1("관리중량", adminWeight, "제조공정도 유형", lineProcessType, "용도용법", usage, etcRow5, workbook);
				/*setEtcRowValue2("식품유형", categoryText, "품목보고번호", mfgNo, etcRow5, workbook);*/
				
				Row etcRow6 = sheet.createRow(++rowNum);
				String dispWeightUnit = (mfgDoc.getDispWeightUnit() != null && !"".equals(mfgDoc.getDispWeightUnit())) ? " "+ mfgDoc.getDispWeightUnit() : "";
				String dispWeight = mfgDoc.getDispWeight() + dispWeightUnit;
					if(mfgDoc.getDispWeightText() != null && !"".equals(mfgDoc.getDispWeightUnit().trim())){
						dispWeight += "("+mfgDoc.getDispWeightText()+")";
					}
				String mfgDocQns = mfgDoc.getQns();
				String packMaterial = ""; 
					if(mfgNoData != null && mfgNoData.get("manufacturingNo") != "" && mfgNoData.get("manufacturingNo") != null){	
						packMaterial = String.valueOf(mfgNoData.get("packageUnitNames"));
					}else{
						packMaterial = mfgDoc.getPackMaterial();
					}
				mergeEtcRow1(rowNum, sheet);
				setEtcRowValue1("표기중량", dispWeight, "QNS등록번호", mfgDocQns, "포장재질", packMaterial, etcRow6, workbook);
				
				
				rowNum++;
				sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum+1, 0, 1));		// 행병합(ex_ A1~B2)
				sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum+1, 2, 9));
				for(int i=0; i<2; i++){
					sheet.addMergedRegion(new CellRangeAddress(rowNum+i, rowNum+i, 10, 12));	// i개 각 행병합(ex_ C1~P1)
					sheet.addMergedRegion(new CellRangeAddress(rowNum+i, rowNum+i, 13, 15));
				}
				
				Row etcRow7 = sheet.createRow(rowNum);
				String etcText = StringUtil.getHtmlBr(mfgDoc.getNote()).replaceAll("<BR>", "\n");
				if("&nbsp;".equals(etcText)){
					etcText = "";
				}
				String packUnit = mfgDoc.getPackUnit();
				
				Cell etcRow_7_title = etcRow7.createCell(0);
				etcRow_7_title.setCellStyle(getCellStyle(workbook, "subTitle"));
				setBorder(sheet, BorderStyle.THIN, etcRow_7_title);
				etcRow_7_title.setCellValue("비고");
				
				Cell etcRow_7_value = etcRow7.createCell(2);
				etcRow_7_value.setCellStyle(getCellStyle(workbook, "default"));
				setBorder(sheet, BorderStyle.THIN, etcRow_7_value);
				etcRow_7_value.setCellValue(etcText);
				
				Cell etcRow_7_title2 = etcRow7.createCell(10);
				etcRow_7_title2.setCellStyle(getCellStyle(workbook, "subTitle"));
				setBorder(sheet, BorderStyle.THIN, etcRow_7_title2);
				etcRow_7_title2.setCellValue("포장단위");			
				
				Cell etcRow_7_value2 = etcRow7.createCell(13);
				etcRow_7_value2.setCellStyle(getCellStyle(workbook, "default"));
				setBorder(sheet, BorderStyle.THIN, etcRow_7_value2);
				etcRow_7_value2.setCellValue(packUnit);
				
				rowNum++;
				Row etcRow8 = sheet.createRow(rowNum);
				String childHarm = mfgDoc.getChildHarm();
				String chText = "";
				if(childHarm != null && "1".equals(childHarm)) chText = "[●]예   []아니오   []해당 없음";
				else if(childHarm != null && "2".equals(childHarm)) chText = "[]예   [●]아니오   []해당 없음";
				else if(childHarm != null && "3".equals(childHarm)) chText = "[]예   []아니오   [●]해당 없음";
				else chText = "[]예   []아니오   []해당 없음";
				
				Cell etcRow_8_value = etcRow8.createCell(2);
				etcRow_8_value.setCellStyle(getCellStyle(workbook, "default"));
				setBorder(sheet, BorderStyle.THIN, etcRow_8_value);
				
				Cell etcRow_8_title2 = etcRow8.createCell(10);
				etcRow_8_title2.setCellStyle(getCellStyle(workbook, "subTitle"));
				setBorder(sheet, BorderStyle.THIN, etcRow_8_title2);
				etcRow_8_title2.setCellValue("어린이 기호식품 고열량 저열량 해당유무");
				
				Cell etcRow_8_value2 = etcRow8.createCell(13);
				etcRow_8_value2.setCellStyle(getCellStyle(workbook, "default"));
				setBorder(sheet, BorderStyle.THIN, etcRow_8_value2);
				etcRow_8_value2.setCellValue(chText);
				
			}
			setBorder(sheet, BorderStyle.THICK, etcStartRow, rowNum, 0, 15);
			
			Row specRow = sheet.createRow(++rowNum);
			sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, 15));
			Cell specCell = specRow.createCell(0);
			specCell.setCellValue("제품규격(밀다원)");
			specCell.setCellStyle(getCellStyle(workbook, "subTitle"));
			
			MfgProcessDocProdSpecMD specMD = mfgDoc.getSpecMD();
			
			if(specMD == null){
				Row specRow0 = sheet.createRow(++rowNum);
				mergeEtcRow1(rowNum, sheet);
				setEtcRowValue1("Moisture(%)", "", "Ash(%)", "", "Protein(%)", "", specRow0, workbook);
				
				Row specRow1 = sheet.createRow(++rowNum);
				mergeEtcRow1(rowNum, sheet);
				setEtcRowValue1("Water absorption(%)", "", "Stability(%)", "", "Development time(min)", "", specRow1, workbook);
				
				Row specRow2 = sheet.createRow(++rowNum);
				mergeEtcRow1(rowNum, sheet);
				setEtcRowValue1("P/L", "", "Maximum viscosity(BU)", "", "FN(sec)", "", specRow2, workbook);
				
				Row specRow3 = sheet.createRow(++rowNum);
				mergeEtcRow1(rowNum, sheet);
				setEtcRowValue1("Color(Lightness)", "", "Wet gluten(%)", "", "Viscosity(Batter)mm", "", specRow3, workbook);
				
				Row specRow4 = sheet.createRow(++rowNum);
				mergeEtcRow3(rowNum, sheet);
				setEtcRowValue3("Particle size(Average)㎛", "", specRow4, workbook);
			} else {
				Row specRow0 = sheet.createRow(++rowNum);
				String moisture = specMD.getMoisture() == null ? "" : specMD.getMoisture();
				if(specMD.getMoisture() != null && specMD.getMoisture().length() > 0){
					moisture += (specMD.getMoistureUnit() == "gt" ? " ↑" : " ↓");
				}
				String ash = "";
				if(specMD.getAshFrom() != null && specMD.getAshTo() != null){
					ash = specMD.getAshFrom() + " ~ " + specMD.getAshTo();
				}
				String protein = specMD.getProtein() == null ? "" : specMD.getProtein();
				if(specMD.getProtein() != null && !"".equals(specMD.getProtein())){
					protein += (" ± " + specMD.getProteinErr());
				}
				mergeEtcRow1(rowNum, sheet);
				setEtcRowValue1("Moisture(%)", moisture, "Ash(%)", ash, "Protein(%)", protein, specRow0, workbook);
				
				Row specRow1 = sheet.createRow(++rowNum);
				String waterAbs = "";
				if(specMD.getWaterAbsFrom() != null && specMD.getWaterAbsTo() != null){
					waterAbs = specMD.getWaterAbsFrom() + " ~ " + specMD.getWaterAbsTo();
				}
				String stability = "";
				if(specMD.getStabilityFrom() != null && specMD.getStabilityTo() != null){
					stability = specMD.getStabilityFrom() + " ~ " + specMD.getStabilityTo();
				}
				String devTime = specMD.getDevTime() == null ? "" : specMD.getDevTime();
				if(specMD.getDevTimeUnit() != null && specMD.getDevTimeUnit().length() > 0){
					devTime = specMD.getDevTime() + (specMD.getDevTimeUnit() == "gt" ? " ↑" : " ↓");
				}
				mergeEtcRow1(rowNum, sheet);
				setEtcRowValue1("Water absorption(%)", waterAbs, "Stability(%)", stability, "Development time(min)", devTime, specRow1, workbook);
				
				Row specRow2 = sheet.createRow(++rowNum);
				String pl = "";
				if(specMD.getPlFrom() != null && specMD.getPlTo() != null){
					pl = specMD.getPlFrom() + " ~ " + specMD.getPlTo();
				}
				String maxVisc = specMD.getMaxVisc() == null ? "" : specMD.getMaxVisc();
				if(specMD.getMaxVisc() != null && specMD.getMaxVisc().length() > 0){
					maxVisc += (specMD.getMaxVisc() == "gt" ? " ↑" : " ↓");
				}
				String fn = "";
				if(specMD.getFnFrom() != null && specMD.getFnTo() != null){
					fn = specMD.getFnFrom() + " ~ " + specMD.getFnTo();
				}
				mergeEtcRow1(rowNum, sheet);
				setEtcRowValue1("P/L", pl, "Maximum viscosity(BU)", maxVisc, "FN(sec)", fn, specRow2, workbook);
				
				Row specRow3 = sheet.createRow(++rowNum);
				String color = specMD.getColor() == null ? "" : specMD.getColor();
				if(specMD.getColor() != null && specMD.getColor().length() > 0){
					color += (specMD.getColorUnit() == "gt" ? " ↑" : " ↓");
				}
				String webGluten = "";
				if(specMD.getWetGlutenFrom() !=null && specMD.getWetGlutenTo() != null){
					webGluten = specMD.getWetGlutenFrom() + " ~ " + specMD.getWetGlutenTo();
				}
				String visc = specMD.getVisc() == null ? "" : specMD.getVisc();
				if(specMD.getVisc() != null && specMD.getVisc().length() > 0){
					visc += (specMD.getViscUnit() == "gt" ? " ↑" : " ↓");
				}
				mergeEtcRow1(rowNum, sheet);
				setEtcRowValue1("Color(Lightness)", color, "Wet gluten(%)", webGluten, "Viscosity(Batter)mm", visc, specRow3, workbook);
				
				Row specRow4 = sheet.createRow(++rowNum);
				String particleSize = specMD.getParticleSize() == null ? "" : specMD.getParticleSize();;
				mergeEtcRow3(rowNum, sheet);
				setEtcRowValue3("Particle size(Average)㎛", particleSize, specRow4, workbook);
			}
			
			setBorder(sheet, BorderStyle.THICK, etcStartRow, rowNum, 0, 15);
		} else {
			int etcStartRow = rowNum+1;
			
			/* --------------------제품규격 start-----------------------------*/
			Row specRow0 = sheet.createRow(++rowNum);
			sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, 15));
			Cell specCell = specRow0.createCell(0);
			specCell.setCellValue("제품규격");
			specCell.setCellStyle(getCellStyle(workbook, "subTitle"));
			
			MfgProcessDocProdSpec spec = mfgDoc.getSpec(); 
			
			if(spec == null){ // 제품규격이 없을 때 표시
				Row specRow1 = sheet.createRow(++rowNum);	// 1행 ) 전체 , 크기 
				Cell Row1Cell15 = specRow1.createCell(15);
				mergeEtcSpecRow1(rowNum, sheet, Row1Cell15);
				setEtcSpecRowValue1("전체", "크기", "", "±%", specRow1, workbook);  
				
				Row specRow2 = sheet.createRow(++rowNum);	// 2행 ) 성상 , 토핑
				Cell Row2Cell15 = specRow2.createCell(15);
				mergeEtcSpecRow1(rowNum, sheet, Row2Cell15);
				setEtcSpecRowValue1("성상", "토핑,착색,흐름성", "", "", specRow2, workbook);
				

			}else{
				// 1행 ) 전체 , 크기 
				Row specRow1 = sheet.createRow(++rowNum);	
				Cell Row1Cell15 = specRow1.createCell(15);
				String specSize = StringUtil.getHtmlBr(spec.getSize());
				if("&nbsp;".equals(specSize)){
					specSize = "";
				}
				String specSizeErr = "± "+spec.getSizeErr()+ " %";   //"± "+specSizeErr+ " %"
				mergeEtcSpecRow1(rowNum, sheet, Row1Cell15);
				setEtcSpecRowValue1("전체", "크기", specSize, specSizeErr, specRow1, workbook);  
				
				// 2행 ) 성상 , 토핑
				Row specRow2 = sheet.createRow(++rowNum);	
				Cell Row2Cell15 = specRow2.createCell(15);
				String specFeature = spec.getFeature();
				mergeEtcSpecRow1(rowNum, sheet, Row2Cell15);
				setEtcSpecRowValue1("성상", "토핑,착색,흐름성", specFeature, "", specRow2, workbook);
			
				if(spec.isHasProduct() || spec.isHasContent()){
					
					// 3,4,5,6,7,8 행 제품과 내용물
					rowNum++;
					sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum+5, 0, 1));		// 행병합(ex_ A1~B6)
					sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum+5, 7, 9));
					for(int i=0; i<6; i++){
						sheet.addMergedRegion(new CellRangeAddress(rowNum+i, rowNum+i, 2, 4));	// i개 각 행병합(ex_ C1~E1)
						sheet.addMergedRegion(new CellRangeAddress(rowNum+i, rowNum+i, 5, 6));
						sheet.addMergedRegion(new CellRangeAddress(rowNum+i, rowNum+i, 10, 12));
						sheet.addMergedRegion(new CellRangeAddress(rowNum+i, rowNum+i, 13, 14));
					}
					
					Row specRow3 = sheet.createRow(rowNum);	
					Cell Row3Cell0 = specRow3.createCell(0);
					Row3Cell0.setCellValue("전체");
					Row3Cell0.setCellStyle(getCellStyle(workbook, "subTitle"));
					setBorder(sheet, BorderStyle.THIN, Row3Cell0);
					
					Cell Row3Cell7 = specRow3.createCell(7);
					Row3Cell7.setCellValue("내용물");
					Row3Cell7.setCellStyle(getCellStyle(workbook, "subTitle"));
					setBorder(sheet, BorderStyle.THIN, Row3Cell7);
					
					// 3행) 수분
					String specProductWater = spec.getProductWater();	// 전체
					String specContentWater = spec.getContentWater();	// 내용물
					setEtcSpecRowValue2("수분(%)", specProductWater, "수분(%)", specContentWater, specRow3, workbook, sheet);
					
					Cell Row3Cell15 = specRow3.createCell(15);
					Row3Cell15.setCellStyle(getCellStyle(workbook, "default"));
					String specContentWaterErr = "± "+spec.getContentWaterErr();  
					Row3Cell15.setCellValue(specContentWaterErr);
					setBorder(sheet, BorderStyle.THIN, Row3Cell15);
					
					// 4행) Aw
					rowNum++;
					Row specRow4 = sheet.createRow(rowNum);
					
					String specProductAW = spec.getProductAw();		// 전체
					String specContentAW = spec.getContentAw();		// 내용물
					setEtcSpecRowValue2("AW", specProductAW, "AW", specContentAW, specRow4, workbook, sheet);
					
					Cell Row4Cell15 = specRow4.createCell(15);
					Row4Cell15.setCellStyle(getCellStyle(workbook, "default"));
					String specContentAwErr = "± "+spec.getContentAwErr();  
					Row4Cell15.setCellValue(specContentAwErr);
					setBorder(sheet, BorderStyle.THIN, Row4Cell15);
					
					// 5행) pH
					rowNum++;
					Row specRow5 = sheet.createRow(rowNum);
					
					String specProductPh = spec.getProductPh();		//전체
					String specContentPh = spec.getContentPh();		//내용물
					setEtcSpecRowValue2("pH", specProductPh, "pH", specContentPh, specRow5, workbook, sheet);
					
					Cell Row5Cell15 = specRow5.createCell(15);
					Row5Cell15.setCellStyle(getCellStyle(workbook, "default"));
					String specContentPhErr = "± "+spec.getContentPhErr();  
					Row5Cell15.setCellValue(specContentPhErr);
					setBorder(sheet, BorderStyle.THIN, Row5Cell15);
					
					// 6행) 염도
					rowNum++;
					Row specRow6 = sheet.createRow(rowNum);
					
					String specProductSalinity = spec.getProductBrightness(); //전체  // 2308 요청사항- 제품규격 명칭 변경 - 명도 >> 염도
					String specContentSalinity = spec.getContentSalinity();	  //내용물	
					setEtcSpecRowValue2("염도", specProductSalinity, "염도", specContentSalinity, specRow6, workbook, sheet);
					
					Cell Row6Cell15 = specRow6.createCell(15);
					Row6Cell15.setCellStyle(getCellStyle(workbook, "default"));
					String specContentSalinityErr = "± "+spec.getContentSalinityErr();  
					Row6Cell15.setCellValue(specContentSalinityErr);
					setBorder(sheet, BorderStyle.THIN, Row6Cell15);
					
					// 7행) 당도
					rowNum++;
					Row specRow7 = sheet.createRow(rowNum);
					
					String specProductBrix = spec.getProductTone();	//전체	// 2308 요청사항- 제품규격 명칭 변경 - 색도 >> 당도
					String specContentBrix = spec.getContentBrix(); //내용물	
					setEtcSpecRowValue2("당도", specProductBrix, "당도", specContentBrix, specRow7, workbook, sheet);
					
					Cell Row7Cell15 = specRow7.createCell(15);
					Row7Cell15.setCellStyle(getCellStyle(workbook, "default"));
					String specContentBrixErr = "± "+spec.getContentBrixErr();  
					Row7Cell15.setCellValue(specContentBrixErr);
					setBorder(sheet, BorderStyle.THIN, Row7Cell15);
					
					// 8행) 점도 / hardness
					rowNum++;
					Row specRow8 = sheet.createRow(rowNum);	
					
					String specProductHardness = spec.getProductHardness();	//전체	// 2308 요청사항- 제품규격 명칭 변경 - Hardness >> 점도
					String specContentHardness = spec.getContentTone();		//내용물	// 2308 요청사항- 제품규격 명칭 변경 - 색도 >> Hardness
					setEtcSpecRowValue2("점도", specProductHardness, "Hardness", specContentHardness, specRow8, workbook, sheet);
					
					Cell Row8Cell15 = specRow8.createCell(15);
					Row8Cell15.setCellStyle(getCellStyle(workbook, "default"));
					String specContentHardnessErr = "± "+spec.getContentToneErr();  
					Row8Cell15.setCellValue(specContentHardnessErr);
					setBorder(sheet, BorderStyle.THIN, Row8Cell15);
				}
				
				
				if(spec.isHasNoodles()){
					
					// 9행 ) 기타 관리 규격
					Row specRow9 = sheet.createRow(++rowNum);	
					Cell Row9Cell15 = specRow2.createCell(15);
					String specAcidity = StringUtil.getHtmlBr(spec.getNoodlesAcidity());
					mergeEtcSpecRow1(rowNum, sheet, Row9Cell15);
					setEtcSpecRowValue1("전체", "기타 관리규격", specAcidity, "", specRow9, workbook);
					
					
					// 10 , 11 행 국수
					rowNum++;
					sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum+1, 0, 1));		// 행병합(ex_ A1~B2)
					
					for(int i=0; i<2; i++){
						sheet.addMergedRegion(new CellRangeAddress(rowNum+i, rowNum+i, 2, 4));	// i개 각 행병합(ex_ C1~E1)
						sheet.addMergedRegion(new CellRangeAddress(rowNum+i, rowNum+i, 5, 14));
					}
					
					// 10행 ) 국수_수분(%)
					Row specRow10 = sheet.createRow(rowNum);	

					Cell Row10Cell0 = specRow10.createCell(0);
					Row10Cell0.setCellValue("국수(면류)\n 주정침지제품에한함.");
					Row10Cell0.setCellStyle(getCellStyle(workbook, "subTitle"));
					setBorder(sheet, BorderStyle.THIN, Row10Cell0);

					String specNoodlesWater = spec.getNoodlesWater();
					setEtcSpecRowValue3("수분(%)", specNoodlesWater, specRow10, workbook, sheet);
					
					Cell Row10Cell15 = specRow10.createCell(15);
					Row10Cell15.setCellStyle(getCellStyle(workbook, "default"));
					setBorder(sheet, BorderStyle.THIN, Row10Cell15);
					
					
					// 11행 ) 국수_Ph
					rowNum++;
					Row specRow11 = sheet.createRow(rowNum);	
					
					String specNoodlesPh = spec.getNoodlesPh();
					setEtcSpecRowValue3("ph", specNoodlesPh, specRow11, workbook, sheet);
					
					Cell Row11Cell15 = specRow11.createCell(15);
					Row11Cell15.setCellStyle(getCellStyle(workbook, "default"));
					setBorder(sheet, BorderStyle.THIN, Row11Cell15);
				}
				
				// 12행 ) 탈산소재
				if(spec.getDeoxidizer() != "" && spec.getDeoxidizer() != null){
					String specDeoxidier = StringUtil.getHtmlBr(spec.getDeoxidizer());
					if("&nbsp;".equals(specDeoxidier)){
						specDeoxidier = "";
					}
					
					if(specDeoxidier != "" && specDeoxidier != null){
						
						Row specRow12 = sheet.createRow(++rowNum);	
						Cell Row12Cell15 = specRow12.createCell(15);
						mergeEtcSpecRow4(rowNum, sheet, Row12Cell15);
						setEtcSpecRowValue4("탈산소제", specDeoxidier, specRow12, workbook);  
					}
					
				}
				
				// 13행 ) 질소충전제품
				if(spec.getNitrogenous() != "" && spec.getNitrogenous() != null){
					String specNitrogenous = StringUtil.getHtmlBr(spec.getNitrogenous());
					if("&nbsp;".equals(specNitrogenous)){
						specNitrogenous = "";
					}
					
					if(specNitrogenous != "" && specNitrogenous != null){

						Row specRow13 = sheet.createRow(++rowNum);	
						Cell Row13Cell15 = specRow13.createCell(15);
						
						mergeEtcSpecRow4(rowNum, sheet, Row13Cell15);
						setEtcSpecRowValue4("질소충전제품", specNitrogenous, specRow13, workbook); 
					}
				}	
				
			}
			setBorder(sheet, BorderStyle.THICK, etcStartRow, rowNum, 0, 15);
			/* --------------------제품규격 ends-----------------------------*/
			
			Row tiTitleRow = sheet.createRow(++rowNum);
			sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, 9));
			sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 10, 15));

			Cell titleCell = tiTitleRow.createCell(0);
			titleCell.setCellValue("관련정보");
			titleCell.setCellStyle(getCellStyle(workbook, "subTitle"));
			Cell titleCell2 = tiTitleRow.createCell(10);
			titleCell2.setCellValue("품목제조보고서 정보");
			titleCell2.setCellStyle(getCellStyle(workbook, "subTitle"));
			
			Row etcRow0 = sheet.createRow(++rowNum);
			String lineName = mfgDoc.getLineName();	
			String bomRate = mfgDoc.getBomRate() + " %";
			String applyName = "";
				if(mfgNoData != null && mfgNoData.get("manufacturingNo") != "" && mfgNoData.get("manufacturingNo") != null){
					applyName = String.valueOf(mfgNoData.get("manufacturingName"));
				}else{
					applyName = mfgDoc.getDocProdName();	
				}		
			mergeEtcRow1(rowNum, sheet);
			setEtcRowValue1("생산라인", lineName, "BOM수율", bomRate, "품목제조보고서명", applyName, etcRow0, workbook);
			
			Row etcRow1 = sheet.createRow(++rowNum);
			String weightText = mfgDoc.getMixWeight() +" kg ("+ mfgDoc.getBagAmout() + " 포)";
			String stdAmount = mfgDoc.getTotWeight() + " g";
			String mfgNo = ""; 
				if(mfgNoData != null && mfgNoData.get("manufacturingNo") != "" && mfgNoData.get("manufacturingNo") != null){
					mfgNo = String.valueOf(mfgNoData.get("licensingNo"))+"-"+String.valueOf(mfgNoData.get("manufacturingNo"));
				}else{
					mfgNo = mfgDoc.getRegNum();
				}
			/*if(mfgNo.equals("") || mfgNo.equals(null)){
				Map<String, Object> param = new HashMap<>();
				param.put("tbKey", mfgDoc.getDNo());
				try {
					mfgNo = manufacturingNoService.selectManufacturingNoDataByDocNo(param).get("licensingNo") + "-" + manufacturingNoService.selectManufacturingNoDataByDocNo(param).get("manufacturingNo");
				} catch (Exception e) {
					// TODO: handle exception
				}
			}*/
			mergeEtcRow1(rowNum, sheet);
			setEtcRowValue1("배합중량", weightText, "분할중량총합계(g)", stdAmount, "품목제조보고번호", mfgNo, etcRow1, workbook);
			
			Row etcRow2 = sheet.createRow(++rowNum);
			String numBong = mfgDoc.getNumBong() + " /ea";
			String ingredient = mfgDoc.getIngredient();
			String categoryText = devDoc.getProductType1Text();
				if(devDoc.getProductType2Text() != null && !"".equals(devDoc.getProductType2Text())){
					categoryText += " > " + devDoc.getProductType2Text();
				}
				if(devDoc.getProductType3Text() != null && !"".equals(devDoc.getProductType3Text())){
					categoryText += " > " + devDoc.getProductType3Text();
				}
				if( (devDoc.getSterilizationText() != null && !"".equals(devDoc.getSterilizationText())) && (devDoc.getEtcDisplayText() != null && !"".equals(devDoc.getEtcDisplayText())) ){
					String sterilizationText = (devDoc.getSterilizationText() != null && !"".equals(devDoc.getSterilizationText())) ? devDoc.getSterilizationText() : "-";
					String etcDisplayText = (devDoc.getEtcDisplayText() != null && !"".equals(devDoc.getEtcDisplayText())) ? devDoc.getEtcDisplayText() : "-";
					categoryText += "( " + sterilizationText + " / " + etcDisplayText + " )";
				}
			mergeEtcRow1(rowNum, sheet);
			setEtcRowValue1("봉당 들이수", numBong, "성상", ingredient, "식품유형", categoryText, etcRow2, workbook);
			
			Row etcRow3 = sheet.createRow(++rowNum);
			String numBox = mfgDoc.getNumBox();
			String loss = mfgDoc.getLoss() + " %";
			String keepCondition = "";
				if(mfgNoData != null && mfgNoData.get("manufacturingNo") != "" && mfgNoData.get("manufacturingNo") != null){
					if("".equals(String.valueOf(mfgNoData.get("keepConditionText")).trim()) ||  mfgNoData.get("keepConditionText") == null){
						keepCondition = String.valueOf(mfgNoData.get("keepConditionName"));
					}	
					if(!"".equals(String.valueOf(mfgNoData.get("keepConditionText")).trim()) &&  mfgNoData.get("keepConditionText") != null){
						keepCondition = String.valueOf(mfgNoData.get("keepConditionText"));
					}
				}else{
					keepCondition = mfgDoc.getKeepCondition();
				}
			mergeEtcRow1(rowNum, sheet);
			setEtcRowValue1("상자 들이수", numBox, "소성손실(g/%)", loss, "보관조건", keepCondition, etcRow3, workbook);
			
			Row etcRow4 = sheet.createRow(++rowNum);
			String compWeightUnit = (mfgDoc.getCompWeightUnit() != null && !"".equals(mfgDoc.getCompWeightUnit())) ? " "+ mfgDoc.getCompWeightUnit() : "";
			String compWeight = mfgDoc.getCompWeight() + compWeightUnit;
				if(mfgDoc.getCompWeightText() != null && !"".equals(mfgDoc.getCompWeightText().trim())){
					compWeight += "("+mfgDoc.getCompWeightText()+")";
				}
			String distPeriSite = mfgDoc.getDistPeriSite();
			String distPeriDoc = "";
				if(mfgNoData != null && mfgNoData.get("manufacturingNo") != "" && mfgNoData.get("manufacturingNo") != null){
					distPeriDoc = String.valueOf(mfgNoData.get("sellDate1Text"))+" "+String.valueOf(mfgNoData.get("sellDate2"))+" "+String.valueOf(mfgNoData.get("sellDate3Text"));
				}else{
					distPeriDoc = mfgDoc.getDistPeriDoc();
				}
			mergeEtcRow1(rowNum, sheet);
			setEtcRowValue1("완제중량", compWeight, "소비기한(현장)", distPeriSite, "소비기한(등록서류)", distPeriDoc, etcRow4, workbook);
			/*setEtcRowValue1("성상", ingredient, "용도용법", usage, "품목제조보고서명", applyName, etcRow4, workbook);*/
			
			Row etcRow5 = sheet.createRow(++rowNum);
			String adminWeight = mfgDoc.getAdminWeightFrom() + " " + mfgDoc.getAdminWeightUnitFrom();
				adminWeight += " ~ " + mfgDoc.getAdminWeightTo() + " " + mfgDoc.getAdminWeightUnitTo();
			String lineProcessType = mfgDoc.getLineProcessType();
			String usage = mfgDoc.getUsage();
			mergeEtcRow1(rowNum, sheet);
			setEtcRowValue1("관리중량", adminWeight, "제조공정도 유형", lineProcessType, "용도용법", usage, etcRow5, workbook);
			/*setEtcRowValue2("식품유형", categoryText, "품목보고번호", mfgNo, etcRow5, workbook);*/
			
			Row etcRow6 = sheet.createRow(++rowNum);
			String dispWeightUnit = (mfgDoc.getDispWeightUnit() != null && !"".equals(mfgDoc.getDispWeightUnit())) ? " "+ mfgDoc.getDispWeightUnit() : "";
			String dispWeight = mfgDoc.getDispWeight() + dispWeightUnit;
				if(mfgDoc.getDispWeightText() != null && !"".equals(mfgDoc.getDispWeightText().trim())){
					dispWeight += "("+mfgDoc.getDispWeightText()+")";
				}
			String mfgDocQns = mfgDoc.getQns();
			String packMaterial = ""; 
				if(mfgNoData != null && mfgNoData.get("manufacturingNo") != "" && mfgNoData.get("manufacturingNo") != null){	
					packMaterial = String.valueOf(mfgNoData.get("packageUnitNames"));
				}else{
					packMaterial = mfgDoc.getPackMaterial();
				}	
			mergeEtcRow1(rowNum, sheet);
			setEtcRowValue1("표기중량", dispWeight, "QNS등록번호", mfgDocQns, "포장재질", packMaterial, etcRow6, workbook);
			
			
			rowNum++;
			sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum+1, 0, 1));		// 행병합(ex_ A1~B2)
			sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum+1, 2, 9));
			for(int i=0; i<2; i++){
				sheet.addMergedRegion(new CellRangeAddress(rowNum+i, rowNum+i, 10, 12));	// i개 각 행병합(ex_ C1~P1)
				sheet.addMergedRegion(new CellRangeAddress(rowNum+i, rowNum+i, 13, 15));
			}
			
			Row etcRow7 = sheet.createRow(rowNum);
			String etcText = StringUtil.getHtmlBr(mfgDoc.getNote()).replaceAll("<BR>", "\n");
			if("&nbsp;".equals(etcText)){
				etcText = "";
			}
			String packUnit = mfgDoc.getPackUnit();
			
			Cell etcRow_7_title = etcRow7.createCell(0);
			etcRow_7_title.setCellStyle(getCellStyle(workbook, "subTitle"));
			setBorder(sheet, BorderStyle.THIN, etcRow_7_title);
			etcRow_7_title.setCellValue("비고");
			
			Cell etcRow_7_value = etcRow7.createCell(2);
			etcRow_7_value.setCellStyle(getCellStyle(workbook, "default"));
			setBorder(sheet, BorderStyle.THIN, etcRow_7_value);
			etcRow_7_value.setCellValue(etcText);
			
			Cell etcRow_7_title2 = etcRow7.createCell(10);
			etcRow_7_title2.setCellStyle(getCellStyle(workbook, "subTitle"));
			setBorder(sheet, BorderStyle.THIN, etcRow_7_title2);
			etcRow_7_title2.setCellValue("포장단위");			
			
			Cell etcRow_7_value2 = etcRow7.createCell(13);
			etcRow_7_value2.setCellStyle(getCellStyle(workbook, "default"));
			setBorder(sheet, BorderStyle.THIN, etcRow_7_value2);
			etcRow_7_value2.setCellValue(packUnit);
			
			rowNum++;
			Row etcRow8 = sheet.createRow(rowNum);
			String childHarm = mfgDoc.getChildHarm();
			String chText = "";
			if(childHarm != null && "1".equals(childHarm)) chText = "[●]예   []아니오   []해당 없음";
			else if(childHarm != null && "2".equals(childHarm)) chText = "[]예   [●]아니오   []해당 없음";
			else if(childHarm != null && "3".equals(childHarm)) chText = "[]예   []아니오   [●]해당 없음";
			else chText = "[]예   []아니오   []해당 없음";
			
			Cell etcRow_8_value = etcRow8.createCell(2);
			etcRow_8_value.setCellStyle(getCellStyle(workbook, "default"));
			setBorder(sheet, BorderStyle.THIN, etcRow_8_value);
			
			Cell etcRow_8_title2 = etcRow8.createCell(10);
			etcRow_8_title2.setCellStyle(getCellStyle(workbook, "subTitle"));
			setBorder(sheet, BorderStyle.THIN, etcRow_8_title2);
			etcRow_8_title2.setCellValue("어린이 기호식품 고열량 저열량 해당유무");
			
			Cell etcRow_8_value2 = etcRow8.createCell(13);
			etcRow_8_value2.setCellStyle(getCellStyle(workbook, "default"));
			setBorder(sheet, BorderStyle.THIN, etcRow_8_value2);
			etcRow_8_value2.setCellValue(chText);

			setBorder(sheet, BorderStyle.THICK, etcStartRow, rowNum, 0, 15);
		}
	}
	
	
	
	private void mergeEtcRow1(int rowNum, Sheet sheet){
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, 1));
		setBorder(sheet, BorderStyle.THIN, rowNum, rowNum, 0, 1);
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 2, 4));
		setBorder(sheet, BorderStyle.THIN, rowNum, rowNum, 2, 4);
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 5, 6));
		setBorder(sheet, BorderStyle.THIN, rowNum, rowNum, 5, 6);
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 7, 9));
		setBorder(sheet, BorderStyle.THIN, rowNum, rowNum, 7, 9);
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 10, 12));
		setBorder(sheet, BorderStyle.THIN, rowNum, rowNum, 10, 12);
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 13, 15));
		setBorder(sheet, BorderStyle.THIN, rowNum, rowNum, 13, 15);
	}
	
	private void setEtcRowValue1(String title1, String value1, String title2, String value2, String title3, String value3, Row row, Workbook workbook){
		Cell title_1_title = row.createCell(0);
		Cell title_1_value = row.createCell(2);
		Cell title_2_title = row.createCell(5);
		Cell title_2_value = row.createCell(7);
		Cell title_3_title = row.createCell(10);
		Cell title_3_value = row.createCell(13);
		
		title_1_title.setCellValue(title1);
		title_1_value.setCellValue(value1);
		title_2_title.setCellValue(title2);
		title_2_value.setCellValue(value2);
		title_3_title.setCellValue(title3);
		title_3_value.setCellValue(value3);
		
		title_1_title.setCellStyle(getCellStyle(workbook, "subTitle"));
		title_1_value.setCellStyle(getCellStyle(workbook, "default"));
		title_2_title.setCellStyle(getCellStyle(workbook, "subTitle"));
		title_2_value.setCellStyle(getCellStyle(workbook, "default"));
		title_3_title.setCellStyle(getCellStyle(workbook, "subTitle"));
		title_3_value.setCellStyle(getCellStyle(workbook, "default"));
	}
	
	private void mergeEtcRow2(int rowNum, Sheet sheet){
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, 1));
		setBorder(sheet, BorderStyle.THIN, rowNum, rowNum, 0, 1);
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 2, 9));
		setBorder(sheet, BorderStyle.THIN, rowNum, rowNum, 2, 9);
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 10, 12));
		setBorder(sheet, BorderStyle.THIN, rowNum, rowNum, 10, 12);
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 13, 15));
		setBorder(sheet, BorderStyle.THIN, rowNum, rowNum, 13, 15);
	}
	
	private void setEtcRowValue2(String title1, String value1, String title2, String value2, Row row, Workbook workbook){
		Cell title_1_title = row.createCell(0);
		Cell title_1_value = row.createCell(2);
		Cell title_2_title = row.createCell(10);
		Cell title_2_value = row.createCell(13);
		
		title_1_title.setCellValue(title1);
		title_1_value.setCellValue(value1);
		title_2_title.setCellValue(title2);
		title_2_value.setCellValue(value2);
		
		title_1_title.setCellStyle(getCellStyle(workbook, "subTitle"));
		title_1_value.setCellStyle(getCellStyle(workbook, "default"));
		title_2_title.setCellStyle(getCellStyle(workbook, "subTitle"));
		title_2_value.setCellStyle(getCellStyle(workbook, "default"));
	}
	
	private void mergeEtcRow3(int rowNum, Sheet sheet){
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, 1));
		setBorder(sheet, BorderStyle.THIN, rowNum, rowNum, 0, 1);
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 2, 4));
		setBorder(sheet, BorderStyle.THIN, rowNum, rowNum, 2, 4);
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 5, 15));
		setBorder(sheet, BorderStyle.THIN, rowNum, rowNum, 5, 15);
	}
	
	private void setEtcRowValue3(String title1, String value1, Row row, Workbook workbook){
		Cell title_1_title = row.createCell(0);
		Cell title_1_value = row.createCell(2);
		Cell title_2_title = row.createCell(4);
		
		title_1_title.setCellValue(title1);
		title_1_value.setCellValue(value1);
		title_2_title.setCellValue("");
		
		title_1_title.setCellStyle(getCellStyle(workbook, "subTitle"));
		title_1_value.setCellStyle(getCellStyle(workbook, "default"));
		title_2_title.setCellStyle(getCellStyle(workbook, "default"));
	}
	
	/* 제품규격 - 크기, 토핑 template*/
	private void mergeEtcSpecRow1(int rowNum, Sheet sheet, Cell cell15){
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, 1));
		setBorder(sheet, BorderStyle.THIN, rowNum, rowNum, 0, 1);
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 2, 4));
		setBorder(sheet, BorderStyle.THIN, rowNum, rowNum, 2, 4);
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 5, 14));
		setBorder(sheet, BorderStyle.THIN, rowNum, rowNum, 5, 14);
		setBorder(sheet, BorderStyle.THIN, cell15);
	}
	
	private void setEtcSpecRowValue1(String title1, String title2, String value1, String value2, Row row, Workbook workbook){
		Cell specCell0_title1 = row.createCell(0); 
		Cell specCell2_title2 = row.createCell(2); 
		Cell specCell5_value1 = row.createCell(5); 
		Cell specCell15_value2 = row.createCell(15); 
		
		specCell0_title1.setCellValue(title1);
		specCell2_title2.setCellValue(title2);
		specCell5_value1.setCellValue(value1);
		specCell15_value2.setCellValue(value2);
		
		specCell0_title1.setCellStyle(getCellStyle(workbook, "subTitle"));
		specCell2_title2.setCellStyle(getCellStyle(workbook, "default"));
		specCell5_value1.setCellStyle(getCellStyle(workbook, "default"));
		specCell15_value2.setCellStyle(getCellStyle(workbook, "default"));
	}
	
	/* 제품규격 - 제품/내용물 */
	private void setEtcSpecRowValue2(String title2, String value1, String title3,String value2, Row row, Workbook workbook, Sheet sheet){// 2,5,10,13
		Cell specCell2_title2 = row.createCell(2); 
		Cell specCell5_value1 = row.createCell(5);
		Cell specCell10_title3 = row.createCell(10); 
		Cell specCell13_value2 = row.createCell(13); 
	
		specCell2_title2.setCellValue(title2);
		specCell5_value1.setCellValue(value1);
		specCell10_title3.setCellValue(title3);
		specCell13_value2.setCellValue(value2);
		
		specCell2_title2.setCellStyle(getCellStyle(workbook, "default"));
		specCell5_value1.setCellStyle(getCellStyle(workbook, "default"));
		specCell10_title3.setCellStyle(getCellStyle(workbook, "default"));
		specCell13_value2.setCellStyle(getCellStyle(workbook, "default"));
		
		setBorder(sheet, BorderStyle.THIN, specCell2_title2);
		setBorder(sheet, BorderStyle.THIN, specCell5_value1);
		setBorder(sheet, BorderStyle.THIN, specCell10_title3);
		setBorder(sheet, BorderStyle.THIN, specCell13_value2);
	}
	
	/* 제품규격 - 국수  */
	private void setEtcSpecRowValue3(String title2, String value1, Row row, Workbook workbook, Sheet sheet){
		Cell specCell2_title2 = row.createCell(2); 
		Cell specCell5_value1 = row.createCell(5); 
	
		specCell2_title2.setCellValue(title2);
		specCell5_value1.setCellValue(value1);
		
		specCell2_title2.setCellStyle(getCellStyle(workbook, "default"));
		specCell5_value1.setCellStyle(getCellStyle(workbook, "default"));
		
		setBorder(sheet, BorderStyle.THIN, specCell2_title2);
		setBorder(sheet, BorderStyle.THIN, specCell5_value1);
	}
	
	
	/* 제품규격 - 탈산소제 , 질소충전제품 template */
	private void mergeEtcSpecRow4(int rowNum, Sheet sheet, Cell cell15){
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, 4));
		setBorder(sheet, BorderStyle.THIN, rowNum, rowNum, 0, 4);
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 5, 14));
		setBorder(sheet, BorderStyle.THIN, rowNum, rowNum, 5, 14);
		setBorder(sheet, BorderStyle.THIN, cell15);
	}
	
	private void setEtcSpecRowValue4(String title1, String value1, Row row, Workbook workbook){
		Cell specCell0_title1 = row.createCell(0); 
		Cell specCell5_value1 = row.createCell(5); 
		Cell specCell15_value2 = row.createCell(15); 
		
		specCell0_title1.setCellValue(title1);
		specCell5_value1.setCellValue(value1);
		
		
		specCell0_title1.setCellStyle(getCellStyle(workbook, "subTitle"));
		specCell5_value1.setCellStyle(getCellStyle(workbook, "default"));
		specCell15_value2.setCellStyle(getCellStyle(workbook, "default"));
	}

	/*제품규격 용 end */

	
	// Font 4개, CellStyle 8개
	private Font getFont(Workbook workbook, String type){
		Font font = workbook.createFont();
		
		if(type.equals("mg9")){
			font.setFontName("맑은 고딕");
			font.setFontHeightInPoints((short) 9);
			font.setBold(false);
			font.setColor(IndexedColors.BLACK.getIndex());
		}
		
		if(type.equals("mg9white")){
			font.setFontName("맑은 고딕");
			font.setFontHeightInPoints((short) 9);
			font.setBold(false);
			font.setColor(IndexedColors.WHITE.getIndex());
		}
		
		if(type.equals("mg9bold")){
			font.setFontName("맑은 고딕");
			font.setFontHeightInPoints((short) 9);
			font.setBold(true);
			font.setColor(IndexedColors.BLACK.getIndex());
		}
		
		if(type.equals("mg16")){
			font.setFontName("맑은 고딕");
			font.setFontHeightInPoints((short) 16);
			font.setBold(false);
			font.setColor(IndexedColors.BLACK.getIndex());
		}
		
		return font;
	}
	
	private CellStyle getCellStyle(Workbook workbook, String type){
		//CellStyle cellStyle = workbook.createCellStyle();
		CellStyle cellStyle = workbook.createCellStyle();
		
		cellStyle.setBorderTop(BorderStyle.THIN);
		cellStyle.setTopBorderColor(IndexedColors.BLACK.getIndex());
		cellStyle.setBorderBottom(BorderStyle.THIN);
		cellStyle.setBottomBorderColor(IndexedColors.BLACK.getIndex());
		cellStyle.setBorderLeft(BorderStyle.THIN);
		cellStyle.setLeftBorderColor(IndexedColors.BLACK.getIndex());
		cellStyle.setBorderRight(BorderStyle.THIN);
		cellStyle.setRightBorderColor(IndexedColors.BLACK.getIndex());
		
		if(type.equals("default")){
			
			cellStyle.setAlignment(HorizontalAlignment.CENTER);
			cellStyle.setVerticalAlignment(VerticalAlignment.CENTER);
			cellStyle.setFillForegroundColor(IndexedColors.WHITE.index);
			cellStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
			cellStyle.setFont(getFont(workbook, "mg9"));
			cellStyle.setWrapText(true);
		}
		
		if(type.equals("title")){
			cellStyle.setAlignment(HorizontalAlignment.CENTER);
			cellStyle.setVerticalAlignment(VerticalAlignment.CENTER);
			cellStyle.setFillForegroundColor(IndexedColors.WHITE.index);
			cellStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
			cellStyle.setFont(getFont(workbook, "mg16"));
		}
		
		if(type.equals("subTitle")){
			cellStyle.setAlignment(HorizontalAlignment.CENTER);
			cellStyle.setVerticalAlignment(VerticalAlignment.CENTER);
			cellStyle.setFillForegroundColor(IndexedColors.LIGHT_CORNFLOWER_BLUE.index);
			cellStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
			cellStyle.setFont(getFont(workbook, "mg9"));
		}
		
		if(type.equals("mixTitle")){
			cellStyle.setAlignment(HorizontalAlignment.CENTER);
			cellStyle.setVerticalAlignment(VerticalAlignment.CENTER);
			cellStyle.setFillForegroundColor(IndexedColors.BLUE_GREY.index);
			cellStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
			cellStyle.setFont(getFont(workbook, "mg9white"));
		}
		
		if(type.equals("contTitle")){
			cellStyle.setAlignment(HorizontalAlignment.CENTER);
			cellStyle.setVerticalAlignment(VerticalAlignment.CENTER);
			cellStyle.setFillForegroundColor(IndexedColors.LIGHT_ORANGE.index);
			cellStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
			cellStyle.setFont(getFont(workbook, "mg9white"));
		}
		
		if(type.equals("itemCategory")){
			cellStyle.setAlignment(HorizontalAlignment.CENTER);
			cellStyle.setVerticalAlignment(VerticalAlignment.CENTER);
			cellStyle.setFillForegroundColor(IndexedColors.WHITE.index);
			cellStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
			cellStyle.setFont(getFont(workbook, "mg9bold"));
		}
		
		if(type.equals("itemName")){
			cellStyle.setAlignment(HorizontalAlignment.LEFT);
			cellStyle.setVerticalAlignment(VerticalAlignment.CENTER);
			cellStyle.setFillForegroundColor(IndexedColors.LIGHT_TURQUOISE.index);
			cellStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
			cellStyle.setFont(getFont(workbook, "mg9"));
		}
		
		if(type.equals("text")){
			cellStyle.setAlignment(HorizontalAlignment.LEFT);
			cellStyle.setVerticalAlignment(VerticalAlignment.TOP);
			cellStyle.setFillForegroundColor(IndexedColors.WHITE.index);
			cellStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
			cellStyle.setWrapText(true);
			cellStyle.setFont(getFont(workbook, "mg9"));
		}
		
		return cellStyle;
	}
	
	private void setDefaultMerge(Sheet sheet, int firstRow, int lastRow, int firstCol, int lastCol){
		sheet.addMergedRegion(new CellRangeAddress(firstRow, lastRow, firstCol, lastCol));
		setBorder(sheet, BorderStyle.THIN, firstRow, lastRow, firstCol, lastCol);
	}
	
	private void setBorder(Sheet sheet, BorderStyle border, Cell cell){
		List<CellRangeAddress> rangeList = sheet.getMergedRegions();
		
		int rowIndex = cell.getRowIndex();
		int columnIndex = cell.getColumnIndex();
		
		int firstRow = 0;
		int lastRow = 0;
		int firstCol = 0;
		int lastCol = 0;
		
		for (CellRangeAddress cellRangeAddress : rangeList) {
			if(firstRow == 0 && cellRangeAddress.getFirstRow() == rowIndex){
				firstRow = cellRangeAddress.getFirstRow();
				lastRow = cellRangeAddress.getLastRow();
			}
			
			if(firstRow == cellRangeAddress.getFirstRow() && columnIndex == cellRangeAddress.getFirstColumn()){
				firstCol = cellRangeAddress.getFirstColumn();
				lastCol = cellRangeAddress.getLastColumn();
			}
		}
		
		//System.out.println("range result : " + firstRow + ", " + lastRow + ", "+ firstCol + ", " + lastCol);
		setBorder(sheet, border, firstRow, lastRow, firstCol, lastCol);
	}
	
	private void setBorder(Sheet sheet, BorderStyle border, int firstRow, int lastRow, int firstCol, int lastCol){
		RegionUtil.setBorderLeft(border, new CellRangeAddress(firstRow, lastRow, firstCol, lastCol), sheet);
		RegionUtil.setBorderRight(border, new CellRangeAddress(firstRow, lastRow, firstCol, lastCol), sheet);
		RegionUtil.setBorderTop(border, new CellRangeAddress(firstRow, lastRow, firstCol, lastCol), sheet);
		RegionUtil.setBorderBottom(border, new CellRangeAddress(firstRow, lastRow, firstCol, lastCol), sheet);
	}
	
	
	private int textRowCnt(String str){
        String regEx = "\n";
    
        // 정규식(regEx)을 패턴으로 만들고,
        Pattern pat = Pattern.compile(regEx);
        // 패턴을 타겟 스트링(target)과 매치시킨다.
        Matcher match = pat.matcher(str);
        
        int cnt = 0;
        while(match.find()){
            cnt ++;
        }
        
        return cnt;
	}
	
	

}


