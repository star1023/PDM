package kr.co.aspn.service;

import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import kr.co.aspn.vo.ApprovalItemVO;
import kr.co.aspn.vo.ApprovalLineHeaderVO;
import kr.co.aspn.vo.ApprovalLineInfoVO;
import kr.co.aspn.vo.CodeItemVO;
import kr.co.aspn.vo.ReportVO;

public interface Report2Service {

	int insertDesign(Map<String, Object> param, HashMap<String, Object> listMap, MultipartFile[] file) throws Exception;

	Map<String, Object> selectDesignList(Map<String, Object> param) throws Exception;

	Map<String, Object> selectDesignData(Map<String, Object> param);

	List<Map<String, Object>> selectDesignChangeList(Map<String, Object> param);

	List<Map<String, String>> selectHistory(Map<String, Object> param);

	void updateDesign(Map<String, Object> param, HashMap<String, Object> listMap, MultipartFile[] file) throws Exception;

	Map<String, Object> selectBusinessTripList(Map<String, Object> param) throws Exception;
	
	int insertBusinessTripTmp(Map<String, Object> param, MultipartFile[] file) throws Exception;

	int insertBusinessTrip(Map<String, Object> param, MultipartFile[] file) throws Exception;

	Map<String, Object> selectBusinessTripData(Map<String, Object> param);

	void updateBusinessTrip(Map<String, Object> param, MultipartFile[] file) throws Exception;
	
	List<Map<String, Object>> searchBusinessTripPlanList(Map<String, Object> param);
	
	List<Map<String, Object>> searchNewProductResultListAjax(Map<String, Object> param);

	Map<String, Object> selectBusinessTripPlanList(Map<String, Object> param) throws Exception;
	
	int insertBusinessTripPlanTmp(Map<String, Object> param, MultipartFile[] file) throws Exception;

	int insertBusinessTripPlan(Map<String, Object> param, MultipartFile[] file) throws Exception;

	Map<String, Object> selectBusinessTripPlanData(Map<String, Object> param);
	
	List<Map<String, Object>> selectBusinessTripPlanUserList(Map<String, Object> param);
	
	List<Map<String, Object>> selectBusinessTripPlanAddInfoList(Map<String, Object> param);

	List<Map<String, Object>> selectBusinessTripPlanContentsList(Map<String, Object> param);
	
	void updateBusinessTripPlanTmp(Map<String, Object> param, MultipartFile[] file) throws Exception;
	
	void updateBusinessTripPlan(Map<String, Object> param, MultipartFile[] file) throws Exception;

	int insertSenseQuality(Map<String, Object> param, HashMap<String, Object> listMap, MultipartFile[] file) throws Exception;

	Map<String, Object> selectSenseQualityList(Map<String, Object> param) throws Exception;

	Map<String, Object> selectSenseQualityData(Map<String, Object> param);

	int insertSenseQualityTmp(Map<String, Object> param, HashMap<String, Object> listMap, MultipartFile[] file) throws Exception;

	void deleteSenseQualityContenstsData(Map<String, Object> param) throws Exception;

	void updateSenseQualityTmp(Map<String, Object> param, HashMap<String, Object> dataListMap, HashMap<String, Object> fileMap, 
			HashMap<String, Object> listMap, MultipartFile[] file) throws Exception;

	void updateSenseQuality(Map<String, Object> param, HashMap<String, Object> dataListMap,
			HashMap<String, Object> fileMap, HashMap<String, Object> listMap, MultipartFile[] file) throws Exception;

	
	//추가시작 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	List<Map<String, Object>> selectBusinessTripUserList(Map<String, Object> param);

	List<Map<String, Object>> selectBusinessTripAddInfoList(Map<String, Object> param);

	List<Map<String, Object>> selectBusinessTripContentsList(Map<String, Object> param);

	void updateBusinessTripTmp(Map<String, Object> param, MultipartFile[] file) throws Exception;
	
	int insertMarketResearchTmp(Map<String, Object> param, MultipartFile[] file) throws Exception;
	
	int insertMarketResearch(Map<String, Object> param, MultipartFile[] file) throws Exception;	
	
	Map<String, Object> selectMarketResearchList(Map<String, Object> param) throws Exception;
	
	Map<String, Object> selectMarketResearchData(Map<String, Object> param);

	List<Map<String, Object>> selectMarketResearchUserList(Map<String, Object> param);

	List<Map<String, Object>> selectMarketResearchAddInfoList(Map<String, Object> param);
	
	void updateMarketResearchTmp(Map<String, Object> param, MultipartFile[] file) throws Exception;	
	
	void updateMarketResearch(Map<String, Object> param, MultipartFile[] file) throws Exception;

	//추가완료 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	
	Map<String, Object> selectNewProductResultList(Map<String, Object> param) throws Exception;
	
	Map<String, Object> selectChemicalTestList(Map<String, Object> param) throws Exception;
	
}
