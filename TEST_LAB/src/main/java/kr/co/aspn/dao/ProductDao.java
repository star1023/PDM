package kr.co.aspn.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface ProductDao {

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

	List<Map<String, String>> checkErpMaterial(Map<String, Object> param);

	Map<String, Object> selectErpMaterialData(Map<String, Object> param);

	int insertNewVersionCheck(Map<String, Object> param);

	List<Map<String, Object>> selectSearchProduct(Map<String, Object> param);

	void insertFileCopy(HashMap<String, Object> paramMap) throws Exception;
}
