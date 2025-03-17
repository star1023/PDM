package kr.co.aspn.dao;

import java.util.List;
import java.util.Map;

import kr.co.aspn.vo.PlantLineVO;
import kr.co.aspn.vo.TrialProductionReportVO;
import kr.co.aspn.vo.TrialReportComment;
import kr.co.aspn.vo.TrialReportHeader;

/**
 * ��ǰ���߹��� > �û��� ����
 * @author JAEOH
 */

public interface TrialProductionReportDao {
	
	/**
	 * �û��� ���� ����Ʈ
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<TrialProductionReportVO> selectTrialProductionReportList(Map<String, Object> param) throws Exception;
	
	/**
	 * �û��� ���� ī��Ʈ
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int selectTrialProductionReportCount(Map<String, Object> param) throws Exception;
	
	/**
	 * �û��� ���� ��
	 * @param rNo
	 * @return
	 * @throws Exception
	 */
	public TrialProductionReportVO selectTrialProductionReportDetail(int rNo) throws Exception;
	
	/**
	 * �����ڵ� �̸� ��������
	 * @param lineCode
	 * @return
	 * @throws Exception
	 */
	public PlantLineVO selectLineDetailFromPlantLine(Map<String, Object> param) throws Exception;
	
	/**
	 * �û��� ���� ���
	 * @param trialProductionReportVO
	 * @return
	 * @throws Exception
	 */
	public int insertTrialProductionReport(TrialProductionReportVO trialProductionReportVO) throws Exception;
	
	/**
	 * �û��� ���� ����
	 * @param trialProductionReportVO
	 * @return
	 * @throws Exception
	 */
	public int updateTrialProductionReport(TrialProductionReportVO trialProductionReportVO) throws Exception;
	
	/**
	 * �û��� ���� ���� ����
	 * @param trialProductionReportVO
	 * @return
	 * @throws Exception
	 */
	public int updateTrialProductionReportState(TrialProductionReportVO trialProductionReportVO) throws Exception;
	
	/**
	 * �û��� ���� ����
	 * @param trialProductionReportVO
	 * @return
	 * @throws Exception
	 */
	public int deleteTrialProductionReport(TrialProductionReportVO trialProductionReportVO) throws Exception;
	
	/**
	 * �û��� ���� ī��Ʈ(Ư�� ��������)
	 * @param map
	 * @return int
	 * @throws Exception
	 */
	public int getTrialDocumentCnt(Map<String, Object> param);
}