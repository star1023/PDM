package kr.co.aspn.service.impl;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import org.json.simple.JSONArray;
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
	public int insertBusinessTrip(Map<String, Object> param, MultipartFile[] file) throws Exception {
		// TODO Auto-generated method stub
		int tripIdx = 0;
		try {
			tripIdx = reportDao.selectTripSeq();	//key value 조회
			param.put("idx", tripIdx);
			param.put("status", "REG");
			
			//제품 등록
			reportDao.insertBusinessTrip(param);
			
			//history 저장
			Map<String, Object> historyParam = new HashMap<String, Object>();
			historyParam.put("docIdx", tripIdx);
			historyParam.put("docType", "TRIP");
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
							fileMap.put("docIdx", tripIdx);
							fileMap.put("docType", "TRIP");
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
			reportDao.updateBusinessTrip(param);
			
			//history 저장
			Map<String, Object> historyParam = new HashMap<String, Object>();
			historyParam.put("docIdx", tripIdx);
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
	public List<Map<String, Object>> searchBusinessTripPlanList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return reportDao.searchBusinessTripPlanList(param);
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
	public int insertBusinessTripPlan(Map<String, Object> param, MultipartFile[] file) throws Exception {
		// TODO Auto-generated method stub
		int planIdx = 0;
		try {
			planIdx = reportDao.selectTripPlanSeq();	//key value 조회
			param.put("idx", planIdx);
			param.put("status", "REG");
			
			//제품 등록
			reportDao.insertBusinessTripPlan(param);
			
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
		return reportDao.selectBusinessTripPlanData(param);
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
			param.put("status", "REG");
			
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
		return null;
	}	
}
