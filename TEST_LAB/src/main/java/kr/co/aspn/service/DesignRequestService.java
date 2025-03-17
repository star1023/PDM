package kr.co.aspn.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

public interface DesignRequestService {

	public List<Map<String,Object>> newDesignRequestDocList(Map<String,Object> param);
	
	public Map<String,Object> designRequestPopupList(Map<String,Object> param,HttpServletRequest request) throws Exception;

	public int designRequestDocSave(Map<String,Object> param);
	
	public List<Map<String,Object>> designRequestDocView(Map<String,Object> param);
	
	public void updateCommentTbKey(Map<String,Object> param);
	
	public void designRequestDocStateUpdate(String tbKey, String state);
}


