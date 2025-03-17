package kr.co.aspn.vo;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@EqualsAndHashCode(callSuper=false)
public class FileVO {
	private String fmNo				= "";		//첨부파일 고유번호
	private String tbKey			= "";		//문서 번호
	private String tbType			= "";		//문서 타입
	private String category			= "";		//파일 카테고리
	private String fileName 		= "";		//파일명
	private String oldFileName 		= "";
	private String orgFileName 		= "";		//원본 파일명
	private String path 			= "";		//파일 경로
	private String regUserId 		= "";		//작성자
	private String regDate 			= "";		//작성일
	private String isOld			= "";
	//private String[] fileDelete	;	//삭제한 파일
	}
