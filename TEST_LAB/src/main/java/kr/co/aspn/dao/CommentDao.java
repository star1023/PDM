package kr.co.aspn.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface CommentDao {

	List<Map<String, Object>> getCommentList(HashMap<String, Object> param);

	int addComment(HashMap<String, Object> param);
	int updateComment(HashMap<String, Object> param);
	int deleteComment(HashMap<String, Object> param);

	Map<String, Object> getDevDocParam(HashMap<String, Object> param);


}
