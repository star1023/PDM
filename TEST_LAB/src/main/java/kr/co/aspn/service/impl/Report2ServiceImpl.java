package kr.co.aspn.service.impl;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import org.json.simple.JSONArray;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.web.multipart.MultipartFile;

import kr.co.aspn.controller.ReportController;
import kr.co.aspn.dao.ApprovalDao;
import kr.co.aspn.dao.Report2Dao;
import kr.co.aspn.dao.ReportDao;
import kr.co.aspn.dao.TestDao;
import kr.co.aspn.dao.UserDao;
import kr.co.aspn.service.ApprovalService;
import kr.co.aspn.service.CommonService;
import kr.co.aspn.service.FileService;
import kr.co.aspn.service.Report2Service;
import kr.co.aspn.service.ReportService;
import kr.co.aspn.service.SendMailService;
import kr.co.aspn.util.FileUtil;
import kr.co.aspn.util.PageNavigator;
import kr.co.aspn.vo.ApprovalHeaderVO;
import kr.co.aspn.vo.ApprovalItemVO;
import kr.co.aspn.vo.ApprovalLineHeaderVO;
import kr.co.aspn.vo.ApprovalLineInfoVO;
import kr.co.aspn.vo.ApprovalReferenceVO;
import kr.co.aspn.vo.CodeItemVO;
import kr.co.aspn.vo.CompanyVO;
import kr.co.aspn.vo.FileVO;
import kr.co.aspn.vo.ReportVO;
import kr.co.aspn.vo.UserVO;

@Service
public class Report2ServiceImpl implements Report2Service {
	private Logger logger = LoggerFactory.getLogger(Report2ServiceImpl.class);
	
	@Autowired
	Report2Dao reportDao;
	
	@Autowired
	private Properties config;
	
	@Autowired
	TestDao testDao;
	
	@Override
	public Map<String, Object> selectDesignList(Map<String, Object> param) throws Exception{
		// TODO Auto-generated method stub
		int totalCount = reportDao.selectDesignCount(param);
		
		int viewCount = 10;
		int pageNo = 1;
		try {
			pageNo = Integer.parseInt((String)param.get("pageNo"));
		} catch( Exception e ) {
			System.err.println(e.getMessage());
			pageNo = 1;
		}
		
		try {
			viewCount = Integer.parseInt((String)param.get("viewCount"));
		} catch( Exception e ) {
			System.err.println(e.getMessage());
			viewCount = 10;
		}
		
		// 페이징: 페이징 정보 SET
		PageNavigator navi = new PageNavigator(param, viewCount, totalCount);
		
		List<Map<String, Object>> designList = reportDao.selectDesignList(param);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("pageNo", pageNo);
		map.put("totalCount", totalCount);
		map.put("list", designList);	
		map.put("navi", navi);
		return map;
	}
	

	@Override
	public int insertDesign(Map<String, Object> param, HashMap<String, Object> listMap, MultipartFile[] file)
			throws Exception {
		// TODO Auto-generated method stub
		int designIdx = 0;
		try {
			ArrayList<String> fileType = (ArrayList<String>)listMap.get("fileType");
			ArrayList<String> fileTypeText = (ArrayList<String>)listMap.get("fileTypeText");
			ArrayList<String> rowIdArr = (ArrayList<String>)listMap.get("rowIdArr");
			ArrayList<String> itemDivArr = (ArrayList<String>)listMap.get("itemDivArr");
			ArrayList<String> itemCurrentArr = (ArrayList<String>)listMap.get("itemCurrentArr");
			ArrayList<String> itemChangeArr = (ArrayList<String>)listMap.get("itemChangeArr");
			ArrayList<String> itemNoteArr = (ArrayList<String>)listMap.get("itemNoteArr");
			
			designIdx = reportDao.selectDesignSeq();	//key value 조회
			param.put("idx", designIdx);
			param.put("status", "REG");
			
			//제품 등록
			reportDao.insertDesign(param);
			
			ArrayList<HashMap<String,String>> changeList = new ArrayList<HashMap<String,String>>();
			for( int i = 0 ; i < itemDivArr.size() ; i++ ) {
				HashMap<String,String> matMap = new HashMap<String,String>();
				try{
					matMap.put("itemDiv", itemDivArr.get(i));
				} catch(Exception e) {
					matMap.put("itemDiv", "");
				}				
				try{
					matMap.put("itemCurrent", itemCurrentArr.get(i));
				} catch(Exception e) {
					matMap.put("itemCurrent", "");
				}				
				try{
					matMap.put("itemChange", itemChangeArr.get(i));
				} catch(Exception e) {
					matMap.put("itemChange", "");
				}
				try{
					matMap.put("itemNote", itemNoteArr.get(i));
				} catch(Exception e) {
					matMap.put("itemNote", "");
				}
				
				changeList.add(matMap);
			}
			param.put("changeList", changeList);
			reportDao.insertChangeList(param);
			
			//history 저장
			Map<String, Object> historyParam = new HashMap<String, Object>();
			historyParam.put("docIdx", designIdx);
			historyParam.put("docType", "DESIGN");
			historyParam.put("historyType", "I");
			historyParam.put("historyData", param.toString());
			historyParam.put("userId", param.get("userId"));
			testDao.insertHistory(historyParam);
			
			//파일 DB 저장
			if( file != null && file.length > 0 ) {
				Calendar cal = Calendar.getInstance();
		        Date day = cal.getTime();    //시간을 꺼낸다.
		        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
		        String toDay = sdf.format(day);
				String path = config.getProperty("upload.file.path.design");
				path += "/"+toDay; 
				int idx = 0;
				for( MultipartFile multipartFile : file ) {
					System.err.println("=================================");
					System.err.println("isEmpty : "+multipartFile.isEmpty());
					System.err.println("name : " + multipartFile.getName());
					System.err.println("originalFilename : " + multipartFile.getOriginalFilename());		
					System.err.println("size : " + multipartFile.getSize());				
					System.err.println("=================================");
					try {
						if( !multipartFile.isEmpty() ) {
							String fileIdx = FileUtil.getUUID();
							String result = FileUtil.upload3(multipartFile,path,fileIdx);
							String content = FileUtil.getPdfContents(path, result);
							Map<String,Object> fileMap = new HashMap<String,Object>();
							fileMap.put("fileIdx", fileIdx);
							fileMap.put("docIdx", designIdx);
							fileMap.put("docType", "DESIGN");
							fileMap.put("fileType", fileType.get(idx));
							fileMap.put("orgFileName", multipartFile.getOriginalFilename());
							fileMap.put("filePath", path);
							fileMap.put("changeFileName", result);
							fileMap.put("content", content);
							System.err.println(fileMap);
							//파일정보 저장
							testDao.insertFileInfo(fileMap);
							idx++;
						}
					} catch( Exception e ) {
						//throw e;
					}					
				}
			}
		} catch( Exception e ) {
			e.printStackTrace();
			throw e;
		}
		return designIdx;
	}


	@Override
	public Map<String, Object> selectDesignData(Map<String, Object> param) {
		// TODO Auto-generated method stub
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, String> data = reportDao.selectDesignData(param);
		param.put("docType", "DESIGN");
		List<Map<String, String>> fileList = testDao.selectFileList(param);
		map.put("data", data);
		map.put("fileList", fileList);
		return map;
	}


	@Override
	public List<Map<String, Object>> selectDesignChangeList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return reportDao.selectDesignChangeList(param);
	}


	@Override
	public List<Map<String, String>> selectHistory(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return reportDao.selectHistory(param);
	}


	@Override
	public void updateDesign(Map<String, Object> param, HashMap<String, Object> listMap, MultipartFile[] file)
			throws Exception {
		// TODO Auto-generated method stub
		try {
			ArrayList<String> fileType = (ArrayList<String>)listMap.get("fileType");
			ArrayList<String> fileTypeText = (ArrayList<String>)listMap.get("fileTypeText");
			ArrayList<String> rowIdArr = (ArrayList<String>)listMap.get("rowIdArr");
			ArrayList<String> itemDivArr = (ArrayList<String>)listMap.get("itemDivArr");
			ArrayList<String> itemCurrentArr = (ArrayList<String>)listMap.get("itemCurrentArr");
			ArrayList<String> itemChangeArr = (ArrayList<String>)listMap.get("itemChangeArr");
			ArrayList<String> itemNoteArr = (ArrayList<String>)listMap.get("itemNoteArr");
			
			int designIdx = Integer.parseInt((String)param.get("idx")); 	//key value 조회
			if( param.get("currentStatus") != null && "COND_APPR".equals(param.get("currentStatus")) ) {
				param.put("status", "APPR");
			}
			
			reportDao.updateDesign(param);			
			
			reportDao.deleteChangeList(param);
			
			ArrayList<HashMap<String,String>> changeList = new ArrayList<HashMap<String,String>>();
			for( int i = 0 ; i < itemDivArr.size() ; i++ ) {
				HashMap<String,String> matMap = new HashMap<String,String>();
				try{
					matMap.put("itemDiv", itemDivArr.get(i));
				} catch(Exception e) {
					matMap.put("itemDiv", "");
				}				
				try{
					matMap.put("itemCurrent", itemCurrentArr.get(i));
				} catch(Exception e) {
					matMap.put("itemCurrent", "");
				}				
				try{
					matMap.put("itemChange", itemChangeArr.get(i));
				} catch(Exception e) {
					matMap.put("itemChange", "");
				}
				try{
					matMap.put("itemNote", itemNoteArr.get(i));
				} catch(Exception e) {
					matMap.put("itemNote", "");
				}
				
				changeList.add(matMap);
			}
			param.put("changeList", changeList);
			reportDao.insertChangeList(param);
			
			//history 저장
			Map<String, Object> historyParam = new HashMap<String, Object>();
			historyParam.put("docIdx", designIdx);
			historyParam.put("docType", "DESIGN");
			historyParam.put("historyType", "U");
			historyParam.put("historyData", param.toString());
			historyParam.put("userId", param.get("userId"));
			testDao.insertHistory(historyParam);
			
			//파일 DB 저장
			if( file != null && file.length > 0 ) {
				Calendar cal = Calendar.getInstance();
		        Date day = cal.getTime();    //시간을 꺼낸다.
		        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
		        String toDay = sdf.format(day);
		        String path = config.getProperty("upload.file.path.design");
				path += "/"+toDay; 
				int idx = 0;
				for( MultipartFile multipartFile : file ) {
					System.err.println("=================================");
					System.err.println("isEmpty : "+multipartFile.isEmpty());
					System.err.println("name : " + multipartFile.getName());
					System.err.println("originalFilename : " + multipartFile.getOriginalFilename());		
					System.err.println("size : " + multipartFile.getSize());				
					System.err.println("=================================");
					try {
						if( !multipartFile.isEmpty() ) {
							String fileIdx = FileUtil.getUUID();
							String result = FileUtil.upload3(multipartFile,path,fileIdx);
							String content = FileUtil.getPdfContents(path, result);
							Map<String,Object> fileMap = new HashMap<String,Object>();
							fileMap.put("fileIdx", fileIdx);
							fileMap.put("docIdx", designIdx);
							fileMap.put("docType", "DESIGN");
							fileMap.put("fileType", fileType.get(idx));
							fileMap.put("orgFileName", multipartFile.getOriginalFilename());
							fileMap.put("filePath", path);
							fileMap.put("changeFileName", result);
							fileMap.put("content", content);
							System.err.println(fileMap);
							//파일정보 저장
							testDao.insertFileInfo(fileMap);
							idx++;
						}
					} catch( Exception e ) {
						//throw e;
					}					
				}
			}
			
			if( param.get("currentStatus") != null && "COND_APPR".equals(param.get("currentStatus")) ) {
				//다음 결재자에게 메일을 보낸다.
			}
			
		} catch( Exception e ) {
			e.printStackTrace();
			throw e;
		}
	}


	@Override
	public Map<String, Object> selectBusinessTripList(Map<String, Object> param) throws Exception{
		// TODO Auto-generated method stub
		int totalCount = reportDao.selectBusinessTripCount(param);
		
		int viewCount = 10;
		int pageNo = 1;
		try {
			pageNo = Integer.parseInt((String)param.get("pageNo"));
		} catch( Exception e ) {
			System.err.println(e.getMessage());
			pageNo = 1;
		}
		
		try {
			viewCount = Integer.parseInt((String)param.get("viewCount"));
		} catch( Exception e ) {
			System.err.println(e.getMessage());
			viewCount = 10;
		}
		
		// 페이징: 페이징 정보 SET
		PageNavigator navi = new PageNavigator(param, viewCount, totalCount);
		
		List<Map<String, Object>> designList = reportDao.selectBusinessTripList(param);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("pageNo", pageNo);
		map.put("totalCount", totalCount);
		map.put("list", designList);	
		map.put("navi", navi);
		return map;
	}
	
	@Override
	public int insertBusinessTripTmp(Map<String, Object> param, MultipartFile[] file) throws Exception {
		// TODO Auto-generated method stub
		int tripIdx = 0;
		try {
			JSONParser parser = new JSONParser();
			JSONArray deptArr = (JSONArray) parser.parse((String)param.get("deptArr"));
			JSONArray positionArr = (JSONArray) parser.parse((String)param.get("positionArr"));
			JSONArray nameArr = (JSONArray) parser.parse((String)param.get("nameArr"));
			JSONArray purposeArr = (JSONArray) parser.parse((String)param.get("purposeArr"));
			JSONArray tripDestinationArr = (JSONArray) parser.parse((String)param.get("tripDestinationArr"));
			JSONArray scheduleArr = (JSONArray) parser.parse((String)param.get("scheduleArr"));
			JSONArray contentArr = (JSONArray) parser.parse((String)param.get("contentArr"));
			JSONArray placeArr = (JSONArray) parser.parse((String)param.get("placeArr"));
			JSONArray noteArr = (JSONArray) parser.parse((String)param.get("noteArr"));
			
			tripIdx = reportDao.selectTripSeq();	//key value 조회
			param.put("idx", tripIdx);
			
			//출장결과 등록
			reportDao.insertBusinessTrip(param);
			
			//2. 출장자 등록
			ArrayList<HashMap<String,Object>> userList = new ArrayList<HashMap<String,Object>>();
			for( int i = 0 ; i < deptArr.size() ; i++ ) {
				HashMap<String,Object> userMap = new HashMap<String,Object>();
				userMap.put("idx", tripIdx);
				userMap.put("displayOrder", i+1);
				
				try{
					userMap.put("dept", deptArr.get(i));
				} catch(Exception e) {
					userMap.put("dept", "");
				}
				
				try{
					userMap.put("position", positionArr.get(i));
				} catch(Exception e) {
					userMap.put("position", "");
				}
				
				try{
					userMap.put("name", nameArr.get(i));
				} catch(Exception e) {
					userMap.put("name", "");
				}
				
				userList.add(userMap);
			}			
			if( userList != null && userList.size() > 0 ) {
				reportDao.insertBusinessTripUser(userList);
			}
			
			//3. 추가 정보 등록
			ArrayList<HashMap<String,Object>> addInfoList = new ArrayList<HashMap<String,Object>>();
			if( purposeArr.size() > 0 ) {
				for( int i = 0 ; i < purposeArr.size() ; i++ ) {					
					if( purposeArr.get(i) != null && !"".equals(purposeArr.get(i)) ) {
						HashMap<String,Object> purposeData = new HashMap<String,Object>();
						purposeData.put("idx", tripIdx);
						purposeData.put("displayOrder", i+1);
						purposeData.put("infoType", "PUR");
						purposeData.put("infoText", purposeArr.get(i));
						addInfoList.add(purposeData);
					}
				}				
			}
			
			if( tripDestinationArr.size() > 0 ) {
				for( int i = 0 ; i < tripDestinationArr.size() ; i++ ) {
					if( tripDestinationArr.get(i) != null && !"".equals(tripDestinationArr.get(i)) ) {
						HashMap<String,Object> featureData = new HashMap<String,Object>();
						featureData.put("idx", tripIdx);
						featureData.put("displayOrder", i+1);
						featureData.put("infoType", "DEST");
						featureData.put("infoText", tripDestinationArr.get(i));
						addInfoList.add(featureData);
					}
				}
			}
			
			if( addInfoList != null && addInfoList.size() > 0 ) {
				reportDao.insertBusinessTripAddInfo(addInfoList);
			}
			
			//4. 업무수행내용 등록
			ArrayList<HashMap<String,Object>> contentList = new ArrayList<HashMap<String,Object>>();
			for( int i = 0 ; i < scheduleArr.size() ; i++ ) {
				HashMap<String,Object> contentMap = new HashMap<String,Object>();
				contentMap.put("idx", tripIdx);
				contentMap.put("displayOrder", i+1);
				
				try{
					contentMap.put("schedule", scheduleArr.get(i));
				} catch(Exception e) {
					contentMap.put("schedule", "");
				}
				
				try{
					contentMap.put("content", contentArr.get(i));
				} catch(Exception e) {
					contentMap.put("content", "");
				}
				
				try{
					contentMap.put("place", placeArr.get(i));
				} catch(Exception e) {
					contentMap.put("place", "");
				}
				
				try{
					contentMap.put("note", noteArr.get(i));
				} catch(Exception e) {
					contentMap.put("note", "");
				}
				
				contentList.add(contentMap);
			}			
			if( contentList != null && contentList.size() > 0 ) {
				reportDao.insertBusinessTripContents(contentList);
			}
			
			//history 저장
			Map<String, Object> historyParam = new HashMap<String, Object>();
			historyParam.put("docIdx", tripIdx);
			historyParam.put("docType", param.get("docType"));
			historyParam.put("historyType", "T");
			historyParam.put("historyData", param.toString());
			historyParam.put("userId", param.get("userId"));
			testDao.insertHistory(historyParam);
			
			//파일 DB 저장
			if( file != null && file.length > 0 ) {
				Calendar cal = Calendar.getInstance();
		        Date day = cal.getTime();    //시간을 꺼낸다.
		        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
		        String toDay = sdf.format(day);
				String path = config.getProperty("upload.file.path.trip");
				path += "/"+toDay; 
				for( MultipartFile multipartFile : file ) {
					System.err.println("=================================");
					System.err.println("isEmpty : "+multipartFile.isEmpty());
					System.err.println("name : " + multipartFile.getName());
					System.err.println("originalFilename : " + multipartFile.getOriginalFilename());		
					System.err.println("size : " + multipartFile.getSize());				
					System.err.println("=================================");
					try {
						if( !multipartFile.isEmpty() ) {
							String fileIdx = FileUtil.getUUID();
							String result = FileUtil.upload3(multipartFile,path,fileIdx);
							String content = FileUtil.getPdfContents(path, result);
							Map<String,Object> fileMap = new HashMap<String,Object>();
							fileMap.put("fileIdx", fileIdx);
							fileMap.put("docIdx", tripIdx);
							fileMap.put("docType", param.get("docType"));
							fileMap.put("fileType", "00");
							fileMap.put("orgFileName", multipartFile.getOriginalFilename());
							fileMap.put("filePath", path);
							fileMap.put("changeFileName", result);
							fileMap.put("content", content);
							System.err.println(fileMap);
							//파일정보 저장
							testDao.insertFileInfo(fileMap);
						}
					} catch( Exception e ) {
						//throw e;
					}					
				}
			}
		} catch( Exception e ) {
			throw e;
		}
		return tripIdx;
	}


	@Override
	public int insertBusinessTrip(Map<String, Object> param, MultipartFile[] file) throws Exception {
		// TODO Auto-generated method stub
		int tripIdx = 0;
		try {
			JSONParser parser = new JSONParser();
			JSONArray deptArr = (JSONArray) parser.parse((String)param.get("deptArr"));
			JSONArray positionArr = (JSONArray) parser.parse((String)param.get("positionArr"));
			JSONArray nameArr = (JSONArray) parser.parse((String)param.get("nameArr"));
			JSONArray purposeArr = (JSONArray) parser.parse((String)param.get("purposeArr"));
			JSONArray tripDestinationArr = (JSONArray) parser.parse((String)param.get("tripDestinationArr"));
			JSONArray scheduleArr = (JSONArray) parser.parse((String)param.get("scheduleArr"));
			JSONArray contentArr = (JSONArray) parser.parse((String)param.get("contentArr"));
			JSONArray placeArr = (JSONArray) parser.parse((String)param.get("placeArr"));
			JSONArray noteArr = (JSONArray) parser.parse((String)param.get("noteArr"));
			
			tripIdx = reportDao.selectTripSeq();	//key value 조회
			param.put("idx", tripIdx);
			
			//출장결과 등록
			reportDao.insertBusinessTrip(param);
			
			//2. 출장자 등록
			ArrayList<HashMap<String,Object>> userList = new ArrayList<HashMap<String,Object>>();
			for( int i = 0 ; i < deptArr.size() ; i++ ) {
				HashMap<String,Object> userMap = new HashMap<String,Object>();
				userMap.put("idx", tripIdx);
				userMap.put("displayOrder", i+1);
				
				try{
					userMap.put("dept", deptArr.get(i));
				} catch(Exception e) {
					userMap.put("dept", "");
				}
				
				try{
					userMap.put("position", positionArr.get(i));
				} catch(Exception e) {
					userMap.put("position", "");
				}
				
				try{
					userMap.put("name", nameArr.get(i));
				} catch(Exception e) {
					userMap.put("name", "");
				}
				
				userList.add(userMap);
			}			
			if( userList != null && userList.size() > 0 ) {
				reportDao.insertBusinessTripUser(userList);
			}
			
			//3. 추가 정보 등록
			ArrayList<HashMap<String,Object>> addInfoList = new ArrayList<HashMap<String,Object>>();
			if( purposeArr.size() > 0 ) {
				for( int i = 0 ; i < purposeArr.size() ; i++ ) {					
					if( purposeArr.get(i) != null && !"".equals(purposeArr.get(i)) ) {
						HashMap<String,Object> purposeData = new HashMap<String,Object>();
						purposeData.put("idx", tripIdx);
						purposeData.put("displayOrder", i+1);
						purposeData.put("infoType", "PUR");
						purposeData.put("infoText", purposeArr.get(i));
						addInfoList.add(purposeData);
					}
				}				
			}
			
			if( tripDestinationArr.size() > 0 ) {
				for( int i = 0 ; i < tripDestinationArr.size() ; i++ ) {
					if( tripDestinationArr.get(i) != null && !"".equals(tripDestinationArr.get(i)) ) {
						HashMap<String,Object> featureData = new HashMap<String,Object>();
						featureData.put("idx", tripIdx);
						featureData.put("displayOrder", i+1);
						featureData.put("infoType", "DEST");
						featureData.put("infoText", tripDestinationArr.get(i));
						addInfoList.add(featureData);
					}
				}
			}
			
			if( addInfoList != null && addInfoList.size() > 0 ) {
				reportDao.insertBusinessTripAddInfo(addInfoList);
			}
			
			//4. 업무수행내용 등록
			ArrayList<HashMap<String,Object>> contentList = new ArrayList<HashMap<String,Object>>();
			for( int i = 0 ; i < scheduleArr.size() ; i++ ) {
				HashMap<String,Object> contentMap = new HashMap<String,Object>();
				contentMap.put("idx", tripIdx);
				contentMap.put("displayOrder", i+1);
				
				try{
					contentMap.put("schedule", scheduleArr.get(i));
				} catch(Exception e) {
					contentMap.put("schedule", "");
				}
				
				try{
					contentMap.put("content", contentArr.get(i));
				} catch(Exception e) {
					contentMap.put("content", "");
				}
				
				try{
					contentMap.put("place", placeArr.get(i));
				} catch(Exception e) {
					contentMap.put("place", "");
				}
				
				try{
					contentMap.put("note", noteArr.get(i));
				} catch(Exception e) {
					contentMap.put("note", "");
				}
				
				contentList.add(contentMap);
			}			
			if( contentList != null && contentList.size() > 0 ) {
				reportDao.insertBusinessTripContents(contentList);
			}
			
			//history 저장
			Map<String, Object> historyParam = new HashMap<String, Object>();
			historyParam.put("docIdx", tripIdx);
			historyParam.put("docType", param.get("docType"));
			historyParam.put("historyType", "T");
			historyParam.put("historyData", param.toString());
			historyParam.put("userId", param.get("userId"));
			testDao.insertHistory(historyParam);
			
			//파일 DB 저장
			if( file != null && file.length > 0 ) {
				Calendar cal = Calendar.getInstance();
		        Date day = cal.getTime();    //시간을 꺼낸다.
		        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
		        String toDay = sdf.format(day);
				String path = config.getProperty("upload.file.path.trip");
				path += "/"+toDay; 
				for( MultipartFile multipartFile : file ) {
					System.err.println("=================================");
					System.err.println("isEmpty : "+multipartFile.isEmpty());
					System.err.println("name : " + multipartFile.getName());
					System.err.println("originalFilename : " + multipartFile.getOriginalFilename());		
					System.err.println("size : " + multipartFile.getSize());				
					System.err.println("=================================");
					try {
						if( !multipartFile.isEmpty() ) {
							String fileIdx = FileUtil.getUUID();
							String result = FileUtil.upload3(multipartFile,path,fileIdx);
							String content = FileUtil.getPdfContents(path, result);
							Map<String,Object> fileMap = new HashMap<String,Object>();
							fileMap.put("fileIdx", fileIdx);
							fileMap.put("docIdx", tripIdx);
							fileMap.put("docType", param.get("docType"));
							fileMap.put("fileType", "00");
							fileMap.put("orgFileName", multipartFile.getOriginalFilename());
							fileMap.put("filePath", path);
							fileMap.put("changeFileName", result);
							fileMap.put("content", content);
							System.err.println(fileMap);
							//파일정보 저장
							testDao.insertFileInfo(fileMap);
						}
					} catch( Exception e ) {
						//throw e;
					}					
				}
			}
		} catch( Exception e ) {
			throw e;
		}
		return tripIdx;
	}


	@Override
	public Map<String, Object> selectBusinessTripData(Map<String, Object> param) {
		// TODO Auto-generated method stub
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, String> data = reportDao.selectBusinessTripData(param);
		param.put("docType", "TRIP");
		List<Map<String, String>> fileList = testDao.selectFileList(param);
		map.put("data", data);
		map.put("fileList", fileList);
		return map;
	}


	@Override
	public void updateBusinessTrip(Map<String, Object> param, MultipartFile[] file) throws Exception {
		// TODO Auto-generated method stub
		try {
			int tripIdx = Integer.parseInt((String)param.get("idx")); 	//key value 조회
			if( param.get("currentStatus") != null && "COND_APPR".equals(param.get("currentStatus")) ) {
				param.put("status", "APPR");
			}
			
			JSONParser parser = new JSONParser();
			JSONArray deptArr = (JSONArray) parser.parse((String)param.get("deptArr"));
			JSONArray positionArr = (JSONArray) parser.parse((String)param.get("positionArr"));
			JSONArray nameArr = (JSONArray) parser.parse((String)param.get("nameArr"));
			JSONArray purposeArr = (JSONArray) parser.parse((String)param.get("purposeArr"));
			JSONArray tripDestinationArr = (JSONArray) parser.parse((String)param.get("tripDestinationArr"));
			JSONArray scheduleArr = (JSONArray) parser.parse((String)param.get("scheduleArr"));
			JSONArray contentArr = (JSONArray) parser.parse((String)param.get("contentArr"));
			JSONArray placeArr = (JSONArray) parser.parse((String)param.get("placeArr"));
			JSONArray noteArr = (JSONArray) parser.parse((String)param.get("noteArr"));
			
			//출장결과 수정
			reportDao.updateBusinessTrip(param);
			
			//2. 출장자 등록
			ArrayList<HashMap<String,Object>> userList = new ArrayList<HashMap<String,Object>>();
			for( int i = 0 ; i < deptArr.size() ; i++ ) {
				HashMap<String,Object> userMap = new HashMap<String,Object>();
				userMap.put("idx", param.get("idx"));
				userMap.put("displayOrder", i+1);
				
				try{
					userMap.put("dept", deptArr.get(i));
				} catch(Exception e) {
					userMap.put("dept", "");
				}
				
				try{
					userMap.put("position", positionArr.get(i));
				} catch(Exception e) {
					userMap.put("position", "");
				}
				
				try{
					userMap.put("name", nameArr.get(i));
				} catch(Exception e) {
					userMap.put("name", "");
				}
				
				userList.add(userMap);
			}			
			reportDao.deleteBusinessTripUser(param);
			if( userList != null && userList.size() > 0 ) {
				reportDao.insertBusinessTripUser(userList);
			}
			
			//3. 추가 정보 등록
			ArrayList<HashMap<String,Object>> addInfoList = new ArrayList<HashMap<String,Object>>();
			
			if( purposeArr.size() > 0 ) {
				for( int i = 0 ; i < purposeArr.size() ; i++ ) {					
					if( purposeArr.get(i) != null && !"".equals(purposeArr.get(i)) ) {
						HashMap<String,Object> purposeData = new HashMap<String,Object>();
						purposeData.put("idx", param.get("idx"));
						purposeData.put("displayOrder", i+1);
						purposeData.put("infoType", "PUR");
						purposeData.put("infoText", purposeArr.get(i));
						addInfoList.add(purposeData);
					}
				}				
			}
			
			if( tripDestinationArr.size() > 0 ) {
				for( int i = 0 ; i < tripDestinationArr.size() ; i++ ) {
					if( tripDestinationArr.get(i) != null && !"".equals(tripDestinationArr.get(i)) ) {
						HashMap<String,Object> featureData = new HashMap<String,Object>();
						featureData.put("idx", param.get("idx"));
						featureData.put("displayOrder", i+1);
						featureData.put("infoType", "DEST");
						featureData.put("infoText", tripDestinationArr.get(i));
						addInfoList.add(featureData);
					}
				}
			}
			
			reportDao.deleteBusinessTripAddInfo(param);
			if( addInfoList != null && addInfoList.size() > 0 ) {
				reportDao.insertBusinessTripAddInfo(addInfoList);
			}
			
			//4. 업무수행내용 등록
			ArrayList<HashMap<String,Object>> contentList = new ArrayList<HashMap<String,Object>>();
			for( int i = 0 ; i < scheduleArr.size() ; i++ ) {
				HashMap<String,Object> contentMap = new HashMap<String,Object>();
				contentMap.put("idx", param.get("idx"));
				contentMap.put("displayOrder", i+1);
				
				try{
					contentMap.put("schedule", scheduleArr.get(i));
				} catch(Exception e) {
					contentMap.put("schedule", "");
				}
				
				try{
					contentMap.put("content", contentArr.get(i));
				} catch(Exception e) {
					contentMap.put("content", "");
				}
				
				try{
					contentMap.put("place", placeArr.get(i));
				} catch(Exception e) {
					contentMap.put("place", "");
				}
				
				try{
					contentMap.put("note", noteArr.get(i));
				} catch(Exception e) {
					contentMap.put("note", "");
				}
				
				contentList.add(contentMap);
			}
			reportDao.deleteBusinessTripContents(param);
			if( contentList != null && contentList.size() > 0 ) {
				reportDao.insertBusinessTripContents(contentList);
			}
			
			//history 저장
			Map<String, Object> historyParam = new HashMap<String, Object>();
			historyParam.put("docIdx", param.get("idx"));
			historyParam.put("docType", param.get("docType"));
			historyParam.put("historyType", "U");
			historyParam.put("historyData", param.toString());
			historyParam.put("userId", param.get("userId"));
			testDao.insertHistory(historyParam);
			
			//파일 DB 저장
			if( file != null && file.length > 0 ) {
				Calendar cal = Calendar.getInstance();
		        Date day = cal.getTime();    //시간을 꺼낸다.
		        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
		        String toDay = sdf.format(day);
				String path = config.getProperty("upload.file.path.trip");
				path += "/"+toDay; 
				for( MultipartFile multipartFile : file ) {
					System.err.println("=================================");
					System.err.println("isEmpty : "+multipartFile.isEmpty());
					System.err.println("name : " + multipartFile.getName());
					System.err.println("originalFilename : " + multipartFile.getOriginalFilename());		
					System.err.println("size : " + multipartFile.getSize());				
					System.err.println("=================================");
					try {
						if( !multipartFile.isEmpty() ) {
							String fileIdx = FileUtil.getUUID();
							String result = FileUtil.upload3(multipartFile,path,fileIdx);
							String content = FileUtil.getPdfContents(path, result);
							Map<String,Object> fileMap = new HashMap<String,Object>();
							fileMap.put("fileIdx", fileIdx);
							fileMap.put("docIdx", param.get("idx"));
							fileMap.put("docType", param.get("docType"));
							fileMap.put("fileType", "00");
							fileMap.put("orgFileName", multipartFile.getOriginalFilename());
							fileMap.put("filePath", path);
							fileMap.put("changeFileName", result);
							fileMap.put("content", content);
							System.err.println(fileMap);
							//파일정보 저장
							testDao.insertFileInfo(fileMap);
						}
					} catch( Exception e ) {
						//throw e;
					}					
				}
			}
			
			if( param.get("currentStatus") != null && "COND_APPR".equals(param.get("currentStatus")) ) {
				//다음 결재자에게 메일을 보낸다.
			}
		} catch( Exception e ) {
			throw e;
		}
	}
	
	@Override
	public List<Map<String, Object>> searchBusinessTripPlanList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return reportDao.searchBusinessTripPlanList(param);
	}
	
	@Override
	public List<Map<String, Object>> searchNewProductResultListAjax(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return reportDao.searchNewProductResultListAjax(param);
	}

	@Override
	public Map<String, Object> selectBusinessTripPlanList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		int totalCount = reportDao.selectBusinessTripPlanCount(param);
		
		int viewCount = 10;
		int pageNo = 1;
		try {
			pageNo = Integer.parseInt((String)param.get("pageNo"));
		} catch( Exception e ) {
			System.err.println(e.getMessage());
			pageNo = 1;
		}
		
		try {
			viewCount = Integer.parseInt((String)param.get("viewCount"));
		} catch( Exception e ) {
			System.err.println(e.getMessage());
			viewCount = 10;
		}
		
		// 페이징: 페이징 정보 SET
		PageNavigator navi = new PageNavigator(param, viewCount, totalCount);
		
		List<Map<String, Object>> designList = reportDao.selectBusinessTripPlanList(param);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("pageNo", pageNo);
		map.put("totalCount", totalCount);
		map.put("list", designList);	
		map.put("navi", navi);
		return map;
	}
	
	@Override
	public int insertBusinessTripPlanTmp(Map<String, Object> param, MultipartFile[] file) throws Exception {
		// TODO Auto-generated method stub
		int planIdx = 0;
		try {
			JSONParser parser = new JSONParser();
			JSONArray deptArr = (JSONArray) parser.parse((String)param.get("deptArr"));
			JSONArray positionArr = (JSONArray) parser.parse((String)param.get("positionArr"));
			JSONArray nameArr = (JSONArray) parser.parse((String)param.get("nameArr"));
			JSONArray purposeArr = (JSONArray) parser.parse((String)param.get("purposeArr"));
			JSONArray tripDestinationArr = (JSONArray) parser.parse((String)param.get("tripDestinationArr"));
			JSONArray scheduleArr = (JSONArray) parser.parse((String)param.get("scheduleArr"));
			JSONArray contentArr = (JSONArray) parser.parse((String)param.get("contentArr"));
			JSONArray placeArr = (JSONArray) parser.parse((String)param.get("placeArr"));
			JSONArray noteArr = (JSONArray) parser.parse((String)param.get("noteArr"));
			
			
			planIdx = reportDao.selectTripPlanSeq();	//key value 조회
			param.put("idx", planIdx);
			
			//1. 출장계획 등록
			reportDao.insertBusinessTripPlan(param);			
			
			//2. 출장자 등록
			ArrayList<HashMap<String,Object>> userList = new ArrayList<HashMap<String,Object>>();
			for( int i = 0 ; i < deptArr.size() ; i++ ) {
				HashMap<String,Object> userMap = new HashMap<String,Object>();
				userMap.put("idx", planIdx);
				userMap.put("displayOrder", i+1);
				
				try{
					userMap.put("dept", deptArr.get(i));
				} catch(Exception e) {
					userMap.put("dept", "");
				}
				
				try{
					userMap.put("position", positionArr.get(i));
				} catch(Exception e) {
					userMap.put("position", "");
				}
				
				try{
					userMap.put("name", nameArr.get(i));
				} catch(Exception e) {
					userMap.put("name", "");
				}
				
				userList.add(userMap);
			}			
			if( userList != null && userList.size() > 0 ) {
				reportDao.insertBusinessTripPlanUser(userList);
			}
			
			//3. 추가 정보 등록
			ArrayList<HashMap<String,Object>> addInfoList = new ArrayList<HashMap<String,Object>>();
			if( purposeArr.size() > 0 ) {
				for( int i = 0 ; i < purposeArr.size() ; i++ ) {					
					if( purposeArr.get(i) != null && !"".equals(purposeArr.get(i)) ) {
						HashMap<String,Object> purposeData = new HashMap<String,Object>();
						purposeData.put("idx", planIdx);
						purposeData.put("displayOrder", i+1);
						purposeData.put("infoType", "PUR");
						purposeData.put("infoText", purposeArr.get(i));
						addInfoList.add(purposeData);
					}
				}				
			}
			
			if( tripDestinationArr.size() > 0 ) {
				for( int i = 0 ; i < tripDestinationArr.size() ; i++ ) {
					if( tripDestinationArr.get(i) != null && !"".equals(tripDestinationArr.get(i)) ) {
						HashMap<String,Object> featureData = new HashMap<String,Object>();
						featureData.put("idx", planIdx);
						featureData.put("displayOrder", i+1);
						featureData.put("infoType", "DEST");
						featureData.put("infoText", tripDestinationArr.get(i));
						addInfoList.add(featureData);
					}
				}
			}
			
			if( addInfoList != null && addInfoList.size() > 0 ) {
				reportDao.insertBusinessTripPlanAddInfo(addInfoList);
			}
			
			//4. 업무수행내용 등록
			ArrayList<HashMap<String,Object>> contentList = new ArrayList<HashMap<String,Object>>();
			for( int i = 0 ; i < scheduleArr.size() ; i++ ) {
				HashMap<String,Object> contentMap = new HashMap<String,Object>();
				contentMap.put("idx", planIdx);
				contentMap.put("displayOrder", i+1);
				
				try{
					contentMap.put("schedule", scheduleArr.get(i));
				} catch(Exception e) {
					contentMap.put("schedule", "");
				}
				
				try{
					contentMap.put("content", contentArr.get(i));
				} catch(Exception e) {
					contentMap.put("content", "");
				}
				
				try{
					contentMap.put("place", placeArr.get(i));
				} catch(Exception e) {
					contentMap.put("place", "");
				}
				
				try{
					contentMap.put("note", noteArr.get(i));
				} catch(Exception e) {
					contentMap.put("note", "");
				}
				
				contentList.add(contentMap);
			}			
			if( contentList != null && contentList.size() > 0 ) {
				reportDao.insertBusinessTripPlanContents(contentList);
			}
			
			//history 저장
			Map<String, Object> historyParam = new HashMap<String, Object>();
			historyParam.put("docIdx", planIdx);
			historyParam.put("docType", param.get("docType"));
			historyParam.put("historyType", "T");
			historyParam.put("historyData", param.toString());
			historyParam.put("userId", param.get("userId"));
			testDao.insertHistory(historyParam);
			
			
			//파일 DB 저장
			if( file != null && file.length > 0 ) {
				Calendar cal = Calendar.getInstance();
		        Date day = cal.getTime();    //시간을 꺼낸다.
		        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
		        String toDay = sdf.format(day);
				String path = config.getProperty("upload.file.path.trip");
				path += "/"+toDay; 
				int idx = 0;
				for( MultipartFile multipartFile : file ) {
					System.err.println("=================================");
					System.err.println("isEmpty : "+multipartFile.isEmpty());
					System.err.println("name : " + multipartFile.getName());
					System.err.println("originalFilename : " + multipartFile.getOriginalFilename());		
					System.err.println("size : " + multipartFile.getSize());				
					System.err.println("=================================");
					try {
						if( !multipartFile.isEmpty() ) {
							String fileIdx = FileUtil.getUUID();
							String result = FileUtil.upload3(multipartFile,path,fileIdx);
							String content = FileUtil.getPdfContents(path, result);
							Map<String,Object> fileMap = new HashMap<String,Object>();
							fileMap.put("fileIdx", fileIdx);
							fileMap.put("docIdx", planIdx);
							fileMap.put("docType", param.get("docType"));
							fileMap.put("fileType", "00");
							fileMap.put("orgFileName", multipartFile.getOriginalFilename());
							fileMap.put("filePath", path);
							fileMap.put("changeFileName", result);
							fileMap.put("content", content);
							System.err.println(fileMap);
							//파일정보 저장
							testDao.insertFileInfo(fileMap);
							idx++;
						}
					} catch( Exception e ) {
						//throw e;
					}					
				}
			}
			
		} catch( Exception e ) {
			e.printStackTrace();
			throw e;
		}
		return planIdx;
	}	


	@Override
	public int insertBusinessTripPlan(Map<String, Object> param, MultipartFile[] file) throws Exception {
		// TODO Auto-generated method stub
		int planIdx = 0;
		try {
			JSONParser parser = new JSONParser();
			JSONArray deptArr = (JSONArray) parser.parse((String)param.get("deptArr"));
			JSONArray positionArr = (JSONArray) parser.parse((String)param.get("positionArr"));
			JSONArray nameArr = (JSONArray) parser.parse((String)param.get("nameArr"));
			JSONArray purposeArr = (JSONArray) parser.parse((String)param.get("purposeArr"));
			JSONArray tripDestinationArr = (JSONArray) parser.parse((String)param.get("tripDestinationArr"));
			JSONArray scheduleArr = (JSONArray) parser.parse((String)param.get("scheduleArr"));
			JSONArray contentArr = (JSONArray) parser.parse((String)param.get("contentArr"));
			JSONArray placeArr = (JSONArray) parser.parse((String)param.get("placeArr"));
			JSONArray noteArr = (JSONArray) parser.parse((String)param.get("noteArr"));
			
			planIdx = reportDao.selectTripPlanSeq();	//key value 조회
			param.put("idx", planIdx);
			//param.put("status", "REG");
			
			//1. 출장계획 등록
			reportDao.insertBusinessTripPlan(param);
			
			//2. 출장자 등록
			ArrayList<HashMap<String,Object>> userList = new ArrayList<HashMap<String,Object>>();
			for( int i = 0 ; i < deptArr.size() ; i++ ) {
				HashMap<String,Object> userMap = new HashMap<String,Object>();
				userMap.put("idx", planIdx);
				userMap.put("displayOrder", i+1);
				
				try{
					userMap.put("dept", deptArr.get(i));
				} catch(Exception e) {
					userMap.put("dept", "");
				}
				
				try{
					userMap.put("position", positionArr.get(i));
				} catch(Exception e) {
					userMap.put("position", "");
				}
				
				try{
					userMap.put("name", nameArr.get(i));
				} catch(Exception e) {
					userMap.put("name", "");
				}
				
				userList.add(userMap);
			}			
			if( userList != null && userList.size() > 0 ) {
				reportDao.insertBusinessTripPlanUser(userList);
			}
			
			//3. 추가 정보 등록
			ArrayList<HashMap<String,Object>> addInfoList = new ArrayList<HashMap<String,Object>>();
			if( purposeArr.size() > 0 ) {
				for( int i = 0 ; i < purposeArr.size() ; i++ ) {					
					if( purposeArr.get(i) != null && "".equals(purposeArr.get(i)) ) {
						HashMap<String,Object> purposeData = new HashMap<String,Object>();
						purposeData.put("idx", planIdx);
						purposeData.put("displayOrder", i+1);
						purposeData.put("infoType", "PUR");
						purposeData.put("infoText", purposeArr.get(i));
						addInfoList.add(purposeData);
					}
				}				
			}
			
			if( tripDestinationArr.size() > 0 ) {
				for( int i = 0 ; i < tripDestinationArr.size() ; i++ ) {
					if( tripDestinationArr.get(i) != null && "".equals(tripDestinationArr.get(i)) ) {
						HashMap<String,Object> featureData = new HashMap<String,Object>();
						featureData.put("idx", planIdx);
						featureData.put("displayOrder", i+1);
						featureData.put("infoType", "DEST");
						featureData.put("infoText", tripDestinationArr.get(i));
						addInfoList.add(featureData);
					}
				}
			}
			
			if( addInfoList != null && addInfoList.size() > 0 ) {
				reportDao.insertBusinessTripPlanAddInfo(addInfoList);
			}
			
			//4. 업무수행내용 등록
			ArrayList<HashMap<String,Object>> contentList = new ArrayList<HashMap<String,Object>>();
			for( int i = 0 ; i < scheduleArr.size() ; i++ ) {
				HashMap<String,Object> contentMap = new HashMap<String,Object>();
				contentMap.put("idx", planIdx);
				contentMap.put("displayOrder", i+1);
				
				try{
					contentMap.put("schedule", scheduleArr.get(i));
				} catch(Exception e) {
					contentMap.put("schedule", "");
				}
				
				try{
					contentMap.put("content", contentArr.get(i));
				} catch(Exception e) {
					contentMap.put("content", "");
				}
				
				try{
					contentMap.put("place", placeArr.get(i));
				} catch(Exception e) {
					contentMap.put("place", "");
				}
				
				try{
					contentMap.put("note", noteArr.get(i));
				} catch(Exception e) {
					contentMap.put("note", "");
				}
				
				contentList.add(contentMap);
			}			
			if( contentList != null && contentList.size() > 0 ) {
				reportDao.insertBusinessTripPlanContents(contentList);
			}
			
			//history 저장
			Map<String, Object> historyParam = new HashMap<String, Object>();
			historyParam.put("docIdx", planIdx);
			historyParam.put("docType", param.get("docType"));
			historyParam.put("historyType", "I");
			historyParam.put("historyData", param.toString());
			historyParam.put("userId", param.get("userId"));
			testDao.insertHistory(historyParam);
			
			
			//파일 DB 저장
			if( file != null && file.length > 0 ) {
				Calendar cal = Calendar.getInstance();
		        Date day = cal.getTime();    //시간을 꺼낸다.
		        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
		        String toDay = sdf.format(day);
				String path = config.getProperty("upload.file.path.trip");
				path += "/"+toDay; 
				int idx = 0;
				for( MultipartFile multipartFile : file ) {
					System.err.println("=================================");
					System.err.println("isEmpty : "+multipartFile.isEmpty());
					System.err.println("name : " + multipartFile.getName());
					System.err.println("originalFilename : " + multipartFile.getOriginalFilename());		
					System.err.println("size : " + multipartFile.getSize());				
					System.err.println("=================================");
					try {
						if( !multipartFile.isEmpty() ) {
							String fileIdx = FileUtil.getUUID();
							String result = FileUtil.upload3(multipartFile,path,fileIdx);
							String content = FileUtil.getPdfContents(path, result);
							Map<String,Object> fileMap = new HashMap<String,Object>();
							fileMap.put("fileIdx", fileIdx);
							fileMap.put("docIdx", planIdx);
							fileMap.put("docType", param.get("docType"));
							fileMap.put("fileType", "00");
							fileMap.put("orgFileName", multipartFile.getOriginalFilename());
							fileMap.put("filePath", path);
							fileMap.put("changeFileName", result);
							fileMap.put("content", content);
							System.err.println(fileMap);
							//파일정보 저장
							testDao.insertFileInfo(fileMap);
							idx++;
						}
					} catch( Exception e ) {
						//throw e;
					}					
				}
			}
		} catch( Exception e ) {
			throw e;
		}
		return planIdx;
	}


	@Override
	public Map<String, Object> selectBusinessTripPlanData(Map<String, Object> param) {
		// TODO Auto-generated method stub
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> data = reportDao.selectBusinessTripPlanData(param);
		param.put("docType", "PLAN");
		List<Map<String, String>> fileList = testDao.selectFileList(param);
		map.put("data", data);
		map.put("fileList", fileList);
		//return reportDao.selectBusinessTripPlanData(param);
		return map;
	}
	
	@Override
	public List<Map<String, Object>> selectBusinessTripPlanUserList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return reportDao.selectBusinessTripPlanUserList(param);
	}


	@Override
	public List<Map<String, Object>> selectBusinessTripPlanAddInfoList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return reportDao.selectBusinessTripPlanAddInfoList(param);
	}


	@Override
	public List<Map<String, Object>> selectBusinessTripPlanContentsList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return reportDao.selectBusinessTripPlanContentsList(param);
	}
	
	@Override
	public void updateBusinessTripPlanTmp(Map<String, Object> param, MultipartFile[] file) throws Exception {
		// TODO Auto-generated method stub
		try {
			JSONParser parser = new JSONParser();
			JSONArray deptArr = (JSONArray) parser.parse((String)param.get("deptArr"));
			JSONArray positionArr = (JSONArray) parser.parse((String)param.get("positionArr"));
			JSONArray nameArr = (JSONArray) parser.parse((String)param.get("nameArr"));
			JSONArray purposeArr = (JSONArray) parser.parse((String)param.get("purposeArr"));
			JSONArray tripDestinationArr = (JSONArray) parser.parse((String)param.get("tripDestinationArr"));
			JSONArray scheduleArr = (JSONArray) parser.parse((String)param.get("scheduleArr"));
			JSONArray contentArr = (JSONArray) parser.parse((String)param.get("contentArr"));
			JSONArray placeArr = (JSONArray) parser.parse((String)param.get("placeArr"));
			JSONArray noteArr = (JSONArray) parser.parse((String)param.get("noteArr"));
			
			//1. 출장계획 등록
			reportDao.updateBusinessTripPlan(param);			
			
			//2. 출장자 등록
			ArrayList<HashMap<String,Object>> userList = new ArrayList<HashMap<String,Object>>();
			reportDao.deleteBusinessTripPlanUser(param);
			for( int i = 0 ; i < deptArr.size() ; i++ ) {
				HashMap<String,Object> userMap = new HashMap<String,Object>();
				userMap.put("idx", param.get("idx"));
				userMap.put("displayOrder", i+1);
				
				try{
					userMap.put("dept", deptArr.get(i));
				} catch(Exception e) {
					userMap.put("dept", "");
				}
				
				try{
					userMap.put("position", positionArr.get(i));
				} catch(Exception e) {
					userMap.put("position", "");
				}
				
				try{
					userMap.put("name", nameArr.get(i));
				} catch(Exception e) {
					userMap.put("name", "");
				}
				
				userList.add(userMap);
			}			
			if( userList != null && userList.size() > 0 ) {
				reportDao.insertBusinessTripPlanUser(userList);
			}
			
			//3. 추가 정보 등록
			ArrayList<HashMap<String,Object>> addInfoList = new ArrayList<HashMap<String,Object>>();
			reportDao.deleteBusinessTripPlanAddInfo(param);
			if( purposeArr.size() > 0 ) {
				for( int i = 0 ; i < purposeArr.size() ; i++ ) {					
					if( purposeArr.get(i) != null && !"".equals(purposeArr.get(i)) ) {
						HashMap<String,Object> purposeData = new HashMap<String,Object>();
						purposeData.put("idx", param.get("idx"));
						purposeData.put("displayOrder", i+1);
						purposeData.put("infoType", "PUR");
						purposeData.put("infoText", purposeArr.get(i));
						addInfoList.add(purposeData);
					}
				}				
			}
			
			if( tripDestinationArr.size() > 0 ) {
				for( int i = 0 ; i < tripDestinationArr.size() ; i++ ) {
					if( tripDestinationArr.get(i) != null && !"".equals(tripDestinationArr.get(i)) ) {
						HashMap<String,Object> featureData = new HashMap<String,Object>();
						featureData.put("idx", param.get("idx"));
						featureData.put("displayOrder", i+1);
						featureData.put("infoType", "DEST");
						featureData.put("infoText", tripDestinationArr.get(i));
						addInfoList.add(featureData);
					}
				}
			}
			
			if( addInfoList != null && addInfoList.size() > 0 ) {
				reportDao.insertBusinessTripPlanAddInfo(addInfoList);
			}
			
			//4. 업무수행내용 등록
			ArrayList<HashMap<String,Object>> contentList = new ArrayList<HashMap<String,Object>>();
			reportDao.deleteBusinessTripPlanContents(param);
			for( int i = 0 ; i < scheduleArr.size() ; i++ ) {
				HashMap<String,Object> contentMap = new HashMap<String,Object>();
				contentMap.put("idx", param.get("idx"));
				contentMap.put("displayOrder", i+1);
				
				try{
					contentMap.put("schedule", scheduleArr.get(i));
				} catch(Exception e) {
					contentMap.put("schedule", "");
				}
				
				try{
					contentMap.put("content", contentArr.get(i));
				} catch(Exception e) {
					contentMap.put("content", "");
				}
				
				try{
					contentMap.put("place", placeArr.get(i));
				} catch(Exception e) {
					contentMap.put("place", "");
				}
				
				try{
					contentMap.put("note", noteArr.get(i));
				} catch(Exception e) {
					contentMap.put("note", "");
				}
				
				contentList.add(contentMap);
			}			
			if( contentList != null && contentList.size() > 0 ) {
				reportDao.insertBusinessTripPlanContents(contentList);
			}
			
			//history 저장
			Map<String, Object> historyParam = new HashMap<String, Object>();
			historyParam.put("docIdx", param.get("idx"));
			historyParam.put("docType", param.get("docType"));
			historyParam.put("historyType", "U");
			historyParam.put("historyData", param.toString());
			historyParam.put("userId", param.get("userId"));
			testDao.insertHistory(historyParam);
			
			
			//파일 DB 저장
			if( file != null && file.length > 0 ) {
				Calendar cal = Calendar.getInstance();
		        Date day = cal.getTime();    //시간을 꺼낸다.
		        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
		        String toDay = sdf.format(day);
				String path = config.getProperty("upload.file.path.trip");
				path += "/"+toDay; 
				int idx = 0;
				for( MultipartFile multipartFile : file ) {
					System.err.println("=================================");
					System.err.println("isEmpty : "+multipartFile.isEmpty());
					System.err.println("name : " + multipartFile.getName());
					System.err.println("originalFilename : " + multipartFile.getOriginalFilename());		
					System.err.println("size : " + multipartFile.getSize());				
					System.err.println("=================================");
					try {
						if( !multipartFile.isEmpty() ) {
							String fileIdx = FileUtil.getUUID();
							String result = FileUtil.upload3(multipartFile,path,fileIdx);
							String content = FileUtil.getPdfContents(path, result);
							Map<String,Object> fileMap = new HashMap<String,Object>();
							fileMap.put("fileIdx", fileIdx);
							fileMap.put("docIdx", param.get("idx"));
							fileMap.put("docType", param.get("docType"));
							fileMap.put("fileType", "00");
							fileMap.put("orgFileName", multipartFile.getOriginalFilename());
							fileMap.put("filePath", path);
							fileMap.put("changeFileName", result);
							fileMap.put("content", content);
							System.err.println(fileMap);
							//파일정보 저장
							testDao.insertFileInfo(fileMap);
							idx++;
						}
					} catch( Exception e ) {
						//throw e;
					}					
				}
			}			
		} catch( Exception e ) {
			e.printStackTrace();
			throw e;
		}
	}


	@Override
	public void updateBusinessTripPlan(Map<String, Object> param, MultipartFile[] file) throws Exception {
		// TODO Auto-generated method stub
		try {
			JSONParser parser = new JSONParser();
			JSONArray deptArr = (JSONArray) parser.parse((String)param.get("deptArr"));
			JSONArray positionArr = (JSONArray) parser.parse((String)param.get("positionArr"));
			JSONArray nameArr = (JSONArray) parser.parse((String)param.get("nameArr"));
			JSONArray purposeArr = (JSONArray) parser.parse((String)param.get("purposeArr"));
			JSONArray tripDestinationArr = (JSONArray) parser.parse((String)param.get("tripDestinationArr"));
			JSONArray scheduleArr = (JSONArray) parser.parse((String)param.get("scheduleArr"));
			JSONArray contentArr = (JSONArray) parser.parse((String)param.get("contentArr"));
			JSONArray placeArr = (JSONArray) parser.parse((String)param.get("placeArr"));
			JSONArray noteArr = (JSONArray) parser.parse((String)param.get("noteArr"));
			
			if( param.get("currentStatus") != null && "COND_APPR".equals(param.get("currentStatus")) ) {
				param.put("status", "APPR");
			}
			
			//1. 출장계획 등록
			reportDao.updateBusinessTripPlan(param);			
			
			//2. 출장자 등록
			ArrayList<HashMap<String,Object>> userList = new ArrayList<HashMap<String,Object>>();
			reportDao.deleteBusinessTripPlanUser(param);
			for( int i = 0 ; i < deptArr.size() ; i++ ) {
				HashMap<String,Object> userMap = new HashMap<String,Object>();
				userMap.put("idx", param.get("idx"));
				userMap.put("displayOrder", i+1);
				
				try{
					userMap.put("dept", deptArr.get(i));
				} catch(Exception e) {
					userMap.put("dept", "");
				}
				
				try{
					userMap.put("position", positionArr.get(i));
				} catch(Exception e) {
					userMap.put("position", "");
				}
				
				try{
					userMap.put("name", nameArr.get(i));
				} catch(Exception e) {
					userMap.put("name", "");
				}
				
				userList.add(userMap);
			}			
			if( userList != null && userList.size() > 0 ) {
				reportDao.insertBusinessTripPlanUser(userList);
			}
			
			//3. 추가 정보 등록
			ArrayList<HashMap<String,Object>> addInfoList = new ArrayList<HashMap<String,Object>>();
			reportDao.deleteBusinessTripPlanAddInfo(param);
			if( purposeArr.size() > 0 ) {
				for( int i = 0 ; i < purposeArr.size() ; i++ ) {					
					if( purposeArr.get(i) != null && !"".equals(purposeArr.get(i)) ) {
						HashMap<String,Object> purposeData = new HashMap<String,Object>();
						purposeData.put("idx", param.get("idx"));
						purposeData.put("displayOrder", i+1);
						purposeData.put("infoType", "PUR");
						purposeData.put("infoText", purposeArr.get(i));
						addInfoList.add(purposeData);
					}
				}				
			}
			
			if( tripDestinationArr.size() > 0 ) {
				for( int i = 0 ; i < tripDestinationArr.size() ; i++ ) {
					if( tripDestinationArr.get(i) != null && !"".equals(tripDestinationArr.get(i)) ) {
						HashMap<String,Object> featureData = new HashMap<String,Object>();
						featureData.put("idx", param.get("idx"));
						featureData.put("displayOrder", i+1);
						featureData.put("infoType", "DEST");
						featureData.put("infoText", tripDestinationArr.get(i));
						addInfoList.add(featureData);
					}
				}
			}
			
			if( addInfoList != null && addInfoList.size() > 0 ) {
				reportDao.insertBusinessTripPlanAddInfo(addInfoList);
			}
			
			//4. 업무수행내용 등록
			ArrayList<HashMap<String,Object>> contentList = new ArrayList<HashMap<String,Object>>();
			reportDao.deleteBusinessTripPlanContents(param);
			for( int i = 0 ; i < scheduleArr.size() ; i++ ) {
				HashMap<String,Object> contentMap = new HashMap<String,Object>();
				contentMap.put("idx", param.get("idx"));
				contentMap.put("displayOrder", i+1);
				
				try{
					contentMap.put("schedule", scheduleArr.get(i));
				} catch(Exception e) {
					contentMap.put("schedule", "");
				}
				
				try{
					contentMap.put("content", contentArr.get(i));
				} catch(Exception e) {
					contentMap.put("content", "");
				}
				
				try{
					contentMap.put("place", placeArr.get(i));
				} catch(Exception e) {
					contentMap.put("place", "");
				}
				
				try{
					contentMap.put("note", noteArr.get(i));
				} catch(Exception e) {
					contentMap.put("note", "");
				}
				
				contentList.add(contentMap);
			}			
			if( contentList != null && contentList.size() > 0 ) {
				reportDao.insertBusinessTripPlanContents(contentList);
			}
			
			//history 저장
			Map<String, Object> historyParam = new HashMap<String, Object>();
			historyParam.put("docIdx", param.get("idx"));
			historyParam.put("docType", param.get("docType"));
			historyParam.put("historyType", "U");
			historyParam.put("historyData", param.toString());
			historyParam.put("userId", param.get("userId"));
			testDao.insertHistory(historyParam);
			
			
			//파일 DB 저장
			if( file != null && file.length > 0 ) {
				Calendar cal = Calendar.getInstance();
		        Date day = cal.getTime();    //시간을 꺼낸다.
		        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
		        String toDay = sdf.format(day);
				String path = config.getProperty("upload.file.path.trip");
				path += "/"+toDay; 
				int idx = 0;
				for( MultipartFile multipartFile : file ) {
					System.err.println("=================================");
					System.err.println("isEmpty : "+multipartFile.isEmpty());
					System.err.println("name : " + multipartFile.getName());
					System.err.println("originalFilename : " + multipartFile.getOriginalFilename());		
					System.err.println("size : " + multipartFile.getSize());				
					System.err.println("=================================");
					try {
						if( !multipartFile.isEmpty() ) {
							String fileIdx = FileUtil.getUUID();
							String result = FileUtil.upload3(multipartFile,path,fileIdx);
							String content = FileUtil.getPdfContents(path, result);
							Map<String,Object> fileMap = new HashMap<String,Object>();
							fileMap.put("fileIdx", fileIdx);
							fileMap.put("docIdx", param.get("idx"));
							fileMap.put("docType", param.get("docType"));
							fileMap.put("fileType", "00");
							fileMap.put("orgFileName", multipartFile.getOriginalFilename());
							fileMap.put("filePath", path);
							fileMap.put("changeFileName", result);
							fileMap.put("content", content);
							System.err.println(fileMap);
							//파일정보 저장
							testDao.insertFileInfo(fileMap);
							idx++;
						}
					} catch( Exception e ) {
						//throw e;
					}					
				}
			}			
		} catch( Exception e ) {
			e.printStackTrace();
			throw e;
		}
	}
	
	@Override
	public int insertSenseQualityTmp(Map<String, Object> param, HashMap<String, Object> listMap, MultipartFile[] file)
			throws Exception {
		// TODO Auto-generated method stub
		int reportIdx = 0;
		try {
			JSONArray contentsDivArr = (JSONArray)listMap.get("contentsDivArr");
			JSONArray contentsResultArr = (JSONArray)listMap.get("contentsResultArr");
			JSONArray contentsNoteArr = (JSONArray)listMap.get("contentsNoteArr");
			JSONArray resultArr = (JSONArray)listMap.get("resultArr");
			//1. key value 조회
			reportIdx = reportDao.selectSenseQualitySeq();	//key value 조회
			param.put("idx", reportIdx);
			
			//2. lab_sense_quality_report 등록
			reportDao.insertSenseQualityReport(param);
			
			//3. lab_sense_quality_contents 등록
			ArrayList<HashMap<String,Object>> contentsList = new ArrayList<HashMap<String,Object>>();
			
			Calendar cal = Calendar.getInstance();
	        Date day = cal.getTime();    //시간을 꺼낸다.
	        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
	        String toDay = sdf.format(day);
			String path = config.getProperty("upload.file.path.images");
			path += "/"+toDay; 			
			for( int i = 0 ; i < contentsDivArr.size() ; i++ ) {
				HashMap<String,Object> contentsMap = new HashMap<String,Object>();
				contentsMap.put("idx", reportIdx);
				contentsMap.put("displayOrder", i+1);
				
				try{
					contentsMap.put("contentsDiv", contentsDivArr.get(i));
				} catch(Exception e) {
					contentsMap.put("contentsDiv", "");
				}
				
				try{
					contentsMap.put("contentsResult", contentsResultArr.get(i));
				} catch(Exception e) {
					contentsMap.put("contentsResult", "");
				}
				
				try {
					MultipartFile multipartFile = file[i];
					if( file != null && file.length > 0 ) {
						if( !multipartFile.isEmpty() ) {
							String fileIdx = FileUtil.getUUID();
							String result = FileUtil.upload3(multipartFile,path,fileIdx);
							contentsMap.put("orgFileName", multipartFile.getOriginalFilename());
							contentsMap.put("filePath", "/"+toDay);
							contentsMap.put("changeFileName", result);
						} else {
							contentsMap.put("orgFileName", "");
							contentsMap.put("filePath", "");
							contentsMap.put("changeFileName", "");
						}
					} else {
						contentsMap.put("orgFileName", "");
						contentsMap.put("filePath", "");
						contentsMap.put("changeFileName", "");
					}
				} catch( Exception e ) {
					contentsMap.put("orgFileName", "");
					contentsMap.put("filePath", "");
					contentsMap.put("changeFileName", "");
				}
				
				contentsList.add(contentsMap);
			}			
			reportDao.insertSenseQualityContents(contentsList);
			
			
			//4. lab_sense_quality_add_info 등록
			ArrayList<HashMap<String,Object>> addInfoList = new ArrayList<HashMap<String,Object>>();
			if( contentsNoteArr != null && contentsNoteArr.size() > 0 ) {
				for( int i = 0 ; i < contentsNoteArr.size() ; i++ ) {
					HashMap<String,Object> contentsNoteData = new HashMap<String,Object>();
					contentsNoteData.put("idx", reportIdx);
					contentsNoteData.put("infoType", "NOTE");
					contentsNoteData.put("infoText", contentsNoteArr.get(i));
					addInfoList.add(contentsNoteData);
				}				
			}
			
			if( resultArr != null && resultArr.size() > 0 ) {
				for( int i = 0 ; i < resultArr.size() ; i++ ) {
					HashMap<String,Object> resultData = new HashMap<String,Object>();
					resultData.put("idx", reportIdx);
					resultData.put("infoType", "RESULT");
					resultData.put("infoText", resultArr.get(i));
					addInfoList.add(resultData);
				}				
			}
			
			if( addInfoList != null && addInfoList.size() > 0 ) {
				//등록한다.
				reportDao.insertSenseQualityAddInfo(addInfoList);
			}

		} catch( Exception e ) {
			e.printStackTrace();
			throw e;
		}
		return reportIdx;
	}	

	@Override
	public int insertSenseQuality(Map<String, Object> param, HashMap<String, Object> listMap, MultipartFile[] file) throws Exception {
		// TODO Auto-generated method stub
		int reportIdx = 0;
		try {
			JSONArray contentsDivArr = (JSONArray)listMap.get("contentsDivArr");
			JSONArray contentsResultArr = (JSONArray)listMap.get("contentsResultArr");
			JSONArray contentsNoteArr = (JSONArray)listMap.get("contentsNoteArr");
			JSONArray resultArr = (JSONArray)listMap.get("resultArr");
			//1. key value 조회
			reportIdx = reportDao.selectSenseQualitySeq();	//key value 조회
			param.put("idx", reportIdx);
			//param.put("status", "REG");
			
			//2. lab_sense_quality_report 등록
			reportDao.insertSenseQualityReport(param);
			
			//3. lab_sense_quality_contents 등록
			ArrayList<HashMap<String,Object>> contentsList = new ArrayList<HashMap<String,Object>>();
			
			Calendar cal = Calendar.getInstance();
	        Date day = cal.getTime();    //시간을 꺼낸다.
	        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
	        String toDay = sdf.format(day);
			String path = config.getProperty("upload.file.path.images");
			path += "/"+toDay; 			
			for( int i = 0 ; i < contentsDivArr.size() ; i++ ) {
				HashMap<String,Object> contentsMap = new HashMap<String,Object>();
				contentsMap.put("idx", reportIdx);
				contentsMap.put("displayOrder", i+1);
				
				try{
					contentsMap.put("contentsDiv", contentsDivArr.get(i));
				} catch(Exception e) {
					contentsMap.put("contentsDiv", "");
				}
				
				try{
					contentsMap.put("contentsResult", contentsResultArr.get(i));
				} catch(Exception e) {
					contentsMap.put("contentsResult", "");
				}
				
				try {
					MultipartFile multipartFile = file[i];
					if( file != null && file.length > 0 ) {
						if( !multipartFile.isEmpty() ) {
							String fileIdx = FileUtil.getUUID();
							String result = FileUtil.upload3(multipartFile,path,fileIdx);
							contentsMap.put("orgFileName", multipartFile.getOriginalFilename());
							contentsMap.put("filePath", "/"+toDay);
							contentsMap.put("changeFileName", result);
						} else {
							contentsMap.put("orgFileName", "");
							contentsMap.put("filePath", "");
							contentsMap.put("changeFileName", "");
						}
					} else {
						contentsMap.put("orgFileName", "");
						contentsMap.put("filePath", "");
						contentsMap.put("changeFileName", "");
					}
				} catch( Exception e ) {
					contentsMap.put("orgFileName", "");
					contentsMap.put("filePath", "");
					contentsMap.put("changeFileName", "");
				}
				
				contentsList.add(contentsMap);
			}			
			reportDao.insertSenseQualityContents(contentsList);
			
			
			//4. lab_sense_quality_add_info 등록
			ArrayList<HashMap<String,Object>> addInfoList = new ArrayList<HashMap<String,Object>>();
			if( contentsNoteArr != null && contentsNoteArr.size() > 0 ) {
				for( int i = 0 ; i < contentsNoteArr.size() ; i++ ) {
					HashMap<String,Object> contentsNoteData = new HashMap<String,Object>();
					contentsNoteData.put("idx", reportIdx);
					contentsNoteData.put("infoType", "NOTE");
					contentsNoteData.put("infoText", contentsNoteArr.get(i));
					addInfoList.add(contentsNoteData);
				}				
			}
			
			if( resultArr != null && resultArr.size() > 0 ) {
				for( int i = 0 ; i < resultArr.size() ; i++ ) {
					HashMap<String,Object> resultData = new HashMap<String,Object>();
					resultData.put("idx", reportIdx);
					resultData.put("infoType", "RESULT");
					resultData.put("infoText", resultArr.get(i));
					addInfoList.add(resultData);
				}				
			}
			
			if( addInfoList != null && addInfoList.size() > 0 ) {
				//등록한다.
				reportDao.insertSenseQualityAddInfo(addInfoList);
			}
		} catch( Exception e ) {
			throw e;
		}
		return reportIdx;
	}


	@Override
	public Map<String, Object> selectSenseQualityList(Map<String, Object> param) throws Exception{
		// TODO Auto-generated method stub
		int totalCount = reportDao.selectSenseQualityCount(param);
		
		int viewCount = 10;
		int pageNo = 1;
		try {
			pageNo = Integer.parseInt((String)param.get("pageNo"));
		} catch( Exception e ) {
			System.err.println(e.getMessage());
			pageNo = 1;
		}
		
		try {
			viewCount = Integer.parseInt((String)param.get("viewCount"));
		} catch( Exception e ) {
			System.err.println(e.getMessage());
			viewCount = 10;
		}
		
		// 페이징: 페이징 정보 SET
		PageNavigator navi = new PageNavigator(param, viewCount, totalCount);
		
		List<Map<String, Object>> designList = reportDao.selectSenseQualityList(param);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("pageNo", pageNo);
		map.put("totalCount", totalCount);
		map.put("list", designList);	
		map.put("navi", navi);
		return map;
	}


	@Override
	public Map<String, Object> selectSenseQualityData(Map<String, Object> param) {
		// TODO Auto-generated method stub
		//1. lab_sense_quality_report 조회
		Map<String, Object> reportMap = reportDao.selectSenseQualityReport(param);
		//2. lab_sense_quality_contents 조회
		List<Map<String, Object>> contentsList = reportDao.selectSenseQualityContensts(param);
		
		int totalCount = contentsList.size();
		int modCount = totalCount/3;
		if( totalCount % 3 > 0  ) {
			modCount++;
		}
		
		//3. lab_sense_quality_add_info 조회
		param.put("infoType", "NOTE");
		List<Map<String, Object>> infoNoteList = reportDao.selectSenseQualityInfo(param);		
		param.put("infoType", "RESULT");
		List<Map<String, Object>> infoResultList = reportDao.selectSenseQualityInfo(param);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("reportMap", reportMap);
		map.put("contentsList", contentsList);
		map.put("totalCount", totalCount);
		map.put("modCount", modCount);
		map.put("infoNoteList", infoNoteList);
		map.put("infoResultList", infoResultList);
		
		return map;
	}



	@Override
	public void deleteSenseQualityContenstsData(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method
		try {
			//1. 데이터를 조회한다.
			Map<String, Object> contenstsMap = reportDao.selectSenseQualityContenstsData(param);
			if( contenstsMap != null  ) {
				//2. 업로드 파일을 삭제한다.
				String path = config.getProperty("upload.file.path.images");
				path += contenstsMap.get("FILE_PATH")+"/"+contenstsMap.get("ORG_FILE_NAME"); 
				File file = new File(path);
				if(file.exists() == true){		
					file.delete();				// 해당 경로의 파일이 존재하면 파일 삭제
				}
				//3. 데이터를 삭제한다.
				reportDao.deleteSenseQualityContenstsData(param);
			}
		} catch( Exception e ) {
			throw e;
		}		
	}


	@Override
	public void updateSenseQualityTmp(Map<String, Object> param, HashMap<String, Object> dataListMap, 
			HashMap<String, Object> fileMap, HashMap<String, Object> listMap, MultipartFile[] file) throws Exception {
		// TODO Auto-generated method stub
		JSONArray contentsNoteArr = (JSONArray)listMap.get("contentsNoteArr");
		JSONArray resultArr = (JSONArray)listMap.get("resultArr");
		
		//1. lab_sense_quality_report 등록
		reportDao.updateSenseQualityReport(param);
		
		Iterator<String> keys = dataListMap.keySet().iterator();		
		Calendar cal = Calendar.getInstance();
        Date day = cal.getTime();    //시간을 꺼낸다.
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
        String toDay = sdf.format(day);
		String path = config.getProperty("upload.file.path.images");
		path += "/"+toDay; 			
		while( keys.hasNext() ) {
			String key = keys.next();
			HashMap<String, Object> dataMap = (HashMap<String, Object>)dataListMap.get(key);
			if( dataMap != null && "U".equals(dataMap.get("dataStatus")) ) {
				reportDao.updateSenseQualityContent(dataMap);
			} else {
				dataMap.put("idx", param.get("idx"));
				//파일에 대한 정보를 조회한다.
				try {
					MultipartFile multipartFile = (MultipartFile)fileMap.get(key);
					if( file != null && file.length > 0 ) {
						if( !multipartFile.isEmpty() ) {
							String fileIdx = FileUtil.getUUID();
							String result = FileUtil.upload3(multipartFile,path,fileIdx);
							dataMap.put("orgFileName", multipartFile.getOriginalFilename());
							dataMap.put("filePath", "/"+toDay);
							dataMap.put("changeFileName", result);
						} else {
							dataMap.put("orgFileName", "");
							dataMap.put("filePath", "");
							dataMap.put("changeFileName", "");
						}
					} else {
						dataMap.put("orgFileName", "");
						dataMap.put("filePath", "");
						dataMap.put("changeFileName", "");
					}
				} catch( Exception e ) {
					dataMap.put("orgFileName", "");
					dataMap.put("filePath", "");
					dataMap.put("changeFileName", "");
				}
				reportDao.insertSenseQualityContent(dataMap);
			}
		}
		
		//3. lab_sense_quality_add_info 등록
		ArrayList<HashMap<String,Object>> addInfoList = new ArrayList<HashMap<String,Object>>();
		if( contentsNoteArr != null && contentsNoteArr.size() > 0 ) {
			for( int i = 0 ; i < contentsNoteArr.size() ; i++ ) {
				HashMap<String,Object> contentsNoteData = new HashMap<String,Object>();
				contentsNoteData.put("idx", param.get("idx"));
				contentsNoteData.put("infoType", "NOTE");
				contentsNoteData.put("infoText", contentsNoteArr.get(i));
				addInfoList.add(contentsNoteData);
			}				
		}
		
		if( resultArr != null && resultArr.size() > 0 ) {
			for( int i = 0 ; i < resultArr.size() ; i++ ) {
				HashMap<String,Object> resultData = new HashMap<String,Object>();
				resultData.put("idx", param.get("idx"));
				resultData.put("infoType", "RESULT");
				resultData.put("infoText", resultArr.get(i));
				addInfoList.add(resultData);
			}				
		}
		System.err.println("addInfoList : "+addInfoList);
		reportDao.deleteSenseQualityAddInfo(param);
		
		if( addInfoList != null && addInfoList.size() > 0 ) {
			//등록한다.
			reportDao.insertSenseQualityAddInfo(addInfoList);
		}
	}


	@Override
	public void updateSenseQuality(Map<String, Object> param, HashMap<String, Object> dataListMap,
			HashMap<String, Object> fileMap, HashMap<String, Object> listMap, MultipartFile[] file) throws Exception {
		// TODO Auto-generated method stub
		JSONArray contentsNoteArr = (JSONArray)listMap.get("contentsNoteArr");
		JSONArray resultArr = (JSONArray)listMap.get("resultArr");
		
		//1. lab_sense_quality_report 등록
		reportDao.updateSenseQualityReport(param);
		
		Iterator<String> keys = dataListMap.keySet().iterator();		
		Calendar cal = Calendar.getInstance();
        Date day = cal.getTime();    //시간을 꺼낸다.
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
        String toDay = sdf.format(day);
		String path = config.getProperty("upload.file.path.images");
		path += "/"+toDay; 			
		while( keys.hasNext() ) {
			String key = keys.next();
			HashMap<String, Object> dataMap = (HashMap<String, Object>)dataListMap.get(key);
			if( dataMap != null && "U".equals(dataMap.get("dataStatus")) ) {
				//update 하자
				System.err.println("UPDATE 하자 "+dataMap);
				reportDao.updateSenseQualityContent(dataMap);
			} else {
				dataMap.put("idx", param.get("idx"));
				//파일에 대한 정보를 조회한다.
				try {
					MultipartFile multipartFile = (MultipartFile)fileMap.get(key);
					if( file != null && file.length > 0 ) {
						if( !multipartFile.isEmpty() ) {
							String fileIdx = FileUtil.getUUID();
							String result = FileUtil.upload3(multipartFile,path,fileIdx);
							dataMap.put("orgFileName", multipartFile.getOriginalFilename());
							dataMap.put("filePath", "/"+toDay);
							dataMap.put("changeFileName", result);
						} else {
							dataMap.put("orgFileName", "");
							dataMap.put("filePath", "");
							dataMap.put("changeFileName", "");
						}
					} else {
						dataMap.put("orgFileName", "");
						dataMap.put("filePath", "");
						dataMap.put("changeFileName", "");
					}
				} catch( Exception e ) {
					dataMap.put("orgFileName", "");
					dataMap.put("filePath", "");
					dataMap.put("changeFileName", "");
				}
				System.err.println("INSERT 하자 "+dataMap);
				reportDao.insertSenseQualityContent(dataMap);
			}
		}
		
		//3. lab_sense_quality_add_info 등록
		ArrayList<HashMap<String,Object>> addInfoList = new ArrayList<HashMap<String,Object>>();
		if( contentsNoteArr != null && contentsNoteArr.size() > 0 ) {
			for( int i = 0 ; i < contentsNoteArr.size() ; i++ ) {
				HashMap<String,Object> contentsNoteData = new HashMap<String,Object>();
				contentsNoteData.put("idx", param.get("idx"));
				contentsNoteData.put("infoType", "NOTE");
				contentsNoteData.put("infoText", contentsNoteArr.get(i));
				addInfoList.add(contentsNoteData);
			}				
		}
		
		if( resultArr != null && resultArr.size() > 0 ) {
			for( int i = 0 ; i < resultArr.size() ; i++ ) {
				HashMap<String,Object> resultData = new HashMap<String,Object>();
				resultData.put("idx", param.get("idx"));
				resultData.put("infoType", "RESULT");
				resultData.put("infoText", resultArr.get(i));
				addInfoList.add(resultData);
			}				
		}
		System.err.println("addInfoList : "+addInfoList);
		reportDao.deleteSenseQualityAddInfo(param);
		
		if( addInfoList != null && addInfoList.size() > 0 ) {
			//등록한다.
			reportDao.insertSenseQualityAddInfo(addInfoList);
		}
	}


	//추가시작 ~~~~~~~~~~~~~~~~~~~
	@Override
	public List<Map<String, Object>> selectBusinessTripUserList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return reportDao.selectBusinessTripUserList(param);
	}


	@Override
	public List<Map<String, Object>> selectBusinessTripAddInfoList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return reportDao.selectBusinessTripAddInfoList(param);
	}


	@Override
	public List<Map<String, Object>> selectBusinessTripContentsList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return reportDao.selectBusinessTripContentsList(param);
	}


	@Override
	public void updateBusinessTripTmp(Map<String, Object> param, MultipartFile[] file) throws Exception {
		// TODO Auto-generated method stub
		try {
			JSONParser parser = new JSONParser();
			JSONArray deptArr = (JSONArray) parser.parse((String)param.get("deptArr"));
			JSONArray positionArr = (JSONArray) parser.parse((String)param.get("positionArr"));
			JSONArray nameArr = (JSONArray) parser.parse((String)param.get("nameArr"));
			JSONArray purposeArr = (JSONArray) parser.parse((String)param.get("purposeArr"));
			JSONArray tripDestinationArr = (JSONArray) parser.parse((String)param.get("tripDestinationArr"));
			JSONArray scheduleArr = (JSONArray) parser.parse((String)param.get("scheduleArr"));
			JSONArray contentArr = (JSONArray) parser.parse((String)param.get("contentArr"));
			JSONArray placeArr = (JSONArray) parser.parse((String)param.get("placeArr"));
			JSONArray noteArr = (JSONArray) parser.parse((String)param.get("noteArr"));
			
			//출장결과 수정
			reportDao.updateBusinessTrip(param);
			
			//2. 출장자 등록
			ArrayList<HashMap<String,Object>> userList = new ArrayList<HashMap<String,Object>>();
			for( int i = 0 ; i < deptArr.size() ; i++ ) {
				HashMap<String,Object> userMap = new HashMap<String,Object>();
				userMap.put("idx", param.get("idx"));
				userMap.put("displayOrder", i+1);
				
				try{
					userMap.put("dept", deptArr.get(i));
				} catch(Exception e) {
					userMap.put("dept", "");
				}
				
				try{
					userMap.put("position", positionArr.get(i));
				} catch(Exception e) {
					userMap.put("position", "");
				}
				
				try{
					userMap.put("name", nameArr.get(i));
				} catch(Exception e) {
					userMap.put("name", "");
				}
				
				userList.add(userMap);
			}			
			reportDao.deleteBusinessTripUser(param);
			if( userList != null && userList.size() > 0 ) {
				reportDao.insertBusinessTripUser(userList);
			}
			
			//3. 추가 정보 등록
			ArrayList<HashMap<String,Object>> addInfoList = new ArrayList<HashMap<String,Object>>();
			
			if( purposeArr.size() > 0 ) {
				for( int i = 0 ; i < purposeArr.size() ; i++ ) {					
					if( purposeArr.get(i) != null && !"".equals(purposeArr.get(i)) ) {
						HashMap<String,Object> purposeData = new HashMap<String,Object>();
						purposeData.put("idx", param.get("idx"));
						purposeData.put("displayOrder", i+1);
						purposeData.put("infoType", "PUR");
						purposeData.put("infoText", purposeArr.get(i));
						addInfoList.add(purposeData);
					}
				}				
			}
			
			if( tripDestinationArr.size() > 0 ) {
				for( int i = 0 ; i < tripDestinationArr.size() ; i++ ) {
					if( tripDestinationArr.get(i) != null && !"".equals(tripDestinationArr.get(i)) ) {
						HashMap<String,Object> featureData = new HashMap<String,Object>();
						featureData.put("idx", param.get("idx"));
						featureData.put("displayOrder", i+1);
						featureData.put("infoType", "DEST");
						featureData.put("infoText", tripDestinationArr.get(i));
						addInfoList.add(featureData);
					}
				}
			}
			
			reportDao.deleteBusinessTripAddInfo(param);
			if( addInfoList != null && addInfoList.size() > 0 ) {
				reportDao.insertBusinessTripAddInfo(addInfoList);
			}
			
			//4. 업무수행내용 등록
			ArrayList<HashMap<String,Object>> contentList = new ArrayList<HashMap<String,Object>>();
			for( int i = 0 ; i < scheduleArr.size() ; i++ ) {
				HashMap<String,Object> contentMap = new HashMap<String,Object>();
				contentMap.put("idx", param.get("idx"));
				contentMap.put("displayOrder", i+1);
				
				try{
					contentMap.put("schedule", scheduleArr.get(i));
				} catch(Exception e) {
					contentMap.put("schedule", "");
				}
				
				try{
					contentMap.put("content", contentArr.get(i));
				} catch(Exception e) {
					contentMap.put("content", "");
				}
				
				try{
					contentMap.put("place", placeArr.get(i));
				} catch(Exception e) {
					contentMap.put("place", "");
				}
				
				try{
					contentMap.put("note", noteArr.get(i));
				} catch(Exception e) {
					contentMap.put("note", "");
				}
				
				contentList.add(contentMap);
			}
			reportDao.deleteBusinessTripContents(param);
			if( contentList != null && contentList.size() > 0 ) {
				reportDao.insertBusinessTripContents(contentList);
			}
			
			//history 저장
			Map<String, Object> historyParam = new HashMap<String, Object>();
			historyParam.put("docIdx", param.get("idx"));
			historyParam.put("docType", param.get("docType"));
			historyParam.put("historyType", "U");
			historyParam.put("historyData", param.toString());
			historyParam.put("userId", param.get("userId"));
			testDao.insertHistory(historyParam);
			
			//파일 DB 저장
			if( file != null && file.length > 0 ) {
				Calendar cal = Calendar.getInstance();
		        Date day = cal.getTime();    //시간을 꺼낸다.
		        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
		        String toDay = sdf.format(day);
				String path = config.getProperty("upload.file.path.trip");
				path += "/"+toDay; 
				for( MultipartFile multipartFile : file ) {
					System.err.println("=================================");
					System.err.println("isEmpty : "+multipartFile.isEmpty());
					System.err.println("name : " + multipartFile.getName());
					System.err.println("originalFilename : " + multipartFile.getOriginalFilename());		
					System.err.println("size : " + multipartFile.getSize());				
					System.err.println("=================================");
					try {
						if( !multipartFile.isEmpty() ) {
							String fileIdx = FileUtil.getUUID();
							String result = FileUtil.upload3(multipartFile,path,fileIdx);
							String content = FileUtil.getPdfContents(path, result);
							Map<String,Object> fileMap = new HashMap<String,Object>();
							fileMap.put("fileIdx", fileIdx);
							fileMap.put("docIdx", param.get("idx"));
							fileMap.put("docType", param.get("docType"));
							fileMap.put("fileType", "00");
							fileMap.put("orgFileName", multipartFile.getOriginalFilename());
							fileMap.put("filePath", path);
							fileMap.put("changeFileName", result);
							fileMap.put("content", content);
							System.err.println(fileMap);
							//파일정보 저장
							testDao.insertFileInfo(fileMap);
						}
					} catch( Exception e ) {
						//throw e;
					}					
				}
			}
		} catch( Exception e ) {
			throw e;
		}
	}
	
	@Override
	public Map<String, Object> selectNewProductResultList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		int totalCount = reportDao.selectNewProductResultCount(param);
		
		int viewCount = 10;
		int pageNo = 1;
		try {
			pageNo = Integer.parseInt((String)param.get("pageNo"));
		} catch( Exception e ) {
			System.err.println(e.getMessage());
			pageNo = 1;
		}
		
		try {
			viewCount = Integer.parseInt((String)param.get("viewCount"));
		} catch( Exception e ) {
			System.err.println(e.getMessage());
			viewCount = 10;
		}
		
		// 페이징: 페이징 정보 SET
		PageNavigator navi = new PageNavigator(param, viewCount, totalCount);
		
		List<Map<String, Object>> newProductResultList = reportDao.selectNewProductResultList(param);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("pageNo", pageNo);
		map.put("totalCount", totalCount);
		map.put("list", newProductResultList);	
		map.put("navi", navi);
		return map;
	}
	
	@Override
	public Map<String, Object> selectChemicalTestList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		int totalCount = reportDao.selectChemicalTestCount(param);
		
		int viewCount = 10;
		int pageNo = 1;
		try {
			pageNo = Integer.parseInt((String)param.get("pageNo"));
		} catch( Exception e ) {
			System.err.println(e.getMessage());
			pageNo = 1;
		}
		
		try {
			viewCount = Integer.parseInt((String)param.get("viewCount"));
		} catch( Exception e ) {
			System.err.println(e.getMessage());
			viewCount = 10;
		}
		
		// 페이징: 페이징 정보 SET
		PageNavigator navi = new PageNavigator(param, viewCount, totalCount);
		
		List<Map<String, Object>> chemicalTestList = reportDao.selectChemicalTestList(param);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("pageNo", pageNo);
		map.put("totalCount", totalCount);
		map.put("list", chemicalTestList);	
		map.put("navi", navi);
		return map;
	}
}
