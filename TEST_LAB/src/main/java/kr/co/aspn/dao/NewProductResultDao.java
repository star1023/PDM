package kr.co.aspn.dao;

import java.util.List;
import java.util.Map;

public interface NewProductResultDao {

	List<Map<String, String>> selectHistory(Map<String, Object> param);
	
	List<Map<String, Object>> searchNewProductResultListAjax(Map<String, Object> param);

	int selectNewProductResultCount(Map<String, Object> param);

	List<Map<String, Object>> selectNewProductResultList(Map<String, Object> param);
	
	int selectNewProductResultSeq();
	
	int selectNewProductResultItemSeq();
	
	int selectNewProductResultItemImageSeq();
	
	public void insertNewProductResult(Map<String, Object> param) throws Exception;
	
	public void insertNewProductResultItems(List<Map<String, Object>> itemList) throws Exception;
	
	public void insertNewProductResultItemImage(List<Map<String, Object>> itemList) throws Exception;
	
	public Map<String, String> selectNewProductResultData(Map<String, Object> param);
	
	public List<Map<String, Object>> selectNewProductResultItemList(Map<String, Object> param);
	
	public List<Map<String, Object>> selectNewProductResultItemImageList(Map<String, Object> param);
	
	public void updateNewProductResult(Map<String, Object> param);
	
	public void deleteNewProductResultItems(Map<String, Object> param);

	public void deleteNewProductResultItemImages(Map<String, Object> param);
	
	public List<Map<String, Object>> selectNewProductResultItemImages(Map<String, Object> param);
	
	public void deleteNewProductResultItemImageByRow(Map<String, Object> param);
}
