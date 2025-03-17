package kr.co.aspn.vo;
import java.util.Date;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ResultVO {
	public final static String SUCCESS = "success";
	public final static String FAIL = "fail";
	public final static String ERROR = "error";
	public final static String LOCK = "lock";

	private String status;
	private String code;
	private String msg;
	private String date;

	public ResultVO() {
		this.status = SUCCESS;
		this.code = "00";
		this.msg = "SUCCESS";
		setNowDate();
	}
	
	public ResultVO(String status) {
		this.status = status;
		if (SUCCESS.equals(status)) {
			this.code = "00";
			this.msg = "SUCCESS";
		} else if (FAIL.equals(status)) {
			this.code = "10";
			this.msg = "FAIL";
		} else if (LOCK.equals(status)){
			this.code = "20";
			this.msg = "LOCK";
		} else if (ERROR.equals(status)) {
			this.code = "99";
			this.msg = "ERROR";
		} else if ("exception".equals(status)) {
			this.code = "99";
			this.msg = "Exception";
		}
		setNowDate();
	}

	public ResultVO(String status, String msg) {
		this.status = status;
		this.msg = msg;
		if (FAIL.equals(status)) {
			this.code = "10";
		
		} else if (ERROR.equals(status)) {
			this.code = "99";
			this.msg = "ERROR";
		} else if ("exception".equals(status)) {
			this.code = "99";
		}
		setNowDate();
	}

	public ResultVO(String status, String code, String msg) {
		this.status = status;
		this.code = code;
		this.msg = msg;
		setNowDate();
	}
	
	public void setNowDate() {
		date = new Date().toString();
	}
}
