package kr.co.aspn.dao;

import java.util.List;
import java.util.Map;

import kr.co.aspn.vo.CodeItemVO;
import kr.co.aspn.vo.CompanyVO;
import kr.co.aspn.vo.FileVO;
import kr.co.aspn.vo.PlantLineVO;
import kr.co.aspn.vo.PlantVO;
import kr.co.aspn.vo.StorageVO;
import kr.co.aspn.vo.UnitVO;
import kr.co.aspn.vo.UserVO;

public interface CommonDao {
	
	List<PlantLineVO> getPlantLine(Map<String, Object> param);

	List<PlantVO> getPlant(Map<String, Object> param);

	List<CompanyVO> getCompany() throws Exception;

	List<UnitVO> getUnit() throws Exception;

	List<CodeItemVO> getCodeList(CodeItemVO code) throws Exception;

	List<Map<String, String>> searchUserId(Map<String, Object> param) throws Exception;

	List<Map<String, String>> getCodeListAjax(CodeItemVO code) throws Exception;

	int searchUserCount(Map<String, Object> param) throws Exception;

	List<UserVO> searchUserList(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> searchUserList2(Map<String, Object> param) throws Exception;
	
	int notificationCount(Map<String, String> param) throws Exception;
	
	List<Map<String, Object>> notificationList(Map<String, String> param) throws Exception;
	
	int updateNotification(Map<String, Object> param) throws Exception;

	void insertNotification(Map<String, Object> param) throws Exception;

	List<UserVO> getUserInfo(Map<String, Object> param) throws Exception;

	void insertPrintLog(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> docCount(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> docStateCount(Map<String, Object> param) throws Exception;

	List<StorageVO> getStorageList(Map<String, Object> param);
}
