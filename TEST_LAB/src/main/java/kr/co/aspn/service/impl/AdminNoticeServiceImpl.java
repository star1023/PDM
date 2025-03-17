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
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.web.multipart.MultipartException;
import org.springframework.web.multipart.MultipartFile;

import kr.co.aspn.common.auth.AuthUtil;
import kr.co.aspn.dao.AdminNoticeDao;
import kr.co.aspn.service.AdminNoticeService;
import kr.co.aspn.service.FileService;
import kr.co.aspn.util.FileUtil;
import kr.co.aspn.util.PageNavigator;
import kr.co.aspn.util.StringUtil;
import kr.co.aspn.vo.FileVO;
import kr.co.aspn.vo.LabPagingObject;
import kr.co.aspn.vo.LabPagingResult;
import kr.co.aspn.vo.NoticeVO;

@Service
public class AdminNoticeServiceImpl implements AdminNoticeService {

	@Autowired
	AdminNoticeDao adminNoticeDao;

	@Autowired
	FileService fileService;

	@Autowired
	private Properties config;
	
	@Autowired
	PlatformTransactionManager txManager;
	TransactionStatus status = null;
	DefaultTransactionDefinition def = null;
	
//	@Override
//	public LabPagingResult AdminNoticeList(LabPagingObject page, String keyword) {
//		LabPagingResult result = new LabPagingResult();
//		
//		HashMap<String,Object> param = new HashMap<String,Object>();
//		param.put("keyword",keyword);
//		param.put("page", page);
//		
//		int count = adminNoticeDao.AdminNoticeListCount(param);
//		
//		page.setTotalCount(count);
//		
//		result.setPage(page);
//		result.setPagenatedList(adminNoticeDao.getPagenatedAdminNoticeList(param));
//		
//		return result;
//	}

	@Override
	public Map<String,Object> AdminNoticeList(HashMap<String,Object> param) throws Exception {
		
		

			if( (String)param.get("keyword") !=null && (String)param.get("searchName") !=null) {
				String keyword = URLDecoder.decode((String)param.get("keyword"),"UTF-8");
				String searchName = URLDecoder.decode((String)param.get("searchName"),"UTF-8");
				
				param.put("keyword", keyword);
				param.put("searchName", searchName);
			}

		
		int totalCount = adminNoticeDao.AdminNoticeListCount(param);
		
		PageNavigator navi = new PageNavigator(param, totalCount);
		
		List<Map<String,Object>> noticeList = adminNoticeDao.getPagenatedAdminNoticeList(param);
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("totalCount", totalCount);
		map.put("noticeList", noticeList);
		map.put("navi", navi);
		/* map.put("keyword", param.get("keyword")); */
		map.put("pageNo", StringUtil.nvl((String) param.get("pageNo"), "1"));
		map.put("paramVO", param);
		
		return map;
	}
	
	@Override
	public Map<Object, Object> AdminNoticeView(Object nNo) {
		// TODO Auto-generated method stub
		return adminNoticeDao.noticeView(nNo);
	}

	@Override
	public List<Map<Object, Object>> AdminNoticeFileView(HashMap<Object,Object> param) {
		// TODO Auto-generated method stub
		return adminNoticeDao.fileView(param);
	}

	@Override
	public void RegistAdminNotice(HttpServletRequest request,HashMap<Object, Object> param, MultipartFile... files) throws Exception {
		try {
			def = new DefaultTransactionDefinition();
			def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRES_NEW);
			status = txManager.getTransaction(def);	
			//공지사항 등록
			int tbkey = adminNoticeDao.noticeSave(param);
			
	//		ArrayList<String> fileNames = new ArrayList<String>();
	//		for( MultipartFile multipartFile : files ) {
	//			try {
	//				
	//				HashMap<Object,Object> fileParam = new HashMap<Object,Object>();
	//				
	//				String result = FileUtil.upload2(multipartFile,path,"notice");
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
	//				String subPath = "notice" + File.separator + str + File.separator;
	//				
	//				fileParam.put("tbKey", tbkey);
	//				fileParam.put("tbType", "notice");
	//				fileParam.put("fileName", subPath + multipartFile.getOriginalFilename());
	//
	//				adminNoticeDao.fileSave(fileParam);
	//				
	//			} catch( MultipartException e ) {
	//				e.printStackTrace();
	//			} 
	//		}
			
			Calendar cal = Calendar.getInstance();
			Date day = cal.getTime();
		    SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
		    String toDay = sdf.format(day);
		    
			if(files !=null && files.length > 0) {
				String path = config.getProperty("upload.file.path.notice");
				path+="/"+toDay;
	//			String path = "C:/TDDOWNLOAD\\\\"+File.separator+"notice"+File.separator+toDay;
				
				for(MultipartFile multipartFile : files) {
					try {
						if( !multipartFile.isEmpty() ) {	
							String result = "";
							FileVO fileVO = new FileVO();
							fileVO.setTbKey(""+tbkey);
							fileVO.setTbType("notice");
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
			txManager.commit(status);    // 커밋 시
		} catch( Exception e ) {
			txManager.rollback(status);  // 롤백 시
		}
	}

	@Override
	public void DeleteAdminNotice(HashMap<Object,Object> param) {
		adminNoticeDao.noticeDelete(param);
	}

	@Override
	public void AdminNoticeFileDeleteBytbKeytbType(HashMap<Object, Object> param) {
		adminNoticeDao.fileDeleteBytbKeytbType(param);
		
	}

	@Override
	public void AdminNoticeModify(HttpServletRequest request,NoticeVO noticeVO, MultipartFile... files) throws Exception {
		
		String contents = noticeVO.getContents().replaceAll("\n", "<br>");
		
		noticeVO.setContents(contents);
		
		adminNoticeDao.noticeEdit(noticeVO);
		
		int tbKey = Integer.valueOf(noticeVO.getnNo());
		
		HashMap<Object,Object> param = new HashMap<Object,Object>();
		param.put("tbKey", noticeVO.getnNo());
		param.put("tbType", "notice");
		
		if(noticeVO.getFileDelete()!=null){
			for(int i=0; i<noticeVO.getFileDelete().length; i++){

				param.put("fmNo", noticeVO.getFileDelete()[i]);
				adminNoticeDao.fileManagerFileDelete(param);
			}	
		}
		
		Calendar cal = Calendar.getInstance();
		Date day = cal.getTime();
	    SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
	    String toDay = sdf.format(day);
	    
		if(files !=null && files.length > 0) {
			String path = config.getProperty("upload.file.path.notice");
			path+="/"+toDay;
//			String path = "C:/TDDOWNLOAD\\\\"+File.separator+"notice"+File.separator+toDay;
			
			for(MultipartFile multipartFile : files) {
				try {
					if( !multipartFile.isEmpty() ) {	
						String result = "";
						FileVO fileVO = new FileVO();
						fileVO.setTbKey(""+tbKey);
						fileVO.setTbType("notice");
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
//				String result = FileUtil.upload2(multipartFile,path,"notice");
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
//				String subPath = "notice" + File.separator + str + File.separator;
//				
//				fileParam.put("tbKey", tbKey);
//				fileParam.put("tbType", "notice");
//				fileParam.put("fileName", subPath + multipartFile.getOriginalFilename());
//
//				adminNoticeDao.fileSave(fileParam);
//				
//			} catch( MultipartException e ) {
//				e.printStackTrace();
//			} 
//		}
		
		
		
		
	}

	@Override
	public List<Map<Object, Object>> replyListByNo(HashMap<Object,Object> param) {
		// TODO Auto-generated method stub
		return adminNoticeDao.replyListByNo(param);
	}

	@Override
	public void replyDeleteByNo(HashMap<Object, Object> param) {
		adminNoticeDao.replyDeleteByNo(param);
	}

	@Override
	public void replyRegistByNo(HashMap<Object, Object> param) {
		adminNoticeDao.replyRegistByNo(param);
	}

	@Override
	public void ReplyUpdateByNo(HashMap<Object, Object> param) {
		adminNoticeDao.ReplyUpdateByNo(param);
		
	}

	@Override
	public Map<Object, Object> AdminNoticeFileViewByFmNo(HashMap<Object, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return adminNoticeDao.fileViewByFmNo(param);
	}

	@Override
	public void addHitsNotice(HashMap<Object, Object> param) {
		// TODO Auto-generated method stub
		adminNoticeDao.addHitsNotice(param);
	}



}
