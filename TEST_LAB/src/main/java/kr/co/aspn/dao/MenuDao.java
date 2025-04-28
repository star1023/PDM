package kr.co.aspn.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface MenuDao {

	String selectMenuCode();

	List<Map<String, String>> selectMaterialList(Map<String, Object> param);

	int selectMaterialCount(Map<String, Object> param);

	List<Map<String, String>> checkMaterial(Map<String, Object> param);

	int selectMenuDataCount(Map<String, Object> param);

	int selectMenuSeq();

	void insertMenu(Map<String, Object> param) throws Exception;

	void insertMenuMaterial(Map<String, Object> param) throws Exception;

	int selectMenuCount(Map<String, Object> param);

	List<Map<String, Object>> selectMenuList(Map<String, Object> param);

	Map<String, String> selectMenuData(Map<String, Object> param);

	List<Map<String, String>> selectMenuMaterial(Map<String, Object> param);

	List<Map<String, String>> selectHistory(Map<String, Object> param);

	void updateMenuIsLast(Map<String, Object> param) throws Exception;

	void insertNewVersionMenu(Map<String, Object> param) throws Exception;

	List<Map<String, String>> checkErpMaterial(Map<String, Object> param);

	Map<String, Object> selectErpMaterialData(Map<String, Object> param);

	int insertNewVersionCheck(Map<String, Object> param);

	List<Map<String, Object>> selectSearchMenu(Map<String, Object> param);

	void insertFileCopy(HashMap<String, Object> paramMap) throws Exception;

	Map<String, Object> selectFileData(Map<String, Object> param);

	void deleteFileData(Map<String, Object> param) throws Exception;

	void deleteMenuMaterial(Map<String, Object> param) throws Exception;

	void deleteFileType(HashMap<String, Object> map) throws Exception;

	void updateMenuData(Map<String, Object> param) throws Exception;

	void insertAddInfo(ArrayList<HashMap<String, Object>> addInfoList) throws Exception;

	List<Map<String, String>> selectAddInfo(Map<String, Object> param);

	void insertMenuNew(ArrayList<HashMap<String, Object>> newList) throws Exception;

	List<Map<String, String>> selectNewDataList(Map<String, Object> param);

	void deleteAddInfo(HashMap<String, Object> map) throws Exception;

	void deleteMenuNew(HashMap<String, Object> map) throws Exception;

	void insertMenuImporvePurpose(ArrayList<HashMap<String, Object>> imporvePurList) throws Exception;

	List<Map<String, String>> selectImporvePurposeList(Map<String, Object> param);

	Map<String, Object> selectAddInfoCount(Map<String, Object> param);

	void deleteMenuImporvePurpose(HashMap<String, Object> map) throws Exception;
}
