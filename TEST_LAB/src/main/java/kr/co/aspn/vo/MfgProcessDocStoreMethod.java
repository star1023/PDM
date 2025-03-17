package kr.co.aspn.vo;

import lombok.Data;

@Data
public class MfgProcessDocStoreMethod {
	private String dSMNo;
	private String dNo;				// 문서번호  (제조공정서번호)
	private String docNo;			// 문서번호 제조공정서 (제품개발문서번호)
	private String docVersion;		// 문서버전
	private String methodName;		// 제조방법 명
	private String methodExplain;	// 제조방법 설명
	private String regDate;
	private String regUserId;
	private String modDate;
	private String modUserId;
	private String etc;
}
