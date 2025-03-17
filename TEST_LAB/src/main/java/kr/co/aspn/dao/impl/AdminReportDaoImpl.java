package kr.co.aspn.dao.impl;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.aspn.dao.AdminReportDao;

import java.util.HashMap;
import java.util.List;

@Repository
public class AdminReportDaoImpl implements AdminReportDao {

    @Autowired
    private SqlSessionTemplate sqlSessionTemplate;

    /**
     * userList Gird Data
     * @param
     * @return List
     * @throws Exception
     * @author guanghai.cui
     * @since 2023. 1. 9.
     */
    @Override
    public List<HashMap<String, Object>> userListReport() {
        return sqlSessionTemplate.selectList("adminreport.userListReport");
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
        return sqlSessionTemplate.selectList("adminreport.userLoginLogReport",param);
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
        return sqlSessionTemplate.selectList("adminreport.manufacturingProcessDocReport");
    }
}
