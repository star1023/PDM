package kr.co.aspn.util;

import java.io.UnsupportedEncodingException;
import java.util.Date;
import java.util.Properties;

import javax.activation.DataHandler;
import javax.activation.FileDataSource;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.mail.internet.MimeUtility;

public class MailUtil {
	
	private String receiver = "";
	private String message = "";
	private String filename = "";
	private String subject = "";

	private String mailtype = "";
	private String mailhost = "";
	private String mailer = "";
	private String sender = "";
	private String authId = "";
	private String authPasswd = "";
	private boolean useAuth = true;
	
	public MailUtil() {
	}

	public MailUtil(String mailType, String mailHost, String mailer, String sender, 
			boolean useAuth, String authId,String authPasswd) {
		setMailtype(mailType);
		setMailhost(mailHost);
		setMailer(mailer);
		setSender(sender);
		setUseAuth(useAuth);
		setAuthId(authId);
		setAuthPasswd(authPasswd);
	}
	
	public String getReceiver() {
		return receiver;
	}

	public void setReceiver(String receiver) {
		this.receiver = receiver;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public String getFilename() {
		return filename;
	}

	public void setFilename(String filename) {
		this.filename = filename;
	}

	public String getMailhost() {
		return mailhost;
	}

	public void setMailhost(String mailhost) {
		this.mailhost = mailhost;
	}

	public String getMailer() {
		return mailer;
	}

	public void setMailer(String mailer) {
		this.mailer = mailer;
	}

	public String getSender() {
		return sender;
	}

	public void setSender(String sender) {
		this.sender = sender;
	}

	public boolean isUseAuth() {
		return useAuth;
	}

	public void setUseAuth(boolean useAuth) {
		this.useAuth = useAuth;
	}

	public String getMailtype() {
		return mailtype;
	}

	public String getAuthId() {
		return authId;
	}

	public void setAuthId(String authId) {
		this.authId = authId;
	}

	public String getAuthPasswd() {
		return authPasswd;
	}

	public void setAuthPasswd(String authPasswd) {
		this.authPasswd = authPasswd;
	}

	public void setSubject(String str) {
		try {
			this.subject = MimeUtility.encodeText(str, this.mailtype, "B");
		} catch (UnsupportedEncodingException e) {
			this.subject = str;
		}
	}

	public void setMailtype(String mailtype) {
		this.mailtype = mailtype;
	}
	
	public boolean sendMail() {
		try {
			Session session;
			if (this.useAuth) {
				Properties props = System.getProperties();
				props.put("mail.smtp.auth", "true");
				props.put("mail.smtp.host", this.mailhost);

				Authenticator auth = new PclabAuthenticator(authId, authPasswd);
				session = Session.getInstance(props, auth);
			} else {
				Properties props = System.getProperties();
				props.put("mail.smtp.host", this.mailhost);
				session = Session.getDefaultInstance(props, null);
			}

			MimeMessage msg = new MimeMessage(session);

			msg.setFrom(new InternetAddress(this.sender));
			msg.setHeader("Content-Type", "text/html; charset=" + this.mailtype);

			msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(this.receiver, false));

			msg.setSubject(this.subject);
			msg.setSentDate(new Date());

			if (this.filename.equals("")) {
				msg.setContent(this.message, "text/html; charset=" + this.mailtype);
			} else {
				MimeBodyPart mbp1 = new MimeBodyPart();
				mbp1.setText(this.message, this.mailtype);
				mbp1.setHeader("Content-Type", "text/html; charset=" + this.mailtype);

				MimeBodyPart mbp2 = new MimeBodyPart();
				FileDataSource fds = new FileDataSource(this.filename);
				mbp2.setDataHandler(new DataHandler(fds));
				try {
					mbp2.setFileName(MimeUtility.encodeWord(fds.getName()));
				} catch (UnsupportedEncodingException localUnsupportedEncodingException) {
				}
				Multipart mp = new MimeMultipart();
				mp.addBodyPart(mbp1);
				mp.addBodyPart(mbp2);
				msg.setContent(mp);
			}

			msg.setHeader("X-Mailer", this.mailer);

			Transport.send(msg);
			return true;
		} catch (MessagingException e) {
			e.printStackTrace();
			return false;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}

}
