<%@ page import="nets.websso.ssoclient.authcheck.*" %>
<%@ page import="java.io.FileInputStream" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.co.aspn.vo.*" %>
<%@ page import="kr.co.aspn.util.exception.*" %>
<%@ page import="kr.co.aspn.service.*" %>
<%@ page import="kr.co.aspn.service.impl.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<html>
<head><title>SSO 통합인증 테스트 사이트</title></head>
<%
    String navigateUrl = "";
	
	boolean ssoResult = false;
	
	boolean isLock = false;
	
	String url = "";

	String HPW_UserId = "";
	
	UserService userService = (UserService)new UserServiceImpl();
	
	boolean isFirst = true;
	String params = "";
	Enumeration<String> paramEnum = request.getParameterNames();
	while(paramEnum.hasMoreElements()){
		String paramName = paramEnum.nextElement();
		String paramValue = request.getParameter(paramName);
		
		if(isFirst){
			params = paramName+"="+paramValue;
			isFirst = false;
		} else {
			params += "&" + paramName+"="+paramValue;
		}
	}
	
	System.err.println(params);
	
	System.err.println("\n [][][]  IN JSP START [][][]");
	String userId = "";
	try {
	    SSOConfig.request = request;
	    AuthCheck auth = new AuthCheck(request, response);
	    AuthStatus status = auth.CheckLogon(AuthCheckLevel.Medium);
	    
	    System.err.println("####### RequestURI(): + " + request.getRequestURI());
	    System.err.println("####### Parameter 'userId' : " + request.getParameter("userId"));
	    System.err.println("####### auth.checkAvailable(): " + auth.checkAvailable());
	    
	    System.err.println("");
	    System.err.println("####### status: " + status);
	    if (status == AuthStatus.SSOFirstAccess) {
	    	System.err.println("####### status == AuthStatus.SSOFirstAccess");
	        auth.TrySSO();
	    } else if (status == AuthStatus.SSOSuccess) {
	    	System.err.println("####### status == AuthStatus.SSOSuccess");
	    	userId = auth.UserID();
	    	
	    	System.err.println("####### auth.UserID(): " + auth.UserID());
	    	
	    	Cookie c = Util.getCookie(request.getCookies(), SSOConfig.SSODomainTokenName());
	    	String domainAuthCookie = Util.DecryptDomainCookie(c.getValue());
	    	System.err.println("####### 도메인 인증 쿠키: " + domainAuthCookie  + "");
	    	
	    	if(SSOConfig.SSODomainCookieInfos() != null && SSOConfig.SSODomainCookieInfos().length > 0 ) {
	    		for(int i = 0 ; i < SSOConfig.SSODomainCookieInfos().length ; i++){
	    			CookieInfo domainAddCookie = SSOConfig.SSODomainCookieInfos()[i];
	    			System.err.println(domainAddCookie.Name()+ " : " + auth.GetSSODomainCookieValue(domainAddCookie.Name()) + "");
	    		}
	    	}
	    	
	    	if( userId == null || "".equals(userId) ) {
				 ssoResult = false;
				 System.err.println("####### => userId == null || ''.equals(userId)");
			 }else {
				 UserVO userVO = new UserVO();
				 userVO.setUserId(userId);
				try {
					userService.login(userVO, request);
					ssoResult = true;
					System.err.println("####### ==> try ");
				} catch( CommonException ce ) {
					if(ce.getMessage().equals("USER_LOCK")) {
						isLock = true;
					}
					ssoResult = false;
					System.err.println("####### ==> catch CommonException");
				} catch( Exception e ) {
					ssoResult = false;
					System.err.println("####### ==> catch Exception");
				}
			 }
	    } else if (status == AuthStatus.SSOFail) {
	    	System.err.println("####### status == AuthStatus.SSOFail");
	    	ssoResult = false;
	    }
	} catch (Exception ex) {
		ex.printStackTrace();
		System.err.println("####### printStackTrace printStackTrace printStackTrace : " + ex.toString() + ", " + ex.getMessage());
		ssoResult = false;
	}
	
	System.err.println("");
	System.err.println("###### last ssoResult: " + ssoResult);
	System.err.println(" [][][]  IN JSP END [][][]");
	
	
	ssoResult= true;
	
    if(ssoResult) {
		
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
			if( HPW_UserId != null & !"".equals(HPW_UserId) ) {
				if( param != null && !"".equals(param) ) {
					param += "&";
				}
				param += "regUserId="+HPW_UserId;
			}
			if( callType != null & !"".equals(callType) ) {
				if( param != null && !"".equals(param) ) {
					param += "&";
				}
				param += "callType="+callType;
			}
		}
		
		System.err.println("returnURL: " + "/ssoLoginCheckTest2?"+params);
		if( returnURL != null && !"".equals(returnURL)) {
			//response.sendRedirect("redirect:"+returnURL+"?"+param);
			response.sendRedirect("/ssoLoginCheckTest2?"+params);
		} else {
			response.sendRedirect("/main/main");
		}
	}else {
		System.err.println("else");
		if( isLock ) {
			userService.logout(request);
			response.sendRedirect("/user/userlock");
		} else {
			response.sendRedirect("/user/logout");
		}
	}
%>
<script language="javascript" type="text/javascript">
    function OnLogoff() {
        document.location.href = "<%=navigateUrl%>";
    }
</script>
<body>
</body>
</html>
