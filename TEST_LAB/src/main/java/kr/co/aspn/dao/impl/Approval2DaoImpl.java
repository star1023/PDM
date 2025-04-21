package kr.co.aspn.dao.impl;

import java.util.List;
import java.util.Map;
import java.util.HashMap;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;



import kr.co.aspn.dao.Approval2Dao;

@Repository
public class Approval2DaoImpl implements Approval2Dao {
	private Logger logger = LoggerFactory.getLogger(Approval2DaoImpl.class);
	
	@Autowired
	SqlSessionTemplate sqlSessionTemplate;
	
	@Override
	public List<Map<String, Object>> searchUser(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("approval2.searchUser", param);
	}

	@Override
	public int selectLineSeq() {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("approval2.selectLineSeq");
	}

	@Override
	public void insertApprLine(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("approval2.insertApprLine", param);
	}

	@Override
	public void insertApprLineItem(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("approval2.insertApprLineItem", param);
	}

	@Override
	public List<Map<String, Object>> selectApprovalLine(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("approval2.selectApprovalLine", param);
	}

	@Override
	public List<Map<String, Object>> selectApprovalLineItem(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("approval2.selectApprovalLineItem", param);
	}

	@Override
	public void deleteApprLine(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("approval2.deleteApprLine", param);
	}

	@Override
	public int selectApprSeq() {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("approval2.selectApprSeq");
	}

	@Override
	public void insertApprHeader(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("approval2.insertApprHeader",param);
	}

	@Override
	public void insertApprItem(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("approval2.insertApprItem",param);
	}

	@Override
	public void insertReference(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("approval2.insertReference",param);
	}

	@Override
	public void updateStatus(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("approval2.updateStatus", param);
	}

	@Override
	public int selectTotalCount(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("approval2.selectTotalCount", param);
	}

	@Override
	public List<Map<String, Object>> selectApprovalList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("approval2.selectApprovalList", param);
	}

	@Override
	public int selectMyApprTotalCount(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("approval2.selectMyApprTotalCount", param);
	}

	@Override
	public List<Map<String, Object>> selectMyApprList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("approval2.selectMyApprList", param);
	}

	@Override
	public int selectMyRefTotalCount(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("approval2.selectMyRefTotalCount", param);
	}

	@Override
	public List<Map<String, Object>> selectMyRefList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("approval2.selectMyRefList", param);
	}

	@Override
	public int selectMyCompTotalCount(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("approval2.selectMyCompTotalCount", param);
	}

	@Override
	public List<Map<String, Object>> selectMyCompList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("approval2.selectMyCompList", param);
	}

	@Override
	public Map<String, String> selectApprHeaderData(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("approval2.selectApprHeaderData", param);
	}

	@Override
	public void updateApprStatus(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("approval2.updateApprStatus", param);
	}

	@Override
	public void updateDocStatus(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("approval2.updateDocStatus", param);
	}

	@Override
	public Map<String, String> selectDocData(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("approval2.selectDocData", param);
	}

	@Override
	public List<Map<String, String>> selectApprItemList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("approval2.selectApprItemList", param);
	}

	@Override
	public List<Map<String, String>> selectReferenceList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("approval2.selectReferenceList", param);
	}

	@Override
	public void approvalSubmitItem(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("approval2.approvalSubmitItem", param);
	}

	@Override
	public Map<String, Object> selectNextApprItem(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("approval2.selectNextApprItem", param);
	}

	@Override
	public void updateApprUser(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("approval2.updateApprUser", param);
	}

	@Override
	public Map<String, String> selectApprItem(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("approval2.selectApprItem", param);
	}

	@Override
	public void deleteApprItem(Map<String, String> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.delete("approval2.deleteApprItem", param);
	}

	@Override
	public void deleteApprHeader(Map<String, String> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.delete("approval2.deleteApprHeader", param);
	}

	@Override
	public void deleteApprReference(Map<String, String> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.delete("approval2.deleteApprReference", param);
	}	
}
