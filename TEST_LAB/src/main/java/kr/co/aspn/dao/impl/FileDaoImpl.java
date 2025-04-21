package kr.co.aspn.dao.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.aspn.dao.FileDao;
import kr.co.aspn.vo.DevDocFileVO;
import kr.co.aspn.vo.FileVO;
import kr.co.aspn.vo.TrialReportFile;

@Repository
public class FileDaoImpl implements FileDao {
	@Autowired
	SqlSessionTemplate sqlSessionTemplate;
	
	@Override
	public List<FileVO> fileList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("file.fileList", param);
	}

	@Override
	public FileVO getOneFileInfo(FileVO fileVO) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("file.getOneFileInfo", fileVO);
	}

	@Override
	public void insertFile(FileVO fileVO) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("file.insertFile", fileVO);
	}

	@Override
	public int deleteFile(FileVO fileVO) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.delete("file.deleteFile", fileVO);
	}

	@Override
	public List<FileVO> getFileInfo(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("file.fileInfo", param);
	}

	@Override
	public int insertDevDocFile(DevDocFileVO devDocFile) {
		return sqlSessionTemplate.insert("file.insertDevDocFile", devDocFile);
	}

	@Override
	public void insertImageFile(FileVO fileVO) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("file.insertImageFile", fileVO);
	}

	@Override
	public List<FileVO> imageFileList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("file.imageFileList", param);
	}

	@Override
	public FileVO imageFileInfo(FileVO fileVO) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("file.imageFileInfo", fileVO);
	}

	@Override
	public int deleteImageFile(FileVO fileVO) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.delete("file.deleteImageFile", fileVO);
	}


	@Override
	public DevDocFileVO getDevDocFileInfo(DevDocFileVO devDocFile) {
		return sqlSessionTemplate.selectOne("file.getDevDocFileInfo", devDocFile); 
	}

	@Override
	public int deleteDevDocFile(DevDocFileVO devDocFile) {
		return sqlSessionTemplate.delete("file.deleteDevDocFile", devDocFile);
	}

	//@Override
	//public int deleteFile(Map<String, Object> param) throws Exception {
	//	// TODO Auto-generated method stub
	//	return sqlSessionTemplate.delete("file.deleteFileByTbKey", param);
	//}
	
	@Override
	public List<DevDocFileVO> getDevDocFileList(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectList("file.getDevDocFileList", param);
	}
	
	@Override
	public int deleteDevDocList(HashMap<String, Object> param) {
		return sqlSessionTemplate.delete("file.deleteDevDocList", param);
	}

	@Override
	public List<FileVO> fileList_1(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("file.fileList_1", param);
	}

	//230714
	@Override
	public TrialReportFile getTrialFileInfo(TrialReportFile trialReprotFile) {
		return sqlSessionTemplate.selectOne("file.getTrialFileInfo",trialReprotFile);
	}

	@Override
	public int deleteTrialFile(TrialReportFile trialReprotFile) {
		return sqlSessionTemplate.delete("file.deleteTrialFile", trialReprotFile);
	}

	@Override
	public Map<String, Object> selectFileData(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("file.selectFileData", param);
	}

	@Override
	public void deleteFileData(Map<String, Object> param) {
		// TODO Auto-generated method stub
		sqlSessionTemplate.delete("file.deleteFileData", param);
	}
}
