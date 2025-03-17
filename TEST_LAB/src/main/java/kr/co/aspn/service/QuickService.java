package kr.co.aspn.service;

import java.util.List;
import java.util.Map;

public interface QuickService {

	int registQuick(Map<String, Object> param);

	List<Map<String, Object>> getQuickInfoList(Map<String, Object> param);

	int deleteQuickInfo(Map<String, Object> param);

}
