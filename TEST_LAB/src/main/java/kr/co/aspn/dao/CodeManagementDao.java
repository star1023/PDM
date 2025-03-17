package kr.co.aspn.dao;

import java.util.List;

import kr.co.aspn.vo.CodeGroupVO;
import kr.co.aspn.vo.CodeItemVO;

public interface CodeManagementDao {

	List<CodeGroupVO> getGroupList() throws Exception;

	int groupCount(CodeGroupVO codeGroupVO) throws Exception;

	void groupInsert(CodeGroupVO codeGroupVO) throws Exception;

	void groupUpdate(CodeGroupVO codeGroupVO) throws Exception;

	void groupDelete(CodeGroupVO codeGroupVO) throws Exception;

	int groupItemCount(CodeGroupVO codeGroupVO) throws Exception;

	List<CodeItemVO> getItemList(CodeItemVO codeItemVO) throws Exception;

	int itemCount(CodeItemVO codeItemVO) throws Exception;

	void itemInsert(CodeItemVO codeItemVO) throws Exception;

	void itemUpdate(CodeItemVO codeItemVO) throws Exception;

	void itemOrderUpdate(CodeItemVO codeItemVO) throws Exception;

	void itemDelete(CodeItemVO codeItemVO) throws Exception;

	void itemOrderUpDown(CodeItemVO codeItemVO) throws Exception;

	void itemOrderUpdateAjax(CodeItemVO codeItemVO) throws Exception ;

}
