package kr.co.aspn.dao.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.aspn.dao.ManufacturingNoDao;

@Repository
public class ManufacturingNoDaoImpl implements ManufacturingNoDao {
	private Logger logger = LoggerFactory.getLogger(ManufacturingNoDaoImpl.class);
	@Autowired
	SqlSessionTemplate sqlSessionTemplate;
	
	@Override
	public int selectManufacturingNoMappingCount(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("manufacturingNo.selectManufacturingNoMappingCount", param);
	}
	
	@Override
	public int checkName(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("manufacturingNo.checkName", param);
	}
	
	@Override
	public List<Map<String, Object>> licensingNoList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("manufacturingNo.licensingNoList", param);
	}
	
	@Override
	public int getManufacturingMaxNo(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("manufacturingNo.selectManufacturingMaxNo", param);
	}
	
	@Override
	public int insert(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.insert("manufacturingNo.insert", param);
	}
	
	@Override
	public int insertData(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.insert("manufacturingNo.insertData", param);
	}
	
	@Override
	public int insertMapping(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.insert("manufacturingNo.insertMapping", param);
	}

	@Override
	public List<Map<String, Object>> searchManufacturingNoList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("manufacturingNo.searchManufacturingNoList", param);
	}

	
	@Override
	public List<Map<String, Object>> selectManufacturingNoList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("manufacturingNo.selectManufacturingNoList", param);
	}

	@Override
	public int manufacturingNoTotalCount(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("manufacturingNo.manufacturingNoCount", param);
	}

	@Override
	public List<Map<String, Object>> manufacturingNoList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("manufacturingNo.manufacturingNoList", param);
	}

	@Override
	public Map<String, Object> selectDevDocInfo(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("manufacturingNo.selectDevDocInfo", param);
	}

	@Override
	public Map<String, Object> manufacturingNo(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("manufacturingNo.manufacturingNo", param);
	}

	@Override
	public List<Map<String, Object>> manufacturingDocData(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("manufacturingNo.manufacturingDocData", param);
	}

	@Override
	public List<Map<String, Object>> manufacturingNoDataList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("manufacturingNo.manufacturingNoDataList", param);
	}

	@Override
	public Map<String, Object> selectManufacturingNoData(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("manufacturingNo.selectManufacturingNoData", param);
	}

	@Override
	public int updateManufacturingNoStatus(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.update("manufacturingNo.updateManufacturingNoStatus", param);
	}

	@Override
	public int updateManufacturingNoStatusByAppr(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.update("manufacturingNo.updateManufacturingNoStatusByAppr", param);
	}

	@Override
	public List<Map<String, Object>> selectManufacturingNoFile(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("manufacturingNo.selectManufacturingNoFile", param);
	}

	@Override
	public Map<String, Object> selectManufacturingNoData2(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("manufacturingNo.selectManufacturingNoData2", param);
	}

	@Override
	public List<Map<String, Object>> selectCreatePlant(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("manufacturingNo.selectCreatePlant", param);
	}

	@Override
	public List<Map<String, Object>> selectPackageUnit(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("manufacturingNo.selectPackageUnit", param);
	}

	@Override
	public void insertPackageUnit(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("manufacturingNo.insertPackageUnit", param);
	}

	@Override
	public String selectLaunchDate(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("manufacturingNo.selectLaunchDate", param);
	}

	@Override
	public List<Map<String, Object>> manufacturingDocList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("manufacturingNo.manufacturingDocList", param);
	}

	@Override
	public List<Map<String, Object>> selectManufacturingStatusCount() throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("manufacturingNo.selectManufacturingStatusCount");
	}

	@Override
	public List<Map<String, Object>> selectManufacturingNoStatusList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("manufacturingNo.selectManufacturingNoStatusList", param);
	}

	@Override
	public int updateReportDate(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.insert("manufacturingNo.updateReportDate", param);
	}

	@Override
	public int manufacturingNoStatusTotalCount(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("manufacturingNo.manufacturingNoStatusTotalCount", param);
	}

	@Override
	public int selectMappingCountBySeq(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("manufacturingNo.selectMappingCountBySeq", param);
	}

	@Override
	public Map<String, Object> selectManufacturingNoDataByDocNo(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("manufacturingNo.selectManufacturingNoDataByDocNo", param);
	}

	@Override
	public int updateManufacturingNoData(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.update("manufacturingNo.updateManufacturingNoData", param);
	}

	@Override
	public int updateManufacturingNo(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.update("manufacturingNo.updateManufacturingNo", param);
	}

	@Override
	public int deleteManufacturingNoPackageUnit(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.delete("manufacturingNo.deleteManufacturingNoPackageUnit", param);
	}

	@Override
	public int updateManufacturingNoPackageUnit(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.insert("manufacturingNo.updateManufacturingNoPackageUnit", param);
	}

	@Override
	public List<Map<String, Object>> selectDevDocRegUserId(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("manufacturingNo.selectDevDocRegUserId", param);
	}

	@Override
	public String checkIsAdmin(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("manufacturingNo.checkIsAdmin", param);
	}

	@Override
	public List<Map<String, Object>> manufacturingNoVersionList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("manufacturingNo.selectManufacturingNoVersionList", param);
	}

	@Override
	public int insertVersionUpData(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.insert("manufacturingNo.insertVersionUpData", param);
	}

	@Override
	public int insertVersionUpMapping(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.insert("manufacturingNo.insertVersionUpMapping", param);
	}

	@Override
	public Map<String, Object> selectVersionUpReason(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("manufacturingNo.selectVersionUpReason", param);
	}

	@Override
	public int insertVersionUpHistory(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.insert("manufacturingNo.insertVersionUpHistory", param);
	}

	@Override
	public List<Map<String, Object>> getManufacturingNoMappingBymNoseq(Map<String, Object> param) {
		return sqlSessionTemplate.selectList("manufacturingNo.getManufacturingNoMappingBymNoseq", param);
	}

	@Override
	public List<Map<String, Object>> getDocStateListBySeq(Map<String, Object> param) {
		return sqlSessionTemplate.selectList("manufacturingNo.getDocStateListBySeq", param);
	}

	@Override
	public List<Map<String, Object>> selectManufacturingNoStatusListData(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("manufacturingNo.selectManufacturingNoStatusListData", param);
	}

	@Override
	public List<String> selectManufacturingMaxVersionNoView() throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("manufacturingNo.selectManufacturingMaxVersionNoView");
	}

	@Override
	public List<HashMap<String,Object>> selectMgdListData(Map<String, Object> param){
		return sqlSessionTemplate.selectList("manufacturingNo.selectMgdListData",param);
	}

	@Override
	public List<String> getAuthTeamCode(String userId){
		return sqlSessionTemplate.selectList("manufacturingNo.getAuthTeamCode",userId);
	}

	@Override
	public List<Map<String, Object>> getAuthDevDoc(int seq){
		return sqlSessionTemplate.selectList("manufacturingNo.getAuthDevDoc",seq);
	}
}
