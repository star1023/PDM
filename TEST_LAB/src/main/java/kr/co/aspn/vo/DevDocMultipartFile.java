package kr.co.aspn.vo;

import org.springframework.web.multipart.MultipartFile;

public interface DevDocMultipartFile extends MultipartFile {
	String getFileType();
	String getFileTypeText();
}
