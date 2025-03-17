package kr.co.aspn.service;

import org.springframework.web.multipart.MultipartFile;

import kr.co.aspn.vo.*;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 제품개발문서 > 시생산 보고서
 * @author JAEOH
 */

public interface TrialReportService {

    int trialReportCreate(HashMap<String, Object> param) throws Exception;

    String getReportTemplateContents(String reportTemplateNo, Map<String, Object> model)throws Exception;

    int changeTrialReportState(HashMap<String, Object> param);

    int updateTrialReportProperty(Object id, String key, Object value);

    int updateTrialReportCommentProperty(Object id, String key, Object value);

    TrialReportHeader getTrialReportHeaderVO(String rNo);

    List<TrialReportComment> getTrialReportComments(String rNo);

    List<TrialReportFile> getTrialReportFiles(String rNo);

    void trialReportAppr(String rNo);

    void trialReportAppr2(String rNo);

    Map<String, Object> getTrialReportListPage(Map<String, Object> param) throws Exception;

    int saveTrialReport(Map<String, Object> param) throws Exception;

    TrialReportFile saveTrialReportFile(TrialReportFile trialReportFile) throws Exception;

    List<TrialReportHeader> trialReportListForDevDocDetail(Map<String, Object> param);

    int checkoutTrialReport(Map<String, Object> param) throws Exception;

    int editCancel(Map<String, Object> param) throws Exception;
    
    /*23.07.17*/
	TrialReportFile insertTrialReportAttachFile(TrialReportFile trialReportFile) throws Exception;

	List<Map<String, Object>> getTrialReportAttachFiles(String rNo);
}