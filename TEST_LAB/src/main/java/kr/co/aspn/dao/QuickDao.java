package kr.co.aspn.dao;

import java.util.List;
import java.util.Map;

public interface QuickDao {

	int registQuick(Map<String, Object> param);

	List<Map<String, Object>> getQuickInfoList(Map<String, Object> param);

	int deleteQuickInfo(Map<String, Object> param);

}
