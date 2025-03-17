package kr.co.aspn.service;

import java.util.Map;

public interface LogService {

	Map<String, Object> getLoginLogList(Map<String, Object> param) throws Exception;

	Map<String, Object> getBomLogList(Map<String, Object> param) throws Exception;

	Map<String, Object> commonLogListAjax(Map<String, Object> param) throws Exception;

	Map<String, Object> printLogListAjax(Map<String, Object> param) throws Exception;
}
