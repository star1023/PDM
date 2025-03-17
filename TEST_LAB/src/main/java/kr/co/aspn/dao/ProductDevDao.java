package kr.co.aspn.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.co.aspn.vo.DesignRequestDocVO;
import kr.co.aspn.vo.DevDocLogVO;
import kr.co.aspn.vo.DevDocVO;
import kr.co.aspn.vo.ImageFileForStores;
import kr.co.aspn.vo.ManufacturingProcessDocVO;
import kr.co.aspn.vo.MfgProcessDoc;
import kr.co.aspn.vo.MfgProcessDocBase;
import kr.co.aspn.vo.MfgProcessDocDisp;
import kr.co.aspn.vo.MfgProcessDocItem;
import kr.co.aspn.vo.MfgProcessDocProdSpec;
import kr.co.aspn.vo.MfgProcessDocProdSpecMD;
import kr.co.aspn.vo.MfgProcessDocStoreMethod;
import kr.co.aspn.vo.MfgProcessDocSubProd;
import kr.co.aspn.vo.NutritionLabel;
import kr.co.aspn.vo.ProductDevDocFileVO;
import kr.co.aspn.vo.ProductDevDocVO;

public interface ProductDevDao {

	public int getProductDevDocListCount(HashMap<String, Object> param);
	public List<Map<String, Object>> getProductDevDocList(HashMap<String, Object> param);
	public ProductDevDocVO getProductDevDoc(HashMap<String, Object> param);
	public List<ManufacturingProcessDocVO> getManufacturingProcessDocList(HashMap<String, Object> param);
	public List<DesignRequestDocVO> getDesignRequestDocList(HashMap<String, Object> param);
	public List<ProductDevDocFileVO> getAttatchFile(HashMap<String, Object> param);
	public List<Integer> getProductDevDocVersionList(HashMap<String, Object> param);
	public String getNextDevDocNo();
	public void loggingDevDoc(DevDocLogVO devDocLogVO);
	
	// 제품개발문서 등록, 수정
	public int saveProductDevDoc(DevDocVO devDocVO);
	public int updateProductDevDoc(DevDocVO devDocVO);
	
	// 제조공정서 저장
	public void saveMfgProcessDoc(MfgProcessDoc mfgProcessDoc);
	public void saveMfgProcessDocSub(MfgProcessDocSubProd mfgProcessDocSubProd);
	public void saveMfgProcessDocMix(MfgProcessDocBase mfgProcessDocMix);
	public void saveMfgProcessDocCont(MfgProcessDocBase mfgProcessDocMix);
	public int saveMfgProcessDocItem(MfgProcessDocItem mfgProcessDocItem);
	public void saveMfgProcessDocDisp(MfgProcessDocDisp mfgProcessDocDisp);
	public int saveMfgProcessDocProdSpec(MfgProcessDocProdSpec spec);
	public void saveMfgProcessDocProdSpecMD(MfgProcessDocProdSpecMD specMD); 
	public void saveMfgProcessDocStoreMethod(MfgProcessDocStoreMethod mfgProcessDocStoreMethod); // 23.11.02(점포용 제조공정서 저장)
	
	// 제조공정서 삭제
	public int deleteMfgProcessDoc(HashMap<String, Object> param);
	public int deleteMfgProcessDocSub(HashMap<String, Object> param);
	public int deleteMfgProcessDocMix(HashMap<String, Object> param);
	public int deleteMfgProcessDocCont(HashMap<String, Object> param);
	public int deleteMfgProcessDocItem(HashMap<String, Object> param);
	public int deleteMfgProcessDocDisp(HashMap<String, Object> param);
	public int deleteMfgProcessDocSpec(HashMap<String, Object> param);
	public int deleteMfgProcessDocSpecMD(HashMap<String, Object> param);
	public int deleteMfgProcessDocStoreMethod(HashMap<String, Object> param); // 23.11.02(점포용 제조공정서 조회)
	
	// 제조공정서 조회
	public MfgProcessDoc getMfgProcessDocDetail(HashMap<String, Object> param);
	public List<MfgProcessDocSubProd> getMfgProcessDocSub(HashMap<String, Object> param);
	public List<MfgProcessDocBase> getMfgProcessDocMix(HashMap<String, Object> param);
	public List<MfgProcessDocBase> getMfgProcessDocCont(HashMap<String, Object> param);
	public List<MfgProcessDocItem> getMfgProcessDocItem(HashMap<String, Object> param);
	public List<MfgProcessDocDisp> getMfgProcessDocDisp(HashMap<String, Object> param);
	public MfgProcessDocProdSpec getMfgProcessDocSpec(HashMap<String, Object> param);
	public MfgProcessDocProdSpecMD getMfgProcessDocSpecMD(HashMap<String, Object> param);	
	public List<MfgProcessDocStoreMethod> getMfgProcessDocStoreMethod(HashMap<String, Object> param); // 23.11.02(점포용 제조공정서 조회)
	
	// 제조공정서 수정시 이전문서 키 값으로 변경
	public int updateMfgProcessDoc(MfgProcessDoc mfgProcessDoc);
	
	// 제조공정서 상태변경
	public int updateManufacturingProcessDoc(HashMap<String, Object> param);
	
	// 디자인의뢰서
	public int saveDesignRequestDoc(DesignRequestDocVO designVO);
	public int saveNutritionLabel(NutritionLabel nutritionLabel);
	public DesignRequestDocVO getDesignRequestDocDetail(HashMap<String, Object> param);
	public NutritionLabel getNutritionLabel(HashMap<String, Object> param);
	public int updateDesignRequestDoc(DesignRequestDocVO designVO);
	public int deleteDesignRequestDoc(HashMap<String, Object> param);
	public int deleteAllDesignRequestDoc(HashMap<String,Object> param);
	
	// 제조공정서 상태 변경
	public int updateDevDocCloseState(HashMap<String, Object> param);
	public int updateDevDocLatestState(HashMap<String, Object> param);
	
	// 제조공정서 버전업
	public int versionUpDevDoc(DevDocVO devDocVO);
	public int copyDesignRequestDocList(HashMap<String, Object> param);
	public int copyDevDocFile(HashMap<String, Object> param);
	
	
	public int hasAuthority(Map<String,Object> param);
	public List<Map<String,Object>> detailDdNo(int ddNo);
	public List<Map<String, Object>> getMfgsummaryList(HashMap<String, Object> param);
	public List<Map<String, Object>> getDevDocSummaryList(HashMap<String, Object> param);
	public List<String> getDevDocVersion(HashMap<String, Object> param);

	public List<Map<String, Object>> getLatestMaterailOfSapCode(HashMap<String, Object> param);
	public List<Map<String, Object>> getLatestMaterailOfImNo(HashMap<String, Object> param);
	
	public int countForDevDoc(String regUserId);
	public int countForDesignRequestDoc(String regUserId);
	public int countForManuFacturingProcessDoc(String regUserId);
	public List<Map<String, Object>> getBomHeaderList(HashMap<String, Object> param);
	public List<Map<String, Object>> getBomItemList(HashMap<String, Object> param);
	
	public Map<String,Object> MfgProcessDetail(Map<String,Object> param);
	public int deleteProductDevDoc(DevDocVO devDocVO);
	public List<String> getdNo(HashMap<String, Object> param);
	public int getProductDevDocLatest(String docNo);
	public int updateProductDevDocLatest(String docNo);
	public List<Map<String, Object>> getDispInfo(HashMap<String, Object> param);
	
	public int updateDisp(MfgProcessDocDisp disp);
	public int updateMfgProcessDocState0(HashMap<String, Object> param);
	public int updateDesignRequestDocState0(HashMap<String, Object> param);
	public int getBomHeaderNextSeq(Map<String, Object> headerMap);
	public int insertBomHeader(Map<String, Object> headerMap);
	public int updateMgfProcessDocBom(Map<String, Object> headerMap);
	public int checkDevDocFile(HashMap<String, Object> param);
	public int deleteMfgProcessDocPkgItem(HashMap<String, Object> param);
	public int copyDesignRequestDoc(HashMap<String, Object> param);
	public int copyNutiritionLabel(HashMap<String, Object> param);
	public int updateNutritionLabel(NutritionLabel nutritionLabel);

	public List<Map<String,Object>> searchDevDocLatest(Map<String,Object> param);

	public void updateProductLaunchDate(Map<String,Object> param);
	
	public List<Map<String,Object>> searchLaunchListByDate (Map<String,Object> param);
	public List<String> selectDesignReqDocApprNo(HashMap<String, Object> param);
	public int updateMfgProcessDocEtc(MfgProcessDoc mfgProcessDoc);
	
	public int copyMfgProcessDocDetail(MfgProcessDoc mfgPrcoessDoc);
	// S201109-00014
	public int updateQns(Map<String, Object> param);
	
	public Map<String, String> getDocInfo(Map<String, Object> param);
	
	public int updateDocProdName(HashMap<String, Object> param);
	
	public List<Map<String, Object>> getCheckBomHeaderList(HashMap<String, Object> param);
	public List<Map<String, Object>> getCheckBomItemList(HashMap<String, Object> param);
	
	//
    int updateDocStopMonth(HashMap<String, Object> param);
    
    // 23.11.06 점포용 제조공정서 																					
	List<ImageFileForStores> getimageFileForStores(String dNo);
	public int insertImageFileForStores(ImageFileForStores imageFileForStore);
	public int updateImageFileForStores(ImageFileForStores imageFileForStore);
	public int updateImageDescript(ImageFileForStores imageFileForStores);
	public int getimageFileForStoresCnt(String dNo);
	
	// 24.01.03 임시 자재코드  조회
	public List<Map<String, Object>> getCheckBomItemSampleList(HashMap<String, Object> param);
    
}
