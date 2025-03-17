package kr.co.aspn.controller;

import java.awt.image.BufferedImage;
import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.rendering.ImageType;
import org.apache.pdfbox.rendering.PDFRenderer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import kr.co.aspn.common.auth.Auth;
import kr.co.aspn.common.auth.AuthUtil;
import kr.co.aspn.service.MenuService;
import kr.co.aspn.util.StringUtil;

@Controller
@RequestMapping("/menu")
public class MenuController {
	private Logger logger = LoggerFactory.getLogger(MenuController.class);
	
	@Autowired
	MenuService menuService;
	
	@RequestMapping(value = "/productList")
	public String productList( HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param ) throws Exception{
		try {
			logger.debug("param : {} ",param.toString());
			return "/menu/productList";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping("/selectProductListAjax")
	@ResponseBody
	public Map<String, Object> selectProductListAjax(HttpServletRequest request, HttpServletResponse response, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		Map<String, Object> returnMap = menuService.selectProductList(param);
		return returnMap;
	}
	
	@RequestMapping(value = "/productInsert")
	public String compInsert( HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param ) throws Exception{
		try {
			logger.debug("param : {} ",param.toString());
			return "/menu/productInsert";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping("/productView")
	public String productView(HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param, ModelMap model) throws Exception{
		//lab_product 테이블 조회, lab_file 테이블 조회
		Map<String, Object> productData = menuService.selectProductData(param);
		model.addAttribute("productData", productData);
		//lab_product_materisl 테이블 조회
		model.addAttribute("productMaterialData", menuService.selectProductMaterial(param));
		
		return "/menu/productView";
	}
	
	@RequestMapping(value = "/improveList")
	public String improveList( HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param ){
		
		return "";
	}
	
	@RequestMapping("/selectNewCodeAjax")
	@ResponseBody
	public String selectNewCodeAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat sdf = new SimpleDateFormat("yyMMdd");
		String selectCode = menuService.selectProductCode();
		return sdf.format(cal.getTime())+""+selectCode;
	}
	
	@RequestMapping("/checkMaterialAjax")
	@ResponseBody
	public List<Map<String, String>> checkMaterialAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		return menuService.checkMaterial(param);
	}
	
	@RequestMapping("/checkErpMaterialAjax")
	@ResponseBody
	public List<Map<String, String>> checkErpMaterialAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		return menuService.checkErpMaterial(param);
	}
	
	@RequestMapping("/selectMaterialAjax")
	@ResponseBody
	public Map<String, Object> selectMaterialListAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		System.err.println(param);
		return menuService.selectMaterialList(param);
	}
	
	@RequestMapping("/selectProductCountAjax")
	@ResponseBody
	public Map<String, Object> selectProductCountAjax(HttpServletRequest request, HttpServletResponse response, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		Map<String, Object> returnMap = menuService.selectProductDataCount(param);
		return returnMap;
	}
	
	@RequestMapping("/insertProductAjax")
	@ResponseBody
	public Map<String, String> insertProductAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param
			, @RequestParam(value = "productType", required = false) List<String> productType
			, @RequestParam(value = "fileType", required = false) List<String> fileType
			, @RequestParam(value = "fileTypeText", required = false) List<String> fileTypeText
			, @RequestParam(value = "docType", required = false) List<String> docType
			, @RequestParam(value = "docTypeText", required = false) List<String> docTypeText
			, @RequestParam(value = "tempFile", required = false) List<String> tempFile
			, @RequestParam(value = "rowIdArr", required = false) List<String> rowIdArr
			, @RequestParam(value = "itemTypeArr", required = false) List<String> itemTypeArr
			, @RequestParam(value = "itemMatIdxArr", required = false) List<String> itemMatIdxArr
			, @RequestParam(value = "itemSapCodeArr", required = false) List<String> itemSapCodeArr
			, @RequestParam(value = "itemNameArr", required = false) List<String> itemNameArr
			, @RequestParam(value = "itemStandardArr", required = false) List<String> itemStandardArr
			, @RequestParam(value = "itemKeepExpArr", required = false) List<String> itemKeepExpArr
			, @RequestParam(value = "itemUnitPriceArr", required = false) List<String> itemUnitPriceArr
			, @RequestParam(value = "itemDescArr", required = false) List<String> itemDescArr
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
			Collections.reverse(productType);
			System.err.println(productType);
			System.err.println(tempFile);
			System.err.println(rowIdArr);
			System.err.println(itemMatIdxArr);
			System.err.println(itemSapCodeArr);
			System.err.println(itemNameArr);
			System.err.println(itemStandardArr);
			System.err.println(itemKeepExpArr);
			System.err.println(itemUnitPriceArr);
			System.err.println(itemDescArr);
			System.err.println(file);
			HashMap<String, Object> listMap = new HashMap<String, Object>();
			listMap.put("productType", productType);
			listMap.put("fileType", fileType);
			listMap.put("fileTypeText", fileTypeText);
			listMap.put("docType", docType);
			listMap.put("docTypeText", docTypeText);
			listMap.put("tempFile", tempFile);
			listMap.put("rowIdArr", rowIdArr);
			listMap.put("itemTypeArr", itemTypeArr);
			listMap.put("itemMatIdxArr", itemMatIdxArr);
			listMap.put("itemSapCodeArr", itemSapCodeArr);
			listMap.put("itemNameArr", itemNameArr);
			listMap.put("itemStandardArr", itemStandardArr);
			listMap.put("itemKeepExpArr", itemKeepExpArr);
			listMap.put("itemUnitPriceArr", itemUnitPriceArr);
			listMap.put("itemDescArr", itemDescArr);
			menuService.insertProduct(param, listMap, file);
			returnMap.put("RESULT", "S");			
		} catch( Exception e ) {
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}
		return returnMap;
	}
	
	@RequestMapping(value = "/versionUpProductForm")
	public String versionUpProductForm( HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param, ModelMap model ) throws Exception{
		try {
			logger.debug("param : {} ",param.toString());
			Map<String, Object> productData = menuService.selectProductData(param);
			model.addAttribute("productData", productData);
			//Map<String, String> data = (Map<String, String>)productData.get("data");
			//lab_product_materisl 테이블 조회
			//if( data.get("IS_NEW_MATERIAL") != null && "Y".equals(data.get("IS_NEW_MATERIAL")) ) {
				model.addAttribute("productMaterialData", menuService.selectProductMaterial(param));
			//}
			return "/menu/versionUpProductForm";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping("/selectHistoryAjax")
	@ResponseBody
	public List<Map<String, String>> selectHistoryAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		return menuService.selectHistory(param);
	}
	
	@RequestMapping("/insertNewVersionCheckAjax")
	@ResponseBody
	public Map<String, Object> insertNewVersionCheckAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();
		returnMap.put("RESULT", menuService.insertNewVersionCheck(param));
		return returnMap;
	}
	
	@RequestMapping("/insertNewVersionProductAjax")
	@ResponseBody
	public Map<String, String> insertNewVersionProductAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param
			, @RequestParam(value = "productType", required = false) List<String> productType
			, @RequestParam(value = "fileType", required = false) List<String> fileType
			, @RequestParam(value = "fileTypeText", required = false) List<String> fileTypeText
			, @RequestParam(value = "docType", required = false) List<String> docType
			, @RequestParam(value = "docTypeText", required = false) List<String> docTypeText
			, @RequestParam(value = "rowIdArr", required = false) List<String> rowIdArr
			, @RequestParam(value = "itemTypeArr", required = false) List<String> itemTypeArr
			, @RequestParam(value = "itemMatIdxArr", required = false) List<String> itemMatIdxArr
			, @RequestParam(value = "itemSapCodeArr", required = false) List<String> itemSapCodeArr
			, @RequestParam(value = "itemNameArr", required = false) List<String> itemNameArr
			, @RequestParam(value = "itemStandardArr", required = false) List<String> itemStandardArr
			, @RequestParam(value = "itemKeepExpArr", required = false) List<String> itemKeepExpArr
			, @RequestParam(value = "itemUnitPriceArr", required = false) List<String> itemUnitPriceArr
			, @RequestParam(value = "itemDescArr", required = false) List<String> itemDescArr
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
			Collections.reverse(productType);
			System.err.println(productType);
			System.err.println(rowIdArr);
			System.err.println(itemTypeArr);
			System.err.println(itemMatIdxArr);
			System.err.println(itemSapCodeArr);
			System.err.println(itemNameArr);
			System.err.println(itemStandardArr);
			System.err.println(itemKeepExpArr);
			System.err.println(itemUnitPriceArr);
			System.err.println(itemDescArr);
			System.err.println(file);
			HashMap<String, Object> listMap = new HashMap<String, Object>();
			listMap.put("productType", productType);
			listMap.put("fileType", fileType);
			listMap.put("fileTypeText", fileTypeText);
			listMap.put("docType", docType);
			listMap.put("docTypeText", docTypeText);
			listMap.put("rowIdArr", rowIdArr);
			listMap.put("itemTypeArr", itemTypeArr);
			listMap.put("itemMatIdxArr", itemMatIdxArr);
			listMap.put("itemSapCodeArr", itemSapCodeArr);
			listMap.put("itemNameArr", itemNameArr);
			listMap.put("itemStandardArr", itemStandardArr);
			listMap.put("itemKeepExpArr", itemKeepExpArr);
			listMap.put("itemUnitPriceArr", itemUnitPriceArr);
			listMap.put("itemDescArr", itemDescArr);
			menuService.insertNewVersionProduct(param, listMap, file);
			returnMap.put("RESULT", "S");			
		} catch( Exception e ) {
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}
		return returnMap;
	}
	
	
	@RequestMapping(value = "/menuList")
	public String menuList( HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param ) throws Exception{
		try {
			logger.debug("param : {} ",param.toString());
			return "/menu/menuList";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping("/selectMenuListAjax")
	@ResponseBody
	public Map<String, Object> selectMenuListAjax(HttpServletRequest request, HttpServletResponse response, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		Map<String, Object> returnMap = menuService.selectMenuList(param);
		return returnMap;
	}
	
	@RequestMapping(value = "/menuInsert")
	public String menuInsert( HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param ) throws Exception{
		try {
			logger.debug("param : {} ",param.toString());
			return "/menu/menuInsert";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping("/selectMenuDataCountAjax")
	@ResponseBody
	public Map<String, Object> selectMenuDataCountAjax(HttpServletRequest request, HttpServletResponse response, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		Map<String, Object> returnMap = menuService.selectMenuDataCount(param);
		return returnMap;
	}
	
	@RequestMapping("/insertMenuAjax")
	@ResponseBody
	public Map<String, String> insertMenuAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param
			, @RequestParam(value = "menuType", required = false) List<String> menuType
			, @RequestParam(value = "fileType", required = false) List<String> fileType
			, @RequestParam(value = "fileTypeText", required = false) List<String> fileTypeText
			, @RequestParam(value = "docType", required = false) List<String> docType
			, @RequestParam(value = "docTypeText", required = false) List<String> docTypeText
			, @RequestParam(value = "rowIdArr", required = false) List<String> rowIdArr
			, @RequestParam(value = "itemMatIdxArr", required = false) List<String> itemMatIdxArr
			, @RequestParam(value = "itemSapCodeArr", required = false) List<String> itemSapCodeArr
			, @RequestParam(value = "itemNameArr", required = false) List<String> itemNameArr
			, @RequestParam(value = "itemStandardArr", required = false) List<String> itemStandardArr
			, @RequestParam(value = "itemKeepExpArr", required = false) List<String> itemKeepExpArr
			, @RequestParam(value = "itemUnitPriceArr", required = false) List<String> itemUnitPriceArr
			, @RequestParam(value = "itemDescArr", required = false) List<String> itemDescArr
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
			Collections.reverse(menuType);
			System.err.println(menuType);
			System.err.println(rowIdArr);
			System.err.println(itemMatIdxArr);
			System.err.println(itemSapCodeArr);
			System.err.println(itemNameArr);
			System.err.println(itemStandardArr);
			System.err.println(itemKeepExpArr);
			System.err.println(itemUnitPriceArr);
			System.err.println(itemDescArr);
			System.err.println(file);
			HashMap<String, Object> listMap = new HashMap<String, Object>();
			listMap.put("menuType", menuType);
			listMap.put("fileType", fileType);
			listMap.put("fileTypeText", fileTypeText);
			listMap.put("docType", docType);
			listMap.put("docTypeText", docTypeText);
			listMap.put("rowIdArr", rowIdArr);
			listMap.put("itemMatIdxArr", itemMatIdxArr);
			listMap.put("itemSapCodeArr", itemSapCodeArr);
			listMap.put("itemNameArr", itemNameArr);
			listMap.put("itemStandardArr", itemStandardArr);
			listMap.put("itemKeepExpArr", itemKeepExpArr);
			listMap.put("itemUnitPriceArr", itemUnitPriceArr);
			listMap.put("itemDescArr", itemDescArr);
			menuService.insertMenu(param, listMap, file);
			returnMap.put("RESULT", "S");			
		} catch( Exception e ) {
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}
		return returnMap;
	}
	
	@RequestMapping("/selectMenuHistoryAjax")
	@ResponseBody
	public List<Map<String, String>> selectMenuHistoryAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		return menuService.selectMenuHistory(param);
	}
	
	@RequestMapping("/menuView")
	public String menuView(HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param, ModelMap model) throws Exception{
		//lab_product 테이블 조회, lab_file 테이블 조회
		Map<String, Object> menuData = menuService.selectMenuData(param);
		model.addAttribute("menuData", menuData);
		Map<String, String> data = (Map<String, String>)menuData.get("data");
		//lab_product_materisl 테이블 조회
		if( data.get("IS_NEW_MATERIAL") != null && "Y".equals(data.get("IS_NEW_MATERIAL")) ) {
			model.addAttribute("menuMaterialData", menuService.selectMenuMaterial(param));
		}		
		return "/menu/menuView";
	}
	
	@RequestMapping(value = "/versionUpMenuForm")
	public String versionUpMenuForm( HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param, ModelMap model ) throws Exception{
		try {
			logger.debug("param : {} ",param.toString());
			Map<String, Object> menuData = menuService.selectMenuData(param);
			model.addAttribute("menuData", menuData);
			Map<String, String> data = (Map<String, String>)menuData.get("data");
			//lab_product_materisl 테이블 조회
			if( data.get("IS_NEW_MATERIAL") != null && "Y".equals(data.get("IS_NEW_MATERIAL")) ) {
				model.addAttribute("menuMaterialData", menuService.selectMenuMaterial(param));
			}
			return "/menu/versionUpMenuForm";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping("/insertNewVersionMenuAjax")
	@ResponseBody
	public Map<String, String> insertNewVersionMenuAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param
			, @RequestParam(value = "menuType", required = false) List<String> menuType
			, @RequestParam(value = "fileType", required = false) List<String> fileType
			, @RequestParam(value = "fileTypeText", required = false) List<String> fileTypeText
			, @RequestParam(value = "docType", required = false) List<String> docType
			, @RequestParam(value = "docTypeText", required = false) List<String> docTypeText
			, @RequestParam(value = "rowIdArr", required = false) List<String> rowIdArr
			, @RequestParam(value = "itemMatIdxArr", required = false) List<String> itemMatIdxArr
			, @RequestParam(value = "itemSapCodeArr", required = false) List<String> itemSapCodeArr
			, @RequestParam(value = "itemNameArr", required = false) List<String> itemNameArr
			, @RequestParam(value = "itemStandardArr", required = false) List<String> itemStandardArr
			, @RequestParam(value = "itemKeepExpArr", required = false) List<String> itemKeepExpArr
			, @RequestParam(value = "itemUnitPriceArr", required = false) List<String> itemUnitPriceArr
			, @RequestParam(value = "itemDescArr", required = false) List<String> itemDescArr
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
			Collections.reverse(menuType);
			System.err.println(menuType);
			System.err.println(rowIdArr);
			System.err.println(itemMatIdxArr);
			System.err.println(itemSapCodeArr);
			System.err.println(itemNameArr);
			System.err.println(itemStandardArr);
			System.err.println(itemKeepExpArr);
			System.err.println(itemUnitPriceArr);
			System.err.println(itemDescArr);
			System.err.println(file);
			HashMap<String, Object> listMap = new HashMap<String, Object>();
			listMap.put("menuType", menuType);
			listMap.put("fileType", fileType);
			listMap.put("fileTypeText", fileTypeText);
			listMap.put("docType", docType);
			listMap.put("docTypeText", docTypeText);
			listMap.put("rowIdArr", rowIdArr);
			listMap.put("itemMatIdxArr", itemMatIdxArr);
			listMap.put("itemSapCodeArr", itemSapCodeArr);
			listMap.put("itemNameArr", itemNameArr);
			listMap.put("itemStandardArr", itemStandardArr);
			listMap.put("itemKeepExpArr", itemKeepExpArr);
			listMap.put("itemUnitPriceArr", itemUnitPriceArr);
			listMap.put("itemDescArr", itemDescArr);
			menuService.insertNewVersionMenu(param, listMap, file);
			returnMap.put("RESULT", "S");			
		} catch( Exception e ) {
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}
		return returnMap;
	}
	
	
	@RequestMapping(value = "/pdfConversion")
	public String pdfConversion( HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param ) throws Exception{
		try {
			logger.debug("param : {} ",param.toString());
			
			File file = new File("E:/develop/upload/menu/202502/24d0357f-669c-4db1-8b9d-26353952ba90_2024학년도_2학기_대학원_수강신청_홈화면_수정_요청.pdf");
			PDDocument document = PDDocument.load(file);
			
			// PDF 파일의 페이지 수 가져오기
			int pageCount = document.getNumberOfPages();
			
			// 페이지별로 이미지 변환
			PDFRenderer pdfRenderer = new PDFRenderer(document);
			String path = "E:/develop/upload/images/";
			Calendar cal = Calendar.getInstance();
			String folder = ""+cal.getTimeInMillis();
			String imagePath = path+folder+"/";
			File dir = new File(imagePath);
			if (!dir.isDirectory()) {
				dir.mkdirs();
			}
			for(int i = 0; i < pageCount; i++) {
				BufferedImage imageObj = pdfRenderer.renderImageWithDPI(i, 300, ImageType.RGB);
				File outputfile = new File(imagePath + i + ".jpg");
				ImageIO.write(imageObj, "jpg", outputfile);
			}
			return "";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping("/selectErpMaterialDataAjax")
	@ResponseBody
	public Map<String, Object> selectErpMaterialDataAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		return menuService.selectErpMaterialData(param);
	}
	
	@RequestMapping("/selectSearchProductAjax")
	@ResponseBody
	public Map<String, Object> selectSearchProductAjax(HttpServletRequest request, HttpServletResponse response, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		Auth auth = AuthUtil.getAuth(request);
		param.put("userId", auth.getUserId());
		System.err.println(param);
		Map<String, Object> returnMap = menuService.selectSearchProduct(param);
		return returnMap;
	}
	
	@RequestMapping("/selectProductDataAjax")
	@ResponseBody
	public Map<String, Object> selectProductDataAjax(HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param, ModelMap model) throws Exception{
		//lab_product 테이블 조회, lab_file 테이블 조회
		Map<String, Object> returnMap = new HashMap<String, Object>();
		returnMap.put("productData", menuService.selectProductData(param));
		returnMap.put("productMaterialData", menuService.selectProductMaterial(param));
		return returnMap;
	}
	
	@RequestMapping("/searchUserAjax")
	@ResponseBody
	public List<Map<String, Object>> searchUserAjax(HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param, ModelMap model) throws Exception{
		//lab_product 테이블 조회, lab_file 테이블 조회
		System.err.println(param);
		List<Map<String, Object>> list = menuService.searchUser(param);
		return list;
	}
	
	@RequestMapping("/insertApprLineAjax")
	@ResponseBody
	public Map<String, String> insertApprLineAjax(HttpSession session,HttpServletRequest request, HttpServletResponse response
			, @RequestParam Map<String, Object> param
			, @RequestParam(value = "apprLine", required = false) List<String> apprLine
			, ModelMap model) throws Exception{
		Map<String, String> returnMap = new HashMap<String, String>();
		try {
			Auth auth = AuthUtil.getAuth(request);
			param.put("userId", auth.getUserId());
			param.put("apprLine", apprLine);
			menuService.insertApprLine(param);
			returnMap.put("RESULT", "S");			
		} catch( Exception e ) {
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}
		return returnMap;
	}
	
	@RequestMapping("/selectApprovalLineAjax")
	@ResponseBody
	public List<Map<String, Object>> selectApprovalLineAjax(HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param, ModelMap model) throws Exception{
		//lab_product 테이블 조회, lab_file 테이블 조회
		Auth auth = AuthUtil.getAuth(request);
		param.put("userId", auth.getUserId());
		System.err.println(param);
		List<Map<String, Object>> list = menuService.selectApprovalLine(param);
		return list;
	}
	
	@RequestMapping("/selectApprovalLineItemAjax")
	@ResponseBody
	public List<Map<String, Object>> selectApprovalLineItemAjax(HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param, ModelMap model) throws Exception{
		//lab_product 테이블 조회, lab_file 테이블 조회
		System.err.println(param);
		List<Map<String, Object>> list = menuService.selectApprovalLineItem(param);
		return list;
	}
	
	@RequestMapping("/deleteApprLineAjax")
	@ResponseBody
	public Map<String, String> deleteApprLineAjax(HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param, ModelMap model) throws Exception{
		//lab_product 테이블 조회, lab_file 테이블 조회
		System.err.println(param);
		
		Map<String, String> returnMap = new HashMap<String, String>();
		try {
			menuService.deleteApprLine(param);
			returnMap.put("RESULT", "S");			
		} catch( Exception e ) {
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}
		return returnMap;
	}
	
	@RequestMapping("/insertApprAjax")
	@ResponseBody
	public Map<String, String> insertApprAjax(HttpSession session,HttpServletRequest request, HttpServletResponse response
			, @RequestParam Map<String, Object> param
			, @RequestParam(value = "apprLine", required = false) List<String> apprLine
			, @RequestParam(value = "refLine", required = false) List<String> refLine
			, ModelMap model) throws Exception{
		Map<String, String> returnMap = new HashMap<String, String>();
		try {
			System.err.println("param : "+param);
			System.err.println("apprLine : "+apprLine);
			System.err.println("refLine : "+refLine);
			Auth auth = AuthUtil.getAuth(request);
			param.put("userId", auth.getUserId());
			param.put("apprLine", apprLine);
			param.put("refLine", refLine);
			menuService.insertAppr(param);
			returnMap.put("RESULT", "S");			
		} catch( Exception e ) {
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}
		return returnMap;
	}
}
