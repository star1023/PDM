package kr.co.aspn.controller;

import java.io.File;
import java.io.InputStream;
import java.net.URL;
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

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.sap.conn.jco.JCoDestination;
import com.sap.conn.jco.JCoFunction;

import kr.co.aspn.common.auth.Auth;
import kr.co.aspn.common.auth.AuthUtil;
import kr.co.aspn.common.jco.LabDestDataProvider;
import kr.co.aspn.common.jco.LabRfcManager;
import kr.co.aspn.dao.impl.BatchDaoImpl;
import kr.co.aspn.dao.impl.UserDaoImpl;
import kr.co.aspn.schedule.PclabSchedule;
import kr.co.aspn.schedule.SllabSchedule;
import kr.co.aspn.service.BatchService;
import kr.co.aspn.service.TestService;
import kr.co.aspn.service.impl.SendMailServiceImpl;
import kr.co.aspn.util.FileUtil;
import kr.co.aspn.vo.UserVO;

@Controller
@RequestMapping("/test")
public class TestController {
	/*private Logger logger = LoggerFactory.getLogger(TestController.class);
	
	@Autowired
	SllabSchedule sllabSchedule;
	
	@Autowired
	BatchService batchService;
	
	@Autowired
	UserDaoImpl userDao;
	
	@Autowired
	SendMailServiceImpl sendMailService; 
	
	@RequestMapping(value="/fileTest")
	public String fileTest( HttpServletResponse respose,HttpServletRequest request ) {
		System.err.println("call /test/fileTest1");
		System.err.println("call /test/fileTest2");
		System.err.println("call /test/fileTest3");
		return "/test/fileTest";
	}
	
	@RequestMapping(value="/chartTest")
	public String chartTest( HttpServletResponse respose,HttpServletRequest request ) {
		return "/test/chartTest";
	}
	
	@RequestMapping(value="/batchTest")
	public void batchTest( HttpServletResponse respose,HttpServletRequest request ) {
		try {
			sllabSchedule.masterData();
			//this.getStroage("SL");
			//this.line("SL");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public List<Map<String, String>> getStroage(String companyCode) throws Exception {
		// TODO Auto-generated method stub
		List<Map<String, String>> returnList = null;
		try {
			LabDestDataProvider provider = new LabDestDataProvider();
			logger.debug("companyCode {} "+companyCode);
			logger.debug("provider {} "+provider);
			JCoDestination dest = provider.getMyDestination(companyCode.toLowerCase());
			logger.debug("dest {} "+dest);
			logger.debug("dest.getDestinationName() {} "+dest.getDestinationName());
			LabRfcManager rfcManager = new LabRfcManager();
			logger.debug("rfcManager {} "+rfcManager);
			JCoFunction function = rfcManager.getFunction(dest.getDestinationName(), "ZMM_LGORT_RFC");
			
			HashMap<String, String> importParams = new HashMap<String, String>();
			
			HashMap<String, Object> rfcResult = rfcManager.execute(function,importParams);
			Map<String, List<Map<String, String>>> tableData = (Map<String, List<Map<String, String>>>)rfcResult.get("exportTableData");
			returnList = tableData.get("IT_LGORT");
		} catch( Exception e ) {
			e.printStackTrace();
		}
		return returnList;
	}
	
	public void line( String companyCode ) throws Exception{
		List<Map<String, String>> lineList = batchService.getLine(companyCode);
		int totalCount = 0;
		int count = 0;
		if( lineList != null ) {
			totalCount = lineList.size();
			for( int i = 0 ; i < lineList.size() ; i++ ) {
				Map<String, String> map = lineList.get(i);
				if( companyCode != null && "SN".equals(companyCode) && "8300".equals(map.get("WERKS")) ) {
					map.put("COMPANY", "EG");
				} else {
					map.put("COMPANY", companyCode);
				}

				int result = batchService.setLine(lineList.get(i));
				count += result;
			}
			System.err.println("companyCode  :  "+companyCode+"   lineList.size()  :  "+lineList.size()+"  count  :  "+count);
			Map<String, String> logMap = new HashMap<String, String>();
			logMap.put("companyCode", companyCode);
			logMap.put("batchType", "line");
			logMap.put("totalCount", ""+totalCount);
			logMap.put("successCount", ""+count);
			logMap.put("etcCount", "0");
			batchService.insertBatchLog(logMap);
		}
	}
	
	@RequestMapping("/sendMailTest")
	@ResponseBody
	public String sendMailTest() throws Exception {
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		List<UserVO> bomUserList = userDao.userListBom();
		
		if(bomUserList.size() > 0) {
			for(int i=0; i<bomUserList.size(); i++) {
				
				UserVO bomUserVO = new UserVO();
				bomUserVO.setUserId(bomUserList.get(i).getUserId());
				bomUserVO = userDao.selectUser(bomUserVO);
				
				if(bomUserVO.getMailCheck3()!=null || "Y".equals(bomUserVO.getMailCheck3())) {
					//param.put("title", "결재 완료 알림["+param.get("title")+"]");
					param.put("receiver_id", bomUserVO.getUserId());
					param.put("receiver", bomUserVO.getEmail());
					param.put("receiver_name", bomUserVO.getUserName());
					param.put("url", "http://slab.samlipgf.co.kr/ssoLoginC	heck?userId="+bomUserVO.getUserId()+"&callType=DEV&docNo=" + "docData.get(\"docNo\")" + "&docVersion=" + "docData.get(\"docVersion\")" + "&returnURL=/dev/productDevDocDetail");
					param.put("subTitle1", "제조공정서가 수정되었습니다.");
					param.put("dNo", "dNo");
					param.put("productName", "productName");
					param.put("mailTitle","["+"제조공정서 수정"+"] 알림 메일입니다.");
					param.put("modUserId", "modUserId");
					param.put("modDate", "modDate");
					
					//System.err.println("BOM 담당자 메일발송  : "+param);
					//sendMailService.sendMail(param);
					sendMailService.sendMfgCommentUpdateMail(param);
				}
				
			}
		}
		
		return "sendMail - TEST";
	}*/
	
	private Logger logger = LoggerFactory.getLogger(TestController.class);
	
	@Autowired
	TestService testService;

	@RequestMapping("/menuList")
	public String menuList(HttpServletRequest request, HttpServletResponse response, Model model , @RequestParam(required=false) Map<String, Object> param) throws Exception {
		return "/test/menuList";
	}
	
	@RequestMapping("/menuListAjax")
	@ResponseBody
	public Map<String, Object> menuListAjax(HttpServletRequest request, HttpServletResponse response, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		Map<String, Object> returnMap = testService.menuList(param);
		return returnMap;
	}
	
	@RequestMapping("/selectAllMenuList2Ajax")
	@ResponseBody
	public List<Map<String, Object>> selectAllMenuList2Ajax(HttpServletRequest request, HttpServletResponse response, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		List<Map<String, Object>> returnList = testService.selectAllMenuList2(param);
		return returnList;
	}
	
	@RequestMapping("/pMenuListAjax")
	@ResponseBody
	public List<Map<String, String>> pMenuListAjax(HttpServletRequest request, HttpServletResponse response, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		Auth auth = AuthUtil.getAuth(request);
		param.put("userId", auth.getUserId());
		List<Map<String, String>> returnList = testService.pMenuList(param);
		return returnList;
	}
	
	@RequestMapping("/insertMenuAjax")
	@ResponseBody
	public Map<String, String> insertMenuAjax(HttpServletRequest request, HttpServletResponse response, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		Map<String, String> returnMap = new HashMap<String,String>();
		try {
			Auth auth = AuthUtil.getAuth(request);
			param.put("userId", auth.getUserId());
			testService.insertMenu(param);
			returnMap.put("RESULT", "S");
		} catch( Exception e ) {
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}		
		return returnMap;
	}
	
	@RequestMapping("/insertMenu2Ajax")
	@ResponseBody
	public Map<String, String> insertMenu2Ajax(HttpServletRequest request, HttpServletResponse response, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		Map<String, String> returnMap = new HashMap<String,String>();
		try {
			Auth auth = AuthUtil.getAuth(request);
			param.put("userId", auth.getUserId());
			testService.insertMenu2(param);
			returnMap.put("RESULT", "S");
		} catch( Exception e ) {
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}		
		return returnMap;
	}
	
	@RequestMapping("/selectMenuDataAjax")
	@ResponseBody
	public Map<String, String> selectMenuDataAjax(HttpServletRequest request, HttpServletResponse response, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		Map<String, String> returnMap = testService.selectMenuData(param);
		return returnMap;
	}
	
	@RequestMapping("/updateMenuAjax")
	@ResponseBody
	public Map<String, String> updateMenuAjax(HttpServletRequest request, HttpServletResponse response, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		Map<String, String> returnMap = new HashMap<String,String>();
		try {
			Auth auth = AuthUtil.getAuth(request);
			param.put("userId", auth.getUserId());
			testService.updateMenu(param);
			returnMap.put("RESULT", "S");
		} catch( Exception e ) {
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}		
		return returnMap;
	}
	
	@RequestMapping("/deleteMenuAjax")
	@ResponseBody
	public Map<String, String> deleteMenuAjax(HttpServletRequest request, HttpServletResponse response, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		Map<String, String> returnMap = new HashMap<String,String>();
		try {
			Auth auth = AuthUtil.getAuth(request);
			param.put("userId", auth.getUserId());
			testService.deleteMenu(param);
			returnMap.put("RESULT", "S");
		} catch( Exception e ) {
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}		
		return returnMap;
	}
	
	@RequestMapping("/roleList")
	public String roleList(HttpServletRequest request, HttpServletResponse response, Model model , @RequestParam(required=false) Map<String, Object> param) throws Exception {
		return "/test/roleList";
	}
	
	@RequestMapping("/roleListAjax")
	@ResponseBody
	public Map<String, Object> roleListAjax(HttpServletRequest request, HttpServletResponse response, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		Map<String, Object> returnMap = testService.roleList(param);
		return returnMap;
	}
	
	@RequestMapping("/insertRoleAjax")
	@ResponseBody
	public Map<String, String> insertRoleAjax(HttpServletRequest request, HttpServletResponse response, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		Map<String, String> returnMap = new HashMap<String,String>();
		try {
			Map<String, String> roleData = testService.selectRoleData(param);
			System.err.println(roleData);
			if( roleData != null && roleData.get("ROLE_ID") != null && !"".equals(roleData.get("ROLE_ID")) ) {
				returnMap.put("RESULT", "F");
				returnMap.put("MESSAGE","동일한 권한이 등록되어있습니다.");
			} else {
				Auth auth = AuthUtil.getAuth(request);
				param.put("userId", auth.getUserId());
				testService.insertRole(param);
				returnMap.put("RESULT", "S");
			}
			
		} catch( Exception e ) {
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}		
		return returnMap;
	}
	
	@RequestMapping("/selectRoleDataAjax")
	@ResponseBody
	public Map<String, String> selectRoleDataAjax(HttpServletRequest request, HttpServletResponse response, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		Map<String, String> returnMap = testService.selectRoleData(param);
		return returnMap;
	}
	
	@RequestMapping("/updateRoleAjax")
	@ResponseBody
	public Map<String, String> updateRoleAjax(HttpServletRequest request, HttpServletResponse response, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		Map<String, String> returnMap = new HashMap<String,String>();
		try {
			Auth auth = AuthUtil.getAuth(request);
			param.put("userId", auth.getUserId());
			testService.updateRole(param);
			returnMap.put("RESULT", "S");
		} catch( Exception e ) {
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}		
		return returnMap;
	}
	
	@RequestMapping("/deleteRoleAjax")
	@ResponseBody
	public Map<String, String> deleteRoleAjax(HttpServletRequest request, HttpServletResponse response, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		Map<String, String> returnMap = new HashMap<String,String>();
		try {
			Auth auth = AuthUtil.getAuth(request);
			param.put("userId", auth.getUserId());
			testService.deleteRole(param);
			returnMap.put("RESULT", "S");
		} catch( Exception e ) {
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}		
		return returnMap;
	}
	
	@RequestMapping("/roleMenuList")
	public String roleMenuList(HttpServletRequest request, HttpServletResponse response, Model model , @RequestParam(required=false) Map<String, Object> param) throws Exception {
		return "/test/roleMenuList";
	}
	
	
	@RequestMapping("/selectAllMenuAjax")
	@ResponseBody
	public List<Map<String, String>> selectAllMenuAjax(HttpServletRequest request, HttpServletResponse response, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		List<Map<String, String>> returnMap = testService.selectAllMenu(param);
		return returnMap;
	}
	
	@RequestMapping("/selectRoleMenuListAjax")
	@ResponseBody
	public List<Map<String, String>> selectRoleMenuListAjax(HttpServletRequest request, HttpServletResponse response, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		List<Map<String, String>> returnMap = testService.selectRoleMenuList(param);
		return returnMap;
	}
	
	@RequestMapping("/updateRoleMenuAjax")
	@ResponseBody
	public Map<String, String> updateRoleMenuAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(value="selectedMenu") List<String> selectedMenu
			, @RequestParam(value = "selectedRoleIdx", required = false) String selectedRoleIdx) throws Exception {
		//List<Map<String, String>> returnMap = testService.selectRoleMenuList(param);
		//return returnMap;
		Map<String, String> returnMap = new HashMap<String,String>();
		try {
			Map<String, Object> param = new HashMap<String, Object>();
			Auth auth = AuthUtil.getAuth(request);
			param.put("userId", auth.getUserId());
			param.put("selectedMenu", selectedMenu);
			param.put("selectedRoleIdx", selectedRoleIdx);
			testService.updateRoleMenu(param);
			returnMap.put("RESULT", "S");
		} catch( Exception e ) {
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}
		return returnMap;
	}
	
	@RequestMapping("/categoryList")
	public String categoryList(HttpServletRequest request, HttpServletResponse response, Model model , @RequestParam(required=false) Map<String, Object> param) throws Exception {
		return "/test/categoryList";
	}
	
	@RequestMapping("/selectCategoryAjax")
	@ResponseBody
	public List<Map<String, Object>> selectCategoryAjax(HttpServletRequest request, HttpServletResponse response, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		List<Map<String, Object>> returnMap = testService.selectCategory(param);
		return returnMap;
	}
	
	@RequestMapping("/insertCategoryAjax")
	@ResponseBody
	public Map<String, String> insertCategoryAjax(HttpServletRequest request, HttpServletResponse response, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		Map<String, String> returnMap = new HashMap<String,String>();
		try {
			Auth auth = AuthUtil.getAuth(request);
			param.put("userId", auth.getUserId());
			testService.insertCategory(param);
			returnMap.put("RESULT", "S");
		} catch( Exception e ) {
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}
		return returnMap;
	}
	
	@RequestMapping("/deleteCategoryAjax")
	@ResponseBody
	public Map<String, String> deleteCategoryAjax(HttpServletRequest request, HttpServletResponse response, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		Map<String, String> returnMap = new HashMap<String,String>();
		try {
			testService.deleteCategory(param);
			returnMap.put("RESULT", "S");
		} catch( Exception e ) {
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}
		return returnMap;
	}
	
	@RequestMapping("/updateCategoryAjax")
	@ResponseBody
	public Map<String, String> updateCategoryAjax(HttpServletRequest request, HttpServletResponse response, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		Map<String, String> returnMap = new HashMap<String,String>();
		try {
			System.err.println(param);
			testService.updateCategory(param);
			returnMap.put("RESULT", "S");
		} catch( Exception e ) {
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}
		return returnMap;
	}
	
	@RequestMapping("/updateMoveCategoryAjax")
	@ResponseBody
	public Map<String, String> updateMoveCategoryAjax(HttpServletRequest request, HttpServletResponse response, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		Map<String, String> returnMap = new HashMap<String,String>();
		try {
			System.err.println(param);
			returnMap = testService.updateMoveCategory(param);
			//returnMap.put("RESULT", "S");
		} catch( Exception e ) {
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}
		return returnMap;
	}
	
	@RequestMapping("/materialList")
	public String materialList(HttpServletRequest request, HttpServletResponse response, Model model , @RequestParam(required=false) Map<String, Object> param) throws Exception {
		return "/test/materialList";
	}
	
	@RequestMapping("/selectMaterialListAjax")
	@ResponseBody
	public Map<String, Object> selectMaterialListAjax(HttpServletRequest request, HttpServletResponse response, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		Map<String, Object> returnMap = testService.selectMaterialList(param);
		return returnMap;
	}
	
	@RequestMapping("/categoryListAjax")
	@ResponseBody
	public List<Map<String, Object>> categoryListAjax(HttpServletRequest request, HttpServletResponse response, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		return testService.categoryList(param);
	}
	
	@RequestMapping("/selectMaterialDataCountAjax")
	@ResponseBody
	public Map<String, Object> selectMaterialDataCountAjax(HttpServletRequest request, HttpServletResponse response, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		Map<String, Object> returnMap = testService.selectMaterialDataCount(param);
		return returnMap;
	}
	
	@RequestMapping("/insertMaterialAjax")
	@ResponseBody
	public Map<String, String> insertMaterialAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param
			, @RequestParam(value = "materialType", required = false) List<String> materialType
			, @RequestParam(value = "fileType", required = false) List<String> fileType
			, @RequestParam(value = "fileTypeText", required = false) List<String> fileTypeText
			, @RequestParam(value = "docType", required = false) List<String> docType
			, @RequestParam(value = "docTypeText", required = false) List<String> docTypeText
			, @RequestParam(required=false) MultipartFile... file) throws Exception {
		Map<String, String> returnMap = new HashMap<String, String>();
		try {
			
			Calendar cal = Calendar.getInstance();
			SimpleDateFormat sdf = new SimpleDateFormat("yyMMdd");
			String selectCode = testService.selectmaterialCode();
			String matCode = "E"+sdf.format(cal.getTime())+""+selectCode;
			
			Auth auth = AuthUtil.getAuth(request);
			param.put("userId", auth.getUserId());
			param.put("matCode", matCode);
			System.err.println(param);
			System.err.println(fileType);
			System.err.println(fileTypeText);
			System.err.println(docType);
			System.err.println(docTypeText);
			testService.insertMaterial(param, materialType, fileType, fileTypeText, docType, docTypeText, file);
			returnMap.put("MATERIAL_CODE", matCode);
			returnMap.put("RESULT", "S");			
		} catch( Exception e ) {
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}
		return returnMap;
	}
	
	@RequestMapping("/selectMaterialDataAjax")
	@ResponseBody
	public Map<String, Object> selectMaterialDataAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		return testService.selectMaterialData(param);
	}
	
	@RequestMapping("/fileDownload")
	public void fileDownload(HttpServletRequest request, HttpServletResponse response, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		try{
			Map<String, String> fileInfo = testService.selectFileData(param);
			if( fileInfo != null && ( fileInfo.get("FILE_IDX") != null || !"".equals(fileInfo.get("FILE_IDX"))) ) {
				FileUtil.fileDownload3(fileInfo, response);	
			}
		} catch( Exception e ) {
			
		}
	}
	
	@RequestMapping("/pdfTest")
	@ResponseBody
	public String pdfTest(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param) throws Exception {
			String content = "";
			try {
				File file = new File("E:/develop/upload/material/202412"+File.separator+"66062d3d-3265-4879-8d40-d56be5089177_2차인증_매뉴얼(241126).pdf");
				PDDocument document;
				document = PDDocument.load(file);
				
				PDFTextStripper s = new PDFTextStripper();
				String extractText = s.getText(document);
				System.err.println(extractText);
				content = extractText.trim().replace(" ", "");
				System.err.println(content);
			} catch( Exception e ) {
				e.printStackTrace();	
			}
		return content;
	}
	
	@RequestMapping("/selectCategoryByPIdAjax")
	@ResponseBody
	public List<Map<String, String>> selectCategoryByPIdAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		return testService.selectCategoryByPId(param);
	}
	
	@RequestMapping("/deleteMaterialAjax")
	@ResponseBody
	public Map<String, String> deleteMaterialAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		Map<String, String> returnMap = new HashMap<String, String>();
		try {
			Auth auth = AuthUtil.getAuth(request);
			param.put("userId", auth.getUserId());			
			testService.deleteMaterial(param);
			returnMap.put("RESULT", "S");			
		} catch( Exception e ) {
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}
		return returnMap;
	}
	
	@RequestMapping("/insertForm")
	public String insertForm(HttpServletRequest request, HttpServletResponse response, Model model , @RequestParam(required=false) Map<String, Object> param) throws Exception {
		return "/test/insertForm";
	}
	
	@RequestMapping("/selectErpMaterialListAjax")
	@ResponseBody
	public Map<String, Object> selectErpMaterialListAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		System.err.println(param);
		return testService.selectErpMaterialList(param);
	}
	
	@RequestMapping("/selectErpMaterialDataAjax")
	@ResponseBody
	public Map<String, Object> selectErpMaterialDataAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		return testService.selectErpMaterialData(param);
	}
	
	@RequestMapping("/selectNewCodeAjax")
	@ResponseBody
	public String selectNewCodeAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat sdf = new SimpleDateFormat("yyMMdd");
		String selectCode = testService.selectmaterialCode();
		return sdf.format(cal.getTime())+""+selectCode;
	}
	
	@RequestMapping("/versionUpForm")
	public String versionUpForm(HttpServletRequest request, HttpServletResponse response, Model model , @RequestParam(required=false) Map<String, Object> param) throws Exception {
		model.addAttribute("param",param);
		model.addAttribute("materialData", testService.selectMaterialData(param));
		param.put("docType", "MAT");
		model.addAttribute("fileType", testService.selectFileType(param));
		return "/test/versionUpForm";
	}
	
	@RequestMapping("/insertNewVersionMaterialAjax")
	@ResponseBody
	public Map<String, String> insertNewVersionMaterialAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param
			, @RequestParam(value = "materialType", required = false) List<String> materialType
			, @RequestParam(value = "fileType", required = false) List<String> fileType
			, @RequestParam(value = "fileTypeText", required = false) List<String> fileTypeText
			, @RequestParam(value = "docType", required = false) List<String> docType
			, @RequestParam(value = "docTypeText", required = false) List<String> docTypeText
			, @RequestParam(required=false) MultipartFile... file) throws Exception {
		Map<String, String> returnMap = new HashMap<String, String>();
		try {
			Auth auth = AuthUtil.getAuth(request);
			param.put("userId", auth.getUserId());
			System.err.println(param);
			System.err.println(fileType);
			System.err.println(fileTypeText);
			System.err.println(docType);
			System.err.println(docTypeText);
			testService.insertNewVersionMaterial(param, materialType, fileType, fileTypeText, docType, docTypeText, file);
			returnMap.put("RESULT", "S");			
		} catch( Exception e ) {
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}
		return returnMap;
	}
	
	@RequestMapping("/selectHistoryAjax")
	@ResponseBody
	public List<Map<String, String>> selectHistoryAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		return testService.selectHistory(param);
	}
	
	@RequestMapping("/erpMaterialList")
	public String erpMaterialList(HttpServletRequest request, HttpServletResponse response, Model model , @RequestParam(required=false) Map<String, Object> param) throws Exception {
		return "/test/erpMaterialList";
	}
}
