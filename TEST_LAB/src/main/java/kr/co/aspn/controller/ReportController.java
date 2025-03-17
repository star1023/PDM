package kr.co.aspn.controller;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import kr.co.aspn.common.auth.AuthUtil;
import kr.co.aspn.service.ApprovalService;
import kr.co.aspn.service.CommonService;
import kr.co.aspn.service.FileService;
import kr.co.aspn.service.ReportService;
import kr.co.aspn.util.FileUtil;
import kr.co.aspn.util.StringUtil;
import kr.co.aspn.util.UserUtil;
import kr.co.aspn.vo.ApprovalHeaderVO;
import kr.co.aspn.vo.ApprovalItemVO;
import kr.co.aspn.vo.ApprovalLineHeaderVO;
import kr.co.aspn.vo.ApprovalLineInfoVO;
import kr.co.aspn.vo.CodeItemVO;
import kr.co.aspn.vo.FileVO;
import kr.co.aspn.vo.ReportBom;
import kr.co.aspn.vo.ReportVO;
import kr.co.aspn.vo.ResultVO;

@Controller
@RequestMapping("/report")
public class ReportController {
	private Logger logger = LoggerFactory.getLogger(ReportController.class);
	
	@Autowired
	private Properties config;
	
	@Autowired
	ReportService reportService;
	
	@Autowired
	ApprovalService approvalService;
	
	@Autowired
	CommonService commonService;
	
	@Autowired
	FileService fileService;
	
	@RequestMapping("/list")
	public String list(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		//model.addAllAttributes(reportService.getList(param));
		model.addAttribute("paramVO", param);
		return "/report/list";
	}
	
	@RequestMapping(value = "/listAjax", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> listAjax(@RequestParam Map<String, Object> param, HttpServletRequest request, HttpServletResponse response) throws Exception {
		return reportService.getList(param);
	}
	
	@RequestMapping("/view")
	public String view(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			logger.debug("param {}", param);
			model.addAllAttributes(reportService.reportData(param));
			return "/report/view";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping("/viewPopup")
	public String viewPopup(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			logger.debug("param {}", param);
			model.addAllAttributes(reportService.reportData(param));
			return "/report/viewPopup";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping("/insertForm")
	public String insertForm(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			CodeItemVO code = new CodeItemVO ();
			code.setGroupCode("REPORTCATEGORY1");
			List<CodeItemVO> category1 = commonService.getCodeList(code);
			FileVO fileVO = new FileVO();
			fileVO.setFmNo("2904");
			fileVO.setTbType("report");
			model.addAttribute("category1", category1);
			model.addAttribute("tempFile", fileService.getOneFileInfo(fileVO));
			model.addAttribute("paramVO", param);
			return "/report/insertForm";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping(value = "/getCategoryAjax", method = RequestMethod.POST)
	@ResponseBody
	public List<Map<String,String>> getCategoryAjax(@RequestParam String categoryDiv, @RequestParam String categoryValue, HttpServletRequest request, HttpServletResponse response) throws Exception {
		try {
			return reportService.getCategoryAjax(categoryDiv, categoryValue);
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping(value = "/getSubCategoryAjax", method = RequestMethod.POST)
	@ResponseBody
	public List<Map<String,String>> getSubCategory(@RequestParam String category1, HttpServletRequest request, HttpServletResponse response) throws Exception {
		try {
			return reportService.getSubCategory(category1);
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping("/insert")
	public String insert(
			//ReportVO reportVO,
			@RequestBody @ModelAttribute ReportVO reportVO,
			@RequestParam(value = "mixName", required = false) List<String> mixName,
			@RequestParam(value = "mixId", required = false) List<String> mixId,
			@RequestParam(value = "mixItemId", required = false) List<String> mixItemId,
			@RequestParam(value = "itemName", required = false) List<String> itemName,
			@RequestParam(value = "itemBom", required = false) List<String> itemBom,
			HttpServletRequest request, HttpServletResponse response, 
			Model model,
			@RequestParam(required=false) MultipartFile... file) throws Exception {
		logger.debug("reportVO {}"+reportVO);
		String userId = UserUtil.getUserId(request);
		reportVO.setRegUserId(userId);
		reportService.insert(reportVO);
		int rNo = reportVO.getRNo();
		
		if( reportVO.getCategory1() != null && "PRD_REPORT_5".equals(reportVO.getCategory1()) ) {
			Map<String,Object> param = new HashMap<String,Object>();
			param.put("mixName", mixName);
			logger.debug("mixId : {}",mixId);
			param.put("mixId", mixId);
			param.put("rNo", rNo);
			param.put("mixItemId", mixItemId);
			param.put("itemName", itemName);
			param.put("itemBom", itemBom);
			reportService.insertReportBom(param);
		}
		
		logger.debug("rNo : {}",rNo);
		logger.debug("files : {}",file.length);
		Calendar cal = Calendar.getInstance();
        Date day = cal.getTime();    //시간을 꺼낸다.
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
        String toDay = sdf.format(day);    		
		if( file != null && file.length > 0 ) {
			String path = config.getProperty("upload.file.path.report");
			String imagePath = config.getProperty("upload.file.path.images");
			path += "/"+toDay; 
			imagePath += "/"+toDay; 
			int idx = 0;
			for( MultipartFile multipartFile : file ) {
				logger.debug("=================================");
				logger.debug("idx : {}", idx);
				logger.debug("isEmpty : {}", multipartFile.isEmpty());
				logger.debug("name : {}", multipartFile.getName());
				logger.debug("originalFilename : {}", multipartFile.getOriginalFilename());		
				logger.debug("size : {}", multipartFile.getSize());				
				logger.debug("=================================");
				try {
					if( !multipartFile.isEmpty() ) {	
						if( idx == 0 && (reportVO.getCategory1() != null && "PRD_REPORT_5".equals(reportVO.getCategory1()) ) ) {
							String result = "";
							FileVO fileVO = new FileVO();
							fileVO.setTbKey(""+rNo);
							fileVO.setTbType("report");
							fileVO.setOrgFileName(multipartFile.getOriginalFilename());
							fileVO.setRegUserId(userId);
							
							//result = FileUtil.upload(multipartFile,path);
							
							result = FileUtil.upload3(multipartFile,imagePath);
							fileVO.setFileName(result);
							fileVO.setPath(imagePath);
							//fileService.insertFile(fileVO);
							fileService.insertImageFile(fileVO);
						} else {
							String result = "";
							FileVO fileVO = new FileVO();
							fileVO.setTbKey(""+rNo);
							fileVO.setTbType("report");
							fileVO.setOrgFileName(multipartFile.getOriginalFilename());
							fileVO.setRegUserId(userId);
							
							//result = FileUtil.upload(multipartFile,path);
							result = FileUtil.upload3(multipartFile,path);
							fileVO.setFileName(result);
							fileVO.setPath(path);
							fileService.insertFile(fileVO);
						}
					}				
				} catch( Exception e ) {
					logger.debug("에러발생");
					logger.error(StringUtil.getStackTrace(e, this.getClass()));
				}
				idx++;
			}	
		}
		
		/*
		String userId = UserUtil.getUserId(request);
		reportVO.setRegUserId(userId);
		reportService.insert(reportVO);
		int rNo = reportVO.getRNo();
		
		if( reportVO.getCategory1() != null && "1".equals(reportVO.getCategory1()) ) {
			String apprUser[] = request.getParameterValues("apprUser");
			String refUser[] = request.getParameterValues("refUser");
			String circUser[] = request.getParameterValues("circUser");
			String apprTitle = request.getParameter("apprTitle");
			String apprComment = request.getParameter("apprComment");
			reportService.inserAppr(apprUser, refUser, circUser, rNo, "report", userId, apprTitle, apprComment );
		}
		
		logger.debug("rNo : {}",rNo);
		logger.debug("files : {}",file.length);
		Calendar cal = Calendar.getInstance();
        Date day = cal.getTime();    //시간을 꺼낸다.
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
        String toDay = sdf.format(day);    		
		if( file != null && file.length > 0 ) {
			String path = config.getProperty("upload.file.path.report");
			path += "/"+toDay; 
			int idx = 0;
			for( MultipartFile multipartFile : file ) {
				logger.debug("=================================");
				logger.debug("idx : {}", idx);
				logger.debug("isEmpty : {}", multipartFile.isEmpty());
				logger.debug("name : {}", multipartFile.getName());
				logger.debug("originalFilename : {}", multipartFile.getOriginalFilename());		
				logger.debug("size : {}", multipartFile.getSize());				
				logger.debug("=================================");
				try {
					if( !multipartFile.isEmpty() ) {	
						String result = "";
						FileVO fileVO = new FileVO();
						fileVO.setTbKey(""+rNo);
						fileVO.setTbType("report");
						fileVO.setOrgFileName(multipartFile.getOriginalFilename());
						fileVO.setRegUserId(userId);
						
						//result = FileUtil.upload(multipartFile,path);
						result = FileUtil.upload3(multipartFile,path);
						fileVO.setFileName(result);
						fileVO.setPath(path);
						fileService.insertFile(fileVO);
					}				
				} catch( Exception e ) {
					logger.debug("에러발생");
					e.printStackTrace();
				}
				idx++;
			}	
		}*/
		return "redirect:/report/list";
	}
	
	@RequestMapping("/updateForm")
	public String updateForm(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			model.addAllAttributes(reportService.reportData(param));
			FileVO fileVO = new FileVO();
			fileVO.setFmNo("2904");
			fileVO.setTbType("report");
			model.addAttribute("tempFile", fileService.getOneFileInfo(fileVO));
			//model.addAllAttributes(reportService.apprInfo(param));
			return "/report/updateForm";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping(value = "/apprInfoAjax", method = RequestMethod.POST)
	@ResponseBody
	public List<ApprovalItemVO> apprInfoAjax(@RequestParam String apprNo, HttpServletRequest request, HttpServletResponse response) throws Exception {
		try {
			logger.debug("apprNo {}", apprNo);
			return reportService.apprInfoAjax(apprNo);
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping(value = "/refInfoAjax", method = RequestMethod.POST)
	@ResponseBody
	public List<Map<String, Object>> refInfoAjax(@RequestParam String apprNo, HttpServletRequest request, HttpServletResponse response) throws Exception {
		try {
			logger.debug("apprNo {}", apprNo);
			return reportService.refInfoAjax(apprNo);
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping("/update")
	public String update(
			@RequestBody @ModelAttribute ReportVO reportVO,
			@RequestParam(value = "mixName", required = false) List<String> mixName,
			@RequestParam(value = "mixId", required = false) List<String> mixId,
			@RequestParam(value = "mixItemId", required = false) List<String> mixItemId,
			@RequestParam(value = "itemName", required = false) List<String> itemName,
			@RequestParam(value = "itemBom", required = false) List<String> itemBom,
			HttpServletRequest request, HttpServletResponse response, 
			Model model,
			@RequestParam(required=false) MultipartFile... file) throws Exception {
		
		String userId = UserUtil.getUserId(request);
		reportVO.setModUserId(userId);
		reportService.update(reportVO);
		int rNo = reportVO.getRNo();
		
		if( reportVO.getCategory1() != null && "PRD_REPORT_5".equals(reportVO.getCategory1()) ) {
			Map<String,Object> param = new HashMap<String,Object>();
			param.put("mixName", mixName);
			logger.debug("mixId : {}",mixId);
			param.put("mixId", mixId);
			param.put("rNo", rNo);
			param.put("mixItemId", mixItemId);
			param.put("itemName", itemName);
			param.put("itemBom", itemBom);
			reportService.deleteReportBom(param);
			reportService.insertReportBom(param);
		}
		
		logger.debug("rNo : {}",rNo);
		logger.debug("files : {}",file.length);
		Calendar cal = Calendar.getInstance();
        Date day = cal.getTime();    //시간을 꺼낸다.
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
        String toDay = sdf.format(day);    		
		if( file != null && file.length > 0 ) {
			String path = config.getProperty("upload.file.path.report");
			String imagePath = config.getProperty("upload.file.path.images");
			path += "/"+toDay; 
			imagePath += "/"+toDay; 
			int idx = 0;
			for( MultipartFile multipartFile : file ) {
				logger.debug("=================================");
				logger.debug("idx : {}", idx);
				logger.debug("isEmpty : {}", multipartFile.isEmpty());
				logger.debug("name : {}", multipartFile.getName());
				logger.debug("originalFilename : {}", multipartFile.getOriginalFilename());		
				logger.debug("size : {}", multipartFile.getSize());				
				logger.debug("=================================");
				try {
					if( !multipartFile.isEmpty() ) {	
						if( idx == 0 && (reportVO.getCategory1() != null && "PRD_REPORT_5".equals(reportVO.getCategory1()) ) ) {
							String result = "";
							FileVO fileVO = new FileVO();
							fileVO.setTbKey(""+rNo);
							fileVO.setTbType("report");
							fileVO.setOrgFileName(multipartFile.getOriginalFilename());
							fileVO.setRegUserId(userId);
							
							FileVO imageFileVO = fileService.imageFileInfo(fileVO);
							FileUtil.fileDelete(imageFileVO.getFileName(), imageFileVO.getPath());
							fileService.deleteImageFileInfo(imageFileVO);
							//result = FileUtil.upload(multipartFile,path);
							result = FileUtil.upload3(multipartFile,imagePath);
							fileVO.setFileName(result);
							fileVO.setPath(imagePath);
							//fileService.insertFile(fileVO);
							fileService.insertImageFile(fileVO);
						} else {
							String result = "";
							FileVO fileVO = new FileVO();
							fileVO.setTbKey(""+rNo);
							fileVO.setTbType("report");
							fileVO.setOrgFileName(multipartFile.getOriginalFilename());
							fileVO.setRegUserId(userId);
							
							//result = FileUtil.upload(multipartFile,path);
							result = FileUtil.upload3(multipartFile,path);
							fileVO.setFileName(result);
							fileVO.setPath(path);
							fileService.insertFile(fileVO);
						}
					}				
				} catch( Exception e ) {
					logger.debug("에러발생");
					logger.error(StringUtil.getStackTrace(e, this.getClass()));
				}
				idx++;
			}	
		}
		
		/*
		if( reportVO.getCategory1() != null && "1".equals(reportVO.getCategory1()) ) {
			//결재 데이터(헤더, 아이템) 삭제
			//참조, 회람 데이터 삭제
			approvalService.deleteAppr(reportVO.getApprNo());
			String apprUser[] = request.getParameterValues("apprUser");
			String refUser[] = request.getParameterValues("refUser");
			String circUser[] = request.getParameterValues("circUser");
			String apprTitle = request.getParameter("apprTitle");
			String apprComment = request.getParameter("apprComment");
			reportService.inserAppr(apprUser, refUser, circUser, rNo, "report", userId, apprTitle, apprComment );
		}
		
		logger.debug("rNo : {}",rNo);
		logger.debug("files : {}",file.length);
		Calendar cal = Calendar.getInstance();
        Date day = cal.getTime();    //시간을 꺼낸다.
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
        String toDay = sdf.format(day);    		
		if( file != null && file.length > 0 ) {
			String path = config.getProperty("upload.file.path.report");
			path += "/"+toDay; 
			int idx = 0;
			for( MultipartFile multipartFile : file ) {
				logger.debug("=================================");
				logger.debug("idx : {}", idx);
				logger.debug("isEmpty : {}", multipartFile.isEmpty());
				logger.debug("name : {}", multipartFile.getName());
				logger.debug("originalFilename : {}", multipartFile.getOriginalFilename());		
				logger.debug("size : {}", multipartFile.getSize());				
				logger.debug("=================================");
				try {
					if( !multipartFile.isEmpty() ) {	
						String result = "";
						FileVO fileVO = new FileVO();
						fileVO.setTbKey(""+rNo);
						fileVO.setTbType("report");
						fileVO.setOrgFileName(multipartFile.getOriginalFilename());
						fileVO.setRegUserId(userId);
						
						//result = FileUtil.upload(multipartFile,path);
						result = FileUtil.upload3(multipartFile,path);
						fileVO.setFileName(result);
						fileVO.setPath(path);
						fileService.insertFile(fileVO);
					}				
				} catch( Exception e ) {
					logger.debug("에러발생");
					e.printStackTrace();
				}
				idx++;
			}	
		}
		*/
		return "redirect:/report/list";
	}
	
	@RequestMapping("/delete")
	public String delete(@RequestParam String rNo, HttpServletRequest request, HttpServletResponse response) throws Exception {
		try {
			reportService.delete(rNo);
			Map<String,Object> param = new HashMap<String,Object>();
			param.put("rNo", rNo);
			reportService.deleteReportBom(param);
			
			//결재 데이터(헤더, 아이템) 삭제
			//reportService.deleteAppr(apprNo);
			//참조, 회람 데이터 삭제
			//approvalService.deleteAppr(apprNo);
			//reportService.deleteRefCirc(apprNo);
			
			//파일삭제
			//reportService.deleteFile(rNo);
			param.put("tbKey", rNo);
			param.put("tbType", "report");
			fileService.deleteAllImageFile(param);
			fileService.deleteAllFile(param);
			return "redirect:/report/list";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
}
