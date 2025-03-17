package kr.co.aspn.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.multipart.MultipartFile;

import kr.co.aspn.vo.LabPagingObject;
import kr.co.aspn.vo.LabPagingResult;
import kr.co.aspn.vo.NoticeVO;

public interface AdminNoticeService {
	public Map<String,Object> AdminNoticeList(HashMap<String,Object> param) throws Exception;
	
	public Map<Object,Object> AdminNoticeView(Object nNo);
	
	public List<Map<Object,Object>> AdminNoticeFileView(HashMap<Object,Object> param);
	
	public void RegistAdminNotice(HttpServletRequest request,HashMap<Object,Object> param,MultipartFile... files) throws Exception;
	
	public void DeleteAdminNotice(HashMap<Object,Object> param);
	
	public void AdminNoticeFileDeleteBytbKeytbType(HashMap<Object,Object> param);
	
	public void AdminNoticeModify(HttpServletRequest request,NoticeVO noticeVO,MultipartFile... files) throws Exception;
	
	public List<Map<Object,Object>> replyListByNo(HashMap<Object,Object> param);
	
	public void replyDeleteByNo(HashMap<Object,Object> param);
	
	public void replyRegistByNo(HashMap<Object,Object> param);
	
	public void ReplyUpdateByNo(HashMap<Object,Object> param);
	
	public Map<Object,Object> AdminNoticeFileViewByFmNo(HashMap<Object,Object> param) throws Exception;

	public void addHitsNotice(HashMap<Object,Object> param);
}
