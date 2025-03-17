package kr.co.aspn.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.aspn.dao.CommonDao;
import kr.co.aspn.dao.DevdocManagementDao;
import kr.co.aspn.service.DevdocManagementService;

@Service
public class DevdocManagementServiceImpl implements DevdocManagementService {
	@Autowired 
	DevdocManagementDao devdocManagementDao;
	
	@Override
	public List<Map<String, String>> devDocList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		List<Map<String, String>> docList = null;
		if(param.get("docType") != null && "D".equals(param.get("docType")) ) {
			docList = devdocManagementDao.menuDocList(param);
		} else {
			docList = devdocManagementDao.devDocList(param);
		}
		return docList;
	}

	@Override
	public void userChange(String[] changeDocNo, String[] changeRegUserId, String targetUserId) throws Exception {
		// TODO Auto-generated method stub
		for( int i = 0 ; i < changeDocNo.length ; i++ ) {
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("ddNo", changeDocNo[i]);
			param.put("docNo", changeDocNo[i]);
			param.put("regUserId", changeRegUserId[i]);
			param.put("userId", targetUserId);
			param.put("docName", "제품개발문서");
			devdocManagementDao.userChange(param);
			devdocManagementDao.insertChangeLog(param);
		}
		//devdocManagementDao.userChange(target_ddNo_sel, changeRegUserId, targetUserId);
	}

	@Override
	public List<Map<String, Object>> manufacturingProcessDocList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return devdocManagementDao.manufacturingProcessDocList(param);
	}

	@Override
	public void userChangeMenuDoc(String[] changePNo, String[] changePNoRegUserId, String targetUserId)
			throws Exception {
		// TODO Auto-generated method stub
		for( int i = 0 ; i < changePNo.length ; i++ ) {
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("pNo", changePNo[i]);
			param.put("docNo", changePNo[i]);
			param.put("regUserId", changePNoRegUserId[i]);
			param.put("userId", targetUserId);
			param.put("docName", "제품설계서");
			devdocManagementDao.userChangeMenuDoc(param);
			devdocManagementDao.insertChangeLog(param);
		}
	}
	
	@Override
	public void launchDateUpdate(Map<String, Object> param) {
		// TODO Auto-generated method stub
		devdocManagementDao.launchDateUpdate(param);
	}

}
