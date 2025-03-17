package kr.co.aspn.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@ToString
@NoArgsConstructor
@AllArgsConstructor
public class QAReportVO {
	
	private int rNo;
	private String title;
	private String content;
	private String category;
	private String categoryName;
	private String inspector;
	private String attendees;
	private String createUser;
	private String createName;
	private String createDate;
	private String changeUser;
	private String changeName;
	private String changeDate;
}