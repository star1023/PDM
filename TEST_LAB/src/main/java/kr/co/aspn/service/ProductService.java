package kr.co.aspn.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import kr.co.aspn.vo.FileVO;

public interface ProductService {

	String selectProductCode();

	Map<String, Object> selectMaterialList(Map<String, Object> param);

	List<Map<String, String>> checkMaterial(Map<String, Object> param);

	Map<String, Object> selectProductDataCount(Map<String, Object> param);

	int insertProduct(Map<String, Object> param, HashMap<String, Object> listMap, MultipartFile[] file) throws Exception;

	Map<String, Object> selectProductList(Map<String, Object> param)  throws Exception;

	Map<String, Object> selectProductData(Map<String, Object> param);

	List<Map<String, String>> selectProductMaterial(Map<String, Object> param);

	List<Map<String, String>> selectHistory(Map<String, Object> param);

	int insertNewVersionProduct(Map<String, Object> param, HashMap<String, Object> listMap, MultipartFile[] file) throws Exception;

	List<Map<String, String>> checkErpMaterial(Map<String, Object> param);

	Map<String, Object> selectErpMaterialData(Map<String, Object> param);

	int insertNewVersionCheck(Map<String, Object> param);

	Map<String, Object> selectSearchProduct(Map<String, Object> param);

	Map<String, Object> selectFileData(Map<String, Object> param);

	void deleteFileData(Map<String, Object> param) throws Exception;

	void updateProduct(Map<String, Object> param, HashMap<String, Object> listMap, MultipartFile[] file) throws Exception;

	int insertTmpProduct(Map<String, Object> param, HashMap<String, Object> listMap, MultipartFile[] file) throws Exception;

	List<Map<String, String>> selectAddInfo(Map<String, Object> param) throws Exception;

	List<Map<String, String>> selectNewDataList(Map<String, Object> param);

	void updateProductTmp(Map<String, Object> param, HashMap<String, Object> listMap, MultipartFile[] file) throws Exception;

	int insertNewVersionProductTmp(Map<String, Object> param, HashMap<String, Object> listMap, MultipartFile[] file) throws Exception;

	List<Map<String, String>> selectImporvePurposeList(Map<String, Object> param);

	Map<String, Object> selectAddInfoCount(Map<String, Object> param);
}
