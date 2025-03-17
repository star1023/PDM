package kr.co.aspn.common.auth;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.co.aspn.util.CookieUtil;
import kr.co.aspn.util.StringUtil;


public class AuthUtil {
	public static final String COOKIE_KEY = "SLLAB_AUTH";
	public static final String COOKIE_SAVE_ID = "SLLAB_SAVE_ID";
	public static final String SESSION_KEY = "SESS_AUTH";
	public static final String AUTH_KEY = "AUTH";
	public static int SESSION_TIME = 60 * 60 * 2;
	
	/**
	 * �?��?? ??�? 조�?
	 *
	 * @param request
	 * @return
	 * @throws Exception
	 */
	public static Auth getAuth(HttpServletRequest request) throws Exception {
		HttpSession session = request.getSession();
		Auth auth = (Auth) session.getAttribute(SESSION_KEY);
		return auth != null ? auth : new Auth();
	}

	/**
	 * �?��?? ??�? 조�? ???? ??보�? ???? 경�? �?? ??보�?? ?????? ??????.
	 *
	 * @param request
	 * @return
	 * @throws Exception
	 */
	public static Auth getAuth(HttpServletRequest request, HttpServletResponse response) throws Exception {
		Auth auth = getAuth(request);

		// if (auth == null) {
		// auth = getAuthByToekn(request, response);
		// if (auth != null)
		// setAuth(request, auth);
		// }

		return auth != null ? auth : new Auth();
	}

	/**
	 * �?��?? ??�? set
	 *
	 * @param request
	 * @param auth
	 * @throws Exception
	 */
	public static void setAuth(HttpServletRequest request, Auth auth) throws Exception {
		removeAuth(request);
		HttpSession session = request.getSession();

		if (auth == null) {
			auth = new Auth();
		}

		auth.setUserIp(getClientIpAddress(request));
		auth.setSessionId(session.getId());

		session.setAttribute(SESSION_KEY, auth);
		session.setMaxInactiveInterval(SESSION_TIME);
	}

	/**
	 * �?��?? session ????
	 *
	 * @param request
	 * @throws Exception
	 */
	public static void removeAuth(HttpServletRequest request) throws Exception {
		HttpSession session = request.getSession();
		session.removeAttribute(SESSION_KEY);
	}

	/**
	 * ???? �? �?? ??�?
	 *
	 * @param request
	 * @param response
	 * @param auth
	 * @throws Exception
	 */
	public static void setAuth(HttpServletRequest request, HttpServletResponse response, Auth auth) throws Exception {
		setAuth(request, auth);
		// CookieUtil cu = new CookieUtil(request, response);
		// String encAuth = CryptoUtil.encrypt(auth.toToken());
		// cu.setMaxAge(-1);
		// cu.setCookie(COOKIE_KEY, encAuth);
	}

	/**
	 * �?��?? ??�?
	 *
	 * @param request
	 * @throws Exception
	 */
	public static boolean hasAuth(HttpServletRequest request) throws Exception {
		Auth auth = getAuth(request);
		
		return StringUtil.isNotEmpty(auth.getUserId());
	}

	/**
	 * ???? �? �?? ????
	 *
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	public static void removeAuth(HttpServletRequest request, HttpServletResponse response) throws Exception {
		removeAuth(request);
		// CookieUtil cu = new CookieUtil(request, response);
		// cu.clearCookie(COOKIE_KEY);
	}

	/**
	 * �?? ??????�? �??? �?��?? ??�? ????
	 *
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public static Auth getAuthByToekn(HttpServletRequest request, HttpServletResponse response) throws Exception {
		Auth auth = null;

		// try {
		// String authToken = getAuthToken(request, response);
		// String decAuthToken = CryptoUtil.decrypt(authToken);
		// auth = parseAuthToken(decAuthToken);
		// } catch (Exception ex) {
		// logger.error("ERROR::AUTH::getAuthByToken:{}", ex.toString());
		// }

		return auth;
	}

	/**
	 * �?? ????�? �??
	 *
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public static String getAuthToken(HttpServletRequest request, HttpServletResponse response) throws Exception {
		CookieUtil cu = new CookieUtil(request, response);
		return cu.getCookie(COOKIE_KEY);
	}

	/**
	 * ???? ????�??�? Auth �??
	 *
	 * @param authToken
	 * @return
	 * @throws Exception
	 */
	public static Auth parseAuthToken(String authToken) throws Exception {
		Map<String, String> map = new HashMap<String, String>();
		String[] auths = StringUtil.split(authToken, ",");
		for (String row : auths) {
			String[] data = StringUtil.split(row, "=");
			String key = data[0].trim();
			String value = data[1].trim();
			map.put(key, value);
		}

		Auth auth = new Auth();
		// auth.setMemberCode(map.get("memberCode"));
		// auth.setMemberName(map.get("memberName"));
		// auth.setWebId(map.get("webId"));
		// auth.setEmail(map.get("email"));
		// auth.setHandphoneNo(map.get("handphoneNo"));
		// auth.setMemberRnk(map.get("memberRnk"));
		// auth.setParentInfoRegYn(map.get("parentInfoRegYn"));
		// auth.setWebNormalInfoRegYn(map.get("webNormalInfoRegYn"));
		// auth.setMemberTypeCode(map.get("memberTypeCode"));
		// auth.setMemberStatCode(map.get("memberStatCode"));
		//
		// // String studentList = map.get("studentList");
		//
		// auth.setStudentList(null);

		return auth;
	}

	/*
	 * private static final String[] HEADERS_TO_TRY = { "X-Forwarded-For",
	 * "Proxy-Client-IP", "WL-Proxy-Client-IP", "HTTP_X_FORWARDED_FOR",
	 * "HTTP_X_FORWARDED", "HTTP_X_CLUSTER_CLIENT_IP", "HTTP_CLIENT_IP",
	 * "HTTP_FORWARDED_FOR", "HTTP_FORWARDED", "HTTP_VIA", "REMOTE_ADDR" };
	 */

	private static final String[] HEADERS_TO_TRY = { "HTTP_CLIENT_IP", "HTTP_X_FORWARDED_FOR", "HTTP_X_FORWARDED",
			"HTTP_X_CLUSTER_CLIENT_IP", "HTTP_FORWARDED_FOR", "HTTP_FORWARDED" };

	public static String getClientIpAddress(HttpServletRequest request) {
		/*for (String header : HEADERS_TO_TRY) {
			String ip = request.getHeader(header);
			if (ip != null && (ip.length() != 0 && ip.length() >= 20) && !"unknown".equalsIgnoreCase(ip)) {
				return ip;
			}
		}*/
		
		String ip = request.getHeader("X-Forwarded-For");
        if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_CLIENT_IP");
        }
        if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_X_FORWARDED_FOR");
        }
        if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
		return ip;
		//return request.getRemoteAddr();
	}
	
	public static boolean isEmpty(String str) {
		return ((str == null) || (str.length() == 0));
	}
	/**
	 * null 체�?
	 *
	 * @param str
	 * @return
	 */
	public static boolean isEmpty(Object str) {
		
		if(str == null) {
			return true;
		}
		
		return isEmpty(str.toString()) ;
	}
}
