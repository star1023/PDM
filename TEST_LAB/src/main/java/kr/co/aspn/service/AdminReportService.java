package kr.co.aspn.service;

import java.util.HashMap;
import java.util.List;

public interface AdminReportService {
    List<HashMap<String, Object>> userListReport();

    List<HashMap<String,Object>> userLoginLogReport(HashMap<String, Object> param);

    List<HashMap<String,Object>> manufacturingProcessDocReport();
}
