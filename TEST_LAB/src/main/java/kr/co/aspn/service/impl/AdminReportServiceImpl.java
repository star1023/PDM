package kr.co.aspn.service.impl;

import kr.co.aspn.dao.AdminReportDao;
import kr.co.aspn.service.AdminReportService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;

@Service
public class AdminReportServiceImpl implements AdminReportService {

    @Autowired
    AdminReportDao adminReportDao;

    /**
     * userList Gird Data
     * @param
     * @return List
     * @throws Exception
     * @author guanghai.cui
     * @since 2023. 1. 9.
     */
    @Override
    public List<HashMap<String, Object>> userListReport(){
        return adminReportDao.userListReport();
    }

    /**
     * Login log Grid Data
     * @param param
     * @return List
     * @throws Exception
     * @author guanghai.cui
     * @since 2023. 1. 11.
     */
    @Override
    public List<HashMap<String,Object>> userLoginLogReport(HashMap<String, Object> param){
        return adminReportDao.userLoginLogReport(param);
    }

    /**
     * manufacturingProcessDoc Gird data
     * @param
     * @return List
     * @throws Exception
     * @author guanghai.cui
     * @since 2023. 1. 12.
     */
    @Override
    public List<HashMap<String,Object>> manufacturingProcessDocReport(){
        return adminReportDao.manufacturingProcessDocReport();
    }
}
