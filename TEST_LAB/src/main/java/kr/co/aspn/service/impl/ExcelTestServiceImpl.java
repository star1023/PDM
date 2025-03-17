package kr.co.aspn.service.impl;

import java.sql.Date;
import java.time.LocalDate;
import java.util.HashMap;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.aspn.controller.ExcelTestController;
import kr.co.aspn.dao.ExcelTestDao;
import kr.co.aspn.service.ExcelTestService;

@Service
public class ExcelTestServiceImpl implements ExcelTestService {

	private Logger logger = LoggerFactory.getLogger(ExcelTestServiceImpl.class);
	HashMap<Integer, HashMap<String, Object>> map;
	String cellValue = "";
	HashMap<String, Object> inputs;
	LocalDate date;
	Date sqlDate;
	
	

	XSSFRow rowNo;
	XSSFRow rowNoData;
	XSSFRow rowNoPackageUnit;
	XSSFRow rowNoMapping;
	
	@Autowired
	ExcelTestDao excelTestDao;
	
	public String readCell(Cell cell){
		CellType cellType;
		try {
			cellType = cell.getCellType();
		} catch (Exception e) {
			cell.setCellValue("");
			cell.setCellType(CellType.STRING);
			cell.setCellValue("");
		}
		switch (cell.getCellType()){
		case STRING :
			if(cell.getStringCellValue().equals("NULL")){
				cellValue = null;
			}else if(cell.getStringCellValue().equals(" ")){
				cellValue = null;
			}else{
				cellValue = cell.getStringCellValue();
			}
			break;
		case NUMERIC :
			if(cell.getNumericCellValue()>2147483647){
				cellValue = String.format("%.0f",cell.getNumericCellValue()) + "";
			}else {
				cellValue = (int)(cell.getNumericCellValue()) + "";
			}
			break;
		case BOOLEAN :
			cellValue = cell.getBooleanCellValue() + "";
			break;
		case BLANK :
			cellValue = "";
			break;
		case _NONE :
			cellValue = "";
			break;
		default:
			cellValue = "";
			break;
		};
		return cellValue;	
	}
	
	
	/*엑셀 인서트 후 nodata 시트 오기입 데이터 삼립에서 수정해 주면 update*/
	@Override
	public void update(XSSFWorkbook wb){
		XSSFRow rowNoData;
		
		map = new HashMap<Integer, HashMap<String, Object>>();
		//manufacturingNoDate 테이블
		XSSFSheet noData = wb.getSheetAt(4);
	}
	
	

	/*엑셀 처음 인서트*/
	@Override
	@Transactional(rollbackFor = Exception.class)
	public void insert(XSSFWorkbook wb) {
		
		map = new HashMap<Integer, HashMap<String, Object>>();
		int readNoCnt = 0;
		int seq; //품목보고 키
		int noDataSeq; //품목보고데이터 키
		
		//manufacturingNo 테이블
		XSSFSheet no = wb.getSheetAt(0);
		//manufacturingNoDate 테이블
		XSSFSheet noData = wb.getSheetAt(1);
		//manufacturingNoPackageUnit 테이블
		XSSFSheet noPackageUnit = wb.getSheetAt(2);
		//manufacturingNoMapping 테이블
		XSSFSheet noMapping = wb.getSheetAt(3);

		HashMap<String, Object> inputsNo;
		HashMap<String, Object> inputsNoData;
		HashMap<String, Object> inputsNoPackageUnit;
		HashMap<String, Object> inputsNoMapping;

		/*
		 * 한 테이블의 모든 row들을 insert -> 다음 테이블의 모든 row들을 insert할 때 아래의 새로운 hashmap이 필요
		 * 지금 로직(1번 테이블의 1번째 row insert -> 2번 테이블의 1번째 row insert ... -> 1번째 테이블의 2번째 row insert ->
		 *  ... -> 1번째 테이블의 nth row insert)에서는 불필요.
		HashMap<Integer, HashMap<String, Object>> mapNo = new HashMap<Integer, HashMap<String, Object>>();
		HashMap<Integer, HashMap<String, Object>> mapNoData = new HashMap<Integer, HashMap<String, Object>>();
		HashMap<Integer, HashMap<String, Object>> mapNoPackageUnit = new HashMap<Integer, HashMap<String, Object>>();
		HashMap<Integer, HashMap<String, Object>> mapNoMapping = new HashMap<Integer, HashMap<String, Object>>();
		*/
		
		//각 테이블마다 몇 번의 for loop를 몇 번 돌아야 할 지 = 엑셀 no sheet의 row 개수만큼
		int rowLength = no.getLastRowNum();
		
		for(int i = 1; i<=rowLength; i++){
			rowNo = no.getRow(i);
			
			inputsNo = new HashMap<String, Object>();
			
			inputsNo.put("tempKey", readCell(rowNo.getCell(0))); //맵핑 테이블 매칭을 위해 temp key 생성
			inputsNo.put("companyCode", readCell(rowNo.getCell(1)));
			inputsNo.put("plantCode", readCell(rowNo.getCell(2)));
			inputsNo.put("manufacturingNo", readCell(rowNo.getCell(3)));
			inputsNo.put("manufacturingName", readCell(rowNo.getCell(4)));
			inputsNo.put("licensingNo", readCell(rowNo.getCell(5)));
			inputsNo.put("status", readCell(rowNo.getCell(6)));
			try {
				date = rowNo.getCell(7).getLocalDateTimeCellValue().toLocalDate();
				inputsNo.put("reportSDate", date);
				date = rowNo.getCell(8).getLocalDateTimeCellValue().toLocalDate();
				inputsNo.put("stopReqDate", date);
				date = rowNo.getCell(9).getLocalDateTimeCellValue().toLocalDate();
				inputsNo.put("stopDate", date);
			} catch (Exception e) {
				
			}
			/*
			if(rowNo.getCell(7) != null && !readCell(rowNo.getCell(7)).equals("NULL")){
					date = rowNo.getCell(7).getLocalDateTimeCellValue().toLocalDate();
					inputsNo.put("reportSDate", date);
			};
			if(rowNo.getCell(8) != null && !readCell(rowNo.getCell(8)).equals("NULL")){
				date = rowNo.getCell(8).getLocalDateTimeCellValue().toLocalDate();
				inputsNo.put("stopReqDate", date);
			};
			if(rowNo.getCell(9) != null && !readCell(rowNo.getCell(9)).equals("NULL")){
				date = rowNo.getCell(9).getLocalDateTimeCellValue().toLocalDate();
				inputsNo.put("stopDate", date);
			};
			*/
			
			excelTestDao.insertIntoNo(inputsNo);
			
			rowNoData = noData.getRow(i);
			//if(엑셀 no sheet의 seq == 엑셀 noData sheet의 seq) -> noData 테이블 데이터 insert 시작
			
				inputsNoData  = new HashMap<String, Object>();
				Integer tempKey = Integer.parseInt(readCell(rowNoData.getCell(1)));
				Integer dataTempKey = Integer.parseInt(readCell(rowNoData.getCell(0)));
				//auto_increment 에 허수를 넣고 나중에 update;
				inputsNoData.put("no_seq", excelTestDao.getSeq());
				//엑셀의 품보데이터 키 insert. 마이그레이션 완료까지 수정이 필요할 때 사용해야 함
				inputsNoData.put("dataTempKey", dataTempKey);
				//엑셀의 품보 키 insert. 마이그레이션 완료까지 수정이 필요할 때 사용해야 함
				inputsNoData.put("tempKey", tempKey);
				
				inputsNoData.put("productType1", readCell(rowNoData.getCell(2)));
				inputsNoData.put("productType2", readCell(rowNoData.getCell(3)));
				//임시로 INSERT 안 할 것 inputsNoData.put("productType3", readCell(rowNoData.getCell(4)));
				if(rowNoData.getCell(5) != null){
					inputsNoData.put("comment", readCell(rowNoData.getCell(5)));
				}
				inputsNoData.put("keepCondition", readCell(rowNoData.getCell(6)));
				if(rowNoData.getCell(7) != null){
					inputsNoData.put("keepConditionText", readCell(rowNoData.getCell(7)));
				}
				inputsNoData.put("sterilization", readCell(rowNoData.getCell(8)));
				inputsNoData.put("sellDate1", readCell(rowNoData.getCell(9)));
				inputsNoData.put("sellDate2", readCell(rowNoData.getCell(10)));
				inputsNoData.put("sellDate3", readCell(rowNoData.getCell(11)));
				inputsNoData.put("sellDate4", readCell(rowNoData.getCell(12)));
				inputsNoData.put("sellDate5", readCell(rowNoData.getCell(13)));
				inputsNoData.put("sellDate6", readCell(rowNoData.getCell(14)));
				inputsNoData.put("referral", readCell(rowNoData.getCell(15)));
				inputsNoData.put("createPlant", readCell(rowNoData.getCell(16)));
				inputsNoData.put("oem", readCell(rowNoData.getCell(17)));
				inputsNoData.put("oemText", readCell(rowNoData.getCell(18)));
				inputsNoData.put("packageEtc", readCell(rowNoData.getCell(19)));
				inputsNoData.put("regUserId", readCell(rowNoData.getCell(20)));
				inputsNoData.put("versionNo", excelTestDao.selectVersionNo(tempKey));
				
				//noData 테이블로 데이터 insert
				excelTestDao.insertIntoNoData(inputsNoData);
				
				Integer no_seq = excelTestDao.selectSeqFromNo(tempKey);
				HashMap<String, Object> newInput = new HashMap<String, Object>();
				newInput.put("no_seq", no_seq);
				newInput.put("tempKey", tempKey);
				excelTestDao.updateNoData(newInput);
				
				
				/*
				//품목보고 데이터 키 가져오기
				noDataSeq = excelTestDao.getNoDataSeq();
				
				//noData 테이블의 seq와 no_seq 가져오기
				
				rowNoPackageUnit = noPackageUnit.getRow(i);
				//(엑셀 noPackageUnit sheet의 dNoseq == noData sheet의 seq) -> noPackageUnit insert 시작
				String dNoSeq = readCell(rowNoPackageUnit.getCell(0));
				if(dNoSeq.equals(readCell(rowNoData.getCell(0)))){
					rowNoPackageUnit = noPackageUnit.getRow(i);
					inputsNoPackageUnit = new HashMap<String, Object>();
					
					//포장재 개수가 1~5개로 제품마다 다름 -> null이 아닐 때에만 insert
					if(rowNoPackageUnit.getCell(1) != null){
						
						inputsNoPackageUnit = new HashMap<String, Object>();
						
						inputsNoPackageUnit.put("dNoSeq", noDataSeq);
						inputsNoPackageUnit.put("dataTempKey", readCell(rowNoPackageUnit.getCell(0)));
						inputsNoPackageUnit.put("packageUnit", readCell(rowNoPackageUnit.getCell(1)));
						
						//noPackageUnit 테이블에 데이터 insert
						excelTestDao.insertIntoNoPackageUnit(inputsNoPackageUnit);
						
						if(rowNoPackageUnit.getCell(2) != null){
							inputsNoPackageUnit = new HashMap<String, Object>();
							
							inputsNoPackageUnit.put("dNoSeq", noDataSeq);
							inputsNoPackageUnit.put("dataTempKey", readCell(rowNoPackageUnit.getCell(0)));
							inputsNoPackageUnit.put("packageUnit", readCell(rowNoPackageUnit.getCell(2)));
							
							//noPackageUnit 테이블에 데이터 insert
							excelTestDao.insertIntoNoPackageUnit(inputsNoPackageUnit);
							
							if(rowNoPackageUnit.getCell(3) != null){
								inputsNoPackageUnit = new HashMap<String, Object>();
								
								inputsNoPackageUnit.put("dNoSeq", noDataSeq);
								inputsNoPackageUnit.put("dataTempKey", readCell(rowNoPackageUnit.getCell(0)));
								inputsNoPackageUnit.put("packageUnit", readCell(rowNoPackageUnit.getCell(3)));
								
								//noPackageUnit 테이블에 데이터 insert
								excelTestDao.insertIntoNoPackageUnit(inputsNoPackageUnit);
								
								if(rowNoPackageUnit.getCell(4) != null){
									inputsNoPackageUnit = new HashMap<String, Object>();
									
									inputsNoPackageUnit.put("dNoSeq", noDataSeq);
									inputsNoPackageUnit.put("dataTempKey", readCell(rowNoPackageUnit.getCell(0)));
									inputsNoPackageUnit.put("packageUnit", readCell(rowNoPackageUnit.getCell(4)));
									
									//noPackageUnit 테이블에 데이터 insert
									excelTestDao.insertIntoNoPackageUnit(inputsNoPackageUnit);
									
									if(rowNoPackageUnit.getCell(5) != null){
										inputsNoPackageUnit = new HashMap<String, Object>();
										
										inputsNoPackageUnit.put("dNoSeq", noDataSeq);
										inputsNoPackageUnit.put("dataTempKey", readCell(rowNoPackageUnit.getCell(0)));
										inputsNoPackageUnit.put("packageUnit", readCell(rowNoPackageUnit.getCell(5)));
										
										//noPackageUnit 테이블에 데이터 insert
										excelTestDao.insertIntoNoPackageUnit(inputsNoPackageUnit);										
									}
								}
							}
						}
					}
				}
				*/
				/*
				rowNoMapping = noMapping.getRow(i);
				
				//(엑셀 noMapping sheet의  mNoSeq == no sheet의 no_seq) -> noMapping 테이블 insert 시작
				String mNoSeq = readCell(rowNoMapping.getCell(0));
				if(mNoSeq.equals(readCell(rowNo.getCell(0)))){
					inputsNoMapping = new HashMap<String, Object>();
					inputsNoMapping.put("mNoSeq", seq);
					inputsNoMapping.put("dNo", rowNoMapping.getCell(1).getNumericCellValue());
					inputsNoMapping.put("regUserId", rowNoMapping.getCell(2).getStringCellValue());
					
					//noMapping 테이블에 insert
					excelTestDao.insertIntoNoMapping(inputsNoMapping);
				}
				*/
			
		}
		
		rowLength = noMapping.getLastRowNum();
		for(int i = 1; i<rowLength; i++){
			rowNoMapping = noMapping.getRow(i);
			int tempKey = Integer.parseInt(readCell(rowNoMapping.getCell(0)));
			inputsNoMapping = new HashMap<String, Object>();
			inputsNoMapping.put("tempKey", tempKey);
			inputsNoMapping.put("mNoSeq", excelTestDao.selectSeq(tempKey)); 
			inputsNoMapping.put("dNo", rowNoMapping.getCell(1).getNumericCellValue());
			if(rowNoMapping.getCell(2)!=null){
				inputsNoMapping.put("regUserId", readCell(rowNoMapping.getCell(2)));
			};
			

			//noMapping 테이블에 insert
			excelTestDao.insertIntoNoMapping(inputsNoMapping);
			
			/*
			//mNoSeq(품보 key) update
			Integer tempKey = Integer.parseInt(readCell(rowNoMapping.getCell(0)));
			HashMap<String, Integer> map = new HashMap<>();
			map.put("mSeq", excelTestDao.selectSeq(tempKey));
			map.put("tempKey", tempKey);
			excelTestDao.updateNoMapping(map);
			*/
		}
		
		//포장재 데이터 입력
		insertPackage(wb);
	}
	
	
	
	
	
	@Override
	@Transactional(rollbackFor = Exception.class)
	public void readNo(XSSFSheet sheet) {
		map = new HashMap<Integer, HashMap<String, Object>>();
		int readNoCnt = 0;
		for(Row row : sheet){
			if(row.getRowNum()>0 && row.getRowNum()<=sheet.getLastRowNum()){
				inputs = new HashMap<String, Object>();
				/*
				for(Cell cell : row){
					
					switch(cell.getColumnIndex()){
					case 0 :
						inputs.put("seq", readCell(cell));
						System.out.println(readCell(cell));
						break;
					case 1 :
						inputs.put("companyCode", readCell(cell));
						System.out.println(readCell(cell));
						break;
					case 2 :
						inputs.put("plantCode", readCell(cell));
						System.out.println(readCell(cell));
						break;
					case 3 :
						inputs.put("manufacturingNo", readCell(cell));
						System.out.println(readCell(cell));
						break;
					case 4 :
						inputs.put("manufacturingName", readCell(cell));
						System.out.println(readCell(cell));
						break;
					case 5 :
						inputs.put("licensingNo", readCell(cell));
						System.out.println(readCell(cell));
						break;
					case 6 :
						inputs.put("status", readCell(cell));
						System.out.println(readCell(cell));
						break;
					case 7 :
						inputs.put("reportSDate", cell.getLocalDateTimeCellValue().toLocalDate());
						System.out.println(readCell(cell));
						break;
					case 8 :
						inputs.put("stopReqDate", cell.getLocalDateTimeCellValue().toLocalDate());
						System.out.println(readCell(cell));
						break;
					case 9 :
						inputs.put("stopDate", cell.getLocalDateTimeCellValue().toLocalDate());
						System.out.println(readCell(cell));
						break;
					}
				}
				*/
				
				
				//inputs.put("seq", readCell(row.getCell(0)));
				inputs.put("companyCode", readCell(row.getCell(1)));
				inputs.put("plantCode", readCell(row.getCell(2)));
				inputs.put("manufacturingNo", readCell(row.getCell(3)));
				inputs.put("manufacturingName", readCell(row.getCell(4)));
				inputs.put("licensingNo", readCell(row.getCell(5)));
				inputs.put("status", readCell(row.getCell(6)));
				if(row.getCell(7).getDateCellValue() != null && !row.getCell(7).getDateCellValue().equals("")){
					date = row.getCell(7).getLocalDateTimeCellValue().toLocalDate();
					inputs.put("reportSDate", date);
				};

				if(row.getCell(8).getDateCellValue() != null && !row.getCell(8).getDateCellValue().equals("")){
					date = row.getCell(8).getLocalDateTimeCellValue().toLocalDate();
					inputs.put("stopReqDate", date);
				};
				/*
				date = row.getCell(8).getLocalDateTimeCellValue().toLocalDate();
				//sqlDate = new Date(date.getYear(), date.getMonthValue(), date.getMonthValue());
				inputs.put("stopReqDate", date);
				*/
				
				if(row.getCell(row.getLastCellNum()-2).getDateCellValue() != null && !row.getCell(row.getLastCellNum()-2).getDateCellValue().equals("")){
					date = row.getCell(row.getLastCellNum()-2).getLocalDateTimeCellValue().toLocalDate();
					inputs.put("stopDate", date);
				};
				
				
				map.put(row.getRowNum()-1, inputs);
				readNoCnt ++;
				excelTestDao.insertIntoNo(inputs);
			}
		}
	}
	
	@Override
	@Transactional(rollbackFor = Exception.class)
	public void readNoData(XSSFSheet sheet) {
		int readNoCnt = 0;
		map = new HashMap<Integer, HashMap<String, Object>>();
		for(Row row : sheet){
			if(row.getRowNum()>0 && row.getRowNum()<=sheet.getLastRowNum()){
				inputs = new HashMap<String, Object>();
				inputs.put("seq", readCell(row.getCell(0)));
				inputs.put("no_seq", readCell(row.getCell(1)));
				inputs.put("productType1", readCell(row.getCell(2)));
				inputs.put("productType2", readCell(row.getCell(3)));
				inputs.put("productType3", readCell(row.getCell(4)));
				inputs.put("comment", readCell(row.getCell(5)));
				inputs.put("keepCondition", readCell(row.getCell(6)));
				inputs.put("keepConditionText", readCell(row.getCell(7)));
				inputs.put("sterilization", readCell(row.getCell(8)));
				inputs.put("sellDate1", readCell(row.getCell(9)));
				inputs.put("sellDate2", readCell(row.getCell(10)));
				inputs.put("sellDate3", readCell(row.getCell(11)));
				inputs.put("sellDate4", readCell(row.getCell(12)));
				inputs.put("sellDate5", readCell(row.getCell(13)));
				inputs.put("sellDate6", readCell(row.getCell(14)));
				inputs.put("referral", readCell(row.getCell(15)));
				inputs.put("createPlant", readCell(row.getCell(16)));
				inputs.put("oem", readCell(row.getCell(17)));
				inputs.put("oemText", readCell(row.getCell(18)));
				inputs.put("packageEtc", readCell(row.getCell(19)));
				inputs.put("regUserId", readCell(row.getCell(20)));
				
				map.put(row.getRowNum()-1, inputs);
				readNoCnt++;
				excelTestDao.insertIntoNoData(inputs);
			}
		}
	}
	
	@Override
	@Transactional(rollbackFor = Exception.class)
	public void readNoPackageUnit(XSSFSheet sheet) {
		map = new HashMap<Integer, HashMap<String, Object>>();
		int readNoCnt = 0;
		for(Row row : sheet){
			if(row.getRowNum()>0 && row.getRowNum()<=sheet.getLastRowNum()){
				inputs = new HashMap<String, Object>();
				inputs.put("dNoSeq", readCell(row.getCell(0)));
				inputs.put("packageUnit", readCell(row.getCell(1)));
				
				map.put(row.getRowNum()-1, inputs);
				readNoCnt++;
				excelTestDao.insertIntoNoPackageUnit(inputs);
			}
		}
	}
	@Override
	@Transactional(rollbackFor = Exception.class)
	public void readNoMapping(XSSFSheet sheet){
		map = new HashMap<Integer, HashMap<String, Object>>();
		int readNoCnt = 0;
		for(Row row : sheet){
			if(row.getRowNum()>0 && row.getRowNum()<=sheet.getLastRowNum()){
				inputs = new HashMap<String, Object>();
				inputs.put("mNoSeq", row.getCell(0).getNumericCellValue());
				inputs.put("dNo", row.getCell(1).getNumericCellValue());
				inputs.put("regUserId", row.getCell(2).getStringCellValue());
				
				map.put(row.getRowNum()-1, inputs);
				readNoCnt++;
				excelTestDao.insertIntoNoMapping(inputs);
			}
		}
	}
	/*오류 후 맵핑 테이블 시작 row 설정하고 인서트*/
	@Override
	public void insert(XSSFWorkbook wb, Integer startRow) {
		XSSFSheet noMapping = wb.getSheetAt(3);
		XSSFRow rowNoMapping;
		HashMap<String, Object> inputsNoMapping;
		
		int rowLength = noMapping.getLastRowNum();
		System.out.println("길이 : "+rowLength);
		for(int i = startRow; i<=rowLength; i++){
			rowNoMapping = noMapping.getRow(i);
			inputsNoMapping = new HashMap<String, Object>();
			int tempKey = Integer.parseInt(readCell(rowNoMapping.getCell(0)));
			inputsNoMapping.put("tempKey", tempKey);
			inputsNoMapping.put("mNoSeq", excelTestDao.selectSeq(tempKey)); //null이 허용되지 않으므로 허수를 채움. 다시 update 예정.
			inputsNoMapping.put("dNo", rowNoMapping.getCell(1).getNumericCellValue());
			inputsNoMapping.put("regUserId", readCell(rowNoMapping.getCell(2)));

			//noMapping 테이블에 insert
			excelTestDao.insertIntoNoMapping(inputsNoMapping);
			
			/*업데이트 안 해도 됨
			//mNoSeq(품보 key) update
			Integer tempKey = Integer.parseInt(readCell(rowNoMapping.getCell(0)));
			HashMap<String, Integer> map = new HashMap<>();
			map.put("mSeq", excelTestDao.selectSeq(tempKey));
			map.put("dNo", Integer.parseInt(readCell(rowNoMapping.getCell(1))));
			map.put("tempKey", tempKey);
			excelTestDao.updateNoMapping(map);
			*/
			
		}
	}

	//포장재 데이터 입력
	@Override
	public void insertPackage(XSSFWorkbook wb) {
		
		//manufacturingNoPackageUnit 테이블
		XSSFSheet noPackageUnit = wb.getSheetAt(2);
		HashMap<String, Object> inputsNoPackageUnit;
		Integer dataTempKey;
		Integer dNoSeq;
		HashMap<String, Object> update;
		
		for(int i = 1; i<=noPackageUnit.getLastRowNum(); i++){
			rowNoPackageUnit = noPackageUnit.getRow(i);
			
				rowNoPackageUnit = noPackageUnit.getRow(i);
				inputsNoPackageUnit = new HashMap<String, Object>();
				
				//포장재 개수가 1~5개로 제품마다 다름 -> null이 아닐 때에만 insert
				if(rowNoPackageUnit.getCell(1) != null && readCell(rowNoPackageUnit.getCell(1)) != null){
					
					inputsNoPackageUnit = new HashMap<String, Object>();
					dataTempKey = Integer.parseInt(readCell(rowNoPackageUnit.getCell(0)));
					//auto_increment 값을 나중에 맞추기 전에 허수 입력
					inputsNoPackageUnit.put("dNoSeq", excelTestDao.selectSeqFromNoData(dataTempKey));
					inputsNoPackageUnit.put("dataTempKey", readCell(rowNoPackageUnit.getCell(0)));
					inputsNoPackageUnit.put("packageUnit", readCell(rowNoPackageUnit.getCell(1)));
					//inputsNoPackageUnit.put("regUserId", readCell(rowNoPackageUnit.getCell(2)));
					
					//noPackageUnit 테이블에 데이터 insert
					excelTestDao.insertIntoNoPackageUnit(inputsNoPackageUnit);
					
					//auto_increment 값 업데이트
					dNoSeq = excelTestDao.selectSeqFromNoData(dataTempKey);
					update = new HashMap<String, Object>();
					update.put("dNoSeq", dataTempKey);
					update.put("dataTempKey", dataTempKey);
					
					
					if(rowNoPackageUnit.getCell(2) != null){
						inputsNoPackageUnit = new HashMap<String, Object>();

						inputsNoPackageUnit.put("dNoSeq", excelTestDao.selectSeqFromNoData(dataTempKey));
						inputsNoPackageUnit.put("dataTempKey", readCell(rowNoPackageUnit.getCell(0)));
						inputsNoPackageUnit.put("packageUnit", readCell(rowNoPackageUnit.getCell(2)));
						
						//noPackageUnit 테이블에 데이터 insert
						excelTestDao.insertIntoNoPackageUnit(inputsNoPackageUnit);
						
						if(rowNoPackageUnit.getCell(3) != null){
							inputsNoPackageUnit = new HashMap<String, Object>();

							inputsNoPackageUnit.put("dNoSeq", excelTestDao.selectSeqFromNoData(dataTempKey));
							inputsNoPackageUnit.put("dataTempKey", readCell(rowNoPackageUnit.getCell(0)));
							inputsNoPackageUnit.put("packageUnit", readCell(rowNoPackageUnit.getCell(3)));
							
							//noPackageUnit 테이블에 데이터 insert
							excelTestDao.insertIntoNoPackageUnit(inputsNoPackageUnit);
							
							if(rowNoPackageUnit.getCell(4) != null){
								inputsNoPackageUnit = new HashMap<String, Object>();

								inputsNoPackageUnit.put("dNoSeq", excelTestDao.selectSeqFromNoData(dataTempKey));
								inputsNoPackageUnit.put("dataTempKey", readCell(rowNoPackageUnit.getCell(0)));
								inputsNoPackageUnit.put("packageUnit", readCell(rowNoPackageUnit.getCell(4)));
								
								//noPackageUnit 테이블에 데이터 insert
								excelTestDao.insertIntoNoPackageUnit(inputsNoPackageUnit);
								
								if(rowNoPackageUnit.getCell(5) != null){
									inputsNoPackageUnit = new HashMap<String, Object>();

									inputsNoPackageUnit.put("dNoSeq", excelTestDao.selectSeqFromNoData(dataTempKey));
									inputsNoPackageUnit.put("dataTempKey", readCell(rowNoPackageUnit.getCell(0)));
									inputsNoPackageUnit.put("packageUnit", readCell(rowNoPackageUnit.getCell(5)));
									
									//noPackageUnit 테이블에 데이터 insert
									excelTestDao.insertIntoNoPackageUnit(inputsNoPackageUnit);										
								}
							}
						}
					}
				}
			
		}
		
		
		
	}

	
	
	

}
