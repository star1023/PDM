package kr.co.aspn.dao.impl;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.aspn.dao.CommonDao;
import kr.co.aspn.vo.CodeItemVO;
import kr.co.aspn.vo.CompanyVO;
import kr.co.aspn.vo.FileVO;
import kr.co.aspn.vo.PlantLineVO;
import kr.co.aspn.vo.PlantVO;
import kr.co.aspn.vo.StorageVO;
import kr.co.aspn.vo.UnitVO;
import kr.co.aspn.vo.UserVO;

@Repository
public class CommonDaoImpl implements CommonDao {
	@Autowired
	SqlSessionTemplate sqlSessionTemplate;
	
	@Override
	public List<PlantLineVO> getPlantLine(Map<String, Object> param) {
		return sqlSessionTemplate.selectList("common.plantLine",param);
	}
	
	@Override
	public List<PlantVO> getPlant(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("common.plant",param);
	}

	@Override
	public List<CompanyVO> getCompany() {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("common.company");
	}

	@Override
	public List<UnitVO> getUnit() {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("common.unit");
	}

	@Override
	public List<CodeItemVO> getCodeList(CodeItemVO code) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("common.codeList",code);
	}

	@Override
	public List<Map<String, String>> searchUserId(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("common.searchUserId",param);
	}

	@Override
	public List<Map<String, String>> getCodeListAjax(CodeItemVO code) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("common.codeListAjax",code);
	}

	@Override
	public int searchUserCount(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("common.searchUserCount",param);
	}

	@Override
	public List<UserVO> searchUserList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("common.searchUserList",param);
	}

	@Override
	public List<Map<String, Object>> searchUserList2(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("common.searchUserList2",param);
	}
	
	@Override
	public int notificationCount(Map<String, String> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("common.notificationCount", param);
	}

	@Override
	public List<Map<String, Object>> notificationList(Map<String, String> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("common.notificationList", param);
	}

	@Override
	public int updateNotification(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.update("common.updateNotification", param);
	}

	@Override
	public void insertNotification(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("common.insertNotification", param);
	}

	@Override
	public List<UserVO> getUserInfo(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("common.userInfo",param);
	}

	@Override
	public void insertPrintLog(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("common.insertPrintLog", param);
	}

	@Override
	public List<Map<String, Object>> docCount(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("common.docCount",param);
	}

	@Override
	public List<Map<String, Object>> docStateCount(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("common.docStateCount",param);
	}
	
	@Override
	public List<StorageVO> getStorageList(Map<String, Object> param) {
		return sqlSessionTemplate.selectList("common.getStorageList",param);
	}
}
