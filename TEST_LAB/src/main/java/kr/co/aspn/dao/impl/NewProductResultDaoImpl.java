package kr.co.aspn.dao.impl;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.aspn.dao.NewProductResultDao;

@Repository
public class NewProductResultDaoImpl implements NewProductResultDao {
	@Autowired
	SqlSessionTemplate sqlSessionTemplate;

	@Override
	public List<Map<String, String>> selectHistory(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("newProductResult.selectHistory", param);
	}

	@Override
	public List<Map<String, Object>> searchNewProductResultListAjax(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("newProductResult.searchNewProductResultListAjax", param);
	}
	
	@Override
	public int selectNewProductResultCount(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("newProductResult.selectNewProductResultCount",param);
	}
	
	@Override
	public List<Map<String, Object>> selectNewProductResultList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("newProductResult.selectNewProductResultList", param);
	}
	
	@Override
	public int selectNewProductResultSeq() {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("newProductResult.selectNewProductResultSeq");
	}
	
	@Override
	public int selectNewProductResultItemSeq() {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("newProductResult.selectNewProductResultItemSeq");
	}
	
	@Override
	public int selectNewProductResultItemImageSeq() {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("newProductResult.selectNewProductResultItemImageSeq");
	}
	
	@Override
	public void insertNewProductResult(Map<String, Object> param) throws Exception{
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("newProductResult.insertNewProductResult", param);
	}
	
	@Override
	public void insertNewProductResultItems(List<Map<String, Object>> itemList) throws Exception{
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("newProductResult.insertNewProductResultItem", itemList);
	}
	
	@Override
	public void insertNewProductResultItemImage(List<Map<String, Object>> itemList) throws Exception{
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("newProductResult.insertNewProductResultItemImage", itemList);
	}
	
	@Override
	public Map<String, String> selectNewProductResultData(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("newProductResult.selectNewProductResultData", param);
	}
	
	@Override
	public List<Map<String, Object>> selectNewProductResultItemList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("newProductResult.selectNewProductResultItemList", param);
	}
	
	@Override
	public List<Map<String, Object>> selectNewProductResultItemImageList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("newProductResult.selectNewProductResultItemImageList", param);
	}
	
	@Override
	public void updateNewProductResult(Map<String, Object> param) {
	    sqlSessionTemplate.update("newProductResult.updateNewProductResult", param);
	}

	@Override
	public void deleteNewProductResultItems(Map<String, Object> param) {
	    sqlSessionTemplate.delete("newProductResult.deleteNewProductResultItems", param);
	}

	@Override
	public void deleteNewProductResultItemImages(Map<String, Object> param) {
	    sqlSessionTemplate.delete("newProductResult.deleteNewProductResultItemImages", param);
	}
	
	@Override
	public List<Map<String, Object>> selectNewProductResultItemImages(Map<String, Object> param) {
	    return sqlSessionTemplate.selectList("newProductResult.selectNewProductResultItemImages", param);
	}

	@Override
	public void deleteNewProductResultItemImageByRow(Map<String, Object> param) {
	    sqlSessionTemplate.delete("newProductResult.deleteNewProductResultItemImageByRow", param);
	}
	
}