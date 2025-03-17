package kr.co.aspn.dao.impl;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.aspn.dao.QuickDao;
import kr.co.aspn.vo.ProcessLineVO;

@Repository
public class QuickDaoImpl implements QuickDao{
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	/*
	 * @Override public List<ProcessLineVO> getList(Map<String, Object> param) { //
	 * TODO Auto-generated method stub return
	 * sqlSessionTemplate.selectList("processLine.list", param); }
	 */
	
	@Override
	public int registQuick(Map<String, Object> param) {
		return sqlSessionTemplate.insert("quick.registQuick", param);
	}
	
	@Override
	public List<Map<String, Object>> getQuickInfoList(Map<String, Object> param) {
		return sqlSessionTemplate.selectList("quick.getQuickInfoList", param);
	}
	
	@Override
	public int deleteQuickInfo(Map<String, Object> param) {
		return sqlSessionTemplate.update("quick.deleteQuickInfo", param);
	}
}
