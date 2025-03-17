package kr.co.aspn.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.aspn.dao.CommonDao;
import kr.co.aspn.service.CommonService;
import kr.co.aspn.util.PageNavigator;
import kr.co.aspn.vo.CodeItemVO;
import kr.co.aspn.vo.CompanyVO;
import kr.co.aspn.vo.FileVO;
import kr.co.aspn.vo.PlantLineVO;
import kr.co.aspn.vo.PlantVO;
import kr.co.aspn.vo.ReportVO;
import kr.co.aspn.vo.StorageVO;
import kr.co.aspn.vo.UnitVO;
import kr.co.aspn.vo.UserVO;

@Service
public class CommonServiceImpl implements CommonService {

	@Autowired 
	CommonDao commonDao;
	
	@Override
	public List<PlantLineVO> getPlantLine(Map<String, Object> param) {
		return commonDao.getPlantLine(param);
	}
	
	@Override
	public List<PlantVO> getPlant(Map<String, Object> param) throws Exception{
		// TODO Auto-generated method stub
		return commonDao.getPlant(param);
	}

	@Override
	public List<CompanyVO> getCompany() throws Exception{
		// TODO Auto-generated method stub
		List<CompanyVO> companyList = commonDao.getCompany();
		return companyList;
	}

	@Override
	public List<UnitVO> getUnit() throws Exception{
		// TODO Auto-generated method stub
		return commonDao.getUnit();
	}

	@Override
	public List<CodeItemVO> getCodeList(CodeItemVO code) throws Exception{
		// TODO Auto-generated method stub
		return commonDao.getCodeList(code);
	}

	@Override
	public List<Map<String, String>> searchUserId(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return commonDao.searchUserId(param);
	}

	@Override
	public List<Map<String, String>> getCodeListAjax(CodeItemVO code) throws Exception{
		// TODO Auto-generated method stub
		return commonDao.getCodeListAjax(code);
	}

	@Override
	public Map<String, Object> popupSearchUser(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		Map<String, Object> map = new HashMap<String, Object>();
		
		int totalCount = commonDao.searchUserCount(param);
		
		// 페이징: 페이징 정보 SET
		PageNavigator navi = new PageNavigator(param, totalCount);
		
		List<UserVO> userList = commonDao.searchUserList(param);
		
		map.put("userList", userList);
		map.put("totalCount", totalCount);
		map.put("navi", navi);
		map.put("paramVO", param);
		return map;
	}

	@Override
	public Map<String, Object> userListAjax(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		Map<String, Object> map = new HashMap<String, Object>();
		
		int totalCount = commonDao.searchUserCount(param);
		
		// 페이징: 페이징 정보 SET
		PageNavigator navi = new PageNavigator(param, totalCount);
		
		List<UserVO> userList = commonDao.searchUserList(param);
		
		map.put("userList", userList);
		map.put("totalCount", totalCount);
		map.put("navi", navi);
		map.put("paramVO", param);
		return map;
	}

	@Override
	public List<Map<String, Object>> userListAjax2(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return commonDao.searchUserList2(param);
	}

	@Override
	public int notificationCount(Map<String, String> param) throws Exception {
		// TODO Auto-generated method stub
		return commonDao.notificationCount(param);
	}

	@Override
	public List<Map<String, Object>> notificationList(Map<String, String> param) throws Exception {
		// TODO Auto-generated method stub
		return commonDao.notificationList(param);
	}

	@Override
	public Map<String, Object> updateNotification(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("count",commonDao.updateNotification(param));
		return map;
	}

	@Override
	public void insertNotification(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		commonDao.insertNotification(param);
	}

	@Override
	public List<UserVO> getUserInfo(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return commonDao.getUserInfo(param);
	}

	@Override
	public void insertPrintLog(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		commonDao.insertPrintLog(param);
	}

	@Override
	public List<Map<String, Object>> docCount(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return commonDao.docCount(param);
	}

	@Override
	public List<Map<String, Object>> docStateCount(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return commonDao.docStateCount(param);
	}
	
	@Override
	public List<StorageVO> getStorageList(Map<String, Object> param) {
		return commonDao.getStorageList(param);
	}
}
