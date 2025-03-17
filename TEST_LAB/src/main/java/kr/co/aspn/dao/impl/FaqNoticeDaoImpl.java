package kr.co.aspn.dao.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.aspn.dao.FaqNoticeDao;
import kr.co.aspn.service.LabDataService;
import kr.co.aspn.vo.NoticeVO;

@Repository("faqNoticeRepo")
public class FaqNoticeDaoImpl implements FaqNoticeDao{
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	@Autowired
	private LabDataService labDataService;
	
	@Override
	public List<Map<String, Object>> getPagenatedFaqNoticeList(HashMap<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("faq.getPagenatedFaqNoticeList", param);
	}

	@Override
	public Map<Object, Object> faqNoticeView(Object nNo) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("faq.getFaqNoticeView", nNo);
	}

	@Override
	public List<Map<Object, Object>> faqFileView(HashMap<Object, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("file.fileView", param);
	}

	@Override
	public void FaqnoticeDelete(HashMap<Object, Object> param) {
		// TODO Auto-generated method stub
		sqlSessionTemplate.delete("faq.FaqnoticeDelete", param);
		
	}

	@Override
	public void fileDeleteBytbKeytbType(HashMap<Object, Object> param) {
		sqlSessionTemplate.delete("file.fileDeleteBytbKeytbType", param);
	}

	@Override
	public int FaqnoticeSave(HashMap<Object, Object> param) {
		int max = 0;
		
		try {
		
			sqlSessionTemplate.insert("faq.noticeSave", param);
			max = labDataService.insertMax("faq");
		
		}catch(Exception e) {
			e.printStackTrace();
			max = -1;
		}
		return max;
	}	

	@Override
	public void fileSave(HashMap<Object, Object> param) {
		sqlSessionTemplate.insert("file.fileSave", param);
		
	}

	@Override
	public void FaqnoticeEdit(NoticeVO noticeVO) {
		sqlSessionTemplate.update("faq.FaqnoticeEdit", noticeVO);
		
	}

	@Override
	public void fileManagerFileDelete(HashMap<Object, Object> param) {
		sqlSessionTemplate.delete("file.fileManagerFileDelete", param);
		
	}

	@Override
	public Map<Object, Object> fileViewByFmNo(HashMap<Object, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("file.fileViewByFmNo", param);
	}

	@Override
	public int FaqNoticeListCount(HashMap<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("faq.FaqNoticeListCount", param);
	}






}
