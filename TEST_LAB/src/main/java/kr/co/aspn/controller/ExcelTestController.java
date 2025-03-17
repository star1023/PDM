package kr.co.aspn.controller;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.aspn.service.ExcelTestService;

@Controller
@RequestMapping("/excelTest")
public class ExcelTestController {
	Logger logger = LoggerFactory.getLogger(ExcelTestController.class);
	HashMap<Integer, HashMap> map;
	
	@Autowired
	ExcelTestService excelTestService;
	
	
	@RequestMapping("/excelRead")
	public String readExcel() throws Exception{
		
		FileInputStream fis = new FileInputStream("C://Users//User//Desktop//삼립연구소//migration_final//final_20220519.xlsx");
		XSSFWorkbook wb = new XSSFWorkbook(fis);
		
		//manufacturingNo 테이블
		//excelTestService.readNo(wb.getSheetAt(0));
		
		//manufacturingNoDate 테이블
		//excelTestService.readNoData(wb.getSheetAt(1));
		
		//manufacturingNoPackageUnit 테이블
		//excelTestService.readNoPackageUnit(wb.getSheetAt(2));
		
		//manufacturingNoMapping 테이블
		//excelTestService.readNoMapping(wb.getSheetAt(3));
		
		//엑셀 파일 한 줄씩 순차적으로 쿼리 실행
		excelTestService.insert(wb);
		
		wb.close();
		
		return "/manufacturingNo/dbList";
	};
	
	@RequestMapping("/excelInsertAfterError")
	public String insertAfterError() throws IOException{
		FileInputStream fis = new FileInputStream("C://Users//User//Desktop//삼립연구소//migration_final//final_20220519.xlsx");
		XSSFWorkbook wb = new XSSFWorkbook(fis);
		
		excelTestService.insert(wb, 1);
		
		wb.close();
		
		return "/manufacturingNo/dbList";
	}
	
	@RequestMapping("/excelUpdate")
	public String updateExcel() throws IOException{
		FileInputStream fis = new FileInputStream("C://Users//User//Desktop//삼립연구소//migration_final//final_20220519.xlsx");
		XSSFWorkbook wb = new XSSFWorkbook(fis);
		

		return "/manufacturingNo/dbList";
	}
	@RequestMapping("/updatePackage")
	public String updatePackage() throws IOException{
		FileInputStream fis = new FileInputStream("C://Users//User//Desktop//삼립연구소//migration_final//final_20220519.xlsx");
		XSSFWorkbook wb = new XSSFWorkbook(fis);
		excelTestService.insertPackage(wb);

		return "/manufacturingNo/dbList";
	}
}
