package kr.co.aspn.util;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public final class TreeGridUtil {
	
	/**
	 * TreeGrid list data xml 
	 * @author 
	 * @since 2023.01.09
	 * @param List<HashMap<String, Object>>
	 * @return String
	 * @throws Exception
	 */
	public static String getGridListData(List<HashMap<String, Object>> list) throws Exception {
		
		StringBuffer rtnXML = new StringBuffer("");
		rtnXML.append("<Grid>" );
		rtnXML.append("<Body>" );
		rtnXML.append("<B>");
		rtnXML.append(System.getProperty("line.separator"));
		for(HashMap<String, Object> rowData:list) {
			rtnXML.append("<I ");
			for(String key : rowData.keySet()){
				if(rowData.get(key) != null){
					rtnXML.append(key + "=\"" + rowData.get(key).toString().replaceAll("\"", "&quot;") + "\" ");
				}
			}
			rtnXML.append("/>");
			rtnXML.append(System.getProperty("line.separator"));
		}
		rtnXML.append("</B>");
		rtnXML.append("</Body>");
		rtnXML.append("</Grid>");
		
		return rtnXML.toString();
	}

	public static String getGridListData2(List<Map<String, Object>> list) throws Exception {

		StringBuffer rtnXML = new StringBuffer("");
		rtnXML.append("<Grid>" );
		rtnXML.append("<Body>" );
		rtnXML.append("<B>");
		rtnXML.append(System.getProperty("line.separator"));
		for(Map<String, Object> rowData:list) {
			rtnXML.append("<I ");
			for(String key : rowData.keySet()){
				if(rowData.get(key) != null){
					rtnXML.append(key + "=\"" + rowData.get(key).toString().replaceAll("\"", "&quot;") + "\" ");
				}
			}
			rtnXML.append("/>");
			rtnXML.append(System.getProperty("line.separator"));
		}
		rtnXML.append("</B>");
		rtnXML.append("</Body>");
		rtnXML.append("</Grid>");

		return rtnXML.toString();
	}
	
	public static String getGridTreeData(List<HashMap<String, Object>> list) throws Exception {
		
		StringBuffer rtnXML = new StringBuffer("");
		rtnXML.append("<Grid>" );
		rtnXML.append("<Body>" );
		rtnXML.append("<B>" );
		rtnXML.append(System.getProperty("line.separator"));
		int nodeCnt = 0;
		int cur_lvl = 0;
		int nex_lvl = 0;
		for(HashMap<String, Object> rowData:list) {
			nodeCnt = 0;
			rtnXML.append("<I ");
			for(String key : rowData.keySet()){
				rtnXML.append(key + "=\"" + rowData.get(key).toString().replaceAll("\"", "&quot;") + "\"");
			}
			cur_lvl = Integer.parseInt(rowData.get("CUR_LVL").toString());
			nex_lvl = Integer.parseInt(rowData.get("NEXT_LVL").toString());
			
			if(cur_lvl == nex_lvl){
				rtnXML.append("></I>");
			}
			else if(cur_lvl < nex_lvl){
				rtnXML.append("CanExpand='1' Expanded='1'>");
			}
			else if(cur_lvl > nex_lvl){
				rtnXML.append("></I>");
			}
			nodeCnt = cur_lvl - nex_lvl;
			for(int i=0; i<nodeCnt; i++){
				rtnXML.append("</I>");
			}
			rtnXML.append(System.getProperty("line.separator"));
		}
		rtnXML.append("</B>");
		rtnXML.append("</Body>");
		rtnXML.append("</Grid>");
		
		return rtnXML.toString();
	}
	
}