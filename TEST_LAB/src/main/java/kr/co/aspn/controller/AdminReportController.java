package kr.co.aspn.controller;


import kr.co.aspn.common.auth.AuthUtil;
import kr.co.aspn.service.AdminReportService;
import kr.co.aspn.util.TreeGridUtil;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;

@Controller
@RequestMapping("/AdminReport")
public class AdminReportController {

    private Logger logger = LoggerFactory.getLogger(AdminNoticeController.class);

    @Autowired
    AdminReportService adminReportService;

    // menu url

    /**
     * userList menu url
     * @param model
     * @return String
     * @throws Exception
     * @author guanghai.cui
     * @since 2023. 1. 9.
     */
    @RequestMapping("/userList")
    public String manageUserList(HttpServletRequest request,Model model) throws Exception {
        model.addAttribute("sessionId", AuthUtil.getAuth(request).getUserId());
        return "/AdminReport/userList";
    }

    /**
     * userList Layout
     * @param model
     * @return String
     * @throws Exception
     * @author guanghai.cui
     * @since 2023. 1. 9.
     */
    @RequestMapping("/userListLayout")
    public String userListLayout(@RequestParam("gridId") String gridId, Model model) throws Exception {
        model.addAttribute("gridId",gridId);
        return "/AdminReport/userListLayout";
    }

    /**
     * userList Grid data
     * @param model
     * @return String
     * @throws Exception
     * @author guanghai.cui
     * @since 2023. 1. 9.
     */
    @RequestMapping(value = "/userListData" , produces = {"application/xml;charset=UTF-8"})
    @ResponseBody
    public String userListData(Model model) throws Exception {
        List<HashMap<String, Object>> userList = new ArrayList<HashMap<String,Object>>();
        userList = adminReportService.userListReport();
        return TreeGridUtil.getGridListData(userList);
    }

    /**
     * Login log menu url
     * @param model
     * @return String
     * @throws Exception
     * @author guanghai.cui
     * @since 2023. 1. 11.
     */
    @RequestMapping("/userLoginLog")
    public String userLoginLog(HttpServletRequest request,Model model) throws Exception {
        model.addAttribute("sessionId", AuthUtil.getAuth(request).getUserId());

        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");

        Calendar cal_start = Calendar.getInstance();
        cal_start.add(Calendar.MONTH, -1);
        cal_start.set(Calendar.DAY_OF_MONTH,1);
        String startDt = format.format(cal_start.getTime());

        Calendar cal_end = Calendar.getInstance();
        cal_end.set(Calendar.DAY_OF_MONTH,1);
        String endDt = format.format(cal_end.getTime());

        model.addAttribute("startDt",startDt);
        model.addAttribute("endDt",endDt);

        return "/AdminReport/userLoginLog";
    }

    /**
     * Login log Layout
     * @param model
     * @return String
     * @throws Exception
     * @author guanghai.cui
     * @since 2023. 1. 11.
     */
    @RequestMapping("/userLoginLogLayout")
    public String userLoginLogLayout(@RequestParam("gridId") String gridId, Model model) throws Exception {
        model.addAttribute("gridId",gridId);
        return "/AdminReport/userLoginLogLayout";
    }

    /**
     * Login log Grid data
     * @param startDt, endDt
     * @return String
     * @throws Exception
     * @author guanghai.cui
     * @since 2023. 1. 11.
     */
    @RequestMapping(value = "/userLoginLogData" , produces = {"application/xml;charset=UTF-8"})
    @ResponseBody
    public String userLoginLogData(@RequestParam("startDt")String startDt, @RequestParam("endDt")String endDt) throws Exception {
        List<HashMap<String, Object>> userLoginLog = new ArrayList<HashMap<String,Object>>();
        HashMap<String,Object> param = new HashMap<String,Object>();
        param.put("startDt",startDt);
        param.put("endDt",endDt);
        userLoginLog = adminReportService.userLoginLogReport(param);
        return TreeGridUtil.getGridListData(userLoginLog);
    }

    /**
     * manufacturingProcessDoc List menu url
     * @param model
     * @return String
     * @throws Exception
     * @author guanghai.cui
     * @since 2023. 1. 12.
     */
    @RequestMapping("/manufacturingProcessDocList")
    public String manufacturingProcessDocList(HttpServletRequest request,Model model) throws Exception {
        model.addAttribute("sessionId", AuthUtil.getAuth(request).getUserId());
        return "/AdminReport/manufacturingProcessDocList";
    }

    /**
     * manufacturingProcessDoc Grid Layout
     * @param model
     * @return String
     * @throws Exception
     * @author guanghai.cui
     * @since 2023. 1. 12.
     */
    @RequestMapping("/manufacturingProcessDocListLayout")
    public String manufacturingProcessDocListLayout(@RequestParam("gridId") String gridId, Model model) throws Exception {
        model.addAttribute("gridId",gridId);
        return "/AdminReport/manufacturingProcessDocListLayout";
    }

    /**
     * manufacturingProcessDoc Grid data
     * @param model
     * @return String
     * @throws Exception
     * @author guanghai.cui
     * @since 2023. 1. 12.
     */
    @RequestMapping(value = "/manufacturingProcessDocListData" , produces = {"application/xml;charset=UTF-8"})
    @ResponseBody
    public String manufacturingProcessDocListData(Model model) throws Exception {
        List<HashMap<String, Object>> manufacturingProcessDocList = new ArrayList<HashMap<String,Object>>();
        manufacturingProcessDocList = adminReportService.manufacturingProcessDocReport();
        return TreeGridUtil.getGridListData(manufacturingProcessDocList);
    }
}
