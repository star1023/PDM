package kr.co.aspn.dao;

import java.util.List;
import java.util.Map;

public interface BoardNoticeDao {

    int selectBoardNoticeCount(Map<String, Object> param);

    List<Map<String, Object>> selectBoardNoticeList(Map<String, Object> param);

    Map<String, Object> selectBoardNoticeData(Map<String, Object> param);
    
    List<Map<String, String>> selectHistory(Map<String, Object> param);
    
    int selectNoticeSeq();
    
    void insertNotice(Map<String, Object> param) throws Exception;
    
    Map<String, String> selectNoticeData(Map<String, Object> param);
    
    void updateNotice(Map<String, Object> param);
    
    int updateHits(Map<String, Object> param);
    
    void updateIsDeleteY(Map<String, Object> param);
    
}