package kr.co.aspn.dao.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.aspn.dao.ProductDevDao;
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

@Repository("pruductDevRepo")
public class ProductDevDaoImpl implements ProductDevDao {
	@Autowired
	@Resource(name="sqlSessionTemplate")
	private SqlSessionTemplate sqlSessionTemplate;

	@Override
	public int getProductDevDocListCount(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectOne("productDev.getProductDevDocListCount", param);
	}

	@Override
	public List<Map<String, Object>> getProductDevDocList(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectList("productDev.getProductDevDocList", param);
	}

	@Override
	public ProductDevDocVO getProductDevDoc(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectOne("productDev.getProductDevDoc", param);
	}

	@Override
	public List<ManufacturingProcessDocVO> getManufacturingProcessDocList(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectList("productDev.getManufacturingProcessDocList", param);
	}
	
	@Override
	public List<DesignRequestDocVO> getDesignRequestDocList(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectList("productDev.getDesignRequestDocList", param);
	}
	
	@Override
	public List<ProductDevDocFileVO> getAttatchFile(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectList("productDev.getAttatchFile", param);
	}

	@Override
	public List<Integer> getProductDevDocVersionList(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectList("productDev.getProductDevDocVersionList", param);
	}

	@Override
	public int saveProductDevDoc(DevDocVO devDocVO) {
		return sqlSessionTemplate.insert("productDev.saveProductDevDoc", devDocVO);
	}
	
	@Override
	public int updateProductDevDoc(DevDocVO devDocVO) {
		return sqlSessionTemplate.update("productDev.updateProductDevDoc", devDocVO);
	}
	
	@Override
	public List<String> getdNo(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectList("productDev.getdNo", param);
	}
	
	@Override
	public int deleteProductDevDoc(DevDocVO devDocVO) {
		return sqlSessionTemplate.update("productDev.deleteProductDevDoc", devDocVO);
	}
	
	@Override
	public int getProductDevDocLatest(String docNo) {
		return sqlSessionTemplate.selectOne("productDev.getProductDevDocLatest",docNo);
	}
	
	@Override
	public int updateProductDevDocLatest(String docNo) {
		return sqlSessionTemplate.update("productDev.updateProductDevDocLatest",docNo);
	}
	
	@Override
	public String getNextDevDocNo() {
		return sqlSessionTemplate.selectOne("productDev.getNextDevDocNo");
	}

	@Override
	public void loggingDevDoc(DevDocLogVO devDocLogVO) {
		sqlSessionTemplate.insert("productDev.loggingDevDoc", devDocLogVO);
	}

	@Override
	public void saveMfgProcessDoc(MfgProcessDoc doc) {
		sqlSessionTemplate.insert("productDev.saveMfgProcessDoc", doc);
	}

	@Override
	public void saveMfgProcessDocSub(MfgProcessDocSubProd sub) {
		sqlSessionTemplate.insert("productDev.saveMfgProcessDocSub", sub);
	}

	@Override
	public void saveMfgProcessDocMix(MfgProcessDocBase base) {
		sqlSessionTemplate.insert("productDev.saveMfgProcessDocMix", base);
	}
	@Override
	public void saveMfgProcessDocCont(MfgProcessDocBase base) {
		sqlSessionTemplate.insert("productDev.saveMfgProcessDocCont", base);
	}

	@Override
	public int saveMfgProcessDocItem(MfgProcessDocItem item) {
		return sqlSessionTemplate.insert("productDev.saveMfgProcessDocItem", item);
	}

	@Override
	public void saveMfgProcessDocDisp(MfgProcessDocDisp disp) {
		sqlSessionTemplate.insert("productDev.saveMfgProcessDocDisp", disp);
	}
	
	@Override
	public int saveMfgProcessDocProdSpec(MfgProcessDocProdSpec spec) {
		return sqlSessionTemplate.insert("productDev.saveMfgProcessDocProdSpec", spec);
	}
	
	@Override
	public void saveMfgProcessDocProdSpecMD(MfgProcessDocProdSpecMD specMD) {
		sqlSessionTemplate.insert("productDev.saveMfgProcessDocProdSpecMD", specMD);
	}
	
	@Override
	public int saveDesignRequestDoc(DesignRequestDocVO designVO) {
		return sqlSessionTemplate.insert("productDev.saveDesignRequestDoc", designVO);
	}
	
	@Override
	public int saveNutritionLabel(NutritionLabel nutritionLabel) {
		return sqlSessionTemplate.insert("productDev.saveNutritionLabel", nutritionLabel);
	}
	
	@Override
	public int updateNutritionLabel(NutritionLabel nutritionLabel) {
		return sqlSessionTemplate.update("productDev.updateNutritionLabel", nutritionLabel);
	}

	@Override
	public DesignRequestDocVO getDesignRequestDocDetail(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectOne("productDev.getDesignRequestDocDetail", param);
	}
	
	@Override
	public NutritionLabel getNutritionLabel(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectOne("productDev.getNutritionLabel", param);
	}

	@Override
	public MfgProcessDoc getMfgProcessDocDetail(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectOne("productDev.getMfgProcessDocDetail", param);
	}

	@Override
	public List<MfgProcessDocSubProd> getMfgProcessDocSub(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectList("productDev.getMfgProcessDocSub", param);
	}

	@Override
	public List<MfgProcessDocBase> getMfgProcessDocMix(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectList("productDev.getMfgProcessDocMix", param);
	}
	
	@Override
	public List<MfgProcessDocBase> getMfgProcessDocCont(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectList("productDev.getMfgProcessDocCont", param);
	}

	@Override
	public List<MfgProcessDocItem> getMfgProcessDocItem(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectList("productDev.getMfgProcessDocItem", param);
	}
	
	@Override
	public List<MfgProcessDocDisp> getMfgProcessDocDisp(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectList("productDev.getMfgProcessDocDisp", param);
	}
	
	@Override
	public MfgProcessDocProdSpec getMfgProcessDocSpec(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectOne("productDev.getMfgProcessDocSpec", param);
	}
	
	@Override
	public MfgProcessDocProdSpecMD getMfgProcessDocSpecMD(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectOne("productDev.getMfgProcessDocSpecMD", param);
	}

	@Override
	public int deleteMfgProcessDoc(HashMap<String, Object> param) {
		return sqlSessionTemplate.delete("productDev.deleteMfgProcessDoc", param);
	}
	
	@Override
	public int deleteMfgProcessDocSub(HashMap<String, Object> param) {
		return sqlSessionTemplate.delete("productDev.deleteMfgProcessDocSub", param);
	}

	@Override
	public int deleteMfgProcessDocMix(HashMap<String, Object> param) {
		return sqlSessionTemplate.delete("productDev.deleteMfgProcessDocMix", param);
	}

	@Override
	public int deleteMfgProcessDocCont(HashMap<String, Object> param) {
		return sqlSessionTemplate.delete("productDev.deleteMfgProcessDocCont", param);
	}

	@Override
	public int deleteMfgProcessDocItem(HashMap<String, Object> param) {
		return sqlSessionTemplate.delete("productDev.deleteMfgProcessDocItem", param);
	}

	@Override
	public int deleteMfgProcessDocDisp(HashMap<String, Object> param) {
		return sqlSessionTemplate.delete("productDev.deleteMfgProcessDocDisp", param);
	}

	@Override
	public int deleteMfgProcessDocSpec(HashMap<String, Object> param) {
		return sqlSessionTemplate.delete("productDev.deleteMfgProcessDocSpec", param);
	}
	
	@Override
	public int deleteMfgProcessDocSpecMD(HashMap<String, Object> param) {
		return sqlSessionTemplate.delete("productDev.deleteMfgProcessDocSpecMD", param);
	}
	
	@Override
	public int updateManufacturingProcessDoc(HashMap<String, Object> param) {
		return sqlSessionTemplate.update("productDev.updateManufacturingProcessDoc", param);
	}
	
	@Override
	public int updateMfgProcessDoc(MfgProcessDoc doc) {
		return sqlSessionTemplate.update("productDev.updateMfgProcessDoc", doc);
	}
	
	@Override
	public int updateDesignRequestDoc(DesignRequestDocVO designVO) {
		return sqlSessionTemplate.update("productDev.updateDesignRequestDoc", designVO);
	}
	
	@Override
	public int deleteDesignRequestDoc(HashMap<String, Object> param) {
		return sqlSessionTemplate.update("productDev.deleteDesignRequestDoc", param);
	}
	
	@Override
	public int deleteAllDesignRequestDoc(HashMap<String, Object> param) {
		return sqlSessionTemplate.update("productDev.deleteAllDesignRequestDoc", param);
	}

	@Override
	public int updateDevDocCloseState(HashMap<String, Object> param) {		
		return sqlSessionTemplate.update("productDev.updateDevDocCloseState", param);
	}

	@Override
	public int updateDevDocLatestState(HashMap<String, Object> param) {
		return sqlSessionTemplate.update("productDev.updateDevDocLatestState", param);
	}
	
	@Override
	public int versionUpDevDoc(DevDocVO devDocVO) {
		return sqlSessionTemplate.insert("productDev.versionUpDevDoc", devDocVO);
	}
	
	@Override
	public int copyDesignRequestDocList(HashMap<String, Object> param) {
		return sqlSessionTemplate.insert("productDev.copyDesignRequestDocList", param);
	}
	
	@Override
	public int copyDevDocFile(HashMap<String, Object> param) {
		return sqlSessionTemplate.insert("productDev.copyDevDocFile", param);
	}

	@Override
	public int hasAuthority(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("productDev.hasAuthority",param);
	}

	@Override
	public List<Map<String, Object>> detailDdNo(int ddNo) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("productDev.detailDdNo", ddNo);
	}
	
	@Override
	public List<Map<String, Object>> getMfgsummaryList(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectList("productDev.getMfgsummaryList", param);
	}
	
	@Override
	public List<Map<String, Object>> getDevDocSummaryList(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectList("productDev.getDevDocSummaryList", param);
	}
	
	@Override
	public List<String> getDevDocVersion(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectList("productDev.getDevDocVersion", param);
	}
	
	@Override
	public List<Map<String, Object>> getBomHeaderList(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectList("productDev.getBomHeaderList", param);
	}
	
	@Override
	public List<Map<String, Object>> getBomItemList(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectList("productDev.getBomItemList", param);
	}
	
	@Override
	public List<Map<String, Object>> getLatestMaterailOfSapCode(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectList("productDev.getLatestMaterailOfSapCode", param);
	}
	
	@Override
	public List<Map<String, Object>> getLatestMaterailOfImNo(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectList("productDev.getLatestMaterailOfImNo", param);
	}
	
	@Override
	public int countForDevDoc(String regUserId) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("productDev.countForDevDoc",regUserId);
	}

	@Override
	public int countForDesignRequestDoc(String regUserId) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("productDev.countForDesignRequestDoc",regUserId);
	}

	@Override
	public int countForManuFacturingProcessDoc(String regUserId) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("productDev.countForManuFacturingProcessDoc",regUserId);
	}
	
	@Override
	public Map<String, Object> MfgProcessDetail(Map<String,Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("productDev.MfgProcessDetail",param);
	}
	
	@Override
	public List<Map<String, Object>> getDispInfo(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectList("productDev.getDispInfo", param);
	}
	
	@Override
	public int updateDisp(MfgProcessDocDisp disp) {
		return sqlSessionTemplate.update("productDev.updateDisp", disp);
	}

	@Override
	public int updateMfgProcessDocState0(HashMap<String, Object> param) {
		return sqlSessionTemplate.update("productDev.updateMfgProcessDocState0", param);
	}

	@Override
	public int updateDesignRequestDocState0(HashMap<String, Object> param) {
		return sqlSessionTemplate.update("productDev.updateDesignRequestDocState0", param);
	}

	@Override
	public int getBomHeaderNextSeq(Map<String, Object> headerMap) {
		return sqlSessionTemplate.selectOne("productDev.getBomHeaderNextSeq", headerMap);
	}

	@Override
	public int insertBomHeader(Map<String, Object> headerMap) {
		return sqlSessionTemplate.insert("productDev.insertBomHeader", headerMap);
	}

	@Override
	public int updateMgfProcessDocBom(Map<String, Object> headerMap) {
		return sqlSessionTemplate.update("productDev.updateMgfProcessDocBom", headerMap);
	}
	
	@Override
	public int checkDevDocFile(HashMap<String, Object> param) {
		return sqlSessionTemplate.update("productDev.checkDevDocFile", param);
	}
	
	@Override
	public int deleteMfgProcessDocPkgItem(HashMap<String, Object> headerMap) {
		return sqlSessionTemplate.delete("productDev.deleteMfgProcessDocPkgItem", headerMap);
	}
	
	@Override
	public int copyDesignRequestDoc(HashMap<String, Object> param) {
		return sqlSessionTemplate.insert("productDev.copyDesignRequestDoc", param);
	}
	
	@Override
	public int copyNutiritionLabel(HashMap<String, Object> param) {
		return sqlSessionTemplate.insert("productDev.copyNutiritionLabel", param);
	}

	@Override
	public List<Map<String, Object>> searchDevDocLatest(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("productDev.searchDevDocLatest", param);
	}

	@Override
	public void updateProductLaunchDate(Map<String, Object> param) {
		// TODO Auto-generated method stub
		
		sqlSessionTemplate.update("productDev.updateProductLaunchDate",param);
		
	}
	
	@Override
	public List<Map<String,Object>> searchLaunchListByDate(Map<String,Object> param){
		
		return sqlSessionTemplate.selectList("productDev.searchLaunchListByDate", param);
	}
	
	@Override
	public List<String> selectDesignReqDocApprNo(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectList("productDev.selectDesignReqDocApprNo", param);
	}
	
	@Override
	public int updateMfgProcessDocEtc(MfgProcessDoc doc) {
		return sqlSessionTemplate.update("productDev.updateMfgProcessDocEtc", doc);
	}
	
	@Override
	public int copyMfgProcessDocDetail(MfgProcessDoc doc) {
		return sqlSessionTemplate.insert("productDev.copyMfgProcessDocDetail", doc);
	}
	
	@Override
	public int updateQns(Map<String, Object> param) {
		// S201109-00014
		return sqlSessionTemplate.update("productDev.updateQns", param);
	}
	
	@Override
	public Map<String, String> getDocInfo(Map<String, Object> param) {
		return sqlSessionTemplate.selectOne("productDev.getDocInfo", param);
	}
	
	@Override
	public int updateDocProdName(HashMap<String, Object> param) {
		return sqlSessionTemplate.update("productDev.updateDocProdName", param);
	}
	
	@Override
   public List<Map<String, Object>> getCheckBomHeaderList(HashMap<String, Object> param) {
      // TODO Auto-generated method stub
      return sqlSessionTemplate.selectList("productDev.getCheckBomHeaderList", param);
   }
   @Override
   public List<Map<String, Object>> getCheckBomItemList(HashMap<String, Object> param) {
      return sqlSessionTemplate.selectList("productDev.getCheckBomItemList", param);
   }

   @Override
   public int updateDocStopMonth(HashMap<String, Object> param){
	   return sqlSessionTemplate.update("productDev.updateDocStopMonth", param);
   }

	@Override
	public void saveMfgProcessDocStoreMethod(MfgProcessDocStoreMethod mfgProcessDocStoreMethod) {
		sqlSessionTemplate.insert("productDev.saveMfgProcessDocStoreMethod", mfgProcessDocStoreMethod);
	}

	@Override
	public List<MfgProcessDocStoreMethod> getMfgProcessDocStoreMethod(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectList("productDev.getMfgProcessDocStoreMethod", param);
	}

	@Override
	public int deleteMfgProcessDocStoreMethod(HashMap<String, Object> param) {
		return sqlSessionTemplate.delete("productDev.deleteMfgProcessDocStoreMethod", param);
	}
	
	@Override
	public List<ImageFileForStores> getimageFileForStores(String dNo) {
		return sqlSessionTemplate.selectList("productDev.getimageFileForStores",dNo);
	}

	@Override
	public int insertImageFileForStores(ImageFileForStores imageFileForStore) {
		return sqlSessionTemplate.insert("productDev.insertImageFileForStores", imageFileForStore);
	}

	@Override
	public int updateImageFileForStores(ImageFileForStores imageFileForStore) {
		return sqlSessionTemplate.update("productDev.updateImageFileForStores", imageFileForStore);
	}

	@Override
	public int updateImageDescript(ImageFileForStores imageFileForStores) {
		return sqlSessionTemplate.update("productDev.updateImageDescript", imageFileForStores);
	}

	@Override
	public int getimageFileForStoresCnt(String dNo) {
		return sqlSessionTemplate.selectOne("productDev.getimageFileForStoresCnt",dNo);
	}

	@Override
	public List<Map<String, Object>> getCheckBomItemSampleList(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectList("productDev.getCheckBomItemSampleList", param);
	}

}
