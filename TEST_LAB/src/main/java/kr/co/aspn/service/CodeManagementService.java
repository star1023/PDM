package kr.co.aspn.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import kr.co.aspn.vo.CodeGroupVO;
import kr.co.aspn.vo.CodeItemVO;

public interface CodeManagementService {

	List<CodeGroupVO> getGroupList() throws Exception;

	int groupCount(CodeGroupVO codeMainVO, HttpServletRequest request) throws Exception;

	void groupInsert(CodeGroupVO codeMainVO, HttpServletRequest request) throws Exception;

	void groupUpdate(CodeGroupVO codeGroupVO, HttpServletRequest request) throws Exception;

	void groupDelete(CodeGroupVO codeGroupVO, HttpServletRequest request) throws Exception;

	int groupItemCount(CodeGroupVO codeGroupVO, HttpServletRequest request) throws Exception;

	List<CodeItemVO> getItemList(CodeItemVO codeItemVO) throws Exception;

	int itemCount(CodeItemVO codeItemVO, HttpServletRequest request) throws Exception;

	void itemInsert(CodeItemVO codeItemVO, HttpServletRequest request) throws Exception;

	void itemUpdate(CodeItemVO codeItemVO, HttpServletRequest request) throws Exception;

	void itemOrderUpdate(CodeItemVO codeItemVO, HttpServletRequest request) throws Exception;

	void itemDelete(CodeItemVO codeItemVO, HttpServletRequest request) throws Exception;

	void itemOrderUpDown(CodeItemVO codeItemVO, HttpServletRequest request) throws Exception;

	void itemOrderUpdateAjax(CodeItemVO codeItemVO, HttpServletRequest request) throws Exception;

}
