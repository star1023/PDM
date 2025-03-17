package kr.co.aspn.service;

import java.util.List;
import java.util.Map;

public interface SellingService {

	Map<String, Object> sellingMasterList(Map<String, Object> param) throws Exception;

	Map<String, Object> insertMaster(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> sellingDataList(Map<String, Object> param) throws Exception;

	void deleteSellingData(Map<String, Object> param) throws Exception;

	Map<String, Object> sellingMaster(Map<String, Object> param) throws Exception;

	Map<String, Object> updateMaster(Map<String, Object> param) throws Exception;

}
