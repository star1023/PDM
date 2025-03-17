package kr.co.aspn.dao.impl;

import kr.co.aspn.dao.TrialReportDao;
import kr.co.aspn.vo.TrialReportComment;
import kr.co.aspn.vo.TrialReportFile;
import kr.co.aspn.vo.TrialReportHeader;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.*;

/**
 * 제품개발문서 > 시생산 보고서
 * @author JAEOH
 */

@Repository
public class TrialReportDaoImpl implements TrialReportDao {
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	@Override
	public int trialReportCreate(TrialReportHeader trialProductionReportHeader){
		return sqlSessionTemplate.insert("trialReport.trialReportCreate",trialProductionReportHeader);
	}

	@Override
	public int trialReportCommentCreate(List<TrialReportComment> trialProductionReportComments){
		int resultCount  = 0;
		for(TrialReportComment c : trialProductionReportComments){
			resultCount += sqlSessionTemplate.insert("trialReport.trialReportCommentCreate",c);
		}
		return resultCount;
	}

	@Override
	public int changeTrialReportState(HashMap<String, Object> param){
		return sqlSessionTemplate.update("trialReport.changeTrialReportState",param);
	}

	@Override
	public int updateTrialReportProperty(HashMap<String, Object> param){
		return sqlSessionTemplate.update("trialReport.updateTrialReportProperty",param);
	}

	@Override
	public TrialReportHeader getTrialReportHeaderVO(String rNo){
		TrialReportHeader trialReportHeader = sqlSessionTemplate.selectOne("trialReport.getTrialReportHeader",rNo);
		if(trialReportHeader != null){
			List<TrialReportComment> trialReportComments = getTrialReportComment(rNo);
			trialReportHeader.setTrialReportComment(trialReportComments);
		}
		return trialReportHeader;
	}

	@Override
	public List<TrialReportComment> getTrialReportComment(String rNo){
		return sqlSessionTemplate.selectList("trialReport.getTrialReportComment", rNo);
	}

	@Override
	public List<TrialReportFile> getTrialReportFiles(String rNo){
		return sqlSessionTemplate.selectList("trialReport.getTrialReportFiles",rNo);
	}

	@Override
	public Map<String,Object> trialReportListCount(Map<String, Object> param){
		return sqlSessionTemplate.selectOne("trialReport.trialReportListCount",param);
	}

	@Override
	public List<Map<String,Object>> trialReportListPage(Map<String, Object> param){
		List<Map<String,Object>> list = sqlSessionTemplate.selectList("trialReport.trialReportListPage",param);
		if(list.size() > 0){
			HashSet<String> rNos = new HashSet<String>();
			for(Map<String,Object> item : list){
				rNos.add(item.get("rNo").toString());
			}
			Map<String,Object> rNosMap = new HashMap<String,Object>();
			rNosMap.put("rNos",rNos);
			List<Map<String,Object>> writedStatus = sqlSessionTemplate.selectList("trialReport.trialReportWritedStutes",rNosMap);
			for(Map<String,Object> item : list){
				for(Map<String,Object> status : writedStatus){
					// 230922 시생산보고서 작성단계가 0/0으로 표기되어 확인된 사항.
					if(item.get("rNo").equals(status.get("rNo"))){		// == 에서 equals로 수정 230922
						item.put("writedCount",status.get("writedCount"));
						item.put("totalCount",status.get("totalCount"));
						break;
					}
				}
			}
		}
		return list;
	}

	@Override
	public int saveTrialReportHeader(Map<String, Object> param){
		return sqlSessionTemplate.update("trialReport.saveTrialReportHeader",param);
	}

	@Override
	public int saveTrialReportComment(Map<String, Object> param){
		return sqlSessionTemplate.update("trialReport.saveTrialReportComment",param);
	}

	@Override
	public int insertTrialReportFile(TrialReportFile trialReportFile){
		return sqlSessionTemplate.insert("trialReport.insertTrialReportFile",trialReportFile);
	}

	@Override
	public int updateTrialReportFile(TrialReportFile trialReportFile){
		return sqlSessionTemplate.insert("trialReport.updateTrialReportFile",trialReportFile);
	}

	@Override
	public List<TrialReportHeader> trialReportListForDevDocDetail(Map<String, Object> param){
		return sqlSessionTemplate.selectList("trialReport.trialReportListForDevDocDetail",param);
	}

	@Override
	public int updateTrialReportCommentProperty(Map<String, Object> param){
		return sqlSessionTemplate.update("trialReport.updateTrialReportCommentProperty",param);
	}

	@Override
	public List<Map<String,Object>> getTrialReportAttachFiles(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectList("trialReport.getTrialReportAttachFiles", param);
	}
}