package kr.co.aspn.service;

import java.util.List;
import java.util.Map;

import kr.co.aspn.vo.LabPagingObject;
import kr.co.aspn.vo.LabPagingResult;
import kr.co.aspn.vo.LabSearchVO;

public interface LabDataService {
	public List<Map<String, Object>> getCodeList(String groupCode);
	public List<Map<String, Object>> getCompanyList();
	public List<Map<String, Object>> getPlantList();
	public List<Map<String, Object>> getPlantLineList();
	public LabPagingResult getMaterialListPopup(LabPagingObject page, LabSearchVO search);
	public int insertMax(String tbType);
	public List<Map<String, Object>> getStorageList(String companyCode, String plantCode);
	List<Map<String, Object>> userList();
	public List<Map<String,Object>> userInfo(String userId);
	public String getUserInfo(String userId);
	public Map<String,Object> countForState(String regUserId);
	public List<Map<String, Object>> getMaterialList(String searchValue);
	public Map<String,Object> getMaterialInfo(String imNo);
	public List<Map<String, Object>> checkMaterial(String sapCode, String type, String plant, String company);
}
