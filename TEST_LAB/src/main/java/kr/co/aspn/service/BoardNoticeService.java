package kr.co.aspn.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;


public interface BoardNoticeService {

    int selectBoardNoticeCount(Map<String, Object> param);

    Map<String, Object> selectBoardNoticeList(Map<String, Object> param) throws Exception;

    Map<String, Object> selectBoardNoticeData(Map<String, Object> param);
    
    List<Map<String, String>> selectHistory(Map<String, Object> param);
    
    int insertNotice(Map<String, Object> param, MultipartFile[] file) throws Exception;
    
    Map<String, Object> selectNoticeData(Map<String, Object> param);
    
    void updateNotice(Map<String, Object> param, MultipartFile[] files, String[] deletedFileList) throws Exception;
    
    int updateHits(Map<String, Object> param) throws Exception;
    
    void deleteNotice(Map<String, Object> param) throws Exception;
}