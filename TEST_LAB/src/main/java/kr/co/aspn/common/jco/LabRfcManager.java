package kr.co.aspn.common.jco;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.poi.hwpf.dev.FieldIterator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import com.sap.conn.jco.JCoDestination;
import com.sap.conn.jco.JCoDestinationManager;
import com.sap.conn.jco.JCoException;
import com.sap.conn.jco.JCoField;
import com.sap.conn.jco.JCoFieldIterator;
import com.sap.conn.jco.JCoFunction;
import com.sap.conn.jco.JCoParameterList;
import com.sap.conn.jco.JCoTable;

import kr.co.aspn.common.jco.vo.LabRfcInterface;

@Component
public class LabRfcManager implements LabRfcInterface {
	private static Logger log = LoggerFactory.getLogger(LabRfcManager.class);
	private static LabDestDataProvider provider = new LabDestDataProvider();
	
	public LabDestDataProvider getProvider() {
		return provider;
	}

	public void executeCalls() {
		String destName = provider.getDestinationName();
		JCoDestination dest = provider.getMyDestination(destName);
		
		//log.error("Destination " + destName);
		try {
			dest = JCoDestinationManager.getDestination(destName);
			//log.error("getDestinationName() : " + dest.getDestinationName());
			JCoFunction fn = dest.getRepository().getFunctionTemplate("RFC_FUNCTION_SEARCH").getFunction();
			//log.error(fn.getImportParameterList().getMetaData().toString());
			//log.error("Destination " + destName + " works");
		} catch (JCoException e) {
			e.printStackTrace();
			System.out.println("Execution on destination " + destName + " failed");
		}
	}
	
	public JCoFunction getFunction(String destnationName, String functionName){
		JCoFunction function;
		
		if(destnationName != provider.getDestinationName())
			provider.setLabDestination(destnationName);
		
		try {
			function = provider.getMyDestination(destnationName).getRepository().getFunction(functionName);
			return function;
		} catch (JCoException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		}
	}

	@Override
	public HashMap<String, Object> execute(JCoFunction function) {
		String logStr = "[RFC Function Log] execute(function) calling / Function: " + function.getName();
		boolean executeError = false;
		
		HashMap<String, Object> rfcResult = new HashMap<String, Object>();
		
		try {
			function.execute(provider.getLabDestnation());
			
			logStr += "\n\n\t " + function.getName() +"'s export parameter data";
			//logStr = getExportData(function, logStr);
			//logStr = getExportTableData(function, logStr);
			HashMap<String, String> exportData = getExportData(function);
			Map<String, List<Map<String, String>>> exportTableData = getExportTableData(function);
			
			rfcResult.put("exportData", exportData);
			rfcResult.put("exportTableData", exportTableData);
			
		} catch (JCoException e) {
			e.printStackTrace();
			executeError = true;
		} finally {
			//log.error(logStr);
			if(executeError)
				log.error(function.getName() +"'s Execute Error");
		}
		
		log.error(logStr);
		
		return rfcResult;
	}

	@Override
	public HashMap<String, Object> execute(JCoFunction function, HashMap<String, String> importParameter) {
		boolean executeError = false;
		
		setImportData(function, importParameter);
		
		HashMap<String, Object> rfcResult = new HashMap<String, Object>();
		
		try {
			function.execute(provider.getLabDestnation());
			
			HashMap<String, String> exportData = getExportData(function);
			Map<String, List<Map<String, String>>> exportTableData = getExportTableData(function);
			
			rfcResult.put("exportData", exportData);
			rfcResult.put("exportTableData", exportTableData);
		} catch (JCoException e) {
			e.printStackTrace();
			executeError = true;
		} finally {
			if(executeError)
				log.error(function.getName() +"'s Execute Error");
		}
		
		return rfcResult;
	}

	/*@Override
	public HashMap<String, Object> execute(JCoFunction function
			, HashMap<String, String> importParameter
			, HashMap<String, HashMap<String, String>> importTable) {
		
		String logStr = "[RFC Function Log] execute(function, importParameter) calling / Function: " + function.getName();
		boolean executeError = false;
		
		//logStr = setImportData(function, importParameter, logStr);
		//logStr = setImportTable(function, importTable, logStr);
		setImportData(function, importParameter);
		setImportTable(function, importTable);
		
		HashMap<String, Object> rfcResult = new HashMap<String, Object>();
		
		try {
			function.execute(provider.getLabDestnation());
			
			HashMap<String, String> exportData = getExportData(function);
			Map<String, List<Map<String, String>>> exportTableData = getExportTableData(function);
			
			rfcResult.put("exportData", exportData);
			rfcResult.put("exportTableData", exportTableData);
				
		} catch (JCoException e) {
			e.printStackTrace();
			executeError = true;
		} finally {
			//log.error(logStr);
			if(executeError)
				log.error(function.getName() +"'s Execute Error");
		}
		
		return rfcResult;
	}*/

	private void setImportData(JCoFunction function, HashMap<String, String> importParameter){
		String setImportDataLog = "\t " + function.getName() +"'s import parameter data";
		if(function.getImportParameterList() != null){
			JCoParameterList importParameterList = function.getImportParameterList();
			JCoFieldIterator importParamterIterator = importParameterList.getFieldIterator();
			
			//logStr += "\n\t " + function.getName() +"'s import parameter data";
			while(importParamterIterator.hasNextField()){
				JCoField field = importParamterIterator.nextField();
				if(importParameter.keySet().contains(field.getName())){
					importParameterList.setValue(field.getName(), importParameter.get(field.getName()));
					//logStr += "\n ==> Parameter: " + field.getName() + ", UserImportValue: " + importParameter.get(field.getName());
					setImportDataLog += "\n ==> Parameter: " + field.getName() + ", UserImportValue: " + importParameter.get(field.getName());
				} else {
					//importParameterList.setValue(field.getName(), "");
					//logStr += "\n ==> Parameter: " + field.getName() + ", UserImportValue: 'Not exsist matched data'";
					setImportDataLog += "\n ==> Parameter: " + field.getName() + ", UserImportValue: 'Not exsist matched data'";
				}
			}
		} else {
			//logStr += "\n\t " + function.getName() +"' has no import parameter metadata";
			setImportDataLog += "\n\t " + function.getName() +"' has no import parameter metadata";
		}
		//log.error(setImportDataLog);
		//return logStr;
	}
	
	private void setImportTable(JCoFunction function, HashMap<String, List<HashMap<String, String>>> importTable){
		String setImportTableLog = "";
		
		if(function.getTableParameterList() != null){
			JCoParameterList importTableParameterList = function.getTableParameterList();
			JCoFieldIterator importTableParamterIterator = importTableParameterList.getFieldIterator();
			
			//logStr += "\n\n\t " + function.getName() +"'s improt table parameter data";
			setImportTableLog += "\t " + function.getName() +"'s improt table parameter data";
			while(importTableParamterIterator.hasNextField()){
				JCoField importTableParameter = importTableParamterIterator.nextField();
				String importTableName = importTableParameter.getName();
				
				if(importTable.keySet().contains(importTableName)){
					List<HashMap<String, String>> importTableList = importTable.get(importTableName);
					JCoTable jCoTable = function.getTableParameterList().getTable(importTableName);
					jCoTable.appendRows(importTableList.size());
					for( int i = 0 ; i < importTableList.size() ; i++ ) {
						//if( i != 0 ) { jCoTable.nextRow(); }
						jCoTable.setRow(i);
						
						HashMap<String, String> importData = importTableList.get(i);
						Iterator<String> keys = importData.keySet().iterator();
				    	while( keys.hasNext() ){
					        String key = keys.next();
					        String value = importData.get(key);
					        jCoTable.setValue(key, value);
				        }
					}
				}
			}
		} else {
			//logStr += "\n\t " + function.getName() +"' has no table parameter metadata";
			setImportTableLog += "\n\t " + function.getName() +"' has no table parameter metadata";
		}
		//log.error(setImportTableLog);
		//return logStr;
	}
	
	private HashMap<String, String> getExportData(JCoFunction function){
		String exportDataLog = "\t " + function.getName() +"'s export parameter data";
		HashMap<String, String> exportDataMap = new HashMap<String, String>();
		if(function.getExportParameterList() != null){
			JCoParameterList exportParameterList = function.getExportParameterList();
			JCoFieldIterator exportParameterIterator = function.getExportParameterList().getFieldIterator();
			while(exportParameterIterator.hasNextField()){
				JCoField field = exportParameterIterator.nextField();
				
				//exportDataLog+= "\n ==> Parameter: " + field.getName() + ", Value: " + exportParameterList.getString(field.getName());
				exportDataLog+= "\n ==> Parameter: " + field.getName() + ", Value: " + exportParameterList.getString(field.getName());
				exportDataMap.put(field.getName(), exportParameterList.getString(field.getName()));
			}
			log.error(exportDataLog);
			return exportDataMap;
		} else {
			log.error(exportDataLog);
			return null;
		}
		
	}
	
	private Map<String, List<Map<String, String>>> getExportTableData(JCoFunction function) {
		
		String exportTableDataLog = "\t " + function.getName() +"'s export table parameter data";
		Map<String, List<Map<String, String>>> exportTableData = new HashMap<String, List<Map<String, String>>>();
		if(function.getTableParameterList() != null){
			JCoParameterList exportTableParameterList = function.getTableParameterList();
			JCoFieldIterator exportTableParameterIterator = exportTableParameterList.getFieldIterator();
			
			exportTableDataLog += "\n\n\t " + function.getName() +"'s export table parameter data";
			
			while(exportTableParameterIterator.hasNextField()){				
				List<Map<String, String>> talbeRows = new ArrayList<Map<String, String>>();
				JCoField exportTableParameter = exportTableParameterIterator.nextField();
				String exportTableName = exportTableParameter.getName();
				JCoTable jCoTable = function.getTableParameterList().getTable(exportTableName);
				
				
				//exportTableDataLog += "\n\t\t " + function.getName() + "'s Talbe : " + exportTableName;
				//exportTableDataLog += "\n\t " + function.getName() + "'s Talbe : " + exportTableName;
				int tableRowCnt = 0;
				if(jCoTable.getNumRows() > 0) {
					for( int i = 0 ; i < jCoTable.getNumRows() ; i++ ) {
						Iterator<JCoField> tableIterator = jCoTable.iterator();
					
						if(tableRowCnt != 0){
							exportTableDataLog += "\n";
						}
						
						//logStr += "\n\t\t [" + exportTableName + "]'s data Row : " + tableRowCnt;
						//exportTableDataLog += "\n\t\t [" + exportTableName + "]'s data Row : " + tableRowCnt;
						exportTableDataLog += "\n\t\t [" + exportTableName + "]'s data Row : " + i;
						Map<String ,String> tableParameter = new HashMap<String ,String>();
						jCoTable.setRow(i);
						while(tableIterator.hasNext()){
							JCoField tableField = tableIterator.next();
							
							//logStr+= "\n\t\t ==> Field: " + tableField.getName() + ", Value: " + jCoTable.getString(tableField.getName());
							exportTableDataLog+= "\n\t\t ==> Field: " + tableField.getName() + ", Value: " + jCoTable.getString(tableField.getName());
							tableParameter.put(tableField.getName(), jCoTable.getString(tableField.getName()));						
						}
						talbeRows.add(tableParameter);
					}
				} else {
					//logStr += "\n\t\t [" + exportTableName + "] not returned any data.";
					exportTableDataLog += "\n\t\t [" + exportTableName + "] not returned any data.";
				}
				
				exportTableData.put(exportTableName, talbeRows);
			}
			log.error(exportTableDataLog);
			//System.err.println(exportTableDataLog);
			return exportTableData;
		} else {
			//System.err.println(exportTableDataLog);
			log.error(exportTableDataLog);
			return null;
		}
	}
/*
	@Override
	public HashMap<String, Object> execute2(JCoFunction function, HashMap<String, String> importParameter,
			HashMap<String, List<HashMap<String, String>>> importTable) {
		// TODO Auto-generated method stub
		String logStr = "[RFC Function Log] execute(function, importParameter) calling / Function: " + function.getName();
		boolean executeError = false;
		
		//logStr = setImportData(function, importParameter, logStr);
		//logStr = setImportTable(function, importTable, logStr);
		setImportData(function, importParameter);
		setImportTableList(function, importTable);
		
		HashMap<String, Object> rfcResult = new HashMap<String, Object>();
		
		try {
			function.execute(provider.getLabDestnation());
			
			HashMap<String, String> exportData = getExportData(function);
			Map<String, List<Map<String, String>>> exportTableData = getExportTableData(function);
			
			rfcResult.put("exportData", exportData);
			rfcResult.put("exportTableData", exportTableData);
				
		} catch (JCoException e) {
			e.printStackTrace();
			executeError = true;
		} finally {
			//log.error(logStr);
			if(executeError)
				log.error(function.getName() +"'s Execute Error");
		}
		
		return rfcResult;
	}
	*/
	public JCoFunction executeFunction(JCoFunction fn){
		JCoDestination dest = provider.getLabDestnation();
		
		//System.out.println("dest.getDestinationName() : " + dest.getDestinationName());
		
		try {
			fn.execute(dest);
		} catch (JCoException e) {
			e.printStackTrace();
		}
		
		return fn;
	}
	
	public void executeLog(JCoFunction fn){
		JCoParameterList importParameterList = fn.getImportParameterList();
		JCoParameterList exportParameterList = fn.getExportParameterList();
		JCoParameterList tableParameterList = fn.getTableParameterList();
		
		String logStr = " === RFC Function: " + fn.getName() + " execute log === ";
		
		if(importParameterList != null){
			
			logStr += "\n\t # import Data log";
			
			JCoFieldIterator importIterator =  importParameterList.getFieldIterator();
			while(importIterator.hasNextField()){
				JCoField importParam = importIterator.nextField();
				
				String paramKey = importParam.getName();
				String paramValue = importParameterList.getString(paramKey);
				
				logStr += "\nimport param " + paramKey + ": " + paramValue;
			}
		}
		
		if(exportParameterList != null){
			logStr += "\n\t # export Data log";
			
			JCoFieldIterator exportIterator =  exportParameterList.getFieldIterator();
			while(exportIterator.hasNextField()){
				JCoField exportParam = exportIterator.nextField();
				
				String paramKey = exportParam.getName();
				String paramValue = exportParameterList.getString(paramKey);
				
				logStr += "\nexport param " + paramKey + ": " + paramValue;
			}
		}
		
		if(tableParameterList != null){
			logStr += "\n\t # table Data log";
			
			JCoFieldIterator tableIterator =  tableParameterList.getFieldIterator();
			
			ArrayList<String> tableList = new ArrayList<String>();
			while(tableIterator.hasNextField()){
				JCoField tableParam = tableIterator.nextField();
				
				String tableName = tableParam.getName();
				
				JCoTable table = tableParameterList.getTable(tableName);
				logStr += "\nJcoTable: " + tableName;
				
				for (int i = 0; i < table.getNumRows(); i++) {
					table.setRow(i);
					
					JCoFieldIterator tableParamIterator = table.getFieldIterator();
					while (tableParamIterator.hasNextField()) {
						JCoField tableParameter = tableParamIterator.nextField();
						
						String tableParameterName = tableParameter.getName();
						String tableParameterValue = table.getString(tableParameterName);
						
						logStr += "\n\t table: " + tableName + "["+(i+1)+"/"+table.getNumRows()+"] " + tableParameterName + ": " + tableParameterValue;
					}
				} 
			}
		}
		log.error(logStr);
		//System.out.println(logStr);
	}
}


//<!-- Builder 개발서버 반영 원복 재실행을 위한 주석 추가 -->