package kr.co.aspn.common.interceptor;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.fasterxml.jackson.databind.ObjectMapper;

import kr.co.aspn.common.auth.AuthUtil;
import kr.co.aspn.service.UserService;
import kr.co.aspn.util.MessageUtil;

public class AuthInterceptor extends HandlerInterceptorAdapter {
	private static final Logger logger = LoggerFactory.getLogger(AuthInterceptor.class);

	@Autowired
	private MessageSourceAccessor msa;
	
	@Autowired
	UserService userService;
	
	@SuppressWarnings({ "static-access", "unchecked" })
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		String sRequestUri = request.getRequestURI();
		logger.debug("사용자 접속 Uri. : "+sRequestUri);
		System.err.println("사용자 접속 Uri. : "+sRequestUri);
		
		boolean isExcept = false;
		boolean hasAuth = AuthUtil.hasAuth(request);
		logger.debug("hasAuth : "+hasAuth);
		System.err.println("hasAuth : "+hasAuth);
		System.err.println("user id : "+AuthUtil.getAuth(request).getUserId());
		
		List<String> exceptUriList = new ArrayList<String>();
		exceptUriList.add("/common");
		//exceptUriList.add("/test");
		exceptUriList.add("/data");
		exceptUriList.add("/design/getMaterialList");
		exceptUriList.add("Ajax");
		exceptUriList.add("/quick");
		exceptUriList.add("/dev/getNutritionTableView");
		exceptUriList.add("/dev/getNutritionTable");
		exceptUriList.add("/dev/getDevDocVersion");
		exceptUriList.add("/dev/getDevDocSummaryList");
		exceptUriList.add("/dev/getMfgsummaryList");
		
		exceptUriList.add("/qns/mfgLayout");
		exceptUriList.add("/qns/drLayout");
		//exceptUriList.add("/user/login");
		
		for (String exceptUri : exceptUriList) {
			if(sRequestUri.startsWith(exceptUri)){
				isExcept = true;
			}
			if(sRequestUri.indexOf(exceptUri) != -1){
				isExcept = true;
			}
		}
		
        // 예외로 지정된 URL을 호출한 경우 사용자 로그인 Check를 하지 않음
		if(!isExcept) {
            // 일반URL을 호출한 경우 Login 했는지 체크
			if(!hasAuth) {
				logger.debug("비정상접근 ");
				MessageUtil.showAlert(request, response, msa.getMessage("login.ing.use"), "/user/logout");
				return false;	
			}
		}
		
		if(!isExcept) {
			String[] keys = {"docno", "docversion", "companyCode", "dNoList", "dNoList[]", "dbkey", "tbtype", "dno", "seq", "drno", "drpno", "imno", "sapcode", "cno", "pno", "rno", "apprno", "nno"};
			String[] columns = {"docNo", "docVersion", "dNo"};
			List<String> allowKeyList = Arrays.asList(keys);
			HashMap<String, Object> param = new HashMap<String, Object>();
			
			Enumeration<String> paramsEnum = request.getParameterNames();
			Map<String, String> requestParam = new HashMap<String, String>();
			
			JSONObject json = new JSONObject();
			
			while (paramsEnum.hasMoreElements()) {
				String paramName = paramsEnum.nextElement();
				String pramValue = request.getParameter(paramName);
				
				//System.err.println(paramName + " : " + pramValue);
				
				/*if(paramName.equals("dNoList"))
					requestParam.put(paramName, pramValue);
				
				if(paramName.equals("docNo") || paramName.equals("tbKey") || paramName.equals("tbType") || paramName.equals("pNo")) {
					param.put(paramName, pramValue);
				}
				
				if(allowKeyList.indexOf(paramName.toLowerCase()) >= 0) {
					requestParam.put(paramName, pramValue);
				}*/
				
				requestParam.put(paramName, pramValue);
			}
			json.putAll(requestParam);
			
			//SimpleDateFormat 선언
			Date date = new Date();
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            //SimpleDateFormat 을 이용해 String 타입으로 가져오기  
			String serverTime = dateFormat.format(date);
			
			String logStr = "==== User Access Log ====";
			logStr += "\nsRequestUri : " + sRequestUri;
			logStr += "\ngetUserId : " + AuthUtil.getAuth(request).getUserId();
			logStr += "\nserverTime : " + serverTime;
			logger.debug(logStr);
			
			param.put("userId", AuthUtil.getAuth(request).getUserId());
			param.put("url", sRequestUri);
			param.put("time", serverTime);
			param.put("requestParams", json.toJSONString(requestParam));
			
			userService.insertAccessLog(param);
		}
		
		return true;
	}
}