package kr.co.aspn.dao.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.aspn.dao.ProductDesignDao;
import kr.co.aspn.vo.LabPagingObject;
import kr.co.aspn.vo.LabPagingResult;
import kr.co.aspn.vo.ProductDeisgnDocDetailCostView;
import kr.co.aspn.vo.ProductDesignCreateVO;
import kr.co.aspn.vo.ProductDesignDocDetail;
import kr.co.aspn.vo.ProductDesignDocDetailPackage;
import kr.co.aspn.vo.ProductDesignDocDetailSub;
import kr.co.aspn.vo.ProductDesignDocDetailSubContent;
import kr.co.aspn.vo.ProductDesignDocDetailSubContentItem;
import kr.co.aspn.vo.ProductDesignDocDetailSubMix;
import kr.co.aspn.vo.ProductDesignDocDetailSubMixItem;
import kr.co.aspn.vo.ProductDesignDocVO;

@Repository("pruductDesignRepo")
public class ProductDesignDaoImpl implements ProductDesignDao {
	
	@Autowired
	@Resource(name="sqlSessionTemplate")
	private SqlSessionTemplate sqlSessionTemplate;
	
	@Override
	public Map<String, Object> getProductDesignDocInfo(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectOne("productDesign.getProductDesignDocInfo", param);
	}
	
	@Override
	public List<Map<String, Object>> getProductDesignList() {
		return sqlSessionTemplate.selectList("productDesign.getProductDesignList", null);
	}

	@Override
	public int getProductDesignListCount(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectList("productDesign.getPagenatedProductDesignList", param).size();
	}

	@Override
	public List<Map<String, Object>> getPagenatedProductDesignList(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectList("productDesign.getPagenatedProductDesignList", param);
	}

	@Override
	public int productDesignSave(ProductDesignCreateVO vo) {
		return sqlSessionTemplate.insert("productDesign.productDesignSave", vo);
	}
	
	@Override
	public int updateProductDesignDoc(ProductDesignCreateVO vo) {
		return sqlSessionTemplate.update("productDesign.updateProductDesignDoc", vo);
	}
	
	@Override
	public int getProductDesignDetailListCount(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectList("productDesign.getPagenatedProductDesignItemList", param).size();
	}
	
	@Override
	public List<Map<String, Object>> getPagenatedProductDesignItemList(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectList("productDesign.getPagenatedProductDesignItemList", param);
	}

	@Override
	public Map<String, Object> getProductDetail(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectOne("productDesign.getProductDetail", param);
	}

	@Override
	public List<Map<String, Object>> getProductDetailTableList(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectList("productDesign.getProductDetailTableList", param);
	}

	@Override
	public List<Map<String, Object>> getProductDetailCostList(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectList("productDesign.getProductDetailCostList", param);
	}

	@Override
	public List<String> getItemTypeList(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectList("productDesign.getItemTypeList", param);
	}

	
	


	@Override
	public int insertProductDesignDocDetail(ProductDesignDocDetail detail) {
		return sqlSessionTemplate.insert("productDesign.insertProductDesignDocDetail", detail);
	}
	
	@Override
	public int insertProductDesignDocDetailSub(ProductDesignDocDetailSub sub) {
		return sqlSessionTemplate.insert("productDesign.insertProductDesignDocDetailSub", sub);
	}

	@Override
	public int insertProductDesignDocDetailSubMix(ProductDesignDocDetailSubMix subMix) {
		return sqlSessionTemplate.insert("productDesign.insertProductDesignDocDetailSubMix", subMix);
	}

	@Override
	public int insertProductDesignDocDetailSubMixItem(ProductDesignDocDetailSubMixItem mixItem) {
		return sqlSessionTemplate.insert("productDesign.insertProductDesignDocDetailSubMixItem", mixItem);
	}
	
	@Override
	public int insertProductDesignDocDetailSubContent(ProductDesignDocDetailSubContent subContent) {
		return sqlSessionTemplate.insert("productDesign.insertProductDesignDocDetailSubContent", subContent);
	}

	@Override
	public int insertProductDesignDocDetailSubContentItem(ProductDesignDocDetailSubContentItem contentItem) {
		return sqlSessionTemplate.insert("productDesign.insertProductDesignDocDetailSubContentItem", contentItem);
	}
	
	@Override
	public int insertProductDesignDocDetailPackage(ProductDesignDocDetailPackage pkg) {
		return sqlSessionTemplate.insert("productDesign.insertProductDesignDocDetailPackage", pkg);
	}
	
	
	
	@Override
	public int updateProductDesignDocDetail(ProductDesignDocDetail detail) {
		return sqlSessionTemplate.update("productDesign.updateProductDesignDocDetail", detail);
	}
	
	@Override
	public int deleteProductDesignDoc(HashMap<String, Object> param) {
		return sqlSessionTemplate.delete("productDesign.deleteProductDesignDoc", param);
	}
	
	@Override
	public int deleteProductDesignDocDetail(HashMap<String, Object> param) {
		return sqlSessionTemplate.delete("productDesign.deleteProductDesignDocDetail", param);
	}
	
	@Override
	public int deleteProductDesignDocDetailSub(HashMap<String, Object> param) {
		return sqlSessionTemplate.delete("productDesign.deleteProductDesignDocDetailSub", param);
	}

	@Override
	public int deleteProductDesignDocDetailSubMix(HashMap<String, Object> param) {
		return sqlSessionTemplate.delete("productDesign.deleteProductDesignDocDetailSubMix", param);
	}

	@Override
	public int deleteProductDesignDocDetailSubMixItem(HashMap<String, Object> param) {
		return sqlSessionTemplate.delete("productDesign.deleteProductDesignDocDetailSubMixItem", param);
	}

	@Override
	public int deleteProductDesignDocDetailSubContent(HashMap<String, Object> param) {
		return sqlSessionTemplate.delete("productDesign.deleteProductDesignDocDetailSubContent", param);
	}

	@Override
	public int deleteProductDesignDocDetailSubContentItem(HashMap<String, Object> param) {
		return sqlSessionTemplate.delete("productDesign.deleteProductDesignDocDetailSubContentItem", param);
	}

	@Override
	public int deleteProductDesignDocDetailPackage(HashMap<String, Object> param) {
		return sqlSessionTemplate.delete("productDesign.deleteProductDesignDocDetailPackage", param);
	}
	
	
	

	@Override
	public ProductDesignDocDetail getProductDesignDocDetail(String pdNo) {
		return sqlSessionTemplate.selectOne("productDesign.getProductDesignDocDetail", pdNo);
	}
	
	
	@Override
	public List<ProductDesignDocDetailSub> getProductDesignDocDetailSub(String pdNo) {
		return sqlSessionTemplate.selectList("productDesign.getProductDesignDocDetailSub", pdNo);
	}
	
	@Override
	public List<ProductDesignDocDetailSubMix> getProductDesignDocDetailSubMix(String pdsNo) {
		return sqlSessionTemplate.selectList("productDesign.getProductDesignDocDetailSubMix", pdsNo);
	}
	
	@Override
	public List<ProductDesignDocDetailSubMixItem> getProductDesignDocDetailSubMixItem(String pdsmNo, String plantCode) {
      HashMap<String, Object> param = new HashMap<String, Object>();
      param.put("pdsmNo", pdsmNo);
      param.put("plantCode", plantCode);
      //return sqlSessionTemplate.selectList("productDesign.getProductDesignDocDetailSubMixItem", pdsmNo);
      return sqlSessionTemplate.selectList("productDesign.getProductDesignDocDetailSubMixItem", param);
   }
	
	@Override
	public List<ProductDesignDocDetailSubContent> getProductDesignDocDetailSubContent(String pdsNo) {
		return sqlSessionTemplate.selectList("productDesign.getProductDesignDocDetailSubContent", pdsNo);
	}
	
	@Override
	public List<ProductDesignDocDetailSubContentItem> getProductDesignDocDetailSubContentItem(String pdscNo, String plantCode) {
      HashMap<String, Object> param = new HashMap<String, Object>();
      param.put("pdscNo", pdscNo);
      param.put("plantCode", plantCode);
      //return sqlSessionTemplate.selectList("productDesign.getProductDesignDocDetailSubContentItem", pdscNo);
      return sqlSessionTemplate.selectList("productDesign.getProductDesignDocDetailSubContentItem", param);
   }
	
	@Override
	public List<ProductDesignDocDetailPackage> getProductDesignDocDetailPackage(String pdNo, String plantCode) {
		HashMap<String, Object> param = new HashMap<String, Object>();
	      param.put("pdNo", pdNo);
	      param.put("plantCode", plantCode);
		return sqlSessionTemplate.selectList("productDesign.getProductDesignDocDetailPackage", param);
	}
	
	@Override
	public List<ProductDeisgnDocDetailCostView> getProductDesignDocDetailCostView(String pdNo) {
		return sqlSessionTemplate.selectList("productDesign.getProductDesignDocDetailCostView", pdNo);
	}
	
	@Override
	public List<String> getProductDesignDocDetailPNoList(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectList("productDesign.getProductDesignDocDetailPNoList", param);
	}
	
	@Override
	public List<Map<String, Object>> getDesignDocSummaryList(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectList("productDesign.getDesignDocSummaryList", param);
	}
	
	@Override
	public List<Map<String, Object>> getDesignDocDetailSummaryList(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectList("productDesign.getDesignDocDetailSummaryList", param);
	}

	@Override
	public int countForProductDesignDoc(String regUserId) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("productDesign.countForProductDesignDoc", regUserId);
	}
	
	@Override
	public List<Map<String, Object>> getLatestMaterialList(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectList("productDesign.getLatestMaterialList", param);
	}
	
	@Override
	public int getPagenatedPopupListCount(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectOne("productDesign.getPagenatedPopupListCount", param);
	}
	
	@Override
	public List<Map<String, Object>> getPagenatedPopupList(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectList("productDesign.getPagenatedPopupList", param);
	}
	
	@Override
	public ProductDesignDocVO getProductDesignDoc(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectOne("productDesign.getProductDesignDoc", param);
	}

	@Override
	public int getProductDesignDocDetailListCount(Map<String, Object> param) {
		return sqlSessionTemplate.selectOne("productDesign.getProductDesignDocDetailListCount", param);
	}

	@Override
	public List<Map<String, Object>> getProductDesignDocDetailList(Map<String, Object> param) {
		return sqlSessionTemplate.selectList("productDesign.getProductDesignDocDetailList", param);
	}
}
