package kr.co.aspn.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.TimeZone;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
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
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.aspn.service.ProductDevService;
import kr.co.aspn.vo.MfgProcessDoc;
import kr.co.aspn.vo.MfgProcessDocBase;
import kr.co.aspn.vo.MfgProcessDocDisp;
import kr.co.aspn.vo.MfgProcessDocItem;
import kr.co.aspn.vo.MfgProcessDocSubProd;
import kr.co.aspn.vo.ProductDevDocVO;

//@Controller
//@RequestMapping("excel")
public class ExcelUtil {
	Logger logger = LoggerFactory.getLogger(ExcelUtil.class);
	
	@Autowired
	ProductDevService productDevService;
	
	private String IMG_PATH = "";								// 이미지 파일 경로
	private String OUTPUT_FILE_PATH = "";						// 최종 파일 생성 경로

	private int rowNum = 0;												// Row Index
	int FIRST_CELLNUM = 0;
	int LAST_CELLNUM = 15;
	
	/**
	 * Constructor
	 */
	public ExcelUtil(){				
		// 다운로드 이미지 세팅
		String downloadPath = "D:"+File.separator+"upload"+File.separator+"devdoc"+File.separator;//PSettings.prop.getProperty("file.downloadPath");
		IMG_PATH = downloadPath  + "uploadImages" +File.separator;
		OUTPUT_FILE_PATH = downloadPath + "TEMP" +File.separator;
	}
	
	/**
	 * 엑셀 생성 및 다운로드
	 */
	//@RequestMapping(value="mainTask", produces="text/plain;charset=utf-8", method=RequestMethod.POST)
	//@ResponseBody
	public void mainTask(HttpServletRequest req, HttpServletResponse resp, String dNo, String docNo, String docVersion) throws Exception{	
		String resultFilePath = "";
		
		
		MfgProcessDoc mfgDoc = productDevService.getMfgProcessDocDetail(dNo, docNo, docVersion, "");
		ProductDevDocVO devDoc = productDevService.getProductDevDoc(docNo, docVersion);
		
		XSSFWorkbook workbook = new XSSFWorkbook();
		XSSFSheet sheet = workbook.createSheet("sheet");
		sheet.setDefaultColumnWidth(sheet.getDefaultColumnWidth());
		
		setDefaultMerge(sheet,0,0,0,7);
		setDefaultMerge(sheet,1,2,0,7);
		setDefaultMerge(sheet,0,2,8,13);
		
		// [BODY] start
		Row row4 = sheet.createRow(4);
		
		setHeader(workbook, sheet, mfgDoc);
		setSeparater(workbook, sheet);
		
		for (MfgProcessDocSubProd sub : mfgDoc.getSub()) {
			int subProdStartRow = rowNum;
			
			setSubProductName(workbook, sheet, sub.getSubProdName());
			setSubProduct(workbook, sheet, sub);
			
			int subProdEndRow = rowNum-1;
			
			// setSubProdBorder
			setBorder(sheet, BorderStyle.THICK, subProdStartRow, subProdEndRow, 0, 15);
		}
		
		setMatDisp(workbook, sheet, mfgDoc.getPkg(), mfgDoc.getDisp());
		setTextAndImage(workbook, sheet, mfgDoc.getMenuProcess(), mfgDoc.getProdStandard());
		setEtcInfo(workbook, sheet, mfgDoc, devDoc);
		
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
		
		resp.setHeader("Content-Disposition", "attachment;filename=\"" + fileName +"\"");             
		resp.setContentType("application/octer-stream");
		resp.setHeader("Content-Transfer-Encoding", "binary;");
		
		try{
			FileInputStream fis = new FileInputStream(file); 
			ServletOutputStream sos = resp.getOutputStream();
			byte[] b = new byte[1024];
			
			int data = 0;
			
			while((data=(fis.read(b, 0, b.length))) != -1){
				sos.write(b, 0, data);
			}
			
			sos.flush();
		} catch(Exception e) {
			throw e;
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
	
	private void setHeader(Workbook workbook, Sheet sheet, MfgProcessDoc mfgDoc){
		// [HEADER] start
		Row row0 = sheet.createRow(0);
		Row row1 = sheet.createRow(1);
		Row row2 = sheet.createRow(2);
		
		rowNum = 3;
		
		Cell cell = row0.createCell(0);
		cell.setCellValue("제품제조공정서");
		cell.setCellStyle(getCellStyle(workbook, "subTitle"));
		setBorder(sheet, BorderStyle.THIN, cell);
		
		Cell cell8 = row0.createCell(8);
		setBorder(sheet, BorderStyle.THIN, 0, 0, 8, 15);
		setBorder(sheet, BorderStyle.THIN, cell8);
		
		Cell cell10 = row0.createCell(14);
		cell10.setCellValue("문서번호");
		cell10.setCellStyle(getCellStyle(workbook, "subTitle"));
		setBorder(sheet, BorderStyle.THIN, cell10);
		
		Cell cell11 = row0.createCell(15);
		cell11.setCellValue("SHA-L-001");
		cell11.setCellStyle(getCellStyle(workbook, "default"));
		setBorder(sheet, BorderStyle.THIN, cell10);
		
		Cell row1Cell0 = row1.createCell(0);
		row1Cell0.setCellValue(mfgDoc.getDocProdName());
		row1Cell0.setCellStyle(getCellStyle(workbook, "title"));
		setBorder(sheet, BorderStyle.THIN, row1Cell0);
		
		Cell row1Cell10 = row1.createCell(14);
		row1Cell10.setCellValue("제개정일");
		row1Cell10.setCellStyle(getCellStyle(workbook, "subTitle"));
		setBorder(sheet, BorderStyle.THIN, row1Cell10);
		
		Cell row1Cell11 = row1.createCell(15);
		//String lastDate = mfgDoc.getModDate().split(" ")[0] == null ? mfgDoc.getRegDate().split(" ")[0] : mfgDoc.getModDate().split(" ")[0];
		String lastDate = mfgDoc.getRegDate().split(" ")[0];
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
		cell.setCellValue(subProdName);
		
		rowNum++;
	}
	
	private void setSubProduct(Workbook workbook, Sheet sheet, MfgProcessDocSubProd sub){
		setMixCont(sub, "mix", workbook, sheet);
		setMixCont(sub, "cont", workbook, sheet);
	}
	
	private void setMixCont(MfgProcessDocSubProd sub, String type, Workbook workbook, Sheet sheet){
		List<MfgProcessDocBase> base = new ArrayList<MfgProcessDocBase>();
		if(type.equals("mix"))
			base = sub.getMix();
		
		if(type.equals("cont"))
			base = sub.getCont();
		
		int tempItemSize = 0;
		
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
						headCell0.setCellValue(mix.getBaseName());
						headCell0.setCellStyle(getCellStyle(workbook, type+"Title"));
						setBorder(sheet, BorderStyle.THIN, headCell0);
						
						Cell headCell8 = baseTitle.createCell(8);
						headCell8.setCellValue("");
						headCell8.setCellStyle(getCellStyle(workbook, type+"Title"));
						setBorder(sheet, BorderStyle.THIN, headCell8);
						
						// 카테고리명
						Row category = sheet.createRow(rowNum+1);
						sheet.addMergedRegion(new CellRangeAddress(rowNum+1, rowNum+1, 0, 3));
						sheet.addMergedRegion(new CellRangeAddress(rowNum+1, rowNum+1, 8, 11));
						
						Cell categoryCell0 = category.createCell(0);
						categoryCell0.setCellValue("원료명");
						categoryCell0.setCellStyle(getCellStyle(workbook, "itemCategory"));
						setBorder(sheet, BorderStyle.THIN, categoryCell0);
						
						Cell categoryCell4 = category.createCell(4);
						categoryCell4.setCellValue("코드번호");
						categoryCell4.setCellStyle(getCellStyle(workbook, "itemCategory"));
						setBorder(sheet, BorderStyle.THIN, categoryCell4);
						
						Cell categoryCell5 = category.createCell(5);
						categoryCell5.setCellValue("베이커리%");
						categoryCell5.setCellStyle(getCellStyle(workbook, "itemCategory"));
						setBorder(sheet, BorderStyle.THIN, categoryCell5);
						
						Cell categoryCell6 = category.createCell(6);
						categoryCell6.setCellValue("BOM");
						categoryCell6.setCellStyle(getCellStyle(workbook, "itemCategory"));
						setBorder(sheet, BorderStyle.THIN, categoryCell6);
						
						Cell categoryCell7 = category.createCell(7);
						categoryCell7.setCellValue("수량 스크랩");
						categoryCell7.setCellStyle(getCellStyle(workbook, "itemCategory"));
						setBorder(sheet, BorderStyle.THIN, categoryCell7);
						
						Cell categoryCell8 = category.createCell(8);
						categoryCell8.setCellValue("원료명");
						categoryCell8.setCellStyle(getCellStyle(workbook, "itemCategory"));
						setBorder(sheet, BorderStyle.THIN, categoryCell8);
						
						Cell categoryCell12 = category.createCell(12);
						categoryCell12.setCellValue("코드번호");
						categoryCell12.setCellStyle(getCellStyle(workbook, "itemCategory"));
						setBorder(sheet, BorderStyle.THIN, categoryCell12);
						
						Cell categoryCell13 = category.createCell(13);
						categoryCell13.setCellValue("베이커리%");
						categoryCell13.setCellStyle(getCellStyle(workbook, "itemCategory"));
						setBorder(sheet, BorderStyle.THIN, categoryCell13);
						
						Cell categoryCell14 = category.createCell(14);
						categoryCell14.setCellValue("BOM");
						categoryCell14.setCellStyle(getCellStyle(workbook, "itemCategory"));
						setBorder(sheet, BorderStyle.THIN, categoryCell4);
						
						Cell categoryCell15 = category.createCell(15);
						categoryCell15.setCellValue("수량 스크랩");
						categoryCell15.setCellStyle(getCellStyle(workbook, "itemCategory"));
						setBorder(sheet, BorderStyle.THIN, categoryCell15);
					}
					Row row = sheet.createRow(rowNum+2+j);
					
					sheet.addMergedRegion(new CellRangeAddress(rowNum+2+j, rowNum+2+j, 0, 3));
					sheet.addMergedRegion(new CellRangeAddress(rowNum+2+j, rowNum+2+j, 8, 11));
					
					Cell nameCell0 = row.createCell(0);
					nameCell0.setCellValue(mix.getItem().get(j).getItemName());
					nameCell0.setCellStyle(getCellStyle(workbook, "itemName"));
					setBorder(sheet, BorderStyle.THIN, nameCell0);
					
					Cell nameCell1 = row.createCell(4);
					nameCell1.setCellValue(mix.getItem().get(j).getItemCode());
					nameCell1.setCellStyle(getCellStyle(workbook, "default"));
					setBorder(sheet, BorderStyle.THIN, nameCell1);
					
					Cell nameCell5 = row.createCell(5);
					nameCell5.setCellValue(mix.getItem().get(j).getBomRate());
					nameCell5.setCellStyle(getCellStyle(workbook, "default"));
					setBorder(sheet, BorderStyle.THIN, nameCell5);
					totalLeftBomRate += Double.parseDouble(mix.getItem().get(j).getBomRate());
					
					Cell nameCell6 = row.createCell(6);
					nameCell6.setCellValue(mix.getItem().get(j).getBomAmount());
					nameCell6.setCellStyle(getCellStyle(workbook, "default"));
					setBorder(sheet, BorderStyle.THIN, nameCell6);
					totalLeftBomAmount += Double.parseDouble(mix.getItem().get(j).getBomAmount());
					
					Cell nameCell7 = row.createCell(7);
					nameCell7.setCellValue(mix.getItem().get(j).getScrap());
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
				tempItemSize =  mix.getItem().size();
			} else {
				for (int j=0; j < mix.getItem().size(); j++) {
					System.out.println("\t !i%2 rowNum+j: " + (rowNum+j) + ", tempItemSize: " + tempItemSize);
					
					if(j==0){
						// 배합,내용물 제목 열 추가
						Row baseTitle = sheet.getRow(rowNum);
						
						Cell headCell = baseTitle.getCell(8);
						headCell.setCellValue(mix.getBaseName());
						headCell.setCellStyle(getCellStyle(workbook, type+"Title"));
						setBorder(sheet, BorderStyle.THIN, headCell);
					}
					
					if(j < tempItemSize){
						Row row = sheet.getRow(rowNum+2+j);
						
						Cell nameCell = row.getCell(8);
						nameCell.setCellValue(mix.getItem().get(j).getItemName());
						
						Cell nameCell12 = row.getCell(12);
						nameCell12.setCellValue(mix.getItem().get(j).getItemCode());
						
						Cell nameCell13 = row.getCell(13);
						nameCell13.setCellValue(mix.getItem().get(j).getBomRate());
						totalRightBomRate += Double.parseDouble(mix.getItem().get(j).getBomRate());
						
						Cell nameCell14 = row.getCell(14);
						nameCell14.setCellValue(mix.getItem().get(j).getBomAmount());
						totalRightBomAmount += Double.parseDouble(mix.getItem().get(j).getBomAmount());
						
						Cell nameCell15 = row.getCell(15);
						nameCell15.setCellValue(mix.getItem().get(j).getScrap());
					} else {
						Row row = sheet.createRow(rowNum+2+j);
						
						sheet.addMergedRegion(new CellRangeAddress(rowNum+2+j, rowNum+2+j, 0, 3));
						sheet.addMergedRegion(new CellRangeAddress(rowNum+2+j, rowNum+2+j, 8, 11));
						
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
						nameCell8.setCellValue(mix.getItem().get(j).getItemName());
						nameCell8.setCellStyle(getCellStyle(workbook, "itemName"));
						setBorder(sheet, BorderStyle.THIN, nameCell8);
						
						Cell nameCell12 = row.createCell(12);
						nameCell12.setCellValue(mix.getItem().get(j).getItemCode());
						nameCell12.setCellStyle(getCellStyle(workbook, "default"));
						setBorder(sheet, BorderStyle.THIN, nameCell12);
						
						Cell nameCell13 = row.createCell(13);
						nameCell13.setCellValue(mix.getItem().get(j).getBomRate());
						nameCell13.setCellStyle(getCellStyle(workbook, "default"));
						setBorder(sheet, BorderStyle.THIN, nameCell13);
						totalRightBomRate += Double.parseDouble(mix.getItem().get(j).getBomRate());
						
						Cell nameCell14 = row.createCell(14);
						nameCell14.setCellValue(mix.getItem().get(j).getBomAmount());
						nameCell14.setCellStyle(getCellStyle(workbook, "default"));
						setBorder(sheet, BorderStyle.THIN, nameCell14);
						totalRightBomAmount += Double.parseDouble(mix.getItem().get(j).getBomAmount());
						
						Cell nameCell15 = row.createCell(15);
						nameCell15.setCellValue(mix.getItem().get(j).getScrap());
						nameCell15.setCellStyle(getCellStyle(workbook, "default"));
						setBorder(sheet, BorderStyle.THIN, nameCell15);
						
						if (j == mix.getItem().size())
							tempItemSize = mix.getItem().size();
					}
				}
				tempItemSize = tempItemSize > mix.getItem().size() ? tempItemSize : mix.getItem().size();
			}
			
			
			if(base.size()%2 == 1 && base.size() == i+1){
				
			}
			
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
					leftSumCell5.setCellValue(totalLeftBomRate);
					leftSumCell5.setCellStyle(getCellStyle(workbook, "default"));
					
					Cell leftSumCell6 = sumRow.createCell(6);
					leftSumCell6.setCellValue(totalLeftBomAmount);
					leftSumCell6.setCellStyle(getCellStyle(workbook, "default"));
					
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
						divWeightCell13.setCellValue(base.get(i).getDivWeight());
						divWeightCell13.setCellStyle(getCellStyle(workbook, "default"));
						setBorder(sheet, BorderStyle.THIN, divWeightCell13);
						
						rowNum += 2;
					} else {
						rowNum += 1;
					}
				} else {
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
					divWeightCell13.setCellValue(base.get(i).getDivWeight());
					divWeightCell13.setCellStyle(getCellStyle(workbook, "default"));
					setBorder(sheet, BorderStyle.THIN, divWeightCell13);
					
					rowNum += 2;
				} else {
					rowNum += 1;
				}
			}
			
			
			/*
			if(base.size()%2 == 1 && base.size() == i+1){
				rowNum += tempItemSize+2;
				
				Row sumRow = sheet.createRow(rowNum);
				sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, 4));
				sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 8, 12));
				Cell leftSumCell0 = sumRow.createCell(0);
				leftSumCell0.setCellValue("합계");
				leftSumCell0.setCellStyle(getCellStyle(workbook, "itemName"));
				setBorder(sheet, BorderStyle.THIN, leftSumCell0);
				
				Cell leftSumCell5 = sumRow.createCell(5);
				leftSumCell5.setCellValue(totalLeftBomRate);
				leftSumCell5.setCellStyle(getCellStyle(workbook, "default"));
				
				Cell leftSumCell6 = sumRow.createCell(6);
				leftSumCell6.setCellValue(totalLeftBomAmount);
				leftSumCell6.setCellStyle(getCellStyle(workbook, "default"));
				
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
				
				if(i==0 && type.equals("mix")){
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
					divWeightCell13.setCellValue(base.get(i).getDivWeight());
					divWeightCell13.setCellStyle(getCellStyle(workbook, "default"));
					setBorder(sheet, BorderStyle.THIN, divWeightCell13);
					
					rowNum += 2;
				} else {
					rowNum += 1;
				}
			} else {
				if(i%2 != 0){
					rowNum += tempItemSize+2;
					
					Row sumRow = sheet.createRow(rowNum);
					sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, 4));
					sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 8, 12));
					Cell leftSumCell0 = sumRow.createCell(0);
					leftSumCell0.setCellValue("합계");
					leftSumCell0.setCellStyle(getCellStyle(workbook, "itemName"));
					setBorder(sheet, BorderStyle.THIN, leftSumCell0);
					
					Cell leftSumCell5 = sumRow.createCell(5);
					//leftSumCell5.setCellValue(totalLeftBomRate);
					leftSumCell5.setCellStyle(getCellStyle(workbook, "default"));
					
					Cell leftSumCell6 = sumRow.createCell(6);
					//leftSumCell6.setCellValue(totalLeftBomAmount);
					leftSumCell6.setCellStyle(getCellStyle(workbook, "default"));
					
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
					
					if(i==0 && type.equals("mix")){
						Row etcRow = sheet.createRow(rowNum+1);
						sheet.addMergedRegion(new CellRangeAddress(rowNum+1, rowNum+1, 0, 4));
						sheet.addMergedRegion(new CellRangeAddress(rowNum+1, rowNum+1, 5, 7));
						sheet.addMergedRegion(new CellRangeAddress(rowNum+1, rowNum+1, 8, 12));
						sheet.addMergedRegion(new CellRangeAddress(rowNum+1, rowNum+1, 13, 15));
						
						Cell stdAmountCell = etcRow.createCell(0);
						stdAmountCell.setCellValue("기준수량");
						stdAmountCell.setCellStyle(getCellStyle(workbook, "itemName"));
						setBorder(sheet, BorderStyle.THIN, stdAmountCell);
						
						Cell stdAmountCell5 = etcRow.createCell(5);
						stdAmountCell5.setCellValue(sub.getStdAmount());
						stdAmountCell5.setCellStyle(getCellStyle(workbook, "default"));
						setBorder(sheet, BorderStyle.THIN, stdAmountCell5);
						
						Cell divWeightCell = etcRow.createCell(8);
						divWeightCell.setCellValue("분할중량");
						divWeightCell.setCellStyle(getCellStyle(workbook, "itemName"));
						setBorder(sheet, BorderStyle.THIN, divWeightCell);
						
						Cell divWeightCell13 = etcRow.createCell(13);
						divWeightCell13.setCellValue(base.get(i).getDivWeight());
						divWeightCell13.setCellStyle(getCellStyle(workbook, "default"));
						setBorder(sheet, BorderStyle.THIN, divWeightCell13);
						
						rowNum += 2;
					} else {
						rowNum += 1;
					}
				}
			}
			*/
			
		}
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
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, 4));
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 6, 7));
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 8, 13));
		
		// 재료명
		// 코드번호
		// 재료사양
		Cell categoryCell0 = cateroryRow.createCell(0);
		categoryCell0.setCellValue("재료명");
		categoryCell0.setCellStyle(getCellStyle(workbook, "itemCategory"));
		setBorder(sheet, BorderStyle.THIN, categoryCell0);
		Cell categoryCell5 = cateroryRow.createCell(5);
		categoryCell5.setCellValue("코드번호");
		categoryCell5.setCellStyle(getCellStyle(workbook, "itemCategory"));
		setBorder(sheet, BorderStyle.THIN, categoryCell5);
		Cell categoryCell6 = cateroryRow.createCell(6);
		categoryCell6.setCellValue("재료사양");
		categoryCell6.setCellStyle(getCellStyle(workbook, "itemCategory"));
		setBorder(sheet, BorderStyle.THIN, categoryCell6);
		
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
			sheet.addMergedRegion(new CellRangeAddress(rowNum+i, rowNum+i, 0, 4));
			sheet.addMergedRegion(new CellRangeAddress(rowNum+i, rowNum+i, 6, 7));
			sheet.addMergedRegion(new CellRangeAddress(rowNum+i, rowNum+i, 8, 13));
			
			Cell cell0 = matDispRow.createCell(0);
			cell0.setCellStyle(getCellStyle(workbook, "itemName"));
			setBorder(sheet, BorderStyle.THIN, cell0);
			
			Cell cell5 = matDispRow.createCell(5);
			cell5.setCellStyle(getCellStyle(workbook, "default"));
			setBorder(sheet, BorderStyle.THIN, cell5);
			
			Cell cell6 = matDispRow.createCell(6);
			cell6.setCellStyle(getCellStyle(workbook, "default"));
			setBorder(sheet, BorderStyle.THIN, cell6);
			
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
			nameCell.setCellValue(pkg.get(i).getItemName());
			
			Cell codeCell = row.getCell(5);
			codeCell.setCellValue(pkg.get(i).getItemCode());
			
			Cell dataCell = row.getCell(6);
			dataCell.setCellValue(pkg.get(i).getBomAmount());
			totalPkg += Double.parseDouble(pkg.get(i).getBomAmount());
		}
		
		double totalExcRate = 0;
		double totalincRate = 0;
		for (int i = 0; i < disp.size(); i++) {
			Row row = sheet.getRow(rowNum+i);
			Cell nameCell = row.getCell(8);
			nameCell.setCellValue(disp.get(i).getMatName());
			
			Cell perCell = row.getCell(14);
			perCell.setCellValue(disp.get(i).getExcRate());
			totalExcRate += Double.parseDouble(disp.get(i).getExcRate());
			
			Cell waterCell = row.getCell(15);
			waterCell.setCellValue(disp.get(i).getIncRate());
			totalincRate += Double.parseDouble(disp.get(i).getIncRate());
		}
		
		rowNum += matDispRows;
		
		Row totalRow = sheet.createRow(rowNum);
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, 5));
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 6, 7));
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 8, 13));
		
		Cell matTotalCell0 = totalRow.createCell(0);
		matTotalCell0.setCellValue("합계");
		matTotalCell0.setCellStyle(getCellStyle(workbook, "subTitle"));
		setBorder(sheet, BorderStyle.THIN, matTotalCell0);
		Cell matTotalCell6 = totalRow.createCell(6);
		matTotalCell6.setCellValue(totalPkg);
		matTotalCell6.setCellStyle(getCellStyle(workbook, "default"));
		setBorder(sheet, BorderStyle.THIN, matTotalCell6);
		
		Cell dispTotalCell8 = totalRow.createCell(8);
		dispTotalCell8.setCellValue("합계");
		dispTotalCell8.setCellStyle(getCellStyle(workbook, "subTitle"));
		setBorder(sheet, BorderStyle.THIN, dispTotalCell8);
		Cell dispTotalCell14 = totalRow.createCell(14);
		dispTotalCell14.setCellValue(totalExcRate);
		dispTotalCell14.setCellStyle(getCellStyle(workbook, "default"));
		setBorder(sheet, BorderStyle.THIN, dispTotalCell14);
		Cell dispTotalCell15 = totalRow.createCell(15);
		dispTotalCell15.setCellValue(totalincRate);
		dispTotalCell15.setCellStyle(getCellStyle(workbook, "default"));
		setBorder(sheet, BorderStyle.THIN, dispTotalCell15);
		
		rowNum++;
		
		setBorder(sheet, BorderStyle.THICK, matDispStartRow, rowNum-1, 0, 15);
	}
	
	private void setTextAndImage(XSSFWorkbook workbook, XSSFSheet sheet, String menuProcess, String prodStandard) {

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
		
		for (int i = 0; i < 15; i++) {
			sheet.createRow(rowNum+i);
		}
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum+15, 0, 5));
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum+15, 6, 10));
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum+15, 11, 15));
		
		Row tiRow0 = sheet.createRow(rowNum);
		Cell menuProcessDataCell = tiRow0.createCell(0);
		menuProcessDataCell.setCellValue(menuProcess);
		menuProcessDataCell.setCellStyle(getCellStyle(workbook, "text"));
		Cell prodStandardDataCell = tiRow0.createCell(6);
		prodStandardDataCell.setCellValue(prodStandard);
		prodStandardDataCell.setCellStyle(getCellStyle(workbook, "default"));
		Cell imageDataCell = tiRow0.createCell(11);
		
		// drawing
		try {
			
			String imagePath = "D:"+File.separator+"upload"+File.separator+"devdoc"+File.separator+"images"+File.separator+"201912"+File.separator+"1576832586900.PNG";
			InputStream inputStream = new FileInputStream(new File(imagePath));
			byte[] bytes = IOUtils.toByteArray(inputStream);
			int pictureIdx = workbook.addPicture(bytes, XSSFWorkbook.PICTURE_TYPE_JPEG);
			
			XSSFCreationHelper helper = workbook.getCreationHelper();
			XSSFDrawing drawing = sheet.createDrawingPatriarch();
			XSSFClientAnchor anchor = helper.createClientAnchor();
			
			anchor.setCol1(11);
			anchor.setRow1(tiRow0.getRowNum());
			
			XSSFPicture pict = drawing.createPicture(anchor, pictureIdx);
			
			pict.resize();
			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		tiRow0.setHeight((short) -1);
		
		rowNum += 15;
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
	
	private void setEtcInfo(XSSFWorkbook workbook, XSSFSheet sheet, MfgProcessDoc mfgDoc, ProductDevDocVO devDoc) {
		int etcStartRow = rowNum+1;
		
		Row tiTitleRow = sheet.createRow(++rowNum);
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, 15));
		Cell titleCell = tiTitleRow.createCell(0);
		titleCell.setCellValue("비고");
		titleCell.setCellStyle(getCellStyle(workbook, "subTitle"));
		
		Row etcRow0 = sheet.createRow(++rowNum);
		String lineName = mfgDoc.getLineName();
		String weightText = mfgDoc.getTotWeight() +" kg ("+ mfgDoc.getBagAmout() + " ��)";
		String bomRate = mfgDoc.getBomRate() + " %";
		mergeEtcRow(rowNum, sheet);
		setEtcRowValue("생산라인", lineName, "배합중량", weightText, "BOM수율", bomRate, etcRow0, workbook);
		
		Row etcRow1 = sheet.createRow(++rowNum);
		String numBong = mfgDoc.getNumBong() + " /ea";
		String numBox = mfgDoc.getNumBox();
		String lineProcessType = mfgDoc.getLineProcessType();
		mergeEtcRow(rowNum, sheet);
		setEtcRowValue("봉당 들이수", numBong, "상자 들이수", numBox, "제조공정도 유형", lineProcessType, etcRow1, workbook);
		
		Row etcRow2 = sheet.createRow(++rowNum);
		String stdAmount = mfgDoc.getStdAmount() + "g";
		String loss = mfgDoc.getLoss() + " %";
		mergeEtcRow(rowNum, sheet);
		setEtcRowValue("분할중량합계(g)", stdAmount, "소성손실(g/%)", loss, "", "", etcRow2, workbook);
		
		Row etcRow3 = sheet.createRow(++rowNum);
		String compWeight = mfgDoc.getCompWeight();
		String adminWeight = mfgDoc.getAdminWeight();
		String dispWeight = mfgDoc.getDispWeight();
		mergeEtcRow(rowNum, sheet);
		setEtcRowValue("완제중량", compWeight, "관리중량", adminWeight, "표기중량", dispWeight, etcRow3, workbook);
		
		Row etcRow4 = sheet.createRow(++rowNum);
		String ingredient = mfgDoc.getIngredient();
		String usage = mfgDoc.getUsage();
		String applyName = "";
		mergeEtcRow(rowNum, sheet);
		setEtcRowValue("성상", ingredient, "용도용법", usage, "등록서류제품명", applyName, etcRow4, workbook);
		
		Row etcRow5 = sheet.createRow(++rowNum);
		String categoryText = devDoc.getProductCategoryText();
		String mfgNo = devDoc.getManufacturingNo();
		mergeEtcRow(rowNum, sheet);
		setEtcRowValue("식품유형", categoryText, "등록번호", mfgNo, "", "", etcRow5, workbook);
		
		Row etcRow6 = sheet.createRow(++rowNum);
		String distPeriDoc = mfgDoc.getDistPeriDoc();
		String distPeriSite = mfgDoc.getDistPeriSite();
		String keepCondition = mfgDoc.getKeepCondition();
		mergeEtcRow(rowNum, sheet);
		setEtcRowValue("소비기한 - 등록서류", distPeriDoc, "소비기한 - 현장", distPeriSite, "보관조건", keepCondition, etcRow6, workbook);
		
		Row etcRow7 = sheet.createRow(++rowNum);
		String packMaterial = mfgDoc.getPackMaterial();
		String packUnit = mfgDoc.getPackUnit();
		String childHarm = mfgDoc.getChildHarm();
		
		String chText = "";
		if(childHarm.equals("1")) chText = "[●]예   []아니오   []해당 없음";
		else if(childHarm.equals("2")) chText = "[]예   [●]아니오   []해당 없음";
		else if(childHarm.equals("3")) chText = "[]예   []아니오   [●]해당 없음";
		
		mergeEtcRow(rowNum, sheet);
		setEtcRowValue("포장재질", packMaterial, "품목제조보고서 포장단위", packUnit, "어린이 기호식품 고열량 저열량 해당유무", chText, etcRow7, workbook);
		
		Row etcRow8 = sheet.createRow(++rowNum);
		String etcText = mfgDoc.getNote();
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 0, 1));
		sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 2, 15));
		Cell etcRow_8_title = etcRow8.createCell(0);
		Cell etcRow_8_value = etcRow8.createCell(2);
		etcRow_8_title.setCellValue("비고");
		etcRow_8_title.setCellStyle(getCellStyle(workbook, "subTitle"));
		etcRow_8_value.setCellValue(etcText);
		etcRow_8_value.setCellStyle(getCellStyle(workbook, "default"));
		
		setBorder(sheet, BorderStyle.THICK, etcStartRow, rowNum, 0, 15);
	}
	
	private void mergeEtcRow(int rowNum, Sheet sheet){
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
	
	private void setEtcRowValue(String title1, String value1, String title2, String value2, String title3, String value3, Row row, Workbook workbook){
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
}
