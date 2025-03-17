package kr.co.aspn.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import kr.co.aspn.common.auth.Auth;
import kr.co.aspn.common.auth.AuthUtil;
import kr.co.aspn.dao.QAReportDao;
import kr.co.aspn.service.FileService;
import kr.co.aspn.service.QAReportService;
import kr.co.aspn.util.FileUtil;
import kr.co.aspn.util.StringUtil;
import kr.co.aspn.vo.FileVO;
import kr.co.aspn.vo.QAReportVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class QAReportServiceImpl implements QAReportService {
	/* 인코딩 수정 */
	
	@Autowired
	private Properties config;
	
	@Autowired
	private FileService fileService;
	
	@Autowired
	private QAReportDao qaReportDao;
	
	
	/**
	 * 품질 보고서 목록 + 카운트
	 */
	@Override
	public Map<String, Object> selectQAReportListAndCount(Map<String, Object> param) throws Exception {
		Map<String, Object> res = new HashMap<String, Object>();
		
		// 목록 & 카운트
		List<QAReportVO> list = qaReportDao.selectQAReportList(param);
		int totalCount = qaReportDao.selectQAReportCount(param);
		
		res.put("list", list);
		res.put("totalCount", totalCount);
		return res;
	}
	
	/**
	 * 품질 보고서 상세
	 */
	@Override
	public Map<String, Object> selectQAReportDetail(int rNo) throws Exception {
		Map<String, Object> returnValue = new HashMap<String, Object>();
		Map<String, Object> paramValue = new HashMap<String, Object>();
		
		paramValue.put("tbKey", rNo);
		paramValue.put("tbType", "QAReport");
		
		returnValue.put("detail", qaReportDao.selectQAReportDetail(rNo));
		returnValue.put("files", fileService.fileList(paramValue));
		
		return returnValue;
	}
	
	/**
	 * 품질 보고서 첨부파일 등록
	 */
	@Override
	public boolean insertQAReportAttachFile(int rNo, List<MultipartFile> files) throws Exception {
		boolean result = true;
		
		// 업로드 경로
		final String appUpTempRoot = config.getProperty("upload.file.path.qareport");
		
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
						fileVO.setTbType("QAReport");
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
	 * 품질 보고서 첨부파일 삭제 
	 * ( 테이블 데이터, 실제 파일 ) 
	 */
	@Override
	public boolean deleteQAReportAttachFile(int rNo, int fmNo, String fileName) throws Exception {
		
		// 업로드 파일 경로
		final String appUpTempRoot = config.getProperty("upload.file.path.qareport");
		
		if( fmNo == 0 || StringUtil.isEmpty( fileName ) )
			return false;
		
		// Remove Real File
		boolean result1 = FileUtil.fileDelete(fileName, appUpTempRoot);
		
		// Delete Data
		FileVO fileVO = new FileVO(); 
		fileVO.setFmNo(fmNo+"");
		fileVO.setTbKey(rNo+"");
		fileVO.setTbType("qareport");
		int result2 = fileService.deleteFileInfo(fileVO);
		
		return ( result1 && result2 > 0 );
	}
	
	/**
	 * 품질 보고서 등록
	 */
	@Override
	public boolean insertQAReport(QAReportVO qaReportVO, HttpServletRequest request) throws Exception {
		MultipartHttpServletRequest multipartHttpServletRequest = (MultipartHttpServletRequest) request;
		List<MultipartFile> files = multipartHttpServletRequest.getFiles("file");
		
		// 로그인 사용자 아이디 가져오기
		Auth auth = AuthUtil.getAuth(request);
		qaReportVO.setCreateUser(auth.getUserId());
		
		qaReportDao.insertQAReport(qaReportVO);		// 보고서 데이터 등록
		int insertedIndex = qaReportVO.getRNo();	// 등록된 보고서 일련번호
		
		// 업로드 파일 등록
		boolean result = this.insertQAReportAttachFile(insertedIndex, files);
		
		return ( insertedIndex > 0 && result );
	}
	
	/**
	 * 품질 보고서 수정
	 */
	@Override
	public boolean updateQAReport(QAReportVO qaReportVO, HttpServletRequest request) throws Exception {
		MultipartHttpServletRequest multipartHttpServletRequest = (MultipartHttpServletRequest) request;
		List<MultipartFile> files = multipartHttpServletRequest.getFiles("file");
		String deletedIndex = (String) request.getParameter("delfile");
		log.debug("deletedIndex : {}", deletedIndex);
		
		// 로그인 사용자 아이디 가져오기
		Auth auth = AuthUtil.getAuth(request);
		qaReportVO.setChangeUser(auth.getUserId());
		
		qaReportDao.updateQAReport(qaReportVO);		// 보고서 데이터 업데이트
		int updatedIndex = qaReportVO.getRNo();
		
		// 신규 업로드 파일 등록
		boolean result1 = this.insertQAReportAttachFile(updatedIndex, files);
		
		// 기존 파일 삭제
		boolean result2 = true;
		if( StringUtil.isNotEmpty( deletedIndex ) ){
			String[] _arr = deletedIndex.split("\\|\\|");
			if( _arr != null && _arr.length > 0 ){
				for(int index = 0; index < _arr.length; index++){
					String fileName = _arr[index].split("@")[1];
					int fmNo = StringUtil.convInt(_arr[index].split("@")[0], 0);
					result2 = this.deleteQAReportAttachFile(updatedIndex, fmNo, fileName);
					if( result2 == false )
						return false;
				}
			}
		}
		return ( updatedIndex > 0 && result1 && result2 );
	}
	
	/**
	 * 품질 보고서 삭제
	 */
	@Override
	public boolean deleteQAReport(QAReportVO qaReportVO) throws Exception {
		int rNo;
		List<FileVO> files = new ArrayList<FileVO>();
		Map<String, Object> paramValue = new HashMap<String, Object>();
		
		
		// 보고서 정보 삭제
		qaReportDao.deleteQAReport(qaReportVO);
		rNo = qaReportVO.getRNo();
		
		if( rNo == 0 )
			return false;
		
		// 파일 목록 불러오기
		paramValue.put("tbKey", rNo);
		paramValue.put("tbType", "qareport");
		files = fileService.fileList(paramValue);
		
		if( files != null && files.size() > 0 ){
			for(FileVO fileVO : files) {
				int fmNo = StringUtil.convInt(fileVO.getFmNo(), 0);
				String fileName = fileVO.getOrgFileName();
				
				if(fmNo == 0)
					return false;
				
				// 등록된 파일 삭제 
				this.deleteQAReportAttachFile(rNo, fmNo, fileName);
			}
		}
		return true;
	}
}