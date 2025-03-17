package kr.co.aspn.dao.impl;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.aspn.dao.ProxyDao;
import kr.co.aspn.vo.ProxyVO;

@Repository
public class ProxyDaoImpl implements ProxyDao {
	@Autowired
	SqlSessionTemplate sqlSessionTemplate;
	
	@Override
	public int proxyTotalCount(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("proxy.proxyTotalCount", param);
	}

	@Override
	public List<ProxyVO> proxyList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("proxy.proxyList", param);
	}

	@Override
	public int proxyDataCount(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("proxy.proxyDataCount", param);
	}

	@Override
	public int insert(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.insert("proxy.insert", param);
	}

	@Override
	public int delete(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.update("proxy.delete", param);
	}

}
