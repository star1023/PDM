package kr.co.aspn.service;

import java.util.Map;

import org.springframework.ui.ModelMap;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.List;

import kr.co.aspn.common.auth.Auth;
import kr.co.aspn.vo.LabPagingObject;
import kr.co.aspn.vo.LabPagingResult;
import kr.co.aspn.vo.LabSearchVO;
import kr.co.aspn.vo.ProductDesignCreateVO;
import kr.co.aspn.vo.ProductDesignDocDetail;
import kr.co.aspn.vo.ProductDesignDocVO;

public interface ProductDesignService {
	public Map<String, Object> getProductDesignDocInfo(String pNo);
	public LabPagingResult getProductDesignList(LabPagingObject page, LabSearchVO search);
	public LabPagingResult getProductDesignItemList(LabPagingObject page, String pNo);
	//public Map<String, Object> getProductDetail(ProductDeisngDocKeyVO vo);
	//public List<Map<String, Object>> getProductDetailTableList(ProductDesignVO vo);
	//public List<Map<String, Object>> getProductDetailCostList(ProductDeisngDocKeyVO vo);
	public List<String> getItemTypeList(String pNo, String pdNo);
	public List<Map<String, Object>> getProductDetailTableList(String pNo, String pdNo, String itemType);
	public ProductDesignDocDetail getProductDesignDocDetail(String pdNo, String plantCode);
	
	public ProductDesignDocVO getProductDesignDoc(String pNo);
	public String productDesignSave(ProductDesignCreateVO vo);
	public String updateProductDesignDoc(ProductDesignCreateVO vo);
	public String deleteProductDesignDoc(String pNo);
	
	public String saveProductDesignDocDetail(ProductDesignDocDetail vo, MultipartFile imageFile, boolean isNew) ;
	//public String updateProductDeisgnDocDetail(String pNo, String pdNo);
	public String deleteProductDesignDocDetail(String pNo, String pdNo);
	public String copyProductDesignDocDetail(String pNo, String pdNo, String userId);
	public List<Map<String, Object>> getDesignDocSummaryList(Auth userInfo, String companyCode, String plantCode, String productName);
	public List<Map<String, Object>> getDesignDocDetailSummaryList(String pNo);
	
	public int countForProductDesignDoc(String regUserId);
	public List<Map<String, Object>> getLatestMaterialList(String[] imNoArr);
	public String txTest(String value) throws Exception;
	
	public LabPagingResult getPagenatedPopupList(LabPagingObject page, LabSearchVO search);
	
	public Map<String, Object> getProductDesingDocDetailList(Map<String, Object> param) throws Exception;
}
