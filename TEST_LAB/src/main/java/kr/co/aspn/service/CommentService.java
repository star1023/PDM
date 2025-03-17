package kr.co.aspn.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface CommentService {

	public List<Map<String, Object>> getCommentList(String tbKey, String tbType);

	public int updateComment(String cNo, String comment);

	public String addComment(HashMap<String, Object> param);

	public int deleteComment(String cNo);

	public Map<String, Object> getDevDocParam(HashMap<String, Object> param);
}
