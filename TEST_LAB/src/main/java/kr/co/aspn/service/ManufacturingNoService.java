package kr.co.aspn.service;

import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

public interface ManufacturingNoService {
	int selectManufacturingNoMappingCount(Map<String, Object> param) throws Exception;
	
	List<Map<String, Object>> licensingNoList(Map<String, Object> param) throws Exception;
	
	int checkName(Map<String, Object> param) throws Exception;
	
	@Transactional(propagation=Propagation.REQUIRED, rollbackFor={Throwable.class})	
	int insert(Map<String, Object> param) throws Exception;

	
	List<Map<String, Object>> searchManufacturingNoList(Map<String, Object> param) throws Exception;

	int addManufacturingMapping(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> selectManufacturingNoList(Map<String, Object> param) throws Exception;

	Map<String, Object> manufacturingNoList(Map<String, Object> param) throws Exception;

	Map<String, Object> selectDevDocInfo(Map<String, Object> param) throws Exception;

	Map<String, Object> manufacturingNoData(Map<String, Object> param) throws Exception;

	Map<String, Object> selectManufacturingNoData(Map<String, Object> param) throws Exception;

	int updateManufacturingNoStatus(Map<String, Object> param) throws Exception;

	int updateManufacturingNoStatusByAppr(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> selectManufacturingNoFile(Map<String, Object> param) throws Exception;

	Map<String, Object> selectManufacturingNoData2(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> selectManufacturingStatusCount() throws Exception;

	Map<String,Object> selectManufacturingNoStatusList(Map<String, Object> param) throws Exception;

	List<Map<String,Object>> selectManufacturingNoStatusListData(Map<String, Object> param) throws Exception;

    int updateReportDate(Map<String, Object> param) throws Exception;

	int selectMappingCountBySeq(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> manufacturingDocData(Map<String, Object> param) throws Exception;

	Map<String, Object> selectManufacturingNoDataByDocNo(Map<String, Object> param);
	
	int updateManufacturingNoData(Map<String, Object> param) throws Exception;
	
	int updateManufacturingNo(Map<String, Object> param) throws Exception;
	
	int deleteManufacturingNoPackageUnit(Map<String, Object> param) throws Exception;
	
	int updateManufacturingNoPackageUnit(Map<String, Object> param) throws Exception;
	
	List<Map<String, Object>> manufacturingNoVersionList(Map<String, Object> param) throws Exception;
	
	Map<String, Object> requestManufacturingNoVersionUp(Map<String, Object> param) throws Exception;

	Map<String, Object> selectVersionUpReason(Map<String, Object> param) throws Exception;

    List<Map<String, Object>> getManufacturingNoMappingBymNoseq(Map<String, Object> param);

    List<Map<String, Object>> getDocStateListBySeq(Map<String, Object> param);

	String getAuthTeamCode(String loginUserId) throws Exception;

	List<HashMap<String, Object>> manufacturingDocList(Map<String, Object> param) throws Exception;

    List<Map<String, Object>> getAuthDevDoc(int seq);

    List<Map<String, Object>> selectPackageUnit(Map<String, Object> param) throws Exception;
}
