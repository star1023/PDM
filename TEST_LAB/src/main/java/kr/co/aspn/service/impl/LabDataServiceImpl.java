package kr.co.aspn.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.aspn.dao.LabDataDao;
import kr.co.aspn.service.LabDataService;
import kr.co.aspn.vo.LabPagingObject;
import kr.co.aspn.vo.LabPagingResult;
import kr.co.aspn.vo.LabSearchVO;

@Service
public class LabDataServiceImpl implements LabDataService {
	@Autowired
	LabDataDao dataDao;

	@Override
	public List<Map<String, Object>> getCodeList(String groupCode) {
		return dataDao.getCodeList(groupCode);
	}
	
	@Override
	public List<Map<String, Object>> getCompanyList() {
		return dataDao.getCompanyList();
	}
	
	@Override
	public List<Map<String, Object>> getPlantList() {
		return dataDao.getPlantList();
	}

	@Override
	public List<Map<String, Object>> getPlantLineList() {
		return dataDao.getPlantLineList();
	}

	@Override
	public int insertMax(String tbType) {
		return dataDao.insertMax(tbType);
	}

	@Override
	public LabPagingResult getMaterialListPopup(LabPagingObject page, LabSearchVO search) {
		LabPagingResult result = new LabPagingResult();
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("search", search);
		param.put("page", page);
		page.setTotalCount(dataDao.getMaterialListPopupTotal(param));
		result.setPage(page);
		result.setPagenatedList(dataDao.getMaterialListPopup(param));
		
		return result;
	}
	
	@Override
	public List<Map<String, Object>> userList() {
		// TODO Auto-generated method stub
		return dataDao.userList();
	}
	
	@Override
	public List<Map<String, Object>> getStorageList(String companyCode, String plantCode) {
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("companyCode", companyCode);
		param.put("plantCode", plantCode);
		
		return dataDao.getStorageList(param);
	}

	@Override
	public List<Map<String, Object>> userInfo(String userId) {
		// TODO Auto-generated method stub
		return dataDao.userInfo(userId);
	}

	@Override
	public String getUserInfo(String userId) {
		// TODO Auto-generated method stub
		
		String result = "";
		List<Map<String,Object>> list = dataDao.getUserInfo(userId);
		
		if(list.size() > 0) {
			result = (String)list.get(0).get("result");
		}
		
		return result;
	}
	
	@Override
	public Map<String, Object> countForState(String regUserId) {
		// TODO Auto-generated method stub
		return dataDao.countForState(regUserId);
	}
	
	@Override
	public List<Map<String, Object>> getMaterialList(String searchValue) {
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("searchValue", searchValue);
		return dataDao.getMaterialList(param);
	}
	
	@Override
	public Map<String, Object> getMaterialInfo(String imNo) {
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("imNo", imNo);
		return dataDao.getMaterialInfo(param);
	}
	
	@Override
	public List<Map<String, Object>> checkMaterial(String sapCode, String type, String plant, String company) {
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("sapCode", sapCode);
		param.put("type", type);
		param.put("plant", plant);
		param.put("company", company);
		return dataDao.checkMaterial(param);
	}
}
