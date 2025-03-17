package kr.co.aspn.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.co.aspn.common.auth.Auth;
import kr.co.aspn.vo.UserManageVO;
import kr.co.aspn.vo.UserVO;

public interface UserService {
	/**
	 * 로그인처리
	 *
	 * @param csrUserVO
	 * @param request
	 * @return
	 * @throws Exception
	 */
	public void login(UserVO UserVO, HttpServletRequest request) throws Exception;

	/**
	 * 파라미터로 넘어온 그룹웨어id와 DB상에 등록된 사용자 아이디가 같은 계정이 맞는지 확인
	 * @param param
	 */
	public UserVO getUserInfo(UserVO UserVO) throws Exception;

	public void logout(HttpServletRequest request) throws Exception;
	
	//추가시작
	UserVO loginCheck(UserVO userVO, HttpServletRequest request) throws Exception;

	public Map<String, Object> getUserList(UserManageVO userManageVO) throws Exception;

	public void insert(UserManageVO userManageVO) throws Exception;

	public int checkId(String userId) throws Exception;

	public UserManageVO getUserData(UserManageVO userManageVO) throws Exception;

	public void update(UserManageVO userManageVO) throws Exception;

	public void delete(UserManageVO userManageVO) throws Exception;
	
	public void restore(UserManageVO userManageVO) throws Exception;
	
	public void unlock(UserManageVO userManageVO);

	public void insertLog(Map<String, String> logParam) throws Exception;

	public List<Map<String,Object>> searchUserList(HashMap<String,Object> param) throws Exception;
	
	public List<Map<String,Object>> detailApprovalLineList(HashMap<String,Object> param) throws Exception;

	public void setPersonalization(Map<String, Object> param) throws Exception;
	
	public List<Map<String,Object>> marketingUserList();
	
	public List<Map<String,Object>> qualityPlanningUserList();
	
	public List<Map<String,Object>> researchUserList();

	public List<Map<String, Object>> sendMailList(Map<String, String> map) throws Exception;

	public int insertAccessLog(HashMap<String, Object> param);

	public HashMap<String, Object> reportViewAuthCheck(Auth auth, Map<String, Object> param) throws Exception;

	
}
