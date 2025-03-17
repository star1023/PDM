package kr.co.aspn.util;

import java.util.List;
import java.util.Map;

public class DataUtil {
	
	public static String keywordCheck(String keyword,List<Map<String,Object>> list) {
		String check ="";
		for (int i=0;i<list.size();i++){
			if (list.get(i).get("userId").equals(keyword)) check = (String)list.get(i).get("userName");	
		}
		return check;
	}

}
