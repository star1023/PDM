package kr.co.aspn.service;


import java.util.List;
import java.util.Map;

public interface DevdocManagementService {

	List<Map<String, String>> devDocList(Map<String, Object> param) throws Exception;

	void userChange(String[] changeDocNo, String[] changeRegUserId, String targetUserId) throws Exception;

	List<Map<String,Object>> manufacturingProcessDocList(Map<String,Object> param) throws Exception;

	void userChangeMenuDoc(String[] changePNo, String[] changePNoRegUserId, String targetUserId) throws Exception;

	void launchDateUpdate(Map<String,Object> param);
}
