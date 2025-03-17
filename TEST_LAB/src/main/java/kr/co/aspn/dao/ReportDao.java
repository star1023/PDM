package kr.co.aspn.dao;

import java.util.List;
import java.util.Map;

import kr.co.aspn.vo.ApprovalHeaderVO;
import kr.co.aspn.vo.ApprovalItemVO;
import kr.co.aspn.vo.ApprovalLineHeaderVO;
import kr.co.aspn.vo.ApprovalLineInfoVO;
import kr.co.aspn.vo.ReportVO;

public interface ReportDao {

	int reportCount(Map<String, Object> param) throws Exception;

	List<ReportVO> reportList(Map<String, Object> param) throws Exception;

	ReportVO reportData(Map<String, Object> param) throws Exception;

	void insert(ReportVO reportVO) throws Exception;

	void inserApprHeader(ApprovalHeaderVO apprvalHeaderVO) throws Exception;

	void inserApprLine(List<ApprovalItemVO> apprLineList) throws Exception;

	void updateState(Map<String, Object> param) throws Exception;

	void insertRefCirc(List<Map<String, Object>> refList) throws Exception;

	List<ApprovalItemVO> getAppr(String apprNo) throws Exception;

	List<Map<String, Object>> getRef(String apprNo) throws Exception;

	void update(ReportVO reportVO) throws Exception;

	void delete(String rNo) throws Exception;

	void insertReportBom(Map<String, Object> map) throws Exception;

	List<Map<String, Object>> reportBom(Map<String, Object> param) throws Exception;

	void deleteReportBom(Map<String, Object> param) throws Exception;

	void insertReportMix(Map<String, Object> map) throws Exception;

	void insertReportMixItem(Map<String, Object> map) throws Exception;

	void deleteReportMixItem(Map<String, Object> param) throws Exception;

	void deleteReportMix(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> reportMix(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> reportMixItem(Map<String, Object> param) throws Exception;

	List<Map<String, String>> getSubCategory(String category1);
}
