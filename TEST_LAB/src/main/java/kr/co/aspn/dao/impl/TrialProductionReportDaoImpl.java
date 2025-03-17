package kr.co.aspn.dao.impl;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.aspn.dao.TrialProductionReportDao;
import kr.co.aspn.vo.PlantLineVO;
import kr.co.aspn.vo.TrialProductionReportVO;
import kr.co.aspn.vo.TrialReportComment;
import kr.co.aspn.vo.TrialReportHeader;

/**
 * ��ǰ���߹��� > �û��� ����
 * @author JAEOH
 */

@Repository
public class TrialProductionReportDaoImpl implements TrialProductionReportDao {
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	/**
	 * �û��� ���� ����Ʈ
	 */
	@Override
	public List<TrialProductionReportVO> selectTrialProductionReportList(Map<String, Object> param) throws Exception {
		return sqlSessionTemplate.selectList("trialProductionReport.selectTrialProductionReportList", param);
	}

	/**
	 * �û��� ���� ī��Ʈ
	 */
	@Override
	public int selectTrialProductionReportCount(Map<String, Object> param) throws Exception {
		return sqlSessionTemplate.selectOne("trialProductionReport.selectTrialProductionReportCount", param);
	}
	
	/**
	 * �û��� ���� ��
	 */
	@Override
	public TrialProductionReportVO selectTrialProductionReportDetail(int rNo) throws Exception {
		return sqlSessionTemplate.selectOne("trialProductionReport.selectTrialProductionReportDetail", rNo);
	}
	
	/**
	 * �����ڵ� �̸� ��������
	 */
	@Override
	public PlantLineVO selectLineDetailFromPlantLine(Map<String, Object> param) throws Exception {
		return sqlSessionTemplate.selectOne("trialProductionReport.selectLineDetailFromPlantLine", param);
	}

	/**
	 * �û��� ���� ���
	 */
	@Override
	public int insertTrialProductionReport(TrialProductionReportVO trialProductionReportVO) throws Exception {
		return sqlSessionTemplate.insert("trialProductionReport.insertTrialProductionReport", trialProductionReportVO);
	}

	/**
	 * �û��� ���� ����
	 */
	@Override
	public int updateTrialProductionReport(TrialProductionReportVO trialProductionReportVO) throws Exception {
		return sqlSessionTemplate.update("trialProductionReport.updateTrialProductionReport", trialProductionReportVO);
	}
	
	/**
	 * �û��� ���� ���� ����
	 */
	@Override
	public int updateTrialProductionReportState(TrialProductionReportVO trialProductionReportVO) throws Exception {
		return sqlSessionTemplate.update("trialProductionReport.updateTrialProductionReportState", trialProductionReportVO);
	}

	/**
	 * �û��� ���� ����
	 */
	@Override
	public int deleteTrialProductionReport(TrialProductionReportVO trialProductionReportVO) throws Exception {
		return sqlSessionTemplate.delete("trialProductionReport.deleteTrialProductionReport", trialProductionReportVO);
	}
	
	/**
	 * �û��� ���� ī��Ʈ(Ư�� ����������)
	 */
	@Override
	public int getTrialDocumentCnt(Map<String, Object> param) {
		return sqlSessionTemplate.selectOne("trialProductionReport.getTrialDocumentCnt", param);
	}

}