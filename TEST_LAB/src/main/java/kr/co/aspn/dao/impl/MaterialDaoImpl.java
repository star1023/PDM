package kr.co.aspn.dao.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.sap.conn.jco.JCoDestination;
import com.sap.conn.jco.JCoFunction;

import kr.co.aspn.common.jco.LabDestDataProvider;
import kr.co.aspn.common.jco.LabRfcManager;
import kr.co.aspn.vo.MaterialManagementItemVO;
import kr.co.aspn.vo.MaterialManagementVO;
import kr.co.aspn.vo.MaterialVO;

@Repository
public class MaterialDaoImpl implements kr.co.aspn.dao.MaterialDao {

	@Autowired
	SqlSessionTemplate sqlSessionTemplate;
	
	@Override
	public int materialTotalCount(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("material.materialTotalCount", param);
	}

	@Override
	public List<MaterialVO> materialList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("material.materialList", param);
	}

	@Override
	public int materialCountAjax(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("material.materialCount", param);
	}

	@Override
	public int insert(MaterialVO materialVO) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.insert("material.insert", materialVO);
	}

	@Override
	public int countByKey(String imNo) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("material.countByKey", imNo);
	}

	@Override
	public int usedCount(String imNo) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("material.usedCount", imNo);
	}
	
	@Override
	public void deleteAjax(String imNo) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.delete("material.deleteAjax", imNo);
	}

	@Override
	public void hiddenAjax(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("material.hiddenAjax", param);
	}

	@Override
	public List<Map<String, String>> callRfc(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		List<Map<String, String>> returnList = null;
		try {
			LabDestDataProvider provider = new LabDestDataProvider();
			//provider.setLabDestination(((String)param.get("company")).toLowerCase());
			JCoDestination dest = provider.getMyDestination(((String)param.get("company")).toLowerCase());
			LabRfcManager rfcManager = new LabRfcManager();
			System.err.println("dest  :  "+dest);
			System.err.println("rfcManager  :  "+rfcManager);
			JCoFunction function = rfcManager.getFunction(dest.getDestinationName(), "ZMM_MAT_RFC2");
			
			HashMap<String, String> importParams = new HashMap<String, String>();
			importParams.put("I_MATNR", (String)param.get("sapCode"));
			
			HashMap<String, Object> rfcResult = rfcManager.execute(function,importParams);
			Map<String, List<Map<String, String>>> tableData = (Map<String, List<Map<String, String>>>)rfcResult.get("exportTableData");
			returnList = tableData.get("IT_MAT");
		} catch( Exception e ) {
			e.printStackTrace();
		}
		return returnList;
	}

	@Override
	public void insertErpData(Map<String, String> map) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("material.insertErpData", map);
	}

	@Override
	public MaterialVO materialData(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("material.materialData", param);
	}

	@Override
	public int update(MaterialVO materialVO) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.update("material.update", materialVO);
	}

	@Override
	public int itemTotalCount(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("material.itemTotalCount", param);
	}

	@Override
	public List<Map<String, Object>> itemList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("material.itemList", param);
	}
	
	@Override
	public int materialMenagementTotalCount(Map<String, Object> param) {
		return sqlSessionTemplate.selectOne("material.materialMenagementTotalCount", param);
	}
	
	@Override
	public List<MaterialManagementVO> materialMenagementList(Map<String, Object> param) {
		return sqlSessionTemplate.selectList("material.materialMenagementList", param);
	}
	
	@Override
	public int insertMaterialManagement(Map<String, Object> mtchMap) {
		return sqlSessionTemplate.insert("material.insertMaterialManagement", mtchMap);
	}
	
	@Override
	public int insertMaterialManagementItem(MaterialManagementItemVO item) {
		return sqlSessionTemplate.insert("material.insertMaterialManagementItem", item);
	}
	
	@Override
	public Map<String, Object> getChangeRequestHeader(Map<String, Object> param) {
		return sqlSessionTemplate.selectOne("material.getChangeRequestHeader", param);
	}
	
	@Override
	public List<Map<String, Object>> getChangeRequestItem(Map<String, Object> param) {
		return sqlSessionTemplate.selectList("material.getChangeRequestItem", param);
	}
	
	@Override
	public String getDNoList(Map<String, Object> param) {
		return sqlSessionTemplate.selectOne("material.getDNoList", param);
	}
	
	@Override
	public int updateMMState(Map<String, Object> param) {
		return sqlSessionTemplate.update("material.updateMMState", param);
	}
	
	@Override
	public int updateMfgItemBom(Map<String, Object> param) {
		return sqlSessionTemplate.update("material.updateMfgItemBom", param);
	}
	
	@Override
	public int updateMMItemState(HashMap<String, Object> param) {
		return sqlSessionTemplate.update("material.updateMMItemState", param);
	}
	
	@Override
	public Map<String, Object> getMmHeader(Map<String, Object> param) {
		return sqlSessionTemplate.selectOne("material.getMmHeader", param);
	}
	
	@Override
	public int getDNoListCnt(String miNo) {
		return sqlSessionTemplate.selectOne("material.getDNoListCnt", miNo);
	}
	
	@Override
	public int updateMMItemMfgState(HashMap<String, Object> mmItemParam) {
		return sqlSessionTemplate.update("material.updateMMItemMfgState", mmItemParam);
	}
	
	@Override
	public int updateMMItemExcept(Map<String, Object> mmHeader) {
		return sqlSessionTemplate.update("material.updateMMItemExcept", mmHeader);
	}
}