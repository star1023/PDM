package kr.co.aspn.service.impl;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.aspn.dao.FileDao;
import kr.co.aspn.dao.ReportDao;
import kr.co.aspn.service.FileService;
import kr.co.aspn.vo.DevDocFileVO;
import kr.co.aspn.vo.FileVO;
import kr.co.aspn.vo.TrialReportFile;

@Service
public class FileServiceImpl implements FileService {
	@Autowired 
	FileDao fileDao;
	@Override
	public List<FileVO> fileList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return fileDao.fileList(param);
	}
	@Override
	public FileVO getOneFileInfo(FileVO fileVO) throws Exception {
		// TODO Auto-generated method stub
		return fileDao.getOneFileInfo(fileVO);
		
	}
	@Override
	public void insertFile(FileVO fileVO) throws Exception {
		// TODO Auto-generated method stub
		fileDao.insertFile(fileVO);
	}
	@Override
	public int deleteFileInfo(FileVO fileVO) throws Exception {
		// TODO Auto-generated method stub
		return fileDao.deleteFile(fileVO);
	}
	@Override
	public List<FileVO> getFileInfo(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return fileDao.getFileInfo(param);
	}
	@Override
	public int insertDevDocFile(DevDocFileVO devDocFile) {
		return fileDao.insertDevDocFile(devDocFile);
	}
	
	@Override
	public DevDocFileVO getDevDocFileInfo(DevDocFileVO devDocFile) {
		return fileDao.getDevDocFileInfo(devDocFile);
	}

	@Override
	public int deleteDevDocFile(DevDocFileVO devDocFile) {
		return fileDao.deleteDevDocFile(devDocFile);
	}
	@Override
	public void insertImageFile(FileVO fileVO) throws Exception {
		// TODO Auto-generated method stub
		fileDao.insertImageFile(fileVO);
	}
	
	@Override
	public List<FileVO> imageFileList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return fileDao.imageFileList(param);
	}
	@Override
	public FileVO imageFileInfo(FileVO fileVO) throws Exception {
		// TODO Auto-generated method stub
		return fileDao.imageFileInfo(fileVO);
	}
	@Override
	public int deleteImageFileInfo(FileVO fileVO) throws Exception {
		// TODO Auto-generated method stub
		return fileDao.deleteImageFile(fileVO);
	}
	
	@Override
	public void deleteAllFile(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		List<FileVO> fileList = fileDao.fileList(param);
		if( fileList != null ) {
			for( int i = 0 ; i < fileList.size() ; i++ ) {
				FileVO fileVO = fileList.get(i);
				String path = "";
				String isOld = fileVO.getIsOld();
				if( isOld != null && "Y".equals(isOld) ) {
					path = "C:/TDDOWNLOAD";
				} else {
					path = fileVO.getPath();
				}
				String fileName = fileVO.getFileName();
				String fullPath = path+"/"+fileName;
				File file = new File(fullPath);
				if(file.exists() == true){		
					file.delete();				// 해당 경로의 파일이 존재하면 파일 삭제
				}
				fileDao.deleteFile(fileVO);
			}
		}
	}
	@Override
	public void deleteAllImageFile(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		List<FileVO> fileList = fileDao.imageFileList(param);
		if( fileList != null ) {
			for( int i = 0 ; i < fileList.size() ; i++ ) {
				FileVO fileVO = fileList.get(i);
				String path = fileVO.getPath();
				String fileName = fileVO.getFileName();
				String fullPath = path+"/"+fileName;
				File file = new File(fullPath);
				if(file.exists() == true){		
					file.delete();				// 해당 경로의 파일이 존재하면 파일 삭제
				}
				fileDao.deleteImageFile(fileVO);
			}
		}
	}
	
	@Override
	public List<DevDocFileVO> getDevDocFileList(HashMap<String, Object> param) {
		return fileDao.getDevDocFileList(param);
	}
	@Override
	public List<FileVO> fileList_1(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return fileDao.fileList_1(param);
	}
	
	//230714
	@Override
	public TrialReportFile getTrialFileInfo(TrialReportFile trialReprotFile) {
		return fileDao.getTrialFileInfo(trialReprotFile);
	}
	
	@Override
	public int deleteTrialFile(TrialReportFile trialReprotFile) {
		return fileDao.deleteTrialFile(trialReprotFile);
	}
	@Override
	public Map<String, Object> selectFileData(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return fileDao.selectFileData(param);
	}
	@Override
	public void deleteFileData(Map<String, Object> param) {
		// TODO Auto-generated method stub
		fileDao.deleteFileData(param);
	}
}
