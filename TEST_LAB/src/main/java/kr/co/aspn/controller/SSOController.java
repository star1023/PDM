package kr.co.aspn.controller;

import java.util.StringTokenizer;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.co.aspn.service.UserService;
import kr.co.aspn.util.exception.CommonException;
import kr.co.aspn.vo.UserVO;
import nets.websso.ssoclient.authcheck.AuthCheck;
import nets.websso.ssoclient.authcheck.AuthCheckLevel;
import nets.websso.ssoclient.authcheck.AuthStatus;
import nets.websso.ssoclient.authcheck.SSOConfig;
import nets.websso.ssoclient.authcheck.Util;

@Controller
public class SSOController {
	private Logger logger = LoggerFactory.getLogger(SSOController.class);
	
	@Autowired
	UserService userService;
	
	@RequestMapping(value = "/ssoLoginCheckTest2")
	public String ssoLoginCheckTest2(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String referer = request.getHeader("referer");
		if(referer == null)
			referer = "null";
		else if("".equals(referer))
			referer = "empty vvalue";
		
		System.err.println(" ========== referer: " + referer);
		// ========== referer: http://webmail.spc.co.kr/WebMail/ExWeb/ContentView.aspx
		
		boolean ssoResult = false;
		boolean isLock = false;
		String userId = "";
		
		String url = ""; 
		String HPW_UserId = "";
		
	    try {
	        SSOConfig.request = request;
	        AuthCheck auth = new AuthCheck(request, response);
	        AuthStatus status = auth.CheckLogon(AuthCheckLevel.Medium);
	        
	        System.err.println("####### request.getRequestURI(): + " + request.getRequestURI());
	        System.err.println("####### request.getParameter('userId') : " + request.getParameter("userId"));
	        System.err.println("####### AuthStatus.SSOFirstAccess: " + AuthStatus.SSOFirstAccess);
	        System.err.println("####### AuthStatus.SSOFail: " + AuthStatus.SSOFail);
	        System.err.println("####### AuthStatus.SSOSuccess: " + AuthStatus.SSOSuccess);
	        
	        System.err.println("####### status: " + status);
	        if (status == AuthStatus.SSOFirstAccess) {
	        	System.err.println("####### status == AuthStatus.SSOFirstAccess");
	            auth.TrySSO();
	        } else if (status == AuthStatus.SSOSuccess) {
	        	System.err.println("####### status == AuthStatus.SSOSuccess");
	        	HPW_UserId = auth.UserID();
	        	userId = HPW_UserId;
	        	
	        	System.err.println("####### auth.UserID(): " + auth.UserID());
	        	
	        	if( HPW_UserId == null || "".equals(HPW_UserId) ) {
					 ssoResult = false;
					 System.err.println("####### 11111111111111");
				 }else {
					 UserVO userVO = new UserVO();
					 userVO.setUserId(HPW_UserId);
					try {
						userService.login(userVO, request);
						ssoResult = true;
						System.err.println("####### 2222222222222");
					} catch( CommonException ce ) {
						if(ce.getMessage().equals("USER_LOCK")) {
							isLock = true;
						}
						ssoResult = false;
						System.err.println("####### 333333333333333");
					} catch( Exception e ) {
						ssoResult = false;
						System.err.println("####### 44444444444");
					}
				 }
	        } else if (status == AuthStatus.SSOFail) {
	        	System.err.println("####### status == AuthStatus.SSOFail");
	        	ssoResult = false;
	        }
	    } catch (Exception ex) {
	    	ex.printStackTrace();
	    	System.err.println("####### printStackTrace printStackTrace printStackTrace : " + ex.getMessage());
	    	ssoResult = false;
	    }
		
	    System.err.println("######  11   ssoResult: " + ssoResult);
	    
	    if( !ssoResult ) {
	    	logger.debug("status SSOSuccess : {}",AuthStatus.SSOSuccess);
			
			Cookie c = Util.getCookie(request.getCookies(), SSOConfig.SSODomainTokenName());
			
			String domainAuthCookie = "";
			try {
				domainAuthCookie = Util.DecryptDomainCookie(c.getValue());
			} catch (Exception e) {
				e.printStackTrace();
				System.err.println(e.getMessage());
			}
			
			logger.debug("domainAuthCookie : {}",domainAuthCookie);
			StringTokenizer stk = new StringTokenizer(domainAuthCookie,"|");
			
			 while(stk.hasMoreTokens()) {
					String thisToken = stk.nextToken();
					System.err.println("thisToken  :  "+ thisToken);
				 }
	    	
	    	if( HPW_UserId == null || "".equals(HPW_UserId) ) {
	    		HPW_UserId = request.getParameter("userId");
	    	}
	    }
		if( HPW_UserId == null || "".equals(HPW_UserId) ) {
			ssoResult  = false;
		} else {
			UserVO userVO = new UserVO();
			userVO.setUserId(HPW_UserId);
			try {
				userService.login(userVO, request);
				ssoResult = true;
			} catch( CommonException ce ) {
				if(ce.getMessage().equals("USER_LOCK")){
					isLock = true;
				}
				ssoResult = false;
			} catch( Exception e ) {
				ssoResult = false;
			}
		}
		// test
		System.err.println("######  22   ssoResult: " + ssoResult);

		if( ssoResult) {
			String returnURL = request.getParameter("returnURL");
			String param = "";
			String callType = request.getParameter("callType");
			if( callType != null && ("MAIL".equals(callType) || "REF".equals(callType) )) {			
				String tbKey = request.getParameter("tbKey");
				String tbType = request.getParameter("tbType");
				String apprNo = request.getParameter("apprNo");
				String apprType = request.getParameter("apprType");
				String viewType = request.getParameter("viewType");
				
				if( apprNo != null & !"".equals(apprNo) ) {
					if( param != null && !"".equals(param) ) {
						param += "&";
					}
					param += "apprNo="+apprNo;
				} 
				if( tbType != null & !"".equals(tbType) ) {
					if( param != null && !"".equals(param) ) {
						param += "&";
					}
					param += "tbType="+tbType;
				}
				if( tbKey != null & !"".equals(tbKey) ) {
					if( param != null && !"".equals(param) ) {
						param += "&";
					}
					param += "tbKey="+tbKey;
				}
				if( callType != null & !"".equals(callType) ) {
					if( param != null && !"".equals(param) ) {
						param += "&";
					}
					param += "callType="+callType;
				}
				if( apprType != null & !"".equals(apprType) ) {
					if( param != null && !"".equals(param) ) {
						param += "&";
					}
					param += "apprType="+apprType;
				}
				if( viewType != null & !"".equals(viewType) ) {
					if( param != null && !"".equals(param) ) {
						param += "&";
					}
					param += "viewType="+viewType;
				}
			} else if( callType != null && "DEV".equals(callType) ) {
				String docNo = request.getParameter("docNo");
				String docVersion = request.getParameter("docVersion");
				if( docNo != null & !"".equals(docNo) ) {
					if( param != null && !"".equals(param) ) {
						param += "&";
					}
					param += "docNo="+docNo;
				}
				if( docVersion != null & !"".equals(docVersion) ) {
					if( param != null && !"".equals(param) ) {
						param += "&";
					}
					param += "docVersion="+docVersion;
				}
				if( userId != null & !"".equals(userId) ) {
					if( param != null && !"".equals(param) ) {
						param += "&";
					}
					param += "regUserId="+userId;
				}
				if( callType != null & !"".equals(callType) ) {
					if( param != null && !"".equals(param) ) {
						param += "&";
					}
					param += "callType="+callType;
				}
			}
			
			if( returnURL != null && !"".equals(returnURL)) {
				System.err.println("####### returnURL: " + returnURL+"?"+param);
				return "redirect:"+returnURL+"?"+param;
			} else {
				return "redirect:/main/main";
			}
		} else {
			if( isLock ) {
				userService.logout(request);
				return "redirect:/user/userlock";
			} else {
				return "redirect:/user/logout";
			}
		}
	}
	
	@RequestMapping(value="logon")
	public String logon(HttpServletRequest req, HttpServletResponse resp, ModelMap model){
		return "/SSOClient/Logon";
	}
	
	@RequestMapping(value="denied")
	public String denied(HttpServletRequest req, HttpServletResponse resp, ModelMap model){
		return "/SSOClient/Denied";
	}
	
	@RequestMapping(value="default")
	public String defaultPage(HttpServletRequest req, HttpServletResponse resp, ModelMap model){
		return "/SSOClient/Default";
	}
	
	@RequestMapping(value="updateSSOConfig")
	public String updateSSOConfig(HttpServletRequest req, HttpServletResponse resp, ModelMap model){
		return "/SSOClient/UpdateSSOConfig";
	}
	
	@RequestMapping(value="viewSSOConfig")
	public String viewSSOConfig(HttpServletRequest req, HttpServletResponse resp, ModelMap model){
		return "/SSOClient/ViewSSOConfig";
	}
	
	@RequestMapping(value = "/ssoLoginCheckTest")
	public String ssoLoginCheckTest(HttpServletRequest request, HttpServletResponse response) throws Exception {
		return "/SSOClient/ssoLoginCheckTest";
	}
	
	@RequestMapping(value = "/ssoLoginCheck")
	public String ssoLoginCheck(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		boolean ssoResult = false;
		boolean isLock = false;
		boolean isDelete = false;
		String userId = request.getParameter("userId");
		if( userId == null || "".equals(userId) ) {
			ssoResult  = false;
		} else {
			UserVO userVO = new UserVO();
			userVO.setUserId(userId);
			try {
				userService.login(userVO, request);
				ssoResult = true;
			} catch( CommonException ce ) {
				if(ce.getMessage().equals("USER_LOCK")){
					isLock = true;
				} else if(ce.getMessage().equals("USER_DELETE")){
					isDelete = true;
				}
				ssoResult = false;
			} catch( Exception e ) {
				ssoResult = false;
			}
		}

		if( ssoResult) {
			String returnURL = request.getParameter("returnURL");
			String param = "";
			String callType = request.getParameter("callType");
			if( callType != null && ("MAIL".equals(callType) || "REF".equals(callType) )) {			
				String tbKey = request.getParameter("tbKey");
				String tbType = request.getParameter("tbType");
				String apprNo = request.getParameter("apprNo");
				String apprType = request.getParameter("apprType");
				String viewType = request.getParameter("viewType");
				
				if( apprNo != null & !"".equals(apprNo) ) {
					if( param != null && !"".equals(param) ) {
						param += "&";
					}
					param += "apprNo="+apprNo;
				}
				if( tbType != null & !"".equals(tbType) ) {
					if( param != null && !"".equals(param) ) {
						param += "&";
					}
					param += "tbType="+tbType;
				}
				if( tbKey != null & !"".equals(tbKey) ) {
					if( param != null && !"".equals(param) ) {
						param += "&";
					}
					param += "tbKey="+tbKey;
				}
				if( callType != null & !"".equals(callType) ) {
					if( param != null && !"".equals(param) ) {
						param += "&";
					}
					param += "callType="+callType;
				}
				if( apprType != null & !"".equals(apprType) ) {
					if( param != null && !"".equals(param) ) {
						param += "&";
					}
					param += "apprType="+apprType;
				}
				if( viewType != null & !"".equals(viewType) ) {
					if( param != null && !"".equals(param) ) {
						param += "&";
					}
					param += "viewType="+viewType;
				}
			} else if( callType != null && "DEV".equals(callType) ) {
				String docNo = request.getParameter("docNo");
				String docVersion = request.getParameter("docVersion");
				if( docNo != null & !"".equals(docNo) ) {
					if( param != null && !"".equals(param) ) {
						param += "&";
					}
					param += "docNo="+docNo;
				}
				if( docVersion != null & !"".equals(docVersion) ) {
					if( param != null && !"".equals(param) ) {
						param += "&";
					}
					param += "docVersion="+docVersion;
				}
				if( userId != null & !"".equals(userId) ) {
					if( param != null && !"".equals(param) ) {
						param += "&";
					}
					param += "regUserId="+userId;
				}
				if( callType != null & !"".equals(callType) ) {
					if( param != null && !"".equals(param) ) {
						param += "&";
					}
					param += "callType="+callType;
				}
			}
			
			if( returnURL != null && !"".equals(returnURL)) {
				return "redirect:"+returnURL+"?"+param;
			} else {
				return "redirect:/main/main";
			}
		} else {
			if( isLock ) {
				userService.logout(request);
				return "redirect:/user/userlock";
			}
			if( isDelete ) {
				userService.logout(request);
				return "redirect:/user/userDelete";
			}
			return "redirect:/user/logout";
		}
	}
}
