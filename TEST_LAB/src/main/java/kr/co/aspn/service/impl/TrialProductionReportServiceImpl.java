package kr.co.aspn.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;

import kr.co.aspn.common.auth.Auth;
import kr.co.aspn.common.auth.AuthUtil;
import kr.co.aspn.dao.ProductDevDao;
import kr.co.aspn.dao.TrialProductionReportDao;
import kr.co.aspn.service.FileService;
import kr.co.aspn.service.ProductDevService;
import kr.co.aspn.service.TrialProductionReportService;
import kr.co.aspn.util.FileUtil;
import kr.co.aspn.util.StringUtil;
import kr.co.aspn.vo.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import lombok.extern.slf4j.Slf4j;

/**
 * 제품개발문서 > 시생산 보고서
 * @author JAEOH
 */

@Slf4j
@Service
public class TrialProductionReportServiceImpl implements TrialProductionReportService {
	
	@Autowired
	private Properties config;
	
	@Autowired
	private FileService fileService;
	
	@Autowired
	ProductDevService productDevService;
	
	@Autowired
	private TrialProductionReportDao dao;

	@Autowired
	ProductDevDao productDevDao;

	@Autowired
	PlatformTransactionManager txManager;
	
	/**
	 * 시생산 보고서 리스트 + 카운트
	 */
	@Override
	public Map<String, Object> selectTrialProductionReportListAndCount(Map<String, Object> param) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("list", this.selectTrialProductionReportList(param));
		map.put("count", this.selectTrialProductionReportCount(param));
		return map;
	}
	
	/**
	 * 시생산 보고서 리스트
	 */
	@Override
	public List<TrialProductionReportVO> selectTrialProductionReportList(Map<String, Object> param) throws Exception {
		return dao.selectTrialProductionReportList(param);
	}
	
	/**
	 * 시생산 보고서 카운트
	 */
	@Override
	public int selectTrialProductionReportCount(Map<String, Object> param) throws Exception {
		return dao.selectTrialProductionReportCount(param);
	}
	
	/**
	 * 시생산 보고서 상세
	 */
	public Map<String, Object> selectTrialProductionReportDetail(Map<String, Object> param) throws Exception {
		
		Map<String, Object> returnValue = new HashMap<String, Object>();
		Map<String, Object> paramValue = new HashMap<String, Object>();
		int rNo = 0;
		
		try {
			
			String rNoString = StringUtil.nvl(param.get("rNo"), "");
//			String docNoString = StringUtil.nvl(param.get("docNo"), "");
//			String docVersionString = StringUtil.nvl(param.get("docVersion"), "");
			
			if(StringUtil.isNotEmpty( rNoString )){
				rNo = StringUtil.convInt(rNoString, 0);
				if( rNo != 0 )
					paramValue.put("tbKey", rNo);
			}
			
//			if(StringUtil.isNotEmpty( docNoString ) && StringUtil.isNotEmpty( docVersionString )){
//				returnValue.put("productDevDoc", productDevService.getProductDevDoc(docNoString, docVersionString));
//			}
			
		}catch(Exception _ex){
			_ex.printStackTrace();
			rNo = 0;
		}
		
		paramValue.put("tbType", "trialprodreport");
		
		returnValue.put("detail", dao.selectTrialProductionReportDetail(rNo));
		returnValue.put("files", fileService.fileList(paramValue));
		
		return returnValue;
	}
	
	/**
	 * 라인코드 이름 가져오기
	 */
	@Override
	public PlantLineVO selectLineDetailFromPlantLine(Map<String, Object> param) throws Exception {
		return dao.selectLineDetailFromPlantLine(param);
	}
	
	/**
	 * 시생산 보고서 첨부파일 등록
	 */
	public boolean insertAttachFile(int rNo, List<MultipartFile> files) throws Exception {
		boolean result = true;
		
		// 업로드 경로
		final String appUpTempRoot = config.getProperty("upload.file.path.trialprodreport");
		
		// HttpServeltRequest 객체 생성
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
		
		// 로그인 사용자 아이디 가져오기
		Auth auth = AuthUtil.getAuth(request);
		
		if( files != null && files.size() > 0 ){
			try {
				for(int index = 0; index < files.size(); index++){
					FileVO fileVO = new FileVO();
					
					// 파일 업로드 (저장)
					String fileName = FileUtil.upload(files.get(index),appUpTempRoot);
					
					// Insert Data
					if( StringUtil.isNotEmpty(fileName) ){
						fileVO.setTbKey(rNo+"");
						fileVO.setTbType("trialprodreport");
						fileVO.setOrgFileName(files.get(index).getOriginalFilename());
						fileVO.setRegUserId(auth.getUserId());
						fileVO.setFileName(fileName);
						fileVO.setPath(appUpTempRoot);
						fileService.insertFile(fileVO);
					}
				}
			}catch(Exception e){
				e.printStackTrace();
				result = false;
			}
		}
		return result;
	}
	
	/**
	 * 시생산 보고서 첨부파일 삭제 
	 */
	@Override
	public boolean deleteAttachFile(int rNo, int fmNo, String fileName) throws Exception {
		
		// 업로드 파일 경로
		final String appUpTempRoot = config.getProperty("upload.file.path.trialprodreport");
		
		if( fmNo == 0 || StringUtil.isEmpty( fileName ) )
			return false;
		
		// Remove Real File
		boolean result1 = FileUtil.fileDelete(fileName, appUpTempRoot);
		
		// Delete Data
		FileVO fileVO = new FileVO(); 
		fileVO.setFmNo(fmNo+"");
		fileVO.setTbKey(rNo+"");
		fileVO.setTbType("trialprodreport");
		int result2 = fileService.deleteFileInfo(fileVO);
		
		return ( result1 && result2 > 0 );
	}
	
	/**
	 * 시생산 보고서 등록
	 */
	@Override
	@Transactional
	public boolean insertTrialProductionReport(TrialProductionReportVO trialProductionReportVO, HttpServletRequest request) throws Exception {
		
		MultipartHttpServletRequest multipartHttpServletRequest = (MultipartHttpServletRequest) request;
		List<MultipartFile> files = multipartHttpServletRequest.getFiles("file");
		
		// 로그인 사용자 아이디 가져오기
		Auth auth = AuthUtil.getAuth(request);
		trialProductionReportVO.setCreateUser(auth.getUserId());
		
		// 시생산 보고서 등록
		dao.insertTrialProductionReport(trialProductionReportVO);
		int insertedIndex = trialProductionReportVO.getRNo();
		
		// 첨부파일 등록
		boolean result = this.insertAttachFile(insertedIndex, files);
		
		return ( insertedIndex > 0 && result );
	}

	/**
	 * 시생산 보고서 수정
	 */
	@Override
	@Transactional
	public boolean updateTrialProductionReport(TrialProductionReportVO trialProductionReportVO, HttpServletRequest request) throws Exception {
		
		MultipartHttpServletRequest multipartHttpServletRequest = (MultipartHttpServletRequest) request;
		List<MultipartFile> files = multipartHttpServletRequest.getFiles("file");
		String deletedIndex = (String) request.getParameter("delfile");
		log.debug("updateTrialProductionReport ==> deletedIndex : {}", deletedIndex);
		
		// 로그인 사용자 아이디 가져오기
		Auth auth = AuthUtil.getAuth(request);
		trialProductionReportVO.setChangeUser(auth.getUserId());
		
		// 시생산 보고서 수정
		dao.updateTrialProductionReport(trialProductionReportVO);
		int updatedIndex = trialProductionReportVO.getRNo();
		
		// 신규 업로드 파일 등록
		boolean result1 = this.insertAttachFile(updatedIndex, files);
		
		// 기존 파일 삭제
		boolean result2 = true;
		if( StringUtil.isNotEmpty( deletedIndex ) ){
			String[] _arr = deletedIndex.split("\\|\\|");
			if( _arr != null && _arr.length > 0 ){
				for(int index = 0; index < _arr.length; index++){
					String fileName = _arr[index].split("@")[1];
					int fmNo = StringUtil.convInt(_arr[index].split("@")[0], 0);
					result2 = this.deleteAttachFile(updatedIndex, fmNo, fileName);
					if( result2 == false )
						return false;
				}
			}
		}
		
		return (updatedIndex > 0 && result1 && result2);
	}
	
	/**
	 * 시생산 보고서 상태 변경
	 */
	@Override
	public boolean updateTrialProductionReportState(TrialProductionReportVO trialProductionReportVO, HttpServletRequest request) throws Exception {
		// 로그인 사용자 아이디 가져오기
		Auth auth = AuthUtil.getAuth(request);
		trialProductionReportVO.setChangeUser(auth.getUserId());
		
		// 상태 변경
		int updatedIndex = dao.updateTrialProductionReportState(trialProductionReportVO);
		
		return (updatedIndex > 0);
	}
	

	/**
	 * 시생산 보고서 삭제
	 */
	@Override
	public boolean deleteTrialProductionReport(int rNo) throws Exception {
		Map<String, Object> paramValue = new HashMap<String, Object>();
		List<FileVO> files = new ArrayList<FileVO>();
		
		if( rNo == 0 )
			return false;
		
		// 보고서 정보 삭제
		TrialProductionReportVO trialProductionReportVO = new TrialProductionReportVO();
		trialProductionReportVO.setRNo(rNo);
		dao.deleteTrialProductionReport(trialProductionReportVO);
		
		// 파일 목록 불러오기
		paramValue.put("tbKey", rNo);
		paramValue.put("tbType", "trialprodreport");
		files = fileService.fileList(paramValue);
		
		if( files != null && files.size() > 0 ){
			for(FileVO fileVO : files) {
				int fmNo = StringUtil.convInt(fileVO.getFmNo(), 0);
				String fileName = fileVO.getOrgFileName();
				
				if(fmNo == 0)
					return false;
				
				// 등록된 파일 삭제 
				this.deleteAttachFile(rNo, fmNo, fileName);
			}
		}
		return true;
	}
	
	@Override
	public int getTrialDocumentCnt(Map<String, Object> param) {
		return dao.getTrialDocumentCnt(param);
	}

}