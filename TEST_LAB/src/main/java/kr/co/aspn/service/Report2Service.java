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

	int insertBusinessTrip(Map<String, Object> param, MultipartFile[] file) throws Exception;

	Map<String, Object> selectBusinessTripData(Map<String, Object> param);

	void updateBusinessTrip(Map<String, Object> param, MultipartFile[] file) throws Exception;
	
	List<Map<String, Object>> searchBusinessTripPlanList(Map<String, Object> param);

	Map<String, Object> selectBusinessTripPlanList(Map<String, Object> param) throws Exception;

	int insertBusinessTripPlan(Map<String, Object> param, MultipartFile[] file) throws Exception;

	Map<String, Object> selectBusinessTripPlanData(Map<String, Object> param);

	int insertSenseQuality(Map<String, Object> param, HashMap<String, Object> listMap, MultipartFile[] file) throws Exception;

	Map<String, Object> selectSenseQualityList(Map<String, Object> param) throws Exception;

	Map<String, Object> selectSenseQualityData(Map<String, Object> param); 
	
}
