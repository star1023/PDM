package kr.co.aspn.dao;

import java.util.List;
import java.util.Map;

public interface BoardFaqDao {

    int selectBoardFaqCount(Map<String, Object> param);

    List<Map<String, Object>> selectBoardFaqList(Map<String, Object> param);

    Map<String, Object> selectBoardFaqData(Map<String, Object> param);
    
    List<Map<String, String>> selectHistory(Map<String, Object> param);
    
    int selectFaqSeq();
    
    void insertFaq(Map<String, Object> param) throws Exception;
    
    Map<String, String> selectFaqData(Map<String, Object> param);
    
    void updateFaq(Map<String, Object> param);
 
    void updateIsDeleteY(Map<String, Object> param);
}