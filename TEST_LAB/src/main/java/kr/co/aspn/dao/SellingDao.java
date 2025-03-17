package kr.co.aspn.dao;

import java.util.List;
import java.util.Map;

import kr.co.aspn.vo.ProxyVO;

public interface SellingDao {

	int sellingDataCount(Map<String, Object> param) throws Exception;

	void insertMaster(Map<String, Object> param) throws Exception;

	int sellingMasterTotalCount(Map<String, Object> param) throws Exception;

	List<ProxyVO> sellingMasterList(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> sellingDataList(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> teamSellingDataList(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> deptSellingDataList(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> allSellingDataList(Map<String, Object> param) throws Exception;

	void deleteSellingData(Map<String, Object> param) throws Exception;

	void deleteSellingMaster(Map<String, Object> param) throws Exception;

	Map<String, Object> sellingMaster(Map<String, Object> param) throws Exception;

	void updateMaster(Map<String, Object> param) throws Exception;

	int sellingDataCountBySeq(Map<String, Object> param) throws Exception;

}
