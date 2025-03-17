package kr.co.aspn.controller;

import java.util.HashMap;
import java.util.List;
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

import com.fasterxml.jackson.databind.ObjectMapper;

import kr.co.aspn.common.auth.AuthUtil;
import kr.co.aspn.service.CommonService;
import kr.co.aspn.util.StringUtil;
import kr.co.aspn.vo.CodeItemVO;
import kr.co.aspn.vo.CompanyVO;
import kr.co.aspn.vo.PlantLineVO;
import kr.co.aspn.vo.PlantVO;
import kr.co.aspn.vo.StorageVO;
import kr.co.aspn.vo.UnitVO;

@Controller
@RequestMapping("/common")
public class CommonController {
	private Logger logger = LoggerFactory.getLogger(CommonController.class);
	
	@Autowired
	CommonService commonService;
	
	@RequestMapping(value = "/plantLineListAjax", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> plantLineListAjax(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			logger.debug("param  :  {}",param);
			Map<String,Object> map = new HashMap<String,Object>();
			System.out.println("param.get(companyCode) : "+param.get("companyCode"));
			System.out.println("param.get(plantCode) : "+param.get("plantCode"));
			List<PlantLineVO> plantLineList = commonService.getPlantLine(param);
			map.put("RESULT", plantLineList);
			return map;
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping(value = "/plantListAjax", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> getPlantListList(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			logger.debug("param  :  {}",param);
			Map<String,Object> map = new HashMap<String,Object>();
			System.out.println("param.get(companyCode) : "+param.get("companyCode"));
			List<PlantVO> plantList = commonService.getPlant(param);
			map.put("RESULT", plantList);
			return map;
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping(value = "/companyListAjax", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> getCompanyList(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			Map<String,Object> map = new HashMap<String,Object>();
			List<CompanyVO> companyList = commonService.getCompany();
			logger.debug("companyList  :  {}",companyList);
			map.put("RESULT", companyList);
			return map;
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	//groupCode
	@RequestMapping(value = "/codeListAjax", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> codeList(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			CodeItemVO codeItemVO = new CodeItemVO();
			codeItemVO.setGroupCode((String)param.get("groupCode"));		
			List<CodeItemVO> codeList = commonService.getCodeList(codeItemVO);
			logger.debug("codeList  :  {}",codeList);
			
			Map<String,Object> map = new HashMap<String,Object>();
			map.put("RESULT", codeList);
			return map;
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping(value = "/productTypeListAjax", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> productTypeList(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			CodeItemVO codeItemVO = new CodeItemVO();
			codeItemVO.setGroupCode((String)param.get("groupCode"));
			codeItemVO.setItemCode((String)param.get("codeValue"));
			List<CodeItemVO> codeList = commonService.getCodeList(codeItemVO);
			logger.debug("codeList  :  {}",codeList);
			
			Map<String,Object> map = new HashMap<String,Object>();
			map.put("RESULT", codeList);
			return map;
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping("/popupSearchUser")
	public String popupSearchUser(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			model.addAllAttributes(commonService.popupSearchUser(param));
			return "/common/popupSearchUser";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping(value = "/userListAjax", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> userListAjax(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			logger.debug("param  :  {}",param);
			Map<String,Object> map = commonService.userListAjax(param);
			return map;
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping(value = "/userListAjax2", method = RequestMethod.POST)
	@ResponseBody
	public String userListAjax2(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			ObjectMapper mapper = new ObjectMapper();
			String data = 	mapper.writeValueAsString(commonService.userListAjax2(param));
			System.err.println("data  :  "+data);
			return data;
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping(value = "/unitListAjax", method = RequestMethod.POST)
	@ResponseBody
	public List<UnitVO> unitListAjax(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			return commonService.getUnit();
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@ResponseBody
	@RequestMapping(value="/notificationCountAjax")
	public Map<String, Object> notificationCount(Model model, HttpServletRequest request ) {
		 Map<String, Object> map = new HashMap<String, Object>();
		try{
			Map<String, String> param = new HashMap<String, String>();
			param.put("userId", AuthUtil.getAuth(request).getUserId());			
			map.put("notiCount", commonService.notificationCount(param));
		}catch(Exception e){
			map.put("notiCount", "0");
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
		}
		return map;
	}
	
	@ResponseBody
	@RequestMapping(value="/notificationListAjax")
	public List<Map<String, Object>> notificationList(Model model, HttpServletRequest request ) throws Exception {
		try {
			Map<String, String> param = new HashMap<String, String>();
			param.put("userId", AuthUtil.getAuth(request).getUserId());			
			return commonService.notificationList(param);
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@ResponseBody
	@RequestMapping(value="/updateNotificationAjax")
	public Map<String, Object> updateNotification(@RequestParam String[] nId, HttpServletRequest request ) throws Exception {
		try {
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("nIds", nId);	
			return commonService.updateNotification(param);
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping("/insertNotification")
	public void insertNotification(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			param.put("targetUserId","seojw1");
			param.put("message","테스트 알림입니다. 이 형식으로 데이터를 넣어주세요.");
			param.put("regUserId","admin");
			param.put("isRead","N");
			param.put("type","BOM등록알림");
			commonService.insertNotification(param);
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@ResponseBody
	@RequestMapping(value="/insertPrintLogAjax")
	public Map<String, Object> insertPrintLogAjax(@RequestParam Map<String, Object> param, HttpServletRequest request ) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		try{
			param.put("userId", AuthUtil.getAuth(request).getUserId());	
			commonService.insertPrintLog(param);		
			map.put("status", "success");
		}catch(Exception e){
			map.put("status", "error");
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
		}
		return map;
	}
	
	@RequestMapping(value = "/storageListAjax", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> storageListAjax(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			logger.debug("param  :  {}",param);
			Map<String,Object> map = new HashMap<String,Object>();
			System.out.println("param.get(companyCode) : "+param.get("companyCode"));
			System.out.println("param.get(plantCode) : "+param.get("plantCode"));
			List<StorageVO> storageList = commonService.getStorageList(param);
			map.put("RESULT", storageList);
			return map;
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
}
