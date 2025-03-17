package kr.co.aspn.dao;

import java.util.List;
import java.util.Map;

public interface LogDao {

	int getLoginLogListTotal(Map<String, Object> param);
	List<Map<String, Object>> getLoginLogList(Map<String, Object> param);

	int getBomLogListTotal(Map<String, Object> param);
	List<Map<String, Object>> getBomLogList(Map<String, Object> param);
	
	int getCommonLogListTotal(Map<String, Object> param);
	List<Map<String, Object>> getCommonLogList(Map<String, Object> param);
	
	int getPrintLogListTotal(Map<String, Object> param);
	List<Map<String, Object>> getPrintLogList(Map<String, Object> param);
}
