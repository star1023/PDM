package kr.co.aspn.vo;

import java.util.ArrayList;
import java.util.Collections;

import lombok.Data;

@Data
public class LabPagingObject {
	private int countPerPage = 10;	// 기본적으로 페이지당 10개 항목
	private int totalCount;
	private int showPage = 1;		// 페이지는 특별한 설정이 없을 시 1페이지
	private ArrayList<Integer> pageBlock;
	private int pageBlockSize = 5;	// 기본적으로 페이지블록은 5개로 지정
	
	private String sortField;
	private String sortOrder;
	
	
	public int getTotalPage(){
		if(totalCount%countPerPage > 0){
			return (totalCount/countPerPage) + 1;
		} else {
			return (totalCount/countPerPage);
		}
	}

	public int getCountPerPage() {
		return countPerPage;
	}

	public void setCountPerPage(int countPerPage) {
		this.countPerPage = countPerPage;
	}

	public int getShowPage() {
		return showPage;
	}

	public void setShowPage(int showPage) {
		this.showPage = showPage;
	}

	public int getTotalCount() {
		return totalCount;
	}

	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
	}
	
	public String getSortField() {
		return sortField;
	}

	public void setSortField(String sortField) {
		this.sortField = sortField;
	}

	public String getSortOrder() {
		return sortOrder;
	}

	public void setSortOrder(String sortOrder) {
		this.sortOrder = sortOrder;
	}
	
	public boolean hasNext() {
		/*if(Math.ceil((showPage-1)/countPerPage)*countPerPage < Math.ceil(getTotalPage()/countPerPage)*countPerPage){
			return true;
		} else {
			return false;
		}*/
		
		if(Collections.max(getPageBlock()) < getTotalPage()){
			return true;
		} else {
			return false;
		}
	}

	public boolean hasPrev() {
		if(showPage >= (pageBlockSize+1)){
			return true;
		} else {
			return false;
		}
	}
	
	public ArrayList<Integer> getPageList(){
		ArrayList<Integer> pageList = new ArrayList<Integer>();
		
		int pageStart = (showPage-1)/pageBlockSize*pageBlockSize+1;
		int pageEnd = ((showPage-1)/pageBlockSize+1)*(pageBlockSize);
		if(pageEnd > getTotalPage()){
			pageEnd = getTotalPage();
		}
		
		for (int i = pageStart; i <= pageEnd; i++) {
			pageList.add(i);
		}
		
		return pageList;
	}
	
	public ArrayList<Integer> getPageBlock(){
		ArrayList<Integer> pageList = new ArrayList<Integer>();
		
		int pageStart = (showPage-1)/pageBlockSize*pageBlockSize+1;
		int pageEnd = ((showPage-1)/pageBlockSize+1)*(pageBlockSize);
		if(pageEnd > getTotalPage()){
			pageEnd = getTotalPage();
		}
		
		for (int i = pageStart; i <= pageEnd; i++) {
			pageList.add(i);
		}
		
		return pageList;
	}
}
