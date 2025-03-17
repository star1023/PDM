package kr.co.aspn.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.aspn.service.CommonService;
import kr.co.aspn.service.FileService;
import kr.co.aspn.util.FileUtil;
import kr.co.aspn.util.StringUtil;
import kr.co.aspn.vo.DevDocFileVO;
import kr.co.aspn.vo.FileVO;
import kr.co.aspn.vo.TrialReportFile;

@Controller
@RequestMapping("/file")
public class FileController {
	private Logger logger = LoggerFactory.getLogger(FileController.class);
	
	@Autowired
	FileService fileService;
	
	@Autowired
	private Properties config;
	
	@Autowired
	CommonService commonService;
	
	/**
	 * 파일 다운로드
	 * @param respose
	 * @param fileVO
	 */
	@RequestMapping(value="/fileDownload")
	public void fileDownload(HttpServletResponse respose, FileVO fileVO,HttpServletRequest request){
//		try{
//			logger.debug("org fileVo {}", fileVO);
//			fileVO.setFmNo("4866");
//			fileVO.setTbKey("102");
//			fileVO.setTbType("report");
//			logger.debug("change fileVo {}", fileVO);
//			fileVO = fileService.getOneFileInfo(fileVO);
//			logger.debug("select fileVo {}", fileVO);
//			if( fileVO.getIsOld() != null && "Y".equals(fileVO.getIsOld()) ) {
//				//옛날 파일 일때
//				String path = config.getProperty("old.file.root");
//				fileVO.setPath(path);
//				fileVO.setOrgFileName(fileVO.getFileName());
//				FileUtil.fileDownload(fileVO, respose);
//			} else {
//				if(fileVO.getPath()!= null && fileVO.getFileName() != null){
//					FileUtil.fileDownload(fileVO, respose);
//				} else {
//					//파일다운로드 되지 않았을때
//				}
//			}
//			
//		}catch(Exception e){
//			e.printStackTrace();
//		}
		
		try{
			fileVO = fileService.getOneFileInfo(fileVO);
			if( fileVO.getIsOld() != null && "Y".equals(fileVO.getIsOld()) ) {
				//옛날 파일 일때
				String path = config.getProperty("old.file.root");
				fileVO.setPath(path);
				fileVO.setOrgFileName(fileVO.getFileName());
				FileUtil.fileDownload(fileVO, respose);
			} else {
				if(fileVO.getPath()!= null && fileVO.getFileName() != null){
					FileUtil.fileDownload(fileVO, respose);
				} else {
					//파일다운로드 되지 않았을때
				}
			}
			
		}catch(Exception e){
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
		}
	}
	
	/**
	 * 파일 다운로드
	 * @param respose
	 * @param fileVO
	 */
	@RequestMapping(value="/multiFileDownload")
	public void multiFileDownload(HttpServletResponse response, String[] fmNo,HttpServletRequest request){
		try{
			Map<String,Object> param = new HashMap<String,Object>();
			String zipFile_path = config.getProperty("zip.file.path");
			param.put("fmNos", fmNo);
			List<FileVO> fileList = fileService.getFileInfo(param);
			logger.debug("select fileVo {}", fileList);
			
			List<String> sourceFiles = new ArrayList<String>();
			for( int i = 0 ; i < fileList.size() ; i++ ) {
				String sourceFile ="";
				FileVO fileVO = fileList.get(i);
				if( fileVO.getIsOld() != null && "Y".equals(fileVO.getIsOld()) ) {
					//옛날 파일 일때
					String path = config.getProperty("old.file.root");
					sourceFile = path+"/"+fileVO.getFileName();
				} else {
					if(fileVO.getPath()!= null && fileVO.getFileName() != null){
						sourceFile = fileVO.getPath()+"/"+fileVO.getFileName();
					}
				}
				sourceFiles.add(sourceFile);
			}
			FileUtil.multiFileDownload( sourceFiles, zipFile_path, response );
		}catch(Exception e){
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
		}
	}
	
	@RequestMapping(value = "/deleteFileAjax", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> deleteFileAjax(@RequestParam String fmNo, HttpServletResponse respose, HttpServletRequest request) throws Exception{
		try {
			FileVO fileVO = new FileVO();
			fileVO.setFmNo(fmNo);
			fileVO = fileService.getOneFileInfo(fileVO);
	
			String path = "";
			String isOld = fileVO.getIsOld();
			if( isOld != null && "Y".equals(isOld) ) {
				path = config.getProperty("old.file.root");
			} else {
				path = fileVO.getPath();
			}
			String fileName = fileVO.getFileName();
			String fullPath = path+"/"+fileName;
			File file = new File(fullPath);
			if(file.exists() == true){		
				file.delete();				// 해당 경로의 파일이 존재하면 파일 삭제
				logger.debug("파일 삭제 !");
			}
			int result = fileService.deleteFileInfo(fileVO);
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("result", result);
			
			return map;
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping(value="/downloadDevDocFile")
	public void downloadDevDocFile(HttpServletResponse respose, DevDocFileVO devDocFile,HttpServletRequest request){
		try{
			logger.debug("org fileVo {}", devDocFile);
			//devDocFile.setDdfNo("4866");
			logger.debug("change fileVo {}", devDocFile);
			devDocFile = fileService.getDevDocFileInfo(devDocFile);
			logger.debug("select fileVo {}", devDocFile);
			
			FileVO fileVO = new FileVO();
			fileVO.setPath(devDocFile.getPath());
			fileVO.setFileName(devDocFile.getFileName());
			fileVO.setOrgFileName(devDocFile.getOrgFileName());
			
			if( devDocFile.getIsOld() != null && "Y".equals(devDocFile.getIsOld()) ) {
				//옛날 파일 일때
				
				// TODO 제품개발문서 번호에 맞는 path 설정 필요
				String path = config.getProperty("old.file.root") + File.separator + "uploadImages" + File.separator + devDocFile.getPath();
				
				fileVO.setPath(path);
				fileVO.setOrgFileName(devDocFile.getFileName());
				FileUtil.fileDownload(fileVO, respose);
			} else {
				if(devDocFile.getPath()!= null && devDocFile.getFileName() != null){
					FileUtil.fileDownload(fileVO, respose);
				} else {
					//파일다운로드 되지 않았을때
				}
			}
			
		}catch(Exception e){
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
		}
	}
	
	@RequestMapping(value="/deleteDevDocFile")
	@ResponseBody
	public String deleteDevDocFile(DevDocFileVO devDocFile){
		devDocFile = fileService.getDevDocFileInfo(devDocFile);
		logger.debug("select fileVo {}", devDocFile);
		
		String path = "";
		String fullPath = "";
		int deleteCnt = 0;
		
		try {
			if( devDocFile.getIsOld() != null && "Y".equals(devDocFile.getIsOld()) ) {
				//path = config.getProperty("old.file.root");
				path = config.getProperty("old.file.root") + File.separator + "uploadImages" + File.separator + devDocFile.getPath();
			} else {
				path = devDocFile.getPath();
			}
			
			fullPath = path+"/"+devDocFile.getFileName();
			File file = new File(fullPath);
			if(file.exists() == true){
				if(file.delete()){ // 해당 경로의 파일이 존재하면 파일 삭제
					deleteCnt += fileService.deleteDevDocFile(devDocFile);
					logger.debug("파일 삭제 - deleteCnt: " + deleteCnt);
				} else {
					logger.debug("삭제할 경로에 해당하는 파일을 찾을 수 없습니다");
				}
				
			}
		} catch (Exception e) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			return "E";
		}
		
		if(deleteCnt > 0){
			return "S";
		} else {
			return "F";
		}
	}
	
	@RequestMapping(value = "/deleteImageFileAjax", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> deleteImageFileAjax(@RequestParam String fmNo, HttpServletResponse respose, HttpServletRequest request) throws Exception{
		try {
		FileVO fileVO = new FileVO();
		fileVO.setFmNo(fmNo);
		fileVO = fileService.imageFileInfo(fileVO);

		String path = fileVO.getPath();
		String fileName = fileVO.getFileName();
		String fullPath = path+"/"+fileName;
		File file = new File(fullPath);
		if(file.exists() == true){		
			file.delete();				// 해당 경로의 파일이 존재하면 파일 삭제
			logger.debug("파일 삭제 !");
		}
		int result = fileService.deleteImageFileInfo(fileVO);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("result", result);
		
		return map;
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	
	/**
	 * 23.07.17
	 * 시생산보고서 첨부파일 다운로드
	 * */
	@RequestMapping(value="/downloadtrialFile")
	public void downloadtrialFile(HttpServletResponse respose, TrialReportFile trialReprotFile,HttpServletRequest request){
		try{
			logger.debug("org trialReprotFile {}", trialReprotFile);
			//devDocFile.setDdfNo("4866");
			logger.debug("change trialReprotFile {}", trialReprotFile);
			trialReprotFile = fileService.getTrialFileInfo(trialReprotFile);
			logger.debug("select trialReprotFile {}", trialReprotFile);
			
			FileVO fileVO = new FileVO();
			fileVO.setPath(trialReprotFile.getPath());
			fileVO.setFileName(trialReprotFile.getFileName());
			fileVO.setOrgFileName(trialReprotFile.getOrgFileName());
			
			if(trialReprotFile.getPath()!= null && trialReprotFile.getFileName() != null){
				FileUtil.fileDownload(fileVO, respose);
			} else {
				logger.debug("해당 경로에 파일이 없습니다.");
				//파일다운로드 되지 않았을때
			}
			
		}catch(Exception e){
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
		}
	}
	
	/**
	 * 23.07.17
	 * 시생산보고서 첨부파일 삭제
	 * */
	@RequestMapping(value="/deleteTrialFile")
	@ResponseBody
	public String deleteTrialFile( TrialReportFile trialReprotFile){
		trialReprotFile = fileService.getTrialFileInfo(trialReprotFile);
		logger.debug("select trialReprotFile {}", trialReprotFile);
		
		String path = "";
		String fullPath = "";
		int deleteCnt = 0;
		
		try {
//			if( devDocFile.getIsOld() != null && "Y".equals(devDocFile.getIsOld()) ) {
				//옛날 파일 일때			
				// TODO 제품개발문서 번호에 맞는 path 설정 필요	
//				//path = config.getProperty("old.file.root");
//				path = config.getProperty("old.file.root") + File.separator + "uploadImages" + File.separator + devDocFile.getPath();
//			} else {
//				
//			}
			path = trialReprotFile.getPath();
			
			fullPath = path+"/"+trialReprotFile.getFileName();
			File file = new File(fullPath);
			if(file.exists() == true){
				if(file.delete()){ // 해당 경로의 파일이 존재하면 파일 삭제
					deleteCnt += fileService.deleteTrialFile(trialReprotFile);
					logger.debug("파일 삭제 - deleteCnt: " + deleteCnt);
				} else {
					logger.debug("삭제할 경로에 해당하는 파일을 찾을 수 없습니다");
				}	
			}
		} catch (Exception e) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			return "E";
		}
		
		if(deleteCnt > 0){
			return "S";
		} else {
			return "F";
		}
	}
}
