package kr.co.aspn.util;

import java.util.Iterator;
import java.util.Map;

public class LogUtil {
	public static String logMapObject(Map<String, Object> map) {
		
		String logStr = " ====== logMapObject result ======";
		
		if(map == null) {
			return "paramter map is null";
		}
		
		Iterator<String> keyItr = map.keySet().iterator();
		while(keyItr.hasNext()) {
			String key = keyItr.next();
			String valueStr = String.valueOf(map.get(key));
			
			logStr += "\n ### " + key + ": " + valueStr;
		}
		
		return logStr;
	}
}


//Builder 개발서버 반영 원복 재실행을 위한 주석 추가