package kr.co.aspn.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface RecordService {
	int insertHistory(HashMap<String,Object> param);

	public List<Map<String,Object>> getHistoryList(HashMap<String,Object> param);
	
	public List<Map<String,Object>> getHistoryListPrintExcel(HashMap<String,Object> param); 

}
