package kr.co.aspn.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

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

public interface ProductDesignDao {
	public List<Map<String, Object>> getProductDesignList();
	
	// tset
	
	// productDesingList.jsp
	public int getProductDesignListCount(HashMap<String, Object> param);
	public List<Map<String, Object>> getPagenatedProductDesignList(HashMap<String, Object> param);
	public int productDesignSave(ProductDesignCreateVO vo);
	
	// productDesignMain.jsp
	public Map<String, Object> getProductDesignDocInfo(HashMap<String, Object> param);
	public int getProductDesignDetailListCount(HashMap<String, Object> param);
	public List<Map<String, Object>> getPagenatedProductDesignItemList(HashMap<String, Object> param);

	// productDesignDetail.jsp
	public Map<String, Object> getProductDetail(HashMap<String, Object> param);
	public List<Map<String, Object>> getProductDetailTableList(HashMap<String, Object> param);
	public List<Map<String, Object>> getProductDetailCostList(HashMap<String, Object> param);
	public List<String> getItemTypeList(HashMap<String, Object> param);
	
	public int updateProductDesignDoc(ProductDesignCreateVO vo);
	
	public List<String> getProductDesignDocDetailPNoList(HashMap<String, Object> param);
	public int deleteProductDesignDoc(HashMap<String, Object> param);
	public int deleteProductDesignDocDetail(HashMap<String, Object> param);
	/*public int copyProductDesignDocDetail(ProductDesignDocDetail detail);
	public int copyProductDesignDocDetailSub(ProductDesignDocDetailSub sub);
	public int copyProductDesignDocDetailSubMix(ProductDesignDocDetailSubMix subMix);
	public int copyProductDesignDocDetailSubMixItem(ProductDesignDocDetailSubMixItem mixItem);
	public int copyProductDesignDocDetailSubContent(ProductDesignDocDetailSubContent subContent);
	public int copyProductDesignDocDetailSubContentItem(ProductDesignDocDetailSubContentItem contentItem);
	public int copyProductDesignDocDetailPackage(ProductDesignDocDetailPackage pkg);*/
	
	// productDesignDocDetailCreateForm
	public int insertProductDesignDocDetail(ProductDesignDocDetail detail);
	public int insertProductDesignDocDetailSub(ProductDesignDocDetailSub sub);
	public int insertProductDesignDocDetailSubMix(ProductDesignDocDetailSubMix subMix);
	public int insertProductDesignDocDetailSubMixItem(ProductDesignDocDetailSubMixItem mixItem);
	public int insertProductDesignDocDetailSubContent(ProductDesignDocDetailSubContent subContent);
	public int insertProductDesignDocDetailSubContentItem(ProductDesignDocDetailSubContentItem contentItem);
	public int insertProductDesignDocDetailPackage(ProductDesignDocDetailPackage pkg);
	
	// productDesignDocDetailEditForm
	public int updateProductDesignDocDetail(ProductDesignDocDetail detail);
	public int deleteProductDesignDocDetailSub(HashMap<String, Object> param);
	public int deleteProductDesignDocDetailSubMix(HashMap<String, Object> param);
	public int deleteProductDesignDocDetailSubMixItem(HashMap<String, Object> param);
	public int deleteProductDesignDocDetailSubContent(HashMap<String, Object> param);
	public int deleteProductDesignDocDetailSubContentItem(HashMap<String, Object> param);
	public int deleteProductDesignDocDetailPackage(HashMap<String, Object> param);

	// productDesignDocDetailView
	public ProductDesignDocDetail getProductDesignDocDetail(String pdNo);
	public List<ProductDesignDocDetailSub> getProductDesignDocDetailSub(String pdNo);
	public List<ProductDesignDocDetailSubMix> getProductDesignDocDetailSubMix(String pdsNo);
	public List<ProductDesignDocDetailSubMixItem> getProductDesignDocDetailSubMixItem(String pdsmNo, String plantCode);
	public List<ProductDesignDocDetailSubContent> getProductDesignDocDetailSubContent(String pdsNo);
	public List<ProductDesignDocDetailSubContentItem> getProductDesignDocDetailSubContentItem(String pdscNo, String plantCode);
	public List<ProductDesignDocDetailPackage> getProductDesignDocDetailPackage(String pdNo, String plantCode);
	public List<ProductDeisgnDocDetailCostView> getProductDesignDocDetailCostView(String pdNo);

	public List<Map<String, Object>> getDesignDocSummaryList(HashMap<String, Object> param);

	public List<Map<String, Object>> getDesignDocDetailSummaryList(HashMap<String, Object> param);

	public int countForProductDesignDoc(String regUserId);

	public List<Map<String, Object>> getLatestMaterialList(HashMap<String, Object> param);

	public List<Map<String, Object>> getPagenatedPopupList(HashMap<String, Object> param);

	public int getPagenatedPopupListCount(HashMap<String, Object> param);

	public ProductDesignDocVO getProductDesignDoc(HashMap<String, Object> param);

	
	
	public int getProductDesignDocDetailListCount(Map<String, Object> param);
	public List<Map<String, Object>> getProductDesignDocDetailList(Map<String, Object> param);
	
}
