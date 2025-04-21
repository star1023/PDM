package kr.co.aspn.dao;

import java.util.List;
import java.util.Map;

public interface Approval2Dao {
	
	List<Map<String, Object>> searchUser(Map<String, Object> param);

	int selectLineSeq();

	void insertApprLine(Map<String, Object> param) throws Exception;

	void insertApprLineItem(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> selectApprovalLine(Map<String, Object> param);

	List<Map<String, Object>> selectApprovalLineItem(Map<String, Object> param);

	void deleteApprLine(Map<String, Object> param) throws Exception;

	int selectApprSeq();

	void insertApprHeader(Map<String, Object> param) throws Exception;

	void insertApprItem(Map<String, Object> param) throws Exception;

	void insertReference(Map<String, Object> param) throws Exception;

	void updateStatus(Map<String, Object> param) throws Exception;

	int selectTotalCount(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> selectApprovalList(Map<String, Object> param) throws Exception;

	int selectMyApprTotalCount(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> selectMyApprList(Map<String, Object> param) throws Exception;

	int selectMyRefTotalCount(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> selectMyRefList(Map<String, Object> param) throws Exception;

	int selectMyCompTotalCount(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> selectMyCompList(Map<String, Object> param) throws Exception;

	Map<String, String> selectApprHeaderData(Map<String, Object> param);

	void updateApprStatus(Map<String, Object> param) throws Exception;

	void updateDocStatus(Map<String, Object> param) throws Exception;

	Map<String, String> selectDocData(Map<String, Object> param);

	List<Map<String, String>> selectApprItemList(Map<String, Object> param);

	List<Map<String, String>> selectReferenceList(Map<String, Object> param);

	void approvalSubmitItem(Map<String, Object> param) throws Exception;

	Map<String, Object> selectNextApprItem(Map<String, Object> param);

	void updateApprUser(Map<String, Object> map) throws Exception;

	Map<String, String> selectApprItem(Map<String, Object> param);

	void deleteApprItem(Map<String, String> param) throws Exception;

	void deleteApprHeader(Map<String, String> param) throws Exception;

	void deleteApprReference(Map<String, String> headerData) throws Exception;
}
