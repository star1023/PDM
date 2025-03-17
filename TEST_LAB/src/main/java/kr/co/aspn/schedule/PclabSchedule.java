package kr.co.aspn.schedule;

import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import kr.co.aspn.service.BatchService;
import kr.co.aspn.util.StringUtil;

public class PclabSchedule {
	private Logger logger = LoggerFactory.getLogger(PclabSchedule.class);
	
	//@Autowired
	//MaterialManagementService materialManagementService;
	
	@Autowired
	BatchService batchService;
	
	public void test() throws Exception {
		Calendar cal = Calendar.getInstance();
		System.err.println(cal.get(Calendar.YEAR)+"-"+cal.get(Calendar.MONTH)+"-"+cal.get(Calendar.DATE)+"  "+cal.get(Calendar.HOUR)+":"+cal.get(Calendar.MINUTE)+":"+cal.get(Calendar.SECOND)+" : 스케쥴러~~~~~~");
	}
}
