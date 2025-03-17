package kr.co.aspn.dao.impl;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.aspn.dao.DevdocManagementDao;

@Repository
public class DevdocManagementDaoImpl implements DevdocManagementDao {
	@Autowired
	SqlSessionTemplate sqlSessionTemplate;
	
	@Override
	public List<Map<String, String>> devDocList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("devDocManagement.devDocList",param);
	}

	@Override
	public void userChange(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("devDocManagement.userChange",param);
	}

	@Override
	public void insertChangeLog(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("devDocManagement.insertChangeLog",param);
	}

	@Override
	public List<Map<String, Object>> manufacturingProcessDocList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("devDocManagement.manufacturingProcessDocList", param);
	}

	@Override
	public void launchDateUpdate(Map<String, Object> param) {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("devDocManagement.launchDateUpdate", param);
	}

	@Override
	public List<Map<String, String>> menuDocList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("devDocManagement.menuDocList",param);
	}
	
	@Override
	public void userChangeMenuDoc(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("devDocManagement.userChangeMenuDoc",param);
	}

}
