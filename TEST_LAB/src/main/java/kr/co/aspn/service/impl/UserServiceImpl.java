package kr.co.aspn.service.impl;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.beanutils.BeanUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.aspn.common.auth.Auth;
import kr.co.aspn.common.auth.AuthUtil;
import kr.co.aspn.dao.TestDao;
import kr.co.aspn.dao.UserDao;
import kr.co.aspn.service.UserService;
import kr.co.aspn.util.PageNavigator;
import kr.co.aspn.util.exception.CommonException;
import kr.co.aspn.vo.UserManageVO;
import kr.co.aspn.vo.UserVO;

@Service
public class UserServiceImpl implements UserService {
	
	@Autowired
	UserDao userDao;
	
	@Autowired
	TestDao testDao;
	
	@Override
	public void login(UserVO UserVO, HttpServletRequest request) throws Exception {
		// TODO Auto-generated method stub
		UserVO loginUserVO = userDao.selectUser(UserVO);
		
		if( loginUserVO == null ) {
			throw new CommonException("NO_USER");
		}
		if( loginUserVO != null && "Y".equals(loginUserVO.getIsLock()) ) {
			throw new CommonException("USER_LOCK");
		}
		if( loginUserVO != null && "Y".equals(loginUserVO.getIsDelete()) ) {
			throw new CommonException("USER_DELETE");
		}
		
		Map<String, String> param = new HashMap<String, String>();
		param.put("roleCode", loginUserVO.getRoleCode());
		List<Map<String,Object>> userMenu = testDao.selectUserMenu(param);
		
		JSONArray jArr = new JSONArray();
		for (Map<String, Object> menu : userMenu) {
			Iterator<String> itr = menu.keySet().iterator();

			JSONObject jObj = new JSONObject();
			while (itr.hasNext()) {
				String key = itr.next();
				String value = String.valueOf(menu.get(key));
				jObj.put(key, value);
			}
			jArr.add(jObj);
		}
		HttpSession session = request.getSession(false);
		session.setAttribute("USER_MENU", jArr);
		// 세션 저장
		Auth auth = new Auth();
		BeanUtils.copyProperties(auth, loginUserVO);
		AuthUtil.setAuth(request, auth);
		loginUserVO.setUserIp(auth.getUserIp());
		userDao.insertLginLog(loginUserVO);
	}
	
	@Override
	public UserVO getUserInfo(UserVO UserVO) throws Exception{
		
		UserVO loginUserVO = userDao.selectUser(UserVO);
		
		return loginUserVO;
		
	}

	@Override
	public void logout(HttpServletRequest request) throws Exception {
		// TODO Auto-generated method stub
		Auth auth = AuthUtil.getAuth(request);
		// 로그인 세션 삭제
		AuthUtil.removeAuth(request);
	}
	
	@Override
	public UserVO loginCheck(UserVO userVO, HttpServletRequest request) throws Exception {
		// TODO Auto-generated method stub
		
		UserVO loginUserVO = userDao.loginCheck(userVO);
		if( loginUserVO != null && loginUserVO.getUserId() != null ) {
			// 세션 저장
			Auth auth = new Auth();
			
			BeanUtils.copyProperties(auth, loginUserVO);
			AuthUtil.setAuth(request, auth);
		} else {
			throw new CommonException("NO_USER");
		}
		
		return loginUserVO;
	}

	@Override
	public Map<String, Object> getUserList(UserManageVO userManageVO) throws Exception {
		// TODO Auto-generated method stub
		Map<String, Object> map = new HashMap<String, Object>();
		
		// 페이징: 페이징 정보 SET
		int totalCount = userDao.geUserCount(userManageVO);
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("pageNo", Integer.toString(userManageVO.getPageNo()));
		
		PageNavigator navi = new PageNavigator(param, totalCount);
		
		List<UserManageVO> list = userDao.getUserList(userManageVO);
		
		map.put("navi", navi);
		map.put("list", list);
		map.put("totalCount", totalCount);
		
		return map;
	}

	@Override
	public void insert(UserManageVO userManageVO) throws Exception {
		// TODO Auto-generated method stub
		userDao.insert(userManageVO);
	}

	@Override
	public int checkId(String userId) throws Exception {
		// TODO Auto-generated method stub
		return userDao.checkId(userId);
	}

	@Override
	public UserManageVO getUserData(UserManageVO userManageVO) throws Exception {
		// TODO Auto-generated method stub
		return userDao.getUserData(userManageVO);
	}

	@Override
	public void update(UserManageVO userManageVO) throws Exception {
		// TODO Auto-generated method stub
		userDao.update(userManageVO);
	}

	@Override
	public void delete(UserManageVO userManageVO) throws Exception {
		// TODO Auto-generated method stub
		userDao.delete(userManageVO);
	}
	
	@Override
	public void restore(UserManageVO userManageVO) throws Exception {
		userDao.restore(userManageVO);
	}
	
	@Override
	public void unlock(UserManageVO userManageVO) {
		// TODO Auto-generated method stub
		userDao.unlock(userManageVO);
	}

	@Override
	public void insertLog(Map<String, String> logParam) {
		// TODO Auto-generated method stub
		userDao.insertLog(logParam);
	}

	@Override
	public List<Map<String, Object>> searchUserList(HashMap<String, Object> param) {
		// TODO Auto-generated method stub
		return userDao.searchUserList(param);
	}

	@Override
	public List<Map<String, Object>> detailApprovalLineList(HashMap<String, Object> param) {
		// TODO Auto-generated method stub
		return userDao.detailApprovalLineList(param);
	}

	@Override
	public void setPersonalization(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		userDao.setPersonalization(param);
	}

	@Override
	public List<Map<String, Object>> marketingUserList() {
		// TODO Auto-generated method stub
		return userDao.marketingUserList();
	}

	@Override
	public List<Map<String, Object>> qualityPlanningUserList() {
		// TODO Auto-generated method stub
		return userDao.qualityPlanningUserList();
	}

	@Override
	public List<Map<String, Object>> researchUserList() {
		// TODO Auto-generated method stub
		return userDao.researchUserList();
	}

	@Override
	public List<Map<String, Object>> sendMailList(Map<String, String> map) throws Exception {
		// TODO Auto-generated method stub
		return userDao.sendMailList(map);
	}
	
	@Override
	public int insertAccessLog(HashMap<String, Object> param) {
		
		int insertCnt = userDao.insertAccessLog(param);
		String requestParams = (String)param.get("requestParams");
		if(requestParams != null && requestParams.length() > 0 ) {
			userDao.insertAccessLogParams(param);
		}
		
		return insertCnt;
	}
	
	@Override
	public HashMap<String, Object> reportViewAuthCheck(Auth auth, Map<String, Object> param) throws Exception {
		HashMap<String, Object> reulstMap = new HashMap<String, Object>();
		
		String loginUserId = auth.getUserId();
		String regUserId = (String)param.get("regUserId");
		
		if(regUserId == null || regUserId.equals("")) {
			reulstMap.put("result", "E");
			reulstMap.put("resultText", "등록자 ID가 없습니다.");
			return reulstMap;
		}
		
		if(loginUserId.equals(regUserId)) {
			reulstMap.put("result", "T");
			reulstMap.put("resultText", "등록자");
			return reulstMap;
		}
		
		/*240724 add - 사용자 권한 Grade: 연구소장  20*/
		if(auth.getUserGrade().equals("20")) {
			reulstMap.put("result", "T");
			reulstMap.put("resultText", "연구소장");
			return reulstMap;
		}
		
		if(auth.getIsAdmin() != null && auth.getIsAdmin().equals("Y")) {
			reulstMap.put("result", "T");
			reulstMap.put("resultText", "관리자");
			return reulstMap;
		}
		
		UserManageVO userVO = new UserManageVO();
		userVO.setUserId(regUserId);
		
		if(userDao.geUserCount(userVO) <= 0) {
			reulstMap.put("result", "E");
			reulstMap.put("resultText", "등록자 ID정보가 조회되지 않습니다.");
			return reulstMap;
		}
		userVO = userDao.getUserData(userVO);
		
		if(auth.getTeamCode().equals(userVO.getTeamCode()) && auth.getUserGrade().equals("5")){
			reulstMap.put("result", "T");
			reulstMap.put("resultText", "파트장");
			return reulstMap;
		}
		/*240724 add - 등록자와 동일한 팀(dept), 부서장 */
		if(auth.getDeptCode().equals(userVO.getDeptCode())){
			reulstMap.put("result", "T");
			if(auth.getUserGrade().equals("2")){
				reulstMap.put("resultText", "팀(부서장)");
			}else{
				reulstMap.put("resultText", "팀원");
			}
			return reulstMap;
		}
		
		reulstMap.put("result", "F");
		reulstMap.put("resultText", "조회 권한 없음");
		
		return reulstMap;
	}
}
