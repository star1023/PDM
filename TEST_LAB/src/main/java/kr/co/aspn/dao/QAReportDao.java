package kr.co.aspn.dao;

import java.util.List;
import java.util.Map;

import kr.co.aspn.vo.QAReportVO;

public interface QAReportDao {
	/* 인코딩 수정 */
	
	/**
	 * 품질 보고서 목록 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<QAReportVO> selectQAReportList(Map<String, Object> param) throws Exception;
	
	/**
	 * 품질 보고서 목록 카운트
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int selectQAReportCount(Map<String, Object> param) throws Exception;
	
	/**
	 * 품질 보고서 상세
	 * @param rNo
	 * @return
	 * @throws Exception
	 */
	public QAReportVO selectQAReportDetail(int rNo) throws Exception;
	
	/**
	 * 품질 보고서 등록
	 * @param qaReportVO
	 * @throws Exception
	 */
	public int insertQAReport(QAReportVO qaReportVO) throws Exception;
	
	/**
	 * 품질 보고서 수정
	 * @param qaReportVO
	 * @throws Exception
	 */
	public int updateQAReport(QAReportVO qaReportVO) throws Exception;
	
	/**
	 * 품질 보고서 삭제
	 * @param qaReportVO
	 * @return
	 * @throws Exception
	 */
	public int deleteQAReport(QAReportVO qaReportVO) throws Exception;
}