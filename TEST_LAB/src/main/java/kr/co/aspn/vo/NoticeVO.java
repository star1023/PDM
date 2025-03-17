package kr.co.aspn.vo;

import java.util.Arrays;

public class NoticeVO extends SearchVO{ 
	private String nNo			=		"";			// 공지사항 고유 번호	
	private String title		=		"";			// 공지사항명
	private String contents		=		"";			// 공지사항 내용
	private String regUserId	=		"";			// 작성자
	private String regUserNm 	=		"";			// 작성자 이름
	private String regDate		=		"";			// 작성일
	private String modUserId	=		"";			// 수정자
	private String modDate		=		"";			// 수정일
	private String rnum			=		"";
	private String fileDelete [];
	public String getnNo() {
		return nNo;
	}
	public void setnNo(String nNo) {
		this.nNo = nNo;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getContents() {
		return contents;
	}
	public void setContents(String contents) {
		this.contents = contents;
	}
	public String getRegUserId() {
		return regUserId;
	}
	public void setRegUserId(String regUserId) {
		this.regUserId = regUserId;
	}
	public String getRegUserNm() {
		return regUserNm;
	}
	public void setRegUserNm(String regUserNm) {
		this.regUserNm = regUserNm;
	}
	public String getRegDate() {
		return regDate;
	}
	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}
	public String getModUserId() {
		return modUserId;
	}
	public void setModUserId(String modUserId) {
		this.modUserId = modUserId;
	}
	public String getModDate() {
		return modDate;
	}
	public void setModDate(String modDate) {
		this.modDate = modDate;
	}
	public String getRnum() {
		return rnum;
	}
	public void setRnum(String rnum) {
		this.rnum = rnum;
	}
	public String[] getFileDelete() {
		return fileDelete;
	}
	public void setFileDelete(String[] fileDelete) {
		this.fileDelete = fileDelete;
	}
	@Override
	public String toString() {
		return "NoticeVO [nNo=" + nNo + ", title=" + title + ", contents=" + contents + ", regUserId=" + regUserId
				+ ", regUserNm=" + regUserNm + ", regDate=" + regDate + ", modUserId=" + modUserId + ", modDate="
				+ modDate + ", rnum=" + rnum + ", fileDelete=" + Arrays.toString(fileDelete) + "]";
	}

	
}
