package kr.co.aspn.service;

import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.RequestParam;

import kr.co.aspn.vo.ApprovalHeaderVO;
import kr.co.aspn.vo.ApprovalItemVO;
import kr.co.aspn.vo.ApprovalLineSaveVO;
import kr.co.aspn.vo.ApprovalRequestVO;

public interface ApprovalService {

	public Map<String,Object> getList(Map<String, Object> param) throws Exception;

	public Map<String,Object> approvalDetail(Map<String, Object> param) throws Exception;
	
	public List<Map<String,Object>> approvalLineList(Map<String,Object> param);

	public void deleteApprovalLineHeader(String apprLineNo);
	
	public void deleteApprovalLineInfo(String apprLineNo);

	public Map<String,Object> selectinsertApprovalLineHeader(HashMap<String,Object> param);

	public void insertApprovalLineInfo(HashMap<String,Object> param);
	
	public List<Map<String,Object>> selectRegUserInfo(Map<String,Object> param);
	
	public List<Map<String,Object>> keyData(String ddNo);

	public List<Map<String, Object>> detailApprovalLineList(Map<String, Object> param);

	public Map<String, Object> getApprList(Map<String, Object> param) throws Exception;

	public Map<String, Object> getRefrList(Map<String, Object> param) throws Exception;

	public Map<String, Object> apprCountInfo(Map<String, Object> param) throws Exception;

	public void sendArrpMail(Map<String, Object> param) throws Exception;

	public void sendRefMail(Map<String, Object> param) throws Exception;
	
	public void sendCircMail(Map<String, Object> param) throws Exception;

	public void deleteAppr(int apprNo) throws Exception;

	public String newApprovalSave(Map<String,Object> paramMap);
	
	public void approvalReferenceSave(String apprNo,String tbKey,String tbType,String title,String regUserId,String targetUserId,String link,String type);

	public String nextApprovalUserInfoText(String nextUserId,String tbType);
	
	public List<Map<String,Object>> nextApprovalBoxInfo(String apprNo,String currentStep);

	public void approvalBoxHeaderUpdate(String apprNo, String currentStep, String currentUserId);

	public void approvalBoxHeaderLinkUpdate(String link, String apprNo, String tbKey, String tbType);
	
	public List<Map<String,Object>> getDetailApprovalLineList(String apprLineNo);

	public void reAppr(@RequestParam Map<String, Object> param) throws Exception;

	public void approvalSubmit(Map<String, Object> param) throws Exception;

	public void approvalReject(Map<String, Object> param) throws Exception;
	
	public List<Map<String,Object>> getApprNo(Map<String,Object> param);

	public ApprovalItemVO apprItemInfoByApbNo(Map<String, Object> param) throws Exception;

	public Map<String, Object> getDocData(Map<String, Object> param) throws Exception;

	public ApprovalHeaderVO printConfirmData(Map<String, Object> param) throws Exception;

	public void printRequest(Map<String, Object> param) throws Exception;

	void deleteApprList(String docNo, String docVersion) throws Exception;

	public List<Map<String, Object>> apprCountType(Map<String, Object> param) throws Exception;

	public List<Map<String, Object>> myCountType(Map<String, Object> param) throws Exception;

	public Map<String, Object> refListCount(Map<String, Object> param) throws Exception;

	public void approvalStateUpdate(Map<String, Object> map) throws Exception;
	
	public void approvalLineDelete(String apprLineNo) throws Exception;

	public int countReviewDoc(Map<String, Object> param) throws Exception;

	public Map<String, Object> getAppringList(Map<String, Object> param) throws Exception;
	
	public List<ApprovalItemVO> apprItemInfoExcel(Map<String,Object> param);

	public Map<String, Object> approvalLineSave(ApprovalLineSaveVO vo);

	public Map<String, Object> approvalRequest(ApprovalRequestVO vo);

	public Map<String, Object> approvalProductDesign(ApprovalRequestVO vo);
	
	public int countPrint(Map<String, Object> param) throws Exception;

    int isApprExsiste(Map<String, Object> param);

	public Map<String, Object> approvalDetail2(Map<String, Object> param) throws Exception;
}

//<!-- Builder 개발서버 반영 원복 재실행을 위한 주석 추가 -->