package kr.co.aspn.vo;

import java.util.List;

import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;

@Data
@EqualsAndHashCode(callSuper=false)
public class ReportVO {
	private int rNo;
	private int reportKey;
	private int apprNo;
	private String category1;
	private String category1Name;
	private String category2;
	private String category2Name;
	private String category3;
	private String category3Name;
	private String subCategory;
	private String subCategoryName;
	private String title = "";
	private String prdTitle = "";
	private String userName = "";
	private String deptName = "";
	private String regDate = "";
	private String regUserId = "";
	private String fileCount = "";
	private String reportDate = "";
	private String content = "";
	private String state = "";
	private String modUserId = "";
	private String adviserPrd = "";
	private String prdFeature = "";
	private String isConfirm = "";
	private String isConfirmText = "";
	private String isRelease = "";
	private String isReleaseText = "";
	private String result = "";
	private String developer = "";
	private String visitPurpose = "";
	private String visitPlace = "";
	private String visitUser = "";
	private String visitTime = "";
	private String isOld = "";
	private String oldCategory = "";
	private String oldCategoryName = "";
	private String testTitle = "";
	private String testPurpose = "";
	private String testDate = "";
	private String testObject = "";
	private String seminarTitle = "";
	private String seminarDate = "";
	private String seminarHost = "";
	private String seminarContent = "";
	private String regularTitle = "";
	
	
	List<ReportBom> bom;
}
