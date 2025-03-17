package kr.co.aspn.util;

public class PclabAuthenticator extends javax.mail.Authenticator {
	private String id;
	private String pw;

	public PclabAuthenticator(String id, String pw) {
		this.id = id;
		this.pw = pw;
	}

	protected javax.mail.PasswordAuthentication getPasswordAuthentication() {
		return new javax.mail.PasswordAuthentication(id, pw);
	}
}
