package kr.co.aspn.service;

import java.util.Map;

public interface ProxyService {

	Map<String, Object> proxyList(Map<String, Object> param) throws Exception;

	Map<String, Object> insert(Map<String, Object> param) throws Exception;

	void delete(Map<String, Object> param) throws Exception;

}
