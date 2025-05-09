package kr.co.aspn.dao.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.aspn.dao.Report2Dao;
import kr.co.aspn.dao.ReportDao;
import kr.co.aspn.vo.ApprovalHeaderVO;
import kr.co.aspn.vo.ApprovalItemVO;
import kr.co.aspn.vo.ApprovalLineHeaderVO;
import kr.co.aspn.vo.ApprovalLineInfoVO;
import kr.co.aspn.vo.ReportVO;

@Repository
public class Report2DaoImpl implements Report2Dao {
	@Autowired
	SqlSessionTemplate sqlSessionTemplate;

	@Override
	public int selectDesignSeq() {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("report2.selectDesignSeq");
	}

	@Override
	public void insertDesign(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("report2.insertDesign", param);
	}

	@Override
	public void insertChangeList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("report2.insertChangeList", param);
	}

	@Override
	public int selectDesignCount(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("report2.selectDesignCount",param);
	}

	@Override
	public List<Map<String, Object>> selectDesignList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("report2.selectDesignList", param);
	}

	@Override
	public Map<String, String> selectDesignData(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("report2.selectDesignData", param);
	}

	@Override
	public List<Map<String, Object>> selectDesignChangeList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("report2.selectDesignChangeList", param);
	}

	@Override
	public List<Map<String, String>> selectHistory(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("report2.selectHistory", param);
	}

	@Override
	public void updateDesign(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("report2.updateDesign", param);
	}

	@Override
	public void deleteChangeList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.delete("report2.deleteChangeList", param);
	}

	@Override
	public int selectBusinessTripCount(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("report2.selectBusinessTripCount",param);
	}

	@Override
	public List<Map<String, Object>> selectBusinessTripList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("report2.selectBusinessTripList", param);
	}

	@Override
	public int selectTripSeq() {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("report2.selectTripSeq");
	}

	@Override
	public void insertBusinessTrip(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("report2.insertBusinessTrip", param);
	}

	@Override
	public Map<String, String> selectBusinessTripData(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("report2.selectBusinessTripData", param);
	}

	@Override
	public void updateBusinessTrip(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("report2.updateBusinessTrip", param);
	}
	
	@Override
	public List<Map<String, Object>> searchBusinessTripPlanList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("report2.searchBusinessTripPlanList", param);
	}
	
	@Override
	public List<Map<String, Object>> searchNewProductResultListAjax(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("report2.searchNewProductResultListAjax", param);
	}

	@Override
	public int selectBusinessTripPlanCount(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("report2.selectBusinessTripPlanCount",param);
	}

	@Override
	public List<Map<String, Object>> selectBusinessTripPlanList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("report2.selectBusinessTripPlanList", param);
	}

	@Override
	public int selectTripPlanSeq() {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("report2.selectTripPlanSeq");
	}

	@Override
	public void insertBusinessTripPlan(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("report2.insertBusinessTripPlan", param);
	}
	
	@Override
	public void insertBusinessTripPlanUser(ArrayList<HashMap<String, Object>> userList) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("report2.insertBusinessTripPlanUser", userList);
	}
	
	@Override
	public void insertBusinessTripPlanAddInfo(ArrayList<HashMap<String, Object>> addInfoList) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("report2.insertBusinessTripPlanAddInfo", addInfoList);
	}
	
	@Override
	public void insertBusinessTripPlanContents(ArrayList<HashMap<String, Object>> contentList) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("report2.insertBusinessTripPlanContents", contentList);
	}

	@Override
	public Map<String, Object> selectBusinessTripPlanData(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("report2.selectBusinessTripPlanData", param);
	}
	
	@Override
	public List<Map<String, Object>> selectBusinessTripPlanUserList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("report2.selectBusinessTripPlanUserList", param);
	}

	@Override
	public List<Map<String, Object>> selectBusinessTripPlanAddInfoList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("report2.selectBusinessTripPlanAddInfoList", param);
	}

	@Override
	public List<Map<String, Object>> selectBusinessTripPlanContentsList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("report2.selectBusinessTripPlanContentsList", param);
	}
	
	@Override
	public void updateBusinessTripPlan(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("report2.updateBusinessTripPlan", param);
	}

	@Override
	public void deleteBusinessTripPlanUser(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.delete("report2.deleteBusinessTripPlanUser", param);
	}

	@Override
	public void deleteBusinessTripPlanAddInfo(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.delete("report2.deleteBusinessTripPlanAddInfo", param);
	}

	@Override
	public void deleteBusinessTripPlanContents(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.delete("report2.deleteBusinessTripPlanContents", param);
	}

	@Override
	public int selectSenseQualitySeq() {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("report2.selectSenseQualitySeq");
	}

	@Override
	public void insertSenseQualityReport(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("report2.insertSenseQualityReport", param);
	}

	@Override
	public void insertSenseQualityContents(ArrayList<HashMap<String, Object>> contentsList) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("report2.insertSenseQualityContents", contentsList);
	}

	@Override
	public void insertSenseQualityAddInfo(ArrayList<HashMap<String, Object>> addInfoList) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("report2.insertSenseQualityAddInfo", addInfoList);
	}

	@Override
	public int selectSenseQualityCount(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("report2.selectSenseQualityCount",param);
	}

	@Override
	public List<Map<String, Object>> selectSenseQualityList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("report2.selectSenseQualityList", param);
	}

	@Override
	public Map<String, Object> selectSenseQualityReport(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("report2.selectSenseQualityReport",param);
	}

	@Override
	public List<Map<String, Object>> selectSenseQualityContensts(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("report2.selectSenseQualityContensts",param);
	}

	@Override
	public List<Map<String, Object>> selectSenseQualityInfo(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("report2.selectSenseQualityInfo",param);

	}

	@Override
	public Map<String, Object> selectSenseQualityContenstsData(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("report2.selectSenseQualityContenstsData",param);
	}

	@Override
	public void deleteSenseQualityContenstsData(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.delete("report2.deleteSenseQualityContenstsData",param);
	}

	@Override
	public void updateSenseQualityReport(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("report2.updateSenseQualityReport", param);
	}

	@Override
	public void deleteSenseQualityAddInfo(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.delete("report2.deleteSenseQualityAddInfo",param);
	}

	@Override
	public void updateSenseQualityContent(HashMap<String, Object> dataMap) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("report2.updateSenseQualityContent", dataMap);
	}

	@Override
	public void insertSenseQualityContent(HashMap<String, Object> dataMap) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("report2.insertSenseQualityContent", dataMap);
	}

	
	//여기서부터 시작--------------------------------------------------------------------------------------
	@Override
	public void insertBusinessTripUser(ArrayList<HashMap<String, Object>> userList) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("report2.insertBusinessTripUser", userList);
	}

	@Override
	public void insertBusinessTripAddInfo(ArrayList<HashMap<String, Object>> addInfoList) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("report2.insertBusinessTripAddInfo", addInfoList);
	}

	@Override
	public void insertBusinessTripContents(ArrayList<HashMap<String, Object>> contentList) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("report2.insertBusinessTripContents", contentList);
	}

	@Override
	public List<Map<String, Object>> selectBusinessTripUserList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("report2.selectBusinessTripUserList", param);
	}

	@Override
	public List<Map<String, Object>> selectBusinessTripAddInfoList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("report2.selectBusinessTripAddInfoList", param);
	}

	@Override
	public List<Map<String, Object>> selectBusinessTripContentsList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("report2.selectBusinessTripContentsList", param);
	}

	@Override
	public void deleteBusinessTripUser(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.delete("report2.deleteBusinessTripUser", param);
	}

	@Override
	public void deleteBusinessTripAddInfo(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.delete("report2.deleteBusinessTripAddInfo", param);
	}

	@Override
	public void deleteBusinessTripContents(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.delete("report2.deleteBusinessTripContents", param);
	}

	
	@Override
	public int selectNewProductResultCount(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("report2.selectNewProductResultCount",param);
	}
	
	@Override
	public int selectChemicalTestCount(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("report2.selectChemicalTestCount",param);
	}
	
	@Override
	public List<Map<String, Object>> selectNewProductResultList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("report2.selectNewProductResultList", param);
	}
	
	@Override
	public List<Map<String, Object>> selectChemicalTestList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("report2.selectChemicalTestList", param);
	}
}