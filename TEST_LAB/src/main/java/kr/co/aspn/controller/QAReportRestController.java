package kr.co.aspn.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import kr.co.aspn.service.FileService;
import kr.co.aspn.service.QAReportService;
import kr.co.aspn.vo.QAReportVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping(value = "/qareport")
public class QAReportRestController {
	/* 인코딩 수정 */
	
	@Autowired
	private QAReportService qaReportService;
	
	@Autowired
	private FileService fileService;
	
	/**
	 * 품질 보고서 목록 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/selectListAndCount", method = RequestMethod.GET )
	public Map<String, Object> selectQAReportList(@RequestParam Map<String, Object> param) throws Exception {
		log.debug("[RestController] selectListAndCount Paramters : {}", param.toString());
		return qaReportService.selectQAReportListAndCount(param);
	}
	
	/**
	 * 품질 보고서 상세
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/selectQAReportDetail", method = RequestMethod.GET )
	public Map<String, Object> selectQAReportDetail(@RequestParam Map<String, Object> param) throws Exception {
		log.debug("[RestController] selectQAReportDetail Paramters : {}", param.toString());
		
		int rNo = 0;
		try {
			rNo = Integer.parseInt( param.get("rNo") + "" );
		}catch(NumberFormatException _ex){
			_ex.printStackTrace();
			return null;
		}
		return qaReportService.selectQAReportDetail( rNo );
	}
	
	/**
	 * 품질 보고서 등록
	 * @param qaReportVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/insertQAReport", method = RequestMethod.POST )
	public boolean insertQAReport(QAReportVO qaReportVO, HttpServletRequest request) throws Exception {
		log.debug("[RestController] insertQAReport Paramters : {}", qaReportVO.toString());
		return qaReportService.insertQAReport(qaReportVO, request);
	}
	
	/**
	 * 품질보고서 수정
	 * @param qaReportVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/updateQAReport", method = RequestMethod.POST )
	public boolean updateQAReport(QAReportVO qaReportVO, HttpServletRequest request) throws Exception {
		log.debug("[RestController] updateQAReport Paramters : {}", qaReportVO.toString());
		return qaReportService.updateQAReport(qaReportVO, request);
	}
	
	/**
	 * 품질 보고서 삭제
	 * @param qaReportVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/deleteQAReport", method = RequestMethod.DELETE )
	public boolean deleteQAReport(@RequestBody QAReportVO qaReportVO) throws Exception {
		log.debug("[RestController] deleteQAReport Paramters : {}", qaReportVO.toString());
		return qaReportService.deleteQAReport(qaReportVO);
	}
}