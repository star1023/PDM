package kr.co.aspn.dao.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.aspn.dao.MenuDao;

@Repository
public class MenuDaoImpl implements MenuDao {
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	@Override
	public String selectProductCode() {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("menu.selectProductCode");
	}
	
	@Override
	public List<Map<String, String>> checkMaterial(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("menu.checkMaterial", param);
	}

	@Override
	public int selectMaterialCount(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("menu.selectMaterialCount", param);
	}
	
	@Override
	public List<Map<String, String>> selectMaterialList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("menu.selectMaterialList", param);
	}

	@Override
	public int selectProductDataCount(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("menu.selectProductDataCount", param);
	}

	@Override
	public int selectProductSeq() {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("menu.selectProductSeq");
	}

	@Override
	public void insertProduct(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("menu.insertProduct", param);
	}

	@Override
	public void insertProductMaterial(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("menu.insertProductMaterial", param);
	}

	@Override
	public int selectProductCount(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("menu.selectProductCount", param);
	}

	@Override
	public List<Map<String, Object>> selectProductList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("menu.selectProductList", param);
	}

	@Override
	public Map<String, String> selectProductData(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("menu.selectProductData", param);
	}

	@Override
	public List<Map<String, String>> selectProductMaterial(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("menu.selectProductMaterial", param);
	}

	@Override
	public List<Map<String, String>> selectHistory(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("menu.selectHistory", param);
	}

	@Override
	public void updateProduct(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("menu.updateProduct", param);
	}

	@Override
	public void insertNewVersionProduct(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("menu.insertNewVersionProduct", param);
	}

	@Override
	public int selectMenuCount(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("menu.selectMenuCount", param);
	}

	@Override
	public List<Map<String, Object>> selectMenuList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("menu.selectMenuList", param);
	}

	@Override
	public int selectMenuDataCount(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("menu.selectMenuDataCount", param);
	}

	@Override
	public int selectMenuSeq() {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("menu.selectMenuSeq");
	}

	@Override
	public void insertMenu(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("menu.insertMenu", param);
	}

	@Override
	public void insertMenuMaterial(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("menu.insertMenuMaterial", param);
	}

	@Override
	public List<Map<String, String>> selectMenuHistory(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("menu.selectMenuHistory", param);
	}

	@Override
	public Map<String, String> selectMenuData(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("menu.selectMenuData", param);
	}

	@Override
	public List<Map<String, String>> selectMenuMaterial(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("menu.selectMenuMaterial", param);
	}

	@Override
	public void updateMenuVersion(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("menu.updateMenuVersion", param);
	}

	@Override
	public void insertNewVersionMenu(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("menu.insertNewVersionMenu", param);
	}

	@Override
	public void insertCookManual(Map<String, Object> param) {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("menu.insertCookManual", param);
	}

	@Override
	public List<Map<String, String>> checkErpMaterial(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("menu.checkErpMaterial", param);
	}

	@Override
	public Map<String, Object> selectErpMaterialData(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("menu.selectErpMaterialData", param);
	}

	@Override
	public int insertNewVersionCheck(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("menu.insertNewVersionCheck", param);
	}

	@Override
	public List<Map<String, Object>> selectSearchProduct(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("menu.selectSearchProduct", param);
	}

	@Override
	public void insertFileCopy(HashMap<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("menu.insertFileCopy", param);
	}

	@Override
	public List<Map<String, Object>> searchUser(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("menu.searchUser", param);
	}

	@Override
	public int selectLineSeq() {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("menu.selectLineSeq");
	}

	@Override
	public void insertApprLine(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("menu.insertApprLine", param);
	}

	@Override
	public void insertApprLineItem(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("menu.insertApprLineItem", param);
	}

	@Override
	public List<Map<String, Object>> selectApprovalLine(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("menu.selectApprovalLine", param);
	}

	@Override
	public List<Map<String, Object>> selectApprovalLineItem(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("menu.selectApprovalLineItem", param);
	}

	@Override
	public void deleteApprLine(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("menu.deleteApprLine", param);
	}

	@Override
	public int selectApprSeq() {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("menu.selectApprSeq");
	}	
}
