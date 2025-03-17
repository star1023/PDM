package kr.co.aspn.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.web.multipart.MultipartFile;

import kr.co.aspn.common.auth.Auth;
import kr.co.aspn.dao.FileDao;
import kr.co.aspn.dao.LabDataDao;
import kr.co.aspn.dao.ProductDesignDao;
import kr.co.aspn.service.ProductDesignService;
import kr.co.aspn.util.FileUtil;
import kr.co.aspn.util.PageNavigator;
import kr.co.aspn.vo.FileVO;
import kr.co.aspn.vo.LabPagingObject;
import kr.co.aspn.vo.LabPagingResult;
import kr.co.aspn.vo.LabSearchVO;
import kr.co.aspn.vo.ProductDesignCreateVO;
import kr.co.aspn.vo.ProductDesignDocDetail;
import kr.co.aspn.vo.ProductDesignDocDetailSub;
import kr.co.aspn.vo.ProductDesignDocVO;

@Service
public class ProductDesignServiceImpl implements ProductDesignService {
	Logger logger = LoggerFactory.getLogger(ProductDesignServiceImpl.class);
	
	@Autowired
	PlatformTransactionManager txManager;
	
	@Autowired
	ProductDesignDao productDesignDao;
	
	@Autowired
	LabDataDao dataDao;
	
	@Autowired
	Properties config;
	
	@Autowired
	FileDao fileDao;
	
	@Override
	public Map<String, Object> getProductDesignDocInfo(String pNo) {
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("pNo", pNo);
		return productDesignDao.getProductDesignDocInfo(param);
	}

	@Override
	public LabPagingResult getProductDesignList(LabPagingObject page, LabSearchVO search) {
		LabPagingResult result = new LabPagingResult();
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("search", search);
		page.setTotalCount(productDesignDao.getProductDesignListCount(param));
		param.put("page", page);
		
		result.setPage(page);
		result.setPagenatedList(productDesignDao.getPagenatedProductDesignList(param));
		
		return result;
	}
	
	@Override
	public LabPagingResult getProductDesignItemList(LabPagingObject page, String pNo) {
		LabPagingResult result = new LabPagingResult();
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("pNo", pNo);
		page.setTotalCount(productDesignDao.getProductDesignDetailListCount(param));
		param.put("page", page);
		
		result.setPage(page);
		result.setPagenatedList(productDesignDao.getPagenatedProductDesignItemList(param));
		
		return result;
	}

	public List<Map<String, Object>> getCodeList(String groupCode) {
		return dataDao.getCodeList(groupCode);
	}

	public List<Map<String, Object>> getPlantList() {
		return dataDao.getPlantList();
	}

	@Override
	public String productDesignSave(ProductDesignCreateVO vo) {
		return productDesignDao.productDesignSave(vo)>0?"1":"0";
	}
	
	@Override
	public String updateProductDesignDoc(ProductDesignCreateVO vo) {
		return productDesignDao.updateProductDesignDoc(vo)>0?"1":"0";
	}
	
	@Override
	public String deleteProductDesignDoc(String pNo) {
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		TransactionStatus status = null;
		
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRES_NEW);
		status = txManager.getTransaction(def);
		
		try {
			HashMap<String, Object> param = new HashMap<String, Object>();
			
			param.put("pNo", pNo);
			
			List<String> pdNoList =  productDesignDao.getProductDesignDocDetailPNoList(param);
			
			for (String pdNo : pdNoList) {
				param.put("pdNo", pdNo);
				
				productDesignDao.deleteProductDesignDocDetail(param);
				productDesignDao.deleteProductDesignDocDetailSub(param);
				productDesignDao.deleteProductDesignDocDetailSubMix(param);
				productDesignDao.deleteProductDesignDocDetailSubMixItem(param);
				productDesignDao.deleteProductDesignDocDetailSubContent(param);
				productDesignDao.deleteProductDesignDocDetailSubContentItem(param);
				productDesignDao.deleteProductDesignDocDetailPackage(param);
			}
			
			int deleteDocCnt = productDesignDao.deleteProductDesignDoc(param);
			
			if(deleteDocCnt > 0){
				txManager.commit(status);
				return "S";
			} else {
				return "F";
			}
		} catch (Exception e) {
			// TODO: handle exception
			txManager.rollback(status);
			return "F";
		}
	}

/*	@Override
	public Map<String, Object> getProductDetail(ProductDeisngDocKeyVO vo) {
		HashMap<String, Object> param = new HashMap<>();
		param.put("pNo", vo.getPNo());
		param.put("pdNo", vo.getPdNo());
		param.put("pdaNo", vo.getPdaNo());
		return productDesignDao.getProductDetail(param);
	}*/

	/*@Override
	public List<Map<String, Object>> getProductDetailTableList(ProductDeisngDocKeyVO vo) {
		HashMap<String, Object> param = new HashMap<>();
		param.put("pNo", vo.getPNo());
		param.put("pdNo", vo.getPdNo());
		param.put("pdaNo", vo.getPdaNo());
		return productDesignDao.getProductDetailTableList(param);
	}*/
	
	/*@Override
	public List<Map<String, Object>> getProductDetailCostList(ProductDeisngDocKeyVO vo){
		HashMap<String, Object> param = new HashMap<>();
		param.put("pNo", vo.getPNo());
		param.put("pdNo", vo.getPdNo());
		param.put("pdaNo", vo.getPdaNo());
		return productDesignDao.getProductDetailCostList(param);
	}*/
	
	@Override
	public List<String> getItemTypeList(String pNo, String pdNo){
		HashMap<String, Object> param = new HashMap();
		param.put("pNo", pNo);
		param.put("pdNo", pdNo);
		return productDesignDao.getItemTypeList(param);
	}

	@Override
	public List<Map<String, Object>> getProductDetailTableList(String pNo, String pdNo, String itemType) {
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("pNo", pNo);
		param.put("pdNo", pdNo);
		param.put("itemType", itemType);
		return productDesignDao.getProductDetailTableList(param);
	}
	
	@Override
	public String saveProductDesignDocDetail(ProductDesignDocDetail vo, MultipartFile imageFile, boolean isNew) {
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		TransactionStatus status = null;
		
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRES_NEW);
		status = txManager.getTransaction(def);
		
		try {
			// isNew true => 신규 설계서 생성, false => 기존 설계서 업데이트
			
			String userId = vo.getRegUserId();
			String pNo = vo.getPNo();
			System.err.println("pNo in saveProductDesignDocDetail : " + pNo);
			String pdNo = vo.getPdNo();
			
			int insertDocCnt = 0;
			int updateDocCnt = 0;
			
			if(isNew){
				pdNo = "0";
				insertDocCnt = productDesignDao.insertProductDesignDocDetail(vo);
				if(insertDocCnt > 0) {
					pdNo = vo.getPdNo();
				}
			} else {
				userId = vo.getModUserId();
				updateDocCnt = productDesignDao.updateProductDesignDocDetail(vo);
				deleteProductDesignDocDetailChild(pNo, pdNo);
			}
			
			
			if(vo != null)
			for (int i = 0; i < vo.getSub().size(); i++) {
				// sub
				vo.getSub().get(i).setRegUserId(userId);
				vo.getSub().get(i).setPNo(pNo);
				vo.getSub().get(i).setPdNo(pdNo);
				String pdsNo = "0";
				if(productDesignDao.insertProductDesignDocDetailSub(vo.getSub().get(i)) > 0){
					pdsNo = String.valueOf(vo.getSub().get(i).getPdsNo());
				}
				
				if(vo.getSub() != null)
				for (int j = 0; j < vo.getSub().get(i).getSubMix().size(); j++) {
					
					vo.getSub().get(i).getSubMix().get(j).setPNo(pNo);
					vo.getSub().get(i).getSubMix().get(j).setPdNo(pdNo);
					vo.getSub().get(i).getSubMix().get(j).setPdsNo(pdsNo);
					vo.getSub().get(i).getSubMix().get(j).setRegUserId(userId);
					String pdsmNo = "0";
					if(productDesignDao.insertProductDesignDocDetailSubMix(vo.getSub().get(i).getSubMix().get(j)) > 0){
						pdsmNo = String.valueOf(vo.getSub().get(i).getSubMix().get(j).getPdsmNo());
					}
					
					if(vo.getSub().get(i).getSubMix() != null)
					for (int k = 0; k < vo.getSub().get(i).getSubMix().get(j).getSubMixItem().size(); k++) {
						//subMixItem
						//productDesignDao.insertProductDesignDocSubMixItem(vo.getSub().get(i).getSubMix().get(j).getSubMixItem().get(k));
						vo.getSub().get(i).getSubMix().get(j).getSubMixItem().get(k).setPNo(pNo);
						vo.getSub().get(i).getSubMix().get(j).getSubMixItem().get(k).setPdNo(pdNo);
						vo.getSub().get(i).getSubMix().get(j).getSubMixItem().get(k).setPdsNo(pdsNo);
						vo.getSub().get(i).getSubMix().get(j).getSubMixItem().get(k).setPdsmNo(pdsmNo);
						vo.getSub().get(i).getSubMix().get(j).getSubMixItem().get(k).setRegUserId(userId);
						
						String pdsmiNo = "0";
						if(productDesignDao.insertProductDesignDocDetailSubMixItem(vo.getSub().get(i).getSubMix().get(j).getSubMixItem().get(k)) > 0){
							pdsmiNo = vo.getSub().get(i).getSubMix().get(j).getSubMixItem().get(k).getPdsmiNo();
						}
					}
				}
				
				
				if(vo.getSub().get(i).getSubContent() != null)
				for (int j = 0; j < vo.getSub().get(i).getSubContent().size(); j++) {
					vo.getSub().get(i).getSubContent().get(j).setPNo(pNo);
					vo.getSub().get(i).getSubContent().get(j).setPdNo(pdNo);
					vo.getSub().get(i).getSubContent().get(j).setPdsNo(pdsNo);
					vo.getSub().get(i).getSubContent().get(j).setRegUserId(userId);
					String pdscNo = "0";
					if(productDesignDao.insertProductDesignDocDetailSubContent(vo.getSub().get(i).getSubContent().get(j)) > 0){
						pdscNo = String.valueOf(vo.getSub().get(i).getSubContent().get(j).getPdscNo());
					}
					
					if(vo.getSub().get(i).getSubContent().get(j).getSubContentItem() != null)
					for (int k = 0; k < vo.getSub().get(i).getSubContent().get(j).getSubContentItem().size(); k++) {
						//getSubContentItem
						vo.getSub().get(i).getSubContent().get(j).getSubContentItem().get(k).setPNo(pNo);
						vo.getSub().get(i).getSubContent().get(j).getSubContentItem().get(k).setPdNo(pdNo);
						vo.getSub().get(i).getSubContent().get(j).getSubContentItem().get(k).setPdsNo(pdsNo);
						vo.getSub().get(i).getSubContent().get(j).getSubContentItem().get(k).setPdscNo(pdscNo);
						vo.getSub().get(i).getSubContent().get(j).getSubContentItem().get(k).setRegUserId(userId);
						
						String pdsciNo = "0";
						if(productDesignDao.insertProductDesignDocDetailSubContentItem(vo.getSub().get(i).getSubContent().get(j).getSubContentItem().get(k)) > 0){
							pdsciNo = vo.getSub().get(i).getSubContent().get(j).getSubContentItem().get(k).getPdsciNo();
						}
						
					}
				}
			}
			
			if(vo.getPkg() != null)
				System.err.println("vo.getPkg() "+vo.getPkg());
			for (int i = 0; i < vo.getPkg().size(); i++) {
				// packageItem
				if ( vo.getPkg().get(i).getItemImNo() != null && !"".equals(vo.getPkg().get(i).getItemImNo()) ) {
					System.err.println("vo.getPkg().get(i) "+vo.getPkg().get(i));
					vo.getPkg().get(i).setRegUserId(userId);
					vo.getPkg().get(i).setPNo(pNo);
					vo.getPkg().get(i).setPdNo(pdNo);
					String pdpNo = "0";
					if(productDesignDao.insertProductDesignDocDetailPackage(vo.getPkg().get(i)) > 0){
						pdpNo = String.valueOf(vo.getPkg().get(i).getPdpNo());
					}
				}
			}
			
			
			if(imageFile != null){
				FileVO fileVO = new FileVO();
				String imagePath = config.getProperty("upload.file.path.images");
				String result = "";
				
				try {
					fileVO.setTbKey(""+pdNo);
					fileVO.setTbType("productDesign");
					fileVO.setOrgFileName(imageFile.getOriginalFilename());
					fileVO.setRegUserId(userId);
					if(!isNew){
						// 파일삭제
						FileVO oldFileVO = fileDao.imageFileInfo(fileVO);
						
						if(oldFileVO != null){
							if(FileUtil.fileDelete(oldFileVO.getFileName(), oldFileVO.getPath())){
								logger.debug("delte file["+oldFileVO.getPath()+"] in saveProductDesignDocDetail()");
								fileDao.deleteImageFile(oldFileVO);
							}
						}
					}
					result = FileUtil.upload3(imageFile, imagePath);
					
					fileVO.setFileName(result);
					fileVO.setPath(imagePath);
					
					fileDao.insertImageFile(fileVO);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			
			if(insertDocCnt > 0 || updateDocCnt > 0){
				txManager.commit(status);
				return "S";
			} else {
				return "F";
			}
		} catch (Exception e) {
			// TODO: handle exception
			txManager.rollback(status);
			return "F";
		}
	}

	@Override
	public ProductDesignDocDetail getProductDesignDocDetail(String pdNo, String plantCode) {
		ProductDesignDocDetail docDetail = productDesignDao.getProductDesignDocDetail(pdNo);
		docDetail.setSub(productDesignDao.getProductDesignDocDetailSub(pdNo));
		for (int i = 0; i < docDetail.getSub().size(); i++) {
			String pdsNo = docDetail.getSub().get(i).getPdsNo();
			docDetail.getSub().get(i).setSubMix(productDesignDao.getProductDesignDocDetailSubMix(pdsNo));
			docDetail.getSub().get(i).setSubContent(productDesignDao.getProductDesignDocDetailSubContent(pdsNo));
			
			for (int j = 0; j < docDetail.getSub().get(i).getSubMix().size(); j++) {
				String pdsmNo = docDetail.getSub().get(i).getSubMix().get(j).getPdsmNo();
				docDetail.getSub().get(i).getSubMix().get(j).setSubMixItem(productDesignDao.getProductDesignDocDetailSubMixItem(pdsmNo,plantCode));
			}
			
			for (int j = 0; j < docDetail.getSub().get(i).getSubContent().size(); j++) {
				String pdscNo = docDetail.getSub().get(i).getSubContent().get(j).getPdscNo();
				docDetail.getSub().get(i).getSubContent().get(j).setSubContentItem(productDesignDao.getProductDesignDocDetailSubContentItem(pdscNo,plantCode));
			}
		} 
		docDetail.setPkg(productDesignDao.getProductDesignDocDetailPackage(pdNo, plantCode));
		docDetail.setCost(productDesignDao.getProductDesignDocDetailCostView(pdNo));
		return docDetail;
	}
	
	private void deleteProductDesignDocDetailChild(String pNo, String pdNo){
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		TransactionStatus status = null;
		
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRES_NEW);
		status = txManager.getTransaction(def);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("pNo", pNo);
		param.put("pdNo", pdNo);
		
		try {
			productDesignDao.deleteProductDesignDocDetailSub(param);
			productDesignDao.deleteProductDesignDocDetailSubMix(param);
			productDesignDao.deleteProductDesignDocDetailSubMixItem(param);
			productDesignDao.deleteProductDesignDocDetailSubContent(param);
			productDesignDao.deleteProductDesignDocDetailSubContentItem(param);
			productDesignDao.deleteProductDesignDocDetailPackage(param);
			
			txManager.commit(status);
		} catch (Exception e) {
			// TODO: handle exception
			txManager.rollback(status);
		}
		
	}
	
	/*@Override
	public void updateProductDeisgnDocDetail(String pNo, String pdNo){
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("pNo", pNo);
		param.put("pdNo", pdNo);
		
		productDesignDao.deleteProductDesignDocDetail(param);
		deleteProductDesignDocDetailChild(pNo, pdNo);
		
		// TODO delete log
	}*/
	
	@Override
	public String copyProductDesignDocDetail(String pNo, String pdNo, String userId) {
		ProductDesignDocDetail detail = getProductDesignDocDetail(pdNo,"");
		detail.setPNo(pNo);
		detail.setRegUserId(userId);
		System.err.println("pNo in copyProductDesignDocDetail : " + pNo);
		return saveProductDesignDocDetail(detail, null, true);
		
		// file 경로 복사
	}

	@Override
	public String deleteProductDesignDocDetail(String pNo, String pdNo) {
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		TransactionStatus status = null;
		
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRES_NEW);
		status = txManager.getTransaction(def);
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("pNo", pNo);
		param.put("pdNo", pdNo);
		
		try {
			int deleteDocCnt = productDesignDao.deleteProductDesignDocDetail(param);
			productDesignDao.deleteProductDesignDocDetailSub(param);
			productDesignDao.deleteProductDesignDocDetailSubMix(param);
			productDesignDao.deleteProductDesignDocDetailSubMixItem(param);
			productDesignDao.deleteProductDesignDocDetailSubContent(param);
			productDesignDao.deleteProductDesignDocDetailSubContentItem(param);
			productDesignDao.deleteProductDesignDocDetailPackage(param);
			
			if(deleteDocCnt > 0){
				txManager.commit(status);
				return "S";
			} else {
				return "F";
			}
		} catch (Exception e) {
			// TODO: handle exception
			txManager.rollback(status);
			return "F";
		}
	}
	
	@Override
	public List<Map<String, Object>> getDesignDocSummaryList(Auth userInfo, String companyCode, String plantCode
			, String productName) {
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("companyCode", companyCode);
		param.put("plantCode", plantCode);
		param.put("productName", productName);
		param.put("userId", userInfo.getUserId());
		param.put("isAdmin", userInfo.getIsAdmin());
		
		return productDesignDao.getDesignDocSummaryList(param);
	}
	
	@Override
	public List<Map<String, Object>> getDesignDocDetailSummaryList(String pNo) {
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("pNo", pNo);
		
		return productDesignDao.getDesignDocDetailSummaryList(param);
	}

	@Override
	public int countForProductDesignDoc(String regUserId) {
		// TODO Auto-generated method stub
		return productDesignDao.countForProductDesignDoc(regUserId);
	}
	
	@Override
	public List<Map<String, Object>> getLatestMaterialList(String[] imNoArr) {
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("imNoArr", imNoArr);
		return productDesignDao.getLatestMaterialList(param);
	}
	
	@Override
	public String txTest(String value) throws Exception {
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		TransactionStatus status = null;
		
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRES_NEW);
		status = txManager.getTransaction(def);
		txManager.rollback(status);
		txManager.commit(status);
		
		dataDao.updateTxTest1(value);
		dataDao.updateTxTest2(value);
		try {
			String a = null;
			a.split(",");
			dataDao.updateTxTest3(value);
		} catch (Exception e) {
			// TODO: handle exception
			//txManager.rollback(status);
			throw e;
		}
		
		//txManager.commit(status);
		return "TEST";
	}
	
	@Override
	public LabPagingResult getPagenatedPopupList(LabPagingObject page, LabSearchVO search) {
		LabPagingResult result = new LabPagingResult();
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("search", search);
		param.put("page", page);
		page.setTotalCount(productDesignDao.getPagenatedPopupListCount(param));
		
		result.setPage(page);
		result.setPagenatedList(productDesignDao.getPagenatedPopupList(param));
		
		return result;
	}
	
	@Override
	public ProductDesignDocVO getProductDesignDoc(String pNo) {
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("pNo", pNo);
		
		return productDesignDao.getProductDesignDoc(param);
	}
	
	@Override
	public Map<String, Object> getProductDesingDocDetailList(Map<String, Object> param) throws Exception {
		String pNo = (String)param.get("pNo");
		System.err.println("\t pNo: " + pNo);
		
		int viewCount = 0;
		try {
			viewCount = Integer.parseInt(param.get("viewCount").toString());
		} catch( Exception e ) {
			viewCount = 10;
		}
		
		int totalCount = productDesignDao.getProductDesignDocDetailListCount(param);
		
		// 페이징: 페이징 정보 SET
		PageNavigator navi = new PageNavigator(param, viewCount, totalCount);
		
		List<Map<String, Object>> detailList = productDesignDao.getProductDesignDocDetailList(param);
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		//map.put("plant", plantList);
		map.put("totalCount", totalCount);
		map.put("list", detailList);
		map.put("navi", navi);
		
		System.err.println("param  :  "+param);
		map.put("paramVO", param);
		
		return map;
	}
}
