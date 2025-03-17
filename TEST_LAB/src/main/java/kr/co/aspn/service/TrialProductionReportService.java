package kr.co.aspn.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.multipart.MultipartFile;

import kr.co.aspn.vo.PlantLineVO;
import kr.co.aspn.vo.TrialProductionReportVO;

/**
 * ��ǰ���߹��� > �û��� ����
 * @author JAEOH
 */

public interface TrialProductionReportService {
	
	/**
	 * �û��� ���� ����Ʈ + ī��Ʈ
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> selectTrialProductionReportListAndCount(Map<String, Object> param) throws Exception;
	
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
	public Map<String, Object> selectTrialProductionReportDetail(Map<String, Object> param) throws Exception;
	
	/**
	 * �����ڵ� �̸� ��������
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public PlantLineVO selectLineDetailFromPlantLine(Map<String, Object> param) throws Exception;
	
	/**
	 * ÷������ ���
	 * @param rNo, files
	 * @return
	 * @throws Exception
	 */
	public boolean insertAttachFile(int rNo, List<MultipartFile> files) throws Exception;
	
	/**
	 * ÷������ ����
	 * @param rNo, fmNo, fileName
	 * @return
	 * @throws Exception
	 */
	public boolean deleteAttachFile(int rNo, int fmNo, String fileName) throws Exception;
	
	/**
	 * �û��� ���� ���
	 * @param trialProductionReportVO
	 * @return
	 * @throws Exception
	 */
	public boolean insertTrialProductionReport(TrialProductionReportVO trialProductionReportVO, HttpServletRequest request) throws Exception;
	
	/**
	 * �û��� ���� ����
	 * @param trialProductionReportVO
	 * @return
	 * @throws Exception
	 */
	public boolean updateTrialProductionReport(TrialProductionReportVO trialProductionReportVO, HttpServletRequest request) throws Exception;
	
	/**
	 * �û��� ���� ���� ����
	 * @param rNo
	 * @return
	 * @throws Exception
	 */
	public boolean updateTrialProductionReportState(TrialProductionReportVO trialProductionReportVO, HttpServletRequest request) throws Exception;
	
	/**
	 * �û��� ���� ����
	 * @param trialProductionReportVO
	 * @return
	 * @throws Exception
	 */
	public boolean deleteTrialProductionReport(int rNo) throws Exception;

	public int getTrialDocumentCnt(Map<String, Object> param);
}