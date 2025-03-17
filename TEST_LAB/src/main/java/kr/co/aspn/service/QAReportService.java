package kr.co.aspn.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.multipart.MultipartFile;

import kr.co.aspn.vo.QAReportVO;

public interface QAReportService {
	/* 인코딩 수정 */
	
	/**
	 * 품질 보고서 목록 + 카운트
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> selectQAReportListAndCount(Map<String, Object> param) throws Exception;
	
	/**
	 * 품질 보고서 상세
	 * @param rNo
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> selectQAReportDetail(int rNo) throws Exception;
	
	/**
	 * 품질 보고서 첨부파일 등록
	 * @return
	 * @throws Exception
	 */
	public boolean insertQAReportAttachFile(int rNo, List<MultipartFile> files) throws Exception;
	
	/**
	 * 품질 보고서 첨부파일 삭제
	 * @param rNo
	 * @return
	 * @throws Exception
	 */
	public boolean deleteQAReportAttachFile(int rNo, int fmNo, String fileName) throws Exception;
	
	/**
	 * 품질 보고서 등록
	 * @param qaReportVO
	 * @throws Exception
	 */
	public boolean insertQAReport(QAReportVO qaReportVO, HttpServletRequest request) throws Exception;
	
	/**
	 * 품질 보고서 수정
	 * @param qaReportVO
	 * @throws Exception
	 */
	public boolean updateQAReport(QAReportVO qaReportVO, HttpServletRequest request) throws Exception;
	
	/**
	 * 품질 보고서 삭제
	 * @param qaReportVO
	 * @return
	 * @throws Exception
	 */
	public boolean deleteQAReport(QAReportVO qaReportVO) throws Exception;
}