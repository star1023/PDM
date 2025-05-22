package kr.co.aspn.service.impl;


import kr.co.aspn.dao.ProductDevDao;
import kr.co.aspn.dao.TrialReportDao;
import kr.co.aspn.service.FileService;
import kr.co.aspn.service.ProductDevService;
import kr.co.aspn.service.TrialReportService;
import kr.co.aspn.util.DateUtil;
import kr.co.aspn.util.FileUtil;
import kr.co.aspn.util.PageNavigator;
import kr.co.aspn.util.StringUtil;
import kr.co.aspn.vo.*;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.apache.velocity.app.VelocityEngine;

import java.nio.charset.StandardCharsets;
import java.util.*;

/**
 * 제품개발문서 > 시생산 보고서
 * @author JAEOH
 */

@Slf4j
@Service
public class TrialReportServiceImpl implements TrialReportService {

	private Logger logger = LoggerFactory.getLogger(TrialReportServiceImpl.class);

	@Autowired
	private Properties config;

	@Autowired
	private FileService fileService;

	@Autowired
	ProductDevService productDevService;

	@Autowired
	private TrialReportDao trialReportDao;

	@Autowired
	ProductDevDao productDevDao;

	@Autowired
	PlatformTransactionManager txManager;

	@Autowired
	VelocityEngine velocityEngine;

	@Override
	public int trialReportCreate(HashMap<String,Object> param) throws Exception {
		// TODO test
		int rNo = 0;

		TrialReportHeader trialProductionReportHeader = new TrialReportHeader();
		trialProductionReportHeader.setCreateUser(StringUtil.nvl(param.get("createUser")));
		trialProductionReportHeader.setDNo(StringUtil.nvl(param.get("dNo")));
		trialProductionReportHeader.setLine(StringUtil.nvl(param.get("line")));
		trialProductionReportHeader.setState("00");
		trialProductionReportHeader.setReportTemplateNo(StringUtil.nvl(param.get("reportTemplateNo")));
		trialProductionReportHeader.setReportTemplateName(StringUtil.nvl(param.get("reportTemplateName")));

		MfgProcessDoc mfgPrcoessDoc = productDevDao.getMfgProcessDocDetail(param);
		trialProductionReportHeader.setDocNo(mfgPrcoessDoc.getDocNo());
		trialProductionReportHeader.setDocVersion(mfgPrcoessDoc.getDocVersion());

		Map<String,Object> mpd = MfgProcessDocToMap(mfgPrcoessDoc);

		String bodyHtml = getReportTemplateContents(trialProductionReportHeader.getReportTemplateNo(),mpd);
		//String bodyEncode = base64Encode(bodyHtml);
		String bodyEncode = StringUtil.htmlToText(bodyHtml);
		trialProductionReportHeader.setReportContents(bodyEncode);
		trialProductionReportHeader.setReportContentsAppr1(bodyEncode);

		trialReportDao.trialReportCreate(trialProductionReportHeader);
		rNo = trialProductionReportHeader.getRNo();

		String strWriters = StringUtil.nvl(param.get("writerUserIdArr"));
		String[] writers = strWriters.split(",");
		List<TrialReportComment> trialProductionReportComments = new ArrayList<TrialReportComment>();
		for (String writerUserId : writers){
			TrialReportComment trialProductionReportComment = new TrialReportComment();
			trialProductionReportComment.setRNo(rNo);
			trialProductionReportComment.setWriterUserId(writerUserId);
			trialProductionReportComments.add(trialProductionReportComment);
		}
		trialReportDao.trialReportCommentCreate(trialProductionReportComments);

		return rNo;
	}

	@Override
	public String getReportTemplateContents(String reportTemplateNo,Map<String,Object> model)throws Exception{
		//String strHTML = VelocityEngineUtils.mergeTemplateIntoString(velocityEngine, "config/templates/trialReport_" + reportTemplateNo + ".html", "UTF-8", model);
//		logger.info("TrialReportServiceImpl.getReportTemplateContents:  velocityEngine - start");
//		logger.info(strHTML);
//		logger.info("TrialReportServiceImpl.getReportTemplateContents:  velocityEngine - end");
//
//		logger.info("TrialReportServiceImpl.getReportTemplateContents:  velocityEngine and base64 - start");
//		logger.info(base64Decode(base64Encode(strHTML)));
//		logger.info("TrialReportServiceImpl.getReportTemplateContents:  velocityEngine and base64 - end");
//
//		//trialReport.template.dir
//		String fileName = config.getProperty("trialReport.template.dir") + "/" + "trialReport_" + reportTemplateNo + ".html";
//		String textHTML = FileUtil.read( fileName, "UTF-8");
//		logger.info("TrialReportServiceImpl.getReportTemplateContents:  FileUtil.read - start");
//		logger.info(textHTML);
//		logger.info("TrialReportServiceImpl.getReportTemplateContents:  FileUtil.read - end");
		//return strHTML;
		return null;
	}

	public String base64Encode(String html){
		String encodedString = Base64.getEncoder().encodeToString(html.getBytes());
		return encodedString;
	}

	public String base64Decode(String base64){
		try{
			byte[] decodedBytes = Base64.getDecoder().decode(base64);
			String decodedString = new String(decodedBytes, StandardCharsets.UTF_8);
			return decodedString;
		}catch (Exception e){
			return null;
		}
	}

	@Override
	public int changeTrialReportState(HashMap<String, Object> param){
		return trialReportDao.changeTrialReportState(param);
	}

	public Map<String,Object> MfgProcessDocToMap(MfgProcessDoc mfgProcessDoc){
		Map<String,Object> mpd = new HashMap<String,Object>();

		return mpd;
	}

	@Override
	public int updateTrialReportProperty(Object id, String key, Object value){
		int result = 0;
		HashMap<String,Object> property = new HashMap<String,Object>();
		property.put("id",id);
		property.put("key",key);
		property.put("value",value);
		result = trialReportDao.updateTrialReportProperty(property);
		return result;
	}

	@Override
	public int updateTrialReportCommentProperty(Object id, String key, Object value){
		int result = 0;
		HashMap<String,Object> property = new HashMap<String,Object>();
		property.put("id",id);
		property.put("key",key);
		property.put("value",value);
		result = trialReportDao.updateTrialReportCommentProperty(property);
		return result;
	}

	@Override
	public TrialReportHeader getTrialReportHeaderVO(String rNo){
		TrialReportHeader trialReportHeader = trialReportDao.getTrialReportHeaderVO(rNo);
		if(trialReportHeader != null){
			trialReportHeader.setReportContents(StringUtil.htmlEscape(trialReportHeader.getReportContents()));
			trialReportHeader.setReportContentsAppr1(StringUtil.htmlEscape(trialReportHeader.getReportContentsAppr1()));
		}
		return trialReportHeader;
	}

	@Override
	public List<TrialReportComment> getTrialReportComments(String rNo){
		return trialReportDao.getTrialReportComment(rNo);
	}

	@Override
	public List<TrialReportFile> getTrialReportFiles(String rNo){
		List<TrialReportFile> trialReportFiles = trialReportDao.getTrialReportFiles(rNo);
		for(TrialReportFile trialReportFile : trialReportFiles){
			trialReportFile.setWebUrl(StringUtil.getDevdocFileName(trialReportFile.getPath() + "/" + trialReportFile.getFileName()));
		}
		return trialReportFiles;
	}

	@Override
	public void trialReportAppr(String rNo){
		// 1차결재 최종승인 처리

		//복고서 상태 변경 : 20:1차결재 완료
		HashMap<String,Object> chageStateParam = new HashMap<String,Object>();
		chageStateParam.put("rNo",rNo);
		chageStateParam.put("state","20");      // 1차 결재 진행중
		changeTrialReportState(chageStateParam);

		String startDate = DateUtil.getDate("yyyy-MM-dd");
		updateTrialReportProperty(rNo,"startDate", startDate);
	}

	@Override
	public void trialReportAppr2(String rNo){
		// 2차결재 최종승인 처리

		//복고서 상태 변경 : 50:2차결재 완료
		HashMap<String,Object> chageStateParam = new HashMap<String,Object>();
		chageStateParam.put("rNo",rNo);
		chageStateParam.put("state","50");      // 1차 결재 진행중
		changeTrialReportState(chageStateParam);

		String endDate = DateUtil.getDate("yyyy-MM-dd");
		updateTrialReportProperty(rNo,"endDate", endDate);
	}

	@Override
	public Map<String, Object> getTrialReportListPage(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		Map<String, Object> map = new HashMap<String, Object>();

		Map<String,Object> mapCount = trialReportDao.trialReportListCount(param);

		int totalCount = Integer.parseInt(StringUtil.nvl(mapCount.get("COUNT_" + param.get("status")),"0"));

		int viewCount = 0;
		try {
			viewCount = Integer.parseInt(param.get("viewCount").toString());
		} catch( Exception e ) {
			viewCount = 10;
		}
		// 페이징: 페이징 정보 SET
		PageNavigator navi = new PageNavigator(param, viewCount, totalCount);

		List<Map<String,Object>> trialReportList = trialReportDao.trialReportListPage(param);
		map.put("trialReportList", trialReportList);
		map.put("totalCount", totalCount);
		map.put("navi", navi);
		map.put("paramVO", param);
		map.put("mapCount",mapCount);

		return map;
	}

	@Override
	public int saveTrialReport(Map<String, Object> param) throws Exception {
		int resultCount = 0;

		String reportBody = StringUtil.nvl(param.get("reportContents"));
		param.put("reportContents",reportBody);

		Map<String,Object> commentParam = new HashMap<String,Object>();
		commentParam.put("cNo",param.get("cNo"));
		commentParam.put("writerComment",param.get("writerComment"));
		if(StringUtil.nvl(param.get("writerComment")).isEmpty()){
			param.put("writerComment",null);
		}
		resultCount += trialReportDao.saveTrialReportComment(commentParam);

		param.put("releasePlanDate",StringUtil.nvl(param.get("releasePlanDate")).isEmpty() ? null :  StringUtil.nvl(param.get("releasePlanDate")));
		param.put("releaseRealDate",StringUtil.nvl(param.get("releaseRealDate")).isEmpty() ? null :  StringUtil.nvl(param.get("releaseRealDate")));

		resultCount += trialReportDao.saveTrialReportHeader(param);

		// 작성자 5명 작성완료 여부 체크 및 상태변경
		List<TrialReportComment> trialReportComments = getTrialReportComments(StringUtil.nvl(param.get("rNo")));
		boolean isWriteOver = true;
		for(TrialReportComment trialReportComment : trialReportComments){
			if (StringUtil.nvl(trialReportComment.getWriterComment()).isEmpty()) {
				isWriteOver = false;
				break;
			}
		}
		if(isWriteOver){
			updateTrialReportProperty(param.get("rNo"),"state","35");
		}

		return resultCount;
	}

	@Override
	public TrialReportFile saveTrialReportFile(TrialReportFile trialReportFile) throws Exception {
		List<TrialReportFile> trialReportFiles = trialReportDao.getTrialReportFiles(StringUtil.nvl(trialReportFile.getRNo()));
		boolean isInsert = true;
		for(TrialReportFile reportFile : trialReportFiles){
			if(reportFile.getGubun().equals(trialReportFile.getGubun())){
				isInsert = false;
				trialReportFile.setFNo(reportFile.getFNo());
				FileUtil.fileDelete(reportFile.getFileName(),reportFile.getPath());
			}
		}
		if(isInsert){
			trialReportDao.insertTrialReportFile(trialReportFile);
		}else{
			trialReportDao.updateTrialReportFile(trialReportFile);
		}
		trialReportFile.setWebUrl(StringUtil.getDevdocFileName(trialReportFile.getPath() + "/" + trialReportFile.getFileName()));
		return trialReportFile;
	}

	@Override
	public List<TrialReportHeader> trialReportListForDevDocDetail(Map<String, Object> param){
		return trialReportDao.trialReportListForDevDocDetail(param);
	}

	@Override
	public int checkoutTrialReport(Map<String, Object> param) throws Exception {
		updateTrialReportProperty(param.get("rNo"),"state","30");
		return updateTrialReportCommentProperty(param.get("cNo"),"isEditing",1);
	}

	@Override
	public int editCancel(Map<String, Object> param) throws Exception {
		int resultCount = 0;
		resultCount += updateTrialReportCommentProperty(param.get("cNo"),"isEditing",0);
		List<TrialReportComment> trialReportComments = getTrialReportComments(StringUtil.nvl(param.get("rNo")));
		boolean isWriteOver = true;
		for(TrialReportComment trialReportComment : trialReportComments){
			if (StringUtil.nvl(trialReportComment.getWriterComment()).isEmpty()) {
				isWriteOver = false;
				break;
			}
		}
		if(isWriteOver){
			updateTrialReportProperty(param.get("rNo"),"state","35");
		}
		return resultCount;
	}
	
    /**
     * 23.07.17
     * 시생산보고서 첨부파일 업로드
     * */
	@Override
	public TrialReportFile insertTrialReportAttachFile(TrialReportFile trialReportFile) throws Exception {
		// 기존 저장된 파일내역
		List<TrialReportFile> trialReportFiles = trialReportDao.getTrialReportFiles(StringUtil.nvl(trialReportFile.getRNo()));
		
		boolean isInsert = true;
		for(TrialReportFile reportFile : trialReportFiles){
			if(reportFile.getGubun().equals(trialReportFile.getGubun())){ //50 - 첨부파일만 비교
				if(reportFile.getOrgFileName().equals(trialReportFile.getOrgFileName())){ //원본 파일명이 동일한게 있을경우.
					isInsert = false;
					trialReportFile.setFNo(reportFile.getFNo());
					FileUtil.fileDelete(reportFile.getFileName(),reportFile.getPath());
				}
			}
		}
		if(isInsert){
			trialReportDao.insertTrialReportFile(trialReportFile);
		}else{
			trialReportDao.updateTrialReportFile(trialReportFile);
		}

		return trialReportFile;
	}
	
	/**
     * 23.07.17
     * 시생산보고서 첨부파일 항목 조회
     * */
	@Override
	public List<Map<String, Object>> getTrialReportAttachFiles(String rNo){
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("rNo", rNo);
		param.put("gubun", "50"); // gubun:50 첨부파일
		//조회
		return trialReportDao.getTrialReportAttachFiles(param);
	}
}