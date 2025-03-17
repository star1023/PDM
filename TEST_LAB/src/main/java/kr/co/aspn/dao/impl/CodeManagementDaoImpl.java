package kr.co.aspn.dao.impl;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.aspn.dao.CodeManagementDao;
import kr.co.aspn.vo.CodeGroupVO;
import kr.co.aspn.vo.CodeItemVO;

@Repository
public class CodeManagementDaoImpl implements CodeManagementDao {
	@Autowired
	SqlSessionTemplate sqlSessionTemplate;
	
	@Override
	public List<CodeGroupVO> getGroupList() throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("code.groupList");
	}

	@Override
	public int groupCount(CodeGroupVO codeGroupVO) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("code.groupCount", codeGroupVO);
	}

	@Override
	public void groupInsert(CodeGroupVO codeGroupVO) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("code.groupInsert", codeGroupVO);
	}

	@Override
	public void groupUpdate(CodeGroupVO codeGroupVO) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("code.groupUpdate", codeGroupVO);
	}

	@Override
	public void groupDelete(CodeGroupVO codeGroupVO) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.delete("code.groupDelete", codeGroupVO);
	}

	@Override
	public int groupItemCount(CodeGroupVO codeGroupVO) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("code.groupItemCount", codeGroupVO);
	}

	@Override
	public List<CodeItemVO> getItemList(CodeItemVO codeItemVO) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("code.itemList",codeItemVO);
	}

	@Override
	public int itemCount(CodeItemVO codeItemVO) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("code.itemCount", codeItemVO);
	}

	@Override
	public void itemInsert(CodeItemVO codeItemVO) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("code.itemInsert", codeItemVO);
	}

	@Override
	public void itemUpdate(CodeItemVO codeItemVO) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("code.itemUpdate", codeItemVO);
	}

	@Override
	public void itemOrderUpdate(CodeItemVO codeItemVO) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("code.itemOrderUpdate", codeItemVO);
	}

	@Override
	public void itemDelete(CodeItemVO codeItemVO) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("code.itemDelete", codeItemVO);
	}

	@Override
	public void itemOrderUpDown(CodeItemVO codeItemVO) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("code.itemOrderUpDown", codeItemVO);
	}

	@Override
	public void itemOrderUpdateAjax(CodeItemVO codeItemVO) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("code.itemOrderUpdateAjax", codeItemVO);
	}

}
