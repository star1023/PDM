package kr.co.aspn.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import kr.co.aspn.vo.ApprovalHeaderVO;
import kr.co.aspn.vo.ApprovalItemVO;
import kr.co.aspn.vo.ApprovalReferenceVO;

public interface ApprovalDao {

	public int apporvalDocCount(Map<String, Object> param) throws Exception;

	public List<ApprovalHeaderVO> approvalDocList(Map<String, Object> param) throws Exception;

	public ApprovalHeaderVO apprHeaderInfo(Map<String, Object> param) throws Exception;

	public List<ApprovalItemVO> apprItemInfo(Map<String, Object> param) throws Exception;
	
	public List<ApprovalItemVO> apprItemInfoExcel(Map<String, Object> param) throws Exception;

	public List<ApprovalReferenceVO> apprReferenceInfo(Map<String, Object> param) throws Exception;

	public String printRequest(ApprovalHeaderVO apprItemHeader) throws Exception;

	public int proxyInfo(Map<String, Object> param) throws Exception;

	public List<Map<String,Object>> approvalLineList(Map<String,Object> param);
	
	public void deleteApprovalLineHeader(@Param("apprLineNo") String apprLineNo);
	
	public void deleteApprovalLineInfo(@Param("apprLineNo") String apprLineNo);
	
	public Map<String,Object> selectinsertApprovalLineHeader(HashMap<String,Object> param);

	public void insertApprovalLineInfo(HashMap<String,Object> param);
	
	public List<Map<String,Object>> selectRegUserInfo(Map<String,Object> param);
	
	public List<Map<String,Object>> keyData (@Param("ddNo") String ddNo);

	public List<Map<String, Object>> detailApprovalLineList(Map<String, Object> param);

	public int apporvalListCount(Map<String, Object> param) throws Exception;

	public List<ApprovalHeaderVO> apporvalList(Map<String, Object> param) throws Exception;

	public int refListCount(Map<String, Object> param) throws Exception;

	public List<ApprovalHeaderVO> refList(Map<String, Object> param) throws Exception;

	public Object myCount(Map<String, Object> param) throws Exception;

	public Object apprCount(Map<String, Object> param) throws Exception;

	public Object refCount(Map<String, Object> param) throws Exception;

	public void deleteApprHeader(int apprNo) throws Exception;

	public void deleteRefCirc(int apprNo) throws Exception;

	public void deleteApprItem(int apprNo) throws Exception;
	
	public Map<String,Object> newApprovalBoxHeaderSave(Map<String,Object> param);
	
	public void approvalBoxInfoSave(Map<String,Object> param);
	
	public void approvalReferenceSave(Map<String,Object> param);
	
	public List<Map<String,Object>> approvalBoxDataForEmail(String apprNo);
	
	public List<Map<String,Object>> approvalBoxDataForEmailReference(Map<String,Object> param);
	
	public List<Map<String,Object>> nextApprovalUserInfo(Map<String,Object> param);

	public List<Map<String,Object>> nextApprovalBoxInfo(Map<String,Object> param);

	public void approvalBoxHeaderUpdate(Map<String,Object> param);
	
	public void apprStateUpdate(Map<String,Object> param);

	public void approvalBoxHeaderLinkUpdate(Map<String,Object> param);
	
	public List<Map<String,Object>> getDetailApprovalLineList(String apprLineNo);

	public void approvalBoxHeaderCopy(Map<String, Object> param) throws Exception;

	public void approvalBoxInfoCopy(Map<String, Object> param)  throws Exception;

	public void approvalReferenceCopy(Map<String, Object> param) throws Exception;

	public void approvalStateUpdate(Map<String, Object> map) throws Exception;

	public void updateApprvalItemInfo(Map<String, Object> param) throws Exception;

	public int apprvalItemState(Map<String, Object> param) throws Exception;

	public void updateArrpvalHeader(Map<String, Object> param) throws Exception;
	
	public List<Map<String,Object>> getApprNo (Map<String,Object> param);

	public ApprovalItemVO apprItemInfoByApbNo(Map<String, Object> param) throws Exception;

	public Map<String, Object> getDocData(Map<String, Object> param) throws Exception;

	public ApprovalHeaderVO printConfirmData(Map<String, Object> param) throws Exception;

	public void printRequest(Map<String, Object> param) throws Exception;

	public List<Integer> getMfgApprNoList(HashMap<String, Object> param);

	public List<Integer> getDesignApprNoList(HashMap<String, Object> param);

	public List<Map<String, Object>> apprCountType(Map<String, Object> param) throws Exception;

	public List<Map<String, Object>> myCountType(Map<String, Object> param) throws Exception;

	public void approvalLineHeaderDelete(String apprLineNo) throws Exception;
	
	public void approvalLineItemDelete(String apprLineNo) throws Exception;

	public int countReviewDoc(Map<String, Object> param) throws Exception;

	public int apporvingListCount(Map<String, Object> param) throws Exception;

	public List<ApprovalHeaderVO> apporvingList(Map<String, Object> param) throws Exception;

	public List<Map<String, Object>> getPrintApprTargetList(Map<String, Object> param);

	public int insertApprovalLineHeader(HashMap<String, Object> param);

	public int insertApprovalBoxHeader(HashMap<String, Object> param);

	public int insertApprovalBoxInfo(HashMap<String, Object> param);

	public int insertApprovalReference(HashMap<String, Object> param);

	public String getRegUserId(Map<String, Object> param);

	public String getMfgPlantName(Map<String, Object> param);
	
	public int countPrint(Map<String, Object> param) throws Exception;

	int isApprExsiste(Map<String, Object> param);

	public List<ApprovalItemVO> apprItemInfo2(Map<String, Object> param) throws Exception;
}


//<!-- Builder 개발서버 반영 원복 재실행을 위한 주석 추가 -->