package kr.co.aspn.dao;

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

	Map<String, String> selectBusinessTripData(Map<String, Object> param);

	void updateBusinessTrip(Map<String, Object> param) throws Exception;
	
	List<Map<String, Object>> searchBusinessTripPlanList(Map<String, Object> param);

	int selectBusinessTripPlanCount(Map<String, Object> param);

	List<Map<String, Object>> selectBusinessTripPlanList(Map<String, Object> param);

	int selectTripPlanSeq();

	void insertBusinessTripPlan(Map<String, Object> param) throws Exception;

	Map<String, Object> selectBusinessTripPlanData(Map<String, Object> param);

	
}
