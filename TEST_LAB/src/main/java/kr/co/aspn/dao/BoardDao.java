package kr.co.aspn.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface BoardDao {

	int getBoardListCount(HashMap<String, Object> param);

	List<Map<String, Object>> getBoardList(HashMap<String, Object> param);

	int registPost(HashMap<Object, Object> param);

	Map<String, Object> getPostDetail(HashMap<String, Object> param);

	int deletePost(HashMap<Object, Object> param);

	int modifyPost(HashMap<Object, Object> param);

	int updateHits(HashMap<String, Object> param);

}
