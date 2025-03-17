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
import kr.co.aspn.dao.RfcDao;

@Repository("rfcRepo")
public class RfcDaoImpl implements RfcDao {
	Logger logger = LoggerFactory.getLogger(RfcDaoImpl.class);
	
	private final static String TYPE_IMPORT = "import";
	private final static String TYPE_EXPORT = "export";
	
	@Autowired
	LabRfcManager rfcManager;
	
	@Override
	public Map<String, Object> getBomListOfMaterial(Map<String, Object> param) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		String companyCode = (String)param.get("companyCode");
		String plantCode = (String)param.get("plantCode");
		String preSapCode = (String)param.get("preSapCode");
		
		JCoFunction fn = rfcManager.getFunction(companyCode, "ZPP_BOM_RFC6");
		
		fn.getImportParameterList().setValue("I_WERKS", plantCode);
		fn.getImportParameterList().setValue("I_IDNRK", preSapCode);
		
		rfcManager.executeFunction(fn);
		rfcManager.executeLog(fn);
		
		resultMap.put("import", jcoInExportParamListToMap(fn, TYPE_IMPORT));
		resultMap.put("export", jcoInExportParamListToMap(fn, TYPE_EXPORT));
		resultMap.put("tables", jCoTableParameterListToListMap(fn));

	    return resultMap;
	}
	
	@Override
	public Map<String, Object> changeBomItem(Map<String, Object> param) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		String companyCode = (String)param.get("companyCode");
		
		//List<String> MATNR_LIST = (List<String>)param.get("IT_MATNR");
		List<Map<String, Object>> tableItem = (List<Map<String, Object>>)param.get("IT_MATNR");
		
		String I_MATNR_B = (String)param.get("I_MATNR_B");
		String I_MATNR_A = (String)param.get("I_MATNR_A");
		String I_WERKS = (String)param.get("I_WERKS");
		
		JCoFunction fn = rfcManager.getFunction(companyCode, "ZPP_BOM_RFC7");
		
		fn.getImportParameterList().setValue("I_WERKS", I_WERKS);
		fn.getImportParameterList().setValue("I_MATNR_B", I_MATNR_B);
		fn.getImportParameterList().setValue("I_MATNR_A", I_MATNR_A);
		
		JCoTable IT_MATNR = fn.getTableParameterList().getTable("IT_MATNR");
		IT_MATNR.appendRows(tableItem.size());
		for (int i = 0; i < tableItem.size(); i++) {
			String MATNR = (String)tableItem.get(i).get("MATNR");
			String STLAL = (String)tableItem.get(i).get("STLAL");
			
			IT_MATNR.setRow(i);
			IT_MATNR.setValue("MATNR", MATNR);
			IT_MATNR.setValue("STLAL", STLAL);
		}
		
		rfcManager.executeFunction(fn);
		rfcManager.executeLog(fn);
		
		resultMap.put("import", jcoInExportParamListToMap(fn, TYPE_IMPORT));
		resultMap.put("export", jcoInExportParamListToMap(fn, TYPE_EXPORT));
		resultMap.put("tables", jCoTableParameterListToListMap(fn));
		
		return resultMap;
	}
	
	private static Map<String, Object> jcoInExportParamListToMap(JCoFunction function, String type) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		Iterator<JCoField> jCoFieldIterator = null;
		
		/*switch (type) {
		case TYPE_IMPORT:
			if (function.getExportParameterList() == null) return null;
			jCoFieldIterator = function.getImportParameterList().iterator();
			break;
		case TYPE_EXPORT:
			if (function.getExportParameterList() == null) return null;
			jCoFieldIterator = function.getExportParameterList().iterator();
			break;
		default:
			return null;
		}*/
		if( type != null && TYPE_IMPORT.equals(type) ) {
			if (function.getExportParameterList() == null) return null;
			jCoFieldIterator = function.getImportParameterList().iterator();
		} else if( type != null && TYPE_EXPORT.equals(type) ){
			if (function.getExportParameterList() == null) return null;
			jCoFieldIterator = function.getExportParameterList().iterator();
		} else {
			return null;
		}
		
		while (jCoFieldIterator.hasNext()) {
			JCoField jCoField = jCoFieldIterator.next();
			String fieldName = jCoField.getName();
			String fieldValue = String.valueOf(jCoField.getValue());
			
			resultMap.put(fieldName, fieldValue);
		}
		return resultMap;
	}
	
	public static Map<String, List<Map<String, Object>>> jCoTableParameterListToListMap(JCoFunction function) {
		Map<String, List<Map<String, Object>>> resultMap = new HashMap<String, List<Map<String, Object>>>();

		if (function.getTableParameterList() == null)
			return null;

		Iterator<JCoField> jCoTableIterator = function.getTableParameterList().iterator();

		while (jCoTableIterator.hasNext()) {
			List<Map<String, Object>> tableData = new ArrayList<Map<String, Object>>();
			JCoField jCoTableField = jCoTableIterator.next();
			String tableName = jCoTableField.getName();

			JCoTable jCoTable = function.getTableParameterList().getTable(tableName);
			for (int i = 0; i < jCoTable.getNumRows(); i++) {
				Map<String, Object> tableParameterMap = new HashMap<String, Object>();

				jCoTable.setRow(i);
				Iterator<JCoField> jCoTableFieldIterator = jCoTable.iterator();
				while (jCoTableFieldIterator.hasNext()) {
					JCoField jCoField = jCoTableFieldIterator.next();
					String fieldName = jCoField.getName();
					String fieldValue = jCoTable.getString(fieldName);

					tableParameterMap.put(fieldName, fieldValue);
				}
				tableData.add(tableParameterMap);
			}
			resultMap.put(tableName, tableData);
		}

		return resultMap;
	}
	
}