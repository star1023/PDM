package kr.co.aspn.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.aspn.common.auth.AuthUtil;
import kr.co.aspn.dao.ApprovalDao;
import kr.co.aspn.dao.DesignRequestDao;
import kr.co.aspn.service.ApprovalService;
import kr.co.aspn.service.DesignRequestService;

@Service
public class DesignRequestServiceImpl implements DesignRequestService {

	@Autowired
	DesignRequestDao designRequestDao;
	
	@Autowired
	ApprovalDao approvalDao;
	
	@Override
	public List<Map<String, Object>> newDesignRequestDocList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return designRequestDao.newDesignRequestDocList(param);
	}

	@Override
	public Map<String, Object> designRequestPopupList(Map<String, Object> param, HttpServletRequest request) throws Exception {
		// TODO Auto-generated method stub
		
		Map<String,Object> map  = new HashMap<String, Object>();
		
		String userId =  AuthUtil.getAuth(request).getUserId();
		
		String tbType = (String)param.get("tbType");
		
		Map<String,Object> param_1 = new HashMap<String,Object>();
		
		param_1.put("userId",userId);
		
		List<Map<String,Object>> regUserData = approvalDao.selectRegUserInfo(param_1);
		
		map.put("regUserData", regUserData);
		
		List<Map<String,Object>> defalutUserList = new ArrayList<Map<String,Object>>();
		
		defalutUserList.add(regUserData.get(0));
		
		defalutUserList.get(0).put("seq", "3");
		
		defalutUserList.get(0).put("type", "2차 검토");
		
		map.put("defaultUserList", defalutUserList);
		
		String ddNo = "9638";	//		String ddNo = (String)param.get("tbKey");
		
		List<Map<String,Object>> keyData = approvalDao.keyData(ddNo);
		
		List<Map<String,Object>> data1 = new ArrayList<Map<String,Object>>();
		
		param_1.put("docNo", keyData.get(0).get("docNo"));
		
		param_1.put("docVersion", keyData.get(0).get("docVersion"));
		
		data1 = designRequestDao.newDesignRequestDocList(param_1);
		
		param_1.put(tbType, tbType);
		
		List<Map<String,Object>> approvalLineList = approvalDao.approvalLineList(param_1);
		
		map.put("data1", data1);
		map.put("tbType",tbType);
		map.put("userId",userId);
		map.put("approvalLineList", approvalLineList);
		
		return map;
	}

	@Override
	public int designRequestDocSave(Map<String, Object> param) {
		// TODO Auto-generated method stub
		
		int drpNo = 0;
		
		Map<String,Object> map = designRequestDao.designRequestDocMax(param);
		
		if(map !=null) {
			if(String.valueOf(map.get("drpNo"))!=null || !String.valueOf(map.get("drpNo")).equals("") ) {
				drpNo = Integer.parseInt(String.valueOf(map.get("drpNo")));
			}
		}

		try {
			
			param.put("drpNo", drpNo+1);
			
			designRequestDao.designRequestDocSave(param);
			
			
		}catch(Exception e){
			
			e.printStackTrace();
			//throw e;
		}
		return drpNo+1;
	}

	@Override
	public List<Map<String, Object>> designRequestDocView(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return designRequestDao.designRequestDocView(param);
	}

	@Override
	public void updateCommentTbKey(Map<String, Object> param) {
		// TODO Auto-generated method stub
		designRequestDao.updateCommentTbKey(param);
	}

	@Override
	public void designRequestDocStateUpdate(String tbKey, String state) {
		// TODO Auto-generated method stub
		
		String [] drNos = tbKey.split(",");
		
		for(int i = 0; i<drNos.length;i++) {
		
			Map<String,Object> param = new HashMap<String,Object>();
			param.put("drNo", drNos[i]);
			param.put("state", state);
		
			designRequestDao.designRequestDocStateUpdate(param);
		}
		
	}

	

}
