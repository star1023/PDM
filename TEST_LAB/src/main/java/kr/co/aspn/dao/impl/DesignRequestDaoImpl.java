package kr.co.aspn.dao.impl;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.aspn.dao.DesignRequestDao;

@Repository
public class DesignRequestDaoImpl implements DesignRequestDao{

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	@Override
	public List<Map<String, Object>> newDesignRequestDocList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("designRequest.newDesignRequestDocList", param);
	}
	
	@Override
	public Map<String,Object> designRequestDocMax(Map<String,Object> param) {
		
		return sqlSessionTemplate.selectOne("designRequest.designRequestDocMax", param);
	}

	@Override
	public void designRequestDocSave(Map<String, Object> param) {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("designRequest.designRequestDocSave", param);
		
	}

	@Override
	public List<Map<String, Object>> designRequestDocView(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("designRequest.designRequestDocView", param);
	}

	@Override
	public void updateCommentTbKey(Map<String, Object> param) {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("designRequest.updateCommentTbKey", param);
	}

	@Override
	public void designRequestDocStateUpdate(Map<String,Object> param) {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("designRequest.designRequestDocStateUpdate", param);
	}
}
