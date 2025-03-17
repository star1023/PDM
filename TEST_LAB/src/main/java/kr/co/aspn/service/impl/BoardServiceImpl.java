package kr.co.aspn.service.impl;

import java.net.URLDecoder;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.web.multipart.MultipartFile;

import kr.co.aspn.common.auth.AuthUtil;
import kr.co.aspn.dao.AdminNoticeDao;
import kr.co.aspn.dao.BoardDao;
import kr.co.aspn.service.BoardService;
import kr.co.aspn.service.CommentService;
import kr.co.aspn.service.FileService;
import kr.co.aspn.service.LabDataService;
import kr.co.aspn.util.FileUtil;
import kr.co.aspn.util.PageNavigator;
import kr.co.aspn.util.StringUtil;
import kr.co.aspn.vo.CompanyVO;
import kr.co.aspn.vo.FileVO;
import kr.co.aspn.vo.MaterialVO;

@Service
public class BoardServiceImpl implements BoardService{
	Logger logger = LoggerFactory.getLogger(BoardService.class);
	
	@Autowired
	BoardDao boardDao;
	
	@Autowired
	AdminNoticeDao adminNoticeDao;
	
	@Autowired
	FileService fileService;
	
	@Autowired
	LabDataService labDataService;
	
	@Autowired
	CommentService commentService;

	@Autowired
	private Properties config;
	
	@Autowired
	PlatformTransactionManager txManager;
	TransactionStatus status = null;
	DefaultTransactionDefinition def = null;
	
	@Override
	public Map<String, Object> getBoardList(HashMap<String, Object> param) throws Exception {
		int totalCount = boardDao.getBoardListCount(param);
		
		int viewCount = 0;
		try {
			viewCount = Integer.parseInt(param.get("viewCount").toString());
		} catch( Exception e ) {
			viewCount = 10;
		}
		// 페이징: 페이징 정보 SET
		PageNavigator navi = new PageNavigator(param, viewCount, totalCount);
		
		List<Map<String, Object>> boardList = boardDao.getBoardList(param);
		
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("totalCount", totalCount);
		map.put("boardList", boardList);
		map.put("navi", navi);
		
		return map;
	}
	
	@Override
	public int registPost(HttpServletRequest request, HashMap<Object, Object> param, MultipartFile... files) {
		try {
			def = new DefaultTransactionDefinition();
			def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRES_NEW);
			status = txManager.getTransaction(def);	
			//공지사항 등록
			int insertCnt = boardDao.registPost(param);
			int tbkey = labDataService.insertMax("board");
			
			if(files !=null && files.length > 0) {
				Calendar cal = Calendar.getInstance();
				Date day = cal.getTime();
			    SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
			    String toDay = sdf.format(day);
			    
				String path = config.getProperty("upload.file.path.board");
				path+="/"+toDay;
	//			String path = "C:/TDDOWNLOAD\\\\"+File.separator+"notice"+File.separator+toDay;
				
				for(MultipartFile multipartFile : files) {
					try {
						if( !multipartFile.isEmpty() ) {	
							String result = "";
							FileVO fileVO = new FileVO();
							fileVO.setTbKey(""+tbkey);
							fileVO.setTbType("board_"+param.get("type"));
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
			
			return insertCnt;
		} catch( Exception e ) {
			txManager.rollback(status);  // 롤백 시
		}
		return 0;
	}
	
	@Override
	public int modfiyPost(HttpServletRequest request, HashMap<Object, Object> param, MultipartFile... files) {
		try {
			def = new DefaultTransactionDefinition();
			def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRES_NEW);
			status = txManager.getTransaction(def);	
			//공지사항 등록
			int updateCnt = boardDao.modifyPost(param);
			String tbkey = (String)param.get("nNo");
			
			String deleteFmNoParam = (String)param.get("deleteFmNoArr");
			if(deleteFmNoParam != null && !deleteFmNoParam.trim().isEmpty() ) {
				List<String> fmNoList = Arrays.asList(deleteFmNoParam.split(","));
				
				param.put("fmNo", fmNoList);
				param.put("tbType", "board_lab");
				
				logger.debug("첨부파일 삭제NO :: "+ fmNoList);
				adminNoticeDao.fileManagerFileDelete(param);
			}
			
			if(files !=null && files.length > 0) {
				Calendar cal = Calendar.getInstance();
				Date day = cal.getTime();
			    SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
			    String toDay = sdf.format(day);
			    
				String path = config.getProperty("upload.file.path.board");
				path+="/"+toDay;
				
				for(MultipartFile multipartFile : files) {
					try {
						if( !multipartFile.isEmpty() ) {	
							String result = "";
							FileVO fileVO = new FileVO();
							fileVO.setTbKey(""+tbkey);
							fileVO.setTbType("board_"+param.get("type"));
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
			
			return updateCnt;
		} catch( Exception e ) {
			txManager.rollback(status);  // 롤백 시
		}
		return 0;
	}
	
	@Override
	public Map<String, Object> getPostDetail(HashMap<String, Object> param) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		String tbType = "board_"+(String)param.get("type");
		String tbKey = (String)param.get("nNo");
		
		Map<String, Object> postDetail = boardDao.getPostDetail(param);
		boardDao.updateHits(param);
		
		resultMap.put("postDetail", postDetail);
		resultMap.put("commentList", commentService.getCommentList(tbKey, tbType));
		
		try {
			param.put("tbType", tbType);
			param.put("tbKey", tbKey);
			
			List<FileVO> fileList = fileService.fileList(param);
			resultMap.put("fileList", fileList);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		/*
		 * for(int i=0; i<fileList.size(); i++) {
		 * 
		 * fileList.get(i).put("subSequence",
		 * fileList.get(i).get("fileName").toString().subSequence(fileList.get(i).get(
		 * "fileName").toString().lastIndexOf("\\")+1, fileList.get(i).get("fileName").
		 * toString().length())); }
		 * 
		 * resultMap.put("fileView", fileList);
		 * 
		 * model.addAttribute("page",param.get("page"));
		 * model.addAttribute("keyword",param.get("keyword"));
		 * model.addAttribute("paramVO",param);
		 */
		return resultMap;
	}
	
	@Override
	public int deletePost(HashMap<Object, Object> param) {
		return boardDao.deletePost(param);
	}
}
