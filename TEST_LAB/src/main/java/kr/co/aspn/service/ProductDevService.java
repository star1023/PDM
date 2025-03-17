package kr.co.aspn.service;

import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import kr.co.aspn.common.auth.Auth;
import kr.co.aspn.vo.DesignRequestDocVO;
import kr.co.aspn.vo.DevDocVO;
import kr.co.aspn.vo.ImageFileForStores;
import kr.co.aspn.vo.LabPagingObject;
import kr.co.aspn.vo.LabPagingResult;
import kr.co.aspn.vo.LabSearchVO;
import kr.co.aspn.vo.ManufacturingProcessDocVO;
import kr.co.aspn.vo.MfgProcessDoc;
import kr.co.aspn.vo.MfgProcessDocDisp;
import kr.co.aspn.vo.MfgProcessDocProdSpec;
import kr.co.aspn.vo.NutritionLabel;
import kr.co.aspn.vo.ProductDevDocFileVO;
import kr.co.aspn.vo.ProductDevDocVO;
import kr.co.aspn.vo.ResultVO;

public interface ProductDevService {
	public LabPagingResult getProductDevDocList(LabPagingObject page, LabSearchVO search);
	
	public ProductDevDocVO getProductDevDoc(String docNo, String docVersion);
	public List<ManufacturingProcessDocVO> getManufacturingProcessDocList(String docNo, String docVersion);
	public List<DesignRequestDocVO> getDesignRequestDocList(String docNo, String docVersion);
	public List<ProductDevDocFileVO> getAttatchFile(String docNo, String docVersion);

	public List<Integer> getProductDevDocVersionList(String docNo);

	public String saveProductDevDoc(DevDocVO devDocVO);

	public String saveManufacturingProcessDoc(MfgProcessDoc mfgProcessDoc, boolean isUpdate);
	
	public MfgProcessDoc getMfgProcessDocDetail(String dNo, String docNo, String docVersion, String plantCode);

	public String deleteManufacturingProcessDoc(String dNo, boolean isUpdate, String usreId);
	
	public String copyManufacturingProcessDoc(String dNo, String userId);

	public MfgProcessDocProdSpec testCall(String dNo);

	public DesignRequestDocVO getDesignRequestDocDetail(String drNo);

	public int saveDesignRequestDoc(DesignRequestDocVO designVO);

	public int updateDesignRequestDoc(DesignRequestDocVO designVO);
	
	public int deleteDesignRequestDoc(int drNo, String userId);
	
	public int deleteAllDesignRequestDoc(String docNo, String docVersion, String modUserId);

	public int updateDevDocCloseState(DevDocVO devDocVO, String userId);

	public int updateProductDevDoc(DevDocVO devDocVO);

	public String versionUpDevDoc(DevDocVO devDocVO, String[] drNoArr);
	
	public boolean hasAuthority(String userId,String regUserId,int grade);
	
	public List<Map<String,Object>> detailDdNo(int ddNo);

	public List<Map<String, Object>> getMfgsummaryList(Auth userInfo, String docNo, String docVersion);

	public List<Map<String, Object>> getDevDocSummaryList(Auth userInfo, String productType1, String productType2, String productType3, String productName);

	public List<String> getDevDocVersion(String docNo);
	
	public int countForDevDoc(String regUserId);
	
	public int countForDesignRequestDoc(String regUserId);
	
	public int countForManuFacturingProcessDoc(String regUserId);

	public NutritionLabel getNutritionLabel(String drNo);
	
	public Map<String, Object> updateBOM(String[] dNoList, String userId) throws Exception;
	

	public String updateManufacturingProcessDoc(String dNo, String state, String userId);
	
	public Map<String,Object> MfgProcessDetail(Map<String,Object> param);

	public List<Map<String, Object>> getLatestMaterail(String dNo, String itemImNo, String itemSapCode);

	public int deleteProductDevDoc(DevDocVO devDocVO);

	public Map<String, Object> getDispInfo(String dNo);

	public int updateDispList(MfgProcessDoc mfgProcessDoc);

	public String checkDevDocFile(String ddfNo, String userId);

	public String updateManufacturingProcessDocPakcage(MfgProcessDoc mfgProcessDoc);
	
	public String updateManufacturingProcessDocSpec(MfgProcessDoc mfgProcessDoc);

	public List<Map<String,Object>> getHistoryList(String tbType, String tbKey);

	public String copyDesignRequestDoc(String drNo, String docNo, String docVersion, String userId);

	public List<Map<String,Object>> searchDevDocLatest(Map<String,Object> param);

	public void updateProductLaunchDate(Map<String,Object> param);
	
	public List<Map<String,Object>> searchLaunchListByDate (Map<String,Object> param);

	// S201109-00014
	public ResultVO updateQns(HttpServletRequest request, Map<String, Object> param);

	public Map<String,Object> popupDataInfo(Map<String, Object> param);
	
	public Map<String, Object> bomItemCheck(String[] dNoList, String userId) throws Exception;

    void updateDocStopMonth(HashMap<String, Object> param);
	
    ImageFileForStores saveImageFileForStore(ImageFileForStores imageFileForStore) throws Exception; //제조순서 첨부파일 저장 23.11.06

	List<ImageFileForStores> getImageFileForStores(String dNo); //제조순서 첨부파일 조회 23.11.06

	int getImageFileForStoresCnt(String dNo);

	String saveManufacturingProcessDocStores(MfgProcessDoc mfgProcessDoc, boolean isUpdate, MultipartFile[] files, String[] gubuns)throws Exception;
}
