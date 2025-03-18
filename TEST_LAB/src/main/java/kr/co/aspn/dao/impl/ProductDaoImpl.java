package kr.co.aspn.dao.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.aspn.dao.MenuDao;
import kr.co.aspn.dao.ProductDao;

@Repository
public class ProductDaoImpl implements ProductDao {
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	@Override
	public String selectProductCode() {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("product.selectProductCode");
	}
	
	@Override
	public List<Map<String, String>> checkMaterial(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("product.checkMaterial", param);
	}

	@Override
	public int selectMaterialCount(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("product.selectMaterialCount", param);
	}
	
	@Override
	public List<Map<String, String>> selectMaterialList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("product.selectMaterialList", param);
	}

	@Override
	public int selectProductDataCount(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("product.selectProductDataCount", param);
	}

	@Override
	public int selectProductSeq() {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("product.selectProductSeq");
	}

	@Override
	public void insertProduct(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("product.insertProduct", param);
	}

	@Override
	public void insertProductMaterial(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("product.insertProductMaterial", param);
	}

	@Override
	public int selectProductCount(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("product.selectProductCount", param);
	}

	@Override
	public List<Map<String, Object>> selectProductList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("product.selectProductList", param);
	}

	@Override
	public Map<String, String> selectProductData(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("product.selectProductData", param);
	}

	@Override
	public List<Map<String, String>> selectProductMaterial(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("product.selectProductMaterial", param);
	}

	@Override
	public List<Map<String, String>> selectHistory(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("product.selectHistory", param);
	}

	@Override
	public void updateProduct(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("product.updateProduct", param);
	}

	@Override
	public void insertNewVersionProduct(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("product.insertNewVersionProduct", param);
	}

	@Override
	public List<Map<String, String>> checkErpMaterial(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("product.checkErpMaterial", param);
	}

	@Override
	public Map<String, Object> selectErpMaterialData(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("product.selectErpMaterialData", param);
	}

	@Override
	public int insertNewVersionCheck(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("product.insertNewVersionCheck", param);
	}

	@Override
	public List<Map<String, Object>> selectSearchProduct(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("product.selectSearchProduct", param);
	}

	@Override
	public void insertFileCopy(HashMap<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("product.insertFileCopy", param);
	}		
}
