package kr.co.aspn.service.impl;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;

import kr.co.aspn.dao.BomDao;
import kr.co.aspn.dao.MaterialDao;
import kr.co.aspn.dao.RfcDao;
import kr.co.aspn.service.CommonService;
import kr.co.aspn.service.MaterialService;
import kr.co.aspn.util.PageNavigator;
import kr.co.aspn.vo.CompanyVO;
import kr.co.aspn.vo.MaterialChangeVO;
import kr.co.aspn.vo.MaterialManagementItemVO;
import kr.co.aspn.vo.MaterialManagementVO;
import kr.co.aspn.vo.MaterialVO;
import kr.co.aspn.vo.PlantVO;

@Service
public class MaterialServiceImpl implements MaterialService {
	Logger logger = LoggerFactory.getLogger(MaterialServiceImpl.class);
	
	@Resource
	DataSourceTransactionManager txManager;
	
	@Autowired 
	MaterialDao materialDao;
	
	@Autowired
	CommonService commonService;
	
	@Autowired
	RfcDao rfcDao;
	
	@Override
	public Map<String, Object> getMaterialList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		//자재코드 전체 수
		int totalCount = materialDao.materialTotalCount(param);
		
		int viewCount = 0;
		try {
			viewCount = Integer.parseInt(param.get("viewCount").toString());
		} catch( Exception e ) {
			viewCount = 10;
		}
		// 페이징: 페이징 정보 SET
		PageNavigator navi = new PageNavigator(param, viewCount, totalCount);
		
		List<MaterialVO> materialList = materialDao.materialList(param);
		
		List<CompanyVO> companyList = commonService.getCompany(); 
		//List<PlantVO> plantList = commonService.getPlant(param);
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("company", companyList);
		//map.put("plant", plantList);
		map.put("totalCount", totalCount);
		map.put("materialList", materialList);
		map.put("navi", navi);
		
		System.err.println("param  :  "+param);
		map.put("paramVO", param);

		return map;
	}

	@Override
	public Map<String, Object> insertForm()  throws Exception {
		// TODO Auto-generated method stub
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("company", commonService.getCompany());
		map.put("unit", commonService.getUnit());
		return map;
	}

	@Override
	public int materialCountAjax(Map<String, Object> param)  throws Exception{
		// TODO Auto-generated method stub
		return materialDao.materialCountAjax(param);
	}

	@Override
	public int insert(MaterialVO materialVO) throws Exception {
		// TODO Auto-generated method stub
		return materialDao.insert(materialVO);
	}

	@Override
	public int countByKey(String imNo) throws Exception {
		// TODO Auto-generated method stub
		return materialDao.countByKey(imNo);
	}

	@Override
	public void deleteAjax(String imNo) throws Exception {
		// TODO Auto-generated method stub
		materialDao.deleteAjax(imNo);
	}

	@Override
	public int usedCount(String imNo) throws Exception {
		// TODO Auto-generated method stub
		return materialDao.usedCount(imNo);
	}

	@Override
	public void hiddenAjax(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		
		materialDao.hiddenAjax(param);
	}

	@Override
	public Map<String, Object> popupCallForm() throws Exception {
		// TODO Auto-generated method stub
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("company", commonService.getCompany());
		return map;
	}

	@Override
	public int rfcCallAjax(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		
		return 0;
	}

	@Override
	public List<Map<String, String>> callRfc(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return materialDao.callRfc(param);
	}

	@Override
	public void insertErpData(Map<String, String> map) throws Exception {
		// TODO Auto-generated method stub
		String company = map.get("company");
		String MATNR = map.get("MATNR");
		String WERKS = map.get("WERKS");
		if( company != null && "MD".equals(company.toUpperCase()) ) {
			if( MATNR != null && (MATNR.startsWith("1") || MATNR.startsWith("4") || MATNR.startsWith("5")) ) {
				map.put("type","B");
			} else if( MATNR != null && MATNR.startsWith("2") ) {
				map.put("type","R");
			} else {
				map.put("type","");
			}
		} else if (WERKS.equals("8400")){ // 공장무관 PlantCode가 청주(8400)이면 원료코드로 S201113-00004
			if( MATNR != null && (MATNR.startsWith("1") || MATNR.startsWith("3") || MATNR.startsWith("4")) ) {
				map.put("type","B");
			} else if( MATNR != null && MATNR.startsWith("5") ) {
				map.put("type","R");
			} else {
				map.put("type","");
			}
		} else {
			if( MATNR != null && (MATNR.startsWith("3") || MATNR.startsWith("4")  || MATNR.startsWith("170174") || MATNR.startsWith("170177")) ) {
				map.put("type","B");
			} else if( MATNR != null && MATNR.startsWith("5") ) {
				map.put("type","R");
			} else {
				map.put("type","");
			}
		}
		
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
		
		materialDao.insertErpData(map);
	}

	@Override
	public Map<String, Object> materialData(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		MaterialVO materialVO = materialDao.materialData(param);
		
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("materialVO", materialVO);
		map.put("paramVO", param);

		return map;
	}

	@Override
	public int update(MaterialVO materialVO) throws Exception {
		// TODO Auto-generated method stub
		return materialDao.update(materialVO);
	}

	@Override
	public Map<String, Object> getItemList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		//자재코드 전체 수
		int totalCount = materialDao.itemTotalCount(param);
		
		int viewCount = 0;
		try {
			viewCount = Integer.parseInt(param.get("viewCount").toString());
		} catch( Exception e ) {
			viewCount = 10;
		}
		// 페이징: 페이징 정보 SET
		PageNavigator navi = new PageNavigator(param, viewCount, totalCount);
		
		List<Map<String, Object>> materialList = materialDao.itemList(param);
		
		List<CompanyVO> companyList = commonService.getCompany(); 
		//List<PlantVO> plantList = commonService.getPlant(param);
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("company", companyList);
		//map.put("plant", plantList);
		map.put("totalCount", totalCount);
		map.put("materialList", materialList);
		map.put("navi", navi);
		
		System.err.println("param  :  "+param);
		map.put("paramVO", param);

		return map;
	}
	
	@Override
	public Map<String, Object> getMateriaManegementlList(Map<String, Object> param) throws Exception {
		//자재코드 전체 수
		int totalCount = materialDao.materialMenagementTotalCount(param);
		
		int viewCount = 0;
		try {
			viewCount = Integer.parseInt(param.get("viewCount").toString());
		} catch( Exception e ) {
			viewCount = 10;
		}
		// 페이징: 페이징 정보 SET
		PageNavigator navi = new PageNavigator(param, viewCount, totalCount);
		
		List<MaterialManagementVO> materialManagementList = materialDao.materialMenagementList(param);
		
		List<CompanyVO> companyList = commonService.getCompany(); 
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("company", companyList);
		//map.put("plant", plantList);
		map.put("totalCount", totalCount);
		map.put("materialManagementList", materialManagementList);
		
		map.put("navi", navi);
		
		System.err.println("param  :  "+param);
		map.put("paramVO", param);

		return map;
	}
	
	@Override
	public String addMaterialChange(Map<String, Object> mtchMap, MaterialChangeVO itemVO) {
		
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		TransactionStatus status = null;
		
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRES_NEW);
		status = txManager.getTransaction(def);
		
		try {
			int insertHeaderCnt = materialDao.insertMaterialManagement(mtchMap);
			//int mmNo = (int) mtchMap.get("mmNo");
			int mmNo = Integer.parseInt(""+mtchMap.get("mmNo"));
			
			if(insertHeaderCnt > 0) {
				
				for (MaterialManagementItemVO item : itemVO.getItemList()) {
					item.setMmNo(mmNo);
					item.setRegUserId((String)mtchMap.get("regUserId"));
					materialDao.insertMaterialManagementItem(item);
				}
				
				txManager.commit(status);
				return "S";
			} else {
				txManager.rollback(status);
				return "F";
			}
		} catch (Exception e) {
			logger.error(e.getMessage());
			e.printStackTrace();
			txManager.rollback(status);
			return "F";
		}
	}
	
	@Override
	public Map<String, Object> getBomListOfMaterial(Map<String, Object> param) {
		Map<String, Object> bomList = rfcDao.getBomListOfMaterial(param);
		Map<String, List<Map<String, Object>>> tableList = (Map<String, List<Map<String, Object>>>) bomList.get("tables");
		Iterator<String> tableItr = tableList.keySet().iterator();
		while (tableItr.hasNext()) {
			String tableName = (String) tableItr.next();
			List<Map<String, Object>> tableItem = tableList.get(tableName);
			for (Map<String, Object> map : tableItem) {
				
				String MATNR = (String)map.get("MATNR");
				if(MATNR.length() > 6) {
					map.remove("MATNR");
					map.put("MATNR", MATNR.substring(12));
				}
				
				String dNoList = materialDao.getDNoList(map);
				map.put("dNoList", dNoList);
			}
		}
		return bomList;
	}
	
	@Override
	public Map<String, Object> getChangeRequestDetail(String mmNo) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("mmNo", mmNo);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("mmHeader", materialDao.getChangeRequestHeader(param));
		resultMap.put("mmItemList", materialDao.getChangeRequestItem(param));
		
		return resultMap;
	}
	
	@Override
	public Map<String, Object> changeBomList(Map<String, Object> param) {
		
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		TransactionStatus status = null;
		
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRES_NEW);
		status = txManager.getTransaction(def);
		
		try {
			String mmNo = (String)param.get("mmNo");
			param.put("forRFC", "Y");
			
			Map<String, Object> mmHeader = materialDao.getChangeRequestHeader(param);
			List<Map<String, Object>> mmItemList = materialDao.getChangeRequestItem(param);
			
			
			String I_MATNR_B = (String)mmHeader.get("preSapCode");
			String I_MATNR_A = (String)mmHeader.get("postSapCode");
			String I_WERKS = (String)mmHeader.get("plant");
			String I_STLAL = (String)mmHeader.get("posnr");
			String companyCode = (String)mmHeader.get("companyCode");
			
			Map<String, Object> importDataMap = new HashMap<String, Object>();
			
			importDataMap.put("I_MATNR_B", I_MATNR_B);
			importDataMap.put("I_MATNR_A", I_MATNR_A);
			importDataMap.put("I_WERKS", I_WERKS);
			importDataMap.put("companyCode", companyCode);
			
			//List<String> MATNR_LIST = new ArrayList<String>();
			List<Map<String, Object>> IT_MATNR = new ArrayList<Map<String,Object>>();
			
			for (Map<String, Object> mmItem : mmItemList) {
				String MATNR = (String)mmItem.get("productCode");
				String STLAL = (String)mmItem.get("posnr");
				HashMap<String, Object> tableMap = new HashMap<String, Object>();
				
				tableMap.put("MATNR", MATNR);
				tableMap.put("STLAL", STLAL);
				
				//MATNR_LIST.add(MATNR);
				IT_MATNR.add(tableMap);
			}
			
			importDataMap.put("IT_MATNR", IT_MATNR);
			
			Map<String, Object> rfcResult = rfcDao.changeBomItem(importDataMap);
			Map<String, Object> tableMap = (Map<String, Object>)rfcResult.get("tables");
			List<Map<String, Object>> IT_RETURN_LIST = (List<Map<String, Object>>) tableMap.get("IT_RETURN");
			
			int rfcSuccessCnt = 0;
			int rfcFailCnt = 0;
			
			for (Map<String, Object> IT_RETURN : IT_RETURN_LIST) {
				String RFC_MATNR = (String)IT_RETURN.get("MATNR");
				RFC_MATNR = RFC_MATNR.length() > 6 ? RFC_MATNR.substring(12) : RFC_MATNR;
				
				String RFC_WERKS = (String)IT_RETURN.get("WERKS");
				String RFC_STLAL = (String)IT_RETURN.get("STLAL");
				String RFC_IDNRK = (String)IT_RETURN.get("IDNRK");
				String RFC_MESSAGE = (String)IT_RETURN.get("MESSAGE");
				String RFC_COM = (String)IT_RETURN.get("COM");
				
				
				HashMap<String, Object> mmItemParam = new HashMap<String, Object>();
				mmItemParam.put("modUserId", param.get("modUserId"));
				
				mmItemParam.put("MATNR", RFC_MATNR);
				mmItemParam.put("WERKS", RFC_WERKS);
				mmItemParam.put("STLAL", RFC_STLAL);
				mmItemParam.put("IDNRK", RFC_IDNRK);
				mmItemParam.put("MESSAGE", RFC_MESSAGE);
				mmItemParam.put("COM", RFC_COM);
				mmItemParam.put("mmNo", mmHeader.get("mmNo"));
				
				mmItemParam.put("MATNR_A", I_MATNR_A);
				mmItemParam.put("MATNR_B", I_MATNR_B);
				mmItemParam.put("companyCode", companyCode);
				mmItemParam.put("modUserId", mmHeader.get("modUserId"));
				
				if("S".equals(RFC_COM)) {
					mmItemParam.put("state", "4");
				} else {
					mmItemParam.put("state", "5");
					rfcFailCnt++;
				}
				
				// update 후 selectKey 값으로 miNo 값을 mmItemParam 에 리턴받음
				int updateCnt = materialDao.updateMMItemState(mmItemParam);
				
				if (updateCnt > 0 && "S".equals(RFC_COM)) {
					rfcSuccessCnt++;
					
					String miNo = (String)mmItemParam.get("miNo");
					
					try {
						int dNoListCnt = materialDao.getDNoListCnt(miNo);
						if(dNoListCnt > 0 ) {
							int mmItemUpdateCnt = materialDao.updateMfgItemBom(mmItemParam);
							
							// 연관제조공정서 update count 가 0보다 크면 정상 "4" 아니면 오류 "5"
							if( mmItemUpdateCnt > 0 ) {
								mmItemParam.put("mfgState", "4");
								materialDao.updateMMItemMfgState(mmItemParam);
							} else {
								mmItemParam.put("mfgState", "5");
								materialDao.updateMMItemMfgState(mmItemParam);
							}
						} 
					} catch (Exception e) {
						logger.debug(e.getMessage(), e);
						
						mmItemParam.put("mfgState", "9");
						materialDao.updateMMItemMfgState(mmItemParam);
					}
				}
			}
			
			materialDao.updateMMItemExcept(mmHeader);
			
			if(rfcFailCnt > 0) {
				param.put("state", "5");
				rfcResult.put("state", "5");
			} else {
				param.put("state", "4");
				rfcResult.put("state", "4");
			}
			materialDao.updateMMState(param);
			txManager.commit(status);
			
			return rfcResult;
		} catch (Exception e) {
			logger.error(e.getMessage());
			e.printStackTrace();
			txManager.rollback(status);
			
			Map<String, Object> errResultMap = new HashMap<String, Object>();
			
			errResultMap.put("state", "99");
			
			return errResultMap;
		}
		
	}
	
	private String logMapItem(Map<String, Object> map) {
		Iterator<String> mapItr = map.keySet().iterator();
		String logStr = " ========= MapItem Logs ========";
		while (mapItr.hasNext()) {
			String key = mapItr.next();
			logStr += "\n " + key + ":\t " + map.get(key);
		}
		return logStr;
	}
	
	@Override
	public Map<String, Object> getMmHeader(Map<String, Object> param) {
		return materialDao.getMmHeader(param);
	}
}

//<!-- Builder 개발서버 반영 원복 재실행을 위한 주석 추가 -->