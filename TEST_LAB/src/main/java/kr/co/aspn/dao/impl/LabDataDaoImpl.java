package kr.co.aspn.dao.impl;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.aspn.dao.LabDataDao;

@Repository("dataRepo")
public class LabDataDaoImpl implements LabDataDao {
	@Autowired
	@Resource(name="sqlSessionTemplate")
	private SqlSessionTemplate sqlSessionTemplate;
	
	@Override
	public List<Map<String, Object>> getCodeList(String groupCode){
		return sqlSessionTemplate.selectList("data.getCodeList", groupCode);
	}
	
	@Override
	public List<Map<String, Object>> getCompanyList() {
		return sqlSessionTemplate.selectList("data.getCompanyList");
	}
	
	@Override
	public List<Map<String, Object>> getPlantList() {
		return sqlSessionTemplate.selectList("data.getPlantList");
	}

	@Override
	public List<Map<String, Object>> getPlantLineList() {
		return sqlSessionTemplate.selectList("data.getPlantLineList");
	}

	@Override
	public int getMaterialListPopupTotal(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectOne("data.getMaterialListPopupTotal", param);
	}

	@Override
	public List<Map<String, Object>> getMaterialListPopup(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectList("data.getMaterialListPopup", param);
	}

	
	@Override
	public int insertMax(String tbType) {
		
		List<Map<Object,Object>> maxList = sqlSessionTemplate.selectList("data.insertMax",tbType);
		
		int max = 0;
		
		if(maxList.size() > 0) {
			if(maxList.get(0).get("max") != null) {
				max = ((BigDecimal)maxList.get(0).get("max")).intValue();
			}
		}
		
		return max;
	}
	
	@Override
	public List<Map<String, Object>> userList() {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("data.userList");
	}

	@Override
	public List<Map<String, Object>> getStorageList(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectList("data.getStorageList", param);
	}
	
	@Override
	public List<Map<String,Object>> userInfo(String userId){
		return sqlSessionTemplate.selectList("data.userInfo", userId);
	}

	@Override
	public List<Map<String, Object>> getUserInfo(String userId) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("data.getUserInfo", userId);
	}
	
	@Override
	public Map<String, Object> countForState(String regUserId) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("data.countForState", regUserId);
	}
	
	@Override
	public List<Map<String, Object>> getMaterialList(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectList("data.getMaterialList", param);
	}
	
	@Override
	public Map<String, Object> getMaterialInfo(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectOne("data.getMaterialInfo", param);
	}
	
	@Override
	public void updateTxTest1(String value) {
		sqlSessionTemplate.update("data.updateTxTest1", value);
	}
	
	@Override
	public void updateTxTest2(String value) {
		sqlSessionTemplate.update("data.updateTxTest2", value);
	}
	
	@Override
	public void updateTxTest3(String value) {
		sqlSessionTemplate.update("data.updateTxTest3", value);
	}
	
	@Override
	public List<Map<String, Object>> checkMaterial(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectList("data.checkMaterial", param);
	}
}
