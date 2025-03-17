package kr.co.aspn.service;

import java.util.List;
import java.util.Map;

public interface BatchService {

	List<Map<String, String>> getStroage(String companyCode) throws Exception ;

	int setStroage(Map<String, String> map) throws Exception;

	List<Map<String, String>> getLine(String companyCode) throws Exception;

	List<Map<String, String>> getVendor(String companyCode, String startDate, String endDate) throws Exception;

	List<Map<String, String>> getMaterial(String companyCode, String startDate, String endDate) throws Exception;

	int setLine(Map<String, String> map) throws Exception;

	int setVendor(Map<String, String> map) throws Exception;

	int setMaterial(Map<String, String> map) throws Exception;

	void insertBatchLog(Map<String, String> logMap) throws Exception;

	List<Map<String, String>> getMaterialSample() throws Exception;

	int deleteMaterialSample() throws Exception;

	List<Map<String, String>> getStroage2(String companyCode) throws Exception;

	List<Map<String, String>> sellingMasterData() throws Exception;

	List<Map<String, String>> sellingData(String date, List<Map<String, String>> sellingMasterData) throws Exception;

	void updateProductName(Map<String, String> map) throws Exception;

	void batchUserLock();
}
