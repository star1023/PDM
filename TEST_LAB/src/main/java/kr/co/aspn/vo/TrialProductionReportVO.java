package kr.co.aspn.vo;

import lombok.Data;

@Data
//@ToString
//@NoArgsConstructor
//@AllArgsConstructor
public class TrialProductionReportVO {
	
	private int rNo;					// 일련번호
	private int docNo;					// 제품개발문서 일련번호
	private int docVersion;				// 문서 버전
	private int dNo;					// 제조공정서 번호
	private String line;				// 라인
	private String lineName;			// 라인명
	private String trialDate;			// 생산일
	private String devIntensity;		// 개발 강도 코드
	private String devIntensityName;	// 개발 강도 코드명
	private String result;				// 결과 코드
	private String resultName;			// 결과 코드명
	private String importantNote;		// 시생산 중요사항
	private int apprNo;					// 결재번호
	private String state;				// 상태코드
	private String stateName;			// 상태명
	private int fileCount;				// 첨부파일 개수
	private String createUser;			// 작성자 아이디
	private String createName;			// 작성자명
	private String createDate;			// 작성일
	private String changeUser;			// 수정자 아이디
	private String changeName;			// 수정자명
	private String changeDate;			// 수정일
	
	private String plantCode;			// 공장
	private String companyCode;			// 회사코드
	
}