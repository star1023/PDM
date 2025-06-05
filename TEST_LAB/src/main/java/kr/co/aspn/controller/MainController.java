package kr.co.aspn.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

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

import kr.co.aspn.common.auth.Auth;
import kr.co.aspn.common.auth.AuthUtil;
import kr.co.aspn.service.BoardNoticeService;
import kr.co.aspn.service.CommonService;
import kr.co.aspn.service.LabDataService;
import kr.co.aspn.service.ProductDesignService;
import kr.co.aspn.service.ProductDevService;
import kr.co.aspn.service.ReserveService;
import kr.co.aspn.util.StringUtil;
import kr.co.aspn.vo.CompanyVO;

@Controller
@RequestMapping("/main")
public class MainController {
	private Logger logger = LoggerFactory.getLogger(MainController.class);
	@Autowired
	ReserveService reserveService;
	
	@Autowired
	ProductDevService productDevService;
	
	@Autowired
	ProductDesignService productDesgignService;
	
	@Autowired
	LabDataService labDataService;
	
	@Autowired
	CommonService commonService;
	
	@Autowired
	BoardNoticeService boardNoticeService;
	
	@RequestMapping(value = { "/","/main" }, method = RequestMethod.GET)
	public String main(HttpServletRequest request, Model model,@RequestParam Map<String,Object> param) throws Exception {

		// 메인에서 로그인
		if (!AuthUtil.hasAuth(request)) {
			return "redirect:/user/login";
		}
		try {
		//Auth auth = AuthUtil.getAuth(request);
				//model.addAttribute("countDesignDoc",productDesgignService.countForProductDesignDoc(AuthUtil.getAuth(request).getUserId()));
				//model.addAttribute("countDevDoc",productDevService.countForDevDoc(AuthUtil.getAuth(request).getUserId()));
				//model.addAttribute("countDesignRequest",productDevService.countForDesignRequestDoc(AuthUtil.getAuth(request).getUserId()));
				//model.addAttribute("countManufacturingDoc",productDevService.countForManuFacturingProcessDoc(AuthUtil.getAuth(request).getUserId()));
				//model.addAttribute("countForState",labDataService.countForState(AuthUtil.getAuth(request).getUserId()));
				
				SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
				
				Date todayDate = new Date();
				
				Calendar cal = Calendar.getInstance();
				
				String selectDayParam = (String)param.get("selectDay");
				
				String weekParam = (String)param.get("weekParam");
				
				int timeCode = Integer.valueOf(reserveService.selectTimeCode());
				
				int tYear = 0;
				int tMonth = 0;
				int tDate = 0;
				
				if(selectDayParam == null || selectDayParam.equals("")) {
						tYear = cal.get(cal.YEAR);
						tMonth = cal.get(cal.MONTH) + 1;
						tDate = cal.get(cal.DATE);
				} 
				else {
					tYear = Integer.parseInt(selectDayParam.split("-")[0]);
					tMonth = Integer.parseInt(selectDayParam.split("-")[1]); 
					tDate = Integer.parseInt(selectDayParam.split("-")[2]); 
				}
				
				if(weekParam !=null && !weekParam.equals("")) {
					if(weekParam.equals("P")) {
						cal.set(tYear, tMonth-1, tDate);
						cal.add(Calendar.DATE, -7);
					}else if(weekParam.equals("N")) {
						cal.set(tYear, tMonth-1, tDate);
						cal.add(Calendar.DATE, +7);
					}
				}
				else if(weekParam == null || weekParam.equals("")){
					 cal.set(tYear, tMonth-1, tDate);
				}
				
		        String selectDay = format.format(cal.getTime());
		        
		        cal.set(Calendar.DAY_OF_WEEK,Calendar.MONDAY);
		        String monday =  format.format(cal.getTime());
		        
		        cal.set(Calendar.DAY_OF_WEEK,Calendar.TUESDAY);
		        String tuesday =  format.format(cal.getTime());
				
		        cal.set(Calendar.DAY_OF_WEEK,Calendar.WEDNESDAY);
		        String wednesday =  format.format(cal.getTime());
		        
		        cal.set(Calendar.DAY_OF_WEEK,Calendar.THURSDAY);
		        String thursday =  format.format(cal.getTime());
		        
		        cal.set(Calendar.DAY_OF_WEEK,Calendar.FRIDAY);
		        String friday =  format.format(cal.getTime());
		        
		        param.put("monday", monday);
		        param.put("friday", friday);
		        
		       /* List<Map<String,Object>> reserveList = reserveService.reserveRoomList(param);
		        
		        List<Map<String,Object>> reserveList1 = new ArrayList<Map<String,Object>>();
		        List<Map<String,Object>> reserveList2 = new ArrayList<Map<String,Object>>();
		        List<Map<String,Object>> reserveList3 = new ArrayList<Map<String,Object>>();
		        List<Map<String,Object>> reserveList4 = new ArrayList<Map<String,Object>>();
		        List<Map<String,Object>> reserveList5 = new ArrayList<Map<String,Object>>();
		        
		        List<Map<String,Object>> reserveListDay1 = new ArrayList<Map<String,Object>>();
		        List<Map<String,Object>> reserveListDay2 = new ArrayList<Map<String,Object>>();
		        List<Map<String,Object>> reserveListDay3 = new ArrayList<Map<String,Object>>();
		        List<Map<String,Object>> reserveListDay4 = new ArrayList<Map<String,Object>>();
		        List<Map<String,Object>> reserveListDay5 = new ArrayList<Map<String,Object>>();
		        
		        for(int i=0; i<reserveList.size(); i++) {
		        	
		        	if(((String)reserveList.get(i).get("reserveDayCode")).trim().equals("1")) {
		        		reserveList1.add(reserveList.get(i));
		        	}else if(((String)reserveList.get(i).get("reserveDayCode")).trim().equals("2")) {
		        		reserveList2.add(reserveList.get(i));
		        	}else if(((String)reserveList.get(i).get("reserveDayCode")).trim().equals("3")) {
		        		reserveList3.add(reserveList.get(i));
		        	}else if(((String)reserveList.get(i).get("reserveDayCode")).trim().equals("4")) {
		        		reserveList4.add(reserveList.get(i));
		        	}else {
		        		reserveList5.add(reserveList.get(i));
		        	}
			
		        }
		        
		        for(int i=0; i<18; i++) {
		        	
		        	if(!reserveList1.isEmpty()) {
		        		Map<String,Object> map = new HashMap<String,Object>();
		        		for(int j=0; j<reserveList1.size();j++) {
		        		// startTimeCode 3 endTimeCode 6
		        			int startTimeCode = Integer.parseInt((String)reserveList1.get(j).get("startTimeCode"));
		            		int endTimeCode = Integer.parseInt((String)reserveList1.get(j).get("endTimeCode"));
		            		
		            		if(startTimeCode <= i+1 && startTimeCode <= i+2 && endTimeCode >= i+1 && endTimeCode >= i+2) {
		            			if(startTimeCode == i+1) {
		            				
		            				map.put("key", i);
		            				map.put("start", "yes");
		            				map.put("title", (String)reserveList1.get(j).get("title"));
		            				map.put("rmrNo", reserveList1.get(j).get("rmrNo"));
		            				map.put("deleteYN", (String)reserveList1.get(j).get("deleteYN"));
		            				map.put("regUserId", (String)reserveList1.get(j).get("regUserId"));
		            				map.put("regUserName", (String)reserveList1.get(j).get("regUserName"));
		            				map.put("notiYN", (String)reserveList1.get(j).get("notiYN"));
		            				map.put("reserveCode", (String)reserveList1.get(j).get("reserveCode"));
		            				map.put("pn",  (String)reserveList1.get(j).get("pn"));
		            				map.put("startTime", (String)reserveList1.get(j).get("startTime"));
		            				map.put("endTime", (String)reserveList1.get(j).get("endTime"));
		            				map.put("diffTime", (String)reserveList1.get(j).get("diffTime"));
		            				map.put("fileCnt",reserveList1.get(j).get("fileCnt"));
		            				
		            			}else {
		            				map.put("key", i);
		            				map.put("start", "include");
		            				map.put("title", (String)reserveList1.get(j).get("title"));
		            				map.put("rmrNo", reserveList1.get(j).get("rmrNo"));
		            				map.put("deleteYN", (String)reserveList1.get(j).get("deleteYN"));
		            				map.put("regUserId", (String)reserveList1.get(j).get("regUserId"));
		            				map.put("regUserName", (String)reserveList1.get(j).get("regUserName"));
		            				map.put("notiYN", (String)reserveList1.get(j).get("notiYN"));
		            				map.put("reserveCode", (String)reserveList1.get(j).get("reserveCode"));
		            				map.put("pn",  (String)reserveList1.get(j).get("pn"));
		            				map.put("startTime", (String)reserveList1.get(j).get("startTime"));
		            				map.put("endTime", (String)reserveList1.get(j).get("endTime"));
		            				map.put("diffTime", (String)reserveList1.get(j).get("diffTime"));
		            				map.put("fileCnt",reserveList1.get(j).get("fileCnt"));
		            			}
		            		}
		        		  		
		        		}
		        		
		        		reserveListDay1.add(map);
		        		
		        	}
		        
		        if(!reserveList2.isEmpty()) {
		        	Map<String,Object> map = new HashMap<String,Object>();
		        	for(int j=0; j<reserveList2.size();j++) {

		        			int startTimeCode = Integer.parseInt((String)reserveList2.get(j).get("startTimeCode"));
		            		int endTimeCode = Integer.parseInt((String)reserveList2.get(j).get("endTimeCode"));
		            		
		            		if(startTimeCode <= i+1 && startTimeCode <= i+2 && endTimeCode >= i+1 && endTimeCode >= i+2) {
		            				if(startTimeCode == i+1) {
		            				
		            				map.put("key", i);
		            				map.put("start", "yes");
		            				map.put("title", (String)reserveList2.get(j).get("title"));
		            				map.put("rmrNo", reserveList2.get(j).get("rmrNo"));
		            				map.put("deleteYN", (String)reserveList2.get(j).get("deleteYN"));
		            				map.put("regUserId", (String)reserveList2.get(j).get("regUserId"));
		            				map.put("regUserName", (String)reserveList2.get(j).get("regUserName"));
		            				map.put("notiYN", (String)reserveList2.get(j).get("notiYN"));
		            				map.put("reserveCode", (String)reserveList2.get(j).get("reserveCode"));
		            				map.put("pn",  (String)reserveList2.get(j).get("pn"));
		            				map.put("startTime", (String)reserveList2.get(j).get("startTime"));
		            				map.put("endTime", (String)reserveList2.get(j).get("endTime"));
		            				map.put("diffTime", (String)reserveList2.get(j).get("diffTime"));
		            				map.put("fileCnt",reserveList2.get(j).get("fileCnt"));
		            				
		            			}else {
		            				map.put("key", i);
		            				map.put("start", "include");
		            				map.put("title", (String)reserveList2.get(j).get("title"));
		            				map.put("rmrNo", reserveList2.get(j).get("rmrNo"));
		            				map.put("deleteYN", (String)reserveList2.get(j).get("deleteYN"));
		            				map.put("regUserId", (String)reserveList2.get(j).get("regUserId"));
		            				map.put("regUserName", (String)reserveList2.get(j).get("regUserName"));
		            				map.put("notiYN", (String)reserveList2.get(j).get("notiYN"));
		            				map.put("reserveCode", (String)reserveList2.get(j).get("reserveCode"));
		            				map.put("pn",  (String)reserveList2.get(j).get("pn"));
		            				map.put("startTime", (String)reserveList2.get(j).get("startTime"));
		            				map.put("endTime", (String)reserveList2.get(j).get("endTime"));
		            				map.put("diffTime", (String)reserveList2.get(j).get("diffTime"));
		            				map.put("fileCnt",reserveList2.get(j).get("fileCnt"));
		            			}
		            		}
		        		  		
		        	}
		        	reserveListDay2.add(map);
		        }
		        
		        if(!reserveList3.isEmpty()) {
		        	Map<String,Object> map = new HashMap<String,Object>();
		        	for(int j=0; j<reserveList3.size();j++) {

		        			int startTimeCode = Integer.parseInt((String)reserveList3.get(j).get("startTimeCode"));
		            		int endTimeCode = Integer.parseInt((String)reserveList3.get(j).get("endTimeCode"));
		            		
		            		if(startTimeCode <= i+1 && startTimeCode <= i+2 && endTimeCode >= i+1 && endTimeCode >= i+2) {
		            				if(startTimeCode == i+1) {
		            				
		            				map.put("key", i);
		            				map.put("start", "yes");
		            				map.put("title", (String)reserveList3.get(j).get("title"));
		            				map.put("rmrNo", reserveList3.get(j).get("rmrNo"));
		            				map.put("deleteYN", (String)reserveList3.get(j).get("deleteYN"));
		            				map.put("regUserId", (String)reserveList3.get(j).get("regUserId"));
		            				map.put("regUserName", (String)reserveList3.get(j).get("regUserName"));
		            				map.put("notiYN", (String)reserveList3.get(j).get("notiYN"));
		            				map.put("reserveCode", (String)reserveList3.get(j).get("reserveCode"));
		            				map.put("pn",  (String)reserveList3.get(j).get("pn"));
		            				map.put("startTime", (String)reserveList3.get(j).get("startTime"));
		            				map.put("endTime", (String)reserveList3.get(j).get("endTime"));
		            				map.put("diffTime", (String)reserveList3.get(j).get("diffTime"));
		            				map.put("fileCnt",reserveList3.get(j).get("fileCnt"));
		            				
		            			}else {
		            				map.put("key", i);
		            				map.put("start", "include");
		            				map.put("title", (String)reserveList3.get(j).get("title"));
		            				map.put("rmrNo", reserveList3.get(j).get("rmrNo"));
		            				map.put("deleteYN", (String)reserveList3.get(j).get("deleteYN"));
		            				map.put("regUserId", (String)reserveList3.get(j).get("regUserId"));
		            				map.put("regUserName", (String)reserveList3.get(j).get("regUserName"));
		            				map.put("notiYN", (String)reserveList3.get(j).get("notiYN"));
		            				map.put("reserveCode", (String)reserveList3.get(j).get("reserveCode"));
		            				map.put("pn",  (String)reserveList3.get(j).get("pn"));
		            				map.put("startTime", (String)reserveList3.get(j).get("startTime"));
		            				map.put("endTime", (String)reserveList3.get(j).get("endTime"));
		            				map.put("diffTime", (String)reserveList3.get(j).get("diffTime"));
		            				map.put("fileCnt",reserveList3.get(j).get("fileCnt"));
		            			}
		            		}
		        		  		
		        	}
		        	reserveListDay3.add(map);
		        }
		        
		        if(!reserveList4.isEmpty()) {
		        	Map<String,Object> map = new HashMap<String,Object>();
		        	for(int j=0; j<reserveList4.size();j++) {

		        			int startTimeCode = Integer.parseInt((String)reserveList4.get(j).get("startTimeCode"));
		            		int endTimeCode = Integer.parseInt((String)reserveList4.get(j).get("endTimeCode"));
		            		
		            		if(startTimeCode <= i+1 && startTimeCode <= i+2 && endTimeCode >= i+1 && endTimeCode >= i+2) {
		            				if(startTimeCode == i+1) {
		            				
		            				map.put("key", i);
		            				map.put("start", "yes");
		            				map.put("title", (String)reserveList4.get(j).get("title"));
		            				map.put("rmrNo", reserveList4.get(j).get("rmrNo"));
		            				map.put("deleteYN", (String)reserveList4.get(j).get("deleteYN"));
		            				map.put("regUserId", (String)reserveList4.get(j).get("regUserId"));
		            				map.put("regUserName", (String)reserveList4.get(j).get("regUserName"));
		            				map.put("notiYN", (String)reserveList4.get(j).get("notiYN"));
		            				map.put("reserveCode", (String)reserveList4.get(j).get("reserveCode"));
		            				map.put("pn",  (String)reserveList4.get(j).get("pn"));
		            				map.put("startTime", (String)reserveList4.get(j).get("startTime"));
		            				map.put("endTime", (String)reserveList4.get(j).get("endTime"));
		            				map.put("diffTime", (String)reserveList4.get(j).get("diffTime"));
		            				map.put("fileCnt",reserveList4.get(j).get("fileCnt"));
		            				
		            			}else {
		            				map.put("key", i);
		            				map.put("start", "include");
		            				map.put("title", (String)reserveList4.get(j).get("title"));
		            				map.put("rmrNo", reserveList4.get(j).get("rmrNo"));
		            				map.put("deleteYN", (String)reserveList4.get(j).get("deleteYN"));
		            				map.put("regUserId", (String)reserveList4.get(j).get("regUserId"));
		            				map.put("regUserName", (String)reserveList4.get(j).get("regUserName"));
		            				map.put("notiYN", (String)reserveList4.get(j).get("notiYN"));
		            				map.put("reserveCode", (String)reserveList4.get(j).get("reserveCode"));
		            				map.put("pn",  (String)reserveList4.get(j).get("pn"));
		            				map.put("startTime", (String)reserveList4.get(j).get("startTime"));
		            				map.put("endTime", (String)reserveList4.get(j).get("endTime"));
		            				map.put("diffTime", (String)reserveList4.get(j).get("diffTime"));
		            				map.put("fileCnt",reserveList4.get(j).get("fileCnt"));
		            			}
		            		}
		        		  		
		        	}
		        	reserveListDay4.add(map);
		        }
		        
		        if(!reserveList5.isEmpty()) {
		        	Map<String,Object> map = new HashMap<String,Object>();
		        	for(int j=0; j<reserveList5.size();j++) {

		        			int startTimeCode = Integer.parseInt((String)reserveList5.get(j).get("startTimeCode"));
		            		int endTimeCode = Integer.parseInt((String)reserveList5.get(j).get("endTimeCode"));
		            		
		            		if(startTimeCode <= i+1 && startTimeCode <= i+2 && endTimeCode >= i+1 && endTimeCode >= i+2) {
		            				if(startTimeCode == i+1) {
		            				
		            				map.put("key", i);
		            				map.put("start", "yes");
		            				map.put("title", (String)reserveList5.get(j).get("title"));
		            				map.put("rmrNo", reserveList5.get(j).get("rmrNo"));
		            				map.put("deleteYN", (String)reserveList5.get(j).get("deleteYN"));
		            				map.put("regUserId", (String)reserveList5.get(j).get("regUserId"));
		            				map.put("regUserName", (String)reserveList5.get(j).get("regUserName"));
		            				map.put("notiYN", (String)reserveList5.get(j).get("notiYN"));
		            				map.put("reserveCode", (String)reserveList5.get(j).get("reserveCode"));
		            				map.put("pn",  (String)reserveList5.get(j).get("pn"));
		            				map.put("startTime", (String)reserveList5.get(j).get("startTime"));
		            				map.put("endTime", (String)reserveList5.get(j).get("endTime"));
		            				map.put("diffTime", (String)reserveList5.get(j).get("diffTime"));
		            				map.put("fileCnt",reserveList5.get(j).get("fileCnt"));
		            				
		            			}else {
		            				map.put("key", i);
		            				map.put("start", "include");
		            				map.put("title", (String)reserveList5.get(j).get("title"));
		            				map.put("rmrNo", reserveList5.get(j).get("rmrNo"));
		            				map.put("deleteYN", (String)reserveList5.get(j).get("deleteYN"));
		            				map.put("regUserId", (String)reserveList5.get(j).get("regUserId"));
		            				map.put("regUserName", (String)reserveList5.get(j).get("regUserName"));
		            				map.put("notiYN", (String)reserveList5.get(j).get("notiYN"));
		            				map.put("reserveCode", (String)reserveList5.get(j).get("reserveCode"));
		            				map.put("pn",  (String)reserveList5.get(j).get("pn"));
		            				map.put("startTime", (String)reserveList5.get(j).get("startTime"));
		            				map.put("endTime", (String)reserveList5.get(j).get("endTime"));
		            				map.put("diffTime", (String)reserveList5.get(j).get("diffTime"));
		            				map.put("fileCnt",reserveList5.get(j).get("fileCnt"));
		            			}
		            		}
		        		  		
		        	}
		        	reserveListDay5.add(map);
		        }

		        	
		        }
		        
		        */
		        
		        
		        
//		        if((String)param.get("reserveCode") !=null && !((String)param.get("reserveCode")).equals("")) {
//		        	model.addAttribute("reserveCode",(String)param.get("reserveCode"));
//		        }else {
//		        	model.addAttribute("reserveCode","V");
//		        }
		        
		        model.addAttribute("loginUserId",AuthUtil.getAuth(request).getUserId());
				//model.addAttribute("reserveListDay1",reserveListDay1);
				//model.addAttribute("reserveListDay2",reserveListDay2);
				//model.addAttribute("reserveListDay3",reserveListDay3);
				//model.addAttribute("reserveListDay4",reserveListDay4);
				//model.addAttribute("reserveListDay5",reserveListDay5);
				//model.addAttribute("today",format.format(todayDate));
				model.addAttribute("monday",monday);
				model.addAttribute("tuesday",tuesday);
				model.addAttribute("wednesday",wednesday);
				model.addAttribute("thursday",thursday);
				model.addAttribute("friday",friday);
				model.addAttribute("selectDay",selectDay);
				model.addAttribute("timeCode",timeCode);
				model.addAttribute("selectDayParam",selectDayParam);
				model.addAttribute("weekParam",weekParam);
				
				
				return "/main/main";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}

	@SuppressWarnings("deprecation")
	@RequestMapping(value = {"/meeting"}, method = RequestMethod.GET)
	public String mainMeetingRoom(HttpServletRequest request, Model model,@RequestParam Map<String,Object> param) throws Exception {
		try {
			//Auth auth = AuthUtil.getAuth(request);
			
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
			
			Date todayDate = new Date();
			
			Calendar cal = Calendar.getInstance();
			
			String selectDayParam = (String)param.get("selectDay");
			
			String weekParam = (String)param.get("weekParam");
			
			int timeCode = Integer.valueOf(reserveService.selectTimeCode());
			
			int tYear = 0;
			int tMonth = 0;
			int tDate = 0;
			
			if(selectDayParam == null || selectDayParam.equals("")) {
					tYear = cal.get(cal.YEAR);
					tMonth = cal.get(cal.MONTH) + 1;
					tDate = cal.get(cal.DATE);
			} 
			else {
				tYear = Integer.parseInt(selectDayParam.split("-")[0]);
				tMonth = Integer.parseInt(selectDayParam.split("-")[1]); 
				tDate = Integer.parseInt(selectDayParam.split("-")[2]); 
			}
			
			if(weekParam !=null && !weekParam.equals("")) {
				if(weekParam.equals("P")) {
					cal.set(tYear, tMonth-1, tDate);
					cal.add(Calendar.DATE, -7);
				}else if(weekParam.equals("N")) {
					cal.set(tYear, tMonth-1, tDate);
					cal.add(Calendar.DATE, +7);
				}
			}
			else if(weekParam == null || weekParam.equals("")){
				 cal.set(tYear, tMonth-1, tDate);
			}
			
	        String selectDay = format.format(cal.getTime());
	        
	        cal.set(Calendar.DAY_OF_WEEK,Calendar.MONDAY);
	        String monday =  format.format(cal.getTime());
	        
	        cal.set(Calendar.DAY_OF_WEEK,Calendar.TUESDAY);
	        String tuesday =  format.format(cal.getTime());
			
	        cal.set(Calendar.DAY_OF_WEEK,Calendar.WEDNESDAY);
	        String wednesday =  format.format(cal.getTime());
	        
	        cal.set(Calendar.DAY_OF_WEEK,Calendar.THURSDAY);
	        String thursday =  format.format(cal.getTime());
	        
	        cal.set(Calendar.DAY_OF_WEEK,Calendar.FRIDAY);
	        String friday =  format.format(cal.getTime());
	        
	        param.put("monday", monday);
	        param.put("friday", friday);
	        
	        List<Map<String,Object>> reserveList = reserveService.reserveRoomList(param);
	        
	        List<Map<String,Object>> reserveList1 = new ArrayList<Map<String,Object>>();
	        List<Map<String,Object>> reserveList2 = new ArrayList<Map<String,Object>>();
	        List<Map<String,Object>> reserveList3 = new ArrayList<Map<String,Object>>();
	        List<Map<String,Object>> reserveList4 = new ArrayList<Map<String,Object>>();
	        List<Map<String,Object>> reserveList5 = new ArrayList<Map<String,Object>>();
	        
	        List<Map<String,Object>> reserveListDay1 = new ArrayList<Map<String,Object>>();
	        List<Map<String,Object>> reserveListDay2 = new ArrayList<Map<String,Object>>();
	        List<Map<String,Object>> reserveListDay3 = new ArrayList<Map<String,Object>>();
	        List<Map<String,Object>> reserveListDay4 = new ArrayList<Map<String,Object>>();
	        List<Map<String,Object>> reserveListDay5 = new ArrayList<Map<String,Object>>();
	        
	        for(int i=0; i<reserveList.size(); i++) {
	        	
	        	if(((String)reserveList.get(i).get("reserveDayCode")).trim().equals("1")) {
	        		reserveList1.add(reserveList.get(i));
	        	}else if(((String)reserveList.get(i).get("reserveDayCode")).trim().equals("2")) {
	        		reserveList2.add(reserveList.get(i));
	        	}else if(((String)reserveList.get(i).get("reserveDayCode")).trim().equals("3")) {
	        		reserveList3.add(reserveList.get(i));
	        	}else if(((String)reserveList.get(i).get("reserveDayCode")).trim().equals("4")) {
	        		reserveList4.add(reserveList.get(i));
	        	}else {
	        		reserveList5.add(reserveList.get(i));
	        	}
		
	        }
	        
	        for(int i=0; i<18; i++) {
	        	
	        	if(!reserveList1.isEmpty()) {
	        		Map<String,Object> map = new HashMap<String,Object>();
	        		for(int j=0; j<reserveList1.size();j++) {
	        		// startTimeCode 3 endTimeCode 6
	        			int startTimeCode = Integer.parseInt((String)reserveList1.get(j).get("startTimeCode"));
	            		int endTimeCode = Integer.parseInt((String)reserveList1.get(j).get("endTimeCode"));
	            		
	            		if(startTimeCode <= i+1 && startTimeCode <= i+2 && endTimeCode >= i+1 && endTimeCode >= i+2) {
	            			if(startTimeCode == i+1) {
	            				
	            				map.put("key", i);
	            				map.put("start", "yes");
	            				map.put("title", (String)reserveList1.get(j).get("title"));
	            				map.put("rmrNo", reserveList1.get(j).get("rmrNo"));
	            				map.put("deleteYN", (String)reserveList1.get(j).get("deleteYN"));
	            				map.put("regUserId", (String)reserveList1.get(j).get("regUserId"));
	            				map.put("regUserName", (String)reserveList1.get(j).get("regUserName"));
	            				map.put("notiYN", (String)reserveList1.get(j).get("notiYN"));
	            				map.put("reserveCode", (String)reserveList1.get(j).get("reserveCode"));
	            				map.put("pn",  (String)reserveList1.get(j).get("pn"));
	            				map.put("startTime", (String)reserveList1.get(j).get("startTime"));
	            				map.put("endTime", (String)reserveList1.get(j).get("endTime"));
	            				map.put("diffTime", (String)reserveList1.get(j).get("diffTime"));
	            				map.put("fileCnt",reserveList1.get(j).get("fileCnt"));
	            				
	            			}else {
	            				map.put("key", i);
	            				map.put("start", "include");
	            				map.put("title", (String)reserveList1.get(j).get("title"));
	            				map.put("rmrNo", reserveList1.get(j).get("rmrNo"));
	            				map.put("deleteYN", (String)reserveList1.get(j).get("deleteYN"));
	            				map.put("regUserId", (String)reserveList1.get(j).get("regUserId"));
	            				map.put("regUserName", (String)reserveList1.get(j).get("regUserName"));
	            				map.put("notiYN", (String)reserveList1.get(j).get("notiYN"));
	            				map.put("reserveCode", (String)reserveList1.get(j).get("reserveCode"));
	            				map.put("pn",  (String)reserveList1.get(j).get("pn"));
	            				map.put("startTime", (String)reserveList1.get(j).get("startTime"));
	            				map.put("endTime", (String)reserveList1.get(j).get("endTime"));
	            				map.put("diffTime", (String)reserveList1.get(j).get("diffTime"));
	            				map.put("fileCnt",reserveList1.get(j).get("fileCnt"));
	            			}
	            		}
	        		  		
	        		}
	        		
	        		reserveListDay1.add(map);
	        		
	        	}
	        
	        if(!reserveList2.isEmpty()) {
	        	Map<String,Object> map = new HashMap<String,Object>();
	        	for(int j=0; j<reserveList2.size();j++) {
	
	        			int startTimeCode = Integer.parseInt((String)reserveList2.get(j).get("startTimeCode"));
	            		int endTimeCode = Integer.parseInt((String)reserveList2.get(j).get("endTimeCode"));
	            		
	            		if(startTimeCode <= i+1 && startTimeCode <= i+2 && endTimeCode >= i+1 && endTimeCode >= i+2) {
	            				if(startTimeCode == i+1) {
	            				
	            				map.put("key", i);
	            				map.put("start", "yes");
	            				map.put("title", (String)reserveList2.get(j).get("title"));
	            				map.put("rmrNo", reserveList2.get(j).get("rmrNo"));
	            				map.put("deleteYN", (String)reserveList2.get(j).get("deleteYN"));
	            				map.put("regUserId", (String)reserveList2.get(j).get("regUserId"));
	            				map.put("regUserName", (String)reserveList2.get(j).get("regUserName"));
	            				map.put("notiYN", (String)reserveList2.get(j).get("notiYN"));
	            				map.put("reserveCode", (String)reserveList2.get(j).get("reserveCode"));
	            				map.put("pn",  (String)reserveList2.get(j).get("pn"));
	            				map.put("startTime", (String)reserveList2.get(j).get("startTime"));
	            				map.put("endTime", (String)reserveList2.get(j).get("endTime"));
	            				map.put("diffTime", (String)reserveList2.get(j).get("diffTime"));
	            				map.put("fileCnt",reserveList2.get(j).get("fileCnt"));
	            				
	            			}else {
	            				map.put("key", i);
	            				map.put("start", "include");
	            				map.put("title", (String)reserveList2.get(j).get("title"));
	            				map.put("rmrNo", reserveList2.get(j).get("rmrNo"));
	            				map.put("deleteYN", (String)reserveList2.get(j).get("deleteYN"));
	            				map.put("regUserId", (String)reserveList2.get(j).get("regUserId"));
	            				map.put("regUserName", (String)reserveList2.get(j).get("regUserName"));
	            				map.put("notiYN", (String)reserveList2.get(j).get("notiYN"));
	            				map.put("reserveCode", (String)reserveList2.get(j).get("reserveCode"));
	            				map.put("pn",  (String)reserveList2.get(j).get("pn"));
	            				map.put("startTime", (String)reserveList2.get(j).get("startTime"));
	            				map.put("endTime", (String)reserveList2.get(j).get("endTime"));
	            				map.put("diffTime", (String)reserveList2.get(j).get("diffTime"));
	            				map.put("fileCnt",reserveList2.get(j).get("fileCnt"));
	            			}
	            		}
	        		  		
	        	}
	        	reserveListDay2.add(map);
	        }
	        
	        if(!reserveList3.isEmpty()) {
	        	Map<String,Object> map = new HashMap<String,Object>();
	        	for(int j=0; j<reserveList3.size();j++) {
	
	        			int startTimeCode = Integer.parseInt((String)reserveList3.get(j).get("startTimeCode"));
	            		int endTimeCode = Integer.parseInt((String)reserveList3.get(j).get("endTimeCode"));
	            		
	            		if(startTimeCode <= i+1 && startTimeCode <= i+2 && endTimeCode >= i+1 && endTimeCode >= i+2) {
	            				if(startTimeCode == i+1) {
	            				
	            				map.put("key", i);
	            				map.put("start", "yes");
	            				map.put("title", (String)reserveList3.get(j).get("title"));
	            				map.put("rmrNo", reserveList3.get(j).get("rmrNo"));
	            				map.put("deleteYN", (String)reserveList3.get(j).get("deleteYN"));
	            				map.put("regUserId", (String)reserveList3.get(j).get("regUserId"));
	            				map.put("regUserName", (String)reserveList3.get(j).get("regUserName"));
	            				map.put("notiYN", (String)reserveList3.get(j).get("notiYN"));
	            				map.put("reserveCode", (String)reserveList3.get(j).get("reserveCode"));
	            				map.put("pn",  (String)reserveList3.get(j).get("pn"));
	            				map.put("startTime", (String)reserveList3.get(j).get("startTime"));
	            				map.put("endTime", (String)reserveList3.get(j).get("endTime"));
	            				map.put("diffTime", (String)reserveList3.get(j).get("diffTime"));
	            				map.put("fileCnt",reserveList3.get(j).get("fileCnt"));
	            				
	            			}else {
	            				map.put("key", i);
	            				map.put("start", "include");
	            				map.put("title", (String)reserveList3.get(j).get("title"));
	            				map.put("rmrNo", reserveList3.get(j).get("rmrNo"));
	            				map.put("deleteYN", (String)reserveList3.get(j).get("deleteYN"));
	            				map.put("regUserId", (String)reserveList3.get(j).get("regUserId"));
	            				map.put("regUserName", (String)reserveList3.get(j).get("regUserName"));
	            				map.put("notiYN", (String)reserveList3.get(j).get("notiYN"));
	            				map.put("reserveCode", (String)reserveList3.get(j).get("reserveCode"));
	            				map.put("pn",  (String)reserveList3.get(j).get("pn"));
	            				map.put("startTime", (String)reserveList3.get(j).get("startTime"));
	            				map.put("endTime", (String)reserveList3.get(j).get("endTime"));
	            				map.put("diffTime", (String)reserveList3.get(j).get("diffTime"));
	            				map.put("fileCnt",reserveList3.get(j).get("fileCnt"));
	            			}
	            		}
	        		  		
	        	}
	        	reserveListDay3.add(map);
	        }
	        
	        if(!reserveList4.isEmpty()) {
	        	Map<String,Object> map = new HashMap<String,Object>();
	        	for(int j=0; j<reserveList4.size();j++) {
	
	        			int startTimeCode = Integer.parseInt((String)reserveList4.get(j).get("startTimeCode"));
	            		int endTimeCode = Integer.parseInt((String)reserveList4.get(j).get("endTimeCode"));
	            		
	            		if(startTimeCode <= i+1 && startTimeCode <= i+2 && endTimeCode >= i+1 && endTimeCode >= i+2) {
	            				if(startTimeCode == i+1) {
	            				
	            				map.put("key", i);
	            				map.put("start", "yes");
	            				map.put("title", (String)reserveList4.get(j).get("title"));
	            				map.put("rmrNo", reserveList4.get(j).get("rmrNo"));
	            				map.put("deleteYN", (String)reserveList4.get(j).get("deleteYN"));
	            				map.put("regUserId", (String)reserveList4.get(j).get("regUserId"));
	            				map.put("regUserName", (String)reserveList4.get(j).get("regUserName"));
	            				map.put("notiYN", (String)reserveList4.get(j).get("notiYN"));
	            				map.put("reserveCode", (String)reserveList4.get(j).get("reserveCode"));
	            				map.put("pn",  (String)reserveList4.get(j).get("pn"));
	            				map.put("startTime", (String)reserveList4.get(j).get("startTime"));
	            				map.put("endTime", (String)reserveList4.get(j).get("endTime"));
	            				map.put("diffTime", (String)reserveList4.get(j).get("diffTime"));
	            				map.put("fileCnt",reserveList4.get(j).get("fileCnt"));
	            				
	            			}else {
	            				map.put("key", i);
	            				map.put("start", "include");
	            				map.put("title", (String)reserveList4.get(j).get("title"));
	            				map.put("rmrNo", reserveList4.get(j).get("rmrNo"));
	            				map.put("deleteYN", (String)reserveList4.get(j).get("deleteYN"));
	            				map.put("regUserId", (String)reserveList4.get(j).get("regUserId"));
	            				map.put("regUserName", (String)reserveList4.get(j).get("regUserName"));
	            				map.put("notiYN", (String)reserveList4.get(j).get("notiYN"));
	            				map.put("reserveCode", (String)reserveList4.get(j).get("reserveCode"));
	            				map.put("pn",  (String)reserveList4.get(j).get("pn"));
	            				map.put("startTime", (String)reserveList4.get(j).get("startTime"));
	            				map.put("endTime", (String)reserveList4.get(j).get("endTime"));
	            				map.put("diffTime", (String)reserveList4.get(j).get("diffTime"));
	            				map.put("fileCnt",reserveList4.get(j).get("fileCnt"));
	            			}
	            		}
	        		  		
	        	}
	        	reserveListDay4.add(map);
	        }
	        
	        if(!reserveList5.isEmpty()) {
	        	Map<String,Object> map = new HashMap<String,Object>();
	        	for(int j=0; j<reserveList5.size();j++) {
	
	        			int startTimeCode = Integer.parseInt((String)reserveList5.get(j).get("startTimeCode"));
	            		int endTimeCode = Integer.parseInt((String)reserveList5.get(j).get("endTimeCode"));
	            		
	            		if(startTimeCode <= i+1 && startTimeCode <= i+2 && endTimeCode >= i+1 && endTimeCode >= i+2) {
	            				if(startTimeCode == i+1) {
	            				
	            				map.put("key", i);
	            				map.put("start", "yes");
	            				map.put("title", (String)reserveList5.get(j).get("title"));
	            				map.put("rmrNo", reserveList5.get(j).get("rmrNo"));
	            				map.put("deleteYN", (String)reserveList5.get(j).get("deleteYN"));
	            				map.put("regUserId", (String)reserveList5.get(j).get("regUserId"));
	            				map.put("regUserName", (String)reserveList5.get(j).get("regUserName"));
	            				map.put("notiYN", (String)reserveList5.get(j).get("notiYN"));
	            				map.put("reserveCode", (String)reserveList5.get(j).get("reserveCode"));
	            				map.put("pn",  (String)reserveList5.get(j).get("pn"));
	            				map.put("startTime", (String)reserveList5.get(j).get("startTime"));
	            				map.put("endTime", (String)reserveList5.get(j).get("endTime"));
	            				map.put("diffTime", (String)reserveList5.get(j).get("diffTime"));
	            				map.put("fileCnt",reserveList5.get(j).get("fileCnt"));
	            				
	            			}else {
	            				map.put("key", i);
	            				map.put("start", "include");
	            				map.put("title", (String)reserveList5.get(j).get("title"));
	            				map.put("rmrNo", reserveList5.get(j).get("rmrNo"));
	            				map.put("deleteYN", (String)reserveList5.get(j).get("deleteYN"));
	            				map.put("regUserId", (String)reserveList5.get(j).get("regUserId"));
	            				map.put("regUserName", (String)reserveList5.get(j).get("regUserName"));
	            				map.put("notiYN", (String)reserveList5.get(j).get("notiYN"));
	            				map.put("reserveCode", (String)reserveList5.get(j).get("reserveCode"));
	            				map.put("pn",  (String)reserveList5.get(j).get("pn"));
	            				map.put("startTime", (String)reserveList5.get(j).get("startTime"));
	            				map.put("endTime", (String)reserveList5.get(j).get("endTime"));
	            				map.put("diffTime", (String)reserveList5.get(j).get("diffTime"));
	            				map.put("fileCnt",reserveList5.get(j).get("fileCnt"));
	            			}
	            		}
	        		  		
	        	}
	        	reserveListDay5.add(map);
	        }
	
	        	
	        }
	        
	        if((String)param.get("reserveCode") !=null && !((String)param.get("reserveCode")).equals("")) {
	        	model.addAttribute("reserveCode",(String)param.get("reserveCode"));
	        }else {
	        	model.addAttribute("reserveCode","V");
	        }
	        
	        model.addAttribute("loginUserId",AuthUtil.getAuth(request).getUserId());
			model.addAttribute("reserveListDay1",reserveListDay1);
			model.addAttribute("reserveListDay2",reserveListDay2);
			model.addAttribute("reserveListDay3",reserveListDay3);
			model.addAttribute("reserveListDay4",reserveListDay4);
			model.addAttribute("reserveListDay5",reserveListDay5);
			model.addAttribute("today",format.format(todayDate));
			model.addAttribute("monday",monday);
			model.addAttribute("tuesday",tuesday);
			model.addAttribute("wednesday",wednesday);
			model.addAttribute("thursday",thursday);
			model.addAttribute("friday",friday);
			model.addAttribute("selectDay",selectDay);
			model.addAttribute("timeCode",timeCode);
			
			return "/main/mainMeetingRoom";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping(value = "/docCountAjax")
	@ResponseBody
	public List<Map<String,Object>> docCountAjax(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			Auth auth = AuthUtil.getAuth(request);
			param.put("userId", auth.getUserId());
			param.put("deptCode", auth.getDeptCode());
			param.put("grade", auth.getUserGrade());
			return commonService.docCount(param);
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping(value = "/docStateCountAjax")
	@ResponseBody
	public Map<String,Object> docStateCountAjax(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			Auth auth = AuthUtil.getAuth(request);
			param.put("userId", auth.getUserId());
			param.put("deptCode", auth.getDeptCode());
			param.put("grade", auth.getUserGrade());
			List<Map<String,Object>> docStateCountList = commonService.docStateCount(param);
			int regCount = 0;	//제조공정 : 0 	디자인 의뢰서 : 0
			int compCount = 0;	//제조공정 : 1 	디자인 의뢰서 : 2
			int goCount = 0;	//제조공정 : 3		디자인 의뢰서 : 1
			int retCount = 0;	//제조공정 : 2		디자인 의뢰서 : 3
			int erpCompCount = 0;//제조공정 :4
			int erpErrCount = 0;//제조공정 : 5
			for( int i = 0 ; i < docStateCountList.size() ; i++ ) {
				Map<String,Object> docStateCount = docStateCountList.get(i);
				if( docStateCount.get("type") != null && "manufacturingDoc".equals(docStateCount.get("type").toString()) ) {
					if( docStateCount.get("state") != null && "0".equals(docStateCount.get("state").toString()) ) {
						regCount += Integer.parseInt(docStateCount.get("docCount").toString());
					} else if( docStateCount.get("state") != null && "1".equals(docStateCount.get("state").toString()) ) {
						compCount += Integer.parseInt(docStateCount.get("docCount").toString());
					} else if( docStateCount.get("state") != null && "2".equals(docStateCount.get("state").toString()) ) {
						retCount += Integer.parseInt(docStateCount.get("docCount").toString());
					} else if( docStateCount.get("state") != null && "3".equals(docStateCount.get("state").toString()) ) {
						goCount += Integer.parseInt(docStateCount.get("docCount").toString());
					} else if( docStateCount.get("state") != null && "4".equals(docStateCount.get("state").toString()) ) {
						erpCompCount += Integer.parseInt(docStateCount.get("docCount").toString());
					} else if( docStateCount.get("state") != null && "5".equals(docStateCount.get("state").toString()) ) {
						erpErrCount += Integer.parseInt(docStateCount.get("docCount").toString());
					}
				} else if( docStateCount.get("type") != null && "designDoc".equals(docStateCount.get("type").toString()) ) {
					if( docStateCount.get("state") != null && "0".equals(docStateCount.get("state").toString()) ) {
						regCount += Integer.parseInt(docStateCount.get("docCount").toString());
					} else if( docStateCount.get("state") != null && "1".equals(docStateCount.get("state").toString()) ) {
						goCount += Integer.parseInt(docStateCount.get("docCount").toString());
					} else if( docStateCount.get("state") != null && "2".equals(docStateCount.get("state").toString()) ) {
						compCount += Integer.parseInt(docStateCount.get("docCount").toString());
					} else if( docStateCount.get("state") != null && "3".equals(docStateCount.get("state").toString()) ) {
						retCount += Integer.parseInt(docStateCount.get("docCount").toString());
					} 
				}
			}
			Map<String,Object> retMap = new HashMap<String,Object>();
			retMap.put("regCount", regCount);
			retMap.put("compCount", compCount);
			retMap.put("goCount", goCount);
			retMap.put("retCount", retCount);
			retMap.put("erpCompCount", erpCompCount);
			retMap.put("erpErrCount", erpErrCount);
			return retMap;
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	
	
	@RequestMapping(value = { "/","/main2" }, method = RequestMethod.GET)
	public String main2(HttpServletRequest request, Model model,@RequestParam Map<String,Object> param) throws Exception {

		// 메인에서 로그인
		if (!AuthUtil.hasAuth(request)) {
			return "redirect:/user/login";
		}
		try {
		//Auth auth = AuthUtil.getAuth(request);
				//model.addAttribute("countDesignDoc",productDesgignService.countForProductDesignDoc(AuthUtil.getAuth(request).getUserId()));
				//model.addAttribute("countDevDoc",productDevService.countForDevDoc(AuthUtil.getAuth(request).getUserId()));
				//model.addAttribute("countDesignRequest",productDevService.countForDesignRequestDoc(AuthUtil.getAuth(request).getUserId()));
				//model.addAttribute("countManufacturingDoc",productDevService.countForManuFacturingProcessDoc(AuthUtil.getAuth(request).getUserId()));
				//model.addAttribute("countForState",labDataService.countForState(AuthUtil.getAuth(request).getUserId()));
				
				SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
				
				Date todayDate = new Date();
				
				Calendar cal = Calendar.getInstance();
				
				String selectDayParam = (String)param.get("selectDay");
				
				String weekParam = (String)param.get("weekParam");
				
				int timeCode = Integer.valueOf(reserveService.selectTimeCode());
				
				int tYear = 0;
				int tMonth = 0;
				int tDate = 0;
				
				if(selectDayParam == null || selectDayParam.equals("")) {
						tYear = cal.get(cal.YEAR);
						tMonth = cal.get(cal.MONTH) + 1;
						tDate = cal.get(cal.DATE);
				} 
				else {
					tYear = Integer.parseInt(selectDayParam.split("-")[0]);
					tMonth = Integer.parseInt(selectDayParam.split("-")[1]); 
					tDate = Integer.parseInt(selectDayParam.split("-")[2]); 
				}
				
				if(weekParam !=null && !weekParam.equals("")) {
					if(weekParam.equals("P")) {
						cal.set(tYear, tMonth-1, tDate);
						cal.add(Calendar.DATE, -7);
					}else if(weekParam.equals("N")) {
						cal.set(tYear, tMonth-1, tDate);
						cal.add(Calendar.DATE, +7);
					}
				}
				else if(weekParam == null || weekParam.equals("")){
					 cal.set(tYear, tMonth-1, tDate);
				}
				
		        String selectDay = format.format(cal.getTime());
		        
		        cal.set(Calendar.DAY_OF_WEEK,Calendar.MONDAY);
		        String monday =  format.format(cal.getTime());
		        
		        cal.set(Calendar.DAY_OF_WEEK,Calendar.TUESDAY);
		        String tuesday =  format.format(cal.getTime());
				
		        cal.set(Calendar.DAY_OF_WEEK,Calendar.WEDNESDAY);
		        String wednesday =  format.format(cal.getTime());
		        
		        cal.set(Calendar.DAY_OF_WEEK,Calendar.THURSDAY);
		        String thursday =  format.format(cal.getTime());
		        
		        cal.set(Calendar.DAY_OF_WEEK,Calendar.FRIDAY);
		        String friday =  format.format(cal.getTime());
		        
		        param.put("monday", monday);
		        param.put("friday", friday);
		        
		       /* List<Map<String,Object>> reserveList = reserveService.reserveRoomList(param);
		        
		        List<Map<String,Object>> reserveList1 = new ArrayList<Map<String,Object>>();
		        List<Map<String,Object>> reserveList2 = new ArrayList<Map<String,Object>>();
		        List<Map<String,Object>> reserveList3 = new ArrayList<Map<String,Object>>();
		        List<Map<String,Object>> reserveList4 = new ArrayList<Map<String,Object>>();
		        List<Map<String,Object>> reserveList5 = new ArrayList<Map<String,Object>>();
		        
		        List<Map<String,Object>> reserveListDay1 = new ArrayList<Map<String,Object>>();
		        List<Map<String,Object>> reserveListDay2 = new ArrayList<Map<String,Object>>();
		        List<Map<String,Object>> reserveListDay3 = new ArrayList<Map<String,Object>>();
		        List<Map<String,Object>> reserveListDay4 = new ArrayList<Map<String,Object>>();
		        List<Map<String,Object>> reserveListDay5 = new ArrayList<Map<String,Object>>();
		        
		        for(int i=0; i<reserveList.size(); i++) {
		        	
		        	if(((String)reserveList.get(i).get("reserveDayCode")).trim().equals("1")) {
		        		reserveList1.add(reserveList.get(i));
		        	}else if(((String)reserveList.get(i).get("reserveDayCode")).trim().equals("2")) {
		        		reserveList2.add(reserveList.get(i));
		        	}else if(((String)reserveList.get(i).get("reserveDayCode")).trim().equals("3")) {
		        		reserveList3.add(reserveList.get(i));
		        	}else if(((String)reserveList.get(i).get("reserveDayCode")).trim().equals("4")) {
		        		reserveList4.add(reserveList.get(i));
		        	}else {
		        		reserveList5.add(reserveList.get(i));
		        	}
			
		        }
		        
		        for(int i=0; i<18; i++) {
		        	
		        	if(!reserveList1.isEmpty()) {
		        		Map<String,Object> map = new HashMap<String,Object>();
		        		for(int j=0; j<reserveList1.size();j++) {
		        		// startTimeCode 3 endTimeCode 6
		        			int startTimeCode = Integer.parseInt((String)reserveList1.get(j).get("startTimeCode"));
		            		int endTimeCode = Integer.parseInt((String)reserveList1.get(j).get("endTimeCode"));
		            		
		            		if(startTimeCode <= i+1 && startTimeCode <= i+2 && endTimeCode >= i+1 && endTimeCode >= i+2) {
		            			if(startTimeCode == i+1) {
		            				
		            				map.put("key", i);
		            				map.put("start", "yes");
		            				map.put("title", (String)reserveList1.get(j).get("title"));
		            				map.put("rmrNo", reserveList1.get(j).get("rmrNo"));
		            				map.put("deleteYN", (String)reserveList1.get(j).get("deleteYN"));
		            				map.put("regUserId", (String)reserveList1.get(j).get("regUserId"));
		            				map.put("regUserName", (String)reserveList1.get(j).get("regUserName"));
		            				map.put("notiYN", (String)reserveList1.get(j).get("notiYN"));
		            				map.put("reserveCode", (String)reserveList1.get(j).get("reserveCode"));
		            				map.put("pn",  (String)reserveList1.get(j).get("pn"));
		            				map.put("startTime", (String)reserveList1.get(j).get("startTime"));
		            				map.put("endTime", (String)reserveList1.get(j).get("endTime"));
		            				map.put("diffTime", (String)reserveList1.get(j).get("diffTime"));
		            				map.put("fileCnt",reserveList1.get(j).get("fileCnt"));
		            				
		            			}else {
		            				map.put("key", i);
		            				map.put("start", "include");
		            				map.put("title", (String)reserveList1.get(j).get("title"));
		            				map.put("rmrNo", reserveList1.get(j).get("rmrNo"));
		            				map.put("deleteYN", (String)reserveList1.get(j).get("deleteYN"));
		            				map.put("regUserId", (String)reserveList1.get(j).get("regUserId"));
		            				map.put("regUserName", (String)reserveList1.get(j).get("regUserName"));
		            				map.put("notiYN", (String)reserveList1.get(j).get("notiYN"));
		            				map.put("reserveCode", (String)reserveList1.get(j).get("reserveCode"));
		            				map.put("pn",  (String)reserveList1.get(j).get("pn"));
		            				map.put("startTime", (String)reserveList1.get(j).get("startTime"));
		            				map.put("endTime", (String)reserveList1.get(j).get("endTime"));
		            				map.put("diffTime", (String)reserveList1.get(j).get("diffTime"));
		            				map.put("fileCnt",reserveList1.get(j).get("fileCnt"));
		            			}
		            		}
		        		  		
		        		}
		        		
		        		reserveListDay1.add(map);
		        		
		        	}
		        
		        if(!reserveList2.isEmpty()) {
		        	Map<String,Object> map = new HashMap<String,Object>();
		        	for(int j=0; j<reserveList2.size();j++) {

		        			int startTimeCode = Integer.parseInt((String)reserveList2.get(j).get("startTimeCode"));
		            		int endTimeCode = Integer.parseInt((String)reserveList2.get(j).get("endTimeCode"));
		            		
		            		if(startTimeCode <= i+1 && startTimeCode <= i+2 && endTimeCode >= i+1 && endTimeCode >= i+2) {
		            				if(startTimeCode == i+1) {
		            				
		            				map.put("key", i);
		            				map.put("start", "yes");
		            				map.put("title", (String)reserveList2.get(j).get("title"));
		            				map.put("rmrNo", reserveList2.get(j).get("rmrNo"));
		            				map.put("deleteYN", (String)reserveList2.get(j).get("deleteYN"));
		            				map.put("regUserId", (String)reserveList2.get(j).get("regUserId"));
		            				map.put("regUserName", (String)reserveList2.get(j).get("regUserName"));
		            				map.put("notiYN", (String)reserveList2.get(j).get("notiYN"));
		            				map.put("reserveCode", (String)reserveList2.get(j).get("reserveCode"));
		            				map.put("pn",  (String)reserveList2.get(j).get("pn"));
		            				map.put("startTime", (String)reserveList2.get(j).get("startTime"));
		            				map.put("endTime", (String)reserveList2.get(j).get("endTime"));
		            				map.put("diffTime", (String)reserveList2.get(j).get("diffTime"));
		            				map.put("fileCnt",reserveList2.get(j).get("fileCnt"));
		            				
		            			}else {
		            				map.put("key", i);
		            				map.put("start", "include");
		            				map.put("title", (String)reserveList2.get(j).get("title"));
		            				map.put("rmrNo", reserveList2.get(j).get("rmrNo"));
		            				map.put("deleteYN", (String)reserveList2.get(j).get("deleteYN"));
		            				map.put("regUserId", (String)reserveList2.get(j).get("regUserId"));
		            				map.put("regUserName", (String)reserveList2.get(j).get("regUserName"));
		            				map.put("notiYN", (String)reserveList2.get(j).get("notiYN"));
		            				map.put("reserveCode", (String)reserveList2.get(j).get("reserveCode"));
		            				map.put("pn",  (String)reserveList2.get(j).get("pn"));
		            				map.put("startTime", (String)reserveList2.get(j).get("startTime"));
		            				map.put("endTime", (String)reserveList2.get(j).get("endTime"));
		            				map.put("diffTime", (String)reserveList2.get(j).get("diffTime"));
		            				map.put("fileCnt",reserveList2.get(j).get("fileCnt"));
		            			}
		            		}
		        		  		
		        	}
		        	reserveListDay2.add(map);
		        }
		        
		        if(!reserveList3.isEmpty()) {
		        	Map<String,Object> map = new HashMap<String,Object>();
		        	for(int j=0; j<reserveList3.size();j++) {

		        			int startTimeCode = Integer.parseInt((String)reserveList3.get(j).get("startTimeCode"));
		            		int endTimeCode = Integer.parseInt((String)reserveList3.get(j).get("endTimeCode"));
		            		
		            		if(startTimeCode <= i+1 && startTimeCode <= i+2 && endTimeCode >= i+1 && endTimeCode >= i+2) {
		            				if(startTimeCode == i+1) {
		            				
		            				map.put("key", i);
		            				map.put("start", "yes");
		            				map.put("title", (String)reserveList3.get(j).get("title"));
		            				map.put("rmrNo", reserveList3.get(j).get("rmrNo"));
		            				map.put("deleteYN", (String)reserveList3.get(j).get("deleteYN"));
		            				map.put("regUserId", (String)reserveList3.get(j).get("regUserId"));
		            				map.put("regUserName", (String)reserveList3.get(j).get("regUserName"));
		            				map.put("notiYN", (String)reserveList3.get(j).get("notiYN"));
		            				map.put("reserveCode", (String)reserveList3.get(j).get("reserveCode"));
		            				map.put("pn",  (String)reserveList3.get(j).get("pn"));
		            				map.put("startTime", (String)reserveList3.get(j).get("startTime"));
		            				map.put("endTime", (String)reserveList3.get(j).get("endTime"));
		            				map.put("diffTime", (String)reserveList3.get(j).get("diffTime"));
		            				map.put("fileCnt",reserveList3.get(j).get("fileCnt"));
		            				
		            			}else {
		            				map.put("key", i);
		            				map.put("start", "include");
		            				map.put("title", (String)reserveList3.get(j).get("title"));
		            				map.put("rmrNo", reserveList3.get(j).get("rmrNo"));
		            				map.put("deleteYN", (String)reserveList3.get(j).get("deleteYN"));
		            				map.put("regUserId", (String)reserveList3.get(j).get("regUserId"));
		            				map.put("regUserName", (String)reserveList3.get(j).get("regUserName"));
		            				map.put("notiYN", (String)reserveList3.get(j).get("notiYN"));
		            				map.put("reserveCode", (String)reserveList3.get(j).get("reserveCode"));
		            				map.put("pn",  (String)reserveList3.get(j).get("pn"));
		            				map.put("startTime", (String)reserveList3.get(j).get("startTime"));
		            				map.put("endTime", (String)reserveList3.get(j).get("endTime"));
		            				map.put("diffTime", (String)reserveList3.get(j).get("diffTime"));
		            				map.put("fileCnt",reserveList3.get(j).get("fileCnt"));
		            			}
		            		}
		        		  		
		        	}
		        	reserveListDay3.add(map);
		        }
		        
		        if(!reserveList4.isEmpty()) {
		        	Map<String,Object> map = new HashMap<String,Object>();
		        	for(int j=0; j<reserveList4.size();j++) {

		        			int startTimeCode = Integer.parseInt((String)reserveList4.get(j).get("startTimeCode"));
		            		int endTimeCode = Integer.parseInt((String)reserveList4.get(j).get("endTimeCode"));
		            		
		            		if(startTimeCode <= i+1 && startTimeCode <= i+2 && endTimeCode >= i+1 && endTimeCode >= i+2) {
		            				if(startTimeCode == i+1) {
		            				
		            				map.put("key", i);
		            				map.put("start", "yes");
		            				map.put("title", (String)reserveList4.get(j).get("title"));
		            				map.put("rmrNo", reserveList4.get(j).get("rmrNo"));
		            				map.put("deleteYN", (String)reserveList4.get(j).get("deleteYN"));
		            				map.put("regUserId", (String)reserveList4.get(j).get("regUserId"));
		            				map.put("regUserName", (String)reserveList4.get(j).get("regUserName"));
		            				map.put("notiYN", (String)reserveList4.get(j).get("notiYN"));
		            				map.put("reserveCode", (String)reserveList4.get(j).get("reserveCode"));
		            				map.put("pn",  (String)reserveList4.get(j).get("pn"));
		            				map.put("startTime", (String)reserveList4.get(j).get("startTime"));
		            				map.put("endTime", (String)reserveList4.get(j).get("endTime"));
		            				map.put("diffTime", (String)reserveList4.get(j).get("diffTime"));
		            				map.put("fileCnt",reserveList4.get(j).get("fileCnt"));
		            				
		            			}else {
		            				map.put("key", i);
		            				map.put("start", "include");
		            				map.put("title", (String)reserveList4.get(j).get("title"));
		            				map.put("rmrNo", reserveList4.get(j).get("rmrNo"));
		            				map.put("deleteYN", (String)reserveList4.get(j).get("deleteYN"));
		            				map.put("regUserId", (String)reserveList4.get(j).get("regUserId"));
		            				map.put("regUserName", (String)reserveList4.get(j).get("regUserName"));
		            				map.put("notiYN", (String)reserveList4.get(j).get("notiYN"));
		            				map.put("reserveCode", (String)reserveList4.get(j).get("reserveCode"));
		            				map.put("pn",  (String)reserveList4.get(j).get("pn"));
		            				map.put("startTime", (String)reserveList4.get(j).get("startTime"));
		            				map.put("endTime", (String)reserveList4.get(j).get("endTime"));
		            				map.put("diffTime", (String)reserveList4.get(j).get("diffTime"));
		            				map.put("fileCnt",reserveList4.get(j).get("fileCnt"));
		            			}
		            		}
		        		  		
		        	}
		        	reserveListDay4.add(map);
		        }
		        
		        if(!reserveList5.isEmpty()) {
		        	Map<String,Object> map = new HashMap<String,Object>();
		        	for(int j=0; j<reserveList5.size();j++) {

		        			int startTimeCode = Integer.parseInt((String)reserveList5.get(j).get("startTimeCode"));
		            		int endTimeCode = Integer.parseInt((String)reserveList5.get(j).get("endTimeCode"));
		            		
		            		if(startTimeCode <= i+1 && startTimeCode <= i+2 && endTimeCode >= i+1 && endTimeCode >= i+2) {
		            				if(startTimeCode == i+1) {
		            				
		            				map.put("key", i);
		            				map.put("start", "yes");
		            				map.put("title", (String)reserveList5.get(j).get("title"));
		            				map.put("rmrNo", reserveList5.get(j).get("rmrNo"));
		            				map.put("deleteYN", (String)reserveList5.get(j).get("deleteYN"));
		            				map.put("regUserId", (String)reserveList5.get(j).get("regUserId"));
		            				map.put("regUserName", (String)reserveList5.get(j).get("regUserName"));
		            				map.put("notiYN", (String)reserveList5.get(j).get("notiYN"));
		            				map.put("reserveCode", (String)reserveList5.get(j).get("reserveCode"));
		            				map.put("pn",  (String)reserveList5.get(j).get("pn"));
		            				map.put("startTime", (String)reserveList5.get(j).get("startTime"));
		            				map.put("endTime", (String)reserveList5.get(j).get("endTime"));
		            				map.put("diffTime", (String)reserveList5.get(j).get("diffTime"));
		            				map.put("fileCnt",reserveList5.get(j).get("fileCnt"));
		            				
		            			}else {
		            				map.put("key", i);
		            				map.put("start", "include");
		            				map.put("title", (String)reserveList5.get(j).get("title"));
		            				map.put("rmrNo", reserveList5.get(j).get("rmrNo"));
		            				map.put("deleteYN", (String)reserveList5.get(j).get("deleteYN"));
		            				map.put("regUserId", (String)reserveList5.get(j).get("regUserId"));
		            				map.put("regUserName", (String)reserveList5.get(j).get("regUserName"));
		            				map.put("notiYN", (String)reserveList5.get(j).get("notiYN"));
		            				map.put("reserveCode", (String)reserveList5.get(j).get("reserveCode"));
		            				map.put("pn",  (String)reserveList5.get(j).get("pn"));
		            				map.put("startTime", (String)reserveList5.get(j).get("startTime"));
		            				map.put("endTime", (String)reserveList5.get(j).get("endTime"));
		            				map.put("diffTime", (String)reserveList5.get(j).get("diffTime"));
		            				map.put("fileCnt",reserveList5.get(j).get("fileCnt"));
		            			}
		            		}
		        		  		
		        	}
		        	reserveListDay5.add(map);
		        }

		        	
		        }
		        
		        */
		        
		        
		        
//		        if((String)param.get("reserveCode") !=null && !((String)param.get("reserveCode")).equals("")) {
//		        	model.addAttribute("reserveCode",(String)param.get("reserveCode"));
//		        }else {
//		        	model.addAttribute("reserveCode","V");
//		        }
		        
		        model.addAttribute("loginUserId",AuthUtil.getAuth(request).getUserId());
				//model.addAttribute("reserveListDay1",reserveListDay1);
				//model.addAttribute("reserveListDay2",reserveListDay2);
				//model.addAttribute("reserveListDay3",reserveListDay3);
				//model.addAttribute("reserveListDay4",reserveListDay4);
				//model.addAttribute("reserveListDay5",reserveListDay5);
				//model.addAttribute("today",format.format(todayDate));
				model.addAttribute("monday",monday);
				model.addAttribute("tuesday",tuesday);
				model.addAttribute("wednesday",wednesday);
				model.addAttribute("thursday",thursday);
				model.addAttribute("friday",friday);
				model.addAttribute("selectDay",selectDay);
				model.addAttribute("timeCode",timeCode);
				model.addAttribute("selectDayParam",selectDayParam);
				model.addAttribute("weekParam",weekParam);
				
				
				return "/main/main2";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping("/noticePopup")
    public String noticePopup(HttpServletRequest request, Model model,@RequestParam Map<String,Object> param) {
		Map<String,Object> notice = boardNoticeService.selectBoardNoticeData(param);
        model.addAttribute("notice", notice);
        return "main/noticePopup"; // → /WEB-INF/views/main2/noticePopup.jsp
    }
	
	
}
