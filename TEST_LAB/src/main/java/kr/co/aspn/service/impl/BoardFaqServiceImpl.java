package kr.co.aspn.service.impl;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import kr.co.aspn.dao.BoardFaqDao;
import kr.co.aspn.dao.BoardNoticeDao;
import kr.co.aspn.dao.TestDao;
import kr.co.aspn.service.BoardFaqService;
import kr.co.aspn.service.BoardNoticeService;
import kr.co.aspn.util.FileUtil;
import kr.co.aspn.util.PageNavigator;

@Service
public class BoardFaqServiceImpl implements BoardFaqService {

    @Autowired
    BoardFaqDao boardFaqDao;

	@Autowired
	TestDao testDao;
    
	@Autowired
	private Properties config;
	
    @Override
    public int selectBoardFaqCount(Map<String, Object> param) {
        return boardFaqDao.selectBoardFaqCount(param);
    }

    @Override
    public Map<String, Object> selectBoardFaqList(Map<String, Object> param) throws Exception {
        int totalCount = boardFaqDao.selectBoardFaqCount(param);

        int viewCount = 10;
        int pageNo = 1;

        try {
            viewCount = Integer.parseInt(String.valueOf(param.get("viewCount")));
            pageNo = Integer.parseInt(String.valueOf(param.get("pageNo")));
        } catch (Exception e) {
            System.err.println("페이징 파라미터 오류: " + e.getMessage());
            viewCount = 10;
            pageNo = 1;
        }

        // PageNavigator를 통해 startRow, endRow 계산
        PageNavigator navi = new PageNavigator(param, viewCount, totalCount);

        List<Map<String, Object>> noticeList = boardFaqDao.selectBoardFaqList(param);

        Map<String, Object> result = new HashMap<>();
        result.put("pageNo", pageNo);
        result.put("totalCount", totalCount);
        result.put("list", noticeList);
        result.put("navi", navi); // PageNavigator 포함

        return result;
    }

    @Override
    public Map<String, Object> selectBoardFaqData(Map<String, Object> param) {
        Map<String, Object> data = boardFaqDao.selectBoardFaqData(param);
        Map<String, Object> result = new HashMap<>();
        result.put("data", data);
        return result;
    }
    
	@Override
	public List<Map<String, String>> selectHistory(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return boardFaqDao.selectHistory(param);
	}
	
	@Override
	public int insertFaq(Map<String, Object> param) throws Exception {
	    int noticeIdx = 0;
	    try {
	        // 공지사항 IDX 생성
	        noticeIdx = boardFaqDao.selectFaqSeq();
	        param.put("idx", noticeIdx);
	        
	        // 1. 공지사항 등록
	        boardFaqDao.insertFaq(param);

	    } catch (Exception e) {
	        throw e;
	    }
	    return noticeIdx;
	}
	
	@Override
	public Map<String, Object> selectFaqData(Map<String, Object> param) {
	    Map<String, Object> result = new HashMap<String, Object>();

	    // FAQ 데이터 조회
	    Map<String, String> faqData = boardFaqDao.selectFaqData(param);


	    result.put("data", faqData);

	    return result;
	}
    
	@Override
	public void updateFaq(Map<String, Object> param, MultipartFile[] files, String[] deletedFileList) throws Exception {
	    try {

	        // 1. FAQ 기본 정보 업데이트
	        boardFaqDao.updateFaq(param);

	    } catch (Exception e) {
	        System.err.println("[updateFaq] 오류 발생:");
	        e.printStackTrace();
	        throw e;
	    }
	}
	
	@Override
	public void deleteFaq(Map<String, Object> param) throws Exception {
		boardFaqDao.updateIsDeleteY(param); // is_delete = 'Y'로 업데이트
	}
	
}