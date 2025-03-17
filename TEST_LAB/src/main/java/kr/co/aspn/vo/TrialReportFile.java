package kr.co.aspn.vo;

import lombok.Data;

@Data
public class TrialReportFile {
	private int fNo;
    private int rNo;
    private String gubun;       //사진: 10:완제품, 20:포장1, 30:포장2, 40:기타첨부이미지, 50~..:기타첨부파일
    private String fileName;
    private String orgFileName;
    private String path;
    private String regDate;
    private String regUserId;
    private String isDelete;    //Y:삭제, N:사용중
    
    // 추가 속성
    private String webUrl;
    private String regUserName;

}
