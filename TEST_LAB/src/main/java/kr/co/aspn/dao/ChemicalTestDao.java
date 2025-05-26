package kr.co.aspn.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface ChemicalTestDao {

	List<Map<String, String>> selectHistory(Map<String, Object> param);
	
	int selectChemicalTestCount(Map<String, Object> param);
	
	List<Map<String, Object>> selectChemicalTestList(Map<String, Object> param);

	int selectChemicalTestSeq();
	
	int selectChemicalTestItemSeq();
	
	void insertChemicalTest(Map<String, Object> param) throws Exception;
	
	void insertChemicalTestItem(ArrayList<HashMap<String,Object>> param) throws Exception;
	
	void insertChemicalTestStandard(ArrayList<HashMap<String,Object>> param) throws Exception;
	
	Map<String, String> selectChemicalTestData(Map<String, Object> param);
	
	List<Map<String, Object>> selectChemicalTestItemData(Map<String, Object> param);
	
	List<Map<String, Object>> selectChemicalTestStandardList(Map<String, Object> param);
	
	List<Map<String, Object>> searchChemicalTestList(Map<String, Object> param);
	
	void updateChemicalTest(Map<String, Object> param);
	
	void deleteChemicalTestItems(Map<String, Object> param);
	
	void deleteChemicalTestStandards(Map<String, Object> param);
}
