package kr.co.aspn.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

public interface NewProductReportService {

	List<Map<String, String>> selectHistory(Map<String, Object> param);
	
	List<Map<String, Object>> searchNewProductResultListAjax(Map<String, Object> param);
	
	Map<String, Object> selectNewProductResultList(Map<String, Object> param) throws Exception;
	
	public int insertNewProductResult(Map<String, Object> param, List<List<Map<String, Object>>> resultItemArr, List<Map<String, Object>> itemImageArr, List<MultipartFile> imageFiles, MultipartFile[] file) throws Exception;
	
	public Map<String, Object> selectNewProductResultData(Map<String, Object> param);
	
	public List<Map<String, Object>> selectNewProductResultItemList(Map<String, Object> param);
	
	public List<Map<String, Object>> selectNewProductResultItemImageList(Map<String, Object> param);
	
	public int updateNewProductResult(Map<String, Object> param, List<List<Map<String, Object>>> resultItemArr, List<Map<String, Object>> itemImageArr, MultipartFile[] file, List<MultipartFile> imageFiles, List<String> deletedFileList) throws Exception;
}
