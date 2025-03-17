package kr.co.aspn.dao.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.aspn.dao.CommentDao;

@Repository("commentRepo")
public class CommentDaoImpl implements CommentDao{
	@Autowired
	SqlSessionTemplate sqlSessionTemplate;
	
	@Override
	public List<Map<String, Object>> getCommentList(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectList("comment.getCommentList", param);
	}
	
	@Override
	public int addComment(HashMap<String, Object> param) {
		return sqlSessionTemplate.insert("comment.addComment", param);
	}
	
	@Override
	public int updateComment(HashMap<String, Object> param) {
		return sqlSessionTemplate.update("comment.updateComment", param);
	}
	
	@Override
	public int deleteComment(HashMap<String, Object> param) {
		return sqlSessionTemplate.update("comment.deleteComment", param);
	}
	
	@Override
	public Map<String, Object> getDevDocParam(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectOne("comment.getDevDocParam", param);
	}
}
