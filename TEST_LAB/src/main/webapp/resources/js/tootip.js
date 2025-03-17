$(function(){
  var title_;
	var class_;
	var imgTag;

	$("a").hover(function(e) { 							// <a> hover �� : mouseEnter

		title_ = $(this).attr("title");				// title�� ������ ����
		class_ = $(this).attr("class");				// class�� ������ ����
		$(this).attr("title","");							// title �Ӽ� ���� ( �⺻ ���� ��� ���� )

		if(class_ == "img"){									// class_ �� img���,
			imgTag = "<img src='"+title_+"' width='100px' height:'100px' />"	// title_�� �ּҷ� ���� <img>�� ���� imgTag�� ����
		}

		$("body").append("<div id='tip'></div>");		// div#tip ����
																								// class_ ���� ���� �̹��� or �ؽ�Ʈ ��� ����
			if (class_ == "img") {
				$("#tip").html(imgTag);
				$("#tip").css("width","100px");
			} else {
				$("#tip").css("width","300px");
				$("#tip").text(title_);
			}

			var pageX = $(this).offset().left -20;
			var pageY = $(this).offset().top - $("#tip").innerHeight();
			$("#tip").css({left : pageX + "px", top : pageY + "px"}).fadeIn(10);

	}, function() {													// <a> hover �� : mouseLeave

		$(this).attr("title", title_);				// title �Ӽ� ��ȯ
		$("#tip").remove();										// div#tip ����

	});
});