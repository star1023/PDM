package kr.co.aspn.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

public interface LabDataDao_back {
	public List<Map<String, Object>> getCodeList(@Param("groupCode")String groupCode);
	public List<Map<String, Object>> getCompanyList();
	public List<Map<String, Object>> getPlantList();
	public List<Map<String, Object>> getPlantLineList();
	public int getMaterialListPopupTotal(HashMap<String, Object> param);
	public List<Map<String, Object>> getMaterialListPopup(HashMap<String, Object> param);	
	public int insertMax(@Param("tbType")String tbType);
	public List<Map<String,Object>> userList();
	public List<Map<String, Object>> getStorageList(HashMap<String, Object> param);
	
}
