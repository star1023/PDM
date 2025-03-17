package kr.co.aspn.dao;

import java.util.List;
import java.util.Map;

public interface DesignRequestDao {

	public List<Map<String,Object>> newDesignRequestDocList(Map<String,Object> param);

	public Map<String,Object> designRequestDocMax(Map<String,Object> param);
	
	public void designRequestDocSave(Map<String,Object> param);

	public List<Map<String,Object>> designRequestDocView(Map<String,Object> param);
	
	public void updateCommentTbKey(Map<String,Object> param);
	
	public void designRequestDocStateUpdate(Map<String,Object> param);
}
