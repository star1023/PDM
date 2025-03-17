package kr.co.aspn.service.impl;

import java.io.File;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.datatype.DatatypeConfigurationException;
import javax.xml.datatype.DatatypeFactory;
import javax.xml.datatype.XMLGregorianCalendar;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartException;
import org.springframework.web.multipart.MultipartFile;

import kr.co.aspn.dao.FaqNoticeDao;
import kr.co.aspn.service.FaqNoticeService;
import kr.co.aspn.util.FileUtil;
import kr.co.aspn.util.PageNavigator;
import kr.co.aspn.util.StringUtil;
import kr.co.aspn.vo.FileVO;
import kr.co.aspn.vo.LabPagingObject;
import kr.co.aspn.vo.LabPagingResult;
import kr.co.aspn.vo.NoticeVO;

@Service
public class FaqNoticeServiceImpl implements FaqNoticeService {

	@Autowired
	FaqNoticeDao faqNoticeDao;

//	@Override
//	public LabPagingResult FaqnoticeList(LabPagingObject page, String keyword) {
//	LabPagingResult result = new LabPagingResult();
//		
//		HashMap<String,Object> param = new HashMap<String,Object>();
//		param.put("keyword",keyword);
//		param.put("page", page);
//		
//		int count = faqNoticeDao.FaqNoticeListCount(param);
//		
//		page.setTotalCount(count);
//		
//		result.setPage(page);
//		result.setPagenatedList(faqNoticeDao.getPagenatedFaqNoticeList(param));
//		
//		return result;
//	}

	@Override
	public Map<String,Object> FaqnoticeList(HashMap<String,Object> param) throws Exception {
		
		if( (String)param.get("keyword") !=null && (String)param.get("searchName") !=null) {
			String keyword = URLDecoder.decode((String)param.get("keyword"),"UTF-8");
			String searchName = URLDecoder.decode((String)param.get("searchName"),"UTF-8");
			
			param.put("keyword", keyword);
			param.put("searchName", searchName);
		}
		
		int totalCount = faqNoticeDao.FaqNoticeListCount(param);
		
		PageNavigator navi = new PageNavigator(param, totalCount);
		
		List<Map<String,Object>> FaqnoticeList = faqNoticeDao.getPagenatedFaqNoticeList(param);
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("totalCount", totalCount);
		map.put("FaqnoticeList", FaqnoticeList);
		map.put("navi", navi);
		map.put("paramVO", param);
		map.put("pageNo", StringUtil.nvl((String) param.get("pageNo"), "1"));
		
		return map;
	}
	@Override
	public Map<Object, Object> faqNoticeView(Object nNo) {
		// TODO Auto-generated method stub
		return faqNoticeDao.faqNoticeView(nNo);
	}

	@Override
	public List<Map<Object, Object>> faqFileView(HashMap<Object, Object> param) {
		// TODO Auto-generated method stub
		return faqNoticeDao.faqFileView(param);
	}

	@Override
	public void FaqnoticeDelete(HashMap<Object, Object> param) {
		// TODO Auto-generated method stub
		faqNoticeDao.FaqnoticeDelete(param);
	}

	@Override
	public void fileDeleteBytbKeytbType(HashMap<Object, Object> param) {
		// TODO Auto-generated method stub
		faqNoticeDao.fileDeleteBytbKeytbType(param);
	}

	@Override
	public void regisFaqtNotice(HashMap<Object, Object> param, MultipartFile... files) throws Exception {
		
		//공지사항 등록
		int tbkey = faqNoticeDao.FaqnoticeSave(param);
		
		String path = "C:/TDDOWNLOAD\\\\";
		
		ArrayList<String> fileNames = new ArrayList<String>();
		for( MultipartFile multipartFile : files ) {
			try {
				
				HashMap<Object,Object> fileParam = new HashMap<Object,Object>();
				
				String result = FileUtil.upload2(multipartFile,path,"faq");
				fileNames.add(result);
				
				GregorianCalendar cal = new GregorianCalendar();
				XMLGregorianCalendar nowData = null;
				try {
					nowData = DatatypeFactory.newInstance().newXMLGregorianCalendar(cal);
				} catch (DatatypeConfigurationException e1) {
					e1.printStackTrace();
				}
				
				String str = nowData.toString().substring(0,7).replace("-", "");
				
				String subPath = "faq" + File.separator + str + File.separator;
				
				fileParam.put("tbKey", tbkey);
				fileParam.put("tbType", "faq");
				fileParam.put("fileName", subPath + multipartFile.getOriginalFilename());

				faqNoticeDao.fileSave(fileParam);
				
			} catch( MultipartException e ) {
				e.printStackTrace();
			} 
		}
		
	}

	@Override
	public void modifyFaqNotice(NoticeVO noticeVO, MultipartFile... files) throws Exception {
		String path = "C:/TDDOWNLOAD\\\\";
		
		String contents = noticeVO.getContents().replaceAll("\n", "<br>");
		
		noticeVO.setContents(contents);
		
		faqNoticeDao.FaqnoticeEdit(noticeVO);
		
		int tbKey = Integer.valueOf(noticeVO.getnNo());
		
		HashMap<Object,Object> param = new HashMap<Object,Object>();
		param.put("tbKey", noticeVO.getnNo());
		param.put("tbType", "faq");
		
		if(noticeVO.getFileDelete()!=null){
			for(int i=0; i<noticeVO.getFileDelete().length; i++){
				/*
				 * if(i == noticeVO.getFileDelete().length || i == 0){ fmNo +=
				 * noticeVO.getFileDelete()[i]; } else { fmNo += ','+
				 * noticeVO.getFileDelete()[i]; }
				 */
				param.put("fmNo", noticeVO.getFileDelete()[i]);
				faqNoticeDao.fileManagerFileDelete(param);
			}
		}
		
		ArrayList<String> fileNames = new ArrayList<String>();
		for( MultipartFile multipartFile : files ) {
			try {
				
				HashMap<Object,Object> fileParam = new HashMap<Object,Object>();
				
				String result = FileUtil.upload2(multipartFile,path,"faq");
				fileNames.add(result);
				
				GregorianCalendar cal = new GregorianCalendar();
				XMLGregorianCalendar nowData = null;
				try {
					nowData = DatatypeFactory.newInstance().newXMLGregorianCalendar(cal);
				} catch (DatatypeConfigurationException e1) {
					e1.printStackTrace();
				}
				
				String str = nowData.toString().substring(0,7).replace("-", "");
				
				String subPath = "notice" + File.separator + str + File.separator;
				
				fileParam.put("tbKey", tbKey);
				fileParam.put("tbType", "faq");
				fileParam.put("fileName", subPath + multipartFile.getOriginalFilename());

				faqNoticeDao.fileSave(fileParam);
				
			} catch( MultipartException e ) {
				e.printStackTrace();
			} 
		}
		
	}

	@Override
	public Map<Object, Object> fileViewByFmNo(HashMap<Object, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return faqNoticeDao.fileViewByFmNo(param);
	}
	



}
