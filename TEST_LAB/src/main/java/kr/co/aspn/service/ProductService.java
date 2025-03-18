package kr.co.aspn.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

public interface ProductService {

	String selectProductCode();

	Map<String, Object> selectMaterialList(Map<String, Object> param);

	List<Map<String, String>> checkMaterial(Map<String, Object> param);

	Map<String, Object> selectProductDataCount(Map<String, Object> param);

	void insertProduct(Map<String, Object> param, HashMap<String, Object> listMap, MultipartFile[] file) throws Exception;

	Map<String, Object> selectProductList(Map<String, Object> param)  throws Exception;

	Map<String, Object> selectProductData(Map<String, Object> param);

	List<Map<String, String>> selectProductMaterial(Map<String, Object> param);

	List<Map<String, String>> selectHistory(Map<String, Object> param);

	void insertNewVersionProduct(Map<String, Object> param, HashMap<String, Object> listMap, MultipartFile[] file) throws Exception;

	List<Map<String, String>> checkErpMaterial(Map<String, Object> param);

	Map<String, Object> selectErpMaterialData(Map<String, Object> param);

	int insertNewVersionCheck(Map<String, Object> param);

	Map<String, Object> selectSearchProduct(Map<String, Object> param);
}
