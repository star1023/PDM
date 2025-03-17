package kr.co.aspn.controller;

import java.io.File;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import kr.co.aspn.common.auth.AuthUtil;
import kr.co.aspn.service.FileService;
import kr.co.aspn.service.ReserveService;
import kr.co.aspn.service.SendMailService;
import kr.co.aspn.service.UserService;
import kr.co.aspn.util.FileUtil;
import kr.co.aspn.util.StringUtil;
import kr.co.aspn.vo.FileVO;
import kr.co.aspn.vo.LabPagingObject;

@Controller
@RequestMapping("/Reserve")
public class ReserveController {
	private Logger logger = LoggerFactory.getLogger(ReportController.class);
	
	@Autowired
	ReserveService reserveService;
	
	@Autowired
	private Properties config;
	
	@Autowired
	FileService fileService;
	
	@Autowired
	UserService userService;
	
	@Autowired
	SendMailService sendMailService;
	
	@RequestMapping("/ReserveList")
	public String reserveList(HttpServletRequest request,ModelMap model, @RequestParam HashMap<String,Object> param) throws Exception {
		
		/*
		 * model.addAllAttributes(reserveService.reserveMeetingRoomList(param));
		 * model.addAttribute("reserveNotiList",
		 * reserveService.reserveMeetingRoomNotiList());
		 */
		
		try {
			model.addAllAttributes(reserveService.reserveRoomPagenatedList(param));
			model.addAttribute("loginuserId", AuthUtil.getAuth(request).getUserId());
		
			int timeCode = Integer.valueOf(reserveService.selectTimeCode());
		
			model.addAttribute("timeCode",timeCode);
			model.addAttribute("pageNo",StringUtil.nvl((String) param.get("pageNo"), "1"));
			model.addAttribute("paramVO",param);
			
			return "/reserve/ReserveList";
		}catch(Exception e) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	
	}
	
	@RequestMapping("/ReserveView")
	public String reserveView(HttpServletRequest request, ModelMap model, @RequestParam HashMap<String,Object> param ) throws Exception {
		
		try {
			model.addAttribute("data",reserveService.reserveMeetingRoomView(param));
			model.addAttribute("userId", AuthUtil.getAuth(request).getUserId());
			model.addAttribute("grade", AuthUtil.getAuth(request).getUserGrade());
			
			return "/001/ReserveView";
		}catch(Exception e) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	
	}
	
	@ResponseBody
	@RequestMapping("/ReserveDelete")
	public Map<String,String> reserveDelete(HttpServletRequest request, ModelMap model, @RequestParam HashMap<String,Object> param ) throws Exception {
		
		Map<String,String> map = new HashMap<String,String>();
		
		try {
			reserveService.reserveMeetingRoomDelete(param);
			
			List<Map<String,Object>> fileList = reserveService.reserveFileList(param);
			if(fileList.size() > 0) {
				for(int i = 0; i<fileList.size(); i++) {
					File file = new File((String)fileList.get(i).get("path")+File.separator+(String)fileList.get(i).get("fileName"));
					if(file.exists()) {
						file.delete();
					}
				}
			}
			reserveService.reserveFileDelete(param);
			
			map.put("result", "S");
		}catch(Exception e) {
			map.put("result", "F");
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
		}
		
		return map;
	}

	@RequestMapping("/ReserveEdit")
	public String reserveEdit(HttpServletRequest request, ModelMap model, @RequestParam HashMap<String,Object> param ) throws Exception {
		
		try {
			model.addAttribute("data", reserveService.reserveMeetingRoomView(param));		
			return "/001/editReservePopup";
		}catch(Exception e) {
			logger.error(StringUtil.getStackTrace(e,this.getClass()));
			throw e;
		}
			
	}
	
	@RequestMapping("/ReserveEditAjax")
	public String reserveEditAjax(HttpServletRequest request, ModelMap model, @RequestParam HashMap<String,Object> param,@RequestParam(required=false) MultipartFile... files) throws Exception {
		
		/*
		 * Map<String,Object> map = new HashMap<String,Object>();
		 * 
		 * String startTime = (String)param.get("startTime")+":00";
		 * 
		 * String endTime = (String)param.get("endTime")+":00";
		 * 
		 * String diffTime = "";
		 * 
		 * SimpleDateFormat f= new SimpleDateFormat("HH:mm:ss",Locale.KOREA);
		 * 
		 * Date d1 = f.parse(startTime); Date d2 = f.parse(endTime);
		 * 
		 * double diff = d2.getTime()-d1.getTime(); int min = (int)diff/60000;
		 * 
		 * switch(min) {
		 * 
		 * case 30: diffTime = "1"; break; case 60: diffTime = "2"; break; case 90:
		 * diffTime = "3"; break; case 120: diffTime = "4"; break; case 150: diffTime =
		 * "5"; break; case 180: diffTime = "6"; break;
		 * 
		 * } param.put("diffTime", diffTime); param.put("modUserId",
		 * AuthUtil.getAuth(request).getUserId()); try {
		 * reserveService.reserveMeetingRoomUpdate(param); map.put("status", "success");
		 * }catch(Exception e) { map.put("status","fail"); e.printStackTrace(); }
		 * 
		 * return map;
		 */
		
		try {
			
		Map<String,Object> existReserveDetail =  reserveService.reserveDetail(String.valueOf(param.get("modifyRmrNo")));
		
		String existStartTime = ((String)existReserveDetail.get("startTime")).trim();
		
		String existEndTime = ((String)existReserveDetail.get("endTime")).trim();
		
		String existReserveDate = (String.valueOf(existReserveDetail.get("reserveDate"))).trim();
		
		String updateStartTime = ((String)param.get("startTime")).trim();
		
		String updateEndTime = ((String)param.get("endTime")).trim();
		
		String updateReserveDate = ((String)param.get("reserveDate")).trim();
		
		String diffTime = "";
			
		SimpleDateFormat f= new SimpleDateFormat("HH:mm:ss",Locale.KOREA);
		
		Date d1 = f.parse((String)param.get("startTime")+":00");
		Date d2 = f.parse((String)param.get("endTime")+":00");
		
		double diff = d2.getTime()-d1.getTime();
		int min = (int)diff/60000;
		
		switch(min) {
		
			case 30:
				diffTime = "1";
				break;
			case 60:
				diffTime = "2";
				break;
			case 90:
				diffTime = "3";
				break;
			case 120:
				diffTime = "4";
				break;
			case 150:
				diffTime = "5";
				break;
			case 180:
				diffTime = "6";
				break;
			case 210:
				diffTime = "7";
				break;
			case 240:
				diffTime = "8";
				break;
			case 270:
				diffTime = "9";
				break;
			case 300:
				diffTime = "10";
				break;
			case 330:
				diffTime = "11";
				break;
			case 360:
				diffTime = "12";
				break;
			case 390:
				diffTime = "13";
				break;
			case 420:
				diffTime = "14";
				break;
			case 450:
				diffTime = "15";
				break;
			case 480:
				diffTime = "16";
				break;
			case 510:
				diffTime = "17";
				break;
			case 540:
				diffTime = "18";
				break;
			case 570:
				diffTime = "19";
				break;
			case 600:
				diffTime = "20";
				break;
		
		}
		
		String fileDelete[] = {};
		
		if((String)param.get("fileDelete") != null && !((String)param.get("fileDelete")).equals("")) {
			fileDelete = ((String)param.get("fileDelete")).split(",");
		}
		
		HashMap<String,Object> map = new HashMap<String,Object>();
		
		map.put("rmrNo", (String)param.get("modifyRmrNo"));
		map.put("title", (String)param.get("title"));
		map.put("modUserId", AuthUtil.getAuth(request).getUserId());
		map.put("notiYN", (String)param.get("notiYNval"));
		map.put("reserveDate", (String)param.get("reserveDate"));
		map.put("reserveCode", (String)param.get("reserveRoomCode"));
		map.put("pn", (String)param.get("pn"));
		map.put("startTime", (String)param.get("startTime"));
		map.put("endTime", (String)param.get("endTime"));
		map.put("reserveDayCode", (String)param.get("reserveDayCode"));
		map.put("diffTime", diffTime);
		map.put("tbType", "reserve");
		map.put("meetingCategory", (String)param.get("meetingCategoryVal"));
		
		
			reserveService.reserveMeetingRoomUpdate(map);
			
		if(fileDelete.length > 0) {
				for(int i = 0 ; i < fileDelete.length; i++) {
				
					map.put("fmNo", fileDelete[i]);
					reserveService.reserveFileManagerDelete(map);
			}
		}
		
		Calendar cal = Calendar.getInstance();
		Date day = cal.getTime();
	    SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
	    String toDay = sdf.format(day);
		
	    
		if(files !=null && files.length > 0) {
			String path = config.getProperty("upload.file.path.reserve");
			path+="/"+toDay;
//			String path = "C:/TDDOWNLOAD\\\\"+File.separator+"reserve"+File.separator+toDay;
			
			for(MultipartFile multipartFile : files) {
				try {
					if( !multipartFile.isEmpty() ) {	
						String result = "";
						FileVO fileVO = new FileVO();
						fileVO.setTbKey(""+(String)param.get("modifyRmrNo"));
						fileVO.setTbType("reserve");
						fileVO.setOrgFileName(multipartFile.getOriginalFilename());
						fileVO.setRegUserId(AuthUtil.getAuth(request).getUserId());
						
						//result = FileUtil.upload(multipartFile,path);
						result = FileUtil.upload3(multipartFile,path);
						fileVO.setFileName(result);
						fileVO.setPath(path);
						fileService.insertFile(fileVO);
					}				
				} catch( Exception e ) {
					logger.error(StringUtil.getStackTrace(e, this.getClass()));
				}
			}
				
		}
		
		param.put("gubun", "modify");
	    param.put("rNo", (String)param.get("modifyRmrNo"));
	    
	    //List<Map<String,Object>> receiver = userService.researchUserList();
	    
	    if(((String)param.get("meetingCategoryVal")).equals("Y")) {
	    	
	    	if(!existStartTime.equals(updateStartTime) || !existEndTime.equals(updateEndTime) || !existReserveDate.equals(updateReserveDate)) {
	    		Map<String,String> parmMap = new HashMap<String,String>();
	    		parmMap.put("userGrade", "4");
				List<Map<String,Object>> mailList = userService.sendMailList(parmMap);
				
				if( mailList != null && mailList.size() > 0 ) {
					for( int i = 0 ; i < mailList.size() ; i++ ) {
						Map<String,Object> mailData = mailList.get(i);
						param.put("mailReceiver", String.valueOf(mailData.get("email")));
						sendMailService.sendMeetingMail(param);
					}
				} else {
					param.put("mailReceiver", "star1023@aspnc.com");
					sendMailService.sendMeetingMail(param);
				}
	    	}
	    }
	    
	    
	    String pageNo = "";
		String searchType = "";
		String searchValue = "";
		String viewCount  = "";
	    
		if(param.get("pageNo_1") !=null && param.get("searchType_1")!=null && param.get("searchValue_1") !=null && param.get("viewCount_1")!=null ) {
			 pageNo = (String)param.get("pageNo_1");
			 searchType = (String)param.get("searchType_1");
			 searchValue = URLEncoder.encode((String)param.get("searchValue_1"),"UTF-8");
			 viewCount  = (String)param.get("viewCount_1");
		}
		
//	    return "redirect:/Reserve/ReserveList?pageNo="+pageNo+"&viewCount="+viewCount+"&searchType="+searchType+"&searchValue="+searchValue;
	    
		return "redirect:/Reserve/ReserveList?pageNo="+pageNo+"&viewCount="+viewCount+"&searchValue="+searchValue+"&searchType="+searchType;
		
		}catch(Exception e) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
		
	}
	
	@RequestMapping("/ReserveSave")
	public String reserveSave(HttpServletRequest request, ModelMap model, @RequestParam HashMap<String,Object> param ) throws Exception {
		
		return "/001/createReservePopup";
	}
	
	@ResponseBody
	@RequestMapping("/ReserveCountAjax")
	public Map<String,Object> reserveCountAjax(HttpServletRequest request, ModelMap model, @RequestParam HashMap<String,Object> param) throws Exception {
		
		Map<String,Object> map = new HashMap<String,Object>();

	    String reserveTime = (String)param.get("reserveTime");
	  
	    int idx = reserveTime.indexOf("~");
		
		param.put("reserveTimeSt", reserveTime.substring(0, idx));
		
		param.put("reserveTimeEt",  reserveTime.substring(idx+1));
		
		try {
			map.put("status", "success");
			map.put("count", reserveService.selectDuplicateTime(param));
		}catch(Exception e) {
			map.put("status", "fail");
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
		}
		
		return map;
	}
	

	@RequestMapping("/ReserveSaveAjax")
	public String reserveSaveAjax(HttpServletRequest request, ModelMap model, @RequestParam HashMap<String,Object> param,@RequestParam(required=false) MultipartFile... files) throws Exception {
		
		
		try {
		
		
		String startTime = (String)param.get("startTime")+":00";
		
		String endTime = (String)param.get("endTime")+":00";
		
		String diffTime = "";
		
		String gubun = (String)param.get("gubun");
		
		String direcTion = "";
		
		SimpleDateFormat f= new SimpleDateFormat("HH:mm:ss",Locale.KOREA);
		
		Date d1 = f.parse(startTime);
		Date d2 = f.parse(endTime);
		
		double diff = d2.getTime()-d1.getTime();
		int min = (int)diff/60000;
		
		switch(min) {
		
		case 30:
			diffTime = "1";
			break;
		case 60:
			diffTime = "2";
			break;
		case 90:
			diffTime = "3";
			break;
		case 120:
			diffTime = "4";
			break;
		case 150:
			diffTime = "5";
			break;
		case 180:
			diffTime = "6";
			break;
		case 210:
			diffTime = "7";
			break;
		case 240:
			diffTime = "8";
			break;
		case 270:
			diffTime = "9";
			break;
		case 300:
			diffTime = "10";
			break;
		case 330:
			diffTime = "11";
			break;
		case 360:
			diffTime = "12";
			break;
		case 390:
			diffTime = "13";
			break;
		case 420:
			diffTime = "14";
			break;
		case 450:
			diffTime = "15";
			break;
		case 480:
			diffTime = "16";
			break;
		case 510:
			diffTime = "17";
			break;
		case 540:
			diffTime = "18";
			break;
		case 570:
			diffTime = "19";
			break;
		case 600:
			diffTime = "20";
			break;
	
	}
		
		Calendar cal = Calendar.getInstance();
		Date day = cal.getTime();
	    SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
	    String toDay = sdf.format(day);
	    
		param.put("diffTime", diffTime);
		param.put("regUserId", AuthUtil.getAuth(request).getUserId());
		param.put("meetingCategory", (String)param.get("meetingCategoryVal"));
		
		Map<String,Object> rNo = reserveService.reserveMeetingRoomSave(param);
			
		if(files !=null && files.length > 0) {
			String path = config.getProperty("upload.file.path.reserve");
			path+="/"+toDay;
//			String path = "C:/TDDOWNLOAD\\\\"+File.separator+"reserve"+File.separator+toDay;
			
			for(MultipartFile multipartFile : files) {
				try {
					if( !multipartFile.isEmpty() ) {	
						String result = "";
						FileVO fileVO = new FileVO();
						fileVO.setTbKey(""+rNo.get("rNo"));
						fileVO.setTbType("reserve");
						fileVO.setOrgFileName(multipartFile.getOriginalFilename());
						fileVO.setRegUserId(AuthUtil.getAuth(request).getUserId());
						
						//result = FileUtil.upload(multipartFile,path);
						result = FileUtil.upload3(multipartFile,path);
						fileVO.setFileName(result);
						fileVO.setPath(path);
						fileService.insertFile(fileVO);
					}				
				} catch( Exception e ) {
					logger.error(StringUtil.getStackTrace(e, this.getClass()));
				}
			}
				
		}
		
		param.put("gubun", "save");
		param.put("rNo", rNo.get("rNo"));
		
		//List<Map<String,Object>> receiver = userService.researchUserList();
		
		if(((String)param.get("meetingCategoryVal")).equals("Y")) {
			
			//for(int i=0; i<receiver.size(); i++) {
			//	param.put("receiver", (String)(receiver.get(i).get("userName")));
			//	param.put("receiver_email", (String)receiver.get(i).get("email"));
			//	sendMailService.sendMeetingMail(param);
			//}
			Map<String,String> parmMap = new HashMap<String,String>();
    		parmMap.put("userGrade", "4");
			List<Map<String,Object>> mailList = userService.sendMailList(parmMap);
			
			if( mailList != null && mailList.size() > 0 ) {
				for( int i = 0 ; i < mailList.size() ; i++ ) {
					Map<String,Object> mailData = mailList.get(i);
					param.put("mailReceiver", String.valueOf(mailData.get("email")));
					sendMailService.sendMeetingMail(param);					
				}
			} else {
				param.put("mailReceiver", "star1023@aspnc.com");
				sendMailService.sendMeetingMail(param);
			}
			
		}
		
		String pageNo = "";
		String searchType = "";
		String searchValue = "";
		String viewCount = "";
		
		if(param.get("pageNo_1") !=null && param.get("searchType_1")!=null && param.get("searchValue_1") !=null && param.get("viewCount_1")!=null ) {
			 pageNo = (String)param.get("pageNo_1");
			 searchType = (String)param.get("searchType_1");
			 searchValue = URLEncoder.encode((String)param.get("searchValue_1"),"UTF-8");
			 viewCount  = (String)param.get("viewCount_1");
		}
		
		String weekParam = "";
		
		String selectDay = "";
		
		if(param.get("weekParam") != null && param.get("selectDay") !=null) {
			
			weekParam = (String)param.get("weekParam");
			
			selectDay = (String)param.get("selectDay");
			
		}
		
		
		if(gubun == null || gubun.equals("")) {
			direcTion = "redirect:/main/main?selectDay="+selectDay+"&weekParam="+weekParam;	
		}else {
			direcTion = "redirect:/Reserve/ReserveList?pageNo="+pageNo+"&viewCount="+viewCount+"&searchType="+searchType+"&searchValue="+searchValue;
		}

			return direcTion;
			
		}catch(Exception e) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@ResponseBody
	@RequestMapping("/ReserveDetail")
	public Map<String,Object> ReserveDetail(ModelMap model, @RequestParam HashMap<String,Object> param) {
		
		Map<String,Object> map = new HashMap<String,Object>();
		
		String rmrNo = String.valueOf(param.get("tbKey"));
		
		try {
			map.put("detailReserve", reserveService.reserveDetail(rmrNo));
			List<FileVO> fileList = fileService.fileList(param);
			for (FileVO fileVO : fileList) {
				// 보안 문제로인 한 Path 삭제 및 사용하지 않는 필드 제거
				fileVO.setTbType("");
				fileVO.setFileName("");
				fileVO.setPath("");
				fileVO.setRegUserId("");
				fileVO.setRegDate("");
				fileVO.setIsOld("");
			}
			map.put("fileList", fileList);
			map.put("status", "S");
		}catch(Exception e) {
			map.put("status","F");
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
		}
		
		return map;
	}
	
	@ResponseBody
	@RequestMapping("/ReserveCount")
	public Map<String,Object> ReserveCount(ModelMap model, @RequestParam HashMap<String,Object> param){
		
		Map<String,Object> map = new HashMap<String,Object>();
		
		String startTime = (String)param.get("startTime");
		String endTime = (String)param.get("endTime");
		
		String startTimeCode = "";
		String endTimeCode = "";
		
		int count = 0;
		
		/*switch(startTime) {
		
			case "09:00":
				startTimeCode = "1";
			break;
			case "09:30":
				startTimeCode = "2";
			break;
			case "10:00":
				startTimeCode = "3";
			break;
			case "10:30":
				startTimeCode = "4";
			break;
			case "11:00":
				startTimeCode = "5";
			break;
			case "11:30":
				startTimeCode = "6";
			break;
			case "12:00":
				startTimeCode = "7";
			break;
			case "12:30":
				startTimeCode = "8";
			break;
			case "13:00":
				startTimeCode = "9";
			break;
			case "13:30":
				startTimeCode = "10";
			break;
			case "14:00":
				startTimeCode = "11";
			break;
			case "14:30":
				startTimeCode = "12";
			break;
			case "15:00":
				startTimeCode = "13";
			break;
			case "15:30":
				startTimeCode = "14";
			break;
			case "16:00":
				startTimeCode = "15";
			break;
			case "16:30":
				startTimeCode = "16";
			break;
			case "17:00":
				startTimeCode = "17";
			break;
			case "17:30":
				startTimeCode = "18";
			break;
			case "18:00":
				startTimeCode = "19";
			break;
		}
		
		switch(endTime) {
		
			case "09:00":
				endTimeCode = "1";
				break;
			case "09:30":
				endTimeCode = "2";
				break;
			case "10:00":
				endTimeCode = "3";
				break;
			case "10:30":
				endTimeCode = "4";
				break;
			case "11:00":
				endTimeCode = "5";
				break;
			case "11:30":
				endTimeCode = "6";
				break;
			case "12:00":
				endTimeCode = "7";
				break;
			case "12:30":
				endTimeCode = "8";
				break;
			case "13:00":
				endTimeCode = "9";
				break;
			case "13:30":
				endTimeCode = "10";
				break;
			case "14:00":
				endTimeCode = "11";
				break;
			case "14:30":
				endTimeCode = "12";
				break;
			case "15:00":
				endTimeCode = "13";
				break;
			case "15:30":
				endTimeCode = "14";
				break;
			case "16:00":
				endTimeCode = "15";
				break;
			case "16:30":
				endTimeCode = "16";
				break;
			case "17:00":
				endTimeCode = "17";
				break;
			case "17:30":
				endTimeCode = "18";
				break;
			case "18:00":
				endTimeCode = "19";
				break;
		}*/
		
		String reserveDate = (String)param.get("reserveDate");
		String reserveCode = (String)param.get("reserveCode");
		String rmrNo = (String)param.get("rmrNo");
		
		try {
		
			HashMap<String,Object> countParam = new HashMap<String,Object>();
				
			countParam.put("startTimeCode", Integer.parseInt(startTimeCode));
			countParam.put("endTimeCode", Integer.parseInt(endTimeCode));
			countParam.put("reserveDate", reserveDate);
			countParam.put("reserveCode", reserveCode);
			countParam.put("rmrNo", rmrNo);
			
			count = reserveService.reserveCountDuple(countParam);
				
			map.put("count", count);
			map.put("status", "S");
		}catch(Exception e) {
			map.put("status", "F");
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
		}
		
			return map;
		
	}
}
