package kr.co.aspn.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.aspn.common.auth.Auth;
import kr.co.aspn.common.auth.AuthUtil;
import kr.co.aspn.service.CommonService;
import kr.co.aspn.service.UserService;
import kr.co.aspn.util.CookieUtil;
import kr.co.aspn.util.SecurityUtil;
import kr.co.aspn.util.StringUtil;
import kr.co.aspn.util.UserUtil;
import kr.co.aspn.util.exception.CommonException;
import kr.co.aspn.vo.CodeItemVO;
import kr.co.aspn.vo.ResultVO;
import kr.co.aspn.vo.UserManageVO;
import kr.co.aspn.vo.UserVO;
import nets.websso.ssoclient.authcheck.*;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.StringTokenizer;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Controller
@RequestMapping("/user")
public class UserController {
	private Logger logger = LoggerFactory.getLogger(UserController.class);
	
	@Autowired
	private Properties config;
	
	@Autowired
	UserService userService;
	
	@Autowired
	private CommonService commonService;
	
	@RequestMapping(value = "/login", method = RequestMethod.GET)
	public String login(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("로그인");
		if (AuthUtil.hasAuth(request)) {
			return "redirect:/main/main";
		}
		
		/*CookieUtil cookieUtil = new CookieUtil(request, response);
		
		String save_id = cookieUtil.getCookie(config.getProperty("save.id"));
		logger.debug("save_id : "+save_id);
		
		model.addAttribute("save_id", save_id);*/
		return "/user/login";
	}
	
	@RequestMapping(value = "/loginProcAjax", method = RequestMethod.POST)
	@ResponseBody
	public ResultVO loginProc(HttpServletRequest request, HttpServletResponse response, UserVO userVO) throws Exception {
		logger.debug("id: {}, autoLogin: {}", userVO.getUserId());
		String pwd = config.getProperty("admin.pwd");
		logger.debug("pwd: {}", pwd);
		//logger.debug("userVO.getUserPw(): {}", userVO.getUserPw());
		String chkSave = request.getParameter("chkSave");
		logger.debug("chkSave: {}", chkSave);
		logger.debug("userVO.getChkSave(): {}", userVO.getChkSave());
		try {
			logger.debug("userVO.getUserPwd(): {}", userVO.getUserPwd());
			if( userVO.getUserPwd() != null && pwd.equals(userVO.getUserPwd()) ) {
				userService.login(userVO, request);
				/*if( userVO.getChkSave() != null && "Y".equals(userVO.getChkSave()) ) {
					CookieUtil cookieUtil = new CookieUtil(request, response);
					cookieUtil.setCookie(config.getProperty("save.id"), userVO.getUserId());
					String save_id = cookieUtil.getCookie(config.getProperty("save.id"));
					logger.debug("save_id: {}", save_id);
				}*/
			} else {
				/*
				userVO.setUserEncPwd(SecurityUtil.encryptSHA256(userVO.getUserPwd()));
				UserVO userVOResult = userService.loginCheck(userVO, request);
				if( userVO.getChkSave() != null && "Y".equals(userVO.getChkSave()) ) {
					CookieUtil cookieUtil = new CookieUtil(request, response);
					cookieUtil.setCookie(config.getProperty("save.id"), userVO.getUserId());
					String save_id = cookieUtil.getCookie(config.getProperty("save.id"));
					logger.debug("save_id: {}", save_id);
				}
				*/
				
				//if( userVOResult == null || "".equals(userVOResult.getUserId())) {
				return new ResultVO(ResultVO.FAIL, "입력하신 비밀번호가 올바르지 않거나 \n 존재하지 않는 사용자 입니다.");
				//}
			}
		} catch(CommonException ce) {
			if(ce.getMessage().equals("USER_LOCK")){
				return new ResultVO("lock");
			} else {
				return new ResultVO(ResultVO.FAIL, "입력하신 비밀번호가 올바르지 않거나 \n 존재하지 않는 사용자 입니다.");
			}
		} catch (Exception e) {
			e.printStackTrace();
			return new ResultVO(ResultVO.ERROR, e.getMessage());
		}
		logger.debug("id: {}, autoLogin: {}", userVO.getUserId());
		return new ResultVO();
	}
	
	@RequestMapping(value = "/logout", method = RequestMethod.GET)
	public String logout(HttpServletRequest request, HttpServletResponse response) throws Exception {
		userService.logout(request);
		return "/user/logout";
		//return "redirect:/user/logout";
	}
	
	@RequestMapping(value = "/userlock", method = RequestMethod.GET)
	public String userlock(HttpServletRequest request, HttpServletResponse response){
		return "/user/userlock";
	}
	
	@RequestMapping(value = "/ssoLoginFail", method = RequestMethod.GET)
	public String ssoLoginFail(HttpServletRequest request, HttpServletResponse response){
		return "/user/ssoLoginFail";
	}
	
	@RequestMapping(value = "/ssoLoginCheck")
	public String ssoLoginCheck(HttpServletRequest request, HttpServletResponse response , Model model) throws Exception {
		logger.error(request.getParameter("userId"));
		String userId = request.getParameter("userId");
		//response.sendRedirect("http://30.10.60.45/gwLogin.jsp?userId="+userId);
		userService.logout(request);
		model.addAttribute("userId", userId);
		return "/user/redirect";
		//return "redirect:http://30.10.60.45/gwLogin.jsp?userId="+userId;
	}
	/*
	@RequestMapping(value = "/ssoLoginCheck")
	public String ssoLoginCheck(HttpServletRequest request, HttpServletResponse response) throws Exception {
		boolean ssoResult = false;
		String userId = request.getParameter("userId");
		//response.sendRedirect("http://30.10.60.45/gwLogin.jsp?userId="+userId);
		userService.logout(request);
		return "redirect:http://30.10.60.45/gwLogin.jsp?userId="+userId;
	*/	
		/*if( userId == null || "".equals(userId) ) {
			ssoResult  = false;
		} else {
			UserVO userVO = new UserVO();
			userVO.setUserId(userId);
			try {
				userService.login(userVO, request);
				ssoResult = true;
			} catch( CommonException ce ) {
				ssoResult = false;
			} catch( Exception e ) {
				ssoResult = false;
			}
		}
		
		if( ssoResult) {
			String returnURL = request.getParameter("returnURL");
			if( returnURL != null && !"".equals(returnURL)) {
				return "redirect:"+returnURL;
			} else {
				return "redirect:/main/main";
			}
		} else {
			return "redirect:/user/logout";
		}*/
	//}

	/*
	public String ssoLoginCheck(HttpServletRequest request, HttpServletResponse response) throws Exception {
		boolean ssoResult = false;
		Map<String,Object> param = new HashMap<String,Object>();
		Map<String,Object> result = new HashMap<String,Object>();
		SimpleDateFormat f = new SimpleDateFormat("HH:mm:ss", Locale.KOREA);

        String P_LOCALE  = ((String)request.getAttribute("P_LOCALE") == null || "".equals((String)request.getAttribute("P_LOCALE"))) ? "ko_KR" : (String)request.getAttribute("P_LOCALE");
        String P_USER_ID = (String)request.getAttribute("P_USER_ID");
        String P_USER_IP = request.getRemoteAddr();
        String P_BROWSER = request.getHeader("User-Agent");
        String P_IS_SSO  = (String)request.getAttribute("P_IS_SSO");	//SSO
        String P_LOGIN_DATETIME = f.format(new Date());
        logger.debug("==============SSO LOGIN Info.================");
        logger.debug("P_LOCALE         ===> " + P_LOCALE);
        logger.debug("P_USER_ID        ===> " + P_USER_ID);
        logger.debug("P_USER_IP        ===> " + P_USER_IP);
        logger.debug("P_BROWSER        ===> " + P_BROWSER);
        logger.debug("P_LOGIN_DATETIME ===> " + P_LOGIN_DATETIME);
        logger.debug("=============================================");
        
        Cookie HPWCookie = null;
		String HPW_UserId = "";
		Cookie cookies[] = request.getCookies();
		for(int i = 0; i < cookies.length; i++) {
			Cookie cook = cookies[i];
			if( !cook.getName().trim().equals("HPW_UserID") ) 
				continue;
				HPWCookie = cook;
				break;
		}
		HPW_UserId = HPWCookie.getValue();
    	if( HPW_UserId == null || "".equals(HPW_UserId) ) {
			//return "redirect:/user/logout";
			ssoResult = false;
		} else {
			boolean isValidUser = false;

			logger.error("HPW_UserId : {} ",HPW_UserId);
			logger.error("isValidUser : {} ",isValidUser);
			System.err.print("HPW_UserId : "+HPW_UserId);
			System.err.print("isValidUser : "+HPW_UserId);
			System.out.print("HPW_UserId : "+HPW_UserId);
			System.out.print("isValidUser : "+HPW_UserId);
			//if(isValidUser) {
				UserVO userVO = new UserVO();
				userVO.setUserId(HPW_UserId);
				try {
					userService.login(userVO, request);
					ssoResult = true;
				} catch( CommonException ce ) {
					logger.error("error : {} ",ce.getMessage());
					System.err.print("error : "+ce.getMessage());
					System.out.print("error : "+ce.getMessage());
					ssoResult = false;
				} catch( Exception e ) {
					logger.error("error : {} ",e.getMessage());
					System.err.print("error : "+e.getMessage());
					System.out.print("error : "+e.getMessage());
				}
			//} else {
			//	ssoResult = false;
			//}
		}
               
        if( ssoResult) {
			String returnURL = request.getParameter("returnURL");
			if( returnURL != null && !"".equals(returnURL)) {
				return "redirect:"+returnURL;
			} else {
				return "redirect:/main/main";
			}
		} else {
			return "redirect:/user/logout";
		}
	}
	*/
	/*
	public String ssoLoginCheck(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		boolean ssoResult = false;
		SSOConfig.request = request;
		AuthCheck auth = new AuthCheck(request, response);
		AuthStatus status = auth.CheckLogon(AuthCheckLevel.Medium);
		try {
		if(status == AuthStatus.SSOFirstAccess) {
			logger.error("status SSOFirstAccess : {} ",AuthStatus.SSOFirstAccess);
			System.err.print("status SSOFirstAccess : "+AuthStatus.SSOFirstAccess);
			System.out.print("status SSOFirstAccess : "+AuthStatus.SSOFirstAccess);
		    auth.TrySSO();
		} else if(status == AuthStatus.SSOFail) {
			logger.error("status SSOFail : {} ",AuthStatus.SSOFail);
			System.err.print("status SSOFail : "+AuthStatus.SSOFail);
			System.out.print("status SSOFail : "+AuthStatus.SSOFail);
	        ssoResult = false;
		} else if(status == AuthStatus.SSOSuccess) {
			// 쿠키값 보기
			Cookie c = Util.getCookie(request.getCookies(), SSOConfig.SSODomainTokenName());
	        String domainAuthCookie = Util.DecryptDomainCookie(c.getValue());
	        logger.error("domainAuthCookie : {} ",domainAuthCookie);
	        System.err.print("domainAuthCookie : "+domainAuthCookie);
	        System.out.print("domainAuthCookie : "+domainAuthCookie);
	        StringTokenizer stk = new StringTokenizer(domainAuthCookie,"|");
			
	        Cookie HPWCookie = null;
			String HPW_UserId = "";
			Cookie cookies[] = request.getCookies();
			for(int i = 0; i < cookies.length; i++) {
				Cookie cook = cookies[i];
				if( !cook.getName().trim().equals("HPW_UserID") ) 
					continue;
					HPWCookie = cook;
					break;
			}
			HPW_UserId = HPWCookie.getValue();
	    	if( HPW_UserId == null || "".equals(HPW_UserId) ) {
				//return "redirect:/user/logout";
				ssoResult = false;
			} else {
				boolean isValidUser = false;
				while( stk.hasMoreTokens()) {
					String thisToken = stk.nextToken();
					if( thisToken != null && thisToken.equals(HPW_UserId) ) {
						isValidUser = true;
						break;
					}
				}
				logger.error("HPW_UserId : {} ",HPW_UserId);
				logger.error("isValidUser : {} ",isValidUser);
				System.err.print("HPW_UserId : "+HPW_UserId);
				System.err.print("isValidUser : "+HPW_UserId);
				System.out.print("HPW_UserId : "+HPW_UserId);
				System.out.print("isValidUser : "+HPW_UserId);
				if(isValidUser) {
					UserVO userVO = new UserVO();
					userVO.setUserId(HPW_UserId);
					try {
						userService.login(userVO, request);
						ssoResult = true;
					} catch( CommonException ce ) {
						logger.error("error : {} ",ce.getMessage());
						System.err.print("error : "+ce.getMessage());
						System.out.print("error : "+ce.getMessage());
						ssoResult = false;
					} catch( Exception e ) {
						logger.error("error : {} ",e.getMessage());
						System.err.print("error : "+e.getMessage());
						System.out.print("error : "+e.getMessage());
					}
				} else {
					ssoResult = false;
				}
			}
	    }
		} catch( Exception e ) {
			logger.error("error : {} ",e.getMessage());
			System.err.print("error : "+e.getMessage());
			System.out.print("error : "+e.getMessage());
		}
		logger.error("ssoResult : {} ",ssoResult);
		System.err.print("status SSOFirstAccess : "+AuthStatus.SSOFirstAccess);
		if( ssoResult) {
			String returnURL = request.getParameter("returnURL");
			if( returnURL != null && !"".equals(returnURL)) {
				return "redirect:"+returnURL;
			} else {
				return "redirect:/user/main";
			}
		} else {
			return "redirect:/user/logout";
		}
		
	}
	*/
	
	@RequestMapping(value = "/ssoTest")
	public String ssoTest(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		boolean ssoResult = false;
		boolean isLock = false;
		userService.logout(request);
		UserVO userVO = new UserVO();
		userVO.setUserId(request.getParameter("user_id"));
		try {
			userService.login(userVO, request);
			ssoResult = true;
		} catch( CommonException ce ) {
			if(ce.getMessage().equals("USER_LOCK")){
				isLock = true;
			}
			logger.debug("error : {} ",ce.getMessage());
			ssoResult = false;
		} catch( Exception e ) {
			logger.debug("error : {} ",e.getMessage());
		}
		
		logger.debug("ssoResult : {} ",ssoResult);
		if( ssoResult) {
			String returnURL = request.getParameter("returnURL");
			if( returnURL != null && !"".equals(returnURL)) {
				return "redirect:"+returnURL;
			} else {
				return "redirect:/user/main";
			}
		} else {
			if(isLock){
				return "redirect:/user/userlock";
			} else {
				return "redirect:/user/logout";
			}
		}
		
	}
	
	@ResponseBody
	@RequestMapping(value="/setPersonalizationAjax")
	public Map<String, Object> setPersonalization(@RequestParam Map<String, Object> param, HttpServletRequest request, HttpServletResponse response ,Model model ) {
		 Map<String, Object> map = new HashMap<String, Object>();
		try{
			param.put("userId", AuthUtil.getAuth(request).getUserId());
			userService.setPersonalization(param);
			if( param.get("type") != null && "theme".equals((String)param.get("type")) ) {
				 AuthUtil.getAuth(request).setTheme((String)param.get("value"));
			} else if( param.get("type") != null && "contentMode".equals((String)param.get("type")) ) {
				AuthUtil.getAuth(request).setContentMode((String)param.get("value"));
			} else if( param.get("type") != null && "widthMode".equals((String)param.get("type")) ) {
				AuthUtil.getAuth(request).setWidthMode((String)param.get("value"));
			} else if( param.get("type") != null && "mailCheck1".equals((String)param.get("type")) ) {
				AuthUtil.getAuth(request).setMailCheck1((String)param.get("value"));
			} else if( param.get("type") != null && "mailCheck2".equals((String)param.get("type")) ) {
				AuthUtil.getAuth(request).setMailCheck2((String)param.get("value"));
			} else if( param.get("type") != null && "mailCheck3".equals((String)param.get("type")) ) {
				AuthUtil.getAuth(request).setMailCheck3((String)param.get("value"));
			}
			map.put("resultCd", "S");
			
		}catch(Exception e){
			map.put("resultCd", "F");
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
		}
		return map;
	}
	
	
	@RequestMapping(value="/userList")
	public String manageUserList(Model model, HttpServletRequest request) throws Exception{
		try {
		CodeItemVO code = new CodeItemVO ();
		code.setGroupCode("DEPT");
		List<CodeItemVO> deptList = commonService.getCodeList(code);
		code.setGroupCode("GRADE");
		List<CodeItemVO> gradeList = commonService.getCodeList(code); 
		code.setGroupCode("TEAM");
		List<CodeItemVO> teamList = commonService.getCodeList(code);
		
		model.addAttribute("deptList", deptList);
		model.addAttribute("gradeList", gradeList);
		model.addAttribute("teamList", teamList);
		return "/user/userList";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@ResponseBody
	@RequestMapping(value="/userListAjax")
	public Map<String, Object> userList(Model model, UserManageVO userManageVO ) {
		 Map<String, Object> map = new HashMap<String, Object>();
		try{
			
			map = userService.getUserList(userManageVO);
			map.put("resultCd", "S");
			
		}catch(Exception e){
			map.put("resultCd", "F");
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
		}
		return map;
	}
	
	@RequestMapping(value="/insertForm")
	public String insertForm(Model model, HttpServletRequest request) throws Exception{
		try {
			CodeItemVO code = new CodeItemVO ();
			code.setGroupCode("DEPT");
			List<CodeItemVO> deptList = commonService.getCodeList(code);
			code.setGroupCode("GRADE");
			List<CodeItemVO> gradeList = commonService.getCodeList(code); 
			code.setGroupCode("TEAM");
			List<CodeItemVO> teamList = commonService.getCodeList(code);
			
			model.addAttribute("deptList", deptList);
			model.addAttribute("gradeList", gradeList);
			model.addAttribute("teamList", teamList);
			return "/user/insertForm";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping(value="/updateForm")
	public String updateForm(UserManageVO userManageVO, Model model) throws Exception{
		try {
			CodeItemVO code = new CodeItemVO ();
			code.setGroupCode("DEPT");
			List<CodeItemVO> deptList = commonService.getCodeList(code);
			code.setGroupCode("GRADE");
			List<CodeItemVO> gradeList = commonService.getCodeList(code);
			code.setGroupCode("TEAM");
			List<CodeItemVO> teamList = commonService.getCodeList(code);
			
			model.addAttribute("deptList", deptList);
			model.addAttribute("gradeList", gradeList);
			model.addAttribute("teamList", teamList);
			model.addAttribute("userManageVO", userService.getUserData(userManageVO));
			return "/user/updateForm";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	/**
	 * 아이디 중복체크
	 * @param userId
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="/checkId")
	public Map<String, Object> checkId(@RequestParam(value="userId") String userId ){
		Map<String, Object> map = new HashMap<String, Object>();
		try{
			int checkId = userService.checkId(userId);
			map.put("result", "S");
			map.put("checkId", checkId);
		}catch(Exception e){
			map.put("result", "F");
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
		}
		return map;
	}
	
	@RequestMapping("/insert")
	public String insert(UserManageVO userManageVO, HttpServletRequest request, HttpServletResponse response){
		Map<String, Object> map = new HashMap<String, Object>();
		try{
			userManageVO.setRegUserId(UserUtil.getUserId(request));
			if( userManageVO.getIsAdmin() == null || "".equals(userManageVO.getIsAdmin()) ){
				userManageVO.setIsAdmin("N");
			}
			userService.insert(userManageVO);
			Map<String, String> logParam = new HashMap<String, String>();
			logParam.put("type", "C");
			logParam.put("description", "사용자 생성");
			logParam.put("userId", userManageVO.getUserId());
			logParam.put("regUserId", UserUtil.getUserId(request));
			userService.insertLog(logParam);
			map.put("resultCd", "S");
			
		}catch(Exception e){
			map.put("resultCd", "F");
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
		}
		return "redirect:/user/userList";
	}
	
	@RequestMapping("/update")
	public String update(UserManageVO userManageVO, HttpServletRequest request, HttpServletResponse response){
		Map<String, Object> map = new HashMap<String, Object>();
		try{
			//userManageVO.setRegUserId(UserUtil.getUserId(request));
			if( userManageVO.getIsAdmin() == null || "".equals(userManageVO.getIsAdmin()) ){
				userManageVO.setIsAdmin("N");
			}
			userService.update(userManageVO);
			Map<String, String> logParam = new HashMap<String, String>();
			logParam.put("type", "U");
			logParam.put("description", request.getParameter("description"));
			logParam.put("userId", userManageVO.getUserId());
			logParam.put("regUserId", UserUtil.getUserId(request));
			userService.insertLog(logParam);
			map.put("resultCd", "S");
			
		}catch(Exception e){
			map.put("resultCd", "F");
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
		}
		return "redirect:/user/userList";
	}
	
	@ResponseBody
	@RequestMapping(value="/delete")
	public Map<String, Object> delete(Model model, UserManageVO userManageVO, HttpServletRequest request ) {
		 Map<String, Object> map = new HashMap<String, Object>();
		try{
			
			userService.delete(userManageVO);
			Map<String, String> logParam = new HashMap<String, String>();
			logParam.put("type", "D");
			logParam.put("description", "사용자 삭제");
			logParam.put("userId", userManageVO.getUserId());
			logParam.put("regUserId", UserUtil.getUserId(request));
			userService.insertLog(logParam);
			map.put("resultCd", "S");
			
		}catch(Exception e){
			map.put("resultCd", "F");
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
		}
		return map;
	}
	
	@ResponseBody
	@RequestMapping(value="/restore")
	public Map<String, Object> restore(Model model, UserManageVO userManageVO, HttpServletRequest request ) {
		 Map<String, Object> map = new HashMap<String, Object>();
		try{
			
			userService.restore(userManageVO);
			Map<String, String> logParam = new HashMap<String, String>();
			logParam.put("type", "D");
			logParam.put("description", "사용자 복구");
			logParam.put("userId", userManageVO.getUserId());
			logParam.put("regUserId", UserUtil.getUserId(request));
			userService.insertLog(logParam);
			map.put("resultCd", "S");
			
		}catch(Exception e){
			map.put("resultCd", "F");
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
		}
		return map;
	}
	
	@ResponseBody
	@RequestMapping(value="/unlock")
	public Map<String, Object> unlock(Model model, UserManageVO userManageVO, HttpServletRequest request ) {
		 Map<String, Object> map = new HashMap<String, Object>();
		try{
			userService.unlock(userManageVO);
			Map<String, String> logParam = new HashMap<String, String>();
			logParam.put("type", "U");
			logParam.put("description", "사용자 잠금해제");
			logParam.put("userId", userManageVO.getUserId());
			logParam.put("regUserId", UserUtil.getUserId(request));
			userService.insertLog(logParam);
			map.put("resultCd", "S");
		}catch(Exception e){
			map.put("resultCd", "F");
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
		}
		return map;
	}
	
	@ResponseBody
	@RequestMapping(value="/marketingUserList")
	public Map<String,Object> marketingUserList(){
		Map<String,Object> map = new HashMap<String,Object>();
		
		try {
			map.put("marketingUserList", userService.marketingUserList());
			map.put("status", "S");
		}catch(Exception e) {
			map.put("status", "F");
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
		}
		
		return map;
		
	}
	
	@ResponseBody
	@RequestMapping(value="/qualityPlanningUserList")
	public Map<String,Object> qualityPlanningUserList(){
		Map<String,Object> map = new HashMap<String,Object>();
		
		try {
			map.put("qualityPlanningUserList", userService.qualityPlanningUserList());
			map.put("status", "S");
		}catch(Exception e) {
			map.put("status", "F");
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
		}
		
		return map;
		
	}
	
	@RequestMapping("reportViewAuthCheck")
	@ResponseBody
	public HashMap<String, Object> reportViewAuthCheck(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String,Object> param) throws Exception {
		logger.debug("param {} ", param);
		
		Auth auth = AuthUtil.getAuth(request);
		
		return userService.reportViewAuthCheck(auth, param);
	}
}
