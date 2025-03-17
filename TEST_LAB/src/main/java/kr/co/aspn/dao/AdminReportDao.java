package kr.co.aspn.dao;

import java.util.HashMap;
import java.util.List;

public interface AdminReportDao {

    public List<HashMap<String, Object>> userListReport();

    List<HashMap<String,Object>> userLoginLogReport(HashMap<String, Object> param);

    List<HashMap<String,Object>> manufacturingProcessDocReport();
}
