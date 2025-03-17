package kr.co.aspn.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.aspn.service.CodeManagementService;
import kr.co.aspn.util.StringUtil;
import kr.co.aspn.vo.CodeGroupVO;
import kr.co.aspn.vo.CodeItemVO;
import kr.co.aspn.vo.ResultVO;

@Controller
@RequestMapping("/code")
public class CodeManagementController {
	private Logger logger = LoggerFactory.getLogger(CodeManagementController.class);
	@Autowired
	CodeManagementService codeManagementService;
	
	@RequestMapping(value = "/groupList")
	public String getGroupList(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		//List<CodeMainVO> groupList = codeManagementService.getGroupList();
		//model.addAttribute("groupList",groupList);
		return "/code/groupList";
	}
	
	@RequestMapping(value = "/groupListAjax")
	@ResponseBody
	public List<CodeGroupVO> getGroupListAjax(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		List<CodeGroupVO> groupList = codeManagementService.getGroupList();
		return groupList;
	}
	
	@RequestMapping(value = "/popupGgroupInsertForm")
	public String groupInsertForm(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		return "/code/groupInsertForm";
	}
	
	@RequestMapping(value = "/gruopInsertAjax", method = RequestMethod.POST)
	@ResponseBody
	public ResultVO gruopInsertAjax(HttpServletRequest request, HttpServletResponse response, CodeGroupVO codeGroupVO) throws Exception {
		try {
			int count = codeManagementService.groupCount(codeGroupVO, request);
			if( count == 0 ) {
				codeManagementService.groupInsert(codeGroupVO, request);
			} else {
				return new ResultVO(ResultVO.FAIL, "동일한 코드값이 존재합니다.");				
			}
		} catch (Exception e) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			return new ResultVO(ResultVO.ERROR, e.getMessage());
		}
		return new ResultVO();
	}
	
	@RequestMapping(value = "/gruopUpdateAjax", method = RequestMethod.POST)
	@ResponseBody
	public ResultVO gruopUpdateAjax(HttpServletRequest request, HttpServletResponse response, CodeGroupVO codeGroupVO) throws Exception {
		try {
			int count = codeManagementService.groupCount(codeGroupVO, request);
			if( count == 1 ) {
				codeManagementService.groupUpdate(codeGroupVO, request);
			} else {
				return new ResultVO(ResultVO.FAIL, "해당 코드가 존재하지 않습니다.");				
			}
		} catch (Exception e) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			return new ResultVO(ResultVO.ERROR, e.getMessage());
		}
		return new ResultVO();
	}
	
	@RequestMapping(value = "/gruopDeleteAjax", method = RequestMethod.POST)
	@ResponseBody
	public ResultVO gruopDeleteAjax(HttpServletRequest request, HttpServletResponse response, CodeGroupVO codeGroupVO) throws Exception {
		try {
			int count = codeManagementService.groupCount(codeGroupVO, request);
			if( count == 1 ) {
				int itemCount = codeManagementService.groupItemCount(codeGroupVO, request);
				if( itemCount == 0 ) {
					codeManagementService.groupDelete(codeGroupVO, request);
				} else {
					return new ResultVO(ResultVO.FAIL, "코드아이템이 존재하여 삭제할 수 없습니다.");
				}
			} else {
				return new ResultVO(ResultVO.FAIL, "해당 코드가 존재하지 않습니다.");				
			}
		} catch (Exception e) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			return new ResultVO(ResultVO.ERROR, e.getMessage());
		}
		return new ResultVO();
	}
	
	@RequestMapping(value = "/itemList")
	public String itemList(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			model.addAttribute("groupCode", request.getParameter("groupCode"));
			return "/code/itemList";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping(value = "/itemListAjax")
	@ResponseBody
	public List<CodeItemVO> getItemListAjax(HttpServletRequest request, HttpServletResponse response, CodeItemVO codeItemVO) throws Exception {
		try {
			List<CodeItemVO> itemList = codeManagementService.getItemList(codeItemVO);
			return itemList;
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping(value = "/itemInsertAjax", method = RequestMethod.POST)
	@ResponseBody
	public ResultVO itemInsertAjax(HttpServletRequest request, HttpServletResponse response, CodeItemVO codeItemVO) throws Exception {
		try {
			int count = codeManagementService.itemCount(codeItemVO, request);
			if( count == 0 ) {
				codeManagementService.itemInsert(codeItemVO, request);
			} else {
				return new ResultVO(ResultVO.FAIL, "동일한 코드값이 존재합니다.");				
			}
		} catch (Exception e) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			return new ResultVO(ResultVO.ERROR, e.getMessage());
		}
		return new ResultVO();
	}
	
	@RequestMapping(value = "/itemUpdateAjax", method = RequestMethod.POST)
	@ResponseBody
	public ResultVO itemUpdateAjax(HttpServletRequest request, HttpServletResponse response, CodeItemVO codeItemVO) throws Exception {
		try {
			int count = codeManagementService.itemCount(codeItemVO, request);
			if( count == 1 ) {
				codeManagementService.itemUpdate(codeItemVO, request);
			} else {
				return new ResultVO(ResultVO.FAIL, "데이터가 없습니다. 다시 시도해주세요.");				
			}
		} catch (Exception e) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			return new ResultVO(ResultVO.ERROR, e.getMessage());
		}
		return new ResultVO();
	}
	
	@RequestMapping(value = "/itemDeleteAjax", method = RequestMethod.POST)
	@ResponseBody
	public ResultVO itemDeleteAjax(HttpServletRequest request, HttpServletResponse response, CodeItemVO codeItemVO) throws Exception {
		try {
			int count = codeManagementService.itemCount(codeItemVO, request);
			if( count == 1 ) {
				codeManagementService.itemOrderUpdate(codeItemVO, request);
				codeManagementService.itemDelete(codeItemVO, request);
			} else {
				return new ResultVO(ResultVO.FAIL, "데이터가 없습니다. 다시 시도해주세요.");				
			}
		} catch (Exception e) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			return new ResultVO(ResultVO.ERROR, e.getMessage());
		}
		return new ResultVO();
	}
	
	@RequestMapping(value = "/itemOrderUpdateAjax", method = RequestMethod.POST)
	@ResponseBody
	public ResultVO itemOrderUpdateAjax(HttpServletRequest request, HttpServletResponse response, CodeItemVO codeItemVO) throws Exception {
		try {
			int count = codeManagementService.itemCount(codeItemVO, request);
			if( count == 1 ) {
				//변경할 대상의 위,아래 아이템의 순서를 변경한다.
				codeManagementService.itemOrderUpDown(codeItemVO, request);				
				codeManagementService.itemOrderUpdateAjax(codeItemVO, request);
			} else {
				return new ResultVO(ResultVO.FAIL, "데이터가 없습니다. 다시 시도해주세요.");				
			}
		} catch (Exception e) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			return new ResultVO(ResultVO.ERROR, e.getMessage());
		}
		return new ResultVO();
	}
}
