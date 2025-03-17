package kr.co.aspn.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.co.aspn.vo.DevDocFileVO;
import kr.co.aspn.vo.FileVO;
import kr.co.aspn.vo.TrialReportFile;

public interface FileService {

	List<FileVO> fileList(Map<String, Object> param) throws Exception;

	List<FileVO> fileList_1(Map<String, Object> param) throws Exception;
	
	//FileVO fileDownload(FileVO fileVO) throws Exception;

	FileVO getOneFileInfo(FileVO fileVO) throws Exception;
	
	void insertFile(FileVO fileVO) throws Exception;
	
	int deleteFileInfo(FileVO fileVO) throws Exception;
	
	List<FileVO> getFileInfo(Map<String, Object> param) throws Exception;

	DevDocFileVO getDevDocFileInfo(DevDocFileVO devDocFile);

	int insertDevDocFile(DevDocFileVO devDocFile);

	void insertImageFile(FileVO fileVO) throws Exception;

	//int deleteFile(Map<String, Object> param) throws Exception;

	List<FileVO> imageFileList(Map<String, Object> param) throws Exception;

	FileVO imageFileInfo(FileVO fileVO) throws Exception;

	int deleteImageFileInfo(FileVO fileVO) throws Exception;

	int deleteDevDocFile(DevDocFileVO devDocFile);

	//void deleteImageFile(Map<String, Object> param) throws Exception;

	void deleteAllImageFile(Map<String, Object> param) throws Exception;

	void deleteAllFile(Map<String, Object> param) throws Exception;

	List<DevDocFileVO> getDevDocFileList(HashMap<String, Object> param);

	//230714
	TrialReportFile getTrialFileInfo(TrialReportFile trialReprotFile);

	int deleteTrialFile(TrialReportFile trialReprotFile);
}
