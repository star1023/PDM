package kr.co.aspn.dao.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.aspn.dao.UserDao;
import kr.co.aspn.vo.UserManageVO;
import kr.co.aspn.vo.UserVO;

@Repository
public class UserDaoImpl implements UserDao {
	
private Logger logger = LoggerFactory.getLogger(UserDaoImpl.class);
	
	@Autowired
	SqlSessionTemplate sqlSessionTemplate;
	
	@Override
	public UserVO selectUser(UserVO userVO) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("user.selectUser", userVO);
	}
	
	@Override
	public UserVO loginCheck(UserVO userVO) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("user.loginCheck", userVO);
	}

	@Override
	public int geUserCount(UserManageVO userManageVO) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("user.userCount", userManageVO);
	}

	@Override
	public List<UserManageVO> getUserList(UserManageVO userManageVO) throws Exception {
		// TODO Auto-generated method stub
		return  sqlSessionTemplate.selectList("user.userList", userManageVO);
	}

	@Override
	public void insert(UserManageVO userManageVO) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("user.insert",userManageVO);
	}

	@Override
	public int checkId(String userId) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("user.checkId", userId);
	}

	@Override
	public UserManageVO getUserData(UserManageVO userManageVO) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("user.getUserData", userManageVO);
	}

	@Override
	public void update(UserManageVO userManageVO) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("user.update", userManageVO);
	}

	@Override
	public void delete(UserManageVO userManageVO) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("user.delete", userManageVO);
	}
	
	@Override
	public void restore(UserManageVO userManageVO) throws Exception {
		sqlSessionTemplate.update("user.restore", userManageVO);
	}
	
	@Override
	public void unlock(UserManageVO userManageVO) {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("user.unlock", userManageVO);
	}

	@Override
	public void insertLog(Map<String, String> logParam) {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("user.insertLog",logParam);
	}

	@Override
	public void insertLginLog(UserVO loginUserVO) {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("user.insertLoginLog",loginUserVO);
	}

	@Override
	public List<Map<String, Object>> searchUserList(HashMap<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("user.searchUserList", param);
	}

	@Override
	public List<Map<String, Object>> detailApprovalLineList(HashMap<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("approval.detailApprovalLineList", param);
	}

	@Override
	public void setPersonalization(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("user.setPersonalization", param);
	}

	@Override
	public List<UserVO> userListBom() {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("user.userListBom");
	}

	@Override
	public List<Map<String, Object>> marketingUserList() {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("user.marketingUserList");
	}

	@Override
	public List<Map<String, Object>> qualityPlanningUserList() {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("user.qualityPlanningUserList");
	}

	@Override
	public List<Map<String, Object>> researchUserList() {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("user.researchUserList");
	}

	@Override
	public List<Map<String, Object>> sendMailList(  Map<String, String> param  ) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("user.sendMailList", param);
	}
	
	@Override
	public int insertAccessLog(HashMap<String, Object> param) {
		return sqlSessionTemplate.insert("user.insertAccessLog", param);
	}
	
	@Override
	public int insertAccessLogParams(HashMap<String, Object> param) {
		return sqlSessionTemplate.insert("user.insertAccessLogParams", param);
	}
	
	@Override
	public UserVO selectDocumentOwner(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectOne("user.selectDocumentOwner", param);
	}
}
