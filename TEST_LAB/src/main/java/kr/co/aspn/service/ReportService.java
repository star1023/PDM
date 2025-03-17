package kr.co.aspn.service;

import java.util.Collection;
import java.util.List;
import java.util.Map;

import kr.co.aspn.vo.ApprovalItemVO;
import kr.co.aspn.vo.ApprovalLineHeaderVO;
import kr.co.aspn.vo.ApprovalLineInfoVO;
import kr.co.aspn.vo.CodeItemVO;
import kr.co.aspn.vo.ReportVO;

public interface ReportService {

	Map<String, Object> getList(Map<String, Object> param) throws Exception;

	Map<String, Object> reportData(Map<String, Object> param) throws Exception;

	List<Map<String, String>> getCategoryAjax(String categoryDiv, String categoryValue) throws Exception;

	void insert(ReportVO reportVO) throws Exception;

	void inserAppr(String[] apprUser, String[] refUser, String[] circUser, int rNo, String tbType, String regUserId,
			String title, String comment) throws Exception;

	List<ApprovalItemVO> apprInfoAjax(String apprNo) throws Exception;

	List<Map<String, Object>> refInfoAjax(String apprNo) throws Exception;

	void update(ReportVO reportVO) throws Exception;

	void delete(String rNo) throws Exception;

	void deleteFile(String rNo) throws Exception;

	void insertReportBom(Map<String,Object> param) throws Exception;

	void deleteReportBom(Map<String, Object> param) throws Exception;

	List<Map<String, String>> getSubCategory(String category1);

}
