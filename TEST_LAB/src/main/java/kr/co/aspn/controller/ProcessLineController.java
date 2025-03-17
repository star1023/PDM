package kr.co.aspn.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
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
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import kr.co.aspn.service.FileService;
import kr.co.aspn.service.ProcessLineService;
import kr.co.aspn.util.FileUtil;
import kr.co.aspn.util.StringUtil;
import kr.co.aspn.util.UserUtil;
import kr.co.aspn.vo.ApprovalItemVO;
import kr.co.aspn.vo.FileVO;
import kr.co.aspn.vo.ProcessLineVO;
import kr.co.aspn.vo.ReportVO;

@Controller
@RequestMapping("/processLine")
public class ProcessLineController {
	private Logger logger = LoggerFactory.getLogger(ProcessLineController.class);
	@Autowired
	private Properties config;
	
	@Autowired
	ProcessLineService processLineService;
	
	@Autowired
	FileService fileService;
	
	@RequestMapping("/list")
	public String list(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			List<ProcessLineVO> processLineList = processLineService.getList(param);
			
			logger.debug("processLineList {}", processLineList);
			logger.debug("size {}", processLineList.size());
			model.addAttribute("processLineList", processLineList);
			param.put("tbType", "lineProcessTree");
			List<FileVO> fileList = fileService.fileList(param);
			Map<String, List<FileVO>> fileMap = new HashMap<String, List<FileVO>>();
			for( int i = 0 ; i < fileList.size() ; i++ ) {
				FileVO fileVO = fileList.get(i);
				String tbKey = fileVO.getTbKey();
				if( fileMap.containsKey(tbKey) ){
					fileMap.get(tbKey).add(fileVO);
				} else {
					List<FileVO> fileData = new ArrayList<FileVO>();
					fileData.add(fileVO);
					fileMap.put(tbKey, fileData);
				}
			}
			logger.debug("fileMap {}", fileMap);
			model.addAttribute("fileMap", fileMap);
			return "/processLine/list";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping(value = "/getLineCodeAjax", method = RequestMethod.POST)
	@ResponseBody
	public List<Map<String,Object>> getLineCodeAjax(@RequestParam String plantName, HttpServletRequest request, HttpServletResponse response) throws Exception {
		try {
			logger.debug("plantName {}", plantName);
			return processLineService.getLineCode(plantName);
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping("/insert")
	public String insert(
			String[] plantCode,
			String[] lineCode,
			HttpServletRequest request, HttpServletResponse response, 
			Model model,
			@RequestParam(required=false) MultipartFile... file) throws Exception {
		
		String userId = UserUtil.getUserId(request);
		String tbType = "lineProcessTree";
		
		Calendar cal = Calendar.getInstance();
        Date day = cal.getTime();    //시간을 꺼낸다.
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
        String toDay = sdf.format(day); 
        if( file != null && file.length > 0 ) {
			String path = config.getProperty("upload.file.path.processLine");
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
						fileVO.setTbKey(lineCode[idx]);
						fileVO.setTbType(tbType);
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
					logger.error(StringUtil.getStackTrace(e, this.getClass()));
				}
				idx++;
			}	
		}
		return "redirect:/processLine/list";
	}
}
