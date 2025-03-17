package kr.co.aspn.dao;

import java.util.List;
import java.util.Map;

import kr.co.aspn.vo.ProxyVO;

public interface ProxyDao {

	int proxyTotalCount(Map<String, Object> param) throws Exception;

	List<ProxyVO> proxyList(Map<String, Object> param) throws Exception;

	int proxyDataCount(Map<String, Object> param) throws Exception;

	int insert(Map<String, Object> param) throws Exception;

	int delete(Map<String, Object> param) throws Exception;

}
