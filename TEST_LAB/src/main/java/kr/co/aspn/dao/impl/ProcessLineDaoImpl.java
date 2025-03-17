package kr.co.aspn.dao.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.aspn.dao.ProcessLineDao;
import kr.co.aspn.vo.ProcessLineVO;

@Repository
public class ProcessLineDaoImpl implements ProcessLineDao {
	@Autowired
	SqlSessionTemplate sqlSessionTemplate;

	@Override
	public List<ProcessLineVO> getList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("processLine.list", param);
	}

	@Override
	public List<Map<String, Object>> getLineCode(String plantName) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("processLine.getLineCode", plantName);
	}
}
