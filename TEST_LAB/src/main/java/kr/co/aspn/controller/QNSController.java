package kr.co.aspn.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;
import java.net.URLEncoder;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Properties;

import javax.net.ssl.HttpsURLConnection;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.aspn.common.auth.Auth;
import kr.co.aspn.common.auth.AuthUtil;
import kr.co.aspn.service.ProductDevService;
import kr.co.aspn.service.QNSService;
import kr.co.aspn.util.SSLHostnameVerifier;
import kr.co.aspn.util.SSLTrustManager;
import kr.co.aspn.vo.DesignRequestDocVO;
import kr.co.aspn.vo.MfgProcessDoc;

@Controller
@RequestMapping("/qns")
public class QNSController {
	
	@Autowired
	Properties config;
	
	@Autowired
	ProductDevService productDevService;
	
	@Autowired
	QNSService qnsService;
	
	private Logger logger = LoggerFactory.getLogger(QNSController.class);
	
	@RequestMapping("setQNSDocument")
	@ResponseBody
	public Map<String, Object> testurl(HttpServletRequest request, @RequestParam Map<String, Object> param) throws Exception {
		Auth auth = AuthUtil.getAuth(request);
		logger.debug("param {} ", param);
		
		//String mfgDoc = URLEncoder.encode(getMfgDoc(param), "UTF-8");
		//String drDoc = URLEncoder.encode(getDrDoc(param), "UTF-8");
		String mfgDoc = getMfgDoc(param);
		String drDoc = getDrDoc(param);	
		
		logger.debug(drDoc);
		
		param.put("manufacturingDoc", mfgDoc);
		param.put("designDoc", drDoc);
		param.put("regUserId", auth.getUserId());
		
		String result = qnsService.insertQNSH(param);
		param.put("status", result);
		
		return param;
	}
	
	@RequestMapping(value="mfgLayout")
	public String mfgLayout(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model ) throws Exception{
		String domain = config.getProperty("site.domain");
		
		model.addAttribute("productDevDoc", productDevService.getProductDevDoc(param.get("docNo").toString(), param.get("docVersion").toString()));
		MfgProcessDoc doc = productDevService.getMfgProcessDocDetail(param.get("dNo").toString(), param.get("docNo").toString(), param.get("docVersion").toString(), "");
		
		model.addAttribute("mfgProcessDoc", doc);
		model.addAttribute("paramVO", param);
		model.addAttribute("domain", domain);
		return "/qnsh/manufacturingProcessDetailPopup";
	}
	
	@RequestMapping(value="drLayout")
	public String drLayout(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model ) throws Exception{
		String domain = config.getProperty("site.domain");
		
		param.put("userId", AuthUtil.getAuth(request).getUserId());
		param.put("type", "0");
		DesignRequestDocVO designVO = productDevService.getDesignRequestDocDetail((String)param.get("drNo"));
		model.addAttribute("designReqDoc", designVO);
		model.addAttribute("paramVO", param);
		model.addAttribute("domain", domain);
		return "/qnsh/designRequestDetailPopup";
	}
	
	private String getMfgDoc(Map<String, Object> requestParam) throws IOException {
		try {
			trustAllHttpsCertificates();
			HttpsURLConnection.setDefaultHostnameVerifier(new SSLHostnameVerifier());
			String domain = config.getProperty("site.domain");
			URL url = new URL(domain+"qns/mfgLayout");
			
			Map<String,Object> params = new LinkedHashMap<String,Object>(); // 파라미터 세팅
			params.put("tbKey", requestParam.get("dNo"));
			params.put("dNo", requestParam.get("dNo"));
			params.put("tbType", "manufacturingProcessDoc");
			params.put("docNo", requestParam.get("docNo"));
			params.put("docVersion", requestParam.get("docVersion"));
			
			StringBuilder postData = new StringBuilder();
			for(Map.Entry<String,Object> param : params.entrySet()) {
				if(postData.length() != 0) postData.append('&');
				postData.append(URLEncoder.encode(param.getKey(), "UTF-8"));
				postData.append('=');
				postData.append(URLEncoder.encode(String.valueOf(param.getValue()), "UTF-8"));
			}
			byte[] postDataBytes = postData.toString().getBytes("UTF-8");
			
			HttpsURLConnection conn = (HttpsURLConnection)url.openConnection();
			conn.setRequestMethod("POST");
			conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
			conn.setRequestProperty("Content-Length", String.valueOf(postDataBytes.length));
			conn.setDoOutput(true);
			conn.getOutputStream().write(postDataBytes); // POST 호출
			
			BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
			
			String inputLine;
			String mfgDoc = "";
			while((inputLine = in.readLine()) != null) { // response 출력
				//System.out.println(inputLine);
				mfgDoc += inputLine;
			}
			
			in.close();
			
			return mfgDoc;
			
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			return null;
		}
	}
	
	private String getDrDoc(Map<String, Object> requestParam) throws IOException {
		try {
			trustAllHttpsCertificates();
			HttpsURLConnection.setDefaultHostnameVerifier(new SSLHostnameVerifier());
			String domain = config.getProperty("site.domain");
			URL url = new URL(domain+"qns/drLayout");
			
			Map<String,Object> params = new LinkedHashMap<String,Object>(); // 파라미터 세팅
			params.put("drNo", requestParam.get("drNo"));
			params.put("docNo", requestParam.get("docNo"));
			params.put("docVersion", requestParam.get("docVersion"));
			
			StringBuilder postData = new StringBuilder();
			for(Map.Entry<String,Object> param : params.entrySet()) {
				if(postData.length() != 0) postData.append('&');
				postData.append(URLEncoder.encode(param.getKey(), "UTF-8"));
				postData.append('=');
				postData.append(URLEncoder.encode(String.valueOf(param.getValue()), "UTF-8"));
			}
			byte[] postDataBytes = postData.toString().getBytes("UTF-8");
			
			HttpsURLConnection conn = (HttpsURLConnection)url.openConnection();
			conn.setRequestMethod("POST");
			conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
			conn.setRequestProperty("Content-Length", String.valueOf(postDataBytes.length));
			conn.setDoOutput(true);
			conn.getOutputStream().write(postDataBytes); // POST 호출
			
			BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
			
			String inputLine;
			
			String drDoc = "";
			while((inputLine = in.readLine()) != null) { // response 출력
				//System.out.println(inputLine);
				drDoc += inputLine;
			}
			
			in.close();
			
			return drDoc;
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			return null;
		}
		
	}
	
	private void trustAllHttpsCertificates() throws Exception { 
		javax.net.ssl.TrustManager[] trustAllCerts = new javax.net.ssl.TrustManager[1]; 
		trustAllCerts[0] = new SSLTrustManager(); 
		javax.net.ssl.SSLContext sc = javax.net.ssl.SSLContext.getInstance("SSL"); 
		sc.init(null, trustAllCerts, null); 
		javax.net.ssl.HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory()); 
	}
}
