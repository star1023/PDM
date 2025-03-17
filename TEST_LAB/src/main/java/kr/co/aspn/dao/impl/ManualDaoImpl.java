package kr.co.aspn.dao.impl;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.aspn.dao.ManualDao;

@Repository
public class ManualDaoImpl implements ManualDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	@Override
	public int selectManualCount(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("manual.selectManualCount", param);
	}

	@Override
	public List<Map<String, Object>> selectManualList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("manual.selectManualList", param);
	}

}
