package kr.co.aspn.vo;

import lombok.Data;

import java.util.List;

@Data
public class TrialReportHeader {
	
	private int rNo;					// 문서번호
	private String startDate;			// 일시(시작일) 자재과 승인 일자
	private String endDate;				// 일시(종료일) 팀장 승인 일자
	private String createUser;			// 연구원: 생성 연구원 ID
	private String createName;			// 연구원: 생성 연구원 성함
	private String createDate;			// 생성일자
	private String docNo;				// 제품개발문서 일련번호
	private String docVersion;			// 문서 버전
	private String dNo;					// 제조공정서 번호
	private String line;				// 라인
	private String lineName;			// 라인명	*
	private String distChannel;			// 유통채널
	private String releasePlanDate;		// 출시일(목표)
	private String releaseRealDate;		// 출시일(가능)
	private String result;				// 시생산 결과 10:합격, 20:조건부 진행, 30:재실험, 40:불가
	private String resultName;			// 결과 코드명	*
	private int apprNo1;				// 자재과 결재 번호
	private int apprNo2;				// 팀장   결재 번호
	private String state;				// 보고서 상태: 00:생성, 10:1차결재 진행중, 20:1차결재 승인, 21:1차결재 반려, 30:작성중, 35:작성완료, 40:2차결재 진행중, 50:2차결재승인, 51:2차결재 반려
	private String stateName;			// 상태명	*
	private String reportTemplateNo;	// 보고서양식 번호
	private String reportTemplateName;	// 보고서양식 명칭
	private String changeUser;			// 수정자 아이디
	private String changeName;			// 수정자명
	private String changeDate;			// 수정일
	private int editLock;				//	0:작성가능, 1:작성불가
	private String reportContents;		// 레포트 body
	private String reportContentsAppr1;	// 1차 레포트

	
	// 작성자 의견
	private List<TrialReportComment> trialReportComment;

	// 추가 속성
	private String plantCode;			// 공장
	private String companyCode;			// 회사코드
	private String productName;			// 제품명
	
}