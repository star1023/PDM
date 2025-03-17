package kr.co.aspn.dao;

import java.util.List;
import java.util.Map;

public interface DevdocManagementDao {

	List<Map<String, String>> devDocList(Map<String, Object> param) throws Exception;

	void userChange(Map<String, Object> param) throws Exception;

	void insertChangeLog(Map<String, Object> param) throws Exception;

	List<Map<String,Object>> manufacturingProcessDocList(Map<String,Object> param) throws Exception;

	List<Map<String, String>> menuDocList(Map<String, Object> param) throws Exception;

	public void launchDateUpdate(Map<String, Object> param);
	
	void userChangeMenuDoc(Map<String, Object> param) throws Exception;
}
