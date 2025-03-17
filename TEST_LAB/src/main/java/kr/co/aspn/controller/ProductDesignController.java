package kr.co.aspn.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import kr.co.aspn.common.auth.Auth;
import kr.co.aspn.common.auth.AuthUtil;
import kr.co.aspn.service.LabDataService;
import kr.co.aspn.service.ProductDesignService;
import kr.co.aspn.util.StringUtil;
import kr.co.aspn.util.UserUtil;
import kr.co.aspn.vo.LabPagingObject;
import kr.co.aspn.vo.LabSearchVO;
import kr.co.aspn.vo.MfgProcessDoc;
import kr.co.aspn.vo.ProductDesignCreateVO;
import kr.co.aspn.vo.ProductDesignDocDetail;

@Controller
@RequestMapping("/design")
public class ProductDesignController {
	Logger logger = LoggerFactory.getLogger(ProductDesignController.class); 
	
	@Autowired
	ProductDesignService productDesignService;
	
	@Autowired
	LabDataService labDataService;
	
	@RequestMapping(value="/testCall", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String testCall(@RequestBody @ModelAttribute ProductDesignDocDetail vo) throws JsonProcessingException{
		System.out.println(vo.toString());
		/*
		ObjectMapper objMapper = new ObjectMapper();
		String jsonString = objMapper.writeValueAsString(vo);
		return jsonString;
		*/
		return "testCall()";
	}
	
	@RequestMapping("/getMaterialListPopup")
	public String getMaterialListPopup(ModelMap model, LabPagingObject page, LabSearchVO search, String parentRowId){
		model.addAttribute("parentRowId", parentRowId);
		model.addAttribute("materialList", labDataService.getMaterialListPopup(page, search));
		
		return "/productDesign/popup/productDesignMaterialPopup";
	}
	
	@RequestMapping(value="/getMaterialList", produces="application/text;charset=utf-8")
	@ResponseBody
	public String getMaterialList(ModelMap model, LabPagingObject page, LabSearchVO search, String parentRowId){
		logger.debug(search.toString());
		try {
			return  new ObjectMapper().writeValueAsString(labDataService.getMaterialListPopup(page, search));
		} catch (JsonProcessingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		}
	}
	
	@RequestMapping(value="/getDesingDocList", produces="application/text;charset=utf-8")
	@ResponseBody
	public String getDesingDocList(ModelMap model, LabPagingObject page, LabSearchVO search, String parentRowId){
		logger.debug(search.toString());
		try {
			return  new ObjectMapper().writeValueAsString(productDesignService.getProductDesignList(page, search));
		} catch (JsonProcessingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		}
	}
	
	
	@RequestMapping("/productDesignDocList")
	public String productDesignDocList(HttpSession session, ModelMap model, LabPagingObject page, LabSearchVO search
			, @RequestParam(value="groupCode", defaultValue="PRODCAT")String groupCode)  throws JsonProcessingException {
		// 제품설계서리스트
		Auth userInfo = (Auth)session.getAttribute("SESS_AUTH");
		search.setOwnerId(userInfo.getUserId());
		search.setDeptCode(userInfo.getDeptCode());
		search.setTeamCode(userInfo.getTeamCode());
		
		model.addAttribute("productDesignList", productDesignService.getProductDesignList(page, search));
		model.addAttribute("ownerType", search.getOwnerType());
		model.addAttribute("search", search);
		
		model.addAttribute("codeList", labDataService.getCodeList(groupCode));
		model.addAttribute("companyList", labDataService.getCompanyList());
		model.addAttribute("plantList", new ObjectMapper().writeValueAsString(labDataService.getPlantList()));
		
		return "/productDesign/productDesignDocList";
	}
	
	@RequestMapping(value="/saveProductDesignDoc", produces="application/text;charset=utf-8")
	@ResponseBody
	public String productDesignSave(ProductDesignCreateVO vo){
		return productDesignService.productDesignSave(vo);
	}
	
	@RequestMapping(value="/updateProductDesignDoc", produces="application/text;charset=utf-8")
	@ResponseBody
	public String updateProductDesignDoc(ProductDesignCreateVO vo){
		return productDesignService.updateProductDesignDoc(vo);
	}
	
	@RequestMapping(value="/deleteProductDesignDoc", produces="text/plain;charset=UTF-8", method = RequestMethod.POST)
	@ResponseBody
	public String deleteProductDesignDoc(String pNo, HttpSession session) {
		
		Auth userInfo = (Auth)session.getAttribute("SESS_AUTH");
		
		return productDesignService.deleteProductDesignDoc(pNo);
	}
	
	@RequestMapping("/productDesignDocDetail")
	public String productDesignDocDetail(HttpServletRequest request, HttpSession session
			, String pNo, ModelMap model, LabPagingObject page, LabSearchVO search
			, @RequestParam(value="groupCode", defaultValue="PRODCAT")String groupCode) throws JsonProcessingException{
		
		// pNo 없이 호출되는 경우가 있어 오류 발생하여 예외처리
		if(pNo == null){
			return null;
		}
		
		model.addAttribute("page", new ObjectMapper().writeValueAsString(page));
		model.addAttribute("search", new ObjectMapper().writeValueAsString(search));
		
		// 하위 품목리스트 with 제품설계서 데이터
		model.addAttribute("pNo", pNo);
		model.addAttribute("designDocInfo", productDesignService.getProductDesignDocInfo(pNo));
		model.addAttribute("productDesignItemList", productDesignService.getProductDesignItemList(page, pNo));
		
		model.addAttribute("codeList", labDataService.getCodeList(groupCode));
		model.addAttribute("companyList", labDataService.getCompanyList());
		model.addAttribute("plantCodeList", labDataService.getPlantList());
		model.addAttribute("plantList", new ObjectMapper().writeValueAsString(labDataService.getPlantList()));
		
		return "/productDesign/productDesignDocDetail";
	}
	
	@RequestMapping("/productDesignDocDetailView")
	public String productDesignDocDetailView(String pNo, String pdNo, ModelMap model){
		
		model.addAttribute("designDocInfo", productDesignService.getProductDesignDocInfo(pNo));
		model.addAttribute("designDocDetail", productDesignService.getProductDesignDocDetail(pdNo,""));
		
		return "/productDesign/productDesignDocDetailView";
	}
	
	@RequestMapping("/productDesignDocDetailCreate")
	public String productDesignDocDetailCreate(ModelMap model, String pNo, String pdNo, String productName) throws JsonProcessingException{
		
		model.addAttribute("pNo", pNo);
		model.addAttribute("pdNo", pdNo);
		model.addAttribute("productName", productName);
		
		model.addAttribute("designDocInfo", productDesignService.getProductDesignDocInfo(pNo));
		
		model.addAttribute("companyList", labDataService.getCompanyList());
		model.addAttribute("plantList", new ObjectMapper().writeValueAsString(labDataService.getPlantList()));
		
		return "/productDesign/productDesignDocDetailCreate";
	}
	
	@RequestMapping("/productDesignDocDetailEdit")
	public String productDesignDocDetailEdit(ModelMap model, String pNo, String pdNo, String productName){
		
		model.addAttribute("pNo", pNo);
		model.addAttribute("pdNo", pdNo);
		model.addAttribute("productName", productName);
		
		model.addAttribute("designDocInfo", productDesignService.getProductDesignDocInfo(pNo));
		model.addAttribute("designDocDetail", productDesignService.getProductDesignDocDetail(pdNo,""));
		
		
		return "/productDesign/productDesignDocDetailEdit";
	}
	/*
	@RequestMapping("/productDesignDocDetailEditForm")
	public String productDesignDocDetailEditForm(ModelMap model, String pNo, String pdNo){
		
		model.addAttribute("pNo", pNo);
		model.addAttribute("pdNo", pdNo);
		
		model.addAttribute("designDocInfo", productDesignService.getProductDesignDocInfo(pNo));
		model.addAttribute("designDocDetail", productDesignService.getProductDesignDocDetail(pdNo));
		
		return "/productDesign/productDesignDocDetailEditForm";
	}
	*/
	@RequestMapping(value="/saveProductDesignDocDetail", produces="text/plain;charset=UTF-8", consumes="multipart/form-data" , method = RequestMethod.POST)
	@ResponseBody
	public String saveProductDesignDocDetail(ProductDesignDocDetail vo, MultipartFile imageFile, HttpSession session) throws Exception {
		Auth userInfo = (Auth)session.getAttribute("SESS_AUTH");
		vo.setRegUserId(userInfo.getUserId());
		
		logger.debug("vo: " + vo.toString());
		
		return productDesignService.saveProductDesignDocDetail(vo, imageFile, true);
	}
	
	@RequestMapping(value="/updateProductDesignDocDetail", produces="text/plain;charset=UTF-8", consumes="multipart/form-data" , method = RequestMethod.POST)
	@ResponseBody
	public String updateProductDesignDocDetail(ProductDesignDocDetail vo, MultipartFile imageFile, HttpSession session) throws Exception {
		
		Auth userInfo = (Auth)session.getAttribute("SESS_AUTH");
		vo.setModUserId(userInfo.getUserId());
		
		logger.debug("vo: " + vo.toString());
		
		return productDesignService.saveProductDesignDocDetail(vo, imageFile, false);
	}	
	
	@RequestMapping(value="/editProductDesignDocDetail", produces="text/plain;charset=UTF-8", method = RequestMethod.POST)
	@ResponseBody
	public String editProductDesignDocDetail(@RequestBody @ModelAttribute ProductDesignDocDetail vo, HttpSession session) {
		
		Auth userInfo = (Auth)session.getAttribute("SESS_AUTH");
		vo.setModUserId(userInfo.getUserId());
		
		productDesignService.saveProductDesignDocDetail(vo, null, false);
		
		return vo.toString();
	}
	
	@RequestMapping(value="/copyProductDesignDocDetail", produces="text/plain;charset=UTF-8", method = RequestMethod.POST)
	@ResponseBody
	public String copyProductDesignDocDetail(String pNo, String pdNo, HttpSession session) {
		
		Auth userInfo = (Auth)session.getAttribute("SESS_AUTH");
		
		return productDesignService.copyProductDesignDocDetail(pNo, pdNo, userInfo.getUserId());
	}
	
	@RequestMapping(value="/deleteProductDesignDocDetail", produces="text/plain;charset=UTF-8", method = RequestMethod.POST)
	@ResponseBody
	public String deleteProductDesignDocDetail(String pNo, String pdNo, HttpSession session) {
		
		Auth userInfo = (Auth)session.getAttribute("SESS_AUTH");
		
		return productDesignService.deleteProductDesignDocDetail(pNo, pdNo);
	}
	
	
	private String toJSON(List<Map<String, Object>> list){
		ObjectMapper mapper = new ObjectMapper();
		try {
			return mapper.writeValueAsString(list);
		} catch (JsonProcessingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		}
	}
	
	@RequestMapping(value="/getDesignDocData", produces="text/plain;charset=UTF-8", method=RequestMethod.POST)
	@ResponseBody
	public String getDesignDocData(String pNo, String pdNo, String plantCode) throws JsonProcessingException{
      return new ObjectMapper().writeValueAsString(productDesignService.getProductDesignDocDetail(pdNo, plantCode));
   }
	
	@RequestMapping(value="/getProductDesingDocDetailListAjax")
	@ResponseBody
	public Map<String, Object> getProductDesingDocDetailListAjax(@RequestParam Map<String, Object> param) throws Exception{
		try {
			return productDesignService.getProductDesingDocDetailList(param);
		} catch (Exception e) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping(value="/getPagenatedPopupList", produces="text/plain;charset=UTF-8", method=RequestMethod.POST)
	@ResponseBody
	public String getPagenatedPopupList(LabPagingObject page, LabSearchVO search) throws JsonProcessingException{
		return new ObjectMapper().writeValueAsString(productDesignService.getPagenatedPopupList(page, search));
	}
	
	@RequestMapping(value="/getDesignDocSummaryList", produces="text/plain;charset=UTF-8", method=RequestMethod.POST)
	@ResponseBody
	public String getDesignDocSummaryList(HttpServletRequest request, String companyCode, String plantCode, String productName) throws Exception{
		Auth userInfo = AuthUtil.getAuth(request);
		
		return new ObjectMapper().writeValueAsString(productDesignService.getDesignDocSummaryList(userInfo, companyCode, plantCode, productName));
	}
	
	@RequestMapping(value="/getDesignDocDetailSummaryList", produces="text/plain;charset=UTF-8", method=RequestMethod.POST)
	@ResponseBody
	public String getDesignDocDetailSummaryList(String pNo) throws JsonProcessingException{
		
		if(true) {
			System.out.println("TEST");
		}
		
		return new ObjectMapper().writeValueAsString(productDesignService.getDesignDocDetailSummaryList(pNo));
	}
	
	@RequestMapping(value="/getLatestMaterialList", produces="text/plain;charset=UTF-8", method=RequestMethod.POST)
	@ResponseBody
	public String getLatestMaterialList(HttpServletRequest req) throws JsonProcessingException{
		String imNoArr[] = req.getParameterValues("imNoArr");
		return new ObjectMapper().writeValueAsString(productDesignService.getLatestMaterialList(imNoArr));
	}
	
	@RequestMapping("/txTest")
	@ResponseBody
	public String txTest(String value) throws Exception{
		return productDesignService.txTest(value);
	}
	
	@RequestMapping(value="productDesignDocDetailViewPopup")
	public String productDesignDocDetailPopup(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model ) throws Exception{
		param.put("userId", AuthUtil.getAuth(request).getUserId());
		param.put("type", "0");
		
		model.addAttribute("designDocInfo", productDesignService.getProductDesignDocInfo((String)param.get("pNo")));
		model.addAttribute("designDocDetail", productDesignService.getProductDesignDocDetail((String)param.get("pdNo"),""));
		
		model.addAttribute("paramVO", param);
		return "/productDesign/productDesignDocDetailViewPopup";
	}
	
	@RequestMapping(value="productDesignDocDetailApprPopup")
	public String productDesignDocDetailApprPopup(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model ) throws Exception{
		param.put("userId", AuthUtil.getAuth(request).getUserId());
		param.put("type", "0");
		
		model.addAttribute("designDocInfo", productDesignService.getProductDesignDocInfo((String)param.get("pNo")));
		model.addAttribute("designDocDetail", productDesignService.getProductDesignDocDetail((String)param.get("pdNo"),""));
		
		model.addAttribute("paramVO", param);
		return "/productDesign/productDesignDocDetailApprPopup";
	}
}