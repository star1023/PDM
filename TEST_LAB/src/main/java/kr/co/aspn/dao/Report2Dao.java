package kr.co.aspn.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.co.aspn.vo.ApprovalHeaderVO;
import kr.co.aspn.vo.ApprovalItemVO;
import kr.co.aspn.vo.ApprovalLineHeaderVO;
import kr.co.aspn.vo.ApprovalLineInfoVO;
import kr.co.aspn.vo.ReportVO;

public interface Report2Dao {

	int selectDesignSeq();

	void insertDesign(Map<String, Object> param) throws Exception;

	void insertChangeList(Map<String, Object> param) throws Exception;

	int selectDesignCount(Map<String, Object> param);

	List<Map<String, Object>> selectDesignList(Map<String, Object> param);

	Map<String, String> selectDesignData(Map<String, Object> param);

	List<Map<String, Object>> selectDesignChangeList(Map<String, Object> param);

	List<Map<String, String>> selectHistory(Map<String, Object> param);

	void updateDesign(Map<String, Object> param) throws Exception;

	void deleteChangeList(Map<String, Object> param) throws Exception;

	int selectBusinessTripCount(Map<String, Object> param);

	List<Map<String, Object>> selectBusinessTripList(Map<String, Object> param);

	int selectTripSeq();

	void insertBusinessTrip(Map<String, Object> param) throws Exception;
	
	void insertBusinessTripUser(ArrayList<HashMap<String, Object>> userList) throws Exception;

	Map<String, String> selectBusinessTripData(Map<String, Object> param);

	void updateBusinessTrip(Map<String, Object> param) throws Exception;
	
	List<Map<String, Object>> searchBusinessTripPlanList(Map<String, Object> param);
	
	List<Map<String, Object>> searchNewProductResultListAjax(Map<String, Object> param);

	int selectBusinessTripPlanCount(Map<String, Object> param);

	List<Map<String, Object>> selectBusinessTripPlanList(Map<String, Object> param);

	int selectTripPlanSeq();
	
	void insertBusinessTripPlan(Map<String, Object> param) throws Exception;
	
	void insertBusinessTripPlanUser(ArrayList<HashMap<String, Object>> userList) throws Exception;
	
	void insertBusinessTripPlanAddInfo(ArrayList<HashMap<String, Object>> addInfoList) throws Exception;
	
	void insertBusinessTripPlanContents(ArrayList<HashMap<String, Object>> contentList) throws Exception;

	Map<String, Object> selectBusinessTripPlanData(Map<String, Object> param);
	
	List<Map<String, Object>> selectBusinessTripPlanUserList(Map<String, Object> param);

	List<Map<String, Object>> selectBusinessTripPlanAddInfoList(Map<String, Object> param);

	List<Map<String, Object>> selectBusinessTripPlanContentsList(Map<String, Object> param);
	
	void updateBusinessTripPlan(Map<String, Object> param) throws Exception;	
	
	void deleteBusinessTripPlanUser(Map<String, Object> param) throws Exception;
	
	void deleteBusinessTripPlanAddInfo(Map<String, Object> param) throws Exception;
	
	void deleteBusinessTripPlanContents(Map<String, Object> param) throws Exception;

	int selectSenseQualitySeq();

	void insertSenseQualityReport(Map<String, Object> param) throws Exception;

	void insertSenseQualityContents(ArrayList<HashMap<String, Object>> contentsList) throws Exception;

	void insertSenseQualityAddInfo(ArrayList<HashMap<String, Object>> addInfoList) throws Exception;

	int selectSenseQualityCount(Map<String, Object> param);

	List<Map<String, Object>> selectSenseQualityList(Map<String, Object> param);

	Map<String, Object> selectSenseQualityReport(Map<String, Object> param);

	List<Map<String, Object>> selectSenseQualityContensts(Map<String, Object> param);

	List<Map<String, Object>> selectSenseQualityInfo(Map<String, Object> param);

	Map<String, Object> selectSenseQualityContenstsData(Map<String, Object> param);

	void deleteSenseQualityContenstsData(Map<String, Object> param) throws Exception;

	void updateSenseQualityReport(Map<String, Object> param) throws Exception;

	void deleteSenseQualityAddInfo(Map<String, Object> param) throws Exception;

	void updateSenseQualityContent(HashMap<String, Object> dataMap) throws Exception;

	void insertSenseQualityContent(HashMap<String, Object> dataMap) throws Exception;

	//여기부터 시작~~~~~~~~~~~~~~~~
	void insertBusinessTripAddInfo(ArrayList<HashMap<String, Object>> addInfoList) throws Exception;

	void insertBusinessTripContents(ArrayList<HashMap<String, Object>> contentList) throws Exception;

	List<Map<String, Object>> selectBusinessTripUserList(Map<String, Object> param);

	List<Map<String, Object>> selectBusinessTripAddInfoList(Map<String, Object> param);

	List<Map<String, Object>> selectBusinessTripContentsList(Map<String, Object> param);

	void deleteBusinessTripUser(Map<String, Object> param) throws Exception;

	void deleteBusinessTripAddInfo(Map<String, Object> param) throws Exception;

	void deleteBusinessTripContents(Map<String, Object> param) throws Exception;

	int selectNewProductResultCount(Map<String, Object> param);
	
	int selectChemicalTestCount(Map<String, Object> param);
	
	List<Map<String, Object>> selectNewProductResultList(Map<String, Object> param);
	
	List<Map<String, Object>> selectChemicalTestList(Map<String, Object> param);

	int selectMarketResearchSeq();

	void insertMarketResearch(Map<String, Object> param) throws Exception;

	void insertMarketResearchAddInfo(ArrayList<HashMap<String, Object>> addInfoList) throws Exception;

	void insertMarketResearchUser(ArrayList<HashMap<String, Object>> userList) throws Exception;

	int selectMarketResearchCount(Map<String, Object> param);

	List<Map<String, Object>> selectMarketResearchList(Map<String, Object> param);

	Map<String, String> selectMarketResearchData(Map<String, Object> param);

	List<Map<String, Object>> selectMarketResearchUserList(Map<String, Object> param);

	List<Map<String, Object>> selectMarketResearchAddInfoList(Map<String, Object> param);

	void updateMarketResearch(Map<String, Object> param) throws Exception;

	void deleteMarketResearchAddInfo(Map<String, Object> param) throws Exception;

	void deleteMarketResearchUser(Map<String, Object> param) throws Exception;

	
}
