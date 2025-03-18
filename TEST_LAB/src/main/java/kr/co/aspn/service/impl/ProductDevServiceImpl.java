package kr.co.aspn.service.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.co.aspn.util.FileUtil;
import kr.co.aspn.util.StringUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import kr.co.aspn.common.auth.Auth;
import kr.co.aspn.common.auth.AuthUtil;
import kr.co.aspn.dao.BomDao;
import kr.co.aspn.dao.FileDao;
import kr.co.aspn.dao.ProductDevDao;
import kr.co.aspn.service.ApprovalService;
import kr.co.aspn.service.CommonService;
import kr.co.aspn.service.ProductDevService;
import kr.co.aspn.service.RecordService;
import kr.co.aspn.service.UserService;
import kr.co.aspn.vo.*;

@Service
@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
public class ProductDevServiceImpl implements ProductDevService{
	Logger logger = LoggerFactory.getLogger(ProductDevServiceImpl.class);
	
	@Autowired
	Properties config;
	
	@Resource
	DataSourceTransactionManager txManager;
	
	@Autowired
	ProductDevDao productDevDao;
	
	@Autowired
	ApprovalService approvalService;
	
	@Autowired
	UserService userService;
	
	@Autowired
	CommonService commonService;
	
	@Autowired
	BomDao bomDao; 
	
	@Autowired
	FileDao fileDao;
	
	@Autowired
	RecordService recordService;

	@Override
	public LabPagingResult getProductDevDocList(LabPagingObject page, LabSearchVO search) {
		LabPagingResult result = new LabPagingResult();
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("search", search);
		page.setTotalCount(productDevDao.getProductDevDocListCount(param));
		param.put("page", page);
		
		result.setPage(page);
		result.setPagenatedList(productDevDao.getProductDevDocList(param));
		
		return result;
	}
	
	@Override
	public ProductDevDocVO getProductDevDoc(String docNo, String docVersion) {
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("docNo", docNo);
		param.put("docVersion", docVersion);
		return productDevDao.getProductDevDoc(param);
	}

	@Override
	public List<ManufacturingProcessDocVO> getManufacturingProcessDocList(String docNo, String docVersion) {
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("docNo", docNo);
		param.put("docVersion", docVersion);
		return productDevDao.getManufacturingProcessDocList(param);
	}

	@Override
	public List<DesignRequestDocVO> getDesignRequestDocList(String docNo, String docVersion) {
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("docNo", docNo);
		param.put("docVersion", docVersion);
		return productDevDao.getDesignRequestDocList(param);
	}
	
	@Override
	public List<ProductDevDocFileVO> getAttatchFile(String docNo, String docVersion) {
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("docNo", docNo);
		param.put("docVersion", docVersion);
		return productDevDao.getAttatchFile(param);
	}

	@Override
	public List<Integer> getProductDevDocVersionList(String docNo) {
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("docNo", docNo);
		return productDevDao.getProductDevDocVersionList(param);
	}

	@Override
	public String saveProductDevDoc(DevDocVO devDocVO) {
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		TransactionStatus status = null;
		
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRES_NEW);
		status = txManager.getTransaction(def);
		
		try {
			String docNo = productDevDao.getNextDevDocNo();
			devDocVO.setDocNo(Integer.parseInt(docNo));
			int insertCnt = productDevDao.saveProductDevDoc(devDocVO);
			if(insertCnt > 0){
				DevDocLogVO logVO = new DevDocLogVO();
				logVO.setDocNo(docNo);
				logVO.setType("C");
				logVO.setDescription("제품개발문서 등록");
				logVO.setUserId(devDocVO.getRegUserId());
				productDevDao.loggingDevDoc(logVO);
				
				
				HashMap<String, Object> historyParam = new HashMap<String, Object>();
				historyParam.put("tbType", "devDoc");
				historyParam.put("tbKey", devDocVO.getDdNo());
				historyParam.put("type", "create");
				historyParam.put("resultFlag", "S");
				historyParam.put("comment", "제품개발문서 등록");
				historyParam.put("regUserId", devDocVO.getRegUserId());
				recordService.insertHistory(historyParam);
				
				txManager.commit(status);
				return docNo;
			} else {
				txManager.rollback(status);
				return null;
			}
		} catch (Exception e) {
			System.err.println(e.getMessage());
			logger.error(e.getMessage());
			txManager.rollback(status);
			return null;
		}
	}
	
	@Override
	public int updateProductDevDoc(DevDocVO devDocVO) {
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		TransactionStatus status = null;
		
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRES_NEW);
		status = txManager.getTransaction(def);
		
		try {
			int deleteCnt = productDevDao.updateProductDevDoc(devDocVO);
			
			HashMap<String, Object> historyParam = new HashMap<String, Object>();
			historyParam.put("tbType", "devDoc");
			historyParam.put("tbKey", devDocVO.getDdNo());
			historyParam.put("type", "update");
			historyParam.put("resultFlag", deleteCnt>0 ? "S" : "F");
			historyParam.put("comment", "제품개발문서 수정");
			historyParam.put("regUserId", devDocVO.getModUserId());
			recordService.insertHistory(historyParam);
			
			txManager.commit(status);
			return deleteCnt;
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage());
			txManager.rollback(status);
			return 0;
		}
	}
	
	@Override
	public int deleteProductDevDoc(DevDocVO devDocVO) {
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		TransactionStatus status = null;
		
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRES_NEW);
		status = txManager.getTransaction(def);
		
		try {
			String docNo = String.valueOf(devDocVO.getDocNo());
			String docVersion = String.valueOf(devDocVO.getDocVersion());
			String deleteLog = " =====  제품개발문서 삭제[docNo="+docNo+", docVersion="+docVersion+"] Log  ===== ";
			
			HashMap<String, Object> param = new HashMap<String, Object>();
			param.put("docNo", docNo);
			param.put("docVersion", docVersion);
			
			List<String> dNoList = productDevDao.getdNo(param);
			System.out.println("dNoList.size() : " + dNoList.size());
			
			
			int deleteCnt = productDevDao.deleteProductDevDoc(devDocVO);
			int latestDocCnt = productDevDao.getProductDevDocLatest(docNo);
			
			if(latestDocCnt <= 0){
				productDevDao.updateProductDevDocLatest(docNo);
			}
			
			if(deleteCnt > 0){
				deleteLog += "\t 제품개발문서 삭제: 성공";
				
				// 결재문서 관련 데이터 삭제
				try {
					//approvalService.deleteApprList(docNo, docVersion);
					deleteLog += "\n\t 결재문서 삭제: 성공";
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
					deleteLog += "\n\t 결재문서 삭제: 실패";
				}
				
				// 제조공정서 삭제
				//String mfgDocDeleteFlag = deleteManufacturingProcessDoc(dNo, false, devDocVO.getModUserId());
				
				boolean isDelete = false;
				for (String dNo : dNoList) {
					HashMap<String, Object> deleteParam = new HashMap<String, Object>();
					deleteParam.put("dNo", dNo);
					int docDelCnt = productDevDao.deleteMfgProcessDoc(deleteParam);
					int docSubDelCnt = productDevDao.deleteMfgProcessDocSub(deleteParam);
					int docMixDelCnt = productDevDao.deleteMfgProcessDocMix(deleteParam);
					int docContDelCnt = productDevDao.deleteMfgProcessDocCont(deleteParam);
					int docItemDelCnt = productDevDao.deleteMfgProcessDocItem(deleteParam); // mixItem, contItem, pkg, cons
					int docDispDelCnt = productDevDao.deleteMfgProcessDocDisp(deleteParam);
					int docSpecDelCnt = productDevDao.deleteMfgProcessDocSpec(deleteParam);
					
					logger.info("docDelCnt: " + docDelCnt 
						+"\n docSubDelCnt: " + docSubDelCnt
						+"\n docMixDelCnt: " + docMixDelCnt
						+"\n docContDelCnt: " + docContDelCnt
						+"\n docItemDelCnt: " + docItemDelCnt
						+"\n docDispDelCnt: " + docDispDelCnt
						+"\n docSpecDelCnt: " + docSpecDelCnt
					);
					
					if(docDelCnt > 0 ) {
						isDelete = true; 
					}
				}
				
				if(isDelete)
					deleteLog += "\n\t 제조공정서 삭제: 성공";
				else 
					deleteLog += "\n\t 제조공정서 삭제: 실패";
				
				// 디자인의뢰서 삭제
				String designReqDocDeleteFlag = deleteAllDesignRequestDoc(docNo, docVersion, devDocVO.getModUserId()) > 0 ? "S" : "F";
				if(designReqDocDeleteFlag.equals("S"))
					deleteLog += "\n\t 디자인의뢰서 삭제: 성공";
				else
					deleteLog += "\n\t 디자인의뢰서 삭제: 실패";
				
				
				List<DevDocFileVO> fileList = fileDao.getDevDocFileList(param);
				int fileDeletCnt = fileDao.deleteDevDocList(param);
			} else {
				deleteLog += "\n\t 제품개발문서 삭제: 실패";
			}
			
			logger.debug(deleteLog);
			//System.out.println(deleteLog);
			
			HashMap<String, Object> historyParam = new HashMap<String, Object>();
			historyParam.put("tbType", "devDoc");
			historyParam.put("tbKey", devDocVO.getDdNo());
			historyParam.put("type", "delete");
			historyParam.put("resultFlag", deleteCnt>0 ? "S" : "F");
			historyParam.put("comment", "제품개발문서 삭제");
			historyParam.put("regUserId", devDocVO.getModUserId());
			recordService.insertHistory(historyParam);
			
			txManager.commit(status);
			return deleteCnt;
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage());
			txManager.rollback(status);
			return 0;
		}
	}
	
	@Override
	public String saveManufacturingProcessDoc(MfgProcessDoc mfgProcessDoc, boolean isUpdate) {
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		TransactionStatus status = null;
		
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRES_NEW);
		status = txManager.getTransaction(def);
		
		try {
			if(isUpdate){
				logger.debug("============================ UPDATE " + isUpdate);
				productDevDao.updateMfgProcessDoc(mfgProcessDoc);
				//deleteManufacturingProcessDoc(mfgProcessDoc.getDNo(), isUpdate, mfgProcessDoc.getModUserId());
				
				HashMap<String, Object> param = new HashMap<String, Object>();
				param.put("dNo", mfgProcessDoc.getDNo());
				
				int docSubDelCnt = productDevDao.deleteMfgProcessDocSub(param);
				int docMixDelCnt = productDevDao.deleteMfgProcessDocMix(param);
				int docContDelCnt = productDevDao.deleteMfgProcessDocCont(param);
				int docItemDelCnt = productDevDao.deleteMfgProcessDocItem(param); // mixItem, contItem, pkg, cons
				int docDispDelCnt = productDevDao.deleteMfgProcessDocDisp(param);
				int docSpecDelCnt = productDevDao.deleteMfgProcessDocSpec(param);
				int docSpecMDDelCnt = productDevDao.deleteMfgProcessDocSpecMD(param);
				int docStoreMethodDelCnt = productDevDao.deleteMfgProcessDocStoreMethod(param);
				
				logger.info("docSubDelCnt: " + docSubDelCnt
					+"\n docMixDelCnt: " + docMixDelCnt
					+"\n docContDelCnt: " + docContDelCnt
					+"\n docItemDelCnt: " + docItemDelCnt
					+"\n docDispDelCnt: " + docDispDelCnt
					+"\n docSpecDelCnt: " + docSpecDelCnt
					+"\n docSpecMDDelCnt: " + docSpecMDDelCnt
					+"\n docStoreMethodDelCnt: " + docStoreMethodDelCnt
				);

//				불필요한 로그 제거
//				HashMap<String, Object> historyParam = new HashMap<>();
//				historyParam.put("tbType", "manufacturingProcessDoc");
//				historyParam.put("tbKey", mfgProcessDoc.getDNo());
//				historyParam.put("type", "delete");
//				historyParam.put("resultFlag", "S");
//				historyParam.put("comment", "제조공정서 삭제");
//				historyParam.put("regUserId", mfgProcessDoc.getModUserId());
//				recordService.insertHistory(historyParam);
//				
			} else {
				logger.debug("============================ INSERT : " + isUpdate);
				productDevDao.saveMfgProcessDoc(mfgProcessDoc);
			}
			
			List<MfgProcessDocSubProd> subProd = mfgProcessDoc.getSub();
			for (MfgProcessDocSubProd mfgProcessDocSubProd : subProd) {
				mfgProcessDocSubProd.setDocNo(mfgProcessDoc.getDocNo());
				mfgProcessDocSubProd.setDocVersion(mfgProcessDoc.getDocVersion());
				mfgProcessDocSubProd.setDNo(mfgProcessDoc.getDNo());
				mfgProcessDocSubProd.setRegUserId(mfgProcessDoc.getRegUserId());
				mfgProcessDocSubProd.setModUserId(mfgProcessDoc.getModUserId());
				// insert subProduct
				productDevDao.saveMfgProcessDocSub(mfgProcessDocSubProd);
				
				List<MfgProcessDocBase> mix = mfgProcessDocSubProd.getMix();
				if(mix != null)
				for (MfgProcessDocBase mfgProcessDocMix : mix) {
					mfgProcessDocMix.setDocNo(mfgProcessDoc.getDocNo());
					mfgProcessDocMix.setDocVersion(mfgProcessDoc.getDocVersion());
					mfgProcessDocMix.setDNo(mfgProcessDoc.getDNo());
					mfgProcessDocMix.setRegUserId(mfgProcessDoc.getRegUserId());
					mfgProcessDocMix.setModUserId(mfgProcessDoc.getModUserId());
					mfgProcessDocMix.setParCode(mfgProcessDocSubProd.getDsNo());
					
					// insert mix
					productDevDao.saveMfgProcessDocMix(mfgProcessDocMix);
					List<MfgProcessDocItem> item = mfgProcessDocMix.getItem();
					if(item != null)
					for (MfgProcessDocItem mfgProcessDocItem : item) {
						mfgProcessDocItem.setDocNo(mfgProcessDoc.getDocNo());
						mfgProcessDocItem.setDocVersion(mfgProcessDoc.getDocVersion());
						mfgProcessDocItem.setDNo(mfgProcessDoc.getDNo());
						mfgProcessDocItem.setRegUserId(mfgProcessDoc.getRegUserId());
						mfgProcessDocItem.setModUserId(mfgProcessDoc.getModUserId());
						mfgProcessDocItem.setParCode(mfgProcessDocMix.getDmNo());
						mfgProcessDocItem.setItemType("MI");
						mfgProcessDocItem.setParCode(mfgProcessDocMix.getDmNo());
						
						// insert item
						productDevDao.saveMfgProcessDocItem(mfgProcessDocItem);
					}
				}
				
				if(mfgProcessDocSubProd.getCont() != null) {
					List<MfgProcessDocBase> cont = mfgProcessDocSubProd.getCont();
					if(cont != null)
					for (MfgProcessDocBase mfgProcessDocCont : cont) {
						mfgProcessDocCont.setDocNo(mfgProcessDoc.getDocNo());
						mfgProcessDocCont.setDocVersion(mfgProcessDoc.getDocVersion());
						mfgProcessDocCont.setDNo(mfgProcessDoc.getDNo());
						mfgProcessDocCont.setRegUserId(mfgProcessDoc.getRegUserId());
						mfgProcessDocCont.setModUserId(mfgProcessDoc.getModUserId());
						mfgProcessDocCont.setParCode(mfgProcessDocSubProd.getDsNo());
						
						productDevDao.saveMfgProcessDocCont(mfgProcessDocCont);
						
						List<MfgProcessDocItem> item = mfgProcessDocCont.getItem();
						if(item != null)
						for (MfgProcessDocItem mfgProcessDocItem : item) {
							mfgProcessDocItem.setDocNo(mfgProcessDoc.getDocNo());
							mfgProcessDocItem.setDocVersion(mfgProcessDoc.getDocVersion());
							mfgProcessDocItem.setDNo(mfgProcessDoc.getDNo());
							mfgProcessDocItem.setRegUserId(mfgProcessDoc.getRegUserId());
							mfgProcessDocItem.setModUserId(mfgProcessDoc.getModUserId());
							mfgProcessDocItem.setParCode(mfgProcessDocCont.getDcNo());
							mfgProcessDocItem.setItemType("CI");
							mfgProcessDocItem.setParCode(mfgProcessDocCont.getDcNo());
							
							//insert item
							productDevDao.saveMfgProcessDocItem(mfgProcessDocItem);
						}
					}
				}
			}
			
			
			if(mfgProcessDoc.getPkg() != null){
				List<MfgProcessDocItem> pkgList = mfgProcessDoc.getPkg();
				if(pkgList != null)
				for (MfgProcessDocItem mfgProcessDocItem : pkgList) {
					mfgProcessDocItem.setDocNo(mfgProcessDoc.getDocNo());
					mfgProcessDocItem.setDocVersion(mfgProcessDoc.getDocVersion());
					mfgProcessDocItem.setDNo(mfgProcessDoc.getDNo());
					mfgProcessDocItem.setRegUserId(mfgProcessDoc.getRegUserId());
					mfgProcessDocItem.setModUserId(mfgProcessDoc.getModUserId());
					mfgProcessDocItem.setItemType("MT");
					
					productDevDao.saveMfgProcessDocItem(mfgProcessDocItem);
				}
			}
			
			if(mfgProcessDoc.getDisp() != null){
				List<MfgProcessDocDisp> dispList = mfgProcessDoc.getDisp();
				if(dispList != null)
				for (MfgProcessDocDisp mfgProcessDocDisp : dispList) {
					mfgProcessDocDisp.setDocNo(mfgProcessDoc.getDocNo());
					mfgProcessDocDisp.setDocVersion(mfgProcessDoc.getDocVersion());
					mfgProcessDocDisp.setDNo(mfgProcessDoc.getDNo());
					mfgProcessDocDisp.setRegUserId(mfgProcessDoc.getRegUserId());
					mfgProcessDocDisp.setModUserId(mfgProcessDoc.getModUserId());
					
					productDevDao.saveMfgProcessDocDisp(mfgProcessDocDisp);
				}
			}
			
			if(mfgProcessDoc.getCons() != null){
				List<MfgProcessDocItem> consList = mfgProcessDoc.getCons();
				if(consList != null)
				for (MfgProcessDocItem mfgProcessDocItem : consList) {
					mfgProcessDocItem.setDocNo(mfgProcessDoc.getDocNo());
					mfgProcessDocItem.setDocVersion(mfgProcessDoc.getDocVersion());
					mfgProcessDocItem.setDNo(mfgProcessDoc.getDNo());
					mfgProcessDocItem.setRegUserId(mfgProcessDoc.getRegUserId());
					mfgProcessDocItem.setModUserId(mfgProcessDoc.getModUserId());
					mfgProcessDocItem.setItemType("CS");
					
					productDevDao.saveMfgProcessDocItem(mfgProcessDocItem);
				}
			}
			
			if(mfgProcessDoc.getSpec() != null){
				MfgProcessDocProdSpec spec = mfgProcessDoc.getSpec();
				spec.setDocNo(mfgProcessDoc.getDocNo());
				spec.setDocVersion(mfgProcessDoc.getDocVersion());
				spec.setDNo(mfgProcessDoc.getDNo());
				spec.setRegUserId(mfgProcessDoc.getRegUserId());
				spec.setModUserId(mfgProcessDoc.getModUserId());
				
				productDevDao.saveMfgProcessDocProdSpec(spec);
			}
			
			if(mfgProcessDoc.getSpecMD() != null){
				MfgProcessDocProdSpecMD specMD = mfgProcessDoc.getSpecMD();
				specMD.setDocNo(mfgProcessDoc.getDocNo());
				specMD.setDocVersion(mfgProcessDoc.getDocVersion());
				specMD.setDNo(mfgProcessDoc.getDNo());
				specMD.setRegUserId(mfgProcessDoc.getRegUserId());
				specMD.setModUserId(mfgProcessDoc.getModUserId());
				
				productDevDao.saveMfgProcessDocProdSpecMD(specMD);
			}
			
			if(mfgProcessDoc.getStoreMethod() != null){
				List<MfgProcessDocStoreMethod> storeMethodList = mfgProcessDoc.getStoreMethod();
				if(storeMethodList != null)
				for(MfgProcessDocStoreMethod mfgProcessDocStoreMethod : storeMethodList){
					mfgProcessDocStoreMethod.setDocNo(mfgProcessDoc.getDocNo());
					mfgProcessDocStoreMethod.setDocVersion(mfgProcessDoc.getDocVersion());
					mfgProcessDocStoreMethod.setDNo(mfgProcessDoc.getDNo());
					mfgProcessDocStoreMethod.setRegUserId(mfgProcessDoc.getRegUserId());
					mfgProcessDocStoreMethod.setModUserId(mfgProcessDoc.getModUserId());
					
					productDevDao.saveMfgProcessDocStoreMethod(mfgProcessDocStoreMethod);
				}
			}
					
			DevDocLogVO logVO = new DevDocLogVO();
			logVO.setDNo(mfgProcessDoc.getDNo());
			logVO.setDocNo(mfgProcessDoc.getDocNo());
			logVO.setDocNo(mfgProcessDoc.getDocVersion());
			logVO.setType("C");
			logVO.setDescription("제조공정서 등록");
			logVO.setUserId(mfgProcessDoc.getRegUserId());
			productDevDao.loggingDevDoc(logVO);
			
			System.err.println(mfgProcessDoc.getRegUserId() + ", " + mfgProcessDoc.getModUserId());
			if(!mfgProcessDoc.getRegUserId().equals(mfgProcessDoc.getModUserId())){
				// 글작성자에게 수정 알림
				HashMap<String, Object> param = new HashMap<String, Object>();
				param.put("targetUserId", mfgProcessDoc.getRegUserId());
				param.put("message", "제조공정서["+mfgProcessDoc.getDNo()+"(문서번호:"+mfgProcessDoc.getDocNo()+")]가 수정되었습니다");
				param.put("regUserId", mfgProcessDoc.getModUserId());
				param.put("isRead", "N");
				param.put("type", "02");
				param.put("typeText", "제조공정서 수정");
				commonService.insertNotification(param);
			}
			
			String historyUserID = mfgProcessDoc.getModUserId();
			if(mfgProcessDoc.getModUserId().equals("")){
				historyUserID = mfgProcessDoc.getRegUserId();
			}
			HashMap<String, Object> historyParam = new HashMap<String, Object>();
			historyParam.put("tbType", "manufacturingProcessDoc");
			historyParam.put("tbKey", mfgProcessDoc.getDNo());
			historyParam.put("type", isUpdate ? "update" : "create");
			historyParam.put("resultFlag", "S");
			historyParam.put("comment", isUpdate ? "제조공정서 수정" : "제조공정서 생성");
			historyParam.put("regUserId", historyUserID);
			recordService.insertHistory(historyParam);
			
			txManager.commit(status);
			return "S";
		} catch (Exception e) {
			System.err.println(e.getMessage());
			logger.error(e.getMessage());
			logger.debug("===== ERROR : 제조공정서 저장/수정 작업 오류");
			
			e.printStackTrace();
			txManager.rollback(status);
			return "F";
		}
	}
	
	/**
	 * 점포용 제조공정서용 등록 수정
	 * 24.03.26
	 * */
	@Override
	public String saveManufacturingProcessDocStores(MfgProcessDoc mfgProcessDoc, boolean isUpdate, MultipartFile[] files, String[] gubuns) {
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		TransactionStatus status = null;
		
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRES_NEW);
		status = txManager.getTransaction(def);
		
		try {
			if(isUpdate){
				logger.debug("============================ UPDATE " + isUpdate);
				productDevDao.updateMfgProcessDoc(mfgProcessDoc);
				//deleteManufacturingProcessDoc(mfgProcessDoc.getDNo(), isUpdate, mfgProcessDoc.getModUserId());
				
				HashMap<String, Object> param = new HashMap<String, Object>();
				param.put("dNo", mfgProcessDoc.getDNo());
				
				int docSubDelCnt = productDevDao.deleteMfgProcessDocSub(param);
				int docMixDelCnt = productDevDao.deleteMfgProcessDocMix(param);
				int docContDelCnt = productDevDao.deleteMfgProcessDocCont(param);
				int docItemDelCnt = productDevDao.deleteMfgProcessDocItem(param); // mixItem, contItem, pkg, cons
				int docDispDelCnt = productDevDao.deleteMfgProcessDocDisp(param);
				int docSpecDelCnt = productDevDao.deleteMfgProcessDocSpec(param);
				int docSpecMDDelCnt = productDevDao.deleteMfgProcessDocSpecMD(param);
				int docStoreMethodDelCnt = productDevDao.deleteMfgProcessDocStoreMethod(param);
				
				logger.info("docSubDelCnt: " + docSubDelCnt
					+"\n docMixDelCnt: " + docMixDelCnt
					+"\n docContDelCnt: " + docContDelCnt
					+"\n docItemDelCnt: " + docItemDelCnt
					+"\n docDispDelCnt: " + docDispDelCnt
					+"\n docSpecDelCnt: " + docSpecDelCnt
					+"\n docSpecMDDelCnt: " + docSpecMDDelCnt
					+"\n docStoreMethodDelCnt: " + docStoreMethodDelCnt
				);

//				불필요한 로그 제거
//				HashMap<String, Object> historyParam = new HashMap<>();
//				historyParam.put("tbType", "manufacturingProcessDoc");
//				historyParam.put("tbKey", mfgProcessDoc.getDNo());
//				historyParam.put("type", "delete");
//				historyParam.put("resultFlag", "S");
//				historyParam.put("comment", "제조공정서 삭제");
//				historyParam.put("regUserId", mfgProcessDoc.getModUserId());
//				recordService.insertHistory(historyParam);
//				
			} else {
				logger.debug("============================ INSERT : " + isUpdate);
				productDevDao.saveMfgProcessDoc(mfgProcessDoc);
			}
			
			List<MfgProcessDocSubProd> subProd = mfgProcessDoc.getSub();
			for (MfgProcessDocSubProd mfgProcessDocSubProd : subProd) {
				mfgProcessDocSubProd.setDocNo(mfgProcessDoc.getDocNo());
				mfgProcessDocSubProd.setDocVersion(mfgProcessDoc.getDocVersion());
				mfgProcessDocSubProd.setDNo(mfgProcessDoc.getDNo());
				mfgProcessDocSubProd.setRegUserId(mfgProcessDoc.getRegUserId());
				mfgProcessDocSubProd.setModUserId(mfgProcessDoc.getModUserId());
				// insert subProduct
				productDevDao.saveMfgProcessDocSub(mfgProcessDocSubProd);
				
				List<MfgProcessDocBase> mix = mfgProcessDocSubProd.getMix();
				if(mix != null)
				for (MfgProcessDocBase mfgProcessDocMix : mix) {
					mfgProcessDocMix.setDocNo(mfgProcessDoc.getDocNo());
					mfgProcessDocMix.setDocVersion(mfgProcessDoc.getDocVersion());
					mfgProcessDocMix.setDNo(mfgProcessDoc.getDNo());
					mfgProcessDocMix.setRegUserId(mfgProcessDoc.getRegUserId());
					mfgProcessDocMix.setModUserId(mfgProcessDoc.getModUserId());
					mfgProcessDocMix.setParCode(mfgProcessDocSubProd.getDsNo());
					
					// insert mix
					productDevDao.saveMfgProcessDocMix(mfgProcessDocMix);
					List<MfgProcessDocItem> item = mfgProcessDocMix.getItem();
					if(item != null)
					for (MfgProcessDocItem mfgProcessDocItem : item) {
						mfgProcessDocItem.setDocNo(mfgProcessDoc.getDocNo());
						mfgProcessDocItem.setDocVersion(mfgProcessDoc.getDocVersion());
						mfgProcessDocItem.setDNo(mfgProcessDoc.getDNo());
						mfgProcessDocItem.setRegUserId(mfgProcessDoc.getRegUserId());
						mfgProcessDocItem.setModUserId(mfgProcessDoc.getModUserId());
						mfgProcessDocItem.setParCode(mfgProcessDocMix.getDmNo());
						mfgProcessDocItem.setItemType("MI");
						mfgProcessDocItem.setParCode(mfgProcessDocMix.getDmNo());
						
						// insert item
						productDevDao.saveMfgProcessDocItem(mfgProcessDocItem);
					}
				}
				
				if(mfgProcessDocSubProd.getCont() != null) {
					List<MfgProcessDocBase> cont = mfgProcessDocSubProd.getCont();
					if(cont != null)
					for (MfgProcessDocBase mfgProcessDocCont : cont) {
						mfgProcessDocCont.setDocNo(mfgProcessDoc.getDocNo());
						mfgProcessDocCont.setDocVersion(mfgProcessDoc.getDocVersion());
						mfgProcessDocCont.setDNo(mfgProcessDoc.getDNo());
						mfgProcessDocCont.setRegUserId(mfgProcessDoc.getRegUserId());
						mfgProcessDocCont.setModUserId(mfgProcessDoc.getModUserId());
						mfgProcessDocCont.setParCode(mfgProcessDocSubProd.getDsNo());
						
						productDevDao.saveMfgProcessDocCont(mfgProcessDocCont);
						
						List<MfgProcessDocItem> item = mfgProcessDocCont.getItem();
						if(item != null)
						for (MfgProcessDocItem mfgProcessDocItem : item) {
							mfgProcessDocItem.setDocNo(mfgProcessDoc.getDocNo());
							mfgProcessDocItem.setDocVersion(mfgProcessDoc.getDocVersion());
							mfgProcessDocItem.setDNo(mfgProcessDoc.getDNo());
							mfgProcessDocItem.setRegUserId(mfgProcessDoc.getRegUserId());
							mfgProcessDocItem.setModUserId(mfgProcessDoc.getModUserId());
							mfgProcessDocItem.setParCode(mfgProcessDocCont.getDcNo());
							mfgProcessDocItem.setItemType("CI");
							mfgProcessDocItem.setParCode(mfgProcessDocCont.getDcNo());
							
							//insert item
							productDevDao.saveMfgProcessDocItem(mfgProcessDocItem);
						}
					}
				}
			}
			
			
			if(mfgProcessDoc.getPkg() != null){
				List<MfgProcessDocItem> pkgList = mfgProcessDoc.getPkg();
				if(pkgList != null)
				for (MfgProcessDocItem mfgProcessDocItem : pkgList) {
					mfgProcessDocItem.setDocNo(mfgProcessDoc.getDocNo());
					mfgProcessDocItem.setDocVersion(mfgProcessDoc.getDocVersion());
					mfgProcessDocItem.setDNo(mfgProcessDoc.getDNo());
					mfgProcessDocItem.setRegUserId(mfgProcessDoc.getRegUserId());
					mfgProcessDocItem.setModUserId(mfgProcessDoc.getModUserId());
					mfgProcessDocItem.setItemType("MT");
					
					productDevDao.saveMfgProcessDocItem(mfgProcessDocItem);
				}
			}
			
			if(mfgProcessDoc.getDisp() != null){
				List<MfgProcessDocDisp> dispList = mfgProcessDoc.getDisp();
				if(dispList != null)
				for (MfgProcessDocDisp mfgProcessDocDisp : dispList) {
					mfgProcessDocDisp.setDocNo(mfgProcessDoc.getDocNo());
					mfgProcessDocDisp.setDocVersion(mfgProcessDoc.getDocVersion());
					mfgProcessDocDisp.setDNo(mfgProcessDoc.getDNo());
					mfgProcessDocDisp.setRegUserId(mfgProcessDoc.getRegUserId());
					mfgProcessDocDisp.setModUserId(mfgProcessDoc.getModUserId());
					
					productDevDao.saveMfgProcessDocDisp(mfgProcessDocDisp);
				}
			}
			
			if(mfgProcessDoc.getCons() != null){
				List<MfgProcessDocItem> consList = mfgProcessDoc.getCons();
				if(consList != null)
				for (MfgProcessDocItem mfgProcessDocItem : consList) {
					mfgProcessDocItem.setDocNo(mfgProcessDoc.getDocNo());
					mfgProcessDocItem.setDocVersion(mfgProcessDoc.getDocVersion());
					mfgProcessDocItem.setDNo(mfgProcessDoc.getDNo());
					mfgProcessDocItem.setRegUserId(mfgProcessDoc.getRegUserId());
					mfgProcessDocItem.setModUserId(mfgProcessDoc.getModUserId());
					mfgProcessDocItem.setItemType("CS");
					
					productDevDao.saveMfgProcessDocItem(mfgProcessDocItem);
				}
			}
			
			if(mfgProcessDoc.getSpec() != null){
				MfgProcessDocProdSpec spec = mfgProcessDoc.getSpec();
				spec.setDocNo(mfgProcessDoc.getDocNo());
				spec.setDocVersion(mfgProcessDoc.getDocVersion());
				spec.setDNo(mfgProcessDoc.getDNo());
				spec.setRegUserId(mfgProcessDoc.getRegUserId());
				spec.setModUserId(mfgProcessDoc.getModUserId());
				
				productDevDao.saveMfgProcessDocProdSpec(spec);
			}
			
			if(mfgProcessDoc.getSpecMD() != null){
				MfgProcessDocProdSpecMD specMD = mfgProcessDoc.getSpecMD();
				specMD.setDocNo(mfgProcessDoc.getDocNo());
				specMD.setDocVersion(mfgProcessDoc.getDocVersion());
				specMD.setDNo(mfgProcessDoc.getDNo());
				specMD.setRegUserId(mfgProcessDoc.getRegUserId());
				specMD.setModUserId(mfgProcessDoc.getModUserId());
				
				productDevDao.saveMfgProcessDocProdSpecMD(specMD);
			}
			
			if(mfgProcessDoc.getStoreMethod() != null){
				List<MfgProcessDocStoreMethod> storeMethodList = mfgProcessDoc.getStoreMethod();
				if(storeMethodList != null)
				for(MfgProcessDocStoreMethod mfgProcessDocStoreMethod : storeMethodList){
					mfgProcessDocStoreMethod.setDocNo(mfgProcessDoc.getDocNo());
					mfgProcessDocStoreMethod.setDocVersion(mfgProcessDoc.getDocVersion());
					mfgProcessDocStoreMethod.setDNo(mfgProcessDoc.getDNo());
					mfgProcessDocStoreMethod.setRegUserId(mfgProcessDoc.getRegUserId());
					mfgProcessDocStoreMethod.setModUserId(mfgProcessDoc.getModUserId());
					
					productDevDao.saveMfgProcessDocStoreMethod(mfgProcessDocStoreMethod);
				}
			}
			
			
			// 제조순서 이미지
			if (files != null && gubuns != null && files.length == gubuns.length) {
				logger.debug("files : {}",files.length);
				
				// 날짜 설정
				Calendar cal = Calendar.getInstance();
		        Date day = cal.getTime();    //시간을 꺼낸다.
		        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
		        String toDay = sdf.format(day);
				
		        // 경로 설정
		        String path = "";
		        path = config.getProperty("upload.file.path.devdoc")+"/"+toDay;
		        
		        // 등록자
				String userId = mfgProcessDoc.getRegUserId();
				
				// 제조공정서번호
				String tbKey = mfgProcessDoc.getDNo();
		        
		        int i = 0;
		        for( MultipartFile multipartFile : files ) {
		             String gubun = gubuns[i];
		             i++;
		             
		             // 점포용제조공정서 이미지 세팅
		             ImageFileForStores imageFileForStore = new ImageFileForStores();
		            
		             imageFileForStore.setTbKey(""+tbKey); 									// 제조공정서 번호
		             imageFileForStore.setTbType("manufacturingProcessDocForStores");		// 점포용 제조공정서 탭key
		             imageFileForStore.setOrgFileName(multipartFile.getOriginalFilename()); // 이미지 실제 이름
		             imageFileForStore.setGubun(gubun);										// 이미지 구분 값
		             imageFileForStore.setRegUserId(userId);								// 등록자(제조공정서 등록자)
		             imageFileForStore.setIsDelete("N");									// delete N
		             
		             // 파일경로에 이미지 저장
		             String uploadFileName = FileUtil.upload(multipartFile, path);
		             
		             imageFileForStore.setFileName(uploadFileName);							// 이미지 저장 이름
		             imageFileForStore.setPath(path);										// 이미지 저장경로
		             
		             // -- 로그 --
		             logger.debug("=================================");
		             logger.debug("isEmpty : {}", multipartFile.isEmpty());
		             logger.debug("name : {}", multipartFile.getName());
		             logger.debug("originalFilename : {}", multipartFile.getOriginalFilename());
		             logger.debug("uploadFileName : {}", uploadFileName);
		             logger.debug("gubun : {}", gubun);
		             logger.debug("size : {}", multipartFile.getSize());
		             logger.debug("++ path : " + path);
		             logger.debug("=================================");
		             
		             //DB에 기존 등록된 이미지 조회
		             List<ImageFileForStores> imageFileForStoresList = productDevDao.getimageFileForStores(StringUtil.nvl(imageFileForStore.getTbKey()));
		             boolean isInsert = true; //이미지 등록 여부

		             for(ImageFileForStores reportFile : imageFileForStoresList){
		            	//등록 이미지(imageFileForStore)과  기존 이미지(reportFile)의 구분(GUBUN값 비교)
		             	if(reportFile.getGubun().equals(imageFileForStore.getGubun())){ 		
		             		isInsert = false;
		             		imageFileForStore.setFNo(reportFile.getFNo());
		             		FileUtil.fileDelete(reportFile.getFileName(),reportFile.getPath());	//실제 경로의 이미지 삭제
		             	}
		             }
		             if(isInsert){
		             	productDevDao.insertImageFileForStores(imageFileForStore);
		             }else{
		             	productDevDao.updateImageFileForStores(imageFileForStore);
		             }
		        }
			}

			
			DevDocLogVO logVO = new DevDocLogVO();
			logVO.setDNo(mfgProcessDoc.getDNo());
			logVO.setDocNo(mfgProcessDoc.getDocNo());
			logVO.setDocNo(mfgProcessDoc.getDocVersion());
			logVO.setType("C");
			logVO.setDescription("제조공정서 등록");
			logVO.setUserId(mfgProcessDoc.getRegUserId());
			productDevDao.loggingDevDoc(logVO);

			
			System.err.println(mfgProcessDoc.getRegUserId() + ", " + mfgProcessDoc.getModUserId());
			if(!mfgProcessDoc.getRegUserId().equals(mfgProcessDoc.getModUserId())){
				// 글작성자에게 수정 알림
				HashMap<String, Object> param = new HashMap<String, Object>();
				param.put("targetUserId", mfgProcessDoc.getRegUserId());
				param.put("message", "제조공정서["+mfgProcessDoc.getDNo()+"(문서번호:"+mfgProcessDoc.getDocNo()+")]가 수정되었습니다");
				param.put("regUserId", mfgProcessDoc.getModUserId());
				param.put("isRead", "N");
				param.put("type", "02");
				param.put("typeText", "제조공정서 수정");
				commonService.insertNotification(param);
			}
			
			String historyUserID = mfgProcessDoc.getModUserId();
			if(mfgProcessDoc.getModUserId().equals("")){
				historyUserID = mfgProcessDoc.getRegUserId();
			}
			HashMap<String, Object> historyParam = new HashMap<String, Object>();
			historyParam.put("tbType", "manufacturingProcessDoc");
			historyParam.put("tbKey", mfgProcessDoc.getDNo());
			historyParam.put("type", isUpdate ? "update" : "create");
			historyParam.put("resultFlag", "S");
			historyParam.put("comment", isUpdate ? "제조공정서 수정" : "제조공정서 생성");
			historyParam.put("regUserId", historyUserID);
			recordService.insertHistory(historyParam);
			
			txManager.commit(status);
			return "S";
		} catch (Exception e) {
			System.err.println(e.getMessage());
			logger.error(e.getMessage());
			logger.debug("===== ERROR : 제조공정서 저장/수정 작업 오류");
			
			e.printStackTrace();
			txManager.rollback(status);
			return "F";
		}
	}
	
	@Override
	public MfgProcessDoc getMfgProcessDocDetail(String dNo, String docNo, String docVersion, String plantCode) {
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("dNo", dNo);
		param.put("docNo", docNo);
		param.put("docVersion", docVersion);
		param.put("plantCode", plantCode);
		
		MfgProcessDoc mfgPrcoessDoc = productDevDao.getMfgProcessDocDetail(param); 
		param.put("isOld", mfgPrcoessDoc.getIsOld());
		mfgPrcoessDoc.setSub(productDevDao.getMfgProcessDocSub(param));
		for (int i = 0; i < mfgPrcoessDoc.getSub().size(); i++) {
			
			//String parCode = Integer.parseInt(dNo) <= lastMfgDocNo ? mfgPrcoessDoc.getSub().get(i).getSubProdCode() : mfgPrcoessDoc.getSub().get(i).getDsNo();
			String parCode = mfgPrcoessDoc.getSub().get(i).getSubProdCode() == null ? mfgPrcoessDoc.getSub().get(i).getDsNo() : mfgPrcoessDoc.getSub().get(i).getSubProdCode();
			
			param.put("parCode", parCode);
			mfgPrcoessDoc.getSub().get(i).setMix(productDevDao.getMfgProcessDocMix(param));
			mfgPrcoessDoc.getSub().get(i).setCont(productDevDao.getMfgProcessDocCont(param));
			
			// 배합비
			for (int j = 0; j < mfgPrcoessDoc.getSub().get(i).getMix().size(); j++) {
				//String itemParCode = Integer.parseInt(dNo) <= lastMfgDocNo ? mfgPrcoessDoc.getSub().get(i).getMix().get(j).getBaseCode() : mfgPrcoessDoc.getSub().get(i).getMix().get(j).getDmNo();
				String itemParCode = mfgPrcoessDoc.getSub().get(i).getMix().get(j).getBaseCode() == null ? mfgPrcoessDoc.getSub().get(i).getMix().get(j).getDmNo() : mfgPrcoessDoc.getSub().get(i).getMix().get(j).getBaseCode(); 
				
				param.put("itemType", "MI");
				param.put("itemParCode", itemParCode);
				mfgPrcoessDoc.getSub().get(i).getMix().get(j).setItem(productDevDao.getMfgProcessDocItem(param));
			}
			
			// 내용물
			for (int j = 0; j < mfgPrcoessDoc.getSub().get(i).getCont().size(); j++) {
				//String itemParCode = Integer.parseInt(dNo) <= lastMfgDocNo ? mfgPrcoessDoc.getSub().get(i).getCont().get(j).getBaseCode() : mfgPrcoessDoc.getSub().get(i).getCont().get(j).getDcNo();
				String itemParCode = mfgPrcoessDoc.getSub().get(i).getCont().get(j).getBaseCode() == null ? mfgPrcoessDoc.getSub().get(i).getCont().get(j).getDcNo() :mfgPrcoessDoc.getSub().get(i).getCont().get(j).getBaseCode(); 
				
				param.put("itemType", "CI");
				param.put("itemParCode", itemParCode);
				mfgPrcoessDoc.getSub().get(i).getCont().get(j).setItem(productDevDao.getMfgProcessDocItem(param));
			}
		}
		
		
		// pkg //04. 재료
		param.put("itemType", "MT"); 
		param.put("itemParCode", "");
		mfgPrcoessDoc.setPkg(productDevDao.getMfgProcessDocItem(param));
		// cons //08. 생산소모품
		param.put("itemType", "CS");
		param.put("itemParCode", "");
		mfgPrcoessDoc.setCons(productDevDao.getMfgProcessDocItem(param));
		// disp 
		mfgPrcoessDoc.setDisp(productDevDao.getMfgProcessDocDisp(param));
		// specs
		mfgPrcoessDoc.setSpec(productDevDao.getMfgProcessDocSpec(param));
		// specMD
		mfgPrcoessDoc.setSpecMD(productDevDao.getMfgProcessDocSpecMD(param));
		// StoreMethod 23.11.02
		mfgPrcoessDoc.setStoreMethod(productDevDao.getMfgProcessDocStoreMethod(param));
		
		// files
		HashMap<String, Object> fileParam = new HashMap<String, Object>();
		fileParam.put("tbKey", mfgPrcoessDoc.getDNo());
		fileParam.put("tbType", "manufacturingProcessDoc");
		try {
			mfgPrcoessDoc.setFile(fileDao.fileList(fileParam));
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return mfgPrcoessDoc;
	}

	@Override
	public String deleteManufacturingProcessDoc(String dNo, boolean isUpdate, String userId) {
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		TransactionStatus status = null;
		
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRES_NEW);
		status = txManager.getTransaction(def);
		
		try {
			HashMap<String, Object> param = new HashMap<String, Object>();
			param.put("dNo", dNo);
			int docDelCnt = isUpdate ? 0 : productDevDao.deleteMfgProcessDoc(param);
			int docSubDelCnt = productDevDao.deleteMfgProcessDocSub(param);
			int docMixDelCnt = productDevDao.deleteMfgProcessDocMix(param);
			int docContDelCnt = productDevDao.deleteMfgProcessDocCont(param);
			int docItemDelCnt = productDevDao.deleteMfgProcessDocItem(param); // mixItem, contItem, pkg, cons
			int docDispDelCnt = productDevDao.deleteMfgProcessDocDisp(param);
			int docSpecDelCnt = productDevDao.deleteMfgProcessDocSpec(param);
			
			logger.info("docDelCnt: " + docDelCnt 
				+"\n docSubDelCnt: " + docSubDelCnt
				+"\n docMixDelCnt: " + docMixDelCnt
				+"\n docContDelCnt: " + docContDelCnt
				+"\n docItemDelCnt: " + docItemDelCnt
				+"\n docDispDelCnt: " + docDispDelCnt
				+"\n docSpecDelCnt: " + docSpecDelCnt
			);
			
			if(docDelCnt > 0){
				HashMap<String, Object> historyParam = new HashMap<String, Object>();
				historyParam.put("tbType", "manufacturingProcessDoc");
				historyParam.put("tbKey", dNo);
				historyParam.put("type", "delete");
				historyParam.put("resultFlag", "S");
				historyParam.put("comment", "제조공정서 삭제");
				historyParam.put("regUserId", userId);
				recordService.insertHistory(historyParam);
				
				txManager.commit(status);
				return "S";
			} else {
				txManager.rollback(status);
				return "F";
			}
		} catch (Exception e) {
			System.err.println(e.getMessage());
			logger.error(e.getMessage());
			txManager.rollback(status);
			return "F";
		}
	}
	
	@Override
	public String copyManufacturingProcessDoc(String dNo, String userId) {
		MfgProcessDoc mfgPrcoessDoc = getMfgProcessDocDetail(dNo, "", "", "");
		mfgPrcoessDoc.setState("0");
		mfgPrcoessDoc.setStlal(null);
		mfgPrcoessDoc.setRegUserId(userId);
		mfgPrcoessDoc.setErrorMessage(null);
		return saveManufacturingProcessDoc(mfgPrcoessDoc, false);
		
		/*DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		TransactionStatus status = null;
		
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRES_NEW);
		status = txManager.getTransaction(def);
		
		try {
			HashMap<String, Object> param = new HashMap<String, Object>();
			param.put("dNo", dNo);
			param.put("userId", userId);
			
			
			mfgPrcoessDoc.setDNo(dNo);
			mfgPrcoessDoc.setRegUserId(userId);
			
//			int docDelCnt = isUpdate ? 0 : productDevDao.deleteMfgProcessDoc(param);
//			int docSubDelCnt = productDevDao.deleteMfgProcessDocSub(param);
//			int docMixDelCnt = productDevDao.deleteMfgProcessDocMix(param);
//			int docContDelCnt = productDevDao.deleteMfgProcessDocCont(param);
//			int docItemDelCnt = productDevDao.deleteMfgProcessDocItem(param); // mixItem, contItem, pkg, cons
//			int docDispDelCnt = productDevDao.deleteMfgProcessDocDisp(param);
//			int docSpecDelCnt = productDevDao.deleteMfgProcessDocSpec(param);
			
			int docCopyCnt = productDevDao.copyMfgProcessDocDetail(mfgPrcoessDoc);
			
			
			System.out.println("mfgPrcoessDoc.getDNo(): " + mfgPrcoessDoc.getDNo());
			System.out.println("mfgPrcoessDoc.getDNo(): " + mfgPrcoessDoc.getDNo());
			System.out.println("mfgPrcoessDoc.getDNo(): " + mfgPrcoessDoc.getDNo());
			System.out.println("mfgPrcoessDoc.getDNo(): " + mfgPrcoessDoc.getDNo());
			
			txManager.commit(status);
			
			return mfgPrcoessDoc.getDNo();
			
//			logger.info("docDelCnt: " + docDelCnt 
//				+"\n docSubDelCnt: " + docSubDelCnt
//				+"\n docMixDelCnt: " + docMixDelCnt
//				+"\n docContDelCnt: " + docContDelCnt
//				+"\n docItemDelCnt: " + docItemDelCnt
//				+"\n docDispDelCnt: " + docDispDelCnt
//				+"\n docSpecDelCnt: " + docSpecDelCnt
//			);
//			
//			if(docDelCnt > 0){
//				HashMap<String, Object> historyParam = new HashMap<>();
//				historyParam.put("tbType", "manufacturingProcessDoc");
//				historyParam.put("tbKey", dNo);
//				historyParam.put("type", "delete");
//				historyParam.put("resultFlag", "S");
//				historyParam.put("comment", "제조공정서 삭제");
//				historyParam.put("regUserId", userId);
//				recordService.insertHistory(historyParam);
//				
//				txManager.commit(status);
//				return "S";
//			} else {
//				txManager.rollback(status);
//				return "F";
//			}
		} catch (Exception e) {
			System.err.println(e.getMessage());
			logger.error(e.getMessage());
			txManager.rollback(status);
			return "F";
		}*/
	}
	
	@Override
	public String updateManufacturingProcessDoc(String dNo, String state, String userID) {
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		TransactionStatus status = null;
		
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRES_NEW);
		status = txManager.getTransaction(def);
		
		try {
			HashMap<String, Object> param = new HashMap<String, Object>();
			param.put("dNo", dNo);
			param.put("state", state);
			param.put("userID", userID);
			
			int updateCnt = productDevDao.updateManufacturingProcessDoc(param);
			
			String resultFlag = "";
			if(updateCnt > 0){
				resultFlag = "S";
			} else {
				resultFlag = "F";
			}
			
			HashMap<String, Object> historyParam = new HashMap<String, Object>();
			historyParam.put("tbType", "manufacturingProcessDoc");
			historyParam.put("tbKey", dNo);
			historyParam.put("type", "stop");
			historyParam.put("resultFlag", resultFlag);
			historyParam.put("comment", "제조공정서 중단");
			historyParam.put("regUserId", userID);
			recordService.insertHistory(historyParam);
			
			txManager.commit(status);
			return resultFlag;
		} catch (Exception e) {
			System.err.println(e.getMessage());
			logger.error(e.getMessage());
			txManager.rollback(status);
			return "F";
		}
		
	}
	
	@Override
	public MfgProcessDocProdSpec testCall(String dNo) {
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("dNo", dNo);
		return productDevDao.getMfgProcessDocSpec(param);
	}

	@Override
	public DesignRequestDocVO getDesignRequestDocDetail(String drNo) {
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("drNo", drNo);
		
		DesignRequestDocVO designVO = productDevDao.getDesignRequestDocDetail(param);
		NutritionLabel nutrition = productDevDao.getNutritionLabel(param);
		
		if(designVO != null && nutrition != null)
			designVO.setNutritionLabel(nutrition);
		
		return designVO;
	}
	
	@Override
	public int saveDesignRequestDoc(DesignRequestDocVO designVO) {
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		TransactionStatus status = null;
		
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRES_NEW);
		status = txManager.getTransaction(def);
		
		try {
			int insertCnt = productDevDao.saveDesignRequestDoc(designVO);
			designVO.getNutritionLabel().setDrNo(designVO.getDrNo());
			if(designVO.getNutritionLabel().getNutritionType() != "0"){
				productDevDao.saveNutritionLabel(designVO.getNutritionLabel());
			}
			
			txManager.commit(status);
			return insertCnt;
		} catch (Exception e) {
			System.err.println(e.getMessage());
			logger.error(e.getMessage());
			txManager.rollback(status);
			return 0;
		}
	}
	
	@Override
	public int updateDesignRequestDoc(DesignRequestDocVO designVO) {
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		TransactionStatus status = null;
		
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRES_NEW);
		status = txManager.getTransaction(def);
		
		try {
			int updateCnt = productDevDao.updateDesignRequestDoc(designVO);
			designVO.getNutritionLabel().setDrNo(designVO.getDrNo());
			if(designVO.getNutritionLabel().getNutritionType() != "0"){
				productDevDao.updateNutritionLabel(designVO.getNutritionLabel());
			}
			
			insertHistory("designRequestDoc", String.valueOf(designVO.getDrNo()), "update", "S", "디자인의뢰서 수정", designVO.getRegUserId());
			
			txManager.commit(status);
			return updateCnt;
		} catch (Exception e) {
			System.err.println(e.getMessage());
			logger.error(e.getMessage());
			txManager.rollback(status);
			return 0;
		}
	}
	
	/*@Override
	public int deleteDesignRequestDoc(int drNo, String userId) {
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("drNo", drNo);
		
		// 결재문서 삭제 로직 추가
		//approvalService.deleteAppr(apprno);
		
		return productDevDao.deleteDesignRequestDoc(param);
	}*/
	
	@Override
	public int deleteDesignRequestDoc(int drNo, String userId) {
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		TransactionStatus status = null;
		
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRES_NEW);
		status = txManager.getTransaction(def);
		
		try {
			HashMap<String, Object> param = new HashMap<String, Object>();
			param.put("drNo", drNo);
			
			// 결재문서 삭제 로직 추가
			DesignRequestDocVO detail = productDevDao.getDesignRequestDocDetail(param);
			int deleteCnt = productDevDao.deleteDesignRequestDoc(param);
			if(deleteCnt > 0 && detail != null){
				List<String> apprnoList = productDevDao.selectDesignReqDocApprNo(param);
				if(!detail.getState().equals("2") && apprnoList.size()>0 ){
					for (String apprno : apprnoList) {
						try {
							//approvalService.deleteAppr(Integer.parseInt(apprno));
							insertHistory("approvalBox", apprno, "delete", "S", "디자인의뢰서["+String.valueOf(drNo)+"]삭제에 따른 결재문서 삭제", userId);
						} catch (Exception e) {
							e.printStackTrace();
						}
					}
				}
				insertHistory("designRequestDoc", String.valueOf(drNo), "delete", "S", "디자인의뢰서 삭제", userId);
			} else {
				insertHistory("designRequestDoc", String.valueOf(drNo), "delete", "F", "디자인의뢰서 삭제 실패", userId);
			}
			
			txManager.commit(status);
			return deleteCnt;
		}catch (Exception e) {
			System.err.println(e.getMessage());
			logger.error(e.getMessage());
			txManager.rollback(status);
			return 0;
		}
	}
	
	@Override
	public int deleteAllDesignRequestDoc(String docNo, String docVersion, String modUserId) {
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("docNo", docNo);
		param.put("docVersion", docVersion);
		int deleteCnt = productDevDao.deleteAllDesignRequestDoc(param);
		// delete log here
		return deleteCnt;
	}

	@Override
	public int updateDevDocCloseState(DevDocVO devDocVO, String userId) {
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		TransactionStatus status = null;
		
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRES_NEW);
		status = txManager.getTransaction(def);
		
		try {
			HashMap<String, Object> param = new HashMap<String, Object>();
			String ddNo = String.valueOf(devDocVO.getDdNo());
			String docNo = String.valueOf(devDocVO.getDocNo());
			String docVersion = String.valueOf(devDocVO.getDocVersion());
			String isClose = String.valueOf(devDocVO.getIsClose());
			String isCloseText = isClose.equals("0") ? "진행(상산)중" : ( isClose.equals("1") ? "보류" : "중단" );
			
			param.put("ddNo", ddNo);
			param.put("docNo", docNo);
			param.put("docVersion", docVersion);
			param.put("isClose", isClose);
			param.put("userId", userId);
			param.put("closeMemo", devDocVO.getCloseMemo());
			
			String deleteLog = " =====  제품개발문서 상태변경[docNo="+docNo+", docVersion="+docVersion+"] Log  ===== ";
			// [보류] 또는 [중단]인 경우 결재문서 삭세
			if(isClose.equals("1") || isClose.equals("2")){
				// 결재문서삭제
				
				try {
					//approvalService.deleteApprList(docNo, docVersion);
					deleteLog += "\n\t 결재문서 삭제: 성공";
					insertHistory("approvalBox", "0", "delete", "S", "제품개발문서["+String.valueOf(ddNo)+"]상태 변경에 따른 결재문서 삭제", userId);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
					deleteLog += "\n\t 결재문서 삭제: 실패";
				}
				
				// 제조공정서 디자인의뢰서 상태 0 으로 초기화
				try {
					int updateCnt = productDevDao.updateMfgProcessDocState0(param);
					deleteLog += "\n\t 제조공정서 초기화: 성공";
					if(updateCnt > 0)
						insertHistory("manufacturingProcessDoc", "0", "update", "S", "제품개발문서["+String.valueOf(ddNo)+"]상태 변경에 따른 제조공정서 상태 초기화", userId);
				} catch (Exception e) {
					e.printStackTrace();
					// TODO: handle exception
					deleteLog += "\n\t 제조공정서 초기화: 실패";
				}
				try {
					int updateCnt = productDevDao.updateDesignRequestDocState0(param);
					deleteLog += "\n\t 디자인의뢰서 초기화: 성공";
					if(updateCnt > 0)
						insertHistory("designRequestDoc", "0", "update", "S", "제품개발문서["+String.valueOf(ddNo)+"]상태 변경에 따른 디자인의뢰서 상태 초기화", userId);
				} catch (Exception e) {
					e.printStackTrace();
					// TODO: handle exception
					deleteLog += "\n\t 디자인의뢰서 초기화: 실패";
				}
			}
			
			logger.debug(deleteLog);
			//System.out.println(deleteLog);
			
			int updateDevDocCnt = productDevDao.updateDevDocCloseState(param);
			
			if(updateDevDocCnt > 0 && !devDocVO.getRegUserId().equals(userId)){
				HashMap<String, Object> notiParam = new HashMap<String, Object>();
				notiParam.put("targetUserId", devDocVO.getRegUserId());
				notiParam.put("message", "제품개발문서["+docNo+"("+docVersion+")]의 상태가 변경되었습니다");
				notiParam.put("regUserId", userId);
				notiParam.put("isRead", "N");
				notiParam.put("type", "02");
				notiParam.put("typeText", "제품개발문서 상태변경");
				
				try {
					commonService.insertNotification(notiParam);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
					System.err.println("=====  제품개발문서 상태변경 알림 등록 오류   =====");
					logger.error("=====  제품개발문서 상태변경 알림 등록 오류   =====");
				}
			}
			
			/*
			 * HashMap<String, Object> historyParam = new HashMap<>();
			 * historyParam.put("tbType", "devDoc"); historyParam.put("tbKey", ddNo);
			 * historyParam.put("type", "update"); historyParam.put("resultFlag",
			 * updateDevDocCnt>0 ? "S" : "F"); historyParam.put("comment",
			 * "제품개발문서 상태 ["+isCloseText+"](으)로 변경"); historyParam.put("regUserId", userId);
			 * recordService.insertHistory(historyParam);
			 */
			
			String type= "update";
			String resultFlag = updateDevDocCnt>0 ? "S" : "F";
			String comment = "제품개발문서 상태 [\"+isCloseText+\"](으)로 변경";
			insertHistory("devDoc", ddNo, type, resultFlag, comment, userId);
			
			txManager.commit(status);
			return updateDevDocCnt;
		} catch (Exception e) {
			logger.error(e.getMessage());
			txManager.rollback(status);
			return 0;
		}
	}
	
	@Override
	public String versionUpDevDoc(DevDocVO devDocVO, String[] drNoArr) {
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		TransactionStatus status = null;
		
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRES_NEW);
		status = txManager.getTransaction(def);
		
		try {
			// 버전업을 위한 쿼리 실행 (devDoc 복사, 디자인의뢰서 복사, 파일 복사)
			HashMap<String, Object> param = new HashMap<String, Object>();
			param.put("docNo", devDocVO.getDocNo());
			param.put("docVersion", devDocVO.getDocVersion());
			param.put("isLatest", "0");
			productDevDao.updateDevDocLatestState(param);
			
			logger.debug("업데이트 이전 - " + devDocVO.toString());
			productDevDao.versionUpDevDoc(devDocVO);
			logger.debug("업데이트 이후 - " + devDocVO.toString());
			param.put("createdDocVersion", devDocVO.getDocVersion());
			
			// 삼립CSR S201005-00017 요청 건
			/*
			 * productDevDao.copyDevDocFile(param); if(drNoArr.length > 0){
			 * param.put("drNoArr", drNoArr); productDevDao.copyDesignRequestDocList(param);
			 * }
			 */
			
			txManager.commit(status);
			return String.valueOf(devDocVO.getDocVersion());
		} catch (Exception e) {
			System.err.println(e.getMessage());
			logger.error(e.getMessage());
			txManager.rollback(status);
			return null;
		}
	
	}

	@Override
	public boolean hasAuthority(String userId, String regUserId, int grade) {
		// TODO Auto-generated method stub
		Map<String,Object> param  = new HashMap<String,Object>();
		
		boolean aut = false;
		
		if(grade == 8) return true;
		if(userId.equals(regUserId)) return true;
		
		param.put("userId", userId);
		param.put("regUserId", regUserId);
		
		int count = productDevDao.hasAuthority(param);
		
		if(count > 0) {
			aut = true;
		}
		
		return aut;
	}

	@Override
	public List<Map<String, Object>> detailDdNo(int ddNo) {
		// TODO Auto-generated method stub
		return productDevDao.detailDdNo(ddNo);
	}
	
	@Override
	public List<Map<String, Object>> getDevDocSummaryList(Auth userInfo, String productType1, String productType2, String productType3,
			String productName) {
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("productType1", productType1);
		param.put("productType2", productType2);
		param.put("productType3", productType3);
		param.put("productName", productName);
		
		System.out.println(userInfo.toString());
		param.put("userId", userInfo.getUserId());
		param.put("isAdmin", userInfo.getIsAdmin());
		param.put("teamCode", userInfo.getTeamCode());
		param.put("deptCode", userInfo.getDeptCode());
		param.put("userGrade", userInfo.getUserGrade());
		
		return productDevDao.getDevDocSummaryList(param);
	}
	
	@Override
	public List<Map<String, Object>> getMfgsummaryList(Auth userInfo, String docNo, String docVersion) {
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("docNo", docNo);
		param.put("docVersion", docVersion);
		param.put("userId", userInfo.getUserId());
		param.put("isAdmin", userInfo.getIsAdmin());
		
		return productDevDao.getMfgsummaryList(param);
	}
	
	@Override
	public List<String> getDevDocVersion(String docNo) {
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("docNo", docNo);
		
		return productDevDao.getDevDocVersion(param);
	}

	@Override
	public int countForDevDoc(String regUserId) {
		// TODO Auto-generated method stub
		return productDevDao.countForDevDoc(regUserId);
	}

	@Override
	public int countForDesignRequestDoc(String regUserId) {
		// TODO Auto-generated method stub
		return productDevDao.countForDesignRequestDoc(regUserId);
	}

	@Override
	public int countForManuFacturingProcessDoc(String regUserId) {
		// TODO Auto-generated method stub
		return productDevDao.countForManuFacturingProcessDoc(regUserId);
	}
	
	@Override
	public NutritionLabel getNutritionLabel(String drNo) {
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("drNo", drNo);
		
		return productDevDao.getNutritionLabel(param);
	}
	
	@Override
	public List<Map<String, Object>> getLatestMaterail(String dNo, String itemImNo, String itemSapCode) {
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("dNo", dNo);
		
		if(itemImNo.equals("") || itemImNo==null){
			param.put("itemSapCode", itemSapCode);
			return productDevDao.getLatestMaterailOfSapCode(param);
		} else {
			param.put("itemImNo", itemImNo);
			return productDevDao.getLatestMaterailOfImNo(param);
		}
	}
	
	// List<Map<String, String>>
	@Override
	public Map<String, Object> updateBOM(String[] dNoList, String userId) throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("dNoList", dNoList);
		
		UserVO user = new UserVO();
		user.setUserId(userId);;
		user = userService.getUserInfo(user);
		List<Map<String, Object>> bomHeaderList = productDevDao.getBomHeaderList(param);
		
		//logger.error("bomHeaderList.size() : " + bomHeaderList.size());
		
		for (Map<String, Object> headerMap : bomHeaderList) {
			
			DefaultTransactionDefinition def = new DefaultTransactionDefinition();
			TransactionStatus status = null;
			
			def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRES_NEW);
			status = txManager.getTransaction(def);
			
			String dNo = String.valueOf(headerMap.get("dNo"));
			
			try {
				Iterator<String> keys = headerMap.keySet().iterator();
				String headerLogStr = "headers"; 
				
				while (keys.hasNext()) {
					String headerKey = keys.next();
					headerLogStr += "\n\tkey: " + headerKey + ", value: " + headerMap.get(headerKey);
				}
				logger.debug(headerLogStr);
				
				// 중복된 BOM인지 header데이터 체크
				// fn: ZPP_BOM_RFC5 
				
				Boolean isNew = null;
				
				String STLAL = (String)headerMap.get("STLAL");
				if(STLAL == null || STLAL.equals("")){
					isNew = true;
				} else {
					isNew = bomDao.bomHeaderCheck(headerMap);
				}
				
				param = new HashMap<String, Object>();
				param.put("dNo", dNo);
				List<Map<String, Object>> bomItemList = productDevDao.getBomItemList(param);
				
				//logger.error("bomItemList.size() : " + bomItemList.size()); 
				
				for (Map<String, Object> bomItem : bomItemList) {
					String meins = String.valueOf(bomItem.get("MEINS"));
					String companyCode = String.valueOf(bomItem.get("companyCode"));
					String idnrk = String.valueOf(bomItem.get("IDNRK"));
					
					// 단위변경 전송		
					if("ST".equals(meins)){
						meins = "PC";
					} else if("KAN".equals(meins)){
						meins = "CAN";
					}
					
					if("SN".equals(companyCode) && "BON".equals(meins)){
						meins = "봉";
					} else if("SL".equals(companyCode) && "BON".equals(meins)){
						meins = "BN";
					}
					
					// 코드가 'P'로 시작하는 아이템은 SANFE 필드의 'X' 값을 보내지 않음
					if(idnrk.startsWith("P")){
						bomItem.remove("SANFE");
						bomItem.put("SANFE", "");
					}
					
					bomItem.remove("MEINS");
					bomItem.put("MEINS", meins);
					bomItem.put("UNAME", user.getUserCode());		// 수정자 사번
				}
				
				
				
				String tempBOM = "";
				for (Map<String, Object> bomItem : bomItemList) {
					if(bomItem.get("POSNR") == null){
						Map<String, String> resultMap = new HashMap<String, String>();
						resultMap.put("dNo", dNo);
						resultMap.put("resultFlag", "F");
						resultMap.put("resultMessage", "BOM항목을 입력하지 않았습니다.\\n 제조공정서의 BOM항목을 입력 후 재반영하세요.");
						txManager.rollback(status);
						
						returnMap.put("header", resultMap);
						return returnMap;
					} else {
						String POSNR = (String)bomItem.get("POSNR");
						
						if(!POSNR.equals("")){
							if(tempBOM.equals(POSNR)){
								Map<String, String> resultMap = new HashMap<String, String>();
								resultMap.put("dNo", dNo);
								resultMap.put("resultFlag", "F");
								resultMap.put("resultMessage", "BOM항목 중 중복된 항목이 있습니다.("+POSNR+") 중복된 항목이\n없도록 변경 후 재반영하세요.");
								txManager.rollback(status);
								
								returnMap.put("header", resultMap);
								return returnMap;
							}
						} else {
							Map<String, String> resultMap = new HashMap<String, String>();
							resultMap.put("dNo", dNo);
							resultMap.put("resultFlag", "F");
							resultMap.put("resultMessage", "BOM항목을 입력하지 않았습니다.\n제조공정서의 BOM항목을 입력 후 재반영하세요.");
							txManager.rollback(status);
							
							returnMap.put("header", resultMap);
							return returnMap;
						}
						
						tempBOM = POSNR;
					}
				}
				
				//logger.debug("next line tempBOM = POSNR");
				
				if(isNew){
					// 새로 BOM 생성
					// fn: ZPP_BOM_RFC
					Map<String, String> resultMap = bomDao.createBom(bomItemList);
					
					resultMap.put("dNo", dNo);
					
					STLAL = resultMap.get("STLAL"); // STLAL
					String resultFlag = resultMap.get("resultFlag"); // COM
					String resultMessage = resultMap.get("resultMessage"); // MESS
					
					if(resultFlag.equals("S")){
						
						headerMap.remove("STLAL");
						headerMap.put("STLAL", STLAL);
						
						int headerSeq = productDevDao.getBomHeaderNextSeq(headerMap);
						
						headerMap.put("seq", headerSeq);
						headerMap.put("regUserId", userId);
						headerMap.put("state", "4");
						headerMap.put("errorMessage", resultMessage);
						
						productDevDao.insertBomHeader(headerMap);
						productDevDao.updateMgfProcessDocBom(headerMap);
					} else {
						
						int headerSeq = productDevDao.getBomHeaderNextSeq(headerMap);
						
						headerMap.put("seq", headerSeq);
						headerMap.put("regUserId", userId);
						headerMap.put("state", "5");
						headerMap.put("errorMessage", resultMessage);
						
						productDevDao.updateMgfProcessDocBom(headerMap);
					}
					
					txManager.commit(status);
					
					returnMap.put("header", resultMap);
					return returnMap;
					//return resultMap;
				} else {
					// 기존 BOM 수정
					// fn: ZPP_BOM_RFC2
					
					//logger.error("BOM UPDAET - term > 0");
					Map<String, String> resultMap = bomDao.updateBom(headerMap);
					
					resultMap.put("dNo", dNo);
					String resultFlag = resultMap.get("resultFlag"); // COM
					String resultMessage = resultMap.get("resultMessage"); // MESS
					
					returnMap.put("header", resultMap);
					
					if(resultFlag.equals("S")){
						Map<String, String> itemResultMap = bomDao.updateBomItem(bomItemList); // RFC4
						
						itemResultMap.put("dNo", dNo);
						String itemResultFlag = itemResultMap.get("resultFlag");
						String itemResultMessage = itemResultMap.get("resultMessage"); // MESS
						
						if("S".equals(itemResultFlag)){
							headerMap.remove("STLAL");
							headerMap.put("STLAL", STLAL);
							
							int headerSeq = productDevDao.getBomHeaderNextSeq(headerMap);
							
							headerMap.put("seq", headerSeq);
							headerMap.put("regUserId", userId);
							headerMap.put("state", "4");
							headerMap.put("errorMessage", itemResultMessage);
							
							productDevDao.insertBomHeader(headerMap);
							productDevDao.updateMgfProcessDocBom(headerMap);
							
							txManager.commit(status);
							
							returnMap.put("item", itemResultMap);
							return returnMap;
						} else if ("X".equals(itemResultFlag)){
							//itemResultFlag = "Y";
							int headerSeq = productDevDao.getBomHeaderNextSeq(headerMap);
							
							headerMap.put("seq", headerSeq);
							headerMap.put("regUserId", userId);
							headerMap.put("state", "4");
							headerMap.put("errorMessage", "[BOM 세부항목]"+itemResultMessage);
							
							productDevDao.insertBomHeader(headerMap);
							productDevDao.updateMgfProcessDocBom(headerMap);
							
							txManager.commit(status);
							
							returnMap.put("item", itemResultMap);
							return returnMap;
						} else {
							headerMap.put("regUserId", userId);
							headerMap.put("state", "5");
							headerMap.put("errorMessage", resultMessage);
							
							productDevDao.updateMgfProcessDocBom(headerMap);
							
							txManager.commit(status);
							
							returnMap.put("item", itemResultMap);
							return returnMap;
						}
					} else {
						headerMap.put("regUserId", userId);
						headerMap.put("state", "5");
						headerMap.put("errorMessage", resultMessage);
						
						productDevDao.updateMgfProcessDocBom(headerMap);
						
						txManager.commit(status);
						return returnMap;
					}
					
					
					/*
					 * 하루 1회만 Header를 업데이트 하는 로직 수정 2020.11.17
					 * 연구기획소재팀과 협의된 내용으로 기준수량이 여러번 업데이트 될 수 있도록 변경하기 위해 해당 로직 제거
					 * 
					 * 일 1회 업데이트 -> 횟수 제한 제거
					 * 일 1회 SAP에 로그 -> 일당 마지막 반영한 BOM만 로그 (이 내용은 SAP로직으로 협의된 김성훈 차장과 협의된 사항임)
					 * 
					 * 위 내용대로 처리하기 위해 term 으로 구분하는 구문은 제거
					 * 
					 * 
					 * int term = Integer.parseInt(String.valueOf(headerMap.get("term")));
					 * 
					 * if(term > 0){ System.err.println("BOM UPDAET - term > 0");
					 * logger.error("BOM UPDAET - term > 0"); Map<String, String> resultMap =
					 * bomDao.updateBom(headerMap);
					 * 
					 * resultMap.put("dNo", dNo); String resultFlag = resultMap.get("resultFlag");
					 * // COM String resultMessage = resultMap.get("resultMessage"); // MESS
					 * 
					 * returnMap.put("header", resultMap);
					 * 
					 * if(resultFlag.equals("S")){ Map<String, String> itemResultMap =
					 * bomDao.updateBomItem(bomItemList); // RFC4
					 * 
					 * itemResultMap.put("dNo", dNo); String itemResultFlag =
					 * itemResultMap.get("resultFlag"); String itemResultMessage =
					 * itemResultMap.get("resultMessage"); // MESS
					 * 
					 * if("S".equals(itemResultFlag)){ headerMap.remove("STLAL");
					 * headerMap.put("STLAL", STLAL);
					 * 
					 * int headerSeq = productDevDao.getBomHeaderNextSeq(headerMap);
					 * 
					 * headerMap.put("seq", headerSeq); headerMap.put("regUserId", userId);
					 * headerMap.put("state", "4"); headerMap.put("errorMessage",
					 * itemResultMessage);
					 * 
					 * productDevDao.insertBomHeader(headerMap);
					 * productDevDao.updateMgfProcessDocBom(headerMap);
					 * 
					 * txManager.commit(status); bomResultList.add(itemResultMap);
					 * 
					 * //return itemResultMap; returnMap.put("item", itemResultMap); return
					 * returnMap; } else if ("X".equals(itemResultFlag)){ itemResultFlag = "Y"; int
					 * headerSeq = productDevDao.getBomHeaderNextSeq(headerMap);
					 * 
					 * headerMap.put("seq", headerSeq); headerMap.put("regUserId", userId);
					 * headerMap.put("state", "4"); headerMap.put("errorMessage",
					 * "[BOM 세부항목]"+itemResultMessage);
					 * 
					 * productDevDao.insertBomHeader(headerMap);
					 * productDevDao.updateMgfProcessDocBom(headerMap);
					 * 
					 * txManager.commit(status); bomResultList.add(itemResultMap);
					 * 
					 * //return itemResultMap; returnMap.put("item", itemResultMap); return
					 * returnMap; } else { headerMap.put("regUserId", userId);
					 * headerMap.put("state", "5"); headerMap.put("errorMessage", resultMessage);
					 * 
					 * productDevDao.updateMgfProcessDocBom(headerMap);
					 * 
					 * txManager.commit(status); bomResultList.add(itemResultMap); //return
					 * itemResultMap;
					 * 
					 * returnMap.put("item", itemResultMap); return returnMap; } } else {
					 * headerMap.put("regUserId", userId); headerMap.put("state", "5");
					 * headerMap.put("errorMessage", resultMessage);
					 * 
					 * productDevDao.updateMgfProcessDocBom(headerMap);
					 * 
					 * txManager.commit(status); bomResultList.add(resultMap); //return resultMap;
					 * return returnMap; } } else { Map<String, String> itemResultMap =
					 * bomDao.updateBomItem(bomItemList);
					 * 
					 * itemResultMap.put("dNo", dNo);
					 * 
					 * String itemResultFlag = itemResultMap.get("resultFlag"); // COM String
					 * itemResultMessage = itemResultMap.get("resultMessage"); // MESS
					 * 
					 * 
					 * if(itemResultFlag.equals("S")){ int headerSeq =
					 * productDevDao.getBomHeaderNextSeq(headerMap);
					 * 
					 * headerMap.put("seq", headerSeq); headerMap.put("regUserId", userId);
					 * headerMap.put("state", "4"); headerMap.put("errorMessage",
					 * itemResultMessage);
					 * 
					 * productDevDao.insertBomHeader(headerMap);
					 * productDevDao.updateMgfProcessDocBom(headerMap);
					 * 
					 * txManager.commit(status); bomResultList.add(itemResultMap); //return
					 * itemResultMap;
					 * 
					 * returnMap.put("item", itemResultMap); return returnMap; } else if
					 * ("X".equals(itemResultFlag)){ int headerSeq =
					 * productDevDao.getBomHeaderNextSeq(headerMap);
					 * 
					 * headerMap.put("seq", headerSeq); headerMap.put("regUserId", userId);
					 * headerMap.put("state", "4"); headerMap.put("errorMessage",
					 * "[BOM 세부항목]"+itemResultMessage);
					 * 
					 * productDevDao.insertBomHeader(headerMap);
					 * productDevDao.updateMgfProcessDocBom(headerMap);
					 * 
					 * txManager.commit(status); bomResultList.add(itemResultMap);
					 * 
					 * //return itemResultMap;
					 * 
					 * returnMap.put("item", itemResultMap); return returnMap; } else {
					 * headerMap.put("regUserId", userId); headerMap.put("state", "5");
					 * headerMap.put("errorMessage", itemResultMessage);
					 * 
					 * productDevDao.updateMgfProcessDocBom(headerMap);
					 * 
					 * txManager.commit(status); bomResultList.add(itemResultMap); //return
					 * itemResultMap;
					 * 
					 * returnMap.put("item", itemResultMap); return returnMap; } }
					 * 
					 */
				}
			} catch (Exception e) {
				e.printStackTrace();
				logger.error(e.getMessage());
				
				Map<String, String> resultMap = new HashMap<String, String>();
				
				resultMap.put("dNo", dNo);
				resultMap.put("resultFlag", "E");
				resultMap.put("resultMessage", "BOM 반영 작업이 정상적으로 수행되지 않았습니다");
				txManager.rollback(status);
				
				//returnMap.put("item", resultMap);
				returnMap.put("header", resultMap);
				return returnMap;
			}
		}
		
		Map<String, String> resultMap = new HashMap<String, String>();
		resultMap.put("resultFlag", "E");
		resultMap.put("resultMessage", "제조공정서가 없거나 지정한 제조공정서를 조회할 수 없습니다");
		
		returnMap.put("header", resultMap);
		return returnMap;
	}
	
	@Override
	public Map<String, Object> MfgProcessDetail(Map<String,Object> param) {
		// TODO Auto-generated method stub
		return productDevDao.MfgProcessDetail(param);
	}
	
	@Override
	public Map<String, Object> getDispInfo(String dNo) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("dNo", dNo);
		
		MfgProcessDoc mfgPrcoessDoc = productDevDao.getMfgProcessDocDetail(param);
		
		resultMap.put("dispInfo", productDevDao.getDispInfo(param));
		resultMap.put("dNo", mfgPrcoessDoc.getDNo());
		resultMap.put("docProdName", mfgPrcoessDoc.getDocProdName());
		
		return resultMap;
	}
	
	@Override
	public int updateDispList(MfgProcessDoc mfgProcessDoc) {
		
		List<MfgProcessDocDisp> dispList = mfgProcessDoc.getDisp();
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		TransactionStatus status = null;
		
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRES_NEW);
		status = txManager.getTransaction(def);
		
		try {
			int updateCnt = 0;
			
			HashMap<String, Object> param = new HashMap<String, Object>();
			param.put("dNo", mfgProcessDoc.getDNo());
			param.put("docProdName", mfgProcessDoc.getDocProdName());
			
			productDevDao.updateDocProdName(param);
			
			for (MfgProcessDocDisp disp : dispList) {
				updateCnt += productDevDao.updateDisp(disp);
			}
			
			txManager.commit(status);
			return updateCnt;
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage());
			
			txManager.rollback(status);
			return 0;
		}
	}
	
	@Override
	public String checkDevDocFile(String ddfNo, String userId) {
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("ddfNo", ddfNo);
		param.put("userId", userId);
		
		int updateCnt = productDevDao.checkDevDocFile(param);
		
		return updateCnt > 0 ? "S" : "F";
	}
	
	@Override
	public String updateManufacturingProcessDocPakcage(MfgProcessDoc mfgProcessDoc) {
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		TransactionStatus status = null;
		
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRES_NEW);
		status = txManager.getTransaction(def);
		
		try {
			HashMap<String, Object> param = new HashMap<String, Object>();
			param.put("dNo", mfgProcessDoc.getDNo());
			
			int docPkgItemDelCnt = productDevDao.deleteMfgProcessDocPkgItem(param);
			int docPkgItemUdateCnt = 0;
			
			if(mfgProcessDoc.getPkg() != null){
				List<MfgProcessDocItem> pkgList = mfgProcessDoc.getPkg();
				if(pkgList != null)
				for (MfgProcessDocItem mfgProcessDocItem : pkgList) {
					mfgProcessDocItem.setDNo(mfgProcessDoc.getDNo());
					mfgProcessDocItem.setDocNo(mfgProcessDoc.getDocNo());
					mfgProcessDocItem.setDocVersion(mfgProcessDoc.getDocVersion());
					mfgProcessDocItem.setRegUserId(mfgProcessDoc.getRegUserId());
					mfgProcessDocItem.setModUserId(mfgProcessDoc.getModUserId());
					mfgProcessDocItem.setItemType("MT");
					
					docPkgItemUdateCnt += productDevDao.saveMfgProcessDocItem(mfgProcessDocItem);
				}
			}
			/*
			 * HashMap<String, Object> historyParam = new HashMap<>();
			 * historyParam.put("tbType", "manufacturingProcessDoc");
			 * historyParam.put("tbKey", mfgProcessDoc.getDNo()); historyParam.put("type",
			 * "update"); historyParam.put("comment", "제조공정서 재료 수정");
			 * historyParam.put("regUserId", mfgProcessDoc.getModUserId());
			 * recordService.insertHistory(historyParam);
			 */
			insertHistory("manufacturingProcessDoc", mfgProcessDoc.getDNo(), "update", "S", "제조공정서 재료 수정", mfgProcessDoc.getModUserId());
			
			txManager.commit(status);
			return docPkgItemUdateCnt > 0 ? "S" : "F";
		} catch (Exception e) {
			System.err.println(e.getMessage());
			logger.error(e.getMessage());
			txManager.rollback(status);
			return "F";
		}
	}
	
	@Override
	public String updateManufacturingProcessDocSpec(MfgProcessDoc mfgProcessDoc) {
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		TransactionStatus status = null;
		
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRES_NEW);
		status = txManager.getTransaction(def);
		
		try {
			HashMap<String, Object> param = new HashMap<String, Object>();
			param.put("dNo", mfgProcessDoc.getDNo());
			
			int deleteCnt = productDevDao.deleteMfgProcessDocSpec(param);
			int insertCnt = 0;
			
			int updateCnt = productDevDao.updateMfgProcessDocEtc(mfgProcessDoc);
			
			if(mfgProcessDoc.getSpec() != null){
				insertCnt = productDevDao.saveMfgProcessDocProdSpec(mfgProcessDoc.getSpec());
			}
			
			/*
			 * HashMap<String, Object> historyParam = new HashMap<>();
			 * historyParam.put("tbType", "manufacturingProcessDoc");
			 * historyParam.put("tbKey", mfgProcessDoc.getDNo()); historyParam.put("type",
			 * "update"); historyParam.put("comment", "제조공정서 제품규격 수정");
			 * historyParam.put("regUserId", mfgProcessDoc.getModUserId());
			 * recordService.insertHistory(historyParam);
			 */
			insertHistory("manufacturingProcessDoc", mfgProcessDoc.getDNo(), "update", "S", "제조공정서 제품규격 수정", mfgProcessDoc.getModUserId());
			
			txManager.commit(status);
			return insertCnt > 0 ? "S" : "F";
		} catch (Exception e) {
			System.err.println(e.getMessage());
			logger.error(e.getMessage());
			txManager.rollback(status);
			return "F";
		}
	}
	
	/**
	 * 
	 * 수정 : 230816 
	 * 수정 : '이력' 항목에 '엑셀,프린트' 내역 추가
	 * */
	@Override
	public List<Map<String, Object>> getHistoryList(String tbType, String tbKey) {
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("tbType", tbType);
		param.put("tbKey", tbKey);
		
		List<Map<String,Object>> documentHistoryList = new ArrayList<Map<String,Object>>();	// documentHistory 이력 
		List<Map<String,Object>> printLogHistoryList = new ArrayList<Map<String,Object>>();	// printLog 이력( 엑셀다운로드, 프린트이력 )
		List<Map<String, Object>> combinedList = new ArrayList<Map<String,Object>>();			// 합본 List<Map>
		
		documentHistoryList = recordService.getHistoryList(param);
		printLogHistoryList = recordService.getHistoryListPrintExcel(param);
		combinedList.addAll(documentHistoryList);
		combinedList.addAll(printLogHistoryList);
		//combinedList.sort(Comparator.comparing(map -> map.get("regDate").toString(), Comparator.reverseOrder())); // 등록일 기준 정렬
		
		//return recordService.getHistoryList(param);
		return combinedList;
	}
	
	@Override
	public String copyDesignRequestDoc(String drNo, String docNo, String docVersion, String userId) {
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		TransactionStatus status = null;
		
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRES_NEW);
		status = txManager.getTransaction(def);
		
		try {
			HashMap<String, Object> param = new HashMap<String, Object>();
			param.put("drNo", drNo);
			param.put("docNo", docNo);
			param.put("docVersion", docVersion);
			param.put("userId", userId);
			
			// copy designdoc
			int designReqDocInsertCnt = productDevDao.copyDesignRequestDoc(param);
			// copy nutritionLabel
			int nutritionInsertCnt = productDevDao.copyNutiritionLabel(param);
			
			txManager.commit(status);
			return designReqDocInsertCnt > 0 ? "S" : "F";
		} catch (Exception e) {
			System.err.println(e.getMessage());
			logger.error(e.getMessage());
			txManager.rollback(status);
			return "F";
		}
		
	}
	
	private void insertHistory(String tbType, String tbKey, String type, String resultFlag, String comment, String userId){
		HashMap<String, Object> historyParam = new HashMap<String, Object>();
		historyParam.put("tbType", tbType);
		historyParam.put("tbKey", tbKey);
		historyParam.put("type", type);
		historyParam.put("resultFlag", resultFlag);
		historyParam.put("comment", comment);
		historyParam.put("regUserId", userId);
		recordService.insertHistory(historyParam);
	}
	
	@Override
	public List<Map<String, Object>> searchDevDocLatest(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return productDevDao.searchDevDocLatest(param);
	}

	@Override
	public void updateProductLaunchDate(Map<String, Object> param) {
		// TODO Auto-generated method stub
		
		productDevDao.updateProductLaunchDate(param);
		
	}

	@Override
	public List<Map<String, Object>> searchLaunchListByDate(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return productDevDao.searchLaunchListByDate(param);
	}
	
	@Override
	public ResultVO updateQns(HttpServletRequest request, Map<String, Object> param) {
		// S201109-00014
		Auth user = null;
		try {
			user = AuthUtil.getAuth(request);
			
			int updateCnt = productDevDao.updateQns(param);
			if(updateCnt > 0) {
				return new ResultVO();
			} else {
				return new ResultVO("90", "수정가능한 제조공정서가 없습니다."); 
			}
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return new ResultVO("90", "로그인 정보가 존재하지 않습니다. 재접속 후 다시 시도해주세요.");
		}
	}
	
	@Override
	public Map<String, Object> popupDataInfo(Map<String, Object> param) {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("productDevDoc", param);
		
		Map<String, String> docInfo = productDevDao.getDocInfo(param);
		String dNo = (String)param.get("dNo");
		String docNo = String.valueOf(docInfo.get("docNo"));
		String docVersion = String.valueOf(docInfo.get("docVersion"));
		
		param.put("docNo", docNo);
		param.put("docVersion", docVersion);
		
		map.put("productDevDoc", getProductDevDoc(docNo, docVersion));
		map.put("mfgProcessDoc", getMfgProcessDocDetail(dNo, docNo, docVersion, ""));
		map.put("paramVO", param);
		
		return map;
	}
	
	@Override
   public Map<String, Object> bomItemCheck(String[] dNoList, String userId) throws Exception{
      // TODO Auto-generated method stub
      Map<String, Object> returnMap = new HashMap<String, Object>();
      String resultFlag = "S";      
      List<Map<String, Object>> resultArray = new ArrayList<Map<String, Object>>();
      HashMap<String, Object> param = new HashMap<String, Object>();
      param.put("dNoList", dNoList);
      
      UserVO user = new UserVO();
      user.setUserId(userId);;
      user = userService.getUserInfo(user);
      List<Map<String, Object>> bomHeaderList = productDevDao.getCheckBomHeaderList(param);
      
      //logger.error("bomHeaderList.size() : " + bomHeaderList.size());
      
      for (Map<String, Object> headerMap : bomHeaderList) {
         
         String dNo = String.valueOf(headerMap.get("dNo"));

		  //점포용,OEM 제거
		  if(StringUtil.nvl(headerMap.get("productDocType")).equals("1")){continue;}
		  if(StringUtil.nvl(headerMap.get("productDocType")).equals("2")){continue;}

         try {
            Iterator<String> keys = headerMap.keySet().iterator();
            String headerLogStr = "headers"; 
            
            while (keys.hasNext()) {
               String headerKey = keys.next();
               headerLogStr += "\n\tkey: " + headerKey + ", value: " + headerMap.get(headerKey);
            }
            logger.debug(headerLogStr);
            System.err.println(headerLogStr);
            
            param = new HashMap<String, Object>();
            param.put("dNo", dNo);
            // 자재코드 상태(X)조회
            List<Map<String, Object>> bomItemList = productDevDao.getCheckBomItemList(param);
            // 임시 자재코드 조회
            List<Map<String, Object>> bomItemSampleList = productDevDao.getCheckBomItemSampleList(param);
            
            if( bomItemList.size() > 0 || bomItemSampleList.size() >0) {
               resultFlag = "E";
               Map<String, Object> result = new HashMap<String, Object>();
               result.put("header", headerMap);
               ArrayList<Map<String, Object>> bomItemInfoList = new ArrayList<Map<String, Object>>();
               
               if(bomItemList.size() > 0){
            	   for (Map<String, Object> bomItem : bomItemList) {
                       Map<String, Object> bomItemInfo = new HashMap<String, Object>();
                       bomItemInfo.put("itemCode", bomItem.get("itemCode"));   
                       bomItemInfo.put("itemName", bomItem.get("itemName"));
                       bomItemInfo.put("unit", bomItem.get("unit"));
                       bomItemInfo.put("matStatus", bomItem.get("matStatus"));
                       bomItemInfoList.add(bomItemInfo);
                    }
                    result.put("item", bomItemInfoList);
               }
               //임시코드 감별
               if(bomItemSampleList.size() > 0){
            	   for (Map<String, Object> bomItem : bomItemSampleList) {
                       Map<String, Object> bomItemInfo = new HashMap<String, Object>();
                       bomItemInfo.put("itemCode", bomItem.get("itemCode"));   
                       bomItemInfo.put("itemName", bomItem.get("itemName"));
                       bomItemInfo.put("unit", bomItem.get("unit"));
                       bomItemInfo.put("isSample", bomItem.get("isSample"));
                       bomItemInfoList.add(bomItemInfo);
                    }
                    result.put("item", bomItemInfoList);
               }
                  
               resultArray.add(result);
            }
            
         } catch (Exception e) {
            e.printStackTrace();
            logger.error(e.getMessage());
            
            //Map<String, String> resultMap = new HashMap<String, String>();
            
            //resultMap.put("dNo", dNo);
            returnMap.put("resultFlag", "E");
            returnMap.put("resultMessage", "데이터 확인 오류");
            
            //returnMap.put("item", resultMap);
            //returnMap.put("header", resultMap);
            System.err.println("returnMap  :  "+returnMap);
            return returnMap;
         }
      }
      System.err.println("resultArray  :  "+resultArray.size());
      //Map<String, String> resultMap = new HashMap<String, String>();
      returnMap.put("resultFlag", resultFlag);
      //returnMap.put("header", resultMap);
      returnMap.put("resultArray", resultArray);
      System.err.println("returnMap  :  "+returnMap);
      return returnMap;
   }

	@Override
	public void updateDocStopMonth(HashMap<String, Object> param) {
		// TODO Auto-generated method stub
		productDevDao.updateDocStopMonth(param);
	}
	
	@Override
	public ImageFileForStores saveImageFileForStore(ImageFileForStores imageFileForStore) throws Exception {
		List<ImageFileForStores> imageFileForStoresList = productDevDao.getimageFileForStores(StringUtil.nvl(imageFileForStore.getTbKey()));
		boolean isInsert = true;
		
		for(ImageFileForStores reportFile : imageFileForStoresList){
			if(reportFile.getGubun().equals(imageFileForStore.getGubun())){
				isInsert = false;
				imageFileForStore.setFNo(reportFile.getFNo());
				FileUtil.fileDelete(reportFile.getFileName(),reportFile.getPath());
			}
		}
		if(isInsert){
			productDevDao.insertImageFileForStores(imageFileForStore);
		}else{
			productDevDao.updateImageFileForStores(imageFileForStore);
		}
		imageFileForStore.setWebUrl(StringUtil.getDevdocFileName(imageFileForStore.getPath() + "/" + imageFileForStore.getFileName()));
		return imageFileForStore;
	}

	@Override
	public List<ImageFileForStores> getImageFileForStores(String dNo) {
		List<ImageFileForStores> imageFileForStoresList = productDevDao.getimageFileForStores(dNo);
		for(ImageFileForStores imageFileForStore : imageFileForStoresList){
			imageFileForStore.setWebUrl(StringUtil.getDevdocFileName(imageFileForStore.getPath() + "/" + imageFileForStore.getFileName()));
		}
		return imageFileForStoresList;
	}
	
	@Override
	public int getImageFileForStoresCnt(String dNo) {
		return productDevDao.getimageFileForStoresCnt(dNo);
	}
	
}
