package kr.co.aspn.service.impl;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.aspn.dao.CodeManagementDao;
import kr.co.aspn.service.CodeManagementService;
import kr.co.aspn.vo.CodeGroupVO;
import kr.co.aspn.vo.CodeItemVO;

@Service
public class CodeManagementServiceImpl implements CodeManagementService {
	@Autowired 
	CodeManagementDao codeManagementDao;
	
	@Override
	public List<CodeGroupVO> getGroupList() throws Exception {
		// TODO Auto-generated method stub
		return codeManagementDao.getGroupList();
	}

	@Override
	public int groupCount(CodeGroupVO codeGroupVO, HttpServletRequest request) throws Exception {
		// TODO Auto-generated method stub
		return codeManagementDao.groupCount(codeGroupVO);
	}

	@Override
	public void groupInsert(CodeGroupVO codeGroupVO, HttpServletRequest request) throws Exception {
		// TODO Auto-generated method stub
		codeManagementDao.groupInsert(codeGroupVO);
	}

	@Override
	public void groupUpdate(CodeGroupVO codeGroupVO, HttpServletRequest request) throws Exception {
		// TODO Auto-generated method stub
		codeManagementDao.groupUpdate(codeGroupVO);
	}

	@Override
	public void groupDelete(CodeGroupVO codeGroupVO, HttpServletRequest request) throws Exception {
		// TODO Auto-generated method stub
		codeManagementDao.groupDelete(codeGroupVO);
	}

	@Override
	public int groupItemCount(CodeGroupVO codeGroupVO, HttpServletRequest request) throws Exception {
		// TODO Auto-generated method stub
		return codeManagementDao.groupItemCount(codeGroupVO);
	}

	@Override
	public List<CodeItemVO> getItemList(CodeItemVO codeItemVO) throws Exception {
		// TODO Auto-generated method stub
		return codeManagementDao.getItemList(codeItemVO);
	}

	@Override
	public int itemCount(CodeItemVO codeItemVO, HttpServletRequest request) throws Exception {
		// TODO Auto-generated method stub
		return codeManagementDao.itemCount(codeItemVO);
	}

	@Override
	public void itemInsert(CodeItemVO codeItemVO, HttpServletRequest request) throws Exception {
		// TODO Auto-generated method stub
		codeManagementDao.itemInsert(codeItemVO);
	}

	@Override
	public void itemUpdate(CodeItemVO codeItemVO, HttpServletRequest request) throws Exception {
		// TODO Auto-generated method stub
		codeManagementDao.itemUpdate(codeItemVO);	
	}

	@Override
	public void itemOrderUpdate(CodeItemVO codeItemVO, HttpServletRequest request) throws Exception {
		// TODO Auto-generated method stub
		codeManagementDao.itemOrderUpdate(codeItemVO);
	}

	@Override
	public void itemDelete(CodeItemVO codeItemVO, HttpServletRequest request) throws Exception {
		// TODO Auto-generated method stub
		codeManagementDao.itemDelete(codeItemVO);
	}

	@Override
	public void itemOrderUpDown(CodeItemVO codeItemVO, HttpServletRequest request) throws Exception {
		// TODO Auto-generated method stub
		codeManagementDao.itemOrderUpDown(codeItemVO);
	}

	@Override
	public void itemOrderUpdateAjax(CodeItemVO codeItemVO, HttpServletRequest request) throws Exception {
		// TODO Auto-generated method stub
		codeManagementDao.itemOrderUpdateAjax(codeItemVO);
	}

}
