package kr.co.aspn.common.jco.vo;

import java.util.HashMap;
import java.util.List;

import com.sap.conn.jco.JCoFunction;

/**
 * @author will
 * SAP RFC 호출에 대한 기본 양식
 */
public interface LabRfcInterface {
	public HashMap<String, Object> execute(JCoFunction function);
	public HashMap<String, Object> execute(JCoFunction function, HashMap<String, String> importParameter);
	//public HashMap<String, Object> execute(JCoFunction function, HashMap<String, String> importParameter, HashMap<String, HashMap<String, String>> importTable);
	//public HashMap<String, Object> execute2(JCoFunction function, HashMap<String, String> importParameter, HashMap<String, List<HashMap<String, String>>> importTable);
}
