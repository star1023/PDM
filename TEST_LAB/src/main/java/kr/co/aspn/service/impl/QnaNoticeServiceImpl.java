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
import kr.co.aspn.dao.QnaNoticeDao;
import kr.co.aspn.service.FileService;
import kr.co.aspn.service.QnaNoticeService;
import kr.co.aspn.util.FileUtil;
import kr.co.aspn.util.PageNavigator;
import kr.co.aspn.util.StringUtil;
import kr.co.aspn.vo.FileVO;
import kr.co.aspn.vo.LabPagingObject;
import kr.co.aspn.vo.LabPagingResult;
import kr.co.aspn.vo.NoticeVO;

@Service
public class QnaNoticeServiceImpl implements QnaNoticeService {

	@Autowired
	QnaNoticeDao QnaNoticeDao;
	
	@Autowired
	FileService fileService;
	
	@Autowired
	private Properties config;
//	@Override
//	public LabPagingResult getPagenatedQnaNoticeList(LabPagingObject page, String keyword) {
//		LabPagingResult result = new LabPagingResult();
//		
//		HashMap<String,Object> param = new HashMap<String,Object>();
//		param.put("keyword",keyword);
//		param.put("page", page);
//		
//		int count = QnaNoticeDao.QnaNoticeListCount(param);
//		
//		page.setTotalCount(count);
//		
//		result.setPage(page);
//		result.setPagenatedList(QnaNoticeDao.getPagenatedQnaNoticeList(param));
//		
//		return result;
//	}
	
	@Override
	public Map<String,Object> getPagenatedQnaNoticeList(HashMap<String,Object> param) throws Exception {
		
		if( (String)param.get("keyword") !=null && (String)param.get("searchName") !=null) {
			String keyword = URLDecoder.decode((String)param.get("keyword"),"UTF-8");
			String searchName = URLDecoder.decode((String)param.get("searchName"),"UTF-8");
			
			param.put("keyword", keyword);
			param.put("searchName", searchName);
		}
		
		int totalCount = QnaNoticeDao.QnaNoticeListCount(param);
		
		PageNavigator navi = new PageNavigator(param, totalCount);
		
		List<Map<String,Object>> QnanoticeList = QnaNoticeDao.getPagenatedQnaNoticeList(param);
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("totalCount", totalCount);
		map.put("QnanoticeList", QnanoticeList);
		map.put("navi", navi);
		map.put("pageNo", StringUtil.nvl((String) param.get("pageNo"), "1"));
		map.put("paramVO", param);
		
		return map;
	}
	
	@Override
	public Map<Object, Object> getQnaNoticeView(Object nNo) {
		// TODO Auto-generated method stub
		return QnaNoticeDao.getQnaNoticeView(nNo);
	}

	@Override
	public List<Map<Object, Object>> fileView(HashMap<Object,Object> param) {
		// TODO Auto-generated method stub
		return QnaNoticeDao.fileView(param);
	}

	@Override
	public int QnaNoticeSave(HttpServletRequest request,HashMap<String, Object> param, MultipartFile... files) throws Exception {
		
		//공지사항 등록
		int tbkey = QnaNoticeDao.QnaNoticeSave(param);
		
		Calendar cal = Calendar.getInstance();
		Date day = cal.getTime();
	    SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
	    String toDay = sdf.format(day);
		
		if(files !=null && files.length > 0) {
			String path = config.getProperty("upload.file.path.qna");
			path+="/"+toDay;
//			String path = "C:/TDDOWNLOAD\\\\"+File.separator+"qna"+File.separator+toDay;
			
			for(MultipartFile multipartFile : files) {
				try {
					if( !multipartFile.isEmpty() ) {	
						String result = "";
						FileVO fileVO = new FileVO();
						fileVO.setTbKey(""+tbkey);
						fileVO.setTbType("qna");
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
	    
		return tbkey;
		
//		ArrayList<String> fileNames = new ArrayList<String>();
//		for( MultipartFile multipartFile : files ) {
//			try {
//				
//				HashMap<Object,Object> fileParam = new HashMap<Object,Object>();
//				
//				String result = FileUtil.upload2(multipartFile,path,"qna");
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
//				String subPath = "qna" + File.separator + str + File.separator;
//				
//				fileParam.put("tbKey", tbkey);
//				fileParam.put("tbType", "qna");
//				fileParam.put("fileName", subPath + multipartFile.getOriginalFilename());
//
//				QnaNoticeDao.fileSave(fileParam);
//				
//			} catch( MultipartException e ) {
//				e.printStackTrace();
//			} 
//		}
		
	}

	@Override
	public void QnaNoticeDelete(HashMap<Object,Object> param) {
		QnaNoticeDao.QnaNoticeDelete(param);
		
	}

	@Override
	public void fileDeleteBytbKeytbType(HashMap<Object, Object> param) {
		QnaNoticeDao.fileDeleteBytbKeytbType(param);
		
	}

	@Override
	public void QnaNoticeEdit(HttpServletRequest request,NoticeVO noticeVO, MultipartFile... files) throws Exception {
		
		String contents = noticeVO.getContents().replaceAll("\n","<br>");
		
		noticeVO.setContents(contents);
		
		QnaNoticeDao.QnaNoticeEdit(noticeVO);
		
		int tbKey = Integer.valueOf(noticeVO.getnNo());
		
		HashMap<Object,Object> param = new HashMap<Object,Object>();
		param.put("tbKey", noticeVO.getnNo());
		param.put("tbType", "qna");
		
		if(noticeVO.getFileDelete()!=null){
			String fmNo = "";
			for(int i=0; i<noticeVO.getFileDelete().length; i++){
				if(i == noticeVO.getFileDelete().length || i == 0){
					fmNo += noticeVO.getFileDelete()[i];
				} else {
					fmNo += ','+ noticeVO.getFileDelete()[i];
				}
			}
			param.put("fmNo", fmNo);
			QnaNoticeDao.fileManagerFileDelete(param);
			// db파일 삭제		
			
		}
		
		Calendar cal = Calendar.getInstance();
		Date day = cal.getTime();
	    SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
	    String toDay = sdf.format(day);
	    
		if(files !=null && files.length > 0) {
			String path = config.getProperty("upload.file.path.qna");
			path+="/"+toDay;
//			String path = "C:/TDDOWNLOAD\\\\"+File.separator+"qna"+File.separator+toDay;
			
			for(MultipartFile multipartFile : files) {
				try {
					if( !multipartFile.isEmpty() ) {	
						String result = "";
						FileVO fileVO = new FileVO();
						fileVO.setTbKey(""+tbKey);
						fileVO.setTbType("qna");
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
//				String result = FileUtil.upload2(multipartFile,path,"qna");
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
//				String subPath = "qna" + File.separator + str + File.separator;
//				
//				fileParam.put("tbKey", tbKey);
//				fileParam.put("tbType", "qna");
//				fileParam.put("fileName", subPath + multipartFile.getOriginalFilename());
//
//				QnaNoticeDao.fileSave(fileParam);
//				
//			} catch( MultipartException e ) {
//				e.printStackTrace();
//			} 
//		}
		
		
		
		
	}

	@Override
	public Map<Object, Object> fileViewByFmNo(HashMap<Object, Object> param) {
		// TODO Auto-generated method stub
		return QnaNoticeDao.fileViewByFmNo(param);
	}

	@Override
	public List<Map<Object, Object>> replyListByNo(HashMap<Object, Object> param) {
		// TODO Auto-generated method stub
		return QnaNoticeDao.replyListByNo(param);
	}

	@Override
	public void replyDeleteByNo(HashMap<Object, Object> param) {
		// TODO Auto-generated method stub
		QnaNoticeDao.replyDeleteByNo(param);
		
	}

	@Override
	public void replyRegistByNo(HashMap<Object, Object> param) {
		// TODO Auto-generated method stub
		QnaNoticeDao.replyRegistByNo(param);
		
	}

	@Override
	public void ReplyUpdateByNo(HashMap<Object, Object> param) {
		// TODO Auto-generated method stub
		QnaNoticeDao.ReplyUpdateByNo(param);
		
	}

	@Override
	public void addHitsQna(HashMap<Object, Object> param) {
		// TODO Auto-generated method stub
		QnaNoticeDao.addHitsQna(param);
	}



}
