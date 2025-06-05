<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <title>${notice.data.TITLE}</title>
<style>
    body {
        font-family: 'Malgun Gothic', sans-serif;
        background-color: #f7f7f7;
        margin: 0;
        padding: 0;
        color: #333;
    }

    /* 헤더 */
    .popup-header {
        background-color: #b32025;
        height: 50px;
        display: flex;
        align-items: center;
        padding: 0 20px;
    }

    .popup-header img {
        height: 40px;
    }

    .popup-container {
        background: #fff;
        border: 1px solid #ddd;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        max-width: 900px;
        margin: 20px 20px;
        padding: 30px 40px;
    }

	.popup-title {
	    display: flex;
	    justify-content: space-between;
	    align-items: center;
	    font-size: 24px;
	    font-weight: bold;
	    color: #222;
	    border-bottom: 2px solid #b92c35;
	    padding-bottom: 10px;
	    margin-bottom: 20px;
	}
	
	.notice-title {
	    cursor: pointer;
	    transition: color 0.2s;
	}
	.notice-title:hover {
	    color: #b92c35;
	}
	
	.more-icon {
	    display: flex;
	    flex-direction: column;
	    align-items: center;
	    font-size: 12px;
	    color: #888;
	    cursor: pointer;
	}
	.more-icon img {
	    width: 20px;
	    height: 20px;
	    margin-bottom: 2px;
	}
	.more-icon:hover {
	    color: #b92c35;
	}

    .popup-title .more-btn {
        cursor: pointer;
        display: flex;
        align-items: center;
        gap: 4px;
    }

    .popup-meta {
        font-size: 14px;
        color: #666;
        margin-bottom: 20px;
    }

    .popup-content {
        font-size: 16px;
        line-height: 1.8;
        white-space: pre-wrap;
    }

    .popup-footer {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-top: 30px;
    }

    .popup-footer label {
        font-size: 14px;
        color: #555;
    }

    .btn-close {
        background: #3c8dbc;
        color: white;
        border: none;
        padding: 8px 16px;
        font-size: 14px;
        border-radius: 4px;
        cursor: pointer;
    }

    .btn-close:hover {
        background: #337ab7;
    }
</style>
<script>
    function setCookie(name, value, hours) {
        const date = new Date();
        date.setTime(date.getTime() + (hours * 60 * 60 * 1000));
        document.cookie = name + "=" + value + ";expires=" + date.toUTCString() + ";path=/";
    }

    window.addEventListener("beforeunload", function () {
        if (document.getElementById("popupTodaySkip").checked) {
            const idx = new URLSearchParams(location.search).get("idx");
            setCookie("notice_skip_" + idx, "Y", 24); // 24시간 저장
        }
    });

    function goViewPage() {
        const idx = new URLSearchParams(location.search).get("idx");
        window.open("/boardNotice/view?idx=" + idx, "_blank");
    }
    
    function goToDetail() {
        const idx = new URLSearchParams(location.search).get("idx");
        window.open("/boardNotice/view?idx=" + idx, "_blank");
    }
</script>
</head>
<body>
    <!-- 🔴 헤더 영역 -->
    <div class="popup-header">
        <img src="/resources/images/bbq_logo.png" alt="BBQ Logo">
    </div>

    <!-- 📦 팝업 본문 -->
    <div class="popup-container">
		<div class="popup-title">
		    <span class="notice-title" onclick="goToDetail()">
		        ${notice.data.TITLE}
		    </span>
		    <div class="more-icon" onclick="goToDetail()">
		        <img src="/resources/images/icon_more.png" alt="돋보기" />
		        <div>More</div>
		    </div>
		</div>

        <div class="popup-meta">
            작성자: ${notice.data.REG_USER} | 등록일: ${notice.data.REG_DATE}
        </div>

        <div class="popup-content">
            ${notice.data.CONTENT}
        </div>

        <div class="popup-footer">
            <label>
                <input type="checkbox" id="popupTodaySkip"> 오늘 하루 보지 않기
            </label>
            <button class="btn-close" onclick="window.close()">닫기</button>
        </div>
    </div>
</body>
</html>
