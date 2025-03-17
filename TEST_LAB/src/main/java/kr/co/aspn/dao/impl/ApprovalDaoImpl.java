package kr.co.aspn.dao.impl;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.HashMap;

import kr.co.aspn.dao.ApprovalDao;
import kr.co.aspn.vo.ApprovalHeaderVO;
import kr.co.aspn.vo.ApprovalItemVO;
import kr.co.aspn.vo.ApprovalReferenceVO;

@Repository
public class ApprovalDaoImpl implements ApprovalDao {
	private Logger logger = LoggerFactory.getLogger(ApprovalDaoImpl.class);
	@Autowired
	SqlSessionTemplate sqlSessionTemplate;
	
	@Override
	public int apporvalDocCount(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("approval.apporvalDocCount", param);
	}

	@Override
	public List<ApprovalHeaderVO> approvalDocList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("approval.approvalDocList", param);
	}
	
	@Override
	public List<Map<String, Object>> approvalLineList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("approval.approvalLineList", param);
	}

	@Override
	public ApprovalHeaderVO apprHeaderInfo(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("approval.apprHeaderInfo", param);
	}

	@Override
	public List<ApprovalItemVO> apprItemInfo(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("approval.apprItemInfo", param);
	}
	
	@Override
	public List<ApprovalItemVO> apprItemInfo2(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("approval.apprItemInfo2", param);
	} 
	
	@Override
	public List<ApprovalItemVO> apprItemInfoExcel(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("approval.apprItemInfoExcel", param);
	}

	@Override
	public List<ApprovalReferenceVO> apprReferenceInfo(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("approval.apprReferenceInfo", param);
	}

	@Override
	public String printRequest(ApprovalHeaderVO apprItemHeader) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("approval.printRequest", apprItemHeader);
	}

	@Override
	public int proxyInfo(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("approval.proxyInfo", param);
	}

	@Override
	public void deleteApprovalLineHeader(String apprLineNo) {
		// TODO Auto-generated method stub
		sqlSessionTemplate.delete("approval.deleteApprovalLineHeader", apprLineNo);
		
	}

	@Override
	public void deleteApprovalLineInfo(String apprLineNo) {
		// TODO Auto-generated method stub
		sqlSessionTemplate.delete("approval.deleteApprovalLineInfo", apprLineNo);
	}

	@Override
	public Map<String,Object> selectinsertApprovalLineHeader(HashMap<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("approval.selectinsertApprovalLineHeader", param);
	}

	@Override
	public void insertApprovalLineInfo(HashMap<String, Object> param) {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("approval.insertApprovalLineInfo", param);
	}

	@Override
	public List<Map<String, Object>> selectRegUserInfo(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("approval.selectRegUserInfo", param);
	}

	@Override
	public List<Map<String, Object>> keyData(String ddNo) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("approval.detailDdNo", ddNo);
	}

	@Override
	public List<Map<String, Object>> detailApprovalLineList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("approval.detailApprovalLineList", param);
	}

	@Override
	public int apporvalListCount(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		logger.debug("param {}", param);
		return sqlSessionTemplate.selectOne("approval.apporvalListCount", param);
	}

	@Override
	public List<ApprovalHeaderVO> apporvalList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		logger.debug("param {}", param);
		return sqlSessionTemplate.selectList("approval.apporvalList", param);
	}

	@Override
	public int refListCount(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("approval.refListCount", param);
	}

	@Override
	public List<ApprovalHeaderVO> refList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("approval.refList", param);
	}

	@Override
	public Object myCount(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("approval.myCount", param);
	}

	@Override
	public Object apprCount(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("approval.apprCount", param);
	}

	@Override
	public Object refCount(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("approval.refCount", param);
	}

	@Override
	public void deleteApprHeader(int apprNo) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.delete("approval.deleteApprHeader", apprNo);
	}

	@Override
	public void deleteRefCirc(int apprNo) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.delete("approval.deleteRefCirc", apprNo);
	}

	@Override
	public void deleteApprItem(int apprNo) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.delete("approval.deleteApprItem", apprNo);
	}

	@Override
	public Map<String, Object> newApprovalBoxHeaderSave(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("approval.newApprovalBoxHeaderSave", param);
	}

	@Override
	public void approvalBoxInfoSave(Map<String, Object> param) {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("approval.approvalBoxInfoSave", param);
	}

	@Override
	public void approvalReferenceSave(Map<String, Object> param) {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("approval.approvalReferenceSave", param);
	}

	@Override
	public List<Map<String, Object>> approvalBoxDataForEmail(String apprNo) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("approval.approvalBoxDataForEmail", apprNo);
	}

	@Override
	public List<Map<String, Object>> approvalBoxDataForEmailReference(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("approval.approvalBoxDataForEmailReference", param);
	}

	@Override
	public List<Map<String, Object>> nextApprovalUserInfo(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("approval.nextApprovalUserInfo", param);
	}

	@Override
	public List<Map<String, Object>> nextApprovalBoxInfo(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("approval.nextApprovalBoxInfo", param);
	}

	@Override
	public void approvalBoxHeaderUpdate(Map<String, Object> param) {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("approval.approvalBoxHeaderUpdate", param);
	}

	@Override
	public void apprStateUpdate(Map<String, Object> param) {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("approval.apprStateUpdateManufac",param);
	}

	@Override
	public void approvalBoxHeaderLinkUpdate(Map<String, Object> param) {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("approval.approvalBoxHeaderLinkUpdate",param);
	}

	@Override
	public List<Map<String, Object>> getDetailApprovalLineList(String apprLineNo) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("approval.getDetailApprovalLineList", apprLineNo);
	}

	@Override
	public void approvalBoxHeaderCopy(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("approval.approvalBoxHeaderCopy", param);
	}

	@Override
	public void approvalBoxInfoCopy(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("approval.approvalBoxInfoCopy", param);
	}

	@Override
	public void approvalReferenceCopy(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("approval.approvalReferenceCopy", param);
	}

	@Override
	public void approvalStateUpdate(Map<String, Object> map) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("approval.approvalStateUpdate", map);
	}

	@Override
	public void updateApprvalItemInfo(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("approval.updateApprvalItemInfo", param);
	}

	@Override
	public int apprvalItemState(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("approval.apprvalItemState", param);
	}

	@Override
	public void updateArrpvalHeader(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("approval.updateArrpvalHeader", param);
	}

	@Override
	public List<Map<String, Object>> getApprNo(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("approval.getApprNo", param);
	}

	@Override
	public ApprovalItemVO apprItemInfoByApbNo(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("approval.apprItemInfoByApbNo", param);
	}

	@Override
	public Map<String, Object> getDocData(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("approval.getDocData", param);
	}

	@Override
	public ApprovalHeaderVO printConfirmData(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("approval.printConfirmData", param);
	}

	@Override
	public void printRequest(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("approval.printRequest", param);
	}

	@Override
	public List<Integer> getMfgApprNoList(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectList("approval.getMfgApprNoList", param);
	}
	
	@Override
	public List<Integer> getDesignApprNoList(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectList("approval.getDesignApprNoList", param);
	}

	@Override
	public List<Map<String, Object>> apprCountType(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("approval.apprCountType", param);
	}

	@Override
	public List<Map<String, Object>> myCountType(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("approval.myCountType", param);
	}

	@Override
	public void approvalLineHeaderDelete(String apprLineNo) throws Exception {
		// TODO Auto-generated method stub
		
		sqlSessionTemplate.delete("approval.approvalLineHeaderDelete", apprLineNo);
		
	}

	@Override
	public void approvalLineItemDelete(String apprLineNo) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.delete("approval.approvalLineItemDelete", apprLineNo);
		
	}

	@Override
	public int countReviewDoc(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("approval.countReviewDoc", param);
	}

	@Override
	public int apporvingListCount(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("approval.apporvingListCount", param);
	}

	@Override
	public List<ApprovalHeaderVO> apporvingList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("approval.apporvingList", param);
	}
	
	@Override
	public List<Map<String, Object>> getPrintApprTargetList(Map<String, Object> param) {
		return sqlSessionTemplate.selectList("approval.getPrintApprTargetList", param);
	}
	
	@Override
	public int insertApprovalLineHeader(HashMap<String, Object> param) {
		return sqlSessionTemplate.insert("approval.insertApprovalLineHeader", param);
	}
	
	@Override
	public int insertApprovalBoxHeader(HashMap<String, Object> param) {
		return sqlSessionTemplate.insert("approval.insertApprovalBoxHeader", param);
	}
	
	@Override
	public int insertApprovalBoxInfo(HashMap<String, Object> param) {
		return sqlSessionTemplate.insert("approval.insertApprovalBoxInfo", param);
	}
	
	@Override
	public int insertApprovalReference(HashMap<String, Object> param) {
		return sqlSessionTemplate.insert("approval.insertApprovalReference", param);
	}
	
	@Override
	public String getRegUserId(Map<String, Object> param) {
		return sqlSessionTemplate.selectOne("approval.getRegUserId", param);
	}
	
	@Override
	public String getMfgPlantName(Map<String, Object> param) {
		return sqlSessionTemplate.selectOne("approval.getMfgPlantName", param);
	}
	
	@Override
	public int countPrint(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("approval.countPrint", param);
	}

	@Override
	public int isApprExsiste(Map<String, Object> param){
		return sqlSessionTemplate.selectOne("approval.isApprExsiste", param);
	}
}


//<!-- Builder 개발서버 반영 원복 재실행을 위한 주석 추가 -->