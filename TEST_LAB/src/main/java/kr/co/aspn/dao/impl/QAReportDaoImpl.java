package kr.co.aspn.dao.impl;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.aspn.dao.QAReportDao;
import kr.co.aspn.vo.QAReportVO;

@Repository
public class QAReportDaoImpl implements QAReportDao {
	/* 인코딩 수정 */
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	/**
	 * 품질 보고서 목록 조회
	 */
	@Override
	public List<QAReportVO> selectQAReportList(Map<String, Object> param) throws Exception {
		return sqlSessionTemplate.selectList("qareport.selectQAReportList", param);
	}
	
	/**
	 * 품질 보고서 목록 카운트
	 */
	@Override
	public int selectQAReportCount(Map<String, Object> param) throws Exception {
		return sqlSessionTemplate.selectOne("qareport.selectQAReportCount", param);
	}
	
	/**
	 * 품질 보고서 상세
	 */
	@Override
	public QAReportVO selectQAReportDetail(int rNo) throws Exception {
		return sqlSessionTemplate.selectOne("qareport.selectQAReportDetail", rNo);
	}
	
	/**
	 * 품질 보고서 등록
	 */
	@Override
	public int insertQAReport(QAReportVO qaReportVO) throws Exception {
		return sqlSessionTemplate.insert("qareport.insert", qaReportVO);
	}
	
	/**
	 * 품질 보고서 수정
	 */
	@Override
	public int updateQAReport(QAReportVO qaReportVO) throws Exception {
		return sqlSessionTemplate.update("qareport.update", qaReportVO);
	}
	
	/**
	 * 품질 보고서 삭제
	 */
	@Override
	public int deleteQAReport(QAReportVO qaReportVO) throws Exception {
		return sqlSessionTemplate.delete("qareport.delete", qaReportVO);
	}
}