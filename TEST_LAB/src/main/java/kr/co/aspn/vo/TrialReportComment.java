package kr.co.aspn.vo;

import lombok.Data;

@Data
public class TrialReportComment {

    private int cNo;                        // 코멘트번호
    private int rNo;                        // 문서번호(시생산보고서)
    private String writerUserId;            // 작성자ID
    private String writerUserName;          // 작성자 이름
    private String writerDeptCode;			// 작성자 부서
    private String writerDeptCodeName;		// 작성자 부서명
    private String writerTeamCode;          // 작성자 팀
    private String writerTeamCodeName;      // 작성자 팀명
    private String createDate;              // 생성일자
    private String writeDate;               // 작성일자
    private String writerComment;           // 내역
    private int isEditing;                  // 1:작성중, 0:작성완료
}
