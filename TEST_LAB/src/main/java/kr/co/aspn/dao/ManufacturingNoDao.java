package kr.co.aspn.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface ManufacturingNoDao {
	int selectManufacturingNoMappingCount(Map<String, Object> param) throws Exception;
	
	int checkName(Map<String, Object> param) throws Exception;
	
	int getManufacturingMaxNo(Map<String, Object> param) throws Exception;
	
	List<Map<String, Object>> licensingNoList(Map<String, Object> param) throws Exception;
	
	int insert(Map<String, Object> param) throws Exception;
	
	int insertData(Map<String, Object> param) throws Exception;
	
	int insertMapping(Map<String, Object> param) throws Exception;
	

	List<Map<String, Object>> searchManufacturingNoList(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> selectManufacturingNoList(Map<String, Object> param) throws Exception;

	int manufacturingNoTotalCount(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> manufacturingNoList(Map<String, Object> param) throws Exception;

	Map<String, Object> selectDevDocInfo(Map<String, Object> param) throws Exception;

	Map<String, Object> manufacturingNo(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> manufacturingDocData(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> manufacturingNoDataList(Map<String, Object> param) throws Exception;

	Map<String, Object> selectManufacturingNoData(Map<String, Object> param) throws Exception;

	int updateManufacturingNoStatus(Map<String, Object> param) throws Exception;

    int updateManufacturingNoStatusByAppr(Map<String, Object> param) throws Exception;

    List<Map<String, Object>> selectManufacturingNoFile(Map<String, Object> param) throws Exception;

	Map<String, Object> selectManufacturingNoData2(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> selectCreatePlant(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> selectPackageUnit(Map<String, Object> param) throws Exception;

	void insertPackageUnit(Map<String, Object> param) throws Exception;

	String selectLaunchDate(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> manufacturingDocList(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> selectManufacturingStatusCount() throws Exception;

	List<Map<String, Object>> selectManufacturingNoStatusList(Map<String, Object> param) throws Exception;

	int updateReportDate(Map<String, Object> param)  throws Exception;

	int manufacturingNoStatusTotalCount(Map<String, Object> param) throws Exception;

	int selectMappingCountBySeq(Map<String, Object> param) throws Exception;

	Map<String, Object> selectManufacturingNoDataByDocNo(Map<String, Object> param);
	
	int updateManufacturingNoData(Map<String, Object> param) throws Exception;
	
	int updateManufacturingNo(Map<String, Object> param) throws Exception;
	
	int deleteManufacturingNoPackageUnit(Map<String, Object> param) throws Exception;
	
	int updateManufacturingNoPackageUnit(Map<String, Object> param) throws Exception;
	
	List<Map<String, Object>> selectDevDocRegUserId(Map<String, Object> param) throws Exception;
	
	String checkIsAdmin(Map<String, Object> param) throws Exception;
	
	List<Map<String, Object>> manufacturingNoVersionList(Map<String, Object> param) throws Exception;
	
	int insertVersionUpData(Map<String, Object> param) throws Exception;
	
	int insertVersionUpMapping(Map<String, Object> param) throws Exception;
	
	Map<String, Object> selectVersionUpReason(Map<String, Object> param) throws Exception;
	
	int insertVersionUpHistory(Map<String, Object> param) throws Exception;

    List<Map<String, Object>> getManufacturingNoMappingBymNoseq(Map<String, Object> param);

    List<Map<String, Object>> getDocStateListBySeq(Map<String, Object> param);

	List<Map<String, Object>> selectManufacturingNoStatusListData(Map<String, Object> param) throws Exception;

    List<String> selectManufacturingMaxVersionNoView() throws Exception;

    List<HashMap<String,Object>> selectMgdListData(Map<String, Object> param);

    List<String> getAuthTeamCode(String userId);

    List<Map<String, Object>> getAuthDevDoc(int seq);
}
