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
import kr.co.aspn.service.ProductService;
import kr.co.aspn.util.StringUtil;
import kr.co.aspn.vo.FileVO;

@Controller
@RequestMapping("/product")
public class ProductController {
	private Logger logger = LoggerFactory.getLogger(ProductController.class);
	
	@Autowired
	ProductService productService;
	
	@RequestMapping(value = "/productList")
	public String productList( HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param ) throws Exception{
		try {
			logger.debug("param : {} ",param.toString());
			return "/product/productList";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping("/selectProductListAjax")
	@ResponseBody
	public Map<String, Object> selectProductListAjax(HttpServletRequest request, HttpServletResponse response, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		Map<String, Object> returnMap = productService.selectProductList(param);
		return returnMap;
	}
	
	@RequestMapping(value = "/productInsert")
	public String compInsert( HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param ) throws Exception{
		try {
			logger.debug("param : {} ",param.toString());
			return "/product/productInsert";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping("/productView")
	public String productView(HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param, ModelMap model) throws Exception{
		//lab_product 테이블 조회, lab_file 테이블 조회
		Map<String, Object> productData = productService.selectProductData(param);
		model.addAttribute("productData", productData);
		Map<String, Object> addInfoCount = productService.selectAddInfoCount(param);
		model.addAttribute("addInfoCount", addInfoCount);
		List<Map<String, String>> addInfoList = productService.selectAddInfo(param);
		model.addAttribute("addInfoList", addInfoList);
		List<Map<String, String>> imporvePurposeList = productService.selectImporvePurposeList(param);
		model.addAttribute("imporvePurposeList", imporvePurposeList);
		List<Map<String, String>> newDataList = productService.selectNewDataList(param);
		model.addAttribute("newDataList", newDataList);
		model.addAttribute("productMaterialData", productService.selectProductMaterial(param));
		
		return "/product/productView";
	}
	
	@RequestMapping("/selectNewCodeAjax")
	@ResponseBody
	public String selectNewCodeAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat sdf = new SimpleDateFormat("yyMMdd");
		String selectCode = productService.selectProductCode();
		return sdf.format(cal.getTime())+""+selectCode;
	}
	
	@RequestMapping("/checkMaterialAjax")
	@ResponseBody
	public List<Map<String, String>> checkMaterialAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		return productService.checkMaterial(param);
	}
	
	@RequestMapping("/checkErpMaterialAjax")
	@ResponseBody
	public List<Map<String, String>> checkErpMaterialAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		return productService.checkErpMaterial(param);
	}
	
	@RequestMapping("/selectMaterialAjax")
	@ResponseBody
	public Map<String, Object> selectMaterialListAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		System.err.println(param);
		return productService.selectMaterialList(param);
	}
	
	@RequestMapping("/selectProductCountAjax")
	@ResponseBody
	public Map<String, Object> selectProductCountAjax(HttpServletRequest request, HttpServletResponse response, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		Map<String, Object> returnMap = productService.selectProductDataCount(param);
		return returnMap;
	}
	
	@RequestMapping("/insertTmpProductAjax")
	@ResponseBody
	public Map<String, Object> insertTmpProductAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param
			, @RequestParam(value = "purposeArr", required = false) List<String> purposeArr
			, @RequestParam(value = "featureArr", required = false) List<String> featureArr
			, @RequestParam(value = "newItemNameArr", required = false) List<String> newItemNameArr
			, @RequestParam(value = "newItemStandardArr", required = false) List<String> newItemStandardArr
			, @RequestParam(value = "newItemSupplierArr", required = false) List<String> newItemSupplierArr
			, @RequestParam(value = "newItemKeepExpArr", required = false) List<String> newItemKeepExpArr
			, @RequestParam(value = "newItemNoteArr", required = false) List<String> newItemNoteArr
			, @RequestParam(value = "productType", required = false) List<String> productType
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
			System.err.println(newItemNameArr);
			System.err.println(newItemStandardArr);
			System.err.println(newItemSupplierArr);
			System.err.println(newItemKeepExpArr);
			System.err.println(newItemNoteArr);
			
			System.err.println(fileType);
			System.err.println(fileTypeText);
			System.err.println(docType);
			System.err.println(docTypeText);
			Collections.reverse(productType);
			System.err.println(productType);
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
			listMap.put("newItemNameArr", newItemNameArr);
			listMap.put("newItemStandardArr", newItemStandardArr);
			listMap.put("newItemSupplierArr", newItemSupplierArr);
			listMap.put("newItemKeepExpArr", newItemKeepExpArr);
			listMap.put("newItemNoteArr", newItemNoteArr);
			listMap.put("productType", productType);
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
			
			int productIdx = productService.insertTmpProduct(param, listMap, file);
			returnMap.put("IDX", productIdx);
			returnMap.put("RESULT", "S");
			
		} catch( Exception e ) {
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}
		return returnMap;
	}
	
	@RequestMapping("/insertProductAjax")
	@ResponseBody
	public Map<String, Object> insertProductAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param
			, @RequestParam(value = "purposeArr", required = false) List<String> purposeArr
			, @RequestParam(value = "featureArr", required = false) List<String> featureArr
			, @RequestParam(value = "newItemNameArr", required = false) List<String> newItemNameArr
			, @RequestParam(value = "newItemStandardArr", required = false) List<String> newItemStandardArr
			, @RequestParam(value = "newItemSupplierArr", required = false) List<String> newItemSupplierArr
			, @RequestParam(value = "newItemKeepExpArr", required = false) List<String> newItemKeepExpArr
			, @RequestParam(value = "newItemNoteArr", required = false) List<String> newItemNoteArr
			, @RequestParam(value = "productType", required = false) List<String> productType
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
			Collections.reverse(productType);
			System.err.println(productType);
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
			listMap.put("newItemNameArr", newItemNameArr);
			listMap.put("newItemStandardArr", newItemStandardArr);
			listMap.put("newItemSupplierArr", newItemSupplierArr);
			listMap.put("newItemKeepExpArr", newItemKeepExpArr);
			listMap.put("newItemNoteArr", newItemNoteArr);
			listMap.put("productType", productType);
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
			int productIdx = productService.insertProduct(param, listMap, file);
			returnMap.put("IDX", productIdx);
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
			Map<String, Object> productData = productService.selectProductData(param);
			model.addAttribute("productData", productData);
			Map<String, Object> addInfoCount = productService.selectAddInfoCount(param);
			model.addAttribute("addInfoCount", addInfoCount);
			List<Map<String, String>> addInfoList = productService.selectAddInfo(param);
			model.addAttribute("addInfoList", addInfoList);
			List<Map<String, String>> imporvePurposeList = productService.selectImporvePurposeList(param);
			model.addAttribute("imporvePurposeList", imporvePurposeList);
			List<Map<String, String>> newDataList = productService.selectNewDataList(param);
			model.addAttribute("newDataList", newDataList);
			model.addAttribute("productMaterialData", productService.selectProductMaterial(param));
			
			return "/product/versionUpProductForm";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping("/selectHistoryAjax")
	@ResponseBody
	public List<Map<String, String>> selectHistoryAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		return productService.selectHistory(param);
	}
	
	@RequestMapping("/insertNewVersionCheckAjax")
	@ResponseBody
	public Map<String, Object> insertNewVersionCheckAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();
		returnMap.put("RESULT", productService.insertNewVersionCheck(param));
		return returnMap;
	}
	
	@RequestMapping("/insertNewVersionProductTmpAjax")
	@ResponseBody
	public Map<String, Object> insertNewVersionProductTmpAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param
			, @RequestParam(value = "itemImproveArr", required = false) List<String> itemImproveArr
			, @RequestParam(value = "itemExistArr", required = false) List<String> itemExistArr
			, @RequestParam(value = "itemNoteArr", required = false) List<String> itemNoteArr
			, @RequestParam(value = "improveArr", required = false) List<String> improveArr
			, @RequestParam(value = "newItemNameArr", required = false) List<String> newItemNameArr
			, @RequestParam(value = "newItemStandardArr", required = false) List<String> newItemStandardArr
			, @RequestParam(value = "newItemSupplierArr", required = false) List<String> newItemSupplierArr
			, @RequestParam(value = "newItemKeepExpArr", required = false) List<String> newItemKeepExpArr
			, @RequestParam(value = "newItemNoteArr", required = false) List<String> newItemNoteArr
			, @RequestParam(value = "productType", required = false) List<String> productType
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
			
			System.err.println(productType);
			System.err.println(itemImproveArr);
			System.err.println(itemExistArr);
			System.err.println(itemNoteArr);
			System.err.println(improveArr);
			
			System.err.println(fileType);
			System.err.println(fileTypeText);
			System.err.println(docType);
			System.err.println(docTypeText);
			Collections.reverse(productType);
			
			
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
			listMap.put("newItemNameArr", newItemNameArr);
			listMap.put("newItemStandardArr", newItemStandardArr);
			listMap.put("newItemSupplierArr", newItemSupplierArr);
			listMap.put("newItemKeepExpArr", newItemKeepExpArr);
			listMap.put("newItemNoteArr", newItemNoteArr);
			listMap.put("productType", productType);
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
			int productIdx = productService.insertNewVersionProductTmp(param, listMap, file);
			returnMap.put("IDX", productIdx);
			returnMap.put("RESULT", "S");			
		} catch( Exception e ) {
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}
		return returnMap;
	}
	
	@RequestMapping("/insertNewVersionProductAjax")
	@ResponseBody
	public Map<String, Object> insertNewVersionProductAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param
			, @RequestParam(value = "itemImproveArr", required = false) List<String> itemImproveArr
			, @RequestParam(value = "itemExistArr", required = false) List<String> itemExistArr
			, @RequestParam(value = "itemNoteArr", required = false) List<String> itemNoteArr
			, @RequestParam(value = "improveArr", required = false) List<String> improveArr
			, @RequestParam(value = "newItemNameArr", required = false) List<String> newItemNameArr
			, @RequestParam(value = "newItemStandardArr", required = false) List<String> newItemStandardArr
			, @RequestParam(value = "newItemSupplierArr", required = false) List<String> newItemSupplierArr
			, @RequestParam(value = "newItemKeepExpArr", required = false) List<String> newItemKeepExpArr
			, @RequestParam(value = "newItemNoteArr", required = false) List<String> newItemNoteArr
			, @RequestParam(value = "productType", required = false) List<String> productType
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
			listMap.put("itemImproveArr", itemImproveArr);
			listMap.put("itemExistArr", itemExistArr);
			listMap.put("itemNoteArr", itemNoteArr);
			listMap.put("improveArr", improveArr);
			listMap.put("newItemNameArr", newItemNameArr);
			listMap.put("newItemStandardArr", newItemStandardArr);
			listMap.put("newItemSupplierArr", newItemSupplierArr);
			listMap.put("newItemKeepExpArr", newItemKeepExpArr);
			listMap.put("newItemNoteArr", newItemNoteArr);
			listMap.put("productType", productType);
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
			int productIdx = productService.insertNewVersionProduct(param, listMap, file);
			returnMap.put("IDX", productIdx);
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
		return productService.selectErpMaterialData(param);
	}
	
	@RequestMapping("/selectSearchProductAjax")
	@ResponseBody
	public Map<String, Object> selectSearchProductAjax(HttpServletRequest request, HttpServletResponse response, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		Auth auth = AuthUtil.getAuth(request);
		param.put("userId", auth.getUserId());
		System.err.println(param);
		Map<String, Object> returnMap = productService.selectSearchProduct(param);
		return returnMap;
	}
	
	@RequestMapping("/selectProductDataAjax")
	@ResponseBody
	public Map<String, Object> selectProductDataAjax(HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param, ModelMap model) throws Exception{
		//lab_product 테이블 조회, lab_file 테이블 조회
		Map<String, Object> returnMap = new HashMap<String, Object>();
		returnMap.put("productData", productService.selectProductData(param));
		Map<String, Object> addInfoCount = productService.selectAddInfoCount(param);
		returnMap.put("addInfoCount", addInfoCount);
		List<Map<String, String>> addInfoList = productService.selectAddInfo(param);
		returnMap.put("addInfoList", addInfoList);
		List<Map<String, String>> newDataList = productService.selectNewDataList(param);
		returnMap.put("newDataList", newDataList);
		returnMap.put("productMaterialData", productService.selectProductMaterial(param));
		return returnMap;
	}
	
	@RequestMapping(value = "/productUpdateForm")
	public String productUpdateForm( HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param, ModelMap model ) throws Exception{
		try {
			logger.debug("param : {} ",param.toString());
			Map<String, Object> productData = productService.selectProductData(param);
			model.addAttribute("productData", productData);
			Map<String, Object> addInfoCount = productService.selectAddInfoCount(param);
			model.addAttribute("addInfoCount", addInfoCount);
			List<Map<String, String>> addInfoList = productService.selectAddInfo(param);
			model.addAttribute("addInfoList", addInfoList);
			List<Map<String, String>> imporvePurposeList = productService.selectImporvePurposeList(param);
			model.addAttribute("imporvePurposeList", imporvePurposeList);
			List<Map<String, String>> newDataList = productService.selectNewDataList(param);
			model.addAttribute("newDataList", newDataList);
			model.addAttribute("productMaterialData", productService.selectProductMaterial(param));
			return "/product/productUpdateForm";
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
			Map<String, Object> fileData = productService.selectFileData(param);
			System.err.println("파일 데이터 : "+fileData);
			String path = (String)fileData.get("FILE_PATH");
			String fileName = (String)fileData.get("FILE_NAME");

			String fullPath = path+"/"+fileName;
			File file = new File(fullPath);
			if(file.exists() == true){		
				file.delete();				// 해당 경로의 파일이 존재하면 파일 삭제
				System.err.println("파일삭제");
			}
			productService.deleteFileData(param);
			map.put("RESULT", "S");
		} catch( Exception e ) {
			map.put("RESULT", "E");
			map.put("MESSAGE", e.getMessage());
		}
		return map;
	}
	
	@RequestMapping("/updateTmpProductAjax")
	@ResponseBody
	public Map<String, String> updateTmpProductAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param
			, @RequestParam(value = "purposeArr", required = false) List<String> purposeArr
			, @RequestParam(value = "featureArr", required = false) List<String> featureArr
			
			, @RequestParam(value = "itemImproveArr", required = false) List<String> itemImproveArr
			, @RequestParam(value = "itemExistArr", required = false) List<String> itemExistArr
			, @RequestParam(value = "itemNoteArr", required = false) List<String> itemNoteArr
			, @RequestParam(value = "improveArr", required = false) List<String> improveArr
			
			, @RequestParam(value = "newItemNameArr", required = false) List<String> newItemNameArr
			, @RequestParam(value = "newItemStandardArr", required = false) List<String> newItemStandardArr
			, @RequestParam(value = "newItemSupplierArr", required = false) List<String> newItemSupplierArr
			, @RequestParam(value = "newItemKeepExpArr", required = false) List<String> newItemKeepExpArr
			, @RequestParam(value = "newItemNoteArr", required = false) List<String> newItemNoteArr
			, @RequestParam(value = "productType", required = false) List<String> productType
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
			listMap.put("purposeArr", purposeArr);
			listMap.put("featureArr", featureArr);
			
			listMap.put("itemImproveArr", itemImproveArr);
			listMap.put("itemExistArr", itemExistArr);
			listMap.put("itemNoteArr", itemNoteArr);
			listMap.put("improveArr", improveArr);
			
			
			listMap.put("newItemNameArr", newItemNameArr);
			listMap.put("newItemStandardArr", newItemStandardArr);
			listMap.put("newItemSupplierArr", newItemSupplierArr);
			listMap.put("newItemKeepExpArr", newItemKeepExpArr);
			listMap.put("newItemNoteArr", newItemNoteArr);
			listMap.put("productType", productType);
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
			productService.updateProductTmp(param, listMap, file);
			returnMap.put("RESULT", "S");			
		} catch( Exception e ) {
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}
		return returnMap;
	}
	
	@RequestMapping("/updateProductAjax")
	@ResponseBody
	public Map<String, String> updateProductAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param
			, @RequestParam(value = "purposeArr", required = false) List<String> purposeArr
			, @RequestParam(value = "featureArr", required = false) List<String> featureArr
			
			, @RequestParam(value = "itemImproveArr", required = false) List<String> itemImproveArr
			, @RequestParam(value = "itemExistArr", required = false) List<String> itemExistArr
			, @RequestParam(value = "itemNoteArr", required = false) List<String> itemNoteArr
			, @RequestParam(value = "improveArr", required = false) List<String> improveArr
			
			
			, @RequestParam(value = "newItemNameArr", required = false) List<String> newItemNameArr
			, @RequestParam(value = "newItemStandardArr", required = false) List<String> newItemStandardArr
			, @RequestParam(value = "newItemSupplierArr", required = false) List<String> newItemSupplierArr
			, @RequestParam(value = "newItemKeepExpArr", required = false) List<String> newItemKeepExpArr
			, @RequestParam(value = "newItemNoteArr", required = false) List<String> newItemNoteArr
			, @RequestParam(value = "productType", required = false) List<String> productType
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
			listMap.put("purposeArr", purposeArr);
			listMap.put("featureArr", featureArr);
			
			listMap.put("itemImproveArr", itemImproveArr);
			listMap.put("itemExistArr", itemExistArr);
			listMap.put("itemNoteArr", itemNoteArr);
			listMap.put("improveArr", improveArr);
			
			listMap.put("newItemNameArr", newItemNameArr);
			listMap.put("newItemStandardArr", newItemStandardArr);
			listMap.put("newItemSupplierArr", newItemSupplierArr);
			listMap.put("newItemKeepExpArr", newItemKeepExpArr);
			listMap.put("newItemNoteArr", newItemNoteArr);
			listMap.put("productType", productType);
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
			productService.updateProduct(param, listMap, file);
			returnMap.put("RESULT", "S");			
		} catch( Exception e ) {
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}
		return returnMap;
	}
}
