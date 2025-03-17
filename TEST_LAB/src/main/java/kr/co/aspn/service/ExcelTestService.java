package kr.co.aspn.service;

import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

public interface ExcelTestService {
	public void readNo(XSSFSheet sheet);
	public void readNoData(XSSFSheet sheet);
	public void readNoPackageUnit(XSSFSheet sheet);
	public void readNoMapping(XSSFSheet sheet);
	public void insert(XSSFWorkbook wb);
	public void update(XSSFWorkbook wb);
	public void insert(XSSFWorkbook wb, Integer startRow);
	public void insertPackage(XSSFWorkbook wb);
}
