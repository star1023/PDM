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
import org.springframework.web.bind.annotation.RequestMethod;
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
	public String compInsert( HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param ) throws Exception{
		try {
			logger.debug("param : {} ",param.toString());
			return "/menu/menuInsert";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping("/menuView")
	public String menuView(HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param, ModelMap model) throws Exception{
		//lab_menu 테이블 조회, lab_file 테이블 조회
		Map<String, Object> menuData = menuService.selectMenuData(param);
		model.addAttribute("menuData", menuData);
		Map<String, Object> addInfoCount = menuService.selectAddInfoCount(param);
		model.addAttribute("addInfoCount", addInfoCount);
		List<Map<String, String>> addInfoList = menuService.selectAddInfo(param);
		model.addAttribute("addInfoList", addInfoList);
		List<Map<String, String>> imporvePurposeList = menuService.selectImporvePurposeList(param);
		model.addAttribute("imporvePurposeList", imporvePurposeList);
		List<Map<String, String>> newDataList = menuService.selectNewDataList(param);
		model.addAttribute("newDataList", newDataList);
		model.addAttribute("menuMaterialData", menuService.selectMenuMaterial(param));
		
		return "/menu/menuView";
	}
	
	@RequestMapping("/selectNewCodeAjax")
	@ResponseBody
	public String selectNewCodeAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat sdf = new SimpleDateFormat("yyMMdd");
		String selectCode = menuService.selectMenuCode();
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
	
	@RequestMapping("/selectMenuCountAjax")
	@ResponseBody
	public Map<String, Object> selectMenuCountAjax(HttpServletRequest request, HttpServletResponse response, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		Map<String, Object> returnMap = menuService.selectMenuDataCount(param);
		return returnMap;
	}
	
	@RequestMapping("/insertTmpMenuAjax")
	@ResponseBody
	public Map<String, Object> insertTmpMenuAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param
			, @RequestParam(value = "purposeArr", required = false) List<String> purposeArr
			, @RequestParam(value = "featureArr", required = false) List<String> featureArr
			, @RequestParam(value = "usageArr", required = false) List<String> usageArr
			, @RequestParam(value = "usageType", required = false) String usageType
			, @RequestParam(value = "newItemNameArr", required = false) List<String> newItemNameArr
			, @RequestParam(value = "newItemStandardArr", required = false) List<String> newItemStandardArr
			, @RequestParam(value = "newItemSupplierArr", required = false) List<String> newItemSupplierArr
			, @RequestParam(value = "newItemKeepExpArr", required = false) List<String> newItemKeepExpArr
			, @RequestParam(value = "newItemNoteArr", required = false) List<String> newItemNoteArr
			, @RequestParam(value = "newItemTypeCodeArr", required = false) List<String> newItemTypeCodeArr
			, @RequestParam(value = "menuType", required = false) List<String> menuType
			, @RequestParam(value = "fileType", required = false) List<String> fileType
			, @RequestParam(value = "fileTypeText", required = false) List<String> fileTypeText
			, @RequestParam(value = "docType", required = false) List<String> docType
			, @RequestParam(value = "docTypeText", required = false) List<String> docTypeText
			, @RequestParam(value = "tempFile", required = false) List<String> tempFile
			, @RequestParam(value = "rowIdArr", required = false) List<String> rowIdArr
			, @RequestParam(value = "itemTypeArr", required = false) List<String> itemTypeArr
			, @RequestParam(value = "itemMatIdxArr", required = false) List<String> itemMatIdxArr
			, @RequestParam(value = "itemMatCodeArr", required = false) List<String> itemMatCodeArr
			, @RequestParam(value = "itemSapCodeArr", required = false) List<String> itemSapCodeArr
			, @RequestParam(value = "itemNameArr", required = false) List<String> itemNameArr
			, @RequestParam(value = "itemStandardArr", required = false) List<String> itemStandardArr
			, @RequestParam(value = "itemKeepExpArr", required = false) List<String> itemKeepExpArr
			, @RequestParam(value = "itemUnitPriceArr", required = false) List<String> itemUnitPriceArr
			, @RequestParam(value = "itemDescArr", required = false) List<String> itemDescArr
			, @RequestParam(required=false) MultipartFile... file) throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();
		try {
			Auth auth = AuthUtil.getAuth(request);
			param.put("userId", auth.getUserId());
			System.err.println(param);
			
			System.err.println(purposeArr);
			System.err.println(featureArr);
			System.err.println(usageArr);
			System.err.println(usageType);
			System.err.println(newItemNameArr);
			System.err.println(newItemStandardArr);
			System.err.println(newItemSupplierArr);
			System.err.println(newItemKeepExpArr);
			System.err.println(newItemNoteArr);
			
			System.err.println(fileType);
			System.err.println(fileTypeText);
			System.err.println(docType);
			System.err.println(docTypeText);
			Collections.reverse(menuType);
			System.err.println(menuType);
			System.err.println(tempFile);
			System.err.println(rowIdArr);
			System.err.println(itemMatIdxArr);
			System.err.println(itemMatCodeArr);
			System.err.println(itemSapCodeArr);
			System.err.println(itemNameArr);
			System.err.println(itemStandardArr);
			System.err.println(itemKeepExpArr);
			System.err.println(itemUnitPriceArr);
			System.err.println(itemDescArr);
			System.err.println(file);
			
			HashMap<String, Object> listMap = new HashMap<String, Object>();
			listMap.put("purposeArr", purposeArr);
			listMap.put("featureArr", featureArr);
			listMap.put("usageArr", usageArr);
			listMap.put("usageType", usageType);
			listMap.put("newItemNameArr", newItemNameArr);
			listMap.put("newItemStandardArr", newItemStandardArr);
			listMap.put("newItemSupplierArr", newItemSupplierArr);
			listMap.put("newItemKeepExpArr", newItemKeepExpArr);
			listMap.put("newItemNoteArr", newItemNoteArr);
			listMap.put("newItemTypeCodeArr", newItemTypeCodeArr);
			listMap.put("menuType", menuType);
			listMap.put("fileType", fileType);
			listMap.put("fileTypeText", fileTypeText);
			listMap.put("docType", docType);
			listMap.put("docTypeText", docTypeText);
			listMap.put("tempFile", tempFile);
			listMap.put("rowIdArr", rowIdArr);
			listMap.put("itemTypeArr", itemTypeArr);
			listMap.put("itemMatIdxArr", itemMatIdxArr);
			listMap.put("itemMatCodeArr", itemMatCodeArr);
			listMap.put("itemSapCodeArr", itemSapCodeArr);
			listMap.put("itemNameArr", itemNameArr);
			listMap.put("itemStandardArr", itemStandardArr);
			listMap.put("itemKeepExpArr", itemKeepExpArr);
			listMap.put("itemUnitPriceArr", itemUnitPriceArr);
			listMap.put("itemDescArr", itemDescArr);
			
			int menuIdx = menuService.insertTmpMenu(param, listMap, file);
			returnMap.put("IDX", menuIdx);
			returnMap.put("RESULT", "S");
			
		} catch( Exception e ) {
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}
		return returnMap;
	}
	
	@RequestMapping("/insertMenuAjax")
	@ResponseBody
	public Map<String, Object> insertMenuAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param
			, @RequestParam(value = "purposeArr", required = false) List<String> purposeArr
			, @RequestParam(value = "featureArr", required = false) List<String> featureArr
			, @RequestParam(value = "usageArr", required = false) List<String> usageArr
			, @RequestParam(value = "usageType", required = false) String usageType
			, @RequestParam(value = "newItemNameArr", required = false) List<String> newItemNameArr
			, @RequestParam(value = "newItemStandardArr", required = false) List<String> newItemStandardArr
			, @RequestParam(value = "newItemSupplierArr", required = false) List<String> newItemSupplierArr
			, @RequestParam(value = "newItemKeepExpArr", required = false) List<String> newItemKeepExpArr
			, @RequestParam(value = "newItemNoteArr", required = false) List<String> newItemNoteArr
			, @RequestParam(value = "newItemTypeCodeArr", required = false) List<String> newItemTypeCodeArr
			, @RequestParam(value = "menuType", required = false) List<String> menuType
			, @RequestParam(value = "fileType", required = false) List<String> fileType
			, @RequestParam(value = "fileTypeText", required = false) List<String> fileTypeText
			, @RequestParam(value = "docType", required = false) List<String> docType
			, @RequestParam(value = "docTypeText", required = false) List<String> docTypeText
			, @RequestParam(value = "tempFile", required = false) List<String> tempFile
			, @RequestParam(value = "rowIdArr", required = false) List<String> rowIdArr
			, @RequestParam(value = "itemTypeArr", required = false) List<String> itemTypeArr
			, @RequestParam(value = "itemMatIdxArr", required = false) List<String> itemMatIdxArr
			, @RequestParam(value = "itemMatCodeArr", required = false) List<String> itemMatCodeArr
			, @RequestParam(value = "itemSapCodeArr", required = false) List<String> itemSapCodeArr
			, @RequestParam(value = "itemNameArr", required = false) List<String> itemNameArr
			, @RequestParam(value = "itemStandardArr", required = false) List<String> itemStandardArr
			, @RequestParam(value = "itemKeepExpArr", required = false) List<String> itemKeepExpArr
			, @RequestParam(value = "itemUnitPriceArr", required = false) List<String> itemUnitPriceArr
			, @RequestParam(value = "itemDescArr", required = false) List<String> itemDescArr
			, @RequestParam(required=false) MultipartFile... file) throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();
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
			System.err.println(tempFile);
			System.err.println(rowIdArr);
			System.err.println(itemMatIdxArr);
			System.err.println(itemMatCodeArr);
			System.err.println(itemSapCodeArr);
			System.err.println(itemNameArr);
			System.err.println(itemStandardArr);
			System.err.println(itemKeepExpArr);
			System.err.println(itemUnitPriceArr);
			System.err.println(itemDescArr);
			System.err.println(file);
			HashMap<String, Object> listMap = new HashMap<String, Object>();
			listMap.put("purposeArr", purposeArr);
			listMap.put("featureArr", featureArr);
			listMap.put("usageArr", usageArr);
			listMap.put("usageType", usageType);
			listMap.put("newItemNameArr", newItemNameArr);
			listMap.put("newItemStandardArr", newItemStandardArr);
			listMap.put("newItemSupplierArr", newItemSupplierArr);
			listMap.put("newItemKeepExpArr", newItemKeepExpArr);
			listMap.put("newItemNoteArr", newItemNoteArr);
			listMap.put("newItemTypeCodeArr", newItemTypeCodeArr);
			listMap.put("menuType", menuType);
			listMap.put("fileType", fileType);
			listMap.put("fileTypeText", fileTypeText);
			listMap.put("docType", docType);
			listMap.put("docTypeText", docTypeText);
			listMap.put("tempFile", tempFile);
			listMap.put("rowIdArr", rowIdArr);
			listMap.put("itemTypeArr", itemTypeArr);
			listMap.put("itemMatIdxArr", itemMatIdxArr);
			listMap.put("itemMatCodeArr", itemMatCodeArr);
			listMap.put("itemSapCodeArr", itemSapCodeArr);
			listMap.put("itemNameArr", itemNameArr);
			listMap.put("itemStandardArr", itemStandardArr);
			listMap.put("itemKeepExpArr", itemKeepExpArr);
			listMap.put("itemUnitPriceArr", itemUnitPriceArr);
			listMap.put("itemDescArr", itemDescArr);
			int menuIdx = menuService.insertMenu(param, listMap, file);
			returnMap.put("IDX", menuIdx);
			returnMap.put("RESULT", "S");			
		} catch( Exception e ) {
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}
		return returnMap;
	}
	
	@RequestMapping(value = "/versionUpMenuForm")
	public String versionUpMenuForm( HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param, ModelMap model ) throws Exception{
		try {
			logger.debug("param : {} ",param.toString());
			Map<String, Object> menuData = menuService.selectMenuData(param);
			model.addAttribute("menuData", menuData);
			Map<String, Object> addInfoCount = menuService.selectAddInfoCount(param);
			model.addAttribute("addInfoCount", addInfoCount);
			List<Map<String, String>> addInfoList = menuService.selectAddInfo(param);
			model.addAttribute("addInfoList", addInfoList);
			List<Map<String, String>> imporvePurposeList = menuService.selectImporvePurposeList(param);
			model.addAttribute("imporvePurposeList", imporvePurposeList);
			List<Map<String, String>> newDataList = menuService.selectNewDataList(param);
			model.addAttribute("newDataList", newDataList);
			model.addAttribute("menuMaterialData", menuService.selectMenuMaterial(param));
			
			return "/menu/versionUpMenuForm";
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
	
	@RequestMapping("/insertNewVersionMenuTmpAjax")
	@ResponseBody
	public Map<String, Object> insertNewVersionMenuTmpAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param
			, @RequestParam(value = "itemImproveArr", required = false) List<String> itemImproveArr
			, @RequestParam(value = "itemExistArr", required = false) List<String> itemExistArr
			, @RequestParam(value = "itemNoteArr", required = false) List<String> itemNoteArr
			, @RequestParam(value = "improveArr", required = false) List<String> improveArr
			, @RequestParam(value = "usageArr", required = false) List<String> usageArr
			, @RequestParam(value = "usageType", required = false) String usageType
			, @RequestParam(value = "newItemNameArr", required = false) List<String> newItemNameArr
			, @RequestParam(value = "newItemStandardArr", required = false) List<String> newItemStandardArr
			, @RequestParam(value = "newItemSupplierArr", required = false) List<String> newItemSupplierArr
			, @RequestParam(value = "newItemKeepExpArr", required = false) List<String> newItemKeepExpArr
			, @RequestParam(value = "newItemNoteArr", required = false) List<String> newItemNoteArr
			, @RequestParam(value = "newItemTypeCodeArr", required = false) List<String> newItemTypeCodeArr
			, @RequestParam(value = "menuType", required = false) List<String> menuType
			, @RequestParam(value = "fileType", required = false) List<String> fileType
			, @RequestParam(value = "fileTypeText", required = false) List<String> fileTypeText
			, @RequestParam(value = "docType", required = false) List<String> docType
			, @RequestParam(value = "docTypeText", required = false) List<String> docTypeText
			, @RequestParam(value = "rowIdArr", required = false) List<String> rowIdArr
			, @RequestParam(value = "itemTypeArr", required = false) List<String> itemTypeArr
			, @RequestParam(value = "itemMatIdxArr", required = false) List<String> itemMatIdxArr
			, @RequestParam(value = "itemMatCodeArr", required = false) List<String> itemMatCodeArr
			, @RequestParam(value = "itemSapCodeArr", required = false) List<String> itemSapCodeArr
			, @RequestParam(value = "itemNameArr", required = false) List<String> itemNameArr
			, @RequestParam(value = "itemStandardArr", required = false) List<String> itemStandardArr
			, @RequestParam(value = "itemKeepExpArr", required = false) List<String> itemKeepExpArr
			, @RequestParam(value = "itemUnitPriceArr", required = false) List<String> itemUnitPriceArr
			, @RequestParam(value = "itemDescArr", required = false) List<String> itemDescArr
			, @RequestParam(required=false) MultipartFile... file) throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();
		try {
			Auth auth = AuthUtil.getAuth(request);
			param.put("userId", auth.getUserId());
			System.err.println(param);
			
			System.err.println(menuType);
			System.err.println(itemImproveArr);
			System.err.println(itemExistArr);
			System.err.println(itemNoteArr);
			System.err.println(itemNoteArr);
			System.err.println(improveArr);
			System.err.println(usageArr);
			System.err.println(usageType);
			
			System.err.println(fileType);
			System.err.println(fileTypeText);
			System.err.println(docType);
			System.err.println(docTypeText);
			Collections.reverse(menuType);
			
			
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
			listMap.put("itemImproveArr", itemImproveArr);
			listMap.put("itemExistArr", itemExistArr);
			listMap.put("itemNoteArr", itemNoteArr);
			listMap.put("improveArr", improveArr);
			listMap.put("usageArr", usageArr);
			listMap.put("usageType", usageType);
			listMap.put("newItemNameArr", newItemNameArr);
			listMap.put("newItemStandardArr", newItemStandardArr);
			listMap.put("newItemSupplierArr", newItemSupplierArr);
			listMap.put("newItemKeepExpArr", newItemKeepExpArr);
			listMap.put("newItemNoteArr", newItemNoteArr);
			listMap.put("newItemTypeCodeArr", newItemTypeCodeArr);
			listMap.put("menuType", menuType);
			listMap.put("fileType", fileType);
			listMap.put("fileTypeText", fileTypeText);
			listMap.put("docType", docType);
			listMap.put("docTypeText", docTypeText);
			listMap.put("rowIdArr", rowIdArr);
			listMap.put("itemTypeArr", itemTypeArr);
			listMap.put("itemMatIdxArr", itemMatIdxArr);
			listMap.put("itemMatCodeArr", itemMatCodeArr);
			listMap.put("itemSapCodeArr", itemSapCodeArr);
			listMap.put("itemNameArr", itemNameArr);
			listMap.put("itemStandardArr", itemStandardArr);
			listMap.put("itemKeepExpArr", itemKeepExpArr);
			listMap.put("itemUnitPriceArr", itemUnitPriceArr);
			listMap.put("itemDescArr", itemDescArr);
			int menuIdx = menuService.insertNewVersionMenuTmp(param, listMap, file);
			returnMap.put("IDX", menuIdx);
			returnMap.put("RESULT", "S");			
		} catch( Exception e ) {
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}
		return returnMap;
	}
	
	@RequestMapping("/insertNewVersionMenuAjax")
	@ResponseBody
	public Map<String, Object> insertNewVersionMenuAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param
			, @RequestParam(value = "itemImproveArr", required = false) List<String> itemImproveArr
			, @RequestParam(value = "itemExistArr", required = false) List<String> itemExistArr
			, @RequestParam(value = "itemNoteArr", required = false) List<String> itemNoteArr
			, @RequestParam(value = "improveArr", required = false) List<String> improveArr
			, @RequestParam(value = "usageArr", required = false) List<String> usageArr
			, @RequestParam(value = "usageType", required = false) String usageType
			, @RequestParam(value = "newItemNameArr", required = false) List<String> newItemNameArr
			, @RequestParam(value = "newItemStandardArr", required = false) List<String> newItemStandardArr
			, @RequestParam(value = "newItemSupplierArr", required = false) List<String> newItemSupplierArr
			, @RequestParam(value = "newItemKeepExpArr", required = false) List<String> newItemKeepExpArr
			, @RequestParam(value = "newItemNoteArr", required = false) List<String> newItemNoteArr
			, @RequestParam(value = "newItemTypeCodeArr", required = false) List<String> newItemTypeCodeArr
			, @RequestParam(value = "menuType", required = false) List<String> menuType
			, @RequestParam(value = "fileType", required = false) List<String> fileType
			, @RequestParam(value = "fileTypeText", required = false) List<String> fileTypeText
			, @RequestParam(value = "docType", required = false) List<String> docType
			, @RequestParam(value = "docTypeText", required = false) List<String> docTypeText
			, @RequestParam(value = "rowIdArr", required = false) List<String> rowIdArr
			, @RequestParam(value = "itemTypeArr", required = false) List<String> itemTypeArr
			, @RequestParam(value = "itemMatIdxArr", required = false) List<String> itemMatIdxArr
			, @RequestParam(value = "itemMatCodeArr", required = false) List<String> itemMatCodeArr
			, @RequestParam(value = "itemSapCodeArr", required = false) List<String> itemSapCodeArr
			, @RequestParam(value = "itemNameArr", required = false) List<String> itemNameArr
			, @RequestParam(value = "itemStandardArr", required = false) List<String> itemStandardArr
			, @RequestParam(value = "itemKeepExpArr", required = false) List<String> itemKeepExpArr
			, @RequestParam(value = "itemUnitPriceArr", required = false) List<String> itemUnitPriceArr
			, @RequestParam(value = "itemDescArr", required = false) List<String> itemDescArr
			, @RequestParam(required=false) MultipartFile... file) throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();
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
			listMap.put("itemImproveArr", itemImproveArr);
			listMap.put("itemExistArr", itemExistArr);
			listMap.put("itemNoteArr", itemNoteArr);
			listMap.put("improveArr", improveArr);
			listMap.put("usageArr", usageArr);
			listMap.put("usageType", usageType);
			listMap.put("newItemNameArr", newItemNameArr);
			listMap.put("newItemStandardArr", newItemStandardArr);
			listMap.put("newItemSupplierArr", newItemSupplierArr);
			listMap.put("newItemKeepExpArr", newItemKeepExpArr);
			listMap.put("newItemNoteArr", newItemNoteArr);
			listMap.put("newItemTypeCodeArr", newItemTypeCodeArr);
			listMap.put("menuType", menuType);
			listMap.put("fileType", fileType);
			listMap.put("fileTypeText", fileTypeText);
			listMap.put("docType", docType);
			listMap.put("docTypeText", docTypeText);
			listMap.put("rowIdArr", rowIdArr);
			listMap.put("itemTypeArr", itemTypeArr);
			listMap.put("itemMatIdxArr", itemMatIdxArr);
			listMap.put("itemMatCodeArr", itemMatCodeArr);
			listMap.put("itemSapCodeArr", itemSapCodeArr);
			listMap.put("itemNameArr", itemNameArr);
			listMap.put("itemStandardArr", itemStandardArr);
			listMap.put("itemKeepExpArr", itemKeepExpArr);
			listMap.put("itemUnitPriceArr", itemUnitPriceArr);
			listMap.put("itemDescArr", itemDescArr);
			int menuIdx = menuService.insertNewVersionMenu(param, listMap, file);
			returnMap.put("IDX", menuIdx);
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
	
	@RequestMapping("/selectSearchMenuAjax")
	@ResponseBody
	public Map<String, Object> selectSearchMenuAjax(HttpServletRequest request, HttpServletResponse response, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		Auth auth = AuthUtil.getAuth(request);
		param.put("userId", auth.getUserId());
		System.err.println(param);
		Map<String, Object> returnMap = menuService.selectSearchMenu(param);
		return returnMap;
	}
	
	@RequestMapping("/selectMenuDataAjax")
	@ResponseBody
	public Map<String, Object> selectMenuDataAjax(HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param, ModelMap model) throws Exception{
		//lab_menu 테이블 조회, lab_file 테이블 조회
		Map<String, Object> returnMap = new HashMap<String, Object>();
		returnMap.put("menuData", menuService.selectMenuData(param));
		Map<String, Object> addInfoCount = menuService.selectAddInfoCount(param);
		returnMap.put("addInfoCount", addInfoCount);
		List<Map<String, String>> addInfoList = menuService.selectAddInfo(param);
		returnMap.put("addInfoList", addInfoList);
		List<Map<String, String>> newDataList = menuService.selectNewDataList(param);
		returnMap.put("newDataList", newDataList);
		returnMap.put("menuMaterialData", menuService.selectMenuMaterial(param));
		return returnMap;
	}
	
	@RequestMapping(value = "/menuUpdateForm")
	public String menuUpdateForm( HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param, ModelMap model ) throws Exception{
		try {
			logger.debug("param : {} ",param.toString());
			Map<String, Object> menuData = menuService.selectMenuData(param);
			model.addAttribute("menuData", menuData);
			Map<String, Object> addInfoCount = menuService.selectAddInfoCount(param);
			model.addAttribute("addInfoCount", addInfoCount);
			List<Map<String, String>> addInfoList = menuService.selectAddInfo(param);
			model.addAttribute("addInfoList", addInfoList);
			List<Map<String, String>> imporvePurposeList = menuService.selectImporvePurposeList(param);
			model.addAttribute("imporvePurposeList", imporvePurposeList);
			List<Map<String, String>> newDataList = menuService.selectNewDataList(param);
			model.addAttribute("newDataList", newDataList);
			model.addAttribute("menuMaterialData", menuService.selectMenuMaterial(param));
			return "/menu/menuUpdateForm";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping(value = "/deleteFileAjax", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> deleteFileAjax(HttpServletResponse respose, HttpServletRequest request, @RequestParam Map<String, Object> param) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			Map<String, Object> fileData = menuService.selectFileData(param);
			System.err.println("파일 데이터 : "+fileData);
			String path = (String)fileData.get("FILE_PATH");
			String fileName = (String)fileData.get("FILE_NAME");

			String fullPath = path+"/"+fileName;
			File file = new File(fullPath);
			if(file.exists() == true){		
				file.delete();				// 해당 경로의 파일이 존재하면 파일 삭제
				System.err.println("파일삭제");
			}
			menuService.deleteFileData(param);
			map.put("RESULT", "S");
		} catch( Exception e ) {
			map.put("RESULT", "E");
			map.put("MESSAGE", e.getMessage());
		}
		return map;
	}
	
	@RequestMapping("/updateTmpMenuAjax")
	@ResponseBody
	public Map<String, String> updateTmpMenuAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param
			, @RequestParam(value = "purposeArr", required = false) List<String> purposeArr
			, @RequestParam(value = "featureArr", required = false) List<String> featureArr
			, @RequestParam(value = "usageArr", required = false) List<String> usageArr
			, @RequestParam(value = "usageType", required = false) String usageType
			
			, @RequestParam(value = "itemImproveArr", required = false) List<String> itemImproveArr
			, @RequestParam(value = "itemExistArr", required = false) List<String> itemExistArr
			, @RequestParam(value = "itemNoteArr", required = false) List<String> itemNoteArr
			, @RequestParam(value = "improveArr", required = false) List<String> improveArr
			
			, @RequestParam(value = "newItemNameArr", required = false) List<String> newItemNameArr
			, @RequestParam(value = "newItemStandardArr", required = false) List<String> newItemStandardArr
			, @RequestParam(value = "newItemSupplierArr", required = false) List<String> newItemSupplierArr
			, @RequestParam(value = "newItemKeepExpArr", required = false) List<String> newItemKeepExpArr
			, @RequestParam(value = "newItemNoteArr", required = false) List<String> newItemNoteArr
			, @RequestParam(value = "newItemTypeCodeArr", required = false) List<String> newItemTypeCodeArr
			, @RequestParam(value = "menuType", required = false) List<String> menuType
			, @RequestParam(value = "fileType", required = false) List<String> fileType
			, @RequestParam(value = "fileTypeText", required = false) List<String> fileTypeText
			, @RequestParam(value = "docType", required = false) List<String> docType
			, @RequestParam(value = "docTypeText", required = false) List<String> docTypeText
			, @RequestParam(value = "rowIdArr", required = false) List<String> rowIdArr
			, @RequestParam(value = "itemTypeArr", required = false) List<String> itemTypeArr
			, @RequestParam(value = "itemMatIdxArr", required = false) List<String> itemMatIdxArr
			, @RequestParam(value = "itemMatCodeArr", required = false) List<String> itemMatCodeArr
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
			listMap.put("purposeArr", purposeArr);
			listMap.put("featureArr", featureArr);
			listMap.put("usageArr", usageArr);
			listMap.put("usageType", usageType);
			
			listMap.put("itemImproveArr", itemImproveArr);
			listMap.put("itemExistArr", itemExistArr);
			listMap.put("itemNoteArr", itemNoteArr);
			listMap.put("improveArr", improveArr);
			
			
			listMap.put("newItemNameArr", newItemNameArr);
			listMap.put("newItemStandardArr", newItemStandardArr);
			listMap.put("newItemSupplierArr", newItemSupplierArr);
			listMap.put("newItemKeepExpArr", newItemKeepExpArr);
			listMap.put("newItemNoteArr", newItemNoteArr);
			listMap.put("newItemTypeCodeArr", newItemTypeCodeArr);
			listMap.put("menuType", menuType);
			listMap.put("fileType", fileType);
			listMap.put("fileTypeText", fileTypeText);
			listMap.put("docType", docType);
			listMap.put("docTypeText", docTypeText);
			listMap.put("rowIdArr", rowIdArr);
			listMap.put("itemTypeArr", itemTypeArr);
			listMap.put("itemMatIdxArr", itemMatIdxArr);
			listMap.put("itemMatCodeArr", itemMatCodeArr);
			listMap.put("itemSapCodeArr", itemSapCodeArr);
			listMap.put("itemNameArr", itemNameArr);
			listMap.put("itemStandardArr", itemStandardArr);
			listMap.put("itemKeepExpArr", itemKeepExpArr);
			listMap.put("itemUnitPriceArr", itemUnitPriceArr);
			listMap.put("itemDescArr", itemDescArr);
			menuService.updateMenuTmp(param, listMap, file);
			returnMap.put("RESULT", "S");			
		} catch( Exception e ) {
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}
		return returnMap;
	}
	
	@RequestMapping("/updateMenuAjax")
	@ResponseBody
	public Map<String, String> updateMenuAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param
			, @RequestParam(value = "purposeArr", required = false) List<String> purposeArr
			, @RequestParam(value = "featureArr", required = false) List<String> featureArr
			, @RequestParam(value = "usageArr", required = false) List<String> usageArr
			, @RequestParam(value = "usageType", required = false) String usageType
			
			, @RequestParam(value = "itemImproveArr", required = false) List<String> itemImproveArr
			, @RequestParam(value = "itemExistArr", required = false) List<String> itemExistArr
			, @RequestParam(value = "itemNoteArr", required = false) List<String> itemNoteArr
			, @RequestParam(value = "improveArr", required = false) List<String> improveArr
			
			, @RequestParam(value = "newItemNameArr", required = false) List<String> newItemNameArr
			, @RequestParam(value = "newItemStandardArr", required = false) List<String> newItemStandardArr
			, @RequestParam(value = "newItemSupplierArr", required = false) List<String> newItemSupplierArr
			, @RequestParam(value = "newItemKeepExpArr", required = false) List<String> newItemKeepExpArr
			, @RequestParam(value = "newItemNoteArr", required = false) List<String> newItemNoteArr
			, @RequestParam(value = "newItemTypeCodeArr", required = false) List<String> newItemTypeCodeArr
			
			, @RequestParam(value = "menuType", required = false) List<String> menuType
			, @RequestParam(value = "fileType", required = false) List<String> fileType
			, @RequestParam(value = "fileTypeText", required = false) List<String> fileTypeText
			, @RequestParam(value = "docType", required = false) List<String> docType
			, @RequestParam(value = "docTypeText", required = false) List<String> docTypeText
			, @RequestParam(value = "rowIdArr", required = false) List<String> rowIdArr
			, @RequestParam(value = "itemTypeArr", required = false) List<String> itemTypeArr
			, @RequestParam(value = "itemMatIdxArr", required = false) List<String> itemMatIdxArr
			, @RequestParam(value = "itemMatCodeArr", required = false) List<String> itemMatCodeArr
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
			listMap.put("purposeArr", purposeArr);
			listMap.put("featureArr", featureArr);
			listMap.put("usageArr", usageArr);
			listMap.put("usageType", usageType);
			
			listMap.put("itemImproveArr", itemImproveArr);
			listMap.put("itemExistArr", itemExistArr);
			listMap.put("itemNoteArr", itemNoteArr);
			listMap.put("improveArr", improveArr);
			
			listMap.put("newItemNameArr", newItemNameArr);
			listMap.put("newItemStandardArr", newItemStandardArr);
			listMap.put("newItemSupplierArr", newItemSupplierArr);
			listMap.put("newItemKeepExpArr", newItemKeepExpArr);
			listMap.put("newItemNoteArr", newItemNoteArr);
			listMap.put("newItemTypeCodeArr", newItemTypeCodeArr);
			
			listMap.put("menuType", menuType);
			listMap.put("fileType", fileType);
			listMap.put("fileTypeText", fileTypeText);
			listMap.put("docType", docType);
			listMap.put("docTypeText", docTypeText);
			listMap.put("rowIdArr", rowIdArr);
			listMap.put("itemTypeArr", itemTypeArr);
			listMap.put("itemMatIdxArr", itemMatIdxArr);
			listMap.put("itemMatCodeArr", itemMatCodeArr);
			listMap.put("itemSapCodeArr", itemSapCodeArr);
			listMap.put("itemNameArr", itemNameArr);
			listMap.put("itemStandardArr", itemStandardArr);
			listMap.put("itemKeepExpArr", itemKeepExpArr);
			listMap.put("itemUnitPriceArr", itemUnitPriceArr);
			listMap.put("itemDescArr", itemDescArr);
			menuService.updateMenu(param, listMap, file);
			returnMap.put("RESULT", "S");			
		} catch( Exception e ) {
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}
		return returnMap;
	}
}
