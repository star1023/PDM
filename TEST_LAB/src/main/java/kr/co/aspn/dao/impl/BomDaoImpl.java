package kr.co.aspn.dao.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.sap.conn.jco.JCoField;
import com.sap.conn.jco.JCoFieldIterator;
import com.sap.conn.jco.JCoFunction;
import com.sap.conn.jco.JCoTable;

import kr.co.aspn.common.jco.LabRfcManager;
import kr.co.aspn.common.jco.RfcManager;
import kr.co.aspn.dao.BomDao;

@Repository("bomRepo")
public class BomDaoImpl implements BomDao {
	Logger logger = LoggerFactory.getLogger(BomDaoImpl.class);
	
	private final static String TYPE_IMPORT = "import";
	private final static String TYPE_EXPORT = "export";
	
	@Autowired
	LabRfcManager rfcManager;
	
	@Override
	public Boolean bomHeaderCheck(Map<String, Object> headerMap) {
		//logger.debug("bomHeaderCheck() - headerMap.companyCode: " + headerMap.get("companyCode"));
		//System.out.println("bomHeaderCheck() - headerMap.companyCode: " + headerMap.get("companyCode"));
		String companyCode = (String)headerMap.get("companyCode");
		String I_MATNR = (String)headerMap.get("MATNR");
		String I_WERKS = (String)headerMap.get("WERKS");
		String I_STLAL = (String)headerMap.get("STLAL");
		
		JCoFunction fn = rfcManager.getFunction(companyCode, "ZPP_BOM_RFC5");
		
		fn.getImportParameterList().setValue("I_MATNR", I_MATNR);
		fn.getImportParameterList().setValue("I_WERKS", I_WERKS);
		fn.getImportParameterList().setValue("I_STLAL", I_STLAL);
		
		rfcManager.executeFunction(fn);
		rfcManager.executeLog(fn);
		
		String resultFlag = fn.getExportParameterList().getString("E_MESSAGE");
		
		return resultFlag.equals("F") ? true : false;
	}
	
	@Override
	public Map<String, String> createBom(List<Map<String, Object>> bomItemList) {
		//System.out.println("createBom() - bomItemList.size(): " + bomItemList.size());
		String companyCode = (String) bomItemList.get(0).get("companyCode");
		
		JCoFunction fn = rfcManager.getFunction(companyCode, "ZPP_BOM_RFC");
		JCoTable table = fn.getTableParameterList().getTable("GT_BOM");
		
		//System.out.println("RFC FUNCTION: ZPP_BOM_RFC Excuute Log");
		
		for (Map<String, Object> bomItem : bomItemList) {
			table.appendRow();
			
			table.setValue("MATNR", (String)bomItem.get("MATNR"));
			table.setValue("WERKS", (String)bomItem.get("WERKS"));
			table.setValue("STLAN", (String)bomItem.get("STLAN"));
			table.setValue("STLAL", (String)bomItem.get("STLAL"));
			table.setValue("ZTEXT", (String)bomItem.get("ZTEXT"));
			table.setValue("STKTX", (String)bomItem.get("STKTX"));
			table.setValue("BMENG", String.valueOf(bomItem.get("BMENG")));
			table.setValue("POSNR", (String)bomItem.get("POSNR"));
			table.setValue("IDNRK", (String)bomItem.get("IDNRK"));
			table.setValue("MENGE", (String)bomItem.get("MENGE"));
			table.setValue("MEINS", (String)bomItem.get("MEINS"));
			table.setValue("AUSCH", (String)bomItem.get("AUSCH"));
			table.setValue("SANFE", (String)bomItem.get("SANFE"));
			table.setValue("LGORT", (String)bomItem.get("LGORT"));
			table.setValue("POTX1", (String)bomItem.get("POTX1"));
			table.setValue("UNAME", (String)bomItem.get("UNAME"));
			table.setValue("MAKTX2", (String)bomItem.get("MAKTX2"));
		}
		
		rfcManager.executeFunction(fn);
		rfcManager.executeLog(fn);
		
		JCoTable resultTable2 = fn.getTableParameterList().getTable("IT_RETURN2");
		String returnErrLog = "";
		for (int i = 0; i < resultTable2.getNumRows(); i++) {
			resultTable2.setRow(i);
			
			String POSNR = resultTable2.getString("POSNR");
			String IDNRK = resultTable2.getString("IDNRK");
			String MESS = resultTable2.getString("MESS");
			
			//String sapCode = IDNRK.substring(12);
			String sapCode = IDNRK; // 자리수 변경
			String posnr = POSNR;
			String message = MESS;
			
			String errStr = "["+posnr+"]" + sapCode + " - " + message;
			if(i == 0){
				returnErrLog = errStr;
			} else {
				returnErrLog += "\n"+errStr;
			}
		}
		logger.error(returnErrLog);
		
		JCoTable resultTable = fn.getTableParameterList().getTable("IT_RETURN");
		
		String STLAL = resultTable.getString("STLAL");
		String resultFlag = "F";
		String resultMessage = "";
		
		for (int i = 0; i < resultTable.getNumRows(); i++) {
			resultTable.setRow(i);
			/*JCoFieldIterator tableIterator = resultTable.getFieldIterator();
			while(tableIterator.hasNextField()){
				JCoField field = tableIterator.nextField();
				
				String fieldName = field.getName();
				String fieldValue = resultTable.getString(fieldName);
				
			}*/
			
			//String MANTR = String.valueOf(Integer.valueOf(resultTable.getString("MATNR")));
			
			resultFlag = resultTable.getString("COM");
			resultMessage = resultTable.getString("MESS");
			
			if(!resultFlag.equals("S")) {
				Map<String, String> resultMap = new HashMap<String, String>();
				resultMap.put("resultFlag", resultFlag);
				resultMap.put("resultMessage", resultMessage);
				resultMap.put("itemErrMessage", returnErrLog);
				
				return resultMap;
			}
		}
		
		
		Map<String, String> resultMap = new HashMap<String, String>();
		resultMap.put("STLAL", STLAL);
		resultMap.put("resultFlag", resultFlag);
		resultMap.put("resultMessage", resultMessage);
		resultMap.put("itemErrMessage", returnErrLog);
		
		return resultMap;
	}
	
	@Override
	public Map<String, String> updateBom(Map<String, Object> headerMap) {
		String companyCode = (String) headerMap.get("companyCode");
		
		JCoFunction fn = rfcManager.getFunction(companyCode, "ZPP_BOM_RFC2");
		JCoTable table = fn.getTableParameterList().getTable("GT_BOM");
		
		table.appendRow();
		
		table.setValue("MATNR", (String)headerMap.get("MATNR"));
		table.setValue("WERKS", (String)headerMap.get("WERKS"));
		table.setValue("STLAN", (String)headerMap.get("STLAN"));
		table.setValue("STLAL", (String)headerMap.get("STLAL"));
		table.setValue("ZTEXT", (String)headerMap.get("ZTEXT"));
		table.setValue("STKTX", (String)headerMap.get("STKTX"));
		table.setValue("BMENG", String.valueOf(headerMap.get("BMENG")));
		table.setValue("MAKTX2", (String)headerMap.get("MAKTX2"));
		
		rfcManager.executeFunction(fn);
		rfcManager.executeLog(fn);
		
		JCoTable resultTable = fn.getTableParameterList().getTable("IT_RETURN");
		String resultFlag = resultTable.getString("COM");
		String resultMessage = resultTable.getString("MESS");
		
		Map<String, String> resultMap = new HashMap<String, String>();
		
		resultMap.put("resultFlag", resultFlag);
		resultMap.put("resultMessage", resultMessage);
		
		return resultMap;
	}
	
	@Override
	public Map<String, String> updateBomItem(List<Map<String, Object>> bomItemList) {
		logger.debug("updateBomItem() - bomItemList.size(): " + bomItemList.size());
		System.out.println("updateBomItem() - bomItemList.size(): " + bomItemList.size());
		
		String companyCode = (String) bomItemList.get(0).get("companyCode");
		
		JCoFunction fn = rfcManager.getFunction(companyCode, "ZPP_BOM_RFC4");
		JCoTable table = fn.getTableParameterList().getTable("GT_BOM");
		
		System.out.println("RFC FUNCTION: ZPP_BOM_RFC4 Excuute Log");
		
		for (Map<String, Object> bomItem : bomItemList) {
			table.appendRow();
			
			table.setValue("MATNR", (String)bomItem.get("MATNR"));
			table.setValue("WERKS", (String)bomItem.get("WERKS"));
			table.setValue("STLAN", (String)bomItem.get("STLAN"));
			table.setValue("STLAL", (String)bomItem.get("STLAL"));
			table.setValue("ZTEXT", (String)bomItem.get("ZTEXT"));
			table.setValue("STKTX", (String)bomItem.get("STKTX"));
			table.setValue("BMENG", String.valueOf(bomItem.get("BMENG")));
			table.setValue("POSNR", (String)bomItem.get("POSNR"));
			table.setValue("IDNRK", (String)bomItem.get("IDNRK"));
			table.setValue("MENGE", (String)bomItem.get("MENGE"));
			table.setValue("MEINS", (String)bomItem.get("MEINS"));
			table.setValue("AUSCH", (String)bomItem.get("AUSCH"));
			table.setValue("SANFE", (String)bomItem.get("SANFE"));
			table.setValue("LGORT", (String)bomItem.get("LGORT"));
			table.setValue("POTX1", (String)bomItem.get("POTX1"));
			table.setValue("UNAME", (String)bomItem.get("UNAME"));
			table.setValue("MAKTX2", (String)bomItem.get("MAKTX2"));
		}
		
		rfcManager.executeFunction(fn);
		rfcManager.executeLog(fn);
		
		JCoTable resultTable2 = fn.getTableParameterList().getTable("IT_RETURN2");
		String returnErrLog = "";
		for (int i = 0; i < resultTable2.getNumRows(); i++) {
			resultTable2.setRow(i);
			
			String POSNR = resultTable2.getString("POSNR");
			String IDNRK = resultTable2.getString("IDNRK");
			String MESS = resultTable2.getString("MESS");
			
			//String sapCode = IDNRK.substring(12);
			String sapCode = IDNRK; // 자리수 변경
			String posnr = POSNR;
			String message = MESS;
			
			String errStr = "["+posnr+"]" + sapCode + " - " + message;
			if(i == 0){
				returnErrLog = errStr;
			} else {
				returnErrLog += "\n"+errStr;
			}
		}
		logger.error(returnErrLog);
		
		JCoTable resultTable = fn.getTableParameterList().getTable("IT_RETURN");
		String STLAL = "";
		String resultFlag = "";
		String resultMessage = "";
		if( resultTable.getNumRows() == 0 ) {
			resultFlag = "F";
			resultMessage = "변경된 내역이 없습니다.";
		} else {
			STLAL = resultTable.getString("STLAL");
			resultFlag = "F";
			resultMessage = "";
			for (int i = 0; i < resultTable.getNumRows(); i++) {
				resultTable.setRow(i);
				
				resultFlag = resultTable.getString("COM");
				resultMessage = resultTable.getString("MESS");
				
				if(!(resultFlag.equals("S") || resultFlag.equals("X"))) {
					Map<String, String> resultMap = new HashMap<String, String>();
					resultMap.put("resultFlag", resultFlag);
					resultMap.put("resultMessage", resultMessage);
					resultMap.put("itemErrMessage", returnErrLog);
					
					return resultMap;
				}
			}
		}
		
		Map<String, String> resultMap = new HashMap<String, String>();
		resultMap.put("STLAL", STLAL);
		resultMap.put("resultFlag", resultFlag);
		resultMap.put("resultMessage", resultMessage);
		resultMap.put("itemErrMessage", returnErrLog);
		
		return resultMap;
	}
}
