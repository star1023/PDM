package kr.co.aspn.dao;

import java.util.List;
import java.util.Map;

public interface ManualDao {

	int selectManualCount(Map<String, Object> param);

	List<Map<String, Object>> selectManualList(Map<String, Object> param);

}
