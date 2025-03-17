package kr.co.aspn.dao.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.aspn.dao.BoardDao;

@Repository
public class BoardDaoImpl implements BoardDao{
	@Autowired
	SqlSessionTemplate sqlSessionTemplate;
	
	private Logger logger = LoggerFactory.getLogger(BoardDaoImpl.class);
	
	@Override
	public int getBoardListCount(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectOne("board.getBoardListCount", param);
	}
	
	@Override
	public List<Map<String, Object>> getBoardList(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectList("board.getBoardList", param);
	}
	
	@Override
	public int registPost(HashMap<Object, Object> param) {
		return sqlSessionTemplate.insert("board.registPost", param);
	}
	
	@Override
	public Map<String, Object> getPostDetail(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectOne("board.getPostDetail", param);
	}
	
	@Override
	public int deletePost(HashMap<Object, Object> param) {
		return sqlSessionTemplate.update("board.deletePost", param);
	}
	
	@Override
	public int modifyPost(HashMap<Object, Object> param) {
		return sqlSessionTemplate.update("board.modifyPost", param);
	}
	
	@Override
	public int updateHits(HashMap<String, Object> param) {
		return sqlSessionTemplate.update("board.updateHits", param);
	}
}
