package kr.co.aspn.dao.impl;

import java.util.HashMap;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.aspn.dao.ExcelTestDao;

@Repository("excelTestDaoImpl")
public class ExcelTestDaoImpl implements ExcelTestDao{
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	@Override
	public void insertIntoNo(HashMap<String, Object> inputs) {
		sqlSessionTemplate.insert("excelTest.no", inputs);
	}

	@Override
	public void insertIntoNoData(HashMap<String, Object> inputs) {
		sqlSessionTemplate.insert("excelTest.noData", inputs);
		
	}

	@Override
	public void insertIntoNoMapping(HashMap<String, Object> inputs) {
		sqlSessionTemplate.insert("excelTest.noMapping", inputs);		
	}

	@Override
	public void insertIntoNoPackageUnit(HashMap<String, Object> inputs) {
		sqlSessionTemplate.insert("excelTest.noPackageUnit", inputs);		
	}

	@Override
	public Integer getSeq() {
		Integer seq = sqlSessionTemplate.selectOne("excelTest.getSeq");
		return seq;
	}

	@Override
	public Integer getNoDataSeq() {
		Integer noDataSeq = sqlSessionTemplate.selectOne("excelTest.getNoDataSeq");
		return noDataSeq;
	}

	@Override
	public Integer selectVersionNo(int seq) {
		Integer versionNo = sqlSessionTemplate.selectOne("excelTest.selectVersionNo", seq);
		return versionNo;
	}

	@Override
	public Integer selectSeq(Integer tempKey) {
		Integer seq = sqlSessionTemplate.selectOne("excelTest.selectSeq", tempKey);
		return seq;
	}

	@Override
	public void updateNoMapping(HashMap<String, Integer> map) {
		sqlSessionTemplate.update("excelTest.updateNoMapping", map);
	}

	@Override
	public Integer selectSeqFromNoData(Integer dataTempKey) {
		Integer seq = sqlSessionTemplate.selectOne("excelTest.selectSeqFromNoData", dataTempKey);
		return seq;
	}

	@Override
	public void updateNoPackage(HashMap<String, Object> map) {
		sqlSessionTemplate.update("excelTest.updateNoPackage");
	}

	@Override
	public Integer selectSeqFromNo(Integer tempKey) {
		Integer seq = sqlSessionTemplate.selectOne("excelTest.selectSeqFromNo", tempKey);
		return seq;
	}

	@Override
	public void updateNoData(HashMap<String, Object> map) {
		sqlSessionTemplate.update("excelTest.updateNoData");
	}

}
