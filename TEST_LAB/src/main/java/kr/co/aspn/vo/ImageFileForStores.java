package kr.co.aspn.vo;

import lombok.Data;

@Data
public class ImageFileForStores {
	private int fNo;
	private String tbKey;			// 문서 번호 (제조공정서번호)
	private String tbType;			// 문서 타입
    private String gubun;       	// 10단위
    private String fileName;		// 파일명
    private String orgFileName; 	// 실제파일명
    private String path;			// 경로
    private String regDate;			// 등록일
    private String regUserId;		// 등록자
    private String isDelete;    	// Y:삭제, N:사용중
    private String imgDescript;		// 자신 설명
    
    // 추가 속성
    private String webUrl;
    private String regUserName;

}
