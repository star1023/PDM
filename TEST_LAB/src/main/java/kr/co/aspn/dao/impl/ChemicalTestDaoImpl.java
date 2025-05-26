package kr.co.aspn.dao.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.aspn.dao.ChemicalTestDao;

@Repository
public class ChemicalTestDaoImpl implements ChemicalTestDao {
	@Autowired
	SqlSessionTemplate sqlSessionTemplate;

	@Override
	public List<Map<String, String>> selectHistory(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("chemicalTest.selectHistory", param);
	}

	@Override
	public int selectChemicalTestCount(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("chemicalTest.selectChemicalTestCount",param);
	}
	
	@Override
	public List<Map<String, Object>> selectChemicalTestList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("chemicalTest.selectChemicalTestList", param);
	}
	
	@Override
	public int selectChemicalTestSeq() {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("chemicalTest.selectChemicalTestSeq");
	}
	
	@Override
	public int selectChemicalTestItemSeq() {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("chemicalTest.selectChemicalTestItemSeq");
	}
	
	@Override
	public void insertChemicalTest(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("chemicalTest.insertChemicalTest", param);
	}
	
	@Override
	public void insertChemicalTestItem(ArrayList<HashMap<String,Object>> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("chemicalTest.insertChemicalTestItem", param);
	}
	
	@Override
	public void insertChemicalTestStandard(ArrayList<HashMap<String,Object>> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("chemicalTest.insertChemicalTestStandard", param);
	}
	
	@Override
	public Map<String, String> selectChemicalTestData(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("chemicalTest.selectChemicalTestData", param);
	}
	
	@Override
	public List<Map<String, Object>> selectChemicalTestItemData(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("chemicalTest.selectChemicalTestItemData", param);
	}
	
	@Override
	public List<Map<String, Object>> selectChemicalTestStandardList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("chemicalTest.selectChemicalTestStandardList", param);
	}

	@Override
	public List<Map<String, Object>> searchChemicalTestList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("chemicalTest.searchChemicalTestList", param);
	}
	
	@Override
	public void updateChemicalTest(Map<String, Object> param) {
		// TODO Auto-generated method stub
		sqlSessionTemplate.selectList("chemicalTest.updateChemicalTest", param);
	}
	
	@Override
	public void deleteChemicalTestItems(Map<String, Object> param) {
		// TODO Auto-generated method stub
		sqlSessionTemplate.selectList("chemicalTest.deleteChemicalTestItems", param);
	}
	
	@Override
	public void deleteChemicalTestStandards(Map<String, Object> param) {
		// TODO Auto-generated method stub
		sqlSessionTemplate.selectList("chemicalTest.deleteChemicalTestStandards", param);
	}
	
	public void insertNewProductResultItems(List<Map<String, Object>> itemList) throws Exception{
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("chemicalTest.insertNewProductResultItem", itemList);
	}
	
	public void insertNewProductResultItemImage(List<Map<String, Object>> itemList) throws Exception{
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("chemicalTest.insertNewProductResultItemImage", itemList);
	}
	
}