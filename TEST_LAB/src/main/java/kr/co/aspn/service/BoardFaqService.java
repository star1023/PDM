package kr.co.aspn.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;


public interface BoardFaqService {

    int selectBoardFaqCount(Map<String, Object> param);

    Map<String, Object> selectBoardFaqList(Map<String, Object> param) throws Exception;

    Map<String, Object> selectBoardFaqData(Map<String, Object> param);
    
    List<Map<String, String>> selectHistory(Map<String, Object> param);
    
    int insertFaq(Map<String, Object> param) throws Exception;
    
    Map<String, Object> selectFaqData(Map<String, Object> param);
    
    void updateFaq(Map<String, Object> param, MultipartFile[] files, String[] deletedFileList) throws Exception;
    
    void deleteFaq(Map<String, Object> param) throws Exception;
}