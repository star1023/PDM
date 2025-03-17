package kr.co.aspn.dao.impl;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.aspn.dao.ReportDao;
import kr.co.aspn.vo.ApprovalHeaderVO;
import kr.co.aspn.vo.ApprovalItemVO;
import kr.co.aspn.vo.ApprovalLineHeaderVO;
import kr.co.aspn.vo.ApprovalLineInfoVO;
import kr.co.aspn.vo.ReportVO;

@Repository
public class ReportDaoImpl implements ReportDao {
	@Autowired
	SqlSessionTemplate sqlSessionTemplate;

	@Override
	public int reportCount(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("report.reportCount", param);
	}

	@Override
	public List<ReportVO> reportList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("report.reportList", param);
	}

	@Override
	public ReportVO reportData(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("report.reportData", param);
	}

	@Override
	public void insert(ReportVO reportVO) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("report.insert", reportVO);
	}

	/**
	 * 나중에 결재부분으로 이동
	 */
	@Override
	public void inserApprHeader(ApprovalHeaderVO apprvalHeaderVO) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("report.inserApprHeader", apprvalHeaderVO);
	}

	@Override
	public void inserApprLine(List<ApprovalItemVO> apprLineList) throws Exception {
		// TODO Auto-generated method stub
		for( int i = 0 ; i < apprLineList.size(); i++ ) {
			sqlSessionTemplate.insert("report.inserApprLine", apprLineList.get(i));
		}
	}

	@Override
	public void updateState(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("report.updateState", param);
	}

	@Override
	public void insertRefCirc(List<Map<String, Object>> refList) throws Exception {
		// TODO Auto-generated method stub
		for( int i = 0 ; i < refList.size(); i++ ) {
			sqlSessionTemplate.insert("report.insertRefCirc", refList.get(i));
		}
	}

	@Override
	public List<ApprovalItemVO> getAppr(String apprNo) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("report.getAppr", apprNo);
	}

	@Override
	public List<Map<String, Object>> getRef(String apprNo) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("report.getRef", apprNo);
	}

	@Override
	public void update(ReportVO reportVO) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("report.update", reportVO);
	}

		@Override
	public void delete(String rNo) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.delete("report.delete", rNo);
	}

	@Override
	public void insertReportBom(Map<String, Object> map) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("report.insertReportBom", map);
	}

	@Override
	public List<Map<String, Object>> reportBom(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("report.reportBom", param);
	}

	@Override
	public void deleteReportBom(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.delete("report.deleteReportBom", param);
	}

	@Override
	public void insertReportMix(Map<String, Object> map) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("report.insertReportMix", map);
	}

	@Override
	public void insertReportMixItem(Map<String, Object> map) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("report.insertReportMixItem", map);
	}
	
	@Override
	public void deleteReportMix(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.delete("report.deleteReportMix", param);
	}

	@Override
	public void deleteReportMixItem(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.delete("report.deleteReportMixItem", param);
	}

	@Override
	public List<Map<String, Object>> reportMix(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("report.reportMix", param);
	}

	@Override
	public List<Map<String, Object>> reportMixItem(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("report.reportMixItem", param);
	}
	
	@Override
	public List<Map<String, String>> getSubCategory(String category1) {
		return sqlSessionTemplate.selectList("report.getSubCategory", category1);
	}
}
