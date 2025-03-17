package kr.co.aspn.dao;

import java.util.HashMap;

public interface ExcelTestDao {
	public void insertIntoNo(HashMap<String, Object> inputs);
	public void insertIntoNoData(HashMap<String, Object> inputs);
	public void insertIntoNoMapping(HashMap<String, Object> inputs);
	public void insertIntoNoPackageUnit(HashMap<String, Object> inputs);
	public Integer getSeq();
	public Integer getNoDataSeq();
	public Integer selectVersionNo(int seq);
	public Integer selectSeq(Integer tempKey);
	public void updateNoMapping(HashMap<String, Integer> map);
	public Integer selectSeqFromNoData(Integer dataTempKey);
	public void updateNoPackage(HashMap<String, Object> map);
	public Integer selectSeqFromNo(Integer tempKey);
	public void updateNoData(HashMap<String, Object> map);
}
