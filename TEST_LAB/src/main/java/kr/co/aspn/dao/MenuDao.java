package kr.co.aspn.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface MenuDao {

	String selectProductCode();

	List<Map<String, String>> selectMaterialList(Map<String, Object> param);

	int selectMaterialCount(Map<String, Object> param);

	List<Map<String, String>> checkMaterial(Map<String, Object> param);

	int selectProductDataCount(Map<String, Object> param);

	int selectProductSeq();

	void insertProduct(Map<String, Object> param) throws Exception;

	void insertProductMaterial(Map<String, Object> param) throws Exception;

	int selectProductCount(Map<String, Object> param);

	List<Map<String, Object>> selectProductList(Map<String, Object> param);

	Map<String, String> selectProductData(Map<String, Object> param);

	List<Map<String, String>> selectProductMaterial(Map<String, Object> param);

	List<Map<String, String>> selectHistory(Map<String, Object> param);

	void updateProduct(Map<String, Object> param) throws Exception;

	void insertNewVersionProduct(Map<String, Object> param) throws Exception;

	int selectMenuCount(Map<String, Object> param);

	List<Map<String, Object>> selectMenuList(Map<String, Object> param);

	int selectMenuDataCount(Map<String, Object> param);

	int selectMenuSeq();

	void insertMenu(Map<String, Object> param) throws Exception;

	void insertMenuMaterial(Map<String, Object> param) throws Exception;

	List<Map<String, String>> selectMenuHistory(Map<String, Object> param);

	Map<String, String> selectMenuData(Map<String, Object> param);

	List<Map<String, String>> selectMenuMaterial(Map<String, Object> param);

	void updateMenuVersion(Map<String, Object> param) throws Exception;

	void insertNewVersionMenu(Map<String, Object> param) throws Exception;

	void insertCookManual(Map<String, Object> param);

	List<Map<String, String>> checkErpMaterial(Map<String, Object> param);

	Map<String, Object> selectErpMaterialData(Map<String, Object> param);

	int insertNewVersionCheck(Map<String, Object> param);

	List<Map<String, Object>> selectSearchProduct(Map<String, Object> param);

	void insertFileCopy(HashMap<String, Object> paramMap) throws Exception;

	List<Map<String, Object>> searchUser(Map<String, Object> param);

	int selectLineSeq();

	void insertApprLine(Map<String, Object> param) throws Exception;

	void insertApprLineItem(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> selectApprovalLine(Map<String, Object> param);

	List<Map<String, Object>> selectApprovalLineItem(Map<String, Object> param);

	void deleteApprLine(Map<String, Object> param) throws Exception;

	int selectApprSeq();

}
