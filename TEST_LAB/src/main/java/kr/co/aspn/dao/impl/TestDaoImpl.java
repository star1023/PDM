package kr.co.aspn.dao.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.aspn.dao.TestDao;

@Repository
public class TestDaoImpl implements TestDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	@Override
	public int testUpdate(HashMap<String, Object> param) {
		return sqlSessionTemplate.update("test.testUpdate", param);
	}

	@Override
	public List<Map<String, String>> pMenuList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("test.selectPMenuList", param);
	}

	@Override
	public void insertMenu(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("test.insertMenu", param);
	}
	
	@Override
	public void insertMenu2(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("test.insertMenu2", param);
	}

	@Override
	public int selectTotalMenuCount(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("test.selectTotalMenuCount", param);
	}

	@Override
	public List<Map<String, Object>> selectMenuList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("test.selectMenuList", param);
	}

	@Override
	public void deleteMenu(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("test.deleteMenu", param);
	}

	@Override
	public Map<String, String> selectMenuData(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("test.selectMenuData", param);
	}

	@Override
	public void updateMenu(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("test.updateMenu", param);
	}

	@Override
	public int selectTotalRoleCount(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("test.selectTotalRoleCount", param);
	}

	@Override
	public List<Map<String, Object>> selectRoleList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("test.selectRoleList", param);
	}

	@Override
	public void insertRole(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("test.insertRole", param);
	}

	@Override
	public Map<String, String> selectRoleData(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("test.selectRoleData", param);
	}

	@Override
	public void updateRole(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("test.updateRole", param);
	}

	@Override
	public void deleteRole(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("test.deleteRole", param);
	}

	@Override
	public List<Map<String, String>> selectAllMenu(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("test.selectAllMenu", param);
	}

	@Override
	public List<Map<String, String>> selectRoleMenuList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("test.selectRoleMenuList", param);
	}

	@Override
	public void deleteRoleMenu(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.delete("test.deleteRoleMenu", param);
	}

	@Override
	public void insertRoleMenu(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		System.err.println(param);
		sqlSessionTemplate.insert("test.insertRoleMenu", param);
	}

	@Override
	public List<Map<String, Object>> selectUserMenu(Map<String, String> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("test.selectUserMenu", param);
	}

	@Override
	public List<Map<String, Object>> selectCategory(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("test.selectCategory", param);
	}
	
	@Override
	public Map<String, Object> selectCategoryData(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("test.selectCategoryData", param);
	}

	@Override
	public void insertCategory(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("test.insertCategory", param);
	}

	@Override
	public void updateCategoryName(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("test.updateCategoryName", param);
	}

	@Override
	public void deleteCategory(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("test.deleteCategory", param);
	}
	
	@Override
	public void updateCategoryOrder(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("test.updateCategoryOrder", param);
	}

	@Override
	public void updateDisplayOrder(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("test.updateDisplayOrder", param);
	}
	
	@Override
	public Map<String, Object> selectNPCategory(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("test.selectNPCategory", param);
	}
	
	@Override
	public void updateNPCategoryOrder(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("test.updateNPCategoryOrder", param);
	}
	
	@Override
	public void updateMyCategoryOrder(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("test.updateMyCategoryOrder", param);
	}

	@Override
	public void updateCategory(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("test.updateCategory", param);
	}

	@Override
	public List<Map<String, Object>> selectAllMenuList2(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("test.selectAllMenuList2", param);
	}

	@Override
	public int selectMaterialCount(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("test.selectMaterialCount", param);
	}

	@Override
	public List<Map<String, Object>> selectMaterialList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("test.selectMaterialList", param);
	}

	@Override
	public List<Map<String, Object>> categoryList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("test.categoryList", param);
	}

	@Override
	public int selectMaterialDataCount(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("test.selectMaterialDataCount", param);
	}

	@Override
	public int selectMaterialSeq() {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("test.selectMaterialSeq");
	}

	@Override
	public void insertMaterial(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("test.insertMaterial",param);
	}

	@Override
	public void insertHistory(Map<String, Object> historyParam) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("test.insertHistory",historyParam);
	}

	@Override
	public void insertFileInfo(Map<String, Object> fileMap) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("test.insertFileInfo",fileMap);
	}

	@Override
	public Map<String, String> selectMaterialData(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("test.selectMaterialData", param);
	}

	@Override
	public List<Map<String, String>> selectFileList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("test.selectFileList", param);
	}

	@Override
	public Map<String, String> selectFileData(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("test.selectFileData", param);
	}

	@Override
	public List<Map<String, String>> selectCategoryByPId(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("test.selectCategoryByPId", param);
	}

	@Override
	public void deleteMaterial(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("test.deleteMaterial",param);
	}

	@Override
	public int selectErpMaterialCount(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("test.selectErpMaterialCount", param);
	}

	@Override
	public List<Map<String, Object>> selectErpMaterialList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("test.selectErpMaterialList", param);
	}

	@Override
	public String selectmaterialCode() {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("test.selectmaterialCode");
	}

	@Override
	public void insertFileType(List<HashMap<String, Object>> docTypeList) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("test.insertFileType", docTypeList);
	}

	@Override
	public List<Map<String, String>> selectFileType(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("test.selectFileType", param);
	}

	@Override
	public void updateMaterial(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("test.updateMaterial",param);
	}

	@Override
	public void insertNewVersionMaterial(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("test.insertNewVersionMaterial",param);
	}

	@Override
	public List<Map<String, String>> selectHistory(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("test.selectHistory", param);
	}

	@Override
	public Map<String, Object> selectErpMaterialData(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("test.selectErpMaterialData", param);
	}
	
	@Override
	public void deleteFileData(String fileIdx) {
	    sqlSessionTemplate.delete("test.deleteFileData", fileIdx);
	}
}
