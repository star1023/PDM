package kr.co.aspn.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.co.aspn.vo.TrialReportComment;
import kr.co.aspn.vo.TrialReportFile;
import kr.co.aspn.vo.TrialReportHeader;

/**
 * 제품개발문서 > 시생산 보고서
 * @author JAEOH
 */

public interface TrialReportDao {

	int trialReportCreate(TrialReportHeader trialProductionReportHeader);

    int trialReportCommentCreate(List<TrialReportComment> trialProductionReportComments);

    int changeTrialReportState(HashMap<String, Object> param);

    int updateTrialReportProperty(HashMap<String, Object> param);

    TrialReportHeader getTrialReportHeaderVO(String rNo);

    List<TrialReportComment> getTrialReportComment(String rNo);

    List<TrialReportFile> getTrialReportFiles(String rNo);

    Map<String,Object> trialReportListCount(Map<String, Object> param);

    List<Map<String,Object>> trialReportListPage(Map<String, Object> param);

    int saveTrialReportHeader(Map<String, Object> param);

    int saveTrialReportComment(Map<String, Object> param);

    int insertTrialReportFile(TrialReportFile trialReportFile);

    int updateTrialReportFile(TrialReportFile trialReportFile);

    List<TrialReportHeader> trialReportListForDevDocDetail(Map<String, Object> param);

    int updateTrialReportCommentProperty(Map<String, Object> param);

    // 23.07.17
	List<Map<String, Object>> getTrialReportAttachFiles(HashMap<String, Object> param);
}