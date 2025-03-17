package kr.co.aspn.dao;

import java.util.List;
import java.util.Map;

public interface BomDao {

	Boolean bomHeaderCheck(Map<String, Object> headerMap);

	Map<String, String> createBom(List<Map<String, Object>> bomItemList);

	Map<String, String> updateBom(Map<String, Object> headerMap);

	Map<String, String> updateBomItem(List<Map<String, Object>> bomItemList);

}
