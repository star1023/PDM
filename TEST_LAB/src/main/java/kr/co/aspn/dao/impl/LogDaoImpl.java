package kr.co.aspn.dao.impl;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.aspn.dao.LogDao;

@Repository
public class LogDaoImpl implements LogDao{
	private Logger logger = LoggerFactory.getLogger(LogDaoImpl.class);
	
	@Autowired
	SqlSessionTemplate sqlSessionTemplate;
	
	@Override
	public int getLoginLogListTotal(Map<String, Object> param) {
		return sqlSessionTemplate.selectOne("log.getLoginLogListTotal", param);
	}
	
	@Override
	public List<Map<String, Object>> getLoginLogList(Map<String, Object> param) {
		return sqlSessionTemplate.selectList("log.getLoginLogList", param);
	}
	
	@Override
	public int getBomLogListTotal(Map<String, Object> param) {
		return sqlSessionTemplate.selectOne("log.getBomLogListTotal", param);
	}
	
	@Override
	public List<Map<String, Object>> getBomLogList(Map<String, Object> param) {
		return sqlSessionTemplate.selectList("log.getBomLogList", param);
	}
	
	@Override
	public int getCommonLogListTotal(Map<String, Object> param) {
		return sqlSessionTemplate.selectOne("log.getCommonLogListTotal", param);
	}
	
	@Override
	public List<Map<String, Object>> getCommonLogList(Map<String, Object> param) {
		return sqlSessionTemplate.selectList("log.getCommonLogList", param);
	}
	
	@Override
	public int getPrintLogListTotal(Map<String, Object> param) {
		return sqlSessionTemplate.selectOne("log.getPrintLogListTotal", param);
	}
	
	@Override
	public List<Map<String, Object>> getPrintLogList(Map<String, Object> param) {
		return sqlSessionTemplate.selectList("log.getPrintLogList", param);
	}
}
