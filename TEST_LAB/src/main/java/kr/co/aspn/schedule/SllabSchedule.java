package kr.co.aspn.schedule;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import kr.co.aspn.service.BatchService;
import kr.co.aspn.service.CommonService;
import kr.co.aspn.service.UserService;
import kr.co.aspn.util.DateUtil;
import kr.co.aspn.util.StringUtil;
import kr.co.aspn.vo.CompanyVO;

public class SllabSchedule {
	
	private Logger logger = LoggerFactory.getLogger(SllabSchedule.class);
	
	@Autowired
	BatchService batchService;
	
	@Autowired
	CommonService commonService;
	
	@Autowired
	UserService userService;
	
	public void masterData() throws Exception {
		List<CompanyVO> companyList = commonService.getCompany();
		if( companyList != null ) {
			for( int i = 0 ; i  < companyList.size() ; i++ ) {
				CompanyVO companyVO =  companyList.get(i);
				if( companyVO.getCompanyCode() != null && "EG".equals(companyVO.getCompanyCode())) {
					continue;
				}
				//System.err.println(companyVO.getCompanyCode());
				
				String startDate = StringUtil.getDate(-7, "yyyyMMdd");
				String endDate = StringUtil.getDate(0, "yyyyMMdd");
				//logger.error("companyVO.getCompanyCode() {} : "+companyVO.getCompanyCode());
				
				// (2) 플랜트별 라인
				this.line(companyVO.getCompanyCode());
				// (3) 자재별 공급업체
				this.vendor(companyVO.getCompanyCode(), startDate, endDate );
				// (1) 플랜트별 저장위치
				this.storage(companyVO.getCompanyCode());
				// (4) 자재정보
				this.material(companyVO.getCompanyCode(), startDate, endDate);
			}
		}
	}
	
	public void storage( String companyCode ) throws Exception {
		List<Map<String, String>> storageList = batchService.getStroage2(companyCode);		
		int count = 0;
		int totalCount = 0;
		if( storageList != null ) {
			totalCount = storageList.size();
			for( int i = 0 ; i < storageList.size() ; i++ ) {
				Map<String, String> map = storageList.get(i);
				if( companyCode != null && "SN".equals(companyCode) && "8300".equals(map.get("WERKS")) ) {
					map.put("COMPANY", "EG");
				} else {
					map.put("COMPANY", companyCode);
				}
				int result = batchService.setStroage(storageList.get(i));
				count += result;
			}
			Map<String, String> logMap = new HashMap<String, String>();
			logMap.put("companyCode", companyCode);
			logMap.put("batchType", "storage");
			logMap.put("totalCount", ""+totalCount);
			logMap.put("successCount", ""+count);
			logMap.put("etcCount", "0");
			batchService.insertBatchLog(logMap);
		}
	}
	
	public void line( String companyCode ) throws Exception{
		List<Map<String, String>> lineList = batchService.getLine(companyCode);
		int totalCount = 0;
		int count = 0;
		if( lineList != null ) {
			totalCount = lineList.size();
			for( int i = 0 ; i < lineList.size() ; i++ ) {
				Map<String, String> map = lineList.get(i);
				if( companyCode != null && "SN".equals(companyCode) && "8300".equals(map.get("WERKS")) ) {
					map.put("COMPANY", "EG");
				} else {
					map.put("COMPANY", companyCode);
				}

				int result = batchService.setLine(lineList.get(i));
				count += result;
			}
			Map<String, String> logMap = new HashMap<String, String>();
			logMap.put("companyCode", companyCode);
			logMap.put("batchType", "line");
			logMap.put("totalCount", ""+totalCount);
			logMap.put("successCount", ""+count);
			logMap.put("etcCount", "0");
			batchService.insertBatchLog(logMap);
		}
	}
	
	public void vendor( String companyCode, String startDate, String endDate ) throws Exception{
		List<Map<String, String>> vendorList = batchService.getVendor(companyCode, startDate, endDate);
		int totalCount = 0;
		int count = 0;
		if( vendorList != null ) {
			totalCount = vendorList.size();
			for( int i = 0 ; i < vendorList.size() ; i++ ) {
				Map<String, String> map = vendorList.get(i);
				map.put("COMPANY", companyCode);
				int result = batchService.setVendor(vendorList.get(i));
				count += result;
			}
			System.err.println("companyCode  :  "+companyCode+"   vendorList.size()  :  "+vendorList.size()+"  count  :  "+count);
			Map<String, String> logMap = new HashMap<String, String>();
			logMap.put("companyCode", companyCode);
			logMap.put("batchType", "vendor");
			logMap.put("totalCount", ""+totalCount);
			logMap.put("successCount", ""+count);
			logMap.put("etcCount", "0");
			batchService.insertBatchLog(logMap);
		}
	}
	
	public void material( String companyCode, String startDate, String endDate ) throws Exception{
		List<Map<String, String>> materialList = batchService.getMaterial(companyCode, startDate, endDate);
		int totalCount = 0;
		int count = 0;
		int etcCount = 0;
		if( materialList != null ) {
			totalCount = materialList.size();
			for( int i = 0 ; i < materialList.size() ; i++ ) {
				Map<String, String> map = materialList.get(i);
				//map.put("COMPANY", companyCode);
				if( companyCode != null && "SN".equals(companyCode) && "8300".equals(map.get("WERKS")) ) {
					map.put("COMPANY", "EG");
				} else {
					map.put("COMPANY", companyCode);
				}
				map.put("user", "SYSTEM");
				String MATNR = map.get("MATNR");
				String WERKS = map.get("WERKS"); // PlantCode
				
				if( companyCode != null && "MD".equals(companyCode) ) {
					if( MATNR != null && (MATNR.startsWith("1") || MATNR.startsWith("4") || MATNR.startsWith("5")) ) {
						map.put("type","B");
					} else if( MATNR != null && MATNR.startsWith("2") ) {
						map.put("type","R");
					} else {
						map.put("type","");
						etcCount++;
						continue;
					}
				} else if (WERKS.equals("8400")){ // 공장무관 PlantCode가 청주(8400)이면 원료코드로 S201113-00004
					if( MATNR != null && (MATNR.startsWith("1") || MATNR.startsWith("3") || MATNR.startsWith("4")) ) {
						map.put("type","B");
					} else if( MATNR != null && MATNR.startsWith("5") ) {
						map.put("type","R");
					} else {
						map.put("type","");
						etcCount++;
						continue;
					}
				} else {
					if( MATNR != null && (MATNR.startsWith("3") || MATNR.startsWith("4") || MATNR.startsWith("170174") || MATNR.startsWith("170177") ) ) {
						map.put("type","B");
					} else if( MATNR != null && MATNR.startsWith("5") ) {
						map.put("type","R");
					} else {
						map.put("type","");
						etcCount++;
						continue;
					}
				}
				
				/*if( MATNR != null && (MATNR.startsWith("3") || MATNR.startsWith("4")) ) {
					map.put("type","B");
				} else if( MATNR != null && MATNR.startsWith("5") ) {
					map.put("type","R");
				} else {
					etcCount++;
					continue;
				}*/
				
				if(MATNR != null && (MATNR.equals("P001") || MATNR.equals("P10001"))){
					map.put("type","B");
				}
				
				String DEL = map.get("DEL");
				if( DEL != null && "X".equals(DEL) ) {
					map.put("isDelete", "Y");
				} else {
					map.put("isDelete", "N");
				}
				
				String TOSTA = map.get("TOSTA");
	            String PLSTA = map.get("PLSTA");
	            String status = "";
	            
	            if( (TOSTA != null && "X".equals(TOSTA)) || (PLSTA != null && "X".equals(PLSTA)) ) {
	               status = "X";
	            } 
	            map.put("status", status);
				
				int result = batchService.setMaterial(map);
				batchService.updateProductName(map);
				count += result;
			}
			Map<String, String> logMap = new HashMap<String, String>();
			logMap.put("companyCode", companyCode);
			logMap.put("batchType", "material");
			logMap.put("totalCount", ""+totalCount);
			logMap.put("successCount", ""+count);
			logMap.put("etcCount", ""+etcCount);
			batchService.insertBatchLog(logMap);
		}
	}
	
	public void delMaterialSample() throws Exception {
		List<Map<String, String>> materialList = batchService.getMaterialSample();
		int result = 0;
		if( materialList != null && materialList.size() > 0 ) {
			result = batchService.deleteMaterialSample();
		}
		Map<String, String> logMap = new HashMap<String, String>();
		logMap.put("companyCode", "");
		logMap.put("batchType", "delMaterialSample");
		logMap.put("totalCount", ""+materialList.size());
		logMap.put("successCount", ""+result);
		logMap.put("etcCount", ""+0);
		batchService.insertBatchLog(logMap);
	}
	
	public void sellingData() throws Exception {
		String date = DateUtil.getDate("yyyyMMdd");
		List<Map<String, String>> sellingMasterData = batchService.sellingMasterData();
		if( sellingMasterData != null && sellingMasterData.size() > 0  ) {
			batchService.sellingData(date, sellingMasterData);
		}
	}
	
	public void userLock(){
		batchService.batchUserLock();
	}
}
