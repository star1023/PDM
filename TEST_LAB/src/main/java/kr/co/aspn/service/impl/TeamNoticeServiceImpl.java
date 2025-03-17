package kr.co.aspn.service.impl;

import java.io.File;
import java.net.URLDecoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.xml.datatype.DatatypeConfigurationException;
import javax.xml.datatype.DatatypeFactory;
import javax.xml.datatype.XMLGregorianCalendar;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartException;
import org.springframework.web.multipart.MultipartFile;

import kr.co.aspn.common.auth.AuthUtil;
import kr.co.aspn.dao.TeamNoticeDao;
import kr.co.aspn.service.FileService;
import kr.co.aspn.service.TeamNoticeService;
import kr.co.aspn.util.FileUtil;
import kr.co.aspn.util.PageNavigator;
import kr.co.aspn.util.StringUtil;
import kr.co.aspn.vo.FileVO;
import kr.co.aspn.vo.LabPagingObject;
import kr.co.aspn.vo.LabPagingResult;
import kr.co.aspn.vo.NoticeVO;

@Service
public class TeamNoticeServiceImpl implements TeamNoticeService {

	@Autowired
	TeamNoticeDao teamNoticeDao;
	
	@Autowired
	FileService fileService;
	
	@Autowired
	private Properties config;
//	@Override
//	public LabPagingResult TeamnoticeList(LabPagingObject page, String keyword, String deptCode) {
//		LabPagingResult result = new LabPagingResult();
//		
//		HashMap<String,Object> param = new HashMap<String,Object>();
//		param.put("keyword", keyword);
//		param.put("page", page);
//		param.put("deptCode", deptCode);
//		
//		int count = teamNoticeDao.TeamNoticeListCount(param);
//		page.setTotalCount(count);
//		
//		result.setPage(page);
//		result.setPagenatedList(teamNoticeDao.getPagenatedTeamNoticeList(param));
//		
//		
//		return result;
//	}

	@Override
	public Map<String,Object> TeamnoticeList(HashMap<String,Object> param) throws Exception {
		
		if((String)param.get("searchName")!=null && (String)param.get("keyword") !=null) {
		
			String searchName = URLDecoder.decode((String)param.get("searchName"),"UTF-8");
			String keyword = URLDecoder.decode((String)param.get("keyword"),"UTF-8");
			param.put("searchName", searchName);
			param.put("keyword", keyword);
		}
		
		int totalCount = teamNoticeDao.TeamNoticeListCount(param);
		
		PageNavigator navi = new PageNavigator(param, totalCount);
		
		List<Map<String,Object>> TeamnoticeList = teamNoticeDao.getPagenatedTeamNoticeList(param);
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("totalCount", totalCount);
		map.put("TeamnoticeList", TeamnoticeList);
		map.put("navi", navi);
		
		map.put("pageNo", StringUtil.nvl((String) param.get("pageNo"), "1"));
		map.put("paramVO", param);
		
		return map;
	}
	
	@Override
	public Map<Object, Object> teamNoticeView(Object nNo) {
		// TODO Auto-generated method stub
		return teamNoticeDao.teamNoticeView(nNo);
	}

	@Override
	public List<Map<Object, Object>> teamFileView(HashMap<Object, Object> param) {
		// TODO Auto-generated method stub
		return teamNoticeDao.teamFileView(param);
	}

	@Override
	public void TeamnoticeDelete(HashMap<Object, Object> param) {
		teamNoticeDao.TeamnoticeDelete(param);
		
	}

	@Override
	public void fileDeleteBytbKeytbType(HashMap<Object, Object> param) {
		teamNoticeDao.fileDeleteBytbKeytbType(param);
		
	}

	@Override
	public void registNotice(HttpServletRequest request,HashMap<Object, Object> param, MultipartFile... files) throws Exception {
		//공지사항 등록
				int tbkey = teamNoticeDao.noticeSave(param);
				System.err.println("tbkey: " + tbkey);
				
//				ArrayList<String> fileNames = new ArrayList<String>();
//				for( MultipartFile multipartFile : files ) {
//					try {
//						
//						HashMap<Object,Object> fileParam = new HashMap<Object,Object>();
//						
//						String result = FileUtil.upload2(multipartFile,path,"team");
//						fileNames.add(result);
//						
//						GregorianCalendar cal = new GregorianCalendar();
//						XMLGregorianCalendar nowData = null;
//						try {
//							nowData = DatatypeFactory.newInstance().newXMLGregorianCalendar(cal);
//						} catch (DatatypeConfigurationException e1) {
//							e1.printStackTrace();
//						}
//						
//						String str = nowData.toString().substring(0,7).replace("-", "");
//						
//						String subPath = "team" + File.separator + str + File.separator;
//						
//						fileParam.put("tbKey", tbkey);
//						fileParam.put("tbType", "team");
//						fileParam.put("fileName", subPath + multipartFile.getOriginalFilename());
//
//						teamNoticeDao.fileSave(fileParam);
//						
//					} catch( MultipartException e ) {
//						e.printStackTrace();
//					} 
//				}
		
				Calendar cal = Calendar.getInstance();
				Date day = cal.getTime();
			    SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
			    String toDay = sdf.format(day);
				
				if(files !=null && files.length > 0) {
					String path = config.getProperty("upload.file.path.team");
					path+="/"+toDay;
//					String path = "C:/TDDOWNLOAD\\\\"+File.separator+"team"+File.separator+toDay;
					
					for(MultipartFile multipartFile : files) {
						try {
							if( !multipartFile.isEmpty() ) {	
								String result = "";
								FileVO fileVO = new FileVO();
								fileVO.setTbKey(""+tbkey);
								fileVO.setTbType("team");
								fileVO.setOrgFileName(multipartFile.getOriginalFilename());
								fileVO.setRegUserId(AuthUtil.getAuth(request).getUserId());
								
								//result = FileUtil.upload(multipartFile,path);
								result = FileUtil.upload3(multipartFile,path);
								fileVO.setFileName(result);
								fileVO.setPath(path);
								fileService.insertFile(fileVO);
							}				
						} catch( Exception e ) {
							e.printStackTrace();
						}
					}
						
				}
	}

	@Override
	public void modifyNotice(HttpServletRequest request,NoticeVO noticeVO, MultipartFile... files) throws Exception {
		
		String contents = noticeVO.getContents().replaceAll("\n", "<br>");
		
		noticeVO.setContents(contents);
		
		teamNoticeDao.TeamnoticeEdit(noticeVO);
		
		int tbKey = Integer.valueOf(noticeVO.getnNo());
		
		HashMap<Object,Object> param = new HashMap<Object,Object>();
		param.put("tbKey", noticeVO.getnNo());
		param.put("tbType", "team");
		
		if(noticeVO.getFileDelete()!=null) {
			for(int i=0; i<noticeVO.getFileDelete().length; i++){
				param.put("fmNo", noticeVO.getFileDelete()[i]);
				teamNoticeDao.fileManagerFileDelete(param);
			}
		}
		
		Calendar cal = Calendar.getInstance();
		Date day = cal.getTime();
	    SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
	    String toDay = sdf.format(day);
		
		if(files !=null && files.length > 0) {
			String path = config.getProperty("upload.file.path.team");
			path+="/"+toDay;
//			String path = "C:/TDDOWNLOAD\\\\"+File.separator+"team"+File.separator+toDay;
			
			for(MultipartFile multipartFile : files) {
				try {
					if( !multipartFile.isEmpty() ) {	
						String result = "";
						FileVO fileVO = new FileVO();
						fileVO.setTbKey(""+tbKey);
						fileVO.setTbType("team");
						fileVO.setOrgFileName(multipartFile.getOriginalFilename());
						fileVO.setRegUserId(AuthUtil.getAuth(request).getUserId());
						
						//result = FileUtil.upload(multipartFile,path);
						result = FileUtil.upload3(multipartFile,path);
						fileVO.setFileName(result);
						fileVO.setPath(path);
						fileService.insertFile(fileVO);
					}				
				} catch( Exception e ) {
					e.printStackTrace();
				}
			}
				
		}
	    
//		ArrayList<String> fileNames = new ArrayList<String>();
//		for( MultipartFile multipartFile : files ) {
//			try {
//				
//				HashMap<Object,Object> fileParam = new HashMap<Object,Object>();
//				
//				String result = FileUtil.upload2(multipartFile,path,"team");
//				fileNames.add(result);
//				
//				GregorianCalendar cal = new GregorianCalendar();
//				XMLGregorianCalendar nowData = null;
//				try {
//					nowData = DatatypeFactory.newInstance().newXMLGregorianCalendar(cal);
//				} catch (DatatypeConfigurationException e1) {
//					e1.printStackTrace();
//				}
//				
//				String str = nowData.toString().substring(0,7).replace("-", "");
//				
//				String subPath = "team" + File.separator + str + File.separator;
//				
//				fileParam.put("tbKey", tbKey);
//				fileParam.put("tbType", "team");
//				fileParam.put("fileName", subPath + multipartFile.getOriginalFilename());
//
//				teamNoticeDao.fileSave(fileParam);
//				
//			} catch( MultipartException e ) {
//				e.printStackTrace();
//			} 
//		}
		
		
	}

	@Override
	public Map<Object, Object> fileViewByFmNo(HashMap<Object, Object> param) {
		// TODO Auto-generated method stub
		return teamNoticeDao.fileViewByFmNo(param);
	}
	
	@Override
	public List<Map<Object, Object>> replyListByNo(HashMap<Object, Object> param) {
		// TODO Auto-generated method stub
		return teamNoticeDao.replyListByNo(param);
	}

	@Override
	public void replyDeleteByNo(HashMap<Object, Object> param) {
		// TODO Auto-generated method stub
		teamNoticeDao.replyDeleteByNo(param);
		
	}

	@Override
	public void replyRegistByNo(HashMap<Object, Object> param) {
		// TODO Auto-generated method stub
		teamNoticeDao.replyRegistByNo(param);
		
	}

	@Override
	public void ReplyUpdateByNo(HashMap<Object, Object> param) {
		// TODO Auto-generated method stub
		teamNoticeDao.ReplyUpdateByNo(param);
		
	}

	@Override
	public void addHitsTeam(HashMap<Object, Object> param) {
		// TODO Auto-generated method stub
		teamNoticeDao.addHitsTeam(param);
		
	}

	@Override
	public List<Map<String,Object>> fileViewByTbKey(String nNo) {
		// TODO Auto-generated method stub
		return teamNoticeDao.fileViewByTbKey(nNo);
	}

}
