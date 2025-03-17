package kr.co.aspn.dao.impl;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.aspn.dao.ItemManufacturingDao;

@Repository
public class ItemManufacturingDaoImpl implements ItemManufacturingDao{

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	@Override
	public List<Map<String, Object>> newItemManufacturingProcessDocList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("itemManuFac.newItemManufacturingProcessDocList", param);
	}

}
