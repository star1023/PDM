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

import kr.co.aspn.dao.BoardNoticeDao;
import kr.co.aspn.dao.TestDao;
import kr.co.aspn.service.BoardNoticeService;
import kr.co.aspn.util.FileUtil;
import kr.co.aspn.util.PageNavigator;

@Service
public class BoardNoticeServiceImpl implements BoardNoticeService {

    @Autowired
    BoardNoticeDao boardNoticeDao;

	@Autowired
	TestDao testDao;
    
	@Autowired
	private Properties config;
	
    @Override
    public int selectBoardNoticeCount(Map<String, Object> param) {
        return boardNoticeDao.selectBoardNoticeCount(param);
    }

    @Override
    public Map<String, Object> selectBoardNoticeList(Map<String, Object> param) throws Exception {
        int totalCount = boardNoticeDao.selectBoardNoticeCount(param);

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

        List<Map<String, Object>> noticeList = boardNoticeDao.selectBoardNoticeList(param);

        Map<String, Object> result = new HashMap<>();
        result.put("pageNo", pageNo);
        result.put("totalCount", totalCount);
        result.put("list", noticeList);
        result.put("navi", navi); // PageNavigator 포함

        return result;
    }

    @Override
    public Map<String, Object> selectBoardNoticeData(Map<String, Object> param) {
        Map<String, Object> data = boardNoticeDao.selectBoardNoticeData(param);
        Map<String, Object> result = new HashMap<>();
        result.put("data", data);
        return result;
    }
    
	@Override
	public List<Map<String, String>> selectHistory(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return boardNoticeDao.selectHistory(param);
	}
	
	@Override
	public int insertNotice(Map<String, Object> param, MultipartFile[] file) throws Exception {
	    int noticeIdx = 0;
	    try {
	        // 공지사항 IDX 생성
	        noticeIdx = boardNoticeDao.selectNoticeSeq();
	        param.put("idx", noticeIdx);

	        // 현재 날짜 기준 폴더 생성용 yyyyMM
	        Calendar cal = Calendar.getInstance();
	        Date now = cal.getTime();
	        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
	        String today = sdf.format(now);

	        String path = config.getProperty("upload.file.path.notice") + "/" + today;

	        // 1. 공지사항 등록
	        boardNoticeDao.insertNotice(param);

	        // 2. 첨부파일 저장
	        if (file != null && file.length > 0) {
	            for (MultipartFile multipartFile : file) {
	                System.err.println("===============================");
	                System.err.println("isEmpty : " + multipartFile.isEmpty());
	                System.err.println("name : " + multipartFile.getName());
	                System.err.println("originalFilename : " + multipartFile.getOriginalFilename());
	                System.err.println("size : " + multipartFile.getSize());
	                System.err.println("===============================");

	                try {
	                    if (!multipartFile.isEmpty()) {
	                        String fileIdx = FileUtil.getUUID();
	                        String result = FileUtil.upload3(multipartFile, path, fileIdx);
	                        String content = FileUtil.getPdfContents(path, result);

	                        Map<String, Object> fileMap = new HashMap<>();
	                        fileMap.put("fileIdx", fileIdx);
	                        fileMap.put("docIdx", noticeIdx);
	                        fileMap.put("docType", "NOTICE");
	                        fileMap.put("fileType", "00"); // 필요 시 외부에서 값 받아서 수정 가능
	                        fileMap.put("orgFileName", multipartFile.getOriginalFilename());
	                        fileMap.put("filePath", path);
	                        fileMap.put("changeFileName", result);
	                        fileMap.put("content", content);

	                        testDao.insertFileInfo(fileMap);
	                    }
	                } catch (Exception e) {
	                    // 개별 파일 저장 실패는 전체 실패로 이어지지 않도록 로그만 출력
	                    e.printStackTrace();
	                }
	            }
	        }

	        // 3. 히스토리 저장
	        Map<String, Object> historyParam = new HashMap<>();
	        historyParam.put("docIdx", noticeIdx);
	        historyParam.put("docType", "NOTICE");
	        historyParam.put("historyType", "I");
	        historyParam.put("historyData", param.toString());
	        historyParam.put("userId", param.get("userId"));
	        testDao.insertHistory(historyParam);

	    } catch (Exception e) {
	        throw e;
	    }
	    return noticeIdx;
	}
	
	@Override
	public Map<String, Object> selectNoticeData(Map<String, Object> param) {
	    Map<String, Object> result = new HashMap<String, Object>();

	    // 공지사항 본문 데이터 조회
	    Map<String, String> noticeData = boardNoticeDao.selectNoticeData(param);

	    // 첨부파일 리스트 조회
	    param.put("docType", "NOTICE"); // 문서 타입 명확하게 설정 (필요 시 변경)
	    List<Map<String, String>> fileList = testDao.selectFileList(param);

	    result.put("data", noticeData);
	    result.put("fileList", fileList);

	    return result;
	}
    
	@Override
	public void updateNotice(Map<String, Object> param, MultipartFile[] files, String[] deletedFileList) throws Exception {
	    try {
	        // 날짜 폴더 구성
	        Calendar cal = Calendar.getInstance();
	        String toDay = new SimpleDateFormat("yyyyMM").format(cal.getTime());

	        // 파일 저장 경로
	        String basePath = config.getProperty("upload.file.path.notice"); // 예: /aspn/pdm/upload/notice
	        String savePath = basePath + "/" + toDay;

	        // 1. 공지사항 본문 및 기본 정보 업데이트
	        boardNoticeDao.updateNotice(param); // param에는 idx, title, type, dates, contents 등이 포함됨

	        // 2. 기존 파일 삭제 처리
	        if (deletedFileList != null) {
	            for (String fileIdx : deletedFileList) {
	                if (fileIdx == null || fileIdx.trim().isEmpty()) continue;

	                Map<String, Object> fileParam = new HashMap<>();
	                fileParam.put("idx", fileIdx);
	                Map<String, String> fileData = testDao.selectFileData(fileParam);

	                if (fileData == null) {
	                    System.err.println("❌ 삭제할 파일 데이터 없음 (FILE_IDX=" + fileIdx + ")");
	                    continue;
	                }

	                String filePath = fileData.get("FILE_PATH");
	                String fileName = fileData.get("FILE_NAME");

	                if (filePath != null && fileName != null) {
	                    File fileToDelete = new File(filePath + File.separator + fileName);
	                    System.err.println("🧾 삭제 대상: " + fileToDelete.getAbsolutePath());

	                    if (fileToDelete.exists()) {
	                        boolean deleted = fileToDelete.delete();
	                        if (deleted) {
	                            System.err.println("✅ 삭제 성공");
	                        } else {
	                            System.err.println("❌ 삭제 실패 (파일 존재함)");
	                        }
	                    } else {
	                        System.err.println("❌ 파일 존재하지 않음");
	                    }
	                }

	                testDao.deleteFileData(fileIdx); // DB 삭제는 계속 수행
	            }
	        }

	        // 3. 신규 파일 업로드 및 저장
	        if (files != null && files.length > 0) {
	            for (MultipartFile multipartFile : files) {
	                if (multipartFile != null && !multipartFile.isEmpty()) {
	                    String fileIdx = FileUtil.getUUID();
	                    String storedFileName = FileUtil.upload3(multipartFile, savePath, fileIdx);

	                    Map<String, Object> fileMap = new HashMap<>();
	                    fileMap.put("fileIdx", fileIdx);
	                    fileMap.put("docIdx", param.get("idx"));
	                    fileMap.put("docType", "NOTICE");
	                    fileMap.put("fileType", "00");
	                    fileMap.put("orgFileName", multipartFile.getOriginalFilename());
	                    fileMap.put("changeFileName", storedFileName);
	                    fileMap.put("filePath", savePath);

	                    testDao.insertFileInfo(fileMap);
	                }
	            }
	        }

	        // 4. 히스토리 기록 (선택)
	        Map<String, Object> history = new HashMap<>();
	        history.put("docIdx", param.get("idx"));
	        history.put("docType", "NOTICE");
	        history.put("historyType", "U");
	        history.put("historyData", param.toString());
	        history.put("userId", param.get("userId"));
	        testDao.insertHistory(history);

	    } catch (Exception e) {
	        System.err.println("[updateNotice] 오류 발생:");
	        e.printStackTrace();
	        throw e;
	    }
	}
	
	@Override
	public int updateHits(Map<String, Object> param) throws Exception {
	    return boardNoticeDao.updateHits(param);
	}
}