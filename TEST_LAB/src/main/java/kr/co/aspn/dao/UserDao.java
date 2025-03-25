package kr.co.aspn.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.co.aspn.vo.UserManageVO;
import kr.co.aspn.vo.UserVO;

public interface UserDao {
	
	public UserVO selectUser(UserVO userVO) throws Exception;
	//추가시작
	UserVO loginCheck(UserVO userVO);
	public int geUserCount(UserManageVO userManageVO) throws Exception;
	
	public List<UserManageVO> getUserList(UserManageVO userManageVO) throws Exception;
	
	public void insert(UserManageVO userManageVO) throws Exception;
	
	public int checkId(String userId) throws Exception;
	
	public UserManageVO getUserData(UserManageVO userManageVO) throws Exception;
	
	public void update(UserManageVO userManageVO) throws Exception;
	
	public void delete(UserManageVO userManageVO) throws Exception;
	
	public void restore(UserManageVO userManageVO) throws Exception;
	
	public void unlock(UserManageVO userManageVO);
	
	public void insertLog(Map<String, String> logParam);
	
	public void insertLginLog(UserVO loginUserVO);

	public List<Map<String,Object>> searchUserList(HashMap<String,Object> param);

	public List<Map<String,Object>> detailApprovalLineList(HashMap<String,Object> param);
	
	public void setPersonalization(Map<String, Object> param) throws Exception;
	
	public List<UserVO> userListBom();
	
	public List<Map<String,Object>> marketingUserList();
	
	public List<Map<String,Object>> qualityPlanningUserList();
	
	public List<Map<String,Object>> researchUserList();
	
	public List<Map<String, Object>> sendMailList( Map<String, String> param ) throws Exception;
	
	public int insertAccessLog(HashMap<String, Object> param);
	
	public int insertAccessLogParams(HashMap<String, Object> param);
	
	public UserVO selectDocumentOwner(HashMap<String, Object> param);
	
	public int selectAccessLogSeq();
}
